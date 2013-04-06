From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 07/18] be2iscsi: Fix support for DEFQ extension
Date: Fri,  5 Apr 2013 20:38:27 -0700
Message-ID: <1365219519-3457-7-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41793 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163196Ab3DFDi6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:38:58 -0400
Received: by mail-pa0-f42.google.com with SMTP id kq13so2352288pab.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:38:58 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Fix support for DEFQ extension which will be used by latest
 adapters

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   42 +++++++++++++++++++++++++++++----------
 drivers/scsi/be2iscsi/be_cmds.h |   14 ++++++++++++-
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index db6c50b..4f3c93a 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1021,6 +1021,7 @@ int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
 	struct be_defq_create_req *req = embedded_payload(wrb);
 	struct be_dma_mem *q_mem = &dq->dma_mem;
+	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
 	void *ctxt = &req->context;
 	int status;
 
@@ -1033,17 +1034,36 @@ int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 			   OPCODE_COMMON_ISCSI_DEFQ_CREATE, sizeof(*req));
 
 	req->num_pages = PAGES_4K_SPANNED(q_mem->va, q_mem->size);
-	AMAP_SET_BITS(struct amap_be_default_pdu_context, rx_pdid, ctxt, 0);
-	AMAP_SET_BITS(struct amap_be_default_pdu_context, rx_pdid_valid, ctxt,
-		      1);
-	AMAP_SET_BITS(struct amap_be_default_pdu_context, pci_func_id, ctxt,
-		      PCI_FUNC(ctrl->pdev->devfn));
-	AMAP_SET_BITS(struct amap_be_default_pdu_context, ring_size, ctxt,
-		      be_encoded_q_len(length / sizeof(struct phys_addr)));
-	AMAP_SET_BITS(struct amap_be_default_pdu_context, default_buffer_size,
-		      ctxt, entry_size);
-	AMAP_SET_BITS(struct amap_be_default_pdu_context, cq_id_recv, ctxt,
-		      cq->id);
+
+	if (is_chip_be2_be3r(phba)) {
+		AMAP_SET_BITS(struct amap_be_default_pdu_context,
+			      rx_pdid, ctxt, 0);
+		AMAP_SET_BITS(struct amap_be_default_pdu_context,
+			      rx_pdid_valid, ctxt, 1);
+		AMAP_SET_BITS(struct amap_be_default_pdu_context,
+			      pci_func_id, ctxt, PCI_FUNC(ctrl->pdev->devfn));
+		AMAP_SET_BITS(struct amap_be_default_pdu_context,
+			      ring_size, ctxt,
+			      be_encoded_q_len(length /
+			      sizeof(struct phys_addr)));
+		AMAP_SET_BITS(struct amap_be_default_pdu_context,
+			      default_buffer_size, ctxt, entry_size);
+		AMAP_SET_BITS(struct amap_be_default_pdu_context,
+			      cq_id_recv, ctxt,	cq->id);
+	} else {
+		AMAP_SET_BITS(struct amap_default_pdu_context_ext,
+			      rx_pdid, ctxt, 0);
+		AMAP_SET_BITS(struct amap_default_pdu_context_ext,
+			      rx_pdid_valid, ctxt, 1);
+		AMAP_SET_BITS(struct amap_default_pdu_context_ext,
+			      ring_size, ctxt,
+			      be_encoded_q_len(length /
+			      sizeof(struct phys_addr)));
+		AMAP_SET_BITS(struct amap_default_pdu_context_ext,
+			      default_buffer_size, ctxt, entry_size);
+		AMAP_SET_BITS(struct amap_default_pdu_context_ext,
+			      cq_id_recv, ctxt, cq->id);
+	}
 
 	be_dws_cpu_to_le(ctxt, sizeof(req->context));
 
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index a338625..9b64b36 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -756,6 +756,18 @@ struct amap_be_default_pdu_context {
 	u8 rsvd4[32];		/* dword 3 */
 } __packed;
 
+struct amap_default_pdu_context_ext {
+	u8 rsvd0[16];   /* dword 0 */
+	u8 ring_size[4];    /* dword 0 */
+	u8 rsvd1[12];   /* dword 0 */
+	u8 rsvd2[22];   /* dword 1 */
+	u8 rx_pdid[9];  /* dword 1 */
+	u8 rx_pdid_valid;   /* dword 1 */
+	u8 default_buffer_size[16]; /* dword 2 */
+	u8 cq_id_recv[16];  /* dword 2 */
+	u8 rsvd3[32];   /* dword 3 */
+} __packed;
+
 struct be_defq_create_req {
 	struct be_cmd_req_hdr hdr;
 	u16 num_pages;
@@ -901,7 +913,7 @@ struct amap_it_dmsg_cqe_v2 {
  * stack to notify the
  * controller of a posted Work Request Block
  */
-#define DB_WRB_POST_CID_MASK		0x3FF	/* bits 0 - 9 */
+#define DB_WRB_POST_CID_MASK		0xFFFF	/* bits 0 - 16 */
 #define DB_DEF_PDU_WRB_INDEX_MASK	0xFF	/* bits 0 - 9 */
 
 #define DB_DEF_PDU_WRB_INDEX_SHIFT	16
-- 
1.7.10.4

