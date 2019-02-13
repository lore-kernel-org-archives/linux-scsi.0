From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 4/4] hisi_sas: fix calls to dma_set_mask_and_coherent()
Date: Wed, 13 Feb 2019 13:52:44 -0500
Message-ID: <d3fdae2d562cc8dcae2c8dbd09c60d4ceb4da4c8.camel@redhat.com>
References: <20190213114234.67275-1-hare@suse.de>
         <20190213114234.67275-5-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190213114234.67275-5-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

See comment below re: the patch description.  The
code itself looks fine.

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
> Fixes: e4db40e7a1a2 ("scsi: hisi_sas: use dma_set_mask_and_coherent")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Ewan D. Milne <emilne@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index eed7fc5b3389..bc17fa0d8375 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -2323,6 +2323,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
>  	struct Scsi_Host *shost;
>  	struct hisi_hba *hisi_hba;
>  	struct device *dev = &pdev->dev;
> +	int error;
>  
>  	shost = scsi_host_alloc(hw->sht, sizeof(*hisi_hba));
>  	if (!shost) {
> @@ -2343,8 +2344,11 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
>  	if (hisi_sas_get_fw_info(hisi_hba) < 0)
>  		goto err_out;
>  
> -	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) &&
> -	    dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
> +	error = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> +	if (error)
> +		error = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
> +
> +	if (error) {
>  		dev_err(dev, "No usable DMA addressing method\n");
>  		goto err_out;
>  	}
