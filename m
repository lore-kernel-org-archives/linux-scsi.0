From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 1/3] block: add rq->complete_io hook for request
 stacking
Date: Fri, 15 Feb 2008 17:27:27 -0500 (EST)
Message-ID: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbYBOW1Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:27:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch adds ->complete_io() hook for request stacking.
Request stacking drivers (such as request-based dm) can set
a callback for completion.
(The hook is not called in blk_end_io(), since request-based dm uses
 it for clone completion in the following appendix patches.)

For the stacking to work without deadlock between stacking devices,
both the submission function and the completion function must be
called without the queue lock.
So the stacking is not available for __blk_end_request(), which
is called with the queue lock held.
The patch adds a queue flag (QUEUE_FLAG_STACKABLE) and a check to
make sure that the stacking is not enabled in drivers calling
__blk_end_request().

It means that only scsi mid-layer, cciss and i2o are ready for
the stacking.
I believe current dm-multipath users are using scsi, cciss and dasd.
So at least, dasd needs to be changed not to use __blk_end_request()
for request-based dm-multipath.



Below is the detailed explanation why the stacking is not possible
for drivers using __blk_end_request().

If the completion function is called with the queue lock held,
we have 2 deadlock problems:
  a). when the stacking driver completes the hooked request
  b). when the stacking driver submits other requests in that
      completion context

  Suppose we have the following stack:
     ________________________
    |                        |
    | stacking device: DEV#2 |
    |________________________|
     ________________________
    |                        |
    | real device:     DEV#1 |
    |________________________|

  For example of a):
    1. The device driver takes the queue lock for DEV#1
    2. The device driver calls __blk_end_request() for the request
       and it is hooked by the stacking driver
    3. The stacking driver tries to take the queue lock for DEV#1
       to complete the hooked request
    => deadlock happens on the queue lock for DEV#1

  For example of b): Assume the a) is worked-around by something
    1. The device driver takes the queue lock for DEV#1
    2. The device driver calls __blk_end_request() for the request
       and it is hooked by the stacking driver
    3. The stacking driver completes the hooked request
    4. The stacking driver dequeues the next request from DEV#2
       to dispatch quickly due to some performance reasons
    5. The stacking driver tries to take the queue lock for DEV#1
       to submit the next request
    => deadlock happens on the queue lock for DEV#1

To prevent such deadlock problems on the stacking, I'd like to say
that drivers which hold the queue lock when completing request are
not ready for the stacking.
So drivers using __blk_end_request() (and end_[queued|dequeued_]request())
need to be modified in this request stacking design, if we need to
use such devices for the stacking.

To prevent request stacking drivers from using such unstackable
devices, a queue flag, QUEUE_FLAG_STACKABLE, is added.
And device drivers can set it to be used by request stacking drivers.
(scsi patch is included just for an example of the setting.)
To detect wrong use of the flag and the hook, some checks are also
put in __blk_end_request().


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-core.c        |   31 +++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c |    7 +++++++
 include/linux/blkdev.h  |    7 +++++++
 3 files changed, 45 insertions(+)

Index: 2.6.25-rc1/block/blk-core.c
===================================================================
--- 2.6.25-rc1.orig/block/blk-core.c
+++ 2.6.25-rc1/block/blk-core.c
@@ -138,6 +138,7 @@ void rq_init(struct request_queue *q, st
 	rq->data = NULL;
 	rq->sense = NULL;
 	rq->end_io = NULL;
+	rq->complete_io = NULL;
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
 }
@@ -1917,6 +1918,9 @@ static int blk_end_io(struct request *rq
  **/
 int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
+	if (rq->complete_io)
+		return rq->complete_io(rq, error, nr_bytes, 0, NULL);
+
 	return blk_end_io(rq, error, nr_bytes, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(blk_end_request);
@@ -1936,6 +1940,27 @@ EXPORT_SYMBOL_GPL(blk_end_request);
  **/
 int __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
+	if (unlikely(blk_queue_stackable(rq->q)))
+		printk(KERN_WARNING "dev: %s: Not ready for request stacking, "
+		       "but the device driver set it stackable. "
+		       "Need to fix the device driver!\n",
+		       rq->rq_disk ? rq->rq_disk->disk_name : "?");
+
+	if (unlikely(rq->complete_io)) {
+		/*
+		 * If we invoke the ->complete_io here, the request submitter's
+		 * handler would get deadlock on the queue lock.
+		 *
+		 * This happens, when the request submitter didn't check
+		 * whether the queue is stackable or the device driver marked
+		 * the queue stackable.
+		 * Need to fix the request submitter or the device driver.
+		 */
+		printk(KERN_ERR "The device driver isn't ready for "
+		       "request stacking.\n");
+		BUG();
+	}
+
 	if (blk_fs_request(rq) || blk_pc_request(rq)) {
 		if (__end_that_request_first(rq, error, nr_bytes))
 			return 1;
@@ -1966,6 +1991,9 @@ EXPORT_SYMBOL_GPL(__blk_end_request);
 int blk_end_bidi_request(struct request *rq, int error, unsigned int nr_bytes,
 			 unsigned int bidi_bytes)
 {
+	if (rq->complete_io)
+		return rq->complete_io(rq, error, nr_bytes, bidi_bytes, NULL);
+
 	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
 }
 EXPORT_SYMBOL_GPL(blk_end_bidi_request);
@@ -1999,6 +2027,9 @@ int blk_end_request_callback(struct requ
 			     unsigned int nr_bytes,
 			     int (drv_callback)(struct request *))
 {
+	if (rq->complete_io)
+		return rq->complete_io(rq, error, nr_bytes, 0, drv_callback);
+
 	return blk_end_io(rq, error, nr_bytes, 0, drv_callback);
 }
 EXPORT_SYMBOL_GPL(blk_end_request_callback);
Index: 2.6.25-rc1/include/linux/blkdev.h
===================================================================
--- 2.6.25-rc1.orig/include/linux/blkdev.h
+++ 2.6.25-rc1/include/linux/blkdev.h
@@ -42,6 +42,9 @@ void copy_io_context(struct io_context *
 
 struct request;
 typedef void (rq_end_io_fn)(struct request *, int);
+typedef int (rq_complete_io_fn)(struct request *rq, int error,
+				unsigned int nr_bytes, unsigned int bidi_bytes,
+				int (drv_callback)(struct request *));
 
 struct request_list {
 	int count[2];
@@ -228,6 +231,7 @@ struct request {
 	 * completion callback.
 	 */
 	rq_end_io_fn *end_io;
+	rq_complete_io_fn *complete_io;
 	void *end_io_data;
 
 	/* for bidi */
@@ -401,6 +405,7 @@ struct request_queue
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
+#define QUEUE_FLAG_STACKABLE	10	/* queue supports request stacking */
 
 enum {
 	/*
@@ -446,6 +451,8 @@ enum {
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_flushing(q)	((q)->ordseq)
+#define blk_queue_stackable(q)	\
+		test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
Index: 2.6.25-rc1/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.25-rc1.orig/drivers/scsi/scsi_lib.c
+++ 2.6.25-rc1/drivers/scsi/scsi_lib.c
@@ -1597,6 +1597,13 @@ struct request_queue *__scsi_alloc_queue
 	 */
 	blk_queue_dma_alignment(q, 0x03);
 
+	/*
+	 * SCSI is ready for request stacking, since it doesn't hold
+	 * queue lock when completing request.
+	 * (It doesn't use __blk_end_request().)
+	 */
+	set_bit(QUEUE_FLAG_STACKABLE, &q->queue_flags);
+
 	return q;
 }
 EXPORT_SYMBOL(__scsi_alloc_queue);
