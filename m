From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/18] target_core: Rename alua_access_status to alua_status_modification
Date: Tue, 19 Nov 2013 09:07:55 +0100
Message-ID: <1384848483-3771-11-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab3KSIIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Nov 2013 03:08:09 -0500
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

It is utterly confusing to have an attribute 'alua_access_state'
and another one 'alua_access_status'. So rename the latter to
'alua_status_modification' to avoid the confusion and better
reflect that actual usage.

Signed-off-by: Hannes Reiencke <hare@suse.de>
---
 drivers/target/target_core_alua.c     | 10 +++++-----
 drivers/target/target_core_configfs.c | 14 +++++++-------
 include/target/target_core_base.h     |  2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 5540aae..661ee1b 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -128,7 +128,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		/*
 		 * STATUS CODE
 		 */
-		buf[off++] = (tg_pt_gp->tg_pt_gp_alua_access_status & 0xff);
+		buf[off++] = (tg_pt_gp->tg_pt_gp_alua_status_modification & 0xff);
 		/*
 		 * Vendor Specific field
 		 */
@@ -764,9 +764,9 @@ static int core_alua_update_tpg_primary_metadata(
 	len = snprintf(md_buf, tg_pt_gp->tg_pt_gp_md_buf_len,
 			"tg_pt_gp_id=%hu\n"
 			"alua_access_state=0x%02x\n"
-			"alua_access_status=0x%02x\n",
+			"alua_status_modification=0x%02x\n",
 			tg_pt_gp->tg_pt_gp_id, primary_state,
-			tg_pt_gp->tg_pt_gp_alua_access_status);
+			tg_pt_gp->tg_pt_gp_alua_status_modification);
 
 	snprintf(path, ALUA_METADATA_PATH_LEN,
 		"/var/target/alua/tpgs_%s/%s", &wwn->unit_serial[0],
@@ -795,7 +795,7 @@ static int core_alua_do_transition_tg_pt(
 	old_state = atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
 	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
 			ALUA_ACCESS_STATE_TRANSITION);
-	tg_pt_gp->tg_pt_gp_alua_access_status = (explicit) ?
+	tg_pt_gp->tg_pt_gp_alua_status_modification = (explicit) ?
 				ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
 				ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
 	/*
@@ -1653,7 +1653,7 @@ ssize_t core_alua_show_tg_pt_gp_info(struct se_port *port, char *page)
 			core_alua_dump_state(atomic_read(
 					&tg_pt_gp->tg_pt_gp_alua_access_state)),
 			core_alua_dump_status(
-				tg_pt_gp->tg_pt_gp_alua_access_status),
+				tg_pt_gp->tg_pt_gp_alua_status_modification),
 			(atomic_read(&port->sep_tg_pt_secondary_offline)) ?
 			"Offline" : "None",
 			core_alua_dump_status(port->sep_tg_pt_secondary_stat));
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c16eb87..9ba6828 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2067,17 +2067,17 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 SE_DEV_ALUA_TG_PT_ATTR(alua_access_state, S_IRUGO | S_IWUSR);
 
 /*
- * alua_access_status
+ * alua_status_modification
  */
-static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_access_status(
+static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_status_modification(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	char *page)
 {
 	return sprintf(page, "%s\n",
-		core_alua_dump_status(tg_pt_gp->tg_pt_gp_alua_access_status));
+		core_alua_dump_status(tg_pt_gp->tg_pt_gp_alua_status_modification));
 }
 
-static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
+static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_status_modification(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	const char *page,
 	size_t count)
@@ -2108,11 +2108,11 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
 		return -EINVAL;
 	}
 
-	tg_pt_gp->tg_pt_gp_alua_access_status = new_status;
+	tg_pt_gp->tg_pt_gp_alua_status_modification = new_status;
 	return count;
 }
 
-SE_DEV_ALUA_TG_PT_ATTR(alua_access_status, S_IRUGO | S_IWUSR);
+SE_DEV_ALUA_TG_PT_ATTR(alua_status_modification, S_IRUGO | S_IWUSR);
 
 #define SE_DEV_ALUA_SUPPORT_STATE_SHOW(_name, _var, _bit)		\
 static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_##_name(	\
@@ -2432,7 +2432,7 @@ CONFIGFS_EATTR_OPS(target_core_alua_tg_pt_gp, t10_alua_tg_pt_gp,
 
 static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_core_alua_tg_pt_gp_alua_access_state.attr,
-	&target_core_alua_tg_pt_gp_alua_access_status.attr,
+	&target_core_alua_tg_pt_gp_alua_status_modification.attr,
 	&target_core_alua_tg_pt_gp_alua_management_implicit.attr,
 	&target_core_alua_tg_pt_gp_alua_management_explicit.attr,
 	&target_core_alua_tg_pt_gp_alua_support_transitioning.attr,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e3e334d..6944c75 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -284,7 +284,7 @@ struct t10_alua_tg_pt_gp {
 	u16	tg_pt_gp_id;
 	int	tg_pt_gp_valid_id;
 	int	tg_pt_gp_alua_supported_states;
-	int	tg_pt_gp_alua_access_status;
+	int	tg_pt_gp_alua_status_modification;
 	int	tg_pt_gp_alua_mgmt_type;
 	int	tg_pt_gp_nonop_delay_msecs;
 	int	tg_pt_gp_trans_delay_msecs;
-- 
1.7.12.4

