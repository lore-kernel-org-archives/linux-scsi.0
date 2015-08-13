From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH v5 1/3] cxlflash: Base error recovery support
Date: Thu, 13 Aug 2015 09:25:27 -0400
Message-ID: <20150813092527.Horde.Gnhl9W8RluCuAKlQh0IQfQ1@ltc.linux.ibm.com>
References: <1439423466-15609-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:52633 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbbHMNZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 09:25:35 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Thu, 13 Aug 2015 07:25:34 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 4EE173E40048
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 07:25:32 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7DDOZlY56688772
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 06:24:35 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7DDPT0j004346
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 07:25:31 -0600
In-Reply-To: <1439423466-15609-1-git-send-email-mrochs@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, mikey@neuling.org, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Thanks for merging the comments I made for v3.

Reviewed-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Quoting "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>:

> Introduce support for enhanced I/O error handling.
>
> A device state is added to track 3 possible states of the device:
>
> Normal - the device is operating normally and is fully operational
>
> Limbo - the device is in a reset/recovery scenario and its operational
>         status is paused
>
> Failed/terminating - the device has either failed to be reset/recovered
>                      or is being terminated (removed); it is no longer
>                      operational
>
> All operations are allowed when the device is operating normally. When the
> device transitions to limbo state, I/O must be paused. To help accomplish
> this, a wait queue is introduced where existing and new threads can wait
> until the device is no longer in limbo. When coming out of limbo, threads
> need to check the state and error out gracefully when encountering the
> failed state. When the device transitions to the failed/terminating state,
> normal operations are no longer allowed. Only specially designated
> operations related to graceful cleanup are permitted.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> ---
>  drivers/scsi/cxlflash/Kconfig  |   2 +-
>  drivers/scsi/cxlflash/common.h |  12 ++-
>  drivers/scsi/cxlflash/main.c   | 174  
> ++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/cxlflash/main.h   |   6 +-
>  4 files changed, 177 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/scsi/cxlflash/Kconfig b/drivers/scsi/cxlflash/Kconfig
> index c707508..c052104 100644
> --- a/drivers/scsi/cxlflash/Kconfig
> +++ b/drivers/scsi/cxlflash/Kconfig
> @@ -4,7 +4,7 @@
>
>  config CXLFLASH
>  	tristate "Support for IBM CAPI Flash"
> -	depends on PCI && SCSI && CXL
> +	depends on PCI && SCSI && CXL && EEH
>  	default m
>  	help
>  	  Allows CAPI Accelerated IO to Flash
> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
> index fe86bfe..ffdbc57 100644
> --- a/drivers/scsi/cxlflash/common.h
> +++ b/drivers/scsi/cxlflash/common.h
> @@ -76,6 +76,12 @@ enum cxlflash_init_state {
>  	INIT_STATE_SCSI
>  };
>
> +enum cxlflash_state {
> +	STATE_NORMAL,	/* Normal running state, everything good */
> +	STATE_LIMBO,	/* Limbo running state, trying to reset/recover */
> +	STATE_FAILTERM	/* Failed/terminating state, error out users/threads */
> +};
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
>
>  	wait_queue_head_t tmf_waitq;
>  	bool tmf_active;
> -	u8 err_recovery_active:1;
> +	wait_queue_head_t limbo_waitq;
> +	enum cxlflash_state state;
>  };
>
>  struct afu_cmd {
> @@ -178,4 +183,3 @@ struct afu_cmd *cxlflash_cmd_checkout(struct afu *);
>  void cxlflash_cmd_checkin(struct afu_cmd *);
>  int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
>  #endif /* ifndef _CXLFLASH_COMMON_H */
> -
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 76a7286..4df1ff6 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -353,6 +353,7 @@ static int cxlflash_queuecommand(struct  
> Scsi_Host *host, struct scsi_cmnd *scp)
>  	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
>  	struct afu *afu = cfg->afu;
>  	struct pci_dev *pdev = cfg->dev;
> +	struct device *dev = &cfg->dev->dev;
>  	struct afu_cmd *cmd;
>  	u32 port_sel = scp->device->channel + 1;
>  	int nseg, i, ncount;
> @@ -380,6 +381,21 @@ static int cxlflash_queuecommand(struct  
> Scsi_Host *host, struct scsi_cmnd *scp)
>  	}
>  	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
>
> +	switch (cfg->state) {
> +	case STATE_LIMBO:
> +		dev_dbg_ratelimited(dev, "%s: device in limbo!\n", __func__);
> +		rc = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	case STATE_FAILTERM:
> +		dev_dbg_ratelimited(dev, "%s: device has failed!\n", __func__);
> +		scp->result = (DID_NO_CONNECT << 16);
> +		scp->scsi_done(scp);
> +		rc = 0;
> +		goto out;
> +	default:
> +		break;
> +	}
> +
>  	cmd = cxlflash_cmd_checkout(afu);
>  	if (unlikely(!cmd)) {
>  		pr_err("%s: could not get a free command\n", __func__);
> @@ -455,9 +471,21 @@ static int  
> cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>
> -	rcr = send_tmf(afu, scp, TMF_LUN_RESET);
> -	if (unlikely(rcr))
> +	switch (cfg->state) {
> +	case STATE_NORMAL:
> +		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
> +		if (unlikely(rcr))
> +			rc = FAILED;
> +		break;
> +	case STATE_LIMBO:
> +		wait_event(cfg->limbo_waitq, cfg->state != STATE_LIMBO);
> +		if (cfg->state == STATE_NORMAL)
> +			break;
> +		/* fall through */
> +	default:
>  		rc = FAILED;
> +		break;
> +	}
>
>  	pr_debug("%s: returning rc=%d\n", __func__, rc);
>  	return rc;
> @@ -487,11 +515,29 @@ static int  
> cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>
> -	rcr = cxlflash_afu_reset(cfg);
> -	if (rcr == 0)
> -		rc = SUCCESS;
> -	else
> +	switch (cfg->state) {
> +	case STATE_NORMAL:
> +		cfg->state = STATE_LIMBO;
> +		scsi_block_requests(cfg->host);
> +
> +		rcr = cxlflash_afu_reset(cfg);
> +		if (rcr) {
> +			rc = FAILED;
> +			cfg->state = STATE_FAILTERM;
> +		} else
> +			cfg->state = STATE_NORMAL;
> +		wake_up_all(&cfg->limbo_waitq);
> +		scsi_unblock_requests(cfg->host);
> +		break;
> +	case STATE_LIMBO:
> +		wait_event(cfg->limbo_waitq, cfg->state != STATE_LIMBO);
> +		if (cfg->state == STATE_NORMAL)
> +			break;
> +		/* fall through */
> +	default:
>  		rc = FAILED;
> +		break;
> +	}
>
>  	pr_debug("%s: returning rc=%d\n", __func__, rc);
>  	return rc;
> @@ -642,7 +688,7 @@ static void  
> cxlflash_wait_for_pci_err_recovery(struct cxlflash_cfg *cfg)
>  	struct pci_dev *pdev = cfg->dev;
>
>  	if (pci_channel_offline(pdev))
> -		wait_event_timeout(cfg->eeh_waitq,
> +		wait_event_timeout(cfg->limbo_waitq,
>  				   !pci_channel_offline(pdev),
>  				   CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT);
>  }
> @@ -825,6 +871,8 @@ static void cxlflash_remove(struct pci_dev *pdev)
>  						    !cfg->tmf_active);
>  	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
>
> +	cfg->state = STATE_FAILTERM;
> +
>  	switch (cfg->init_state) {
>  	case INIT_STATE_SCSI:
>  		scsi_remove_host(cfg->host);
> @@ -1879,6 +1927,8 @@ static int init_afu(struct cxlflash_cfg *cfg)
>  	struct afu *afu = cfg->afu;
>  	struct device *dev = &cfg->dev->dev;
>
> +	cxl_perst_reloads_same_image(cfg->cxl_afu, true);
> +
>  	rc = init_mc(cfg);
>  	if (rc) {
>  		dev_err(dev, "%s: call to init_mc failed, rc=%d!\n",
> @@ -2021,6 +2071,12 @@ void cxlflash_wait_resp(struct afu *afu,  
> struct afu_cmd *cmd)
>   * the sync. This design point requires calling threads to not be  
> on interrupt
>   * context due to the possibility of sleeping during concurrent  
> sync operations.
>   *
> + * AFU sync operations are only necessary and allowed when the device is
> + * operating normally. When not operating normally, sync requests  
> can occur as
> + * part of cleaning up resources associated with an adapter prior  
> to removal.
> + * In this scenario, these requests are simply ignored (safe due to the AFU
> + * going away).
> + *
>   * Return:
>   *	0 on success
>   *	-1 on failure
> @@ -2028,11 +2084,17 @@ void cxlflash_wait_resp(struct afu *afu,  
> struct afu_cmd *cmd)
>  int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
>  		      res_hndl_t res_hndl_u, u8 mode)
>  {
> +	struct cxlflash_cfg *cfg = afu->parent;
>  	struct afu_cmd *cmd = NULL;
>  	int rc = 0;
>  	int retry_cnt = 0;
>  	static DEFINE_MUTEX(sync_active);
>
> +	if (cfg->state != STATE_NORMAL) {
> +		pr_debug("%s: Sync not required! (%u)\n", __func__, cfg->state);
> +		return 0;
> +	}
> +
>  	mutex_lock(&sync_active);
>  retry:
>  	cmd = cxlflash_cmd_checkout(afu);
> @@ -2116,12 +2178,17 @@ int cxlflash_afu_reset(struct cxlflash_cfg *cfg)
>   */
>  static void cxlflash_worker_thread(struct work_struct *work)
>  {
> -	struct cxlflash_cfg *cfg =
> -	    container_of(work, struct cxlflash_cfg, work_q);
> +	struct cxlflash_cfg *cfg = container_of(work, struct cxlflash_cfg,
> +						work_q);
>  	struct afu *afu = cfg->afu;
>  	int port;
>  	ulong lock_flags;
>
> +	/* Avoid MMIO if the device has failed */
> +
> +	if (cfg->state != STATE_NORMAL)
> +		return;
> +
>  	spin_lock_irqsave(cfg->host->host_lock, lock_flags);
>
>  	if (cfg->lr_state == LINK_RESET_REQUIRED) {
> @@ -2200,10 +2267,9 @@ static int cxlflash_probe(struct pci_dev *pdev,
>  	cfg->dev = pdev;
>  	cfg->dev_id = (struct pci_device_id *)dev_id;
>  	cfg->mcctx = NULL;
> -	cfg->err_recovery_active = 0;
>
>  	init_waitqueue_head(&cfg->tmf_waitq);
> -	init_waitqueue_head(&cfg->eeh_waitq);
> +	init_waitqueue_head(&cfg->limbo_waitq);
>
>  	INIT_WORK(&cfg->work_q, cxlflash_worker_thread);
>  	cfg->lr_state = LINK_RESET_INVALID;
> @@ -2259,6 +2325,91 @@ out_remove:
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
> +	struct device *dev = &cfg->dev->dev;
> +
> +	dev_dbg(dev, "%s: pdev=%p state=%u\n", __func__, pdev, state);
> +
> +	switch (state) {
> +	case pci_channel_io_frozen:
> +		cfg->state = STATE_LIMBO;
> +
> +		/* Turn off legacy I/O */
> +		scsi_block_requests(cfg->host);
> +
> +		term_mc(cfg, UNDO_START);
> +		stop_afu(cfg);
> +
> +		return PCI_ERS_RESULT_NEED_RESET;
> +	case pci_channel_io_perm_failure:
> +		cfg->state = STATE_FAILTERM;
> +		wake_up_all(&cfg->limbo_waitq);
> +		scsi_unblock_requests(cfg->host);
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
> +	dev_dbg(dev, "%s: pdev=%p\n", __func__, pdev);
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
> +	struct device *dev = &cfg->dev->dev;
> +
> +	dev_dbg(dev, "%s: pdev=%p\n", __func__, pdev);
> +
> +	cfg->state = STATE_NORMAL;
> +	wake_up_all(&cfg->limbo_waitq);
> +	scsi_unblock_requests(cfg->host);
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
> @@ -2267,6 +2418,7 @@ static struct pci_driver cxlflash_driver = {
>  	.id_table = cxlflash_pci_table,
>  	.probe = cxlflash_probe,
>  	.remove = cxlflash_remove,
> +	.err_handler = &cxlflash_err_handler,
>  };
>
>  /**
> diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
> index 7f890cc..7bf0d4d 100644
> --- a/drivers/scsi/cxlflash/main.h
> +++ b/drivers/scsi/cxlflash/main.h
> @@ -22,7 +22,7 @@
>
>  #define CXLFLASH_NAME		"cxlflash"
>  #define CXLFLASH_ADAPTER_NAME	"IBM POWER CXL Flash Adapter"
> -#define CXLFLASH_DRIVER_DATE	"(June 2, 2015)"
> +#define CXLFLASH_DRIVER_DATE	"(August 12, 2015)"
>
>  #define PCI_DEVICE_ID_IBM_CORSA	0x04F0
>  #define CXLFLASH_SUBS_DEV_ID	0x04F0
> @@ -101,4 +101,8 @@ struct asyc_intr_info {
>  #define LINK_RESET	0x02
>  };
>
> +#ifndef CONFIG_CXL_EEH
> +#define cxl_perst_reloads_same_image(_a, _b) do { } while (0)
> +#endif
> +
>  #endif /* _CXLFLASH_MAIN_H */
> --
> 2.1.0


