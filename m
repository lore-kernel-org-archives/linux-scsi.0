From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 13/18] lpfc: NVME Target: Receive buffer updates
Date: Mon, 06 Feb 2017 15:09:02 -0800
Message-ID: <5899020e.GCmXcJLNvZ41Jdy+%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34922 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752149AbdBFXJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:09:09 -0500
Received: by mail-wr0-f196.google.com with SMTP id o16so3998672wra.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 15:09:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Target: Receive buffer updates

Allocates buffer pools and configures adapter interfaces to handle
receive buffer (asynchronous FCP CMD ius, first burst data)
from the adapter. Splits by protocol, etc.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
Modifications in V2:
 Sync with max_hw_queues/io_channel/io_channel_irqs change
 Sync with refactoring

 drivers/scsi/lpfc/lpfc.h      |   3 +
 drivers/scsi/lpfc/lpfc_attr.c |  81 +++++-
 drivers/scsi/lpfc/lpfc_crtn.h |   1 +
 drivers/scsi/lpfc/lpfc_hw4.h  | 274 +++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c | 233 +++++++++++++++-
 drivers/scsi/lpfc/lpfc_mbox.c |  87 ++++++
 drivers/scsi/lpfc/lpfc_sli.c  | 608 +++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli4.h |  11 +
 8 files changed, 1282 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index c5208e2..2d4c3e6 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -770,9 +770,12 @@ struct lpfc_hba {
 	uint32_t cfg_suppress_rsp;
 	uint32_t cfg_nvme_oas;
 	uint32_t cfg_nvme_io_channel;
+	uint32_t cfg_nvmet_mrq;
+	uint32_t cfg_nvmet_mrq_post;
 	uint32_t cfg_enable_nvmet;
 	uint32_t cfg_nvme_posted_buf;
 	uint32_t cfg_nvme_enable_fb;
+	uint32_t cfg_nvmet_fb_size;
 	uint32_t cfg_total_seg_cnt;
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 8058484..2731bf8 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -58,6 +58,10 @@
 #define LPFC_MIN_DEVLOSS_TMO	1
 #define LPFC_MAX_DEVLOSS_TMO	255
 
+#define LPFC_DEF_MRQ_POST	128
+#define LPFC_MIN_MRQ_POST	32
+#define LPFC_MAX_MRQ_POST	512
+
 /*
  * Write key size should be multiple of 4. If write key is changed
  * make sure that library write key is also changed.
@@ -3282,6 +3286,24 @@ LPFC_ATTR_R(suppress_rsp, 1, 0, 1,
 	    "Enable suppress rsp feature is firmware supports it");
 
 /*
+ * lpfc_nvmet_mrq: Specify number of RQ pairs for processing NVMET cmds
+ * lpfc_nvmet_mrq = 1  use a single RQ pair
+ * lpfc_nvmet_mrq >= 2  use specified RQ pairs for MRQ
+ *
+ */
+LPFC_ATTR_R(nvmet_mrq,
+	    1, 1, 16,
+	    "Specify number of RQ pairs for processing NVMET cmds");
+
+/*
+ * lpfc_nvmet_mrq_post: Specify number buffers to post on every MRQ
+ *
+ */
+LPFC_ATTR_R(nvmet_mrq_post, LPFC_DEF_MRQ_POST,
+	    LPFC_MIN_MRQ_POST, LPFC_MAX_MRQ_POST,
+	    "Specify number of buffers to post on every MRQ");
+
+/*
  * lpfc_enable_fc4_type: Defines what FC4 types are supported.
  * Supported Values:  1 - register just FCP
  *                    2 - register just NVME
@@ -4658,13 +4680,28 @@ LPFC_VPORT_ATTR_RW(first_burst_size, 0, 0, 65536,
 		   "First burst size for Targets that support first burst");
 
 /*
-* lpfc_nvme_enable_fb: Enable NVME first burst on I and T functions.
-* For the Initiator (I), enabling this parameter means that an NVME
-* PRLI response with FBA enabled and an FB_SIZE set to a nonzero value
-* will be processed by the initiator for subsequent NVME FCP IO.
+* lpfc_nvmet_fb_size: NVME Target mode supported first burst size.
+* When the driver is configured as an NVME target, this value is
+* communicated to the NVME initiator in the PRLI response.  It is
+* used only when the lpfc_nvme_enable_fb and lpfc_nvmet_support
+* parameters are set and the target is sending the PRLI RSP.
 * Parameter supported on physical port only - no NPIV support.
-* Value range is [0,1]. Default value is 0 (disabled).
+* Value range is [0,65536]. Default value is 0.
 */
+LPFC_ATTR_RW(nvmet_fb_size, 0, 0, 65536,
+	     "NVME Target mode first burst size in 512B increments.");
+
+/*
+ * lpfc_nvme_enable_fb: Enable NVME first burst on I and T functions.
+ * For the Initiator (I), enabling this parameter means that an NVMET
+ * PRLI response with FBA enabled and an FB_SIZE set to a nonzero value will be
+ * processed by the initiator for subsequent NVME FCP IO. For the target
+ * function (T), enabling this parameter qualifies the lpfc_nvmet_fb_size
+ * driver parameter as the target function's first burst size returned to the
+ * initiator in the target's NVME PRLI response. Parameter supported on physical
+ * port only - no NPIV support.
+ * Value range is [0,1]. Default value is 0 (disabled).
+ */
 LPFC_ATTR_RW(nvme_enable_fb, 0, 0, 1,
 	     "Enable First Burst feature on I and T functions.");
 
@@ -5100,7 +5137,10 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_fcp_io_channel,
 	&dev_attr_lpfc_suppress_rsp,
 	&dev_attr_lpfc_nvme_io_channel,
+	&dev_attr_lpfc_nvmet_mrq,
+	&dev_attr_lpfc_nvmet_mrq_post,
 	&dev_attr_lpfc_nvme_enable_fb,
+	&dev_attr_lpfc_nvmet_fb_size,
 	&dev_attr_lpfc_enable_bg,
 	&dev_attr_lpfc_soft_wwnn,
 	&dev_attr_lpfc_soft_wwpn,
@@ -6137,9 +6177,12 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_suppress_rsp_init(phba, lpfc_suppress_rsp);
 
 	lpfc_enable_fc4_type_init(phba, lpfc_enable_fc4_type);
+	lpfc_nvmet_mrq_init(phba, lpfc_nvmet_mrq);
+	lpfc_nvmet_mrq_post_init(phba, lpfc_nvmet_mrq_post);
 
 	/* Initialize first burst. Target vs Initiator are different. */
 	lpfc_nvme_enable_fb_init(phba, lpfc_nvme_enable_fb);
+	lpfc_nvmet_fb_size_init(phba, lpfc_nvmet_fb_size);
 	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
 	lpfc_nvme_io_channel_init(phba, lpfc_nvme_io_channel);
 
@@ -6202,9 +6245,35 @@ lpfc_nvme_mod_param_dep(struct lpfc_hba *phba)
 	    phba->nvmet_support) {
 		phba->cfg_enable_fc4_type &= ~LPFC_ENABLE_FCP;
 		phba->cfg_fcp_io_channel = 0;
-	} else
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
+				"6013 %s x%x fb_size x%x, fb_max x%x\n",
+				"NVME Target PRLI ACC enable_fb ",
+				phba->cfg_nvme_enable_fb,
+				phba->cfg_nvmet_fb_size,
+				LPFC_NVMET_FB_SZ_MAX);
+
+		if (phba->cfg_nvme_enable_fb == 0)
+			phba->cfg_nvmet_fb_size = 0;
+		else {
+			if (phba->cfg_nvmet_fb_size > LPFC_NVMET_FB_SZ_MAX)
+				phba->cfg_nvmet_fb_size = LPFC_NVMET_FB_SZ_MAX;
+		}
+
+		/* Adjust lpfc_nvmet_mrq to avoid running out of WQE slots */
+		if (phba->cfg_nvmet_mrq > phba->cfg_nvme_io_channel) {
+			phba->cfg_nvmet_mrq = phba->cfg_nvme_io_channel;
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
+					"6018 Adjust lpfc_nvmet_mrq to %d\n",
+					phba->cfg_nvmet_mrq);
+		}
+	} else {
 		/* Not NVME Target mode.  Turn off Target parameters. */
 		phba->nvmet_support = 0;
+		phba->cfg_nvmet_mrq = 0;
+		phba->cfg_nvmet_mrq_post = 0;
+		phba->cfg_nvmet_fb_size = 0;
+	}
 
 	if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
 		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 9f598e2..675b5bb 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -229,6 +229,7 @@ void lpfc_reg_vfi(struct lpfcMboxq *, struct lpfc_vport *, dma_addr_t);
 void lpfc_init_vpi(struct lpfc_hba *, struct lpfcMboxq *, uint16_t);
 void lpfc_unreg_vfi(struct lpfcMboxq *, struct lpfc_vport *);
 void lpfc_reg_fcfi(struct lpfc_hba *, struct lpfcMboxq *);
+void lpfc_reg_fcfi_mrq(struct lpfc_hba *phba, struct lpfcMboxq *mbox, int mode);
 void lpfc_unreg_fcfi(struct lpfcMboxq *, uint16_t);
 void lpfc_resume_rpi(struct lpfcMboxq *, struct lpfc_nodelist *);
 int lpfc_check_pending_fcoe_event(struct lpfc_hba *, uint8_t);
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index b25e2f2..0fddb23 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -962,6 +962,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_FCOE_DELETE_FCF		0x0A
 #define LPFC_MBOX_OPCODE_FCOE_POST_HDR_TEMPLATE		0x0B
 #define LPFC_MBOX_OPCODE_FCOE_REDISCOVER_FCF		0x10
+#define LPFC_MBOX_OPCODE_FCOE_CQ_CREATE_SET		0x1D
 #define LPFC_MBOX_OPCODE_FCOE_SET_FCLINK_SETTINGS	0x21
 #define LPFC_MBOX_OPCODE_FCOE_LINK_DIAG_STATE		0x22
 #define LPFC_MBOX_OPCODE_FCOE_LINK_DIAG_LOOPBACK	0x23
@@ -1143,6 +1144,116 @@ struct lpfc_mbx_cq_create {
 	} u;
 };
 
+struct lpfc_mbx_cq_create_set {
+	union  lpfc_sli4_cfg_shdr cfg_shdr;
+	union {
+		struct {
+			uint32_t word0;
+#define lpfc_mbx_cq_create_set_page_size_SHIFT	16	/* Version 2 Only */
+#define lpfc_mbx_cq_create_set_page_size_MASK	0x000000FF
+#define lpfc_mbx_cq_create_set_page_size_WORD	word0
+#define lpfc_mbx_cq_create_set_num_pages_SHIFT	0
+#define lpfc_mbx_cq_create_set_num_pages_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_num_pages_WORD	word0
+			uint32_t word1;
+#define lpfc_mbx_cq_create_set_evt_SHIFT	31
+#define lpfc_mbx_cq_create_set_evt_MASK		0x00000001
+#define lpfc_mbx_cq_create_set_evt_WORD		word1
+#define lpfc_mbx_cq_create_set_valid_SHIFT	29
+#define lpfc_mbx_cq_create_set_valid_MASK	0x00000001
+#define lpfc_mbx_cq_create_set_valid_WORD	word1
+#define lpfc_mbx_cq_create_set_cqe_cnt_SHIFT	27
+#define lpfc_mbx_cq_create_set_cqe_cnt_MASK	0x00000003
+#define lpfc_mbx_cq_create_set_cqe_cnt_WORD	word1
+#define lpfc_mbx_cq_create_set_cqe_size_SHIFT	25
+#define lpfc_mbx_cq_create_set_cqe_size_MASK	0x00000003
+#define lpfc_mbx_cq_create_set_cqe_size_WORD	word1
+#define lpfc_mbx_cq_create_set_auto_SHIFT	15
+#define lpfc_mbx_cq_create_set_auto_MASK	0x0000001
+#define lpfc_mbx_cq_create_set_auto_WORD	word1
+#define lpfc_mbx_cq_create_set_nodelay_SHIFT	14
+#define lpfc_mbx_cq_create_set_nodelay_MASK	0x00000001
+#define lpfc_mbx_cq_create_set_nodelay_WORD	word1
+#define lpfc_mbx_cq_create_set_clswm_SHIFT	12
+#define lpfc_mbx_cq_create_set_clswm_MASK	0x00000003
+#define lpfc_mbx_cq_create_set_clswm_WORD	word1
+			uint32_t word2;
+#define lpfc_mbx_cq_create_set_arm_SHIFT	31
+#define lpfc_mbx_cq_create_set_arm_MASK		0x00000001
+#define lpfc_mbx_cq_create_set_arm_WORD		word2
+#define lpfc_mbx_cq_create_set_num_cq_SHIFT	0
+#define lpfc_mbx_cq_create_set_num_cq_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_num_cq_WORD	word2
+			uint32_t word3;
+#define lpfc_mbx_cq_create_set_eq_id1_SHIFT	16
+#define lpfc_mbx_cq_create_set_eq_id1_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id1_WORD	word3
+#define lpfc_mbx_cq_create_set_eq_id0_SHIFT	0
+#define lpfc_mbx_cq_create_set_eq_id0_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id0_WORD	word3
+			uint32_t word4;
+#define lpfc_mbx_cq_create_set_eq_id3_SHIFT	16
+#define lpfc_mbx_cq_create_set_eq_id3_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id3_WORD	word4
+#define lpfc_mbx_cq_create_set_eq_id2_SHIFT	0
+#define lpfc_mbx_cq_create_set_eq_id2_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id2_WORD	word4
+			uint32_t word5;
+#define lpfc_mbx_cq_create_set_eq_id5_SHIFT	16
+#define lpfc_mbx_cq_create_set_eq_id5_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id5_WORD	word5
+#define lpfc_mbx_cq_create_set_eq_id4_SHIFT	0
+#define lpfc_mbx_cq_create_set_eq_id4_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id4_WORD	word5
+			uint32_t word6;
+#define lpfc_mbx_cq_create_set_eq_id7_SHIFT	16
+#define lpfc_mbx_cq_create_set_eq_id7_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id7_WORD	word6
+#define lpfc_mbx_cq_create_set_eq_id6_SHIFT	0
+#define lpfc_mbx_cq_create_set_eq_id6_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id6_WORD	word6
+			uint32_t word7;
+#define lpfc_mbx_cq_create_set_eq_id9_SHIFT	16
+#define lpfc_mbx_cq_create_set_eq_id9_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id9_WORD	word7
+#define lpfc_mbx_cq_create_set_eq_id8_SHIFT	0
+#define lpfc_mbx_cq_create_set_eq_id8_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id8_WORD	word7
+			uint32_t word8;
+#define lpfc_mbx_cq_create_set_eq_id11_SHIFT	16
+#define lpfc_mbx_cq_create_set_eq_id11_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id11_WORD	word8
+#define lpfc_mbx_cq_create_set_eq_id10_SHIFT	0
+#define lpfc_mbx_cq_create_set_eq_id10_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id10_WORD	word8
+			uint32_t word9;
+#define lpfc_mbx_cq_create_set_eq_id13_SHIFT	16
+#define lpfc_mbx_cq_create_set_eq_id13_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id13_WORD	word9
+#define lpfc_mbx_cq_create_set_eq_id12_SHIFT	0
+#define lpfc_mbx_cq_create_set_eq_id12_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id12_WORD	word9
+			uint32_t word10;
+#define lpfc_mbx_cq_create_set_eq_id15_SHIFT	16
+#define lpfc_mbx_cq_create_set_eq_id15_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id15_WORD	word10
+#define lpfc_mbx_cq_create_set_eq_id14_SHIFT	0
+#define lpfc_mbx_cq_create_set_eq_id14_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_eq_id14_WORD	word10
+			struct dma_address page[1];
+		} request;
+		struct {
+			uint32_t word0;
+#define lpfc_mbx_cq_create_set_num_alloc_SHIFT	16
+#define lpfc_mbx_cq_create_set_num_alloc_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_num_alloc_WORD	word0
+#define lpfc_mbx_cq_create_set_base_id_SHIFT	0
+#define lpfc_mbx_cq_create_set_base_id_MASK	0x0000FFFF
+#define lpfc_mbx_cq_create_set_base_id_WORD	word0
+		} response;
+	} u;
+};
+
 struct lpfc_mbx_cq_destroy {
 	struct mbox_header header;
 	union {
@@ -2277,6 +2388,160 @@ struct lpfc_mbx_reg_fcfi {
 #define lpfc_reg_fcfi_vlan_tag_WORD	word8
 };
 
+struct lpfc_mbx_reg_fcfi_mrq {
+	uint32_t word1;
+#define lpfc_reg_fcfi_mrq_info_index_SHIFT	0
+#define lpfc_reg_fcfi_mrq_info_index_MASK	0x0000FFFF
+#define lpfc_reg_fcfi_mrq_info_index_WORD	word1
+#define lpfc_reg_fcfi_mrq_fcfi_SHIFT		16
+#define lpfc_reg_fcfi_mrq_fcfi_MASK		0x0000FFFF
+#define lpfc_reg_fcfi_mrq_fcfi_WORD		word1
+	uint32_t word2;
+#define lpfc_reg_fcfi_mrq_rq_id1_SHIFT		0
+#define lpfc_reg_fcfi_mrq_rq_id1_MASK		0x0000FFFF
+#define lpfc_reg_fcfi_mrq_rq_id1_WORD		word2
+#define lpfc_reg_fcfi_mrq_rq_id0_SHIFT		16
+#define lpfc_reg_fcfi_mrq_rq_id0_MASK		0x0000FFFF
+#define lpfc_reg_fcfi_mrq_rq_id0_WORD		word2
+	uint32_t word3;
+#define lpfc_reg_fcfi_mrq_rq_id3_SHIFT		0
+#define lpfc_reg_fcfi_mrq_rq_id3_MASK		0x0000FFFF
+#define lpfc_reg_fcfi_mrq_rq_id3_WORD		word3
+#define lpfc_reg_fcfi_mrq_rq_id2_SHIFT		16
+#define lpfc_reg_fcfi_mrq_rq_id2_MASK		0x0000FFFF
+#define lpfc_reg_fcfi_mrq_rq_id2_WORD		word3
+	uint32_t word4;
+#define lpfc_reg_fcfi_mrq_type_match0_SHIFT	24
+#define lpfc_reg_fcfi_mrq_type_match0_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_type_match0_WORD	word4
+#define lpfc_reg_fcfi_mrq_type_mask0_SHIFT	16
+#define lpfc_reg_fcfi_mrq_type_mask0_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_type_mask0_WORD	word4
+#define lpfc_reg_fcfi_mrq_rctl_match0_SHIFT	8
+#define lpfc_reg_fcfi_mrq_rctl_match0_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_rctl_match0_WORD	word4
+#define lpfc_reg_fcfi_mrq_rctl_mask0_SHIFT	0
+#define lpfc_reg_fcfi_mrq_rctl_mask0_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_rctl_mask0_WORD	word4
+	uint32_t word5;
+#define lpfc_reg_fcfi_mrq_type_match1_SHIFT	24
+#define lpfc_reg_fcfi_mrq_type_match1_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_type_match1_WORD	word5
+#define lpfc_reg_fcfi_mrq_type_mask1_SHIFT	16
+#define lpfc_reg_fcfi_mrq_type_mask1_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_type_mask1_WORD	word5
+#define lpfc_reg_fcfi_mrq_rctl_match1_SHIFT	8
+#define lpfc_reg_fcfi_mrq_rctl_match1_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_rctl_match1_WORD	word5
+#define lpfc_reg_fcfi_mrq_rctl_mask1_SHIFT	0
+#define lpfc_reg_fcfi_mrq_rctl_mask1_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_rctl_mask1_WORD	word5
+	uint32_t word6;
+#define lpfc_reg_fcfi_mrq_type_match2_SHIFT	24
+#define lpfc_reg_fcfi_mrq_type_match2_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_type_match2_WORD	word6
+#define lpfc_reg_fcfi_mrq_type_mask2_SHIFT	16
+#define lpfc_reg_fcfi_mrq_type_mask2_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_type_mask2_WORD	word6
+#define lpfc_reg_fcfi_mrq_rctl_match2_SHIFT	8
+#define lpfc_reg_fcfi_mrq_rctl_match2_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_rctl_match2_WORD	word6
+#define lpfc_reg_fcfi_mrq_rctl_mask2_SHIFT	0
+#define lpfc_reg_fcfi_mrq_rctl_mask2_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_rctl_mask2_WORD	word6
+	uint32_t word7;
+#define lpfc_reg_fcfi_mrq_type_match3_SHIFT	24
+#define lpfc_reg_fcfi_mrq_type_match3_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_type_match3_WORD	word7
+#define lpfc_reg_fcfi_mrq_type_mask3_SHIFT	16
+#define lpfc_reg_fcfi_mrq_type_mask3_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_type_mask3_WORD	word7
+#define lpfc_reg_fcfi_mrq_rctl_match3_SHIFT	8
+#define lpfc_reg_fcfi_mrq_rctl_match3_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_rctl_match3_WORD	word7
+#define lpfc_reg_fcfi_mrq_rctl_mask3_SHIFT	0
+#define lpfc_reg_fcfi_mrq_rctl_mask3_MASK	0x000000FF
+#define lpfc_reg_fcfi_mrq_rctl_mask3_WORD	word7
+	uint32_t word8;
+#define lpfc_reg_fcfi_mrq_ptc7_SHIFT		31
+#define lpfc_reg_fcfi_mrq_ptc7_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_ptc7_WORD		word8
+#define lpfc_reg_fcfi_mrq_ptc6_SHIFT		30
+#define lpfc_reg_fcfi_mrq_ptc6_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_ptc6_WORD		word8
+#define lpfc_reg_fcfi_mrq_ptc5_SHIFT		29
+#define lpfc_reg_fcfi_mrq_ptc5_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_ptc5_WORD		word8
+#define lpfc_reg_fcfi_mrq_ptc4_SHIFT		28
+#define lpfc_reg_fcfi_mrq_ptc4_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_ptc4_WORD		word8
+#define lpfc_reg_fcfi_mrq_ptc3_SHIFT		27
+#define lpfc_reg_fcfi_mrq_ptc3_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_ptc3_WORD		word8
+#define lpfc_reg_fcfi_mrq_ptc2_SHIFT		26
+#define lpfc_reg_fcfi_mrq_ptc2_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_ptc2_WORD		word8
+#define lpfc_reg_fcfi_mrq_ptc1_SHIFT		25
+#define lpfc_reg_fcfi_mrq_ptc1_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_ptc1_WORD		word8
+#define lpfc_reg_fcfi_mrq_ptc0_SHIFT		24
+#define lpfc_reg_fcfi_mrq_ptc0_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_ptc0_WORD		word8
+#define lpfc_reg_fcfi_mrq_pt7_SHIFT		23
+#define lpfc_reg_fcfi_mrq_pt7_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_pt7_WORD		word8
+#define lpfc_reg_fcfi_mrq_pt6_SHIFT		22
+#define lpfc_reg_fcfi_mrq_pt6_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_pt6_WORD		word8
+#define lpfc_reg_fcfi_mrq_pt5_SHIFT		21
+#define lpfc_reg_fcfi_mrq_pt5_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_pt5_WORD		word8
+#define lpfc_reg_fcfi_mrq_pt4_SHIFT		20
+#define lpfc_reg_fcfi_mrq_pt4_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_pt4_WORD		word8
+#define lpfc_reg_fcfi_mrq_pt3_SHIFT		19
+#define lpfc_reg_fcfi_mrq_pt3_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_pt3_WORD		word8
+#define lpfc_reg_fcfi_mrq_pt2_SHIFT		18
+#define lpfc_reg_fcfi_mrq_pt2_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_pt2_WORD		word8
+#define lpfc_reg_fcfi_mrq_pt1_SHIFT		17
+#define lpfc_reg_fcfi_mrq_pt1_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_pt1_WORD		word8
+#define lpfc_reg_fcfi_mrq_pt0_SHIFT		16
+#define lpfc_reg_fcfi_mrq_pt0_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_pt0_WORD		word8
+#define lpfc_reg_fcfi_mrq_xmv_SHIFT		15
+#define lpfc_reg_fcfi_mrq_xmv_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_xmv_WORD		word8
+#define lpfc_reg_fcfi_mrq_mode_SHIFT		13
+#define lpfc_reg_fcfi_mrq_mode_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_mode_WORD		word8
+#define lpfc_reg_fcfi_mrq_vv_SHIFT		12
+#define lpfc_reg_fcfi_mrq_vv_MASK		0x00000001
+#define lpfc_reg_fcfi_mrq_vv_WORD		word8
+#define lpfc_reg_fcfi_mrq_vlan_tag_SHIFT	0
+#define lpfc_reg_fcfi_mrq_vlan_tag_MASK		0x00000FFF
+#define lpfc_reg_fcfi_mrq_vlan_tag_WORD		word8
+	uint32_t word9;
+#define lpfc_reg_fcfi_mrq_policy_SHIFT		12
+#define lpfc_reg_fcfi_mrq_policy_MASK		0x0000000F
+#define lpfc_reg_fcfi_mrq_policy_WORD		word9
+#define lpfc_reg_fcfi_mrq_filter_SHIFT		8
+#define lpfc_reg_fcfi_mrq_filter_MASK		0x0000000F
+#define lpfc_reg_fcfi_mrq_filter_WORD		word9
+#define lpfc_reg_fcfi_mrq_npairs_SHIFT		0
+#define lpfc_reg_fcfi_mrq_npairs_MASK		0x000000FF
+#define lpfc_reg_fcfi_mrq_npairs_WORD		word9
+	uint32_t word10;
+	uint32_t word11;
+	uint32_t word12;
+	uint32_t word13;
+	uint32_t word14;
+	uint32_t word15;
+	uint32_t word16;
+};
+
 struct lpfc_mbx_unreg_fcfi {
 	uint32_t word1_rsv;
 	uint32_t word2;
@@ -2456,6 +2721,9 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rq_perfh_SHIFT		11
 #define lpfc_mbx_rq_ftr_rq_perfh_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rq_perfh_WORD		word2
+#define lpfc_mbx_rq_ftr_rq_mrqp_SHIFT		16
+#define lpfc_mbx_rq_ftr_rq_mrqp_MASK		0x00000001
+#define lpfc_mbx_rq_ftr_rq_mrqp_WORD		word2
 	uint32_t word3;
 #define lpfc_mbx_rq_ftr_rsp_iaab_SHIFT		0
 #define lpfc_mbx_rq_ftr_rsp_iaab_MASK		0x00000001
@@ -2484,6 +2752,9 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rsp_perfh_SHIFT		11
 #define lpfc_mbx_rq_ftr_rsp_perfh_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rsp_perfh_WORD		word3
+#define lpfc_mbx_rq_ftr_rsp_mrqp_SHIFT		16
+#define lpfc_mbx_rq_ftr_rsp_mrqp_MASK		0x00000001
+#define lpfc_mbx_rq_ftr_rsp_mrqp_WORD		word3
 };
 
 struct lpfc_mbx_supp_pages {
@@ -3376,12 +3647,14 @@ struct lpfc_mqe {
 		struct lpfc_mbx_del_fcf_tbl_entry del_fcf_entry;
 		struct lpfc_mbx_redisc_fcf_tbl redisc_fcf_tbl;
 		struct lpfc_mbx_reg_fcfi reg_fcfi;
+		struct lpfc_mbx_reg_fcfi_mrq reg_fcfi_mrq;
 		struct lpfc_mbx_unreg_fcfi unreg_fcfi;
 		struct lpfc_mbx_mq_create mq_create;
 		struct lpfc_mbx_mq_create_ext mq_create_ext;
 		struct lpfc_mbx_eq_create eq_create;
 		struct lpfc_mbx_modify_eq_delay eq_delay;
 		struct lpfc_mbx_cq_create cq_create;
+		struct lpfc_mbx_cq_create_set cq_create_set;
 		struct lpfc_mbx_wq_create wq_create;
 		struct lpfc_mbx_rq_create rq_create;
 		struct lpfc_mbx_rq_create_v2 rq_create_v2;
@@ -4037,6 +4310,7 @@ struct lpfc_nvme_prli {
 #define prli_fb_sz_SHIFT                0
 #define prli_fb_sz_MASK                 0x0000ffff
 #define prli_fb_sz_WORD                 word5
+#define LPFC_NVMET_FB_SZ_MAX  65536   /* Driver target mode only. */
 };
 
 struct create_xri_wqe {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index eaa10e2..2c0cd93 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3356,8 +3356,15 @@ lpfc_sli4_nvmet_sgl_update(struct lpfc_hba *phba)
 	 * update on pci function's nvmet xri-sgl list
 	 */
 	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
-	nvmet_xri_cnt = 0;
+	nvmet_xri_cnt = phba->cfg_nvmet_mrq * phba->cfg_nvmet_mrq_post;
 	tot_cnt = phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
+	if (nvmet_xri_cnt > tot_cnt) {
+		phba->cfg_nvmet_mrq_post = tot_cnt / phba->cfg_nvmet_mrq;
+		nvmet_xri_cnt = phba->cfg_nvmet_mrq * phba->cfg_nvmet_mrq_post;
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"6301 NVMET post-sgl count changed to %d\n",
+				phba->cfg_nvmet_mrq_post);
+	}
 
 	if (nvmet_xri_cnt > phba->sli4_hba.nvmet_xri_cnt) {
 		/* els xri-sgl expanded */
@@ -7676,11 +7683,13 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 		phba->cfg_fcp_io_channel = io_channel;
 	if (phba->cfg_nvme_io_channel > io_channel)
 		phba->cfg_nvme_io_channel = io_channel;
+	if (phba->cfg_nvme_io_channel < phba->cfg_nvmet_mrq)
+		phba->cfg_nvmet_mrq = phba->cfg_nvme_io_channel;
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"2574 IO channels: irqs %d fcp %d nvme %d\n",
+			"2574 IO channels: irqs %d fcp %d nvme %d MRQ: %d\n",
 			phba->io_channel_irqs, phba->cfg_fcp_io_channel,
-			phba->cfg_nvme_io_channel);
+			phba->cfg_nvme_io_channel, phba->cfg_nvmet_mrq);
 
 	/* Get EQ depth from module parameter, fake the default for now */
 	phba->sli4_hba.eq_esize = LPFC_EQE_SIZE_4B;
@@ -7770,7 +7779,7 @@ int
 lpfc_sli4_queue_create(struct lpfc_hba *phba)
 {
 	struct lpfc_queue *qdesc;
-	int idx, io_channel;
+	int idx, io_channel, max;
 
 	/*
 	 * Create HBA Record arrays.
@@ -7847,7 +7856,6 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 			goto out_error;
 		}
 
-
 		phba->sli4_hba.nvme_wq = kcalloc(phba->cfg_nvme_io_channel,
 						sizeof(struct lpfc_queue *),
 						GFP_KERNEL);
@@ -7872,6 +7880,39 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 					"fast-path CQ map\n");
 			goto out_error;
 		}
+
+		if (phba->nvmet_support) {
+			phba->sli4_hba.nvmet_cqset = kcalloc(
+					phba->cfg_nvmet_mrq,
+					sizeof(struct lpfc_queue *),
+					GFP_KERNEL);
+			if (!phba->sli4_hba.nvmet_cqset) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"3121 Fail allocate memory for "
+					"fast-path CQ set array\n");
+				goto out_error;
+			}
+			phba->sli4_hba.nvmet_mrq_hdr = kcalloc(
+					phba->cfg_nvmet_mrq,
+					sizeof(struct lpfc_queue *),
+					GFP_KERNEL);
+			if (!phba->sli4_hba.nvmet_mrq_hdr) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"3122 Fail allocate memory for "
+					"fast-path RQ set hdr array\n");
+				goto out_error;
+			}
+			phba->sli4_hba.nvmet_mrq_data = kcalloc(
+					phba->cfg_nvmet_mrq,
+					sizeof(struct lpfc_queue *),
+					GFP_KERNEL);
+			if (!phba->sli4_hba.nvmet_mrq_data) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"3124 Fail allocate memory for "
+					"fast-path RQ set data array\n");
+				goto out_error;
+			}
+		}
 	}
 
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_wq_list);
@@ -7899,6 +7940,30 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		if (lpfc_alloc_nvme_wq_cq(phba, idx))
 			goto out_error;
 
+	/* allocate MRQ CQs */
+	max = phba->cfg_nvme_io_channel;
+	if (max < phba->cfg_nvmet_mrq)
+		max = phba->cfg_nvmet_mrq;
+
+	for (idx = 0; idx < max; idx++)
+		if (lpfc_alloc_nvme_wq_cq(phba, idx))
+			goto out_error;
+
+	if (phba->nvmet_support) {
+		for (idx = 0; idx < max; idx++) {
+			qdesc = lpfc_sli4_queue_alloc(phba,
+					phba->sli4_hba.cq_esize,
+					phba->sli4_hba.cq_ecount);
+			if (!qdesc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"3142 Failed allocate NVME "
+					"CQ Set (%d)\n", idx);
+				goto out_error;
+			}
+			phba->sli4_hba.nvmet_cqset[idx] = qdesc;
+		}
+	}
+
 	/*
 	 * Create Slow Path Completion Queues (CQs)
 	 */
@@ -8001,6 +8066,44 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	}
 	phba->sli4_hba.dat_rq = qdesc;
 
+	if (phba->nvmet_support) {
+		for (idx = 0; idx < phba->cfg_nvmet_mrq; idx++) {
+			/* Create NVMET Receive Queue for header */
+			qdesc = lpfc_sli4_queue_alloc(phba,
+						      phba->sli4_hba.rq_esize,
+						      phba->sli4_hba.rq_ecount);
+			if (!qdesc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"3146 Failed allocate "
+						"receive HRQ\n");
+				goto out_error;
+			}
+			phba->sli4_hba.nvmet_mrq_hdr[idx] = qdesc;
+
+			/* Only needed for header of RQ pair */
+			qdesc->rqbp = kzalloc(sizeof(struct lpfc_rqb),
+					      GFP_KERNEL);
+			if (qdesc->rqbp == NULL) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6131 Failed allocate "
+						"Header RQBP\n");
+				goto out_error;
+			}
+
+			/* Create NVMET Receive Queue for data */
+			qdesc = lpfc_sli4_queue_alloc(phba,
+						      phba->sli4_hba.rq_esize,
+						      phba->sli4_hba.rq_ecount);
+			if (!qdesc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"3156 Failed allocate "
+						"receive DRQ\n");
+				goto out_error;
+			}
+			phba->sli4_hba.nvmet_mrq_data[idx] = qdesc;
+		}
+	}
+
 	/* Create the Queues needed for Flash Optimized Fabric operations */
 	if (phba->cfg_fof)
 		lpfc_fof_queue_create(phba);
@@ -8087,6 +8190,14 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 	/* Release NVME CQ mapping array */
 	lpfc_sli4_release_queue_map(&phba->sli4_hba.nvme_cq_map);
 
+	lpfc_sli4_release_queues(&phba->sli4_hba.nvmet_cqset,
+					phba->cfg_nvmet_mrq);
+
+	lpfc_sli4_release_queues(&phba->sli4_hba.nvmet_mrq_hdr,
+					phba->cfg_nvmet_mrq);
+	lpfc_sli4_release_queues(&phba->sli4_hba.nvmet_mrq_data,
+					phba->cfg_nvmet_mrq);
+
 	/* Release mailbox command work queue */
 	__lpfc_sli4_release_queue(&phba->sli4_hba.mbx_wq);
 
@@ -8424,6 +8535,44 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			(uint32_t)rc);
 		goto out_destroy;
 	}
+	if (phba->nvmet_support) {
+		if (!phba->sli4_hba.nvmet_cqset) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"3165 Fast-path NVME CQ Set "
+					"array not allocated\n");
+			rc = -ENOMEM;
+			goto out_destroy;
+		}
+		if (phba->cfg_nvmet_mrq > 1) {
+			rc = lpfc_cq_create_set(phba,
+					phba->sli4_hba.nvmet_cqset,
+					phba->sli4_hba.hba_eq,
+					LPFC_WCQ, LPFC_NVMET);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"3164 Failed setup of NVME CQ "
+						"Set, rc = 0x%x\n",
+						(uint32_t)rc);
+				goto out_destroy;
+			}
+		} else {
+			/* Set up NVMET Receive Complete Queue */
+			rc = lpfc_cq_create(phba, phba->sli4_hba.nvmet_cqset[0],
+					    phba->sli4_hba.hba_eq[0],
+					    LPFC_WCQ, LPFC_NVMET);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6089 Failed setup NVMET CQ: "
+						"rc = 0x%x\n", (uint32_t)rc);
+				goto out_destroy;
+			}
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"6090 NVMET CQ setup: cq-id=%d, "
+					"parent eq-id=%d\n",
+					phba->sli4_hba.nvmet_cqset[0]->queue_id,
+					phba->sli4_hba.hba_eq[0]->queue_id);
+		}
+	}
 
 	/* Set up slow-path ELS WQ/CQ */
 	if (!phba->sli4_hba.els_cq || !phba->sli4_hba.els_wq) {
@@ -8475,6 +8624,58 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 				phba->sli4_hba.nvmels_cq->queue_id);
 	}
 
+	/*
+	 * Create NVMET Receive Queue (RQ)
+	 */
+	if (phba->nvmet_support) {
+		if ((!phba->sli4_hba.nvmet_cqset) ||
+		    (!phba->sli4_hba.nvmet_mrq_hdr) ||
+		    (!phba->sli4_hba.nvmet_mrq_data)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6130 MRQ CQ Queues not "
+					"allocated\n");
+			rc = -ENOMEM;
+			goto out_destroy;
+		}
+		if (phba->cfg_nvmet_mrq > 1) {
+			rc = lpfc_mrq_create(phba,
+					     phba->sli4_hba.nvmet_mrq_hdr,
+					     phba->sli4_hba.nvmet_mrq_data,
+					     phba->sli4_hba.nvmet_cqset,
+					     LPFC_NVMET);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6098 Failed setup of NVMET "
+						"MRQ: rc = 0x%x\n",
+						(uint32_t)rc);
+				goto out_destroy;
+			}
+
+		} else {
+			rc = lpfc_rq_create(phba,
+					    phba->sli4_hba.nvmet_mrq_hdr[0],
+					    phba->sli4_hba.nvmet_mrq_data[0],
+					    phba->sli4_hba.nvmet_cqset[0],
+					    LPFC_NVMET);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6057 Failed setup of NVMET "
+						"Receive Queue: rc = 0x%x\n",
+						(uint32_t)rc);
+				goto out_destroy;
+			}
+
+			lpfc_printf_log(
+				phba, KERN_INFO, LOG_INIT,
+				"6099 NVMET RQ setup: hdr-rq-id=%d, "
+				"dat-rq-id=%d parent cq-id=%d\n",
+				phba->sli4_hba.nvmet_mrq_hdr[0]->queue_id,
+				phba->sli4_hba.nvmet_mrq_data[0]->queue_id,
+				phba->sli4_hba.nvmet_cqset[0]->queue_id);
+
+		}
+	}
+
 	if (!phba->sli4_hba.hdr_rq || !phba->sli4_hba.dat_rq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0540 Receive Queue not allocated\n");
@@ -8591,6 +8792,21 @@ lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
 			lpfc_cq_destroy(phba, phba->sli4_hba.nvme_cq[qidx]);
 
+	/* Unset NVMET MRQ queue */
+	if (phba->sli4_hba.nvmet_mrq_hdr) {
+		for (qidx = 0; qidx < phba->cfg_nvmet_mrq; qidx++)
+			lpfc_rq_destroy(phba,
+					phba->sli4_hba.nvmet_mrq_hdr[qidx],
+					phba->sli4_hba.nvmet_mrq_data[qidx]);
+	}
+
+	/* Unset NVMET CQ Set complete queue */
+	if (phba->sli4_hba.nvmet_cqset) {
+		for (qidx = 0; qidx < phba->cfg_nvmet_mrq; qidx++)
+			lpfc_cq_destroy(phba,
+					phba->sli4_hba.nvmet_cqset[qidx]);
+	}
+
 	/* Unset FCP response complete queue */
 	if (phba->sli4_hba.fcp_cq)
 		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++)
@@ -9937,6 +10153,7 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	    !phba->nvme_support) {
 		phba->nvme_support = 0;
 		phba->nvmet_support = 0;
+		phba->cfg_nvmet_mrq = 0;
 		phba->cfg_nvme_io_channel = 0;
 		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_NVME,
@@ -10880,12 +11097,14 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	if (phba->intr_type != MSIX) {
 		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP)
 			phba->cfg_fcp_io_channel = 1;
-		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
 			phba->cfg_nvme_io_channel = 1;
+			if (phba->nvmet_support)
+				phba->cfg_nvmet_mrq = 1;
+		}
 		phba->io_channel_irqs = 1;
 	}
 
-
 	/* Set up SLI-4 HBA */
 	if (lpfc_sli4_hba_setup(phba)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index dc1b9a1..7b0a314 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2081,6 +2081,9 @@ lpfc_request_features(struct lpfc_hba *phba, struct lpfcMboxq *mboxq)
 	if (phba->max_vpi && phba->cfg_enable_npiv)
 		bf_set(lpfc_mbx_rq_ftr_rq_npiv, &mboxq->u.mqe.un.req_ftrs, 1);
 
+	if (phba->nvmet_support)
+		bf_set(lpfc_mbx_rq_ftr_rq_mrqp, &mboxq->u.mqe.un.req_ftrs, 1);
+
 	return;
 }
 
@@ -2448,6 +2451,26 @@ lpfc_reg_fcfi(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
 		/* addr mode is bit wise inverted value of fcf addr_mode */
 		bf_set(lpfc_reg_fcfi_mam, reg_fcfi,
 		       (~phba->fcf.addr_mode) & 0x3);
+	} else {
+		/* This is ONLY for NVMET MRQ == 1 */
+		if (phba->cfg_nvmet_mrq != 1)
+			return;
+
+		bf_set(lpfc_reg_fcfi_rq_id0, reg_fcfi,
+		       phba->sli4_hba.nvmet_mrq_hdr[0]->queue_id);
+		/* Match type FCP - rq_id0 */
+		bf_set(lpfc_reg_fcfi_type_match0, reg_fcfi, FC_TYPE_FCP);
+		bf_set(lpfc_reg_fcfi_type_mask0, reg_fcfi, 0xff);
+		bf_set(lpfc_reg_fcfi_rctl_match0, reg_fcfi,
+		       FC_RCTL_DD_UNSOL_CMD);
+
+		bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi,
+		       phba->sli4_hba.hdr_rq->queue_id);
+		/* Match everything else - rq_id1 */
+		bf_set(lpfc_reg_fcfi_type_match1, reg_fcfi, 0);
+		bf_set(lpfc_reg_fcfi_type_mask1, reg_fcfi, 0);
+		bf_set(lpfc_reg_fcfi_rctl_match1, reg_fcfi, 0);
+		bf_set(lpfc_reg_fcfi_rctl_mask1, reg_fcfi, 0);
 	}
 	bf_set(lpfc_reg_fcfi_rq_id2, reg_fcfi, REG_FCF_INVALID_QID);
 	bf_set(lpfc_reg_fcfi_rq_id3, reg_fcfi, REG_FCF_INVALID_QID);
@@ -2461,6 +2484,70 @@ lpfc_reg_fcfi(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
 }
 
 /**
+ * lpfc_reg_fcfi_mrq - Initialize the REG_FCFI_MRQ mailbox command
+ * @phba: pointer to the hba structure containing the FCF index and RQ ID.
+ * @mbox: pointer to lpfc mbox command to initialize.
+ * @mode: 0 to register FCFI, 1 to register MRQs
+ *
+ * The REG_FCFI_MRQ mailbox command supports Fibre Channel Forwarders (FCFs).
+ * The SLI Host uses the command to activate an FCF after it has acquired FCF
+ * information via a READ_FCF mailbox command. This mailbox command also is used
+ * to indicate where received unsolicited frames from this FCF will be sent. By
+ * default this routine will set up the FCF to forward all unsolicited frames
+ * the the RQ ID passed in the @phba. This can be overridden by the caller for
+ * more complicated setups.
+ **/
+void
+lpfc_reg_fcfi_mrq(struct lpfc_hba *phba, struct lpfcMboxq *mbox, int mode)
+{
+	struct lpfc_mbx_reg_fcfi_mrq *reg_fcfi;
+
+	/* This is ONLY for MRQ */
+	if (phba->cfg_nvmet_mrq <= 1)
+		return;
+
+	memset(mbox, 0, sizeof(*mbox));
+	reg_fcfi = &mbox->u.mqe.un.reg_fcfi_mrq;
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_REG_FCFI_MRQ);
+	if (mode == 0) {
+		bf_set(lpfc_reg_fcfi_mrq_info_index, reg_fcfi,
+		       phba->fcf.current_rec.fcf_indx);
+		if (phba->fcf.current_rec.vlan_id != LPFC_FCOE_NULL_VID) {
+			bf_set(lpfc_reg_fcfi_mrq_vv, reg_fcfi, 1);
+			bf_set(lpfc_reg_fcfi_mrq_vlan_tag, reg_fcfi,
+			       phba->fcf.current_rec.vlan_id);
+		}
+		return;
+	}
+
+	bf_set(lpfc_reg_fcfi_mrq_rq_id0, reg_fcfi,
+	       phba->sli4_hba.nvmet_mrq_hdr[0]->queue_id);
+	/* Match NVME frames of type FCP (protocol NVME) - rq_id0 */
+	bf_set(lpfc_reg_fcfi_mrq_type_match0, reg_fcfi, FC_TYPE_FCP);
+	bf_set(lpfc_reg_fcfi_mrq_type_mask0, reg_fcfi, 0xff);
+	bf_set(lpfc_reg_fcfi_mrq_rctl_match0, reg_fcfi, FC_RCTL_DD_UNSOL_CMD);
+	bf_set(lpfc_reg_fcfi_mrq_rctl_mask0, reg_fcfi, 0xff);
+	bf_set(lpfc_reg_fcfi_mrq_ptc0, reg_fcfi, 1);
+	bf_set(lpfc_reg_fcfi_mrq_pt0, reg_fcfi, 1);
+
+	bf_set(lpfc_reg_fcfi_mrq_policy, reg_fcfi, 3); /* NVME connection id */
+	bf_set(lpfc_reg_fcfi_mrq_mode, reg_fcfi, 1);
+	bf_set(lpfc_reg_fcfi_mrq_filter, reg_fcfi, 1); /* rq_id0 */
+	bf_set(lpfc_reg_fcfi_mrq_npairs, reg_fcfi, phba->cfg_nvmet_mrq);
+
+	bf_set(lpfc_reg_fcfi_mrq_rq_id1, reg_fcfi,
+	       phba->sli4_hba.hdr_rq->queue_id);
+	/* Match everything - rq_id1 */
+	bf_set(lpfc_reg_fcfi_mrq_type_match1, reg_fcfi, 0);
+	bf_set(lpfc_reg_fcfi_mrq_type_mask1, reg_fcfi, 0);
+	bf_set(lpfc_reg_fcfi_mrq_rctl_match1, reg_fcfi, 0);
+	bf_set(lpfc_reg_fcfi_mrq_rctl_mask1, reg_fcfi, 0);
+
+	bf_set(lpfc_reg_fcfi_mrq_rq_id2, reg_fcfi, REG_FCF_INVALID_QID);
+	bf_set(lpfc_reg_fcfi_mrq_rq_id3, reg_fcfi, REG_FCF_INVALID_QID);
+}
+
+/**
  * lpfc_unreg_fcfi - Initialize the UNREG_FCFI mailbox command
  * @mbox: pointer to lpfc mbox command to initialize.
  * @fcfi: FCFI to be unregistered.
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 99dbfdf..fecbfa4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2028,6 +2028,29 @@ lpfc_sli_hbqbuf_get(struct list_head *rb_list)
 }
 
 /**
+ * lpfc_sli_rqbuf_get - Remove the first dma buffer off of an RQ list
+ * @phba: Pointer to HBA context object.
+ * @hbqno: HBQ number.
+ *
+ * This function removes the first RQ buffer on an RQ buffer list and returns a
+ * pointer to that buffer. If it finds no buffers on the list it returns NULL.
+ **/
+static struct rqb_dmabuf *
+lpfc_sli_rqbuf_get(struct lpfc_hba *phba, struct lpfc_queue *hrq)
+{
+	struct lpfc_dmabuf *h_buf;
+	struct lpfc_rqb *rqbp;
+
+	rqbp = hrq->rqbp;
+	list_remove_head(&rqbp->rqb_buffer_list, h_buf,
+			 struct lpfc_dmabuf, list);
+	if (!h_buf)
+		return NULL;
+	rqbp->buffer_count--;
+	return container_of(h_buf, struct rqb_dmabuf, hbuf);
+}
+
+/**
  * lpfc_sli_hbqbuf_find - Find the hbq buffer associated with a tag
  * @phba: Pointer to HBA context object.
  * @tag: Tag of the hbq buffer.
@@ -5271,6 +5294,14 @@ lpfc_sli4_arm_cqeq_intr(struct lpfc_hba *phba)
 			lpfc_sli4_eq_release(phba->sli4_hba.hba_eq[qidx],
 						LPFC_QUEUE_REARM);
 
+	if (phba->nvmet_support) {
+		for (qidx = 0; qidx < phba->cfg_nvmet_mrq; qidx++) {
+			lpfc_sli4_cq_release(
+				phba->sli4_hba.nvmet_cqset[qidx],
+				LPFC_QUEUE_REARM);
+		}
+	}
+
 	if (phba->cfg_fof)
 		lpfc_sli4_eq_release(phba->sli4_hba.fof_eq, LPFC_QUEUE_REARM);
 }
@@ -6478,7 +6509,7 @@ lpfc_set_host_data(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 int
 lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 {
-	int rc;
+	int rc, i;
 	LPFC_MBOXQ_t *mboxq;
 	struct lpfc_mqe *mqe;
 	uint8_t *vpd;
@@ -6487,6 +6518,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(phba->pport);
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_dmabuf *mp;
+	struct lpfc_rqb *rqbp;
 
 	/* Perform a PCI function reset to start from clean */
 	rc = lpfc_pci_function_reset(phba);
@@ -6849,6 +6881,29 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		}
 	}
 
+	if (phba->nvmet_support && phba->cfg_nvmet_mrq) {
+
+		/* Post initial buffers to all RQs created */
+		for (i = 0; i < phba->cfg_nvmet_mrq; i++) {
+			rqbp = phba->sli4_hba.nvmet_mrq_hdr[i]->rqbp;
+			INIT_LIST_HEAD(&rqbp->rqb_buffer_list);
+			rqbp->rqb_alloc_buffer = lpfc_sli4_nvmet_alloc;
+			rqbp->rqb_free_buffer = lpfc_sli4_nvmet_free;
+			rqbp->entry_count = 256;
+			rqbp->buffer_count = 0;
+
+			/* Divide by 4 and round down to multiple of 16 */
+			rc = (phba->cfg_nvmet_mrq_post >> 2) & 0xfff8;
+			phba->sli4_hba.nvmet_mrq_hdr[i]->entry_repost = rc;
+			phba->sli4_hba.nvmet_mrq_data[i]->entry_repost = rc;
+
+			lpfc_post_rq_buffer(
+				phba, phba->sli4_hba.nvmet_mrq_hdr[i],
+				phba->sli4_hba.nvmet_mrq_data[i],
+				phba->cfg_nvmet_mrq_post);
+		}
+	}
+
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
 		/* register the allocated scsi sgl pool to the port */
 		rc = lpfc_sli4_repost_scsi_sgl_list(phba);
@@ -6891,7 +6946,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	lpfc_sli4_node_prep(phba);
 
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
-		if (phba->nvmet_support == 0) {
+		if ((phba->nvmet_support == 0) || (phba->cfg_nvmet_mrq == 1)) {
 			/*
 			 * The FC Port needs to register FCFI (index 0)
 			 */
@@ -6903,6 +6958,26 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 			rc = 0;
 			phba->fcf.fcfi = bf_get(lpfc_reg_fcfi_fcfi,
 						&mboxq->u.mqe.un.reg_fcfi);
+		} else {
+			/* We are a NVME Target mode with MRQ > 1 */
+
+			/* First register the FCFI */
+			lpfc_reg_fcfi_mrq(phba, mboxq, 0);
+			mboxq->vport = phba->pport;
+			rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+			if (rc != MBX_SUCCESS)
+				goto out_unset_queue;
+			rc = 0;
+			phba->fcf.fcfi = bf_get(lpfc_reg_fcfi_mrq_fcfi,
+						&mboxq->u.mqe.un.reg_fcfi_mrq);
+
+			/* Next register the MRQs */
+			lpfc_reg_fcfi_mrq(phba, mboxq, 1);
+			mboxq->vport = phba->pport;
+			rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+			if (rc != MBX_SUCCESS)
+				goto out_unset_queue;
+			rc = 0;
 		}
 		/* Check if the port is configured to be disabled */
 		lpfc_sli_read_link_ste(phba);
@@ -12981,6 +13056,101 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 }
 
 /**
+ * lpfc_sli4_nvmet_handle_rcqe - Process a receive-queue completion queue entry
+ * @phba: Pointer to HBA context object.
+ * @rcqe: Pointer to receive-queue completion queue entry.
+ *
+ * This routine process a receive-queue completion queue entry.
+ *
+ * Return: true if work posted to worker thread, otherwise false.
+ **/
+static bool
+lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
+			    struct lpfc_rcqe *rcqe)
+{
+	bool workposted = false;
+	struct lpfc_queue *hrq;
+	struct lpfc_queue *drq;
+	struct rqb_dmabuf *dma_buf;
+	struct fc_frame_header *fc_hdr;
+	uint32_t status, rq_id;
+	unsigned long iflags;
+	uint32_t fctl, idx;
+
+	if ((phba->nvmet_support == 0) ||
+	    (phba->sli4_hba.nvmet_cqset == NULL))
+		return workposted;
+
+	idx = cq->queue_id - phba->sli4_hba.nvmet_cqset[0]->queue_id;
+	hrq = phba->sli4_hba.nvmet_mrq_hdr[idx];
+	drq = phba->sli4_hba.nvmet_mrq_data[idx];
+
+	/* sanity check on queue memory */
+	if (unlikely(!hrq) || unlikely(!drq))
+		return workposted;
+
+	if (bf_get(lpfc_cqe_code, rcqe) == CQE_CODE_RECEIVE_V1)
+		rq_id = bf_get(lpfc_rcqe_rq_id_v1, rcqe);
+	else
+		rq_id = bf_get(lpfc_rcqe_rq_id, rcqe);
+
+	if ((phba->nvmet_support == 0) ||
+	    (rq_id != hrq->queue_id))
+		return workposted;
+
+	status = bf_get(lpfc_rcqe_status, rcqe);
+	switch (status) {
+	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"6126 Receive Frame Truncated!!\n");
+		hrq->RQ_buf_trunc++;
+		break;
+	case FC_STATUS_RQ_SUCCESS:
+		lpfc_sli4_rq_release(hrq, drq);
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		dma_buf = lpfc_sli_rqbuf_get(phba, hrq);
+		if (!dma_buf) {
+			hrq->RQ_no_buf_found++;
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			goto out;
+		}
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		hrq->RQ_rcv_buf++;
+		fc_hdr = (struct fc_frame_header *)dma_buf->hbuf.virt;
+
+		/* Just some basic sanity checks on FCP Command frame */
+		fctl = (fc_hdr->fh_f_ctl[0] << 16 |
+		fc_hdr->fh_f_ctl[1] << 8 |
+		fc_hdr->fh_f_ctl[2]);
+		if (((fctl &
+		    (FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT)) !=
+		    (FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT)) ||
+		    (fc_hdr->fh_seq_cnt != 0)) /* 0 byte swapped is still 0 */
+			goto drop;
+
+		if (fc_hdr->fh_type == FC_TYPE_FCP) {
+			dma_buf->bytes_recv = bf_get(lpfc_rcqe_length,  rcqe);
+			/* todo: tgt: forward cmd iu to transport */
+			return false;
+		}
+drop:
+		lpfc_in_buf_free(phba, &dma_buf->dbuf);
+		break;
+	case FC_STATUS_INSUFF_BUF_NEED_BUF:
+	case FC_STATUS_INSUFF_BUF_FRM_DISC:
+		hrq->RQ_no_posted_buf++;
+		/* Post more buffers if possible */
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		phba->hba_flag |= HBA_POST_RECEIVE_BUFFER;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		workposted = true;
+		break;
+	}
+out:
+	return workposted;
+}
+
+/**
  * lpfc_sli4_fp_handle_cqe - Process fast-path work queue completion entry
  * @cq: Pointer to the completion queue.
  * @eqe: Pointer to fast-path completion queue entry.
@@ -13028,6 +13198,10 @@ lpfc_sli4_fp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	case CQE_CODE_RECEIVE_V1:
 	case CQE_CODE_RECEIVE:
 		phba->last_completion_time = jiffies;
+		if (cq->subtype == LPFC_NVMET) {
+			workposted = lpfc_sli4_nvmet_handle_rcqe(
+				phba, cq, (struct lpfc_rcqe *)&wcqe);
+		}
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -13057,7 +13231,7 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	struct lpfc_queue *cq = NULL;
 	struct lpfc_cqe *cqe;
 	bool workposted = false;
-	uint16_t cqid;
+	uint16_t cqid, id;
 	int ecount = 0;
 
 	if (unlikely(bf_get_le32(lpfc_eqe_major_code, eqe) != 0)) {
@@ -13072,6 +13246,15 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	/* Get the reference to the corresponding CQ */
 	cqid = bf_get_le32(lpfc_eqe_resource_id, eqe);
 
+	if (phba->cfg_nvmet_mrq && phba->sli4_hba.nvmet_cqset) {
+		id = phba->sli4_hba.nvmet_cqset[0]->queue_id;
+		if ((cqid >= id) && (cqid < (id + phba->cfg_nvmet_mrq))) {
+			/* Process NVMET unsol rcv */
+			cq = phba->sli4_hba.nvmet_cqset[cqid - id];
+			goto  process_cq;
+		}
+	}
+
 	if (phba->sli4_hba.nvme_cq_map &&
 	    (cqid == phba->sli4_hba.nvme_cq_map[qidx])) {
 		/* Process NVME / NVMET command completion */
@@ -13956,6 +14139,234 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 }
 
 /**
+ * lpfc_cq_create_set - Create a set of Completion Queues on the HBA for MRQ
+ * @phba: HBA structure that indicates port to create a queue on.
+ * @cqp: The queue structure array to use to create the completion queues.
+ * @eqp: The event queue array to bind these completion queues to.
+ *
+ * This function creates a set of  completion queue, s to support MRQ
+ * as detailed in @cqp, on a port,
+ * described by @phba by sending a CREATE_CQ_SET mailbox command to the HBA.
+ *
+ * The @phba struct is used to send mailbox command to HBA. The @cq struct
+ * is used to get the entry count and entry size that are necessary to
+ * determine the number of pages to allocate and use for this queue. The @eq
+ * is used to indicate which event queue to bind this completion queue to. This
+ * function will send the CREATE_CQ_SET mailbox command to the HBA to setup the
+ * completion queue. This function is asynchronous and will wait for the mailbox
+ * command to finish before continuing.
+ *
+ * On success this function will return a zero. If unable to allocate enough
+ * memory this function will return -ENOMEM. If the queue create mailbox command
+ * fails this function will return -ENXIO.
+ **/
+int
+lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
+		   struct lpfc_queue **eqp, uint32_t type, uint32_t subtype)
+{
+	struct lpfc_queue *cq;
+	struct lpfc_queue *eq;
+	struct lpfc_mbx_cq_create_set *cq_set;
+	struct lpfc_dmabuf *dmabuf;
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, alloclen, status = 0;
+	int cnt, idx, numcq, page_idx = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+	uint32_t hw_page_size = phba->sli4_hba.pc_sli4_params.if_page_sz;
+
+	/* sanity check on queue memory */
+	numcq = phba->cfg_nvmet_mrq;
+	if (!cqp || !eqp || !numcq)
+		return -ENODEV;
+	if (!phba->sli4_hba.pc_sli4_params.supported)
+		hw_page_size = SLI4_PAGE_SIZE;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+
+	length = sizeof(struct lpfc_mbx_cq_create_set);
+	length += ((numcq * cqp[0]->page_count) *
+		   sizeof(struct dma_address));
+	alloclen = lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+			LPFC_MBOX_OPCODE_FCOE_CQ_CREATE_SET, length,
+			LPFC_SLI4_MBX_NEMBED);
+	if (alloclen < length) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"3098 Allocated DMA memory size (%d) is "
+				"less than the requested DMA memory size "
+				"(%d)\n", alloclen, length);
+		status = -ENOMEM;
+		goto out;
+	}
+	cq_set = mbox->sge_array->addr[0];
+	shdr = (union lpfc_sli4_cfg_shdr *)&cq_set->cfg_shdr;
+	bf_set(lpfc_mbox_hdr_version, &shdr->request, 0);
+
+	for (idx = 0; idx < numcq; idx++) {
+		cq = cqp[idx];
+		eq = eqp[idx];
+		if (!cq || !eq) {
+			status = -ENOMEM;
+			goto out;
+		}
+
+		switch (idx) {
+		case 0:
+			bf_set(lpfc_mbx_cq_create_set_page_size,
+			       &cq_set->u.request,
+			       (hw_page_size / SLI4_PAGE_SIZE));
+			bf_set(lpfc_mbx_cq_create_set_num_pages,
+			       &cq_set->u.request, cq->page_count);
+			bf_set(lpfc_mbx_cq_create_set_evt,
+			       &cq_set->u.request, 1);
+			bf_set(lpfc_mbx_cq_create_set_valid,
+			       &cq_set->u.request, 1);
+			bf_set(lpfc_mbx_cq_create_set_cqe_size,
+			       &cq_set->u.request, 0);
+			bf_set(lpfc_mbx_cq_create_set_num_cq,
+			       &cq_set->u.request, numcq);
+			switch (cq->entry_count) {
+			default:
+				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+						"3118 Bad CQ count. (%d)\n",
+						cq->entry_count);
+				if (cq->entry_count < 256) {
+					status = -EINVAL;
+					goto out;
+				}
+				/* otherwise default to smallest (drop thru) */
+			case 256:
+				bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
+				       &cq_set->u.request, LPFC_CQ_CNT_256);
+				break;
+			case 512:
+				bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
+				       &cq_set->u.request, LPFC_CQ_CNT_512);
+				break;
+			case 1024:
+				bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
+				       &cq_set->u.request, LPFC_CQ_CNT_1024);
+				break;
+			}
+			bf_set(lpfc_mbx_cq_create_set_eq_id0,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 1:
+			bf_set(lpfc_mbx_cq_create_set_eq_id1,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 2:
+			bf_set(lpfc_mbx_cq_create_set_eq_id2,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 3:
+			bf_set(lpfc_mbx_cq_create_set_eq_id3,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 4:
+			bf_set(lpfc_mbx_cq_create_set_eq_id4,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 5:
+			bf_set(lpfc_mbx_cq_create_set_eq_id5,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 6:
+			bf_set(lpfc_mbx_cq_create_set_eq_id6,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 7:
+			bf_set(lpfc_mbx_cq_create_set_eq_id7,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 8:
+			bf_set(lpfc_mbx_cq_create_set_eq_id8,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 9:
+			bf_set(lpfc_mbx_cq_create_set_eq_id9,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 10:
+			bf_set(lpfc_mbx_cq_create_set_eq_id10,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 11:
+			bf_set(lpfc_mbx_cq_create_set_eq_id11,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 12:
+			bf_set(lpfc_mbx_cq_create_set_eq_id12,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 13:
+			bf_set(lpfc_mbx_cq_create_set_eq_id13,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 14:
+			bf_set(lpfc_mbx_cq_create_set_eq_id14,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		case 15:
+			bf_set(lpfc_mbx_cq_create_set_eq_id15,
+			       &cq_set->u.request, eq->queue_id);
+			break;
+		}
+
+		/* link the cq onto the parent eq child list */
+		list_add_tail(&cq->list, &eq->child_list);
+		/* Set up completion queue's type and subtype */
+		cq->type = type;
+		cq->subtype = subtype;
+		cq->assoc_qid = eq->queue_id;
+		cq->host_index = 0;
+		cq->hba_index = 0;
+
+		rc = 0;
+		list_for_each_entry(dmabuf, &cq->page_list, list) {
+			memset(dmabuf->virt, 0, hw_page_size);
+			cnt = page_idx + dmabuf->buffer_tag;
+			cq_set->u.request.page[cnt].addr_lo =
+					putPaddrLow(dmabuf->phys);
+			cq_set->u.request.page[cnt].addr_hi =
+					putPaddrHigh(dmabuf->phys);
+			rc++;
+		}
+		page_idx += rc;
+	}
+
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3119 CQ_CREATE_SET mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+		goto out;
+	}
+	rc = bf_get(lpfc_mbx_cq_create_set_base_id, &cq_set->u.response);
+	if (rc == 0xFFFF) {
+		status = -ENXIO;
+		goto out;
+	}
+
+	for (idx = 0; idx < numcq; idx++) {
+		cq = cqp[idx];
+		cq->queue_id = rc + idx;
+	}
+
+out:
+	lpfc_sli4_mbox_cmd_free(phba, mbox);
+	return status;
+}
+
+/**
  * lpfc_mq_create_fb_init - Send MCC_CREATE without async events registration
  * @phba: HBA structure that indicates port to create a queue on.
  * @mq: The queue structure to use to create the mailbox queue.
@@ -14686,6 +15097,197 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 }
 
 /**
+ * lpfc_mrq_create - Create MRQ Receive Queues on the HBA
+ * @phba: HBA structure that indicates port to create a queue on.
+ * @hrqp: The queue structure array to use to create the header receive queues.
+ * @drqp: The queue structure array to use to create the data receive queues.
+ * @cqp: The completion queue array to bind these receive queues to.
+ *
+ * This function creates a receive buffer queue pair , as detailed in @hrq and
+ * @drq, on a port, described by @phba by sending a RQ_CREATE mailbox command
+ * to the HBA.
+ *
+ * The @phba struct is used to send mailbox command to HBA. The @drq and @hrq
+ * struct is used to get the entry count that is necessary to determine the
+ * number of pages to use for this queue. The @cq is used to indicate which
+ * completion queue to bind received buffers that are posted to these queues to.
+ * This function will send the RQ_CREATE mailbox command to the HBA to setup the
+ * receive queue pair. This function is asynchronous and will wait for the
+ * mailbox command to finish before continuing.
+ *
+ * On success this function will return a zero. If unable to allocate enough
+ * memory this function will return -ENOMEM. If the queue create mailbox command
+ * fails this function will return -ENXIO.
+ **/
+int
+lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_queue **hrqp,
+		struct lpfc_queue **drqp, struct lpfc_queue **cqp,
+		uint32_t subtype)
+{
+	struct lpfc_queue *hrq, *drq, *cq;
+	struct lpfc_mbx_rq_create_v2 *rq_create;
+	struct lpfc_dmabuf *dmabuf;
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, alloclen, status = 0;
+	int cnt, idx, numrq, page_idx = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+	uint32_t hw_page_size = phba->sli4_hba.pc_sli4_params.if_page_sz;
+
+	numrq = phba->cfg_nvmet_mrq;
+	/* sanity check on array memory */
+	if (!hrqp || !drqp || !cqp || !numrq)
+		return -ENODEV;
+	if (!phba->sli4_hba.pc_sli4_params.supported)
+		hw_page_size = SLI4_PAGE_SIZE;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+
+	length = sizeof(struct lpfc_mbx_rq_create_v2);
+	length += ((2 * numrq * hrqp[0]->page_count) *
+		   sizeof(struct dma_address));
+
+	alloclen = lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+				    LPFC_MBOX_OPCODE_FCOE_RQ_CREATE, length,
+				    LPFC_SLI4_MBX_NEMBED);
+	if (alloclen < length) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"3099 Allocated DMA memory size (%d) is "
+				"less than the requested DMA memory size "
+				"(%d)\n", alloclen, length);
+		status = -ENOMEM;
+		goto out;
+	}
+
+
+
+	rq_create = mbox->sge_array->addr[0];
+	shdr = (union lpfc_sli4_cfg_shdr *)&rq_create->cfg_shdr;
+
+	bf_set(lpfc_mbox_hdr_version, &shdr->request, LPFC_Q_CREATE_VERSION_2);
+	cnt = 0;
+
+	for (idx = 0; idx < numrq; idx++) {
+		hrq = hrqp[idx];
+		drq = drqp[idx];
+		cq  = cqp[idx];
+
+		if (hrq->entry_count != drq->entry_count) {
+			status = -EINVAL;
+			goto out;
+		}
+
+		/* sanity check on queue memory */
+		if (!hrq || !drq || !cq) {
+			status = -ENODEV;
+			goto out;
+		}
+
+		if (idx == 0) {
+			bf_set(lpfc_mbx_rq_create_num_pages,
+			       &rq_create->u.request,
+			       hrq->page_count);
+			bf_set(lpfc_mbx_rq_create_rq_cnt,
+			       &rq_create->u.request, (numrq * 2));
+			bf_set(lpfc_mbx_rq_create_dnb, &rq_create->u.request,
+			       1);
+			bf_set(lpfc_rq_context_base_cq,
+			       &rq_create->u.request.context,
+			       cq->queue_id);
+			bf_set(lpfc_rq_context_data_size,
+			       &rq_create->u.request.context,
+			       LPFC_DATA_BUF_SIZE);
+			bf_set(lpfc_rq_context_hdr_size,
+			       &rq_create->u.request.context,
+			       LPFC_HDR_BUF_SIZE);
+			bf_set(lpfc_rq_context_rqe_count_1,
+			       &rq_create->u.request.context,
+			       hrq->entry_count);
+			bf_set(lpfc_rq_context_rqe_size,
+			       &rq_create->u.request.context,
+			       LPFC_RQE_SIZE_8);
+			bf_set(lpfc_rq_context_page_size,
+			       &rq_create->u.request.context,
+			       (PAGE_SIZE/SLI4_PAGE_SIZE));
+		}
+		rc = 0;
+		list_for_each_entry(dmabuf, &hrq->page_list, list) {
+			memset(dmabuf->virt, 0, hw_page_size);
+			cnt = page_idx + dmabuf->buffer_tag;
+			rq_create->u.request.page[cnt].addr_lo =
+					putPaddrLow(dmabuf->phys);
+			rq_create->u.request.page[cnt].addr_hi =
+					putPaddrHigh(dmabuf->phys);
+			rc++;
+		}
+		page_idx += rc;
+
+		rc = 0;
+		list_for_each_entry(dmabuf, &drq->page_list, list) {
+			memset(dmabuf->virt, 0, hw_page_size);
+			cnt = page_idx + dmabuf->buffer_tag;
+			rq_create->u.request.page[cnt].addr_lo =
+					putPaddrLow(dmabuf->phys);
+			rq_create->u.request.page[cnt].addr_hi =
+					putPaddrHigh(dmabuf->phys);
+			rc++;
+		}
+		page_idx += rc;
+
+		hrq->db_format = LPFC_DB_RING_FORMAT;
+		hrq->db_regaddr = phba->sli4_hba.RQDBregaddr;
+		hrq->type = LPFC_HRQ;
+		hrq->assoc_qid = cq->queue_id;
+		hrq->subtype = subtype;
+		hrq->host_index = 0;
+		hrq->hba_index = 0;
+
+		drq->db_format = LPFC_DB_RING_FORMAT;
+		drq->db_regaddr = phba->sli4_hba.RQDBregaddr;
+		drq->type = LPFC_DRQ;
+		drq->assoc_qid = cq->queue_id;
+		drq->subtype = subtype;
+		drq->host_index = 0;
+		drq->hba_index = 0;
+
+		list_add_tail(&hrq->list, &cq->child_list);
+		list_add_tail(&drq->list, &cq->child_list);
+	}
+
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3120 RQ_CREATE mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+		goto out;
+	}
+	rc = bf_get(lpfc_mbx_rq_create_q_id, &rq_create->u.response);
+	if (rc == 0xFFFF) {
+		status = -ENXIO;
+		goto out;
+	}
+
+	/* Initialize all RQs with associated queue id */
+	for (idx = 0; idx < numrq; idx++) {
+		hrq = hrqp[idx];
+		hrq->queue_id = rc + (2 * idx);
+		drq = drqp[idx];
+		drq->queue_id = rc + (2 * idx) + 1;
+	}
+
+out:
+	lpfc_sli4_mbox_cmd_free(phba, mbox);
+	return status;
+}
+
+/**
  * lpfc_eq_destroy - Destroy an event Queue on the HBA
  * @eq: The queue structure associated with the queue to destroy.
  *
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 99546ea..3bfdff1 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -550,6 +550,9 @@ struct lpfc_sli4_hba {
 	struct lpfc_queue **hba_eq;  /* Event queues for HBA */
 	struct lpfc_queue **fcp_cq;  /* Fast-path FCP compl queue */
 	struct lpfc_queue **nvme_cq; /* Fast-path NVME compl queue */
+	struct lpfc_queue **nvmet_cqset; /* Fast-path NVMET CQ Set queues */
+	struct lpfc_queue **nvmet_mrq_hdr; /* Fast-path NVMET hdr MRQs */
+	struct lpfc_queue **nvmet_mrq_data; /* Fast-path NVMET data MRQs */
 	struct lpfc_queue **fcp_wq;  /* Fast-path FCP work queue */
 	struct lpfc_queue **nvme_wq; /* Fast-path NVME work queue */
 	uint16_t *fcp_cq_map;
@@ -655,6 +658,8 @@ struct lpfc_sli4_hba {
 	uint16_t num_online_cpu;
 	uint16_t num_present_cpu;
 	uint16_t curr_disp_cpu;
+
+	uint16_t nvmet_mrq_post_idx;
 };
 
 enum lpfc_sge_type {
@@ -742,12 +747,18 @@ int lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint32_t);
 int lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uint32_t startq);
 int lpfc_cq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t, uint32_t);
+int lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
+			struct lpfc_queue **eqp, uint32_t type,
+			uint32_t subtype);
 int32_t lpfc_mq_create(struct lpfc_hba *, struct lpfc_queue *,
 		       struct lpfc_queue *, uint32_t);
 int lpfc_wq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t);
 int lpfc_rq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, struct lpfc_queue *, uint32_t);
+int lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_queue **hrqp,
+			struct lpfc_queue **drqp, struct lpfc_queue **cqp,
+			uint32_t subtype);
 void lpfc_rq_adjust_repost(struct lpfc_hba *, struct lpfc_queue *, int);
 int lpfc_eq_destroy(struct lpfc_hba *, struct lpfc_queue *);
 int lpfc_cq_destroy(struct lpfc_hba *, struct lpfc_queue *);
-- 
2.5.0
