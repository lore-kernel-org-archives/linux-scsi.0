From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 10/11] Fixup scsi_sysfs_add_sdev()
Date: Mon, 18 Jun 2007 11:02:15 +0200
Message-ID: <20070618090215.08F6CD44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:56594 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbXFRJCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 05:02:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


scsi_sysfs_add_sdev() should not modify the sdev state as it doesn't
require any hardware access. And we should take care to retrace our
steps on failure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0e11fa3..6be59c9 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -720,21 +721,16 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 {
 	int error, i;
 
-	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
-		return error;
-
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
 			    "failed to add device (error %d)\n", error);
-		scsi_device_set_state(sdev, SDEV_DEL);
 		return error;
 	}
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
 			    "failed to add class device (error %d)\n", error);
-		scsi_device_set_state(sdev, SDEV_DEL);
 		device_del(&sdev->sdev_gendev);
 		return error;
 	}
@@ -746,14 +742,11 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = attr_add(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
-			if (error) {
-				scsi_sysfs_remove_sdev(sdev);
-				scsi_destroy_device(sdev);
+			if (error)
 				goto out;
-			}
 		}
 	}
-	
+
 	for (i = 0; scsi_sysfs_sdev_attrs[i]; i++) {
 		if (!attr_overridden(sdev->host->hostt->sdev_attrs,
 					scsi_sysfs_sdev_attrs[i])) {
@@ -761,16 +754,20 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 				attr_changed_internally(sdev->host, 
 							scsi_sysfs_sdev_attrs[i]);
 			error = device_create_file(&sdev->sdev_gendev, attr);
-			if (error) {
-				scsi_sysfs_remove_sdev(sdev);
-				scsi_destroy_device(sdev);
+			if (error)
 				goto out;
-			}
 		}
 	}
 
 	transport_add_device(&sdev->sdev_gendev);
+
+	return 0;
+
  out:
+	class_device_del(&sdev->sdev_classdev);
+	put_device(&sdev->sdev_gendev);
+	device_del(&sdev->sdev_gendev);
+
 	return error;
 }
 
-- 
1.4.3.4

