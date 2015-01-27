From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 07/10] qla2xxx: Fix sparse annotations
Date: Tue, 27 Jan 2015 10:34:19 +0100
Message-ID: <54C75B9B.8070400@sandisk.com>
References: <54C75AF8.90102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0059.outbound.protection.outlook.com ([157.56.110.59]:19175
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754428AbbA0Je0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 04:34:26 -0500
In-Reply-To: <54C75AF8.90102@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch removes 21 casts between an __iomem pointer type and
another data type but also introduces five new casts (see also
the casts with "__force"). Although this patch does not change
any functionality, IMHO the code with __force casts needs further
review.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   6 +--
 drivers/scsi/qla2xxx/qla_iocb.c |  12 ++---
 drivers/scsi/qla2xxx/qla_mbx.c  |   2 +-
 drivers/scsi/qla2xxx/qla_mr.c   |   6 +--
 drivers/scsi/qla2xxx/qla_nx.c   | 107 +++++++++++++++++++---------------------
 drivers/scsi/qla2xxx/qla_tmpl.c |  20 ++++----
 6 files changed, 71 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5f6b296..3bed3d0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3415,9 +3415,9 @@ struct qla_hw_data {
 	mempool_t       *ctx_mempool;
 #define FCP_CMND_DMA_POOL_SIZE 512
 
-	unsigned long	nx_pcibase;		/* Base I/O address */
-	uint8_t		*nxdb_rd_ptr;		/* Doorbell read pointer */
-	unsigned long	nxdb_wr_ptr;		/* Door bell write pointer */
+	void __iomem	*nx_pcibase;		/* Base I/O address */
+	void __iomem	*nxdb_rd_ptr;		/* Doorbell read pointer */
+	void __iomem	*nxdb_wr_ptr;		/* Door bell write pointer */
 
 	uint32_t	crb_win;
 	uint32_t	curr_window;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 25f31d9..21d6f3f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2507,16 +2507,12 @@ sufficient_dsds:
 	/* write, read and verify logic */
 	dbval = dbval | (req->id << 8) | (req->ring_index << 16);
 	if (ql2xdbwr)
-		qla82xx_wr_32(ha, ha->nxdb_wr_ptr, dbval);
+		qla82xx_wr_32(ha, (uintptr_t __force)ha->nxdb_wr_ptr, dbval);
 	else {
-		WRT_REG_DWORD(
-			(unsigned long __iomem *)ha->nxdb_wr_ptr,
-			dbval);
+		WRT_REG_DWORD(ha->nxdb_wr_ptr, dbval);
 		wmb();
-		while (RD_REG_DWORD((void __iomem *)ha->nxdb_rd_ptr) != dbval) {
-			WRT_REG_DWORD(
-				(unsigned long __iomem *)ha->nxdb_wr_ptr,
-				dbval);
+		while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
+			WRT_REG_DWORD(ha->nxdb_wr_ptr, dbval);
 			wmb();
 		}
 	}
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 03e92d0..e26e603 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1225,7 +1225,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 	    "Entered %s.\n", __func__);
 
 	if (IS_P3P_TYPE(ha) && ql2xdbwr)
-		qla82xx_wr_32(ha, ha->nxdb_wr_ptr,
+		qla82xx_wr_32(ha, (uintptr_t __force)ha->nxdb_wr_ptr,
 			(0x04 | (ha->portnum << 5) | (0 << 8) | (0 << 16)));
 
 	if (ha->flags.npiv_supported)
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 2d798e6..b5029e5 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -862,7 +862,7 @@ qlafx00_config_queues(struct scsi_qla_host *vha)
 	dma_addr_t bar2_hdl = pci_resource_start(ha->pdev, 2);
 
 	req->length = ha->req_que_len;
-	req->ring = (void *)ha->iobase + ha->req_que_off;
+	req->ring = (void __force *)ha->iobase + ha->req_que_off;
 	req->dma = bar2_hdl + ha->req_que_off;
 	if ((!req->ring) || (req->length == 0)) {
 		ql_log_pci(ql_log_info, ha->pdev, 0x012f,
@@ -877,7 +877,7 @@ qlafx00_config_queues(struct scsi_qla_host *vha)
 	    ha->req_que_off, (u64)req->dma);
 
 	rsp->length = ha->rsp_que_len;
-	rsp->ring = (void *)ha->iobase + ha->rsp_que_off;
+	rsp->ring = (void __force *)ha->iobase + ha->rsp_que_off;
 	rsp->dma = bar2_hdl + ha->rsp_que_off;
 	if ((!rsp->ring) || (rsp->length == 0)) {
 		ql_log_pci(ql_log_info, ha->pdev, 0x0131,
@@ -1425,7 +1425,7 @@ qlafx00_init_response_q_entries(struct rsp_que *rsp)
 	pkt = rsp->ring_ptr;
 	for (cnt = 0; cnt < rsp->length; cnt++) {
 		pkt->signature = RESPONSE_PROCESSED;
-		WRT_REG_DWORD((void __iomem *)&pkt->signature,
+		WRT_REG_DWORD((void __force __iomem *)&pkt->signature,
 		    RESPONSE_PROCESSED);
 		pkt++;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 0af9d5a..7521054 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -347,32 +347,31 @@ char *qdev_state(uint32_t dev_state)
 }
 
 /*
- * In: 'off' is offset from CRB space in 128M pci map
- * Out: 'off' is 2M pci map addr
+ * In: 'off_in' is offset from CRB space in 128M pci map
+ * Out: 'off_out' is 2M pci map addr
  * side effect: lock crb window
  */
 static void
-qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong *off)
+qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong off_in,
+			     void __iomem **off_out)
 {
 	u32 win_read;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
-	ha->crb_win = CRB_HI(*off);
-	writel(ha->crb_win,
-		(void __iomem *)(CRB_WINDOW_2M + ha->nx_pcibase));
+	ha->crb_win = CRB_HI(off_in);
+	writel(ha->crb_win, CRB_WINDOW_2M + ha->nx_pcibase);
 
 	/* Read back value to make sure write has gone through before trying
 	 * to use it.
 	 */
-	win_read = RD_REG_DWORD((void __iomem *)
-	    (CRB_WINDOW_2M + ha->nx_pcibase));
+	win_read = RD_REG_DWORD(CRB_WINDOW_2M + ha->nx_pcibase);
 	if (win_read != ha->crb_win) {
 		ql_dbg(ql_dbg_p3p, vha, 0xb000,
 		    "%s: Written crbwin (0x%x) "
 		    "!= Read crbwin (0x%x), off=0x%lx.\n",
-		    __func__, ha->crb_win, win_read, *off);
+		    __func__, ha->crb_win, win_read, off_in);
 	}
-	*off = (*off & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase;
+	*off_out = (off_in & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase;
 }
 
 static inline unsigned long
@@ -417,29 +416,30 @@ qla82xx_pci_set_crbwindow(struct qla_hw_data *ha, u64 off)
 }
 
 static int
-qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong *off)
+qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
+			    void __iomem **off_out)
 {
 	struct crb_128M_2M_sub_block_map *m;
 
-	if (*off >= QLA82XX_CRB_MAX)
+	if (off_in >= QLA82XX_CRB_MAX)
 		return -1;
 
-	if (*off >= QLA82XX_PCI_CAMQM && (*off < QLA82XX_PCI_CAMQM_2M_END)) {
-		*off = (*off - QLA82XX_PCI_CAMQM) +
+	if (off_in >= QLA82XX_PCI_CAMQM && off_in < QLA82XX_PCI_CAMQM_2M_END) {
+		*off_out = (off_in - QLA82XX_PCI_CAMQM) +
 		    QLA82XX_PCI_CAMQM_2M_BASE + ha->nx_pcibase;
 		return 0;
 	}
 
-	if (*off < QLA82XX_PCI_CRBSPACE)
+	if (off_in < QLA82XX_PCI_CRBSPACE)
 		return -1;
 
-	*off -= QLA82XX_PCI_CRBSPACE;
+	*off_out = (void __iomem *)(off_in - QLA82XX_PCI_CRBSPACE);
 
 	/* Try direct map */
-	m = &crb_128M_2M_map[CRB_BLK(*off)].sub_block[CRB_SUBBLK(*off)];
+	m = &crb_128M_2M_map[CRB_BLK(off_in)].sub_block[CRB_SUBBLK(off_in)];
 
-	if (m->valid && (m->start_128M <= *off) && (m->end_128M > *off)) {
-		*off = *off + m->start_2M - m->start_128M + ha->nx_pcibase;
+	if (m->valid && (m->start_128M <= off_in) && (m->end_128M > off_in)) {
+		*off_out = off_in + m->start_2M - m->start_128M + ha->nx_pcibase;
 		return 0;
 	}
 	/* Not in direct map, use crb window */
@@ -465,19 +465,20 @@ static int qla82xx_crb_win_lock(struct qla_hw_data *ha)
 }
 
 int
-qla82xx_wr_32(struct qla_hw_data *ha, ulong off, u32 data)
+qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u32 data)
 {
+	void __iomem *off;
 	unsigned long flags = 0;
 	int rv;
 
-	rv = qla82xx_pci_get_crb_addr_2M(ha, &off);
+	rv = qla82xx_pci_get_crb_addr_2M(ha, off_in, &off);
 
 	BUG_ON(rv == -1);
 
 	if (rv == 1) {
 		write_lock_irqsave(&ha->hw_lock, flags);
 		qla82xx_crb_win_lock(ha);
-		qla82xx_pci_set_crbwindow_2M(ha, &off);
+		qla82xx_pci_set_crbwindow_2M(ha, off_in, &off);
 	}
 
 	writel(data, (void __iomem *)off);
@@ -490,22 +491,23 @@ qla82xx_wr_32(struct qla_hw_data *ha, ulong off, u32 data)
 }
 
 int
-qla82xx_rd_32(struct qla_hw_data *ha, ulong off)
+qla82xx_rd_32(struct qla_hw_data *ha, ulong off_in)
 {
+	void __iomem *off;
 	unsigned long flags = 0;
 	int rv;
 	u32 data;
 
-	rv = qla82xx_pci_get_crb_addr_2M(ha, &off);
+	rv = qla82xx_pci_get_crb_addr_2M(ha, off_in, &off);
 
 	BUG_ON(rv == -1);
 
 	if (rv == 1) {
 		write_lock_irqsave(&ha->hw_lock, flags);
 		qla82xx_crb_win_lock(ha);
-		qla82xx_pci_set_crbwindow_2M(ha, &off);
+		qla82xx_pci_set_crbwindow_2M(ha, off_in, &off);
 	}
-	data = RD_REG_DWORD((void __iomem *)off);
+	data = RD_REG_DWORD(off);
 
 	if (rv == 1) {
 		qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_UNLOCK));
@@ -919,20 +921,18 @@ qla82xx_md_rw_32(struct qla_hw_data *ha, uint32_t off, u32 data, uint8_t flag)
 {
 	uint32_t  off_value, rval = 0;
 
-	WRT_REG_DWORD((void __iomem *)(CRB_WINDOW_2M + ha->nx_pcibase),
-	    (off & 0xFFFF0000));
+	WRT_REG_DWORD(CRB_WINDOW_2M + ha->nx_pcibase, off & 0xFFFF0000);
 
 	/* Read back value to make sure write has gone through */
-	RD_REG_DWORD((void __iomem *)(CRB_WINDOW_2M + ha->nx_pcibase));
+	RD_REG_DWORD(CRB_WINDOW_2M + ha->nx_pcibase);
 	off_value  = (off & 0x0000FFFF);
 
 	if (flag)
-		WRT_REG_DWORD((void __iomem *)
-		    (off_value + CRB_INDIRECT_2M + ha->nx_pcibase),
-		    data);
+		WRT_REG_DWORD(off_value + CRB_INDIRECT_2M + ha->nx_pcibase,
+			      data);
 	else
-		rval = RD_REG_DWORD((void __iomem *)
-		    (off_value + CRB_INDIRECT_2M + ha->nx_pcibase));
+		rval = RD_REG_DWORD(off_value + CRB_INDIRECT_2M +
+				    ha->nx_pcibase);
 
 	return rval;
 }
@@ -1660,8 +1660,7 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
 	}
 
 	len = pci_resource_len(ha->pdev, 0);
-	ha->nx_pcibase =
-	    (unsigned long)ioremap(pci_resource_start(ha->pdev, 0), len);
+	ha->nx_pcibase = ioremap(pci_resource_start(ha->pdev, 0), len);
 	if (!ha->nx_pcibase) {
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x000e,
 		    "Cannot remap pcibase MMIO, aborting.\n");
@@ -1670,17 +1669,13 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
 
 	/* Mapping of IO base pointer */
 	if (IS_QLA8044(ha)) {
-		ha->iobase =
-		    (device_reg_t *)((uint8_t *)ha->nx_pcibase);
+		ha->iobase = ha->nx_pcibase;
 	} else if (IS_QLA82XX(ha)) {
-		ha->iobase =
-		    (device_reg_t *)((uint8_t *)ha->nx_pcibase +
-			0xbc000 + (ha->pdev->devfn << 11));
+		ha->iobase = ha->nx_pcibase + 0xbc000 + (ha->pdev->devfn << 11);
 	}
 
 	if (!ql2xdbwr) {
-		ha->nxdb_wr_ptr =
-		    (unsigned long)ioremap((pci_resource_start(ha->pdev, 4) +
+		ha->nxdb_wr_ptr = ioremap((pci_resource_start(ha->pdev, 4) +
 		    (ha->pdev->devfn << 12)), 4);
 		if (!ha->nxdb_wr_ptr) {
 			ql_log_pci(ql_log_fatal, ha->pdev, 0x000f,
@@ -1691,10 +1686,10 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
 		/* Mapping of IO base pointer,
 		 * door bell read and write pointer
 		 */
-		ha->nxdb_rd_ptr = (uint8_t *) ha->nx_pcibase + (512 * 1024) +
+		ha->nxdb_rd_ptr = ha->nx_pcibase + (512 * 1024) +
 		    (ha->pdev->devfn * 8);
 	} else {
-		ha->nxdb_wr_ptr = (ha->pdev->devfn == 6 ?
+		ha->nxdb_wr_ptr = (void __iomem *)(ha->pdev->devfn == 6 ?
 			QLA82XX_CAMRAM_DB1 :
 			QLA82XX_CAMRAM_DB2);
 	}
@@ -1704,12 +1699,12 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
 	ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc006,
 	    "nx_pci_base=%p iobase=%p "
 	    "max_req_queues=%d msix_count=%d.\n",
-	    (void *)ha->nx_pcibase, ha->iobase,
+	    ha->nx_pcibase, ha->iobase,
 	    ha->max_req_queues, ha->msix_count);
 	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0010,
 	    "nx_pci_base=%p iobase=%p "
 	    "max_req_queues=%d msix_count=%d.\n",
-	    (void *)ha->nx_pcibase, ha->iobase,
+	    ha->nx_pcibase, ha->iobase,
 	    ha->max_req_queues, ha->msix_count);
 	return 0;
 
@@ -1774,9 +1769,9 @@ void qla82xx_config_rings(struct scsi_qla_host *vha)
 	icb->response_q_address[0] = cpu_to_le32(LSD(rsp->dma));
 	icb->response_q_address[1] = cpu_to_le32(MSD(rsp->dma));
 
-	WRT_REG_DWORD((unsigned long  __iomem *)&reg->req_q_out[0], 0);
-	WRT_REG_DWORD((unsigned long  __iomem *)&reg->rsp_q_in[0], 0);
-	WRT_REG_DWORD((unsigned long  __iomem *)&reg->rsp_q_out[0], 0);
+	WRT_REG_DWORD(&reg->req_q_out[0], 0);
+	WRT_REG_DWORD(&reg->rsp_q_in[0], 0);
+	WRT_REG_DWORD(&reg->rsp_q_out[0], 0);
 }
 
 static int
@@ -2799,13 +2794,12 @@ qla82xx_start_iocbs(scsi_qla_host_t *vha)
 
 	dbval = dbval | (req->id << 8) | (req->ring_index << 16);
 	if (ql2xdbwr)
-		qla82xx_wr_32(ha, ha->nxdb_wr_ptr, dbval);
+		qla82xx_wr_32(ha, (unsigned long)ha->nxdb_wr_ptr, dbval);
 	else {
-		WRT_REG_DWORD((unsigned long __iomem *)ha->nxdb_wr_ptr, dbval);
+		WRT_REG_DWORD(ha->nxdb_wr_ptr, dbval);
 		wmb();
-		while (RD_REG_DWORD((void __iomem *)ha->nxdb_rd_ptr) != dbval) {
-			WRT_REG_DWORD((unsigned long  __iomem *)ha->nxdb_wr_ptr,
-				dbval);
+		while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
+			WRT_REG_DWORD(ha->nxdb_wr_ptr, dbval);
 			wmb();
 		}
 	}
@@ -3836,8 +3830,7 @@ qla82xx_minidump_process_rdocm(scsi_qla_host_t *vha,
 	loop_cnt = ocm_hdr->op_count;
 
 	for (i = 0; i < loop_cnt; i++) {
-		r_value = RD_REG_DWORD((void __iomem *)
-		    (r_addr + ha->nx_pcibase));
+		r_value = RD_REG_DWORD(r_addr + ha->nx_pcibase);
 		*data_ptr++ = cpu_to_le32(r_value);
 		r_addr += r_stride;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 0fb4ed1..2dae823 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -137,39 +137,39 @@ qla27xx_insertbuf(void *mem, ulong size, void *buf, ulong *len)
 }
 
 static inline void
-qla27xx_read8(void *window, void *buf, ulong *len)
+qla27xx_read8(void __iomem *window, void *buf, ulong *len)
 {
 	uint8_t value = ~0;
 
 	if (buf) {
-		value = RD_REG_BYTE((__iomem void *)window);
+		value = RD_REG_BYTE(window);
 	}
 	qla27xx_insert32(value, buf, len);
 }
 
 static inline void
-qla27xx_read16(void *window, void *buf, ulong *len)
+qla27xx_read16(void __iomem *window, void *buf, ulong *len)
 {
 	uint16_t value = ~0;
 
 	if (buf) {
-		value = RD_REG_WORD((__iomem void *)window);
+		value = RD_REG_WORD(window);
 	}
 	qla27xx_insert32(value, buf, len);
 }
 
 static inline void
-qla27xx_read32(void *window, void *buf, ulong *len)
+qla27xx_read32(void __iomem *window, void *buf, ulong *len)
 {
 	uint32_t value = ~0;
 
 	if (buf) {
-		value = RD_REG_DWORD((__iomem void *)window);
+		value = RD_REG_DWORD(window);
 	}
 	qla27xx_insert32(value, buf, len);
 }
 
-static inline void (*qla27xx_read_vector(uint width))(void *, void *, ulong *)
+static inline void (*qla27xx_read_vector(uint width))(void __iomem*, void *, ulong *)
 {
 	return
 	    (width == 1) ? qla27xx_read8 :
@@ -181,7 +181,7 @@ static inline void
 qla27xx_read_reg(__iomem struct device_reg_24xx *reg,
 	uint offset, void *buf, ulong *len)
 {
-	void *window = (void *)reg + offset;
+	void __iomem *window = (void __iomem *)reg + offset;
 
 	qla27xx_read32(window, buf, len);
 }
@@ -202,8 +202,8 @@ qla27xx_read_window(__iomem struct device_reg_24xx *reg,
 	uint32_t addr, uint offset, uint count, uint width, void *buf,
 	ulong *len)
 {
-	void *window = (void *)reg + offset;
-	void (*readn)(void *, void *, ulong *) = qla27xx_read_vector(width);
+	void __iomem *window = (void __iomem *)reg + offset;
+	void (*readn)(void __iomem*, void *, ulong *) = qla27xx_read_vector(width);
 
 	qla27xx_write_reg(reg, IOBASE_ADDR, addr, buf);
 	while (count--) {
-- 
2.1.2

