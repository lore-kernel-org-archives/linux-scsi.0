From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] add hotplug support for updating HBA flash.
Date: Wed, 9 Feb 2005 16:42:17 -0800
Message-ID: <20050210004217.GA10833@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:7975 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261990AbVBJAmD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2005 19:42:03 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Currently the only way to update an HBA's flash-part (for boot-code
such as BIOS, EFI, or FCODE) is to use the managment-tools which rely
on IOCTL support within the driver.  The attached patch adds support
for updating the flash via the request_firmware() hotplug
infrastructure.  This code is fashioned around similar code in the IPR
driver:

	# echo "ql23rom.bin" > /sys/class/scsi_host/host0/update_flash

which signals the driver to request the file image via the
request_firmware() interface.

The attached patch is against scsi-misc-2.6.  Please consider for
inclusion.


Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com> 

 Kconfig   |    1 
 qla_def.h |   11 
 qla_gbl.h |    4 
 qla_os.c  |   95 +++++++
 qla_sup.c |  809 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 919 insertions(+), 1 deletion(-)

===== drivers/scsi/qla2xxx/Kconfig 1.7 vs edited =====
--- 1.7/drivers/scsi/qla2xxx/Kconfig	2004-12-08 22:16:47 -08:00
+++ edited/drivers/scsi/qla2xxx/Kconfig	2005-02-09 16:31:30 -08:00
@@ -2,6 +2,7 @@ config SCSI_QLA2XXX
 	tristate
 	default (SCSI && PCI)
 	depends on SCSI && PCI
+	select FW_LOADER
 
 config SCSI_QLA21XX
 	tristate "QLogic ISP2100 host adapter family support"
===== drivers/scsi/qla2xxx/qla_def.h 1.27 vs edited =====
--- 1.27/drivers/scsi/qla2xxx/qla_def.h	2004-12-08 22:16:47 -08:00
+++ edited/drivers/scsi/qla2xxx/qla_def.h	2005-02-09 16:31:31 -08:00
@@ -83,8 +83,12 @@
 
 #if defined(CONFIG_SCSI_QLA2322) || defined(CONFIG_SCSI_QLA2322_MODULE)
 #define IS_QLA2322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2322)
+#define IS_OEM_001(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2322 && \
+				(ha)->pdev->subsystem_vendor == 0x1028 && \
+				(ha)->pdev->subsystem_device == 0x0170)
 #else
 #define IS_QLA2322(ha)	0
+#define IS_OEM_001(ha)  0
 #endif
 
 #if defined(CONFIG_SCSI_QLA6312) || defined(CONFIG_SCSI_QLA6312_MODULE)
@@ -176,6 +180,13 @@
 #define WRT_REG_BYTE(addr, data)	writeb(data,addr)
 #define WRT_REG_WORD(addr, data)	writew(data,addr)
 #define WRT_REG_DWORD(addr, data)	writel(data,addr)
+
+#define RD_REG_WORD_PIO(addr)		(inw((unsigned long)addr))
+#define WRT_REG_WORD_PIO(addr, data)	(outw(data,(unsigned long)addr))
+#define QLA2X00_READ			1
+#define QLA2X00_WRITE			2
+#define OPT_ROM_SIZE_2312		0x20000
+#define OPT_ROM_SIZE_2322		0x100000
 
 /*
  * Fibre Channel device definitions.
===== drivers/scsi/qla2xxx/qla_gbl.h 1.16 vs edited =====
--- 1.16/drivers/scsi/qla2xxx/qla_gbl.h	2004-12-08 22:13:14 -08:00
+++ edited/drivers/scsi/qla2xxx/qla_gbl.h	2005-02-09 16:31:31 -08:00
@@ -96,6 +96,7 @@ extern void qla2x00_abort_queues(scsi_ql
 extern void qla2x00_blink_led(scsi_qla_host_t *);
 
 extern int qla2x00_down_timeout(struct semaphore *, unsigned long);
+extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
 
 /*
  * Global Function Prototypes in qla_iocb.c source file.
@@ -215,6 +216,9 @@ extern void qla2x00_unlock_nvram_access(
 extern void qla2x00_release_nvram_protection(scsi_qla_host_t *);
 extern uint16_t qla2x00_get_nvram_word(scsi_qla_host_t *, uint32_t);
 extern void qla2x00_write_nvram_word(scsi_qla_host_t *, uint32_t, uint16_t);
+extern uint16_t qla2x00_update_or_read_flash(scsi_qla_host_t *, uint8_t *,
+    uint32_t, uint32_t, uint8_t);
+
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
===== drivers/scsi/qla2xxx/qla_os.c 1.53 vs edited =====
--- 1.53/drivers/scsi/qla2xxx/qla_os.c	2004-12-08 22:15:37 -08:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2005-02-09 16:31:32 -08:00
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <linux/smp_lock.h>
 #include <linux/delay.h>
+#include <linux/firmware.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -163,6 +164,22 @@ static int qla2x00_device_reset(scsi_qla
 static int qla2x00_proc_info(struct Scsi_Host *, char *, char **,
     off_t, int, int);
 
+static ssize_t qla2x00_store_update_flash(struct class_device *, const char *,
+    size_t);
+
+static struct class_device_attribute qla2x00_update_flash_attr = {
+	.attr = {
+		.name =         "update_flash",
+		.mode =         S_IWUSR,
+	},
+	.store = qla2x00_store_update_flash
+};
+
+static struct class_device_attribute *qla2x00_cdev_attrs[] = {
+	&qla2x00_update_flash_attr,
+	NULL,
+};
+
 static struct scsi_host_template qla2x00_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "qla2xxx",
@@ -187,6 +204,8 @@ static struct scsi_host_template qla2x00
 	 * which equates to 0x800000 sectors.
 	 */
 	.max_sectors		= 0xFFFF,
+
+	.shost_attrs		= qla2x00_cdev_attrs
 };
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
@@ -579,6 +598,80 @@ static ssize_t qla2x00_sysfs_write_nvram
 	return (count);
 }
 
+/* Flash ------------------------------------------------------------------- */
+size_t
+qla2x00_get_flash_size(scsi_qla_host_t *ha)
+{
+	size_t size = 0;
+
+	switch (ha->pdev->device) {
+	case PCI_DEVICE_ID_QLOGIC_ISP6312:
+	case PCI_DEVICE_ID_QLOGIC_ISP2312:
+		size = OPT_ROM_SIZE_2312;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2322:
+	case PCI_DEVICE_ID_QLOGIC_ISP6322:
+		size = OPT_ROM_SIZE_2322;
+		break;
+	default:
+		size = 0;
+		break;
+	}
+	return size;
+}
+
+static ssize_t
+qla2x00_store_update_flash(struct class_device *class_dev, const char *buf,
+    size_t count)
+{
+	struct Scsi_Host *host = class_to_shost(class_dev);
+	scsi_qla_host_t	*ha = (scsi_qla_host_t *) host->hostdata;
+	const struct firmware *fw_entry;
+	char fname[100];
+	int len;
+	size_t fsize;
+	uint16_t status;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	len = snprintf(fname, 99, "%s", buf);
+	fname[len-1] = '\0';
+
+	if (request_firmware(&fw_entry, fname, &ha->pdev->dev)) {
+		qla_printk(KERN_ERR, ha,
+		    "Flash image file not found: '%s'\n", fname);
+		return -EIO;
+	}
+
+	/* Minimal image validation... */
+	fsize = qla2x00_get_flash_size(ha);
+	if (!fsize || fsize != fw_entry->size) {
+		qla_printk(KERN_ERR, ha,
+		    "Invalid flash image file: '%s' %x/%x\n", fname,
+		    fw_entry->size, fsize);
+		release_firmware(fw_entry);
+		return -EINVAL;
+	}
+
+        /* Go with update... */
+	status = qla2x00_update_or_read_flash(ha, fw_entry->data, 0, fsize,
+	    QLA2X00_WRITE);
+	if (status) {
+		qla_printk(KERN_ERR, ha,
+		    "Unable to complete flash image update: '%s' %x\n", fname,
+		    fsize);
+		release_firmware(fw_entry);
+		return -EIO;
+	}
+
+	qla_printk(KERN_INFO, ha,
+	    "Flash image update complete: '%s' %x\n", fname, fsize);
+	release_firmware(fw_entry);
+
+	return count;
+}
+
 /* -------------------------------------------------------------------------- */
 static char *
 qla2x00_get_pci_info_str(struct scsi_qla_host *ha, char *str)
@@ -953,7 +1046,7 @@ qla2x00_eh_wait_on_command(scsi_qla_host
  *    Success (Adapter is online) : 0
  *    Failed  (Adapter is offline/disabled) : 1
  */
-static int 
+int 
 qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
 {
 	int 	 return_status;
===== drivers/scsi/qla2xxx/qla_sup.c 1.8 vs edited =====
--- 1.8/drivers/scsi/qla2xxx/qla_sup.c	2004-12-08 22:13:14 -08:00
+++ edited/drivers/scsi/qla2xxx/qla_sup.c	2005-02-09 16:31:32 -08:00
@@ -294,3 +294,812 @@ qla2x00_nv_write(scsi_qla_host_t *ha, ui
 	NVRAM_DELAY();
 }
 
+/*
+ * Flash support routines
+ */
+
+/**
+ * qla2x00_flash_enable() - Setup flash for reading and writing.
+ * @ha: HA context
+ */
+void
+qla2x00_flash_enable(scsi_qla_host_t *ha)
+{
+	uint16_t	data;
+	device_reg_t	*reg = ha->iobase;
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
+void
+qla2x00_flash_disable(scsi_qla_host_t *ha)
+{
+	uint16_t	data;
+	device_reg_t	*reg = ha->iobase;
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
+uint8_t
+qla2x00_read_flash_byte(scsi_qla_host_t *ha, uint32_t addr)
+{
+	uint16_t	data;
+	uint16_t	bank_select;
+	device_reg_t	*reg = ha->iobase;
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
+		return ((uint8_t)data);
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
+	/* The ISP2312 v2 chip cannot access the FLASH registers via MMIO. */
+	if (IS_QLA2312(ha) && ha->pio_address) {
+		uint16_t data2;
+
+		reg = (device_reg_t *)ha->pio_address;
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
+	return ((uint8_t)data);
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
+	uint16_t	bank_select;
+	device_reg_t	*reg = ha->iobase;
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
+	/* The ISP2312 v2 chip cannot access the FLASH registers via MMIO. */
+	if (IS_QLA2312(ha) && ha->pio_address) {
+		reg = (device_reg_t *)ha->pio_address;
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
+static uint8_t
+qla2x00_poll_flash(scsi_qla_host_t *ha, uint32_t addr, uint8_t poll_data,
+    uint8_t man_id, uint8_t flash_id)
+{
+	uint8_t		status;
+	uint8_t		flash_data;
+	uint32_t	cnt;
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
+	return (status);
+}
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
+static uint8_t
+qla2x00_program_flash_address(scsi_qla_host_t *ha, uint32_t addr, uint8_t data,
+    uint8_t man_id, uint8_t flash_id)
+{
+	/* Write Program Command Sequence */
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
+	return (qla2x00_poll_flash(ha, addr, data, man_id, flash_id));
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
+static uint8_t
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
+	return (qla2x00_poll_flash(ha, 0x00, 0x80, man_id, flash_id));
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
+static uint8_t
+qla2x00_erase_flash_sector(scsi_qla_host_t *ha, uint32_t addr,
+    uint32_t sec_mask, uint8_t man_id, uint8_t flash_id)
+{
+	/* Individual Sector Erase Command Sequence */
+	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
+	qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
+	qla2x00_write_flash_byte(ha, 0x5555, 0x80);
+	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
+	qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
+	qla2x00_write_flash_byte(ha, addr & sec_mask, 0x30);
+
+	udelay(150);
+
+	/* Wait for erase to complete. */
+	return (qla2x00_poll_flash(ha, addr, 0x80, man_id, flash_id));
+}
+
+/**
+ * qla2x00_get_flash_manufacturer() - Read manufacturer ID from flash chip.
+ * @man_id: Flash manufacturer ID
+ * @flash_id: Flash ID
+ *
+ */
+void
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
+/**
+ * qla2x00_set_flash_image() - Write image to flash chip.
+ * @ha: HA context
+ * @image: Source image to write to flash
+ *
+ * Returns 0 on success, else non-zero.
+ */
+uint16_t
+qla2x00_set_flash_image(scsi_qla_host_t *ha, uint8_t *image, uint32_t saddr,
+    uint32_t length)
+{
+	uint16_t	status;
+	uint32_t	addr;
+	uint32_t	liter;
+	uint32_t	sec_mask;
+	uint32_t	rest_addr;
+	uint8_t		man_id, flash_id;
+	uint8_t		sec_number;
+	uint8_t		data;
+	device_reg_t	*reg = ha->iobase;
+
+	status = 0;
+	sec_number = 0;
+
+	/* Reset ISP chip. */
+	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+	RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+
+	qla2x00_flash_enable(ha);
+	do {	/* Loop once to provide quick error exit */
+		/* Structure of flash memory based on manufacturer */
+		if (IS_OEM_001(ha)) {
+			// OEM variant with special flash part.
+			man_id = flash_id = 0;
+			rest_addr = 0xffff;
+			sec_mask   = 0x10000;
+			goto update_flash;
+		}
+		qla2x00_get_flash_manufacturer(ha, &man_id, &flash_id);
+		DEBUG9(printk("%s(%ld): Flash man_id=%d flash_id=%d\n",
+		    __func__, ha->host_no, man_id, flash_id));
+		switch (man_id) {
+		case 0x20: // ST flash
+			if (flash_id == 0xd2 || flash_id == 0xe3) {
+				// ST m29w008at part - 64kb sector size with
+				// 32kb,8kb,8kb,16kb sectors at memory address
+				// 0xf0000
+				rest_addr = 0xffff;
+				sec_mask = 0x10000;
+				break;   
+			}
+			// ST m29w010b part - 16kb sector size  
+			// Default to 16kb sectors      
+			rest_addr = 0x3fff;
+			sec_mask = 0x1c000;
+			break;   
+		case 0x40: // Mostel flash
+			// Mostel v29c51001 part - 512 byte sector size  
+			rest_addr = 0x1ff;
+			sec_mask = 0x1fe00;
+			break;   
+		case 0xbf: // SST flash
+			// SST39sf10 part - 4kb sector size   
+			rest_addr = 0xfff;
+			sec_mask = 0x1f000;
+			break;
+		case 0xda: // Winbond flash
+			// Winbond W29EE011 part - 256 byte sector size   
+			rest_addr = 0x7f;
+			sec_mask = 0x1ff80;
+			break;
+		case 0xc2: // Macronix flash
+			// 64k sector size    
+			if (flash_id == 0x38) {
+				rest_addr = 0xffff;
+				sec_mask = 0x10000;
+				break;
+			}
+			// Fall through...
+
+		case 0x1f: // Atmel flash
+			// 512k sector size    
+			if (flash_id == 0x13) {
+				rest_addr = 0x7fffffff;
+				sec_mask =   0x80000000;
+				break;
+			}   
+			// Fall through...
+
+		case 0x01: // AMD flash 
+			if (flash_id == 0x38 || flash_id == 0x40 ||
+			    flash_id == 0x4f) {
+				// Am29LV081 part - 64kb sector size   
+				// Am29LV002BT part - 64kb sector size   
+				rest_addr = 0xffff;
+				sec_mask = 0x10000;
+				break;
+			} else if (flash_id == 0x3e) {
+				// Am29LV008b part - 64kb sector size with
+				// 32kb,8kb,8kb,16kb sector at memory address
+				// 0xf0000
+				rest_addr = 0xffff;
+				sec_mask = 0x10000;
+				break;
+			} else if (flash_id == 0x20 || flash_id == 0x6e) {
+				// Am29LV010 part or AM29f010 - 16kb sector
+				// size   
+				rest_addr = 0x3fff;
+				sec_mask = 0x1c000;
+				break;
+			} else if (flash_id == 0x6d) {
+				// Am29LV001 part - 8kb sector size   
+				rest_addr = 0x1fff;
+				sec_mask = 0x1e000;
+				break;
+			}   
+		default:
+			// Default to 16 kb sector size  
+			rest_addr = 0x3fff;
+			sec_mask = 0x1c000;
+			break;
+		}
+
+update_flash:
+		if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
+			if (qla2x00_erase_flash(ha, man_id, flash_id)) {
+				status = 1;
+				break;
+			}
+		}
+
+		for (addr = saddr, liter = 0; liter < length; liter++, addr++) {
+			data = image[liter];
+			/* Are we at the beginning of a sector? */
+			if ((addr & rest_addr) == 0) {
+				if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
+					if (addr >= 0x10000UL) {
+						if (((addr >> 12) & 0xf0) &&
+						    ((man_id == 0x01 && flash_id == 0x3e) ||
+						    (man_id == 0x20 && flash_id == 0xd2))) {
+							sec_number++;
+							if (sec_number == 1) {   
+								rest_addr = 0x7fff;
+								sec_mask = 0x18000;
+							} else if (sec_number == 2 ||
+							    sec_number == 3) {
+								rest_addr = 0x1fff;
+								sec_mask = 0x1e000;
+							} else if (sec_number == 4) {
+								rest_addr = 0x3fff;
+								sec_mask = 0x1c000;
+							}         
+						}                           
+					}    
+				} else if (addr == FLASH_IMAGE_SIZE / 2) {
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
+					if (qla2x00_erase_flash_sector(ha, addr,
+					    sec_mask, man_id, flash_id)) {
+						DEBUG9(printk("%s(%ld) Unable "
+						    "to erase flash sector "
+						    "addr=%x mask=%x.\n",
+						    __func__, ha->host_no, addr,
+						    sec_mask));
+						status = 1;
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
+				DEBUG9(printk("%s(%ld) Unable to program flash "
+				    "address=%x data=%x.\n", __func__,
+				    ha->host_no, addr, data));
+				status = 1;
+				break;
+			}
+		}
+	} while (0);
+	qla2x00_flash_disable(ha);
+
+	return (status);
+}
+
+
+/* qla2x00_cmd_wait
+ *	Stall driver until all outstanding commands are returned.
+ *
+ * Input:
+ *	ha = adapter state pointer.
+ *
+ * Return;
+ *  0 -- Done
+ *  1 -- cmds still outstanding
+ *
+ * Context:
+ *  This routine must be called without hardware_lock held.
+ */
+int
+qla2x00_cmd_wait(scsi_qla_host_t *ha) 
+{
+	int status = 0;
+	int index = 0;
+	int wait_cnt = 30; 
+	unsigned long cpu_flags;
+
+	DEBUG(printk("%s(%ld): Started\n",__func__,ha->host_no));
+
+	while (wait_cnt) {
+		/* Find a command that hasn't completed. */
+		for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+			spin_lock_irqsave(&ha->hardware_lock, cpu_flags);  
+			if (ha->outstanding_cmds[index] != NULL) {
+				spin_unlock_irqrestore(&ha->hardware_lock,
+				    cpu_flags); 
+				break;
+			}
+			spin_unlock_irqrestore(&ha->hardware_lock, cpu_flags);  
+		}
+
+		/* If No Commands are pending wait is complete */
+		if (index == MAX_OUTSTANDING_COMMANDS)
+			break;
+
+		/*
+		 * If we timed out on waiting for commands to come back Reset
+		 * the ISP
+		 */
+		wait_cnt--;
+		if (wait_cnt == 0) {
+			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			status = 1;
+			DEBUG(printk("%s(%ld): ISP abort - handle %d\n",
+			    __func__, ha->host_no, index));
+		} else {
+			/* sleep a second */
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(HZ);
+		}
+	}
+
+	DEBUG(printk("%s(%ld): Done waiting on commands - ind=%d\n",
+	    __func__, ha->host_no, index));
+
+	return status;
+}
+
+/*
+ *  qla2x00_suspend_target
+ *	Suspend target
+ *
+ * Input:
+ *	ha = visable adapter block pointer.
+ *  target = target queue
+ *  time = time in seconds
+ *
+ * Return:
+ *     QL_STATUS_SUCCESS  -- suspended lun 
+ *     QL_STATUS_ERROR  -- Didn't suspend lun
+ *
+ * Context:
+ *	Interrupt context.
+ */
+int
+qla2x00_suspend_target(scsi_qla_host_t *ha, os_tgt_t *tq, int time)
+{
+	srb_t *sp, *sptemp;
+	unsigned long flags;
+
+	if (test_bit(TQF_SUSPENDED, &tq->flags))
+		return QLA_FUNCTION_FAILED;
+
+	/* now suspend the lun */
+	set_bit(TQF_SUSPENDED, &tq->flags);
+
+	DEBUG2(printk(KERN_INFO
+	    "scsi%ld: Starting - suspend target for %d secs\n", ha->host_no,
+	    time));
+
+	/*
+	 * Remove all (TARGET) pending commands from request queue and put them
+	 * in the scsi_retry queue.
+	 */
+	spin_lock_irqsave(&ha->list_lock, flags);
+	list_for_each_entry_safe(sp, sptemp, &ha->pending_queue, list) {
+		if (sp->tgt_queue != tq)
+			continue;
+
+		DEBUG3(printk("scsi%ld: %s requeue for suspended target %p\n",
+		    ha->host_no, __func__, sp));
+
+		__del_from_pending_queue(ha, sp);
+		__add_to_scsi_retry_queue(ha,sp);
+	}
+	spin_unlock_irqrestore(&ha->list_lock, flags);
+
+	return QLA_SUCCESS;
+}
+
+/*
+ *  qla2x00_unsuspend_all_target
+ *	Unsuspend all target. 
+ *
+ * Input:
+ *	ha = visable adapter block pointer.
+ *
+ * Return:
+ *
+ * Context:
+ *	Process context.
+ */
+void
+qla2x00_unsuspend_all_target(scsi_qla_host_t *ha)
+{
+	os_tgt_t *tq;
+	int 	 t;
+
+	for (t = 0; t < ha->max_targets; t++) {
+		if ((tq = ha->otgt[t]) == NULL)
+			continue;
+
+		clear_bit(TQF_SUSPENDED, &tq->flags); 
+	}
+}
+
+/*
+ *  qla2x00_suspend_all_target
+ *	Suspend all target indefinitely. Caller need to make sure
+ *	to explicitly unsuspend it later on.
+ *
+ * Input:
+ *	ha = visable adapter block pointer.
+ *  target = target queue
+ *  time = time in seconds
+ *
+ * Return:
+ *     QL_STATUS_SUCCESS  -- suspended lun 
+ *     QL_STATUS_ERROR  -- Didn't suspend lun
+ *
+ * Context:
+ *	qla2x00_suspend_target can be called in Interrupt context.
+ *	Hold the hardware lock for synchronisation.
+ */
+int
+qla2x00_suspend_all_target(scsi_qla_host_t *ha)
+{
+	int  status = 0;	
+	os_tgt_t *tq;
+	int 	 t, time;
+	unsigned long cpu_flags = 0;
+
+	/* Suspend the Target until explicitly cleared */
+	time = 0;
+
+	for (t = 0; t < ha->max_targets; t++) {
+		if ((tq = ha->otgt[t]) == NULL)
+			continue;
+
+		spin_lock_irqsave(&ha->hardware_lock, cpu_flags);
+		status = qla2x00_suspend_target(ha, tq, time);
+		spin_unlock_irqrestore(&ha->hardware_lock, cpu_flags);
+	}
+
+	return status;
+}
+
+uint16_t
+qla2x00_read_flash_image(scsi_qla_host_t *ha, uint8_t *usr_tmp, uint32_t saddr,
+    uint32_t length)
+{
+	device_reg_t	*reg = ha->iobase;
+	uint32_t	midpoint;
+	uint8_t		data;
+	uint32_t	ilength;
+	uint16_t	status = 0;
+
+	midpoint = length / 2;
+	qla2x00_flash_enable(ha);
+	WRT_REG_WORD(&reg->nvram, 0);
+	RD_REG_WORD(&reg->nvram);
+	for (ilength = 0; ilength < length; saddr++, ilength++, usr_tmp++) {
+		if (ilength == midpoint) {
+			WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+			RD_REG_WORD(&reg->nvram);
+		}
+		data = qla2x00_read_flash_byte(ha, saddr);
+		if (saddr % 100)
+			udelay(10);
+		__put_user(data, usr_tmp);
+	}
+	qla2x00_flash_disable(ha);
+	
+	return (status);
+}
+
+uint16_t
+qla2x00_update_or_read_flash(scsi_qla_host_t *ha, uint8_t *image,
+    uint32_t saddr, uint32_t length, uint8_t direction)
+{
+	uint16_t    status;	
+	unsigned long flags;
+	uint32_t	cnt;
+	device_reg_t	*reg = ha->iobase;
+
+	/* Not setting the timer so that tgt remains unsuspended */
+	qla2x00_suspend_all_target(ha);
+
+	/* wait for big hammer to complete if it fails */
+	status = qla2x00_cmd_wait(ha);
+	if (status)
+		qla2x00_wait_for_hba_online(ha);
+
+	/* Dont process mailbox cmd until flash operation is done */
+	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
+
+	qla2x00_disable_intrs(ha);
+
+	/* Pause RISC. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
+	RD_REG_WORD(&reg->hccr);
+	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
+		for (cnt = 0; cnt < 30000; cnt++) {
+			if ((RD_REG_WORD(&reg->hccr) &
+			    HCCR_RISC_PAUSE) != 0)
+				break;
+			udelay(100);
+		}
+	} else {
+		udelay(10);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	switch (direction) {
+	case QLA2X00_READ:
+		DEBUG9(printk("%s(%ld): Reading image=%p saddr=0x%x "
+		    "length=0x%x\n", __func__, ha->host_no, image, saddr,
+		    length));		
+		status = qla2x00_read_flash_image(ha, image, saddr, length);
+		break;
+
+	case QLA2X00_WRITE:
+		DEBUG9(printk("%s(%ld): Writing image=%p saddr=0x%x "
+		    "length=0x%x\n", __func__, ha->host_no, image, saddr,
+		    length));		
+		status = qla2x00_set_flash_image(ha, image, saddr, length);
+		break;
+	default:
+		printk(KERN_INFO "%s unknown operation\n", __func__);
+		break;
+	}
+
+	/* Schedule DPC to restart the RISC */
+	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+	up(ha->dpc_wait);
+	qla2x00_wait_for_hba_online(ha);
+
+	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
+	
+	qla2x00_unsuspend_all_target(ha);
+
+	return status;
+}
