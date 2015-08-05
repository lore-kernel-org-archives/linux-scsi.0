From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/4] cxlflash: Base error recovery support
Date: Wed, 05 Aug 2015 11:04:48 -0500
Message-ID: <55C23420.50905@linux.vnet.ibm.com>
References: <1438576402-32935-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:33783 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbHEQE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2015 12:04:58 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 5 Aug 2015 12:04:56 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 42A8C6E8041
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2015 11:56:40 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t75G4sFG62783540
	for <linux-scsi@vger.kernel.org>; Wed, 5 Aug 2015 16:04:54 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t75G4r3k025929
	for <linux-scsi@vger.kernel.org>; Wed, 5 Aug 2015 12:04:54 -0400
In-Reply-To: <1438576402-32935-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 08/02/2015 11:33 PM, Matthew R. Ochs wrote:

> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
> index ba070a5..3d6217a 100644
> --- a/drivers/scsi/cxlflash/common.h
> +++ b/drivers/scsi/cxlflash/common.h
> @@ -76,6 +76,12 @@ enum cxlflash_init_state {
>  	INIT_STATE_SCSI
>  };
> 
> +enum eeh_state {
> +	EEH_STATE_NONE,
> +	EEH_STATE_ACTIVE,
> +	EEH_STATE_FAILED
> +};

Can you use pdev->error_state and pci_channel_offline instead of duplicating this
state information in a private driver definition?

> +
>  /*
>   * Each context has its own set of resource handles that is visible
>   * only from that context.
> @@ -91,8 +97,6 @@ struct cxlflash_cfg {
> 
>  	ulong cxlflash_regs_pci;
> 
> -	wait_queue_head_t eeh_waitq;
> -
>  	struct work_struct work_q;
>  	enum cxlflash_init_state init_state;
>  	enum cxlflash_lr_state lr_state;
> @@ -105,7 +109,8 @@ struct cxlflash_cfg {
>  	wait_queue_head_t tmf_waitq;
>  	spinlock_t tmf_slock;
>  	bool tmf_active;
> -	u8 err_recovery_active:1;
> +	wait_queue_head_t eeh_waitq;
> +	enum eeh_state eeh_active;
>  };
> 
>  struct afu_cmd {
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index ae2351a..9515525 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -524,6 +524,18 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>  	}
>  	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
> 
> +	switch (cfg->eeh_active) {
> +	case EEH_STATE_ACTIVE:
> +		pr_debug_ratelimited("%s: BUSY w/ EEH Recovery!\n", __func__);
> +		rc = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	case EEH_STATE_FAILED:
> +		pr_debug_ratelimited("%s: device has failed!\n", __func__);
> +		goto out;
> +	case EEH_STATE_NONE:
> +		break;
> +	}
> +
>  	cmd = cmd_checkout(afu);
>  	if (unlikely(!cmd)) {
>  		dev_err(dev, "%s: could not get a free command\n", __func__);
> @@ -1694,6 +1706,10 @@ static int init_afu(struct cxlflash_cfg *cfg)
>  	struct afu *afu = cfg->afu;
>  	struct device *dev = &cfg->dev->dev;
> 
> +#ifdef CONFIG_CXL_EEH
> +	cxl_perst_reloads_same_image(afu, val) 
> +#endif

I'd suggest moving this to a .h and defining the function as a noop there if appropriate, something
like:

#ifndef CONFIG_CXL_EEH
#define cxl_perst_reloads_same_image(cfg->cxl_afu, true) do { } while(0)
#endif


> +
>  	rc = init_mc(cfg);
>  	if (rc) {
>  		dev_err(dev, "%s: call to init_mc failed, rc=%d!\n",
> @@ -1748,6 +1764,12 @@ err1:
>   * the sync. This design point requires calling threads to not be on interrupt
>   * context due to the possibility of sleeping during concurrent sync operations.
>   *
> + * AFU sync operations should be gated during EEH recovery. When a recovery
> + * fails and an adapter is to be removed, sync requests can occur as part of
> + * cleaning up resources associated with an adapter prior to its removal. In
> + * this scenario, these requests are identified here and simply ignored (safe
> + * due to the AFU going away).
> + *
>   * Return:
>   *	0 on success
>   *	-1 on failure
> @@ -1762,6 +1784,11 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
>  	int retry_cnt = 0;
>  	static DEFINE_MUTEX(sync_active);
> 
> +	if (cfg->eeh_active == EEH_STATE_FAILED) {
> +		pr_debug("%s: Sync not required due to EEH state!\n", __func__);
> +		return 0;
> +	}
> +
>  	mutex_lock(&sync_active);
>  retry:
>  	cmd = cmd_checkout(afu);
> @@ -1857,9 +1884,18 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
> 
> -	rcr = send_tmf(afu, scp, TMF_LUN_RESET);
> -	if (unlikely(rcr))
> -		rc = FAILED;
> +	switch (cfg->eeh_active) {
> +	case EEH_STATE_NONE:
> +		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
> +		if (unlikely(rcr))
> +			rc = FAILED;
> +		break;
> +	case EEH_STATE_ACTIVE:
> +		wait_event(cfg->eeh_waitq, cfg->eeh_active != EEH_STATE_ACTIVE);
> +		break;
> +	case EEH_STATE_FAILED:
> +		break;
> +	}
> 
>  	pr_debug("%s: returning rc=%d\n", __func__, rc);
>  	return rc;
> @@ -1889,11 +1925,23 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
> 
> -	rcr = afu_reset(cfg);
> -	if (rcr == 0)
> -		rc = SUCCESS;
> -	else
> -		rc = FAILED;
> +	switch (cfg->eeh_active) {
> +	case EEH_STATE_NONE:
> +		cfg->eeh_active = EEH_STATE_FAILED;

Seems a little strange to be messing with the EEH state machine here when EEH isn't even at play.
If you can't switch to use the existing EEH state machine in the pdev struct, suggest renaming
this internal state machine to something more accurate and using the pdev EEH state machine where you can.
Same goes for the eeh_waitq...

> +		rcr = afu_reset(cfg);
> +		if (rcr == 0)
> +			rc = SUCCESS;
> +		else
> +			rc = FAILED;
> +		cfg->eeh_active = EEH_STATE_NONE;
> +		wake_up_all(&cfg->eeh_waitq);
> +		break;
> +	case EEH_STATE_ACTIVE:
> +		wait_event(cfg->eeh_waitq, cfg->eeh_active != EEH_STATE_ACTIVE);
> +		break;
> +	case EEH_STATE_FAILED:
> +		break;
> +	}
> 
>  	pr_debug("%s: returning rc=%d\n", __func__, rc);
>  	return rc;
> @@ -2145,6 +2193,11 @@ static void cxlflash_worker_thread(struct work_struct *work)
>  	int port;
>  	ulong lock_flags;
> 
> +	/* Avoid MMIO if the device has failed */
> +
> +	if (cfg->eeh_active == EEH_STATE_FAILED)
> +		return;
> +
>  	spin_lock_irqsave(cfg->host->host_lock, lock_flags);
> 
>  	if (cfg->lr_state == LINK_RESET_REQUIRED) {
> @@ -2226,6 +2279,8 @@ static int cxlflash_probe(struct pci_dev *pdev,
> 
>  	cfg->init_state = INIT_STATE_NONE;
>  	cfg->dev = pdev;
> +
> +	cfg->eeh_active = EEH_STATE_NONE;
>  	cfg->dev_id = (struct pci_device_id *)dev_id;
> 
> 
> @@ -2286,6 +2341,85 @@ out_remove:
>  	goto out;
>  }
> 
> +/**
> + * cxlflash_pci_error_detected() - called when a PCI error is detected
> + * @pdev:	PCI device struct.
> + * @state:	PCI channel state.
> + *
> + * Return: PCI_ERS_RESULT_NEED_RESET or PCI_ERS_RESULT_DISCONNECT
> + */
> +static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
> +						    pci_channel_state_t state)
> +{
> +	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
> +
> +	pr_debug("%s: pdev=%p state=%u\n", __func__, pdev, state);
> +
> +	switch (state) {
> +	case pci_channel_io_frozen:
> +		cfg->eeh_active = EEH_STATE_ACTIVE;
> +		udelay(100);
> +

I think this udelay needs a comment...

I'd suggest calling scsi_block_requests here to stop your queuecommand function from being called.
Note that this won't stop EH commands from being sent, so you will still need to check this
in queuecommand, although the right thing to do may be to fix scsi_send_eh_cmnd to not call
queuecommand if the host is blocked.

You'd then need to call scsi_unblock_requests when EEH in the perm failure and resume cases.

> +		term_mc(cfg, UNDO_START);
> +		stop_afu(cfg);
> +
> +		return PCI_ERS_RESULT_CAN_RECOVER;
> +	case pci_channel_io_perm_failure:
> +		cfg->eeh_active = EEH_STATE_FAILED;
> +		wake_up_all(&cfg->eeh_waitq);
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	default:
> +		break;
> +	}
> +	return PCI_ERS_RESULT_NEED_RESET;
> +}
> +
> +/**
> + * cxlflash_pci_slot_reset() - called when PCI slot has been reset
> + * @pdev:	PCI device struct.
> + *
> + * This routine is called by the pci error recovery code after the PCI
> + * slot has been reset, just before we should resume normal operations.
> + *
> + * Return: PCI_ERS_RESULT_RECOVERED or PCI_ERS_RESULT_DISCONNECT
> + */
> +static pci_ers_result_t cxlflash_pci_slot_reset(struct pci_dev *pdev)
> +{
> +	int rc = 0;
> +	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
> +	struct device *dev = &cfg->dev->dev;
> +
> +	pr_debug("%s: pdev=%p\n", __func__, pdev);
> +
> +	rc = init_afu(cfg);
> +	if (unlikely(rc)) {
> +		dev_err(dev, "%s: EEH recovery failed! (%d)\n", __func__, rc);
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +
> +	return PCI_ERS_RESULT_RECOVERED;
> +}
> +
> +/**
> + * cxlflash_pci_resume() - called when normal operation can resume
> + * @pdev:	PCI device struct
> + */
> +static void cxlflash_pci_resume(struct pci_dev *pdev)
> +{
> +	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
> +
> +	pr_debug("%s: pdev=%p\n", __func__, pdev);
> +
> +	cfg->eeh_active = EEH_STATE_NONE;
> +	wake_up_all(&cfg->eeh_waitq);
> +}
> +
> +static const struct pci_error_handlers cxlflash_err_handler = {
> +	.error_detected = cxlflash_pci_error_detected,
> +	.slot_reset = cxlflash_pci_slot_reset,
> +	.resume = cxlflash_pci_resume,
> +};
> +
>  /*
>   * PCI device structure
>   */
> @@ -2294,6 +2428,7 @@ static struct pci_driver cxlflash_driver = {
>  	.id_table = cxlflash_pci_table,
>  	.probe = cxlflash_probe,
>  	.remove = cxlflash_remove,
> +	.err_handler = &cxlflash_err_handler,
>  };
> 
>  /**
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


