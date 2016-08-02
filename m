From: J Freyensee <james_p_freyensee@linux.intel.com>
Subject: Re: [PATCH 4/5] nvme-fabrics: Add target FC transport support
Date: Mon, 01 Aug 2016 21:37:50 -0700
Message-ID: <1470112670.6134.88.camel@linux.intel.com>
References: <5792b91e.51+4Ind0/2MxGqHU%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47143 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbcHBEi4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 00:38:56 -0400
In-Reply-To: <5792b91e.51+4Ind0/2MxGqHU%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Fri, 2016-07-22 at 17:23 -0700, James Smart wrote:

A few comments.

> Add nvme-fabrics target FC transport support
> 
> Implements the FC-NVME T11 definition of how nvme fabric capsules are
> performed on an FC fabric. Utilizes a lower-layer API to FC host
> adapters
> to send/receive FC-4 LS operations and perform the FCP transactions
> necessary
> to perform and FCP IO request for NVME.
> 
> The T11 definitions for FC-4 Link Services are implemented which
> create
> NVMeOF connections.  Implements the hooks with nvmet layer to pass
> NVME
> commands to it for processing and posting of data/response base to
> the
> host via the differernt connections.
> 
> 
snip
.
.
.

> +static void
> +nvmet_fc_free_target_queue(struct nvmet_fc_tgt_queue *queue)
> +{
> +	struct nvmet_fc_tgtport *tgtport = queue->assoc->tgtport;
> +	unsigned long flags;
> +
> +	/*
> +	 * beware: nvmet layer hangs waiting for a completion if
> +	 * connect command failed
> +	 */
> +	flush_workqueue(queue->work_q);
> +	if (queue->connected)
> +		nvmet_sq_destroy(&queue->nvme_sq);

I was wondering if there is any way for this fc target layer to fake
send an NVMe completion to the nvmet layer to prevent a nvmet layer
hang (because I'm assuming the nvmet layer hangs because it never
receives a connect completion upon failure here), then send a signal to
tear down the sq.

Or alternatively call nvmet_ctrl_fatal_error() if connect fails as a
trial/alternative to having the nvmet layer hang?


> +	spin_lock_irqsave(&tgtport->lock, flags);
> +	queue->assoc->queues[queue->qid] = NULL;
> +	spin_unlock_irqrestore(&tgtport->lock, flags);
> +	nvmet_fc_destroy_fcp_iodlist(tgtport, queue);
> +	destroy_workqueue(queue->work_q);
> +	kfree(queue);
> +}
> +
> +static struct nvmet_fc_tgt_queue *
> +nvmet_fc_find_target_queue(struct nvmet_fc_tgtport *tgtport,
> +				u64 connection_id)
> +{
> +	struct nvmet_fc_tgt_assoc *assoc;
> +	u64 association_id =
> nvmet_fc_getassociationid(connection_id);
> +	u16 qid = nvmet_fc_getqueueid(connection_id);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tgtport->lock, flags);
> +	list_for_each_entry(assoc, &tgtport->assoc_list, a_list) {
> +		if (association_id == assoc->association_id) {
> +			spin_unlock_irqrestore(&tgtport->lock,
> flags);
> +			return assoc->queues[qid];
> +		}
> +	}
> +	spin_unlock_irqrestore(&tgtport->lock, flags);
> +	return NULL;
> +}

snip
.
.

> +
> +/**
> + * nvme_fc_register_targetport - transport entry point called by an
> + *                              LLDD to register the existence of a
> local
> + *                              NVME subystem FC port.
> + * @pinfo:     pointer to information about the port to be
> registered
> + * @template:  LLDD entrypoints and operational parameters for the
> port
> + * @dev:       physical hardware device node port corresponds to.
> Will be
> + *             used for DMA mappings
> + * @tgtport_p:   pointer to a local port pointer. Upon success, the


looks like the variable tgtport_p does not exist (or it's now called
portptr)?

> routine
> + *             will allocate a nvme_fc_local_port structure and
> place its
> + *             address in the local port pointer. Upon failure,
> local port
> + *             pointer will be set to 0.

And I think the description is wrong, looks like the code does the more
correct thing, set *portptr = NULL, not 0.


snip.
.
.
.
> +/*
> + * Actual processing routine for received FC-NVME LS Requests from
> the LLD
> + */
> +void
> +nvmet_fc_handle_ls_rqst(struct nvmet_fc_tgtport *tgtport,
> +			struct nvmet_fc_ls_iod *iod)
> +{
> +	struct fcnvme_ls_rqst_w0 *w0 =
> +			(struct fcnvme_ls_rqst_w0 *)iod->rqstbuf;
> +
> +	iod->lsreq->nvmet_fc_private = iod;
> +	iod->lsreq->rspbuf = iod->rspbuf;
> +	iod->lsreq->rspdma = iod->rspdma;
> +	iod->lsreq->done = nvmet_fc_xmt_ls_rsp_done;
> +	/* Be preventative. handlers will later set to valid length
> */
> +	iod->lsreq->rsplen = 0;
> +
> +	iod->assoc = NULL;
> +
> +	/*
> +	 * handlers:
> +	 *   parse request input, set up nvmet req (cmd, rsp, 
>  execute)
> +	 *   and format the LS response
> +	 * if non-zero returned, then no futher action taken on the
> LS
> +	 * if zero:
> +	 *   valid to call nvmet layer if execute routine set
> +	 *   iod->rspbuf contains ls response
> +	 */
> +	switch (w0->ls_cmd) {
> +	case FCNVME_LS_CREATE_ASSOCIATION:
> +		/* Creates Association and initial Admin
> Queue/Connection */
> +		nvmet_fc_ls_create_association(tgtport, iod);
> +		break;
> +	case FCNVME_LS_CREATE_CONNECTION:
> +		/* Creates an IO Queue/Connection */
> +		nvmet_fc_ls_create_connection(tgtport, iod);
> +		break;
> +	case FCNVME_LS_DISCONNECT:
> +		/* Terminate a Queue/Connection or the Association
> */
> +		nvmet_fc_ls_disconnect(tgtport, iod);
> +		break;
> +	default:
> +		iod->lsreq->rsplen = nvmet_fc_format_rjt(iod
> ->rspbuf,
> +				NVME_FC_MAX_LS_BUFFER_SIZE, w0
> ->ls_cmd,
> +				LSRJT_REASON_INVALID_ELS_CODE,
> +				LSRJT_EXPL_NO_EXPLANATION, 0);
> +	}
> +
> +	nvmet_fc_xmt_ls_rsp(tgtport, iod);
> +}

All the functions in the case() (nvmet_fc_ls_disconnect(),
nvmet_fc_ls_create_association(), etc)  have internal return values
(errors and certain values), I'm curious why you wouldn't want to
bubble up those values through the function calling chain?  Especially
since there is a comment in the function above that says "if non-zero
returned, then no futher action taken on the LS".

snip
.
.

> +
> +/**
> + * nvmet_fc_rcv_fcp_req - transport entry point called by an LLDD
> + *                       upon the reception of a NVME FCP CMD IU.
> + *
> + * Pass a FC-NVME FCP CMD IU received from the FC link to the nvmet
> -fc
> + * layer for processing.
> + *
> + * The nvmet-fc layer will copy cmd payload to an internal structure
> for
> + * processing.  As such, upon completion of the routine, the LLDD
> may
> + * immediately free/reuse the CMD IU buffer passed in the call.
> + *
> + * If this routine returns error, the lldd should abort the
> exchange.
> + *
> + * @tgtport:    pointer to the (registered) target port the FCP CMD
> IU
> + *              was receive on.

misspelling between this variable name and 'target_port'.

> + * @fcpreq:     pointer to a fcpreq request structure to be used to
> reference
> + *              the exchange corresponding to the FCP Exchange.
> + * @cmdiubuf:   pointer to the buffer containing the FCP CMD IU
> + * @cmdiubuf_len: length, in bytes, of the received FCP CMD IU
> + */
> +int
> +nvmet_fc_rcv_fcp_req(struct nvmet_fc_target_port *target_port,
> +			struct nvmefc_tgt_fcp_req *fcpreq,
> +			void *cmdiubuf, u32 cmdiubuf_len)
> +{
> +	struct nvmet_fc_tgtport *tgtport = container_of(target_port,
> +			struct nvmet_fc_tgtport, fc_target_port);
> +	struct nvme_fc_cmd_iu *cmdiu = cmdiubuf;
> +	struct nvmet_fc_tgt_queue *queue;
> +	struct nvmet_fc_fcp_iod *fod;
> +
> +
> +	/* validate iu, so the connection id can be used to find the
> queue */
> +	if ((cmdiubuf_len != sizeof(*cmdiu)) ||
> +			(cmdiu->scsi_id != NVME_CMD_SCSI_ID) ||
> +			(cmdiu->fc_id != NVME_CMD_FC_ID) ||
> +			(be16_to_cpu(cmdiu->iu_len) !=
> (sizeof(*cmdiu)/4)))
> +		return -EIO;
> +
> +	queue = nvmet_fc_find_target_queue(tgtport,
> +				be64_to_cpu(cmdiu->connection_id));
> +	if (!queue)
> +		return -ENOTCONN;
> +
> +	fod = nvmet_fc_alloc_fcp_iod(tgtport, queue);
> +	if (!fod)
> +		return -ENOENT;
> +
> +	fcpreq->nvmet_fc_private = fod;
> +	fod->fcpreq = fcpreq;
> +	memcpy(&fod->cmdiubuf, cmdiubuf, cmdiubuf_len);
> +
> +	queue_work(fod->queue->work_q, &fod->work);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nvmet_fc_rcv_fcp_req);

snip
.
.
> +
> +static int __init nvmet_fc_init_module(void)
> +{
> +	/* ensure NVMET_NR_QUEUES is a power of 2 - required for our
> masks */
> +	if (!is_power_of_2((unsigned long)NVMET_NR_QUEUES)) {
> +		pr_err("%s: NVMET_NR_QUEUES required to be power of
> 2\n",
> +				__func__);

If this is so important that NVMET_NR_QUEUES always be a power of two
for this FC driver, I'd have the function print out the value in the
error message for easier diagnosis.

And why mask the sign of NVMET_NR_QUEUES?  Yes, it would have to be a
really careless programmer error that would be caught very quick if the
#define became negative, but masking out the sign of a #define value
that seems to be pretty important for FC transport functionality makes
me a tad nervous.

> +		return(-EINVAL);

nitpick, about the only 'return' line using parenthesis in the whole
file.

> +	}
> +
> +	return nvmet_register_transport(&nvmet_fc_tgt_fcp_ops);

> +}
> +
> +static void __exit nvmet_fc_exit_module(void)
> +{
> +	nvmet_unregister_transport(&nvmet_fc_tgt_fcp_ops);
> +
> +	__nvmet_fc_free_tgtports();
> +}
> +
> +module_init(nvmet_fc_init_module);
> +module_exit(nvmet_fc_exit_module);
> +
> +MODULE_LICENSE("GPL v2");
> +
> +

Good stuff James,
J


> +
