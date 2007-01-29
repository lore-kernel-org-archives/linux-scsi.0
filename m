From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/14] qla2xxx: Export OptionROM boot-codes version information.
Date: Mon, 29 Jan 2007 10:22:21 -0800
Message-ID: <11700949513213-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbXA2SWn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:43 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

This includes BIOS, EFI, FCODE and firmware versions.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   49 ++++++
 drivers/scsi/qla2xxx/qla_def.h  |   11 ++
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 +
 drivers/scsi/qla2xxx/qla_init.c |    4 +
 drivers/scsi/qla2xxx/qla_os.c   |    2 +
 drivers/scsi/qla2xxx/qla_sup.c  |  347 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 416 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7b18a6c..78a5867 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -653,6 +653,43 @@ qla2x00_beacon_store(struct class_device *cdev, const char *buf,
 	return count;
 }
 
+static ssize_t
+qla2x00_optrom_bios_version_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+
+	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->bios_revision[1],
+	    ha->bios_revision[0]);
+}
+
+static ssize_t
+qla2x00_optrom_efi_version_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+
+	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->efi_revision[1],
+	    ha->efi_revision[0]);
+}
+
+static ssize_t
+qla2x00_optrom_fcode_version_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+
+	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->fcode_revision[1],
+	    ha->fcode_revision[0]);
+}
+
+static ssize_t
+qla2x00_optrom_fw_version_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+
+	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d %d\n",
+	    ha->fw_revision[0], ha->fw_revision[1], ha->fw_revision[2],
+	    ha->fw_revision[3]);
+}
+
 static CLASS_DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show,
 	NULL);
 static CLASS_DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
@@ -669,6 +706,14 @@ static CLASS_DEVICE_ATTR(zio_timer, S_IRUGO | S_IWUSR, qla2x00_zio_timer_show,
     qla2x00_zio_timer_store);
 static CLASS_DEVICE_ATTR(beacon, S_IRUGO | S_IWUSR, qla2x00_beacon_show,
     qla2x00_beacon_store);
+static CLASS_DEVICE_ATTR(optrom_bios_version, S_IRUGO,
+    qla2x00_optrom_bios_version_show, NULL);
+static CLASS_DEVICE_ATTR(optrom_efi_version, S_IRUGO,
+    qla2x00_optrom_efi_version_show, NULL);
+static CLASS_DEVICE_ATTR(optrom_fcode_version, S_IRUGO,
+    qla2x00_optrom_fcode_version_show, NULL);
+static CLASS_DEVICE_ATTR(optrom_fw_version, S_IRUGO,
+    qla2x00_optrom_fw_version_show, NULL);
 
 struct class_device_attribute *qla2x00_host_attrs[] = {
 	&class_device_attr_driver_version,
@@ -683,6 +728,10 @@ struct class_device_attribute *qla2x00_host_attrs[] = {
 	&class_device_attr_zio,
 	&class_device_attr_zio_timer,
 	&class_device_attr_beacon,
+	&class_device_attr_optrom_bios_version,
+	&class_device_attr_optrom_efi_version,
+	&class_device_attr_optrom_fcode_version,
+	&class_device_attr_optrom_fw_version,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 53dd546..aba63b0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2045,6 +2045,8 @@ struct isp_operations {
 		uint32_t, uint32_t);
 	int (*write_optrom) (struct scsi_qla_host *, uint8_t *, uint32_t,
 		uint32_t);
+
+	int (*get_flash_version) (struct scsi_qla_host *, void *);
 };
 
 /* MSI-X Support *************************************************************/
@@ -2402,6 +2404,15 @@ typedef struct scsi_qla_host {
 #define QLA_SREADING	1
 #define QLA_SWRITING	2
 
+        /* PCI expansion ROM image information. */
+#define ROM_CODE_TYPE_BIOS	0
+#define ROM_CODE_TYPE_FCODE	1
+#define ROM_CODE_TYPE_EFI	3
+	uint8_t		bios_revision[2];
+	uint8_t		efi_revision[2];
+	uint8_t		fcode_revision[16];
+	uint32_t	fw_revision[4];
+
 	/* Needed for BEACON */
 	uint16_t	beacon_blink_led;
 	uint8_t		beacon_color_state;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 7a7b7e9..74544ae 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -262,6 +262,9 @@ extern uint8_t *qla24xx_read_optrom_data(struct scsi_qla_host *, uint8_t *,
 extern int qla24xx_write_optrom_data(struct scsi_qla_host *, uint8_t *,
     uint32_t, uint32_t);
 
+extern int qla2x00_get_flash_version(scsi_qla_host_t *, void *);
+extern int qla24xx_get_flash_version(scsi_qla_host_t *, void *);
+
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e594915..cef24f3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -84,6 +84,8 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 
 	ha->isp_ops.reset_chip(ha);
 
+	ha->isp_ops.get_flash_version(ha, ha->request_ring);
+
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
 
 	ha->isp_ops.nvram_config(ha);
@@ -3109,6 +3111,8 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 		}
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
+		ha->isp_ops.get_flash_version(ha, ha->request_ring);
+
 		ha->isp_ops.nvram_config(ha);
 
 		if (!qla2x00_restart_isp(ha)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1f8d04c..fc99398 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1485,6 +1485,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->isp_ops.fw_dump		= qla2100_fw_dump;
 	ha->isp_ops.read_optrom		= qla2x00_read_optrom_data;
 	ha->isp_ops.write_optrom	= qla2x00_write_optrom_data;
+	ha->isp_ops.get_flash_version	= qla2x00_get_flash_version;
 	if (IS_QLA2100(ha)) {
 		host->max_id = MAX_TARGETS_2100;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT_2100;
@@ -1550,6 +1551,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->isp_ops.beacon_on = qla24xx_beacon_on;
 		ha->isp_ops.beacon_off = qla24xx_beacon_off;
 		ha->isp_ops.beacon_blink = qla24xx_beacon_blink;
+		ha->isp_ops.get_flash_version = qla24xx_get_flash_version;
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_24XX;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 7bbe751..ff1dd41 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1382,6 +1382,29 @@ qla2x00_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
 	qla2x00_write_flash_byte(ha, 0x5555, 0xf0);
 }
 
+static void
+qla2x00_read_flash_data(scsi_qla_host_t *ha, uint8_t *tmp_buf, uint32_t saddr,
+        uint32_t length)
+{
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	uint32_t midpoint, ilength;
+	uint8_t data;
+
+	midpoint = length / 2;
+
+	WRT_REG_WORD(&reg->nvram, 0);
+	RD_REG_WORD(&reg->nvram);
+	for (ilength = 0; ilength < length; saddr++, ilength++, tmp_buf++) {
+		if (ilength == midpoint) {
+			WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+			RD_REG_WORD(&reg->nvram);
+		}
+		data = qla2x00_read_flash_byte(ha, saddr);
+		if (saddr % 100)
+			udelay(10);
+		*tmp_buf = data;
+	}
+}
 
 static inline void
 qla2x00_suspend_hba(struct scsi_qla_host *ha)
@@ -1721,3 +1744,327 @@ qla24xx_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 
 	return rval;
 }
+
+/**
+ * qla2x00_get_fcode_version() - Determine an FCODE image's version.
+ * @ha: HA context
+ * @pcids: Pointer to the FCODE PCI data structure
+ *
+ * The process of retrieving the FCODE version information is at best
+ * described as interesting.
+ *
+ * Within the first 100h bytes of the image an ASCII string is present
+ * which contains several pieces of information including the FCODE
+ * version.  Unfortunately it seems the only reliable way to retrieve
+ * the version is by scanning for another sentinel within the string,
+ * the FCODE build date:
+ *
+ *	... 2.00.02 10/17/02 ...
+ *
+ * Returns QLA_SUCCESS on successful retrieval of version.
+ */
+static void
+qla2x00_get_fcode_version(scsi_qla_host_t *ha, uint32_t pcids)
+{
+	int ret = QLA_FUNCTION_FAILED;
+	uint32_t istart, iend, iter, vend;
+	uint8_t do_next, rbyte, *vbyte;
+
+	memset(ha->fcode_revision, 0, sizeof(ha->fcode_revision));
+
+	/* Skip the PCI data structure. */
+	istart = pcids +
+	    ((qla2x00_read_flash_byte(ha, pcids + 0x0B) << 8) |
+		qla2x00_read_flash_byte(ha, pcids + 0x0A));
+	iend = istart + 0x100;
+	do {
+		/* Scan for the sentinel date string...eeewww. */
+		do_next = 0;
+		iter = istart;
+		while ((iter < iend) && !do_next) {
+			iter++;
+			if (qla2x00_read_flash_byte(ha, iter) == '/') {
+				if (qla2x00_read_flash_byte(ha, iter + 2) ==
+				    '/')
+					do_next++;
+				else if (qla2x00_read_flash_byte(ha,
+				    iter + 3) == '/')
+					do_next++;
+			}
+		}
+		if (!do_next)
+			break;
+
+		/* Backtrack to previous ' ' (space). */
+		do_next = 0;
+		while ((iter > istart) && !do_next) {
+			iter--;
+			if (qla2x00_read_flash_byte(ha, iter) == ' ')
+				do_next++;
+		}
+		if (!do_next)
+			break;
+
+		/*
+		 * Mark end of version tag, and find previous ' ' (space) or
+		 * string length (recent FCODE images -- major hack ahead!!!).
+		 */
+		vend = iter - 1;
+		do_next = 0;
+		while ((iter > istart) && !do_next) {
+			iter--;
+			rbyte = qla2x00_read_flash_byte(ha, iter);
+			if (rbyte == ' ' || rbyte == 0xd || rbyte == 0x10)
+				do_next++;
+		}
+		if (!do_next)
+			break;
+
+		/* Mark beginning of version tag, and copy data. */
+		iter++;
+		if ((vend - iter) &&
+		    ((vend - iter) < sizeof(ha->fcode_revision))) {
+			vbyte = ha->fcode_revision;
+			while (iter <= vend) {
+				*vbyte++ = qla2x00_read_flash_byte(ha, iter);
+				iter++;
+			}
+			ret = QLA_SUCCESS;
+		}
+	} while (0);
+
+	if (ret != QLA_SUCCESS)
+		memset(ha->fcode_revision, 0, sizeof(ha->fcode_revision));
+}
+
+int
+qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
+{
+	int ret = QLA_SUCCESS;
+	uint8_t code_type, last_image;
+	uint32_t pcihdr, pcids;
+	uint8_t *dbyte;
+	uint16_t *dcode;
+
+	if (!ha->pio_address || !mbuf)
+		return QLA_FUNCTION_FAILED;
+
+	memset(ha->bios_revision, 0, sizeof(ha->bios_revision));
+	memset(ha->efi_revision, 0, sizeof(ha->efi_revision));
+	memset(ha->fcode_revision, 0, sizeof(ha->fcode_revision));
+	memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
+
+	qla2x00_flash_enable(ha);
+
+	/* Begin with first PCI expansion ROM header. */
+	pcihdr = 0;
+	last_image = 1;
+	do {
+		/* Verify PCI expansion ROM header. */
+		if (qla2x00_read_flash_byte(ha, pcihdr) != 0x55 ||
+		    qla2x00_read_flash_byte(ha, pcihdr + 0x01) != 0xaa) {
+			/* No signature */
+			DEBUG2(printk("scsi(%ld): No matching ROM "
+			    "signature.\n", ha->host_no));
+			ret = QLA_FUNCTION_FAILED;
+			break;
+		}
+
+		/* Locate PCI data structure. */
+		pcids = pcihdr +
+		    ((qla2x00_read_flash_byte(ha, pcihdr + 0x19) << 8) |
+			qla2x00_read_flash_byte(ha, pcihdr + 0x18));
+
+		/* Validate signature of PCI data structure. */
+		if (qla2x00_read_flash_byte(ha, pcids) != 'P' ||
+		    qla2x00_read_flash_byte(ha, pcids + 0x1) != 'C' ||
+		    qla2x00_read_flash_byte(ha, pcids + 0x2) != 'I' ||
+		    qla2x00_read_flash_byte(ha, pcids + 0x3) != 'R') {
+			/* Incorrect header. */
+			DEBUG2(printk("%s(): PCI data struct not found "
+			    "pcir_adr=%x.\n", __func__, pcids));
+			ret = QLA_FUNCTION_FAILED;
+			break;
+		}
+
+		/* Read version */
+		code_type = qla2x00_read_flash_byte(ha, pcids + 0x14);
+		switch (code_type) {
+		case ROM_CODE_TYPE_BIOS:
+			/* Intel x86, PC-AT compatible. */
+			ha->bios_revision[0] =
+			    qla2x00_read_flash_byte(ha, pcids + 0x12);
+			ha->bios_revision[1] =
+			    qla2x00_read_flash_byte(ha, pcids + 0x13);
+			DEBUG3(printk("%s(): read BIOS %d.%d.\n", __func__,
+			    ha->bios_revision[1], ha->bios_revision[0]));
+			break;
+		case ROM_CODE_TYPE_FCODE:
+			/* Open Firmware standard for PCI (FCode). */
+			/* Eeeewww... */
+			qla2x00_get_fcode_version(ha, pcids);
+			break;
+		case ROM_CODE_TYPE_EFI:
+			/* Extensible Firmware Interface (EFI). */
+			ha->efi_revision[0] =
+			    qla2x00_read_flash_byte(ha, pcids + 0x12);
+			ha->efi_revision[1] =
+			    qla2x00_read_flash_byte(ha, pcids + 0x13);
+			DEBUG3(printk("%s(): read EFI %d.%d.\n", __func__,
+			    ha->efi_revision[1], ha->efi_revision[0]));
+			break;
+		default:
+			DEBUG2(printk("%s(): Unrecognized code type %x at "
+			    "pcids %x.\n", __func__, code_type, pcids));
+			break;
+		}
+
+		last_image = qla2x00_read_flash_byte(ha, pcids + 0x15) & BIT_7;
+
+		/* Locate next PCI expansion ROM. */
+		pcihdr += ((qla2x00_read_flash_byte(ha, pcids + 0x11) << 8) |
+		    qla2x00_read_flash_byte(ha, pcids + 0x10)) * 512;
+	} while (!last_image);
+
+	if (IS_QLA2322(ha)) {
+		/* Read firmware image information. */
+		memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
+		dbyte = mbuf;
+		memset(dbyte, 0, 8);
+		dcode = (uint16_t *)dbyte;
+
+		qla2x00_read_flash_data(ha, dbyte, FA_RISC_CODE_ADDR * 4 + 10,
+		    8);
+		DEBUG3(printk("%s(%ld): dumping fw ver from flash:\n",
+		    __func__, ha->host_no));
+		DEBUG3(qla2x00_dump_buffer((uint8_t *)dbyte, 8));
+
+		if ((dcode[0] == 0xffff && dcode[1] == 0xffff &&
+		    dcode[2] == 0xffff && dcode[3] == 0xffff) ||
+		    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
+		    dcode[3] == 0)) {
+			DEBUG2(printk("%s(): Unrecognized fw revision at "
+			    "%x.\n", __func__, FA_RISC_CODE_ADDR * 4));
+		} else {
+			/* values are in big endian */
+			ha->fw_revision[0] = dbyte[0] << 16 | dbyte[1];
+			ha->fw_revision[1] = dbyte[2] << 16 | dbyte[3];
+			ha->fw_revision[2] = dbyte[4] << 16 | dbyte[5];
+		}
+	}
+
+	qla2x00_flash_disable(ha);
+
+	return ret;
+}
+
+int
+qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
+{
+	int ret = QLA_SUCCESS;
+	uint32_t pcihdr, pcids;
+	uint32_t *dcode;
+	uint8_t *bcode;
+	uint8_t code_type, last_image;
+	int i;
+
+	if (!mbuf)
+		return QLA_FUNCTION_FAILED;
+
+	memset(ha->bios_revision, 0, sizeof(ha->bios_revision));
+	memset(ha->efi_revision, 0, sizeof(ha->efi_revision));
+	memset(ha->fcode_revision, 0, sizeof(ha->fcode_revision));
+	memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
+
+	dcode = mbuf;
+
+	/* Begin with first PCI expansion ROM header. */
+	pcihdr = 0;
+	last_image = 1;
+	do {
+		/* Verify PCI expansion ROM header. */
+		qla24xx_read_flash_data(ha, dcode, pcihdr >> 2, 0x20);
+		bcode = mbuf + (pcihdr % 4);
+		if (bcode[0x0] != 0x55 || bcode[0x1] != 0xaa) {
+			/* No signature */
+			DEBUG2(printk("scsi(%ld): No matching ROM "
+			    "signature.\n", ha->host_no));
+			ret = QLA_FUNCTION_FAILED;
+			break;
+		}
+
+		/* Locate PCI data structure. */
+		pcids = pcihdr + ((bcode[0x19] << 8) | bcode[0x18]);
+
+		qla24xx_read_flash_data(ha, dcode, pcids >> 2, 0x20);
+		bcode = mbuf + (pcihdr % 4);
+
+		/* Validate signature of PCI data structure. */
+		if (bcode[0x0] != 'P' || bcode[0x1] != 'C' ||
+		    bcode[0x2] != 'I' || bcode[0x3] != 'R') {
+			/* Incorrect header. */
+			DEBUG2(printk("%s(): PCI data struct not found "
+			    "pcir_adr=%x.\n", __func__, pcids));
+			ret = QLA_FUNCTION_FAILED;
+			break;
+		}
+
+		/* Read version */
+		code_type = bcode[0x14];
+		switch (code_type) {
+		case ROM_CODE_TYPE_BIOS:
+			/* Intel x86, PC-AT compatible. */
+			ha->bios_revision[0] = bcode[0x12];
+			ha->bios_revision[1] = bcode[0x13];
+			DEBUG3(printk("%s(): read BIOS %d.%d.\n", __func__,
+			    ha->bios_revision[1], ha->bios_revision[0]));
+			break;
+		case ROM_CODE_TYPE_FCODE:
+			/* Open Firmware standard for PCI (FCode). */
+			ha->fcode_revision[0] = bcode[0x12];
+			ha->fcode_revision[1] = bcode[0x13];
+			DEBUG3(printk("%s(): read FCODE %d.%d.\n", __func__,
+			    ha->fcode_revision[1], ha->fcode_revision[0]));
+			break;
+		case ROM_CODE_TYPE_EFI:
+			/* Extensible Firmware Interface (EFI). */
+			ha->efi_revision[0] = bcode[0x12];
+			ha->efi_revision[1] = bcode[0x13];
+			DEBUG3(printk("%s(): read EFI %d.%d.\n", __func__,
+			    ha->efi_revision[1], ha->efi_revision[0]));
+			break;
+		default:
+			DEBUG2(printk("%s(): Unrecognized code type %x at "
+			    "pcids %x.\n", __func__, code_type, pcids));
+			break;
+		}
+
+		last_image = bcode[0x15] & BIT_7;
+
+		/* Locate next PCI expansion ROM. */
+		pcihdr += ((bcode[0x11] << 8) | bcode[0x10]) * 512;
+	} while (!last_image);
+
+	/* Read firmware image information. */
+	memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
+	dcode = mbuf;
+
+	qla24xx_read_flash_data(ha, dcode, FA_RISC_CODE_ADDR + 4, 4);
+	for (i = 0; i < 4; i++)
+		dcode[i] = be32_to_cpu(dcode[i]);
+
+	if ((dcode[0] == 0xffffffff && dcode[1] == 0xffffffff &&
+	    dcode[2] == 0xffffffff && dcode[3] == 0xffffffff) ||
+	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
+	    dcode[3] == 0)) {
+		DEBUG2(printk("%s(): Unrecognized fw version at %x.\n",
+		    __func__, FA_RISC_CODE_ADDR));
+	} else {
+		ha->fw_revision[0] = dcode[0];
+		ha->fw_revision[1] = dcode[1];
+		ha->fw_revision[2] = dcode[2];
+		ha->fw_revision[3] = dcode[3];
+	}
+
+	return ret;
+}
-- 
1.5.0.rc2.gdbaa0

