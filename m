Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41A4C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 06:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A87223120
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 06:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgLVGPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 01:15:20 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:44418 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgLVGPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 01:15:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608617695; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=0V+Cu3IuR1wCCobiWDWzsRADyySL0im47csfUoulkMo=;
 b=oO3CGENt0pLe8Yi9AdOkyB6BqrEd3DORCWG7ct8sX8gEzPq6+o7d65LI2wBKrqoAiyDzqML1
 N4KgbEaa5qFpL77sAeex0IzbTiXaVcf2KaPgMyJkN7Ioi5q4lPsPNhVJ/ibrVdSTRUe/0TUd
 equwIzouaW+1nPUJ+Jw1LKjIZ5A=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5fe18ed93ac69bd6b81f9e6d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 06:14:49
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 99958C43465; Tue, 22 Dec 2020 06:14:48 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ECEC5C433C6;
        Tue, 22 Dec 2020 06:14:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 22 Dec 2020 14:14:46 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/7] scsi: ufs: Group UFS WB related flags to struct
 ufs_dev_info
In-Reply-To: <20201215230519.15158-6-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
 <20201215230519.15158-6-huobean@gmail.com>
Message-ID: <12d605355add6c4d55697f69737292eb@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-16 07:05, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> UFS device-related flags should be grouped in ufs_dev_info. Take
> wb_enabled and wb_buf_flush_enabled out from the struct ufs_hba,
> group them to struct ufs_dev_info, and align the names of the structure
> members vertically.
> 

Reviewed-by: Can Guo <cang@codeaurora.org>

> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs-sysfs.c |  2 +-
>  drivers/scsi/ufs/ufs.h       | 27 ++++++++++++++++-----------
>  drivers/scsi/ufs/ufshcd.c    | 21 ++++++++++-----------
>  drivers/scsi/ufs/ufshcd.h    |  4 +---
>  4 files changed, 28 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
> b/drivers/scsi/ufs/ufs-sysfs.c
> index f3ca3d6b82c4..9a9acc722a37 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -194,7 +194,7 @@ static ssize_t wb_on_show(struct device *dev,
> struct device_attribute *attr,
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> 
> -	return sysfs_emit(buf, "%d\n", hba->wb_enabled);
> +	return sysfs_emit(buf, "%d\n", hba->dev_info.wb_enabled);
>  }
> 
>  static ssize_t wb_on_store(struct device *dev, struct device_attribute 
> *attr,
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index a789e074ae3f..ec74cf360b1f 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -527,20 +527,25 @@ struct ufs_vreg_info {
>  };
> 
>  struct ufs_dev_info {
> -	bool f_power_on_wp_en;
> +	bool	f_power_on_wp_en;
>  	/* Keeps information if any of the LU is power on write protected */
> -	bool is_lu_power_on_wp;
> +	bool	is_lu_power_on_wp;
>  	/* Maximum number of general LU supported by the UFS device */
> -	u8 max_lu_supported;
> -	u8 wb_dedicated_lu;
> -	u16 wmanufacturerid;
> +	u8	max_lu_supported;
> +	u16	wmanufacturerid;
>  	/*UFS device Product Name */
> -	u8 *model;
> -	u16 wspecversion;
> -	u32 clk_gating_wait_us;
> -	u8 b_wb_buffer_type;
> -	bool b_rpm_dev_flush_capable;
> -	u8 b_presrv_uspc_en;
> +	u8	*model;
> +	u16	wspecversion;
> +	u32	clk_gating_wait_us;
> +
> +	/* UFS WB related flags */
> +	bool    wb_enabled;
> +	bool    wb_buf_flush_enabled;
> +	u8	wb_dedicated_lu;
> +	u8      wb_buffer_type;
> +
> +	bool	b_rpm_dev_flush_capable;
> +	u8	b_presrv_uspc_en;
>  };
> 
>  /**
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5f08f4a59a17..466a85051d54 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -589,8 +589,8 @@ static void ufshcd_device_reset(struct ufs_hba 
> *hba)
>  	if (!err) {
>  		ufshcd_set_ufs_dev_active(hba);
>  		if (ufshcd_is_wb_allowed(hba)) {
> -			hba->wb_enabled = false;
> -			hba->wb_buf_flush_enabled = false;
> +			hba->dev_info.wb_enabled = false;
> +			hba->dev_info.wb_buf_flush_enabled = false;
>  		}
>  	}
>  	if (err != -EOPNOTSUPP)
> @@ -5359,7 +5359,7 @@ int ufshcd_wb_ctrl(struct ufs_hba *hba, bool 
> enable)
>  	if (!ufshcd_is_wb_allowed(hba))
>  		return 0;
> 
> -	if (!(enable ^ hba->wb_enabled))
> +	if (!(enable ^ hba->dev_info.wb_enabled))
>  		return 0;
>  	if (enable)
>  		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
> @@ -5375,7 +5375,7 @@ int ufshcd_wb_ctrl(struct ufs_hba *hba, bool 
> enable)
>  		return ret;
>  	}
> 
> -	hba->wb_enabled = enable;
> +	hba->dev_info.wb_enabled = enable;
>  	dev_dbg(hba->dev, "%s write booster %s %d\n",
>  			__func__, enable ? "enable" : "disable", ret);
> 
> @@ -5415,7 +5415,7 @@ static int ufshcd_wb_buf_flush_enable(struct 
> ufs_hba *hba)
>  	int ret;
>  	u8 index;
> 
> -	if (!ufshcd_is_wb_allowed(hba) || hba->wb_buf_flush_enabled)
> +	if (!ufshcd_is_wb_allowed(hba) || hba->dev_info.wb_buf_flush_enabled)
>  		return 0;
> 
>  	index = ufshcd_wb_get_query_index(hba);
> @@ -5426,7 +5426,7 @@ static int ufshcd_wb_buf_flush_enable(struct 
> ufs_hba *hba)
>  		dev_err(hba->dev, "%s WB - buf flush enable failed %d\n",
>  			__func__, ret);
>  	else
> -		hba->wb_buf_flush_enabled = true;
> +		hba->dev_info.wb_buf_flush_enabled = true;
> 
>  	dev_dbg(hba->dev, "WB - Flush enabled: %d\n", ret);
>  	return ret;
> @@ -5437,7 +5437,7 @@ static int ufshcd_wb_buf_flush_disable(struct
> ufs_hba *hba)
>  	int ret;
>  	u8 index;
> 
> -	if (!ufshcd_is_wb_allowed(hba) || !hba->wb_buf_flush_enabled)
> +	if (!ufshcd_is_wb_allowed(hba) || 
> !hba->dev_info.wb_buf_flush_enabled)
>  		return 0;
> 
>  	index = ufshcd_wb_get_query_index(hba);
> @@ -5448,7 +5448,7 @@ static int ufshcd_wb_buf_flush_disable(struct
> ufs_hba *hba)
>  		dev_warn(hba->dev, "%s: WB - buf flush disable failed %d\n",
>  			 __func__, ret);
>  	} else {
> -		hba->wb_buf_flush_enabled = false;
> +		hba->dev_info.wb_buf_flush_enabled = false;
>  		dev_dbg(hba->dev, "WB - Flush disabled: %d\n", ret);
>  	}
> 
> @@ -7236,13 +7236,12 @@ static void ufshcd_wb_probe(struct ufs_hba
> *hba, u8 *desc_buf)
>  	 * says, in dedicated wb buffer mode, a max of 1 lun would have wb
>  	 * buffer configured.
>  	 */
> -	dev_info->b_wb_buffer_type =
> -		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
> +	dev_info->wb_buffer_type = desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
> 
>  	dev_info->b_presrv_uspc_en =
>  		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
> 
> -	if (dev_info->b_wb_buffer_type == WB_BUF_MODE_SHARED) {
> +	if (dev_info->wb_buffer_type == WB_BUF_MODE_SHARED) {
>  		if (!get_unaligned_be32(desc_buf +
>  				   DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS))
>  			goto wb_disabled;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 2a97006a2c93..ee97068158e2 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -805,8 +805,6 @@ struct ufs_hba {
> 
>  	struct device		bsg_dev;
>  	struct request_queue	*bsg_queue;
> -	bool wb_buf_flush_enabled;
> -	bool wb_enabled;
>  	struct delayed_work rpm_dev_flush_recheck_work;
> 
>  #ifdef CONFIG_SCSI_UFS_CRYPTO
> @@ -946,7 +944,7 @@ static inline bool
> ufshcd_keep_autobkops_enabled_except_suspend(
> 
>  static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
>  {
> -	if (hba->dev_info.b_wb_buffer_type == WB_BUF_MODE_LU_DEDICATED)
> +	if (hba->dev_info.wb_buffer_type == WB_BUF_MODE_LU_DEDICATED)
>  		return hba->dev_info.wb_dedicated_lu;
>  	return 0;
>  }
