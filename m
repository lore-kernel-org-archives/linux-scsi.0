From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 3/5] New blk_make_request(), takes bio, returns a
	request
Date: Tue, 19 May 2009 14:49:53 +0200
Message-ID: <20090519124953.GA4140@kernel.dk>
References: <4A1032B0.5000003@panasas.com> <4A1033DB.2030908@panasas.com> <20090519094130.GW4140@kernel.dk> <4A1284F7.2050703@panasas.com> <20090519101308.GX4140@kernel.dk> <4A12A5BB.3060105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:55769 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbZESMtx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 08:49:53 -0400
Content-Disposition: inline
In-Reply-To: <4A12A5BB.3060105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Tue, May 19 2009, Boaz Harrosh wrote:
> On 05/19/2009 01:13 PM, Jens Axboe wrote:
> > On Tue, May 19 2009, Boaz Harrosh wrote:
> <snip>
> >> Thanks Jens, for your comment.
> >>
> >> I have three sources of bio allocations.
> >> 1. bio_map_kern which uses bio_kmalloc (recently fixed by Tejun)
> >> 2. by osdblk which does a clone and will not ever wait.
> >>    (I've fixed the code to split up the IO on allocation failure into
> >>     smaller requests (will repost soon))
> >> 3. Future code in exofs and pNFS-Client that will only ever use bio_kmalloc.
> > 
> > All of those are fine!
> > 
> >> Should we add something to the Documentation, and/or above doc_book comment
> >> to warn off users?
> > 
> > Yes I think so. I'm generally weary of adding interfaces that are easy
> > to misuse. This one has that potential, but it also has merits. So I'll
> > merge your series, if you could send a patch updating the
> > comment/docbook, then that would be great.
> > 
> 
> As my English sucks, please read proof below addition. I will repost later
> today.
> 
> Should I just post this one patch, or all the 5?
> (alternatively I have these on a public git tree reabased on
> block/for-next branch.)

Just this one is fine, I already merged the series.

> Thanks Boaz
> ---
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 89261d2..4dc4e32 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -910,6 +910,15 @@ EXPORT_SYMBOL(blk_get_request);
>   * need bouncing, by calling the appropriate masked or flagged allocator,
>   * suitable for the target device. Otherwise the call to blk_queue_bounce will
>   * BUG.
> + *
> + * WARNING: When allocating/cloning a bio-chain, careful consideration should be
> + * given to how you allocate bios. In particular, you cannot use __GFP_WAIT for
> + * anything but the first bio in the chain. Otherwise you risk deadlocking,
> + * waiting for a bio to be returned to the pool, which will never return, since
> + * it was not submitted yet.

Perhaps something like:

Otherwise you risk waiting for IO completion of a bio that hasn't been
submitted yet, thus resulting in a deadlock.

> + * Alternatively bios should be allocated using bio_kmalloc only.
> + * If possible a long IO should be split into smaller parts when allocation
> + * fails. Partial allocation should not be an error, or you risk a live-lock.
>   */
>  struct request *blk_make_request(struct request_queue *q, struct bio *bio,
>  				 gfp_t gfp_mask)

Alternatively bios should be allocated using bio_kmalloc() instead of
bio_alloc(), as that avoids the mempool deadlock. If possible a big IO
should be ...

-- 
Jens Axboe

