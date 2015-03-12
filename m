From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 6/7] dm: optimize dm_mq_queue_rq to _not_ use kthread if using pure blk-mq
Date: Wed, 11 Mar 2015 23:56:41 -0400
Message-ID: <1426132602-34331-7-git-send-email-snitzer@redhat.com>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

dm_mq_queue_rq() is in atomic context so care must be taken to not
sleep -- as such GFP_ATOMIC is used for the md->bs bioset allocations
and dm-mpath's call to blk_get_request().  In the future the bioset
allocations will hopefully go away (by removing support for partial
completions of a request).

But the kthread will still be used to queue work if blk-mq is used ontop
of old-style request_fn device(s).  Also prepare for supporting DM
blk-mq ontop of old-style request_fn device(s) if a new dm-mod
'use_blk_mq' parameter is set.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 65 +++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b5409ac..b0c965a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1074,9 +1074,10 @@ static void free_rq_clone(struct request *clone)
 
 	blk_rq_unprep_clone(clone);
 
-	if (clone->q && clone->q->mq_ops)
+	if (clone->q->mq_ops)
 		tio->ti->type->release_clone_rq(clone);
-	else
+	else if (!md->queue->mq_ops)
+		/* request_fn queue stacked on request_fn queue(s) */
 		free_clone_request(md, clone);
 
 	if (!md->queue->mq_ops)
@@ -1835,15 +1836,25 @@ static int setup_clone(struct request *clone, struct request *rq,
 static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 				struct dm_rq_target_io *tio, gfp_t gfp_mask)
 {
-	struct request *clone = alloc_clone_request(md, gfp_mask);
+	/*
+	 * Do not allocate a clone if tio->clone was already set
+	 * (see: dm_mq_queue_rq).
+	 */
+	bool alloc_clone = !tio->clone;
+	struct request *clone;
 
-	if (!clone)
-		return NULL;
+	if (alloc_clone) {
+		clone = alloc_clone_request(md, gfp_mask);
+		if (!clone)
+			return NULL;
+	} else
+		clone = tio->clone;
 
 	blk_rq_init(NULL, clone);
 	if (setup_clone(clone, rq, tio, gfp_mask)) {
 		/* -ENOMEM */
-		free_clone_request(md, clone);
+		if (alloc_clone)
+			free_clone_request(md, clone);
 		return NULL;
 	}
 
@@ -1861,7 +1872,8 @@ static void init_tio(struct dm_rq_target_io *tio, struct request *rq,
 	tio->orig = rq;
 	tio->error = 0;
 	memset(&tio->info, 0, sizeof(tio->info));
-	init_kthread_work(&tio->work, map_tio_request);
+	if (md->kworker_task)
+		init_kthread_work(&tio->work, map_tio_request);
 }
 
 static struct dm_rq_target_io *prep_tio(struct request *rq,
@@ -1938,7 +1950,7 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
 		}
 		if (IS_ERR(clone))
 			return DM_MAPIO_REQUEUE;
-		if (setup_clone(clone, rq, tio, GFP_NOIO)) {
+		if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
 			/* -ENOMEM */
 			ti->type->release_clone_rq(clone);
 			return DM_MAPIO_REQUEUE;
@@ -2403,7 +2415,7 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 	p->bs = NULL;
 
 out:
-	/* mempool bind completed, now no need any mempools in the table */
+	/* mempool bind completed, no longer need any mempools in the table */
 	dm_table_free_md_mempools(t);
 }
 
@@ -2708,17 +2720,25 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	/* Init tio using md established in .init_request */
 	init_tio(tio, rq, md);
 
+	/*
+	 * Establish tio->ti before queuing work (map_tio_request)
+	 * or making direct call to map_request().
+	 */
+	tio->ti = ti;
+
 	/* Clone the request if underlying devices aren't blk-mq */
 	if (dm_table_get_type(map) == DM_TYPE_REQUEST_BASED) {
-		// FIXME: make the memory for clone part of the pdu
+		/* clone request is allocated at the end of the pdu */
+		tio->clone = (void *)blk_mq_rq_to_pdu(rq) + sizeof(struct dm_rq_target_io);
 		if (!clone_rq(rq, md, tio, GFP_ATOMIC))
 			return BLK_MQ_RQ_QUEUE_BUSY;
+		queue_kthread_work(&md->kworker, &tio->work);
+	} else {
+		/* Direct call is fine since .queue_rq allows allocations */
+		if (map_request(tio, rq, md) == DM_MAPIO_REQUEUE)
+			dm_requeue_unmapped_original_request(md, rq);
 	}
 
-	/* Establish tio->ti before queuing work (map_tio_request) */
-	tio->ti = ti;
-	queue_kthread_work(&md->kworker, &tio->work);
-
 	return BLK_MQ_RQ_QUEUE_OK;
 }
 
@@ -2731,6 +2751,7 @@ static struct blk_mq_ops dm_mq_ops = {
 
 static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
 {
+	unsigned md_type = dm_get_md_type(md);
 	struct request_queue *q;
 	int err;
 
@@ -2740,9 +2761,11 @@ static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
 	md->tag_set.numa_node = NUMA_NO_NODE;
 	md->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
 	md->tag_set.nr_hw_queues = 1;
-	// FIXME: make the memory for non-blk-mq clone part of the pdu
-	// would need to be done only if new 'use_blk_mq' is set in DM sysfs
-	md->tag_set.cmd_size = sizeof(struct dm_rq_target_io);
+	if (md_type == DM_TYPE_REQUEST_BASED) {
+		/* make the memory for non-blk-mq clone part of the pdu */
+		md->tag_set.cmd_size = sizeof(struct dm_rq_target_io) + sizeof(struct request);
+	} else
+		md->tag_set.cmd_size = sizeof(struct dm_rq_target_io);
 	md->tag_set.driver_data = md;
 
 	err = blk_mq_alloc_tag_set(&md->tag_set);
@@ -2760,7 +2783,8 @@ static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
 	/* backfill 'mq' sysfs registration normally done in blk_register_queue */
 	blk_mq_register_disk(md->disk);
 
-	init_rq_based_worker_thread(md);
+	if (md_type == DM_TYPE_REQUEST_BASED)
+		init_rq_based_worker_thread(md);
 
 	return 0;
 
@@ -2879,7 +2903,7 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
-	if (dm_request_based(md))
+	if (dm_request_based(md) && md->kworker_task)
 		flush_kthread_worker(&md->kworker);
 
 	/*
@@ -3133,7 +3157,8 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 	 */
 	if (dm_request_based(md)) {
 		stop_queue(md->queue);
-		flush_kthread_worker(&md->kworker);
+		if (md->kworker_task)
+			flush_kthread_worker(&md->kworker);
 	}
 
 	flush_workqueue(md->wq);
-- 
1.9.5 (Apple Git-50.3)
