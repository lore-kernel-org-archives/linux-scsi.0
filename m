From: James.Smart@Emulex.Com
Subject: [Patch] Allow LLDD's to fail slave alloc (non-existent slave) and not display error messages
Date: Wed, 15 Sep 2004 12:27:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F1BE@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:30683 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S266674AbUIOQ2a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 12:28:30 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i8FGRkgK001919
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2004 09:28:29 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


In the cases where an LLDD knows that a lun does not exist, if it fails slave_alloc(), the midlayer reports an error message indicating slave_alloc failed.

This patch allows the LLDD to reject the slave_alloc() call if it knows the lun doesn't exist, and skips the reporting of the slave_alloc failure message. This avoids jumping through hoops in the LLDD to avoid error messages from slave_alloc. Also saves cycles in that the probe is also cancelled for the non-existent device.

-- James S



diff -uNr scsi-target-2.6/drivers/scsi/scsi_scan.c scsi-target-2.6-jws/drivers/scsi/scsi_scan.c
--- scsi-target-2.6/drivers/scsi/scsi_scan.c	2004-09-15 11:24:46.000000000 -0400
+++ scsi-target-2.6-jws/drivers/scsi/scsi_scan.c	2004-09-15 11:24:25.000000000 -0400
@@ -204,6 +204,7 @@
 {
 	struct scsi_device *sdev;
 	unsigned long flags;
+	int display_failure_msg = 1, ret;
 
 	sdev = kmalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
@@ -253,8 +254,16 @@
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
 	if (shost->hostt->slave_alloc) {
-		if (shost->hostt->slave_alloc(sdev))
+		ret = shost->hostt->slave_alloc(sdev);
+		if (ret) {
+			/*
+			 * if LLDD reports slave not present, don't clutter
+			 * console with alloc failure messages
+			 */
+			if (ret == -ENXIO)
+				display_failure_msg = 0;
 			goto out_free_queue;
+		}
 	}
 
 	if (shost->transportt->device_setup) {
@@ -287,7 +296,8 @@
 out_free_dev:
 	kfree(sdev);
 out:
-	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+	if (display_failure_msg)
+		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 	return NULL;
 }
 
