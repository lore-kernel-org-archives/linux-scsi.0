From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
 about VMERGE
Date: Wed, 16 Jul 2008 14:02:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807161359001.30207@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807151033040.25390@devserv.devel.redhat.com>
 <20080716003047P.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0807151143050.29803@devserv.devel.redhat.com>
 <20080716093456J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbYGPSDQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 14:03:16 -0400
In-Reply-To: <20080716093456J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org

On Wed, 16 Jul 2008, FUJITA Tomonori wrote:

> On Tue, 15 Jul 2008 11:46:46 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > >> Even if we fix it now, the question is: how long it will stay fixed? Until
> > >> someone makes another change to struct device that restricts boundaries on
> > >> some wacky hardware.
> > >
> > > I'm not sure how the boundary restriction of a device can break
> > > the VMERGE accounting.
> > 
> > Because block layer code doesn't know anything about the device, pci 
> > access restrictions and so on.
> 
> Not true, the block layer knows about the device restrictions like DMA
> boundary.
> 
> But it's not the point here because the boundary restriction doesn't
> matter for the VMERGE accounting. An IOMMU just returns an error if it
> can't allocate an I/O space fit for the device restrictions.
> 
> 
> Please give me an example how the boundary restriction of a device can
> break the VMERGE accounting and an IOMMU if you aren't still sure.

You have dma_get_seg_boundary and dma_get_max_seg_size. On sparc64, adding 
one of these broken VMERGE accounting (the VMERGE didn't happen past 64-kb 
boundary and bio layer thought that VMERGE would be possible).

And if you fix this case, someone will break it again, sooner or later, by 
adding new restriction.

Mikulas
