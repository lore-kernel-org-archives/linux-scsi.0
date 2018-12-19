From: John Garry <john.garry@huawei.com>
Subject: [PATCH 4/8] scsi: hisi_sas: Debugfs global register create file and add file operations
Date: Wed, 19 Dec 2018 23:56:42 +0800
Message-ID: <1545235006-151716-5-git-send-email-john.garry@huawei.com>
References: <1545235006-151716-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545235006-151716-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

This patch create debugfs file for global register and add file
operations.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  8 ++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 64 +++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 69 ++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 3b5fd6d..6a1a5ad 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -221,7 +221,15 @@ struct hisi_sas_slot {
 	u16	idx;
 };
 
+#define HISI_SAS_DEBUGFS_REG(x) {#x, x}
+
+struct hisi_sas_debugfs_reg_lu {
+	char *name;
+	int off;
+};
+
 struct hisi_sas_debugfs_reg {
+	const struct hisi_sas_debugfs_reg_lu *lu;
 	int count;
 	int base_off;
 	union {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 742f71a..fd85934 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2544,6 +2544,66 @@ static void hisi_sas_debugfs_snapshot_iost_reg(struct hisi_hba *hisi_hba)
 	}
 }
 
+const char *
+hisi_sas_debugfs_to_reg_name(int off, int base_off,
+			     const struct hisi_sas_debugfs_reg_lu *lu)
+{
+	for (; lu->name; lu++) {
+		if (off == lu->off - base_off)
+			return lu->name;
+	}
+
+	return NULL;
+}
+
+static void hisi_sas_debugfs_print_reg(u32 *regs_val, const void *ptr,
+				       struct seq_file *s)
+{
+	const struct hisi_sas_debugfs_reg *reg = ptr;
+	int i;
+
+	for (i = 0; i < reg->count; i++) {
+		int off = i * 4;
+		const char *name;
+
+		name = hisi_sas_debugfs_to_reg_name(off, reg->base_off,
+						    reg->lu);
+
+		if (name)
+			seq_printf(s, "0x%08x 0x%08x %s\n", off,
+				   le32_to_cpu(regs_val[i]), name);
+		else
+			seq_printf(s, "0x%08x 0x%08x\n", off,
+				   le32_to_cpu(regs_val[i]));
+	}
+}
+
+static int hisi_sas_debugfs_global_show(struct seq_file *s, void *p)
+{
+	struct hisi_hba *hisi_hba = s->private;
+	const struct hisi_sas_hw *hw = hisi_hba->hw;
+	const struct hisi_sas_debugfs_reg *reg_global = hw->debugfs_reg_global;
+
+	hisi_sas_debugfs_print_reg((u32 *)hisi_hba->debugfs_global_reg,
+				   reg_global, s);
+
+	return 0;
+}
+
+static int hisi_sas_debugfs_global_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_global_show,
+			   inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_global_fops = {
+	.open = hisi_sas_debugfs_global_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 {
 	struct dentry *dump_dentry;
@@ -2554,6 +2614,10 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 		goto fail;
 
 	hisi_hba->debugfs_dump_dentry = dump_dentry;
+
+	if (!debugfs_create_file("global", 0400, dump_dentry, hisi_hba,
+				 &hisi_sas_debugfs_global_fops))
+		goto fail;
 	return;
 fail:
 	debugfs_remove_recursive(hisi_hba->debugfs_dir);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4dd48ac..ca3d13b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2344,7 +2344,76 @@ static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
 	.read_port_reg = hisi_sas_phy_read32,
 };
 
+static const struct hisi_sas_debugfs_reg_lu debugfs_global_reg_lu[] = {
+	HISI_SAS_DEBUGFS_REG(DLVRY_QUEUE_ENABLE),
+	HISI_SAS_DEBUGFS_REG(PHY_CONTEXT),
+	HISI_SAS_DEBUGFS_REG(PHY_STATE),
+	HISI_SAS_DEBUGFS_REG(PHY_PORT_NUM_MA),
+	HISI_SAS_DEBUGFS_REG(PHY_CONN_RATE),
+	HISI_SAS_DEBUGFS_REG(ITCT_CLR),
+	HISI_SAS_DEBUGFS_REG(IO_SATA_BROKEN_MSG_ADDR_LO),
+	HISI_SAS_DEBUGFS_REG(IO_SATA_BROKEN_MSG_ADDR_HI),
+	HISI_SAS_DEBUGFS_REG(SATA_INITI_D2H_STORE_ADDR_LO),
+	HISI_SAS_DEBUGFS_REG(SATA_INITI_D2H_STORE_ADDR_HI),
+	HISI_SAS_DEBUGFS_REG(CFG_MAX_TAG),
+	HISI_SAS_DEBUGFS_REG(HGC_SAS_TX_OPEN_FAIL_RETRY_CTRL),
+	HISI_SAS_DEBUGFS_REG(HGC_SAS_TXFAIL_RETRY_CTRL),
+	HISI_SAS_DEBUGFS_REG(HGC_GET_ITV_TIME),
+	HISI_SAS_DEBUGFS_REG(DEVICE_MSG_WORK_MODE),
+	HISI_SAS_DEBUGFS_REG(OPENA_WT_CONTI_TIME),
+	HISI_SAS_DEBUGFS_REG(I_T_NEXUS_LOSS_TIME),
+	HISI_SAS_DEBUGFS_REG(MAX_CON_TIME_LIMIT_TIME),
+	HISI_SAS_DEBUGFS_REG(BUS_INACTIVE_LIMIT_TIME),
+	HISI_SAS_DEBUGFS_REG(REJECT_TO_OPEN_LIMIT_TIME),
+	HISI_SAS_DEBUGFS_REG(CQ_INT_CONVERGE_EN),
+	HISI_SAS_DEBUGFS_REG(CFG_AGING_TIME),
+	HISI_SAS_DEBUGFS_REG(HGC_DFX_CFG2),
+	HISI_SAS_DEBUGFS_REG(CFG_ABT_SET_QUERY_IPTT),
+	HISI_SAS_DEBUGFS_REG(CFG_ABT_SET_IPTT_DONE),
+	HISI_SAS_DEBUGFS_REG(HGC_IOMB_PROC1_STATUS),
+	HISI_SAS_DEBUGFS_REG(CHNL_INT_STATUS),
+	HISI_SAS_DEBUGFS_REG(HGC_AXI_FIFO_ERR_INFO),
+	HISI_SAS_DEBUGFS_REG(INT_COAL_EN),
+	HISI_SAS_DEBUGFS_REG(OQ_INT_COAL_TIME),
+	HISI_SAS_DEBUGFS_REG(OQ_INT_COAL_CNT),
+	HISI_SAS_DEBUGFS_REG(ENT_INT_COAL_TIME),
+	HISI_SAS_DEBUGFS_REG(ENT_INT_COAL_CNT),
+	HISI_SAS_DEBUGFS_REG(OQ_INT_SRC),
+	HISI_SAS_DEBUGFS_REG(OQ_INT_SRC_MSK),
+	HISI_SAS_DEBUGFS_REG(ENT_INT_SRC1),
+	HISI_SAS_DEBUGFS_REG(ENT_INT_SRC2),
+	HISI_SAS_DEBUGFS_REG(ENT_INT_SRC3),
+	HISI_SAS_DEBUGFS_REG(ENT_INT_SRC_MSK1),
+	HISI_SAS_DEBUGFS_REG(ENT_INT_SRC_MSK2),
+	HISI_SAS_DEBUGFS_REG(ENT_INT_SRC_MSK3),
+	HISI_SAS_DEBUGFS_REG(CHNL_PHYUPDOWN_INT_MSK),
+	HISI_SAS_DEBUGFS_REG(CHNL_ENT_INT_MSK),
+	HISI_SAS_DEBUGFS_REG(HGC_COM_INT_MSK),
+	HISI_SAS_DEBUGFS_REG(SAS_ECC_INTR),
+	HISI_SAS_DEBUGFS_REG(SAS_ECC_INTR_MSK),
+	HISI_SAS_DEBUGFS_REG(HGC_ERR_STAT_EN),
+	HISI_SAS_DEBUGFS_REG(CQE_SEND_CNT),
+	HISI_SAS_DEBUGFS_REG(DLVRY_Q_0_DEPTH),
+	HISI_SAS_DEBUGFS_REG(DLVRY_Q_0_WR_PTR),
+	HISI_SAS_DEBUGFS_REG(DLVRY_Q_0_RD_PTR),
+	HISI_SAS_DEBUGFS_REG(HYPER_STREAM_ID_EN_CFG),
+	HISI_SAS_DEBUGFS_REG(OQ0_INT_SRC_MSK),
+	HISI_SAS_DEBUGFS_REG(COMPL_Q_0_DEPTH),
+	HISI_SAS_DEBUGFS_REG(COMPL_Q_0_WR_PTR),
+	HISI_SAS_DEBUGFS_REG(COMPL_Q_0_RD_PTR),
+	HISI_SAS_DEBUGFS_REG(AWQOS_AWCACHE_CFG),
+	HISI_SAS_DEBUGFS_REG(ARQOS_ARCACHE_CFG),
+	HISI_SAS_DEBUGFS_REG(HILINK_ERR_DFX),
+	HISI_SAS_DEBUGFS_REG(SAS_GPIO_CFG_0),
+	HISI_SAS_DEBUGFS_REG(SAS_GPIO_CFG_1),
+	HISI_SAS_DEBUGFS_REG(SAS_GPIO_TX_0_1),
+	HISI_SAS_DEBUGFS_REG(SAS_CFG_DRIVE_VLD),
+	{}
+};
+
 static const struct hisi_sas_debugfs_reg debugfs_global_reg = {
+	.lu = debugfs_global_reg_lu,
+	.count = 0x800,
 	.read_global_reg = hisi_sas_read32,
 };
 
-- 
1.9.1
