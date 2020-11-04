Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2E7C4741F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 16:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E02E206DB
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 16:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="RP6DDn/d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbgKDQfF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 11:35:05 -0500
Received: from z5.mailgun.us ([104.130.96.5]:61889 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729211AbgKDQfF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Nov 2020 11:35:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604507704; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=SU4HLVR4/pKEuR98eYnU7WA158OKC9R/E6ZMPClcWT0=; b=RP6DDn/dHHn/VD7CKcbkSDpDrEltMPoEkJoo6V/EJb8QG/1yQPzltFhtQwtdLgi56GUsVBbZ
 Mk0z9Ul+o4Ygaz3uIZlkYQ0Uzu4Wqg40JuVbb+JNStOebmfSe6Sz0RUTGZlKc2x8zTy13FhN
 w1V2ufvEn5YOWMHCYdDy99F56BU=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fa2d8360f4c350e07351f0f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 04 Nov 2020 16:35:02
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 08910C433C8; Wed,  4 Nov 2020 16:35:02 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D4277C433C6;
        Wed,  4 Nov 2020 16:35:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D4277C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH V4 2/2] scsi: ufs: Allow an error return value from
 ->device_reset()
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
 <20201103141403.2142-3-adrian.hunter@intel.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <c9d90e63-2adb-5dc1-21c8-8112d92dc5b0@codeaurora.org>
Date:   Wed, 4 Nov 2020 08:35:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201103141403.2142-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/2020 6:14 AM, Adrian Hunter wrote:
> It is simpler for drivers to provide a ->device_reset() callback
> irrespective of whether the GPIO, or firmware interface necessary to do the
> reset, is discovered during probe.
> 
> Change ->device_reset() to return an error code.  Drivers that provide
> the callback, but do not do the reset operation should return -EOPNOTSUPP.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

> ---
>   drivers/scsi/ufs/ufs-mediatek.c |  4 +++-
>   drivers/scsi/ufs/ufs-qcom.c     |  6 ++++--
>   drivers/scsi/ufs/ufshcd.h       | 11 +++++++----
>   3 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 8df73bc2f8cb..914a827a93ee 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -743,7 +743,7 @@ static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
>   	return ret;
>   }
>   
> -static void ufs_mtk_device_reset(struct ufs_hba *hba)
> +static int ufs_mtk_device_reset(struct ufs_hba *hba)
>   {
>   	struct arm_smccc_res res;
>   
> @@ -764,6 +764,8 @@ static void ufs_mtk_device_reset(struct ufs_hba *hba)
>   	usleep_range(10000, 15000);
>   
>   	dev_info(hba->dev, "device reset done\n");
> +
> +	return 0;
>   }
>   
>   static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 9a19c6d15d3b..357c3b49321d 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1422,13 +1422,13 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
>    *
>    * Toggles the (optional) reset line to reset the attached device.
>    */
> -static void ufs_qcom_device_reset(struct ufs_hba *hba)
> +static int ufs_qcom_device_reset(struct ufs_hba *hba)
>   {
>   	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>   
>   	/* reset gpio is optional */
>   	if (!host->device_reset)
> -		return;
> +		return -EOPNOTSUPP;
>   
>   	/*
>   	 * The UFS device shall detect reset pulses of 1us, sleep for 10us to
> @@ -1439,6 +1439,8 @@ static void ufs_qcom_device_reset(struct ufs_hba *hba)
>   
>   	gpiod_set_value_cansleep(host->device_reset, 0);
>   	usleep_range(10, 15);
> +
> +	return 0;
>   }
>   
>   #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 213be0667b59..5191d87f6263 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -323,7 +323,7 @@ struct ufs_hba_variant_ops {
>   	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>   	void	(*dbg_register_dump)(struct ufs_hba *hba);
>   	int	(*phy_initialization)(struct ufs_hba *);
> -	void	(*device_reset)(struct ufs_hba *hba);
> +	int	(*device_reset)(struct ufs_hba *hba);
>   	void	(*config_scaling_param)(struct ufs_hba *hba,
>   					struct devfreq_dev_profile *profile,
>   					void *data);
> @@ -1207,9 +1207,12 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
>   static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
>   {
>   	if (hba->vops && hba->vops->device_reset) {
> -		hba->vops->device_reset(hba);
> -		ufshcd_set_ufs_dev_active(hba);
> -		ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, 0);
> +		int err = hba->vops->device_reset(hba);
> +
> +		if (!err)
> +			ufshcd_set_ufs_dev_active(hba);
> +		if (err != -EOPNOTSUPP)
> +			ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, err);
>   	}
>   }
>   
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
