From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 2/4] scsi: ufs: add quirk not to allow reset of interrupt
 aggregation
Date: Wed, 16 May 2018 14:24:24 -0700
Message-ID: <4b8de89ece0390be3d5e8473e2ab08b7@codeaurora.org>
References: <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com>
 <CGME20180506102639epcas2p13ac44966a64e539f611ccdc2479e1abb@epcas2p1.samsung.com>
 <1525601658-31989-3-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525601658-31989-3-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, vivek.gautam@codeaurora.org, vinholikatti@gmail.com, olof@lixom.net, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-05-06 03:14, Alim Akhtar wrote:
> Some host controller supports interrupt aggregation, but doesn't
> allow to reset counter and timer by s/w.
> 
> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  drivers/scsi/ufs/ufshcd.h | 6 ++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9898ce5..253257c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4695,7 +4695,8 @@ static void ufshcd_transfer_req_compl(struct 
> ufs_hba *hba)
>  	 * false interrupt if device completes another request after 
> resetting
>  	 * aggregation and before reading the DB.
>  	 */
> -	if (ufshcd_is_intr_aggr_allowed(hba))
> +	if (ufshcd_is_intr_aggr_allowed(hba) &&
> +	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
>  		ufshcd_reset_intr_aggr(hba);
> 
>  	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 43035f8..5c91ff1 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -600,6 +600,12 @@ struct ufs_hba {
>  	 */
>  	#define UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		0x100
> 
> +	/*
> +	 * This quirk needs to be enabled if host controller doesn't allow
> +	 * that the interrupt aggregation timer and counter are reset by s/w.
> +	 */
> +	#define UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		0x200
> +
>  	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
> 
>  	/* Device deviations from standard UFS device spec. */

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
