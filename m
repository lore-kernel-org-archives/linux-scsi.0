From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: 2.6.24 regression w/ QLA2300
Date: Tue, 05 Feb 2008 10:56:38 -0500
Message-ID: <47A88736.6090706@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:7951 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYBEP4x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 10:56:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

During this merge:

commit 9b73e76f3cf63379dcf45fcd4f112f5812418d0a
Merge: 50d9a12... 23c3e29...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jan 25 17:19:08 2008 -0800

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6

    * git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6: (200 commits)

I believe a regression was introduced. I'm running on a 4-way IA64,
with straight 2.6.24 and 2 dual-port cards:

40:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
40:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
c0:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
c0:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)

the adapters failed initialization. In particular, I narrowed it down
to failing the qla2x00_mbox_command call within qla2x00_init_firmware
function. I went and removed the qla2x00-related parts of this (large-ish)
merge, and the 4 ports initialized just fine.

Specifically, reverting the "patch" below enabled the devices to initialize properly.

If need be, I'm certainly willing to help narrow down to the specific part in
this patch...

Alan D. Brunelle
HP OSLO S&P

---
diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index 71ddb5d..c51fd1f 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,4 +1,4 @@
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
-		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o
+		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o
 
 obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fb388b8..adf9732 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -9,7 +9,7 @@
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
 
-int qla24xx_vport_disable(struct fc_vport *, bool);
+static int qla24xx_vport_disable(struct fc_vport *, bool);
 
 /* SYSFS attributes --------------------------------------------------------- */
 
@@ -958,7 +958,7 @@ qla2x00_issue_lip(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *ha = shost_priv(shost);
 
-	set_bit(LOOP_RESET_NEEDED, &ha->dpc_flags);
+	qla2x00_loop_reset(ha);
 	return 0;
 }
 
@@ -967,35 +967,51 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *ha = shost_priv(shost);
 	int rval;
-	uint16_t mb_stat[1];
-	link_stat_t stat_buf;
+	struct link_statistics *stats;
+	dma_addr_t stats_dma;
 	struct fc_host_statistics *pfc_host_stat;
 
-	rval = QLA_FUNCTION_FAILED;
 	pfc_host_stat = &ha->fc_host_stat;
 	memset(pfc_host_stat, -1, sizeof(struct fc_host_statistics));
 
+	stats = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &stats_dma);
+	if (stats == NULL) {
+		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
+		    __func__, ha->host_no));
+		goto done;
+	}
+	memset(stats, 0, DMA_POOL_SIZE);
+
+	rval = QLA_FUNCTION_FAILED;
 	if (IS_FWI2_CAPABLE(ha)) {
-		rval = qla24xx_get_isp_stats(ha, (uint32_t *)&stat_buf,
-		    sizeof(stat_buf) / 4, mb_stat);
+		rval = qla24xx_get_isp_stats(ha, stats, stats_dma);
 	} else if (atomic_read(&ha->loop_state) == LOOP_READY &&
 		    !test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) &&
 		    !test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) &&
 		    !ha->dpc_active) {
 		/* Must be in a 'READY' state for statistics retrieval. */
-		rval = qla2x00_get_link_status(ha, ha->loop_id, &stat_buf,
-		    mb_stat);
+		rval = qla2x00_get_link_status(ha, ha->loop_id, stats,
+		    stats_dma);
 	}
 
 	if (rval != QLA_SUCCESS)
-		goto done;
+		goto done_free;
+
+	pfc_host_stat->link_failure_count = stats->link_fail_cnt;
+	pfc_host_stat->loss_of_sync_count = stats->loss_sync_cnt;
+	pfc_host_stat->loss_of_signal_count = stats->loss_sig_cnt;
+	pfc_host_stat->prim_seq_protocol_err_count = stats->prim_seq_err_cnt;
+	pfc_host_stat->invalid_tx_word_count = stats->inval_xmit_word_cnt;
+	pfc_host_stat->invalid_crc_count = stats->inval_crc_cnt;
+	if (IS_FWI2_CAPABLE(ha)) {
+		pfc_host_stat->tx_frames = stats->tx_frames;
+		pfc_host_stat->rx_frames = stats->rx_frames;
+		pfc_host_stat->dumped_frames = stats->dumped_frames;
+		pfc_host_stat->nos_count = stats->nos_rcvd;
+	}
 
-	pfc_host_stat->link_failure_count = stat_buf.link_fail_cnt;
-	pfc_host_stat->loss_of_sync_count = stat_buf.loss_sync_cnt;
-	pfc_host_stat->loss_of_signal_count = stat_buf.loss_sig_cnt;
-	pfc_host_stat->prim_seq_protocol_err_count = stat_buf.prim_seq_err_cnt;
-	pfc_host_stat->invalid_tx_word_count = stat_buf.inval_xmit_word_cnt;
-	pfc_host_stat->invalid_crc_count = stat_buf.inval_crc_cnt;
+done_free:
+        dma_pool_free(ha->s_dma_pool, stats, stats_dma);
 done:
 	return pfc_host_stat;
 }
@@ -1113,7 +1129,7 @@ vport_create_failed_2:
 	return FC_VPORT_FAILED;
 }
 
-int
+static int
 qla24xx_vport_delete(struct fc_vport *fc_vport)
 {
 	scsi_qla_host_t *ha = shost_priv(fc_vport->shost);
@@ -1124,7 +1140,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	down(&ha->vport_sem);
 	ha->cur_vport_count--;
-	clear_bit(vha->vp_idx, (unsigned long *)ha->vp_idx_map);
+	clear_bit(vha->vp_idx, ha->vp_idx_map);
 	up(&ha->vport_sem);
 
 	kfree(vha->node_name);
@@ -1146,7 +1162,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	return 0;
 }
 
-int
+static int
 qla24xx_vport_disable(struct fc_vport *fc_vport, bool disable)
 {
 	scsi_qla_host_t *vha = fc_vport->dd_data;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index eaa04da..d88e98c 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1051,6 +1051,7 @@ qla25xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	struct qla25xx_fw_dump *fw;
 	uint32_t	ext_mem_cnt;
 	void		*nxt;
+	struct qla2xxx_fce_chain *fcec;
 
 	risc_address = ext_mem_cnt = 0;
 	flags = 0;
@@ -1321,10 +1322,31 @@ qla25xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	if (rval != QLA_SUCCESS)
 		goto qla25xx_fw_dump_failed_0;
 
+	/* Fibre Channel Trace Buffer. */
 	nxt = qla2xxx_copy_queues(ha, nxt);
 	if (ha->eft)
 		memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
 
+	/* Fibre Channel Event Buffer. */
+	if (!ha->fce)
+		goto qla25xx_fw_dump_failed_0;
+
+	ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
+
+	fcec = nxt + ntohl(ha->fw_dump->eft_size);
+	fcec->type = __constant_htonl(DUMP_CHAIN_FCE | DUMP_CHAIN_LAST);
+	fcec->chain_size = htonl(sizeof(struct qla2xxx_fce_chain) +
+	    fce_calc_size(ha->fce_bufs));
+	fcec->size = htonl(fce_calc_size(ha->fce_bufs));
+	fcec->addr_l = htonl(LSD(ha->fce_dma));
+	fcec->addr_h = htonl(MSD(ha->fce_dma));
+
+	iter_reg = fcec->eregs;
+	for (cnt = 0; cnt < 8; cnt++)
+		*iter_reg++ = htonl(ha->fce_mb[cnt]);
+
+	memcpy(iter_reg, ha->fce, ntohl(fcec->size));
+
 qla25xx_fw_dump_failed_0:
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
@@ -1428,21 +1450,6 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd * cmd)
 	printk("  sp flags=0x%x\n", sp->flags);
 }
 
-void
-qla2x00_dump_pkt(void *pkt)
-{
-	uint32_t i;
-	uint8_t *data = (uint8_t *) pkt;
-
-	for (i = 0; i < 64; i++) {
-		if (!(i % 4))
-			printk("\n%02x: ", i);
-
-		printk("%02x ", data[i]);
-	}
-	printk("\n");
-}
-
 #if defined(QL_DEBUG_ROUTINES)
 /*
  * qla2x00_formatted_dump_buffer
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index a50ecf0..524598a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -256,6 +256,25 @@ struct qla25xx_fw_dump {
 #define EFT_BYTES_PER_BUFFER	0x4000
 #define EFT_SIZE		((EFT_BYTES_PER_BUFFER) * (EFT_NUM_BUFFERS))
 
+#define FCE_NUM_BUFFERS		64
+#define FCE_BYTES_PER_BUFFER	0x400
+#define FCE_SIZE		((FCE_BYTES_PER_BUFFER) * (FCE_NUM_BUFFERS))
+#define fce_calc_size(b)	((FCE_BYTES_PER_BUFFER) * (b))
+
+struct qla2xxx_fce_chain {
+	uint32_t type;
+	uint32_t chain_size;
+
+	uint32_t size;
+	uint32_t addr_l;
+	uint32_t addr_h;
+	uint32_t eregs[8];
+};
+
+#define DUMP_CHAIN_VARIANT	0x80000000
+#define DUMP_CHAIN_FCE		0x7FFFFAF0
+#define DUMP_CHAIN_LAST		0x80000000
+
 struct qla2xxx_fw_dump {
 	uint8_t signature[4];
 	uint32_t version;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 04e8cbc..6f129da 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -623,9 +623,6 @@ typedef struct {
 #define MBC_GET_LINK_PRIV_STATS		0x6d	/* Get link & private data. */
 #define MBC_SET_VENDOR_ID		0x76	/* Set Vendor ID. */
 
-#define TC_ENABLE			4
-#define TC_DISABLE			5
-
 /* Firmware return data sizes */
 #define FCAL_MAP_SIZE	128
 
@@ -862,14 +859,20 @@ typedef struct {
 #define GLSO_SEND_RPS	BIT_0
 #define GLSO_USE_DID	BIT_3
 
-typedef struct {
-	uint32_t	link_fail_cnt;
-	uint32_t	loss_sync_cnt;
-	uint32_t	loss_sig_cnt;
-	uint32_t	prim_seq_err_cnt;
-	uint32_t	inval_xmit_word_cnt;
-	uint32_t	inval_crc_cnt;
-} link_stat_t;
+struct link_statistics {
+	uint32_t link_fail_cnt;
+	uint32_t loss_sync_cnt;
+	uint32_t loss_sig_cnt;
+	uint32_t prim_seq_err_cnt;
+	uint32_t inval_xmit_word_cnt;
+	uint32_t inval_crc_cnt;
+	uint32_t unused1[0x1b];
+	uint32_t tx_frames;
+	uint32_t rx_frames;
+	uint32_t dumped_frames;
+	uint32_t unused2[2];
+	uint32_t nos_rcvd;
+};
 
 /*
  * NVRAM Command values.
@@ -2116,14 +2119,6 @@ struct qla_msix_entry {
 
 #define	WATCH_INTERVAL		1       /* number of seconds */
 
-/* NPIV */
-#define MAX_MULTI_ID_LOOP                     126
-#define MAX_MULTI_ID_FABRIC                    64
-#define MAX_NUM_VPORT_LOOP                      (MAX_MULTI_ID_LOOP - 1)
-#define MAX_NUM_VPORT_FABRIC                    (MAX_MULTI_ID_FABRIC - 1)
-#define MAX_NUM_VHBA_LOOP                       (MAX_MULTI_ID_LOOP - 1)
-#define MAX_NUM_VHBA_FABRIC                     (MAX_MULTI_ID_FABRIC - 1)
-
 /*
  * Linux Host Adapter structure
  */
@@ -2161,6 +2156,7 @@ typedef struct scsi_qla_host {
 		uint32_t	gpsc_supported		:1;
 		uint32_t        vsan_enabled            :1;
 		uint32_t	npiv_supported		:1;
+		uint32_t	fce_enabled		:1;
 	} flags;
 
 	atomic_t	loop_state;
@@ -2273,8 +2269,7 @@ typedef struct scsi_qla_host {
 
 	int		bars;
 	device_reg_t __iomem *iobase;		/* Base I/O address */
-	unsigned long	pio_address;
-	unsigned long	pio_length;
+	resource_size_t pio_address;
 #define MIN_IOBASE_LEN		0x100
 
 	/* ISP ring lock, rings, and indexes */
@@ -2416,9 +2411,9 @@ typedef struct scsi_qla_host {
 #define MBX_INTR_WAIT	2
 #define MBX_UPDATE_FLASH_ACTIVE	3
 
-	struct semaphore mbx_cmd_sem;	/* Serialialize mbx access */
 	struct semaphore vport_sem;	/* Virtual port synchronization */
-	struct semaphore mbx_intr_sem;  /* Used for completion notification */
+	struct completion mbx_cmd_comp;	/* Serialize mbx access */
+	struct completion mbx_intr_comp;  /* Used for completion notification */
 
 	uint32_t	mbx_flags;
 #define  MBX_IN_PROGRESS	BIT_0
@@ -2455,6 +2450,15 @@ typedef struct scsi_qla_host {
 	dma_addr_t	eft_dma;
 	void		*eft;
 
+	struct dentry *dfs_dir;
+	struct dentry *dfs_fce;
+	dma_addr_t	fce_dma;
+	void		*fce;
+	uint32_t	fce_bufs;
+	uint16_t	fce_mb[8];
+	uint64_t	fce_wr, fce_rd;
+	struct mutex	fce_mutex;
+
 	uint8_t		host_str[16];
 	uint32_t	pci_attr;
 	uint16_t	chip_revision;
@@ -2507,7 +2511,7 @@ typedef struct scsi_qla_host {
 
 	struct list_head	vp_list;	/* list of VP */
 	struct fc_vport	*fc_vport;	/* holds fc_vport * for each vport */
-	uint8_t		vp_idx_map[16];
+	unsigned long	vp_idx_map[(MAX_MULTI_ID_FABRIC / 8) / sizeof(unsigned long)];
 	uint16_t        num_vhosts;	/* number of vports created */
 	uint16_t        num_vsans;	/* number of vsan created */
 	uint16_t        vp_idx;		/* vport ID */
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
new file mode 100644
index 0000000..1479c60
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -0,0 +1,175 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#include "qla_def.h"
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+static struct dentry *qla2x00_dfs_root;
+static atomic_t qla2x00_dfs_root_count;
+
+static int
+qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
+{
+	scsi_qla_host_t *ha = s->private;
+	uint32_t cnt;
+	uint32_t *fce;
+	uint64_t fce_start;
+
+	mutex_lock(&ha->fce_mutex);
+
+	seq_printf(s, "FCE Trace Buffer\n");
+	seq_printf(s, "In Pointer = %llx\n\n", ha->fce_wr);
+	seq_printf(s, "Base = %llx\n\n", (unsigned long long) ha->fce_dma);
+	seq_printf(s, "FCE Enable Registers\n");
+	seq_printf(s, "%08x %08x %08x %08x %08x %08x\n",
+	    ha->fce_mb[0], ha->fce_mb[2], ha->fce_mb[3], ha->fce_mb[4],
+	    ha->fce_mb[5], ha->fce_mb[6]);
+
+	fce = (uint32_t *) ha->fce;
+	fce_start = (unsigned long long) ha->fce_dma;
+	for (cnt = 0; cnt < fce_calc_size(ha->fce_bufs) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			seq_printf(s, "\n%llx: ",
+			    (unsigned long long)((cnt * 4) + fce_start));
+		else
+			seq_printf(s, " ");
+		seq_printf(s, "%08x", *fce++);
+	}
+
+	seq_printf(s, "\nEnd\n");
+
+	mutex_unlock(&ha->fce_mutex);
+
+	return 0;
+}
+
+static int
+qla2x00_dfs_fce_open(struct inode *inode, struct file *file)
+{
+	scsi_qla_host_t *ha = inode->i_private;
+	int rval;
+
+	if (!ha->flags.fce_enabled)
+		goto out;
+
+	mutex_lock(&ha->fce_mutex);
+
+	/* Pause tracing to flush FCE buffers. */
+	rval = qla2x00_disable_fce_trace(ha, &ha->fce_wr, &ha->fce_rd);
+	if (rval)
+		qla_printk(KERN_WARNING, ha,
+		    "DebugFS: Unable to disable FCE (%d).\n", rval);
+
+	ha->flags.fce_enabled = 0;
+
+	mutex_unlock(&ha->fce_mutex);
+out:
+	return single_open(file, qla2x00_dfs_fce_show, ha);
+}
+
+static int
+qla2x00_dfs_fce_release(struct inode *inode, struct file *file)
+{
+	scsi_qla_host_t *ha = inode->i_private;
+	int rval;
+
+	if (ha->flags.fce_enabled)
+		goto out;
+
+	mutex_lock(&ha->fce_mutex);
+
+	/* Re-enable FCE tracing. */
+	ha->flags.fce_enabled = 1;
+	memset(ha->fce, 0, fce_calc_size(ha->fce_bufs));
+	rval = qla2x00_enable_fce_trace(ha, ha->fce_dma, ha->fce_bufs,
+	    ha->fce_mb, &ha->fce_bufs);
+	if (rval) {
+		qla_printk(KERN_WARNING, ha,
+		    "DebugFS: Unable to reinitialize FCE (%d).\n", rval);
+		ha->flags.fce_enabled = 0;
+	}
+
+	mutex_unlock(&ha->fce_mutex);
+out:
+	return single_release(inode, file);
+}
+
+static const struct file_operations dfs_fce_ops = {
+	.open		= qla2x00_dfs_fce_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= qla2x00_dfs_fce_release,
+};
+
+int
+qla2x00_dfs_setup(scsi_qla_host_t *ha)
+{
+	if (!IS_QLA25XX(ha))
+		goto out;
+	if (!ha->fce)
+		goto out;
+
+	if (qla2x00_dfs_root)
+		goto create_dir;
+
+	atomic_set(&qla2x00_dfs_root_count, 0);
+	qla2x00_dfs_root = debugfs_create_dir(QLA2XXX_DRIVER_NAME, NULL);
+	if (!qla2x00_dfs_root) {
+		qla_printk(KERN_NOTICE, ha,
+		    "DebugFS: Unable to create root directory.\n");
+		goto out;
+	}
+
+create_dir:
+	if (ha->dfs_dir)
+		goto create_nodes;
+
+	mutex_init(&ha->fce_mutex);
+	ha->dfs_dir = debugfs_create_dir(ha->host_str, qla2x00_dfs_root);
+	if (!ha->dfs_dir) {
+		qla_printk(KERN_NOTICE, ha,
+		    "DebugFS: Unable to create ha directory.\n");
+		goto out;
+	}
+
+	atomic_inc(&qla2x00_dfs_root_count);
+
+create_nodes:
+	ha->dfs_fce = debugfs_create_file("fce", S_IRUSR, ha->dfs_dir, ha,
+	    &dfs_fce_ops);
+	if (!ha->dfs_fce) {
+		qla_printk(KERN_NOTICE, ha,
+		    "DebugFS: Unable to fce node.\n");
+		goto out;
+	}
+out:
+	return 0;
+}
+
+int
+qla2x00_dfs_remove(scsi_qla_host_t *ha)
+{
+	if (ha->dfs_fce) {
+		debugfs_remove(ha->dfs_fce);
+		ha->dfs_fce = NULL;
+	}
+
+	if (ha->dfs_dir) {
+		debugfs_remove(ha->dfs_dir);
+		ha->dfs_dir = NULL;
+		atomic_dec(&qla2x00_dfs_root_count);
+	}
+
+	if (atomic_read(&qla2x00_dfs_root_count) == 0 &&
+	    qla2x00_dfs_root) {
+		debugfs_remove(qla2x00_dfs_root);
+		qla2x00_dfs_root = NULL;
+	}
+
+	return 0;
+}
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 25364b1..9337e13 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -952,9 +952,31 @@ struct device_reg_24xx {
 	uint32_t iobase_sdata;
 };
 
+/* Trace Control *************************************************************/
+
+#define TC_AEN_DISABLE		0
+
+#define TC_EFT_ENABLE		4
+#define TC_EFT_DISABLE		5
+
+#define TC_FCE_ENABLE		8
+#define TC_FCE_OPTIONS		0
+#define TC_FCE_DEFAULT_RX_SIZE	2112
+#define TC_FCE_DEFAULT_TX_SIZE	2112
+#define TC_FCE_DISABLE		9
+#define TC_FCE_DISABLE_TRACE	BIT_0
+
 /* MID Support ***************************************************************/
 
-#define MAX_MID_VPS	125
+#define MIN_MULTI_ID_FABRIC	64	/* Must be power-of-2. */
+#define MAX_MULTI_ID_FABRIC	256	/* ... */
+
+#define for_each_mapped_vp_idx(_ha, _idx)		\
+	for (_idx = find_next_bit((_ha)->vp_idx_map,	\
+		(_ha)->max_npiv_vports + 1, 1);		\
+	    _idx <= (_ha)->max_npiv_vports;		\
+	    _idx = find_next_bit((_ha)->vp_idx_map,	\
+		(_ha)->max_npiv_vports + 1, _idx + 1))	\
 
 struct mid_conf_entry_24xx {
 	uint16_t reserved_1;
@@ -982,7 +1004,7 @@ struct mid_init_cb_24xx {
 	uint16_t count;
 	uint16_t options;
 
-	struct mid_conf_entry_24xx entries[MAX_MID_VPS];
+	struct mid_conf_entry_24xx entries[MAX_MULTI_ID_FABRIC];
 };
 
 
@@ -1002,10 +1024,6 @@ struct mid_db_entry_24xx {
 	uint8_t reserved_1;
 };
 
-struct mid_db_24xx {
-	struct mid_db_entry_24xx entries[MAX_MID_VPS];
-};
-
  /*
  * Virtual Fabric ID type definition.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 09cb2a9..ba35fc2 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -65,33 +65,25 @@ extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
 extern int num_hosts;
 
+extern int qla2x00_loop_reset(scsi_qla_host_t *);
+
 /*
  * Global Functions in qla_mid.c source file.
  */
-extern struct scsi_host_template qla2x00_driver_template;
 extern struct scsi_host_template qla24xx_driver_template;
 extern struct scsi_transport_template *qla2xxx_transport_vport_template;
-extern uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
 extern void qla2x00_timer(scsi_qla_host_t *);
 extern void qla2x00_start_timer(scsi_qla_host_t *, void *, unsigned long);
-extern void qla2x00_stop_timer(scsi_qla_host_t *);
-extern uint32_t qla24xx_allocate_vp_id(scsi_qla_host_t *);
 extern void qla24xx_deallocate_vp_id(scsi_qla_host_t *);
 extern int qla24xx_disable_vp (scsi_qla_host_t *);
 extern int qla24xx_enable_vp (scsi_qla_host_t *);
-extern void qla2x00_mem_free(scsi_qla_host_t *);
 extern int qla24xx_control_vp(scsi_qla_host_t *, int );
 extern int qla24xx_modify_vp_config(scsi_qla_host_t *);
 extern int qla2x00_send_change_request(scsi_qla_host_t *, uint16_t, uint16_t);
 extern void qla2x00_vp_stop_timer(scsi_qla_host_t *);
 extern int qla24xx_configure_vhba (scsi_qla_host_t *);
-extern int qla24xx_get_vp_entry(scsi_qla_host_t *, uint16_t, int);
-extern int qla24xx_get_vp_database(scsi_qla_host_t *, uint16_t);
-extern int qla2x00_do_dpc_vp(scsi_qla_host_t *);
 extern void qla24xx_report_id_acquisition(scsi_qla_host_t *,
     struct vp_rpt_id_entry_24xx *);
-extern scsi_qla_host_t * qla24xx_find_vhost_by_name(scsi_qla_host_t *,
-    uint8_t *);
 extern void qla2x00_do_dpc_all_vps(scsi_qla_host_t *);
 extern int qla24xx_vport_create_req_sanity_check(struct fc_vport *);
 extern scsi_qla_host_t * qla24xx_create_vhost(struct fc_vport *);
@@ -103,8 +95,6 @@ extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *, int);
 
-extern int qla2x00_down_timeout(struct semaphore *, unsigned long);
-
 extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
 extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
@@ -113,7 +103,6 @@ extern void qla2xxx_wake_dpc(scsi_qla_host_t *);
 extern void qla2x00_alert_all_vps(scsi_qla_host_t *, uint16_t *);
 extern void qla2x00_async_event(scsi_qla_host_t *, uint16_t *);
 extern void qla2x00_vp_abort_isp(scsi_qla_host_t *);
-extern int qla24xx_vport_delete(struct fc_vport *);
 
 /*
  * Global Function Prototypes in qla_iocb.c source file.
@@ -222,21 +211,16 @@ extern int
 qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map);
 
 extern int
-qla2x00_get_link_status(scsi_qla_host_t *, uint16_t, link_stat_t *,
-    uint16_t *);
+qla2x00_get_link_status(scsi_qla_host_t *, uint16_t, struct link_statistics *,
+    dma_addr_t);
 
 extern int
-qla24xx_get_isp_stats(scsi_qla_host_t *, uint32_t *, uint32_t, uint16_t *);
+qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
+    dma_addr_t);
 
 extern int qla24xx_abort_command(scsi_qla_host_t *, srb_t *);
 extern int qla24xx_abort_target(fc_port_t *);
 
-extern int qla2x00_system_error(scsi_qla_host_t *);
-
-extern int
-qla2x00_get_serdes_params(scsi_qla_host_t *, uint16_t *, uint16_t *,
-    uint16_t *);
-
 extern int
 qla2x00_set_serdes_params(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
 
@@ -244,13 +228,19 @@ extern int
 qla2x00_stop_firmware(scsi_qla_host_t *);
 
 extern int
-qla2x00_trace_control(scsi_qla_host_t *, uint16_t, dma_addr_t, uint16_t);
+qla2x00_enable_eft_trace(scsi_qla_host_t *, dma_addr_t, uint16_t);
+extern int
+qla2x00_disable_eft_trace(scsi_qla_host_t *);
 
 extern int
-qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t, uint16_t);
+qla2x00_enable_fce_trace(scsi_qla_host_t *, dma_addr_t, uint16_t , uint16_t *,
+    uint32_t *);
 
 extern int
-qla2x00_get_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t *, uint16_t *);
+qla2x00_disable_fce_trace(scsi_qla_host_t *, uint64_t *, uint64_t *);
+
+extern int
+qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t, uint16_t);
 
 extern int
 qla2x00_set_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t *);
@@ -270,11 +260,7 @@ extern void qla2x00_free_irqs(scsi_qla_host_t *);
 /*
  * Global Function Prototypes in qla_sup.c source file.
  */
-extern void qla2x00_lock_nvram_access(scsi_qla_host_t *);
-extern void qla2x00_unlock_nvram_access(scsi_qla_host_t *);
 extern void qla2x00_release_nvram_protection(scsi_qla_host_t *);
-extern uint16_t qla2x00_get_nvram_word(scsi_qla_host_t *, uint32_t);
-extern void qla2x00_write_nvram_word(scsi_qla_host_t *, uint32_t, uint16_t);
 extern uint32_t *qla24xx_read_flash_data(scsi_qla_host_t *, uint32_t *,
     uint32_t, uint32_t);
 extern uint8_t *qla2x00_read_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
@@ -321,7 +307,6 @@ extern void qla25xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla2x00_dump_regs(scsi_qla_host_t *);
 extern void qla2x00_dump_buffer(uint8_t *, uint32_t);
 extern void qla2x00_print_scsi_cmd(struct scsi_cmnd *);
-extern void qla2x00_dump_pkt(void *);
 
 /*
  * Global Function Prototypes in qla_gs.c source file.
@@ -356,4 +341,10 @@ extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_init_host_attr(scsi_qla_host_t *);
 extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
+
+/*
+ * Global Function Prototypes in qla_dfs.c source file.
+ */
+extern int qla2x00_dfs_setup(scsi_qla_host_t *);
+extern int qla2x00_dfs_remove(scsi_qla_host_t *);
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 191dafd..d0633ca 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -732,9 +732,9 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 {
 	int rval;
 	uint32_t dump_size, fixed_size, mem_size, req_q_size, rsp_q_size,
-	    eft_size;
-	dma_addr_t eft_dma;
-	void *eft;
+	    eft_size, fce_size;
+	dma_addr_t tc_dma;
+	void *tc;
 
 	if (ha->fw_dump) {
 		qla_printk(KERN_WARNING, ha,
@@ -743,7 +743,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 	}
 
 	ha->fw_dumped = 0;
-	fixed_size = mem_size = eft_size = 0;
+	fixed_size = mem_size = eft_size = fce_size = 0;
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 		fixed_size = sizeof(struct qla2100_fw_dump);
 	} else if (IS_QLA23XX(ha)) {
@@ -758,21 +758,21 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 		    sizeof(uint32_t);
 
 		/* Allocate memory for Extended Trace Buffer. */
-		eft = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &eft_dma,
+		tc = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
 		    GFP_KERNEL);
-		if (!eft) {
+		if (!tc) {
 			qla_printk(KERN_WARNING, ha, "Unable to allocate "
 			    "(%d KB) for EFT.\n", EFT_SIZE / 1024);
 			goto cont_alloc;
 		}
 
-		rval = qla2x00_trace_control(ha, TC_ENABLE, eft_dma,
-		    EFT_NUM_BUFFERS);
+		memset(tc, 0, EFT_SIZE);
+		rval = qla2x00_enable_eft_trace(ha, tc_dma, EFT_NUM_BUFFERS);
 		if (rval) {
 			qla_printk(KERN_WARNING, ha, "Unable to initialize "
 			    "EFT (%d).\n", rval);
-			dma_free_coherent(&ha->pdev->dev, EFT_SIZE, eft,
-			    eft_dma);
+			dma_free_coherent(&ha->pdev->dev, EFT_SIZE, tc,
+			    tc_dma);
 			goto cont_alloc;
 		}
 
@@ -780,9 +780,40 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 		    EFT_SIZE / 1024);
 
 		eft_size = EFT_SIZE;
-		memset(eft, 0, eft_size);
-		ha->eft_dma = eft_dma;
-		ha->eft = eft;
+		ha->eft_dma = tc_dma;
+		ha->eft = tc;
+
+		/* Allocate memory for Fibre Channel Event Buffer. */
+		if (!IS_QLA25XX(ha))
+			goto cont_alloc;
+
+		tc = dma_alloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
+		    GFP_KERNEL);
+		if (!tc) {
+			qla_printk(KERN_WARNING, ha, "Unable to allocate "
+			    "(%d KB) for FCE.\n", FCE_SIZE / 1024);
+			goto cont_alloc;
+		}
+
+		memset(tc, 0, FCE_SIZE);
+		rval = qla2x00_enable_fce_trace(ha, tc_dma, FCE_NUM_BUFFERS,
+		    ha->fce_mb, &ha->fce_bufs);
+		if (rval) {
+			qla_printk(KERN_WARNING, ha, "Unable to initialize "
+			    "FCE (%d).\n", rval);
+			dma_free_coherent(&ha->pdev->dev, FCE_SIZE, tc,
+			    tc_dma);
+			ha->flags.fce_enabled = 0;
+			goto cont_alloc;
+		}
+
+		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for FCE...\n",
+		    FCE_SIZE / 1024);
+
+		fce_size = sizeof(struct qla2xxx_fce_chain) + EFT_SIZE;
+		ha->flags.fce_enabled = 1;
+		ha->fce_dma = tc_dma;
+		ha->fce = tc;
 	}
 cont_alloc:
 	req_q_size = ha->request_q_length * sizeof(request_t);
@@ -790,7 +821,7 @@ cont_alloc:
 
 	dump_size = offsetof(struct qla2xxx_fw_dump, isp);
 	dump_size += fixed_size + mem_size + req_q_size + rsp_q_size +
-	    eft_size;
+	    eft_size + fce_size;
 
 	ha->fw_dump = vmalloc(dump_size);
 	if (!ha->fw_dump) {
@@ -922,9 +953,9 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 					ha->flags.npiv_supported = 1;
 					if ((!ha->max_npiv_vports) ||
 					    ((ha->max_npiv_vports + 1) %
-					    MAX_MULTI_ID_FABRIC))
+					    MIN_MULTI_ID_FABRIC))
 						ha->max_npiv_vports =
-						    MAX_NUM_VPORT_FABRIC;
+						    MIN_MULTI_ID_FABRIC - 1;
 				}
 
 				if (ql2xallocfwdump)
@@ -1162,7 +1193,10 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
 
-	mid_init_cb->count = ha->max_npiv_vports;
+	if (ha->flags.npiv_supported)
+		mid_init_cb->count = cpu_to_le16(ha->max_npiv_vports);
+
+	mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
 
 	rval = qla2x00_init_firmware(ha, ha->init_cb_size);
 	if (rval) {
@@ -2566,14 +2600,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 
 		/* Bypass virtual ports of the same host. */
 		if (pha->num_vhosts) {
-			vp_index = find_next_bit(
-			    (unsigned long *)pha->vp_idx_map,
-			    MAX_MULTI_ID_FABRIC + 1, 1);
-
-			for (;vp_index <= MAX_MULTI_ID_FABRIC;
-			    vp_index = find_next_bit(
-			    (unsigned long *)pha->vp_idx_map,
-			    MAX_MULTI_ID_FABRIC + 1, vp_index + 1)) {
+			for_each_mapped_vp_idx(pha, vp_index) {
 				empty_vp_index = 1;
 				found_vp = 0;
 				list_for_each_entry(vha, &pha->vp_list,
@@ -2592,7 +2619,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 				    new_fcport->d_id.b24 == vha->d_id.b24)
 					break;
 			}
-			if (vp_index <= MAX_MULTI_ID_FABRIC)
+
+			if (vp_index <= pha->max_npiv_vports)
 				continue;
 		}
 
@@ -3245,7 +3273,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 
 			if (ha->eft) {
-				rval = qla2x00_trace_control(ha, TC_ENABLE,
+				rval = qla2x00_enable_eft_trace(ha,
 				    ha->eft_dma, EFT_NUM_BUFFERS);
 				if (rval) {
 					qla_printk(KERN_WARNING, ha,
@@ -3253,6 +3281,21 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 					    "(%d).\n", rval);
 				}
 			}
+
+			if (ha->fce) {
+				ha->flags.fce_enabled = 1;
+				memset(ha->fce, 0,
+				    fce_calc_size(ha->fce_bufs));
+				rval = qla2x00_enable_fce_trace(ha,
+				    ha->fce_dma, ha->fce_bufs, ha->fce_mb,
+				    &ha->fce_bufs);
+				if (rval) {
+					qla_printk(KERN_WARNING, ha,
+					    "Unable to reinitialize FCE "
+					    "(%d).\n", rval);
+					ha->flags.fce_enabled = 0;
+				}
+			}
 		} else {	/* failed the ISP abort */
 			ha->flags.online = 1;
 			if (test_bit(ISP_ABORT_RETRY, &ha->dpc_flags)) {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1104bd2..642a0c3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -104,7 +104,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_comp);
 	}
 
 	return (IRQ_HANDLED);
@@ -216,7 +216,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_comp);
 	}
 
 	return (IRQ_HANDLED);
@@ -347,10 +347,6 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 
 	case MBA_SYSTEM_ERR:		/* System Error */
-		mb[1] = RD_MAILBOX_REG(ha, reg, 1);
-		mb[2] = RD_MAILBOX_REG(ha, reg, 2);
-		mb[3] = RD_MAILBOX_REG(ha, reg, 3);
-
 		qla_printk(KERN_INFO, ha,
 		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n",
 		    mb[1], mb[2], mb[3]);
@@ -579,12 +575,15 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		/* Check if the Vport has issued a SCR */
 		if (ha->parent && test_bit(VP_SCR_NEEDED, &ha->vp_flags))
 			break;
+		/* Only handle SCNs for our Vport index. */
+		if (ha->flags.npiv_supported && ha->vp_idx != mb[3])
+			break;
 
 		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
 		    ha->host_no));
 		DEBUG(printk(KERN_INFO
-		    "scsi(%ld): RSCN database changed -- %04x %04x.\n",
-		    ha->host_no, mb[1], mb[2]));
+		    "scsi(%ld): RSCN database changed -- %04x %04x %04x.\n",
+		    ha->host_no, mb[1], mb[2], mb[3]));
 
 		rscn_entry = (mb[1] << 16) | mb[2];
 		host_pid = (ha->d_id.b.domain << 16) | (ha->d_id.b.area << 8) |
@@ -823,6 +822,35 @@ qla2x00_process_response_queue(struct scsi_qla_host *ha)
 	WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), ha->rsp_ring_index);
 }
 
+static inline void
+qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
+{
+	struct scsi_cmnd *cp = sp->cmd;
+
+	if (sense_len >= SCSI_SENSE_BUFFERSIZE)
+		sense_len = SCSI_SENSE_BUFFERSIZE;
+
+	CMD_ACTUAL_SNSLEN(cp) = sense_len;
+	sp->request_sense_length = sense_len;
+	sp->request_sense_ptr = cp->sense_buffer;
+	if (sp->request_sense_length > 32)
+		sense_len = 32;
+
+	memcpy(cp->sense_buffer, sense_data, sense_len);
+
+	sp->request_sense_ptr += sense_len;
+	sp->request_sense_length -= sense_len;
+	if (sp->request_sense_length != 0)
+		sp->ha->status_srb = sp;
+
+	DEBUG5(printk("%s(): Check condition Sense data, scsi(%ld:%d:%d:%d) "
+	    "cmd=%p pid=%ld\n", __func__, sp->ha->host_no, cp->device->channel,
+	    cp->device->id, cp->device->lun, cp, cp->serial_number));
+	if (sense_len)
+		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
+		    CMD_ACTUAL_SNSLEN(cp)));
+}
+
 /**
  * qla2x00_status_entry() - Process a Status IOCB entry.
  * @ha: SCSI driver HA context
@@ -977,36 +1005,11 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		if (lscsi_status != SS_CHECK_CONDITION)
 			break;
 
-		/* Copy Sense Data into sense buffer. */
-		memset(cp->sense_buffer, 0, sizeof(cp->sense_buffer));
-
+		memset(cp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		if (!(scsi_status & SS_SENSE_LEN_VALID))
 			break;
 
-		if (sense_len >= sizeof(cp->sense_buffer))
-			sense_len = sizeof(cp->sense_buffer);
-
-		CMD_ACTUAL_SNSLEN(cp) = sense_len;
-		sp->request_sense_length = sense_len;
-		sp->request_sense_ptr = cp->sense_buffer;
-
-		if (sp->request_sense_length > 32)
-			sense_len = 32;
-
-		memcpy(cp->sense_buffer, sense_data, sense_len);
-
-		sp->request_sense_ptr += sense_len;
-		sp->request_sense_length -= sense_len;
-		if (sp->request_sense_length != 0)
-			ha->status_srb = sp;
-
-		DEBUG5(printk("%s(): Check condition Sense data, "
-		    "scsi(%ld:%d:%d:%d) cmd=%p pid=%ld\n", __func__,
-		    ha->host_no, cp->device->channel, cp->device->id,
-		    cp->device->lun, cp, cp->serial_number));
-		if (sense_len)
-			DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
-			    CMD_ACTUAL_SNSLEN(cp)));
+		qla2x00_handle_sense(sp, sense_data, sense_len);
 		break;
 
 	case CS_DATA_UNDERRUN:
@@ -1061,34 +1064,11 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 			if (lscsi_status != SS_CHECK_CONDITION)
 				break;
 
-			/* Copy Sense Data into sense buffer */
-			memset(cp->sense_buffer, 0, sizeof(cp->sense_buffer));
-
+			memset(cp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 			if (!(scsi_status & SS_SENSE_LEN_VALID))
 				break;
 
-			if (sense_len >= sizeof(cp->sense_buffer))
-				sense_len = sizeof(cp->sense_buffer);
-
-			CMD_ACTUAL_SNSLEN(cp) = sense_len;
-			sp->request_sense_length = sense_len;
-			sp->request_sense_ptr = cp->sense_buffer;
-
-			if (sp->request_sense_length > 32)
-				sense_len = 32;
-
-			memcpy(cp->sense_buffer, sense_data, sense_len);
-
-			sp->request_sense_ptr += sense_len;
-			sp->request_sense_length -= sense_len;
-			if (sp->request_sense_length != 0)
-				ha->status_srb = sp;
-
-			DEBUG5(printk("%s(): Check condition Sense data, "
-			    "scsi(%ld:%d:%d:%d) cmd=%p pid=%ld\n",
-			    __func__, ha->host_no, cp->device->channel,
-			    cp->device->id, cp->device->lun, cp,
-			    cp->serial_number));
+			qla2x00_handle_sense(sp, sense_data, sense_len);
 
 			/*
 			 * In case of a Underrun condition, set both the lscsi
@@ -1108,10 +1088,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 
 				cp->result = DID_ERROR << 16 | lscsi_status;
 			}
-
-			if (sense_len)
-				DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
-				    CMD_ACTUAL_SNSLEN(cp)));
 		} else {
 			/*
 			 * If RISC reports underrun and target does not report
@@ -1621,7 +1597,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_comp);
 	}
 
 	return IRQ_HANDLED;
@@ -1758,7 +1734,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_comp);
 	}
 
 	return IRQ_HANDLED;
@@ -1853,6 +1829,18 @@ qla2x00_request_irqs(scsi_qla_host_t *ha)
 		goto skip_msix;
 	}
 
+	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
+	    (ha->pdev->subsystem_device == 0x7040 ||
+		ha->pdev->subsystem_device == 0x7041 ||
+		ha->pdev->subsystem_device == 0x1705)) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "MSI-X: Unsupported ISP2432 SSVID/SSDID (0x%X, 0x%X).\n",
+		    ha->pdev->subsystem_vendor,
+		    ha->pdev->subsystem_device));
+
+		goto skip_msi;
+	}
+
 	ret = qla24xx_enable_msix(ha);
 	if (!ret) {
 		DEBUG2(qla_printk(KERN_INFO, ha,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ccd662a..0c10c0b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -8,19 +8,6 @@
 
 #include <linux/delay.h>
 
-static void
-qla2x00_mbx_sem_timeout(unsigned long data)
-{
-	struct semaphore	*sem_ptr = (struct semaphore *)data;
-
-	DEBUG11(printk("qla2x00_sem_timeout: entered.\n"));
-
-	if (sem_ptr != NULL) {
-		up(sem_ptr);
-	}
-
-	DEBUG11(printk("qla2x00_mbx_sem_timeout: exiting.\n"));
-}
 
 /*
  * qla2x00_mailbox_command
@@ -47,7 +34,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	int		rval;
 	unsigned long    flags = 0;
 	device_reg_t __iomem *reg;
-	struct timer_list	tmp_intr_timer;
 	uint8_t		abort_active;
 	uint8_t		io_lock_on;
 	uint16_t	command;
@@ -72,7 +58,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	 * non ISP abort time.
 	 */
 	if (!abort_active) {
-		if (qla2x00_down_timeout(&ha->mbx_cmd_sem, mcp->tov * HZ)) {
+		if (!wait_for_completion_timeout(&ha->mbx_cmd_comp,
+		    mcp->tov * HZ)) {
 			/* Timeout occurred. Return error. */
 			DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
 			    "Exiting.\n", __func__, ha->host_no));
@@ -135,22 +122,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	/* Wait for mbx cmd completion until timeout */
 
 	if (!abort_active && io_lock_on) {
-		/* sleep on completion semaphore */
-		DEBUG11(printk("%s(%ld): INTERRUPT MODE. Initializing timer.\n",
-		    __func__, ha->host_no));
-
-		init_timer(&tmp_intr_timer);
-		tmp_intr_timer.data = (unsigned long)&ha->mbx_intr_sem;
-		tmp_intr_timer.expires = jiffies + mcp->tov * HZ;
-		tmp_intr_timer.function =
-		    (void (*)(unsigned long))qla2x00_mbx_sem_timeout;
-
-		DEBUG11(printk("%s(%ld): Adding timer.\n", __func__,
-		    ha->host_no));
-		add_timer(&tmp_intr_timer);
-
-		DEBUG11(printk("%s(%ld): going to unlock & sleep. "
-		    "time=0x%lx.\n", __func__, ha->host_no, jiffies));
 
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
@@ -160,17 +131,10 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		/* Wait for either the timer to expire
-		 * or the mbox completion interrupt
-		 */
-		down(&ha->mbx_intr_sem);
+		wait_for_completion_timeout(&ha->mbx_intr_comp, mcp->tov * HZ);
 
-		DEBUG11(printk("%s(%ld): waking up. time=0x%lx\n", __func__,
-		    ha->host_no, jiffies));
 		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
-		/* delete the timer */
-		del_timer(&tmp_intr_timer);
 	} else {
 		DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
 		    ha->host_no, command));
@@ -299,7 +263,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 	/* Allow next mbx cmd to come in. */
 	if (!abort_active)
-		up(&ha->mbx_cmd_sem);
+		complete(&ha->mbx_cmd_comp);
 
 	if (rval) {
 		DEBUG2_3_11(printk("%s(%ld): **** FAILED. mbx0=%x, mbx1=%x, "
@@ -905,7 +869,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
 
 	mcp->mb[0] = MBC_GET_ADAPTER_LOOP_ID;
 	mcp->mb[9] = ha->vp_idx;
-	mcp->out_mb = MBX_0;
+	mcp->out_mb = MBX_9|MBX_0;
 	mcp->in_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
@@ -1016,7 +980,7 @@ qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
 	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
 	    ha->host_no));
 
-	if (ha->flags.npiv_supported)
+	if (ha->fw_attributes & BIT_2)
 		mcp->mb[0] = MBC_MID_INITIALIZE_FIRMWARE;
 	else
 		mcp->mb[0] = MBC_INITIALIZE_FIRMWARE;
@@ -2042,29 +2006,20 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
  */
 int
 qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
-    link_stat_t *ret_buf, uint16_t *status)
+    struct link_statistics *stats, dma_addr_t stats_dma)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	link_stat_t *stat_buf;
-	dma_addr_t stat_buf_dma;
+	uint32_t *siter, *diter, dwords;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	stat_buf = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &stat_buf_dma);
-	if (stat_buf == NULL) {
-		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
-		    __func__, ha->host_no));
-		return BIT_0;
-	}
-	memset(stat_buf, 0, sizeof(link_stat_t));
-
 	mcp->mb[0] = MBC_GET_LINK_STATUS;
-	mcp->mb[2] = MSW(stat_buf_dma);
-	mcp->mb[3] = LSW(stat_buf_dma);
-	mcp->mb[6] = MSW(MSD(stat_buf_dma));
-	mcp->mb[7] = LSW(MSD(stat_buf_dma));
+	mcp->mb[2] = MSW(stats_dma);
+	mcp->mb[3] = LSW(stats_dma);
+	mcp->mb[6] = MSW(MSD(stats_dma));
+	mcp->mb[7] = LSW(MSD(stats_dma));
 	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(ha)) {
@@ -2089,78 +2044,43 @@ qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
 			    __func__, ha->host_no, mcp->mb[0]));
-			status[0] = mcp->mb[0];
-			rval = BIT_1;
+			rval = QLA_FUNCTION_FAILED;
 		} else {
-			/* copy over data -- firmware data is LE. */
-			ret_buf->link_fail_cnt =
-			    le32_to_cpu(stat_buf->link_fail_cnt);
-			ret_buf->loss_sync_cnt =
-			    le32_to_cpu(stat_buf->loss_sync_cnt);
-			ret_buf->loss_sig_cnt =
-			    le32_to_cpu(stat_buf->loss_sig_cnt);
-			ret_buf->prim_seq_err_cnt =
-			    le32_to_cpu(stat_buf->prim_seq_err_cnt);
-			ret_buf->inval_xmit_word_cnt =
-			    le32_to_cpu(stat_buf->inval_xmit_word_cnt);
-			ret_buf->inval_crc_cnt =
-			    le32_to_cpu(stat_buf->inval_crc_cnt);
-
-			DEBUG11(printk("%s(%ld): stat dump: fail_cnt=%d "
-			    "loss_sync=%d loss_sig=%d seq_err=%d "
-			    "inval_xmt_word=%d inval_crc=%d.\n", __func__,
-			    ha->host_no, stat_buf->link_fail_cnt,
-			    stat_buf->loss_sync_cnt, stat_buf->loss_sig_cnt,
-			    stat_buf->prim_seq_err_cnt,
-			    stat_buf->inval_xmit_word_cnt,
-			    stat_buf->inval_crc_cnt));
+			/* Copy over data -- firmware data is LE. */
+			dwords = offsetof(struct link_statistics, unused1) / 4;
+			siter = diter = &stats->link_fail_cnt;
+			while (dwords--)
+				*diter++ = le32_to_cpu(*siter++);
 		}
 	} else {
 		/* Failed. */
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
 		    ha->host_no, rval));
-		rval = BIT_1;
 	}
 
-	dma_pool_free(ha->s_dma_pool, stat_buf, stat_buf_dma);
-
 	return rval;
 }
 
 int
-qla24xx_get_isp_stats(scsi_qla_host_t *ha, uint32_t *dwbuf, uint32_t dwords,
-    uint16_t *status)
+qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
+    dma_addr_t stats_dma)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	uint32_t *sbuf, *siter;
-	dma_addr_t sbuf_dma;
+	uint32_t *siter, *diter, dwords;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	if (dwords > (DMA_POOL_SIZE / 4)) {
-		DEBUG2_3_11(printk("%s(%ld): Unabled to retrieve %d DWORDs "
-		    "(max %d).\n", __func__, ha->host_no, dwords,
-		    DMA_POOL_SIZE / 4));
-		return BIT_0;
-	}
-	sbuf = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &sbuf_dma);
-	if (sbuf == NULL) {
-		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
-		    __func__, ha->host_no));
-		return BIT_0;
-	}
-	memset(sbuf, 0, DMA_POOL_SIZE);
-
 	mcp->mb[0] = MBC_GET_LINK_PRIV_STATS;
-	mcp->mb[2] = MSW(sbuf_dma);
-	mcp->mb[3] = LSW(sbuf_dma);
-	mcp->mb[6] = MSW(MSD(sbuf_dma));
-	mcp->mb[7] = LSW(MSD(sbuf_dma));
-	mcp->mb[8] = dwords;
+	mcp->mb[2] = MSW(stats_dma);
+	mcp->mb[3] = LSW(stats_dma);
+	mcp->mb[6] = MSW(MSD(stats_dma));
+	mcp->mb[7] = LSW(MSD(stats_dma));
+	mcp->mb[8] = sizeof(struct link_statistics) / 4;
+	mcp->mb[9] = ha->vp_idx;
 	mcp->mb[10] = 0;
-	mcp->out_mb = MBX_10|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
+	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
 	mcp->tov = 30;
 	mcp->flags = IOCTL_CMD;
@@ -2170,23 +2090,20 @@ qla24xx_get_isp_stats(scsi_qla_host_t *ha, uint32_t *dwbuf, uint32_t dwords,
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
 			    __func__, ha->host_no, mcp->mb[0]));
-			status[0] = mcp->mb[0];
-			rval = BIT_1;
+			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Copy over data -- firmware data is LE. */
-			siter = sbuf;
+			dwords = sizeof(struct link_statistics) / 4;
+			siter = diter = &stats->link_fail_cnt;
 			while (dwords--)
-				*dwbuf++ = le32_to_cpu(*siter++);
+				*diter++ = le32_to_cpu(*siter++);
 		}
 	} else {
 		/* Failed. */
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
 		    ha->host_no, rval));
-		rval = BIT_1;
 	}
 
-	dma_pool_free(ha->s_dma_pool, sbuf, sbuf_dma);
-
 	return rval;
 }
 
@@ -2331,6 +2248,8 @@ atarget_done:
 	return rval;
 }
 
+#if 0
+
 int
 qla2x00_system_error(scsi_qla_host_t *ha)
 {
@@ -2360,47 +2279,7 @@ qla2x00_system_error(scsi_qla_host_t *ha)
 	return rval;
 }
 
-/**
- * qla2x00_get_serdes_params() -
- * @ha: HA context
- *
- * Returns
- */
-int
-qla2x00_get_serdes_params(scsi_qla_host_t *ha, uint16_t *sw_em_1g,
-    uint16_t *sw_em_2g, uint16_t *sw_em_4g)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
-
-	mcp->mb[0] = MBC_SERDES_PARAMS;
-	mcp->mb[1] = 0;
-	mcp->out_mb = MBX_1|MBX_0;
-	mcp->in_mb = MBX_4|MBX_3|MBX_2|MBX_0;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
-	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
-
-		if (sw_em_1g)
-			*sw_em_1g = mcp->mb[2];
-		if (sw_em_2g)
-			*sw_em_2g = mcp->mb[3];
-		if (sw_em_4g)
-			*sw_em_4g = mcp->mb[4];
-	}
-
-	return rval;
-}
+#endif  /*  0  */
 
 /**
  * qla2x00_set_serdes_params() -
@@ -2471,7 +2350,7 @@ qla2x00_stop_firmware(scsi_qla_host_t *ha)
 }
 
 int
-qla2x00_trace_control(scsi_qla_host_t *ha, uint16_t ctrl, dma_addr_t eft_dma,
+qla2x00_enable_eft_trace(scsi_qla_host_t *ha, dma_addr_t eft_dma,
     uint16_t buffers)
 {
 	int rval;
@@ -2484,22 +2363,18 @@ qla2x00_trace_control(scsi_qla_host_t *ha, uint16_t ctrl, dma_addr_t eft_dma,
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
-	mcp->mb[1] = ctrl;
-	mcp->out_mb = MBX_1|MBX_0;
+	mcp->mb[1] = TC_EFT_ENABLE;
+	mcp->mb[2] = LSW(eft_dma);
+	mcp->mb[3] = MSW(eft_dma);
+	mcp->mb[4] = LSW(MSD(eft_dma));
+	mcp->mb[5] = MSW(MSD(eft_dma));
+	mcp->mb[6] = buffers;
+	mcp->mb[7] = TC_AEN_DISABLE;
+	mcp->out_mb = MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_1|MBX_0;
-	if (ctrl == TC_ENABLE) {
-		mcp->mb[2] = LSW(eft_dma);
-		mcp->mb[3] = MSW(eft_dma);
-		mcp->mb[4] = LSW(MSD(eft_dma));
-		mcp->mb[5] = MSW(MSD(eft_dma));
-		mcp->mb[6] = buffers;
-		mcp->mb[7] = 0;
-		mcp->out_mb |= MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2;
-	}
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
-
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
 		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
@@ -2511,8 +2386,7 @@ qla2x00_trace_control(scsi_qla_host_t *ha, uint16_t ctrl, dma_addr_t eft_dma,
 }
 
 int
-qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
-    uint16_t off, uint16_t count)
+qla2x00_disable_eft_trace(scsi_qla_host_t *ha)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -2523,24 +2397,16 @@ qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	mcp->mb[0] = MBC_READ_SFP;
-	mcp->mb[1] = addr;
-	mcp->mb[2] = MSW(sfp_dma);
-	mcp->mb[3] = LSW(sfp_dma);
-	mcp->mb[6] = MSW(MSD(sfp_dma));
-	mcp->mb[7] = LSW(MSD(sfp_dma));
-	mcp->mb[8] = count;
-	mcp->mb[9] = off;
-	mcp->mb[10] = 0;
-	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
+	mcp->mb[0] = MBC_TRACE_CONTROL;
+	mcp->mb[1] = TC_EFT_DISABLE;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
-
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
+		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
 		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
@@ -2549,176 +2415,168 @@ qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
 }
 
 int
-qla2x00_get_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
-    uint16_t *port_speed, uint16_t *mb)
+qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
+    uint16_t buffers, uint16_t *mb, uint32_t *dwords)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_IIDMA_CAPABLE(ha))
+	if (!IS_QLA25XX(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	mcp->mb[0] = MBC_PORT_PARAMS;
-	mcp->mb[1] = loop_id;
-	mcp->mb[2] = mcp->mb[3] = mcp->mb[4] = mcp->mb[5] = 0;
-	mcp->out_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
+	mcp->mb[0] = MBC_TRACE_CONTROL;
+	mcp->mb[1] = TC_FCE_ENABLE;
+	mcp->mb[2] = LSW(fce_dma);
+	mcp->mb[3] = MSW(fce_dma);
+	mcp->mb[4] = LSW(MSD(fce_dma));
+	mcp->mb[5] = MSW(MSD(fce_dma));
+	mcp->mb[6] = buffers;
+	mcp->mb[7] = TC_AEN_DISABLE;
+	mcp->mb[8] = 0;
+	mcp->mb[9] = TC_FCE_DEFAULT_RX_SIZE;
+	mcp->mb[10] = TC_FCE_DEFAULT_TX_SIZE;
+	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|
+	    MBX_1|MBX_0;
+	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
-
-	/* Return mailbox statuses. */
-	if (mb != NULL) {
-		mb[0] = mcp->mb[0];
-		mb[1] = mcp->mb[1];
-		mb[3] = mcp->mb[3];
-		mb[4] = mcp->mb[4];
-		mb[5] = mcp->mb[5];
-	}
-
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
+		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
 		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
-		if (port_speed)
-			*port_speed = mcp->mb[3];
+
+		if (mb)
+			memcpy(mb, mcp->mb, 8 * sizeof(*mb));
+		if (dwords)
+			*dwords = mcp->mb[6];
 	}
 
 	return rval;
 }
 
 int
-qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
-    uint16_t port_speed, uint16_t *mb)
+qla2x00_disable_fce_trace(scsi_qla_host_t *ha, uint64_t *wr, uint64_t *rd)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_IIDMA_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	mcp->mb[0] = MBC_PORT_PARAMS;
-	mcp->mb[1] = loop_id;
-	mcp->mb[2] = BIT_0;
-	mcp->mb[3] = port_speed & (BIT_2|BIT_1|BIT_0);
-	mcp->mb[4] = mcp->mb[5] = 0;
-	mcp->out_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
+	mcp->mb[0] = MBC_TRACE_CONTROL;
+	mcp->mb[1] = TC_FCE_DISABLE;
+	mcp->mb[2] = TC_FCE_DISABLE_TRACE;
+	mcp->out_mb = MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_9|MBX_8|MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|
+	    MBX_1|MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
-
-	/* Return mailbox statuses. */
-	if (mb != NULL) {
-		mb[0] = mcp->mb[0];
-		mb[1] = mcp->mb[1];
-		mb[3] = mcp->mb[3];
-		mb[4] = mcp->mb[4];
-		mb[5] = mcp->mb[5];
-	}
-
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
+		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
 		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+
+		if (wr)
+			*wr = (uint64_t) mcp->mb[5] << 48 |
+			    (uint64_t) mcp->mb[4] << 32 |
+			    (uint64_t) mcp->mb[3] << 16 |
+			    (uint64_t) mcp->mb[2];
+		if (rd)
+			*rd = (uint64_t) mcp->mb[9] << 48 |
+			    (uint64_t) mcp->mb[8] << 32 |
+			    (uint64_t) mcp->mb[7] << 16 |
+			    (uint64_t) mcp->mb[6];
 	}
 
 	return rval;
 }
 
-/*
- * qla24xx_get_vp_database
- *	Get the VP's database for all configured ports.
- *
- * Input:
- *	ha = adapter block pointer.
- *	size = size of initialization control block.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
 int
-qla24xx_get_vp_database(scsi_qla_host_t *ha, uint16_t size)
+qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
+    uint16_t off, uint16_t count)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("scsi(%ld):%s - entered.\n",
-	    ha->host_no, __func__));
+	if (!IS_FWI2_CAPABLE(ha))
+		return QLA_FUNCTION_FAILED;
 
-	mcp->mb[0] = MBC_MID_GET_VP_DATABASE;
-	mcp->mb[2] = MSW(ha->init_cb_dma);
-	mcp->mb[3] = LSW(ha->init_cb_dma);
-	mcp->mb[4] = 0;
-	mcp->mb[5] = 0;
-	mcp->mb[6] = MSW(MSD(ha->init_cb_dma));
-	mcp->mb[7] = LSW(MSD(ha->init_cb_dma));
-	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
-	mcp->in_mb = MBX_1|MBX_0;
-	mcp->buf_size = size;
-	mcp->flags = MBX_DMA_OUT;
-	mcp->tov = MBX_TOV_SECONDS;
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_READ_SFP;
+	mcp->mb[1] = addr;
+	mcp->mb[2] = MSW(sfp_dma);
+	mcp->mb[3] = LSW(sfp_dma);
+	mcp->mb[6] = MSW(MSD(sfp_dma));
+	mcp->mb[7] = LSW(MSD(sfp_dma));
+	mcp->mb[8] = count;
+	mcp->mb[9] = off;
+	mcp->mb[10] = 0;
+	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x "
-		    "mb0=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0]));
+		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
+		    ha->host_no, rval, mcp->mb[0]));
 	} else {
-		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n",
-		    __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla24xx_get_vp_entry(scsi_qla_host_t *ha, uint16_t size, int vp_id)
+qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
+    uint16_t port_speed, uint16_t *mb)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	if (!IS_IIDMA_CAPABLE(ha))
+		return QLA_FUNCTION_FAILED;
+
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	mcp->mb[0] = MBC_MID_GET_VP_ENTRY;
-	mcp->mb[2] = MSW(ha->init_cb_dma);
-	mcp->mb[3] = LSW(ha->init_cb_dma);
-	mcp->mb[4] = 0;
-	mcp->mb[5] = 0;
-	mcp->mb[6] = MSW(MSD(ha->init_cb_dma));
-	mcp->mb[7] = LSW(MSD(ha->init_cb_dma));
-	mcp->mb[9] = vp_id;
-	mcp->out_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->buf_size = size;
-	mcp->flags = MBX_DMA_OUT;
+	mcp->mb[0] = MBC_PORT_PARAMS;
+	mcp->mb[1] = loop_id;
+	mcp->mb[2] = BIT_0;
+	mcp->mb[3] = port_speed & (BIT_2|BIT_1|BIT_0);
+	mcp->mb[4] = mcp->mb[5] = 0;
+	mcp->out_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
 	mcp->tov = 30;
+	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
+	/* Return mailbox statuses. */
+	if (mb != NULL) {
+		mb[0] = mcp->mb[0];
+		mb[1] = mcp->mb[1];
+		mb[3] = mcp->mb[3];
+		mb[4] = mcp->mb[4];
+		mb[5] = mcp->mb[5];
+	}
+
 	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("qla24xx_get_vp_entry(%ld): failed=%x "
-		    "mb0=%x.\n",
-		    ha->host_no, rval, mcp->mb[0]));
+		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
+		    ha->host_no, rval));
 	} else {
-		/*EMPTY*/
-		DEBUG11(printk("qla24xx_get_vp_entry(%ld): done.\n",
-		    ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
 	return rval;
@@ -2873,7 +2731,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	DEBUG11(printk("%s(%ld): entered. Enabling index %d\n", __func__,
 	    ha->host_no, vp_index));
 
-	if (vp_index == 0 || vp_index >= MAX_MULTI_ID_LOOP)
+	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
 		return QLA_PARAMETER_ERROR;
 
 	vce = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &vce_dma);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 821ee74..cf784cd 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -39,7 +39,7 @@ qla2x00_vp_stop_timer(scsi_qla_host_t *vha)
 	}
 }
 
-uint32_t
+static uint32_t
 qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 {
 	uint32_t vp_id;
@@ -47,16 +47,15 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 
 	/* Find an empty slot and assign an vp_id */
 	down(&ha->vport_sem);
-	vp_id = find_first_zero_bit((unsigned long *)ha->vp_idx_map,
-				MAX_MULTI_ID_FABRIC);
-	if (vp_id > MAX_MULTI_ID_FABRIC) {
-		DEBUG15(printk ("vp_id %d is bigger than MAX_MULTI_ID_FABRID\n",
-		    vp_id));
+	vp_id = find_first_zero_bit(ha->vp_idx_map, ha->max_npiv_vports + 1);
+	if (vp_id > ha->max_npiv_vports) {
+		DEBUG15(printk ("vp_id %d is bigger than max-supported %d.\n",
+		    vp_id, ha->max_npiv_vports));
 		up(&ha->vport_sem);
 		return vp_id;
 	}
 
-	set_bit(vp_id, (unsigned long *)ha->vp_idx_map);
+	set_bit(vp_id, ha->vp_idx_map);
 	ha->num_vhosts++;
 	vha->vp_idx = vp_id;
 	list_add_tail(&vha->vp_list, &ha->vp_list);
@@ -73,12 +72,12 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	down(&ha->vport_sem);
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
-	clear_bit(vp_id, (unsigned long *)ha->vp_idx_map);
+	clear_bit(vp_id, ha->vp_idx_map);
 	list_del(&vha->vp_list);
 	up(&ha->vport_sem);
 }
 
-scsi_qla_host_t *
+static scsi_qla_host_t *
 qla24xx_find_vhost_by_name(scsi_qla_host_t *ha, uint8_t *port_name)
 {
 	scsi_qla_host_t *vha;
@@ -216,11 +215,7 @@ qla2x00_alert_all_vps(scsi_qla_host_t *ha, uint16_t *mb)
 	if (ha->parent)
 		return;
 
-	i = find_next_bit((unsigned long *)ha->vp_idx_map,
-	    MAX_MULTI_ID_FABRIC + 1, 1);
-	for (;i <= MAX_MULTI_ID_FABRIC;
-	    i = find_next_bit((unsigned long *)ha->vp_idx_map,
-	    MAX_MULTI_ID_FABRIC + 1, i + 1)) {
+	for_each_mapped_vp_idx(ha, i) {
 		vp_idx_matched = 0;
 
 		list_for_each_entry(vha, &ha->vp_list, vp_list) {
@@ -270,7 +265,7 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 	qla24xx_enable_vp(vha);
 }
 
-int
+static int
 qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 {
 	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
@@ -311,11 +306,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *ha)
 
 	clear_bit(VP_DPC_NEEDED, &ha->dpc_flags);
 
-	i = find_next_bit((unsigned long *)ha->vp_idx_map,
-	    MAX_MULTI_ID_FABRIC + 1, 1);
-	for (;i <= MAX_MULTI_ID_FABRIC;
-	    i = find_next_bit((unsigned long *)ha->vp_idx_map,
-	    MAX_MULTI_ID_FABRIC + 1, i + 1)) {
+	for_each_mapped_vp_idx(ha, i) {
 		vp_idx_matched = 0;
 
 		list_for_each_entry(vha, &ha->vp_list, vp_list) {
@@ -350,15 +341,17 @@ qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 
 	/* Check up unique WWPN */
 	u64_to_wwn(fc_vport->port_name, port_name);
+	if (!memcmp(port_name, ha->port_name, WWN_SIZE))
+		return VPCERR_BAD_WWN;
 	vha = qla24xx_find_vhost_by_name(ha, port_name);
 	if (vha)
 		return VPCERR_BAD_WWN;
 
 	/* Check up max-npiv-supports */
 	if (ha->num_vhosts > ha->max_npiv_vports) {
-		DEBUG15(printk("scsi(%ld): num_vhosts %d is bigger than "
-		    "max_npv_vports %d.\n", ha->host_no,
-		    (uint16_t) ha->num_vhosts, (int) ha->max_npiv_vports));
+		DEBUG15(printk("scsi(%ld): num_vhosts %ud is bigger than "
+		    "max_npv_vports %ud.\n", ha->host_no,
+		    ha->num_vhosts, ha->max_npiv_vports));
 		return VPCERR_UNSUPPORTED;
 	}
 	return 0;
@@ -412,8 +405,9 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	}
 	vha->mgmt_svr_loop_id = 10 + vha->vp_idx;
 
-	init_MUTEX(&vha->mbx_cmd_sem);
-	init_MUTEX_LOCKED(&vha->mbx_intr_sem);
+	init_completion(&vha->mbx_cmd_comp);
+	complete(&vha->mbx_cmd_comp);
+	init_completion(&vha->mbx_intr_comp);
 
 	INIT_LIST_HEAD(&vha->list);
 	INIT_LIST_HEAD(&vha->fcports);
@@ -450,7 +444,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	num_hosts++;
 
 	down(&ha->vport_sem);
-	set_bit(vha->vp_idx, (unsigned long *)ha->vp_idx_map);
+	set_bit(vha->vp_idx, ha->vp_idx_map);
 	ha->cur_vport_count++;
 	up(&ha->vport_sem);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8ecc047..aba1e6d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -105,13 +105,12 @@ static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
-static int qla2x00_loop_reset(scsi_qla_host_t *ha);
 static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
 
 static int qla2x00_change_queue_depth(struct scsi_device *, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
 
-struct scsi_host_template qla2x00_driver_template = {
+static struct scsi_host_template qla2x00_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= QLA2XXX_DRIVER_NAME,
 	.queuecommand		= qla2x00_queuecommand,
@@ -179,13 +178,6 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
  * Timer routines
  */
 
-void qla2x00_timer(scsi_qla_host_t *);
-
-__inline__ void qla2x00_start_timer(scsi_qla_host_t *,
-    void *, unsigned long);
-static __inline__ void qla2x00_restart_timer(scsi_qla_host_t *, unsigned long);
-__inline__ void qla2x00_stop_timer(scsi_qla_host_t *);
-
 __inline__ void
 qla2x00_start_timer(scsi_qla_host_t *ha, void *func, unsigned long interval)
 {
@@ -203,7 +195,7 @@ qla2x00_restart_timer(scsi_qla_host_t *ha, unsigned long interval)
 	mod_timer(&ha->timer, jiffies + interval * HZ);
 }
 
-__inline__ void
+static __inline__ void
 qla2x00_stop_timer(scsi_qla_host_t *ha)
 {
 	del_timer_sync(&ha->timer);
@@ -214,12 +206,11 @@ static int qla2x00_do_dpc(void *data);
 
 static void qla2x00_rst_aen(scsi_qla_host_t *);
 
-uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
-void qla2x00_mem_free(scsi_qla_host_t *ha);
+static uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
+static void qla2x00_mem_free(scsi_qla_host_t *ha);
 static int qla2x00_allocate_sp_pool( scsi_qla_host_t *ha);
 static void qla2x00_free_sp_pool(scsi_qla_host_t *ha);
 static void qla2x00_sp_free_dma(scsi_qla_host_t *, srb_t *);
-void qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *);
 
 /* -------------------------------------------------------------------------- */
 
@@ -1060,7 +1051,7 @@ eh_host_reset_lock:
 * Returns:
 *      0 = success
 */
-static int
+int
 qla2x00_loop_reset(scsi_qla_host_t *ha)
 {
 	int ret;
@@ -1479,8 +1470,7 @@ qla2x00_set_isp_flags(scsi_qla_host_t *ha)
 static int
 qla2x00_iospace_config(scsi_qla_host_t *ha)
 {
-	unsigned long	pio, pio_len, pio_flags;
-	unsigned long	mmio, mmio_len, mmio_flags;
+	resource_size_t pio;
 
 	if (pci_request_selected_regions(ha->pdev, ha->bars,
 	    QLA2XXX_DRIVER_NAME)) {
@@ -1495,10 +1485,8 @@ qla2x00_iospace_config(scsi_qla_host_t *ha)
 
 	/* We only need PIO for Flash operations on ISP2312 v2 chips. */
 	pio = pci_resource_start(ha->pdev, 0);
-	pio_len = pci_resource_len(ha->pdev, 0);
-	pio_flags = pci_resource_flags(ha->pdev, 0);
-	if (pio_flags & IORESOURCE_IO) {
-		if (pio_len < MIN_IOBASE_LEN) {
+	if (pci_resource_flags(ha->pdev, 0) & IORESOURCE_IO) {
+		if (pci_resource_len(ha->pdev, 0) < MIN_IOBASE_LEN) {
 			qla_printk(KERN_WARNING, ha,
 			    "Invalid PCI I/O region size (%s)...\n",
 				pci_name(ha->pdev));
@@ -1511,28 +1499,23 @@ qla2x00_iospace_config(scsi_qla_host_t *ha)
 		pio = 0;
 	}
 	ha->pio_address = pio;
-	ha->pio_length = pio_len;
 
 skip_pio:
 	/* Use MMIO operations for all accesses. */
-	mmio = pci_resource_start(ha->pdev, 1);
-	mmio_len = pci_resource_len(ha->pdev, 1);
-	mmio_flags = pci_resource_flags(ha->pdev, 1);
-
-	if (!(mmio_flags & IORESOURCE_MEM)) {
+	if (!(pci_resource_flags(ha->pdev, 1) & IORESOURCE_MEM)) {
 		qla_printk(KERN_ERR, ha,
-		    "region #0 not an MMIO resource (%s), aborting\n",
+		    "region #1 not an MMIO resource (%s), aborting\n",
 		    pci_name(ha->pdev));
 		goto iospace_error_exit;
 	}
-	if (mmio_len < MIN_IOBASE_LEN) {
+	if (pci_resource_len(ha->pdev, 1) < MIN_IOBASE_LEN) {
 		qla_printk(KERN_ERR, ha,
 		    "Invalid PCI mem region size (%s), aborting\n",
 			pci_name(ha->pdev));
 		goto iospace_error_exit;
 	}
 
-	ha->iobase = ioremap(mmio, MIN_IOBASE_LEN);
+	ha->iobase = ioremap(pci_resource_start(ha->pdev, 1), MIN_IOBASE_LEN);
 	if (!ha->iobase) {
 		qla_printk(KERN_ERR, ha,
 		    "cannot remap MMIO (%s), aborting\n", pci_name(ha->pdev));
@@ -1701,9 +1684,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* load the F/W, read paramaters, and init the H/W */
 	ha->instance = num_hosts;
 
-	init_MUTEX(&ha->mbx_cmd_sem);
 	init_MUTEX(&ha->vport_sem);
-	init_MUTEX_LOCKED(&ha->mbx_intr_sem);
+	init_completion(&ha->mbx_cmd_comp);
+	complete(&ha->mbx_cmd_comp);
+	init_completion(&ha->mbx_intr_comp);
 
 	INIT_LIST_HEAD(&ha->list);
 	INIT_LIST_HEAD(&ha->fcports);
@@ -1807,6 +1791,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	qla2x00_init_host_attr(ha);
 
+	qla2x00_dfs_setup(ha);
+
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
 	    "  QLogic %s - %s\n"
@@ -1838,6 +1824,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	ha = pci_get_drvdata(pdev);
 
+	qla2x00_dfs_remove(ha);
+
 	qla2x00_free_sysfs_attr(ha);
 
 	fc_remove_host(ha->host);
@@ -1871,8 +1859,11 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 		kthread_stop(t);
 	}
 
+	if (ha->flags.fce_enabled)
+		qla2x00_disable_fce_trace(ha, NULL, NULL);
+
 	if (ha->eft)
-		qla2x00_trace_control(ha, TC_DISABLE, 0, 0);
+		qla2x00_disable_eft_trace(ha);
 
 	ha->flags.online = 0;
 
@@ -2016,7 +2007,7 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 *      0  = success.
 *      1  = failure.
 */
-uint8_t
+static uint8_t
 qla2x00_mem_alloc(scsi_qla_host_t *ha)
 {
 	char	name[16];
@@ -2213,7 +2204,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 * Input:
 *      ha = adapter block pointer.
 */
-void
+static void
 qla2x00_mem_free(scsi_qla_host_t *ha)
 {
 	struct list_head	*fcpl, *fcptemp;
@@ -2228,6 +2219,10 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	/* free sp pool */
 	qla2x00_free_sp_pool(ha);
 
+	if (ha->fce)
+		dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce,
+		    ha->fce_dma);
+
 	if (ha->fw_dump) {
 		if (ha->eft)
 			dma_free_coherent(&ha->pdev->dev,
@@ -2748,23 +2743,6 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	qla2x00_restart_timer(ha, WATCH_INTERVAL);
 }
 
-/* XXX(hch): crude hack to emulate a down_timeout() */
-int
-qla2x00_down_timeout(struct semaphore *sema, unsigned long timeout)
-{
-	const unsigned int step = 100; /* msecs */
-	unsigned int iterations = jiffies_to_msecs(timeout)/100;
-
-	do {
-		if (!down_trylock(sema))
-			return 0;
-		if (msleep_interruptible(step))
-			break;
-	} while (--iterations > 0);
-
-	return -ETIMEDOUT;
-}
-
 /* Firmware interface routines. */
 
 #define FW_BLOBS	6
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index ad2fa01..b68fb73 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -22,7 +22,7 @@ static void qla2x00_nv_write(scsi_qla_host_t *, uint16_t);
  * qla2x00_lock_nvram_access() -
  * @ha: HA context
  */
-void
+static void
 qla2x00_lock_nvram_access(scsi_qla_host_t *ha)
 {
 	uint16_t data;
@@ -55,7 +55,7 @@ qla2x00_lock_nvram_access(scsi_qla_host_t *ha)
  * qla2x00_unlock_nvram_access() -
  * @ha: HA context
  */
-void
+static void
 qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -74,7 +74,7 @@ qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
  *
  * Returns the word read from nvram @addr.
  */
-uint16_t
+static uint16_t
 qla2x00_get_nvram_word(scsi_qla_host_t *ha, uint32_t addr)
 {
 	uint16_t	data;
@@ -93,7 +93,7 @@ qla2x00_get_nvram_word(scsi_qla_host_t *ha, uint32_t addr)
  * @addr: Address in NVRAM to write
  * @data: word to program
  */
-void
+static void
 qla2x00_write_nvram_word(scsi_qla_host_t *ha, uint32_t addr, uint16_t data)
 {
 	int count;
@@ -550,7 +550,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 	int ret;
 	uint32_t liter, miter;
 	uint32_t sec_mask, rest_addr, conf_addr;
-	uint32_t fdata, findex ;
+	uint32_t fdata, findex, cnt;
 	uint8_t	man_id, flash_id;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	dma_addr_t optrom_dma;
@@ -690,8 +690,14 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 			    0xff0000) | ((fdata >> 16) & 0xff));
 	}
 
-	/* Enable flash write-protection. */
+	/* Enable flash write-protection and wait for completion. */
 	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0x9c);
+	for (cnt = 300; cnt &&
+	    qla24xx_read_flash_dword(ha,
+		    flash_conf_to_access_addr(0x005)) & BIT_0;
+	    cnt--) {
+		udelay(10);
+	}
 
 	/* Disable flash write. */
 	WRT_REG_DWORD(&reg->ctrl_status,
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index ae6f7a2..2c2f6b4 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.02.00-k5"
+#define QLA2XXX_VERSION      "8.02.00-k7"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	2

