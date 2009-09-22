From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [2.6.31] Memory leak in SCSI initialization?
Date: Tue, 22 Sep 2009 23:13:14 +1000
Message-ID: <1253625194.5923.10.camel@concordia>
References: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
Reply-To: michael@ellerman.id.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:57112 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276AbZIVNNL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2009 09:13:11 -0400
In-Reply-To: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 13:18 +0900, Tetsuo Handa wrote:
> Hello.
> 
> I can see below message appears for 15 times in
> /sys/kernel/debug/kmemleak after processing /init inside initramfs.
> 
> unreferenced object 0xdeadb5c8 (size 32):
>   comm "insmod", pid 543, jiffies 4294674766
>   backtrace:
>     [<c048a22c>] create_object+0x135/0x202
>     [<c048a31e>] kmemleak_alloc+0x25/0x49
>     [<c04865d9>] kmemleak_alloc_recursive+0x1c/0x22
>     [<c0486d33>] __kmalloc+0x6c/0xb9
>     [<c04f5675>] kvasprintf+0x2d/0x4a
>     [<c04ef5af>] kobject_set_name_vargs+0x21/0x50
>     [<c054bbd7>] dev_set_name+0x1a/0x1c
>     [<e08dc1b7>] scsi_sysfs_device_initialize+0x8b/0xe4 [scsi_mod]
>     [<e08d9bbf>] scsi_alloc_sdev+0x134/0x18f [scsi_mod]
>     [<e08d9e7a>] scsi_probe_and_add_lun+0x107/0xa98 [scsi_mod]
>     [<e08da946>] __scsi_scan_target+0x70/0x4b1 [scsi_mod]
>     [<e08dadbe>] scsi_scan_channel+0x37/0x60 [scsi_mod]
>     [<e08dae9f>] scsi_scan_host_selected+0xb8/0xf1 [scsi_mod]
>     [<e08daf2c>] do_scsi_scan_host+0x54/0x5d [scsi_mod]
>     [<e08db2ef>] scsi_scan_host+0x14d/0x165 [scsi_mod]
>     [<e0959771>] mptspi_probe+0x2cd/0x2f8 [mptspi]

I think this will fix it:

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9ce5c34..284bcbe 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -957,7 +957,7 @@ static inline void scsi_destroy_sdev(struct scsi_device *sdev)
        if (sdev->host->hostt->slave_destroy)
                sdev->host->hostt->slave_destroy(sdev);
        transport_destroy_device(&sdev->sdev_gendev);
-       put_device(&sdev->sdev_gendev);
+       put_device(&sdev->sdev_dev);
 }
 
 #ifdef CONFIG_SCSI_LOGGING


sdev_dev has class == sdev_class. The release function for sdev_class is
scsi_device_cls_release(), and _that_ does a put on the sdev_gendev.

But someone who groks all that mess, er beauty ;D, should check that
makes sense.

cheers

