From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 29/30] blk_end_request: cleanup 'uptodate'
 related code (take 4)
Date: Tue, 11 Dec 2007 17:53:03 -0500 (EST)
Message-ID: <20071211.175303.99826025.k-ueda@ct.jp.nec.com>
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

This patch converts 'uptodate' arguments of no longer exported
interfaces, end_that_request_first/last, to 'error', and removes
internal conversions for it in blk_end_request interfaces.

Also, this patch removes no longer needed end_io_error().

Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   56 +++++++------------------------------------------
 include/linux/blkdev.h |    8 -------
 2 files changed, 9 insertions(+), 55 deletions(-)

Index: 2.6.24-rc4/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc4.orig/block/ll_rw_blk.c
+++ 2.6.24-rc4/block/ll_rw_blk.c
@@ -3413,7 +3413,7 @@ static void blk_recalc_rq_sectors(struct
 /**
  * __end_that_request_first - end I/O on a request
  * @req:      the request being processed
- * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
+ * @error:    0 for success, < 0 for error
  * @nr_bytes: number of bytes to complete
  *
  * Description:
@@ -3424,29 +3424,22 @@ static void blk_recalc_rq_sectors(struct
  *     0 - we are done with this request, call end_that_request_last()
  *     1 - still buffers pending for this request
  **/
-static int __end_that_request_first(struct request *req, int uptodate,
+static int __end_that_request_first(struct request *req, int error,
 				    int nr_bytes)
 {
-	int total_bytes, bio_nbytes, error, next_idx = 0;
+	int total_bytes, bio_nbytes, next_idx = 0;
 	struct bio *bio;
 
 	blk_add_trace_rq(req->q, req, BLK_TA_COMPLETE);
 
 	/*
-	 * extend uptodate bool to allow < 0 value to be direct io error
-	 */
-	error = 0;
-	if (end_io_error(uptodate))
-		error = !uptodate ? -EIO : uptodate;
-
-	/*
 	 * for a REQ_BLOCK_PC request, we want to carry any eventual
 	 * sense key with us all the way through
 	 */
 	if (!blk_pc_request(req))
 		req->errors = 0;
 
-	if (!uptodate) {
+	if (error) {
 		if (blk_fs_request(req) && !(req->cmd_flags & REQ_QUIET))
 			printk("end_request: I/O error, dev %s, sector %llu\n",
 				req->rq_disk ? req->rq_disk->disk_name : "?",
@@ -3619,17 +3612,9 @@ EXPORT_SYMBOL(blk_complete_request);
 /*
  * queue lock must be held
  */
-static void end_that_request_last(struct request *req, int uptodate)
+static void end_that_request_last(struct request *req, int error)
 {
 	struct gendisk *disk = req->rq_disk;
-	int error;
-
-	/*
-	 * extend uptodate bool to allow < 0 value to be direct io error
-	 */
-	error = 0;
-	if (end_io_error(uptodate))
-		error = !uptodate ? -EIO : uptodate;
 
 	if (unlikely(laptop_mode) && blk_fs_request(req))
 		laptop_io_completion();
@@ -3754,14 +3739,6 @@ EXPORT_SYMBOL(end_request);
 
 static void complete_request(struct request *rq, int error)
 {
-	/*
-	 * REMOVEME: This conversion is transitional and will be removed
-	 *           when old end_that_request_* are unexported.
-	 */
-	int uptodate = 1;
-	if (error)
-		uptodate = (error == -EIO) ? 0 : error;
-
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(rq->q, rq);
 
@@ -3771,7 +3748,7 @@ static void complete_request(struct requ
 	if (blk_bidi_rq(rq) && !rq->end_io)
 		__blk_put_request(rq->next_rq->q, rq->next_rq);
 
-	end_that_request_last(rq, uptodate);
+	end_that_request_last(rq, error);
 }
 
 /**
@@ -3798,21 +3775,14 @@ static int blk_end_io(struct request *rq
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
-	/*
-	 * REMOVEME: This conversion is transitional and will be removed
-	 *           when old end_that_request_* are unexported.
-	 */
-	int uptodate = 1;
-	if (error)
-		uptodate = (error == -EIO) ? 0 : error;
 
 	if (blk_fs_request(rq) || blk_pc_request(rq)) {
-		if (__end_that_request_first(rq, uptodate, nr_bytes))
+		if (__end_that_request_first(rq, error, nr_bytes))
 			return 1;
 
 		/* Bidi request must be completed as a whole */
 		if (blk_bidi_rq(rq) &&
-		    __end_that_request_first(rq->next_rq, uptodate, bidi_bytes))
+		    __end_that_request_first(rq->next_rq, error, bidi_bytes))
 			return 1;
 	}
 
@@ -3864,16 +3834,8 @@ EXPORT_SYMBOL_GPL(blk_end_request);
  **/
 int __blk_end_request(struct request *rq, int error, int nr_bytes)
 {
-	/*
-	 * REMOVEME: This conversion is transitional and will be removed
-	 *           when old end_that_request_* are unexported.
-	 */
-	int uptodate = 1;
-	if (error)
-		uptodate = (error == -EIO) ? 0 : error;
-
 	if (blk_fs_request(rq) || blk_pc_request(rq)) {
-		if (__end_that_request_first(rq, uptodate, nr_bytes))
+		if (__end_that_request_first(rq, error, nr_bytes))
 			return 1;
 	}
 
Index: 2.6.24-rc4/include/linux/blkdev.h
===================================================================
--- 2.6.24-rc4.orig/include/linux/blkdev.h
+++ 2.6.24-rc4/include/linux/blkdev.h
@@ -747,14 +747,6 @@ extern void blk_complete_request(struct 
 extern unsigned int blk_rq_bytes(struct request *rq);
 extern unsigned int blk_rq_cur_bytes(struct request *rq);
 
-/*
- * end_that_request_first/chunk() takes an uptodate argument. we account
- * any value <= as an io error. 0 means -EIO for compatability reasons,
- * any other < 0 value is the direct error type. An uptodate value of
- * 1 indicates successful io completion
- */
-#define end_io_error(uptodate)	(unlikely((uptodate) <= 0))
-
 static inline void blkdev_dequeue_request(struct request *req)
 {
 	elv_dequeue_request(req->q, req);
