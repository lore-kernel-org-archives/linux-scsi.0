From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v2 PATCH 4/5] bnx2fc: Broadcom FCoE Offload driver submission
 - part 2
Date: Sat, 15 Jan 2011 03:17:40 -0600
Message-ID: <4D316634.5030300@cs.wisc.edu>
References: <1293170555.4676.574.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37931 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1AOJRr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Jan 2011 04:17:47 -0500
In-Reply-To: <1293170555.4676.574.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org, mchan@broadcom.com

On 12/24/2010 12:02 AM, Bhanu Gollapudi wrote:
> +
> +static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_req, int err_code)


> +
> +	bnx2fc_dbg(LOG_IOERR, "sc=%p, result=0x%x, retries=%d, allowed=%d\n",
> +		sc_cmd, host_byte(sc_cmd->result), sc_cmd->retries,
> +		sc_cmd->allowed);
> +	scsi_set_resid(sc_cmd, scsi_bufflen(sc_cmd));
> +	sc_cmd->SCp.ptr = NULL;
> +	if (sc_cmd->scsi_done)
> +		sc_cmd->scsi_done(sc_cmd);



It seems scsi_done should always be set. In newer kernels scsi-ml sets 
this too, so you should remove the checks.



> +
> +u16 bnx2fc_get_xid(struct bnx2fc_cmd *io_req, struct bnx2fc_hba *hba)
> +{
> +	u16 xid;
> +	xid = io_req->xid;
> +	return xid;
> +}

Kind of a useless function.


> +
> +static void bnx2fc_cmd_hold(struct bnx2fc_cmd *io_req)
> +{
> +	atomic_inc(&io_req->cmd_refcnt);
> +}


Use krefs.


> +
> +int bnx2fc_init_mp_req(struct bnx2fc_cmd *io_req)
> +{
> +	struct bnx2fc_mp_req *mp_req;
> +	struct fcoe_bd_ctx *mp_req_bd;
> +	struct fcoe_bd_ctx *mp_resp_bd;
> +	struct bnx2fc_hba *hba = io_req->port->hba;
> +	dma_addr_t addr;
> +	size_t sz;
> +
> +	bnx2fc_dbg(LOG_IOERR, "Entered bnx2fc_init_mp_req\n");
> +


For your logging and printks, I think you want to add the host or rport 
that is having the problem.

There is the scsi printks and maybe libfc or the fc class could export 
some fc specific ones.



> +	mp_req = (struct bnx2fc_mp_req *)&(io_req->mp_req);
> +	memset(mp_req, 0, sizeof(struct bnx2fc_mp_req));
> +
> +	mp_req->req_len = sizeof(struct fcp_cmnd);
> +	io_req->data_xfer_len = mp_req->req_len;
> +	mp_req->req_buf = dma_alloc_coherent(&hba->pcidev->dev, 0x1000,
> +					&mp_req->req_buf_dma,
> +					     GFP_ATOMIC);


I think you can use GFP_NOIO in these allocations.

What is the 0x1000 value based off of? Is it hardware or is just due 
because it is the page size on many archs?



> +	if (!mp_req->req_buf) {
> +		printk(KERN_ERR PFX "unable to alloc MP req buffer\n");
> +		bnx2fc_free_mp_resc(io_req);
> +		return FAILED;
> +	}
> +
> +	mp_req->resp_buf = dma_alloc_coherent(&hba->pcidev->dev, 0x1000,
> +					&mp_req->resp_buf_dma,
> +					      GFP_ATOMIC);
> +	if (!mp_req->resp_buf) {
> +		printk(KERN_ERR PFX "unable to alloc TM resp buffer\n");
> +		bnx2fc_free_mp_resc(io_req);
> +		return FAILED;
> +	}
> +	memset(mp_req->req_buf, 0, 0x1000);
> +	memset(mp_req->resp_buf, 0, 0x1000);
> +
> +	/* Allocate and map mp_req_bd and mp_resp_bd */
> +	sz = sizeof(struct fcoe_bd_ctx);
> +	mp_req->mp_req_bd = dma_alloc_coherent(&hba->pcidev->dev, sz,
> +						&mp_req->mp_req_bd_dma,
> +						 GFP_ATOMIC);
> +	if (!mp_req->mp_req_bd) {
> +		printk(KERN_ERR PFX "unable to alloc MP req bd\n");
> +		bnx2fc_free_mp_resc(io_req);
> +		return FAILED;
> +	}
> +	mp_req->mp_resp_bd = dma_alloc_coherent(&hba->pcidev->dev, sz,
> +						&mp_req->mp_resp_bd_dma,
> +						 GFP_ATOMIC);
> +	if (!mp_req->mp_req_bd) {
> +		printk(KERN_ERR PFX "unable to alloc MP resp bd\n");
> +		bnx2fc_free_mp_resc(io_req);
> +		return FAILED;
> +	}
> +	/* Fill bd table */
> +	addr = mp_req->req_buf_dma;
> +	mp_req_bd = mp_req->mp_req_bd;
> +	mp_req_bd->buf_addr_lo = (u32)addr&  0xffffffff;
> +	mp_req_bd->buf_addr_hi = (u32)((u64)addr>>  32);
> +	mp_req_bd->buf_len = 0x1000;
> +	mp_req_bd->flags = 0;
> +
> +	/*
> +	 * MP buffer is either a task mgmt command or an ELS.
> +	 * So the assumption is that it consumes a single bd
> +	 * entry in the bd table
> +	 */
> +	mp_resp_bd = mp_req->mp_resp_bd;
> +	addr = mp_req->resp_buf_dma;
> +	mp_resp_bd->buf_addr_lo = (u32)addr&  0xffffffff;
> +	mp_resp_bd->buf_addr_hi = (u32)((u64)addr>>  32);
> +	mp_resp_bd->buf_len = 0x1000;
> +	mp_resp_bd->flags = 0;
> +
> +	return SUCCESS;
> +}
> +
> +static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
> +{
> +	struct fc_lport *lport;
> +	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
> +	struct fc_rport_libfc_priv *rp = rport->dd_data;
> +	struct bnx2fc_port *port;
> +	struct bnx2fc_hba *hba;
> +	struct bnx2fc_rport *tgt;
> +	struct bnx2fc_cmd *io_req;
> +	struct bnx2fc_mp_req *tm_req;
> +	struct fcoe_task_ctx_entry *task;
> +	struct fcoe_task_ctx_entry *task_page;
> +	struct Scsi_Host *host = sc_cmd->device->host;
> +	struct fc_frame_header *fc_hdr;
> +	struct fcp_cmnd *fcp_cmnd;
> +	int task_idx, index;
> +	int rc = SUCCESS;
> +	u16 xid;
> +	int rval;
> +	u32 sid, did;
> +	unsigned long start = jiffies;
> +
> +	bnx2fc_dbg(LOG_IOERR, "initiate_tmf - tm_flags = %d\n", tm_flags);
> +
> +	lport = shost_priv(host);
> +	port = lport_priv(lport);
> +	hba = port->hba;
> +
> +	if (rport == NULL) {
> +		printk(KERN_ALERT PFX "device_reset: rport is NULL\n");
> +		rc = FAILED;
> +		goto tmf_err;
> +	}
> +	rval = fc_remote_port_chkready(rport);
> +	if (rval) {
> +		printk(KERN_ALERT PFX "device_reset rport not ready\n");
> +		rc = FAILED;
> +		goto tmf_err;
> +	}


This has been replaced with the fc_block_scsi_eh calls now. Do not copy 
drivers when converting to it because some are broken. Be aware that its 
return value is 0 instead of something like SUCCESS.


> +	if (lport->state != LPORT_ST_READY || !(lport->link_up)) {
> +		printk(KERN_ERR PFX "device_reset: link is not ready\n");
> +		rc = FAILED;
> +		goto tmf_err;
> +	}
> +	/* rport and tgt are allocated together, so tgt should be non-NULL */
> +	tgt = (struct bnx2fc_rport *)&rp[1];
> +
> +	if (!(test_bit(BNX2FC_FLAG_SESSION_READY,&tgt->flags))) {
> +		printk(KERN_ERR PFX "device_reset: tgt not offloaded\n");
> +		rc = FAILED;
> +		goto tmf_err;
> +	}
> +retry_tmf:
> +	io_req = bnx2fc_elstm_alloc(tgt, BNX2FC_TASK_MGMT_CMD);
> +	if (!io_req) {
> +		if (time_after(jiffies, start + HZ)) {
> +			printk(KERN_ERR PFX "tmf: Failed TMF");
> +			rc = FAILED;
> +			goto tmf_err;
> +		}
> +		msleep(20);
> +		goto retry_tmf;
> +	}
> +	/* Initialize rest of io_req fields */
> +	io_req->sc_cmd = sc_cmd;
> +	io_req->port = port;
> +	io_req->tgt = tgt;
> +
> +	tm_req = (struct bnx2fc_mp_req *)&(io_req->mp_req);
> +
> +	rc = bnx2fc_init_mp_req(io_req);
> +	if (rc == FAILED) {
> +		printk(KERN_ERR PFX "Task mgmt MP request init failed\n");
> +		bnx2fc_cmd_release(io_req);
> +		goto tmf_err;
> +	}
> +
> +	/* Set TM flags */
> +	io_req->io_req_flags = 0;
> +	tm_req->tm_flags = tm_flags;
> +
> +	/* Fill FCP_CMND */
> +	bnx2fc_build_fcp_cmnd(io_req, (struct fcp_cmnd *)tm_req->req_buf);
> +	fcp_cmnd = (struct fcp_cmnd *)tm_req->req_buf;
> +	memset(fcp_cmnd->fc_cdb, 0,  sc_cmd->cmd_len);
> +	fcp_cmnd->fc_dl = 0;
> +
> +	/* Fill FC header */
> +	fc_hdr =&(tm_req->req_fc_hdr);
> +	sid = tgt->sid;
> +	did = rport->port_id;
> +	bnx2fc_fill_fc_hdr(fc_hdr, FC_RCTL_DD_UNSOL_CMD, sid, did,
> +			   FC_TYPE_FCP, FC_FC_FIRST_SEQ | FC_FC_END_SEQ |
> +			   FC_FC_SEQ_INIT, 0);
> +	/* Obtain exchange id */
> +	xid = bnx2fc_get_xid(io_req, hba);
> +
> +	bnx2fc_dbg(LOG_IOERR, "TMF io_req xid = 0x%x\n", xid);
> +	task_idx = xid/BNX2FC_TASKS_PER_PAGE;
> +	index = xid % BNX2FC_TASKS_PER_PAGE;
> +
> +	/* Initialize task context for this IO request */
> +	task_page = (struct fcoe_task_ctx_entry *) hba->task_ctx[task_idx];
> +	task =&(task_page[index]);
> +	bnx2fc_init_mp_task(io_req, task);
> +
> +	sc_cmd->SCp.ptr = (char *)io_req;
> +
> +	/* Obtain free SQ entry */
> +	spin_lock_bh(&tgt->tgt_lock);
> +	bnx2fc_add_2_sq(tgt, xid);
> +
> +	/* Enqueue the io_req to active_tm_queue */
> +	io_req->on_tmf_queue = 1;
> +	list_add_tail(&io_req->link,&tgt->active_tm_queue);
> +
> +	/* Ring doorbell */
> +	bnx2fc_ring_doorbell(tgt);
> +	spin_unlock_bh(&tgt->tgt_lock);
> +
> +	init_completion(&io_req->tm_done);
> +	io_req->wait_for_comp = 1;


I think you want to set that and init the completion before you send the 
IO right?


> +
> +	rc = wait_for_completion_timeout(&io_req->tm_done,
> +					 BNX2FC_TM_TIMEOUT * HZ);
> +	io_req->wait_for_comp = 0;
> +
> +	if (!(test_bit(BNX2FC_FLAG_TM_COMPL,&io_req->req_flags)))
> +		set_bit(BNX2FC_FLAG_TM_TIMEOUT,&io_req->req_flags);
> +	else
> +		/* TM should have just completed */
> +		return SUCCESS;


I think you need to move where you set the BNX2FC_FLAG_TM_COMPL bit. 
bnx2fc_process_tm_compl set complete it in one context, we could wake up 
early due to timeout and see it here and return SUCCESS, scsi-ml's 
scsi_error.c code would think it owns the scsi_cmnd and start setting it 
up for a TUR, but then bnx2fc_process_tm_compl/bnx2fc_lun_reset_cmpl 
could be accessing the scsi_cmnd cleaning it up at the same time.



> +
> +static int bnx2fc_abort_handler(struct bnx2fc_cmd *io_req)
> +{
> +	struct bnx2fc_rport *tgt = io_req->tgt;
> +	int rc;
> +
> +	init_completion(&io_req->tm_done);
> +	io_req->wait_for_comp = 1;

This seems racy too. I think you need to set that up before you send the 
abort, or the abort could complete and not see the wait_for_comp is set, 
and then we could set it here.


> +	wait_for_completion(&io_req->tm_done);
> +
> +	spin_lock_bh(&tgt->tgt_lock);
> +	io_req->wait_for_comp = 0;
> +	if (!(test_and_set_bit(BNX2FC_FLAG_ABTS_DONE,
> +				&io_req->req_flags))) {
> +		/* Let the scsi-ml try to recover this command */
> +		printk(KERN_ERR PFX "abort failed, xid = 0x%x\n",
> +		       io_req->xid);
> +		rc = FAILED;
> +	} else {
> +		/*
> +		 * We come here even when there was a race condition
> +		 * between timeout and abts completion, and abts
> +		 * completion happens just in time.
> +		 */
> +		bnx2fc_dbg(LOG_IOERR, "abort succeeded, xid = 0x%x\n",
> +			   io_req->xid);
> +		rc = SUCCESS;
> +		bnx2fc_scsi_done(io_req, DID_ABORT);
> +		bnx2fc_cmd_release(io_req);
> +	}
> +
> +	/* release the reference taken in eh_abort */
> +	bnx2fc_cmd_release(io_req);
> +	spin_unlock_bh(&tgt->tgt_lock);
> +	return rc;
> +}
> +
> +/**
> + * bnx2fc_eh_device_reset: Reset a single LUN
> + * @sc_cmd:	SCSI command
> + *
> + * Set from SCSI host template to send task mgmt command to the target
> + *	and wait for the response
> + */
> +int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd)
> +{
> +	int rc;
> +
> +	bnx2fc_dbg(LOG_IOERR, "Entered bnx2fc_eh_target_reset\n");

Here you definately want better logging. Something like scmd_printk at 
least.


> +	rc = bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_TGT_RESET);
> +	return rc;

you can just do
return bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_TGT_RESET);
and delete rc;

> +}
> +
> +/**
> + * bnx2fc_eh_device_reset: Reset a single LUN
> + * @sc_cmd:	SCSI command
> + *
> + * Set from SCSI host template to send task mgmt command to the target
> + *	and wait for the response
> + */
> +int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
> +{
> +	int rc;
> +
> +	bnx2fc_dbg(LOG_IOERR, "Entered bnx2fc_eh_device_reset\n");
> +	/* bnx2fc_initiate_tmf is a blocking call */
> +	rc = bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
> +
> +	return rc;

same as a bove.


> +}
> +
> +/**
> + * bnx2fc_eh_abort - eh_abort_handler api to abort an outstanding
> + *			SCSI command
> + * @sc_cmd:	SCSI_ML command pointer
> + *
> + * SCSI abort request handler
> + */
> +int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
> +{
> +
> +	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
> +	struct fc_rport_libfc_priv *rp = rport->dd_data;
> +	struct bnx2fc_cmd *io_req;
> +	struct fc_lport *lport;
> +	struct bnx2fc_rport *tgt;
> +	int rc = FAILED;
> +
> +	bnx2fc_dbg(LOG_IOERR, "Entered bnx2fc_eh_abort\n");
> +
> +	if (fc_remote_port_chkready(rport)) {
> +		printk(KERN_ALERT PFX "bnx2fc_eh_abort: rport not ready\n");
> +		return rc;
> +	}


Should be fc_block_scsi_eh.


> +
> +	lport = shost_priv(sc_cmd->device->host);
> +	if ((lport->state != LPORT_ST_READY) || !(lport->link_up)) {
> +		printk(KERN_ALERT PFX "eh_abort: link not ready\n");
> +		return rc;
> +	}
> +
> +	tgt = (struct bnx2fc_rport *)&rp[1];
> +	spin_lock_bh(&tgt->tgt_lock);
> +	io_req = (struct bnx2fc_cmd *)sc_cmd->SCp.ptr;
> +	if (!io_req) {
> +		/* Command might have just completed */
> +		printk(KERN_ERR PFX "eh_abort: io_req is NULL\n");
> +		spin_unlock_bh(&tgt->tgt_lock);
> +		return SUCCESS;
> +	}
> +	printk(KERN_ERR PFX "eh_abort: xid = 0x%x refcnt = %d\n",
> +		 io_req->xid, io_req->cmd_refcnt.counter);
> +
> +	/* Hold IO request across abort processing */
> +	bnx2fc_cmd_hold(io_req);
> +
> +	BUG_ON(tgt != io_req->tgt);
> +
> +	/* Remove the io_req from the active_q. */
> +	/*
> +	 * Task Mgmt functions (LUN RESET&  TGT RESET) will not
> +	 * issue an ABTS on this particular IO req, as the
> +	 * io_req is no longer in the active_q.
> +	 */
> +	if (tgt->flush_in_prog) {
> +		printk(KERN_ALERT PFX "eh_abort: io_req (xid = 0x%x) "
> +			"flush in progress\n", io_req->xid);
> +		bnx2fc_cmd_release(io_req);
> +		spin_unlock_bh(&tgt->tgt_lock);
> +		return SUCCESS;
> +	}
> +
> +	if (io_req->on_active_queue == 0) {
> +		printk(KERN_ALERT PFX "eh_abort: io_req (xid = 0x%x) "
> +				"not on active_q\n", io_req->xid);
> +		/*
> +		 * This condition can happen only due to the FW bug,
> +		 * where we do not receive cleanup response from
> +		 * the FW. Handle this case gracefully by erroring
> +		 * back the IO request to SCSI-ml
> +		 */
> +		bnx2fc_scsi_done(io_req, DID_ABORT);
> +
> +		bnx2fc_cmd_release(io_req);
> +		spin_unlock_bh(&tgt->tgt_lock);
> +		return SUCCESS;
> +	}
> +
> +	/*
> +	 * Only eh_abort processing will remove the IO from
> +	 * active_cmd_q before processing the request. this is
> +	 * done to avoid race conditions between IOs aborted
> +	 * as part of task management completion and eh_abort
> +	 * processing
> +	 */
> +	list_del_init(&io_req->link);
> +	io_req->on_active_queue = 0;
> +	/* Move IO req to retire queue */
> +	list_add_tail(&io_req->link,&tgt->io_retire_queue);
> +
> +	if (!test_and_set_bit(BNX2FC_FLAG_ISSUE_ABTS,&io_req->req_flags)) {
> +		/* Cancel the current timer running on this io_req */
> +		if (cancel_delayed_work(&io_req->timeout_work))
> +			bnx2fc_cmd_release(io_req); /* drop timer hold */
> +		set_bit(BNX2FC_FLAG_EH_ABORT,&io_req->req_flags);
> +		rc = bnx2fc_initiate_abts(io_req);
> +	} else {
> +		printk(KERN_ALERT PFX "eh_abort: io_req (xid = 0x%x) "
> +				"already in abts processing\n", io_req->xid);
> +		bnx2fc_cmd_release(io_req);
> +		spin_unlock_bh(&tgt->tgt_lock);
> +		return SUCCESS;
> +	}
> +	if (rc == FAILED) {
> +		bnx2fc_cmd_release(io_req);
> +		spin_unlock_bh(&tgt->tgt_lock);
> +		return rc;
> +	}
> +	spin_unlock_bh(&tgt->tgt_lock);
> +
> +	rc = bnx2fc_abort_handler(io_req);
> +	return rc;


Just do

return bnx2fc_abort_handler(io_req);

> +}
> +
> +void bnx2fc_process_cleanup_compl(struct bnx2fc_cmd *io_req,
> +				  struct fcoe_task_ctx_entry *task,
> +				  u8 num_rq)
> +{
> +	bnx2fc_dbg(LOG_IOERR, "Entered process_cleanup_compl xid = 0x%x"
> +			      "refcnt = %d, cmd_type = %d\n",
> +		   io_req->xid, io_req->cmd_refcnt.counter, io_req->cmd_type);
> +	bnx2fc_scsi_done(io_req, DID_REQUEUE);


I don't think you can use DID_REQUEUE here can you? In this path IO 
could have started, right? If so then DID_REQUEUE could end up retrying 
a partially run tape command.


> +	bnx2fc_cmd_release(io_req);
> +	return;


no return needed. There are others in the file.


> +
> +static void bnx2fc_lun_reset_cmpl(struct bnx2fc_cmd *io_req)
> +{
> +	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
> +	struct bnx2fc_rport *tgt = io_req->tgt;
> +	struct list_head *list;
> +	struct list_head *tmp;
> +	struct bnx2fc_cmd *cmd;
> +	int tm_lun = sc_cmd->device->lun;
> +	int rc = 0;
> +	int lun;
> +
> +	/* called with tgt_lock held */
> +	bnx2fc_dbg(LOG_IOERR, "Entered bnx2fc_lun_reset_cmpl\n");
> +	/*
> +	 * Walk thru the active_ios queue and ABORT the IO
> +	 * that matches with the LUN that was reset
> +	 */
> +	list_for_each_safe(list, tmp,&tgt->active_cmd_queue) {
> +		bnx2fc_dbg(LOG_IOERR, "LUN RST cmpl: scan for pending IOs\n");
> +		cmd = (struct bnx2fc_cmd *)list;
> +		lun = cmd->sc_cmd->device->lun;
> +		if (lun == tm_lun) {
> +			/* Initiate ABTS on this cmd */
> +			if (!test_and_set_bit(BNX2FC_FLAG_ISSUE_ABTS,
> +					&cmd->req_flags)) {
> +				/* cancel the IO timeout */
> +				if (cancel_delayed_work(&io_req->timeout_work))
> +					bnx2fc_cmd_release(io_req);
> +							/* timer hold */
> +				rc = bnx2fc_initiate_abts(cmd);
> +				/* abts shouldnt fail in this context */
> +				WARN_ON(rc != SUCCESS);
> +			} else
> +				printk(KERN_ERR PFX "lun_rst: abts already in"
> +					" progress for this IO 0x%x\n",
> +					cmd->xid);
> +		}
> +	}
> +}
> +
> +static void bnx2fc_tgt_reset_cmpl(struct bnx2fc_cmd *io_req)
> +{
> +	struct bnx2fc_rport *tgt = io_req->tgt;
> +	struct list_head *list;
> +	struct list_head *tmp;
> +	struct bnx2fc_cmd *cmd;
> +	int rc = 0;
> +
> +	/* called with tgt_lock held */
> +	bnx2fc_dbg(LOG_IOERR, "Entered bnx2fc_tgt_reset_cmpl\n");
> +	/*
> +	 * Walk thru the active_ios queue and ABORT the IO
> +	 * that matches with the LUN that was reset
> +	 */
> +	list_for_each_safe(list, tmp,&tgt->active_cmd_queue) {
> +		bnx2fc_dbg(LOG_IOERR, "TGT RST cmpl: scan for pending IOs\n");
> +		cmd = (struct bnx2fc_cmd *)list;
> +		/* Initiate ABTS */
> +		if (!test_and_set_bit(BNX2FC_FLAG_ISSUE_ABTS,
> +							&cmd->req_flags)) {
> +			/* cancel the IO timeout */
> +			if (cancel_delayed_work(&io_req->timeout_work))
> +				bnx2fc_cmd_release(io_req); /* timer hold */
> +			rc = bnx2fc_initiate_abts(cmd);
> +			/* abts shouldnt fail in this context */
> +			WARN_ON(rc != SUCCESS);
> +
> +		} else
> +			printk(KERN_ERR PFX "tgt_rst: abts already in progress"
> +				" for this IO 0x%x\n", cmd->xid);
> +	}
> +}


Are you sending a abort when a lun or target reset has been successfully 
completed? Does your hw need the reset? SCSI spec wise the lun or target 
reset will take care of the scsi commands on its side, so there is no 
need to send an abort.

Does the fcoe card have the similar cleanup command as bnx2i and do you 
just need to run that?




> +}
> +
> +static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
> +{
> +	struct bnx2fc_hba *hba = io_req->port->hba;
> +	struct scsi_cmnd *sc = io_req->sc_cmd;
> +	struct fcoe_bd_ctx *bd = io_req->bd_tbl->bd_tbl;
> +	struct scatterlist *sg;
> +	int byte_count = 0;
> +	int sg_count = 0;
> +	int bd_count = 0;
> +	int sg_frags;
> +	unsigned int sg_len;
> +	u64 addr;
> +	int i;
> +
> +	sg = scsi_sglist(sc);
> +	sg_count = pci_map_sg(hba->pcidev, sg, scsi_sg_count(sc),
> +			      sc->sc_data_direction);


I think you could also use scsi_dma_map instead.

And if not I think we are supposed to be using the dma functions instead 
of the pci ones.



> +	for (i = 0; i<  sg_count; i++) {

You need to use the sg list accessors for_each_sg() for example.


> +
> +		sg_len = sg_dma_len(sg);
> +		addr = sg_dma_address(sg);
> +		if (sg_len>  BNX2FC_MAX_BD_LEN) {
> +			sg_frags = bnx2fc_split_bd(io_req, addr, sg_len,
> +						   bd_count);
> +		} else {
> +
> +			sg_frags = 1;
> +			bd[bd_count].buf_addr_lo = addr&  0xffffffff;
> +			bd[bd_count].buf_addr_hi  = addr>>  32;
> +			bd[bd_count].buf_len = (u16)sg_len;
> +			bd[bd_count].flags = 0;
> +		}
> +		bd_count += sg_frags;
> +		byte_count += sg_len;
> +		sg++;
> +	}
> +	if (byte_count != scsi_bufflen(sc))
> +		printk(KERN_ERR PFX "byte_count = %d != scsi_bufflen = %d, "
> +			"task_id = 0x%x\n", byte_count, scsi_bufflen(sc),
> +			io_req->xid);
> +	return bd_count;
> +}
> +


> +
> +static void bnx2fc_unmap_sg_list(struct bnx2fc_cmd *io_req)
> +{
> +	struct bnx2fc_hba *hba = io_req->port->hba;
> +	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
> +	struct scatterlist *sg;
> +
> +	if (io_req->bd_tbl->bd_valid&&  sc_cmd) {
> +		if (scsi_sg_count(sc_cmd)) {
> +			sg = scsi_sglist(sc_cmd);
> +			pci_unmap_sg(hba->pcidev, sg, scsi_sg_count(sc_cmd),
> +				     sc_cmd->sc_data_direction);


scsi_dma_unmap.



> +static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
> +				 struct fcoe_fcp_rsp_payload *fcp_rsp,
> +				 u8 num_rq)
> +{
> +	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
> +	struct bnx2fc_rport *tgt = io_req->tgt;
> +	u8 rsp_flags = fcp_rsp->fcp_flags.flags;
> +	u32 rq_buff_len = 0;
> +	int i;
> +	unsigned char *rq_data;
> +	unsigned char *dummy;
> +	int fcp_sns_len = 0;
> +	int fcp_rsp_len = 0;
> +
> +	io_req->fcp_status = FC_GOOD;
> +	io_req->fcp_resid = fcp_rsp->fcp_resid;
> +
> +	io_req->scsi_comp_flags = rsp_flags;
> +	if (sc_cmd == NULL)
> +		printk(KERN_ERR PFX "ERROR!! sc_cmd NULL\n");


Does this ever happen? If so then handle it properly because you 
probably will not even see the printk and instead see a oops trample 
over it or a hung box when you access the cmd below. If it does not 
every happen then remove the goofy printk.



> +
> +/**
> + * bnx2fc_queuecommand - Queuecommand function of the scsi template
> + * @sc_cmd:	struct scsi_cmnd to be executed
> + * @done:	Callback function to be called when sc_cmd is complted
> + *
> + * This is the IO strategy routine, called by SCSI-ML
> + **/
> +int bnx2fc_queuecommand(struct scsi_cmnd *sc_cmd,
> +				void (*done)(struct scsi_cmnd *))
> +{
> +	struct fc_lport *lport;
> +	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
> +	struct fc_rport_libfc_priv *rp = rport->dd_data;
> +	struct bnx2fc_port *port;
> +	struct bnx2fc_hba *hba;
> +	struct bnx2fc_rport *tgt;
> +	struct Scsi_Host *host = sc_cmd->device->host;
> +	struct bnx2fc_cmd *io_req;
> +	int rc = 0;
> +	int rval;
> +	struct cnic_dev *dev;
> +
> +	lport = shost_priv(host);
> +	spin_unlock_irq(host->host_lock);

Don't forget to update to the new locking when you resend.


> +	sc_cmd->scsi_done = done;
> +	port = lport_priv(lport);
> +	hba = port->hba;
> +	dev = hba->cnic;
> +
> +	rval = fc_remote_port_chkready(rport);
> +	if (rval) {
> +		sc_cmd->result = rval;
> +		done(sc_cmd);
> +		goto exit_qcmd;
> +	}
> +
> +	if ((lport->state != LPORT_ST_READY) || !(lport->link_up)) {
> +		rc = SCSI_MLQUEUE_HOST_BUSY;
> +		goto exit_qcmd;
> +	}
> +
> +	/* rport and tgt are allocated together, so tgt should be non-NULL */
> +	tgt = (struct bnx2fc_rport *)&rp[1];
> +
> +	if (!test_bit(BNX2FC_FLAG_SESSION_READY,&tgt->flags)) {
> +		/*
> +		 * Session is not offloaded yet. Let SCSI-ml retry
> +		 * the command.
> +		 */
> +		rc = SCSI_MLQUEUE_HOST_BUSY;

You should use SCSI_MLQUEUE_TARGET_BUSY, so only the one target is 
blocked and not the whole host.



> +
> +static int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
> +			       struct bnx2fc_cmd *io_req)
> +{


> +
> +	/* Time IO req */
> +	bnx2fc_cmd_timer_set(io_req, BNX2FC_IO_TIMEOUT);

Hard coding this does not seem right becuase the scsi cmnd timer can be 
set through sysfs. It could be set lower than this which makes it 
useless. I think libfc is dropping their similar timer like this and 
just relying on the scsi_cmnd timer now (I think they just do the rec 
but not the abort now).




> +	/* Obtain free SQ entry */
> +	bnx2fc_add_2_sq(tgt, xid);
> +
> +	/* Enqueue the io_req to active_cmd_queue */
> +
> +	io_req->on_active_queue = 1;
> +	/* move io_req from pending_queue to active_queue */
> +	list_add_tail(&io_req->link,&tgt->active_cmd_queue);
> +
> +	/* Ring doorbell */
> +	bnx2fc_ring_doorbell(tgt);
> +	spin_unlock_bh(&tgt->tgt_lock);
> +	return 0;
> +}
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> new file mode 100644
> index 0000000..6739dce
> --- /dev/null
> +++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> @@ -0,0 +1,875 @@


I have to do some other stuff now. Will continue from here Monday or Sunday.
