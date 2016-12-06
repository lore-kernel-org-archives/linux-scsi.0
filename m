From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 05/22] qla2xxx: Add DebugFS node of irq vector cpuid
Date: Tue, 6 Dec 2016 12:30:34 -0800
Message-ID: <1481056251-2310-6-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:14496
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751993AbcLFUqe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 15:46:34 -0500
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

> cat /sys/kernel/debug/qla2xxx/*/irq_cpuid
qla2xxx_81
            IRQ Name  Vector  CPUID
    qla2xxx (default)  150     9
    qla2xxx (rsp_q)    151     9
    qla2xxx (atio_q)   152     9

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |  2 +-
 drivers/scsi/qla2xxx/qla_def.h |  1 +
 drivers/scsi/qla2xxx/qla_dfs.c | 52 +++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c | 14 ++++++++++++
 4 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 21d9fb7..b2e3167 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -59,7 +59,7 @@
  * |                              |                    | 0xb13c-0xb140  |
  * |                              |                    | 0xb149		|
  * | MultiQ                       |       0xc010       |		|
- * | Misc                         |       0xd301       | 0xd031-0xd0ff	|
+ * | Misc                         |       0xd303       | 0xd031-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
  * | Target Mode		  |	  0xe080       |		|
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 84f2cc3..1e3a3fa 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3448,6 +3448,7 @@ struct qla_hw_data {
 	struct dentry *dfs_fce;
 	struct dentry *dfs_tgt_counters;
 	struct dentry *dfs_fw_resource_cnt;
+	struct dentry *dfs_irq_cpuid;
 
 	dma_addr_t	fce_dma;
 	void		*fce;
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 34272fd..08d7a05 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -13,6 +13,42 @@
 static atomic_t qla2x00_dfs_root_count;
 
 static int
+qla2x00_dfs_irq_cpuid_show(struct seq_file *s, void *unused)
+{
+	int i;
+	scsi_qla_host_t *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_msix_entry *qentry;
+
+	seq_printf(s, "%s\n", vha->host_str);
+	seq_printf(s, "%20s  Vector  CPUID\n", "IRQ Name");
+
+	for (i = 0; i < ha->msix_count; i++) {
+		qentry = &ha->msix_entries[i];
+		if (qentry->have_irq)
+			seq_printf(s, "%20s  %3d     %d\n",
+				qentry->name, qentry->vector,
+				qentry->cpuid);
+	}
+
+	return 0;
+}
+
+static int
+qla2x00_dfs_irq_cpuid_open(struct inode *inode, struct file *file)
+{
+	scsi_qla_host_t *vha = inode->i_private;
+	return single_open(file, qla2x00_dfs_irq_cpuid_show, vha);
+}
+
+static const struct file_operations dfs_irq_cpuid_ops = {
+	.open		= qla2x00_dfs_irq_cpuid_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int
 qla2x00_dfs_tgt_sess_show(struct seq_file *s, void *unused)
 {
 	scsi_qla_host_t *vha = s->private;
@@ -293,11 +329,20 @@
 	ha->tgt.dfs_tgt_sess = debugfs_create_file("tgt_sess",
 		S_IRUSR, ha->dfs_dir, vha, &dfs_tgt_sess_ops);
 	if (!ha->tgt.dfs_tgt_sess) {
-		ql_log(ql_log_warn, vha, 0xffff,
+		ql_log(ql_log_warn, vha, 0xd302,
 			"Unable to create debugFS tgt_sess node.\n");
 		goto out;
 	}
 
+	ha->dfs_irq_cpuid = debugfs_create_file("irq_cpuid",
+		S_IRUSR, ha->dfs_dir, vha, &dfs_irq_cpuid_ops);
+	if (!ha->dfs_irq_cpuid) {
+		ql_log(ql_log_warn, vha, 0xd303,
+			"Unable to create debugFS irq_cpuid node.\n");
+		goto out;
+	}
+
+
 out:
 	return 0;
 }
@@ -307,6 +352,11 @@
 {
 	struct qla_hw_data *ha = vha->hw;
 
+	if (ha->dfs_irq_cpuid) {
+		debugfs_remove(ha->dfs_irq_cpuid);
+		ha->dfs_irq_cpuid = NULL;
+	}
+
 	if (ha->tgt.dfs_tgt_sess) {
 		debugfs_remove(ha->tgt.dfs_tgt_sess);
 		ha->tgt.dfs_tgt_sess = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 98e4904..dec4b37 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3121,6 +3121,20 @@ struct qla_init_msix_entry {
 			msix_entries[QLA_ATIO_VECTOR].handler,
 			0, msix_entries[QLA_ATIO_VECTOR].name, rsp);
 		qentry->have_irq = 1;
+		qentry->irq_notify.notify  = qla_irq_affinity_notify;
+		qentry->irq_notify.release = qla_irq_affinity_release;
+
+		/* Register for CPU affinity notification. */
+		irq_set_affinity_notifier(qentry->vector, &qentry->irq_notify);
+
+		/* Schedule work (ie. trigger a notification) to read cpu
+		 * mask for this specific irq.
+		 * kref_get is required because
+		* irq_affinity_notify() will do
+		* kref_put().
+		*/
+		kref_get(&qentry->irq_notify.kref);
+		schedule_work(&qentry->irq_notify.work);
 	}
 
 msix_register_fail:
-- 
1.8.3.1

