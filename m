From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5/6] SCSI: simplify scsi_device destruction
Date: Fri, 29 May 2009 16:06:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905291556240.2648-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40249 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756770AbZE2UGu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 16:06:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1250) adds extra flags to the scsi_device structure, to
keep track of what parts have been constructed.  These flags are used
in the destructor routines to determine which fields need to be torn
down.

This simplifies the destructors.  There's no need for a separate
scsi_destroy_sdev() routine; __scsi_remove_device() can handle
everything.  The error paths are more robust because now it's easy to
verify that all the destructors are called along every pathway.

The patch also moves some codes having nothing to do with sysfs out of
scsi_sysfs_device_initialize() into the caller, scsi_alloc_sdev().

A couple of minor improvements were made in other areas:

	There's no need for scsi_device_dev_release_user_context()
	to check the request_queue has been allocated, because the
	release routine isn't called if allocation fails.

	Two uninformative error messages in scsi_sysfs_add_sdev()
	are expanded.

A few bugs in the existing code are fixed:

	In scsi_report_lun_scan(), if a newly-allocated device
	couldn't be used, it never got deleted.

	scsi_get_host_dev() incorrectly called get_device() on the
	new device's target.

	Some of the error paths in scsi_sysfs_add_sdev() would
	mistakenly remove the device.

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
@@ -241,6 +241,7 @@ static struct scsi_device *scsi_alloc_sd
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	extern void scsi_evt_thread(struct work_struct *work);
+	unsigned long flags;
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
@@ -299,6 +300,14 @@ static struct scsi_device *scsi_alloc_sd
 
 	scsi_sysfs_device_initialize(sdev);
 
+	spin_lock_irqsave(shost->host_lock, flags);
+	starget->reap_ref++;
+	list_add_tail(&sdev->same_target_siblings, &starget->devices);
+	list_add_tail(&sdev->siblings, &shost->__devices);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	transport_setup_device(&sdev->sdev_gendev);
+
 	if (shost->hostt->slave_alloc) {
 		ret = shost->hostt->slave_alloc(sdev);
 		if (ret) {
@@ -311,13 +320,12 @@ static struct scsi_device *scsi_alloc_sd
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
@@ -939,15 +947,6 @@ static int scsi_add_lun(struct scsi_devi
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
@@ -1125,7 +1124,7 @@ static int scsi_probe_and_add_lun(struct
 			}
 		}
 	} else
-		scsi_destroy_sdev(sdev);
+		__scsi_remove_device(sdev);
  out:
 	return res;
 }
@@ -1332,8 +1331,10 @@ static int scsi_report_lun_scan(struct s
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
@@ -1481,12 +1482,7 @@ static int scsi_report_lun_scan(struct s
  out_err:
 	kfree(lun_data);
  out:
-	scsi_device_put(sdev);
-	if (scsi_device_created(sdev))
-		/*
-		 * the sdev we used didn't appear in the report luns scan
-		 */
-		scsi_destroy_sdev(sdev);
+	__scsi_remove_device(sdev);
 	return ret;
 }
 
@@ -1696,7 +1692,7 @@ static void scsi_sysfs_add_devices(struc
 	shost_for_each_device(sdev, shost) {
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
-			scsi_destroy_sdev(sdev);
+			__scsi_remove_device(sdev);
 	}
 }
 
@@ -1900,10 +1896,9 @@ struct scsi_device *scsi_get_host_dev(st
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
@@ -1929,7 +1924,7 @@ void scsi_free_host_dev(struct scsi_devi
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
@@ -317,14 +317,17 @@ static void scsi_device_dev_release_user
 		kfree(evt);
 	}
 
-	if (sdev->request_queue) {
-		sdev->request_queue->queuedata = NULL;
-		/* user context needed to free queue */
-		scsi_free_queue(sdev->request_queue);
-		/* temporary expedient, try to catch use of queue lock
-		 * after free of sdev */
-		sdev->request_queue = NULL;
-	}
+	if (sdev->did_slave_alloc && sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+
+	transport_destroy_device(&sdev->sdev_gendev);
+
+	sdev->request_queue->queuedata = NULL;
+	/* user context needed to free queue */
+	scsi_free_queue(sdev->request_queue);
+	/* temporary expedient, try to catch use of queue lock
+	 * after free of sdev */
+	sdev->request_queue = NULL;
 
 	scsi_target_reap(scsi_target(sdev));
 
@@ -870,15 +873,19 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		put_device(sdev->sdev_gendev.parent);
-		printk(KERN_INFO "error 1\n");
+		sdev_printk(KERN_INFO, sdev,
+				"failed to add device: %d\n", error);
 		return error;
 	}
+	sdev->did_device_add = 1;
+
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
-		printk(KERN_INFO "error 2\n");
-		goto clean_device;
+		sdev_printk(KERN_INFO, sdev,
+				"failed to add class device: %d\n", error);
+		return error;
 	}
+	sdev->did_add_sdev_dev = 1;
 
 	/* take a reference for the sdev_dev; this is
 	 * released by the sdev_class .release */
@@ -889,21 +896,16 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_depth_rw);
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
-	if (error) {
-		__scsi_remove_device(sdev);
-		goto out;
-	}
+	if (error)
+		return error;
 	if (sdev->host->hostt->change_queue_type)
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_type_rw);
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_type);
-	if (error) {
-		__scsi_remove_device(sdev);
-		goto out;
-	}
+	if (error)
+		return error;
 
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
-
 	if (error)
 		sdev_printk(KERN_INFO, sdev,
 			    "Failed to register bsg queue, errno=%d\n", error);
@@ -911,30 +913,20 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	/* we're treating error on bsg register as non-fatal, so pretend
 	 * nothing went wrong */
 	error = 0;
+	sdev->did_bsg_register_queue = 1;
 
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
+				return error;
 		}
 	}
 
 	transport_add_device(&sdev->sdev_gendev);
- out:
-	return error;
-
- clean_device:
-	scsi_device_set_state(sdev, SDEV_CANCEL);
-
-	device_del(&sdev->sdev_gendev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
-
+	sdev->did_transport_add_device = 1;
 	return error;
 }
 
@@ -945,14 +937,15 @@ void __scsi_remove_device(struct scsi_de
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
-	bsg_unregister_queue(sdev->request_queue);
-	device_unregister(&sdev->sdev_dev);
-	transport_remove_device(dev);
-	device_del(dev);
+	if (sdev->did_transport_add_device)
+		transport_remove_device(dev);
+	if (sdev->did_bsg_register_queue)
+		bsg_unregister_queue(sdev->request_queue);
+	if (sdev->did_add_sdev_dev)
+		device_unregister(&sdev->sdev_dev);
+	if (sdev->did_device_add)
+		device_del(dev);
 	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(dev);
 	put_device(dev);
 }
 
@@ -1068,10 +1061,6 @@ static struct device_type scsi_dev_type 
 
 void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
-	unsigned long flags;
-	struct Scsi_Host *shost = sdev->host;
-	struct scsi_target  *starget = sdev->sdev_target;
-
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.type = &scsi_dev_type;
@@ -1083,13 +1072,7 @@ void scsi_sysfs_device_initialize(struct
 	sdev->sdev_dev.class = &sdev_class;
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	sdev->scsi_level = starget->scsi_level;
-	transport_setup_device(&sdev->sdev_gendev);
-	spin_lock_irqsave(shost->host_lock, flags);
-	starget->reap_ref++;
-	list_add_tail(&sdev->same_target_siblings, &starget->devices);
-	list_add_tail(&sdev->siblings, &shost->__devices);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	sdev->scsi_level = sdev->sdev_target->scsi_level;
 }
 
 int scsi_is_sdev_device(const struct device *dev)


