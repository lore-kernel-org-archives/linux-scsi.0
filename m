From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix up short inquiry printing
Date: Sun, 06 Aug 2006 18:15:22 -0500
Message-ID: <1154906122.3683.244.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:55504 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750763AbWHFXPa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Aug 2006 19:15:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>

A recent drivers base commit:

3e95637a48820ff8bedb33e6439def96ccff1de5

Caused the bus to be added to dev_printk, so now our SCSI inquiry short
messages print like this:

scsiscsi 2:0:0:0: Direct access     IBM-ESXS ST973401SS       B519 PQ: 0 ANSI: 5

Just remove the "scsi" from the sdev_printk to compensate.

James

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1803994..114e206 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -659,7 +659,7 @@ static int scsi_add_lun(struct scsi_devi
 	if (inq_result[7] & 0x10)
 		sdev->sdtr = 1;
 
-	sdev_printk(KERN_NOTICE "scsi", sdev, "%s %.8s %.16s %.4s PQ: %d "
+	sdev_printk(KERN_NOTICE, sdev, "%s %.8s %.16s %.4s PQ: %d "
 			"ANSI: %d%s\n", scsi_device_type(sdev->type),
 			sdev->vendor, sdev->model, sdev->rev,
 			sdev->inq_periph_qual, inq_result[2] & 0x07,


