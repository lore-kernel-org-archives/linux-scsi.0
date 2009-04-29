From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 2/4] sd: fix printk() levels
Date: Wed, 29 Apr 2009 22:07:59 +0200
Message-ID: <200904292207.59465.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42027 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZD2UHT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 16:07:19 -0400
Received: by fxm2 with SMTP id 2so1411628fxm.37
        for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2009 13:07:17 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Fix

	WARNING: printk() should include KERN_ facility level

issues detected by checkpatch.pl.

While at it:
- fix whitespace damage in sd_ioctl()
- use __func__ in sd_ioctl(), init_sd() and exit_sd()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/sd.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: b/drivers/scsi/sd.c
===================================================================
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -748,9 +748,9 @@ static int sd_ioctl(struct block_device 
 	struct scsi_device *sdp = scsi_disk(disk)->device;
 	void __user *p = (void __user *)arg;
 	int error;
-    
-	SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
-						disk->disk_name, cmd));
+
+	SCSI_LOG_IOCTL(1, printk(KERN_INFO "%s: disk=%s, cmd=0x%x\n",
+				 __func__, disk->disk_name, cmd));
 
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
@@ -1191,7 +1191,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			}
 			/* Wait 1 second for next try */
 			msleep(1000);
-			printk(".");
+			printk(KERN_CONT ".");
 
 		/*
 		 * Wait for USB flash devices with slow firmware.
@@ -1221,9 +1221,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 
 	if (spintime) {
 		if (scsi_status_is_good(the_result))
-			printk("ready\n");
+			printk(KERN_CONT "ready\n");
 		else
-			printk("not responding...\n");
+			printk(KERN_CONT "not responding...\n");
 	}
 }
 
@@ -2203,7 +2203,8 @@ static int __init init_sd(void)
 {
 	int majors = 0, i, err;
 
-	SCSI_LOG_HLQUEUE(3, printk("init_sd: sd driver entry point\n"));
+	SCSI_LOG_HLQUEUE(3, printk(KERN_INFO "%s: sd driver entry point\n",
+					     __func__));
 
 	for (i = 0; i < SD_MAJORS; i++)
 		if (register_blkdev(sd_major(i), "sd") == 0)
@@ -2239,7 +2240,8 @@ static void __exit exit_sd(void)
 {
 	int i;
 
-	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
+	SCSI_LOG_HLQUEUE(3, printk(KERN_INFO "%s: exiting sd driver\n",
+				   __func__));
 
 	scsi_unregister_driver(&sd_template.gendrv);
 	class_unregister(&sd_disk_class);
