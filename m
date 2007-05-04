From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Fri, 04 May 2007 22:55:38 +0900
Message-ID: <200705041355.l44Dtdpg016232@mbox.iij4u.or.jp>
References: <20070430111157.GI21015@kernel.dk>
	<20070502043754N.fujita.tomonori@lab.ntt.co.jp>
	<463A1F14.9080309@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44554 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbXEDN5t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2007 09:57:49 -0400
In-Reply-To: <463A1F14.9080309@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, hch@infradead.org, James.Bottomley@SteelEye.com, tomof@acm.org, akpm@osdl.org, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, bhalevy@panasas.com

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Thu, 03 May 2007 20:42:44 +0300

> FUJITA Tomonori wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: [PATCH 4/4] bidi support: bidirectional request
> > Date: Mon, 30 Apr 2007 13:11:57 +0200
> > 
> >> On Sun, Apr 29 2007, James Bottomley wrote:
> >>> On Sun, 2007-04-29 at 18:48 +0300, Boaz Harrosh wrote:
> >>>> FUJITA Tomonori wrote:
> >>>>> From: Boaz Harrosh <bharrosh@panasas.com>
> >>>>> Subject: [PATCH 4/4] bidi support: bidirectional request
> >>>>> Date: Sun, 15 Apr 2007 20:33:28 +0300
> >>>>>
> >>>>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >>>>>> index 645d24b..16a02ee 100644
> >>>>>> --- a/include/linux/blkdev.h
> >>>>>> +++ b/include/linux/blkdev.h
> >>>>>> @@ -322,6 +322,7 @@ struct request {
> >>>>>>      void *end_io_data;
> >>>>>>
> >>>>>>      struct request_io_part uni;
> >>>>>> +    struct request_io_part bidi_read;
> >>>>>>  };
> >>>>> Would be more straightforward to have:
> >>>>>
> >>>>> struct request_io_part in;
> >>>>> struct request_io_part out;
> >>>>>
> >>>> Yes I wish I could do that. For bidi supporting drivers this is the most logical.
> >>>> But for the 99.9% of uni-directional drivers, calling rq_uni(), and being some what on
> >>>> the hotish paths, this means we will need a pointer to a uni request_io_part.
> >>>> This is bad because:
> >>>> 1st- There is no defined stage in a request life where to definitely set that pointer,
> >>>>      specially in the preparation stages.
> >>>> 2nd- hacks like scsi_error.c/scsi_send_eh_cmnd() will not work at all. Now this is a
> >>>>      very bad spot already, and I have a short term fix for it in the SCSI-bidi patches
> >>>>      (not sent yet) but a more long term solution is needed. Once such hacks are
> >>>>      cleaned up we can do what you say. This is exactly why I use the access functions
> >>>>      rq_uni/rq_io/rq_in/rq_out and not open code access.
> >>> I'm still not really convinced about this approach.  The primary job of
> >>> the block layer is to manage and merge READ and WRITE requests.  It
> >>> serves a beautiful secondary function of queueing for arbitrary requests
> >>> it doesn't understand (REQ_TYPE_BLOCK_PC or REQ_TYPE_SPECIAL ... or
> >>> indeed any non REQ_TYPE_FS).
> >>>
> >>> bidirectional requests fall into the latter category (there's nothing
> >>> really we can do to merge them ... they're just transported by the block
> >>> layer).  The only unusual feature is that they carry two bios.  I think
> >>> the drivers that actually support bidirectional will be a rarity, so it
> >>> might even be advisable to add it to the queue capability (refuse
> >>> bidirectional requests at the top rather than perturbing all the drivers
> >>> to process them).
> >>>
> >>> So, what about REQ_TYPE_BIDIRECTIONAL rather than REQ_BIDI?  That will
> >>> remove it from the standard path and put it on the special command type
> >>> path where we can process it specially.  Additionally, if you take this
> >>> approach, you can probably simply chain the second bio through
> >>> req->special as an additional request in the stream.  The only thing
> >>> that would then need modification would be the dequeue of the block
> >>> driver (it would have to dequeue both requests and prepare them) and
> >>> that needs to be done only for drivers handling bidirectional requests.
> >> I agree, I'm really not crazy about shuffling the entire request setup
> >> around just for something as exotic as bidirection commands. How about
> >> just keeping it simple - have a second request linked off the first one
> >> for the second data phase? So keep it completely seperate, not just
> >> overload ->special for 2nd bio list.
> >>
> >> So basically just add a struct request pointer, so you can do rq =
> >> rq->next_rq or something for the next data phase. I bet this would be a
> >> LOT less invasive as well, and we can get by with a few helpers to
> >> support it.
> > 
> > This patch tried this approach. It's just for seeing how it works.
> > 
> > I added bidi support to open-iscsi and bsg and tested this patch
> > lightly. I've attached only a patch for the block layer and scsl-ml.
> > You can get all the patches are:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/tomo/bidi
> > 
> > If we go with this approach, we need just minor changes to the block
> > layer. The overloading rq->special approach needs more but it's
> > reasonable too.
> > 
> > I need to add the proper error handling code, which might be a bit
> > tricky, but I think that it will not be so complicated.
> > 
> > 
> >> And it should definitely be a request type.
> > 
> > I'm not sure about this. I think that bidi can't be a request type to
> > trace bidi pc requests (we have bidi special requests like SMP). I use
> > REQ_BIDI though I've not implemented bidi trace code.
> > 
> > 
> > From 7d278323ff8aad86fb82c823538f7ddfb6ded11c Mon Sep 17 00:00:00 2001
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date: Wed, 2 May 2007 03:55:56 +0900
> > Subject: [PATCH] add bidi support
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  block/ll_rw_blk.c        |    1 +
> >  drivers/scsi/scsi_lib.c  |   72 +++++++++++++++++++++++++++++++++++++++-------
> >  include/linux/blkdev.h   |    7 ++++
> >  include/scsi/scsi_cmnd.h |    9 ++++++
> >  4 files changed, 78 insertions(+), 11 deletions(-)
> > 
> 
> Well what can I say guys. Just that I told you so.
> After 6 month you all agree on my original solution. Back than I
> wouldn't even dream of touching block layer and struct request.
> The 2 requests approach seemed perfectly fine. But people laughed
> that it is maybe good for out-of-tree debugging but I must do
> a proper support at the request layer. Even then, I say "ok but
> can we do it very ugly but safe on the side?, not to touch any
> legacy code." "No!" people say "do one for in one for out".
> So what should I understand for next time? a "Proper bidi support
> at the block layer" means we'll let you have a bad named pointer
> so you don't have to overload req->end_io_data at the scsi-ml level.
> Thanks I could use req->data for that.
> 
> Tomo's code is a perfectly valid approach, but it is certainly not
> finished. I have some comments and questions below.

Yeah, my patchset can't handle errors, partial completions, etc
properly. I'll fix the problems and send a new patchset soon.


> If anyone cares I put up a patcheset that I've tested to be stable.
> it is here:
> http://www.bhalevy.com/open-osd/download/double_request_bidi/
> 
> 1. I'm not very experienced with blk_map_user but there is some
>    asymmetry at SCSI-ml between handling of the first WRITE request
>    and second READ request. At scsi_end_request() there is the
>    end_that_request_chunk() calls. Now from my experience
>    with kernel buffers (I am using sglists through scsi_req_map_sg())
>    not calling end_that_request_chunk() on the second request will leak
>    the BIOs. Maybe blk_{,un}map_user() does not care I'm not sure. In my
>    SCSI-ml patch I have hacked up a scsi_end_request_block() to free
>    the BIOs unconditionally, since it is what I want to do. But calling
>    end_that_request_chunk() with the right size should also do the trick.

I think that we need to call end_that_request_chunk properly against
the second request.


> 2. At struct request the blk_bidi_rq() should just be:
>    #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
>    The flag gives us nothing but an extra BUG_ON. In fact we don't
>    need the flag at all.
>    And the name next_rq? are we intending to have a chain of these?
>    What's bad with plain bidi_read?

I used the new bidi flag though I thought about ((rq)->next_rq !=
NULL) since since we might support a chain of requests. Either is ok
for me.


> 3. On the other hand we need a new flag REQ_IO_ONLY, to stick on
>    the Second READ request. So block layer can avoid doing any
>    extra work on IO_ONLY requests. For now it does not matter
>    since BIDI devices like OSD do not get any regular FS traffic.
>    But when they will, the Second READ request might confuse the
>    elevator handling.

They will? I'm not sure. I think that the block layer just transports
bidi requests.


>   (See: 0003-out-of-tree-block-bidi-debugging.patch for what I mean)

So I don't think that we need to touch the elevator code.
