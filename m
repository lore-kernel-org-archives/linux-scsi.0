From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
Date: Tue, 15 Jul 2008 11:07:51 -0500
Message-ID: <1216138072.3312.54.camel@localhost.localdomain>
References: <1216118676-13625-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
	 <20080715231956A.fujita.tomonori@lab.ntt.co.jp>
	 <1216133421.3312.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0807151104450.26824@devserv.devel.redhat.com>
	 <1216136503.3312.48.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0807151147040.29803@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43755 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbYGOQH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 12:07:56 -0400
In-Reply-To: <Pine.LNX.4.64.0807151147040.29803@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org

On Tue, 2008-07-15 at 11:58 -0400, Mikulas Patocka wrote:
> You are mixing two ideas here:
> 
> (1) virtual merging --- IOMMU maps discontinuous segments into continuous 
> area that it presents to the device.
> 
> (2) virtual merge accounting --- block layer tries to guess how many 
> segments will be created by (1) and merges small requests into big ones. 
> The resulting requests are as big that they can't be processed by the 
> device if (1) weren't in effect.

No ... I'm not ... the virtual merge implementation requires the block
layer to get this accounting right, otherwise the iommu code can end up
doing the wrong thing.

You're proposing to eliminate the difference between max_phys_segments
and max_hw_segments without actually removing them.

> >> The problem is with vmerge accounting in block layer (that is what I'm
> >> proposing to remove), not with vmerge itself.
> >
> > I don't think that's true ... otherwise parisc would be falling over
> > left right and centre.
> >
> >> Vmerge accounting has advantages only if you have device with small amount
> >> of sg slots --- it allows the block layer to create request that has
> >> higher number of segments then the device.
> >
> > This isn't really true either.  A lot of devices with a high sg slot
> > count are still less efficient than an iommu for programming.
> 
> --- for these devices virtual merging (1) improves performance, but 
> virtual merge accounting (2) doesn't.
> 
> > Even if they're not, on parisc we have to program the iommu, we can't
> > bypass, so it still makes sense to only have one large sg list (in the
> > iommu) and one small one (in the device).  Having two large ones reduces
> > our I/O throughput because of the extra overhead.
> >
> >> If you have device with for example 1024 slots, the virtual merge
> >> accounting has no effect, because the any request will fit into that size.
> >
> > It's not about fitting a request, it's about efficient processing.
> 
> Virtual merge accounting (2) is about fitting a request. It is block layer 
> technique.
> 
> >> Even without virtual merge accounting, the virtual merging will happen, so
> >> there will be no performance penalty for the controller --- the controller
> >> will be programmed with exactly the same number of segments as if virtual
> >> merge accounting was present. (there could be even slight positive
> >> performance effect if you remove accounting, because you burn less CPU
> >> cycles per request)
> >
> > Yes there is.  Both the iommu and the device have to traverse large SG
> > lists.  This is where the inefficiency lies.  On PA, we use exactly the
> > same number of iotlb slots whether virtual merging is in effect or not,
> > but the device has an internal loop to go over the list.  It's that loop
> > that virtual merging reduces.
> >
> > Since the virtual merge computation is in line when the request is built
> > (by design) it doesn't really detract from the throughput and the cost
> > is pretty small.
> 
> The purpose of (1) virtual merging is to save device's sg slots. The 
> purpose of (2) virtual merge accounting is to allow block layer to build 
> larger requests. If you remove virtual merge accounting, it will cause no 
> increase in number of sg slots used.
> 
> >>> I suspect with IOMMUs coming back (and being unable to be bypassed) with
> >>> virtualisation, virtual merging might once more become a significant
> >>> value.
> >>
> >> I suppose that no one would manufacture new SCSI card with 16 or 32 sg
> >> slots these days, so the accounting of hardware segments has no effect on
> >> modern hardware.
> >
> > It's not about accounting, it's about performance.  There's a cost in
> > every device to traversing large count sg lists.  If you have to bear it
> > in the iommu (which is usually more efficient because the iotlb tends to
> > follow mmtlb optimisations) you can reduce the cost by eliminating it
> > from the device.
> 
> That's why I'm proposing to remove virtual merge accounting (2), but leave 
> virtual merging (1) itself. The accounting doesn't reduce number of sg 
> slots.

Yes, but it's gains very little ... architectures that don't want it can
already turn it off, and it's useful for those, like parisc, who do.

James


