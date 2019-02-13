From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 1/4] lpfc: fix calls to dma_set_mask_and_coherent()
Date: Wed, 13 Feb 2019 13:52:10 -0500
Message-ID: <8d799a1a4e8b801bdf9ae019510582264d0695e6.camel@redhat.com>
References: <20190213114234.67275-1-hare@suse.de>
         <20190213114234.67275-2-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190213114234.67275-2-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

See below.  Also, this patch only fixes 1 of the 2 places,
we need to fix lpfc_sli4_pci_mem_setup() also.  With the
same code applied in both places, the NVMe/FC issue is fixed.
I expect the SCSI/FCP tests would pass too, but those take
a couple of days.

-Ewan

On Wed, 2019-02-13 at 12:42 +0100, Hannes Reinecke wrote:
> The change to use dma_set_mask_and_coherent() incorrectly made a second
> call with the 32 bit DMA mask value when the call with the 64 bit DMA
> mask value succeeded.  This resulted in NVMe/FC connections failing due
> to corrupted data buffers, and various other SCSI/FCP I/O errors.
> 
> Fixes: f30e1bfd6154 ("scsi: lpfc: use dma_set_mask_and_coherent")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Don Dutile <ddutile@redhat.com>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index bede11e16349..8a4b096ffe47 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -7361,15 +7361,18 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
>  	unsigned long bar0map_len, bar2map_len;
>  	int i, hbq_count;
>  	void *ptr;
> -	int error = -ENODEV;
> +	int error;
>  
>  	if (!pdev)
>  		return error;

Since this patch removes the initialization of "error" above, this return
statement returns an undefined value.  Change it to return -ENODEV?

>  
>  	/* Set the device DMA mask size */
> -	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
> -	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
> +	error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (error)
> +		error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +	if (error)
>  		return error;
> +	error = -ENODEV;
>  
>  	/* Get the bus address of Bar0 and Bar2 and the number of bytes
>  	 * required by each mapping.
