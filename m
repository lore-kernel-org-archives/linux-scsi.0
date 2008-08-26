From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] [PATCH] Potential bug fix for blk_tag_queue
Date: Mon, 25 Aug 2008 20:46:20 -0600
Message-ID: <20080826024620.GC23698@parisc-linux.org>
References: <20080826005856.27375.59152.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53715 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbYHZCqh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2008 22:46:37 -0400
Content-Disposition: inline
In-Reply-To: <20080826005856.27375.59152.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <ajoglekar@nuovasystems.com>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Mon, Aug 25, 2008 at 06:03:01PM -0700, Abhijeet Joglekar wrote:
> The following patch fixes a potential bug in the blk_tag_queue structure.
> "busy" is used to keep track of outstanding tags, is declared as int,
> and updated inside queue lock. For host-wide shared tag map, this corrupts
> the value of busy, which hits BUG_ON during __blk_free_tags.

I believe you to be right.

> Recommend converting busy to atomic_t and using atomic_macros to access it.

ugh, more atomic ops.  How about just getting rid of it?  Patch
untested:

diff --git a/block/blk-tag.c b/block/blk-tag.c
index 32667be..ed5166f 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -38,7 +38,8 @@ static int __blk_free_tags(struct blk_queue_tag *bqt)
 
 	retval = atomic_dec_and_test(&bqt->refcnt);
 	if (retval) {
-		BUG_ON(bqt->busy);
+		BUG_ON(find_first_bit(bqt->tag_map, bqt->max_depth) <
+							bqt->max_depth);
 
 		kfree(bqt->tag_index);
 		bqt->tag_index = NULL;
@@ -147,7 +148,6 @@ static struct blk_queue_tag *__blk_queue_init_tags(struct request_queue *q,
 	if (init_tag_map(q, tags, depth))
 		goto fail;
 
-	tags->busy = 0;
 	atomic_set(&tags->refcnt, 1);
 	return tags;
 fail:
@@ -313,7 +313,6 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 	 * unlock memory barrier semantics.
 	 */
 	clear_bit_unlock(tag, bqt->tag_map);
-	bqt->busy--;
 }
 EXPORT_SYMBOL(blk_queue_end_tag);
 
@@ -368,7 +367,6 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	bqt->tag_index[tag] = rq;
 	blkdev_dequeue_request(rq);
 	list_add(&rq->queuelist, &q->tag_busy_list);
-	bqt->busy++;
 	return 0;
 }
 EXPORT_SYMBOL(blk_queue_start_tag);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e61f22b..c66c664 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -274,7 +274,6 @@ enum blk_queue_state {
 struct blk_queue_tag {
 	struct request **tag_index;	/* map of busy tags */
 	unsigned long *tag_map;		/* bit map of free/busy tags */
-	int busy;			/* current depth */
 	int max_depth;			/* what we will send to device */
 	int real_max_depth;		/* what the array can hold */
 	atomic_t refcnt;		/* map can be shared */

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
