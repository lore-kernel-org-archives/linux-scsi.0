From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4/7] Fix various bugs in the target code
Date: Mon, 10 Aug 2009 11:08:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908101104080.3208-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59391 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755180AbZHJPIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 11:08:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1276) fixes some bugs in the SCSI target code:

	In scsi_alloc_target(), a newly-created target was added to
	the host's list of targets before the host's target_alloc()
	method was called.

	In the same routine, if a match was found with an old target
	in the DEL state then that target's reap_ref was mistakenly
	incremented.  This is harmless, but it shouldn't happen.

	If we have to wait for an old target to disappear, instead of
	calling flush_scheduled_work() the patch calls
	schedule_timeout_uninterruptible(1).  After all, whatever is
	pinning the old target might not have anything to do with a
	workqueue.  Besides, flush_scheduled_work() is prone to
	deadlocks and should never be used by drivers.

	scsi_target_reap() changed starget->state outside the
	protection of the host lock.

	__scsi_add_device() called scsi_alloc_target() outside the
	protection of the host's scan_mutex, meaning that it might
	find an incompletely-initialized target or it might create
	a duplicate target.

	scsi_sysfs_add_sdev() would call transport_configure_device()
	for a target each time a new device was added under that
	target.  The call has been moved to scsi_target_add(), where
	it will be made only once.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -376,6 +376,9 @@ static struct scsi_target *__scsi_find_t
  *
  * The target is returned with an incremented reference, so the caller
  * is responsible for both reaping and doing a last put
+ *
+ * This routine should be called only under the protection of the host's
+ * scan_mutex.
  */
 static struct scsi_target *scsi_alloc_target(struct device *parent,
 					     int channel, uint id)
@@ -418,7 +421,6 @@ static struct scsi_target *scsi_alloc_ta
 	if (found_target)
 		goto found;
 
-	list_add_tail(&starget->siblings, &shost->__targets);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
 	transport_setup_device(dev);
@@ -433,22 +435,26 @@ static struct scsi_target *scsi_alloc_ta
 	}
 	spin_lock_irqsave(shost->host_lock, flags);
 	starget->state = STARGET_CREATED;
+	list_add_tail(&starget->siblings, &shost->__targets);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	get_device(dev);
 
 	return starget;
 
  found:
-	found_target->reap_ref++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
 	if (found_target->state != STARGET_DEL) {
+		found_target->reap_ref++;
+		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_target_reap(starget);
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
 
@@ -471,13 +477,14 @@ void scsi_target_reap(struct scsi_target
 	spin_lock_irqsave(shost->host_lock, flags);
 	state = starget->state;
 	empty = --starget->reap_ref == 0;
+	if (empty)
+		starget->state = STARGET_DEL;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (!empty)
 		return;
 
 	BUG_ON(state == STARGET_DEL || !list_empty(&starget->devices));
-	starget->state = STARGET_DEL;
 	if (state == STARGET_RUNNING) {
 		transport_remove_device(dev);
 		device_del(dev);
@@ -1487,27 +1494,29 @@ static int scsi_report_lun_scan(struct s
 struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 				      uint id, uint lun, void *hostdata)
 {
-	struct scsi_device *sdev = ERR_PTR(-ENODEV);
+	struct scsi_device *sdev = ERR_PTR(-ENOMEM);
 	struct device *parent = &shost->shost_gendev;
-	struct scsi_target *starget;
+	struct scsi_target *starget = NULL;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return ERR_PTR(-ENODEV);
 
-	starget = scsi_alloc_target(parent, channel, id);
-	if (!starget)
-		return ERR_PTR(-ENOMEM);
-
 	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-	if (scsi_host_scan_allowed(shost))
-		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
+	if (scsi_host_scan_allowed(shost)) {
+		starget = scsi_alloc_target(parent, channel, id);
+		if (starget)
+			scsi_probe_and_add_lun(starget, lun, NULL, &sdev,
+					1, hostdata);
+	}
 	mutex_unlock(&shost->scan_mutex);
-	scsi_target_reap(starget);
-	put_device(&starget->dev);
 
+	if (starget) {
+		scsi_target_reap(starget);
+		put_device(&starget->dev);
+	}
 	return sdev;
 }
 EXPORT_SYMBOL(__scsi_add_device);
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -822,6 +822,7 @@ static int scsi_target_add(struct scsi_t
 	}
 	transport_add_device(&starget->dev);
 	starget->state = STARGET_RUNNING;
+	transport_configure_device(&starget->dev);
 
 	return 0;
 }
@@ -850,7 +851,6 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	if (error)
 		return error;
 
-	transport_configure_device(&starget->dev);
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		put_device(sdev->sdev_gendev.parent);

