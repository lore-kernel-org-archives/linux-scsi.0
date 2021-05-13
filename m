Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A49C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D2F4613C1
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhEMGAC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 02:00:02 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:10542 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230369AbhEMGAB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 May 2021 02:00:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620885531; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=q5KdQlOl1ylIUSIN0VQMcheb3G+UFc80HYRe5Ow63b4=;
 b=oWnP4XE3XmBd7s1OADAaVJiVvaVa0hkRxoocRIrfWjQ+q5p5wMu91oss7zlx7nZ+T/ZW5EVS
 G6CrpfkRLEPiuD6owu3lpO2uoZPLypkICD+GOpL7gyAqAnablBGPuYUOlCaI0pQ84eZmh7pT
 JSKr8X4fGngJ+TXlhoMWYFI8biQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 609cc01a7bf557a01295fdf4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 13 May 2021 05:58:50
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A0DB7C4338A; Thu, 13 May 2021 05:58:50 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A2949C433D3;
        Thu, 13 May 2021 05:58:48 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 13 May 2021 13:58:48 +0800
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/6] scsi: ufs: Differentiate status of hba and wl pm
 ops
In-Reply-To: <1620885319-15151-3-git-send-email-cang@codeaurora.org>
References: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
 <1620885319-15151-3-git-send-email-cang@codeaurora.org>
Message-ID: <37a48463f90d2fef55aab315acadb543@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Please ignore this one - it is duplicated.

On 2021-05-13 13:55, Can Guo wrote:
> Put pm_op_in_progress and is_sys_suspend flags back to ufshcd hba pm 
> ops,
> add two new flags, namely wl_pm_op_in_progress and is_wl_sys_suspended, 
> to
> track the UFS device W-LU pm ops. This helps us differentiate the 
> status of
> hba and wl pm ops when we need to do troubleshooting.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 42 
> ++++++++++++++++++++++++++++--------------
>  drivers/scsi/ufs/ufshcd.h |  4 +++-
>  2 files changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ab707a2..c69602b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -543,7 +543,9 @@ static void ufshcd_print_host_state(struct ufs_hba 
> *hba)
>  		hba->saved_err, hba->saved_uic_err);
>  	dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
> -	dev_err(hba->dev, "PM in progress=%d, sys. suspended=%d\n",
> +	dev_err(hba->dev, "wl_pm_op_in_progress=%d, 
> is_wl_sys_suspended=%d\n",
> +		hba->wl_pm_op_in_progress, hba->is_wl_sys_suspended);
> +	dev_err(hba->dev, "pm_op_in_progress=%d, is_sys_suspended=%d\n",
>  		hba->pm_op_in_progress, hba->is_sys_suspended);
>  	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
>  		hba->auto_bkops_enabled, hba->host->host_self_blocked);
> @@ -1991,7 +1993,7 @@ static void ufshcd_clk_scaling_start_busy(struct
> ufs_hba *hba)
>  	if (!hba->clk_scaling.active_reqs++)
>  		queue_resume_work = true;
> 
> -	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress)
> +	if (!hba->clk_scaling.is_enabled || hba->wl_pm_op_in_progress)
>  		return;
> 
>  	if (queue_resume_work)
> @@ -2640,7 +2642,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
> 
>  	lrbp = &hba->lrb[tag];
>  	if (unlikely(lrbp->in_use)) {
> -		if (hba->pm_op_in_progress)
> +		if (hba->wl_pm_op_in_progress)
>  			set_host_byte(cmd, DID_BAD_TARGET);
>  		else
>  			err = SCSI_MLQUEUE_HOST_BUSY;
> @@ -2687,7 +2689,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  		 * err handler blocked for too long. So, just fail the scsi cmd
>  		 * sent from PM ops, err handler can recover PM error anyways.
>  		 */
> -		if (hba->pm_op_in_progress) {
> +		if (hba->wl_pm_op_in_progress) {
>  			hba->force_reset = true;
>  			set_host_byte(cmd, DID_BAD_TARGET);
>  			goto out_compl_cmd;
> @@ -5036,7 +5038,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  			 * solution could be to abort the system suspend if
>  			 * UFS device needs urgent BKOPs.
>  			 */
> -			if (!hba->pm_op_in_progress &&
> +			if (!hba->wl_pm_op_in_progress &&
>  			    !ufshcd_eh_in_progress(hba) &&
>  			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
>  				/* Flushed in suspend */
> @@ -5799,7 +5801,7 @@ static void ufshcd_err_handling_prepare(struct
> ufs_hba *hba)
>  {
>  	ufshcd_rpm_get_sync(hba);
>  	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) 
> ||
> -	    hba->is_sys_suspended) {
> +	    hba->is_wl_sys_suspended) {
>  		enum ufs_pm_op pm_op;
> 
>  		/*
> @@ -5816,7 +5818,7 @@ static void ufshcd_err_handling_prepare(struct
> ufs_hba *hba)
>  		if (!ufshcd_is_clkgating_allowed(hba))
>  			ufshcd_setup_clocks(hba, true);
>  		ufshcd_release(hba);
> -		pm_op = hba->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
> +		pm_op = hba->is_wl_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
>  		ufshcd_vops_resume(hba, pm_op);
>  	} else {
>  		ufshcd_hold(hba, false);
> @@ -5859,7 +5861,7 @@ static void ufshcd_recover_pm_error(struct 
> ufs_hba *hba)
>  	struct request_queue *q;
>  	int ret;
> 
> -	hba->is_sys_suspended = false;
> +	hba->is_wl_sys_suspended = false;
>  	/*
>  	 * Set RPM status of wlun device to RPM_ACTIVE,
>  	 * this also clears its runtime error.
> @@ -8709,7 +8711,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba
> *hba, enum ufs_pm_op pm_op)
>  	enum ufs_dev_pwr_mode req_dev_pwr_mode;
>  	enum uic_link_state req_link_state;
> 
> -	hba->pm_op_in_progress = true;
> +	hba->wl_pm_op_in_progress = true;
>  	if (!ufshcd_is_shutdown_pm(pm_op)) {
>  		pm_lvl = ufshcd_is_runtime_pm(pm_op) ?
>  			 hba->rpm_lvl : hba->spm_lvl;
> @@ -8844,7 +8846,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba
> *hba, enum ufs_pm_op pm_op)
>  		hba->clk_gating.is_suspended = false;
>  		ufshcd_release(hba);
>  	}
> -	hba->pm_op_in_progress = false;
> +	hba->wl_pm_op_in_progress = false;
>  	return ret;
>  }
> 
> @@ -8853,7 +8855,7 @@ static int __ufshcd_wl_resume(struct ufs_hba
> *hba, enum ufs_pm_op pm_op)
>  	int ret;
>  	enum uic_link_state old_link_state = hba->uic_link_state;
> 
> -	hba->pm_op_in_progress = true;
> +	hba->wl_pm_op_in_progress = true;
> 
>  	/*
>  	 * Call vendor specific resume callback. As these callbacks may 
> access
> @@ -8931,7 +8933,7 @@ static int __ufshcd_wl_resume(struct ufs_hba
> *hba, enum ufs_pm_op pm_op)
>  		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
>  	hba->clk_gating.is_suspended = false;
>  	ufshcd_release(hba);
> -	hba->pm_op_in_progress = false;
> +	hba->wl_pm_op_in_progress = false;
>  	return ret;
>  }
> 
> @@ -8997,7 +8999,7 @@ static int ufshcd_wl_suspend(struct device *dev)
> 
>  out:
>  	if (!ret)
> -		hba->is_sys_suspended = true;
> +		hba->is_wl_sys_suspended = true;
>  	trace_ufshcd_wl_suspend(dev_name(dev), ret,
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
> @@ -9025,7 +9027,7 @@ static int ufshcd_wl_resume(struct device *dev)
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>  	if (!ret)
> -		hba->is_sys_suspended = false;
> +		hba->is_wl_sys_suspended = false;
>  	up(&hba->host_sem);
>  	return ret;
>  }
> @@ -9067,6 +9069,8 @@ static int ufshcd_suspend(struct ufs_hba *hba)
> 
>  	if (!hba->is_powered)
>  		return 0;
> +
> +	hba->pm_op_in_progress = true;
>  	/*
>  	 * Disable the host irq as host controller as there won't be any
>  	 * host controller transaction expected till resume.
> @@ -9086,6 +9090,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>  	ufshcd_vreg_set_lpm(hba);
>  	/* Put the host controller in low power mode if possible */
>  	ufshcd_hba_vreg_set_lpm(hba);
> +	hba->pm_op_in_progress = false;
>  	return ret;
>  }
> 
> @@ -9106,6 +9111,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
>  	if (!hba->is_powered)
>  		return 0;
> 
> +	hba->pm_op_in_progress = true;
>  	ufshcd_hba_vreg_set_hpm(hba);
>  	ret = ufshcd_vreg_set_hpm(hba);
>  	if (ret)
> @@ -9125,6 +9131,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
>  out:
>  	if (ret)
>  		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)ret);
> +	hba->pm_op_in_progress = false;
>  	return ret;
>  }
> 
> @@ -9150,6 +9157,10 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>  	trace_ufshcd_system_suspend(dev_name(hba->dev), ret,
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
> +
> +	if (!ret)
> +		hba->is_sys_suspended = true;
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(ufshcd_system_suspend);
> @@ -9176,6 +9187,9 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
> 
> +	if (!ret)
> +		hba->is_sys_suspended = false;
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(ufshcd_system_resume);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b8b4fe2..201dc49 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -739,7 +739,8 @@ struct ufs_hba {
>  	enum ufs_pm_level spm_lvl;
>  	struct device_attribute rpm_lvl_attr;
>  	struct device_attribute spm_lvl_attr;
> -	int pm_op_in_progress;
> +	bool pm_op_in_progress;
> +	bool wl_pm_op_in_progress;
> 
>  	/* Auto-Hibernate Idle Timer register value */
>  	u32 ahit;
> @@ -826,6 +827,7 @@ struct ufs_hba {
>  	struct devfreq *devfreq;
>  	struct ufs_clk_scaling clk_scaling;
>  	bool is_sys_suspended;
> +	bool is_wl_sys_suspended;
> 
>  	enum bkops_status urgent_bkops_lvl;
>  	bool is_urgent_bkops_lvl_checked;
