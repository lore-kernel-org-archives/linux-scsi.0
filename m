From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Wed, 16 Mar 2005 16:48:06 +0000
Message-ID: <20050316164806.GO21986@parcelfarce.linux.theplanet.co.uk>
References: <200503160209.j2G29cAf010870@hera.kernel.org> <20050316075839.GC7842@suse.de> <1110986016.5771.3.camel@mulgrave> <20050316160447.GU7842@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:17543 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262680AbVCPQsH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 11:48:07 -0500
Content-Disposition: inline
In-Reply-To: <20050316160447.GU7842@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, g.liakhovetski@gmx.de

On Wed, Mar 16, 2005 at 05:04:47PM +0100, Jens Axboe wrote:
> The kmap() isn't just inefficient, it's a problem to iterate over the sg
> list and kmap all the pages. That is illegal.
> 
> But it's not so tricky to get right, if the punting just happens in the
> isr. Basically just iterate over every sg entry left ala:
> 
>         for (i = start; i < sg_entries; i++) {
>                 unsigned long flags;
>                 char *ptr;
> 
>                 local_irq_save(flags);
>                 ptr = kmap_atomic(sg->page, KM_BIO_SRC_IRQ);
> 
>                 /* transfer to/from ptr + sg->offset, sg->length bytes */
> 
>                 kunmap_atomic(ptr, KM_BIO_SRC_IRQ);
>                 local_irq_restore(flags);
>         }
> 
> I _think_ the sg->length field is universally called so, you should not
> use sg->dma_length/sg_dma_len() or sg_dma_address(), as we are outside
> the work of the iommu at this point.

Documentation/DMA-mapping.txt agrees with you:

                        Platform Issues

1) Struct scatterlist requirements.

   Struct scatterlist must contain, at a minimum, the following
   members:

        struct page *page;
        unsigned int offset;
        unsigned int length;

Would you mind writing up a change to DMA-mapping.txt that explains why
one would need to do the kmap solution you outline above?  If it needs
to be done for IDE and one SCSI driver, I bet it needs to be done for
more devices, and it'd be a handy place to refer to.

I'm a bit confused why the approach outlined in DMA-mapping.txt doesn't
work for this driver.  Is it because you don't find out until you're
in the interrupt handler that you need to map the sg-list and you can't
call pci_map_sg() from interrupt context?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
