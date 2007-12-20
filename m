From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/5] dma_map_sg_ring() helper
Date: Wed, 19 Dec 2007 23:42:44 -0800 (PST)
Message-ID: <20071219.234244.148945256.davem@davemloft.net>
References: <200712201648.58480.rusty@rustcorp.com.au>
	<200712201649.31254.rusty@rustcorp.com.au>
	<20071220160631S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50843
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbXLTHmt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 02:42:49 -0500
In-Reply-To: <20071220160631S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: rusty@rustcorp.com.au, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 20 Dec 2007 16:06:31 +0900

> On Thu, 20 Dec 2007 16:49:30 +1100
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > +/**
> > + * dma_map_sg_ring - Map an entire sg ring
> > + * @dev: Device to free noncoherent memory for
> > + * @sg: The sg_ring
> > + * @direction: DMA_TO_DEVICE, DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
> > + *
> > + * This returns -ENOMEM if mapping fails.  It's not clear that telling you
> > + * it failed is useful though.
> > + */
> > +int dma_map_sg_ring(struct device *dev, struct sg_ring *sg,
> > +		     enum dma_data_direction direction)
> > +{
> > +	struct sg_ring *i;
> > +	unsigned int num;
> > +
> > +	for (i = sg; i; i = sg_ring_next(i, sg)) {
> > +		BUG_ON(i->num > i->max);
> > +		num = dma_map_sg(dev, i->sg, i->num, direction);
> > +		if (num == 0 && i->num != 0)
> > +			goto unmap;
> > +	}
> > +	return 0;
> 
> I don't think that this works for IOMMUs that could merge sg entries.

Right, it won't work at all.

The caller has to be told how many DMA entries it really did use to
compose the mapping, and there has to be a way to properly iterate
over them.  The assumption that the IOMMU will map the SG entries
1-to-1 is invalid.

The IOMMU code can and will map thousands of pages all to one linear
DMA address+length pair of all the segments start and end on page
boundaries, since it can virtually remap those pages however it
chooses.
