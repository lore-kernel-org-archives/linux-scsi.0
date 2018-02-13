From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 02/13] lpfc: Rework sli4 doorbell infrastructure
Date: Tue, 13 Feb 2018 11:34:46 -0800
Message-ID: <20180213193457.21206-3-jsmart2021@gmail.com>
References: <20180213193457.21206-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:42768 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965611AbeBMTff (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 14:35:35 -0500
Received: by mail-qt0-f196.google.com with SMTP id l9so4692826qtj.9
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2018 11:35:35 -0800 (PST)
In-Reply-To: <20180213193457.21206-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Up until now, all SLI-4 devices had the same doorbells at the same
bar locations. With newer hardware, there are now independent EQ and
CQ doorbells and the bar locations differ.

Prepare the code for new hardware by separating the eq/cq doorbell into
separate components. The components can be set based on if_type.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 20 ++++++++++++++------
 drivers/scsi/lpfc/lpfc_debugfs.h | 11 ++++++-----
 drivers/scsi/lpfc/lpfc_init.c    |  9 ++++++---
 drivers/scsi/lpfc/lpfc_sli.c     |  8 ++++----
 drivers/scsi/lpfc/lpfc_sli4.h    |  3 ++-
 5 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 17ea3bb04266..308303d501cf 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3944,10 +3944,15 @@ lpfc_idiag_drbacc_read_reg(struct lpfc_hba *phba, char *pbuffer,
 		return 0;
 
 	switch (drbregid) {
-	case LPFC_DRB_EQCQ:
-		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
-				"EQCQ-DRB-REG: 0x%08x\n",
-				readl(phba->sli4_hba.EQCQDBregaddr));
+	case LPFC_DRB_EQ:
+		len += snprintf(pbuffer + len, LPFC_DRB_ACC_BUF_SIZE-len,
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
@@ -4086,8 +4091,11 @@ lpfc_idiag_drbacc_write(struct file *file, const char __user *buf,
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
index c4edd87bfc65..12fbf498a7ce 100644
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
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e24dca2b3f2f..b2cf8eb99008 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7430,8 +7430,9 @@ lpfc_sli4_bar0_register_memmap(struct lpfc_hba *phba, uint32_t if_type)
 		phba->sli4_hba.WQDBregaddr =
 			phba->sli4_hba.conf_regs_memmap_p +
 						LPFC_ULP0_WQ_DOORBELL;
-		phba->sli4_hba.EQCQDBregaddr =
+		phba->sli4_hba.CQDBregaddr =
 			phba->sli4_hba.conf_regs_memmap_p + LPFC_EQCQ_DOORBELL;
+		phba->sli4_hba.EQDBregaddr = phba->sli4_hba.CQDBregaddr;
 		phba->sli4_hba.MQDBregaddr =
 			phba->sli4_hba.conf_regs_memmap_p + LPFC_MQ_DOORBELL;
 		phba->sli4_hba.BMBXregaddr =
@@ -7488,8 +7489,10 @@ lpfc_sli4_bar2_register_memmap(struct lpfc_hba *phba, uint32_t vf)
 	phba->sli4_hba.WQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
 				vf * LPFC_VFR_PAGE_SIZE +
 					LPFC_ULP0_WQ_DOORBELL);
-	phba->sli4_hba.EQCQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
-				vf * LPFC_VFR_PAGE_SIZE + LPFC_EQCQ_DOORBELL);
+	phba->sli4_hba.CQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
+				vf * LPFC_VFR_PAGE_SIZE +
+					LPFC_EQCQ_DOORBELL);
+	phba->sli4_hba.EQDBregaddr = phba->sli4_hba.CQDBregaddr;
 	phba->sli4_hba.MQDBregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
 				vf * LPFC_VFR_PAGE_SIZE + LPFC_MQ_DOORBELL);
 	phba->sli4_hba.BMBXregaddr = (phba->sli4_hba.drbl_regs_memmap_p +
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f91caae6489a..f4db7d486431 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -310,7 +310,7 @@ lpfc_sli4_eq_clr_intr(struct lpfc_queue *q)
 	bf_set(lpfc_eqcq_doorbell_eqid_hi, &doorbell,
 		(q->queue_id >> LPFC_EQID_HI_FIELD_SHIFT));
 	bf_set(lpfc_eqcq_doorbell_eqid_lo, &doorbell, q->queue_id);
-	writel(doorbell.word0, q->phba->sli4_hba.EQCQDBregaddr);
+	writel(doorbell.word0, q->phba->sli4_hba.EQDBregaddr);
 }
 
 /**
@@ -360,10 +360,10 @@ lpfc_sli4_eq_release(struct lpfc_queue *q, bool arm)
 	bf_set(lpfc_eqcq_doorbell_eqid_hi, &doorbell,
 			(q->queue_id >> LPFC_EQID_HI_FIELD_SHIFT));
 	bf_set(lpfc_eqcq_doorbell_eqid_lo, &doorbell, q->queue_id);
-	writel(doorbell.word0, q->phba->sli4_hba.EQCQDBregaddr);
+	writel(doorbell.word0, q->phba->sli4_hba.EQDBregaddr);
 	/* PCI read to flush PCI pipeline on re-arming for INTx mode */
 	if ((q->phba->intr_type == INTx) && (arm == LPFC_QUEUE_REARM))
-		readl(q->phba->sli4_hba.EQCQDBregaddr);
+		readl(q->phba->sli4_hba.EQDBregaddr);
 	return released;
 }
 
@@ -453,7 +453,7 @@ lpfc_sli4_cq_release(struct lpfc_queue *q, bool arm)
 	bf_set(lpfc_eqcq_doorbell_cqid_hi, &doorbell,
 			(q->queue_id >> LPFC_CQID_HI_FIELD_SHIFT));
 	bf_set(lpfc_eqcq_doorbell_cqid_lo, &doorbell, q->queue_id);
-	writel(doorbell.word0, q->phba->sli4_hba.EQCQDBregaddr);
+	writel(doorbell.word0, q->phba->sli4_hba.CQDBregaddr);
 	return released;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 0c0cbe296fed..e2f06c92c4dd 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -569,7 +569,8 @@ struct lpfc_sli4_hba {
 	/* IF type 0, BAR 0 and if type 2, BAR 0 doorbell register memory map */
 	void __iomem *RQDBregaddr;	/* RQ_DOORBELL register */
 	void __iomem *WQDBregaddr;	/* WQ_DOORBELL register */
-	void __iomem *EQCQDBregaddr;	/* EQCQ_DOORBELL register */
+	void __iomem *CQDBregaddr;	/* CQ_DOORBELL register */
+	void __iomem *EQDBregaddr;	/* EQ_DOORBELL register */
 	void __iomem *MQDBregaddr;	/* MQ_DOORBELL register */
 	void __iomem *BMBXregaddr;	/* BootStrap MBX register */
 
-- 
2.13.1
