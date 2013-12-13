From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 05/32] target: Rename some list heads used as nodes
Date: Fri, 13 Dec 2013 15:58:53 -0800
Message-ID: <1386979160-6928-6-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Since everything's a list_head, naming it _node makes it clearer it's
to put the struct on a list, not a list head itself.

Rename ua_nacl_list to ua_nacl_node
Rename alua_port_list to alua_port_node
Rename lu_gp_mem_list to lu_gp_mem_node
Rename tg_pt_gp_mem_list to tg_pt_gp_mem_node
Rename sep_list to sep_node
Rename tg_pt_gp_list to tg_pt_gp_node
Rename se_session sess_list to sess_node
Rename se_node_acl acl_list to acl_node

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c       |    2 +-
 drivers/target/iscsi/iscsi_target_login.c |    4 +-
 drivers/target/sbp/sbp_target.c           |    6 ++--
 drivers/target/target_core_alua.c         |   52 ++++++++++++++--------------
 drivers/target/target_core_configfs.c     |    4 +-
 drivers/target/target_core_device.c       |   18 +++++-----
 drivers/target/target_core_pr.c           |    8 ++--
 drivers/target/target_core_tpg.c          |   20 +++++-----
 drivers/target/target_core_transport.c    |    8 ++--
 drivers/target/target_core_ua.c           |   28 ++++++++--------
 drivers/target/target_core_xcopy.c        |    6 ++--
 drivers/target/tcm_fc/tfc_conf.c          |    2 +-
 include/target/target_core_base.h         |   16 ++++----
 13 files changed, 87 insertions(+), 87 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d70e911..2844aff 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4703,7 +4703,7 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 	}
 
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
-			sess_list) {
+			sess_node) {
 		sess = (struct iscsi_session *)se_sess->fabric_sess_ptr;
 
 		spin_lock(&sess->conn_lock);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 4eb93b2..99cd298 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -180,7 +180,7 @@ int iscsi_check_for_session_reinstatement(struct iscsi_conn *conn)
 
 	spin_lock_bh(&se_tpg->session_lock);
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
-			sess_list) {
+			sess_node) {
 
 		sess_p = se_sess->fabric_sess_ptr;
 		spin_lock(&sess_p->conn_lock);
@@ -534,7 +534,7 @@ static int iscsi_login_non_zero_tsih_s2(
 
 	spin_lock_bh(&se_tpg->session_lock);
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
-			sess_list) {
+			sess_node) {
 
 		sess_p = (struct iscsi_session *)se_sess->fabric_sess_ptr;
 		if (atomic_read(&sess_p->session_fall_back_to_erl0) ||
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 24884ca..e1ceae5 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -99,7 +99,7 @@ static struct sbp_session *sbp_session_find_by_guid(
 	struct sbp_session *sess, *found = NULL;
 
 	spin_lock_bh(&tpg->se_tpg.session_lock);
-	list_for_each_entry(se_sess, &tpg->se_tpg.tpg_sess_list, sess_list) {
+	list_for_each_entry(se_sess, &tpg->se_tpg.tpg_sess_list, sess_node) {
 		sess = se_sess->fabric_sess_ptr;
 		if (sess->guid == guid)
 			found = sess;
@@ -135,7 +135,7 @@ static int sbp_login_count_all_by_lun(
 	int count = 0;
 
 	spin_lock_bh(&tpg->se_tpg.session_lock);
-	list_for_each_entry(se_sess, &tpg->se_tpg.tpg_sess_list, sess_list) {
+	list_for_each_entry(se_sess, &tpg->se_tpg.tpg_sess_list, sess_node) {
 		sess = se_sess->fabric_sess_ptr;
 
 		spin_lock_bh(&sess->lock);
@@ -161,7 +161,7 @@ static struct sbp_login_descriptor *sbp_login_find_by_id(
 	struct sbp_login_descriptor *login, *found = NULL;
 
 	spin_lock_bh(&tpg->se_tpg.session_lock);
-	list_for_each_entry(se_sess, &tpg->se_tpg.tpg_sess_list, sess_list) {
+	list_for_each_entry(se_sess, &tpg->se_tpg.tpg_sess_list, sess_node) {
 		sess = se_sess->fabric_sess_ptr;
 
 		spin_lock_bh(&sess->lock);
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index fdcee32..2ac2f11 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -91,7 +91,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
-			tg_pt_gp_list) {
+			tg_pt_gp_node) {
 		/*
 		 * Check if the Target port group and Target port descriptor list
 		 * based on tg_pt_gp_members count will fit into the response payload.
@@ -141,7 +141,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 		list_for_each_entry(tg_pt_gp_mem, &tg_pt_gp->tg_pt_gp_mem_list,
-				tg_pt_gp_mem_list) {
+				tg_pt_gp_mem_node) {
 			port = tg_pt_gp_mem->tg_pt;
 			/*
 			 * Start Target Port descriptor format
@@ -300,7 +300,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 			spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 			list_for_each_entry(tg_pt_gp,
 					&dev->t10_alua.tg_pt_gps_list,
-					tg_pt_gp_list) {
+					tg_pt_gp_node) {
 				if (!tg_pt_gp->tg_pt_gp_valid_id)
 					continue;
 
@@ -336,7 +336,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 */
 			spin_lock(&dev->se_port_lock);
 			list_for_each_entry(port, &dev->dev_sep_list,
-							sep_list) {
+							sep_node) {
 				if (port->sep_rtpi != rtpi)
 					continue;
 
@@ -790,7 +790,7 @@ static int core_alua_do_transition_tg_pt(
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_for_each_entry(mem, &tg_pt_gp->tg_pt_gp_mem_list,
-				tg_pt_gp_mem_list) {
+				tg_pt_gp_mem_node) {
 		port = mem->tg_pt;
 		/*
 		 * After an implicit target port asymmetric access state
@@ -812,7 +812,7 @@ static int core_alua_do_transition_tg_pt(
 
 		spin_lock_bh(&port->sep_alua_lock);
 		list_for_each_entry(se_deve, &port->sep_alua_list,
-					alua_port_list) {
+					alua_port_node) {
 			lacl = se_deve->se_lun_acl;
 			/*
 			 * se_deve->se_lun_acl pointer may be NULL for a
@@ -925,7 +925,7 @@ int core_alua_do_port_transition(
 	 */
 	spin_lock(&lu_gp->lu_gp_lock);
 	list_for_each_entry(lu_gp_mem, &lu_gp->lu_gp_mem_list,
-				lu_gp_mem_list) {
+				lu_gp_mem_node) {
 
 		dev = lu_gp_mem->lu_gp_mem_dev;
 		atomic_inc(&lu_gp_mem->lu_gp_mem_ref_cnt);
@@ -935,7 +935,7 @@ int core_alua_do_port_transition(
 		spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 		list_for_each_entry(tg_pt_gp,
 				&dev->t10_alua.tg_pt_gps_list,
-				tg_pt_gp_list) {
+				tg_pt_gp_node) {
 
 			if (!tg_pt_gp->tg_pt_gp_valid_id)
 				continue;
@@ -1175,7 +1175,7 @@ core_alua_allocate_lu_gp_mem(struct se_device *dev)
 		pr_err("Unable to allocate struct t10_alua_lu_gp_member\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	INIT_LIST_HEAD(&lu_gp_mem->lu_gp_mem_list);
+	INIT_LIST_HEAD(&lu_gp_mem->lu_gp_mem_node);
 	spin_lock_init(&lu_gp_mem->lu_gp_mem_lock);
 	atomic_set(&lu_gp_mem->lu_gp_mem_ref_cnt, 0);
 
@@ -1213,9 +1213,9 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
 	 */
 	spin_lock(&lu_gp->lu_gp_lock);
 	list_for_each_entry_safe(lu_gp_mem, lu_gp_mem_tmp,
-				&lu_gp->lu_gp_mem_list, lu_gp_mem_list) {
+				&lu_gp->lu_gp_mem_list, lu_gp_mem_node) {
 		if (lu_gp_mem->lu_gp_assoc) {
-			list_del(&lu_gp_mem->lu_gp_mem_list);
+			list_del(&lu_gp_mem->lu_gp_mem_node);
 			lu_gp->lu_gp_members--;
 			lu_gp_mem->lu_gp_assoc = 0;
 		}
@@ -1261,7 +1261,7 @@ void core_alua_free_lu_gp_mem(struct se_device *dev)
 	if (lu_gp) {
 		spin_lock(&lu_gp->lu_gp_lock);
 		if (lu_gp_mem->lu_gp_assoc) {
-			list_del(&lu_gp_mem->lu_gp_mem_list);
+			list_del(&lu_gp_mem->lu_gp_mem_node);
 			lu_gp->lu_gp_members--;
 			lu_gp_mem->lu_gp_assoc = 0;
 		}
@@ -1311,7 +1311,7 @@ void __core_alua_attach_lu_gp_mem(
 	spin_lock(&lu_gp->lu_gp_lock);
 	lu_gp_mem->lu_gp = lu_gp;
 	lu_gp_mem->lu_gp_assoc = 1;
-	list_add_tail(&lu_gp_mem->lu_gp_mem_list, &lu_gp->lu_gp_mem_list);
+	list_add_tail(&lu_gp_mem->lu_gp_mem_node, &lu_gp->lu_gp_mem_list);
 	lu_gp->lu_gp_members++;
 	spin_unlock(&lu_gp->lu_gp_lock);
 }
@@ -1324,7 +1324,7 @@ void __core_alua_drop_lu_gp_mem(
 	struct t10_alua_lu_gp *lu_gp)
 {
 	spin_lock(&lu_gp->lu_gp_lock);
-	list_del(&lu_gp_mem->lu_gp_mem_list);
+	list_del(&lu_gp_mem->lu_gp_mem_node);
 	lu_gp_mem->lu_gp = NULL;
 	lu_gp_mem->lu_gp_assoc = 0;
 	lu_gp->lu_gp_members--;
@@ -1341,7 +1341,7 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
 		pr_err("Unable to allocate struct t10_alua_tg_pt_gp\n");
 		return NULL;
 	}
-	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_list);
+	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_node);
 	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_mem_list);
 	mutex_init(&tg_pt_gp->tg_pt_gp_md_mutex);
 	spin_lock_init(&tg_pt_gp->tg_pt_gp_lock);
@@ -1375,7 +1375,7 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
 				dev->t10_alua.alua_tg_pt_gps_counter++;
 		tg_pt_gp->tg_pt_gp_valid_id = 1;
 		dev->t10_alua.alua_tg_pt_gps_count++;
-		list_add_tail(&tg_pt_gp->tg_pt_gp_list,
+		list_add_tail(&tg_pt_gp->tg_pt_gp_node,
 			      &dev->t10_alua.tg_pt_gps_list);
 		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 	}
@@ -1413,7 +1413,7 @@ again:
 			dev->t10_alua.alua_tg_pt_gps_counter++;
 
 	list_for_each_entry(tg_pt_gp_tmp, &dev->t10_alua.tg_pt_gps_list,
-			tg_pt_gp_list) {
+			tg_pt_gp_node) {
 		if (tg_pt_gp_tmp->tg_pt_gp_id == tg_pt_gp_id_tmp) {
 			if (!tg_pt_gp_id)
 				goto again;
@@ -1427,7 +1427,7 @@ again:
 
 	tg_pt_gp->tg_pt_gp_id = tg_pt_gp_id_tmp;
 	tg_pt_gp->tg_pt_gp_valid_id = 1;
-	list_add_tail(&tg_pt_gp->tg_pt_gp_list,
+	list_add_tail(&tg_pt_gp->tg_pt_gp_node,
 			&dev->t10_alua.tg_pt_gps_list);
 	dev->t10_alua.alua_tg_pt_gps_count++;
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
@@ -1446,7 +1446,7 @@ struct t10_alua_tg_pt_gp_member *core_alua_allocate_tg_pt_gp_mem(
 		pr_err("Unable to allocate struct t10_alua_tg_pt_gp_member\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	INIT_LIST_HEAD(&tg_pt_gp_mem->tg_pt_gp_mem_list);
+	INIT_LIST_HEAD(&tg_pt_gp_mem->tg_pt_gp_mem_node);
 	spin_lock_init(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	atomic_set(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt, 0);
 
@@ -1471,7 +1471,7 @@ void core_alua_free_tg_pt_gp(
 	 * can be made while we are releasing struct t10_alua_tg_pt_gp.
 	 */
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
-	list_del(&tg_pt_gp->tg_pt_gp_list);
+	list_del(&tg_pt_gp->tg_pt_gp_node);
 	dev->t10_alua.alua_tg_pt_gps_counter--;
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
@@ -1490,9 +1490,9 @@ void core_alua_free_tg_pt_gp(
 	 */
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_for_each_entry_safe(tg_pt_gp_mem, tg_pt_gp_mem_tmp,
-			&tg_pt_gp->tg_pt_gp_mem_list, tg_pt_gp_mem_list) {
+			&tg_pt_gp->tg_pt_gp_mem_list, tg_pt_gp_mem_node) {
 		if (tg_pt_gp_mem->tg_pt_gp_assoc) {
-			list_del(&tg_pt_gp_mem->tg_pt_gp_mem_list);
+			list_del(&tg_pt_gp_mem->tg_pt_gp_mem_node);
 			tg_pt_gp->tg_pt_gp_members--;
 			tg_pt_gp_mem->tg_pt_gp_assoc = 0;
 		}
@@ -1538,7 +1538,7 @@ void core_alua_free_tg_pt_gp_mem(struct se_port *port)
 	if (tg_pt_gp) {
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 		if (tg_pt_gp_mem->tg_pt_gp_assoc) {
-			list_del(&tg_pt_gp_mem->tg_pt_gp_mem_list);
+			list_del(&tg_pt_gp_mem->tg_pt_gp_mem_node);
 			tg_pt_gp->tg_pt_gp_members--;
 			tg_pt_gp_mem->tg_pt_gp_assoc = 0;
 		}
@@ -1558,7 +1558,7 @@ static struct t10_alua_tg_pt_gp *core_alua_get_tg_pt_gp_by_name(
 
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
-			tg_pt_gp_list) {
+			tg_pt_gp_node) {
 		if (!tg_pt_gp->tg_pt_gp_valid_id)
 			continue;
 		ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
@@ -1593,7 +1593,7 @@ void __core_alua_attach_tg_pt_gp_mem(
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	tg_pt_gp_mem->tg_pt_gp = tg_pt_gp;
 	tg_pt_gp_mem->tg_pt_gp_assoc = 1;
-	list_add_tail(&tg_pt_gp_mem->tg_pt_gp_mem_list,
+	list_add_tail(&tg_pt_gp_mem->tg_pt_gp_mem_node,
 			&tg_pt_gp->tg_pt_gp_mem_list);
 	tg_pt_gp->tg_pt_gp_members++;
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
@@ -1607,7 +1607,7 @@ static void __core_alua_drop_tg_pt_gp_mem(
 	struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-	list_del(&tg_pt_gp_mem->tg_pt_gp_mem_list);
+	list_del(&tg_pt_gp_mem->tg_pt_gp_mem_node);
 	tg_pt_gp_mem->tg_pt_gp = NULL;
 	tg_pt_gp_mem->tg_pt_gp_assoc = 0;
 	tg_pt_gp->tg_pt_gp_members--;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a1c23d1..bdf4299 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1887,7 +1887,7 @@ static ssize_t target_core_alua_lu_gp_show_attr_members(
 	memset(buf, 0, LU_GROUP_NAME_BUF);
 
 	spin_lock(&lu_gp->lu_gp_lock);
-	list_for_each_entry(lu_gp_mem, &lu_gp->lu_gp_mem_list, lu_gp_mem_list) {
+	list_for_each_entry(lu_gp_mem, &lu_gp->lu_gp_mem_list, lu_gp_mem_node) {
 		dev = lu_gp_mem->lu_gp_mem_dev;
 		hba = dev->se_hba;
 
@@ -2400,7 +2400,7 @@ static ssize_t target_core_alua_tg_pt_gp_show_attr_members(
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_for_each_entry(tg_pt_gp_mem, &tg_pt_gp->tg_pt_gp_mem_list,
-			tg_pt_gp_mem_list) {
+			tg_pt_gp_mem_node) {
 		port = tg_pt_gp_mem->tg_pt;
 		tpg = port->sep_tpg;
 		lun = port->sep_lun;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 207b340..3350467 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -364,7 +364,7 @@ int core_enable_device_list_for_node(
 	spin_unlock_irq(&nacl->device_list_lock);
 
 	spin_lock_bh(&port->sep_alua_lock);
-	list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
+	list_add_tail(&deve->alua_port_node, &port->sep_alua_list);
 	spin_unlock_bh(&port->sep_alua_lock);
 
 	return 0;
@@ -393,13 +393,13 @@ int core_disable_device_list_for_node(
 	 *
 	 * deve->se_lun_acl will be NULL for demo-mode created LUNs
 	 * that have not been explicitly converted to MappedLUNs ->
-	 * struct se_lun_acl, but we remove deve->alua_port_list from
+	 * struct se_lun_acl, but we remove deve->alua_port_node from
 	 * port->sep_alua_list. This also means that active UAs and
 	 * NodeACL context specific PR metadata for demo-mode
 	 * MappedLUN *deve will be released below..
 	 */
 	spin_lock_bh(&port->sep_alua_lock);
-	list_del(&deve->alua_port_list);
+	list_del(&deve->alua_port_node);
 	spin_unlock_bh(&port->sep_alua_lock);
 	/*
 	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
@@ -435,7 +435,7 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	u32 i;
 
 	spin_lock_irq(&tpg->acl_node_lock);
-	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
+	list_for_each_entry(nacl, &tpg->acl_node_list, acl_node) {
 		spin_unlock_irq(&tpg->acl_node_lock);
 
 		spin_lock_irq(&nacl->device_list_lock);
@@ -468,7 +468,7 @@ static struct se_port *core_alloc_port(struct se_device *dev)
 		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&port->sep_alua_list);
-	INIT_LIST_HEAD(&port->sep_list);
+	INIT_LIST_HEAD(&port->sep_node);
 	atomic_set(&port->sep_tg_pt_secondary_offline, 0);
 	spin_lock_init(&port->sep_alua_lock);
 	mutex_init(&port->sep_tg_pt_md_mutex);
@@ -497,7 +497,7 @@ again:
 	if (!port->sep_rtpi)
 		goto again;
 
-	list_for_each_entry(port_tmp, &dev->dev_sep_list, sep_list) {
+	list_for_each_entry(port_tmp, &dev->dev_sep_list, sep_node) {
 		/*
 		 * Make sure RELATIVE TARGET PORT IDENTIFIER is unique
 		 * for 16-bit wrap..
@@ -525,7 +525,7 @@ static void core_export_port(
 	lun->lun_sep = port;
 	spin_unlock(&lun->lun_sep_lock);
 
-	list_add_tail(&port->sep_list, &dev->dev_sep_list);
+	list_add_tail(&port->sep_node, &dev->dev_sep_list);
 	spin_unlock(&dev->se_port_lock);
 
 	if (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV &&
@@ -566,7 +566,7 @@ static void core_release_port(struct se_device *dev, struct se_port *port)
 
 	core_alua_free_tg_pt_gp_mem(port);
 
-	list_del(&port->sep_list);
+	list_del(&port->sep_node);
 	dev->dev_port_count--;
 	kfree(port);
 }
@@ -1137,7 +1137,7 @@ struct se_lun *core_dev_add_lun(
 	if (tpg->se_tpg_tfo->tpg_check_demo_mode(tpg)) {
 		struct se_node_acl *acl;
 		spin_lock_irq(&tpg->acl_node_lock);
-		list_for_each_entry(acl, &tpg->acl_node_list, acl_list) {
+		list_for_each_entry(acl, &tpg->acl_node_list, acl_node) {
 			if (acl->dynamic_node_acl &&
 			    (!tpg->se_tpg_tfo->tpg_check_demo_mode_login_only ||
 			     !tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg))) {
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 2f5d779..d141c7f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -673,14 +673,14 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 * for ALL_TG_PT=1
 	 */
 	spin_lock(&dev->se_port_lock);
-	list_for_each_entry_safe(port, port_tmp, &dev->dev_sep_list, sep_list) {
+	list_for_each_entry_safe(port, port_tmp, &dev->dev_sep_list, sep_node) {
 		atomic_inc(&port->sep_tg_pt_ref_cnt);
 		smp_mb__after_atomic_inc();
 		spin_unlock(&dev->se_port_lock);
 
 		spin_lock_bh(&port->sep_alua_lock);
 		list_for_each_entry(deve_tmp, &port->sep_alua_list,
-					alua_port_list) {
+					alua_port_node) {
 			/*
 			 * This pointer will be NULL for demo mode MappedLUNs
 			 * that have not been make explicit via a ConfigFS
@@ -1526,7 +1526,7 @@ core_scsi3_decode_spec_i_port(
 		dest_tpg = NULL;
 
 		spin_lock(&dev->se_port_lock);
-		list_for_each_entry(tmp_port, &dev->dev_sep_list, sep_list) {
+		list_for_each_entry(tmp_port, &dev->dev_sep_list, sep_node) {
 			tmp_tpg = tmp_port->sep_tpg;
 			if (!tmp_tpg)
 				continue;
@@ -3154,7 +3154,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	}
 
 	spin_lock(&dev->se_port_lock);
-	list_for_each_entry(se_port, &dev->dev_sep_list, sep_list) {
+	list_for_each_entry(se_port, &dev->dev_sep_list, sep_node) {
 		if (se_port->sep_rtpi != rtpi)
 			continue;
 		dest_se_tpg = se_port->sep_tpg;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index f697f8b..1fd90fc 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -92,7 +92,7 @@ struct se_node_acl *__core_tpg_get_initiator_node_acl(
 {
 	struct se_node_acl *acl;
 
-	list_for_each_entry(acl, &tpg->acl_node_list, acl_list) {
+	list_for_each_entry(acl, &tpg->acl_node_list, acl_node) {
 		if (!strcmp(acl->initiatorname, initiatorname))
 			return acl;
 	}
@@ -239,7 +239,7 @@ static int core_create_device_list_for_node(struct se_node_acl *nacl)
 		atomic_set(&deve->ua_count, 0);
 		atomic_set(&deve->pr_ref_count, 0);
 		spin_lock_init(&deve->ua_lock);
-		INIT_LIST_HEAD(&deve->alua_port_list);
+		INIT_LIST_HEAD(&deve->alua_port_node);
 		INIT_LIST_HEAD(&deve->ua_list);
 	}
 
@@ -267,7 +267,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	if (!acl)
 		return NULL;
 
-	INIT_LIST_HEAD(&acl->acl_list);
+	INIT_LIST_HEAD(&acl->acl_node);
 	INIT_LIST_HEAD(&acl->acl_sess_list);
 	kref_init(&acl->acl_kref);
 	init_completion(&acl->acl_free_comp);
@@ -303,7 +303,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 		core_tpg_add_node_to_devs(acl, tpg);
 
 	spin_lock_irq(&tpg->acl_node_lock);
-	list_add_tail(&acl->acl_list, &tpg->acl_node_list);
+	list_add_tail(&acl->acl_node, &tpg->acl_node_list);
 	tpg->num_node_acls++;
 	spin_unlock_irq(&tpg->acl_node_lock);
 
@@ -395,7 +395,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	 */
 	acl = se_nacl;
 
-	INIT_LIST_HEAD(&acl->acl_list);
+	INIT_LIST_HEAD(&acl->acl_node);
 	INIT_LIST_HEAD(&acl->acl_sess_list);
 	kref_init(&acl->acl_kref);
 	init_completion(&acl->acl_free_comp);
@@ -422,7 +422,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	}
 
 	spin_lock_irq(&tpg->acl_node_lock);
-	list_add_tail(&acl->acl_list, &tpg->acl_node_list);
+	list_add_tail(&acl->acl_node, &tpg->acl_node_list);
 	tpg->num_node_acls++;
 	spin_unlock_irq(&tpg->acl_node_lock);
 
@@ -454,7 +454,7 @@ int core_tpg_del_initiator_node_acl(
 	if (acl->dynamic_node_acl) {
 		acl->dynamic_node_acl = 0;
 	}
-	list_del(&acl->acl_list);
+	list_del(&acl->acl_node);
 	tpg->num_node_acls--;
 	spin_unlock_irq(&tpg->acl_node_lock);
 
@@ -532,7 +532,7 @@ int core_tpg_set_initiator_node_queue_depth(
 	spin_unlock_irq(&tpg->acl_node_lock);
 
 	spin_lock_irqsave(&tpg->session_lock, flags);
-	list_for_each_entry(sess, &tpg->tpg_sess_list, sess_list) {
+	list_for_each_entry(sess, &tpg->tpg_sess_list, sess_node) {
 		if (sess->se_node_acl != acl)
 			continue;
 
@@ -767,8 +767,8 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	 */
 	spin_lock_irq(&se_tpg->acl_node_lock);
 	list_for_each_entry_safe(nacl, nacl_tmp, &se_tpg->acl_node_list,
-			acl_list) {
-		list_del(&nacl->acl_list);
+			acl_node) {
+		list_del(&nacl->acl_node);
 		se_tpg->num_node_acls--;
 		spin_unlock_irq(&se_tpg->acl_node_lock);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 91953da..accaca5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -219,7 +219,7 @@ struct se_session *transport_init_session(void)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	INIT_LIST_HEAD(&se_sess->sess_list);
+	INIT_LIST_HEAD(&se_sess->sess_node);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
 	INIT_LIST_HEAD(&se_sess->sess_wait_list);
@@ -324,7 +324,7 @@ void __transport_register_session(
 			      &se_nacl->acl_sess_list);
 		spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	}
-	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
+	list_add_tail(&se_sess->sess_node, &se_tpg->tpg_sess_list);
 
 	pr_debug("TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
 		se_tpg->se_tpg_tfo->get_fabric_name(), se_sess->fabric_sess_ptr);
@@ -442,7 +442,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	se_tfo = se_tpg->se_tpg_tfo;
 
 	spin_lock_irqsave(&se_tpg->session_lock, flags);
-	list_del(&se_sess->sess_list);
+	list_del(&se_sess->sess_node);
 	se_sess->se_tpg = NULL;
 	se_sess->fabric_sess_ptr = NULL;
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
@@ -456,7 +456,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	spin_lock_irqsave(&se_tpg->acl_node_lock, flags);
 	if (se_nacl && se_nacl->dynamic_node_acl) {
 		if (!se_tfo->tpg_check_demo_mode_cache(se_tpg)) {
-			list_del(&se_nacl->acl_list);
+			list_del(&se_nacl->acl_node);
 			se_tpg->num_node_acls--;
 			spin_unlock_irqrestore(&se_tpg->acl_node_lock, flags);
 			core_tpg_wait_for_nacl_pr_ref(se_nacl);
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 505519b..2a1cbf9 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -98,7 +98,7 @@ int core_scsi3_ua_allocate(
 		pr_err("Unable to allocate struct se_ua\n");
 		return -ENOMEM;
 	}
-	INIT_LIST_HEAD(&ua->ua_nacl_list);
+	INIT_LIST_HEAD(&ua->ua_nacl_node);
 
 	ua->ua_nacl = nacl;
 	ua->ua_asc = asc;
@@ -108,7 +108,7 @@ int core_scsi3_ua_allocate(
 	deve = nacl->device_list[unpacked_lun];
 
 	spin_lock(&deve->ua_lock);
-	list_for_each_entry_safe(ua_p, ua_tmp, &deve->ua_list, ua_nacl_list) {
+	list_for_each_entry_safe(ua_p, ua_tmp, &deve->ua_list, ua_nacl_node) {
 		/*
 		 * Do not report the same UNIT ATTENTION twice..
 		 */
@@ -139,10 +139,10 @@ int core_scsi3_ua_allocate(
 		 */
 		if (ua_p->ua_asc == 0x29) {
 			if ((asc == 0x29) && (ascq > ua_p->ua_ascq))
-				list_add(&ua->ua_nacl_list,
+				list_add(&ua->ua_nacl_node,
 						&deve->ua_list);
 			else
-				list_add_tail(&ua->ua_nacl_list,
+				list_add_tail(&ua->ua_nacl_node,
 						&deve->ua_list);
 		} else if (ua_p->ua_asc == 0x2a) {
 			/*
@@ -150,13 +150,13 @@ int core_scsi3_ua_allocate(
 			 * Family 2AHh ASCQ codes for Unit Attention condition.
 			 */
 			if ((asc == 0x29) || (ascq > ua_p->ua_asc))
-				list_add(&ua->ua_nacl_list,
+				list_add(&ua->ua_nacl_node,
 					&deve->ua_list);
 			else
-				list_add_tail(&ua->ua_nacl_list,
+				list_add_tail(&ua->ua_nacl_node,
 						&deve->ua_list);
 		} else
-			list_add_tail(&ua->ua_nacl_list,
+			list_add_tail(&ua->ua_nacl_node,
 				&deve->ua_list);
 		spin_unlock(&deve->ua_lock);
 		spin_unlock_irq(&nacl->device_list_lock);
@@ -165,7 +165,7 @@ int core_scsi3_ua_allocate(
 		smp_mb__after_atomic_inc();
 		return 0;
 	}
-	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
+	list_add_tail(&ua->ua_nacl_node, &deve->ua_list);
 	spin_unlock(&deve->ua_lock);
 	spin_unlock_irq(&nacl->device_list_lock);
 
@@ -185,8 +185,8 @@ void core_scsi3_ua_release_all(
 	struct se_ua *ua, *ua_p;
 
 	spin_lock(&deve->ua_lock);
-	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_list) {
-		list_del(&ua->ua_nacl_list);
+	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_node) {
+		list_del(&ua->ua_nacl_node);
 		kmem_cache_free(se_ua_cache, ua);
 
 		atomic_dec(&deve->ua_count);
@@ -226,7 +226,7 @@ void core_scsi3_ua_for_check_condition(
 	 * sense data for the received CDB.
 	 */
 	spin_lock(&deve->ua_lock);
-	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_list) {
+	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_node) {
 		/*
 		 * For ua_intlck_ctrl code not equal to 00b, only report the
 		 * highest priority UNIT_ATTENTION and ASC/ASCQ without
@@ -247,7 +247,7 @@ void core_scsi3_ua_for_check_condition(
 			*ascq = ua->ua_ascq;
 			head = 0;
 		}
-		list_del(&ua->ua_nacl_list);
+		list_del(&ua->ua_nacl_node);
 		kmem_cache_free(se_ua_cache, ua);
 
 		atomic_dec(&deve->ua_count);
@@ -300,13 +300,13 @@ int core_scsi3_ua_clear_for_request_sense(
 	 * struct se_lun.
 	 */
 	spin_lock(&deve->ua_lock);
-	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_list) {
+	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_node) {
 		if (head) {
 			*asc = ua->ua_asc;
 			*ascq = ua->ua_ascq;
 			head = 0;
 		}
-		list_del(&ua->ua_nacl_list);
+		list_del(&ua->ua_nacl_node);
 		kmem_cache_free(se_ua_cache, ua);
 
 		atomic_dec(&deve->ua_count);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 6b88a99..bf22d4b 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -463,7 +463,7 @@ int target_xcopy_setup_pt(void)
 
 	memset(&xcopy_pt_port, 0, sizeof(struct se_port));
 	INIT_LIST_HEAD(&xcopy_pt_port.sep_alua_list);
-	INIT_LIST_HEAD(&xcopy_pt_port.sep_list);
+	INIT_LIST_HEAD(&xcopy_pt_port.sep_node);
 	mutex_init(&xcopy_pt_port.sep_tg_pt_md_mutex);
 
 	memset(&xcopy_pt_tpg, 0, sizeof(struct se_portal_group));
@@ -475,10 +475,10 @@ int target_xcopy_setup_pt(void)
 	xcopy_pt_tpg.se_tpg_tfo = &xcopy_pt_tfo;
 
 	memset(&xcopy_pt_nacl, 0, sizeof(struct se_node_acl));
-	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_list);
+	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_node);
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_sess_list);
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
-	INIT_LIST_HEAD(&xcopy_pt_sess.sess_list);
+	INIT_LIST_HEAD(&xcopy_pt_sess.sess_node);
 	INIT_LIST_HEAD(&xcopy_pt_sess.sess_acl_list);
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index c6932fb..47d0038 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -250,7 +250,7 @@ struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
 	struct se_node_acl *se_acl;
 
 	spin_lock_irq(&se_tpg->acl_node_lock);
-	list_for_each_entry(se_acl, &se_tpg->acl_node_list, acl_list) {
+	list_for_each_entry(se_acl, &se_tpg->acl_node_list, acl_node) {
 		acl = container_of(se_acl, struct ft_node_acl, se_node_acl);
 		pr_debug("acl %p port_name %llx\n",
 			acl, (unsigned long long)acl->node_auth.port_name);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d6f96c7..d5e0da1 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -277,7 +277,7 @@ struct t10_alua_lu_gp_member {
 	spinlock_t lu_gp_mem_lock;
 	struct t10_alua_lu_gp *lu_gp;
 	struct se_device *lu_gp_mem_dev;
-	struct list_head lu_gp_mem_list;
+	struct list_head lu_gp_mem_node;
 };
 
 struct t10_alua_tg_pt_gp {
@@ -301,7 +301,7 @@ struct t10_alua_tg_pt_gp {
 	struct mutex tg_pt_gp_md_mutex;
 	struct se_device *tg_pt_gp_dev;
 	struct config_group tg_pt_gp_group;
-	struct list_head tg_pt_gp_list;
+	struct list_head tg_pt_gp_node;
 	struct list_head tg_pt_gp_mem_list;
 };
 
@@ -311,7 +311,7 @@ struct t10_alua_tg_pt_gp_member {
 	spinlock_t tg_pt_gp_mem_lock;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct se_port *tg_pt;
-	struct list_head tg_pt_gp_mem_list;
+	struct list_head tg_pt_gp_mem_node;
 };
 
 struct t10_vpd {
@@ -504,7 +504,7 @@ struct se_ua {
 	u8			ua_asc;
 	u8			ua_ascq;
 	struct se_node_acl	*ua_nacl;
-	struct list_head	ua_nacl_list;
+	struct list_head	ua_nacl_node;
 };
 
 struct se_node_acl {
@@ -533,7 +533,7 @@ struct se_node_acl {
 	struct config_group	acl_param_group;
 	struct config_group	acl_fabric_stat_group;
 	struct config_group	*acl_default_groups[5];
-	struct list_head	acl_list;
+	struct list_head	acl_node;
 	struct list_head	acl_sess_list;
 	struct completion	acl_free_comp;
 	struct kref		acl_kref;
@@ -545,7 +545,7 @@ struct se_session {
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
-	struct list_head	sess_list;
+	struct list_head	sess_node;
 	struct list_head	sess_acl_list;
 	struct list_head	sess_cmd_list;
 	struct list_head	sess_wait_list;
@@ -592,7 +592,7 @@ struct se_dev_entry {
 	struct se_lun_acl	*se_lun_acl;
 	spinlock_t		ua_lock;
 	struct se_lun		*se_lun;
-	struct list_head	alua_port_list;
+	struct list_head	alua_port_node;
 	struct list_head	ua_list;
 };
 
@@ -780,7 +780,7 @@ struct se_port {
 	struct se_lun *sep_lun;
 	struct se_portal_group *sep_tpg;
 	struct list_head sep_alua_list;
-	struct list_head sep_list;
+	struct list_head sep_node;
 };
 
 struct se_tpg_np {
-- 
1.7.1
