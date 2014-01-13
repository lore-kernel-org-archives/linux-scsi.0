From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 4/7] be2iscsi : Fix statistics update in the driver.
Date: Sun, 12 Jan 2014 16:42:17 -0800
Message-ID: <1389573741-3523-4-git-send-email-jayamohan.kallickal@emulex.com>
References: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54338 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaAMCiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2014 21:38:16 -0500
Received: by mail-pa0-f41.google.com with SMTP id fb1so5513839pad.0
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2014 18:38:16 -0800 (PST)
In-Reply-To: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Statistics counters which are added is
 - NOP IN/OUT counters
 - Login PDU counters
 - Text PDU counters
 - Logout PDU counters
 - ASYNC_PDU counters
 - Reject PDU counters
 - Digest Error counters

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   12 ++++++++++--
 drivers/scsi/be2iscsi/be_main.c  |   30 +++++++++++++++++++++++++++++-
 drivers/scsi/be2iscsi/be_main.h  |   19 +++++++++++++++++++
 3 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 2843a67..9ba2a64 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -899,6 +899,7 @@ void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 			    struct iscsi_stats *stats)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
 	struct beiscsi_hba *phba = NULL;
 
 	phba = ((struct beiscsi_conn *)conn->dd_data)->phba;
@@ -914,8 +915,15 @@ void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
 	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
 	stats->r2t_pdus = conn->r2t_pdus_cnt;
-	stats->digest_err = 0;
-	stats->timeout_err = 0;
+	stats->noptx_pdus = beiscsi_conn->noptx_pdus;
+	stats->noprx_pdus = beiscsi_conn->noprx_pdus;
+	stats->login_pdus = beiscsi_conn->login_pdus;
+	stats->text_pdus = beiscsi_conn->text_pdus;
+	stats->textrsp_pdus = beiscsi_conn->textrsp_pdus;
+	stats->logout_pdus = beiscsi_conn->logoutrsp_pdus;
+	stats->async_pdus = beiscsi_conn->async_pdus;
+	stats->rjt_pdus = beiscsi_conn->rjt_pdus;
+	stats->digest_err = beiscsi_conn->digest_err;
 	stats->custom_length = 0;
 	strcpy(stats->custom[0].desc, "eh_abort_cnt");
 	stats->custom[0].value = conn->eh_abort_cnt;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 89bf558..a045f06 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1180,8 +1180,10 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 	case ISCSI_OP_NOOP_IN:
 		pbuffer = NULL;
 		buf_len = 0;
+		beiscsi_conn->noprx_pdus++;
 		break;
 	case ISCSI_OP_ASYNC_EVENT:
+		beiscsi_conn->async_pdus++;
 		break;
 	case ISCSI_OP_REJECT:
 		WARN_ON(!pbuffer);
@@ -1189,6 +1191,7 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
 			    "BM_%d : In ISCSI_OP_REJECT\n");
+		beiscsi_conn->rjt_pdus++;
 		break;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
@@ -1196,6 +1199,9 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 		io_task = task->dd_data;
 		login_hdr = (struct iscsi_hdr *)ppdu;
 		login_hdr->itt = io_task->libiscsi_itt;
+
+		if (login_hdr->opcode == ISCSI_OP_TEXT_RSP)
+			beiscsi_conn->textrsp_pdus++;
 		break;
 	default:
 		beiscsi_log(phba, KERN_WARNING,
@@ -1404,6 +1410,8 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 
 		return;
 	}
+
+	conn->scsirsp_pdus_cnt++;
 	task->sc->result = (DID_OK << 16) | status;
 	if (rsp != ISCSI_STATUS_CMD_COMPLETED) {
 		task->sc->result = DID_ERROR << 16;
@@ -1464,6 +1472,8 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 	hdr->dlength[2] = 0;
 	hdr->hlength = 0;
 	hdr->itt = io_task->libiscsi_itt;
+
+	beiscsi_conn->logoutrsp_pdus++;
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
 }
 
@@ -1485,6 +1495,8 @@ be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 				     csol_cqe->cmd_wnd - 1);
 
 	hdr->itt = io_task->libiscsi_itt;
+
+	conn->tmfrsp_pdus_cnt++;
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
 }
 
@@ -1539,6 +1551,8 @@ be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,
 
 	hdr->opcode = ISCSI_OP_NOOP_IN;
 	hdr->itt = io_task->libiscsi_itt;
+
+	beiscsi_conn->noprx_pdus++;
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
 }
 
@@ -2240,7 +2254,14 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				    "BM_%d : Ignoring %s[%d] on CID : %d\n",
 				    cqe_desc[code], code, cid);
 			break;
+		case CXN_KILLED_HDR_DIGEST_ERR:
 		case SOL_CMD_KILLED_DATA_DIGEST_ERR:
+			beiscsi_conn->digest_err++;
+			beiscsi_log(phba, KERN_ERR,
+				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+				    "BM_%d : Cmd Notification %s[%d] on CID : %d\n",
+				    cqe_desc[code], code,  cid);
+			break;
 		case CMD_KILLED_INVALID_STATSN_RCVD:
 		case CMD_KILLED_INVALID_R2T_RCVD:
 		case CMD_CXN_KILLED_LUN_INVALID:
@@ -2254,6 +2275,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				    cqe_desc[code], code,  cid);
 			break;
 		case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
+			beiscsi_conn->digest_err++;
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
 				    "BM_%d :  Dropping %s[%d] on DPDU ring on CID : %d\n",
@@ -2266,7 +2288,6 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		case CXN_KILLED_PDU_SIZE_EXCEEDS_DSL:
 		case CXN_KILLED_BURST_LEN_MISMATCH:
 		case CXN_KILLED_AHS_RCVD:
-		case CXN_KILLED_HDR_DIGEST_ERR:
 		case CXN_KILLED_UNKNOWN_HDR:
 		case CXN_KILLED_STALE_ITT_TTT_RCVD:
 		case CXN_KILLED_INVALID_ITT_TTT_RCVD:
@@ -4923,6 +4944,7 @@ int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
 		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, type, pwrb,
 			      INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, dsp, pwrb, 1);
+		conn->txdata_octets += (xferlen + sg_dma_len(sg));
 	} else {
 		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, type, pwrb,
 			      INI_RD_CMD);
@@ -4987,6 +5009,7 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 			      INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
+		conn->txdata_octets += (xferlen + sg_dma_len(sg));
 	} else {
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 			      INI_RD_CMD);
@@ -5090,6 +5113,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	case ISCSI_OP_LOGIN:
 		AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb, 1);
 		ADAPTER_SET_WRB_TYPE(pwrb, TGT_DM_CMD, pwrb_typeoffset);
+		beiscsi_conn->login_pdus++;
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_NOOP_OUT:
@@ -5110,18 +5134,22 @@ static int beiscsi_mtask(struct iscsi_task *task)
 				AMAP_SET_BITS(struct amap_iscsi_wrb_v2,
 					      dmsg, pwrb, 0);
 		}
+		beiscsi_conn->noptx_pdus++;
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_TEXT:
 		ADAPTER_SET_WRB_TYPE(pwrb, TGT_DM_CMD, pwrb_typeoffset);
+		beiscsi_conn->text_pdus++;
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
 		ADAPTER_SET_WRB_TYPE(pwrb, INI_TMF_CMD, pwrb_typeoffset);
+		conn->tmfcmd_pdus_cnt++;
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_LOGOUT:
 		ADAPTER_SET_WRB_TYPE(pwrb, HWH_TYPE_LOGOUT, pwrb_typeoffset);
+		beiscsi_conn->logout_pdus++;
 		hwi_write_buffer(pwrb, task);
 		break;
 
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 0076119..d21ad9e 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -449,6 +449,25 @@ struct beiscsi_conn {
 	struct sgl_handle *plogin_sgl_handle;
 	struct beiscsi_session *beiscsi_sess;
 	struct iscsi_task *task;
+
+	/* CXN statistics */
+	/* Xmit Counters */
+	uint32_t noptx_pdus;
+	uint32_t login_pdus;
+	uint32_t text_pdus;
+	uint32_t logout_pdus;
+	uint32_t snack_pdus;
+
+	/* Rx Counters */
+	uint32_t noprx_pdus;
+	uint32_t textrsp_pdus;
+	uint32_t logoutrsp_pdus;
+	uint32_t async_pdus;
+	uint32_t rjt_pdus;
+
+	/* Error Counters */
+	uint32_t digest_err;
+	uint32_t format_err;
 };
 
 /* This structure is used by the chip */
-- 
1.7.10.4

