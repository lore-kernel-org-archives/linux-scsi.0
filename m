Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C4DC4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 12:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44A7761076
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 12:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhFWMf4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 08:35:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:42821 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhFWMf4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 08:35:56 -0400
IronPort-SDR: MH1aMG9iCdIpzQ7jE4qQk612ReISVLm2mB91R8NZ9jzvYFzZl4h6mU4t8ghHZECpooY47wJ/Og
 X1zFY5A5lMwA==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="205423464"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="205423464"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 05:33:26 -0700
IronPort-SDR: CoIbM9hMlkZZaXOB9WWWFvy8MOhN/dl5YS/M1dsRoU7BCSD9hj/45CC1rbHAPSxcKqbdC+ueyL
 gtQ71drzSBLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="406293937"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.79]) ([10.237.72.79])
  by orsmga006.jf.intel.com with ESMTP; 23 Jun 2021 05:33:21 -0700
Subject: Re: [PATCH v4 02/10] scsi: ufs: Add flags pm_op_in_progress and
 is_sys_suspended
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
        Satya Tangirala <satyat@google.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-3-git-send-email-cang@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <d9da89ac-cb40-d11b-5af3-5c948eb9b927@intel.com>
Date:   Wed, 23 Jun 2021 15:33:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624433711-9339-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/06/21 10:35 am, Can Guo wrote:
> Add flags pm_op_in_progress and is_sys_suspended to track the status of hba
> runtime and system suspend/resume operations.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 12 +++++++++++-
>  drivers/scsi/ufs/ufshcd.h |  4 ++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c40ba1d..abe5f2d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -551,6 +551,8 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>  	dev_err(hba->dev, "wlu_pm_op_in_progress=%d, is_wlu_sys_suspended=%d\n",
>  		hba->wlu_pm_op_in_progress, hba->is_wlu_sys_suspended);
> +	dev_err(hba->dev, "pm_op_in_progress=%d, is_sys_suspended=%d\n",
> +		hba->pm_op_in_progress, hba->is_sys_suspended);
>  	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
>  		hba->auto_bkops_enabled, hba->host->host_self_blocked);
>  	dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
> @@ -9141,6 +9143,8 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>  
>  	if (!hba->is_powered)
>  		return 0;
> +
> +	hba->pm_op_in_progress = true;
>  	/*
>  	 * Disable the host irq as host controller as there won't be any
>  	 * host controller transaction expected till resume.
	 */
	ufshcd_disable_irq(hba);
	ret = ufshcd_setup_clocks(hba, false);
	if (ret) {
		ufshcd_enable_irq(hba);

Is "hba->pm_op_in_progress = false" needed here?

		return ret;
	}



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
> @@ -9222,6 +9229,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>  	trace_ufshcd_system_suspend(dev_name(hba->dev), ret,
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
> +	if (!ret)
> +		hba->is_sys_suspended = true;
>  	return ret;
>  }
>  EXPORT_SYMBOL(ufshcd_system_suspend);
> @@ -9247,7 +9256,8 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>  	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
> -
> +	if (!ret)
> +		hba->is_sys_suspended = false;
>  	return ret;
>  }
>  EXPORT_SYMBOL(ufshcd_system_resume);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 93aeeb3..1e7fe73 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -754,6 +754,8 @@ struct ufs_hba {
>  	struct device_attribute spm_lvl_attr;
>  	/* A flag to tell whether __ufshcd_wl_suspend/resume() is in progress */
>  	bool wlu_pm_op_in_progress;
> +	/* A flag to tell whether ufshcd_suspend/resume() is in progress */
> +	bool pm_op_in_progress;
>  
>  	/* Auto-Hibernate Idle Timer register value */
>  	u32 ahit;
> @@ -841,6 +843,8 @@ struct ufs_hba {
>  	struct ufs_clk_scaling clk_scaling;
>  	/* A flag to tell whether the UFS device W-LU is system suspended */
>  	bool is_wlu_sys_suspended;
> +	/* A flag to tell whether hba is system suspended */
> +	bool is_sys_suspended;
>  
>  	enum bkops_status urgent_bkops_lvl;
>  	bool is_urgent_bkops_lvl_checked;
> 

