From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/18] target_core_configfs: split up ALUA supported states
Date: Tue, 19 Nov 2013 09:07:51 +0100
Message-ID: <1384848483-3771-7-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab3KSIIG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Nov 2013 03:08:06 -0500
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Split up the various ALUA states into individual attributes to
make parsing easier and adhere to the one value per attribute
sysfs principle.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_configfs.c | 127 ++++++++++++++++++++++------------
 1 file changed, 84 insertions(+), 43 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 1e4ea28..8476f48 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2133,51 +2133,86 @@ SE_DEV_ALUA_TG_PT_ATTR(alua_access_type, S_IRUGO | S_IWUSR);
 /*
  * alua_supported_states
  */
-static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_supported_states(
-	struct t10_alua_tg_pt_gp *tg_pt_gp,
-	char *page)
-{
-	return sprintf(page, "%02x\n",
-		tg_pt_gp->tg_pt_gp_alua_supported_states);
-}
-
-static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_supported_states(
-	struct t10_alua_tg_pt_gp *tg_pt_gp,
-	const char *page,
-	size_t count)
-{
-	unsigned long tmp;
-	int new_states, valid_states, ret;
 
-	if (!tg_pt_gp->tg_pt_gp_valid_id) {
-		pr_err("Unable to do set supported ALUA states on non"
-			" valid tg_pt_gp ID: %hu\n",
-			tg_pt_gp->tg_pt_gp_valid_id);
-		return -EINVAL;
-	}
-
-	ret = strict_strtoul(page, 0, &tmp);
-	if (ret < 0) {
-		pr_err("Unable to extract new supported ALUA states"
-				" from %s\n", page);
-		return -EINVAL;
-	}
-	new_states = (int)tmp;
-	valid_states = ALUA_T_SUP | ALUA_O_SUP | ALUA_LBD_SUP | \
-	    ALUA_U_SUP | ALUA_S_SUP | ALUA_AN_SUP | ALUA_AO_SUP;
-
-
-	if (new_states & ~valid_states) {
-		pr_err("Illegal supported ALUA states: 0x%02x\n",
-				new_states);
-		return -EINVAL;
-	}
-
-	tg_pt_gp->tg_pt_gp_alua_supported_states = new_states;
-	return count;
+#define SE_DEV_ALUA_SUPPORT_STATE_SHOW(_name, _var, _bit)		\
+static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_support_##_name( \
+	struct t10_alua_tg_pt_gp *t, char *p)				\
+{									\
+	return sprintf(p, "%d\n", !!(t->_var & _bit));			\
 }
 
-SE_DEV_ALUA_TG_PT_ATTR(alua_supported_states, S_IRUGO | S_IWUSR);
+#define SE_DEV_ALUA_SUPPORT_STATE_STORE(_name, _var, _bit)		\
+static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_support_##_name(\
+	struct t10_alua_tg_pt_gp *t, const char *p, size_t c)		\
+{									\
+	unsigned long tmp;						\
+	int ret;							\
+									\
+	if (!t->tg_pt_gp_valid_id) {					\
+		pr_err("Unable to do set ##_name ALUA state on non"	\
+		       " valid tg_pt_gp ID: %hu\n",			\
+		       t->tg_pt_gp_valid_id);				\
+		return -EINVAL;						\
+	}								\
+									\
+	ret = strict_strtoul(p, 0, &tmp);				\
+	if (ret < 0) {							\
+		pr_err("Invalid value '%s', must be '0' or '1'\n", p);	\
+		return -EINVAL;						\
+	}								\
+	if (tmp > 1) {							\
+		pr_err("Invalid value '%ld', must be '0' or '1'\n", tmp); \
+		return -EINVAL;						\
+	}								\
+	if (!tmp)							\
+		t->_var |= _bit;					\
+	else								\
+		t->_var &= ~_bit;					\
+									\
+	return c;							\
+}
+
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(transitioning,
+			       tg_pt_gp_alua_supported_states, ALUA_T_SUP);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(transitioning,
+				tg_pt_gp_alua_supported_states, ALUA_T_SUP);
+SE_DEV_ALUA_TG_PT_ATTR(alua_support_transitioning, S_IRUGO | S_IWUSR);
+
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(offline,
+			       tg_pt_gp_alua_supported_states, ALUA_O_SUP);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(offline,
+				tg_pt_gp_alua_supported_states, ALUA_O_SUP);
+SE_DEV_ALUA_TG_PT_ATTR(alua_support_offline, S_IRUGO | S_IWUSR);
+
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(lba_dependent,
+			       tg_pt_gp_alua_supported_states, ALUA_LBD_SUP);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(lba_dependent,
+				tg_pt_gp_alua_supported_states, ALUA_LBD_SUP);
+SE_DEV_ALUA_TG_PT_ATTR(alua_support_lba_dependent, S_IRUGO | S_IWUSR);
+
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(unavailable,
+			       tg_pt_gp_alua_supported_states, ALUA_U_SUP);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(unavailable,
+				tg_pt_gp_alua_supported_states, ALUA_U_SUP);
+SE_DEV_ALUA_TG_PT_ATTR(alua_support_unavailable, S_IRUGO | S_IWUSR);
+
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(standby,
+			       tg_pt_gp_alua_supported_states, ALUA_S_SUP);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(standby,
+				tg_pt_gp_alua_supported_states, ALUA_S_SUP);
+SE_DEV_ALUA_TG_PT_ATTR(alua_support_standby, S_IRUGO | S_IWUSR);
+
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(active_optimized,
+			       tg_pt_gp_alua_supported_states, ALUA_AO_SUP);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(active_optimized,
+				tg_pt_gp_alua_supported_states, ALUA_AO_SUP);
+SE_DEV_ALUA_TG_PT_ATTR(alua_support_active_optimized, S_IRUGO | S_IWUSR);
+
+SE_DEV_ALUA_SUPPORT_STATE_SHOW(active_nonoptimized,
+			       tg_pt_gp_alua_supported_states, ALUA_AN_SUP);
+SE_DEV_ALUA_SUPPORT_STATE_STORE(active_nonoptimized,
+				tg_pt_gp_alua_supported_states, ALUA_AN_SUP);
+SE_DEV_ALUA_TG_PT_ATTR(alua_support_active_nonoptimized, S_IRUGO | S_IWUSR);
 
 /*
  * alua_write_metadata
@@ -2399,7 +2434,13 @@ static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_core_alua_tg_pt_gp_alua_access_state.attr,
 	&target_core_alua_tg_pt_gp_alua_access_status.attr,
 	&target_core_alua_tg_pt_gp_alua_access_type.attr,
-	&target_core_alua_tg_pt_gp_alua_supported_states.attr,
+	&target_core_alua_tg_pt_gp_alua_support_transitioning.attr,
+	&target_core_alua_tg_pt_gp_alua_support_offline.attr,
+	&target_core_alua_tg_pt_gp_alua_support_lba_dependent.attr,
+	&target_core_alua_tg_pt_gp_alua_support_unavailable.attr,
+	&target_core_alua_tg_pt_gp_alua_support_standby.attr,
+	&target_core_alua_tg_pt_gp_alua_support_active_nonoptimized.attr,
+	&target_core_alua_tg_pt_gp_alua_support_active_optimized.attr,
 	&target_core_alua_tg_pt_gp_alua_write_metadata.attr,
 	&target_core_alua_tg_pt_gp_nonop_delay_msecs.attr,
 	&target_core_alua_tg_pt_gp_trans_delay_msecs.attr,
-- 
1.7.12.4

