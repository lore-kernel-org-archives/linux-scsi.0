From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
Date: Tue, 15 Jul 2008 10:41:43 -0500
Message-ID: <1216136503.3312.48.camel@localhost.localdomain>
References: <1216118676-13625-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
	 <20080715231956A.fujita.tomonori@lab.ntt.co.jp>
	 <1216133421.3312.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0807151104450.26824@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44902 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101AbYGOPls (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 11:41:48 -0400
In-Reply-To: <Pine.LNX.4.64.0807151104450.26824@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org

On Tue, 2008-07-15 at 11:24 -0400, Mikulas Patocka wrote:
> >>> On sparc64 it is broken anyway with or without your patch.
> >>
> >> Yeah, we need to modify SPARC64 IOMMU code (I'm not sure that it's
> >> worth). Right now, the best fix is setting BIO_VMERGE_BOUNDARY to 0.
> >>
> >>
> >>> And alpha alone doesn't justify substantial code bloat in generic block
> >>> layer. So I propose this patch to drop it at all.
> >>
> >> Jens, what do you think about removing VMERGE code?
> >
> > Actually, it's code I did.
> >
> > There are plusses and minusses to all of this.  The original vmerge code
> > was done for sparc ... mainly because the benefits of virtual merging
> > can offset the cost of having to use the iommu.  However, most
> > architectures didn't use it.  When I fixed it up to work for parisc (and
> > introduced the parameters) we were trying to demonstrate that using it
> > was feasible.
> >
> > The idea behind vmerging is that assembling and programming sg lists is
> > expensive, so you want to do it once.  Either in the iommu or in the
> > driver sg list, but not in both.  There is evidence that it saves around
> > 7% or so on drivers.  However, for architectures that can do it, better
> > savings are made simply by lifting the iommu out of the I/O path (so
> > called bypass mode).
> 
> The problem is with vmerge accounting in block layer (that is what I'm 
> proposing to remove), not with vmerge itself.

I don't think that's true ... otherwise parisc would be falling over
left right and centre.

> Vmerge accounting has advantages only if you have device with small amount 
> of sg slots --- it allows the block layer to create request that has 
> higher number of segments then the device.

This isn't really true either.  A lot of devices with a high sg slot
count are still less efficient than an iommu for programming.

Even if they're not, on parisc we have to program the iommu, we can't
bypass, so it still makes sense to only have one large sg list (in the
iommu) and one small one (in the device).  Having two large ones reduces
our I/O throughput because of the extra overhead.

> If you have device with for example 1024 slots, the virtual merge 
> accounting has no effect, because the any request will fit into that size. 

It's not about fitting a request, it's about efficient processing.

> Even without virtual merge accounting, the virtual merging will happen, so 
> there will be no performance penalty for the controller --- the controller 
> will be programmed with exactly the same number of segments as if virtual 
> merge accounting was present. (there could be even slight positive 
> performance effect if you remove accounting, because you burn less CPU 
> cycles per request)

Yes there is.  Both the iommu and the device have to traverse large SG
lists.  This is where the inefficiency lies.  On PA, we use exactly the
same number of iotlb slots whether virtual merging is in effect or not,
but the device has an internal loop to go over the list.  It's that loop
that virtual merging reduces.

Since the virtual merge computation is in line when the request is built
(by design) it doesn't really detract from the throughput and the cost
is pretty small.

> If you have device will small number of sg slots (16 or so), vmerge 
> accounting can improve performance by creating requests with more than 16 
> segments --- the question is: is there any such device? And is the device 
> performance-sensitive? (i.e. isn't it such an old hardware where no one 
> cares about performance anyway?)
> 
> > I suspect with IOMMUs coming back (and being unable to be bypassed) with
> > virtualisation, virtual merging might once more become a significant
> > value.
> 
> I suppose that no one would manufacture new SCSI card with 16 or 32 sg 
> slots these days, so the accounting of hardware segments has no effect on 
> modern hardware.

It's not about accounting, it's about performance.  There's a cost in
every device to traversing large count sg lists.  If you have to bear it
in the iommu (which is usually more efficient because the iotlb tends to
follow mmtlb optimisations) you can reduce the cost by eliminating it
from the device.

James


