From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 4/4] drivers/scsi/mvsas/mv_init: Use dma_zalloc_coherent
 to replace dma_alloc_coherent+memset
Date: Thu, 2 Aug 2018 00:55:27 +0100
Message-ID: <b533cd56-947e-e276-2ef9-a5e15b0a5d94@huawei.com>
References: <1533129976-51930-1-git-send-email-zhongjiang@huawei.com>
 <1533129976-51930-5-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533129976-51930-5-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com
Cc: andy.shevchenko@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/08/2018 14:26, zhong jiang wrote:
> The dma_zalloc_coherent is better than dma_alloc_coherent+memset,
> so replace them.
>
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/scsi/mvsas/mv_init.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 8c91637..da62e18 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -253,33 +253,29 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
>  	/*
>  	 * alloc and init our DMA areas
>  	 */
> -	mvi->tx = dma_alloc_coherent(mvi->dev,
> +	mvi->tx = dma_zalloc_coherent(mvi->dev,
>  				     sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
>  				     &mvi->tx_dma, GFP_KERNEL);
>  	if (!mvi->tx)
>  		goto err_out;
> -	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
> -	mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
> +	mvi->rx_fis = dma_zalloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
>  					 &mvi->rx_fis_dma, GFP_KERNEL);

Nit: Please ensure that you maintain alignment between the opening brace 
and each new line.

Thanks,

>  	if (!mvi->rx_fis)
>  		goto err_out;
> -	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
>
> -	mvi->rx = dma_alloc_coherent(mvi->dev,
> +	mvi->rx = dma_zalloc_coherent(mvi->dev,
>  				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
>  				     &mvi->rx_dma, GFP_KERNEL);
>  	if (!mvi->rx)
>  		goto err_out;
> -	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
>  	mvi->rx[0] = cpu_to_le32(0xfff);
>  	mvi->rx_cons = 0xfff;
>
> -	mvi->slot = dma_alloc_coherent(mvi->dev,
> +	mvi->slot = dma_zalloc_coherent(mvi->dev,
>  				       sizeof(*mvi->slot) * slot_nr,
>  				       &mvi->slot_dma, GFP_KERNEL);
>  	if (!mvi->slot)
>  		goto err_out;
> -	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
>
>  	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
>  				       TRASH_BUCKET_SIZE,
>
