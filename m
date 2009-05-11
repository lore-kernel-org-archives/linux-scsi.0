From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] block: move completion related functions back to blk-core.c
Date: Mon, 11 May 2009 17:56:09 +0900
Message-ID: <1242032169-22422-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37526 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbZEKI47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 04:56:59 -0400
In-Reply-To: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Let's put the completion related functions back to block/blk-core.c
where they have lived. We can also unexport blk_end_bidi_request() and
__blk_end_bidi_request(), which nobody uses.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-core.c       |  128 +++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/blkdev.h |  128 +++---------------------------------------------
 2 files changed, 130 insertions(+), 126 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 93691d2..a2d97de 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2026,8 +2026,8 @@ static void blk_finish_request(struct request *req, int error)
  *     %false - we are done with this request
  *     %true  - still buffers pending for this request
  **/
-bool blk_end_bidi_request(struct request *rq, int error,
-			  unsigned int nr_bytes, unsigned int bidi_bytes)
+static bool blk_end_bidi_request(struct request *rq, int error,
+				 unsigned int nr_bytes, unsigned int bidi_bytes)
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags;
@@ -2041,7 +2041,6 @@ bool blk_end_bidi_request(struct request *rq, int error,
 
 	return false;
 }
-EXPORT_SYMBOL_GPL(blk_end_bidi_request);
 
 /**
  * __blk_end_bidi_request - Complete a bidi request with queue lock held
@@ -2058,8 +2057,8 @@ EXPORT_SYMBOL_GPL(blk_end_bidi_request);
  *     %false - we are done with this request
  *     %true  - still buffers pending for this request
  **/
-bool __blk_end_bidi_request(struct request *rq, int error,
-			    unsigned int nr_bytes, unsigned int bidi_bytes)
+static bool __blk_end_bidi_request(struct request *rq, int error,
+				   unsigned int nr_bytes, unsigned int bidi_bytes)
 {
 	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
 		return true;
@@ -2068,7 +2067,124 @@ bool __blk_end_bidi_request(struct request *rq, int error,
 
 	return false;
 }
-EXPORT_SYMBOL_GPL(__blk_end_bidi_request);
+
+/**
+ * blk_end_request - Helper function for drivers to complete the request.
+ * @rq:       the request being processed
+ * @error:    %0 for success, < %0 for error
+ * @nr_bytes: number of bytes to complete
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
+ **/
+bool blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
+{
+	return blk_end_bidi_request(rq, error, nr_bytes, 0);
+}
+EXPORT_SYMBOL_GPL(blk_end_request);
+
+/**
+ * blk_end_request_all - Helper function for drives to finish the request.
+ * @rq: the request to finish
+ * @err: %0 for success, < %0 for error
+ *
+ * Description:
+ *     Completely finish @rq.
+ */
+void blk_end_request_all(struct request *rq, int error)
+{
+	bool pending;
+	unsigned int bidi_bytes = 0;
+
+	if (unlikely(blk_bidi_rq(rq)))
+		bidi_bytes = blk_rq_bytes(rq->next_rq);
+
+	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
+	BUG_ON(pending);
+}
+EXPORT_SYMBOL_GPL(blk_end_request_all);
+
+/**
+ * blk_end_request_cur - Helper function to finish the current request chunk.
+ * @rq: the request to finish the current chunk for
+ * @err: %0 for success, < %0 for error
+ *
+ * Description:
+ *     Complete the current consecutively mapped chunk from @rq.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
+ */
+bool blk_end_request_cur(struct request *rq, int error)
+{
+	return blk_end_request(rq, error, blk_rq_cur_bytes(rq));
+}
+EXPORT_SYMBOL_GPL(blk_end_request_cur);
+
+/**
+ * __blk_end_request - Helper function for drivers to complete the request.
+ * @rq:       the request being processed
+ * @error:    %0 for success, < %0 for error
+ * @nr_bytes: number of bytes to complete
+ *
+ * Description:
+ *     Must be called with queue lock held unlike blk_end_request().
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
+ **/
+bool __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
+{
+	return __blk_end_bidi_request(rq, error, nr_bytes, 0);
+}
+EXPORT_SYMBOL_GPL(__blk_end_request);
+
+/**
+ * __blk_end_request_all - Helper function for drives to finish the request.
+ * @rq: the request to finish
+ * @err: %0 for success, < %0 for error
+ *
+ * Description:
+ *     Completely finish @rq.  Must be called with queue lock held.
+ */
+void __blk_end_request_all(struct request *rq, int error)
+{
+	bool pending;
+	unsigned int bidi_bytes = 0;
+
+	if (unlikely(blk_bidi_rq(rq)))
+		bidi_bytes = blk_rq_bytes(rq->next_rq);
+
+	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
+	BUG_ON(pending);
+}
+EXPORT_SYMBOL_GPL(__blk_end_request_all);
+
+/**
+ * __blk_end_request_cur - Helper function to finish the current request chunk.
+ * @rq: the request to finish the current chunk for
+ * @err: %0 for success, < %0 for error
+ *
+ * Description:
+ *     Complete the current consecutively mapped chunk from @rq.  Must
+ *     be called with queue lock held.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
+ */
+bool __blk_end_request_cur(struct request *rq, int error)
+{
+	return __blk_end_request(rq, error, blk_rq_cur_bytes(rq));
+}
+EXPORT_SYMBOL_GPL(__blk_end_request_cur);
 
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		     struct bio *bio)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3b5c564..4dcc0b5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -873,126 +873,14 @@ extern struct request *blk_fetch_request(struct request_queue *q);
  */
 extern bool blk_update_request(struct request *rq, int error,
 			       unsigned int nr_bytes);
-extern bool blk_end_bidi_request(struct request *rq, int error,
-				 unsigned int nr_bytes,
-				 unsigned int bidi_bytes);
-extern bool __blk_end_bidi_request(struct request *rq, int error,
-				   unsigned int nr_bytes,
-				   unsigned int bidi_bytes);
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
-static inline bool blk_end_request(struct request *rq, int error,
-				   unsigned int nr_bytes)
-{
-	return blk_end_bidi_request(rq, error, nr_bytes, 0);
-}
-
-/**
- * blk_end_request_all - Helper function for drives to finish the request.
- * @rq: the request to finish
- * @err: %0 for success, < %0 for error
- *
- * Description:
- *     Completely finish @rq.
- */
-static inline void blk_end_request_all(struct request *rq, int error)
-{
-	bool pending;
-	unsigned int bidi_bytes = 0;
-
-	if (unlikely(blk_bidi_rq(rq)))
-		bidi_bytes = blk_rq_bytes(rq->next_rq);
-
-	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
-	BUG_ON(pending);
-}
-
-/**
- * blk_end_request_cur - Helper function to finish the current request chunk.
- * @rq: the request to finish the current chunk for
- * @err: %0 for success, < %0 for error
- *
- * Description:
- *     Complete the current consecutively mapped chunk from @rq.
- *
- * Return:
- *     %false - we are done with this request
- *     %true  - still buffers pending for this request
- */
-static inline bool blk_end_request_cur(struct request *rq, int error)
-{
-	return blk_end_request(rq, error, blk_rq_cur_bytes(rq));
-}
-
-/**
- * __blk_end_request - Helper function for drivers to complete the request.
- * @rq:       the request being processed
- * @error:    %0 for success, < %0 for error
- * @nr_bytes: number of bytes to complete
- *
- * Description:
- *     Must be called with queue lock held unlike blk_end_request().
- *
- * Return:
- *     %false - we are done with this request
- *     %true  - still buffers pending for this request
- **/
-static inline bool __blk_end_request(struct request *rq, int error,
-				     unsigned int nr_bytes)
-{
-	return __blk_end_bidi_request(rq, error, nr_bytes, 0);
-}
-
-/**
- * __blk_end_request_all - Helper function for drives to finish the request.
- * @rq: the request to finish
- * @err: %0 for success, < %0 for error
- *
- * Description:
- *     Completely finish @rq.  Must be called with queue lock held.
- */
-static inline void __blk_end_request_all(struct request *rq, int error)
-{
-	bool pending;
-	unsigned int bidi_bytes = 0;
-
-	if (unlikely(blk_bidi_rq(rq)))
-		bidi_bytes = blk_rq_bytes(rq->next_rq);
-
-	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
-	BUG_ON(pending);
-}
-
-/**
- * __blk_end_request_cur - Helper function to finish the current request chunk.
- * @rq: the request to finish the current chunk for
- * @err: %0 for success, < %0 for error
- *
- * Description:
- *     Complete the current consecutively mapped chunk from @rq.  Must
- *     be called with queue lock held.
- *
- * Return:
- *     %false - we are done with this request
- *     %true  - still buffers pending for this request
- */
-static inline bool __blk_end_request_cur(struct request *rq, int error)
-{
-	return __blk_end_request(rq, error, blk_rq_cur_bytes(rq));
-}
+extern bool blk_end_request(struct request *rq, int error,
+			    unsigned int nr_bytes);
+extern void blk_end_request_all(struct request *rq, int error);
+extern bool blk_end_request_cur(struct request *rq, int error);
+extern bool __blk_end_request(struct request *rq, int error,
+			      unsigned int nr_bytes);
+extern void __blk_end_request_all(struct request *rq, int error);
+extern bool __blk_end_request_cur(struct request *rq, int error);
 
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
-- 
1.6.0.6

