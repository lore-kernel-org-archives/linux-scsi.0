From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4/5] SCSI scanning and removal fixes
Date: Tue, 26 Jul 2005 10:27:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0507261020540.4746-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36073 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261795AbVGZO1K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 10:27:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as545) fixes the list traversals in __scsi_remove_target and 
scsi_forget_host.  In each case the existing code list_for_each_entry_safe 
in an _unsafe_ manner, because the list was not protected from outside 
modification while the iteration was running.

The new scsi_forget_host routine takes the moderately controversial step 
of iterating over devices for removal rather than iterating over targets.  
This makes more sense to me because the current scheme treats targets as 
second-class citizens, created and removed on demand, rather than as 
objects corresponding to actual hardware.  (Also I couldn't figure out any 
safe way to iterate over the target list, since it's not so easy to tell 
when a target has already been removed.)

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: 2613/drivers/scsi/scsi_sysfs.c
===================================================================
--- 2613.orig/drivers/scsi/scsi_sysfs.c
+++ 2613/drivers/scsi/scsi_sysfs.c
@@ -717,17 +717,20 @@ void __scsi_remove_target(struct scsi_ta
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
-	struct scsi_device *sdev, *tmp;
+	struct scsi_device *sdev;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	starget->reap_ref++;
-	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
+ restart:
+	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
-		    sdev->id != starget->id)
+		    sdev->id != starget->id ||
+		    sdev->sdev_state == SDEV_DEL)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
 		spin_lock_irqsave(shost->host_lock, flags);
+		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	scsi_target_reap(starget);
Index: 2613/drivers/scsi/scsi_scan.c
===================================================================
--- 2613.orig/drivers/scsi/scsi_scan.c
+++ 2613/drivers/scsi/scsi_scan.c
@@ -1425,23 +1425,17 @@ EXPORT_SYMBOL(scsi_scan_single_target);
 
 void scsi_forget_host(struct Scsi_Host *shost)
 {
-	struct scsi_target *starget, *tmp;
+	struct scsi_device *sdev;
 	unsigned long flags;
 
-	/*
-	 * Ok, this look a bit strange.  We always look for the first device
-	 * on the list as scsi_remove_device removes them from it - thus we
-	 * also have to release the lock.
-	 * We don't need to get another reference to the device before
-	 * releasing the lock as we already own the reference from
-	 * scsi_register_device that's release in scsi_remove_device.  And
-	 * after that we don't look at sdev anymore.
-	 */
+ restart:
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
+	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		scsi_remove_target(&starget->dev);
-		spin_lock_irqsave(shost->host_lock, flags);
+		__scsi_remove_device(sdev);
+		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }

