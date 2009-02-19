From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
Date: Thu, 19 Feb 2009 18:41:21 +0000
Message-ID: <1235068881.12500.33.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0902191002160.3012-100000@iolanthe.rowland.org>
	 <404514.58700.qm@web110616.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42640 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbZBSSl0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2009 13:41:26 -0500
In-Reply-To: <404514.58700.qm@web110616.mail.gq1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, rjw@sisk.pl, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org

On Thu, 2009-02-19 at 08:52 -0800, Sitsofe Wheeler wrote:
> > From: Alan Stern <stern@rowland.harvard.edu>
> >
> > On Thu, 19 Feb 2009, Sitsofe Wheeler wrote:
> > 
> > > Hi,
> > > 
> > > There appears to be a regression from 2.6.28 in how disk errors are
> > > handled in 2.6.29rc5 - rather than trying and eventually giving up, it
> > > appears to try (and report) forever. 
> > 
> > See this thread and patch:
> > 
> >     http://marc.info/?l=linux-kernel&m=123490148422684&w=2
> 
> The patch there (actually I downloaded it from http://patchwork.kernel.org/patch/7989/ )
> did not make any diference. I fear my disk will soon have torn itself to bits but until then I
> can trigger the error at will so I can test any patches that are suggested...

Can you try this patch ... it was something I meant to get into 2.6.29
but forgot about.  The key problem that you seem to be hitting is that
the requeue evades the timeout check.  Moving the timeout check to block
should fix that.

James

---

>From 5546538f37a1f4319ec4dbdb6f2e7261ce986e61 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 16 Dec 2008 17:00:44 -0500
Subject: block: move SCSI timeout check into block

We can eliminate the SCSI command timed out check entirely if the block
layer does this for us.  The way to do this in block is to check how
long the request has been outstanding if a requeue is requested and
ending it if we've gone over retries * timeout.

This will also eliminate many cases in SCSI where we evade the command
timeout for various reasons (like initial success converted to requeue)

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/blk-core.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 29bcfac..3928ec8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -937,6 +937,8 @@ EXPORT_SYMBOL(blk_start_queueing);
  */
 void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
+	unsigned long wait_for = (rq->retries + 1) * rq->timeout;
+
 	blk_delete_timer(rq);
 	blk_clear_rq_complete(rq);
 	trace_block_rq_requeue(q, rq);
@@ -944,7 +946,13 @@ void blk_requeue_request(struct request_queue *q, struct request *rq)
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(q, rq);
 
-	elv_requeue_request(q, rq);
+	if (time_before(rq->start_time + wait_for, jiffies)) {
+		printk(KERN_ERR "%s: timing out command, waited %lus\n",
+		       rq->rq_disk ? rq->rq_disk->disk_name : "?",
+		       wait_for/HZ);
+		blk_end_request(rq, -EIO, blk_rq_bytes(rq));
+	} else
+		elv_requeue_request(q, rq);
 }
 EXPORT_SYMBOL(blk_requeue_request);
 
-- 
1.5.6.6



