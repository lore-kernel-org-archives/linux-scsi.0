From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 13/22] be2iscsi: Fix connection offload to support Dual Chute
Date: Thu, 12 Sep 2013 22:10:03 -0700
Message-ID: <1379049014-32716-13-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56082 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3IMFgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:41 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so2075152pad.33
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:40 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 The connection is offload to each chute in a round-robin manner
 if both the chute is loaded with iSCSI protocol

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    6 ++++++
 drivers/scsi/be2iscsi/be_main.c  |   13 ++++++++-----
 drivers/scsi/be2iscsi/be_main.h  |    1 +
 drivers/scsi/be2iscsi/be_mgmt.c  |   19 ++++++++++++++++---
 4 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 09a09be..66c44c6 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -194,6 +194,8 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+	struct hwi_controller *phwi_ctrlr = phba->phwi_ctrlr;
+	struct hwi_wrb_context *pwrb_context;
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_endpoint *ep;
 
@@ -214,9 +216,13 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		return -EEXIST;
 	}
 
+	pwrb_context = &phwi_ctrlr->wrb_context[BE_GET_CRI_FROM_CID(
+						beiscsi_ep->ep_cid)];
+
 	beiscsi_conn->beiscsi_conn_cid = beiscsi_ep->ep_cid;
 	beiscsi_conn->ep = beiscsi_ep;
 	beiscsi_ep->conn = beiscsi_conn;
+	beiscsi_conn->doorbell_offset = pwrb_context->doorbell_offset;
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 		    "BS_%d : beiscsi_conn=%p conn=%p ep_cid=%d\n",
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1e0a8a2..02a7bf7 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4595,8 +4595,8 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	doorbell |= (pwrb_handle->wrb_index & DB_DEF_PDU_WRB_INDEX_MASK)
 			     << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
-
-	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
+	iowrite32(doorbell, phba->db_va +
+		  beiscsi_conn->doorbell_offset);
 }
 
 static void beiscsi_parse_pdu(struct iscsi_conn *conn, itt_t itt,
@@ -4821,7 +4821,8 @@ int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
 		     DB_DEF_PDU_WRB_INDEX_MASK) <<
 		     DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
-	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
+	iowrite32(doorbell, phba->db_va +
+		  beiscsi_conn->doorbell_offset);
 	return 0;
 }
 
@@ -4876,7 +4877,8 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 		     DB_DEF_PDU_WRB_INDEX_MASK) << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
 
-	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
+	iowrite32(doorbell, phba->db_va +
+		  beiscsi_conn->doorbell_offset);
 	return 0;
 }
 
@@ -4978,7 +4980,8 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	doorbell |= (io_task->pwrb_handle->wrb_index &
 		     DB_DEF_PDU_WRB_INDEX_MASK) << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
-	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
+	iowrite32(doorbell, phba->db_va +
+		  beiscsi_conn->doorbell_offset);
 	return 0;
 }
 
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index e5e0d7e..3fa1e81 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -425,6 +425,7 @@ struct beiscsi_conn {
 	struct iscsi_conn *conn;
 	struct beiscsi_hba *phba;
 	u32 exp_statsn;
+	u32 doorbell_offset;
 	u32 beiscsi_conn_cid;
 	struct beiscsi_endpoint *ep;
 	unsigned short login_in_progress;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 4bb1464..1622bb5 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -629,6 +629,16 @@ unsigned int mgmt_upload_connection(struct beiscsi_hba *phba,
 	return tag;
 }
 
+/**
+ * mgmt_open_connection()- Establish a TCP CXN
+ * @dst_addr: Destination Address
+ * @beiscsi_ep: ptr to device endpoint struct
+ * @nonemb_cmd: ptr to memory allocated for command
+ *
+ * return
+ *	Success: Tag number of the MBX Command issued
+ *	Failure: Error code
+ **/
 int mgmt_open_connection(struct beiscsi_hba *phba,
 			 struct sockaddr *dst_addr,
 			 struct beiscsi_endpoint *beiscsi_ep,
@@ -646,14 +656,17 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	struct phys_addr template_address = { 0, 0 };
 	struct phys_addr *ptemplate_address;
 	unsigned int tag = 0;
-	unsigned int i;
+	unsigned int i, ulp_num;
 	unsigned short cid = beiscsi_ep->ep_cid;
 	struct be_sge *sge;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
-	def_hdr_id = (unsigned short)HWI_GET_DEF_HDRQ_ID(phba, 0);
-	def_data_id = (unsigned short)HWI_GET_DEF_BUFQ_ID(phba, 0);
+
+	ulp_num = phwi_ctrlr->wrb_context[BE_GET_CRI_FROM_CID(cid)].ulp_num;
+
+	def_hdr_id = (unsigned short)HWI_GET_DEF_HDRQ_ID(phba, ulp_num);
+	def_data_id = (unsigned short)HWI_GET_DEF_BUFQ_ID(phba, ulp_num);
 
 	ptemplate_address = &template_address;
 	ISCSI_GET_PDU_TEMPLATE_ADDRESS(phba, ptemplate_address);
-- 
1.7.10.4

