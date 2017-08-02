From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 20/21] lpfc: Add new adapter type 6 support
Date: Wed,  2 Aug 2017 16:36:47 -0700
Message-ID: <20170802233648.4573-21-jsmart2021@gmail.com>
References: <20170802233648.4573-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38507 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751987AbdHBXiY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 19:38:24 -0400
Received: by mail-qt0-f193.google.com with SMTP id p3so6126904qtg.5
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 16:38:24 -0700 (PDT)
In-Reply-To: <20170802233648.4573-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The new adpater has a different PCI bar map, the EQ/CQ doorbell
registers and their formats are different from LPE1600 /LPE3200

Replaced the field EQCQDBregaddr with EQDBregaddr and CQDBregaddr in
lpfc_sli4_hba structure. There were a few other minor changes to support
the new adapter type.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |  20 +-
 drivers/scsi/lpfc/lpfc_debugfs.h |  11 +-
 drivers/scsi/lpfc/lpfc_hw4.h     |  85 ++++++++-
 drivers/scsi/lpfc/lpfc_init.c    | 152 +++++++++++++--
 drivers/scsi/lpfc/lpfc_nvme.c    |   4 +-
 drivers/scsi/lpfc/lpfc_nvmet.c   |   5 +-
 drivers/scsi/lpfc/lpfc_sli.c     | 402 +++++++++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_sli4.h    |  27 ++-
 8 files changed, 543 insertions(+), 163 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index c292264aa687..e900d0a3a0fd 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3900,10 +3900,15 @@ lpfc_idiag_drbacc_read_reg(struct lpfc_hba *phba, char *pbuffer,
 		return 0;
 
 	switch (drbregid) {
-	case LPFC_DRB_EQCQ:
-		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
-				"EQCQ-DRB-REG: 0x%08x\n",
-				readl(phba->sli4_hba.EQCQDBregaddr));
+	case LPFC_DRB_EQ:
+		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE - len,
+				"EQ-DRB-REG: 0x%08x\n",
+				readl(phba->sli4_hba.EQDBregaddr));
+		break;
+	case LPFC_DRB_CQ:
+		len += snprintf(pbuffer + len, LPFC_DRB_ACC_BUF_SIZE - len,
+				"CQ-DRB-REG: 0x%08x\n",
+				readl(phba->sli4_hba.CQDBregaddr));
 		break;
 	case LPFC_DRB_MQ:
 		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
@@ -4042,8 +4047,11 @@ lpfc_idiag_drbacc_write(struct file *file, const char __user *buf,
 	    idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_ST ||
 	    idiag.cmd.opcode == LPFC_IDIAG_CMD_DRBACC_CL) {
 		switch (drb_reg_id) {
-		case LPFC_DRB_EQCQ:
-			drb_reg = phba->sli4_hba.EQCQDBregaddr;
+		case LPFC_DRB_EQ:
+			drb_reg = phba->sli4_hba.EQDBregaddr;
+			break;
+		case LPFC_DRB_CQ:
+			drb_reg = phba->sli4_hba.CQDBregaddr;
 			break;
 		case LPFC_DRB_MQ:
 			drb_reg = phba->sli4_hba.MQDBregaddr;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 7b7d314af0e0..97674e86dba7 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -126,12 +126,13 @@
 #define LPFC_DRB_ACC_WR_CMD_ARG 2
 #define LPFC_DRB_ACC_BUF_SIZE 256
 
-#define LPFC_DRB_EQCQ 1
-#define LPFC_DRB_MQ   2
-#define LPFC_DRB_WQ   3
-#define LPFC_DRB_RQ   4
+#define LPFC_DRB_EQ   1
+#define LPFC_DRB_CQ   2
+#define LPFC_DRB_MQ   3
+#define LPFC_DRB_WQ   4
+#define LPFC_DRB_RQ   5
 
-#define LPFC_DRB_MAX  4
+#define LPFC_DRB_MAX  5
 
 #define IDIAG_DRBACC_REGID_INDX 0
 #define IDIAG_DRBACC_VALUE_INDX 1
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 1db0a38683f4..c18f83d4bdec 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -84,6 +84,7 @@ struct lpfc_sli_intf {
 #define LPFC_SLI_INTF_IF_TYPE_0		0
 #define LPFC_SLI_INTF_IF_TYPE_1		1
 #define LPFC_SLI_INTF_IF_TYPE_2		2
+#define LPFC_SLI_INTF_IF_TYPE_6		6
 #define lpfc_sli_intf_sli_family_SHIFT		8
 #define lpfc_sli_intf_sli_family_MASK		0x0000000F
 #define lpfc_sli_intf_sli_family_WORD		word0
@@ -731,11 +732,13 @@ struct lpfc_register {
  * register sets depending on the UCNA Port's reported if_type
  * value.  For UCNA ports running SLI4 and if_type 0, they reside in
  * BAR4.  For UCNA ports running SLI4 and if_type 2, they reside in
- * BAR0.  The offsets are the same so the driver must account for
- * any base address difference.
+ * BAR0.  For FC ports running SLI4 and if_type 6, they reside in
+ * BAR2. The offsets and base address are different,  so the driver
+ * has to compute the register addresses accordingly
  */
 #define LPFC_ULP0_RQ_DOORBELL		0x00A0
 #define LPFC_ULP1_RQ_DOORBELL		0x00C0
+#define LPFC_IF6_RQ_DOORBELL		0x0080
 #define lpfc_rq_db_list_fm_num_posted_SHIFT	24
 #define lpfc_rq_db_list_fm_num_posted_MASK	0x00FF
 #define lpfc_rq_db_list_fm_num_posted_WORD	word0
@@ -770,6 +773,20 @@ struct lpfc_register {
 #define lpfc_wq_db_ring_fm_id_MASK              0xFFFF
 #define lpfc_wq_db_ring_fm_id_WORD              word0
 
+#define LPFC_IF6_WQ_DOORBELL		0x0040
+#define lpfc_if6_wq_db_list_fm_num_posted_SHIFT	24
+#define lpfc_if6_wq_db_list_fm_num_posted_MASK	0x00FF
+#define lpfc_if6_wq_db_list_fm_num_posted_WORD	word0
+#define lpfc_if6_wq_db_list_fm_dpp_SHIFT	23
+#define lpfc_if6_wq_db_list_fm_dpp_MASK		0x0001
+#define lpfc_if6_wq_db_list_fm_dpp_WORD		word0
+#define lpfc_if6_wq_db_list_fm_dpp_id_SHIFT	16
+#define lpfc_if6_wq_db_list_fm_dpp_id_MASK	0x001F
+#define lpfc_if6_wq_db_list_fm_dpp_id_WORD	word0
+#define lpfc_if6_wq_db_list_fm_id_SHIFT		0
+#define lpfc_if6_wq_db_list_fm_id_MASK		0xFFFF
+#define lpfc_if6_wq_db_list_fm_id_WORD		word0
+
 #define LPFC_EQCQ_DOORBELL		0x0120
 #define lpfc_eqcq_doorbell_se_SHIFT		31
 #define lpfc_eqcq_doorbell_se_MASK		0x0001
@@ -805,6 +822,38 @@ struct lpfc_register {
 #define LPFC_CQID_HI_FIELD_SHIFT		10
 #define LPFC_EQID_HI_FIELD_SHIFT		9
 
+#define LPFC_IF6_CQ_DOORBELL			0x00C0
+#define lpfc_if6_cq_doorbell_se_SHIFT		31
+#define lpfc_if6_cq_doorbell_se_MASK		0x0001
+#define lpfc_if6_cq_doorbell_se_WORD		word0
+#define LPFC_IF6_CQ_SOLICIT_ENABLE_OFF		0
+#define LPFC_IF6_CQ_SOLICIT_ENABLE_ON		1
+#define lpfc_if6_cq_doorbell_arm_SHIFT		29
+#define lpfc_if6_cq_doorbell_arm_MASK		0x0001
+#define lpfc_if6_cq_doorbell_arm_WORD		word0
+#define lpfc_if6_cq_doorbell_num_released_SHIFT	16
+#define lpfc_if6_cq_doorbell_num_released_MASK	0x1FFF
+#define lpfc_if6_cq_doorbell_num_released_WORD	word0
+#define lpfc_if6_cq_doorbell_cqid_SHIFT		0
+#define lpfc_if6_cq_doorbell_cqid_MASK		0xFFFF
+#define lpfc_if6_cq_doorbell_cqid_WORD		word0
+
+#define LPFC_IF6_EQ_DOORBELL			0x0120
+#define lpfc_if6_eq_doorbell_io_SHIFT		31
+#define lpfc_if6_eq_doorbell_io_MASK		0x0001
+#define lpfc_if6_eq_doorbell_io_WORD		word0
+#define LPFC_IF6_EQ_INTR_OVERRIDE_OFF		0
+#define LPFC_IF6_EQ_INTR_OVERRIDE_ON		1
+#define lpfc_if6_eq_doorbell_arm_SHIFT		29
+#define lpfc_if6_eq_doorbell_arm_MASK		0x0001
+#define lpfc_if6_eq_doorbell_arm_WORD		word0
+#define lpfc_if6_eq_doorbell_num_released_SHIFT	16
+#define lpfc_if6_eq_doorbell_num_released_MASK	0x1FFF
+#define lpfc_if6_eq_doorbell_num_released_WORD	word0
+#define lpfc_if6_eq_doorbell_eqid_SHIFT		0
+#define lpfc_if6_eq_doorbell_eqid_MASK		0x0FFF
+#define lpfc_if6_eq_doorbell_eqid_WORD		word0
+
 #define LPFC_BMBX			0x0160
 #define lpfc_bmbx_addr_SHIFT		2
 #define lpfc_bmbx_addr_MASK		0x3FFFFFFF
@@ -817,6 +866,7 @@ struct lpfc_register {
 #define lpfc_bmbx_rdy_WORD		word0
 
 #define LPFC_MQ_DOORBELL			0x0140
+#define LPFC_IF6_MQ_DOORBELL			0x0160
 #define lpfc_mq_doorbell_num_posted_SHIFT	16
 #define lpfc_mq_doorbell_num_posted_MASK	0x3FFF
 #define lpfc_mq_doorbell_num_posted_WORD	word0
@@ -1318,6 +1368,15 @@ struct lpfc_mbx_wq_create {
 #define lpfc_mbx_wq_create_page_size_MASK	0x000000FF
 #define lpfc_mbx_wq_create_page_size_WORD	word1
 #define LPFC_WQ_PAGE_SIZE_4096	0x1
+#define lpfc_mbx_wq_create_dpp_req_SHIFT	15
+#define lpfc_mbx_wq_create_dpp_req_MASK		0x00000001
+#define lpfc_mbx_wq_create_dpp_req_WORD		word1
+#define lpfc_mbx_wq_create_doe_SHIFT		14
+#define lpfc_mbx_wq_create_doe_MASK		0x00000001
+#define lpfc_mbx_wq_create_doe_WORD		word1
+#define lpfc_mbx_wq_create_toe_SHIFT		13
+#define lpfc_mbx_wq_create_toe_MASK		0x00000001
+#define lpfc_mbx_wq_create_toe_WORD		word1
 #define lpfc_mbx_wq_create_wqe_size_SHIFT	8
 #define lpfc_mbx_wq_create_wqe_size_MASK	0x0000000F
 #define lpfc_mbx_wq_create_wqe_size_WORD	word1
@@ -1346,6 +1405,28 @@ struct lpfc_mbx_wq_create {
 #define lpfc_mbx_wq_create_db_format_MASK	0x0000FFFF
 #define lpfc_mbx_wq_create_db_format_WORD	word2
 		} response;
+		struct {
+			uint32_t word0;
+#define lpfc_mbx_wq_create_dpp_rsp_SHIFT	31
+#define lpfc_mbx_wq_create_dpp_rsp_MASK		0x00000001
+#define lpfc_mbx_wq_create_dpp_rsp_WORD		word0
+#define lpfc_mbx_wq_create_v1_q_id_SHIFT	0
+#define lpfc_mbx_wq_create_v1_q_id_MASK		0x0000FFFF
+#define lpfc_mbx_wq_create_v1_q_id_WORD		word0
+			uint32_t word1;
+#define lpfc_mbx_wq_create_v1_bar_set_SHIFT	0
+#define lpfc_mbx_wq_create_v1_bar_set_MASK	0x0000000F
+#define lpfc_mbx_wq_create_v1_bar_set_WORD	word1
+			uint32_t doorbell_offset;
+			uint32_t word3;
+#define lpfc_mbx_wq_create_dpp_id_SHIFT		16
+#define lpfc_mbx_wq_create_dpp_id_MASK		0x0000001F
+#define lpfc_mbx_wq_create_dpp_id_WORD		word3
+#define lpfc_mbx_wq_create_dpp_bar_SHIFT	0
+#define lpfc_mbx_wq_create_dpp_bar_MASK		0x0000000F
+#define lpfc_mbx_wq_create_dpp_bar_WORD		word3
+			uint32_t dpp_offset;
+		} response_1;
 	} u;
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 19af7e2c2ac0..d7f18c9ea0bb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1753,7 +1753,7 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 	int rc;
 	uint32_t intr_mode;
 
-	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
 	    LPFC_SLI_INTF_IF_TYPE_2) {
 		/*
 		 * On error status condition, driver need to wait for port
@@ -1884,6 +1884,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 		break;
 
 	case LPFC_SLI_INTF_IF_TYPE_2:
+	case LPFC_SLI_INTF_IF_TYPE_6:
 		pci_rd_rc1 = lpfc_readl(
 				phba->sli4_hba.u.if_type2.STATUSregaddr,
 				&portstat_reg.word0);
@@ -6001,7 +6002,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		return -ENOMEM;
 
 	/* IF Type 2 ports get initialized now. */
-	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
 	    LPFC_SLI_INTF_IF_TYPE_2) {
 		rc = lpfc_pci_function_reset(phba);
 		if (unlikely(rc)) {
@@ -7321,6 +7322,7 @@ lpfc_sli4_post_status_check(struct lpfc_hba *phba)
 			}
 			break;
 		case LPFC_SLI_INTF_IF_TYPE_2:
+		case LPFC_SLI_INTF_IF_TYPE_6:
 			/* Final checks.  The port status should be clean. */
 			if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
 				&reg_data.word0) ||
@@ -7403,13 +7405,34 @@ lpfc_sli4_bar0_register_memmap(struct lpfc_hba *phba, uint32_t if_type)
 		phba->sli4_hba.WQDBregaddr =
 			phba->sli4_hba.conf_regs_memmap_p +
 						LPFC_ULP0_WQ_DOORBELL;
-		phba->sli4_hba.EQCQDBregaddr =
+		phba->sli4_hba.CQDBregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_EQCQ_DOORBELL;
+		phba->sli4_hba.EQDBregaddr =
 			phba->sli4_hba.conf_regs_memmap_p + LPFC_EQCQ_DOORBELL;
 		phba->sli4_hba.MQDBregaddr =
 			phba->sli4_hba.conf_regs_memmap_p + LPFC_MQ_DOORBELL;
 		phba->sli4_hba.BMBXregaddr =
 			phba->sli4_hba.conf_regs_memmap_p + LPFC_BMBX;
 		break;
+	case LPFC_SLI_INTF_IF_TYPE_6:
+		phba->sli4_hba.u.if_type2.ERR1regaddr =
+			phba->sli4_hba.conf_regs_memmap_p +
+						LPFC_CTL_PORT_ER1_OFFSET;
+		phba->sli4_hba.u.if_type2.ERR2regaddr =
+			phba->sli4_hba.conf_regs_memmap_p +
+						LPFC_CTL_PORT_ER2_OFFSET;
+		phba->sli4_hba.u.if_type2.CTRLregaddr =
+			phba->sli4_hba.conf_regs_memmap_p +
+						LPFC_CTL_PORT_CTL_OFFSET;
+		phba->sli4_hba.u.if_type2.STATUSregaddr =
+			phba->sli4_hba.conf_regs_memmap_p +
+						LPFC_CTL_PORT_STA_OFFSET;
+		phba->sli4_hba.PSMPHRregaddr =
+			phba->sli4_hba.conf_regs_memmap_p +
+						LPFC_CTL_PORT_SEM_OFFSET;
+		phba->sli4_hba.BMBXregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_BMBX;
+		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
 		dev_printk(KERN_ERR, &phba->pcidev->dev,
@@ -7423,20 +7446,43 @@ lpfc_sli4_bar0_register_memmap(struct lpfc_hba *phba, uint32_t if_type)
  * lpfc_sli4_bar1_register_memmap - Set up SLI4 BAR1 register memory map.
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to set up SLI4 BAR1 control status register (CSR)
- * memory map.
+ * This routine is invoked to set up SLI4 BAR1 register memory map.
  **/
 static void
-lpfc_sli4_bar1_register_memmap(struct lpfc_hba *phba)
+lpfc_sli4_bar1_register_memmap(struct lpfc_hba *phba, uint32_t if_type)
 {
-	phba->sli4_hba.PSMPHRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
-		LPFC_SLIPORT_IF0_SMPHR;
-	phba->sli4_hba.ISRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
-		LPFC_HST_ISR0;
-	phba->sli4_hba.IMRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
-		LPFC_HST_IMR0;
-	phba->sli4_hba.ISCRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
-		LPFC_HST_ISCR0;
+	switch (if_type) {
+	case LPFC_SLI_INTF_IF_TYPE_0:
+		phba->sli4_hba.PSMPHRregaddr =
+			phba->sli4_hba.ctrl_regs_memmap_p +
+			LPFC_SLIPORT_IF0_SMPHR;
+		phba->sli4_hba.ISRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
+			LPFC_HST_ISR0;
+		phba->sli4_hba.IMRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
+			LPFC_HST_IMR0;
+		phba->sli4_hba.ISCRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
+			LPFC_HST_ISCR0;
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_6:
+		phba->sli4_hba.RQDBregaddr = phba->sli4_hba.drbl_regs_memmap_p +
+			LPFC_IF6_RQ_DOORBELL;
+		phba->sli4_hba.WQDBregaddr = phba->sli4_hba.drbl_regs_memmap_p +
+			LPFC_IF6_WQ_DOORBELL;
+		phba->sli4_hba.CQDBregaddr = phba->sli4_hba.drbl_regs_memmap_p +
+			LPFC_IF6_CQ_DOORBELL;
+		phba->sli4_hba.EQDBregaddr = phba->sli4_hba.drbl_regs_memmap_p +
+			LPFC_IF6_EQ_DOORBELL;
+		phba->sli4_hba.MQDBregaddr = phba->sli4_hba.drbl_regs_memmap_p +
+			LPFC_IF6_MQ_DOORBELL;
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_2:
+	case LPFC_SLI_INTF_IF_TYPE_1:
+	default:
+		dev_err(&phba->pcidev->dev,
+			   "FATAL - unsupported SLI4 interface type - %d\n",
+			   if_type);
+		break;
+	}
 }
 
 /**
@@ -7461,8 +7507,12 @@ lpfc_sli4_bar2_register_memmap(struct lpfc_hba *phba, uint32_t vf)
 	phba->sli4_hba.WQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
 				vf * LPFC_VFR_PAGE_SIZE +
 					LPFC_ULP0_WQ_DOORBELL);
-	phba->sli4_hba.EQCQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
-				vf * LPFC_VFR_PAGE_SIZE + LPFC_EQCQ_DOORBELL);
+	phba->sli4_hba.CQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
+				vf * LPFC_VFR_PAGE_SIZE +
+					LPFC_EQCQ_DOORBELL);
+	phba->sli4_hba.EQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
+				vf * LPFC_VFR_PAGE_SIZE +
+					LPFC_EQCQ_DOORBELL);
 	phba->sli4_hba.MQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
 				vf * LPFC_VFR_PAGE_SIZE + LPFC_MQ_DOORBELL);
 	phba->sli4_hba.BMBXregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
@@ -7699,7 +7749,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 
 	/* Update link speed if forced link speed is supported */
 	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
-	if (if_type == LPFC_SLI_INTF_IF_TYPE_2) {
+	if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
 		forced_link_speed =
 			bf_get(lpfc_mbx_rd_conf_link_speed, rd_config);
 		if (forced_link_speed) {
@@ -7759,7 +7809,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 		phba->cfg_hba_queue_depth = length;
 	}
 
-	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) <
 	    LPFC_SLI_INTF_IF_TYPE_2)
 		goto read_cfg_out;
 
@@ -7873,6 +7923,7 @@ lpfc_setup_endian_order(struct lpfc_hba *phba)
 		}
 		mempool_free(mboxq, phba->mbox_mem_pool);
 		break;
+	case LPFC_SLI_INTF_IF_TYPE_6:
 	case LPFC_SLI_INTF_IF_TYPE_2:
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
@@ -9247,6 +9298,7 @@ lpfc_pci_function_reset(struct lpfc_hba *phba)
 		}
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_2:
+	case LPFC_SLI_INTF_IF_TYPE_6:
 wait:
 		/*
 		 * Poll the Port Status Register and wait for RDY for
@@ -9402,7 +9454,7 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 	} else {
 		phba->pci_bar0_map = pci_resource_start(pdev, 1);
 		bar0map_len = pci_resource_len(pdev, 1);
-		if (if_type == LPFC_SLI_INTF_IF_TYPE_2) {
+		if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
 			dev_printk(KERN_ERR, &pdev->dev,
 			   "FATAL - No BAR0 mapping for SLI4, if_type 2\n");
 			goto out;
@@ -9434,7 +9486,26 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 			goto out_iounmap_conf;
 		}
 		phba->pci_bar2_memmap_p = phba->sli4_hba.ctrl_regs_memmap_p;
-		lpfc_sli4_bar1_register_memmap(phba);
+		lpfc_sli4_bar1_register_memmap(phba, if_type);
+	}
+
+	if (if_type == LPFC_SLI_INTF_IF_TYPE_6 &&
+	    pci_resource_start(pdev, PCI_64BIT_BAR2)) {
+		/*
+		 * Map SLI4 if type 6 HBA Doorbell Register base to a kernel
+		 * virtual address and setup the registers.
+		 */
+		phba->pci_bar1_map = pci_resource_start(pdev, PCI_64BIT_BAR2);
+		bar1map_len = pci_resource_len(pdev, PCI_64BIT_BAR2);
+		phba->sli4_hba.drbl_regs_memmap_p =
+				ioremap(phba->pci_bar1_map, bar1map_len);
+		if (!phba->sli4_hba.drbl_regs_memmap_p) {
+			dev_err(&pdev->dev,
+			   "ioremap failed for SLI4 HBA doorbell registers.\n");
+			goto out_iounmap_conf;
+		}
+		phba->pci_bar2_memmap_p = phba->sli4_hba.drbl_regs_memmap_p;
+		lpfc_sli4_bar1_register_memmap(phba, if_type);
 	}
 
 	if ((if_type == LPFC_SLI_INTF_IF_TYPE_0) &&
@@ -9458,6 +9529,41 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 			goto out_iounmap_all;
 	}
 
+	if (if_type == LPFC_SLI_INTF_IF_TYPE_6 &&
+	    pci_resource_start(pdev, PCI_64BIT_BAR4)) {
+		/*
+		 * Map SLI4 if type 6 HBA DPP Register base to a kernel
+		 * virtual address and setup the registers.
+		 */
+		phba->pci_bar2_map = pci_resource_start(pdev, PCI_64BIT_BAR4);
+		bar2map_len = pci_resource_len(pdev, PCI_64BIT_BAR4);
+		phba->sli4_hba.dpp_regs_memmap_p =
+				ioremap(phba->pci_bar2_map, bar2map_len);
+		if (!phba->sli4_hba.dpp_regs_memmap_p) {
+			dev_err(&pdev->dev,
+			   "ioremap failed for SLI4 HBA dpp registers.\n");
+			goto out_iounmap_ctrl;
+		}
+		phba->pci_bar4_memmap_p = phba->sli4_hba.dpp_regs_memmap_p;
+	}
+
+	/* Set up the EQ/CQ register handeling functions now */
+	switch (if_type) {
+	case LPFC_SLI_INTF_IF_TYPE_0:
+	case LPFC_SLI_INTF_IF_TYPE_2:
+		phba->sli4_hba.sli4_eq_clr_intr = lpfc_sli4_eq_clr_intr;
+		phba->sli4_hba.sli4_eq_release = lpfc_sli4_eq_release;
+		phba->sli4_hba.sli4_cq_release = lpfc_sli4_cq_release;
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_6:
+		phba->sli4_hba.sli4_eq_clr_intr = lpfc_sli4_if6_eq_clr_intr;
+		phba->sli4_hba.sli4_eq_release = lpfc_sli4_if6_eq_release;
+		phba->sli4_hba.sli4_cq_release = lpfc_sli4_if6_cq_release;
+		break;
+	default:
+		break;
+	}
+
 	return 0;
 
 out_iounmap_all:
@@ -9492,6 +9598,10 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 	case LPFC_SLI_INTF_IF_TYPE_2:
 		iounmap(phba->sli4_hba.conf_regs_memmap_p);
 		break;
+	case LPFC_SLI_INTF_IF_TYPE_6:
+		iounmap(phba->sli4_hba.drbl_regs_memmap_p);
+		iounmap(phba->sli4_hba.conf_regs_memmap_p);
+		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
 		dev_printk(KERN_ERR, &phba->pcidev->dev,
@@ -11169,7 +11279,7 @@ lpfc_sli4_request_firmware_update(struct lpfc_hba *phba, uint8_t fw_upgrade)
 	const struct firmware *fw;
 
 	/* Only supported on SLI4 interface type 2 for now */
-	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) <
 	    LPFC_SLI_INTF_IF_TYPE_2)
 		return -EPERM;
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index d3c171a72ae0..edb7767171c9 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -619,7 +619,7 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 
 	/* Word 0-2 - NVME CMND IU (embedded payload) */
 	wqe->generic.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_IMMED;
-	wqe->generic.bde.tus.f.bdeSize = 60;
+	wqe->generic.bde.tus.f.bdeSize = 56;
 	wqe->generic.bde.addrHigh = 0;
 	wqe->generic.bde.addrLow =  64;  /* Word 16 */
 
@@ -628,6 +628,7 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 	       (nCmd->rsplen + nCmd->cmdlen));
 
 	/* Word 10 */
+	bf_set(wqe_dbde, &wqe->generic.wqe_com, 0);
 	bf_set(wqe_nvme, &wqe->fcp_icmd.wqe_com, 1);
 	bf_set(wqe_wqes, &wqe->fcp_icmd.wqe_com, 1);
 
@@ -1999,7 +2000,6 @@ lpfc_new_nvme_buf(struct lpfc_vport *vport, int num_to_alloc)
 
 		/* Word 10 */
 		bf_set(wqe_ebde_cnt, &wqe->generic.wqe_com, 0);
-		bf_set(wqe_dbde, &wqe->generic.wqe_com, 1);
 
 		/* add the nvme buffer to a post list */
 		list_add_tail(&lpfc_ncmd->list, &post_nblist);
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 40fa5dd72bfa..beaa934908ab 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2179,7 +2179,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 
 		/* Word 10 */
 		bf_set(wqe_nvme, &wqe->fcp_trsp.wqe_com, 1);
-		bf_set(wqe_dbde, &wqe->fcp_trsp.wqe_com, 0);
+		bf_set(wqe_dbde, &wqe->fcp_trsp.wqe_com, 1);
 		bf_set(wqe_iod, &wqe->fcp_trsp.wqe_com, LPFC_WQE_IOD_WRITE);
 		bf_set(wqe_lenloc, &wqe->fcp_trsp.wqe_com,
 		       LPFC_WQE_LENLOC_WORD3);
@@ -2516,7 +2516,7 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	bf_set(wqe_rcvoxid, &wqe_abts->xmit_sequence.wqe_com, xri);
 
 	/* Word 10 */
-	bf_set(wqe_dbde, &wqe_abts->xmit_sequence.wqe_com, 1);
+	bf_set(wqe_dbde, &wqe_abts->xmit_sequence.wqe_com, 0);
 	bf_set(wqe_iod, &wqe_abts->xmit_sequence.wqe_com, LPFC_WQE_IOD_WRITE);
 	bf_set(wqe_lenloc, &wqe_abts->xmit_sequence.wqe_com,
 	       LPFC_WQE_LENLOC_WORD12);
@@ -2652,6 +2652,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	       abts_wqeq->iotag);
 
 	/* word 10 */
+	bf_set(wqe_dbde, &abts_wqe->abort_cmd.wqe_com, 0);
 	bf_set(wqe_qosd, &abts_wqe->abort_cmd.wqe_com, 1);
 	bf_set(wqe_lenloc, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_LENLOC_NONE);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5018f41669cc..3539ac85dcac 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -113,6 +113,8 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe *wqe)
 	struct lpfc_register doorbell;
 	uint32_t host_index;
 	uint32_t idx;
+	uint32_t i = 0;
+	uint8_t *tmp;
 
 	/* sanity check on queue memory */
 	if (unlikely(!q))
@@ -132,6 +134,12 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe *wqe)
 	if (q->phba->sli3_options & LPFC_SLI4_PHWQ_ENABLED)
 		bf_set(wqe_wqid, &wqe->generic.wqe_com, q->queue_id);
 	lpfc_sli_pcimem_bcopy(wqe, temp_wqe, q->entry_size);
+	if (q->dpp_enable) {
+		/* write to the dpp-aperture as well */
+		tmp = (uint8_t *)wqe;
+		for (i = 0; i < q->entry_size; i += sizeof(uint32_t))
+			writel(*((uint32_t *)(tmp + i)), q->dpp_regaddr + i);
+	}
 	/* ensure WQE bcopy flushed before doorbell write */
 	wmb();
 
@@ -143,9 +151,18 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe *wqe)
 	/* Ring Doorbell */
 	doorbell.word0 = 0;
 	if (q->db_format == LPFC_DB_LIST_FORMAT) {
-		bf_set(lpfc_wq_db_list_fm_num_posted, &doorbell, 1);
-		bf_set(lpfc_wq_db_list_fm_index, &doorbell, host_index);
-		bf_set(lpfc_wq_db_list_fm_id, &doorbell, q->queue_id);
+		if (q->dpp_enable) {
+			bf_set(lpfc_if6_wq_db_list_fm_num_posted, &doorbell, 1);
+			bf_set(lpfc_if6_wq_db_list_fm_dpp, &doorbell, 1);
+			bf_set(lpfc_if6_wq_db_list_fm_dpp_id, &doorbell,
+			    q->dpp_id);
+			bf_set(lpfc_if6_wq_db_list_fm_id, &doorbell,
+			    q->queue_id);
+		} else {
+			bf_set(lpfc_wq_db_list_fm_num_posted, &doorbell, 1);
+			bf_set(lpfc_wq_db_list_fm_index, &doorbell, host_index);
+			bf_set(lpfc_wq_db_list_fm_id, &doorbell, q->queue_id);
+		}
 	} else if (q->db_format == LPFC_DB_RING_FORMAT) {
 		bf_set(lpfc_wq_db_ring_fm_num_posted, &doorbell, 1);
 		bf_set(lpfc_wq_db_ring_fm_id, &doorbell, q->queue_id);
@@ -298,7 +315,7 @@ lpfc_sli4_eq_get(struct lpfc_queue *q)
  * @q: The Event Queue to disable interrupts
  *
  **/
-static inline void
+inline void
 lpfc_sli4_eq_clr_intr(struct lpfc_queue *q)
 {
 	struct lpfc_register doorbell;
@@ -309,7 +326,26 @@ lpfc_sli4_eq_clr_intr(struct lpfc_queue *q)
 	bf_set(lpfc_eqcq_doorbell_eqid_hi, &doorbell,
 		(q->queue_id >> LPFC_EQID_HI_FIELD_SHIFT));
 	bf_set(lpfc_eqcq_doorbell_eqid_lo, &doorbell, q->queue_id);
-	writel(doorbell.word0, q->phba->sli4_hba.EQCQDBregaddr);
+	writel(doorbell.word0, q->phba->sli4_hba.EQDBregaddr);
+}
+
+/**
+ * lpfc_sli4_if6_eq_clr_intr - Turn off interrupts from this EQ
+ * @q: The Event Queue to disable interrupts
+ *
+ **/
+inline void
+lpfc_sli4_if6_eq_clr_intr(struct lpfc_queue *q)
+{
+	struct lpfc_register doorbell;
+
+	doorbell.word0 = 0;
+	bf_set(lpfc_eqcq_doorbell_eqci, &doorbell, 1);
+	bf_set(lpfc_eqcq_doorbell_qt, &doorbell, LPFC_QUEUE_TYPE_EVENT);
+	bf_set(lpfc_eqcq_doorbell_eqid_hi, &doorbell,
+		(q->queue_id >> LPFC_EQID_HI_FIELD_SHIFT));
+	bf_set(lpfc_eqcq_doorbell_eqid_lo, &doorbell, q->queue_id);
+	writel(doorbell.word0, q->phba->sli4_hba.EQDBregaddr);
 }
 
 /**
@@ -359,10 +395,59 @@ lpfc_sli4_eq_release(struct lpfc_queue *q, bool arm)
 	bf_set(lpfc_eqcq_doorbell_eqid_hi, &doorbell,
 			(q->queue_id >> LPFC_EQID_HI_FIELD_SHIFT));
 	bf_set(lpfc_eqcq_doorbell_eqid_lo, &doorbell, q->queue_id);
-	writel(doorbell.word0, q->phba->sli4_hba.EQCQDBregaddr);
+	writel(doorbell.word0, q->phba->sli4_hba.EQDBregaddr);
+	/* PCI read to flush PCI pipeline on re-arming for INTx mode */
+	if (q->phba->intr_type == INTx && arm == LPFC_QUEUE_REARM)
+		readl(q->phba->sli4_hba.EQDBregaddr);
+	return released;
+}
+
+/**
+ * lpfc_sli4_if6_eq_release - Indicates the host has finished processing an EQ
+ * @q: The Event Queue that the host has completed processing for.
+ * @arm: Indicates whether the host wants to arms this CQ.
+ *
+ * This routine will mark all Event Queue Entries on @q, from the last
+ * known completed entry to the last entry that was processed, as completed
+ * by clearing the valid bit for each completion queue entry. Then it will
+ * notify the HBA, by ringing the doorbell, that the EQEs have been processed.
+ * The internal host index in the @q will be updated by this routine to indicate
+ * that the host has finished processing the entries. The @arm parameter
+ * indicates that the queue should be rearmed when ringing the doorbell.
+ *
+ * This function will return the number of EQEs that were popped.
+ **/
+uint32_t
+lpfc_sli4_if6_eq_release(struct lpfc_queue *q, bool arm)
+{
+	uint32_t released = 0;
+	struct lpfc_eqe *temp_eqe;
+	struct lpfc_register doorbell;
+
+	/* sanity check on queue memory */
+	if (unlikely(!q))
+		return 0;
+
+	/* while there are valid entries */
+	while (q->hba_index != q->host_index) {
+		temp_eqe = q->qe[q->host_index].eqe;
+		bf_set_le32(lpfc_eqe_valid, temp_eqe, 0);
+		released++;
+		q->host_index = ((q->host_index + 1) % q->entry_count);
+	}
+	if (unlikely(released == 0 && !arm))
+		return 0;
+
+	/* ring doorbell for number popped */
+	doorbell.word0 = 0;
+	if (arm)
+		bf_set(lpfc_if6_eq_doorbell_arm, &doorbell, 1);
+	bf_set(lpfc_if6_eq_doorbell_num_released, &doorbell, released);
+	bf_set(lpfc_if6_eq_doorbell_eqid, &doorbell, q->queue_id);
+	writel(doorbell.word0, q->phba->sli4_hba.EQDBregaddr);
 	/* PCI read to flush PCI pipeline on re-arming for INTx mode */
-	if ((q->phba->intr_type == INTx) && (arm == LPFC_QUEUE_REARM))
-		readl(q->phba->sli4_hba.EQCQDBregaddr);
+	if (q->phba->intr_type == INTx && arm == LPFC_QUEUE_REARM)
+		readl(q->phba->sli4_hba.EQDBregaddr);
 	return released;
 }
 
@@ -452,7 +537,52 @@ lpfc_sli4_cq_release(struct lpfc_queue *q, bool arm)
 	bf_set(lpfc_eqcq_doorbell_cqid_hi, &doorbell,
 			(q->queue_id >> LPFC_CQID_HI_FIELD_SHIFT));
 	bf_set(lpfc_eqcq_doorbell_cqid_lo, &doorbell, q->queue_id);
-	writel(doorbell.word0, q->phba->sli4_hba.EQCQDBregaddr);
+	writel(doorbell.word0, q->phba->sli4_hba.CQDBregaddr);
+	return released;
+}
+
+/**
+ * lpfc_sli4_if6_cq_release - Indicates the host has finished processing a CQ
+ * @q: The Completion Queue that the host has completed processing for.
+ * @arm: Indicates whether the host wants to arms this CQ.
+ *
+ * This routine will mark all Completion queue entries on @q, from the last
+ * known completed entry to the last entry that was processed, as completed
+ * by clearing the valid bit for each completion queue entry. Then it will
+ * notify the HBA, by ringing the doorbell, that the CQEs have been processed.
+ * The internal host index in the @q will be updated by this routine to indicate
+ * that the host has finished processing the entries. The @arm parameter
+ * indicates that the queue should be rearmed when ringing the doorbell.
+ *
+ * This function will return the number of CQEs that were released.
+ **/
+uint32_t
+lpfc_sli4_if6_cq_release(struct lpfc_queue *q, bool arm)
+{
+	uint32_t released = 0;
+	struct lpfc_cqe *temp_qe;
+	struct lpfc_register doorbell;
+
+	/* sanity check on queue memory */
+	if (unlikely(!q))
+		return 0;
+	/* while there are valid entries */
+	while (q->hba_index != q->host_index) {
+		temp_qe = q->qe[q->host_index].cqe;
+		bf_set_le32(lpfc_cqe_valid, temp_qe, 0);
+		released++;
+		q->host_index = ((q->host_index + 1) % q->entry_count);
+	}
+	if (unlikely(released == 0 && !arm))
+		return 0;
+
+	/* ring doorbell for number popped */
+	doorbell.word0 = 0;
+	if (arm)
+		bf_set(lpfc_if6_cq_doorbell_arm, &doorbell, 1);
+	bf_set(lpfc_if6_cq_doorbell_num_released, &doorbell, released);
+	bf_set(lpfc_if6_cq_doorbell_cqid, &doorbell, q->queue_id);
+	writel(doorbell.word0, q->phba->sli4_hba.CQDBregaddr);
 	return released;
 }
 
@@ -2328,7 +2458,7 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	if (pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) {
 		if (phba->sli_rev == LPFC_SLI_REV4 &&
 		    (bf_get(lpfc_sli_intf_if_type,
-		     &phba->sli4_hba.sli_intf) ==
+		     &phba->sli4_hba.sli_intf) >=
 		     LPFC_SLI_INTF_IF_TYPE_2)) {
 			if (ndlp) {
 				lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
@@ -5281,41 +5411,42 @@ static void
 lpfc_sli4_arm_cqeq_intr(struct lpfc_hba *phba)
 {
 	int qidx;
+	struct lpfc_sli4_hba *sli4_hba = &phba->sli4_hba;
 
-	lpfc_sli4_cq_release(phba->sli4_hba.mbx_cq, LPFC_QUEUE_REARM);
-	lpfc_sli4_cq_release(phba->sli4_hba.els_cq, LPFC_QUEUE_REARM);
-	if (phba->sli4_hba.nvmels_cq)
-		lpfc_sli4_cq_release(phba->sli4_hba.nvmels_cq,
+	sli4_hba->sli4_cq_release(sli4_hba->mbx_cq, LPFC_QUEUE_REARM);
+	sli4_hba->sli4_cq_release(sli4_hba->els_cq, LPFC_QUEUE_REARM);
+	if (sli4_hba->nvmels_cq)
+		sli4_hba->sli4_cq_release(sli4_hba->nvmels_cq,
 						LPFC_QUEUE_REARM);
 
-	if (phba->sli4_hba.fcp_cq)
+	if (sli4_hba->fcp_cq)
 		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++)
-			lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[qidx],
+			sli4_hba->sli4_cq_release(sli4_hba->fcp_cq[qidx],
 						LPFC_QUEUE_REARM);
 
-	if (phba->sli4_hba.nvme_cq)
+	if (sli4_hba->nvme_cq)
 		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
-			lpfc_sli4_cq_release(phba->sli4_hba.nvme_cq[qidx],
+			sli4_hba->sli4_cq_release(sli4_hba->nvme_cq[qidx],
 						LPFC_QUEUE_REARM);
 
 	if (phba->cfg_fof)
-		lpfc_sli4_cq_release(phba->sli4_hba.oas_cq, LPFC_QUEUE_REARM);
+		sli4_hba->sli4_cq_release(sli4_hba->oas_cq, LPFC_QUEUE_REARM);
 
-	if (phba->sli4_hba.hba_eq)
+	if (sli4_hba->hba_eq)
 		for (qidx = 0; qidx < phba->io_channel_irqs; qidx++)
-			lpfc_sli4_eq_release(phba->sli4_hba.hba_eq[qidx],
-						LPFC_QUEUE_REARM);
+			sli4_hba->sli4_eq_release(sli4_hba->hba_eq[qidx],
+							LPFC_QUEUE_REARM);
 
 	if (phba->nvmet_support) {
 		for (qidx = 0; qidx < phba->cfg_nvmet_mrq; qidx++) {
-			lpfc_sli4_cq_release(
-				phba->sli4_hba.nvmet_cqset[qidx],
+			sli4_hba->sli4_cq_release(
+				sli4_hba->nvmet_cqset[qidx],
 				LPFC_QUEUE_REARM);
 		}
 	}
 
 	if (phba->cfg_fof)
-		lpfc_sli4_eq_release(phba->sli4_hba.fof_eq, LPFC_QUEUE_REARM);
+		sli4_hba->sli4_eq_release(sli4_hba->fof_eq, LPFC_QUEUE_REARM);
 }
 
 /**
@@ -7237,7 +7368,7 @@ lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba)
 bool
 lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 {
-
+	struct lpfc_sli4_hba *sli4_hba = &phba->sli4_hba;
 	uint32_t eqidx;
 	struct lpfc_queue *fpeq = NULL;
 	struct lpfc_eqe *eqe;
@@ -7248,11 +7379,11 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 
 	/* Find the eq associated with the mcq */
 
-	if (phba->sli4_hba.hba_eq)
+	if (sli4_hba->hba_eq)
 		for (eqidx = 0; eqidx < phba->io_channel_irqs; eqidx++)
-			if (phba->sli4_hba.hba_eq[eqidx]->queue_id ==
-			    phba->sli4_hba.mbx_cq->assoc_qid) {
-				fpeq = phba->sli4_hba.hba_eq[eqidx];
+			if (sli4_hba->hba_eq[eqidx]->queue_id ==
+					sli4_hba->mbx_cq->assoc_qid) {
+				fpeq = sli4_hba->hba_eq[eqidx];
 				break;
 			}
 	if (!fpeq)
@@ -7260,7 +7391,7 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 
 	/* Turn off interrupts from this EQ */
 
-	lpfc_sli4_eq_clr_intr(fpeq);
+	sli4_hba->sli4_eq_clr_intr(fpeq);
 
 	/* Check to see if a mbox completion is pending */
 
@@ -7281,7 +7412,7 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 
 	/* Always clear and re-arm the EQ */
 
-	lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
+	sli4_hba->sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
 
 	return mbox_pending;
 
@@ -8758,7 +8889,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 					iocbq->context2)->virt);
 		if_type = bf_get(lpfc_sli_intf_if_type,
 					&phba->sli4_hba.sli_intf);
-		if (if_type == LPFC_SLI_INTF_IF_TYPE_2) {
+		if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
 			if (pcmd && (*pcmd == ELS_CMD_FLOGI ||
 				*pcmd == ELS_CMD_SCR ||
 				*pcmd == ELS_CMD_FDISC ||
@@ -9055,7 +9186,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 
 		if_type = bf_get(lpfc_sli_intf_if_type,
 					&phba->sli4_hba.sli_intf);
-		if (if_type == LPFC_SLI_INTF_IF_TYPE_2) {
+		if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
 			if (iocbq->vport->fc_flag & FC_PT2PT) {
 				bf_set(els_rsp64_sp, &wqe->xmit_els_rsp, 1);
 				bf_set(els_rsp64_sid, &wqe->xmit_els_rsp,
@@ -9458,7 +9589,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 				fpeq = phba->sli4_hba.hba_eq[idx];
 
 				/* Turn off interrupts from this EQ */
-				lpfc_sli4_eq_clr_intr(fpeq);
+				phba->sli4_hba.sli4_eq_clr_intr(fpeq);
 
 				/*
 				 * Process all the events on FCP EQ
@@ -9470,7 +9601,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 				}
 
 				/* Always clear and re-arm the EQ */
-				lpfc_sli4_eq_release(fpeq,
+				phba->sli4_hba.sli4_eq_release(fpeq,
 					LPFC_QUEUE_REARM);
 			}
 			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
@@ -11628,6 +11759,7 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 		}
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_2:
+	case LPFC_SLI_INTF_IF_TYPE_6:
 		if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
 			&portstat_reg.word0) ||
 			lpfc_readl(phba->sli4_hba.PSMPHRregaddr,
@@ -13081,7 +13213,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 				"(x%x), type (%d)\n", cq->queue_id, cq->type);
 
 	/* In any case, flash and re-arm the RCQ */
-	lpfc_sli4_cq_release(cq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_cq_release(cq, LPFC_QUEUE_REARM);
 
 	/* wake up worker thread if there are works to be done */
 	if (workposted)
@@ -13484,7 +13616,7 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 				"queue fcpcqid=%d\n", cq->queue_id);
 
 	/* In any case, flash and re-arm the CQ */
-	lpfc_sli4_cq_release(cq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_cq_release(cq, LPFC_QUEUE_REARM);
 
 	/* wake up worker thread if there are works to be done */
 	if (workposted)
@@ -13503,7 +13635,7 @@ lpfc_sli4_eq_flush(struct lpfc_hba *phba, struct lpfc_queue *eq)
 		;
 
 	/* Clear and re-arm the EQ */
-	lpfc_sli4_eq_release(eq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_eq_release(eq, LPFC_QUEUE_REARM);
 }
 
 
@@ -13584,7 +13716,7 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
 				"queue fcpcqid=%d\n", cq->queue_id);
 
 	/* In any case, flash and re-arm the CQ */
-	lpfc_sli4_cq_release(cq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_cq_release(cq, LPFC_QUEUE_REARM);
 
 	/* wake up worker thread if there are works to be done */
 	if (workposted)
@@ -13675,7 +13807,7 @@ lpfc_sli4_fof_intr_handler(int irq, void *dev_id)
 		}
 	}
 	/* Always clear and re-arm the fast-path EQ */
-	lpfc_sli4_eq_release(eq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_eq_release(eq, LPFC_QUEUE_REARM);
 	return IRQ_HANDLED;
 }
 
@@ -13739,7 +13871,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 
 	if (lpfc_fcp_look_ahead) {
 		if (atomic_dec_and_test(&hba_eq_hdl->hba_eq_in_use))
-			lpfc_sli4_eq_clr_intr(fpeq);
+			phba->sli4_hba.sli4_eq_clr_intr(fpeq);
 		else {
 			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 			return IRQ_NONE;
@@ -13778,7 +13910,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		fpeq->EQ_max_eqe = ecount;
 
 	/* Always clear and re-arm the fast-path EQ */
-	lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
 
 	if (unlikely(ecount == 0)) {
 		fpeq->EQ_no_entry++;
@@ -14824,6 +14956,9 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	void __iomem *bar_memmap_p;
 	uint32_t db_offset;
 	uint16_t pci_barset;
+	uint8_t dpp_barset;
+	uint32_t dpp_offset;
+	uint8_t wq_create_version;
 
 	/* sanity check on queue memory */
 	if (!wq || !cq)
@@ -14850,38 +14985,12 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	bf_set(lpfc_mbox_hdr_version, &shdr->request,
 	       phba->sli4_hba.pc_sli4_params.wqv);
 
-	switch (phba->sli4_hba.pc_sli4_params.wqv) {
-	case LPFC_Q_CREATE_VERSION_0:
-		switch (wq->entry_size) {
-		default:
-		case 64:
-			/* Nothing to do, version 0 ONLY supports 64 byte */
-			page = wq_create->u.request.page;
-			break;
-		case 128:
-			if (!(phba->sli4_hba.pc_sli4_params.wqsize &
-			    LPFC_WQ_SZ128_SUPPORT)) {
-				status = -ERANGE;
-				goto out;
-			}
-			/* If we get here the HBA MUST also support V1 and
-			 * we MUST use it
-			 */
-			bf_set(lpfc_mbox_hdr_version, &shdr->request,
-			       LPFC_Q_CREATE_VERSION_1);
+	if (phba->sli4_hba.pc_sli4_params.wqsize & LPFC_WQ_SZ128_SUPPORT)
+		wq_create_version = LPFC_Q_CREATE_VERSION_1;
+	else
+		wq_create_version = LPFC_Q_CREATE_VERSION_0;
 
-			bf_set(lpfc_mbx_wq_create_wqe_count,
-			       &wq_create->u.request_1, wq->entry_count);
-			bf_set(lpfc_mbx_wq_create_wqe_size,
-			       &wq_create->u.request_1,
-			       LPFC_WQ_WQE_SIZE_128);
-			bf_set(lpfc_mbx_wq_create_page_size,
-			       &wq_create->u.request_1,
-			       LPFC_WQ_PAGE_SIZE_4096);
-			page = wq_create->u.request_1.page;
-			break;
-		}
-		break;
+	switch (wq_create_version) {
 	case LPFC_Q_CREATE_VERSION_1:
 		bf_set(lpfc_mbx_wq_create_wqe_count, &wq_create->u.request_1,
 		       wq->entry_count);
@@ -14896,24 +15005,23 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 			       LPFC_WQ_WQE_SIZE_64);
 			break;
 		case 128:
-			if (!(phba->sli4_hba.pc_sli4_params.wqsize &
-				LPFC_WQ_SZ128_SUPPORT)) {
-				status = -ERANGE;
-				goto out;
-			}
 			bf_set(lpfc_mbx_wq_create_wqe_size,
 			       &wq_create->u.request_1,
 			       LPFC_WQ_WQE_SIZE_128);
 			break;
 		}
+		/* Request DPP by default */
+		bf_set(lpfc_mbx_wq_create_dpp_req,
+		       &wq_create->u.request_1,
+		       1);
 		bf_set(lpfc_mbx_wq_create_page_size,
 		       &wq_create->u.request_1,
 		       LPFC_WQ_PAGE_SIZE_4096);
 		page = wq_create->u.request_1.page;
 		break;
 	default:
-		status = -ERANGE;
-		goto out;
+		page = wq_create->u.request.page;
+		break;
 	}
 
 	list_for_each_entry(dmabuf, &wq->page_list, list) {
@@ -14937,52 +15045,104 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 		status = -ENXIO;
 		goto out;
 	}
-	wq->queue_id = bf_get(lpfc_mbx_wq_create_q_id, &wq_create->u.response);
+
+	if (wq_create_version == LPFC_Q_CREATE_VERSION_0)
+		wq->queue_id = bf_get(lpfc_mbx_wq_create_q_id,
+					&wq_create->u.response);
+	else
+		wq->queue_id = bf_get(lpfc_mbx_wq_create_v1_q_id,
+					&wq_create->u.response_1);
+
 	if (wq->queue_id == 0xFFFF) {
 		status = -ENXIO;
 		goto out;
 	}
-	if (phba->sli4_hba.fw_func_mode & LPFC_DUA_MODE) {
-		wq->db_format = bf_get(lpfc_mbx_wq_create_db_format,
-				       &wq_create->u.response);
-		if ((wq->db_format != LPFC_DB_LIST_FORMAT) &&
-		    (wq->db_format != LPFC_DB_RING_FORMAT)) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"3265 WQ[%d] doorbell format not "
-					"supported: x%x\n", wq->queue_id,
-					wq->db_format);
-			status = -EINVAL;
-			goto out;
-		}
-		pci_barset = bf_get(lpfc_mbx_wq_create_bar_set,
-				    &wq_create->u.response);
-		bar_memmap_p = lpfc_dual_chute_pci_bar_map(phba, pci_barset);
-		if (!bar_memmap_p) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"3263 WQ[%d] failed to memmap pci "
-					"barset:x%x\n", wq->queue_id,
-					pci_barset);
-			status = -ENOMEM;
-			goto out;
-		}
-		db_offset = wq_create->u.response.doorbell_offset;
-		if ((db_offset != LPFC_ULP0_WQ_DOORBELL) &&
-		    (db_offset != LPFC_ULP1_WQ_DOORBELL)) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"3252 WQ[%d] doorbell offset not "
-					"supported: x%x\n", wq->queue_id,
-					db_offset);
-			status = -EINVAL;
-			goto out;
+
+	wq->db_format = LPFC_DB_LIST_FORMAT;
+	if (wq_create_version == LPFC_Q_CREATE_VERSION_0) {
+		if (phba->sli4_hba.fw_func_mode & LPFC_DUA_MODE) {
+			wq->db_format = bf_get(lpfc_mbx_wq_create_db_format,
+					       &wq_create->u.response);
+			if (wq->db_format != LPFC_DB_LIST_FORMAT &&
+			    wq->db_format != LPFC_DB_RING_FORMAT) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"3265 WQ[%d] doorbell format "
+						"not supported: x%x\n",
+						wq->queue_id, wq->db_format);
+				status = -EINVAL;
+				goto out;
+			}
+			pci_barset = bf_get(lpfc_mbx_wq_create_bar_set,
+					    &wq_create->u.response);
+			bar_memmap_p = lpfc_dual_chute_pci_bar_map(phba,
+								   pci_barset);
+			if (!bar_memmap_p) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"3263 WQ[%d] failed to memmap "
+						"pci barset:x%x\n",
+						wq->queue_id, pci_barset);
+				status = -ENOMEM;
+				goto out;
+			}
+			db_offset = wq_create->u.response.doorbell_offset;
+			if (db_offset != LPFC_ULP0_WQ_DOORBELL &&
+			    db_offset != LPFC_ULP1_WQ_DOORBELL) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"3252 WQ[%d] doorbell offset "
+						"not supported: x%x\n",
+						wq->queue_id, db_offset);
+				status = -EINVAL;
+				goto out;
+			}
+			wq->db_regaddr = bar_memmap_p + db_offset;
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"3264 WQ[%d]: barset:x%x, offset:x%x, "
+					"format:x%x\n", wq->queue_id,
+					pci_barset, db_offset, wq->db_format);
 		}
-		wq->db_regaddr = bar_memmap_p + db_offset;
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3264 WQ[%d]: barset:x%x, offset:x%x, "
-				"format:x%x\n", wq->queue_id, pci_barset,
-				db_offset, wq->db_format);
 	} else {
-		wq->db_format = LPFC_DB_LIST_FORMAT;
-		wq->db_regaddr = phba->sli4_hba.WQDBregaddr;
+		/* Check if DPP was honored by the firmware */
+		wq->dpp_enable = bf_get(lpfc_mbx_wq_create_dpp_rsp,
+				    &wq_create->u.response_1);
+		if (wq->dpp_enable) {
+			pci_barset = bf_get(lpfc_mbx_wq_create_v1_bar_set,
+					    &wq_create->u.response_1);
+			bar_memmap_p = lpfc_dual_chute_pci_bar_map(phba,
+								   pci_barset);
+			if (!bar_memmap_p) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"3267 WQ[%d] failed to memmap "
+						"pci barset:x%x\n",
+						wq->queue_id, pci_barset);
+				status = -ENOMEM;
+				goto out;
+			}
+			db_offset = wq_create->u.response_1.doorbell_offset;
+			wq->db_regaddr = bar_memmap_p + db_offset;
+			wq->dpp_id = bf_get(lpfc_mbx_wq_create_dpp_id,
+					    &wq_create->u.response_1);
+			dpp_barset = bf_get(lpfc_mbx_wq_create_dpp_bar,
+					    &wq_create->u.response_1);
+			bar_memmap_p = lpfc_dual_chute_pci_bar_map(phba,
+								   dpp_barset);
+			if (!bar_memmap_p) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"3268 WQ[%d] failed to memmap "
+						"pci barset:x%x\n",
+						wq->queue_id, dpp_barset);
+				status = -ENOMEM;
+				goto out;
+			}
+			dpp_offset = wq_create->u.response_1.dpp_offset;
+			wq->dpp_regaddr = bar_memmap_p + dpp_offset;
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"3271 WQ[%d]: barset:x%x, offset:x%x, "
+					"dpp_id:x%x dpp_barset:x%x dpp_offset:x%x\n",
+					wq->queue_id, pci_barset, db_offset,
+					wq->dpp_id, dpp_barset, dpp_offset);
+		} else {
+			wq->db_regaddr = phba->sli4_hba.WQDBregaddr;
+		}
 	}
 	wq->pring = kzalloc(sizeof(struct lpfc_sli_ring), GFP_KERNEL);
 	if (wq->pring == NULL) {
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 60200385fe00..9efc08aa0d58 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -174,6 +174,10 @@ struct lpfc_queue {
 #define LPFC_DB_RING_FORMAT	0x01
 #define LPFC_DB_LIST_FORMAT	0x02
 	void __iomem *db_regaddr;
+	uint16_t dpp_enable;
+	uint16_t dpp_id;
+	void __iomem *dpp_regaddr;
+
 	/* For q stats */
 	uint32_t q_cnt_1;
 	uint32_t q_cnt_2;
@@ -510,11 +514,17 @@ struct lpfc_vector_map_info {
 /* SLI4 HBA data structure entries */
 struct lpfc_sli4_hba {
 	void __iomem *conf_regs_memmap_p; /* Kernel memory mapped address for
-					     PCI BAR0, config space registers */
+					   * config space registers
+					   */
 	void __iomem *ctrl_regs_memmap_p; /* Kernel memory mapped address for
-					     PCI BAR1, control registers */
+					   * control registers
+					   */
 	void __iomem *drbl_regs_memmap_p; /* Kernel memory mapped address for
-					     PCI BAR2, doorbell registers */
+					   * doorbell registers
+					   */
+	void __iomem *dpp_regs_memmap_p;  /* Kernel memory mapped address for
+					   * dpp registers
+					   */
 	union {
 		struct {
 			/* IF Type 0, BAR 0 PCI cfg space reg mem map */
@@ -555,7 +565,8 @@ struct lpfc_sli4_hba {
 	/* IF type 0, BAR 0 and if type 2, BAR 0 doorbell register memory map */
 	void __iomem *RQDBregaddr;	/* RQ_DOORBELL register */
 	void __iomem *WQDBregaddr;	/* WQ_DOORBELL register */
-	void __iomem *EQCQDBregaddr;	/* EQCQ_DOORBELL register */
+	void __iomem *CQDBregaddr;	/* CQ_DOORBELL register */
+	void __iomem *EQDBregaddr;	/* EQ_DOORBELL register */
 	void __iomem *MQDBregaddr;	/* MQ_DOORBELL register */
 	void __iomem *BMBXregaddr;	/* BootStrap MBX register */
 
@@ -568,6 +579,10 @@ struct lpfc_sli4_hba {
 	struct lpfc_bbscn_params bbscn_params;
 	struct lpfc_hba_eq_hdl *hba_eq_hdl; /* HBA per-WQ handle */
 
+	void (*sli4_eq_clr_intr)(struct lpfc_queue *);
+	uint32_t (*sli4_eq_release)(struct lpfc_queue *, bool);
+	uint32_t (*sli4_cq_release)(struct lpfc_queue *, bool);
+
 	/* Pointers to the constructed SLI4 queues */
 	struct lpfc_queue **hba_eq;  /* Event queues for HBA */
 	struct lpfc_queue **fcp_cq;  /* Fast-path FCP compl queue */
@@ -836,8 +851,12 @@ void lpfc_sli_remove_dflt_fcf(struct lpfc_hba *);
 int lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *);
 int lpfc_sli4_get_iocb_cnt(struct lpfc_hba *phba);
 int lpfc_sli4_init_vpi(struct lpfc_vport *);
+inline void lpfc_sli4_eq_clr_intr(struct lpfc_queue *);
 uint32_t lpfc_sli4_cq_release(struct lpfc_queue *, bool);
 uint32_t lpfc_sli4_eq_release(struct lpfc_queue *, bool);
+inline void lpfc_sli4_if6_eq_clr_intr(struct lpfc_queue *);
+uint32_t lpfc_sli4_if6_cq_release(struct lpfc_queue *q, bool arm);
+uint32_t lpfc_sli4_if6_eq_release(struct lpfc_queue *q, bool arm);
 void lpfc_sli4_fcfi_unreg(struct lpfc_hba *, uint16_t);
 int lpfc_sli4_fcf_scan_read_fcf_rec(struct lpfc_hba *, uint16_t);
 int lpfc_sli4_fcf_rr_read_fcf_rec(struct lpfc_hba *, uint16_t);
-- 
2.13.1
