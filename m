From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v1] ufs: introduce UFSHCI_QUIRK_SKIP_INTR_AGGR quirk
Date: Tue, 08 Nov 2016 11:56:40 -0800
Message-ID: <d8123bcfe400777db2b5745a2d2b3d8d@codeaurora.org>
References: <002401d23996$1986d4b0$4c947e10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40552 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753542AbcKHT4l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 14:56:41 -0500
In-Reply-To: <002401d23996$1986d4b0$4c947e10$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com, =?UTF-8?Q?=EC=B6=94=ED=97=8C=EA=B4=91?= <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-07 23:59, Kiwoong Kim wrote:
> If UFS driver resets interrupt aggregation timer and counter
> when there is a pending doorbell, an interrupt of IO completion
> of a corresponding task may be missed.
> That would cause a command timeout.
> 
> If UFS driver resets interrupt aggregation timer and counter
> when there is a pending doorbell, a competion interrupt
> of a corresponing task may be issued.
> That would casue a command timeout.
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 +++-
>  drivers/scsi/ufs/ufshcd.h | 1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c904854..65bbf59 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3730,7 +3730,9 @@ static void ufshcd_transfer_req_compl(struct 
> ufs_hba *hba)
>  	 * false interrupt if device completes another request after 
> resetting
>  	 * aggregation and before reading the DB.
>  	 */
> -	if (ufshcd_is_intr_aggr_allowed(hba))
> +	if ((ufshcd_is_intr_aggr_allowed(hba))
> +		&& !(hba->quirks & UFSHCI_QUIRK_SKIP_INTR_AGGR))

Why do we need this new quirk? If controller has the issue with 
interrupt aggregation, you can remove this UFSHCD_CAP_INTR_AGGR to 
disable the aggregation altogether.

> +		ufshcd_reset_intr_aggr(hba);
>  		ufshcd_reset_intr_aggr(hba);
> 
>  	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 6a96f24..6a9c6e9 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -497,6 +497,7 @@ struct ufs_hba {
>  	#define UFSHCD_QUIRK_BROKEN_DWORD_UTRD                  UFS_BIT(7)
>  	#define UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR                UFS_BIT(8)
>  	#define UFSHCD_QUIRK_USE_OF_HCE				UFS_BIT(9)
> +	#define UFSHCI_QUIRK_SKIP_INTR_AGGR			UFS_BIT(10)
> 
> 
>  	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
