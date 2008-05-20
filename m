From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 7/7] scsi_dh: attach to hardware handler from
	dm-mpath
Date: Tue, 20 May 2008 16:05:53 +0200
Message-ID: <20080520140553.A393810B5DF@craiglockhart-ipmi.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


multipath keeps a separate device table which may be
more current than the built-in one.
So we should make sure to always call ->attach whenever
a multipath map with hardware handler is instantiated.
And we should call ->detach on removal, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c                 |   13 ++++++
 drivers/scsi/device_handler/scsi_dh.c |   74 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_dh.h                |    2 +
 3 files changed, 89 insertions(+), 0 deletions(-)

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
index b80fae7..a9404b5 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -362,6 +362,80 @@ int scsi_dh_handler_exist(const char *name)
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
+	int i, found = 0;
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
+		scsi_dh = sdev->scsi_dh_data->scsi_dh;
+		for(i = 0; scsi_dh->devlist[i].vendor; i++) {
+			if (!strncmp(sdev->vendor, scsi_dh->devlist[i].vendor,
+				     strlen(scsi_dh->devlist[i].vendor)) &&
+			    !strncmp(sdev->model, scsi_dh->devlist[i].model,
+				     strlen(scsi_dh->devlist[i].model))) {
+				found = 1;
+				break;
+			}
+		}
+		/* sdev not on internal list, detach */
+		if (!found)
+			scsi_dh_handler_detach(sdev);
+	}
+	put_device(&sdev->sdev_gendev);
+}
+EXPORT_SYMBOL_GPL(scsi_dh_detach);
+
 static struct notifier_block scsi_dh_nb = {
 	.notifier_call = scsi_dh_notifier
 };
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 5d05ac0..8032e51 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -59,3 +59,5 @@ enum {
 
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
+extern int scsi_dh_attach(struct request_queue *, const char *);
+extern void scsi_dh_detach(struct request_queue *q);
-- 
1.5.2.4
