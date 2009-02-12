From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Thu, 12 Feb 2009 14:48:49 +0000
Message-ID: <1234450129.3295.75.camel@localhost.localdomain>
References: <4992E9A4.9080303@panasas.com>
	 <20090212002105A.fujita.tomonori@lab.ntt.co.jp>
	 <4992F1AF.9060702@panasas.com>
	 <20090212010454J.fujita.tomonori@lab.ntt.co.jp>
	 <1234369838.3295.31.camel@localhost.localdomain>
	 <49931113.3090701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57068 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084AbZBLOsw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2009 09:48:52 -0500
In-Reply-To: <49931113.3090701@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Wed, 2009-02-11 at 19:55 +0200, Boaz Harrosh wrote:
> James Bottomley wrote:
> > On Thu, 2009-02-12 at 01:04 +0900, FUJITA Tomonori wrote:
> >> On Wed, 11 Feb 2009 17:41:35 +0200
> >> Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>
> >>> FUJITA Tomonori wrote:
> >>>> On Wed, 11 Feb 2009 17:07:16 +0200
> >>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>>>
> >>>>>>
> >>>>> Sure it can pass pages to ULD but then how ULD maks a request out of
> >>>>> pages?
> >>>> If you extend blk_rq_map_kern as James did, your ULD make a request
> >>>> out of passed pages, that is, the block layer properly builds a
> >>>> request with bio(s).
> >>> What? I don't understand?
> >>> blk_rq_map_kern takes a kernel-pointer and length, how to pass array
> >>> of page* ?
> >> You can call it multiple times. But I guess that you need something
> >> new since you need to handle user pages.
> >>
> >>
> >>>> I think that another possible option is adding a new mapping function
> >>>> that can handle multiple bios for kernel buffers (as Mike extended
> >>>> blk_rq_map_user).
> >>>>
> >>> Yes adding a new mapping function can help. Please note I need to
> >>> add (append) pages same as bio_add_pc_page() but on request level.
> >> I think that what you need already exists.
> >>
> >> See how st uses blk_rq_map_user() in scsi-misc (keywords: rq_map_data
> >> and null_mapped). Please read it before saying something like 'we need
> >> to handle kernel buffer'.
> >>
> >>
> >>> And yet we had an entry that did exactly that, blk_rq_append_bio(), no?
> >> Using blk_rq_append_bio in SCSI is unacceptable.
> >>
> >>
> >>>>> And it gets more complicated then that (above multiple times)
> >>>> I don't think so. If you don't have time to work on it, please let me
> >>>> know. I'll fix OSD ULD.
> >>> I have all the time in the world, And yes what James did with blk_rq_map_kern
> >>> will help with appending other osd segments on top of data.
> >>>
> >>> If you propose the appropriate new API for block request level I can implement
> >>> that in block, and also in OSD. What other entry you want to add/change that solve
> >>> my need?
> >> If you have time, how about making a proposal. ;)
> >>
> >> But as I wrote above, I think that blk_rq_map_user() works for you.
> > 
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

Yes, but we've been trying to cut down on them.  In fact with both osd
and integrity, the use of bio handlers has been increasing.

> > Your problem is that you phrase your osd fs/pnfs in terms of bios, so
> > then you need to emulate the block bio handlers internally (because
> > you're bypassing block) in your ULD.  However, what we're saying is if
> > you speak pages instead, you can utilise the standard block pc handlers,
> > which are designed to speak pages, without reinventing the bio handling
> > infrastructure.
> 
> I did not know I was reinventing the bio handling infrastructure, I thought
> I was using it with all available glory, and exported API. I let different users
> collect their memory information inside a bio, then in one simple call
> the bio is elevated to a request and the request is submitted, block_pc style.

Everything in your last sentence is how the block layer handles bios
(although it's more sophisticated), so this is the duplication.  The
problem is that how bios are put together is a block internal thing.
Nothing outside of block does that today ... if you construct your own
multi-bio requests, we have to remember that drivers/scsi/osd needs
updating as well if block ever alters this (say to cope with a new
elevator strategy).

> Actually I just started to code using blk_rq_map_user(), and setting of all
> struct rq_map_data information, and that feels a little like bio code duplication.
> Because I need a collection (link-list) of them. struct rq_map_data assumes linear memory
> which I do not have. Also I will need that blk_rq_map_user() will append bios like the change
> you proposed to blk_rq_map_kern(), I guess it is doable, only it's lots of more work.
> (And that awful blk_rq_unmap_user() which forces me to know if I sent via map_usr or map_kern ...)

blk_rq_map_user does append pages to bios ... that's where I got the
changes to blk_rq_map_kern() from.

> I have one question. If bio API is only to be used by block layer internal, why is it
> exported at all? Seems a bio has nice API for collecting memory information and is used
> by all kind of block users like filesystems, DM, MD, data integrity and others. I would
> not mind a:
> 	struct requst *blk_pc_make_request(bio);
> Of sorts, to make it official, same as generic_make_request() but for block_pc users.

bios are supposed to be used by filesystems ... they represent the input
to block.  In principle, it seems nicer that PC requests deal with pages
as their natural input ... that way we don't have to worry about
exporting the block interfaces for bio->request construction.

> I will try the blk_rq_map_user, I'm sure it will not be pretty, though.

Great, thanks ... we can also adjust block interfaces to help.

James


