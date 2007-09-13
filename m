From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix race with shared tag queue maps
Date: Thu, 13 Sep 2007 17:22:23 +0200
Message-ID: <20070913152222.GS25592@kernel.dk>
References: <20070913122652.GK25592@kernel.dk> <alpine.LFD.0.999.0709130813220.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:28659 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbXIMPWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Sep 2007 11:22:38 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709130813220.16478@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, orgis@agnld.uni-potsdam.de, arekm@maven.pl, ed.lin@promise.com, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com

On Thu, Sep 13 2007, Linus Torvalds wrote:
> 
> 
> On Thu, 13 Sep 2007, Jens Axboe wrote:
> > +
> > +	/*
> > +	 * Ensure ordering with tag section
> > +	 */
> > +	smp_mb__before_clear_bit();
> > +
> > +	if (unlikely(!test_and_clear_bit(tag, bqt->tag_map))) {
> 
> You don't need the "smp_mb__before_clear_bit()" there.
> 
> The regular "clear_bit()" needs it, but the "test_and_xxx()" versions are 
> architecturally defined to be memory barriers, exactly because they are 
> regularly used for locking.
> 
> This is even documented - see Documentation/atomic_ops.txt.

My bad, I think I added the smp_mb__before_clear_bit() when it was
__test_and_set_bit() like in the first hunk.

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index a15845c..dfc9f22 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1075,12 +1075,6 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 		 */
 		return;
 
-	if (unlikely(!__test_and_clear_bit(tag, bqt->tag_map))) {
-		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
-		       __FUNCTION__, tag);
-		return;
-	}
-
 	list_del_init(&rq->queuelist);
 	rq->cmd_flags &= ~REQ_QUEUED;
 	rq->tag = -1;
@@ -1090,6 +1084,18 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 		       __FUNCTION__, tag);
 
 	bqt->tag_index[tag] = NULL;
+
+	if (unlikely(!test_and_clear_bit(tag, bqt->tag_map))) {
+		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
+		       __FUNCTION__, tag);
+		return;
+	}
+
+	/*
+	 * Ensure ordering between ->tag_index[tag] clear and tag clear
+	 */
+	smp_mb__after_clear_bit();
+
 	bqt->busy--;
 }
 

-- 
Jens Axboe

