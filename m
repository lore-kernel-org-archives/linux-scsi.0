From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] FC pass through support - revised III
Date: Tue, 11 Nov 2008 18:41:49 +0900
Message-ID: <20081111184216Q.fujita.tomonori@lab.ntt.co.jp>
References: <B125BA56-8293-4C42-AEBC-0C0DCAC365D0@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46523 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbYKKJmO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 04:42:14 -0500
In-Reply-To: <B125BA56-8293-4C42-AEBC-0C0DCAC365D0@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

On Fri, 31 Oct 2008 08:34:47 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> Attachment is also available at the bottom.
> ---
>  From 4c6fc04a25afd6dd495975434e9732ede4a1bae1 Mon Sep 17 00:00:00 2001
> From: root <root@linux-atl-00.qlogic.com>
> Date: Fri, 31 Oct 2008 08:15:56 -0700
> Subject: [PATCH] qla2xxx: FC pass through support
> 
> This patch will add FC passs through support.
> With this patch, the driver support,
> - ELS (Extended Link Services)
> - FC-CT (Generic Services)
> 
> Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c |  253 ++++++++++++++++++++++++++++++ 
> +++++++++
>   drivers/scsi/qla2xxx/qla_def.h  |    5 +
>   drivers/scsi/qla2xxx/qla_fw.h   |   35 ++++++
>   drivers/scsi/qla2xxx/qla_gbl.h  |    4 +
>   drivers/scsi/qla2xxx/qla_gs.c   |    2 +-
>   drivers/scsi/qla2xxx/qla_init.c |   11 ++
>   drivers/scsi/qla2xxx/qla_iocb.c |    9 +-
>   drivers/scsi/qla2xxx/qla_isr.c  |   68 +++++++++++
>   8 files changed, 380 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/ 
> qla_attr.c
> index b223842..945c840 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1257,6 +1257,253 @@ qla24xx_vport_disable(struct fc_vport  
> *fc_vport, bool disable)
>   	return 0;
>   }
> 
> +static int
> +qla2x00_execute_fc_service(struct fc_service *service)
> +{
> +	struct fc_rport *rport = service->rport;
> +	fc_port_t *fcport = *(fc_port_t **) rport->dd_data;
> +	struct Scsi_Host *host = rport_to_shost(rport);
> +	scsi_qla_host_t *vha = shost_priv(host);
> +	struct qla_hw_data *ha = vha->hw;
> +	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
> +	struct req_que *req = ha->req;
> +	struct els_entry_24xx *els_iocb;
> +	struct ct_entry_24xx *ct_iocb;
> +	request_t *iocb;
> +	srb_t *sp;
> +	unsigned long flags;
> +	uint32_t  handle;
> +	int  index;
> +	int  req_sg_cnt, rsp_sg_cnt;
> +	uint8_t  els_pkt[20];
> +	size_t   copy_size;
> +	uint16_t avail_dsds;
> +	uint32_t *cur_dsd;
> +	struct scatterlist *sg;
> +
> +	/* At this time, pass throug supported by 4Gb or higher */
> +	if (!IS_FWI2_CAPABLE(ha))
> +		goto pt_error0;
> +
> +	if (rport->port_state != FC_PORTSTATE_ONLINE || !fcport)
> +		goto pt_error0;
> +
> +	if ((service->srv_request->request_type != FC_FRAME_TYPE_ELS) &&
> +	    (service->srv_request->request_type != FC_FRAME_TYPE_FC_CT))
> +		goto pt_error0;
> +
> +	/* ELS doesn't support multiple SG */
> +	if ((service->srv_request->request_type == FC_FRAME_TYPE_ELS) &&
> +	    (service->req_sg_cnt > 1 || service->rsp_sg_cnt > 1)) {
> +		printk(KERN_WARNING "ERROR: multiple SG of request/response "
> +		    "[%u/%u]  are not supported for ELS services\n",
> +		    service->req_sg_cnt, service->rsp_sg_cnt);
> +		service->srv_reply.status = FC_SERVICE_UNSUPPORTED;
> +		goto pt_error0;
> +	}
> +
> +	sp = mempool_alloc(ha->srb_mempool, GFP_ATOMIC);
> +	if (!sp)
> +		goto pt_error0;
> +
> +	sp->vha = vha;
> +	sp->fcport = fcport;
> +	sp->cmd = (struct scsi_cmnd *)service;
> +	sp->flags = SRB_ELS_CT;
> +
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
> +	iocb = qla2x00_req_pkt(base_vha);
> +	if (iocb == NULL) {
> +		qla_printk(KERN_WARNING, ha,
> +		    "Passthru request failed to get request packet\n");
> +		goto pt_error1;
> +	}
> +
> +	req_sg_cnt = dma_map_sg(&ha->pdev->dev, service->sg_req,
> +	    service->req_sg_cnt, DMA_TO_DEVICE);
> +	if (!req_sg_cnt)
> +		goto pt_error1;
> +	rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, service->sg_rsp,
> +	    service->rsp_sg_cnt, DMA_FROM_DEVICE);
> +	if (!rsp_sg_cnt)
> +		goto pt_error2;
> +
> +	copy_size = sg_copy_to_buffer(service->sg_req, req_sg_cnt,
> +	    els_pkt, 20);

You need to use service->sg_rsp instead of req_sg_cnt here.

sg_copy_to_buffer takes the number entry of scatter gather. dma_map_sg
returns the number of physical segments mapped. They could be
different (when IOMMU merges the entries).


> +	if (!copy_size)
> +		goto pt_error3;
> +
> +	/* Check for room in outstanding command list. */
> +	handle = req->current_outstanding_cmd;
> +	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
> +		handle++;
> +		if (handle == MAX_OUTSTANDING_COMMANDS)
> +			handle = 1;
> +		if (!req->outstanding_cmds[handle])
> +			break;
> +	}

Hmm, needs to check the index overflow here?
