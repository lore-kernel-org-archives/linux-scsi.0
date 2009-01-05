From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/8] qla2xxx: Remove support for reading/writing HW-event-log.
Date: Mon,  5 Jan 2009 11:18:05 -0800
Message-ID: <1231183092-10471-2-git-send-email-andrew.vasquez@qlogic.com>
References: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22498 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZAETSS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 14:18:18 -0500
In-Reply-To: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Software should not touch this region of flash, as the firmware
will be the only writer and consumer of the region.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   10 ---
 drivers/scsi/qla2xxx/qla_gbl.h  |    5 --
 drivers/scsi/qla2xxx/qla_init.c |    8 ---
 drivers/scsi/qla2xxx/qla_isr.c  |   15 -----
 drivers/scsi/qla2xxx/qla_mbx.c  |    9 ---
 drivers/scsi/qla2xxx/qla_os.c   |   21 -------
 drivers/scsi/qla2xxx/qla_sup.c  |  120 +--------------------------------------
 7 files changed, 2 insertions(+), 186 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a29c952..fc50221 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2136,7 +2136,6 @@ struct qla_msix_entry {
 /* Work events.  */
 enum qla_work_type {
 	QLA_EVT_AEN,
-	QLA_EVT_HWE_LOG,
 };
 
 
@@ -2151,10 +2150,6 @@ struct qla_work_evt {
 			enum fc_host_event_code code;
 			u32 data;
 		} aen;
-		struct {
-			uint16_t code;
-			uint16_t d1, d2, d3;
-		} hwe;
 	} u;
 };
 
@@ -2489,10 +2484,6 @@ struct qla_hw_data {
 	uint64_t	fce_wr, fce_rd;
 	struct mutex	fce_mutex;
 
-	uint32_t	hw_event_start;
-	uint32_t	hw_event_ptr;
-	uint32_t	hw_event_pause_errors;
-
 	uint32_t	pci_attr;
 	uint16_t	chip_revision;
 
@@ -2533,7 +2524,6 @@ struct qla_hw_data {
 	uint32_t        flt_region_boot;
 	uint32_t        flt_region_fw;
 	uint32_t        flt_region_vpd_nvram;
-	uint32_t        flt_region_hw_event;
 	uint32_t        flt_region_npiv_conf;
 
 	/* Needed for BEACON */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0011e31..450a05c 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -69,8 +69,6 @@ extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
 extern int qla2x00_post_aen_work(struct scsi_qla_host *, enum
     fc_host_event_code, u32);
-extern int qla2x00_post_hwe_work(struct scsi_qla_host *, uint16_t , uint16_t,
-    uint16_t, uint16_t);
 
 extern void qla2x00_abort_fcport_cmds(fc_port_t *);
 extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
@@ -317,9 +315,6 @@ extern uint8_t *qla25xx_read_optrom_data(struct scsi_qla_host *, uint8_t *,
 extern int qla2x00_get_flash_version(scsi_qla_host_t *, void *);
 extern int qla24xx_get_flash_version(scsi_qla_host_t *, void *);
 
-extern int qla2xxx_hw_event_log(scsi_qla_host_t *, uint16_t , uint16_t,
-    uint16_t, uint16_t);
-
 extern int qla2xxx_get_flash_info(scsi_qla_host_t *);
 extern int qla2xxx_get_vpd_field(scsi_qla_host_t *, char *, char *, size_t);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 52ed56e..521d215 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -552,10 +552,6 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 		d2 = RD_REG_DWORD(&reg->ctrl_status);
 		barrier();
 	}
-	if (cnt == 0 || hw_evt)
-		qla2xxx_hw_event_log(vha, HW_EVENT_RESET_ERR,
-		    RD_REG_WORD(&reg->mailbox1), RD_REG_WORD(&reg->mailbox2),
-		    RD_REG_WORD(&reg->mailbox3));
 
 	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
 	RD_REG_DWORD(&reg->hccr);
@@ -1665,10 +1661,6 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
 		    "invalid -- WWPN) defaults.\n");
 
-		if (chksum)
-			qla2xxx_hw_event_log(vha, HW_EVENT_NVRAM_CHKSUM_ERR, 0,
-			    MSW(chksum), LSW(chksum));
-
 		/*
 		 * Set default initialization control block.
 		 */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d5fb79a..6447eb1 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -362,7 +362,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n",
 		    mb[1], mb[2], mb[3]);
 
-		qla2x00_post_hwe_work(vha, mb[0], mb[1], mb[2], mb[3]);
 		ha->isp_ops->fw_dump(vha, 1);
 
 		if (IS_FWI2_CAPABLE(ha)) {
@@ -387,7 +386,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		    vha->host_no));
 		qla_printk(KERN_WARNING, ha, "ISP Request Transfer Error.\n");
 
-		qla2x00_post_hwe_work(vha, mb[0], mb[1], mb[2], mb[3]);
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
 
@@ -396,7 +394,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		    vha->host_no));
 		qla_printk(KERN_WARNING, ha, "ISP Response Transfer Error.\n");
 
-		qla2x00_post_hwe_work(vha, mb[0], mb[1], mb[2], mb[3]);
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
 
@@ -1590,12 +1587,6 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			if (pci_channel_offline(ha->pdev))
 				break;
 
-			if (ha->hw_event_pause_errors == 0)
-				qla2x00_post_hwe_work(vha, HW_EVENT_PARITY_ERR,
-				    0, MSW(stat), LSW(stat));
-			else if (ha->hw_event_pause_errors < 0xffffffff)
-				ha->hw_event_pause_errors++;
-
 			hccr = RD_REG_DWORD(&reg->hccr);
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
@@ -1740,12 +1731,6 @@ qla24xx_msix_default(int irq, void *dev_id)
 			if (pci_channel_offline(ha->pdev))
 				break;
 
-			if (ha->hw_event_pause_errors == 0)
-				qla2x00_post_hwe_work(vha, HW_EVENT_PARITY_ERR,
-				    0, MSW(stat), LSW(stat));
-			else if (ha->hw_event_pause_errors < 0xffffffff)
-				ha->hw_event_pause_errors++;
-
 			hccr = RD_REG_DWORD(&reg->hccr);
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a99976f..f03de8c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -568,7 +568,6 @@ int
 qla2x00_mbx_reg_test(scsi_qla_host_t *vha)
 {
 	int rval;
-	struct qla_hw_data *ha = vha->hw;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
@@ -595,14 +594,6 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *vha)
 		if (mcp->mb[5] != 0xA5A5 || mcp->mb[6] != 0x5A5A ||
 		    mcp->mb[7] != 0x2525)
 			rval = QLA_FUNCTION_FAILED;
-		if (rval == QLA_FUNCTION_FAILED) {
-			struct device_reg_24xx __iomem *reg =
-			    &ha->iobase->isp24;
-
-			qla2xxx_hw_event_log(vha, HW_EVENT_ISP_ERR, 0,
-			    LSW(RD_REG_DWORD(&reg->hccr)),
-			    LSW(RD_REG_DWORD(&reg->istatus)));
-		}
 	}
 
 	if (rval != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8ea9277..3b1b68c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2458,23 +2458,6 @@ qla2x00_post_aen_work(struct scsi_qla_host *vha, enum fc_host_event_code code,
 	return qla2x00_post_work(vha, e, 1);
 }
 
-int
-qla2x00_post_hwe_work(struct scsi_qla_host *vha, uint16_t code, uint16_t d1,
-    uint16_t d2, uint16_t d3)
-{
-	struct qla_work_evt *e;
-
-	e = qla2x00_alloc_work(vha, QLA_EVT_HWE_LOG, 1);
-	if (!e)
-		return QLA_FUNCTION_FAILED;
-
-	e->u.hwe.code = code;
-	e->u.hwe.d1 = d1;
-	e->u.hwe.d2 = d2;
-	e->u.hwe.d3 = d3;
-	return qla2x00_post_work(vha, e, 1);
-}
-
 static void
 qla2x00_do_work(struct scsi_qla_host *vha)
 {
@@ -2492,10 +2475,6 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 			fc_host_post_event(vha->host, fc_get_event_number(),
 			    e->u.aen.code, e->u.aen.data);
 			break;
-		case QLA_EVT_HWE_LOG:
-			qla2xxx_hw_event_log(vha, e->u.hwe.code, e->u.hwe.d1,
-			    e->u.hwe.d2, e->u.hwe.d3);
-			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index c538ee1..628d79c 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -676,14 +676,6 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 		case FLT_REG_FDT:
 			ha->flt_region_fdt = start;
 			break;
-		case FLT_REG_HW_EVENT_0:
-			if (!PCI_FUNC(ha->pdev->devfn))
-				ha->flt_region_hw_event = start;
-			break;
-		case FLT_REG_HW_EVENT_1:
-			if (PCI_FUNC(ha->pdev->devfn))
-				ha->flt_region_hw_event = start;
-			break;
 		case FLT_REG_NPIV_CONF_0:
 			if (!PCI_FUNC(ha->pdev->devfn))
 				ha->flt_region_npiv_conf = start;
@@ -704,17 +696,14 @@ no_flash_data:
 	ha->flt_region_vpd_nvram = FA_VPD_NVRAM_ADDR;
 	ha->flt_region_fdt = IS_QLA24XX_TYPE(ha) ? FA_FLASH_DESCR_ADDR_24:
 	    FA_FLASH_DESCR_ADDR;
-	ha->flt_region_hw_event = !PCI_FUNC(ha->pdev->devfn) ?
-	    FA_HW_EVENT0_ADDR: FA_HW_EVENT1_ADDR;
 	ha->flt_region_npiv_conf = !PCI_FUNC(ha->pdev->devfn) ?
 	    (IS_QLA24XX_TYPE(ha) ? FA_NPIV_CONF0_ADDR_24: FA_NPIV_CONF0_ADDR):
 	    (IS_QLA24XX_TYPE(ha) ? FA_NPIV_CONF1_ADDR_24: FA_NPIV_CONF1_ADDR);
 done:
 	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLT[%s]: boot=0x%x fw=0x%x "
-	    "vpd_nvram=0x%x fdt=0x%x flt=0x%x hwe=0x%x npiv=0x%x.\n", loc,
+	    "vpd_nvram=0x%x fdt=0x%x flt=0x%x npiv=0x%x.\n", loc,
 	    ha->flt_region_boot, ha->flt_region_fw, ha->flt_region_vpd_nvram,
-	    ha->flt_region_fdt, ha->flt_region_flt, ha->flt_region_hw_event,
-	    ha->flt_region_npiv_conf));
+	    ha->flt_region_fdt, ha->flt_region_flt, ha->flt_region_npiv_conf));
 }
 
 static void
@@ -2648,108 +2637,3 @@ qla2xxx_get_vpd_field(scsi_qla_host_t *vha, char *key, char *str, size_t size)
 
 	return 0;
 }
-
-static int
-qla2xxx_hw_event_store(scsi_qla_host_t *vha, uint32_t *fdata)
-{
-	uint32_t d[2], faddr;
-	struct qla_hw_data *ha = vha->hw;
-
-	/* Locate first empty entry. */
-	for (;;) {
-		if (ha->hw_event_ptr >=
-		    ha->flt_region_hw_event + FA_HW_EVENT_SIZE) {
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			    "HW event -- Log Full!\n"));
-			return QLA_MEMORY_ALLOC_FAILED;
-		}
-
-		qla24xx_read_flash_data(vha, d, ha->hw_event_ptr, 2);
-		faddr = flash_data_to_access_addr(ha->hw_event_ptr);
-		ha->hw_event_ptr += FA_HW_EVENT_ENTRY_SIZE;
-		if (d[0] == __constant_cpu_to_le32(0xffffffff) &&
-		    d[1] == __constant_cpu_to_le32(0xffffffff)) {
-			qla24xx_unprotect_flash(ha);
-
-			qla24xx_write_flash_dword(ha, faddr++,
-			    cpu_to_le32(jiffies));
-			qla24xx_write_flash_dword(ha, faddr++, 0);
-			qla24xx_write_flash_dword(ha, faddr++, *fdata++);
-			qla24xx_write_flash_dword(ha, faddr++, *fdata);
-
-			qla24xx_protect_flash(ha);
-			break;
-		}
-	}
-	return QLA_SUCCESS;
-}
-
-int
-qla2xxx_hw_event_log(scsi_qla_host_t *vha, uint16_t code, uint16_t d1,
-    uint16_t d2, uint16_t d3)
-{
-#define QMARK(a, b, c, d) \
-    cpu_to_le32(LSB(a) << 24 | LSB(b) << 16 | LSB(c) << 8 | LSB(d))
-	struct qla_hw_data *ha = vha->hw;
-	int rval;
-	uint32_t marker[2], fdata[4];
-
-	if (ha->flt_region_hw_event == 0)
-		return QLA_FUNCTION_FAILED;
-
-	DEBUG2(qla_printk(KERN_WARNING, ha,
-	    "HW event -- code=%x, d1=%x, d2=%x, d3=%x.\n", code, d1, d2, d3));
-
-	/* If marker not already found, locate or write.  */
-	if (!ha->flags.hw_event_marker_found) {
-		/* Create marker. */
-		marker[0] = QMARK('L', ha->fw_major_version,
-		    ha->fw_minor_version, ha->fw_subminor_version);
-		marker[1] = QMARK(QLA_DRIVER_MAJOR_VER, QLA_DRIVER_MINOR_VER,
-		    QLA_DRIVER_PATCH_VER, QLA_DRIVER_BETA_VER);
-
-		/* Locate marker. */
-		ha->hw_event_ptr = ha->flt_region_hw_event;
-		for (;;) {
-			qla24xx_read_flash_data(vha, fdata, ha->hw_event_ptr,
-			    4);
-			if (fdata[0] == __constant_cpu_to_le32(0xffffffff) &&
-			    fdata[1] == __constant_cpu_to_le32(0xffffffff))
-				break;
-			ha->hw_event_ptr += FA_HW_EVENT_ENTRY_SIZE;
-			if (ha->hw_event_ptr >=
-			    ha->flt_region_hw_event + FA_HW_EVENT_SIZE) {
-				DEBUG2(qla_printk(KERN_WARNING, ha,
-				    "HW event -- Log Full!\n"));
-				return QLA_MEMORY_ALLOC_FAILED;
-			}
-			if (fdata[2] == marker[0] && fdata[3] == marker[1]) {
-				ha->flags.hw_event_marker_found = 1;
-				break;
-			}
-		}
-		/* No marker, write it. */
-		if (!ha->flags.hw_event_marker_found) {
-			rval = qla2xxx_hw_event_store(vha, marker);
-			if (rval != QLA_SUCCESS) {
-				DEBUG2(qla_printk(KERN_WARNING, ha,
-				    "HW event -- Failed marker write=%x.!\n",
-				    rval));
-				return rval;
-			}
-			ha->flags.hw_event_marker_found = 1;
-		}
-	}
-
-	/* Store error.  */
-	fdata[0] = cpu_to_le32(code << 16 | d1);
-	fdata[1] = cpu_to_le32(d2 << 16 | d3);
-	rval = qla2xxx_hw_event_store(vha, fdata);
-	if (rval != QLA_SUCCESS) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "HW event -- Failed error write=%x.!\n",
-		    rval));
-	}
-
-	return rval;
-}
-- 
1.6.1.28.gc32f76

