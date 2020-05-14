Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF26C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 17:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4076C206F1
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 17:07:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="b2+QHWQN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgENRHA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 13:07:00 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:49566 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbgENRHA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 May 2020 13:07:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589476018; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=M/yi92o3kNGCcpoKE1hRJo2YjuLewaLJcQLxkEjatR0=; b=b2+QHWQNFNiiIOuj03T8XS6kSzDGBmcnssaDN0C3BVYBRELiOZKOA8fZQgdGjBp1uQtpK41b
 85ukLkdsD8fsWlLFdzZtdbFVyRvo4jW4fW62VbCnAtUq7CoHkz24Ls4mlgLNC+JePv2kVhFz
 CS4W74UjkyDuX3EmR66buZoJoKs=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5ebd7aabd915e862f6d79bc2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 May 2020 17:06:51
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 441DEC44793; Thu, 14 May 2020 17:06:50 +0000 (UTC)
Received: from [192.168.8.150] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D4AD7C432C2;
        Thu, 14 May 2020 17:06:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D4AD7C432C2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2 4/4] scsi: ufs: Fix WriteBooster flush during runtime
 suspend
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200514150122.32110-1-stanley.chu@mediatek.com>
 <20200514150122.32110-5-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <a41771f3-b82e-9fc4-798a-99b0c6598699@codeaurora.org>
Date:   Thu, 14 May 2020 10:06:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514150122.32110-5-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/14/2020 8:01 AM, Stanley Chu wrote:
> Currently UFS host driver promises VCC supply if UFS device
> needs to do WriteBooster flush during runtime suspend.
> 
> However the UFS specification mentions,
> 
> "While the flushing operation is in progress, the device is
> in Active power mode."
> 
> Therefore UFS host driver needs to promise more: Keep UFS
> device as "Active power mode", otherwise UFS device shall not
> do any flush if device enters Sleep or PowerDown power mode.
> 
> Fix this by not changing device power mode if WriteBooster
> flush is required in ufshcd_suspend().
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>   drivers/scsi/ufs/ufs.h    |  1 -
>   drivers/scsi/ufs/ufshcd.c | 42 ++++++++++++++++++++-------------------
>   2 files changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index b3135344ab3f..9e4bc2e97ada 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -577,7 +577,6 @@ struct ufs_dev_info {
>   	u32 d_ext_ufs_feature_sup;
>   	u8 b_wb_buffer_type;
>   	u32 d_wb_alloc_units;
> -	bool keep_vcc_on;
>   	u8 b_presrv_uspc_en;
>   };
>   
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 169a3379e468..b9f7744ca2b4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8101,8 +8101,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
>   	    !hba->dev_info.is_lu_power_on_wp) {
>   		ufshcd_setup_vreg(hba, false);
>   	} else if (!ufshcd_is_ufs_dev_active(hba)) {
> -		if (!hba->dev_info.keep_vcc_on)
> -			ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
> +		ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
>   		if (!ufshcd_is_link_active(hba)) {
>   			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq);
>   			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq2);
> @@ -8172,6 +8171,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   	enum ufs_pm_level pm_lvl;
>   	enum ufs_dev_pwr_mode req_dev_pwr_mode;
>   	enum uic_link_state req_link_state;
> +	bool keep_curr_dev_pwr_mode = false;
>   
>   	hba->pm_op_in_progress = 1;
>   	if (!ufshcd_is_shutdown_pm(pm_op)) {
> @@ -8227,27 +8227,29 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   			ufshcd_disable_auto_bkops(hba);
>   		}
>   		/*
> -		 * With wb enabled, if the bkops is enabled or if the
> -		 * configured WB type is 70% full, keep vcc ON
> -		 * for the device to flush the wb buffer
> +		 * If device needs to do BKOP or WB buffer flush during
> +		 * Hibern8, keep device power mode as "active power mode"
> +		 * and VCC supply.
>   		 */
> -		if ((hba->auto_bkops_enabled && ufshcd_is_wb_allowed(hba)) ||
> -		    ufshcd_wb_keep_vcc_on(hba))
> -			hba->dev_info.keep_vcc_on = true;
> -		else
> -			hba->dev_info.keep_vcc_on = false;
> -	} else {
> -		hba->dev_info.keep_vcc_on = false;
> +		keep_curr_dev_pwr_mode = hba->auto_bkops_enabled ||
> +			(((req_link_state == UIC_LINK_HIBERN8_STATE) ||
> +			((req_link_state == UIC_LINK_ACTIVE_STATE) &&
> +			ufshcd_is_auto_hibern8_enabled(hba))) &&
> +			ufshcd_wb_keep_vcc_on(hba));
>   	}
>   
This looks fine.
But I still think the delayed check of flush status should be done to 
turn-off Vcc when flush is complete.

> -	if ((req_dev_pwr_mode != hba->curr_dev_pwr_mode) &&
> -	    ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
> -	    !ufshcd_is_runtime_pm(pm_op))) {
> -		/* ensure that bkops is disabled */
> -		ufshcd_disable_auto_bkops(hba);
> -		ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
> -		if (ret)
> -			goto enable_gating;
> +	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
> +		if ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
> +		    !ufshcd_is_runtime_pm(pm_op)) {
> +			/* ensure that bkops is disabled */
> +			ufshcd_disable_auto_bkops(hba);
> +		}
> +
> +		if (!keep_curr_dev_pwr_mode) {
> +			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
> +			if (ret)
> +				goto enable_gating;
> +		}
>   	}
>   
>   	flush_work(&hba->eeh_work);
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
