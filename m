From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 3/5] tcm_qla2xxx: Add NPIV specific enable/disable attribute logic
Date: Thu, 20 Feb 2014 21:03:27 +0000
Message-ID: <1392930209-25065-4-git-send-email-nab@daterainc.com>
References: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sawan Chandak <sawan.chandak@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds seperate logic for NPIV specific enable/disable
attribute logic, as NPIV vs. non-NPIV enable/disable ends up being
different enough to warrent seperate logic for setting configfs
tpg_group dependencies in the non-NPIV case.

Cc: Sawan Chandak <sawan.chandak@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   59 ++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 75a141b..db43b289 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1053,11 +1053,64 @@ static void tcm_qla2xxx_drop_tpg(struct se_portal_group *se_tpg)
 	/*
 	 * Clear local TPG=1 pointer for non NPIV mode.
 	 */
-		lport->tpg_1 = NULL;
-
+	lport->tpg_1 = NULL;
 	kfree(tpg);
 }
 
+static ssize_t tcm_qla2xxx_npiv_tpg_show_enable(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	return tcm_qla2xxx_tpg_show_enable(se_tpg, page);
+}
+
+static ssize_t tcm_qla2xxx_npiv_tpg_store_enable(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct se_wwn *se_wwn = se_tpg->se_tpg_wwn;
+	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct scsi_qla_host *vha = lport->qla_vha;
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+			struct tcm_qla2xxx_tpg, se_tpg);
+	unsigned long op;
+	int rc;
+
+	rc = kstrtoul(page, 0, &op);
+	if (rc < 0) {
+		pr_err("kstrtoul() returned %d\n", rc);
+		return -EINVAL;
+	}
+	if ((op != 1) && (op != 0)) {
+		pr_err("Illegal value for tpg_enable: %lu\n", op);
+		return -EINVAL;
+	}
+	if (op) {
+		if (atomic_read(&tpg->lport_tpg_enabled))
+			return -EEXIST;
+
+		atomic_set(&tpg->lport_tpg_enabled, 1);
+		qlt_enable_vha(vha);
+	} else {
+		if (!atomic_read(&tpg->lport_tpg_enabled))
+			return count;
+
+		atomic_set(&tpg->lport_tpg_enabled, 0);
+		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
+	}
+
+	return count;
+}
+
+TF_TPG_BASE_ATTR(tcm_qla2xxx_npiv, enable, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *tcm_qla2xxx_npiv_tpg_attrs[] = {
+        &tcm_qla2xxx_npiv_tpg_enable.attr,
+        NULL,
+};
+
 static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
 	struct se_wwn *wwn,
 	struct config_group *group,
@@ -1935,7 +1988,7 @@ static int tcm_qla2xxx_register_configfs(void)
 	 */
 	npiv_fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = tcm_qla2xxx_wwn_attrs;
 	npiv_fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs =
-	    tcm_qla2xxx_tpg_attrs;
+	    tcm_qla2xxx_npiv_tpg_attrs;
 	npiv_fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
 	npiv_fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
 	npiv_fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
-- 
1.7.10.4
