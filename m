From: malahal@us.ibm.com
Subject: Re: blk request timeout handler against 2.6.26
Date: Mon, 5 May 2008 18:47:32 -0700
Message-ID: <20080506014732.GA6249@us.ibm.com>
References: <20080503020000.GU14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60948 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYEFBre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2008 21:47:34 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m461ngE3012140
	for <linux-scsi@vger.kernel.org>; Mon, 5 May 2008 21:49:42 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m461lXeG300514
	for <linux-scsi@vger.kernel.org>; Mon, 5 May 2008 21:47:33 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m461lXPF021483
	for <linux-scsi@vger.kernel.org>; Mon, 5 May 2008 21:47:33 -0400
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.130])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m461lXaq021474
	for <linux-scsi@vger.kernel.org>; Mon, 5 May 2008 21:47:33 -0400
Content-Disposition: inline
In-Reply-To: <20080503020000.GU14976@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Matthew Wilcox [matthew@wil.cx] wrote:
> 
> This patch is a forward-port of the patch Jens posted last October.
> gdth_proc needs some loving, I just #if 0'd it out for the moment.

I posted a patch for gdth driver.  Here is a link:
http://article.gmane.org/gmane.linux.scsi/36024
The patch is taken into 'timeout' branch of Jen's block git tree.

> +static void blk_rq_timed_out_timer(unsigned long data)
> +{
> +	struct request_queue *q = (struct request_queue *) data;
> +	unsigned long flags, next = 0;
> +	struct request *rq, *tmp;
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +
> +	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list) {
> +		if (!next || time_before(next, rq->timeout))
   
Above should be time_after() rather than time_before, I think.  I posted
a patch for it here, http://article.gmane.org/gmane.linux.scsi/36528.

> +void blk_complete_request(struct request *req)
> +{
> +	/*
> +	 * We don't have to worry about this one timing out any more.
> +	 * If we are unable to remove the timer, then the command
> +	 * has already timed out.  In which case, we have no choice but to
> +	 * let the timeout function run, as we have no idea where in fact
> +	 * that function could really be.  It might be on another processor,
> +	 * etc, etc.
> +	 */
> +	if (!blk_delete_timer(req))
> +		return;

blk_delete_timer() requires that the queue lock must be held.
blk_complete_request() is called without holding the lock (e.g. from
scsi_done). Maybe, blk_complete_request() should hold the lock while
calling blk_delete_timer()?

I tested with the following code and it seems to work fine.

diff -r 9239c54db9f0 block/blk-core.c
--- a/block/blk-core.c	Thu May 01 14:23:05 2008 -0700
+++ b/block/blk-core.c	Mon May 05 18:46:07 2008 -0700
@@ -1864,6 +1864,10 @@
  */
 void blk_complete_request(struct request *req)
 {
+	unsigned long flags;
+	struct request_queue *q = req->q;
+	int rc;
+
 	/*
 	 * We don't have to worry about this one timing out any more.
 	 * If we are unable to remove the timer, then the command
@@ -1872,7 +1876,10 @@
 	 * that function could really be.  It might be on another processor,
 	 * etc, etc.
 	 */
-	if (!blk_delete_timer(req))
+	spin_lock_irqsave(q->queue_lock, flags);
+	rc = blk_delete_timer(req);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+	if (!rc)
 		return;
 
 	__blk_complete_request(req);
