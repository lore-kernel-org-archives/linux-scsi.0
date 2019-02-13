From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 3/4] bfa: fix calls to dma_set_mask_and_coherent()
Date: Wed, 13 Feb 2019 13:52:30 -0500
Message-ID: <aae0c25ab1b44c391ce47a626730c9c66f680ecc.camel@redhat.com>
References: <20190213114234.67275-1-hare@suse.de>
         <20190213114234.67275-4-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190213114234.67275-4-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

See below.  Also see comment re: the patch description.

-Ewan

On Wed, 2019-02-13 at 12:42 +0100, Hannes Reinecke wrote:
> The change to use dma_set_mask_and_coherent() incorrectly made a second
> call with the 32 bit DMA mask value when the call with the 64 bit DMA
> mask value succeeded.  This resulted in FC connections failing due
                         -------------------------------------------
> to corrupted data buffers, and various other SCSI/FCP I/O errors.
  -----------------------------------------------------------------

The last sentence should be removed from the patch description.

> 
> Fixes: a69b080025ea ("scsi: bfa: use dma_set_mask_and_coherent")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Ewan D. Milne <emilne@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/bfa/bfad.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
> index 42a0caf6740d..2ffbe36f5860 100644
> --- a/drivers/scsi/bfa/bfad.c
> +++ b/drivers/scsi/bfa/bfad.c
> @@ -727,7 +727,7 @@ bfad_init_timer(struct bfad_s *bfad)
>  int
>  bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
>  {
> -	int		rc = -ENODEV;
> +	int rc;

There are error paths from the calls to pci_enable_device() and
pci_request_regions() that will return an undefined value if this
initializer is removed.  Leave it in place?

>  
>  	if (pci_enable_device(pdev)) {
>  		printk(KERN_ERR "pci_enable_device fail %p\n", pdev);
> @@ -739,11 +739,15 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
>  
>  	pci_set_master(pdev);
>  
> -	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
> -	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
> +	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (rc)
> +		rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +
> +	if (rc) {
>  		printk(KERN_ERR "dma_set_mask_and_coherent fail %p\n", pdev);
>  		goto out_release_region;
>  	}
> +	rc = -ENODEV;
>  
>  	/* Enable PCIE Advanced Error Recovery (AER) if kernel supports */
>  	pci_enable_pcie_error_reporting(pdev);
