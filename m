From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6/6 ver 2] SCSI: remove targets when all underlying devices
 are removed
Date: Wed, 3 Jun 2009 11:36:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906031134220.2994-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39872 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753663AbZFCPgH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 11:36:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1251b) changes the meaning of scsi_target->reap_ref.
Previously it counted the number of LUNs below the target; now it
counts only the number of visible LUNs.  In other words, the call to
scsi_target_reap() is moved from scsi_device_dev_release_usercontext()
to __scsi_remove_device().

This fixes a general problem in the midlayer's architecture: A host
could be removed from visibility before some its targets, because a
target wasn't removed until all the underlying LUNs were finally
released -- an arbitrarily long delay.  Now the target will become
invisible as soon as all the underlying LUNs do.

Note that the linked list pointers and the lifetime of the scsi_target
structure are unaffected.  Only the removal from visibility is
changed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -292,14 +292,11 @@ static void scsi_device_dev_release_user
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
 	list_del(&sdev->siblings);
@@ -329,8 +326,6 @@ static void scsi_device_dev_release_user
 	 * after free of sdev */
 	sdev->request_queue = NULL;
 
-	scsi_target_reap(scsi_target(sdev));
-
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -946,6 +941,9 @@ void __scsi_remove_device(struct scsi_de
 	if (sdev->did_device_add)
 		device_del(dev);
 	scsi_device_set_state(sdev, SDEV_DEL);
+
+	scsi_target_reap(sdev->sdev_target);
+
 	put_device(dev);
 }
 
Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -490,7 +490,6 @@ void scsi_target_reap(struct scsi_target
 	BUG_ON(state == STARGET_DEL || reap_ref < 0);
 	if (reap_ref > 0)
 		return;
-	BUG_ON(!list_empty(&starget->devices));
 
 	if (state == STARGET_RUNNING) {
 		device_del(&starget->dev);

