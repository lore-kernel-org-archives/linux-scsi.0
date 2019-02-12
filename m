From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: lpfc: fix calls to dma_set_mask_and_coherent()
Date: Tue, 12 Feb 2019 10:37:45 -0500
Message-ID: <9572ae3b0131ad1c74d6a775f819437e3d4f1795.camel@redhat.com>
References: <20190211150502.9999-1-emilne@redhat.com>
         <20190212080627.GC10547@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190212080627.GC10547@infradead.org>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, stable@vger.kernel.org, james.smart@broadcom.com, dick.kennedy@broadcom.com, martin.petersen@oracle.com, jejb@linux.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2019-02-12 at 00:06 -0800, Christoph Hellwig wrote:
> On Mon, Feb 11, 2019 at 10:05:02AM -0500, Ewan D. Milne wrote:
> > The change to use dma_set_mask_and_coherent() incorrectly made a second
> > call with the 32 bit DMA mask value when the call with the 64 bit DMA
> > mask value succeeded.  This resulted in NVMe/FC connections failing due
> > to corrupted data buffers, and various other SCSI/FCP I/O errors.
> 
> Ooops, sorry.
> 
> >  	/* Set the device DMA mask size */
> > -	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
> > -	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
> > -		return error;
> > +	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) != 0)
> > +		if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0)
> 
> But this still looks obsfuctating, why not:
> 
> 	error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> 	if (error)
> 		error = dma_set_mask_and_coherent(&pdev->dev,
> 				DMA_BIT_MASK(32)));
> 	if (error)
> 		return error;

I agree that making the flow of control explicit would be good, but...

It looks like this would introduce a different problem.  "error" is set to
-ENODEV earlier in the two functions so that the various error paths will return
that value.  If it is overwritten with a successful result from the call to
dma_set_mask_and_coherent() but a later call to e.g. ioremap() fails, the
functions will incorrectly return a value indicating that they have succeeded.

It also appears as if the patches to hptiop, hisi_sas and bfa need to be fixed up.
I don't have a test environment for these, although I might be able to modify the
test environment for bfa.  Martin/James, what about the others?

-Ewan
