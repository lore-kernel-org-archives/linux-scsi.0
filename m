From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4/6] SCSI: simplify target destruction
Date: Fri, 29 May 2009 16:06:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905291555370.2648-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40246 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753502AbZE2UGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 16:06:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1249) adds an extra state, STARGET_NEW, to the SCSI
target state model.  A target is in this state initially and changes
over to STARGET_CREATED when the hostt->target_alloc() call has been
made.

This simplifies target destruction.  There's no need for a separate
scsi_target_destroy() function; everything can be handled within
scsi_target_reap().  The error paths are more robust because now it's
easy to verify that all the destructors are called along every
pathway.

The patch also fixes a few bugs in the existing code:

	In scsi_alloc_target(), if a match was found with an old
	target in the DEL state then that target's reap_ref was
	mistakenly incremented.  This is harmless, but it shouldn't
	happen.

	In the same routine, if we have to wait for an old target to
	disappear, instead of calling flush_scheduled_work() the patch
	calls schedule_timeout_uninterruptible(1).  After all,
	whatever is pinning the old target might not have anything to
	do with a workqueue.  Besides, flush_scheduled_work() is prone
	to deadlocks and should never be used by drivers.

	scsi_target_reap() changed starget->state outside the
	protection of the host lock.

	scsi_sysfs_add_sdev() would call transport_configure_device()
	for a target each time a new device was added under that
	target.  The call has been moved to scsi_target_add(), where
	it will be made only once.

In addition, the existing code is slightly improved in a couple of spots:

	__scsi_remove_target() is simplified by replacing reap_ref
	operations with calls to get_device()/put_device().

	An unnecessary local variable is eliminated from
	scsi_remove_target().


Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

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
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -438,31 +423,37 @@ static struct scsi_target *scsi_alloc_ta
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
+	spin_lock_irqsave(shost->host_lock, flags);
+	starget->state = STARGET_CREATED;
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	get_device(dev);
 
 	return starget;
 
  found:
-	found_target->reap_ref++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
 	if (found_target->state != STARGET_DEL) {
-		put_device(parent);
-		kfree(starget);
+		/* The state can't be STARGET_NEW because we are serialized
+		 * by shost->scan_mutex.
+		 */
+		found_target->reap_ref++;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		put_device(dev);
 		return found_target;
 	}
-	/* Unfortunately, we found a dying target; need to
-	 * wait until it's dead before we can get a new one */
+
+	/* Unfortunately, we found a dying target; we need to
+	 * wait until it's gone before we can get a new one.
+	 */
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(&found_target->dev);
-	flush_scheduled_work();
+	schedule_timeout_uninterruptible(1);
 	goto retry;
 }
 
@@ -479,23 +470,32 @@ void scsi_target_reap(struct scsi_target
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
 	enum scsi_target_state state;
-	int empty;
+	int reap_ref;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	state = starget->state;
-	empty = --starget->reap_ref == 0;
+	reap_ref = --starget->reap_ref;
+	if (reap_ref == 0)
+		starget->state = STARGET_DEL;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (!empty)
+	BUG_ON(state == STARGET_DEL || reap_ref < 0);
+	if (reap_ref > 0)
 		return;
+	BUG_ON(!list_empty(&starget->devices));
 
-	BUG_ON(state == STARGET_DEL || !list_empty(&starget->devices));
-	starget->state = STARGET_DEL;
 	if (state == STARGET_RUNNING) {
-		transport_remove_device(&starget->dev);
 		device_del(&starget->dev);
+		transport_remove_device(&starget->dev);
 	}
-	scsi_target_destroy(starget);
+
+	if (state == STARGET_CREATED && shost->hostt->target_destroy)
+		shost->hostt->target_destroy(starget);
+	transport_destroy_device(&starget->dev);
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del_init(&starget->siblings);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	put_device(&starget->dev);
 }
 
 /**
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -839,6 +839,7 @@ static int scsi_target_add(struct scsi_t
 	}
 	transport_add_device(&starget->dev);
 	starget->state = STARGET_RUNNING;
+	transport_configure_device(&starget->dev);
 
 	return 0;
 }
@@ -867,7 +868,6 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	if (error)
 		return error;
 
-	transport_configure_device(&starget->dev);
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		put_device(sdev->sdev_gendev.parent);
@@ -976,8 +976,8 @@ static void __scsi_remove_target(struct 
 	unsigned long flags;
 	struct scsi_device *sdev;
 
+	get_device(&starget->dev);
 	spin_lock_irqsave(shost->host_lock, flags);
-	starget->reap_ref++;
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
@@ -990,7 +990,7 @@ static void __scsi_remove_target(struct 
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	scsi_target_reap(starget);
+	put_device(&starget->dev);
 }
 
 static int __remove_child (struct device * dev, void * data)
@@ -1010,16 +1010,14 @@ static int __remove_child (struct device
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
 


