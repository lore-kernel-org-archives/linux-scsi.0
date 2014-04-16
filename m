From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] blk-mq: add blk_mq_requeue_request
Date: Wed, 16 Apr 2014 09:44:57 +0200
Message-ID: <1397634299-7466-7-git-send-email-hch@lst.de>
References: <1397634299-7466-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397634299-7466-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This allows to requeue a request that has been accepted by ->queue_rq
earlier.  This is needed by the SCSI layer in various error conditions.

The existing internal blk_mq_requeue_request is renamed to
__blk_mq_requeue_request as it is a lower level building block for this
funtionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         |   18 ++++++++++++++++--
 include/linux/blk-mq.h |    2 ++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7946f0b..99d3795 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -400,7 +400,7 @@ static void blk_mq_start_request(struct request *rq, bool last)
 		rq->cmd_flags |= REQ_END;
 }
 
-static void blk_mq_requeue_request(struct request *rq)
+static void __blk_mq_requeue_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
@@ -413,6 +413,20 @@ static void blk_mq_requeue_request(struct request *rq)
 		rq->nr_phys_segments--;
 }
 
+void blk_mq_requeue_request(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+
+	__blk_mq_requeue_request(rq);
+	blk_clear_rq_complete(rq);
+
+	trace_block_rq_requeue(q, rq);
+
+	BUG_ON(blk_queued_rq(rq));
+	blk_mq_insert_request(rq, true, true, false);
+}
+EXPORT_SYMBOL(blk_mq_requeue_request);
+
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
 {
 	return tags->rqs[tag];
@@ -600,7 +614,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 			 * time
 			 */
 			list_add(&rq->queuelist, &rq_list);
-			blk_mq_requeue_request(rq);
+			__blk_mq_requeue_request(rq);
 			break;
 		default:
 			pr_err("blk-mq: bad return on queue: %d\n", ret);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 391377e..ab469d5 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -153,6 +153,8 @@ void blk_mq_free_single_hw_queue(struct blk_mq_hw_ctx *, unsigned int);
 void blk_mq_end_io(struct request *rq, int error);
 void __blk_mq_end_io(struct request *rq, int error);
 
+void blk_mq_requeue_request(struct request *rq);
+
 void blk_mq_complete_request(struct request *rq);
 
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
-- 
1.7.10.4
