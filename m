From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Wed, 14 May 2008 16:43:38 +0200
Message-ID: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773AbYENOnj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 10:43:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


multipath keeps a separate device table which may be
more current than the built-in one.
So we should allow to override the multipath settings
by calling ->attach for each device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c                 |   10 ++++++
 drivers/scsi/device_handler/scsi_dh.c |   52 ++++++++++++++++++++++++++++++--
 include/scsi/scsi_dh.h                |    1 +
 3 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e8f704a..b69cd87 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -546,6 +546,7 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 {
 	int r;
 	struct pgpath *p;
+	struct multipath *m = (struct multipath *) ti->private;
 
 	/* we need at least a path arg */
 	if (as->argc < 1) {
@@ -564,6 +565,15 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
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
index 2dbf84b..dfca3db 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -113,8 +113,12 @@ int scsi_dh_handler_attach(struct scsi_device *sdev,
 {
 	int err = -EBUSY;
 
-	if (sdev->scsi_dh_data)
-		return err;
+	if (sdev->scsi_dh_data) {
+		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
+			return err;
+		else
+			return 0;
+	}
 
 	err = scsi_dh->attach(sdev);
 
@@ -163,8 +167,11 @@ static int scsi_dh_notifier(struct notifier_block *nb,
 		goto out;
 
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
-		scsi_dh_handler_attach(sdev, devinfo->handler);
-		device_create_file(dev, &scsi_dh_state_attr);
+		int err;
+
+		err = scsi_dh_handler_attach(sdev, devinfo->handler);
+		if (!err)
+			err = device_create_file(dev, &scsi_dh_state_attr);
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		if (sdev->scsi_dh_data == NULL)
 			goto out;
@@ -345,6 +352,43 @@ int scsi_dh_handler_exist(const char *name)
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
+	if (sdev && sdev->scsi_dh_data) {
+		if (sdev->scsi_dh_data->scsi_dh != scsi_dh) {
+			err = -EBUSY;
+		} else {
+			spin_unlock_irqrestore(q->queue_lock, flags);
+			return 0;
+		}
+	}
+	if (!err || !get_device(&sdev->sdev_gendev))
+		err = -ENODEV;
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (scsi_dh->attach)
+		err = scsi_dh->attach(sdev);
+	put_device(&sdev->sdev_gendev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_attach);
+
 static struct notifier_block scsi_dh_nb = {
 	.notifier_call = scsi_dh_notifier
 };
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 5d05ac0..567bd38 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -59,3 +59,4 @@ enum {
 
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
+extern int scsi_dh_attach(struct request_queue *, const char *);
-- 
1.5.2.4

