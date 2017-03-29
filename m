From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 1/6] scsi: ufs: make
 ufshcd_is_{device_present,hba_active}() return bool
Date: Tue, 28 Mar 2017 21:59:55 -0700
Message-ID: <42401dd05e12b83079f642fd32556be1@codeaurora.org>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752258AbdC2E76 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 00:59:58 -0400
In-Reply-To: <20170328134929.25599-1-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kusumi.tomohiro@gmail.com
Cc: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>, linux-scsi-owner@vger.kernel.org

On 2017-03-28 06:49, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> ufshcd driver generally uses bool for is_xxx type things instead of 
> int,
> so conform to its style.
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b7e5128..b006f1e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -585,12 +585,12 @@ static inline u32 ufshcd_get_ufs_version(struct
> ufs_hba *hba)
>   *			      the host controller
>   * @hba: pointer to adapter instance
>   *
> - * Returns 1 if device present, 0 if no device detected
> + * Returns true if device present, false if no device detected
>   */
> -static inline int ufshcd_is_device_present(struct ufs_hba *hba)
> +static inline bool ufshcd_is_device_present(struct ufs_hba *hba)
>  {
>  	return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
> -						DEVICE_PRESENT) ? 1 : 0;
> +						DEVICE_PRESENT) ? true : false;
>  }
> 
>  /**
> @@ -832,11 +832,11 @@ static inline void ufshcd_hba_start(struct 
> ufs_hba *hba)
>   * ufshcd_is_hba_active - Get controller state
>   * @hba: per adapter instance
>   *
> - * Returns zero if controller is active, 1 otherwise
> + * Returns false if controller is active, true otherwise
>   */
> -static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
> +static inline bool ufshcd_is_hba_active(struct ufs_hba *hba)
>  {
> -	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
> +	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? false : 
> true;
>  }
> 
>  static const char *ufschd_uic_link_state_to_string(

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
