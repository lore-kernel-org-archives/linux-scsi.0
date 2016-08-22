From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 3/5] nvme-fabrics: Add host FC transport support
Date: Mon, 22 Aug 2016 09:45:56 -0700
Message-ID: <0bbf1735-6f90-c778-ee8a-02d954fbf108@broadcom.com>
References: <5792b91d.bp8ih+rK5Jet+Cpn%james.smart@broadcom.com>
 <1469830236.12212.48.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33177 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932773AbcHVQqU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 12:46:20 -0400
Received: by mail-pf0-f182.google.com with SMTP id y134so34064218pfg.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 09:45:59 -0700 (PDT)
In-Reply-To: <1469830236.12212.48.camel@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: J Freyensee <james_p_freyensee@linux.intel.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>



On 7/29/2016 3:10 PM, J Freyensee wrote:
>> +	/* TODO:
>> +	 * assoc_rqst->assoc_cmd.cntlid = cpu_to_be16(?);
>> +	 * strncpy(assoc_rqst->assoc_cmd.hostid, ?,
>> +	 *	min(FCNVME_ASSOC_HOSTID_LEN, NVMF_NQN_SIZE));
>> +	 * strncpy(assoc_rqst->assoc_cmd.hostnqn, ?,
>> +	 *	min(FCNVME_ASSOC_HOSTNQN_LEN, NVMF_NQN_SIZE];
>> +	 */
> What is the TODO here?

main todo is that the ctrlid is not known yet - not set in the opts 
struct yet. It's set within the fabrics connect
routines that build the capsule, which are called after this transport 
action.  So the todo is to modify
the core to add it to the opts struct as well. Then these lines can be 
added in.



>
> more snip...
>
>
>> +
>> +static int
>> +nvme_fc_init_queue(struct nvme_fc_ctrl *ctrl, int idx, size_t
>> queue_size)
>> +{
>> +	...
>> +
>> +	return 0;
> Slightly confused.  Looks like in nvme_fc_configure_admin_queue() and
> nvme_fc_init_io_queues() check for this function returning an error,
> but nvme_fc_init_queue() never returns anything but 0.  Should it
> return an error?  Does the comments above imply that this function
> could change in the future such that it would return something other
> than 0?
>
> more more snip...
>
>> +
>> +static int
>> +nvme_fc_init_io_queues(struct nvme_fc_ctrl *ctrl)
>> +{
>> +	...
>> +
>> +	return 0;
> Right now as-is nvme_fc_init_queue() will always return 0, but this
> function is hard-coded to return 0.  Independent of what
> nvme_fc_init_queue() returns, this function should be returning 'ret'
> as "nvme_fc_create_io_queues()" has code to check if this function
> fails:
>
>> +static int
>> +nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
>> +{
> .
> .
> .
>> +	dev_info(ctrl->ctrl.device, "creating %d I/O queues.\n",
>> +			opts->nr_io_queues);
>> +
>> +	ret = nvme_fc_init_io_queues(ctrl);
>> +	if (ret)
>> +		return ret;
>> +

Well, at the time it was written, it wasn't clear it would always return 
0. As it does, I'll see about cleaning it up.


>
>> +static int
>> +nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue
>> *queue,
>> +	struct nvme_fc_fcp_op *op, u32 data_len,
>> +	enum nvmefc_fcp_datadir	io_dir)
>> +{
>> +	...
>> +
>> +	if (op->rq)
>> +		blk_mq_start_request(op->rq);
>> +
>> +	ret = ctrl->lport->ops->fcp_io(&ctrl->lport->localport,
>> +					&ctrl->rport->remoteport,
>> +					queue->lldd_handle, &op
>> ->fcp_req);
>> +
>> +	if (ret) {
>> +		dev_err(ctrl->dev,
>> +			"Send nvme command failed - lldd returned
>> %d.\n", ret);
> see a bit lower for a comment on this if(ret) evaluating to TRUE.
>
>> +
>> +		if (op->rq) {			/* normal
>> request */
>> +			nvme_fc_unmap_data(ctrl, op->rq, op);
>> +			nvme_cleanup_cmd(op->rq);
>> +			if (ret != -EBUSY) {
>> +				/* complete the io w/ error status
>> */
>> +				blk_mq_complete_request(op->rq,
>> +						NVME_SC_FC_TRANSPORT
>> _ERROR);
>> +			} else {
>> +				blk_mq_stop_hw_queues(op->rq->q);
>> +				nvme_requeue_req(op->rq);
>> +				blk_mq_delay_queue(queue->hctx,
>> +						NVMEFC_QUEUE_DELAY);
>> +			}
>> +		} else {			/* aen */
>> +			struct nvme_completion *cqe = &op
>> ->rsp_iu.cqe;
>> +
>> +			cqe->status = (NVME_SC_FC_TRANSPORT_ERROR <<
>> 1);
>> +			nvme_complete_async_event(&queue->ctrl
>> ->ctrl, cqe);
>> +		}
>> +	}
>> +
>> +	return BLK_MQ_RQ_QUEUE_OK;
> Is this right?  We want to return 'BLK_MQ_RQ_QUEUE_OK' and not
> something to signify the 'ret' value was not 0?

yeah - this could probably use fixing. I should be returning 
BLK_MQ_RQ_QUEUE_BUSY for some of the cases and BLK_MQ_RQ_QUEUE_ERROR on 
some others.


>
>> +static struct nvme_ctrl *
>> +__nvme_fc_create_ctrl(struct device *dev, struct nvmf_ctrl_options
>> *opts,
>> +	struct nvme_fc_lport *lport, struct nvme_fc_rport *rport)
>> +{
>> +	struct nvme_fc_ctrl *ctrl;
>> +	int ret;
>> +	bool changed;
>> +
>> +	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
>> +	if (!ctrl)
>> +		return ERR_PTR(-ENOMEM);
>> +	ctrl->ctrl.opts = opts;
>> +	INIT_LIST_HEAD(&ctrl->ctrl_list);
>> +	ctrl->lport = lport;
>> +	ctrl->l_id = lport->localport.port_num;
>> +	ctrl->rport = rport;
>> +	ctrl->r_id = rport->remoteport.port_num;
>> +	ctrl->dev = lport->dev;
>> +
>> +	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_fc_ctrl_ops,
>> 0);
>> +	if (ret)
>> +		goto out_free_ctrl;
>> +
>> +	INIT_WORK(&ctrl->delete_work, nvme_fc_del_ctrl_work);
>> +	spin_lock_init(&ctrl->lock);
>> +
>> +	/* io queue count */
>> +	ctrl->queue_count = min_t(unsigned int,
>> +				opts->nr_io_queues,
>> +				lport->ops->max_hw_queues);
>> +	opts->nr_io_queues = ctrl->queue_count;	/* so opts
>> has valid value */
>> +	ctrl->queue_count++;	/* +1 for admin queue */
>> +
>> +	ctrl->ctrl.sqsize = opts->queue_size;
>> +	ctrl->ctrl.kato = opts->kato;
>> +
>> +	ret = -ENOMEM;
>> +	ctrl->queues = kcalloc(ctrl->queue_count, sizeof(struct
>> nvme_fc_queue),
>> +				GFP_KERNEL);
>> +	if (!ctrl->queues)
>> +		goto out_uninit_ctrl;
>> +
>> +	ret = nvme_fc_configure_admin_queue(ctrl);
>> +	if (ret)
>> +		goto out_kfree_queues;
>> +
>> +	/* sanity checks */
>> +
>> +	if (ctrl->ctrl.ioccsz != 4) {
> Slightly confused, the spec says the minimum value that may be
> specified is 4.  So 4 is not a legal value for fc transport?
>
> My preference would be to make this
>
> if (ctrl->ctrl.ioccsz <= 4) {
>
> even though the spec says the minimum value for ioccsz is 4 (to catch
> weird programming errors).

??   The only value supported by FC is a 64byte capsule (really SQE), 
thus only 4 is supported.   Although, you're touching on a point in the 
fabrics spec that I think is really screwy. ping me offline if you want 
more opinion.


>
>> +		dev_err(ctrl->ctrl.device, "ioccsz %d is not
>> supported!\n",
>> +				ctrl->ctrl.ioccsz);
>> +		goto out_remove_admin_queue;
>> +	}
>> +	if (ctrl->ctrl.iorcsz != 1) {
> dido here, so the fc transport does not support the minimum value the
> spec says, 1?

No - FC says it must be 1.  Thus a 16-byte CQE.

FC could expand to larger SQE/CQE, but not right now.


Thanks

-- james

