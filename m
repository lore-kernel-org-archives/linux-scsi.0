From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/20] qla2xxx: Fix interaction issue between qla2xxx and
 Target Core Module
Date: Wed, 9 Dec 2015 08:01:14 +0100
Message-ID: <5667D1BA.6070106@suse.de>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-11-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbbLIHBR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Dec 2015 02:01:17 -0500
In-Reply-To: <1449535747-2850-11-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 12/08/2015 01:48 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
>=20
> During lun reset, TMR thread from TCM would issue abort
> to qla driver.  At abort time, each command is in different
> state.  Depending on the state, qla will use the TMR thread
> to trigger a command free(cmd_kref--) if command is not
> down at firmware.
>=20
> Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c  |   60 +++++++++++++++++++++-----=
---
>  drivers/scsi/qla2xxx/qla_target.h  |   59 +++++++++++++++++---------=
---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   73 ++++++++++++++++++++++++++=
++++++++-
>  3 files changed, 147 insertions(+), 45 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx=
/qla_target.c
> index 638940f..4d42b79 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -105,7 +105,7 @@ static void qlt_response_pkt(struct scsi_qla_host=
 *ha, response_t *pkt);
>  static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t l=
un,
>  	int fn, void *iocb, int flags);
>  static void qlt_send_term_exchange(struct scsi_qla_host *ha, struct =
qla_tgt_cmd
> -	*cmd, struct atio_from_isp *atio, int ha_locked);
> +	*cmd, struct atio_from_isp *atio, int ha_locked, int ul_abort);
>  static void qlt_reject_free_srr_imm(struct scsi_qla_host *ha,
>  	struct qla_tgt_srr_imm *imm, int ha_lock);
>  static void qlt_abort_cmd_on_host_reset(struct scsi_qla_host *vha,
> @@ -2646,7 +2646,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, =
int xmit_type,
>  			/* no need to terminate. FW already freed exchange. */
>  			qlt_abort_cmd_on_host_reset(cmd->vha, cmd);
>  		else
> -			qlt_send_term_exchange(vha, cmd, &cmd->atio, 1);
> +			qlt_send_term_exchange(vha, cmd, &cmd->atio, 1, 0);
>  		spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  		return 0;
>  	}
> @@ -3154,7 +3154,8 @@ static int __qlt_send_term_exchange(struct scsi=
_qla_host *vha,
>  }
> =20
>  static void qlt_send_term_exchange(struct scsi_qla_host *vha,
> -	struct qla_tgt_cmd *cmd, struct atio_from_isp *atio, int ha_locked)
> +	struct qla_tgt_cmd *cmd, struct atio_from_isp *atio, int ha_locked,
> +	int ul_abort)
>  {
>  	unsigned long flags =3D 0;
>  	int rc;
> @@ -3174,8 +3175,7 @@ static void qlt_send_term_exchange(struct scsi_=
qla_host *vha,
>  		qlt_alloc_qfull_cmd(vha, atio, 0, 0);
> =20
>  done:
> -	if (cmd && (!cmd->aborted ||
> -	    !cmd->cmd_sent_to_fw)) {
> +	if (cmd && !ul_abort && !cmd->aborted) {
>  		if (cmd->sg_mapped)
>  			qlt_unmap_sg(vha, cmd);
>  		vha->hw->tgt.tgt_ops->free_cmd(cmd);
> @@ -3234,21 +3234,43 @@ static void qlt_chk_exch_leak_thresh_hold(str=
uct scsi_qla_host *vha)
> =20
>  }
> =20
> -void qlt_abort_cmd(struct qla_tgt_cmd *cmd)
> +int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
>  {
>  	struct qla_tgt *tgt =3D cmd->tgt;
>  	struct scsi_qla_host *vha =3D tgt->vha;
>  	struct se_cmd *se_cmd =3D &cmd->se_cmd;
> +	unsigned long flags,refcount;
> =20
>  	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
>  	    "qla_target(%d): terminating exchange for aborted cmd=3D%p "
>  	    "(se_cmd=3D%p, tag=3D%llu)", vha->vp_idx, cmd, &cmd->se_cmd,
>  	    se_cmd->tag);
> =20
> +    spin_lock_irqsave(&cmd->cmd_lock, flags);
> +    if (cmd->aborted) {
> +        spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> +
> +        /* It's normal to see 2 calls in this path:
> +         *  1) XFER Rdy completion + CMD_T_ABORT
> +         *  2) TCM TMR - drain_state_list
> +         */
> +        refcount =3D atomic_read(&cmd->se_cmd.cmd_kref.refcount);
> +        ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
> +               "multiple abort. %p refcount %lx"
> +               "transport_state %x, t_state %x, se_cmd_flags %x \n",
> +               cmd, refcount,cmd->se_cmd.transport_state,
> +               cmd->se_cmd.t_state,cmd->se_cmd.se_cmd_flags);
> +
> +        return EIO;
> +    }
> +
>  	cmd->aborted =3D 1;
>  	cmd->cmd_flags |=3D BIT_6;
> +    spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> +
> +	qlt_send_term_exchange(vha, cmd, &cmd->atio, 0, 1);
> =20
> -	qlt_send_term_exchange(vha, cmd, &cmd->atio, 0);
> +	return 0;
>  }
>  EXPORT_SYMBOL(qlt_abort_cmd);
> =20
> @@ -3263,6 +3285,9 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
> =20
>  	BUG_ON(cmd->cmd_in_wq);
> =20
> +	if (cmd->sg_mapped)
> +		qlt_unmap_sg(cmd->vha, cmd);
> +
>  	if (!cmd->q_full)
>  		qlt_decr_num_pend_cmds(cmd->vha);
> =20
> @@ -3380,7 +3405,7 @@ static int qlt_term_ctio_exchange(struct scsi_q=
la_host *vha, void *ctio,
>  		term =3D 1;
> =20
>  	if (term)
> -		qlt_send_term_exchange(vha, cmd, &cmd->atio, 1);
> +		qlt_send_term_exchange(vha, cmd, &cmd->atio, 1, 0);
> =20
>  	return term;
>  }
> @@ -3735,6 +3760,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *c=
md)
>  		goto out_term;
>  	}
> =20
> +	spin_lock_init(&cmd->cmd_lock);
>  	cdb =3D &atio->u.isp24.fcp_cmnd.cdb[0];
>  	cmd->se_cmd.tag =3D atio->u.isp24.exchange_addr;
>  	cmd->unpacked_lun =3D scsilun_to_int(
> @@ -3777,7 +3803,7 @@ out_term:
>  	 */
>  	cmd->cmd_flags |=3D BIT_2;
>  	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1);
> +	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1, 0);
> =20
>  	qlt_decr_num_pend_cmds(vha);
>  	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag)=
;
> @@ -3896,7 +3922,7 @@ static void qlt_create_sess_from_atio(struct wo=
rk_struct *work)
> =20
>  out_term:
>  	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	qlt_send_term_exchange(vha, NULL, &op->atio, 1);
> +	qlt_send_term_exchange(vha, NULL, &op->atio, 1, 0);
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  	kfree(op);
> =20
> @@ -4722,7 +4748,7 @@ out_reject:
>  		dump_stack();
>  	} else {
>  		cmd->cmd_flags |=3D BIT_9;
> -		qlt_send_term_exchange(vha, cmd, &cmd->atio, 1);
> +		qlt_send_term_exchange(vha, cmd, &cmd->atio, 1, 0);
>  	}
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  }
> @@ -4901,7 +4927,7 @@ static void qlt_prepare_srr_imm(struct scsi_qla=
_host *vha,
>  				    sctio, sctio->srr_id);
>  				list_del(&sctio->srr_list_entry);
>  				qlt_send_term_exchange(vha, sctio->cmd,
> -				    &sctio->cmd->atio, 1);
> +				    &sctio->cmd->atio, 1, 0);
>  				kfree(sctio);
>  			}
>  		}
> @@ -5071,7 +5097,7 @@ static int __qlt_send_busy(struct scsi_qla_host=
 *vha,
>  	sess =3D ha->tgt.tgt_ops->find_sess_by_s_id(vha,
>  	    atio->u.isp24.fcp_hdr.s_id);
>  	if (!sess) {
> -		qlt_send_term_exchange(vha, NULL, atio, 1);
> +		qlt_send_term_exchange(vha, NULL, atio, 1, 0);
>  		return 0;
>  	}
>  	/* Sending marker isn't necessary, since we called from ISR */
> @@ -5345,7 +5371,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_h=
ost *vha,
>  #if 1 /* With TERM EXCHANGE some FC cards refuse to boot */
>  				qlt_send_busy(vha, atio, SAM_STAT_BUSY);
>  #else
> -				qlt_send_term_exchange(vha, NULL, atio, 1);
> +				qlt_send_term_exchange(vha, NULL, atio, 1, 0);
>  #endif
>  			} else {
>  				if (tgt->tgt_stop) {
> @@ -5446,7 +5472,7 @@ static void qlt_response_pkt(struct scsi_qla_ho=
st *vha, response_t *pkt)
>  #if 1 /* With TERM EXCHANGE some FC cards refuse to boot */
>  				qlt_send_busy(vha, atio, 0);
>  #else
> -				qlt_send_term_exchange(vha, NULL, atio, 1);
> +				qlt_send_term_exchange(vha, NULL, atio, 1, 0);
>  #endif
>  			} else {
>  				if (tgt->tgt_stop) {
> @@ -5455,7 +5481,7 @@ static void qlt_response_pkt(struct scsi_qla_ho=
st *vha, response_t *pkt)
>  					    "command to target, sending TERM "
>  					    "EXCHANGE for rsp\n");
>  					qlt_send_term_exchange(vha, NULL,
> -					    atio, 1);
> +					    atio, 1, 0);
>  				} else {
>  					ql_dbg(ql_dbg_tgt, vha, 0xe060,
>  					    "qla_target(%d): Unable to send "
> @@ -5875,7 +5901,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
>  	return;
> =20
>  out_term:
> -	qlt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 1);
> +	qlt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 1, 0);
>  	if (sess)
>  		ha->tgt.tgt_ops->put_sess(sess);
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx=
/qla_target.h
> index f5dbeab..a079c237 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -941,6 +941,36 @@ struct qla_tgt_sess {
>  	qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
>  };
> =20
> +typedef enum {
> +	/*
> +	 * BIT_0 - Atio Arrival / schedule to work
> +	 * BIT_1 - qlt_do_work
> +	 * BIT_2 - qlt_do work failed
> +	 * BIT_3 - xfer rdy/tcm_qla2xxx_write_pending
> +	 * BIT_4 - read respond/tcm_qla2xx_queue_data_in
> +	 * BIT_5 - status respond / tcm_qla2xx_queue_status
> +	 * BIT_6 - tcm request to abort/Term exchange.
> +	 *	pre_xmit_response->qlt_send_term_exchange
> +	 * BIT_7 - SRR received (qlt_handle_srr->qlt_xmit_response)
> +	 * BIT_8 - SRR received (qlt_handle_srr->qlt_rdy_to_xfer)
> +	 * BIT_9 - SRR received (qla_handle_srr->qlt_send_term_exchange)
> +	 * BIT_10 - Data in - hanlde_data->tcm_qla2xxx_handle_data
> +
> +	 * BIT_12 - good completion - qlt_ctio_do_completion -->free_cmd
> +	 * BIT_13 - Bad completion -
> +	 *	qlt_ctio_do_completion --> qlt_term_ctio_exchange
> +	 * BIT_14 - Back end data received/sent.
> +	 * BIT_15 - SRR prepare ctio
> +	 * BIT_16 - complete free
> +	 * BIT_17 - flush - qlt_abort_cmd_on_host_reset
> +	 * BIT_18 - completion w/abort status
> +	 * BIT_19 - completion w/unknown status
> +	 * BIT_20 - tcm_qla2xxx_free_cmd
> +	 */
> +	CMD_FLAG_DATA_WORK =3D BIT_11,
> +	CMD_FLAG_DATA_WORK_FREE =3D BIT_21,
> +} cmd_flags_t;
> +
>  struct qla_tgt_cmd {
>  	struct se_cmd se_cmd;
>  	struct qla_tgt_sess *sess;
> @@ -950,6 +980,7 @@ struct qla_tgt_cmd {
>  	/* Sense buffer that will be mapped into outgoing status */
>  	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
> =20
> +	spinlock_t cmd_lock;
>  	/* to save extra sess dereferences */
>  	unsigned int conf_compl_supported:1;
>  	unsigned int sg_mapped:1;
> @@ -984,30 +1015,8 @@ struct qla_tgt_cmd {
> =20
>  	uint64_t jiffies_at_alloc;
>  	uint64_t jiffies_at_free;
> -	/* BIT_0 - Atio Arrival / schedule to work
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
> -	 * BIT_11 - Data actually going to TCM : tcm_qla2xx_handle_data_wor=
k
> -	 * BIT_12 - good completion - qlt_ctio_do_completion -->free_cmd
> -	 * BIT_13 - Bad completion -
> -	 *	qlt_ctio_do_completion --> qlt_term_ctio_exchange
> -	 * BIT_14 - Back end data received/sent.
> -	 * BIT_15 - SRR prepare ctio
> -	 * BIT_16 - complete free
> -	 * BIT_17 - flush - qlt_abort_cmd_on_host_reset
> -	 * BIT_18 - completion w/abort status
> -	 * BIT_19 - completion w/unknown status
> -	 */
> -	uint32_t cmd_flags;
> +
> +	cmd_flags_t cmd_flags;
>  };
> =20
>  struct qla_tgt_sess_work_param {
> @@ -1146,7 +1155,7 @@ static inline void sid_to_portid(const uint8_t =
*s_id, port_id_t *p)
>  extern void qlt_response_pkt_all_vps(struct scsi_qla_host *, respons=
e_t *);
>  extern int qlt_rdy_to_xfer(struct qla_tgt_cmd *);
>  extern int qlt_xmit_response(struct qla_tgt_cmd *, int, uint8_t);
> -extern void qlt_abort_cmd(struct qla_tgt_cmd *);
> +extern int qlt_abort_cmd(struct qla_tgt_cmd *);
>  extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
>  extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
>  extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xx=
x/tcm_qla2xxx.c
> index 366142a..842fcca 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -298,6 +298,10 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_=
cmd *cmd)
>  {
>  	cmd->vha->tgt_counters.core_qla_free_cmd++;
>  	cmd->cmd_in_wq =3D 1;
> +
> +	BUG_ON(cmd->cmd_flags & BIT_20);
> +	cmd->cmd_flags |=3D BIT_20;
> +
>  	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
>  	queue_work(tcm_qla2xxx_free_wq, &cmd->work);
>  }
Why not test_and_set_bit()?

> @@ -375,6 +379,20 @@ static int tcm_qla2xxx_write_pending(struct se_c=
md *se_cmd)
>  {
>  	struct qla_tgt_cmd *cmd =3D container_of(se_cmd,
>  				struct qla_tgt_cmd, se_cmd);
> +
> +	if (cmd->aborted) {
> +		/* Cmd can loop during Q-full.  tcm_qla2xxx_aborted_task
> +		 * can get ahead of this cmd. tcm_qla2xxx_aborted_task
> +		 * already kick start the free.
> +		 */
> +		pr_debug("write_pending aborted cmd[%p] refcount %d "
> +			"transport_state %x, t_state %x, se_cmd_flags %x\n",
> +			cmd,cmd->se_cmd.cmd_kref.refcount.counter,
> +			cmd->se_cmd.transport_state,
> +			cmd->se_cmd.t_state,
> +			cmd->se_cmd.se_cmd_flags);
> +		return 0;
> +	}
>  	cmd->cmd_flags |=3D BIT_3;
>  	cmd->bufflen =3D se_cmd->data_length;
>  	cmd->dma_data_direction =3D target_reverse_dma_direction(se_cmd);
> @@ -406,7 +424,7 @@ static int tcm_qla2xxx_write_pending_status(struc=
t se_cmd *se_cmd)
>  	    se_cmd->t_state =3D=3D TRANSPORT_COMPLETE_QF_WP) {
>  		spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
>  		wait_for_completion_timeout(&se_cmd->t_transport_stop_comp,
> -					    3 * HZ);
> +						50);
>  		return 0;
>  	}
>  	spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
> @@ -466,13 +484,25 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host=
_t *vha, struct qla_tgt_cmd *cmd,
>  static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
>  {
>  	struct qla_tgt_cmd *cmd =3D container_of(work, struct qla_tgt_cmd, =
work);
> +	unsigned long flags;
> =20
>  	/*
>  	 * Ensure that the complete FCP WRITE payload has been received.
>  	 * Otherwise return an exception via CHECK_CONDITION status.
>  	 */
>  	cmd->cmd_in_wq =3D 0;
> -	cmd->cmd_flags |=3D BIT_11;
> +
> +	spin_lock_irqsave(&cmd->cmd_lock, flags);
> +	cmd->cmd_flags |=3D CMD_FLAG_DATA_WORK;
> +	if (cmd->aborted) {
> +		cmd->cmd_flags |=3D CMD_FLAG_DATA_WORK_FREE;
> +		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> +
> +		tcm_qla2xxx_free_cmd(cmd);
> +		return;
> +	}
> +	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> +
>  	cmd->vha->tgt_counters.qla_core_ret_ctio++;
>  	if (!cmd->write_data_transferred) {
>  		/*
> @@ -547,6 +577,20 @@ static int tcm_qla2xxx_queue_data_in(struct se_c=
md *se_cmd)
>  	struct qla_tgt_cmd *cmd =3D container_of(se_cmd,
>  				struct qla_tgt_cmd, se_cmd);
> =20
> +	if (cmd->aborted) {
> +		/* Cmd can loop during Q-full.  tcm_qla2xxx_aborted_task
> +		 * can get ahead of this cmd. tcm_qla2xxx_aborted_task
> +		 * already kick start the free.
> +		 */
> +		pr_debug("queue_data_in aborted cmd[%p] refcount %d "
> +			"transport_state %x, t_state %x, se_cmd_flags %x\n",
> +			cmd,cmd->se_cmd.cmd_kref.refcount.counter,
> +			cmd->se_cmd.transport_state,
> +			cmd->se_cmd.t_state,
> +			cmd->se_cmd.se_cmd_flags);
> +		return 0;
> +	}
> +
>  	cmd->cmd_flags |=3D BIT_4;
>  	cmd->bufflen =3D se_cmd->data_length;
>  	cmd->dma_data_direction =3D target_reverse_dma_direction(se_cmd);
> @@ -638,11 +682,34 @@ static void tcm_qla2xxx_queue_tm_rsp(struct se_=
cmd *se_cmd)
>  	qlt_xmit_tm_rsp(mcmd);
>  }
> =20
> +
> +#define DATA_WORK_NOT_FREE(_flags) \
> +	(( _flags & (CMD_FLAG_DATA_WORK|CMD_FLAG_DATA_WORK_FREE)) =3D=3D \
> +	 CMD_FLAG_DATA_WORK)
>  static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
>  {
>  	struct qla_tgt_cmd *cmd =3D container_of(se_cmd,
>  				struct qla_tgt_cmd, se_cmd);
> -	qlt_abort_cmd(cmd);
> +	unsigned long flags;
> +
> +	if (qlt_abort_cmd(cmd))
> +		return;
> +
> +	spin_lock_irqsave(&cmd->cmd_lock, flags);
> +	if ((cmd->state =3D=3D QLA_TGT_STATE_NEW)||
> +		((cmd->state =3D=3D QLA_TGT_STATE_DATA_IN) &&
> +		 DATA_WORK_NOT_FREE(cmd->cmd_flags)) ) {
> +
> +		cmd->cmd_flags |=3D CMD_FLAG_DATA_WORK_FREE;
> +		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> +		/* Cmd have not reached firmware.
> +		 * Use this trigger to free it. */
> +		tcm_qla2xxx_free_cmd(cmd);
> +		return;
> +	}
> +	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> +	return;
> +
>  }
> =20
>  static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *=
,
>=20
Have you considered moving to bit ops when modifying cmd_flags?
I guess you can also move the ->aborted bit into the bit field, and
could get rid of some of the spinlocks ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
