From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 05/10] qla4xxx: Added PEX DMA Support for ISP8022 Adapter
Date: Mon, 24 Feb 2014 22:07:00 -0500
Message-ID: <1393297625-928-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:29027 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902AbaBYDpG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 22:45:06 -0500
In-Reply-To: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_83xx.c | 44 +++++++++++++++++++++--------------------
 drivers/scsi/qla4xxx/ql4_glbl.h |  2 +-
 drivers/scsi/qla4xxx/ql4_nx.c   | 15 ++++----------
 3 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index 2eba353..ffce016 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -250,7 +250,7 @@ void qla4_83xx_rom_lock_recovery(struct scsi_qla_host *ha)
 }
 
 /**
- * qla4_83xx_ms_mem_write_128b - Writes data to MS/off-chip memory
+ * qla4_8xxx_ms_mem_write_128b - Writes data to MS/off-chip memory
  * @ha: Pointer to adapter structure
  * @addr: Flash address to write to
  * @data: Data to be written
@@ -259,7 +259,7 @@ void qla4_83xx_rom_lock_recovery(struct scsi_qla_host *ha)
  * Return: On success return QLA_SUCCESS
  *	   On error return QLA_ERROR
  **/
-int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha, uint64_t addr,
+int qla4_8xxx_ms_mem_write_128b(struct scsi_qla_host *ha, uint64_t addr,
 				uint32_t *data, uint32_t count)
 {
 	int i, j;
@@ -276,7 +276,7 @@ int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha, uint64_t addr,
 	write_lock_irqsave(&ha->hw_lock, flags);
 
 	/* Write address */
-	ret_val = qla4_83xx_wr_reg_indirect(ha, MD_MIU_TEST_AGT_ADDR_HI, 0);
+	ret_val = ha->isp_ops->wr_reg_indirect(ha, MD_MIU_TEST_AGT_ADDR_HI, 0);
 	if (ret_val == QLA_ERROR) {
 		ql4_printk(KERN_ERR, ha, "%s: write to AGT_ADDR_HI failed\n",
 			   __func__);
@@ -292,19 +292,20 @@ int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha, uint64_t addr,
 			goto exit_ms_mem_write_unlock;
 		}
 
-		ret_val = qla4_83xx_wr_reg_indirect(ha, MD_MIU_TEST_AGT_ADDR_LO,
-						    addr);
+		ret_val = ha->isp_ops->wr_reg_indirect(ha,
+						       MD_MIU_TEST_AGT_ADDR_LO,
+						       addr);
 		/* Write data */
-		ret_val |= qla4_83xx_wr_reg_indirect(ha,
-						     MD_MIU_TEST_AGT_WRDATA_LO,
-						     *data++);
-		ret_val |= qla4_83xx_wr_reg_indirect(ha,
-						     MD_MIU_TEST_AGT_WRDATA_HI,
-						     *data++);
-		ret_val |= qla4_83xx_wr_reg_indirect(ha,
+		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
+						      MD_MIU_TEST_AGT_WRDATA_LO,
+						      *data++);
+		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
+						      MD_MIU_TEST_AGT_WRDATA_HI,
+						      *data++);
+		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
 						     MD_MIU_TEST_AGT_WRDATA_ULO,
 						     *data++);
-		ret_val |= qla4_83xx_wr_reg_indirect(ha,
+		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
 						     MD_MIU_TEST_AGT_WRDATA_UHI,
 						     *data++);
 		if (ret_val == QLA_ERROR) {
@@ -314,10 +315,11 @@ int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha, uint64_t addr,
 		}
 
 		/* Check write status */
-		ret_val = qla4_83xx_wr_reg_indirect(ha, MD_MIU_TEST_AGT_CTRL,
-						    MIU_TA_CTL_WRITE_ENABLE);
-		ret_val |= qla4_83xx_wr_reg_indirect(ha, MD_MIU_TEST_AGT_CTRL,
-						     MIU_TA_CTL_WRITE_START);
+		ret_val = ha->isp_ops->wr_reg_indirect(ha, MD_MIU_TEST_AGT_CTRL,
+						       MIU_TA_CTL_WRITE_ENABLE);
+		ret_val |= ha->isp_ops->wr_reg_indirect(ha,
+							MD_MIU_TEST_AGT_CTRL,
+							MIU_TA_CTL_WRITE_START);
 		if (ret_val == QLA_ERROR) {
 			ql4_printk(KERN_ERR, ha, "%s: write to AGT_CTRL failed\n",
 				   __func__);
@@ -325,9 +327,9 @@ int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha, uint64_t addr,
 		}
 
 		for (j = 0; j < MAX_CTL_CHECK; j++) {
-			ret_val = qla4_83xx_rd_reg_indirect(ha,
-							MD_MIU_TEST_AGT_CTRL,
-							&agt_ctrl);
+			ret_val = ha->isp_ops->rd_reg_indirect(ha,
+							  MD_MIU_TEST_AGT_CTRL,
+							  &agt_ctrl);
 			if (ret_val == QLA_ERROR) {
 				ql4_printk(KERN_ERR, ha, "%s: failed to read MD_MIU_TEST_AGT_CTRL\n",
 					   __func__);
@@ -760,7 +762,7 @@ static int qla4_83xx_copy_bootloader(struct scsi_qla_host *ha)
 			  __func__));
 
 	/* 128 bit/16 byte write to MS memory */
-	ret_val = qla4_83xx_ms_mem_write_128b(ha, dest, (uint32_t *)p_cache,
+	ret_val = qla4_8xxx_ms_mem_write_128b(ha, dest, (uint32_t *)p_cache,
 					      count);
 	if (ret_val == QLA_ERROR) {
 		ql4_printk(KERN_ERR, ha, "%s: Error writing firmware to MS\n",
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index b1a19cd..2035475 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -274,7 +274,7 @@ int qla4xxx_set_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 int qla4xxx_get_acb(struct scsi_qla_host *ha, dma_addr_t acb_dma,
 		    uint32_t acb_type, uint32_t len);
 int qla4_84xx_config_acb(struct scsi_qla_host *ha, int acb_config);
-int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha,
+int qla4_8xxx_ms_mem_write_128b(struct scsi_qla_host *ha,
 				uint64_t addr, uint32_t *data, uint32_t count);
 uint8_t qla4xxx_set_ipaddr_state(uint8_t fw_ipaddr_state);
 int qla4_83xx_get_port_config(struct scsi_qla_host *ha, uint32_t *config);
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index bdc3b95..6032bf6 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1918,7 +1918,7 @@ error_exit:
 	return rval;
 }
 
-static int qla4_83xx_minidump_pex_dma_read(struct scsi_qla_host *ha,
+static int qla4_8xxx_minidump_pex_dma_read(struct scsi_qla_host *ha,
 				struct qla8xxx_minidump_entry_hdr *entry_hdr,
 				uint32_t **d_ptr)
 {
@@ -1995,7 +1995,7 @@ static int qla4_83xx_minidump_pex_dma_read(struct scsi_qla_host *ha,
 		dma_desc.cmd.read_data_size = size;
 
 		/* Prepare: Write pex-dma descriptor to MS memory. */
-		rval = qla4_83xx_ms_mem_write_128b(ha,
+		rval = qla4_8xxx_ms_mem_write_128b(ha,
 			      (uint64_t)m_hdr->desc_card_addr,
 			      (uint32_t *)&dma_desc,
 			      (sizeof(struct qla4_83xx_pex_dma_descriptor)/16));
@@ -2455,17 +2455,10 @@ static int qla4_8xxx_minidump_process_rdmem(struct scsi_qla_host *ha,
 	uint32_t *data_ptr = *d_ptr;
 	int rval = QLA_SUCCESS;
 
-	if (is_qla8032(ha) || is_qla8042(ha)) {
-		rval = qla4_83xx_minidump_pex_dma_read(ha, entry_hdr,
-						       &data_ptr);
-		if (rval != QLA_SUCCESS) {
-			rval = __qla4_8xxx_minidump_process_rdmem(ha, entry_hdr,
-								  &data_ptr);
-		}
-	} else {
+	rval = qla4_8xxx_minidump_pex_dma_read(ha, entry_hdr, &data_ptr);
+	if (rval != QLA_SUCCESS)
 		rval = __qla4_8xxx_minidump_process_rdmem(ha, entry_hdr,
 							  &data_ptr);
-	}
 	*d_ptr = data_ptr;
 	return rval;
 }
-- 
1.8.2.GIT

