From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/17]  qla2xxx: Factor-out ISP specific functions to method-based call tables.
Date: Wed,  6 Jul 2005 10:30:05 -0700 (PDT)
Message-ID: <20050706173005.10568.50882.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:41038 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262400AbVGFRaL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:30:11 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Factor-out ISP specific functions to method-based call tables.

In anticipation of ISP24xx/ISP25xx support, factor-out ISP
specific functions into a method-based call table.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_attr.c   |    5 -
 drivers/scsi/qla2xxx/qla_dbg.c    |    4 -
 drivers/scsi/qla2xxx/qla_def.h    |   46 ++++++-
 drivers/scsi/qla2xxx/qla_gbl.h    |   13 ++
 drivers/scsi/qla2xxx/qla_gs.c     |    5 -
 drivers/scsi/qla2xxx/qla_init.c   |  252 ++++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_inline.h |   39 ------
 drivers/scsi/qla2xxx/qla_iocb.c   |    4 -
 drivers/scsi/qla2xxx/qla_isr.c    |    5 -
 drivers/scsi/qla2xxx/qla_os.c     |  101 +++++++++++----
 10 files changed, 275 insertions(+), 199 deletions(-)

cbb4eeb0e8f2b44b671834ce8ba67fec8b624cff
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -93,10 +93,7 @@ qla2x00_sysfs_write_fw_dump(struct kobje
 			    "Firmware dump ready for read on (%ld).\n",
 			    ha->host_no);
 			memset(ha->fw_dump_buffer, 0, dump_size);
-			if (IS_QLA2100(ha) || IS_QLA2200(ha))
- 				qla2100_ascii_fw_dump(ha);
- 			else
- 				qla2300_ascii_fw_dump(ha);
+			ha->isp_ops.ascii_fw_dump(ha);
 			ha->fw_dump_buffer_len = strlen(ha->fw_dump_buffer);
 		}
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -405,7 +405,7 @@ qla2300_ascii_fw_dump(scsi_qla_host_t *h
 	fw = ha->fw_dump;
 
 	qla_uprintf(&uiter, "%s Firmware Version %s\n", ha->model_number,
-	    qla2x00_get_fw_version_str(ha, fw_info));
+	    ha->isp_ops.fw_version_str(ha, fw_info));
 
 	qla_uprintf(&uiter, "\n[==>BEG]\n");
 
@@ -819,7 +819,7 @@ qla2100_ascii_fw_dump(scsi_qla_host_t *h
 	fw = ha->fw_dump;
 
 	qla_uprintf(&uiter, "%s Firmware Version %s\n", ha->model_number,
-	    qla2x00_get_fw_version_str(ha, fw_info));
+	    ha->isp_ops.fw_version_str(ha, fw_info));
 
 	qla_uprintf(&uiter, "\n[==>BEG]\n");
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -33,6 +33,7 @@
 #include <linux/mempool.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
+#include <linux/interrupt.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
@@ -1950,6 +1951,47 @@ struct gid_list_info {
 #define GID_LIST_SIZE (sizeof(struct gid_list_info) * MAX_FIBRE_DEVICES)
 
 /*
+ * ISP operations
+ */
+struct isp_operations {
+
+	int (*pci_config) (struct scsi_qla_host *);
+	void (*reset_chip) (struct scsi_qla_host *);
+	int (*chip_diag) (struct scsi_qla_host *);
+	void (*config_rings) (struct scsi_qla_host *);
+	void (*reset_adapter) (struct scsi_qla_host *);
+	int (*nvram_config) (struct scsi_qla_host *);
+	void (*update_fw_options) (struct scsi_qla_host *);
+	int (*load_risc) (struct scsi_qla_host *, uint32_t *);
+
+	char * (*pci_info_str) (struct scsi_qla_host *, char *);
+	char * (*fw_version_str) (struct scsi_qla_host *, char *);
+
+	irqreturn_t (*intr_handler) (int, void *, struct pt_regs *);
+	void (*enable_intrs) (struct scsi_qla_host *);
+	void (*disable_intrs) (struct scsi_qla_host *);
+
+	int (*abort_command) (struct scsi_qla_host *, srb_t *);
+	int (*abort_target) (struct fc_port *);
+	int (*fabric_login) (struct scsi_qla_host *, uint16_t, uint8_t,
+		uint8_t, uint8_t, uint16_t *, uint8_t);
+	int (*fabric_logout) (struct scsi_qla_host *, uint16_t);
+
+	uint16_t (*calc_req_entries) (uint16_t);
+	void (*build_iocbs) (srb_t *, cmd_entry_t *, uint16_t);
+	ms_iocb_entry_t * (*prep_ms_iocb) (struct scsi_qla_host *, uint32_t,
+	    uint32_t);
+
+	uint8_t * (*read_nvram) (struct scsi_qla_host *, uint8_t *,
+		uint32_t, uint32_t);
+	int (*write_nvram) (struct scsi_qla_host *, uint8_t *, uint32_t,
+		uint32_t);
+
+	void (*fw_dump) (struct scsi_qla_host *, int);
+	void (*ascii_fw_dump) (struct scsi_qla_host *);
+};
+
+/*
  * Linux Host Adapter structure
  */
 typedef struct scsi_qla_host {
@@ -2055,8 +2097,7 @@ typedef struct scsi_qla_host {
 	uint16_t        rsp_ring_index;     /* Current index. */
 	uint16_t	response_q_length;
     
-	uint16_t	(*calc_request_entries)(uint16_t);
-	void		(*build_scsi_iocbs)(srb_t *, cmd_entry_t *, uint16_t);
+	struct isp_operations isp_ops;
 
 	/* Outstandings ISP commands. */
 	srb_t		*outstanding_cmds[MAX_OUTSTANDING_COMMANDS];
@@ -2149,6 +2190,7 @@ typedef struct scsi_qla_host {
 
 	dma_addr_t	gid_list_dma;
 	struct gid_list_info *gid_list;
+	int		gid_list_info_size;
 
 	dma_addr_t	rlc_rsp_dma;
 	rpt_lun_cmd_rsp_t *rlc_rsp;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -32,6 +32,17 @@ extern int qla2x00_probe_one(struct pci_
  * Global Function Prototypes in qla_init.c source file.
  */
 extern int qla2x00_initialize_adapter(scsi_qla_host_t *);
+
+extern int qla2100_pci_config(struct scsi_qla_host *);
+extern int qla2300_pci_config(struct scsi_qla_host *);
+extern void qla2x00_reset_chip(struct scsi_qla_host *);
+extern int qla2x00_chip_diag(struct scsi_qla_host *);
+extern void qla2x00_config_rings(struct scsi_qla_host *);
+extern void qla2x00_reset_adapter(struct scsi_qla_host *);
+extern int qla2x00_nvram_config(struct scsi_qla_host *);
+extern void qla2x00_update_fw_options(struct scsi_qla_host *);
+extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
+
 extern fc_port_t *qla2x00_alloc_fcport(scsi_qla_host_t *, int);
 
 extern int qla2x00_loop_resync(scsi_qla_host_t *);
@@ -205,6 +216,8 @@ extern void qla2x00_print_scsi_cmd(struc
 /*
  * Global Function Prototypes in qla_gs.c source file.
  */
+extern ms_iocb_entry_t *qla2x00_prep_ms_iocb(scsi_qla_host_t *, uint32_t,
+    uint32_t);
 extern int qla2x00_ga_nxt(scsi_qla_host_t *, fc_port_t *);
 extern int qla2x00_gid_pt(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_gpn_id(scsi_qla_host_t *, sw_info_t *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -18,9 +18,6 @@
  */
 #include "qla_def.h"
 
-static inline ms_iocb_entry_t *
-qla2x00_prep_ms_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
-
 static inline struct ct_sns_req *
 qla2x00_prep_ct_req(struct ct_sns_req *, uint16_t, uint16_t);
 
@@ -42,7 +39,7 @@ static int qla2x00_sns_rnn_id(scsi_qla_h
  *
  * Returns a pointer to the @ha's ms_iocb.
  */
-static inline ms_iocb_entry_t *
+ms_iocb_entry_t *
 qla2x00_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t req_size, uint32_t rsp_size)
 {
 	ms_iocb_entry_t *ms_pkt;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -34,17 +34,13 @@
 /*
 *  QLogic ISP2x00 Hardware Support Function Prototypes.
 */
-static int qla2x00_pci_config(scsi_qla_host_t *);
 static int qla2x00_isp_firmware(scsi_qla_host_t *);
-static void qla2x00_reset_chip(scsi_qla_host_t *);
-static int qla2x00_chip_diag(scsi_qla_host_t *);
 static void qla2x00_resize_request_q(scsi_qla_host_t *);
 static int qla2x00_setup_chip(scsi_qla_host_t *);
 static void qla2x00_init_response_q_entries(scsi_qla_host_t *);
 static int qla2x00_init_rings(scsi_qla_host_t *);
 static int qla2x00_fw_ready(scsi_qla_host_t *);
 static int qla2x00_configure_hba(scsi_qla_host_t *);
-static int qla2x00_nvram_config(scsi_qla_host_t *);
 static int qla2x00_configure_loop(scsi_qla_host_t *);
 static int qla2x00_configure_local_loop(scsi_qla_host_t *);
 static void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
@@ -55,7 +51,6 @@ static int qla2x00_fabric_dev_login(scsi
     uint16_t *);
 
 static int qla2x00_restart_isp(scsi_qla_host_t *);
-static void qla2x00_reset_adapter(scsi_qla_host_t *);
 
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
@@ -92,17 +87,17 @@ qla2x00_initialize_adapter(scsi_qla_host
 	ha->isp_abort_cnt = 0;
 	ha->beacon_blink_led = 0;
 
-	rval = qla2x00_pci_config(ha);
+	rval = ha->isp_ops.pci_config(ha);
 	if (rval) {
 		DEBUG2(printk("scsi(%ld): Unable to configure PCI space=n",
 		    ha->host_no));
 		return (rval);
 	}
 
-	qla2x00_reset_chip(ha);
+	ha->isp_ops.reset_chip(ha);
 
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
-	qla2x00_nvram_config(ha);
+	ha->isp_ops.nvram_config(ha);
 
 	qla_printk(KERN_INFO, ha, "Verifying loaded RISC code...\n");
 
@@ -115,7 +110,7 @@ qla2x00_initialize_adapter(scsi_qla_host
 
 		/* If firmware needs to be loaded */
 		if (qla2x00_isp_firmware(ha) != QLA_SUCCESS) {
-			if ((rval = qla2x00_chip_diag(ha)) == QLA_SUCCESS) {
+			if ((rval = ha->isp_ops.chip_diag(ha)) == QLA_SUCCESS) {
 				rval = qla2x00_setup_chip(ha);
 			}
 		}
@@ -190,110 +185,130 @@ check_fw_ready_again:
 }
 
 /**
- * qla2x00_pci_config() - Setup device PCI configuration registers.
+ * qla2100_pci_config() - Setup ISP21xx PCI configuration registers.
  * @ha: HA context
  *
  * Returns 0 on success.
  */
-static int
-qla2x00_pci_config(scsi_qla_host_t *ha)
+int
+qla2100_pci_config(scsi_qla_host_t *ha)
 {
-	uint16_t	w, mwi;
-	unsigned long   flags = 0;
-	uint32_t	cnt;
+	uint16_t w, mwi;
+	unsigned long flags;
 
 	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
 
-	/* 
-	 * Turn on PCI master; for system BIOSes that don't turn it on by
-	 * default.
-	 */
 	pci_set_master(ha->pdev);
 	mwi = 0;
 	if (pci_set_mwi(ha->pdev))
 		mwi = PCI_COMMAND_INVALIDATE;
 	pci_read_config_word(ha->pdev, PCI_REVISION_ID, &ha->revision);
 
-	if (!ha->iobase)
-		return (QLA_FUNCTION_FAILED);
-
-	/*
-	 * We want to respect framework's setting of PCI configuration space
-	 * command register and also want to make sure that all bits of
-	 * interest to us are properly set in command register.
-	 */
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
 	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
+
+	/* Reset expansion ROM address decode enable */
+	pci_read_config_word(ha->pdev, PCI_ROM_ADDRESS, &w);
+	w &= ~PCI_ROM_ADDRESS_ENABLE;
+	pci_write_config_word(ha->pdev, PCI_ROM_ADDRESS, w);
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->pci_attr = RD_REG_WORD(&ha->iobase->ctrl_status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	if (!IS_QLA2100(ha) && !IS_QLA2200(ha)) {
-		pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER, 0x80);
+	return QLA_SUCCESS;
+}
 
-		/* PCI Specification Revision 2.3 changes */
-		if (IS_QLA2322(ha) || IS_QLA6322(ha))
-			/* Command Register - Reset Interrupt Disable. */
-			w &= ~PCI_COMMAND_INTX_DISABLE;
+/**
+ * qla2300_pci_config() - Setup ISP23xx PCI configuration registers.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+int
+qla2300_pci_config(scsi_qla_host_t *ha)
+{
+	uint16_t	w, mwi;
+	unsigned long   flags = 0;
+	uint32_t	cnt;
 
-		/*
-		 * If this is a 2300 card and not 2312, reset the
-		 * COMMAND_INVALIDATE due to a bug in the 2300. Unfortunately,
-		 * the 2310 also reports itself as a 2300 so we need to get the
-		 * fb revision level -- a 6 indicates it really is a 2300 and
-		 * not a 2310.
-		 */
-		if (IS_QLA2300(ha)) {
-			spin_lock_irqsave(&ha->hardware_lock, flags);
+	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
 
-			/* Pause RISC. */
-			WRT_REG_WORD(&ha->iobase->hccr, HCCR_PAUSE_RISC);
-			for (cnt = 0; cnt < 30000; cnt++) {
-				if ((RD_REG_WORD(&ha->iobase->hccr) &
-				    HCCR_RISC_PAUSE) != 0)
-					break;
-	
-				udelay(10);
-			}
+	pci_set_master(ha->pdev);
+	mwi = 0;
+	if (pci_set_mwi(ha->pdev))
+		mwi = PCI_COMMAND_INVALIDATE;
+	pci_read_config_word(ha->pdev, PCI_REVISION_ID, &ha->revision);
 
-			/* Select FPM registers. */
-			WRT_REG_WORD(&ha->iobase->ctrl_status, 0x20);
-			RD_REG_WORD(&ha->iobase->ctrl_status);
+	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
+	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 
-			/* Get the fb rev level */
-			ha->fb_rev = RD_FB_CMD_REG(ha, ha->iobase);
+	if (IS_QLA2322(ha) || IS_QLA6322(ha))
+		w &= ~PCI_COMMAND_INTX_DISABLE;
 
-			if (ha->fb_rev == FPM_2300)
-				w &= ~PCI_COMMAND_INVALIDATE;
+	/*
+	 * If this is a 2300 card and not 2312, reset the
+	 * COMMAND_INVALIDATE due to a bug in the 2300. Unfortunately,
+	 * the 2310 also reports itself as a 2300 so we need to get the
+	 * fb revision level -- a 6 indicates it really is a 2300 and
+	 * not a 2310.
+	 */
+	if (IS_QLA2300(ha)) {
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 
-			/* Deselect FPM registers. */
-			WRT_REG_WORD(&ha->iobase->ctrl_status, 0x0);
-			RD_REG_WORD(&ha->iobase->ctrl_status);
+		/* Pause RISC. */
+		WRT_REG_WORD(&ha->iobase->hccr, HCCR_PAUSE_RISC);
+		for (cnt = 0; cnt < 30000; cnt++) {
+			if ((RD_REG_WORD(&ha->iobase->hccr) &
+			    HCCR_RISC_PAUSE) != 0)
+				break;
 
-			/* Release RISC module. */
-			WRT_REG_WORD(&ha->iobase->hccr, HCCR_RELEASE_RISC);
-			for (cnt = 0; cnt < 30000; cnt++) {
-				if ((RD_REG_WORD(&ha->iobase->hccr) &
-				    HCCR_RISC_PAUSE) == 0)
-					break;
-	
-				udelay(10);
-			}
+			udelay(10);
+		}
 
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		/* Select FPM registers. */
+		WRT_REG_WORD(&ha->iobase->ctrl_status, 0x20);
+		RD_REG_WORD(&ha->iobase->ctrl_status);
+
+		/* Get the fb rev level */
+		ha->fb_rev = RD_FB_CMD_REG(ha, ha->iobase);
+
+		if (ha->fb_rev == FPM_2300)
+			w &= ~PCI_COMMAND_INVALIDATE;
+
+		/* Deselect FPM registers. */
+		WRT_REG_WORD(&ha->iobase->ctrl_status, 0x0);
+		RD_REG_WORD(&ha->iobase->ctrl_status);
+
+		/* Release RISC module. */
+		WRT_REG_WORD(&ha->iobase->hccr, HCCR_RELEASE_RISC);
+		for (cnt = 0; cnt < 30000; cnt++) {
+			if ((RD_REG_WORD(&ha->iobase->hccr) &
+			    HCCR_RISC_PAUSE) == 0)
+				break;
+
+			udelay(10);
 		}
-	}
 
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	}
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
+	pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER, 0x80);
+
 	/* Reset expansion ROM address decode enable */
 	pci_read_config_word(ha->pdev, PCI_ROM_ADDRESS, &w);
 	w &= ~PCI_ROM_ADDRESS_ENABLE;
 	pci_write_config_word(ha->pdev, PCI_ROM_ADDRESS, w);
 
-	return (QLA_SUCCESS);
+	/* Get PCI bus information. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->pci_attr = RD_REG_WORD(&ha->iobase->ctrl_status);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return QLA_SUCCESS;
 }
 
 /**
@@ -333,7 +348,7 @@ qla2x00_isp_firmware(scsi_qla_host_t *ha
  *
  * Returns 0 on success.
  */
-static void
+void
 qla2x00_reset_chip(scsi_qla_host_t *ha) 
 {
 	unsigned long   flags = 0;
@@ -342,8 +357,7 @@ qla2x00_reset_chip(scsi_qla_host_t *ha) 
 	unsigned long	mbx_flags = 0;
 	uint16_t	cmd;
 
-	/* Disable ISP interrupts. */
-	qla2x00_disable_intrs(ha);
+	ha->isp_ops.disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -487,7 +501,7 @@ qla2x00_reset_chip(scsi_qla_host_t *ha) 
  *
  * Returns 0 on success.
  */
-static int
+int
 qla2x00_chip_diag(scsi_qla_host_t *ha)
 {
 	int		rval;
@@ -802,7 +816,7 @@ qla2x00_init_response_q_entries(scsi_qla
  *
  * Returns 0 on success.
  */
-static void
+void
 qla2x00_update_fw_options(scsi_qla_host_t *ha)
 {
 	uint16_t swing, emphasis, tx_sens, rx_sens;
@@ -872,6 +886,28 @@ qla2x00_update_fw_options(scsi_qla_host_
 	qla2x00_set_fw_options(ha, ha->fw_options);
 }
 
+void
+qla2x00_config_rings(struct scsi_qla_host *ha)
+{
+	device_reg_t __iomem *reg = ha->iobase;
+
+	/* Setup ring parameters in initialization control block. */
+	ha->init_cb->request_q_outpointer = __constant_cpu_to_le16(0);
+	ha->init_cb->response_q_inpointer = __constant_cpu_to_le16(0);
+	ha->init_cb->request_q_length = cpu_to_le16(ha->request_q_length);
+	ha->init_cb->response_q_length = cpu_to_le16(ha->response_q_length);
+	ha->init_cb->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
+	ha->init_cb->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
+	ha->init_cb->response_q_address[0] = cpu_to_le32(LSD(ha->response_dma));
+	ha->init_cb->response_q_address[1] = cpu_to_le32(MSD(ha->response_dma));
+
+	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), 0);
+	WRT_REG_WORD(ISP_REQ_Q_OUT(ha, reg), 0);
+	WRT_REG_WORD(ISP_RSP_Q_IN(ha, reg), 0);
+	WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), 0);
+	RD_REG_WORD(ISP_RSP_Q_OUT(ha, reg));		/* PCI Posting. */
+}
+
 /**
  * qla2x00_init_rings() - Initializes firmware.
  * @ha: HA context
@@ -887,7 +923,6 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 	int	rval;
 	unsigned long flags = 0;
 	int cnt;
-	device_reg_t __iomem *reg = ha->iobase;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -908,29 +943,15 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 	ha->response_ring_ptr = ha->response_ring;
 	ha->rsp_ring_index    = 0;
 
-	/* Setup ring parameters in initialization control block. */
-	ha->init_cb->request_q_outpointer = __constant_cpu_to_le16(0);
-	ha->init_cb->response_q_inpointer = __constant_cpu_to_le16(0);
-	ha->init_cb->request_q_length = cpu_to_le16(ha->request_q_length);
-	ha->init_cb->response_q_length = cpu_to_le16(ha->response_q_length);
-	ha->init_cb->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
-	ha->init_cb->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
-	ha->init_cb->response_q_address[0] = cpu_to_le32(LSD(ha->response_dma));
-	ha->init_cb->response_q_address[1] = cpu_to_le32(MSD(ha->response_dma));
-
 	/* Initialize response queue entries */
 	qla2x00_init_response_q_entries(ha);
 
- 	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), 0);
- 	WRT_REG_WORD(ISP_REQ_Q_OUT(ha, reg), 0);
- 	WRT_REG_WORD(ISP_RSP_Q_IN(ha, reg), 0);
- 	WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), 0);
-	RD_REG_WORD(ISP_RSP_Q_OUT(ha, reg));		/* PCI Posting. */
+	ha->isp_ops.config_rings(ha);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Update any ISP specific firmware options before initialization. */
-	qla2x00_update_fw_options(ha);
+	ha->isp_ops.update_fw_options(ha);
 
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
 	rval = qla2x00_init_firmware(ha, sizeof(init_cb_t));
@@ -1165,7 +1186,7 @@ qla2x00_configure_hba(scsi_qla_host_t *h
 * Returns:
 *      0 = success.
 */
-static int
+int
 qla2x00_nvram_config(scsi_qla_host_t *ha)
 {
 	int   rval;
@@ -1698,15 +1719,13 @@ qla2x00_configure_local_loop(scsi_qla_ho
 		domain = ((struct gid_list_info *)id_iter)->domain;
 		area = ((struct gid_list_info *)id_iter)->area;
 		al_pa = ((struct gid_list_info *)id_iter)->al_pa;
-		if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
+		if (IS_QLA2100(ha) || IS_QLA2200(ha))
 			loop_id = (uint16_t)
 			    ((struct gid_list_info *)id_iter)->loop_id_2100;
-			id_iter += 4;
-		} else {
+		else
 			loop_id = le16_to_cpu(
 			    ((struct gid_list_info *)id_iter)->loop_id);
-			id_iter += 6;
-		}
+		id_iter += ha->gid_list_info_size;
 
 		/* Bypass reserved domain fields. */
 		if ((domain & 0xf0) == 0xf0)
@@ -1937,8 +1956,8 @@ qla2x00_configure_fabric(scsi_qla_host_t
 	}
 	do {
 		/* Ensure we are logged into the SNS. */
-		qla2x00_login_fabric(ha, SIMPLE_NAME_SERVER, 0xff, 0xff, 0xfc,
-		    mb, BIT_1 | BIT_0);
+		ha->isp_ops.fabric_login(ha, SIMPLE_NAME_SERVER, 0xff, 0xff,
+		    0xfc, mb, BIT_1 | BIT_0);
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2(qla_printk(KERN_INFO, ha,
 			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x "
@@ -1992,7 +2011,7 @@ qla2x00_configure_fabric(scsi_qla_host_t
 				    fcport->port_type != FCT_INITIATOR &&
 				    fcport->port_type != FCT_BROADCAST) {
 
-					qla2x00_fabric_logout(ha,
+					ha->isp_ops.fabric_logout(ha,
 					    fcport->loop_id);
 					fcport->loop_id = FC_NO_LOOP_ID;
 				}
@@ -2238,7 +2257,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 			    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
 			    fcport->port_type != FCT_INITIATOR &&
 			    fcport->port_type != FCT_BROADCAST) {
-				qla2x00_fabric_logout(ha, fcport->loop_id);
+				ha->isp_ops.fabric_logout(ha, fcport->loop_id);
 				fcport->loop_id = FC_NO_LOOP_ID;
 			}
 
@@ -2497,7 +2516,7 @@ qla2x00_fabric_dev_login(scsi_qla_host_t
 	if (rval == QLA_SUCCESS) {
 		rval = qla2x00_get_port_database(ha, fcport, 0);
 		if (rval != QLA_SUCCESS) {
-			qla2x00_fabric_logout(ha, fcport->loop_id);
+			ha->isp_ops.fabric_logout(ha, fcport->loop_id);
 		} else {
 			qla2x00_update_fcport(ha, fcport);
 		}
@@ -2539,7 +2558,7 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa));
 
 		/* Login fcport on switch. */
-		qla2x00_login_fabric(ha, fcport->loop_id,
+		ha->isp_ops.fabric_login(ha, fcport->loop_id,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa, mb, BIT_0);
 		if (mb[0] == MBS_PORT_ID_USED) {
@@ -2602,7 +2621,7 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 			 * dead.
 			 */
 			*next_loopid = fcport->loop_id;
-			qla2x00_fabric_logout(ha, fcport->loop_id);
+			ha->isp_ops.fabric_logout(ha, fcport->loop_id);
 			qla2x00_mark_device_lost(ha, fcport, 1);
 
 			rval = 1;
@@ -2618,7 +2637,7 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 			    fcport->d_id.b.al_pa, fcport->loop_id, jiffies));
 
 			*next_loopid = fcport->loop_id;
-			qla2x00_fabric_logout(ha, fcport->loop_id);
+			ha->isp_ops.fabric_logout(ha, fcport->loop_id);
 			fcport->loop_id = FC_NO_LOOP_ID;
 			atomic_set(&fcport->state, FCS_DEVICE_DEAD);
 
@@ -2763,7 +2782,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 
 		qla_printk(KERN_INFO, ha,
 		    "Performing ISP error recovery - ha= %p.\n", ha);
-		qla2x00_reset_chip(ha);
+		ha->isp_ops.reset_chip(ha);
 
 		atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
@@ -2789,7 +2808,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 		}
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		qla2x00_nvram_config(ha);
+		ha->isp_ops.nvram_config(ha);
 
 		if (!qla2x00_restart_isp(ha)) {
 			clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
@@ -2804,8 +2823,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 
 			ha->flags.online = 1;
 
-			/* Enable ISP interrupts. */
-			qla2x00_enable_intrs(ha);
+			ha->isp_ops.enable_intrs(ha);
 
 			ha->isp_abort_cnt = 0; 
 			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
@@ -2820,7 +2838,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 					 * The next call disables the board
 					 * completely.
 					 */
-					qla2x00_reset_adapter(ha);
+					ha->isp_ops.reset_adapter(ha);
 					ha->flags.online = 0;
 					clear_bit(ISP_ABORT_RETRY,
 					    &ha->dpc_flags);
@@ -2877,7 +2895,7 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 	/* If firmware needs to be loaded */
 	if (qla2x00_isp_firmware(ha)) {
 		ha->flags.online = 0;
-		if (!(status = qla2x00_chip_diag(ha))) {
+		if (!(status = ha->isp_ops.chip_diag(ha))) {
 			if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 				status = qla2x00_setup_chip(ha);
 				goto done;
@@ -2951,14 +2969,14 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 * Input:
 *      ha = adapter block pointer.
 */
-static void
+void
 qla2x00_reset_adapter(scsi_qla_host_t *ha)
 {
 	unsigned long flags = 0;
 	device_reg_t __iomem *reg = ha->iobase;
 
 	ha->flags.online = 0;
-	qla2x00_disable_intrs(ha);
+	ha->isp_ops.disable_intrs(ha);
 
 	/* Reset RISC processor. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -117,46 +117,9 @@ static __inline__ void qla2x00_poll(scsi
 static inline void 
 qla2x00_poll(scsi_qla_host_t *ha)
 {
-	if (IS_QLA2100(ha) || IS_QLA2200(ha))
-		qla2100_intr_handler(0, ha, NULL);
-	else
-		qla2300_intr_handler(0, ha, NULL);
+	ha->isp_ops.intr_handler(0, ha, NULL);
 }
 
-
-static __inline__ void qla2x00_enable_intrs(scsi_qla_host_t *);
-static __inline__ void qla2x00_disable_intrs(scsi_qla_host_t *);
-
-static inline void 
-qla2x00_enable_intrs(scsi_qla_host_t *ha)
-{
-	unsigned long flags = 0;
-	device_reg_t __iomem *reg = ha->iobase;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->interrupts_on = 1;
-	/* enable risc and host interrupts */
-	WRT_REG_WORD(&reg->ictrl, ICR_EN_INT | ICR_EN_RISC);
-	RD_REG_WORD(&reg->ictrl);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-}
-
-static inline void 
-qla2x00_disable_intrs(scsi_qla_host_t *ha)
-{
-	unsigned long flags = 0;
-	device_reg_t __iomem *reg = ha->iobase;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->interrupts_on = 0;
-	/* disable risc and host interrupts */
-	WRT_REG_WORD(&reg->ictrl, 0);
-	RD_REG_WORD(&reg->ictrl);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-}
-
-
 static __inline__ int qla2x00_is_wwn_zero(uint8_t *);
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -369,7 +369,7 @@ qla2x00_start_scsi(srb_t *sp)
 	}
 
 	/* Calculate the number of request entries needed. */
-	req_cnt = (ha->calc_request_entries)(tot_dsds);
+	req_cnt = ha->isp_ops.calc_req_entries(tot_dsds);
 	if (ha->req_q_cnt < (req_cnt + 2)) {
 		cnt = RD_REG_WORD_RELAXED(ISP_REQ_Q_OUT(ha, reg));
 		if (ha->req_ring_index < cnt)
@@ -419,7 +419,7 @@ qla2x00_start_scsi(srb_t *sp)
 	cmd_pkt->byte_count = cpu_to_le32((uint32_t)cmd->request_bufflen);
 
 	/* Build IOCB segments */
-	(ha->build_scsi_iocbs)(sp, cmd_pkt, tot_dsds);
+	ha->isp_ops.build_iocbs(sp, cmd_pkt, tot_dsds);
 
 	/* Set total data segment count. */
 	cmd_pkt->entry_count = (uint8_t)req_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -356,10 +356,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n",
 		    mb[1], mb[2], mb[3]);
 
-		if (IS_QLA2100(ha) || IS_QLA2200(ha))
-			qla2100_fw_dump(ha, 1);
-		else
-	    		qla2300_fw_dump(ha, 1);
+		ha->isp_ops.fw_dump(ha, 1);
 
 		if (mb[1] == 0) {
 			qla_printk(KERN_INFO, ha,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -178,7 +178,7 @@ void qla2x00_sp_compl(scsi_qla_host_t *h
 /* -------------------------------------------------------------------------- */
 
 static char *
-qla2x00_get_pci_info_str(struct scsi_qla_host *ha, char *str)
+qla2x00_pci_info_str(struct scsi_qla_host *ha, char *str)
 {
 	static char *pci_bus_modes[] = {
 		"33", "66", "100", "133",
@@ -201,7 +201,7 @@ qla2x00_get_pci_info_str(struct scsi_qla
 }
 
 char *
-qla2x00_get_fw_version_str(struct scsi_qla_host *ha, char *str)
+qla2x00_fw_version_str(struct scsi_qla_host *ha, char *str)
 {
 	char un_str[10];
 	
@@ -493,7 +493,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		DEBUG3(qla2x00_print_scsi_cmd(cmd);)
 
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		if (qla2x00_abort_command(ha, sp)) {
+		if (ha->isp_ops.abort_command(ha, sp)) {
 			DEBUG2(printk("%s(%ld): abort_command "
 			    "mbx failed.\n", __func__, ha->host_no));
 		} else {
@@ -624,7 +624,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 #if defined(LOGOUT_AFTER_DEVICE_RESET)
 		if (ret == SUCCESS) {
 			if (fcport->flags & FC_FABRIC_DEVICE) {
-				qla2x00_fabric_logout(ha, fcport->loop_id);
+				ha->isp_ops.fabric_logout(ha, fcport->loop_id);
 				qla2x00_mark_device_lost(ha, fcport);
 			}
 		}
@@ -925,7 +925,7 @@ static int
 qla2x00_device_reset(scsi_qla_host_t *ha, fc_port_t *reset_fcport)
 {
 	/* Abort Target command will clear Reservation */
-	return qla2x00_abort_target(reset_fcport);
+	return ha->isp_ops.abort_target(reset_fcport);
 }
 
 static int
@@ -989,8 +989,6 @@ qla2x00_config_dma_addressing(scsi_qla_h
 {
 	/* Assume 32bit DMA address */
 	ha->flags.enable_64bit_addressing = 0;
-	ha->calc_request_entries = qla2x00_calc_iocbs_32;
-	ha->build_scsi_iocbs = qla2x00_build_scsi_iocbs_32;
 
 	/*
 	 * Given the two variants pci_set_dma_mask(), allow the compiler to
@@ -999,8 +997,8 @@ qla2x00_config_dma_addressing(scsi_qla_h
 	if (sizeof(dma_addr_t) > 4) {
 		if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK) == 0) {
 			ha->flags.enable_64bit_addressing = 1;
-			ha->calc_request_entries = qla2x00_calc_iocbs_64;
-			ha->build_scsi_iocbs = qla2x00_build_scsi_iocbs_64;
+			ha->isp_ops.calc_req_entries = qla2x00_calc_iocbs_64;
+			ha->isp_ops.build_iocbs = qla2x00_build_scsi_iocbs_64;
 
 			if (pci_set_consistent_dma_mask(ha->pdev,
 			    DMA_64BIT_MASK)) {
@@ -1087,6 +1085,35 @@ iospace_error_exit:
 	return (-ENOMEM);
 }
 
+static void
+qla2x00_enable_intrs(scsi_qla_host_t *ha)
+{
+	unsigned long flags = 0;
+	device_reg_t __iomem *reg = ha->iobase;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->interrupts_on = 1;
+	/* enable risc and host interrupts */
+	WRT_REG_WORD(&reg->ictrl, ICR_EN_INT | ICR_EN_RISC);
+	RD_REG_WORD(&reg->ictrl);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+}
+
+static void
+qla2x00_disable_intrs(scsi_qla_host_t *ha)
+{
+	unsigned long flags = 0;
+	device_reg_t __iomem *reg = ha->iobase;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->interrupts_on = 0;
+	/* disable risc and host interrupts */
+	WRT_REG_WORD(&reg->ictrl, 0);
+	RD_REG_WORD(&reg->ictrl);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
 /*
  * PCI driver interface
  */
@@ -1140,6 +1167,28 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->prev_topology = 0;
 	ha->ports = MAX_BUSES;
 
+	/* Assign ISP specific operations. */
+	ha->isp_ops.pci_config		= qla2100_pci_config;
+	ha->isp_ops.reset_chip		= qla2x00_reset_chip;
+	ha->isp_ops.chip_diag		= qla2x00_chip_diag;
+	ha->isp_ops.config_rings	= qla2x00_config_rings;
+	ha->isp_ops.reset_adapter	= qla2x00_reset_adapter;
+	ha->isp_ops.nvram_config	= qla2x00_nvram_config;
+	ha->isp_ops.update_fw_options	= qla2x00_update_fw_options;
+	ha->isp_ops.pci_info_str	= qla2x00_pci_info_str;
+	ha->isp_ops.fw_version_str	= qla2x00_fw_version_str;
+	ha->isp_ops.intr_handler	= qla2100_intr_handler;
+	ha->isp_ops.enable_intrs	= qla2x00_enable_intrs;
+	ha->isp_ops.disable_intrs	= qla2x00_disable_intrs;
+	ha->isp_ops.abort_command	= qla2x00_abort_command;
+	ha->isp_ops.abort_target	= qla2x00_abort_target;
+	ha->isp_ops.fabric_login	= qla2x00_login_fabric;
+	ha->isp_ops.fabric_logout	= qla2x00_fabric_logout;
+	ha->isp_ops.calc_req_entries	= qla2x00_calc_iocbs_32;
+	ha->isp_ops.build_iocbs		= qla2x00_build_scsi_iocbs_32;
+	ha->isp_ops.prep_ms_iocb	= qla2x00_prep_ms_iocb;
+	ha->isp_ops.fw_dump		= qla2100_fw_dump;
+	ha->isp_ops.ascii_fw_dump	= qla2100_ascii_fw_dump;
 	if (IS_QLA2100(ha)) {
 		host->max_id = MAX_TARGETS_2100;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT_2100;
@@ -1147,18 +1196,25 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
 		host->sg_tablesize = 32;
+		ha->gid_list_info_size = 4;
 	} else if (IS_QLA2200(ha)) {
 		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
+		ha->gid_list_info_size = 4;
 	} else /*if (IS_QLA2300(ha))*/ {
 		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+		ha->isp_ops.pci_config = qla2300_pci_config;
+		ha->isp_ops.intr_handler = qla2300_intr_handler;
+		ha->isp_ops.fw_dump = qla2300_fw_dump;
+		ha->isp_ops.ascii_fw_dump = qla2300_ascii_fw_dump;
+		ha->gid_list_info_size = 6;
 	}
 	host->can_queue = ha->request_q_length + 128;
 
@@ -1229,12 +1285,8 @@ int qla2x00_probe_one(struct pci_dev *pd
 	host->max_lun = MAX_LUNS;
 	host->transportt = qla2xxx_transport_template;
 
-	if (IS_QLA2100(ha) || IS_QLA2200(ha))
-		ret = request_irq(host->irq, qla2100_intr_handler,
-		    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
-	else
-		ret = request_irq(host->irq, qla2300_intr_handler,
-		    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
+	ret = request_irq(host->irq, ha->isp_ops.intr_handler,
+	    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
 	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
@@ -1250,8 +1302,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 
 	reg = ha->iobase;
 
-	/* Disable ISP interrupts. */
-	qla2x00_disable_intrs(ha);
+	ha->isp_ops.disable_intrs(ha);
 
 	/* Ensure mailbox registers are free. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1270,8 +1321,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	/* Enable chip interrupts. */
-	qla2x00_enable_intrs(ha);
+	ha->isp_ops.enable_intrs(ha);
 
 	/* v2.19.5b6 */
 	/*
@@ -1306,9 +1356,9 @@ int qla2x00_probe_one(struct pci_dev *pd
 	    "  QLogic %s - %s\n"
 	    "  %s: %s @ %s hdma%c, host#=%ld, fw=%s\n", qla2x00_version_str,
 	    ha->model_number, ha->model_desc ? ha->model_desc: "",
-	    ha->brd_info->isp_name, qla2x00_get_pci_info_str(ha, pci_info),
+	    ha->brd_info->isp_name, ha->isp_ops.pci_info_str(ha, pci_info),
 	    pci_name(ha->pdev), ha->flags.enable_64bit_addressing ? '+': '-',
-	    ha->host_no, qla2x00_get_fw_version_str(ha, fw_str));
+	    ha->host_no, ha->isp_ops.fw_version_str(ha, fw_str));
 
 	/* Go with fc_rport registration. */
 	list_for_each_entry(fcport, &ha->fcports, list)
@@ -1362,7 +1412,7 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 
 	/* turn-off interrupts on the card */
 	if (ha->interrupts_on)
-		qla2x00_disable_intrs(ha);
+		ha->isp_ops.disable_intrs(ha);
 
 	/* Disable timer */
 	if (ha->timer_active)
@@ -1951,9 +2001,8 @@ qla2x00_do_dpc(void *data)
 					if (fcport->flags & FCF_FABRIC_DEVICE) {
 						if (fcport->flags &
 						    FCF_TAPE_PRESENT)
-							qla2x00_fabric_logout(
-							    ha,
-							    fcport->loop_id);
+							ha->isp_ops.fabric_logout(
+							    ha, fcport->loop_id);
 						status = qla2x00_fabric_login(
 						    ha, fcport, &next_loopid);
 					} else
@@ -2034,7 +2083,7 @@ qla2x00_do_dpc(void *data)
 		}
 
 		if (!ha->interrupts_on)
-			qla2x00_enable_intrs(ha);
+			ha->isp_ops.enable_intrs(ha);
 
 		ha->dpc_active = 0;
 	} /* End of while(1) */

-- 
Andrew Vasquez
