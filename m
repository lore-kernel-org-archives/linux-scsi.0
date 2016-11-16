From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v3] ufs: introduce UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR quirk
Date: Wed, 16 Nov 2016 10:54:48 -0800
Message-ID: <f8c2f1028a39a13130dc8831584d96cb@codeaurora.org>
References: <000601d23fc7$0701b580$15052080$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbcKPSyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 13:54:49 -0500
In-Reply-To: <000601d23fc7$0701b580$15052080$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-15 21:05, Kiwoong Kim wrote:
> If UFS driver resets interrupt aggregation timer and counter
> when there are some pended tasks, an IO competion interrupt
> of any corresponing task may be issued.
> That would casue a command timeout.
> 
> One thing you should mind to use interrupt aggreation
> with this quirk is that the host controller should be
> able to refresh interrupt aggreation counter or timer
> in other way, such as doing it automatically when receiving
> any response.
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
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  drivers/scsi/ufs/ufshcd.h | 7 +++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8aac98f..7b62d8b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3713,7 +3713,8 @@ static void ufshcd_transfer_req_compl(struct 
> ufs_hba *hba)
>  	 * false interrupt if device completes another request after 
> resetting
>  	 * aggregation and before reading the DB.
>  	 */
> -	if (ufshcd_is_intr_aggr_allowed(hba))
> +	if ((ufshcd_is_intr_aggr_allowed(hba))
> +		&& !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
>  		ufshcd_reset_intr_aggr(hba);
> 
>  	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index dfa17ac..d6861ed 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -505,6 +505,13 @@ struct ufs_hba {
>  	 */
>  	#define UFSHCD_QUIRK_BROKEN_HCE				UFS_BIT(9)
> 
> +	/*
> +	 * This quirk is only not to reset interrupt aggregation logic
> +	 * in ISR. The reset can make the host controller miss an event
> +	 * of previously completed IO.
> +	 */
> +	#define UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		UFS_BIT(10)
> +
>  	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
> 
>  	/* Device deviations from standard UFS device spec. */

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
