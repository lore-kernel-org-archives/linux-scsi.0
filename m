From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCHv2] scsi: use 'scsi_device_from_queue()' for scsi_dh
Date: Thu, 16 Feb 2017 12:13:53 -0500
Message-ID: <20170216171353.GA17828@localhost.localdomain>
References: <1487257943-72264-1-git-send-email-hare@suse.de>
 <20170216170519.GA9630@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38552 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932193AbdBPRFa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 12:05:30 -0500
Content-Disposition: inline
In-Reply-To: <20170216170519.GA9630@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>

On Thu, Feb 16, 2017 at 12:05:19PM -0500, Keith Busch wrote:
> On Thu, Feb 16, 2017 at 04:12:23PM +0100, Hannes Reinecke wrote:
> > The device handler needs to check if a given queue belongs to
> > a scsi device; only then does it make sense to attach a device
> > handler.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.com>
> 
> The thing I don't like is that this still has dm-mpath directly calling
> into scsi. I don't think dm-mpath has any business calling protocol
> specific APIs, and doesn't help other protocols with similar needs.
> 
> Can we solve this with an indirection layer instead? 
> 
> (untested; just checking if this direction is preferable)

Eh osrry, I accidently included unrelated stuff in the previous. Here's
what I meant to send:

---
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 3570bcb..28310a2 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -847,7 +847,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags)) {
 retain:
-		attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
+		attached_handler_name = blk_dh_attached_handler_name(q, GFP_KERNEL);
 		if (attached_handler_name) {
 			/*
 			 * Clear any hw_handler_params associated with a
@@ -870,7 +870,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	}
 
 	if (m->hw_handler_name) {
-		r = scsi_dh_attach(q, m->hw_handler_name);
+		r = blk_dh_attach(q, m->hw_handler_name);
 		if (r == -EBUSY) {
 			char b[BDEVNAME_SIZE];
 
@@ -885,7 +885,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		}
 
 		if (m->hw_handler_params) {
-			r = scsi_dh_set_params(q, m->hw_handler_params);
+			r = blk_dh_set_params(q, m->hw_handler_params);
 			if (r < 0) {
 				ti->error = "unable to set hardware "
 							"handler parameters";
@@ -1526,7 +1526,7 @@ static void activate_path(struct work_struct *work)
 	struct request_queue *q = bdev_get_queue(pgpath->path.dev->bdev);
 
 	if (pgpath->is_active && !blk_queue_dying(q))
-		scsi_dh_activate(q, pg_init_done, pgpath);
+		blk_dh_activate(q, pg_init_done, pgpath);
 	else
 		pg_init_done(pgpath, SCSI_DH_DEV_OFFLINED);
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9e1e14..e23c7d5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2028,6 +2028,13 @@ static u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 	return bounce_limit;
 }
 
+static struct dh_ops scsi_dh_ops = {
+	.dh_activate = scsi_dh_activate,
+	.dh_attach = scsi_dh_attach,
+	.dh_attached_handler_name = scsi_dh_attached_handler_name,
+	.dh_set_params = scsi_dh_set_params,
+};
+
 static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 {
 	struct device *dev = shost->dma_dev;
@@ -2062,6 +2069,8 @@ static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 	 * blk_queue_update_dma_alignment() later.
 	 */
 	blk_queue_dma_alignment(q, 0x03);
+
+	q->dh_ops = &scsi_dh_ops;
 }
 
 struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1ca8e8f..5899768 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -378,6 +378,14 @@ static inline int blkdev_reset_zones_ioctl(struct block_device *bdev,
 
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+typedef void (*activate_complete)(void *, int);
+struct dh_ops {
+	int (*dh_activate)(struct request_queue *, activate_complete, void *);
+	int (*dh_attach)(struct request_queue *, const char *);
+	const char *(*dh_attached_handler_name)(struct request_queue *, gfp_t);
+	int (*dh_set_params)(struct request_queue *, const char *);
+};
+
 struct request_queue {
 	/*
 	 * Together with queue_head for cacheline sharing
@@ -408,6 +416,7 @@ struct request_queue {
 	lld_busy_fn		*lld_busy_fn;
 
 	struct blk_mq_ops	*mq_ops;
+	struct dh_ops 		*dh_ops;
 
 	unsigned int		*mq_map;
 
@@ -572,6 +581,35 @@ struct request_queue {
 	bool			mq_sysfs_init_done;
 };
 
+static inline int blk_dh_activate(struct request_queue *q, activate_complete fn, void *data)
+{
+	if (q->dh_ops && q->dh_ops->dh_activate)
+		return q->dh_ops->dh_activate(q, fn, data);
+	fn(data, 0);
+	return 0;
+}
+
+static inline int blk_dh_attach(struct request_queue *q, const char *name)
+{
+	if (q->dh_ops && q->dh_ops->dh_attach)
+		return q->dh_ops->dh_attach(q, name);
+	return 0;
+}
+
+static inline const char *blk_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
+{
+	if (q->dh_ops && q->dh_ops->dh_attached_handler_name)
+		return q->dh_ops->dh_attached_handler_name(q, gfp);
+	return NULL;
+}
+
+static inline int blk_dh_set_params(struct request_queue *q, const char *params)
+{
+	if (q->dh_ops && q->dh_ops->dh_set_params)
+		return q->dh_ops->dh_set_params(q, params);
+	return 0;
+}
+
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
 #define QUEUE_FLAG_STOPPED	2	/* queue is stopped */
 #define	QUEUE_FLAG_SYNCFULL	3	/* read queue has been filled */
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index c7bba2b..9169a66 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -57,7 +57,6 @@ enum {
 	SCSI_DH_DRIVER_MAX,
 };
 
-typedef void (*activate_complete)(void *, int);
 struct scsi_device_handler {
 	/* Used by the infrastructure */
 	struct list_head list; /* list of scsi_device_handlers */
--
