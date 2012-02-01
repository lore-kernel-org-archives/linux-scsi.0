From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC][ATTEND]IOPS based ioscheduler
Date: Wed, 1 Feb 2012 13:54:05 -0500
Message-ID: <20120201185405.GB13246@redhat.com>
References: <1327997806.21268.47.camel@sli10-conroe>
 <x49ehufd9mi.fsf@segfault.boston.devel.redhat.com>
 <1328079791.21268.61.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2BATHs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Feb 2012 14:07:48 -0500
Content-Disposition: inline
In-Reply-To: <1328079791.21268.61.camel@sli10-conroe>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Wed, Feb 01, 2012 at 03:03:11PM +0800, Shaohua Li wrote:
> On Tue, 2012-01-31 at 13:12 -0500, Jeff Moyer wrote:
> > Shaohua Li <shaohua.li@intel.com> writes:
> > 
> > > Flash based storage has its characteristics. CFQ has some optimizations
> > > for it, but not enough. The big problem is CFQ doesn't drive deep queue
> > > depth, which causes poor performance in some workloads. CFQ also isn't
> > > quite fair for fast storage (or further sacrifice of performance to get
> > > fairness) because it uses time based accounting. This isn't good for
> > > block cgroup. We need something different to make both performance and
> > > fairness good.
> > >
> > > A recent attempt is to use IOPS based ioscheduler for flash based
> > > storage. It's expected to drive deep queue depth (so better performance)
> > > and be more fairness (IOPS based accounting instead of time based).
> > >
> > > I'd like to discuss:
> > >  - Do we really need it? Or the question is if it is popular real
> > > workloads drive deep io depth?
> > >  - Should we have a separate ioscheduler for this or merge it to CFQ?
> > >  - Other implementation discussions like differentiation of read/write
> > > requests and request size. Flash based storage doesn't like rotate
> > > storage, request cost of read/write and different request size usually
> > > is different.
> > 
> > I think you need to define a couple things to really gain traction.
> > First, what is the target?  Flash storage comes in many varieties, from
> > really poor performance to really, really fast.  Are you aiming to
> > address all of them?  If so, then let's see some numbers that prove that
> > you're basing your scheduling decisions on the right metrics for the
> > target storage device types.
> For fast storage, like SSD or PCIe flash card.

PCIe flash card can drive really deep queue depths to achieve optimal
performance. IIRC, we have driven queue depths of 512 or even more. If
that's the case, then threre might not be much point in IO scheduler
trying to provide per process fairness. Deadline doing batches of reads
and writes might be just enough.

> 
> > Second, demonstrate how one workload can negatively affect another.  In
> > other words, justify the need for *any* I/O prioritization.  Building on
> > that, you'd have to show that you can't achieve your goals with existing
> > solutions, like deadline or noop with bandwidth control.
> Basically some workloads with cgroup. bandwidth control doesn't cover
> all requirements for cgroup users, that's why we have cgroup for CFQ
> anyway.

What requirements are not covered? If you are just looking for fairness
among cgroups and CFQ already has iops mode for groups.

> 
> >   Proportional
> > weight I/O scheduling is often sub-optimal when the device is not kept
> > busy.  How will you address that?
> That's true. I choose better performance instead of better fairness if
> device isn't busy. Fast flash storage is expensive, I thought
> performance is more important in such case.

How do you decide whether drive is being utilized to the capacity? Looking
at queue depths itself is not sufficient. In flash based PCIe devices we
have noticed that driving deeper queue depths helped with throughput. So
just looking at random number of requests in flight to determine whether
drive is fully used or not is not a very good idea.

I agree with Jeff that we probably first need some real workload examples
and numbers to justify the need of an IOPS based scheduler. Once we are
convinced that we need it, discussion can go to next level where we
try to figure out whether we need to extend CFQ to handle that mode or
we need a new IO scheduler altoghether.

Thanks
Vivek
