From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 14/15] tcm_qla2xxx: Add fabric_prot_type attribute support
Date: Mon, 30 Mar 2015 03:28:23 +0000
Message-ID: <1427686104-14231-15-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates qla2xxx target to add a new fabric_prot_type TPG
attribute, used for controlling LLD level protection into LIO when
the backend device does not support T10-PI.

This is required for qla_target.c to enable WRITE_STRIP + READ_INSERT
hardware offloads.

It's disabled by default and controls which se_sesion->sess_prot_type
are set at tcm_qla2xxx_check_initiator_node_acl() session registration
time.

Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 44 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  1 +
 2 files changed, 45 insertions(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 57346ab..843b53b 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -336,6 +336,14 @@ static int tcm_qla2xxx_check_demo_mode_login_only(struct se_portal_group *se_tpg
 	return tpg->tpg_attrib.demo_mode_login_only;
 }
 
+static int tcm_qla2xxx_check_prot_fabric_only(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+
+	return tpg->tpg_attrib.fabric_prot_type;
+}
+
 static struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(
 	struct se_portal_group *se_tpg)
 {
@@ -1091,9 +1099,44 @@ static ssize_t tcm_qla2xxx_tpg_show_dynamic_sessions(
 
 TF_TPG_BASE_ATTR_RO(tcm_qla2xxx, dynamic_sessions);
 
+static ssize_t tcm_qla2xxx_tpg_store_fabric_prot_type(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	unsigned long val;
+	int ret = kstrtoul(page, 0, &val);
+
+	if (ret) {
+		pr_err("kstrtoul() returned %d for fabric_prot_type\n", ret);
+		return ret;
+	}
+	if (val != 0 && val != 1 && val != 3) {
+		pr_err("Invalid qla2xxx fabric_prot_type: %lu\n", val);
+		return -EINVAL;
+	}
+	tpg->tpg_attrib.fabric_prot_type = val;
+
+	return count;
+}
+
+static ssize_t tcm_qla2xxx_tpg_show_fabric_prot_type(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+
+	return sprintf(page, "%d\n", tpg->tpg_attrib.fabric_prot_type);
+}
+TF_TPG_BASE_ATTR(tcm_qla2xxx, fabric_prot_type, S_IRUGO | S_IWUSR);
+
 static struct configfs_attribute *tcm_qla2xxx_tpg_attrs[] = {
 	&tcm_qla2xxx_tpg_enable.attr,
 	&tcm_qla2xxx_tpg_dynamic_sessions.attr,
+	&tcm_qla2xxx_tpg_fabric_prot_type.attr,
 	NULL,
 };
 
@@ -1959,6 +2002,7 @@ static struct target_core_fabric_ops tcm_qla2xxx_ops = {
 					tcm_qla2xxx_check_demo_write_protect,
 	.tpg_check_prod_mode_write_protect =
 					tcm_qla2xxx_check_prod_write_protect,
+	.tpg_check_prot_fabric_only	= tcm_qla2xxx_check_prot_fabric_only,
 	.tpg_check_demo_mode_login_only = tcm_qla2xxx_check_demo_mode_login_only,
 	.tpg_alloc_fabric_acl		= tcm_qla2xxx_alloc_fabric_acl,
 	.tpg_release_fabric_acl		= tcm_qla2xxx_release_fabric_acl,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 10c0021..2329511 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -33,6 +33,7 @@ struct tcm_qla2xxx_tpg_attrib {
 	int demo_mode_write_protect;
 	int prod_mode_write_protect;
 	int demo_mode_login_only;
+	int fabric_prot_type;
 };
 
 struct tcm_qla2xxx_tpg {
-- 
1.9.1
