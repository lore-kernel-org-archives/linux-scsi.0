From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2] ufs: introduce UFSHCD_QUIRK_BROKEN_HCE quirk
Date: Tue, 15 Nov 2016 10:29:48 -0800
Message-ID: <b33b185fa384464774ad843abbfbd74d@codeaurora.org>
References: <00ea01d23f2e$b631acc0$22950640$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbcKOS3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 13:29:49 -0500
In-Reply-To: <00ea01d23f2e$b631acc0$22950640$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-15 02:55, Kiwoong Kim wrote:
> Some UFS host controllers might not be able to
> reset UIC by setting HCE to 1.
> Those controllers should invoke 'DME reset' and 'DME enable'
> in order instead.
> 
> V2

As Martin mentioned in other email, please separate this version history 
from commit text with line having "----" before the start of version 
history.
Rest all looks good but i will wait for updated patch fixing above 
before giving Reviewed-By.

> - modify the commit message
> - change the name of the quirk
> (s/UFSHCD_QUIRK_USE_OF_HCE/UFSHCD_QUIRK_BROKEN_HCE)
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 44 
> +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/ufs/ufshcd.h |  7 +++++++
>  2 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c9cf011..8aac98f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2477,6 +2477,37 @@ static inline void
> ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
>  	usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
>  }
> 
> +static int ufshcd_dme_reset(struct ufs_hba *hba)
> +{
> +	struct uic_command uic_cmd = {0};
> +	int ret;
> +
> +	uic_cmd.command = UIC_CMD_DME_RESET;
> +	uic_cmd.argument1 = 0x1;
> +
> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +	if (ret)
> +		dev_err(hba->dev,
> +			"dme-reset: error code %d\n", ret);
> +
> +	return ret;
> +}
> +
> +static int ufshcd_dme_enable(struct ufs_hba *hba)
> +{
> +	struct uic_command uic_cmd = {0};
> +	int ret;
> +
> +	uic_cmd.command = UIC_CMD_DME_ENABLE;
> +
> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +	if (ret)
> +		dev_err(hba->dev,
> +			"dme-enable: error code %d\n", ret);
> +
> +	return ret;
> +}
> +
>  /**
>   * ufshcd_dme_set_attr - UIC command for DME_SET, DME_PEER_SET
>   * @hba: per adapter instance
> @@ -3084,6 +3115,7 @@ static inline void ufshcd_hba_stop(struct
> ufs_hba *hba, bool can_sleep)
>  static int ufshcd_hba_enable(struct ufs_hba *hba)
>  {
>  	int retry;
> +	int ret = 0;
> 
>  	/*
>  	 * msleep of 1 and 5 used in this function might result in 
> msleep(20),
> @@ -3100,6 +3132,9 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
> 
>  	ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
> 
> +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_HCE)
> +		goto use_dme;
> +
>  	/* start controller initialization sequence */
>  	ufshcd_hba_start(hba);
> 
> @@ -3128,12 +3163,19 @@ static int ufshcd_hba_enable(struct ufs_hba 
> *hba)
>  		msleep(5);
>  	}
> 
> +use_dme:
>  	/* enable UIC related interrupts */
>  	ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
> 
> +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_HCE) {
> +		ret = ufshcd_dme_reset(hba);
> +		if (!ret)
> +			ret = ufshcd_dme_enable(hba);
> +	}
> +
>  	ufshcd_vops_hce_enable_notify(hba, POST_CHANGE);
> 
> -	return 0;
> +	return ret;
>  }
> 
>  static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 9838598..dfa17ac 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -498,6 +498,13 @@ struct ufs_hba {
>  	 */
>  	#define UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR                UFS_BIT(8)
> 
> +	/*
> +	 * This quirk needs to be enabled if the host contoller can't reset
> +	 * UIC by setting HCE to 1. Those controllers should invoke
> +	 * DME reset and DME enable in order.
> +	 */
> +	#define UFSHCD_QUIRK_BROKEN_HCE				UFS_BIT(9)
> +
>  	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
> 
>  	/* Device deviations from standard UFS device spec. */

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
