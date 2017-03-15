From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 11/14] qla2xxx: Add DebugFS node to display Port Database
Date: Wed, 15 Mar 2017 09:48:53 -0700
Message-ID: <20170315164856.17255-12-himanshu.madhani@cavium.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0089.outbound.protection.outlook.com ([104.47.40.89]:46880
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753136AbdCOQtb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 12:49:31 -0400
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  2 +
 drivers/scsi/qla2xxx/qla_dfs.c | 92 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ae38b7a789b1..089480280558 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3300,6 +3300,8 @@ struct qlt_hw_data {
 	uint8_t tgt_node_name[WWN_SIZE];
 
 	struct dentry *dfs_tgt_sess;
+	struct dentry *dfs_tgt_port_database;
+
 	struct list_head q_full_list;
 	uint32_t num_pend_cmds;
 	uint32_t num_qfull_cmds_alloc;
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 3b35905619b0..989e17b0758c 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -19,11 +19,11 @@ qla2x00_dfs_tgt_sess_show(struct seq_file *s, void *unused)
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
 	struct fc_port *sess = NULL;
-	struct qla_tgt *tgt= vha->vha_tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 
-	seq_printf(s, "%s\n",vha->host_str);
+	seq_printf(s, "%s\n", vha->host_str);
 	if (tgt) {
-		seq_printf(s, "Port ID   Port Name                Handle\n");
+		seq_puts(s, "Port ID   Port Name                Handle\n");
 
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		list_for_each_entry(sess, &vha->vp_fcports, list)
@@ -44,7 +44,6 @@ qla2x00_dfs_tgt_sess_open(struct inode *inode, struct file *file)
 	return single_open(file, qla2x00_dfs_tgt_sess_show, vha);
 }
 
-
 static const struct file_operations dfs_tgt_sess_ops = {
 	.open		= qla2x00_dfs_tgt_sess_open,
 	.read		= seq_read,
@@ -53,6 +52,78 @@ static const struct file_operations dfs_tgt_sess_ops = {
 };
 
 static int
+qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
+{
+	scsi_qla_host_t *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+	struct gid_list_info *gid_list;
+	dma_addr_t gid_list_dma;
+	fc_port_t fc_port;
+	char *id_iter;
+	int rc, i;
+	uint16_t entries, loop_id;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+
+	seq_printf(s, "%s\n", vha->host_str);
+	if (tgt) {
+		gid_list = dma_alloc_coherent(&ha->pdev->dev,
+		    qla2x00_gid_list_size(ha),
+		    &gid_list_dma, GFP_KERNEL);
+		if (!gid_list) {
+			ql_dbg(ql_dbg_user, vha, 0x705c,
+			    "DMA allocation failed for %u\n",
+			     qla2x00_gid_list_size(ha));
+			return 0;
+		}
+
+		rc = qla24xx_gidlist_wait(vha, gid_list, gid_list_dma,
+		    &entries);
+		if (rc != QLA_SUCCESS)
+			goto out_free_id_list;
+
+		id_iter = (char *)gid_list;
+
+		seq_puts(s, "Port Name	Port ID 	Loop ID\n");
+
+		for (i = 0; i < entries; i++) {
+			struct gid_list_info *gid =
+			    (struct gid_list_info *)id_iter;
+			loop_id = le16_to_cpu(gid->loop_id);
+			memset(&fc_port, 0, sizeof(fc_port_t));
+
+			fc_port.loop_id = loop_id;
+
+			rc = qla24xx_gpdb_wait(vha, &fc_port, 0);
+			seq_printf(s, "%8phC  %02x%02x%02x  %d\n",
+				fc_port.port_name, fc_port.d_id.b.domain,
+				fc_port.d_id.b.area, fc_port.d_id.b.al_pa,
+				fc_port.loop_id);
+			id_iter += ha->gid_list_info_size;
+		}
+out_free_id_list:
+		dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha),
+		    gid_list, gid_list_dma);
+	}
+
+	return 0;
+}
+
+static int
+qla2x00_dfs_tgt_port_database_open(struct inode *inode, struct file *file)
+{
+	scsi_qla_host_t *vha = inode->i_private;
+
+	return single_open(file, qla2x00_dfs_tgt_port_database_show, vha);
+}
+
+static const struct file_operations dfs_tgt_port_database_ops = {
+	.open		= qla2x00_dfs_tgt_port_database_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int
 qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 {
 	struct scsi_qla_host *vha = s->private;
@@ -296,6 +367,14 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 		goto out;
 	}
 
+	ha->tgt.dfs_tgt_port_database = debugfs_create_file("tgt_port_database",
+	    S_IRUSR,  ha->dfs_dir, vha, &dfs_tgt_port_database_ops);
+	if (!ha->tgt.dfs_tgt_port_database) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "Unable to create debugFS tgt_port_database node.\n");
+		goto out;
+	}
+
 	ha->dfs_fce = debugfs_create_file("fce", S_IRUSR, ha->dfs_dir, vha,
 	    &dfs_fce_ops);
 	if (!ha->dfs_fce) {
@@ -326,6 +405,11 @@ qla2x00_dfs_remove(scsi_qla_host_t *vha)
 		ha->tgt.dfs_tgt_sess = NULL;
 	}
 
+	if (ha->tgt.dfs_tgt_port_database) {
+		debugfs_remove(ha->tgt.dfs_tgt_port_database);
+		ha->tgt.dfs_tgt_port_database = NULL;
+	}
+
 	if (ha->dfs_fw_resource_cnt) {
 		debugfs_remove(ha->dfs_fw_resource_cnt);
 		ha->dfs_fw_resource_cnt = NULL;
-- 
2.12.0
