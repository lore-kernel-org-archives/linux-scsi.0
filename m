Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E91EC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 17:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60CB1206C0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 17:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="TbbSn6O8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387766AbgF3Rce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:32:34 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:10483 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730171AbgF3Rcd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 13:32:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1593538352; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=ZFcSwfI5UdhOXhdrQZvHHPaea1ggOYoJbFhXiurrIwM=; b=TbbSn6O88PmpM4+Ql3+xdrFj5qqpo+O2QPBXyAe5IMhA2nZHwA52dIq16pkgiQqa9zdLpMLH
 zPgPIxRLCGaXz8mulnLvjjS2tNTVdBrTRQY3DGONs+Lj2YfaYAFVQFd4LF7qs4NaZZgKnEH8
 9hnVXevGuoA7zBiFNzdprnoIDRA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n11.prod.us-west-2.postgun.com with SMTP id
 5efb772aad153efa34f14357 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 30 Jun 2020 17:32:26
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E593CC433CA; Tue, 30 Jun 2020 17:32:25 +0000 (UTC)
Received: from [192.168.8.176] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D29B9C433C8;
        Tue, 30 Jun 2020 17:32:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D29B9C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2] scsi: ufs: Disable WriteBooster capability in
 non-supported UFS device
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com
References: <20200624074110.21919-1-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <7f826f0c-6ed1-b3a3-72c9-aae0a1680e23@codeaurora.org>
Date:   Tue, 30 Jun 2020 10:32:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200624074110.21919-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/24/2020 12:41 AM, Stanley Chu wrote:
> If UFS device is not qualified to enter the detection of WriteBooster
> probing by disallowed UFS version or device quirks, then WriteBooster
> capability in host shall be disabled to prevent any WriteBooster
> operations in the future.
> 
> Fixes: 3d17b9b5ab11 ("scsi: ufs: Add write booster feature support")
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 35 +++++++++++++++++++----------------
>   1 file changed, 19 insertions(+), 16 deletions(-)
> 
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>


> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f173ad1bd79f..c62bd47beeaa 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6847,21 +6847,31 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
>   
>   static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>   {
> +	struct ufs_dev_info *dev_info = &hba->dev_info;
>   	u8 lun;
>   	u32 d_lu_wb_buf_alloc;
>   
>   	if (!ufshcd_is_wb_allowed(hba))
>   		return;
> +	/*
> +	 * Probe WB only for UFS-2.2 and UFS-3.1 (and later) devices or
> +	 * UFS devices with quirk UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES
> +	 * enabled
> +	 */
> +	if (!(dev_info->wspecversion >= 0x310 ||
> +	      dev_info->wspecversion == 0x220 ||
> +	     (hba->dev_quirks & UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES)))
> +		goto wb_disabled;
>   
>   	if (hba->desc_size[QUERY_DESC_IDN_DEVICE] <
>   	    DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
>   		goto wb_disabled;
>   
> -	hba->dev_info.d_ext_ufs_feature_sup =
> +	dev_info->d_ext_ufs_feature_sup =
>   		get_unaligned_be32(desc_buf +
>   				   DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
>   
> -	if (!(hba->dev_info.d_ext_ufs_feature_sup & UFS_DEV_WRITE_BOOSTER_SUP))
> +	if (!(dev_info->d_ext_ufs_feature_sup & UFS_DEV_WRITE_BOOSTER_SUP))
>   		goto wb_disabled;
>   
>   	/*
> @@ -6870,17 +6880,17 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>   	 * a max of 1 lun would have wb buffer configured.
>   	 * Now only shared buffer mode is supported.
>   	 */
> -	hba->dev_info.b_wb_buffer_type =
> +	dev_info->b_wb_buffer_type =
>   		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
>   
> -	hba->dev_info.b_presrv_uspc_en =
> +	dev_info->b_presrv_uspc_en =
>   		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
>   
> -	if (hba->dev_info.b_wb_buffer_type == WB_BUF_MODE_SHARED) {
> -		hba->dev_info.d_wb_alloc_units =
> +	if (dev_info->b_wb_buffer_type == WB_BUF_MODE_SHARED) {
> +		dev_info->d_wb_alloc_units =
>   		get_unaligned_be32(desc_buf +
>   				   DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS);
> -		if (!hba->dev_info.d_wb_alloc_units)
> +		if (!dev_info->d_wb_alloc_units)
>   			goto wb_disabled;
>   	} else {
>   		for (lun = 0; lun < UFS_UPIU_MAX_WB_LUN_ID; lun++) {
> @@ -6891,7 +6901,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>   					(u8 *)&d_lu_wb_buf_alloc,
>   					sizeof(d_lu_wb_buf_alloc));
>   			if (d_lu_wb_buf_alloc) {
> -				hba->dev_info.wb_dedicated_lu = lun;
> +				dev_info->wb_dedicated_lu = lun;
>   				break;
>   			}
>   		}
> @@ -6977,14 +6987,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>   
>   	ufs_fixup_device_setup(hba);
>   
> -	/*
> -	 * Probe WB only for UFS-3.1 devices or UFS devices with quirk
> -	 * UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES enabled
> -	 */
> -	if (dev_info->wspecversion >= 0x310 ||
> -	    dev_info->wspecversion == 0x220 ||
> -	    (hba->dev_quirks & UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES))
> -		ufshcd_wb_probe(hba, desc_buf);
> +	ufshcd_wb_probe(hba, desc_buf);
>   
>   	/*
>   	 * ufshcd_read_string_desc returns size of the string
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
