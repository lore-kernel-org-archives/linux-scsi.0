From: Jan Engelhardt <jengelh@medozas.de>
Subject: Large amount of scsi-sgpool objects
Date: Tue, 3 Mar 2009 02:28:51 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54104 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZCCB2y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 20:28:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi,


I am noticing that there are a lot of objects active after a few tens 
minutes of running xfs_fsr.

$ slabtop
  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
818616 818616 100%    0.16K  34109       24    136436K sgpool-8
253692 253692 100%    0.62K  42282        6    169128K sgpool-32
 52017  52016  99%    2.50K  17339        3    138712K sgpool-128
 26220  26219  99%    0.31K   2185       12      8740K sgpool-16
  8927   8574  96%    0.03K     79      113       316K size-32

$ uname -a
Linux yaguchi 2.6.29-rc6-rt #1 SMP PREEMPT RT 2009-02-19 23:12:33 
+0100 i686 athlon i386 GNU/Linux

What could be the problem that there are so many objects around and not 
freed? This makes the system pretty much unusable after a while as it 
runs towards a low-memory condition.

$ free
             total       used       free     shared    buffers     cached
Mem:        766592     758688       7904          0          0     137184
-/+ buffers/cache:     621504     145088
Swap:       795136         32     795104


$ cat /proc/meminfo 
MemTotal:         766592 kB
MemFree:           79388 kB
Buffers:               0 kB
Cached:            62120 kB
SwapCached:         1428 kB
Active:            74472 kB
Inactive:         113524 kB
Active(anon):      58228 kB
Inactive(anon):    69124 kB
Active(file):      16244 kB
Inactive(file):    44400 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:             0 kB
HighFree:              0 kB
LowTotal:         766592 kB
LowFree:           79388 kB
SwapTotal:        795136 kB
SwapFree:         792404 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:        124440 kB
Mapped:            13672 kB
Slab:             478576 kB
SReclaimable:       5316 kB
SUnreclaim:       473260 kB
PageTables:         1220 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1178432 kB
Committed_AS:   4294655912 kB
VmallocTotal:     245816 kB
VmallocUsed:       27404 kB
VmallocChunk:     197108 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:      696256 kB
DirectMap4M:       90112 kB
