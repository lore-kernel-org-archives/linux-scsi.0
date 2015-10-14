From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  2/2] qla2xxx: fix rwlock recursion
Date: Wed, 14 Oct 2015 11:57:41 -0400
Message-ID: <1444838261-20990-3-git-send-email-himanshu.madhani@qlogic.com>
References: <1444838261-20990-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:2755 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbbJNQgX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Oct 2015 12:36:23 -0400
In-Reply-To: <1444838261-20990-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@lst.de
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

This patch fixes rwlock recursion introduced for ISP82XX by
commit 8dfa4b5a ("qla2xxx: Fix sparse annotations")

Original patch fixes other sparse warnings which did not cause
any regression. So instead of reverting complete patch, this patch
will revert only part which caused recursion.

stack track has following signature

kernel:BUG: rwlock recursion on CPU#2, insmod/39333, ffff8803e998cb28
kernel: ffffffff8181d7de ffff88040f2af8a8 ffffffff810a8047 ffff8803e998cb28
kernel: ffff8803e998cb40 ffff88040f2af8c8 ffffffff810a833a 0000000000000086
kernel: Call Trace:
kernel: [<ffffffff812bce44>] dump_stack+0x48/0x64
kernel: [<ffffffff810a8047>] rwlock_bug+0x67/0x70
kernel: [<ffffffff810a833a>] do_raw_write_lock+0x8a/0xa0
kernel: [<ffffffff815f3033>] _raw_write_lock_irqsave+0x63/0x80
kernel: [<ffffffffa08087c8>] ? qla82xx_rd_32+0xe8/0x140 [qla2xxx]
kernel: [<ffffffffa08087c8>] qla82xx_rd_32+0xe8/0x140 [qla2xxx]
kernel: [<ffffffffa0808845>] qla82xx_crb_win_lock+0x25/0x60 [qla2xxx]
kernel: [<ffffffffa0808976>] qla82xx_wr_32+0xf6/0x150 [qla2xxx]
kernel: [<ffffffffa0808aa4>] ? qla82xx_disable_intrs+0x34/0x80 [qla2xxx]
kernel: [<ffffffffa0808ac0>] qla82xx_disable_intrs+0x50/0x80 [qla2xxx]
kernel: [<ffffffffa080630a>] qla82xx_reset_chip+0x1a/0x20 [qla2xxx]
kernel: [<ffffffffa07d6ef2>] qla2x00_initialize_adapter+0x132/0x420 [qla2xxx]
kernel: [<ffffffffa08087c8>] ? qla82xx_rd_32+0xe8/0x140 [qla2xxx]
kernel: [<ffffffffa08087c8>] qla82xx_rd_32+0xe8/0x140 [qla2xxx]
kernel: [<ffffffffa0808845>] qla82xx_crb_win_lock+0x25/0x60 [qla2xxx]
kernel: [<ffffffffa0808976>] qla82xx_wr_32+0xf6/0x150 [qla2xxx]
kernel: [<ffffffffa0808aa4>] ? qla82xx_disable_intrs+0x34/0x80 [qla2xxx]
kernel: [<ffffffffa0808ac0>] qla82xx_disable_intrs+0x50/0x80 [qla2xxx]
kernel: [<ffffffffa080630a>] qla82xx_reset_chip+0x1a/0x20 [qla2xxx]
kernel: [<ffffffffa07d6ef2>] qla2x00_initialize_adapter+0x132/0x420 [qla2xxx]
kernel: [<ffffffffa07c964e>] qla2x00_probe_one+0xefe/0x2130 [qla2xxx]
kernel: [<ffffffff813ee31c>] ? __pm_runtime_resume+0x6c/0x90
kernel: [<ffffffff8130052c>] local_pci_probe+0x4c/0xa0
kernel: [<ffffffff81300603>] pci_call_probe+0x83/0xa0
kernel: [<ffffffff813008cf>] pci_device_probe+0x7f/0xb0
kernel: [<ffffffff813e2e83>] really_probe+0x133/0x390
kernel: [<ffffffff813e3139>] driver_probe_device+0x59/0xd0
kernel: [<ffffffff813e3251>] __driver_attach+0xa1/0xb0
kernel: [<ffffffff813e31b0>] ? driver_probe_device+0xd0/0xd0
kernel: [<ffffffff813e0cdd>] bus_for_each_dev+0x8d/0xb0
kernel: [<ffffffff813e28ee>] driver_attach+0x1e/0x20
kernel: [<ffffffff813e2252>] bus_add_driver+0x1d2/0x290
kernel: [<ffffffff813e3970>] driver_register+0x60/0xe0
kernel: [<ffffffff813009e4>] __pci_register_driver+0x64/0x70
kernel: [<ffffffffa04bc1cb>] qla2x00_module_init+0x1cb/0x21b [qla2xxx]
kernel: [<ffffffffa04bc000>] ? 0xffffffffa04bc000
kernel: [<ffffffff8100027d>] do_one_initcall+0xad/0x1c0
kernel: [<ffffffff810e2859>] do_init_module+0x69/0x210
kernel: [<ffffffff810e4e5c>] load_module+0x5cc/0x750
kernel: [<ffffffff810e1980>] ? mod_sysfs_teardown+0x140/0x140
kernel: [<ffffffff812c9565>] ? copy_user_enhanced_fast_string+0x5/0x10
kernel: [<ffffffff810e12f0>] ? module_sect_show+0x30/0x30
kernel: [<ffffffff810e1a8d>] ? copy_module_from_user+0x8d/0xf0
kernel: [<ffffffff810e5162>] SyS_init_module+0x92/0xc0
kernel: [<ffffffff815f37d7>] entry_SYSCALL_64_fastpath+0x12/0x6f

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   58 ++++++++++++++++++++--------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index eb0cc54..96f9b39 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -347,31 +347,33 @@ char *qdev_state(uint32_t dev_state)
 }
 
 /*
- * In: 'off_in' is offset from CRB space in 128M pci map
- * Out: 'off_out' is 2M pci map addr
+ * In: 'off' is offset from CRB space in 128M pci map
+ * Out: 'off' is 2M pci map addr
  * side effect: lock crb window
  */
 static void
-qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong off_in,
-			     void __iomem **off_out)
+qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong *off)
 {
 	u32 win_read;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
-	ha->crb_win = CRB_HI(off_in);
-	writel(ha->crb_win, CRB_WINDOW_2M + ha->nx_pcibase);
+	ha->crb_win = CRB_HI(*off);
+	writel(ha->crb_win,
+	    (void __iomem *)(CRB_WINDOW_2M + ha->nx_pcibase));
 
 	/* Read back value to make sure write has gone through before trying
 	 * to use it.
 	 */
-	win_read = RD_REG_DWORD(CRB_WINDOW_2M + ha->nx_pcibase);
+	win_read = RD_REG_DWORD((void __iomem *)
+	    (CRB_WINDOW_2M + ha->nx_pcibase));
 	if (win_read != ha->crb_win) {
 		ql_dbg(ql_dbg_p3p, vha, 0xb000,
 		    "%s: Written crbwin (0x%x) "
 		    "!= Read crbwin (0x%x), off=0x%lx.\n",
-		    __func__, ha->crb_win, win_read, off_in);
+		    __func__, ha->crb_win, win_read, *off);
 	}
-	*off_out = (off_in & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase;
+	*off = (*off & MASK(16)) + CRB_INDIRECT_2M +
+	    (unsigned long)ha->nx_pcibase;
 }
 
 static inline unsigned long
@@ -416,30 +418,30 @@ qla82xx_pci_set_crbwindow(struct qla_hw_data *ha, u64 off)
 }
 
 static int
-qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
-			    void __iomem **off_out)
+qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong *off)
 {
 	struct crb_128M_2M_sub_block_map *m;
 
-	if (off_in >= QLA82XX_CRB_MAX)
+	if (*off >= QLA82XX_CRB_MAX)
 		return -1;
 
-	if (off_in >= QLA82XX_PCI_CAMQM && off_in < QLA82XX_PCI_CAMQM_2M_END) {
-		*off_out = (off_in - QLA82XX_PCI_CAMQM) +
-		    QLA82XX_PCI_CAMQM_2M_BASE + ha->nx_pcibase;
+	if (*off >= QLA82XX_PCI_CAMQM && (*off < QLA82XX_PCI_CAMQM_2M_END)) {
+		*off = (*off - QLA82XX_PCI_CAMQM) +
+		    QLA82XX_PCI_CAMQM_2M_BASE + (unsigned long)ha->nx_pcibase;
 		return 0;
 	}
 
-	if (off_in < QLA82XX_PCI_CRBSPACE)
+	if (*off < QLA82XX_PCI_CRBSPACE)
 		return -1;
 
-	*off_out = (void __iomem *)(off_in - QLA82XX_PCI_CRBSPACE);
+	*off -= QLA82XX_PCI_CRBSPACE;
 
 	/* Try direct map */
-	m = &crb_128M_2M_map[CRB_BLK(off_in)].sub_block[CRB_SUBBLK(off_in)];
+	m = &crb_128M_2M_map[CRB_BLK(*off)].sub_block[CRB_SUBBLK(*off)];
 
-	if (m->valid && (m->start_128M <= off_in) && (m->end_128M > off_in)) {
-		*off_out = off_in + m->start_2M - m->start_128M + ha->nx_pcibase;
+	if (m->valid && (m->start_128M <= *off) && (m->end_128M > *off)) {
+		*off = *off + m->start_2M - m->start_128M +
+		    (unsigned long) ha->nx_pcibase;
 		return 0;
 	}
 	/* Not in direct map, use crb window */
@@ -465,13 +467,12 @@ static int qla82xx_crb_win_lock(struct qla_hw_data *ha)
 }
 
 int
-qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u32 data)
+qla82xx_wr_32(struct qla_hw_data *ha, ulong off, u32 data)
 {
-	void __iomem *off;
 	unsigned long flags = 0;
 	int rv;
 
-	rv = qla82xx_pci_get_crb_addr_2M(ha, off_in, &off);
+	rv = qla82xx_pci_get_crb_addr_2M(ha, &off);
 
 	BUG_ON(rv == -1);
 
@@ -480,7 +481,7 @@ qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u32 data)
 		write_lock_irqsave(&ha->hw_lock, flags);
 #endif
 		qla82xx_crb_win_lock(ha);
-		qla82xx_pci_set_crbwindow_2M(ha, off_in, &off);
+		qla82xx_pci_set_crbwindow_2M(ha, &off);
 	}
 
 	writel(data, (void __iomem *)off);
@@ -495,14 +496,13 @@ qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u32 data)
 }
 
 int
-qla82xx_rd_32(struct qla_hw_data *ha, ulong off_in)
+qla82xx_rd_32(struct qla_hw_data *ha, ulong off)
 {
-	void __iomem *off;
 	unsigned long flags = 0;
 	int rv;
 	u32 data;
 
-	rv = qla82xx_pci_get_crb_addr_2M(ha, off_in, &off);
+	rv = qla82xx_pci_get_crb_addr_2M(ha, &off);
 
 	BUG_ON(rv == -1);
 
@@ -511,9 +511,9 @@ qla82xx_rd_32(struct qla_hw_data *ha, ulong off_in)
 		write_lock_irqsave(&ha->hw_lock, flags);
 #endif
 		qla82xx_crb_win_lock(ha);
-		qla82xx_pci_set_crbwindow_2M(ha, off_in, &off);
+		qla82xx_pci_set_crbwindow_2M(ha, &off);
 	}
-	data = RD_REG_DWORD(off);
+	data = RD_REG_DWORD((void __iomem *)off);
 
 	if (rv == 1) {
 		qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_UNLOCK));
-- 
1.7.7

