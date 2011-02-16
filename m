From: michaelc@cs.wisc.edu
Subject: [PATCH 06/17] BNX2I: Added iSCSI text pdu support for iSCSI offload
Date: Wed, 16 Feb 2011 15:04:30 -0600
Message-ID: <1297890281-9076-7-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab1BPVEf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:35 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4Yic027063
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:35 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tst004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:34 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Eddie Wai <eddie.wai@broadcom.com>

This is part of an effort to support send target discovery via
the iSCSI offload path.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/bnx2i/bnx2i.h       |    2 +
 drivers/scsi/bnx2i/bnx2i_hwi.c   |  116 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    6 ++-
 3 files changed, 123 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 2756853..cfd5902 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -751,6 +751,8 @@ extern int bnx2i_send_iscsi_login(struct bnx2i_conn *conn,
 				  struct iscsi_task *mtask);
 extern int bnx2i_send_iscsi_tmf(struct bnx2i_conn *conn,
 				  struct iscsi_task *mtask);
+extern int bnx2i_send_iscsi_text(struct bnx2i_conn *conn,
+				 struct iscsi_task *mtask);
 extern int bnx2i_send_iscsi_scsicmd(struct bnx2i_conn *conn,
 				    struct bnx2i_cmd *cmnd);
 extern int bnx2i_send_iscsi_nopout(struct bnx2i_conn *conn,
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index c8eff57..1da34c0 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -445,6 +445,56 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 }
 
 /**
+ * bnx2i_send_iscsi_text - post iSCSI text WQE to hardware
+ * @conn:	iscsi connection
+ * @mtask:	driver command structure which is requesting
+ *		a WQE to sent to chip for further processing
+ *
+ * prepare and post an iSCSI Text request WQE to CNIC firmware
+ */
+int bnx2i_send_iscsi_text(struct bnx2i_conn *bnx2i_conn,
+			  struct iscsi_task *mtask)
+{
+	struct bnx2i_cmd *bnx2i_cmd;
+	struct bnx2i_text_request *text_wqe;
+	struct iscsi_text *text_hdr;
+	u32 dword;
+
+	bnx2i_cmd = (struct bnx2i_cmd *)mtask->dd_data;
+	text_hdr = (struct iscsi_text *)mtask->hdr;
+	text_wqe = (struct bnx2i_text_request *) bnx2i_conn->ep->qp.sq_prod_qe;
+
+	memset(text_wqe, 0, sizeof(struct bnx2i_text_request));
+
+	text_wqe->op_code = text_hdr->opcode;
+	text_wqe->op_attr = text_hdr->flags;
+	text_wqe->data_length = ntoh24(text_hdr->dlength);
+	text_wqe->itt = mtask->itt |
+		(ISCSI_TASK_TYPE_MPATH << ISCSI_TEXT_REQUEST_TYPE_SHIFT);
+	text_wqe->ttt = be32_to_cpu(text_hdr->ttt);
+
+	text_wqe->cmd_sn = be32_to_cpu(text_hdr->cmdsn);
+
+	text_wqe->resp_bd_list_addr_lo = (u32) bnx2i_conn->gen_pdu.resp_bd_dma;
+	text_wqe->resp_bd_list_addr_hi =
+			(u32) ((u64) bnx2i_conn->gen_pdu.resp_bd_dma >> 32);
+
+	dword = ((1 << ISCSI_TEXT_REQUEST_NUM_RESP_BDS_SHIFT) |
+		 (bnx2i_conn->gen_pdu.resp_buf_size <<
+		  ISCSI_TEXT_REQUEST_RESP_BUFFER_LENGTH_SHIFT));
+	text_wqe->resp_buffer = dword;
+	text_wqe->bd_list_addr_lo = (u32) bnx2i_conn->gen_pdu.req_bd_dma;
+	text_wqe->bd_list_addr_hi =
+			(u32) ((u64) bnx2i_conn->gen_pdu.req_bd_dma >> 32);
+	text_wqe->num_bds = 1;
+	text_wqe->cq_index = 0; /* CQ# used for completion, 5771x only */
+
+	bnx2i_ring_dbell_update_sq_params(bnx2i_conn, 1);
+	return 0;
+}
+
+
+/**
  * bnx2i_send_iscsi_scsicmd - post iSCSI scsicmd request WQE to hardware
  * @conn:	iscsi connection
  * @cmd:	driver command structure which is requesting
@@ -1428,6 +1478,68 @@ done:
 	return 0;
 }
 
+
+/**
+ * bnx2i_process_text_resp - this function handles iscsi text response
+ * @session:	iscsi session pointer
+ * @bnx2i_conn:	iscsi connection pointer
+ * @cqe:	pointer to newly DMA'ed CQE entry for processing
+ *
+ * process iSCSI Text Response CQE&  complete it to open-iscsi user daemon
+ */
+static int bnx2i_process_text_resp(struct iscsi_session *session,
+				   struct bnx2i_conn *bnx2i_conn,
+				   struct cqe *cqe)
+{
+	struct iscsi_conn *conn = bnx2i_conn->cls_conn->dd_data;
+	struct iscsi_task *task;
+	struct bnx2i_text_response *text;
+	struct iscsi_text_rsp *resp_hdr;
+	int pld_len;
+	int pad_len;
+
+	text = (struct bnx2i_text_response *) cqe;
+	spin_lock(&session->lock);
+	task = iscsi_itt_to_task(conn, text->itt & ISCSI_LOGIN_RESPONSE_INDEX);
+	if (!task)
+		goto done;
+
+	resp_hdr = (struct iscsi_text_rsp *)&bnx2i_conn->gen_pdu.resp_hdr;
+	memset(resp_hdr, 0, sizeof(struct iscsi_hdr));
+	resp_hdr->opcode = text->op_code;
+	resp_hdr->flags = text->response_flags;
+	resp_hdr->hlength = 0;
+
+	hton24(resp_hdr->dlength, text->data_length);
+	resp_hdr->itt = task->hdr->itt;
+	resp_hdr->ttt = cpu_to_be32(text->ttt);
+	resp_hdr->statsn = task->hdr->exp_statsn;
+	resp_hdr->exp_cmdsn = cpu_to_be32(text->exp_cmd_sn);
+	resp_hdr->max_cmdsn = cpu_to_be32(text->max_cmd_sn);
+	pld_len = text->data_length;
+	bnx2i_conn->gen_pdu.resp_wr_ptr = bnx2i_conn->gen_pdu.resp_buf +
+					  pld_len;
+	pad_len = 0;
+	if (pld_len & 0x3)
+		pad_len = 4 - (pld_len % 4);
+
+	if (pad_len) {
+		int i = 0;
+		for (i = 0; i < pad_len; i++) {
+			bnx2i_conn->gen_pdu.resp_wr_ptr[0] = 0;
+			bnx2i_conn->gen_pdu.resp_wr_ptr++;
+		}
+	}
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr,
+			     bnx2i_conn->gen_pdu.resp_buf,
+			     bnx2i_conn->gen_pdu.resp_wr_ptr -
+			     bnx2i_conn->gen_pdu.resp_buf);
+done:
+	spin_unlock(&session->lock);
+	return 0;
+}
+
+
 /**
  * bnx2i_process_tmf_resp - this function handles iscsi TMF response
  * @session:		iscsi session pointer
@@ -1769,6 +1881,10 @@ static void bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 			bnx2i_process_tmf_resp(session, bnx2i_conn,
 					       qp->cq_cons_qe);
 			break;
+		case ISCSI_OP_TEXT_RSP:
+			bnx2i_process_text_resp(session, bnx2i_conn,
+						qp->cq_cons_qe);
+			break;
 		case ISCSI_OP_LOGOUT_RSP:
 			bnx2i_process_logout_resp(session, bnx2i_conn,
 						  qp->cq_cons_qe);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f9415aa..05bb808 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1092,6 +1092,9 @@ static int bnx2i_iscsi_send_generic_request(struct iscsi_task *task)
 	case ISCSI_OP_SCSI_TMFUNC:
 		rc = bnx2i_send_iscsi_tmf(bnx2i_conn, task);
 		break;
+	case ISCSI_OP_TEXT:
+		rc = bnx2i_send_iscsi_text(bnx2i_conn, task);
+		break;
 	default:
 		iscsi_conn_printk(KERN_ALERT, bnx2i_conn->cls_conn->dd_data,
 				  "send_gen: unsupported op 0x%x\n",
@@ -2167,7 +2170,8 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.name			= "bnx2i",
 	.caps			= CAP_RECOVERY_L0 | CAP_HDRDGST |
 				  CAP_MULTI_R2T | CAP_DATADGST |
-				  CAP_DATA_PATH_OFFLOAD,
+				  CAP_DATA_PATH_OFFLOAD |
+				  CAP_TEXT_NEGO,
 	.param_mask		= ISCSI_MAX_RECV_DLENGTH |
 				  ISCSI_MAX_XMIT_DLENGTH |
 				  ISCSI_HDRDGST_EN |
-- 
1.7.2.3

