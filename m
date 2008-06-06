From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Fri, 6 Jun 2008 23:21:19 +0300
Message-ID: <20080606202119.GQ15085@il.ibm.com>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp> <da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:29461 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbYFFUWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 16:22:04 -0400
Content-Disposition: inline
In-Reply-To: <da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Wed, Jun 04, 2008 at 11:06:15AM -0700, Grant Grundler wrote:
> On Wed, Jun 4, 2008 at 7:47 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> ...
> > Now I try to fix Intel IOMMU code, the free space management
> > algorithm.
> >
> > The major difference between Intel IOMMU code and the others is Intel
> > IOMMU code uses Red Black tree to manage free space while the others
> > use bitmap (swiotlb is the only exception).
> >
> > The Red Black tree method consumes less memory than the bitmap method,
> > but it incurs more overheads (the RB tree method needs to walk through
> > the tree, allocates a new item, and insert it every time it maps an
> > I/O address). Intel IOMMU (and IOMMUs for virtualization) needs
> > multiple IOMMU address spaces. That's why the Red Black tree method is
> > chosen, I guess.
> 
> It's possible to split up one flat address space and share the IOMMU
> among several users. Each user gets her own segment of bitmap and
> corresponding IO Pdir. So I don't see allocation policy as a strong
> reason to use Red/Black Tree.

Do you mean multiple users sharing the same I/O address space (but
each user using a different segment), or multiple users, each with its
own I/O address space, but only using a specific segment of that
address space and using a single bitmap to represent free space in all
segments? If the former, then you are losing some of the benefit of
the IOMMU since all users can DMA to other users areas (same I/O
address space). If the latter, having a bitmap per IO address space
seems simpler and would have the same memory consumption.

> > I got the following results with one thread issuing 1KB I/Os:
> >
> >                    IOPS (I/O per second)
> > IOMMU disabled         145253.1 (1.000)
> > RB tree (mainline)     118313.0 (0.814)
> > Bitmap                 128954.1 (0.887)
> 
> Just to make this clear, this is a 10% performance difference.
> 
> But a second metric is more telling: CPU utilization.  How much time
> was spent in the IOMMU code for each implementation with the same
> workload?
> 
> This isn't a demand for that information but just a request to
> measure that in any future benchmarking.  oprofile or perfmon2 are
> the best tools to determine that.

Agreed, CPU utilization would be very interesting here.

> Just as important as the allocation data structure is the allocation
> policy.  The allocation policy will perform best if it matches the
> IO TLB replacement implemented in the IOMMU HW. Thrashing the IO TLB
> by allocating aliases to competing streams will hurt perf as well.
> Obviously a single benchmark is unlikely to detect this.

Is there a public description of the caching policies of currently
available VT-d hardware?

> I've never been able to come up with a good heuristic for
> determining the size of the IOVA space. It generally does NOT need
> to map all of Host Physical RAM.  The actual requirement depends
> entirely on the workload, type and number of IO devices
> installed. The problem is we don't know any of those things until
> well after the IOMMU is already needed.

Why not do what hash-tables implementation do, start small and resize
when we approach half-full?

Cheers,
Muli
