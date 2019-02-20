From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: csiostor: fix incorrect if condition for setting
 dma mask
Date: Wed, 20 Feb 2019 15:55:30 +0000
Message-ID: <3385a58e-41be-4fbd-5f19-6613ec6df297@huawei.com>
References: <1550676921-5764-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1550676921-5764-1-git-send-email-varun@chelsio.com>
Sender: stable-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, dt@chelsio.com, indranil@chelsio.com, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 20/02/2019 15:35, Varun Prakash wrote:
> Use && instead of || in if condition as
> dma_set_mask_and_coherent() returns 0 on success.
>
> Fixes: c22b332d811b ("scsi: csiostor: switch to generic DMA API")
> Cc: stable@vger.kernel.org
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>  drivers/scsi/csiostor/csio_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
> index cf629380a981..e7ad7b1a0440 100644
> --- a/drivers/scsi/csiostor/csio_init.c
> +++ b/drivers/scsi/csiostor/csio_init.c
> @@ -210,7 +210,7 @@ csio_pci_init(struct pci_dev *pdev, int *bars)
>  	pci_set_master(pdev);
>  	pci_try_set_mwi(pdev);
>
> -	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
> +	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) &&
>  	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
>  		dev_err(&pdev->dev, "No suitable DMA available.\n");
>  		goto err_release_regions;
>

I think Hannes already sent a fix for this:
https://marc.info/?l=linux-scsi&m=155047528202096&w=2

Thanks
