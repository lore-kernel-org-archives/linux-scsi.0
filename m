From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6/6] SCSI: remove targets when all underlying devices are
 invisible
Date: Fri, 29 May 2009 16:06:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905291557120.2648-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40252 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759079AbZE2UGz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 16:06:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1251) changes the time when a scsi device is unlinked
from the host's and target's lists.  Now the unlinks take place when
the device is removed from visibility, not when it is finally
released.

This fixes a general problem in the midlayer's architecture: a host
could be removed from visibility before some its targets, because the
targets weren't removed until all the devices were released.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -292,18 +292,13 @@ static void scsi_device_dev_release_user
 {
 	struct scsi_device *sdev;
 	struct device *parent;
-	struct scsi_target *starget;
 	struct list_head *this, *tmp;
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
-
 	parent = sdev->sdev_gendev.parent;
-	starget = to_scsi_target(parent);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	list_del(&sdev->siblings);
-	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
@@ -329,8 +324,6 @@ static void scsi_device_dev_release_user
 	 * after free of sdev */
 	sdev->request_queue = NULL;
 
-	scsi_target_reap(scsi_target(sdev));
-
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -933,6 +926,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	unsigned long flags;
 
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
@@ -946,6 +940,13 @@ void __scsi_remove_device(struct scsi_de
 	if (sdev->did_device_add)
 		device_del(dev);
 	scsi_device_set_state(sdev, SDEV_DEL);
+
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	list_del(&sdev->siblings);
+	list_del(&sdev->same_target_siblings);
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
+	scsi_target_reap(sdev->sdev_target);
+
 	put_device(dev);
 }
 


