From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 5/9] be2iscsi: Fix to handle misconfigured optics events
Date: Mon, 14 Dec 2015 11:41:02 +0530
Message-ID: <1450073466-21077-6-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:54830 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752465AbbLNG2T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 01:28:19 -0500
In-Reply-To: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra <jitendra.bhivare@avagotech.com>

From: Jitendra <jitendra.bhivare@avagotech.com>

Log messages for misconfigured transceivers reported by FW.

Register async events that driver handles using MCC_CREATE_EXT ioctl.
Errors messages for faulted/uncertified/unqualified optics are logged.
Added FW config validation.

Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |  169 ++++++++++++++++++-----------
 drivers/scsi/be2iscsi/be_cmds.h |   47 +++++++-
 drivers/scsi/be2iscsi/be_main.c |   22 +---
 drivers/scsi/be2iscsi/be_main.h |   12 ++-
 drivers/scsi/be2iscsi/be_mgmt.c |  230 +++++++++++++++++++++++++++------------
 drivers/scsi/be2iscsi/be_mgmt.h |    2 +
 6 files changed, 327 insertions(+), 155 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index e4cc98f..58a9fda 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -267,26 +267,6 @@ void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
 	spin_unlock(&ctrl->mcc_lock);
 }
 
-bool is_link_state_evt(u32 trailer)
-{
-	return (((trailer >> ASYNC_TRAILER_EVENT_CODE_SHIFT) &
-		  ASYNC_TRAILER_EVENT_CODE_MASK) ==
-		  ASYNC_EVENT_CODE_LINK_STATE);
-}
-
-static bool is_iscsi_evt(u32 trailer)
-{
-	return ((trailer >> ASYNC_TRAILER_EVENT_CODE_SHIFT) &
-		  ASYNC_TRAILER_EVENT_CODE_MASK) ==
-		  ASYNC_EVENT_CODE_ISCSI;
-}
-
-static int iscsi_evt_type(u32 trailer)
-{
-	return (trailer >> ASYNC_TRAILER_EVENT_TYPE_SHIFT) &
-		 ASYNC_TRAILER_EVENT_TYPE_MASK;
-}
-
 static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)
 {
 	if (compl->flags != 0) {
@@ -343,7 +323,7 @@ static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
 			if (resp_hdr->response_length)
 				return 0;
 		}
-		return -EBUSY;
+		return -EINVAL;
 	}
 	return 0;
 }
@@ -422,7 +402,7 @@ void beiscsi_fail_session(struct iscsi_cls_session *cls_session)
 	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
 }
 
-void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
+static void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 		struct be_async_event_link_state *evt)
 {
 	if ((evt->port_link_status == ASYNC_EVENT_LINK_DOWN) ||
@@ -450,6 +430,103 @@ void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 	}
 }
 
+static char *beiscsi_port_misconf_event_msg[] = {
+	"Physical Link is functional.",
+	"Optics faulted/incorrectly installed/not installed - Reseat optics, if issue not resolved, replace.",
+	"Optics of two types installed - Remove one optic or install matching pair of optics.",
+	"Incompatible optics - Replace with compatible optics for card to function.",
+	"Unqualified optics - Replace with Avago optics for Warranty and Technical Support.",
+	"Uncertified optics - Replace with Avago Certified optics to enable link operation."
+};
+#define BEISCSI_PORT_MISCONF_EVENT_MAX \
+	(sizeof(beiscsi_port_misconf_event_msg) / \
+	 sizeof(beiscsi_port_misconf_event_msg[0]))
+
+static void beiscsi_process_async_sli(struct beiscsi_hba *phba,
+				      struct be_mcc_compl *compl)
+{
+	struct be_async_event_sli *async_sli;
+	u8 evt_type, state, old_state, le;
+	char *sev = KERN_WARNING;
+	char *msg = NULL;
+
+	evt_type = compl->flags >> ASYNC_TRAILER_EVENT_TYPE_SHIFT;
+	evt_type &= ASYNC_TRAILER_EVENT_TYPE_MASK;
+
+	/* processing only MISCONFIGURED physical port event */
+	if (evt_type != ASYNC_SLI_EVENT_TYPE_MISCONFIGURED)
+		return;
+
+	async_sli = (struct be_async_event_sli *)compl;
+	state = async_sli->event_data1 >>
+		 (phba->fw_config.phys_port * 8) & 0xff;
+	le = async_sli->event_data2 >>
+		 (phba->fw_config.phys_port * 8) & 0xff;
+
+	old_state = phba->optic_state;
+	phba->optic_state = state;
+
+	if (state >= BEISCSI_PORT_MISCONF_EVENT_MAX) {
+		/* fw is reporting a state we don't know, log and return */
+		__beiscsi_log(phba, KERN_ERR,
+			    "BC_%d : Port %c: Unrecognized optic state 0x%x\n",
+			    phba->port_name, async_sli->event_data1);
+		return;
+	}
+
+	if (ASYNC_SLI_LINK_EFFECT_VALID(le)) {
+		/* log link effect for unqualified-4, uncertified-5 optics */
+		if (state > 3)
+			msg = (ASYNC_SLI_LINK_EFFECT_STATE(le)) ?
+				" Link is non-operational." :
+				" Link is operational.";
+		/* 1 - info */
+		if (ASYNC_SLI_LINK_EFFECT_SEV(le) == 1)
+			sev = KERN_INFO;
+		/* 2 - error */
+		if (ASYNC_SLI_LINK_EFFECT_SEV(le) == 2)
+			sev = KERN_ERR;
+	}
+
+	if (old_state != phba->optic_state)
+		__beiscsi_log(phba, sev, "BC_%d : Port %c: %s%s\n",
+			      phba->port_name,
+			      beiscsi_port_misconf_event_msg[state],
+			      !msg ? "" : msg);
+}
+
+void beiscsi_process_async_event(struct beiscsi_hba *phba,
+				struct be_mcc_compl *compl)
+{
+	char *sev = KERN_INFO;
+	u8 evt_code;
+
+	/* interpret flags as an async trailer */
+	evt_code = compl->flags >> ASYNC_TRAILER_EVENT_CODE_SHIFT;
+	evt_code &= ASYNC_TRAILER_EVENT_CODE_MASK;
+	switch (evt_code) {
+	case ASYNC_EVENT_CODE_LINK_STATE:
+		beiscsi_async_link_state_process(phba,
+				(struct be_async_event_link_state *)compl);
+		break;
+	case ASYNC_EVENT_CODE_ISCSI:
+		phba->state |= BE_ADAPTER_CHECK_BOOT;
+		phba->get_boot = BE_GET_BOOT_RETRIES;
+		sev = KERN_ERR;
+		break;
+	case ASYNC_EVENT_CODE_SLI:
+		beiscsi_process_async_sli(phba, compl);
+		break;
+	default:
+		/* event not registered */
+		sev = KERN_ERR;
+	}
+
+	beiscsi_log(phba, sev, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		    "BC_%d : ASYNC Event: status 0x%08x flags 0x%08x\n",
+		    compl->status, compl->flags);
+}
+
 int beiscsi_process_mcc(struct beiscsi_hba *phba)
 {
 	struct be_mcc_compl *compl;
@@ -459,45 +536,10 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
 	spin_lock_bh(&phba->ctrl.mcc_cq_lock);
 	while ((compl = be_mcc_compl_get(phba))) {
 		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
-			/* Interpret flags as an async trailer */
-			if (is_link_state_evt(compl->flags))
-				/* Interpret compl as a async link evt */
-				beiscsi_async_link_state_process(phba,
-				   (struct be_async_event_link_state *) compl);
-			else if (is_iscsi_evt(compl->flags)) {
-				switch (iscsi_evt_type(compl->flags)) {
-				case ASYNC_EVENT_NEW_ISCSI_TGT_DISC:
-				case ASYNC_EVENT_NEW_ISCSI_CONN:
-				case ASYNC_EVENT_NEW_TCP_CONN:
-					phba->state |= BE_ADAPTER_CHECK_BOOT;
-					phba->get_boot = BE_GET_BOOT_RETRIES;
-					beiscsi_log(phba, KERN_ERR,
-						    BEISCSI_LOG_CONFIG |
-						    BEISCSI_LOG_MBOX,
-						    "BC_%d : Async iscsi Event,"
-						    " flags handled = 0x%08x\n",
-						    compl->flags);
-					break;
-				default:
-					phba->state |= BE_ADAPTER_CHECK_BOOT;
-					phba->get_boot = BE_GET_BOOT_RETRIES;
-					beiscsi_log(phba, KERN_ERR,
-						    BEISCSI_LOG_CONFIG |
-						    BEISCSI_LOG_MBOX,
-						    "BC_%d : Unsupported Async"
-						    " Event, flags = 0x%08x\n",
-						    compl->flags);
-				}
-			} else
-				beiscsi_log(phba, KERN_ERR,
-					    BEISCSI_LOG_CONFIG |
-					    BEISCSI_LOG_MBOX,
-					    "BC_%d : Unsupported Async Event, flags"
-					    " = 0x%08x\n", compl->flags);
-
+			beiscsi_process_async_event(phba, compl);
 		} else if (compl->flags & CQE_FLAGS_COMPLETED_MASK) {
-				status = be_mcc_compl_process(ctrl, compl);
-				atomic_dec(&phba->ctrl.mcc_obj.q.used);
+			status = be_mcc_compl_process(ctrl, compl);
+			atomic_dec(&phba->ctrl.mcc_obj.q.used);
 		}
 		be_mcc_compl_use(compl);
 		num++;
@@ -1013,7 +1055,7 @@ int beiscsi_cmd_mccq_create(struct beiscsi_hba *phba,
 			struct be_queue_info *cq)
 {
 	struct be_mcc_wrb *wrb;
-	struct be_cmd_req_mcc_create *req;
+	struct be_cmd_req_mcc_create_ext *req;
 	struct be_dma_mem *q_mem = &mccq->dma_mem;
 	struct be_ctrl_info *ctrl;
 	void *ctxt;
@@ -1029,9 +1071,12 @@ int beiscsi_cmd_mccq_create(struct beiscsi_hba *phba,
 	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
 
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
-			OPCODE_COMMON_MCC_CREATE, sizeof(*req));
+			OPCODE_COMMON_MCC_CREATE_EXT, sizeof(*req));
 
 	req->num_pages = PAGES_4K_SPANNED(q_mem->va, q_mem->size);
+	req->async_evt_bitmap = 1 << ASYNC_EVENT_CODE_LINK_STATE;
+	req->async_evt_bitmap |= 1 << ASYNC_EVENT_CODE_ISCSI;
+	req->async_evt_bitmap |= 1 << ASYNC_EVENT_CODE_SLI;
 
 	AMAP_SET_BITS(struct amap_mcc_context, fid, ctxt,
 		      PCI_FUNC(phba->pcidev->devfn));
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 5d165ee..6411f7b 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -119,13 +119,22 @@ struct be_mcc_compl {
 #define ASYNC_TRAILER_EVENT_CODE_MASK	0xFF
 #define ASYNC_EVENT_CODE_LINK_STATE	0x1
 #define ASYNC_EVENT_CODE_ISCSI		0x4
+#define ASYNC_EVENT_CODE_SLI		0x11
 
 #define ASYNC_TRAILER_EVENT_TYPE_SHIFT	16	/* bits 16 - 23 */
-#define ASYNC_TRAILER_EVENT_TYPE_MASK	0xF
+#define ASYNC_TRAILER_EVENT_TYPE_MASK	0xFF
+
+/* iSCSI events */
 #define ASYNC_EVENT_NEW_ISCSI_TGT_DISC	0x4
 #define ASYNC_EVENT_NEW_ISCSI_CONN	0x5
 #define ASYNC_EVENT_NEW_TCP_CONN	0x7
 
+/* SLI events */
+#define ASYNC_SLI_EVENT_TYPE_MISCONFIGURED	0x9
+#define ASYNC_SLI_LINK_EFFECT_VALID(le)		(le & 0x80)
+#define ASYNC_SLI_LINK_EFFECT_SEV(le)		((le >> 1)  & 0x03)
+#define ASYNC_SLI_LINK_EFFECT_STATE(le)		(le & 0x01)
+
 struct be_async_event_trailer {
 	u32 code;
 };
@@ -153,6 +162,16 @@ struct be_async_event_link_state {
 	struct be_async_event_trailer trailer;
 } __packed;
 
+/**
+ * When async-trailer is SLI event, mcc_compl is interpreted as
+ */
+struct be_async_event_sli {
+	u32 event_data1;
+	u32 event_data2;
+	u32 reserved;
+	u32 trailer;
+} __packed;
+
 struct be_mcc_mailbox {
 	struct be_mcc_wrb wrb;
 	struct be_mcc_compl compl;
@@ -172,6 +191,7 @@ struct be_mcc_mailbox {
 #define OPCODE_COMMON_CQ_CREATE				12
 #define OPCODE_COMMON_EQ_CREATE				13
 #define OPCODE_COMMON_MCC_CREATE			21
+#define OPCODE_COMMON_MCC_CREATE_EXT			90
 #define OPCODE_COMMON_ADD_TEMPLATE_HEADER_BUFFERS	24
 #define OPCODE_COMMON_REMOVE_TEMPLATE_HEADER_BUFFERS	25
 #define OPCODE_COMMON_GET_CNTL_ATTRIBUTES		32
@@ -183,6 +203,7 @@ struct be_mcc_mailbox {
 #define OPCODE_COMMON_EQ_DESTROY			55
 #define OPCODE_COMMON_QUERY_FIRMWARE_CONFIG		58
 #define OPCODE_COMMON_FUNCTION_RESET			61
+#define OPCODE_COMMON_GET_PORT_NAME			77
 
 /**
  * LIST of opcodes that are common between Initiator and Target
@@ -587,10 +608,11 @@ struct amap_mcc_context {
 	u8 rsvd2[32];
 } __packed;
 
-struct be_cmd_req_mcc_create {
+struct be_cmd_req_mcc_create_ext {
 	struct be_cmd_req_hdr hdr;
 	u16 num_pages;
 	u16 rsvd0;
+	u32 async_evt_bitmap;
 	u8 context[sizeof(struct amap_mcc_context) / 8];
 	struct phys_addr pages[8];
 } __packed;
@@ -748,8 +770,8 @@ struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba);
 int be_mcc_notify_wait(struct beiscsi_hba *phba);
 void be_mcc_notify(struct beiscsi_hba *phba);
 unsigned int alloc_mcc_tag(struct beiscsi_hba *phba);
-void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
-		struct be_async_event_link_state *evt);
+void beiscsi_process_async_event(struct beiscsi_hba *phba,
+				struct be_mcc_compl *compl);
 int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
 				    struct be_mcc_compl *compl);
 
@@ -777,8 +799,6 @@ int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
 		       struct hwi_wrb_context *pwrb_context,
 		       uint8_t ulp_num);
 
-bool is_link_state_evt(u32 trailer);
-
 /* Configuration Functions */
 int be_cmd_set_vlan(struct beiscsi_hba *phba, uint16_t vlan_tag);
 
@@ -1137,6 +1157,21 @@ struct be_cmd_get_all_if_id_req {
 	u32 if_hndl_list[1];
 } __packed;
 
+struct be_cmd_get_port_name {
+	union {
+		struct be_cmd_req_hdr req_hdr;
+		struct be_cmd_resp_hdr resp_hdr;
+	} h;
+	union {
+		struct {
+			u32 reserved;
+		} req;
+		struct {
+			u32 port_names;
+		} resp;
+	} p;
+} __packed;
+
 #define ISCSI_OPCODE_SCSI_DATA_OUT		5
 #define OPCODE_COMMON_NTWK_LINK_STATUS_QUERY 5
 #define OPCODE_COMMON_MODIFY_EQ_DELAY		41
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 2f3e118..d036706 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2048,21 +2048,7 @@ static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
 			num_processed = 0;
 		}
 		if (mcc_compl->flags & CQE_FLAGS_ASYNC_MASK) {
-			/* Interpret flags as an async trailer */
-			if (is_link_state_evt(mcc_compl->flags))
-				/* Interpret compl as a async link evt */
-				beiscsi_async_link_state_process(phba,
-				(struct be_async_event_link_state *) mcc_compl);
-			else {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_MBOX,
-					    "BM_%d :  Unsupported Async Event, flags"
-					    " = 0x%08x\n",
-					    mcc_compl->flags);
-				if (phba->state & BE_ADAPTER_LINK_UP) {
-					phba->state |= BE_ADAPTER_CHECK_BOOT;
-					phba->get_boot = BE_GET_BOOT_RETRIES;
-				}
-			}
+			beiscsi_process_async_event(phba, mcc_compl);
 		} else if (mcc_compl->flags & CQE_FLAGS_COMPLETED_MASK) {
 			be_mcc_compl_process_isr(&phba->ctrl, mcc_compl);
 			atomic_dec(&phba->ctrl.mcc_obj.q.used);
@@ -3868,6 +3854,8 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 	phwi_context->min_eqd = 0;
 	phwi_context->cur_eqd = 0;
 	be_cmd_fw_initialize(&phba->ctrl);
+	/* set optic state to unknown */
+	phba->optic_state = 0xff;
 
 	status = beiscsi_create_eqs(phba, phwi_context);
 	if (status != 0) {
@@ -5545,6 +5533,7 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 	}
 
 	beiscsi_get_params(phba);
+
 	phba->shost->max_id = phba->params.cxns_per_ctrl;
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = hwi_init_controller(phba);
@@ -5681,6 +5670,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 			    "BM_%d : Error getting fw config\n");
 		goto free_port;
 	}
+	mgmt_get_port_name(&phba->ctrl, phba);
+	beiscsi_get_params(phba);
 
 	if (enable_msix)
 		find_num_cpus(phba);
@@ -5698,7 +5689,6 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 
 	phba->shost->max_id = phba->params.cxns_per_ctrl;
-	beiscsi_get_params(phba);
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index bd9d1e1..f89861b 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -397,7 +397,9 @@ struct beiscsi_hba {
 		 * group together since they are used most frequently
 		 * for cid to cri conversion
 		 */
+#define BEISCSI_PHYS_PORT_MAX	4
 		unsigned int phys_port;
+		/* valid values of phys_port id are 0, 1, 2, 3 */
 		unsigned int eqid_count;
 		unsigned int cqid_count;
 		unsigned int iscsi_cid_start[BEISCSI_ULP_COUNT];
@@ -415,6 +417,7 @@ struct beiscsi_hba {
 	} fw_config;
 
 	unsigned int state;
+	u8 optic_state;
 	int get_boot;
 	bool fw_timeout;
 	bool ue_detected;
@@ -422,6 +425,7 @@ struct beiscsi_hba {
 
 	bool mac_addr_set;
 	u8 mac_address[ETH_ALEN];
+	u8 port_name;
 	char fw_ver_str[BEISCSI_VER_STRLEN];
 	char wq_name[20];
 	struct workqueue_struct *wq;	/* The actuak work queue */
@@ -1073,12 +1077,14 @@ struct hwi_context_memory {
 #define BEISCSI_LOG_CONFIG	0x0020	/* CONFIG Code Path */
 #define BEISCSI_LOG_ISCSI	0x0040	/* SCSI/iSCSI Protocol related Logs */
 
+#define __beiscsi_log(phba, level, fmt, arg...) \
+	shost_printk(level, phba->shost, fmt, __LINE__, ##arg)
+
 #define beiscsi_log(phba, level, mask, fmt, arg...) \
 do { \
 	uint32_t log_value = phba->attr_log_enable; \
 		if (((mask) & log_value) || (level[1] <= '3')) \
-			shost_printk(level, phba->shost, \
-				     fmt, __LINE__, ##arg); \
-} while (0)
+			__beiscsi_log(phba, level, fmt, ##arg); \
+} while (0);
 
 #endif
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index a8a1670..15f7ad7 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -316,6 +316,48 @@ unsigned int mgmt_get_session_info(struct beiscsi_hba *phba,
 }
 
 /**
+ * mgmt_get_port_name()- Get port name for the function
+ * @ctrl: ptr to Ctrl Info
+ * @phba: ptr to the dev priv structure
+ *
+ * Get the alphanumeric character for port
+ *
+ **/
+int mgmt_get_port_name(struct be_ctrl_info *ctrl,
+		       struct beiscsi_hba *phba)
+{
+	int ret = 0;
+	struct be_mcc_wrb *wrb;
+	struct be_cmd_get_port_name *ioctl;
+
+	mutex_lock(&ctrl->mbox_lock);
+	wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	memset(wrb, 0, sizeof(*wrb));
+	ioctl = embedded_payload(wrb);
+
+	be_wrb_hdr_prepare(wrb, sizeof(*ioctl), true, 0);
+	be_cmd_hdr_prepare(&ioctl->h.req_hdr, CMD_SUBSYSTEM_COMMON,
+			   OPCODE_COMMON_GET_PORT_NAME,
+			   EMBED_MBX_MAX_PAYLOAD_SIZE);
+	ret = be_mbox_notify(ctrl);
+	phba->port_name = 0;
+	if (!ret) {
+		phba->port_name = ioctl->p.resp.port_names >>
+				  (phba->fw_config.phys_port * 8) & 0xff;
+	} else {
+		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+			    "BG_%d : GET_PORT_NAME ret 0x%x status 0x%x\n",
+			    ret, ioctl->h.resp_hdr.status);
+	}
+
+	if (phba->port_name == 0)
+		phba->port_name = '?';
+
+	mutex_unlock(&ctrl->mbox_lock);
+	return ret;
+}
+
+/**
  * mgmt_get_fw_config()- Get the FW config for the function
  * @ctrl: ptr to Ctrl Info
  * @phba: ptr to the dev priv structure
@@ -331,90 +373,142 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				struct beiscsi_hba *phba)
 {
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
-	struct be_fw_cfg *req = embedded_payload(wrb);
-	int status = 0;
+	struct be_fw_cfg *pfw_cfg = embedded_payload(wrb);
+	uint32_t cid_count, icd_count;
+	int status = -EINVAL;
+	uint8_t ulp_num = 0;
 
 	mutex_lock(&ctrl->mbox_lock);
 	memset(wrb, 0, sizeof(*wrb));
+	be_wrb_hdr_prepare(wrb, sizeof(*pfw_cfg), true, 0);
 
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
-
-	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+	be_cmd_hdr_prepare(&pfw_cfg->hdr, CMD_SUBSYSTEM_COMMON,
 			   OPCODE_COMMON_QUERY_FIRMWARE_CONFIG,
 			   EMBED_MBX_MAX_PAYLOAD_SIZE);
-	status = be_mbox_notify(ctrl);
-	if (!status) {
-		uint8_t ulp_num = 0;
-		struct be_fw_cfg *pfw_cfg;
-		pfw_cfg = req;
 
-		if (!is_chip_be2_be3r(phba)) {
-			phba->fw_config.eqid_count = pfw_cfg->eqid_count;
-			phba->fw_config.cqid_count = pfw_cfg->cqid_count;
+	if (be_mbox_notify(ctrl)) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BG_%d : Failed in mgmt_get_fw_config\n");
+		goto fail_init;
+	}
 
-			beiscsi_log(phba, KERN_INFO,
-				    BEISCSI_LOG_INIT,
-				    "BG_%d : EQ_Count : %d CQ_Count : %d\n",
-				    phba->fw_config.eqid_count,
+	/* FW response formats depend on port id */
+	phba->fw_config.phys_port = pfw_cfg->phys_port;
+	if (phba->fw_config.phys_port >= BEISCSI_PHYS_PORT_MAX) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BG_%d : invalid physical port id %d\n",
+			    phba->fw_config.phys_port);
+		goto fail_init;
+	}
+
+	/* populate and check FW config against min and max values */
+	if (!is_chip_be2_be3r(phba)) {
+		phba->fw_config.eqid_count = pfw_cfg->eqid_count;
+		phba->fw_config.cqid_count = pfw_cfg->cqid_count;
+		if (phba->fw_config.eqid_count == 0 ||
+		    phba->fw_config.eqid_count > 2048) {
+			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+				    "BG_%d : invalid EQ count %d\n",
+				    phba->fw_config.eqid_count);
+			goto fail_init;
+		}
+		if (phba->fw_config.cqid_count == 0 ||
+		    phba->fw_config.cqid_count > 4096) {
+			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+				    "BG_%d : invalid CQ count %d\n",
 				    phba->fw_config.cqid_count);
+			goto fail_init;
 		}
+		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+			    "BG_%d : EQ_Count : %d CQ_Count : %d\n",
+			    phba->fw_config.eqid_count,
+			    phba->fw_config.cqid_count);
+	}
 
-		for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
-			if (pfw_cfg->ulp[ulp_num].ulp_mode &
-			    BEISCSI_ULP_ISCSI_INI_MODE)
-				set_bit(ulp_num,
-				&phba->fw_config.ulp_supported);
-
-		phba->fw_config.phys_port = pfw_cfg->phys_port;
-		for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
-			if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
-
-				phba->fw_config.iscsi_cid_start[ulp_num] =
-					pfw_cfg->ulp[ulp_num].sq_base;
-				phba->fw_config.iscsi_cid_count[ulp_num] =
-					pfw_cfg->ulp[ulp_num].sq_count;
-
-				phba->fw_config.iscsi_icd_start[ulp_num] =
-					pfw_cfg->ulp[ulp_num].icd_base;
-				phba->fw_config.iscsi_icd_count[ulp_num] =
-					pfw_cfg->ulp[ulp_num].icd_count;
-
-				phba->fw_config.iscsi_chain_start[ulp_num] =
-					pfw_cfg->chain_icd[ulp_num].chain_base;
-				phba->fw_config.iscsi_chain_count[ulp_num] =
-					pfw_cfg->chain_icd[ulp_num].chain_count;
-
-				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BG_%d : Function loaded on ULP : %d\n"
-					    "\tiscsi_cid_count : %d\n"
-					    "\tiscsi_cid_start : %d\n"
-					    "\t iscsi_icd_count : %d\n"
-					    "\t iscsi_icd_start : %d\n",
-					    ulp_num,
-					    phba->fw_config.
-					    iscsi_cid_count[ulp_num],
-					    phba->fw_config.
-					    iscsi_cid_start[ulp_num],
-					    phba->fw_config.
-					    iscsi_icd_count[ulp_num],
-					    phba->fw_config.
-					    iscsi_icd_start[ulp_num]);
-			}
+	/**
+	 * Check on which all ULP iSCSI Protocol is loaded.
+	 * Set the Bit for those ULP. This set flag is used
+	 * at all places in the code to check on which ULP
+	 * iSCSi Protocol is loaded
+	 **/
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
+		if (pfw_cfg->ulp[ulp_num].ulp_mode &
+		    BEISCSI_ULP_ISCSI_INI_MODE) {
+			set_bit(ulp_num, &phba->fw_config.ulp_supported);
+
+			/* Get the CID, ICD and Chain count for each ULP */
+			phba->fw_config.iscsi_cid_start[ulp_num] =
+				pfw_cfg->ulp[ulp_num].sq_base;
+			phba->fw_config.iscsi_cid_count[ulp_num] =
+				pfw_cfg->ulp[ulp_num].sq_count;
+
+			phba->fw_config.iscsi_icd_start[ulp_num] =
+				pfw_cfg->ulp[ulp_num].icd_base;
+			phba->fw_config.iscsi_icd_count[ulp_num] =
+				pfw_cfg->ulp[ulp_num].icd_count;
+
+			phba->fw_config.iscsi_chain_start[ulp_num] =
+				pfw_cfg->chain_icd[ulp_num].chain_base;
+			phba->fw_config.iscsi_chain_count[ulp_num] =
+				pfw_cfg->chain_icd[ulp_num].chain_count;
+
+			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+				    "BG_%d : Function loaded on ULP : %d\n"
+				    "\tiscsi_cid_count : %d\n"
+				    "\tiscsi_cid_start : %d\n"
+				    "\t iscsi_icd_count : %d\n"
+				    "\t iscsi_icd_start : %d\n",
+				    ulp_num,
+				    phba->fw_config.
+				    iscsi_cid_count[ulp_num],
+				    phba->fw_config.
+				    iscsi_cid_start[ulp_num],
+				    phba->fw_config.
+				    iscsi_icd_count[ulp_num],
+				    phba->fw_config.
+				    iscsi_icd_start[ulp_num]);
 		}
+	}
 
-		phba->fw_config.dual_ulp_aware = (pfw_cfg->function_mode &
-						  BEISCSI_FUNC_DUA_MODE);
+	if (phba->fw_config.ulp_supported == 0) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BG_%d : iSCSI initiator mode not set: ULP0 %x ULP1 %x\n",
+			    pfw_cfg->ulp[BEISCSI_ULP0].ulp_mode,
+			    pfw_cfg->ulp[BEISCSI_ULP1].ulp_mode);
+		goto fail_init;
+	}
 
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BG_%d : DUA Mode : 0x%x\n",
-			    phba->fw_config.dual_ulp_aware);
+	/**
+	 * ICD is shared among ULPs. Use icd_count of any one loaded ULP
+	 **/
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
+		if (test_bit(ulp_num, &phba->fw_config.ulp_supported))
+			break;
+	icd_count = phba->fw_config.iscsi_icd_count[ulp_num];
+	if (icd_count == 0 || icd_count > 65536) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BG_%d: invalid ICD count %d\n", icd_count);
+		goto fail_init;
+	}
 
-	} else {
+	cid_count = BEISCSI_GET_CID_COUNT(phba, BEISCSI_ULP0) +
+		    BEISCSI_GET_CID_COUNT(phba, BEISCSI_ULP1);
+	if (cid_count == 0 || cid_count > 4096) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG_%d : Failed in mgmt_get_fw_config\n");
-		status = -EINVAL;
+			    "BG_%d: invalid CID count %d\n", cid_count);
+		goto fail_init;
 	}
 
+	phba->fw_config.dual_ulp_aware = (pfw_cfg->function_mode &
+					  BEISCSI_FUNC_DUA_MODE);
+
+	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+		    "BG_%d : DUA Mode : 0x%x\n",
+		    phba->fw_config.dual_ulp_aware);
+
+	/* all set, continue using this FW config */
+	status = 0;
+fail_init:
 	mutex_unlock(&ctrl->mbox_lock);
 	return status;
 }
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index c1dbb69..f3a48a0 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -268,6 +268,8 @@ struct beiscsi_endpoint {
 
 int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				 struct beiscsi_hba *phba);
+int mgmt_get_port_name(struct be_ctrl_info *ctrl,
+		       struct beiscsi_hba *phba);
 
 unsigned int mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 struct beiscsi_endpoint *beiscsi_ep,
-- 
1.7.1

