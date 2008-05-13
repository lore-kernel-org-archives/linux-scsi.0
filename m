From: malahal@us.ibm.com
Subject: blk request timeout minor fixes
Date: Mon, 12 May 2008 20:19:03 -0700
Message-ID: <20080513031903.GB9511@us.ibm.com>
References: <20080503020000.GU14976@parisc-linux.org> <20080507074357.GP329@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:33595 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbYEMDTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 23:19:05 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4D3J5RB028000
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2008 23:19:05 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4D3J4Mv215642
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2008 21:19:04 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4D3J4j1011912
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2008 21:19:04 -0600
Content-Disposition: inline
In-Reply-To: <20080507074357.GP329@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

Adds deadline field to preserve the timeout on retries.  Calculates next
timeout for mod_timer correctly and uses an extra symbol, next_set, as
zero could be a valid 'next' value. Based off of timeout branch from Jens
git repo.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r 012f73f0499b -r c06b3eb1f516 block/blk-core.c
--- a/block/blk-core.c	Wed May 07 20:00:09 2008 -0700
+++ b/block/blk-core.c	Wed May 07 20:07:12 2008 -0700
@@ -123,6 +123,7 @@
 	rq->tag = -1;
 	rq->ref_count = 1;
 	rq->timeout = 0;
+	rq->deadline = 0;
 }
 EXPORT_SYMBOL(blk_rq_init);
 
@@ -1739,21 +1740,24 @@
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
@@ -1792,9 +1796,9 @@
 	BUG_ON(!list_empty(&req->timeout_list));
 
 	if (req->timeout)
-		req->timeout += jiffies;
+		req->deadline = jiffies + req->timeout;
 	else
-		req->timeout = jiffies + q->rq_timeout;
+		req->deadline = jiffies + q->rq_timeout;
 
 	list_add_tail(&req->timeout_list, &q->timeout_list);
 
@@ -1803,7 +1807,7 @@
 	 * than an existing one, modify the timer. Round to next nearest
 	 * second.
 	 */
-	expiry = round_jiffies(req->timeout);
+	expiry = round_jiffies(req->deadline);
 	if (!timer_pending(&q->timeout) ||
 	    time_before(expiry, q->timeout.expires))
 		mod_timer(&q->timeout, expiry);
diff -r 012f73f0499b -r c06b3eb1f516 include/linux/blkdev.h
--- a/include/linux/blkdev.h	Wed May 07 20:00:09 2008 -0700
+++ b/include/linux/blkdev.h	Wed May 07 20:07:12 2008 -0700
@@ -225,8 +225,9 @@
 	void *data;
 	void *sense;
 
-	unsigned long timeout;
+	unsigned long deadline;
 	struct list_head timeout_list;
+	unsigned int timeout;
 	int retries;
 
 	/*
