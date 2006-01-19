From: "Martin W. Schlining III" <mschlining@datadirectnet.com>
Subject: How do I Improve Large Sequential Read Performance to a SCSI Block
 Device?
Date: Thu, 19 Jan 2006 16:00:44 -0500
Message-ID: <43CFFDFC.9020003@datadirectnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postoffice.datadirectnet.com ([64.213.193.141]:32433 "EHLO
	postoffice.datadirectnet.com") by vger.kernel.org with ESMTP
	id S1161421AbWASVAB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 16:00:01 -0500
Received: from localhost (localhost [127.0.0.1])
	by postoffice.datadirectnet.com (Postfix) with ESMTP id 403873516C53
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2006 12:59:45 -0800 (PST)
Received: from postoffice.datadirectnet.com ([127.0.0.1])
 by localhost (postoffice.datadirectnet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 10348-03 for <linux-scsi@vger.kernel.org>;
 Thu, 19 Jan 2006 12:59:43 -0800 (PST)
Received: from [127.0.0.1] (ddneng.com [70.88.130.31])
	by postoffice.datadirectnet.com (Postfix) with ESMTP id 009B3381FDB5
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2006 12:59:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

How do I improve read performance for large sequential IO to a SCSI 
block device
on Linux? In most (if not all) "out of the box" Linux distros, write 
performance
far exceeds read performance for large sequential IO to a block device. 
However,
read and write performance are about equal using a character device 
(sg). The IO
using a character device is larger and more commands are sent to the SCSI
device.

What kind of tuning parameters or patches should be done to improve 
sequential
read performance? Should I be using a different IO elevator or none at 
all? Is
my block device doing direct IO? How would I know?

I have not been able to find a good solution in any searches.

Here are my system details:

SCSI device:
DataDirect Networks S2A9500 Controller (FC-4) w/ 4 TB of FC disks.
LUN 0 - 4 TB w/ 512 byte block size

Computer:
Dell 2850 Server Dual Xeon 3.00 GHz
1G Memory
2 Emulex Dual LP11000 HBAs (Driver 8.0.13), only using one FC Port.
racerx:/proc/scsi # lsscsi -vvg
 sysfsroot: /sys
[0:0:0:0]    disk    SEAGATE  ST336754LC       D402  /dev/sda  /dev/sg0
  dir: /sys/bus/scsi/devices/0:0:0:0  
[/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:05.0/host0/target0:0:0/0:0:0:0]
[0:0:6:0]    process PE/PV    1x6 SCSI BP      1.0   -         /dev/sg1
  dir: /sys/bus/scsi/devices/0:0:6:0  
[/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:05.0/host0/target0:0:6/0:0:6:0]
[9:0:0:0]    disk    DDN      S2A 9500         3.00  /dev/sdb  /dev/sg2
  dir: /sys/bus/scsi/devices/9:0:0:0  
[/sys/devices/pci0000:00/0000:00:06.0/0000:08:00.2/0000:0a:03.1/host9/target9:0:0/9:0:0:0]

OS:
Suse 9.3 x84-64 w/ updates
racerx:~ # uname -a
Linux racerx 2.6.11.4-21.10-smp #1 SMP Tue Nov 29 14:32:49 UTC 2005 
x86_64 x86_64 x86_64 GNU/Linux
Emulex driver version 8.0.13 (not the latest, but good performance can 
be achieved)
No file system is used to test the SCSI device.

Looking at /dev/sdb parameters:

racerx:/sys/block/sdb/queue # ls
.   iosched            max_sectors_kb  read_ahead_kb
..  max_hw_sectors_kb  nr_requests     scheduler
racerx:/sys/block/sdb/queue # cat scheduler
noop [anticipatory] deadline cfq
racerx:/sys/block/sdb/queue # cat max_sectors_kb
512
racerx:/sys/block/sdb/queue # cat read_ahead_kb
128
racerx:/sys/block/sdb/queue # cat max_hw_sectors_kb
512
racerx:/sys/block/sdb/queue # cat nr_requests
128
racerx:/sys/block/sdb/queue # cd ..
racerx:/sys/block/sdb # ls
.  ..  dev  device  queue  range  removable  sdb1  size  stat
racerx:/sys/block/sdb # cat size
9175695360
racerx:/sys/block/sdb # cat range
16
racerx:/sys/block/sdb # cat stat
41800102 1120178689 707930979 242236415 14078051 1138277748 625707891 
310226730        0 42758380 552574197

I figure these might be the tuning parameters I'm looking for. But there 
may be
others as well. I have an idea of what may work, but I'd like to hear 
from the
experts. What kinds of numbers should I use to increase large sequential 
read
performace? How do I make these numbers persistent?

Tests and results:

Read performance using the block device (/dev/sdb):

Using the command:
sgp_dd if=/dev/sdb of=/dev/null bs=512 bpt=4096 time=1 thr=6 
count=100000000 dio=1

BTW: The dio=1 flag really does not affect the results to the block device.

I'm asking for 2M transfers.

S2A 9500[1]: stats length

                         Command Length Statistics

 Length        Port 1            Port 2            Port 3            Port 4
 Kbytes    Reads   Writes    Reads   Writes    Reads   Writes    Reads   
Writes
 >    0        0        0        0        0        0        0        
0        0
 >   16        0        0        0        0        0        0        
0        0
 >   32        0        0        0        0        0        0        
0        0
 >   48        0        0        0        0        0        0        
0        0
 >   64        0        0        0        0        0        0        
0        0
 >   80        0        0        0        0        0        0        
0        0
 >   96        0        0        0        0        0        0        
0        0
 >  112        0        0        0        0        0        0        
0        0
 >  128        0        0        0        0        0        0        
0        0
 >  144        0        0        0        0        0        0        
0        0
 >  160        0        0        0        0        0        0        
0        0
 >  176        0        0        0        0        0        0        
0        0
 >  192        0        0        0        0        0        0        
0        0
 >  208        0        0        0        0        0        0        
0        0
 >  224        0        0        0        0        0        0        
0        0
 >  240        0        0        0        0        0        0        
0        0
 >  256     17F0        0        0        0        0        0        
0        0
S2A 9500[1]: stats

                          System Performance Statistics
                All Ports     Port 1     Port 2     Port 3     Port 4
  Read  MB/s:      145.9      145.9        0.0        0.0        0.0
  Write MB/s:        0.0        0.0        0.0        0.0        0.0
  Total MB/s:      145.9      145.9        0.0        0.0        0.0

  Read  IO/s:        583        583          0          0          0
  Write IO/s:          0          0          0          0          0
  Total IO/s:        583        583          0          0          0

  Read Hits:       100.0%     100.0%       0.0%       0.0%       0.0%
  Prefetch Hits:   100.0%     100.0%       0.0%       0.0%       0.0%
  Prefetches:       20.0%      20.0%       0.0%       0.0%       0.0%
  Writebacks:        0.0%       0.0%       0.0%       0.0%       0.0%
  Rebuild MB/s:      0.0        0.0                   0.0
  Verify MB/s:       0.0        0.0                   0.0

                    Total      Reads     Writes
  Disk IO/s:          145        145          0
  Disk MB/s:        163.9      163.9        0.0
  Disk Pieces:       1869       1869          0
  BDB Pieces:                      0

   Cache Writeback Data:     0.0%
   Rebuild/Verify Data:      0.0%    0.0%
   Cache Data locked:        0.0%
S2A 9500[1]:

Taking snapshots of outstanding Host IO from the S2A9500 only shows a 
max of 1
small (256K) command outstanding at any point in time. There's alot of 
idle time
here.

Write performance using the block device:

Using the command:
sgp_dd if=/dev/zero of=/dev/sdb bs=512 bpt=4096 time=1 thr=6 
count=100000000 dio=1

S2A 9500[1]: stats length

                         Command Length Statistics

 Length        Port 1            Port 2            Port 3            Port 4
 Kbytes    Reads   Writes    Reads   Writes    Reads   Writes    Reads   
Writes
 >    0        0        8        0        0        0        0        
0        0
 >   16        0        0        0        0        0        0        
0        0
 >   32        0        0        0        0        0        0        
0        0
 >   48        0        0        0        0        0        0        
0        0
 >   64        0        0        0        0        0        0        
0        0
 >   80        0        0        0        0        0        0        
0        0
 >   96        0        0        0        0        0        0        
0        0
 >  112        0        0        0        0        0        0        
0        0
 >  128        0        0        0        0        0        0        
0        0
 >  144        0        0        0        0        0        0        
0        0
 >  160        0        0        0        0        0        0        
0        0
 >  176        0        0        0        0        0        0        
0        0
 >  192        0        0        0        0        0        0        
0        0
 >  208        0        0        0        0        0        0        
0        0
 >  224        0        0        0        0        0        0        
0        0
 >  240        0        0        0        0        0        0        
0        0
 >  384        0        A        0        0        0        0        
0        0
 >  400        0        5        0        0        0        0        
0        0
 >  416        0        B        0        0        0        0        
0        0
 >  432        0        B        0        0        0        0        
0        0
 >  448        0       11        0        0        0        0        
0        0
 >  464        0       11        0        0        0        0        
0        0
 >  480        0       10        0        0        0        0        
0        0
 >  496        0       14        0        0        0        0        
0        0
 >  512        0     56EA        0        0        0        0        
0        0
S2A 9500[1]: stats

                          System Performance Statistics
                All Ports     Port 1     Port 2     Port 3     Port 4
  Read  MB/s:        0.0        0.0        0.0        0.0        0.0
  Write MB/s:      385.9      385.9        0.0        0.0        0.0
  Total MB/s:      385.9      385.9        0.0        0.0        0.0

  Read  IO/s:          0          0          0          0          0
  Write IO/s:        772        772          0          0          0
  Total IO/s:        772        772          0          0          0

  Read Hits:         0.0%       0.0%       0.0%       0.0%       0.0%
  Prefetch Hits:     0.0%       0.0%       0.0%       0.0%       0.0%
  Prefetches:        0.0%       0.0%       0.0%       0.0%       0.0%
  Writebacks:      100.0%     100.0%       0.0%       0.0%       0.0%
  Rebuild MB/s:      0.0        0.0                   0.0
  Verify MB/s:       0.0        0.0                   0.0

                    Total      Reads     Writes
  Disk IO/s:           30          0         30
  Disk MB/s:        432.1        0.0      432.1
  Disk Pieces:      12414          0      12414
  BDB Pieces:                      0

   Cache Writeback Data:     7.4%
   Rebuild/Verify Data:      0.0%    0.0%
   Cache Data locked:        0.0%

Still did not get 2M IO, but the command sizes are larger (mostly 512K) and
there are usually 16 commands outstanding on the S2A9500 at any one time.

Read performance using the character device (/dev/sg2):

Using the command:
racerx:~ # sgp_dd if=/dev/sg2 of=/dev/null bs=512 bpt=4096 time=1 thr=6 
count=100000000 dio=1
time to transfer data was 125.323676 secs, 408.54 MB/sec
100000000+0 records in
100000000+0 records out
 >> Direct IO requested but incomplete 24415 times
 >>> /proc/scsi/sg/allow_dio set to '0' but should be set to '1' for 
direct IO

Interesting message. Was I actually getting direct IO? Should I set
/proc/scsi/sg/allow_dio to 1? How do I make that persistent?

S2A 9500[1]: stats length

                         Command Length Statistics

 Length        Port 1            Port 2            Port 3            Port 4
 Kbytes    Reads   Writes    Reads   Writes    Reads   Writes    Reads   
Writes
 >    0        0        0        0        0        0        0        
0        0
 >   16        0        0        0        0        0        0        
0        0
 >   32        0        0        0        0        0        0        
0        0
 >   48        0        0        0        0        0        0        
0        0
 >   64        0        0        0        0        0        0        
0        0
 >   80        0        0        0        0        0        0        
0        0
 >   96        0        0        0        0        0        0        
0        0
 >  112        0        0        0        0        0        0        
0        0
 >  128        0        0        0        0        0        0        
0        0
 >  144        0        0        0        0        0        0        
0        0
 >  160        0        0        0        0        0        0        
0        0
 >  176        0        0        0        0        0        0        
0        0
 >  192        0        0        0        0        0        0        
0        0
 >  208        0        0        0        0        0        0        
0        0
 >  224        0        0        0        0        0        0        
0        0
 >  240        0        0        0        0        0        0        
0        0
 > 2048      B34        0        0        0        0        0        
0        0
S2A 9500[1]: stats

                          System Performance Statistics
                All Ports     Port 1     Port 2     Port 3     Port 4
  Read  MB/s:      389.9      389.9        0.0        0.0        0.0
  Write MB/s:        0.0        0.0        0.0        0.0        0.0
  Total MB/s:      389.9      389.9        0.0        0.0        0.0

  Read  IO/s:        194        194          0          0          0
  Write IO/s:          0          0          0          0          0
  Total IO/s:        194        194          0          0          0

  Read Hits:       100.0%     100.0%       0.0%       0.0%       0.0%
  Prefetch Hits:   100.0%     100.0%       0.0%       0.0%       0.0%
  Prefetches:       50.0%      50.0%       0.0%       0.0%       0.0%
  Writebacks:        0.0%       0.0%       0.0%       0.0%       0.0%
  Rebuild MB/s:      0.0        0.0                   0.0
  Verify MB/s:       0.0        0.0                   0.0

                    Total      Reads     Writes
  Disk IO/s:          194        194          0
  Disk MB/s:        438.5      438.5        0.0
  Disk Pieces:       6306       6306          0
  BDB Pieces:                      0

   Cache Writeback Data:     0.0%
   Rebuild/Verify Data:      0.0%    0.0%
   Cache Data locked:        0.0%

We got 2M reads and the S2A9500 shows between 5 and 6 2M commands 
outstanding on
the S2A9500 at any time.

Write performance using the character device (/dev/sg2):

Using the command:
racerx:~ # sgp_dd if=/dev/zero of=/dev/sg2 bs=512 bpt=4096 time=1 thr=6 
count=100000000 dio=1
time to transfer data was 125.809450 secs, 406.96 MB/sec
100000000+0 records in
100000000+0 records out
 >> Direct IO requested but incomplete 24415 times
 >>> /proc/scsi/sg/allow_dio set to '0' but should be set to '1' for 
direct IO

S2A 9500[1]: stats length

                         Command Length Statistics

 Length        Port 1            Port 2            Port 3            Port 4
 Kbytes    Reads   Writes    Reads   Writes    Reads   Writes    Reads   
Writes
 >    0        0        0        0        0        0        0        
0        0
 >   16        0        0        0        0        0        0        
0        0
 >   32        0        0        0        0        0        0        
0        0
 >   48        0        0        0        0        0        0        
0        0
 >   64        0        0        0        0        0        0        
0        0
 >   80        0        0        0        0        0        0        
0        0
 >   96        0        0        0        0        0        0        
0        0
 >  112        0        0        0        0        0        0        
0        0
 >  128        0        0        0        0        0        0        
0        0
 >  144        0        0        0        0        0        0        
0        0
 >  160        0        0        0        0        0        0        
0        0
 >  176        0        0        0        0        0        0        
0        0
 >  192        0        0        0        0        0        0        
0        0
 >  208        0        0        0        0        0        0        
0        0
 >  224        0        0        0        0        0        0        
0        0
 >  240        0        0        0        0        0        0        
0        0
 > 2048        0      877        0        0        0        0        
0        0
S2A 9500[1]: stats

                          System Performance Statistics
                All Ports     Port 1     Port 2     Port 3     Port 4
  Read  MB/s:        0.0        0.0        0.0        0.0        0.0
  Write MB/s:      387.8      387.8        0.0        0.0        0.0
  Total MB/s:      387.8      387.8        0.0        0.0        0.0

  Read  IO/s:          0          0          0          0          0
  Write IO/s:        194        194          0          0          0
  Total IO/s:        194        194          0          0          0

  Read Hits:         0.0%       0.0%       0.0%       0.0%       0.0%
  Prefetch Hits:     0.0%       0.0%       0.0%       0.0%       0.0%
  Prefetches:        0.0%       0.0%       0.0%       0.0%       0.0%
  Writebacks:      100.0%     100.0%       0.0%       0.0%       0.0%
  Rebuild MB/s:      0.0        0.0                   0.0
  Verify MB/s:       0.0        0.0                   0.0

                    Total      Reads     Writes
  Disk IO/s:           30          0         30
  Disk MB/s:        437.5        0.0      437.5
  Disk Pieces:       4932          0       4932
  BDB Pieces:                      0

   Cache Writeback Data:     8.1%
   Rebuild/Verify Data:      0.0%    0.0%
   Cache Data locked:        0.0%

Same as the reads. 2M IO and between 5 and 6 commands outstanding on the 
S2A9500
at any time.

Any ideas would be appreciated,
Martin Schlining
mschlining@datadirectnet.com










