From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 04/19] qla2xxx: Fix for warnings reported by sparse.
Date: Wed, 21 Nov 2012 02:40:29 -0500
Message-ID: <1353483644-17262-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:55064 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753145Ab2KUH6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:54 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |    4 +-
 drivers/scsi/qla2xxx/qla_def.h    |    4 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |    1 -
 drivers/scsi/qla2xxx/qla_init.c   |   62 +++--------------------------
 drivers/scsi/qla2xxx/qla_iocb.c   |    4 +-
 drivers/scsi/qla2xxx/qla_isr.c    |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c    |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c     |   77 ++++++++++++++-----------------------
 drivers/scsi/qla2xxx/qla_os.c     |   15 ++++---
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 10 files changed, 54 insertions(+), 121 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 44efe3c..04b2823 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -526,8 +526,8 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 		ha->max_req_queues : ha->max_rsp_queues;
 	mq->count = htonl(que_cnt);
 	for (cnt = 0; cnt < que_cnt; cnt++) {
-		reg = (struct device_reg_25xxmq *) ((void *)
-			ha->mqiobase + cnt * QLA_QUE_PAGE);
+		reg = (struct device_reg_25xxmq __iomem *)
+			(ha->mqiobase + cnt * QLA_QUE_PAGE);
 		que_idx = cnt * 4;
 		mq->qregs[que_idx] = htonl(RD_REG_DWORD(&reg->req_q_in));
 		mq->qregs[que_idx+1] = htonl(RD_REG_DWORD(&reg->req_q_out));
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a9725bf..6e7727f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2486,9 +2486,9 @@ struct bidi_statistics {
 #define QLA_MAX_QUEUES 256
 #define ISP_QUE_REG(ha, id) \
 	((ha->mqenable || IS_QLA83XX(ha)) ? \
-	((void *)(ha->mqiobase) +\
+	((device_reg_t __iomem *)(ha->mqiobase) +\
 	(QLA_QUE_PAGE * id)) :\
-	((void *)(ha->iobase)))
+	((device_reg_t __iomem *)(ha->iobase)))
 #define QLA_REQ_QUE_ID(tag) \
 	((tag < QLA_MAX_QUEUES && tag > 0) ? tag : 0)
 #define QLA_DEFAULT_QUE_QOS 5
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 6acb397..dfad959 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -598,7 +598,6 @@ extern void qla82xx_init_flags(struct qla_hw_data *);
 
 /* ISP 8021 hardware related */
 extern void qla82xx_set_drv_active(scsi_qla_host_t *);
-extern void qla82xx_crb_win_unlock(struct qla_hw_data *);
 extern int qla82xx_wr_32(struct qla_hw_data *, ulong, u32);
 extern int qla82xx_rd_32(struct qla_hw_data *, ulong);
 extern int qla82xx_rdmem(struct qla_hw_data *, u64, void *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 39044fc..b7e42a8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -429,7 +429,7 @@ qla2x00_async_adisc_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 /*                QLogic ISP2x00 Hardware Support Functions.                */
 /****************************************************************************/
 
-int
+static int
 qla83xx_nic_core_fw_load(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
@@ -997,7 +997,7 @@ qla2x00_reset_chip(scsi_qla_host_t *vha)
  *
  * Returns 0 on success.
  */
-int
+static int
 qla81xx_reset_mpi(scsi_qla_host_t *vha)
 {
 	uint16_t mb[4] = {0x1010, 0, 1, 0};
@@ -3865,7 +3865,7 @@ qla83xx_reset_ownership(scsi_qla_host_t *vha)
 	}
 }
 
-int
+static int
 __qla83xx_set_drv_ack(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
@@ -3881,19 +3881,7 @@ __qla83xx_set_drv_ack(scsi_qla_host_t *vha)
 	return rval;
 }
 
-int
-qla83xx_set_drv_ack(scsi_qla_host_t *vha)
-{
-	int rval = QLA_SUCCESS;
-
-	qla83xx_idc_lock(vha, 0);
-	rval = __qla83xx_set_drv_ack(vha);
-	qla83xx_idc_unlock(vha, 0);
-
-	return rval;
-}
-
-int
+static int
 __qla83xx_clear_drv_ack(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
@@ -3909,19 +3897,7 @@ __qla83xx_clear_drv_ack(scsi_qla_host_t *vha)
 	return rval;
 }
 
-int
-qla83xx_clear_drv_ack(scsi_qla_host_t *vha)
-{
-	int rval = QLA_SUCCESS;
-
-	qla83xx_idc_lock(vha, 0);
-	rval = __qla83xx_clear_drv_ack(vha);
-	qla83xx_idc_unlock(vha, 0);
-
-	return rval;
-}
-
-const char *
+static const char *
 qla83xx_dev_state_to_string(uint32_t dev_state)
 {
 	switch (dev_state) {
@@ -3975,7 +3951,7 @@ qla83xx_idc_audit(scsi_qla_host_t *vha, int audit_type)
 }
 
 /* Assumes idc_lock always held on entry */
-int
+static int
 qla83xx_initiating_reset(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
@@ -4023,36 +3999,12 @@ __qla83xx_set_idc_control(scsi_qla_host_t *vha, uint32_t idc_control)
 }
 
 int
-qla83xx_set_idc_control(scsi_qla_host_t *vha, uint32_t idc_control)
-{
-	int rval = QLA_SUCCESS;
-
-	qla83xx_idc_lock(vha, 0);
-	rval = __qla83xx_set_idc_control(vha, idc_control);
-	qla83xx_idc_unlock(vha, 0);
-
-	return rval;
-}
-
-int
 __qla83xx_get_idc_control(scsi_qla_host_t *vha, uint32_t *idc_control)
 {
 	return qla83xx_rd_reg(vha, QLA83XX_IDC_CONTROL, idc_control);
 }
 
-int
-qla83xx_get_idc_control(scsi_qla_host_t *vha, uint32_t *idc_control)
-{
-	int rval = QLA_SUCCESS;
-
-	qla83xx_idc_lock(vha, 0);
-	rval = __qla83xx_get_idc_control(vha, idc_control);
-	qla83xx_idc_unlock(vha, 0);
-
-	return rval;
-}
-
-int
+static int
 qla83xx_check_driver_presence(scsi_qla_host_t *vha)
 {
 	uint32_t drv_presence = 0;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 03b7526..b610404 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -520,7 +520,7 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 
 	mrk24 = NULL;
 	req = ha->req_q_map[0];
-	mrk = (mrk_entry_t *)qla2x00_alloc_iocbs(vha, 0);
+	mrk = (mrk_entry_t *)qla2x00_alloc_iocbs(vha, NULL);
 	if (mrk == NULL) {
 		ql_log(ql_log_warn, base_vha, 0x3026,
 		    "Failed to allocate Marker IOCB.\n");
@@ -2551,7 +2551,7 @@ sufficient_dsds:
 			(unsigned long __iomem *)ha->nxdb_wr_ptr,
 			dbval);
 		wmb();
-		while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
+		while (RD_REG_DWORD((void __iomem *)ha->nxdb_rd_ptr) != dbval) {
 			WRT_REG_DWORD(
 				(unsigned long __iomem *)ha->nxdb_wr_ptr,
 				dbval);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5733811..bb611e2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -337,7 +337,7 @@ qla2x00_get_link_speed_str(struct qla_hw_data *ha)
 	return link_speed;
 }
 
-void
+static void
 qla83xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 {
 	struct qla_hw_data *ha = vha->hw;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bdf7fa7..68c55ea 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3536,7 +3536,7 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	if (IS_QLA83XX(ha))
 		mcp->mb[15] = 0;
 
-	reg = (struct device_reg_25xxmq *)((void *)(ha->mqiobase) +
+	reg = (struct device_reg_25xxmq __iomem *)((ha->mqiobase) +
 		QLA_QUE_PAGE * req->id);
 
 	mcp->mb[4] = req->id;
@@ -3605,7 +3605,7 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	if (IS_QLA83XX(ha))
 		mcp->mb[15] = 0;
 
-	reg = (struct device_reg_25xxmq *)((void *)(ha->mqiobase) +
+	reg = (struct device_reg_25xxmq __iomem *)((ha->mqiobase) +
 		QLA_QUE_PAGE * rsp->id);
 
 	mcp->mb[4] = rsp->id;
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 14cd361..f0fdc22 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -36,7 +36,7 @@
 
 #define MAX_CRB_XFORM 60
 static unsigned long crb_addr_xform[MAX_CRB_XFORM];
-int qla82xx_crb_table_initialized;
+static int qla82xx_crb_table_initialized;
 
 #define qla82xx_crb_addr_transform(name) \
 	(crb_addr_xform[QLA82XX_HW_PX_MAP_CRB_##name] = \
@@ -102,7 +102,7 @@ static void qla82xx_crb_addr_transform_setup(void)
 	qla82xx_crb_table_initialized = 1;
 }
 
-struct crb_128M_2M_block_map crb_128M_2M_map[64] = {
+static struct crb_128M_2M_block_map crb_128M_2M_map[64] = {
 	{{{0, 0,         0,         0} } },
 	{{{1, 0x0100000, 0x0102000, 0x120000},
 	{1, 0x0110000, 0x0120000, 0x130000},
@@ -262,7 +262,7 @@ struct crb_128M_2M_block_map crb_128M_2M_map[64] = {
 /*
  * top 12 bits of crb internal address (hub, agent)
  */
-unsigned qla82xx_crb_hub_agt[64] = {
+static unsigned qla82xx_crb_hub_agt[64] = {
 	0,
 	QLA82XX_HW_CRB_HUB_AGT_ADR_PS,
 	QLA82XX_HW_CRB_HUB_AGT_ADR_MN,
@@ -330,7 +330,7 @@ unsigned qla82xx_crb_hub_agt[64] = {
 };
 
 /* Device states */
-char *q_dev_state[] = {
+static char *q_dev_state[] = {
 	 "Unknown",
 	"Cold",
 	"Initializing",
@@ -359,12 +359,13 @@ qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong *off)
 
 	ha->crb_win = CRB_HI(*off);
 	writel(ha->crb_win,
-		(void *)(CRB_WINDOW_2M + ha->nx_pcibase));
+		(void __iomem *)(CRB_WINDOW_2M + ha->nx_pcibase));
 
 	/* Read back value to make sure write has gone through before trying
 	 * to use it.
 	 */
-	win_read = RD_REG_DWORD((void *)(CRB_WINDOW_2M + ha->nx_pcibase));
+	win_read = RD_REG_DWORD((void __iomem *)
+	    (CRB_WINDOW_2M + ha->nx_pcibase));
 	if (win_read != ha->crb_win) {
 		ql_dbg(ql_dbg_p3p, vha, 0xb000,
 		    "%s: Written crbwin (0x%x) "
@@ -567,7 +568,7 @@ qla82xx_pci_mem_bound_check(struct qla_hw_data *ha,
 		return 1;
 }
 
-int qla82xx_pci_set_window_warning_count;
+static int qla82xx_pci_set_window_warning_count;
 
 static unsigned long
 qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
@@ -677,10 +678,10 @@ static int qla82xx_pci_mem_read_direct(struct qla_hw_data *ha,
 	u64 off, void *data, int size)
 {
 	unsigned long   flags;
-	void           *addr = NULL;
+	void __iomem *addr = NULL;
 	int             ret = 0;
 	u64             start;
-	uint8_t         *mem_ptr = NULL;
+	uint8_t __iomem  *mem_ptr = NULL;
 	unsigned long   mem_base;
 	unsigned long   mem_page;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
@@ -712,7 +713,7 @@ static int qla82xx_pci_mem_read_direct(struct qla_hw_data *ha,
 		mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE * 2);
 	else
 		mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
-	if (mem_ptr == 0UL) {
+	if (mem_ptr == NULL) {
 		*(u8  *)data = 0;
 		return -1;
 	}
@@ -749,10 +750,10 @@ qla82xx_pci_mem_write_direct(struct qla_hw_data *ha,
 	u64 off, void *data, int size)
 {
 	unsigned long   flags;
-	void           *addr = NULL;
+	void  __iomem *addr = NULL;
 	int             ret = 0;
 	u64             start;
-	uint8_t         *mem_ptr = NULL;
+	uint8_t __iomem *mem_ptr = NULL;
 	unsigned long   mem_base;
 	unsigned long   mem_page;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
@@ -784,7 +785,7 @@ qla82xx_pci_mem_write_direct(struct qla_hw_data *ha,
 		mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE*2);
 	else
 		mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
-	if (mem_ptr == 0UL)
+	if (mem_ptr == NULL)
 		return -1;
 
 	addr = mem_ptr;
@@ -908,24 +909,24 @@ qla82xx_wait_rom_done(struct qla_hw_data *ha)
 	return 0;
 }
 
-int
+static int
 qla82xx_md_rw_32(struct qla_hw_data *ha, uint32_t off, u32 data, uint8_t flag)
 {
 	uint32_t  off_value, rval = 0;
 
-	WRT_REG_DWORD((void *)(CRB_WINDOW_2M + ha->nx_pcibase),
+	WRT_REG_DWORD((void __iomem *)(CRB_WINDOW_2M + ha->nx_pcibase),
 	    (off & 0xFFFF0000));
 
 	/* Read back value to make sure write has gone through */
-	RD_REG_DWORD((void *)(CRB_WINDOW_2M + ha->nx_pcibase));
+	RD_REG_DWORD((void __iomem *)(CRB_WINDOW_2M + ha->nx_pcibase));
 	off_value  = (off & 0x0000FFFF);
 
 	if (flag)
-		WRT_REG_DWORD((void *)
+		WRT_REG_DWORD((void __iomem *)
 		    (off_value + CRB_INDIRECT_2M + ha->nx_pcibase),
 		    data);
 	else
-		rval = RD_REG_DWORD((void *)
+		rval = RD_REG_DWORD((void __iomem *)
 		    (off_value + CRB_INDIRECT_2M + ha->nx_pcibase));
 
 	return rval;
@@ -1764,14 +1765,6 @@ void qla82xx_config_rings(struct scsi_qla_host *vha)
 	WRT_REG_DWORD((unsigned long  __iomem *)&reg->rsp_q_out[0], 0);
 }
 
-void qla82xx_reset_adapter(struct scsi_qla_host *vha)
-{
-	struct qla_hw_data *ha = vha->hw;
-	vha->flags.online = 0;
-	qla2x00_try_to_stop_firmware(vha);
-	ha->isp_ops->disable_intrs(ha);
-}
-
 static int
 qla82xx_fw_load_from_blob(struct qla_hw_data *ha)
 {
@@ -1856,7 +1849,7 @@ qla82xx_set_product_offset(struct qla_hw_data *ha)
 	return -1;
 }
 
-int
+static int
 qla82xx_validate_firmware_blob(scsi_qla_host_t *vha, uint8_t fw_type)
 {
 	__le32 val;
@@ -1961,20 +1954,6 @@ qla82xx_check_rcvpeg_state(struct qla_hw_data *ha)
 }
 
 /* ISR related functions */
-uint32_t qla82xx_isr_int_target_mask_enable[8] = {
-	ISR_INT_TARGET_MASK, ISR_INT_TARGET_MASK_F1,
-	ISR_INT_TARGET_MASK_F2, ISR_INT_TARGET_MASK_F3,
-	ISR_INT_TARGET_MASK_F4, ISR_INT_TARGET_MASK_F5,
-	ISR_INT_TARGET_MASK_F7, ISR_INT_TARGET_MASK_F7
-};
-
-uint32_t qla82xx_isr_int_target_status[8] = {
-	ISR_INT_TARGET_STATUS, ISR_INT_TARGET_STATUS_F1,
-	ISR_INT_TARGET_STATUS_F2, ISR_INT_TARGET_STATUS_F3,
-	ISR_INT_TARGET_STATUS_F4, ISR_INT_TARGET_STATUS_F5,
-	ISR_INT_TARGET_STATUS_F7, ISR_INT_TARGET_STATUS_F7
-};
-
 static struct qla82xx_legacy_intr_set legacy_intr[] = \
 	QLA82XX_LEGACY_INTR_CONFIG;
 
@@ -2813,7 +2792,7 @@ qla82xx_start_iocbs(scsi_qla_host_t *vha)
 	else {
 		WRT_REG_DWORD((unsigned long __iomem *)ha->nxdb_wr_ptr, dbval);
 		wmb();
-		while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
+		while (RD_REG_DWORD((void __iomem *)ha->nxdb_rd_ptr) != dbval) {
 			WRT_REG_DWORD((unsigned long  __iomem *)ha->nxdb_wr_ptr,
 				dbval);
 			wmb();
@@ -2821,7 +2800,8 @@ qla82xx_start_iocbs(scsi_qla_host_t *vha)
 	}
 }
 
-void qla82xx_rom_lock_recovery(struct qla_hw_data *ha)
+static void
+qla82xx_rom_lock_recovery(struct qla_hw_data *ha)
 {
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
@@ -3177,7 +3157,7 @@ qla82xx_check_md_needed(scsi_qla_host_t *vha)
 }
 
 
-int
+static int
 qla82xx_check_fw_alive(scsi_qla_host_t *vha)
 {
 	uint32_t fw_heartbeat_counter;
@@ -3817,7 +3797,8 @@ qla82xx_minidump_process_rdocm(scsi_qla_host_t *vha,
 	loop_cnt = ocm_hdr->op_count;
 
 	for (i = 0; i < loop_cnt; i++) {
-		r_value = RD_REG_DWORD((void *)(r_addr + ha->nx_pcibase));
+		r_value = RD_REG_DWORD((void __iomem *)
+		    (r_addr + ha->nx_pcibase));
 		*data_ptr++ = cpu_to_le32(r_value);
 		r_addr += r_stride;
 	}
@@ -4376,7 +4357,7 @@ qla82xx_md_free(scsi_qla_host_t *vha)
 		    ha->md_tmplt_hdr, ha->md_template_size / 1024);
 		dma_free_coherent(&ha->pdev->dev, ha->md_template_size,
 		    ha->md_tmplt_hdr, ha->md_tmplt_hdr_dma);
-		ha->md_tmplt_hdr = 0;
+		ha->md_tmplt_hdr = NULL;
 	}
 
 	/* Release the template data buffer allocated */
@@ -4386,7 +4367,7 @@ qla82xx_md_free(scsi_qla_host_t *vha)
 		    ha->md_dump, ha->md_dump_size / 1024);
 		vfree(ha->md_dump);
 		ha->md_dump_size = 0;
-		ha->md_dump = 0;
+		ha->md_dump = NULL;
 	}
 }
 
@@ -4423,7 +4404,7 @@ qla82xx_md_prep(scsi_qla_host_t *vha)
 				dma_free_coherent(&ha->pdev->dev,
 				    ha->md_template_size,
 				    ha->md_tmplt_hdr, ha->md_tmplt_hdr_dma);
-				ha->md_tmplt_hdr = 0;
+				ha->md_tmplt_hdr = NULL;
 			}
 
 		}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f4b1fc8..0cdc6e2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -41,7 +41,7 @@ static struct kmem_cache *ctx_cachep;
  */
 int ql_errlev = ql_log_all;
 
-int ql2xenableclass2;
+static int ql2xenableclass2;
 module_param(ql2xenableclass2, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xenableclass2,
 		"Specify if Class 2 operations are supported from the very "
@@ -3835,7 +3835,7 @@ qla83xx_idc_state_handler_work(struct work_struct *work)
 	qla83xx_idc_unlock(base_vha, 0);
 }
 
-int
+static int
 qla83xx_check_nic_core_fw_alive(scsi_qla_host_t *base_vha)
 {
 	int rval = QLA_SUCCESS;
@@ -3953,7 +3953,7 @@ qla83xx_wait_logic(void)
 	}
 }
 
-int
+static int
 qla83xx_force_lock_recovery(scsi_qla_host_t *base_vha)
 {
 	int rval;
@@ -4012,7 +4012,7 @@ qla83xx_force_lock_recovery(scsi_qla_host_t *base_vha)
 	return rval;
 }
 
-int
+static int
 qla83xx_idc_lock_recovery(scsi_qla_host_t *base_vha)
 {
 	int rval = QLA_SUCCESS;
@@ -4211,7 +4211,7 @@ qla83xx_clear_drv_presence(scsi_qla_host_t *vha)
 	return rval;
 }
 
-void
+static void
 qla83xx_need_reset_handler(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
@@ -4250,7 +4250,7 @@ qla83xx_need_reset_handler(scsi_qla_host_t *vha)
 	ql_log(ql_log_info, vha, 0xb068, "HW State: COLD/RE-INIT.\n");
 }
 
-int
+static int
 qla83xx_device_bootstrap(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
@@ -4986,7 +4986,8 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 		return PCI_ERS_RESULT_RECOVERED;
 }
 
-uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
+static uint32_t
+qla82xx_error_recovery(scsi_qla_host_t *base_vha)
 {
 	uint32_t rval = QLA_FUNCTION_FAILED;
 	uint32_t drv_active = 0;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 62aa558..dc98ec9 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1029,7 +1029,7 @@ void qlt_stop_phase2(struct qla_tgt *tgt)
 EXPORT_SYMBOL(qlt_stop_phase2);
 
 /* Called from qlt_remove_target() -> qla2x00_remove_one() */
-void qlt_release(struct qla_tgt *tgt)
+static void qlt_release(struct qla_tgt *tgt)
 {
 	struct qla_hw_data *ha = tgt->ha;
 
-- 
1.7.7

