From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 4/6] qla2xxx: Add multiple queue pair functionality.
Date: Mon, 5 Dec 2016 08:38:34 +0100
Message-ID: <64bf8c12-c086-2531-8510-27a95f8f0ef1@suse.de>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-5-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59441 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750998AbcLEHj2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Dec 2016 02:39:28 -0500
In-Reply-To: <1480715097-13611-5-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 12/02/2016 10:44 PM, Himanshu Madhani wrote:
> From: Michael Hernandez <michael.hernandez@cavium.com>
> 
> Replaced existing multiple queue functionality with framework
> that allows for the creation of pairs of request and response queues,
> either at start of day or dynamically.
> 
> Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
> Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/Makefile     |   3 +-
>  drivers/scsi/qla2xxx/qla_attr.c   |  36 ++--
>  drivers/scsi/qla2xxx/qla_bottom.c | 398 ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_dbg.c    |   4 +-
>  drivers/scsi/qla2xxx/qla_def.h    | 105 ++++++++--
>  drivers/scsi/qla2xxx/qla_gbl.h    |  32 ++-
>  drivers/scsi/qla2xxx/qla_init.c   |  14 +-
>  drivers/scsi/qla2xxx/qla_inline.h |  30 +++
>  drivers/scsi/qla2xxx/qla_iocb.c   |  56 ++----
>  drivers/scsi/qla2xxx/qla_isr.c    | 101 +++++-----
>  drivers/scsi/qla2xxx/qla_mbx.c    |  33 ++--
>  drivers/scsi/qla2xxx/qla_mid.c    | 116 +++++------
>  drivers/scsi/qla2xxx/qla_mq.c     | 236 ++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_os.c     | 237 +++++++++++------------
>  drivers/scsi/qla2xxx/qla_top.c    |  95 +++++++++
>  15 files changed, 1153 insertions(+), 343 deletions(-)
>  create mode 100644 drivers/scsi/qla2xxx/qla_bottom.c
>  create mode 100644 drivers/scsi/qla2xxx/qla_mq.c
>  create mode 100644 drivers/scsi/qla2xxx/qla_top.c
> 
> diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
> index 44def6b..ca04260 100644
> --- a/drivers/scsi/qla2xxx/Makefile
> +++ b/drivers/scsi/qla2xxx/Makefile
> @@ -1,6 +1,7 @@
>  qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
>  		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o \
> -		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o
> +		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o qla_mq.o \
> +		qla_top.o qla_bottom.o
>  
>  obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
>  obj-$(CONFIG_TCM_QLA2XXX) += tcm_qla2xxx.o
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index fe7469c..47eb4d5 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1988,9 +1988,9 @@ struct device_attribute *qla2x00_host_attrs[] = {
>  	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
>  	scsi_qla_host_t *vha = NULL;
>  	struct qla_hw_data *ha = base_vha->hw;
> -	uint16_t options = 0;
>  	int	cnt;
>  	struct req_que *req = ha->req_q_map[0];
> +	struct qla_qpair *qpair;
>  
>  	ret = qla24xx_vport_create_req_sanity_check(fc_vport);
>  	if (ret) {
> @@ -2075,15 +2075,9 @@ struct device_attribute *qla2x00_host_attrs[] = {
>  	qlt_vport_create(vha, ha);
>  	qla24xx_vport_disable(fc_vport, disable);
>  
> -	if (ha->flags.cpu_affinity_enabled) {
> -		req = ha->req_q_map[1];
> -		ql_dbg(ql_dbg_multiq, vha, 0xc000,
> -		    "Request queue %p attached with "
> -		    "VP[%d], cpu affinity =%d\n",
> -		    req, vha->vp_idx, ha->flags.cpu_affinity_enabled);
> -		goto vport_queue;
> -	} else if (ql2xmaxqueues == 1 || !ha->npiv_info)
> +	if (!ql2xmqsupport || !ha->npiv_info)
>  		goto vport_queue;
> +
>  	/* Create a request queue in QoS mode for the vport */
>  	for (cnt = 0; cnt < ha->nvram_npiv_size; cnt++) {
>  		if (memcmp(ha->npiv_info[cnt].port_name, vha->port_name, 8) == 0
> @@ -2095,20 +2089,20 @@ struct device_attribute *qla2x00_host_attrs[] = {
>  	}
>  
>  	if (qos) {
> -		ret = qla25xx_create_req_que(ha, options, vha->vp_idx, 0, 0,
> -			qos);
> -		if (!ret)
> +		qpair = qla2xxx_create_qpair(vha, qos, vha->vp_idx);
> +		if (!qpair)
>  			ql_log(ql_log_warn, vha, 0x7084,
> -			    "Can't create request queue for VP[%d]\n",
> +			    "Can't create qpair for VP[%d]\n",
>  			    vha->vp_idx);
>  		else {
>  			ql_dbg(ql_dbg_multiq, vha, 0xc001,
> -			    "Request Que:%d Q0s: %d) created for VP[%d]\n",
> -			    ret, qos, vha->vp_idx);
> +			    "Queue pair: %d Qos: %d) created for VP[%d]\n",
> +			    qpair->id, qos, vha->vp_idx);
>  			ql_dbg(ql_dbg_user, vha, 0x7085,
> -			    "Request Que:%d Q0s: %d) created for VP[%d]\n",
> -			    ret, qos, vha->vp_idx);
> -			req = ha->req_q_map[ret];
> +			    "Queue Pair: %d Qos: %d) created for VP[%d]\n",
> +			    qpair->id, qos, vha->vp_idx);
> +			req = qpair->req;
> +			vha->qpair = qpair;
>  		}
>  	}
>  
> @@ -2162,10 +2156,10 @@ struct device_attribute *qla2x00_host_attrs[] = {
>  	clear_bit(vha->vp_idx, ha->vp_idx_map);
>  	mutex_unlock(&ha->vport_lock);
>  
> -	if (vha->req->id && !ha->flags.cpu_affinity_enabled) {
> -		if (qla25xx_delete_req_que(vha, vha->req) != QLA_SUCCESS)
> +	if (vha->qpair->vp_idx == vha->vp_idx) {
> +		if (qla2xxx_delete_qpair(vha, vha->qpair) != QLA_SUCCESS)
>  			ql_log(ql_log_warn, vha, 0x7087,
> -			    "Queue delete failed.\n");
> +			    "Queue Pair delete failed.\n");
>  	}
>  
>  	ql_log(ql_log_info, vha, 0x7088, "VP[%d] deleted.\n", id);
> diff --git a/drivers/scsi/qla2xxx/qla_bottom.c b/drivers/scsi/qla2xxx/qla_bottom.c
> new file mode 100644
> index 0000000..8bf757e
> --- /dev/null
> +++ b/drivers/scsi/qla2xxx/qla_bottom.c
> @@ -0,0 +1,398 @@
> +/*
> + * QLogic Fibre Channel HBA Driver
> + * Copyright (c)  2016 QLogic Corporation
> + *
> + * See LICENSE.qla2xxx for copyright and licensing details.
> + */
> +#include "qla_def.h"
> +
> +/**
> + * qla2xxx_start_scsi_mq() - Send a SCSI command to the ISP
> + * @sp: command to send to the ISP
> + *
> + * Returns non-zero if a failure occurred, else zero.
> + */
> +
> +static int
> +qla2xxx_start_scsi_mq(srb_t *sp)
> +{
> +	int		nseg;
> +	unsigned long   flags;
> +	uint32_t	*clr_ptr;
> +	uint32_t        index;
> +	uint32_t	handle;
> +	struct cmd_type_7 *cmd_pkt;
> +	uint16_t	cnt;
> +	uint16_t	req_cnt;
> +	uint16_t	tot_dsds;
> +	struct req_que *req = NULL;
> +	struct rsp_que *rsp = NULL;
> +	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
> +	struct scsi_qla_host *vha = sp->fcport->vha;
> +	struct qla_hw_data *ha = vha->hw;
> +	struct qla_qpair *qpair = sp->qpair;
> +
> +	/* Setup qpair pointers */
> +	rsp = qpair->rsp;
> +	req = qpair->req;
> +
> +	/* So we know we haven't pci_map'ed anything yet */
> +	tot_dsds = 0;
> +
> +	/* Send marker if required */
> +	if (vha->marker_needed != 0) {
> +		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
> +		    QLA_SUCCESS)
> +			return QLA_FUNCTION_FAILED;
> +		vha->marker_needed = 0;
> +	}
> +
> +	/* Acquire qpair specific lock */
> +	spin_lock_irqsave(&qpair->qp_lock, flags);
> +
> +	/* Check for room in outstanding command list. */
> +	handle = req->current_outstanding_cmd;
> +	for (index = 1; index < req->num_outstanding_cmds; index++) {
> +		handle++;
> +		if (handle == req->num_outstanding_cmds)
> +			handle = 1;
> +		if (!req->outstanding_cmds[handle])
> +			break;
> +	}
> +	if (index == req->num_outstanding_cmds)
> +		goto queuing_error;
> +
> +	/* Map the sg table so we have an accurate count of sg entries needed */
> +	if (scsi_sg_count(cmd)) {
> +		nseg = dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
> +		    scsi_sg_count(cmd), cmd->sc_data_direction);
> +		if (unlikely(!nseg))
> +			goto queuing_error;
> +	} else
> +		nseg = 0;
> +
> +	tot_dsds = nseg;
> +	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
> +	if (req->cnt < (req_cnt + 2)) {
> +		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> +		    RD_REG_DWORD_RELAXED(req->req_q_out);
> +		if (req->ring_index < cnt)
> +			req->cnt = cnt - req->ring_index;
> +		else
> +			req->cnt = req->length -
> +				(req->ring_index - cnt);
> +		if (req->cnt < (req_cnt + 2))
> +			goto queuing_error;
> +	}
> +
> +	/* Build command packet. */
> +	req->current_outstanding_cmd = handle;
> +	req->outstanding_cmds[handle] = sp;
> +	sp->handle = handle;
> +	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
> +	req->cnt -= req_cnt;
> +
> +	cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
> +	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
> +
> +	/* Zero out remaining portion of packet. */
> +	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
> +	clr_ptr = (uint32_t *)cmd_pkt + 2;
> +	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
> +	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
> +
> +	/* Set NPORT-ID and LUN number*/
> +	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
> +	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
> +	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
> +	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
> +	cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
> +
> +	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
> +	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
> +
> +	cmd_pkt->task = TSK_SIMPLE;
> +
> +	/* Load SCSI command packet. */
> +	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
> +	host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
> +
> +	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
> +
> +	/* Build IOCB segments */
> +	qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds, req);
> +
> +	/* Set total data segment count. */
> +	cmd_pkt->entry_count = (uint8_t)req_cnt;
> +	wmb();
> +	/* Adjust ring index. */
> +	req->ring_index++;
> +	if (req->ring_index == req->length) {
> +		req->ring_index = 0;
> +		req->ring_ptr = req->ring;
> +	} else
> +		req->ring_ptr++;
> +
> +	sp->flags |= SRB_DMA_VALID;
> +
> +	/* Set chip new ring index. */
> +	WRT_REG_DWORD(req->req_q_in, req->ring_index);
> +
> +	/* Manage unprocessed RIO/ZIO commands in response queue. */
> +	if (vha->flags.process_response_queue &&
> +		rsp->ring_ptr->signature != RESPONSE_PROCESSED)
> +		qla24xx_process_response_queue(vha, rsp);
> +
> +	spin_unlock_irqrestore(&qpair->qp_lock, flags);
> +	return QLA_SUCCESS;
> +
> +queuing_error:
> +	if (tot_dsds)
> +		scsi_dma_unmap(cmd);
> +
> +	spin_unlock_irqrestore(&qpair->qp_lock, flags);
> +
> +	return QLA_FUNCTION_FAILED;
> +}

That feels really sad; running on multiqueue yet having to take a
spinlock for submitting I/O.
Is this really necessary? What does the spinlock protect against?
If it's just the outstanding commands array: can't you introduce a 1:1
mapping between the outstanding command array index and request->tag?
That way you're protected by the block-layer tagging code, and won't
need to lock it yourself ...

[ .. ]
> @@ -1670,26 +1634,20 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
>  		    "MQIO Base=%p.\n", ha->mqiobase);
>  		/* Read MSIX vector size of the board */
>  		pci_read_config_word(ha->pdev, QLA_PCI_MSIX_CONTROL, &msix);
> -		ha->msix_count = msix;
> +		ha->msix_count = msix + 1;
>  		/* Max queues are bounded by available msix vectors */
> -		/* queue 0 uses two msix vectors */
> -		if (ql2xmultique_tag) {
> -			cpus = num_online_cpus();
> -			ha->max_rsp_queues = (ha->msix_count - 1 > cpus) ?
> -				(cpus + 1) : (ha->msix_count - 1);
> -			ha->max_req_queues = 2;
> -		} else if (ql2xmaxqueues > 1) {
> -			ha->max_req_queues = ql2xmaxqueues > QLA_MQ_SIZE ?
> -			    QLA_MQ_SIZE : ql2xmaxqueues;
> -			ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc008,
> -			    "QoS mode set, max no of request queues:%d.\n",
> -			    ha->max_req_queues);
> -			ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0019,
> -			    "QoS mode set, max no of request queues:%d.\n",
> -			    ha->max_req_queues);
> -		}
> +		/* MB interrupt uses 1 vector */
> +		ha->max_req_queues = ha->msix_count - 1;
> +		ha->max_rsp_queues = ha->max_req_queues;
> +		/* Queue pairs is the max value minus the base queue pair */
> +		ha->max_qpairs = ha->max_rsp_queues - 1;
> +		ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc00e,
> +		    "Max no of queues pairs: %d.\n", ha->max_qpairs);
> +		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0188,
> +		    "Max no of queues pairs: %d.\n", ha->max_qpairs);
> +
>  		ql_log_pci(ql_log_info, ha->pdev, 0x001a,
> -		    "MSI-X vector count: %d.\n", msix);
> +		    "MSI-X vector count: %d.\n", ha->msix_count);
>  	} else
>  		ql_log_pci(ql_log_info, ha->pdev, 0x001b,
>  		    "BAR 3 not enabled.\n");
Have you modified the irq affinity for this?
Typically the irq-affinity changes will treat all vectors identically,
and spread them out across the available CPUS.
But with this layout vector '0' apparently is the MB irq vector, and as
such should _not_ be treated like the others wrt irq affinity, but
rather left alone.
Christoph put in some changes for that, but they'll be coming in via the
tip tree, so not sure if Martin has already taken them in.
But in either way, you should be using them to get the irq affinity
layout correctly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
