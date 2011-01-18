From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v2 PATCH 4/5] bnx2fc: Broadcom FCoE Offload driver submission
 - part 2
Date: Mon, 17 Jan 2011 20:44:42 -0600
Message-ID: <4D34FE9A.2030002@cs.wisc.edu>
References: <1293170555.4676.574.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52330 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab1ARCon (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jan 2011 21:44:43 -0500
In-Reply-To: <1293170555.4676.574.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org, mchan@broadcom.com

On 12/24/2010 12:02 AM, Bhanu Gollapudi wrote:
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c

> +
> +static void bnx2fc_offload_session(struct bnx2fc_port *port,
> +					struct bnx2fc_rport *tgt,
> +					struct fc_rport_priv *rdata)
> +{
> +	struct fc_lport *lport = rdata->local_port;
> +	struct fc_rport *rport = rdata->rport;
> +	struct bnx2fc_hba *hba = port->hba;
> +	int rval;
> +	int i = 0;
> +
> +	/* Initialize bnx2fc_rport */
> +	/* NOTE: tgt is already bzero'd */
> +	rval = bnx2fc_init_tgt(tgt, port, rdata);
> +	if (rval) {
> +		printk(KERN_ERR PFX "Failed to allocate conn id for "
> +			"port_id (%6x)\n", rport->port_id);
> +		goto ofld_err;
> +	}
> +
> +	if (hba->num_ofld_sess>= BNX2FC_NUM_MAX_SESS) {
> +		printk(KERN_ERR PFX "exceeded max sessions port_id (%6x)\n",
> +		       rport->port_id);
> +		goto ofld_err;
> +	}
> +
> +	/* Allocate session resources */
> +	rval = bnx2fc_alloc_session_resc(hba, tgt);
> +	if (rval) {
> +		printk(KERN_ERR PFX "Failed to allocate resources\n");
> +		goto ofld_err;
> +	}
> +
> +	/*
> +	 * Initialize FCoE session offload process.
> +	 * Upon completion of offload process add
> +	 * rport to list of rports
> +	 */
> +retry_ofld:
> +	clear_bit(BNX2FC_FLAG_OFLD_REQ_CMPL,&tgt->flags);
> +	rval = bnx2fc_send_session_ofld_req(port, tgt);
> +	if (rval) {
> +		printk(KERN_ERR PFX "ofld_req failed\n");
> +		goto ofld_err;
> +	}
> +
> +	/*
> +	 * wait for the session is offloaded and enabled. 20 Secs
> +	 * should be ample time for this process to complete.
> +	 */
> +	init_timer(&tgt->ofld_timer);
> +	tgt->ofld_timer.expires = (20 * HZ) + jiffies;
> +	tgt->ofld_timer.function = bnx2fc_ofld_timer;
> +	tgt->ofld_timer.data = (unsigned long)tgt;


setup_timer()

> +
> +	add_timer(&tgt->ofld_timer);
> +
> +	wait_event_interruptible(tgt->ofld_wait,
> +				 (test_bit(
> +				  BNX2FC_FLAG_OFLD_REQ_CMPL,
> +				&tgt->flags)));



This gets run from libfc's work queue, right? It does not seem nice to 
sleep here for so long and block other drivers.

For multipath setups having to wait this longs would be very bad.


> +
> +void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
> +{
> +	struct bnx2fc_cmd *io_req;
> +	struct list_head *list;
> +	struct list_head *tmp;
> +	int rc;
> +	int i = 0;
> +	bnx2fc_dbg(LOG_IOERR, "Entered flush_active_ios - %d, port_id = 0x%x\n",
> +		tgt->num_active_ios, tgt->rdata->ids.port_id);
> +
> +	spin_lock_bh(&tgt->tgt_lock);
> +	tgt->flush_in_prog = 1;
> +
> +	list_for_each_safe(list, tmp,&tgt->active_cmd_queue) {
> +		i++;
> +		io_req = (struct bnx2fc_cmd *)list;
> +		list_del_init(&io_req->link);
> +		io_req->on_active_queue = 0;
> +		bnx2fc_dbg(LOG_IOERR, "cmd_queue cleanup - xid = 0x%x ref_cnt ="
> +			   " %d\n", io_req->xid, io_req->cmd_refcnt.counter);
> +
> +		if (cancel_delayed_work(&io_req->timeout_work)) {
> +			if (test_and_clear_bit(BNX2FC_FLAG_EH_ABORT,
> +						&io_req->req_flags)) {
> +				/* Handle eh_abort timeout */
> +				bnx2fc_dbg(LOG_IOERR, "eh_abort for IO "
> +						"with oxid = 0x%x "
> +					"cleaned up\n", io_req->xid);
> +				complete(&io_req->tm_done);
> +			}
> +			bnx2fc_cmd_release(io_req); /* drop timer hold */
> +		}
> +
> +		set_bit(BNX2FC_FLAG_IO_COMPL,&io_req->req_flags);
> +		set_bit(BNX2FC_FLAG_IO_CLEANUP,&io_req->req_flags);
> +		rc = bnx2fc_initiate_cleanup(io_req);
> +		BUG_ON(rc);
> +	}
> +
> +	list_for_each_safe(list, tmp,&tgt->els_queue) {
> +		i++;
> +		io_req = (struct bnx2fc_cmd *)list;
> +		list_del_init(&io_req->link);
> +		io_req->on_active_queue = 0;
> +
> +		bnx2fc_dbg(LOG_IOERR, "els_queue cleanup - xid = 0x%x"
> +			   " ref_cnt = %d\n", io_req->xid,
> +			   io_req->cmd_refcnt.counter);
> +
> +		if (cancel_delayed_work(&io_req->timeout_work))
> +			bnx2fc_cmd_release(io_req); /* drop timer hold */
> +
> +		if ((io_req->cb_func)&&  (io_req->cb_arg)) {
> +			io_req->cb_func(io_req->cb_arg);
> +			io_req->cb_arg = NULL;
> +		}
> +
> +		rc = bnx2fc_initiate_cleanup(io_req);
> +		BUG_ON(rc);
> +	}
> +
> +	list_for_each_safe(list, tmp,&tgt->io_retire_queue) {
> +		i++;
> +		io_req = (struct bnx2fc_cmd *)list;
> +		list_del_init(&io_req->link);
> +
> +		bnx2fc_dbg(LOG_IOERR, "retire_queue flush - xid = 0x%x"
> +			" ref_cnt = %d\n", io_req->xid,
> +			 io_req->cmd_refcnt.counter);
> +
> +		if (cancel_delayed_work(&io_req->timeout_work))
> +			bnx2fc_cmd_release(io_req);
> +
> +		clear_bit(BNX2FC_FLAG_ISSUE_RRQ,&io_req->req_flags);
> +	}
> +
> +	bnx2fc_dbg(LOG_IOERR, "IOs flushed = %d\n", i);
> +	i = 0;
> +	spin_unlock_bh(&tgt->tgt_lock);
> +	/* wait for active_ios to go to 0 */
> +	while ((tgt->num_active_ios != 0)&&  (i++<  120))
> +		msleep(25);


Are you waiting for bnx2fc_cmd_timeout to stop running (for the case 
where the cancel did not indicate it was pending) or to get a response 
to when you did bnx2fc_initiate_cleanup?

For bnx2fc_cmd_timeout you should just flush the workqueue_struct.

For bnx2fc_initiate_cleanup, where did the 120 * 25msecs limit come from?



> +	if (tgt->num_active_ios != 0)
> +		printk(KERN_ERR PFX "CLEANUP on port 0x%x:"
> +				    " active_ios = %d\n",
> +			tgt->rdata->ids.port_id, tgt->num_active_ios);
> +	spin_lock_bh(&tgt->tgt_lock);
> +	tgt->flush_in_prog = 0;
> +	spin_unlock_bh(&tgt->tgt_lock);
> +}
> +
> +static void bnx2fc_upload_session(struct bnx2fc_port *port,
> +					struct bnx2fc_rport *tgt)
> +{
> +	struct bnx2fc_hba *hba = port->hba;
> +
> +	bnx2fc_dbg(LOG_SESS, "upload_session: active_ios = %d\n",
> +		tgt->num_active_ios);
> +
> +	/*
> +	 * Called with hba->hba_mutex held.
> +	 * This is a blocking call
> +	 */
> +	clear_bit(BNX2FC_FLAG_UPLD_REQ_COMPL,&tgt->flags);
> +	bnx2fc_send_session_disable_req(port, tgt);
> +
> +	/*
> +	 * wait for upload to complete. 20 Secs
> +	 * should be sufficient time for this process to complete.
> +	 */
> +	init_timer(&tgt->upld_timer);
> +	tgt->upld_timer.expires = (20 * HZ) + jiffies;
> +	tgt->upld_timer.function = bnx2fc_upld_timer;
> +	tgt->upld_timer.data = (unsigned long)tgt;
> +


setup_timer() Check for other places in the code for this.


> +	add_timer(&tgt->upld_timer);
> +
> +	bnx2fc_dbg(LOG_SESS, "waiting for disable compl\n");
> +	wait_event_interruptible(tgt->upld_wait,
> +				 (test_bit(
> +				  BNX2FC_FLAG_UPLD_REQ_COMPL,
> +				&tgt->flags)));
> +
> +	if (signal_pending(current))
> +		flush_signals(current);
> +
> +	del_timer_sync(&tgt->upld_timer);
> +
> +	bnx2fc_dbg(LOG_SESS, "disable wait complete flags = 0x%lx\n",
> +		tgt->flags);
> +
> +	/*
> +	 * traverse thru the active_q and tmf_q and cleanup
> +	 * IOs in these lists
> +	 */
> +	bnx2fc_dbg(LOG_SESS, "flush/upload\n");
> +	bnx2fc_flush_active_ios(tgt);
> +
> +	/* Issue destroy KWQE */
> +	if (test_bit(BNX2FC_FLAG_DISABLED,&tgt->flags)) {
> +		bnx2fc_dbg(LOG_SESS, "send destroy req\n");
> +		clear_bit(BNX2FC_FLAG_UPLD_REQ_COMPL,&tgt->flags);
> +		bnx2fc_send_session_destroy_req(hba, tgt);
> +
> +		/* wait for destroy to complete */
> +		init_timer(&tgt->upld_timer);
> +		tgt->upld_timer.expires = (20 * HZ) + jiffies;
> +		tgt->upld_timer.function = bnx2fc_upld_timer;
> +		tgt->upld_timer.data = (unsigned long)tgt;
> +
> +		add_timer(&tgt->upld_timer);
> +
> +		wait_event_interruptible(tgt->upld_wait,
> +					 (test_bit(
> +					  BNX2FC_FLAG_UPLD_REQ_COMPL,
> +					&tgt->flags)));
> +
> +		if (!(test_bit(BNX2FC_FLAG_DESTROYED,&tgt->flags)))
> +			printk(KERN_ERR PFX "ERROR!! destroy timed out\n");
> +
> +		bnx2fc_dbg(LOG_SESS, "destroy wait complete flags = 0x%lx\n",
> +			tgt->flags);
> +		if (signal_pending(current))
> +			flush_signals(current);
> +
> +		del_timer_sync(&tgt->upld_timer);
> +
> +	} else {
> +		printk(KERN_ERR PFX "ERROR!! DISABLE req timed out, destroy"
> +				" not sent to FW\n");
> +	}


No need for extra brackets.

> +
> +
> +	/* Free session resources */
> +	spin_lock_bh(&tgt->cq_lock);
> +	bnx2fc_free_session_resc(hba, tgt);
> +	bnx2fc_free_conn_id(hba, tgt->fcoe_conn_id);
> +	spin_unlock_bh(&tgt->cq_lock);
> +	return;

extra return


> +/**
> + * bnx2fc_tgt_lookup() - Lookup a bnx2fc_rport by port_id
> + * @port:  bnx2fc_port struct to lookup the target port on
> + * @port_id: The remote port ID to look up
> + */
> +struct bnx2fc_rport *bnx2fc_tgt_lookup(struct bnx2fc_port *port,
> +					     u32 port_id)
> +{
> +	struct bnx2fc_hba *hba = port->hba;
> +	struct bnx2fc_rport *tgt;
> +	struct fc_rport_priv *rdata;
> +	int i;
> +
> +	for (i = 0; i<  BNX2FC_NUM_MAX_SESS; i++) {
> +		tgt = hba->tgt_ofld_list[i];
> +		if ((tgt)&&  (tgt->port == port)) {
> +			rdata = tgt->rdata;
> +			if (rdata->ids.port_id == port_id) {
> +				if (rdata->rp_state != RPORT_ST_DELETE) {
> +					bnx2fc_dbg(LOG_IOERR, "rport 0x%x "
> +						"obtained\n",
> +						rdata->ids.port_id);
> +					return tgt;
> +				} else {
> +					printk(KERN_ERR PFX "rport 0x%x "
> +						"is in DELETED state\n",
> +						rdata->ids.port_id);
> +					return NULL;
> +				}
> +			}
> +		}
> +	}
> +	return NULL;
> +}


It seems this should go in scsi_transport_fc. I thought there was a 
similar lookup function in libfc too, and we were trying to move that to 
the transport class.




> +
> +
> +/**
> + * bnx2fc_alloc_conn_id - allocates FCOE Connection id
> + *
> + * @hba:	pointer to adapter structure
> + * @tgt:	pointer to bnx2fc_rport structure
> + */
> +static u32 bnx2fc_alloc_conn_id(struct bnx2fc_hba *hba,
> +				struct bnx2fc_rport *tgt)
> +{
> +	u32 conn_id, next;
> +
> +	/* called with hba mutex held */
> +
> +	/*
> +	 * tgt_ofld_list access is synchronized using
> +	 * both hba mutex and hba lock. Atleast hba mutex or
> +	 * hba lock needs to be held for read access.
> +	 */
> +
> +	spin_lock_bh(&hba->hba_lock);
> +	next = hba->next_conn_id;
> +	conn_id = hba->next_conn_id++;
> +	if (hba->next_conn_id == BNX2FC_NUM_MAX_SESS)
> +		hba->next_conn_id = 0;
> +
> +	while (hba->tgt_ofld_list[conn_id] != NULL) {
> +		conn_id++;
> +		if (conn_id == BNX2FC_NUM_MAX_SESS)
> +			conn_id = 0;
> +
> +		if (conn_id == next) {
> +			/* No free conn_ids are available */
> +			conn_id = -1;
> +			return conn_id;

Just do return -1;




> +static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
> +					struct bnx2fc_rport *tgt)
> +{
> +	dma_addr_t page;
> +	int num_pages;
> +	u32 *pbl;
> +
> +	/* Allocate and map SQ */
> +	tgt->sq_mem_size = tgt->max_sqes * BNX2FC_SQ_WQE_SIZE;
> +	tgt->sq_mem_size = (tgt->sq_mem_size + (PAGE_SIZE - 1))&  PAGE_MASK;
> +
> +	tgt->sq = dma_alloc_coherent(&hba->pcidev->dev, tgt->sq_mem_size,
> +				&tgt->sq_dma, GFP_KERNEL);
> +	if (!tgt->sq) {
> +		printk(KERN_ALERT PFX "unable to allocate SQ memory %d\n",
> +			tgt->sq_mem_size);
> +		goto mem_alloc_failure;
> +	}
> +	memset(tgt->sq, 0, tgt->sq_mem_size);
> +
> +	/* Allocate and map CQ */
> +	tgt->cq_mem_size = tgt->max_cqes * BNX2FC_CQ_WQE_SIZE;
> +	tgt->cq_mem_size = (tgt->cq_mem_size + (PAGE_SIZE - 1))&  PAGE_MASK;
> +
> +	tgt->cq = dma_alloc_coherent(&hba->pcidev->dev, tgt->cq_mem_size,
> +				&tgt->cq_dma, GFP_KERNEL);
> +	if (!tgt->cq) {
> +		printk(KERN_ALERT PFX "unable to allocate CQ memory %d\n",
> +			tgt->cq_mem_size);
> +		goto mem_alloc_failure;
> +	}
> +	memset(tgt->cq, 0, tgt->cq_mem_size);
> +
> +	/* Allocate and map RQ and RQ PBL */
> +	tgt->rq_mem_size = tgt->max_rqes * BNX2FC_RQ_WQE_SIZE;
> +	tgt->rq_mem_size = (tgt->rq_mem_size + (PAGE_SIZE - 1))&  PAGE_MASK;
> +
> +	tgt->rq = dma_alloc_coherent(&hba->pcidev->dev, tgt->rq_mem_size,
> +					&tgt->rq_dma, GFP_KERNEL);
> +	if (!tgt->rq) {
> +		printk(KERN_ALERT PFX "unable to allocate RQ memory %d\n",
> +			tgt->rq_mem_size);
> +		goto mem_alloc_failure;
> +	}
> +	memset(tgt->rq, 0, tgt->rq_mem_size);
> +
> +	tgt->rq_pbl_size = (tgt->rq_mem_size / PAGE_SIZE) * sizeof(void *);
> +	tgt->rq_pbl_size = (tgt->rq_pbl_size + (PAGE_SIZE - 1))&  PAGE_MASK;
> +
> +	tgt->rq_pbl = dma_alloc_coherent(&hba->pcidev->dev, tgt->rq_pbl_size,
> +					&tgt->rq_pbl_dma, GFP_KERNEL);
> +	if (!tgt->rq_pbl) {
> +		printk(KERN_ALERT PFX "unable to allocate RQ PBL %d\n",
> +			tgt->rq_pbl_size);
> +		goto mem_alloc_failure;
> +	}
> +
> +	memset(tgt->rq_pbl, 0, tgt->rq_pbl_size);
> +	num_pages = tgt->rq_mem_size / PAGE_SIZE;
> +	page = tgt->rq_dma;
> +	pbl = (u32 *)tgt->rq_pbl;
> +


What is the code below supposed to be doing?


> +	while (num_pages--) {
> +		*pbl = (u32)page;
> +		pbl++;
> +		*pbl = (u32)((u64)page>>  32);
> +		pbl++;
> +		page += PAGE_SIZE;
> +	}
> +
> +	/* Allocate and map XFERQ */
> +	tgt->xferq_mem_size = tgt->max_sqes * BNX2FC_XFERQ_WQE_SIZE;
> +	tgt->xferq_mem_size = (tgt->xferq_mem_size + (PAGE_SIZE - 1))&
> +			       PAGE_MASK;
> +
> +	tgt->xferq = dma_alloc_coherent(&hba->pcidev->dev, tgt->xferq_mem_size,
> +					&tgt->xferq_dma, GFP_KERNEL);
> +	if (!tgt->xferq) {
> +		printk(KERN_ALERT PFX "unable to allocate XFERQ %d\n",
> +			tgt->xferq_mem_size);
> +		goto mem_alloc_failure;
> +	}
> +	memset(tgt->xferq, 0, tgt->xferq_mem_size);
> +
> +	/* Allocate and map CONFQ&  CONFQ PBL */
> +	tgt->confq_mem_size = tgt->max_sqes * BNX2FC_CONFQ_WQE_SIZE;
> +	tgt->confq_mem_size = (tgt->confq_mem_size + (PAGE_SIZE - 1))&
> +			       PAGE_MASK;
> +
> +	tgt->confq = dma_alloc_coherent(&hba->pcidev->dev, tgt->confq_mem_size,
> +					&tgt->confq_dma, GFP_KERNEL);
> +	if (!tgt->confq) {
> +		printk(KERN_ALERT PFX "unable to allocate CONFQ %d\n",
> +			tgt->confq_mem_size);
> +		goto mem_alloc_failure;
> +	}
> +	memset(tgt->confq, 0, tgt->confq_mem_size);
> +
> +	tgt->confq_pbl_size =
> +		(tgt->confq_mem_size / PAGE_SIZE) * sizeof(void *);
> +	tgt->confq_pbl_size =
> +		(tgt->confq_pbl_size + (PAGE_SIZE - 1))&  PAGE_MASK;
> +
> +	tgt->confq_pbl = dma_alloc_coherent(&hba->pcidev->dev,
> +					    tgt->confq_pbl_size,
> +					&tgt->confq_pbl_dma, GFP_KERNEL);
> +	if (!tgt->confq_pbl) {
> +		printk(KERN_ALERT PFX "unable to allocate CONFQ PBL %d\n",
> +			tgt->confq_pbl_size);
> +		goto mem_alloc_failure;
> +	}
> +
> +	memset(tgt->confq_pbl, 0, tgt->confq_pbl_size);
> +	num_pages = tgt->confq_mem_size / PAGE_SIZE;
> +	page = tgt->confq_dma;
> +	pbl = (u32 *)tgt->confq_pbl;
> +
> +	while (num_pages--) {
> +		*pbl = (u32)page;
> +		pbl++;
> +		*pbl = (u32)((u64)page>>  32);
> +		pbl++;
> +		page += PAGE_SIZE;
> +	}
> +
> +	/* Allocate and map ConnDB */
> +	tgt->conn_db_mem_size = sizeof(struct fcoe_conn_db);
> +
> +	tgt->conn_db = dma_alloc_coherent(&hba->pcidev->dev,
> +					  tgt->conn_db_mem_size,
> +					&tgt->conn_db_dma, GFP_KERNEL);
> +	if (!tgt->conn_db) {
> +		printk(KERN_ALERT PFX "unable to allocate conn_db %d\n",
> +						tgt->conn_db_mem_size);
> +		goto mem_alloc_failure;
> +	}
> +	memset(tgt->conn_db, 0, tgt->conn_db_mem_size);
> +
> +
> +	/* Allocate and map LCQ */
> +	tgt->lcq_mem_size = (tgt->max_sqes + 8) * BNX2FC_SQ_WQE_SIZE;
> +	tgt->lcq_mem_size = (tgt->lcq_mem_size + (PAGE_SIZE - 1))&
> +			     PAGE_MASK;
> +
> +	tgt->lcq = dma_alloc_coherent(&hba->pcidev->dev, tgt->lcq_mem_size,
> +				&tgt->lcq_dma, GFP_KERNEL);
> +
> +	if (!tgt->lcq) {
> +		printk(KERN_ALERT PFX "unable to allocate lcq %d\n",
> +		       tgt->lcq_mem_size);
> +		goto mem_alloc_failure;
> +	}
> +	memset(tgt->lcq, 0, tgt->lcq_mem_size);
> +
> +	/* Arm CQ */
> +	tgt->conn_db->cq_arm.lo = -1;
> +	tgt->conn_db->rq_prod = 0x8000;
> +
> +	return 0;
> +
> +mem_alloc_failure:
> +	bnx2fc_free_session_resc(hba, tgt);
> +	bnx2fc_free_conn_id(hba, tgt->fcoe_conn_id);
> +	return -ENOMEM;
> +}
> +
