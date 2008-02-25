From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [3/22] Remove unchecked_isa_dma in advansys.c
Date: Mon, 25 Feb 2008 14:58:06 -0800
Message-ID: <1203980286.3254.54.camel@localhost.localdomain>
References: <200802251235.889863872@firstfloor.org>
	 <20080224233516.0657F1B4183@basil.firstfloor.org>
	 <20080225214746.GA11382@parisc-linux.org>
	 <20080225224035.GB21577@one.firstfloor.org>
	 <20080225225022.GD20273@parisc-linux.org>  <47C34715.7040005@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43984 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760780AbYBYW6L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 17:58:11 -0500
In-Reply-To: <47C34715.7040005@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org


On Mon, 2008-02-25 at 17:54 -0500, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> > On Mon, Feb 25, 2008 at 11:40:35PM +0100, Andi Kleen wrote:
> >>> (I must have fixed it somehow because it works on parisc, which is most
> >>> unforgiving of drivers which do DMA without the DMA API).
> >> At least on x86 the DMA API cannot do ISA bouncing.
> > 
> > You're saying that if I set a 24-bit DMA mask, and then do a
> > pci_alloc_coherent(), x86 might hand me back something that's not
> > accessible?  That would be just broken.
> 
> Indeed.

It's doing the right thing (from pci-dma_32.c):

void *dma_alloc_coherent(struct device *dev, size_t size,
			   dma_addr_t *dma_handle, gfp_t gfp)
[...]
	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
		gfp |= GFP_DMA;


	ret = (void *)__get_free_pages(gfp, order);


Which correctly allocates the region.

James



