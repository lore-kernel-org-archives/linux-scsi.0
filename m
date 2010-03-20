From: giridhar.malavali@qlogic.com
Subject: [PATCH 5/5] qla2xxx: General checkpatch corrections.
Date: Fri, 19 Mar 2010 17:04:02 -0700
Message-ID: <1269043442-2306-6-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36586 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752436Ab0CTAEH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 20:04:07 -0400
In-Reply-To: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 +--
 drivers/scsi/qla2xxx/qla_bsg.c  |   95 ++++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_init.c |    4 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 drivers/scsi/qla2xxx/qla_os.c   |   22 ++++++---
 5 files changed, 69 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8918c2d..6e597d4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1176,15 +1176,13 @@ qla24xx_84xx_fw_version_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (IS_QLA84XX(ha) && ha->cs84xx) {
-		if (ha->cs84xx->op_fw_version == 0) {
+	if (IS_QLA84XX(ha) && ha->cs84xx)
+		if (ha->cs84xx->op_fw_version == 0)
 			rval = qla84xx_verify_chip(vha, status);
-	}
 
 	if ((rval == QLA_SUCCESS) && (status[0] == 0))
 		return snprintf(buf, PAGE_SIZE, "%u\n",
 			(uint32_t)ha->cs84xx->op_fw_version);
-	}
 
 	return snprintf(buf, PAGE_SIZE, "\n");
 }
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index dc8bf10..387d694 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -274,7 +274,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 
 	if (!vha->flags.online) {
 		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "host not online\n"));
+		"host not online\n"));
 		rval = -EIO;
 		goto done;
 	}
@@ -286,16 +286,16 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 		rval = -ENOMEM;
 		goto done_free_fcport;
 	}
-        rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+	rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+		bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
         if (!rsp_sg_cnt) {
 		rval = -ENOMEM;
 		goto done_free_fcport;
 	}
 
 	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
-	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
-	{
+		(rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
 		DEBUG2(printk(KERN_INFO
 			"dma mapping resulted in different sg counts \
 			[request_sg_cnt: %x dma_request_sg_cnt: %x\
@@ -310,7 +310,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	sp = qla2x00_get_ctx_bsg_sp(vha, fcport, sizeof(struct srb_bsg));
 	if (!sp) {
 		rval = -ENOMEM;
-                goto done_unmap_sg;
+		goto done_unmap_sg;
 	}
 
 	els = sp->ctx;
@@ -364,10 +364,10 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	struct srb_bsg *ct;
 
 	/* pass through is supported only for ISP 4Gb or higher */
-        if (!IS_FWI2_CAPABLE(ha)) {
+	if (!IS_FWI2_CAPABLE(ha)) {
 		DEBUG2(qla_printk(KERN_INFO, ha,
-			"scsi(%ld):Firmware is not capable to support FC "
-			"CT pass thru\n", vha->host_no));
+		    "scsi(%ld):Firmware is not capable to support FC "
+		    "CT pass thru\n", vha->host_no));
 		rval = -EPERM;
 		goto done;
 	}
@@ -375,7 +375,7 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	req_sg_cnt =
 		dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 			bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-        if (!req_sg_cnt) {
+	if (!req_sg_cnt) {
 		rval = -ENOMEM;
 		goto done;
 	}
@@ -388,15 +388,14 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	}
 
 	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
-		(rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
-	{
+	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
 		DEBUG2(qla_printk(KERN_WARNING, ha,
-			"[request_sg_cnt: %x dma_request_sg_cnt: %x\
-			reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
-			bsg_job->request_payload.sg_cnt, req_sg_cnt,
-			bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
+		    "[request_sg_cnt: %x dma_request_sg_cnt: %x\
+		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+		    bsg_job->request_payload.sg_cnt, req_sg_cnt,
+		    bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
 		rval = -EAGAIN;
-                goto done_unmap_sg;
+		goto done_unmap_sg;
 	}
 
 	if (!vha->flags.online) {
@@ -410,17 +409,17 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 		(bsg_job->request->rqst_data.h_ct.preamble_word1 & 0xFF000000)
 			>> 24;
 	switch (loop_id) {
-		case 0xFC:
-			loop_id = cpu_to_le16(NPH_SNS);
-			break;
-		case 0xFA:
-			loop_id = vha->mgmt_svr_loop_id;
-			break;
-		default:
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "Unknown loop id: %x\n", loop_id));
-			rval = -EINVAL;
-			goto done_unmap_sg;
+	case 0xFC:
+		loop_id = cpu_to_le16(NPH_SNS);
+		break;
+	case 0xFA:
+		loop_id = vha->mgmt_svr_loop_id;
+		break;
+	default:
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "Unknown loop id: %x\n", loop_id));
+		rval = -EINVAL;
+		goto done_unmap_sg;
 	}
 
 	/* Allocate a dummy fcport structure, since functions preparing the
@@ -429,10 +428,9 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	 * no fcport structure allocated
 	 */
 	fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
-	if (!fcport)
-	{
+	if (!fcport) {
 		rval = -ENOMEM;
-		goto  done_unmap_sg;
+		goto done_unmap_sg;
 	}
 
 	/* Initialize all required  fields of fcport */
@@ -492,7 +490,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	char *type;
 	struct msg_echo_lb elreq;
 	uint16_t response[MAILBOX_REGISTER_COUNT];
-	uint8_t* fw_sts_ptr;
+	uint8_t *fw_sts_ptr;
 	uint8_t *req_data = NULL;
 	dma_addr_t req_data_dma;
 	uint32_t req_data_len;
@@ -524,7 +522,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	if (!elreq.rsp_sg_cnt) {
 		rval = -ENOMEM;
 		goto done_unmap_req_sg;
-}
+	}
 
 	if ((elreq.req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
 		(elreq.rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
@@ -586,21 +584,21 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	} else {
 		type = "FC_BSG_HST_VENDOR_ECHO_DIAG";
 		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "scsi(%ld) bsg rqst type: %s\n" ,vha->host_no, type));
+		    "scsi(%ld) bsg rqst type: %s\n", vha->host_no, type));
 		command_sent = INT_DEF_LB_ECHO_CMD;
 		rval = qla2x00_echo_test(vha, &elreq, response);
 	}
 
 	if (rval) {
 		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
-			"request %s failed\n", vha->host_no, type));
+		    "request %s failed\n", vha->host_no, type));
 
 		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
-			sizeof(struct fc_bsg_reply);
+		    sizeof(struct fc_bsg_reply);
 
 		memcpy(fw_sts_ptr, response, sizeof(response));
 		fw_sts_ptr += sizeof(response);
-                *fw_sts_ptr = command_sent;
+		*fw_sts_ptr = command_sent;
 		rval = 0;
 		bsg_job->reply->reply_payload_rcv_len = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
@@ -637,7 +635,7 @@ done_unmap_req_sg:
 	dma_unmap_sg(&ha->pdev->dev,
 	    bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-        return rval;
+	return rval;
 }
 
 static int
@@ -975,7 +973,8 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 				bsg_job->reply_payload.payload_len;
 
 			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-				bsg_job->reply_payload.sg_cnt, mgmt_b, data_len);
+				bsg_job->reply_payload.sg_cnt, mgmt_b,
+				data_len);
 		}
 	}
 
@@ -1062,7 +1061,8 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 
 	if (rval) {
 		DEBUG16(printk(KERN_ERR "scsi(%ld): iIDMA cmd failed for "
-			"%02x%02x%02x%02x%02x%02x%02x%02x -- %04x %x %04x %04x.\n",
+			"%02x%02x%02x%02x%02x%02x%02x%02x -- "
+			"%04x %x %04x %04x.\n",
 			vha->host_no, fcport->port_name[0],
 			fcport->port_name[1],
 			fcport->port_name[2], fcport->port_name[3],
@@ -1142,7 +1142,7 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 	default:
 		DEBUG2(printk("qla2xxx: unsupported BSG request\n"));
 		break;
-        }
+	}
 	return ret;
 }
 
@@ -1164,23 +1164,26 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 		if (!req)
 			continue;
 
-		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++ ) {
+		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
 			sp = req->outstanding_cmds[cnt];
-
 			if (sp) {
-				sp_bsg = (struct srb_bsg*)sp->ctx;
+				sp_bsg = (struct srb_bsg *)sp->ctx;
 
 				if (((sp_bsg->ctx.type == SRB_CT_CMD) ||
 					(sp_bsg->ctx.type == SRB_ELS_CMD_HST))
 					&& (sp_bsg->bsg_job == bsg_job)) {
 					if (ha->isp_ops->abort_command(sp)) {
 						DEBUG2(qla_printk(KERN_INFO, ha,
-						"scsi(%ld): mbx abort_command failed\n", vha->host_no));
+						    "scsi(%ld): mbx "
+						    "abort_command failed\n",
+						    vha->host_no));
 						bsg_job->req->errors =
 						bsg_job->reply->result = -EIO;
 					} else {
 						DEBUG2(qla_printk(KERN_INFO, ha,
-						"scsi(%ld): mbx abort_command success\n", vha->host_no));
+						    "scsi(%ld): mbx "
+						    "abort_command success\n",
+						    vha->host_no));
 						bsg_job->req->errors =
 						bsg_job->reply->result = 0;
 					}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3714fec..56e8169 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -339,7 +339,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	ha->flags.chip_reset_done = 1;
 
 	if (rval == QLA_SUCCESS && IS_QLA84XX(ha)) {
-	/* Issue verify 84xx FW IOCB to complete 84xx initialization */
+		/* Issue verify 84xx FW IOCB to complete 84xx initialization */
 		rval = qla84xx_init_chip(vha);
 		if (rval != QLA_SUCCESS) {
 			qla_printk(KERN_ERR, ha,
@@ -4923,7 +4923,7 @@ qla81xx_update_fw_options(scsi_qla_host_t *vha)
  *	fcport = port structure pointer.
  *
  * Return:
- * 	non-zero (if found)
+ *	non-zero (if found)
  * 	0 (if not found)
  *
  * Context:
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d1d66a1..513a0e3 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3839,7 +3839,7 @@ qla2x00_write_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t data)
 	mbx_cmd_t *mcp = &mc;
 
 	if (!IS_FWI2_CAPABLE(vha->hw))
-                return QLA_FUNCTION_FAILED;
+		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index be3f1d3..f4ffa30 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1129,18 +1129,26 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 					qla2x00_sp_compl(ha, sp);
 				} else {
 					ctx = sp->ctx;
-					if (ctx->type == SRB_LOGIN_CMD || ctx->type == SRB_LOGOUT_CMD) {
+					if (ctx->type == SRB_LOGIN_CMD ||
+					    ctx->type == SRB_LOGOUT_CMD) {
 						del_timer_sync(&ctx->timer);
 						ctx->free(sp);
 					} else {
-						struct srb_bsg* sp_bsg = (struct srb_bsg*)sp->ctx;
-						if (sp_bsg->bsg_job->request->msgcode == FC_BSG_HST_CT)
+						struct srb_bsg *sp_bsg =
+						    (struct srb_bsg *)sp->ctx;
+						struct fc_bsg_job *bsg_job =
+						    sp_bsg->bsg_job;
+
+						if (bsg_job->request->msgcode
+						    == FC_BSG_HST_CT)
 							kfree(sp->fcport);
-						sp_bsg->bsg_job->req->errors = 0;
-						sp_bsg->bsg_job->reply->result = res;
-						sp_bsg->bsg_job->job_done(sp_bsg->bsg_job);
+						bsg_job->req->errors = 0;
+						bsg_job->reply->result = res;
+						bsg_job->job_done(
+						    sp_bsg->bsg_job);
 						kfree(sp->ctx);
-						mempool_free(sp, ha->srb_mempool);
+						mempool_free(sp,
+						    ha->srb_mempool);
 					}
 				}
 			}
-- 
1.6.2.rc1.30.gd43c

