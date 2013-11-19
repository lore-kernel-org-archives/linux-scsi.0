From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/18] target_core: Rename alua_access_type in alua_mgmt_type
Date: Tue, 19 Nov 2013 09:07:54 +0100
Message-ID: <1384848483-3771-10-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

'alua_access_type' is not very descriptive and leads to confusion,
so rename it to 'alua_mgmt_type'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c     | 10 +++++-----
 drivers/target/target_core_alua.h     |  6 +++---
 drivers/target/target_core_configfs.c | 32 ++++++++++++++++----------------
 drivers/target/target_core_spc.c      |  2 +-
 include/target/target_core_base.h     |  2 +-
 5 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index c4d73a4..5540aae 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -246,9 +246,9 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	}
 	spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
-	if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)) {
-		pr_debug("Unable to process SET_TARGET_PORT_GROUPS"
-				" while TPGS_EXPLICIT_ALUA is disabled\n");
+	if (!(l_tg_pt_gp->tg_pt_gp_alua_mgmt_type & ALUA_MGMT_EXPLICIT)) {
+		pr_debug("Unable to process SET_TARGET_PORT_GROUPS while"
+				" explicit ALUA management is disabled\n");
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
@@ -1369,8 +1369,8 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
 	/*
 	 * Enable both explicit and implicit ALUA support by default
 	 */
-	tg_pt_gp->tg_pt_gp_alua_access_type =
-			TPGS_EXPLICIT_ALUA | TPGS_IMPLICIT_ALUA;
+	tg_pt_gp->tg_pt_gp_alua_mgmt_type =
+			ALUA_MGMT_EXPLICIT | ALUA_MGMT_IMPLICIT;
 	/*
 	 * Set the default Active/NonOptimized Delay in milliseconds
 	 */
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index 03955a9..299dc33 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -6,9 +6,9 @@
  *
  * from spc4r17 section 6.4.2 Table 135
  */
-#define TPGS_NO_ALUA				0x00
-#define TPGS_IMPLICIT_ALUA			0x10
-#define TPGS_EXPLICIT_ALUA			0x20
+#define ALUA_MGMT_NONE				0x00
+#define ALUA_MGMT_IMPLICIT			0x10
+#define ALUA_MGMT_EXPLICIT			0x20
 
 /*
  * ASYMMETRIC ACCESS STATE field
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 6f01a1e..c16eb87 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2043,9 +2043,9 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 		return -EINVAL;
 	}
 
-	if (!(tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICIT_ALUA)) {
-		pr_err("Unable to process implicit configfs ALUA"
-			" transition while TPGS_IMPLICIT_ALUA is disabled\n");
+	if (!(tg_pt_gp->tg_pt_gp_alua_mgmt_type & ALUA_MGMT_IMPLICIT)) {
+		pr_err("Unable to process implicit configfs ALUA transition"
+			" while implicit ALUA management is disabled\n");
 		return -EINVAL;
 	}
 
@@ -2153,19 +2153,19 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_##_name(	\
 }
 
 /*
- * alua_access_type
+ * alua_mgmt_type
  */
-SE_DEV_ALUA_SUPPORT_STATE_SHOW(access_implicit,
-			       tg_pt_gp_alua_access_type, TPGS_IMPLICIT_ALUA);
-SE_DEV_ALUA_SUPPORT_STATE_STORE(access_implicit,
-				tg_pt_gp_alua_access_type, TPGS_IMPLICIT_ALUA);
-SE_DEV_ALUA_TG_PT_ATTR(alua_access_implicit, S_IRUGO | S_IWUSR);
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(management_implicit,
+			       tg_pt_gp_alua_mgmt_type, ALUA_MGMT_IMPLICIT);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(management_implicit,
+				tg_pt_gp_alua_mgmt_type, ALUA_MGMT_IMPLICIT);
+SE_DEV_ALUA_TG_PT_ATTR(alua_management_implicit, S_IRUGO | S_IWUSR);
 
-SE_DEV_ALUA_SUPPORT_STATE_SHOW(access_explicit,
-			       tg_pt_gp_alua_access_type, TPGS_EXPLICIT_ALUA);
-SE_DEV_ALUA_SUPPORT_STATE_STORE(access_explicit,
-				tg_pt_gp_alua_access_type, TPGS_EXPLICIT_ALUA);
-SE_DEV_ALUA_TG_PT_ATTR(alua_access_explicit, S_IRUGO | S_IWUSR);
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(management_explicit,
+			       tg_pt_gp_alua_mgmt_type, ALUA_MGMT_EXPLICIT);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(management_explicit,
+				tg_pt_gp_alua_mgmt_type, ALUA_MGMT_EXPLICIT);
+SE_DEV_ALUA_TG_PT_ATTR(alua_management_explicit, S_IRUGO | S_IWUSR);
 
 
 /*
@@ -2433,8 +2433,8 @@ CONFIGFS_EATTR_OPS(target_core_alua_tg_pt_gp, t10_alua_tg_pt_gp,
 static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_core_alua_tg_pt_gp_alua_access_state.attr,
 	&target_core_alua_tg_pt_gp_alua_access_status.attr,
-	&target_core_alua_tg_pt_gp_alua_access_implicit.attr,
-	&target_core_alua_tg_pt_gp_alua_access_explicit.attr,
+	&target_core_alua_tg_pt_gp_alua_management_implicit.attr,
+	&target_core_alua_tg_pt_gp_alua_management_explicit.attr,
 	&target_core_alua_tg_pt_gp_alua_support_transitioning.attr,
 	&target_core_alua_tg_pt_gp_alua_support_offline.attr,
 	&target_core_alua_tg_pt_gp_alua_support_lba_dependent.attr,
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 021c3f4..49947f3 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -62,7 +62,7 @@ static void spc_fill_alua_data(struct se_port *port, unsigned char *buf)
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
 	if (tg_pt_gp)
-		buf[5] |= tg_pt_gp->tg_pt_gp_alua_access_type;
+		buf[5] |= tg_pt_gp->tg_pt_gp_alua_mgmt_type;
 	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 }
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index a23785f..e3e334d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -285,7 +285,7 @@ struct t10_alua_tg_pt_gp {
 	int	tg_pt_gp_valid_id;
 	int	tg_pt_gp_alua_supported_states;
 	int	tg_pt_gp_alua_access_status;
-	int	tg_pt_gp_alua_access_type;
+	int	tg_pt_gp_alua_mgmt_type;
 	int	tg_pt_gp_nonop_delay_msecs;
 	int	tg_pt_gp_trans_delay_msecs;
 	int	tg_pt_gp_implicit_trans_secs;
-- 
1.7.12.4
