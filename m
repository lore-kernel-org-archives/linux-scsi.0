From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH] pm8001: deficient responses to IO_XFER_ERROR_BREAK and IO_XFER_OPEN_RETRY_TIMEOUT
Date: Sat, 21 Jan 2012 17:21:07 +0800
Message-ID: <2245BE24D7044378B6D2B4884C7CA7A0@usish.com.cn>
References: <200EB790-6DA0-4537-9C2F-8472ECF8D29E@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53727 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2AUJWp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Jan 2012 04:22:45 -0500
In-Reply-To: <200EB790-6DA0-4537-9C2F-8472ECF8D29E@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@xyratex.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>
Cc: 'James Bottomley' <JBottomley@parallels.com>, 'lindar_liu' <lindar_liu@usish.com>, 'john_gong' <john_gong@usish.com>, 'crystal_yu' <crystal_yu@usish.com>

Thanks Mark for fix this.
Acked-by: Jack Wang <jack_wang@usish.com>



> IO_XFER_ERROR_BREAK and IO_XFER_OPEN_RETRY_TIMEOUT are deficient of the
> required actions as outlined in the programming manual for the pm8001. Due
to
> the overlapping code requirements of these recovery responses, we found it
> necessary to bundle them together into one patch.
> 
> When a break is received during the command phase (ssp_completion), this
is
> a result of a timeout or interruption on the bus. Logic suggests that we
should
> retry the command.
> 
> When a break is received during the data-phase (ssp_event), the task must
be
> aborted on the target or it will retain a data-phase lock turning the
target
> reticent to all future media commands yet will successfully respond to
TUR,
> INQUIRY and ABORT leading eventually to target failure through several
> abort-cycle loops.
> 
> The open retry interval is exceedingly short resulting in occasional
target
> drop-off during expander resets or when targets push-back during bad-block
> remapping. Increased effective timeout from 130ms to 1.5 seconds for each
try
> so as to trigger after the administrative inquiry/tur timeout in the scsi
> subsystem to keep error-recovery harmonics to a minimum.
> 
> When an open retry timeout event is received, the action required by the
targets
> is to issue an abort for the outstanding command then logic suggests we
retry
> the command as this state is usually an indication of a credit block or
busy
> condition on the target.
> 
> We hijacked the pm8001_handle_event work queue handler so that it will
handle
> task as an argument instead of device for the workers in support of the
deferred
> handling outlined above.
> 
> Moderate to Heavy bad-path testing on a 2.6.32 vintage kernel,
compile-testing
> on scsi-misc-2.6 kernel ...
> 
> Signed-off-by: mark_salyzyn@xyratex.com
> Cc: jack_wang@usish.com
> Cc: JBottomley@parallels.com
> Cc: crystal_yu@usish.com
> Cc: john_gong@usish.com
> Cc: lindar_liu <lindar_liu@usish.com>
> 
>  drivers/scsi/pm8001/pm8001_hwi.c |  196
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  drivers/scsi/pm8001/pm8001_sas.c |   72 +++++++++++++++++++++
>  drivers/scsi/pm8001/pm8001_sas.h |    5 +
>  3 files changed, 261 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
> b/drivers/scsi/pm8001/pm8001_hwi.c
> index b7b92f7..faeda89 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -607,7 +607,8 @@ static int __devinit pm8001_chip_init(struct
> pm8001_hba_info *pm8001_ha)
>  	update_inbnd_queue_table(pm8001_ha, 0);
>  	update_outbnd_queue_table(pm8001_ha, 0);
>  	mpi_set_phys_g3_with_ssc(pm8001_ha, 0);
> -	mpi_set_open_retry_interval_reg(pm8001_ha, 7);
> +	/* 7->130ms, 34->500ms, 119->1.5s */
> +	mpi_set_open_retry_interval_reg(pm8001_ha, 119);
>  	/* notify firmware update finished and check initialization status
*/
>  	if (0 == mpi_init_check(pm8001_ha)) {
>  		PM8001_INIT_DBG(pm8001_ha,
> @@ -1388,24 +1389,191 @@ static void pm8001_work_fn(struct work_struct
*work)
>  	struct pm8001_device *pm8001_dev;
>  	struct domain_device *dev;
> 
> +	/*
> +	 * So far, all users of this stash an associated structure here.
> +	 * If we get here, and this pointer is null, then the action
> +	 * was cancelled. This nullification happens when the device
> +	 * goes away.
> +	 */
> +	pm8001_dev = pw->data; /* Most stash device structure */
> +	if ((pm8001_dev == NULL)
> +	 || ((pw->handler != IO_XFER_ERROR_BREAK)
> +	  && (pm8001_dev->dev_type == NO_DEVICE))) {
> +		kfree(pw);
> +		return;
> +	}
> +
>  	switch (pw->handler) {
> +	case IO_XFER_ERROR_BREAK:
> +	{	/* This one stashes the sas_task instead */
> +		struct sas_task *t = (struct sas_task *)pm8001_dev;
> +		u32 tag;
> +		struct pm8001_ccb_info *ccb;
> +		struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
> +		unsigned long flags, flags1;
> +		struct task_status_struct *ts;
> +		int i;
> +
> +		if (pm8001_query_task(t) == TMF_RESP_FUNC_SUCC)
> +			break; /* Task still on lu */
> +		spin_lock_irqsave(&pm8001_ha->lock, flags);
> +
> +		spin_lock_irqsave(&t->task_state_lock, flags1);
> +		if (unlikely((t->task_state_flags & SAS_TASK_STATE_DONE))) {
> +			spin_unlock_irqrestore(&t->task_state_lock, flags1);
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +			break; /* Task got completed by another */
> +		}
> +		spin_unlock_irqrestore(&t->task_state_lock, flags1);
> +
> +		/* Search for a possible ccb that matches the task */
> +		for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
> +			ccb = &pm8001_ha->ccb_info[i];
> +			tag = ccb->ccb_tag;
> +			if ((tag != 0xFFFFFFFF) && (ccb->task == t))
> +				break;
> +		}
> +		if (!ccb) {
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +			break; /* Task got freed by another */
> +		}
> +		ts = &t->task_status;
> +		ts->resp = SAS_TASK_COMPLETE;
> +		/* Force the midlayer to retry */
> +		ts->stat = SAS_QUEUE_FULL;
> +		pm8001_dev = ccb->device;
> +		if (pm8001_dev)
> +			pm8001_dev->running_req--;
> +		spin_lock_irqsave(&t->task_state_lock, flags1);
> +		t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
> +		t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
> +		t->task_state_flags |= SAS_TASK_STATE_DONE;
> +		if (unlikely((t->task_state_flags &
SAS_TASK_STATE_ABORTED))) {
> +			spin_unlock_irqrestore(&t->task_state_lock, flags1);
> +			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("task 0x%p"
> +				" done with event 0x%x resp 0x%x stat 0x%x
but"
> +				" aborted by upper layer!\n",
> +				t, pw->handler, ts->resp, ts->stat));
> +			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +		} else {
> +			spin_unlock_irqrestore(&t->task_state_lock, flags1);
> +			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +			mb();/* in order to force CPU ordering */
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +			t->task_done(t);
> +		}
> +	}	break;
> +	case IO_XFER_OPEN_RETRY_TIMEOUT:
> +	{	/* This one stashes the sas_task instead */
> +		struct sas_task *t = (struct sas_task *)pm8001_dev;
> +		u32 tag;
> +		struct pm8001_ccb_info *ccb;
> +		struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
> +		unsigned long flags, flags1;
> +		int i, ret = 0;
> +
> +		PM8001_IO_DBG(pm8001_ha,
> +			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
> +
> +		ret = pm8001_query_task(t);
> +
> +		PM8001_IO_DBG(pm8001_ha,
> +			switch (ret) {
> +			case TMF_RESP_FUNC_SUCC:
> +				pm8001_printk("...Task on lu\n");
> +				break;
> +
> +			case TMF_RESP_FUNC_COMPLETE:
> +				pm8001_printk("...Task NOT on lu\n");
> +				break;
> +
> +			default:
> +				pm8001_printk("...query task failed!!!\n");
> +				break;
> +			});
> +
> +		spin_lock_irqsave(&pm8001_ha->lock, flags);
> +
> +		spin_lock_irqsave(&t->task_state_lock, flags1);
> +
> +		if (unlikely((t->task_state_flags & SAS_TASK_STATE_DONE))) {
> +			spin_unlock_irqrestore(&t->task_state_lock, flags1);
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +			if (ret == TMF_RESP_FUNC_SUCC) /* task on lu */
> +				(void)pm8001_abort_task(t);
> +			break; /* Task got completed by another */
> +		}
> +
> +		spin_unlock_irqrestore(&t->task_state_lock, flags1);
> +
> +		/* Search for a possible ccb that matches the task */
> +		for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
> +			ccb = &pm8001_ha->ccb_info[i];
> +			tag = ccb->ccb_tag;
> +			if ((tag != 0xFFFFFFFF) && (ccb->task == t))
> +				break;
> +		}
> +		if (!ccb) {
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +			if (ret == TMF_RESP_FUNC_SUCC) /* task on lu */
> +				(void)pm8001_abort_task(t);
> +			break; /* Task got freed by another */
> +		}
> +
> +		pm8001_dev = ccb->device;
> +		dev = pm8001_dev->sas_device;
> +
> +		switch (ret) {
> +		case TMF_RESP_FUNC_SUCC: /* task on lu */
> +			ccb->open_retry = 1; /* Snub completion */
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +			ret = pm8001_abort_task(t);
> +			ccb->open_retry = 0;
> +			switch (ret) {
> +			case TMF_RESP_FUNC_SUCC:
> +			case TMF_RESP_FUNC_COMPLETE:
> +				break;
> +			default: /* device misbehavior */
> +				ret = TMF_RESP_FUNC_FAILED;
> +				PM8001_IO_DBG(pm8001_ha,
> +					pm8001_printk("...Reset phy\n"));
> +				pm8001_I_T_nexus_reset(dev);
> +				break;
> +			}
> +			break;
> +
> +		case TMF_RESP_FUNC_COMPLETE: /* task not on lu */
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +			/* Do we need to abort the task locally? */
> +			break;
> +
> +		default: /* device misbehavior */
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +			ret = TMF_RESP_FUNC_FAILED;
> +			PM8001_IO_DBG(pm8001_ha,
> +				pm8001_printk("...Reset phy\n"));
> +			pm8001_I_T_nexus_reset(dev);
> +		}
> +
> +		if (ret == TMF_RESP_FUNC_FAILED)
> +			t = NULL;
> +		pm8001_open_reject_retry(pm8001_ha, t, pm8001_dev);
> +		PM8001_IO_DBG(pm8001_ha, pm8001_printk("...Complete\n"));
> +	}	break;
>  	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
> -		pm8001_dev = pw->data;
>  		dev = pm8001_dev->sas_device;
>  		pm8001_I_T_nexus_reset(dev);
>  		break;
>  	case IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY:
> -		pm8001_dev = pw->data;
>  		dev = pm8001_dev->sas_device;
>  		pm8001_I_T_nexus_reset(dev);
>  		break;
>  	case IO_DS_IN_ERROR:
> -		pm8001_dev = pw->data;
>  		dev = pm8001_dev->sas_device;
>  		pm8001_I_T_nexus_reset(dev);
>  		break;
>  	case IO_DS_NON_OPERATIONAL:
> -		pm8001_dev = pw->data;
>  		dev = pm8001_dev->sas_device;
>  		pm8001_I_T_nexus_reset(dev);
>  		break;
> @@ -1460,6 +1628,11 @@ mpi_ssp_completion(struct pm8001_hba_info
*pm8001_ha ,
> void *piomb)
>  	status = le32_to_cpu(psspPayload->status);
>  	tag = le32_to_cpu(psspPayload->tag);
>  	ccb = &pm8001_ha->ccb_info[tag];
> +	if ((status == IO_ABORTED) && ccb->open_retry) {
> +		/* Being completed by another */
> +		ccb->open_retry = 0;
> +		return;
> +	}
>  	pm8001_dev = ccb->device;
>  	param = le32_to_cpu(psspPayload->param);
> 
> @@ -1515,6 +1688,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha
,
> void *piomb)
>  			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
>  		ts->resp = SAS_TASK_COMPLETE;
>  		ts->stat = SAS_OPEN_REJECT;
> +		/* Force the midlayer to retry */
> +		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
>  		break;
>  	case IO_XFER_ERROR_PHY_NOT_READY:
>  		PM8001_IO_DBG(pm8001_ha,
> @@ -1719,9 +1894,8 @@ static void mpi_ssp_event(struct pm8001_hba_info
> *pm8001_ha , void *piomb)
>  	case IO_XFER_ERROR_BREAK:
>  		PM8001_IO_DBG(pm8001_ha,
>  			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
> -		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAS_INTERRUPTED;
> -		break;
> +		pm8001_handle_event(pm8001_ha, t, IO_XFER_ERROR_BREAK);
> +		return;
>  	case IO_XFER_ERROR_PHY_NOT_READY:
>  		PM8001_IO_DBG(pm8001_ha,
>  			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
> @@ -1800,10 +1974,8 @@ static void mpi_ssp_event(struct pm8001_hba_info
> *pm8001_ha , void *piomb)
>  	case IO_XFER_OPEN_RETRY_TIMEOUT:
>  		PM8001_IO_DBG(pm8001_ha,
>  			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
> -		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAS_OPEN_REJECT;
> -		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
> -		break;
> +		pm8001_handle_event(pm8001_ha, t,
IO_XFER_OPEN_RETRY_TIMEOUT);
> +		return;
>  	case IO_XFER_ERROR_UNEXPECTED_PHASE:
>  		PM8001_IO_DBG(pm8001_ha,
>  			pm8001_printk("IO_XFER_ERROR_UNEXPECTED_PHASE\n"));
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c
> b/drivers/scsi/pm8001/pm8001_sas.c
> index fb3dc99..c8869c0 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -516,6 +516,7 @@ void pm8001_ccb_task_free(struct pm8001_hba_info
> *pm8001_ha,
>  	task->lldd_task = NULL;
>  	ccb->task = NULL;
>  	ccb->ccb_tag = 0xFFFFFFFF;
> +	ccb->open_retry = 0;
>  	pm8001_ccb_free(pm8001_ha, ccb_idx);
>  }
> 
> @@ -860,6 +861,77 @@ static int pm8001_issue_ssp_tmf(struct domain_device
> *dev,
>  		tmf);
>  }
> 
> +/* retry commands by ha, by task and/or by device */
> +void pm8001_open_reject_retry(
> +	struct pm8001_hba_info *pm8001_ha,
> +	struct sas_task *task_to_close,
> +	struct pm8001_device *device_to_close)
> +{
> +	int i;
> +	unsigned long flags;
> +
> +	if (pm8001_ha == NULL)
> +		return;
> +
> +	spin_lock_irqsave(&pm8001_ha->lock, flags);
> +
> +	for (i = 0; i < PM8001_MAX_CCB; i++) {
> +		struct sas_task *task;
> +		struct task_status_struct *ts;
> +		struct pm8001_device *pm8001_dev;
> +		unsigned long flags1;
> +		u32 tag;
> +		struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[i];
> +
> +		pm8001_dev = ccb->device;
> +		if (!pm8001_dev || (pm8001_dev->dev_type == NO_DEVICE))
> +			continue;
> +		if (!device_to_close) {
> +			uintptr_t d = (uintptr_t)pm8001_dev
> +					- (uintptr_t)&pm8001_ha->devices;
> +			if (((d % sizeof(*pm8001_dev)) != 0)
> +			 || ((d / sizeof(*pm8001_dev)) >=
PM8001_MAX_DEVICES))
> +				continue;
> +		} else if (pm8001_dev != device_to_close)
> +			continue;
> +		tag = ccb->ccb_tag;
> +		if (!tag || (tag == 0xFFFFFFFF))
> +			continue;
> +		task = ccb->task;
> +		if (!task || !task->task_done)
> +			continue;
> +		if (task_to_close && (task != task_to_close))
> +			continue;
> +		ts = &task->task_status;
> +		ts->resp = SAS_TASK_COMPLETE;
> +		/* Force the midlayer to retry */
> +		ts->stat = SAS_OPEN_REJECT;
> +		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
> +		if (pm8001_dev)
> +			pm8001_dev->running_req--;
> +		spin_lock_irqsave(&task->task_state_lock, flags1);
> +		task->task_state_flags &= ~SAS_TASK_STATE_PENDING;
> +		task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
> +		task->task_state_flags |= SAS_TASK_STATE_DONE;
> +		if (unlikely((task->task_state_flags
> +				& SAS_TASK_STATE_ABORTED))) {
> +			spin_unlock_irqrestore(&task->task_state_lock,
> +				flags1);
> +			pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
> +		} else {
> +			spin_unlock_irqrestore(&task->task_state_lock,
> +				flags1);
> +			pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
> +			mb();/* in order to force CPU ordering */
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +			task->task_done(task);
> +			spin_lock_irqsave(&pm8001_ha->lock, flags);
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +}
> +
>  /**
>    * Standard mandates link reset for ATA  (type 0) and hard reset for
>    * SSP (type 1) , only for RECOVERY
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h
> b/drivers/scsi/pm8001/pm8001_sas.h
> index 93959fe..43cd49b 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -235,6 +235,7 @@ struct pm8001_ccb_info {
>  	struct pm8001_device	*device;
>  	struct pm8001_prd	buf_prd[PM8001_MAX_DMA_SG];
>  	struct fw_control_ex	*fw_control_context;
> +	u8			open_retry;
>  };
> 
>  struct mpi_mem {
> @@ -484,6 +485,10 @@ void pm8001_dev_gone(struct domain_device *dev);
>  int pm8001_lu_reset(struct domain_device *dev, u8 *lun);
>  int pm8001_I_T_nexus_reset(struct domain_device *dev);
>  int pm8001_query_task(struct sas_task *task);
> +void pm8001_open_reject_retry(
> +	struct pm8001_hba_info *pm8001_ha,
> +	struct sas_task *task_to_close,
> +	struct pm8001_device *device_to_close);
>  int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,
>  	dma_addr_t *pphys_addr, u32 *pphys_addr_hi, u32 *pphys_addr_lo,
>  	u32 mem_size, u32 align);
> 
> ______________________________________________________________________
> This email may contain privileged or confidential information, which
should
> only be used for the purpose for which it was sent by Xyratex. No further
rights
> or licenses are granted to use such information. If you are not the
intended
> recipient of this message, please notify the sender by return and delete
it.
> You may not use, copy, disclose or rely on the information contained in
it.
> 
> Internet email is susceptible to data corruption, interception and
> unauthorised amendment for which Xyratex does not accept liability. While
we
> have taken reasonable precautions to ensure that this email is free of
viruses,
> Xyratex does not accept liability for the presence of any computer viruses
in
> this email, nor for any losses caused as a result of viruses.
> 
> Xyratex Technology Limited (03134912), Registered in England & Wales,
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
> 
> The Xyratex group of companies also includes, Xyratex Ltd, registered in
> Bermuda, Xyratex International Inc, registered in California, Xyratex
> (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co
Ltd
> registered in The People's Republic of China and Xyratex Japan Limited
> registered in Japan.
> ______________________________________________________________________
> 

