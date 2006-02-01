From: andrew.vasquez@qlogic.com
Subject: [PATCH 6/6] qla2xxx: Add support to retrieve/update HBA option-rom.
Date: Tue, 31 Jan 2006 16:05:17 -0800
Message-ID: <11387523122674-git-send-email-andrew.vasquez@qlogic.com>
References: <20060201000146.GA4456@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:64195 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751137AbWBAAFR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 19:05:17 -0500
In-Reply-To: <20060201000146.GA4456@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_attr.c |  135 ++++++++
 drivers/scsi/qla2xxx/qla_def.h  |   17 +
 drivers/scsi/qla2xxx/qla_gbl.h  |   11 +
 drivers/scsi/qla2xxx/qla_os.c   |   15 +
 drivers/scsi/qla2xxx/qla_sup.c  |  669 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 845 insertions(+), 2 deletions(-)

59a2c0125e5efb01c6a00ed1a81cbe2d3a6e24f1
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 73d10b3..92b3e13 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -179,6 +179,135 @@ static struct bin_attribute sysfs_nvram_
 	.write = qla2x00_sysfs_write_nvram,
 };
 
+static ssize_t
+qla2x00_sysfs_read_optrom(struct kobject *kobj, char *buf, loff_t off,
+    size_t count)
+{
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+
+	if (ha->optrom_state != QLA_SREADING)
+		return 0;
+	if (off > ha->optrom_size)
+		return 0;
+	if (off + count > ha->optrom_size)
+		count = ha->optrom_size - off;
+
+	memcpy(buf, &ha->optrom_buffer[off], count);
+
+	return count;
+}
+
+static ssize_t
+qla2x00_sysfs_write_optrom(struct kobject *kobj, char *buf, loff_t off,
+    size_t count)
+{
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+
+	if (ha->optrom_state != QLA_SWRITING)
+		return -EINVAL;
+	if (off > ha->optrom_size)
+		return -ERANGE;
+	if (off + count > ha->optrom_size)
+		count = ha->optrom_size - off;
+
+	memcpy(&ha->optrom_buffer[off], buf, count);
+
+	return count;
+}
+
+static struct bin_attribute sysfs_optrom_attr = {
+	.attr = {
+		.name = "optrom",
+		.mode = S_IRUSR | S_IWUSR,
+		.owner = THIS_MODULE,
+	},
+	.size = OPTROM_SIZE_24XX,
+	.read = qla2x00_sysfs_read_optrom,
+	.write = qla2x00_sysfs_write_optrom,
+};
+
+static ssize_t
+qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj, char *buf, loff_t off,
+    size_t count)
+{
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	int val;
+
+	if (off)
+		return 0;
+
+	if (sscanf(buf, "%d", &val) != 1)
+		return -EINVAL;
+
+	switch (val) {
+	case 0:
+		if (ha->optrom_state != QLA_SREADING &&
+		    ha->optrom_state != QLA_SWRITING)
+			break;
+
+		ha->optrom_state = QLA_SWAITING;
+		vfree(ha->optrom_buffer);
+		ha->optrom_buffer = NULL;
+		break;
+	case 1:
+		if (ha->optrom_state != QLA_SWAITING)
+			break;
+
+		ha->optrom_state = QLA_SREADING;
+		ha->optrom_buffer = (uint8_t *)vmalloc(ha->optrom_size);
+		if (ha->optrom_buffer == NULL) {
+			qla_printk(KERN_WARNING, ha,
+			    "Unable to allocate memory for optrom retrieval "
+			    "(%x).\n", ha->optrom_size);
+
+			ha->optrom_state = QLA_SWAITING;
+			return count;
+		}
+
+		memset(ha->optrom_buffer, 0, ha->optrom_size);
+		ha->isp_ops.read_optrom(ha, ha->optrom_buffer, 0,
+		    ha->optrom_size);
+		break;
+	case 2:
+		if (ha->optrom_state != QLA_SWAITING)
+			break;
+
+		ha->optrom_state = QLA_SWRITING;
+		ha->optrom_buffer = (uint8_t *)vmalloc(ha->optrom_size);
+		if (ha->optrom_buffer == NULL) {
+			qla_printk(KERN_WARNING, ha,
+			    "Unable to allocate memory for optrom update "
+			    "(%x).\n", ha->optrom_size);
+
+			ha->optrom_state = QLA_SWAITING;
+			return count;
+		}
+		memset(ha->optrom_buffer, 0, ha->optrom_size);
+		break;
+	case 3:
+		if (ha->optrom_state != QLA_SWRITING)
+			break;
+
+		ha->isp_ops.write_optrom(ha, ha->optrom_buffer, 0,
+		    ha->optrom_size);
+		break;
+	}
+	return count;
+}
+
+static struct bin_attribute sysfs_optrom_ctl_attr = {
+	.attr = {
+		.name = "optrom_ctl",
+		.mode = S_IWUSR,
+		.owner = THIS_MODULE,
+	},
+	.size = 0,
+	.write = qla2x00_sysfs_write_optrom_ctl,
+};
+
 void
 qla2x00_alloc_sysfs_attr(scsi_qla_host_t *ha)
 {
@@ -186,6 +315,9 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t
 
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
+	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_optrom_attr);
+	sysfs_create_bin_file(&host->shost_gendev.kobj,
+	    &sysfs_optrom_ctl_attr);
 }
 
 void
@@ -195,6 +327,9 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t 
 
 	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
 	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
+	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_optrom_attr);
+	sysfs_remove_bin_file(&host->shost_gendev.kobj,
+	    &sysfs_optrom_ctl_attr);
 
 	if (ha->beacon_blink_led == 1)
 		ha->isp_ops.beacon_off(ha);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7cb8b5a..b31a03b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2214,6 +2214,11 @@ struct isp_operations {
 	int (*beacon_on) (struct scsi_qla_host *);
 	int (*beacon_off) (struct scsi_qla_host *);
 	void (*beacon_blink) (struct scsi_qla_host *);
+
+	uint8_t * (*read_optrom) (struct scsi_qla_host *, uint8_t *,
+		uint32_t, uint32_t);
+	int (*write_optrom) (struct scsi_qla_host *, uint8_t *, uint32_t,
+		uint32_t);
 };
 
 /*
@@ -2505,6 +2510,14 @@ typedef struct scsi_qla_host {
 	uint8_t		*port_name;
 	uint32_t    isp_abort_cnt;
 
+	/* Option ROM information. */
+	char		*optrom_buffer;
+	uint32_t	optrom_size;
+	int		optrom_state;
+#define QLA_SWAITING	0
+#define QLA_SREADING	1
+#define QLA_SWRITING	2
+
 	/* Needed for BEACON */
 	uint16_t	beacon_blink_led;
 	uint8_t		beacon_color_state;
@@ -2582,7 +2595,9 @@ struct _qla2x00stats  {
 /*
  * Flash support definitions
  */
-#define FLASH_IMAGE_SIZE	131072
+#define OPTROM_SIZE_2300	0x20000
+#define OPTROM_SIZE_2322	0x100000
+#define OPTROM_SIZE_24XX	0x100000
 
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index eb35198..ffdc268 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -79,6 +79,8 @@ extern int qla2x00_down_timeout(struct s
 
 extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
+extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
+
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
@@ -240,6 +242,15 @@ extern int qla24xx_beacon_on(struct scsi
 extern int qla24xx_beacon_off(struct scsi_qla_host *);
 extern void qla24xx_beacon_blink(struct scsi_qla_host *);
 
+extern uint8_t *qla2x00_read_optrom_data(struct scsi_qla_host *, uint8_t *,
+    uint32_t, uint32_t);
+extern int qla2x00_write_optrom_data(struct scsi_qla_host *, uint8_t *,
+    uint32_t, uint32_t);
+extern uint8_t *qla24xx_read_optrom_data(struct scsi_qla_host *, uint8_t *,
+    uint32_t, uint32_t);
+extern int qla24xx_write_optrom_data(struct scsi_qla_host *, uint8_t *,
+    uint32_t, uint32_t);
+
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 57179da..495ccbc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -513,7 +513,7 @@ qla2x00_eh_wait_on_command(scsi_qla_host
  *    Success (Adapter is online) : 0
  *    Failed  (Adapter is offline/disabled) : 1
  */
-static int
+int
 qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
 {
 	int		return_status;
@@ -1271,6 +1271,9 @@ int qla2x00_probe_one(struct pci_dev *pd
 	fc_port_t *fcport;
 	struct scsi_host_template *sht;
 
+if (PCI_FUNC(pdev->devfn))
+	goto probe_out;
+
 	if (pci_enable_device(pdev))
 		goto probe_out;
 
@@ -1313,6 +1316,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->init_cb_size = sizeof(init_cb_t);
 	ha->mgmt_svr_loop_id = MANAGEMENT_SERVER;
 	ha->link_data_rate = LDR_UNKNOWN;
+	ha->optrom_size = OPTROM_SIZE_2300;
 
 	/* Assign ISP specific operations. */
 	ha->isp_ops.pci_config		= qla2100_pci_config;
@@ -1340,6 +1344,8 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->isp_ops.write_nvram		= qla2x00_write_nvram_data;
 	ha->isp_ops.fw_dump		= qla2100_fw_dump;
 	ha->isp_ops.ascii_fw_dump	= qla2100_ascii_fw_dump;
+	ha->isp_ops.read_optrom		= qla2x00_read_optrom_data;
+	ha->isp_ops.write_optrom	= qla2x00_write_optrom_data;
 	if (IS_QLA2100(ha)) {
 		host->max_id = MAX_TARGETS_2100;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT_2100;
@@ -1369,6 +1375,8 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->isp_ops.beacon_off = qla2x00_beacon_off;
 		ha->isp_ops.beacon_blink = qla2x00_beacon_blink;
 		ha->gid_list_info_size = 6;
+		if (IS_QLA2322(ha) || IS_QLA6322(ha))
+			ha->optrom_size = OPTROM_SIZE_2322;
 	} else if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
 		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
@@ -1404,10 +1412,13 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->isp_ops.write_nvram = qla24xx_write_nvram_data;
 		ha->isp_ops.fw_dump = qla24xx_fw_dump;
 		ha->isp_ops.ascii_fw_dump = qla24xx_ascii_fw_dump;
+		ha->isp_ops.read_optrom	= qla24xx_read_optrom_data;
+		ha->isp_ops.write_optrom = qla24xx_write_optrom_data;
 		ha->isp_ops.beacon_on = qla24xx_beacon_on;
 		ha->isp_ops.beacon_off = qla24xx_beacon_off;
 		ha->isp_ops.beacon_blink = qla24xx_beacon_blink;
 		ha->gid_list_info_size = 8;
+		ha->optrom_size = OPTROM_SIZE_24XX;
 	}
 	host->can_queue = ha->request_q_length + 128;
 
@@ -2073,6 +2084,8 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	ha->fw_dumped = 0;
 	ha->fw_dump_reading = 0;
 	ha->fw_dump_buffer = NULL;
+
+	vfree(ha->optrom_buffer);
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 3105bb9..3866a57 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -989,3 +989,672 @@ qla24xx_beacon_off(struct scsi_qla_host 
 
 	return QLA_SUCCESS;
 }
+
+
+/*
+ * Flash support routines
+ */
+
+/**
+ * qla2x00_flash_enable() - Setup flash for reading and writing.
+ * @ha: HA context
+ */
+static void
+qla2x00_flash_enable(scsi_qla_host_t *ha)
+{
+	uint16_t data;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	data = RD_REG_WORD(&reg->ctrl_status);
+	data |= CSR_FLASH_ENABLE;
+	WRT_REG_WORD(&reg->ctrl_status, data);
+	RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+}
+
+/**
+ * qla2x00_flash_disable() - Disable flash and allow RISC to run.
+ * @ha: HA context
+ */
+static void
+qla2x00_flash_disable(scsi_qla_host_t *ha)
+{
+	uint16_t data;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	data = RD_REG_WORD(&reg->ctrl_status);
+	data &= ~(CSR_FLASH_ENABLE);
+	WRT_REG_WORD(&reg->ctrl_status, data);
+	RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+}
+
+/**
+ * qla2x00_read_flash_byte() - Reads a byte from flash
+ * @ha: HA context
+ * @addr: Address in flash to read
+ *
+ * A word is read from the chip, but, only the lower byte is valid.
+ *
+ * Returns the byte read from flash @addr.
+ */
+static uint8_t
+qla2x00_read_flash_byte(scsi_qla_host_t *ha, uint32_t addr)
+{
+	uint16_t data;
+	uint16_t bank_select;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	bank_select = RD_REG_WORD(&reg->ctrl_status);
+
+	if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
+		/* Specify 64K address range: */
+		/*  clear out Module Select and Flash Address bits [19:16]. */
+		bank_select &= ~0xf8;
+		bank_select |= addr >> 12 & 0xf0;
+		bank_select |= CSR_FLASH_64K_BANK;
+		WRT_REG_WORD(&reg->ctrl_status, bank_select);
+		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+
+		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
+		data = RD_REG_WORD(&reg->flash_data);
+
+		return (uint8_t)data;
+	}
+
+	/* Setup bit 16 of flash address. */
+	if ((addr & BIT_16) && ((bank_select & CSR_FLASH_64K_BANK) == 0)) {
+		bank_select |= CSR_FLASH_64K_BANK;
+		WRT_REG_WORD(&reg->ctrl_status, bank_select);
+		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+	} else if (((addr & BIT_16) == 0) &&
+	    (bank_select & CSR_FLASH_64K_BANK)) {
+		bank_select &= ~(CSR_FLASH_64K_BANK);
+		WRT_REG_WORD(&reg->ctrl_status, bank_select);
+		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+	}
+
+	/* Always perform IO mapped accesses to the FLASH registers. */
+	if (ha->pio_address) {
+		uint16_t data2;
+
+		reg = (struct device_reg_2xxx __iomem *)ha->pio_address;
+		WRT_REG_WORD_PIO(&reg->flash_address, (uint16_t)addr);
+		do {
+			data = RD_REG_WORD_PIO(&reg->flash_data);
+			barrier();
+			cpu_relax();
+			data2 = RD_REG_WORD_PIO(&reg->flash_data);
+		} while (data != data2);
+	} else {
+		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
+		data = qla2x00_debounce_register(&reg->flash_data);
+	}
+
+	return (uint8_t)data;
+}
+
+/**
+ * qla2x00_write_flash_byte() - Write a byte to flash
+ * @ha: HA context
+ * @addr: Address in flash to write
+ * @data: Data to write
+ */
+static void
+qla2x00_write_flash_byte(scsi_qla_host_t *ha, uint32_t addr, uint8_t data)
+{
+	uint16_t bank_select;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	bank_select = RD_REG_WORD(&reg->ctrl_status);
+	if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
+		/* Specify 64K address range: */
+		/*  clear out Module Select and Flash Address bits [19:16]. */
+		bank_select &= ~0xf8;
+		bank_select |= addr >> 12 & 0xf0;
+		bank_select |= CSR_FLASH_64K_BANK;
+		WRT_REG_WORD(&reg->ctrl_status, bank_select);
+		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+
+		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
+		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+		WRT_REG_WORD(&reg->flash_data, (uint16_t)data);
+		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+
+		return;
+	}
+
+	/* Setup bit 16 of flash address. */
+	if ((addr & BIT_16) && ((bank_select & CSR_FLASH_64K_BANK) == 0)) {
+		bank_select |= CSR_FLASH_64K_BANK;
+		WRT_REG_WORD(&reg->ctrl_status, bank_select);
+		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+	} else if (((addr & BIT_16) == 0) &&
+	    (bank_select & CSR_FLASH_64K_BANK)) {
+		bank_select &= ~(CSR_FLASH_64K_BANK);
+		WRT_REG_WORD(&reg->ctrl_status, bank_select);
+		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+	}
+
+	/* Always perform IO mapped accesses to the FLASH registers. */
+	if (ha->pio_address) {
+		reg = (struct device_reg_2xxx __iomem *)ha->pio_address;
+		WRT_REG_WORD_PIO(&reg->flash_address, (uint16_t)addr);
+		WRT_REG_WORD_PIO(&reg->flash_data, (uint16_t)data);
+	} else {
+		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
+		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+		WRT_REG_WORD(&reg->flash_data, (uint16_t)data);
+		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+	}
+}
+
+/**
+ * qla2x00_poll_flash() - Polls flash for completion.
+ * @ha: HA context
+ * @addr: Address in flash to poll
+ * @poll_data: Data to be polled
+ * @man_id: Flash manufacturer ID
+ * @flash_id: Flash ID
+ *
+ * This function polls the device until bit 7 of what is read matches data
+ * bit 7 or until data bit 5 becomes a 1.  If that hapens, the flash ROM timed
+ * out (a fatal error).  The flash book recommeds reading bit 7 again after
+ * reading bit 5 as a 1.
+ *
+ * Returns 0 on success, else non-zero.
+ */
+static int
+qla2x00_poll_flash(scsi_qla_host_t *ha, uint32_t addr, uint8_t poll_data,
+    uint8_t man_id, uint8_t flash_id)
+{
+	int status;
+	uint8_t flash_data;
+	uint32_t cnt;
+
+	status = 1;
+
+	/* Wait for 30 seconds for command to finish. */
+	poll_data &= BIT_7;
+	for (cnt = 3000000; cnt; cnt--) {
+		flash_data = qla2x00_read_flash_byte(ha, addr);
+		if ((flash_data & BIT_7) == poll_data) {
+			status = 0;
+			break;
+		}
+
+		if (man_id != 0x40 && man_id != 0xda) {
+			if ((flash_data & BIT_5) && cnt > 2)
+				cnt = 2;
+		}
+		udelay(10);
+		barrier();
+	}
+	return status;
+}
+
+#define IS_OEM_001(ha) \
+	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2322 && \
+	 (ha)->pdev->subsystem_vendor == 0x1028 && \
+	 (ha)->pdev->subsystem_device == 0x0170)
+
+/**
+ * qla2x00_program_flash_address() - Programs a flash address
+ * @ha: HA context
+ * @addr: Address in flash to program
+ * @data: Data to be written in flash
+ * @man_id: Flash manufacturer ID
+ * @flash_id: Flash ID
+ *
+ * Returns 0 on success, else non-zero.
+ */
+static int
+qla2x00_program_flash_address(scsi_qla_host_t *ha, uint32_t addr, uint8_t data,
+    uint8_t man_id, uint8_t flash_id)
+{
+	/* Write Program Command Sequence. */
+	if (IS_OEM_001(ha)) {
+		qla2x00_write_flash_byte(ha, 0xaaa, 0xaa);
+		qla2x00_write_flash_byte(ha, 0x555, 0x55);
+		qla2x00_write_flash_byte(ha, 0xaaa, 0xa0);
+		qla2x00_write_flash_byte(ha, addr, data);
+	} else {
+		if (man_id == 0xda && flash_id == 0xc1) {
+			qla2x00_write_flash_byte(ha, addr, data);
+			if (addr & 0x7e)
+				return 0;
+		} else {
+			qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
+			qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
+			qla2x00_write_flash_byte(ha, 0x5555, 0xa0);
+			qla2x00_write_flash_byte(ha, addr, data);
+		}
+	}
+
+	udelay(150);
+
+	/* Wait for write to complete. */
+	return qla2x00_poll_flash(ha, addr, data, man_id, flash_id);
+}
+
+/**
+ * qla2x00_erase_flash() - Erase the flash.
+ * @ha: HA context
+ * @man_id: Flash manufacturer ID
+ * @flash_id: Flash ID
+ *
+ * Returns 0 on success, else non-zero.
+ */
+static int
+qla2x00_erase_flash(scsi_qla_host_t *ha, uint8_t man_id, uint8_t flash_id)
+{
+	/* Individual Sector Erase Command Sequence */
+	if (IS_OEM_001(ha)) {
+		qla2x00_write_flash_byte(ha, 0xaaa, 0xaa);
+		qla2x00_write_flash_byte(ha, 0x555, 0x55);
+		qla2x00_write_flash_byte(ha, 0xaaa, 0x80);
+		qla2x00_write_flash_byte(ha, 0xaaa, 0xaa);
+		qla2x00_write_flash_byte(ha, 0x555, 0x55);
+		qla2x00_write_flash_byte(ha, 0xaaa, 0x10);
+	} else {
+		qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
+		qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
+		qla2x00_write_flash_byte(ha, 0x5555, 0x80);
+		qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
+		qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
+		qla2x00_write_flash_byte(ha, 0x5555, 0x10);
+	}
+
+	udelay(150);
+
+	/* Wait for erase to complete. */
+	return qla2x00_poll_flash(ha, 0x00, 0x80, man_id, flash_id);
+}
+
+/**
+ * qla2x00_erase_flash_sector() - Erase a flash sector.
+ * @ha: HA context
+ * @addr: Flash sector to erase
+ * @sec_mask: Sector address mask
+ * @man_id: Flash manufacturer ID
+ * @flash_id: Flash ID
+ *
+ * Returns 0 on success, else non-zero.
+ */
+static int
+qla2x00_erase_flash_sector(scsi_qla_host_t *ha, uint32_t addr,
+    uint32_t sec_mask, uint8_t man_id, uint8_t flash_id)
+{
+	/* Individual Sector Erase Command Sequence */
+	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
+	qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
+	qla2x00_write_flash_byte(ha, 0x5555, 0x80);
+	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
+	qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
+	if (man_id == 0x1f && flash_id == 0x13)
+		qla2x00_write_flash_byte(ha, addr & sec_mask, 0x10);
+	else
+		qla2x00_write_flash_byte(ha, addr & sec_mask, 0x30);
+
+	udelay(150);
+
+	/* Wait for erase to complete. */
+	return qla2x00_poll_flash(ha, addr, 0x80, man_id, flash_id);
+}
+
+/**
+ * qla2x00_get_flash_manufacturer() - Read manufacturer ID from flash chip.
+ * @man_id: Flash manufacturer ID
+ * @flash_id: Flash ID
+ */
+static void
+qla2x00_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
+    uint8_t *flash_id)
+{
+	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
+	qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
+	qla2x00_write_flash_byte(ha, 0x5555, 0x90);
+	*man_id = qla2x00_read_flash_byte(ha, 0x0000);
+	*flash_id = qla2x00_read_flash_byte(ha, 0x0001);
+	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
+	qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
+	qla2x00_write_flash_byte(ha, 0x5555, 0xf0);
+}
+
+
+static inline void
+qla2x00_suspend_hba(struct scsi_qla_host *ha)
+{
+	int cnt;
+	unsigned long flags;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	/* Suspend HBA. */
+	scsi_block_requests(ha->host);
+	ha->isp_ops.disable_intrs(ha);
+	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
+
+	/* Pause RISC. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
+	RD_REG_WORD(&reg->hccr);
+	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
+		for (cnt = 0; cnt < 30000; cnt++) {
+			if ((RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) != 0)
+				break;
+			udelay(100);
+		}
+	} else {
+		udelay(10);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+static inline void
+qla2x00_resume_hba(struct scsi_qla_host *ha)
+{
+	/* Resume HBA. */
+	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
+	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+	up(ha->dpc_wait);
+	qla2x00_wait_for_hba_online(ha);
+	scsi_unblock_requests(ha->host);
+}
+
+uint8_t *
+qla2x00_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+    uint32_t offset, uint32_t length)
+{
+	unsigned long flags;
+	uint32_t addr, midpoint;
+	uint8_t *data;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	/* Suspend HBA. */
+	qla2x00_suspend_hba(ha);
+
+	/* Go with read. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	midpoint = ha->optrom_size / 2;
+
+	qla2x00_flash_enable(ha);
+	WRT_REG_WORD(&reg->nvram, 0);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	for (addr = offset, data = buf; addr < length; addr++, data++) {
+		if (addr == midpoint) {
+			WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+			RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+		}
+
+		*data = qla2x00_read_flash_byte(ha, addr);
+	}
+	qla2x00_flash_disable(ha);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	/* Resume HBA. */
+	qla2x00_resume_hba(ha);
+
+	return buf;
+}
+
+int
+qla2x00_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+    uint32_t offset, uint32_t length)
+{
+
+	int rval;
+	unsigned long flags;
+	uint8_t man_id, flash_id, sec_number, data;
+	uint16_t wd;
+	uint32_t addr, liter, sec_mask, rest_addr;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	/* Suspend HBA. */
+	qla2x00_suspend_hba(ha);
+
+	rval = QLA_SUCCESS;
+	sec_number = 0;
+
+	/* Reset ISP chip. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+	pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
+
+	/* Go with write. */
+	qla2x00_flash_enable(ha);
+	do {	/* Loop once to provide quick error exit */
+		/* Structure of flash memory based on manufacturer */
+		if (IS_OEM_001(ha)) {
+			/* OEM variant with special flash part. */
+			man_id = flash_id = 0;
+			rest_addr = 0xffff;
+			sec_mask   = 0x10000;
+			goto update_flash;
+		}
+		qla2x00_get_flash_manufacturer(ha, &man_id, &flash_id);
+		switch (man_id) {
+		case 0x20: /* ST flash. */
+			if (flash_id == 0xd2 || flash_id == 0xe3) {
+				/*
+				 * ST m29w008at part - 64kb sector size with
+				 * 32kb,8kb,8kb,16kb sectors at memory address
+				 * 0xf0000.
+				 */
+				rest_addr = 0xffff;
+				sec_mask = 0x10000;
+				break;   
+			}
+			/*
+			 * ST m29w010b part - 16kb sector size
+			 * Default to 16kb sectors
+			 */
+			rest_addr = 0x3fff;
+			sec_mask = 0x1c000;
+			break;
+		case 0x40: /* Mostel flash. */
+			/* Mostel v29c51001 part - 512 byte sector size. */
+			rest_addr = 0x1ff;
+			sec_mask = 0x1fe00;
+			break;
+		case 0xbf: /* SST flash. */
+			/* SST39sf10 part - 4kb sector size. */
+			rest_addr = 0xfff;
+			sec_mask = 0x1f000;
+			break;
+		case 0xda: /* Winbond flash. */
+			/* Winbond W29EE011 part - 256 byte sector size. */
+			rest_addr = 0x7f;
+			sec_mask = 0x1ff80;
+			break;
+		case 0xc2: /* Macronix flash. */
+			/* 64k sector size. */
+			if (flash_id == 0x38 || flash_id == 0x4f) {
+				rest_addr = 0xffff;
+				sec_mask = 0x10000;
+				break;
+			}
+			/* Fall through... */
+
+		case 0x1f: /* Atmel flash. */
+			/* 512k sector size. */
+			if (flash_id == 0x13) {
+				rest_addr = 0x7fffffff;
+				sec_mask =   0x80000000;
+				break;
+			}
+			/* Fall through... */
+
+		case 0x01: /* AMD flash. */
+			if (flash_id == 0x38 || flash_id == 0x40 ||
+			    flash_id == 0x4f) {
+				/* Am29LV081 part - 64kb sector size. */
+				/* Am29LV002BT part - 64kb sector size. */
+				rest_addr = 0xffff;
+				sec_mask = 0x10000;
+				break;
+			} else if (flash_id == 0x3e) {
+				/*
+				 * Am29LV008b part - 64kb sector size with
+				 * 32kb,8kb,8kb,16kb sector at memory address
+				 * h0xf0000.
+				 */
+				rest_addr = 0xffff;
+				sec_mask = 0x10000;
+				break;
+			} else if (flash_id == 0x20 || flash_id == 0x6e) {
+				/*
+				 * Am29LV010 part or AM29f010 - 16kb sector
+				 * size.
+				 */
+				rest_addr = 0x3fff;
+				sec_mask = 0x1c000;
+				break;
+			} else if (flash_id == 0x6d) {
+				/* Am29LV001 part - 8kb sector size. */
+				rest_addr = 0x1fff;
+				sec_mask = 0x1e000;
+				break;
+			}
+		default:
+			/* Default to 16 kb sector size. */
+			rest_addr = 0x3fff;
+			sec_mask = 0x1c000;
+			break;
+		}
+
+update_flash:
+		if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
+			if (qla2x00_erase_flash(ha, man_id, flash_id)) {
+				rval = QLA_FUNCTION_FAILED;
+				break;
+			}
+		}
+
+		for (addr = offset, liter = 0; liter < length; liter++,
+		    addr++) {
+			data = buf[liter];
+			/* Are we at the beginning of a sector? */
+			if ((addr & rest_addr) == 0) {
+				if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
+					if (addr >= 0x10000UL) {
+						if (((addr >> 12) & 0xf0) &&
+						    ((man_id == 0x01 &&
+							flash_id == 0x3e) ||
+						     (man_id == 0x20 &&
+							 flash_id == 0xd2))) {
+							sec_number++;
+							if (sec_number == 1) {
+								rest_addr =
+								    0x7fff;
+								sec_mask =
+								    0x18000;
+							} else if (
+							    sec_number == 2 ||
+							    sec_number == 3) {
+								rest_addr =
+								    0x1fff;
+								sec_mask =
+								    0x1e000;
+							} else if (
+							    sec_number == 4) {
+								rest_addr =
+								    0x3fff;
+								sec_mask =
+								    0x1c000;
+							}
+						}
+					}
+				} else if (addr == ha->optrom_size / 2) {
+					WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+					RD_REG_WORD(&reg->nvram);
+				}
+
+				if (flash_id == 0xda && man_id == 0xc1) {
+					qla2x00_write_flash_byte(ha, 0x5555,
+					    0xaa);
+					qla2x00_write_flash_byte(ha, 0x2aaa,
+					    0x55);
+					qla2x00_write_flash_byte(ha, 0x5555,
+					    0xa0);
+				} else if (!IS_QLA2322(ha) && !IS_QLA6322(ha)) {
+					/* Then erase it */
+					if (qla2x00_erase_flash_sector(ha,
+					    addr, sec_mask, man_id,
+					    flash_id)) {
+						rval = QLA_FUNCTION_FAILED;
+						break;
+					}
+					if (man_id == 0x01 && flash_id == 0x6d)
+						sec_number++;
+				}
+			}
+
+			if (man_id == 0x01 && flash_id == 0x6d) {
+				if (sec_number == 1 &&
+				    addr == (rest_addr - 1)) {
+					rest_addr = 0x0fff;
+					sec_mask   = 0x1f000;
+				} else if (sec_number == 3 && (addr & 0x7ffe)) {
+					rest_addr = 0x3fff;
+					sec_mask   = 0x1c000;
+				}
+			}
+
+			if (qla2x00_program_flash_address(ha, addr, data,
+			    man_id, flash_id)) {
+				rval = QLA_FUNCTION_FAILED;
+				break;
+			}
+		}
+	} while (0);
+	qla2x00_flash_disable(ha);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	/* Resume HBA. */
+	qla2x00_resume_hba(ha);
+
+	return rval;
+}
+
+uint8_t *
+qla24xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+    uint32_t offset, uint32_t length)
+{
+	/* Suspend HBA. */
+	scsi_block_requests(ha->host);
+	ha->isp_ops.disable_intrs(ha);
+	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
+
+	/* Go with read. */
+	qla24xx_read_flash_data(ha, (uint32_t *)buf, offset >> 2, length >> 2);
+
+	/* Resume HBA. */
+	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
+	ha->isp_ops.enable_intrs(ha);
+	scsi_unblock_requests(ha->host);
+
+	return buf;
+}
+
+int
+qla24xx_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+    uint32_t offset, uint32_t length)
+{
+	int rval;
+
+	/* Suspend HBA. */
+	scsi_block_requests(ha->host);
+	ha->isp_ops.disable_intrs(ha);
+	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
+
+	/* Go with write. */
+	rval = qla24xx_write_flash_data(ha, (uint32_t *)buf, offset >> 2,
+	    length >> 2);
+
+	/* Resume HBA -- RISC reset needed. */
+	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
+	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+	up(ha->dpc_wait);
+	qla2x00_wait_for_hba_online(ha);
+	scsi_unblock_requests(ha->host);
+
+	return rval;
+}
-- 
1.1.6.g1506


