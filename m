From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Thin provisioning update
Date: Mon, 9 Nov 2009 09:20:51 -0500
Message-ID: <20091109142051.GC4855@infradead.org>
References: <1257308740-4729-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbZKIOU4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 09:20:56 -0500
Content-Disposition: inline
In-Reply-To: <1257308740-4729-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hch@infradead.org, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

On Tue, Nov 03, 2009 at 11:25:38PM -0500, Martin K. Petersen wrote:
> Christoph,
> 
> Here are some more recent bits for you to tinker with.
> 
> The first patch exports unmap granularity and alignment up the stack.  I have
> also implemented support for topology stacking of these parameters.  A reported
> discard granularity of 0 means fully provisioned.
> 
> In the second patch I made a few changes to the TP detection and extraction of
> VPD values.

I was offline for a while, but I have another half-finished alternative
to it.  Which only exposes the discard granularity/alignment at the
whole disk level and does the adjustment in sd.  I think I actually
prefer it - I'll post it for review as soon as I have cought up with my
backlog.

> I have been hunting for heuristics for the WRITE SAME case but haven't found any
> good ones.  I'm thinking we probably want to distinguish between a real array
> with NV-backed unmap queueing and a thinly provisioned disk on a virtualization
> server where there might be a real impact from having to zero out partial blocks.
> I guess that's easy to handle with virtio but I'm not so sure how to do it when
> emulating a SCSI disk.

We might just offer UNMAP for virtualized disks for now to sort this
out.  But the primary use case at least for now will be ide TRIM for
virtualized environments with virtio as a second and scsi a distant
third for now.

