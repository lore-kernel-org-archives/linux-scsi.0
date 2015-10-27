From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v5 15/15] scsi: ufs: add wrapper for retrying sending
 query attribute
Date: Tue, 27 Oct 2015 15:00:30 -0000
Message-ID: <11a50cbba7edb5332644f9937c2f1f82.squirrel@www.codeaurora.org>
References: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
    <1445942657-6293-16-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445942657-6293-16-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>

> Sometimes queries from the device might return a failure so it is
> recommended to retry sending the query, before giving up.
> This change adds a wrapper to retry sending a query attribute,
> in cases where we need to wait longer, before we continue,
> or before reporting a failure.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 51
> ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 44 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ec90504..1d1e681 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1824,6 +1824,43 @@ out:
>  }
>
>  /**
> + * ufshcd_query_attr_retry() - API function for sending query
> + * attribute with retries
> + * @hba: per-adapter instance
> + * @opcode: attribute opcode
> + * @idn: attribute idn to access
> + * @index: index field
> + * @selector: selector field
> + * @attr_val: the attribute value after the query request
> + * completes
> + *
> + * Returns 0 for success, non-zero in case of failure
> +*/
> +static int ufshcd_query_attr_retry(struct ufs_hba *hba,
> +	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
> +	u32 *attr_val)
> +{
> +	int ret = 0;
> +	u32 retries;
> +
> +	 for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
> +		ret = ufshcd_query_attr(hba, opcode, idn, index,
> +						selector, attr_val);
> +		if (ret)
> +			dev_dbg(hba->dev, "%s: failed with error %d, retries %d\n",
> +				__func__, ret, retries);
> +		else
> +			break;
> +	}
> +
> +	if (ret)
> +		dev_err(hba->dev,
> +			"%s: query attribute, idn %d, failed with error %d after %d
> retires\n",
> +			__func__, idn, ret, QUERY_REQ_RETRIES);
> +	return ret;
> +}
> +
> +/**
>   * ufshcd_query_descriptor - API function for sending descriptor requests
>   * hba: per-adapter instance
>   * opcode: attribute opcode
> @@ -3404,7 +3441,7 @@ static int ufshcd_disable_ee(struct ufs_hba *hba,
> u16 mask)
>
>  	val = hba->ee_ctrl_mask & ~mask;
>  	val &= 0xFFFF; /* 2 bytes */
> -	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>  			QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
>  	if (!err)
>  		hba->ee_ctrl_mask &= ~mask;
> @@ -3432,7 +3469,7 @@ static int ufshcd_enable_ee(struct ufs_hba *hba, u16
> mask)
>
>  	val = hba->ee_ctrl_mask | mask;
>  	val &= 0xFFFF; /* 2 bytes */
> -	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>  			QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
>  	if (!err)
>  		hba->ee_ctrl_mask |= mask;
> @@ -3538,7 +3575,7 @@ static void  ufshcd_force_reset_auto_bkops(struct
> ufs_hba *hba)
>
>  static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32
> *status)
>  {
> -	return ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>  			QUERY_ATTR_IDN_BKOPS_STATUS, 0, 0, status);
>  }
>
> @@ -3601,7 +3638,7 @@ static int ufshcd_urgent_bkops(struct ufs_hba *hba)
>
>  static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32 *status)
>  {
> -	return ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>  			QUERY_ATTR_IDN_EE_STATUS, 0, 0, status);
>  }
>
> @@ -4355,9 +4392,9 @@ static void ufshcd_init_icc_levels(struct ufs_hba
> *hba)
>  	dev_dbg(hba->dev, "%s: setting icc_level 0x%x",
>  			__func__, hba->init_prefetch_data.icc_level);
>
> -	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> -			QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
> -			&hba->init_prefetch_data.icc_level);
> +	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
> +		&hba->init_prefetch_data.icc_level);
>
>  	if (ret)
>  		dev_err(hba->dev,
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
