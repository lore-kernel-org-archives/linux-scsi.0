From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/17] qla2xxx: Add ISP24xx initialization routines.
Date: Wed,  6 Jul 2005 10:31:37 -0700 (PDT)
Message-ID: <20050706173137.10568.55242.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:42835 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262429AbVGFRbi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:31:38 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add ISP24xx initialization routines.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_gbl.h  |    9 
 drivers/scsi/qla2xxx/qla_init.c |  973 ++++++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_os.c   |    1 
 3 files changed, 848 insertions(+), 135 deletions(-)

0fa8d6c80a75c92805ff55eb87287fd53dd239bc
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -35,13 +35,22 @@ extern int qla2x00_initialize_adapter(sc
 
 extern int qla2100_pci_config(struct scsi_qla_host *);
 extern int qla2300_pci_config(struct scsi_qla_host *);
+extern int qla24xx_pci_config(scsi_qla_host_t *);
 extern void qla2x00_reset_chip(struct scsi_qla_host *);
+extern void qla24xx_reset_chip(struct scsi_qla_host *);
 extern int qla2x00_chip_diag(struct scsi_qla_host *);
+extern int qla24xx_chip_diag(struct scsi_qla_host *);
 extern void qla2x00_config_rings(struct scsi_qla_host *);
+extern void qla24xx_config_rings(struct scsi_qla_host *);
 extern void qla2x00_reset_adapter(struct scsi_qla_host *);
+extern void qla24xx_reset_adapter(struct scsi_qla_host *);
 extern int qla2x00_nvram_config(struct scsi_qla_host *);
+extern int qla24xx_nvram_config(struct scsi_qla_host *);
 extern void qla2x00_update_fw_options(struct scsi_qla_host *);
+extern void qla24xx_update_fw_options(scsi_qla_host_t *);
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
+extern int qla24xx_load_risc_flash(scsi_qla_host_t *, uint32_t *);
+extern int qla24xx_load_risc_hotplug(scsi_qla_host_t *, uint32_t *);
 
 extern fc_port_t *qla2x00_alloc_fcport(scsi_qla_host_t *, int);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -19,6 +19,8 @@
 #include "qla_def.h"
 
 #include <linux/delay.h>
+#include <linux/vmalloc.h>
+#include <linux/firmware.h>
 #include <scsi/scsi_transport_fc.h>
 
 #include "qla_devtbl.h"
@@ -87,6 +89,7 @@ qla2x00_initialize_adapter(scsi_qla_host
 	ha->isp_abort_cnt = 0;
 	ha->beacon_blink_led = 0;
 
+	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
 	rval = ha->isp_ops.pci_config(ha);
 	if (rval) {
 		DEBUG2(printk("scsi(%ld): Unable to configure PCI space=n",
@@ -97,6 +100,7 @@ qla2x00_initialize_adapter(scsi_qla_host
 	ha->isp_ops.reset_chip(ha);
 
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
+
 	ha->isp_ops.nvram_config(ha);
 
 	qla_printk(KERN_INFO, ha, "Verifying loaded RISC code...\n");
@@ -129,6 +133,9 @@ check_fw_ready_again:
 			if (rval == QLA_SUCCESS) {
 				clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 
+				/* Issue a marker after FW becomes ready. */
+				qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
+
 				/*
 				 * Wait at most MAX_TARGET RSCNs for a stable
 				 * link.
@@ -172,7 +179,6 @@ check_fw_ready_again:
 
 	if (rval == QLA_SUCCESS) {
 		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
-		ha->marker_needed = 1;
 		qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
 		ha->marker_needed = 0;
 
@@ -197,8 +203,6 @@ qla2100_pci_config(scsi_qla_host_t *ha)
 	unsigned long flags;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
-
 	pci_set_master(ha->pdev);
 	mwi = 0;
 	if (pci_set_mwi(ha->pdev))
@@ -236,8 +240,6 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 	uint32_t	cnt;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
-
 	pci_set_master(ha->pdev);
 	mwi = 0;
 	if (pci_set_mwi(ha->pdev))
@@ -312,6 +314,70 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 }
 
 /**
+ * qla24xx_pci_config() - Setup ISP24xx PCI configuration registers.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+int
+qla24xx_pci_config(scsi_qla_host_t *ha)
+{
+	uint16_t w, mwi;
+	unsigned long flags = 0;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	int pcix_cmd_reg, pcie_dctl_reg;
+
+	pci_set_master(ha->pdev);
+	mwi = 0;
+	if (pci_set_mwi(ha->pdev))
+		mwi = PCI_COMMAND_INVALIDATE;
+	pci_read_config_word(ha->pdev, PCI_REVISION_ID, &ha->revision);
+
+	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
+	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w &= ~PCI_COMMAND_INTX_DISABLE;
+	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
+
+	pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER, 0x80);
+
+	/* PCI-X -- adjust Maximum Memory Read Byte Count (2048). */
+	pcix_cmd_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_PCIX);
+	if (pcix_cmd_reg) {
+		uint16_t pcix_cmd;
+
+		pcix_cmd_reg += PCI_X_CMD;
+		pci_read_config_word(ha->pdev, pcix_cmd_reg, &pcix_cmd);
+		pcix_cmd &= ~PCI_X_CMD_MAX_READ;
+		pcix_cmd |= 0x0008;
+		pci_write_config_word(ha->pdev, pcix_cmd_reg, pcix_cmd);
+	}
+
+	/* PCIe -- adjust Maximum Read Request Size (2048). */
+	pcie_dctl_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+	if (pcie_dctl_reg) {
+		uint16_t pcie_dctl;
+
+		pcie_dctl_reg += PCI_EXP_DEVCTL;
+		pci_read_config_word(ha->pdev, pcie_dctl_reg, &pcie_dctl);
+		pcie_dctl &= ~PCI_EXP_DEVCTL_READRQ;
+		pcie_dctl |= 0x4000;
+		pci_write_config_word(ha->pdev, pcie_dctl_reg, pcie_dctl);
+	}
+
+	/* Reset expansion ROM address decode enable */
+	pci_read_config_word(ha->pdev, PCI_ROM_ADDRESS, &w);
+	w &= ~PCI_ROM_ADDRESS_ENABLE;
+	pci_write_config_word(ha->pdev, PCI_ROM_ADDRESS, w);
+
+	/* Get PCI bus information. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->pci_attr = RD_REG_DWORD(&reg->ctrl_status);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return QLA_SUCCESS;
+}
+
+/**
  * qla2x00_isp_firmware() - Choose firmware image.
  * @ha: HA context
  *
@@ -498,6 +564,61 @@ qla2x00_reset_chip(scsi_qla_host_t *ha) 
 }
 
 /**
+ * qla24xx_reset_chip() - Reset ISP24xx chip.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+void
+qla24xx_reset_chip(scsi_qla_host_t *ha)
+{
+	unsigned long flags = 0;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	uint32_t cnt, d2;
+
+	ha->isp_ops.disable_intrs(ha);
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	/* Reset RISC. */
+	WRT_REG_DWORD(&reg->ctrl_status, CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+	for (cnt = 0; cnt < 30000; cnt++) {
+		if ((RD_REG_DWORD(&reg->ctrl_status) & CSRX_DMA_ACTIVE) == 0)
+			break;
+
+		udelay(10);
+	}
+
+	WRT_REG_DWORD(&reg->ctrl_status,
+	    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+	udelay(20);
+	d2 = RD_REG_DWORD(&reg->ctrl_status);
+	for (cnt = 6000000 ; cnt && (d2 & CSRX_ISP_SOFT_RESET); cnt--) {
+		udelay(5);
+		d2 = RD_REG_DWORD(&reg->ctrl_status);
+		barrier();
+	}
+
+	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
+	RD_REG_DWORD(&reg->hccr);
+
+	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
+	RD_REG_DWORD(&reg->hccr);
+
+	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
+	RD_REG_DWORD(&reg->hccr);
+
+	d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+	for (cnt = 6000000 ; cnt && d2; cnt--) {
+		udelay(5);
+		d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+		barrier();
+	}
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+/**
  * qla2x00_chip_diag() - Test chip for proper operation.
  * @ha: HA context
  *
@@ -623,6 +744,91 @@ chip_diag_failed:
 }
 
 /**
+ * qla24xx_chip_diag() - Test ISP24xx for proper operation.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+int
+qla24xx_chip_diag(scsi_qla_host_t *ha)
+{
+	int rval;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	unsigned long flags = 0;
+	uint32_t cnt, d2;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	/* Reset RISC. */
+	WRT_REG_DWORD(&reg->ctrl_status, CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+	for (cnt = 0; cnt < 30000; cnt++) {
+		if ((RD_REG_DWORD(&reg->ctrl_status) &
+		    CSRX_DMA_ACTIVE) == 0)
+			break;
+
+		udelay(10);
+	}
+
+	WRT_REG_DWORD(&reg->ctrl_status,
+	    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+	udelay(20);
+	d2 = RD_REG_DWORD(&reg->ctrl_status);
+	for (cnt = 6000000 ; cnt && (d2 & CSRX_ISP_SOFT_RESET); cnt--) {
+		udelay(5);
+		d2 = RD_REG_DWORD(&reg->ctrl_status);
+		barrier();
+	}
+
+	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
+	RD_REG_DWORD(&reg->hccr);
+
+	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
+	RD_REG_DWORD(&reg->hccr);
+
+	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
+	RD_REG_DWORD(&reg->hccr);
+
+	d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+	for (cnt = 6000000 ; cnt && d2; cnt--) {
+		udelay(5);
+		d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+		barrier();
+	}
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * 1024;
+
+	rval = qla2x00_mbx_reg_test(ha);
+	if (rval) {
+		DEBUG(printk("scsi(%ld): Failed mailbox send register test\n",
+		    ha->host_no));
+		qla_printk(KERN_WARNING, ha,
+		    "Failed mailbox send register test\n");
+	} else {
+		/* Flag a successful rval */
+		rval = QLA_SUCCESS;
+	}
+
+	return rval;
+}
+
+static void
+qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
+{
+	ha->fw_dumped = 0;
+	ha->fw_dump24_len = sizeof(struct qla24xx_fw_dump);
+	ha->fw_dump24_len += (ha->fw_memory_size - 0x100000) * sizeof(uint32_t);
+	ha->fw_dump24 = vmalloc(ha->fw_dump24_len);
+	if (ha->fw_dump24)
+		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for firmware "
+		    "dump...\n", ha->fw_dump24_len / 1024);
+	else
+		qla_printk(KERN_WARNING, ha, "Unable to allocate (%d KB) for "
+		    "firmware dump!!!\n", ha->fw_dump24_len / 1024);
+}
+
+/**
  * qla2x00_resize_request_q() - Resize request queue given available ISP memory.
  * @ha: HA context
  *
@@ -641,6 +847,9 @@ qla2x00_resize_request_q(scsi_qla_host_t
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return;
 
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		qla2x00_alloc_fw_dump(ha);
+
 	/* Retrieve IOCB counts available to the firmware. */
 	rval = qla2x00_get_resource_cnts(ha, NULL, NULL, NULL, &fw_iocb_cnt);
 	if (rval)
@@ -684,91 +893,22 @@ qla2x00_resize_request_q(scsi_qla_host_t
 static int
 qla2x00_setup_chip(scsi_qla_host_t *ha)
 {
-	int		rval;
-	uint16_t	cnt;
-	uint16_t	*risc_code;
-	unsigned long	risc_address;
-	unsigned long	risc_code_size;
-	int		num;
-	int		i;
-	uint16_t	*req_ring;
-	struct qla_fw_info *fw_iter;
-
-	rval = QLA_SUCCESS;
+	int rval;
+	uint32_t srisc_address = 0;
 
 	/* Load firmware sequences */
-	fw_iter = ha->brd_info->fw_info;
-	while (fw_iter->addressing != FW_INFO_ADDR_NOMORE) {
-		risc_code = fw_iter->fwcode;
-		risc_code_size = *fw_iter->fwlen;
-
-		if (fw_iter->addressing == FW_INFO_ADDR_NORMAL) {
-			risc_address = *fw_iter->fwstart;
-		} else {
-			/* Extended address */
-			risc_address = *fw_iter->lfwstart;
-		}
-
-		num = 0;
-		rval = 0;
-		while (risc_code_size > 0 && !rval) {
-			cnt = (uint16_t)(ha->fw_transfer_size >> 1);
-			if (cnt > risc_code_size)
-				cnt = risc_code_size;
-
-			DEBUG7(printk("scsi(%ld): Loading risc segment@ "
-			    "addr %p, number of bytes 0x%x, offset 0x%lx.\n",
-			    ha->host_no, risc_code, cnt, risc_address));
-
-			req_ring = (uint16_t *)ha->request_ring;
-			for (i = 0; i < cnt; i++)
-				req_ring[i] = cpu_to_le16(risc_code[i]);
-
-			if (fw_iter->addressing == FW_INFO_ADDR_NORMAL) {
-				rval = qla2x00_load_ram(ha,
-				    ha->request_dma, risc_address, cnt);
-			} else {
-				rval = qla2x00_load_ram_ext(ha,
-				    ha->request_dma, risc_address, cnt);
-			}
-			if (rval) {
-				DEBUG(printk("scsi(%ld): [ERROR] Failed to "
-				    "load segment %d of firmware\n",
-				    ha->host_no, num));
-				qla_printk(KERN_WARNING, ha,
-				    "[ERROR] Failed to load "
-				    "segment %d of firmware\n", num);
-
-				qla2x00_dump_regs(ha);
-				break;
-			}
-
-			risc_code += cnt;
-			risc_address += cnt;
-			risc_code_size -= cnt;
-			num++;
-		}
-
-		/* Next firmware sequence */
-		fw_iter++;
-	}
-
-	/* Verify checksum of loaded RISC code. */
-	if (!rval) {
+	rval = ha->isp_ops.load_risc(ha, &srisc_address);
+	if (rval == QLA_SUCCESS) {
 		DEBUG(printk("scsi(%ld): Verifying Checksum of loaded RISC "
 		    "code.\n", ha->host_no));
 
-		rval = qla2x00_verify_checksum(ha,
-		    IS_QLA24XX(ha) || IS_QLA25XX(ha) ? RISC_SADDRESS :
-		    *ha->brd_info->fw_info[0].fwstart);
+		rval = qla2x00_verify_checksum(ha, srisc_address);
 		if (rval == QLA_SUCCESS) {
 			/* Start firmware execution. */
 			DEBUG(printk("scsi(%ld): Checksum OK, start "
 			    "firmware.\n", ha->host_no));
 
-			rval = qla2x00_execute_fw(ha,
-			    IS_QLA24XX(ha) || IS_QLA25XX(ha) ? RISC_SADDRESS :
-			    *ha->brd_info->fw_info[0].fwstart);
+			rval = qla2x00_execute_fw(ha, srisc_address);
 			/* Retrieve firmware information. */
 			if (rval == QLA_SUCCESS && ha->fw_major_version == 0) {
 				qla2x00_get_fw_version(ha,
@@ -893,6 +1033,23 @@ qla2x00_update_fw_options(scsi_qla_host_
 }
 
 void
+qla24xx_update_fw_options(scsi_qla_host_t *ha)
+{
+	int rval;
+
+	/* Update Serial Link options. */
+	if ((ha->fw_seriallink_options24[0] & BIT_0) == 0)
+		return;
+
+	rval = qla2x00_set_serdes_params(ha, ha->fw_seriallink_options24[1],
+	    ha->fw_seriallink_options24[2], ha->fw_seriallink_options24[3]);
+	if (rval != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to update Serial Link options (%x).\n", rval);
+	}
+}
+
+void
 qla2x00_config_rings(struct scsi_qla_host *ha)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -914,6 +1071,30 @@ qla2x00_config_rings(struct scsi_qla_hos
 	RD_REG_WORD(ISP_RSP_Q_OUT(ha, reg));		/* PCI Posting. */
 }
 
+void
+qla24xx_config_rings(struct scsi_qla_host *ha)
+{
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	struct init_cb_24xx *icb;
+
+	/* Setup ring parameters in initialization control block. */
+	icb = (struct init_cb_24xx *)ha->init_cb;
+	icb->request_q_outpointer = __constant_cpu_to_le16(0);
+	icb->response_q_inpointer = __constant_cpu_to_le16(0);
+	icb->request_q_length = cpu_to_le16(ha->request_q_length);
+	icb->response_q_length = cpu_to_le16(ha->response_q_length);
+	icb->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
+	icb->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
+	icb->response_q_address[0] = cpu_to_le32(LSD(ha->response_dma));
+	icb->response_q_address[1] = cpu_to_le32(MSD(ha->response_dma));
+
+	WRT_REG_DWORD(&reg->req_q_in, 0);
+	WRT_REG_DWORD(&reg->req_q_out, 0);
+	WRT_REG_DWORD(&reg->rsp_q_in, 0);
+	WRT_REG_DWORD(&reg->rsp_q_out, 0);
+	RD_REG_DWORD(&reg->rsp_q_out);
+}
+
 /**
  * qla2x00_init_rings() - Initializes firmware.
  * @ha: HA context
@@ -960,7 +1141,7 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 	ha->isp_ops.update_fw_options(ha);
 
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
-	rval = qla2x00_init_firmware(ha, sizeof(init_cb_t));
+	rval = qla2x00_init_firmware(ha, ha->init_cb_size);
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Init firmware **** FAILED ****.\n",
 		    ha->host_no));
@@ -1195,38 +1376,33 @@ qla2x00_configure_hba(scsi_qla_host_t *h
 int
 qla2x00_nvram_config(scsi_qla_host_t *ha)
 {
-	int   rval;
-	uint8_t   chksum = 0;
-	uint16_t  cnt;
-	uint8_t   *dptr1, *dptr2;
-	init_cb_t *icb   = ha->init_cb;
-	nvram_t *nv    = (nvram_t *)ha->request_ring;
-	uint16_t  *wptr  = (uint16_t *)ha->request_ring;
+	int             rval;
+	uint8_t         chksum = 0;
+	uint16_t        cnt;
+	uint8_t         *dptr1, *dptr2;
+	init_cb_t       *icb = ha->init_cb;
+	nvram_t         *nv = (nvram_t *)ha->request_ring;
+	uint8_t         *ptr = (uint8_t *)ha->request_ring;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-	uint8_t  timer_mode;
+	uint8_t         timer_mode;
 
 	rval = QLA_SUCCESS;
 
 	/* Determine NVRAM starting address. */
+	ha->nvram_size = sizeof(nvram_t);
 	ha->nvram_base = 0;
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA2300(ha))
 		if ((RD_REG_WORD(&reg->ctrl_status) >> 14) == 1)
 			ha->nvram_base = 0x80;
 
 	/* Get NVRAM data and calculate checksum. */
-	qla2x00_lock_nvram_access(ha);
-	for (cnt = 0; cnt < sizeof(nvram_t)/2; cnt++) {
-		*wptr = cpu_to_le16(qla2x00_get_nvram_word(ha,
-		    (cnt+ha->nvram_base)));
-		chksum += (uint8_t)*wptr;
-		chksum += (uint8_t)(*wptr >> 8);
-		wptr++;
-	}
-	qla2x00_unlock_nvram_access(ha);
+	ha->isp_ops.read_nvram(ha, ptr, ha->nvram_base, ha->nvram_size);
+	for (cnt = 0, chksum = 0; cnt < ha->nvram_size; cnt++)
+		chksum += *ptr++;
 
 	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", ha->host_no));
 	DEBUG5(qla2x00_dump_buffer((uint8_t *)ha->request_ring,
-	    sizeof(nvram_t)));
+	    ha->nvram_size));
 
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' ||
@@ -1241,7 +1417,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 		/*
 		 * Set default initialization control block.
 		 */
-		memset(nv, 0, sizeof(nvram_t));
+		memset(nv, 0, ha->nvram_size);
 		nv->parameter_block_version = ICB_VERSION;
 
 		if (IS_QLA23XX(ha)) {
@@ -1301,7 +1477,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 #endif
 
 	/* Reset Initialization control block */
-	memset(icb, 0, sizeof(init_cb_t));
+	memset(icb, 0, ha->init_cb_size);
 
 	/*
 	 * Setup driver NVRAM options.
@@ -1314,6 +1490,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	if (IS_QLA23XX(ha)) {
 		nv->firmware_options[0] |= BIT_2;
 		nv->firmware_options[0] &= ~BIT_3;
+		nv->add_firmware_options[1] |= BIT_5 | BIT_4;
 
 		if (IS_QLA2300(ha)) {
 			if (ha->fb_rev == FPM_2310) {
@@ -1941,10 +2118,15 @@ qla2x00_configure_fabric(scsi_qla_host_t
 	fc_port_t	*fcport, *fcptemp;
 	uint16_t	next_loopid;
 	uint16_t	mb[MAILBOX_REGISTER_COUNT];
+	uint16_t	loop_id;
 	LIST_HEAD(new_fcports);
 
 	/* If FL port exists, then SNS is present */
-	rval = qla2x00_get_port_name(ha, SNS_FL_PORT, NULL, 0);
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		loop_id = NPH_F_PORT;
+	else
+		loop_id = SNS_FL_PORT;
+	rval = qla2x00_get_port_name(ha, loop_id, NULL, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(printk("scsi(%ld): MBC_GET_PORT_NAME Failed, No FL "
 		    "Port\n", ha->host_no));
@@ -1961,12 +2143,16 @@ qla2x00_configure_fabric(scsi_qla_host_t
 	}
 	do {
 		/* Ensure we are logged into the SNS. */
-		ha->isp_ops.fabric_login(ha, SIMPLE_NAME_SERVER, 0xff, 0xff,
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			loop_id = NPH_SNS;
+		else
+			loop_id = SIMPLE_NAME_SERVER;
+		ha->isp_ops.fabric_login(ha, loop_id, 0xff, 0xff,
 		    0xfc, mb, BIT_1 | BIT_0);
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2(qla_printk(KERN_INFO, ha,
 			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x "
-			    "mb[2]=%x mb[6]=%x mb[7]=%x\n", SIMPLE_NAME_SERVER,
+			    "mb[2]=%x mb[6]=%x mb[7]=%x\n", loop_id,
 			    mb[0], mb[1], mb[2], mb[6], mb[7]));
 			return (QLA_SUCCESS);
 		}
@@ -2050,7 +2236,6 @@ qla2x00_configure_fabric(scsi_qla_host_t
 					break;
 				}
 			}
-
 			/* Login and update database */
 			qla2x00_fabric_dev_login(ha, fcport, &next_loopid);
 		}
@@ -2164,7 +2349,6 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 
 	/* Starting free loop ID. */
 	loop_id = ha->min_external_loopid;
-
 	for (; loop_id <= ha->last_loop_id; loop_id++) {
 		if (qla2x00_is_reserved_id(ha, loop_id))
 			continue;
@@ -2450,6 +2634,7 @@ qla2x00_device_resync(scsi_qla_host_t *h
 		case 0:
 			if (!IS_QLA2100(ha) && !IS_QLA2200(ha) &&
 			    !IS_QLA6312(ha) && !IS_QLA6322(ha) &&
+			    !IS_QLA24XX(ha) && !IS_QLA25XX(ha) &&
 			    ha->flags.init_done) {
 				/* Handle port RSCN via asyncronous IOCBs */
 				rval2 = qla2x00_handle_port_rscn(ha, rscn_entry,
@@ -2518,17 +2703,24 @@ qla2x00_fabric_dev_login(scsi_qla_host_t
 {
 	int	rval;
 	int	retry;
+	uint8_t opts;
 
 	rval = QLA_SUCCESS;
 	retry = 0;
 
 	rval = qla2x00_fabric_login(ha, fcport, next_loopid);
 	if (rval == QLA_SUCCESS) {
-		rval = qla2x00_get_port_database(ha, fcport, 0);
+		/* Send an ADISC to tape devices.*/
+		opts = 0;
+		if (fcport->flags & FCF_TAPE_PRESENT)
+			opts |= BIT_1;
+		rval = qla2x00_get_port_database(ha, fcport, opts);
 		if (rval != QLA_SUCCESS) {
 			ha->isp_ops.fabric_logout(ha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
+			qla2x00_mark_device_lost(ha, fcport, 1);
+
 		} else {
 			qla2x00_update_fcport(ha, fcport);
 		}
@@ -2576,10 +2768,10 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 		if (mb[0] == MBS_PORT_ID_USED) {
 			/*
 			 * Device has another loop ID.  The firmware team
-			 * recommends us to perform an implicit login with the
-			 * specified ID again. The ID we just used is save here
-			 * so we return with an ID that can be tried by the
-			 * next login.
+			 * recommends the driver perform an implicit login with
+			 * the specified ID again. The ID we just used is save
+			 * here so we return with an ID that can be tried by
+			 * the next login.
 			 */
 			retry++;
 			tmp_loopid = fcport->loop_id;
@@ -2723,14 +2915,11 @@ qla2x00_loop_resync(scsi_qla_host_t *ha)
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
 			wait_time = 256;
 			do {
-				/* v2.19.05b6 */
 				atomic_set(&ha->loop_state, LOOP_UPDATE);
 
-				/*
-				 * Issue marker command only when we are going
-				 * to start the I/O .
-				 */
-				ha->marker_needed = 1;
+				/* Issue a marker after FW becomes ready. */
+				qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
+				ha->marker_needed = 0;
 
 				/* Remap devices on Loop. */
 				clear_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
@@ -2862,7 +3051,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 				} else { /* schedule another ISP abort */
 					ha->isp_abort_cnt--;
 					DEBUG(printk("qla%ld: ISP abort - "
-					    "retry remainning %d\n",
+					    "retry remaining %d\n",
 					    ha->host_no, ha->isp_abort_cnt);)
 					status = 1;
 				}
@@ -2919,9 +3108,15 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 
 			spin_lock_irqsave(&ha->hardware_lock, flags);
 
-			/* Disable SRAM, Instruction RAM and GP RAM parity. */
-			WRT_REG_WORD(&reg->hccr, (HCCR_ENABLE_PARITY + 0x0));
-			RD_REG_WORD(&reg->hccr);	/* PCI Posting. */
+			if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha)) {
+				/*
+				 * Disable SRAM, Instruction RAM and GP RAM
+				 * parity.
+				 */
+				WRT_REG_WORD(&reg->hccr,
+				    (HCCR_ENABLE_PARITY + 0x0));
+				RD_REG_WORD(&reg->hccr);
+			}
 
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	
@@ -2929,16 +3124,21 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 
 			spin_lock_irqsave(&ha->hardware_lock, flags);
  
- 			/* Enable proper parity */
- 			if (IS_QLA2300(ha))
- 				/* SRAM parity */
- 				WRT_REG_WORD(&reg->hccr,
- 				    (HCCR_ENABLE_PARITY + 0x1));
- 			else
- 				/* SRAM, Instruction RAM and GP RAM parity */
- 				WRT_REG_WORD(&reg->hccr,
- 				    (HCCR_ENABLE_PARITY + 0x7));
-			RD_REG_WORD(&reg->hccr);	/* PCI Posting. */
+			if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha)) {
+				/* Enable proper parity */
+				if (IS_QLA2300(ha))
+					/* SRAM parity */
+					WRT_REG_WORD(&reg->hccr,
+					    (HCCR_ENABLE_PARITY + 0x1));
+				else
+					/*
+					 * SRAM, Instruction RAM and GP RAM
+					 * parity.
+					 */
+					WRT_REG_WORD(&reg->hccr,
+					    (HCCR_ENABLE_PARITY + 0x7));
+				RD_REG_WORD(&reg->hccr);
+			}
 
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		}
@@ -2949,9 +3149,11 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 		if (!(status = qla2x00_fw_ready(ha))) {
 			DEBUG(printk("%s(): Start configure loop, "
-					"status = %d\n",
-					__func__,
-					status);)
+			    "status = %d\n", __func__, status);)
+
+			/* Issue a marker after FW becomes ready. */
+			qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
+
 			ha->flags.online = 1;
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
 			wait_time = 256;
@@ -2992,7 +3194,6 @@ qla2x00_reset_adapter(scsi_qla_host_t *h
 	ha->flags.online = 0;
 	ha->isp_ops.disable_intrs(ha);
 
-	/* Reset RISC processor. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
 	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
@@ -3000,3 +3201,505 @@ qla2x00_reset_adapter(scsi_qla_host_t *h
 	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
+
+void
+qla24xx_reset_adapter(scsi_qla_host_t *ha)
+{
+	unsigned long flags = 0;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	ha->flags.online = 0;
+	ha->isp_ops.disable_intrs(ha);
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
+	RD_REG_DWORD(&reg->hccr);
+	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
+	RD_REG_DWORD(&reg->hccr);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+int
+qla24xx_nvram_config(scsi_qla_host_t *ha)
+{
+	int   rval;
+	struct init_cb_24xx *icb;
+	struct nvram_24xx *nv;
+	uint32_t *dptr;
+	uint8_t  *dptr1, *dptr2;
+	uint32_t chksum;
+	uint16_t cnt;
+
+	rval = QLA_SUCCESS;
+	icb = (struct init_cb_24xx *)ha->init_cb;
+	nv = (struct nvram_24xx *)ha->request_ring;
+
+	/* Determine NVRAM starting address. */
+	ha->nvram_size = sizeof(struct nvram_24xx);
+	ha->nvram_base = FA_NVRAM_FUNC0_ADDR;
+	if (PCI_FUNC(ha->pdev->devfn))
+		ha->nvram_base = FA_NVRAM_FUNC1_ADDR;
+
+	/* Get NVRAM data and calculate checksum. */
+	dptr = (uint32_t *)nv;
+	ha->isp_ops.read_nvram(ha, (uint8_t *)dptr, ha->nvram_base,
+	    ha->nvram_size);
+	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++)
+		chksum += le32_to_cpu(*dptr++);
+
+	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", ha->host_no));
+	DEBUG5(qla2x00_dump_buffer((uint8_t *)ha->request_ring,
+	    ha->nvram_size));
+
+	/* Bad NVRAM data, set defaults parameters. */
+	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' || nv->id[2] != 'P'
+	    || nv->id[3] != ' ' ||
+	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
+		/* Reset NVRAM data. */
+		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
+		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
+		    le16_to_cpu(nv->nvram_version));
+		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
+		    "invalid -- WWPN) defaults.\n");
+
+		/*
+		 * Set default initialization control block.
+		 */
+		memset(nv, 0, ha->nvram_size);
+		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
+		nv->version = __constant_cpu_to_le16(ICB_VERSION);
+		nv->frame_payload_size = __constant_cpu_to_le16(2048);
+		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+		nv->exchange_count = __constant_cpu_to_le16(0);
+		nv->hard_address = __constant_cpu_to_le16(124);
+		nv->port_name[0] = 0x21;
+		nv->port_name[1] = 0x00 + PCI_FUNC(ha->pdev->devfn);
+		nv->port_name[2] = 0x00;
+		nv->port_name[3] = 0xe0;
+		nv->port_name[4] = 0x8b;
+		nv->port_name[5] = 0x1c;
+		nv->port_name[6] = 0x55;
+		nv->port_name[7] = 0x86;
+		nv->node_name[0] = 0x20;
+		nv->node_name[1] = 0x00;
+		nv->node_name[2] = 0x00;
+		nv->node_name[3] = 0xe0;
+		nv->node_name[4] = 0x8b;
+		nv->node_name[5] = 0x1c;
+		nv->node_name[6] = 0x55;
+		nv->node_name[7] = 0x86;
+		nv->login_retry_count = __constant_cpu_to_le16(8);
+		nv->link_down_timeout = __constant_cpu_to_le16(200);
+		nv->interrupt_delay_timer = __constant_cpu_to_le16(0);
+		nv->login_timeout = __constant_cpu_to_le16(0);
+		nv->firmware_options_1 =
+		    __constant_cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
+		nv->firmware_options_2 = __constant_cpu_to_le32(2 << 4);
+		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
+		nv->firmware_options_3 = __constant_cpu_to_le32(2 << 13);
+		nv->host_p = __constant_cpu_to_le32(BIT_11|BIT_10);
+		nv->efi_parameters = __constant_cpu_to_le32(0);
+		nv->reset_delay = 5;
+		nv->max_luns_per_target = __constant_cpu_to_le16(128);
+		nv->port_down_retry_count = __constant_cpu_to_le16(30);
+		nv->link_down_timeout = __constant_cpu_to_le16(30);
+
+		rval = 1;
+	}
+
+	/* Reset Initialization control block */
+	memset(icb, 0, sizeof(struct init_cb_24xx));
+
+	/* Copy 1st segment. */
+	dptr1 = (uint8_t *)icb;
+	dptr2 = (uint8_t *)&nv->version;
+	cnt = (uint8_t *)&icb->response_q_inpointer - (uint8_t *)&icb->version;
+	while (cnt--)
+		*dptr1++ = *dptr2++;
+
+	icb->login_retry_count = nv->login_retry_count;
+	icb->link_down_timeout = nv->link_down_timeout;
+
+	/* Copy 2nd segment. */
+	dptr1 = (uint8_t *)&icb->interrupt_delay_timer;
+	dptr2 = (uint8_t *)&nv->interrupt_delay_timer;
+	cnt = (uint8_t *)&icb->reserved_3 -
+	    (uint8_t *)&icb->interrupt_delay_timer;
+	while (cnt--)
+		*dptr1++ = *dptr2++;
+
+	/*
+	 * Setup driver NVRAM options.
+	 */
+	if (memcmp(nv->model_name, BINZERO, sizeof(nv->model_name)) != 0) {
+		char *st, *en;
+		uint16_t index;
+
+		strncpy(ha->model_number, nv->model_name,
+		    sizeof(nv->model_name));
+		st = en = ha->model_number;
+		en += sizeof(nv->model_name) - 1;
+		while (en > st) {
+			if (*en != 0x20 && *en != 0x00)
+				break;
+			*en-- = '\0';
+		}
+
+		index = (ha->pdev->subsystem_device & 0xff);
+		if (index < QLA_MODEL_NAMES)
+			ha->model_desc = qla2x00_model_desc[index];
+	} else
+		strcpy(ha->model_number, "QLA2462");
+
+	/* Prepare nodename */
+	if ((icb->firmware_options_1 & BIT_14) == 0) {
+		/*
+		 * Firmware will apply the following mask if the nodename was
+		 * not provided.
+		 */
+		memcpy(icb->node_name, icb->port_name, WWN_SIZE);
+		icb->node_name[0] &= 0xF0;
+	}
+
+	/* Set host adapter parameters. */
+	ha->flags.disable_risc_code_load = 0;
+	ha->flags.enable_lip_reset = 1;
+	ha->flags.enable_lip_full_login = 1;
+	ha->flags.enable_target_reset = 1;
+	ha->flags.enable_led_scheme = 0;
+
+	ha->operating_mode =
+	    (icb->firmware_options_2 & (BIT_6 | BIT_5 | BIT_4)) >> 4;
+
+	memcpy(ha->fw_seriallink_options24, nv->seriallink_options,
+	    sizeof(ha->fw_seriallink_options24));
+
+	/* save HBA serial number */
+	ha->serial0 = icb->port_name[5];
+	ha->serial1 = icb->port_name[6];
+	ha->serial2 = icb->port_name[7];
+	ha->node_name = icb->node_name;
+	ha->port_name = icb->port_name;
+
+	ha->retry_count = le16_to_cpu(nv->login_retry_count);
+
+	/* Set minimum login_timeout to 4 seconds. */
+	if (le16_to_cpu(nv->login_timeout) < ql2xlogintimeout)
+		nv->login_timeout = cpu_to_le16(ql2xlogintimeout);
+	if (le16_to_cpu(nv->login_timeout) < 4)
+		nv->login_timeout = __constant_cpu_to_le16(4);
+	ha->login_timeout = le16_to_cpu(nv->login_timeout);
+	icb->login_timeout = cpu_to_le16(nv->login_timeout);
+
+	/* Set minimum RATOV to 200 tenths of a second. */
+	ha->r_a_tov = 200;
+
+	ha->loop_reset_delay = nv->reset_delay;
+
+	/* Link Down Timeout = 0:
+	 *
+	 * 	When Port Down timer expires we will start returning
+	 *	I/O's to OS with "DID_NO_CONNECT".
+	 *
+	 * Link Down Timeout != 0:
+	 *
+	 *	 The driver waits for the link to come up after link down
+	 *	 before returning I/Os to OS with "DID_NO_CONNECT".
+	 */
+	if (le16_to_cpu(nv->link_down_timeout) == 0) {
+		ha->loop_down_abort_time =
+		    (LOOP_DOWN_TIME - LOOP_DOWN_TIMEOUT);
+	} else {
+		ha->link_down_timeout =	le16_to_cpu(nv->link_down_timeout);
+		ha->loop_down_abort_time =
+		    (LOOP_DOWN_TIME - ha->link_down_timeout);
+	}
+
+	/* Need enough time to try and get the port back. */
+	ha->port_down_retry_count = le16_to_cpu(nv->port_down_retry_count);
+	if (qlport_down_retry)
+		ha->port_down_retry_count = qlport_down_retry;
+
+	/* Set login_retry_count */
+	ha->login_retry_count  = le16_to_cpu(nv->login_retry_count);
+	if (ha->port_down_retry_count ==
+	    le16_to_cpu(nv->port_down_retry_count) &&
+	    ha->port_down_retry_count > 3)
+		ha->login_retry_count = ha->port_down_retry_count;
+	else if (ha->port_down_retry_count > (int)ha->login_retry_count)
+		ha->login_retry_count = ha->port_down_retry_count;
+	if (ql2xloginretrycount)
+		ha->login_retry_count = ql2xloginretrycount;
+
+	if (rval) {
+		DEBUG2_3(printk(KERN_WARNING
+		    "scsi(%ld): NVRAM configuration failed!\n", ha->host_no));
+	}
+	return (rval);
+}
+
+int
+qla2x00_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+{
+	int		rval;
+	uint16_t	cnt;
+	uint16_t	*risc_code;
+	unsigned long	risc_address;
+	unsigned long	risc_code_size;
+	int		num;
+	int		i;
+	uint16_t	*req_ring;
+	struct qla_fw_info *fw_iter;
+
+	rval = QLA_SUCCESS;
+
+	/* Load firmware sequences */
+	fw_iter = ha->brd_info->fw_info;
+	*srisc_addr = *ha->brd_info->fw_info->fwstart;
+	while (fw_iter->addressing != FW_INFO_ADDR_NOMORE) {
+		risc_code = fw_iter->fwcode;
+		risc_code_size = *fw_iter->fwlen;
+
+		if (fw_iter->addressing == FW_INFO_ADDR_NORMAL) {
+			risc_address = *fw_iter->fwstart;
+		} else {
+			/* Extended address */
+			risc_address = *fw_iter->lfwstart;
+		}
+
+		num = 0;
+		rval = 0;
+		while (risc_code_size > 0 && !rval) {
+			cnt = (uint16_t)(ha->fw_transfer_size >> 1);
+			if (cnt > risc_code_size)
+				cnt = risc_code_size;
+
+			DEBUG7(printk("scsi(%ld): Loading risc segment@ "
+			    "addr %p, number of bytes 0x%x, offset 0x%lx.\n",
+			    ha->host_no, risc_code, cnt, risc_address));
+
+			req_ring = (uint16_t *)ha->request_ring;
+			for (i = 0; i < cnt; i++)
+				req_ring[i] = cpu_to_le16(risc_code[i]);
+
+			if (fw_iter->addressing == FW_INFO_ADDR_NORMAL) {
+				rval = qla2x00_load_ram(ha, ha->request_dma,
+				    risc_address, cnt);
+			} else {
+				rval = qla2x00_load_ram_ext(ha,
+				    ha->request_dma, risc_address, cnt);
+			}
+			if (rval) {
+				DEBUG(printk("scsi(%ld): [ERROR] Failed to "
+				    "load segment %d of firmware\n",
+				    ha->host_no, num));
+				qla_printk(KERN_WARNING, ha,
+				    "[ERROR] Failed to load segment %d of "
+				    "firmware\n", num);
+
+				qla2x00_dump_regs(ha);
+				break;
+			}
+
+			risc_code += cnt;
+			risc_address += cnt;
+			risc_code_size -= cnt;
+			num++;
+		}
+
+		/* Next firmware sequence */
+		fw_iter++;
+	}
+
+	return (rval);
+}
+
+int
+qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+{
+	int	rval;
+	int	segments, fragment;
+	uint32_t faddr;
+	uint32_t *dcode, dlen;
+	uint32_t risc_addr;
+	uint32_t risc_size;
+	uint32_t i;
+
+	rval = QLA_SUCCESS;
+
+	segments = FA_RISC_CODE_SEGMENTS;
+	faddr = FA_RISC_CODE_ADDR;
+	dcode = (uint32_t *)ha->request_ring;
+	*srisc_addr = 0;
+
+	/* Validate firmware image by checking version. */
+	qla24xx_read_flash_data(ha, dcode, faddr + 4, 4);
+	for (i = 0; i < 4; i++)
+		dcode[i] = be32_to_cpu(dcode[i]);
+	if ((dcode[0] == 0xffffffff && dcode[1] == 0xffffffff &&
+	    dcode[2] == 0xffffffff && dcode[3] == 0xffffffff) ||
+	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
+		dcode[3] == 0)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to verify integrity of flash firmware image!\n");
+		qla_printk(KERN_WARNING, ha,
+		    "Firmware data: %08x %08x %08x %08x!\n", dcode[0],
+		    dcode[1], dcode[2], dcode[3]);
+
+		return QLA_FUNCTION_FAILED;
+	}
+
+	while (segments && rval == QLA_SUCCESS) {
+		/* Read segment's load information. */
+		qla24xx_read_flash_data(ha, dcode, faddr, 4);
+
+		risc_addr = be32_to_cpu(dcode[2]);
+		*srisc_addr = *srisc_addr == 0 ? risc_addr : *srisc_addr;
+		risc_size = be32_to_cpu(dcode[3]);
+
+		fragment = 0;
+		while (risc_size > 0 && rval == QLA_SUCCESS) {
+			dlen = (uint32_t)(ha->fw_transfer_size >> 2);
+			if (dlen > risc_size)
+				dlen = risc_size;
+
+			DEBUG7(printk("scsi(%ld): Loading risc segment@ risc "
+			    "addr %x, number of dwords 0x%x, offset 0x%x.\n",
+			    ha->host_no, risc_addr, dlen, faddr));
+
+			qla24xx_read_flash_data(ha, dcode, faddr, dlen);
+			for (i = 0; i < dlen; i++)
+				dcode[i] = swab32(dcode[i]);
+
+			rval = qla2x00_load_ram_ext(ha, ha->request_dma,
+			    risc_addr, dlen);
+			if (rval) {
+				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
+				    "segment %d of firmware\n", ha->host_no,
+				    fragment));
+				qla_printk(KERN_WARNING, ha,
+				    "[ERROR] Failed to load segment %d of "
+				    "firmware\n", fragment);
+				break;
+			}
+
+			faddr += dlen;
+			risc_addr += dlen;
+			risc_size -= dlen;
+			fragment++;
+		}
+
+		/* Next segment. */
+		segments--;
+	}
+
+	return rval;
+}
+
+int
+qla24xx_load_risc_hotplug(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+{
+	int	rval;
+	int	segments, fragment;
+	uint32_t *dcode, dlen;
+	uint32_t risc_addr;
+	uint32_t risc_size;
+	uint32_t i;
+	const struct firmware *fw_entry;
+	uint32_t *fwcode, fwclen;
+
+	if (request_firmware(&fw_entry, ha->brd_info->fw_fname,
+	    &ha->pdev->dev)) {
+		qla_printk(KERN_ERR, ha,
+		    "Firmware image file not available: '%s'\n",
+		    ha->brd_info->fw_fname);
+		return QLA_FUNCTION_FAILED;
+	}
+
+	rval = QLA_SUCCESS;
+
+	segments = FA_RISC_CODE_SEGMENTS;
+	dcode = (uint32_t *)ha->request_ring;
+	*srisc_addr = 0;
+	fwcode = (uint32_t *)fw_entry->data;
+	fwclen = 0;
+
+	/* Validate firmware image by checking version. */
+	if (fw_entry->size < 8 * sizeof(uint32_t)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to verify integrity of flash firmware image "
+		    "(%Zd)!\n", fw_entry->size);
+		goto fail_fw_integrity;
+	}
+	for (i = 0; i < 4; i++)
+		dcode[i] = be32_to_cpu(fwcode[i + 4]);
+	if ((dcode[0] == 0xffffffff && dcode[1] == 0xffffffff &&
+	    dcode[2] == 0xffffffff && dcode[3] == 0xffffffff) ||
+	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
+		dcode[3] == 0)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to verify integrity of flash firmware image!\n");
+		qla_printk(KERN_WARNING, ha,
+		    "Firmware data: %08x %08x %08x %08x!\n", dcode[0],
+		    dcode[1], dcode[2], dcode[3]);
+		goto fail_fw_integrity;
+	}
+
+	while (segments && rval == QLA_SUCCESS) {
+		risc_addr = be32_to_cpu(fwcode[2]);
+		*srisc_addr = *srisc_addr == 0 ? risc_addr : *srisc_addr;
+		risc_size = be32_to_cpu(fwcode[3]);
+
+		/* Validate firmware image size. */
+		fwclen += risc_size * sizeof(uint32_t);
+		if (fw_entry->size < fwclen) {
+			qla_printk(KERN_WARNING, ha,
+			    "Unable to verify integrity of flash firmware "
+			    "image (%Zd)!\n", fw_entry->size);
+			goto fail_fw_integrity;
+		}
+
+		fragment = 0;
+		while (risc_size > 0 && rval == QLA_SUCCESS) {
+			dlen = (uint32_t)(ha->fw_transfer_size >> 2);
+			if (dlen > risc_size)
+				dlen = risc_size;
+
+			DEBUG7(printk("scsi(%ld): Loading risc segment@ risc "
+			    "addr %x, number of dwords 0x%x.\n", ha->host_no,
+			    risc_addr, dlen));
+
+			for (i = 0; i < dlen; i++)
+				dcode[i] = swab32(fwcode[i]);
+
+			rval = qla2x00_load_ram_ext(ha, ha->request_dma,
+			    risc_addr, dlen);
+			if (rval) {
+				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
+				    "segment %d of firmware\n", ha->host_no,
+				    fragment));
+				qla_printk(KERN_WARNING, ha,
+				    "[ERROR] Failed to load segment %d of "
+				    "firmware\n", fragment);
+				break;
+			}
+
+			fwcode += dlen;
+			risc_addr += dlen;
+			risc_size -= dlen;
+			fragment++;
+		}
+
+		/* Next segment. */
+		segments--;
+	}
+
+	release_firmware(fw_entry);
+	return rval;
+
+fail_fw_integrity:
+
+	release_firmware(fw_entry);
+	return QLA_FUNCTION_FAILED;
+
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1175,6 +1175,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->isp_ops.reset_adapter	= qla2x00_reset_adapter;
 	ha->isp_ops.nvram_config	= qla2x00_nvram_config;
 	ha->isp_ops.update_fw_options	= qla2x00_update_fw_options;
+	ha->isp_ops.load_risc		= qla2x00_load_risc;
 	ha->isp_ops.pci_info_str	= qla2x00_pci_info_str;
 	ha->isp_ops.fw_version_str	= qla2x00_fw_version_str;
 	ha->isp_ops.intr_handler	= qla2100_intr_handler;

-- 
Andrew Vasquez
