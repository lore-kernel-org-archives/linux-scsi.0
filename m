From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi_remove_device simplifications
Date: Sun, 13 Jul 2003 15:33:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030713133320.GA24821@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:1189 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266004AbTGMNSj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jul 2003 09:18:39 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

 - change return value to void, returning errors from unregister
   doesn't make lots of sense
 - rename scsi_device_unregister to scsi_remove_device to kill
   a superflous level of layering


diff -Nru a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
--- a/drivers/ieee1394/sbp2.c	Sat Jul  5 19:42:23 2003
+++ b/drivers/ieee1394/sbp2.c	Sat Jul  5 19:42:23 2003
@@ -986,8 +986,9 @@
 	sbp2scsi_complete_all_commands(scsi_id, DID_NO_CONNECT);
 
 	/* Remove it from the scsi layer now */
-	if (sdev && scsi_remove_device(sdev))
-		SBP2_ERR("scsi_remove_device failed");
+	if (sdev) {
+		scsi_remove_device(sdev);
+	}
 
 	sbp2util_remove_command_orb_pool(scsi_id);
 
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Sat Jul  5 19:42:23 2003
+++ b/drivers/scsi/scsi_priv.h	Sat Jul  5 19:42:23 2003
@@ -109,7 +109,6 @@
 
 /* scsi_sysfs.c */
 extern int scsi_device_register(struct scsi_device *);
-extern void scsi_device_unregister(struct scsi_device *);
 extern void scsi_sysfs_init_host(struct Scsi_Host *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_sysfs_remove_host(struct Scsi_Host *);
diff -Nru a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	Sat Jul  5 19:42:23 2003
+++ b/drivers/scsi/scsi_proc.c	Sat Jul  5 19:42:23 2003
@@ -208,7 +208,8 @@
 	if (sdev->access_count)
 		goto out;
 
-	error = scsi_remove_device(sdev);
+	scsi_remove_device(sdev);
+	error = 0;
 out:
 	scsi_host_put(shost);
 	return error;
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Sat Jul  5 19:42:23 2003
+++ b/drivers/scsi/scsi_scan.c	Sat Jul  5 19:42:23 2003
@@ -1074,12 +1074,6 @@
 	return sdev;
 }
 
-int scsi_remove_device(struct scsi_device *sdev)
-{
-	scsi_device_unregister(sdev);
-	return 0;
-}
-
 void scsi_rescan_device(struct device *dev)
 {
 	struct scsi_driver *drv = to_scsi_driver(dev->driver);
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Sat Jul  5 19:42:23 2003
+++ b/drivers/scsi/scsi_sysfs.c	Sat Jul  5 19:42:23 2003
@@ -283,7 +283,7 @@
 			error = device_create_file(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error)
-				scsi_device_unregister(sdev);
+				scsi_remove_device(sdev);
 		}
 	}
 	
@@ -293,7 +293,7 @@
 			error = device_create_file(&sdev->sdev_gendev,
 					scsi_sysfs_sdev_attrs[i]);
 			if (error)
-				scsi_device_unregister(sdev);
+				scsi_remove_device(sdev);
 		}
 	}
 
@@ -301,10 +301,10 @@
 }
 
 /**
- * scsi_device_unregister - unregister a device from the scsi bus
+ * scsi_remove_device - unregister a device from the scsi bus
  * @sdev:	scsi_device to unregister
  **/
-void scsi_device_unregister(struct scsi_device *sdev)
+void scsi_remove_device(struct scsi_device *sdev)
 {
 	class_device_unregister(&sdev->sdev_classdev);
 	device_unregister(&sdev->sdev_gendev);
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Sat Jul  5 19:42:23 2003
+++ b/include/scsi/scsi_device.h	Sat Jul  5 19:42:23 2003
@@ -93,7 +93,7 @@
 
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
-extern int scsi_remove_device(struct scsi_device *);
+extern void scsi_remove_device(struct scsi_device *);
 extern void scsi_set_device_offline(struct scsi_device *);
 
 extern int scsi_device_get(struct scsi_device *);
