From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 06/10] qla4xxx: qla4xxx: Move qla4_8xxx_ms_mem_write_128b to ql4_nx.c
Date: Mon, 24 Feb 2014 22:07:01 -0500
Message-ID: <1393297625-928-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:32062 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902AbaBYDpE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 22:45:04 -0500
In-Reply-To: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_83xx.c | 106 ----------------------------------------
 drivers/scsi/qla4xxx/ql4_nx.c   | 106 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+), 106 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index ffce016..556c152 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -249,112 +249,6 @@ void qla4_83xx_rom_lock_recovery(struct scsi_qla_host *ha)
 	qla4_83xx_flash_unlock(ha);
 }
 
-/**
- * qla4_8xxx_ms_mem_write_128b - Writes data to MS/off-chip memory
- * @ha: Pointer to adapter structure
- * @addr: Flash address to write to
- * @data: Data to be written
- * @count: word_count to be written
- *
- * Return: On success return QLA_SUCCESS
- *	   On error return QLA_ERROR
- **/
-int qla4_8xxx_ms_mem_write_128b(struct scsi_qla_host *ha, uint64_t addr,
-				uint32_t *data, uint32_t count)
-{
-	int i, j;
-	uint32_t agt_ctrl;
-	unsigned long flags;
-	int ret_val = QLA_SUCCESS;
-
-	/* Only 128-bit aligned access */
-	if (addr & 0xF) {
-		ret_val = QLA_ERROR;
-		goto exit_ms_mem_write;
-	}
-
-	write_lock_irqsave(&ha->hw_lock, flags);
-
-	/* Write address */
-	ret_val = ha->isp_ops->wr_reg_indirect(ha, MD_MIU_TEST_AGT_ADDR_HI, 0);
-	if (ret_val == QLA_ERROR) {
-		ql4_printk(KERN_ERR, ha, "%s: write to AGT_ADDR_HI failed\n",
-			   __func__);
-		goto exit_ms_mem_write_unlock;
-	}
-
-	for (i = 0; i < count; i++, addr += 16) {
-		if (!((QLA8XXX_ADDR_IN_RANGE(addr, QLA8XXX_ADDR_QDR_NET,
-					     QLA8XXX_ADDR_QDR_NET_MAX)) ||
-		      (QLA8XXX_ADDR_IN_RANGE(addr, QLA8XXX_ADDR_DDR_NET,
-					     QLA8XXX_ADDR_DDR_NET_MAX)))) {
-			ret_val = QLA_ERROR;
-			goto exit_ms_mem_write_unlock;
-		}
-
-		ret_val = ha->isp_ops->wr_reg_indirect(ha,
-						       MD_MIU_TEST_AGT_ADDR_LO,
-						       addr);
-		/* Write data */
-		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
-						      MD_MIU_TEST_AGT_WRDATA_LO,
-						      *data++);
-		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
-						      MD_MIU_TEST_AGT_WRDATA_HI,
-						      *data++);
-		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
-						     MD_MIU_TEST_AGT_WRDATA_ULO,
-						     *data++);
-		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
-						     MD_MIU_TEST_AGT_WRDATA_UHI,
-						     *data++);
-		if (ret_val == QLA_ERROR) {
-			ql4_printk(KERN_ERR, ha, "%s: write to AGT_WRDATA failed\n",
-				   __func__);
-			goto exit_ms_mem_write_unlock;
-		}
-
-		/* Check write status */
-		ret_val = ha->isp_ops->wr_reg_indirect(ha, MD_MIU_TEST_AGT_CTRL,
-						       MIU_TA_CTL_WRITE_ENABLE);
-		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
-							MD_MIU_TEST_AGT_CTRL,
-							MIU_TA_CTL_WRITE_START);
-		if (ret_val == QLA_ERROR) {
-			ql4_printk(KERN_ERR, ha, "%s: write to AGT_CTRL failed\n",
-				   __func__);
-			goto exit_ms_mem_write_unlock;
-		}
-
-		for (j = 0; j < MAX_CTL_CHECK; j++) {
-			ret_val = ha->isp_ops->rd_reg_indirect(ha,
-							  MD_MIU_TEST_AGT_CTRL,
-							  &agt_ctrl);
-			if (ret_val == QLA_ERROR) {
-				ql4_printk(KERN_ERR, ha, "%s: failed to read MD_MIU_TEST_AGT_CTRL\n",
-					   __func__);
-				goto exit_ms_mem_write_unlock;
-			}
-			if ((agt_ctrl & MIU_TA_CTL_BUSY) == 0)
-				break;
-		}
-
-		/* Status check failed */
-		if (j >= MAX_CTL_CHECK) {
-			printk_ratelimited(KERN_ERR "%s: MS memory write failed!\n",
-					   __func__);
-			ret_val = QLA_ERROR;
-			goto exit_ms_mem_write_unlock;
-		}
-	}
-
-exit_ms_mem_write_unlock:
-	write_unlock_irqrestore(&ha->hw_lock, flags);
-
-exit_ms_mem_write:
-	return ret_val;
-}
-
 #define INTENT_TO_RECOVER	0x01
 #define PROCEED_TO_RECOVER	0x02
 
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 6032bf6..8a56209 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1177,6 +1177,112 @@ qla4_82xx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
 	return 0;
 }
 
+/**
+ * qla4_8xxx_ms_mem_write_128b - Writes data to MS/off-chip memory
+ * @ha: Pointer to adapter structure
+ * @addr: Flash address to write to
+ * @data: Data to be written
+ * @count: word_count to be written
+ *
+ * Return: On success return QLA_SUCCESS
+ *         On error return QLA_ERROR
+ **/
+int qla4_8xxx_ms_mem_write_128b(struct scsi_qla_host *ha, uint64_t addr,
+				uint32_t *data, uint32_t count)
+{
+	int i, j;
+	uint32_t agt_ctrl;
+	unsigned long flags;
+	int ret_val = QLA_SUCCESS;
+
+	/* Only 128-bit aligned access */
+	if (addr & 0xF) {
+		ret_val = QLA_ERROR;
+		goto exit_ms_mem_write;
+	}
+
+	write_lock_irqsave(&ha->hw_lock, flags);
+
+	/* Write address */
+	ret_val = ha->isp_ops->wr_reg_indirect(ha, MD_MIU_TEST_AGT_ADDR_HI, 0);
+	if (ret_val == QLA_ERROR) {
+		ql4_printk(KERN_ERR, ha, "%s: write to AGT_ADDR_HI failed\n",
+			   __func__);
+		goto exit_ms_mem_write_unlock;
+	}
+
+	for (i = 0; i < count; i++, addr += 16) {
+		if (!((QLA8XXX_ADDR_IN_RANGE(addr, QLA8XXX_ADDR_QDR_NET,
+					     QLA8XXX_ADDR_QDR_NET_MAX)) ||
+		      (QLA8XXX_ADDR_IN_RANGE(addr, QLA8XXX_ADDR_DDR_NET,
+					     QLA8XXX_ADDR_DDR_NET_MAX)))) {
+			ret_val = QLA_ERROR;
+			goto exit_ms_mem_write_unlock;
+		}
+
+		ret_val = ha->isp_ops->wr_reg_indirect(ha,
+						       MD_MIU_TEST_AGT_ADDR_LO,
+						       addr);
+		/* Write data */
+		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
+						MD_MIU_TEST_AGT_WRDATA_LO,
+						*data++);
+		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
+						MD_MIU_TEST_AGT_WRDATA_HI,
+						*data++);
+		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
+						MD_MIU_TEST_AGT_WRDATA_ULO,
+						*data++);
+		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
+						MD_MIU_TEST_AGT_WRDATA_UHI,
+						*data++);
+		if (ret_val == QLA_ERROR) {
+			ql4_printk(KERN_ERR, ha, "%s: write to AGT_WRDATA failed\n",
+				   __func__);
+			goto exit_ms_mem_write_unlock;
+		}
+
+		/* Check write status */
+		ret_val = ha->isp_ops->wr_reg_indirect(ha, MD_MIU_TEST_AGT_CTRL,
+						       MIU_TA_CTL_WRITE_ENABLE);
+		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
+							MD_MIU_TEST_AGT_CTRL,
+							MIU_TA_CTL_WRITE_START);
+		if (ret_val == QLA_ERROR) {
+			ql4_printk(KERN_ERR, ha, "%s: write to AGT_CTRL failed\n",
+				   __func__);
+			goto exit_ms_mem_write_unlock;
+		}
+
+		for (j = 0; j < MAX_CTL_CHECK; j++) {
+			ret_val = ha->isp_ops->rd_reg_indirect(ha,
+							MD_MIU_TEST_AGT_CTRL,
+							&agt_ctrl);
+			if (ret_val == QLA_ERROR) {
+				ql4_printk(KERN_ERR, ha, "%s: failed to read MD_MIU_TEST_AGT_CTRL\n",
+					   __func__);
+				goto exit_ms_mem_write_unlock;
+			}
+			if ((agt_ctrl & MIU_TA_CTL_BUSY) == 0)
+				break;
+		}
+
+		/* Status check failed */
+		if (j >= MAX_CTL_CHECK) {
+			printk_ratelimited(KERN_ERR "%s: MS memory write failed!\n",
+					   __func__);
+			ret_val = QLA_ERROR;
+			goto exit_ms_mem_write_unlock;
+		}
+	}
+
+exit_ms_mem_write_unlock:
+	write_unlock_irqrestore(&ha->hw_lock, flags);
+
+exit_ms_mem_write:
+	return ret_val;
+}
+
 static int
 qla4_82xx_load_from_flash(struct scsi_qla_host *ha, uint32_t image_start)
 {
-- 
1.8.2.GIT

