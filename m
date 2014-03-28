From: Quinn Tran <quinn.tran@qlogic.com>
Subject: [PATCH 2/4] tcm_qla2xxx: T10-Dif set harware capability
Date: Fri, 28 Mar 2014 19:05:25 -0400
Message-ID: <1396047927-14189-3-git-send-email-quinn.tran@qlogic.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:40880 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbaC1XmF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 19:42:05 -0400
In-Reply-To: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

Set Protection Type(1,2,3) capabilities, Guarg type (CRC/IPchksm)
capabilities bits to let TCM core knows of HW/fabric capabilities.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 23 +++++++++++++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index b23a0ff..4d93081 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -910,12 +910,20 @@ DEF_QLA_TPG_ATTR_BOOL(demo_mode_login_only);
 DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
 QLA_TPG_ATTR(demo_mode_login_only, S_IRUGO | S_IWUSR);
 
+/*
+ * Define tcm_qla2xxx_tpg_attrib_s_t10dif_force_on
+ */
+DEF_QLA_TPG_ATTR_BOOL(t10dif_force_on);
+DEF_QLA_TPG_ATTRIB(t10dif_force_on);
+QLA_TPG_ATTR(t10dif_force_on, S_IRUGO | S_IWUSR);
+
 static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
 	&tcm_qla2xxx_tpg_attrib_generate_node_acls.attr,
 	&tcm_qla2xxx_tpg_attrib_cache_dynamic_acls.attr,
 	&tcm_qla2xxx_tpg_attrib_demo_mode_write_protect.attr,
 	&tcm_qla2xxx_tpg_attrib_prod_mode_write_protect.attr,
 	&tcm_qla2xxx_tpg_attrib_demo_mode_login_only.attr,
+	&tcm_qla2xxx_tpg_attrib_t10dif_force_on.attr,
 	NULL,
 };
 
@@ -1049,6 +1057,18 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
 	tpg->tpg_attrib.demo_mode_write_protect = 1;
 	tpg->tpg_attrib.cache_dynamic_acls = 1;
 	tpg->tpg_attrib.demo_mode_login_only = 1;
+	tpg->tpg_attrib.t10dif_force_on = 0;
+	tpg->se_tpg.fabric_sup_prot_type = 0;
+	tpg->se_tpg.fabric_sup_guard_type = 0;
+
+	if (scsi_host_get_prot(lport->qla_vha->host)) {
+		tpg->se_tpg.fabric_sup_prot_type = (TARGET_DIF_TYPE0_PROT|
+			TARGET_DIF_TYPE1_PROT|TARGET_DIF_TYPE2_PROT|
+			TARGET_DIF_TYPE3_PROT);
+
+		tpg->se_tpg.fabric_sup_guard_type = TARGET_GUARD_CRC|
+			TARGET_GUARD_IP;
+	}
 
 	ret = core_tpg_register(&tcm_qla2xxx_fabric_configfs->tf_ops, wwn,
 				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
@@ -1127,6 +1147,8 @@ static ssize_t tcm_qla2xxx_npiv_tpg_store_enable(
 		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
 	}
 
+	core_tpg_set_fabric_t10dif(se_tpg, tpg->tpg_attrib.t10dif_force_on);
+
 	return count;
 }
 
@@ -1169,6 +1191,7 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
 	tpg->tpg_attrib.demo_mode_write_protect = 1;
 	tpg->tpg_attrib.cache_dynamic_acls = 1;
 	tpg->tpg_attrib.demo_mode_login_only = 1;
+	tpg->tpg_attrib.t10dif_force_on = 0;
 
 	ret = core_tpg_register(&tcm_qla2xxx_npiv_fabric_configfs->tf_ops, wwn,
 				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 33aaac8..62fdce3 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -28,6 +28,7 @@ struct tcm_qla2xxx_tpg_attrib {
 	int demo_mode_write_protect;
 	int prod_mode_write_protect;
 	int demo_mode_login_only;
+	int t10dif_force_on;
 };
 
 struct tcm_qla2xxx_tpg {
-- 
1.8.4.GIT

