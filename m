From: malahal@us.ibm.com
Subject: Re: [PATCH] blk request timeout minor fixes...
Date: Mon, 3 Dec 2007 15:47:03 -0800
Message-ID: <20071203234703.GA16786@us.ibm.com>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com> <20071107132256.GG5525@kernel.dk> <20071114023929.GB29136@us.ibm.com> <20071203015330.GA3485@us.ibm.com> <20071203024945.GO2584@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60415 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbXLCXrI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Dec 2007 18:47:08 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB3Nl5J2010734
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2007 18:47:05 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3Nl5JS121280
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2007 18:47:05 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB3Nl4cc004965
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2007 18:47:05 -0500
Content-Disposition: inline
In-Reply-To: <20071203024945.GO2584@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, andmike@us.ibm.com

Matthew Wilcox [matthew@wil.cx] wrote:
> On Sun, Dec 02, 2007 at 05:53:30PM -0800, malahal@us.ibm.com wrote:
> Can I suggest running 'pahole' over this when compiled on 64-bit?
> You've just introduced a 4-byte hole.

This one fixes the 4-byte hole. Thank you very much.


diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 79ed268..5e95fa8 100644
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
+	unsigned long flags, uninitialized_var(next), next_set = 0;
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
index 917fe86..834d097 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -295,8 +295,9 @@ struct request {
 	void *data;
 	void *sense;
 
-	unsigned long timeout;
+	unsigned long deadline;
 	struct list_head timeout_list;
+	unsigned int timeout;
 	int retries;
 
 	/*
