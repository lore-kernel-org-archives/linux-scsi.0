From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v1] ufs: introduce UFSHCD_QUIRK_USE_OF_HCE quirk
Date: Tue, 08 Nov 2016 11:50:05 -0800
Message-ID: <2c77bb07cb872130fb55c555391f8080@codeaurora.org>
References: <002301d23995$c3be88c0$4b3b9a40$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38580 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbcKHTuH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 14:50:07 -0500
In-Reply-To: <002301d23995$c3be88c0$4b3b9a40$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com, =?UTF-8?Q?=EC=B6=94=ED=97=8C=EA=B4=91?= <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-07 23:57, Kiwoong Kim wrote:
> Some host controller might not initialize itself
> by setting "Host Controller Enable" to 1.

> They should do this to reset UIC.

I am not sure if i understood this statment. can you give more details?

> In such cases, 'DME reset' and 'DME enable' are required
> for normal subsequent operations.

This means HCE implementation is broken, you should name the quirk as 
UFSHCD_QUIRK_BROKEN_HCE .

> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 44 
> +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/ufs/ufshcd.h |  1 +
>  2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 24d6ea7..c904854 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2496,6 +2496,37 @@ static inline void
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

This error message doesn't say which DME command failed, do you want to 
add that?

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

This error message doesn't say which DME command failed, do you want to 
add that?

> +
> +	return ret;
> +}
> +
>  /**
>   * ufshcd_dme_set_attr - UIC command for DME_SET, DME_PEER_SET
>   * @hba: per adapter instance
> @@ -3101,6 +3132,7 @@ static inline void ufshcd_hba_stop(struct
> ufs_hba *hba, bool can_sleep)
>  static int ufshcd_hba_enable(struct ufs_hba *hba)
>  {
>  	int retry;
> +	int ret = 0;
> 
>  	/*
>  	 * msleep of 1 and 5 used in this function might result in 
> msleep(20),
> @@ -3117,6 +3149,9 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
> 
>  	ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
> 
> +	if (hba->quirks & UFSHCD_QUIRK_USE_OF_HCE)
> +		goto use_dme;
> +
>  	/* start controller initialization sequence */
>  	ufshcd_hba_start(hba);
> 
> @@ -3145,12 +3180,19 @@ static int ufshcd_hba_enable(struct ufs_hba 
> *hba)
>  		msleep(5);
>  	}
> 
> +use_dme:
>  	/* enable UIC related interrupts */
>  	ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
> 
> +	if (hba->quirks & UFSHCD_QUIRK_USE_OF_HCE) {
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
> index c4abd76..6a96f24 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -496,6 +496,7 @@ struct ufs_hba {
>  	#define UFSHCD_QUIRK_GET_VS_RESULT			UFS_BIT(6)
>  	#define UFSHCD_QUIRK_BROKEN_DWORD_UTRD                  UFS_BIT(7)
>  	#define UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR                UFS_BIT(8)
> +	#define UFSHCD_QUIRK_USE_OF_HCE				UFS_BIT(9)
> 
> 
>  	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
