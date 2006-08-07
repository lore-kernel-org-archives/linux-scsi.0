From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] fix up short inquiry printing
Date: Sun, 6 Aug 2006 20:46:12 -0600
Message-ID: <20060807024612.GJ4379@parisc-linux.org>
References: <1154906122.3683.244.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43435 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750924AbWHGCqO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Aug 2006 22:46:14 -0400
Content-Disposition: inline
In-Reply-To: <1154906122.3683.244.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Aug 06, 2006 at 06:15:22PM -0500, James Bottomley wrote:
> Caused the bus to be added to dev_printk, so now our SCSI inquiry short
> messages print like this:
> 
> scsiscsi 2:0:0:0: Direct access     IBM-ESXS ST973401SS       B519 PQ: 0 ANSI: 5
> 
> Just remove the "scsi" from the sdev_printk to compensate.

Yes, that's clearly the right thing to do, thanks for fixing that up.

I think we should probably switch sdev_printk() to its own custom
implementation rather than just calling dev_printk().  Greg didn't seem
to be interested in fixing the problem that we have with dev_printk();
presumably he has some other users in mind for which the current
dev_printk behaviour is useful.

How does something like the following look (compile tested):

Index: include/scsi/scsi_device.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/scsi/scsi_device.h,v
retrieving revision 1.28
diff -u -p -r1.28 scsi_device.h
--- include/scsi/scsi_device.h	19 May 2006 02:43:19 -0000	1.28
+++ include/scsi/scsi_device.h	7 Aug 2006 02:45:24 -0000
@@ -151,10 +151,10 @@ struct scsi_device {
 	to_scsi_device(class_dev->dev)
 
 #define sdev_printk(prefix, sdev, fmt, a...)	\
-	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
+	printk(prefix "scsi %s: " fmt, (sdev)->sdev_gendev.bus_id , ## a)
 
 #define scmd_printk(prefix, scmd, fmt, a...)	\
-	dev_printk(prefix, &(scmd)->device->sdev_gendev, fmt, ##a)
+	sdev_printk(prefix, (scmd)->device, fmt, ##a)
 
 enum scsi_target_state {
 	STARGET_RUNNING = 1,
