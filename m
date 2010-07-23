From: giridhar.malavali@qlogic.com
Subject: [PATCH 11/17] qla2xxx: Add CT passthru support for ISP23xx adapters
Date: Fri, 23 Jul 2010 15:28:32 +0500
Message-ID: <1279880918-62876-12-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47959 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755808Ab0GWJ7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:38 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  |    9 ----
 drivers/scsi/qla2xxx/qla_iocb.c |   80 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c  |   83 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 162 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 518fccf..04ead06 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -396,15 +396,6 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	char  *type = "FC_BSG_HST_CT";
 	struct srb_ctx *ct;
 
-	/* pass through is supported only for ISP 4Gb or higher */
-	if (!IS_FWI2_CAPABLE(ha)) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "scsi(%ld):Firmware is not capable to support FC "
-		    "CT pass thru\n", vha->host_no));
-		rval = -EPERM;
-		goto done;
-	}
-
 	req_sg_cnt =
 		dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 			bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 370646f..e27d947 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1765,6 +1765,82 @@ qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 }
 
 static void
+qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
+{
+	uint16_t        avail_dsds;
+	uint32_t        *cur_dsd;
+	struct scatterlist *sg;
+	int index;
+	uint16_t tot_dsds;
+	scsi_qla_host_t *vha = sp->fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct fc_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
+	int loop_iterartion = 0;
+	int cont_iocb_prsnt = 0;
+	int entry_count = 1;
+
+	memset(ct_iocb, 0, sizeof(ms_iocb_entry_t));
+	ct_iocb->entry_type = CT_IOCB_TYPE;
+	ct_iocb->entry_status = 0;
+	ct_iocb->handle1 = sp->handle;
+	SET_TARGET_ID(ha, ct_iocb->loop_id, sp->fcport->loop_id);
+	ct_iocb->status = __constant_cpu_to_le16(0);
+	ct_iocb->control_flags = __constant_cpu_to_le16(0);
+	ct_iocb->timeout = 0;
+	ct_iocb->cmd_dsd_count =
+	    __constant_cpu_to_le16(bsg_job->request_payload.sg_cnt);
+	ct_iocb->total_dsd_count =
+	    __constant_cpu_to_le16(bsg_job->request_payload.sg_cnt + 1);
+	ct_iocb->req_bytecount =
+	    cpu_to_le32(bsg_job->request_payload.payload_len);
+	ct_iocb->rsp_bytecount =
+	    cpu_to_le32(bsg_job->reply_payload.payload_len);
+
+	ct_iocb->dseg_req_address[0] = cpu_to_le32(LSD(sg_dma_address
+	    (bsg_job->request_payload.sg_list)));
+	ct_iocb->dseg_req_address[1] = cpu_to_le32(MSD(sg_dma_address
+	    (bsg_job->request_payload.sg_list)));
+	ct_iocb->dseg_req_length = ct_iocb->req_bytecount;
+
+	ct_iocb->dseg_rsp_address[0] = cpu_to_le32(LSD(sg_dma_address
+	    (bsg_job->reply_payload.sg_list)));
+	ct_iocb->dseg_rsp_address[1] = cpu_to_le32(MSD(sg_dma_address
+	    (bsg_job->reply_payload.sg_list)));
+	ct_iocb->dseg_rsp_length = ct_iocb->rsp_bytecount;
+
+	avail_dsds = 1;
+	cur_dsd = (uint32_t *)ct_iocb->dseg_rsp_address;
+	index = 0;
+	tot_dsds = bsg_job->reply_payload.sg_cnt;
+
+	for_each_sg(bsg_job->reply_payload.sg_list, sg, tot_dsds, index) {
+		dma_addr_t       sle_dma;
+		cont_a64_entry_t *cont_pkt;
+
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			/*
+			* Five DSDs are available in the Cont.
+			* Type 1 IOCB.
+			       */
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
+			cur_dsd = (uint32_t *) cont_pkt->dseg_0_address;
+			avail_dsds = 5;
+			cont_iocb_prsnt = 1;
+			entry_count++;
+		}
+
+		sle_dma = sg_dma_address(sg);
+		*cur_dsd++   = cpu_to_le32(LSD(sle_dma));
+		*cur_dsd++   = cpu_to_le32(MSD(sle_dma));
+		*cur_dsd++   = cpu_to_le32(sg_dma_len(sg));
+		loop_iterartion++;
+		avail_dsds--;
+	}
+	ct_iocb->entry_count = entry_count;
+}
+
+static void
 qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 {
 	uint16_t        avail_dsds;
@@ -1867,7 +1943,9 @@ qla2x00_start_sp(srb_t *sp)
 		qla24xx_els_iocb(sp, pkt);
 		break;
 	case SRB_CT_CMD:
-		qla24xx_ct_iocb(sp, pkt);
+		IS_FWI2_CAPABLE(ha) ?
+		qla24xx_ct_iocb(sp, pkt) :
+		qla2x00_ct_iocb(sp, pkt);
 		break;
 	case SRB_ADISC_CMD:
 		IS_FWI2_CAPABLE(ha) ?
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ffc855f..5180033 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -984,6 +984,86 @@ logio_done:
 }
 
 static void
+qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
+    sts_entry_t *pkt, int iocb_type)
+{
+	const char func[] = "CT_IOCB";
+	const char *type;
+	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp;
+	struct srb_ctx *sp_bsg;
+	struct fc_bsg_job *bsg_job;
+	uint16_t comp_status;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	if (!sp)
+		return;
+
+	sp_bsg = sp->ctx;
+	bsg_job = sp_bsg->u.bsg_job;
+
+	type = NULL;
+	switch (sp_bsg->type) {
+	case SRB_CT_CMD:
+		type = "ct pass-through";
+		break;
+	default:
+		qla_printk(KERN_WARNING, ha,
+		    "%s: Unrecognized SRB: (%p) type=%d.\n", func, sp,
+		    sp_bsg->type);
+		return;
+	}
+
+	comp_status = le16_to_cpu(pkt->comp_status);
+
+	/* return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
+	 * fc payload  to the caller
+	 */
+	bsg_job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+
+	if (comp_status != CS_COMPLETE) {
+		if (comp_status == CS_DATA_UNDERRUN) {
+			bsg_job->reply->result = DID_OK << 16;
+			bsg_job->reply->reply_payload_rcv_len =
+			    le16_to_cpu(((sts_entry_t *)pkt)->rsp_info_len);
+
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			    "scsi(%ld): CT pass-through-%s error "
+			    "comp_status-status=0x%x total_byte = 0x%x.\n",
+			    vha->host_no, type, comp_status,
+			    bsg_job->reply->reply_payload_rcv_len));
+		} else {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			    "scsi(%ld): CT pass-through-%s error "
+			    "comp_status-status=0x%x.\n",
+			    vha->host_no, type, comp_status));
+			bsg_job->reply->result = DID_ERROR << 16;
+			bsg_job->reply->reply_payload_rcv_len = 0;
+		}
+		DEBUG2(qla2x00_dump_buffer((uint8_t *)pkt, sizeof(*pkt)));
+	} else {
+		bsg_job->reply->result =  DID_OK << 16;;
+		bsg_job->reply->reply_payload_rcv_len =
+		    bsg_job->reply_payload.payload_len;
+		bsg_job->reply_len = 0;
+	}
+
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+	if (sp_bsg->type == SRB_ELS_CMD_HST || sp_bsg->type == SRB_CT_CMD)
+		kfree(sp->fcport);
+
+	kfree(sp->ctx);
+	mempool_free(sp, ha->srb_mempool);
+	bsg_job->job_done(bsg_job);
+}
+
+static void
 qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
     struct sts_entry_24xx *pkt, int iocb_type)
 {
@@ -1303,6 +1383,9 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 			qla2x00_mbx_iocb_entry(vha, rsp->req,
 			    (struct mbx_entry *)pkt);
 			break;
+		case CT_IOCB_TYPE:
+			qla2x00_ct_entry(vha, rsp->req, pkt, CT_IOCB_TYPE);
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
-- 
1.6.0.2

