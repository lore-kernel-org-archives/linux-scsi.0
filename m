From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 1/2] scsi: ufs: use MASK_EE_STATUS
Date: Wed, 26 Apr 2017 09:39:29 -0700
Message-ID: <efd9c0c63e54d7be381b09d2da5fa9ed@codeaurora.org>
References: <20170420120145.7035-1-tkusumi@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43038 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbdDZQja (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 12:39:30 -0400
In-Reply-To: <20170420120145.7035-1-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kusumi.tomohiro@gmail.com
Cc: vinholikatti@gmail.com, linux-scsi@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>

On 2017-04-20 05:01, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> MASK_EE_STATUS added by 66ec6d59 was unused, but it seems to have been
> defined to do this.
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 096e95b..9278666 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4717,7 +4717,7 @@ static int ufshcd_disable_ee(struct ufs_hba
> *hba, u16 mask)
>  		goto out;
> 
>  	val = hba->ee_ctrl_mask & ~mask;
> -	val &= 0xFFFF; /* 2 bytes */
> +	val &= MASK_EE_STATUS;
>  	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>  			QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
>  	if (!err)
> @@ -4745,7 +4745,7 @@ static int ufshcd_enable_ee(struct ufs_hba *hba, 
> u16 mask)
>  		goto out;
> 
>  	val = hba->ee_ctrl_mask | mask;
> -	val &= 0xFFFF; /* 2 bytes */
> +	val &= MASK_EE_STATUS;
>  	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>  			QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
>  	if (!err)

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
