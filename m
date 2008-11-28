From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2.6.28-rc6] block: internal dequeue shouldn't start timer
Date: Fri, 28 Nov 2008 13:05:16 +0900
Message-ID: <492F6DFC.3010103@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:59563 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbYK1EFc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2008 23:05:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linu
Cc: Hannes Reinecke <hare@suse.de>

blkdev_dequeue_request() and elv_dequeue_request() are equivalent and
both start the timeout timer.  Barrier code dequeues the original
barrier request but doesn't passes the request itself to lower level
driver, only broken down proxy requests; however, as the original
barrier code goes through the same dequeue path and timeout timer is
started on it.  If barrier sequence takes long enough, this timer
expires but the low level driver has no idea about this request and
oops follows.

Timeout timer shouldn't have been started on the original barrier
request as it never goes through actual IO.  This patch unexports
elv_dequeue_request(), which has no external user anyway, and makes it
operate on elevator proper w/o adding the timer and make
blkdev_dequeue_request() call elv_dequeue_request() and add timer.
Internal users which don't pass the request to driver - barrier code
and end_that_request_last() - are converted to use
elv_dequeue_request().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
---
Mike, this should fix the problem you were seeing (blk_add_timer on
requests w/o REQ_STARTED set).

 block/blk-barrier.c    |    4 ++--
 block/blk-core.c       |   24 +++++++++++++++++++++++-
 block/elevator.c       |    7 -------
 include/linux/blkdev.h |    7 ++-----
 4 files changed, 27 insertions(+), 15 deletions(-)

Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -1637,6 +1637,28 @@ int blk_insert_cloned_request(struct req
 EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
 
 /**
+ * blkdev_dequeue_request - dequeue request and start timeout timer
+ * @req: request to dequeue
+ *
+ * Dequeue @req and start timeout timer on it.  This hands off the
+ * request to the driver.
+ *
+ * Block internal functions which don't want to start timer should
+ * call elv_dequeue_request().
+ */
+void blkdev_dequeue_request(struct request *req)
+{
+	elv_dequeue_request(req->q, req);
+
+	/*
+	 * We are now handing the request to the hardware, add the
+	 * timeout handler.
+	 */
+	blk_add_timer(req);
+}
+EXPORT_SYMBOL(blkdev_dequeue_request);
+
+/**
  * __end_that_request_first - end I/O on a request
  * @req:      the request being processed
  * @error:    %0 for success, < %0 for error
@@ -1774,7 +1796,7 @@ static void end_that_request_last(struct
 		blk_queue_end_tag(req->q, req);
 
 	if (blk_queued_rq(req))
-		blkdev_dequeue_request(req);
+		elv_dequeue_request(req->q, req);
 
 	if (unlikely(laptop_mode) && blk_fs_request(req))
 		laptop_io_completion();
Index: work/block/elevator.c
===================================================================
--- work.orig/block/elevator.c
+++ work/block/elevator.c
@@ -844,14 +844,7 @@ void elv_dequeue_request(struct request_
 	 */
 	if (blk_account_rq(rq))
 		q->in_flight++;
-
-	/*
-	 * We are now handing the request to the hardware, add the
-	 * timeout handler.
-	 */
-	blk_add_timer(rq);
 }
-EXPORT_SYMBOL(elv_dequeue_request);
 
 int elv_queue_empty(struct request_queue *q)
 {
Index: work/include/linux/blkdev.h
===================================================================
--- work.orig/include/linux/blkdev.h
+++ work/include/linux/blkdev.h
@@ -786,6 +786,8 @@ static inline void blk_run_address_space
 		blk_run_backing_dev(mapping->backing_dev_info, NULL);
 }
 
+extern void blkdev_dequeue_request(struct request *req);
+
 /*
  * blk_end_request() and friends.
  * __blk_end_request() and end_request() must be called with
@@ -820,11 +822,6 @@ extern void blk_update_request(struct re
 extern unsigned int blk_rq_bytes(struct request *rq);
 extern unsigned int blk_rq_cur_bytes(struct request *rq);
 
-static inline void blkdev_dequeue_request(struct request *req)
-{
-	elv_dequeue_request(req->q, req);
-}
-
 /*
  * Access functions for manipulating queue properties
  */
Index: work/block/blk-barrier.c
===================================================================
--- work.orig/block/blk-barrier.c
+++ work/block/blk-barrier.c
@@ -161,7 +161,7 @@ static inline struct request *start_orde
 	/*
 	 * Prep proxy barrier request.
 	 */
-	blkdev_dequeue_request(rq);
+	elv_dequeue_request(q, rq);
 	q->orig_bar_rq = rq;
 	rq = &q->bar_rq;
 	blk_rq_init(q, rq);
@@ -219,7 +219,7 @@ int blk_do_ordered(struct request_queue
 			 * This can happen when the queue switches to
 			 * ORDERED_NONE while this request is on it.
 			 */
-			blkdev_dequeue_request(rq);
+			elv_dequeue_request(q, rq);
 			if (__blk_end_request(rq, -EOPNOTSUPP,
 					      blk_rq_bytes(rq)))
 				BUG();
