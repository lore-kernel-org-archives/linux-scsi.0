From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] nvme-fabrics: Add host FC transport support
Date: Thu, 11 Aug 2016 14:16:52 -0700
Message-ID: <20160811211652.GF18013@infradead.org>
References: <5792b91d.bp8ih+rK5Jet+Cpn%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52011 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbcHKVQx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 17:16:53 -0400
Content-Disposition: inline
In-Reply-To: <5792b91d.bp8ih+rK5Jet+Cpn%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

This looks mostly fine, a few nitpicks below:

> +config NVME_FC
> +	tristate "NVM Express over Fabrics FC host driver"
> +	depends on BLK_DEV_NVME

This should be

	select NVME_CORE

instead.  The existing RDMA and loop drivers also get this wrong,
but I'll sned a patch to fix it up.

> +	select NVME_FABRICS
> +	select SG_POOL
> +	help
> +	  This provides support for the NVMe over Fabrics protocol using
> +	  the FC transport.  This allows you to use remote block devices
> +	  exported using the NVMe protocol set.
> +
> +	  To configure a NVMe over Fabrics controller use the nvme-cli tool
> +	  from https://github.com/linux-nvme/nvme-cli.

Are you going to send a FC support patch for nvme-cli as well?

> +	/* TODO: better to use dma_map_page() ?*/
> +	lsreq->rqstdma = dma_map_single(ctrl->dev, lsreq->rqstaddr,
> +				  (lsreq->rqstlen + lsreq->rsplen),
> +				  DMA_BIDIRECTIONAL);

Either one is fine, so no need to the TODO comment, please remove
it and all the other similar ones.

Also while I'm at it: no need for the braces around the
"lsreq->rqstlen + lsreq->rsplen".

> +	assoc_rqst->assoc_cmd.ersp_ratio = cpu_to_be16(ersp_ratio);
> +	assoc_rqst->assoc_cmd.sqsize = cpu_to_be16(qsize);
> +	/* TODO:
> +	 * assoc_rqst->assoc_cmd.cntlid = cpu_to_be16(?);
> +	 * strncpy(assoc_rqst->assoc_cmd.hostid, ?,
> +	 *	min(FCNVME_ASSOC_HOSTID_LEN, NVMF_NQN_SIZE));
> +	 * strncpy(assoc_rqst->assoc_cmd.hostnqn, ?,
> +	 *	min(FCNVME_ASSOC_HOSTNQN_LEN, NVMF_NQN_SIZE];
> +	 */

What is the problem with filling all these out based on the information
in the nvme_host structure?

> +nvme_fc_free_nvme_ctrl(struct nvme_ctrl *nctrl)
> +{
> +	struct nvme_fc_ctrl *ctrl = to_fc_ctrl(nctrl);
> +
> +	/*
> +	 * if we've already started down this path, controller
> +	 * will already be unlinked.
> +	 */
> +	if (list_empty(&ctrl->ctrl_list))
> +		goto free_ctrl;
> +
> +	mutex_lock(&nvme_fc_ctrl_mutex);
> +	list_del(&ctrl->ctrl_list);
> +	mutex_unlock(&nvme_fc_ctrl_mutex);
> +
> +	if (nctrl->tagset) {
> +		blk_cleanup_queue(ctrl->ctrl.connect_q);
> +		blk_mq_free_tag_set(&ctrl->tag_set);
> +	}

This probably needs to be moved, similar to the patch Sagi just
did for RDMA.  In general it might be a good idea to look at the
various recent RDMA changes and check if they need to be brought over.

> +	/*
> +	 * TODO: blk_integrity_rq(rq)  for DIX
> +	 */

We'll hopefully be able to just move the DIX handling to common code.
Any help appreciated..

> +	/* find the host and remote ports to connect together */
> +	spin_lock_irqsave(&nvme_fc_lock, flags);
> +	list_for_each_entry(lport, &nvme_fc_lport_list, port_list) {
> +		if ((lport->localport.fabric_name != laddr.fab) ||
> +		    (lport->localport.node_name != laddr.nn) ||
> +		    (lport->localport.port_name != laddr.pn))
> +			continue;
> +
> +		list_for_each_entry(rport, &lport->endp_list, endp_list) {
> +			if ((rport->remoteport.node_name != raddr.nn) ||
> +			    (rport->remoteport.port_name != raddr.pn))
> +				continue;
> +
> +			spin_unlock_irqrestore(&nvme_fc_lock, flags);
> +
> +			return __nvme_fc_create_ctrl(dev, opts, lport, rport);
> +		}
> +	}
> +	spin_unlock_irqrestore(&nvme_fc_lock, flags);

This seems to miss reference counting on the lport and rport structure.

> +	/* release topology elements
> +	 * TODO: This is broken: as ctrl delete is async - need to tie
> +	 *  final topology delete to last controller detach
> +	 */
> +	__nvme_fc_free_ports();

It would be good to sort this out before merging.
