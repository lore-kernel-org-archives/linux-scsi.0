From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 15/15] iscsi/iser-target: Add fabric_prot_type attribute support
Date: Mon, 30 Mar 2015 03:28:24 +0000
Message-ID: <1427686104-14231-16-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates iscsi/iser-target to add a new fabric_prot_type
TPG attribute for iser-target, used for controlling LLD level
protection into LIO when the backend device does not support T10-PI.

This is required for ib_isert to enable WRITE_STRIP + READ_INSERT
hardware offloads.

It's disabled by default and controls which se_sesion->sess_prot_type
are set at iscsi_target_locate_portal() session registration time.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Martin Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 22 ++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_tpg.c      | 19 +++++++++++++++++++
 drivers/target/iscsi/iscsi_target_tpg.h      |  1 +
 include/target/iscsi/iscsi_target_core.h     |  2 ++
 4 files changed, 44 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 95a67f6..9cb5ab4 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1052,6 +1052,11 @@ TPG_ATTR(default_erl, S_IRUGO | S_IWUSR);
  */
 DEF_TPG_ATTRIB(t10_pi);
 TPG_ATTR(t10_pi, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_tpg_attrib_s_fabric_prot_type
+ */
+DEF_TPG_ATTRIB(fabric_prot_type);
+TPG_ATTR(fabric_prot_type, S_IRUGO | S_IWUSR);
 
 static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_authentication.attr,
@@ -1065,6 +1070,7 @@ static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_demo_mode_discovery.attr,
 	&iscsi_tpg_attrib_default_erl.attr,
 	&iscsi_tpg_attrib_t10_pi.attr,
+	&iscsi_tpg_attrib_fabric_prot_type.attr,
 	NULL,
 };
 
@@ -1882,6 +1888,20 @@ static int lio_tpg_check_prod_mode_write_protect(
 	return tpg->tpg_attrib.prod_mode_write_protect;
 }
 
+static int lio_tpg_check_prot_fabric_only(
+	struct se_portal_group *se_tpg)
+{
+	struct iscsi_portal_group *tpg = se_tpg->se_tpg_fabric_ptr;
+	/*
+	 * Only report fabric_prot_type if t10_pi has also been enabled
+	 * for incoming ib_isert sessions.
+	 */
+	if (!tpg->tpg_attrib.t10_pi)
+		return 0;
+
+	return tpg->tpg_attrib.fabric_prot_type;
+}
+
 static void lio_tpg_release_fabric_acl(
 	struct se_portal_group *se_tpg,
 	struct se_node_acl *se_acl)
@@ -1997,6 +2017,8 @@ int iscsi_target_register_configfs(void)
 				&lio_tpg_check_demo_mode_write_protect;
 	fabric->tf_ops.tpg_check_prod_mode_write_protect =
 				&lio_tpg_check_prod_mode_write_protect;
+	fabric->tf_ops.tpg_check_prot_fabric_only =
+				&lio_tpg_check_prot_fabric_only;
 	fabric->tf_ops.tpg_alloc_fabric_acl = &lio_tpg_alloc_fabric_acl;
 	fabric->tf_ops.tpg_release_fabric_acl = &lio_tpg_release_fabric_acl;
 	fabric->tf_ops.tpg_get_inst_index = &lio_tpg_get_inst_index;
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index bdd127c..3076e6f 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -228,6 +228,7 @@ static void iscsit_set_default_tpg_attribs(struct iscsi_portal_group *tpg)
 	a->demo_mode_discovery = TA_DEMO_MODE_DISCOVERY;
 	a->default_erl = TA_DEFAULT_ERL;
 	a->t10_pi = TA_DEFAULT_T10_PI;
+	a->fabric_prot_type = TA_DEFAULT_FABRIC_PROT_TYPE;
 }
 
 int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_portal_group *tpg)
@@ -878,3 +879,21 @@ int iscsit_ta_t10_pi(
 
 	return 0;
 }
+
+int iscsit_ta_fabric_prot_type(
+	struct iscsi_portal_group *tpg,
+	u32 prot_type)
+{
+	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
+
+	if ((prot_type != 0) && (prot_type != 1) && (prot_type != 3)) {
+		pr_err("Illegal value for fabric_prot_type: %u\n", prot_type);
+		return -EINVAL;
+	}
+
+	a->fabric_prot_type = prot_type;
+	pr_debug("iSCSI_TPG[%hu] - T10 Fabric Protection Type: %u\n",
+		 tpg->tpgt, prot_type);
+
+	return 0;
+}
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index e726533..95ff5bd 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -39,5 +39,6 @@ extern int iscsit_ta_prod_mode_write_protect(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_demo_mode_discovery(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_default_erl(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_t10_pi(struct iscsi_portal_group *, u32);
+extern int iscsit_ta_fabric_prot_type(struct iscsi_portal_group *, u32);
 
 #endif /* ISCSI_TARGET_TPG_H */
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 0e394a0..54e7af3 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -62,6 +62,7 @@
 #define TA_CACHE_CORE_NPS		0
 /* T10 protection information disabled by default */
 #define TA_DEFAULT_T10_PI		0
+#define TA_DEFAULT_FABRIC_PROT_TYPE	0
 
 #define ISCSI_IOV_DATA_BUFFER		5
 
@@ -772,6 +773,7 @@ struct iscsi_tpg_attrib {
 	u32			demo_mode_discovery;
 	u32			default_erl;
 	u8			t10_pi;
+	u32			fabric_prot_type;
 	struct iscsi_portal_group *tpg;
 };
 
-- 
1.9.1
