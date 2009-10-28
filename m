From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/4 ver 3] SCSI: add construction flags to scsi_device
 structure
Date: Wed, 28 Oct 2009 15:09:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0910281456510.3061-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57065 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751293AbZJ1TJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2009 15:09:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1250c) adds extra flags to the scsi_device structure, to
keep track of what parts have been constructed.  These flags are used
in the destructor routines to determine which fields need to be torn
down.  This allows all the slave_destroy() and
transport_destroy_device() calls to be moved to a single place in
scsi_device_dev_release_user_context() instead of appearing in
multiple locations throughout the source.

This also simplifies the destructors.  There's no need for a separate
scsi_destroy_sdev() routine; __scsi_remove_device() can handle
everything.  The error paths are more robust because now it's easy to
verify that all the destructors are called along every pathway.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/include/scsi/scsi_device.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_device.h
+++ usb-2.6/include/scsi/scsi_device.h
@@ -146,6 +146,13 @@ struct scsi_device {
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
 
+			/* Keep track of how much has been constructed */
+	unsigned did_slave_alloc:1;
+	unsigned did_device_add:1;
+	unsigned did_add_sdev_dev:1;
+	unsigned did_bsg_register_queue:1;
+	unsigned did_transport_add_device:1;
+
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
 	struct work_struct event_work;
Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -311,13 +311,12 @@ static struct scsi_device *scsi_alloc_sd
 			goto out_device_destroy;
 		}
 	}
+	sdev->did_slave_alloc = 1;
 
 	return sdev;
 
 out_device_destroy:
-	scsi_device_set_state(sdev, SDEV_DEL);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+	__scsi_remove_device(sdev);
 out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __func__);
@@ -951,15 +950,6 @@ static int scsi_add_lun(struct scsi_devi
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
-static inline void scsi_destroy_sdev(struct scsi_device *sdev)
-{
-	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
-}
-
 #ifdef CONFIG_SCSI_LOGGING
 /** 
  * scsi_inq_str - print INQUIRY data from min to max index, strip trailing whitespace
@@ -1137,7 +1127,7 @@ static int scsi_probe_and_add_lun(struct
 			}
 		}
 	} else
-		scsi_destroy_sdev(sdev);
+		__scsi_remove_device(sdev);
  out:
 	return res;
 }
@@ -1498,7 +1488,7 @@ static int scsi_report_lun_scan(struct s
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
-		scsi_destroy_sdev(sdev);
+		__scsi_remove_device(sdev);
 	return ret;
 }
 
@@ -1708,7 +1698,7 @@ static void scsi_sysfs_add_devices(struc
 	shost_for_each_device(sdev, shost) {
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
-			scsi_destroy_sdev(sdev);
+			__scsi_remove_device(sdev);
 	}
 }
 
@@ -1941,7 +1931,7 @@ void scsi_free_host_dev(struct scsi_devi
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
 
-	scsi_destroy_sdev(sdev);
+	scsi_remove_device(sdev);
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
 
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -318,6 +318,11 @@ static void scsi_device_dev_release_user
 		kfree(evt);
 	}
 
+	if (sdev->did_slave_alloc && sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+
+	transport_destroy_device(&sdev->sdev_gendev);
+
 	if (sdev->request_queue) {
 		sdev->request_queue->queuedata = NULL;
 		/* user context needed to free queue */
@@ -858,11 +863,15 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		printk(KERN_INFO "error 1\n");
 		return error;
 	}
+	sdev->did_device_add = 1;
+
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
-		goto clean_device;
+		__scsi_remove_device(sdev);
+		return error;
 	}
+	sdev->did_add_sdev_dev = 1;
 
 	/* take a reference for the sdev_dev; this is
 	 * released by the sdev_class .release */
@@ -895,6 +904,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	/* we're treating error on bsg register as non-fatal, so pretend
 	 * nothing went wrong */
 	error = 0;
+	sdev->did_bsg_register_queue = 1;
 
 	/* add additional host specific attributes */
 	if (sdev->host->hostt->sdev_attrs) {
@@ -909,17 +919,9 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	}
 
 	transport_add_device(&sdev->sdev_gendev);
+	sdev->did_transport_add_device = 1;
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
@@ -929,14 +931,15 @@ void __scsi_remove_device(struct scsi_de
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
-	bsg_unregister_queue(sdev->request_queue);
-	device_unregister(&sdev->sdev_dev);
-	transport_remove_device(dev);
-	device_del(dev);
+	if (sdev->did_bsg_register_queue)
+		bsg_unregister_queue(sdev->request_queue);
+	if (sdev->did_add_sdev_dev)
+		device_unregister(&sdev->sdev_dev);
+	if (sdev->did_transport_add_device)
+		transport_remove_device(dev);
+	if (sdev->did_device_add)
+		device_del(dev);
 	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(dev);
 	put_device(dev);
 }
 


