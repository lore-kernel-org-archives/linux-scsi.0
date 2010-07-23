From: giridhar.malavali@qlogic.com
Subject: [PATCH 13/17] qla2xxx: Updates for ISP82xx.
Date: Fri, 23 Jul 2010 15:28:34 +0500
Message-ID: <1279880918-62876-14-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47963 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755708Ab0GWJ7r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:47 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Re-organized and cleaned up the ISP82xx specific code.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    4 -
 drivers/scsi/qla2xxx/qla_mbx.c |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c  |  320 +++++-----------------------------------
 drivers/scsi/qla2xxx/qla_nx.h  |    3 +-
 4 files changed, 42 insertions(+), 289 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 84441e8..8b0a8ca 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -508,16 +508,12 @@ extern int qla82xx_pci_mem_read_2M(struct qla_hw_data *, u64, void *, int);
 extern int qla82xx_pci_mem_write_2M(struct qla_hw_data *, u64, void *, int);
 extern char *qla82xx_pci_info_str(struct scsi_qla_host *, char *);
 extern int qla82xx_pci_region_offset(struct pci_dev *, int);
-extern int qla82xx_pci_region_len(struct pci_dev *, int);
 extern int qla82xx_iospace_config(struct qla_hw_data *);
 
 /* Initialization related functions */
 extern void qla82xx_reset_chip(struct scsi_qla_host *);
 extern void qla82xx_config_rings(struct scsi_qla_host *);
-extern int qla82xx_nvram_config(struct scsi_qla_host *);
 extern int qla82xx_pinit_from_rom(scsi_qla_host_t *);
-extern int qla82xx_load_firmware(scsi_qla_host_t *);
-extern int qla82xx_reset_hw(scsi_qla_host_t *);
 extern void qla82xx_watchdog(scsi_qla_host_t *);
 
 /* Firmware and flash related functions */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2f39e30..02a4d35 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4111,7 +4111,7 @@ qla82xx_mbx_intr_enable(scsi_qla_host_t *vha)
 		"%s(%ld): entered.\n", __func__, vha->host_no));
 
 	memset(mcp, 0, sizeof(mbx_cmd_t));
-	mcp->mb[0] = MBC_TOGGLE_INTR;
+	mcp->mb[0] = MBC_TOGGLE_INTERRUPT;
 	mcp->mb[1] = 1;
 
 	mcp->out_mb = MBX_1|MBX_0;
@@ -4147,7 +4147,7 @@ qla82xx_mbx_intr_disable(scsi_qla_host_t *vha)
 		"%s(%ld): entered.\n", __func__, vha->host_no));
 
 	memset(mcp, 0, sizeof(mbx_cmd_t));
-	mcp->mb[0] = MBC_TOGGLE_INTR;
+	mcp->mb[0] = MBC_TOGGLE_INTERRUPT;
 	mcp->mb[1] = 0;
 
 	mcp->out_mb = MBX_1|MBX_0;
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index e3e3ebd..4299df2 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -797,179 +797,6 @@ qla82xx_pci_mem_write_direct(struct qla_hw_data *ha,
 	return ret;
 }
 
-int
-qla82xx_wrmem(struct qla_hw_data *ha, u64 off, void *data, int size)
-{
-	int i, j, ret = 0, loop, sz[2], off0;
-	u32 temp;
-	u64 off8, mem_crb, tmpw, word[2] = {0, 0};
-#define MAX_CTL_CHECK   1000
-	/*
-	 * If not MN, go check for MS or invalid.
-	 */
-	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX) {
-		mem_crb = QLA82XX_CRB_QDR_NET;
-	} else {
-		mem_crb = QLA82XX_CRB_DDR_NET;
-		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
-			return qla82xx_pci_mem_write_direct(ha, off,
-			    data, size);
-	}
-
-	off8 = off & 0xfffffff8;
-	off0 = off & 0x7;
-	sz[0] = (size < (8 - off0)) ? size : (8 - off0);
-	sz[1] = size - sz[0];
-	loop = ((off0 + size - 1) >> 3) + 1;
-
-	if ((size != 8) || (off0 != 0))  {
-		for (i = 0; i < loop; i++) {
-			if (qla82xx_rdmem(ha, off8 + (i << 3), &word[i], 8))
-				return -1;
-		}
-	}
-
-	switch (size) {
-	case 1:
-		tmpw = *((u8 *)data);
-		break;
-	case 2:
-		tmpw = *((u16 *)data);
-		break;
-	case 4:
-		tmpw = *((u32 *)data);
-		break;
-	case 8:
-	default:
-		tmpw = *((u64 *)data);
-		break;
-	}
-
-	word[0] &= ~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
-	word[0] |= tmpw << (off0 * 8);
-
-	if (loop == 2) {
-		word[1] &= ~(~0ULL << (sz[1] * 8));
-		word[1] |= tmpw >> (sz[0] * 8);
-	}
-
-	for (i = 0; i < loop; i++) {
-		temp = off8 + (i << 3);
-		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_LO, temp);
-		temp = 0;
-		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_HI, temp);
-		temp = word[i] & 0xffffffff;
-		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_LO, temp);
-		temp = (word[i] >> 32) & 0xffffffff;
-		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_HI, temp);
-		temp = MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
-		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_CTRL, temp);
-		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
-		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_CTRL, temp);
-
-		for (j = 0; j < MAX_CTL_CHECK; j++) {
-			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
-			if ((temp & MIU_TA_CTL_BUSY) == 0)
-				break;
-		}
-
-		if (j >= MAX_CTL_CHECK) {
-			qla_printk(KERN_WARNING, ha,
-				"%s: Fail to write through agent\n",
-				QLA2XXX_DRIVER_NAME);
-			ret = -1;
-			break;
-		}
-	}
-	return ret;
-}
-
-int
-qla82xx_rdmem(struct qla_hw_data *ha, u64 off, void *data, int size)
-{
-	int i, j = 0, k, start, end, loop, sz[2], off0[2];
-	u32 temp;
-	u64 off8, val, mem_crb, word[2] = {0, 0};
-#define MAX_CTL_CHECK   1000
-
-	/*
-	 * If not MN, go check for MS or invalid.
-	 */
-	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX)
-		mem_crb = QLA82XX_CRB_QDR_NET;
-	else {
-		mem_crb = QLA82XX_CRB_DDR_NET;
-		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
-			return qla82xx_pci_mem_read_direct(ha, off,
-				data, size);
-	}
-
-	off8 = off & 0xfffffff8;
-	off0[0] = off & 0x7;
-	off0[1] = 0;
-	sz[0] = (size < (8 - off0[0])) ? size : (8 - off0[0]);
-	sz[1] = size - sz[0];
-	loop = ((off0[0] + size - 1) >> 3) + 1;
-
-	for (i = 0; i < loop; i++) {
-		temp = off8 + (i << 3);
-		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_LO, temp);
-		temp = 0;
-		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_HI, temp);
-		temp = MIU_TA_CTL_ENABLE;
-		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
-		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE;
-		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
-
-		for (j = 0; j < MAX_CTL_CHECK; j++) {
-			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
-			if ((temp & MIU_TA_CTL_BUSY) == 0)
-				break;
-		}
-
-		if (j >= MAX_CTL_CHECK) {
-			qla_printk(KERN_INFO, ha,
-				"%s: Fail to read through agent\n",
-				QLA2XXX_DRIVER_NAME);
-			break;
-		}
-
-		start = off0[i] >> 2;
-		end   = (off0[i] + sz[i] - 1) >> 2;
-		for (k = start; k <= end; k++) {
-			temp = qla82xx_rd_32(ha,
-			    mem_crb + MIU_TEST_AGT_RDDATA(k));
-			word[i] |= ((u64)temp << (32 * k));
-		}
-	}
-
-	if (j >= MAX_CTL_CHECK)
-		return -1;
-
-	if (sz[0] == 8) {
-		val = word[0];
-	} else {
-		val = ((word[0] >> (off0[0] * 8)) & (~(~0ULL << (sz[0] * 8)))) |
-			((word[1] & (~(~0ULL << (sz[1] * 8)))) << (sz[0] * 8));
-	}
-
-	switch (size) {
-	case 1:
-		*(u8  *)data = val;
-		break;
-	case 2:
-		*(u16 *)data = val;
-		break;
-	case 4:
-		*(u32 *)data = val;
-		break;
-	case 8:
-		*(u64 *)data = val;
-		break;
-	}
-	return 0;
-}
-
 #define MTU_FUDGE_FACTOR 100
 unsigned long qla82xx_decode_crb_addr(unsigned long addr)
 {
@@ -1347,11 +1174,6 @@ int qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 			continue;
 		}
 
-		if (off == (QLA82XX_CRB_PEG_NET_1 + 0x18)) {
-			if (!QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision))
-				buf[i].data = 0x1020;
-		}
-
 		qla82xx_wr_32(ha, off, buf[i].data);
 
 		/* ISP requires much bigger delay to settle down,
@@ -1429,12 +1251,8 @@ qla82xx_fw_load_from_flash(struct qla_hw_data *ha)
 	}
 	udelay(100);
 	read_lock(&ha->hw_lock);
-	if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
-		qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x18, 0x1020);
-		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001e);
-	} else {
-		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001d);
-	}
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x18, 0x1020);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001e);
 	read_unlock(&ha->hw_lock);
 	return 0;
 }
@@ -1461,17 +1279,10 @@ qla82xx_pci_mem_read_2M(struct qla_hw_data *ha,
 			    off, data, size);
 	}
 
-	if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
-		off8 = off & 0xfffffff0;
-		off0[0] = off & 0xf;
-		sz[0] = (size < (16 - off0[0])) ? size : (16 - off0[0]);
-		shift_amount = 4;
-	} else {
-		off8 = off & 0xfffffff8;
-		off0[0] = off & 0x7;
-		sz[0] = (size < (8 - off0[0])) ? size : (8 - off0[0]);
-		shift_amount = 4;
-	}
+	off8 = off & 0xfffffff0;
+	off0[0] = off & 0xf;
+	sz[0] = (size < (16 - off0[0])) ? size : (16 - off0[0]);
+	shift_amount = 4;
 	loop = ((off0[0] + size - 1) >> shift_amount) + 1;
 	off0[1] = 0;
 	sz[1] = size - sz[0];
@@ -1551,7 +1362,7 @@ qla82xx_pci_mem_write_2M(struct qla_hw_data *ha,
 		u64 off, void *data, int size)
 {
 	int i, j, ret = 0, loop, sz[2], off0;
-	int scale, shift_amount, p3p, startword;
+	int scale, shift_amount, startword;
 	uint32_t temp;
 	uint64_t off8, mem_crb, tmpw, word[2] = {0, 0};
 
@@ -1571,28 +1382,16 @@ qla82xx_pci_mem_write_2M(struct qla_hw_data *ha,
 	sz[0] = (size < (8 - off0)) ? size : (8 - off0);
 	sz[1] = size - sz[0];
 
-	if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
-		off8 = off & 0xfffffff0;
-		loop = (((off & 0xf) + size - 1) >> 4) + 1;
-		shift_amount = 4;
-		scale = 2;
-		p3p = 1;
-		startword = (off & 0xf)/8;
-	} else {
-		off8 = off & 0xfffffff8;
-		loop = ((off0 + size - 1) >> 3) + 1;
-		shift_amount = 3;
-		scale = 1;
-		p3p = 0;
-		startword = 0;
-	}
-
-	if (p3p || (size != 8) || (off0 != 0)) {
-		for (i = 0; i < loop; i++) {
-			if (qla82xx_pci_mem_read_2M(ha, off8 +
-			    (i << shift_amount), &word[i * scale], 8))
-				return -1;
-		}
+	off8 = off & 0xfffffff0;
+	loop = (((off & 0xf) + size - 1) >> 4) + 1;
+	shift_amount = 4;
+	scale = 2;
+	startword = (off & 0xf)/8;
+
+	for (i = 0; i < loop; i++) {
+		if (qla82xx_pci_mem_read_2M(ha, off8 +
+		    (i << shift_amount), &word[i * scale], 8))
+			return -1;
 	}
 
 	switch (size) {
@@ -1611,26 +1410,16 @@ qla82xx_pci_mem_write_2M(struct qla_hw_data *ha,
 		break;
 	}
 
-	if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
-		if (sz[0] == 8) {
-			word[startword] = tmpw;
-		} else {
-			word[startword] &=
-				~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
-			word[startword] |= tmpw << (off0 * 8);
-		}
-		if (sz[1] != 0) {
-			word[startword+1] &= ~(~0ULL << (sz[1] * 8));
-			word[startword+1] |= tmpw >> (sz[0] * 8);
-		}
+	if (sz[0] == 8) {
+		word[startword] = tmpw;
 	} else {
-		word[startword] &= ~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
+		word[startword] &=
+			~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
 		word[startword] |= tmpw << (off0 * 8);
-
-		if (loop == 2) {
-			word[1] &= ~(~0ULL << (sz[1] * 8));
-			word[1] |= tmpw >> (sz[0] * 8);
-		}
+	}
+	if (sz[1] != 0) {
+		word[startword+1] &= ~(~0ULL << (sz[1] * 8));
+		word[startword+1] |= tmpw >> (sz[0] * 8);
 	}
 
 	/*
@@ -1647,14 +1436,12 @@ qla82xx_pci_mem_write_2M(struct qla_hw_data *ha,
 		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_LO, temp);
 		temp = (word[i * scale] >> 32) & 0xffffffff;
 		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_HI, temp);
-		if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
-			temp = word[i*scale + 1] & 0xffffffff;
-			qla82xx_wr_32(ha, mem_crb +
-			    MIU_TEST_AGT_WRDATA_UPPER_LO, temp);
-			temp = (word[i*scale + 1] >> 32) & 0xffffffff;
-			qla82xx_wr_32(ha, mem_crb +
-			    MIU_TEST_AGT_WRDATA_UPPER_HI, temp);
-		}
+		temp = word[i*scale + 1] & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb +
+		    MIU_TEST_AGT_WRDATA_UPPER_LO, temp);
+		temp = (word[i*scale + 1] >> 32) & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb +
+		    MIU_TEST_AGT_WRDATA_UPPER_HI, temp);
 
 		temp = MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
 		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
@@ -1804,22 +1591,6 @@ int qla82xx_pci_region_offset(struct pci_dev *pdev, int region)
 	return val;
 }
 
-int qla82xx_pci_region_len(struct pci_dev *pdev, int region)
-{
-	unsigned long val = 0;
-	u32 control;
-	switch (region) {
-	case 0:
-		pci_read_config_dword(pdev, QLA82XX_PCI_REG_MSIX_TBL, &control);
-		val = control;
-		break;
-	case 1:
-		val = pci_resource_len(pdev, 0) -
-		    qla82xx_pci_region_offset(pdev, 1);
-		break;
-	}
-	return val;
-}
 
 int
 qla82xx_iospace_config(struct qla_hw_data *ha)
@@ -1941,12 +1712,6 @@ void qla82xx_config_rings(struct scsi_qla_host *vha)
 	icb->response_q_address[0] = cpu_to_le32(LSD(rsp->dma));
 	icb->response_q_address[1] = cpu_to_le32(MSD(rsp->dma));
 
-	icb->version = 1;
-	icb->frame_payload_size = 2112;
-	icb->execution_throttle = 8;
-	icb->exchange_count = 128;
-	icb->login_retry_count = 8;
-
 	WRT_REG_DWORD((unsigned long  __iomem *)&reg->req_q_out[0], 0);
 	WRT_REG_DWORD((unsigned long  __iomem *)&reg->rsp_q_in[0], 0);
 	WRT_REG_DWORD((unsigned long  __iomem *)&reg->rsp_q_out[0], 0);
@@ -1999,11 +1764,8 @@ int qla82xx_fw_load_from_blob(struct qla_hw_data *ha)
 	qla82xx_wr_32(ha, QLA82XX_CAM_RAM(0x1fc), QLA82XX_BDINFO_MAGIC);
 
 	read_lock(&ha->hw_lock);
-	if (QLA82XX_IS_REVISION_P3PLUS(ha->chip_revision)) {
-		qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x18, 0x1020);
-		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001e);
-	} else
-		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001d);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x18, 0x1020);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001e);
 	read_unlock(&ha->hw_lock);
 	return 0;
 }
@@ -2256,8 +2018,6 @@ qla82xx_intr_handler(int irq, void *dev_id)
 
 		if (RD_REG_DWORD(&reg->host_int)) {
 			stat = RD_REG_DWORD(&reg->host_status);
-			if ((stat & HSRX_RISC_INT) == 0)
-				break;
 
 			switch (stat & 0xff) {
 			case 0x1:
@@ -2332,8 +2092,6 @@ qla82xx_msix_default(int irq, void *dev_id)
 	do {
 		if (RD_REG_DWORD(&reg->host_int)) {
 			stat = RD_REG_DWORD(&reg->host_status);
-			if ((stat & HSRX_RISC_INT) == 0)
-				break;
 
 			switch (stat & 0xff) {
 			case 0x1:
@@ -2583,12 +2341,6 @@ int qla82xx_load_fw(scsi_qla_host_t *vha)
 	struct fw_blob *blob;
 	struct qla_hw_data *ha = vha->hw;
 
-	/* Put both the PEG CMD and RCV PEG to default state
-	 * of 0 before resetting the hardware
-	 */
-	qla82xx_wr_32(ha, CRB_CMDPEG_STATE, 0);
-	qla82xx_wr_32(ha, CRB_RCVPEG_STATE, 0);
-
 	if (qla82xx_pinit_from_rom(vha) != QLA_SUCCESS) {
 		qla_printk(KERN_ERR, ha,
 			"%s: Error during CRB Initialization\n", __func__);
@@ -2669,6 +2421,12 @@ qla82xx_start_firmware(scsi_qla_host_t *vha)
 	/* scrub dma mask expansion register */
 	qla82xx_wr_32(ha, CRB_DMA_SHIFT, 0x55555555);
 
+	/* Put both the PEG CMD and RCV PEG to default state
+	 * of 0 before resetting the hardware
+	 */
+	qla82xx_wr_32(ha, CRB_CMDPEG_STATE, 0);
+	qla82xx_wr_32(ha, CRB_RCVPEG_STATE, 0);
+
 	/* Overwrite stale initialization register values */
 	qla82xx_wr_32(ha, QLA82XX_PEG_HALT_STATUS1, 0);
 	qla82xx_wr_32(ha, QLA82XX_PEG_HALT_STATUS2, 0);
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 9a9127e..420e077 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -816,7 +816,6 @@ struct qla82xx_uri_data_desc{
 #define QLA82XX_FLASH_ROMIMAGE		4
 #define QLA82XX_UNKNOWN_ROMIMAGE	0xff
 
-#define QLA82XX_IS_REVISION_P3PLUS(_rev_)	((_rev_) >= 0x50)
 #define MIU_TEST_AGT_WRDATA_UPPER_LO		(0x0b0)
 #define	MIU_TEST_AGT_WRDATA_UPPER_HI		(0x0b4)
 
@@ -887,7 +886,7 @@ struct ct6_dsd {
 	struct list_head dsd_list;
 };
 
-#define MBC_TOGGLE_INTR			0x10
+#define MBC_TOGGLE_INTERRUPT	0x10
 
 /* Flash  offset */
 #define FLT_REG_BOOTLOAD_82XX	0x72
-- 
1.6.0.2

