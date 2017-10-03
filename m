From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V8 4/8] block: pass 'op' to blk_queue_enter()
Date: Tue,  3 Oct 2017 22:04:02 +0800
Message-ID: <20171003140406.26060-5-ming.lei@redhat.com>
References: <20171003140406.26060-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171003140406.26060-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

We need to check if the request to be allocated is PREEMPT_ONLY,
and have to pass REQ_PREEEMPT flag to blk_queue_eneter(), so pass
'op' to blk_queue_enter() directly.

Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 11 ++++++-----
 block/blk-mq.c         |  3 ++-
 block/blk-timeout.c    |  2 +-
 fs/block_dev.c         |  4 ++--
 include/linux/blkdev.h |  2 +-
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 900eaa8eefa6..1bb566245d37 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -766,7 +766,7 @@ struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(blk_alloc_queue);
 
-int blk_queue_enter(struct request_queue *q, bool nowait)
+int blk_queue_enter(struct request_queue *q, unsigned int op)
 {
 	while (true) {
 		int ret;
@@ -774,7 +774,7 @@ int blk_queue_enter(struct request_queue *q, bool nowait)
 		if (percpu_ref_tryget_live(&q->q_usage_counter))
 			return 0;
 
-		if (nowait)
+		if (op & REQ_NOWAIT)
 			return -EBUSY;
 
 		/*
@@ -1408,8 +1408,8 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	/* create ioc upfront */
 	create_io_context(gfp_mask, q->node);
 
-	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM) ||
-			(op & REQ_NOWAIT));
+	ret = blk_queue_enter(q, (gfp_mask & __GFP_DIRECT_RECLAIM) ? op :
+			op | REQ_NOWAIT);
 	if (ret)
 		return ERR_PTR(ret);
 	spin_lock_irq(q->queue_lock);
@@ -1436,6 +1436,7 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
 		req = blk_mq_alloc_request(q, op,
 			(gfp_mask & __GFP_DIRECT_RECLAIM) ?
 				0 : BLK_MQ_REQ_NOWAIT);
+
 		if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
 			q->mq_ops->initialize_rq_fn(req);
 	} else {
@@ -2216,7 +2217,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 	do {
 		struct request_queue *q = bio->bi_disk->queue;
 
-		if (likely(blk_queue_enter(q, bio->bi_opf & REQ_NOWAIT) == 0)) {
+		if (likely(blk_queue_enter(q, bio->bi_opf) == 0)) {
 			struct bio_list lower, same;
 
 			/* Create a fresh bio_list for all subordinate requests */
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 10c1f49f663d..bf89549074bb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -384,7 +384,8 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 	struct request *rq;
 	int ret;
 
-	ret = blk_queue_enter(q, flags & BLK_MQ_REQ_NOWAIT);
+	ret = blk_queue_enter(q, !(flags & BLK_MQ_REQ_NOWAIT) ? op :
+			op | REQ_NOWAIT);
 	if (ret)
 		return ERR_PTR(ret);
 
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 17ec83bb0900..071c6de9154d 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -134,7 +134,7 @@ void blk_timeout_work(struct work_struct *work)
 	struct request *rq, *tmp;
 	int next_set = 0;
 
-	if (blk_queue_enter(q, true))
+	if (blk_queue_enter(q, REQ_NOWAIT))
 		return;
 	spin_lock_irqsave(q->queue_lock, flags);
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 93d088ffc05c..98cf2d7ee9d3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -674,7 +674,7 @@ int bdev_read_page(struct block_device *bdev, sector_t sector,
 	if (!ops->rw_page || bdev_get_integrity(bdev))
 		return result;
 
-	result = blk_queue_enter(bdev->bd_queue, false);
+	result = blk_queue_enter(bdev->bd_queue, 0);
 	if (result)
 		return result;
 	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, false);
@@ -710,7 +710,7 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 
 	if (!ops->rw_page || bdev_get_integrity(bdev))
 		return -EOPNOTSUPP;
-	result = blk_queue_enter(bdev->bd_queue, false);
+	result = blk_queue_enter(bdev->bd_queue, 0);
 	if (result)
 		return result;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ab6b6c0392c2..4c688385d866 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -960,7 +960,7 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
-extern int blk_queue_enter(struct request_queue *q, bool nowait);
+extern int blk_queue_enter(struct request_queue *q, unsigned int op);
 extern void blk_queue_exit(struct request_queue *q);
 extern void blk_start_queue(struct request_queue *q);
 extern void blk_start_queue_async(struct request_queue *q);
-- 
2.9.5
