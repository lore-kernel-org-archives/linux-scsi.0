From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/5] qla2xxx: Add multiple queue pair functionality.
Date: Thu, 1 Dec 2016 09:39:09 +0100
Message-ID: <118f1092-d945-d170-31dd-fd25ef0105c4@suse.de>
References: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
 <1480537497-16429-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932318AbcLAIjL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Dec 2016 03:39:11 -0500
In-Reply-To: <1480537497-16429-4-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2016 09:24 PM, Himanshu Madhani wrote:
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
>  drivers/scsi/qla2xxx/qla_def.h    | 114 +++++++++--
>  drivers/scsi/qla2xxx/qla_gbl.h    |  34 +++-
>  drivers/scsi/qla2xxx/qla_init.c   |  14 +-
>  drivers/scsi/qla2xxx/qla_inline.h |  30 +++
>  drivers/scsi/qla2xxx/qla_iocb.c   |  56 ++----
>  drivers/scsi/qla2xxx/qla_isr.c    | 109 +++++------
>  drivers/scsi/qla2xxx/qla_mbx.c    |  44 +++--
>  drivers/scsi/qla2xxx/qla_mid.c    | 116 +++++------
>  drivers/scsi/qla2xxx/qla_mq.c     | 279 ++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_os.c     | 235 +++++++++++-----------
>  drivers/scsi/qla2xxx/qla_target.c |   4 +
>  drivers/scsi/qla2xxx/qla_top.c    |  95 +++++++++
>  16 files changed, 1230 insertions(+), 341 deletions(-)
>  create mode 100644 drivers/scsi/qla2xxx/qla_bottom.c
>  create mode 100644 drivers/scsi/qla2xxx/qla_mq.c
>  create mode 100644 drivers/scsi/qla2xxx/qla_top.c
> 
[ .. ]
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
This will kill all performance benefits; having a single array to handle
all outstanding commands inevitably leads to cache trashing.

[ .. ]
> @@ -812,23 +817,27 @@ static void qla_do_work(struct work_struct *work)
>  	if (!IS_MSIX_NACK_CAPABLE(ha))
>  		options |= BIT_6;
>  
> +	/* Set option to indicate response queue creation */
> +	options |= BIT_1;
> +

Is this bit supported on all firmware releases?
Do we need an updated firmware for this?


[ .. ]
> +		/* Create request queue */
> +		req_id = qla25xx_create_req_que(ha, 0, vp_idx, 0, rsp_id, qos);
> +		if (!req_id) {
> +			ql_log(ql_log_warn, vha, 0x0186,
> +			    "Failed to create request queue.\n");
> +			goto fail_req;
> +		}
> +
> +		qpair->req = ha->req_q_map[req_id];
> +		qpair->rsp->req = qpair->req;
> +
> +		if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
> +			if (ha->fw_attributes & BIT_4)
> +				qpair->difdix_supported = 1;
> +		}
> +
> +		qpair->srb_mempool = mempool_create_slab_pool(SRB_MIN_REQ, srb_cachep);
> +		if (!qpair->srb_mempool) {
> +			ql_log(ql_log_warn, vha, 0x0191,
> +			    "Failed to create srb mempool for qpair %d\n",
> +			    qpair->id);
> +			goto fail_mempool;
> +		}
> +
> +		/* Set CPU affinity hint */
> +		if (cpu_mask)
> +			qla2xxx_set_affinity_hint(qpair, cpu_mask);
> +
> +		if (cpu_mask) {
> +			cpumask_copy(&qpair->cpu_mask, cpu_mask);
> +			for_each_cpu(cpu_id, cpu_mask) {
> +				hint = per_cpu_ptr(vha->qps_hint, cpu_id);
> +				hint->change_in_progress = 1;
> +				hint->qp = qpair;
> +				hint->change_in_progress = 0;
> +			}
> +		}
> +
Please use the irq-affinity rework from Christoph Hellwig here; we
really shouldn't introduce any home-grown interrupt affinity settings
anymore.


Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
