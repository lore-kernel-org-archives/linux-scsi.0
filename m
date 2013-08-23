From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/4] qla4xxx: Add pex-dma support for capturing minidump
Date: Fri, 23 Aug 2013 03:40:18 -0400
Message-ID: <1377243621-32107-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1377243621-32107-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:59662 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755137Ab3HWIKD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Aug 2013 04:10:03 -0400
In-Reply-To: <1377243621-32107-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Santosh Vernekar <santosh.vernekar@qlogic.com>

From: Santosh Vernekar <santosh.vernekar@qlogic.com>

Add pex-dma support for ISP8324 and ISP8042 to improve
the minidump capture time.

Signed-off-by: Santosh Vernekar <santosh.vernekar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_83xx.c |   4 +-
 drivers/scsi/qla4xxx/ql4_83xx.h |  34 ++++++
 drivers/scsi/qla4xxx/ql4_glbl.h |   2 +
 drivers/scsi/qla4xxx/ql4_nx.c   | 226 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 263 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index 9be4f8f..8196c2f 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -259,8 +259,8 @@ void qla4_83xx_rom_lock_recovery(struct scsi_qla_host *ha)
  * Return: On success return QLA_SUCCESS
  *	   On error return QLA_ERROR
  **/
-static int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha, uint64_t addr,
-				       uint32_t *data, uint32_t count)
+int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha, uint64_t addr,
+				uint32_t *data, uint32_t count)
 {
 	int i, j;
 	uint32_t agt_ctrl;
diff --git a/drivers/scsi/qla4xxx/ql4_83xx.h b/drivers/scsi/qla4xxx/ql4_83xx.h
index 1b8c544..a0de6e2 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.h
+++ b/drivers/scsi/qla4xxx/ql4_83xx.h
@@ -290,4 +290,38 @@ struct qla4_83xx_idc_information {
 	uint32_t info3; /* IDC additional info */
 };
 
+#define QLA83XX_PEX_DMA_ENGINE_INDEX		8
+#define QLA83XX_PEX_DMA_BASE_ADDRESS		0x77320000
+#define QLA83XX_PEX_DMA_NUM_OFFSET		0x10000
+#define QLA83XX_PEX_DMA_CMD_ADDR_LOW		0x0
+#define QLA83XX_PEX_DMA_CMD_ADDR_HIGH		0x04
+#define QLA83XX_PEX_DMA_CMD_STS_AND_CNTRL	0x08
+
+#define QLA83XX_PEX_DMA_READ_SIZE	(16 * 1024)
+#define QLA83XX_PEX_DMA_MAX_WAIT	(100 * 100) /* Max wait of 100 msecs */
+
+/* Read Memory: For Pex-DMA */
+struct qla4_83xx_minidump_entry_rdmem_pex_dma {
+	struct qla8xxx_minidump_entry_hdr h;
+	uint32_t desc_card_addr;
+	uint16_t dma_desc_cmd;
+	uint8_t rsvd[2];
+	uint32_t start_dma_cmd;
+	uint8_t rsvd2[12];
+	uint32_t read_addr;
+	uint32_t read_data_size;
+};
+
+struct qla4_83xx_pex_dma_descriptor {
+	struct {
+		uint32_t read_data_size; /* 0-23: size, 24-31: rsvd */
+		uint8_t rsvd[2];
+		uint16_t dma_desc_cmd;
+	} cmd;
+	uint64_t src_addr;
+	uint64_t dma_bus_addr; /* 0-3: desc-cmd, 4-7: pci-func,
+				* 8-15: desc-cmd */
+	uint8_t rsvd[24];
+} __packed;
+
 #endif
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index cec80b6..e6f2a26 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -272,6 +272,8 @@ int qla4xxx_set_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 int qla4xxx_get_acb(struct scsi_qla_host *ha, dma_addr_t acb_dma,
 		    uint32_t acb_type, uint32_t len);
 int qla4_84xx_config_acb(struct scsi_qla_host *ha, int acb_config);
+int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha,
+				uint64_t addr, uint32_t *data, uint32_t count);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 67831aa..c41362c 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1737,6 +1737,208 @@ static void qla4_8xxx_minidump_process_rdcrb(struct scsi_qla_host *ha,
 	*d_ptr = data_ptr;
 }
 
+static int qla4_83xx_check_dma_engine_state(struct scsi_qla_host *ha)
+{
+	int rval = QLA_SUCCESS;
+	uint32_t dma_eng_num = 0, cmd_sts_and_cntrl = 0;
+	uint64_t dma_base_addr = 0;
+	struct qla4_8xxx_minidump_template_hdr *tmplt_hdr = NULL;
+
+	tmplt_hdr = (struct qla4_8xxx_minidump_template_hdr *)
+							ha->fw_dump_tmplt_hdr;
+	dma_eng_num =
+		tmplt_hdr->saved_state_array[QLA83XX_PEX_DMA_ENGINE_INDEX];
+	dma_base_addr = QLA83XX_PEX_DMA_BASE_ADDRESS +
+				(dma_eng_num * QLA83XX_PEX_DMA_NUM_OFFSET);
+
+	/* Read the pex-dma's command-status-and-control register. */
+	rval = ha->isp_ops->rd_reg_indirect(ha,
+			(dma_base_addr + QLA83XX_PEX_DMA_CMD_STS_AND_CNTRL),
+			&cmd_sts_and_cntrl);
+
+	if (rval)
+		return QLA_ERROR;
+
+	/* Check if requested pex-dma engine is available. */
+	if (cmd_sts_and_cntrl & BIT_31)
+		return QLA_SUCCESS;
+	else
+		return QLA_ERROR;
+}
+
+static int qla4_83xx_start_pex_dma(struct scsi_qla_host *ha,
+			   struct qla4_83xx_minidump_entry_rdmem_pex_dma *m_hdr)
+{
+	int rval = QLA_SUCCESS, wait = 0;
+	uint32_t dma_eng_num = 0, cmd_sts_and_cntrl = 0;
+	uint64_t dma_base_addr = 0;
+	struct qla4_8xxx_minidump_template_hdr *tmplt_hdr = NULL;
+
+	tmplt_hdr = (struct qla4_8xxx_minidump_template_hdr *)
+							ha->fw_dump_tmplt_hdr;
+	dma_eng_num =
+		tmplt_hdr->saved_state_array[QLA83XX_PEX_DMA_ENGINE_INDEX];
+	dma_base_addr = QLA83XX_PEX_DMA_BASE_ADDRESS +
+				(dma_eng_num * QLA83XX_PEX_DMA_NUM_OFFSET);
+
+	rval = ha->isp_ops->wr_reg_indirect(ha,
+				dma_base_addr + QLA83XX_PEX_DMA_CMD_ADDR_LOW,
+				m_hdr->desc_card_addr);
+	if (rval)
+		goto error_exit;
+
+	rval = ha->isp_ops->wr_reg_indirect(ha,
+			      dma_base_addr + QLA83XX_PEX_DMA_CMD_ADDR_HIGH, 0);
+	if (rval)
+		goto error_exit;
+
+	rval = ha->isp_ops->wr_reg_indirect(ha,
+			      dma_base_addr + QLA83XX_PEX_DMA_CMD_STS_AND_CNTRL,
+			      m_hdr->start_dma_cmd);
+	if (rval)
+		goto error_exit;
+
+	/* Wait for dma operation to complete. */
+	for (wait = 0; wait < QLA83XX_PEX_DMA_MAX_WAIT; wait++) {
+		rval = ha->isp_ops->rd_reg_indirect(ha,
+			    (dma_base_addr + QLA83XX_PEX_DMA_CMD_STS_AND_CNTRL),
+			    &cmd_sts_and_cntrl);
+		if (rval)
+			goto error_exit;
+
+		if ((cmd_sts_and_cntrl & BIT_1) == 0)
+			break;
+		else
+			udelay(10);
+	}
+
+	/* Wait a max of 100 ms, otherwise fallback to rdmem entry read */
+	if (wait >= QLA83XX_PEX_DMA_MAX_WAIT) {
+		rval = QLA_ERROR;
+		goto error_exit;
+	}
+
+error_exit:
+	return rval;
+}
+
+static int qla4_83xx_minidump_pex_dma_read(struct scsi_qla_host *ha,
+				struct qla8xxx_minidump_entry_hdr *entry_hdr,
+				uint32_t **d_ptr)
+{
+	int rval = QLA_SUCCESS;
+	struct qla4_83xx_minidump_entry_rdmem_pex_dma *m_hdr = NULL;
+	uint32_t size, read_size;
+	uint8_t *data_ptr = (uint8_t *)*d_ptr;
+	void *rdmem_buffer = NULL;
+	dma_addr_t rdmem_dma;
+	struct qla4_83xx_pex_dma_descriptor dma_desc;
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "Entering fn: %s\n", __func__));
+
+	rval = qla4_83xx_check_dma_engine_state(ha);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "%s: DMA engine not available. Fallback to rdmem-read.\n",
+				  __func__));
+		return QLA_ERROR;
+	}
+
+	m_hdr = (struct qla4_83xx_minidump_entry_rdmem_pex_dma *)entry_hdr;
+	rdmem_buffer = dma_alloc_coherent(&ha->pdev->dev,
+					  QLA83XX_PEX_DMA_READ_SIZE,
+					  &rdmem_dma, GFP_KERNEL);
+	if (!rdmem_buffer) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "%s: Unable to allocate rdmem dma buffer\n",
+				  __func__));
+		return QLA_ERROR;
+	}
+
+	/* Prepare pex-dma descriptor to be written to MS memory. */
+	/* dma-desc-cmd layout:
+	 *              0-3: dma-desc-cmd 0-3
+	 *              4-7: pcid function number
+	 *              8-15: dma-desc-cmd 8-15
+	 */
+	dma_desc.cmd.dma_desc_cmd = (m_hdr->dma_desc_cmd & 0xff0f);
+	dma_desc.cmd.dma_desc_cmd |= ((PCI_FUNC(ha->pdev->devfn) & 0xf) << 0x4);
+	dma_desc.dma_bus_addr = rdmem_dma;
+
+	size = 0;
+	read_size = 0;
+	/*
+	 * Perform rdmem operation using pex-dma.
+	 * Prepare dma in chunks of QLA83XX_PEX_DMA_READ_SIZE.
+	 */
+	while (read_size < m_hdr->read_data_size) {
+		if (m_hdr->read_data_size - read_size >=
+		    QLA83XX_PEX_DMA_READ_SIZE)
+			size = QLA83XX_PEX_DMA_READ_SIZE;
+		else {
+			size = (m_hdr->read_data_size - read_size);
+
+			if (rdmem_buffer)
+				dma_free_coherent(&ha->pdev->dev,
+						  QLA83XX_PEX_DMA_READ_SIZE,
+						  rdmem_buffer, rdmem_dma);
+
+			rdmem_buffer = dma_alloc_coherent(&ha->pdev->dev, size,
+							  &rdmem_dma,
+							  GFP_KERNEL);
+			if (!rdmem_buffer) {
+				DEBUG2(ql4_printk(KERN_INFO, ha,
+						  "%s: Unable to allocate rdmem dma buffer\n",
+						  __func__));
+				return QLA_ERROR;
+			}
+			dma_desc.dma_bus_addr = rdmem_dma;
+		}
+
+		dma_desc.src_addr = m_hdr->read_addr + read_size;
+		dma_desc.cmd.read_data_size = size;
+
+		/* Prepare: Write pex-dma descriptor to MS memory. */
+		rval = qla4_83xx_ms_mem_write_128b(ha,
+			      (uint64_t)m_hdr->desc_card_addr,
+			      (uint32_t *)&dma_desc,
+			      (sizeof(struct qla4_83xx_pex_dma_descriptor)/16));
+		if (rval == -1) {
+			ql4_printk(KERN_INFO, ha,
+				   "%s: Error writing rdmem-dma-init to MS !!!\n",
+				   __func__);
+			goto error_exit;
+		}
+
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "%s: Dma-desc: Instruct for rdmem dma (size 0x%x).\n",
+				  __func__, size));
+		/* Execute: Start pex-dma operation. */
+		rval = qla4_83xx_start_pex_dma(ha, m_hdr);
+		if (rval != QLA_SUCCESS) {
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "scsi(%ld): start-pex-dma failed rval=0x%x\n",
+					  ha->host_no, rval));
+			goto error_exit;
+		}
+
+		memcpy(data_ptr, rdmem_buffer, size);
+		data_ptr += size;
+		read_size += size;
+	}
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "Leaving fn: %s\n", __func__));
+
+	*d_ptr = (uint32_t *)data_ptr;
+
+error_exit:
+	if (rdmem_buffer)
+		dma_free_coherent(&ha->pdev->dev, size, rdmem_buffer,
+				  rdmem_dma);
+
+	return rval;
+}
+
 static int qla4_8xxx_minidump_process_l2tag(struct scsi_qla_host *ha,
 				 struct qla8xxx_minidump_entry_hdr *entry_hdr,
 				 uint32_t **d_ptr)
@@ -2068,7 +2270,7 @@ static void qla4_82xx_minidump_process_rdrom(struct scsi_qla_host *ha,
 #define MD_MIU_TEST_AGT_ADDR_LO		0x41000094
 #define MD_MIU_TEST_AGT_ADDR_HI		0x41000098
 
-static int qla4_8xxx_minidump_process_rdmem(struct scsi_qla_host *ha,
+static int __qla4_8xxx_minidump_process_rdmem(struct scsi_qla_host *ha,
 				struct qla8xxx_minidump_entry_hdr *entry_hdr,
 				uint32_t **d_ptr)
 {
@@ -2150,6 +2352,28 @@ static int qla4_8xxx_minidump_process_rdmem(struct scsi_qla_host *ha,
 	return QLA_SUCCESS;
 }
 
+static int qla4_8xxx_minidump_process_rdmem(struct scsi_qla_host *ha,
+				struct qla8xxx_minidump_entry_hdr *entry_hdr,
+				uint32_t **d_ptr)
+{
+	uint32_t *data_ptr = *d_ptr;
+	int rval = QLA_SUCCESS;
+
+	if (is_qla8032(ha) || is_qla8042(ha)) {
+		rval = qla4_83xx_minidump_pex_dma_read(ha, entry_hdr,
+						       &data_ptr);
+		if (rval != QLA_SUCCESS) {
+			rval = __qla4_8xxx_minidump_process_rdmem(ha, entry_hdr,
+								  &data_ptr);
+		}
+	} else {
+		rval = __qla4_8xxx_minidump_process_rdmem(ha, entry_hdr,
+							  &data_ptr);
+	}
+	*d_ptr = data_ptr;
+	return rval;
+}
+
 static void qla4_8xxx_mark_entry_skipped(struct scsi_qla_host *ha,
 				struct qla8xxx_minidump_entry_hdr *entry_hdr,
 				int index)
-- 
1.8.2.GIT

