From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/18] target_core_configfs: Split up ALUA access type
Date: Tue, 19 Nov 2013 09:07:53 +0100
Message-ID: <1384848483-3771-9-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Instead of lumping two independent values into one attribute
we should be using on attribute per value.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c     | 46 --------------------
 drivers/target/target_core_alua.h     |  3 --
 drivers/target/target_core_configfs.c | 79 +++++++++++++++++------------------
 3 files changed, 38 insertions(+), 90 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 26e3c6d..c4d73a4 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1754,52 +1754,6 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	return count;
 }
 
-ssize_t core_alua_show_access_type(
-	struct t10_alua_tg_pt_gp *tg_pt_gp,
-	char *page)
-{
-	if ((tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA) &&
-	    (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICIT_ALUA))
-		return sprintf(page, "Implicit and Explicit\n");
-	else if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICIT_ALUA)
-		return sprintf(page, "Implicit\n");
-	else if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)
-		return sprintf(page, "Explicit\n");
-	else
-		return sprintf(page, "None\n");
-}
-
-ssize_t core_alua_store_access_type(
-	struct t10_alua_tg_pt_gp *tg_pt_gp,
-	const char *page,
-	size_t count)
-{
-	unsigned long tmp;
-	int ret;
-
-	ret = kstrtoul(page, 0, &tmp);
-	if (ret < 0) {
-		pr_err("Unable to extract alua_access_type\n");
-		return ret;
-	}
-	if ((tmp != 0) && (tmp != 1) && (tmp != 2) && (tmp != 3)) {
-		pr_err("Illegal value for alua_access_type:"
-				" %lu\n", tmp);
-		return -EINVAL;
-	}
-	if (tmp == 3)
-		tg_pt_gp->tg_pt_gp_alua_access_type =
-			TPGS_IMPLICIT_ALUA | TPGS_EXPLICIT_ALUA;
-	else if (tmp == 2)
-		tg_pt_gp->tg_pt_gp_alua_access_type = TPGS_EXPLICIT_ALUA;
-	else if (tmp == 1)
-		tg_pt_gp->tg_pt_gp_alua_access_type = TPGS_IMPLICIT_ALUA;
-	else
-		tg_pt_gp->tg_pt_gp_alua_access_type = 0;
-
-	return count;
-}
-
 ssize_t core_alua_show_nonop_delay_msecs(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	char *page)
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index 24ddf85..03955a9 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -115,9 +115,6 @@ extern void __core_alua_attach_tg_pt_gp_mem(struct t10_alua_tg_pt_gp_member *,
 extern ssize_t core_alua_show_tg_pt_gp_info(struct se_port *, char *);
 extern ssize_t core_alua_store_tg_pt_gp_info(struct se_port *, const char *,
 						size_t);
-extern ssize_t core_alua_show_access_type(struct t10_alua_tg_pt_gp *, char *);
-extern ssize_t core_alua_store_access_type(struct t10_alua_tg_pt_gp *,
-					const char *, size_t);
 extern ssize_t core_alua_show_nonop_delay_msecs(struct t10_alua_tg_pt_gp *,
 						char *);
 extern ssize_t core_alua_store_nonop_delay_msecs(struct t10_alua_tg_pt_gp *,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index dcceecf..6f01a1e 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2114,39 +2114,15 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
 
 SE_DEV_ALUA_TG_PT_ATTR(alua_access_status, S_IRUGO | S_IWUSR);
 
-/*
- * alua_access_type
- */
-static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_access_type(
-	struct t10_alua_tg_pt_gp *tg_pt_gp,
-	char *page)
-{
-	return core_alua_show_access_type(tg_pt_gp, page);
-}
-
-static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_type(
-	struct t10_alua_tg_pt_gp *tg_pt_gp,
-	const char *page,
-	size_t count)
-{
-	return core_alua_store_access_type(tg_pt_gp, page, count);
-}
-
-SE_DEV_ALUA_TG_PT_ATTR(alua_access_type, S_IRUGO | S_IWUSR);
-
-/*
- * alua_supported_states
- */
-
 #define SE_DEV_ALUA_SUPPORT_STATE_SHOW(_name, _var, _bit)		\
-static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_support_##_name( \
+static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_##_name(	\
 	struct t10_alua_tg_pt_gp *t, char *p)				\
 {									\
 	return sprintf(p, "%d\n", !!(t->_var & _bit));			\
 }
 
 #define SE_DEV_ALUA_SUPPORT_STATE_STORE(_name, _var, _bit)		\
-static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_support_##_name(\
+static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_##_name(	\
 	struct t10_alua_tg_pt_gp *t, const char *p, size_t c)		\
 {									\
 	unsigned long tmp;						\
@@ -2176,45 +2152,65 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_support_##_name(\
 	return c;							\
 }
 
-SE_DEV_ALUA_SUPPORT_STATE_SHOW(transitioning,
+/*
+ * alua_access_type
+ */
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(access_implicit,
+			       tg_pt_gp_alua_access_type, TPGS_IMPLICIT_ALUA);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(access_implicit,
+				tg_pt_gp_alua_access_type, TPGS_IMPLICIT_ALUA);
+SE_DEV_ALUA_TG_PT_ATTR(alua_access_implicit, S_IRUGO | S_IWUSR);
+
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(access_explicit,
+			       tg_pt_gp_alua_access_type, TPGS_EXPLICIT_ALUA);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(access_explicit,
+				tg_pt_gp_alua_access_type, TPGS_EXPLICIT_ALUA);
+SE_DEV_ALUA_TG_PT_ATTR(alua_access_explicit, S_IRUGO | S_IWUSR);
+
+
+/*
+ * alua_supported_states
+ */
+
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(support_transitioning,
 			       tg_pt_gp_alua_supported_states, ALUA_T_SUP);
-SE_DEV_ALUA_SUPPORT_STATE_STORE(transitioning,
+SE_DEV_ALUA_SUPPORT_STATE_STORE(support_transitioning,
 				tg_pt_gp_alua_supported_states, ALUA_T_SUP);
 SE_DEV_ALUA_TG_PT_ATTR(alua_support_transitioning, S_IRUGO | S_IWUSR);
 
-SE_DEV_ALUA_SUPPORT_STATE_SHOW(offline,
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(support_offline,
 			       tg_pt_gp_alua_supported_states, ALUA_O_SUP);
-SE_DEV_ALUA_SUPPORT_STATE_STORE(offline,
+SE_DEV_ALUA_SUPPORT_STATE_STORE(support_offline,
 				tg_pt_gp_alua_supported_states, ALUA_O_SUP);
 SE_DEV_ALUA_TG_PT_ATTR(alua_support_offline, S_IRUGO | S_IWUSR);
 
-SE_DEV_ALUA_SUPPORT_STATE_SHOW(lba_dependent,
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(support_lba_dependent,
 			       tg_pt_gp_alua_supported_states, ALUA_LBD_SUP);
-SE_DEV_ALUA_SUPPORT_STATE_STORE(lba_dependent,
+SE_DEV_ALUA_SUPPORT_STATE_STORE(support_lba_dependent,
 				tg_pt_gp_alua_supported_states, ALUA_LBD_SUP);
 SE_DEV_ALUA_TG_PT_ATTR(alua_support_lba_dependent, S_IRUGO | S_IWUSR);
 
-SE_DEV_ALUA_SUPPORT_STATE_SHOW(unavailable,
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(support_unavailable,
 			       tg_pt_gp_alua_supported_states, ALUA_U_SUP);
-SE_DEV_ALUA_SUPPORT_STATE_STORE(unavailable,
+SE_DEV_ALUA_SUPPORT_STATE_STORE(support_unavailable,
 				tg_pt_gp_alua_supported_states, ALUA_U_SUP);
 SE_DEV_ALUA_TG_PT_ATTR(alua_support_unavailable, S_IRUGO | S_IWUSR);
 
-SE_DEV_ALUA_SUPPORT_STATE_SHOW(standby,
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(support_standby,
 			       tg_pt_gp_alua_supported_states, ALUA_S_SUP);
-SE_DEV_ALUA_SUPPORT_STATE_STORE(standby,
+SE_DEV_ALUA_SUPPORT_STATE_STORE(support_standby,
 				tg_pt_gp_alua_supported_states, ALUA_S_SUP);
 SE_DEV_ALUA_TG_PT_ATTR(alua_support_standby, S_IRUGO | S_IWUSR);
 
-SE_DEV_ALUA_SUPPORT_STATE_SHOW(active_optimized,
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(support_active_optimized,
 			       tg_pt_gp_alua_supported_states, ALUA_AO_SUP);
-SE_DEV_ALUA_SUPPORT_STATE_STORE(active_optimized,
+SE_DEV_ALUA_SUPPORT_STATE_STORE(support_active_optimized,
 				tg_pt_gp_alua_supported_states, ALUA_AO_SUP);
 SE_DEV_ALUA_TG_PT_ATTR(alua_support_active_optimized, S_IRUGO | S_IWUSR);
 
-SE_DEV_ALUA_SUPPORT_STATE_SHOW(active_nonoptimized,
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(support_active_nonoptimized,
 			       tg_pt_gp_alua_supported_states, ALUA_AN_SUP);
-SE_DEV_ALUA_SUPPORT_STATE_STORE(active_nonoptimized,
+SE_DEV_ALUA_SUPPORT_STATE_STORE(support_active_nonoptimized,
 				tg_pt_gp_alua_supported_states, ALUA_AN_SUP);
 SE_DEV_ALUA_TG_PT_ATTR(alua_support_active_nonoptimized, S_IRUGO | S_IWUSR);
 
@@ -2437,7 +2433,8 @@ CONFIGFS_EATTR_OPS(target_core_alua_tg_pt_gp, t10_alua_tg_pt_gp,
 static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_core_alua_tg_pt_gp_alua_access_state.attr,
 	&target_core_alua_tg_pt_gp_alua_access_status.attr,
-	&target_core_alua_tg_pt_gp_alua_access_type.attr,
+	&target_core_alua_tg_pt_gp_alua_access_implicit.attr,
+	&target_core_alua_tg_pt_gp_alua_access_explicit.attr,
 	&target_core_alua_tg_pt_gp_alua_support_transitioning.attr,
 	&target_core_alua_tg_pt_gp_alua_support_offline.attr,
 	&target_core_alua_tg_pt_gp_alua_support_lba_dependent.attr,
-- 
1.7.12.4
