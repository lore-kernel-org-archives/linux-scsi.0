From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: Fix Runtime PM
Date: Tue, 21 Nov 2017 11:45:22 -0800
Message-ID: <182dc19cbdb877bd0f8dfd2d870c1a0f@codeaurora.org>
References: <20171113091426.15573-1-michalx.potomski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50394 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdKUTpY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Nov 2017 14:45:24 -0500
In-Reply-To: <20171113091426.15573-1-michalx.potomski@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Potomski <michalx.potomski@intel.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, szymonx.mielczarek@intel.com, linux-scsi-owner@vger.kernel.org



On 2017-11-13 01:14, Michal Potomski wrote:
> From: Michał Potomski <michalx.potomski@intel.com>
> 
> Recent testing of Runtime PM for UFS has shown it's not
> working as intended. To acheive fully working Runtime PM,
> first we have to put back scsi_device autopm reference counter.
> 
> Existing implementation was prone to races and not working for
> tranfsers to sleeping devices. This commit aims to fix this
> to acheive fully working environment. Due to runtime PM being
> previously disabled by not putting scsi_device autopm counter,
> the Runtime PM is set to be forbidden as default, to not cause
> problems with hosts and devices, which do not fully support
> different Device and Link states.
> 
> It can be still enabled through sysFS power/control attribute.
> 
> Changes since v1:
>  - Fix compilation error for certain kernel configs,
>  - Move pm_mark_last_busy(), only to relevant context.
> 
> Signed-off-by: Michał Potomski <michalx.potomski@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd-pci.c |  4 ++-
>  drivers/scsi/ufs/ufshcd.c     | 64 
> +++++++++++++++++++++++++++++++++++--------
>  2 files changed, 56 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c 
> b/drivers/scsi/ufs/ufshcd-pci.c
> index 925b0ec7ec54..4fffb1123876 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -184,8 +184,10 @@ ufshcd_pci_probe(struct pci_dev *pdev, const
> struct pci_device_id *id)
>  	}
> 
>  	pci_set_drvdata(pdev, hba);
> +	pm_runtime_set_autosuspend_delay(&pdev->dev, 3000);
> +	pm_runtime_use_autosuspend(&pdev->dev);
>  	pm_runtime_put_noidle(&pdev->dev);
> -	pm_runtime_allow(&pdev->dev);
> +	pm_runtime_forbid(&pdev->dev);
> 
>  	return 0;
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 011c3369082c..7ff7f51afe26 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -240,6 +240,37 @@ static inline bool ufshcd_valid_tag(struct
> ufs_hba *hba, int tag)
>  	return tag >= 0 && tag < hba->nutrs;
>  }
> 
> +#ifdef CONFIG_PM
> +static void ufshcd_pm_runtime_get(struct device *dev)
> +{
> +	// Don't trigger PM events while in transition states
> +	if (dev->power.runtime_status == RPM_RESUMING ||
> +	    dev->power.runtime_status == RPM_SUSPENDING)

Why do we need to check this? Isn't this check race condition prone?
> +		pm_runtime_get_noresume(dev);
> +	else
> +		pm_runtime_get_sync(dev);
> +}
> +
> +static void ufshcd_pm_runtime_put(struct device *dev)
> +{
> +	// Don't trigger PM events while in transition states
> +	if (dev->power.runtime_status == RPM_RESUMING ||
> +	    dev->power.runtime_status == RPM_SUSPENDING)
> +		pm_runtime_put_noidle(dev);
> +	else {
> +		pm_runtime_mark_last_busy(dev);
> +		pm_runtime_put_autosuspend(dev);
> +	}
> +}
> +#else
> +static void ufshcd_pm_runtime_get(struct device *dev)
> +{
> +}
> +static void ufshcd_pm_runtime_put(struct device *dev)
> +{
> +}
> +#endif
> +
>  static inline int ufshcd_enable_irq(struct ufs_hba *hba)
>  {
>  	int ret = 0;
> @@ -1345,7 +1376,7 @@ static ssize_t
> ufshcd_clkscale_enable_store(struct device *dev,
>  	if (value == hba->clk_scaling.is_allowed)
>  		goto out;
> 
> -	pm_runtime_get_sync(hba->dev);
> +	ufshcd_pm_runtime_get(hba->dev);
>  	ufshcd_hold(hba, false);
> 
>  	cancel_work_sync(&hba->clk_scaling.suspend_work);
> @@ -1364,7 +1395,7 @@ static ssize_t
> ufshcd_clkscale_enable_store(struct device *dev,
>  	}
> 
>  	ufshcd_release(hba);
> -	pm_runtime_put_sync(hba->dev);
> +	ufshcd_pm_runtime_put(hba->dev);
>  out:
>  	return count;
>  }
> @@ -1948,6 +1979,7 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct
> uic_command *uic_cmd)
>  	unsigned long flags;
> 
>  	ufshcd_hold(hba, false);
> +	ufshcd_pm_runtime_get(hba->dev);
>  	mutex_lock(&hba->uic_cmd_mutex);
>  	ufshcd_add_delay_before_dme_cmd(hba);
> 
> @@ -1959,6 +1991,7 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct
> uic_command *uic_cmd)
> 
>  	mutex_unlock(&hba->uic_cmd_mutex);
> 
> +	ufshcd_pm_runtime_put(hba->dev);
>  	ufshcd_release(hba);
>  	return ret;
>  }
> @@ -2345,6 +2378,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  		clear_bit_unlock(tag, &hba->lrb_in_use);
>  		goto out;
>  	}
> +	ufshcd_pm_runtime_get(hba->dev);


why do we need to hold PM reference count here? I thought as ufs host is 
parent of scsi_host/scsi_device, scsi would make sure that UFS host is 
runtime resumed before any access to it.

>  	WARN_ON(hba->clk_gating.state != CLKS_ON);
> 
>  	lrbp = &hba->lrb[tag];
> @@ -3555,6 +3589,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba
> *hba, struct uic_command *cmd)
>  	int ret;
>  	bool reenable_intr = false;
> 
> +	ufshcd_pm_runtime_get(hba->dev);
>  	mutex_lock(&hba->uic_cmd_mutex);
>  	init_completion(&uic_async_done);
>  	ufshcd_add_delay_before_dme_cmd(hba);
> @@ -3609,6 +3644,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba
> *hba, struct uic_command *cmd)
>  		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	mutex_unlock(&hba->uic_cmd_mutex);
> +	ufshcd_pm_runtime_put(hba->dev);
> 
>  	return ret;
>  }
> @@ -4386,6 +4422,7 @@ static int ufshcd_slave_configure(struct
> scsi_device *sdev)
> 
>  	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
>  	blk_queue_max_segment_size(q, PRDT_DATA_BYTE_COUNT_MAX);
> +	scsi_autopm_put_device(sdev);


scsi_sysfs_add_sdev() calls scsi_autopm_put_device() so not sure why 
this is required here?

> 
>  	return 0;
>  }
> @@ -4622,6 +4659,7 @@ static void __ufshcd_transfer_req_compl(struct
> ufs_hba *hba,
>  			/* Do not touch lrbp after scsi done */
>  			cmd->scsi_done(cmd);
>  			__ufshcd_release(hba);
> +			ufshcd_pm_runtime_put(hba->dev);
>  		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
>  			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
>  			if (hba->dev_cmd.complete) {
> @@ -4951,7 +4989,7 @@ static void
> ufshcd_exception_event_handler(struct work_struct *work)
>  	u32 status = 0;
>  	hba = container_of(work, struct ufs_hba, eeh_work);
> 
> -	pm_runtime_get_sync(hba->dev);
> +	ufshcd_pm_runtime_get(hba->dev);
>  	err = ufshcd_get_ee_status(hba, &status);
>  	if (err) {
>  		dev_err(hba->dev, "%s: failed to get exception status %d\n",
> @@ -4965,7 +5003,7 @@ static void
> ufshcd_exception_event_handler(struct work_struct *work)
>  		ufshcd_bkops_exception_event_handler(hba);
> 
>  out:
> -	pm_runtime_put_sync(hba->dev);
> +	ufshcd_pm_runtime_put(hba->dev);
>  	return;
>  }
> 
> @@ -5065,7 +5103,7 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
> 
>  	hba = container_of(work, struct ufs_hba, eh_work);
> 
> -	pm_runtime_get_sync(hba->dev);
> +	ufshcd_pm_runtime_get(hba->dev);
>  	ufshcd_hold(hba, false);
> 
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> @@ -5177,7 +5215,7 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	scsi_unblock_requests(hba->host);
>  	ufshcd_release(hba);
> -	pm_runtime_put_sync(hba->dev);
> +	ufshcd_pm_runtime_put(hba->dev);
>  }
> 
>  static void ufshcd_update_uic_reg_hist(struct ufs_uic_err_reg_hist 
> *reg_hist,
> @@ -6425,7 +6463,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  		}
> 
>  		scsi_scan_host(hba->host);
> -		pm_runtime_put_sync(hba->dev);
> +		ufshcd_pm_runtime_put(hba->dev);
>  	}
> 
>  	if (!hba->is_init_prefetch)
> @@ -6437,7 +6475,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  	 * present, turn off the power/clocks etc.
>  	 */
>  	if (ret && !ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
> -		pm_runtime_put_sync(hba->dev);
> +		ufshcd_pm_runtime_put(hba->dev);
>  		ufshcd_hba_exit(hba);
>  	}
> 
> @@ -7747,6 +7785,8 @@ EXPORT_SYMBOL(ufshcd_shutdown);
>  void ufshcd_remove(struct ufs_hba *hba)
>  {
>  	ufshcd_remove_sysfs_nodes(hba);
> +	// Resume if suspended for sync
> +	ufshcd_pm_runtime_get(hba->dev);
>  	scsi_remove_host(hba->host);
>  	/* disable interrupts */
>  	ufshcd_disable_intr(hba, hba->intr_mask);
> @@ -7756,6 +7796,8 @@ void ufshcd_remove(struct ufs_hba *hba)
>  	if (ufshcd_is_clkscaling_supported(hba))
>  		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
>  	ufshcd_hba_exit(hba);
> +	// Final sync finished - put it back
> +	ufshcd_pm_runtime_put(hba->dev);
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_remove);
> 
> @@ -7978,11 +8020,11 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  						UFS_SLEEP_PWR_MODE,
>  						UIC_LINK_HIBERN8_STATE);
>  	hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
> -						UFS_SLEEP_PWR_MODE,
> -						UIC_LINK_HIBERN8_STATE);
> +						UFS_POWERDOWN_PWR_MODE,
> +						UIC_LINK_OFF_STATE);

This may add lot of latencies on resume so not sure we want to change 
the default.

> 
>  	/* Hold auto suspend until async scan completes */
> -	pm_runtime_get_sync(dev);
> +	ufshcd_pm_runtime_get(dev);
> 
>  	/*
>  	 * We are assuming that device wasn't put in sleep/power-down

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
