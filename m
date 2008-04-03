From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/21] qla2xxx: Add hardware trace-logging support.
Date: Thu,  3 Apr 2008 13:13:19 -0700
Message-ID: <1207253612-15538-8-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbYDCUNx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:53 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Recent ISPs have a region within FLASH which acts as a repository
for the logging of serious hardware and software failures.
Currently, the region is large enough to support up to 255
entries.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   10 +++
 drivers/scsi/qla2xxx/qla_fw.h   |   14 +++-
 drivers/scsi/qla2xxx/qla_gbl.h  |    5 +
 drivers/scsi/qla2xxx/qla_init.c |   11 +++
 drivers/scsi/qla2xxx/qla_isr.c  |   15 ++++
 drivers/scsi/qla2xxx/qla_mbx.c  |    8 ++
 drivers/scsi/qla2xxx/qla_os.c   |   23 ++++++
 drivers/scsi/qla2xxx/qla_sup.c  |  168 +++++++++++++++++++++++++++++++++------
 8 files changed, 229 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 35c730a..13ffeda 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2118,6 +2118,7 @@ struct qla_msix_entry {
 /* Work events.  */
 enum qla_work_type {
 	QLA_EVT_AEN,
+	QLA_EVT_HWE_LOG,
 };
 
 
@@ -2132,6 +2133,10 @@ struct qla_work_evt {
 			enum fc_host_event_code code;
 			u32 data;
 		} aen;
+		struct {
+			uint16_t code;
+			uint16_t d1, d2, d3;
+		} hwe;
 	} u;
 };
 
@@ -2173,6 +2178,7 @@ typedef struct scsi_qla_host {
 		uint32_t        vsan_enabled            :1;
 		uint32_t	npiv_supported		:1;
 		uint32_t	fce_enabled		:1;
+		uint32_t	hw_event_marker_found	:1;
 	} flags;
 
 	atomic_t	loop_state;
@@ -2478,6 +2484,10 @@ typedef struct scsi_qla_host {
 	uint64_t	fce_wr, fce_rd;
 	struct mutex	fce_mutex;
 
+	uint32_t	hw_event_start;
+	uint32_t	hw_event_ptr;
+	uint32_t	hw_event_pause_errors;
+
 	uint8_t		host_str[16];
 	uint32_t	pci_attr;
 	uint16_t	chip_revision;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 4ae2653..5d19b0e 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -793,7 +793,19 @@ struct device_reg_24xx {
 #define FA_VPD_NVRAM_ADDR	0x48000
 #define FA_FEATURE_ADDR		0x4C000
 #define FA_FLASH_DESCR_ADDR	0x50000
-#define FA_HW_EVENT_ADDR	0x54000
+#define FA_HW_EVENT0_ADDR	0x54000
+#define FA_HW_EVENT1_ADDR	0x54200
+#define FA_HW_EVENT_SIZE	0x200
+#define FA_HW_EVENT_ENTRY_SIZE	4
+/*
+ * Flash Error Log Event Codes.
+ */
+#define HW_EVENT_RESET_ERR	0xF00B
+#define HW_EVENT_ISP_ERR	0xF020
+#define HW_EVENT_PARITY_ERR	0xF022
+#define HW_EVENT_NVRAM_CHKSUM_ERR	0xF023
+#define HW_EVENT_FLASH_FW_ERR	0xF024
+
 #define FA_BOOT_LOG_ADDR	0x58000
 #define FA_FW_DUMP0_ADDR	0x60000
 #define FA_FW_DUMP1_ADDR	0x70000
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ee52f3e..276bd26 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -69,6 +69,8 @@ extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
 extern int qla2x00_post_aen_work(struct scsi_qla_host *, enum
     fc_host_event_code, u32);
+extern int qla2x00_post_hwe_work(struct scsi_qla_host *, uint16_t , uint16_t,
+    uint16_t, uint16_t);
 
 /*
  * Global Functions in qla_mid.c source file.
@@ -298,6 +300,9 @@ extern uint8_t *qla25xx_read_optrom_data(struct scsi_qla_host *, uint8_t *,
 extern int qla2x00_get_flash_version(scsi_qla_host_t *, void *);
 extern int qla24xx_get_flash_version(scsi_qla_host_t *, void *);
 
+extern int qla2xxx_hw_event_log(scsi_qla_host_t *, uint16_t , uint16_t,
+    uint16_t, uint16_t);
+
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e773697..e9a7c2d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -500,6 +500,7 @@ qla2x00_reset_chip(scsi_qla_host_t *ha)
 static inline void
 qla24xx_reset_risc(scsi_qla_host_t *ha)
 {
+	int hw_evt = 0;
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t cnt, d2;
@@ -528,6 +529,8 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
 		d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
 		barrier();
 	}
+	if (cnt == 0)
+		hw_evt = 1;
 
 	/* Wait for soft-reset to complete. */
 	d2 = RD_REG_DWORD(&reg->ctrl_status);
@@ -536,6 +539,10 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
 		d2 = RD_REG_DWORD(&reg->ctrl_status);
 		barrier();
 	}
+	if (cnt == 0 || hw_evt)
+		qla2xxx_hw_event_log(ha, HW_EVENT_RESET_ERR,
+		    RD_REG_WORD(&reg->mailbox1), RD_REG_WORD(&reg->mailbox2),
+		    RD_REG_WORD(&reg->mailbox3));
 
 	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
 	RD_REG_DWORD(&reg->hccr);
@@ -1555,6 +1562,10 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
 		    "invalid -- WWPN) defaults.\n");
 
+		if (chksum)
+			qla2xxx_hw_event_log(ha, HW_EVENT_NVRAM_CHKSUM_ERR, 0,
+			    MSW(chksum), LSW(chksum));
+
 		/*
 		 * Set default initialization control block.
 		 */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e9d8a79..0884642 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -349,6 +349,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n",
 		    mb[1], mb[2], mb[3]);
 
+		qla2x00_post_hwe_work(ha, mb[0], mb[1], mb[2], mb[3]);
 		ha->isp_ops->fw_dump(ha, 1);
 
 		if (IS_FWI2_CAPABLE(ha)) {
@@ -373,6 +374,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		    ha->host_no));
 		qla_printk(KERN_WARNING, ha, "ISP Request Transfer Error.\n");
 
+		qla2x00_post_hwe_work(ha, mb[0], mb[1], mb[2], mb[3]);
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 		break;
 
@@ -381,6 +383,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		    ha->host_no));
 		qla_printk(KERN_WARNING, ha, "ISP Response Transfer Error.\n");
 
+		qla2x00_post_hwe_work(ha, mb[0], mb[1], mb[2], mb[3]);
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 		break;
 
@@ -1558,6 +1561,12 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			if (pci_channel_offline(ha->pdev))
 				break;
 
+			if (ha->hw_event_pause_errors == 0)
+				qla2x00_post_hwe_work(ha, HW_EVENT_PARITY_ERR,
+				    0, MSW(stat), LSW(stat));
+			else if (ha->hw_event_pause_errors < 0xffffffff)
+				ha->hw_event_pause_errors++;
+
 			hccr = RD_REG_DWORD(&reg->hccr);
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
@@ -1693,6 +1702,12 @@ qla24xx_msix_default(int irq, void *dev_id)
 			if (pci_channel_offline(ha->pdev))
 				break;
 
+			if (ha->hw_event_pause_errors == 0)
+				qla2x00_post_hwe_work(ha, HW_EVENT_PARITY_ERR,
+				    0, MSW(stat), LSW(stat));
+			else if (ha->hw_event_pause_errors < 0xffffffff)
+				ha->hw_event_pause_errors++;
+
 			hccr = RD_REG_DWORD(&reg->hccr);
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 898847e..b25c15a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -587,6 +587,14 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
 		if (mcp->mb[5] != 0xA5A5 || mcp->mb[6] != 0x5A5A ||
 		    mcp->mb[7] != 0x2525)
 			rval = QLA_FUNCTION_FAILED;
+		if (rval == QLA_FUNCTION_FAILED) {
+			struct device_reg_24xx __iomem *reg =
+			    &ha->iobase->isp24;
+
+			qla2xxx_hw_event_log(ha, HW_EVENT_ISP_ERR, 0,
+			    LSW(RD_REG_DWORD(&reg->hccr)),
+			    LSW(RD_REG_DWORD(&reg->istatus)));
+		}
 	}
 
 	if (rval != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index eb77067..3d29041 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1690,6 +1690,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_25XX;
 		ha->isp_ops = &qla25xx_isp_ops;
+		ha->hw_event_start = PCI_FUNC(pdev->devfn) ?
+		    FA_HW_EVENT1_ADDR: FA_HW_EVENT0_ADDR;
 	}
 	host->can_queue = ha->request_q_length + 128;
 
@@ -2244,6 +2246,23 @@ qla2x00_post_aen_work(struct scsi_qla_host *ha, enum fc_host_event_code code,
 	return qla2x00_post_work(ha, e, 1);
 }
 
+int
+qla2x00_post_hwe_work(struct scsi_qla_host *ha, uint16_t code, uint16_t d1,
+    uint16_t d2, uint16_t d3)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(ha, QLA_EVT_HWE_LOG, 1);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.hwe.code = code;
+	e->u.hwe.d1 = d1;
+	e->u.hwe.d2 = d2;
+	e->u.hwe.d3 = d3;
+	return qla2x00_post_work(ha, e, 1);
+}
+
 static void
 qla2x00_do_work(struct scsi_qla_host *ha)
 {
@@ -2260,6 +2279,10 @@ qla2x00_do_work(struct scsi_qla_host *ha)
 			fc_host_post_event(ha->host, fc_get_event_number(),
 			    e->u.aen.code, e->u.aen.data);
 			break;
+		case QLA_EVT_HWE_LOG:
+			qla2xxx_hw_event_log(ha, e->u.hwe.code, e->u.hwe.d1,
+			    e->u.hwe.d2, e->u.hwe.d3);
+			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 317cd8f..c10ccc7 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -543,6 +543,43 @@ qla24xx_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
 	}
 }
 
+static void
+qla24xx_unprotect_flash(scsi_qla_host_t *ha)
+{
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	/* Enable flash write. */
+	WRT_REG_DWORD(&reg->ctrl_status,
+	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
+	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+
+	/* Disable flash write-protection. */
+	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
+	/* Some flash parts need an additional zero-write to clear bits.*/
+	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
+}
+
+static void
+qla24xx_protect_flash(scsi_qla_host_t *ha)
+{
+	uint32_t cnt;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	/* Enable flash write-protection and wait for completion. */
+	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0x9c);
+	for (cnt = 300; cnt &&
+	    qla24xx_read_flash_dword(ha,
+		    flash_conf_to_access_addr(0x005)) & BIT_0;
+	    cnt--) {
+		udelay(10);
+	}
+
+	/* Disable flash write. */
+	WRT_REG_DWORD(&reg->ctrl_status,
+	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
+	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+}
+
 static int
 qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
@@ -550,9 +587,8 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 	int ret;
 	uint32_t liter, miter;
 	uint32_t sec_mask, rest_addr, conf_addr;
-	uint32_t fdata, findex, cnt;
+	uint32_t fdata, findex;
 	uint8_t	man_id, flash_id;
-	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	dma_addr_t optrom_dma;
 	void *optrom = NULL;
 	uint32_t *s, *d;
@@ -604,15 +640,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 		break;
 	}
 
-	/* Enable flash write. */
-	WRT_REG_DWORD(&reg->ctrl_status,
-	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
-	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
-
-	/* Disable flash write-protection. */
-	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
-	/* Some flash parts need an additional zero-write to clear bits.*/
-	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
+	qla24xx_unprotect_flash(ha);
 
 	for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
 		if (man_id == 0x1f) {
@@ -690,19 +718,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 			    0xff0000) | ((fdata >> 16) & 0xff));
 	}
 
-	/* Enable flash write-protection and wait for completion. */
-	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0x9c);
-	for (cnt = 300; cnt &&
-	    qla24xx_read_flash_dword(ha,
-		    flash_conf_to_access_addr(0x005)) & BIT_0;
-	    cnt--) {
-		udelay(10);
-	}
-
-	/* Disable flash write. */
-	WRT_REG_DWORD(&reg->ctrl_status,
-	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
-	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+	qla24xx_protect_flash(ha);
 
 	if (optrom)
 		dma_free_coherent(&ha->pdev->dev,
@@ -2221,3 +2237,107 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 
 	return ret;
 }
+
+static int
+qla2xxx_hw_event_store(scsi_qla_host_t *ha, uint32_t *fdata)
+{
+	uint32_t d[2], faddr;
+
+	/* Locate first empty entry. */
+	for (;;) {
+		if (ha->hw_event_ptr >=
+		    ha->hw_event_start + FA_HW_EVENT_SIZE) {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			    "HW event -- Log Full!\n"));
+			return QLA_MEMORY_ALLOC_FAILED;
+		}
+
+		qla24xx_read_flash_data(ha, d, ha->hw_event_ptr, 2);
+		faddr = flash_data_to_access_addr(ha->hw_event_ptr);
+		ha->hw_event_ptr += FA_HW_EVENT_ENTRY_SIZE;
+		if (d[0] == __constant_cpu_to_le32(0xffffffff) &&
+		    d[1] == __constant_cpu_to_le32(0xffffffff)) {
+			qla24xx_unprotect_flash(ha);
+
+			qla24xx_write_flash_dword(ha, faddr++,
+			    cpu_to_le32(jiffies));
+			qla24xx_write_flash_dword(ha, faddr++, 0);
+			qla24xx_write_flash_dword(ha, faddr++, *fdata++);
+			qla24xx_write_flash_dword(ha, faddr++, *fdata);
+
+			qla24xx_protect_flash(ha);
+			break;
+		}
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
+    uint16_t d2, uint16_t d3)
+{
+#define QMARK(a, b, c, d) \
+    cpu_to_le32(LSB(a) << 24 | LSB(b) << 16 | LSB(c) << 8 | LSB(d))
+
+	int rval;
+	uint32_t marker[2], fdata[4];
+
+	if (ha->hw_event_start == 0)
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG2(qla_printk(KERN_WARNING, ha,
+	    "HW event -- code=%x, d1=%x, d2=%x, d3=%x.\n", code, d1, d2, d3));
+
+	/* If marker not already found, locate or write.  */
+	if (!ha->flags.hw_event_marker_found) {
+		/* Create marker. */
+		marker[0] = QMARK('L', ha->fw_major_version,
+		    ha->fw_minor_version, ha->fw_subminor_version);
+		marker[1] = QMARK(QLA_DRIVER_MAJOR_VER, QLA_DRIVER_MINOR_VER,
+		    QLA_DRIVER_PATCH_VER, QLA_DRIVER_BETA_VER);
+
+		/* Locate marker. */
+		ha->hw_event_ptr = ha->hw_event_start;
+		for (;;) {
+			qla24xx_read_flash_data(ha, fdata, ha->hw_event_ptr,
+			    4);
+			if (fdata[0] == __constant_cpu_to_le32(0xffffffff) &&
+			    fdata[1] == __constant_cpu_to_le32(0xffffffff))
+				break;
+			ha->hw_event_ptr += FA_HW_EVENT_ENTRY_SIZE;
+			if (ha->hw_event_ptr >=
+			    ha->hw_event_start + FA_HW_EVENT_SIZE) {
+				DEBUG2(qla_printk(KERN_WARNING, ha,
+				    "HW event -- Log Full!\n"));
+				return QLA_MEMORY_ALLOC_FAILED;
+			}
+			if (fdata[2] == marker[0] && fdata[3] == marker[1]) {
+				ha->flags.hw_event_marker_found = 1;
+				break;
+			}
+		}
+		/* No marker, write it. */
+		if (!ha->flags.hw_event_marker_found) {
+			rval = qla2xxx_hw_event_store(ha, marker);
+			if (rval != QLA_SUCCESS) {
+				DEBUG2(qla_printk(KERN_WARNING, ha,
+				    "HW event -- Failed marker write=%x.!\n",
+				    rval));
+				return rval;
+			}
+			ha->flags.hw_event_marker_found = 1;
+		}
+	}
+
+	/* Store error.  */
+	fdata[0] = cpu_to_le32(code << 16 | d1);
+	fdata[1] = cpu_to_le32(d2 << 16 | d3);
+	rval = qla2xxx_hw_event_store(ha, fdata);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "HW event -- Failed error write=%x.!\n",
+		    rval));
+	}
+
+	return rval;
+}
-- 
1.5.5.rc2

