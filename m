From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] dm-mpath, scsi_dh: don't let dm detach device handlers
Date: Sun, 10 May 2015 20:40:53 +0200
Message-ID: <1431283260-13406-2-git-send-email-hch@lst.de>
References: <1431283260-13406-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbbEJSmQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2015 14:42:16 -0400
In-Reply-To: <1431283260-13406-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

While allowing dm-mpath to attach device handlers is a functionality we need
for backwards compatibility reason there is no reason to reference count
them and detach them if dm-mpath stops using the device for some reason.

If the device handler works for the given device it can just stay attached,
and we can take the retain_hw_handler codepath.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c                 | 21 +++-----
 drivers/scsi/device_handler/scsi_dh.c | 96 ++++++++---------------------------
 include/scsi/scsi_device.h            |  1 -
 include/scsi/scsi_dh.h                |  5 --
 4 files changed, 28 insertions(+), 95 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6395347..0517b61 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -159,12 +159,9 @@ static struct priority_group *alloc_priority_group(void)
 static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
 {
 	struct pgpath *pgpath, *tmp;
-	struct multipath *m = ti->private;
 
 	list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
 		list_del(&pgpath->list);
-		if (m->hw_handler_name)
-			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
 		dm_put_device(ti, pgpath->path.dev);
 		free_pgpath(pgpath);
 	}
@@ -578,6 +575,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		q = bdev_get_queue(p->path.dev->bdev);
 
 	if (m->retain_attached_hw_handler) {
+retain:
 		attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
 		if (attached_handler_name) {
 			/*
@@ -597,20 +595,14 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	}
 
 	if (m->hw_handler_name) {
-		/*
-		 * Increments scsi_dh reference, even when using an
-		 * already-attached handler.
-		 */
 		r = scsi_dh_attach(q, m->hw_handler_name);
 		if (r == -EBUSY) {
-			/*
-			 * Already attached to different hw_handler:
-			 * try to reattach with correct one.
-			 */
-			scsi_dh_detach(q);
-			r = scsi_dh_attach(q, m->hw_handler_name);
+			char b[BDEVNAME_SIZE];
+	
+			printk(KERN_INFO "dm-mpath: retaining handler on device %s\n",
+				bdevname(p->path.dev->bdev, b));
+			goto retain;
 		}
-
 		if (r < 0) {
 			ti->error = "error attaching hardware handler";
 			dm_put_device(ti, p->path.dev);
@@ -622,7 +614,6 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 			if (r < 0) {
 				ti->error = "unable to set hardware "
 							"handler parameters";
-				scsi_dh_detach(q);
 				dm_put_device(ti, p->path.dev);
 				goto bad;
 			}
diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 1efebc9..869b5bd 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -100,14 +100,6 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
 {
 	struct scsi_dh_data *d;
 
-	if (sdev->scsi_dh_data) {
-		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
-			return -EBUSY;
-
-		kref_get(&sdev->scsi_dh_data->kref);
-		return 0;
-	}
-
 	if (!try_module_get(scsi_dh->module))
 		return -EINVAL;
 
@@ -120,7 +112,6 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
 	}
 
 	d->scsi_dh = scsi_dh;
-	kref_init(&d->kref);
 	d->sdev = sdev;
 
 	spin_lock_irq(sdev->request_queue->queue_lock);
@@ -129,12 +120,14 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
 	return 0;
 }
 
-static void __detach_handler (struct kref *kref)
+/*
+ * scsi_dh_handler_detach - Detach a device handler from a device
+ * @sdev - SCSI device the device handler should be detached from
+ */
+static void scsi_dh_handler_detach(struct scsi_device *sdev)
 {
-	struct scsi_dh_data *scsi_dh_data =
-		container_of(kref, struct scsi_dh_data, kref);
+	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
 	struct scsi_device_handler *scsi_dh = scsi_dh_data->scsi_dh;
-	struct scsi_device *sdev = scsi_dh_data->sdev;
 
 	scsi_dh->detach(sdev);
 
@@ -147,30 +140,6 @@ static void __detach_handler (struct kref *kref)
 }
 
 /*
- * scsi_dh_handler_detach - Detach a device handler from a device
- * @sdev - SCSI device the device handler should be detached from
- * @scsi_dh - Device handler to be detached
- *
- * Detach from a device handler. If a device handler is specified,
- * only detach if the currently attached handler matches @scsi_dh.
- */
-static void scsi_dh_handler_detach(struct scsi_device *sdev,
-				   struct scsi_device_handler *scsi_dh)
-{
-	if (!sdev->scsi_dh_data)
-		return;
-
-	if (scsi_dh && scsi_dh != sdev->scsi_dh_data->scsi_dh)
-		return;
-
-	if (!scsi_dh)
-		scsi_dh = sdev->scsi_dh_data->scsi_dh;
-
-	if (scsi_dh)
-		kref_put(&sdev->scsi_dh_data->kref, __detach_handler);
-}
-
-/*
  * Functions for sysfs attribute 'dh_state'
  */
 static ssize_t
@@ -198,7 +167,7 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 			/*
 			 * Detach from a device handler
 			 */
-			scsi_dh_handler_detach(sdev, scsi_dh);
+			scsi_dh_handler_detach(sdev);
 			err = 0;
 		} else if (!strncmp(buf, "activate", 8)) {
 			/*
@@ -290,7 +259,8 @@ static int scsi_dh_notifier(struct notifier_block *nb,
 			err = scsi_dh_handler_attach(sdev, devinfo);
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		device_remove_file(dev, &scsi_dh_state_attr);
-		scsi_dh_handler_detach(sdev, NULL);
+		if (sdev->scsi_dh_data)
+			scsi_dh_handler_detach(sdev);
 	}
 	return err;
 }
@@ -335,7 +305,8 @@ static int scsi_dh_notifier_remove(struct device *dev, void *data)
 
 	sdev = to_scsi_device(dev);
 
-	scsi_dh_handler_detach(sdev, scsi_dh);
+	if (sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh == scsi_dh)
+		scsi_dh_handler_detach(sdev);
 
 	put_device(dev);
 
@@ -517,45 +488,22 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 		err = -ENODEV;
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	if (!err) {
-		err = scsi_dh_handler_attach(sdev, scsi_dh);
-		put_device(&sdev->sdev_gendev);
-	}
-	return err;
-}
-EXPORT_SYMBOL_GPL(scsi_dh_attach);
-
-/*
- * scsi_dh_detach - Detach device handler
- * @q - Request queue that is associated with the scsi_device
- *      the handler should be detached from
- *
- * This function will detach the device handler only
- * if the sdev is not part of the internal list, ie
- * if it has been attached manually.
- */
-void scsi_dh_detach(struct request_queue *q)
-{
-	unsigned long flags;
-	struct scsi_device *sdev;
-	struct scsi_device_handler *scsi_dh = NULL;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
-	if (!sdev || !get_device(&sdev->sdev_gendev))
-		sdev = NULL;
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	if (!sdev)
-		return;
+	if (err)
+		return err;
 
 	if (sdev->scsi_dh_data) {
-		scsi_dh = sdev->scsi_dh_data->scsi_dh;
-		scsi_dh_handler_detach(sdev, scsi_dh);
+		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
+			err = -EBUSY;
+		goto out_put_device;
 	}
+
+	err = scsi_dh_handler_attach(sdev, scsi_dh);
+
+out_put_device:
 	put_device(&sdev->sdev_gendev);
+	return err;
 }
-EXPORT_SYMBOL_GPL(scsi_dh_detach);
+EXPORT_SYMBOL_GPL(scsi_dh_attach);
 
 /*
  * scsi_dh_attached_handler_name - Get attached device handler's name
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a4c9336..b711254 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -220,7 +220,6 @@ struct scsi_device_handler {
 struct scsi_dh_data {
 	struct scsi_device_handler *scsi_dh;
 	struct scsi_device *sdev;
-	struct kref kref;
 };
 
 #define	to_scsi_device(d)	\
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 620c723..99c9196 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -59,7 +59,6 @@ enum {
 extern int scsi_dh_activate(struct request_queue *, activate_complete, void *);
 extern int scsi_dh_handler_exist(const char *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
-extern void scsi_dh_detach(struct request_queue *);
 extern const char *scsi_dh_attached_handler_name(struct request_queue *, gfp_t);
 extern int scsi_dh_set_params(struct request_queue *, const char *);
 #else
@@ -77,10 +76,6 @@ static inline int scsi_dh_attach(struct request_queue *req, const char *name)
 {
 	return SCSI_DH_NOSYS;
 }
-static inline void scsi_dh_detach(struct request_queue *q)
-{
-	return;
-}
 static inline const char *scsi_dh_attached_handler_name(struct request_queue *q,
 							gfp_t gfp)
 {
-- 
1.9.1

