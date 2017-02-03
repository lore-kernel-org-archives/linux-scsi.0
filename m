From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 05/14] qla2xxx: Add DebugFS node to display Port Database
Date: Fri, 3 Feb 2017 14:40:46 -0800
Message-ID: <1486161655-2307-6-git-send-email-himanshu.madhani@cavium.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0042.outbound.protection.outlook.com ([104.47.33.42]:14259
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753011AbdBCWlt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 17:41:49 -0500
In-Reply-To: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  2 +
 drivers/scsi/qla2xxx/qla_dfs.c | 92 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f92977b..8bc1111 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3278,6 +3278,8 @@ struct qlt_hw_data {
 	uint8_t tgt_node_name[WWN_SIZE];
 
 	struct dentry *dfs_tgt_sess;
+	struct dentry *dfs_tgt_port_database;
+
 	struct list_head q_full_list;
 	uint32_t num_pend_cmds;
 	uint32_t num_qfull_cmds_alloc;
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index b48cce6..0fb33e6 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -19,11 +19,11 @@
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
@@ -44,7 +44,6 @@
 	return single_open(file, qla2x00_dfs_tgt_sess_show, vha);
 }
 
-
 static const struct file_operations dfs_tgt_sess_ops = {
 	.open		= qla2x00_dfs_tgt_sess_open,
 	.read		= seq_read,
@@ -53,6 +52,78 @@
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
@@ -281,6 +352,14 @@
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
@@ -311,6 +390,11 @@
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
1.8.3.1
