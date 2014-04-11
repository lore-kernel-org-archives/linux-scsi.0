From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 16/42] qla2xxx: Introduce fw_dump_flag to track fw dump progress.
Date: Fri, 11 Apr 2014 16:54:21 -0400
Message-ID: <1397249687-32666-17-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:63634 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754468AbaDKVcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:31 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Hiral Patel <hiral.patel@qlogic.com>

Signed-off-by: Hiral Patel <hiral.patel@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |   42 +++++++++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_dbg.h  |    3 +-
 drivers/scsi/qla2xxx/qla_def.h  |    7 ++++++
 drivers/scsi/qla2xxx/qla_init.c |    1 +
 drivers/scsi/qla2xxx/qla_os.c   |    1 +
 drivers/scsi/qla2xxx/qla_tmpl.c |    2 +-
 6 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 16939a9..b063c39 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -277,9 +277,15 @@ qla24xx_dump_memory(struct qla_hw_data *ha, uint32_t *code_ram,
 	if (rval != QLA_SUCCESS)
 		return rval;
 
+	set_bit(RISC_SRAM_DUMP_CMPL, &ha->fw_dump_cap_flags);
+
 	/* External Memory. */
-	return qla24xx_dump_ram(ha, 0x100000, *nxt,
+	rval = qla24xx_dump_ram(ha, 0x100000, *nxt,
 	    ha->fw_memory_size - 0x100000 + 1, nxt);
+	if (rval == QLA_SUCCESS)
+		set_bit(RISC_EXT_MEM_DUMP_CMPL, &ha->fw_dump_cap_flags);
+
+	return rval;
 }
 
 static uint32_t *
@@ -297,12 +303,14 @@ qla24xx_read_window(struct device_reg_24xx __iomem *reg, uint32_t iobase,
 }
 
 void
-qla24xx_pause_risc(struct device_reg_24xx __iomem *reg)
+qla24xx_pause_risc(struct device_reg_24xx __iomem *reg, struct qla_hw_data *ha)
 {
 	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
 
 	/* 100 usec delay is sufficient enough for hardware to pause RISC */
 	udelay(100);
+	if (RD_REG_DWORD(&reg->host_status) & HSRX_RISC_PAUSED)
+		set_bit(RISC_PAUSE_CMPL, &ha->fw_dump_cap_flags);
 }
 
 int
@@ -325,6 +333,8 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
 
 		udelay(10);
 	}
+	if (!(RD_REG_DWORD(&reg->ctrl_status) & CSRX_DMA_ACTIVE))
+		set_bit(DMA_SHUTDOWN_CMPL, &ha->fw_dump_cap_flags);
 
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
@@ -340,6 +350,9 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
 
 		udelay(10);
 	}
+	if (!(RD_REG_DWORD(&reg->ctrl_status) & CSRX_ISP_SOFT_RESET))
+		set_bit(ISP_RESET_CMPL, &ha->fw_dump_cap_flags);
+
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
 	RD_REG_DWORD(&reg->hccr);             /* PCI Posting. */
 
@@ -350,6 +363,8 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
 		else
 			rval = QLA_FUNCTION_TIMEOUT;
 	}
+	if (rval == QLA_SUCCESS)
+		set_bit(RISC_RDY_AFT_RESET, &ha->fw_dump_cap_flags);
 
 	return rval;
 }
@@ -646,12 +661,13 @@ qla2xxx_dump_post_process(scsi_qla_host_t *vha, int rval)
 
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0xd000,
-		    "Failed to dump firmware (%x).\n", rval);
+		    "Failed to dump firmware (%x), dump status flags (0x%lx).\n",
+		    rval, ha->fw_dump_cap_flags);
 		ha->fw_dumped = 0;
 	} else {
 		ql_log(ql_log_info, vha, 0xd001,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    vha->host_no, ha->fw_dump);
+		    "Firmware dump saved to temp buffer (%ld/%p), dump status flags (0x%lx).\n",
+		    vha->host_no, ha->fw_dump, ha->fw_dump_cap_flags);
 		ha->fw_dumped = 1;
 		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
 	}
@@ -1040,6 +1056,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	risc_address = ext_mem_cnt = 0;
 	flags = 0;
+	ha->fw_dump_cap_flags = 0;
 
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1066,7 +1083,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	 * Pause RISC. No need to track timeout, as resetting the chip
 	 * is the right approach incase of pause timeout
 	 */
-	qla24xx_pause_risc(reg);
+	qla24xx_pause_risc(reg, ha);
 
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
@@ -1290,6 +1307,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	risc_address = ext_mem_cnt = 0;
 	flags = 0;
+	ha->fw_dump_cap_flags = 0;
 
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1317,7 +1335,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	 * Pause RISC. No need to track timeout, as resetting the chip
 	 * is the right approach incase of pause timeout
 	 */
-	qla24xx_pause_risc(reg);
+	qla24xx_pause_risc(reg, ha);
 
 	/* Host/Risc registers. */
 	iter_reg = fw->host_risc_reg;
@@ -1608,6 +1626,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	risc_address = ext_mem_cnt = 0;
 	flags = 0;
+	ha->fw_dump_cap_flags = 0;
 
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1634,7 +1653,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	 * Pause RISC. No need to track timeout, as resetting the chip
 	 * is the right approach incase of pause timeout
 	 */
-	qla24xx_pause_risc(reg);
+	qla24xx_pause_risc(reg, ha);
 
 	/* Host/Risc registers. */
 	iter_reg = fw->host_risc_reg;
@@ -1928,6 +1947,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	risc_address = ext_mem_cnt = 0;
 	flags = 0;
+	ha->fw_dump_cap_flags = 0;
 
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1953,7 +1973,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	 * Pause RISC. No need to track timeout, as resetting the chip
 	 * is the right approach incase of pause timeout
 	 */
-	qla24xx_pause_risc(reg);
+	qla24xx_pause_risc(reg, ha);
 
 	WRT_REG_DWORD(&reg->iobase_addr, 0x6000);
 	dmp_reg = &reg->iobase_window;
@@ -2376,9 +2396,11 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 			nxt += sizeof(fw->code_ram);
 			nxt += (ha->fw_memory_size - 0x100000 + 1);
 			goto copy_queue;
-		} else
+		} else {
+			set_bit(RISC_RDY_AFT_RESET, &ha->fw_dump_cap_flags);
 			ql_log(ql_log_warn, vha, 0xd010,
 			    "bigger hammer success?\n");
+		}
 	}
 
 	rval = qla24xx_dump_memory(ha, fw->code_ram, sizeof(fw->code_ram),
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 3679b73..feae593 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -353,5 +353,6 @@ extern int qla27xx_dump_mpi_ram(struct qla_hw_data *, uint32_t, uint32_t *,
 	uint32_t, void **);
 extern int qla24xx_dump_ram(struct qla_hw_data *, uint32_t, uint32_t *,
 	uint32_t, void **);
-extern void qla24xx_pause_risc(struct device_reg_24xx __iomem *);
+extern void qla24xx_pause_risc(struct device_reg_24xx __iomem *,
+	struct qla_hw_data *);
 extern int qla24xx_soft_reset(struct qla_hw_data *);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2326827..dd9b7fe0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3147,6 +3147,13 @@ struct qla_hw_data {
 	struct qla2xxx_fw_dump *fw_dump;
 	uint32_t	fw_dump_len;
 	int		fw_dumped;
+	unsigned long	fw_dump_cap_flags;
+#define RISC_PAUSE_CMPL		0
+#define DMA_SHUTDOWN_CMPL	1
+#define ISP_RESET_CMPL		2
+#define RISC_RDY_AFT_RESET	3
+#define RISC_SRAM_DUMP_CMPL	4
+#define RISC_EXT_MEM_DUMP_CMPL	5
 	int		fw_dump_reading;
 	int		prev_minidump_failed;
 	dma_addr_t	eft_dma;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 38aeb54..ec6c8f5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1476,6 +1476,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 	}
 
 	ha->fw_dumped = 0;
+	ha->fw_dump_cap_flags = 0;
 	dump_size = fixed_size = mem_size = eft_size = fce_size = mq_size = 0;
 	req_q_size = rsp_q_size = 0;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0114ea4..ed44e63 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3654,6 +3654,7 @@ qla2x00_free_fw_dump(struct qla_hw_data *ha)
 	ha->eft = NULL;
 	ha->eft_dma = 0;
 	ha->fw_dumped = 0;
+	ha->fw_dump_cap_flags = 0;
 	ha->fw_dump_reading = 0;
 	ha->fw_dump = NULL;
 	ha->fw_dump_len = 0;
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 8469405..8dc9813 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -516,7 +516,7 @@ qla27xx_fwdt_entry_t265(struct scsi_qla_host *vha,
 	ql_dbg(ql_dbg_misc, vha, 0xd209,
 	    "%s: pause risc [%lx]\n", __func__, *len);
 	if (buf)
-		qla24xx_pause_risc(reg);
+		qla24xx_pause_risc(reg, vha->hw);
 
 	return false;
 }
-- 
1.7.7

