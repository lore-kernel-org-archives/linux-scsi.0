From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 4/5] tcm_qla2xxx: Perform configfs depend/undepend for base_tpg
Date: Thu, 20 Feb 2014 21:03:28 +0000
Message-ID: <1392930209-25065-5-git-send-email-nab@daterainc.com>
References: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57610 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaBTVZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 16:25:25 -0500
Received: by mail-oa0-f46.google.com with SMTP id n16so2873091oag.33
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2014 13:25:23 -0800 (PST)
In-Reply-To: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sawan Chandak <sawan.chandak@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch performs configfs_depend_item() during TPG enable for
base_tpg (eg: non-NPIV) ports, and configfs_undepend_item() during
TPG disable for base_tpg.

This is done to ensure that any attempt to configfs rmdir a base_tpg
with active NPIV ports will fail with -EBUSY, until all associated
NPIV ports have been explicitly shutdown and base_tpg disabled.

Note that the actual configfs_[un]depend_item() is done from seperate
process context, as these are not intended to be called directly
from configfs callbacks.

Cc: Sawan Chandak <sawan.chandak@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   72 +++++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    3 ++
 2 files changed, 61 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index db43b289..5bdc440 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -941,15 +941,41 @@ static ssize_t tcm_qla2xxx_tpg_show_enable(
 			atomic_read(&tpg->lport_tpg_enabled));
 }
 
+static void tcm_qla2xxx_depend_tpg(struct work_struct *work)
+{
+	struct tcm_qla2xxx_tpg *base_tpg = container_of(work,
+				struct tcm_qla2xxx_tpg, tpg_base_work);
+	struct se_portal_group *se_tpg = &base_tpg->se_tpg;
+	struct scsi_qla_host *base_vha = base_tpg->lport->qla_vha;
+
+	if (!configfs_depend_item(se_tpg->se_tpg_tfo->tf_subsys,
+				  &se_tpg->tpg_group.cg_item)) {
+		atomic_set(&base_tpg->lport_tpg_enabled, 1);
+		qlt_enable_vha(base_vha);
+	}
+	complete(&base_tpg->tpg_base_comp);
+}
+
+static void tcm_qla2xxx_undepend_tpg(struct work_struct *work)
+{
+	struct tcm_qla2xxx_tpg *base_tpg = container_of(work,
+				struct tcm_qla2xxx_tpg, tpg_base_work);
+	struct se_portal_group *se_tpg = &base_tpg->se_tpg;
+	struct scsi_qla_host *base_vha = base_tpg->lport->qla_vha;
+
+	if (!qlt_stop_phase1(base_vha->vha_tgt.qla_tgt)) {
+		atomic_set(&base_tpg->lport_tpg_enabled, 0);
+		configfs_undepend_item(se_tpg->se_tpg_tfo->tf_subsys,
+				       &se_tpg->tpg_group.cg_item);
+	}
+	complete(&base_tpg->tpg_base_comp);
+}
+
 static ssize_t tcm_qla2xxx_tpg_store_enable(
 	struct se_portal_group *se_tpg,
 	const char *page,
 	size_t count)
 {
-	struct se_wwn *se_wwn = se_tpg->se_tpg_wwn;
-	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
-			struct tcm_qla2xxx_lport, lport_wwn);
-	struct scsi_qla_host *vha = lport->qla_vha;
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 			struct tcm_qla2xxx_tpg, se_tpg);
 	unsigned long op;
@@ -964,19 +990,28 @@ static ssize_t tcm_qla2xxx_tpg_store_enable(
 		pr_err("Illegal value for tpg_enable: %lu\n", op);
 		return -EINVAL;
 	}
-
 	if (op) {
-		atomic_set(&tpg->lport_tpg_enabled, 1);
-		qlt_enable_vha(vha);
+		if (atomic_read(&tpg->lport_tpg_enabled))
+			return -EEXIST;
+
+		INIT_WORK(&tpg->tpg_base_work, tcm_qla2xxx_depend_tpg);
 	} else {
-		if (!vha->vha_tgt.qla_tgt) {
-			pr_err("struct qla_hw_data *vha->vha_tgt.qla_tgt is NULL\n");
-			return -ENODEV;
-		}
-		atomic_set(&tpg->lport_tpg_enabled, 0);
-		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
+		if (!atomic_read(&tpg->lport_tpg_enabled))
+			return count;
+
+		INIT_WORK(&tpg->tpg_base_work, tcm_qla2xxx_undepend_tpg);
 	}
+	init_completion(&tpg->tpg_base_comp);
+	schedule_work(&tpg->tpg_base_work);
+	wait_for_completion(&tpg->tpg_base_comp);
 
+	if (op) {
+		if (!atomic_read(&tpg->lport_tpg_enabled))
+			return -ENODEV;
+	} else {
+		if (atomic_read(&tpg->lport_tpg_enabled))
+			return -EPERM;
+	}
 	return count;
 }
 
@@ -1703,6 +1738,9 @@ static int tcm_qla2xxx_lport_register_npiv_cb(struct scsi_qla_host *base_vha,
 	struct scsi_qla_host *npiv_vha;
 	struct tcm_qla2xxx_lport *lport =
 			(struct tcm_qla2xxx_lport *)target_lport_ptr;
+	struct tcm_qla2xxx_lport *base_lport =
+			(struct tcm_qla2xxx_lport *)base_vha->vha_tgt.target_lport_ptr;
+	struct tcm_qla2xxx_tpg *base_tpg;
 	struct fc_vport_identifiers vport_id;
 
 	if (!qla_tgt_mode_enabled(base_vha)) {
@@ -1710,6 +1748,13 @@ static int tcm_qla2xxx_lport_register_npiv_cb(struct scsi_qla_host *base_vha,
 		return -EPERM;
 	}
 
+	if (!base_lport || !base_lport->tpg_1 ||
+	    !atomic_read(&base_lport->tpg_1->lport_tpg_enabled)) {
+		pr_err("qla2xxx base_lport or tpg_1 not available\n");
+		return -EPERM;
+	}
+	base_tpg = base_lport->tpg_1;
+
 	memset(&vport_id, 0, sizeof(vport_id));
 	vport_id.port_name = npiv_wwpn;
 	vport_id.node_name = npiv_wwnn;
@@ -1728,7 +1773,6 @@ static int tcm_qla2xxx_lport_register_npiv_cb(struct scsi_qla_host *base_vha,
 	npiv_vha = (struct scsi_qla_host *)vport->dd_data;
 	npiv_vha->vha_tgt.target_lport_ptr = target_lport_ptr;
 	lport->qla_vha = npiv_vha;
-
 	scsi_host_get(npiv_vha->host);
 	return 0;
 }
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 275d8b9..a90966d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -43,6 +43,9 @@ struct tcm_qla2xxx_tpg {
 	struct tcm_qla2xxx_tpg_attrib tpg_attrib;
 	/* Returned by tcm_qla2xxx_make_tpg() */
 	struct se_portal_group se_tpg;
+	/* Items for dealing with configfs_depend_item */
+	struct completion tpg_base_comp;
+	struct work_struct tpg_base_work;
 };
 
 struct tcm_qla2xxx_fc_loopid {
-- 
1.7.10.4

