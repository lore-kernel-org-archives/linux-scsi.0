From: madhu.iyengar@qlogic.com
Subject: [PATCH 05/10] qla2xxx: Cleanup some dead-code and make some functions static.
Date: Fri,  3 Sep 2010 15:20:52 -0700
Message-ID: <1283552457-4497-6-git-send-email-madhu.iyengar@qlogic.com>
References: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39331 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753476Ab0ICW06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:58 -0400
In-Reply-To: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |   11 --
 drivers/scsi/qla2xxx/qla_nx.c  |  385 ++++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_nx.h  |    5 +
 3 files changed, 202 insertions(+), 199 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 4edfc73..967bc92 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -501,7 +501,6 @@ extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 /* PCI related functions */
 extern int qla82xx_pci_config(struct scsi_qla_host *);
 extern int qla82xx_pci_mem_read_2M(struct qla_hw_data *, u64, void *, int);
-extern int qla82xx_pci_mem_write_2M(struct qla_hw_data *, u64, void *, int);
 extern char *qla82xx_pci_info_str(struct scsi_qla_host *, char *);
 extern int qla82xx_pci_region_offset(struct pci_dev *, int);
 extern int qla82xx_iospace_config(struct qla_hw_data *);
@@ -509,7 +508,6 @@ extern int qla82xx_iospace_config(struct qla_hw_data *);
 /* Initialization related functions */
 extern void qla82xx_reset_chip(struct scsi_qla_host *);
 extern void qla82xx_config_rings(struct scsi_qla_host *);
-extern int qla82xx_pinit_from_rom(scsi_qla_host_t *);
 extern void qla82xx_watchdog(scsi_qla_host_t *);
 extern int qla82xx_start_firmware(scsi_qla_host_t *);
 
@@ -534,26 +532,17 @@ extern irqreturn_t qla82xx_msix_default(int, void *);
 extern irqreturn_t qla82xx_msix_rsp_q(int, void *);
 extern void qla82xx_enable_intrs(struct qla_hw_data *);
 extern void qla82xx_disable_intrs(struct qla_hw_data *);
-extern void qla82xx_mbx_completion(scsi_qla_host_t *, uint16_t);
 extern void qla82xx_poll(int, void *);
 extern void qla82xx_init_flags(struct qla_hw_data *);
 
 /* ISP 8021 hardware related */
 extern void qla82xx_set_drv_active(scsi_qla_host_t *);
-extern int qla82xx_crb_win_lock(struct qla_hw_data *);
 extern void qla82xx_crb_win_unlock(struct qla_hw_data *);
-extern int qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *, ulong *);
 extern int qla82xx_wr_32(struct qla_hw_data *, ulong, u32);
 extern int qla82xx_rd_32(struct qla_hw_data *, ulong);
 extern int qla82xx_rdmem(struct qla_hw_data *, u64, void *, int);
 extern int qla82xx_wrmem(struct qla_hw_data *, u64, void *, int);
-extern int qla82xx_check_for_bad_spd(struct qla_hw_data *);
-extern int qla82xx_load_fw(scsi_qla_host_t *);
-extern int qla82xx_rom_lock(struct qla_hw_data *);
 extern void qla82xx_rom_unlock(struct qla_hw_data *);
-extern int qla82xx_rom_fast_read(struct qla_hw_data *, int , int *);
-extern int qla82xx_do_rom_fast_read(struct qla_hw_data *, int, int *);
-extern unsigned long qla82xx_decode_crb_addr(unsigned long);
 
 /* ISP 8021 IDC */
 extern void qla82xx_clear_drv_active(struct qla_hw_data *);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 66f0aee..c5ac876 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -403,6 +403,54 @@ qla82xx_pci_set_crbwindow(struct qla_hw_data *ha, u64 off)
 	return off;
 }
 
+static int
+qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong *off)
+{
+	struct crb_128M_2M_sub_block_map *m;
+
+	if (*off >= QLA82XX_CRB_MAX)
+		return -1;
+
+	if (*off >= QLA82XX_PCI_CAMQM && (*off < QLA82XX_PCI_CAMQM_2M_END)) {
+		*off = (*off - QLA82XX_PCI_CAMQM) +
+		    QLA82XX_PCI_CAMQM_2M_BASE + ha->nx_pcibase;
+		return 0;
+	}
+
+	if (*off < QLA82XX_PCI_CRBSPACE)
+		return -1;
+
+	*off -= QLA82XX_PCI_CRBSPACE;
+
+	/* Try direct map */
+	m = &crb_128M_2M_map[CRB_BLK(*off)].sub_block[CRB_SUBBLK(*off)];
+
+	if (m->valid && (m->start_128M <= *off) && (m->end_128M > *off)) {
+		*off = *off + m->start_2M - m->start_128M + ha->nx_pcibase;
+		return 0;
+	}
+	/* Not in direct map, use crb window */
+	return 1;
+}
+
+#define CRB_WIN_LOCK_TIMEOUT 100000000
+static int qla82xx_crb_win_lock(struct qla_hw_data *ha)
+{
+	int done = 0, timeout = 0;
+
+	while (!done) {
+		/* acquire semaphore3 from PCI HW block */
+		done = qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_LOCK));
+		if (done == 1)
+			break;
+		if (timeout >= CRB_WIN_LOCK_TIMEOUT)
+			return -1;
+		timeout++;
+	}
+	qla82xx_wr_32(ha, QLA82XX_CRB_WIN_LOCK_ID, ha->portnum);
+	return 0;
+}
+
 int
 qla82xx_wr_32(struct qla_hw_data *ha, ulong off, u32 data)
 {
@@ -453,24 +501,6 @@ qla82xx_rd_32(struct qla_hw_data *ha, ulong off)
 	return data;
 }
 
-#define CRB_WIN_LOCK_TIMEOUT 100000000
-int qla82xx_crb_win_lock(struct qla_hw_data *ha)
-{
-	int done = 0, timeout = 0;
-
-	while (!done) {
-		/* acquire semaphore3 from PCI HW block */
-		done = qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_LOCK));
-		if (done == 1)
-			break;
-		if (timeout >= CRB_WIN_LOCK_TIMEOUT)
-			return -1;
-		timeout++;
-	}
-	qla82xx_wr_32(ha, QLA82XX_CRB_WIN_LOCK_ID, ha->portnum);
-	return 0;
-}
-
 #define IDC_LOCK_TIMEOUT 100000000
 int qla82xx_idc_lock(struct qla_hw_data *ha)
 {
@@ -504,36 +534,6 @@ void qla82xx_idc_unlock(struct qla_hw_data *ha)
 	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM5_UNLOCK));
 }
 
-int
-qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong *off)
-{
-	struct crb_128M_2M_sub_block_map *m;
-
-	if (*off >= QLA82XX_CRB_MAX)
-		return -1;
-
-	if (*off >= QLA82XX_PCI_CAMQM && (*off < QLA82XX_PCI_CAMQM_2M_END)) {
-		*off = (*off - QLA82XX_PCI_CAMQM) +
-		    QLA82XX_PCI_CAMQM_2M_BASE + ha->nx_pcibase;
-		return 0;
-	}
-
-	if (*off < QLA82XX_PCI_CRBSPACE)
-		return -1;
-
-	*off -= QLA82XX_PCI_CRBSPACE;
-
-	/* Try direct map */
-	m = &crb_128M_2M_map[CRB_BLK(*off)].sub_block[CRB_SUBBLK(*off)];
-
-	if (m->valid && (m->start_128M <= *off) && (m->end_128M > *off)) {
-		*off = *off + m->start_2M - m->start_128M + ha->nx_pcibase;
-		return 0;
-	}
-	/* Not in direct map, use crb window */
-	return 1;
-}
-
 /*  PCI Windowing for DDR regions.  */
 #define QLA82XX_ADDR_IN_RANGE(addr, low, high) \
 	(((addr) <= (high)) && ((addr) >= (low)))
@@ -557,7 +557,7 @@ qla82xx_pci_mem_bound_check(struct qla_hw_data *ha,
 
 int qla82xx_pci_set_window_warning_count;
 
-unsigned long
+static unsigned long
 qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
 {
 	int window;
@@ -798,7 +798,8 @@ qla82xx_pci_mem_write_direct(struct qla_hw_data *ha,
 }
 
 #define MTU_FUDGE_FACTOR 100
-unsigned long qla82xx_decode_crb_addr(unsigned long addr)
+static unsigned long
+qla82xx_decode_crb_addr(unsigned long addr)
 {
 	int i;
 	unsigned long base_addr, offset, pci_base;
@@ -824,7 +825,7 @@ unsigned long qla82xx_decode_crb_addr(unsigned long addr)
 static long rom_max_timeout = 100;
 static long qla82xx_rom_lock_timeout = 100;
 
-int
+static int
 qla82xx_rom_lock(struct qla_hw_data *ha)
 {
 	int done = 0, timeout = 0;
@@ -842,7 +843,7 @@ qla82xx_rom_lock(struct qla_hw_data *ha)
 	return 0;
 }
 
-int
+static int
 qla82xx_wait_rom_busy(struct qla_hw_data *ha)
 {
 	long timeout = 0;
@@ -862,7 +863,7 @@ qla82xx_wait_rom_busy(struct qla_hw_data *ha)
 	return 0;
 }
 
-int
+static int
 qla82xx_wait_rom_done(struct qla_hw_data *ha)
 {
 	long timeout = 0;
@@ -882,7 +883,7 @@ qla82xx_wait_rom_done(struct qla_hw_data *ha)
 	return 0;
 }
 
-int
+static int
 qla82xx_do_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 {
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ADDRESS, addr);
@@ -905,7 +906,7 @@ qla82xx_do_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 	return 0;
 }
 
-int
+static int
 qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 {
 	int ret, loops = 0;
@@ -926,7 +927,7 @@ qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 	return ret;
 }
 
-int
+static int
 qla82xx_read_status_reg(struct qla_hw_data *ha, uint32_t *val)
 {
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_RDSR);
@@ -940,7 +941,7 @@ qla82xx_read_status_reg(struct qla_hw_data *ha, uint32_t *val)
 	return 0;
 }
 
-int
+static int
 qla82xx_flash_wait_write_finish(struct qla_hw_data *ha)
 {
 	long timeout = 0;
@@ -964,7 +965,7 @@ qla82xx_flash_wait_write_finish(struct qla_hw_data *ha)
 	return ret;
 }
 
-int
+static int
 qla82xx_flash_set_write_enable(struct qla_hw_data *ha)
 {
 	uint32_t val;
@@ -981,7 +982,7 @@ qla82xx_flash_set_write_enable(struct qla_hw_data *ha)
 	return 0;
 }
 
-int
+static int
 qla82xx_write_status_reg(struct qla_hw_data *ha, uint32_t val)
 {
 	if (qla82xx_flash_set_write_enable(ha))
@@ -996,7 +997,7 @@ qla82xx_write_status_reg(struct qla_hw_data *ha, uint32_t val)
 	return qla82xx_flash_wait_write_finish(ha);
 }
 
-int
+static int
 qla82xx_write_disable_flash(struct qla_hw_data *ha)
 {
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_WRDI);
@@ -1008,7 +1009,7 @@ qla82xx_write_disable_flash(struct qla_hw_data *ha)
 	return 0;
 }
 
-int
+static int
 ql82xx_rom_lock_d(struct qla_hw_data *ha)
 {
 	int loops = 0;
@@ -1024,7 +1025,7 @@ ql82xx_rom_lock_d(struct qla_hw_data *ha)
 	return 0;;
 }
 
-int
+static int
 qla82xx_write_flash_dword(struct qla_hw_data *ha, uint32_t flashaddr,
 	uint32_t data)
 {
@@ -1061,7 +1062,8 @@ done_write:
 /* This routine does CRB initialize sequence
  *  to put the ISP into operational state
  */
-int qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
+static int
+qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 {
 	int addr, val;
 	int i ;
@@ -1207,7 +1209,8 @@ int qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 	return 0;
 }
 
-int qla82xx_check_for_bad_spd(struct qla_hw_data *ha)
+static int
+qla82xx_check_for_bad_spd(struct qla_hw_data *ha)
 {
 	u32 val = 0;
 	val = qla82xx_rd_32(ha, BOOT_LOADER_DIMM_STATUS);
@@ -1225,7 +1228,116 @@ int qla82xx_check_for_bad_spd(struct qla_hw_data *ha)
 	return 0;
 }
 
-int
+static int
+qla82xx_pci_mem_write_2M(struct qla_hw_data *ha,
+		u64 off, void *data, int size)
+{
+	int i, j, ret = 0, loop, sz[2], off0;
+	int scale, shift_amount, startword;
+	uint32_t temp;
+	uint64_t off8, mem_crb, tmpw, word[2] = {0, 0};
+
+	/*
+	 * If not MN, go check for MS or invalid.
+	 */
+	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX)
+		mem_crb = QLA82XX_CRB_QDR_NET;
+	else {
+		mem_crb = QLA82XX_CRB_DDR_NET;
+		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
+			return qla82xx_pci_mem_write_direct(ha,
+			    off, data, size);
+	}
+
+	off0 = off & 0x7;
+	sz[0] = (size < (8 - off0)) ? size : (8 - off0);
+	sz[1] = size - sz[0];
+
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
+	}
+
+	switch (size) {
+	case 1:
+		tmpw = *((uint8_t *)data);
+		break;
+	case 2:
+		tmpw = *((uint16_t *)data);
+		break;
+	case 4:
+		tmpw = *((uint32_t *)data);
+		break;
+	case 8:
+	default:
+		tmpw = *((uint64_t *)data);
+		break;
+	}
+
+	if (sz[0] == 8) {
+		word[startword] = tmpw;
+	} else {
+		word[startword] &=
+			~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
+		word[startword] |= tmpw << (off0 * 8);
+	}
+	if (sz[1] != 0) {
+		word[startword+1] &= ~(~0ULL << (sz[1] * 8));
+		word[startword+1] |= tmpw >> (sz[0] * 8);
+	}
+
+	/*
+	 * don't lock here - write_wx gets the lock if each time
+	 * write_lock_irqsave(&adapter->adapter_lock, flags);
+	 * netxen_nic_pci_change_crbwindow_128M(adapter, 0);
+	 */
+	for (i = 0; i < loop; i++) {
+		temp = off8 + (i << shift_amount);
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_LO, temp);
+		temp = 0;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_HI, temp);
+		temp = word[i * scale] & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_LO, temp);
+		temp = (word[i * scale] >> 32) & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_HI, temp);
+		temp = word[i*scale + 1] & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb +
+		    MIU_TEST_AGT_WRDATA_UPPER_LO, temp);
+		temp = (word[i*scale + 1] >> 32) & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb +
+		    MIU_TEST_AGT_WRDATA_UPPER_HI, temp);
+
+		temp = MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
+		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
+
+		for (j = 0; j < MAX_CTL_CHECK; j++) {
+			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
+			if ((temp & MIU_TA_CTL_BUSY) == 0)
+				break;
+		}
+
+		if (j >= MAX_CTL_CHECK) {
+			if (printk_ratelimit())
+				dev_err(&ha->pdev->dev,
+				    "failed to write through agent\n");
+			ret = -1;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int
 qla82xx_fw_load_from_flash(struct qla_hw_data *ha)
 {
 	int  i;
@@ -1357,114 +1469,6 @@ qla82xx_pci_mem_read_2M(struct qla_hw_data *ha,
 	return 0;
 }
 
-int
-qla82xx_pci_mem_write_2M(struct qla_hw_data *ha,
-		u64 off, void *data, int size)
-{
-	int i, j, ret = 0, loop, sz[2], off0;
-	int scale, shift_amount, startword;
-	uint32_t temp;
-	uint64_t off8, mem_crb, tmpw, word[2] = {0, 0};
-
-	/*
-	 * If not MN, go check for MS or invalid.
-	 */
-	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX)
-		mem_crb = QLA82XX_CRB_QDR_NET;
-	else {
-		mem_crb = QLA82XX_CRB_DDR_NET;
-		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
-			return qla82xx_pci_mem_write_direct(ha,
-			    off, data, size);
-	}
-
-	off0 = off & 0x7;
-	sz[0] = (size < (8 - off0)) ? size : (8 - off0);
-	sz[1] = size - sz[0];
-
-	off8 = off & 0xfffffff0;
-	loop = (((off & 0xf) + size - 1) >> 4) + 1;
-	shift_amount = 4;
-	scale = 2;
-	startword = (off & 0xf)/8;
-
-	for (i = 0; i < loop; i++) {
-		if (qla82xx_pci_mem_read_2M(ha, off8 +
-		    (i << shift_amount), &word[i * scale], 8))
-			return -1;
-	}
-
-	switch (size) {
-	case 1:
-		tmpw = *((uint8_t *)data);
-		break;
-	case 2:
-		tmpw = *((uint16_t *)data);
-		break;
-	case 4:
-		tmpw = *((uint32_t *)data);
-		break;
-	case 8:
-	default:
-		tmpw = *((uint64_t *)data);
-		break;
-	}
-
-	if (sz[0] == 8) {
-		word[startword] = tmpw;
-	} else {
-		word[startword] &=
-			~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
-		word[startword] |= tmpw << (off0 * 8);
-	}
-	if (sz[1] != 0) {
-		word[startword+1] &= ~(~0ULL << (sz[1] * 8));
-		word[startword+1] |= tmpw >> (sz[0] * 8);
-	}
-
-	/*
-	 * don't lock here - write_wx gets the lock if each time
-	 * write_lock_irqsave(&adapter->adapter_lock, flags);
-	 * netxen_nic_pci_change_crbwindow_128M(adapter, 0);
-	 */
-	for (i = 0; i < loop; i++) {
-		temp = off8 + (i << shift_amount);
-		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_LO, temp);
-		temp = 0;
-		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_HI, temp);
-		temp = word[i * scale] & 0xffffffff;
-		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_LO, temp);
-		temp = (word[i * scale] >> 32) & 0xffffffff;
-		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_HI, temp);
-		temp = word[i*scale + 1] & 0xffffffff;
-		qla82xx_wr_32(ha, mem_crb +
-		    MIU_TEST_AGT_WRDATA_UPPER_LO, temp);
-		temp = (word[i*scale + 1] >> 32) & 0xffffffff;
-		qla82xx_wr_32(ha, mem_crb +
-		    MIU_TEST_AGT_WRDATA_UPPER_HI, temp);
-
-		temp = MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
-		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
-		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
-		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
-
-		for (j = 0; j < MAX_CTL_CHECK; j++) {
-			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
-			if ((temp & MIU_TA_CTL_BUSY) == 0)
-				break;
-		}
-
-		if (j >= MAX_CTL_CHECK) {
-			if (printk_ratelimit())
-				dev_err(&ha->pdev->dev,
-				    "failed to write through agent\n");
-			ret = -1;
-			break;
-		}
-	}
-
-	return ret;
-}
 
 static struct qla82xx_uri_table_desc *
 qla82xx_get_table_desc(const u8 *unirom, int section)
@@ -1725,7 +1729,8 @@ void qla82xx_reset_adapter(struct scsi_qla_host *vha)
 	ha->isp_ops->disable_intrs(ha);
 }
 
-int qla82xx_fw_load_from_blob(struct qla_hw_data *ha)
+static int
+qla82xx_fw_load_from_blob(struct qla_hw_data *ha)
 {
 	u64 *ptr64;
 	u32 i, flashaddr, size;
@@ -1836,7 +1841,8 @@ qla82xx_validate_firmware_blob(scsi_qla_host_t *vha, uint8_t fw_type)
 	return 0;
 }
 
-int qla82xx_check_cmdpeg_state(struct qla_hw_data *ha)
+static int
+qla82xx_check_cmdpeg_state(struct qla_hw_data *ha)
 {
 	u32 val = 0;
 	int retries = 60;
@@ -1874,7 +1880,8 @@ int qla82xx_check_cmdpeg_state(struct qla_hw_data *ha)
 	return QLA_FUNCTION_FAILED;
 }
 
-int qla82xx_check_rcvpeg_state(struct qla_hw_data *ha)
+static int
+qla82xx_check_rcvpeg_state(struct qla_hw_data *ha)
 {
 	u32 val = 0;
 	int retries = 60;
@@ -1933,7 +1940,7 @@ static struct qla82xx_legacy_intr_set legacy_intr[] = \
  * @ha: SCSI driver HA context
  * @mb0: Mailbox0 register
  */
-void
+static void
 qla82xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 {
 	uint16_t	cnt;
@@ -2267,10 +2274,11 @@ qla82xx_set_drv_active(scsi_qla_host_t *vha)
 
 	/* If reset value is all FF's, initialize DRV_ACTIVE */
 	if (drv_active == 0xffffffff) {
-		qla82xx_wr_32(ha, QLA82XX_CRB_DRV_ACTIVE, 0);
+		qla82xx_wr_32(ha, QLA82XX_CRB_DRV_ACTIVE,
+			QLA82XX_DRV_NOT_ACTIVE);
 		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
 	}
-	drv_active |= (1 << (ha->portnum * 4));
+	drv_active |= (QLA82XX_DRV_ACTIVE << (ha->portnum * 4));
 	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_ACTIVE, drv_active);
 }
 
@@ -2280,7 +2288,7 @@ qla82xx_clear_drv_active(struct qla_hw_data *ha)
 	uint32_t drv_active;
 
 	drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
-	drv_active &= ~(1 << (ha->portnum * 4));
+	drv_active &= ~(QLA82XX_DRV_ACTIVE << (ha->portnum * 4));
 	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_ACTIVE, drv_active);
 }
 
@@ -2291,7 +2299,7 @@ qla82xx_need_reset(struct qla_hw_data *ha)
 	int rval;
 
 	drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
-	rval = drv_state & (1 << (ha->portnum * 4));
+	rval = drv_state & (QLA82XX_DRVST_RST_RDY << (ha->portnum * 4));
 	return rval;
 }
 
@@ -2305,7 +2313,7 @@ qla82xx_set_rst_ready(struct qla_hw_data *ha)
 
 	/* If reset value is all FF's, initialize DRV_STATE */
 	if (drv_state == 0xffffffff) {
-		qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, 0);
+		qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, QLA82XX_DRVST_NOT_RDY);
 		drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
 	}
 	drv_state |= (QLA82XX_DRVST_RST_RDY << (ha->portnum * 4));
@@ -2335,7 +2343,8 @@ qla82xx_set_qsnt_ready(struct qla_hw_data *ha)
 	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, qsnt_state);
 }
 
-int qla82xx_load_fw(scsi_qla_host_t *vha)
+static int
+qla82xx_load_fw(scsi_qla_host_t *vha)
 {
 	int rst;
 	struct fw_blob *blob;
@@ -2419,7 +2428,7 @@ qla82xx_start_firmware(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	/* scrub dma mask expansion register */
-	qla82xx_wr_32(ha, CRB_DMA_SHIFT, 0x55555555);
+	qla82xx_wr_32(ha, CRB_DMA_SHIFT, QLA82XX_DMA_SHIFT_VALUE);
 
 	/* Put both the PEG CMD and RCV PEG to default state
 	 * of 0 before resetting the hardware
@@ -2882,7 +2891,7 @@ queuing_error:
 	return QLA_FUNCTION_FAILED;
 }
 
-uint32_t *
+static uint32_t *
 qla82xx_read_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	uint32_t length)
 {
@@ -2903,7 +2912,7 @@ done_read:
 	return dwptr;
 }
 
-int
+static int
 qla82xx_unprotect_flash(struct qla_hw_data *ha)
 {
 	int ret;
@@ -2934,7 +2943,7 @@ done_unprotect:
 	return ret;
 }
 
-int
+static int
 qla82xx_protect_flash(struct qla_hw_data *ha)
 {
 	int ret;
@@ -2963,7 +2972,7 @@ done_protect:
 	return ret;
 }
 
-int
+static int
 qla82xx_erase_sector(struct qla_hw_data *ha, int addr)
 {
 	int ret = 0;
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 15559ca..51ec0c5 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -26,6 +26,7 @@
 #define CRB_RCVPEG_STATE		QLA82XX_REG(0x13c)
 #define BOOT_LOADER_DIMM_STATUS		QLA82XX_REG(0x54)
 #define CRB_DMA_SHIFT			QLA82XX_REG(0xcc)
+#define QLA82XX_DMA_SHIFT_VALUE		0x55555555
 
 #define QLA82XX_HW_H0_CH_HUB_ADR    0x05
 #define QLA82XX_HW_H1_CH_HUB_ADR    0x0E
@@ -583,6 +584,10 @@
 #define	QLA82XX_DRVST_RST_RDY		1
 #define QLA82XX_DRVST_QSNT_RDY		2
 
+/* Different drive active state */
+#define QLA82XX_DRV_NOT_ACTIVE		0
+#define QLA82XX_DRV_ACTIVE		1
+
 /*
  * The PCI VendorID and DeviceID for our board.
  */
-- 
1.6.0.2

