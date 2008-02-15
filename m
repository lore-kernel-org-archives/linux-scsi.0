From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 02/13] block: add request submission interface
Date: Fri, 15 Feb 2008 17:29:38 -0500 (EST)
Message-ID: <20080215.172938.125896466.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761075AbYBOWaI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:30:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch adds a generic request submission interface for request
stacking drivers so that request-based dm can use it to submit
clones to underlying devices.

The request may have been made based on limitations of other queues.
So generic limitation checks based on the submitting queue are needed.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-core.c       |   65 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    1 
 2 files changed, 66 insertions(+)

Index: 2.6.25-rc1/block/blk-core.c
===================================================================
--- 2.6.25-rc1.orig/block/blk-core.c
+++ 2.6.25-rc1/block/blk-core.c
@@ -1510,6 +1510,71 @@ void submit_bio(int rw, struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio);
 
+/*
+ * Check a request for queue limits
+ */
+static int check_queue_limit(struct request_queue *q, struct request *rq)
+{
+	if (rq->nr_sectors > q->max_sectors ||
+	    rq->data_len >> 9 > q->max_hw_sectors) {
+		printk(KERN_ERR "%s: over max size limit.\n", __func__);
+		return 1;
+	}
+
+	/*
+	 * queue's settings related to segment counting like q->bounce_pfn
+	 * may differ from that of other stacking queues.
+	 * Recalculate it to check the request correctly on this queue's
+	 * limitation.
+	 */
+	blk_recalc_rq_segments(rq);
+	if (rq->nr_phys_segments > q->max_phys_segments ||
+	    rq->nr_hw_segments > q->max_hw_segments) {
+		printk(KERN_ERR "%s: over max segments limit.\n", __func__);
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * blk_submit_request - Helper for stacking drivers to submit the request
+ * @q:  the queue to submit the request
+ * @rq: the request being queued
+ **/
+void blk_submit_request(struct request_queue *q, struct request *rq)
+{
+	unsigned long flags;
+
+	if (check_queue_limit(q, rq))
+		goto end_io;
+
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+	if (rq->rq_disk && rq->rq_disk->flags & GENHD_FL_FAIL &&
+	    should_fail(&fail_make_request, blk_rq_bytes(rq)))
+		goto end_io;
+#endif
+
+	spin_lock_irqsave(q->queue_lock, flags);
+
+	/*
+	 * Submitting request must be dequeued before calling this function
+	 * because it will be linked to another request_queue
+	 */
+	BUG_ON(blk_queued_rq(rq));
+
+	drive_stat_acct(rq, 1);
+	__elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 0);
+
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return;
+
+end_io:
+	blk_end_request(rq, -EIO, blk_rq_bytes(rq));
+}
+EXPORT_SYMBOL_GPL(blk_submit_request);
+
 /**
  * __end_that_request_first - end I/O on a request
  * @req:      the request being processed
Index: 2.6.25-rc1/include/linux/blkdev.h
===================================================================
--- 2.6.25-rc1.orig/include/linux/blkdev.h
+++ 2.6.25-rc1/include/linux/blkdev.h
@@ -616,6 +616,7 @@ extern void blk_end_sync_rq(struct reque
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern void blk_insert_request(struct request_queue *, struct request *, int, void *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
+extern void blk_submit_request(struct request_queue *q, struct request *rq);
 extern void blk_plug_device(struct request_queue *);
 extern int blk_remove_plug(struct request_queue *);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
