From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/20] qla2xxx: Fix interaction issue between qla2xxx and
 Target Core Module
Date: Mon, 7 Dec 2015 18:37:00 -0800
Message-ID: <20151208023700.GB9088@infradead.org>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-11-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbbLHChA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2015 21:37:00 -0500
Content-Disposition: inline
In-Reply-To: <1449535747-2850-11-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

> -void qlt_abort_cmd(struct qla_tgt_cmd *cmd)
> +int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
>  {
>  	struct qla_tgt *tgt = cmd->tgt;
>  	struct scsi_qla_host *vha = tgt->vha;
>  	struct se_cmd *se_cmd = &cmd->se_cmd;
> +	unsigned long flags,refcount;
>  
>  	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
>  	    "qla_target(%d): terminating exchange for aborted cmd=%p "
>  	    "(se_cmd=%p, tag=%llu)", vha->vp_idx, cmd, &cmd->se_cmd,
>  	    se_cmd->tag);
>  
> +    spin_lock_irqsave(&cmd->cmd_lock, flags);
> +    if (cmd->aborted) {
> +        spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> +
> +        /* It's normal to see 2 calls in this path:
> +         *  1) XFER Rdy completion + CMD_T_ABORT
> +         *  2) TCM TMR - drain_state_list
> +         */
> +        refcount = atomic_read(&cmd->se_cmd.cmd_kref.refcount);
> +        ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
> +               "multiple abort. %p refcount %lx"
> +               "transport_state %x, t_state %x, se_cmd_flags %x \n",
> +               cmd, refcount,cmd->se_cmd.transport_state,
> +               cmd->se_cmd.t_state,cmd->se_cmd.se_cmd_flags);
> +
> +        return EIO;
> +    }

Err, no.  Looking into the refcount inside a kref is never the
right thing to do.

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

Please use descriptive names for these flags in the source code!

> +	BUG_ON(cmd->cmd_flags & BIT_20);
> +	cmd->cmd_flags |= BIT_20;
> +

And no crazieness like this.  While we're at it: what synchronizes
access to ->cmd_flags?

> @@ -466,13 +484,25 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
>  static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
>  {
>  	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
> +	unsigned long flags;
>  
>  	/*
>  	 * Ensure that the complete FCP WRITE payload has been received.
>  	 * Otherwise return an exception via CHECK_CONDITION status.
>  	 */
>  	cmd->cmd_in_wq = 0;
> -	cmd->cmd_flags |= BIT_11;
> +
> +	spin_lock_irqsave(&cmd->cmd_lock, flags);
> +	cmd->cmd_flags |= CMD_FLAG_DATA_WORK;
> +	if (cmd->aborted) {
> +		cmd->cmd_flags |= CMD_FLAG_DATA_WORK_FREE;
> +		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> +
> +		tcm_qla2xxx_free_cmd(cmd);
> +		return;
> +	}
> +	spin_unlock_irqrestore(&cmd->cmd_lock, flags);

All these abort flag hacks look very suspicios.  Can you explain the
exact theory of operation behind them?

