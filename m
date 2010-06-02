From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/7] SCSI: improve two error messages
Date: Wed, 2 Jun 2010 16:35:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006021151110.1992-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58685 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758027Ab0FBUf3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 16:35:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This trivial patch (as1338) makes two uninformative error messages in
scsi_sysfs_add_sdev() more explicit.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -890,13 +890,15 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	device_enable_async_suspend(&sdev->sdev_gendev);
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		printk(KERN_INFO "error 1\n");
+		sdev_printk(KERN_INFO, sdev,
+				"failed to add device: %d\n", error);
 		return error;
 	}
 	device_enable_async_suspend(&sdev->sdev_dev);
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
-		printk(KERN_INFO "error 2\n");
+		sdev_printk(KERN_INFO, sdev,
+				"failed to add class device: %d\n", error);
 		device_del(&sdev->sdev_gendev);
 		return error;
 	}

