From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4/7] SCSI: move irrelevant code out of scsi_sysfs_device_initialize()
Date: Wed, 2 Jun 2010 16:36:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006021155370.1992-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58691 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758027Ab0FBUgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 16:36:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1341) moves some code having nothing to do with sysfs
out of scsi_sysfs_device_initialize() and into its caller,
scsi_alloc_sdev().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -1078,10 +1078,6 @@ static struct device_type scsi_dev_type 
 
 void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
-	unsigned long flags;
-	struct Scsi_Host *shost = sdev->host;
-	struct scsi_target  *starget = sdev->sdev_target;
-
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.type = &scsi_dev_type;
@@ -1093,12 +1089,6 @@ void scsi_sysfs_device_initialize(struct
 	sdev->sdev_dev.class = &sdev_class;
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	sdev->scsi_level = starget->scsi_level;
-	transport_setup_device(&sdev->sdev_gendev);
-	spin_lock_irqsave(shost->host_lock, flags);
-	list_add_tail(&sdev->same_target_siblings, &starget->devices);
-	list_add_tail(&sdev->siblings, &shost->__devices);
-	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 int scsi_is_sdev_device(const struct device *dev)
Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -242,6 +242,7 @@ static struct scsi_device *scsi_alloc_sd
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	extern void scsi_evt_thread(struct work_struct *work);
+	unsigned long flags;
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
@@ -267,6 +268,7 @@ static struct scsi_device *scsi_alloc_sd
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
+	sdev->scsi_level = starget->scsi_level;
 
 	/* usually NULL and set by ->slave_alloc instead */
 	sdev->hostdata = hostdata;
@@ -300,6 +302,12 @@ static struct scsi_device *scsi_alloc_sd
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
 	scsi_sysfs_device_initialize(sdev);
+	transport_setup_device(&sdev->sdev_gendev);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_add_tail(&sdev->same_target_siblings, &starget->devices);
+	list_add_tail(&sdev->siblings, &shost->__devices);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (shost->hostt->slave_alloc) {
 		ret = shost->hostt->slave_alloc(sdev);

