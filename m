From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
Date: Thu, 17 Jul 2008 13:14:18 +0900
Message-ID: <20080717131444K.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0807151143050.29803@devserv.devel.redhat.com>
	<20080716093456J.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0807161359001.30207@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807161359001.30207@devserv.devel.redhat.com>
Sender: linux-parisc-owner@vger.kernel.org
To: mpatocka@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 16 Jul 2008 14:02:27 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Wed, 16 Jul 2008, FUJITA Tomonori wrote:
> 
> > On Tue, 15 Jul 2008 11:46:46 -0400 (EDT)
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > >> Even if we fix it now, the question is: how long it will stay fixed? Until
> > > >> someone makes another change to struct device that restricts boundaries on
> > > >> some wacky hardware.
> > > >
> > > > I'm not sure how the boundary restriction of a device can break
> > > > the VMERGE accounting.
> > > 
> > > Because block layer code doesn't know anything about the device, pci 
> > > access restrictions and so on.
> > 
> > Not true, the block layer knows about the device restrictions like DMA
> > boundary.
> > 
> > But it's not the point here because the boundary restriction doesn't
> > matter for the VMERGE accounting. An IOMMU just returns an error if it
> > can't allocate an I/O space fit for the device restrictions.
> > 
> > 
> > Please give me an example how the boundary restriction of a device can
> > break the VMERGE accounting and an IOMMU if you aren't still sure.
> 
> You have dma_get_seg_boundary and dma_get_max_seg_size. On sparc64, adding 
> one of these broken VMERGE accounting (the VMERGE didn't happen past 64-kb 
> boundary and bio layer thought that VMERGE would be possible).

If the device has 64KB boundary restriction, the device also has
max_seg_size restriction of 64KB or under. So the vmerge acounting
works (though we need to fix it to handle max_seg_size, as discussed).


> And if you fix this case, someone will break it again, sooner or later, by 
> adding new restriction.

What is your new restriction?

All restrictions that IOMMUs need to know are dma_get_seg_boundary and
dma_get_max_seg_size.
