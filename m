From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 11/23] be2iscsi: Fix WRB_Q posting to support Dual Chute mode
Date: Sat, 28 Sep 2013 15:35:48 -0700
Message-ID: <1380407761-2949-11-git-send-email-jayamohan.kallickal@emulex.com>
References: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63049 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3I1Wgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Sep 2013 18:36:33 -0400
Received: by mail-pd0-f175.google.com with SMTP id q10so4024561pdj.20
        for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2013 15:36:33 -0700 (PDT)
In-Reply-To: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Configuration parameters return number of CID each chute supports. The WRB_Q
 is created for the passed CID count. If both the Chute has iSCSI Protocol then
 WRB_Q creation is in a round robin mechanism.

 For BE-X family iSCSI protocol is loaded only on single chute.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   37 ++++++++++++++++++++++++++++++++++---
 drivers/scsi/be2iscsi/be_cmds.h |   12 +++++++++---
 drivers/scsi/be2iscsi/be_main.c |   30 +++++++++++++++++++++++++++---
 drivers/scsi/be2iscsi/be_main.h |   35 +++++++++++++++++++----------------
 4 files changed, 89 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index b77a327..cc37a4e 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -17,9 +17,9 @@
 
 #include <scsi/iscsi_proto.h>
 
+#include "be_main.h"
 #include "be.h"
 #include "be_mgmt.h"
-#include "be_main.h"
 
 int beiscsi_pci_soft_reset(struct beiscsi_hba *phba)
 {
@@ -1135,12 +1135,27 @@ int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 	return status;
 }
 
-int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
-		       struct be_queue_info *wrbq)
+/**
+ * be_cmd_wrbq_create()- Create WRBQ
+ * @ctrl: ptr to ctrl_info
+ * @q_mem: memory details for the queue
+ * @wrbq: queue info
+ * @pwrb_context: ptr to wrb_context
+ * @ulp_num: ULP on which the WRBQ is to be created
+ *
+ * Create WRBQ on the passed ULP_NUM.
+ *
+ **/
+int be_cmd_wrbq_create(struct be_ctrl_info *ctrl,
+			struct be_dma_mem *q_mem,
+			struct be_queue_info *wrbq,
+			struct hwi_wrb_context *pwrb_context,
+			uint8_t ulp_num)
 {
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
 	struct be_wrbq_create_req *req = embedded_payload(wrb);
 	struct be_wrbq_create_resp *resp = embedded_payload(wrb);
+	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
 	int status;
 
 	spin_lock(&ctrl->mbox_lock);
@@ -1151,12 +1166,28 @@ int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
 		OPCODE_COMMON_ISCSI_WRBQ_CREATE, sizeof(*req));
 	req->num_pages = PAGES_4K_SPANNED(q_mem->va, q_mem->size);
+
+	if (phba->fw_config.dual_ulp_aware) {
+		req->ulp_num = ulp_num;
+		req->dua_feature |= (1 << BEISCSI_DUAL_ULP_AWARE_BIT);
+		req->dua_feature |= (1 << BEISCSI_BIND_Q_TO_ULP_BIT);
+	}
+
 	be_cmd_page_addrs_prepare(req->pages, ARRAY_SIZE(req->pages), q_mem);
 
 	status = be_mbox_notify(ctrl);
 	if (!status) {
 		wrbq->id = le16_to_cpu(resp->cid);
 		wrbq->created = true;
+
+		pwrb_context->cid = wrbq->id;
+		if (!phba->fw_config.dual_ulp_aware) {
+			pwrb_context->doorbell_offset = DB_TXULP0_OFFSET;
+			pwrb_context->ulp_num = BEISCSI_ULP0;
+		} else {
+			pwrb_context->ulp_num = resp->ulp_num;
+			pwrb_context->doorbell_offset = resp->doorbell_offset;
+		}
 	}
 	spin_unlock(&ctrl->mbox_lock);
 	return status;
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 40bc285..627ebbe 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -744,7 +744,9 @@ int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,
 int beiscsi_cmd_reset_function(struct beiscsi_hba *phba);
 
 int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
-		       struct be_queue_info *wrbq);
+		       struct be_queue_info *wrbq,
+		       struct hwi_wrb_context *pwrb_context,
+		       uint8_t ulp_num);
 
 bool is_link_state_evt(u32 trailer);
 
@@ -836,14 +838,18 @@ struct be_wrbq_create_req {
 	struct be_cmd_req_hdr hdr;
 	u16 num_pages;
 	u8 ulp_num;
-	u8 rsvd0;
+	u8 dua_feature;
 	struct phys_addr pages[8];
 } __packed;
 
 struct be_wrbq_create_resp {
 	struct be_cmd_resp_hdr resp_hdr;
 	u16 cid;
-	u16 rsvd0;
+	u8 rsvd0;
+	u8 ulp_num;
+	u32 doorbell_offset;
+	u16 register_set;
+	u16 doorbell_format;
 } __packed;
 
 #define SOL_CID_MASK		0x0000FFC0
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 59d7e932..8595908 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3507,13 +3507,15 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 {
 	unsigned int wrb_mem_index, offset, size, num_wrb_rings;
 	u64 pa_addr_lo;
-	unsigned int idx, num, i;
+	unsigned int idx, num, i, ulp_num;
 	struct mem_array *pwrb_arr;
 	void *wrb_vaddr;
 	struct be_dma_mem sgl;
 	struct be_mem_descriptor *mem_descr;
 	struct hwi_wrb_context *pwrb_context;
 	int status;
+	uint8_t ulp_count = 0, ulp_base_num = 0;
+	uint16_t cid_count_ulp[BEISCSI_ULP_COUNT] = { 0 };
 
 	idx = 0;
 	mem_descr = phba->init_mem;
@@ -3557,14 +3559,37 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 			num_wrb_rings--;
 		}
 	}
+
+	/* Get the ULP Count */
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
+		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
+			ulp_count++;
+			ulp_base_num = ulp_num;
+			cid_count_ulp[ulp_num] =
+				BEISCSI_GET_CID_COUNT(phba, ulp_num);
+		}
+
 	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
 		wrb_mem_index = 0;
 		offset = 0;
 		size = 0;
 
+		if (ulp_count > 1) {
+			ulp_base_num = (ulp_base_num + 1) % BEISCSI_ULP_COUNT;
+
+			if (!cid_count_ulp[ulp_base_num])
+				ulp_base_num = (ulp_base_num + 1) %
+						BEISCSI_ULP_COUNT;
+
+			cid_count_ulp[ulp_base_num]--;
+		}
+
+
 		hwi_build_be_sgl_by_offset(phba, &pwrb_arr[i], &sgl);
 		status = be_cmd_wrbq_create(&phba->ctrl, &sgl,
-					    &phwi_context->be_wrbq[i]);
+					    &phwi_context->be_wrbq[i],
+					    &phwi_ctrlr->wrb_context[i],
+					    ulp_base_num);
 		if (status != 0) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 				    "BM_%d : wrbq create failed.");
@@ -3572,7 +3597,6 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 			return status;
 		}
 		pwrb_context = &phwi_ctrlr->wrb_context[i];
-		pwrb_context->cid = phwi_context->be_wrbq[i].id;
 		BE_SET_CID_TO_CRI(i, pwrb_context->cid);
 	}
 	kfree(pwrb_arr);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index bb96ba4..410efc7 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -34,7 +34,6 @@
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_transport_iscsi.h>
 
-#include "be.h"
 #define DRV_NAME		"be2iscsi"
 #define BUILD_STR		"10.0.467.0"
 #define BE_NAME			"Emulex OneConnect" \
@@ -280,6 +279,25 @@ struct invalidate_command_table {
 	unsigned short cid;
 } __packed;
 
+#define BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr, cri) \
+	(phwi_ctrlr->wrb_context[cri].ulp_num)
+struct hwi_wrb_context {
+	struct list_head wrb_handle_list;
+	struct list_head wrb_handle_drvr_list;
+	struct wrb_handle **pwrb_handle_base;
+	struct wrb_handle **pwrb_handle_basestd;
+	struct iscsi_wrb *plast_wrb;
+	unsigned short alloc_index;
+	unsigned short free_index;
+	unsigned short wrb_handles_available;
+	unsigned short cid;
+	uint8_t ulp_num;	/* ULP to which CID binded */
+	uint16_t register_set;
+	uint16_t doorbell_format;
+	uint32_t doorbell_offset;
+};
+
+#include "be.h"
 #define chip_be2(phba)      (phba->generation == BE_GEN2)
 #define chip_be3_r(phba)    (phba->generation == BE_GEN3)
 #define is_chip_be2_be3r(phba) (chip_be3_r(phba) || (chip_be2(phba)))
@@ -955,21 +973,6 @@ struct be_ring {
 				 */
 };
 
-#define BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr, cri) \
-	(phwi_ctrlr->wrb_context[cri].ulp_num)
-struct hwi_wrb_context {
-	struct list_head wrb_handle_list;
-	struct list_head wrb_handle_drvr_list;
-	struct wrb_handle **pwrb_handle_base;
-	struct wrb_handle **pwrb_handle_basestd;
-	struct iscsi_wrb *plast_wrb;
-	unsigned short alloc_index;
-	unsigned short free_index;
-	unsigned short wrb_handles_available;
-	unsigned short cid;
-	uint8_t ulp_num;	/* ULP to which CID binded */
-};
-
 struct hwi_controller {
 	struct list_head io_sgl_list;
 	struct list_head eh_sgl_list;
-- 
1.7.10.4

