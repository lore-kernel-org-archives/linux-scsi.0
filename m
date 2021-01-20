Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF5DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 08:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980782251D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 08:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbhATIbx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 03:31:53 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:59279 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730925AbhATIad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 03:30:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611131405; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Mp4yQQCSbmzB8BgSXIJHw+hGvH34AKSc++wzgF8lU1E=;
 b=GEehKusQCkr5H4jc8wMjk6ItMPv2IbHEo6IkxC0p27CTzufLPW7G45lJJM/cRDHfW9bqzl8d
 kgpd3L7HtDWpd758O/LAX2ftD1Xf2zWje7FbgUZKJvzqBmqCMgqELDr+pUvwU7jBbSx4ChUe
 XMZUrEYIRApMvygDl7/HEeDbZf8=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6007e9f0e23dedcc3a5f08c5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Jan 2021 08:29:36
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 560FBC43465; Wed, 20 Jan 2021 08:29:35 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2EAB4C433CA;
        Wed, 20 Jan 2021 08:29:33 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 20 Jan 2021 16:29:33 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 1/3] scsi: ufs: Protect some contexts from unexpected
 clock scaling
In-Reply-To: <1611118491.1261.3.camel@mtkswgap22>
References: <1611057183-6925-1-git-send-email-cang@codeaurora.org>
 <1611057183-6925-2-git-send-email-cang@codeaurora.org>
 <1611118491.1261.3.camel@mtkswgap22>
Message-ID: <ee1bff22e19e522533f5e48b572c80e2@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-20 12:54, Stanley Chu wrote:
> Hi Can,
> 
> On Tue, 2021-01-19 at 03:52 -0800, Can Guo wrote:
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
>>  drivers/scsi/ufs/ufshcd.c | 83 
>> +++++++++++++++++++++++++++++------------------
>>  drivers/scsi/ufs/ufshcd.h |  6 +++-
>>  2 files changed, 56 insertions(+), 33 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 53fd59c..ba62d84 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1201,19 +1201,30 @@ static int ufshcd_clock_scaling_prepare(struct 
>> ufs_hba *hba)
>>  	 */
>>  	ufshcd_scsi_block_requests(hba);
>>  	down_write(&hba->clk_scaling_lock);
>> -	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
>> +
>> +	if (!hba->clk_scaling.is_allowed ||
>> +	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
>>  		ret = -EBUSY;
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
>> @@ -1228,13 +1239,11 @@ static void 
>> ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>>  static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>>  {
>>  	int ret = 0;
>> -
>> -	/* let's not get into low power until clock scaling is completed */
>> -	ufshcd_hold(hba, false);
>> +	bool is_writelock = true;
>> 
>>  	ret = ufshcd_clock_scaling_prepare(hba);
>>  	if (ret)
>> -		goto out;
>> +		return ret;
>> 
>>  	/* scale down the gear before scaling down clocks */
>>  	if (!scale_up) {
>> @@ -1260,14 +1269,12 @@ static int ufshcd_devfreq_scale(struct ufs_hba 
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
>> @@ -1541,7 +1548,7 @@ static ssize_t 
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
>> @@ -1555,7 +1562,7 @@ static ssize_t 
>> ufshcd_clkscale_enable_store(struct device *dev,
>>  		return -EINVAL;
>> 
>>  	value = !!value;
>> -	if (value == hba->clk_scaling.is_allowed)
>> +	if (value == hba->clk_scaling.is_enabled)
>>  		goto out;
>> 
>>  	pm_runtime_get_sync(hba->dev);
>> @@ -1564,7 +1571,7 @@ static ssize_t 
>> ufshcd_clkscale_enable_store(struct device *dev,
>>  	cancel_work_sync(&hba->clk_scaling.suspend_work);
>>  	cancel_work_sync(&hba->clk_scaling.resume_work);
>> 
>> -	hba->clk_scaling.is_allowed = value;
>> +	hba->clk_scaling.is_enabled = value;
>> 
>>  	if (value) {
>>  		ufshcd_resume_clkscaling(hba);
>> @@ -1902,8 +1909,6 @@ static void ufshcd_init_clk_scaling(struct 
>> ufs_hba *hba)
>>  	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
>>  		 hba->host->host_no);
>>  	hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
>> -
>> -	ufshcd_clkscaling_init_sysfs(hba);
>>  }
>> 
>>  static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
>> @@ -1911,6 +1916,8 @@ static void ufshcd_exit_clk_scaling(struct 
>> ufs_hba *hba)
>>  	if (!ufshcd_is_clkscaling_supported(hba))
>>  		return;
>> 
>> +	if (hba->clk_scaling.enable_attr.attr.name)
>> +		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
>>  	destroy_workqueue(hba->clk_scaling.workq);
>>  	ufshcd_devfreq_remove(hba);
>>  }
>> @@ -1975,7 +1982,7 @@ static void ufshcd_clk_scaling_start_busy(struct 
>> ufs_hba *hba)
>>  	if (!hba->clk_scaling.active_reqs++)
>>  		queue_resume_work = true;
>> 
>> -	if (!hba->clk_scaling.is_allowed || hba->pm_op_in_progress)
>> +	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress)
>>  		return;
>> 
>>  	if (queue_resume_work)
>> @@ -5093,7 +5100,8 @@ static void __ufshcd_transfer_req_compl(struct 
>> ufs_hba *hba,
>>  				update_scaling = true;
>>  			}
>>  		}
>> -		if (ufshcd_is_clkscaling_supported(hba) && update_scaling)
>> +		if (ufshcd_is_clkscaling_supported(hba) && update_scaling &&
> 
>> +		    hba->clk_scaling.active_reqs > 0)
> Do we need to check hba->clk_scaling.active_reqs here?
> 
> if hba->clk_scaling.active_reqs is possibly decreased to negative value
> here, then there may be something to be fixed?

No actual issue here, just want to be on the safe side.
Let me remove it in next version.

Thanks,
Can Guo.

> 
> Otherwise this patch looks good to me.
> 
> Thanks,
> Stanley Chu
> 
>>  			hba->clk_scaling.active_reqs--;
>>  	}
>> 
>> @@ -5759,18 +5767,24 @@ static void ufshcd_err_handling_prepare(struct 
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
>> @@ -7750,12 +7764,14 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
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
>> @@ -8672,11 +8688,14 @@ static int ufshcd_suspend(struct ufs_hba *hba, 
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
>> @@ -8773,8 +8792,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, 
>> enum ufs_pm_op pm_op)
>>  	goto out;
>> 
>>  set_link_active:
>> -	if (hba->clk_scaling.is_allowed)
>> -		ufshcd_resume_clkscaling(hba);
>>  	ufshcd_vreg_set_hpm(hba);
>>  	/*
>>  	 * Device hardware reset is required to exit DeepSleep. Also, for
>> @@ -8798,7 +8815,10 @@ static int ufshcd_suspend(struct ufs_hba *hba, 
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
>> @@ -8901,7 +8921,10 @@ static int ufshcd_resume(struct ufs_hba *hba, 
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
>> @@ -8925,8 +8948,6 @@ static int ufshcd_resume(struct ufs_hba *hba, 
>> enum ufs_pm_op pm_op)
>>  	ufshcd_vreg_set_lpm(hba);
>>  disable_irq_and_vops_clks:
>>  	ufshcd_disable_irq(hba);
>> -	if (hba->clk_scaling.is_allowed)
>> -		ufshcd_suspend_clkscaling(hba);
>>  	ufshcd_setup_clocks(hba, false);
>>  	if (ufshcd_is_clkgating_allowed(hba)) {
>>  		hba->clk_gating.state = CLKS_OFF;
>> @@ -9153,8 +9174,6 @@ void ufshcd_remove(struct ufs_hba *hba)
>> 
>>  	ufshcd_exit_clk_scaling(hba);
>>  	ufshcd_exit_clk_gating(hba);
>> -	if (ufshcd_is_clkscaling_supported(hba))
>> -		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
>>  	ufshcd_hba_exit(hba);
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_remove);
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 85f9d0f..d553e46 100644
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
