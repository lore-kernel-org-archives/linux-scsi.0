From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/3] qla2xxx: Assign names to the flags in cmd_flags
Date: Thu, 31 Mar 2016 09:56:07 +0200
Message-ID: <f377547ae9f56b39e2c26aaec1ceecfa@suse.de>
References: <56FC6049.3090303@sandisk.com> <56FC6096.30507@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbcCaH4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 03:56:09 -0400
In-Reply-To: <56FC6096.30507@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-03-31 01:26, Bart Van Assche wrote:
> Use a C bitfield instead of emulating this functionality with
> bit manipulations. Since only bits 5, 16 and 20 are ever tested,
> remove the code that sets the other bits. This is easy to verify
> by running the following command:
> 
> $ git grep -nH 'BIT_[0-9]' drivers/scsi/qla2xxx | grep cmd_flags
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Quinn Tran <quinn.tran@qlogic.com>
> Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/qla2xxx/qla_target.c  | 23 +++++------------------
>  drivers/scsi/qla2xxx/qla_target.h  | 36 
> +++++-------------------------------
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 33 
> ++++++++++++++++-----------------
>  3 files changed, 26 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c
> b/drivers/scsi/qla2xxx/qla_target.c
> index 8a44d15..8b8622d 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3291,7 +3291,6 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
>  		return EIO;
>  	}
>  	cmd->aborted = 1;
> -	cmd->cmd_flags |= BIT_6;
>  	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> 
>  	qlt_send_term_exchange(vha, cmd, &cmd->atio, 0, 1);
> @@ -3339,7 +3338,6 @@ static int qlt_prepare_srr_ctio(struct 
> scsi_qla_host *vha,
>  	struct qla_tgt_srr_imm *imm;
> 
>  	tgt->ctio_srr_id++;
> -	cmd->cmd_flags |= BIT_15;
> 
>  	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf019,
>  	    "qla_target(%d): CTIO with SRR status received\n", vha->vp_idx);
> @@ -3522,7 +3520,6 @@ qlt_abort_cmd_on_host_reset(struct scsi_qla_host
> *vha, struct qla_tgt_cmd *cmd)
>  		dump_stack();
>  	}
> 
> -	cmd->cmd_flags |= BIT_17;
>  	ha->tgt.tgt_ops->free_cmd(cmd);
>  }
> 
> @@ -3688,7 +3685,6 @@ static void qlt_do_ctio_completion(struct
> scsi_qla_host *vha, uint32_t handle,
>  		 */
>  		if ((cmd->state != QLA_TGT_STATE_NEED_DATA) &&
>  		    (!cmd->aborted)) {
> -			cmd->cmd_flags |= BIT_13;
>  			if (qlt_term_ctio_exchange(vha, ctio, cmd, status))
>  				return;
>  		}
> @@ -3696,7 +3692,7 @@ static void qlt_do_ctio_completion(struct
> scsi_qla_host *vha, uint32_t handle,
>  skip_term:
> 
>  	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
> -		cmd->cmd_flags |= BIT_12;
> +		;
>  	} else if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
>  		cmd->state = QLA_TGT_STATE_DATA_IN;

What about:
if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
         cmd->state = QLA_TGT_STATE_DATA_IN;
[...]

I.e. kick that nop
if (cmd->state == QLA_TGT_STATE_NEED_DATA)
       ;

> 
> @@ -3706,11 +3702,9 @@ skip_term:
>  		ha->tgt.tgt_ops->handle_data(cmd);
>  		return;
>  	} else if (cmd->aborted) {
> -		cmd->cmd_flags |= BIT_18;
>  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01e,
>  		  "Aborted command %p (tag %lld) finished\n", cmd, se_cmd->tag);
>  	} else {
> -		cmd->cmd_flags |= BIT_19;
>  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05c,
>  		    "qla_target(%d): A command in state (%d) should "
>  		    "not return a CTIO complete\n", vha->vp_idx, cmd->state);
> @@ -3775,7 +3769,6 @@ static void __qlt_do_work(struct qla_tgt_cmd 
> *cmd)
>  	int ret, fcp_task_attr, data_dir, bidi = 0;
> 
>  	cmd->cmd_in_wq = 0;
> -	cmd->cmd_flags |= BIT_1;
>  	if (tgt->tgt_stop)
>  		goto out_term;
> 
> @@ -3827,7 +3820,6 @@ out_term:
>  	 * cmd has not sent to target yet, so pass NULL as the second
>  	 * argument to qlt_send_term_exchange() and free the memory here.
>  	 */
> -	cmd->cmd_flags |= BIT_2;
>  	spin_lock_irqsave(&ha->hardware_lock, flags);
>  	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1, 0);
> 
> @@ -3878,7 +3870,8 @@ static struct qla_tgt_cmd
> *qlt_get_tag(scsi_qla_host_t *vha,
>  	cmd->loop_id = sess->loop_id;
>  	cmd->conf_compl_supported = sess->conf_compl_supported;
> 
> -	cmd->cmd_flags = 0;
> +	cmd->status_queued = cmd->cmd_freed = cmd->complete_free = 0;
> +	cmd->data_work = cmd->data_work_free = 0;
>  	cmd->jiffies_at_alloc = get_jiffies_64();
> 
>  	cmd->reset_count = vha->hw->chip_reset;
> @@ -4014,7 +4007,6 @@ static int qlt_handle_cmd_for_atio(struct
> scsi_qla_host *vha,
>  	}
> 
>  	cmd->cmd_in_wq = 1;
> -	cmd->cmd_flags |= BIT_0;
>  	cmd->se_cmd.cpuid = ha->msix_count ?
>  		ha->tgt.rspq_vector_cpuid : WORK_CPU_UNBOUND;
> 
> @@ -4767,10 +4759,8 @@ static void qlt_handle_srr(struct scsi_qla_host 
> *vha,
>  			qlt_send_notify_ack(vha, ntfy,
>  			    0, 0, 0, NOTIFY_ACK_SRR_FLAGS_ACCEPT, 0, 0);
>  			spin_unlock_irqrestore(&ha->hardware_lock, flags);
> -			if (xmit_type & QLA_TGT_XMIT_DATA) {
> -				cmd->cmd_flags |= BIT_8;
> +			if (xmit_type & QLA_TGT_XMIT_DATA)
>  				qlt_rdy_to_xfer(cmd);
> -			}
>  		} else {
>  			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf066,
>  			    "qla_target(%d): SRR for out data for cmd without them (tag
> %lld, SCSI status %d), reject",
> @@ -4786,10 +4776,8 @@ static void qlt_handle_srr(struct scsi_qla_host 
> *vha,
>  	}
> 
>  	/* Transmit response in case of status and data-in cases */
> -	if (resp) {
> -		cmd->cmd_flags |= BIT_7;
> +	if (resp)
>  		qlt_xmit_response(cmd, xmit_type, se_cmd->scsi_status);
> -	}
> 
>  	return;
> 
> @@ -4803,7 +4791,6 @@ out_reject:
>  		cmd->state = QLA_TGT_STATE_DATA_IN;
>  		dump_stack();
>  	} else {
> -		cmd->cmd_flags |= BIT_9;
>  		qlt_send_term_exchange(vha, cmd, &cmd->atio, 1, 0);
>  	}
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> diff --git a/drivers/scsi/qla2xxx/qla_target.h
> b/drivers/scsi/qla2xxx/qla_target.h
> index d857fee..9cf2aef 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -943,36 +943,6 @@ struct qla_tgt_sess {
>  	qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
>  };
> 
> -typedef enum {
> -	/*
> -	 * BIT_0 - Atio Arrival / schedule to work
> -	 * BIT_1 - qlt_do_work
> -	 * BIT_2 - qlt_do work failed
> -	 * BIT_3 - xfer rdy/tcm_qla2xxx_write_pending
> -	 * BIT_4 - read respond/tcm_qla2xx_queue_data_in
> -	 * BIT_5 - status respond / tcm_qla2xx_queue_status
> -	 * BIT_6 - tcm request to abort/Term exchange.
> -	 *	pre_xmit_response->qlt_send_term_exchange
> -	 * BIT_7 - SRR received (qlt_handle_srr->qlt_xmit_response)
> -	 * BIT_8 - SRR received (qlt_handle_srr->qlt_rdy_to_xfer)
> -	 * BIT_9 - SRR received (qla_handle_srr->qlt_send_term_exchange)
> -	 * BIT_10 - Data in - hanlde_data->tcm_qla2xxx_handle_data
> -
> -	 * BIT_12 - good completion - qlt_ctio_do_completion -->free_cmd
> -	 * BIT_13 - Bad completion -
> -	 *	qlt_ctio_do_completion --> qlt_term_ctio_exchange
> -	 * BIT_14 - Back end data received/sent.
> -	 * BIT_15 - SRR prepare ctio
> -	 * BIT_16 - complete free
> -	 * BIT_17 - flush - qlt_abort_cmd_on_host_reset
> -	 * BIT_18 - completion w/abort status
> -	 * BIT_19 - completion w/unknown status
> -	 * BIT_20 - tcm_qla2xxx_free_cmd
> -	 */
> -	CMD_FLAG_DATA_WORK = BIT_11,
> -	CMD_FLAG_DATA_WORK_FREE = BIT_21,
> -} cmd_flags_t;
> -
>  struct qla_tgt_cmd {
>  	struct se_cmd se_cmd;
>  	struct qla_tgt_sess *sess;
> @@ -1018,7 +988,11 @@ struct qla_tgt_cmd {
>  	uint64_t jiffies_at_alloc;
>  	uint64_t jiffies_at_free;
> 
> -	cmd_flags_t cmd_flags;
> +	unsigned status_queued:1;
> +	unsigned cmd_freed:1;
> +	unsigned complete_free:1;
> +	unsigned data_work:1;
> +	unsigned data_work_free:1;
>  };
> 
>  struct qla_tgt_sess_work_param {
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 97fcbf2..36500b3 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -282,10 +282,10 @@ static void tcm_qla2xxx_complete_free(struct
> work_struct *work)
> 
>  	cmd->cmd_in_wq = 0;
> 
> -	WARN_ON(cmd->cmd_flags &  BIT_16);
> +	WARN_ON(cmd->complete_free);
> 
>  	cmd->vha->tgt_counters.qla_core_ret_sta_ctio++;
> -	cmd->cmd_flags |= BIT_16;
> +	cmd->complete_free = 1;
>  	transport_generic_free_cmd(&cmd->se_cmd, 0);
>  }
> 
> @@ -299,8 +299,8 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd 
> *cmd)
>  	cmd->vha->tgt_counters.core_qla_free_cmd++;
>  	cmd->cmd_in_wq = 1;
> 
> -	BUG_ON(cmd->cmd_flags & BIT_20);
> -	cmd->cmd_flags |= BIT_20;
> +	BUG_ON(cmd->cmd_freed);
> +	cmd->cmd_freed = 1;
> 
>  	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
>  	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
> @@ -385,7 +385,6 @@ static int tcm_qla2xxx_write_pending(struct se_cmd 
> *se_cmd)
>  			cmd->se_cmd.se_cmd_flags);
>  		return 0;
>  	}
> -	cmd->cmd_flags |= BIT_3;
>  	cmd->bufflen = se_cmd->data_length;
>  	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
> 
> @@ -488,9 +487,9 @@ static void tcm_qla2xxx_handle_data_work(struct
> work_struct *work)
>  	cmd->cmd_in_wq = 0;
> 
>  	spin_lock_irqsave(&cmd->cmd_lock, flags);
> -	cmd->cmd_flags |= CMD_FLAG_DATA_WORK;
> +	cmd->data_work = 1;
>  	if (cmd->aborted) {
> -		cmd->cmd_flags |= CMD_FLAG_DATA_WORK_FREE;
> +		cmd->data_work_free = 1;
>  		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> 
>  		tcm_qla2xxx_free_cmd(cmd);
> @@ -527,7 +526,6 @@ static void tcm_qla2xxx_handle_data_work(struct
> work_struct *work)
>   */
>  static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
>  {
> -	cmd->cmd_flags |= BIT_10;
>  	cmd->cmd_in_wq = 1;
>  	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
>  	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
> @@ -586,7 +584,6 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd 
> *se_cmd)
>  		return 0;
>  	}
> 
> -	cmd->cmd_flags |= BIT_4;
>  	cmd->bufflen = se_cmd->data_length;
>  	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
> 
> @@ -617,11 +614,11 @@ static int tcm_qla2xxx_queue_status(struct se_cmd 
> *se_cmd)
>  	cmd->sg_cnt = 0;
>  	cmd->offset = 0;
>  	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
> -	if (cmd->cmd_flags &  BIT_5) {
> -		pr_crit("Bit_5 already set for cmd = %p.\n", cmd);
> +	if (cmd->status_queued) {
> +		pr_crit("Status already queued for cmd = %p.\n", cmd);
>  		dump_stack();
>  	}
> -	cmd->cmd_flags |= BIT_5;
> +	cmd->status_queued = 1;
> 
>  	if (se_cmd->data_direction == DMA_FROM_DEVICE) {
>  		/*
> @@ -678,9 +675,11 @@ static void tcm_qla2xxx_queue_tm_rsp(struct se_cmd 
> *se_cmd)
>  }
> 
> 
> -#define DATA_WORK_NOT_FREE(_flags) \
> -	(( _flags & (CMD_FLAG_DATA_WORK|CMD_FLAG_DATA_WORK_FREE)) == \
> -	 CMD_FLAG_DATA_WORK)
> +static inline bool DATA_WORK_NOT_FREE(struct qla_tgt_cmd *cmd)
> +{
> +	return cmd->data_work && !cmd->data_work_free;
> +}
> +

Can you make that lower case?

>  static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
>  {
>  	struct qla_tgt_cmd *cmd = container_of(se_cmd,
> @@ -693,9 +692,9 @@ static void tcm_qla2xxx_aborted_task(struct se_cmd 
> *se_cmd)
>  	spin_lock_irqsave(&cmd->cmd_lock, flags);
>  	if ((cmd->state == QLA_TGT_STATE_NEW)||
>  		((cmd->state == QLA_TGT_STATE_DATA_IN) &&
> -		 DATA_WORK_NOT_FREE(cmd->cmd_flags)) ) {
> +		 DATA_WORK_NOT_FREE(cmd))) {
> 
> -		cmd->cmd_flags |= CMD_FLAG_DATA_WORK_FREE;
> +		cmd->data_work_free = 1;
>  		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
>  		/* Cmd have not reached firmware.
>  		 * Use this trigger to free it. */

