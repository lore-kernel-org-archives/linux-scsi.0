From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/1] block: add lld busy state exporting interface
Date: Mon, 29 Sep 2008 11:35:58 -0400 (EDT)
Message-ID: <20080929.113558.112628070.k-ueda@ct.jp.nec.com>
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
Cc: k-ueda@ct.jp.nec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

I hope the previous RFC patch(*) would be no problem, since I haven't
gotten any negative comment.
    (*) http://lkml.org/lkml/2008/9/25/262

So could you take this patch for 2.6.28 additionally?
This patch adds a new interface for request stacking drivers.
There should be no regression risk.

This patch was created on top of the commit below of for-2.6.28.
---------------------------------------------------------------------
commit e857b07acc3f1352224f380fcbf26ef985116cc8
Author: Sven Schuetz <sven@linux.vnet.ibm.com>
Date:   Fri Sep 26 10:58:02 2008 +0200

    include blktrace_api.h in headers_install
---------------------------------------------------------------------

Thanks,
Kiyoshi Ueda


Subject: [PATCH 1/1] block: add lld busy state exporting interface

This patch adds an new interface, blk_lld_busy(), to check lld's
busy state from the block layer.
blk_lld_busy() calls down into low-level drivers for the checking
if the drivers set q->lld_busy_fn() using blk_queue_lld_busy().

This resolves a performance problem on request stacking devices below.

Some drivers like scsi mid layer stop dispatching request when
they detect busy state on its low-level device like host/target/device.
It allows other requests to stay in the I/O scheduler's queue
for a chance of merging.

Request stacking drivers like request-based dm should follow
the same logic.
However, there is no generic interface for the stacked device
to check if the underlying device(s) are busy.
If the request stacking driver dispatches and submits requests to
the busy underlying device, the requests will stay in
the underlying device's queue without a chance of merging.
This causes performance problem on burst I/O load.

With this patch, busy state of the underlying device is exported
via q->lld_busy_fn().  So the request stacking driver can check it
and stop dispatching requests if busy.

The underlying device driver must return the busy state appropriately:
    1: when the device driver can't process requests immediately.
    0: when the device driver can process requests immediately,
       including abnormal situations where the device driver needs
       to kill all requests.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c       |   25 +++++++++++++++++++++++++
 block/blk-settings.c   |    6 ++++++
 include/linux/blkdev.h |    4 ++++
 3 files changed, 35 insertions(+)

Index: linux-2.6-block/block/blk-settings.c
===================================================================
--- linux-2.6-block.orig/block/blk-settings.c
+++ linux-2.6-block/block/blk-settings.c
@@ -89,6 +89,12 @@ void blk_queue_rq_timed_out(struct reque
 }
 EXPORT_SYMBOL_GPL(blk_queue_rq_timed_out);
 
+void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn)
+{
+	q->lld_busy_fn = fn;
+}
+EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
+
 /**
  * blk_queue_make_request - define an alternate make_request function for a device
  * @q:  the request queue for the device to be affected
Index: linux-2.6-block/include/linux/blkdev.h
===================================================================
--- linux-2.6-block.orig/include/linux/blkdev.h
+++ linux-2.6-block/include/linux/blkdev.h
@@ -269,6 +269,7 @@ typedef int (merge_bvec_fn) (struct requ
 typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
 typedef int (dma_drain_needed_fn)(struct request *);
+typedef int (lld_busy_fn) (struct request_queue *q);
 
 enum blk_eh_timer_return {
 	BLK_EH_NOT_HANDLED,
@@ -325,6 +326,7 @@ struct request_queue
 	softirq_done_fn		*softirq_done_fn;
 	rq_timed_out_fn		*rq_timed_out_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
+	lld_busy_fn		*lld_busy_fn;
 
 	/*
 	 * Dispatch queue sorting
@@ -699,6 +701,7 @@ extern struct request *blk_get_request(s
 extern void blk_insert_request(struct request_queue *, struct request *, int, void *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
+extern int blk_lld_busy(struct request_queue *q);
 extern int blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 extern void blk_plug_device(struct request_queue *);
@@ -835,6 +838,7 @@ extern void blk_queue_update_dma_pad(str
 extern int blk_queue_dma_drain(struct request_queue *q,
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size);
+extern void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
Index: linux-2.6-block/block/blk-core.c
===================================================================
--- linux-2.6-block.orig/block/blk-core.c
+++ linux-2.6-block/block/blk-core.c
@@ -2098,6 +2098,31 @@ void blk_rq_bio_prep(struct request_queu
 		rq->rq_disk = bio->bi_bdev->bd_disk;
 }
 
+/**
+ * blk_lld_busy - Check if underlying low-level drivers of a device are busy
+ * @q : the queue of the device being checked
+ *
+ * Description:
+ *    Check if underlying low-level drivers of a device are busy.
+ *    If the drivers want to export their busy state, they must set own
+ *    exporting function using blk_queue_lld_busy() first.
+ *
+ *    Basically, this function is used only by request stacking drivers
+ *    to stop dispatching requests to underlying devices when underlying
+ *    devices are busy.  This behavior helps more I/O merging on the queue
+ *    of the request stacking driver and prevents I/O throughput regression
+ *    on burst I/O load.
+ *
+ * Return:
+ *    0 - Not busy (The request stacking driver should dispatch request)
+ *    1 - Busy (The request stacking driver should stop dispatching request)
+ */
+int blk_lld_busy(struct request_queue *q)
+{
+	return q->lld_busy_fn ? q->lld_busy_fn(q) : 0;
+}
+EXPORT_SYMBOL_GPL(blk_lld_busy);
+
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
 {
 	return queue_work(kblockd_workqueue, work);
