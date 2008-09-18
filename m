From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/3] block: add request update interface
Date: Thu, 18 Sep 2008 10:45:09 -0400 (EDT)
Message-ID: <20080918.104509.41628894.k-ueda@ct.jp.nec.com>
References: <20080918.104356.74754407.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080918.104356.74754407.k-ueda@ct.jp.nec.com>
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
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds blk_update_request(), which updates struct request
with completing its data part, but doesn't complete the struct
request itself.
Though it looks like end_that_request_first() of older kernels,
blk_update_request() should be used only by request stacking drivers.

Request-based dm will use it in bio->bi_end_io callback to update
the original request when a data part of a cloned request completes.
Followings are additional background information of why request-based
dm needs this interface.

  - Request stacking drivers can't use blk_end_request() directly from
    the lower driver's completion context (bio->bi_end_io or rq->end_io),
    because some device drivers (e.g. ide) may try to complete
    their request with queue lock held, and it may cause deadlock.
    See below for detailed description of possible deadlock:
    <http://marc.info/?l=linux-kernel&m=120311479108569&w=2>

  - To solve that, request-based dm offloads the completion of
    cloned struct request to softirq context (i.e. using
    blk_complete_request() from rq->end_io).

  - Though it is possible to use the same solution from bio->bi_end_io,
    it will delay the notification of bio completion to the original
    submitter.  Also, it will cause inefficient partial completion,
    because the lower driver can't perform the cloned request anymore
    and request-based dm needs to requeue and redispatch it to
    the lower driver again later.  That's not good.

  - So request-based dm needs blk_update_request() to perform the bio
    completion in the lower driver's completion context, which is more
    efficient.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c       |   57 +++++++++++++++++++++++++++++++++++++++++--------
 include/linux/blkdev.h |    2 +
 2 files changed, 50 insertions(+), 9 deletions(-)

Index: linux-2.6-block/block/blk-core.c
===================================================================
--- linux-2.6-block.orig/block/blk-core.c
+++ linux-2.6-block/block/blk-core.c
@@ -1798,6 +1798,22 @@ void end_request(struct request *req, in
 }
 EXPORT_SYMBOL(end_request);
 
+static int end_that_request_data(struct request *rq, int error,
+				 unsigned int nr_bytes, unsigned int bidi_bytes)
+{
+	if (rq->bio) {
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
@@ -1824,15 +1840,8 @@ static int blk_end_io(struct request *rq
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
 
-	if (rq->bio) {
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
@@ -1915,6 +1924,36 @@ int blk_end_bidi_request(struct request 
 EXPORT_SYMBOL_GPL(blk_end_bidi_request);
 
 /**
+ * blk_update_request - Special helper function for request stacking drivers
+ * @rq:           the request being processed
+ * @error:        %0 for success, < %0 for error
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
+ */
+void blk_update_request(struct request *rq, int error, unsigned int nr_bytes)
+{
+	if (!end_that_request_data(rq, error, nr_bytes, 0)) {
+		/*
+		 * These members are not updated in end_that_request_data()
+		 * when all bios are completed.
+		 * Update them so that the request stacking driver can find
+		 * how many bytes remain in the request later.
+		 */
+		rq->nr_sectors = rq->hard_nr_sectors = 0;
+		rq->current_nr_sectors = rq->hard_cur_sectors = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(blk_update_request);
+
+/**
  * blk_end_request_callback - Special helper function for tricky drivers
  * @rq:           the request being processed
  * @error:        %0 for success, < %0 for error
Index: linux-2.6-block/include/linux/blkdev.h
===================================================================
--- linux-2.6-block.orig/include/linux/blkdev.h
+++ linux-2.6-block/include/linux/blkdev.h
@@ -791,6 +791,8 @@ extern void blk_complete_request(struct 
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
 extern void blk_abort_queue(struct request_queue *);
+extern void blk_update_request(struct request *rq, int error,
+			       unsigned int nr_bytes);
 
 /*
  * blk_end_request() takes bytes instead of sectors as a complete size.
