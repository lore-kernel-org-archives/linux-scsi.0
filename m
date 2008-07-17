From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
Date: Thu, 17 Jul 2008 22:18:44 +0900
Message-ID: <20080717221908D.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0807161359001.30207@devserv.devel.redhat.com>
	<20080717131444K.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0807170746001.31185@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:54376 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbYGQNU3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 09:20:29 -0400
In-Reply-To: <Pine.LNX.4.64.0807170746001.31185@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mpatocka@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org

On Thu, 17 Jul 2008 07:50:24 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> > > > Please give me an example how the boundary restriction of a device can
> > > > break the VMERGE accounting and an IOMMU if you aren't still sure.
> > > 
> > > You have dma_get_seg_boundary and dma_get_max_seg_size. On sparc64, adding 
> > > one of these broken VMERGE accounting (the VMERGE didn't happen past 64-kb 
> > > boundary and bio layer thought that VMERGE would be possible).
> > 
> > If the device has 64KB boundary restriction, the device also has
> > max_seg_size restriction of 64KB or under. So the vmerge acounting
> > works (though we need to fix it to handle max_seg_size, as discussed).
> > 
> > > And if you fix this case, someone will break it again, sooner or later, by 
> > > adding new restriction.
> > 
> > All restrictions that IOMMUs need to know are dma_get_seg_boundary and
> > dma_get_max_seg_size.
> > 
> > What is your new restriction?
> 
> We don't know what happens in the future.

It's very unlikely to add new restrictions.


> And that is the problem that we 
> don't know --- but we have two pieces of code (blk-merge and iommu) that 
> try to calculate the same number (number of hw segments) and if they get 
> different result, it will crash. If the calculations were done at one 
> place, there would be no problem with that.

I don't think that your argument, 'the problem that we don't know', is
true.

With the vmerge accounting, we calculate at two places. So if we add
a new restriction, we need to handle it at two places. It's a logical
result.

Of course, it's easier to calculate at one place rather than two
places. But 'we don't know what restriction we will need' isn't a
problem.


BTW, as I've already said, I'm not against removing the vmerge
accounting from the block layer.
