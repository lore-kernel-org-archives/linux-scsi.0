From: jayamohank@gmail.com
Subject: [PATCH 07/15] be2iscsi: Fix support for DEFQ extension
Date: Mon, 11 Mar 2013 21:39:37 -0700
Message-ID: <1363063186-4902-7-git-send-email-jayamohan.kallickal@emulex.com>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37769 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3CLEkI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Mar 2013 00:40:08 -0400
Received: by mail-pb0-f46.google.com with SMTP id uo15so4535733pbc.5
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 21:40:07 -0700 (PDT)
In-Reply-To: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>

 Fix support for DEFQ extension which will be used by latest
 adapters

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   43 ++++++++++++++++++++++++++++-----------
 drivers/scsi/be2iscsi/be_cmds.h |   14 ++++++++++++-
 2 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index db6c50b..39d2dd4 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1021,6 +1021,7 @@ int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
 	struct be_defq_create_req *req = embedded_payload(wrb);
 	struct be_dma_mem *q_mem = &dq->dma_mem;
+	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
 	void *ctxt = &req->context;
 	int status;
 
@@ -1032,18 +1033,36 @@ int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
 			   OPCODE_COMMON_ISCSI_DEFQ_CREATE, sizeof(*req));
 
-	req->num_pages = PAGES_4K_SPANNED(q_mem->va, q_mem->size);
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
+	if (is_chip_be2_be3r(phba)) {
+		req->num_pages = PAGES_4K_SPANNED(q_mem->va, q_mem->size);
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

