From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: remove blk_end_bidi_request and
 __blk_end_bidi_request
Date: Fri, 15 May 2009 16:35:19 +0900
Message-ID: <20090515163416M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38168 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbZEOHg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 May 2009 03:36:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com

The block core does:

- blk_end_request and blk_end_request_all calls blk_end_bidi_request.
- __blk_end_request and __blk_end_request_all calls __blk_end_bidi_request.

The bidi name is confusing since all the callers are generic
completion functions.

A bidi request must be completed as a whole so let's reorganize the
functions a bit:

- blk_end_request_all calls blk_end_request, __blk_end_request_all
calls __blk_end_request

- blk_end_request and __blk_end_request complete a bidi request as a
whole because we always have to complete a bidi request as a whole.


It might be better to change blk_update_bidi_request too since we
can't update a bidi request.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-core.c |   94 +++++++++++++++---------------------------------------
 1 files changed, 26 insertions(+), 68 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a2d97de..2c6d0ec 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1972,7 +1972,6 @@ static bool blk_update_bidi_request(struct request *rq, int error,
 	if (blk_update_request(rq, error, nr_bytes))
 		return true;
 
-	/* Bidi request must be completed as a whole */
 	if (unlikely(blk_bidi_rq(rq)) &&
 	    blk_update_request(rq->next_rq, error, bidi_bytes))
 		return true;
@@ -2010,27 +2009,28 @@ static void blk_finish_request(struct request *req, int error)
 }
 
 /**
- * blk_end_bidi_request - Complete a bidi request
- * @rq:         the request to complete
- * @error:      %0 for success, < %0 for error
- * @nr_bytes:   number of bytes to complete @rq
- * @bidi_bytes: number of bytes to complete @rq->next_rq
+ * blk_end_request - Helper function for drivers to complete the request.
+ * @rq:       the request being processed
+ * @error:    %0 for success, < %0 for error
+ * @nr_bytes: number of bytes to complete
  *
  * Description:
- *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
- *     Drivers that supports bidi can safely call this member for any
- *     type of request, bidi or uni.  In the later case @bidi_bytes is
- *     just ignored.
+ *     Ends I/O on a number of bytes attached to @rq.
+ *     If @rq has leftover, sets it up for the next range of segments.
  *
  * Return:
  *     %false - we are done with this request
  *     %true  - still buffers pending for this request
  **/
-static bool blk_end_bidi_request(struct request *rq, int error,
-				 unsigned int nr_bytes, unsigned int bidi_bytes)
+bool blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags;
+	unsigned int bidi_bytes = 0;
+	bool pending;
+
+	if (unlikely(blk_bidi_rq(rq)))
+		bidi_bytes = blk_rq_bytes(rq->next_rq);
 
 	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
 		return true;
@@ -2041,51 +2041,6 @@ static bool blk_end_bidi_request(struct request *rq, int error,
 
 	return false;
 }
-
-/**
- * __blk_end_bidi_request - Complete a bidi request with queue lock held
- * @rq:         the request to complete
- * @error:      %0 for success, < %0 for error
- * @nr_bytes:   number of bytes to complete @rq
- * @bidi_bytes: number of bytes to complete @rq->next_rq
- *
- * Description:
- *     Identical to blk_end_bidi_request() except that queue lock is
- *     assumed to be locked on entry and remains so on return.
- *
- * Return:
- *     %false - we are done with this request
- *     %true  - still buffers pending for this request
- **/
-static bool __blk_end_bidi_request(struct request *rq, int error,
-				   unsigned int nr_bytes, unsigned int bidi_bytes)
-{
-	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
-		return true;
-
-	blk_finish_request(rq, error);
-
-	return false;
-}
-
-/**
- * blk_end_request - Helper function for drivers to complete the request.
- * @rq:       the request being processed
- * @error:    %0 for success, < %0 for error
- * @nr_bytes: number of bytes to complete
- *
- * Description:
- *     Ends I/O on a number of bytes attached to @rq.
- *     If @rq has leftover, sets it up for the next range of segments.
- *
- * Return:
- *     %false - we are done with this request
- *     %true  - still buffers pending for this request
- **/
-bool blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
-{
-	return blk_end_bidi_request(rq, error, nr_bytes, 0);
-}
 EXPORT_SYMBOL_GPL(blk_end_request);
 
 /**
@@ -2099,12 +2054,8 @@ EXPORT_SYMBOL_GPL(blk_end_request);
 void blk_end_request_all(struct request *rq, int error)
 {
 	bool pending;
-	unsigned int bidi_bytes = 0;
-
-	if (unlikely(blk_bidi_rq(rq)))
-		bidi_bytes = blk_rq_bytes(rq->next_rq);
 
-	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
+	pending = blk_end_request(rq, error, blk_rq_bytes(rq));
 	BUG_ON(pending);
 }
 EXPORT_SYMBOL_GPL(blk_end_request_all);
@@ -2142,7 +2093,18 @@ EXPORT_SYMBOL_GPL(blk_end_request_cur);
  **/
 bool __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
-	return __blk_end_bidi_request(rq, error, nr_bytes, 0);
+	bool pending;
+	unsigned int bidi_bytes = 0;
+
+	if (unlikely(blk_bidi_rq(rq)))
+		bidi_bytes = blk_rq_bytes(rq->next_rq);
+
+	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
+		return true;
+
+	blk_finish_request(rq, error);
+
+	return false;
 }
 EXPORT_SYMBOL_GPL(__blk_end_request);
 
@@ -2157,12 +2119,8 @@ EXPORT_SYMBOL_GPL(__blk_end_request);
 void __blk_end_request_all(struct request *rq, int error)
 {
 	bool pending;
-	unsigned int bidi_bytes = 0;
-
-	if (unlikely(blk_bidi_rq(rq)))
-		bidi_bytes = blk_rq_bytes(rq->next_rq);
 
-	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
+	pending = __blk_end_request(rq, error, blk_rq_bytes(rq));
 	BUG_ON(pending);
 }
 EXPORT_SYMBOL_GPL(__blk_end_request_all);
-- 
1.6.0.6

