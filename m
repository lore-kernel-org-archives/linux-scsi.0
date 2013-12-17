From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/8] target_core_alua: Use workqueue for ALUA transitioning
Date: Tue, 17 Dec 2013 09:18:46 +0100
Message-ID: <1387268330-121064-5-git-send-email-hare@suse.de>
References: <1387268330-121064-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387268330-121064-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Use a workqueue for processing ALUA state transitions; this allows
us to process implicit delay properly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 174 +++++++++++++++++++++++++++-----------
 include/target/target_core_base.h |   4 +
 2 files changed, 128 insertions(+), 50 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 4805e97..01f0c71 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -769,8 +769,7 @@ static int core_alua_write_tpg_metadata(
  * Called with tg_pt_gp->tg_pt_gp_md_mutex held
  */
 static int core_alua_update_tpg_primary_metadata(
-	struct t10_alua_tg_pt_gp *tg_pt_gp,
-	int primary_state)
+	struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
 	unsigned char *md_buf;
 	struct t10_wwn *wwn = &tg_pt_gp->tg_pt_gp_dev->t10_wwn;
@@ -789,7 +788,8 @@ static int core_alua_update_tpg_primary_metadata(
 			"tg_pt_gp_id=%hu\n"
 			"alua_access_state=0x%02x\n"
 			"alua_access_status=0x%02x\n",
-			tg_pt_gp->tg_pt_gp_id, primary_state,
+			tg_pt_gp->tg_pt_gp_id,
+			tg_pt_gp->tg_pt_gp_alua_pending_state,
 			tg_pt_gp->tg_pt_gp_alua_access_status);
 
 	snprintf(path, ALUA_METADATA_PATH_LEN,
@@ -801,36 +801,17 @@ static int core_alua_update_tpg_primary_metadata(
 	return rc;
 }
 
-static int core_alua_do_transition_tg_pt(
-	struct t10_alua_tg_pt_gp *tg_pt_gp,
-	struct se_port *l_port,
-	struct se_node_acl *nacl,
-	int new_state,
-	int explicit)
+static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 {
+	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(work,
+		struct t10_alua_tg_pt_gp, tg_pt_gp_transition_work.work);
+	struct se_device *dev = tg_pt_gp->tg_pt_gp_dev;
 	struct se_dev_entry *se_deve;
 	struct se_lun_acl *lacl;
 	struct se_port *port;
 	struct t10_alua_tg_pt_gp_member *mem;
-
-	/*
-	 * Save the old primary ALUA access state, and set the current state
-	 * to ALUA_ACCESS_STATE_TRANSITION.
-	 */
-	tg_pt_gp->tg_pt_gp_alua_previous_state =
-		atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
-	tg_pt_gp->tg_pt_gp_alua_pending_state = new_state;
-
-	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
-			ALUA_ACCESS_STATE_TRANSITION);
-	tg_pt_gp->tg_pt_gp_alua_access_status = (explicit) ?
-				ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
-				ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
-	/*
-	 * Check for the optional ALUA primary state transition delay
-	 */
-	if (tg_pt_gp->tg_pt_gp_trans_delay_msecs != 0)
-		msleep_interruptible(tg_pt_gp->tg_pt_gp_trans_delay_msecs);
+	bool explicit = (tg_pt_gp->tg_pt_gp_alua_access_status ==
+			 ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG);
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_for_each_entry(mem, &tg_pt_gp->tg_pt_gp_mem_list,
@@ -865,9 +846,12 @@ static int core_alua_do_transition_tg_pt(
 			if (!lacl)
 				continue;
 
-			if (explicit &&
-			   (nacl != NULL) && (nacl == lacl->se_lun_nacl) &&
-			   (l_port != NULL) && (l_port == port))
+			if ((tg_pt_gp->tg_pt_gp_alua_access_status ==
+			     ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG) &&
+			   (tg_pt_gp->tg_pt_gp_alua_nacl != NULL) &&
+			    (tg_pt_gp->tg_pt_gp_alua_nacl == lacl->se_lun_nacl) &&
+			   (tg_pt_gp->tg_pt_gp_alua_port != NULL) &&
+			    (tg_pt_gp->tg_pt_gp_alua_port == port))
 				continue;
 
 			core_scsi3_ua_allocate(lacl->se_lun_nacl,
@@ -895,7 +879,7 @@ static int core_alua_do_transition_tg_pt(
 	 */
 	if (tg_pt_gp->tg_pt_gp_write_metadata) {
 		mutex_lock(&tg_pt_gp->tg_pt_gp_md_mutex);
-		core_alua_update_tpg_primary_metadata(tg_pt_gp, new_state);
+		core_alua_update_tpg_primary_metadata(tg_pt_gp);
 		mutex_unlock(&tg_pt_gp->tg_pt_gp_md_mutex);
 	}
 	/*
@@ -910,6 +894,87 @@ static int core_alua_do_transition_tg_pt(
 		tg_pt_gp->tg_pt_gp_id,
 		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_previous_state),
 		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_pending_state));
+	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
+	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
+	smp_mb__after_atomic_dec();
+	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+
+	if (tg_pt_gp->tg_pt_gp_transition_complete)
+		complete(tg_pt_gp->tg_pt_gp_transition_complete);
+}
+
+static int core_alua_do_transition_tg_pt(
+	struct t10_alua_tg_pt_gp *tg_pt_gp,
+	int new_state,
+	int explicit)
+{
+	struct se_device *dev = tg_pt_gp->tg_pt_gp_dev;
+	DECLARE_COMPLETION_ONSTACK(wait);
+
+	/* Nothing to be done here */
+	if (atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state) == new_state)
+		return 0;
+
+	if (new_state == ALUA_ACCESS_STATE_TRANSITION)
+		return -EAGAIN;
+
+	/*
+	 * Flush any pending transitions
+	 */
+	if (!explicit && tg_pt_gp->tg_pt_gp_implicit_trans_secs &&
+	    atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state) ==
+	    ALUA_ACCESS_STATE_TRANSITION) {
+		/* Just in case */
+		tg_pt_gp->tg_pt_gp_alua_pending_state = new_state;
+		tg_pt_gp->tg_pt_gp_transition_complete = &wait;
+		flush_delayed_work(&tg_pt_gp->tg_pt_gp_transition_work);
+		wait_for_completion(&wait);
+		tg_pt_gp->tg_pt_gp_transition_complete = NULL;
+		return 0;
+	}
+
+	/*
+	 * Save the old primary ALUA access state, and set the current state
+	 * to ALUA_ACCESS_STATE_TRANSITION.
+	 */
+	tg_pt_gp->tg_pt_gp_alua_previous_state =
+		atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
+	tg_pt_gp->tg_pt_gp_alua_pending_state = new_state;
+
+	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
+			ALUA_ACCESS_STATE_TRANSITION);
+	tg_pt_gp->tg_pt_gp_alua_access_status = (explicit) ?
+				ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
+				ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
+
+	/*
+	 * Check for the optional ALUA primary state transition delay
+	 */
+	if (tg_pt_gp->tg_pt_gp_trans_delay_msecs != 0)
+		msleep_interruptible(tg_pt_gp->tg_pt_gp_trans_delay_msecs);
+
+	/*
+	 * Take a reference for workqueue item
+	 */
+	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
+	atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
+	smp_mb__after_atomic_inc();
+	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+
+	if (!explicit && tg_pt_gp->tg_pt_gp_implicit_trans_secs) {
+		unsigned long transition_tmo;
+
+		transition_tmo = tg_pt_gp->tg_pt_gp_implicit_trans_secs * HZ;
+		queue_delayed_work(tg_pt_gp->tg_pt_gp_dev->tmr_wq,
+				   &tg_pt_gp->tg_pt_gp_transition_work,
+				   transition_tmo);
+	} else {
+		tg_pt_gp->tg_pt_gp_transition_complete = &wait;
+		queue_delayed_work(tg_pt_gp->tg_pt_gp_dev->tmr_wq,
+				   &tg_pt_gp->tg_pt_gp_transition_work, 0);
+		wait_for_completion(&wait);
+		tg_pt_gp->tg_pt_gp_transition_complete = NULL;
+	}
 
 	return 0;
 }
@@ -923,12 +988,10 @@ int core_alua_do_port_transition(
 	int explicit)
 {
 	struct se_device *dev;
-	struct se_port *port;
-	struct se_node_acl *nacl;
 	struct t10_alua_lu_gp *lu_gp;
 	struct t10_alua_lu_gp_member *lu_gp_mem, *local_lu_gp_mem;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
-	int primary, valid_states;
+	int primary, valid_states, rc = 0;
 
 	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
 	if (core_alua_check_transition(new_state, valid_states, &primary) != 0)
@@ -950,11 +1013,13 @@ int core_alua_do_port_transition(
 		 * core_alua_do_transition_tg_pt() will always return
 		 * success.
 		 */
-		core_alua_do_transition_tg_pt(l_tg_pt_gp, l_port, l_nacl,
-					new_state, explicit);
+		l_tg_pt_gp->tg_pt_gp_alua_port = l_port;
+		l_tg_pt_gp->tg_pt_gp_alua_nacl = l_nacl;
+		rc = core_alua_do_transition_tg_pt(l_tg_pt_gp,
+						   new_state, explicit);
 		atomic_dec(&lu_gp->lu_gp_ref_cnt);
 		smp_mb__after_atomic_dec();
-		return 0;
+		return rc;
 	}
 	/*
 	 * For all other LU groups aside from 'default_lu_gp', walk all of
@@ -989,11 +1054,11 @@ int core_alua_do_port_transition(
 				continue;
 
 			if (l_tg_pt_gp == tg_pt_gp) {
-				port = l_port;
-				nacl = l_nacl;
+				tg_pt_gp->tg_pt_gp_alua_port = l_port;
+				tg_pt_gp->tg_pt_gp_alua_nacl = l_nacl;
 			} else {
-				port = NULL;
-				nacl = NULL;
+				tg_pt_gp->tg_pt_gp_alua_port = NULL;
+				tg_pt_gp->tg_pt_gp_alua_nacl = NULL;
 			}
 			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
 			smp_mb__after_atomic_inc();
@@ -1002,12 +1067,14 @@ int core_alua_do_port_transition(
 			 * core_alua_do_transition_tg_pt() will always return
 			 * success.
 			 */
-			core_alua_do_transition_tg_pt(tg_pt_gp, port,
-					nacl, new_state, explicit);
+			rc = core_alua_do_transition_tg_pt(tg_pt_gp,
+					new_state, explicit);
 
 			spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 			atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
 			smp_mb__after_atomic_dec();
+			if (rc)
+				break;
 		}
 		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
@@ -1017,15 +1084,18 @@ int core_alua_do_port_transition(
 	}
 	spin_unlock(&lu_gp->lu_gp_lock);
 
-	pr_debug("Successfully processed LU Group: %s all ALUA TG PT"
-		" Group IDs: %hu %s transition to primary state: %s\n",
-		config_item_name(&lu_gp->lu_gp_group.cg_item),
-		l_tg_pt_gp->tg_pt_gp_id, (explicit) ? "explicit" : "implicit",
-		core_alua_dump_state(new_state));
+	if (!rc) {
+		pr_debug("Successfully processed LU Group: %s all ALUA TG PT"
+			 " Group IDs: %hu %s transition to primary state: %s\n",
+			 config_item_name(&lu_gp->lu_gp_group.cg_item),
+			 l_tg_pt_gp->tg_pt_gp_id,
+			 (explicit) ? "explicit" : "implicit",
+			 core_alua_dump_state(new_state));
+	}
 
 	atomic_dec(&lu_gp->lu_gp_ref_cnt);
 	smp_mb__after_atomic_dec();
-	return 0;
+	return rc;
 }
 
 /*
@@ -1379,6 +1449,8 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
 	mutex_init(&tg_pt_gp->tg_pt_gp_md_mutex);
 	spin_lock_init(&tg_pt_gp->tg_pt_gp_lock);
 	atomic_set(&tg_pt_gp->tg_pt_gp_ref_cnt, 0);
+	INIT_DELAYED_WORK(&tg_pt_gp->tg_pt_gp_transition_work,
+			  core_alua_do_transition_tg_pt_work);
 	tg_pt_gp->tg_pt_gp_dev = dev;
 	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
 		ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED);
@@ -1507,6 +1579,8 @@ void core_alua_free_tg_pt_gp(
 	dev->t10_alua.alua_tg_pt_gps_counter--;
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
+	flush_delayed_work(&tg_pt_gp->tg_pt_gp_transition_work);
+
 	/*
 	 * Allow a struct t10_alua_tg_pt_gp_member * referenced by
 	 * core_alua_get_tg_pt_gp_by_name() in
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6758e81..65390f6 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -302,6 +302,10 @@ struct t10_alua_tg_pt_gp {
 	struct config_group tg_pt_gp_group;
 	struct list_head tg_pt_gp_list;
 	struct list_head tg_pt_gp_mem_list;
+	struct se_port *tg_pt_gp_alua_port;
+	struct se_node_acl *tg_pt_gp_alua_nacl;
+	struct delayed_work tg_pt_gp_transition_work;
+	struct completion *tg_pt_gp_transition_complete;
 };
 
 struct t10_alua_tg_pt_gp_member {
-- 
1.7.12.4
