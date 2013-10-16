From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/11] target core: rename (ex,im)plict -> (ex,im)plicit
Date: Wed, 16 Oct 2013 09:20:40 +0200
Message-ID: <1381908048-82014-2-git-send-email-hare@suse.de>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab3JPHUu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Oct 2013 03:20:50 -0400
In-Reply-To: <1381908048-82014-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c      | 110 ++++++++++++++++-----------------
 drivers/target/target_core_alua.h      |  20 +++---
 drivers/target/target_core_configfs.c  |  26 ++++----
 drivers/target/target_core_device.c    |   6 +-
 drivers/target/target_core_file.c      |   2 +-
 drivers/target/target_core_pr.c        |  24 +++----
 drivers/target/target_core_spc.c       |   6 +-
 drivers/target/target_core_transport.c |   4 +-
 drivers/target/target_core_ua.h        |   2 +-
 include/target/target_core_base.h      |   2 +-
 10 files changed, 101 insertions(+), 101 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 4724410..8297d37 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -44,7 +44,7 @@
 static sense_reason_t core_alua_check_transition(int state, int *primary);
 static int core_alua_set_tg_pt_secondary_state(
 		struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
-		struct se_port *port, int explict, int offline);
+		struct se_port *port, int explicit, int offline);
 
 static u16 alua_lu_gps_counter;
 static u32 alua_lu_gps_count;
@@ -175,7 +175,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	if (ext_hdr != 0) {
 		buf[4] = 0x10;
 		/*
-		 * Set the implict transition time (in seconds) for the application
+		 * Set the implicit transition time (in seconds) for the application
 		 * client to use as a base for it's transition timeout value.
 		 *
 		 * Use the current tg_pt_gp_mem -> tg_pt_gp membership from the LUN
@@ -188,7 +188,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 			spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 			tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
 			if (tg_pt_gp)
-				buf[5] = tg_pt_gp->tg_pt_gp_implict_trans_secs;
+				buf[5] = tg_pt_gp->tg_pt_gp_implicit_trans_secs;
 			spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 		}
 	}
@@ -199,7 +199,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 }
 
 /*
- * SET_TARGET_PORT_GROUPS for explict ALUA operation.
+ * SET_TARGET_PORT_GROUPS for explicit ALUA operation.
  *
  * See spc4r17 section 6.35
  */
@@ -232,7 +232,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	/*
-	 * Determine if explict ALUA via SET_TARGET_PORT_GROUPS is allowed
+	 * Determine if explicit ALUA via SET_TARGET_PORT_GROUPS is allowed
 	 * for the local tg_pt_gp.
 	 */
 	l_tg_pt_gp_mem = l_port->sep_alua_tg_pt_gp_mem;
@@ -251,9 +251,9 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	}
 	spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
-	if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA)) {
+	if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)) {
 		pr_debug("Unable to process SET_TARGET_PORT_GROUPS"
-				" while TPGS_EXPLICT_ALUA is disabled\n");
+				" while TPGS_EXPLICIT_ALUA is disabled\n");
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
@@ -620,7 +620,7 @@ out:
 }
 
 /*
- * Check implict and explict ALUA state change request.
+ * Check implicit and explicit ALUA state change request.
  */
 static sense_reason_t
 core_alua_check_transition(int state, int *primary)
@@ -676,10 +676,10 @@ char *core_alua_dump_status(int status)
 	switch (status) {
 	case ALUA_STATUS_NONE:
 		return "None";
-	case ALUA_STATUS_ALTERED_BY_EXPLICT_STPG:
-		return "Altered by Explict STPG";
-	case ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA:
-		return "Altered by Implict ALUA";
+	case ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG:
+		return "Altered by Explicit STPG";
+	case ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA:
+		return "Altered by Implicit ALUA";
 	default:
 		return "Unknown";
 	}
@@ -770,7 +770,7 @@ static int core_alua_do_transition_tg_pt(
 	struct se_node_acl *nacl,
 	unsigned char *md_buf,
 	int new_state,
-	int explict)
+	int explicit)
 {
 	struct se_dev_entry *se_deve;
 	struct se_lun_acl *lacl;
@@ -784,9 +784,9 @@ static int core_alua_do_transition_tg_pt(
 	old_state = atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
 	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
 			ALUA_ACCESS_STATE_TRANSITION);
-	tg_pt_gp->tg_pt_gp_alua_access_status = (explict) ?
-				ALUA_STATUS_ALTERED_BY_EXPLICT_STPG :
-				ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
+	tg_pt_gp->tg_pt_gp_alua_access_status = (explicit) ?
+				ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
+				ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
 	/*
 	 * Check for the optional ALUA primary state transition delay
 	 */
@@ -821,12 +821,12 @@ static int core_alua_do_transition_tg_pt(
 			lacl = se_deve->se_lun_acl;
 			/*
 			 * se_deve->se_lun_acl pointer may be NULL for a
-			 * entry created without explict Node+MappedLUN ACLs
+			 * entry created without explicit Node+MappedLUN ACLs
 			 */
 			if (!lacl)
 				continue;
 
-			if (explict &&
+			if (explicit &&
 			   (nacl != NULL) && (nacl == lacl->se_lun_nacl) &&
 			   (l_port != NULL) && (l_port == port))
 				continue;
@@ -866,8 +866,8 @@ static int core_alua_do_transition_tg_pt(
 	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state, new_state);
 
 	pr_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
-		" from primary access state %s to %s\n", (explict) ? "explict" :
-		"implict", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
+		" from primary access state %s to %s\n", (explicit) ? "explicit" :
+		"implicit", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
 		tg_pt_gp->tg_pt_gp_id, core_alua_dump_state(old_state),
 		core_alua_dump_state(new_state));
 
@@ -880,7 +880,7 @@ int core_alua_do_port_transition(
 	struct se_port *l_port,
 	struct se_node_acl *l_nacl,
 	int new_state,
-	int explict)
+	int explicit)
 {
 	struct se_device *dev;
 	struct se_port *port;
@@ -917,7 +917,7 @@ int core_alua_do_port_transition(
 		 * success.
 		 */
 		core_alua_do_transition_tg_pt(l_tg_pt_gp, l_port, l_nacl,
-					md_buf, new_state, explict);
+					md_buf, new_state, explicit);
 		atomic_dec(&lu_gp->lu_gp_ref_cnt);
 		smp_mb__after_atomic_dec();
 		kfree(md_buf);
@@ -970,7 +970,7 @@ int core_alua_do_port_transition(
 			 * success.
 			 */
 			core_alua_do_transition_tg_pt(tg_pt_gp, port,
-					nacl, md_buf, new_state, explict);
+					nacl, md_buf, new_state, explicit);
 
 			spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 			atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
@@ -987,7 +987,7 @@ int core_alua_do_port_transition(
 	pr_debug("Successfully processed LU Group: %s all ALUA TG PT"
 		" Group IDs: %hu %s transition to primary state: %s\n",
 		config_item_name(&lu_gp->lu_gp_group.cg_item),
-		l_tg_pt_gp->tg_pt_gp_id, (explict) ? "explict" : "implict",
+		l_tg_pt_gp->tg_pt_gp_id, (explicit) ? "explicit" : "implicit",
 		core_alua_dump_state(new_state));
 
 	atomic_dec(&lu_gp->lu_gp_ref_cnt);
@@ -1034,7 +1034,7 @@ static int core_alua_update_tpg_secondary_metadata(
 static int core_alua_set_tg_pt_secondary_state(
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
 	struct se_port *port,
-	int explict,
+	int explicit,
 	int offline)
 {
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
@@ -1061,13 +1061,13 @@ static int core_alua_set_tg_pt_secondary_state(
 		atomic_set(&port->sep_tg_pt_secondary_offline, 0);
 
 	md_buf_len = tg_pt_gp->tg_pt_gp_md_buf_len;
-	port->sep_tg_pt_secondary_stat = (explict) ?
-			ALUA_STATUS_ALTERED_BY_EXPLICT_STPG :
-			ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
+	port->sep_tg_pt_secondary_stat = (explicit) ?
+			ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
+			ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
 
 	pr_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
-		" to secondary access state: %s\n", (explict) ? "explict" :
-		"implict", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
+		" to secondary access state: %s\n", (explicit) ? "explicit" :
+		"implicit", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
 		tg_pt_gp->tg_pt_gp_id, (offline) ? "OFFLINE" : "ONLINE");
 
 	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
@@ -1356,16 +1356,16 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
 	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
 		ALUA_ACCESS_STATE_ACTIVE_OPTMIZED);
 	/*
-	 * Enable both explict and implict ALUA support by default
+	 * Enable both explicit and implicit ALUA support by default
 	 */
 	tg_pt_gp->tg_pt_gp_alua_access_type =
-			TPGS_EXPLICT_ALUA | TPGS_IMPLICT_ALUA;
+			TPGS_EXPLICIT_ALUA | TPGS_IMPLICIT_ALUA;
 	/*
 	 * Set the default Active/NonOptimized Delay in milliseconds
 	 */
 	tg_pt_gp->tg_pt_gp_nonop_delay_msecs = ALUA_DEFAULT_NONOP_DELAY_MSECS;
 	tg_pt_gp->tg_pt_gp_trans_delay_msecs = ALUA_DEFAULT_TRANS_DELAY_MSECS;
-	tg_pt_gp->tg_pt_gp_implict_trans_secs = ALUA_DEFAULT_IMPLICT_TRANS_SECS;
+	tg_pt_gp->tg_pt_gp_implicit_trans_secs = ALUA_DEFAULT_IMPLICIT_TRANS_SECS;
 
 	if (def_group) {
 		spin_lock(&dev->t10_alua.tg_pt_gps_lock);
@@ -1465,7 +1465,7 @@ void core_alua_free_tg_pt_gp(
 	 * been called from target_core_alua_drop_tg_pt_gp().
 	 *
 	 * Here we remove *tg_pt_gp from the global list so that
-	 * no assications *OR* explict ALUA via SET_TARGET_PORT_GROUPS
+	 * no assications *OR* explicit ALUA via SET_TARGET_PORT_GROUPS
 	 * can be made while we are releasing struct t10_alua_tg_pt_gp.
 	 */
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
@@ -1740,13 +1740,13 @@ ssize_t core_alua_show_access_type(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	char *page)
 {
-	if ((tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA) &&
-	    (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICT_ALUA))
-		return sprintf(page, "Implict and Explict\n");
-	else if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICT_ALUA)
-		return sprintf(page, "Implict\n");
-	else if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA)
-		return sprintf(page, "Explict\n");
+	if ((tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA) &&
+	    (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICIT_ALUA))
+		return sprintf(page, "Implicit and Explicit\n");
+	else if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICIT_ALUA)
+		return sprintf(page, "Implicit\n");
+	else if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)
+		return sprintf(page, "Explicit\n");
 	else
 		return sprintf(page, "None\n");
 }
@@ -1771,11 +1771,11 @@ ssize_t core_alua_store_access_type(
 	}
 	if (tmp == 3)
 		tg_pt_gp->tg_pt_gp_alua_access_type =
-			TPGS_IMPLICT_ALUA | TPGS_EXPLICT_ALUA;
+			TPGS_IMPLICIT_ALUA | TPGS_EXPLICIT_ALUA;
 	else if (tmp == 2)
-		tg_pt_gp->tg_pt_gp_alua_access_type = TPGS_EXPLICT_ALUA;
+		tg_pt_gp->tg_pt_gp_alua_access_type = TPGS_EXPLICIT_ALUA;
 	else if (tmp == 1)
-		tg_pt_gp->tg_pt_gp_alua_access_type = TPGS_IMPLICT_ALUA;
+		tg_pt_gp->tg_pt_gp_alua_access_type = TPGS_IMPLICIT_ALUA;
 	else
 		tg_pt_gp->tg_pt_gp_alua_access_type = 0;
 
@@ -1844,14 +1844,14 @@ ssize_t core_alua_store_trans_delay_msecs(
 	return count;
 }
 
-ssize_t core_alua_show_implict_trans_secs(
+ssize_t core_alua_show_implicit_trans_secs(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	char *page)
 {
-	return sprintf(page, "%d\n", tg_pt_gp->tg_pt_gp_implict_trans_secs);
+	return sprintf(page, "%d\n", tg_pt_gp->tg_pt_gp_implicit_trans_secs);
 }
 
-ssize_t core_alua_store_implict_trans_secs(
+ssize_t core_alua_store_implicit_trans_secs(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	const char *page,
 	size_t count)
@@ -1861,16 +1861,16 @@ ssize_t core_alua_store_implict_trans_secs(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract implict_trans_secs\n");
+		pr_err("Unable to extract implicit_trans_secs\n");
 		return ret;
 	}
-	if (tmp > ALUA_MAX_IMPLICT_TRANS_SECS) {
-		pr_err("Passed implict_trans_secs: %lu, exceeds"
-			" ALUA_MAX_IMPLICT_TRANS_SECS: %d\n", tmp,
-			ALUA_MAX_IMPLICT_TRANS_SECS);
+	if (tmp > ALUA_MAX_IMPLICIT_TRANS_SECS) {
+		pr_err("Passed implicit_trans_secs: %lu, exceeds"
+			" ALUA_MAX_IMPLICIT_TRANS_SECS: %d\n", tmp,
+			ALUA_MAX_IMPLICIT_TRANS_SECS);
 		return  -EINVAL;
 	}
-	tg_pt_gp->tg_pt_gp_implict_trans_secs = (int)tmp;
+	tg_pt_gp->tg_pt_gp_implicit_trans_secs = (int)tmp;
 
 	return count;
 }
@@ -1970,8 +1970,8 @@ ssize_t core_alua_store_secondary_status(
 		return ret;
 	}
 	if ((tmp != ALUA_STATUS_NONE) &&
-	    (tmp != ALUA_STATUS_ALTERED_BY_EXPLICT_STPG) &&
-	    (tmp != ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA)) {
+	    (tmp != ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG) &&
+	    (tmp != ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA)) {
 		pr_err("Illegal value for alua_tg_pt_status: %lu\n",
 				tmp);
 		return -EINVAL;
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index e539c3e..74cf0c0 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -7,8 +7,8 @@
  * from spc4r17 section 6.4.2 Table 135
  */
 #define TPGS_NO_ALUA				0x00
-#define TPGS_IMPLICT_ALUA			0x10
-#define TPGS_EXPLICT_ALUA			0x20
+#define TPGS_IMPLICIT_ALUA			0x10
+#define TPGS_EXPLICIT_ALUA			0x20
 
 /*
  * ASYMMETRIC ACCESS STATE field
@@ -28,8 +28,8 @@
  * from spc4r17 section 6.27 Table 246
  */
 #define ALUA_STATUS_NONE				0x00
-#define ALUA_STATUS_ALTERED_BY_EXPLICT_STPG		0x01
-#define ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA		0x02
+#define ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG		0x01
+#define ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA		0x02
 
 /*
  * From spc4r17, Table D.1: ASC and ASCQ Assignement
@@ -46,17 +46,17 @@
 #define ALUA_DEFAULT_NONOP_DELAY_MSECS			100
 #define ALUA_MAX_NONOP_DELAY_MSECS			10000 /* 10 seconds */
 /*
- * Used for implict and explict ALUA transitional delay, that is disabled
+ * Used for implicit and explicit ALUA transitional delay, that is disabled
  * by default, and is intended to be used for debugging client side ALUA code.
  */
 #define ALUA_DEFAULT_TRANS_DELAY_MSECS			0
 #define ALUA_MAX_TRANS_DELAY_MSECS			30000 /* 30 seconds */
 /*
- * Used for the recommended application client implict transition timeout
+ * Used for the recommended application client implicit transition timeout
  * in seconds, returned by the REPORT_TARGET_PORT_GROUPS w/ extended header.
  */
-#define ALUA_DEFAULT_IMPLICT_TRANS_SECS			0
-#define ALUA_MAX_IMPLICT_TRANS_SECS			255
+#define ALUA_DEFAULT_IMPLICIT_TRANS_SECS			0
+#define ALUA_MAX_IMPLICIT_TRANS_SECS			255
 /*
  * Used by core_alua_update_tpg_primary_metadata() and
  * core_alua_update_tpg_secondary_metadata()
@@ -113,9 +113,9 @@ extern ssize_t core_alua_show_trans_delay_msecs(struct t10_alua_tg_pt_gp *,
 					char *);
 extern ssize_t core_alua_store_trans_delay_msecs(struct t10_alua_tg_pt_gp *,
 					const char *, size_t);
-extern ssize_t core_alua_show_implict_trans_secs(struct t10_alua_tg_pt_gp *,
+extern ssize_t core_alua_show_implicit_trans_secs(struct t10_alua_tg_pt_gp *,
 					char *);
-extern ssize_t core_alua_store_implict_trans_secs(struct t10_alua_tg_pt_gp *,
+extern ssize_t core_alua_store_implicit_trans_secs(struct t10_alua_tg_pt_gp *,
 					const char *, size_t);
 extern ssize_t core_alua_show_preferred_bit(struct t10_alua_tg_pt_gp *,
 					char *);
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 82e81c5..d4c28a3 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2036,7 +2036,7 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 	int new_state, ret;
 
 	if (!tg_pt_gp->tg_pt_gp_valid_id) {
-		pr_err("Unable to do implict ALUA on non valid"
+		pr_err("Unable to do implicit ALUA on non valid"
 			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
 		return -EINVAL;
 	}
@@ -2049,9 +2049,9 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 	}
 	new_state = (int)tmp;
 
-	if (!(tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICT_ALUA)) {
-		pr_err("Unable to process implict configfs ALUA"
-			" transition while TPGS_IMPLICT_ALUA is disabled\n");
+	if (!(tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICIT_ALUA)) {
+		pr_err("Unable to process implicit configfs ALUA"
+			" transition while TPGS_IMPLICIT_ALUA is disabled\n");
 		return -EINVAL;
 	}
 
@@ -2097,8 +2097,8 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
 	new_status = (int)tmp;
 
 	if ((new_status != ALUA_STATUS_NONE) &&
-	    (new_status != ALUA_STATUS_ALTERED_BY_EXPLICT_STPG) &&
-	    (new_status != ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA)) {
+	    (new_status != ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG) &&
+	    (new_status != ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA)) {
 		pr_err("Illegal ALUA access status: 0x%02x\n",
 				new_status);
 		return -EINVAL;
@@ -2210,24 +2210,24 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_trans_delay_msecs(
 SE_DEV_ALUA_TG_PT_ATTR(trans_delay_msecs, S_IRUGO | S_IWUSR);
 
 /*
- * implict_trans_secs
+ * implicit_trans_secs
  */
-static ssize_t target_core_alua_tg_pt_gp_show_attr_implict_trans_secs(
+static ssize_t target_core_alua_tg_pt_gp_show_attr_implicit_trans_secs(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	char *page)
 {
-	return core_alua_show_implict_trans_secs(tg_pt_gp, page);
+	return core_alua_show_implicit_trans_secs(tg_pt_gp, page);
 }
 
-static ssize_t target_core_alua_tg_pt_gp_store_attr_implict_trans_secs(
+static ssize_t target_core_alua_tg_pt_gp_store_attr_implicit_trans_secs(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	const char *page,
 	size_t count)
 {
-	return core_alua_store_implict_trans_secs(tg_pt_gp, page, count);
+	return core_alua_store_implicit_trans_secs(tg_pt_gp, page, count);
 }
 
-SE_DEV_ALUA_TG_PT_ATTR(implict_trans_secs, S_IRUGO | S_IWUSR);
+SE_DEV_ALUA_TG_PT_ATTR(implicit_trans_secs, S_IRUGO | S_IWUSR);
 
 /*
  * preferred
@@ -2353,7 +2353,7 @@ static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_core_alua_tg_pt_gp_alua_write_metadata.attr,
 	&target_core_alua_tg_pt_gp_nonop_delay_msecs.attr,
 	&target_core_alua_tg_pt_gp_trans_delay_msecs.attr,
-	&target_core_alua_tg_pt_gp_implict_trans_secs.attr,
+	&target_core_alua_tg_pt_gp_implicit_trans_secs.attr,
 	&target_core_alua_tg_pt_gp_preferred.attr,
 	&target_core_alua_tg_pt_gp_tg_pt_gp_id.attr,
 	&target_core_alua_tg_pt_gp_members.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index d90dbb0..d17e10d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -314,14 +314,14 @@ int core_enable_device_list_for_node(
 	deve = nacl->device_list[mapped_lun];
 
 	/*
-	 * Check if the call is handling demo mode -> explict LUN ACL
+	 * Check if the call is handling demo mode -> explicit LUN ACL
 	 * transition.  This transition must be for the same struct se_lun
 	 * + mapped_lun that was setup in demo mode..
 	 */
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
 		if (deve->se_lun_acl != NULL) {
 			pr_err("struct se_dev_entry->se_lun_acl"
-			       " already set for demo mode -> explict"
+			       " already set for demo mode -> explicit"
 			       " LUN ACL transition\n");
 			spin_unlock_irq(&nacl->device_list_lock);
 			return -EINVAL;
@@ -329,7 +329,7 @@ int core_enable_device_list_for_node(
 		if (deve->se_lun != lun) {
 			pr_err("struct se_dev_entry->se_lun does"
 			       " match passed struct se_lun for demo mode"
-			       " -> explict LUN ACL transition\n");
+			       " -> explicit LUN ACL transition\n");
 			spin_unlock_irq(&nacl->device_list_lock);
 			return -EINVAL;
 		}
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index b662f89..0e34cda 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -562,7 +562,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	} else {
 		ret = fd_do_rw(cmd, sgl, sgl_nents, 1);
 		/*
-		 * Perform implict vfs_fsync_range() for fd_do_writev() ops
+		 * Perform implicit vfs_fsync_range() for fd_do_writev() ops
 		 * for SCSI WRITEs with Forced Unit Access (FUA) set.
 		 * Allow this to happen independent of WCE=0 setting.
 		 */
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index d1ae4c5..2f5d779 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -474,7 +474,7 @@ static int core_scsi3_pr_seq_non_holder(
 	 * statement.
 	 */
 	if (!ret && !other_cdb) {
-		pr_debug("Allowing explict CDB: 0x%02x for %s"
+		pr_debug("Allowing explicit CDB: 0x%02x for %s"
 			" reservation holder\n", cdb[0],
 			core_scsi3_pr_dump_type(pr_reg_type));
 
@@ -507,7 +507,7 @@ static int core_scsi3_pr_seq_non_holder(
 			 */
 
 			if (!registered_nexus) {
-				pr_debug("Allowing implict CDB: 0x%02x"
+				pr_debug("Allowing implicit CDB: 0x%02x"
 					" for %s reservation on unregistered"
 					" nexus\n", cdb[0],
 					core_scsi3_pr_dump_type(pr_reg_type));
@@ -522,7 +522,7 @@ static int core_scsi3_pr_seq_non_holder(
 			 * allow commands from registered nexuses.
 			 */
 
-			pr_debug("Allowing implict CDB: 0x%02x for %s"
+			pr_debug("Allowing implicit CDB: 0x%02x for %s"
 				" reservation\n", cdb[0],
 				core_scsi3_pr_dump_type(pr_reg_type));
 
@@ -683,7 +683,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 					alua_port_list) {
 			/*
 			 * This pointer will be NULL for demo mode MappedLUNs
-			 * that have not been make explict via a ConfigFS
+			 * that have not been make explicit via a ConfigFS
 			 * MappedLUN group for the SCSI Initiator Node ACL.
 			 */
 			if (!deve_tmp->se_lun_acl)
@@ -1158,7 +1158,7 @@ static void core_scsi3_put_pr_reg(struct t10_pr_registration *pr_reg)
 	smp_mb__after_atomic_dec();
 }
 
-static int core_scsi3_check_implict_release(
+static int core_scsi3_check_implicit_release(
 	struct se_device *dev,
 	struct t10_pr_registration *pr_reg)
 {
@@ -1174,7 +1174,7 @@ static int core_scsi3_check_implict_release(
 	}
 	if (pr_res_holder == pr_reg) {
 		/*
-		 * Perform an implict RELEASE if the registration that
+		 * Perform an implicit RELEASE if the registration that
 		 * is being released is holding the reservation.
 		 *
 		 * From spc4r17, section 5.7.11.1:
@@ -1192,7 +1192,7 @@ static int core_scsi3_check_implict_release(
 		 * For 'All Registrants' reservation types, all existing
 		 * registrations are still processed as reservation holders
 		 * in core_scsi3_pr_seq_non_holder() after the initial
-		 * reservation holder is implictly released here.
+		 * reservation holder is implicitly released here.
 		 */
 	} else if (pr_reg->pr_reg_all_tg_pt &&
 		  (!strcmp(pr_res_holder->pr_reg_nacl->initiatorname,
@@ -2125,7 +2125,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		/*
 		 * sa_res_key=0 Unregister Reservation Key for registered I_T Nexus.
 		 */
-		pr_holder = core_scsi3_check_implict_release(
+		pr_holder = core_scsi3_check_implicit_release(
 				cmd->se_dev, pr_reg);
 		if (pr_holder < 0) {
 			ret = TCM_RESERVATION_CONFLICT;
@@ -2402,7 +2402,7 @@ static void __core_scsi3_complete_pro_release(
 	struct se_device *dev,
 	struct se_node_acl *se_nacl,
 	struct t10_pr_registration *pr_reg,
-	int explict)
+	int explicit)
 {
 	struct target_core_fabric_ops *tfo = se_nacl->se_tpg->se_tpg_tfo;
 	char i_buf[PR_REG_ISID_ID_LEN];
@@ -2416,7 +2416,7 @@ static void __core_scsi3_complete_pro_release(
 
 	pr_debug("SPC-3 PR [%s] Service Action: %s RELEASE cleared"
 		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		tfo->get_fabric_name(), (explict) ? "explict" : "implict",
+		tfo->get_fabric_name(), (explicit) ? "explicit" : "implicit",
 		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
 	pr_debug("SPC-3 PR [%s] RELEASE Node: %s%s\n",
@@ -2692,7 +2692,7 @@ static void __core_scsi3_complete_pro_preempt(
 	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 	/*
-	 * Do an implict RELEASE of the existing reservation.
+	 * Do an implicit RELEASE of the existing reservation.
 	 */
 	if (dev->dev_pr_res_holder)
 		__core_scsi3_complete_pro_release(dev, nacl,
@@ -2845,7 +2845,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 				 * 5.7.11.4 Preempting, Table 52 and Figure 7.
 				 *
 				 * For a ZERO SA Reservation key, release
-				 * all other registrations and do an implict
+				 * all other registrations and do an implicit
 				 * release of active persistent reservation.
 				 *
 				 * For a non-ZERO SA Reservation key, only
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 0745395..5ff69a5 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -48,7 +48,7 @@ static void spc_fill_alua_data(struct se_port *port, unsigned char *buf)
 	buf[5]	= 0x80;
 
 	/*
-	 * Set TPGS field for explict and/or implict ALUA access type
+	 * Set TPGS field for explicit and/or implicit ALUA access type
 	 * and opteration.
 	 *
 	 * See spc4r17 section 6.4.2 Table 135
@@ -1250,7 +1250,7 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		*size = (cdb[3] << 8) + cdb[4];
 
 		/*
-		 * Do implict HEAD_OF_QUEUE processing for INQUIRY.
+		 * Do implicit HEAD_OF_QUEUE processing for INQUIRY.
 		 * See spc4r17 section 5.3
 		 */
 		cmd->sam_task_attr = MSG_HEAD_TAG;
@@ -1284,7 +1284,7 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		cmd->execute_cmd = spc_emulate_report_luns;
 		*size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
 		/*
-		 * Do implict HEAD_OF_QUEUE processing for REPORT_LUNS
+		 * Do implicit HEAD_OF_QUEUE processing for REPORT_LUNS
 		 * See spc4r17 section 5.3
 		 */
 		cmd->sam_task_attr = MSG_HEAD_TAG;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 81e945e..98bb7c4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -473,7 +473,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
 		se_tpg->se_tpg_tfo->get_fabric_name());
 	/*
-	 * If last kref is dropping now for an explict NodeACL, awake sleeping
+	 * If last kref is dropping now for an explicit NodeACL, awake sleeping
 	 * ->acl_free_comp caller to wakeup configfs se_node_acl->acl_group
 	 * removal context.
 	 */
@@ -668,7 +668,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 		cmd->transport_state |= CMD_T_FAILED;
 
 	/*
-	 * Check for case where an explict ABORT_TASK has been received
+	 * Check for case where an explicit ABORT_TASK has been received
 	 * and transport_wait_for_tasks() will be waiting for completion..
 	 */
 	if (cmd->transport_state & CMD_T_ABORTED &&
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index 0204952..be912b3 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -19,7 +19,7 @@
 #define ASCQ_2AH_RESERVATIONS_RELEASED				0x04
 #define ASCQ_2AH_REGISTRATIONS_PREEMPTED			0x05
 #define ASCQ_2AH_ASYMMETRIC_ACCESS_STATE_CHANGED		0x06
-#define ASCQ_2AH_IMPLICT_ASYMMETRIC_ACCESS_STATE_TRANSITION_FAILED 0x07
+#define ASCQ_2AH_IMPLICIT_ASYMMETRIC_ACCESS_STATE_TRANSITION_FAILED 0x07
 #define ASCQ_2AH_PRIORITY_CHANGED				0x08
 
 #define ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS		0x09
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5bdb8b7..1c6e54d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -286,7 +286,7 @@ struct t10_alua_tg_pt_gp {
 	int	tg_pt_gp_alua_access_type;
 	int	tg_pt_gp_nonop_delay_msecs;
 	int	tg_pt_gp_trans_delay_msecs;
-	int	tg_pt_gp_implict_trans_secs;
+	int	tg_pt_gp_implicit_trans_secs;
 	int	tg_pt_gp_pref;
 	int	tg_pt_gp_write_metadata;
 	/* Used by struct t10_alua_tg_pt_gp->tg_pt_gp_md_buf_len */
-- 
1.7.12.4

