From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] sg: increase sglist_len of the sg_scatter_hold
 structure
Date: Thu, 9 Aug 2007 22:43:58 +0900
Message-ID: <20070809155653I.tomof@acm.org>
References: <46B8A845.4080106@cs.wisc.edu>
	<20070808073801U.fujita.tomonori@lab.ntt.co.jp>
	<46B9F626.9020200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:57337 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbXHINoS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Aug 2007 09:44:18 -0400
In-Reply-To: <46B9F626.9020200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: fujita.tomonori@lab.ntt.co.jp, dougg@torque.net, tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.comfujita.tomonori@lab.ntt.co.jp

On Wed, 08 Aug 2007 11:58:14 -0500
Mike Christie <michaelc@cs.wisc.edu> wrote:

> FUJITA Tomonori wrote:
> > On Tue, 07 Aug 2007 12:13:41 -0500
> > Mike Christie <michaelc@cs.wisc.edu> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>> Allocating 64K contiguous memory is not good so the next thing to do
> >>> is converting sg to use the sg chaining support fully. Or it might be
> >> For LLDs like aic7xxx, I think we are stuck with a small 
> >> scsi_host_template->sg_tablesize, so to continue to get large requests 
> >> like before will we have to still allocate large segments?
> > 
> > No. sg.c has:
> > 
> > sizeof(struct scatterlist) * min(q->max_hw_segments, q->max_phys_segments)
> > 
> > If a lld has small max_hw_segments, it doesn't allocate big contiguous
> > memory.
> > 
> 
> Are we talking about the same thing? Are you saying that it does not 
> allocate big continuous memory for the scatterlist right? I was asking 
> about continuous memory for the buffer sg.c copies data to/from for the 
> IO operation. I was saying that currently for something like aic if we 
> want to continue to support 8 MB commands (or whatever it was) like 
> before, then because its sg_tablesize/max_hw_segments is so small we 
> have to continue allocating large IO buffers. That did not change right? 
> If so let me know because you save me :)

Oops, sorry. I think that nothing changes about large IO buffers. You
have to contiunue to allocate large IO buffers like before.
