From: Spelic <spelic@shiftmail.org>
Subject: on-off periodic hangs in scsi commands
Date: Wed, 05 Jan 2011 19:56:04 +0100
Message-ID: <4D24BEC4.7040906@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:62042 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1AESz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2011 13:55:58 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NW9YQQ7JEONG7WWX@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Wed, 05 Jan 2011 19:55:49 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NW9YQPWSBKNG7S68@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Wed, 05 Jan 2011 19:55:47 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: open-iscsi@googlegroups.com, scst-devel@lists.sourceforge.net

Hello
I am on kernel 2.6.36.2  (but I think I saw this problem also long time 
ago on 2.6.31)
I am having problems of greatly reduced throughput to scsi devices

Commands run for about 0.3 seconds and then are hanged for about 1.7 
seconds. Then run again for 0.3 seconds then are hanged again for 1.7 
and so on.
This is very recognizable by looking at iostat -x 1.
In the 1.7 seconds of freeze (actually with iostat you see 1 second of 
freeze) you can see a few outstanding writes. I saw either outstanding 
reads+writes or outstanding writes alone but I think I never saw 
outstanding reads alone. For these writes, completion is returned only 
after the pause (or so says blktrace...) . I am even wondering if this 
could be an interrupt serviced late...?

I saw this in two very different occasions: on 3ware with real disks, 
and now on iscsi against a ramdisk.

First case was with my 3ware 9650SE controller used as a SATA controller 
with MD on top of it: the problem happens with MD raid 5 doing e.g. 4k 
I/O O_DIRECT on it. You can read a detailed description in linux-raid 
mailing list
http://marc.info/?l=linux-raid&m=129377016700391&w=2
http://marc.info/?l=linux-raid&m=129377380202417&w=2
http://marc.info/?l=linux-raid&m=129422832802809&w=2
the last post is the most relevant, start from that one.

Initially I thought it was a bug of the 3ware controller, famous for not 
being fast / capable to handle high IOPS, however it's strange the 
problem does not happen on raid10 with a much higher throughput on same 
controller and same disks. The situation is similar because raid-5 in 
this case does not read (see last link) but it definitely only happens 
in raid5, and not in raid10, i tried lots of times.


Now I am seeing the same thing with open-iscsi over IPoIB against SCST 
backed by a ramdisk at the other side, so it's network, completely 
different beast, no disks involved (it's a linux ramdisk), on a 
completely different hardware for both client and server machines. The 
only thing these two iscsi servers have in common with the storage 
server (the one with the 3ware) is the type of CPUs: dual Xeon 5420. 
Mainboard also is different: supermicro for both computers in this case, 
tyan for the storage server.

Here is an excerpt of iostat -x 1 for the iscsi case, initiator side:
-----------------------------------------------------------------
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.00    0.00    0.00  100.00    0.00    0.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     
0.00   184.00    0.00   0.00 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.59    0.00   10.95   67.40    0.00   21.05

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdc              30.00 26676.00  934.00 5773.00 18912.00 258200.00    
41.32   153.98   51.05   0.15  98.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.00    0.00    0.15   83.89    0.00   15.96

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     
0.00   172.00    0.00   0.00 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.78    0.00   16.96   51.33    0.00   30.93

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdc              62.00 22410.00 1773.00 6236.00 35696.00 235392.00    
33.85   156.14   42.12   0.12 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.00    0.00    0.00   80.00    0.00   20.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     
0.00   138.00    0.00   0.00 100.00


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.19    0.00   15.03   61.41    0.00   23.38

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdc              19.00 21617.00  806.00 5303.00 13464.00 221096.00    
38.40   136.32   44.53   0.16  99.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.00    0.00    0.00   16.96    0.00   83.04

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     
0.00   152.00    0.00   0.00 100.00

-----------------------------------------------------------------

...off-on-off-on....

See what I mean?
"Top" says that all cpus are idle in the 1 second "off" period, 
synchronously for both at initiator side and target side. I can also say 
that the IPoIB network is practically stuck during transfer times, pings 
between the two machines do not pass, but it's totally idle in the still 
time, pings pass. At first I thought the network could have caused these 
problems but TCP retransmissions do not wait exactly 1 second, it's a 
too perfect synchronization to be a TCP problem. I have never seen a TCP 
transfer go fullspeed for 1 second then 0 bytes/sec for another second 
then fullspeed again for 1 second... it's not how TCP works.


Here is an iostat -x 1 with the real-disks on 3ware controller during:
dd if=/dev/zero of=/dev/mapper/datavg1-lvol0 bs=4K oflag=direct
(it is the same with oflag=direct,sync)

Note: I am keeping queue_depth at 1 with these controllers: they don't 
behave well with ncq.
Note2: it does not pass through a filesystem.

-------------------------------------------------
sdi               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdj               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     1.00    0.00   0.00 100.00   (*)
sdm               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdk               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdn               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
...[CUT]...
sdj               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00  448.00     0.00  3584.00     
8.00     0.99    4.42   2.21  99.00
sdm               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdk               0.00     0.00    0.00  448.00     0.00  3584.00     
8.00     0.03    0.07   0.07   3.00
sdn               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
...[CUT]...
sdj               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     1.00    0.00   0.00 100.00   (*)
sdm               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdk               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdn               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
...[CUT]...
sdj               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00  384.00     0.00  3072.00     
8.00     0.98    5.13   2.55  98.00
sdm               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdk               0.00     0.00    0.00  384.00     0.00  3072.00     
8.00     0.00    0.00   0.00   0.00
sdn               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
...[CUT]...
sdj               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     1.00    0.00   0.00 100.00   (*)
sdm               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdk               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdn               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
-------------------------------------------------

(*) <--- see the write stuck in these places... the dd write is sync so 
nothing else goes on until it has returned, and it does not return for 
one whole second, actually 1.7 seconds.

Now I can show you a blktrace for the real-disks on 3ware case:

Note: this is where I took the 0.3 -- 1.7 figure. For the iscsi case I 
am not sure of the exact timing but it also cycles every about 2 
seconds. The iscsi case drifts slowly so that after a few minutes is not 
in-sync anymore with iostat, then after a few more minutes it is again 
in-sync with iostat -x 1 and I could take some clear shots of the 
problem like in the iostat I pasted to you.


--------------------------------------------------
   8,240  2     1119     0.097304762  5319  I   W [kworker/u:1]
   8,240  2     1120     0.097305511  5319  C   W 0 [0]
   8,240  1     3333     0.097350168  1557  A   W 859034104 + 8 <- 
(8,241) 859032056
   8,240  1     3334     0.097350336  1557  Q   W 859034104 + 8 [md11_raid5]
   8,240  1     3335     0.097351193  1557  G   W 859034104 + 8 [md11_raid5]
   8,240  1     3336     0.097352168  1557  P   N [md11_raid5]
   8,240  1     3337     0.097352469  1557  I   W 859034104 + 8 [md11_raid5]
   8,240  1     3338     0.097359991  1557  U   N [md11_raid5] 1
   8,240  1     3339     0.097360743  1557  D   W 859034104 + 8 [md11_raid5]
   8,240  1     3340     0.097363489  1557  U   N [md11_raid5] 1
   8,240  1     3341     0.097464999     0  C   W 859034104 + 8 [0]
   8,240  1     3342     0.097494707  1557  U   N [md11_raid5] 0
   8,240  0     1116     0.097508456  5319  Q WBS [kworker/u:1]
   8,240  0     1117     0.097509015  5319  G WBS [kworker/u:1]
   8,240  0     1118     0.097509674  5319  P   N [kworker/u:1]
   8,240  0     1119     0.097509992  5319  I   W [kworker/u:1]
   8,240  0     1120     0.097510835  5319  C   W 0 [0]
   8,240  1     3343     0.097555058  1557  A   W 859034112 + 8 <- 
(8,241) 859032064
   8,240  1     3344     0.097555236  1557  Q   W 859034112 + 8 [md11_raid5]
   8,240  1     3345     0.097556090  1557  G   W 859034112 + 8 [md11_raid5]
   8,240  1     3346     0.097557062  1557  P   N [md11_raid5]
   8,240  1     3347     0.097557386  1557  I   W 859034112 + 8 [md11_raid5]
   8,240  1     3348     0.097564103  1557  U   N [md11_raid5] 1
   8,240  1     3349     0.097564957  1557  D   W 859034112 + 8 [md11_raid5]
   8,240  1     3350     0.097567754  1557  U   N [md11_raid5] 1
   8,240  1     3351     0.302256343  1557  U   N [md11_raid5] 1
   8,240  3     1117     1.999682436     0  C   W 859034112 + 8 [0] 
<--------- write completes only here after 1.7 secs
   8,240  2     1121     1.999737611  5319  Q WBS [kworker/u:1]
   8,240  2     1122     1.999738330  5319  G WBS [kworker/u:1]
   8,240  2     1123     1.999738907  5319  P   N [kworker/u:1]
   8,240  2     1124     1.999739262  5319  I   W [kworker/u:1]
   8,240  2     1125     1.999740107  5319  C   W 0 [0]
   8,240  3     1118     1.999792262  1557  A   W 859034120 + 8 <- 
(8,241) 859032072
   8,240  3     1119     1.999792413  1557  Q   W 859034120 + 8 [md11_raid5]
   8,240  3     1120     1.999793213  1557  G   W 859034120 + 8 [md11_raid5]
   8,240  3     1121     1.999794118  1557  P   N [md11_raid5]
   8,240  3     1122     1.999794422  1557  I   W 859034120 + 8 [md11_raid5]
   8,240  3     1123     1.999801199  1557  U   N [md11_raid5] 1
   8,240  3     1124     1.999801884  1557  D   W 859034120 + 8 [md11_raid5]
   8,240  3     1125     1.999804152  1557  U   N [md11_raid5] 1
   8,240  1     3352     1.999972330     0  C   W 859034120 + 8 [0]
   8,240  0     1121     2.000030768  5319  Q WBS [kworker/u:1]
   8,240  0     1122     2.000031333  5319  G WBS [kworker/u:1]

...[CUT]...

   8,240  2     2236     2.097562839  5319  Q WBS [kworker/u:1]
   8,240  2     2237     2.097563398  5319  G WBS [kworker/u:1]
   8,240  2     2238     2.097564060  5319  P   N [kworker/u:1]
   8,240  2     2239     2.097564381  5319  I   W [kworker/u:1]
   8,240  2     2240     2.097565242  5319  C   W 0 [0]
   8,240  1     6656     2.097613839  1557  A   W 859037688 + 8 <- 
(8,241) 859035640
   8,240  1     6657     2.097613995  1557  Q   W 859037688 + 8 [md11_raid5]
   8,240  1     6658     2.097614822  1557  G   W 859037688 + 8 [md11_raid5]
   8,240  1     6659     2.097615667  1557  P   N [md11_raid5]
   8,240  1     6660     2.097615929  1557  I   W 859037688 + 8 [md11_raid5]
   8,240  1     6661     2.097622654  1557  U   N [md11_raid5] 1
   8,240  1     6662     2.097623343  1557  D   W 859037688 + 8 [md11_raid5]
   8,240  1     6663     2.097625494  1557  U   N [md11_raid5] 1
   8,240  1     6664     2.097729515     0  C   W 859037688 + 8 [0]
   8,240  1     6665     2.097758720  1557  U   N [md11_raid5] 0
   8,240  0     2236     2.097772162  5319  Q WBS [kworker/u:1]
   8,240  0     2237     2.097772725  5319  G WBS [kworker/u:1]
   8,240  0     2238     2.097773386  5319  P   N [kworker/u:1]
   8,240  0     2239     2.097773705  5319  I   W [kworker/u:1]
   8,240  0     2240     2.097774617  5319  C   W 0 [0]
   8,240  1     6666     2.097823090  1557  A   W 859037696 + 8 <- 
(8,241) 859035648
   8,240  1     6667     2.097823331  1557  Q   W 859037696 + 8 [md11_raid5]
   8,240  1     6668     2.097824152  1557  G   W 859037696 + 8 [md11_raid5]
   8,240  1     6669     2.097824997  1557  P   N [md11_raid5]
   8,240  1     6670     2.097825247  1557  I   W 859037696 + 8 [md11_raid5]
   8,240  1     6671     2.097831340  1557  U   N [md11_raid5] 1
   8,240  1     6672     2.097832048  1557  D   W 859037696 + 8 [md11_raid5]
   8,240  1     6673     2.097834622  1557  U   N [md11_raid5] 1
   8,240  1     6674     2.302260290  1557  U   N [md11_raid5] 1
   8,240  3     2234     4.000203670     0  C   W 859037696 + 8 [0] 
<--------- write completes here
   8,240  2     2241     4.000256295  5319  Q WBS [kworker/u:1]
   8,240  2     2242     4.000256890  5319  G WBS [kworker/u:1]
   8,240  2     2243     4.000257477  5319  P   N [kworker/u:1]
   8,240  2     2244     4.000257832  5319  I   W [kworker/u:1]
   8,240  2     2245     4.000258659  5319  C   W 0 [0]
   8,240  3     2235     4.000311545  1557  A   W 859037704 + 8 <- 
(8,241) 859035656
   8,240  3     2236     4.000311677  1557  Q   W 859037704 + 8 [md11_raid5]
   8,240  3     2237     4.000312973  1557  G   W 859037704 + 8 [md11_raid5]
   8,240  3     2238     4.000313864  1557  P   N [md11_raid5]
   8,240  3     2239     4.000314120  1557  I   W 859037704 + 8 [md11_raid5]
   8,240  3     2240     4.000321038  1557  U   N [md11_raid5] 1
   8,240  3     2241     4.000321735  1557  D   W 859037704 + 8 [md11_raid5]
   8,240  3     2242     4.000323994  1557  U   N [md11_raid5] 1
   8,240  1     6675     4.000427558     0  C   W 859037704 + 8 [0]
   8,240  1     6676     4.000461787  1557  U   N [md11_raid5] 0
   8,240  0     2241     4.000476233  5319  Q WBS [kworker/u:1]
   8,240  0     2242     4.000476793  5319  G WBS [kworker/u:1]

...[CUT]...

   8,240  2     3516     4.111962898  5319  Q WBS [kworker/u:1]
   8,240  2     3517     4.111963472  5319  G WBS [kworker/u:1]
   8,240  2     3518     4.111964044  5319  P   N [kworker/u:1]
   8,240  2     3519     4.111964378  5319  I   W [kworker/u:1]
   8,240  2     3520     4.111965295  5319  C   W 0 [0]
   8,240  3     3804     4.112013696  1557  A   W 859033592 + 8 <- 
(8,241) 859031544
   8,240  3     3805     4.112013841  1557  Q   W 859033592 + 8 [md11_raid5]
   8,240  3     3806     4.112014653  1557  G   W 859033592 + 8 [md11_raid5]
   8,240  3     3807     4.112015874  1557  P   N [md11_raid5]
   8,240  3     3808     4.112016166  1557  I   W 859033592 + 8 [md11_raid5]
   8,240  3     3809     4.112024245  1557  U   N [md11_raid5] 1
   8,240  3     3810     4.112025141  1557  D   W 859033592 + 8 [md11_raid5]
   8,240  3     3811     4.112027938  1557  U   N [md11_raid5] 1
   8,240  1    10164     4.112131048  6493  C   W 859033592 + 8 [0]
   8,240  3     3812     4.112163132  1557  U   N [md11_raid5] 0
   8,240  0     3516     4.112174324  5319  Q WBS [kworker/u:1]
   8,240  0     3517     4.112174914  5319  G WBS [kworker/u:1]
   8,240  0     3518     4.112175476  5319  P   N [kworker/u:1]
   8,240  0     3519     4.112175795  5319  I   W [kworker/u:1]
   8,240  0     3520     4.112176739  5319  C   W 0 [0]
   8,240  3     3813     4.112221841  1557  A   W 859033600 + 8 <- 
(8,241) 859031552
   8,240  3     3814     4.112221952  1557  Q   W 859033600 + 8 [md11_raid5]
   8,240  3     3815     4.112222762  1557  G   W 859033600 + 8 [md11_raid5]
   8,240  3     3816     4.112223586  1557  P   N [md11_raid5]
   8,240  3     3817     4.112223901  1557  I   W 859033600 + 8 [md11_raid5]
   8,240  3     3818     4.112229650  1557  U   N [md11_raid5] 1
   8,240  3     3819     4.112230275  1557  D   W 859033600 + 8 [md11_raid5]
   8,240  3     3820     4.112232817  1557  U   N [md11_raid5] 1
   8,240  3     3821     4.312255629  1557  U   N [md11_raid5] 1
   8,240  3     3822     6.001904854     0  C   W 859033600 + 8 [0] 
<--------- write completes here
   8,240  3     3823     6.001944705  1557  U   N [md11_raid5] 0
   8,240  2     3521     6.001961244  5319  Q WBS [kworker/u:1]
   8,240  2     3522     6.001961855  5319  G WBS [kworker/u:1]
   8,240  2     3523     6.001962360  5319  P   N [kworker/u:1]
   8,240  2     3524     6.001962718  5319  I   W [kworker/u:1]
   8,240  2     3525     6.001963488  5319  C   W 0 [0]
   8,240  3     3824     6.002019367  1557  A   W 859033608 + 8 <- 
(8,241) 859031560
   8,240  3     3825     6.002019532  1557  Q   W 859033608 + 8 [md11_raid5]
   8,240  3     3826     6.002020332  1557  G   W 859033608 + 8 [md11_raid5]
   8,240  3     3827     6.002021283  1557  P   N [md11_raid5]
   8,240  3     3828     6.002021547  1557  I   W 859033608 + 8 [md11_raid5]
   8,240  3     3829     6.002028883  1557  U   N [md11_raid5] 1
   8,240  3     3830     6.002029497  1557  D   W 859033608 + 8 [md11_raid5]
   8,240  3     3831     6.002032017  1557  U   N [md11_raid5] 1
   8,240  1    10165     6.002174214     0  C   W 859033608 + 8 [0]
   8,240  0     3521     6.002243288  5319  Q WBS [kworker/u:1]
   8,240  0     3522     6.002248444  5319  G WBS [kworker/u:1]
--------------------------------------------------

You see how perfect is that? Hangs at exactly .30--.31 every time and 
restores after 1.7 seconds at or .00 +/-  about 500us !
Maybe it drifts very slowly like 500us at every cycle but it's almost 
perfectly synchronized...


Have you seen anything similar?

As I said, I think I saw this bug with XFS 2 years ago on the 
3.6.31-rcsomething with a MD raid-6 on the same 3ware.
So if it is a kernel bug it has been there for long

What do you think?


I am cc-ing the open-iscsi and scst people to see if they can suggest a 
way to debug the iscsi one. In particular it would be very interesting 
to get the number of commands received and replied from target side, and 
match it to the number of commands submitted from initiator side. (but I 
suspect these status variables do not exist) If target side says it has 
already replied, but initiator side sees the reply after 1 second... 
that would be very meaningful. The bad thing is that I do not have much 
time to debug this :-(


Thank you

