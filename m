Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F45CC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 10:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6ABB23136
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 10:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbhAMKua (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 05:50:30 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:47782 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbhAMKuT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 05:50:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610534998; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=CK3kaLtR6AqGwvBs5IsRHtwgSXrWdz3GgJ43/RnibKw=;
 b=BTztNYBabBKHBbtGMOAnbzncAHy9lcROt0OUpsxo7Ue+NqavjYRkPLN2UUGH4SP9V1gIS+p2
 x8ay67sB0nbjzPbCv96ZRICLLH5yBQXdWLDiRD5TyMMxEzur4x3Fl/7zfPp8bTNPCB18EaxH
 uIu7n/lvInrGR5YuCIfc3V81DPQ=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5ffed038415a6293c5cf11cd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 13 Jan 2021 10:49:28
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D7295C43468; Wed, 13 Jan 2021 10:49:27 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99171C433CA;
        Wed, 13 Jan 2021 10:49:25 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 13 Jan 2021 18:49:25 +0800
From:   Can Guo <cang@codeaurora.org>
To:     =?UTF-8?Q?=ED=99=A9=EB=91=90=ED=98=84?= <dh0421.hwang@samsung.com>
Cc:     adrian.hunter@intel.com, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, avri.altman@wdc.com, beanhuo@micron.com,
        hongwus@codeaurora.org, jejb@linux.ibm.com,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        nguyenb@codeaurora.org, rnayak@codeaurora.org, salyzyn@google.com,
        saravanak@google.com, satyat@google.com, stanley.chu@mediatek.com,
        grant.jung@samsung.com, jt77.jang@samsung.com,
        junwoo80.lee@samsung.com, sh043.lee@samsung.com,
        jangsub.yi@samsung.com, cw9316.lee@samsung.com,
        sh8267.baek@samsung.com, wkon.kim@samsung.com
Subject: Re: [PATCH v9 1/3] scsi: ufs: Protect some contexts from unexpected
 clock scaling
In-Reply-To: <00e401d6e994$e62e1660$b28a4320$@samsung.com>
References: <CGME20210113101438epcas1p21192b49fa1a079353ab36555478f32d8@epcas1p2.samsung.com>
 <00e401d6e994$e62e1660$b28a4320$@samsung.com>
Message-ID: <eeb48b97d094d0240813f6c7d6953d54@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-13 18:14, 황두현 wrote:
>> From: Can Guo <cang@codeaurora.org>
>> 
>> In contexts like suspend, shutdown and error handling, we need to 
>> suspend
>> devfreq to make sure these contexts won't be disturbed by clock 
>> scaling.
>> However, suspending devfreq is not enough since users can still 
>> trigger a
>> clock scaling by manipulating the devfreq sysfs nodes like 
>> min/max_freq and
>> governor even after devfreq is suspended. Moreover, mere suspending 
>> devfreq
>> cannot synchroinze a clock scaling which has already been invoked 
>> through
>> these sysfs nodes. Add one more flag in struct clk_scaling and wrap 
>> the
>> entire func ufshcd_devfreq_scale() with the clk_scaling_lock, so that 
>> we
>> can use this flag and clk_scaling_lock to control and synchronize 
>> clock
>> scaling invoked through devfreq sysfs nodes.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 86 
>> +++++++++++++++++++++++++++++------------------
>>  drivers/scsi/ufs/ufshcd.h |  6 +++-
>>  2 files changed, 59 insertions(+), 33 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 82ad317..64218e6 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1181,19 +1181,33 @@ static int ufshcd_clock_scaling_prepare(struct 
>> ufs_hba *hba)
>>  	 */
>>  	ufshcd_scsi_block_requests(hba);
>>  	down_write(&hba->clk_scaling_lock);
>> -	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
>> +
> 
> I think another value is better than -EAGAIN.
> Ex) -EPERM because the clk scaling is not allowed state.

-EPERM is usually used by IOCTL to tell users that
they don't have right permissions. -EAGAIN here tells
the caller that if it tries again, it may success, i.e
after hba is runtime resumed or error recovery is completed.

> 
>> +	if (!hba->clk_scaling.is_allowed)
>> +		ret = -EAGAIN;
> 
> I think ufshcd_hold() has to be called before access host registers,
> so calling ufshcd_hold() is better before calling
> ufshcd_clock_scaling_prepare().
> 
> If you want to do not anything when hba->clk_scaling.is_allowed is 
> false,
> it is recommended to check hba->clk_scaling.is_allowed before calling
> ufshcd_hold() in ufshcd_devfreq_scale().

Check ufshcd_wait_for_doorbell_clr(), it calls ufshcd_hold/release() 
inside.

> 
>> +	else if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US))
>>  		ret = -EBUSY;
>> +
>> +	if (ret) {
>>  		up_write(&hba->clk_scaling_lock);
>>  		ufshcd_scsi_unblock_requests(hba);
>> +		goto out;
>>  	}
>> 
>> +	/* let's not get into low power until clock scaling is completed */
>> +	ufshcd_hold(hba, false);
>> +
>> +out:
>>  	return ret;
>>  }
>> 
>> -static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>> +static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool 
>> writelock)
>>  {
>> -	up_write(&hba->clk_scaling_lock);
>> +	if (writelock)
>> +		up_write(&hba->clk_scaling_lock);
>> +	else
>> +		up_read(&hba->clk_scaling_lock);
>>  	ufshcd_scsi_unblock_requests(hba);
>> +	ufshcd_release(hba);
>>  }
>> 
>>  /**
>> @@ -1208,13 +1222,11 @@ static void 
>> ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>>  static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>>  {
>>  	int ret = 0;
>> -
>> -	/* let's not get into low power until clock scaling is completed */
>> -	ufshcd_hold(hba, false);
>> +	bool is_writelock = true;
>> 
> 
> I think it would be nice to call ufshcd_hold() here.

No, if hba is runtime suspended (rpm_lvl = 3/4/5),
calling ufshcd_hold() here shall fail, because you
are trying to exit hibern8 even when UFS is not
powered or VCCQ2/VCCQ in LPM.

So ufshcd_hold MUST come after hba->clk_scaling.is_allowed
check in prepare(), and the code is clean and tight if
ufshcd_hold() is put in prepare().

> 
>>  	ret = ufshcd_clock_scaling_prepare(hba);
>>  	if (ret)
> 
> Below change is not needed if calling ufshcd_hold() is before calling
> ufshcd_clock_scaling_prepare().
> 

See my comments above.

>> -		goto out;
>> +		return ret;
>> 
>>  	/* scale down the gear before scaling down clocks */
>>  	if (!scale_up) {
>> @@ -1240,14 +1252,12 @@ static int ufshcd_devfreq_scale(struct ufs_hba 
>> *hba, bool scale_up)
>>  	}
>> 
>>  	/* Enable Write Booster if we have scaled up else disable it */
>> -	up_write(&hba->clk_scaling_lock);
>> +	downgrade_write(&hba->clk_scaling_lock);
>> +	is_writelock = false;
>>  	ufshcd_wb_ctrl(hba, scale_up);
>> -	down_write(&hba->clk_scaling_lock);
>> 
>>  out_unprepare:
>> -	ufshcd_clock_scaling_unprepare(hba);
>> -out:
>> -	ufshcd_release(hba);
>> +	ufshcd_clock_scaling_unprepare(hba, is_writelock);
>>  	return ret;
>>  }
>> 
>> @@ -1521,7 +1531,7 @@ static ssize_t 
>> ufshcd_clkscale_enable_show(struct device *dev,
>>  {
>>  	struct ufs_hba *hba = dev_get_drvdata(dev);
>> 
>> -	return snprintf(buf, PAGE_SIZE, "%d\n", 
>> hba->clk_scaling.is_allowed);
>> +	return snprintf(buf, PAGE_SIZE, "%d\n", 
>> hba->clk_scaling.is_enabled);
>>  }
>> 
>>  static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
>> @@ -1535,7 +1545,7 @@ static ssize_t 
>> ufshcd_clkscale_enable_store(struct device *dev,
>>  		return -EINVAL;
>> 
>>  	value = !!value;
>> -	if (value == hba->clk_scaling.is_allowed)
>> +	if (value == hba->clk_scaling.is_enabled)
>>  		goto out;
>> 
>>  	pm_runtime_get_sync(hba->dev);
>> @@ -1544,7 +1554,7 @@ static ssize_t 
>> ufshcd_clkscale_enable_store(struct device *dev,
>>  	cancel_work_sync(&hba->clk_scaling.suspend_work);
>>  	cancel_work_sync(&hba->clk_scaling.resume_work);
>> 
>> -	hba->clk_scaling.is_allowed = value;
>> +	hba->clk_scaling.is_enabled = value;
>> 
>>  	if (value) {
>>  		ufshcd_resume_clkscaling(hba);
>> @@ -1882,8 +1892,6 @@ static void ufshcd_init_clk_scaling(struct 
>> ufs_hba *hba)
>>  	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
>>  		 hba->host->host_no);
>>  	hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
>> -
>> -	ufshcd_clkscaling_init_sysfs(hba);
>>  }
>> 
>>  static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
>> @@ -1891,6 +1899,8 @@ static void ufshcd_exit_clk_scaling(struct 
>> ufs_hba *hba)
>>  	if (!ufshcd_is_clkscaling_supported(hba))
>>  		return;
>> 
>> +	if (hba->clk_scaling.enable_attr.attr.name)
>> +		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
>>  	destroy_workqueue(hba->clk_scaling.workq);
>>  	ufshcd_devfreq_remove(hba);
>>  }
>> @@ -1955,7 +1965,7 @@ static void ufshcd_clk_scaling_start_busy(struct 
>> ufs_hba *hba)
>>  	if (!hba->clk_scaling.active_reqs++)
>>  		queue_resume_work = true;
>> 
>> -	if (!hba->clk_scaling.is_allowed || hba->pm_op_in_progress)
>> +	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress)
>>  		return;
>> 
>>  	if (queue_resume_work)
>> @@ -5071,7 +5081,8 @@ static void __ufshcd_transfer_req_compl(struct 
>> ufs_hba *hba,
>>  				update_scaling = true;
>>  			}
>>  		}
>> -		if (ufshcd_is_clkscaling_supported(hba) && update_scaling)
>> +		if (ufshcd_is_clkscaling_supported(hba) && update_scaling &&
>> +		    hba->clk_scaling.active_reqs > 0)
>>  			hba->clk_scaling.active_reqs--;
>>  	}
>> 
>> @@ -5737,18 +5748,24 @@ static void ufshcd_err_handling_prepare(struct 
>> ufs_hba *hba)
>>  		ufshcd_vops_resume(hba, pm_op);
>>  	} else {
>>  		ufshcd_hold(hba, false);
>> -		if (hba->clk_scaling.is_allowed) {
>> +		if (hba->clk_scaling.is_enabled) {
>>  			cancel_work_sync(&hba->clk_scaling.suspend_work);
>>  			cancel_work_sync(&hba->clk_scaling.resume_work);
>>  			ufshcd_suspend_clkscaling(hba);
>>  		}
>> +		down_write(&hba->clk_scaling_lock);
>> +		hba->clk_scaling.is_allowed = false;
>> +		up_write(&hba->clk_scaling_lock);
>>  	}
>>  }
>> 
>>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>>  {
>>  	ufshcd_release(hba);
>> -	if (hba->clk_scaling.is_allowed)
>> +	down_write(&hba->clk_scaling_lock);
>> +	hba->clk_scaling.is_allowed = true;
>> +	up_write(&hba->clk_scaling_lock);
>> +	if (hba->clk_scaling.is_enabled)
>>  		ufshcd_resume_clkscaling(hba);
>>  	pm_runtime_put(hba->dev);
>>  }
>> @@ -7728,12 +7745,14 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>>  			sizeof(struct ufs_pa_layer_attr));
>>  		hba->clk_scaling.saved_pwr_info.is_valid = true;
>>  		if (!hba->devfreq) {
>> +			hba->clk_scaling.is_allowed = true;
>>  			ret = ufshcd_devfreq_init(hba);
>>  			if (ret)
>>  				goto out;
>> -		}
>> 
>> -		hba->clk_scaling.is_allowed = true;
>> +			hba->clk_scaling.is_enabled = true;
>> +			ufshcd_clkscaling_init_sysfs(hba);
>> +		}
>>  	}
>> 
>>  	ufs_bsg_probe(hba);
>> @@ -8650,11 +8669,14 @@ static int ufshcd_suspend(struct ufs_hba *hba, 
>> enum ufs_pm_op pm_op)
>>  	ufshcd_hold(hba, false);
>>  	hba->clk_gating.is_suspended = true;
>> 
>> -	if (hba->clk_scaling.is_allowed) {
>> +	if (hba->clk_scaling.is_enabled) {
>>  		cancel_work_sync(&hba->clk_scaling.suspend_work);
>>  		cancel_work_sync(&hba->clk_scaling.resume_work);
>>  		ufshcd_suspend_clkscaling(hba);
>>  	}
>> +	down_write(&hba->clk_scaling_lock);
>> +	hba->clk_scaling.is_allowed = false;
>> +	up_write(&hba->clk_scaling_lock);
>> 
>>  	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
>>  			req_link_state == UIC_LINK_ACTIVE_STATE) {
>> @@ -8751,8 +8773,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, 
>> enum ufs_pm_op pm_op)
>>  	goto out;
>> 
>>  set_link_active:
>> -	if (hba->clk_scaling.is_allowed)
>> -		ufshcd_resume_clkscaling(hba);
>>  	ufshcd_vreg_set_hpm(hba);
>>  	/*
>>  	 * Device hardware reset is required to exit DeepSleep. Also, for
>> @@ -8776,7 +8796,10 @@ static int ufshcd_suspend(struct ufs_hba *hba, 
>> enum ufs_pm_op pm_op)
>>  	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
>>  		ufshcd_disable_auto_bkops(hba);
>>  enable_gating:
>> -	if (hba->clk_scaling.is_allowed)
>> +	down_write(&hba->clk_scaling_lock);
>> +	hba->clk_scaling.is_allowed = true;
>> +	up_write(&hba->clk_scaling_lock);
>> +	if (hba->clk_scaling.is_enabled)
>>  		ufshcd_resume_clkscaling(hba);
>>  	hba->clk_gating.is_suspended = false;
>>  	hba->dev_info.b_rpm_dev_flush_capable = false;
>> @@ -8879,7 +8902,10 @@ static int ufshcd_resume(struct ufs_hba *hba, 
>> enum ufs_pm_op pm_op)
>> 
>>  	hba->clk_gating.is_suspended = false;
>> 
>> -	if (hba->clk_scaling.is_allowed)
>> +	down_write(&hba->clk_scaling_lock);
>> +	hba->clk_scaling.is_allowed = true;
>> +	up_write(&hba->clk_scaling_lock);
>> +	if (hba->clk_scaling.is_enabled)
>>  		ufshcd_resume_clkscaling(hba);
>> 
>>  	/* Enable Auto-Hibernate if configured */
>> @@ -8903,8 +8929,6 @@ static int ufshcd_resume(struct ufs_hba *hba, 
>> enum ufs_pm_op pm_op)
>>  	ufshcd_vreg_set_lpm(hba);
>>  disable_irq_and_vops_clks:
>>  	ufshcd_disable_irq(hba);
>> -	if (hba->clk_scaling.is_allowed)
>> -		ufshcd_suspend_clkscaling(hba);
>>  	ufshcd_setup_clocks(hba, false);
>>  	if (ufshcd_is_clkgating_allowed(hba)) {
>>  		hba->clk_gating.state = CLKS_OFF;
>> @@ -9131,8 +9155,6 @@ void ufshcd_remove(struct ufs_hba *hba)
>> 
>>  	ufshcd_exit_clk_scaling(hba);
>>  	ufshcd_exit_clk_gating(hba);
>> -	if (ufshcd_is_clkscaling_supported(hba))
>> -		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
>>  	ufshcd_hba_exit(hba);
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_remove);
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index aa9ea35..2863af1 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -419,7 +419,10 @@ struct ufs_saved_pwr_info {
>>   * @suspend_work: worker to suspend devfreq
>>   * @resume_work: worker to resume devfreq
>>   * @min_gear: lowest HS gear to scale down to
>> - * @is_allowed: tracks if scaling is currently allowed or not
>> + * @is_enabled: tracks if scaling is currently enabled or not, 
>> controlled by
>> +		clkscale_enable sysfs node
>> + * @is_allowed: tracks if scaling is currently allowed or not, used 
>> to block
>> +		clock scaling which is not invoked from devfreq governor
>>   * @is_busy_started: tracks if busy period has started or not
>>   * @is_suspended: tracks if devfreq is suspended or not
>>   */
>> @@ -434,6 +437,7 @@ struct ufs_clk_scaling {
>>  	struct work_struct suspend_work;
>>  	struct work_struct resume_work;
>>  	u32 min_gear;
>> +	bool is_enabled;
>>  	bool is_allowed;
>>  	bool is_busy_started;
>>  	bool is_suspended;
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
>> Linux Foundation Collaborative Project.
> 
> --
> DooHyun Hwang
> Samsung Electronics
