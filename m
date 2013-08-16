From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/4] qla4xxx: Added support for ISP8042
Date: Fri, 16 Aug 2013 07:03:02 -0400
Message-ID: <1376650985-11416-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1376650985-11416-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:41438 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019Ab3HPMAI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Aug 2013 08:00:08 -0400
In-Reply-To: <1376650985-11416-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_83xx.c |  6 ++---
 drivers/scsi/qla4xxx/ql4_attr.c |  2 +-
 drivers/scsi/qla4xxx/ql4_dbg.c  | 13 ++++-----
 drivers/scsi/qla4xxx/ql4_def.h  | 14 ++++++++--
 drivers/scsi/qla4xxx/ql4_init.c |  4 +--
 drivers/scsi/qla4xxx/ql4_isr.c  | 29 ++++++++++----------
 drivers/scsi/qla4xxx/ql4_mbx.c  |  4 +--
 drivers/scsi/qla4xxx/ql4_nx.c   | 60 ++++++++++++++++++++---------------------
 drivers/scsi/qla4xxx/ql4_os.c   | 47 +++++++++++++++++++-------------
 9 files changed, 100 insertions(+), 79 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index d607eb8..d5335b7 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -1473,9 +1473,9 @@ int qla4_83xx_isp_reset(struct scsi_qla_host *ha)
 				  __func__));
 	}
 
-	/* For ISP8324, Reset owner is NIC, iSCSI or FCOE based on priority
-	 * and which drivers are present. Unlike ISP8022, the function setting
-	 * NEED_RESET, may not be the Reset owner. */
+	/* For ISP8324 and ISP8042, Reset owner is NIC, iSCSI or FCOE based on
+	 * priority and which drivers are present. Unlike ISP8022, the function
+	 * setting NEED_RESET, may not be the Reset owner. */
 	if (qla4_83xx_can_perform_reset(ha))
 		set_bit(AF_8XXX_RST_OWNER, &ha->flags);
 
diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
index 687c07f..b015ee4 100644
--- a/drivers/scsi/qla4xxx/ql4_attr.c
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -83,7 +83,7 @@ qla4_8xxx_sysfs_write_fw_dump(struct file *filep, struct kobject *kobj,
 			qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DEV_STATE,
 					    QLA8XXX_DEV_NEED_RESET);
 			if (is_qla8022(ha) ||
-			    (is_qla8032(ha) &&
+			    ((is_qla8032(ha) || is_qla8042(ha)) &&
 			     qla4_83xx_can_perform_reset(ha))) {
 				set_bit(AF_8XXX_RST_OWNER, &ha->flags);
 				set_bit(AF_FW_RECOVERY, &ha->flags);
diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
index 77b7c59..5649e9e 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.c
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -141,21 +141,22 @@ void qla4_8xxx_dump_peg_reg(struct scsi_qla_host *ha)
 
 	if (is_qla8022(ha)) {
 		ql4_printk(KERN_INFO, ha,
-			   "scsi(%ld): %s, ISP8022 Dumping hw/fw registers:\n"
+			   "scsi(%ld): %s, ISP%04x Dumping hw/fw registers:\n"
 			   " PEG_HALT_STATUS1: 0x%x, PEG_HALT_STATUS2: 0x%x,\n"
 			   " PEG_NET_0_PC: 0x%x, PEG_NET_1_PC: 0x%x,\n"
 			   " PEG_NET_2_PC: 0x%x, PEG_NET_3_PC: 0x%x,\n"
-			   " PEG_NET_4_PC: 0x%x\n", ha->host_no,
-			   __func__, halt_status1, halt_status2,
+			   " PEG_NET_4_PC: 0x%x\n", ha->host_no, __func__,
+			   ha->pdev->device, halt_status1, halt_status2,
 			   qla4_82xx_rd_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x3c),
 			   qla4_82xx_rd_32(ha, QLA82XX_CRB_PEG_NET_1 + 0x3c),
 			   qla4_82xx_rd_32(ha, QLA82XX_CRB_PEG_NET_2 + 0x3c),
 			   qla4_82xx_rd_32(ha, QLA82XX_CRB_PEG_NET_3 + 0x3c),
 			   qla4_82xx_rd_32(ha, QLA82XX_CRB_PEG_NET_4 + 0x3c));
-	} else if (is_qla8032(ha)) {
+	} else if (is_qla8032(ha) || is_qla8042(ha)) {
 		ql4_printk(KERN_INFO, ha,
-			   "scsi(%ld): %s, ISP8324 Dumping hw/fw registers:\n"
+			   "scsi(%ld): %s, ISP%04x Dumping hw/fw registers:\n"
 			   " PEG_HALT_STATUS1: 0x%x, PEG_HALT_STATUS2: 0x%x,\n",
-			   ha->host_no, __func__, halt_status1, halt_status2);
+			   ha->host_no, __func__, ha->pdev->device,
+			   halt_status1, halt_status2);
 	}
 }
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index b0a0e93..bd01af5 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -64,6 +64,10 @@
 #define PCI_DEVICE_ID_QLOGIC_ISP8324	0x8032
 #endif
 
+#ifndef PCI_DEVICE_ID_QLOGIC_ISP8042
+#define PCI_DEVICE_ID_QLOGIC_ISP8042	0x8042
+#endif
+
 #define ISP4XXX_PCI_FN_1	0x1
 #define ISP4XXX_PCI_FN_2	0x3
 
@@ -778,7 +782,8 @@ struct scsi_qla_host {
 	uint32_t *reg_tbl;
 	struct qla4_83xx_reset_template reset_tmplt;
 	struct device_reg_83xx  __iomem *qla4_83xx_reg; /* Base I/O address
-							   for ISP8324 */
+							   for ISP8324 and
+							   and ISP8042 */
 	uint32_t pf_bit;
 	struct qla4_83xx_idc_information idc_info;
 };
@@ -848,9 +853,14 @@ static inline int is_qla8032(struct scsi_qla_host *ha)
 	return ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8324;
 }
 
+static inline int is_qla8042(struct scsi_qla_host *ha)
+{
+	return ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8042;
+}
+
 static inline int is_qla80XX(struct scsi_qla_host *ha)
 {
-	return is_qla8022(ha) || is_qla8032(ha);
+	return is_qla8022(ha) || is_qla8032(ha) || is_qla8042(ha);
 }
 
 static inline int is_aer_supported(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 8fc8548..222b91a 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -107,7 +107,7 @@ int qla4xxx_init_rings(struct scsi_qla_host *ha)
 		    (unsigned long  __iomem *)&ha->qla4_82xx_reg->rsp_q_in);
 		writel(0,
 		    (unsigned long  __iomem *)&ha->qla4_82xx_reg->rsp_q_out);
-	} else if (is_qla8032(ha)) {
+	} else if (is_qla8032(ha) || is_qla8042(ha)) {
 		writel(0,
 		       (unsigned long __iomem *)&ha->qla4_83xx_reg->req_q_in);
 		writel(0,
@@ -940,7 +940,7 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha, int is_reset)
 	 * while switching from polling to interrupt mode. IOCB interrupts are
 	 * enabled via isp_ops->enable_intrs.
 	 */
-	if (is_qla8032(ha))
+	if (is_qla8032(ha) || is_qla8042(ha))
 		qla4_83xx_enable_mbox_intrs(ha);
 
 	if (qla4xxx_about_firmware(ha) == QLA_ERROR)
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 482287f..fbd415d 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -588,7 +588,7 @@ static int qla4_83xx_loopback_in_progress(struct scsi_qla_host *ha)
 {
 	int rval = 1;
 
-	if (is_qla8032(ha)) {
+	if (is_qla8032(ha) || is_qla8042(ha)) {
 		if ((ha->idc_info.info2 & ENABLE_INTERNAL_LOOPBACK) ||
 		    (ha->idc_info.info2 & ENABLE_EXTERNAL_LOOPBACK)) {
 			DEBUG2(ql4_printk(KERN_INFO, ha,
@@ -621,7 +621,7 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 	uint32_t mbox_sts[MBOX_AEN_REG_COUNT];
 	__le32 __iomem *mailbox_out;
 
-	if (is_qla8032(ha))
+	if (is_qla8032(ha) || is_qla8042(ha))
 		mailbox_out = &ha->qla4_83xx_reg->mailbox_out[0];
 	else if (is_qla8022(ha))
 		mailbox_out = &ha->qla4_82xx_reg->mailbox_out[0];
@@ -665,7 +665,8 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			qla4xxx_dump_registers(ha);
 
 			if ((is_qla8022(ha) && ql4xdontresethba) ||
-			    (is_qla8032(ha) && qla4_83xx_idc_dontreset(ha))) {
+			    ((is_qla8032(ha) || is_qla8042(ha)) &&
+			     qla4_83xx_idc_dontreset(ha))) {
 				DEBUG2(printk("scsi%ld: %s:Don't Reset HBA\n",
 				    ha->host_no, __func__));
 			} else {
@@ -836,7 +837,7 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 		case MBOX_ASTS_IDC_REQUEST_NOTIFICATION:
 		{
 			uint32_t opcode;
-			if (is_qla8032(ha)) {
+			if (is_qla8032(ha) || is_qla8042(ha)) {
 				DEBUG2(ql4_printk(KERN_INFO, ha,
 						  "scsi%ld: AEN %04x, mbox_sts[1]=%08x, mbox_sts[2]=%08x, mbox_sts[3]=%08x, mbox_sts[4]=%08x\n",
 						  ha->host_no, mbox_sts[0],
@@ -858,7 +859,7 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 		}
 
 		case MBOX_ASTS_IDC_COMPLETE:
-			if (is_qla8032(ha)) {
+			if (is_qla8032(ha) || is_qla8042(ha)) {
 				DEBUG2(ql4_printk(KERN_INFO, ha,
 						  "scsi%ld: AEN %04x, mbox_sts[1]=%08x, mbox_sts[2]=%08x, mbox_sts[3]=%08x, mbox_sts[4]=%08x\n",
 						  ha->host_no, mbox_sts[0],
@@ -1297,7 +1298,7 @@ qla4_8xxx_default_intr_handler(int irq, void *dev_id)
 	uint32_t intr_status;
 	uint8_t reqs_count = 0;
 
-	if (is_qla8032(ha)) {
+	if (is_qla8032(ha) || is_qla8042(ha)) {
 		qla4_83xx_mailbox_intr_handler(irq, dev_id);
 	} else {
 		spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1334,7 +1335,7 @@ qla4_8xxx_msix_rsp_q(int irq, void *dev_id)
 	uint32_t ival = 0;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	if (is_qla8032(ha)) {
+	if (is_qla8032(ha) || is_qla8042(ha)) {
 		ival = readl(&ha->qla4_83xx_reg->iocb_int_mask);
 		if (ival == 0) {
 			ql4_printk(KERN_INFO, ha, "%s: It is a spurious iocb interrupt!\n",
@@ -1425,10 +1426,10 @@ int qla4xxx_request_irqs(struct scsi_qla_host *ha)
 		goto try_intx;
 
 	if (ql4xenablemsix == 2) {
-		/* Note: MSI Interrupts not supported for ISP8324 */
-		if (is_qla8032(ha)) {
-			ql4_printk(KERN_INFO, ha, "%s: MSI Interrupts not supported for ISP8324, Falling back-to INTx mode\n",
-				   __func__);
+		/* Note: MSI Interrupts not supported for ISP8324 and ISP8042 */
+		if (is_qla8032(ha) || is_qla8042(ha)) {
+			ql4_printk(KERN_INFO, ha, "%s: MSI Interrupts not supported for ISP%04x, Falling back-to INTx mode\n",
+				   __func__, ha->pdev->device);
 			goto try_intx;
 		}
 		goto try_msi;
@@ -1444,9 +1445,9 @@ int qla4xxx_request_irqs(struct scsi_qla_host *ha)
 		    "MSI-X: Enabled (0x%X).\n", ha->revision_id));
 		goto irq_attached;
 	} else {
-		if (is_qla8032(ha)) {
-			ql4_printk(KERN_INFO, ha, "%s: ISP8324: MSI-X: Falling back-to INTx mode. ret = %d\n",
-				   __func__, ret);
+		if (is_qla8032(ha) || is_qla8042(ha)) {
+			ql4_printk(KERN_INFO, ha, "%s: ISP%04x: MSI-X: Falling back-to INTx mode. ret = %d\n",
+				   __func__, ha->pdev->device, ret);
 			goto try_intx;
 		}
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 3c18b7f..e39895c 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -53,7 +53,7 @@ static int qla4xxx_is_intr_poll_mode(struct scsi_qla_host *ha)
 {
 	int rval = 1;
 
-	if (is_qla8032(ha)) {
+	if (is_qla8032(ha) || is_qla8042(ha)) {
 		if (test_bit(AF_IRQ_ATTACHED, &ha->flags) &&
 		    test_bit(AF_83XX_MBOX_INTR_ON, &ha->flags))
 			rval = 0;
@@ -224,7 +224,7 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 			qla4_82xx_wr_32(ha, QLA82XX_CRB_NIU + 0x98,
 					CRB_NIU_XG_PAUSE_CTL_P0 |
 					CRB_NIU_XG_PAUSE_CTL_P1);
-		} else if (is_qla8032(ha)) {
+		} else if (is_qla8032(ha) || is_qla8042(ha)) {
 			ql4_printk(KERN_INFO, ha, " %s: disabling pause transmit on port 0 & 1.\n",
 				   __func__);
 			qla4_83xx_disable_pause(ha);
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index eaf00c1..378282b 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1514,11 +1514,11 @@ qla4_8xxx_set_drv_active(struct scsi_qla_host *ha)
 	drv_active = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_ACTIVE);
 
 	/*
-	 * For ISP8324, drv_active register has 1 bit per function,
+	 * For ISP8324 and ISP8042, drv_active register has 1 bit per function,
 	 * shift 1 by func_num to set a bit for the function.
 	 * For ISP8022, drv_active has 4 bits per function
 	 */
-	if (is_qla8032(ha))
+	if (is_qla8032(ha) || is_qla8042(ha))
 		drv_active |= (1 << ha->func_num);
 	else
 		drv_active |= (1 << (ha->func_num * 4));
@@ -1536,11 +1536,11 @@ qla4_8xxx_clear_drv_active(struct scsi_qla_host *ha)
 	drv_active = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_ACTIVE);
 
 	/*
-	 * For ISP8324, drv_active register has 1 bit per function,
+	 * For ISP8324 and ISP8042, drv_active register has 1 bit per function,
 	 * shift 1 by func_num to set a bit for the function.
 	 * For ISP8022, drv_active has 4 bits per function
 	 */
-	if (is_qla8032(ha))
+	if (is_qla8032(ha) || is_qla8042(ha))
 		drv_active &= ~(1 << (ha->func_num));
 	else
 		drv_active &= ~(1 << (ha->func_num * 4));
@@ -1559,11 +1559,11 @@ inline int qla4_8xxx_need_reset(struct scsi_qla_host *ha)
 	drv_state = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_STATE);
 
 	/*
-	 * For ISP8324, drv_active register has 1 bit per function,
+	 * For ISP8324 and ISP8042, drv_active register has 1 bit per function,
 	 * shift 1 by func_num to set a bit for the function.
 	 * For ISP8022, drv_active has 4 bits per function
 	 */
-	if (is_qla8032(ha))
+	if (is_qla8032(ha) || is_qla8042(ha))
 		rval = drv_state & (1 << ha->func_num);
 	else
 		rval = drv_state & (1 << (ha->func_num * 4));
@@ -1581,11 +1581,11 @@ void qla4_8xxx_set_rst_ready(struct scsi_qla_host *ha)
 	drv_state = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_STATE);
 
 	/*
-	 * For ISP8324, drv_active register has 1 bit per function,
+	 * For ISP8324 and ISP8042, drv_active register has 1 bit per function,
 	 * shift 1 by func_num to set a bit for the function.
 	 * For ISP8022, drv_active has 4 bits per function
 	 */
-	if (is_qla8032(ha))
+	if (is_qla8032(ha) || is_qla8042(ha))
 		drv_state |= (1 << ha->func_num);
 	else
 		drv_state |= (1 << (ha->func_num * 4));
@@ -1602,11 +1602,11 @@ void qla4_8xxx_clear_rst_ready(struct scsi_qla_host *ha)
 	drv_state = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_STATE);
 
 	/*
-	 * For ISP8324, drv_active register has 1 bit per function,
+	 * For ISP8324 and ISP8042, drv_active register has 1 bit per function,
 	 * shift 1 by func_num to set a bit for the function.
 	 * For ISP8022, drv_active has 4 bits per function
 	 */
-	if (is_qla8032(ha))
+	if (is_qla8032(ha) || is_qla8042(ha))
 		drv_state &= ~(1 << ha->func_num);
 	else
 		drv_state &= ~(1 << (ha->func_num * 4));
@@ -1624,11 +1624,11 @@ qla4_8xxx_set_qsnt_ready(struct scsi_qla_host *ha)
 	qsnt_state = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_STATE);
 
 	/*
-	 * For ISP8324, drv_active register has 1 bit per function,
+	 * For ISP8324 and ISP8042, drv_active register has 1 bit per function,
 	 * shift 1 by func_num to set a bit for the function.
 	 * For ISP8022, drv_active has 4 bits per function.
 	 */
-	if (is_qla8032(ha))
+	if (is_qla8032(ha) || is_qla8042(ha))
 		qsnt_state |= (1 << ha->func_num);
 	else
 		qsnt_state |= (2 << (ha->func_num * 4));
@@ -2398,7 +2398,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 					(((uint8_t *)ha->fw_dump_tmplt_hdr) +
 					 tmplt_hdr->first_entry_offset);
 
-	if (is_qla8032(ha))
+	if (is_qla8032(ha) || is_qla8042(ha))
 		tmplt_hdr->saved_state_array[QLA83XX_SS_OCM_WNDREG_INDEX] =
 					tmplt_hdr->ocm_window_reg[ha->func_num];
 
@@ -2455,7 +2455,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 			if (is_qla8022(ha)) {
 				qla4_82xx_minidump_process_rdrom(ha, entry_hdr,
 								 &data_ptr);
-			} else if (is_qla8032(ha)) {
+			} else if (is_qla8032(ha) || is_qla8042(ha)) {
 				rval = qla4_83xx_minidump_process_rdrom(ha,
 								    entry_hdr,
 								    &data_ptr);
@@ -2496,7 +2496,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 							 &data_ptr);
 			break;
 		case QLA83XX_POLLRD:
-			if (!is_qla8032(ha)) {
+			if (is_qla8022(ha)) {
 				qla4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
 				break;
 			}
@@ -2506,7 +2506,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 				qla4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
 			break;
 		case QLA83XX_RDMUX2:
-			if (!is_qla8032(ha)) {
+			if (is_qla8022(ha)) {
 				qla4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
 				break;
 			}
@@ -2514,7 +2514,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 							&data_ptr);
 			break;
 		case QLA83XX_POLLRDMWR:
-			if (!is_qla8032(ha)) {
+			if (is_qla8022(ha)) {
 				qla4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
 				break;
 			}
@@ -2642,10 +2642,10 @@ dev_initialize:
 			    QLA8XXX_DEV_INITIALIZING);
 
 	/*
-	 * For ISP8324, if IDC_CTRL GRACEFUL_RESET_BIT1 is set, reset it after
-	 * device goes to INIT state.
+	 * For ISP8324 and ISP8042, if IDC_CTRL GRACEFUL_RESET_BIT1 is set,
+	 * reset it after device goes to INIT state.
 	 */
-	if (is_qla8032(ha)) {
+	if (is_qla8032(ha) || is_qla8042(ha)) {
 		idc_ctrl = qla4_83xx_rd_reg(ha, QLA83XX_IDC_DRV_CTRL);
 		if (idc_ctrl & GRACEFUL_RESET_BIT1) {
 			qla4_83xx_wr_reg(ha, QLA83XX_IDC_DRV_CTRL,
@@ -2846,7 +2846,7 @@ int qla4_8xxx_update_idc_reg(struct scsi_qla_host *ha)
 	 * If we are the first driver to load and
 	 * ql4xdontresethba is not set, clear IDC_CTRL BIT0.
 	 */
-	if (is_qla8032(ha)) {
+	if (is_qla8032(ha) || is_qla8042(ha)) {
 		drv_active = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_ACTIVE);
 		if ((drv_active == (1 << ha->func_num)) && !ql4xdontresethba)
 			qla4_83xx_clear_idc_dontreset(ha);
@@ -2854,7 +2854,7 @@ int qla4_8xxx_update_idc_reg(struct scsi_qla_host *ha)
 
 	if (is_qla8022(ha)) {
 		qla4_82xx_set_idc_ver(ha);
-	} else if (is_qla8032(ha)) {
+	} else if (is_qla8032(ha) || is_qla8042(ha)) {
 		rval = qla4_83xx_set_idc_ver(ha);
 		if (rval == QLA_ERROR)
 			qla4_8xxx_clear_drv_active(ha);
@@ -2922,11 +2922,11 @@ int qla4_8xxx_device_state_handler(struct scsi_qla_host *ha)
 			break;
 		case QLA8XXX_DEV_NEED_RESET:
 			/*
-			 * For ISP8324, if NEED_RESET is set by any driver,
-			 * it should be honored, irrespective of IDC_CTRL
-			 * DONTRESET_BIT0
+			 * For ISP8324 and ISP8042, if NEED_RESET is set by any
+			 * driver, it should be honored, irrespective of
+			 * IDC_CTRL DONTRESET_BIT0
 			 */
-			if (is_qla8032(ha)) {
+			if (is_qla8032(ha) || is_qla8042(ha)) {
 				qla4_83xx_need_reset_handler(ha);
 			} else if (is_qla8022(ha)) {
 				if (!ql4xdontresethba) {
@@ -2976,7 +2976,7 @@ int qla4_8xxx_load_risc(struct scsi_qla_host *ha)
 	int retval;
 
 	/* clear the interrupt */
-	if (is_qla8032(ha)) {
+	if (is_qla8032(ha) || is_qla8042(ha)) {
 		writel(0, &ha->qla4_83xx_reg->risc_intr);
 		readl(&ha->qla4_83xx_reg->risc_intr);
 	} else if (is_qla8022(ha)) {
@@ -3094,7 +3094,7 @@ qla4_8xxx_get_flt_info(struct scsi_qla_host *ha, uint32_t flt_addr)
 	if (is_qla8022(ha)) {
 		qla4_82xx_read_optrom_data(ha, (uint8_t *)ha->request_ring,
 					   flt_addr << 2, OPTROM_BURST_SIZE);
-	} else if (is_qla8032(ha)) {
+	} else if (is_qla8032(ha) || is_qla8042(ha)) {
 		status = qla4_83xx_flash_read_u32(ha, flt_addr << 2,
 						  (uint8_t *)ha->request_ring,
 						  0x400);
@@ -3326,7 +3326,7 @@ qla4_8xxx_get_flash_info(struct scsi_qla_host *ha)
 	if (is_qla8022(ha)) {
 		qla4_82xx_get_fdt_info(ha);
 		qla4_82xx_get_idc_param(ha);
-	} else if (is_qla8032(ha)) {
+	} else if (is_qla8032(ha) || is_qla8042(ha)) {
 		qla4_83xx_get_idc_param(ha);
 	}
 
@@ -3436,7 +3436,7 @@ int qla4_8xxx_get_sys_info(struct scsi_qla_host *ha)
 	}
 
 	/* Make sure we receive the minimum required data to cache internally */
-	if ((is_qla8032(ha) ? mbox_sts[3] : mbox_sts[4]) <
+	if (((is_qla8032(ha) || is_qla8042(ha)) ? mbox_sts[3] : mbox_sts[4]) <
 	    offsetof(struct mbx_sys_info, reserved)) {
 		DEBUG2(printk("scsi%ld: %s: GET_SYS_INFO data receive"
 		    " error (%x)\n", ha->host_no, __func__, mbox_sts[4]));
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6226df6..4f9651a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2745,7 +2745,7 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 		if (ha->nx_pcibase)
 			iounmap(
 			    (struct device_reg_82xx __iomem *)ha->nx_pcibase);
-	} else if (is_qla8032(ha)) {
+	} else if (is_qla8032(ha) || is_qla8042(ha)) {
 		if (ha->nx_pcibase)
 			iounmap(
 			    (struct device_reg_83xx __iomem *)ha->nx_pcibase);
@@ -2939,7 +2939,7 @@ static void qla4_8xxx_process_fw_error(struct scsi_qla_host *ha)
 				   __func__);
 		if (halt_status & HALT_STATUS_UNRECOVERABLE)
 			halt_status_unrecoverable = 1;
-	} else if (is_qla8032(ha)) {
+	} else if (is_qla8032(ha) || is_qla8042(ha)) {
 		if (halt_status & QLA83XX_HALT_STATUS_FW_RESET)
 			ql4_printk(KERN_ERR, ha, "%s: Firmware error detected device is being reset\n",
 				   __func__);
@@ -2994,7 +2994,7 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 			ql4_printk(KERN_INFO, ha, "%s: HW State: NEED RESET!\n",
 				   __func__);
 
-			if (is_qla8032(ha)) {
+			if (is_qla8032(ha) || is_qla8042(ha)) {
 				idc_ctrl = qla4_83xx_rd_reg(ha,
 							QLA83XX_IDC_DRV_CTRL);
 				if (!(idc_ctrl & GRACEFUL_RESET_BIT1)) {
@@ -3005,7 +3005,7 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 				}
 			}
 
-			if (is_qla8032(ha) ||
+			if ((is_qla8032(ha) || is_qla8042(ha)) ||
 			    (is_qla8022(ha) && !ql4xdontresethba)) {
 				set_bit(DPC_RESET_HA, &ha->dpc_flags);
 				qla4xxx_wake_dpc(ha);
@@ -3389,7 +3389,7 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 
 	set_bit(DPC_RESET_ACTIVE, &ha->dpc_flags);
 
-	if (is_qla8032(ha) &&
+	if ((is_qla8032(ha) || is_qla8042(ha)) &&
 	    !test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags)) {
 		ql4_printk(KERN_INFO, ha, "%s: disabling pause transmit on port 0 & 1.\n",
 			   __func__);
@@ -3848,7 +3848,7 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 
 	if (is_qla80XX(ha)) {
 		if (test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags)) {
-			if (is_qla8032(ha)) {
+			if (is_qla8032(ha) || is_qla8042(ha)) {
 				ql4_printk(KERN_INFO, ha, "%s: disabling pause transmit on port 0 & 1.\n",
 					   __func__);
 				/* disable pause frame for ISP83xx */
@@ -3876,7 +3876,8 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 	    test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))) {
 		if ((is_qla8022(ha) && ql4xdontresethba) ||
-		    (is_qla8032(ha) && qla4_83xx_idc_dontreset(ha))) {
+		    ((is_qla8032(ha) || is_qla8042(ha)) &&
+		     qla4_83xx_idc_dontreset(ha))) {
 			DEBUG2(printk("scsi%ld: %s: Don't Reset HBA\n",
 			    ha->host_no, __func__));
 			clear_bit(DPC_RESET_HA, &ha->dpc_flags);
@@ -3968,7 +3969,7 @@ static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
 	} else if (is_qla8022(ha)) {
 		writel(0, &ha->qla4_82xx_reg->host_int);
 		readl(&ha->qla4_82xx_reg->host_int);
-	} else if (is_qla8032(ha)) {
+	} else if (is_qla8032(ha) || is_qla8042(ha)) {
 		writel(0, &ha->qla4_83xx_reg->risc_intr);
 		readl(&ha->qla4_83xx_reg->risc_intr);
 	}
@@ -4043,7 +4044,7 @@ int qla4_8xxx_iospace_config(struct scsi_qla_host *ha)
 				     (ha->pdev->devfn << 11));
 		ha->nx_db_wr_ptr = (ha->pdev->devfn == 4 ? QLA82XX_CAM_RAM_DB1 :
 				    QLA82XX_CAM_RAM_DB2);
-	} else if (is_qla8032(ha)) {
+	} else if (is_qla8032(ha) || is_qla8042(ha)) {
 		ha->qla4_83xx_reg = (struct device_reg_83xx __iomem *)
 				    ((uint8_t *)ha->nx_pcibase);
 	}
@@ -7033,7 +7034,7 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 			nx_legacy_intr->tgt_status_reg;
 		ha->nx_legacy_intr.tgt_mask_reg = nx_legacy_intr->tgt_mask_reg;
 		ha->nx_legacy_intr.pci_int_reg = nx_legacy_intr->pci_int_reg;
-	} else if (is_qla8032(ha)) {
+	} else if (is_qla8032(ha) || is_qla8042(ha)) {
 		ha->isp_ops = &qla4_83xx_isp_ops;
 		ha->reg_tbl = (uint32_t *)qla4_83xx_reg_tbl;
 	} else {
@@ -7104,7 +7105,7 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	if (is_qla80XX(ha))
 		qla4_8xxx_get_flash_info(ha);
 
-	if (is_qla8032(ha)) {
+	if (is_qla8032(ha) || is_qla8042(ha)) {
 		qla4_83xx_read_reset_template(ha);
 		/*
 		 * NOTE: If ql4dontresethba==1, set IDC_CTRL DONTRESET_BIT0.
@@ -7159,7 +7160,8 @@ skip_retry_init:
 		ql4_printk(KERN_WARNING, ha, "Failed to initialize adapter\n");
 
 		if ((is_qla8022(ha) && ql4xdontresethba) ||
-		    (is_qla8032(ha) && qla4_83xx_idc_dontreset(ha))) {
+		    ((is_qla8032(ha) || is_qla8042(ha)) &&
+		     qla4_83xx_idc_dontreset(ha))) {
 			/* Put the device in failed state. */
 			DEBUG2(printk(KERN_ERR "HW STATE: FAILED\n"));
 			ha->isp_ops->idc_lock(ha);
@@ -7768,16 +7770,16 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 
 	ha = to_qla_host(cmd->device->host);
 
-	if (is_qla8032(ha) && ql4xdontresethba)
+	if ((is_qla8032(ha) || is_qla8042(ha)) && ql4xdontresethba)
 		qla4_83xx_set_idc_dontreset(ha);
 
 	/*
-	 * For ISP8324, if IDC_CTRL DONTRESET_BIT0 is set by other
-	 * protocol drivers, we should not set device_state to
-	 * NEED_RESET
+	 * For ISP8324 and ISP8042, if IDC_CTRL DONTRESET_BIT0 is set by other
+	 * protocol drivers, we should not set device_state to NEED_RESET
 	 */
 	if (ql4xdontresethba ||
-	    (is_qla8032(ha) && qla4_83xx_idc_dontreset(ha))) {
+	    ((is_qla8032(ha) || is_qla8042(ha)) &&
+	     qla4_83xx_idc_dontreset(ha))) {
 		DEBUG2(printk("scsi%ld: %s: Don't Reset HBA\n",
 		     ha->host_no, __func__));
 
@@ -7902,9 +7904,10 @@ static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type)
 	}
 
 recover_adapter:
-	/* For ISP83XX set graceful reset bit in IDC_DRV_CTRL if
+	/* For ISP8324 and ISP8042 set graceful reset bit in IDC_DRV_CTRL if
 	 * reset is issued by application */
-	if (is_qla8032(ha) && test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
+	if ((is_qla8032(ha) || is_qla8042(ha)) &&
+	    test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
 		idc_ctrl = qla4_83xx_rd_reg(ha, QLA83XX_IDC_DRV_CTRL);
 		qla4_83xx_wr_reg(ha, QLA83XX_IDC_DRV_CTRL,
 				 (idc_ctrl | GRACEFUL_RESET_BIT1));
@@ -8201,6 +8204,12 @@ static struct pci_device_id qla4xxx_pci_tbl[] = {
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP8042,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
 	{0, 0},
 };
 MODULE_DEVICE_TABLE(pci, qla4xxx_pci_tbl);
-- 
1.8.2.GIT

