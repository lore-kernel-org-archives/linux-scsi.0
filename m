From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 7/8] scsi_dh: attach to hardware handler from dm-mpath
Date: Thu, 17 Jul 2008 09:39:17 +0200
Message-ID: <20080717073917.36E0F18C6FD@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbYGQHjS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 03:39:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org


multipath keeps a separate device table which may be
more current than the built-in one.
So we should make sure to always call ->attach whenever
a multipath map with hardware handler is instantiated.
And we should call ->detach on removal, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c                 |   13 +++++++
 drivers/scsi/device_handler/scsi_dh.c |   64 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_dh.h                |    2 +
 3 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e8f704a..bd2bcf4 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -147,9 +147,12 @@ static struct priority_group *alloc_priority_group(void)
 static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
 {
 	struct pgpath *pgpath, *tmp;
+	struct multipath *m = (struct multipath *) ti->private;
 
 	list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
 		list_del(&pgpath->list);
+		if (m->hw_handler_name)
+			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
 		dm_put_device(ti, pgpath->path.dev);
 		free_pgpath(pgpath);
 	}
@@ -546,6 +549,7 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 {
 	int r;
 	struct pgpath *p;
+	struct multipath *m = (struct multipath *) ti->private;
 
 	/* we need at least a path arg */
 	if (as->argc < 1) {
@@ -564,6 +568,15 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 		goto bad;
 	}
 
+	if (m->hw_handler_name) {
+		r = scsi_dh_attach(bdev_get_queue(p->path.dev->bdev),
+				   m->hw_handler_name);
+		if (r < 0) {
+			dm_put_device(ti, p->path.dev);
+			goto bad;
+		}
+	}
+
 	r = ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->error);
 	if (r) {
 		dm_put_device(ti, p->path.dev);
diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index e90df9d..a915968 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -369,6 +369,70 @@ int scsi_dh_handler_exist(const char *name)
 }
 EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
 
+/*
+ * scsi_dh_handler_attach - Attach device handler
+ * @sdev - sdev the handler should be attached to
+ * @name - name of the handler to attach
+ */
+int scsi_dh_attach(struct request_queue *q, const char *name)
+{
+	unsigned long flags;
+	struct scsi_device *sdev;
+	struct scsi_device_handler *scsi_dh;
+	int err = 0;
+
+	scsi_dh = get_device_handler(name);
+	if (!scsi_dh)
+		return -EINVAL;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	sdev = q->queuedata;
+	if (!sdev || !get_device(&sdev->sdev_gendev))
+		err = -ENODEV;
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (!err) {
+		err = scsi_dh_handler_attach(sdev, scsi_dh);
+
+		put_device(&sdev->sdev_gendev);
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_attach);
+
+/*
+ * scsi_dh_handler_detach - Detach device handler
+ * @sdev - sdev the handler should be detached from
+ *
+ * This function will detach the device handler only
+ * if the sdev is not part of the internal list, ie
+ * if it has been attached manually.
+ */
+void scsi_dh_detach(struct request_queue *q)
+{
+	unsigned long flags;
+	struct scsi_device *sdev;
+	struct scsi_device_handler *scsi_dh = NULL;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	sdev = q->queuedata;
+	if (!sdev || !get_device(&sdev->sdev_gendev))
+		sdev = NULL;
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (!sdev)
+		return;
+
+	if (sdev->scsi_dh_data) {
+		/* if sdev is not on internal list, detach */
+		scsi_dh = sdev->scsi_dh_data->scsi_dh;
+		if (!device_handler_match(scsi_dh, sdev))
+			scsi_dh_handler_detach(sdev, scsi_dh);
+	}
+	put_device(&sdev->sdev_gendev);
+}
+EXPORT_SYMBOL_GPL(scsi_dh_detach);
+
 static struct notifier_block scsi_dh_nb = {
 	.notifier_call = scsi_dh_notifier
 };
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 3b486d9..78ba73f 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -58,3 +58,5 @@ enum {
 
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
+extern int scsi_dh_attach(struct request_queue *, const char *);
+extern void scsi_dh_detach(struct request_queue *q);
-- 
1.5.2.4

