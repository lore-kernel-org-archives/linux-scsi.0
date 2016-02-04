From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 4/4] qla2xxx: Add DebugFS node to show irq vector's cpuid
Date: Thu, 4 Feb 2016 11:45:19 -0500
Message-ID: <1454604319-27947-5-git-send-email-himanshu.madhani@qlogic.com>
References: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

> cat /sys/kernel/debug/qla2xxx/*/irq_cpuid
qla2xxx_81
            IRQ Name  Vector  CPUID
   qla2xxx (default)  150     9
     qla2xxx (rsp_q)  151     9
    qla2xxx (atio_q)  152     9

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 +
 drivers/scsi/qla2xxx/qla_dfs.c |   49 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c |   16 +++++++++++++
 3 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e6c5bcf..c6cc519 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2722,6 +2722,7 @@ struct qla_msix_entry {
 	int have_irq;
 	uint32_t vector;
 	uint16_t entry;
+	const char *name;
 	struct rsp_que *rsp;
 	struct irq_affinity_notify irq_notify;
 	int cpuid;
@@ -3377,6 +3378,7 @@ struct qla_hw_data {
 	struct dentry *dfs_fce;
 	struct dentry *dfs_tgt_counters;
 	struct dentry *dfs_fw_resource_cnt;
+	struct dentry *dfs_irq_cpuid;
 
 	dma_addr_t	fce_dma;
 	void		*fce;
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 34272fd..4ff17f6 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -13,6 +13,41 @@ static struct dentry *qla2x00_dfs_root;
 static atomic_t qla2x00_dfs_root_count;
 
 static int
+qla2x00_dfs_irq_cpuid_show(struct seq_file *s, void *unused)
+{
+	scsi_qla_host_t *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_msix_entry *qentry;
+	int i;
+
+	seq_printf(s, "%s\n",vha->host_str);
+	seq_printf(s, "%20s  Vector  CPUID\n","IRQ Name");
+
+	for (i = 0; i < ha->msix_count; i++) {
+		qentry = &ha->msix_entries[i];
+		if (qentry->have_irq)
+			seq_printf(s, "%20s  %3d      %d\n", qentry->name,
+			    qentry->vector, qentry->cpuid);
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
@@ -298,6 +333,15 @@ create_nodes:
 		goto out;
 	}
 
+	ha->dfs_irq_cpuid = debugfs_create_file("irq_cpuid",
+		S_IRUSR, ha->dfs_dir, vha, &dfs_irq_cpuid_ops);
+	if (!ha->dfs_irq_cpuid) {
+		ql_log(ql_log_warn, vha, 0xffff,
+			"Unable to create debugFS irq_cpuid node.\n");
+		goto out;
+	}
+
+
 out:
 	return 0;
 }
@@ -307,6 +351,11 @@ qla2x00_dfs_remove(scsi_qla_host_t *vha)
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
index 4af9547..d527189 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3102,6 +3102,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 			goto msix_register_fail;
 		qentry->have_irq = 1;
 		qentry->rsp = rsp;
+		qentry->name = msix_entries[i].name;
 		rsp->msix = qentry;
 
 		/* Register for CPU affinity notification. */
@@ -3128,7 +3129,22 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 			0, qla83xx_msix_entries[ATIO_VECTOR].name, rsp);
 		qentry->have_irq = 1;
 		qentry->rsp = rsp;
+		qentry->name = qla83xx_msix_entries[ATIO_VECTOR].name;
+		qentry->irq_notify.notify  = qla_irq_affinity_notify;
+		qentry->irq_notify.release = qla_irq_affinity_release;
 		rsp->msix = qentry;
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
1.7.7
