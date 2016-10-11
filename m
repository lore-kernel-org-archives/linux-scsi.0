From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 06/44] qla2xxx: don't use fc_bsg_job::request and fc_bsg_job::reply directly
Date: Tue, 11 Oct 2016 13:28:37 +0200
Message-ID: <d8005d92e5518518360113d50dca54126c592d8e.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
helper variables bsg_request and bsg_reply. This will be helpfull when
transitioning to bsg-lib.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla2xxx/qla_bsg.c  | 264 +++++++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_iocb.c |   5 +-
 drivers/scsi/qla2xxx/qla_isr.c  |  46 ++++---
 drivers/scsi/qla2xxx/qla_mr.c   |  10 +-
 4 files changed, 189 insertions(+), 136 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 643014f..40f7c10 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -17,8 +17,9 @@ qla2x00_bsg_job_done(void *data, void *ptr, int res)
 	srb_t *sp = (srb_t *)ptr;
 	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
 	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
-	bsg_job->reply->result = res;
+	bsg_reply->result = res;
 	bsg_job->job_done(bsg_job);
 	sp->free(vha, sp);
 }
@@ -29,12 +30,14 @@ qla2x00_bsg_sp_free(void *data, void *ptr)
 	srb_t *sp = (srb_t *)ptr;
 	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_mt_iocb_rqst_fx00 *piocb_rqst;
 
 	if (sp->type == SRB_FXIOCB_BCMD) {
 		piocb_rqst = (struct qla_mt_iocb_rqst_fx00 *)
-		    &bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+		    &bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 		if (piocb_rqst->flags & SRB_FXDISC_REQ_DMA_VALID)
 			dma_unmap_sg(&ha->pdev->dev,
@@ -119,6 +122,8 @@ static int
 qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 {
 	struct Scsi_Host *host = bsg_job->shost;
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int ret = 0;
@@ -131,7 +136,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 	}
 
 	/* Get the sub command */
-	oper = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	oper = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	/* Only set config is allowed if config memory is not allocated */
 	if (!ha->fcp_prio_cfg && (oper != QLFC_FCP_PRIO_SET_CONFIG)) {
@@ -145,10 +150,10 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
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
@@ -160,10 +165,10 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
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
@@ -173,12 +178,12 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
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
@@ -189,7 +194,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 	case QLFC_FCP_PRIO_SET_CONFIG:
 		len = bsg_job->request_payload.payload_len;
 		if (!len || len > FCP_PRIO_CFG_SIZE) {
-			bsg_job->reply->result = (DID_ERROR << 16);
+			bsg_reply->result = (DID_ERROR << 16);
 			ret = -EINVAL;
 			goto exit_fcp_prio_cfg;
 		}
@@ -200,7 +205,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 				ql_log(ql_log_warn, vha, 0x7050,
 				    "Unable to allocate memory for fcp prio "
 				    "config data (%x).\n", FCP_PRIO_CFG_SIZE);
-				bsg_job->reply->result = (DID_ERROR << 16);
+				bsg_reply->result = (DID_ERROR << 16);
 				ret = -ENOMEM;
 				goto exit_fcp_prio_cfg;
 			}
@@ -215,7 +220,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 
 		if (!qla24xx_fcp_prio_cfg_valid(vha,
 		    (struct qla_fcp_prio_cfg *) ha->fcp_prio_cfg, 1)) {
-			bsg_job->reply->result = (DID_ERROR << 16);
+			bsg_reply->result = (DID_ERROR << 16);
 			ret = -EINVAL;
 			/* If buffer was invalidatic int
 			 * fcp_prio_cfg is of no use
@@ -229,7 +234,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 		if (ha->fcp_prio_cfg->attributes & FCP_PRIO_ATTR_ENABLE)
 			ha->flags.fcp_prio_enabled = 1;
 		qla24xx_update_all_fcp_prio(vha);
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 		break;
 	default:
 		ret = -EINVAL;
@@ -244,6 +249,7 @@ exit_fcp_prio_cfg:
 static int
 qla2x00_process_els(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_rport *rport;
 	fc_port_t *fcport = NULL;
 	struct Scsi_Host *host;
@@ -255,7 +261,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	int rval =  (DRIVER_ERROR << 16);
 	uint16_t nextlid = 0;
 
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = bsg_job->rport;
 		fcport = *(fc_port_t **) rport->dd_data;
 		host = rport_to_shost(rport);
@@ -296,7 +302,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	}
 
 	/* ELS request for rport */
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		/* make sure the rport is logged in,
 		 * if not perform fabric login
 		 */
@@ -322,11 +328,11 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 		/* Initialize all required  fields of fcport */
 		fcport->vha = vha;
 		fcport->d_id.b.al_pa =
-			bsg_job->request->rqst_data.h_els.port_id[0];
+			bsg_request->rqst_data.h_els.port_id[0];
 		fcport->d_id.b.area =
-			bsg_job->request->rqst_data.h_els.port_id[1];
+			bsg_request->rqst_data.h_els.port_id[1];
 		fcport->d_id.b.domain =
-			bsg_job->request->rqst_data.h_els.port_id[2];
+			bsg_request->rqst_data.h_els.port_id[2];
 		fcport->loop_id =
 			(fcport->d_id.b.al_pa == 0xFD) ?
 			NPH_FABRIC_CONTROLLER : NPH_F_PORT;
@@ -366,11 +372,11 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	}
 
 	sp->type =
-		(bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
-		SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
+		(bsg_request->msgcode == FC_BSG_RPT_ELS ?
+		 SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
 	sp->name =
-		(bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
-		"bsg_els_rpt" : "bsg_els_hst");
+		(bsg_request->msgcode == FC_BSG_RPT_ELS ?
+		 "bsg_els_rpt" : "bsg_els_hst");
 	sp->u.bsg_job = bsg_job;
 	sp->free = qla2x00_bsg_sp_free;
 	sp->done = qla2x00_bsg_job_done;
@@ -378,7 +384,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	ql_dbg(ql_dbg_user, vha, 0x700a,
 	    "bsg rqst type: %s els type: %x - loop-id=%x "
 	    "portid=%-2x%02x%02x.\n", type,
-	    bsg_job->request->rqst_data.h_els.command_code, fcport->loop_id,
+	    bsg_request->rqst_data.h_els.command_code, fcport->loop_id,
 	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	rval = qla2x00_start_sp(sp);
@@ -399,7 +405,7 @@ done_unmap_sg:
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS)
+	if (bsg_request->msgcode == FC_BSG_RPT_ELS)
 		kfree(fcport);
 done:
 	return rval;
@@ -423,6 +429,7 @@ static int
 qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 {
 	srb_t *sp;
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -469,7 +476,7 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	}
 
 	loop_id =
-		(bsg_job->request->rqst_data.h_ct.preamble_word1 & 0xFF000000)
+		(bsg_request->rqst_data.h_ct.preamble_word1 & 0xFF000000)
 			>> 24;
 	switch (loop_id) {
 	case 0xFC:
@@ -500,9 +507,9 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 
 	/* Initialize all required  fields of fcport */
 	fcport->vha = vha;
-	fcport->d_id.b.al_pa = bsg_job->request->rqst_data.h_ct.port_id[0];
-	fcport->d_id.b.area = bsg_job->request->rqst_data.h_ct.port_id[1];
-	fcport->d_id.b.domain = bsg_job->request->rqst_data.h_ct.port_id[2];
+	fcport->d_id.b.al_pa = bsg_request->rqst_data.h_ct.port_id[0];
+	fcport->d_id.b.area = bsg_request->rqst_data.h_ct.port_id[1];
+	fcport->d_id.b.domain = bsg_request->rqst_data.h_ct.port_id[2];
 	fcport->loop_id = loop_id;
 
 	/* Alloc SRB structure */
@@ -524,7 +531,7 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	ql_dbg(ql_dbg_user, vha, 0x7016,
 	    "bsg rqst type: %s else type: %x - "
 	    "loop-id=%x portid=%02x%02x%02x.\n", type,
-	    (bsg_job->request->rqst_data.h_ct.preamble_word2 >> 16),
+	    (bsg_request->rqst_data.h_ct.preamble_word2 >> 16),
 	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
 	    fcport->d_id.b.al_pa);
 
@@ -699,6 +706,8 @@ done_set_internal:
 static int
 qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -780,9 +789,9 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	elreq.rcv_dma = rsp_data_dma;
 	elreq.transfer_size = req_data_len;
 
-	elreq.options = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	elreq.options = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	elreq.iteration_count =
-	    bsg_job->request->rqst_data.h_vendor.vendor_cmd[2];
+	    bsg_request->rqst_data.h_vendor.vendor_cmd[2];
 
 	if (atomic_read(&vha->loop_state) == LOOP_READY &&
 	    (ha->current_topology == ISP_CFG_F ||
@@ -896,12 +905,12 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 		    "Vendor request %s failed.\n", type);
 
 		rval = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
-		bsg_job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->result = (DID_ERROR << 16);
+		bsg_reply->reply_payload_rcv_len = 0;
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x702d,
 		    "Vendor request %s completed.\n", type);
-		bsg_job->reply->result = (DID_OK << 16);
+		bsg_reply->result = (DID_OK << 16);
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 			bsg_job->reply_payload.sg_cnt, rsp_data,
 			rsp_data_len);
@@ -937,7 +946,9 @@ done_unmap_req_sg:
 static int
 qla84xx_reset(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct Scsi_Host *host = bsg_job->shost;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -948,7 +959,7 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
-	flag = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	flag = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	rval = qla84xx_reset_chip(vha, flag == A84_ISSUE_RESET_DIAG_FW);
 
@@ -960,7 +971,7 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x7031,
 		    "Vendor request 84xx reset completed.\n");
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 		bsg_job->job_done(bsg_job);
 	}
 
@@ -970,6 +981,8 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
 static int
 qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1027,7 +1040,7 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 		goto done_free_fw_buf;
 	}
 
-	flag = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	flag = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	fw_ver = le32_to_cpu(*((uint32_t *)((uint32_t *)fw_buf + 2)));
 
 	memset(mn, 0, sizeof(struct access_chip_84xx));
@@ -1059,7 +1072,7 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 		    "Vendor request 84xx updatefw completed.\n");
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 	}
 
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
@@ -1079,6 +1092,8 @@ done_unmap_sg:
 static int
 qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1107,7 +1122,7 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 	memset(mn, 0, sizeof(struct access_chip_84xx));
 	mn->entry_type = ACCESS_CHIP_IOCB_TYPE;
 	mn->entry_count = 1;
-	ql84_mgmt = (void *)bsg_job->request + sizeof(struct fc_bsg_request);
+	ql84_mgmt = (void *)bsg_request + sizeof(struct fc_bsg_request);
 	switch (ql84_mgmt->mgmt.cmd) {
 	case QLA84_MGMT_READ_MEM:
 	case QLA84_MGMT_GET_INFO:
@@ -1239,11 +1254,11 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		    "Vendor request 84xx mgmt completed.\n");
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 
 		if ((ql84_mgmt->mgmt.cmd == QLA84_MGMT_READ_MEM) ||
 			(ql84_mgmt->mgmt.cmd == QLA84_MGMT_GET_INFO)) {
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				bsg_job->reply_payload.payload_len;
 
 			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
@@ -1274,6 +1289,8 @@ exit_mgmt:
 static int
 qla24xx_iidma(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
@@ -1288,7 +1305,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
-	port_param = (void *)bsg_job->request + sizeof(struct fc_bsg_request);
+	port_param = (void *)bsg_request + sizeof(struct fc_bsg_request);
 	if (port_param->fc_scsi_addr.dest_type != EXT_DEF_TYPE_WWPN) {
 		ql_log(ql_log_warn, vha, 0x7048,
 		    "Invalid destination type.\n");
@@ -1343,14 +1360,14 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 			bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
 				sizeof(struct qla_port_param);
 
-			rsp_ptr = ((uint8_t *)bsg_job->reply) +
+			rsp_ptr = ((uint8_t *)bsg_reply) +
 				sizeof(struct fc_bsg_reply);
 
 			memcpy(rsp_ptr, port_param,
 				sizeof(struct qla_port_param));
 		}
 
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 		bsg_job->job_done(bsg_job);
 	}
 
@@ -1361,6 +1378,7 @@ static int
 qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, scsi_qla_host_t *vha,
 	uint8_t is_update)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	uint32_t start = 0;
 	int valid = 0;
 	struct qla_hw_data *ha = vha->hw;
@@ -1368,7 +1386,7 @@ qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, scsi_qla_host_t *vha,
 	if (unlikely(pci_channel_offline(ha->pdev)))
 		return -EINVAL;
 
-	start = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	if (start > ha->optrom_size) {
 		ql_log(ql_log_warn, vha, 0x7055,
 		    "start %d > optrom_size %d.\n", start, ha->optrom_size);
@@ -1429,6 +1447,7 @@ qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, scsi_qla_host_t *vha,
 static int
 qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1451,8 +1470,8 @@ qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 	    bsg_job->reply_payload.sg_cnt, ha->optrom_buffer,
 	    ha->optrom_region_size);
 
-	bsg_job->reply->reply_payload_rcv_len = ha->optrom_region_size;
-	bsg_job->reply->result = DID_OK;
+	bsg_reply->reply_payload_rcv_len = ha->optrom_region_size;
+	bsg_reply->result = DID_OK;
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
@@ -1464,6 +1483,7 @@ qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 static int
 qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1486,7 +1506,7 @@ qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 	ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
 	    ha->optrom_region_start, ha->optrom_region_size);
 
-	bsg_job->reply->result = DID_OK;
+	bsg_reply->result = DID_OK;
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
@@ -1498,6 +1518,7 @@ qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 static int
 qla2x00_update_fru_versions(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1509,7 +1530,7 @@ qla2x00_update_fru_versions(struct fc_bsg_job *bsg_job)
 	dma_addr_t sfp_dma;
 	void *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 	if (!sfp) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_NO_MEMORY;
 		goto done;
 	}
@@ -1525,21 +1546,21 @@ qla2x00_update_fru_versions(struct fc_bsg_job *bsg_job)
 		    image->field_address.device, image->field_address.offset,
 		    sizeof(image->field_info), image->field_address.option);
 		if (rval) {
-			bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+			bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 			    EXT_STATUS_MAILBOX;
 			goto dealloc;
 		}
 		image++;
 	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
 
 dealloc:
 	dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	return 0;
@@ -1548,6 +1569,7 @@ done:
 static int
 qla2x00_read_fru_status(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1557,7 +1579,7 @@ qla2x00_read_fru_status(struct fc_bsg_job *bsg_job)
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 	if (!sfp) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_NO_MEMORY;
 		goto done;
 	}
@@ -1571,7 +1593,7 @@ qla2x00_read_fru_status(struct fc_bsg_job *bsg_job)
 	sr->status_reg = *sfp;
 
 	if (rval) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_MAILBOX;
 		goto dealloc;
 	}
@@ -1579,15 +1601,15 @@ qla2x00_read_fru_status(struct fc_bsg_job *bsg_job)
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 	    bsg_job->reply_payload.sg_cnt, sr, sizeof(*sr));
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
 
 dealloc:
 	dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->reply_payload_rcv_len = sizeof(*sr);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->reply_payload_rcv_len = sizeof(*sr);
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	return 0;
@@ -1596,6 +1618,7 @@ done:
 static int
 qla2x00_write_fru_status(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1605,7 +1628,7 @@ qla2x00_write_fru_status(struct fc_bsg_job *bsg_job)
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 	if (!sfp) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_NO_MEMORY;
 		goto done;
 	}
@@ -1619,19 +1642,19 @@ qla2x00_write_fru_status(struct fc_bsg_job *bsg_job)
 	    sizeof(sr->status_reg), sr->field_address.option);
 
 	if (rval) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_MAILBOX;
 		goto dealloc;
 	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
 
 dealloc:
 	dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	return 0;
@@ -1640,6 +1663,7 @@ done:
 static int
 qla2x00_write_i2c(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1649,7 +1673,7 @@ qla2x00_write_i2c(struct fc_bsg_job *bsg_job)
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 	if (!sfp) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_NO_MEMORY;
 		goto done;
 	}
@@ -1662,19 +1686,19 @@ qla2x00_write_i2c(struct fc_bsg_job *bsg_job)
 	    i2c->device, i2c->offset, i2c->length, i2c->option);
 
 	if (rval) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_MAILBOX;
 		goto dealloc;
 	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
 
 dealloc:
 	dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	return 0;
@@ -1683,6 +1707,7 @@ done:
 static int
 qla2x00_read_i2c(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1692,7 +1717,7 @@ qla2x00_read_i2c(struct fc_bsg_job *bsg_job)
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 	if (!sfp) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_NO_MEMORY;
 		goto done;
 	}
@@ -1704,7 +1729,7 @@ qla2x00_read_i2c(struct fc_bsg_job *bsg_job)
 		i2c->device, i2c->offset, i2c->length, i2c->option);
 
 	if (rval) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_MAILBOX;
 		goto dealloc;
 	}
@@ -1713,15 +1738,15 @@ qla2x00_read_i2c(struct fc_bsg_job *bsg_job)
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 	    bsg_job->reply_payload.sg_cnt, i2c, sizeof(*i2c));
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
 
 dealloc:
 	dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->reply_payload_rcv_len = sizeof(*i2c);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->reply_payload_rcv_len = sizeof(*i2c);
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	return 0;
@@ -1730,6 +1755,7 @@ done:
 static int
 qla24xx_process_bidir_cmd(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1895,10 +1921,10 @@ done:
 	/* Return an error vendor specific response
 	 * and complete the bsg request
 	 */
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->reply_payload_rcv_len = 0;
-	bsg_job->reply->result = (DID_OK) << 16;
+	bsg_reply->reply_payload_rcv_len = 0;
+	bsg_reply->result = (DID_OK) << 16;
 	bsg_job->job_done(bsg_job);
 	/* Always return success, vendor rsp carries correct status */
 	return 0;
@@ -1907,6 +1933,7 @@ done:
 static int
 qlafx00_mgmt_cmd(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1919,7 +1946,7 @@ qlafx00_mgmt_cmd(struct fc_bsg_job *bsg_job)
 
 	/* Copy the IOCB specific information */
 	piocb_rqst = (struct qla_mt_iocb_rqst_fx00 *)
-	    &bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	    &bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	/* Dump the vendor information */
 	ql_dump_buffer(ql_dbg_user + ql_dbg_verbose , vha, 0x70cf,
@@ -2029,6 +2056,7 @@ done:
 static int
 qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
@@ -2042,13 +2070,13 @@ qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
 	switch (sr.cmd) {
 	case INT_SC_SERDES_WRITE_REG:
 		rval = qla2x00_write_serdes_word(vha, sr.addr, sr.val);
-		bsg_job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->reply_payload_rcv_len = 0;
 		break;
 	case INT_SC_SERDES_READ_REG:
 		rval = qla2x00_read_serdes_word(vha, sr.addr, &sr.val);
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 		    bsg_job->reply_payload.sg_cnt, &sr, sizeof(sr));
-		bsg_job->reply->reply_payload_rcv_len = sizeof(sr);
+		bsg_reply->reply_payload_rcv_len = sizeof(sr);
 		break;
 	default:
 		ql_dbg(ql_dbg_user, vha, 0x708c,
@@ -2057,11 +2085,11 @@ qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
 		break;
 	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    rval ? EXT_STATUS_MAILBOX : 0;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 	return 0;
 }
@@ -2069,6 +2097,7 @@ qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
 static int
 qla8044_serdes_op(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
@@ -2082,13 +2111,13 @@ qla8044_serdes_op(struct fc_bsg_job *bsg_job)
 	switch (sr.cmd) {
 	case INT_SC_SERDES_WRITE_REG:
 		rval = qla8044_write_serdes_word(vha, sr.addr, sr.val);
-		bsg_job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->reply_payload_rcv_len = 0;
 		break;
 	case INT_SC_SERDES_READ_REG:
 		rval = qla8044_read_serdes_word(vha, sr.addr, &sr.val);
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 		    bsg_job->reply_payload.sg_cnt, &sr, sizeof(sr));
-		bsg_job->reply->reply_payload_rcv_len = sizeof(sr);
+		bsg_reply->reply_payload_rcv_len = sizeof(sr);
 		break;
 	default:
 		ql_dbg(ql_dbg_user, vha, 0x70cf,
@@ -2097,11 +2126,11 @@ qla8044_serdes_op(struct fc_bsg_job *bsg_job)
 		break;
 	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    rval ? EXT_STATUS_MAILBOX : 0;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 	return 0;
 }
@@ -2109,6 +2138,7 @@ qla8044_serdes_op(struct fc_bsg_job *bsg_job)
 static int
 qla27xx_get_flash_upd_cap(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -2125,13 +2155,13 @@ qla27xx_get_flash_upd_cap(struct fc_bsg_job *bsg_job)
 
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 	    bsg_job->reply_payload.sg_cnt, &cap, sizeof(cap));
-	bsg_job->reply->reply_payload_rcv_len = sizeof(cap);
+	bsg_reply->reply_payload_rcv_len = sizeof(cap);
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 	return 0;
 }
@@ -2139,6 +2169,7 @@ qla27xx_get_flash_upd_cap(struct fc_bsg_job *bsg_job)
 static int
 qla27xx_set_flash_upd_cap(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -2158,24 +2189,24 @@ qla27xx_set_flash_upd_cap(struct fc_bsg_job *bsg_job)
 			 (uint64_t)ha->fw_attributes;
 
 	if (online_fw_attr != cap.capabilities) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_INVALID_PARAM;
 		return -EINVAL;
 	}
 
 	if (cap.outage_duration < MAX_LOOP_TIMEOUT)  {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_INVALID_PARAM;
 		return -EINVAL;
 	}
 
-	bsg_job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 	return 0;
 }
@@ -2183,6 +2214,7 @@ qla27xx_set_flash_upd_cap(struct fc_bsg_job *bsg_job)
 static int
 qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -2227,12 +2259,12 @@ qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_job)
 done:
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 		bsg_job->reply_payload.sg_cnt, &bbcr, sizeof(bbcr));
-	bsg_job->reply->reply_payload_rcv_len = sizeof(bbcr);
+	bsg_reply->reply_payload_rcv_len = sizeof(bbcr);
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 	return 0;
 }
@@ -2240,6 +2272,8 @@ done:
 static int
 qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -2247,7 +2281,7 @@ qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 	struct link_statistics *stats = NULL;
 	dma_addr_t stats_dma;
 	int rval;
-	uint32_t *cmd = bsg_job->request->rqst_data.h_vendor.vendor_cmd;
+	uint32_t *cmd = bsg_request->rqst_data.h_vendor.vendor_cmd;
 	uint options = cmd[0] == QL_VND_GET_PRIV_STATS_EX ? cmd[1] : 0;
 
 	if (test_bit(UNLOADING, &vha->dpc_flags))
@@ -2281,12 +2315,12 @@ qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 			bsg_job->reply_payload.sg_cnt, stats, sizeof(*stats));
 	}
 
-	bsg_job->reply->reply_payload_rcv_len = sizeof(*stats);
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_payload_rcv_len = sizeof(*stats);
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    rval ? EXT_STATUS_MAILBOX : EXT_STATUS_OK;
 
-	bsg_job->reply_len = sizeof(*bsg_job->reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_job->reply_len = sizeof(*bsg_reply);
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
@@ -2298,6 +2332,7 @@ qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 static int
 qla2x00_do_dport_diagnostics(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval;
@@ -2323,12 +2358,12 @@ qla2x00_do_dport_diagnostics(struct fc_bsg_job *bsg_job)
 		    bsg_job->reply_payload.sg_cnt, dd, sizeof(*dd));
 	}
 
-	bsg_job->reply->reply_payload_rcv_len = sizeof(*dd);
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_payload_rcv_len = sizeof(*dd);
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    rval ? EXT_STATUS_MAILBOX : EXT_STATUS_OK;
 
-	bsg_job->reply_len = sizeof(*bsg_job->reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_job->reply_len = sizeof(*bsg_reply);
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	kfree(dd);
@@ -2339,7 +2374,9 @@ qla2x00_do_dport_diagnostics(struct fc_bsg_job *bsg_job)
 static int
 qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 {
-	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+
+	switch (bsg_request->rqst_data.h_vendor.vendor_cmd[0]) {
 	case QL_VND_LOOPBACK:
 		return qla2x00_process_loopback(bsg_job);
 
@@ -2415,15 +2452,17 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 int
 qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	int ret = -EINVAL;
 	struct fc_rport *rport;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *vha;
 
 	/* In case no data transferred. */
-	bsg_job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = bsg_job->rport;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
@@ -2435,14 +2474,14 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 	if (qla2x00_reset_active(vha)) {
 		ql_dbg(ql_dbg_user, vha, 0x709f,
 		    "BSG: ISP abort active/needed -- cmd=%d.\n",
-		    bsg_job->request->msgcode);
+		    bsg_request->msgcode);
 		return -EBUSY;
 	}
 
 	ql_dbg(ql_dbg_user, vha, 0x7000,
-	    "Entered %s msgcode=0x%x.\n", __func__, bsg_job->request->msgcode);
+	    "Entered %s msgcode=0x%x.\n", __func__, bsg_request->msgcode);
 
-	switch (bsg_job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
 	case FC_BSG_HST_ELS_NOLOGIN:
 		ret = qla2x00_process_els(bsg_job);
@@ -2466,6 +2505,7 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 int
 qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(bsg_job->shost);
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
@@ -2494,13 +2534,13 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 						    "mbx abort_command "
 						    "failed.\n");
 						bsg_job->req->errors =
-						bsg_job->reply->result = -EIO;
+						bsg_reply->result = -EIO;
 					} else {
 						ql_dbg(ql_dbg_user, vha, 0x708a,
 						    "mbx abort_command "
 						    "success.\n");
 						bsg_job->req->errors =
-						bsg_job->reply->result = 0;
+						bsg_reply->result = 0;
 					}
 					spin_lock_irqsave(&ha->hardware_lock, flags);
 					goto done;
@@ -2510,7 +2550,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
-	bsg_job->req->errors = bsg_job->reply->result = -ENXIO;
+	bsg_job->req->errors = bsg_reply->result = -ENXIO;
 	return 0;
 
 done:
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b41265a..6929fda 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2198,6 +2198,7 @@ static void
 qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 {
 	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 
         els_iocb->entry_type = ELS_IOCB_TYPE;
         els_iocb->entry_count = 1;
@@ -2212,8 +2213,8 @@ qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 
 	els_iocb->opcode =
 	    sp->type == SRB_ELS_CMD_RPT ?
-	    bsg_job->request->rqst_data.r_els.els_code :
-	    bsg_job->request->rqst_data.h_els.command_code;
+	    bsg_request->rqst_data.r_els.els_code :
+	    bsg_request->rqst_data.h_els.command_code;
         els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
         els_iocb->port_id[1] = sp->fcport->d_id.b.area;
         els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 987f1c7..1adaad3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1357,6 +1357,7 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	const char *type;
 	srb_t *sp;
 	struct fc_bsg_job *bsg_job;
+	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	int res;
 
@@ -1365,6 +1366,7 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		return;
 
 	bsg_job = sp->u.bsg_job;
+	bsg_reply = bsg_job->reply;
 
 	type = "ct pass-through";
 
@@ -1373,32 +1375,32 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	/* return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
 	 * fc payload  to the caller
 	 */
-	bsg_job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 
 	if (comp_status != CS_COMPLETE) {
 		if (comp_status == CS_DATA_UNDERRUN) {
 			res = DID_OK << 16;
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 			    le16_to_cpu(((sts_entry_t *)pkt)->rsp_info_len);
 
 			ql_log(ql_log_warn, vha, 0x5048,
 			    "CT pass-through-%s error "
 			    "comp_status-status=0x%x total_byte = 0x%x.\n",
 			    type, comp_status,
-			    bsg_job->reply->reply_payload_rcv_len);
+			    bsg_reply->reply_payload_rcv_len);
 		} else {
 			ql_log(ql_log_warn, vha, 0x5049,
 			    "CT pass-through-%s error "
 			    "comp_status-status=0x%x.\n", type, comp_status);
 			res = DID_ERROR << 16;
-			bsg_job->reply->reply_payload_rcv_len = 0;
+			bsg_reply->reply_payload_rcv_len = 0;
 		}
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5035,
 		    (uint8_t *)pkt, sizeof(*pkt));
 	} else {
 		res = DID_OK << 16;
-		bsg_job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 		    bsg_job->reply_payload.payload_len;
 		bsg_job->reply_len = 0;
 	}
@@ -1414,6 +1416,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	const char *type;
 	srb_t *sp;
 	struct fc_bsg_job *bsg_job;
+	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	uint32_t fw_status[3];
 	uint8_t* fw_sts_ptr;
@@ -1423,6 +1426,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	if (!sp)
 		return;
 	bsg_job = sp->u.bsg_job;
+	bsg_reply = bsg_job->reply;
 
 	type = NULL;
 	switch (sp->type) {
@@ -1452,13 +1456,13 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	/* return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
 	 * fc payload  to the caller
 	 */
-	bsg_job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply) + sizeof(fw_status);
 
 	if (comp_status != CS_COMPLETE) {
 		if (comp_status == CS_DATA_UNDERRUN) {
 			res = DID_OK << 16;
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 			    le16_to_cpu(((struct els_sts_entry_24xx *)pkt)->total_byte_count);
 
 			ql_dbg(ql_dbg_user, vha, 0x503f,
@@ -1480,7 +1484,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			    le16_to_cpu(((struct els_sts_entry_24xx *)
 				    pkt)->error_subcode_2));
 			res = DID_ERROR << 16;
-			bsg_job->reply->reply_payload_rcv_len = 0;
+			bsg_reply->reply_payload_rcv_len = 0;
 			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
@@ -1489,7 +1493,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 	else {
 		res =  DID_OK << 16;
-		bsg_job->reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
+		bsg_reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
 		bsg_job->reply_len = 0;
 	}
 
@@ -1905,6 +1909,8 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	uint16_t thread_id;
 	uint32_t rval = EXT_STATUS_OK;
 	struct fc_bsg_job *bsg_job = NULL;
+	struct fc_bsg_request *bsg_request;
+	struct fc_bsg_reply *bsg_reply;
 	sts_entry_t *sts;
 	struct sts_entry_24xx *sts24;
 	sts = (sts_entry_t *) pkt;
@@ -1919,11 +1925,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	}
 
 	sp = req->outstanding_cmds[index];
-	if (sp) {
-		/* Free outstanding command slot. */
-		req->outstanding_cmds[index] = NULL;
-		bsg_job = sp->u.bsg_job;
-	} else {
+	if (!sp) {
 		ql_log(ql_log_warn, vha, 0x70b0,
 		    "Req:%d: Invalid ISP SCSI completion handle(0x%x)\n",
 		    req->id, index);
@@ -1932,6 +1934,12 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 		return;
 	}
 
+	/* Free outstanding command slot. */
+	req->outstanding_cmds[index] = NULL;
+	bsg_job = sp->u.bsg_job;
+	bsg_request = bsg_job->request;
+	bsg_reply = bsg_job->reply;
+
 	if (IS_FWI2_CAPABLE(ha)) {
 		comp_status = le16_to_cpu(sts24->comp_status);
 		scsi_status = le16_to_cpu(sts24->scsi_status) & SS_MASK;
@@ -1940,14 +1948,14 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 		scsi_status = le16_to_cpu(sts->scsi_status) & SS_MASK;
 	}
 
-	thread_id = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	thread_id = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	switch (comp_status) {
 	case CS_COMPLETE:
 		if (scsi_status == 0) {
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 					bsg_job->reply_payload.payload_len;
 			vha->qla_stats.input_bytes +=
-				bsg_job->reply->reply_payload_rcv_len;
+				bsg_reply->reply_payload_rcv_len;
 			vha->qla_stats.input_requests++;
 			rval = EXT_STATUS_OK;
 		}
@@ -2028,11 +2036,11 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 		rval = EXT_STATUS_ERR;
 		break;
 	}
-	bsg_job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 done:
 	/* Return the vendor specific reply to API */
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	/* Always return DID_OK, bsg will send the vendor specific response
 	 * in this case only */
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 15dff70..b597d04 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2207,6 +2207,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	const char func[] = "IOSB_IOCB";
 	srb_t *sp;
 	struct fc_bsg_job *bsg_job;
+	struct fc_bsg_reply *bsg_reply;
 	struct srb_iocb *iocb_job;
 	int res;
 	struct qla_mt_iocb_rsp_fx00 fstatus;
@@ -2226,6 +2227,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 			    pkt->dataword_r;
 	} else {
 		bsg_job = sp->u.bsg_job;
+		bsg_reply = bsg_job->reply;
 
 		memset(&fstatus, 0, sizeof(struct qla_mt_iocb_rsp_fx00));
 
@@ -2257,8 +2259,8 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    sp->fcport->vha, 0x5074,
 		    (uint8_t *)fw_sts_ptr, sizeof(struct qla_mt_iocb_rsp_fx00));
 
-		res = bsg_job->reply->result = DID_OK << 16;
-		bsg_job->reply->reply_payload_rcv_len =
+		res = bsg_reply->result = DID_OK << 16;
+		bsg_reply->reply_payload_rcv_len =
 		    bsg_job->reply_payload.payload_len;
 	}
 	sp->done(vha, sp, res);
@@ -3253,6 +3255,7 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_fx00 *pfxiocb)
 	struct srb_iocb *fxio = &sp->u.iocb_cmd;
 	struct qla_mt_iocb_rqst_fx00 *piocb_rqst;
 	struct fc_bsg_job *bsg_job;
+	struct fc_bsg_request *bsg_request;
 	struct fxdisc_entry_fx00 fx_iocb;
 	uint8_t entry_cnt = 1;
 
@@ -3301,8 +3304,9 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_fx00 *pfxiocb)
 	} else {
 		struct scatterlist *sg;
 		bsg_job = sp->u.bsg_job;
+		bsg_request = bsg_job->request;
 		piocb_rqst = (struct qla_mt_iocb_rqst_fx00 *)
-			&bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+			&bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 		fx_iocb.func_num = piocb_rqst->func_type;
 		fx_iocb.adapid = piocb_rqst->adapid;
-- 
1.8.5.6
