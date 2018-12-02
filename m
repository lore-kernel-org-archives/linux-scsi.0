From: Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH] scsi: convert to DEFINE_SHOW_ATTRIBUTE
Date: Sun,  2 Dec 2018 01:59:13 -0500
Message-ID: <20181202065913.10377-1-tiny.windzz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, kartilak@cisco.com, sebaddel@cisco.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c   | 77 +++++---------------------------
 drivers/scsi/snic/snic_debugfs.c | 20 +--------
 2 files changed, 13 insertions(+), 84 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 0b190082aa8d..5703650a9e51 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -12,8 +12,7 @@
 static struct dentry *qla2x00_dfs_root;
 static atomic_t qla2x00_dfs_root_count;
 
-static int
-qla2x00_dfs_tgt_sess_show(struct seq_file *s, void *unused)
+static int dfs_tgt_sess_show(struct seq_file *s, void *unused)
 {
 	scsi_qla_host_t *vha = s->private;
 	struct qla_hw_data *ha = vha->hw;
@@ -37,22 +36,9 @@ qla2x00_dfs_tgt_sess_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int
-qla2x00_dfs_tgt_sess_open(struct inode *inode, struct file *file)
-{
-	scsi_qla_host_t *vha = inode->i_private;
-	return single_open(file, qla2x00_dfs_tgt_sess_show, vha);
-}
-
-static const struct file_operations dfs_tgt_sess_ops = {
-	.open		= qla2x00_dfs_tgt_sess_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(dfs_tgt_sess);
 
-static int
-qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
+static int dfs_tgt_port_database_show(struct seq_file *s, void *unused)
 {
 	scsi_qla_host_t *vha = s->private;
 	struct qla_hw_data *ha = vha->hw;
@@ -108,23 +94,9 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int
-qla2x00_dfs_tgt_port_database_open(struct inode *inode, struct file *file)
-{
-	scsi_qla_host_t *vha = inode->i_private;
+DEFINE_SHOW_ATTRIBUTE(dfs_tgt_port_database);
 
-	return single_open(file, qla2x00_dfs_tgt_port_database_show, vha);
-}
-
-static const struct file_operations dfs_tgt_port_database_ops = {
-	.open		= qla2x00_dfs_tgt_port_database_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int
-qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
+static int dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 {
 	struct scsi_qla_host *vha = s->private;
 	uint16_t mb[MAX_IOCB_MB_REG];
@@ -157,22 +129,9 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int
-qla_dfs_fw_resource_cnt_open(struct inode *inode, struct file *file)
-{
-	struct scsi_qla_host *vha = inode->i_private;
-	return single_open(file, qla_dfs_fw_resource_cnt_show, vha);
-}
+DEFINE_SHOW_ATTRIBUTE(dfs_fw_resource_cnt);
 
-static const struct file_operations dfs_fw_resource_cnt_ops = {
-	.open           = qla_dfs_fw_resource_cnt_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = single_release,
-};
-
-static int
-qla_dfs_tgt_counters_show(struct seq_file *s, void *unused)
+static int dfs_tgt_counters_show(struct seq_file *s, void *unused)
 {
 	struct scsi_qla_host *vha = s->private;
 	struct qla_qpair *qpair = vha->hw->base_qpair;
@@ -244,19 +203,7 @@ qla_dfs_tgt_counters_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int
-qla_dfs_tgt_counters_open(struct inode *inode, struct file *file)
-{
-	struct scsi_qla_host *vha = inode->i_private;
-	return single_open(file, qla_dfs_tgt_counters_show, vha);
-}
-
-static const struct file_operations dfs_tgt_counters_ops = {
-	.open           = qla_dfs_tgt_counters_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(dfs_tgt_counters);
 
 static int
 qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
@@ -468,7 +415,7 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 
 create_nodes:
 	ha->dfs_fw_resource_cnt = debugfs_create_file("fw_resource_count",
-	    S_IRUSR, ha->dfs_dir, vha, &dfs_fw_resource_cnt_ops);
+	    S_IRUSR, ha->dfs_dir, vha, &dfs_fw_resource_cnt_fops);
 	if (!ha->dfs_fw_resource_cnt) {
 		ql_log(ql_log_warn, vha, 0x00fd,
 		    "Unable to create debugFS fw_resource_count node.\n");
@@ -476,7 +423,7 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 	}
 
 	ha->dfs_tgt_counters = debugfs_create_file("tgt_counters", S_IRUSR,
-	    ha->dfs_dir, vha, &dfs_tgt_counters_ops);
+	    ha->dfs_dir, vha, &dfs_tgt_counters_fops);
 	if (!ha->dfs_tgt_counters) {
 		ql_log(ql_log_warn, vha, 0xd301,
 		    "Unable to create debugFS tgt_counters node.\n");
@@ -484,7 +431,7 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 	}
 
 	ha->tgt.dfs_tgt_port_database = debugfs_create_file("tgt_port_database",
-	    S_IRUSR,  ha->dfs_dir, vha, &dfs_tgt_port_database_ops);
+	    S_IRUSR,  ha->dfs_dir, vha, &dfs_tgt_port_database_fops);
 	if (!ha->tgt.dfs_tgt_port_database) {
 		ql_log(ql_log_warn, vha, 0xd03f,
 		    "Unable to create debugFS tgt_port_database node.\n");
@@ -500,7 +447,7 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 	}
 
 	ha->tgt.dfs_tgt_sess = debugfs_create_file("tgt_sess",
-		S_IRUSR, ha->dfs_dir, vha, &dfs_tgt_sess_ops);
+		S_IRUSR, ha->dfs_dir, vha, &dfs_tgt_sess_fops);
 	if (!ha->tgt.dfs_tgt_sess) {
 		ql_log(ql_log_warn, vha, 0xd040,
 		    "Unable to create debugFS tgt_sess node.\n");
diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index 0abe17c1a73b..268b5075a6f5 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -354,25 +354,7 @@ snic_stats_show(struct seq_file *sfp, void *data)
 	return 0;
 }
 
-/*
- * snic_stats_open - Open the stats file for specific host
- *
- * Description:
- * This routine opens a debugfs file stats of specific host
- */
-static int
-snic_stats_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, snic_stats_show, inode->i_private);
-}
-
-static const struct file_operations snic_stats_fops = {
-	.owner	= THIS_MODULE,
-	.open	= snic_stats_open,
-	.read	= seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(snic_stats);
 
 static const struct file_operations snic_reset_stats_fops = {
 	.owner = THIS_MODULE,
-- 
2.17.0
