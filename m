From: "Joe Eiler" <joe@eiler.net>
Subject: Re: 3ware 9500 very slow
Date: Fri, 2 Jul 2004 20:10:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <029101c4609a$7a123460$0300000a@joe>
References: <Pine.GSO.4.33.0406301301360.25702-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host01.ipowerweb.com ([12.129.206.101]:15525 "EHLO
	host01.ipowerweb.com") by vger.kernel.org with ESMTP
	id S265692AbUGCBHv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2004 21:07:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: Ricky Beam <jfbeam@bluetronic.net>, Linux SCSI List <linux-scsi@vger.kernel.org>

If you have write cache enabled, the writes will be faster.

If your biggest concern is sequential reads, try increasing your read ahead
> blockdev --setra 4096 /dev/sda

And bump up nr_requests to something bigger than the card supports(254), so
linux gets a chance optimize the ordering a little
> echo "512" > /sys/block/sda/queue/nr_requests

Joe


----- Original Message ----- 
From: "Ricky Beam" <jfbeam@bluetronic.net>
To: "Linux SCSI List" <linux-scsi@vger.kernel.org>
Sent: Wednesday, June 30, 2004 12:28 PM
Subject: 3ware 9500 very slow


[blockdev --report]
 RO    RA   SSZ   BSZ   StartSec     Size    Device
 rw   256   512  4096   78140160   15647310  /dev/sda2

 sda == 4 x WD 250G, RAID5, 64k stripe

3ware 9000 Storage Controller device driver for Linux v2.26.02.001.
ACPI: PCI interrupt 0000:06:03.0[A] -> GSI 24 (level, low) -> IRQ 217
scsi0 : 3ware 9000 Storage Controller
3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xfe8ffc00, IRQ:
217.
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


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


