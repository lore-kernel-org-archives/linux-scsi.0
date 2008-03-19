From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 01/13] block: add request update interface
Date: Wed, 19 Mar 2008 18:07:06 -0500 (EST)
Message-ID: <20080319.180706.35658194.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds an interface to update request information so that
request stacking drivers can complete only data part of a request
without completing the request.
Request stacking drivers can use it for partial completion.

Request stacking drivers like request-based dm need to complete
clone requests from bottom to top on the device stack in that order.
If request stacking drivers use blk_end_request() to updatethe original
request during partial completion (in bio->bi_end_io() hook),
the original request will be completed before the clone request when
all bios are completed.  It breaks the ordering.

blk_update_request() just completes only data part of a request and
updates information of the request, but doesn't complete the request.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-core.c       |   59 +++++++++++++++++++++++++++++++++++++++++--------
 include/linux/blkdev.h |    2 +
 2 files changed, 52 insertions(+), 9 deletions(-)

Index: 2.6.25-rc5/block/blk-core.c
===================================================================
--- 2.6.25-rc5.orig/block/blk-core.c
+++ 2.6.25-rc5/block/blk-core.c
@@ -1853,6 +1853,22 @@ void end_request(struct request *req, in
 }
 EXPORT_SYMBOL(end_request);
 
+static int end_that_request_data(struct request *rq, int error,
+				 unsigned int nr_bytes, unsigned int bidi_bytes)
+{
+	if (blk_fs_request(rq) || blk_pc_request(rq)) {
+		if (__end_that_request_first(rq, error, nr_bytes))
+			return 1;
+
+		/* Bidi request must be completed as a whole */
+		if (blk_bidi_rq(rq) &&
+		    __end_that_request_first(rq->next_rq, error, bidi_bytes))
+			return 1;
+	}
+
+	return 0;
+}
+
 /**
  * blk_end_io - Generic end_io function to complete a request.
  * @rq:           the request being processed
@@ -1879,15 +1895,8 @@ static int blk_end_io(struct request *rq
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
 
-	if (blk_fs_request(rq) || blk_pc_request(rq)) {
-		if (__end_that_request_first(rq, error, nr_bytes))
-			return 1;
-
-		/* Bidi request must be completed as a whole */
-		if (blk_bidi_rq(rq) &&
-		    __end_that_request_first(rq->next_rq, error, bidi_bytes))
-			return 1;
-	}
+	if (end_that_request_data(rq, error, nr_bytes, bidi_bytes))
+		return 1;
 
 	/* Special feature for tricky drivers */
 	if (drv_callback && drv_callback(rq))
@@ -1972,6 +1981,38 @@ int blk_end_bidi_request(struct request 
 EXPORT_SYMBOL_GPL(blk_end_bidi_request);
 
 /**
+ * blk_update_request - Special helper function for request stacking drivers
+ * @rq:           the request being processed
+ * @error:        0 for success, < 0 for error
+ * @nr_bytes:     number of bytes to complete @rq
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq, but doesn't complete
+ *     the request structure even if @rq doesn't have leftover.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ *     This special helper function is only for request stacking drivers
+ *     (e.g. request-based dm) so that they can handle partial completion.
+ *     Actual device drivers should use blk_end_request instead.
+ **/
+void blk_update_request(struct request *rq, int error, unsigned int nr_bytes)
+{
+	if (!end_that_request_data(rq, error, nr_bytes, 0)) {
+		/*
+		 * All bios in the request have been completed.
+		 * Then, members of the request are not updated.
+		 * Update those members to avoid double charge of diskstat
+		 * when the stacking driver calls blk_end_request()
+		 * to complete the request actually.
+		 */
+		rq->nr_sectors = rq->hard_nr_sectors = 0;
+		rq->current_nr_sectors = rq->hard_cur_sectors = 0;
+		rq->nr_phys_segments = rq->nr_hw_segments = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(blk_update_request);
+
+/**
  * blk_end_request_callback - Special helper function for tricky drivers
  * @rq:           the request being processed
  * @error:        0 for success, < 0 for error
Index: 2.6.25-rc5/include/linux/blkdev.h
===================================================================
--- 2.6.25-rc5.orig/include/linux/blkdev.h
+++ 2.6.25-rc5/include/linux/blkdev.h
@@ -673,6 +673,8 @@ extern int blk_end_request_callback(stru
 				unsigned int nr_bytes,
 				int (drv_callback)(struct request *));
 extern void blk_complete_request(struct request *);
+extern void blk_update_request(struct request *rq, int error,
+			       unsigned int nr_bytes);
 
 /*
  * blk_end_request() takes bytes instead of sectors as a complete size.
