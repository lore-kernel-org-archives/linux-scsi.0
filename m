From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [scsi 2/4] scsi: ufs: unexport descritpor reading functions
Date: Tue, 10 Jan 2017 16:55:29 -0800
Message-ID: <57254b37bdcd7ec94874351355ec9116@codeaurora.org>
References: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
 <1483605912-15041-2-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483605912-15041-2-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-01-05 00:45, Tomas Winkler wrote:
> Unexport ufshcd_read_device_desc and ufshcd_read_string_desc
> there is no really possibility to calling them directly
> outside of UFS context.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 ++++-----
>  drivers/scsi/ufs/ufshcd.h | 7 -------
>  2 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index be3c2900b6bb..63d7ae2c3be9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2208,11 +2208,10 @@ static inline int
> ufshcd_read_power_desc(struct ufs_hba *hba,
>  	return err;
>  }
> 
> -int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
> +static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 
> size)
>  {
>  	return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
>  }
> -EXPORT_SYMBOL(ufshcd_read_device_desc);
> 
>  /**
>   * ufshcd_read_string_desc - read string descriptor
> @@ -2224,8 +2223,9 @@ EXPORT_SYMBOL(ufshcd_read_device_desc);
>   *
>   * Return 0 in case of success, non-zero otherwise
>   */
> -int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8 
> *buf,
> -				u32 size, bool ascii)
> +#define ASCII_STD true
> +static int ufshcd_read_string_desc(struct ufs_hba *hba, int 
> desc_index,
> +				   u8 *buf, u32 size, bool ascii)
>  {
>  	int err = 0;
> 
> @@ -2281,7 +2281,6 @@ int ufshcd_read_string_desc(struct ufs_hba *hba,
> int desc_index, u8 *buf,
>  out:
>  	return err;
>  }
> -EXPORT_SYMBOL(ufshcd_read_string_desc);
> 
>  /**
>   * ufshcd_read_unit_desc_param - read the specified unit descriptor 
> parameter
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 08cd26ed2382..00fb82589895 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -713,8 +713,6 @@ static inline int ufshcd_dme_peer_get(struct 
> ufs_hba *hba,
>  	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
>  }
> 
> -int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size);
> -
>  static inline bool ufshcd_is_hs_mode(struct ufs_pa_layer_attr 
> *pwr_info)
>  {
>  	return (pwr_info->pwr_rx == FAST_MODE ||
> @@ -723,11 +721,6 @@ static inline bool ufshcd_is_hs_mode(struct
> ufs_pa_layer_attr *pwr_info)
>  		pwr_info->pwr_tx == FASTAUTO_MODE);
>  }
> 
> -#define ASCII_STD true
> -
> -int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8 
> *buf,
> -				u32 size, bool ascii);
> -
>  /* Expose Query-Request API */
>  int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
>  	enum flag_idn idn, bool *flag_res);

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
