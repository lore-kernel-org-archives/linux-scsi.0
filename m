From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 11/15] megaraid_sas: Make adprecovery variable atomic
Date: Tue, 19 Jan 2016 14:52:39 +0100
Message-ID: <569E3FA7.80004@redhat.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-12-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbcASNwm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 08:52:42 -0500
In-Reply-To: <1450445228-26571-12-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 18.12.2015 14:27, Sumit Saxena wrote:
> Make instance->adprecovery variable atomic and removes hba_lock spinlock while accessing instance->adprecovery.

adprecovery is a 8bit int, you don't do any arithmetic with it, the newly set values
do not depend on previous values - I think that an atomic variable is not needed. 

-tm

>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |    2 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c   |   95 ++++++++++-----------------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   27 ++++----
>  3 files changed, 50 insertions(+), 74 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 9d2b3da..ac19d53 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2101,7 +2101,7 @@ struct megasas_instance {
>  	u16 drv_supported_vd_count;
>  	u16 drv_supported_pd_count;
>  
> -	u8 adprecovery;
> +	atomic_t adprecovery;
>  	unsigned long last_time;
>  	u32 mfiStatus;
>  	u32 last_seq_num;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index edc26fb..5eaf6fd 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -483,7 +483,7 @@ static int
>  megasas_check_reset_xscale(struct megasas_instance *instance,
>  		struct megasas_register_set __iomem *regs)
>  {
> -	if ((instance->adprecovery != MEGASAS_HBA_OPERATIONAL) &&
> +	if ((atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) &&
>  	    (le32_to_cpu(*instance->consumer) ==
>  		MEGASAS_ADPRESET_INPROG_SIGN))
>  		return 1;
> @@ -619,7 +619,7 @@ static int
>  megasas_check_reset_ppc(struct megasas_instance *instance,
>  			struct megasas_register_set __iomem *regs)
>  {
> -	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL)
> +	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL)
>  		return 1;
>  
>  	return 0;
> @@ -756,7 +756,7 @@ static int
>  megasas_check_reset_skinny(struct megasas_instance *instance,
>  				struct megasas_register_set __iomem *regs)
>  {
> -	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL)
> +	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL)
>  		return 1;
>  
>  	return 0;
> @@ -950,9 +950,8 @@ static int
>  megasas_check_reset_gen2(struct megasas_instance *instance,
>  		struct megasas_register_set __iomem *regs)
>  {
> -	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
> +	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL)
>  		return 1;
> -	}
>  
>  	return 0;
>  }
> @@ -998,7 +997,7 @@ megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd *cmd)
>  	frame_hdr->cmd_status = MFI_STAT_INVALID_STATUS;
>  	frame_hdr->flags |= cpu_to_le16(MFI_FRAME_DONT_POST_IN_REPLY_QUEUE);
>  
> -	if ((instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) ||
> +	if ((atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) ||
>  		(instance->instancet->issue_dcmd(instance, cmd))) {
>  		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
>  			__func__, __LINE__);
> @@ -1026,7 +1025,7 @@ megasas_issue_blocked_cmd(struct megasas_instance *instance,
>  	int ret = 0;
>  	cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
>  
> -	if ((instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) ||
> +	if ((atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) ||
>  		(instance->instancet->issue_dcmd(instance, cmd))) {
>  		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
>  			__func__, __LINE__);
> @@ -1090,7 +1089,7 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
>  	cmd->sync_cmd = 1;
>  	cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
>  
> -	if ((instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) ||
> +	if ((atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) ||
>  		(instance->instancet->issue_dcmd(instance, cmd))) {
>  		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
>  			__func__, __LINE__);
> @@ -1653,7 +1652,6 @@ static int
>  megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>  {
>  	struct megasas_instance *instance;
> -	unsigned long flags;
>  	struct MR_PRIV_DEVICE *mr_device_priv_data;
>  
>  	instance = (struct megasas_instance *)
> @@ -1668,24 +1666,20 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>  	if (instance->issuepend_done == 0)
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  
> -	spin_lock_irqsave(&instance->hba_lock, flags);
>  
>  	/* Check for an mpio path and adjust behavior */
> -	if (instance->adprecovery == MEGASAS_ADPRESET_SM_INFAULT) {
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_ADPRESET_SM_INFAULT) {
>  		if (megasas_check_mpio_paths(instance, scmd) ==
>  		    (DID_RESET << 16)) {
> -			spin_unlock_irqrestore(&instance->hba_lock, flags);
>  			return SCSI_MLQUEUE_HOST_BUSY;
>  		} else {
> -			spin_unlock_irqrestore(&instance->hba_lock, flags);
>  			scmd->result = DID_NO_CONNECT << 16;
>  			scmd->scsi_done(scmd);
>  			return 0;
>  		}
>  	}
>  
> -	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
> -		spin_unlock_irqrestore(&instance->hba_lock, flags);
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
>  		scmd->result = DID_NO_CONNECT << 16;
>  		scmd->scsi_done(scmd);
>  		return 0;
> @@ -1693,23 +1687,17 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>  
>  	mr_device_priv_data = scmd->device->hostdata;
>  	if (!mr_device_priv_data) {
> -		spin_unlock_irqrestore(&instance->hba_lock, flags);
>  		scmd->result = DID_NO_CONNECT << 16;
>  		scmd->scsi_done(scmd);
>  		return 0;
>  	}
>  
> -	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
> -		spin_unlock_irqrestore(&instance->hba_lock, flags);
> +	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL)
>  		return SCSI_MLQUEUE_HOST_BUSY;
> -	}
>  
> -	if (mr_device_priv_data->tm_busy) {
> -		spin_unlock_irqrestore(&instance->hba_lock, flags);
> +	if (mr_device_priv_data->tm_busy)
>  		return SCSI_MLQUEUE_DEVICE_BUSY;
> -	}
>  
> -	spin_unlock_irqrestore(&instance->hba_lock, flags);
>  
>  	scmd->result = 0;
>  
> @@ -1943,7 +1931,7 @@ static void megasas_complete_outstanding_ioctls(struct megasas_instance *instanc
>  void megaraid_sas_kill_hba(struct megasas_instance *instance)
>  {
>  	/* Set critical error to block I/O & ioctls in case caller didn't */
> -	instance->adprecovery = MEGASAS_HW_CRITICAL_ERROR;
> +	atomic_set(&instance->adprecovery, MEGASAS_HW_CRITICAL_ERROR);
>  	/* Wait 1 second to ensure IO or ioctls in build have posted */
>  	msleep(1000);
>  	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
> @@ -2003,7 +1991,7 @@ static void megasas_complete_cmd_dpc(unsigned long instance_addr)
>  	unsigned long flags;
>  
>  	/* If we have already declared adapter dead, donot complete cmds */
> -	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
>  		return;
>  
>  	spin_lock_irqsave(&instance->completion_lock, flags);
> @@ -2072,7 +2060,7 @@ void megasas_do_ocr(struct megasas_instance *instance)
>  		*instance->consumer = cpu_to_le32(MEGASAS_ADPRESET_INPROG_SIGN);
>  	}
>  	instance->instancet->disable_intr(instance);
> -	instance->adprecovery   = MEGASAS_ADPRESET_SM_INFAULT;
> +	atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_INFAULT);
>  	instance->issuepend_done = 0;
>  
>  	atomic_set(&instance->fw_outstanding, 0);
> @@ -2471,18 +2459,14 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
>  	int i;
>  	u32 reset_index;
>  	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
> -	u8 adprecovery;
>  	unsigned long flags;
>  	struct list_head clist_local;
>  	struct megasas_cmd *reset_cmd;
>  	u32 fw_state;
>  	u8 kill_adapter_flag;
>  
> -	spin_lock_irqsave(&instance->hba_lock, flags);
> -	adprecovery = instance->adprecovery;
> -	spin_unlock_irqrestore(&instance->hba_lock, flags);
>  
> -	if (adprecovery != MEGASAS_HBA_OPERATIONAL) {
> +	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
>  
>  		INIT_LIST_HEAD(&clist_local);
>  		spin_lock_irqsave(&instance->hba_lock, flags);
> @@ -2493,18 +2477,13 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
>  		dev_notice(&instance->pdev->dev, "HBA reset wait ...\n");
>  		for (i = 0; i < wait_time; i++) {
>  			msleep(1000);
> -			spin_lock_irqsave(&instance->hba_lock, flags);
> -			adprecovery = instance->adprecovery;
> -			spin_unlock_irqrestore(&instance->hba_lock, flags);
> -			if (adprecovery == MEGASAS_HBA_OPERATIONAL)
> +			if (atomic_read(&instance->adprecovery) == MEGASAS_HBA_OPERATIONAL)
>  				break;
>  		}
>  
> -		if (adprecovery != MEGASAS_HBA_OPERATIONAL) {
> +		if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
>  			dev_notice(&instance->pdev->dev, "reset: Stopping HBA.\n");
> -			spin_lock_irqsave(&instance->hba_lock, flags);
> -			instance->adprecovery = MEGASAS_HW_CRITICAL_ERROR;
> -			spin_unlock_irqrestore(&instance->hba_lock, flags);
> +			atomic_set(&instance->adprecovery, MEGASAS_HW_CRITICAL_ERROR);
>  			return FAILED;
>  		}
>  
> @@ -2613,9 +2592,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
>  				&instance->reg_set->inbound_doorbell);
>  		}
>  		megasas_dump_pending_frames(instance);
> -		spin_lock_irqsave(&instance->hba_lock, flags);
> -		instance->adprecovery = MEGASAS_HW_CRITICAL_ERROR;
> -		spin_unlock_irqrestore(&instance->hba_lock, flags);
> +		atomic_set(&instance->adprecovery, MEGASAS_HW_CRITICAL_ERROR);
>  		return FAILED;
>  	}
>  
> @@ -2642,7 +2619,7 @@ static int megasas_generic_reset(struct scsi_cmnd *scmd)
>  	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET cmd=%x retries=%x\n",
>  		 scmd->cmnd[0], scmd->retries);
>  
> -	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
>  		dev_err(&instance->pdev->dev, "cannot recover from previous reset failures\n");
>  		return FAILED;
>  	}
> @@ -3386,13 +3363,13 @@ process_fw_state_change_wq(struct work_struct *work)
>  	u32 wait;
>  	unsigned long flags;
>  
> -	if (instance->adprecovery != MEGASAS_ADPRESET_SM_INFAULT) {
> +    if (atomic_read(&instance->adprecovery) != MEGASAS_ADPRESET_SM_INFAULT) {
>  		dev_notice(&instance->pdev->dev, "error, recovery st %x\n",
> -				instance->adprecovery);
> +				atomic_read(&instance->adprecovery));
>  		return ;
>  	}
>  
> -	if (instance->adprecovery == MEGASAS_ADPRESET_SM_INFAULT) {
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_ADPRESET_SM_INFAULT) {
>  		dev_notice(&instance->pdev->dev, "FW detected to be in fault"
>  					"state, restarting it...\n");
>  
> @@ -3435,7 +3412,7 @@ process_fw_state_change_wq(struct work_struct *work)
>  		megasas_issue_init_mfi(instance);
>  
>  		spin_lock_irqsave(&instance->hba_lock, flags);
> -		instance->adprecovery	= MEGASAS_HBA_OPERATIONAL;
> +		atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
>  		spin_unlock_irqrestore(&instance->hba_lock, flags);
>  		instance->instancet->enable_intr(instance);
>  
> @@ -3500,14 +3477,14 @@ megasas_deplete_reply_queue(struct megasas_instance *instance,
>  
>  
>  			instance->instancet->disable_intr(instance);
> -			instance->adprecovery	= MEGASAS_ADPRESET_SM_INFAULT;
> +			atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_INFAULT);
>  			instance->issuepend_done = 0;
>  
>  			atomic_set(&instance->fw_outstanding, 0);
>  			megasas_internal_reset_defer_cmds(instance);
>  
>  			dev_notice(&instance->pdev->dev, "fwState=%x, stage:%d\n",
> -					fw_state, instance->adprecovery);
> +					fw_state, atomic_read(&instance->adprecovery));
>  
>  			schedule_work(&instance->work_init);
>  			return IRQ_HANDLED;
> @@ -5796,7 +5773,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
>  	instance->flag_ieee = 0;
>  	instance->ev = NULL;
>  	instance->issuepend_done = 1;
> -	instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
> +	atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
>  	instance->is_imr = 0;
>  
>  	instance->evt_detail = pci_alloc_consistent(pdev,
> @@ -5975,7 +5952,7 @@ static void megasas_flush_cache(struct megasas_instance *instance)
>  	struct megasas_cmd *cmd;
>  	struct megasas_dcmd_frame *dcmd;
>  
> -	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
>  		return;
>  
>  	cmd = megasas_get_cmd(instance);
> @@ -6018,7 +5995,7 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
>  	struct megasas_cmd *cmd;
>  	struct megasas_dcmd_frame *dcmd;
>  
> -	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
>  		return;
>  
>  	cmd = megasas_get_cmd(instance);
> @@ -6463,7 +6440,7 @@ static int megasas_set_crash_dump_params_ioctl(struct megasas_cmd *cmd)
>  	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
>  		local_instance = megasas_mgmt_info.instance[i];
>  		if (local_instance && local_instance->crash_dump_drv_support) {
> -			if ((local_instance->adprecovery ==
> +			if ((atomic_read(&local_instance->adprecovery) ==
>  				MEGASAS_HBA_OPERATIONAL) &&
>  				!megasas_set_crash_dump_params(local_instance,
>  					crash_support)) {
> @@ -6711,7 +6688,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
>  		goto out_kfree_ioc;
>  	}
>  
> -	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
>  		dev_err(&instance->pdev->dev, "Controller in crit error\n");
>  		error = -ENODEV;
>  		goto out_kfree_ioc;
> @@ -6730,7 +6707,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
>  	for (i = 0; i < wait_time; i++) {
>  
>  		spin_lock_irqsave(&instance->hba_lock, flags);
> -		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL) {
> +		if (atomic_read(&instance->adprecovery) == MEGASAS_HBA_OPERATIONAL) {
>  			spin_unlock_irqrestore(&instance->hba_lock, flags);
>  			break;
>  		}
> @@ -6745,7 +6722,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
>  	}
>  
>  	spin_lock_irqsave(&instance->hba_lock, flags);
> -	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
> +	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
>  		spin_unlock_irqrestore(&instance->hba_lock, flags);
>  
>  		dev_err(&instance->pdev->dev, "timed out while"
> @@ -6787,7 +6764,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
>  	if (!instance)
>  		return -ENODEV;
>  
> -	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
>  		return -ENODEV;
>  	}
>  
> @@ -6798,7 +6775,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
>  	for (i = 0; i < wait_time; i++) {
>  
>  		spin_lock_irqsave(&instance->hba_lock, flags);
> -		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL) {
> +		if (atomic_read(&instance->adprecovery) == MEGASAS_HBA_OPERATIONAL) {
>  			spin_unlock_irqrestore(&instance->hba_lock,
>  						flags);
>  			break;
> @@ -6815,7 +6792,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
>  	}
>  
>  	spin_lock_irqsave(&instance->hba_lock, flags);
> -	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
> +	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
>  		spin_unlock_irqrestore(&instance->hba_lock, flags);
>  		dev_err(&instance->pdev->dev, "timed out while waiting"
>  				"for HBA to recover\n");
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 1248c7a..96e8d80 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -2251,7 +2251,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
>  
>  	fusion = instance->ctrl_context;
>  
> -	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
>  		return IRQ_HANDLED;
>  
>  	desc = fusion->reply_frames_desc[MSIxIndex] +
> @@ -2418,7 +2418,7 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
>  
>  	/* If we have already declared adapter dead, donot complete cmds */
>  	spin_lock_irqsave(&instance->hba_lock, flags);
> -	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
>  		spin_unlock_irqrestore(&instance->hba_lock, flags);
>  		return;
>  	}
> @@ -3200,7 +3200,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
>  	instance = (struct megasas_instance *)scmd->device->host->hostdata;
>  	fusion = instance->ctrl_context;
>  
> -	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
> +	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
>  		dev_err(&instance->pdev->dev, "Controller is not OPERATIONAL,"
>  		"SCSI host:%d\n", instance->host->host_no);
>  		ret = FAILED;
> @@ -3284,7 +3284,7 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
>  	instance = (struct megasas_instance *)scmd->device->host->hostdata;
>  	fusion = instance->ctrl_context;
>  
> -	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
> +	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
>  		dev_err(&instance->pdev->dev, "Controller is not OPERATIONAL,"
>  		"SCSI host:%d\n", instance->host->host_no);
>  		ret = FAILED;
> @@ -3376,7 +3376,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
>  
>  	mutex_lock(&instance->reset_mutex);
>  
> -	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
> +	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
>  		dev_warn(&instance->pdev->dev, "Hardware critical error, "
>  		       "returning FAILED for scsi%d.\n",
>  			instance->host->host_no);
> @@ -3391,7 +3391,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
>  		instance->crash_dump_app_support && reason) {
>  		dev_info(&instance->pdev->dev, "IO/DCMD timeout is detected, "
>  			"forcibly FAULT Firmware\n");
> -		instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
> +		atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_INFAULT);
>  		status_reg = readl(&instance->reg_set->doorbell);
>  		writel(status_reg | MFI_STATE_FORCE_OCR,
>  			&instance->reg_set->doorbell);
> @@ -3403,10 +3403,10 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
>  			dev_dbg(&instance->pdev->dev, "waiting for [%d] "
>  				"seconds for crash dump collection and OCR "
>  				"to be done\n", (io_timeout_in_crash_mode * 3));
> -		} while ((instance->adprecovery != MEGASAS_HBA_OPERATIONAL) &&
> +		} while ((atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) &&
>  			(io_timeout_in_crash_mode < 80));
>  
> -		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL) {
> +		if (atomic_read(&instance->adprecovery) == MEGASAS_HBA_OPERATIONAL) {
>  			dev_info(&instance->pdev->dev, "OCR done for IO "
>  				"timeout case\n");
>  			retval = SUCCESS;
> @@ -3423,14 +3423,14 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
>  	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
>  		del_timer_sync(&instance->sriov_heartbeat_timer);
>  	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
> -	instance->adprecovery = MEGASAS_ADPRESET_SM_POLLING;
> +	atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_POLLING);
>  	instance->instancet->disable_intr(instance);
>  	msleep(1000);
>  
>  	/* First try waiting for commands to complete */
>  	if (megasas_wait_for_outstanding_fusion(instance, reason,
>  						&convert)) {
> -		instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
> +		atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_INFAULT);
>  		dev_warn(&instance->pdev->dev, "resetting fusion "
>  		       "adapter scsi%d.\n", instance->host->host_no);
>  		if (convert)
> @@ -3513,8 +3513,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
>  					       status_reg);
>  					megaraid_sas_kill_hba(instance);
>  					instance->skip_heartbeat_timer_del = 1;
> -					instance->adprecovery =
> -						MEGASAS_HW_CRITICAL_ERROR;
> +					atomic_set(&instance->adprecovery, MEGASAS_HW_CRITICAL_ERROR);
>  					retval = FAILED;
>  					goto out;
>  				}
> @@ -3573,7 +3572,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
>  			clear_bit(MEGASAS_FUSION_IN_RESET,
>  				  &instance->reset_flags);
>  			instance->instancet->enable_intr(instance);
> -			instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
> +			atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
>  
>  			/* Restart SR-IOV heartbeat */
>  			if (instance->requestorId) {
> @@ -3618,7 +3617,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
>  		}
>  		clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
>  		instance->instancet->enable_intr(instance);
> -		instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
> +		atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
>  	}
>  out:
>  	clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);

