From: malahal@us.ibm.com
Subject: [PATCH] blk request timeout minor fixes...
Date: Sun, 2 Dec 2007 17:53:30 -0800
Message-ID: <20071203015330.GA3485@us.ibm.com>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com> <20071107132256.GG5525@kernel.dk> <20071114023929.GB29136@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:55573 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLCBxz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2007 20:53:55 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB31ro4K008676
	for <linux-scsi@vger.kernel.org>; Sun, 2 Dec 2007 20:53:50 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB31rnsK119578
	for <linux-scsi@vger.kernel.org>; Sun, 2 Dec 2007 18:53:49 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB31rnrF017256
	for <linux-scsi@vger.kernel.org>; Sun, 2 Dec 2007 18:53:49 -0700
Content-Disposition: inline
In-Reply-To: <20071114023929.GB29136@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com

Adds deadline field to preserve the timeout on retries.  Calculates next
timeout for mod_timer correctly and uses an extra symbol, next_set, as
zero could be a valid 'next' value. Based off of timeout branch from Jens
git repo.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 79ed268..6bf31f0 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -259,6 +259,7 @@ static void rq_init(struct request_queue *q, struct request *rq)
 	INIT_LIST_HEAD(&rq->timeout_list);
 
 	rq->timeout = 0;
+	rq->deadline = 0;
 	rq->errors = 0;
 	rq->bio = rq->biotail = NULL;
 	INIT_HLIST_NODE(&rq->hash);
@@ -3707,21 +3708,24 @@ static void blk_rq_timed_out(struct request *req)
 static void blk_rq_timed_out_timer(unsigned long data)
 {
 	struct request_queue *q = (struct request_queue *) data;
-	unsigned long flags, next = 0;
+	unsigned long flags, next, next_set = 0;
 	struct request *rq, *tmp;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
 	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list) {
-		if (!next || time_before(next, rq->timeout))
-			next = rq->timeout;
-		if (time_after_eq(jiffies, rq->timeout)) {
+		if (time_after_eq(jiffies, rq->deadline)) {
 			list_del_init(&rq->timeout_list);
 			blk_rq_timed_out(rq);
 		}
+		if (!next_set) {
+			next = rq->deadline;
+			next_set = 1;
+		} else if (time_after(next, rq->deadline))
+			next = rq->deadline;
 	}
 
-	if (next)
+	if (next_set)
 		mod_timer(&q->timeout, round_jiffies(next));
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
@@ -3760,9 +3764,9 @@ void blk_add_timer(struct request *req)
 	BUG_ON(!list_empty(&req->timeout_list));
 
 	if (req->timeout)
-		req->timeout += jiffies;
+		req->deadline = jiffies + req->timeout;
 	else
-		req->timeout = jiffies + q->rq_timeout;
+		req->deadline = jiffies + q->rq_timeout;
 
 	list_add_tail(&req->timeout_list, &q->timeout_list);
 
@@ -3771,7 +3775,7 @@ void blk_add_timer(struct request *req)
 	 * than an existing one, modify the timer. Round to next nearest
 	 * second.
 	 */
-	expiry = round_jiffies(req->timeout);
+	expiry = round_jiffies(req->deadline);
 	if (!timer_pending(&q->timeout) ||
 	    time_before(expiry, q->timeout.expires))
 		mod_timer(&q->timeout, expiry);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 917fe86..e495d61 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -295,7 +295,8 @@ struct request {
 	void *data;
 	void *sense;
 
-	unsigned long timeout;
+	unsigned long deadline;
+	unsigned int timeout;
 	struct list_head timeout_list;
 	int retries;
 
