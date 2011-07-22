From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 08/10] qla2xxx: convert qla2xxx to scsi bsg lib
Date: Fri, 22 Jul 2011 05:04:58 -0500
Message-ID: <1311329100-2982-9-git-send-email-michaelc@cs.wisc.edu>
References: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab1GVKCf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 06:02:35 -0400
In-Reply-To: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

This patch converts qla2xxx to the scsi bsg lib. The differences
visible to the driver are:
- fc_bsg_job is now named scsi_bsg_job.
- no rport pointer. Can access it through the device pointer.
- the request and reply pointers on the scsi_bsg_job struct
  are now void pointers, so you cannot do bsg_job->request->some_field.

I did some basic testing with Qlogic's tools that use bsg.
Giri has also reported success with some basic testing.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  |  219 ++++++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_def.h  |    3 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |    4 +-
 drivers/scsi/qla2xxx/qla_iocb.c |   11 +-
 drivers/scsi/qla2xxx/qla_isr.c  |   44 +++++----
 drivers/scsi/qla2xxx/qla_os.c   |   32 ++++---
 6 files changed, 178 insertions(+), 135 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 8c10e2c..5923b97 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -92,16 +92,18 @@ qla24xx_fcp_prio_cfg_valid(struct qla_fcp_prio_cfg *pri_cfg, uint8_t flag)
 }
 
 static int
-qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
+qla24xx_proc_fcp_prio_cfg_cmd(struct scsi_bsg_job *bsg_job)
 {
 	struct Scsi_Host *host = bsg_job->shost;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct fc_bsg_request *bsg_req = bsg_job->request;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int ret = 0;
 	uint32_t len;
 	uint32_t oper;
 
-	bsg_job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (!(IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))) {
 		ret = -EINVAL;
@@ -116,7 +118,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 	}
 
 	/* Get the sub command */
-	oper = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	oper = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
 
 	/* Only set config is allowed if config memory is not allocated */
 	if (!ha->fcp_prio_cfg && (oper != QLFC_FCP_PRIO_SET_CONFIG)) {
@@ -130,10 +132,10 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 			ha->fcp_prio_cfg->attributes &=
 				~FCP_PRIO_ATTR_ENABLE;
 			qla24xx_update_all_fcp_prio(vha);
-			bsg_job->reply->result = DID_OK;
+			bsg_reply->result = DID_OK;
 		} else {
 			ret = -EINVAL;
-			bsg_job->reply->result = (DID_ERROR << 16);
+			bsg_reply->result = (DID_ERROR << 16);
 			goto exit_fcp_prio_cfg;
 		}
 		break;
@@ -145,10 +147,10 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 				ha->fcp_prio_cfg->attributes |=
 				    FCP_PRIO_ATTR_ENABLE;
 				qla24xx_update_all_fcp_prio(vha);
-				bsg_job->reply->result = DID_OK;
+				bsg_reply->result = DID_OK;
 			} else {
 				ret = -EINVAL;
-				bsg_job->reply->result = (DID_ERROR << 16);
+				bsg_reply->result = (DID_ERROR << 16);
 				goto exit_fcp_prio_cfg;
 			}
 		}
@@ -158,12 +160,12 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 		len = bsg_job->reply_payload.payload_len;
 		if (!len || len > FCP_PRIO_CFG_SIZE) {
 			ret = -EINVAL;
-			bsg_job->reply->result = (DID_ERROR << 16);
+			bsg_reply->result = (DID_ERROR << 16);
 			goto exit_fcp_prio_cfg;
 		}
 
-		bsg_job->reply->result = DID_OK;
-		bsg_job->reply->reply_payload_rcv_len =
+		bsg_reply->result = DID_OK;
+		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(
 			bsg_job->reply_payload.sg_list,
 			bsg_job->reply_payload.sg_cnt, ha->fcp_prio_cfg,
@@ -174,7 +176,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 	case QLFC_FCP_PRIO_SET_CONFIG:
 		len = bsg_job->request_payload.payload_len;
 		if (!len || len > FCP_PRIO_CFG_SIZE) {
-			bsg_job->reply->result = (DID_ERROR << 16);
+			bsg_reply->result = (DID_ERROR << 16);
 			ret = -EINVAL;
 			goto exit_fcp_prio_cfg;
 		}
@@ -186,7 +188,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 					"Unable to allocate memory "
 					"for fcp prio config data (%x).\n",
 					FCP_PRIO_CFG_SIZE);
-				bsg_job->reply->result = (DID_ERROR << 16);
+				bsg_reply->result = (DID_ERROR << 16);
 				ret = -ENOMEM;
 				goto exit_fcp_prio_cfg;
 			}
@@ -201,7 +203,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 		if (!qla24xx_fcp_prio_cfg_valid(
 			(struct qla_fcp_prio_cfg *)
 			ha->fcp_prio_cfg, 1)) {
-			bsg_job->reply->result = (DID_ERROR << 16);
+			bsg_reply->result = (DID_ERROR << 16);
 			ret = -EINVAL;
 			/* If buffer was invalidatic int
 			 * fcp_prio_cfg is of no use
@@ -215,19 +217,21 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 		if (ha->fcp_prio_cfg->attributes & FCP_PRIO_ATTR_ENABLE)
 			ha->flags.fcp_prio_enabled = 1;
 		qla24xx_update_all_fcp_prio(vha);
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 		break;
 	default:
 		ret = -EINVAL;
 		break;
 	}
 exit_fcp_prio_cfg:
-	bsg_job->job_done(bsg_job);
+	bsg_job->job_done(bsg_job, bsg_reply->result,
+			  bsg_reply->reply_payload_rcv_len);
 	return ret;
 }
 static int
-qla2x00_process_els(struct fc_bsg_job *bsg_job)
+qla2x00_process_els(struct scsi_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_req = bsg_job->request;
 	struct fc_rport *rport;
 	fc_port_t *fcport = NULL;
 	struct Scsi_Host *host;
@@ -240,8 +244,8 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	uint16_t nextlid = 0;
 	struct srb_ctx *els;
 
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
-		rport = bsg_job->rport;
+	if (bsg_req->msgcode == FC_BSG_RPT_ELS) {
+		rport = dev_to_rport(bsg_job->dev);
 		fcport = *(fc_port_t **) rport->dd_data;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
@@ -276,7 +280,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	}
 
 	/* ELS request for rport */
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+	if (bsg_req->msgcode == FC_BSG_RPT_ELS) {
 		/* make sure the rport is logged in,
 		 * if not perform fabric login
 		 */
@@ -303,11 +307,11 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 		fcport->vha = vha;
 		fcport->vp_idx = vha->vp_idx;
 		fcport->d_id.b.al_pa =
-			bsg_job->request->rqst_data.h_els.port_id[0];
+			bsg_req->rqst_data.h_els.port_id[0];
 		fcport->d_id.b.area =
-			bsg_job->request->rqst_data.h_els.port_id[1];
+			bsg_req->rqst_data.h_els.port_id[1];
 		fcport->d_id.b.domain =
-			bsg_job->request->rqst_data.h_els.port_id[2];
+			bsg_req->rqst_data.h_els.port_id[2];
 		fcport->loop_id =
 			(fcport->d_id.b.al_pa == 0xFD) ?
 			NPH_FABRIC_CONTROLLER : NPH_F_PORT;
@@ -356,17 +360,17 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 
 	els = sp->ctx;
 	els->type =
-		(bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
+		(bsg_req->msgcode == FC_BSG_RPT_ELS ?
 		SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
 	els->name =
-		(bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
+		(bsg_req->msgcode == FC_BSG_RPT_ELS ?
 		"bsg_els_rpt" : "bsg_els_hst");
 	els->u.bsg_job = bsg_job;
 
 	DEBUG2(qla_printk(KERN_INFO, ha,
 		"scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
 		"portid=%02x%02x%02x.\n", vha->host_no, sp->handle, type,
-		bsg_job->request->rqst_data.h_els.command_code,
+		bsg_req->rqst_data.h_els.command_code,
 		fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
 		fcport->d_id.b.al_pa));
 
@@ -387,16 +391,17 @@ done_unmap_sg:
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN)
+	if (bsg_req->msgcode == FC_BSG_HST_ELS_NOLOGIN)
 		kfree(fcport);
 done:
 	return rval;
 }
 
 static int
-qla2x00_process_ct(struct fc_bsg_job *bsg_job)
+qla2x00_process_ct(struct scsi_bsg_job *bsg_job)
 {
 	srb_t *sp;
+	struct fc_bsg_request *bsg_req = bsg_job->request;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -441,7 +446,7 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	}
 
 	loop_id =
-		(bsg_job->request->rqst_data.h_ct.preamble_word1 & 0xFF000000)
+		(bsg_req->rqst_data.h_ct.preamble_word1 & 0xFF000000)
 			>> 24;
 	switch (loop_id) {
 	case 0xFC:
@@ -471,9 +476,9 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	/* Initialize all required  fields of fcport */
 	fcport->vha = vha;
 	fcport->vp_idx = vha->vp_idx;
-	fcport->d_id.b.al_pa = bsg_job->request->rqst_data.h_ct.port_id[0];
-	fcport->d_id.b.area = bsg_job->request->rqst_data.h_ct.port_id[1];
-	fcport->d_id.b.domain = bsg_job->request->rqst_data.h_ct.port_id[2];
+	fcport->d_id.b.al_pa = bsg_req->rqst_data.h_ct.port_id[0];
+	fcport->d_id.b.area = bsg_req->rqst_data.h_ct.port_id[1];
+	fcport->d_id.b.domain = bsg_req->rqst_data.h_ct.port_id[2];
 	fcport->loop_id = loop_id;
 
 	/* Alloc SRB structure */
@@ -491,7 +496,7 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	DEBUG2(qla_printk(KERN_INFO, ha,
 		"scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
 		"portid=%02x%02x%02x.\n", vha->host_no, sp->handle, type,
-		(bsg_job->request->rqst_data.h_ct.preamble_word2 >> 16),
+		(bsg_req->rqst_data.h_ct.preamble_word2 >> 16),
 		fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
 		fcport->d_id.b.al_pa));
 
@@ -608,8 +613,10 @@ done_reset_internal:
 }
 
 static int
-qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
+qla2x00_process_loopback(struct scsi_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_req = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -691,7 +698,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	elreq.rcv_dma = rsp_data_dma;
 	elreq.transfer_size = req_data_len;
 
-	elreq.options = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	elreq.options = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
 
 	if ((ha->current_topology == ISP_CFG_F ||
 	    (IS_QLA81XX(ha) &&
@@ -711,8 +718,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 				DEBUG2(printk(KERN_ERR
 					"%s(%lu): Get port config failed\n",
 					__func__, vha->host_no));
-				bsg_job->reply->reply_payload_rcv_len = 0;
-				bsg_job->reply->result = (DID_ERROR << 16);
+				bsg_reply->reply_payload_rcv_len = 0;
+				bsg_reply->result = (DID_ERROR << 16);
 				rval = -EPERM;
 				goto done_free_dma_req;
 			}
@@ -723,10 +730,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 					config[0]));
 				if (qla81xx_set_internal_loopback(vha, config,
 					new_config)) {
-					bsg_job->reply->reply_payload_rcv_len =
-						0;
-					bsg_job->reply->result =
-						(DID_ERROR << 16);
+					bsg_reply->reply_payload_rcv_len = 0;
+					bsg_reply->result = (DID_ERROR << 16);
 					rval = -EPERM;
 					goto done_free_dma_req;
 				}
@@ -736,10 +741,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 				 */
 				if (qla81xx_reset_internal_loopback(vha,
 					config, 1)) {
-					bsg_job->reply->reply_payload_rcv_len =
-						0;
-					bsg_job->reply->result =
-						(DID_ERROR << 16);
+					bsg_reply->reply_payload_rcv_len = 0;
+					bsg_reply->result = (DID_ERROR << 16);
 					rval = -EPERM;
 					goto done_free_dma_req;
 				}
@@ -776,8 +779,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 					    vha->host_no);
 				}
 
-				bsg_job->reply->reply_payload_rcv_len = 0;
-				bsg_job->reply->result = (DID_ERROR << 16);
+				bsg_reply->reply_payload_rcv_len = 0;
+				bsg_reply->result = (DID_ERROR << 16);
 				rval = -EIO;
 				goto done_free_dma_req;
 			}
@@ -802,27 +805,28 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 		fw_sts_ptr += sizeof(response);
 		*fw_sts_ptr = command_sent;
 		rval = 0;
-		bsg_job->reply->reply_payload_rcv_len = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
+		bsg_reply->reply_payload_rcv_len = 0;
+		bsg_reply->result = (DID_ERROR << 16);
 	} else {
 		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
 			"request %s completed\n", vha->host_no, type));
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
 			sizeof(response) + sizeof(uint8_t);
-		bsg_job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 			bsg_job->reply_payload.payload_len;
 		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
 			sizeof(struct fc_bsg_reply);
 		memcpy(fw_sts_ptr, response, sizeof(response));
 		fw_sts_ptr += sizeof(response);
 		*fw_sts_ptr = command_sent;
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 			bsg_job->reply_payload.sg_cnt, rsp_data,
 			rsp_data_len);
 	}
-	bsg_job->job_done(bsg_job);
+	bsg_job->job_done(bsg_job, bsg_reply->result,
+			  bsg_reply->reply_payload_rcv_len);
 
 	dma_free_coherent(&ha->pdev->dev, rsp_data_len,
 		rsp_data, rsp_data_dma);
@@ -841,8 +845,10 @@ done_unmap_req_sg:
 }
 
 static int
-qla84xx_reset(struct fc_bsg_job *bsg_job)
+qla84xx_reset(struct scsi_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct fc_bsg_request *bsg_req = bsg_job->request;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -860,29 +866,32 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
-	flag = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	flag = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
 
 	rval = qla84xx_reset_chip(vha, flag == A84_ISSUE_RESET_DIAG_FW);
 
 	if (rval) {
 		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
 		    "request 84xx reset failed\n", vha->host_no));
-		rval = bsg_job->reply->reply_payload_rcv_len = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
+		rval = bsg_reply->reply_payload_rcv_len = 0;
+		bsg_reply->result = (DID_ERROR << 16);
 
 	} else {
 		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
 		    "request 84xx reset completed\n", vha->host_no));
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 	}
 
-	bsg_job->job_done(bsg_job);
+	bsg_job->job_done(bsg_job, bsg_reply->result,
+			  bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
 static int
-qla84xx_updatefw(struct fc_bsg_job *bsg_job)
+qla84xx_updatefw(struct scsi_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct fc_bsg_request *bsg_req = bsg_job->request;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -942,7 +951,7 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 		goto done_free_fw_buf;
 	}
 
-	flag = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	flag = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
 	fw_ver = le32_to_cpu(*((uint32_t *)((uint32_t *)fw_buf + 2)));
 
 	memset(mn, 0, sizeof(struct access_chip_84xx));
@@ -968,18 +977,19 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
 			"request 84xx updatefw failed\n", vha->host_no));
 
-		rval = bsg_job->reply->reply_payload_rcv_len = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
+		rval = bsg_reply->reply_payload_rcv_len = 0;
+		bsg_reply->result = (DID_ERROR << 16);
 
 	} else {
 		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
 			"request 84xx updatefw completed\n", vha->host_no));
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 	}
 
-	bsg_job->job_done(bsg_job);
+	bsg_job->job_done(bsg_job, bsg_reply->result,
+			  bsg_reply->reply_payload_rcv_len);
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
 done_free_fw_buf:
@@ -993,8 +1003,9 @@ done_unmap_sg:
 }
 
 static int
-qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
+qla84xx_mgmt_cmd(struct scsi_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1159,19 +1170,19 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
 			"request 84xx mgmt failed\n", vha->host_no));
 
-		rval = bsg_job->reply->reply_payload_rcv_len = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
+		rval = bsg_reply->reply_payload_rcv_len = 0;
+		bsg_reply->result = (DID_ERROR << 16);
 
 	} else {
 		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
 			"request 84xx mgmt completed\n", vha->host_no));
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 
 		if ((ql84_mgmt->mgmt.cmd == QLA84_MGMT_READ_MEM) ||
 			(ql84_mgmt->mgmt.cmd == QLA84_MGMT_GET_INFO)) {
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				bsg_job->reply_payload.payload_len;
 
 			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
@@ -1180,7 +1191,8 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		}
 	}
 
-	bsg_job->job_done(bsg_job);
+	bsg_job->job_done(bsg_job, bsg_reply->result,
+			  bsg_reply->reply_payload_rcv_len);
 
 done_unmap_sg:
 	if (mgmt_b)
@@ -1200,8 +1212,9 @@ exit_mgmt:
 }
 
 static int
-qla24xx_iidma(struct fc_bsg_job *bsg_job)
+qla24xx_iidma(struct scsi_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1211,7 +1224,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	uint8_t *rsp_ptr = NULL;
 
-	bsg_job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
 		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
@@ -1285,7 +1298,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 			fcport->port_name[6], fcport->port_name[7], rval,
 			fcport->fp_speed, mb[0], mb[1]));
 		rval = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
+		bsg_reply->result = (DID_ERROR << 16);
 
 	} else {
 		if (!port_param->mode) {
@@ -1299,26 +1312,29 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 				sizeof(struct qla_port_param));
 		}
 
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 	}
 
-	bsg_job->job_done(bsg_job);
+	bsg_job->job_done(bsg_job, bsg_reply->result,
+			  bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
 static int
-qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, struct qla_hw_data *ha,
+qla2x00_optrom_setup(struct scsi_bsg_job *bsg_job, struct qla_hw_data *ha,
 	uint8_t is_update)
 {
+	struct fc_bsg_request *bsg_req = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	uint32_t start = 0;
 	int valid = 0;
 
-	bsg_job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (unlikely(pci_channel_offline(ha->pdev)))
 		return -EINVAL;
 
-	start = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	start = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
 	if (start > ha->optrom_size)
 		return -EINVAL;
 
@@ -1371,10 +1387,11 @@ qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, struct qla_hw_data *ha,
 }
 
 static int
-qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
+qla2x00_read_optrom(struct scsi_bsg_job *bsg_job)
 {
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
@@ -1389,20 +1406,22 @@ qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 	    bsg_job->reply_payload.sg_cnt, ha->optrom_buffer,
 	    ha->optrom_region_size);
 
-	bsg_job->reply->reply_payload_rcv_len = ha->optrom_region_size;
-	bsg_job->reply->result = DID_OK;
+	bsg_reply->reply_payload_rcv_len = ha->optrom_region_size;
+	bsg_reply->result = DID_OK;
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
-	bsg_job->job_done(bsg_job);
+	bsg_job->job_done(bsg_job, bsg_reply->result,
+			  bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
 static int
-qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
+qla2x00_update_optrom(struct scsi_bsg_job *bsg_job)
 {
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
@@ -1417,18 +1436,23 @@ qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 	ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
 	    ha->optrom_region_start, ha->optrom_region_size);
 
-	bsg_job->reply->result = DID_OK;
+	bsg_reply->result = DID_OK;
+	bsg_reply->reply_payload_rcv_len = 0;
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
-	bsg_job->job_done(bsg_job);
+	bsg_job->job_done(bsg_job, bsg_reply->result,
+			  bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
 static int
-qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
+qla2x00_process_vendor_specific(struct scsi_bsg_job *bsg_job)
 {
-	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
+	struct fc_bsg_request *bsg_req = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+
+	switch (bsg_req->rqst_data.h_vendor.vendor_cmd[0]) {
 	case QL_VND_LOOPBACK:
 		return qla2x00_process_loopback(bsg_job);
 
@@ -1454,18 +1478,21 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 		return qla2x00_update_optrom(bsg_job);
 
 	default:
-		bsg_job->reply->result = (DID_ERROR << 16);
-		bsg_job->job_done(bsg_job);
+		bsg_reply->result = (DID_ERROR << 16);
+		bsg_reply->reply_payload_rcv_len = 0;
+		bsg_job->job_done(bsg_job, bsg_reply->result,
+				  bsg_reply->reply_payload_rcv_len);
 		return -ENOSYS;
 	}
 }
 
 int
-qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
+qla24xx_bsg_request(struct scsi_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_req = bsg_job->request;
 	int ret = -EINVAL;
 
-	switch (bsg_job->request->msgcode) {
+	switch (bsg_req->msgcode) {
 	case FC_BSG_RPT_ELS:
 	case FC_BSG_HST_ELS_NOLOGIN:
 		ret = qla2x00_process_els(bsg_job);
@@ -1487,8 +1514,10 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 }
 
 int
-qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
+qla24xx_bsg_timeout(struct scsi_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_req = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(bsg_job->shost);
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
@@ -1519,14 +1548,14 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 						    "abort_command failed\n",
 						    vha->host_no));
 						bsg_job->req->errors =
-						bsg_job->reply->result = -EIO;
+						bsg_reply->result = -EIO;
 					} else {
 						DEBUG2(qla_printk(KERN_INFO, ha,
 						    "scsi(%ld): mbx "
 						    "abort_command success\n",
 						    vha->host_no));
 						bsg_job->req->errors =
-						bsg_job->reply->result = 0;
+						bsg_reply->result = 0;
 					}
 					spin_lock_irqsave(&ha->hardware_lock, flags);
 					goto done;
@@ -1537,12 +1566,12 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	DEBUG2(qla_printk(KERN_INFO, ha,
 		"scsi(%ld) SRB not found to abort\n", vha->host_no));
-	bsg_job->req->errors = bsg_job->reply->result = -ENXIO;
+	bsg_job->req->errors = bsg_reply->result = -ENXIO;
 	return 0;
 
 done:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
+	if (bsg_req->msgcode == FC_BSG_HST_CT)
 		kfree(sp->fcport);
 	kfree(sp->ctx);
 	mempool_free(sp, ha->srb_mempool);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cc5a792..82253c3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -31,6 +31,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_bsg.h>
 #include <scsi/scsi_bsg_fc.h>
 
 #include "qla_bsg.h"
@@ -273,7 +274,7 @@ struct srb_ctx {
 	char *name;
 	union {
 		struct srb_iocb *iocb_cmd;
-		struct fc_bsg_job *bsg_job;
+		struct scsi_bsg_job *bsg_job;
 	} u;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0b38122..6b6da33 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -568,8 +568,8 @@ extern int qla82xx_fcoe_ctx_reset(scsi_qla_host_t *);
 extern void qla82xx_chip_reset_cleanup(scsi_qla_host_t *);
 
 /* BSG related functions */
-extern int qla24xx_bsg_request(struct fc_bsg_job *);
-extern int qla24xx_bsg_timeout(struct fc_bsg_job *);
+extern int qla24xx_bsg_request(struct scsi_bsg_job *);
+extern int qla24xx_bsg_timeout(struct scsi_bsg_job *);
 extern int qla84xx_reset_chip(scsi_qla_host_t *, uint16_t);
 extern int qla2x00_issue_iocb_timeout(scsi_qla_host_t *, void *,
 	dma_addr_t, size_t, uint32_t);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7bac3cd..7eba83d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1799,7 +1799,8 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 static void
 qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 {
-	struct fc_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
+	struct scsi_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
+	struct fc_bsg_request *bsg_req = bsg_job->request;
 
         els_iocb->entry_type = ELS_IOCB_TYPE;
         els_iocb->entry_count = 1;
@@ -1814,8 +1815,8 @@ qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 
 	els_iocb->opcode =
 	    (((struct srb_ctx *)sp->ctx)->type == SRB_ELS_CMD_RPT) ?
-	    bsg_job->request->rqst_data.r_els.els_code :
-	    bsg_job->request->rqst_data.h_els.command_code;
+	    bsg_req->rqst_data.r_els.els_code :
+	    bsg_req->rqst_data.h_els.command_code;
         els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
         els_iocb->port_id[1] = sp->fcport->d_id.b.area;
         els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
@@ -1850,7 +1851,7 @@ qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
 	uint16_t tot_dsds;
 	scsi_qla_host_t *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct fc_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
+	struct scsi_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
 	int loop_iterartion = 0;
 	int cont_iocb_prsnt = 0;
 	int entry_count = 1;
@@ -1925,7 +1926,7 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 	int index;
 	uint16_t tot_dsds;
         scsi_qla_host_t *vha = sp->fcport->vha;
-	struct fc_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
+	struct scsi_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
 	int loop_iterartion = 0;
 	int cont_iocb_prsnt = 0;
 	int entry_count = 1;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1b60a95..12f10e7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1009,7 +1009,8 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
 	struct srb_ctx *sp_bsg;
-	struct fc_bsg_job *bsg_job;
+	struct scsi_bsg_job *bsg_job;
+	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
@@ -1018,6 +1019,7 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 	sp_bsg = sp->ctx;
 	bsg_job = sp_bsg->u.bsg_job;
+	bsg_reply = bsg_job->reply;
 
 	type = NULL;
 	switch (sp_bsg->type) {
@@ -1036,32 +1038,32 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	/* return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
 	 * fc payload  to the caller
 	 */
-	bsg_job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 
 	if (comp_status != CS_COMPLETE) {
 		if (comp_status == CS_DATA_UNDERRUN) {
-			bsg_job->reply->result = DID_OK << 16;
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->result = DID_OK << 16;
+			bsg_reply->reply_payload_rcv_len =
 			    le16_to_cpu(((sts_entry_t *)pkt)->rsp_info_len);
 
 			DEBUG2(qla_printk(KERN_WARNING, ha,
 			    "scsi(%ld): CT pass-through-%s error "
 			    "comp_status-status=0x%x total_byte = 0x%x.\n",
 			    vha->host_no, type, comp_status,
-			    bsg_job->reply->reply_payload_rcv_len));
+			    bsg_reply->reply_payload_rcv_len));
 		} else {
 			DEBUG2(qla_printk(KERN_WARNING, ha,
 			    "scsi(%ld): CT pass-through-%s error "
 			    "comp_status-status=0x%x.\n",
 			    vha->host_no, type, comp_status));
-			bsg_job->reply->result = DID_ERROR << 16;
-			bsg_job->reply->reply_payload_rcv_len = 0;
+			bsg_reply->result = DID_ERROR << 16;
+			bsg_reply->reply_payload_rcv_len = 0;
 		}
 		DEBUG2(qla2x00_dump_buffer((uint8_t *)pkt, sizeof(*pkt)));
 	} else {
-		bsg_job->reply->result =  DID_OK << 16;
-		bsg_job->reply->reply_payload_rcv_len =
+		bsg_reply->result =  DID_OK << 16;;
+		bsg_reply->reply_payload_rcv_len =
 		    bsg_job->reply_payload.payload_len;
 		bsg_job->reply_len = 0;
 	}
@@ -1077,7 +1079,8 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 	kfree(sp->ctx);
 	mempool_free(sp, ha->srb_mempool);
-	bsg_job->job_done(bsg_job);
+	bsg_job->job_done(bsg_job, bsg_reply->result,
+			  bsg_reply->reply_payload_rcv_len);
 }
 
 static void
@@ -1089,7 +1092,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
 	struct srb_ctx *sp_bsg;
-	struct fc_bsg_job *bsg_job;
+	struct scsi_bsg_job *bsg_job;
+	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	uint32_t fw_status[3];
 	uint8_t* fw_sts_ptr;
@@ -1099,6 +1103,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		return;
 	sp_bsg = sp->ctx;
 	bsg_job = sp_bsg->u.bsg_job;
+	bsg_reply = bsg_job->reply;
 
 	type = NULL;
 	switch (sp_bsg->type) {
@@ -1123,13 +1128,13 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	/* return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
 	 * fc payload  to the caller
 	 */
-	bsg_job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply) + sizeof(fw_status);
 
 	if (comp_status != CS_COMPLETE) {
 		if (comp_status == CS_DATA_UNDERRUN) {
-			bsg_job->reply->result = DID_OK << 16;
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->result = DID_OK << 16;
+			bsg_reply->reply_payload_rcv_len =
 				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->total_byte_count);
 
 			DEBUG2(qla_printk(KERN_WARNING, ha,
@@ -1147,16 +1152,16 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 				vha->host_no, sp->handle, type, comp_status,
 				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->error_subcode_1),
 				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->error_subcode_2)));
-			bsg_job->reply->result = DID_ERROR << 16;
-			bsg_job->reply->reply_payload_rcv_len = 0;
+			bsg_reply->result = DID_ERROR << 16;
+			bsg_reply->reply_payload_rcv_len = 0;
 			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
 		DEBUG2(qla2x00_dump_buffer((uint8_t *)pkt, sizeof(*pkt)));
 	}
 	else {
-		bsg_job->reply->result =  DID_OK << 16;
-		bsg_job->reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
+		bsg_reply->result =  DID_OK << 16;;
+		bsg_reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
 		bsg_job->reply_len = 0;
 	}
 
@@ -1171,7 +1176,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		kfree(sp->fcport);
 	kfree(sp->ctx);
 	mempool_free(sp, ha->srb_mempool);
-	bsg_job->job_done(bsg_job);
+	bsg_job->job_done(bsg_job, bsg_reply->result,
+			  bsg_reply->reply_payload_rcv_len);
 }
 
 static void
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f461925..a940435 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1214,6 +1214,22 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	return QLA_SUCCESS;
 }
 
+static void qla2x00_abort_bsg_job(struct qla_hw_data *ha, srb_t *sp, int res)
+{
+	struct srb_ctx *ctx = sp->ctx;
+	struct scsi_bsg_job *bsg_job = ctx->u.bsg_job;
+	struct fc_bsg_request *bsg_req = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+
+	if (bsg_req->msgcode == FC_BSG_HST_CT)
+		kfree(sp->fcport);
+	bsg_job->req->errors = 0;
+	bsg_reply->result = res;
+	bsg_job->job_done(bsg_job, res,	bsg_reply->reply_payload_rcv_len);
+	kfree(sp->ctx);
+	mempool_free(sp, ha->srb_mempool);
+}
+
 void
 qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 {
@@ -1243,19 +1259,9 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 					if (ctx->type == SRB_LOGIN_CMD ||
 					    ctx->type == SRB_LOGOUT_CMD) {
 						ctx->u.iocb_cmd->free(sp);
-					} else {
-						struct fc_bsg_job *bsg_job =
-						    ctx->u.bsg_job;
-						if (bsg_job->request->msgcode
-						    == FC_BSG_HST_CT)
-							kfree(sp->fcport);
-						bsg_job->req->errors = 0;
-						bsg_job->reply->result = res;
-						bsg_job->job_done(bsg_job);
-						kfree(sp->ctx);
-						mempool_free(sp,
-							ha->srb_mempool);
-					}
+					} else
+						qla2x00_abort_bsg_job(ha, sp,
+								      res);
 				}
 			}
 		}
-- 
1.7.2.3

