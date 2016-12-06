From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 14/22] qla2xxx: Add interrupt polling mechanism
Date: Tue, 6 Dec 2016 12:30:43 -0800
Message-ID: <1481056251-2310-15-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

This patch adds capability to poll for an interrupt, If hardware
does not generate any interrupt for 2 seconds.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  8 +++++
 drivers/scsi/qla2xxx/qla_dfs.c    | 75 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
 drivers/scsi/qla2xxx/qla_isr.c    | 22 ++++++++++--
 drivers/scsi/qla2xxx/qla_os.c     | 31 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.c |  6 ++++
 6 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6bf7ff9..09da61f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2921,6 +2921,10 @@ struct qla_msix_entry {
 	void *handle;
 	struct irq_affinity_notify irq_notify;
 	int cpuid;
+	irqreturn_t (*irq_handler)(int, void *);
+	u32		intr_cnt;
+	u32		last_intr_cnt;
+	struct work_struct intr_work;
 };
 
 #define	WATCH_INTERVAL		1       /* number of seconds */
@@ -3826,6 +3830,10 @@ struct qla_hw_data {
 
 	struct qlt_hw_data tgt;
 	int	allow_cna_fw_dump;
+
+	int irqpoll_interval, irqpoll_cnt;
+	struct dentry *dfs_irqpoll;
+#define MAX_IRQPOLL_INTV 30
 };
 
 struct qla_tgt_counters {
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index f69ff52..18cedf7 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -12,6 +12,68 @@
 static struct dentry *qla2x00_dfs_root;
 static atomic_t qla2x00_dfs_root_count;
 
+
+static int
+qla_dfs_irqpoll_show(struct seq_file *s,  void *unused)
+{
+	struct scsi_qla_host *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+
+	seq_printf(s, "IRQ poll interval: %d Seconds (max=%d, def=0/off)\n",
+			 ha->irqpoll_interval, MAX_IRQPOLL_INTV);
+
+	return 0;
+}
+
+static ssize_t qla_dfs_irqpoll_write(struct file *file, const char __user *ubuf,
+	size_t len, loff_t *offp)
+{
+	struct seq_file *s = file->private_data;
+	char *buf;
+	int ret = 0;
+	int interval = 0;
+	struct scsi_qla_host *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+
+	buf = memdup_user(ubuf, len);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	if (sscanf(buf, "%d", &interval) != 1)
+		return -EINVAL;
+
+	if (interval > MAX_IRQPOLL_INTV  || interval < 0)
+		return -ERANGE;
+
+	ha->irqpoll_interval = interval;
+
+	if (ha->irqpoll_interval == 0)
+		ql_log(ql_log_info, vha, 0xffff,
+			"IRQ Poll turned off.\n");
+	else
+		ql_log(ql_log_info, vha, 0xffff,
+			"IRQ Poll turned on(%d).\n", ha->irqpoll_interval);
+
+
+	kfree(buf);
+	return (ret) ? ret : len;
+}
+
+static int
+qla_dfs_irqpoll_open(struct inode *inode, struct file *file)
+{
+	struct scsi_qla_host *vha = inode->i_private;
+	return single_open(file, qla_dfs_irqpoll_show, vha);
+}
+
+static const struct file_operations dfs_irqpoll = {
+	.open           = qla_dfs_irqpoll_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+	.write          = qla_dfs_irqpoll_write,
+};
+
 static int
 qla2x00_dfs_irq_cpuid_show(struct seq_file *s, void *unused)
 {
@@ -357,6 +419,14 @@
 		goto out;
 	}
 
+	ha->dfs_irqpoll = debugfs_create_file("irq_poll_interval",
+		S_IRUSR, ha->dfs_dir, vha, &dfs_irqpoll);
+	if (!ha->dfs_irqpoll) {
+		ql_log(ql_log_warn, vha, 0xffff,
+			"Unable to create debugFS irq_poll_interval node.\n");
+		goto out;
+	}
+
 
 out:
 	return 0;
@@ -367,6 +437,11 @@
 {
 	struct qla_hw_data *ha = vha->hw;
 
+	if (ha->dfs_irqpoll) {
+		debugfs_remove(ha->dfs_irqpoll);
+		ha->dfs_irqpoll = NULL;
+	}
+
 	if (ha->dfs_irq_cpuid) {
 		debugfs_remove(ha->dfs_irq_cpuid);
 		ha->dfs_irq_cpuid = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3593a39..944f37a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -140,6 +140,7 @@ int qla24xx_post_newsess_work(struct scsi_qla_host *, port_id_t *,
 extern int ql2xexlogins;
 extern int ql2xexchoffld;
 extern int ql2xfwholdabts;
+extern struct workqueue_struct *qla_wq;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c7f73b1..eee98c9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3003,6 +3003,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	}
 	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
+	ha->msix_entries[1].intr_cnt++;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -3047,6 +3048,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
 	status = 0;
+	ha->msix_entries[0].intr_cnt++;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
@@ -3150,6 +3152,16 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	return IRQ_HANDLED;
 }
 
+static
+void qla_irq_poll(struct work_struct *work)
+{
+	struct qla_msix_entry *qentry =
+		container_of(work, struct qla_msix_entry, intr_work);
+
+	if (qentry)
+		qentry->irq_handler(qentry->vector, qentry->handle);
+}
+
 /* Interrupt handling helpers. */
 
 struct qla_init_msix_entry {
@@ -3235,18 +3247,23 @@ struct qla_init_msix_entry {
 		rsp->msix = qentry;
 		scnprintf(qentry->name, sizeof(qentry->name),
 		    msix_entries[i].name);
-		if (IS_P3P_TYPE(ha))
+		if (IS_P3P_TYPE(ha)) {
 			ret = request_irq(qentry->vector,
 				qla82xx_msix_entries[i].handler,
 				0, qla82xx_msix_entries[i].name, rsp);
-		else
+
+			qentry->irq_handler = qla82xx_msix_entries[i].handler;
+		} else {
 			ret = request_irq(qentry->vector,
 				msix_entries[i].handler,
 				0, msix_entries[i].name, rsp);
+			qentry->irq_handler = msix_entries[i].handler;
+		}
 		if (ret)
 			goto msix_register_fail;
 		qentry->have_irq = 1;
 		qentry->in_use = 1;
+		INIT_WORK(&qentry->intr_work, qla_irq_poll);
 
 		/* Register for CPU affinity notification. */
 		irq_set_affinity_notifier(qentry->vector, &qentry->irq_notify);
@@ -3278,6 +3295,7 @@ struct qla_init_msix_entry {
 		qentry->have_irq = 1;
 		qentry->irq_notify.notify  = qla_irq_affinity_notify;
 		qentry->irq_notify.release = qla_irq_affinity_release;
+		qentry->irq_handler = msix_entries[QLA_ATIO_VECTOR].handler;
 
 		/* Register for CPU affinity notification. */
 		irq_set_affinity_notifier(qentry->vector, &qentry->irq_notify);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4be58b0..18795c3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -36,6 +36,9 @@
  * CT6 CTX allocation cache
  */
 static struct kmem_cache *ctx_cachep;
+
+struct workqueue_struct *qla_wq;
+
 /*
  * error level for logging
  */
@@ -5895,6 +5898,26 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 		qla2xxx_wake_dpc(vha);
 	}
 
+	if (ha->irqpoll_interval && ha->msix_count &&
+		(atomic_read(&vha->loop_state) == LOOP_READY) &&
+		(IS_QLA83XX(ha) || IS_QLA27XX(ha))) {
+
+		struct qla_msix_entry *qentry;
+
+		ha->irqpoll_cnt++;
+		if (ha->irqpoll_cnt >= ha->irqpoll_interval) {
+			ha->irqpoll_cnt = 0;
+			/* scan default & rspq 1 */
+			for (index = 0; index < 2; index++) {
+				qentry = &ha->msix_entries[index];
+				if (qentry->last_intr_cnt == qentry->intr_cnt) {
+					queue_work_on(qentry->cpuid, qla_wq, &qentry->intr_work);
+				}
+				qentry->last_intr_cnt = qentry->intr_cnt+1;
+			}
+		}
+	}
+
 	qla2x00_restart_timer(vha, WATCH_INTERVAL);
 }
 
@@ -6369,6 +6392,13 @@ struct fw_blob *
 {
 	int ret = 0;
 
+	qla_wq = alloc_workqueue("qla_wq", WQ_MEM_RECLAIM, 0);
+	if (!qla_wq) {
+		ql_log(ql_log_fatal, NULL, 0xffff,
+		    "Unable to allocate qla_wq...Failing load!.\n");
+		return -ENOMEM;
+	}
+
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
 	    SLAB_HWCACHE_ALIGN, NULL);
@@ -6455,6 +6485,7 @@ struct fw_blob *
 		kmem_cache_destroy(ctx_cachep);
 	fc_release_transport(qla2xxx_transport_template);
 	fc_release_transport(qla2xxx_transport_vport_template);
+	destroy_workqueue(qla_wq);
 }
 
 module_init(qla2x00_module_init);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e6b2a45..cc24d1a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -7138,8 +7138,14 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	unsigned long flags;
 
 	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
+		ql_log(ql_log_info, NULL, 0xffff,
+		    "%s: NULL atio queue pointer.\n", __func__);
+		return IRQ_NONE;
+	}
 	ha = rsp->hw;
 	vha = pci_get_drvdata(ha->pdev);
+	ha->msix_entries[2].intr_cnt++;
 
 	spin_lock_irqsave(&ha->tgt.atio_lock, flags);
 
-- 
1.8.3.1
