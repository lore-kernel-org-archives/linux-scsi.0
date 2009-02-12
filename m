From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Thu, 12 Feb 2009 10:30:56 +0900
Message-ID: <20090212103112M.fujita.tomonori@lab.ntt.co.jp>
References: <20090212010454J.fujita.tomonori@lab.ntt.co.jp>
	<1234369838.3295.31.camel@localhost.localdomain>
	<49931113.3090701@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59872 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454AbZBLBbR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 20:31:17 -0500
In-Reply-To: <49931113.3090701@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Wed, 11 Feb 2009 19:55:31 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> > Part of the problem, I think, is that a typical filesystem either works
> > with pages (ext3) or bios (btrfs) and puts them in block at the top.
> > Block then accumulates the pages to bios, elevates the bios into
> > requests and spits those out to SCSI ... this is why we want to
> > eliminate bio handlers from SCSI.
> > 
> 
> You are too fast for me, sorry, I did not get that: "... this is why" logical jump.
> I thought we where getting read of scatter-gather handlers from SCSI. We never
> had any bio handlers in scsi, did we?
> 
> > Your problem is that you phrase your osd fs/pnfs in terms of bios, so
> > then you need to emulate the block bio handlers internally (because
> > you're bypassing block) in your ULD.  However, what we're saying is if
> > you speak pages instead, you can utilise the standard block pc handlers,
> > which are designed to speak pages, without reinventing the bio handling
> > infrastructure.
> 
> I did not know I was reinventing the bio handling infrastructure, I thought

I think that we call something like the following reinventing the bio
handling infrastructure:

static void _abort_unexecuted_bios(struct request *rq)
{
	struct bio *bio;

	while ((bio = rq->bio) != NULL) {
		rq->bio = bio->bi_next;
		bio_endio(bio, 0);
	}
}


> I was using it with all available glory, and exported API. I let different users

include/blkdev.h says:

/*
 * Temporary export, until SCSI gets fixed up.
 */
extern int blk_rq_append_bio(struct request_queue *q, struct request *rq,
			     struct bio *bio);


blk_rq_append_bio is not an exported API. We finally fixed SCSI but
you broke it again.


> collect their memory information inside a bio, then in one simple call
> the bio is elevated to a request and the request is submitted, block_pc style.
> 
> Actually I just started to code using blk_rq_map_user(), and setting of all
> struct rq_map_data information, and that feels a little like bio code duplication.
> Because I need a collection (link-list) of them. struct rq_map_data assumes linear memory
> which I do not have. Also I will need that blk_rq_map_user() will append bios like the change
> you proposed to blk_rq_map_kern(), I guess it is doable, only it's lots of more work.
> (And that awful blk_rq_unmap_user() which forces me to know if I sent via map_usr or map_kern ...)

I think that having something like blk_rq_map_kern_page with James'
extension is another option.


> I have one question. If bio API is only to be used by block layer internal, why is it
> exported at all? Seems a bio has nice API for collecting memory information and is used

As I wrote, you use API that should not be exported. And I really
don't think that SCSI ULD needs to play with bio. As James wrote, you
reinvent and duplicate some of the block layer. That's a design that
we should avoid.


> by all kind of block users like filesystems, DM, MD, data integrity and others. I would
> not mind a:
> 	struct requst *blk_pc_make_request(bio);
> Of sorts, to make it official, same as generic_make_request() but for block_pc users.
