From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 4/8] block: avoid to use q->flush_rq directly
Date: Tue,  9 Sep 2014 21:05:45 +0800
Message-ID: <1410267949-21904-5-git-send-email-ming.lei@canonical.com>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

This patch trys to use local variable to access flush request,
so that we can convert to per-queue flush machinery a bit easier.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-flush.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index a5b2a00..a59dd1a 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -225,7 +225,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 
 	if (q->mq_ops) {
 		spin_lock_irqsave(&q->mq_flush_lock, flags);
-		q->flush_rq->tag = -1;
+		flush_rq->tag = -1;
 	}
 
 	running = &q->flush_queue[q->flush_running_idx];
@@ -283,6 +283,7 @@ static bool blk_kick_flush(struct request_queue *q)
 	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
 	struct request *first_rq =
 		list_first_entry(pending, struct request, flush.list);
+	struct request *flush_rq = q->flush_rq;
 
 	/* C1 described at the top of this file */
 	if (q->flush_pending_idx != q->flush_running_idx || list_empty(pending))
@@ -300,16 +301,16 @@ static bool blk_kick_flush(struct request_queue *q)
 	 */
 	q->flush_pending_idx ^= 1;
 
-	blk_rq_init(q, q->flush_rq);
+	blk_rq_init(q, flush_rq);
 	if (q->mq_ops)
-		blk_mq_clone_flush_request(q->flush_rq, first_rq);
+		blk_mq_clone_flush_request(flush_rq, first_rq);
 
-	q->flush_rq->cmd_type = REQ_TYPE_FS;
-	q->flush_rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
-	q->flush_rq->rq_disk = first_rq->rq_disk;
-	q->flush_rq->end_io = flush_end_io;
+	flush_rq->cmd_type = REQ_TYPE_FS;
+	flush_rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
+	flush_rq->rq_disk = first_rq->rq_disk;
+	flush_rq->end_io = flush_end_io;
 
-	return blk_flush_queue_rq(q->flush_rq, false);
+	return blk_flush_queue_rq(flush_rq, false);
 }
 
 static void flush_data_end_io(struct request *rq, int error)
-- 
1.7.9.5
