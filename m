From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/5] SCSI: fix duplicate removal in scsi_sysfs_add_sdev
Date: Fri, 12 Feb 2010 12:13:55 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002121210420.1307-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35477 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757511Ab0BLRNz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 12:13:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1335) fixes a bug in scsi_sysfs_add_sdev().  Its callers
always remove the device if anything goes wrong, so it should never
remove the device.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -878,7 +878,8 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	struct request_queue *rq = sdev->request_queue;
 	struct scsi_target *starget = sdev->sdev_target;
 
-	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
+	error = scsi_device_set_state(sdev, SDEV_RUNNING);
+	if (error)
 		return error;
 
 	error = scsi_target_add(starget);
@@ -889,13 +890,13 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		printk(KERN_INFO "error 1\n");
-		goto out_remove;
+		return error;
 	}
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
 		device_del(&sdev->sdev_gendev);
-		goto out_remove;
+		return error;
 	}
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
@@ -910,14 +911,14 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
 	if (error)
-		goto out_remove;
+		return error;
 
 	if (sdev->host->hostt->change_queue_type)
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_type_rw);
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_type);
 	if (error)
-		goto out_remove;
+		return error;
 
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
 
@@ -933,16 +934,11 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 			error = device_create_file(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error)
-				goto out_remove;
+				return error;
 		}
 	}
 
-	return 0;
-
- out_remove:
-	__scsi_remove_device(sdev);
 	return error;
-
 }
 
 void __scsi_remove_device(struct scsi_device *sdev)

