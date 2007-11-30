From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 28/28] blk_end_request: remove/unexport
 end_that_request_* (take 3)
Date: Fri, 30 Nov 2007 18:35:35 -0500 (EST)
Message-ID: <20071130.183535.75758102.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch removes the following functions:
  o end_that_request_first()
  o end_that_request_chunk()
and stops exporting the functions below:
  o end_that_request_last()

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   61 ++++++++++++-------------------------------------
 include/linux/blkdev.h |   15 ++++--------
 2 files changed, 21 insertions(+), 55 deletions(-)

Index: 2.6.24-rc3-mm2/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc3-mm2.orig/block/ll_rw_blk.c
+++ 2.6.24-rc3-mm2/block/ll_rw_blk.c
@@ -3415,6 +3415,20 @@ static void blk_recalc_rq_sectors(struct
 	}
 }
 
+/**
+ * __end_that_request_first - end I/O on a request
+ * @req:      the request being processed
+ * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
+ * @nr_bytes: number of bytes to complete
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @req, and sets it up
+ *     for the next range of segments (if any) in the cluster.
+ *
+ * Return:
+ *     0 - we are done with this request, call end_that_request_last()
+ *     1 - still buffers pending for this request
+ **/
 static int __end_that_request_first(struct request *req, int uptodate,
 				    int nr_bytes)
 {
@@ -3531,49 +3545,6 @@ static int __end_that_request_first(stru
 	return 1;
 }
 
-/**
- * end_that_request_first - end I/O on a request
- * @req:      the request being processed
- * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
- * @nr_sectors: number of sectors to end I/O on
- *
- * Description:
- *     Ends I/O on a number of sectors attached to @req, and sets it up
- *     for the next range of segments (if any) in the cluster.
- *
- * Return:
- *     0 - we are done with this request, call end_that_request_last()
- *     1 - still buffers pending for this request
- **/
-int end_that_request_first(struct request *req, int uptodate, int nr_sectors)
-{
-	return __end_that_request_first(req, uptodate, nr_sectors << 9);
-}
-
-EXPORT_SYMBOL(end_that_request_first);
-
-/**
- * end_that_request_chunk - end I/O on a request
- * @req:      the request being processed
- * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
- * @nr_bytes: number of bytes to complete
- *
- * Description:
- *     Ends I/O on a number of bytes attached to @req, and sets it up
- *     for the next range of segments (if any). Like end_that_request_first(),
- *     but deals with bytes instead of sectors.
- *
- * Return:
- *     0 - we are done with this request, call end_that_request_last()
- *     1 - still buffers pending for this request
- **/
-int end_that_request_chunk(struct request *req, int uptodate, int nr_bytes)
-{
-	return __end_that_request_first(req, uptodate, nr_bytes);
-}
-
-EXPORT_SYMBOL(end_that_request_chunk);
-
 /*
  * splice the completion data to a local structure and hand off to
  * process_completion_queue() to complete the requests
@@ -3653,7 +3624,7 @@ EXPORT_SYMBOL(blk_complete_request);
 /*
  * queue lock must be held
  */
-void end_that_request_last(struct request *req, int uptodate)
+static void end_that_request_last(struct request *req, int uptodate)
 {
 	struct gendisk *disk = req->rq_disk;
 	int error;
@@ -3688,8 +3659,6 @@ void end_that_request_last(struct reques
 		__blk_put_request(req->q, req);
 }
 
-EXPORT_SYMBOL(end_that_request_last);
-
 static inline void __end_request(struct request *rq, int uptodate,
 				 unsigned int nr_bytes)
 {
Index: 2.6.24-rc3-mm2/include/linux/blkdev.h
===================================================================
--- 2.6.24-rc3-mm2.orig/include/linux/blkdev.h
+++ 2.6.24-rc3-mm2/include/linux/blkdev.h
@@ -717,19 +717,16 @@ static inline void blk_run_address_space
 }
 
 /*
- * end_request() and friends. Must be called with the request queue spinlock
- * acquired. All functions called within end_request() _must_be_ atomic.
+ * blk_end_request() and friends.
+ * __blk_end_request() and end_request() must be called with
+ * the request queue spinlock acquired.
  *
  * Several drivers define their own end_request and call
- * end_that_request_first() and end_that_request_last()
- * for parts of the original function. This prevents
- * code duplication in drivers.
+ * blk_end_request() for parts of the original function.
+ * This prevents code duplication in drivers.
  */
 extern int blk_end_request(struct request *rq, int uptodate, int nr_bytes);
 extern int __blk_end_request(struct request *rq, int uptodate, int nr_bytes);
-extern int end_that_request_first(struct request *, int, int);
-extern int end_that_request_chunk(struct request *, int, int);
-extern void end_that_request_last(struct request *, int);
 extern void end_request(struct request *, int);
 extern void end_queued_request(struct request *, int);
 extern void end_dequeued_request(struct request *, int);
@@ -747,7 +744,7 @@ extern unsigned int blk_rq_bytes(struct 
 extern unsigned int blk_rq_cur_bytes(struct request *rq);
 
 /*
- * end_that_request_first/chunk() takes an uptodate argument. we account
+ * blk_end_request() takes an uptodate argument. we account
  * any value <= as an io error. 0 means -EIO for compatability reasons,
  * any other < 0 value is the direct error type. An uptodate value of
  * 1 indicates successful io completion
