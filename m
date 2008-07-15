From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
Date: Tue, 15 Jul 2008 09:50:21 -0500
Message-ID: <1216133421.3312.30.camel@localhost.localdomain>
References: <1216118676-13625-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
	 <20080715231956A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47090 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbYGOOu1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 10:50:27 -0400
In-Reply-To: <20080715231956A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mpatocka@redhat.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org

On Tue, 2008-07-15 at 23:20 +0900, FUJITA Tomonori wrote:
> On Tue, 15 Jul 2008 09:37:05 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > On Tue, 15 Jul 2008, FUJITA Tomonori wrote:
> > 
> > > blk_recalc_rq_segments assumes that any segments can be merged in the
> > > case of BIOVEC_VIRT_MERGEABLE && !BIOVEC_VIRT_OVERSIZE. However, an
> > > IOMMU can't merge segments if the total length of the segments is
> > > larger than max_segment_size (the LLD restriction).
> > >
> > > Due to this bug, a LLD may get the larger number of segments than
> > > nr_hw_segments because the block layer puts more segments in a request
> > > than it should do.
> > >
> > > This bug could happen on alpha, parisc, and sparc, which use VMERGE.
> > 
> > Parisc doesn't use virtual merge accounting (there is variable for it but 
> > it's always 0).
> 
> Hmm, really? Looks like PARISC IOMMUs (ccio-dma.c and sba_iomm.c) set
> parisc_vmerge_boundary (CC'ed PARISC mailing list).

That's correct.  The size and boundary depend on the type of IOMMU (ccio
or sba) so the vmerge boundary parameters are set up in the iommu driver
code.

> > On sparc64 it is broken anyway with or without your patch. 
> 
> Yeah, we need to modify SPARC64 IOMMU code (I'm not sure that it's
> worth). Right now, the best fix is setting BIO_VMERGE_BOUNDARY to 0.
> 
> 
> > And alpha alone doesn't justify substantial code bloat in generic block 
> > layer. So I propose this patch to drop it at all.
> 
> Jens, what do you think about removing VMERGE code?

Actually, it's code I did.

There are plusses and minusses to all of this.  The original vmerge code
was done for sparc ... mainly because the benefits of virtual merging
can offset the cost of having to use the iommu.  However, most
architectures didn't use it.  When I fixed it up to work for parisc (and
introduced the parameters) we were trying to demonstrate that using it
was feasible.

The idea behind vmerging is that assembling and programming sg lists is
expensive, so you want to do it once.  Either in the iommu or in the
driver sg list, but not in both.  There is evidence that it saves around
7% or so on drivers.  However, for architectures that can do it, better
savings are made simply by lifting the iommu out of the I/O path (so
called bypass mode).

I suspect with IOMMUs coming back (and being unable to be bypassed) with
virtualisation, virtual merging might once more become a significant
value.

James


