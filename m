From: "Abhijeet Joglekar" <ajoglekar@nuovasystems.com>
Subject: RE: [RFC] [PATCH] Potential bug fix for blk_tag_queue
Date: Tue, 26 Aug 2008 00:49:11 -0700
Message-ID: <34BDD2A93E5FD84594BB230DD6C18EA205B3437D@nuova-ex1.hq.nuovaimpresa.com>
References: <20080826005856.27375.59152.stgit@feynman.nuovasystems.com> <20080826024620.GC23698@parisc-linux.org> <20080826070046.GQ20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nuova-ex1.nuovasystems.com ([67.91.200.196]:35542 "EHLO
	nuova-ex1.nuovasystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180AbYHZHtM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2008 03:49:12 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080826070046.GQ20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Ok, removing that works too. 

Shouldn't the BUG_ON be checking upto bqt->real_max_depth instead of
bqt->depth?  

BUG_ON(find_first_bit(bqt->tag_map, bqt->real_max_depth) <
                      bqt->real_max_depth);


In cases where the tag map gets resized to a value less than the
originally allocated tag map, blk_queue_resize_tags seems to be setting
bqt->max_depth to the new_depth. 

There could still be outstanding tags max_depth <= t <= real_max_depth
which might not get freed, which the BUG_ON will not capture if it
checks against max_depth.

abhijeet

-----Original Message-----
From: Jens Axboe [mailto:jens.axboe@oracle.com] 
Sent: Tuesday, August 26, 2008 12:01 AM
To: Matthew Wilcox
Cc: Abhijeet Joglekar; linux-scsi@vger.kernel.org
Subject: Re: [RFC] [PATCH] Potential bug fix for blk_tag_queue

On Mon, Aug 25 2008, Matthew Wilcox wrote:
> On Mon, Aug 25, 2008 at 06:03:01PM -0700, Abhijeet Joglekar wrote:
> > The following patch fixes a potential bug in the blk_tag_queue
structure.
> > "busy" is used to keep track of outstanding tags, is declared as
int,
> > and updated inside queue lock. For host-wide shared tag map, this
corrupts
> > the value of busy, which hits BUG_ON during __blk_free_tags.
> 
> I believe you to be right.
> 
> > Recommend converting busy to atomic_t and using atomic_macros to
access it.
> 
> ugh, more atomic ops.  How about just getting rid of it?  Patch
> untested:
> 
> diff --git a/block/blk-tag.c b/block/blk-tag.c
> index 32667be..ed5166f 100644
> --- a/block/blk-tag.c
> +++ b/block/blk-tag.c
> @@ -38,7 +38,8 @@ static int __blk_free_tags(struct blk_queue_tag
*bqt)
>  
>  	retval = atomic_dec_and_test(&bqt->refcnt);
>  	if (retval) {
> -		BUG_ON(bqt->busy);
> +		BUG_ON(find_first_bit(bqt->tag_map, bqt->max_depth) <
> +							bqt->max_depth);
>  
>  		kfree(bqt->tag_index);
>  		bqt->tag_index = NULL;
> @@ -147,7 +148,6 @@ static struct blk_queue_tag
*__blk_queue_init_tags(struct request_queue *q,
>  	if (init_tag_map(q, tags, depth))
>  		goto fail;
>  
> -	tags->busy = 0;
>  	atomic_set(&tags->refcnt, 1);
>  	return tags;
>  fail:
> @@ -313,7 +313,6 @@ void blk_queue_end_tag(struct request_queue *q,
struct request *rq)
>  	 * unlock memory barrier semantics.
>  	 */
>  	clear_bit_unlock(tag, bqt->tag_map);
> -	bqt->busy--;
>  }
>  EXPORT_SYMBOL(blk_queue_end_tag);
>  
> @@ -368,7 +367,6 @@ int blk_queue_start_tag(struct request_queue *q,
struct request *rq)
>  	bqt->tag_index[tag] = rq;
>  	blkdev_dequeue_request(rq);
>  	list_add(&rq->queuelist, &q->tag_busy_list);
> -	bqt->busy++;
>  	return 0;
>  }
>  EXPORT_SYMBOL(blk_queue_start_tag);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index e61f22b..c66c664 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -274,7 +274,6 @@ enum blk_queue_state {
>  struct blk_queue_tag {
>  	struct request **tag_index;	/* map of busy tags */
>  	unsigned long *tag_map;		/* bit map of free/busy tags */
> -	int busy;			/* current depth */
>  	int max_depth;			/* what we will send to device
*/
>  	int real_max_depth;		/* what the array can hold */
>  	atomic_t refcnt;		/* map can be shared */

Thanks, we can easily kill it. We should remove blk_queue_tag_depth()
and blk_queue_tag_queue() as well, they were the 'exported' way of
getting this information. I added this for the IDE TCQ bits back in
olden days, but that stuff is no longer there. So it's probably been
unused since then.

I've applied your patch.

-- 
Jens Axboe

