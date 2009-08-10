From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6/7] Fix various bugs in the the scsi_device code
Date: Mon, 10 Aug 2009 11:08:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908101106020.3208-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59395 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932099AbZHJPIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 11:08:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1277) fixes some bugs in the scsi_device code:

	In scsi_report_lun_scan(), if a newly-allocated device
	couldn't be used, it never got deleted.

	scsi_get_host_dev() incorrectly called get_device() on the
	new device's target.  This was compensated by a put_device()
	in scsi_sysfs_add_sdev(), but only in one of the error paths.

	Most, but not all, of the error paths in scsi_sysfs_add_sdev()
	would mistakenly remove the device.  Since the caller always
	removes the device if anything goes wrong,
	scsi_sysfs_add_sdev() should leave it alone.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -1323,8 +1323,10 @@ static int scsi_report_lun_scan(struct s
 		sdev = scsi_alloc_sdev(starget, 0, NULL);
 		if (!sdev)
 			return 0;
-		if (scsi_device_get(sdev))
+		if (scsi_device_get(sdev)) {
+			__scsi_remove_device(sdev);
 			return 0;
+		}
 	}
 
 	sprintf(devname, "host %d channel %d id %d",
@@ -1893,10 +1895,9 @@ struct scsi_device *scsi_get_host_dev(st
 		goto out;
 
 	sdev = scsi_alloc_sdev(starget, 0, NULL);
-	if (sdev) {
-		sdev->sdev_gendev.parent = get_device(&starget->dev);
+	if (sdev)
 		sdev->borken = 0;
-	} else
+	else
 		scsi_target_reap(starget);
 	put_device(&starget->dev);
  out:
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -858,7 +858,6 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		put_device(sdev->sdev_gendev.parent);
 		printk(KERN_INFO "error 1\n");
 		return error;
 	}
@@ -867,7 +866,6 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
-		__scsi_remove_device(sdev);
 		return error;
 	}
 	sdev->did_add_sdev_dev = 1;
@@ -881,18 +879,14 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_depth_rw);
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
-	if (error) {
-		__scsi_remove_device(sdev);
+	if (error)
 		goto out;
-	}
 	if (sdev->host->hostt->change_queue_type)
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_type_rw);
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_type);
-	if (error) {
-		__scsi_remove_device(sdev);
+	if (error)
 		goto out;
-	}
 
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
 
@@ -910,10 +904,8 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = device_create_file(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
-			if (error) {
-				__scsi_remove_device(sdev);
+			if (error)
 				goto out;
-			}
 		}
 	}
 

