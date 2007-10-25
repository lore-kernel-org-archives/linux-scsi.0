From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: stex driver panic in kernel 2.6.23
Date: Thu, 25 Oct 2007 10:11:17 +0200
Message-ID: <20071025081117.GF5053@kernel.dk>
References: <NONAMEWzsLqIfQdmEB40000023f@nonamew.ptu.promise.com> <20071024121714.149b10c7.akpm@linux-foundation.org> <1193254176.3441.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:29328 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbXJYINB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 04:13:01 -0400
Content-Disposition: inline
In-Reply-To: <1193254176.3441.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ed Lin <ed.lin@promise.com>, jeff <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Oct 24 2007, James Bottomley wrote:
> On Wed, 2007-10-24 at 12:17 -0700, Andrew Morton wrote:
> > On Wed, 24 Oct 2007 11:59:30 -0700 "Ed Lin" <ed.lin@promise.com> wrote:
> > 
> > > The shared tag issue was not fixed yet. Kernel panic
> > > happened while running I/O test in kernel 2.6.23
> > > (information attached). After applying the patch I posted
> > > (or the version James modified), panic disappeared.
> > > Switch back to standard kernel, panic again.
> > 
> > Did either of those patches get merged in 2.6.24-rc1?
> 
> No ... Jens did one instead (commit
> f3da54ba140c6427fa4a32913e1bf406f41b5dda), which now looks like it might
> not have fixed the issue.

I think there's one more bug there, for shared maps. For the locking to
work, only the tag map and tag bit map may be shared (incidentally, I
was just explaining this to Nick yesterday, but I apparently didn't
review the code well enough myself). But we also share the busy list!
The busy_list must be queue private, or we need a block_queue_tag
covering lock as well.

So we have to move the busy_list to the queue. This'll work fine, and
it'll actually also fix a problem with blk_queue_invalidate_tags() which
will invalidate tags across all shared queues. This is a bit confusing,
the low level driver should call it for each queue seperately since
otherwise you cannot kill tags on just a single queue for eg a hard
drive that stops responding. Since the function has no callers
currently, it's not an issue.

Please test.

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index a8a1810..56f2646 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -791,7 +791,6 @@ static int __blk_free_tags(struct blk_queue_tag *bqt)
 	retval = atomic_dec_and_test(&bqt->refcnt);
 	if (retval) {
 		BUG_ON(bqt->busy);
-		BUG_ON(!list_empty(&bqt->busy_list));
 
 		kfree(bqt->tag_index);
 		bqt->tag_index = NULL;
@@ -903,7 +902,6 @@ static struct blk_queue_tag *__blk_queue_init_tags(struct request_queue *q,
 	if (init_tag_map(q, tags, depth))
 		goto fail;
 
-	INIT_LIST_HEAD(&tags->busy_list);
 	tags->busy = 0;
 	atomic_set(&tags->refcnt, 1);
 	return tags;
@@ -954,6 +952,7 @@ int blk_queue_init_tags(struct request_queue *q, int depth,
 	 */
 	q->queue_tags = tags;
 	q->queue_flags |= (1 << QUEUE_FLAG_QUEUED);
+	INIT_LIST_HEAD(&q->tag_busy_list);
 	return 0;
 fail:
 	kfree(tags);
@@ -1122,7 +1121,7 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	rq->tag = tag;
 	bqt->tag_index[tag] = rq;
 	blkdev_dequeue_request(rq);
-	list_add(&rq->queuelist, &bqt->busy_list);
+	list_add(&rq->queuelist, &q->tag_busy_list);
 	bqt->busy++;
 	return 0;
 }
@@ -1143,11 +1142,10 @@ EXPORT_SYMBOL(blk_queue_start_tag);
  **/
 void blk_queue_invalidate_tags(struct request_queue *q)
 {
-	struct blk_queue_tag *bqt = q->queue_tags;
 	struct list_head *tmp, *n;
 	struct request *rq;
 
-	list_for_each_safe(tmp, n, &bqt->busy_list) {
+	list_for_each_safe(tmp, n, &q->tag_busy_list) {
 		rq = list_entry_rq(tmp);
 
 		if (rq->tag == -1) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bbf906a..8396db2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -341,7 +341,6 @@ enum blk_queue_state {
 struct blk_queue_tag {
 	struct request **tag_index;	/* map of busy tags */
 	unsigned long *tag_map;		/* bit map of free/busy tags */
-	struct list_head busy_list;	/* fifo list of busy tags */
 	int busy;			/* current depth */
 	int max_depth;			/* what we will send to device */
 	int real_max_depth;		/* what the array can hold */
@@ -435,6 +434,7 @@ struct request_queue
 	unsigned int		dma_alignment;
 
 	struct blk_queue_tag	*queue_tags;
+	struct list_head	tag_busy_list;
 
 	unsigned int		nr_sorted;
 	unsigned int		in_flight;

-- 
Jens Axboe

