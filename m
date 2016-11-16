From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v3] ufs: introduce UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR quirk
Date: Wed, 16 Nov 2016 10:52:53 -0800
Message-ID: <4efc79cfcd21ee4044a3d3a2f9551078@codeaurora.org>
References: <000401d23fc6$b6685110$2338f330$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39376 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbcKPSwz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 13:52:55 -0500
In-Reply-To: <000401d23fc6$b6685110$2338f330$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-15 21:03, Kiwoong Kim wrote:
> Some UFS host controllers may clear a transfer request slot
> by setting an associated bit in UTRLCLR/UTMRLCLR to 1, not 0.
> That's opposite to what UFS spec describes.
> 

This was the comment on v2: "As Martin mentioned in other email, please 
separate this version history from commit text with line having "----" 
before the start of version history."
So i would have expected the patch version to be still v2 and just add 
the version history separator added before version history. But you 
posted v3 and removed the version history altogether. As far as patch 
contents are concerned, it looks good to me hence i am adding by 
reviewed-by. But please make sure to keep the version history intact for 
fewer patches.

Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>


> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 28 ++++++++++++++++++++++++++--
>  drivers/scsi/ufs/ufshcd.h |  7 +++++++
>  2 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d6e3112..c9cf011 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -392,7 +392,31 @@ static inline void ufshcd_put_tm_slot(struct
> ufs_hba *hba, int slot)
>   */
>  static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
>  {
> -	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> +	u32 clear;
> +
> +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR)
> +		clear = (1 << pos);
> +	else
> +		clear = ~(1 << pos);
> +
> +	ufshcd_writel(hba, clear, REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> +}
> +
> +/**
> + * ufshcd_utmrl_clear - Clear a bit in UTRMLCLR register
> + * @hba: per adapter instance
> + * @pos: position of the bit to be cleared
> + */
> +static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
> +{
> +	u32 clear;
> +
> +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR)
> +		clear = (1 << pos);
> +	else
> +		clear = ~(1 << pos);
> +
> +	ufshcd_writel(hba, clear, REG_UTP_TASK_REQ_LIST_CLEAR);
>  }
> 
>  /**
> @@ -4312,7 +4336,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba
> *hba, int tag)
>  		goto out;
> 
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> -	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
> +	ufshcd_utmrl_clear(hba, tag);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
>  	/* poll for max. 1 sec to clear door bell register by h/w */
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 7d9ff22..9838598 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -491,6 +491,13 @@ struct ufs_hba {
>  	 */
>  	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			UFS_BIT(7)
> 
> +	/*
> +	 * This quirk needs to be enabled if the host contoller has to set
> +	 * the bit corresponding the slot to be cleared to 1, not 0 as
> +	 * described in UFS spec.
> +	 */
> +	#define UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR                UFS_BIT(8)
> +
>  	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
> 
>  	/* Device deviations from standard UFS device spec. */

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
