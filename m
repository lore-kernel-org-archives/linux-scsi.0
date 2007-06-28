From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Some NCQ numbers...
Date: Thu, 28 Jun 2007 14:51:58 +0400
Message-ID: <468392CE.6010206@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[Offtopic notice: For the first time I demonstrated some
speed testing results on linux-ide mailinglist, as a
demonstration how [NT]CQ can help.  But later, someone
becomes curious and posted that email to lkml, asking
for more details.  Since that, I become more curious
as well, and decided to look at it more closely.
Here it goes...]

A test drive is Seagate Barracuda ST3250620AS "desktop" drive,
250Gb, cache size is 16Mb, 7200RPM.

The same results shows Seagate Barracuda ES drive, ST3250620NS.

I guess pretty similar results will be fore larger Barracudas from
Seagate.  The only difference between 250Gb ones and larger ones is
the amount of disk platters and heads.

Test machine was using MPTSAS driver for the following card:
  SCSI storage controller: LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT SAS (rev 02)

Pretty similar results were obtained on an AHCI controller:
  SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controller AHCI (rev 01)
on another machines.


The following tables shows data read/write speed in Megabytes/sec,
with different parameters.

All I/O performed directly on the whole drive, i.e.
open("/dev/sda", O_RDWR|O_DIRECT).

There are 5 kinds of tests were performed: linear read (linRd),
random read (rndRd), linear write (linWr), random write (rndWr),
and a combination of random read and write (rndR/W).

Each test has been tried with 1 (2 in case of r/w), 4 and 32 threads
doing I/O in parallel (Trd column).  Linear read and writes were
performed only for single thread.

Two modes for each test -- with command queuing enabled (qena) and
disabled (qdis), using /sys/block/sda/device/queue_depth, by setting
queue depth to 31 (default) and 1 respectively.

And finally, each set of tests were performed for different block sizes --
4, 8, 16, 32, 128 and 1024 kb (1 kb = 1024 bytes).


First, tests with write cache enabled (factory default settings for the
drives in question):

BlkSz Trd   linRd       rndRd     linWr       rndWr           rndR/W
           qena qdis  qena qdis  qena qdis  qena qdis     qena      qdis
   4k   1  12.8 12.8   0.3  0.3  35.4 37.0   0.5  0.5   0.2/ 0.2  0.2/ 0.2
        4              0.3  0.3              0.5  0.5   0.2/ 0.2  0.2/ 0.1
       32              0.3  0.4              0.5  0.5   0.2/ 0.2  0.2/ 0.1
   8k   1  23.4 23.4   0.6  0.6  51.5 51.2   1.0  1.0   0.4/ 0.4  0.4/ 0.4
        4              0.6  0.6              1.0  1.0   0.4/ 0.4  0.4/ 0.2
       32              0.6  0.8              1.0  1.0   0.4/ 0.4  0.4/ 0.2
  16k   1  41.1 40.3   1.2  1.2  67.4 67.8   2.0  2.0   0.7/ 0.7  0.7/ 0.7
        4              1.2  1.1              2.0  2.0   0.7/ 0.7  0.8/ 0.4
       32              1.2  1.6              2.0  2.0   0.7/ 0.7  0.9/ 0.4
  32k   1  58.6 57.6   2.2  2.2  79.1 70.9   3.8  3.7   1.4/ 1.4  1.4/ 1.4
        4              2.3  2.2              3.8  3.7   1.4/ 1.4  1.6/ 0.8
       32              2.3  3.0              3.7  3.8   1.4/ 1.4  1.7/ 0.9
  128k  1  80.4 80.4   8.1  8.0  78.7 77.3  11.6 11.6   4.5/ 4.5  4.5/ 4.5
        4              8.1  8.0             11.4 11.3   4.6/ 4.6  5.5/ 2.8
       32              8.1  9.2             11.3 11.4   4.7/ 4.6  5.7/ 3.0
 1024k  1  80.4 80.4  33.9 34.0  78.2 78.3  33.6 33.6  15.9/15.9 15.9/15.9
        4             34.5 34.8             33.5 33.3  16.4/16.3 17.2/11.8
       32             34.5 34.5             33.5 35.8  20.6/11.3 21.4/11.6


And second, the same drive with write caching disabled (WCE=0, hdparm -W0):

BlkSz Trd   linRd       rndRd     linWr       rndWr           rndR/W
           qena qdis  qena qdis  qena qdis  qena qdis     qena      qdis
   4k   1  12.8 12.8   0.3  0.3   0.4  0.5   0.3  0.3   0.2/ 0.2  0.2/ 0.2
        4              0.3  0.3              0.3  0.3   0.2/ 0.2  0.2/ 0.1
       32              0.3  0.4              0.3  0.4   0.2/ 0.1  0.2/ 0.1
   8k   1  24.6 24.6   0.6  0.6   0.9  0.9   0.6  0.6   0.3/ 0.3  0.3/ 0.3
        4              0.6  0.6              0.6  0.5   0.3/ 0.3  0.4/ 0.2
       32              0.6  0.8              0.6  0.8   0.3/ 0.3  0.4/ 0.2
  16k   1  41.8 41.7   1.2  1.1   1.8  1.8   1.1  1.1   0.6/ 0.6  0.6/ 0.6
        4              1.2  1.1              1.1  1.0   0.6/ 0.6  0.8/ 0.4
       32              1.2  1.5              1.1  1.6   0.6/ 0.6  0.8/ 0.4
  32k   1  60.1 59.2   2.3  2.3   3.6  3.5   2.1  2.1   1.1/ 1.1  1.1/ 1.1
        4              2.3  2.2              2.1  2.0   1.1/ 1.1  1.5/ 0.7
       32              2.3  2.9              2.1  3.0   1.1/ 1.1  1.5/ 0.8
 128k   1  79.4 79.4   8.1  8.1  12.4 12.6   7.2  7.1   3.8/ 3.8  3.8/ 3.8
        4              8.1  7.9              7.2  7.1   3.8/ 3.8  5.2/ 2.6
       32              8.1  9.0              7.2  7.8   3.9/ 3.8  5.2/ 2.7
1024k   1  79.0 79.4  33.8 33.8  34.2 34.1  24.6 24.6  14.3/14.2 14.3/14.2
        4             33.9 34.3             24.7 24.8  14.4/14.2 15.9/11.1
       32             34.0 34.3             24.7 27.6  19.3/10.4 19.3/10.4



Two immediate conclusions.

First, NCQ on this combination of drive/controller/driver DOES NOT WORK.
Without write cache on the drive, the results are pretty much the same
whenever NCQ is enabled or not (modulo some random fluctuations).  With
write cache enabled, NCQ leads to the drive starts "preferring" reads over
writes in combined R/W test, but summary thougoutput stays the same.

And second, write cache doesn't seem to help, at least not for a busy
drive.  Yes it helps *alot* for sequential writes, but definitely not
for random writes, which stays the same whenever write cache is turned
on or not.  Again: this is a "busy" drive, which has no idle time to
complete queued writes since new requests are coming and coming -- for
not-so-busy drive write caching should help to made the whole system
more "responsive".

I don't have other models of SATA drives around.

I'm planning to test several models of SCSI drives.  On SCSI front
(or maybe with different drives - I don't know) things are WAY more
interesting wrt TCQ.  Difference in results between 1 and 32 threads
goes up to 4 times sometimes!.  But I'm a bit stuck with SCSI tests
since I don't know how to turn off TCQ without rebooting a machine.

Note that the results are NOT interesting for a "typical" workload,
where you work with filesystem (file server, compiling a kernel etc).
The test is more a (synthetic) database workload with direct I/O and
relatively small block sizes.

As a test, I used a tiny program I wrote especially for this purpose,
available at http://www.corpit.ru/mjt/iot.c .  Please note that I
never used threads before, and since this program runs several
threads, it needs some syncronisations between them, and I'm not
sure I got it right, but at least it seems to work... ;)  So if
anyone can offer correction to this area, you're welcome!

The program (look into it for instructions) performs a single test.
In order to build a table like the above, I had to run it multiple
times, and collect the results into a nicely-looking table.  I wont
show you a script I used for that, because it's way too specific
for my system (particular device names etc), and it's just too ugly
(a quick hack).  Instead, here is a simpler, but more generally
useful one, to test single drive in single mode as I posted
previously: http://www.corpit.ru/mjt/iot.sh .

/mjt
