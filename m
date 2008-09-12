From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/8] qla2xxx: Add Flash Layout Table support.
Date: Thu, 11 Sep 2008 21:22:49 -0700
Message-ID: <1221193374-77635-4-git-send-email-andrew.vasquez@qlogic.com>
References: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46751 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYILEW7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 00:22:59 -0400
In-Reply-To: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The Flash Layout Table (FLT) present on many recent HBAs encodes
flash usage information, organizes data stored into separate
regions and presents the information uniformly to the driver.
Use this information rather than using specific hard-coded values
based on ISP type.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    7 +-
 drivers/scsi/qla2xxx/qla_def.h  |    8 +-
 drivers/scsi/qla2xxx/qla_fw.h   |   45 +++++++-
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |   10 ++-
 drivers/scsi/qla2xxx/qla_os.c   |    2 -
 drivers/scsi/qla2xxx/qla_sup.c  |  242 ++++++++++++++++++++++++++++++++++-----
 7 files changed, 272 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 866b0a8..0ddfe71 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -292,10 +292,11 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		valid = 0;
 		if (ha->optrom_size == OPTROM_SIZE_2300 && start == 0)
 			valid = 1;
-		else if (start == (FA_BOOT_CODE_ADDR*4) ||
-		    start == (FA_RISC_CODE_ADDR*4))
+		else if (start == (ha->flt_region_boot * 4) ||
+		    start == (ha->flt_region_fw * 4))
 			valid = 1;
-		else if (IS_QLA25XX(ha) && start == (FA_VPD_NVRAM_ADDR*4))
+		else if (IS_QLA25XX(ha) &&
+		    start == (ha->flt_region_vpd_nvram * 4))
 		    valid = 1;
 		if (!valid) {
 			qla_printk(KERN_WARNING, ha,
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d1160d2..880e711 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2508,7 +2508,6 @@ typedef struct scsi_qla_host {
 	uint64_t	fce_wr, fce_rd;
 	struct mutex	fce_mutex;
 
-	uint32_t	hw_event_start;
 	uint32_t	hw_event_ptr;
 	uint32_t	hw_event_pause_errors;
 
@@ -2554,6 +2553,13 @@ typedef struct scsi_qla_host {
 	uint32_t	fdt_unprotect_sec_cmd;
 	uint32_t	fdt_protect_sec_cmd;
 
+	uint32_t	flt_region_flt;
+	uint32_t	flt_region_fdt;
+	uint32_t	flt_region_boot;
+	uint32_t	flt_region_fw;
+	uint32_t	flt_region_vpd_nvram;
+	uint32_t	flt_region_hw_event;
+
 	/* Needed for BEACON */
 	uint16_t	beacon_blink_led;
 	uint8_t		beacon_color_state;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index cf19451..2ec986b 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -789,12 +789,16 @@ struct device_reg_24xx {
 #define FA_RISC_CODE_ADDR	0x20000
 #define FA_RISC_CODE_SEGMENTS	2
 
+#define FA_FLASH_DESCR_ADDR_24	0x11000
+#define FA_FLASH_LAYOUT_ADDR_24	0x11400
+
 #define FA_FW_AREA_ADDR		0x40000
 #define FA_VPD_NVRAM_ADDR	0x48000
 #define FA_FEATURE_ADDR		0x4C000
 #define FA_FLASH_DESCR_ADDR	0x50000
+#define FA_FLASH_LAYOUT_ADDR	0x50400
 #define FA_HW_EVENT0_ADDR	0x54000
-#define FA_HW_EVENT1_ADDR	0x54200
+#define FA_HW_EVENT1_ADDR	0x54400
 #define FA_HW_EVENT_SIZE	0x200
 #define FA_HW_EVENT_ENTRY_SIZE	4
 /*
@@ -806,10 +810,6 @@ struct device_reg_24xx {
 #define HW_EVENT_NVRAM_CHKSUM_ERR	0xF023
 #define HW_EVENT_FLASH_FW_ERR	0xF024
 
-#define FA_BOOT_LOG_ADDR	0x58000
-#define FA_FW_DUMP0_ADDR	0x60000
-#define FA_FW_DUMP1_ADDR	0x70000
-
 	uint32_t flash_data;		/* Flash/NVRAM BIOS data. */
 
 	uint32_t ctrl_status;		/* Control/Status. */
@@ -1203,6 +1203,41 @@ struct qla_fdt_layout {
 	uint8_t unused2[65];
 };
 
+/* Flash Layout Table ********************************************************/
+
+struct qla_flt_location {
+	uint8_t sig[4];
+	uint32_t start_lo;
+	uint32_t start_hi;
+	uint16_t unused;
+	uint16_t checksum;
+};
+
+struct qla_flt_header {
+	uint16_t version;
+	uint16_t length;
+	uint16_t checksum;
+	uint16_t unused;
+};
+
+#define FLT_REG_FW		0x01
+#define FLT_REG_BOOT_CODE	0x07
+#define FLT_REG_VPD_0		0x14
+#define FLT_REG_NVRAM_0		0x15
+#define FLT_REG_VPD_1		0x16
+#define FLT_REG_NVRAM_1		0x17
+#define FLT_REG_FDT		0x1a
+#define FLT_REG_FLT		0x1c
+#define FLT_REG_HW_EVENT_0	0x1d
+#define FLT_REG_HW_EVENT_1	0x1f
+
+struct qla_flt_region {
+	uint32_t code;
+	uint32_t size;
+	uint32_t start;
+	uint32_t end;
+};
+
 /* 84XX Support **************************************************************/
 
 #define MBA_ISP84XX_ALERT	0x800f  /* Alert Notification. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0b15673..dbd9f93 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -313,7 +313,7 @@ extern int qla24xx_get_flash_version(scsi_qla_host_t *, void *);
 extern int qla2xxx_hw_event_log(scsi_qla_host_t *, uint16_t , uint16_t,
     uint16_t, uint16_t);
 
-extern void qla2xxx_get_flash_info(scsi_qla_host_t *);
+extern int qla2xxx_get_flash_info(scsi_qla_host_t *);
 extern int qla2xxx_get_vpd_field(scsi_qla_host_t *, char *, char *, size_t);
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 57f24df..20847fb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -83,6 +83,13 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 
 	ha->isp_ops->reset_chip(ha);
 
+	rval = qla2xxx_get_flash_info(ha);
+	if (rval) {
+		DEBUG2(printk("scsi(%ld): Unable to validate FLASH data.\n",
+		    ha->host_no));
+		return (rval);
+	}
+
 	ha->isp_ops->get_flash_version(ha, ha->request_ring);
 
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
@@ -109,7 +116,6 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 		rval = qla2x00_setup_chip(ha);
 		if (rval)
 			return (rval);
-		qla2xxx_get_flash_info(ha);
 	}
 	if (IS_QLA84XX(ha)) {
 		ha->cs84xx = qla84xx_get_chip(ha);
@@ -3751,7 +3757,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 	rval = QLA_SUCCESS;
 
 	segments = FA_RISC_CODE_SEGMENTS;
-	faddr = FA_RISC_CODE_ADDR;
+	faddr = ha->flt_region_fw;
 	dcode = (uint32_t *)ha->request_ring;
 	*srisc_addr = 0;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 26afe44..f89f292 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1663,8 +1663,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_25XX;
 		ha->isp_ops = &qla25xx_isp_ops;
-		ha->hw_event_start = PCI_FUNC(pdev->devfn) ?
-		    FA_HW_EVENT1_ADDR: FA_HW_EVENT0_ADDR;
 	}
 	host->can_queue = ha->request_q_length + 128;
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 1bca744..6de1e3b 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -543,23 +543,186 @@ qla24xx_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
 	}
 }
 
-void
-qla2xxx_get_flash_info(scsi_qla_host_t *ha)
+static int
+qla2xxx_find_flt_start(scsi_qla_host_t *ha, uint32_t *start)
+{
+	const char *loc, *locations[] = { "DEF", "PCI" };
+	uint32_t pcihdr, pcids;
+	uint32_t *dcode;
+	uint8_t *buf, *bcode, last_image;
+	uint16_t cnt, chksum, *wptr;
+	struct qla_flt_location *fltl;
+
+	/*
+	 * FLT-location structure resides after the last PCI region.
+	 */
+
+	/* Begin with sane defaults. */
+	loc = locations[0];
+	*start = IS_QLA24XX_TYPE(ha) ? FA_FLASH_LAYOUT_ADDR_24:
+	    FA_FLASH_LAYOUT_ADDR;
+
+	/* Begin with first PCI expansion ROM header. */
+	buf = (uint8_t *)ha->request_ring;
+	dcode = (uint32_t *)ha->request_ring;
+	pcihdr = 0;
+	last_image = 1;
+	do {
+		/* Verify PCI expansion ROM header. */
+		qla24xx_read_flash_data(ha, dcode, pcihdr >> 2, 0x20);
+		bcode = buf + (pcihdr % 4);
+		if (bcode[0x0] != 0x55 || bcode[0x1] != 0xaa)
+			goto end;
+
+		/* Locate PCI data structure. */
+		pcids = pcihdr + ((bcode[0x19] << 8) | bcode[0x18]);
+		qla24xx_read_flash_data(ha, dcode, pcids >> 2, 0x20);
+		bcode = buf + (pcihdr % 4);
+
+		/* Validate signature of PCI data structure. */
+		if (bcode[0x0] != 'P' || bcode[0x1] != 'C' ||
+		    bcode[0x2] != 'I' || bcode[0x3] != 'R')
+			goto end;
+
+		last_image = bcode[0x15] & BIT_7;
+
+		/* Locate next PCI expansion ROM. */
+		pcihdr += ((bcode[0x11] << 8) | bcode[0x10]) * 512;
+	} while (!last_image);
+
+	/* Now verify FLT-location structure. */
+	fltl = (struct qla_flt_location *)ha->request_ring;
+	qla24xx_read_flash_data(ha, dcode, pcihdr >> 2,
+	    sizeof(struct qla_flt_location) >> 2);
+	if (fltl->sig[0] != 'Q' || fltl->sig[1] != 'F' ||
+	    fltl->sig[2] != 'L' || fltl->sig[3] != 'T')
+		goto end;
+
+	wptr = (uint16_t *)ha->request_ring;
+	cnt = sizeof(struct qla_flt_location) >> 1;
+	for (chksum = 0; cnt; cnt--)
+		chksum += le16_to_cpu(*wptr++);
+	if (chksum) {
+		qla_printk(KERN_ERR, ha,
+		    "Inconsistent FLTL detected: checksum=0x%x.\n", chksum);
+		qla2x00_dump_buffer(buf, sizeof(struct qla_flt_location));
+		return QLA_FUNCTION_FAILED;
+	}
+
+	/* Good data.  Use specified location. */
+	loc = locations[1];
+	*start = le16_to_cpu(fltl->start_hi) << 16 |
+	    le16_to_cpu(fltl->start_lo);
+end:
+	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLTL[%s] = 0x%x.\n", loc, *start));
+	return QLA_SUCCESS;
+}
+
+static void
+qla2xxx_get_flt_info(scsi_qla_host_t *ha, uint32_t flt_addr)
+{
+	const char *loc, *locations[] = { "DEF", "FLT" };
+	uint16_t *wptr;
+	uint16_t cnt, chksum;
+	uint32_t start;
+	struct qla_flt_header *flt;
+	struct qla_flt_region *region;
+
+	ha->flt_region_flt = flt_addr;
+	wptr = (uint16_t *)ha->request_ring;
+	flt = (struct qla_flt_header *)ha->request_ring;
+	region = (struct qla_flt_region *)&flt[1];
+	ha->isp_ops->read_optrom(ha, (uint8_t *)ha->request_ring,
+	    flt_addr << 2, OPTROM_BURST_SIZE);
+	if (*wptr == __constant_cpu_to_le16(0xffff))
+		goto no_flash_data;
+	if (flt->version != __constant_cpu_to_le16(1)) {
+		DEBUG2(qla_printk(KERN_INFO, ha, "Unsupported FLT detected: "
+		    "version=0x%x length=0x%x checksum=0x%x.\n",
+		    le16_to_cpu(flt->version), le16_to_cpu(flt->length),
+		    le16_to_cpu(flt->checksum)));
+		goto no_flash_data;
+	}
+
+	cnt = (sizeof(struct qla_flt_header) + le16_to_cpu(flt->length)) >> 1;
+	for (chksum = 0; cnt; cnt--)
+		chksum += le16_to_cpu(*wptr++);
+	if (chksum) {
+		DEBUG2(qla_printk(KERN_INFO, ha, "Inconsistent FLT detected: "
+		    "version=0x%x length=0x%x checksum=0x%x.\n",
+		    le16_to_cpu(flt->version), le16_to_cpu(flt->length),
+		    chksum));
+		goto no_flash_data;
+	}
+
+	loc = locations[1];
+	cnt = le16_to_cpu(flt->length) / sizeof(struct qla_flt_region);
+	for ( ; cnt; cnt--, region++) {
+		/* Store addresses as DWORD offsets. */
+		start = le32_to_cpu(region->start) >> 2;
+
+		DEBUG3(qla_printk(KERN_DEBUG, ha, "FLT[%02x]: start=0x%x "
+		    "end=0x%x size=0x%x.\n", le32_to_cpu(region->code), start,
+		    le32_to_cpu(region->end) >> 2, le32_to_cpu(region->size)));
+
+		switch (le32_to_cpu(region->code)) {
+		case FLT_REG_FW:
+			ha->flt_region_fw = start;
+			break;
+		case FLT_REG_BOOT_CODE:
+			ha->flt_region_boot = start;
+			break;
+		case FLT_REG_VPD_0:
+			ha->flt_region_vpd_nvram = start;
+			break;
+		case FLT_REG_FDT:
+			ha->flt_region_fdt = start;
+			break;
+		case FLT_REG_HW_EVENT_0:
+			if (!PCI_FUNC(ha->pdev->devfn))
+				ha->flt_region_hw_event = start;
+			break;
+		case FLT_REG_HW_EVENT_1:
+			if (PCI_FUNC(ha->pdev->devfn))
+				ha->flt_region_hw_event = start;
+			break;
+		}
+	}
+	goto done;
+
+no_flash_data:
+	/* Use hardcoded defaults. */
+	loc = locations[0];
+	ha->flt_region_fw = FA_RISC_CODE_ADDR;
+	ha->flt_region_boot = FA_BOOT_CODE_ADDR;
+	ha->flt_region_vpd_nvram = FA_VPD_NVRAM_ADDR;
+	ha->flt_region_fdt = IS_QLA24XX_TYPE(ha) ? FA_FLASH_DESCR_ADDR_24:
+	    FA_FLASH_DESCR_ADDR;
+	ha->flt_region_hw_event = !PCI_FUNC(ha->pdev->devfn) ?
+	    FA_HW_EVENT0_ADDR: FA_HW_EVENT1_ADDR;
+done:
+	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLT[%s]: boot=0x%x fw=0x%x "
+	    "vpd_nvram=0x%x fdt=0x%x flt=0x%x hwe=0x%x.\n", loc,
+	    ha->flt_region_boot, ha->flt_region_fw, ha->flt_region_vpd_nvram,
+	    ha->flt_region_fdt, ha->flt_region_flt, ha->flt_region_hw_event));
+}
+
+static void
+qla2xxx_get_fdt_info(scsi_qla_host_t *ha)
 {
 #define FLASH_BLK_SIZE_32K	0x8000
 #define FLASH_BLK_SIZE_64K	0x10000
+	const char *loc, *locations[] = { "MID", "FDT" };
 	uint16_t cnt, chksum;
 	uint16_t *wptr;
 	struct qla_fdt_layout *fdt;
 	uint8_t	man_id, flash_id;
-
-	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
-		return;
+	uint16_t mid, fid;
 
 	wptr = (uint16_t *)ha->request_ring;
 	fdt = (struct qla_fdt_layout *)ha->request_ring;
 	ha->isp_ops->read_optrom(ha, (uint8_t *)ha->request_ring,
-	    FA_FLASH_DESCR_ADDR << 2, OPTROM_BURST_SIZE);
+	    ha->flt_region_fdt << 2, OPTROM_BURST_SIZE);
 	if (*wptr == __constant_cpu_to_le16(0xffff))
 		goto no_flash_data;
 	if (fdt->sig[0] != 'Q' || fdt->sig[1] != 'L' || fdt->sig[2] != 'I' ||
@@ -577,7 +740,10 @@ qla2xxx_get_flash_info(scsi_qla_host_t *ha)
 		goto no_flash_data;
 	}
 
-	ha->fdt_odd_index = le16_to_cpu(fdt->man_id) == 0x1f;
+	loc = locations[1];
+	mid = le16_to_cpu(fdt->man_id);
+	fid = le16_to_cpu(fdt->id);
+	ha->fdt_odd_index = mid == 0x1f;
 	ha->fdt_wrt_disable = fdt->wrt_disable_bits;
 	ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0300 | fdt->erase_cmd);
 	ha->fdt_block_size = le32_to_cpu(fdt->block_size);
@@ -588,16 +754,12 @@ qla2xxx_get_flash_info(scsi_qla_host_t *ha)
 		    flash_conf_to_access_addr(0x0300 | fdt->protect_sec_cmd):
 		    flash_conf_to_access_addr(0x0336);
 	}
-
-	DEBUG2(qla_printk(KERN_DEBUG, ha, "Flash[FDT]: (0x%x/0x%x) erase=0x%x "
-	    "pro=%x upro=%x idx=%d wrtd=0x%x blk=0x%x.\n",
-	    le16_to_cpu(fdt->man_id), le16_to_cpu(fdt->id), ha->fdt_erase_cmd,
-	    ha->fdt_protect_sec_cmd, ha->fdt_unprotect_sec_cmd,
-	    ha->fdt_odd_index, ha->fdt_wrt_disable, ha->fdt_block_size));
-	return;
-
+	goto done;
 no_flash_data:
+	loc = locations[0];
 	qla24xx_get_flash_manufacturer(ha, &man_id, &flash_id);
+	mid = man_id;
+	fid = flash_id;
 	ha->fdt_wrt_disable = 0x9c;
 	ha->fdt_erase_cmd = flash_conf_to_access_addr(0x03d8);
 	switch (man_id) {
@@ -625,14 +787,33 @@ no_flash_data:
 		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
 		break;
 	}
-
-	DEBUG2(qla_printk(KERN_DEBUG, ha, "Flash[MID]: (0x%x/0x%x) erase=0x%x "
-	    "pro=%x upro=%x idx=%d wrtd=0x%x blk=0x%x.\n", man_id, flash_id,
+done:
+	DEBUG2(qla_printk(KERN_DEBUG, ha, "FDT[%s]: (0x%x/0x%x) erase=0x%x "
+	    "pro=%x upro=%x idx=%d wrtd=0x%x blk=0x%x.\n", loc, mid, fid,
 	    ha->fdt_erase_cmd, ha->fdt_protect_sec_cmd,
 	    ha->fdt_unprotect_sec_cmd, ha->fdt_odd_index, ha->fdt_wrt_disable,
 	    ha->fdt_block_size));
 }
 
+int
+qla2xxx_get_flash_info(scsi_qla_host_t *ha)
+{
+	int ret;
+	uint32_t flt_addr;
+
+	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
+		return QLA_SUCCESS;
+
+	ret = qla2xxx_find_flt_start(ha, &flt_addr);
+	if (ret != QLA_SUCCESS)
+		return ret;
+
+	qla2xxx_get_flt_info(ha, flt_addr);
+	qla2xxx_get_fdt_info(ha);
+
+	return QLA_SUCCESS;
+}
+
 static void
 qla24xx_unprotect_flash(scsi_qla_host_t *ha)
 {
@@ -920,7 +1101,8 @@ qla25xx_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	dwptr = (uint32_t *)buf;
 	for (i = 0; i < bytes >> 2; i++, naddr++)
 		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
-		    flash_data_to_access_addr(FA_VPD_NVRAM_ADDR | naddr)));
+		    flash_data_to_access_addr(ha->flt_region_vpd_nvram |
+		    naddr)));
 
 	return buf;
 }
@@ -935,10 +1117,10 @@ qla25xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	dbuf = vmalloc(RMW_BUFFER_SIZE);
 	if (!dbuf)
 		return QLA_MEMORY_ALLOC_FAILED;
-	ha->isp_ops->read_optrom(ha, dbuf, FA_VPD_NVRAM_ADDR << 2,
+	ha->isp_ops->read_optrom(ha, dbuf, ha->flt_region_vpd_nvram << 2,
 	    RMW_BUFFER_SIZE);
 	memcpy(dbuf + (naddr << 2), buf, bytes);
-	ha->isp_ops->write_optrom(ha, dbuf, FA_VPD_NVRAM_ADDR << 2,
+	ha->isp_ops->write_optrom(ha, dbuf, ha->flt_region_vpd_nvram << 2,
 	    RMW_BUFFER_SIZE);
 	vfree(dbuf);
 
@@ -2166,7 +2348,7 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 		memset(dbyte, 0, 8);
 		dcode = (uint16_t *)dbyte;
 
-		qla2x00_read_flash_data(ha, dbyte, FA_RISC_CODE_ADDR * 4 + 10,
+		qla2x00_read_flash_data(ha, dbyte, ha->flt_region_fw * 4 + 10,
 		    8);
 		DEBUG3(printk("%s(%ld): dumping fw ver from flash:\n",
 		    __func__, ha->host_no));
@@ -2177,7 +2359,7 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 		    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 		    dcode[3] == 0)) {
 			DEBUG2(printk("%s(): Unrecognized fw revision at "
-			    "%x.\n", __func__, FA_RISC_CODE_ADDR * 4));
+			    "%x.\n", __func__, ha->flt_region_fw * 4));
 		} else {
 			/* values are in big endian */
 			ha->fw_revision[0] = dbyte[0] << 16 | dbyte[1];
@@ -2212,7 +2394,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	dcode = mbuf;
 
 	/* Begin with first PCI expansion ROM header. */
-	pcihdr = 0;
+	pcihdr = ha->flt_region_boot;
 	last_image = 1;
 	do {
 		/* Verify PCI expansion ROM header. */
@@ -2282,7 +2464,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
 	dcode = mbuf;
 
-	qla24xx_read_flash_data(ha, dcode, FA_RISC_CODE_ADDR + 4, 4);
+	qla24xx_read_flash_data(ha, dcode, ha->flt_region_fw + 4, 4);
 	for (i = 0; i < 4; i++)
 		dcode[i] = be32_to_cpu(dcode[i]);
 
@@ -2291,7 +2473,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 	    dcode[3] == 0)) {
 		DEBUG2(printk("%s(): Unrecognized fw version at %x.\n",
-		    __func__, FA_RISC_CODE_ADDR));
+		    __func__, ha->flt_region_fw));
 	} else {
 		ha->fw_revision[0] = dcode[0];
 		ha->fw_revision[1] = dcode[1];
@@ -2355,7 +2537,7 @@ qla2xxx_hw_event_store(scsi_qla_host_t *ha, uint32_t *fdata)
 	/* Locate first empty entry. */
 	for (;;) {
 		if (ha->hw_event_ptr >=
-		    ha->hw_event_start + FA_HW_EVENT_SIZE) {
+		    ha->flt_region_hw_event + FA_HW_EVENT_SIZE) {
 			DEBUG2(qla_printk(KERN_WARNING, ha,
 			    "HW event -- Log Full!\n"));
 			return QLA_MEMORY_ALLOC_FAILED;
@@ -2391,7 +2573,7 @@ qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
 	int rval;
 	uint32_t marker[2], fdata[4];
 
-	if (ha->hw_event_start == 0)
+	if (ha->flt_region_hw_event == 0)
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG2(qla_printk(KERN_WARNING, ha,
@@ -2406,7 +2588,7 @@ qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
 		    QLA_DRIVER_PATCH_VER, QLA_DRIVER_BETA_VER);
 
 		/* Locate marker. */
-		ha->hw_event_ptr = ha->hw_event_start;
+		ha->hw_event_ptr = ha->flt_region_hw_event;
 		for (;;) {
 			qla24xx_read_flash_data(ha, fdata, ha->hw_event_ptr,
 			    4);
@@ -2415,7 +2597,7 @@ qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
 				break;
 			ha->hw_event_ptr += FA_HW_EVENT_ENTRY_SIZE;
 			if (ha->hw_event_ptr >=
-			    ha->hw_event_start + FA_HW_EVENT_SIZE) {
+			    ha->flt_region_hw_event + FA_HW_EVENT_SIZE) {
 				DEBUG2(qla_printk(KERN_WARNING, ha,
 				    "HW event -- Log Full!\n"));
 				return QLA_MEMORY_ALLOC_FAILED;
-- 
1.6.0.1.294.gda06a

