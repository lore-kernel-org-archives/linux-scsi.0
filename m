From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 3/3 v3] osdblk: a Linux block device for OSD objects
Date: Mon, 27 Apr 2009 20:24:34 +0200
Message-ID: <20090427182434.GD4593@kernel.dk>
References: <20090402015455.GA14087@havoc.gtf.org> <20090407225302.GA14248@havoc.gtf.org> <20090410114821.GA10602@havoc.gtf.org> <20090410114908.GB10602@havoc.gtf.org> <20090410115045.GC10602@havoc.gtf.org> <49F5D66E.2040506@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:41558 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZD0SYf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 14:24:35 -0400
Content-Disposition: inline
In-Reply-To: <49F5D66E.2040506@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, osd-dev@open-osd.org, Tejun Heo <tj@kernel.org>

On Mon, Apr 27 2009, Boaz Harrosh wrote:
> > +static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
> > +{
> > +	struct bio *tmp, *new_chain = NULL, *tail = NULL;
> > +
> > +	while (old_chain) {
> > +		tmp = bio_clone(old_chain, gfpmask);
> > +		if (!tmp)
> > +			goto err_out;
> > +
> > +		tmp->bi_next = NULL;
> > +		if (!new_chain)
> > +			new_chain = tail = tmp;
> > +		else {
> > +			tail->bi_next = tmp;
> > +			tail = tmp;
> > +		}
> > +
> > +		old_chain = old_chain->bi_next;
> > +	}
> > +
> > +	return new_chain;
> > +
> > +err_out:
> > +	bio_chain_put(new_chain);
> > +	return NULL;
> > +}
> > +
> 
> NOTE-TO-ME:
>   blk_bio_clone()

Note to Boaz - this is illegal, unless gfp_mask is GFP_ATOMIC (in which
case you should not pass it in). The only way to make this work is to:

1) Have a private bio pool, and
2) Make sure it has enough reserved entries to populate the chain, and
3) Ensure only a single caller at the time, or entries enough for the N
   users that are allowed. It has to be controlled either way, whether N
   is 1 or larger.

> > +static void osdblk_rq_fn(struct request_queue *q)
> > +{
> > +	struct osdblk_device *osdev = q->queuedata;
> > +	struct request *rq;
> > +	struct osdblk_request *orq;
> > +	struct osd_request *or;
> > +	struct bio *bio;
> > +	int do_write, do_flush;
> > +
> > +	while (1) {
> > +		/* peek at request from block layer */
> > +		rq = elv_next_request(q);
> > +		if (!rq)
> > +			break;
> > +
> > +		/* filter out block requests we don't understand */
> > +		if (!blk_fs_request(rq) && !blk_barrier_rq(rq)) {
> > +			end_request(rq, 0);
> > +			continue;
> > +		}
> > +
> > +		/* deduce our operation (read, write, flush) */
> > +		/* I wish the block layer simplified cmd_type/cmd_flags/cmd[]
> > +		 * into a clearly defined set of RPC commands:
> > +		 * read, write, flush, scsi command, power mgmt req,
> > +		 * driver-specific, etc.
> > +		 */
> > +
> > +		do_flush = (rq->special == (void *) 0xdeadbeefUL);
> 
> That's for real? or it needs a "FIXME" next to it?
> 
> > +		do_write = (rq_data_dir(rq) == WRITE);
> > +
> > +		/* a bio clone to be passed down to OSD request */
> > +		bio = bio_chain_clone(rq->bio, GFP_ATOMIC);
> > +		if (!bio)
> > +			break;
> 
> does blk_barrier_rq() have a rq->bio?

It may or may not.

-- 
Jens Axboe

