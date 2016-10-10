#!/usr/bin/perl -W
$state=0;
if ($ARGV[0] eq "--head") {
    $head=1;
    shift @ARGV;
} else {
    $head=0;
}

if ($ARGV[0] eq "--data") {
    $data=1;
    shift @ARGV;
} else {
    $data=0;
}

sub trim {
    @ans=();
    foreach my $t (@_) {
        $t =~ s/^[ \t]*//;
        $t =~ s/[ \t]*$//;
        @ans=(@ans,$t);
    }
    return @ans;
}

foreach my $filename (@ARGV) {
    if ($filename =~ m/d([0-9]+)_g([0-9]+)/) {
        $d=$1;
        $g=$2;
        @head=("d","g");
        @data=($d,$g);
    }
    $state = 0;
    open IN, "<$filename";

    while (<IN>) {
       next if (m/^#/);
       chomp;
       if ($state == 0) {
           @head0=trim(split(/\|/,$_));
           @head0=(@head0,"d","g");
           $state = 1;
       } elsif ($state == 1) {
           @data0=trim(split(/\|/,$_));
           @data0=(@data0,$d,$g);
           $state = 2;
       } elsif ($state == 2) {
           @head1=trim(split(/\|/,$_));
           @head=(@head0,@head1);
           print join(",",@head) . "\n" if ($head);
           $state = 3;
       } elsif ($state == 3) {
           @data1=trim(split(/\|/,$_));
           @data=(@data0,@data1);
           print join(",",@data) . "\n" if ($data);
       }
   }
}
