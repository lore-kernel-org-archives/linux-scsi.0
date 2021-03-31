Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373F0C43462
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 18:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0360B61073
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 18:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhCaSAa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 14:00:30 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53888 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbhCaSA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 14:00:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617213629; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=mYdCYC/FPImOY3Dj4Qxijet1JbSBWQXVRBoquvOZPb8=; b=dmfn9crM/LTgdIVFwtbGA8YXr33Zb7TYm45PmyF5UckSqMrE/tZcOfKIquySmbZXSevvMcY2
 uFosTNPp2dpUgbDMDq1D5o4EDcewkHAvU1JOXHIiH4vCovA97LpPx4/p0CUcDiRZe+cxqNx2
 WtQH5yLSlPlpvaI80okcopgj5Fg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6064b8abfebcffa80fe61ba3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 31 Mar 2021 18:00:11
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 09775C43466; Wed, 31 Mar 2021 18:00:11 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7C840C433ED;
        Wed, 31 Mar 2021 18:00:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7C840C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH V2 2/3] scsi: ufs: add a vops to configure VCC voltage
 level
To:     Nitin Rawat <nitirawa@codeaurora.org>, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bjorn.andersson@linaro.org,
        adrian.hunter@intel.com, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
 <1616363857-26760-3-git-send-email-nitirawa@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <80f681a6-165f-0610-dfea-6b66ce4abddc@codeaurora.org>
Date:   Wed, 31 Mar 2021 11:00:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1616363857-26760-3-git-send-email-nitirawa@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/21/2021 2:57 PM, Nitin Rawat wrote:
> Add a vops to configure VCC voltage VCC voltage level
> for platform supporting both ufs2.x and ufs 3.x devices.
> 
> Suggested-by: Stanley Chu <stanley.chu@mediatek.com>
> Suggested-by: Asutosh Das <asutoshd@codeaurora.org>
> Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
> Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
> ---
>   drivers/scsi/ufs/ufshcd.c |  4 ++++
>   drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 633ca8e..5bfe987 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7763,6 +7763,10 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>   		goto out;
> 
>   	ufshcd_clear_ua_wluns(hba);
> +	if (ufshcd_vops_setup_vcc_regulators(hba))
This would be invoked even for platforms that don't support both 2.x and 
3.x and don't need to set the voltages in the driver.
I guess platforms that support both 2.x and 3.x and can't set the 
regulator voltages from dts due to different voltage requirements of 2.x 
and 3.x, should request the driver to set the voltages. And the driver 
may do so after determining the device version.

> +		dev_err(hba->dev,
> +			"%s: Failed to set the VCC regulator values, continue with 2.7v\n",
> +			__func__);
> 
>   	/* Initialize devfreq after UFS device is detected */
>   	if (ufshcd_is_clkscaling_supported(hba)) {
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 0db796a..8f0945d 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -324,6 +324,7 @@ struct ufs_pwr_mode_info {
>    * @device_reset: called to issue a reset pulse on the UFS device
>    * @program_key: program or evict an inline encryption key
>    * @event_notify: called to notify important events
> + * @setup_vcc_regulators : update vcc regulator level
>    */
>   struct ufs_hba_variant_ops {
>   	const char *name;
> @@ -360,6 +361,7 @@ struct ufs_hba_variant_ops {
>   			       const union ufs_crypto_cfg_entry *cfg, int slot);
>   	void	(*event_notify)(struct ufs_hba *hba,
>   				enum ufs_event_type evt, void *data);
> +	int    (*setup_vcc_regulators)(struct ufs_hba *hba);
>   };
> 
>   /* clock gating state  */
> @@ -1269,6 +1271,14 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
>   		hba->vops->config_scaling_param(hba, profile, data);
>   }
> 
> +static inline int ufshcd_vops_setup_vcc_regulators(struct ufs_hba *hba)
> +{
> +	if (hba->vops && hba->vops->setup_vcc_regulators)
> +		return hba->vops->setup_vcc_regulators(hba);
> +
> +	return 0;
> +}
> +
>   extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
> 
>   /*
> --
> 2.7.4
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
