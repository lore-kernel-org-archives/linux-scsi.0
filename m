From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Wed, 16 Mar 2005 17:04:47 +0100
Message-ID: <20050316160447.GU7842@suse.de>
References: <200503160209.j2G29cAf010870@hera.kernel.org> <20050316075839.GC7842@suse.de> <1110986016.5771.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:33941 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262661AbVCPQEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 11:04:51 -0500
Content-Disposition: inline
In-Reply-To: <1110986016.5771.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, g.liakhovetski@gmx.de

On Wed, Mar 16 2005, James Bottomley wrote:
> On Wed, 2005-03-16 at 08:58 +0100, Jens Axboe wrote:
> > Guys, who reviewed this? It looks completely bogus, using kmap() for tha
> > entire sg list is just wrong and can deadlock easily. The proper way is
> > of course to skip the virtual address requirement and dma map the sg
> > array properly.
> 
> I suppose ultimately, the responsibility is mine.
> 
> The problem with this particular card (at least as I read the comments
> in the driver) is that most of the time, it can actually do DMA on its
> own.  However, when something unexpected occurs (Like a SCSI device
> disconnections), the DMA engine halts and the last pieces of data have
> to be read in manually using PIO.

Ah, that is very similar to IDE in fact. Not lovely :-)

> I agree the kmap is inefficient.  The efficient alternative is to do
> dma_map_sg() and use kmap_atomic() in the interrupt routine where we do
> the PIO cleanup---I'm afraid I just passed on explaining how to do
> this ... unless you care to do the honours ?

The kmap() isn't just inefficient, it's a problem to iterate over the sg
list and kmap all the pages. That is illegal.

But it's not so tricky to get right, if the punting just happens in the
isr. Basically just iterate over every sg entry left ala:

        for (i = start; i < sg_entries; i++) {
                unsigned long flags;
                char *ptr;

                local_irq_save(flags);
                ptr = kmap_atomic(sg->page, KM_BIO_SRC_IRQ);

                /* transfer to/from ptr + sg->offset, sg->length bytes */

                kunmap_atomic(ptr, KM_BIO_SRC_IRQ);
                local_irq_restore(flags);
        }

I _think_ the sg->length field is universally called so, you should not
use sg->dma_length/sg_dma_len() or sg_dma_address(), as we are outside
the work of the iommu at this point.

-- 
Jens Axboe

