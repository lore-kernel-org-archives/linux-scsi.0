From: J Freyensee <james_p_freyensee@linux.intel.com>
Subject: Re: [PATCH 5/5] nvme-fabrics: Add FC LLDD loopback driver to test
 FC host and target transport
Date: Tue, 02 Aug 2016 17:15:44 -0700
Message-ID: <1470183344.3928.54.camel@linux.intel.com>
References: <5792b91f.Lb5BdNQrSWnmgOYG%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:8369 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbcHCAUG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 20:20:06 -0400
In-Reply-To: <5792b91f.Lb5BdNQrSWnmgOYG%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Fri, 2016-07-22 at 17:23 -0700, James Smart wrote:

A couple comments.

> Add FC LLDD loopback driver to test FC host and target transport
> within
> nvme-fabrics
> 
> To aid in the development and testing of the lower-level api of the
> FC
> transport, this loopback driver has been created to act as if it were
> a
> FC hba driver supporting both the host interfaces as well as the
> target
> interfaces with the nvme FC transport.
> 
> 
> Signed-off-by: James Smart <james.smart@broadcom.com>
> 
> ---

snip...

>  +int
> +fcloop_fcp_op(struct nvmet_fc_target_port *tgtport,
> +			struct nvmefc_tgt_fcp_req *tgt_fcpreq)
> +{
> +	struct fcloop_fcpreq *tfcp_req =
> +		container_of(tgt_fcpreq, struct fcloop_fcpreq,
> tgt_fcp_req);
> +	struct nvmefc_fcp_req *fcpreq = tfcp_req->fcpreq;
> +	u32 rsplen = 0, xfrlen = 0;
> +	int fcp_err = 0;
> +	u8 op = tgt_fcpreq->op;
> +
> +	switch (op) {
> +	case NVMET_FCOP_WRITEDATA:
> +		xfrlen = tgt_fcpreq->transfer_length;
> +		fcloop_fcp_copy_data(op, tgt_fcpreq->sg, fcpreq
> ->first_sgl,
> +					tgt_fcpreq->offset, xfrlen);
> +		fcpreq->transferred_length += xfrlen;
> +		break;
> +
> +	case NVMET_FCOP_READDATA:
> +	case NVMET_FCOP_READDATA_RSP:
> +		xfrlen = tgt_fcpreq->transfer_length;
> +		fcloop_fcp_copy_data(op, tgt_fcpreq->sg, fcpreq
> ->first_sgl,
> +					tgt_fcpreq->offset, xfrlen);
> +		fcpreq->transferred_length += xfrlen;
> +		if (op == NVMET_FCOP_READDATA)
> +			break;
> +
> +		/* Fall-Thru to RSP handling */
> +
> +	case NVMET_FCOP_RSP:
> +		rsplen = ((fcpreq->rsplen < tgt_fcpreq->rsplen) ?
> +				fcpreq->rsplen : tgt_fcpreq
> ->rsplen);
> +		memcpy(fcpreq->rspaddr, tgt_fcpreq->rspaddr,
> rsplen);
> +		if (rsplen < tgt_fcpreq->rsplen)
> +			fcp_err = -E2BIG;
> +		fcpreq->rcv_rsplen = rsplen;
> +		fcpreq->status = 0;
> +		tfcp_req->status = 0;
> +		break;
> +
> +	case NVMET_FCOP_ABORT:
> +		tfcp_req->status = NVME_SC_FC_TRANSPORT_ABORTED;
> +		break;
> +
> +	default:
> +		fcp_err = -EINVAL;
> +		break;
> +	}
> +
> +	tgt_fcpreq->transferred_length = xfrlen;
> +	tgt_fcpreq->fcp_error = fcp_err;
> +	tgt_fcpreq->done(tgt_fcpreq);
> +
> +	if ((!fcp_err) && (op == NVMET_FCOP_RSP ||
> +			op == NVMET_FCOP_READDATA_RSP ||
> +			op == NVMET_FCOP_ABORT))
> +		schedule_work(&tfcp_req->work);
> +
> +	return 0;

if this function returns an 'int', why would it always return 0 and not
the fcp_err values (if there is an error)?

> +}
> +
> +void
> +fcloop_ls_abort(struct nvme_fc_local_port *localport,
> +			struct nvme_fc_remote_port *remoteport,
> +				struct nvmefc_ls_req *lsreq)
> +{
> +}
> +
> +void
> +fcloop_fcp_abort(struct nvme_fc_local_port *localport,
> +			struct nvme_fc_remote_port *remoteport,
> +			void *hw_queue_handle,
> +			struct nvmefc_fcp_req *fcpreq)
> +{
> +}
> +
> +
> +struct nvme_fc_port_template fctemplate = {
> +	.create_queue	= fcloop_create_queue,
> +	.delete_queue	= fcloop_delete_queue,
> +	.ls_req		= fcloop_ls_req,
> +	.fcp_io		= fcloop_fcp_req,
> +	.ls_abort	= fcloop_ls_abort,
> +	.fcp_abort	= fcloop_fcp_abort,
> +
> +	.max_hw_queues	= 1,
> +	.max_sgl_segments = 256,
> +	.max_dif_sgl_segments = 256,
> +	.dma_boundary = 0xFFFFFFFF,

Between here and "struct nvmet_fc_target_template tgttemplate" they are
assigning the same magic values to the same variable names, so why not
have these values as #defines for a tad easier maintainability?

> +	/* sizes of additional private data for data structures */
> +	.local_priv_sz	= sizeof(struct fcloop_lport),
> +	.remote_priv_sz	= sizeof(struct fcloop_rport),
> +	.lsrqst_priv_sz = sizeof(struct fcloop_lsreq),
> +	.fcprqst_priv_sz = sizeof(struct fcloop_fcpreq),
> +};
> +
> +struct nvmet_fc_target_template tgttemplate = {
> +	.xmt_ls_rsp	= fcloop_xmt_ls_rsp,
> +	.fcp_op		= fcloop_fcp_op,
> +
> +	.max_hw_queues	= 1,
> +	.max_sgl_segments = 256,
> +	.max_dif_sgl_segments = 256,
> +	.dma_boundary = 0xFFFFFFFF,
> +

see above comment.

> +	/* optional features */
> +	.target_features = NVMET_FCTGTFEAT_READDATA_RSP,
> +
> +	/* sizes of additional private data for data structures */
> +	.target_priv_sz = sizeof(struct fcloop_tgtport),
> +};
> +
> +static ssize_t
> +fcloop_create_local_port(struct device *dev, struct device_attribute
> *attr,
> +		const char *buf, size_t count)
> +{
> +	struct nvme_fc_port_info pinfo;
> +	struct fcloop_ctrl_options *opts;
> +	struct nvme_fc_local_port *localport;
> +	struct fcloop_lport *lport;
> +	int ret;
> +
> +	opts = kzalloc(sizeof(*opts), GFP_KERNEL);
> +	if (!opts)
> +		return -ENOMEM;
> +
> +	ret = fcloop_parse_options(opts, buf);
> +	if (ret)
> +		goto out_free_opts;
> +
> +	/* everything there ? */
> +	if ((opts->mask & LPORT_OPTS) != LPORT_OPTS) {
> +		ret = -EINVAL;
> +		goto out_free_opts;
> +	}
> +
> +	pinfo.fabric_name = opts->fabric;
> +	pinfo.node_name = opts->wwnn;
> +	pinfo.port_name = opts->wwpn;
> +	pinfo.port_role = opts->roles;
> +	pinfo.port_id = opts->fcaddr;
> +
> +	ret = nvme_fc_register_localport(&pinfo, &fctemplate, NULL,
> &localport);
> +	if (!ret) {
> +		/* success */
> +		lport = localport->private;
> +		lport->localport = localport;
> +		INIT_LIST_HEAD(&lport->list);
> +		INIT_LIST_HEAD(&lport->rport_list);
> +		list_add_tail(&lport->list, &fcloop_lports);
> +
> +		/* mark all of the input buffer consumed */
> +		ret = count;
> +	}
> +
> +out_free_opts:
> +	kfree(opts);
> +	return ret;
> +}
> +
> +static int __delete_local_port(struct fcloop_lport *lport)
> +{
> +	int ret;
> +
> +	if (!list_empty(&lport->rport_list))
> +		return -EBUSY;
> +
> +	list_del(&lport->list);
> +

Is a mutex or locking mechanism not needed here for this list?

> +	ret = nvme_fc_unregister_localport(lport->localport);
> +
> +	return ret;
> +}
> +
> +static ssize_t
> +fcloop_delete_local_port(struct device *dev, struct device_attribute
> *attr,
> +		const char *buf, size_t count)
> +{
> +	struct fcloop_lport *lport, *lnext;
> +	u64 fabric, portname;
> +	int ret;
> +
> +	ret = fcloop_parse_nm_options(dev, &fabric, &portname, buf);
> +	if (ret)
> +		return ret;
> +
> +	list_for_each_entry_safe(lport, lnext, &fcloop_lports, list)
> {
> +		if ((lport->localport->fabric_name == fabric) &&
> +		    (lport->localport->port_name == portname)) {
> +			break;
> +		}
> +	}
> +	if (is_end_of_list(lport, &fcloop_lports, list))
> +		return -ENOENT;
> +
> +	ret = __delete_local_port(lport);
> +
> +	if (!ret)
> +		return count;
> +
> +	return ret;
> +}
> +
> +static ssize_t
> +fcloop_create_remote_port(struct device *dev, struct
> device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	struct fcloop_ctrl_options *opts;
> +	struct fcloop_lport *lport, *lnext;
> +	struct nvme_fc_remote_port *remoteport;
> +	struct fcloop_rport *rport;
> +	struct nvme_fc_port_info pinfo;
> +	struct nvmet_fc_port_info tinfo;
> +	int ret;
> +
> +	opts = kzalloc(sizeof(*opts), GFP_KERNEL);
> +	if (!opts)
> +		return -ENOMEM;
> +
> +	ret = fcloop_parse_options(opts, buf);
> +	if (ret)
> +		goto out_free_opts;
> +
> +	/* everything there ? */
> +	if ((opts->mask & RPORT_OPTS) != RPORT_OPTS) {
> +		ret = -EINVAL;
> +		goto out_free_opts;
> +	}
> +
> +	pinfo.fabric_name = tinfo.fabric_name = opts->fabric;
> +	pinfo.node_name = tinfo.node_name = opts->wwnn;
> +	pinfo.port_name = tinfo.port_name = opts->wwpn;
> +	pinfo.port_role = opts->roles;
> +	pinfo.port_id = tinfo.port_id = opts->fcaddr;
> +
> +	list_for_each_entry_safe(lport, lnext, &fcloop_lports, list)
> {
> +		if (lport->localport->fabric_name == opts->fabric)
> +			break;
> +	}
> +	if (is_end_of_list(lport, &fcloop_lports, list)) {
> +		ret = -ENOENT;
> +		goto out_free_opts;
> +	}
> +
> +	ret = nvme_fc_register_remoteport(lport->localport, &pinfo,
> +					&remoteport);
> +	if (ret)
> +		goto out_free_opts;
> +
> +	/* success */
> +	rport = remoteport->private;
> +	rport->remoteport = remoteport;
> +	INIT_LIST_HEAD(&rport->list);
> +	list_add_tail(&rport->list, &lport->rport_list);

is there not a mutex or locking mechanism needed when manipulating this
list?

> +
> +	/* tie into nvme target side */
> +	ret = nvmet_fc_register_targetport(&tinfo, &tgttemplate,
> NULL,
> +					&rport->targetport);
> +	if (ret) {
> +		list_del(&rport->list);
> +		(void)nvme_fc_unregister_remoteport(remoteport);
> +	} else {
> +		struct fcloop_tgtport *tport;
> +
> +		tport = rport->targetport->private;
> +		tport->rport = rport;
> +		tport->lport = lport;
> +		tport->tgtport = rport->targetport;
> +
> +		/* mark all of the input buffer consumed */
> +		ret = count;
> +	}
> +
> +out_free_opts:
> +	kfree(opts);
> +	return ret;
> +}
> +

Thanks,
J

