From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 7/8] hisi_sas: fix calls to dma_set_mask_and_coherent()
Date: Mon, 18 Feb 2019 09:24:18 +0000
Message-ID: <5692f8d3-6770-bf70-d650-708307cb6452@huawei.com>
References: <20190218073426.111853-1-hare@suse.de>
 <20190218073426.111853-8-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190218073426.111853-8-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 18/02/2019 07:34, Hannes Reinecke wrote:

Hi Hannes,

Thanks for this. I have some comments, below.

> The change to use dma_set_mask_and_coherent() incorrectly made a second
> call with the 32 bit DMA mask value when the call with the 64 bit DMA
> mask value succeeded.

And the second call to dma_set_mask_and_coherent() is not done if first 
fails, and we just bail out.

This resulted in FC connections failing due
> to corrupted data buffers, and various other SCSI/FCP I/O errors.
>

Not relevant.

> Fixes: e4db40e7a1a2 ("scsi: hisi_sas: use dma_set_mask_and_coherent")
> Cc: <stable@vger.kernel.org>

e4db40e7a1a2 only went into 5.0, so I don't know which stable kernel 
we're trying to fix. I am assuming that we can get this fix into 5.0.

> Suggested-by: Ewan D. Milne <emilne@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c  | 8 ++++++--
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 8 +++++---
>  2 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 923296653ed7..13ca5a0bdf6b 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -2484,6 +2484,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
>  	struct Scsi_Host *shost;
>  	struct hisi_hba *hisi_hba;
>  	struct device *dev = &pdev->dev;
> +	int error;
>
>  	shost = scsi_host_alloc(hw->sht, sizeof(*hisi_hba));
>  	if (!shost) {
> @@ -2504,8 +2505,11 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
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


This code was ok as is, so we're not really fixing anything. And 
certainly not fixing e4db40e7a1a2, so I am unsure if this should be 
included.

>  	}
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 00738d0673fe..79390f235c7e 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -2742,10 +2742,12 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		goto err_out_disable_device;
>
> -	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
> -	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
> +	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (rc)
> +		rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +	if (rc) {
>  		dev_err(dev, "No usable DMA addressing method\n");
> -		rc = -EIO;
> +		rc = -ENODEV;
>  		goto err_out_regions;
>  	}
>
>
