Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5086FC2D0D2
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C9B722314
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="bmvBQTxr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfLRXxp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:53:45 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:55644 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbfLRXxo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Dec 2019 18:53:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576713223; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=+dFcC2QCZE4EMyWiuaOLbaCWdMrLQF93LI0XXqLXM9Q=; b=bmvBQTxrxQyWxx8kMA5url77p7X1lp2MNwy6F2lKl3AlcLcm9wiVMBSaYnWMmbfqfy/BVD9c
 XJkpreSkCnDvrvu6YLkyBaUBMZK+ENDj04gVXN+oBW/vdD1GK59SzAo+V2/lPTqhkO8HTuyo
 8MEqqxvngDv5cs9YTRvCvezUFO8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfabc03.7f8ab9da1148-smtp-out-n01;
 Wed, 18 Dec 2019 23:53:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D2FE3C447A0; Wed, 18 Dec 2019 23:53:39 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 090F0C433A2;
        Wed, 18 Dec 2019 23:53:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 090F0C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 2/4] scsi: ufs: export ufshcd_auto_hibern8_update for
 vendor usage
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, pedrom.sousa@synopsys.com,
        jejb@linux.ibm.com, matthias.bgg@gmail.com
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        beanhuo@micron.com, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
 <1576224695-22657-3-git-send-email-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <ad0153db-93ad-0ecf-c2f3-1b76dda778d3@codeaurora.org>
Date:   Wed, 18 Dec 2019 15:53:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1576224695-22657-3-git-send-email-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/13/2019 12:11 AM, Stanley Chu wrote:
> Export ufshcd_auto_hibern8_update to allow vendors to use common
> interface to customize auto-hibernate timer.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>   drivers/scsi/ufs/ufs-sysfs.c | 20 --------------------
>   drivers/scsi/ufs/ufshcd.c    | 18 ++++++++++++++++++
>   drivers/scsi/ufs/ufshcd.h    |  1 +
>   3 files changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index ad2abc96c0f1..720be3f64be7 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -118,26 +118,6 @@ static ssize_t spm_target_link_state_show(struct device *dev,
>   				ufs_pm_lvl_states[hba->spm_lvl].link_state));
>   }
>   
> -static void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
> -{
> -	unsigned long flags;
> -
> -	if (!ufshcd_is_auto_hibern8_supported(hba))
> -		return;
> -
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> -	if (hba->ahit != ahit)
> -		hba->ahit = ahit;
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -	if (!pm_runtime_suspended(hba->dev)) {
> -		pm_runtime_get_sync(hba->dev);
> -		ufshcd_hold(hba, false);
> -		ufshcd_auto_hibern8_enable(hba);
> -		ufshcd_release(hba);
> -		pm_runtime_put(hba->dev);
> -	}
> -}
> -
>   /* Convert Auto-Hibernate Idle Timer register value to microseconds */
>   static int ufshcd_ahit_to_us(u32 ahit)
>   {
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b5966faf3e98..589f519316aa 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3956,6 +3956,24 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>   	return ret;
>   }
>   
> +void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
> +{
> +	unsigned long flags;
> +
> +	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
> +		return;
> +
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	if (hba->ahit == ahit)
> +		goto out_unlock;
> +	hba->ahit = ahit;
> +	if (!pm_runtime_suspended(hba->dev))
> +		ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +out_unlock:
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
> +
>   void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
>   {
>   	unsigned long flags;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 2740f6941ec6..86586a0b9aa5 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -927,6 +927,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
>   	enum flag_idn idn, bool *flag_res);
>   
>   void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
> +void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
>   
>   #define SD_ASCII_STD true
>   #define SD_RAW false
> 

Looks good to me.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
