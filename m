From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 8/11]  qla2xxx: Final glue-code for ISP24xx.
Date: Mon, 13 Jun 2005 22:32:17 -0700 (PDT)
Message-ID: <20050614053217.12127.19802.sendpatchset@plap.qlogic.com>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:46998 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261211AbVFNFcT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 01:32:19 -0400
In-Reply-To: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Final glue-code for ISP24xx.

Add appropriate glue-code for ISP24xx support within
OS and initialization sections of driver.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/Makefile     |    3 
 drivers/scsi/qla2xxx/qla_attr.c   |   32 +
 drivers/scsi/qla2xxx/qla_gbl.h    |    1 
 drivers/scsi/qla2xxx/qla_init.c   | 1131 ++++++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_inline.h |   21 +
 drivers/scsi/qla2xxx/qla_os.c     |  245 ++++++--
 6 files changed, 1170 insertions(+), 263 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,4 +1,6 @@
 EXTRA_CFLAGS += -DUNIQUE_FW_NAME
+CONFIG_SCSI_QLA24XX=m
+EXTRA_CFLAGS += -DCONFIG_SCSI_QLA24XX -DCONFIG_SCSI_QLA24XX_MODULE
 
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
 		qla_dbg.o qla_sup.o qla_rscn.o qla_attr.o
@@ -14,3 +16,4 @@ obj-$(CONFIG_SCSI_QLA22XX) += qla2xxx.o 
 obj-$(CONFIG_SCSI_QLA2300) += qla2xxx.o qla2300.o
 obj-$(CONFIG_SCSI_QLA2322) += qla2xxx.o qla2322.o
 obj-$(CONFIG_SCSI_QLA6312) += qla2xxx.o qla6312.o
+obj-$(CONFIG_SCSI_QLA24XX) += qla2xxx.o
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -63,23 +63,29 @@ qla2x00_sysfs_write_fw_dump(struct kobje
 			    ha->host_no);
 
 			vfree(ha->fw_dump_buffer);
-			free_pages((unsigned long)ha->fw_dump,
-			    ha->fw_dump_order);
+			if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha))
+				free_pages((unsigned long)ha->fw_dump,
+				    ha->fw_dump_order);
 
 			ha->fw_dump_reading = 0;
 			ha->fw_dump_buffer = NULL;
 			ha->fw_dump = NULL;
+			ha->fw_dumped = 0;
 		}
 		break;
 	case 1:
-		if (ha->fw_dump != NULL && !ha->fw_dump_reading) {
+		if ((ha->fw_dump || ha->fw_dumped) && !ha->fw_dump_reading) {
 			ha->fw_dump_reading = 1;
 
-			dump_size = FW_DUMP_SIZE_1M;
-			if (ha->fw_memory_size < 0x20000) 
-				dump_size = FW_DUMP_SIZE_128K;
-			else if (ha->fw_memory_size < 0x80000) 
-				dump_size = FW_DUMP_SIZE_512K;
+			if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+				dump_size = FW_DUMP_SIZE_24XX;
+			else {
+				dump_size = FW_DUMP_SIZE_1M;
+				if (ha->fw_memory_size < 0x20000)
+					dump_size = FW_DUMP_SIZE_128K;
+				else if (ha->fw_memory_size < 0x80000)
+					dump_size = FW_DUMP_SIZE_512K;
+			}
 			ha->fw_dump_buffer = (char *)vmalloc(dump_size);
 			if (ha->fw_dump_buffer == NULL) {
 				qla_printk(KERN_WARNING, ha,
@@ -94,9 +100,11 @@ qla2x00_sysfs_write_fw_dump(struct kobje
 			    ha->host_no);
 			memset(ha->fw_dump_buffer, 0, dump_size);
 			if (IS_QLA2100(ha) || IS_QLA2200(ha))
- 				qla2100_ascii_fw_dump(ha);
- 			else
- 				qla2300_ascii_fw_dump(ha);
+				qla2100_ascii_fw_dump(ha);
+			else if (IS_QLA23XX(ha))
+				qla2300_ascii_fw_dump(ha);
+			else if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+				qla24xx_ascii_fw_dump(ha);
 			ha->fw_dump_buffer_len = strlen(ha->fw_dump_buffer);
 		}
 		break;
@@ -184,7 +192,7 @@ static struct bin_attribute sysfs_nvram_
 		.mode = S_IRUSR | S_IWUSR,
 		.owner = THIS_MODULE,
 	},
-	.size = 0;
+	.size = 0,
 	.read = qla2x00_sysfs_read_nvram,
 	.write = qla2x00_sysfs_write_nvram,
 };
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -59,6 +59,7 @@ extern int ql2xplogiabsentdevice;
 extern int ql2xenablezio;
 extern int ql2xintrdelaytimer;
 extern int ql2xloginretrycount;
+extern int ql2xfwloadbin;
 
 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
 
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
@@ -39,6 +41,7 @@ static int qla2x00_isp_firmware(scsi_qla
 static void qla2x00_reset_chip(scsi_qla_host_t *);
 static int qla2x00_chip_diag(scsi_qla_host_t *);
 static void qla2x00_resize_request_q(scsi_qla_host_t *);
+static int qla2x00_load_risc(scsi_qla_host_t *, uint32_t *);
 static int qla2x00_setup_chip(scsi_qla_host_t *);
 static void qla2x00_init_response_q_entries(scsi_qla_host_t *);
 static int qla2x00_init_rings(scsi_qla_host_t *);
@@ -57,6 +60,11 @@ static int qla2x00_fabric_dev_login(scsi
 static int qla2x00_restart_isp(scsi_qla_host_t *);
 static void qla2x00_reset_adapter(scsi_qla_host_t *);
 
+static int qla24xx_nvram_config(scsi_qla_host_t *);
+static int qla24xx_load_risc_flash(scsi_qla_host_t *, uint32_t *);
+static int qla24xx_load_risc_hotplug(scsi_qla_host_t *, uint32_t *);
+static void qla24xx_update_fw_options(scsi_qla_host_t *);
+
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
 /****************************************************************************/
@@ -102,6 +110,7 @@ qla2x00_initialize_adapter(scsi_qla_host
 	qla2x00_reset_chip(ha);
 
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
+
 	qla2x00_nvram_config(ha);
 
 	qla_printk(KERN_INFO, ha, "Verifying loaded RISC code...\n");
@@ -134,6 +143,9 @@ check_fw_ready_again:
 			if (rval == QLA_SUCCESS) {
 				clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 
+				/* Issue a marker after FW becomes ready. */
+				qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
+
 				/*
 				 * Wait at most MAX_TARGET RSCNs for a stable
 				 * link.
@@ -177,7 +189,6 @@ check_fw_ready_again:
 
 	if (rval == QLA_SUCCESS) {
 		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
-		ha->marker_needed = 1;
 		qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
 		ha->marker_needed = 0;
 
@@ -225,64 +236,111 @@ qla2x00_pci_config(scsi_qla_host_t *ha)
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
 	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 
-	/* Get PCI bus information. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->pci_attr = RD_REG_WORD(&ha->iobase->ctrl_status);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		int pcix_cmd_reg, pcie_dctl_reg;
+		struct device_reg_24xx __iomem *reg24 =
+		    (struct device_reg_24xx __iomem *)ha->iobase;
 
-	if (!IS_QLA2100(ha) && !IS_QLA2200(ha)) {
-		pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER, 0x80);
+		/* Get PCI bus information. */
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		ha->pci_attr = RD_REG_DWORD(&reg24->ctrl_status);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		/* PCI Specification Revision 2.3 changes */
-		if (IS_QLA2322(ha) || IS_QLA6322(ha))
-			/* Command Register - Reset Interrupt Disable. */
-			w &= ~PCI_COMMAND_INTX_DISABLE;
+		w &= ~PCI_COMMAND_INTX_DISABLE;
 
-		/*
-		 * If this is a 2300 card and not 2312, reset the
-		 * COMMAND_INVALIDATE due to a bug in the 2300. Unfortunately,
-		 * the 2310 also reports itself as a 2300 so we need to get the
-		 * fb revision level -- a 6 indicates it really is a 2300 and
-		 * not a 2310.
-		 */
-		if (IS_QLA2300(ha)) {
-			spin_lock_irqsave(&ha->hardware_lock, flags);
+		/* PCI-X -- adjust Maximum Memory Read Byte Count (2048). */
+		pcix_cmd_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_PCIX);
+		if (pcix_cmd_reg) {
+			uint16_t pcix_cmd;
+
+			pcix_cmd_reg += PCI_X_CMD;
+			pci_read_config_word(ha->pdev, pcix_cmd_reg,
+			    &pcix_cmd);
+			pcix_cmd &= ~PCI_X_CMD_MAX_READ;
+			pcix_cmd |= 0x0008;
+			pci_write_config_word(ha->pdev, pcix_cmd_reg,
+			    pcix_cmd);
+		}
+
+		/* PCIe -- adjust Maximum Read Request Size (2048). */
+		pcie_dctl_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+		if (pcie_dctl_reg) {
+			uint16_t pcie_dctl;
+
+			pcie_dctl_reg += PCI_EXP_DEVCTL;
+			pci_read_config_word(ha->pdev, pcie_dctl_reg,
+			    &pcie_dctl);
+			pcie_dctl &= ~PCI_EXP_DEVCTL_READRQ;
+			pcie_dctl |= 0x4000;
+			pci_write_config_word(ha->pdev, pcie_dctl_reg,
+			    pcie_dctl);
+		}
+	} else {
+		/* Get PCI bus information. */
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		ha->pci_attr = (uint32_t)RD_REG_WORD(&ha->iobase->ctrl_status);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-			/* Pause RISC. */
-			WRT_REG_WORD(&ha->iobase->hccr, HCCR_PAUSE_RISC);
-			for (cnt = 0; cnt < 30000; cnt++) {
-				if ((RD_REG_WORD(&ha->iobase->hccr) &
-				    HCCR_RISC_PAUSE) != 0)
-					break;
-	
-				udelay(10);
-			}
+		if (!IS_QLA2100(ha) && !IS_QLA2200(ha)) {
+			pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER,
+			    0x80);
 
-			/* Select FPM registers. */
-			WRT_REG_WORD(&ha->iobase->ctrl_status, 0x20);
-			RD_REG_WORD(&ha->iobase->ctrl_status);
+			/* PCI Specification Revision 2.3 changes */
+			if (IS_QLA2322(ha) || IS_QLA6322(ha))
+				/*
+				 * Command Register - Reset Interrupt Disable.
+				 */
+				w &= ~PCI_COMMAND_INTX_DISABLE;
 
-			/* Get the fb rev level */
-			ha->fb_rev = RD_FB_CMD_REG(ha, ha->iobase);
+			/*
+			 * If this is a 2300 card and not 2312, reset the
+			 * COMMAND_INVALIDATE due to a bug in the 2300.
+			 * Unfortunately, the 2310 also reports itself as a
+			 * 2300 so we need to get the fb revision level -- a 6
+			 * indicates it really is a 2300 and not a 2310.
+			 */
+			if (IS_QLA2300(ha)) {
+				spin_lock_irqsave(&ha->hardware_lock, flags);
 
-			if (ha->fb_rev == FPM_2300)
-				w &= ~PCI_COMMAND_INVALIDATE;
+				/* Pause RISC. */
+				WRT_REG_WORD(&ha->iobase->hccr,
+				    HCCR_PAUSE_RISC);
+				for (cnt = 0; cnt < 30000; cnt++) {
+					if ((RD_REG_WORD(&ha->iobase->hccr) &
+					    HCCR_RISC_PAUSE) != 0)
+						break;
 
-			/* Deselect FPM registers. */
-			WRT_REG_WORD(&ha->iobase->ctrl_status, 0x0);
-			RD_REG_WORD(&ha->iobase->ctrl_status);
+					udelay(10);
+				}
 
-			/* Release RISC module. */
-			WRT_REG_WORD(&ha->iobase->hccr, HCCR_RELEASE_RISC);
-			for (cnt = 0; cnt < 30000; cnt++) {
-				if ((RD_REG_WORD(&ha->iobase->hccr) &
-				    HCCR_RISC_PAUSE) == 0)
-					break;
-	
-				udelay(10);
-			}
+				/* Select FPM registers. */
+				WRT_REG_WORD(&ha->iobase->ctrl_status, 0x20);
+				RD_REG_WORD(&ha->iobase->ctrl_status);
+
+				/* Get the fb rev level */
+				ha->fb_rev = RD_FB_CMD_REG(ha, ha->iobase);
+
+				if (ha->fb_rev == FPM_2300)
+					w &= ~PCI_COMMAND_INVALIDATE;
+
+				/* Deselect FPM registers. */
+				WRT_REG_WORD(&ha->iobase->ctrl_status, 0x0);
+				RD_REG_WORD(&ha->iobase->ctrl_status);
+
+				/* Release RISC module. */
+				WRT_REG_WORD(&ha->iobase->hccr,
+				    HCCR_RELEASE_RISC);
+				for (cnt = 0; cnt < 30000; cnt++) {
+					if ((RD_REG_WORD(&ha->iobase->hccr) &
+					    HCCR_RISC_PAUSE) == 0)
+						break;
 
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+					udelay(10);
+				}
+
+				spin_unlock_irqrestore(&ha->hardware_lock,
+				    flags);
+			}
 		}
 	}
 
@@ -316,7 +374,9 @@ qla2x00_isp_firmware(scsi_qla_host_t *ha
 		qla_printk(KERN_INFO, ha, "RISC CODE NOT loaded\n");
 
 		/* Verify checksum of loaded RISC code. */
-		rval = qla2x00_verify_checksum(ha);
+		rval = qla2x00_verify_checksum(ha,
+		    IS_QLA24XX(ha) || IS_QLA25XX(ha) ? RISC_SADDRESS :
+		    *ha->brd_info->fw_info[0].fwstart);
 	}
 
 	if (rval) {
@@ -342,6 +402,59 @@ qla2x00_reset_chip(scsi_qla_host_t *ha) 
 	unsigned long	mbx_flags = 0;
 	uint16_t	cmd;
 
+
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		struct device_reg_24xx __iomem *reg24 =
+		    (struct device_reg_24xx __iomem *)ha->iobase;
+		uint32_t d2;
+
+		/* Disable ISP interrupts. */
+		qla2x00_disable_intrs(ha);
+
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+
+		/* Reset RISC. */
+		WRT_REG_DWORD(&reg24->ctrl_status,
+		    CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+		for (cnt = 0; cnt < 30000; cnt++) {
+			if ((RD_REG_DWORD(&reg24->ctrl_status) &
+			    CSRX_DMA_ACTIVE) == 0)
+				break;
+
+			udelay(10);
+		}
+
+		WRT_REG_DWORD(&reg24->ctrl_status,
+		    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+		udelay(20);
+		d2 = RD_REG_DWORD(&reg24->ctrl_status);
+		for (cnt = 6000000 ; cnt && (d2 & CSRX_ISP_SOFT_RESET); cnt--) {
+			udelay(5);
+			d2 = RD_REG_DWORD(&reg24->ctrl_status);
+			barrier();
+		}
+
+		WRT_REG_DWORD(&reg24->hccr, HCCRX_SET_RISC_RESET);
+		RD_REG_DWORD(&reg24->hccr);		/* PCI Posting. */
+
+		WRT_REG_DWORD(&reg24->hccr, HCCRX_REL_RISC_PAUSE);
+		RD_REG_DWORD(&reg24->hccr);		/* PCI Posting. */
+
+		WRT_REG_DWORD(&reg24->hccr, HCCRX_CLR_RISC_RESET);
+		RD_REG_DWORD(&reg24->hccr);		/* PCI Posting. */
+
+		d2 = (uint32_t) RD_REG_WORD(&reg24->mailbox0);
+		for (cnt = 6000000 ; cnt && d2; cnt--) {
+			udelay(5);
+			d2 = (uint32_t) RD_REG_WORD(&reg24->mailbox0);
+			barrier();
+		}
+
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		return;
+	}
+
 	/* Disable ISP interrupts. */
 	qla2x00_disable_intrs(ha);
 
@@ -497,6 +610,69 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 	uint32_t	cnt;
 	uint16_t	mb[5];
 
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		struct device_reg_24xx __iomem *reg24 =
+		    (struct device_reg_24xx __iomem *)ha->iobase;
+		uint32_t d2;
+
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+
+		/* Reset RISC. */
+		WRT_REG_DWORD(&reg24->ctrl_status,
+		    CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+		for (cnt = 0; cnt < 30000; cnt++) {
+			if ((RD_REG_DWORD(&reg24->ctrl_status) &
+			    CSRX_DMA_ACTIVE) == 0)
+				break;
+
+			udelay(10);
+		}
+
+		WRT_REG_DWORD(&reg24->ctrl_status,
+		    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+		udelay(20);
+		d2 = RD_REG_DWORD(&reg24->ctrl_status);
+		for (cnt = 6000000 ; cnt && (d2 & CSRX_ISP_SOFT_RESET); cnt--) {
+			udelay(5);
+			d2 = RD_REG_DWORD(&reg24->ctrl_status);
+			barrier();
+		}
+
+		WRT_REG_DWORD(&reg24->hccr, HCCRX_SET_RISC_RESET);
+		RD_REG_DWORD(&reg24->hccr);		/* PCI Posting. */
+
+		WRT_REG_DWORD(&reg24->hccr, HCCRX_REL_RISC_PAUSE);
+		RD_REG_DWORD(&reg24->hccr);		/* PCI Posting. */
+
+		WRT_REG_DWORD(&reg24->hccr, HCCRX_CLR_RISC_RESET);
+		RD_REG_DWORD(&reg24->hccr);		/* PCI Posting. */
+
+		d2 = (uint32_t) RD_REG_WORD(&reg24->mailbox0);
+		for (cnt = 6000000 ; cnt && d2; cnt--) {
+			udelay(5);
+			d2 = (uint32_t) RD_REG_WORD(&reg24->mailbox0);
+			barrier();
+		}
+
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		ha->fw_transfer_size = REQUEST_ENTRY_SIZE * 1024;
+
+		rval = qla2x00_mbx_reg_test(ha);
+		if (rval) {
+			DEBUG(printk("scsi(%ld): Failed mailbox send register "
+			    "test\n", ha->host_no));
+			qla_printk(KERN_WARNING, ha,
+			    "Failed mailbox send register test\n");
+		}
+		else {
+			/* Flag a successful rval */
+			rval = QLA_SUCCESS;
+		}
+
+		return rval;
+	}
+
 	/* Assume a failed state */
 	rval = QLA_FUNCTION_FAILED;
 
@@ -606,6 +782,24 @@ chip_diag_failed:
 	return (rval);
 }
 
+static void
+qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
+{
+	if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha))
+		return;
+
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
 /**
  * qla2x00_resize_request_q() - Resize request queue given available ISP memory.
  * @ha: HA context
@@ -621,6 +815,9 @@ qla2x00_resize_request_q(scsi_qla_host_t
 	dma_addr_t request_dma;
 	request_t *request_ring;
 
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		qla2x00_alloc_fw_dump(ha);
+
 	/* Valid only on recent ISPs. */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return;
@@ -668,87 +865,22 @@ qla2x00_resize_request_q(scsi_qla_host_t
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
+	rval = qla2x00_load_risc(ha, &srisc_address);
+	if (rval == QLA_SUCCESS) {
 		DEBUG(printk("scsi(%ld): Verifying Checksum of loaded RISC "
 		    "code.\n", ha->host_no));
 
-		rval = qla2x00_verify_checksum(ha);
+		rval = qla2x00_verify_checksum(ha, srisc_address);
 		if (rval == QLA_SUCCESS) {
 			/* Start firmware execution. */
 			DEBUG(printk("scsi(%ld): Checksum OK, start "
 			    "firmware.\n", ha->host_no));
 
-			rval = qla2x00_execute_fw(ha);
+			rval = qla2x00_execute_fw(ha, srisc_address);
 			/* Retrieve firmware information. */
 			if (rval == QLA_SUCCESS && ha->fw_major_version == 0) {
 				qla2x00_get_fw_version(ha,
@@ -812,6 +944,8 @@ qla2x00_update_fw_options(scsi_qla_host_
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return;
+	else if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		return qla24xx_update_fw_options(ha);
 
 	/* Serial Link options. */
 	DEBUG3(printk("scsi(%ld): Serial link options:\n",
@@ -909,23 +1043,53 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 	ha->rsp_ring_index    = 0;
 
 	/* Setup ring parameters in initialization control block. */
-	ha->init_cb->request_q_outpointer = __constant_cpu_to_le16(0);
-	ha->init_cb->response_q_inpointer = __constant_cpu_to_le16(0);
-	ha->init_cb->request_q_length = cpu_to_le16(ha->request_q_length);
-	ha->init_cb->response_q_length = cpu_to_le16(ha->response_q_length);
-	ha->init_cb->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
-	ha->init_cb->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
-	ha->init_cb->response_q_address[0] = cpu_to_le32(LSD(ha->response_dma));
-	ha->init_cb->response_q_address[1] = cpu_to_le32(MSD(ha->response_dma));
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		struct init_cb_24xx *icb24;
+
+		icb24 = (struct init_cb_24xx *)ha->init_cb;
+		icb24->request_q_outpointer = __constant_cpu_to_le16(0);
+		icb24->response_q_inpointer = __constant_cpu_to_le16(0);
+		icb24->request_q_length = cpu_to_le16(ha->request_q_length);
+		icb24->response_q_length = cpu_to_le16(ha->response_q_length);
+		icb24->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
+		icb24->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
+		icb24->response_q_address[0] =
+		    cpu_to_le32(LSD(ha->response_dma));
+		icb24->response_q_address[1] =
+		    cpu_to_le32(MSD(ha->response_dma));
+	} else {
+		init_cb_t *icb;
+
+		icb = ha->init_cb;
+		icb->request_q_outpointer = __constant_cpu_to_le16(0);
+		icb->response_q_inpointer = __constant_cpu_to_le16(0);
+		icb->request_q_length = cpu_to_le16(ha->request_q_length);
+		icb->response_q_length = cpu_to_le16(ha->response_q_length);
+		icb->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
+		icb->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
+		icb->response_q_address[0] = cpu_to_le32(LSD(ha->response_dma));
+		icb->response_q_address[1] = cpu_to_le32(MSD(ha->response_dma));
+	}
 
 	/* Initialize response queue entries */
 	qla2x00_init_response_q_entries(ha);
 
- 	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), 0);
- 	WRT_REG_WORD(ISP_REQ_Q_OUT(ha, reg), 0);
- 	WRT_REG_WORD(ISP_RSP_Q_IN(ha, reg), 0);
- 	WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), 0);
-	RD_REG_WORD(ISP_RSP_Q_OUT(ha, reg));		/* PCI Posting. */
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		struct device_reg_24xx __iomem *reg24 =
+		    (struct device_reg_24xx __iomem *) ha->iobase;
+
+		WRT_REG_DWORD(&reg24->req_q_in, 0);
+		WRT_REG_DWORD(&reg24->req_q_out, 0);
+		WRT_REG_DWORD(&reg24->rsp_q_in, 0);
+		WRT_REG_DWORD(&reg24->rsp_q_out, 0);
+		RD_REG_DWORD(&reg24->rsp_q_out);
+	} else {
+		WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), 0);
+		WRT_REG_WORD(ISP_REQ_Q_OUT(ha, reg), 0);
+		WRT_REG_WORD(ISP_RSP_Q_IN(ha, reg), 0);
+		WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), 0);
+		RD_REG_WORD(ISP_RSP_Q_OUT(ha, reg));
+	}
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -933,7 +1097,7 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 	qla2x00_update_fw_options(ha);
 
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
-	rval = qla2x00_init_firmware(ha, sizeof(init_cb_t));
+	rval = qla2x00_init_firmware(ha, ha->init_cb_size);
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Init firmware **** FAILED ****.\n",
 		    ha->host_no));
@@ -1168,38 +1332,36 @@ qla2x00_configure_hba(scsi_qla_host_t *h
 static int
 qla2x00_nvram_config(scsi_qla_host_t *ha)
 {
-	int   rval;
-	uint8_t   chksum = 0;
-	uint16_t  cnt;
-	uint8_t   *dptr1, *dptr2;
-	init_cb_t *icb   = ha->init_cb;
-	nvram_t *nv    = (nvram_t *)ha->request_ring;
-	uint16_t  *wptr  = (uint16_t *)ha->request_ring;
+	int		rval;
+	uint8_t		chksum = 0;
+	uint16_t	cnt;
+	uint8_t		*dptr1, *dptr2;
+	init_cb_t	*icb = ha->init_cb;
+	nvram_t		*nv = (nvram_t *)ha->request_ring;
+	uint8_t		*ptr = (uint8_t *)ha->request_ring;
 	device_reg_t __iomem *reg = ha->iobase;
-	uint8_t  timer_mode;
+	uint8_t		timer_mode;
+
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		return qla24xx_nvram_config(ha);
 
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
+	qla2x00_read_nvram_data(ha, ptr, ha->nvram_base, ha->nvram_size);
+	for (cnt = 0, chksum = 0; cnt < ha->nvram_size; cnt++)
+		chksum += *ptr++;
 
 	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", ha->host_no));
 	DEBUG5(qla2x00_dump_buffer((uint8_t *)ha->request_ring,
-	    sizeof(nvram_t)));
+	    ha->nvram_size));
 
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' ||
@@ -1214,7 +1376,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 		/*
 		 * Set default initialization control block.
 		 */
-		memset(nv, 0, sizeof(nvram_t));
+		memset(nv, 0, ha->nvram_size);
 		nv->parameter_block_version = ICB_VERSION;
 
 		if (IS_QLA23XX(ha)) {
@@ -1274,7 +1436,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 #endif
 
 	/* Reset Initialization control block */
-	memset(icb, 0, sizeof(init_cb_t));
+	memset(icb, 0, ha->init_cb_size);
 
 	/*
 	 * Setup driver NVRAM options.
@@ -1287,6 +1449,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	if (IS_QLA23XX(ha)) {
 		nv->firmware_options[0] |= BIT_2;
 		nv->firmware_options[0] &= ~BIT_3;
+		nv->add_firmware_options[1] |= BIT_5 | BIT_4;
 
 		if (IS_QLA2300(ha)) {
 			if (ha->fb_rev == FPM_2310) {
@@ -1387,7 +1550,8 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	ha->serial0 = icb->port_name[5];
 	ha->serial1 = icb->port_name[6];
 	ha->serial2 = icb->port_name[7];
-	memcpy(ha->node_name, icb->node_name, WWN_SIZE);
+	ha->node_name = icb->node_name;
+	ha->port_name = icb->port_name;
 
 	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
 
@@ -1702,12 +1866,16 @@ qla2x00_configure_local_loop(scsi_qla_ho
 			loop_id = (uint16_t)
 			    ((struct gid_list_info *)id_iter)->loop_id_2100;
 			id_iter += 4;
-		} else {
+		} else if (IS_QLA23XX(ha)) {
 			loop_id = le16_to_cpu(
 			    ((struct gid_list_info *)id_iter)->loop_id);
 			id_iter += 6;
+		} else /* if (IS_QLA24XX(ha)) */ {
+			loop_id = le16_to_cpu(
+			    ((struct gid_list_info *)id_iter)->loop_id);
+			id_iter += 8;
 		}
-
+ 
 		/* Bypass reserved domain fields. */
 		if ((domain & 0xf0) == 0xf0)
 			continue;
@@ -1917,10 +2085,15 @@ qla2x00_configure_fabric(scsi_qla_host_t
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
@@ -1937,12 +2110,16 @@ qla2x00_configure_fabric(scsi_qla_host_t
 	}
 	do {
 		/* Ensure we are logged into the SNS. */
-		qla2x00_login_fabric(ha, SIMPLE_NAME_SERVER, 0xff, 0xff, 0xfc,
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			loop_id = NPH_SNS;
+		else
+			loop_id = SIMPLE_NAME_SERVER;
+		qla2x00_login_fabric(ha, loop_id, 0xff, 0xff, 0xfc,
 		    mb, BIT_1 | BIT_0);
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2(qla_printk(KERN_INFO, ha,
 			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x "
-			    "mb[2]=%x mb[6]=%x mb[7]=%x\n", SIMPLE_NAME_SERVER,
+			    "mb[2]=%x mb[6]=%x mb[7]=%x\n", loop_id,
 			    mb[0], mb[1], mb[2], mb[6], mb[7]));
 			return (QLA_SUCCESS);
 		}
@@ -1993,7 +2170,10 @@ qla2x00_configure_fabric(scsi_qla_host_t
 				    fcport->port_type != FCT_BROADCAST) {
 
 					qla2x00_fabric_logout(ha,
-					    fcport->loop_id);
+					    fcport->loop_id,
+					    fcport->d_id.b.domain,
+					    fcport->d_id.b.area,
+					    fcport->d_id.b.al_pa);
 					fcport->loop_id = FC_NO_LOOP_ID;
 				}
 			}
@@ -2023,7 +2203,6 @@ qla2x00_configure_fabric(scsi_qla_host_t
 					break;
 				}
 			}
-
 			/* Login and update database */
 			qla2x00_fabric_dev_login(ha, fcport, &next_loopid);
 		}
@@ -2137,7 +2316,6 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 
 	/* Starting free loop ID. */
 	loop_id = ha->min_external_loopid;
-
 	for (; loop_id <= ha->last_loop_id; loop_id++) {
 		if (qla2x00_is_reserved_id(ha, loop_id))
 			continue;
@@ -2238,7 +2416,9 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 			    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
 			    fcport->port_type != FCT_INITIATOR &&
 			    fcport->port_type != FCT_BROADCAST) {
-				qla2x00_fabric_logout(ha, fcport->loop_id);
+				qla2x00_fabric_logout(ha, fcport->loop_id,
+				    fcport->d_id.b.domain, fcport->d_id.b.area,
+				    fcport->d_id.b.al_pa);
 				fcport->loop_id = FC_NO_LOOP_ID;
 			}
 
@@ -2421,6 +2601,7 @@ qla2x00_device_resync(scsi_qla_host_t *h
 		case 0:
 			if (!IS_QLA2100(ha) && !IS_QLA2200(ha) &&
 			    !IS_QLA6312(ha) && !IS_QLA6322(ha) &&
+			    !IS_QLA24XX(ha) && !IS_QLA25XX(ha) &&
 			    ha->flags.init_done) {
 				/* Handle port RSCN via asyncronous IOCBs */
 				rval2 = qla2x00_handle_port_rscn(ha, rscn_entry,
@@ -2489,15 +2670,23 @@ qla2x00_fabric_dev_login(scsi_qla_host_t
 {
 	int	rval;
 	int	retry;
+	uint8_t	opts;
 
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
-			qla2x00_fabric_logout(ha, fcport->loop_id);
+			qla2x00_fabric_logout(ha, fcport->loop_id,
+			    fcport->d_id.b.domain, fcport->d_id.b.area,
+			    fcport->d_id.b.al_pa);
+			qla2x00_mark_device_lost(ha, fcport, 1);
 		} else {
 			qla2x00_update_fcport(ha, fcport);
 		}
@@ -2545,10 +2734,10 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
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
@@ -2602,7 +2791,9 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 			 * dead.
 			 */
 			*next_loopid = fcport->loop_id;
-			qla2x00_fabric_logout(ha, fcport->loop_id);
+			qla2x00_fabric_logout(ha, fcport->loop_id,
+			    fcport->d_id.b.domain, fcport->d_id.b.area,
+			    fcport->d_id.b.al_pa);
 			qla2x00_mark_device_lost(ha, fcport, 1);
 
 			rval = 1;
@@ -2618,7 +2809,9 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 			    fcport->d_id.b.al_pa, fcport->loop_id, jiffies));
 
 			*next_loopid = fcport->loop_id;
-			qla2x00_fabric_logout(ha, fcport->loop_id);
+			qla2x00_fabric_logout(ha, fcport->loop_id,
+			    fcport->d_id.b.domain, fcport->d_id.b.area,
+			    fcport->d_id.b.al_pa);
 			fcport->loop_id = FC_NO_LOOP_ID;
 			atomic_set(&fcport->state, FCS_DEVICE_DEAD);
 
@@ -2688,14 +2881,11 @@ qla2x00_loop_resync(scsi_qla_host_t *ha)
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
@@ -2828,7 +3018,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 				} else { /* schedule another ISP abort */
 					ha->isp_abort_cnt--;
 					DEBUG(printk("qla%ld: ISP abort - "
-					    "retry remainning %d\n",
+					    "retry remaining %d\n",
 					    ha->host_no, ha->isp_abort_cnt);)
 					status = 1;
 				}
@@ -2887,9 +3077,15 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 
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
 	
@@ -2897,16 +3093,21 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 
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
@@ -2917,9 +3118,11 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
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
@@ -2960,11 +3163,537 @@ qla2x00_reset_adapter(scsi_qla_host_t *h
 	ha->flags.online = 0;
 	qla2x00_disable_intrs(ha);
 
-	/* Reset RISC processor. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
-	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
-	WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
-	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
+	/* Reset RISC processor. */
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		struct device_reg_24xx __iomem *reg24 =
+		    (struct device_reg_24xx __iomem *)ha->iobase;
+		WRT_REG_DWORD(&reg24->hccr, HCCRX_SET_RISC_RESET);
+		RD_REG_DWORD(&reg24->hccr);		/* PCI Posting. */
+		WRT_REG_DWORD(&reg24->hccr, HCCRX_REL_RISC_PAUSE);
+		RD_REG_DWORD(&reg24->hccr);		/* PCI Posting. */
+	} else {
+		WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
+		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
+		WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
+		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
+	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
+
+static int
+qla24xx_nvram_config(scsi_qla_host_t *ha)
+{
+	int   rval;
+	struct init_cb_24xx *icb;
+	struct nvram_24xx *nv;
+	uint32_t *dptr;
+	uint8_t  *dptr1, *dptr2;
+	struct device_reg_24xx __iomem *reg;
+	uint32_t chksum;
+	uint16_t cnt;
+
+	rval = QLA_SUCCESS;
+	icb = (struct init_cb_24xx *)ha->init_cb;
+	reg = (struct device_reg_24xx __iomem *)ha->iobase;
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
+	qla2x00_read_nvram_data(ha, (uint8_t *)dptr, ha->nvram_base,
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
+static int
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
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		if (ql2xfwloadbin)
+			return qla24xx_load_risc_hotplug(ha, srisc_addr);
+		else
+			return qla24xx_load_risc_flash(ha, srisc_addr);
+	}
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
+/* NOTE: ISP24XX
+ *
+ * Firmware image is written to flash via the .bin file which is in big-endian
+ * format.
+ */
+
+static int
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
+static int
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
+			    "Unable to verify integrity of flash firmware image "
+			    "(%Zd)!\n", fw_entry->size);
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
+
+static void
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
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -288,6 +288,27 @@ qla2x00_delete_timer_from_cmd(srb_t *sp)
 	}
 }
 
+static inline uint8_t *host_to_fcp_swap(uint8_t *, uint32_t);
+
+/**
+ * host_to_fcp_swap() - 
+ * @fcp: 
+ * @bsize: 
+ *
+ * Returns 
+ */
+static inline uint8_t *
+host_to_fcp_swap(uint8_t *fcp, uint32_t bsize)
+{
+	uint32_t *ifcp = (uint32_t *) fcp;
+	uint32_t *ofcp = (uint32_t *) fcp;
+	uint32_t iter = bsize >> 2;
+
+	for (; iter ; iter--)
+		*ofcp++ = swab32(*ifcp++);
+
+	return (fcp);
+}
 
 static inline int qla2x00_is_reserved_id(scsi_qla_host_t *, uint16_t);
 static inline int
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -83,6 +83,11 @@ static void qla2x00_free_device(scsi_qla
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
 
+int ql2xfwloadbin;
+module_param(ql2xfwloadbin, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xfwloadbin,
+		"");
+
 /*
  * SCSI host template entry points 
  */
@@ -180,24 +185,61 @@ void qla2x00_sp_compl(scsi_qla_host_t *h
 static char *
 qla2x00_get_pci_info_str(struct scsi_qla_host *ha, char *str)
 {
-	static char *pci_bus_modes[] = {
-		"33", "66", "100", "133",
-	};
-	uint16_t pci_bus;
+	static char *pci_bus_modes[] = { "33", "66", "100", "133", };
+	uint32_t pci_bus;
+	int pcie_reg;
+
+	pcie_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+	if (pcie_reg) {
+		char lwstr[6];
+		uint16_t pcie_lstat, lspeed, lwidth;
+
+		pcie_reg += 0x12;
+		pci_read_config_word(ha->pdev, pcie_reg, &pcie_lstat);
+		lspeed = pcie_lstat & (BIT_0 | BIT_1 | BIT_2 | BIT_3);
+		lwidth = (pcie_lstat &
+		    (BIT_4 | BIT_5 | BIT_6 | BIT_7 | BIT_8 | BIT_9)) >> 4;
+
+		strcpy(str, "PCIe (");
+		if (lspeed == 1)
+			strcat(str, "2.5Gb/s ");
+		else
+			strcat(str, "<unknown> ");
+		snprintf(lwstr, sizeof(lwstr), "x%d)", lwidth);
+		strcat(str, lwstr);
+
+		return str;
+	}
 
 	strcpy(str, "PCI");
-	pci_bus = (ha->pci_attr & (BIT_9 | BIT_10)) >> 9;
-	if (pci_bus) {
-		strcat(str, "-X (");
-		strcat(str, pci_bus_modes[pci_bus]);
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		pci_bus = (ha->pci_attr & CSRX_PCIX_BUS_MODE_MASK) >> 8;
+		if (pci_bus == 0 || pci_bus == 8) {
+			strcat(str, " (");
+			strcat(str, pci_bus_modes[pci_bus >> 3]);
+		} else {
+			strcat(str, "-X ");
+			if (pci_bus & BIT_2)
+				strcat(str, "Mode 2");
+			else
+				strcat(str, "Mode 1");
+			strcat(str, " (");
+			strcat(str, pci_bus_modes[pci_bus & ~BIT_2]);
+		}
 	} else {
-		pci_bus = (ha->pci_attr & BIT_8) >> 8;
-		strcat(str, " (");
-		strcat(str, pci_bus_modes[pci_bus]);
+		pci_bus = (ha->pci_attr & (BIT_9 | BIT_10)) >> 9;
+		if (pci_bus) {
+			strcat(str, "-X (");
+			strcat(str, pci_bus_modes[pci_bus]);
+		} else {
+			pci_bus = (ha->pci_attr & BIT_8) >> 8;
+			strcat(str, " (");
+			strcat(str, pci_bus_modes[pci_bus]);
+		}
 	}
 	strcat(str, " MHz)");
 
-	return (str);
+	return str;
 }
 
 char *
@@ -209,9 +251,21 @@ qla2x00_get_fw_version_str(struct scsi_q
 	    ha->fw_minor_version,
 	    ha->fw_subminor_version);
 
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		if (ha->fw_attributes & BIT_0)
+			strcat(str, "[Class 2] ");
+		if (ha->fw_attributes & BIT_1)
+			strcat(str, "[IP] ");
+		if (ha->fw_attributes & BIT_2)
+			strcat(str, "[Multi-ID] ");
+		if (ha->fw_attributes & BIT_13)
+			strcat(str, "[Experimental] ");
+		return str;
+	}
+
 	if (ha->fw_attributes & BIT_9) {
 		strcat(str, "FLX");
-		return (str);
+		return str;
 	}
 
 	switch (ha->fw_attributes & 0xFF) {
@@ -235,7 +289,7 @@ qla2x00_get_fw_version_str(struct scsi_q
 	if (ha->fw_attributes & 0x100)
 		strcat(str, "X");
 
-	return (str);
+	return str;
 }
 
 /**************************************************************************
@@ -294,7 +348,7 @@ qla2x00_queuecommand(struct scsi_cmnd *c
 	CMD_SP(cmd) = (void *)sp;
 	cmd->scsi_done = done;
 
-	rval = qla2x00_start_scsi(sp);
+	rval = ha->start_scsi(sp);
 	if (rval != QLA_SUCCESS)
 		goto qc_host_busy_free_sp;
 
@@ -385,8 +439,8 @@ qla2x00_eh_wait_on_command(scsi_qla_host
 static int 
 qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
 {
-	int 	 return_status;
-	unsigned long wait_online;
+	int		return_status;
+	unsigned long	wait_online;
 
 	wait_online = jiffies + (MAX_LOOP_TIMEOUT * HZ); 
 	while (((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) ||
@@ -629,7 +683,9 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 #if defined(LOGOUT_AFTER_DEVICE_RESET)
 		if (ret == SUCCESS) {
 			if (fcport->flags & FC_FABRIC_DEVICE) {
-				qla2x00_fabric_logout(ha, fcport->loop_id);
+				qla2x00_fabric_logout(ha, fcport->loop_id,
+				    fcport->d_id.b.domain, fcport->d_id.b.area,
+				    fcport->d_id.b.al_pa);
 				qla2x00_mark_device_lost(ha, fcport);
 			}
 		}
@@ -1108,6 +1164,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 {
 	int	ret = -ENODEV;
 	device_reg_t __iomem *reg;
+	struct device_reg_24xx __iomem *reg24;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
 	unsigned long	flags = 0;
@@ -1142,18 +1199,17 @@ int qla2x00_probe_one(struct pci_dev *pd
 	if (ret)
 		goto probe_failed;
 
-	/* Sanitize the information from PCI BIOS. */
-	host->irq = pdev->irq;
-
 	qla_printk(KERN_INFO, ha,
 	    "Found an %s, irq %d, iobase 0x%p\n", ha->brd_info->isp_name,
-	    host->irq, ha->iobase);
+	    pdev->irq, ha->iobase);
 
 	spin_lock_init(&ha->hardware_lock);
 
 	ha->prev_topology = 0;
 	ha->ports = MAX_BUSES;
 
+	ha->init_cb_size = sizeof(init_cb_t);
+	ha->start_scsi = qla2x00_start_scsi;
 	if (IS_QLA2100(ha)) {
 		host->max_id = MAX_TARGETS_2100;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT_2100;
@@ -1167,12 +1223,20 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
-	} else /*if (IS_QLA2300(ha))*/ {
+	} else if (IS_QLA23XX(ha)) {
 		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+	} else if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		host->max_id = MAX_TARGETS_2200;
+		ha->mbx_count = MAILBOX_REGISTER_COUNT;
+		ha->request_q_length = REQUEST_ENTRY_CNT_24XX;
+		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
+		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+		ha->init_cb_size = sizeof(struct init_cb_24xx);
+		ha->start_scsi = qla24xx_start_scsi;
 	}
 	host->can_queue = ha->request_q_length + 128;
 
@@ -1243,18 +1307,23 @@ int qla2x00_probe_one(struct pci_dev *pd
 	host->max_lun = MAX_LUNS;
 	host->transportt = qla2xxx_transport_template;
 
+	/* Register ISR. */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
-		ret = request_irq(host->irq, qla2100_intr_handler,
+		ret = request_irq(pdev->irq, qla2100_intr_handler,
+		    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
+	else if (IS_QLA23XX(ha))
+		ret = request_irq(pdev->irq, qla2300_intr_handler,
 		    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
 	else
-		ret = request_irq(host->irq, qla2300_intr_handler,
+		ret = request_irq(pdev->irq, qla24xx_intr_handler,
 		    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
-	if (ret) {
+	if (ret != 0) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
-		    host->irq);
+		    pdev->irq);
 		goto probe_failed;
 	}
+	host->irq = pdev->irq;
 
 	/* Initialized the timer */
 	qla2x00_start_timer(ha, qla2x00_timer, WATCH_INTERVAL);
@@ -1262,27 +1331,35 @@ int qla2x00_probe_one(struct pci_dev *pd
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
 	    ha->host_no, ha));
 
-	reg = ha->iobase;
-
 	/* Disable ISP interrupts. */
 	qla2x00_disable_intrs(ha);
 
-	/* Ensure mailbox registers are free. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	WRT_REG_WORD(&reg->semaphore, 0);
-	WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-	WRT_REG_WORD(&reg->hccr, HCCR_CLR_HOST_INT);
-
-	/* Enable proper parity */
-	if (!IS_QLA2100(ha) && !IS_QLA2200(ha)) {
-		if (IS_QLA2300(ha))
-			/* SRAM parity */
-			WRT_REG_WORD(&reg->hccr, (HCCR_ENABLE_PARITY + 0x1));
-		else
-			/* SRAM, Instruction RAM and GP RAM parity */
-			WRT_REG_WORD(&reg->hccr, (HCCR_ENABLE_PARITY + 0x7));
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		reg24 = (struct device_reg_24xx __iomem *)ha->iobase;
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		WRT_REG_DWORD(&reg24->hccr, HCCRX_CLR_HOST_INT);
+		WRT_REG_DWORD(&reg24->hccr, HCCRX_CLR_RISC_INT);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	} else {
+		reg = ha->iobase;
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		WRT_REG_WORD(&reg->semaphore, 0);
+		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
+		WRT_REG_WORD(&reg->hccr, HCCR_CLR_HOST_INT);
+
+		/* Enable proper parity */
+		if (!IS_QLA2100(ha) && !IS_QLA2200(ha)) {
+			if (IS_QLA2300(ha))
+				/* SRAM parity */
+				WRT_REG_WORD(&reg->hccr,
+				    (HCCR_ENABLE_PARITY + 0x1));
+			else
+				/* SRAM, Instruction RAM and GP RAM parity */
+				WRT_REG_WORD(&reg->hccr,
+				    (HCCR_ENABLE_PARITY + 0x7));
+		}
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Enable chip interrupts. */
 	qla2x00_enable_intrs(ha);
@@ -1321,7 +1398,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	    "  %s: %s @ %s hdma%c, host#=%ld, fw=%s\n", qla2x00_version_str,
 	    ha->model_number, ha->model_desc ? ha->model_desc: "",
 	    ha->brd_info->isp_name, qla2x00_get_pci_info_str(ha, pci_info),
-	    pci_name(ha->pdev), ha->flags.enable_64bit_addressing ? '+': '-',
+	    pci_name(pdev), ha->flags.enable_64bit_addressing ? '+': '-',
 	    ha->host_no, qla2x00_get_fw_version_str(ha, fw_str));
 
 	/* Go with fc_rport registration. */
@@ -1606,7 +1683,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 
 			continue;
 		}
-		memset(ha->init_cb, 0, sizeof(init_cb_t));
+		memset(ha->init_cb, 0, ha->init_cb_size);
 
 		/* Get consistent memory allocated for Get Port Database cmd */
 		ha->iodesc_pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
@@ -1818,10 +1895,15 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	if (ha->fw_dump)
 		free_pages((unsigned long)ha->fw_dump, ha->fw_dump_order);
 
+	if (ha->fw_dump24)
+		vfree(ha->fw_dump24);
+
 	if (ha->fw_dump_buffer)
 		vfree(ha->fw_dump_buffer);
 
 	ha->fw_dump = NULL;
+	ha->fw_dump24 = NULL;
+	ha->fw_dumped = 0;
 	ha->fw_dump_reading = 0;
 	ha->fw_dump_buffer = NULL;
 }
@@ -1983,7 +2065,10 @@ qla2x00_do_dpc(void *data)
 						    FCF_TAPE_PRESENT)
 							qla2x00_fabric_logout(
 							    ha,
-							    fcport->loop_id);
+							    fcport->loop_id,
+							    fcport->d_id.b.domain,
+							    fcport->d_id.b.area,
+							    fcport->d_id.b.al_pa);
 						status = qla2x00_fabric_login(
 						    ha, fcport, &next_loopid);
 					} else
@@ -2194,7 +2279,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 				atomic_set(&fcport->state, FCS_DEVICE_DEAD);
 			
 			DEBUG(printk("scsi(%ld): fcport-%d - port retry count: "
-			    "%d remainning\n",
+			    "%d remaining\n",
 			    ha->host_no,
 			    t, atomic_read(&fcport->port_down_timer)));
 		}
@@ -2257,7 +2342,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			}
 		}
-		DEBUG3(printk("scsi(%ld): Loop Down - seconds remainning %d\n",
+		DEBUG3(printk("scsi(%ld): Loop Down - seconds remaining %d\n",
 		    ha->host_no,
 		    atomic_read(&ha->loop_down_timer)));
 	}
@@ -2294,12 +2379,66 @@ qla2x00_down_timeout(struct semaphore *s
 	return -ETIMEDOUT;
 }
 
+static struct qla_board_info qla_board_tbl[] = {
+	{
+		.drv_name	= "qla2400",
+		.isp_name	= "ISP2422",
+		.fw_fname	= "ql2400_fw.bin",
+	},
+	{
+		.drv_name	= "qla2400",
+		.isp_name	= "ISP2432",
+		.fw_fname	= "ql2400_fw.bin",
+	},
+};
+
+static struct pci_device_id qla2xxx_pci_tbl[] = {
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP2422,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[0],
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP2432,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[1],
+	},
+	{0, 0},
+};
+MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
+
+static int __devinit
+qla2xxx_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	return qla2x00_probe_one(pdev,
+	    (struct qla_board_info *)id->driver_data);
+}
+
+static void __devexit
+qla2xxx_remove_one(struct pci_dev *pdev)
+{
+	qla2x00_remove_one(pdev);
+}
+
+static struct pci_driver qla2xxx_pci_driver = {
+	.name		= "qla2xxx",
+	.id_table	= qla2xxx_pci_tbl,
+	.probe		= qla2xxx_probe_one,
+	.remove		= __devexit_p(qla2xxx_remove_one),
+};
+
 /**
  * qla2x00_module_init - Module initialization.
  **/
 static int __init
 qla2x00_module_init(void)
 {
+	int ret = 0;
+
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
 	    SLAB_HWCACHE_ALIGN, NULL, NULL);
@@ -2320,7 +2459,12 @@ qla2x00_module_init(void)
 		return -ENODEV;
 
 	printk(KERN_INFO "QLogic Fibre Channel HBA Driver\n");
-	return 0;
+	ret = pci_module_init(&qla2xxx_pci_driver);
+	if (ret) {
+		kmem_cache_destroy(srb_cachep);
+		fc_release_transport(qla2xxx_transport_template);
+	}
+	return ret;
 }
 
 /**
@@ -2329,6 +2473,7 @@ qla2x00_module_init(void)
 static void __exit
 qla2x00_module_exit(void)
 {
+	pci_unregister_driver(&qla2xxx_pci_driver);
 	kmem_cache_destroy(srb_cachep);
 	fc_release_transport(qla2xxx_transport_template);
 }
------------

-- 
Andrew Vasquez
