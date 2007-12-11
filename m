From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 28/30] blk_end_request: remove/unexport
 end_that_request_* (take 4)
Date: Tue, 11 Dec 2007 17:52:28 -0500 (EST)
Message-ID: <20071211.175228.52120550.k-ueda@ct.jp.nec.com>
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

This patch removes the following functions:
  o end_that_request_first()
  o end_that_request_chunk()
and stops exporting the functions below:
  o end_that_request_last()

Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   61 ++++++++++++-------------------------------------
 include/linux/blkdev.h |   13 ++++------
 2 files changed, 20 insertions(+), 54 deletions(-)

Index: 2.6.24-rc4/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc4.orig/block/ll_rw_blk.c
+++ 2.6.24-rc4/block/ll_rw_blk.c
@@ -3410,6 +3410,20 @@ static void blk_recalc_rq_sectors(struct
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
@@ -3526,49 +3540,6 @@ static int __end_that_request_first(stru
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
@@ -3648,7 +3619,7 @@ EXPORT_SYMBOL(blk_complete_request);
 /*
  * queue lock must be held
  */
-void end_that_request_last(struct request *req, int uptodate)
+static void end_that_request_last(struct request *req, int uptodate)
 {
 	struct gendisk *disk = req->rq_disk;
 	int error;
@@ -3683,8 +3654,6 @@ void end_that_request_last(struct reques
 		__blk_put_request(req->q, req);
 }
 
-EXPORT_SYMBOL(end_that_request_last);
-
 static inline void __end_request(struct request *rq, int uptodate,
 				 unsigned int nr_bytes)
 {
Index: 2.6.24-rc4/include/linux/blkdev.h
===================================================================
--- 2.6.24-rc4.orig/include/linux/blkdev.h
+++ 2.6.24-rc4/include/linux/blkdev.h
@@ -720,21 +720,18 @@ static inline void blk_run_address_space
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
 extern int blk_end_request(struct request *rq, int error, int nr_bytes);
 extern int __blk_end_request(struct request *rq, int error, int nr_bytes);
 extern int blk_end_bidi_request(struct request *rq, int error, int nr_bytes,
 				int bidi_bytes);
-extern int end_that_request_first(struct request *, int, int);
-extern int end_that_request_chunk(struct request *, int, int);
-extern void end_that_request_last(struct request *, int);
 extern void end_request(struct request *, int);
 extern void end_queued_request(struct request *, int);
 extern void end_dequeued_request(struct request *, int);
