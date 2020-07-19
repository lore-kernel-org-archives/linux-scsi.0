Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D4CC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 00:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4AD722BF5
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 00:27:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="WDsMAyMc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgGSA1Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 20:27:25 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:28240 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgGSA1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Jul 2020 20:27:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595118441; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=swEPo0oBNF4tJGqop/Mhxw/U3rvOKmFH9qZ+t3vofGU=;
 b=WDsMAyMcMeecUPdXYKO573c4gtlf2PqBR4otT9ffl31GlGgoPB/1G4WuiGvLZJ84Dk8P8lmZ
 d2sUJjlhcjwYSdE19LzVfI5h0Q8lu94jSoUwPsMn3Y39OpyiXeI5jCFiTa3pg39FcMcGr7KS
 sqkxEvxq3wZOY+oa6g5hkgz8DoY=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f139368f9ca681bd03395ba (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 19 Jul 2020 00:27:20
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8E8A6C4339C; Sun, 19 Jul 2020 00:27:19 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 38D64C433CA;
        Sun, 19 Jul 2020 00:27:18 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 19 Jul 2020 08:27:18 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Subject: Re: [RFC PATCH v1] ufs: introduce async ufs interface initialization
In-Reply-To: <1593678039-139543-1-git-send-email-kwmad.kim@samsung.com>
References: <CGME20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8@epcas2p2.samsung.com>
 <1593678039-139543-1-git-send-email-kwmad.kim@samsung.com>
Message-ID: <aea35acbf4a93c0068b19f05169801c5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kiwoong,

On 2020-07-02 16:20, Kiwoong Kim wrote:
> When you set uic_link_state during sleep statae to
> UIC_LINK_OFF_STATE, UFS driver does interface initialization
> that is a series of some steps including fDeviceInit and thus,
> You might feel that its latency is a little bit longer.
> 
> This patch is run it asynchronously to reduce system wake-up time.

Have you considered the existing async suspend/resume support from
kernel power management framework? Can device_enable_async_suspend()
serve your purpose?

I don't see how this change works in two ways

#1 During system resume, how do you make sure resume of children
devices come after the resume of their parent? To be more specific,
in UFS's case, how do you make sure scsi devices (sda, sdb...) start
to resume only AFTER hba resume is finished (I mean all steps in hba
probe finished, not just schedule the async resume work). Your test
passed only because that in current scsi device's resume ops, no actual
commands need to be sent during scsi devices resume. If some commands
need to be sent during scsi device resume (say SSU commands), you would
run into error since scsi commands are sent before host is fully 
resumed.
If you use kernel power management framework, during resume, dpm_wait()
is called for each device to make its parent has finished resuming.

#2 ufshcd_resume() is called in both hba system and runtime resume path.
Your change even makes hba runtime resume ops "async". How can you make
sure that hba is resumed after pm_runtime_get_sync() returns? Besides,
I don't think it can work well along with block layer PM.

Thanks,

Can Guo

> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/Kconfig  |  10 ++++
>  drivers/scsi/ufs/ufshcd.c | 120 
> ++++++++++++++++++++++++++++++++++------------
>  2 files changed, 100 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 8cd9026..723e7cb 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -172,3 +172,13 @@ config SCSI_UFS_EXYNOS
> 
>  	  Select this if you have UFS host controller on EXYNOS chipset.
>  	  If unsure, say N.
> +
> +config SCSI_UFSHCD_ASYNC_INIT
> +	bool "Asynchronous UFS interface initialization support"
> +	depends on SCSI_UFSHCD
> +	default n
> +	---help---
> +	This selects the support of doing UFS interface initialization
> +	asynchronously when you set link state to link off,
> +	i.e. UIC_LINK_OFF_STATE, to reduce system wake-up time.
> +	Select this if you have UFS Host Controller.
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 52abe82..b65d38c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8319,6 +8319,80 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	return ret;
>  }
> 
> +static int ufshcd_post_resume(struct ufs_hba *hba)
> +{
> +	int ret;
> +
> +	if (!ufshcd_is_ufs_dev_active(hba)) {
> +		ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
> +		ufshcd_enable_auto_bkops(hba);
> +	else
> +		/*
> +		 * If BKOPs operations are urgently needed at this moment then
> +		 * keep auto-bkops enabled or else disable it.
> +		 */
> +		ufshcd_urgent_bkops(hba);
> +
> +	hba->clk_gating.is_suspended = false;
> +
> +	if (hba->clk_scaling.is_allowed)
> +		ufshcd_resume_clkscaling(hba);
> +
> +	/* Enable Auto-Hibernate if configured */
> +	ufshcd_auto_hibern8_enable(hba);
> +
> +	if (hba->dev_info.b_rpm_dev_flush_capable) {
> +		hba->dev_info.b_rpm_dev_flush_capable = false;
> +		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
> +	}
> +
> +	/* Schedule clock gating in case of no access to UFS device yet */
> +	ufshcd_release(hba);
> +out:
> +	return ret;
> +}
> +
> +#if defined(SCSI_UFSHCD_ASYNC_INIT)
> +static void ufshcd_async_resume(void *data, async_cookie_t cookie)
> +{
> +	struct ufs_hba *hba = (struct ufs_hba *)data;
> +	unsigned long flags;
> +	int ret = 0;
> +	int retries = 2;
> +
> +	/* transition to block requests */
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	hba->ufshcd_state = UFSHCD_STATE_RESET;
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +	/* initialize, instead of set_old_link_state ?? */
> +	do {
> +		ret = ufshcd_reset_and_restore(hba);
> +		if (ret) {
> +			dev_err(hba->dev, "%s: reset and restore failed\n",
> +					__func__);
> +			spin_lock_irqsave(hba->host->host_lock, flags);
> +			hba->ufshcd_state = UFSHCD_STATE_ERROR;
> +			hba->pm_op_in_progress = 0;
> +			spin_unlock_irqrestore(hba->host->host_lock, flags);
> +			return;
> +		}
> +		ret = ufshcd_post_resume(hba);
> +	} while (ret && --retries);
> +	if (ret)
> +		goto reset;
> +
> +	hba->pm_op_in_progress = 0;
> +	if (ret)
> +		ufshcd_update_reg_hist(&hba->ufs_stats.resume_err, (u32)ret);
> +}
> +#endif
> +
>  /**
>   * ufshcd_resume - helper function for resume operations
>   * @hba: per adapter instance
> @@ -8370,6 +8444,14 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  		 * A full initialization of the host and the device is
>  		 * required since the link was put to off during suspend.
>  		 */
> +#if defined(SCSI_UFSHCD_ASYNC_INIT)
> +		/*
> +		 * Assuems error free since ufshcd_probe_hba failure is
> +		 * uncorrectable.
> +		 */
> +		ufshcd_async_schedule(ufshcd_async_resume, hba);
> +		goto out_new;
> +#else
>  		ret = ufshcd_reset_and_restore(hba);
>  		/*
>  		 * ufshcd_reset_and_restore() should have already
> @@ -8377,38 +8459,12 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  		 */
>  		if (ret || !ufshcd_is_link_active(hba))
>  			goto vendor_suspend;
> +#endif
>  	}
> 
> -	if (!ufshcd_is_ufs_dev_active(hba)) {
> -		ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
> -		if (ret)
> -			goto set_old_link_state;
> -	}
> -
> -	if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
> -		ufshcd_enable_auto_bkops(hba);
> -	else
> -		/*
> -		 * If BKOPs operations are urgently needed at this moment then
> -		 * keep auto-bkops enabled or else disable it.
> -		 */
> -		ufshcd_urgent_bkops(hba);
> -
> -	hba->clk_gating.is_suspended = false;
> -
> -	if (hba->clk_scaling.is_allowed)
> -		ufshcd_resume_clkscaling(hba);
> -
> -	/* Enable Auto-Hibernate if configured */
> -	ufshcd_auto_hibern8_enable(hba);
> -
> -	if (hba->dev_info.b_rpm_dev_flush_capable) {
> -		hba->dev_info.b_rpm_dev_flush_capable = false;
> -		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
> -	}
> -
> -	/* Schedule clock gating in case of no access to UFS device yet */
> -	ufshcd_release(hba);
> +	ret = ufshcd_post_resume(hba);
> +	if (ret)
> +		goto set_old_link_state;
> 
>  	goto out;
> 
> @@ -8427,6 +8483,10 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	hba->pm_op_in_progress = 0;
>  	if (ret)
>  		ufshcd_update_reg_hist(&hba->ufs_stats.resume_err, (u32)ret);
> +	/* For async init, pm_op_in_progress still needs to be one */
> +#if defined(SCSI_UFSHCD_ASYNC_INIT)
> +out_new:
> +#endif
>  	return ret;
>  }
