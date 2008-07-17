From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 7/8] scsi_dh: attach to hardware handler from
	dm-mpath
Date: Thu, 17 Jul 2008 16:53:27 -0700
Message-ID: <20080717235327.23056.59814.sendpatchset@chandra-ubuntu>
References: <20080717235245.23056.89788.sendpatchset@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080717235245.23056.89788.sendpatchset@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James.Bottomley@HansenPartnership.com, hare@suse.de, linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

multipath keeps a separate device table which may be
more current than the built-in one.
So we should make sure to always call ->attach whenever
a multipath map with hardware handler is instantiated.
And we should call ->detach on removal, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/md/dm-mpath.c                 |   13 +++++++
 drivers/scsi/device_handler/scsi_dh.c |   64 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_dh.h                |    2 +
 3 files changed, 79 insertions(+), 0 deletions(-)

Index: linux-2.6.26-git5/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.26-git5.orig/drivers/md/dm-mpath.c
+++ linux-2.6.26-git5/drivers/md/dm-mpath.c
@@ -147,9 +147,12 @@ static struct priority_group *alloc_prio
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
@@ -546,6 +549,7 @@ static struct pgpath *parse_path(struct 
 {
 	int r;
 	struct pgpath *p;
+	struct multipath *m = (struct multipath *) ti->private;
 
 	/* we need at least a path arg */
 	if (as->argc < 1) {
@@ -564,6 +568,15 @@ static struct pgpath *parse_path(struct 
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
Index: linux-2.6.26-git5/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.26-git5.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.26-git5/drivers/scsi/device_handler/scsi_dh.c
@@ -369,6 +369,70 @@ int scsi_dh_handler_exist(const char *na
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
Index: linux-2.6.26-git5/include/scsi/scsi_dh.h
===================================================================
--- linux-2.6.26-git5.orig/include/scsi/scsi_dh.h
+++ linux-2.6.26-git5/include/scsi/scsi_dh.h
@@ -58,6 +58,8 @@ enum {
 #if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
+extern int scsi_dh_attach(struct request_queue *, const char *);
+extern void scsi_dh_detach(struct request_queue *);
 #else
 static inline int scsi_dh_activate(struct request_queue *req)
 {
@@ -67,4 +69,12 @@ static inline int scsi_dh_handler_exist(
 {
 	return 0;
 }
+static inline int scsi_dh_attach(struct request_queue *req, const char *name)
+{
+	return SCSI_DH_NOSYS;
+}
+static inline void scsi_dh_detach(struct request_queue *q)
+{
+	return;
+}
 #endif
