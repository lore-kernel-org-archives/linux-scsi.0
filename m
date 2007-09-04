From: "Halevy, Benny" <bhalevy@panasas.com>
Subject: RE: [PATCH 6/7] blk_end_request: remove/unexport end_that_request_*
Date: Tue, 4 Sep 2007 17:25:14 -0400
Message-ID: <E472128B1EB43941B4E7FB268020C89B02992D9B@riverside.int.panasas.com>
References: <20070831.184335.85683085.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-ide-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, mike.miller@hp.com, grant
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

Boaz raised my attention to this patchset today...
We suspect we'll still need the extern entry points for handling the bidi 
request in the scsi_io_completion() path as we only want to call
end_that_request_chunk on req->next_rq and never
end_that_request_last.
 
(see 
http://www.bhalevy.com/open-osd/download/linux-2.6.23-rc2_and_iscsi-iscsi-2007_08_09/0005-SCSI-bidi-support.patch)
 
If this is ok with you I'd leave these entry points in place rather than
taking them out and putting them back in later.
 
Benny

________________________________

From: linux-scsi-owner@vger.kernel.org on behalf of Kiyoshi Ueda
Sent: Sat 2007-09-01 01:43
To: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; linux-ide@vger.kernel.org; jens.axboe@oracle.com; mike.miller@hp.com; grant.likely@secretlab.ca
Cc: dm-devel@redhat.com; j-nomura@ce.jp.nec.com; k-ueda@ct.jp.nec.com
Subject: [PATCH 6/7] blk_end_request: remove/unexport end_that_request_*



This patch removes the following functions:
  o end_that_request_first()
  o end_that_request_chunk()
and stops exporting the functions below:
  o end_that_request_last()

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   61 ++++++++++++------------------------------------- include/linux/blkdev.h |   15 ++++--------
 2 files changed, 21 insertions(+), 55 deletions(-)

diff -rupN 05-ide-cd-change/block/ll_rw_blk.c 06-remove-old-interface/block/ll_rw_blk.c
--- 05-ide-cd-change/block/ll_rw_blk.c  2007-08-24 12:11:02.000000000 -0400
+++ 06-remove-old-interface/block/ll_rw_blk.c   2007-08-24 12:19:02.000000000 -0400
@@ -3388,6 +3388,20 @@ static void blk_recalc_rq_sectors(struct
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
@@ -3498,49 +3512,6 @@ static int __end_that_request_first(stru
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
-       return __end_that_request_first(req, uptodate, nr_sectors << 9);
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
-       return __end_that_request_first(req, uptodate, nr_bytes);
-}
-
-EXPORT_SYMBOL(end_that_request_chunk);
-
 /*
  * splice the completion data to a local structure and hand off to
  * process_completion_queue() to complete the requests
@@ -3620,7 +3591,7 @@ EXPORT_SYMBOL(blk_complete_request);
 /*
  * queue lock must be held
  */
-void end_that_request_last(struct request *req, int uptodate)
+static void end_that_request_last(struct request *req, int uptodate)
 {
        struct gendisk *disk = req->rq_disk;
        int error;
@@ -3655,8 +3626,6 @@ void end_that_request_last(struct reques
                __blk_put_request(req->q, req);
 }

-EXPORT_SYMBOL(end_that_request_last);
-
 void end_request(struct request *req, int uptodate)
 {
        __blk_end_request(req, uptodate, sect2byte(req->hard_cur_sectors));
diff -rupN 05-ide-cd-change/include/linux/blkdev.h 06-remove-old-interface/include/linux/blkdev.h
--- 05-ide-cd-change/include/linux/blkdev.h     2007-08-24 12:21:45.000000000 -0400
+++ 06-remove-old-interface/include/linux/blkdev.h      2007-08-24 12:21:15.000000000 -0400
@@ -720,19 +720,16 @@ static inline void blk_run_address_space
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
 extern void end_request(struct request *req, int uptodate);
 extern int blk_end_request_callback(struct request *rq, int uptodate,
                                    int nr_bytes,
@@ -749,7 +746,7 @@ extern void blk_complete_request(struct
 #define blk_rq_cur_size(rq) (sect2byte((rq)->current_nr_sectors))

 /*
- * end_that_request_first/chunk() takes an uptodate argument. we account
+ * blk_end_request() takes an uptodate argument. we account
  * any value <= as an io error. 0 means -EIO for compatability reasons,
  * any other < 0 value is the direct error type. An uptodate value of
  * 1 indicates successful io completion
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


