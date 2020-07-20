Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327B6C433F7
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 16:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C8FA206E9
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 16:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="P9KXLtU4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgGTQrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 12:47:19 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:21740 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730047AbgGTQrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 12:47:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595263633; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: To:
 Subject: Sender; bh=V5Px2E5JQXEPJZlAu52NsQJJIoSxqUY57ak+xF3xJw4=; b=P9KXLtU4QDyDeGuGvBFHqIybDkC2+SsDQKzNP2bDtPXHymjr44lO4FoZkOaQWsJzjlVL6Xk0
 tQfB4T0kkjIneFue3yjpDfgpFH7V6NbDS4SxkYpSL6mCjO4wTMDaksN/1fxiAiysWkCurk23
 W35Rb+GvbygDSiC7AFZN5eJQudw=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f15ca86cf983e60a870d83f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 20 Jul 2020 16:47:02
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1461EC433BA; Mon, 20 Jul 2020 16:47:02 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A7E44C433AD;
        Mon, 20 Jul 2020 16:46:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A7E44C433AD
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [RFC PATCH v2 1/3] scsi: ufs: modify write booster
To:     SEO HOYOUNG <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, bvanassche@acm.org, grant.jung@samsung.com
References: <cover.1595240433.git.hy50.seo@samsung.com>
 <CGME20200720103949epcas2p4a49b245d9cebf0478d42fb6c607fc236@epcas2p4.samsung.com>
 <a4db9e7982c4dcd00b4adbcb5d247261a7ec0c27.1595240433.git.hy50.seo@samsung.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <4a4c1753-b78d-30eb-b086-5812b67de31a@codeaurora.org>
Date:   Mon, 20 Jul 2020 09:46:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a4db9e7982c4dcd00b4adbcb5d247261a7ec0c27.1595240433.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/20/2020 3:40 AM, SEO HOYOUNG wrote:
> Add vendor specific functions for WB
> Use callback additional setting when use write booster.
> 
> Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 23 ++++++++++++++++-----
>   drivers/scsi/ufs/ufshcd.h | 43 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 61 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index efc0a6cbfe22..efa16bf4fd76 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3306,11 +3306,11 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
>    *
>    * Return 0 in case of success, non-zero otherwise
>    */
> -static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> -					      int lun,
> -					      enum unit_desc_param param_offset,
> -					      u8 *param_read_buf,
> -					      u32 param_size)
> +int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> +				int lun,
> +				enum unit_desc_param param_offset,
> +				u8 *param_read_buf,
> +				u32 param_size)
>   {
>   	/*
>   	 * Unit descriptors are only available for general purpose LUs (LUN id
> @@ -3322,6 +3322,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
>   	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
>   				      param_offset, param_read_buf, param_size);
>   }
> +EXPORT_SYMBOL_GPL(ufshcd_read_unit_desc_param);
>   
>   static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
>   {
> @@ -5257,6 +5258,10 @@ static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
>   
>   	if (!(enable ^ hba->wb_enabled))
>   		return 0;
> +
> +	if (!ufshcd_wb_ctrl_vendor(hba, enable))
> +		return 0;
> +
>   	if (enable)
>   		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
>   	else
> @@ -6610,6 +6615,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>   	int err = 0;
>   	int retries = MAX_HOST_RESET_RETRIES;
>   
> +	ufshcd_reset_vendor(hba);
> +
>   	do {
>   		/* Reset the attached device */
>   		ufshcd_vops_device_reset(hba);
> @@ -6903,6 +6910,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>   	if (!(dev_info->d_ext_ufs_feature_sup & UFS_DEV_WRITE_BOOSTER_SUP))
>   		goto wb_disabled;
>   
> +	if (!ufshcd_wb_alloc_units_vendor(hba))
> +		return;
I didn't understand this check. Have you considered this - 
ufshcd_is_wb_allowed(...).
> +
>   	/*
>   	 * WB may be supported but not configured while provisioning.
>   	 * The spec says, in dedicated wb buffer mode,
> @@ -8260,6 +8270,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   			/* make sure that auto bkops is disabled */
>   			ufshcd_disable_auto_bkops(hba);
>   		}
> +
Unnecessary new line, perhaps?
>   		/*
>   		 * If device needs to do BKOP or WB buffer flush during
>   		 * Hibern8, keep device power mode as "active power mode"
> @@ -8273,6 +8284,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   			ufshcd_wb_need_flush(hba));
>   	}
>   
> +	ufshcd_wb_toggle_flush_vendor(hba, pm_op);
> +
>   	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
>   		if ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
>   		    !ufshcd_is_runtime_pm(pm_op)) {
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 656c0691c858..deb9577e0eaa 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -254,6 +254,13 @@ struct ufs_pwr_mode_info {
>   	struct ufs_pa_layer_attr info;
>   };
>   
> +struct ufs_wb_ops {
> +	int (*wb_toggle_flush_vendor)(struct ufs_hba *hba, enum ufs_pm_op pm_op);
> +	int (*wb_alloc_units_vendor)(struct ufs_hba *hba);
> +	int (*wb_ctrl_vendor)(struct ufs_hba *hba, bool enable);
> +	int (*wb_reset_vendor)(struct ufs_hba *hba, bool force);
> +};
> +
>   /**
>    * struct ufs_hba_variant_ops - variant specific callbacks
>    * @name: variant name
> @@ -752,6 +759,7 @@ struct ufs_hba {
>   	struct request_queue	*bsg_queue;
>   	bool wb_buf_flush_enabled;
>   	bool wb_enabled;
> +	struct ufs_wb_ops *wb_ops;
>   	struct delayed_work rpm_dev_flush_recheck_work;
>   
>   #ifdef CONFIG_SCSI_UFS_CRYPTO
> @@ -1004,6 +1012,10 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>   			     u8 *desc_buff, int *buff_len,
>   			     enum query_opcode desc_op);
>   
> +int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> +				int lun, enum unit_desc_param param_offset,
> +				u8 *param_read_buf, u32 param_size);
> +
>   /* Wrapper functions for safely calling variant operations */
>   static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
>   {
> @@ -1181,4 +1193,35 @@ static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
>   int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
>   		     const char *prefix);
>   
> +static inline int ufshcd_wb_toggle_flush_vendor(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> +{
> +	if (!hba->wb_ops || !hba->wb_ops->wb_toggle_flush_vendor)
> +		return -1;
> +
> +	return hba->wb_ops->wb_toggle_flush_vendor(hba, pm_op);
> +}
> +
> +static int ufshcd_wb_alloc_units_vendor(struct ufs_hba *hba)
> +{
> +	if (!hba->wb_ops || !hba->wb_ops->wb_alloc_units_vendor)
> +		return -1;
> +
> +	return hba->wb_ops->wb_alloc_units_vendor(hba);
> +}
> +
> +static int ufshcd_wb_ctrl_vendor(struct ufs_hba *hba, bool enable)
> +{
> +	if (!hba->wb_ops || !hba->wb_ops->wb_ctrl_vendor)
> +		return -1;
> +
> +	return hba->wb_ops->wb_ctrl_vendor(hba, enable);
> +}
> +
> +static int ufshcd_reset_vendor(struct ufs_hba *hba)
> +{
> +	if (!hba->wb_ops || !hba->wb_ops->wb_reset_vendor)
> +		return -1;
> +
> +	return hba->wb_ops->wb_reset_vendor(hba, false);
> +}
>   #endif /* End of Header */
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
