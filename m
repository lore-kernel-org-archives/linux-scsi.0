From: Lincoln Dale <ltd@cisco.com>
Subject: RE: What's the "right" qla2100 driver?
Date: Thu, 22 Jan 2004 16:06:09 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20040122145815.02a6fe48@171.71.163.14>
References: <47F3C2BE74738E4683574107469DFA201DF5BF@XYUSEX01.xyus.xyrat
 ex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:17162 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S264267AbUAVFGR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 00:06:17 -0500
In-Reply-To: <47F3C2BE74738E4683574107469DFA201DF5BF@XYUSEX01.xyus.xyrat
 ex.com>
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: Poul Petersen <petersp@roguewave.com>, linux-scsi@vger.kernel.org

At 12:39 PM 22/01/2004, Frank Borich wrote:
>I heard the fc driver is bad.
>Has anyone experienced very poor performance when using MD- SCSI 
>mid-layer, and FC HBA?
>I create a 3 drive raid 5 array using MD, during initialization I get 50 + 
>MB/sec
>When I  write 00's using dd I get 3 MB/sec.  I can tell by using a fc 
>analyzer that my write commands
>are being chopped up into pieces.  Just wondering if anyone else has seen 
>this or knows of any issues using MD, and SCSI mid-layer, so I can shift 
>focus to FC side?  I lost all of my SCSI arrays! argh......

<shrug>

works ok here.  i wonder if you're realizing exactly how RAID5 works ...?:

Linux 2.6.2-rc1, using the QLogic driver that is integrated into the kernel 
with a QLA2300 attached to a Cisco MDS FC switch in turn connected to a FC 
JBOD with 8 x 15K RPM disks:

[root@mel-stglab-host31 linux]# head -2 /proc/scsi/qla2xxx/0
QLogic PCI to Fibre Channel Host Adapter for QLA2310:
         Firmware version 3.02.18 TPX, Driver version 8.00.00b8

constructing a 3-drive raid5 array (2 active 1 spare) using MD, i get 
~31MB/sec:
to 'create' a 3-disk RAID5 array requires reading the data off 2 disks to 
write the parity to the 3rd disk -- the overall speed of constructing a 
RAID5 array is limited by the performance of a single disk spindle.

         (output from mdstat)
         [root@mel-stglab-host31 root]# cat /proc/mdstat
         Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
         md0 : active raid5 sdg1[2] sdd1[1] sdb1[0]
               17498880 blocks level 5, 256k chunk, algorithm 2 [2/2] [UU]
               [==>..................]  resync = 10.5% (1852292/17498880) 
finish=8.5min speed=30369K/sec
         unused devices: <none>

         (output from my FC switch connected to this HBA showing the true 
i/o that is going on - both reads & writes):
         mel-stglab-mds9509-1# show interface fc2/9 | include rate
             5 minutes input rate 137039200 bits/sec, 17129900 bytes/sec, 
8709 frames/sec
             5 minutes output rate 347203424 bits/sec, 43400428 bytes/sec, 
21507 frames/sec

once the RAID5 array is built, i get ~44 MB/sec on a 'dd' -- once again, 
about the speed limit of a single disk spindle:

         [root@mel-stglab-host31 root]# time dd if=/dev/md0 of=/dev/null 
bs=256K count=4000
         4000+0 records in
         4000+0 records out

         real    0m22.639s
         user    0m0.020s
         sys     0m4.235s

if i do a 'dd' on one of the disk spindles that makes up the raid5 array, i 
get around the same number (actually, its a bit better: i get 57MB/sec - 
that is probably because ALL I/O is guaranteed to be sequential now):

         [root@mel-stglab-host31 root]# time dd if=/dev/sdg1 of=/dev/null 
bs=256K count=4000
         4000+0 records in
         4000+0 records out

         real    0m17.538s
         user    0m0.013s
         sys     0m2.698s


.... now, if i convert the RAID5 array to be a RAID0 array instead, its 
performance is much much better -- 105MB/sec:

         [root@mel-stglab-host31 root]# !mkraid
         mkraid --really-force /dev/md0
         DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
         handling MD device /dev/md0
         analyzing super-block
         disk 0: /dev/sdb1, 17499120kB, raid superblock at 17499008kB
         disk 1: /dev/sdd1, 17499120kB, raid superblock at 17499008kB
         disk 2: /dev/sdf1, 17775891kB, raid superblock at 17775808kB
         disk 3: /dev/sdg1, 17775891kB, raid superblock at 17775808kB
         [root@mel-stglab-host31 root]# cat /proc/mdstat
         Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
         md0 : active raid0 sdg1[3] sdf1[2] sdd1[1] sdb1[0]
               70548992 blocks 256k chunks

         unused devices: <none>
         [root@mel-stglab-host31 root]# time dd if=/dev/md0 of=/dev/null 
bs=256K count=4000
         4000+0 records in
         4000+0 records out

         real    0m9.557s
         user    0m0.013s
         sys     0m2.357s


cheers,

lincoln.

