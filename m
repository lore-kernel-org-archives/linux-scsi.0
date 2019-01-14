From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: ufs: Consider device limitations for dma_mask
Date: Mon, 14 Jan 2019 03:11:09 -0800
Message-ID: <20190114111109.GA18673@infradead.org>
References: <20190111225402.6133-1-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190111225402.6133-1-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Douglas Anderson <dianders@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 11, 2019 at 02:54:02PM -0800, Bjorn Andersson wrote:
>   */
>  static int ufshcd_set_dma_mask(struct ufs_hba *hba)
>  {
> -	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
> -		if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)))
> -			return 0;
> -	}
> -	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
> +	u64 dma_mask = dma_get_mask(hba->dev);
> +
> +	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT)
> +		dma_mask &= DMA_BIT_MASK(64);
> +	else
> +		dma_mask &= DMA_BIT_MASK(32);
> +
> +	return dma_set_mask_and_coherent(hba->dev, dma_mask);

NAK.  ufshcd clearly is in charge of setting the dma mask, so reading
it back from someone else who might have set it is completely bogus.

You either need to introduce a quirk or a way to communicate the
different limit so that it can be set by the core.
