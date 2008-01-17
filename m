From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Add Fibre Channel Event (FCE) tracing support.
Date: Thu, 17 Jan 2008 09:02:17 -0800
Message-ID: <1200589340-19499-11-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYAQRCj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:39 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

FCE support enables the firmware to record FC extended link
services and basic link services frames which have been
transmitted and received by the ISP.  This allows for a limited
view of the FC traffic through the ISP without using a FC
analyzer.  This can be useful in situations where a physical
connection to the FC bus is not possible.

The driver exports this information in two ways -- first, via a
debugfs node exported for all supported ISPs under:

	<debugfs_mount_point>/qla2xxx/qla2xxx_<host_no>/fce

where a read of the 'fce' file will provide a snapshot of the
firmware's FCE buffer; and finally, the FCE buffer will be
extracted during a firmware-dump scenario.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/Makefile   |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c  |   22 +++++
 drivers/scsi/qla2xxx/qla_dbg.h  |   19 ++++
 drivers/scsi/qla2xxx/qla_def.h  |   10 ++
 drivers/scsi/qla2xxx/qla_dfs.c  |  175 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_fw.h   |    7 ++
 drivers/scsi/qla2xxx/qla_gbl.h  |   13 +++
 drivers/scsi/qla2xxx/qla_init.c |   73 +++++++++++++---
 drivers/scsi/qla2xxx/qla_mbx.c  |   87 +++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |   11 +++
 10 files changed, 405 insertions(+), 14 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_dfs.c

diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index 71ddb5d..c51fd1f 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,4 +1,4 @@
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
-		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o
+		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o
 
 obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 796c4ce..d88e98c 100644
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
index 3f934bd..6f129da 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2156,6 +2156,7 @@ typedef struct scsi_qla_host {
 		uint32_t	gpsc_supported		:1;
 		uint32_t        vsan_enabled            :1;
 		uint32_t	npiv_supported		:1;
+		uint32_t	fce_enabled		:1;
 	} flags;
 
 	atomic_t	loop_state;
@@ -2449,6 +2450,15 @@ typedef struct scsi_qla_host {
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
index ef14bcd..9337e13 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -959,6 +959,13 @@ struct device_reg_24xx {
 #define TC_EFT_ENABLE		4
 #define TC_EFT_DISABLE		5
 
+#define TC_FCE_ENABLE		8
+#define TC_FCE_OPTIONS		0
+#define TC_FCE_DEFAULT_RX_SIZE	2112
+#define TC_FCE_DEFAULT_TX_SIZE	2112
+#define TC_FCE_DISABLE		9
+#define TC_FCE_DISABLE_TRACE	BIT_0
+
 /* MID Support ***************************************************************/
 
 #define MIN_MULTI_ID_FABRIC	64	/* Must be power-of-2. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 2fd31fd..ba35fc2 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -233,6 +233,13 @@ extern int
 qla2x00_disable_eft_trace(scsi_qla_host_t *);
 
 extern int
+qla2x00_enable_fce_trace(scsi_qla_host_t *, dma_addr_t, uint16_t , uint16_t *,
+    uint32_t *);
+
+extern int
+qla2x00_disable_fce_trace(scsi_qla_host_t *, uint64_t *, uint64_t *);
+
+extern int
 qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t, uint16_t);
 
 extern int
@@ -334,4 +341,10 @@ extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
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
index da2cce0..cacfd25 100644
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
@@ -758,20 +758,20 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
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
 
-		rval = qla2x00_enable_eft_trace(ha, eft_dma, EFT_NUM_BUFFERS);
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
 
@@ -779,9 +779,41 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 		    EFT_SIZE / 1024);
 
 		eft_size = EFT_SIZE;
-		memset(eft, 0, eft_size);
-		ha->eft_dma = eft_dma;
-		ha->eft = eft;
+		memset(tc, 0, eft_size);
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
@@ -789,7 +821,7 @@ cont_alloc:
 
 	dump_size = offsetof(struct qla2xxx_fw_dump, isp);
 	dump_size += fixed_size + mem_size + req_q_size + rsp_q_size +
-	    eft_size;
+	    eft_size + fce_size;
 
 	ha->fw_dump = vmalloc(dump_size);
 	if (!ha->fw_dump) {
@@ -3247,6 +3279,21 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
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
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7c6aa4e..99d29ff 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2415,6 +2415,93 @@ qla2x00_disable_eft_trace(scsi_qla_host_t *ha)
 }
 
 int
+qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
+    uint16_t buffers, uint16_t *mb, uint32_t *dwords)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA25XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
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
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
+		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+
+		if (mb)
+			memcpy(mb, mcp->mb, 8 * sizeof(*mb));
+		if (dwords)
+			*dwords = mcp->mb[6];
+	}
+
+	return rval;
+}
+
+int
+qla2x00_disable_fce_trace(scsi_qla_host_t *ha, uint64_t *wr, uint64_t *rd)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_FWI2_CAPABLE(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_TRACE_CONTROL;
+	mcp->mb[1] = TC_FCE_DISABLE;
+	mcp->mb[2] = TC_FCE_DISABLE_TRACE;
+	mcp->out_mb = MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_9|MBX_8|MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|
+	    MBX_1|MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
+		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
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
+	}
+
+	return rval;
+}
+
+int
 qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
     uint16_t off, uint16_t count)
 {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 37b02c0..aba1e6d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1791,6 +1791,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	qla2x00_init_host_attr(ha);
 
+	qla2x00_dfs_setup(ha);
+
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
 	    "  QLogic %s - %s\n"
@@ -1822,6 +1824,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	ha = pci_get_drvdata(pdev);
 
+	qla2x00_dfs_remove(ha);
+
 	qla2x00_free_sysfs_attr(ha);
 
 	fc_remove_host(ha->host);
@@ -1855,6 +1859,9 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 		kthread_stop(t);
 	}
 
+	if (ha->flags.fce_enabled)
+		qla2x00_disable_fce_trace(ha, NULL, NULL);
+
 	if (ha->eft)
 		qla2x00_disable_eft_trace(ha);
 
@@ -2212,6 +2219,10 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	/* free sp pool */
 	qla2x00_free_sp_pool(ha);
 
+	if (ha->fce)
+		dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce,
+		    ha->fce_dma);
+
 	if (ha->fw_dump) {
 		if (ha->eft)
 			dma_free_coherent(&ha->pdev->dev,
-- 
1.5.4.rc3.14.g44397

