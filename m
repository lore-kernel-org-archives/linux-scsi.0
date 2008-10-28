From: malahal@us.ibm.com
Subject: [PATCH] block: optimizations in blk_rq_timed_out_timer()
Date: Tue, 28 Oct 2008 11:22:43 -0700
Message-ID: <20081028182243.GA6716@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:39909 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbYJ1SW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2008 14:22:57 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9SIMb2W005857
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2008 12:22:38 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9SIMogj129746
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2008 12:22:52 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9SIMkrn029799
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2008 12:22:46 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com

Now the rq->deadline can't be zero if the request is in the
timeout_list, so there is no need to have next_set. There is no need to
access a request's deadline field if blk_rq_timed_out is called on it.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r a6ae42397ede block/blk-timeout.c
--- a/block/blk-timeout.c	Thu Oct 23 11:48:45 2008 -0700
+++ b/block/blk-timeout.c	Fri Oct 24 17:08:24 2008 -0700
@@ -118,7 +118,7 @@
 void blk_rq_timed_out_timer(unsigned long data)
 {
 	struct request_queue *q = (struct request_queue *) data;
-	unsigned long flags, uninitialized_var(next), next_set = 0;
+	unsigned long flags, next = 0;
 	struct request *rq, *tmp;
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -133,15 +133,13 @@
 			if (blk_mark_rq_complete(rq))
 				continue;
 			blk_rq_timed_out(rq);
+		} else {
+			if (!next || time_after(next, rq->deadline))
+				next = rq->deadline;
 		}
-		if (!next_set) {
-			next = rq->deadline;
-			next_set = 1;
-		} else if (time_after(next, rq->deadline))
-			next = rq->deadline;
 	}
 
-	if (next_set && !list_empty(&q->timeout_list))
+	if (next)
 		mod_timer(&q->timeout, round_jiffies(next));
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
