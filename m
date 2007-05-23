From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 4/9] Free sdev class device from release function
Date: Wed, 23 May 2007 10:55:32 +0200
Message-ID: <20070523085532.7BC3DD44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:35150 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184AbXEWIzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 04:55:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


For a clean teardown of a sdev the class device should
really be freed from the sdev's release function.
This way we don't have to worry about refcounting the
class device structures itself.
And the functions are now better aligned with the sdev
state model; _scsi_remove_device() transitions the sdev
from RUNNING to CANCEL, and scsi_destroy_device() from
CANCEL to DEL.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c  |   13 ++++++-------
 drivers/scsi/scsi_sysfs.c |   34 ++++++++++++++++------------------
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4874bdd..e967705 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -298,8 +298,7 @@ static struct scsi_device *scsi_alloc_sd
 	return sdev;
 
 out_device_destroy:
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+	scsi_destroy_device(sdev);
 out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
@@ -1095,11 +1094,12 @@ static int scsi_probe_and_add_lun(struct
 				*sdevp = sdev;
 			} else {
 				__scsi_remove_device(sdev);
+				scsi_destroy_device(sdev);
 				res = SCSI_SCAN_NO_RESPONSE;
 			}
 		}
 	} else
-		scsi_destroy_sdev(sdev);
+		scsi_destroy_device(sdev);
  out:
 	return res;
 }
@@ -1453,7 +1453,7 @@ static int scsi_report_lun_scan(struct s
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
-		scsi_destroy_sdev(sdev);
+		scsi_destroy_device(sdev);
 	return ret;
 }
 
@@ -1662,8 +1662,7 @@ static void scsi_sysfs_add_devices(struc
 {
 	struct scsi_device *sdev;
 	shost_for_each_device(sdev, shost) {
-		if (scsi_sysfs_add_sdev(sdev) != 0)
-			scsi_destroy_sdev(sdev);
+		scsi_sysfs_add_sdev(sdev);
 	}
 }
 
@@ -1877,7 +1876,7 @@ void scsi_free_host_dev(struct scsi_devi
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
 
-	scsi_destroy_sdev(sdev);
+	scsi_destroy_device(sdev);
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index c81c326..65b46e0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -215,7 +215,6 @@ static void scsi_device_cls_release(stru
 	struct scsi_device *sdev;
 
 	sdev = class_to_sdev(class_dev);
-	put_device(&sdev->sdev_gendev);
 }
 
 static void scsi_device_dev_release_usercontext(struct work_struct *work)
@@ -230,6 +229,11 @@ static void scsi_device_dev_release_user
 	parent = sdev->sdev_gendev.parent;
 	starget = to_scsi_target(parent);
 
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	transport_destroy_device(&sdev->sdev_gendev);
+	class_device_put(&sdev->sdev_classdev);
+
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	starget->reap_ref++;
 	list_del(&sdev->siblings);
@@ -741,17 +745,20 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
 			    "failed to add device (error %d)\n", error);
+		scsi_device_set_state(sdev, SDEV_DEL);
 		return error;
 	}
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
 			    "failed to add class device (error %d)\n", error);
-		goto clean_device;
+		scsi_device_set_state(sdev, SDEV_DEL);
+		device_del(&sdev->sdev_gendev);
+		return error;
 	}
 
 	/* take a reference for the sdev_classdev; this is
-	 * released by the sdev_class .release */
+	 * released in scsi_remove_device() */
 	get_device(&sdev->sdev_gendev);
 	if (sdev->host->hostt->sdev_attrs) {
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
@@ -759,6 +766,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error) {
 				__scsi_remove_device(sdev);
+				scsi_destroy_device(sdev);
 				goto out;
 			}
 		}
@@ -773,6 +781,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 			error = device_create_file(&sdev->sdev_gendev, attr);
 			if (error) {
 				__scsi_remove_device(sdev);
+				scsi_destroy_device(sdev);
 				goto out;
 			}
 		}
@@ -781,15 +790,6 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	transport_add_device(&sdev->sdev_gendev);
  out:
 	return error;
-
- clean_device:
-	scsi_device_set_state(sdev, SDEV_CANCEL);
-
-	device_del(&sdev->sdev_gendev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
-
-	return error;
 }
 
 void __scsi_remove_device(struct scsi_device *sdev)
@@ -799,14 +799,11 @@ void __scsi_remove_device(struct scsi_de
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
-	class_device_unregister(&sdev->sdev_classdev);
+	class_device_del(&sdev->sdev_classdev);
+	/* Release the refcount hold for the classdev */
+	put_device(&sdev->sdev_gendev);
 	transport_remove_device(dev);
 	device_del(dev);
-	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(dev);
-	put_device(dev);
 }
 
 /**
@@ -819,6 +816,7 @@ void scsi_remove_device(struct scsi_devi
 
 	mutex_lock(&shost->scan_mutex);
 	__scsi_remove_device(sdev);
+	scsi_destroy_device(sdev);
 	mutex_unlock(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
-- 
1.4.3.4

