From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PATCH] SCSI fixes for 2.6.32-rc8
Date: Mon, 30 Nov 2009 17:29:54 -0500
Message-ID: <1259620194.11762.137.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753206AbZK3W34@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of miscellaneous (but small) fixes for SCSI.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Alexey Kuznetsov (1):
      fix crash when disconnecting usb storage

James Bottomley (1):
      fix async scan add/remove race resulting in an oops

Martin K. Petersen (1):
      sd: Return correct error code for DIF

The diffstat is:

 drivers/scsi/hosts.c       |    2 -
 drivers/scsi/scsi_scan.c   |   18 ++----------
 drivers/scsi/scsi_sysfs.c  |   63 +++++++++++++++++++--------------------------
 drivers/scsi/sd_dif.c      |    2 -
 include/scsi/scsi_device.h |    1 
 5 files changed, 34 insertions(+), 52 deletions(-)

And the full patch is attached below.

James

---

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 5fd2da4..c968cc3 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -164,8 +164,8 @@ void scsi_remove_host(struct Scsi_Host *shost)
 			return;
 		}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	mutex_unlock(&shost->scan_mutex);
 	scsi_forget_host(shost);
+	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
 
 	spin_lock_irqsave(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0547a7f..47291bc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -952,16 +952,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
-static inline void scsi_destroy_sdev(struct scsi_device *sdev)
-{
-	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_dev);
-	put_device(&sdev->sdev_gendev);
-}
-
 #ifdef CONFIG_SCSI_LOGGING
 /** 
  * scsi_inq_str - print INQUIRY data from min to max index, strip trailing whitespace
@@ -1139,7 +1129,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 			}
 		}
 	} else
-		scsi_destroy_sdev(sdev);
+		__scsi_remove_device(sdev);
  out:
 	return res;
 }
@@ -1500,7 +1490,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
-		scsi_destroy_sdev(sdev);
+		__scsi_remove_device(sdev);
 	return ret;
 }
 
@@ -1710,7 +1700,7 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 	shost_for_each_device(sdev, shost) {
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
-			scsi_destroy_sdev(sdev);
+			__scsi_remove_device(sdev);
 	}
 }
 
@@ -1943,7 +1933,7 @@ void scsi_free_host_dev(struct scsi_device *sdev)
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
 
-	scsi_destroy_sdev(sdev);
+	__scsi_remove_device(sdev);
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5c7eb63..392d8db 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -854,82 +854,73 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_configure_device(&starget->dev);
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		put_device(sdev->sdev_gendev.parent);
 		printk(KERN_INFO "error 1\n");
-		return error;
+		goto out_remove;
 	}
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
-		goto clean_device;
+		device_del(&sdev->sdev_gendev);
+		goto out_remove;
 	}
+	transport_add_device(&sdev->sdev_gendev);
+	sdev->is_visible = 1;
 
 	/* create queue files, which may be writable, depending on the host */
 	if (sdev->host->hostt->change_queue_depth)
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_depth_rw);
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
-	if (error) {
-		__scsi_remove_device(sdev);
-		goto out;
-	}
+	if (error)
+		goto out_remove;
+
 	if (sdev->host->hostt->change_queue_type)
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_type_rw);
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_type);
-	if (error) {
-		__scsi_remove_device(sdev);
-		goto out;
-	}
+	if (error)
+		goto out_remove;
 
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
 
 	if (error)
+		/* we're treating error on bsg register as non-fatal,
+		 * so pretend nothing went wrong */
 		sdev_printk(KERN_INFO, sdev,
 			    "Failed to register bsg queue, errno=%d\n", error);
 
-	/* we're treating error on bsg register as non-fatal, so pretend
-	 * nothing went wrong */
-	error = 0;
-
 	/* add additional host specific attributes */
 	if (sdev->host->hostt->sdev_attrs) {
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = device_create_file(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
-			if (error) {
-				__scsi_remove_device(sdev);
-				goto out;
-			}
+			if (error)
+				goto out_remove;
 		}
 	}
 
-	transport_add_device(&sdev->sdev_gendev);
- out:
-	return error;
-
- clean_device:
-	scsi_device_set_state(sdev, SDEV_CANCEL);
-
-	device_del(&sdev->sdev_gendev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_dev);
-	put_device(&sdev->sdev_gendev);
+	return 0;
 
+ out_remove:
+	__scsi_remove_device(sdev);
 	return error;
+
 }
 
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
 
-	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-		return;
+	if (sdev->is_visible) {
+		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+			return;
 
-	bsg_unregister_queue(sdev->request_queue);
-	device_unregister(&sdev->sdev_dev);
-	transport_remove_device(dev);
-	device_del(dev);
+		bsg_unregister_queue(sdev->request_queue);
+		device_unregister(&sdev->sdev_dev);
+		transport_remove_device(dev);
+		device_del(dev);
+	} else
+		put_device(&sdev->sdev_dev);
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 88da977..84be621 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -418,7 +418,7 @@ error:
 		  __func__, virt, phys, be32_to_cpu(sdt->ref_tag),
 		  be16_to_cpu(sdt->app_tag));
 
-	return -EIO;
+	return -EILSEQ;
 }
 
 /*
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9af48cb..f097ae3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -145,6 +145,7 @@ struct scsi_device {
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
+	unsigned is_visible:1;	/* is the device visible in sysfs */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
