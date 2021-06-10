Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0488FC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 11:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE82C613F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 11:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFJLRJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:17:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:61539 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhFJLRI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 07:17:08 -0400
IronPort-SDR: sk8C9x06PQbAvDUKuypin6IIJNBXncYDcTDeTgmUcAHEEe1g6ECPT3ngLX1zrLyq2qwQI0w1bu
 5V2TJhX+kXhQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="203430678"
X-IronPort-AV: E=Sophos;i="5.83,263,1616482800"; 
   d="scan'208";a="203430678"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 04:15:06 -0700
IronPort-SDR: XnqcV3Q9BMBVPvWBtSITBeTxQQ8i5OPYsrWDZt8lD7F/zaC8CqOb9T5Y/c25xWYydostiuL9DQ
 xxbhTJ4iDtKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,263,1616482800"; 
   d="scan'208";a="402825980"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.79]) ([10.237.72.79])
  by orsmga003.jf.intel.com with ESMTP; 10 Jun 2021 04:15:00 -0700
Subject: Re: [PATCH v3 1/9] scsi: ufs: Differentiate status between hba pm ops
 and wl pm ops
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-2-git-send-email-cang@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <7d7a771f-6595-0106-8ee5-4e6407caee56@intel.com>
Date:   Thu, 10 Jun 2021 14:15:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623300218-9454-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/06/21 7:43 am, Can Guo wrote:
> Put pm_op_in_progress and is_sys_suspend flags back to ufshcd hba pm ops,
> add two new flags, namely wl_pm_op_in_progress and is_wl_sys_suspended, to
> track the UFS device W-LU pm ops. This helps us differentiate the status of
> hba and wl pm ops when we need to do troubleshooting.

Really you have 2 changes here:
1. Renaming to pm_op_in_progress / is_sys_suspend to wl_pm_op_in_progress / is_wl_sys_suspended
2. Introducing flags for the status of hba

So it should really be 2 patches.

That would show up things like:
- did you intend not to change hba->is_sys_suspended in ufs_qcom_resume() ?

> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 42 ++++++++++++++++++++++++++++--------------
>  drivers/scsi/ufs/ufshcd.h |  4 +++-
>  2 files changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 25fe18a..47b2a9a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -549,7 +549,9 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
>  		hba->saved_err, hba->saved_uic_err);
>  	dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
> -	dev_err(hba->dev, "PM in progress=%d, sys. suspended=%d\n",
> +	dev_err(hba->dev, "wl_pm_op_in_progress=%d, is_wl_sys_suspended=%d\n",
> +		hba->wl_pm_op_in_progress, hba->is_wl_sys_suspended);
> +	dev_err(hba->dev, "pm_op_in_progress=%d, is_sys_suspended=%d\n",
>  		hba->pm_op_in_progress, hba->is_sys_suspended);
>  	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
>  		hba->auto_bkops_enabled, hba->host->host_self_blocked);
> @@ -1999,7 +2001,7 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
>  	if (!hba->clk_scaling.active_reqs++)
>  		queue_resume_work = true;
>  
> -	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress) {
> +	if (!hba->clk_scaling.is_enabled || hba->wl_pm_op_in_progress) {
>  		spin_unlock_irqrestore(hba->host->host_lock, flags);
>  		return;
>  	}
> @@ -2734,7 +2736,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  		 * err handler blocked for too long. So, just fail the scsi cmd
>  		 * sent from PM ops, err handler can recover PM error anyways.
>  		 */
> -		if (hba->pm_op_in_progress) {
> +		if (hba->wl_pm_op_in_progress) {
>  			hba->force_reset = true;
>  			set_host_byte(cmd, DID_BAD_TARGET);
>  			cmd->scsi_done(cmd);
> @@ -2767,7 +2769,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  		(hba->clk_gating.state != CLKS_ON));
>  
>  	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
> -		if (hba->pm_op_in_progress)
> +		if (hba->wl_pm_op_in_progress)
>  			set_host_byte(cmd, DID_BAD_TARGET);
>  		else
>  			err = SCSI_MLQUEUE_HOST_BUSY;
> @@ -5116,7 +5118,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  			 * solution could be to abort the system suspend if
>  			 * UFS device needs urgent BKOPs.
>  			 */
> -			if (!hba->pm_op_in_progress &&
> +			if (!hba->wl_pm_op_in_progress &&
>  			    !ufshcd_eh_in_progress(hba) &&
>  			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
>  				/* Flushed in suspend */
> @@ -5916,7 +5918,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>  {
>  	ufshcd_rpm_get_sync(hba);
>  	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
> -	    hba->is_sys_suspended) {
> +	    hba->is_wl_sys_suspended) {
>  		enum ufs_pm_op pm_op;
>  
>  		/*
> @@ -5933,7 +5935,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>  		if (!ufshcd_is_clkgating_allowed(hba))
>  			ufshcd_setup_clocks(hba, true);
>  		ufshcd_release(hba);
> -		pm_op = hba->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
> +		pm_op = hba->is_wl_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
>  		ufshcd_vops_resume(hba, pm_op);
>  	} else {
>  		ufshcd_hold(hba, false);
> @@ -5976,7 +5978,7 @@ static void ufshcd_recover_pm_error(struct ufs_hba *hba)
>  	struct request_queue *q;
>  	int ret;
>  
> -	hba->is_sys_suspended = false;
> +	hba->is_wl_sys_suspended = false;
>  	/*
>  	 * Set RPM status of wlun device to RPM_ACTIVE,
>  	 * this also clears its runtime error.
> @@ -8784,7 +8786,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  	enum ufs_dev_pwr_mode req_dev_pwr_mode;
>  	enum uic_link_state req_link_state;
>  
> -	hba->pm_op_in_progress = true;
> +	hba->wl_pm_op_in_progress = true;
>  	if (pm_op != UFS_SHUTDOWN_PM) {
>  		pm_lvl = pm_op == UFS_RUNTIME_PM ?
>  			 hba->rpm_lvl : hba->spm_lvl;
> @@ -8919,7 +8921,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  		hba->clk_gating.is_suspended = false;
>  		ufshcd_release(hba);
>  	}
> -	hba->pm_op_in_progress = false;
> +	hba->wl_pm_op_in_progress = false;
>  	return ret;
>  }
>  
> @@ -8928,7 +8930,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  	int ret;
>  	enum uic_link_state old_link_state = hba->uic_link_state;
>  
> -	hba->pm_op_in_progress = true;
> +	hba->wl_pm_op_in_progress = true;
>  
>  	/*
>  	 * Call vendor specific resume callback. As these callbacks may access
> @@ -9006,7 +9008,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
>  	hba->clk_gating.is_suspended = false;
>  	ufshcd_release(hba);
> -	hba->pm_op_in_progress = false;
> +	hba->wl_pm_op_in_progress = false;
>  	return ret;
>  }
>  
> @@ -9072,7 +9074,7 @@ static int ufshcd_wl_suspend(struct device *dev)
>  
>  out:
>  	if (!ret)
> -		hba->is_sys_suspended = true;
> +		hba->is_wl_sys_suspended = true;
>  	trace_ufshcd_wl_suspend(dev_name(dev), ret,
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
> @@ -9100,7 +9102,7 @@ static int ufshcd_wl_resume(struct device *dev)
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>  	if (!ret)
> -		hba->is_sys_suspended = false;
> +		hba->is_wl_sys_suspended = false;
>  	up(&hba->host_sem);
>  	return ret;
>  }
> @@ -9141,6 +9143,8 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>  
>  	if (!hba->is_powered)
>  		return 0;
> +
> +	hba->pm_op_in_progress = true;
>  	/*
>  	 * Disable the host irq as host controller as there won't be any
>  	 * host controller transaction expected till resume.
> @@ -9160,6 +9164,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>  	ufshcd_vreg_set_lpm(hba);
>  	/* Put the host controller in low power mode if possible */
>  	ufshcd_hba_vreg_set_lpm(hba);
> +	hba->pm_op_in_progress = false;
>  	return ret;
>  }
>  
> @@ -9179,6 +9184,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
>  	if (!hba->is_powered)
>  		return 0;
>  
> +	hba->pm_op_in_progress = true;
>  	ufshcd_hba_vreg_set_hpm(hba);
>  	ret = ufshcd_vreg_set_hpm(hba);
>  	if (ret)
> @@ -9198,6 +9204,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
>  out:
>  	if (ret)
>  		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)ret);
> +	hba->pm_op_in_progress = false;
>  	return ret;
>  }
>  
> @@ -9222,6 +9229,10 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
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
> @@ -9248,6 +9259,9 @@ int ufshcd_system_resume(struct ufs_hba *hba)
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
> index c98d540..eaebb4e 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -752,7 +752,8 @@ struct ufs_hba {
>  	enum ufs_pm_level spm_lvl;
>  	struct device_attribute rpm_lvl_attr;
>  	struct device_attribute spm_lvl_attr;
> -	int pm_op_in_progress;
> +	bool pm_op_in_progress;
> +	bool wl_pm_op_in_progress;
>  
>  	/* Auto-Hibernate Idle Timer register value */
>  	u32 ahit;
> @@ -839,6 +840,7 @@ struct ufs_hba {
>  	struct devfreq *devfreq;
>  	struct ufs_clk_scaling clk_scaling;
>  	bool is_sys_suspended;
> +	bool is_wl_sys_suspended;
>  
>  	enum bkops_status urgent_bkops_lvl;
>  	bool is_urgent_bkops_lvl_checked;
> 

