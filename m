From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: 2 KiB/block loopback found where
Date: 06 Oct 2003 18:51:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065487864.4521.52.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
	 <20030929164654.GS15415@suse.de>  <1064855570.3184.3.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:15755 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261771AbTJGAvL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 20:51:11 -0400
In-Reply-To: <1064855570.3184.3.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

Can I easily fix my --getss too?

$ sudo losetup /dev/loop0 dd.bin
$
$ dmesg | tail -2
loop: loaded (max 8 devices)
loop:to x800 from lo_blocksize = 0x1000
$
$ sudo blockdev --getss /dev/loop0
512
$ sudo blockdev --getbsz /dev/loop0
4096
$
$ sudo blockdev --getss /dev/scd0
2048
$ sudo blockdev --getbsz /dev/scd0
4096
$

I'm pleased to report, patching drivers/block/loop.c as suggested,
specifically via the patch quoted below, did confuse udf.ko as well with
a loop device as does my real 2 KiB/block device.

Certainly I could and did then relay details to
linux_udf@hpesjro.fc.hp.com in a thread titled "balloc free bit already
set and byte minus one".  But I'd of course like to make my loop device
as perfect a simulation of my real device as practical.  So I ask:

Can I easily fix my --getss too?

Pat LaVarre

diff -Nur linux-2.6.0-test6/drivers/block/loop.c linux/drivers/block/loop.c
--- linux-2.6.0-test6/drivers/block/loop.c	2003-09-27 18:50:29.000000000 -0600
+++ linux/drivers/block/loop.c	2003-10-06 18:06:20.447708984 -0600
@@ -732,7 +732,13 @@
 	mapping_set_gfp_mask(inode->i_mapping,
 			     lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 
+#if 0
 	set_blocksize(bdev, lo_blocksize);
+#else
+	printk(KERN_INFO "loop:"
+		"to x800 from lo_blocksize = 0x%X\n", lo_blocksize);
+	set_blocksize(bdev, 0x800);
+#endif
 
 	lo->lo_bio = lo->lo_biotail = NULL;


