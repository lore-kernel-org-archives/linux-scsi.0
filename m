From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v5 10/15] scsi: ufs: fix error recovery after the hibern8
 exit failure
Date: Tue, 27 Oct 2015 14:59:17 -0000
Message-ID: <4339c7cfbc77135812744d7e3a94e50e.squirrel@www.codeaurora.org>
References: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
    <1445942657-6293-11-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445942657-6293-11-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>

> Hibern8 exit can be called from 3 different context:
>     - ufshcd_hibern8_exit_work
>     - ufshcd_ungate_work
>     - runtime/system resume
>
> If hibern8 exit fails for some reason then we try to bring the link to
> active state by link startup but this recovery mechanism results into
> deadlock or errors from first 2 context listed above. This change fixes
> the recovery by adding proper error handling mechanism.
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 58
> +++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 53 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ed134d6..60ba729 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -610,6 +610,11 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	hba->clk_gating.active_reqs++;
>
> +	if (ufshcd_eh_in_progress(hba)) {
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		return 0;
> +	}
> +
>  start:
>  	switch (hba->clk_gating.state) {
>  	case CLKS_ON:
> @@ -725,7 +730,8 @@ static void __ufshcd_release(struct ufs_hba *hba)
>  	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended
>  		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
>  		|| hba->lrb_in_use || hba->outstanding_tasks
> -		|| hba->active_uic_cmd || hba->uic_async_done)
> +		|| hba->active_uic_cmd || hba->uic_async_done
> +		|| ufshcd_eh_in_progress(hba))
>  		return;
>
>  	hba->clk_gating.state = REQ_CLKS_OFF;
> @@ -1363,6 +1369,13 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  		cmd->scsi_done(cmd);
>  		goto out_unlock;
>  	}
> +
> +	/* if error handling is in progress, don't issue commands */
> +	if (ufshcd_eh_in_progress(hba)) {
> +		set_host_byte(cmd, DID_ERROR);
> +		cmd->scsi_done(cmd);
> +		goto out_unlock;
> +	}
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>
>  	/* acquire the tag to make sure device cmds don't use it */
> @@ -2393,6 +2406,31 @@ out:
>  	return ret;
>  }
>
> +static int ufshcd_link_recovery(struct ufs_hba *hba)
> +{
> +	int ret;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	hba->ufshcd_state = UFSHCD_STATE_RESET;
> +	ufshcd_set_eh_in_progress(hba);
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +	ret = ufshcd_host_reset_and_restore(hba);
> +
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	if (ret)
> +		hba->ufshcd_state = UFSHCD_STATE_ERROR;
> +	ufshcd_clear_eh_in_progress(hba);
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +	if (ret)
> +		dev_err(hba->dev, "%s: link recovery failed, err %d",
> +			__func__, ret);
> +
> +	return ret;
> +}
> +
>  static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>  {
>  	int ret;
> @@ -2401,10 +2439,18 @@ static int __ufshcd_uic_hibern8_enter(struct
> ufs_hba *hba)
>  	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
>
> -	if (ret)
> +	if (ret) {
>  		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
>  			__func__, ret);
>
> +		/*
> +		 * If link recovery fails then return error so that caller
> +		 * don't retry the hibern8 enter again.
> +		 */
> +		if (ufshcd_link_recovery(hba))
> +			ret = -ENOLINK;
> +	}
> +
>  	return ret;
>  }
>
> @@ -2429,8 +2475,9 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba
> *hba)
>  	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
>  	if (ret) {
> -		ufshcd_set_link_off(hba);
> -		ret = ufshcd_host_reset_and_restore(hba);
> +		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
> +			__func__, ret);
> +		ret = ufshcd_link_recovery(hba);
>  	}
>
>  	return ret;
> @@ -4382,7 +4429,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  	/* UFS device is also active now */
>  	ufshcd_set_ufs_dev_active(hba);
>  	ufshcd_force_reset_auto_bkops(hba);
> -	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>  	hba->wlun_dev_clr_ua = true;
>
>  	if (ufshcd_get_max_pwr_mode(hba)) {
> @@ -4396,6 +4442,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  					__func__, ret);
>  	}
>
> +	/* set the state as operational after switching to desired gear */
> +	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>  	/*
>  	 * If we are in error handling context or in power management callbacks
>  	 * context, no need to scan the host
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
