From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA limit
 rather than to max memory
Date: Fri, 24 Sep 2010 10:05:32 -0700
Message-ID: <20100924170532.GA29071@us.ibm.com>
References: <c9516154fabc03112353.1285107750@malahal>
 <4C9CAE68.4060706@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50161 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab0IXRFf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2010 13:05:35 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o8OGoZsf032758
	for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2010 12:50:35 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o8OH5XuI106274
	for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2010 13:05:33 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o8OH5Xkv004381
	for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2010 14:05:33 -0300
Content-Disposition: inline
In-Reply-To: <4C9CAE68.4060706@fusionio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Jens Axboe [jaxboe@fusionio.com] wrote:
> On 2010-09-22 00:22, Malahal Naineni wrote:
> > The bounce_pfn of the request queue in 64 bit systems is set to the
> > current max_low_pfn. Adding more memory later makes this incorrect.
> 
> Clearly correct.
> 
> > Memory allocated beyond this boot time max_low_pfn appear to require
> > bounce buffers (bounce buffers are actually not allocated but used in
> > calculating segments that may result in "over max segments limit"
> > errors).
> 
> But I can't quite convince myself that the change is fully correct. You
> don't really explain in your own words what the patch does, just what it
> fixes.

OK, the problem is we get "over max segments limit" errors from
blk_rq_check_limits() after adding memory. The actual bug is in
blk_phys_contig_segment() where it doesn't check for possibility of
bounce buffers. This results in merging more requests in
ll_merge_requests_fn(). Later, blk_recalc_rq_segments() call from
blk_rq_check_limits() actually uses the possibility of bounce buffers,
so the calculated number of segments exceed q's max_segments resulting
in the above error.

Fix for the actual problem is posted here:
http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/12426

So clearly the bug should manifest only when 'bounce buffers' are
involved!  Applying the above patch indeed_fixed_ the problem, but I
know there shouldn't be any need for bounce buffers on our system, and
further investigation revealed that DMA limit is not set correctly.

This patch also _fixed_ our problem. So we are fine with either patch,
but this patch is preferred as it enables more request merges. Also,
both patches maybe needed for some configurations.

Thanks, Malahal.
