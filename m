From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 26/30] blk_end_request: add bidi completion
 interface (take 4)
Date: Tue, 11 Dec 2007 17:51:46 -0500 (EST)
Message-ID: <20071211.175146.50591362.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

This patch adds a variant of the interface, blk_end_bidi_request(),
which completes a bidi request.

Bidi request must be completed as a whole, both rq and rq->next_rq
at once.  So the interface has 2 arguments for completion size.

As for ->end_io, only rq->end_io is called (rq->next_rq->end_io is not
called).  So if special completion handling is needed, the handler
must be set to rq->end_io.
And the handler must take care of freeing next_rq too, since
the interface doesn't care of it if rq->end_io is not NULL.

Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   40 +++++++++++++++++++++++++++++++++++-----
 include/linux/blkdev.h |    2 ++
 2 files changed, 37 insertions(+), 5 deletions(-)

Index: 2.6.24-rc4/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc4.orig/block/ll_rw_blk.c
+++ 2.6.24-rc4/block/ll_rw_blk.c
@@ -3799,6 +3799,9 @@ static void complete_request(struct requ
 	if (blk_queued_rq(rq))
 		blkdev_dequeue_request(rq);
 
+	if (blk_bidi_rq(rq) && !rq->end_io)
+		__blk_put_request(rq->next_rq->q, rq->next_rq);
+
 	end_that_request_last(rq, uptodate);
 }
 
@@ -3806,14 +3809,15 @@ static void complete_request(struct requ
  * blk_end_io - Generic end_io function to complete a request.
  * @rq:           the request being processed
  * @error:        0 for success, < 0 for error
- * @nr_bytes:     number of bytes to complete
+ * @nr_bytes:     number of bytes to complete @rq
+ * @bidi_bytes:   number of bytes to complete @rq->next_rq
  * @drv_callback: function called between completion of bios in the request
  *                and completion of the request.
  *                If the callback returns non 0, this helper returns without
  *                completion of the request.
  *
  * Description:
- *     Ends I/O on a number of bytes attached to @rq.
+ *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
  *     If @rq has leftover, sets it up for the next range of segments.
  *
  * Return:
@@ -3821,7 +3825,7 @@ static void complete_request(struct requ
  *     1 - this request is not freed yet, it still has pending buffers.
  **/
 static int blk_end_io(struct request *rq, int error, int nr_bytes,
-		      int (drv_callback)(struct request *))
+		      int bidi_bytes, int (drv_callback)(struct request *))
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
@@ -3836,6 +3840,11 @@ static int blk_end_io(struct request *rq
 	if (blk_fs_request(rq) || blk_pc_request(rq)) {
 		if (__end_that_request_first(rq, uptodate, nr_bytes))
 			return 1;
+
+		/* Bidi request must be completed as a whole */
+		if (blk_bidi_rq(rq) &&
+		    __end_that_request_first(rq->next_rq, uptodate, bidi_bytes))
+			return 1;
 	}
 
 	/* Special feature for tricky drivers */
@@ -3867,7 +3876,7 @@ static int blk_end_io(struct request *rq
  **/
 int blk_end_request(struct request *rq, int error, int nr_bytes)
 {
-	return blk_end_io(rq, error, nr_bytes, NULL);
+	return blk_end_io(rq, error, nr_bytes, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(blk_end_request);
 
@@ -3908,6 +3917,27 @@ int __blk_end_request(struct request *rq
 EXPORT_SYMBOL_GPL(__blk_end_request);
 
 /**
+ * blk_end_bidi_request - Helper function for drivers to complete bidi request.
+ * @rq:         the bidi request being processed
+ * @error:      0 for success, < 0 for error
+ * @nr_bytes:   number of bytes to complete @rq
+ * @bidi_bytes: number of bytes to complete @rq->next_rq
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
+ *
+ * Return:
+ *     0 - we are done with this request
+ *     1 - still buffers pending for this request
+ **/
+int blk_end_bidi_request(struct request *rq, int error, int nr_bytes,
+			 int bidi_bytes)
+{
+	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
+}
+EXPORT_SYMBOL_GPL(blk_end_bidi_request);
+
+/**
  * blk_end_request_callback - Special helper function for tricky drivers
  * @rq:           the request being processed
  * @error:        0 for success, < 0 for error
@@ -3935,7 +3965,7 @@ EXPORT_SYMBOL_GPL(__blk_end_request);
 int blk_end_request_callback(struct request *rq, int error, int nr_bytes,
 			     int (drv_callback)(struct request *))
 {
-	return blk_end_io(rq, error, nr_bytes, drv_callback);
+	return blk_end_io(rq, error, nr_bytes, 0, drv_callback);
 }
 EXPORT_SYMBOL_GPL(blk_end_request_callback);
 
Index: 2.6.24-rc4/include/linux/blkdev.h
===================================================================
--- 2.6.24-rc4.orig/include/linux/blkdev.h
+++ 2.6.24-rc4/include/linux/blkdev.h
@@ -730,6 +730,8 @@ static inline void blk_run_address_space
  */
 extern int blk_end_request(struct request *rq, int error, int nr_bytes);
 extern int __blk_end_request(struct request *rq, int error, int nr_bytes);
+extern int blk_end_bidi_request(struct request *rq, int error, int nr_bytes,
+				int bidi_bytes);
 extern int end_that_request_first(struct request *, int, int);
 extern int end_that_request_chunk(struct request *, int, int);
 extern void end_that_request_last(struct request *, int);
