From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/26] qla2xxx: Add Flash-Access-Control support for recent ISPs.
Date: Tue, 24 Mar 2009 09:08:06 -0700
Message-ID: <1237910900-30817-13-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759573AbZCXQIf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:35 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Given the low-level interface varies from one flash-part
manufacturer to the next, the Flash-Access-Control (FAC) mailbox
command makes the specific flash type transparent to the driver
by encapsulating a basic set of accessor and update routines.
Use these new routines where applicable by querying FAC opcode
get-sector-size at init-time.

Additional cleanups and
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    3 +-
 drivers/scsi/qla2xxx/qla_fw.h   |   14 ++++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    9 ++++
 drivers/scsi/qla2xxx/qla_init.c |   15 ++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |   97 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_sup.c  |   60 +++++++++++++++++++-----
 6 files changed, 184 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 261c869..bca572f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2260,7 +2260,7 @@ struct qla_hw_data {
 		uint32_t	vsan_enabled		:1;
 		uint32_t	npiv_supported		:1;
 		uint32_t	fce_enabled		:1;
-		uint32_t	hw_event_marker_found:1;
+		uint32_t	fac_supported		:1;
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
@@ -2382,6 +2382,7 @@ struct qla_hw_data {
 				IS_QLA25XX(ha) || IS_QLA81XX(ha))
 #define IS_NOPOLLING_TYPE(ha)	((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && \
 				(ha)->flags.msix_enabled)
+#define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha))
 
 #define IS_IIDMA_CAPABLE(ha)    ((ha)->device_type & DT_IIDMA)
 #define IS_FWI2_CAPABLE(ha)     ((ha)->device_type & DT_FWI2)
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 05cf838..9830193 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1403,6 +1403,20 @@ struct access_chip_rsp_84xx {
 #define MBA_IDC_TIME_EXT	0x8102
 
 #define MBC_IDC_ACK		0x101
+#define MBC_FLASH_ACCESS_CTRL	0x3e	/* Control flash access. */
+
+/* Flash access control option field bit definitions */
+#define FAC_OPT_FORCE_SEMAPHORE		BIT_15
+#define FAC_OPT_REQUESTOR_ID		BIT_14
+#define FAC_OPT_CMD_SUBCODE		0xff
+
+/* Flash access control command subcodes */
+#define FAC_OPT_CMD_WRITE_PROTECT	0x00
+#define FAC_OPT_CMD_WRITE_ENABLE	0x01
+#define FAC_OPT_CMD_ERASE_SECTOR	0x02
+#define FAC_OPT_CMD_LOCK_SEMAPHORE	0x03
+#define FAC_OPT_CMD_UNLOCK_SEMAPHORE	0x04
+#define FAC_OPT_CMD_GET_SECTOR_SIZE	0x05
 
 struct nvram_81xx {
 	/* NVRAM header. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index af36238..4d52bf1 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -269,6 +269,15 @@ extern int qla84xx_verify_chip(struct scsi_qla_host *, uint16_t *);
 
 extern int qla81xx_idc_ack(scsi_qla_host_t *, uint16_t *);
 
+extern int
+qla81xx_fac_get_sector_size(scsi_qla_host_t *, uint32_t *);
+
+extern int
+qla81xx_fac_do_write_enable(scsi_qla_host_t *, int);
+
+extern int
+qla81xx_fac_erase_sector(scsi_qla_host_t *, uint32_t, uint32_t);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0febfa6..c37888e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1032,6 +1032,21 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
 
+	if (rval == QLA_SUCCESS && IS_FAC_REQUIRED(ha)) {
+		uint32_t size;
+
+		rval = qla81xx_fac_get_sector_size(vha, &size);
+		if (rval == QLA_SUCCESS) {
+			ha->flags.fac_supported = 1;
+			ha->fdt_block_size = size << 2;
+		} else {
+			qla_printk(KERN_ERR, ha,
+			    "Unsupported FAC firmware (%d.%02d.%02d).\n",
+			    ha->fw_major_version, ha->fw_minor_version,
+			    ha->fw_subminor_version);
+		}
+	}
+
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Setup chip **** FAILED ****.\n",
 		    vha->host_no));
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b380c6f..2bc08d3 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3228,3 +3228,100 @@ qla81xx_idc_ack(scsi_qla_host_t *vha, uint16_t *mb)
 
 	return rval;
 }
+
+int
+qla81xx_fac_get_sector_size(scsi_qla_host_t *vha, uint32_t *sector_size)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA81XX(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_FLASH_ACCESS_CTRL;
+	mcp->mb[1] = FAC_OPT_CMD_GET_SECTOR_SIZE;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		*sector_size = mcp->mb[1];
+	}
+
+	return rval;
+}
+
+int
+qla81xx_fac_do_write_enable(scsi_qla_host_t *vha, int enable)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA81XX(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_FLASH_ACCESS_CTRL;
+	mcp->mb[1] = enable ? FAC_OPT_CMD_WRITE_ENABLE :
+	    FAC_OPT_CMD_WRITE_PROTECT;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
+
+int
+qla81xx_fac_erase_sector(scsi_qla_host_t *vha, uint32_t start, uint32_t finish)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA81XX(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_FLASH_ACCESS_CTRL;
+	mcp->mb[1] = FAC_OPT_CMD_ERASE_SECTOR;
+	mcp->mb[2] = LSW(start);
+	mcp->mb[3] = MSW(start);
+	mcp->mb[4] = LSW(finish);
+	mcp->mb[5] = MSW(finish);
+	mcp->out_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_2|MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x "
+		    "mb[2]=%x.\n", __func__, vha->host_no, rval, mcp->mb[0],
+		    mcp->mb[1], mcp->mb[2]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 5b24af8..ff5aa75 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -931,31 +931,41 @@ done:
 	ha->npiv_info = NULL;
 }
 
-static void
-qla24xx_unprotect_flash(struct qla_hw_data *ha)
+static int
+qla24xx_unprotect_flash(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
+	if (ha->flags.fac_supported)
+		return qla81xx_fac_do_write_enable(vha, 1);
+
 	/* Enable flash write. */
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
 	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
 
 	if (!ha->fdt_wrt_disable)
-		return;
+		goto done;
 
 	/* Disable flash write-protection, first clear SR protection bit */
 	qla24xx_write_flash_dword(ha, flash_conf_addr(ha, 0x101), 0);
 	/* Then write zero again to clear remaining SR bits.*/
 	qla24xx_write_flash_dword(ha, flash_conf_addr(ha, 0x101), 0);
+done:
+	return QLA_SUCCESS;
 }
 
-static void
-qla24xx_protect_flash(struct qla_hw_data *ha)
+static int
+qla24xx_protect_flash(scsi_qla_host_t *vha)
 {
 	uint32_t cnt;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
+	if (ha->flags.fac_supported)
+		return qla81xx_fac_do_write_enable(vha, 0);
+
 	if (!ha->fdt_wrt_disable)
 		goto skip_wrt_protect;
 
@@ -973,6 +983,26 @@ skip_wrt_protect:
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
 	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+
+	return QLA_SUCCESS;
+}
+
+static int
+qla24xx_erase_sector(scsi_qla_host_t *vha, uint32_t fdata)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint32_t start, finish;
+
+	if (ha->flags.fac_supported) {
+		start = fdata >> 2;
+		finish = start + (ha->fdt_block_size >> 2) - 1;
+		return qla81xx_fac_erase_sector(vha, flash_data_addr(ha,
+		    start), flash_data_addr(ha, finish));
+	}
+
+	return qla24xx_write_flash_dword(ha, ha->fdt_erase_cmd,
+	    (fdata & 0xff00) | ((fdata << 16) & 0xff0000) |
+	    ((fdata >> 16) & 0xff));
 }
 
 static int
@@ -987,8 +1017,6 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	void *optrom = NULL;
 	struct qla_hw_data *ha = vha->hw;
 
-	ret = QLA_SUCCESS;
-
 	/* Prepare burst-capable write on supported ISPs. */
 	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && !(faddr & 0xfff) &&
 	    dwords > OPTROM_BURST_DWORDS) {
@@ -1004,7 +1032,12 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	rest_addr = (ha->fdt_block_size >> 2) - 1;
 	sec_mask = ~rest_addr;
 
-	qla24xx_unprotect_flash(ha);
+	ret = qla24xx_unprotect_flash(vha);
+	if (ret != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to unprotect flash for update.\n");
+		goto done;
+	}
 
 	for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
 		fdata = (faddr & sec_mask) << 2;
@@ -1017,9 +1050,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 				    ha->fdt_unprotect_sec_cmd,
 				    (fdata & 0xff00) | ((fdata << 16) &
 				    0xff0000) | ((fdata >> 16) & 0xff));
-			ret = qla24xx_write_flash_dword(ha, ha->fdt_erase_cmd,
-			    (fdata & 0xff00) |((fdata << 16) &
-			    0xff0000) | ((fdata >> 16) & 0xff));
+			ret = qla24xx_erase_sector(vha, fdata);
 			if (ret != QLA_SUCCESS) {
 				DEBUG9(qla_printk("Unable to erase sector: "
 				    "address=%x.\n", faddr));
@@ -1073,8 +1104,11 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 			    0xff0000) | ((fdata >> 16) & 0xff));
 	}
 
-	qla24xx_protect_flash(ha);
-
+	ret = qla24xx_protect_flash(vha);
+	if (ret != QLA_SUCCESS)
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to protect flash after update.\n");
+done:
 	if (optrom)
 		dma_free_coherent(&ha->pdev->dev,
 		    OPTROM_BURST_SIZE, optrom, optrom_dma);
-- 
1.6.2.rc0.55.g30aa4f

