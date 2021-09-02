Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF36C83028
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 17:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 112EC610D2
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 17:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346527AbhIBRJH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 13:09:07 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48430 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346535AbhIBRJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Sep 2021 13:09:03 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630602485; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=Y63IIHHFhHS7/Ubie9RtdMmX4PX9vl9lry6X5vEfXWU=; b=HA4FZdFANnacm2hhl01V0rFQS6OB3oKXwEz4uyKgBZnJqKPGasZYCwtQb19W0BxKrbkY9UXd
 kW7kfFZCO2M3uZ8mfTv5rO4zhXwz7nSgavz7ml+J3UP1Nw4GRUf+yD1BLb2JnMvOV6WBUFMD
 bifW/niblCaRble+ye790nofyg0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 613104ea6fc2cf7ad9e7e985 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 02 Sep 2021 17:07:54
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F1226C43618; Thu,  2 Sep 2021 17:07:52 +0000 (UTC)
Received: from [192.168.1.8] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3D459C4338F;
        Thu,  2 Sep 2021 17:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 3D459C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH 3/3] scsi: ufs: Let devices remain runtime suspended
 during system suspend
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <d5f5552d-257a-62ee-f0a3-55c00959e63b@intel.com>
 <20210902101818.4132-1-adrian.hunter@intel.com>
 <20210902101818.4132-4-adrian.hunter@intel.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <0c162d36-6fb5-19e8-dce2-82156e83db4d@codeaurora.org>
Date:   Thu, 2 Sep 2021 10:07:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210902101818.4132-4-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/2/2021 3:18 AM, Adrian Hunter wrote:
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
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 45 ++++++++++++++++++++++++++++-----------
>   drivers/scsi/ufs/ufshcd.h | 11 +++++++++-
>   2 files changed, 43 insertions(+), 13 deletions(-)
> 
Hi Adrian,
Thanks for the change.

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 57ed4b93b949..8e799e47e095 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9722,13 +9722,29 @@ void ufshcd_resume_complete(struct device *dev)
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
> +static bool ufshcd_rpm_ok_for_spm(struct ufs_hba *hba)
> +{
> +	struct device *dev = &hba->sdev_ufs_device->sdev_gendev;
> +	enum ufs_dev_pwr_mode dev_pwr_mode;
> +	enum uic_link_state link_state;
> +	unsigned long flags;
> +	bool res;
> +
In the current ufshcd_suspend(), there's a ufshcd_vops_suspend().
That's invoked for different pm_ops independent of the rpm_lvl and spm_lvl.
I'm not sure if any vendor driver does different things for diff pm_op.
Perhaps something to check.

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
>   int ufshcd_suspend_prepare(struct device *dev)
>   {
>   	struct ufs_hba *hba = dev_get_drvdata(dev);
> @@ -9741,17 +9757,22 @@ int ufshcd_suspend_prepare(struct device *dev)
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
> +		if (!ufshcd_rpm_ok_for_spm(hba)) {
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
>   EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 4723f27a55d1..149803d60ecb 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -915,7 +915,6 @@ struct ufs_hba {
>   #endif
>   	u32 luns_avail;
>   	bool complete_put;
> -	bool rpmb_complete_put;
>   };
>   
>   /* Returns true if clocks can be gated. Otherwise false */
> @@ -1383,6 +1382,16 @@ static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
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
