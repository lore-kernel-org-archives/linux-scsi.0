Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D205C48BC2
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 02:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C3261351
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 02:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFXCII (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 22:08:08 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:24308 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFXCIH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 22:08:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624500349; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=LBPjdz7Wo1tkWc5lk7wabRwNauOxfy0tmZTFc5EqIYE=;
 b=G5aDN35/1uEy9iAE+szozhyIY8DnY4GtVOh9JDbj79LggCOJaO19pj6mNGA0br9AMRuwogSH
 e71aSQ+JE2qsa3p5qyYaXGYhlA1sYQqMIuR5+1c1DAEtukIQNPU2cR1gleZqt03tibPj9Bxj
 P1aypg/GqtWg/+QVyPIkraJO/H8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60d3e87d638039e997e2f7d6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 02:05:49
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8BBC5C43143; Thu, 24 Jun 2021 02:05:48 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 302A6C433F1;
        Thu, 24 Jun 2021 02:05:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Jun 2021 10:05:47 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Satya Tangirala <satyat@google.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 02/10] scsi: ufs: Add flags pm_op_in_progress and
 is_sys_suspended
In-Reply-To: <d9da89ac-cb40-d11b-5af3-5c948eb9b927@intel.com>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-3-git-send-email-cang@codeaurora.org>
 <d9da89ac-cb40-d11b-5af3-5c948eb9b927@intel.com>
Message-ID: <646da45daab10c264c4c8671744a07df@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Adrian,

On 2021-06-23 20:33, Adrian Hunter wrote:
> On 23/06/21 10:35 am, Can Guo wrote:
>> Add flags pm_op_in_progress and is_sys_suspended to track the status 
>> of hba
>> runtime and system suspend/resume operations.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 12 +++++++++++-
>>  drivers/scsi/ufs/ufshcd.h |  4 ++++
>>  2 files changed, 15 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index c40ba1d..abe5f2d 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -551,6 +551,8 @@ static void ufshcd_print_host_state(struct ufs_hba 
>> *hba)
>>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>>  	dev_err(hba->dev, "wlu_pm_op_in_progress=%d, 
>> is_wlu_sys_suspended=%d\n",
>>  		hba->wlu_pm_op_in_progress, hba->is_wlu_sys_suspended);
>> +	dev_err(hba->dev, "pm_op_in_progress=%d, is_sys_suspended=%d\n",
>> +		hba->pm_op_in_progress, hba->is_sys_suspended);
>>  	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
>>  		hba->auto_bkops_enabled, hba->host->host_self_blocked);
>>  	dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
>> @@ -9141,6 +9143,8 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>> 
>>  	if (!hba->is_powered)
>>  		return 0;
>> +
>> +	hba->pm_op_in_progress = true;
>>  	/*
>>  	 * Disable the host irq as host controller as there won't be any
>>  	 * host controller transaction expected till resume.
> 	 */
> 	ufshcd_disable_irq(hba);
> 	ret = ufshcd_setup_clocks(hba, false);
> 	if (ret) {
> 		ufshcd_enable_irq(hba);
> 
> Is "hba->pm_op_in_progress = false" needed here?
> 
> 		return ret;
> 	}
> 
> 

You are right, I missed it. Will add it in next ver. Thanks!

Regards,

Can Guo.

> 
>> @@ -9160,6 +9164,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>>  	ufshcd_vreg_set_lpm(hba);
>>  	/* Put the host controller in low power mode if possible */
>>  	ufshcd_hba_vreg_set_lpm(hba);
>> +	hba->pm_op_in_progress = false;
>>  	return ret;
>>  }
>> 
>> @@ -9179,6 +9184,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
>>  	if (!hba->is_powered)
>>  		return 0;
>> 
>> +	hba->pm_op_in_progress = true;
>>  	ufshcd_hba_vreg_set_hpm(hba);
>>  	ret = ufshcd_vreg_set_hpm(hba);
>>  	if (ret)
>> @@ -9198,6 +9204,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
>>  out:
>>  	if (ret)
>>  		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)ret);
>> +	hba->pm_op_in_progress = false;
>>  	return ret;
>>  }
>> 
>> @@ -9222,6 +9229,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>>  	trace_ufshcd_system_suspend(dev_name(hba->dev), ret,
>>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>> +	if (!ret)
>> +		hba->is_sys_suspended = true;
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL(ufshcd_system_suspend);
>> @@ -9247,7 +9256,8 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>>  	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
>>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>> -
>> +	if (!ret)
>> +		hba->is_sys_suspended = false;
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL(ufshcd_system_resume);
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 93aeeb3..1e7fe73 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -754,6 +754,8 @@ struct ufs_hba {
>>  	struct device_attribute spm_lvl_attr;
>>  	/* A flag to tell whether __ufshcd_wl_suspend/resume() is in 
>> progress */
>>  	bool wlu_pm_op_in_progress;
>> +	/* A flag to tell whether ufshcd_suspend/resume() is in progress */
>> +	bool pm_op_in_progress;
>> 
>>  	/* Auto-Hibernate Idle Timer register value */
>>  	u32 ahit;
>> @@ -841,6 +843,8 @@ struct ufs_hba {
>>  	struct ufs_clk_scaling clk_scaling;
>>  	/* A flag to tell whether the UFS device W-LU is system suspended */
>>  	bool is_wlu_sys_suspended;
>> +	/* A flag to tell whether hba is system suspended */
>> +	bool is_sys_suspended;
>> 
>>  	enum bkops_status urgent_bkops_lvl;
>>  	bool is_urgent_bkops_lvl_checked;
>> 
