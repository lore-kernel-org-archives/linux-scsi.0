From: Ricky Beam <jfbeam@bluetronic.net>
Subject: 3ware 9500 very slow
Date: Wed, 30 Jun 2004 13:28:54 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0406301301360.25702-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:32455 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S266767AbUF3RfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2004 13:35:12 -0400
Received: from localhost (jfbeam@localhost)
	by sweetums.bluetronic.net (8.11.7/8.11.7) with ESMTP id i5UHSs928840
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jun 2004 13:28:55 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>

[blockdev --report]
 RO    RA   SSZ   BSZ   StartSec     Size    Device
 rw   256   512  4096   78140160   15647310  /dev/sda2

 sda == 4 x WD 250G, RAID5, 64k stripe

3ware 9000 Storage Controller device driver for Linux v2.26.02.001.
ACPI: PCI interrupt 0000:06:03.0[A] -> GSI 24 (level, low) -> IRQ 217
scsi0 : 3ware 9000 Storage Controller
3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xfe8ffc00, IRQ: 217.
3w-9xxx: scsi0: Firmware FE9X 2.02.00.011, BIOS BE9X 2.02.01.037, Ports: 4.

[root@alpha5 root]# hdparm -f /dev/sda2 && time ./speed-buffered /dev/sda2

/dev/sda2:
Working with 8388608 byte buffered access buffer (128 16k stripes)
     7616.00 @  32.00
Blocks: 956 (  7.47GB)

real    4m11.553s
user    0m0.008s
sys     0m15.799s
[root@alpha5 root]# hdparm -f /dev/sda2 && time ./speed-direct /dev/sda2

/dev/sda2:
Working with 8388608 byte direct access buffer (128 16k stripes)
     7584.00 @  64.00
Blocks: 955 (  7.46GB)

real    2m15.744s
user    0m0.001s
sys     0m1.181s

That's usually the other way around...
I'll also add, this is slower than an 8506 in the same system.

And write performance is 2x that of reads.  Did someone forget to tell
the controller it has an SDRAM SODIMM it can use for read/write caching?

[root@alpha5 root]# time ./zero-direct /dev/sda2
Working with 8388608 byte direct access buffer (128 16k stripes)
     7616.00 @  72.00
Blocks: 956 (  7.47GB)

real    1m26.171s
user    0m0.001s
sys     0m0.930s

[root@alpha5 root]# time ./zero-buffered /dev/sda2
Working with 8388608 byte buffered access buffer (128 16k stripes)
     7616.00 @  40.00
Blocks: 956 (  7.47GB)

real    5m11.709s
user    0m0.015s
sys     0m25.315s

--Ricky


