From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 1/2] block: Convert blk_run_queue() recursion into iteration
Date: Wed, 27 Feb 2013 15:47:08 +0100
Message-ID: <512E1C6C.3070200@acm.org>
References: <512E1C06.2000903@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:56313 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759935Ab3B0OrJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2013 09:47:09 -0500
In-Reply-To: <512E1C06.2000903@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Some block drivers, e.g. dm and SCSI, need to trigger a queue
run from inside functions that may be invoked by their request_fn()
implementation. Make sure that invoking blk_run_queue() instead
of blk_run_queue_async() from such functions does not trigger
recursion.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-core.c       |   34 +++++++++++++++++++++++-----------
 include/linux/blkdev.h |    8 ++------
 2 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c973249..ac4f310 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -304,22 +304,34 @@ EXPORT_SYMBOL(blk_sync_queue);
  *    This variant runs the queue whether or not the queue has been
  *    stopped. Must be called with the queue lock held and interrupts
  *    disabled. See also @blk_run_queue.
+ *
+ * Notes:
+ *    It is allowed to invoke __blk_run_queue() or blk_run_queue() (whichever
+ *    is appropriate) from inside a request_fn() implementation. Such
+ *    recursive calls are converted into iteration with the help of the
+ *    needs_rerun flag.
+ *
+ *    Some request_fn() implementations, e.g. scsi_request_fn() and
+ *    dm_request_fn(), unlock the queue lock internally. For such
+ *    implementations the request_fn_running check does not only prevent
+ *    recursion but also avoids that multiple threads execute such a
+ *    request_fn() implementation concurrently.
  */
 inline void __blk_run_queue_uncond(struct request_queue *q)
 {
 	if (unlikely(blk_queue_dead(q)))
 		return;
 
-	/*
-	 * Some request_fn implementations, e.g. scsi_request_fn(), unlock
-	 * the queue lock internally. As a result multiple threads may be
-	 * running such a request function concurrently. Keep track of the
-	 * number of active request_fn invocations such that blk_drain_queue()
-	 * can wait until all these request_fn calls have finished.
-	 */
-	q->request_fn_active++;
-	q->request_fn(q);
-	q->request_fn_active--;
+	if (!q->request_fn_running) {
+		do {
+			q->needs_rerun = false;
+			q->request_fn_running = true;
+			q->request_fn(q);
+			q->request_fn_running = false;
+		} while (q->needs_rerun);
+	} else {
+		q->needs_rerun = true;
+	}
 }
 
 /**
@@ -418,7 +430,7 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
 			__blk_run_queue(q);
 
 		drain |= q->nr_rqs_elvpriv;
-		drain |= q->request_fn_active;
+		drain |= q->request_fn_running;
 
 		/*
 		 * Unfortunately, requests are queued at and tracked from
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94bc83..20da3c8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -378,12 +378,8 @@ struct request_queue {
 
 	unsigned int		nr_sorted;
 	unsigned int		in_flight[2];
-	/*
-	 * Number of active block driver functions for which blk_drain_queue()
-	 * must wait. Must be incremented around functions that unlock the
-	 * queue_lock internally, e.g. scsi_request_fn().
-	 */
-	unsigned int		request_fn_active;
+	bool			request_fn_running;
+	bool			needs_rerun;
 
 	unsigned int		rq_timeout;
 	struct timer_list	timeout;
-- 
1.7.10.4


