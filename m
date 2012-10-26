From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5/7] block: Make blk_cleanup_queue() wait until request_fn
 finished
Date: Fri, 26 Oct 2012 14:04:27 +0200
Message-ID: <508A7C4B.2060904@acm.org>
References: <508A7B63.60608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:37594 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab2JZME2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2012 08:04:28 -0400
In-Reply-To: <508A7B63.60608@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

Some request_fn implementations, e.g. scsi_request_fn(), unlock
the queue lock. Make sure that blk_cleanup_queue() waits until all
active request_fn invocations have finished. A block driver may
start cleaning up resources needed by its request_fn as soon as
blk_cleanup_queue() finished, so blk_cleanup_queue() must wait
for all outstanding request_fn invocations to finish.

Reported-by: Chanho Min <chanho.min@lge.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c       |    3 +++
 include/linux/blkdev.h |    6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2f1be7a..7662d83 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -308,7 +308,9 @@ void inline __blk_run_queue_uncond(struct request_queue *q)
 	if (unlikely(blk_queue_dead(q)))
 		return;
 
+	q->request_fn_active++;
 	q->request_fn(q);
+	q->request_fn_active--;
 }
 
 /**
@@ -407,6 +409,7 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
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

