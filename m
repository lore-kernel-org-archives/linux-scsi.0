From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [GIT PULL] SCSI fixes for 3.3-rc4
Date: Fri, 24 Feb 2012 16:40:44 -0800
Message-ID: <4F482E0C.2000604@panasas.com>
References: <1330126189.2831.44.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:38675 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2BYAlN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2012 19:41:13 -0500
In-Reply-To: <1330126189.2831.44.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 02/24/2012 03:29 PM, James Bottomley wrote:
> This is a set of assorted bug fixes for power management, mpt2sas, ipr,
> the rdac device handler and quite a big chunk for qla2xxx (plus a use
> after free of scsi_host in scsi_scan.c).
> 

James? what's up?

I sent you, what is for me a very important fix, also targeted for stable
which is a one liner. I don't see it below. Do you plan on another scsi-fixes
batch?

If not than please send me your ack and I can push it through the exofs tree
since the most affected systems by this is any objects cluster like exofs+pnfs
type systems.

Thanks
Boaz


> The patch is available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git scsi-fixes
> 
> The short changelog is
> 
> Alan Stern (1):
>       scsi_pm: Fix bug in the SCSI power management handler
> 
> Alexey Khoroshilov (1):
>       mpt2sas: Fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock
> 
> Andrew Vasquez (4):
>       qla2xxx: Correct out of bounds read of ISP2200 mailbox registers.
>       qla2xxx: Remove errant clearing of MBX_INTERRUPT flag during CT-IOCB processing.
>       qla2xxx: Clear options-flags while issuing stop-firmware mbx command.
>       qla2xxx: Add an "is reset active" helper.
> 
> Arun Easi (1):
>       qla2xxx: Propagate up abort failures.
> 
> Chad Dupuis (2):
>       qla2xxx: Update version number to 8.03.07.13-k.
>       qla2xxx: Add check for null fcport references in qla2xxx_queuecommand.
> 
> Dave Jiang (1):
>       isci: Fix NULL ptr dereference when no firmware is being loaded
> 
> Giridhar Malavali (2):
>       qla2xxx: Proper detection of firmware abort error code for ISP82xx.
>       qla2xxx: Complete mailbox command timedout to avoid initialization failures during next reset cycle.
> 
> Huajun Li (1):
>       scsi_scan: Fix 'Poison overwritten' warning caused by using freed 'shost'
> 
> Kleber Sacilotto de Souza (1):
>       ipr: fix eeh recovery for 64-bit adapters
> 
> Michael Christie (1):
>       qla2xxx: Remove check for null fcport from host reset handler.
> 
> Moger, Babu (1):
>       scsi_dh_rdac: Fix for unbalanced reference count
> 
> Shyam Sundar (1):
>       qla2xxx: Remove resetting memory during device initialization for ISP82xx.
> 
> The diffstat is:
> 
>  drivers/scsi/device_handler/scsi_dh_rdac.c |   25 ++++++++------
>  drivers/scsi/ipr.c                         |   24 ++++++++++---
>  drivers/scsi/isci/host.c                   |    4 ++-
>  drivers/scsi/mpt2sas/mpt2sas_base.c        |    3 +-
>  drivers/scsi/qla2xxx/qla_attr.c            |   13 ++-----
>  drivers/scsi/qla2xxx/qla_bsg.c             |   50 +++++-----------------------
>  drivers/scsi/qla2xxx/qla_dbg.c             |    3 +-
>  drivers/scsi/qla2xxx/qla_def.h             |    1 +
>  drivers/scsi/qla2xxx/qla_inline.h          |   13 +++++++
>  drivers/scsi/qla2xxx/qla_isr.c             |    1 -
>  drivers/scsi/qla2xxx/qla_mbx.c             |    7 +++-
>  drivers/scsi/qla2xxx/qla_nx.c              |   15 +--------
>  drivers/scsi/qla2xxx/qla_os.c              |   19 ++++------
>  drivers/scsi/qla2xxx/qla_version.h         |    2 +-
>  drivers/scsi/scsi_pm.c                     |   16 +++++++++
>  drivers/scsi/scsi_priv.h                   |    1 +
>  drivers/scsi/scsi_scan.c                   |    4 +-
>  17 files changed, 101 insertions(+), 100 deletions(-)
> 
> And the full diff is attached below.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
> index 53a31c7..20c4557 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -364,10 +364,7 @@ static void release_controller(struct kref *kref)
>  	struct rdac_controller *ctlr;
>  	ctlr = container_of(kref, struct rdac_controller, kref);
>  
> -	flush_workqueue(kmpath_rdacd);
> -	spin_lock(&list_lock);
>  	list_del(&ctlr->node);
> -	spin_unlock(&list_lock);
>  	kfree(ctlr);
>  }
>  
> @@ -376,20 +373,17 @@ static struct rdac_controller *get_controller(int index, char *array_name,
>  {
>  	struct rdac_controller *ctlr, *tmp;
>  
> -	spin_lock(&list_lock);
> -
>  	list_for_each_entry(tmp, &ctlr_list, node) {
>  		if ((memcmp(tmp->array_id, array_id, UNIQUE_ID_LEN) == 0) &&
>  			  (tmp->index == index) &&
>  			  (tmp->host == sdev->host)) {
>  			kref_get(&tmp->kref);
> -			spin_unlock(&list_lock);
>  			return tmp;
>  		}
>  	}
>  	ctlr = kmalloc(sizeof(*ctlr), GFP_ATOMIC);
>  	if (!ctlr)
> -		goto done;
> +		return NULL;
>  
>  	/* initialize fields of controller */
>  	memcpy(ctlr->array_id, array_id, UNIQUE_ID_LEN);
> @@ -405,8 +399,7 @@ static struct rdac_controller *get_controller(int index, char *array_name,
>  	INIT_WORK(&ctlr->ms_work, send_mode_select);
>  	INIT_LIST_HEAD(&ctlr->ms_head);
>  	list_add(&ctlr->node, &ctlr_list);
> -done:
> -	spin_unlock(&list_lock);
> +
>  	return ctlr;
>  }
>  
> @@ -517,9 +510,12 @@ static int initialize_controller(struct scsi_device *sdev,
>  			index = 0;
>  		else
>  			index = 1;
> +
> +		spin_lock(&list_lock);
>  		h->ctlr = get_controller(index, array_name, array_id, sdev);
>  		if (!h->ctlr)
>  			err = SCSI_DH_RES_TEMP_UNAVAIL;
> +		spin_unlock(&list_lock);
>  	}
>  	return err;
>  }
> @@ -906,7 +902,9 @@ static int rdac_bus_attach(struct scsi_device *sdev)
>  	return 0;
>  
>  clean_ctlr:
> +	spin_lock(&list_lock);
>  	kref_put(&h->ctlr->kref, release_controller);
> +	spin_unlock(&list_lock);
>  
>  failed:
>  	kfree(scsi_dh_data);
> @@ -921,14 +919,19 @@ static void rdac_bus_detach( struct scsi_device *sdev )
>  	struct rdac_dh_data *h;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>  	scsi_dh_data = sdev->scsi_dh_data;
> +	h = (struct rdac_dh_data *) scsi_dh_data->buf;
> +	if (h->ctlr && h->ctlr->ms_queued)
> +		flush_workqueue(kmpath_rdacd);
> +
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>  	sdev->scsi_dh_data = NULL;
>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>  
> -	h = (struct rdac_dh_data *) scsi_dh_data->buf;
> +	spin_lock(&list_lock);
>  	if (h->ctlr)
>  		kref_put(&h->ctlr->kref, release_controller);
> +	spin_unlock(&list_lock);
>  	kfree(scsi_dh_data);
>  	module_put(THIS_MODULE);
>  	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", RDAC_NAME);
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 67b169b..b538f08 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -4613,11 +4613,13 @@ static int __ipr_eh_host_reset(struct scsi_cmnd * scsi_cmd)
>  	ENTER;
>  	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
>  
> -	dev_err(&ioa_cfg->pdev->dev,
> -		"Adapter being reset as a result of error recovery.\n");
> +	if (!ioa_cfg->in_reset_reload) {
> +		dev_err(&ioa_cfg->pdev->dev,
> +			"Adapter being reset as a result of error recovery.\n");
>  
> -	if (WAIT_FOR_DUMP == ioa_cfg->sdt_state)
> -		ioa_cfg->sdt_state = GET_DUMP;
> +		if (WAIT_FOR_DUMP == ioa_cfg->sdt_state)
> +			ioa_cfg->sdt_state = GET_DUMP;
> +	}
>  
>  	rc = ipr_reset_reload(ioa_cfg, IPR_SHUTDOWN_ABBREV);
>  
> @@ -4907,7 +4909,7 @@ static int ipr_cancel_op(struct scsi_cmnd * scsi_cmd)
>  	struct ipr_ioa_cfg *ioa_cfg;
>  	struct ipr_resource_entry *res;
>  	struct ipr_cmd_pkt *cmd_pkt;
> -	u32 ioasc;
> +	u32 ioasc, int_reg;
>  	int op_found = 0;
>  
>  	ENTER;
> @@ -4920,7 +4922,17 @@ static int ipr_cancel_op(struct scsi_cmnd * scsi_cmd)
>  	 */
>  	if (ioa_cfg->in_reset_reload || ioa_cfg->ioa_is_dead)
>  		return FAILED;
> -	if (!res || !ipr_is_gscsi(res))
> +	if (!res)
> +		return FAILED;
> +
> +	/*
> +	 * If we are aborting a timed out op, chances are that the timeout was caused
> +	 * by a still not detected EEH error. In such cases, reading a register will
> +	 * trigger the EEH recovery infrastructure.
> +	 */
> +	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
> +
> +	if (!ipr_is_gscsi(res))
>  		return FAILED;
>  
>  	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
> diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
> index 1a65d65..418391b 100644
> --- a/drivers/scsi/isci/host.c
> +++ b/drivers/scsi/isci/host.c
> @@ -1848,9 +1848,11 @@ static enum sci_status sci_oem_parameters_set(struct isci_host *ihost)
>  	if (state == SCIC_RESET ||
>  	    state == SCIC_INITIALIZING ||
>  	    state == SCIC_INITIALIZED) {
> +		u8 oem_version = pci_info->orom ? pci_info->orom->hdr.version :
> +			ISCI_ROM_VER_1_0;
>  
>  		if (sci_oem_parameters_validate(&ihost->oem_parameters,
> -						pci_info->orom->hdr.version))
> +						oem_version))
>  			return SCI_FAILURE_INVALID_PARAMETER_VALUE;
>  
>  		return SCI_SUCCESS;
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 0b2c955..a78036f 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -4548,7 +4548,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
>  		printk(MPT2SAS_ERR_FMT "%s: pci error recovery reset\n",
>  		    ioc->name, __func__);
>  		r = 0;
> -		goto out;
> +		goto out_unlocked;
>  	}
>  
>  	if (mpt2sas_fwfault_debug)
> @@ -4604,6 +4604,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
>  	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
>  	mutex_unlock(&ioc->reset_in_progress_mutex);
>  
> + out_unlocked:
>  	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: exit\n", ioc->name,
>  	    __func__));
>  	return r;
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index a2f1b30..9f41b3b 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1036,8 +1036,7 @@ qla2x00_link_state_show(struct device *dev, struct device_attribute *attr,
>  	    vha->device_flags & DFLG_NO_CABLE)
>  		len = snprintf(buf, PAGE_SIZE, "Link Down\n");
>  	else if (atomic_read(&vha->loop_state) != LOOP_READY ||
> -	    test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> -	    test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
> +	    qla2x00_reset_active(vha))
>  		len = snprintf(buf, PAGE_SIZE, "Unknown Link State\n");
>  	else {
>  		len = snprintf(buf, PAGE_SIZE, "Link Up - ");
> @@ -1359,8 +1358,7 @@ qla2x00_thermal_temp_show(struct device *dev,
>  		return snprintf(buf, PAGE_SIZE, "\n");
>  
>  	temp = frac = 0;
> -	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> -	    test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
> +	if (qla2x00_reset_active(vha))
>  		ql_log(ql_log_warn, vha, 0x707b,
>  		    "ISP reset active.\n");
>  	else if (!vha->hw->flags.eeh_busy)
> @@ -1379,8 +1377,7 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
>  	int rval = QLA_FUNCTION_FAILED;
>  	uint16_t state[5];
>  
> -	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> -		test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
> +	if (qla2x00_reset_active(vha))
>  		ql_log(ql_log_warn, vha, 0x707c,
>  		    "ISP reset active.\n");
>  	else if (!vha->hw->flags.eeh_busy)
> @@ -1693,9 +1690,7 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
>  	if (IS_FWI2_CAPABLE(ha)) {
>  		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma);
>  	} else if (atomic_read(&base_vha->loop_state) == LOOP_READY &&
> -		    !test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) &&
> -		    !test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags) &&
> -		    !ha->dpc_active) {
> +	    !qla2x00_reset_active(vha) && !ha->dpc_active) {
>  		/* Must be in a 'READY' state for statistics retrieval. */
>  		rval = qla2x00_get_link_status(base_vha, base_vha->loop_id,
>  						stats, stats_dma);
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index b1d0f93..1682e2e 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -108,13 +108,6 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
>  		goto exit_fcp_prio_cfg;
>  	}
>  
> -	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
> -		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> -		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
> -		ret = -EBUSY;
> -		goto exit_fcp_prio_cfg;
> -	}
> -
>  	/* Get the sub command */
>  	oper = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
>  
> @@ -646,13 +639,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
>  	dma_addr_t rsp_data_dma;
>  	uint32_t rsp_data_len;
>  
> -	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
> -		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> -		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
> -		ql_log(ql_log_warn, vha, 0x7018, "Abort active or needed.\n");
> -		return -EBUSY;
> -	}
> -
>  	if (!vha->flags.online) {
>  		ql_log(ql_log_warn, vha, 0x7019, "Host is not online.\n");
>  		return -EIO;
> @@ -874,13 +860,6 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
>  	int rval = 0;
>  	uint32_t flag;
>  
> -	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
> -	    test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> -	    test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
> -		ql_log(ql_log_warn, vha, 0x702e, "Abort active or needed.\n");
> -		return -EBUSY;
> -	}
> -
>  	if (!IS_QLA84XX(ha)) {
>  		ql_dbg(ql_dbg_user, vha, 0x702f, "Not 84xx, exiting.\n");
>  		return -EINVAL;
> @@ -922,11 +901,6 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
>  	uint32_t flag;
>  	uint32_t fw_ver;
>  
> -	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
> -		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> -		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))
> -		return -EBUSY;
> -
>  	if (!IS_QLA84XX(ha)) {
>  		ql_dbg(ql_dbg_user, vha, 0x7032,
>  		    "Not 84xx, exiting.\n");
> @@ -1036,14 +1010,6 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
>  	uint32_t data_len = 0;
>  	uint32_t dma_direction = DMA_NONE;
>  
> -	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
> -		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> -		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
> -		ql_log(ql_log_warn, vha, 0x7039,
> -		    "Abort active or needed.\n");
> -		return -EBUSY;
> -	}
> -
>  	if (!IS_QLA84XX(ha)) {
>  		ql_log(ql_log_warn, vha, 0x703a,
>  		    "Not 84xx, exiting.\n");
> @@ -1246,13 +1212,6 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
>  
>  	bsg_job->reply->reply_payload_rcv_len = 0;
>  
> -	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
> -		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> -		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
> -		ql_log(ql_log_warn, vha, 0x7045, "abort active or needed.\n");
> -		return -EBUSY;
> -	}
> -
>  	if (!IS_IIDMA_CAPABLE(vha->hw)) {
>  		ql_log(ql_log_info, vha, 0x7046, "iiDMA not supported.\n");
>  		return -EINVAL;
> @@ -1668,6 +1627,15 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
>  		vha = shost_priv(host);
>  	}
>  
> +	if (qla2x00_reset_active(vha)) {
> +		ql_dbg(ql_dbg_user, vha, 0x709f,
> +		    "BSG: ISP abort active/needed -- cmd=%d.\n",
> +		    bsg_job->request->msgcode);
> +		bsg_job->reply->result = (DID_ERROR << 16);
> +		bsg_job->job_done(bsg_job);
> +		return -EBUSY;
> +	}
> +
>  	ql_dbg(ql_dbg_user, vha, 0x7000,
>  	    "Entered %s msgcode=0x%x.\n", __func__, bsg_job->request->msgcode);
>  
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
> index 7c54624..45cbf0b 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -19,7 +19,8 @@
>   * | DPC Thread                   |       0x401c       |		|
>   * | Async Events                 |       0x5057       | 0x5052		|
>   * | Timer Routines               |       0x6011       | 0x600e,0x600f  |
> - * | User Space Interactions      |       0x709e       |		|
> + * | User Space Interactions      |       0x709e       | 0x7018,0x702e  |
> + * |                              |                    | 0x7039,0x7045  |
>   * | Task Management              |       0x803c       | 0x8025-0x8026  |
>   * |                              |                    | 0x800b,0x8039  |
>   * | AER/EEH                      |       0x900f       |		|
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index a6a4eeb..af1003f 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -44,6 +44,7 @@
>   * ISP2100 HBAs.
>   */
>  #define MAILBOX_REGISTER_COUNT_2100	8
> +#define MAILBOX_REGISTER_COUNT_2200	24
>  #define MAILBOX_REGISTER_COUNT		32
>  
>  #define QLA2200A_RISC_ROM_VER	4
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
> index 9902834..7cc4f36 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -131,3 +131,16 @@ qla2x00_hba_err_chk_enabled(srb_t *sp)
>  	}
>  	return 0;
>  }
> +
> +static inline int
> +qla2x00_reset_active(scsi_qla_host_t *vha)
> +{
> +	scsi_qla_host_t *base_vha = pci_get_drvdata(vha->hw->pdev);
> +
> +	/* Test appropriate base-vha and vha flags. */
> +	return test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags) ||
> +	    test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
> +	    test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
> +	    test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
> +	    test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index e804585..349843e 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2090,7 +2090,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
>  			break;
>                  case CT_IOCB_TYPE:
>  			qla24xx_els_ct_entry(vha, rsp->req, pkt, CT_IOCB_TYPE);
> -			clear_bit(MBX_INTERRUPT, &vha->hw->mbx_cmd_flags);
>  			break;
>                  case ELS_IOCB_TYPE:
>  			qla24xx_els_ct_entry(vha, rsp->req, pkt, ELS_IOCB_TYPE);
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 34344d3..08f1d01 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -342,6 +342,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
>  
>  				set_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
>  				clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> +				/* Allow next mbx cmd to come in. */
> +				complete(&ha->mbx_cmd_comp);
>  				if (ha->isp_ops->abort_isp(vha)) {
>  					/* Failed. retry later. */
>  					set_bit(ISP_ABORT_NEEDED,
> @@ -350,6 +352,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
>  				clear_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
>  				ql_dbg(ql_dbg_mbx, base_vha, 0x101f,
>  				    "Finished abort_isp.\n");
> +				goto mbx_done;
>  			}
>  		}
>  	}
> @@ -358,6 +361,7 @@ premature_exit:
>  	/* Allow next mbx cmd to come in. */
>  	complete(&ha->mbx_cmd_comp);
>  
> +mbx_done:
>  	if (rval) {
>  		ql_dbg(ql_dbg_mbx, base_vha, 0x1020,
>  		    "**** Failed mbx[0]=%x, mb[1]=%x, mb[2]=%x, cmd=%x ****.\n",
> @@ -2581,7 +2585,8 @@ qla2x00_stop_firmware(scsi_qla_host_t *vha)
>  	ql_dbg(ql_dbg_mbx, vha, 0x10a1, "Entered %s.\n", __func__);
>  
>  	mcp->mb[0] = MBC_STOP_FIRMWARE;
> -	mcp->out_mb = MBX_0;
> +	mcp->mb[1] = 0;
> +	mcp->out_mb = MBX_1|MBX_0;
>  	mcp->in_mb = MBX_0;
>  	mcp->tov = 5;
>  	mcp->flags = 0;
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index 1cd46cd..270ba31 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -1165,19 +1165,6 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
>  		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xfeffffff);
>  	else
>  		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xffffffff);
> -
> -	/* reset ms */
> -	val = qla82xx_rd_32(ha, QLA82XX_CRB_QDR_NET + 0xe4);
> -	val |= (1 << 1);
> -	qla82xx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
> -	msleep(20);
> -
> -	/* unreset ms */
> -	val = qla82xx_rd_32(ha, QLA82XX_CRB_QDR_NET + 0xe4);
> -	val &= ~(1 << 1);
> -	qla82xx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
> -	msleep(20);
> -
>  	qla82xx_rom_unlock(ha);
>  
>  	/* Read the signature value from the flash.
> @@ -3392,7 +3379,7 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
>  					    QLA82XX_CRB_PEG_NET_3 + 0x3c),
>  				    qla82xx_rd_32(ha,
>  					    QLA82XX_CRB_PEG_NET_4 + 0x3c));
> -				if (LSW(MSB(halt_status)) == 0x67)
> +				if (((halt_status & 0x1fffff00) >> 8) == 0x67)
>  					ql_log(ql_log_warn, vha, 0xb052,
>  					    "Firmware aborted with "
>  					    "error code 0x00006700. Device is "
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 4ed1e4a..036030c 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -625,6 +625,12 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  			cmd->result = DID_NO_CONNECT << 16;
>  			goto qc24_fail_command;
>  	}
> +
> +	if (!fcport) {
> +		cmd->result = DID_NO_CONNECT << 16;
> +		goto qc24_fail_command;
> +	}
> +
>  	if (atomic_read(&fcport->state) != FCS_ONLINE) {
>  		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
>  			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
> @@ -877,6 +883,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>  
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  	if (ha->isp_ops->abort_command(sp)) {
> +		ret = FAILED;
>  		ql_dbg(ql_dbg_taskm, vha, 0x8003,
>  		    "Abort command mbx failed cmd=%p.\n", cmd);
>  	} else {
> @@ -1124,7 +1131,6 @@ static int
>  qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
>  {
>  	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
> -	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
>  	struct qla_hw_data *ha = vha->hw;
>  	int ret = FAILED;
>  	unsigned int id, lun;
> @@ -1133,15 +1139,6 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
>  	id = cmd->device->id;
>  	lun = cmd->device->lun;
>  
> -	if (!fcport) {
> -		return ret;
> -	}
> -
> -	ret = fc_block_scsi_eh(cmd);
> -	if (ret != 0)
> -		return ret;
> -	ret = FAILED;
> -
>  	ql_log(ql_log_info, vha, 0x8018,
>  	    "ADAPTER RESET ISSUED nexus=%ld:%d:%d.\n", vha->host_no, id, lun);
>  
> @@ -2047,7 +2044,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  		ha->nvram_data_off = ~0;
>  		ha->isp_ops = &qla2100_isp_ops;
>  	} else if (IS_QLA2200(ha)) {
> -		ha->mbx_count = MAILBOX_REGISTER_COUNT;
> +		ha->mbx_count = MAILBOX_REGISTER_COUNT_2200;
>  		req_length = REQUEST_ENTRY_CNT_2200;
>  		rsp_length = RESPONSE_ENTRY_CNT_2100;
>  		ha->max_loop_id = SNS_LAST_LOOP_ID_2100;
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
> index 23f33a6..29d780c 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -7,7 +7,7 @@
>  /*
>   * Driver version
>   */
> -#define QLA2XXX_VERSION      "8.03.07.12-k"
> +#define QLA2XXX_VERSION      "8.03.07.13-k"
>  
>  #define QLA_DRIVER_MAJOR_VER	8
>  #define QLA_DRIVER_MINOR_VER	3
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index bf8bf79..c467064 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -7,6 +7,7 @@
>  
>  #include <linux/pm_runtime.h>
>  #include <linux/export.h>
> +#include <linux/async.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_device.h>
> @@ -92,6 +93,19 @@ static int scsi_bus_resume_common(struct device *dev)
>  	return err;
>  }
>  
> +static int scsi_bus_prepare(struct device *dev)
> +{
> +	if (scsi_is_sdev_device(dev)) {
> +		/* sd probing uses async_schedule.  Wait until it finishes. */
> +		async_synchronize_full();
> +
> +	} else if (scsi_is_host_device(dev)) {
> +		/* Wait until async scanning is finished */
> +		scsi_complete_async_scans();
> +	}
> +	return 0;
> +}
> +
>  static int scsi_bus_suspend(struct device *dev)
>  {
>  	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
> @@ -110,6 +124,7 @@ static int scsi_bus_poweroff(struct device *dev)
>  #else /* CONFIG_PM_SLEEP */
>  
>  #define scsi_bus_resume_common		NULL
> +#define scsi_bus_prepare		NULL
>  #define scsi_bus_suspend		NULL
>  #define scsi_bus_freeze			NULL
>  #define scsi_bus_poweroff		NULL
> @@ -218,6 +233,7 @@ void scsi_autopm_put_host(struct Scsi_Host *shost)
>  #endif /* CONFIG_PM_RUNTIME */
>  
>  const struct dev_pm_ops scsi_bus_pm_ops = {
> +	.prepare =		scsi_bus_prepare,
>  	.suspend =		scsi_bus_suspend,
>  	.resume =		scsi_bus_resume_common,
>  	.freeze =		scsi_bus_freeze,
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 68eadd1..be4fa6d 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -109,6 +109,7 @@ extern void scsi_exit_procfs(void);
>  #endif /* CONFIG_PROC_FS */
>  
>  /* scsi_scan.c */
> +extern int scsi_complete_async_scans(void);
>  extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
>  				   unsigned int, unsigned int, int);
>  extern void scsi_forget_host(struct Scsi_Host *);
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 89da43f..29c4c04 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1815,6 +1815,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
>  	}
>  	spin_unlock(&async_scan_lock);
>  
> +	scsi_autopm_put_host(shost);
>  	scsi_host_put(shost);
>  	kfree(data);
>  }
> @@ -1841,7 +1842,6 @@ static int do_scan_async(void *_data)
>  
>  	do_scsi_scan_host(shost);
>  	scsi_finish_async_scan(data);
> -	scsi_autopm_put_host(shost);
>  	return 0;
>  }
>  
> @@ -1869,7 +1869,7 @@ void scsi_scan_host(struct Scsi_Host *shost)
>  	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
>  	if (IS_ERR(p))
>  		do_scan_async(data);
> -	/* scsi_autopm_put_host(shost) is called in do_scan_async() */
> +	/* scsi_autopm_put_host(shost) is called in scsi_finish_async_scan() */
>  }
>  EXPORT_SYMBOL(scsi_scan_host);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

