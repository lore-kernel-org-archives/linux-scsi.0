From: J Freyensee <james_p_freyensee@linux.intel.com>
Subject: Re: [PATCH 3/5] nvme-fabrics: Add host FC transport support
Date: Fri, 29 Jul 2016 15:10:36 -0700
Message-ID: <1469830236.12212.48.camel@linux.intel.com>
References: <5792b91d.bp8ih+rK5Jet+Cpn%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbcG2WKo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2016 18:10:44 -0400
In-Reply-To: <5792b91d.bp8ih+rK5Jet+Cpn%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Fri, 2016-07-22 at 17:23 -0700, James Smart wrote:

A couple of minor comments:


> Add nvme-fabrics host FC transport support
> 
> Implements the FC-NVME T11 definition of how nvme fabric capsules are
> performed on an FC fabric. Utilizes a lower-layer API to FC host
> adapters
> to send/receive FC-4 LS operations and FCP operations that comprise
> NVME
> over FC operation.
> 
> The T11 definitions for FC-4 Link Services are implemented which
> create
> NVMeOF connections.  Implements the hooks with blk-mq to then submit
> admin
> and io requests to the different connections.
> 
> 
> Signed-off-by: James Smart <james.smart@broadcom.com>

snip...

> +	/* TODO:
> +	 * assoc_rqst->assoc_cmd.cntlid = cpu_to_be16(?);
> +	 * strncpy(assoc_rqst->assoc_cmd.hostid, ?,
> +	 *	min(FCNVME_ASSOC_HOSTID_LEN, NVMF_NQN_SIZE));
> +	 * strncpy(assoc_rqst->assoc_cmd.hostnqn, ?,
> +	 *	min(FCNVME_ASSOC_HOSTNQN_LEN, NVMF_NQN_SIZE];
> +	 */

What is the TODO here?

more snip...


> +
> +static int
> +nvme_fc_init_queue(struct nvme_fc_ctrl *ctrl, int idx, size_t
> queue_size)
> +{
> +	struct nvme_fc_queue *queue;
> +
> +	queue = &ctrl->queues[idx];
> +	memset(queue, 0, sizeof(*queue));
> +	queue->ctrl = ctrl;
> +	queue->qnum = idx;
> +	atomic_set(&queue->csn, 1);
> +	queue->dev = ctrl->dev;
> +
> +	if (idx > 0)
> +		queue->cmnd_capsule_len = ctrl->ctrl.ioccsz * 16;
> +	else
> +		queue->cmnd_capsule_len = sizeof(struct
> nvme_command);
> +
> +	queue->queue_size = queue_size;
> +
> +	/*
> +	 * Considered whether we should allocate buffers for all
> SQEs
> +	 * and CQEs and dma map them - mapping their respective
> entries
> +	 * into the request structures (kernel vm addr and dma
> address)
> +	 * thus the driver could use the buffers/mappings directly.
> +	 * It only makes sense if the LLDD would use them for its
> +	 * messaging api. It's very unlikely most adapter api's
> would use
> +	 * a native NVME sqe/cqe. More reasonable if FC-NVME IU
> payload
> +	 * structures were used instead. For now - just pass the
> +	 * sqe/cqes to the driver and let it deal with it. We'll
> figure
> +	 * out if the FC-NVME IUs make sense later.
> +	 */
> +
> +	return 0;

Slightly confused.  Looks like in nvme_fc_configure_admin_queue() and
nvme_fc_init_io_queues() check for this function returning an error,
but nvme_fc_init_queue() never returns anything but 0.  Should it
return an error?  Does the comments above imply that this function
could change in the future such that it would return something other
than 0?

more more snip...

> +
> +static int
> +nvme_fc_init_io_queues(struct nvme_fc_ctrl *ctrl)
> +{
> +	int i, ret;
> +
> +	for (i = 1; i < ctrl->queue_count; i++) {
> +		ret = nvme_fc_init_queue(ctrl, i, ctrl
> ->ctrl.sqsize);
> +		if (ret) {
> +			dev_info(ctrl->ctrl.device,
> +				"failed to initialize i/o queue %d:
> %d\n",
> +				i, ret);
> +		}
> +	}
> +
> +	return 0;

Right now as-is nvme_fc_init_queue() will always return 0, but this
function is hard-coded to return 0.  Independent of what
nvme_fc_init_queue() returns, this function should be returning 'ret'
as "nvme_fc_create_io_queues()" has code to check if this function
fails:

> +static int
> +nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
> +{
.
.
.
> +	dev_info(ctrl->ctrl.device, "creating %d I/O queues.\n",
> +			opts->nr_io_queues);
> +
> +	ret = nvme_fc_init_io_queues(ctrl);
> +	if (ret)
> +		return ret;
> +
.
.

more more more snip...

> +static int
> +nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue
> *queue,
> +	struct nvme_fc_fcp_op *op, u32 data_len,
> +	enum nvmefc_fcp_datadir	io_dir)
> +{
> +	struct nvme_fc_cmd_iu *cmdiu = &op->cmd_iu;
> +	struct nvme_command *sqe = &cmdiu->sqe;
> +	u32 csn;
> +	int ret;
> +
> +	/* format the FC-NVME CMD IU and fcp_req */
> +	cmdiu->connection_id = cpu_to_be64(queue->connection_id);
> +	csn = atomic_inc_return(&queue->csn);
> +	cmdiu->csn = cpu_to_be32(csn);
> +	cmdiu->data_len = cpu_to_be32(data_len);
> +	switch (io_dir) {
> +	case NVMEFC_FCP_WRITE:
> +		cmdiu->flags = FCNVME_CMD_FLAGS_WRITE;
> +		break;
> +	case NVMEFC_FCP_READ:
> +		cmdiu->flags = FCNVME_CMD_FLAGS_READ;
> +		break;
> +	case NVMEFC_FCP_NODATA:
> +		cmdiu->flags = 0;
> +		break;
> +	}
> +	op->fcp_req.payload_length = data_len;
> +	op->fcp_req.io_dir = io_dir;
> +	op->fcp_req.transferred_length = 0;
> +	op->fcp_req.rcv_rsplen = 0;
> +	op->fcp_req.status = 0;
> +
> +	/*
> +	 * validate per fabric rules, set fields mandated by fabric
> spec
> +	 * as well as those by FC-NVME spec.
> +	 */
> +	WARN_ON_ONCE(sqe->common.metadata);
> +	WARN_ON_ONCE(sqe->common.dptr.prp1);
> +	WARN_ON_ONCE(sqe->common.dptr.prp2);
> +	sqe->common.flags |= NVME_CMD_SGL_METABUF;
> +
> +	/*
> +	 * format SQE DPTR field per FC-NVME rules
> +	 *    type=data block descr; subtype=offset;
> +	 *    offset is currently 0.
> +	 */
> +	sqe->rw.dptr.sgl.type = NVME_SGL_FMT_OFFSET;
> +	sqe->rw.dptr.sgl.length = cpu_to_le32(data_len);
> +	sqe->rw.dptr.sgl.addr = 0;
> +
> +	/* odd that we set the command_id - should come from nvme
> -fabrics */
> +	WARN_ON_ONCE(sqe->common.command_id != cpu_to_le16(op
> ->rqno));
> +
> +	if (op->rq) {				/* skipped on
> aens */
> +		ret = nvme_fc_map_data(ctrl, op->rq, op);
> +		if (ret < 0) {
> +			dev_err(queue->ctrl->ctrl.device,
> +			     "Failed to map data (%d)\n", ret);
> +			nvme_cleanup_cmd(op->rq);
> +			return (ret == -ENOMEM || ret == -EAGAIN) ?
> +				BLK_MQ_RQ_QUEUE_BUSY :
> BLK_MQ_RQ_QUEUE_ERROR;
> +		}
> +	}
> +
> +	dma_sync_single_for_device(ctrl->lport->dev, op
> ->fcp_req.cmddma,
> +				  sizeof(op->cmd_iu),
> DMA_TO_DEVICE);
> +
> +	atomic_set(&op->state, FCPOP_STATE_ACTIVE);
> +
> +	if (op->rq)
> +		blk_mq_start_request(op->rq);
> +
> +	ret = ctrl->lport->ops->fcp_io(&ctrl->lport->localport,
> +					&ctrl->rport->remoteport,
> +					queue->lldd_handle, &op
> ->fcp_req);
> +
> +	if (ret) {
> +		dev_err(ctrl->dev,
> +			"Send nvme command failed - lldd returned
> %d.\n", ret);

see a bit lower for a comment on this if(ret) evaluating to TRUE.

> +
> +		if (op->rq) {			/* normal
> request */
> +			nvme_fc_unmap_data(ctrl, op->rq, op);
> +			nvme_cleanup_cmd(op->rq);
> +			if (ret != -EBUSY) {
> +				/* complete the io w/ error status
> */
> +				blk_mq_complete_request(op->rq,
> +						NVME_SC_FC_TRANSPORT
> _ERROR);
> +			} else {
> +				blk_mq_stop_hw_queues(op->rq->q);
> +				nvme_requeue_req(op->rq);
> +				blk_mq_delay_queue(queue->hctx,
> +						NVMEFC_QUEUE_DELAY);
> +			}
> +		} else {			/* aen */
> +			struct nvme_completion *cqe = &op
> ->rsp_iu.cqe;
> +
> +			cqe->status = (NVME_SC_FC_TRANSPORT_ERROR <<
> 1);
> +			nvme_complete_async_event(&queue->ctrl
> ->ctrl, cqe);
> +		}
> +	}
> +
> +	return BLK_MQ_RQ_QUEUE_OK;

Is this right?  We want to return 'BLK_MQ_RQ_QUEUE_OK' and not
something to signify the 'ret' value was not 0?

4 x more snip...

> +
> +static int
> +nvme_fc_configure_admin_queue(struct nvme_fc_ctrl *ctrl)
> +{
> +	u32 segs;
> +	int error;
> +
> +	error = nvme_fc_init_queue(ctrl, 0, NVME_FC_AQ_BLKMQ_DEPTH);
> +	if (error)
> +		return error;
> +
> +	error = nvme_fc_connect_admin_queue(ctrl, &ctrl->queues[0],
> +				NVME_FC_AQ_BLKMQ_DEPTH,
> +				(NVME_FC_AQ_BLKMQ_DEPTH / 4));
> +	if (error)
> +		return error;
> +
> +	memset(&ctrl->admin_tag_set, 0, sizeof(ctrl
> ->admin_tag_set));
> +	ctrl->admin_tag_set.ops = &nvme_fc_admin_mq_ops;
> +	ctrl->admin_tag_set.queue_depth = NVME_FC_AQ_BLKMQ_DEPTH;
> +	ctrl->admin_tag_set.reserved_tags = 2; /* fabric connect +
> Keep-Alive */
> +	ctrl->admin_tag_set.numa_node = NUMA_NO_NODE;
> +	ctrl->admin_tag_set.cmd_size = sizeof(struct nvme_fc_fcp_op)
> +
> +					(SG_CHUNK_SIZE *
> +						sizeof(struct
> scatterlist)) +
> +					ctrl->lport->ops
> ->fcprqst_priv_sz;
> +	ctrl->admin_tag_set.driver_data = ctrl;
> +	ctrl->admin_tag_set.nr_hw_queues = 1;
> +	ctrl->admin_tag_set.timeout = ADMIN_TIMEOUT;
> +
> +	error = blk_mq_alloc_tag_set(&ctrl->admin_tag_set);
> +	if (error)
> +		goto out_free_queue;
> +
> +	ctrl->ctrl.admin_q = blk_mq_init_queue(&ctrl
> ->admin_tag_set);
> +	if (IS_ERR(ctrl->ctrl.admin_q)) {
> +		error = PTR_ERR(ctrl->ctrl.admin_q);
> +		goto out_free_tagset;
> +	}
> +
> +	error = __nvme_fc_create_hw_queue(ctrl, &ctrl->queues[0], 0,
> +				NVME_FC_AQ_BLKMQ_DEPTH);
> +	if (error)
> +		goto out_cleanup_queue;
> +
> +	error = nvmf_connect_admin_queue(&ctrl->ctrl);
> +	if (error)
> +		goto out_delete_hw_queue;
> +
> +	error = nvmf_reg_read64(&ctrl->ctrl, NVME_REG_CAP, &ctrl
> ->cap);
> +	if (error) {
> +		dev_err(ctrl->ctrl.device,
> +			"prop_get NVME_REG_CAP failed\n");
> +		goto out_delete_hw_queue;
> +	}
> +
> +	ctrl->ctrl.sqsize =
> +		min_t(int, NVME_CAP_MQES(ctrl->cap) + 1, ctrl
> ->ctrl.sqsize);
> +
> +	error = nvme_enable_ctrl(&ctrl->ctrl, ctrl->cap);
> +	if (error)
> +		goto out_delete_hw_queue;
> +
> +	segs = min_t(u32, NVME_FC_MAX_SEGMENTS,
> +			ctrl->lport->ops->max_sgl_segments);
> +	ctrl->ctrl.max_hw_sectors = (segs - 1) << (PAGE_SHIFT - 9);
> +
> +	error = nvme_init_identify(&ctrl->ctrl);
> +	if (error)
> +		goto out_delete_hw_queue;
> +
> +	nvme_start_keep_alive(&ctrl->ctrl);
> +
> +	return 0;
> +
> +out_delete_hw_queue:
> +	__nvme_fc_delete_hw_queue(ctrl, &ctrl->queues[0], 0);
> +out_cleanup_queue:
> +	blk_cleanup_queue(ctrl->ctrl.admin_q);
> +out_free_tagset:
> +	blk_mq_free_tag_set(&ctrl->admin_tag_set);
> +out_free_queue:
> +	nvme_fc_free_queue(&ctrl->queues[0]);
> +	return error;
> +}
> +

leaving in the above function from the referral comments I made before.

again snip...


> +static int
> +nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
> +{

> +	struct nvmf_ctrl_options *opts = ctrl->ctrl.opts;
> +	int ret;
> +
> +	ret = nvme_set_queue_count(&ctrl->ctrl, &opts
> ->nr_io_queues);
> +	if (ret) {
> +		dev_info(ctrl->ctrl.device,
> +			"set_queue_count failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ctrl->queue_count = opts->nr_io_queues + 1;
> +	if (!opts->nr_io_queues)
> +		return 0;
> +

> +	dev_info(ctrl->ctrl.device, "creating %d I/O queues.\n",
> +			opts->nr_io_queues);
> +
> +	ret = nvme_fc_init_io_queues(ctrl);
> +	if (ret)
> +		return ret;
> +

> +	memset(&ctrl->tag_set, 0, sizeof(ctrl->tag_set));
> +	ctrl->tag_set.ops = &nvme_fc_mq_ops;
> +	ctrl->tag_set.queue_depth = ctrl->ctrl.sqsize;
> +	ctrl->tag_set.reserved_tags = 1; /* fabric connect */
> +	ctrl->tag_set.numa_node = NUMA_NO_NODE;
> +	ctrl->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
> +	ctrl->tag_set.cmd_size = sizeof(struct nvme_fc_fcp_op) +
> +					(SG_CHUNK_SIZE *
> +						sizeof(struct
> scatterlist)) +
> +					ctrl->lport->ops
> ->fcprqst_priv_sz;
> +	ctrl->tag_set.driver_data = ctrl;
> +	ctrl->tag_set.nr_hw_queues = ctrl->queue_count - 1;
> +	ctrl->tag_set.timeout = NVME_IO_TIMEOUT;
> +
> +	ret = blk_mq_alloc_tag_set(&ctrl->tag_set);
> +	if (ret)
> +		return ret;
> +
> +	ctrl->ctrl.tagset = &ctrl->tag_set;
> +
> +	ctrl->ctrl.connect_q = blk_mq_init_queue(&ctrl->tag_set);
> +	if (IS_ERR(ctrl->ctrl.connect_q)) {
> +		ret = PTR_ERR(ctrl->ctrl.connect_q);
> +		goto out_free_tag_set;
> +	}
> +
> +	ret = nvme_fc_create_hw_io_queues(ctrl, ctrl->ctrl.sqsize);
> +	if (ret)
> +		goto out_cleanup_blk_queue;
> +
> +	ret = nvme_fc_connect_io_queues(ctrl, ctrl->ctrl.sqsize);
> +	if (ret)
> +		goto out_delete_hw_queues;
> +
> +	return 0;
> +
> +out_delete_hw_queues:
> +	nvme_fc_delete_hw_io_queues(ctrl);
> +out_cleanup_blk_queue:
> +	nvme_stop_keep_alive(&ctrl->ctrl);
> +	blk_cleanup_queue(ctrl->ctrl.connect_q);
> +out_free_tag_set:
> +	blk_mq_free_tag_set(&ctrl->tag_set);
> +	nvme_fc_free_io_queues(ctrl);
> +
> +	return ret;
> +}
> +
> +
leaving in from the referral comments I made earlier...

snippy-snip...

> +static struct nvme_ctrl *
> +__nvme_fc_create_ctrl(struct device *dev, struct nvmf_ctrl_options
> *opts,
> +	struct nvme_fc_lport *lport, struct nvme_fc_rport *rport)
> +{
> +	struct nvme_fc_ctrl *ctrl;
> +	int ret;
> +	bool changed;
> +
> +	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
> +	if (!ctrl)
> +		return ERR_PTR(-ENOMEM);
> +	ctrl->ctrl.opts = opts;
> +	INIT_LIST_HEAD(&ctrl->ctrl_list);
> +	ctrl->lport = lport;
> +	ctrl->l_id = lport->localport.port_num;
> +	ctrl->rport = rport;
> +	ctrl->r_id = rport->remoteport.port_num;
> +	ctrl->dev = lport->dev;
> +
> +	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_fc_ctrl_ops,
> 0);
> +	if (ret)
> +		goto out_free_ctrl;
> +
> +	INIT_WORK(&ctrl->delete_work, nvme_fc_del_ctrl_work);
> +	spin_lock_init(&ctrl->lock);
> +
> +	/* io queue count */
> +	ctrl->queue_count = min_t(unsigned int,
> +				opts->nr_io_queues,
> +				lport->ops->max_hw_queues);
> +	opts->nr_io_queues = ctrl->queue_count;	/* so opts
> has valid value */
> +	ctrl->queue_count++;	/* +1 for admin queue */
> +
> +	ctrl->ctrl.sqsize = opts->queue_size;
> +	ctrl->ctrl.kato = opts->kato;
> +
> +	ret = -ENOMEM;
> +	ctrl->queues = kcalloc(ctrl->queue_count, sizeof(struct
> nvme_fc_queue),
> +				GFP_KERNEL);
> +	if (!ctrl->queues)
> +		goto out_uninit_ctrl;
> +
> +	ret = nvme_fc_configure_admin_queue(ctrl);
> +	if (ret)
> +		goto out_kfree_queues;
> +
> +	/* sanity checks */
> +
> +	if (ctrl->ctrl.ioccsz != 4) {

Slightly confused, the spec says the minimum value that may be
specified is 4.  So 4 is not a legal value for fc transport?  

My preference would be to make this

if (ctrl->ctrl.ioccsz <= 4) {

even though the spec says the minimum value for ioccsz is 4 (to catch
weird programming errors).

> +		dev_err(ctrl->ctrl.device, "ioccsz %d is not
> supported!\n",
> +				ctrl->ctrl.ioccsz);
> +		goto out_remove_admin_queue;
> +	}
> +	if (ctrl->ctrl.iorcsz != 1) {

dido here, so the fc transport does not support the minimum value the
spec says, 1?

> +		dev_err(ctrl->ctrl.device, "iorcsz %d is not
> supported!\n",
> +				ctrl->ctrl.iorcsz);
> +		goto out_remove_admin_queue;
> +	}
> +	if (ctrl->ctrl.icdoff) {
> +		dev_err(ctrl->ctrl.device, "icdoff %d is not
> supported!\n",
> +				ctrl->ctrl.icdoff);
> +		goto out_remove_admin_queue;
> +	}
> +
> +	if (opts->queue_size > ctrl->ctrl.maxcmd) {
> +		/* warn if maxcmd is lower than queue_size */
> +		dev_warn(ctrl->ctrl.device,
> +			"queue_size %zu > ctrl maxcmd %u, clamping
> down\n",
> +			opts->queue_size, ctrl->ctrl.maxcmd);
> +		opts->queue_size = ctrl->ctrl.maxcmd;
> +	}
> +
> +	ret = nvme_fc_init_aen_ops(ctrl);
> +	if (ret)
> +		goto out_exit_aen_ops;
> +
> +	if (ctrl->queue_count > 1) {
> +		ret = nvme_fc_create_io_queues(ctrl);
> +		if (ret)
> +			goto out_exit_aen_ops;
> +	}
> +
> +	changed = nvme_change_ctrl_state(&ctrl->ctrl,
> NVME_CTRL_LIVE);
> +	WARN_ON_ONCE(!changed);
> +
> +	dev_info(ctrl->ctrl.device,
> +		"NVME-FC[%d.%d]: new ctrl: NQN \"%s\" (%p)\n",
> +		ctrl->l_id, ctrl->r_id, ctrl->ctrl.opts->subsysnqn,
> &ctrl);
> +
> +	kref_get(&ctrl->ctrl.kref);
> +
> +	mutex_lock(&nvme_fc_ctrl_mutex);
> +	list_add_tail(&ctrl->ctrl_list, &nvme_fc_ctrl_list);
> +	mutex_unlock(&nvme_fc_ctrl_mutex);
> +
> +	if (opts->nr_io_queues) {
> +		nvme_queue_scan(&ctrl->ctrl);
> +		nvme_queue_async_events(&ctrl->ctrl);
> +	}
> +
> +	return &ctrl->ctrl;
> +
> +out_exit_aen_ops:
> +	nvme_fc_exit_aen_ops(ctrl);
> +out_remove_admin_queue:
> +	nvme_fc_destroy_admin_queue(ctrl);
> +out_kfree_queues:
> +	kfree(ctrl->queues);
> +out_uninit_ctrl:
> +	nvme_uninit_ctrl(&ctrl->ctrl);
> +	nvme_put_ctrl(&ctrl->ctrl);
> +	if (ret > 0)
> +		ret = -EIO;
> +	return ERR_PTR(ret);
> +out_free_ctrl:
> +	kfree(ctrl);
> +	return ERR_PTR(ret);
> +}

whew...I'll try to get to patch 4 and 5 soon...

Jay

