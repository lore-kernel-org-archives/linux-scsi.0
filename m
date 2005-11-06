From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] Fix transport class oops
Date: Sun, 06 Nov 2005 11:47:08 -0600
Message-ID: <1131299228.3316.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:47494 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932226AbVKFRrU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Nov 2005 12:47:20 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id jA6Hl9x20221
	for <linux-scsi@vger.kernel.org>; Sun, 6 Nov 2005 12:47:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

There's an oops that sometimes shows up with SCSI transport classes in
sysfs_hash_and_remove.  The problem is that now, because of the class to
device and vice versa symlinks, all classes have to be removed from
visibility *before* the device is removed from visibility.

The transport class trigger points violate this, so bring them back into
conformance.

James

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -691,16 +691,19 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 
 void __scsi_remove_device(struct scsi_device *sdev)
 {
+	struct device *dev = &sdev->sdev_gendev;
+
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
 	class_device_unregister(&sdev->sdev_classdev);
-	device_del(&sdev->sdev_gendev);
+	transport_remove_device(dev);
+	device_del(dev);
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-	transport_unregister_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+	transport_destroy_device(dev);
+	put_device(dev);
 }
 
 /**


