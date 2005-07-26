From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/5] SCSI scanning and removal fixes
Date: Tue, 26 Jul 2005 10:20:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0507261018460.4746-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:1174 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261790AbVGZOUy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 10:20:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as544) adds a private entry point to scsi_remove_device, for 
use when callers already own the scan_mutex.  The appropriate callers are 
modified to use the new entry point.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: 2613/drivers/scsi/scsi_sysfs.c
===================================================================
--- 2613.orig/drivers/scsi/scsi_sysfs.c
+++ 2613/drivers/scsi/scsi_sysfs.c
@@ -653,7 +653,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 			error = attr_add(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error) {
-				scsi_remove_device(sdev);
+				__scsi_remove_device(sdev);
 				goto out;
 			}
 		}
@@ -667,7 +667,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 							scsi_sysfs_sdev_attrs[i]);
 			error = device_create_file(&sdev->sdev_gendev, attr);
 			if (error) {
-				scsi_remove_device(sdev);
+				__scsi_remove_device(sdev);
 				goto out;
 			}
 		}
@@ -687,17 +687,10 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	return error;
 }
 
-/**
- * scsi_remove_device - unregister a device from the scsi bus
- * @sdev:	scsi_device to unregister
- **/
-void scsi_remove_device(struct scsi_device *sdev)
+void __scsi_remove_device(struct scsi_device *sdev)
 {
-	struct Scsi_Host *shost = sdev->host;
-
-	down(&shost->scan_mutex);
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-		goto out;
+		return;
 
 	class_device_unregister(&sdev->sdev_classdev);
 	device_del(&sdev->sdev_gendev);
@@ -706,8 +699,17 @@ void scsi_remove_device(struct scsi_devi
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_unregister_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
-out:
-	up(&shost->scan_mutex);
+}
+
+/**
+ * scsi_remove_device - unregister a device from the scsi bus
+ * @sdev:	scsi_device to unregister
+ **/
+void scsi_remove_device(struct scsi_device *sdev)
+{
+	down(&sdev->host->scan_mutex);
+	__scsi_remove_device(sdev);
+	up(&sdev->host->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
 
Index: 2613/drivers/scsi/scsi_priv.h
===================================================================
--- 2613.orig/drivers/scsi/scsi_priv.h
+++ 2613/drivers/scsi/scsi_priv.h
@@ -141,6 +141,7 @@ extern void scsi_sysfs_unregister(void);
 extern void scsi_sysfs_device_initialize(struct scsi_device *);
 extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
+extern void __scsi_remove_device(struct scsi_device *);
 
 extern struct bus_type scsi_bus_type;
 

