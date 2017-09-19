From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 06/10] block: pass flags to blk_queue_enter()
Date: Tue, 19 Sep 2017 11:49:21 +0800
Message-ID: <20170919034925.9894-7-ming.lei@redhat.com>
References: <20170919034925.9894-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170919034925.9894-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

We need to pass PREEMPT flags to blk_queue_enter()
for allocating request with RQF_PREEMPT in the
following patch.

Tested-by: Cathy Avery <cavery@redhat.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 10 ++++++----
 block/blk-mq.c         |  5 +++--
 block/blk-timeout.c    |  2 +-
 fs/block_dev.c         |  4 ++--
 include/linux/blkdev.h |  7 ++++++-
 5 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8889920567d2..16131ea0f3b0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -779,7 +779,7 @@ struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(blk_alloc_queue);
 
-int blk_queue_enter(struct request_queue *q, bool nowait)
+int blk_queue_enter(struct request_queue *q, unsigned flags)
 {
 	while (true) {
 		int ret;
@@ -787,7 +787,7 @@ int blk_queue_enter(struct request_queue *q, bool nowait)
 		if (percpu_ref_tryget_live(&q->q_usage_counter))
 			return 0;
 
-		if (nowait)
+		if (flags & BLK_REQ_NOWAIT)
 			return -EBUSY;
 
 		/*
@@ -1418,7 +1418,8 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	/* create ioc upfront */
 	create_io_context(gfp_mask, q->node);
 
-	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM));
+	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM) ?
+			BLK_REQ_NOWAIT : 0);
 	if (ret)
 		return ERR_PTR(ret);
 	spin_lock_irq(q->queue_lock);
@@ -2225,7 +2226,8 @@ blk_qc_t generic_make_request(struct bio *bio)
 	do {
 		struct request_queue *q = bio->bi_disk->queue;
 
-		if (likely(blk_queue_enter(q, bio->bi_opf & REQ_NOWAIT) == 0)) {
+		if (likely(blk_queue_enter(q, (bio->bi_opf & REQ_NOWAIT) ?
+						BLK_REQ_NOWAIT : 0) == 0)) {
 			struct bio_list lower, same;
 
 			/* Create a fresh bio_list for all subordinate requests */
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 988da93d85a4..0c472f5a9176 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -377,7 +377,8 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 	struct request *rq;
 	int ret;
 
-	ret = blk_queue_enter(q, flags & BLK_MQ_REQ_NOWAIT);
+	ret = blk_queue_enter(q, (flags & BLK_MQ_REQ_NOWAIT) ?
+			BLK_REQ_NOWAIT : 0);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -416,7 +417,7 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	if (hctx_idx >= q->nr_hw_queues)
 		return ERR_PTR(-EIO);
 
-	ret = blk_queue_enter(q, true);
+	ret = blk_queue_enter(q, BLK_REQ_NOWAIT);
 	if (ret)
 		return ERR_PTR(ret);
 
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 17ec83bb0900..e803106a5e5b 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -134,7 +134,7 @@ void blk_timeout_work(struct work_struct *work)
 	struct request *rq, *tmp;
 	int next_set = 0;
 
-	if (blk_queue_enter(q, true))
+	if (blk_queue_enter(q, BLK_REQ_NOWAIT))
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
index b8053bcc6b5f..54450715915b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -857,6 +857,11 @@ enum {
 	BLKPREP_INVALID,	/* invalid command, kill, return -EREMOTEIO */
 };
 
+/* passed to blk_queue_enter */
+enum {
+	BLK_REQ_NOWAIT = (1 << 0),
+};
+
 extern unsigned long blk_max_low_pfn, blk_max_pfn;
 
 /*
@@ -962,7 +967,7 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
-extern int blk_queue_enter(struct request_queue *q, bool nowait);
+extern int blk_queue_enter(struct request_queue *q, unsigned flags);
 extern void blk_queue_exit(struct request_queue *q);
 extern void blk_start_queue(struct request_queue *q);
 extern void blk_start_queue_async(struct request_queue *q);
-- 
2.9.5
