From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 15/22] qla2xxx: Rename qlini_mode parameter
Date: Tue, 6 Dec 2016 12:30:44 -0800
Message-ID: <1481056251-2310-16-git-send-email-himanshu.madhani@cavium.com>
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

Qlogic's adapter is able to behave in multiple modes:
initiator, target, exclusive/either, and dual/both.

This patch renames the qlini_mode -> qlop_mode and allow
different setting for each port and exchange resource control.

Usage:
modprobe qla2xxx qlop_mode=dual_mode

echo 95 > /sys/class/scsi_host/<host X>/ql_dm_tgt_ex_pct

echo dual_mode > /sys/class/scsi_host/<host X>/f_qlop_mode
echo ini_mode > /sys/class/scsi_host/<host Y>/f_qlop_mode

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   | 351 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h    |   4 +
 drivers/scsi/qla2xxx/qla_gbl.h    |   4 +
 drivers/scsi/qla2xxx/qla_os.c     |   4 +
 drivers/scsi/qla2xxx/qla_target.c | 117 ++++++-------
 drivers/scsi/qla2xxx/qla_target.h |  22 +--
 6 files changed, 425 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index f48b76c..d8b77aa 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1504,6 +1504,351 @@
 	    ha->pep_version[0], ha->pep_version[1], ha->pep_version[2]);
 }
 
+
+static ssize_t
+qla2x00_tgt_ex_pct_show(struct device *dev, struct device_attribute *attr,
+		 char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	int len = 0;
+
+	if (ql2x_op_mode == QLA2XXX_OP_MODE_INITIATOR) {
+		len += scnprintf(buf + len, PAGE_SIZE-len,
+		    "This option is not supported. Driver need to be loaded with "
+		    "non-initiator mode (qlop_mode)");
+		return len;
+	}
+
+	len += scnprintf(buf + len, PAGE_SIZE-len,
+	    "target exchange percentage: new %d : current: %d\n\n",
+	    vha->u_tgt_ex_pct, vha->tgt_ex_pct);
+
+	len += scnprintf(buf + len, PAGE_SIZE-len,
+	    "Please (re)set operating mode via \"f_qlop_mode\" to load new setting\n");
+	return len;
+}
+
+static ssize_t
+qla2x00_tgt_ex_pct_store(struct device *dev, struct device_attribute *attr,
+		  const char *buf, size_t count)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	int val = 0;
+
+	if (ql2x_op_mode == QLA2XXX_OP_MODE_INITIATOR)
+		goto out;
+
+	if (sscanf(buf, "%d", &val) != 1)
+		return -EINVAL;
+
+	if (val > 100)
+		val = 100;
+	else if (val < 0)
+		val = 0;
+
+	vha->u_tgt_ex_pct = val;
+out:
+	return strlen(buf);
+}
+
+static ssize_t
+qla2x00_opmode_show(struct device *dev, struct device_attribute *attr,
+		 char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	int len = 0;
+
+	if (ql2x_op_mode == QLA2XXX_OP_MODE_INITIATOR) {
+		len += scnprintf(buf + len, PAGE_SIZE-len,
+			"This option is not supported.  Driver need to be loaded with "
+			"non-initiator mode (qlop_mode)");
+		return len;
+	}
+
+	len += scnprintf(buf + len, PAGE_SIZE-len,
+	    "Supported options: exclusive | tgt_mode | ini_mode | dual_mode\n");
+
+	/* --- */
+	len += scnprintf(buf + len, PAGE_SIZE-len, "Current selection: ");
+
+	switch (vha->qlop_mode) {
+	case QLA2XXX_OP_MODE_EXCLUSIVE:
+		len += scnprintf(buf + len, PAGE_SIZE-len,
+			QLA2XXX_OP_MODE_STR_EXCLUSIVE);
+		break;
+	case QLA2XXX_OP_MODE_TARGET:
+		len += scnprintf(buf + len, PAGE_SIZE-len,
+			QLA2XXX_OP_MODE_STR_TARGET);
+		break;
+	case QLA2XXX_OP_MODE_INITIATOR:
+		len += scnprintf(buf + len, PAGE_SIZE-len,
+			QLA2XXX_OP_MODE_STR_INITIATOR);
+		break;
+	case QLA2XXX_OP_MODE_DUAL:
+		len += scnprintf(buf + len, PAGE_SIZE-len,
+			QLA2XXX_OP_MODE_STR_DUAL);
+		break;
+	}
+	len += scnprintf(buf + len, PAGE_SIZE-len, "\n");
+
+	return len;
+}
+
+
+void qla_adj_tgt_exch_pct(scsi_qla_host_t *vha, int op)
+{
+	/* reserve a few exchange for FW for mgt. */
+	switch (op) {
+	case QLA2XXX_OP_MODE_TARGET:
+		vha->u_tgt_ex_pct = MAX_TGT_EXCH_PCT;
+		break;
+
+	case QLA2XXX_OP_MODE_EXCLUSIVE:
+		if (qla_tgt_mode_enabled(vha) ||
+			qla_dual_mode_enabled(vha)) {
+			vha->u_tgt_ex_pct = MAX_TGT_EXCH_PCT;
+		} else
+			vha->u_tgt_ex_pct = 0;
+		break;
+
+	case QLA2XXX_OP_MODE_INITIATOR:
+		/* target mode does not need any exchange reserve. */
+		vha->u_tgt_ex_pct = 0;
+		break;
+
+	case QLA2XXX_OP_MODE_DUAL:
+		if (vha->u_tgt_ex_pct >= 100)
+			vha->u_tgt_ex_pct = MAX_TGT_EXCH_PCT;
+
+		if (vha->u_tgt_ex_pct <= 0)
+			vha->u_tgt_ex_pct = MIN_TGT_EXCH_PCT;
+		break;
+	}
+}
+
+static
+int qla_set_opmode(scsi_qla_host_t *vha, int op)
+{
+	int rc = 0;
+	enum {
+		NO_ACTION,
+		MODE_CHANGE_ACCEPT,
+		MODE_CHANGE_NO_ACTION,
+		TARGET_STILL_ACTIVE,
+	};
+	int action = NO_ACTION;
+	int set_mode = 0;
+
+	qla_adj_tgt_exch_pct(vha, op);
+
+	switch (vha->qlop_mode) {
+	case QLA2XXX_OP_MODE_TARGET:
+		switch (op) {
+		case QLA2XXX_OP_MODE_TARGET:
+			if (qla_tgt_mode_enabled(vha)) {
+				if (vha->tgt_ex_pct != vha->u_tgt_ex_pct)
+					action = MODE_CHANGE_ACCEPT;
+			} else {
+				action = MODE_CHANGE_NO_ACTION;
+			}
+			break;
+
+		case QLA2XXX_OP_MODE_EXCLUSIVE:
+			if (qla_tgt_mode_enabled(vha)) {
+				if (vha->tgt_ex_pct != vha->u_tgt_ex_pct)
+					action = MODE_CHANGE_ACCEPT;
+				else
+					action = MODE_CHANGE_NO_ACTION;
+			} else {
+				action = MODE_CHANGE_ACCEPT;
+			}
+			break;
+
+		case QLA2XXX_OP_MODE_DUAL:
+			action = MODE_CHANGE_ACCEPT;
+			/* active_mode is target only, reset it to dual */
+			if (qla_tgt_mode_enabled(vha))
+				set_mode = 1;
+			break;
+
+		case QLA2XXX_OP_MODE_INITIATOR:
+			if (qla_tgt_mode_enabled(vha))
+				action = TARGET_STILL_ACTIVE;
+			else
+				action = MODE_CHANGE_ACCEPT;
+			break;
+		}
+		break;
+
+	case QLA2XXX_OP_MODE_EXCLUSIVE:
+		switch (op) {
+		case QLA2XXX_OP_MODE_EXCLUSIVE:
+			if (qla_tgt_mode_enabled(vha)) {
+				if (vha->tgt_ex_pct != vha->u_tgt_ex_pct)
+					action = MODE_CHANGE_ACCEPT;
+				else
+					action = NO_ACTION;
+			} else {
+				action = NO_ACTION;
+			}
+			break;
+
+		case QLA2XXX_OP_MODE_TARGET:
+			if (qla_tgt_mode_enabled(vha)) {
+				if (vha->tgt_ex_pct != vha->u_tgt_ex_pct)
+					action = MODE_CHANGE_ACCEPT;
+				else
+					action = MODE_CHANGE_NO_ACTION;
+			} else {
+				action = MODE_CHANGE_NO_ACTION;
+			}
+			break;
+
+		case QLA2XXX_OP_MODE_DUAL: /* exclusive -> dual */
+			if (qla_tgt_mode_enabled(vha)) {
+				action = MODE_CHANGE_ACCEPT;
+				set_mode = 1;
+			} else {
+				action = MODE_CHANGE_NO_ACTION;
+			}
+			break;
+
+		case QLA2XXX_OP_MODE_INITIATOR:
+			if (qla_tgt_mode_enabled(vha))
+				action = TARGET_STILL_ACTIVE;
+			else
+				action = MODE_CHANGE_NO_ACTION;
+			break;
+		}
+		break;
+
+	case QLA2XXX_OP_MODE_INITIATOR:
+		switch (op) {
+		case QLA2XXX_OP_MODE_INITIATOR:
+			action = NO_ACTION;
+			break;
+		default:
+			action = MODE_CHANGE_NO_ACTION;
+			break;
+		}
+		break;
+
+	case QLA2XXX_OP_MODE_DUAL:
+		switch (op) {
+		case QLA2XXX_OP_MODE_DUAL:
+			if (qla_tgt_mode_enabled(vha) ||
+			    qla_dual_mode_enabled(vha)) {
+				if (vha->tgt_ex_pct != vha->u_tgt_ex_pct)
+					action = MODE_CHANGE_ACCEPT;
+				else
+					action = NO_ACTION;
+			} else {
+				action = MODE_CHANGE_NO_ACTION;
+			}
+			break;
+
+		case QLA2XXX_OP_MODE_TARGET:
+			if (qla_tgt_mode_enabled(vha) ||
+			    qla_dual_mode_enabled(vha)) {
+				/* turning off initiator mode */
+				set_mode = 1;
+				action = MODE_CHANGE_ACCEPT;
+			} else {
+				action = MODE_CHANGE_NO_ACTION;
+			}
+			break;
+
+		case QLA2XXX_OP_MODE_EXCLUSIVE:
+			if (qla_tgt_mode_enabled(vha) ||
+			    qla_dual_mode_enabled(vha)) {
+				set_mode = 1;
+				action = MODE_CHANGE_ACCEPT;
+			} else {
+				action = MODE_CHANGE_NO_ACTION;
+			}
+			break;
+
+		case QLA2XXX_OP_MODE_INITIATOR:
+			if (qla_tgt_mode_enabled(vha) ||
+			    qla_dual_mode_enabled(vha))
+				action = TARGET_STILL_ACTIVE;
+			else
+				action = MODE_CHANGE_NO_ACTION;
+		}
+		break;
+	}
+
+	switch (action) {
+	case MODE_CHANGE_ACCEPT:
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "Mode change accepted %d|%d exch pct %d|%d.\n",
+		    vha->qlop_mode, op,
+		    vha->tgt_ex_pct, vha->u_tgt_ex_pct);
+		vha->qlop_mode = op;
+		vha->tgt_ex_pct = vha->u_tgt_ex_pct;
+		if (set_mode)
+			qlt_set_mode(vha);
+
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		break;
+
+	case MODE_CHANGE_NO_ACTION:
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "Mode is set. No action taken. %d|%d pct %d|%d.\n",
+		    vha->qlop_mode, op,
+		    vha->tgt_ex_pct, vha->u_tgt_ex_pct);
+		vha->tgt_ex_pct = vha->u_tgt_ex_pct;
+		vha->qlop_mode = op;
+		break;
+
+	case TARGET_STILL_ACTIVE:
+	    ql_log(ql_log_warn, vha, 0xffff,
+		"Target Mode is active. Unable to change Mode.\n");
+		break;
+
+	case NO_ACTION:
+	default:
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "Mode unchange. No action taken. %d|%d pct %d|%d.\n",
+		    vha->qlop_mode, op,
+		    vha->tgt_ex_pct, vha->u_tgt_ex_pct);
+		break;
+	}
+
+	return rc;
+}
+
+static ssize_t
+qla2x00_opmode_store(struct device *dev, struct device_attribute *attr,
+		  const char *buf, size_t count)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	char op_mode[16];
+	int op;
+
+
+	if (ql2x_op_mode == QLA2XXX_OP_MODE_INITIATOR)
+		return -EINVAL;
+
+	memset(op_mode,0,16);
+	if (sscanf(buf, "%15s", op_mode) != 1)
+		return -EINVAL;
+
+	if (strcasecmp(op_mode, QLA2XXX_OP_MODE_STR_EXCLUSIVE) == 0)
+		op = QLA2XXX_OP_MODE_EXCLUSIVE;
+	else if (strcasecmp(op_mode, QLA2XXX_OP_MODE_STR_TARGET) == 0)
+		op = QLA2XXX_OP_MODE_TARGET;
+	else if (strcasecmp(op_mode, QLA2XXX_OP_MODE_STR_INITIATOR) == 0)
+		op = QLA2XXX_OP_MODE_INITIATOR;
+	else if (strcasecmp(op_mode, QLA2XXX_OP_MODE_STR_DUAL) == 0)
+		op = QLA2XXX_OP_MODE_DUAL;
+	else
+		return -EINVAL;
+
+	qla_set_opmode(vha, op);
+	return strlen(buf);
+}
+
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
 static DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
 static DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
@@ -1549,6 +1894,10 @@ static DEVICE_ATTR(allow_cna_fw_dump, S_IRUGO | S_IWUSR,
 		   qla2x00_allow_cna_fw_dump_show,
 		   qla2x00_allow_cna_fw_dump_store);
 static DEVICE_ATTR(pep_version, S_IRUGO, qla2x00_pep_version_show, NULL);
+static DEVICE_ATTR(f_qlop_mode, S_IRUGO | S_IWUSR,
+	qla2x00_opmode_show, qla2x00_opmode_store);
+static DEVICE_ATTR(ql_dm_tgt_ex_pct, S_IRUGO | S_IWUSR,
+	qla2x00_tgt_ex_pct_show, qla2x00_tgt_ex_pct_store);
 
 struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version,
@@ -1583,6 +1932,8 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_fw_dump_size,
 	&dev_attr_allow_cna_fw_dump,
 	&dev_attr_pep_version,
+	&dev_attr_f_qlop_mode,
+	&dev_attr_ql_dm_tgt_ex_pct,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 09da61f..85beab6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4017,6 +4017,10 @@ struct qla_tgt_counters {
 	/* Count of active session/fcport */
 	int fcport_count;
 	wait_queue_head_t fcport_waitQ;
+	int qlop_mode;
+	int tgt_ex_pct, u_tgt_ex_pct;
+#define MAX_TGT_EXCH_PCT 99
+#define MIN_TGT_EXCH_PCT 1
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 944f37a..bc2bf57 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -140,8 +140,10 @@ int qla24xx_post_newsess_work(struct scsi_qla_host *, port_id_t *,
 extern int ql2xexlogins;
 extern int ql2xexchoffld;
 extern int ql2xfwholdabts;
+extern int ql_dm_tgt_ex_pct;
 extern struct workqueue_struct *qla_wq;
 
+
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
 extern int qla2x00_post_aen_work(struct scsi_qla_host *, enum
@@ -645,6 +647,7 @@ extern int qla2x00_echo_test(scsi_qla_host_t *,
 extern int qla24xx_update_all_fcp_prio(scsi_qla_host_t *);
 extern int qla24xx_fcp_prio_cfg_valid(scsi_qla_host_t *,
 	struct qla_fcp_prio_cfg *, uint8_t);
+extern void qla_adj_tgt_exch_pct(scsi_qla_host_t *vha, int op);
 
 /*
  * Global Function Prototypes in qla_dfs.c source file.
@@ -849,5 +852,6 @@ void qlt_plogi_ack_link(struct scsi_qla_host *, qlt_plogi_ack_t *,
 extern struct fc_port *qlt_find_sess_invalidate_other(scsi_qla_host_t *,
 	uint64_t wwn, port_id_t port_id, uint16_t loop_id, struct fc_port **);
 void qla24xx_delete_sess_fn(struct work_struct *);
+void qlt_set_mode(struct scsi_qla_host *);
 
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 18795c3..845527d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4301,6 +4301,10 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	vha->host = host;
 	vha->host_no = host->host_no;
 	vha->hw = ha;
+	vha->qlop_mode = ql2x_op_mode;
+	vha->u_tgt_ex_pct = ql_dm_tgt_ex_pct;
+	qla_adj_tgt_exch_pct(vha, ql2x_op_mode);
+	vha->tgt_ex_pct = vha->u_tgt_ex_pct;
 
 	INIT_LIST_HEAD(&vha->vp_fcports);
 	INIT_LIST_HEAD(&vha->work_list);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cc24d1a..089f4ce 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -45,26 +45,26 @@
 MODULE_PARM_DESC(ql2xtgt_tape_enable,
 		"Enables Sequence level error recovery (aka FC Tape). Default is 0 - no SLER. 1 - Enable SLER.");
 
-static char *qlini_mode = QLA2XXX_INI_MODE_STR_ENABLED;
-module_param(qlini_mode, charp, S_IRUGO);
-MODULE_PARM_DESC(qlini_mode,
-	"Determines when initiator mode will be enabled. Possible values: "
+static char *qlop_mode = QLA2XXX_OP_MODE_STR_INITIATOR;
+module_param(qlop_mode, charp, S_IRUGO);
+MODULE_PARM_DESC(qlop_mode,
+	"Determines operating mode. Possible values: "
 	"\"exclusive\" - initiator mode will be enabled on load, "
 	"disabled on enabling target mode and then on disabling target mode "
 	"enabled back; "
-	"\"disabled\" - initiator mode will never be enabled; "
-	"\"dual\" - Initiator Modes will be enabled. Target Mode can be activated "
-	"when ready "
-	"\"enabled\" (default) - initiator mode will always stay enabled.");
+	"\"tgt_mode\" - Target mode only. Initiator mode will never be enabled; "
+	"\"dual_mode\" - Initiator Modes will be enabled. Target Mode can be "
+	"activated when ready; "
+	"\"ini_mode\" (default) - initiator mode will always stay enabled.");
 
-static int ql_dm_tgt_ex_pct = 50;
+int ql_dm_tgt_ex_pct = 50;
 module_param(ql_dm_tgt_ex_pct, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql_dm_tgt_ex_pct,
-	"For Dual Mode (qlini_mode=dual), this parameter determines "
+	"For Dual Mode (qlop_mode=dual_mode), this parameter determines "
 	"the percentage of exchanges/cmds FW will allocate resources "
 	"for Target mode.");
 
-int ql2x_ini_mode = QLA2XXX_INI_MODE_EXCLUSIVE;
+int ql2x_op_mode = QLA2XXX_OP_MODE_EXCLUSIVE;
 
 static int temp_sam_status = SAM_STAT_BUSY;
 
@@ -6579,17 +6579,17 @@ void qlt_lport_deregister(struct scsi_qla_host *vha)
 EXPORT_SYMBOL(qlt_lport_deregister);
 
 /* Must be called under HW lock */
-static void qlt_set_mode(struct scsi_qla_host *vha)
+void qlt_set_mode(struct scsi_qla_host *vha)
 {
-	switch (ql2x_ini_mode) {
-	case QLA2XXX_INI_MODE_DISABLED:
-	case QLA2XXX_INI_MODE_EXCLUSIVE:
+	switch (vha->qlop_mode) {
+	case QLA2XXX_OP_MODE_TARGET:
+	case QLA2XXX_OP_MODE_EXCLUSIVE:
 		vha->host->active_mode = MODE_TARGET;
 		break;
-	case QLA2XXX_INI_MODE_ENABLED:
+	case QLA2XXX_OP_MODE_INITIATOR:
 		vha->host->active_mode = MODE_UNKNOWN;
 		break;
-	case QLA2XXX_INI_MODE_DUAL:
+	case QLA2XXX_OP_MODE_DUAL:
 		vha->host->active_mode = MODE_DUAL;
 		break;
 
@@ -6601,15 +6601,15 @@ static void qlt_set_mode(struct scsi_qla_host *vha)
 /* Must be called under HW lock */
 static void qlt_clear_mode(struct scsi_qla_host *vha)
 {
-	switch (ql2x_ini_mode) {
-	case QLA2XXX_INI_MODE_DISABLED:
+	switch (vha->qlop_mode) {
+	case QLA2XXX_OP_MODE_TARGET:
 		vha->host->active_mode = MODE_UNKNOWN;
 		break;
-	case QLA2XXX_INI_MODE_EXCLUSIVE:
+	case QLA2XXX_OP_MODE_EXCLUSIVE:
 		vha->host->active_mode = MODE_INITIATOR;
 		break;
-	case QLA2XXX_INI_MODE_ENABLED:
-	case QLA2XXX_INI_MODE_DUAL:
+	case QLA2XXX_OP_MODE_INITIATOR:
+	case QLA2XXX_OP_MODE_DUAL:
 		vha->host->active_mode = MODE_INITIATOR;
 		break;
 	default:
@@ -6844,23 +6844,16 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 			ha->tgt.saved_set = 1;
 		}
 
-		if (qla_tgt_mode_enabled(vha)) {
-			nv->exchange_count = cpu_to_le16(0xFFFF);
-		} else {			/* dual */
-			if (ql_dm_tgt_ex_pct > 100) {
-				ql_dm_tgt_ex_pct = 50;
-			} else if (ql_dm_tgt_ex_pct == 100) {
-				/* leave some for FW */
-				ql_dm_tgt_ex_pct = 95;
-			}
+		if (vha->tgt_ex_pct <= 0)
+			vha->tgt_ex_pct = MIN_TGT_EXCH_PCT;
 
-			tmp = ha->orig_fw_xcb_count * ql_dm_tgt_ex_pct;
-			tmp = tmp/100;
-			if (tmp > 0xffff)
-				tmp = 0xffff;
-			t = tmp & 0xffff;
-			nv->exchange_count = cpu_to_le16(t);
-		}
+		tmp = ha->orig_fw_xcb_count * vha->tgt_ex_pct;
+		tmp = tmp/100;
+		if (tmp > 0xffff)
+			tmp = 0xffff;
+		t = tmp & 0xffff;
+
+		nv->exchange_count = cpu_to_le16(t);
 
 		/* Enable target mode */
 		nv->firmware_options_1 |= cpu_to_le32(BIT_4);
@@ -6966,24 +6959,16 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 			ha->tgt.saved_set = 1;
 		}
 
-		if (qla_tgt_mode_enabled(vha)) {
-			nv->exchange_count = cpu_to_le16(0xFFFF);
-		} else {			/* dual */
-			if (ql_dm_tgt_ex_pct > 100) {
-				ql_dm_tgt_ex_pct = 50;
-			} else if (ql_dm_tgt_ex_pct == 100) {
-				/* leave some for FW */
-				ql_dm_tgt_ex_pct = 95;
-			}
+		if (vha->tgt_ex_pct <= 0)
+			vha->tgt_ex_pct = MIN_TGT_EXCH_PCT;
 
-			tmp = ha->orig_fw_xcb_count * ql_dm_tgt_ex_pct;
-			tmp = tmp/100;
-			if (tmp > 0xffff)
-				tmp = 0xffff;
+		tmp = ha->orig_fw_xcb_count * vha->tgt_ex_pct;
+		tmp = tmp/100;
+		if (tmp > 0xffff)
+			tmp = 0xffff;
+		t = tmp & 0xffff;
 
-			t = tmp & 0xffff;
-			nv->exchange_count = cpu_to_le16(t);
-		}
+		nv->exchange_count = cpu_to_le16(t);
 
 		/* Enable target mode */
 		nv->firmware_options_1 |= cpu_to_le32(BIT_4);
@@ -7258,16 +7243,16 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	}
 }
 
-static int __init qlt_parse_ini_mode(void)
+static int __init qlt_parse_operating_mode(void)
 {
-	if (strcasecmp(qlini_mode, QLA2XXX_INI_MODE_STR_EXCLUSIVE) == 0)
-		ql2x_ini_mode = QLA2XXX_INI_MODE_EXCLUSIVE;
-	else if (strcasecmp(qlini_mode, QLA2XXX_INI_MODE_STR_DISABLED) == 0)
-		ql2x_ini_mode = QLA2XXX_INI_MODE_DISABLED;
-	else if (strcasecmp(qlini_mode, QLA2XXX_INI_MODE_STR_ENABLED) == 0)
-		ql2x_ini_mode = QLA2XXX_INI_MODE_ENABLED;
-	else if (strcasecmp(qlini_mode, QLA2XXX_INI_MODE_STR_DUAL) == 0)
-		ql2x_ini_mode = QLA2XXX_INI_MODE_DUAL;
+	if (strcasecmp(qlop_mode, QLA2XXX_OP_MODE_STR_EXCLUSIVE) == 0)
+		ql2x_op_mode = QLA2XXX_OP_MODE_EXCLUSIVE;
+	else if (strcasecmp(qlop_mode, QLA2XXX_OP_MODE_STR_TARGET) == 0)
+		ql2x_op_mode = QLA2XXX_OP_MODE_TARGET;
+	else if (strcasecmp(qlop_mode, QLA2XXX_OP_MODE_STR_INITIATOR) == 0)
+		ql2x_op_mode = QLA2XXX_OP_MODE_INITIATOR;
+	else if (strcasecmp(qlop_mode, QLA2XXX_OP_MODE_STR_DUAL) == 0)
+		ql2x_op_mode = QLA2XXX_OP_MODE_DUAL;
 	else
 		return false;
 
@@ -7278,9 +7263,9 @@ int __init qlt_init(void)
 {
 	int ret;
 
-	if (!qlt_parse_ini_mode()) {
+	if (!qlt_parse_operating_mode()) {
 		ql_log(ql_log_fatal, NULL, 0xe06b,
-		    "qlt_parse_ini_mode() failed\n");
+		    "qlt_parse_operating_mode() failed\n");
 		return -EINVAL;
 	}
 
@@ -7309,7 +7294,7 @@ int __init qlt_init(void)
 	/*
 	 * Return 1 to signal that initiator-mode is being disabled
 	 */
-	return (ql2x_ini_mode == QLA2XXX_INI_MODE_DISABLED) ? 1 : 0;
+	return (ql2x_op_mode == QLA2XXX_OP_MODE_TARGET) ? 1 : 0;
 
 out_plogi_cachep:
 	kmem_cache_destroy(qla_tgt_plogi_cachep);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 90b056e..507b8d9 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -42,15 +42,15 @@
  */
 #define QLA2XXX_INITIATOR_MAGIC   57222
 
-#define QLA2XXX_INI_MODE_STR_EXCLUSIVE	"exclusive"
-#define QLA2XXX_INI_MODE_STR_DISABLED	"disabled"
-#define QLA2XXX_INI_MODE_STR_ENABLED	"enabled"
-#define QLA2XXX_INI_MODE_STR_DUAL		"dual"
+#define QLA2XXX_OP_MODE_STR_EXCLUSIVE	"exclusive"
+#define QLA2XXX_OP_MODE_STR_TARGET		"tgt_mode"
+#define QLA2XXX_OP_MODE_STR_INITIATOR	"ini_mode"
+#define QLA2XXX_OP_MODE_STR_DUAL		"dual_mode"
 
-#define QLA2XXX_INI_MODE_EXCLUSIVE	0
-#define QLA2XXX_INI_MODE_DISABLED	1
-#define QLA2XXX_INI_MODE_ENABLED	2
-#define QLA2XXX_INI_MODE_DUAL	3
+#define QLA2XXX_OP_MODE_EXCLUSIVE	0
+#define QLA2XXX_OP_MODE_TARGET	1
+#define QLA2XXX_OP_MODE_INITIATOR	2
+#define QLA2XXX_OP_MODE_DUAL	3
 
 #define QLA2XXX_COMMAND_COUNT_INIT	250
 #define QLA2XXX_IMMED_NOTIFY_COUNT_INIT 250
@@ -1111,9 +1111,9 @@ extern int qlt_lport_register(void *, u64, u64, u64,
  * is not set. Right now, ha value is ignored.
  */
 #define QLA_TGT_MODE_ENABLED() \
-	((ql2x_ini_mode != QLA2XXX_INI_MODE_ENABLED) || \
-	 (ql2x_ini_mode == QLA2XXX_INI_MODE_DUAL))
-extern int ql2x_ini_mode;
+	(ql2x_op_mode != QLA2XXX_OP_MODE_INITIATOR)
+
+extern int ql2x_op_mode;
 
 static inline bool qla_tgt_mode_enabled(struct scsi_qla_host *ha)
 {
-- 
1.8.3.1
