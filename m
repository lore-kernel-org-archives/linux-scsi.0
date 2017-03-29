From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] Revert "scsi: ufs: add queries retry mechanism"
Date: Tue, 28 Mar 2017 21:53:00 -0700
Message-ID: <bab7a3bfd7a6e9a91a224368d569854d@codeaurora.org>
References: <1490688677-30810-1-git-send-email-szymonx.mielczarek@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39464 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbdC2ExC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 00:53:02 -0400
In-Reply-To: <1490688677-30810-1-git-send-email-szymonx.mielczarek@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Szymon@codeaurora.org, Mielczarek@codeaurora.org, szymonx.mielczarek@intel.com
Cc: linux-scsi@vger.kernel.org

On 2017-03-28 01:11, Szymon@codeaurora.org wrote:
> From: Szymon Mielczarek <szymonx.mielczarek@intel.com>
> 
> This reverts commit 61e073590b82a539654626ecae91b8fab11db3f3.
> 
> The patch introduced redundant query retries as we already had such
> mechanism provided with _retry functions.
> Both ufshcd_read_desc and ufshcd_read_unit_desc_param functions
> call ufshcd_query_descriptor_retry wrapper.
> 
> Signed-off-by: Szymon Mielczarek <szymonx.mielczarek@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 54 
> ++++++++---------------------------------------
>  1 file changed, 9 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 096e95b..3dddd13 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3103,18 +3103,7 @@ static inline int ufshcd_read_power_desc(struct
> ufs_hba *hba,
>  					 u8 *buf,
>  					 u32 size)
>  {
> -	int err = 0;
> -	int retries;
> -
> -	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
> -		/* Read descriptor*/
> -		err = ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
> -		if (!err)
> -			break;
> -		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
> -	}
> -
> -	return err;
> +	return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
>  }
> 
>  static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 
> size)
> @@ -4272,24 +4261,16 @@ static void ufshcd_set_queue_depth(struct
> scsi_device *sdev)
>  {
>  	int ret = 0;
>  	u8 lun_qdepth;
> -	int retries;
>  	struct ufs_hba *hba;
> 
>  	hba = shost_priv(sdev->host);
> 
>  	lun_qdepth = hba->nutrs;
> -	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
> -		/* Read descriptor*/
> -		ret = ufshcd_read_unit_desc_param(hba,
> -				  ufshcd_scsi_to_upiu_lun(sdev->lun),
> -				  UNIT_DESC_PARAM_LU_Q_DEPTH,
> -				  &lun_qdepth,
> -				  sizeof(lun_qdepth));
> -		if (!ret || ret == -ENOTSUPP)
> -			break;
> -
> -		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, ret);
> -	}
> +	ret = ufshcd_read_unit_desc_param(hba,
> +					  ufshcd_scsi_to_upiu_lun(sdev->lun),
> +					  UNIT_DESC_PARAM_LU_Q_DEPTH,
> +					  &lun_qdepth,
> +					  sizeof(lun_qdepth));
> 
>  	/* Some WLUN doesn't support unit descriptor */
>  	if (ret == -EOPNOTSUPP)
> @@ -5960,24 +5941,6 @@ static u32
> ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
>  	return icc_level;
>  }
> 
> -static int ufshcd_set_icc_levels_attr(struct ufs_hba *hba, u32 
> icc_level)
> -{
> -	int ret = 0;
> -	int retries;
> -
> -	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
> -		/* write attribute */
> -		ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> -			QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0, &icc_level);
> -		if (!ret)
> -			break;
> -
> -		dev_dbg(hba->dev, "%s: failed with error %d\n", __func__, ret);
> -	}
> -
> -	return ret;
> -}
> -
>  static void ufshcd_init_icc_levels(struct ufs_hba *hba)
>  {
>  	int ret;
> @@ -5998,8 +5961,9 @@ static void ufshcd_init_icc_levels(struct ufs_hba 
> *hba)
>  	dev_dbg(hba->dev, "%s: setting icc_level 0x%x",
>  			__func__, hba->init_prefetch_data.icc_level);
> 
> -	ret = ufshcd_set_icc_levels_attr(hba,
> -				 hba->init_prefetch_data.icc_level);
> +	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
> +		&hba->init_prefetch_data.icc_level);
> 
>  	if (ret)
>  		dev_err(hba->dev,

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
