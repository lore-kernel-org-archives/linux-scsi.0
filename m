From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 6/8] block: flush: avoid to figure out flush queue unnecessarily
Date: Tue,  9 Sep 2014 21:05:47 +0800
Message-ID: <1410267949-21904-7-git-send-email-ming.lei@canonical.com>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

Just figuring out flush queue at the entry of kicking off flush
machinery and request's completion handler, then pass it through.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-flush.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 894a149..a9d6e01 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -91,7 +91,8 @@ enum {
 	FLUSH_PENDING_TIMEOUT	= 5 * HZ,
 };
 
-static bool blk_kick_flush(struct request_queue *q);
+static bool blk_kick_flush(struct request_queue *q,
+			   struct blk_flush_queue *fq);
 
 static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
 {
@@ -150,6 +151,7 @@ static bool blk_flush_queue_rq(struct request *rq, bool add_front)
 /**
  * blk_flush_complete_seq - complete flush sequence
  * @rq: FLUSH/FUA request being sequenced
+ * @fq: flush queue
  * @seq: sequences to complete (mask of %REQ_FSEQ_*, can be zero)
  * @error: whether an error occurred
  *
@@ -162,11 +164,11 @@ static bool blk_flush_queue_rq(struct request *rq, bool add_front)
  * RETURNS:
  * %true if requests were added to the dispatch queue, %false otherwise.
  */
-static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
-				   int error)
+static bool blk_flush_complete_seq(struct request *rq,
+				   struct blk_flush_queue *fq,
+				   unsigned int seq, int error)
 {
 	struct request_queue *q = rq->q;
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 	struct list_head *pending = &fq->flush_queue[fq->flush_pending_idx];
 	bool queued = false, kicked;
 
@@ -212,7 +214,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 		BUG();
 	}
 
-	kicked = blk_kick_flush(q);
+	kicked = blk_kick_flush(q, fq);
 	return kicked | queued;
 }
 
@@ -244,7 +246,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 		unsigned int seq = blk_flush_cur_seq(rq);
 
 		BUG_ON(seq != REQ_FSEQ_PREFLUSH && seq != REQ_FSEQ_POSTFLUSH);
-		queued |= blk_flush_complete_seq(rq, seq, error);
+		queued |= blk_flush_complete_seq(rq, fq, seq, error);
 	}
 
 	/*
@@ -270,6 +272,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 /**
  * blk_kick_flush - consider issuing flush request
  * @q: request_queue being kicked
+ * @fq: flush queue
  *
  * Flush related states of @q have changed, consider issuing flush request.
  * Please read the comment at the top of this file for more info.
@@ -280,9 +283,8 @@ static void flush_end_io(struct request *flush_rq, int error)
  * RETURNS:
  * %true if flush was issued, %false otherwise.
  */
-static bool blk_kick_flush(struct request_queue *q)
+static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq)
 {
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 	struct list_head *pending = &fq->flush_queue[fq->flush_pending_idx];
 	struct request *first_rq =
 		list_first_entry(pending, struct request, flush.list);
@@ -319,12 +321,13 @@ static bool blk_kick_flush(struct request_queue *q)
 static void flush_data_end_io(struct request *rq, int error)
 {
 	struct request_queue *q = rq->q;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
 	/*
 	 * After populating an empty queue, kick it to avoid stall.  Read
 	 * the comment in flush_end_io().
 	 */
-	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
+	if (blk_flush_complete_seq(rq, fq, REQ_FSEQ_DATA, error))
 		blk_run_queue_async(q);
 }
 
@@ -344,7 +347,7 @@ static void mq_flush_data_end_io(struct request *rq, int error)
 	 * the comment in flush_end_io().
 	 */
 	spin_lock_irqsave(&fq->mq_flush_lock, flags);
-	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
+	if (blk_flush_complete_seq(rq, fq, REQ_FSEQ_DATA, error))
 		blk_mq_run_hw_queue(hctx, true);
 	spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 }
@@ -366,6 +369,7 @@ void blk_insert_flush(struct request *rq)
 	struct request_queue *q = rq->q;
 	unsigned int fflags = q->flush_flags;	/* may change, cache */
 	unsigned int policy = blk_flush_policy(fflags, rq);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
 	/*
 	 * @policy now records what operations need to be done.  Adjust
@@ -414,18 +418,16 @@ void blk_insert_flush(struct request *rq)
 	rq->cmd_flags |= REQ_FLUSH_SEQ;
 	rq->flush.saved_end_io = rq->end_io; /* Usually NULL */
 	if (q->mq_ops) {
-		struct blk_flush_queue *fq = blk_get_flush_queue(q);
-
 		rq->end_io = mq_flush_data_end_io;
 
 		spin_lock_irq(&fq->mq_flush_lock);
-		blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
+		blk_flush_complete_seq(rq, fq, REQ_FSEQ_ACTIONS & ~policy, 0);
 		spin_unlock_irq(&fq->mq_flush_lock);
 		return;
 	}
 	rq->end_io = flush_data_end_io;
 
-	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
+	blk_flush_complete_seq(rq, fq, REQ_FSEQ_ACTIONS & ~policy, 0);
 }
 
 /**
-- 
1.7.9.5
