Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C254C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8289F60560
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbhIVQSI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:18:08 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:39567 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbhIVQSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 12:18:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632327397; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=q43FXrbAgFBvUtFOYUvPyiJL9TAhxcyfcye0voKnb+Q=; b=r0jFnsXRfpTloQ3K2HAleS5J7F9X9yv9KnVGki3PEQq+QUX9P1TuV64UvxtnV6pPd/yOUNa9
 1Ldk4SkvEYRkvskGCWpHPd1hHQq2ZUWQLOTCrXk5InYtKyGF3u59GGjaV89eLcWBhCJbQJ11
 KO+Cwi49DW2D49x/yKlTqcXqXE4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 614b56b9b585cc7d2431ce95 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 22 Sep 2021 16:15:53
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 08D7FC43618; Wed, 22 Sep 2021 16:15:52 +0000 (UTC)
Received: from [192.168.1.5] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D41EFC4338F;
        Wed, 22 Sep 2021 16:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D41EFC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <917fe2b8-78ff-de35-c3cb-3251b23ac003@codeaurora.org>
Date:   Wed, 22 Sep 2021 09:15:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH V5 3/3] scsi: ufs: Let devices remain runtime suspended
 during system suspend
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210922093842.18025-1-adrian.hunter@intel.com>
 <20210922093842.18025-4-adrian.hunter@intel.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <20210922093842.18025-4-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/2021 2:38 AM, Adrian Hunter wrote:
> If the UFS Device WLUN is runtime suspended and is in the same power
> mode, link state and b_rpm_dev_flush_capable (BKOP or WB buffer flush etc)
> state, then it can remain runtime suspended instead of being runtime
> resumed and then system suspended.
> 
> The following patches have cleared the way for that to happen:
>    scsi: ufs: Fix runtime PM dependencies getting broken
>    scsi: ufs: Fix error handler clear ua deadlock
> 
> So amend the logic accordingly.
> 
> Note, the ufs-hisi driver uses different RPM and SPM, but it is made
> explicit by a new parameter to suspend prepare.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---

LGTM.
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufs-hisi.c |  8 +++++-
>   drivers/scsi/ufs/ufshcd.c   | 53 ++++++++++++++++++++++++++++---------
>   drivers/scsi/ufs/ufshcd.h   | 12 ++++++++-
>   3 files changed, 58 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
> index 6b706de8354b..4a08fb35642c 100644
> --- a/drivers/scsi/ufs/ufs-hisi.c
> +++ b/drivers/scsi/ufs/ufs-hisi.c
> @@ -396,6 +396,12 @@ static int ufs_hisi_pwr_change_notify(struct ufs_hba *hba,
>   	return ret;
>   }
>   
> +static int ufs_hisi_suspend_prepare(struct device *dev)
> +{
> +	/* RPM and SPM are different. Refer ufs_hisi_suspend() */
> +	return __ufshcd_suspend_prepare(dev, false);
> +}
> +
>   static int ufs_hisi_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   {
>   	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
> @@ -574,7 +580,7 @@ static int ufs_hisi_remove(struct platform_device *pdev)
>   static const struct dev_pm_ops ufs_hisi_pm_ops = {
>   	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
>   	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
> -	.prepare	 = ufshcd_suspend_prepare,
> +	.prepare	 = ufs_hisi_suspend_prepare,
>   	.complete	 = ufshcd_resume_complete,
>   };
>   
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 39fc6070d2f7..64e81ece1aae 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9797,14 +9797,30 @@ void ufshcd_resume_complete(struct device *dev)
>   		ufshcd_rpm_put(hba);
>   		hba->complete_put = false;
>   	}
> -	if (hba->rpmb_complete_put) {
> -		ufshcd_rpmb_rpm_put(hba);
> -		hba->rpmb_complete_put = false;
> -	}
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
>   
> -int ufshcd_suspend_prepare(struct device *dev)
> +static bool ufshcd_rpm_ok_for_spm(struct ufs_hba *hba)
> +{
> +	struct device *dev = &hba->sdev_ufs_device->sdev_gendev;
> +	enum ufs_dev_pwr_mode dev_pwr_mode;
> +	enum uic_link_state link_state;
> +	unsigned long flags;
> +	bool res;
> +
> +	spin_lock_irqsave(&dev->power.lock, flags);
> +	dev_pwr_mode = ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl);
> +	link_state = ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl);
> +	res = pm_runtime_suspended(dev) &&
> +	      hba->curr_dev_pwr_mode == dev_pwr_mode &&
> +	      hba->uic_link_state == link_state &&
> +	      !hba->dev_info.b_rpm_dev_flush_capable;
> +	spin_unlock_irqrestore(&dev->power.lock, flags);
> +
> +	return res;
> +}
> +
> +int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm)
>   {
>   	struct ufs_hba *hba = dev_get_drvdata(dev);
>   	int ret;
> @@ -9816,19 +9832,30 @@ int ufshcd_suspend_prepare(struct device *dev)
>   	 * Refer ufshcd_resume_complete()
>   	 */
>   	if (hba->sdev_ufs_device) {
> -		ret = ufshcd_rpm_get_sync(hba);
> -		if (ret < 0 && ret != -EACCES) {
> -			ufshcd_rpm_put(hba);
> -			return ret;
> +		/* Prevent runtime suspend */
> +		ufshcd_rpm_get_noresume(hba);
> +		/*
> +		 * Check if already runtime suspended in same state as system
> +		 * suspend would be.
> +		 */
> +		if (!rpm_ok_for_spm || !ufshcd_rpm_ok_for_spm(hba)) {
> +			/* RPM state is not ok for SPM, so runtime resume */
> +			ret = ufshcd_rpm_resume(hba);
> +			if (ret < 0 && ret != -EACCES) {
> +				ufshcd_rpm_put(hba);
> +				return ret;
> +			}
>   		}
>   		hba->complete_put = true;
>   	}
> -	if (hba->sdev_rpmb) {
> -		ufshcd_rpmb_rpm_get_sync(hba);
> -		hba->rpmb_complete_put = true;
> -	}
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(__ufshcd_suspend_prepare);
> +
> +int ufshcd_suspend_prepare(struct device *dev)
> +{
> +	return __ufshcd_suspend_prepare(dev, true);
> +}
>   EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
>   
>   #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 06e743a5937a..c64a92ef15a4 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -929,7 +929,6 @@ struct ufs_hba {
>   #endif
>   	u32 luns_avail;
>   	bool complete_put;
> -	bool rpmb_complete_put;
>   };
>   
>   /* Returns true if clocks can be gated. Otherwise false */
> @@ -1189,6 +1188,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>   
>   int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
>   int ufshcd_suspend_prepare(struct device *dev);
> +int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
>   void ufshcd_resume_complete(struct device *dev);
>   
>   /* Wrapper functions for safely calling variant operations */
> @@ -1397,6 +1397,16 @@ static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
>   	return pm_runtime_put_sync(&hba->sdev_ufs_device->sdev_gendev);
>   }
>   
> +static inline void ufshcd_rpm_get_noresume(struct ufs_hba *hba)
> +{
> +	pm_runtime_get_noresume(&hba->sdev_ufs_device->sdev_gendev);
> +}
> +
> +static inline int ufshcd_rpm_resume(struct ufs_hba *hba)
> +{
> +	return pm_runtime_resume(&hba->sdev_ufs_device->sdev_gendev);
> +}
> +
>   static inline int ufshcd_rpm_put(struct ufs_hba *hba)
>   {
>   	return pm_runtime_put(&hba->sdev_ufs_device->sdev_gendev);
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
