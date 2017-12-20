From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 07/43] qla2xxx: Add ability to track IOCB resource for FW
Date: Tue, 19 Dec 2017 22:56:08 -0800
Message-ID: <20171220065644.21511-8-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0088.outbound.protection.outlook.com ([104.47.38.88]:33568
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932380AbdLTG5F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:05 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

FW has a finite number of IOCB resource. Driver will
track it via the ql2xtrackfwres module parameter. User
will be able to reserve X number of IOCBs for either
the target path or initiator path. The left over IOCBs
are shared between the 2 modes. The shared pool will be
used 1st before tapping into the reserve pool.

usage:
    modprobe qla2xxx ql2xtrackfwres=1 qlini_mode=dual
    echo 256 > /sys/class/scsi_host/hostX/device/reserve_ini_iocbs
    echo 256 > /sys/class/scsi_host/hostX/device/reserve_tgt_iocbs

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  50 +++++-
 drivers/scsi/qla2xxx/qla_dfs.c    | 315 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |   1 +
 drivers/scsi/qla2xxx/qla_init.c   |  36 +++++
 drivers/scsi/qla2xxx/qla_inline.h | 102 ++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c   |  45 ++++++
 drivers/scsi/qla2xxx/qla_isr.c    |  10 +-
 drivers/scsi/qla2xxx/qla_os.c     |  10 ++
 drivers/scsi/qla2xxx/qla_target.c |  24 +++
 drivers/scsi/qla2xxx/qla_target.h |   3 +-
 10 files changed, 592 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5e509763a419..8fbe1736a1a4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -549,6 +549,12 @@ enum {
 	TYPE_TGT_CMD,
 };
 
+struct iocb_resource {
+	u8 res_type;
+	u8 pad;
+	u16 iocb_cnt;
+};
+
 typedef struct srb {
 	/*
 	 * Do not move cmd_type field, it needs to
@@ -556,6 +562,7 @@ typedef struct srb {
 	 */
 	uint8_t cmd_type;
 	uint8_t pad[3];
+	struct iocb_resource iores;
 	atomic_t ref_count;
 	wait_queue_head_t nvme_ls_waitq;
 	struct fc_port *fcport;
@@ -3396,6 +3403,7 @@ struct qla_qpair {
 	uint32_t fw_started:1;
 	uint32_t enable_class_2:1;
 	uint32_t enable_explicit_conf:1;
+	uint32_t fw_res_tracking:1;
 	uint32_t use_shadow_reg:1;
 
 	uint16_t id;			/* qp number used with FW */
@@ -3433,6 +3441,24 @@ struct scsi_qlt_host {
 	struct qla_tgt *qla_tgt;
 };
 
+struct qla_fw_resources {
+	spinlock_t rescnt_lock;
+#define DEF_RES_INI_IOCBS 256
+#define DEF_RES_TGT_IOCBS 256
+#define DEF_RES_BUSY_IOCBS 32
+	u32 tgt_iocbs_reserve;
+	u32 ini_iocbs_reserve;
+	u32 busy_iocbs_reserve;
+	u32 tgt_iocbs_max;
+	u32 ini_iocbs_max;
+	u32 share_iocbs_max;
+
+	/* these fields start high */
+	atomic_t share_iocbs_used;
+	atomic_t tgt_iocbs_used;
+	atomic_t ini_iocbs_used;
+};
+
 struct qlt_hw_data {
 	/* Protected by hw lock */
 	uint32_t node_name_set:1;
@@ -3461,6 +3487,9 @@ struct qlt_hw_data {
 	struct dentry *dfs_tgt_sess;
 	struct dentry *dfs_tgt_port_database;
 	struct dentry *dfs_naqp;
+	struct dentry *dfs_ini_iocbs;
+	struct dentry *dfs_tgt_iocbs;
+	struct dentry *dfs_busy_iocbs;
 
 	struct list_head q_full_list;
 	uint32_t num_pend_cmds;
@@ -3540,7 +3569,6 @@ struct qla_hw_data {
 		uint32_t	n2n_ae:1;
 		uint32_t	fw_started:1;
 		uint32_t	fw_init_done:1;
-
 		uint32_t	detected_lr_sfp:1;
 		uint32_t	using_lr_setting:1;
 	} flags;
@@ -4103,6 +4131,7 @@ struct qla_hw_data {
 
 	struct qlt_hw_data tgt;
 	int	allow_cna_fw_dump;
+	struct qla_fw_resources fwres;
 	uint32_t fw_ability_mask;
 	uint16_t min_link_speed;
 	uint16_t max_speed_sup;
@@ -4406,7 +4435,6 @@ struct qla2_sgx {
 #define QLA_QPAIR_MARK_NOT_BUSY(__qpair)		\
 	atomic_dec(&__qpair->ref_count);		\
 
-
 #define QLA_ENA_CONF(_ha) {\
     int i;\
     _ha->base_qpair->enable_explicit_conf = 1;	\
@@ -4425,6 +4453,24 @@ struct qla2_sgx {
     }						\
 }
 
+#define QLA_ENA_FW_RES_TRACKING(_ha) { \
+	int i; \
+	_ha->base_qpair->fw_res_tracking = 1; \
+	for (i = 0; i < _ha->max_qpairs; i++) { \
+		if (_ha->queue_pair_map[i]) \
+		_ha->queue_pair_map[i]->fw_res_tracking = 1; \
+	} \
+}
+
+#define QLA_DIS_FW_RES_TRACKING(_ha) { \
+	int i; \
+	_ha->base_qpair->fw_res_tracking = 0; \
+	for (i = 0; i < _ha->max_qpairs; i++) { \
+		if (_ha->queue_pair_map[i]) \
+		_ha->queue_pair_map[i]->fw_res_tracking = 0; \
+	} \
+}
+
 /*
  * qla2x00 local function return status codes
  */
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index d231e7156134..87a18a00d509 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -418,6 +418,278 @@ static const struct file_operations dfs_naqp_ops = {
 	.write		= qla_dfs_naqp_write,
 };
 
+static int
+qla_dfs_ini_iocbs_show(struct seq_file *s, void *unused)
+{
+	struct scsi_qla_host *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!qla_dual_mode_enabled(vha)) {
+		seq_puts(s,
+		    "This field requires Dual Mode to be enabled\n");
+		return 0;
+	}
+
+	seq_printf(s, "%d\n", ha->fwres.ini_iocbs_reserve);
+
+	return 0;
+}
+
+static int
+qla_dfs_ini_iocbs_open(struct inode *inode, struct file *file)
+{
+	struct scsi_qla_host *vha = inode->i_private;
+
+	return single_open(file, qla_dfs_ini_iocbs_show, vha);
+}
+
+static ssize_t qla_dfs_ini_iocbs_write(struct file *file,
+    const char __user *buffer, size_t count, loff_t *pos)
+{
+	struct seq_file *s = file->private_data;
+	struct scsi_qla_host *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+	char *buf;
+	int rc = 0;
+	u32 v = 0;
+
+	buf = memdup_user_nul(buffer, count);
+	if (IS_ERR(buf)) {
+		pr_err("host%ld: fail to copy user buffer",
+		    vha->host_no);
+		return PTR_ERR(buf);
+	}
+
+	rc = kstrtouint(buf, 0, &v);
+	if (rc < 0) {
+		ql_log(ql_log_info, vha, 0x707b,
+		    "Unable to set initiator reserve iocbs\n");
+		goto out_free;
+	}
+
+	if (qla_dual_mode_enabled(vha)) {
+		if ((v < ha->orig_fw_iocb_count) &&
+			(ha->fwres.ini_iocbs_reserve != v)) {
+			ha->fwres.ini_iocbs_reserve = v;
+			ql_log(ql_log_info, vha, 0x7024,
+			    "Resetting. User change initiator reserve iocbs (%d/%d)\n",
+			    v, ha->orig_fw_iocb_count);
+
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+			qla2x00_wait_for_chip_reset(vha);
+		} else {
+			ql_log(ql_log_warn, vha, 0x702e,
+			    "Unable to set initiator reserve iocbs (%d/%d)\n",
+			    v, ha->orig_fw_iocb_count);
+		}
+	} else {
+		if (v < (ha->orig_fw_iocb_count - ha->fwres.tgt_iocbs_reserve -
+			ha->fwres.busy_iocbs_reserve))
+			ha->fwres.ini_iocbs_reserve = v;
+		else
+			ql_log(ql_log_warn, vha, 0x7039,
+			    "Unable to set initiator reserve iocbs (%d/%d/%d/%d)\n",
+			    v, ha->orig_fw_iocb_count,
+			    ha->fwres.tgt_iocbs_reserve,
+			    ha->fwres.busy_iocbs_reserve);
+	}
+
+	rc = count;
+out_free:
+	kfree(buf);
+	return rc;
+}
+
+static const struct file_operations dfs_ini_iocbs_ops = {
+	.open		= qla_dfs_ini_iocbs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= qla_dfs_ini_iocbs_write,
+};
+
+
+static int
+qla_dfs_tgt_iocbs_show(struct seq_file *s, void *unused)
+{
+	struct scsi_qla_host *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!qla_dual_mode_enabled(vha)) {
+		seq_puts(s,
+		    "This field requires Dual Mode to be enabled\n");
+		return 0;
+	}
+
+	seq_printf(s, "%d\n", ha->fwres.tgt_iocbs_reserve);
+
+	return 0;
+}
+
+static int
+qla_dfs_tgt_iocbs_open(struct inode *inode, struct file *file)
+{
+	struct scsi_qla_host *vha = inode->i_private;
+
+	return single_open(file, qla_dfs_tgt_iocbs_show, vha);
+}
+
+static ssize_t
+qla_dfs_tgt_iocbs_write(struct file *file, const char __user *buffer,
+    size_t count, loff_t *pos)
+{
+	struct seq_file *s = file->private_data;
+	struct scsi_qla_host *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+	char *buf;
+	int rc = 0;
+	u32 v = 0;
+
+	buf = memdup_user_nul(buffer, count);
+	if (IS_ERR(buf)) {
+		pr_err("host%ld: fail to copy user buffer.",
+		    vha->host_no);
+		return PTR_ERR(buf);
+	}
+	rc = kstrtouint(buf, 0, &v);
+	if (rc < 0) {
+		ql_log(ql_log_info, vha, 0x70a5,
+		    "Unable to set initiator reserve iocbs.\n");
+		goto out_free;
+	}
+
+	if (qla_dual_mode_enabled(vha)) {
+		if ((v < ha->orig_fw_iocb_count) &&
+			(ha->fwres.ini_iocbs_reserve != v)) {
+			ha->fwres.ini_iocbs_reserve = v;
+			ql_log(ql_log_info, vha, 0x703b,
+			    "Resetting. User changed target reserve iocbs (%d/%d).\n",
+			    v, ha->orig_fw_iocb_count);
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+			qla2x00_wait_for_chip_reset(vha);
+		} else
+			ql_log(ql_log_warn, vha, 0x7045,
+			    "Unable to set target reserve iocbs (%d/%d).\n",
+			    v, ha->orig_fw_iocb_count);
+	} else {
+		if (v < (ha->orig_fw_iocb_count - ha->fwres.ini_iocbs_reserve -
+			ha->fwres.busy_iocbs_reserve))
+			ha->fwres.tgt_iocbs_reserve = v;
+		else
+			ql_log(ql_log_warn, vha, 0x7047,
+			    "Unable to set target reserve iocbs (%d/%d/%d/%d).\n",
+			    v, ha->orig_fw_iocb_count,
+			    ha->fwres.ini_iocbs_reserve,
+			    ha->fwres.busy_iocbs_reserve);
+	}
+
+	rc = count;
+out_free:
+	kfree(buf);
+	return rc;
+}
+
+static const struct file_operations dfs_tgt_iocbs_ops = {
+	.open		= qla_dfs_tgt_iocbs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= qla_dfs_tgt_iocbs_write,
+};
+
+static int
+qla_dfs_busy_iocbs_show(struct seq_file *s, void *unused)
+{
+	struct scsi_qla_host *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!qla_dual_mode_enabled(vha)) {
+		seq_puts(s,
+		    "This field requires Dual Mode to be enabled\n");
+		return 0;
+	}
+
+	seq_printf(s, "%d\n", ha->fwres.busy_iocbs_reserve);
+
+	return 0;
+}
+
+static int
+qla_dfs_busy_iocbs_open(struct inode *inode, struct file *file)
+{
+	struct scsi_qla_host *vha = inode->i_private;
+
+	return single_open(file, qla_dfs_busy_iocbs_show, vha);
+}
+
+static ssize_t
+qla_dfs_busy_iocbs_write(struct file *file, const char __user *buffer,
+    size_t count, loff_t *pos)
+{
+	struct seq_file *s = file->private_data;
+	struct scsi_qla_host *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+	char *buf;
+	int rc = 0;
+	u32 v = 0;
+
+	buf = memdup_user_nul(buffer, count);
+	if (IS_ERR(buf)) {
+		pr_err("host%ld: fail to copy user buffer.",
+		    vha->host_no);
+		return PTR_ERR(buf);
+	}
+
+	rc = kstrtouint(buf, 0, &v);
+	if (rc < 0) {
+		ql_log(ql_log_info, vha, 0x70a6,
+		    "Unable to set initiator reserve iocbs.\n");
+		goto out_free;
+	}
+
+	if (qla_dual_mode_enabled(vha)) {
+		if ((v < ha->orig_fw_iocb_count) &&
+			(ha->fwres.busy_iocbs_reserve != v)) {
+			ha->fwres.busy_iocbs_reserve = v;
+			ql_log(ql_log_info, vha, 0x7073,
+			    "Resetting. User change Busy reserve iocbs (%d/%d).\n",
+			    v, ha->orig_fw_iocb_count);
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+			qla2x00_wait_for_chip_reset(vha);
+		} else {
+			ql_log(ql_log_warn, vha, 0x7074,
+			    "Unable to set busy reserve iocbs (%d/%d).\n",
+			    v, ha->orig_fw_iocb_count);
+		}
+	} else {
+		if (v < (ha->orig_fw_iocb_count - ha->fwres.ini_iocbs_reserve -
+			ha->fwres.tgt_iocbs_reserve))
+			ha->fwres.busy_iocbs_reserve = v;
+		else
+			ql_log(ql_log_warn, vha, 0x7075,
+			    "Unable to set busy reserve iocbs (%d/%d/%d/%d).\n",
+			    v, ha->orig_fw_iocb_count,
+			    ha->fwres.ini_iocbs_reserve,
+			    ha->fwres.tgt_iocbs_reserve);
+	}
+
+	rc = count;
+out_free:
+	kfree(buf);
+	return rc;
+}
+
+static const struct file_operations dfs_busy_iocbs_ops = {
+	.open		= qla_dfs_busy_iocbs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= qla_dfs_busy_iocbs_write,
+};
+
 
 int
 qla2x00_dfs_setup(scsi_qla_host_t *vha)
@@ -504,6 +776,33 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 			    "Unable to create debugFS naqp node.\n");
 			goto out;
 		}
+
+		if (ql2xtrackfwres) {
+			ha->tgt.dfs_ini_iocbs =
+				debugfs_create_file("reserve_ini_iocbs",
+				0400, ha->dfs_dir, vha, &dfs_ini_iocbs_ops);
+			if (!ha->tgt.dfs_ini_iocbs) {
+				ql_log(ql_log_warn, vha, 0xd011,
+				    "Unable to create debugFS reserve_ini_iocbs node.\n");
+				goto out;
+			}
+			ha->tgt.dfs_tgt_iocbs =
+				debugfs_create_file("reserve_tgt_iocbs",
+				0400, ha->dfs_dir, vha, &dfs_tgt_iocbs_ops);
+			if (!ha->tgt.dfs_tgt_iocbs) {
+				ql_log(ql_log_warn, vha, 0xd011,
+				    "Unable to create debugFS reserve_tgt_iocbs node.\n");
+				goto out;
+			}
+			ha->tgt.dfs_busy_iocbs =
+				debugfs_create_file("reserve_busy_iocbs",
+				0400, ha->dfs_dir, vha, &dfs_busy_iocbs_ops);
+			if (!ha->tgt.dfs_busy_iocbs) {
+				ql_log(ql_log_warn, vha, 0xd011,
+				    "Unable to create debugFS reserve_busy_iocbs node.\n");
+				goto out;
+			}
+		}
 	}
 out:
 	return 0;
@@ -514,6 +813,22 @@ qla2x00_dfs_remove(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
+
+	if (ha->tgt.dfs_ini_iocbs) {
+		debugfs_remove(ha->tgt.dfs_ini_iocbs);
+		ha->tgt.dfs_ini_iocbs = NULL;
+	}
+
+	if (ha->tgt.dfs_tgt_iocbs) {
+		debugfs_remove(ha->tgt.dfs_tgt_iocbs);
+		ha->tgt.dfs_tgt_iocbs = NULL;
+	}
+
+	if (ha->tgt.dfs_busy_iocbs) {
+		debugfs_remove(ha->tgt.dfs_busy_iocbs);
+		ha->tgt.dfs_busy_iocbs = NULL;
+	}
+
 	if (ha->tgt.dfs_naqp) {
 		debugfs_remove(ha->tgt.dfs_naqp);
 		ha->tgt.dfs_naqp = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index bf907386f177..66dcbdb91244 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -148,6 +148,7 @@ extern int ql2xuctrlirq;
 extern int ql2xnvmeenable;
 extern int ql2xautodetectsfp;
 extern int ql2xenablemsix;
+extern int ql2xtrackfwres;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 24d0f9d419d2..429305caef47 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3108,6 +3108,42 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 						    MIN_MULTI_ID_FABRIC - 1;
 				}
 				qla2x00_get_resource_cnts(vha);
+				if (ql2xtrackfwres) {
+					if (qla_dual_mode_enabled(vha)) {
+						ha->fwres.tgt_iocbs_max =
+						  ha->orig_fw_iocb_count -
+						  ha->fwres.ini_iocbs_reserve -
+						  ha->fwres.busy_iocbs_reserve;
+						ha->fwres.ini_iocbs_max =
+						  ha->orig_fw_iocb_count -
+						  ha->fwres.tgt_iocbs_reserve -
+						  ha->fwres.busy_iocbs_reserve;
+						ha->fwres.share_iocbs_max =
+						  ha->orig_fw_iocb_count -
+						  ha->fwres.ini_iocbs_reserve -
+						  ha->fwres.tgt_iocbs_reserve -
+						  ha->fwres.busy_iocbs_reserve;
+
+					} else if (qla_tgt_mode_enabled(vha)) {
+						ha->fwres.tgt_iocbs_max =
+						  ha->orig_fw_iocb_count -
+						  ha->fwres.busy_iocbs_reserve;
+						ha->fwres.ini_iocbs_max = 0;
+						ha->fwres.share_iocbs_max =
+						  ha->orig_fw_iocb_count -
+						  ha->fwres.ini_iocbs_reserve -
+						  ha->fwres.tgt_iocbs_reserve -
+						  ha->fwres.busy_iocbs_reserve;
+					} else
+						QLA_DIS_FW_RES_TRACKING(ha);
+
+					atomic_set(&ha->fwres.ini_iocbs_used,
+						ha->fwres.ini_iocbs_max);
+					atomic_set(&ha->fwres.tgt_iocbs_used,
+						ha->fwres.tgt_iocbs_max);
+					atomic_set(&ha->fwres.share_iocbs_used,
+						ha->fwres.share_iocbs_max);
+				}
 
 				/*
 				 * Allocate the array of outstanding commands
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 4d32426393c7..d8dc6dea1525 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -221,6 +221,7 @@ qla2xxx_get_qpair_sp(struct qla_qpair *qpair, fc_port_t *fcport, gfp_t flag)
 	sp->fcport = fcport;
 	sp->iocbs = 1;
 	sp->vha = qpair->vha;
+	sp->qpair = qpair;
 done:
 	if (!sp)
 		QLA_QPAIR_MARK_NOT_BUSY(qpair);
@@ -253,6 +254,7 @@ qla2x00_get_sp(scsi_qla_host_t *vha, fc_port_t *fcport, gfp_t flag)
 	sp->cmd_type = TYPE_SRB;
 	sp->iocbs = 1;
 	sp->vha = vha;
+	sp->qpair = vha->hw->base_qpair;
 done:
 	if (!sp)
 		QLA_VHA_MARK_NOT_BUSY(vha);
@@ -366,3 +368,103 @@ qla_83xx_start_iocbs(struct qla_qpair *qpair)
 
 	WRT_REG_DWORD(req->req_q_in, req->ring_index);
 }
+
+enum {
+	RESOURCE_NONE,
+	RESOURCE_INI,
+	RESOURCE_TGT,
+	RESOURCE_SHR,
+};
+
+static inline int
+qla_get_iocbs(struct qla_hw_data *ha, struct iocb_resource *iores)
+{
+	unsigned long flags;
+
+	switch (iores->res_type) {
+	case RESOURCE_TGT:
+		/* spin lock is required here because atomic lib is unable
+		 * to do "check 1st and sub" under 1 atomic operaton.
+		 */
+		spin_lock_irqsave(&ha->fwres.rescnt_lock, flags);
+		if (atomic_read(&ha->fwres.share_iocbs_used) <
+		    iores->iocb_cnt) {
+			/* share pool is emptied */
+			if (atomic_read(&ha->fwres.tgt_iocbs_used) <
+			    iores->iocb_cnt) {
+				iores->res_type = RESOURCE_NONE;
+				spin_unlock_irqrestore(&ha->fwres.rescnt_lock,
+				    flags);
+				return -EAGAIN;
+			}
+
+			atomic_sub(iores->iocb_cnt, &ha->fwres.tgt_iocbs_used);
+			iores->res_type = RESOURCE_TGT;
+			spin_unlock_irqrestore(&ha->fwres.rescnt_lock, flags);
+			return 0;
+		}
+
+		atomic_sub(iores->iocb_cnt, &ha->fwres.share_iocbs_used);
+		iores->res_type = RESOURCE_SHR;
+		spin_unlock_irqrestore(&ha->fwres.rescnt_lock, flags);
+
+		return 0;
+
+	case RESOURCE_INI:
+		spin_lock_irqsave(&ha->fwres.rescnt_lock, flags);
+		if (atomic_read(&ha->fwres.share_iocbs_used) <
+		    iores->iocb_cnt) {
+			if (atomic_read(&ha->fwres.ini_iocbs_used) <
+			    iores->iocb_cnt) {
+				/* fail to get resource */
+				iores->res_type = RESOURCE_NONE;
+				spin_unlock_irqrestore(&ha->fwres.rescnt_lock,
+				    flags);
+				return -EAGAIN;
+			} else {
+				atomic_sub(iores->iocb_cnt,
+				    &ha->fwres.ini_iocbs_used);
+				iores->res_type = RESOURCE_INI;
+				spin_unlock_irqrestore(&ha->fwres.rescnt_lock,
+				    flags);
+				return 0;
+			}
+		}
+		atomic_sub(iores->iocb_cnt, &ha->fwres.share_iocbs_used);
+		iores->res_type = RESOURCE_SHR;
+		spin_unlock_irqrestore(&ha->fwres.rescnt_lock, flags);
+		return 0;
+
+	default:
+		break;
+	}
+
+	return -EIO;
+}
+
+static inline void
+qla_put_iocbs(struct qla_qpair *qpair, struct iocb_resource *iores)
+{
+	struct scsi_qla_host *vha;
+
+	if (!qpair || !qpair->fw_res_tracking)
+		return;
+
+	vha = qpair->vha;
+
+	switch (iores->res_type) {
+	case RESOURCE_TGT:
+		atomic_add(iores->iocb_cnt, &vha->hw->fwres.tgt_iocbs_used);
+		break;
+	case RESOURCE_INI:
+		atomic_add(iores->iocb_cnt, &vha->hw->fwres.ini_iocbs_used);
+		break;
+	case RESOURCE_SHR:
+		atomic_add(iores->iocb_cnt, &vha->hw->fwres.share_iocbs_used);
+		break;
+	default:
+		break;
+	}
+
+	iores->res_type = RESOURCE_NONE;
+}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 62b3d0a8a961..417c40f21244 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1460,6 +1460,14 @@ qla24xx_start_scsi(srb_t *sp)
 
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+
+	if (ha->base_qpair->fw_res_tracking) {
+		sp->iores.iocb_cnt = req_cnt;
+		sp->iores.res_type = RESOURCE_INI;
+		if (qla_get_iocbs(ha, &sp->iores))
+			goto queuing_error;
+	}
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    RD_REG_DWORD_RELAXED(req->req_q_out);
@@ -1538,6 +1546,7 @@ qla24xx_start_scsi(srb_t *sp)
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
+	qla_put_iocbs(ha->base_qpair, &sp->iores);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -1661,6 +1670,13 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	/* Total Data and protection sg segment(s) */
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
+	if (ha->base_qpair->fw_res_tracking) {
+		sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+		sp->iores.res_type = RESOURCE_INI;
+		if (qla_get_iocbs(ha, &sp->iores))
+			goto queuing_error;
+	}
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    RD_REG_DWORD_RELAXED(req->req_q_out);
@@ -1739,6 +1755,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 		req->outstanding_cmds[handle] = NULL;
 		req->cnt += req_cnt;
 	}
+	qla_put_iocbs(ha->base_qpair, &sp->iores);
 	/* Cleanup will be performed by the caller (queuecommand) */
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1813,6 +1830,13 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	if (qpair->fw_res_tracking) {
+		sp->iores.iocb_cnt = req_cnt;
+		sp->iores.res_type = RESOURCE_INI;
+		if (qla_get_iocbs(ha, &sp->iores))
+			goto queuing_error;
+	}
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    RD_REG_DWORD_RELAXED(req->req_q_out);
@@ -1890,6 +1914,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
+	qla_put_iocbs(qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -2028,6 +2053,14 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	/* Total Data and protection sg segment(s) */
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
+
+	if (qpair->fw_res_tracking) {
+		sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+		sp->iores.res_type = RESOURCE_INI;
+		if (qla_get_iocbs(ha, &sp->iores))
+			goto queuing_error;
+	}
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    RD_REG_DWORD_RELAXED(req->req_q_out);
@@ -2103,6 +2136,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 		req->outstanding_cmds[handle] = NULL;
 		req->cnt += req_cnt;
 	}
+	qla_put_iocbs(qpair, &sp->iores);
 	/* Cleanup will be performed by the caller (queuecommand) */
 
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
@@ -3625,6 +3659,14 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 
 	/* Calculate number of IOCB required */
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	if (ha->base_qpair->fw_res_tracking) {
+		sp->iores.iocb_cnt = req_cnt;
+		sp->iores.res_type = RESOURCE_INI;
+		if (qla_get_iocbs(ha, &sp->iores)) {
+			rval = EXT_STATUS_BUSY;
+			goto queuing_error;
+		}
+	}
 
 	/* Check for room on request queue. */
 	if (req->cnt < req_cnt + 2) {
@@ -3667,6 +3709,9 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 	wmb();
 	qla2x00_start_iocbs(vha, req);
 queuing_error:
+	if (rval)
+		qla_put_iocbs(ha->base_qpair, &sp->iores);
+
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 33865e0bb29f..7ae8d4d22952 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1283,6 +1283,8 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 		/* Free outstanding command slot. */
 		req->outstanding_cmds[index] = NULL;
 
+		qla_put_iocbs(sp->qpair, &sp->iores);
+
 		/* Save ISP completion status */
 		sp->done(sp, DID_OK << 16);
 	} else {
@@ -2368,6 +2370,9 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	/* Always return DID_OK, bsg will send the vendor specific response
 	 * in this case only */
+
+	qla_put_iocbs(sp->qpair, &sp->iores);
+
 	sp->done(sp, DID_OK << 6);
 
 }
@@ -2745,8 +2750,10 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		    cp->cmnd, scsi_bufflen(cp), rsp_info_len,
 		    resid_len, fw_resid_len, sp, cp);
 
-	if (rsp->status_srb == NULL)
+	if (rsp->status_srb == NULL) {
+		qla_put_iocbs(sp->qpair, &sp->iores);
 		sp->done(sp, res);
+	}
 }
 
 /**
@@ -2849,6 +2856,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	case MBX_IOCB_TYPE:
 		sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 		if (sp) {
+			qla_put_iocbs(sp->qpair, &sp->iores);
 			sp->done(sp, res);
 			return 0;
 		}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 029b95b2bd8a..7f361e93c593 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -277,6 +277,11 @@ MODULE_PARM_DESC(ql2xenablemsix,
 		 " 1 -- enable MSI-X interrupt mechanism.\n"
 		 " 2 -- enable MSI interrupt mechanism.\n");
 
+int ql2xtrackfwres;
+module_param(ql2xtrackfwres, int, 0444);
+MODULE_PARM_DESC(ql2xtrackfwres,
+		 "Track FW resource.  0(default): disabled");
+
 /*
  * SCSI host template entry points
  */
@@ -1772,6 +1777,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 							atomic_dec(
 							    &sp->ref_count);
 					}
+					qla_put_iocbs(sp->qpair, &sp->iores);
 					sp->done(sp, res);
 				} else {
 					if (!vha->hw->tgt.tgt_ops || !tgt ||
@@ -2790,6 +2796,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->link_data_rate = PORT_SPEED_UNKNOWN;
 	ha->optrom_size = OPTROM_SIZE_2300;
 	ha->max_exchg = FW_MAX_EXCHANGES_CNT;
+	ha->fwres.ini_iocbs_reserve = DEF_RES_INI_IOCBS;
+	ha->fwres.tgt_iocbs_reserve = DEF_RES_TGT_IOCBS;
+	ha->fwres.busy_iocbs_reserve = DEF_RES_BUSY_IOCBS;
+	spin_lock_init(&ha->fwres.rescnt_lock);
 
 	/* Assign ISP specific operations. */
 	if (IS_QLA2100(ha)) {
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index fcfdbe1420cd..0d77b2f67077 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2628,6 +2628,14 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 		}
 	}
 
+	if (cmd->qpair->fw_res_tracking) {
+		cmd->iores.iocb_cnt = *full_req_cnt;
+		cmd->iores.res_type = RESOURCE_TGT;
+		if (qla_get_iocbs(cmd->vha->hw, &cmd->iores)) {
+			qlt_unmap_sg(cmd->vha, cmd);
+			return -EAGAIN;
+		}
+	}
 	return 0;
 }
 
@@ -3202,6 +3210,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 out_unmap_unlock:
 	qlt_unmap_sg(vha, cmd);
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+	qla_put_iocbs(qpair, &cmd->iores);
 
 	return res;
 }
@@ -3243,6 +3252,14 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	}
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+
+	if (cmd->qpair->fw_res_tracking) {
+		cmd->iores.iocb_cnt = prm.req_cnt;
+		cmd->iores.res_type = RESOURCE_TGT;
+		if (qla_get_iocbs(cmd->vha->hw, &cmd->iores))
+			goto out_unlock_free_unmap;
+	}
+
 	/* Does F/W have an IOCBs for this request */
 	res = qlt_check_reserve_free_req(qpair, prm.req_cnt);
 	if (res != 0)
@@ -3281,6 +3298,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	qlt_unmap_sg(vha, cmd);
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
+	qla_put_iocbs(qpair, &cmd->iores);
 	return res;
 }
 EXPORT_SYMBOL(qlt_rdy_to_xfer);
@@ -3810,6 +3828,8 @@ qlt_abort_cmd_on_host_reset(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 		dump_stack();
 	}
 
+	qla_put_iocbs(cmd->qpair, &cmd->iores);
+
 	cmd->trc_flags |= TRC_FLUSH;
 	ha->tgt.tgt_ops->free_cmd(cmd);
 }
@@ -3841,6 +3861,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 
 	se_cmd = &cmd->se_cmd;
 	cmd->cmd_sent_to_fw = 0;
+	qla_put_iocbs(cmd->qpair, &cmd->iores);
 
 	qlt_unmap_sg(vha, cmd);
 
@@ -6412,6 +6433,9 @@ qlt_enable_vha(struct scsi_qla_host *vha)
 		qla24xx_disable_vp(vha);
 		qla24xx_enable_vp(vha);
 	} else {
+		if (ql2xtrackfwres && (IS_QLA83XX(ha) || IS_QLA27XX(ha)))
+			QLA_ENA_FW_RES_TRACKING(ha);
+
 		set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 		qla2xxx_wake_dpc(base_vha);
 		qla2x00_wait_for_hba_online(base_vha);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index aba58d3848a6..588c8bcf1192 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -877,7 +877,8 @@ struct qla_tgt_cmd {
 	 * Do not move cmd_type field. it needs to line up with srb->cmd_type
 	 */
 	uint8_t cmd_type;
-	uint8_t pad[7];
+	uint8_t pad[3];
+	struct iocb_resource iores;
 	struct se_cmd se_cmd;
 	struct fc_port *sess;
 	struct qla_qpair *qpair;
-- 
2.12.0
