From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 05/13] block: Make blk_cleanup_queue() wait until request_fn
 finished
Date: Wed, 28 Nov 2012 13:46:45 +0100
Message-ID: <50B607B5.7020808@acm.org>
References: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:46499 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab2K1Mqq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2012 07:46:46 -0500
In-Reply-To: <50B60619.4080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Some request_fn implementations, e.g. scsi_request_fn(), unlock
the queue lock internally. This may result in multiple threads
executing request_fn for the same queue simultaneously. Keep
track of the number of active request_fn calls and make sure that
blk_cleanup_queue() waits until all active request_fn invocations
have finished. A block driver may start cleaning up resources
needed by its request_fn as soon as blk_cleanup_queue() finished,
so blk_cleanup_queue() must wait for all outstanding request_fn
invocations to finish.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reported-by: Chanho Min <chanho.min@lge.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c       |   10 ++++++++++
 include/linux/blkdev.h |    6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 12deca9..4d09af4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -309,7 +309,16 @@ inline void __blk_run_queue_uncond(struct request_queue *q)
 	if (unlikely(blk_queue_dead(q)))
 		return;
 
+	/*
+	 * Some request_fn implementations, e.g. scsi_request_fn(), unlock
+	 * the queue lock internally. As a result multiple threads may be
+	 * running such a request function concurrently. Keep track of the
+	 * number of active request_fn invocations such that blk_drain_queue()
+	 * can wait until all these request_fn calls have finished.
+	 */
+	q->request_fn_active++;
 	q->request_fn(q);
+	q->request_fn_active--;
 }
 
 /**
@@ -408,6 +417,7 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
 			__blk_run_queue(q);
 
 		drain |= q->nr_rqs_elvpriv;
+		drain |= q->request_fn_active;
 
 		/*
 		 * Unfortunately, requests are queued at and tracked from
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8bc46c2..c9d233e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -378,6 +378,12 @@ struct request_queue {
 
 	unsigned int		nr_sorted;
 	unsigned int		in_flight[2];
+	/*
+	 * Number of active block driver functions for which blk_drain_queue()
+	 * must wait. Must be incremented around functions that unlock the
+	 * queue_lock internally, e.g. scsi_request_fn().
+	 */
+	unsigned int		request_fn_active;
 
 	unsigned int		rq_timeout;
 	struct timer_list	timeout;
-- 
1.7.10.4

