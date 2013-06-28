From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 10/10] ufs: fix DMA mask setting
Date: Fri, 28 Jun 2013 13:37:16 -0700
Message-ID: <1372451836.1884.23.camel@dabdike>
References: <1372266575-3468-1-git-send-email-santoshsy@gmail.com>
	 <1372266575-3468-11-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47422 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588Ab3F1UhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jun 2013 16:37:19 -0400
In-Reply-To: <1372266575-3468-11-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Akinobu Mita <mita@fixstars.com>

On Wed, 2013-06-26 at 22:39 +0530, Santosh Y wrote:
> index 19618c6..431ddb2 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1711,6 +1711,25 @@ void ufshcd_remove(struct ufs_hba *hba)
>  EXPORT_SYMBOL_GPL(ufshcd_remove);
>  
>  /**
> + * ufshcd_set_dma_mask - Set dma mask based on the controller
> + *			 addressing capability
> + * @hba: per adapter instance
> + *
> + * Returns 0 for success, non-zero for failure
> + */
> +static int ufshcd_set_dma_mask(struct ufs_hba *hba)
> +{
> +	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
> +		if (!dma_set_mask(hba->dev, DMA_BIT_MASK(64)) &&
> +		    !dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(64)))
> +			return 0;
> +	}
> +	dma_set_mask(hba->dev, DMA_BIT_MASK(32));
> +
> +	return dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(32));
> +}

This isn't right per the API spec.  The guarantee is that if
dma_set_mask() succeeds then dma_set_coherent_mask of the same mask will
succeed,  so this should read

	int err;

	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
		if (!dma_set_mask(hba->dev, DMA_BIT_MASK(64))) {
			dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(64)))
			return 0;
		}
	}
	err = dma_set_mask(hba->dev, DMA_BIT_MASK(32));
	if (!err)
		dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(32));
	return err;

James


