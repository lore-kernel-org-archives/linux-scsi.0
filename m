From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [RFC 1/2] fix our current target reap infrastructure.
Date: Mon, 16 Dec 2013 07:12:52 -0800
Message-ID: <1387206772.2200.7.camel@dabdike.int.hansenpartnership.com>
References: <1387206619.2200.6.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33509 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978Ab3LPPMy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 10:12:54 -0500
In-Reply-To: <1387206619.2200.6.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>

This patch eliminates the reap_ref and replaces it with a proper kref.
On last put of this kref, the target is removed from visibility in
sysfs.  The final call to scsi_target_reap() for the device is done from
__scsi_remove_device() and only if the device was made visible.  This
ensures that the target disappears as soon as the last device is gone
rather than waiting until final release of the device (which is often
too long).

---
 drivers/scsi/scsi_scan.c   | 89 +++++++++++++++++++++++++++-------------------
 drivers/scsi/scsi_sysfs.c  | 15 ++++----
 include/scsi/scsi_device.h |  3 +-
 3 files changed, 63 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..39e5c85 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -371,6 +371,31 @@ static struct scsi_target *__scsi_find_target(struct device *parent,
 }
 
 /**
+ * scsi_target_reap_ref_release - remove target from visibility
+ * @kref: the reap_ref in the target being released
+ *
+ * Called on last put of reap_ref, which is the indication that no device
+ * under this target is visible anymore, so render the target invisible in
+ * sysfs.  Note: we have to be in user context here because the target reaps
+ * should be done in places where the scsi device visibility is being removed.
+ */
+static void scsi_target_reap_ref_release(struct kref *kref)
+{
+	struct scsi_target *starget
+		= container_of(kref, struct scsi_target, reap_ref);
+
+	transport_remove_device(&starget->dev);
+	device_del(&starget->dev);
+	starget->state = STARGET_DEL;
+	scsi_target_destroy(starget);
+}
+
+static void scsi_target_reap_ref_put(struct scsi_target *starget)
+{
+	kref_put(&starget->reap_ref, scsi_target_reap_ref_release);
+}
+
+/**
  * scsi_alloc_target - allocate a new or find an existing target
  * @parent:	parent of the target (need not be a scsi host)
  * @channel:	target channel number (zero if no channels)
@@ -401,7 +426,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	}
 	dev = &starget->dev;
 	device_initialize(dev);
-	starget->reap_ref = 1;
+	kref_init(&starget->reap_ref);
 	dev->parent = get_device(parent);
 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
 	dev->bus = &scsi_bus_type;
@@ -441,29 +466,32 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	return starget;
 
  found:
-	found_target->reap_ref++;
+	if (!kref_get_unless_zero(&found_target->reap_ref))
+		/*
+		 * release routine already fired.  Target is dead, but
+		 * STARGET_DEL may not yet be set (set in the release
+		 * routine), so set here as well, just in case
+		 */
+		found_target->state = STARGET_DEL;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	if (found_target->state != STARGET_DEL) {
 		put_device(dev);
 		return found_target;
 	}
-	/* Unfortunately, we found a dying target; need to
-	 * wait until it's dead before we can get a new one */
+	/*
+	 * Unfortunately, we found a dying target; need to wait until it's
+	 * dead before we can get a new one.  There is an anomaly here.  We
+	 * *should* call scsi_target_reap() to balance the kref_get() of the
+	 * reap_ref above.  However, since the target is in state STARGET_DEL,
+	 * it's already invisible and the reap_ref is irrelevant.  If we call
+	 * scsi_target_reap() we might spuriously do another device_del() on
+	 * an already invisible target.
+	 */
 	put_device(&found_target->dev);
 	flush_scheduled_work();
 	goto retry;
 }
 
-static void scsi_target_reap_usercontext(struct work_struct *work)
-{
-	struct scsi_target *starget =
-		container_of(work, struct scsi_target, ew.work);
-
-	transport_remove_device(&starget->dev);
-	device_del(&starget->dev);
-	scsi_target_destroy(starget);
-}
-
 /**
  * scsi_target_reap - check to see if target is in use and destroy if not
  * @starget: target to be checked
@@ -474,28 +502,11 @@ static void scsi_target_reap_usercontext(struct work_struct *work)
  */
 void scsi_target_reap(struct scsi_target *starget)
 {
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	unsigned long flags;
-	enum scsi_target_state state;
-	int empty = 0;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	state = starget->state;
-	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
-		empty = 1;
-		starget->state = STARGET_DEL;
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (!empty)
-		return;
-
-	BUG_ON(state == STARGET_DEL);
-	if (state == STARGET_CREATED)
+	BUG_ON(starget->state == STARGET_DEL);
+	if (starget->state == STARGET_CREATED)
 		scsi_target_destroy(starget);
 	else
-		execute_in_process_context(scsi_target_reap_usercontext,
-					   &starget->ew);
+		scsi_target_reap_ref_put(starget);
 }
 
 /**
@@ -1532,6 +1543,10 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	}
 	mutex_unlock(&shost->scan_mutex);
 	scsi_autopm_put_target(starget);
+	/*
+	 * paired with scsi_alloc_target().  Target will be destroyed unless
+	 * scsi_probe_and_add_lun made an underlying device visible
+	 */
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
 
@@ -1612,8 +1627,10 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
 
  out_reap:
 	scsi_autopm_put_target(starget);
-	/* now determine if the target has any children at all
-	 * and if not, nuke it */
+	/*
+	 * paired with scsi_alloc_target(): determine if the target has
+	 * any children at all and if not, nuke it
+	 */
 	scsi_target_reap(starget);
 
 	put_device(&starget->dev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9117d0b..34eab7b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -383,17 +383,14 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 {
 	struct scsi_device *sdev;
 	struct device *parent;
-	struct scsi_target *starget;
 	struct list_head *this, *tmp;
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
 	parent = sdev->sdev_gendev.parent;
-	starget = to_scsi_target(parent);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
@@ -413,8 +410,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
-	scsi_target_reap(scsi_target(sdev));
-
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -1001,6 +996,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		return error;
 	}
 	transport_add_device(&sdev->sdev_gendev);
+	kref_get(&starget->reap_ref); /* device now visible, so target is held */
 	sdev->is_visible = 1;
 
 	/* create queue files, which may be writable, depending on the host */
@@ -1055,6 +1051,13 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
+		/*
+		 * Paired with the kref_get() in scsi_sysfs_add_sdev().  We're
+		 * removing sysfs visibility from the device, so make the
+		 * target invisible if this was the last device underneath it.
+		 */
+		scsi_target_reap(scsi_target(sdev));
+
 	} else
 		put_device(&sdev->sdev_dev);
 
@@ -1133,7 +1136,7 @@ void scsi_remove_target(struct device *dev)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			/* assuming new targets arrive at the end */
-			starget->reap_ref++;
+			kref_get(&starget->reap_ref);
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			if (last)
 				scsi_target_reap(last);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d65fbec..24b9e06 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -257,7 +257,7 @@ struct scsi_target {
 	struct list_head	siblings;
 	struct list_head	devices;
 	struct device		dev;
-	unsigned int		reap_ref; /* protected by the host lock */
+	struct kref		reap_ref; /* last put renders device invisible */
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
@@ -284,7 +284,6 @@ struct scsi_target {
 #define SCSI_DEFAULT_TARGET_BLOCKED	3
 
 	char			scsi_level;
-	struct execute_work	ew;
 	enum scsi_target_state	state;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */
-- 
1.8.4.3



