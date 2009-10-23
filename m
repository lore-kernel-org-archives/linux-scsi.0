From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/2] be2iscsi: Adding msix and mcc_rings V3
Date: Fri, 23 Oct 2009 11:52:33 +0530
Message-ID: <20091023062215.GA3446@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:38578 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751775AbZJWGWX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Oct 2009 02:22:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu

  This patch enables msix for be2iscsi. It also enables use
of mcc_rings for fw commands. Since the mcc eq creation is
dependent on msix I am sending as one patch

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be.h       |   24 +-
 drivers/scsi/be2iscsi/be_cmds.c  |  263 ++++++++++--
 drivers/scsi/be2iscsi/be_cmds.h  |   37 ++-
 drivers/scsi/be2iscsi/be_iscsi.c |   23 +-
 drivers/scsi/be2iscsi/be_main.c  |  888 ++++++++++++++++++++++++++++----------
 drivers/scsi/be2iscsi/be_main.h  |   49 ++-
 drivers/scsi/be2iscsi/be_mgmt.c  |   69 +++-
 drivers/scsi/be2iscsi/be_mgmt.h  |    8 +-
 8 files changed, 1030 insertions(+), 331 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index b36020d..a93a504 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -20,8 +20,10 @@
 
 #include <linux/pci.h>
 #include <linux/if_vlan.h>
-
-#define FW_VER_LEN 32
+#include <linux/blk-iopoll.h>
+#define FW_VER_LEN	32
+#define MCC_Q_LEN	128
+#define MCC_CQ_LEN	256
 
 struct be_dma_mem {
 	void *va;
@@ -74,18 +76,14 @@ static inline void queue_tail_inc(struct be_queue_info *q)
 
 struct be_eq_obj {
 	struct be_queue_info q;
-	char desc[32];
-
-	/* Adaptive interrupt coalescing (AIC) info */
-	bool enable_aic;
-	u16 min_eqd;		/* in usecs */
-	u16 max_eqd;		/* in usecs */
-	u16 cur_eqd;		/* in usecs */
+	struct beiscsi_hba *phba;
+	struct be_queue_info *cq;
+	struct blk_iopoll	iopoll;
 };
 
 struct be_mcc_obj {
-	struct be_queue_info *q;
-	struct be_queue_info *cq;
+	struct be_queue_info q;
+	struct be_queue_info cq;
 };
 
 struct be_ctrl_info {
@@ -176,8 +174,4 @@ static inline void swap_dws(void *wrb, int len)
 	} while (len);
 #endif /* __BIG_ENDIAN */
 }
-
-extern void beiscsi_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
-			      u16 num_popped);
-
 #endif /* BEISCSI_H */
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 08007b6..10f8fe7 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -19,6 +19,16 @@
 #include "be_mgmt.h"
 #include "be_main.h"
 
+static void be_mcc_notify(struct beiscsi_hba *phba)
+{
+	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
+	u32 val = 0;
+
+	val |= mccq->id & DB_MCCQ_RING_ID_MASK;
+	val |= 1 << DB_MCCQ_NUM_POSTED_SHIFT;
+	iowrite32(val, phba->db_va + DB_MCCQ_OFFSET);
+}
+
 static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)
 {
 	if (compl->flags != 0) {
@@ -54,13 +64,56 @@ static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
 	return 0;
 }
 
+
 static inline bool is_link_state_evt(u32 trailer)
 {
 	return (((trailer >> ASYNC_TRAILER_EVENT_CODE_SHIFT) &
-		ASYNC_TRAILER_EVENT_CODE_MASK) == ASYNC_EVENT_CODE_LINK_STATE);
+		  ASYNC_TRAILER_EVENT_CODE_MASK) ==
+		  ASYNC_EVENT_CODE_LINK_STATE);
+}
+
+static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phba)
+{
+	struct be_queue_info *mcc_cq = &phba->ctrl.mcc_obj.cq;
+	struct be_mcc_compl *compl = queue_tail_node(mcc_cq);
+
+	if (be_mcc_compl_is_new(compl)) {
+		queue_tail_inc(mcc_cq);
+		return compl;
+	}
+	return NULL;
+}
+
+static void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
+{
+	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
+}
+
+static void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
+		struct be_async_event_link_state *evt)
+{
+	switch (evt->port_link_status) {
+	case ASYNC_EVENT_LINK_DOWN:
+		SE_DEBUG(DBG_LVL_1, "Link Down on Physical Port %d \n",
+						evt->physical_port);
+		phba->state |= BE_ADAPTER_LINK_DOWN;
+		break;
+	case ASYNC_EVENT_LINK_UP:
+		phba->state = BE_ADAPTER_UP;
+		SE_DEBUG(DBG_LVL_1, "Link UP on Physical Port %d \n",
+						evt->physical_port);
+		iscsi_host_for_each_session(phba->shost,
+					    be2iscsi_fail_session);
+		break;
+	default:
+		SE_DEBUG(DBG_LVL_1, "Unexpected Async Notification %d on"
+				    "Physical Port %d \n",
+				     evt->port_link_status,
+				     evt->physical_port);
+	}
 }
 
-void beiscsi_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
+static void beiscsi_cq_notify(struct beiscsi_hba *phba, u16 qid, bool arm,
 		       u16 num_popped)
 {
 	u32 val = 0;
@@ -68,7 +121,66 @@ void beiscsi_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
 	if (arm)
 		val |= 1 << DB_CQ_REARM_SHIFT;
 	val |= num_popped << DB_CQ_NUM_POPPED_SHIFT;
-	iowrite32(val, ctrl->db + DB_CQ_OFFSET);
+	iowrite32(val, phba->db_va + DB_CQ_OFFSET);
+}
+
+
+int be_process_mcc(struct beiscsi_hba *phba)
+{
+	struct be_mcc_compl *compl;
+	int num = 0, status = 0;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+
+	spin_lock_bh(&phba->ctrl.mcc_cq_lock);
+	while ((compl = be_mcc_compl_get(phba))) {
+		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
+			/* Interpret flags as an async trailer */
+			BUG_ON(!is_link_state_evt(compl->flags));
+
+			/* Interpret compl as a async link evt */
+			beiscsi_async_link_state_process(phba,
+				(struct be_async_event_link_state *) compl);
+		} else if (compl->flags & CQE_FLAGS_COMPLETED_MASK) {
+				status = be_mcc_compl_process(ctrl, compl);
+				atomic_dec(&phba->ctrl.mcc_obj.q.used);
+		}
+		be_mcc_compl_use(compl);
+		num++;
+	}
+
+	if (num)
+		beiscsi_cq_notify(phba, phba->ctrl.mcc_obj.cq.id, true, num);
+
+	spin_unlock_bh(&phba->ctrl.mcc_cq_lock);
+	return status;
+}
+
+/* Wait till no more pending mcc requests are present */
+static int be_mcc_wait_compl(struct beiscsi_hba *phba)
+{
+#define mcc_timeout		120000 /* 5s timeout */
+	int i, status;
+	for (i = 0; i < mcc_timeout; i++) {
+		status = be_process_mcc(phba);
+		if (status)
+			return status;
+
+		if (atomic_read(&phba->ctrl.mcc_obj.q.used) == 0)
+			break;
+		udelay(100);
+	}
+	if (i == mcc_timeout) {
+		dev_err(&phba->pcidev->dev, "mccq poll timed out\n");
+		return -1;
+	}
+	return 0;
+}
+
+/* Notify MCC requests and wait for completion */
+int be_mcc_notify_wait(struct beiscsi_hba *phba)
+{
+	be_mcc_notify(phba);
+	return be_mcc_wait_compl(phba);
 }
 
 static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
@@ -142,6 +254,52 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
 	return 0;
 }
 
+/*
+ * Insert the mailbox address into the doorbell in two steps
+ * Polls on the mbox doorbell till a command completion (or a timeout) occurs
+ */
+static int be_mbox_notify_wait(struct beiscsi_hba *phba)
+{
+	int status;
+	u32 val = 0;
+	void __iomem *db = phba->ctrl.db + MPU_MAILBOX_DB_OFFSET;
+	struct be_dma_mem *mbox_mem = &phba->ctrl.mbox_mem;
+	struct be_mcc_mailbox *mbox = mbox_mem->va;
+	struct be_mcc_compl *compl = &mbox->compl;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+
+	val |= MPU_MAILBOX_DB_HI_MASK;
+	/* at bits 2 - 31 place mbox dma addr msb bits 34 - 63 */
+	val |= (upper_32_bits(mbox_mem->dma) >> 2) << 2;
+	iowrite32(val, db);
+
+	/* wait for ready to be set */
+	status = be_mbox_db_ready_wait(ctrl);
+	if (status != 0)
+		return status;
+
+	val = 0;
+	/* at bits 2 - 31 place mbox dma addr lsb bits 4 - 33 */
+	val |= (u32)(mbox_mem->dma >> 4) << 2;
+	iowrite32(val, db);
+
+	status = be_mbox_db_ready_wait(ctrl);
+	if (status != 0)
+		return status;
+
+	/* A cq entry has been made now */
+	if (be_mcc_compl_is_new(compl)) {
+		status = be_mcc_compl_process(ctrl, &mbox->compl);
+		be_mcc_compl_use(compl);
+		if (status)
+			return status;
+	} else {
+		dev_err(&phba->pcidev->dev, "invalid mailbox completion\n");
+		return -1;
+	}
+	return 0;
+}
+
 void be_wrb_hdr_prepare(struct be_mcc_wrb *wrb, int payload_len,
 				bool embedded, u8 sge_cnt)
 {
@@ -203,6 +361,20 @@ struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem)
 	return &((struct be_mcc_mailbox *)(mbox_mem->va))->wrb;
 }
 
+struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba)
+{
+	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
+	struct be_mcc_wrb *wrb;
+
+	BUG_ON(atomic_read(&mccq->used) >= mccq->len);
+	wrb = queue_head_node(mccq);
+	queue_head_inc(mccq);
+	atomic_inc(&mccq->used);
+	memset(wrb, 0, sizeof(*wrb));
+	return wrb;
+}
+
+
 int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,
 			  struct be_queue_info *eq, int eq_delay)
 {
@@ -212,6 +384,7 @@ int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,
 	struct be_dma_mem *q_mem = &eq->dma_mem;
 	int status;
 
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_cmd_eq_create\n");
 	spin_lock(&ctrl->mbox_lock);
 	memset(wrb, 0, sizeof(*wrb));
 
@@ -249,6 +422,7 @@ int be_cmd_fw_initialize(struct be_ctrl_info *ctrl)
 	int status;
 	u8 *endian_check;
 
+	SE_DEBUG(DBG_LVL_8, "In be_cmd_fw_initialize\n");
 	spin_lock(&ctrl->mbox_lock);
 	memset(wrb, 0, sizeof(*wrb));
 
@@ -282,6 +456,7 @@ int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
 	void *ctxt = &req->context;
 	int status;
 
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_cmd_cq_create \n");
 	spin_lock(&ctrl->mbox_lock);
 	memset(wrb, 0, sizeof(*wrb));
 
@@ -289,7 +464,6 @@ int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
 
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
 			OPCODE_COMMON_CQ_CREATE, sizeof(*req));
-
 	if (!q_mem->va)
 		SE_DEBUG(DBG_LVL_1, "uninitialized q_mem->va\n");
 
@@ -329,6 +503,53 @@ static u32 be_encoded_q_len(int q_len)
 		len_encoded = 0;
 	return len_encoded;
 }
+
+int be_cmd_mccq_create(struct beiscsi_hba *phba,
+			struct be_queue_info *mccq,
+			struct be_queue_info *cq)
+{
+	struct be_mcc_wrb *wrb;
+	struct be_cmd_req_mcc_create *req;
+	struct be_dma_mem *q_mem = &mccq->dma_mem;
+	struct be_ctrl_info *ctrl;
+	void *ctxt;
+	int status;
+
+	spin_lock(&phba->ctrl.mbox_lock);
+	ctrl = &phba->ctrl;
+	wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	req = embedded_payload(wrb);
+	ctxt = &req->context;
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			OPCODE_COMMON_MCC_CREATE, sizeof(*req));
+
+	req->num_pages = PAGES_4K_SPANNED(q_mem->va, q_mem->size);
+
+	AMAP_SET_BITS(struct amap_mcc_context, fid, ctxt,
+		      PCI_FUNC(phba->pcidev->devfn));
+	AMAP_SET_BITS(struct amap_mcc_context, valid, ctxt, 1);
+	AMAP_SET_BITS(struct amap_mcc_context, ring_size, ctxt,
+		be_encoded_q_len(mccq->len));
+	AMAP_SET_BITS(struct amap_mcc_context, cq_id, ctxt, cq->id);
+
+	be_dws_cpu_to_le(ctxt, sizeof(req->context));
+
+	be_cmd_page_addrs_prepare(req->pages, ARRAY_SIZE(req->pages), q_mem);
+
+	status = be_mbox_notify_wait(phba);
+	if (!status) {
+		struct be_cmd_resp_mcc_create *resp = embedded_payload(wrb);
+		mccq->id = le16_to_cpu(resp->id);
+		mccq->created = true;
+	}
+	spin_unlock(&phba->ctrl.mbox_lock);
+
+	return status;
+}
+
 int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 			  int queue_type)
 {
@@ -337,6 +558,7 @@ int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 	u8 subsys = 0, opcode = 0;
 	int status;
 
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_cmd_q_destroy \n");
 	spin_lock(&ctrl->mbox_lock);
 	memset(wrb, 0, sizeof(*wrb));
 	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
@@ -350,6 +572,10 @@ int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 		subsys = CMD_SUBSYSTEM_COMMON;
 		opcode = OPCODE_COMMON_CQ_DESTROY;
 		break;
+	case QTYPE_MCCQ:
+		subsys = CMD_SUBSYSTEM_COMMON;
+		opcode = OPCODE_COMMON_MCC_DESTROY;
+		break;
 	case QTYPE_WRBQ:
 		subsys = CMD_SUBSYSTEM_ISCSI;
 		opcode = OPCODE_COMMON_ISCSI_WRBQ_DESTROY;
@@ -377,30 +603,6 @@ int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 	return status;
 }
 
-int be_cmd_get_mac_addr(struct be_ctrl_info *ctrl, u8 *mac_addr)
-{
-	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
-	struct be_cmd_req_get_mac_addr *req = embedded_payload(wrb);
-	int status;
-
-	spin_lock(&ctrl->mbox_lock);
-	memset(wrb, 0, sizeof(*wrb));
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
-	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
-			   OPCODE_COMMON_ISCSI_NTWK_GET_NIC_CONFIG,
-			   sizeof(*req));
-
-	status = be_mbox_notify(ctrl);
-	if (!status) {
-		struct be_cmd_resp_get_mac_addr *resp = embedded_payload(wrb);
-
-		memcpy(mac_addr, resp->mac_address, ETH_ALEN);
-	}
-
-	spin_unlock(&ctrl->mbox_lock);
-	return status;
-}
-
 int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 				    struct be_queue_info *cq,
 				    struct be_queue_info *dq, int length,
@@ -412,6 +614,7 @@ int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 	void *ctxt = &req->context;
 	int status;
 
+	SE_DEBUG(DBG_LVL_8, "In be_cmd_create_default_pdu_queue\n");
 	spin_lock(&ctrl->mbox_lock);
 	memset(wrb, 0, sizeof(*wrb));
 
@@ -468,8 +671,10 @@ int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
 	be_cmd_page_addrs_prepare(req->pages, ARRAY_SIZE(req->pages), q_mem);
 
 	status = be_mbox_notify(ctrl);
-	if (!status)
+	if (!status) {
 		wrbq->id = le16_to_cpu(resp->cid);
+		wrbq->created = true;
+	}
 	spin_unlock(&ctrl->mbox_lock);
 	return status;
 }
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index c20d686..76fe1f9 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -47,6 +47,8 @@ struct be_mcc_wrb {
 
 #define CQE_FLAGS_VALID_MASK (1 << 31)
 #define CQE_FLAGS_ASYNC_MASK (1 << 30)
+#define CQE_FLAGS_COMPLETED_MASK 	(1 << 28)
+#define CQE_FLAGS_CONSUMED_MASK 	(1 << 27)
 
 /* Completion Status */
 #define MCC_STATUS_SUCCESS 0x0
@@ -173,7 +175,7 @@ struct be_cmd_req_hdr {
 	u8 domain;		/* dword 0 */
 	u32 timeout;		/* dword 1 */
 	u32 request_length;	/* dword 2 */
-	u32 rsvd;		/* dword 3 */
+	u32 rsvd0;		/* dword 3 */
 };
 
 struct be_cmd_resp_hdr {
@@ -382,7 +384,6 @@ struct be_cmd_req_modify_eq_delay {
 
 #define ETH_ALEN	6
 
-
 struct be_cmd_req_get_mac_addr {
 	struct be_cmd_req_hdr hdr;
 	u32 nic_port_count;
@@ -417,14 +418,21 @@ int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
 
 int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 			  int type);
+int be_cmd_mccq_create(struct beiscsi_hba *phba,
+			struct be_queue_info *mccq,
+			struct be_queue_info *cq);
+
 int be_poll_mcc(struct be_ctrl_info *ctrl);
-unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl);
-int be_cmd_get_mac_addr(struct be_ctrl_info *ctrl, u8 *mac_addr);
+unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
+				      struct beiscsi_hba *phba);
+int be_cmd_get_mac_addr(struct beiscsi_hba *phba, u8 *mac_addr);
 
 /*ISCSI Functuions */
 int be_cmd_fw_initialize(struct be_ctrl_info *ctrl);
 
 struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem);
+struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba);
+int be_mcc_notify_wait(struct beiscsi_hba *phba);
 
 int be_mbox_notify(struct be_ctrl_info *ctrl);
 
@@ -531,6 +539,23 @@ struct amap_sol_cqe {
 	u8 valid;		/* dword 3 */
 } __packed;
 
+#define SOL_ICD_INDEX_MASK	0x0003FFC0
+struct amap_sol_cqe_ring {
+	u8 hw_sts[8];		/* dword 0 */
+	u8 i_sts[8];		/* dword 0 */
+	u8 i_resp[8];		/* dword 0 */
+	u8 i_flags[7];		/* dword 0 */
+	u8 s;			/* dword 0 */
+	u8 i_exp_cmd_sn[32];	/* dword 1 */
+	u8 code[6];		/* dword 2 */
+	u8 icd_index[12];	/* dword 2 */
+	u8 rsvd[6];		/* dword 2 */
+	u8 i_cmd_wnd[8];	/* dword 2 */
+	u8 i_res_cnt[31];	/* dword 3 */
+	u8 valid;		/* dword 3 */
+} __packed;
+
+
 
 /**
  * Post WRB Queue Doorbell Register used by the host Storage
@@ -664,8 +689,8 @@ struct be_fw_cfg {
 #define	OPCODE_COMMON_TCP_UPLOAD	56
 #define OPCODE_COMMON_ISCSI_ERROR_RECOVERY_INVALIDATE_COMMANDS 1
 /* --- CMD_ISCSI_INVALIDATE_CONNECTION_TYPE --- */
-#define CMD_ISCSI_CONNECTION_INVALIDATE 1
-#define CMD_ISCSI_CONNECTION_ISSUE_TCP_RST 2
+#define CMD_ISCSI_CONNECTION_INVALIDATE 0x8001
+#define CMD_ISCSI_CONNECTION_ISSUE_TCP_RST 0x8002
 #define OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION 42
 
 #define INI_WR_CMD			1	/* Initiator write command */
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 2fd2544..d587b03 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -67,11 +67,11 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 		cmds_max = beiscsi_ep->phba->params.wrbs_per_cxn;
 	}
 
-	 cls_session = iscsi_session_setup(&beiscsi_iscsi_transport,
-					   shost, cmds_max,
-					   sizeof(*beiscsi_sess),
-					   sizeof(*io_task),
-					   initial_cmdsn, ISCSI_MAX_TARGET);
+	cls_session = iscsi_session_setup(&beiscsi_iscsi_transport,
+					  shost, cmds_max,
+					  sizeof(*beiscsi_sess),
+					  sizeof(*io_task),
+					  initial_cmdsn, ISCSI_MAX_TARGET);
 	if (!cls_session)
 		return NULL;
 	sess = cls_session->dd_data;
@@ -297,7 +297,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_HWADDRESS:
-		be_cmd_get_mac_addr(&phba->ctrl, phba->mac_address);
+		be_cmd_get_mac_addr(phba, phba->mac_address);
 		len = sysfs_format_mac(buf, phba->mac_address, ETH_ALEN);
 		break;
 	default:
@@ -377,16 +377,12 @@ int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct beiscsi_offload_params params;
-	struct iscsi_session *session = conn->session;
-	struct Scsi_Host *shost = iscsi_session_to_shost(session->cls_session);
-	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 
 	memset(&params, 0, sizeof(struct beiscsi_offload_params));
 	beiscsi_ep = beiscsi_conn->ep;
 	if (!beiscsi_ep)
 		SE_DEBUG(DBG_LVL_1, "In beiscsi_conn_start , no beiscsi_ep\n");
 
-	free_mgmt_sgl_handle(phba, beiscsi_conn->plogin_sgl_handle);
 	beiscsi_conn->login_in_progress = 0;
 	beiscsi_set_params_for_offld(beiscsi_conn, &params);
 	beiscsi_offload_connection(beiscsi_conn, &params);
@@ -498,6 +494,13 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		SE_DEBUG(DBG_LVL_1, "shost is NULL \n");
 		return ERR_PTR(ret);
 	}
+
+	if (phba->state) {
+		ret = -EBUSY;
+		SE_DEBUG(DBG_LVL_1, "The Adapet state is Not UP \n");
+		return ERR_PTR(ret);
+	}
+
 	ep = iscsi_create_endpoint(sizeof(struct beiscsi_endpoint));
 	if (!ep) {
 		ret = -ENOMEM;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 4f1aca3..2c3e99e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -39,7 +39,7 @@
 
 static unsigned int be_iopoll_budget = 10;
 static unsigned int be_max_phys_size = 64;
-static unsigned int enable_msix;
+static unsigned int enable_msix = 1;
 
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
@@ -58,6 +58,17 @@ static int beiscsi_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+/*------------------- PCI Driver operations and data ----------------- */
+static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
+	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
+	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID1) },
+	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID2) },
+	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID3) },
+	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID4) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
+
 static struct scsi_host_template beiscsi_sht = {
 	.module = THIS_MODULE,
 	.name = "ServerEngines 10Gbe open-iscsi Initiator Driver",
@@ -76,16 +87,8 @@ static struct scsi_host_template beiscsi_sht = {
 	.cmd_per_lun = BEISCSI_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
 };
-static struct scsi_transport_template *beiscsi_scsi_transport;
 
-/*------------------- PCI Driver operations and data ----------------- */
-static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
-	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
-	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID1) },
-	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID2) },
-	{ 0 }
-};
-MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
+static struct scsi_transport_template *beiscsi_scsi_transport;
 
 static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 {
@@ -104,7 +107,6 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 	shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;
 	shost->max_lun = BEISCSI_NUM_MAX_LUN;
 	shost->transportt = beiscsi_scsi_transport;
-
 	phba = iscsi_host_priv(shost);
 	memset(phba, 0, sizeof(*phba));
 	phba->shost = shost;
@@ -181,6 +183,7 @@ static int beiscsi_enable_pci(struct pci_dev *pcidev)
 		return ret;
 	}
 
+	pci_set_master(pcidev);
 	if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64))) {
 		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32));
 		if (ret) {
@@ -203,7 +206,6 @@ static int be_ctrl_init(struct beiscsi_hba *phba, struct pci_dev *pdev)
 	status = beiscsi_map_pci_bars(phba, pdev);
 	if (status)
 		return status;
-
 	mbox_mem_alloc->size = sizeof(struct be_mcc_mailbox) + 16;
 	mbox_mem_alloc->va = pci_alloc_consistent(pdev,
 						  mbox_mem_alloc->size,
@@ -219,6 +221,9 @@ static int be_ctrl_init(struct beiscsi_hba *phba, struct pci_dev *pdev)
 	mbox_mem_align->dma = PTR_ALIGN(mbox_mem_alloc->dma, 16);
 	memset(mbox_mem_align->va, 0, sizeof(struct be_mcc_mailbox));
 	spin_lock_init(&ctrl->mbox_lock);
+	spin_lock_init(&phba->ctrl.mcc_lock);
+	spin_lock_init(&phba->ctrl.mcc_cq_lock);
+
 	return status;
 }
 
@@ -268,6 +273,113 @@ static void hwi_ring_eq_db(struct beiscsi_hba *phba,
 }
 
 /**
+ * be_isr_mcc - The isr routine of the driver.
+ * @irq: Not used
+ * @dev_id: Pointer to host adapter structure
+ */
+static irqreturn_t be_isr_mcc(int irq, void *dev_id)
+{
+	struct beiscsi_hba *phba;
+	struct be_eq_entry *eqe = NULL;
+	struct be_queue_info *eq;
+	struct be_queue_info *mcc;
+	unsigned int num_eq_processed;
+	struct be_eq_obj *pbe_eq;
+	unsigned long flags;
+
+	pbe_eq = dev_id;
+	eq = &pbe_eq->q;
+	phba =  pbe_eq->phba;
+	mcc = &phba->ctrl.mcc_obj.cq;
+	eqe = queue_tail_node(eq);
+	if (!eqe)
+		SE_DEBUG(DBG_LVL_1, "eqe is NULL\n");
+
+	num_eq_processed = 0;
+
+	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+				& EQE_VALID_MASK) {
+		if (((eqe->dw[offsetof(struct amap_eq_entry,
+		     resource_id) / 32] &
+		     EQE_RESID_MASK) >> 16) == mcc->id) {
+			spin_lock_irqsave(&phba->isr_lock, flags);
+			phba->todo_mcc_cq = 1;
+			spin_unlock_irqrestore(&phba->isr_lock, flags);
+		}
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+		num_eq_processed++;
+	}
+	if (phba->todo_mcc_cq)
+		queue_work(phba->wq, &phba->work_cqs);
+	if (num_eq_processed)
+		hwi_ring_eq_db(phba, eq->id, 1,	num_eq_processed, 1, 1);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * be_isr_msix - The isr routine of the driver.
+ * @irq: Not used
+ * @dev_id: Pointer to host adapter structure
+ */
+static irqreturn_t be_isr_msix(int irq, void *dev_id)
+{
+	struct beiscsi_hba *phba;
+	struct be_eq_entry *eqe = NULL;
+	struct be_queue_info *eq;
+	struct be_queue_info *cq;
+	unsigned int num_eq_processed;
+	struct be_eq_obj *pbe_eq;
+	unsigned long flags;
+
+	pbe_eq = dev_id;
+	eq = &pbe_eq->q;
+	cq = pbe_eq->cq;
+	eqe = queue_tail_node(eq);
+	if (!eqe)
+		SE_DEBUG(DBG_LVL_1, "eqe is NULL\n");
+
+	phba = pbe_eq->phba;
+	num_eq_processed = 0;
+	if (blk_iopoll_enabled) {
+		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+					& EQE_VALID_MASK) {
+			if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
+				blk_iopoll_sched(&pbe_eq->iopoll);
+
+			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+			queue_tail_inc(eq);
+			eqe = queue_tail_node(eq);
+			num_eq_processed++;
+		}
+		if (num_eq_processed)
+			hwi_ring_eq_db(phba, eq->id, 1,	num_eq_processed, 0, 1);
+
+		return IRQ_HANDLED;
+	} else {
+		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+						& EQE_VALID_MASK) {
+			spin_lock_irqsave(&phba->isr_lock, flags);
+			phba->todo_cq = 1;
+			spin_unlock_irqrestore(&phba->isr_lock, flags);
+			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+			queue_tail_inc(eq);
+			eqe = queue_tail_node(eq);
+			num_eq_processed++;
+		}
+		if (phba->todo_cq)
+			queue_work(phba->wq, &phba->work_cqs);
+
+		if (num_eq_processed)
+			hwi_ring_eq_db(phba, eq->id, 1, num_eq_processed, 1, 1);
+
+		return IRQ_HANDLED;
+	}
+}
+
+/**
  * be_isr - The isr routine of the driver.
  * @irq: Not used
  * @dev_id: Pointer to host adapter structure
@@ -280,48 +392,70 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 	struct be_eq_entry *eqe = NULL;
 	struct be_queue_info *eq;
 	struct be_queue_info *cq;
+	struct be_queue_info *mcc;
 	unsigned long flags, index;
-	unsigned int num_eq_processed;
+	unsigned int num_mcceq_processed, num_ioeq_processed;
 	struct be_ctrl_info *ctrl;
+	struct be_eq_obj *pbe_eq;
 	int isr;
 
 	phba = dev_id;
-	if (!enable_msix) {
-		ctrl = &phba->ctrl;;
-		isr = ioread32(ctrl->csr + CEV_ISR0_OFFSET +
-			       (PCI_FUNC(ctrl->pdev->devfn) * CEV_ISR_SIZE));
-		if (!isr)
-			return IRQ_NONE;
-	}
+	ctrl = &phba->ctrl;;
+	isr = ioread32(ctrl->csr + CEV_ISR0_OFFSET +
+		       (PCI_FUNC(ctrl->pdev->devfn) * CEV_ISR_SIZE));
+	if (!isr)
+		return IRQ_NONE;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
-	eq = &phwi_context->be_eq.q;
-	cq = &phwi_context->be_cq;
+	pbe_eq = &phwi_context->be_eq[0];
+
+	eq = &phwi_context->be_eq[0].q;
+	mcc = &phba->ctrl.mcc_obj.cq;
 	index = 0;
 	eqe = queue_tail_node(eq);
 	if (!eqe)
 		SE_DEBUG(DBG_LVL_1, "eqe is NULL\n");
 
-	num_eq_processed = 0;
+	num_ioeq_processed = 0;
+	num_mcceq_processed = 0;
 	if (blk_iopoll_enabled) {
 		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
 					& EQE_VALID_MASK) {
-			if (!blk_iopoll_sched_prep(&phba->iopoll))
-				blk_iopoll_sched(&phba->iopoll);
-
+			if (((eqe->dw[offsetof(struct amap_eq_entry,
+			     resource_id) / 32] &
+			     EQE_RESID_MASK) >> 16) == mcc->id) {
+				spin_lock_irqsave(&phba->isr_lock, flags);
+				phba->todo_mcc_cq = 1;
+				spin_unlock_irqrestore(&phba->isr_lock, flags);
+				num_mcceq_processed++;
+			} else {
+				if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
+					blk_iopoll_sched(&pbe_eq->iopoll);
+				num_ioeq_processed++;
+			}
 			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
 			queue_tail_inc(eq);
 			eqe = queue_tail_node(eq);
-			num_eq_processed++;
-			SE_DEBUG(DBG_LVL_8, "Valid EQE\n");
 		}
-		if (num_eq_processed) {
-			hwi_ring_eq_db(phba, eq->id, 0,	num_eq_processed, 0, 1);
+		if (num_ioeq_processed || num_mcceq_processed) {
+			if (phba->todo_mcc_cq)
+				queue_work(phba->wq, &phba->work_cqs);
+
+		if ((num_mcceq_processed) && (!num_ioeq_processed))
+				hwi_ring_eq_db(phba, eq->id, 0,
+					      (num_ioeq_processed +
+					       num_mcceq_processed) , 1, 1);
+			else
+				hwi_ring_eq_db(phba, eq->id, 0,
+					       (num_ioeq_processed +
+						num_mcceq_processed), 0, 1);
+
 			return IRQ_HANDLED;
 		} else
 			return IRQ_NONE;
 	} else {
+		cq = &phwi_context->be_cq[0];
 		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
 						& EQE_VALID_MASK) {
 
@@ -339,13 +473,14 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
 			queue_tail_inc(eq);
 			eqe = queue_tail_node(eq);
-			num_eq_processed++;
+			num_ioeq_processed++;
 		}
 		if (phba->todo_cq || phba->todo_mcc_cq)
 			queue_work(phba->wq, &phba->work_cqs);
 
-		if (num_eq_processed) {
-			hwi_ring_eq_db(phba, eq->id, 0, num_eq_processed, 1, 1);
+		if (num_ioeq_processed) {
+			hwi_ring_eq_db(phba, eq->id, 0,
+				       num_ioeq_processed, 1, 1);
 			return IRQ_HANDLED;
 		} else
 			return IRQ_NONE;
@@ -355,13 +490,32 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 {
 	struct pci_dev *pcidev = phba->pcidev;
-	int ret;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	int ret, msix_vec, i = 0;
+	char desc[32];
 
-	ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED, "beiscsi", phba);
-	if (ret) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
-			     "Failed to register irq\\n");
-		return ret;
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+
+	if (phba->msix_enabled) {
+		for (i = 0; i < phba->num_cpus; i++) {
+			sprintf(desc, "beiscsi_msix_%04x", i);
+			msix_vec = phba->msix_entries[i].vector;
+			ret = request_irq(msix_vec, be_isr_msix, 0, desc,
+					  &phwi_context->be_eq[i]);
+		}
+		msix_vec = phba->msix_entries[i].vector;
+		ret = request_irq(msix_vec, be_isr_mcc, 0, "beiscsi_msix_mcc",
+				  &phwi_context->be_eq[i]);
+	} else {
+		ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED,
+				  "beiscsi", phba);
+		if (ret) {
+			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
+				     "Failed to register irq\\n");
+			return ret;
+		}
 	}
 	return 0;
 }
@@ -378,15 +532,6 @@ static void hwi_ring_cq_db(struct beiscsi_hba *phba,
 	iowrite32(val, phba->db_va + DB_CQ_OFFSET);
 }
 
-/*
- * async pdus include
- * a. unsolicited NOP-In (target initiated NOP-In)
- * b. Async Messages
- * c. Reject PDU
- * d. Login response
- * These headers arrive unprocessed by the EP firmware and iSCSI layer
- * process them
- */
 static unsigned int
 beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 			  struct beiscsi_hba *phba,
@@ -397,6 +542,9 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 {
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 	struct iscsi_session *session = conn->session;
+	struct iscsi_task *task;
+	struct beiscsi_io_task *io_task;
+	struct iscsi_hdr *login_hdr;
 
 	switch (ppdu->dw[offsetof(struct amap_pdu_base, opcode) / 32] &
 						PDUBASE_OPCODE_MASK) {
@@ -412,6 +560,10 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 		SE_DEBUG(DBG_LVL_1, "In ISCSI_OP_REJECT\n");
 		break;
 	case ISCSI_OP_LOGIN_RSP:
+		task = conn->login_task;
+		io_task = task->dd_data;
+		login_hdr = (struct iscsi_hdr *)ppdu;
+		login_hdr->itt = io_task->libiscsi_itt;
 		break;
 	default:
 		shost_printk(KERN_WARNING, phba->shost,
@@ -440,7 +592,8 @@ static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 						io_sgl_alloc_index];
 		phba->io_sgl_hndl_base[phba->io_sgl_alloc_index] = NULL;
 		phba->io_sgl_hndl_avbl--;
-		if (phba->io_sgl_alloc_index == (phba->params.ios_per_ctrl - 1))
+		if (phba->io_sgl_alloc_index == (phba->params.
+						 ios_per_ctrl - 1))
 			phba->io_sgl_alloc_index = 0;
 		else
 			phba->io_sgl_alloc_index++;
@@ -490,9 +643,18 @@ struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pwrb_context = &phwi_ctrlr->wrb_context[cid];
-	pwrb_handle = pwrb_context->pwrb_handle_base[index];
-	pwrb_handle->wrb_index = index;
-	pwrb_handle->nxt_wrb_index = index;
+	if (pwrb_context->wrb_handles_available) {
+		pwrb_handle = pwrb_context->pwrb_handle_base[
+					    pwrb_context->alloc_index];
+		pwrb_context->wrb_handles_available--;
+		pwrb_handle->nxt_wrb_index = pwrb_handle->wrb_index;
+		if (pwrb_context->alloc_index ==
+						(phba->params.wrbs_per_cxn - 1))
+			pwrb_context->alloc_index = 0;
+		else
+			pwrb_context->alloc_index++;
+	} else
+		pwrb_handle = NULL;
 	return pwrb_handle;
 }
 
@@ -508,11 +670,19 @@ static void
 free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 		struct wrb_handle *pwrb_handle)
 {
+
+	pwrb_context->pwrb_handle_base[pwrb_context->free_index] = pwrb_handle;
+	pwrb_context->wrb_handles_available++;
+	if (pwrb_context->free_index == (phba->params.wrbs_per_cxn - 1))
+		pwrb_context->free_index = 0;
+	else
+		pwrb_context->free_index++;
+
 	SE_DEBUG(DBG_LVL_8,
-		 "FREE WRB: pwrb_handle=%p free_index=%d=0x%x"
+		 "FREE WRB: pwrb_handle=%p free_index=0x%x"
 		 "wrb_handles_available=%d \n",
 		 pwrb_handle, pwrb_context->free_index,
-		 pwrb_context->free_index, pwrb_context->wrb_handles_available);
+		 pwrb_context->wrb_handles_available);
 }
 
 static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
@@ -540,6 +710,8 @@ void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
 
+	SE_DEBUG(DBG_LVL_8, "In  free_mgmt_sgl_handle,eh_sgl_free_index=%d \n",
+			     phba->eh_sgl_free_index);
 	if (phba->eh_sgl_hndl_base[phba->eh_sgl_free_index]) {
 		/*
 		 * this can happen if clean_task is called on a task that
@@ -572,10 +744,10 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 	u32 resid = 0, exp_cmdsn, max_cmdsn;
 	u8 rsp, status, flags;
 
-	exp_cmdsn = be32_to_cpu(psol->
+	exp_cmdsn = (psol->
 			dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) / 32]
 			& SOL_EXP_CMD_SN_MASK);
-	max_cmdsn = be32_to_cpu((psol->
+	max_cmdsn = ((psol->
 			dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) / 32]
 			& SOL_EXP_CMD_SN_MASK) +
 			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
@@ -610,9 +782,9 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 	}
 
 	if (status == SAM_STAT_CHECK_CONDITION) {
+		unsigned short *slen = (unsigned short *)sts_bhs->sense_info;
 		sense = sts_bhs->sense_info + sizeof(unsigned short);
-		sense_len =
-		    cpu_to_be16((unsigned short)(sts_bhs->sense_info[0]));
+		sense_len =  cpu_to_be16(*slen);
 		memcpy(task->sc->sense_buffer, sense,
 		       min_t(u16, sense_len, SCSI_SENSE_BUFFERSIZE));
 	}
@@ -620,8 +792,8 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 		if (psol->dw[offsetof(struct amap_sol_cqe, i_res_cnt) / 32]
 							& SOL_RES_CNT_MASK)
 			 conn->rxdata_octets += (psol->
-			      dw[offsetof(struct amap_sol_cqe, i_res_cnt) / 32]
-							& SOL_RES_CNT_MASK);
+			     dw[offsetof(struct amap_sol_cqe, i_res_cnt) / 32]
+			     & SOL_RES_CNT_MASK);
 	}
 unmap:
 	scsi_dma_unmap(io_task->scsi_cmnd);
@@ -633,6 +805,7 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 		   struct iscsi_task *task, struct sol_cqe *psol)
 {
 	struct iscsi_logout_rsp *hdr;
+	struct beiscsi_io_task *io_task = task->dd_data;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 
 	hdr = (struct iscsi_logout_rsp *)task->hdr;
@@ -651,7 +824,7 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
 					/ 32] & SOL_CMD_WND_MASK) >> 24) - 1);
 	hdr->hlength = 0;
-
+	hdr->itt = io_task->libiscsi_itt;
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
 }
 
@@ -661,6 +834,7 @@ be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 {
 	struct iscsi_tm_rsp *hdr;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct beiscsi_io_task *io_task = task->dd_data;
 
 	hdr = (struct iscsi_tm_rsp *)task->hdr;
 	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
@@ -668,11 +842,12 @@ be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 	hdr->response = (psol->dw[offsetof(struct amap_sol_cqe, i_resp) /
 					32] & SOL_RESP_MASK);
 	hdr->exp_cmdsn = cpu_to_be32(psol->dw[offsetof(struct amap_sol_cqe,
-				     i_exp_cmd_sn) / 32] & SOL_EXP_CMD_SN_MASK);
+				    i_exp_cmd_sn) / 32] & SOL_EXP_CMD_SN_MASK);
 	hdr->max_cmdsn = be32_to_cpu((psol->dw[offsetof(struct amap_sol_cqe,
 			i_exp_cmd_sn) / 32] & SOL_EXP_CMD_SN_MASK) +
 			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
 			/ 32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	hdr->itt = io_task->libiscsi_itt;
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
 }
 
@@ -681,18 +856,25 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 		       struct beiscsi_hba *phba, struct sol_cqe *psol)
 {
 	struct hwi_wrb_context *pwrb_context;
-	struct wrb_handle *pwrb_handle;
+	struct wrb_handle *pwrb_handle = NULL;
 	struct hwi_controller *phwi_ctrlr;
+	struct iscsi_task *task;
+	struct beiscsi_io_task *io_task;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 	struct iscsi_session *session = conn->session;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pwrb_context = &phwi_ctrlr->wrb_context[((psol->
-				dw[offsetof(struct amap_sol_cqe, cid) / 32] &
-				SOL_CID_MASK) >> 6)];
+			dw[offsetof(struct amap_sol_cqe, cid) / 32] &
+			SOL_CID_MASK) >> 6)];
 	pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
-				dw[offsetof(struct amap_sol_cqe, wrb_index) /
-				32] & SOL_WRB_INDEX_MASK) >> 16)];
+			dw[offsetof(struct amap_sol_cqe, wrb_index) /
+			32] & SOL_WRB_INDEX_MASK) >> 16)];
+	task = pwrb_handle->pio_handle;
+	io_task = task->dd_data;
+	spin_lock(&phba->mgmt_sgl_lock);
+	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
+	spin_unlock(&phba->mgmt_sgl_lock);
 	spin_lock_bh(&session->lock);
 	free_wrb_handle(phba, pwrb_context, pwrb_handle);
 	spin_unlock_bh(&session->lock);
@@ -704,6 +886,7 @@ be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,
 {
 	struct iscsi_nopin *hdr;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct beiscsi_io_task *io_task = task->dd_data;
 
 	hdr = (struct iscsi_nopin *)task->hdr;
 	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
@@ -715,6 +898,7 @@ be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,
 			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
 			/ 32] & SOL_CMD_WND_MASK) >> 24) - 1);
 	hdr->opcode = ISCSI_OP_NOOP_IN;
+	hdr->itt = io_task->libiscsi_itt;
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
 }
 
@@ -726,25 +910,25 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_wrb *pwrb = NULL;
 	struct hwi_controller *phwi_ctrlr;
 	struct iscsi_task *task;
-	struct beiscsi_io_task *io_task;
+	unsigned int type;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 	struct iscsi_session *session = conn->session;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-
 	pwrb_context = &phwi_ctrlr->
-		wrb_context[((psol->dw[offsetof(struct amap_sol_cqe, cid) / 32]
-		& SOL_CID_MASK) >> 6)];
+			wrb_context[((psol->dw[offsetof
+			(struct amap_sol_cqe, cid) / 32]
+			& SOL_CID_MASK) >> 6)];
 	pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
-				dw[offsetof(struct amap_sol_cqe, wrb_index) /
-				32] & SOL_WRB_INDEX_MASK) >> 16)];
-
+			dw[offsetof(struct amap_sol_cqe, wrb_index) /
+			32] & SOL_WRB_INDEX_MASK) >> 16)];
 	task = pwrb_handle->pio_handle;
-	io_task = task->dd_data;
-	spin_lock_bh(&session->lock);
 	pwrb = pwrb_handle->pwrb;
-	switch ((pwrb->dw[offsetof(struct amap_iscsi_wrb, type) / 32] &
-		 WRB_TYPE_MASK) >> 28) {
+	type = (pwrb->dw[offsetof(struct amap_iscsi_wrb, type) / 32] &
+			 WRB_TYPE_MASK) >> 28;
+
+	spin_lock_bh(&session->lock);
+	switch (type) {
 	case HWH_TYPE_IO:
 	case HWH_TYPE_IO_RD:
 		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) ==
@@ -774,14 +958,14 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 
 	default:
 		shost_printk(KERN_WARNING, phba->shost,
-			    "wrb_index 0x%x CID 0x%x\n",
-			    ((psol->dw[offsetof(struct amap_iscsi_wrb, type) /
-					32] & SOL_WRB_INDEX_MASK) >> 16),
-			    ((psol->dw[offsetof(struct amap_sol_cqe, cid) / 32]
-					& SOL_CID_MASK) >> 6));
+			"In hwi_complete_cmd, unknown type = %d"
+			"wrb_index 0x%x CID 0x%x\n", type,
+			((psol->dw[offsetof(struct amap_iscsi_wrb,
+			type) / 32] & SOL_WRB_INDEX_MASK) >> 16),
+			((psol->dw[offsetof(struct amap_sol_cqe,
+			cid) / 32] & SOL_CID_MASK) >> 6));
 		break;
 	}
-
 	spin_unlock_bh(&session->lock);
 }
 
@@ -1208,21 +1392,20 @@ static void hwi_process_default_pdu_ring(struct beiscsi_conn *beiscsi_conn,
 	hwi_post_async_buffers(phba, pasync_handle->is_header);
 }
 
-static unsigned int beiscsi_process_cq(struct beiscsi_hba *phba)
+
+static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 {
-	struct hwi_controller *phwi_ctrlr;
-	struct hwi_context_memory *phwi_context;
 	struct be_queue_info *cq;
 	struct sol_cqe *sol;
 	struct dmsg_cqe *dmsg;
 	unsigned int num_processed = 0;
 	unsigned int tot_nump = 0;
 	struct beiscsi_conn *beiscsi_conn;
+	struct beiscsi_hba *phba;
 
-	phwi_ctrlr = phba->phwi_ctrlr;
-	phwi_context = phwi_ctrlr->phwi_ctxt;
-	cq = &phwi_context->be_cq;
+	cq = pbe_eq->cq;
 	sol = queue_tail_node(cq);
+	phba = pbe_eq->phba;
 
 	while (sol->dw[offsetof(struct amap_sol_cqe, valid) / 32] &
 	       CQE_VALID_MASK) {
@@ -1237,11 +1420,11 @@ static unsigned int beiscsi_process_cq(struct beiscsi_hba *phba)
 				     "Connection table empty for cid = %d\n",
 				     (u32)(sol->dw[offsetof(struct amap_sol_cqe,
 				     cid) / 32] & SOL_CID_MASK) >> 6);
-			return 0;
-		}
+				return 0;
+			}
 
 		if (num_processed >= 32) {
-			hwi_ring_cq_db(phba, phwi_context->be_cq.id,
+			hwi_ring_cq_db(phba, cq->id,
 					num_processed, 0, 0);
 			tot_nump += num_processed;
 			num_processed = 0;
@@ -1258,8 +1441,12 @@ static unsigned int beiscsi_process_cq(struct beiscsi_hba *phba)
 			hwi_complete_drvr_msgs(beiscsi_conn, phba, sol);
 			break;
 		case UNSOL_HDR_NOTIFY:
+			SE_DEBUG(DBG_LVL_8, "Received UNSOL_HDR_ NOTIFY\n");
+			hwi_process_default_pdu_ring(beiscsi_conn, phba,
+					     (struct i_t_dpdu_cqe *)sol);
+			break;
 		case UNSOL_DATA_NOTIFY:
-			SE_DEBUG(DBG_LVL_8, "Received UNSOL_HDR/DATA_NOTIFY\n");
+			SE_DEBUG(DBG_LVL_8, "Received UNSOL_DATA_NOTIFY\n");
 			hwi_process_default_pdu_ring(beiscsi_conn, phba,
 					     (struct i_t_dpdu_cqe *)sol);
 			break;
@@ -1306,7 +1493,7 @@ static unsigned int beiscsi_process_cq(struct beiscsi_hba *phba)
 		case CXN_KILLED_OVER_RUN_RESIDUAL:
 		case CXN_KILLED_UNDER_RUN_RESIDUAL:
 		case CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN:
-			SE_DEBUG(DBG_LVL_1, "CQ Error %d, resetting CID "
+			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset CID "
 				 "0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
@@ -1317,8 +1504,8 @@ static unsigned int beiscsi_process_cq(struct beiscsi_hba *phba)
 			break;
 		case CXN_KILLED_RST_SENT:
 		case CXN_KILLED_RST_RCVD:
-			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset received/sent "
-				 "on CID 0x%x...\n",
+			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
+				"received/sent on CID 0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
@@ -1344,8 +1531,7 @@ static unsigned int beiscsi_process_cq(struct beiscsi_hba *phba)
 
 	if (num_processed > 0) {
 		tot_nump += num_processed;
-		hwi_ring_cq_db(phba, phwi_context->be_cq.id, num_processed,
-			       1, 0);
+		hwi_ring_cq_db(phba, cq->id, num_processed, 1, 0);
 	}
 	return tot_nump;
 }
@@ -1353,21 +1539,30 @@ static unsigned int beiscsi_process_cq(struct beiscsi_hba *phba)
 static void beiscsi_process_all_cqs(struct work_struct *work)
 {
 	unsigned long flags;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	struct be_eq_obj *pbe_eq;
 	struct beiscsi_hba *phba =
 	    container_of(work, struct beiscsi_hba, work_cqs);
 
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+	if (phba->msix_enabled)
+		pbe_eq = &phwi_context->be_eq[phba->num_cpus];
+	else
+		pbe_eq = &phwi_context->be_eq[0];
+
 	if (phba->todo_mcc_cq) {
 		spin_lock_irqsave(&phba->isr_lock, flags);
 		phba->todo_mcc_cq = 0;
 		spin_unlock_irqrestore(&phba->isr_lock, flags);
-		SE_DEBUG(DBG_LVL_1, "MCC Interrupt Not expected \n");
 	}
 
 	if (phba->todo_cq) {
 		spin_lock_irqsave(&phba->isr_lock, flags);
 		phba->todo_cq = 0;
 		spin_unlock_irqrestore(&phba->isr_lock, flags);
-		beiscsi_process_cq(phba);
+		beiscsi_process_cq(pbe_eq);
 	}
 }
 
@@ -1375,19 +1570,15 @@ static int be_iopoll(struct blk_iopoll *iop, int budget)
 {
 	static unsigned int ret;
 	struct beiscsi_hba *phba;
+	struct be_eq_obj *pbe_eq;
 
-	phba = container_of(iop, struct beiscsi_hba, iopoll);
-
-	ret = beiscsi_process_cq(phba);
+	pbe_eq = container_of(iop, struct be_eq_obj, iopoll);
+	ret = beiscsi_process_cq(pbe_eq);
 	if (ret < budget) {
-		struct hwi_controller *phwi_ctrlr;
-		struct hwi_context_memory *phwi_context;
-
-		phwi_ctrlr = phba->phwi_ctrlr;
-		phwi_context = phwi_ctrlr->phwi_ctxt;
+		phba = pbe_eq->phba;
 		blk_iopoll_complete(iop);
-		hwi_ring_eq_db(phba, phwi_context->be_eq.q.id, 0,
-							0, 1, 1);
+		SE_DEBUG(DBG_LVL_8, "rearm pbe_eq->q.id =%d\n", pbe_eq->q.id);
+		hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
 	}
 	return ret;
 }
@@ -1537,14 +1728,12 @@ static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
 
 static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 {
-	unsigned int num_cq_pages, num_eq_pages, num_async_pdu_buf_pages;
+	unsigned int num_cq_pages, num_async_pdu_buf_pages;
 	unsigned int num_async_pdu_data_pages, wrb_sz_per_cxn;
 	unsigned int num_async_pdu_buf_sgl_pages, num_async_pdu_data_sgl_pages;
 
 	num_cq_pages = PAGES_REQUIRED(phba->params.num_cq_entries * \
 				      sizeof(struct sol_cqe));
-	num_eq_pages = PAGES_REQUIRED(phba->params.num_eq_entries * \
-				      sizeof(struct be_eq_entry));
 	num_async_pdu_buf_pages =
 			PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
 				       phba->params.defpdu_hdr_sz);
@@ -1565,8 +1754,6 @@ static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 	phba->mem_req[HWI_MEM_ADDN_CONTEXT] =
 					    sizeof(struct hwi_context_memory);
 
-	phba->mem_req[HWI_MEM_CQ] = num_cq_pages * PAGE_SIZE;
-	phba->mem_req[HWI_MEM_EQ] = num_eq_pages * PAGE_SIZE;
 
 	phba->mem_req[HWI_MEM_WRB] = sizeof(struct iscsi_wrb)
 	    * (phba->params.wrbs_per_cxn)
@@ -1751,8 +1938,6 @@ static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 
 	for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
 		pwrb_context = &phwi_ctrlr->wrb_context[index];
-		SE_DEBUG(DBG_LVL_8, "cid=%d pwrb_context=%p \n", index,
-						pwrb_context);
 		pwrb_context->pwrb_handle_base =
 				kzalloc(sizeof(struct wrb_handle *) *
 					phba->params.wrbs_per_cxn, GFP_KERNEL);
@@ -1767,6 +1952,7 @@ static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 				pwrb_context->pwrb_handle_basestd[j] =
 								pwrb_handle;
 				pwrb_context->wrb_handles_available++;
+				pwrb_handle->wrb_index = j;
 				pwrb_handle++;
 			}
 			pwrb_context->free_index = 0;
@@ -1785,6 +1971,7 @@ static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 				pwrb_context->pwrb_handle_basestd[j] =
 				    pwrb_handle;
 				pwrb_context->wrb_handles_available++;
+				pwrb_handle->wrb_index = j;
 				pwrb_handle++;
 			}
 			pwrb_context->free_index = 0;
@@ -2042,79 +2229,126 @@ static int be_fill_queue(struct be_queue_info *q,
 	return 0;
 }
 
-static int beiscsi_create_eq(struct beiscsi_hba *phba,
+static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 			     struct hwi_context_memory *phwi_context)
 {
-	unsigned int idx;
-	int ret;
+	unsigned int i, num_eq_pages;
+	int ret, eq_for_mcc;
 	struct be_queue_info *eq;
 	struct be_dma_mem *mem;
-	struct be_mem_descriptor *mem_descr;
 	void *eq_vaddress;
+	dma_addr_t paddr;
 
-	idx = 0;
-	eq = &phwi_context->be_eq.q;
-	mem = &eq->dma_mem;
-	mem_descr = phba->init_mem;
-	mem_descr += HWI_MEM_EQ;
-	eq_vaddress = mem_descr->mem_array[idx].virtual_address;
-
-	ret = be_fill_queue(eq, phba->params.num_eq_entries,
-			    sizeof(struct be_eq_entry), eq_vaddress);
-	if (ret) {
-		shost_printk(KERN_ERR, phba->shost,
-			     "be_fill_queue Failed for EQ \n");
-		return ret;
-	}
+	num_eq_pages = PAGES_REQUIRED(phba->params.num_eq_entries * \
+				      sizeof(struct be_eq_entry));
 
-	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
+	if (phba->msix_enabled)
+		eq_for_mcc = 1;
+	else
+		eq_for_mcc = 0;
+	for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
+		eq = &phwi_context->be_eq[i].q;
+		mem = &eq->dma_mem;
+		phwi_context->be_eq[i].phba = phba;
+		eq_vaddress = pci_alloc_consistent(phba->pcidev,
+						     num_eq_pages * PAGE_SIZE,
+						     &paddr);
+		if (!eq_vaddress)
+			goto create_eq_error;
+
+		mem->va = eq_vaddress;
+		ret = be_fill_queue(eq, phba->params.num_eq_entries,
+				    sizeof(struct be_eq_entry), eq_vaddress);
+		if (ret) {
+			shost_printk(KERN_ERR, phba->shost,
+				     "be_fill_queue Failed for EQ \n");
+			goto create_eq_error;
+		}
 
-	ret = beiscsi_cmd_eq_create(&phba->ctrl, eq,
-				    phwi_context->be_eq.cur_eqd);
-	if (ret) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_cmd_eq_create"
-			     "Failedfor EQ \n");
-		return ret;
+		mem->dma = paddr;
+		ret = beiscsi_cmd_eq_create(&phba->ctrl, eq,
+					    phwi_context->cur_eqd);
+		if (ret) {
+			shost_printk(KERN_ERR, phba->shost,
+				     "beiscsi_cmd_eq_create"
+				     "Failedfor EQ \n");
+			goto create_eq_error;
+		}
+		SE_DEBUG(DBG_LVL_8, "eqid = %d\n", phwi_context->be_eq[i].q.id);
 	}
-	SE_DEBUG(DBG_LVL_8, "eq id is %d\n", phwi_context->be_eq.q.id);
 	return 0;
+create_eq_error:
+	for (i = 0; i < (phba->num_cpus + 1); i++) {
+		eq = &phwi_context->be_eq[i].q;
+		mem = &eq->dma_mem;
+		if (mem->va)
+			pci_free_consistent(phba->pcidev, num_eq_pages
+					    * PAGE_SIZE,
+					    mem->va, mem->dma);
+	}
+	return ret;
 }
 
-static int beiscsi_create_cq(struct beiscsi_hba *phba,
+static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 			     struct hwi_context_memory *phwi_context)
 {
-	unsigned int idx;
+	unsigned int i, num_cq_pages;
 	int ret;
 	struct be_queue_info *cq, *eq;
 	struct be_dma_mem *mem;
-	struct be_mem_descriptor *mem_descr;
+	struct be_eq_obj *pbe_eq;
 	void *cq_vaddress;
+	dma_addr_t paddr;
 
-	idx = 0;
-	cq = &phwi_context->be_cq;
-	eq = &phwi_context->be_eq.q;
-	mem = &cq->dma_mem;
-	mem_descr = phba->init_mem;
-	mem_descr += HWI_MEM_CQ;
-	cq_vaddress = mem_descr->mem_array[idx].virtual_address;
-	ret = be_fill_queue(cq, phba->params.icds_per_ctrl / 2,
-			    sizeof(struct sol_cqe), cq_vaddress);
-	if (ret) {
-		shost_printk(KERN_ERR, phba->shost,
-			     "be_fill_queue Failed for ISCSI CQ \n");
-		return ret;
-	}
+	num_cq_pages = PAGES_REQUIRED(phba->params.num_cq_entries * \
+				      sizeof(struct sol_cqe));
 
-	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
-	ret = beiscsi_cmd_cq_create(&phba->ctrl, cq, eq, false, false, 0);
-	if (ret) {
-		shost_printk(KERN_ERR, phba->shost,
-			     "beiscsi_cmd_eq_create Failed for ISCSI CQ \n");
-		return ret;
+	for (i = 0; i < phba->num_cpus; i++) {
+		cq = &phwi_context->be_cq[i];
+		eq = &phwi_context->be_eq[i].q;
+		pbe_eq = &phwi_context->be_eq[i];
+		pbe_eq->cq = cq;
+		pbe_eq->phba = phba;
+		mem = &cq->dma_mem;
+		cq_vaddress = pci_alloc_consistent(phba->pcidev,
+						     num_cq_pages * PAGE_SIZE,
+						     &paddr);
+		if (!cq_vaddress)
+			goto create_cq_error;
+		ret = be_fill_queue(cq, phba->params.icds_per_ctrl / 2,
+				    sizeof(struct sol_cqe), cq_vaddress);
+		if (ret) {
+			shost_printk(KERN_ERR, phba->shost,
+				     "be_fill_queue Failed for ISCSI CQ \n");
+			goto create_cq_error;
+		}
+
+		mem->dma = paddr;
+		ret = beiscsi_cmd_cq_create(&phba->ctrl, cq, eq, false,
+					    false, 0);
+		if (ret) {
+			shost_printk(KERN_ERR, phba->shost,
+				     "beiscsi_cmd_eq_create"
+				     "Failed for ISCSI CQ \n");
+			goto create_cq_error;
+		}
+		SE_DEBUG(DBG_LVL_8, "iscsi cq_id is %d for eq_id %d\n",
+						 cq->id, eq->id);
+		SE_DEBUG(DBG_LVL_8, "ISCSI CQ CREATED\n");
 	}
-	SE_DEBUG(DBG_LVL_8, "iscsi cq id is %d\n", phwi_context->be_cq.id);
-	SE_DEBUG(DBG_LVL_8, "ISCSI CQ CREATED\n");
 	return 0;
+
+create_cq_error:
+	for (i = 0; i < phba->num_cpus; i++) {
+		cq = &phwi_context->be_cq[i];
+		mem = &cq->dma_mem;
+		if (mem->va)
+			pci_free_consistent(phba->pcidev, num_cq_pages
+					    * PAGE_SIZE,
+					    mem->va, mem->dma);
+	}
+	return ret;
+
 }
 
 static int
@@ -2132,7 +2366,7 @@ beiscsi_create_def_hdr(struct beiscsi_hba *phba,
 
 	idx = 0;
 	dq = &phwi_context->be_def_hdrq;
-	cq = &phwi_context->be_cq;
+	cq = &phwi_context->be_cq[0];
 	mem = &dq->dma_mem;
 	mem_descr = phba->init_mem;
 	mem_descr += HWI_MEM_ASYNC_HEADER_RING;
@@ -2176,7 +2410,7 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 
 	idx = 0;
 	dataq = &phwi_context->be_def_dataq;
-	cq = &phwi_context->be_cq;
+	cq = &phwi_context->be_cq[0];
 	mem = &dataq->dma_mem;
 	mem_descr = phba->init_mem;
 	mem_descr += HWI_MEM_ASYNC_DATA_RING;
@@ -2239,6 +2473,30 @@ beiscsi_post_pages(struct beiscsi_hba *phba)
 	return 0;
 }
 
+static void be_queue_free(struct beiscsi_hba *phba, struct be_queue_info *q)
+{
+	struct be_dma_mem *mem = &q->dma_mem;
+	if (mem->va)
+		pci_free_consistent(phba->pcidev, mem->size,
+			mem->va, mem->dma);
+}
+
+static int be_queue_alloc(struct beiscsi_hba *phba, struct be_queue_info *q,
+		u16 len, u16 entry_size)
+{
+	struct be_dma_mem *mem = &q->dma_mem;
+
+	memset(q, 0, sizeof(*q));
+	q->len = len;
+	q->entry_size = entry_size;
+	mem->size = len * entry_size;
+	mem->va = pci_alloc_consistent(phba->pcidev, mem->size, &mem->dma);
+	if (!mem->va)
+		return -1;
+	memset(mem->va, 0, mem->size);
+	return 0;
+}
+
 static int
 beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 			 struct hwi_context_memory *phwi_context,
@@ -2328,13 +2586,29 @@ static void free_wrb_handles(struct beiscsi_hba *phba)
 	}
 }
 
+static void be_mcc_queues_destroy(struct beiscsi_hba *phba)
+{
+	struct be_queue_info *q;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+
+	q = &phba->ctrl.mcc_obj.q;
+	if (q->created)
+		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_MCCQ);
+	be_queue_free(phba, q);
+
+	q = &phba->ctrl.mcc_obj.cq;
+	if (q->created)
+		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_CQ);
+	be_queue_free(phba, q);
+}
+
 static void hwi_cleanup(struct beiscsi_hba *phba)
 {
 	struct be_queue_info *q;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
-	int i;
+	int i, eq_num;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
@@ -2343,7 +2617,6 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 		if (q->created)
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_WRBQ);
 	}
-
 	free_wrb_handles(phba);
 
 	q = &phwi_context->be_def_hdrq;
@@ -2356,13 +2629,76 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 
 	beiscsi_cmd_q_destroy(ctrl, NULL, QTYPE_SGL);
 
-	q = &phwi_context->be_cq;
-	if (q->created)
-		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_CQ);
+	for (i = 0; i < (phba->num_cpus); i++) {
+		q = &phwi_context->be_cq[i];
+		if (q->created)
+			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_CQ);
+	}
+	if (phba->msix_enabled)
+		eq_num = 1;
+	else
+		eq_num = 0;
+	for (i = 0; i < (phba->num_cpus + eq_num); i++) {
+		q = &phwi_context->be_eq[i].q;
+		if (q->created)
+			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_EQ);
+	}
+	be_mcc_queues_destroy(phba);
+}
 
-	q = &phwi_context->be_eq.q;
-	if (q->created)
-		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_EQ);
+static int be_mcc_queues_create(struct beiscsi_hba *phba,
+				struct hwi_context_memory *phwi_context)
+{
+	struct be_queue_info *q, *cq;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+
+	/* Alloc MCC compl queue */
+	cq = &phba->ctrl.mcc_obj.cq;
+	if (be_queue_alloc(phba, cq, MCC_CQ_LEN,
+			sizeof(struct be_mcc_compl)))
+		goto err;
+	/* Ask BE to create MCC compl queue; */
+	if (phba->msix_enabled) {
+		if (beiscsi_cmd_cq_create(ctrl, cq, &phwi_context->be_eq
+					 [phba->num_cpus].q, false, true, 0))
+		goto mcc_cq_free;
+	} else {
+		if (beiscsi_cmd_cq_create(ctrl, cq, &phwi_context->be_eq[0].q,
+					  false, true, 0))
+		goto mcc_cq_free;
+	}
+
+	/* Alloc MCC queue */
+	q = &phba->ctrl.mcc_obj.q;
+	if (be_queue_alloc(phba, q, MCC_Q_LEN, sizeof(struct be_mcc_wrb)))
+		goto mcc_cq_destroy;
+
+	/* Ask BE to create MCC queue */
+	if (be_cmd_mccq_create(phba, q, cq))
+		goto mcc_q_free;
+
+	return 0;
+
+mcc_q_free:
+	be_queue_free(phba, q);
+mcc_cq_destroy:
+	beiscsi_cmd_q_destroy(ctrl, cq, QTYPE_CQ);
+mcc_cq_free:
+	be_queue_free(phba, cq);
+err:
+	return -1;
+}
+
+static int find_num_cpus(void)
+{
+	int  num_cpus = 0;
+
+	num_cpus = num_online_cpus();
+	if (num_cpus >= MAX_CPUS)
+		num_cpus = MAX_CPUS - 1;
+
+	SE_DEBUG(DBG_LVL_8, "num_cpus = %d \n", num_cpus);
+	return num_cpus;
 }
 
 static int hwi_init_port(struct beiscsi_hba *phba)
@@ -2376,20 +2712,23 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 	def_pdu_ring_sz =
 		phba->params.asyncpdus_per_ctrl * sizeof(struct phys_addr);
 	phwi_ctrlr = phba->phwi_ctrlr;
-
 	phwi_context = phwi_ctrlr->phwi_ctxt;
-	phwi_context->be_eq.max_eqd = 0;
-	phwi_context->be_eq.min_eqd = 0;
-	phwi_context->be_eq.cur_eqd = 64;
-	phwi_context->be_eq.enable_aic = false;
+	phwi_context->max_eqd = 0;
+	phwi_context->min_eqd = 0;
+	phwi_context->cur_eqd = 64;
 	be_cmd_fw_initialize(&phba->ctrl);
-	status = beiscsi_create_eq(phba, phwi_context);
+
+	status = beiscsi_create_eqs(phba, phwi_context);
 	if (status != 0) {
 		shost_printk(KERN_ERR, phba->shost, "EQ not created \n");
 		goto error;
 	}
 
-	status = mgmt_check_supported_fw(ctrl);
+	status = be_mcc_queues_create(phba, phwi_context);
+	if (status != 0)
+		goto error;
+
+	status = mgmt_check_supported_fw(ctrl, phba);
 	if (status != 0) {
 		shost_printk(KERN_ERR, phba->shost,
 			     "Unsupported fw version \n");
@@ -2403,7 +2742,7 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 		goto error;
 	}
 
-	status = beiscsi_create_cq(phba, phwi_context);
+	status = beiscsi_create_cqs(phba, phwi_context);
 	if (status != 0) {
 		shost_printk(KERN_ERR, phba->shost, "CQ not created\n");
 		goto error;
@@ -2447,7 +2786,6 @@ error:
 	return -ENOMEM;
 }
 
-
 static int hwi_init_controller(struct beiscsi_hba *phba)
 {
 	struct hwi_controller *phwi_ctrlr;
@@ -2530,6 +2868,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 
 	phba->io_sgl_hndl_avbl = 0;
 	phba->eh_sgl_hndl_avbl = 0;
+
 	mem_descr_sglh = phba->init_mem;
 	mem_descr_sglh += HWI_MEM_SGLH;
 	if (1 == mem_descr_sglh->num_elements) {
@@ -2656,13 +2995,12 @@ static unsigned char hwi_enable_intr(struct beiscsi_hba *phba)
 	struct hwi_context_memory *phwi_context;
 	struct be_queue_info *eq;
 	u8 __iomem *addr;
-	u32 reg;
+	u32 reg, i;
 	u32 enabled;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 
-	eq = &phwi_context->be_eq.q;
 	addr = (u8 __iomem *) ((u8 __iomem *) ctrl->pcicfg +
 			PCICFG_MEMBAR_CTRL_INT_CTRL_OFFSET);
 	reg = ioread32(addr);
@@ -2673,9 +3011,11 @@ static unsigned char hwi_enable_intr(struct beiscsi_hba *phba)
 		reg |= MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
 		SE_DEBUG(DBG_LVL_8, "reg =x%08x addr=%p \n", reg, addr);
 		iowrite32(reg, addr);
-		SE_DEBUG(DBG_LVL_8, "eq->id=%d \n", eq->id);
-
-		hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
+		for (i = 0; i <= phba->num_cpus; i++) {
+			eq = &phwi_context->be_eq[i].q;
+			SE_DEBUG(DBG_LVL_8, "eq->id=%d \n", eq->id);
+			hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
+		}
 	} else
 		shost_printk(KERN_WARNING, phba->shost,
 			     "In hwi_enable_intr, Not Enabled \n");
@@ -2738,17 +3078,25 @@ static void hwi_purge_eq(struct beiscsi_hba *phba)
 	struct hwi_context_memory *phwi_context;
 	struct be_queue_info *eq;
 	struct be_eq_entry *eqe = NULL;
+	int i, eq_msix;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
-	eq = &phwi_context->be_eq.q;
-	eqe = queue_tail_node(eq);
+	if (phba->msix_enabled)
+		eq_msix = 1;
+	else
+		eq_msix = 0;
 
-	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
-						& EQE_VALID_MASK) {
-		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
-		queue_tail_inc(eq);
+	for (i = 0; i < (phba->num_cpus + eq_msix); i++) {
+		eq = &phwi_context->be_eq[i].q;
 		eqe = queue_tail_node(eq);
+
+		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+					& EQE_VALID_MASK) {
+			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+			queue_tail_inc(eq);
+			eqe = queue_tail_node(eq);
+		}
 	}
 }
 
@@ -2846,8 +3194,8 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_target_context_update_wrb));
 
 	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
-	doorbell |= (pwrb_handle->wrb_index & DB_DEF_PDU_WRB_INDEX_MASK) <<
-					DB_DEF_PDU_WRB_INDEX_SHIFT;
+	doorbell |= (pwrb_handle->wrb_index & DB_DEF_PDU_WRB_INDEX_MASK)
+			     << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
 
 	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
@@ -2856,7 +3204,7 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 static void beiscsi_parse_pdu(struct iscsi_conn *conn, itt_t itt,
 			      int *index, int *age)
 {
-	*index = be32_to_cpu(itt) >> 16;
+	*index = (int)itt;
 	if (age)
 		*age = conn->session->age;
 }
@@ -2885,15 +3233,13 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 
 	io_task->cmd_bhs = pci_pool_alloc(beiscsi_sess->bhs_pool,
 					  GFP_KERNEL, &paddr);
-
 	if (!io_task->cmd_bhs)
 		return -ENOMEM;
-
 	io_task->bhs_pa.u.a64.address = paddr;
+	io_task->libiscsi_itt = (itt_t)task->itt;
 	io_task->pwrb_handle = alloc_wrb_handle(phba,
 						beiscsi_conn->beiscsi_conn_cid,
 						task->itt);
-	io_task->pwrb_handle->pio_handle = task;
 	io_task->conn = beiscsi_conn;
 
 	task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs->iscsi_hdr;
@@ -2905,7 +3251,6 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		spin_unlock(&phba->io_sgl_lock);
 		if (!io_task->psgl_handle)
 			goto free_hndls;
-
 	} else {
 		io_task->scsi_cmnd = NULL;
 		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
@@ -2932,8 +3277,11 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				goto free_hndls;
 		}
 	}
-	itt = (itt_t) cpu_to_be32(((unsigned int)task->itt << 16) |
-			(unsigned int)(io_task->psgl_handle->sgl_index));
+	itt = (itt_t) cpu_to_be32(((unsigned int)io_task->pwrb_handle->
+				 wrb_index << 16) | (unsigned int)
+				(io_task->psgl_handle->sgl_index));
+	io_task->pwrb_handle->pio_handle = task;
+
 	io_task->cmd_bhs->iscsi_hdr.itt = itt;
 	return 0;
 
@@ -3006,7 +3354,6 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 	io_task->bhs_len = sizeof(struct be_cmd_bhs);
 
 	if (writedir) {
-		SE_DEBUG(DBG_LVL_4, " WRITE Command \t");
 		memset(&io_task->cmd_bhs->iscsi_data_pdu, 0, 48);
 		AMAP_SET_BITS(struct amap_pdu_data_out, itt,
 			      &io_task->cmd_bhs->iscsi_data_pdu,
@@ -3016,11 +3363,12 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 			      ISCSI_OPCODE_SCSI_DATA_OUT);
 		AMAP_SET_BITS(struct amap_pdu_data_out, final_bit,
 			      &io_task->cmd_bhs->iscsi_data_pdu, 1);
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_WR_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+				      INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 	} else {
-		SE_DEBUG(DBG_LVL_4, "READ Command \t");
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_RD_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+				      INI_RD_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
 	}
 	memcpy(&io_task->cmd_bhs->iscsi_data_pdu.
@@ -3059,10 +3407,16 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	struct iscsi_conn *conn = task->conn;
 	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct iscsi_session *session;
 	struct iscsi_wrb *pwrb = NULL;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_wrb_context *pwrb_context;
+	struct wrb_handle *pwrb_handle;
 	unsigned int doorbell = 0;
+	unsigned int i, cid;
 	struct iscsi_task *aborted_task;
 
+	cid = beiscsi_conn->beiscsi_conn_cid;
 	pwrb = io_task->pwrb_handle->pwrb;
 	AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb,
 		      be32_to_cpu(task->cmdsn));
@@ -3073,33 +3427,43 @@ static int beiscsi_mtask(struct iscsi_task *task)
 
 	switch (task->hdr->opcode & ISCSI_OPCODE_MASK) {
 	case ISCSI_OP_LOGIN:
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, TGT_DM_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+				      TGT_DM_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_NOOP_OUT:
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_RD_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+				      INI_RD_CMD);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_TEXT:
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_WR_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+				      INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
-		aborted_task = iscsi_itt_to_task(conn,
-					((struct iscsi_tm *)task->hdr)->rtt);
+		session = conn->session;
+		i = ((struct iscsi_tm *)task->hdr)->rtt;
+		phwi_ctrlr = phba->phwi_ctrlr;
+		pwrb_context = &phwi_ctrlr->wrb_context[cid];
+		pwrb_handle = pwrb_context->pwrb_handle_basestd[be32_to_cpu(i)
+								>> 16];
+		aborted_task = pwrb_handle->pio_handle;
 		 if (!aborted_task)
 			return 0;
+
 		aborted_io_task = aborted_task->dd_data;
 		if (!aborted_io_task->scsi_cmnd)
 			return 0;
 
 		mgmt_invalidate_icds(phba,
 				     aborted_io_task->psgl_handle->sgl_index,
-				     beiscsi_conn->beiscsi_conn_cid);
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_TMF_CMD);
+				     cid);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+				      INI_TMF_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		hwi_write_buffer(pwrb, task);
 		break;
@@ -3122,7 +3486,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		      io_task->pwrb_handle->nxt_wrb_index);
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
 
-	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
+	doorbell |= cid & DB_WRB_POST_CID_MASK;
 	doorbell |= (io_task->pwrb_handle->wrb_index &
 		     DB_DEF_PDU_WRB_INDEX_MASK) << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
@@ -3165,9 +3529,14 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	return beiscsi_iotask(task, sg, num_sg, xferlen, writedir);
 }
 
+
 static void beiscsi_remove(struct pci_dev *pcidev)
 {
 	struct beiscsi_hba *phba = NULL;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	struct be_eq_obj *pbe_eq;
+	unsigned int i, msix_vec;
 
 	phba = (struct beiscsi_hba *)pci_get_drvdata(pcidev);
 	if (!phba) {
@@ -3175,12 +3544,24 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 		return;
 	}
 
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
 	hwi_disable_intr(phba);
-	if (phba->pcidev->irq)
-		free_irq(phba->pcidev->irq, phba);
+	if (phba->msix_enabled) {
+		for (i = 0; i <= phba->num_cpus; i++) {
+			msix_vec = phba->msix_entries[i].vector;
+			free_irq(msix_vec, &phwi_context->be_eq[i]);
+		}
+	} else
+		if (phba->pcidev->irq)
+			free_irq(phba->pcidev->irq, phba);
+	pci_disable_msix(phba->pcidev);
 	destroy_workqueue(phba->wq);
 	if (blk_iopoll_enabled)
-		blk_iopoll_disable(&phba->iopoll);
+		for (i = 0; i < phba->num_cpus; i++) {
+			pbe_eq = &phwi_context->be_eq[i];
+			blk_iopoll_disable(&pbe_eq->iopoll);
+		}
 
 	beiscsi_clean_port(phba);
 	beiscsi_free_mem(phba);
@@ -3194,11 +3575,29 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	iscsi_host_free(phba->shost);
 }
 
+static void beiscsi_msix_enable(struct beiscsi_hba *phba)
+{
+	int i, status;
+
+	for (i = 0; i <= phba->num_cpus; i++)
+		phba->msix_entries[i].entry = i;
+
+	status = pci_enable_msix(phba->pcidev, phba->msix_entries,
+				 (phba->num_cpus + 1));
+	if (!status)
+		phba->msix_enabled = true;
+
+	return;
+}
+
 static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 				const struct pci_device_id *id)
 {
 	struct beiscsi_hba *phba = NULL;
-	int ret;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	struct be_eq_obj *pbe_eq;
+	int ret, msix_vec, num_cpus, i;
 
 	ret = beiscsi_enable_pci(pcidev);
 	if (ret < 0) {
@@ -3213,8 +3612,18 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 			" Failed in beiscsi_hba_alloc \n");
 		goto disable_pci;
 	}
+	SE_DEBUG(DBG_LVL_8, " phba = %p \n", phba);
 
 	pci_set_drvdata(pcidev, phba);
+	if (enable_msix)
+		num_cpus = find_num_cpus();
+	else
+		num_cpus = 1;
+	phba->num_cpus = num_cpus;
+	SE_DEBUG(DBG_LVL_8, "num_cpus = %d \n", phba->num_cpus);
+
+	if (enable_msix)
+		beiscsi_msix_enable(phba);
 	ret = be_ctrl_init(phba, pcidev);
 	if (ret) {
 		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
@@ -3235,7 +3644,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_q_irq%u",
 		 phba->shost->host_no);
-	phba->wq = create_singlethread_workqueue(phba->wq_name);
+	phba->wq = create_workqueue(phba->wq_name);
 	if (!phba->wq) {
 		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
 				"Failed to allocate work queue\n");
@@ -3244,11 +3653,16 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	INIT_WORK(&phba->work_cqs, beiscsi_process_all_cqs);
 
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
 	if (blk_iopoll_enabled) {
-		blk_iopoll_init(&phba->iopoll, be_iopoll_budget, be_iopoll);
-		blk_iopoll_enable(&phba->iopoll);
+		for (i = 0; i < phba->num_cpus; i++) {
+			pbe_eq = &phwi_context->be_eq[i];
+			blk_iopoll_init(&pbe_eq->iopoll, be_iopoll_budget,
+					be_iopoll);
+			blk_iopoll_enable(&pbe_eq->iopoll);
+		}
 	}
-
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
 		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
@@ -3261,17 +3675,26 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 			     "Failed to hwi_enable_intr\n");
 		goto free_ctrlr;
 	}
-
 	SE_DEBUG(DBG_LVL_8, "\n\n\n SUCCESS - DRIVER LOADED \n\n\n");
 	return 0;
 
 free_ctrlr:
-	if (phba->pcidev->irq)
-		free_irq(phba->pcidev->irq, phba);
+	if (phba->msix_enabled) {
+		for (i = 0; i <= phba->num_cpus; i++) {
+			msix_vec = phba->msix_entries[i].vector;
+			free_irq(msix_vec, &phwi_context->be_eq[i]);
+		}
+	} else
+		if (phba->pcidev->irq)
+			free_irq(phba->pcidev->irq, phba);
+	pci_disable_msix(phba->pcidev);
 free_blkenbld:
 	destroy_workqueue(phba->wq);
 	if (blk_iopoll_enabled)
-		blk_iopoll_disable(&phba->iopoll);
+		for (i = 0; i < phba->num_cpus; i++) {
+			pbe_eq = &phwi_context->be_eq[i];
+			blk_iopoll_disable(&pbe_eq->iopoll);
+		}
 free_twq:
 	beiscsi_clean_port(phba);
 	beiscsi_free_mem(phba);
@@ -3351,6 +3774,7 @@ static struct pci_driver beiscsi_pci_driver = {
 	.id_table = beiscsi_pci_id_table
 };
 
+
 static int __init beiscsi_module_init(void)
 {
 	int ret;
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 53c9b70..25e6b20 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -21,11 +21,9 @@
 #ifndef _BEISCSI_MAIN_
 #define _BEISCSI_MAIN_
 
-
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/in.h>
-#include <linux/blk-iopoll.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -35,12 +33,8 @@
 #include <scsi/scsi_transport_iscsi.h>
 
 #include "be.h"
-
-
-
 #define DRV_NAME		"be2iscsi"
 #define BUILD_STR		"2.0.527.0"
-
 #define BE_NAME			"ServerEngines BladeEngine2" \
 				"Linux iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
@@ -49,6 +43,8 @@
 #define BE_DEVICE_ID1		0x212
 #define OC_DEVICE_ID1		0x702
 #define OC_DEVICE_ID2		0x703
+#define OC_DEVICE_ID3		0x712
+#define OC_DEVICE_ID4		0x222
 
 #define BE2_MAX_SESSIONS	64
 #define BE2_CMDS_PER_CXN	128
@@ -63,6 +59,7 @@
 #define BE2_IO_DEPTH \
 	(BE2_MAX_ICDS / 2 - (BE2_LOGOUTS + BE2_TMFS + BE2_NOPOUT_REQ))
 
+#define MAX_CPUS		31
 #define BEISCSI_SGLIST_ELEMENTS	BE2_SGE
 
 #define BEISCSI_MAX_CMNDS	1024	/* Max IO's per Ctrlr sht->can_queue */
@@ -79,7 +76,7 @@
 #define BE_SENSE_INFO_SIZE		258
 #define BE_ISCSI_PDU_HEADER_SIZE	64
 #define BE_MIN_MEM_SIZE			16384
-
+#define MAX_CMD_SZ			65536
 #define IIOC_SCSI_DATA                  0x05	/* Write Operation */
 
 #define DBG_LVL				0x00000001
@@ -100,6 +97,8 @@ do {							\
 	}						\
 } while (0);
 
+#define BE_ADAPTER_UP		0x00000000
+#define BE_ADAPTER_LINK_DOWN	0x00000001
 /**
  * hardware needs the async PDU buffers to be posted in multiples of 8
  * So have atleast 8 of them by default
@@ -160,21 +159,19 @@ do {							\
 
 enum be_mem_enum {
 	HWI_MEM_ADDN_CONTEXT,
-	HWI_MEM_CQ,
-	HWI_MEM_EQ,
 	HWI_MEM_WRB,
 	HWI_MEM_WRBH,
-	HWI_MEM_SGLH,	/* 5 */
+	HWI_MEM_SGLH,
 	HWI_MEM_SGE,
-	HWI_MEM_ASYNC_HEADER_BUF,
+	HWI_MEM_ASYNC_HEADER_BUF, 	/* 5 */
 	HWI_MEM_ASYNC_DATA_BUF,
 	HWI_MEM_ASYNC_HEADER_RING,
-	HWI_MEM_ASYNC_DATA_RING,	/* 10 */
+	HWI_MEM_ASYNC_DATA_RING,
 	HWI_MEM_ASYNC_HEADER_HANDLE,
-	HWI_MEM_ASYNC_DATA_HANDLE,
+	HWI_MEM_ASYNC_DATA_HANDLE, 	/* 10 */
 	HWI_MEM_ASYNC_PDU_CONTEXT,
 	ISCSI_MEM_GLOBAL_HEADER,
-	SE_MEM_MAX  	/* 15 */
+	SE_MEM_MAX
 };
 
 struct be_bus_address32 {
@@ -212,6 +209,9 @@ struct be_mem_descriptor {
 
 struct sgl_handle {
 	unsigned int sgl_index;
+	unsigned int type;
+	unsigned int cid;
+	struct iscsi_task *task;
 	struct iscsi_sge *pfrag;
 };
 
@@ -274,13 +274,17 @@ struct beiscsi_hba {
 	struct pci_dev *pcidev;
 	unsigned int state;
 	unsigned short asic_revision;
-	struct blk_iopoll	iopoll;
+	unsigned int num_cpus;
+	unsigned int nxt_cqid;
+	struct msix_entry msix_entries[MAX_CPUS + 1];
+	bool msix_enabled;
 	struct be_mem_descriptor *init_mem;
 
 	unsigned short io_sgl_alloc_index;
 	unsigned short io_sgl_free_index;
 	unsigned short io_sgl_hndl_avbl;
 	struct sgl_handle **io_sgl_hndl_base;
+	struct sgl_handle **sgl_hndl_array;
 
 	unsigned short eh_sgl_alloc_index;
 	unsigned short eh_sgl_free_index;
@@ -315,6 +319,7 @@ struct beiscsi_hba {
 		unsigned short cid_alloc;
 		unsigned short cid_free;
 		unsigned short avlbl_cids;
+		unsigned short iscsi_features;
 		spinlock_t cid_lock;
 	} fw_config;
 
@@ -343,6 +348,7 @@ struct beiscsi_conn {
 	unsigned short login_in_progress;
 	struct sgl_handle *plogin_sgl_handle;
 	struct beiscsi_session *beiscsi_sess;
+	struct iscsi_task *task;
 };
 
 /* This structure is used by the chip */
@@ -390,7 +396,7 @@ struct beiscsi_io_task {
 	unsigned int flags;
 	unsigned short cid;
 	unsigned short header_len;
-
+	itt_t libiscsi_itt;
 	struct be_cmd_bhs *cmd_bhs;
 	struct be_bus_address bhs_pa;
 	unsigned short bhs_len;
@@ -599,7 +605,6 @@ struct amap_cq_db {
 
 void beiscsi_process_eq(struct beiscsi_hba *phba);
 
-
 struct iscsi_wrb {
 	u32 dw[16];
 } __packed;
@@ -820,10 +825,12 @@ struct wrb_handle {
 };
 
 struct hwi_context_memory {
-	struct be_eq_obj be_eq;
-	struct be_queue_info be_cq;
-	struct be_queue_info be_mcc_cq;
-	struct be_queue_info be_mcc;
+	/* Adaptive interrupt coalescing (AIC) info */
+	u16 min_eqd;		/* in usecs */
+	u16 max_eqd;		/* in usecs */
+	u16 cur_eqd;		/* in usecs */
+	struct be_eq_obj be_eq[MAX_CPUS];
+	struct be_queue_info be_cq[MAX_CPUS];
 
 	struct be_queue_info be_def_hdrq;
 	struct be_queue_info be_def_dataq;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 12e644f..79c2bd5 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -35,7 +35,6 @@ unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
 			   OPCODE_COMMON_QUERY_FIRMWARE_CONFIG, sizeof(*req));
-
 	status = be_mbox_notify(ctrl);
 	if (!status) {
 		struct be_fw_cfg *pfw_cfg;
@@ -58,7 +57,8 @@ unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 	return status;
 }
 
-unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl)
+unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
+				      struct beiscsi_hba *phba)
 {
 	struct be_dma_mem nonemb_cmd;
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
@@ -85,7 +85,6 @@ unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl)
 	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
 	sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
 	sge->len = cpu_to_le32(nonemb_cmd.size);
-
 	status = be_mbox_notify(ctrl);
 	if (!status) {
 		struct be_mgmt_controller_attributes_resp *resp = nonemb_cmd.va;
@@ -95,21 +94,25 @@ unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl)
 			resp->params.hba_attribs.firmware_version_string);
 		SE_DEBUG(DBG_LVL_8,
 			"Developer Build, not performing version check...\n");
-
+		phba->fw_config.iscsi_features =
+				resp->params.hba_attribs.iscsi_features;
+		SE_DEBUG(DBG_LVL_8, " phba->fw_config.iscsi_features = %d\n",
+				      phba->fw_config.iscsi_features);
 	} else
 		SE_DEBUG(DBG_LVL_1, " Failed in mgmt_check_supported_fw\n");
+	spin_unlock(&ctrl->mbox_lock);
 	if (nonemb_cmd.va)
 		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 
-	spin_unlock(&ctrl->mbox_lock);
 	return status;
 }
 
+
 unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
 	struct iscsi_cleanup_req *req = embedded_payload(wrb);
 	int status = 0;
 
@@ -124,7 +127,7 @@ unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 	req->hdr_ring_id = 0;
 	req->data_ring_id = 0;
 
-	status = be_mbox_notify(ctrl);
+	status =  be_mcc_notify_wait(phba);
 	if (status)
 		shost_printk(KERN_WARNING, phba->shost,
 			     " mgmt_epfw_cleanup , FAILED\n");
@@ -137,7 +140,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 {
 	struct be_dma_mem nonemb_cmd;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
 	struct be_sge *sge = nonembedded_sgl(wrb);
 	struct invalidate_commands_params_in *req;
 	int status = 0;
@@ -169,7 +172,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 	sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
 	sge->len = cpu_to_le32(nonemb_cmd.size);
 
-	status = be_mbox_notify(ctrl);
+	status = be_mcc_notify_wait(phba);
 	if (status)
 		SE_DEBUG(DBG_LVL_1, "ICDS Invalidation Failed\n");
 	spin_unlock(&ctrl->mbox_lock);
@@ -186,7 +189,7 @@ unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 unsigned short savecfg_flag)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
 	struct iscsi_invalidate_connection_params_in *req =
 						embedded_payload(wrb);
 	int status = 0;
@@ -205,7 +208,7 @@ unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
 	else
 		req->cleanup_type = CMD_ISCSI_CONNECTION_INVALIDATE;
 	req->save_cfg = savecfg_flag;
-	status = be_mbox_notify(ctrl);
+	status =  be_mcc_notify_wait(phba);
 	if (status)
 		SE_DEBUG(DBG_LVL_1, "Invalidation Failed\n");
 
@@ -217,7 +220,7 @@ unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
 				unsigned short cid, unsigned int upload_flag)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
 	struct tcp_upload_params_in *req = embedded_payload(wrb);
 	int status = 0;
 
@@ -229,7 +232,7 @@ unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
 			   OPCODE_COMMON_TCP_UPLOAD, sizeof(*req));
 	req->id = (unsigned short)cid;
 	req->upload_type = (unsigned char)upload_flag;
-	status = be_mbox_notify(ctrl);
+	status = be_mcc_notify_wait(phba);
 	if (status)
 		SE_DEBUG(DBG_LVL_1, "mgmt_upload_connection Failed\n");
 	spin_unlock(&ctrl->mbox_lock);
@@ -245,13 +248,14 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	struct sockaddr_in *daddr_in = (struct sockaddr_in *)dst_addr;
 	struct sockaddr_in6 *daddr_in6 = (struct sockaddr_in6 *)dst_addr;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
 	struct tcp_connect_and_offload_in *req = embedded_payload(wrb);
 	unsigned short def_hdr_id;
 	unsigned short def_data_id;
 	struct phys_addr template_address = { 0, 0 };
 	struct phys_addr *ptemplate_address;
 	int status = 0;
+	unsigned int i;
 	unsigned short cid = beiscsi_ep->ep_cid;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
@@ -296,14 +300,18 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 
 	}
 	req->cid = cid;
-	req->cq_id = phwi_context->be_cq.id;
+	i = phba->nxt_cqid++;
+	if (phba->nxt_cqid == phba->num_cpus)
+		phba->nxt_cqid = 0;
+	req->cq_id = phwi_context->be_cq[i].id;
+	SE_DEBUG(DBG_LVL_8, "i=%d cq_id=%d \n", i, req->cq_id);
 	req->defq_id = def_hdr_id;
 	req->hdr_ring_id = def_hdr_id;
 	req->data_ring_id = def_data_id;
 	req->do_offload = 1;
 	req->dataout_template_pa.lo = ptemplate_address->lo;
 	req->dataout_template_pa.hi = ptemplate_address->hi;
-	status = be_mbox_notify(ctrl);
+	status = be_mcc_notify_wait(phba);
 	if (!status) {
 		struct iscsi_endpoint *ep;
 		struct tcp_connect_and_offload_out *ptcpcnct_out =
@@ -311,7 +319,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 
 		ep = phba->ep_array[ptcpcnct_out->cid];
 		beiscsi_ep = ep->dd_data;
-		beiscsi_ep->fw_handle = 0;
+		beiscsi_ep->fw_handle = ptcpcnct_out->connection_handle;
 		beiscsi_ep->cid_vld = 1;
 		SE_DEBUG(DBG_LVL_8, "mgmt_open_connection Success\n");
 	} else
@@ -319,3 +327,30 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	spin_unlock(&ctrl->mbox_lock);
 	return status;
 }
+
+int be_cmd_get_mac_addr(struct beiscsi_hba *phba, u8 *mac_addr)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
+	struct be_cmd_req_get_mac_addr *req = embedded_payload(wrb);
+	int status;
+
+	SE_DEBUG(DBG_LVL_8, "In be_cmd_get_mac_addr\n");
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			   OPCODE_COMMON_ISCSI_NTWK_GET_NIC_CONFIG,
+			   sizeof(*req));
+
+	status = be_mcc_notify_wait(phba);
+	if (!status) {
+		struct be_cmd_resp_get_mac_addr *resp = embedded_payload(wrb);
+
+		memcpy(mac_addr, resp->mac_address, ETH_ALEN);
+	}
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 00e816e..24eaff9 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -175,7 +175,9 @@ struct mgmt_hba_attributes {
 	u8 phy_port;
 	u32 firmware_post_status;
 	u32 hba_mtu[8];
-	u32 future_u32[4];
+	u8 iscsi_features;
+	u8 future_u8[3];
+	u32 future_u32[3];
 } __packed;
 
 struct mgmt_controller_attributes {
@@ -246,4 +248,8 @@ unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 unsigned short cid,
 					 unsigned short issue_reset,
 					 unsigned short savecfg_flag);
+
+unsigned char mgmt_fw_cmd(struct be_ctrl_info *ctrl,
+			  struct beiscsi_hba *phba,
+			  char *buf, unsigned int len);
 #endif
-- 
1.6.4

