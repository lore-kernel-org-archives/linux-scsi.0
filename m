From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] Re: libata:  BLKFLSBUF ioctl broken
Date: Fri, 22 Oct 2004 13:07:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41793E68.6010000@pobox.com>
References: <4178244E.1060906@rtr.ca> <20041022040423.GA28782@havoc.gtf.org> <41791728.7060106@rtr.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010901050902070105030502"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:4782 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265773AbUJVRIF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 13:08:05 -0400
In-Reply-To: <41791728.7060106@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>

This is a multi-part message in MIME format.
--------------010901050902070105030502
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Mark Lord wrote:
> Try issuing a BLKFLSBUF to a SATA drive.
> As of 2.6.9 this apparently returns EOPNOTSUPP to userspace.

Ok, I think I see what's going on.  Can you get your users to try the 
attached patch?

Maybe libata should be returning ENOTTY, but that's _quite_ nonsensical 
considering that EOPNOTSUPP describes the error much better (and is a 
standard I-don't-support-that-operation return code in tons of other 
Linux ioctl-handling code).


> I don't have any libata controllers here to try it with.

You mean you don't have an Intel PATA controller lying around 
anywhere???  :)  To enable Intel PATA controllers, set the 
ATA_ENABLE_PATA define in include/linux/libata.h, and recompile the 
ata_piix driver:

#undef ATA_DEBUG                /* debugging output */
#undef ATA_VERBOSE_DEBUG        /* yet more debugging output */
#undef ATA_IRQ_TRAP             /* define to ack screaming irqs */
#undef ATA_NDEBUG               /* define to disable quick runtime checks */
#undef ATA_ENABLE_ATAPI         /* define to enable ATAPI support */
#undef ATA_ENABLE_PATA          /* define to enable PATA support in some
                                  * low-level drivers */
#undef ATAPI_ENABLE_DMADIR      /* enables ATAPI DMADIR bridge support */

--------------010901050902070105030502
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== drivers/block/ioctl.c 1.62 vs edited =====
--- 1.62/drivers/block/ioctl.c	2004-10-03 00:05:10 -04:00
+++ edited/drivers/block/ioctl.c	2004-10-22 13:06:16 -04:00
@@ -195,7 +195,8 @@
 		if (disk->fops->ioctl) {
 			ret = disk->fops->ioctl(inode, file, cmd, arg);
 			/* -EINVAL to handle old uncorrected drivers */
-			if (ret != -EINVAL && ret != -ENOTTY)
+			if (ret != -EINVAL && ret != -ENOTTY &&
+			    ret != -EOPNOTSUPP)
 				return ret;
 		}
 		fsync_bdev(bdev);

--------------010901050902070105030502--
