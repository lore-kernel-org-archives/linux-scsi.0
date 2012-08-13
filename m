From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 6/7] Fix a kernel panic because of TCP RST/FIN received.
Date: Mon, 13 Aug 2012 16:00:45 +0530
Message-ID: <c7324159-2925-438f-8422-f639ef567621@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:48067 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2HMKbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2012 06:31:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 A TCP RST/FIN can be received even before the connection specific
 structures are initialized.This fix checks for the conn structure
 is intialized or not  when RST/FIN is received.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   51 ++++++++++++++++++++++++-----------
 drivers/scsi/be2iscsi/be_iscsi.h |    3 ++
 drivers/scsi/be2iscsi/be_main.c  |   55 ++++++++++++++++++-------------------
 drivers/scsi/be2iscsi/be_mgmt.h  |    1 +
 4 files changed, 66 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 17b0907..8851add 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1254,8 +1254,6 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct beiscsi_hba *phba;
-	unsigned int tag;
-	unsigned short savecfg_flag = CMD_ISCSI_SESSION_SAVE_CFG_ON_FLASH;
 
 	beiscsi_ep = ep->dd_data;
 	phba = beiscsi_ep->phba;
@@ -1263,34 +1261,55 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 			"BS_%d : In beiscsi_ep_disconnect for ep_cid = %d\n",
 			beiscsi_ep->ep_cid);
 
-	if (!beiscsi_ep->conn) {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-				"BS_%d : In beiscsi_ep_disconnect, no "
-				"beiscsi_ep\n");
-		return;
+	if (beiscsi_ep->conn) {
+		beiscsi_conn = beiscsi_ep->conn;
+		iscsi_suspend_queue(beiscsi_conn->conn);
 	}
-	beiscsi_conn = beiscsi_ep->conn;
-	iscsi_suspend_queue(beiscsi_conn->conn);
+
+	/* Cleanup the EP related info */
+	beiscsi_ep_cleanup(beiscsi_ep, ~BEISCSI_NO_RST_ISSUE,
+			CONNECTION_UPLOAD_GRACEFUL);
+}
+
+/**
+  * beiscsi_ep_cleanup : Cleanup of the endpoint.
+  * @beiscsi_ep : pointer to driver ep
+  * @mgmt_invalidate_flag	: Flag to pass while invalidating
+  *						  the connection.
+  * @tcp_upload_flag	: Flag to pass while uploading the
+  *						  the connection
+  *
+  * Invalidates the connection and upload the connection
+  * back to the FW. Does cleanup of info related to the
+  * endpoint.
+  *
+  **/
+void beiscsi_ep_cleanup(struct beiscsi_endpoint *beiscsi_ep,
+		uint8_t mgmt_invalidate_flag,
+		uint8_t tcp_upload_flag)
+{
+	struct beiscsi_hba *phba = beiscsi_ep->phba;
+	unsigned int tag;
+	unsigned short savecfg_flag = CMD_ISCSI_SESSION_SAVE_CFG_ON_FLASH;
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			"BS_%d : In beiscsi_ep_disconnect ep_cid = %d\n",
+			"BS_%d : In beiscsi_ep_cleanup for ep_cid = %d\n",
 			beiscsi_ep->ep_cid);
 
 	tag = mgmt_invalidate_connection(phba, beiscsi_ep,
-					    beiscsi_ep->ep_cid, 1,
-					    savecfg_flag);
+			beiscsi_ep->ep_cid, mgmt_invalidate_flag,
+			savecfg_flag);
 	if (!tag) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				"BS_%d : mgmt_invalidate_connection"
-				" Failed for cid=%d\n",
+				"BS_%d : mgmt_invalidate_connection Failed for cid=%d\n",
 				beiscsi_ep->ep_cid);
 	} else {
 		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
-					 phba->ctrl.mcc_numtag[tag]);
+				phba->ctrl.mcc_numtag[tag]);
 		free_mcc_tag(&phba->ctrl, tag);
 	}
 
-	beiscsi_close_conn(beiscsi_ep, CONNECTION_UPLOAD_GRACEFUL);
+	beiscsi_close_conn(beiscsi_ep, tcp_upload_flag);
 	beiscsi_free_ep(beiscsi_ep);
 	beiscsi_unbind_conn_to_cid(phba, beiscsi_ep->ep_cid);
 	iscsi_destroy_endpoint(beiscsi_ep->openiscsi_ep);
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 8b826fc..24c26ff 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -88,4 +88,7 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep);
 void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 			    struct iscsi_stats *stats);
 
+void beiscsi_ep_cleanup(struct beiscsi_endpoint *beiscsi_ep,
+		uint8_t mgmt_invalidate_flag,
+		uint8_t tcp_upload_flag);
 #endif
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 548f2e7..46d88e0 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -42,6 +42,7 @@
 #include "be_main.h"
 #include "be_iscsi.h"
 #include "be_mgmt.h"
+#include "be_cmds.h"
 
 static unsigned int be_iopoll_budget = 10;
 static unsigned int be_max_phys_size = 64;
@@ -1920,6 +1921,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 	struct dmsg_cqe *dmsg;
 	unsigned int num_processed = 0;
 	unsigned int tot_nump = 0;
+	unsigned short code = 0, cid = 0;
 	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_endpoint *ep;
@@ -1933,10 +1935,11 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 	       CQE_VALID_MASK) {
 		be_dws_le_to_cpu(sol, sizeof(struct sol_cqe));
 
-		ep = phba->ep_array[(u32) ((sol->
-				   dw[offsetof(struct amap_sol_cqe, cid) / 32] &
-				   SOL_CID_MASK) >> 6) -
-				   phba->fw_config.iscsi_cid_start];
+		cid = ((sol->dw[offsetof(struct amap_sol_cqe, cid) /
+					32] & CQE_CID_MASK) >> 6);
+		code = (sol->dw[offsetof(struct amap_sol_cqe, code) /
+				32] & CQE_CODE_MASK);
+		ep = phba->ep_array[cid - phba->fw_config.iscsi_cid_start];
 
 		beiscsi_ep = ep->dd_data;
 		beiscsi_conn = beiscsi_ep->conn;
@@ -1948,8 +1951,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 			num_processed = 0;
 		}
 
-		switch ((u32) sol->dw[offsetof(struct amap_sol_cqe, code) /
-			32] & CQE_CODE_MASK) {
+		switch (code) {
 		case SOL_CMD_COMPLETE:
 			hwi_complete_cmd(beiscsi_conn, phba, sol);
 			break;
@@ -1996,11 +1998,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 			beiscsi_log(phba, KERN_ERR,
 					BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
 					"BM_%d : CQ Error notification for cmd.. "
-					"code %d cid 0x%x\n",
-					sol->dw[offsetof(struct amap_sol_cqe,
-						code) / 32] & CQE_CODE_MASK,
-					sol->dw[offsetof(struct amap_sol_cqe,
-						cid) / 32] & SOL_CID_MASK);
+					"code %d cid 0x%x\n", code, cid);
 			break;
 		case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
 			beiscsi_log(phba, KERN_ERR,
@@ -2027,12 +2025,14 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 			beiscsi_log(phba, KERN_ERR,
 					BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
 					"BM_%d : CQ Error %d, reset CID 0x%x...\n",
-					sol->dw[offsetof(struct amap_sol_cqe,
-						code) / 32] & CQE_CODE_MASK,
-					sol->dw[offsetof(struct amap_sol_cqe,
-						cid) / 32] & CQE_CID_MASK);
-			iscsi_conn_failure(beiscsi_conn->conn,
-					   ISCSI_ERR_CONN_FAILED);
+					code, cid);
+			if (beiscsi_conn)
+				iscsi_conn_failure(beiscsi_conn->conn,
+						ISCSI_ERR_CONN_FAILED);
+			else
+				beiscsi_ep_cleanup(beiscsi_ep,
+						BEISCSI_NO_RST_ISSUE,
+						CONNECTION_UPLOAD_ABORT);
 			break;
 		case CXN_KILLED_RST_SENT:
 		case CXN_KILLED_RST_RCVD:
@@ -2040,23 +2040,22 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 					BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
 					"BM_%d : CQ Error %d, reset"
 					"received/sent on CID 0x%x...\n",
-					sol->dw[offsetof(struct amap_sol_cqe,
-						code) / 32] & CQE_CODE_MASK,
-					sol->dw[offsetof(struct amap_sol_cqe,
-						cid) / 32] & CQE_CID_MASK);
-			iscsi_conn_failure(beiscsi_conn->conn,
-					   ISCSI_ERR_CONN_FAILED);
+					code, cid);
+			if (beiscsi_conn)
+				iscsi_conn_failure(beiscsi_conn->conn,
+						ISCSI_ERR_CONN_FAILED);
+			else
+				beiscsi_ep_cleanup(beiscsi_ep,
+						BEISCSI_NO_RST_ISSUE,
+						CONNECTION_UPLOAD_ABORT);
 			break;
 		default:
 			beiscsi_log(phba, KERN_ERR,
 					BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
 					"BM_%d : CQ Error Invalid code= %d "
 					"received on CID 0x%x...\n",
-					sol->dw[offsetof(struct amap_sol_cqe,
-						code) / 32] & CQE_CODE_MASK,
-					sol->dw[offsetof(struct amap_sol_cqe,
-						cid) / 32] & CQE_CID_MASK);
-			break;
+					code, cid);
+					break;
 		}
 
 		AMAP_SET_BITS(struct amap_sol_cqe, valid, sol, 0);
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index f5b0074..9b0f299 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -108,6 +108,7 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 					 struct bsg_job *job,
 					 struct be_dma_mem *nonemb_cmd);
 
+#define BEISCSI_NO_RST_ISSUE	0
 struct iscsi_invalidate_connection_params_in {
 	struct be_cmd_req_hdr hdr;
 	unsigned int session_handle;
-- 
1.7.1

