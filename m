From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v2 PATCH 3/5] bnx2fc: Broadcom FCoE Offload driver submission
 - part 1
Date: Thu, 13 Jan 2011 18:57:24 -0600
Message-ID: <4D2F9F74.9030206@cs.wisc.edu>
References: <1293170553.4676.573.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52317 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1ANA5e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2011 19:57:34 -0500
In-Reply-To: <1293170553.4676.573.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org, mchan@broadcom.com

You should add more informative emails subject names.

On 12/24/2010 12:02 AM, Bhanu Gollapudi wrote:
> +int bnx2fc_send_rrq(struct bnx2fc_cmd *aborted_io_req)
> +{
> +
> +	struct fc_els_rrq rrq;
> +	struct bnx2fc_rport *tgt = aborted_io_req->tgt;
> +	struct fc_lport *lport = tgt->rdata->local_port;
> +	struct bnx2fc_els_cb_arg *cb_arg = NULL;
> +	u32 sid = tgt->sid;
> +	u32 r_a_tov = lport->r_a_tov;
> +	int rc;
> +
> +	bnx2fc_dbg(LOG_ELS, "Sending RRQ orig_xid = 0x%x\n",
> +		   aborted_io_req->xid);
> +	memset(&rrq, 0, sizeof(rrq));
> +
> +	cb_arg = kzalloc(sizeof(struct bnx2fc_els_cb_arg), GFP_ATOMIC);

I think you can sleep in this path, right? It looks like it is run from 
workqueue and no locks held. You probably want to use GFP_NOIO instead 
of atomic then.

Change bnx2fc_send_adisc and bnx2fc_send_logo too then.

If you can't sleep in this path then you have a problem because they 
call bnx2fc_initiate_els which sleeps when allocations fail.


> +
> +static void bnx2fc_l2_els_compl(struct bnx2fc_els_cb_arg *cb_arg)
> +{
> +	struct bnx2fc_cmd *els_req;
> +	struct bnx2fc_rport *tgt;
> +	struct bnx2fc_mp_req *mp_req;
> +	struct fc_frame_header *fc_hdr;
> +	unsigned char *buf;
> +	void *resp_buf;
> +	u32 resp_len, hdr_len;
> +	u16 l2_oxid;
> +	int frame_len;
> +	int rc = 0;
> +
> +	l2_oxid = cb_arg->l2_oxid;
> +	bnx2fc_dbg(LOG_ELS, "ELS COMPL - l2_oxid = 0x%x\n", l2_oxid);
> +
> +	els_req = cb_arg->io_req;
> +	if (test_and_clear_bit(BNX2FC_FLAG_ELS_TIMEOUT,&els_req->req_flags)) {
> +		/*
> +		 * els req is timed out. cleanup the IO with FW and
> +		 * drop the completion. libfc will handle the els timeout
> +		 */
> +		if (els_req->on_active_queue) {
> +			list_del_init(&els_req->link);
> +			els_req->on_active_queue = 0;
> +			rc = bnx2fc_initiate_cleanup(els_req);
> +			BUG_ON(rc);
> +		}
> +		goto free_arg;
> +	}
> +
> +	tgt = els_req->tgt;
> +	mp_req =&(els_req->mp_req);
> +	fc_hdr =&(mp_req->resp_fc_hdr);
> +	resp_len = mp_req->resp_len;
> +	resp_buf = mp_req->resp_buf;
> +
> +	buf = kzalloc(0x1000, GFP_ATOMIC);


Where did the size value for the allocation come from? It is a little 
scary in that it is hard coded and then you copy to it with no bounds 
checks.



> diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> new file mode 100644
> index 0000000..6452b0f
> --- /dev/null
> +++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> @@ -0,0 +1,1939 @@
> +/* bnx2fc_hwi.c: Broadcom NetXtreme II Linux FCoE offload driver.
> + *

Instead of adding that info about the driver in every file it would be 
more helpful to put some info on the code in the file.

bnx2fc_hwi.c: Low level functions that interact with the bnx hardware 
blah blah or something.


> + * bnx2fc_send_fw_fcoe_init_msg - initiates initial handshake with FCoE f/w
> + *
> + * @hba:	adapter structure pointer
> + *
> + * Send down FCoE firmware init KWQEs which initiates the initial handshake
> + *	with the f/w.
> + *
> + */
> +int bnx2fc_send_fw_fcoe_init_msg(struct bnx2fc_hba *hba)
> +{
> +	struct fcoe_kwqe_init1 fcoe_init1;
> +	struct fcoe_kwqe_init2 fcoe_init2;
> +	struct fcoe_kwqe_init3 fcoe_init3;
> +	struct kwqe *kwqe_arr[3];
> +	int num_kwqes = 3;
> +	int rc = 0;
> +
> +	if (!hba->cnic) {
> +		printk(KERN_ALERT PFX "hba->cnic NULL during fcoe fw init\n");
> +		return -ENODEV;
> +	}
> +
> +	/* fill init1 KWQE */
> +	memset(&fcoe_init1, 0x00, sizeof(struct fcoe_kwqe_init1));
> +	fcoe_init1.hdr.op_code = FCOE_KWQE_OPCODE_INIT1;
> +	fcoe_init1.hdr.flags = (FCOE_KWQE_LAYER_CODE<<
> +					FCOE_KWQE_HEADER_LAYER_CODE_SHIFT);
> +
> +	fcoe_init1.num_tasks = BNX2FC_MAX_TASKS;
> +	fcoe_init1.sq_num_wqes = BNX2FC_SQ_WQES_MAX;
> +	fcoe_init1.rq_num_wqes = BNX2FC_RQ_WQES_MAX;
> +	fcoe_init1.rq_buffer_log_size = BNX2FC_RQ_BUF_LOG_SZ;
> +	fcoe_init1.cq_num_wqes = BNX2FC_CQ_WQES_MAX;
> +	fcoe_init1.dummy_buffer_addr_lo = (u32) hba->dummy_buf_dma;
> +	fcoe_init1.dummy_buffer_addr_hi = (u32) ((u64)hba->dummy_buf_dma>>  32);
> +	fcoe_init1.task_list_pbl_addr_lo = (u32) hba->task_ctx_bd_dma;
> +	fcoe_init1.task_list_pbl_addr_hi =
> +				(u32) ((u64) hba->task_ctx_bd_dma>>  32);
> +	fcoe_init1.mtu = hba->netdev->mtu;
> +
> +	fcoe_init1.flags = (PAGE_SHIFT<<
> +				FCOE_KWQE_INIT1_LOG_PAGE_SIZE_SHIFT);
> +	fcoe_init1.flags |= (0<<
> +				FCOE_KWQE_INIT1_LOG_CACHED_PBES_PER_FUNC_SHIFT);

Is that right? What does shifting zero supposed to do here?


> +
> +/**
> + * bnx2fc_fastpath_notification - process global event queue (KCQ)
> + *
> + * @hba:		adapter structure pointer
> + * @new_cqe_kcqe:	pointer to newly DMA'd KCQ entry
> + *
> + * Fast path event notification handler
> + */
> +static void bnx2fc_fastpath_notification(struct bnx2fc_hba *hba,
> +					struct fcoe_kcqe *new_cqe_kcqe)
> +{
> +	u32 conn_id = new_cqe_kcqe->fcoe_conn_id;
> +	struct bnx2fc_rport *tgt =
> +			(struct bnx2fc_rport *)hba->tgt_ofld_list[conn_id];


no case needed.

> +
> +	if (!tgt) {
> +		printk(KERN_ALERT PFX "conn_id 0x%x not valid\n", conn_id);
> +		return;
> +	}
> +	bnx2fc_process_new_cqes(tgt);
> +}
> +
> +/**
> + * bnx2fc_process_ofld_cmpl - process FCoE session offload completion
> + *
> + * @hba:	adapter structure pointer
> + * @ofld_kcqe:	connection offload kcqe pointer
> + *
> + * handle session offload completion, enable the session if offload is
> + * successful.
> + */
> +static void bnx2fc_process_ofld_cmpl(struct bnx2fc_hba *hba,
> +					struct fcoe_kcqe *ofld_kcqe)
> +{
> +	struct bnx2fc_rport		*tgt;
> +	struct bnx2fc_port		*port;
> +	u32				conn_id;
> +	u32				context_id;
> +	int				rc;
> +
> +	conn_id = ofld_kcqe->fcoe_conn_id;
> +	context_id = ofld_kcqe->fcoe_conn_context_id;
> +	bnx2fc_dbg(LOG_SESS, "Entered ofld compl - context_id = 0x%x\n",
> +		ofld_kcqe->fcoe_conn_context_id);
> +	tgt = (struct bnx2fc_rport *)hba->tgt_ofld_list[conn_id];

No case needed. Did the tgt_ofld_list array change or am I looking at it 
right? tgt_ofld_list is an array of struct bnx2fc_rport *, so no need to 
cast, right. If I am right fix them all. I don't think I mentioned them all.


> +	return;

No return needed. How about, just check the rest of the functions for 
this and fix.



> +static void bnx2fc_process_fcoe_error(struct bnx2fc_hba *hba,
> +					struct fcoe_kcqe *fcoe_err)
> +{
> +
> +
> +}


Just delete this.


> +
> +void bnx2fc_add_2_sq(struct bnx2fc_rport *tgt, u16 xid)
> +{
> +	struct fcoe_sqe *sqe;
> +
> +	sqe = (struct fcoe_sqe *)&tgt->sq[tgt->sq_prod_idx];
> +

No cast needed. Just check all the casts and if you are casting to/from 
a void or casting to/from the same structs then no case needed.




> +
> +/**
> + * bnx2fc_setup_task_ctx - allocate and map task context
> + *
> + * @hba:	pointer to adapter structure
> + *
> + * allocate memory for task context, and associated BD table to be used
> + * by firmware
> + *
> + */
> +int bnx2fc_setup_task_ctx(struct bnx2fc_hba *hba)
> +{
> +	int rc = 0;
> +	struct regpair *task_ctx_bdt;
> +	dma_addr_t addr;
> +	int i;
> +
> +	/*
> +	 * Allocate task context bd table. A page size of bd table
> +	 * can map 256 buffers. Each buffer contains 32 task context
> +	 * entries. Hence the limit with one page is 8192 task context
> +	 * entries.
> +	 */
> +	hba->task_ctx_bd_tbl = dma_alloc_coherent(&hba->pcidev->dev,
> +						  PAGE_SIZE,
> +						&hba->task_ctx_bd_dma,
> +						  GFP_KERNEL);
> +	if (!hba->task_ctx_bd_tbl) {
> +		printk(KERN_ERR PFX "unable to allocate task context BDT\n");
> +		rc = -1;
> +		goto out;
> +	}
> +	memset(hba->task_ctx_bd_tbl, 0, PAGE_SIZE);
> +
> +	/*
> +	 * Allocate task_ctx which is an array of pointers pointing to
> +	 * a page containing 32 task contexts
> +	 */
> +	hba->task_ctx = kmalloc((BNX2FC_TASK_CTX_ARR_SZ * sizeof(void *)),
> +				 GFP_KERNEL);
> +	if (!hba->task_ctx) {
> +		printk(KERN_ERR PFX "unable to allocate task context array\n");
> +		rc = -1;
> +		goto out1;
> +	}
> +	memset(hba->task_ctx, 0, BNX2FC_TASK_CTX_ARR_SZ * sizeof(void *));
> +


Use kzalloc.


> +	/*
> +	 * Allocate task_ctx_dma which is an array of dma addresses
> +	 */
> +	hba->task_ctx_dma = kmalloc((BNX2FC_TASK_CTX_ARR_SZ *
> +					sizeof(dma_addr_t)), GFP_KERNEL);
> +	if (!hba->task_ctx_dma) {
> +		printk(KERN_ERR PFX "unable to alloc context mapping array\n");
> +		rc = -1;
> +		goto out2;
> +	}
> +
> +	task_ctx_bdt = (struct regpair *)hba->task_ctx_bd_tbl;
> +	for (i = 0; i<  BNX2FC_TASK_CTX_ARR_SZ; i++) {
> +
> +		hba->task_ctx[i] = dma_alloc_coherent(&hba->pcidev->dev,
> +						      PAGE_SIZE,
> +						&hba->task_ctx_dma[i],
> +						      GFP_KERNEL);
> +		if (!hba->task_ctx[i]) {
> +			printk(KERN_ERR PFX "unable to alloc task context\n");
> +			rc = -1;
> +			goto out3;
> +		}


I think you want a dma pool instead.


> +		memset(hba->task_ctx[i], 0, PAGE_SIZE);
> +		addr = (u64)hba->task_ctx_dma[i];
> +		task_ctx_bdt->hi = (u64) addr>>  32;
> +		task_ctx_bdt->lo = (u32) addr;
> +		task_ctx_bdt++;
> +	}
> +	return 0;
> +
> +out3:
> +	for (i = 0; i<  BNX2FC_TASK_CTX_ARR_SZ; i++) {
> +		if (hba->task_ctx[i]) {
> +
> +			dma_free_coherent(&hba->pcidev->dev, PAGE_SIZE,
> +				hba->task_ctx[i], hba->task_ctx_dma[i]);
> +			hba->task_ctx[i] = NULL;
> +		}
> +	}
> +
> +	kfree(hba->task_ctx_dma);
> +	hba->task_ctx_dma = NULL;
> +out2:
> +	kfree(hba->task_ctx);
> +	hba->task_ctx = NULL;
> +out1:
> +	dma_free_coherent(&hba->pcidev->dev, PAGE_SIZE,
> +			hba->task_ctx_bd_tbl, hba->task_ctx_bd_dma);
> +	hba->task_ctx_bd_tbl = NULL;
> +out:
> +	return rc;
> +}




