Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4085BC48BD1
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 12:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23A9F61285
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 12:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhFJMbf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 08:31:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:19856 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhFJMbf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 08:31:35 -0400
IronPort-SDR: DY5l5zF7YIUK5Hzj5sy4m6K5241+w1CWbZcmCd+wkxx7S+AFGl2de6T3fjBcrrCI6sK2u6BKPA
 YsOHaBjPWwZw==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="226679576"
X-IronPort-AV: E=Sophos;i="5.83,263,1616482800"; 
   d="scan'208";a="226679576"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 05:29:36 -0700
IronPort-SDR: auYvsEbkvitNxBnp9Q9jAZZdi4V4bN1nU9ODjYE74zaETVUUwKqD6f3bZ4uxGu9I7BQuDbGuCb
 SD1s+5ZqbEZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,263,1616482800"; 
   d="scan'208";a="402844970"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.79]) ([10.237.72.79])
  by orsmga003.jf.intel.com with ESMTP; 10 Jun 2021 05:29:32 -0700
Subject: Re: [PATCH v3 5/9] scsi: ufs: Simplify error handling preparation
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
        open list <linux-kernel@vger.kernel.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-6-git-send-email-cang@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <6abb81f6-4dd2-082e-9440-4b549f105788@intel.com>
Date:   Thu, 10 Jun 2021 15:30:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623300218-9454-6-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/06/21 7:43 am, Can Guo wrote:
> Commit cb7e6f05fce67c965194ac04467e1ba7bc70b069 ("scsi: ufs: core: Enable
> power management for wlun") moves UFS operations out of ufshcd_resume(), so
> in error handling preparation, if ufshcd hba has failed to resume, there is
> no point to re-enable IRQ/clk/pwr.

I am not sure how cb7e6f05fce67c965194ac04467e1ba7bc70b069 made things any
different, but what I really wonder is why we don't just do recovery
directly in __ufshcd_wl_suspend() and  __ufshcd_wl_resume() and strip all
the PM complexity out of ufshcd_err_handling()?

> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 58 +++++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 7dc0fda..0afad6b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2727,8 +2727,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  		break;
>  	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
>  		/*
> -		 * pm_runtime_get_sync() is used at error handling preparation
> -		 * stage. If a scsi cmd, e.g. the SSU cmd, is sent from hba's
> +		 * ufshcd_rpm_get_sync() is used at error handling preparation
> +		 * stage. If a scsi cmd, e.g., the SSU cmd, is sent from the
>  		 * PM ops, it can never be finished if we let SCSI layer keep
>  		 * retrying it, which gets err handler stuck forever. Neither
>  		 * can we let the scsi cmd pass through, because UFS is in bad
> @@ -5915,29 +5915,26 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
>  	}
>  }
>  
> -static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
> +static int ufshcd_err_handling_prepare(struct ufs_hba *hba)
>  {
> +	/*
> +	 * Exclusively call pm_runtime_get_sync(hba->dev) once, in case
> +	 * following ufshcd_rpm_get_sync() fails.
> +	 */
> +	pm_runtime_get_sync(hba->dev);
> +	/* End of the world. */
> +	if (pm_runtime_suspended(hba->dev)) {
> +		pm_runtime_put(hba->dev);
> +		return -EINVAL;
> +	}
> +
> +	ufshcd_set_eh_in_progress(hba);
>  	ufshcd_rpm_get_sync(hba);
> -	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
> +	if (pm_runtime_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
>  	    hba->is_wl_sys_suspended) {
> -		enum ufs_pm_op pm_op;
> +		enum ufs_pm_op pm_op = hba->is_wl_sys_suspended ?
> +				       UFS_SYSTEM_PM : UFS_RUNTIME_PM;
>  
> -		/*
> -		 * Don't assume anything of resume, if
> -		 * resume fails, irq and clocks can be OFF, and powers
> -		 * can be OFF or in LPM.
> -		 */
> -		ufshcd_setup_hba_vreg(hba, true);
> -		ufshcd_setup_vreg(hba, true);
> -		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
> -		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
> -		ufshcd_hold(hba, false);
> -		if (!ufshcd_is_clkgating_allowed(hba)) {
> -			ufshcd_setup_clocks(hba, true);
> -			ufshcd_enable_irq(hba);
> -		}
> -		ufshcd_release(hba);
> -		pm_op = hba->is_wl_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
>  		ufshcd_vops_resume(hba, pm_op);
>  	} else {
>  		ufshcd_hold(hba, false);
> @@ -5951,22 +5948,25 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>  	down_write(&hba->clk_scaling_lock);
>  	up_write(&hba->clk_scaling_lock);
>  	cancel_work_sync(&hba->eeh_work);
> +	return 0;
>  }
>  
>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>  {
> +	ufshcd_clear_eh_in_progress(hba);
>  	ufshcd_scsi_unblock_requests(hba);
>  	ufshcd_release(hba);
>  	if (ufshcd_is_clkscaling_supported(hba))
>  		ufshcd_clk_scaling_suspend(hba, false);
>  	ufshcd_clear_ua_wluns(hba);
>  	ufshcd_rpm_put(hba);
> +	pm_runtime_put(hba->dev);
>  }
>  
>  static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
>  {
>  	return (!hba->is_powered || hba->shutting_down ||
> -		!hba->sdev_ufs_device ||
> +		!hba->sdev_ufs_device || hba->is_sys_suspended ||
>  		hba->ufshcd_state == UFSHCD_STATE_ERROR ||
>  		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
>  		   ufshcd_is_link_broken(hba))));
> @@ -6052,9 +6052,13 @@ static void ufshcd_err_handler(struct work_struct *work)
>  		up(&hba->host_sem);
>  		return;
>  	}
> -	ufshcd_set_eh_in_progress(hba);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -	ufshcd_err_handling_prepare(hba);
> +	if (ufshcd_err_handling_prepare(hba)) {
> +		dev_err(hba->dev, "%s: error handling preparation failed\n",
> +				__func__);
> +		up(&hba->host_sem);
> +		return;
> +	}
>  	/* Complete requests that have door-bell cleared by h/w */
>  	ufshcd_complete_requests(hba);
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> @@ -6198,7 +6202,6 @@ static void ufshcd_err_handler(struct work_struct *work)
>  			dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x saved_uic_err 0x%x",
>  			    __func__, hba->saved_err, hba->saved_uic_err);
>  	}
> -	ufshcd_clear_eh_in_progress(hba);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	ufshcd_err_handling_unprepare(hba);
>  	up(&hba->host_sem);
> @@ -8999,6 +9002,9 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  
>  	/* Enable Auto-Hibernate if configured */
>  	ufshcd_auto_hibern8_enable(hba);
> +
> +	hba->clk_gating.is_suspended = false;
> +	ufshcd_release(hba);
>  	goto out;
>  
>  set_old_link_state:
> @@ -9008,8 +9014,6 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  out:
>  	if (ret)
>  		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
> -	hba->clk_gating.is_suspended = false;
> -	ufshcd_release(hba);
>  	hba->wl_pm_op_in_progress = false;
>  	return ret <= 0 ? ret : -EINVAL;
>  }
> 

