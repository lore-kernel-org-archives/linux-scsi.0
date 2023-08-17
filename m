Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E823C27C7A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 06:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348254AbjHQGcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 02:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348252AbjHQGbs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 02:31:48 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8DAB8
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2023 23:31:46 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37H40Zh6017037;
        Wed, 16 Aug 2023 23:31:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=aKwfoPmiqi2hjUYfJhAHiyHVqEclb85vO4jS2yN7+WI=;
 b=LQXnXBw6DSYOxw+8c7T0heKd31Eej7zU9oMFedGUHUikr/TaaHPF3IBwjxSQ6t785gHh
 O5G+Z/HWK/V4KTiggGNYYIhcB29zxc5v4W1N5RDNkI91Q7mHAN4B+C2NhIbybYRNgzGZ
 o1BdT9UeFFa12FQ+EE+Hw7D+XLzq6lLRg5vop40KBZv79zIFeAkg2B9Sz8RWd2tBl6yX
 93dnFUaryr4FROHU4l/lNCg0/tdgGlz4/OYEdK4oZ8ySnr2yp0TsCtKvZ64zxEkSFyL4
 Enp6agzrvHroshfb+pG8Oz/zrRVlJKqIPfwKzey5cA7qkowNnFD9A7KaUQ/JR6ZN0dB3 Yw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3sgptkvssd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 23:31:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 16 Aug
 2023 23:31:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 16 Aug 2023 23:31:41 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 02BF83F7083;
        Wed, 16 Aug 2023 23:31:38 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 2/2] qla2xxx: allow 32 bytes CDB
Date:   Thu, 17 Aug 2023 12:01:32 +0530
Message-ID: <20230817063132.21900-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230817063132.21900-1-njavali@marvell.com>
References: <20230817063132.21900-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wpeLX5Px_B5VHUoe-xYLkiuzhP9CTT17
X-Proofpoint-GUID: wpeLX5Px_B5VHUoe-xYLkiuzhP9CTT17
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_03,2023-08-15_02,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

System crash when 32 bytes CDB was sent to a non T10-PI disk,

[  177.143279]  ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xxx]
[  177.149165]  ? internal_add_timer+0x42/0x70
[  177.153372]  qla2xxx_mqueuecommand+0x207/0x2b0 [qla2xxx]
[  177.158730]  scsi_queue_rq+0x2b7/0xc00
[  177.162501]  blk_mq_dispatch_rq_list+0x3ea/0x7e0

Current code attempt to use CRC IOCB to send the command but failed.
Instead, type 6 IOCB should be used to send the IO.

Clone existing type 6 IOCB code with addition of MQ support
to allow 32 bytes CDB to go through.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Cc: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
v2:
- remove extra lines and fix comments format
- Add Reviewed-by tag

 drivers/scsi/qla2xxx/qla_iocb.c | 269 ++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nx.h   |   4 +-
 2 files changed, 272 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 5014d0db7242..7fbd917f6e1f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -11,6 +11,7 @@
 
 #include <scsi/scsi_tcq.h>
 
+static int qla_start_scsi_type6(srb_t *sp);
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
  * @sp: SCSI command
@@ -1721,6 +1722,8 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	if (scsi_get_prot_op(cmd) == SCSI_PROT_NORMAL) {
 		if (cmd->cmd_len <= 16)
 			return qla24xx_start_scsi(sp);
+		else
+			return qla_start_scsi_type6(sp);
 	}
 
 	/* Setup device pointers. */
@@ -2100,6 +2103,8 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	if (scsi_get_prot_op(cmd) == SCSI_PROT_NORMAL) {
 		if (cmd->cmd_len <= 16)
 			return qla2xxx_start_scsi_mq(sp);
+		else
+			return qla_start_scsi_type6(sp);
 	}
 
 	spin_lock_irqsave(&qpair->qp_lock, flags);
@@ -4204,3 +4209,267 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 
 	return rval;
 }
+
+/**
+ * qla_start_scsi_type6() - Send a SCSI command to the ISP
+ * @sp: command to send to the ISP
+ *
+ * Returns non-zero if a failure occurred, else zero.
+ */
+static int
+qla_start_scsi_type6(srb_t *sp)
+{
+	int		nseg;
+	unsigned long   flags;
+	uint32_t	*clr_ptr;
+	uint32_t	handle;
+	struct cmd_type_6 *cmd_pkt;
+	uint16_t	cnt;
+	uint16_t	req_cnt;
+	uint16_t	tot_dsds;
+	struct req_que *req = NULL;
+	struct rsp_que *rsp;
+	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
+	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_qpair *qpair = sp->qpair;
+	uint16_t more_dsd_lists = 0;
+	struct dsd_dma *dsd_ptr;
+	uint16_t i;
+	__be32 *fcp_dl;
+	uint8_t additional_cdb_len;
+	struct ct6_dsd *ctx;
+
+	/* Acquire qpair specific lock */
+	spin_lock_irqsave(&qpair->qp_lock, flags);
+
+	/* Setup qpair pointers */
+	req = qpair->req;
+	rsp = qpair->rsp;
+
+	/* So we know we haven't pci_map'ed anything yet */
+	tot_dsds = 0;
+
+	/* Send marker if required */
+	if (vha->marker_needed != 0) {
+		if (__qla2x00_marker(vha, qpair, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS) {
+			spin_unlock_irqrestore(&qpair->qp_lock, flags);
+			return QLA_FUNCTION_FAILED;
+		}
+		vha->marker_needed = 0;
+	}
+
+	handle = qla2xxx_get_next_handle(req);
+	if (handle == 0)
+		goto queuing_error;
+
+	/* Map the sg table so we have an accurate count of sg entries needed */
+	if (scsi_sg_count(cmd)) {
+		nseg = dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
+				  scsi_sg_count(cmd), cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			goto queuing_error;
+	} else {
+		nseg = 0;
+	}
+
+	tot_dsds = nseg;
+
+	/* eventhough driver only need 1 T6 IOCB, FW still convert DSD to Continueation IOCB */
+	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
+	sp->iores.iocb_cnt = req_cnt;
+
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
+		goto queuing_error;
+
+	more_dsd_lists = qla24xx_calc_dsd_lists(tot_dsds);
+	if ((more_dsd_lists + qpair->dsd_inuse) >= NUM_DSD_CHAIN) {
+		ql_dbg(ql_dbg_io, vha, 0x3028,
+		       "Num of DSD list %d is than %d for cmd=%p.\n",
+		       more_dsd_lists + qpair->dsd_inuse, NUM_DSD_CHAIN, cmd);
+		goto queuing_error;
+	}
+
+	if (more_dsd_lists <= qpair->dsd_avail)
+		goto sufficient_dsds;
+	else
+		more_dsd_lists -= qpair->dsd_avail;
+
+	for (i = 0; i < more_dsd_lists; i++) {
+		dsd_ptr = kzalloc(sizeof(*dsd_ptr), GFP_ATOMIC);
+		if (!dsd_ptr) {
+			ql_log(ql_log_fatal, vha, 0x3029,
+			    "Failed to allocate memory for dsd_dma for cmd=%p.\n", cmd);
+			goto queuing_error;
+		}
+		INIT_LIST_HEAD(&dsd_ptr->list);
+
+		dsd_ptr->dsd_addr = dma_pool_alloc(ha->dl_dma_pool,
+			GFP_ATOMIC, &dsd_ptr->dsd_list_dma);
+		if (!dsd_ptr->dsd_addr) {
+			kfree(dsd_ptr);
+			ql_log(ql_log_fatal, vha, 0x302a,
+			    "Failed to allocate memory for dsd_addr for cmd=%p.\n", cmd);
+			goto queuing_error;
+		}
+		list_add_tail(&dsd_ptr->list, &qpair->dsd_list);
+		qpair->dsd_avail++;
+	}
+
+sufficient_dsds:
+	req_cnt = 1;
+
+	if (req->cnt < (req_cnt + 2)) {
+		if (IS_SHADOW_REG_CAPABLE(ha)) {
+			cnt = *req->out_ptr;
+		} else {
+			cnt = (uint16_t)rd_reg_dword_relaxed(req->req_q_out);
+			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
+				goto queuing_error;
+		}
+
+		if (req->ring_index < cnt)
+			req->cnt = cnt - req->ring_index;
+		else
+			req->cnt = req->length - (req->ring_index - cnt);
+		if (req->cnt < (req_cnt + 2))
+			goto queuing_error;
+	}
+
+	ctx = &sp->u.scmd.ct6_ctx;
+
+	memset(ctx, 0, sizeof(struct ct6_dsd));
+	ctx->fcp_cmnd = dma_pool_zalloc(ha->fcp_cmnd_dma_pool,
+		GFP_ATOMIC, &ctx->fcp_cmnd_dma);
+	if (!ctx->fcp_cmnd) {
+		ql_log(ql_log_fatal, vha, 0x3031,
+		    "Failed to allocate fcp_cmnd for cmd=%p.\n", cmd);
+		goto queuing_error;
+	}
+
+	/* Initialize the DSD list and dma handle */
+	INIT_LIST_HEAD(&ctx->dsd_list);
+	ctx->dsd_use_cnt = 0;
+
+	if (cmd->cmd_len > 16) {
+		additional_cdb_len = cmd->cmd_len - 16;
+		if (cmd->cmd_len % 4 ||
+		    cmd->cmd_len > QLA_CDB_BUF_SIZE) {
+			/*
+			 * SCSI command bigger than 16 bytes must be
+			 * multiple of 4 or too big.
+			 */
+			ql_log(ql_log_warn, vha, 0x3033,
+			    "scsi cmd len %d not multiple of 4 for cmd=%p.\n",
+			    cmd->cmd_len, cmd);
+			goto queuing_error_fcp_cmnd;
+		}
+		ctx->fcp_cmnd_len = 12 + cmd->cmd_len + 4;
+	} else {
+		additional_cdb_len = 0;
+		ctx->fcp_cmnd_len = 12 + 16 + 4;
+	}
+
+	/* Build command packet. */
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = sp;
+	sp->handle = handle;
+	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
+	req->cnt -= req_cnt;
+
+	cmd_pkt = (struct cmd_type_6 *)req->ring_ptr;
+	cmd_pkt->handle = make_handle(req->id, handle);
+
+	/* tagged queuing modifier -- default is TSK_SIMPLE (0). */
+	clr_ptr = (uint32_t *)cmd_pkt + 2;
+	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+
+	/* Set NPORT-ID and LUN number */
+	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+	cmd_pkt->vp_index = sp->vha->vp_idx;
+
+	/* Build IOCB segments */
+	qla24xx_build_scsi_type_6_iocbs(sp, cmd_pkt, tot_dsds);
+
+	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
+	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
+
+	/* build FCP_CMND IU */
+	int_to_scsilun(cmd->device->lun, &ctx->fcp_cmnd->lun);
+	ctx->fcp_cmnd->additional_cdb_len = additional_cdb_len;
+
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		ctx->fcp_cmnd->additional_cdb_len |= 1;
+	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+		ctx->fcp_cmnd->additional_cdb_len |= 2;
+
+	/* Populate the FCP_PRIO. */
+	if (ha->flags.fcp_prio_enabled)
+		ctx->fcp_cmnd->task_attribute |=
+		    sp->fcport->fcp_prio << 3;
+
+	memcpy(ctx->fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
+
+	fcp_dl = (__be32 *)(ctx->fcp_cmnd->cdb + 16 +
+	    additional_cdb_len);
+	*fcp_dl = htonl((uint32_t)scsi_bufflen(cmd));
+
+	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(ctx->fcp_cmnd_len);
+	put_unaligned_le64(ctx->fcp_cmnd_dma,
+			   &cmd_pkt->fcp_cmnd_dseg_address);
+
+	sp->flags |= SRB_FCP_CMND_DMA_VALID;
+	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
+	/* Set total data segment count. */
+	cmd_pkt->entry_count = (uint8_t)req_cnt;
+
+	wmb();
+	/* Adjust ring index. */
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
+	} else {
+		req->ring_ptr++;
+	}
+
+	sp->qpair->cmd_cnt++;
+	sp->flags |= SRB_DMA_VALID;
+
+	/* Set chip new ring index. */
+	wrt_reg_dword(req->req_q_in, req->ring_index);
+
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (vha->flags.process_response_queue &&
+	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(vha, rsp);
+
+	spin_unlock_irqrestore(&qpair->qp_lock, flags);
+
+	return QLA_SUCCESS;
+
+queuing_error_fcp_cmnd:
+	dma_pool_free(ha->fcp_cmnd_dma_pool, ctx->fcp_cmnd, ctx->fcp_cmnd_dma);
+
+queuing_error:
+	if (tot_dsds)
+		scsi_dma_unmap(cmd);
+
+	qla_put_fw_resources(sp->qpair, &sp->iores);
+
+	if (sp->u.scmd.crc_ctx) {
+		mempool_free(sp->u.scmd.crc_ctx, ha->ctx_mempool);
+		sp->u.scmd.crc_ctx = NULL;
+	}
+
+	spin_unlock_irqrestore(&qpair->qp_lock, flags);
+
+	return QLA_FUNCTION_FAILED;
+}
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 6dc80c8ddf79..5d1bdc15b75c 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -857,7 +857,9 @@ struct fcp_cmnd {
 	uint8_t task_attribute;
 	uint8_t task_management;
 	uint8_t additional_cdb_len;
-	uint8_t cdb[260]; /* 256 for CDB len and 4 for FCP_DL */
+#define QLA_CDB_BUF_SIZE  256
+#define QLA_FCP_DL_SIZE   4
+	uint8_t cdb[QLA_CDB_BUF_SIZE + QLA_FCP_DL_SIZE]; /* 256 for CDB len and 4 for FCP_DL */
 };
 
 struct dsd_dma {
-- 
2.23.1

