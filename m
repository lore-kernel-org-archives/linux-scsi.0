From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: lpfc: fix calls to dma_set_mask_and_coherent()
Date: Tue, 12 Feb 2019 00:06:27 -0800
Message-ID: <20190212080627.GC10547@infradead.org>
References: <20190211150502.9999-1-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211150502.9999-1-emilne@redhat.com>
Sender: stable-owner@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, stable@vger.kernel.org, james.smart@broadcom.com, dick.kennedy@broadcom.com, martin.petersen@oracle.com, jejb@linux.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 11, 2019 at 10:05:02AM -0500, Ewan D. Milne wrote:
> The change to use dma_set_mask_and_coherent() incorrectly made a second
> call with the 32 bit DMA mask value when the call with the 64 bit DMA
> mask value succeeded.  This resulted in NVMe/FC connections failing due
> to corrupted data buffers, and various other SCSI/FCP I/O errors.

Ooops, sorry.

>  	/* Set the device DMA mask size */
> -	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
> -	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
> -		return error;
> +	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) != 0)
> +		if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0)

But this still looks obsfuctating, why not:

	error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
	if (error)
		error = dma_set_mask_and_coherent(&pdev->dev,
				DMA_BIT_MASK(32)));
	if (error)
		return error;
