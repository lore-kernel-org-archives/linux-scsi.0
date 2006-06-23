From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/13] qla2xxx: Rework firmware-trace facilities.
Date: Fri, 23 Jun 2006 16:10:29 -0700
Message-ID: <11511042291279-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:21679 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752155AbWFWXKa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:10:30 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

- Defer firmware dump-data raw-to-textual conversion to
  user-space.
- Add module parameter (ql2xallocfwdump) to allow for per-HBA
  allocations of firmware dump memory.
- Dump request and response queue data as per firmware group
  request.
- Add extended firmware trace support for ISP24XX/ISP54XX chips.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   53 +-
 drivers/scsi/qla2xxx/qla_dbg.c  |  925 ++++++++-------------------------------
 drivers/scsi/qla2xxx/qla_dbg.h  |   41 ++
 drivers/scsi/qla2xxx/qla_def.h  |   12 -
 drivers/scsi/qla2xxx/qla_gbl.h  |    9 
 drivers/scsi/qla2xxx/qla_init.c |  104 ++++
 drivers/scsi/qla2xxx/qla_mbx.c  |   42 ++
 drivers/scsi/qla2xxx/qla_os.c   |   26 +
 8 files changed, 401 insertions(+), 811 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e96d58d..78eec67 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -16,15 +16,16 @@ qla2x00_sysfs_read_fw_dump(struct kobjec
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	char *rbuf = (char *)ha->fw_dump;
 
 	if (ha->fw_dump_reading == 0)
 		return 0;
-	if (off > ha->fw_dump_buffer_len)
-		return 0;
-	if (off + count > ha->fw_dump_buffer_len)
-		count = ha->fw_dump_buffer_len - off;
+	if (off > ha->fw_dump_len)
+                return 0;
+	if (off + count > ha->fw_dump_len)
+		count = ha->fw_dump_len - off;
 
-	memcpy(buf, &ha->fw_dump_buffer[off], count);
+	memcpy(buf, &rbuf[off], count);
 
 	return (count);
 }
@@ -36,7 +37,6 @@ qla2x00_sysfs_write_fw_dump(struct kobje
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	int reading;
-	uint32_t dump_size;
 
 	if (off != 0)
 		return (0);
@@ -44,46 +44,27 @@ qla2x00_sysfs_write_fw_dump(struct kobje
 	reading = simple_strtol(buf, NULL, 10);
 	switch (reading) {
 	case 0:
-		if (ha->fw_dump_reading == 1) {
-			qla_printk(KERN_INFO, ha,
-			    "Firmware dump cleared on (%ld).\n", ha->host_no);
+		if (!ha->fw_dump_reading)
+			break;
 
-			vfree(ha->fw_dump_buffer);
-			ha->fw_dump_buffer = NULL;
-			ha->fw_dump_reading = 0;
-			ha->fw_dumped = 0;
-		}
+		qla_printk(KERN_INFO, ha,
+		    "Firmware dump cleared on (%ld).\n", ha->host_no);
+
+		ha->fw_dump_reading = 0;
+		ha->fw_dumped = 0;
 		break;
 	case 1:
 		if (ha->fw_dumped && !ha->fw_dump_reading) {
 			ha->fw_dump_reading = 1;
 
-			if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
-				dump_size = FW_DUMP_SIZE_24XX;
-			else {
-				dump_size = FW_DUMP_SIZE_1M;
-				if (ha->fw_memory_size < 0x20000)
-					dump_size = FW_DUMP_SIZE_128K;
-				else if (ha->fw_memory_size < 0x80000)
-					dump_size = FW_DUMP_SIZE_512K;
-			}
-			ha->fw_dump_buffer = (char *)vmalloc(dump_size);
-			if (ha->fw_dump_buffer == NULL) {
-				qla_printk(KERN_WARNING, ha,
-				    "Unable to allocate memory for firmware "
-				    "dump buffer (%d).\n", dump_size);
-
-				ha->fw_dump_reading = 0;
-				return (count);
-			}
 			qla_printk(KERN_INFO, ha,
-			    "Firmware dump ready for read on (%ld).\n",
+			    "Raw firmware dump ready for read on (%ld).\n",
 			    ha->host_no);
-			memset(ha->fw_dump_buffer, 0, dump_size);
-			ha->isp_ops.ascii_fw_dump(ha);
-			ha->fw_dump_buffer_len = strlen(ha->fw_dump_buffer);
 		}
 		break;
+	case 2:
+		qla2x00_alloc_fw_dump(ha);
+		break;
 	}
 	return (count);
 }
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 74e5471..f6ed696 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -8,7 +8,34 @@ #include "qla_def.h"
 
 #include <linux/delay.h>
 
-static int qla_uprintf(char **, char *, ...);
+static inline void
+qla2xxx_prep_dump(scsi_qla_host_t *ha, struct qla2xxx_fw_dump *fw_dump)
+{
+	fw_dump->fw_major_version = htonl(ha->fw_major_version);
+	fw_dump->fw_minor_version = htonl(ha->fw_minor_version);
+	fw_dump->fw_subminor_version = htonl(ha->fw_subminor_version);
+	fw_dump->fw_attributes = htonl(ha->fw_attributes);
+
+	fw_dump->vendor = htonl(ha->pdev->vendor);
+	fw_dump->device = htonl(ha->pdev->device);
+	fw_dump->subsystem_vendor = htonl(ha->pdev->subsystem_vendor);
+	fw_dump->subsystem_device = htonl(ha->pdev->subsystem_device);
+}
+
+static inline void *
+qla2xxx_copy_queues(scsi_qla_host_t *ha, void *ptr)
+{
+	/* Request queue. */
+	memcpy(ptr, ha->request_ring, ha->request_q_length *
+	    sizeof(request_t));
+
+	/* Response queue. */
+	ptr += ha->request_q_length * sizeof(request_t);
+	memcpy(ptr, ha->response_ring, ha->response_q_length  *
+	    sizeof(response_t));
+
+	return ptr + (ha->response_q_length * sizeof(response_t));
+}
 
 /**
  * qla2300_fw_dump() - Dumps binary data from the 2300 firmware.
@@ -49,10 +76,11 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 		    "request...\n", ha->fw_dump);
 		goto qla2300_fw_dump_failed;
 	}
-	fw = ha->fw_dump;
+	fw = &ha->fw_dump->isp.isp23;
+	qla2xxx_prep_dump(ha, ha->fw_dump);
 
 	rval = QLA_SUCCESS;
-	fw->hccr = RD_REG_WORD(&reg->hccr);
+	fw->hccr = htons(RD_REG_WORD(&reg->hccr));
 
 	/* Pause RISC. */
 	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
@@ -73,85 +101,86 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 	if (rval == QLA_SUCCESS) {
 		dmp_reg = (uint16_t __iomem *)(reg + 0);
 		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++)
-			fw->pbiu_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->pbiu_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x10);
 		for (cnt = 0; cnt < sizeof(fw->risc_host_reg) / 2; cnt++)
-			fw->risc_host_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_host_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x40);
 		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
-			fw->mailbox_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x40);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->resp_dma_reg) / 2; cnt++)
-			fw->resp_dma_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->resp_dma_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x50);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++)
-			fw->dma_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->dma_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x00);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0xA0);
 		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++)
-			fw->risc_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_hdw_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2000);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp0_reg) / 2; cnt++)
-			fw->risc_gp0_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp0_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2200);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp1_reg) / 2; cnt++)
-			fw->risc_gp1_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp1_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2400);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp2_reg) / 2; cnt++)
-			fw->risc_gp2_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp2_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2600);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp3_reg) / 2; cnt++)
-			fw->risc_gp3_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp3_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2800);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp4_reg) / 2; cnt++)
-			fw->risc_gp4_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp4_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2A00);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp5_reg) / 2; cnt++)
-			fw->risc_gp5_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp5_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2C00);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp6_reg) / 2; cnt++)
-			fw->risc_gp6_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp6_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2E00);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp7_reg) / 2; cnt++)
-			fw->risc_gp7_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp7_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x10);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->frame_buf_hdw_reg) / 2; cnt++)
-			fw->frame_buf_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->frame_buf_hdw_reg[cnt] =
+			    htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x20);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->fpm_b0_reg) / 2; cnt++)
-			fw->fpm_b0_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->fpm_b0_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x30);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++)
-			fw->fpm_b1_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->fpm_b1_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		/* Reset RISC. */
 		WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
@@ -226,7 +255,7 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 
 		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
 			rval = mb0 & MBS_MASK;
-			fw->risc_ram[cnt] = mb2;
+			fw->risc_ram[cnt] = htons(mb2);
 		} else {
 			rval = QLA_FUNCTION_FAILED;
 		}
@@ -285,7 +314,7 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 
 		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
 			rval = mb0 & MBS_MASK;
-			fw->stack_ram[cnt] = mb2;
+			fw->stack_ram[cnt] = htons(mb2);
 		} else {
 			rval = QLA_FUNCTION_FAILED;
 		}
@@ -345,12 +374,15 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 
 		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
 			rval = mb0 & MBS_MASK;
-			fw->data_ram[cnt] = mb2;
+			fw->data_ram[cnt] = htons(mb2);
 		} else {
 			rval = QLA_FUNCTION_FAILED;
 		}
 	}
 
+	if (rval == QLA_SUCCESS)
+		qla2xxx_copy_queues(ha, &fw->data_ram[cnt]);
+
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to dump firmware (%x)!!!\n", rval);
@@ -369,193 +401,6 @@ qla2300_fw_dump_failed:
 }
 
 /**
- * qla2300_ascii_fw_dump() - Converts a binary firmware dump to ASCII.
- * @ha: HA context
- */
-void
-qla2300_ascii_fw_dump(scsi_qla_host_t *ha)
-{
-	uint32_t cnt;
-	char *uiter;
-	char fw_info[30];
-	struct qla2300_fw_dump *fw;
-	uint32_t data_ram_cnt;
-
-	uiter = ha->fw_dump_buffer;
-	fw = ha->fw_dump;
-
-	qla_uprintf(&uiter, "%s Firmware Version %s\n", ha->model_number,
-	    ha->isp_ops.fw_version_str(ha, fw_info));
-
-	qla_uprintf(&uiter, "\n[==>BEG]\n");
-
-	qla_uprintf(&uiter, "HCCR Register:\n%04x\n\n", fw->hccr);
-
-	qla_uprintf(&uiter, "PBIU Registers:");
-	for (cnt = 0; cnt < sizeof (fw->pbiu_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->pbiu_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nReqQ-RspQ-Risc2Host Status registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_host_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_host_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nMailbox Registers:");
-	for (cnt = 0; cnt < sizeof (fw->mailbox_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->mailbox_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nAuto Request Response DMA Registers:");
-	for (cnt = 0; cnt < sizeof (fw->resp_dma_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->resp_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nDMA Registers:");
-	for (cnt = 0; cnt < sizeof (fw->dma_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC Hardware Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_hdw_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_hdw_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP0 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp0_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp0_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP1 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp1_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp1_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP2 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp2_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp2_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP3 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp3_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp3_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP4 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp4_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp4_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP5 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp5_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp5_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP6 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp6_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp6_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP7 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp7_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp7_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nFrame Buffer Hardware Registers:");
-	for (cnt = 0; cnt < sizeof (fw->frame_buf_hdw_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->frame_buf_hdw_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nFPM B0 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->fpm_b0_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->fpm_b0_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nFPM B1 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->fpm_b1_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->fpm_b1_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nCode RAM Dump:");
-	for (cnt = 0; cnt < sizeof (fw->risc_ram) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n%04x: ", cnt + 0x0800);
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_ram[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nStack RAM Dump:");
-	for (cnt = 0; cnt < sizeof (fw->stack_ram) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n%05x: ", cnt + 0x10000);
-		}
-		qla_uprintf(&uiter, "%04x ", fw->stack_ram[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nData RAM Dump:");
-	data_ram_cnt = ha->fw_memory_size - 0x11000 + 1;
-	for (cnt = 0; cnt < data_ram_cnt; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n%05x: ", cnt + 0x11000);
-		}
-		qla_uprintf(&uiter, "%04x ", fw->data_ram[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\n[<==END] ISP Debug Dump.");
-}
-
-/**
  * qla2100_fw_dump() - Dumps binary data from the 2100/2200 firmware.
  * @ha: HA context
  * @hardware_locked: Called with the hardware_lock
@@ -591,10 +436,11 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int
 		    "request...\n", ha->fw_dump);
 		goto qla2100_fw_dump_failed;
 	}
-	fw = ha->fw_dump;
+	fw = &ha->fw_dump->isp.isp21;
+	qla2xxx_prep_dump(ha, ha->fw_dump);
 
 	rval = QLA_SUCCESS;
-	fw->hccr = RD_REG_WORD(&reg->hccr);
+	fw->hccr = htons(RD_REG_WORD(&reg->hccr));
 
 	/* Pause RISC. */
 	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
@@ -608,79 +454,81 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int
 	if (rval == QLA_SUCCESS) {
 		dmp_reg = (uint16_t __iomem *)(reg + 0);
 		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++)
-			fw->pbiu_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->pbiu_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x10);
 		for (cnt = 0; cnt < ha->mbx_count; cnt++) {
 			if (cnt == 8) {
-				dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0xe0);
+				dmp_reg = (uint16_t __iomem *)
+					((uint8_t __iomem *)reg + 0xe0);
 			}
-			fw->mailbox_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 		}
 
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x20);
 		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++)
-			fw->dma_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->dma_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x00);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0xA0);
 		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++)
-			fw->risc_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_hdw_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2000);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp0_reg) / 2; cnt++)
-			fw->risc_gp0_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp0_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2100);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp1_reg) / 2; cnt++)
-			fw->risc_gp1_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp1_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2200);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp2_reg) / 2; cnt++)
-			fw->risc_gp2_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp2_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2300);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp3_reg) / 2; cnt++)
-			fw->risc_gp3_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp3_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2400);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp4_reg) / 2; cnt++)
-			fw->risc_gp4_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp4_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2500);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp5_reg) / 2; cnt++)
-			fw->risc_gp5_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp5_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2600);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp6_reg) / 2; cnt++)
-			fw->risc_gp6_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp6_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2700);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp7_reg) / 2; cnt++)
-			fw->risc_gp7_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->risc_gp7_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x10);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->frame_buf_hdw_reg) / 2; cnt++)
-			fw->frame_buf_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->frame_buf_hdw_reg[cnt] =
+			    htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x20);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->fpm_b0_reg) / 2; cnt++)
-			fw->fpm_b0_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->fpm_b0_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x30);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++)
-			fw->fpm_b1_reg[cnt] = RD_REG_WORD(dmp_reg++);
+			fw->fpm_b1_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		/* Reset the ISP. */
 		WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
@@ -755,12 +603,15 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int
 
 		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
 			rval = mb0 & MBS_MASK;
-			fw->risc_ram[cnt] = mb2;
+			fw->risc_ram[cnt] = htons(mb2);
 		} else {
 			rval = QLA_FUNCTION_FAILED;
 		}
 	}
 
+	if (rval == QLA_SUCCESS)
+		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
+
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to dump firmware (%x)!!!\n", rval);
@@ -778,179 +629,6 @@ qla2100_fw_dump_failed:
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
-/**
- * qla2100_ascii_fw_dump() - Converts a binary firmware dump to ASCII.
- * @ha: HA context
- */
-void
-qla2100_ascii_fw_dump(scsi_qla_host_t *ha)
-{
-	uint32_t cnt;
-	char *uiter;
-	char fw_info[30];
-	struct qla2100_fw_dump *fw;
-
-	uiter = ha->fw_dump_buffer;
-	fw = ha->fw_dump;
-
-	qla_uprintf(&uiter, "%s Firmware Version %s\n", ha->model_number,
-	    ha->isp_ops.fw_version_str(ha, fw_info));
-
-	qla_uprintf(&uiter, "\n[==>BEG]\n");
-
-	qla_uprintf(&uiter, "HCCR Register:\n%04x\n\n", fw->hccr);
-
-	qla_uprintf(&uiter, "PBIU Registers:");
-	for (cnt = 0; cnt < sizeof (fw->pbiu_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->pbiu_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nMailbox Registers:");
-	for (cnt = 0; cnt < sizeof (fw->mailbox_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->mailbox_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nDMA Registers:");
-	for (cnt = 0; cnt < sizeof (fw->dma_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC Hardware Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_hdw_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_hdw_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP0 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp0_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp0_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP1 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp1_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp1_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP2 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp2_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp2_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP3 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp3_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp3_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP4 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp4_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp4_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP5 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp5_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp5_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP6 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp6_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp6_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP7 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->risc_gp7_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_gp7_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nFrame Buffer Hardware Registers:");
-	for (cnt = 0; cnt < sizeof (fw->frame_buf_hdw_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->frame_buf_hdw_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nFPM B0 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->fpm_b0_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->fpm_b0_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nFPM B1 Registers:");
-	for (cnt = 0; cnt < sizeof (fw->fpm_b1_reg) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n");
-		}
-		qla_uprintf(&uiter, "%04x ", fw->fpm_b1_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC SRAM:");
-	for (cnt = 0; cnt < sizeof (fw->risc_ram) / 2; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n%04x: ", cnt + 0x1000);
-		}
-		qla_uprintf(&uiter, "%04x ", fw->risc_ram[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\n[<==END] ISP Debug Dump.");
-
-	return;
-}
-
-static int
-qla_uprintf(char **uiter, char *fmt, ...)
-{
-	int	iter, len;
-	char	buf[128];
-	va_list	args;
-
-	va_start(args, fmt);
-	len = vsprintf(buf, fmt, args);
-	va_end(args);
-
-	for (iter = 0; iter < len; iter++, *uiter += 1)
-		*uiter[0] = buf[iter];
-
-	return (len);
-}
-
-
 void
 qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 {
@@ -967,6 +645,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 	unsigned long	flags;
 	struct qla24xx_fw_dump *fw;
 	uint32_t	ext_mem_cnt;
+	void		*eft;
 
 	risc_address = ext_mem_cnt = 0;
 	memset(mb, 0, sizeof(mb));
@@ -987,10 +666,11 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 		    "request...\n", ha->fw_dump);
 		goto qla24xx_fw_dump_failed;
 	}
-	fw = ha->fw_dump;
+	fw = &ha->fw_dump->isp.isp24;
+	qla2xxx_prep_dump(ha, ha->fw_dump);
 
 	rval = QLA_SUCCESS;
-	fw->host_status = RD_REG_DWORD(&reg->host_status);
+	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
 
 	/* Pause RISC. */
 	if ((RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0) {
@@ -1012,7 +692,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 		/* Host interface registers. */
 		dmp_reg = (uint32_t __iomem *)(reg + 0);
 		for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
-			fw->host_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+			fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Disable interrupts. */
 		WRT_REG_DWORD(&reg->ictrl, 0);
@@ -1024,470 +704,471 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
 		WRT_REG_DWORD(dmp_reg, 0xB0000000);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[0] = RD_REG_DWORD(dmp_reg);
+		fw->shadow_reg[0] = htonl(RD_REG_DWORD(dmp_reg));
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
 		WRT_REG_DWORD(dmp_reg, 0xB0100000);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[1] = RD_REG_DWORD(dmp_reg);
+		fw->shadow_reg[1] = htonl(RD_REG_DWORD(dmp_reg));
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
 		WRT_REG_DWORD(dmp_reg, 0xB0200000);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[2] = RD_REG_DWORD(dmp_reg);
+		fw->shadow_reg[2] = htonl(RD_REG_DWORD(dmp_reg));
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
 		WRT_REG_DWORD(dmp_reg, 0xB0300000);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[3] = RD_REG_DWORD(dmp_reg);
+		fw->shadow_reg[3] = htonl(RD_REG_DWORD(dmp_reg));
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
 		WRT_REG_DWORD(dmp_reg, 0xB0400000);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[4] = RD_REG_DWORD(dmp_reg);
+		fw->shadow_reg[4] = htonl(RD_REG_DWORD(dmp_reg));
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
 		WRT_REG_DWORD(dmp_reg, 0xB0500000);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[5] = RD_REG_DWORD(dmp_reg);
+		fw->shadow_reg[5] = htonl(RD_REG_DWORD(dmp_reg));
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
 		WRT_REG_DWORD(dmp_reg, 0xB0600000);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[6] = RD_REG_DWORD(dmp_reg);
+		fw->shadow_reg[6] = htonl(RD_REG_DWORD(dmp_reg));
 
 		/* Mailbox registers. */
 		mbx_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
-			fw->mailbox_reg[cnt] = RD_REG_WORD(mbx_reg++);
+			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg++));
 
 		/* Transfer sequence registers. */
 		iter_reg = fw->xseq_gp_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF00);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF10);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF20);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF30);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF40);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF50);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF60);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF70);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBFE0);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < sizeof(fw->xseq_0_reg) / 4; cnt++)
-			fw->xseq_0_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+			fw->xseq_0_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBFF0);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < sizeof(fw->xseq_1_reg) / 4; cnt++)
-			fw->xseq_1_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+			fw->xseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Receive sequence registers. */
 		iter_reg = fw->rseq_gp_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF00);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF10);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF20);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF30);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF40);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF50);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF60);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF70);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFFD0);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < sizeof(fw->rseq_0_reg) / 4; cnt++)
-			fw->rseq_0_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+			fw->rseq_0_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFFE0);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < sizeof(fw->rseq_1_reg) / 4; cnt++)
-			fw->rseq_1_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+			fw->rseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFFF0);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < sizeof(fw->rseq_2_reg) / 4; cnt++)
-			fw->rseq_2_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+			fw->rseq_2_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Command DMA registers. */
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7100);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < sizeof(fw->cmd_dma_reg) / 4; cnt++)
-			fw->cmd_dma_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+			fw->cmd_dma_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Queues. */
 		iter_reg = fw->req0_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7200);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 8; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xE4);
 		for (cnt = 0; cnt < 7; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->resp0_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7300);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 8; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xE4);
 		for (cnt = 0; cnt < 7; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->req1_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7400);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 8; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xE4);
 		for (cnt = 0; cnt < 7; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Transmit DMA registers. */
 		iter_reg = fw->xmt0_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7600);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7610);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->xmt1_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7620);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7630);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->xmt2_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7640);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7650);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->xmt3_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7660);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7670);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->xmt4_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7680);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7690);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x76A0);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < sizeof(fw->xmt_data_dma_reg) / 4; cnt++)
-			fw->xmt_data_dma_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+			fw->xmt_data_dma_reg[cnt] =
+			    htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Receive DMA registers. */
 		iter_reg = fw->rcvt0_data_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7700);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7710);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->rcvt1_data_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7720);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7730);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* RISC registers. */
 		iter_reg = fw->risc_gp_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F00);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F10);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F20);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F30);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F40);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F50);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F60);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Local memory controller registers. */
 		iter_reg = fw->lmc_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3000);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3010);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3020);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3030);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3040);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3050);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3060);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Fibre Protocol Module registers. */
 		iter_reg = fw->fpm_hdw_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4000);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4010);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4020);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4030);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4040);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4050);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4060);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4070);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4080);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4090);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x40A0);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x40B0);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Frame Buffer registers. */
 		iter_reg = fw->fb_hdw_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6000);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6010);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6020);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6030);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6040);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6100);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6130);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6150);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6170);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6190);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x61B0);
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
 		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Reset RISC. */
 		WRT_REG_DWORD(&reg->ctrl_status,
@@ -1577,7 +1258,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 
 		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
 			rval = mb[0] & MBS_MASK;
-			fw->code_ram[cnt] = (mb[3] << 16) | mb[2];
+			fw->code_ram[cnt] = htonl((mb[3] << 16) | mb[2]);
 		} else {
 			rval = QLA_FUNCTION_FAILED;
 		}
@@ -1627,12 +1308,18 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 
 		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
 			rval = mb[0] & MBS_MASK;
-			fw->ext_mem[cnt] = (mb[3] << 16) | mb[2];
+			fw->ext_mem[cnt] = htonl((mb[3] << 16) | mb[2]);
 		} else {
 			rval = QLA_FUNCTION_FAILED;
 		}
 	}
 
+	if (rval == QLA_SUCCESS) {
+		eft = qla2xxx_copy_queues(ha, &fw->ext_mem[cnt]);
+		if (ha->eft)
+			memcpy(eft, ha->eft, ntohl(ha->fw_dump->eft_size));
+	}
+
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to dump firmware (%x)!!!\n", rval);
@@ -1650,252 +1337,6 @@ qla24xx_fw_dump_failed:
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
-void
-qla24xx_ascii_fw_dump(scsi_qla_host_t *ha)
-{
-	uint32_t cnt;
-	char *uiter;
-	struct qla24xx_fw_dump *fw;
-	uint32_t ext_mem_cnt;
-
-	uiter = ha->fw_dump_buffer;
-	fw = ha->fw_dump;
-
-	qla_uprintf(&uiter, "ISP FW Version %d.%02d.%02d Attributes %04x\n",
-	    ha->fw_major_version, ha->fw_minor_version,
-	    ha->fw_subminor_version, ha->fw_attributes);
-
-	qla_uprintf(&uiter, "\nR2H Status Register\n%04x\n", fw->host_status);
-
-	qla_uprintf(&uiter, "\nHost Interface Registers");
-	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->host_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nShadow Registers");
-	for (cnt = 0; cnt < sizeof(fw->shadow_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->shadow_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nMailbox Registers");
-	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->mailbox_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nXSEQ GP Registers");
-	for (cnt = 0; cnt < sizeof(fw->xseq_gp_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->xseq_gp_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nXSEQ-0 Registers");
-	for (cnt = 0; cnt < sizeof(fw->xseq_0_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->xseq_0_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nXSEQ-1 Registers");
-	for (cnt = 0; cnt < sizeof(fw->xseq_1_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->xseq_1_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRSEQ GP Registers");
-	for (cnt = 0; cnt < sizeof(fw->rseq_gp_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->rseq_gp_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRSEQ-0 Registers");
-	for (cnt = 0; cnt < sizeof(fw->rseq_0_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->rseq_0_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRSEQ-1 Registers");
-	for (cnt = 0; cnt < sizeof(fw->rseq_1_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->rseq_1_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRSEQ-2 Registers");
-	for (cnt = 0; cnt < sizeof(fw->rseq_2_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->rseq_2_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nCommand DMA Registers");
-	for (cnt = 0; cnt < sizeof(fw->cmd_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->cmd_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRequest0 Queue DMA Channel Registers");
-	for (cnt = 0; cnt < sizeof(fw->req0_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->req0_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nResponse0 Queue DMA Channel Registers");
-	for (cnt = 0; cnt < sizeof(fw->resp0_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->resp0_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRequest1 Queue DMA Channel Registers");
-	for (cnt = 0; cnt < sizeof(fw->req1_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->req1_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nXMT0 Data DMA Registers");
-	for (cnt = 0; cnt < sizeof(fw->xmt0_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->xmt0_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nXMT1 Data DMA Registers");
-	for (cnt = 0; cnt < sizeof(fw->xmt1_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->xmt1_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nXMT2 Data DMA Registers");
-	for (cnt = 0; cnt < sizeof(fw->xmt2_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->xmt2_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nXMT3 Data DMA Registers");
-	for (cnt = 0; cnt < sizeof(fw->xmt3_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->xmt3_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nXMT4 Data DMA Registers");
-	for (cnt = 0; cnt < sizeof(fw->xmt4_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->xmt4_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nXMT Data DMA Common Registers");
-	for (cnt = 0; cnt < sizeof(fw->xmt_data_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->xmt_data_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRCV Thread 0 Data DMA Registers");
-	for (cnt = 0; cnt < sizeof(fw->rcvt0_data_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->rcvt0_data_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRCV Thread 1 Data DMA Registers");
-	for (cnt = 0; cnt < sizeof(fw->rcvt1_data_dma_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->rcvt1_data_dma_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nRISC GP Registers");
-	for (cnt = 0; cnt < sizeof(fw->risc_gp_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->risc_gp_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nLMC Registers");
-	for (cnt = 0; cnt < sizeof(fw->lmc_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->lmc_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nFPM Hardware Registers");
-	for (cnt = 0; cnt < sizeof(fw->fpm_hdw_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->fpm_hdw_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nFB Hardware Registers");
-	for (cnt = 0; cnt < sizeof(fw->fb_hdw_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->fb_hdw_reg[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nCode RAM");
-	for (cnt = 0; cnt < sizeof (fw->code_ram) / 4; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n%08x: ", cnt + 0x20000);
-		}
-		qla_uprintf(&uiter, "%08x ", fw->code_ram[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n\nExternal Memory");
-	ext_mem_cnt = ha->fw_memory_size - 0x100000 + 1;
-	for (cnt = 0; cnt < ext_mem_cnt; cnt++) {
-		if (cnt % 8 == 0) {
-			qla_uprintf(&uiter, "\n%08x: ", cnt + 0x100000);
-		}
-		qla_uprintf(&uiter, "%08x ", fw->ext_mem[cnt]);
-	}
-
-	qla_uprintf(&uiter, "\n[<==END] ISP Debug Dump");
-}
-
-
 /****************************************************************************/
 /*                         Driver Debug Functions.                          */
 /****************************************************************************/
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index ab6afea..ace6afd 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -176,9 +176,6 @@ #endif
 /*
  * Firmware Dump structure definition
  */
-#define FW_DUMP_SIZE_128K	0xBC000
-#define FW_DUMP_SIZE_512K	0x2FC000
-#define FW_DUMP_SIZE_1M		0x5FC000
 
 struct qla2300_fw_dump {
 	uint16_t hccr;
@@ -224,8 +221,6 @@ struct qla2100_fw_dump {
 	uint16_t risc_ram[0xf000];
 };
 
-#define FW_DUMP_SIZE_24XX	0x2B0000
-
 struct qla24xx_fw_dump {
 	uint32_t host_status;
 	uint32_t host_reg[32];
@@ -257,3 +252,39 @@ struct qla24xx_fw_dump {
 	uint32_t code_ram[0x2000];
 	uint32_t ext_mem[1];
 };
+
+#define EFT_NUM_BUFFERS		4
+#define EFT_BYTES_PER_BUFFER	0x4000
+#define EFT_SIZE		((EFT_BYTES_PER_BUFFER) * (EFT_NUM_BUFFERS))
+
+struct qla2xxx_fw_dump {
+	uint8_t signature[4];
+	uint32_t version;
+
+	uint32_t fw_major_version;
+	uint32_t fw_minor_version;
+	uint32_t fw_subminor_version;
+	uint32_t fw_attributes;
+
+	uint32_t vendor;
+	uint32_t device;
+	uint32_t subsystem_vendor;
+	uint32_t subsystem_device;
+
+	uint32_t fixed_size;
+	uint32_t mem_size;
+	uint32_t req_q_size;
+	uint32_t rsp_q_size;
+
+	uint32_t eft_size;
+	uint32_t eft_addr_l;
+	uint32_t eft_addr_h;
+
+	uint32_t header_size;
+
+	union {
+		struct qla2100_fw_dump isp21;
+		struct qla2300_fw_dump isp23;
+		struct qla24xx_fw_dump isp24;
+	} isp;
+};
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d6f6579..653e22e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -608,6 +608,7 @@ #define MBC_LUN_RESET			0x7E	/* Send LUN
 #define MBC_SERDES_PARAMS		0x10	/* Serdes Tx Parameters. */
 #define MBC_GET_IOCB_STATUS		0x12	/* Get IOCB status command. */
 #define MBC_GET_TIMEOUT_PARAMS		0x22	/* Get FW timeouts. */
+#define MBC_TRACE_CONTROL		0x27	/* Trace control command. */
 #define MBC_GEN_SYSTEM_ERROR		0x2a	/* Generate System Error. */
 #define MBC_SET_TIMEOUT_PARAMS		0x32	/* Set FW timeouts. */
 #define MBC_MID_INITIALIZE_FIRMWARE	0x48	/* MID Initialize firmware. */
@@ -618,6 +619,9 @@ #define MBC_SEND_RNFT_ELS		0x5e	/* Send 
 #define MBC_GET_LINK_PRIV_STATS		0x6d	/* Get link & private data. */
 #define MBC_SET_VENDOR_ID		0x76	/* Set Vendor ID. */
 
+#define TC_ENABLE			4
+#define TC_DISABLE			5
+
 /* Firmware return data sizes */
 #define FCAL_MAP_SIZE	128
 
@@ -1997,7 +2001,6 @@ struct isp_operations {
 		uint32_t);
 
 	void (*fw_dump) (struct scsi_qla_host *, int);
-	void (*ascii_fw_dump) (struct scsi_qla_host *);
 
 	int (*beacon_on) (struct scsi_qla_host *);
 	int (*beacon_off) (struct scsi_qla_host *);
@@ -2303,11 +2306,12 @@ #define RISC_START_ADDRESS_2400 0x100000
 	uint16_t	fw_seriallink_options24[4];
 
 	/* Firmware dump information. */
-	void		*fw_dump;
+	struct qla2xxx_fw_dump *fw_dump;
+	uint32_t	fw_dump_len;
 	int		fw_dumped;
 	int		fw_dump_reading;
-	char		*fw_dump_buffer;
-	int		fw_dump_buffer_len;
+	dma_addr_t	eft_dma;
+	void		*eft;
 
 	uint8_t		host_str[16];
 	uint32_t	pci_attr;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 164d53c..fec1e1c 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -51,6 +51,8 @@ extern int qla2x00_abort_isp(scsi_qla_ho
 extern void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
 extern void qla2x00_reg_remote_port(scsi_qla_host_t *, fc_port_t *);
 
+extern void qla2x00_alloc_fw_dump(scsi_qla_host_t *);
+
 /*
  * Global Data in qla_os.c source file.
  */
@@ -61,6 +63,7 @@ extern int qlport_down_retry;
 extern int ql2xplogiabsentdevice;
 extern int ql2xloginretrycount;
 extern int ql2xfdmienable;
+extern int ql2xallocfwdump;
 
 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
 
@@ -204,6 +207,9 @@ qla2x00_set_serdes_params(scsi_qla_host_
 extern int
 qla2x00_stop_firmware(scsi_qla_host_t *);
 
+extern int
+qla2x00_trace_control(scsi_qla_host_t *, uint16_t, dma_addr_t, uint16_t);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
@@ -254,9 +260,6 @@ extern int qla24xx_write_optrom_data(str
 extern void qla2100_fw_dump(scsi_qla_host_t *, int);
 extern void qla2300_fw_dump(scsi_qla_host_t *, int);
 extern void qla24xx_fw_dump(scsi_qla_host_t *, int);
-extern void qla2100_ascii_fw_dump(scsi_qla_host_t *);
-extern void qla2300_ascii_fw_dump(scsi_qla_host_t *);
-extern void qla24xx_ascii_fw_dump(scsi_qla_host_t *);
 extern void qla2x00_dump_regs(scsi_qla_host_t *);
 extern void qla2x00_dump_buffer(uint8_t *, uint32_t);
 extern void qla2x00_print_scsi_cmd(struct scsi_cmnd *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index aef093d..880de6f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -770,29 +770,104 @@ qla24xx_chip_diag(scsi_qla_host_t *ha)
 	return rval;
 }
 
-static void
+void
 qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 {
-	uint32_t dump_size = 0;
+	int rval;
+	uint32_t dump_size, fixed_size, mem_size, req_q_size, rsp_q_size,
+	    eft_size;
+	dma_addr_t eft_dma;
+	void *eft;
+
+	if (ha->fw_dump) {
+		qla_printk(KERN_WARNING, ha,
+		    "Firmware dump previously allocated.\n");
+		return;
+	}
 
 	ha->fw_dumped = 0;
+	fixed_size = mem_size = eft_size = 0;
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		dump_size = sizeof(struct qla2100_fw_dump);
+		fixed_size = sizeof(struct qla2100_fw_dump);
 	} else if (IS_QLA23XX(ha)) {
-		dump_size = sizeof(struct qla2300_fw_dump);
-		dump_size += (ha->fw_memory_size - 0x11000) * sizeof(uint16_t);
-        } else if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
-		dump_size = sizeof(struct qla24xx_fw_dump);
-		dump_size += (ha->fw_memory_size - 0x100000) * sizeof(uint32_t);
+		fixed_size = offsetof(struct qla2300_fw_dump, data_ram);
+		mem_size = (ha->fw_memory_size - 0x11000 + 1) *
+		    sizeof(uint16_t);
+	} else if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+		fixed_size = offsetof(struct qla24xx_fw_dump, ext_mem);
+		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
+		    sizeof(uint32_t);
+
+		/* Allocate memory for Extended Trace Buffer. */
+		eft = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &eft_dma,
+		    GFP_KERNEL);
+		if (!eft) {
+			qla_printk(KERN_WARNING, ha, "Unable to allocate "
+			    "(%d KB) for EFT.\n", EFT_SIZE / 1024);
+			goto cont_alloc;
+		}
+
+		rval = qla2x00_trace_control(ha, TC_ENABLE, eft_dma,
+		    EFT_NUM_BUFFERS);
+		if (rval) {
+			qla_printk(KERN_WARNING, ha, "Unable to initialize "
+			    "EFT (%d).\n", rval);
+			dma_free_coherent(&ha->pdev->dev, EFT_SIZE, eft,
+			    eft_dma);
+			goto cont_alloc;
+		}
+
+		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for EFT...\n",
+		    EFT_SIZE / 1024);
+
+		eft_size = EFT_SIZE;
+		memset(eft, 0, eft_size);
+		ha->eft_dma = eft_dma;
+		ha->eft = eft;
 	}
+cont_alloc:
+	req_q_size = ha->request_q_length * sizeof(request_t);
+	rsp_q_size = ha->response_q_length * sizeof(response_t);
+
+	dump_size = offsetof(struct qla2xxx_fw_dump, isp);
+	dump_size += fixed_size + mem_size + req_q_size + rsp_q_size +
+	    eft_size;
 
 	ha->fw_dump = vmalloc(dump_size);
-	if (ha->fw_dump)
-		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for firmware "
-		    "dump...\n", dump_size / 1024);
-	else
+	if (!ha->fw_dump) {
 		qla_printk(KERN_WARNING, ha, "Unable to allocate (%d KB) for "
 		    "firmware dump!!!\n", dump_size / 1024);
+
+		if (ha->eft) {
+			dma_free_coherent(&ha->pdev->dev, eft_size, ha->eft,
+			    ha->eft_dma);
+			ha->eft = NULL;
+			ha->eft_dma = 0;
+		}
+		return;
+	}
+
+	qla_printk(KERN_INFO, ha, "Allocated (%d KB) for firmware dump...\n",
+	    dump_size / 1024);
+
+	ha->fw_dump_len = dump_size;
+	ha->fw_dump->signature[0] = 'Q';
+	ha->fw_dump->signature[1] = 'L';
+	ha->fw_dump->signature[2] = 'G';
+	ha->fw_dump->signature[3] = 'C';
+	ha->fw_dump->version = __constant_htonl(1);
+
+	ha->fw_dump->fixed_size = htonl(fixed_size);
+	ha->fw_dump->mem_size = htonl(mem_size);
+	ha->fw_dump->req_q_size = htonl(req_q_size);
+	ha->fw_dump->rsp_q_size = htonl(rsp_q_size);
+
+	ha->fw_dump->eft_size = htonl(eft_size);
+	ha->fw_dump->eft_addr_l = htonl(LSD(ha->eft_dma));
+	ha->fw_dump->eft_addr_h = htonl(MSD(ha->eft_dma));
+
+	ha->fw_dump->header_size =
+	    htonl(offsetof(struct qla2xxx_fw_dump, isp));
 }
 
 /**
@@ -810,8 +885,6 @@ qla2x00_resize_request_q(scsi_qla_host_t
 	dma_addr_t request_dma;
 	request_t *request_ring;
 
-	qla2x00_alloc_fw_dump(ha);
-
 	/* Valid only on recent ISPs. */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return;
@@ -883,6 +956,9 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 				    &ha->fw_subminor_version,
 				    &ha->fw_attributes, &ha->fw_memory_size);
 				qla2x00_resize_request_q(ha);
+
+				if (ql2xallocfwdump)
+					qla2x00_alloc_fw_dump(ha);
 			}
 		} else {
 			DEBUG2(printk(KERN_INFO
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d6cb3bd..39ddd38 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2460,3 +2460,45 @@ qla2x00_stop_firmware(scsi_qla_host_t *h
 
 	return rval;
 }
+
+int
+qla2x00_trace_control(scsi_qla_host_t *ha, uint16_t ctrl, dma_addr_t eft_dma,
+    uint16_t buffers)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_TRACE_CONTROL;
+	mcp->mb[1] = ctrl;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	if (ctrl == TC_ENABLE) {
+		mcp->mb[2] = LSW(eft_dma);
+		mcp->mb[3] = MSW(eft_dma);
+		mcp->mb[4] = LSW(MSD(eft_dma));
+		mcp->mb[5] = MSW(MSD(eft_dma));
+		mcp->mb[6] = buffers;
+		mcp->mb[7] = buffers;
+		mcp->out_mb |= MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2;
+	}
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
+		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+	}
+
+	return rval;
+}
+
+
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ccaad0b..c16154c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -54,6 +54,13 @@ module_param(ql2xloginretrycount, int, S
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
+int ql2xallocfwdump = 1;
+module_param(ql2xallocfwdump, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xallocfwdump,
+		"Option to enable allocation of memory for a firmware dump "
+		"during HBA initialization.  Memory allocation requirements "
+		"vary by ISP type.  Default is 1 - allocate memory.");
+
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
@@ -1405,7 +1412,6 @@ static int qla2x00_probe_one(struct pci_
 	ha->isp_ops.read_nvram		= qla2x00_read_nvram_data;
 	ha->isp_ops.write_nvram		= qla2x00_write_nvram_data;
 	ha->isp_ops.fw_dump		= qla2100_fw_dump;
-	ha->isp_ops.ascii_fw_dump	= qla2100_ascii_fw_dump;
 	ha->isp_ops.read_optrom		= qla2x00_read_optrom_data;
 	ha->isp_ops.write_optrom	= qla2x00_write_optrom_data;
 	if (IS_QLA2100(ha)) {
@@ -1432,7 +1438,6 @@ static int qla2x00_probe_one(struct pci_
 		ha->isp_ops.pci_config = qla2300_pci_config;
 		ha->isp_ops.intr_handler = qla2300_intr_handler;
 		ha->isp_ops.fw_dump = qla2300_fw_dump;
-		ha->isp_ops.ascii_fw_dump = qla2300_ascii_fw_dump;
 		ha->isp_ops.beacon_on = qla2x00_beacon_on;
 		ha->isp_ops.beacon_off = qla2x00_beacon_off;
 		ha->isp_ops.beacon_blink = qla2x00_beacon_blink;
@@ -1469,7 +1474,6 @@ static int qla2x00_probe_one(struct pci_
 		ha->isp_ops.read_nvram = qla24xx_read_nvram_data;
 		ha->isp_ops.write_nvram = qla24xx_write_nvram_data;
 		ha->isp_ops.fw_dump = qla24xx_fw_dump;
-		ha->isp_ops.ascii_fw_dump = qla24xx_ascii_fw_dump;
 		ha->isp_ops.read_optrom	= qla24xx_read_optrom_data;
 		ha->isp_ops.write_optrom = qla24xx_write_optrom_data;
 		ha->isp_ops.beacon_on = qla24xx_beacon_on;
@@ -1678,6 +1682,9 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 		kthread_stop(t);
 	}
 
+	if (ha->eft)
+		qla2x00_trace_control(ha, TC_DISABLE, 0, 0);
+
 	/* Stop currently executing firmware. */
 	qla2x00_stop_firmware(ha);
 
@@ -2012,6 +2019,13 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	/* free sp pool */
 	qla2x00_free_sp_pool(ha);
 
+	if (ha->fw_dump) {
+		if (ha->eft)
+			dma_free_coherent(&ha->pdev->dev,
+			    ntohl(ha->fw_dump->eft_size), ha->eft, ha->eft_dma);
+		vfree(ha->fw_dump);
+	}
+
 	if (ha->sns_cmd)
 		dma_free_coherent(&ha->pdev->dev, sizeof(struct sns_cmd_pkt),
 		    ha->sns_cmd, ha->sns_cmd_dma);
@@ -2043,6 +2057,8 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 		    (ha->request_q_length + 1) * sizeof(request_t),
 		    ha->request_ring, ha->request_dma);
 
+	ha->eft = NULL;
+	ha->eft_dma = 0;
 	ha->sns_cmd = NULL;
 	ha->sns_cmd_dma = 0;
 	ha->ct_sns = NULL;
@@ -2071,13 +2087,9 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	}
 	INIT_LIST_HEAD(&ha->fcports);
 
-	vfree(ha->fw_dump);
-	vfree(ha->fw_dump_buffer);
-
 	ha->fw_dump = NULL;
 	ha->fw_dumped = 0;
 	ha->fw_dump_reading = 0;
-	ha->fw_dump_buffer = NULL;
 
 	vfree(ha->optrom_buffer);
 }
-- 
1.4.1.rc1.gf603


