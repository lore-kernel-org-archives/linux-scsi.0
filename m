From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: Factor out ufshcd_read_desc_param
Date: Wed, 22 Feb 2017 15:23:03 -0800
Message-ID: <42f53def90abe3a0722a5746702b99f8@codeaurora.org>
References: <C8BF859FC3044844854B2CBA1ED115C11B0163@HASMSX106.ger.corp.intel.com>
 <C8BF859FC3044844854B2CBA1ED115C11B053C@HASMSX106.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46660 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932393AbdBVXZB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 18:25:01 -0500
In-Reply-To: <C8BF859FC3044844854B2CBA1ED115C11B053C@HASMSX106.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Potomski, MichalX" <michalx.potomski@intel.com>
Cc: "'vinholikatti@gmail.com'" <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Janca, Grzegorz" <grzegorz.janca@intel.com>, "Mielczarek, SzymonX" <szymonx.mielczarek@intel.com>, linux-scsi-owner@vger.kernel.org

On 2017-02-20 23:36, Potomski, MichalX wrote:
> Since in UFS 2.1 specification some of the descriptor
> lengths differs from 2.0 specification and some devices,
> which are reporting spec version 2.0 have different
> descriptor lengths we can not rely on hardcoded values
> taken from 2.0 specification. This patch introduces
> reading these lengths per each device from descriptor
> headers at probe time to ensure their correctness.
> 
> Signed-off-by: Michal' Potomski <michalx.potomski@intel.com>
> ---
>  drivers/scsi/ufs/ufs.h    |  22 ++---
>  drivers/scsi/ufs/ufshcd.c | 230 
> ++++++++++++++++++++++++++++++++++------------
>  drivers/scsi/ufs/ufshcd.h |  15 +++
>  3 files changed, 195 insertions(+), 72 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 8e6709a..9e1b1a8 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -146,7 +146,7 @@ enum attr_idn {
>  /* Descriptor idn for Query requests */
>  enum desc_idn {
>  	QUERY_DESC_IDN_DEVICE		= 0x0,
> -	QUERY_DESC_IDN_CONFIGURAION	= 0x1,
> +	QUERY_DESC_IDN_CONFIGURATION	= 0x1,
>  	QUERY_DESC_IDN_UNIT		= 0x2,
>  	QUERY_DESC_IDN_RFU_0		= 0x3,
>  	QUERY_DESC_IDN_INTERCONNECT	= 0x4,
> @@ -162,19 +162,13 @@ enum desc_header_offset {
>  	QUERY_DESC_DESC_TYPE_OFFSET	= 0x01,
>  };
> 
> -enum ufs_desc_max_size {
> -	QUERY_DESC_DEVICE_MAX_SIZE		= 0x40,
> -	QUERY_DESC_CONFIGURAION_MAX_SIZE	= 0x90,
> -	QUERY_DESC_UNIT_MAX_SIZE		= 0x23,
> -	QUERY_DESC_INTERCONNECT_MAX_SIZE	= 0x06,
> -	/*
> -	 * Max. 126 UNICODE characters (2 bytes per character) plus 2 bytes
> -	 * of descriptor header.
> -	 */
> -	QUERY_DESC_STRING_MAX_SIZE		= 0xFE,
> -	QUERY_DESC_GEOMETRY_MAX_SIZE		= 0x44,
> -	QUERY_DESC_POWER_MAX_SIZE		= 0x62,
> -	QUERY_DESC_RFU_MAX_SIZE			= 0x00,
> +enum ufs_desc_def_size {
> +	QUERY_DESC_DEVICE_DEF_SIZE		= 0x40,
> +	QUERY_DESC_CONFIGURATION_DEF_SIZE	= 0x90,
> +	QUERY_DESC_UNIT_DEF_SIZE		= 0x23,
> +	QUERY_DESC_INTERCONNECT_DEF_SIZE	= 0x06,
> +	QUERY_DESC_GEOMETRY_DEF_SIZE		= 0x44,
> +	QUERY_DESC_POWER_DEF_SIZE		= 0x62,
>  };
> 
>  /* Unit descriptor parameters offsets in bytes*/
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 20e5e5f..79d5055 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -94,19 +94,6 @@
>  		_ret;                                                   \
>  	})
> 
> -static u32 ufs_query_desc_max_size[] = {
> -	QUERY_DESC_DEVICE_MAX_SIZE,
> -	QUERY_DESC_CONFIGURAION_MAX_SIZE,
> -	QUERY_DESC_UNIT_MAX_SIZE,
> -	QUERY_DESC_RFU_MAX_SIZE,
> -	QUERY_DESC_INTERCONNECT_MAX_SIZE,
> -	QUERY_DESC_STRING_MAX_SIZE,
> -	QUERY_DESC_RFU_MAX_SIZE,
> -	QUERY_DESC_GEOMETRY_MAX_SIZE,
> -	QUERY_DESC_POWER_MAX_SIZE,
> -	QUERY_DESC_RFU_MAX_SIZE,
> -};
> -
>  enum {
>  	UFSHCD_MAX_CHANNEL	= 0,
>  	UFSHCD_MAX_ID		= 1,
> @@ -2012,7 +1999,7 @@ static int __ufshcd_query_descriptor(struct 
> ufs_hba *hba,
>  		goto out;
>  	}
> 
> -	if (*buf_len <= QUERY_DESC_MIN_SIZE || *buf_len > 
> QUERY_DESC_MAX_SIZE) {
> +	if (*buf_len < QUERY_DESC_MIN_SIZE || *buf_len > QUERY_DESC_MAX_SIZE) 
> {
>  		dev_err(hba->dev, "%s: descriptor buffer size (%d) is out of 
> range\n",
>  				__func__, *buf_len);
>  		err = -EINVAL;
> @@ -2092,6 +2079,92 @@ int ufshcd_query_descriptor_retry(struct ufs_hba 
> *hba,
>  EXPORT_SYMBOL(ufshcd_query_descriptor_retry);
> 
>  /**
> + * ufshcd_read_desc_length - read the specified descriptor length from 
> header
> + * @hba: Pointer to adapter instance
> + * @desc_id: descriptor idn value
> + * @desc_index: descriptor index
> + * @desc_length: pointer to variable to read the length of descriptor
> + *
> + * Return 0 in case of success, non-zero otherwise
> + */
> +static int ufshcd_read_desc_length(struct ufs_hba *hba,
> +	enum desc_idn desc_id,
> +	int desc_index,
> +	int *desc_length)
> +{
> +	int ret;
> +	u8 header[QUERY_DESC_HDR_SIZE];
> +	int header_len = QUERY_DESC_HDR_SIZE;
> +
> +	if (desc_id >= QUERY_DESC_IDN_MAX)
> +		return -EINVAL;
> +
> +	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
> +					desc_id, desc_index, 0, header,
> +					&header_len);
> +
> +	if (ret) {
> +		dev_err(hba->dev, "%s: Failed to get descriptor header id %d",
> +			__func__, desc_id);
> +		return ret;
> +	} else if (desc_id != header[QUERY_DESC_DESC_TYPE_OFFSET]) {
> +		dev_warn(hba->dev, "%s: descriptor header id %d and desc_id %d 
> mismatch",
> +			__func__, header[QUERY_DESC_DESC_TYPE_OFFSET],
> +			desc_id);
> +		ret = -EINVAL;
> +	}
> +
> +	*desc_length = header[QUERY_DESC_LENGTH_OFFSET];
> +	return ret;
> +
> +}
> +
> +/**
> + * ufshcd_map_desc_id_to_length - map descriptor IDN to its length
> + * @hba: Pointer to adapter instance
> + * @desc_id: descriptor idn value
> + * @desc_len: mapped desc length (out)
> + *
> + * Return 0 in case of success, non-zero otherwise
> + */
> +int ufshcd_map_desc_id_to_length(struct ufs_hba *hba,
> +	enum desc_idn desc_id, int *desc_len)
> +{
> +	switch (desc_id) {
> +	case QUERY_DESC_IDN_DEVICE:
> +		*desc_len = hba->desc_size.dev_desc;
> +		break;
> +	case QUERY_DESC_IDN_POWER:
> +		*desc_len = hba->desc_size.pwr_desc;
> +		break;
> +	case QUERY_DESC_IDN_GEOMETRY:
> +		*desc_len = hba->desc_size.geom_desc;
> +		break;
> +	case QUERY_DESC_IDN_CONFIGURATION:
> +		*desc_len = hba->desc_size.conf_desc;
> +		break;
> +	case QUERY_DESC_IDN_UNIT:
> +		*desc_len = hba->desc_size.unit_desc;
> +		break;
> +	case QUERY_DESC_IDN_INTERCONNECT:
> +		*desc_len = hba->desc_size.interc_desc;
> +		break;
> +	case QUERY_DESC_IDN_STRING:
> +		*desc_len = QUERY_DESC_MAX_SIZE;
> +		break;
> +	case QUERY_DESC_IDN_RFU_0:
> +	case QUERY_DESC_IDN_RFU_1:
> +		*desc_len = 0;
> +		break;
> +	default:
> +		*desc_len = 0;
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
> +
> +/**
>   * ufshcd_read_desc_param - read the specified descriptor parameter
>   * @hba: Pointer to adapter instance
>   * @desc_id: descriptor idn value
> @@ -2105,42 +2178,49 @@ int ufshcd_query_descriptor_retry(struct 
> ufs_hba *hba,
>  static int ufshcd_read_desc_param(struct ufs_hba *hba,
>  				  enum desc_idn desc_id,
>  				  int desc_index,
> -				  u32 param_offset,
> +				  u8 param_offset,
>  				  u8 *param_read_buf,
> -				  u32 param_size)
> +				  u8 param_size)
>  {
>  	int ret;
>  	u8 *desc_buf;
> -	u32 buff_len;
> +	int buff_len;
>  	bool is_kmalloc = true;
> 
> -	/* safety checks */
> -	if (desc_id >= QUERY_DESC_IDN_MAX)
> +	/* Safety check */
> +	if (desc_id >= QUERY_DESC_IDN_MAX || !param_size)
>  		return -EINVAL;
> 
> -	buff_len = ufs_query_desc_max_size[desc_id];
> -	if ((param_offset + param_size) > buff_len)
> -		return -EINVAL;
> +	/* Get the max length of descriptor from structure filled up at probe
> +	 * time.
> +	 */
> +	ret = ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
> 
> -	if (!param_offset && (param_size == buff_len)) {
> -		/* memory space already available to hold full descriptor */
> -		desc_buf = param_read_buf;
> -		is_kmalloc = false;
> -	} else {
> -		/* allocate memory to hold full descriptor */
> +	/* Sanity checks */
> +	if (ret || !buff_len) {
> +		dev_err(hba->dev, "%s: Failed to get full descriptor length",
> +			__func__);
> +		return ret;
> +	}
> +
> +	/* Check whether we need temp memory */
> +	if (param_offset != 0 || param_size < buff_len) {
>  		desc_buf = kmalloc(buff_len, GFP_KERNEL);
>  		if (!desc_buf)
>  			return -ENOMEM;
> +	} else {
> +		desc_buf = param_read_buf;
> +		is_kmalloc = false;
>  	}
> 
> +	/* Request for full descriptor */
>  	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
> -					desc_id, desc_index, 0, desc_buf,
> -					&buff_len);
> +					desc_id, desc_index, 0,
> +					desc_buf, &buff_len);
> 
>  	if (ret) {
>  		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d,
> desc_index %d, param_offset %d, ret %d",
>  			__func__, desc_id, desc_index, param_offset, ret);
> -
>  		goto out;
>  	}
> 
> @@ -2152,25 +2232,9 @@ static int ufshcd_read_desc_param(struct ufs_hba 
> *hba,
>  		goto out;
>  	}
> 
> -	/*
> -	 * While reading variable size descriptors (like string descriptor),
> -	 * some UFS devices may report the "LENGTH" (field in "Transaction
> -	 * Specific fields" of Query Response UPIU) same as what was 
> requested
> -	 * in Query Request UPIU instead of reporting the actual size of the
> -	 * variable size descriptor.
> -	 * Although it's safe to ignore the "LENGTH" field for variable size
> -	 * descriptors as we can always derive the length of the descriptor 
> from
> -	 * the descriptor header fields. Hence this change impose the length
> -	 * match check only for fixed size descriptors (for which we always
> -	 * request the correct size as part of Query Request UPIU).
> -	 */
> -	if ((desc_id != QUERY_DESC_IDN_STRING) &&
> -	    (buff_len != desc_buf[QUERY_DESC_LENGTH_OFFSET])) {
> -		dev_err(hba->dev, "%s: desc_buf length mismatch: buff_len %d,
> buff_len(desc_header) %d",
> -			__func__, buff_len, desc_buf[QUERY_DESC_LENGTH_OFFSET]);
> -		ret = -EINVAL;
> -		goto out;
> -	}
> +	/* Check wherher we will not copy more data, than available */
> +	if (is_kmalloc && param_size > buff_len)
> +		param_size = buff_len;
> 
>  	if (is_kmalloc)
>  		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
> @@ -4915,8 +4979,8 @@ static int ufshcd_set_icc_levels_attr(struct
> ufs_hba *hba, u32 icc_level)
>  static void ufshcd_init_icc_levels(struct ufs_hba *hba)
>  {
>  	int ret;
> -	int buff_len = QUERY_DESC_POWER_MAX_SIZE;
> -	u8 desc_buf[QUERY_DESC_POWER_MAX_SIZE];
> +	int buff_len = hba->desc_size.pwr_desc;
> +	u8 desc_buf[buff_len];
> 
>  	ret = ufshcd_read_power_desc(hba, desc_buf, buff_len);
>  	if (ret) {
> @@ -5013,11 +5077,10 @@ static int ufs_get_device_info(struct ufs_hba 
> *hba,
>  {
>  	int err;
>  	u8 model_index;
> -	u8 str_desc_buf[QUERY_DESC_STRING_MAX_SIZE + 1] = {0};
> -	u8 desc_buf[QUERY_DESC_DEVICE_MAX_SIZE];
> +	u8 str_desc_buf[QUERY_DESC_MAX_SIZE + 1] = {0};
> +	u8 desc_buf[hba->desc_size.dev_desc];
> 
> -	err = ufshcd_read_device_desc(hba, desc_buf,
> -					QUERY_DESC_DEVICE_MAX_SIZE);
> +	err = ufshcd_read_device_desc(hba, desc_buf, 
> hba->desc_size.dev_desc);
>  	if (err) {
>  		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
>  			__func__, err);
> @@ -5034,14 +5097,14 @@ static int ufs_get_device_info(struct ufs_hba 
> *hba,
>  	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
> 
>  	err = ufshcd_read_string_desc(hba, model_index, str_desc_buf,
> -					QUERY_DESC_STRING_MAX_SIZE, ASCII_STD);
> +				QUERY_DESC_MAX_SIZE, ASCII_STD);
>  	if (err) {
>  		dev_err(hba->dev, "%s: Failed reading Product Name. err = %d\n",
>  			__func__, err);
>  		goto out;
>  	}
> 
> -	str_desc_buf[QUERY_DESC_STRING_MAX_SIZE] = '\0';
> +	str_desc_buf[QUERY_DESC_MAX_SIZE] = '\0';
>  	strlcpy(card_data->model, (str_desc_buf + QUERY_DESC_HDR_SIZE),
>  		min_t(u8, str_desc_buf[QUERY_DESC_LENGTH_OFFSET],
>  		      MAX_MODEL_LEN));
> @@ -5241,6 +5304,50 @@ static void ufshcd_tune_unipro_params(struct
> ufs_hba *hba)
>  	ufshcd_vops_apply_dev_quirks(hba);
>  }
> 
> +static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
> +{
> +	int err;
> +
> +	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_DEVICE, 0,
> +		&hba->desc_size.dev_desc);
> +	if (err)
> +		hba->desc_size.dev_desc = QUERY_DESC_DEVICE_DEF_SIZE;
> +
> +	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_POWER, 0,
> +		&hba->desc_size.pwr_desc);
> +	if (err)
> +		hba->desc_size.pwr_desc = QUERY_DESC_POWER_DEF_SIZE;
> +
> +	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_INTERCONNECT, 0,
> +		&hba->desc_size.interc_desc);
> +	if (err)
> +		hba->desc_size.interc_desc = QUERY_DESC_INTERCONNECT_DEF_SIZE;
> +
> +	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_CONFIGURATION, 0,
> +		&hba->desc_size.conf_desc);
> +	if (err)
> +		hba->desc_size.conf_desc = QUERY_DESC_CONFIGURATION_DEF_SIZE;
> +
> +	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_UNIT, 0,
> +		&hba->desc_size.unit_desc);
> +	if (err)
> +		hba->desc_size.unit_desc = QUERY_DESC_UNIT_DEF_SIZE;
> +
> +	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_GEOMETRY, 0,
> +		&hba->desc_size.geom_desc);
> +	if (err)
> +		hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
> +}
> +
> +static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
> +{
> +	hba->desc_size.dev_desc = QUERY_DESC_DEVICE_DEF_SIZE;
> +	hba->desc_size.pwr_desc = QUERY_DESC_POWER_DEF_SIZE;
> +	hba->desc_size.interc_desc = QUERY_DESC_INTERCONNECT_DEF_SIZE;
> +	hba->desc_size.conf_desc = QUERY_DESC_CONFIGURATION_DEF_SIZE;
> +	hba->desc_size.unit_desc = QUERY_DESC_UNIT_DEF_SIZE;
> +	hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
> +}
>  /**
>   * ufshcd_probe_hba - probe hba to detect device and initialize
>   * @hba: per-adapter instance
> @@ -5272,6 +5379,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  	if (ret)
>  		goto out;
> 
> +	/* Init check for device descriptor sizes */
> +	ufshcd_init_desc_sizes(hba);
> +
>  	ufs_advertise_fixup_device(hba);
>  	ufshcd_tune_unipro_params(hba);
> 
> @@ -5300,6 +5410,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
> 
>  	/* set the state as operational after switching to desired gear */
>  	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> +
>  	/*
>  	 * If we are in error handling context or in power management 
> callbacks
>  	 * context, no need to scan the host
> @@ -6697,6 +6808,9 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  	hba->mmio_base = mmio_base;
>  	hba->irq = irq;
> 
> +	/* Set descriptor lengths to specification defaults */
> +	ufshcd_def_desc_sizes(hba);
> +
>  	err = ufshcd_hba_init(hba);
>  	if (err)
>  		goto out_error;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 08cd26e..308675a 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -205,6 +205,15 @@ struct ufs_dev_cmd {
>  	struct ufs_query query;
>  };
> 
> +struct ufs_desc_size {
> +	int dev_desc;
> +	int pwr_desc;
> +	int geom_desc;
> +	int interc_desc;
> +	int unit_desc;
> +	int conf_desc;
> +};
> +
>  /**
>   * struct ufs_clk_info - UFS clock related info
>   * @list: list headed by hba->clk_list_head
> @@ -398,6 +407,7 @@ struct ufs_init_prefetch {
>   * @clk_list_head: UFS host controller clocks list node head
>   * @pwr_info: holds current power mode
>   * @max_pwr_info: keeps the device max valid pwm
> + * @desc_size: descriptor sizes reported by device
>   * @urgent_bkops_lvl: keeps track of urgent bkops level for device
>   * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level 
> for
>   *  device is known or not.
> @@ -565,6 +575,7 @@ struct ufs_hba {
> 
>  	enum bkops_status urgent_bkops_lvl;
>  	bool is_urgent_bkops_lvl_checked;
> +	struct ufs_desc_size desc_size;
>  };
> 
>  /* Returns true if clocks can be gated. Otherwise false */
> @@ -733,6 +744,10 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum
> query_opcode opcode,
>  	enum flag_idn idn, bool *flag_res);
>  int ufshcd_hold(struct ufs_hba *hba, bool async);
>  void ufshcd_release(struct ufs_hba *hba);
> +
> +int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn 
> desc_id,
> +	int *desc_length);
> +
>  u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);
> 
>  /* Wrapper functions for safely calling variant operations */

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
