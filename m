Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2936FC33C9E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 18:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF37C2082F
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 18:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="u6tH1MxJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgAQSVe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 13:21:34 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:43194 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726970AbgAQSVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jan 2020 13:21:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579285293; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=goazVM9gUDNpcF36ALKOzuu+Mgo8glPm6tH9gHOrM0g=; b=u6tH1MxJ6vVcCfLU8mAFM30Dw/rzGU+jOBKIqv0HWcdRoRAsAUCG3M9ESIlkEZMnQzHzVaNA
 nNuaIVU99Ij33k9l4nTy8BlEnPa5a2dRxQxaP17NPvpedLFHzjUphQFi3OS3R2O7JPX5rF1b
 GeH+DchFEPix7lAlvN5/j+7LdqI=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e21fb2c.7f1cab3bc308-smtp-out-n02;
 Fri, 17 Jan 2020 18:21:32 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7F234C447A2; Fri, 17 Jan 2020 18:21:32 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 68729C433CB;
        Fri, 17 Jan 2020 18:21:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 68729C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2 2/9] scsi: ufs: Delete struct ufs_dev_desc
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-3-huobean@gmail.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <c8d6c59d-6ae4-aead-9f07-146467ed05c4@codeaurora.org>
Date:   Fri, 17 Jan 2020 10:21:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200116215914.16015-3-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/2020 1:59 PM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> In consideration of Host driver uses some certain UFS device properties,
> move parameters of struct ufs_dev_desc to struct ufs_dev_info, and delete
> struct ufs_dev_desc.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>   drivers/scsi/ufs/ufs-mediatek.c |  7 ++---
>   drivers/scsi/ufs/ufs-qcom.c     |  6 ++---
>   drivers/scsi/ufs/ufs.h          | 11 +-------
>   drivers/scsi/ufs/ufs_quirks.h   |  9 ++++---
>   drivers/scsi/ufs/ufshcd.c       | 47 +++++++++++++++------------------
>   drivers/scsi/ufs/ufshcd.h       |  7 +++--
>   6 files changed, 38 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 8d999c0e60fe..f8dd992b6f3a 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -406,10 +406,11 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   	return 0;
>   }
>   
> -static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba,
> -				    struct ufs_dev_desc *card)
> +static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba)
>   {
> -	if (card->wmanufacturerid == UFS_VENDOR_SAMSUNG)
> +	struct ufs_dev_info *dev_info = hba->dev_info;
> +
> +	if (dev_info->wmanufacturerid == UFS_VENDOR_SAMSUNG)
>   		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 6);
>   
>   	return 0;
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index ebb5c66e069f..9c6a182b3ed9 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -949,12 +949,12 @@ static int ufs_qcom_quirk_host_pa_saveconfigtime(struct ufs_hba *hba)
>   	return err;
>   }
>   
> -static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hba,
> -				     struct ufs_dev_desc *card)
> +static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hba)
>   {
>   	int err = 0;
> +	struct ufs_dev_info *dev_info = hba->dev_info;
>   
> -	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
> +	if (dev_info->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
>   		err = ufs_qcom_quirk_host_pa_saveconfigtime(hba);
>   
>   	return err;
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index c89f21698629..fcc9b4d4e56f 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -530,17 +530,8 @@ struct ufs_dev_info {
>   	bool f_power_on_wp_en;
>   	/* Keeps information if any of the LU is power on write protected */
>   	bool is_lu_power_on_wp;
> -};
> -
> -#define MAX_MODEL_LEN 16
> -/**
> - * ufs_dev_desc - ufs device details from the device descriptor
> - *
> - * @wmanufacturerid: card details
> - * @model: card model
> - */
> -struct ufs_dev_desc {
>   	u16 wmanufacturerid;
> +	/*UFS device Product Name */
>   	u8 *model;
>   };
>   
> diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
> index fe6cad9b2a0d..16c324c61b6e 100644
> --- a/drivers/scsi/ufs/ufs_quirks.h
> +++ b/drivers/scsi/ufs/ufs_quirks.h
> @@ -22,16 +22,17 @@
>    * @quirk: device quirk
>    */
>   struct ufs_dev_fix {
> -	struct ufs_dev_desc card;
> +	u16 wmanufacturerid;
> +	u8 *model;
>   	unsigned int quirk;
>   };
>   
> -#define END_FIX { { 0 }, 0 }
> +#define END_FIX { 0 }
>   
>   /* add specific device quirk */
>   #define UFS_FIX(_vendor, _model, _quirk) { \
> -	.card.wmanufacturerid = (_vendor),\
> -	.card.model = (_model),		   \
> +	.wmanufacturerid = (_vendor),\
> +	.model = (_model),		   \
>   	.quirk = (_quirk),		   \
>   }
>   
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9a9085a7bcc5..58ef45b80cb0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6583,16 +6583,13 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
>   	return ret;
>   }
>   
> -static int ufs_get_device_desc(struct ufs_hba *hba,
> -			       struct ufs_dev_desc *dev_desc)
> +static int ufs_get_device_desc(struct ufs_hba *hba)
>   {
>   	int err;
>   	size_t buff_len;
>   	u8 model_index;
>   	u8 *desc_buf;
> -
> -	if (!dev_desc)
> -		return -EINVAL;
> +	struct ufs_dev_info *dev_info = &hba->dev_info;
>   
>   	buff_len = max_t(size_t, hba->desc_size.dev_desc,
>   			 QUERY_DESC_MAX_SIZE + 1);
> @@ -6613,12 +6610,12 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
>   	 * getting vendor (manufacturerID) and Bank Index in big endian
>   	 * format
>   	 */
> -	dev_desc->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
> +	dev_info->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
>   				     desc_buf[DEVICE_DESC_PARAM_MANF_ID + 1];
>   
>   	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
>   	err = ufshcd_read_string_desc(hba, model_index,
> -				      &dev_desc->model, SD_ASCII_STD);
> +				      &dev_info->model, SD_ASCII_STD);
>   	if (err < 0) {
>   		dev_err(hba->dev, "%s: Failed reading Product Name. err = %d\n",
>   			__func__, err);
> @@ -6636,23 +6633,25 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
>   	return err;
>   }
>   
> -static void ufs_put_device_desc(struct ufs_dev_desc *dev_desc)
> +static void ufs_put_device_desc(struct ufs_hba *hba)
>   {
> -	kfree(dev_desc->model);
> -	dev_desc->model = NULL;
> +	struct ufs_dev_info *dev_info = &hba->dev_info;
> +
> +	kfree(dev_info->model);
> +	dev_info->model = NULL;
>   }
>   
> -static void ufs_fixup_device_setup(struct ufs_hba *hba,
> -				   struct ufs_dev_desc *dev_desc)
> +static void ufs_fixup_device_setup(struct ufs_hba *hba)
>   {
>   	struct ufs_dev_fix *f;
> +	struct ufs_dev_info *dev_info = &hba->dev_info;
>   
>   	for (f = ufs_fixups; f->quirk; f++) {
> -		if ((f->card.wmanufacturerid == dev_desc->wmanufacturerid ||
> -		     f->card.wmanufacturerid == UFS_ANY_VENDOR) &&
> -		     ((dev_desc->model &&
> -		       STR_PRFX_EQUAL(f->card.model, dev_desc->model)) ||
> -		      !strcmp(f->card.model, UFS_ANY_MODEL)))
> +		if ((f->wmanufacturerid == dev_info->wmanufacturerid ||
> +		     f->wmanufacturerid == UFS_ANY_VENDOR) &&
> +		     ((dev_info->model &&
> +		       STR_PRFX_EQUAL(f->model, dev_info->model)) ||
> +		      !strcmp(f->model, UFS_ANY_MODEL)))
>   			hba->dev_quirks |= f->quirk;
>   	}
>   }
> @@ -6804,8 +6803,7 @@ static int ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
>   	return ret;
>   }
>   
> -static void ufshcd_tune_unipro_params(struct ufs_hba *hba,
> -				      struct ufs_dev_desc *card)
> +static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
>   {
>   	if (ufshcd_is_unipro_pa_params_tuning_req(hba)) {
>   		ufshcd_tune_pa_tactivate(hba);
> @@ -6819,7 +6817,7 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba,
>   	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
>   		ufshcd_quirk_tune_host_pa_tactivate(hba);
>   
> -	ufshcd_vops_apply_dev_quirks(hba, card);
> +	ufshcd_vops_apply_dev_quirks(hba);
>   }
>   
>   static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
> @@ -6945,7 +6943,6 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
>    */
>   static int ufshcd_probe_hba(struct ufs_hba *hba)
>   {
> -	struct ufs_dev_desc card = {0};
>   	int ret;
>   	ktime_t start = ktime_get();
>   
> @@ -6974,16 +6971,15 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>   	/* Init check for device descriptor sizes */
>   	ufshcd_init_desc_sizes(hba);
>   
> -	ret = ufs_get_device_desc(hba, &card);
> +	ret = ufs_get_device_desc(hba);
>   	if (ret) {
>   		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
>   			__func__, ret);
>   		goto out;
>   	}
>   
> -	ufs_fixup_device_setup(hba, &card);
> -	ufshcd_tune_unipro_params(hba, &card);
> -	ufs_put_device_desc(&card);
> +	ufs_fixup_device_setup(hba);
> +	ufshcd_tune_unipro_params(hba);
>   
>   	/* UFS device is also active now */
>   	ufshcd_set_ufs_dev_active(hba);
> @@ -7544,6 +7540,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
>   		ufshcd_setup_clocks(hba, false);
>   		ufshcd_setup_hba_vreg(hba, false);
>   		hba->is_powered = false;
> +		ufs_put_device_desc(hba);
>   	}
>   }
>   
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b1a1c65be8b1..32b6714f25a5 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -320,7 +320,7 @@ struct ufs_hba_variant_ops {
>   	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
>   	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
>   					enum ufs_notify_change_status);
> -	int	(*apply_dev_quirks)(struct ufs_hba *, struct ufs_dev_desc *);
> +	int	(*apply_dev_quirks)(struct ufs_hba *hba);
>   	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>   	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>   	void	(*dbg_register_dump)(struct ufs_hba *hba);
> @@ -1054,11 +1054,10 @@ static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
>   		return hba->vops->hibern8_notify(hba, cmd, status);
>   }
>   
> -static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba,
> -					       struct ufs_dev_desc *card)
> +static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
>   {
>   	if (hba->vops && hba->vops->apply_dev_quirks)
> -		return hba->vops->apply_dev_quirks(hba, card);
> +		return hba->vops->apply_dev_quirks(hba);
>   	return 0;
>   }
>   
> 

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
