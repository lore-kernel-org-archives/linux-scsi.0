From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/4 ver 3] SCSI: improvements to the device and target code
Date: Wed, 28 Oct 2009 15:09:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0910281503040.3061-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57069 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752338AbZJ1TJc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2009 15:09:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1278c) makes some minor improvements and clean-ups to the
device- and target-handling functions in scsi_scan.c and scsi_sysfs.c:

	Two uninformative error messages in scsi_sysfs_add_sdev()
	are made more explicit, and a uniform scheme is adopted for
	early exits.

	__scsi_remove_target() is simplified by replacing reap_ref
	operations with calls to get_device()/put_device().

	An unnecessary local variable is eliminated from
	scsi_remove_target().

	Some code having nothing to do with sysfs is moved out of
	scsi_sysfs_device_initialize() into its caller,
	scsi_alloc_sdev().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -850,24 +850,26 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	struct scsi_target *starget = sdev->sdev_target;
 
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
-		return error;
+		goto out;
 
 	error = scsi_target_add(starget);
 	if (error)
-		return error;
+		goto out;
 
 	transport_configure_device(&starget->dev);
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		printk(KERN_INFO "error 1\n");
-		return error;
+		sdev_printk(KERN_INFO, sdev,
+				"failed to add device: %d\n", error);
+		goto out;
 	}
 	sdev->did_device_add = 1;
 
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
-		printk(KERN_INFO "error 2\n");
-		return error;
+		sdev_printk(KERN_INFO, sdev,
+				"failed to add class device: %d\n", error);
+		goto out;
 	}
 	sdev->did_add_sdev_dev = 1;
 
@@ -890,7 +892,6 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		goto out;
 
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
-
 	if (error)
 		sdev_printk(KERN_INFO, sdev,
 			    "Failed to register bsg queue, errno=%d\n", error);
@@ -955,8 +956,8 @@ static void __scsi_remove_target(struct 
 	unsigned long flags;
 	struct scsi_device *sdev;
 
+	get_device(&starget->dev);
 	spin_lock_irqsave(shost->host_lock, flags);
-	starget->reap_ref++;
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
@@ -969,7 +970,7 @@ static void __scsi_remove_target(struct 
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	scsi_target_reap(starget);
+	put_device(&starget->dev);
 }
 
 static int __remove_child (struct device * dev, void * data)
@@ -989,16 +990,14 @@ static int __remove_child (struct device
  */
 void scsi_remove_target(struct device *dev)
 {
-	struct device *rdev;
-
 	if (scsi_is_target_device(dev)) {
 		__scsi_remove_target(to_scsi_target(dev));
 		return;
 	}
 
-	rdev = get_device(dev);
+	get_device(dev);
 	device_for_each_child(dev, NULL, __remove_child);
-	put_device(rdev);
+	put_device(dev);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
@@ -1049,10 +1048,6 @@ static struct device_type scsi_dev_type 
 
 void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
-	unsigned long flags;
-	struct Scsi_Host *shost = sdev->host;
-	struct scsi_target  *starget = sdev->sdev_target;
-
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.type = &scsi_dev_type;
@@ -1064,12 +1059,7 @@ void scsi_sysfs_device_initialize(struct
 	sdev->sdev_dev.class = &sdev_class;
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	sdev->scsi_level = starget->scsi_level;
-	transport_setup_device(&sdev->sdev_gendev);
-	spin_lock_irqsave(shost->host_lock, flags);
-	list_add_tail(&sdev->same_target_siblings, &starget->devices);
-	list_add_tail(&sdev->siblings, &shost->__devices);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	sdev->scsi_level = sdev->sdev_target->scsi_level;
 }
 
 int scsi_is_sdev_device(const struct device *dev)
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
@@ -299,6 +300,13 @@ static struct scsi_device *scsi_alloc_sd
 
 	scsi_sysfs_device_initialize(sdev);
 
+	transport_setup_device(&sdev->sdev_gendev);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_add_tail(&sdev->same_target_siblings, &starget->devices);
+	list_add_tail(&sdev->siblings, &shost->__devices);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	if (shost->hostt->slave_alloc) {
 		ret = shost->hostt->slave_alloc(sdev);
 		if (ret) {


