From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/17] qla2xxx: Add OS initialization codes for ISP24xx recognition.
Date: Wed,  6 Jul 2005 10:31:47 -0700 (PDT)
Message-ID: <20050706173147.10568.32053.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56660 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262430AbVGFRbs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:31:48 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add OS initialization codes for ISP24xx recognition.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/Makefile   |    3 
 drivers/scsi/qla2xxx/qla_attr.c |   22 +-
 drivers/scsi/qla2xxx/qla_def.h  |    3 
 drivers/scsi/qla2xxx/qla_os.c   |  417 +++++++++++++++++++++++++++++++--------
 4 files changed, 350 insertions(+), 95 deletions(-)

0b1a41ae2af18d81cd1dc9ea8bce669097f5411a
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
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1989,7 +1989,8 @@ struct qla_board_info {
 
 	char isp_name[8];
 	struct qla_fw_info *fw_info;
-	char *fw_fname;;
+	char *fw_fname;
+	struct scsi_host_template *sht;
 };
 
 /* Return data from MBC_GET_ID_LIST call. */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -79,6 +79,11 @@ module_param(ql2xloginretrycount, int, S
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
+int ql2xfwloadbin;
+module_param(ql2xfwloadbin, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xfwloadbin,
+		"Load ISP2xxx firmware image via hotplug.");
+
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
@@ -91,6 +96,8 @@ static int qla2xxx_slave_alloc(struct sc
 static void qla2xxx_slave_destroy(struct scsi_device *);
 static int qla2x00_queuecommand(struct scsi_cmnd *cmd,
 		void (*fn)(struct scsi_cmnd *));
+static int qla24xx_queuecommand(struct scsi_cmnd *cmd,
+		void (*fn)(struct scsi_cmnd *));
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
@@ -124,6 +131,28 @@ static struct scsi_host_template qla2x00
 	.max_sectors		= 0xFFFF,
 };
 
+static struct scsi_host_template qla24xx_driver_template = {
+	.module			= THIS_MODULE,
+	.name			= "qla2xxx",
+	.queuecommand		= qla24xx_queuecommand,
+
+	.eh_abort_handler	= qla2xxx_eh_abort,
+	.eh_device_reset_handler = qla2xxx_eh_device_reset,
+	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
+	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
+
+	.slave_configure	= qla2xxx_slave_configure,
+
+	.slave_alloc		= qla2xxx_slave_alloc,
+	.slave_destroy		= qla2xxx_slave_destroy,
+	.this_id		= -1,
+	.cmd_per_lun		= 3,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.sg_tablesize		= SG_ALL,
+
+	.max_sectors		= 0xFFFF,
+};
+
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
 
 /* TODO Convert to inlines
@@ -171,7 +200,6 @@ static uint8_t qla2x00_mem_alloc(scsi_ql
 static void qla2x00_mem_free(scsi_qla_host_t *ha);
 static int qla2x00_allocate_sp_pool( scsi_qla_host_t *ha);
 static void qla2x00_free_sp_pool(scsi_qla_host_t *ha);
-static srb_t *qla2x00_get_new_sp(scsi_qla_host_t *);
 static void qla2x00_sp_free_dma(scsi_qla_host_t *, srb_t *);
 void qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *);
 
@@ -200,6 +228,54 @@ qla2x00_pci_info_str(struct scsi_qla_hos
 	return (str);
 }
 
+static char *
+qla24xx_pci_info_str(struct scsi_qla_host *ha, char *str)
+{
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
+
+	strcpy(str, "PCI");
+	pci_bus = (ha->pci_attr & CSRX_PCIX_BUS_MODE_MASK) >> 8;
+	if (pci_bus == 0 || pci_bus == 8) {
+		strcat(str, " (");
+		strcat(str, pci_bus_modes[pci_bus >> 3]);
+	} else {
+		strcat(str, "-X ");
+		if (pci_bus & BIT_2)
+			strcat(str, "Mode 2");
+		else
+			strcat(str, "Mode 1");
+		strcat(str, " (");
+		strcat(str, pci_bus_modes[pci_bus & ~BIT_2]);
+	}
+	strcat(str, " MHz)");
+
+	return str;
+}
+
 char *
 qla2x00_fw_version_str(struct scsi_qla_host *ha, char *str)
 {
@@ -238,25 +314,42 @@ qla2x00_fw_version_str(struct scsi_qla_h
 	return (str);
 }
 
-/**************************************************************************
-* qla2x00_queuecommand
-*
-* Description:
-*     Queue a command to the controller.
-*
-* Input:
-*     cmd - pointer to Scsi cmd structure
-*     fn - pointer to Scsi done function
-*
-* Returns:
-*   0 - Always
-*
-* Note:
-* The mid-level driver tries to ensures that queuecommand never gets invoked
-* concurrently with itself or the interrupt handler (although the
-* interrupt handler may call this routine as part of request-completion
-* handling).
-**************************************************************************/
+char *
+qla24xx_fw_version_str(struct scsi_qla_host *ha, char *str)
+{
+	if (ha->fw_attributes & BIT_0)
+		strcat(str, "[Class 2] ");
+	if (ha->fw_attributes & BIT_1)
+		strcat(str, "[IP] ");
+	if (ha->fw_attributes & BIT_2)
+		strcat(str, "[Multi-ID] ");
+	if (ha->fw_attributes & BIT_13)
+		strcat(str, "[Experimental]");
+	return str;
+
+}
+
+static inline srb_t *
+qla2x00_get_new_sp(scsi_qla_host_t *ha, fc_port_t *fcport,
+    struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+{
+	srb_t *sp;
+
+	sp = mempool_alloc(ha->srb_mempool, GFP_ATOMIC);
+	if (!sp)
+		return sp;
+
+	atomic_set(&sp->ref_count, 1);
+	sp->ha = ha;
+	sp->fcport = fcport;
+	sp->cmd = cmd;
+	sp->flags = 0;
+	CMD_SP(cmd) = (void *)sp;
+	cmd->scsi_done = done;
+
+	return sp;
+}
+
 static int
 qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
@@ -281,18 +374,9 @@ qla2x00_queuecommand(struct scsi_cmnd *c
 
 	spin_unlock_irq(ha->host->host_lock);
 
-	/* Allocate a command packet from the "sp" pool. */
-	if ((sp = qla2x00_get_new_sp(ha)) == NULL) {
+	sp = qla2x00_get_new_sp(ha, fcport, cmd, done);
+	if (!sp)
 		goto qc_host_busy_lock;
-	}
-
-	sp->ha = ha;
-	sp->fcport = fcport;
-	sp->cmd = cmd;
-	sp->flags = 0;
-
-	CMD_SP(cmd) = (void *)sp;
-	cmd->scsi_done = done;
 
 	rval = qla2x00_start_scsi(sp);
 	if (rval != QLA_SUCCESS)
@@ -314,7 +398,6 @@ qla2x00_queuecommand(struct scsi_cmnd *c
 
 qc_host_busy_free_sp:
 	qla2x00_sp_free_dma(ha, sp);
-	CMD_SP(cmd) = NULL;
 	mempool_free(sp, ha->srb_mempool);
 
 qc_host_busy_lock:
@@ -329,6 +412,60 @@ qc_fail_command:
 	return 0;
 }
 
+
+static int
+qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+{
+	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
+	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	srb_t *sp;
+	int rval;
+
+	if (!fcport) {
+		cmd->result = DID_NO_CONNECT << 16;
+		goto qc24_fail_command;
+	}
+
+	if (atomic_read(&fcport->state) != FCS_ONLINE) {
+		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
+		    atomic_read(&ha->loop_state) == LOOP_DEAD) {
+			cmd->result = DID_NO_CONNECT << 16;
+			goto qc24_fail_command;
+		}
+		goto qc24_host_busy;
+	}
+
+	spin_unlock_irq(ha->host->host_lock);
+
+	sp = qla2x00_get_new_sp(ha, fcport, cmd, done);
+	if (!sp)
+		goto qc24_host_busy_lock;
+
+	rval = qla24xx_start_scsi(sp);
+	if (rval != QLA_SUCCESS)
+		goto qc24_host_busy_free_sp;
+
+	spin_lock_irq(ha->host->host_lock);
+
+	return 0;
+
+qc24_host_busy_free_sp:
+	qla2x00_sp_free_dma(ha, sp);
+	mempool_free(sp, ha->srb_mempool);
+
+qc24_host_busy_lock:
+	spin_lock_irq(ha->host->host_lock);
+
+qc24_host_busy:
+	return SCSI_MLQUEUE_HOST_BUSY;
+
+qc24_fail_command:
+	done(cmd);
+
+	return 0;
+}
+
+
 /*
  * qla2x00_eh_wait_on_command
  *    Waits for the command to be returned by the Firmware for some
@@ -385,8 +522,8 @@ qla2x00_eh_wait_on_command(scsi_qla_host
 static int 
 qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
 {
-	int 	 return_status;
-	unsigned long wait_online;
+	int		return_status;
+	unsigned long	wait_online;
 
 	wait_online = jiffies + (MAX_LOOP_TIMEOUT * HZ); 
 	while (((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) ||
@@ -1114,13 +1251,39 @@ qla2x00_disable_intrs(scsi_qla_host_t *h
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+static void
+qla24xx_enable_intrs(scsi_qla_host_t *ha)
+{
+	unsigned long flags = 0;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->interrupts_on = 1;
+	WRT_REG_DWORD(&reg->ictrl, ICRX_EN_RISC_INT);
+	RD_REG_DWORD(&reg->ictrl);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+static void
+qla24xx_disable_intrs(scsi_qla_host_t *ha)
+{
+	unsigned long flags = 0;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->interrupts_on = 0;
+	WRT_REG_DWORD(&reg->ictrl, 0);
+	RD_REG_DWORD(&reg->ictrl);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
 /*
  * PCI driver interface
  */
 int qla2x00_probe_one(struct pci_dev *pdev, struct qla_board_info *brd_info)
 {
 	int	ret = -ENODEV;
-	struct device_reg_2xxx __iomem *reg;
+	device_reg_t __iomem *reg;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
 	unsigned long	flags = 0;
@@ -1132,8 +1295,8 @@ int qla2x00_probe_one(struct pci_dev *pd
 	if (pci_enable_device(pdev))
 		goto probe_out;
 
-	host = scsi_host_alloc(&qla2x00_driver_template,
-	    sizeof(scsi_qla_host_t));
+	host = scsi_host_alloc(brd_info->sht ? brd_info->sht:
+	    &qla2x00_driver_template, sizeof(scsi_qla_host_t));
 	if (host == NULL) {
 		printk(KERN_WARNING
 		    "qla2xxx: Couldn't allocate host from scsi layer!\n");
@@ -1155,17 +1318,15 @@ int qla2x00_probe_one(struct pci_dev *pd
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
 
 	/* Assign ISP specific operations. */
 	ha->isp_ops.pci_config		= qla2100_pci_config;
@@ -1207,7 +1368,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
 		ha->gid_list_info_size = 4;
-	} else /*if (IS_QLA2300(ha))*/ {
+	} else if (IS_QLA23XX(ha)) {
 		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
@@ -1218,6 +1379,38 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->isp_ops.fw_dump = qla2300_fw_dump;
 		ha->isp_ops.ascii_fw_dump = qla2300_ascii_fw_dump;
 		ha->gid_list_info_size = 6;
+	} else if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		host->max_id = MAX_TARGETS_2200;
+		ha->mbx_count = MAILBOX_REGISTER_COUNT;
+		ha->request_q_length = REQUEST_ENTRY_CNT_24XX;
+		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
+		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+		ha->init_cb_size = sizeof(struct init_cb_24xx);
+		ha->isp_ops.pci_config = qla24xx_pci_config;
+		ha->isp_ops.reset_chip = qla24xx_reset_chip;
+		ha->isp_ops.chip_diag = qla24xx_chip_diag;
+		ha->isp_ops.config_rings = qla24xx_config_rings;
+		ha->isp_ops.reset_adapter = qla24xx_reset_adapter;
+		ha->isp_ops.nvram_config = qla24xx_nvram_config;
+		ha->isp_ops.update_fw_options = qla24xx_update_fw_options;
+		ha->isp_ops.load_risc = qla24xx_load_risc_flash;
+		if (ql2xfwloadbin)
+			ha->isp_ops.load_risc = qla24xx_load_risc_hotplug;
+		ha->isp_ops.pci_info_str = qla24xx_pci_info_str;
+		ha->isp_ops.fw_version_str = qla24xx_fw_version_str;
+		ha->isp_ops.intr_handler = qla24xx_intr_handler;
+		ha->isp_ops.enable_intrs = qla24xx_enable_intrs;
+		ha->isp_ops.disable_intrs = qla24xx_disable_intrs;
+		ha->isp_ops.abort_command = qla24xx_abort_command;
+		ha->isp_ops.abort_target = qla24xx_abort_target;
+		ha->isp_ops.fabric_login = qla24xx_login_fabric;
+		ha->isp_ops.fabric_logout = qla24xx_fabric_logout;
+		ha->isp_ops.prep_ms_iocb = qla24xx_prep_ms_iocb;
+		ha->isp_ops.read_nvram = qla24xx_read_nvram_data;
+		ha->isp_ops.write_nvram = qla24xx_write_nvram_data;
+		ha->isp_ops.fw_dump = qla24xx_fw_dump;
+		ha->isp_ops.ascii_fw_dump = qla24xx_ascii_fw_dump;
+		ha->gid_list_info_size = 8;
 	}
 	host->can_queue = ha->request_q_length + 128;
 
@@ -1288,14 +1481,15 @@ int qla2x00_probe_one(struct pci_dev *pd
 	host->max_lun = MAX_LUNS;
 	host->transportt = qla2xxx_transport_template;
 
-	ret = request_irq(host->irq, ha->isp_ops.intr_handler,
+	ret = request_irq(pdev->irq, ha->isp_ops.intr_handler,
 	    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
 	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
-		    host->irq);
+		    pdev->irq);
 		goto probe_failed;
 	}
+	host->irq = pdev->irq;
 
 	/* Initialized the timer */
 	qla2x00_start_timer(ha, qla2x00_timer, WATCH_INTERVAL);
@@ -1303,24 +1497,29 @@ int qla2x00_probe_one(struct pci_dev *pd
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
 	    ha->host_no, ha));
 
-	reg = &ha->iobase->isp;
-
 	ha->isp_ops.disable_intrs(ha);
 
-	/* Ensure mailbox registers are free. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
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
+	reg = ha->iobase;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
+		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_RISC_INT);
+	} else {
+		WRT_REG_WORD(&reg->isp.semaphore, 0);
+		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_RISC_INT);
+		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
+
+		/* Enable proper parity */
+		if (!IS_QLA2100(ha) && !IS_QLA2200(ha)) {
+			if (IS_QLA2300(ha))
+				/* SRAM parity */
+				WRT_REG_WORD(&reg->isp.hccr,
+				    (HCCR_ENABLE_PARITY + 0x1));
+			else
+				/* SRAM, Instruction RAM and GP RAM parity */
+				WRT_REG_WORD(&reg->isp.hccr,
+				    (HCCR_ENABLE_PARITY + 0x7));
+		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -1360,7 +1559,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	    "  %s: %s @ %s hdma%c, host#=%ld, fw=%s\n", qla2x00_version_str,
 	    ha->model_number, ha->model_desc ? ha->model_desc: "",
 	    ha->brd_info->isp_name, ha->isp_ops.pci_info_str(ha, pci_info),
-	    pci_name(ha->pdev), ha->flags.enable_64bit_addressing ? '+': '-',
+	    pci_name(pdev), ha->flags.enable_64bit_addressing ? '+': '-',
 	    ha->host_no, ha->isp_ops.fw_version_str(ha, fw_str));
 
 	/* Go with fc_rport registration. */
@@ -1629,7 +1828,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 
 			continue;
 		}
-		memset(ha->init_cb, 0, sizeof(init_cb_t));
+		memset(ha->init_cb, 0, ha->init_cb_size);
 
 		/* Get consistent memory allocated for Get Port Database cmd */
 		ha->iodesc_pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
@@ -1841,10 +2040,13 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	if (ha->fw_dump)
 		free_pages((unsigned long)ha->fw_dump, ha->fw_dump_order);
 
-	if (ha->fw_dump_buffer)
-		vfree(ha->fw_dump_buffer);
+	vfree(ha->fw_dump24);
+
+	vfree(ha->fw_dump_buffer);
 
 	ha->fw_dump = NULL;
+	ha->fw_dump24 = NULL;
+	ha->fw_dumped = 0;
 	ha->fw_dump_reading = 0;
 	ha->fw_dump_buffer = NULL;
 }
@@ -2131,25 +2333,6 @@ qla2x00_rst_aen(scsi_qla_host_t *ha) 
 	}
 }
 
-
-/*
- * This routine will allocate SP from the free queue
- * input:
- *        scsi_qla_host_t *
- * output:
- *        srb_t * or NULL
- */
-static srb_t *
-qla2x00_get_new_sp(scsi_qla_host_t *ha)
-{
-	srb_t *sp;
-
-	sp = mempool_alloc(ha->srb_mempool, GFP_ATOMIC);
-	if (sp)
-		atomic_set(&sp->ref_count, 1);
-	return (sp);
-}
-
 static void
 qla2x00_sp_free_dma(scsi_qla_host_t *ha, srb_t *sp)
 {
@@ -2165,6 +2348,7 @@ qla2x00_sp_free_dma(scsi_qla_host_t *ha,
 		}
 		sp->flags &= ~SRB_DMA_VALID;
 	}
+	CMD_SP(cmd) = NULL;
 }
 
 void
@@ -2174,7 +2358,6 @@ qla2x00_sp_compl(scsi_qla_host_t *ha, sr
 
 	qla2x00_sp_free_dma(ha, sp);
 
-	CMD_SP(cmd) = NULL;
 	mempool_free(sp, ha->srb_mempool);
 
 	cmd->scsi_done(cmd);
@@ -2219,7 +2402,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 				atomic_set(&fcport->state, FCS_DEVICE_DEAD);
 			
 			DEBUG(printk("scsi(%ld): fcport-%d - port retry count: "
-			    "%d remainning\n",
+			    "%d remaining\n",
 			    ha->host_no,
 			    t, atomic_read(&fcport->port_down_timer)));
 		}
@@ -2282,7 +2465,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			}
 		}
-		DEBUG3(printk("scsi(%ld): Loop Down - seconds remainning %d\n",
+		DEBUG3(printk("scsi(%ld): Loop Down - seconds remaining %d\n",
 		    ha->host_no,
 		    atomic_read(&ha->loop_down_timer)));
 	}
@@ -2319,12 +2502,68 @@ qla2x00_down_timeout(struct semaphore *s
 	return -ETIMEDOUT;
 }
 
+static struct qla_board_info qla_board_tbl[] = {
+	{
+		.drv_name	= "qla2400",
+		.isp_name	= "ISP2422",
+		.fw_fname	= "ql2400_fw.bin",
+		.sht		= &qla24xx_driver_template,
+	},
+	{
+		.drv_name	= "qla2400",
+		.isp_name	= "ISP2432",
+		.fw_fname	= "ql2400_fw.bin",
+		.sht		= &qla24xx_driver_template,
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
@@ -2345,7 +2584,12 @@ qla2x00_module_init(void)
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
@@ -2354,6 +2598,7 @@ qla2x00_module_init(void)
 static void __exit
 qla2x00_module_exit(void)
 {
+	pci_unregister_driver(&qla2xxx_pci_driver);
 	kmem_cache_destroy(srb_cachep);
 	fc_release_transport(qla2xxx_transport_template);
 }

-- 
Andrew Vasquez
