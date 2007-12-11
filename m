From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 24/30] blk_end_request: add callback feature
	(take 4)
Date: Tue, 11 Dec 2007 17:51:02 -0500 (EST)
Message-ID: <20071211.175102.25403920.k-ueda@ct.jp.nec.com>
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
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch adds a variant of the interface, blk_end_request_callback(),
which has driver callback feature.

Drivers may need to do special works between end_that_request_first()
and end_that_request_last().
For such drivers, blk_end_request_callback() allows it to pass
a callback function which is called between end_that_request_first()
and end_that_request_last().

This interface is only for fallback of other blk_end_request interfaces.
Drivers should avoid their tricky behaviors and use other interfaces
as much as possible.

Currently, only one driver, ide-cd, needs this interface.
So this interface should/will be removed, after the driver removes
such tricky behaviors.

o ide-cd (cdrom_newpc_intr())
  In PIO mode, cdrom_newpc_intr() needs to defer end_that_request_last()
  until the device clears DRQ_STAT and raises an interrupt after
  end_that_request_first().
  So end_that_request_first() and end_that_request_last() are called
  separately in cdrom_newpc_intr().

  This means blk_end_request_callback() has to return without
  completing request even if no leftover in the request.
  To satisfy the requirement, callback function has return value
  so that drivers can tell blk_end_request_callback() to return
  without completing request.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   72 ++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/blkdev.h |    2 +
 2 files changed, 68 insertions(+), 6 deletions(-)

Index: 2.6.24-rc4/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc4.orig/block/ll_rw_blk.c
+++ 2.6.24-rc4/block/ll_rw_blk.c
@@ -3803,10 +3803,14 @@ static void complete_request(struct requ
 }
 
 /**
- * blk_end_request - Helper function for drivers to complete the request.
- * @rq:       the request being processed
- * @error:    0 for success, < 0 for error
- * @nr_bytes: number of bytes to complete
+ * blk_end_io - Generic end_io function to complete a request.
+ * @rq:           the request being processed
+ * @error:        0 for success, < 0 for error
+ * @nr_bytes:     number of bytes to complete
+ * @drv_callback: function called between completion of bios in the request
+ *                and completion of the request.
+ *                If the callback returns non 0, this helper returns without
+ *                completion of the request.
  *
  * Description:
  *     Ends I/O on a number of bytes attached to @rq.
@@ -3814,9 +3818,10 @@ static void complete_request(struct requ
  *
  * Return:
  *     0 - we are done with this request
- *     1 - still buffers pending for this request
+ *     1 - this request is not freed yet, it still has pending buffers.
  **/
-int blk_end_request(struct request *rq, int error, int nr_bytes)
+static int blk_end_io(struct request *rq, int error, int nr_bytes,
+		      int (drv_callback)(struct request *))
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
@@ -3833,6 +3838,10 @@ int blk_end_request(struct request *rq, 
 			return 1;
 	}
 
+	/* Special feature for tricky drivers */
+	if (drv_callback && drv_callback(rq))
+		return 1;
+
 	add_disk_randomness(rq->rq_disk);
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -3841,6 +3850,25 @@ int blk_end_request(struct request *rq, 
 
 	return 0;
 }
+
+/**
+ * blk_end_request - Helper function for drivers to complete the request.
+ * @rq:       the request being processed
+ * @error:    0 for success, < 0 for error
+ * @nr_bytes: number of bytes to complete
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ * Return:
+ *     0 - we are done with this request
+ *     1 - still buffers pending for this request
+ **/
+int blk_end_request(struct request *rq, int error, int nr_bytes)
+{
+	return blk_end_io(rq, error, nr_bytes, NULL);
+}
 EXPORT_SYMBOL_GPL(blk_end_request);
 
 /**
@@ -3879,6 +3907,38 @@ int __blk_end_request(struct request *rq
 }
 EXPORT_SYMBOL_GPL(__blk_end_request);
 
+/**
+ * blk_end_request_callback - Special helper function for tricky drivers
+ * @rq:           the request being processed
+ * @error:        0 for success, < 0 for error
+ * @nr_bytes:     number of bytes to complete
+ * @drv_callback: function called between completion of bios in the request
+ *                and completion of the request.
+ *                If the callback returns non 0, this helper returns without
+ *                completion of the request.
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ *     This special helper function is used only for existing tricky drivers.
+ *     (e.g. cdrom_newpc_intr() of ide-cd)
+ *     This interface will be removed when such drivers are rewritten.
+ *     Don't use this interface in other places anymore.
+ *
+ * Return:
+ *     0 - we are done with this request
+ *     1 - this request is not freed yet.
+ *         this request still has pending buffers or
+ *         the driver doesn't want to finish this request yet.
+ **/
+int blk_end_request_callback(struct request *rq, int error, int nr_bytes,
+			     int (drv_callback)(struct request *))
+{
+	return blk_end_io(rq, error, nr_bytes, drv_callback);
+}
+EXPORT_SYMBOL_GPL(blk_end_request_callback);
+
 static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			    struct bio *bio)
 {
Index: 2.6.24-rc4/include/linux/blkdev.h
===================================================================
--- 2.6.24-rc4.orig/include/linux/blkdev.h
+++ 2.6.24-rc4/include/linux/blkdev.h
@@ -736,6 +736,8 @@ extern void end_that_request_last(struct
 extern void end_request(struct request *, int);
 extern void end_queued_request(struct request *, int);
 extern void end_dequeued_request(struct request *, int);
+extern int blk_end_request_callback(struct request *rq, int error, int nr_bytes,
+				    int (drv_callback)(struct request *));
 extern void blk_complete_request(struct request *);
 
 /*
