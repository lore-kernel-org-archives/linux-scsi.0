From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 02/19] qla2xxx: Add flash burst-read/write support.
Date: Thu, 20 Sep 2007 14:07:33 -0700
Message-ID: <1190322470-15543-2-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXITVHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:43 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Newer ISPs support a mechanism to read and write flash-memory via
the firmware LOAD/DUMP memory mailbox command routines.  When
supported, utilizing these mechanisms significantly reduces
overall access times.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    5 +
 drivers/scsi/qla2xxx/qla_mbx.c |   48 +++++++++
 drivers/scsi/qla2xxx/qla_os.c  |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c |  221 ++++++++++++++++++++++++++++++----------
 4 files changed, 220 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index aa1e411..e8122e8 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -134,6 +134,9 @@ extern int
 qla2x00_load_ram(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
 
 extern int
+qla2x00_dump_ram(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
+
+extern int
 qla2x00_execute_fw(scsi_qla_host_t *, uint32_t);
 
 extern void
@@ -302,6 +305,8 @@ extern uint8_t *qla24xx_read_optrom_data(struct scsi_qla_host *, uint8_t *,
     uint32_t, uint32_t);
 extern int qla24xx_write_optrom_data(struct scsi_qla_host *, uint8_t *,
     uint32_t, uint32_t);
+extern uint8_t *qla25xx_read_optrom_data(struct scsi_qla_host *, uint8_t *,
+    uint32_t, uint32_t);
 
 extern int qla2x00_get_flash_version(scsi_qla_host_t *, void *);
 extern int qla24xx_get_flash_version(scsi_qla_host_t *, void *);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d3746ec..e4f4b1f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2980,3 +2980,51 @@ qla2x00_send_change_request(scsi_qla_host_t *ha, uint16_t format,
 
 	return rval;
 }
+
+int
+qla2x00_dump_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t addr,
+    uint32_t size)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	if (MSW(addr) || IS_FWI2_CAPABLE(ha)) {
+		mcp->mb[0] = MBC_DUMP_RISC_RAM_EXTENDED;
+		mcp->mb[8] = MSW(addr);
+		mcp->out_mb = MBX_8|MBX_0;
+	} else {
+		mcp->mb[0] = MBC_DUMP_RISC_RAM;
+		mcp->out_mb = MBX_0;
+	}
+	mcp->mb[1] = LSW(addr);
+	mcp->mb[2] = MSW(req_dma);
+	mcp->mb[3] = LSW(req_dma);
+	mcp->mb[6] = MSW(MSD(req_dma));
+	mcp->mb[7] = LSW(MSD(req_dma));
+	mcp->out_mb |= MBX_7|MBX_6|MBX_3|MBX_2|MBX_1;
+	if (IS_FWI2_CAPABLE(ha)) {
+		mcp->mb[4] = MSW(size);
+		mcp->mb[5] = LSW(size);
+		mcp->out_mb |= MBX_5|MBX_4;
+	} else {
+		mcp->mb[4] = LSW(size);
+		mcp->out_mb |= MBX_4;
+	}
+
+	mcp->in_mb = MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
+		    ha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index acca898..2a03400 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1384,7 +1384,7 @@ static struct isp_operations qla25xx_isp_ops = {
 	.beacon_on		= qla24xx_beacon_on,
 	.beacon_off		= qla24xx_beacon_off,
 	.beacon_blink		= qla24xx_beacon_blink,
-	.read_optrom		= qla24xx_read_optrom_data,
+	.read_optrom		= qla25xx_read_optrom_data,
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 };
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index a925a3f..ad3d1de 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -425,6 +425,9 @@ qla2x00_set_nvram_protection(scsi_qla_host_t *ha, int stat)
 /* Flash Manipulation Routines                                               */
 /*****************************************************************************/
 
+#define OPTROM_BURST_SIZE	0x1000
+#define OPTROM_BURST_DWORDS	(OPTROM_BURST_SIZE / 4)
+
 static inline uint32_t
 flash_conf_to_access_addr(uint32_t faddr)
 {
@@ -544,41 +547,59 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
 {
 	int ret;
-	uint32_t liter;
-	uint32_t sec_mask, rest_addr, conf_addr, sec_end_mask;
+	uint32_t liter, miter;
+	uint32_t sec_mask, rest_addr, conf_addr;
 	uint32_t fdata, findex ;
 	uint8_t	man_id, flash_id;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	dma_addr_t optrom_dma;
+	void *optrom = NULL;
+	uint32_t *s, *d;
 
 	ret = QLA_SUCCESS;
 
+	/* Prepare burst-capable write on supported ISPs. */
+	if (IS_QLA25XX(ha) && !(faddr & ~OPTROM_BURST_SIZE) &&
+	    dwords > OPTROM_BURST_DWORDS) {
+		optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
+		    &optrom_dma, GFP_KERNEL);
+		if (!optrom) {
+			qla_printk(KERN_DEBUG, ha,
+			    "Unable to allocate memory for optrom burst write "
+			    "(%x KB).\n", OPTROM_BURST_SIZE / 1024);
+		}
+	}
+
 	qla24xx_get_flash_manufacturer(ha, &man_id, &flash_id);
 	DEBUG9(printk("%s(%ld): Flash man_id=%d flash_id=%d\n", __func__,
 	    ha->host_no, man_id, flash_id));
 
-	sec_end_mask = 0;
 	conf_addr = flash_conf_to_access_addr(0x03d8);
 	switch (man_id) {
 	case 0xbf: /* STT flash. */
-		rest_addr = 0x1fff;
-		sec_mask = 0x3e000;
+		if (flash_id == 0x8e) {
+			rest_addr = 0x3fff;
+			sec_mask = 0x7c000;
+		} else {
+			rest_addr = 0x1fff;
+			sec_mask = 0x7e000;
+		}
 		if (flash_id == 0x80)
 			conf_addr = flash_conf_to_access_addr(0x0352);
 		break;
 	case 0x13: /* ST M25P80. */
 		rest_addr = 0x3fff;
-		sec_mask = 0x3c000;
+		sec_mask = 0x7c000;
 		break;
 	case 0x1f: // Atmel 26DF081A
-		rest_addr = 0x0fff;
-		sec_mask = 0xff000;
-		sec_end_mask = 0x003ff;
+		rest_addr = 0x3fff;
+		sec_mask = 0x7c000;
 		conf_addr = flash_conf_to_access_addr(0x0320);
 		break;
 	default:
 		/* Default to 64 kb sector size. */
 		rest_addr = 0x3fff;
-		sec_mask = 0x3c000;
+		sec_mask = 0x7c000;
 		break;
 	}
 
@@ -592,56 +613,81 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 	/* Some flash parts need an additional zero-write to clear bits.*/
 	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
 
-	do {    /* Loop once to provide quick error exit. */
-		for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
-			if (man_id == 0x1f) {
-				findex = faddr << 2;
-				fdata = findex & sec_mask;
-			} else {
-				findex = faddr;
-				fdata = (findex & sec_mask) << 2;
-			}
+	for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
+		if (man_id == 0x1f) {
+			findex = faddr << 2;
+			fdata = findex & sec_mask;
+		} else {
+			findex = faddr;
+			fdata = (findex & sec_mask) << 2;
+		}
 
-			/* Are we at the beginning of a sector? */
-			if ((findex & rest_addr) == 0) {
-				/*
-				 * Do sector unprotect at 4K boundry for Atmel
-				 * part.
-				 */
-				if (man_id == 0x1f)
-					qla24xx_write_flash_dword(ha,
-					    flash_conf_to_access_addr(0x0339),
-					    (fdata & 0xff00) | ((fdata << 16) &
-					    0xff0000) | ((fdata >> 16) & 0xff));
-				ret = qla24xx_write_flash_dword(ha, conf_addr,
-				    (fdata & 0xff00) |((fdata << 16) &
+		/* Are we at the beginning of a sector? */
+		if ((findex & rest_addr) == 0) {
+			/* Do sector unprotect at 4K boundry for Atmel part. */
+			if (man_id == 0x1f)
+				qla24xx_write_flash_dword(ha,
+				    flash_conf_to_access_addr(0x0339),
+				    (fdata & 0xff00) | ((fdata << 16) &
 				    0xff0000) | ((fdata >> 16) & 0xff));
-				if (ret != QLA_SUCCESS) {
-					DEBUG9(printk("%s(%ld) Unable to flash "
-					    "sector: address=%x.\n", __func__,
-					    ha->host_no, faddr));
-					break;
-				}
+			ret = qla24xx_write_flash_dword(ha, conf_addr,
+			    (fdata & 0xff00) |((fdata << 16) &
+			    0xff0000) | ((fdata >> 16) & 0xff));
+			if (ret != QLA_SUCCESS) {
+				DEBUG9(printk("%s(%ld) Unable to flash "
+				    "sector: address=%x.\n", __func__,
+				    ha->host_no, faddr));
+				break;
 			}
-			ret = qla24xx_write_flash_dword(ha,
+		}
+
+		/* Go with burst-write. */
+		if (optrom && (liter + OPTROM_BURST_DWORDS) < dwords) {
+			/* Copy data to DMA'ble buffer. */
+			for (miter = 0, s = optrom, d = dwptr;
+			    miter < OPTROM_BURST_DWORDS; miter++, s++, d++)
+				*s = cpu_to_le32(*d);
+
+			ret = qla2x00_load_ram(ha, optrom_dma,
 			    flash_data_to_access_addr(faddr),
-			    cpu_to_le32(*dwptr));
+			    OPTROM_BURST_DWORDS);
 			if (ret != QLA_SUCCESS) {
-				DEBUG9(printk("%s(%ld) Unable to program flash "
-				    "address=%x data=%x.\n", __func__,
-				    ha->host_no, faddr, *dwptr));
-				break;
+				qla_printk(KERN_WARNING, ha,
+				    "Unable to burst-write optrom segment "
+				    "(%x/%x/%llx).\n", ret,
+				    flash_data_to_access_addr(faddr),
+				    optrom_dma);
+				qla_printk(KERN_WARNING, ha,
+				    "Reverting to slow-write.\n");
+
+				dma_free_coherent(&ha->pdev->dev,
+				    OPTROM_BURST_SIZE, optrom, optrom_dma);
+				optrom = NULL;
+			} else {
+				liter += OPTROM_BURST_DWORDS - 1;
+				faddr += OPTROM_BURST_DWORDS - 1;
+				dwptr += OPTROM_BURST_DWORDS - 1;
+				continue;
 			}
+		}
 
-			/* Do sector protect at 4K boundry for Atmel part. */
-			if (man_id == 0x1f &&
-			    ((faddr & sec_end_mask) == 0x3ff))
-				qla24xx_write_flash_dword(ha,
-				    flash_conf_to_access_addr(0x0336),
-				    (fdata & 0xff00) | ((fdata << 16) &
-				    0xff0000) | ((fdata >> 16) & 0xff));
+		ret = qla24xx_write_flash_dword(ha,
+		    flash_data_to_access_addr(faddr), cpu_to_le32(*dwptr));
+		if (ret != QLA_SUCCESS) {
+			DEBUG9(printk("%s(%ld) Unable to program flash "
+			    "address=%x data=%x.\n", __func__,
+			    ha->host_no, faddr, *dwptr));
+			break;
 		}
-	} while (0);
+
+		/* Do sector protect at 4K boundry for Atmel part. */
+		if (man_id == 0x1f &&
+		    ((faddr & rest_addr) == rest_addr))
+			qla24xx_write_flash_dword(ha,
+			    flash_conf_to_access_addr(0x0336),
+			    (fdata & 0xff00) | ((fdata << 16) &
+			    0xff0000) | ((fdata >> 16) & 0xff));
+	}
 
 	/* Enable flash write-protection. */
 	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0x9c);
@@ -651,6 +697,10 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
 	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
 
+	if (optrom)
+		dma_free_coherent(&ha->pdev->dev,
+		    OPTROM_BURST_SIZE, optrom, optrom_dma);
+
 	return ret;
 }
 
@@ -1728,7 +1778,6 @@ qla24xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 {
 	/* Suspend HBA. */
 	scsi_block_requests(ha->host);
-	ha->isp_ops->disable_intrs(ha);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
 	/* Go with read. */
@@ -1736,7 +1785,6 @@ qla24xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 
 	/* Resume HBA. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
-	ha->isp_ops->enable_intrs(ha);
 	scsi_unblock_requests(ha->host);
 
 	return buf;
@@ -1750,7 +1798,6 @@ qla24xx_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 
 	/* Suspend HBA. */
 	scsi_block_requests(ha->host);
-	ha->isp_ops->disable_intrs(ha);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
 	/* Go with write. */
@@ -1767,6 +1814,70 @@ qla24xx_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	return rval;
 }
 
+uint8_t *
+qla25xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+    uint32_t offset, uint32_t length)
+{
+	int rval;
+	dma_addr_t optrom_dma;
+	void *optrom;
+	uint8_t *pbuf;
+	uint32_t faddr, left, burst;
+
+	if (offset & ~OPTROM_BURST_SIZE)
+		goto slow_read;
+	if (length < OPTROM_BURST_SIZE)
+		goto slow_read;
+
+	optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
+	    &optrom_dma, GFP_KERNEL);
+	if (!optrom) {
+		qla_printk(KERN_DEBUG, ha,
+		    "Unable to allocate memory for optrom burst read "
+		    "(%x KB).\n", OPTROM_BURST_SIZE / 1024);
+
+		goto slow_read;
+	}
+
+	pbuf = buf;
+	faddr = offset >> 2;
+	left = length >> 2;
+	burst = OPTROM_BURST_DWORDS;
+	while (left != 0) {
+		if (burst > left)
+			burst = left;
+
+		rval = qla2x00_dump_ram(ha, optrom_dma,
+		    flash_data_to_access_addr(faddr), burst);
+		if (rval) {
+			qla_printk(KERN_WARNING, ha,
+			    "Unable to burst-read optrom segment "
+			    "(%x/%x/%llx).\n", rval,
+			    flash_data_to_access_addr(faddr), optrom_dma);
+			qla_printk(KERN_WARNING, ha,
+			    "Reverting to slow-read.\n");
+
+			dma_free_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
+			    optrom, optrom_dma);
+			goto slow_read;
+		}
+
+		memcpy(pbuf, optrom, burst * 4);
+
+		left -= burst;
+		faddr += burst;
+		pbuf += burst * 4;
+	}
+
+	dma_free_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE, optrom,
+	    optrom_dma);
+
+	return buf;
+
+slow_read:
+    return qla24xx_read_optrom_data(ha, buf, offset, length);
+}
+
 /**
  * qla2x00_get_fcode_version() - Determine an FCODE image's version.
  * @ha: HA context
-- 
1.5.3.2.80.g077d6f

