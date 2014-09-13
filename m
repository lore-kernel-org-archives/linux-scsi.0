From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] blk-mq: unshared timeout handler
Date: Sat, 13 Sep 2014 16:40:12 -0700
Message-ID: <1410651613-1993-6-git-send-email-hch@lst.de>
References: <1410651613-1993-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410651613-1993-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Duplicate the (small) timeout handler in blk-mq so that we can pass
arguments more easily to the driver timeout handler.  This enables
the next patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c      | 53 +++++++++++++++++++++++++++++++++++++----------------
 block/blk-timeout.c |  8 ++------
 block/blk.h         |  2 --
 3 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2d96b0d..c14d397 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -511,9 +511,15 @@ struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
 }
 EXPORT_SYMBOL(blk_mq_tag_to_rq);
 
-static enum blk_eh_timer_return blk_mq_rq_timed_out(struct request *rq)
+struct blk_mq_timeout_data {
+	unsigned long next;
+	unsigned int next_set;
+};
+
+static void blk_mq_rq_timed_out(struct request *req)
 {
-	struct request_queue *q = rq->q;
+	struct blk_mq_ops *ops = req->q->mq_ops;
+	enum blk_eh_timer_return ret = BLK_EH_RESET_TIMER;
 
 	/*
 	 * We know that complete is set at this point. If STARTED isn't set
@@ -524,27 +530,43 @@ static enum blk_eh_timer_return blk_mq_rq_timed_out(struct request *rq)
 	 * we both flags will get cleared. So check here again, and ignore
 	 * a timeout event with a request that isn't active.
 	 */
-	if (!test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
-		return BLK_EH_NOT_HANDLED;
-
-	if (!q->mq_ops->timeout)
-		return BLK_EH_RESET_TIMER;
+	if (!test_bit(REQ_ATOM_STARTED, &req->atomic_flags))
+		return;
 
-	return q->mq_ops->timeout(rq);
+	if (ops->timeout)
+		ret = ops->timeout(req);
+
+	switch (ret) {
+	case BLK_EH_HANDLED:
+		__blk_mq_complete_request(req);
+		break;
+	case BLK_EH_RESET_TIMER:
+		blk_add_timer(req);
+		blk_clear_rq_complete(req);
+		break;
+	case BLK_EH_NOT_HANDLED:
+		break;
+	default:
+		printk(KERN_ERR "block: bad eh return: %d\n", ret);
+		break;
+	}
 }
 		
-struct blk_mq_timeout_data {
-	unsigned long next;
-	unsigned int next_set;
-};
-
 static void blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 		struct request *rq, void *priv, bool reserved)
 {
 	struct blk_mq_timeout_data *data = priv;
 
-	if (test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
-		blk_rq_check_expired(rq, &data->next, &data->next_set);
+	if (!test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
+		return;
+
+	if (time_after_eq(jiffies, rq->deadline)) {
+		if (!blk_mark_rq_complete(rq))
+			blk_mq_rq_timed_out(rq);
+	} else if (!data->next_set || time_after(data->next, rq->deadline)) {
+		data->next = rq->deadline;
+		data->next_set = 1;
+	}
 }
 
 static void blk_mq_rq_timer(unsigned long priv)
@@ -1770,7 +1792,6 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	else
 		blk_queue_make_request(q, blk_sq_make_request);
 
-	blk_queue_rq_timed_out(q, blk_mq_rq_timed_out);
 	if (set->timeout)
 		blk_queue_rq_timeout(q, set->timeout);
 
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 95a0959..4d44825 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -7,7 +7,6 @@
 #include <linux/fault-inject.h>
 
 #include "blk.h"
-#include "blk-mq.h"
 
 #ifdef CONFIG_FAIL_IO_TIMEOUT
 
@@ -90,10 +89,7 @@ static void blk_rq_timed_out(struct request *req)
 	switch (ret) {
 	case BLK_EH_HANDLED:
 		/* Can we use req->errors here? */
-		if (q->mq_ops)
-			__blk_mq_complete_request(req);
-		else
-			__blk_complete_request(req);
+		__blk_complete_request(req);
 		break;
 	case BLK_EH_RESET_TIMER:
 		blk_add_timer(req);
@@ -113,7 +109,7 @@ static void blk_rq_timed_out(struct request *req)
 	}
 }
 
-void blk_rq_check_expired(struct request *rq, unsigned long *next_timeout,
+static void blk_rq_check_expired(struct request *rq, unsigned long *next_timeout,
 			  unsigned int *next_set)
 {
 	if (time_after_eq(jiffies, rq->deadline)) {
diff --git a/block/blk.h b/block/blk.h
index 6748c4f..e515a28 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -38,8 +38,6 @@ bool __blk_end_bidi_request(struct request *rq, int error,
 			    unsigned int nr_bytes, unsigned int bidi_bytes);
 
 void blk_rq_timed_out_timer(unsigned long data);
-void blk_rq_check_expired(struct request *rq, unsigned long *next_timeout,
-			  unsigned int *next_set);
 unsigned long blk_rq_timeout(unsigned long timeout);
 void blk_add_timer(struct request *req);
 void blk_delete_timer(struct request *);
-- 
1.9.1
