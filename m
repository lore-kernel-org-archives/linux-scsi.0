From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [LSF/MM TOPIC][ATTEND]IOPS based ioscheduler
Date: Tue, 31 Jan 2012 13:12:21 -0500
Message-ID: <x49ehufd9mi.fsf@segfault.boston.devel.redhat.com>
References: <1327997806.21268.47.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab2AaS0u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2012 13:26:50 -0500
In-Reply-To: <1327997806.21268.47.camel@sli10-conroe> (Shaohua Li's message of
	"Tue, 31 Jan 2012 16:16:46 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> Flash based storage has its characteristics. CFQ has some optimizations
> for it, but not enough. The big problem is CFQ doesn't drive deep queue
> depth, which causes poor performance in some workloads. CFQ also isn't
> quite fair for fast storage (or further sacrifice of performance to get
> fairness) because it uses time based accounting. This isn't good for
> block cgroup. We need something different to make both performance and
> fairness good.
>
> A recent attempt is to use IOPS based ioscheduler for flash based
> storage. It's expected to drive deep queue depth (so better performance)
> and be more fairness (IOPS based accounting instead of time based).
>
> I'd like to discuss:
>  - Do we really need it? Or the question is if it is popular real
> workloads drive deep io depth?
>  - Should we have a separate ioscheduler for this or merge it to CFQ?
>  - Other implementation discussions like differentiation of read/write
> requests and request size. Flash based storage doesn't like rotate
> storage, request cost of read/write and different request size usually
> is different.

I think you need to define a couple things to really gain traction.
First, what is the target?  Flash storage comes in many varieties, from
really poor performance to really, really fast.  Are you aiming to
address all of them?  If so, then let's see some numbers that prove that
you're basing your scheduling decisions on the right metrics for the
target storage device types.

Second, demonstrate how one workload can negatively affect another.  In
other words, justify the need for *any* I/O prioritization.  Building on
that, you'd have to show that you can't achieve your goals with existing
solutions, like deadline or noop with bandwidth control.  Proportional
weight I/O scheduling is often sub-optimal when the device is not kept
busy.  How will you address that?

Cheers,
Jeff
