From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/6] blk-mq: introduce blk_mq_unquiesce_queue
Date: Fri, 26 May 2017 11:07:34 +0800
Message-ID: <20170526030740.26959-2-ming.lei@redhat.com>
References: <20170526030740.26959-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170526030740.26959-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Now we use blk_mq_start_stopped_hw_queues() implictely
as pair of blk_mq_quiesce_queue(), now we introduce
blk_mq_unquiesce_queue() explictely.

Also this function is introduced for fixing
current quiescing mechanism, which will be done
in the following patches.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c         | 13 +++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f2224ffd225d..a26fee3fb389 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -181,6 +181,19 @@ void blk_mq_quiesce_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue);
 
+/**
+ * blk_mq_unquiesce_queue() - pair of blk_mq_quiesce_queue()
+ * @q: request queue.
+ *
+ * This function recovers queue into the state before quiescing
+ * done by blk_mq_quiesce_queue
+ */
+void blk_mq_unquiesce_queue(struct request_queue *q)
+{
+	blk_mq_start_stopped_hw_queues(q, true);
+}
+EXPORT_SYMBOL_GPL(blk_mq_unquiesce_queue);
+
 void blk_mq_wake_waiters(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ab92c4ea138b..41291be82ac4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -964,6 +964,7 @@ extern void __blk_run_queue_uncond(struct request_queue *q);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_run_queue_async(struct request_queue *q);
 extern void blk_mq_quiesce_queue(struct request_queue *q);
+extern void blk_mq_unquiesce_queue(struct request_queue *q);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);
-- 
2.9.4
