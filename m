From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] Fix for aacraid and high memory on 2.6.1
Date: Wed, 14 Jan 2004 13:48:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074116933.7662.65.camel@markh1.pdx.osdl.net>
References: <1074113037.7662.45.camel@markh1.pdx.osdl.net>
	 <1074115078.2054.166.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:51921 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264329AbUANVsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 16:48:55 -0500
In-Reply-To: <1074115078.2054.166.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, 2004-01-14 at 13:17, James Bottomley wrote:
> On Wed, 2004-01-14 at 15:43, Mark Haverkamp wrote:
> > +	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT) {
> > +		if (pci_set_dma_mask(pdev, 0x7FFFFFFFULL))
> [...]
> > +	/*
> > +	 * If we had set a smaller DMA mask earlier, set it to 4gig
> > +	 * now since the adapter can dma data to at least a 4gig
> > +	 * address space.
> > +	 */
> > +	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
> > +		if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
> > +			goto out_free_fibs;
> 
> Rather than doing this, could you just do a 
> 
> pci_set_consistent_dma_mask()?

I think so.  Looking at DMA-API.txt and DMA-mapping.txt,
set_consistent_dma_mask() to the smaller value would affect
pci_alloc_consistent() calls.  Calling pci_set_dma_mask() with the full
32bit or greater size would allow data DMA without bounces.  Is that
correct?  The kmalloc of the fib structs would have to change if the
consistent dma mask doesn't cover kmalloc.


> 
> Unfortunately, it's currently not correctly implemented for this case on
> x86 (and you don't seem to be able to do what you want on many non-x86
> archs), but I think we can get the implementation fixed.

What do you suggest?  Should the current patch be applied and updated
when the consistent_dma_mask code is fixed?  This code does seem to work
OK.

Mark.

> 
> James
-- 
Mark Haverkamp <markh@osdl.org>

