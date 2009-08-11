From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/7 ver 2] Add STARGET_NEW state
Date: Tue, 11 Aug 2009 11:30:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908111128560.2562-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40095 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751222AbZHKPaV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 11:30:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1249c) adds an extra state, STARGET_NEW, to the SCSI
target state model.  A target is in this state initially and changes
over to STARGET_CREATED when the hostt->target_alloc() call has been
made.

This simplifies target destruction.  There's no need for a separate
scsi_target_destroy() function; everything can be handled within
scsi_target_reap().  The error paths are more robust because now it's
easy to verify that all the destructors are called along every
pathway.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

The revision gets rid of an unnecessary spin_lock/spin_unlock pair 
surrounding the line where starget->state is changed from STARGET_NEW 
to STARGET_CREATED.



Index: usb-2.6/include/scsi/scsi_device.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_device.h
+++ usb-2.6/include/scsi/scsi_device.h
@@ -211,7 +211,8 @@ struct scsi_dh_data {
 	sdev_printk(prefix, (scmd)->device, fmt, ##a)
 
 enum scsi_target_state {
-	STARGET_CREATED = 1,
+	STARGET_NEW = 1,
+	STARGET_CREATED,
 	STARGET_RUNNING,
 	STARGET_DEL,
 };
Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -324,21 +324,6 @@ out:
 	return NULL;
 }
 
-static void scsi_target_destroy(struct scsi_target *starget)
-{
-	struct device *dev = &starget->dev;
-	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	unsigned long flags;
-
-	transport_destroy_device(dev);
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (shost->hostt->target_destroy)
-		shost->hostt->target_destroy(starget);
-	list_del_init(&starget->siblings);
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	put_device(dev);
-}
-
 static void scsi_target_dev_release(struct device *dev)
 {
 	struct device *parent = dev->parent;
@@ -423,7 +408,7 @@ static struct scsi_target *scsi_alloc_ta
 	starget->can_queue = 0;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
-	starget->state = STARGET_CREATED;
+	starget->state = STARGET_NEW;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
  retry:
@@ -439,15 +424,14 @@ static struct scsi_target *scsi_alloc_ta
 	transport_setup_device(dev);
 	if (shost->hostt->target_alloc) {
 		error = shost->hostt->target_alloc(starget);
-
-		if(error) {
-			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
-			/* don't want scsi_target_reap to do the final
-			 * put because it will be under the host lock */
-			scsi_target_destroy(starget);
+		if (error) {
+			dev_printk(KERN_ERR, dev,
+				"target allocation failed, error %d\n", error);
+			scsi_target_reap(starget);
 			return NULL;
 		}
 	}
+	starget->state = STARGET_CREATED;
 	get_device(dev);
 
 	return starget;
@@ -456,8 +440,7 @@ static struct scsi_target *scsi_alloc_ta
 	found_target->reap_ref++;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	if (found_target->state != STARGET_DEL) {
-		put_device(parent);
-		kfree(starget);
+		scsi_target_reap(starget);
 		return found_target;
 	}
 	/* Unfortunately, we found a dying target; need to
@@ -477,7 +460,8 @@ static struct scsi_target *scsi_alloc_ta
  */
 void scsi_target_reap(struct scsi_target *starget)
 {
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct device *dev = &starget->dev;
+	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
 	enum scsi_target_state state;
 	int empty;
@@ -493,10 +477,17 @@ void scsi_target_reap(struct scsi_target
 	BUG_ON(state == STARGET_DEL || !list_empty(&starget->devices));
 	starget->state = STARGET_DEL;
 	if (state == STARGET_RUNNING) {
-		transport_remove_device(&starget->dev);
-		device_del(&starget->dev);
+		transport_remove_device(dev);
+		device_del(dev);
 	}
-	scsi_target_destroy(starget);
+
+	transport_destroy_device(dev);
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (state != STARGET_NEW && shost->hostt->target_destroy)
+		shost->hostt->target_destroy(starget);
+	list_del_init(&starget->siblings);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	put_device(dev);
 }
 
 /**

