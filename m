From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/21] qla2xxx: Add Flash Descriptor Table layout support.
Date: Thu,  3 Apr 2008 13:13:22 -0700
Message-ID: <1207253612-15538-11-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761632AbYDCUNy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:54 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The Flash Descriptor Table (FDT) present on many recent HBAs
encodes flash accessing characteristics of the flash-part used on
the HBA.  Use this information during flash manipulation (writes)
rather than using specific hard-coded values based on queried
manufacturer and device IDs.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    7 ++
 drivers/scsi/qla2xxx/qla_fw.h   |   32 ++++++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +
 drivers/scsi/qla2xxx/qla_init.c |    1 +
 drivers/scsi/qla2xxx/qla_sup.c  |  153 ++++++++++++++++++++++++++++-----------
 5 files changed, 152 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 047973f..7e6b6da 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2521,6 +2521,13 @@ typedef struct scsi_qla_host {
 	uint8_t		fcode_revision[16];
 	uint32_t	fw_revision[4];
 
+	uint16_t	fdt_odd_index;
+	uint32_t	fdt_wrt_disable;
+	uint32_t	fdt_erase_cmd;
+	uint32_t	fdt_block_size;
+	uint32_t	fdt_unprotect_sec_cmd;
+	uint32_t	fdt_protect_sec_cmd;
+
 	/* Needed for BEACON */
 	uint16_t	beacon_blink_led;
 	uint8_t		beacon_color_state;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 5d19b0e..38adc0f 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1186,4 +1186,36 @@ struct vf_evfp_entry_24xx {
 };
 
 /* END MID Support ***********************************************************/
+
+/* Flash Description Table ***************************************************/
+
+struct qla_fdt_layout {
+	uint8_t sig[4];
+	uint16_t version;
+	uint16_t len;
+	uint16_t checksum;
+	uint8_t unused1[2];
+	uint8_t model[16];
+	uint16_t man_id;
+	uint16_t id;
+	uint8_t flags;
+	uint8_t erase_cmd;
+	uint8_t alt_erase_cmd;
+	uint8_t wrt_enable_cmd;
+	uint8_t wrt_enable_bits;
+	uint8_t wrt_sts_reg_cmd;
+	uint8_t unprotect_sec_cmd;
+	uint8_t read_man_id_cmd;
+	uint32_t block_size;
+	uint32_t alt_block_size;
+	uint32_t flash_size;
+	uint32_t wrt_enable_data;
+	uint8_t read_id_addr_len;
+	uint8_t wrt_disable_bits;
+	uint8_t read_dev_id_len;
+	uint8_t chip_erase_cmd;
+	uint16_t read_timeout;
+	uint8_t protect_sec_cmd;
+	uint8_t unused2[65];
+};
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 10c3f90..f25aa63 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -300,6 +300,8 @@ extern int qla24xx_get_flash_version(scsi_qla_host_t *, void *);
 extern int qla2xxx_hw_event_log(scsi_qla_host_t *, uint16_t , uint16_t,
     uint16_t, uint16_t);
 
+extern void qla2xxx_get_flash_info(scsi_qla_host_t *);
+
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d429e2f..10e6995 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -106,6 +106,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 		rval = qla2x00_setup_chip(ha);
 		if (rval)
 			return (rval);
+		qla2xxx_get_flash_info(ha);
 	}
 	rval = qla2x00_init_rings(ha);
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index c10ccc7..eda11f6 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -543,6 +543,96 @@ qla24xx_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
 	}
 }
 
+void
+qla2xxx_get_flash_info(scsi_qla_host_t *ha)
+{
+#define FLASH_BLK_SIZE_32K	0x8000
+#define FLASH_BLK_SIZE_64K	0x10000
+	uint16_t cnt, chksum;
+	uint16_t *wptr;
+	struct qla_fdt_layout *fdt;
+	uint8_t	man_id, flash_id;
+
+	if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha))
+		return;
+
+	wptr = (uint16_t *)ha->request_ring;
+	fdt = (struct qla_fdt_layout *)ha->request_ring;
+	ha->isp_ops->read_optrom(ha, (uint8_t *)ha->request_ring,
+	    FA_FLASH_DESCR_ADDR << 2, OPTROM_BURST_SIZE);
+	if (*wptr == __constant_cpu_to_le16(0xffff))
+		goto no_flash_data;
+	if (fdt->sig[0] != 'Q' || fdt->sig[1] != 'L' || fdt->sig[2] != 'I' ||
+	    fdt->sig[3] != 'D')
+		goto no_flash_data;
+
+	for (cnt = 0, chksum = 0; cnt < sizeof(struct qla_fdt_layout) >> 1;
+	    cnt++)
+		chksum += le16_to_cpu(*wptr++);
+	if (chksum) {
+		DEBUG2(qla_printk(KERN_INFO, ha, "Inconsistent FDT detected: "
+		    "checksum=0x%x id=%c version=0x%x.\n", chksum, fdt->sig[0],
+		    le16_to_cpu(fdt->version)));
+		DEBUG9(qla2x00_dump_buffer((uint8_t *)fdt, sizeof(*fdt)));
+		goto no_flash_data;
+	}
+
+	ha->fdt_odd_index = le16_to_cpu(fdt->man_id) == 0x1f;
+	ha->fdt_wrt_disable = fdt->wrt_disable_bits;
+	ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0300 | fdt->erase_cmd);
+	ha->fdt_block_size = le32_to_cpu(fdt->block_size);
+	if (fdt->unprotect_sec_cmd) {
+		ha->fdt_unprotect_sec_cmd = flash_conf_to_access_addr(0x0300 |
+		    fdt->unprotect_sec_cmd);
+		ha->fdt_protect_sec_cmd = fdt->protect_sec_cmd ?
+		    flash_conf_to_access_addr(0x0300 | fdt->protect_sec_cmd):
+		    flash_conf_to_access_addr(0x0336);
+	}
+
+	DEBUG2(qla_printk(KERN_DEBUG, ha, "Flash[FDT]: (0x%x/0x%x) erase=0x%x "
+	    "pro=%x upro=%x idx=%d wrtd=0x%x blk=0x%x.\n",
+	    le16_to_cpu(fdt->man_id), le16_to_cpu(fdt->id), ha->fdt_erase_cmd,
+	    ha->fdt_protect_sec_cmd, ha->fdt_unprotect_sec_cmd,
+	    ha->fdt_odd_index, ha->fdt_wrt_disable, ha->fdt_block_size));
+	return;
+
+no_flash_data:
+	qla24xx_get_flash_manufacturer(ha, &man_id, &flash_id);
+	ha->fdt_wrt_disable = 0x9c;
+	ha->fdt_erase_cmd = flash_conf_to_access_addr(0x03d8);
+	switch (man_id) {
+	case 0xbf: /* STT flash. */
+		if (flash_id == 0x8e)
+			ha->fdt_block_size = FLASH_BLK_SIZE_64K;
+		else
+			ha->fdt_block_size = FLASH_BLK_SIZE_32K;
+
+		if (flash_id == 0x80)
+			ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0352);
+		break;
+	case 0x13: /* ST M25P80. */
+		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
+		break;
+	case 0x1f: /* Atmel 26DF081A. */
+		ha->fdt_odd_index = 1;
+		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
+		ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0320);
+		ha->fdt_unprotect_sec_cmd = flash_conf_to_access_addr(0x0339);
+		ha->fdt_protect_sec_cmd = flash_conf_to_access_addr(0x0336);
+		break;
+	default:
+		/* Default to 64 kb sector size. */
+		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
+		break;
+	}
+
+	DEBUG2(qla_printk(KERN_DEBUG, ha, "Flash[MID]: (0x%x/0x%x) erase=0x%x "
+	    "pro=%x upro=%x idx=%d wrtd=0x%x blk=0x%x.\n", man_id, flash_id,
+	    ha->fdt_erase_cmd, ha->fdt_protect_sec_cmd,
+	    ha->fdt_unprotect_sec_cmd, ha->fdt_odd_index, ha->fdt_wrt_disable,
+	    ha->fdt_block_size));
+}
+
 static void
 qla24xx_unprotect_flash(scsi_qla_host_t *ha)
 {
@@ -553,6 +643,9 @@ qla24xx_unprotect_flash(scsi_qla_host_t *ha)
 	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
 	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
 
+	if (!ha->fdt_wrt_disable)
+		return;
+
 	/* Disable flash write-protection. */
 	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
 	/* Some flash parts need an additional zero-write to clear bits.*/
@@ -565,8 +658,12 @@ qla24xx_protect_flash(scsi_qla_host_t *ha)
 	uint32_t cnt;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
+	if (!ha->fdt_wrt_disable)
+		goto skip_wrt_protect;
+
 	/* Enable flash write-protection and wait for completion. */
-	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0x9c);
+	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101),
+	    ha->fdt_wrt_disable);
 	for (cnt = 300; cnt &&
 	    qla24xx_read_flash_dword(ha,
 		    flash_conf_to_access_addr(0x005)) & BIT_0;
@@ -574,6 +671,7 @@ qla24xx_protect_flash(scsi_qla_host_t *ha)
 		udelay(10);
 	}
 
+skip_wrt_protect:
 	/* Disable flash write. */
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
@@ -586,9 +684,8 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 {
 	int ret;
 	uint32_t liter, miter;
-	uint32_t sec_mask, rest_addr, conf_addr;
+	uint32_t sec_mask, rest_addr;
 	uint32_t fdata, findex;
-	uint8_t	man_id, flash_id;
 	dma_addr_t optrom_dma;
 	void *optrom = NULL;
 	uint32_t *s, *d;
@@ -607,43 +704,13 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 		}
 	}
 
-	qla24xx_get_flash_manufacturer(ha, &man_id, &flash_id);
-	DEBUG9(printk("%s(%ld): Flash man_id=%d flash_id=%d\n", __func__,
-	    ha->host_no, man_id, flash_id));
-
-	conf_addr = flash_conf_to_access_addr(0x03d8);
-	switch (man_id) {
-	case 0xbf: /* STT flash. */
-		if (flash_id == 0x8e) {
-			rest_addr = 0x3fff;
-			sec_mask = 0x7c000;
-		} else {
-			rest_addr = 0x1fff;
-			sec_mask = 0x7e000;
-		}
-		if (flash_id == 0x80)
-			conf_addr = flash_conf_to_access_addr(0x0352);
-		break;
-	case 0x13: /* ST M25P80. */
-		rest_addr = 0x3fff;
-		sec_mask = 0x7c000;
-		break;
-	case 0x1f: // Atmel 26DF081A
-		rest_addr = 0x3fff;
-		sec_mask = 0x7c000;
-		conf_addr = flash_conf_to_access_addr(0x0320);
-		break;
-	default:
-		/* Default to 64 kb sector size. */
-		rest_addr = 0x3fff;
-		sec_mask = 0x7c000;
-		break;
-	}
+	rest_addr = (ha->fdt_block_size >> 2) - 1;
+	sec_mask = 0x80000 - (ha->fdt_block_size >> 2);
 
 	qla24xx_unprotect_flash(ha);
 
 	for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
-		if (man_id == 0x1f) {
+		if (ha->fdt_odd_index) {
 			findex = faddr << 2;
 			fdata = findex & sec_mask;
 		} else {
@@ -653,13 +720,13 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 
 		/* Are we at the beginning of a sector? */
 		if ((findex & rest_addr) == 0) {
-			/* Do sector unprotect at 4K boundry for Atmel part. */
-			if (man_id == 0x1f)
+			/* Do sector unprotect. */
+			if (ha->fdt_unprotect_sec_cmd)
 				qla24xx_write_flash_dword(ha,
-				    flash_conf_to_access_addr(0x0339),
+				    ha->fdt_unprotect_sec_cmd,
 				    (fdata & 0xff00) | ((fdata << 16) &
 				    0xff0000) | ((fdata >> 16) & 0xff));
-			ret = qla24xx_write_flash_dword(ha, conf_addr,
+			ret = qla24xx_write_flash_dword(ha, ha->fdt_erase_cmd,
 			    (fdata & 0xff00) |((fdata << 16) &
 			    0xff0000) | ((fdata >> 16) & 0xff));
 			if (ret != QLA_SUCCESS) {
@@ -709,11 +776,11 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 			break;
 		}
 
-		/* Do sector protect at 4K boundry for Atmel part. */
-		if (man_id == 0x1f &&
+		/* Do sector protect. */
+		if (ha->fdt_unprotect_sec_cmd &&
 		    ((faddr & rest_addr) == rest_addr))
 			qla24xx_write_flash_dword(ha,
-			    flash_conf_to_access_addr(0x0336),
+			    ha->fdt_protect_sec_cmd,
 			    (fdata & 0xff00) | ((fdata << 16) &
 			    0xff0000) | ((fdata >> 16) & 0xff));
 	}
-- 
1.5.5.rc2

