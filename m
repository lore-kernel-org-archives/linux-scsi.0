From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 11/19] be2iscsi: Fix support for handling CQ_CREATE V2 version.
Date: Sat, 20 Oct 2012 04:43:44 +0530
Message-ID: <b09fb0ae-fb22-4726-8cd2-7f86b0a60268@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:4729 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2JSXOy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:14:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 For latest adapters, V2 version of cq_create MBX_CMD is to be used. When driver is loaded
 depending on the adapter type appropriate cq_create command will be called.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   38 +++++++++++++++++++++++++++-----------
 drivers/scsi/be2iscsi/be_cmds.h |   26 ++++++++++++++++++++++++--
 drivers/scsi/be2iscsi/be_main.h |    1 +
 3 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 05f70bb..3913e26 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -649,18 +649,34 @@ int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
 			OPCODE_COMMON_CQ_CREATE, sizeof(*req));
 
 	req->num_pages = cpu_to_le16(PAGES_4K_SPANNED(q_mem->va, q_mem->size));
+	if (chip_skh_r(ctrl->pdev)) {
+		req->hdr.version = MBX_CMD_VER2;
+		req->page_size = 1;
+		AMAP_SET_BITS(struct amap_cq_context_v2, coalescwm,
+			      ctxt, coalesce_wm);
+		AMAP_SET_BITS(struct amap_cq_context_v2, nodelay,
+			      ctxt, no_delay);
+		AMAP_SET_BITS(struct amap_cq_context_v2, count, ctxt,
+			      __ilog2_u32(cq->len / 256));
+		AMAP_SET_BITS(struct amap_cq_context_v2, valid, ctxt, 1);
+		AMAP_SET_BITS(struct amap_cq_context_v2, eventable, ctxt, 1);
+		AMAP_SET_BITS(struct amap_cq_context_v2, eqid, ctxt, eq->id);
+		AMAP_SET_BITS(struct amap_cq_context_v2, armed, ctxt, 1);
+	} else {
+		AMAP_SET_BITS(struct amap_cq_context, coalescwm,
+			      ctxt, coalesce_wm);
+		AMAP_SET_BITS(struct amap_cq_context, nodelay, ctxt, no_delay);
+		AMAP_SET_BITS(struct amap_cq_context, count, ctxt,
+			      __ilog2_u32(cq->len / 256));
+		AMAP_SET_BITS(struct amap_cq_context, valid, ctxt, 1);
+		AMAP_SET_BITS(struct amap_cq_context, solevent, ctxt, sol_evts);
+		AMAP_SET_BITS(struct amap_cq_context, eventable, ctxt, 1);
+		AMAP_SET_BITS(struct amap_cq_context, eqid, ctxt, eq->id);
+		AMAP_SET_BITS(struct amap_cq_context, armed, ctxt, 1);
+		AMAP_SET_BITS(struct amap_cq_context, func, ctxt,
+			      PCI_FUNC(ctrl->pdev->devfn));
+	}
 
-	AMAP_SET_BITS(struct amap_cq_context, coalescwm, ctxt, coalesce_wm);
-	AMAP_SET_BITS(struct amap_cq_context, nodelay, ctxt, no_delay);
-	AMAP_SET_BITS(struct amap_cq_context, count, ctxt,
-		      __ilog2_u32(cq->len / 256));
-	AMAP_SET_BITS(struct amap_cq_context, valid, ctxt, 1);
-	AMAP_SET_BITS(struct amap_cq_context, solevent, ctxt, sol_evts);
-	AMAP_SET_BITS(struct amap_cq_context, eventable, ctxt, 1);
-	AMAP_SET_BITS(struct amap_cq_context, eqid, ctxt, eq->id);
-	AMAP_SET_BITS(struct amap_cq_context, armed, ctxt, 1);
-	AMAP_SET_BITS(struct amap_cq_context, func, ctxt,
-		      PCI_FUNC(ctrl->pdev->devfn));
 	be_dws_cpu_to_le(ctxt, sizeof(req->context));
 
 	be_cmd_page_addrs_prepare(req->pages, ARRAY_SIZE(req->pages), q_mem);
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 897086b..c560e9d 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -58,6 +58,9 @@ struct be_mcc_wrb {
 #define CQE_STATUS_EXTD_MASK 0xFFFF
 #define CQE_STATUS_EXTD_SHIFT 16		/* bits 0 - 15 */
 
+/* MBOX Command VER */
+#define MBX_CMD_VER2	0x02
+
 struct be_mcc_compl {
 	u32 status;		/* dword 0 */
 	u32 tag0;		/* dword 1 */
@@ -183,7 +186,8 @@ struct be_cmd_req_hdr {
 	u8 domain;		/* dword 0 */
 	u32 timeout;		/* dword 1 */
 	u32 request_length;	/* dword 2 */
-	u32 rsvd0;		/* dword 3 */
+	u8 version;		/* dword 3 */
+	u8 rsvd0[3];		/* dword 3 */
 };
 
 struct be_cmd_resp_hdr {
@@ -483,10 +487,28 @@ struct amap_cq_context {
 	u8 rsvd5[32];		/* dword 3 */
 } __packed;
 
+struct amap_cq_context_v2 {
+	u8 rsvd0[12];   /* dword 0 */
+	u8 coalescwm[2];    /* dword 0 */
+	u8 nodelay;     /* dword 0 */
+	u8 rsvd1[12];   /* dword 0 */
+	u8 count[2];    /* dword 0 */
+	u8 valid;       /* dword 0 */
+	u8 rsvd2;       /* dword 0 */
+	u8 eventable;   /* dword 0 */
+	u8 eqid[16];    /* dword 1 */
+	u8 rsvd3[15];   /* dword 1 */
+	u8 armed;       /* dword 1 */
+	u8 cqecount[16];/* dword 2 */
+	u8 rsvd4[16];   /* dword 2 */
+	u8 rsvd5[32];   /* dword 3 */
+};
+
 struct be_cmd_req_cq_create {
 	struct be_cmd_req_hdr hdr;
 	u16 num_pages;
-	u16 rsvd0;
+	u8 page_size;
+	u8 rsvd0;
 	u8 context[sizeof(struct amap_cq_context) / 8];
 	struct phys_addr pages[4];
 } __packed;
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 2e534f3..2c9cba2 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -265,6 +265,7 @@ struct invalidate_command_table {
 	unsigned short cid;
 } __packed;
 
+#define chip_skh_r(pdev)	(pdev->device == OC_SKH_ID1)
 struct beiscsi_hba {
 	struct hba_parameters params;
 	struct hwi_controller *phwi_ctrlr;
-- 
1.7.2

