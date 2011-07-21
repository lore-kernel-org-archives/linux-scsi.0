From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 098/103] target: Remove extra parentheses
Date: Thu, 21 Jul 2011 07:05:30 +0000
Message-ID: <1311231935-24635-99-git-send-email-nab@linux-iscsi.org>
References: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51701 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1GUH3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 03:29:40 -0400
In-Reply-To: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

No functional changes. Remove extraneous parentheses in if statements,
where there is no chance of order-of-operations confusion. Most
significantly, all instances of parens around bit-testing are retained.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c            |   72 +++++-----
 drivers/target/target_core_cdb.c             |    8 +-
 drivers/target/target_core_configfs.c        |  208 +++++++++++++-------------
 drivers/target/target_core_device.c          |   44 +++---
 drivers/target/target_core_fabric_configfs.c |   70 +++------
 drivers/target/target_core_fabric_lib.c      |    4 +-
 drivers/target/target_core_file.c            |   12 +-
 drivers/target/target_core_hba.c             |    2 +-
 drivers/target/target_core_iblock.c          |   24 ++--
 drivers/target/target_core_pr.c              |  190 ++++++++++++------------
 drivers/target/target_core_pscsi.c           |   44 +++---
 drivers/target/target_core_rd.c              |   26 ++--
 drivers/target/target_core_tmr.c             |   20 ++--
 drivers/target/target_core_tpg.c             |   33 ++--
 drivers/target/target_core_transport.c       |   95 ++++++------
 drivers/target/target_core_ua.c              |   22 ++--
 16 files changed, 424 insertions(+), 450 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index e93c2dd..98c98a3 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -167,7 +167,7 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 	int alua_access_state, primary = 0, rc;
 	u16 tg_pt_id, rtpi;
 
-	if (!(l_port))
+	if (!l_port)
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 
 	buf = transport_kmap_first_data_page(cmd);
@@ -177,14 +177,14 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 	 * for the local tg_pt_gp.
 	 */
 	l_tg_pt_gp_mem = l_port->sep_alua_tg_pt_gp_mem;
-	if (!(l_tg_pt_gp_mem)) {
+	if (!l_tg_pt_gp_mem) {
 		pr_err("Unable to access l_port->sep_alua_tg_pt_gp_mem\n");
 		rc = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		goto out;
 	}
 	spin_lock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	l_tg_pt_gp = l_tg_pt_gp_mem->tg_pt_gp;
-	if (!(l_tg_pt_gp)) {
+	if (!l_tg_pt_gp) {
 		spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 		pr_err("Unable to access *l_tg_pt_gp_mem->tg_pt_gp\n");
 		rc = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
@@ -193,7 +193,7 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 	rc = (l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA);
 	spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
-	if (!(rc)) {
+	if (!rc) {
 		pr_debug("Unable to process SET_TARGET_PORT_GROUPS"
 				" while TPGS_EXPLICT_ALUA is disabled\n");
 		rc = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
@@ -249,7 +249,7 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 			list_for_each_entry(tg_pt_gp,
 					&su_dev->t10_alua.tg_pt_gps_list,
 					tg_pt_gp_list) {
-				if (!(tg_pt_gp->tg_pt_gp_valid_id))
+				if (!tg_pt_gp->tg_pt_gp_valid_id)
 					continue;
 
 				if (tg_pt_id != tg_pt_gp->tg_pt_gp_id)
@@ -498,7 +498,7 @@ static int core_alua_state_check(
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	int out_alua_state, nonop_delay_msecs;
 
-	if (!(port))
+	if (!port)
 		return 0;
 	/*
 	 * First, check for a struct se_port specific secondary ALUA target port
@@ -638,7 +638,7 @@ int core_alua_check_nonop_delay(
 	 * The ALUA Active/NonOptimized access state delay can be disabled
 	 * in via configfs with a value of zero
 	 */
-	if (!(cmd->alua_nonop_delay))
+	if (!cmd->alua_nonop_delay)
 		return 0;
 	/*
 	 * struct se_cmd->alua_nonop_delay gets set by a target port group
@@ -778,7 +778,7 @@ static int core_alua_do_transition_tg_pt(
 			 * se_deve->se_lun_acl pointer may be NULL for a
 			 * entry created without explict Node+MappedLUN ACLs
 			 */
-			if (!(lacl))
+			if (!lacl)
 				continue;
 
 			if (explict &&
@@ -851,7 +851,7 @@ int core_alua_do_port_transition(
 		return -EINVAL;
 
 	md_buf = kzalloc(l_tg_pt_gp->tg_pt_gp_md_buf_len, GFP_KERNEL);
-	if (!(md_buf)) {
+	if (!md_buf) {
 		pr_err("Unable to allocate buf for ALUA metadata\n");
 		return -ENOMEM;
 	}
@@ -867,7 +867,7 @@ int core_alua_do_port_transition(
 	 * we only do transition on the passed *l_tp_pt_gp, and not
 	 * on all of the matching target port groups IDs in default_lu_gp.
 	 */
-	if (!(lu_gp->lu_gp_id)) {
+	if (!lu_gp->lu_gp_id) {
 		/*
 		 * core_alua_do_transition_tg_pt() will always return
 		 * success.
@@ -899,7 +899,7 @@ int core_alua_do_port_transition(
 				&su_dev->t10_alua.tg_pt_gps_list,
 				tg_pt_gp_list) {
 
-			if (!(tg_pt_gp->tg_pt_gp_valid_id))
+			if (!tg_pt_gp->tg_pt_gp_valid_id)
 				continue;
 			/*
 			 * If the target behavior port asymmetric access state
@@ -1001,7 +1001,7 @@ static int core_alua_set_tg_pt_secondary_state(
 
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
-	if (!(tg_pt_gp)) {
+	if (!tg_pt_gp) {
 		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 		pr_err("Unable to complete secondary state"
 				" transition\n");
@@ -1040,7 +1040,7 @@ static int core_alua_set_tg_pt_secondary_state(
 	 */
 	if (port->sep_tg_pt_secondary_write_md) {
 		md_buf = kzalloc(md_buf_len, GFP_KERNEL);
-		if (!(md_buf)) {
+		if (!md_buf) {
 			pr_err("Unable to allocate md_buf for"
 				" secondary ALUA access metadata\n");
 			return -ENOMEM;
@@ -1062,7 +1062,7 @@ core_alua_allocate_lu_gp(const char *name, int def_group)
 	struct t10_alua_lu_gp *lu_gp;
 
 	lu_gp = kmem_cache_zalloc(t10_alua_lu_gp_cache, GFP_KERNEL);
-	if (!(lu_gp)) {
+	if (!lu_gp) {
 		pr_err("Unable to allocate struct t10_alua_lu_gp\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1107,7 +1107,7 @@ again:
 
 	list_for_each_entry(lu_gp_tmp, &lu_gps_list, lu_gp_node) {
 		if (lu_gp_tmp->lu_gp_id == lu_gp_id_tmp) {
-			if (!(lu_gp_id))
+			if (!lu_gp_id)
 				goto again;
 
 			pr_warn("ALUA Logical Unit Group ID: %hu"
@@ -1133,7 +1133,7 @@ core_alua_allocate_lu_gp_mem(struct se_device *dev)
 	struct t10_alua_lu_gp_member *lu_gp_mem;
 
 	lu_gp_mem = kmem_cache_zalloc(t10_alua_lu_gp_mem_cache, GFP_KERNEL);
-	if (!(lu_gp_mem)) {
+	if (!lu_gp_mem) {
 		pr_err("Unable to allocate struct t10_alua_lu_gp_member\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1218,7 +1218,7 @@ void core_alua_free_lu_gp_mem(struct se_device *dev)
 		return;
 
 	lu_gp_mem = dev->dev_alua_lu_gp_mem;
-	if (!(lu_gp_mem))
+	if (!lu_gp_mem)
 		return;
 
 	while (atomic_read(&lu_gp_mem->lu_gp_mem_ref_cnt))
@@ -1226,7 +1226,7 @@ void core_alua_free_lu_gp_mem(struct se_device *dev)
 
 	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = lu_gp_mem->lu_gp;
-	if ((lu_gp)) {
+	if (lu_gp) {
 		spin_lock(&lu_gp->lu_gp_lock);
 		if (lu_gp_mem->lu_gp_assoc) {
 			list_del(&lu_gp_mem->lu_gp_mem_list);
@@ -1248,10 +1248,10 @@ struct t10_alua_lu_gp *core_alua_get_lu_gp_by_name(const char *name)
 
 	spin_lock(&lu_gps_lock);
 	list_for_each_entry(lu_gp, &lu_gps_list, lu_gp_node) {
-		if (!(lu_gp->lu_gp_valid_id))
+		if (!lu_gp->lu_gp_valid_id)
 			continue;
 		ci = &lu_gp->lu_gp_group.cg_item;
-		if (!(strcmp(config_item_name(ci), name))) {
+		if (!strcmp(config_item_name(ci), name)) {
 			atomic_inc(&lu_gp->lu_gp_ref_cnt);
 			spin_unlock(&lu_gps_lock);
 			return lu_gp;
@@ -1307,7 +1307,7 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 
 	tg_pt_gp = kmem_cache_zalloc(t10_alua_tg_pt_gp_cache, GFP_KERNEL);
-	if (!(tg_pt_gp)) {
+	if (!tg_pt_gp) {
 		pr_err("Unable to allocate struct t10_alua_tg_pt_gp\n");
 		return NULL;
 	}
@@ -1376,7 +1376,7 @@ again:
 	list_for_each_entry(tg_pt_gp_tmp, &su_dev->t10_alua.tg_pt_gps_list,
 			tg_pt_gp_list) {
 		if (tg_pt_gp_tmp->tg_pt_gp_id == tg_pt_gp_id_tmp) {
-			if (!(tg_pt_gp_id))
+			if (!tg_pt_gp_id)
 				goto again;
 
 			pr_err("ALUA Target Port Group ID: %hu already"
@@ -1403,7 +1403,7 @@ struct t10_alua_tg_pt_gp_member *core_alua_allocate_tg_pt_gp_mem(
 
 	tg_pt_gp_mem = kmem_cache_zalloc(t10_alua_tg_pt_gp_mem_cache,
 				GFP_KERNEL);
-	if (!(tg_pt_gp_mem)) {
+	if (!tg_pt_gp_mem) {
 		pr_err("Unable to allocate struct t10_alua_tg_pt_gp_member\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1491,7 +1491,7 @@ void core_alua_free_tg_pt_gp_mem(struct se_port *port)
 		return;
 
 	tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-	if (!(tg_pt_gp_mem))
+	if (!tg_pt_gp_mem)
 		return;
 
 	while (atomic_read(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt))
@@ -1499,7 +1499,7 @@ void core_alua_free_tg_pt_gp_mem(struct se_port *port)
 
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
-	if ((tg_pt_gp)) {
+	if (tg_pt_gp) {
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 		if (tg_pt_gp_mem->tg_pt_gp_assoc) {
 			list_del(&tg_pt_gp_mem->tg_pt_gp_mem_list);
@@ -1524,10 +1524,10 @@ static struct t10_alua_tg_pt_gp *core_alua_get_tg_pt_gp_by_name(
 	spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
 	list_for_each_entry(tg_pt_gp, &su_dev->t10_alua.tg_pt_gps_list,
 			tg_pt_gp_list) {
-		if (!(tg_pt_gp->tg_pt_gp_valid_id))
+		if (!tg_pt_gp->tg_pt_gp_valid_id)
 			continue;
 		ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
-		if (!(strcmp(config_item_name(ci), name))) {
+		if (!strcmp(config_item_name(ci), name)) {
 			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
 			spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 			return tg_pt_gp;
@@ -1592,12 +1592,12 @@ ssize_t core_alua_show_tg_pt_gp_info(struct se_port *port, char *page)
 		return len;
 
 	tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-	if (!(tg_pt_gp_mem))
+	if (!tg_pt_gp_mem)
 		return len;
 
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
-	if ((tg_pt_gp)) {
+	if (tg_pt_gp) {
 		tg_pt_ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
 		len += sprintf(page, "TG Port Alias: %s\nTG Port Group ID:"
 			" %hu\nTG Port Primary Access State: %s\nTG Port "
@@ -1659,11 +1659,11 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		 */
 		tg_pt_gp_new = core_alua_get_tg_pt_gp_by_name(su_dev,
 					strstrip(buf));
-		if (!(tg_pt_gp_new))
+		if (!tg_pt_gp_new)
 			return -ENODEV;
 	}
 	tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-	if (!(tg_pt_gp_mem)) {
+	if (!tg_pt_gp_mem) {
 		if (tg_pt_gp_new)
 			core_alua_put_tg_pt_gp_from_name(tg_pt_gp_new);
 		pr_err("NULL struct se_port->sep_alua_tg_pt_gp_mem pointer\n");
@@ -1672,12 +1672,12 @@ ssize_t core_alua_store_tg_pt_gp_info(
 
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
-	if ((tg_pt_gp)) {
+	if (tg_pt_gp) {
 		/*
 		 * Clearing an existing tg_pt_gp association, and replacing
 		 * with the default_tg_pt_gp.
 		 */
-		if (!(tg_pt_gp_new)) {
+		if (!tg_pt_gp_new) {
 			pr_debug("Target_Core_ConfigFS: Moving"
 				" %s/tpgt_%hu/%s from ALUA Target Port Group:"
 				" alua/%s, ID: %hu back to"
@@ -1858,7 +1858,7 @@ ssize_t core_alua_store_preferred_bit(
 
 ssize_t core_alua_show_offline_bit(struct se_lun *lun, char *page)
 {
-	if (!(lun->lun_sep))
+	if (!lun->lun_sep)
 		return -ENODEV;
 
 	return sprintf(page, "%d\n",
@@ -1874,7 +1874,7 @@ ssize_t core_alua_store_offline_bit(
 	unsigned long tmp;
 	int ret;
 
-	if (!(lun->lun_sep))
+	if (!lun->lun_sep)
 		return -ENODEV;
 
 	ret = strict_strtoul(page, 0, &tmp);
@@ -1888,7 +1888,7 @@ ssize_t core_alua_store_offline_bit(
 		return -EINVAL;
 	}
 	tg_pt_gp_mem = lun->lun_sep->sep_alua_tg_pt_gp_mem;
-	if (!(tg_pt_gp_mem)) {
+	if (!tg_pt_gp_mem) {
 		pr_err("Unable to locate *tg_pt_gp_mem\n");
 		return -EINVAL;
 	}
diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index d03eebc..9828300 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -327,7 +327,7 @@ check_tpgi:
 
 		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 		tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
-		if (!(tg_pt_gp)) {
+		if (!tg_pt_gp) {
 			spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 			goto check_lu_gp;
 		}
@@ -358,12 +358,12 @@ check_lu_gp:
 			goto check_scsi_name;
 		}
 		lu_gp_mem = dev->dev_alua_lu_gp_mem;
-		if (!(lu_gp_mem))
+		if (!lu_gp_mem)
 			goto check_scsi_name;
 
 		spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 		lu_gp = lu_gp_mem->lu_gp;
-		if (!(lu_gp)) {
+		if (!lu_gp) {
 			spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 			goto check_scsi_name;
 		}
@@ -957,7 +957,7 @@ target_emulate_request_sense(struct se_cmd *cmd)
 
 	buf = transport_kmap_first_data_page(cmd);
 
-	if (!(core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq))) {
+	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq)) {
 		/*
 		 * CURRENT ERROR, UNIT ATTENTION
 		 */
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 65336e9..e56c39d 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -104,12 +104,12 @@ static struct target_fabric_configfs *target_core_get_fabric(
 {
 	struct target_fabric_configfs *tf;
 
-	if (!(name))
+	if (!name)
 		return NULL;
 
 	mutex_lock(&g_tf_lock);
 	list_for_each_entry(tf, &g_tf_list, tf_list) {
-		if (!(strcmp(tf->tf_name, name))) {
+		if (!strcmp(tf->tf_name, name)) {
 			atomic_inc(&tf->tf_access_cnt);
 			mutex_unlock(&g_tf_lock);
 			return tf;
@@ -150,7 +150,7 @@ static struct config_group *target_core_register_fabric(
 	 * registered, but simply provids auto loading logic for modules with
 	 * mkdir(2) system calls with known TCM fabric modules.
 	 */
-	if (!(strncmp(name, "iscsi", 5))) {
+	if (!strncmp(name, "iscsi", 5)) {
 		/*
 		 * Automatically load the LIO Target fabric module when the
 		 * following is called:
@@ -163,7 +163,7 @@ static struct config_group *target_core_register_fabric(
 				" iscsi_target_mod.ko: %d\n", ret);
 			return ERR_PTR(-EINVAL);
 		}
-	} else if (!(strncmp(name, "loopback", 8))) {
+	} else if (!strncmp(name, "loopback", 8)) {
 		/*
 		 * Automatically load the tcm_loop fabric module when the
 		 * following is called:
@@ -179,7 +179,7 @@ static struct config_group *target_core_register_fabric(
 	}
 
 	tf = target_core_get_fabric(name);
-	if (!(tf)) {
+	if (!tf) {
 		pr_err("target_core_get_fabric() failed for %s\n",
 			name);
 		return ERR_PTR(-EINVAL);
@@ -317,7 +317,7 @@ struct target_fabric_configfs *target_fabric_configfs_init(
 	}
 
 	tf = kzalloc(sizeof(struct target_fabric_configfs), GFP_KERNEL);
-	if (!(tf))
+	if (!tf)
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&tf->tf_list);
@@ -367,59 +367,59 @@ static int target_fabric_tf_ops_check(
 {
 	struct target_core_fabric_ops *tfo = &tf->tf_ops;
 
-	if (!(tfo->get_fabric_name)) {
+	if (!tfo->get_fabric_name) {
 		pr_err("Missing tfo->get_fabric_name()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->get_fabric_proto_ident)) {
+	if (!tfo->get_fabric_proto_ident) {
 		pr_err("Missing tfo->get_fabric_proto_ident()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_get_wwn)) {
+	if (!tfo->tpg_get_wwn) {
 		pr_err("Missing tfo->tpg_get_wwn()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_get_tag)) {
+	if (!tfo->tpg_get_tag) {
 		pr_err("Missing tfo->tpg_get_tag()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_get_default_depth)) {
+	if (!tfo->tpg_get_default_depth) {
 		pr_err("Missing tfo->tpg_get_default_depth()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_get_pr_transport_id)) {
+	if (!tfo->tpg_get_pr_transport_id) {
 		pr_err("Missing tfo->tpg_get_pr_transport_id()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_get_pr_transport_id_len)) {
+	if (!tfo->tpg_get_pr_transport_id_len) {
 		pr_err("Missing tfo->tpg_get_pr_transport_id_len()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_check_demo_mode)) {
+	if (!tfo->tpg_check_demo_mode) {
 		pr_err("Missing tfo->tpg_check_demo_mode()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_check_demo_mode_cache)) {
+	if (!tfo->tpg_check_demo_mode_cache) {
 		pr_err("Missing tfo->tpg_check_demo_mode_cache()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_check_demo_mode_write_protect)) {
+	if (!tfo->tpg_check_demo_mode_write_protect) {
 		pr_err("Missing tfo->tpg_check_demo_mode_write_protect()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_check_prod_mode_write_protect)) {
+	if (!tfo->tpg_check_prod_mode_write_protect) {
 		pr_err("Missing tfo->tpg_check_prod_mode_write_protect()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_alloc_fabric_acl)) {
+	if (!tfo->tpg_alloc_fabric_acl) {
 		pr_err("Missing tfo->tpg_alloc_fabric_acl()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_release_fabric_acl)) {
+	if (!tfo->tpg_release_fabric_acl) {
 		pr_err("Missing tfo->tpg_release_fabric_acl()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->tpg_get_inst_index)) {
+	if (!tfo->tpg_get_inst_index) {
 		pr_err("Missing tfo->tpg_get_inst_index()\n");
 		return -EINVAL;
 	}
@@ -427,71 +427,71 @@ static int target_fabric_tf_ops_check(
 		pr_err("Missing tfo->release_cmd()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->shutdown_session)) {
+	if (!tfo->shutdown_session) {
 		pr_err("Missing tfo->shutdown_session()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->close_session)) {
+	if (!tfo->close_session) {
 		pr_err("Missing tfo->close_session()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->stop_session)) {
+	if (!tfo->stop_session) {
 		pr_err("Missing tfo->stop_session()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->fall_back_to_erl0)) {
+	if (!tfo->fall_back_to_erl0) {
 		pr_err("Missing tfo->fall_back_to_erl0()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->sess_logged_in)) {
+	if (!tfo->sess_logged_in) {
 		pr_err("Missing tfo->sess_logged_in()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->sess_get_index)) {
+	if (!tfo->sess_get_index) {
 		pr_err("Missing tfo->sess_get_index()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->write_pending)) {
+	if (!tfo->write_pending) {
 		pr_err("Missing tfo->write_pending()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->write_pending_status)) {
+	if (!tfo->write_pending_status) {
 		pr_err("Missing tfo->write_pending_status()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->set_default_node_attributes)) {
+	if (!tfo->set_default_node_attributes) {
 		pr_err("Missing tfo->set_default_node_attributes()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->get_task_tag)) {
+	if (!tfo->get_task_tag) {
 		pr_err("Missing tfo->get_task_tag()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->get_cmd_state)) {
+	if (!tfo->get_cmd_state) {
 		pr_err("Missing tfo->get_cmd_state()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->queue_data_in)) {
+	if (!tfo->queue_data_in) {
 		pr_err("Missing tfo->queue_data_in()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->queue_status)) {
+	if (!tfo->queue_status) {
 		pr_err("Missing tfo->queue_status()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->queue_tm_rsp)) {
+	if (!tfo->queue_tm_rsp) {
 		pr_err("Missing tfo->queue_tm_rsp()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->set_fabric_sense_len)) {
+	if (!tfo->set_fabric_sense_len) {
 		pr_err("Missing tfo->set_fabric_sense_len()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->get_fabric_sense_len)) {
+	if (!tfo->get_fabric_sense_len) {
 		pr_err("Missing tfo->get_fabric_sense_len()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->is_state_remove)) {
+	if (!tfo->is_state_remove) {
 		pr_err("Missing tfo->is_state_remove()\n");
 		return -EINVAL;
 	}
@@ -500,19 +500,19 @@ static int target_fabric_tf_ops_check(
 	 * tfo->fabric_make_tpg() and tfo->fabric_drop_tpg() in
 	 * target_core_fabric_configfs.c WWN+TPG group context code.
 	 */
-	if (!(tfo->fabric_make_wwn)) {
+	if (!tfo->fabric_make_wwn) {
 		pr_err("Missing tfo->fabric_make_wwn()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->fabric_drop_wwn)) {
+	if (!tfo->fabric_drop_wwn) {
 		pr_err("Missing tfo->fabric_drop_wwn()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->fabric_make_tpg)) {
+	if (!tfo->fabric_make_tpg) {
 		pr_err("Missing tfo->fabric_make_tpg()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->fabric_drop_tpg)) {
+	if (!tfo->fabric_drop_tpg) {
 		pr_err("Missing tfo->fabric_drop_tpg()\n");
 		return -EINVAL;
 	}
@@ -533,12 +533,12 @@ int target_fabric_configfs_register(
 {
 	int ret;
 
-	if (!(tf)) {
+	if (!tf) {
 		pr_err("Unable to locate target_fabric_configfs"
 			" pointer\n");
 		return -EINVAL;
 	}
-	if (!(tf->tf_subsys)) {
+	if (!tf->tf_subsys) {
 		pr_err("Unable to target struct config_subsystem"
 			" pointer\n");
 		return -EINVAL;
@@ -558,13 +558,13 @@ void target_fabric_configfs_deregister(
 {
 	struct configfs_subsystem *su;
 
-	if (!(tf)) {
+	if (!tf) {
 		pr_err("Unable to locate passed target_fabric_"
 			"configfs\n");
 		return;
 	}
 	su = tf->tf_subsys;
-	if (!(su)) {
+	if (!su) {
 		pr_err("Unable to locate passed tf->tf_subsys"
 			" pointer\n");
 		return;
@@ -609,7 +609,7 @@ static ssize_t target_core_dev_show_attr_##_name(			\
 									\
 	spin_lock(&se_dev->se_dev_lock);				\
 	dev = se_dev->se_dev_ptr;					\
-	if (!(dev)) {							\
+	if (!dev) {							\
 		spin_unlock(&se_dev->se_dev_lock); 			\
 		return -ENODEV;						\
 	}								\
@@ -633,7 +633,7 @@ static ssize_t target_core_dev_store_attr_##_name(			\
 									\
 	spin_lock(&se_dev->se_dev_lock);				\
 	dev = se_dev->se_dev_ptr;					\
-	if (!(dev)) {							\
+	if (!dev) {							\
 		spin_unlock(&se_dev->se_dev_lock);			\
 		return -ENODEV;						\
 	}								\
@@ -806,7 +806,7 @@ static ssize_t target_core_dev_wwn_show_attr_vpd_unit_serial(
 	struct se_device *dev;
 
 	dev = se_dev->se_dev_ptr;
-	if (!(dev))
+	if (!dev)
 		return -ENODEV;
 
 	return sprintf(page, "T10 VPD Unit Serial Number: %s\n",
@@ -850,7 +850,7 @@ static ssize_t target_core_dev_wwn_store_attr_vpd_unit_serial(
 	 * could cause negative effects.
 	 */
 	dev = su_dev->se_dev_ptr;
-	if ((dev)) {
+	if (dev) {
 		if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
 			pr_err("Unable to set VPD Unit Serial while"
 				" active %d $FABRIC_MOD exports exist\n",
@@ -892,19 +892,19 @@ static ssize_t target_core_dev_wwn_show_attr_vpd_protocol_identifier(
 	ssize_t len = 0;
 
 	dev = se_dev->se_dev_ptr;
-	if (!(dev))
+	if (!dev)
 		return -ENODEV;
 
 	memset(buf, 0, VPD_TMP_BUF_SIZE);
 
 	spin_lock(&t10_wwn->t10_vpd_lock);
 	list_for_each_entry(vpd, &t10_wwn->t10_vpd_list, vpd_list) {
-		if (!(vpd->protocol_identifier_set))
+		if (!vpd->protocol_identifier_set)
 			continue;
 
 		transport_dump_vpd_proto_id(vpd, buf, VPD_TMP_BUF_SIZE);
 
-		if ((len + strlen(buf) >= PAGE_SIZE))
+		if (len + strlen(buf) >= PAGE_SIZE)
 			break;
 
 		len += sprintf(page+len, "%s", buf);
@@ -939,7 +939,7 @@ static ssize_t target_core_dev_wwn_show_attr_##_name(			\
 	ssize_t len = 0;						\
 									\
 	dev = se_dev->se_dev_ptr;					\
-	if (!(dev))							\
+	if (!dev)							\
 		return -ENODEV;						\
 									\
 	spin_lock(&t10_wwn->t10_vpd_lock);				\
@@ -949,19 +949,19 @@ static ssize_t target_core_dev_wwn_show_attr_##_name(			\
 									\
 		memset(buf, 0, VPD_TMP_BUF_SIZE);			\
 		transport_dump_vpd_assoc(vpd, buf, VPD_TMP_BUF_SIZE);	\
-		if ((len + strlen(buf) >= PAGE_SIZE))			\
+		if (len + strlen(buf) >= PAGE_SIZE)			\
 			break;						\
 		len += sprintf(page+len, "%s", buf);			\
 									\
 		memset(buf, 0, VPD_TMP_BUF_SIZE);			\
 		transport_dump_vpd_ident_type(vpd, buf, VPD_TMP_BUF_SIZE); \
-		if ((len + strlen(buf) >= PAGE_SIZE))			\
+		if (len + strlen(buf) >= PAGE_SIZE)			\
 			break;						\
 		len += sprintf(page+len, "%s", buf);			\
 									\
 		memset(buf, 0, VPD_TMP_BUF_SIZE);			\
 		transport_dump_vpd_ident(vpd, buf, VPD_TMP_BUF_SIZE); \
-		if ((len + strlen(buf) >= PAGE_SIZE))			\
+		if (len + strlen(buf) >= PAGE_SIZE)			\
 			break;						\
 		len += sprintf(page+len, "%s", buf);			\
 	}								\
@@ -1070,7 +1070,7 @@ static ssize_t target_core_dev_pr_show_spc3_res(
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_reg = dev->dev_pr_res_holder;
-	if (!(pr_reg)) {
+	if (!pr_reg) {
 		*len += sprintf(page + *len, "No SPC-3 Reservation holder\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		return *len;
@@ -1096,7 +1096,7 @@ static ssize_t target_core_dev_pr_show_spc2_res(
 
 	spin_lock(&dev->dev_reservation_lock);
 	se_nacl = dev->dev_reserved_node_acl;
-	if (!(se_nacl)) {
+	if (!se_nacl) {
 		*len += sprintf(page + *len, "No SPC-2 Reservation holder\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		return *len;
@@ -1115,7 +1115,7 @@ static ssize_t target_core_dev_pr_show_attr_res_holder(
 {
 	ssize_t len = 0;
 
-	if (!(su_dev->se_dev_ptr))
+	if (!su_dev->se_dev_ptr)
 		return -ENODEV;
 
 	switch (su_dev->t10_pr.res_type) {
@@ -1152,7 +1152,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_all_tgt_pts(
 	ssize_t len = 0;
 
 	dev = su_dev->se_dev_ptr;
-	if (!(dev))
+	if (!dev)
 		return -ENODEV;
 
 	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
@@ -1160,7 +1160,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_all_tgt_pts(
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_reg = dev->dev_pr_res_holder;
-	if (!(pr_reg)) {
+	if (!pr_reg) {
 		len = sprintf(page, "No SPC-3 Reservation holder\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		return len;
@@ -1189,7 +1189,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_generation(
 	struct se_subsystem_dev *su_dev,
 	char *page)
 {
-	if (!(su_dev->se_dev_ptr))
+	if (!su_dev->se_dev_ptr)
 		return -ENODEV;
 
 	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
@@ -1216,7 +1216,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port(
 	ssize_t len = 0;
 
 	dev = su_dev->se_dev_ptr;
-	if (!(dev))
+	if (!dev)
 		return -ENODEV;
 
 	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
@@ -1224,7 +1224,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port(
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_reg = dev->dev_pr_res_holder;
-	if (!(pr_reg)) {
+	if (!pr_reg) {
 		len = sprintf(page, "No SPC-3 Reservation holder\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		return len;
@@ -1263,7 +1263,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts(
 	ssize_t len = 0;
 	int reg_count = 0, prf_isid;
 
-	if (!(su_dev->se_dev_ptr))
+	if (!su_dev->se_dev_ptr)
 		return -ENODEV;
 
 	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
@@ -1286,7 +1286,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts(
 			&i_buf[0] : "", pr_reg->pr_res_key,
 			pr_reg->pr_res_generation);
 
-		if ((len + strlen(buf) >= PAGE_SIZE))
+		if (len + strlen(buf) >= PAGE_SIZE)
 			break;
 
 		len += sprintf(page+len, "%s", buf);
@@ -1294,7 +1294,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts(
 	}
 	spin_unlock(&su_dev->t10_pr.registration_lock);
 
-	if (!(reg_count))
+	if (!reg_count)
 		len += sprintf(page+len, "None\n");
 
 	return len;
@@ -1314,7 +1314,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_type(
 	ssize_t len = 0;
 
 	dev = su_dev->se_dev_ptr;
-	if (!(dev))
+	if (!dev)
 		return -ENODEV;
 
 	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
@@ -1322,7 +1322,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_type(
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_reg = dev->dev_pr_res_holder;
-	if (!(pr_reg)) {
+	if (!pr_reg) {
 		len = sprintf(page, "No SPC-3 Reservation holder\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		return len;
@@ -1345,7 +1345,7 @@ static ssize_t target_core_dev_pr_show_attr_res_type(
 {
 	ssize_t len = 0;
 
-	if (!(su_dev->se_dev_ptr))
+	if (!su_dev->se_dev_ptr)
 		return -ENODEV;
 
 	switch (su_dev->t10_pr.res_type) {
@@ -1376,7 +1376,7 @@ static ssize_t target_core_dev_pr_show_attr_res_aptpl_active(
 	struct se_subsystem_dev *su_dev,
 	char *page)
 {
-	if (!(su_dev->se_dev_ptr))
+	if (!su_dev->se_dev_ptr)
 		return -ENODEV;
 
 	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
@@ -1395,7 +1395,7 @@ static ssize_t target_core_dev_pr_show_attr_res_aptpl_metadata(
 	struct se_subsystem_dev *su_dev,
 	char *page)
 {
-	if (!(su_dev->se_dev_ptr))
+	if (!su_dev->se_dev_ptr)
 		return -ENODEV;
 
 	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
@@ -1447,7 +1447,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 	u8 type = 0, scope;
 
 	dev = su_dev->se_dev_ptr;
-	if (!(dev))
+	if (!dev)
 		return -ENODEV;
 
 	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
@@ -1583,7 +1583,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 		}
 	}
 
-	if (!(i_port) || !(t_port) || !(sa_res_key)) {
+	if (!i_port || !t_port || !sa_res_key) {
 		pr_err("Illegal parameters for APTPL registration\n");
 		ret = -EINVAL;
 		goto out;
@@ -1649,7 +1649,7 @@ static ssize_t target_core_show_dev_info(void *p, char *page)
 	int bl = 0;
 	ssize_t read_bytes = 0;
 
-	if (!(se_dev->se_dev_ptr))
+	if (!se_dev->se_dev_ptr)
 		return -ENODEV;
 
 	transport_dump_dev_state(se_dev->se_dev_ptr, page, &bl);
@@ -1675,7 +1675,7 @@ static ssize_t target_core_store_dev_control(
 	struct se_hba *hba = se_dev->se_dev_hba;
 	struct se_subsystem_api *t = hba->transport;
 
-	if (!(se_dev->se_dev_su_ptr)) {
+	if (!se_dev->se_dev_su_ptr) {
 		pr_err("Unable to locate struct se_subsystem_dev>se"
 				"_dev_su_ptr\n");
 		return -EINVAL;
@@ -1796,12 +1796,12 @@ static ssize_t target_core_store_dev_enable(
 	char *ptr;
 
 	ptr = strstr(page, "1");
-	if (!(ptr)) {
+	if (!ptr) {
 		pr_err("For dev_enable ops, only valid value"
 				" is \"1\"\n");
 		return -EINVAL;
 	}
-	if ((se_dev->se_dev_ptr)) {
+	if (se_dev->se_dev_ptr) {
 		pr_err("se_dev->se_dev_ptr already set for storage"
 				" object\n");
 		return -EEXIST;
@@ -1841,14 +1841,14 @@ static ssize_t target_core_show_alua_lu_gp(void *p, char *page)
 	ssize_t len = 0;
 
 	dev = su_dev->se_dev_ptr;
-	if (!(dev))
+	if (!dev)
 		return -ENODEV;
 
 	if (su_dev->t10_alua.alua_type != SPC3_ALUA_EMULATED)
 		return len;
 
 	lu_gp_mem = dev->dev_alua_lu_gp_mem;
-	if (!(lu_gp_mem)) {
+	if (!lu_gp_mem) {
 		pr_err("NULL struct se_device->dev_alua_lu_gp_mem"
 				" pointer\n");
 		return -EINVAL;
@@ -1856,7 +1856,7 @@ static ssize_t target_core_show_alua_lu_gp(void *p, char *page)
 
 	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = lu_gp_mem->lu_gp;
-	if ((lu_gp)) {
+	if (lu_gp) {
 		lu_ci = &lu_gp->lu_gp_group.cg_item;
 		len += sprintf(page, "LU Group Alias: %s\nLU Group ID: %hu\n",
 			config_item_name(lu_ci), lu_gp->lu_gp_id);
@@ -1880,7 +1880,7 @@ static ssize_t target_core_store_alua_lu_gp(
 	int move = 0;
 
 	dev = su_dev->se_dev_ptr;
-	if (!(dev))
+	if (!dev)
 		return -ENODEV;
 
 	if (su_dev->t10_alua.alua_type != SPC3_ALUA_EMULATED) {
@@ -1906,11 +1906,11 @@ static ssize_t target_core_store_alua_lu_gp(
 		 * core_alua_get_lu_gp_by_name below().
 		 */
 		lu_gp_new = core_alua_get_lu_gp_by_name(strstrip(buf));
-		if (!(lu_gp_new))
+		if (!lu_gp_new)
 			return -ENODEV;
 	}
 	lu_gp_mem = dev->dev_alua_lu_gp_mem;
-	if (!(lu_gp_mem)) {
+	if (!lu_gp_mem) {
 		if (lu_gp_new)
 			core_alua_put_lu_gp_from_name(lu_gp_new);
 		pr_err("NULL struct se_device->dev_alua_lu_gp_mem"
@@ -1920,12 +1920,12 @@ static ssize_t target_core_store_alua_lu_gp(
 
 	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = lu_gp_mem->lu_gp;
-	if ((lu_gp)) {
+	if (lu_gp) {
 		/*
 		 * Clearing an existing lu_gp association, and replacing
 		 * with NULL
 		 */
-		if (!(lu_gp_new)) {
+		if (!lu_gp_new) {
 			pr_debug("Target_Core_ConfigFS: Releasing %s/%s"
 				" from ALUA LU Group: core/alua/lu_gps/%s, ID:"
 				" %hu\n",
@@ -2026,7 +2026,7 @@ static ssize_t target_core_dev_show(struct config_item *item,
 	struct target_core_configfs_attribute *tc_attr = container_of(
 			attr, struct target_core_configfs_attribute, attr);
 
-	if (!(tc_attr->show))
+	if (!tc_attr->show)
 		return -EINVAL;
 
 	return tc_attr->show(se_dev, page);
@@ -2042,7 +2042,7 @@ static ssize_t target_core_dev_store(struct config_item *item,
 	struct target_core_configfs_attribute *tc_attr = container_of(
 			attr, struct target_core_configfs_attribute, attr);
 
-	if (!(tc_attr->store))
+	if (!tc_attr->store)
 		return -EINVAL;
 
 	return tc_attr->store(se_dev, page, count);
@@ -2085,7 +2085,7 @@ static ssize_t target_core_alua_lu_gp_show_attr_lu_gp_id(
 	struct t10_alua_lu_gp *lu_gp,
 	char *page)
 {
-	if (!(lu_gp->lu_gp_valid_id))
+	if (!lu_gp->lu_gp_valid_id)
 		return 0;
 
 	return sprintf(page, "%hu\n", lu_gp->lu_gp_id);
@@ -2292,7 +2292,7 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 	unsigned long tmp;
 	int new_state, ret;
 
-	if (!(tg_pt_gp->tg_pt_gp_valid_id)) {
+	if (!tg_pt_gp->tg_pt_gp_valid_id) {
 		pr_err("Unable to do implict ALUA on non valid"
 			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
 		return -EINVAL;
@@ -2338,7 +2338,7 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
 	unsigned long tmp;
 	int new_status, ret;
 
-	if (!(tg_pt_gp->tg_pt_gp_valid_id)) {
+	if (!tg_pt_gp->tg_pt_gp_valid_id) {
 		pr_err("Unable to do set ALUA access status on non"
 			" valid tg_pt_gp ID: %hu\n",
 			tg_pt_gp->tg_pt_gp_valid_id);
@@ -2494,7 +2494,7 @@ static ssize_t target_core_alua_tg_pt_gp_show_attr_tg_pt_gp_id(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	char *page)
 {
-	if (!(tg_pt_gp->tg_pt_gp_valid_id))
+	if (!tg_pt_gp->tg_pt_gp_valid_id)
 		return 0;
 
 	return sprintf(page, "%hu\n", tg_pt_gp->tg_pt_gp_id);
@@ -2632,7 +2632,7 @@ static struct config_group *target_core_alua_create_tg_pt_gp(
 	struct config_item *alua_tg_pt_gp_ci = NULL;
 
 	tg_pt_gp = core_alua_allocate_tg_pt_gp(su_dev, name, 0);
-	if (!(tg_pt_gp))
+	if (!tg_pt_gp)
 		return NULL;
 
 	alua_tg_pt_gp_cg = &tg_pt_gp->tg_pt_gp_group;
@@ -2770,7 +2770,7 @@ static struct config_group *target_core_make_subdev(
 
 	dev_cg->default_groups = kzalloc(sizeof(struct config_group) * 7,
 			GFP_KERNEL);
-	if (!(dev_cg->default_groups))
+	if (!dev_cg->default_groups)
 		goto out;
 	/*
 	 * Set se_dev_su_ptr from struct se_subsystem_api returned void ptr
@@ -2781,7 +2781,7 @@ static struct config_group *target_core_make_subdev(
 	 * configfs tree for device object's struct config_group.
 	 */
 	se_dev->se_dev_su_ptr = t->allocate_virtdevice(hba, name);
-	if (!(se_dev->se_dev_su_ptr)) {
+	if (!se_dev->se_dev_su_ptr) {
 		pr_err("Unable to locate subsystem dependent pointer"
 			" from allocate_virtdevice()\n");
 		goto out;
@@ -2813,13 +2813,13 @@ static struct config_group *target_core_make_subdev(
 	 * Add core/$HBA/$DEV/alua/default_tg_pt_gp
 	 */
 	tg_pt_gp = core_alua_allocate_tg_pt_gp(se_dev, "default_tg_pt_gp", 1);
-	if (!(tg_pt_gp))
+	if (!tg_pt_gp)
 		goto out;
 
 	tg_pt_gp_cg = &se_dev->t10_alua.alua_tg_pt_gps_group;
 	tg_pt_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
-	if (!(tg_pt_gp_cg->default_groups)) {
+	if (!tg_pt_gp_cg->default_groups) {
 		pr_err("Unable to allocate tg_pt_gp_cg->"
 				"default_groups\n");
 		goto out;
@@ -2980,7 +2980,7 @@ static ssize_t target_core_hba_store_attr_hba_mode(struct se_hba *hba,
 	}
 
 	spin_lock(&hba->device_lock);
-	if (!(list_empty(&hba->hba_dev_list))) {
+	if (!list_empty(&hba->hba_dev_list)) {
 		pr_err("Unable to set hba_mode with active devices\n");
 		spin_unlock(&hba->device_lock);
 		return -EINVAL;
@@ -3048,7 +3048,7 @@ static struct config_group *target_core_call_addhbatotarget(
 	snprintf(buf, TARGET_CORE_NAME_MAX_LEN, "%s", name);
 
 	str = strstr(buf, "_");
-	if (!(str)) {
+	if (!str) {
 		pr_err("Unable to locate \"_\" for $SUBSYSTEM_PLUGIN_$HOST_ID\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -3058,7 +3058,7 @@ static struct config_group *target_core_call_addhbatotarget(
 	 * Namely rd_direct and rd_mcp..
 	 */
 	str2 = strstr(str+1, "_");
-	if ((str2)) {
+	if (str2) {
 		*str2 = '\0'; /* Terminate for *se_plugin_str */
 		str2++; /* Skip to start of plugin dependent ID */
 		str = str2;
@@ -3142,7 +3142,7 @@ static int __init target_core_init_configfs(void)
 	target_cg = &subsys->su_group;
 	target_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
-	if (!(target_cg->default_groups)) {
+	if (!target_cg->default_groups) {
 		pr_err("Unable to allocate target_cg->default_groups\n");
 		goto out_global;
 	}
@@ -3157,7 +3157,7 @@ static int __init target_core_init_configfs(void)
 	hba_cg = &target_core_hbagroup;
 	hba_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
-	if (!(hba_cg->default_groups)) {
+	if (!hba_cg->default_groups) {
 		pr_err("Unable to allocate hba_cg->default_groups\n");
 		goto out_global;
 	}
@@ -3172,7 +3172,7 @@ static int __init target_core_init_configfs(void)
 	alua_cg = &alua_group;
 	alua_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 			GFP_KERNEL);
-	if (!(alua_cg->default_groups)) {
+	if (!alua_cg->default_groups) {
 		pr_err("Unable to allocate alua_cg->default_groups\n");
 		goto out_global;
 	}
@@ -3191,7 +3191,7 @@ static int __init target_core_init_configfs(void)
 	lu_gp_cg = &alua_lu_gps_group;
 	lu_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 			GFP_KERNEL);
-	if (!(lu_gp_cg->default_groups)) {
+	if (!lu_gp_cg->default_groups) {
 		pr_err("Unable to allocate lu_gp_cg->default_groups\n");
 		goto out_global;
 	}
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7350f5a..81860dd 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -255,14 +255,14 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 			continue;
 
 		lun = deve->se_lun;
-		if (!(lun)) {
+		if (!lun) {
 			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
 			continue;
 		}
 		port = lun->lun_sep;
-		if (!(port)) {
+		if (!port) {
 			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
@@ -372,7 +372,7 @@ int core_update_device_list_for_node(
 	 * struct se_dev_entry pointers below as logic in
 	 * core_alua_do_transition_tg_pt() depends on these being present.
 	 */
-	if (!(enable)) {
+	if (!enable) {
 		/*
 		 * deve->se_lun_acl will be NULL for demo-mode created LUNs
 		 * that have not been explicitly concerted to MappedLUNs ->
@@ -501,7 +501,7 @@ static struct se_port *core_alloc_port(struct se_device *dev)
 	struct se_port *port, *port_tmp;
 
 	port = kzalloc(sizeof(struct se_port), GFP_KERNEL);
-	if (!(port)) {
+	if (!port) {
 		pr_err("Unable to allocate struct se_port\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -532,7 +532,7 @@ again:
 	 * 3h to FFFFh    Relative port 3 through 65 535
 	 */
 	port->sep_rtpi = dev->dev_rpti_counter++;
-	if (!(port->sep_rtpi))
+	if (!port->sep_rtpi)
 		goto again;
 
 	list_for_each_entry(port_tmp, &dev->dev_sep_list, sep_list) {
@@ -663,7 +663,7 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 	list_for_each_entry(se_task, &se_cmd->t_task_list, t_list)
 		break;
 
-	if (!(se_task)) {
+	if (!se_task) {
 		pr_err("Unable to locate struct se_task for struct se_cmd\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -675,7 +675,7 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 	 * coming via a target_core_mod PASSTHROUGH op, and not through
 	 * a $FABRIC_MOD.  In that case, report LUN=0 only.
 	 */
-	if (!(se_sess)) {
+	if (!se_sess) {
 		int_to_scsilun(0, (struct scsi_lun *)&buf[offset]);
 		lun_count = 1;
 		goto done;
@@ -1077,7 +1077,7 @@ int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 	 * We expect this value to be non-zero when generic Block Layer
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
-	if (!(dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count)) {
+	if (!dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count) {
 		pr_err("Generic Block Discard not supported\n");
 		return -ENOSYS;
 	}
@@ -1098,7 +1098,7 @@ int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
 	 * We expect this value to be non-zero when generic Block Layer
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
-	if (!(dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count)) {
+	if (!dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count) {
 		pr_err("Generic Block Discard not supported\n");
 		return -ENOSYS;
 	}
@@ -1146,7 +1146,7 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 			atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
 	}
-	if (!(queue_depth)) {
+	if (!queue_depth) {
 		pr_err("dev[%p]: Illegal ZERO value for queue"
 			"_depth\n", dev);
 		return -EINVAL;
@@ -1193,7 +1193,7 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 			dev, atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
 	}
-	if (!(max_sectors)) {
+	if (!max_sectors) {
 		pr_err("dev[%p]: Illegal ZERO value for"
 			" max_sectors\n", dev);
 		return -EINVAL;
@@ -1213,7 +1213,7 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 			 return -EINVAL;
 		}
 	} else {
-		if (!(force) && (max_sectors >
+		if (!force && (max_sectors >
 				 dev->se_sub_dev->se_dev_attrib.hw_max_sectors)) {
 			pr_err("dev[%p]: Passed max_sectors: %u"
 				" greater than TCM/SE_Device max_sectors"
@@ -1310,7 +1310,7 @@ struct se_lun *core_dev_add_lun(
 	}
 
 	lun_p = core_tpg_pre_addlun(tpg, lun);
-	if ((IS_ERR(lun_p)) || !(lun_p))
+	if ((IS_ERR(lun_p)) || !lun_p)
 		return NULL;
 
 	if (dev->dev_flags & DF_READ_ONLY)
@@ -1357,7 +1357,7 @@ int core_dev_del_lun(
 	int ret = 0;
 
 	lun = core_tpg_pre_dellun(tpg, unpacked_lun, &ret);
-	if (!(lun))
+	if (!lun)
 		return ret;
 
 	core_tpg_post_dellun(tpg, lun);
@@ -1448,12 +1448,12 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 		return NULL;
 	}
 	nacl = core_tpg_get_initiator_node_acl(tpg, initiatorname);
-	if (!(nacl)) {
+	if (!nacl) {
 		*ret = -EINVAL;
 		return NULL;
 	}
 	lacl = kzalloc(sizeof(struct se_lun_acl), GFP_KERNEL);
-	if (!(lacl)) {
+	if (!lacl) {
 		pr_err("Unable to allocate memory for struct se_lun_acl.\n");
 		*ret = -ENOMEM;
 		return NULL;
@@ -1477,7 +1477,7 @@ int core_dev_add_initiator_node_lun_acl(
 	struct se_node_acl *nacl;
 
 	lun = core_dev_get_lun(tpg, unpacked_lun);
-	if (!(lun)) {
+	if (!lun) {
 		pr_err("%s Logical Unit Number: %u is not active on"
 			" Target Portal Group: %hu, ignoring request.\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
@@ -1486,7 +1486,7 @@ int core_dev_add_initiator_node_lun_acl(
 	}
 
 	nacl = lacl->se_lun_nacl;
-	if (!(nacl))
+	if (!nacl)
 		return -EINVAL;
 
 	if ((lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) &&
@@ -1530,7 +1530,7 @@ int core_dev_del_initiator_node_lun_acl(
 	struct se_node_acl *nacl;
 
 	nacl = lacl->se_lun_nacl;
-	if (!(nacl))
+	if (!nacl)
 		return -EINVAL;
 
 	spin_lock(&lun->lun_acl_lock);
@@ -1583,7 +1583,7 @@ int core_dev_setup_virtual_lun0(void)
 	t = hba->transport;
 
 	se_dev = kzalloc(sizeof(struct se_subsystem_dev), GFP_KERNEL);
-	if (!(se_dev)) {
+	if (!se_dev) {
 		pr_err("Unable to allocate memory for"
 				" struct se_subsystem_dev\n");
 		ret = -ENOMEM;
@@ -1606,7 +1606,7 @@ int core_dev_setup_virtual_lun0(void)
 	se_dev->se_dev_hba = hba;
 
 	se_dev->se_dev_su_ptr = t->allocate_virtdevice(hba, "virt_lun0");
-	if (!(se_dev->se_dev_su_ptr)) {
+	if (!se_dev->se_dev_su_ptr) {
 		pr_err("Unable to locate subsystem dependent pointer"
 			" from allocate_virtdevice()\n");
 		ret = -ENOMEM;
@@ -1643,7 +1643,7 @@ void core_dev_release_virtual_lun0(void)
 	struct se_hba *hba = lun0_hba;
 	struct se_subsystem_dev *su_dev = lun0_su_dev;
 
-	if (!(hba))
+	if (!hba)
 		return;
 
 	if (g_lun0_dev)
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 9b5dd49..f165469 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -80,7 +80,7 @@ static int target_fabric_mappedlun_link(
 	/*
 	 * Ensure that the source port exists
 	 */
-	if (!(lun->lun_sep) || !(lun->lun_sep->sep_tpg)) {
+	if (!lun->lun_sep || !lun->lun_sep->sep_tpg) {
 		pr_err("Source se_lun->lun_sep or lun->lun_sep->sep"
 				"_tpg does not exist\n");
 		return -EINVAL;
@@ -147,7 +147,7 @@ static int target_fabric_mappedlun_unlink(
 	/*
 	 * Determine if the underlying MappedLUN has already been released..
 	 */
-	if (!(deve->se_lun))
+	if (!deve->se_lun)
 		return 0;
 
 	lun = container_of(to_config_group(lun_ci), struct se_lun, lun_group);
@@ -327,13 +327,13 @@ static struct config_group *target_fabric_make_mappedlun(
 	int ret = 0;
 
 	acl_ci = &group->cg_item;
-	if (!(acl_ci)) {
+	if (!acl_ci) {
 		pr_err("Unable to locatel acl_ci\n");
 		return NULL;
 	}
 
 	buf = kzalloc(strlen(name) + 1, GFP_KERNEL);
-	if (!(buf)) {
+	if (!buf) {
 		pr_err("Unable to allocate memory for name buf\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -358,7 +358,7 @@ static struct config_group *target_fabric_make_mappedlun(
 
 	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, mapped_lun,
 			config_item_name(acl_ci), &ret);
-	if (!(lacl)) {
+	if (!lacl) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -474,7 +474,7 @@ static struct config_group *target_fabric_make_nodeacl(
 	struct se_node_acl *se_nacl;
 	struct config_group *nacl_cg;
 
-	if (!(tf->tf_ops.fabric_make_nodeacl)) {
+	if (!tf->tf_ops.fabric_make_nodeacl) {
 		pr_err("tf->tf_ops.fabric_make_nodeacl is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
@@ -572,13 +572,13 @@ static struct config_group *target_fabric_make_np(
 	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
 	struct se_tpg_np *se_tpg_np;
 
-	if (!(tf->tf_ops.fabric_make_np)) {
+	if (!tf->tf_ops.fabric_make_np) {
 		pr_err("tf->tf_ops.fabric_make_np is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
 	se_tpg_np = tf->tf_ops.fabric_make_np(se_tpg, group, name);
-	if (!(se_tpg_np) || IS_ERR(se_tpg_np))
+	if (!se_tpg_np || IS_ERR(se_tpg_np))
 		return ERR_PTR(-EINVAL);
 
 	se_tpg_np->tpg_np_parent = se_tpg;
@@ -627,10 +627,7 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_gp(
 	struct se_lun *lun,
 	char *page)
 {
-	if (!(lun))
-		return -ENODEV;
-
-	if (!(lun->lun_sep))
+	if (!lun || !lun->lun_sep)
 		return -ENODEV;
 
 	return core_alua_show_tg_pt_gp_info(lun->lun_sep, page);
@@ -641,10 +638,7 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_gp(
 	const char *page,
 	size_t count)
 {
-	if (!(lun))
-		return -ENODEV;
-
-	if (!(lun->lun_sep))
+	if (!lun || !lun->lun_sep)
 		return -ENODEV;
 
 	return core_alua_store_tg_pt_gp_info(lun->lun_sep, page, count);
@@ -659,10 +653,7 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_offline(
 	struct se_lun *lun,
 	char *page)
 {
-	if (!(lun))
-		return -ENODEV;
-
-	if (!(lun->lun_sep))
+	if (!lun || !lun->lun_sep)
 		return -ENODEV;
 
 	return core_alua_show_offline_bit(lun, page);
@@ -673,10 +664,7 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_offline(
 	const char *page,
 	size_t count)
 {
-	if (!(lun))
-		return -ENODEV;
-
-	if (!(lun->lun_sep))
+	if (!lun || !lun->lun_sep)
 		return -ENODEV;
 
 	return core_alua_store_offline_bit(lun, page, count);
@@ -691,10 +679,7 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_status(
 	struct se_lun *lun,
 	char *page)
 {
-	if (!(lun))
-		return -ENODEV;
-
-	if (!(lun->lun_sep))
+	if (!lun || !lun->lun_sep)
 		return -ENODEV;
 
 	return core_alua_show_secondary_status(lun, page);
@@ -705,10 +690,7 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_status(
 	const char *page,
 	size_t count)
 {
-	if (!(lun))
-		return -ENODEV;
-
-	if (!(lun->lun_sep))
+	if (!lun || !lun->lun_sep)
 		return -ENODEV;
 
 	return core_alua_store_secondary_status(lun, page, count);
@@ -723,10 +705,7 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_write_md(
 	struct se_lun *lun,
 	char *page)
 {
-	if (!(lun))
-		return -ENODEV;
-
-	if (!(lun->lun_sep))
+	if (!lun || !lun->lun_sep)
 		return -ENODEV;
 
 	return core_alua_show_secondary_write_metadata(lun, page);
@@ -737,10 +716,7 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_write_md(
 	const char *page,
 	size_t count)
 {
-	if (!(lun))
-		return -ENODEV;
-
-	if (!(lun->lun_sep))
+	if (!lun || !lun->lun_sep)
 		return -ENODEV;
 
 	return core_alua_store_secondary_write_metadata(lun, page, count);
@@ -786,7 +762,7 @@ static int target_fabric_port_link(
 	}
 
 	dev = se_dev->se_dev_ptr;
-	if (!(dev)) {
+	if (!dev) {
 		pr_err("Unable to locate struct se_device pointer from"
 			" %s\n", config_item_name(se_dev_ci));
 		ret = -ENODEV;
@@ -795,7 +771,7 @@ static int target_fabric_port_link(
 
 	lun_p = core_dev_add_lun(se_tpg, dev->se_hba, dev,
 				lun->unpacked_lun);
-	if ((IS_ERR(lun_p)) || !(lun_p)) {
+	if (IS_ERR(lun_p) || !lun_p) {
 		pr_err("core_dev_add_lun() failed\n");
 		ret = -EINVAL;
 		goto out;
@@ -896,7 +872,7 @@ static struct config_group *target_fabric_make_lun(
 		return ERR_PTR(-EINVAL);
 
 	lun = core_get_lun_from_tpg(se_tpg, unpacked_lun);
-	if (!(lun))
+	if (!lun)
 		return ERR_PTR(-EINVAL);
 
 	lun_cg = &lun->lun_group;
@@ -1031,13 +1007,13 @@ static struct config_group *target_fabric_make_tpg(
 	struct target_fabric_configfs *tf = wwn->wwn_tf;
 	struct se_portal_group *se_tpg;
 
-	if (!(tf->tf_ops.fabric_make_tpg)) {
+	if (!tf->tf_ops.fabric_make_tpg) {
 		pr_err("tf->tf_ops.fabric_make_tpg is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
 	se_tpg = tf->tf_ops.fabric_make_tpg(wwn, group, name);
-	if (!(se_tpg) || IS_ERR(se_tpg))
+	if (!se_tpg || IS_ERR(se_tpg))
 		return ERR_PTR(-EINVAL);
 	/*
 	 * Setup default groups from pre-allocated se_tpg->tpg_default_groups
@@ -1130,13 +1106,13 @@ static struct config_group *target_fabric_make_wwn(
 				struct target_fabric_configfs, tf_group);
 	struct se_wwn *wwn;
 
-	if (!(tf->tf_ops.fabric_make_wwn)) {
+	if (!tf->tf_ops.fabric_make_wwn) {
 		pr_err("tf->tf_ops.fabric_make_wwn is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
 	wwn = tf->tf_ops.fabric_make_wwn(tf, group, name);
-	if (!(wwn) || IS_ERR(wwn))
+	if (!wwn || IS_ERR(wwn))
 		return ERR_PTR(-EINVAL);
 
 	wwn->wwn_tf = tf;
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index ec40a33..a299688 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -172,7 +172,7 @@ u32 fc_get_pr_transport_id(
 	ptr = &se_nacl->initiatorname[0];
 
 	for (i = 0; i < 24; ) {
-		if (!(strncmp(&ptr[i], ":", 1))) {
+		if (!strncmp(&ptr[i], ":", 1)) {
 			i++;
 			continue;
 		}
@@ -420,7 +420,7 @@ char *iscsi_parse_pr_out_transport_id(
 	 */
 	if (format_code == 0x40) {
 		p = strstr((char *)&buf[4], ",i,0x");
-		if (!(p)) {
+		if (!p) {
 			pr_err("Unable to locate \",i,0x\" seperator"
 				" for Initiator port identifier: %s\n",
 				(char *)&buf[4]);
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index a3d72ff..60ee94e 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -53,7 +53,7 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 	struct fd_host *fd_host;
 
 	fd_host = kzalloc(sizeof(struct fd_host), GFP_KERNEL);
-	if (!(fd_host)) {
+	if (!fd_host) {
 		pr_err("Unable to allocate memory for struct fd_host\n");
 		return -ENOMEM;
 	}
@@ -89,7 +89,7 @@ static void *fd_allocate_virtdevice(struct se_hba *hba, const char *name)
 	struct fd_host *fd_host = (struct fd_host *) hba->hba_ptr;
 
 	fd_dev = kzalloc(sizeof(struct fd_dev), GFP_KERNEL);
-	if (!(fd_dev)) {
+	if (!fd_dev) {
 		pr_err("Unable to allocate memory for struct fd_dev\n");
 		return NULL;
 	}
@@ -213,7 +213,7 @@ static struct se_device *fd_create_virtdevice(
 	dev = transport_add_device_to_core_hba(hba, &fileio_template,
 				se_dev, dev_flags, fd_dev,
 				&dev_limits, "FILEIO", FD_VERSION);
-	if (!(dev))
+	if (!dev)
 		goto fail;
 
 	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
@@ -262,7 +262,7 @@ fd_alloc_task(struct se_cmd *cmd)
 	struct fd_request *fd_req;
 
 	fd_req = kzalloc(sizeof(struct fd_request), GFP_KERNEL);
-	if (!(fd_req)) {
+	if (!fd_req) {
 		pr_err("Unable to allocate struct fd_request\n");
 		return NULL;
 	}
@@ -284,7 +284,7 @@ static int fd_do_readv(struct se_task *task)
 	int ret = 0, i;
 
 	iov = kzalloc(sizeof(struct iovec) * task->task_sg_nents, GFP_KERNEL);
-	if (!(iov)) {
+	if (!iov) {
 		pr_err("Unable to allocate fd_do_readv iov[]\n");
 		return -ENOMEM;
 	}
@@ -335,7 +335,7 @@ static int fd_do_writev(struct se_task *task)
 	int ret, i = 0;
 
 	iov = kzalloc(sizeof(struct iovec) * task->task_sg_nents, GFP_KERNEL);
-	if (!(iov)) {
+	if (!iov) {
 		pr_err("Unable to allocate fd_do_writev iov[]\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 24f2b95c..0639b97 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -58,7 +58,7 @@ int transport_subsystem_register(struct se_subsystem_api *sub_api)
 
 	mutex_lock(&subsystem_mutex);
 	list_for_each_entry(s, &subsystem_list, sub_api_list) {
-		if (!(strcmp(s->name, sub_api->name))) {
+		if (!strcmp(s->name, sub_api->name)) {
 			pr_err("%p is already registered with"
 				" duplicate name %s, unable to process"
 				" request\n", s, s->name);
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 76aae71..063f5a5 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -60,7 +60,7 @@ static int iblock_attach_hba(struct se_hba *hba, u32 host_id)
 	struct iblock_hba *ib_host;
 
 	ib_host = kzalloc(sizeof(struct iblock_hba), GFP_KERNEL);
-	if (!(ib_host)) {
+	if (!ib_host) {
 		pr_err("Unable to allocate memory for"
 				" struct iblock_hba\n");
 		return -ENOMEM;
@@ -97,7 +97,7 @@ static void *iblock_allocate_virtdevice(struct se_hba *hba, const char *name)
 	struct iblock_hba *ib_host = hba->hba_ptr;
 
 	ib_dev = kzalloc(sizeof(struct iblock_dev), GFP_KERNEL);
-	if (!(ib_dev)) {
+	if (!ib_dev) {
 		pr_err("Unable to allocate struct iblock_dev\n");
 		return NULL;
 	}
@@ -122,7 +122,7 @@ static struct se_device *iblock_create_virtdevice(
 	u32 dev_flags = 0;
 	int ret = -EINVAL;
 
-	if (!(ib_dev)) {
+	if (!ib_dev) {
 		pr_err("Unable to locate struct iblock_dev parameter\n");
 		return ERR_PTR(ret);
 	}
@@ -131,7 +131,7 @@ static struct se_device *iblock_create_virtdevice(
 	 * These settings need to be made tunable..
 	 */
 	ib_dev->ibd_bio_set = bioset_create(32, 64);
-	if (!(ib_dev->ibd_bio_set)) {
+	if (!ib_dev->ibd_bio_set) {
 		pr_err("IBLOCK: Unable to create bioset()\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -166,7 +166,7 @@ static struct se_device *iblock_create_virtdevice(
 	dev = transport_add_device_to_core_hba(hba,
 			&iblock_template, se_dev, dev_flags, ib_dev,
 			&dev_limits, "IBLOCK", IBLOCK_VERSION);
-	if (!(dev))
+	if (!dev)
 		goto failed;
 
 	/*
@@ -226,7 +226,7 @@ iblock_alloc_task(struct se_cmd *cmd)
 	struct iblock_req *ib_req;
 
 	ib_req = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
-	if (!(ib_req)) {
+	if (!ib_req) {
 		pr_err("Unable to allocate memory for struct iblock_req\n");
 		return NULL;
 	}
@@ -569,7 +569,7 @@ static struct bio *iblock_get_bio(
 	struct bio *bio;
 
 	bio = bio_alloc_bioset(GFP_NOIO, sg_num, ib_dev->ibd_bio_set);
-	if (!(bio)) {
+	if (!bio) {
 		pr_err("Unable to allocate memory for bio\n");
 		*ret = PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 		return NULL;
@@ -622,7 +622,7 @@ static int iblock_map_task_SG(struct se_task *task)
 	}
 
 	bio = iblock_get_bio(task, ib_req, ib_dev, &ret, block_lba, sg_num);
-	if (!(bio))
+	if (!bio)
 		return ret;
 
 	ib_req->ib_bio = bio;
@@ -650,7 +650,7 @@ again:
 
 			bio = iblock_get_bio(task, ib_req, ib_dev, &ret,
 						block_lba, sg_num);
-			if (!(bio))
+			if (!bio)
 				goto fail;
 
 			tbio = tbio->bi_next = bio;
@@ -711,7 +711,7 @@ static void iblock_bio_done(struct bio *bio, int err)
 	/*
 	 * Set -EIO if !BIO_UPTODATE and the passed is still err=0
 	 */
-	if (!(test_bit(BIO_UPTODATE, &bio->bi_flags)) && !(err))
+	if (!test_bit(BIO_UPTODATE, &bio->bi_flags) && !err)
 		err = -EIO;
 
 	if (err != 0) {
@@ -726,7 +726,7 @@ static void iblock_bio_done(struct bio *bio, int err)
 		/*
 		 * Wait to complete the task until the last bio as completed.
 		 */
-		if (!(atomic_dec_and_test(&ibr->ib_bio_cnt)))
+		if (!atomic_dec_and_test(&ibr->ib_bio_cnt))
 			return;
 
 		ibr->ib_bio = NULL;
@@ -743,7 +743,7 @@ static void iblock_bio_done(struct bio *bio, int err)
 	/*
 	 * Wait to complete the task until the last bio as completed.
 	 */
-	if (!(atomic_dec_and_test(&ibr->ib_bio_cnt)))
+	if (!atomic_dec_and_test(&ibr->ib_bio_cnt))
 		return;
 	/*
 	 * Return GOOD status for task if zero ib_bio_err_cnt exists.
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index b14851d..1c1b849 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -62,7 +62,7 @@ int core_pr_dump_initiator_port(
 	char *buf,
 	u32 size)
 {
-	if (!(pr_reg->isid_present_at_reg))
+	if (!pr_reg->isid_present_at_reg)
 		return 0;
 
 	snprintf(buf, size, ",i,0x%s", &pr_reg->pr_reg_isid[0]);
@@ -95,7 +95,7 @@ static int core_scsi2_reservation_check(struct se_cmd *cmd, u32 *pr_reg_type)
 	struct se_session *sess = cmd->se_sess;
 	int ret;
 
-	if (!(sess))
+	if (!sess)
 		return 0;
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -123,7 +123,7 @@ static int core_scsi2_reservation_release(struct se_cmd *cmd)
 	struct se_session *sess = cmd->se_sess;
 	struct se_portal_group *tpg = sess->se_tpg;
 
-	if (!(sess) || !(tpg))
+	if (!sess || !tpg)
 		return 0;
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -167,7 +167,7 @@ static int core_scsi2_reservation_reserve(struct se_cmd *cmd)
 	 * This is currently the case for target_core_mod passthrough struct se_cmd
 	 * ops
 	 */
-	if (!(sess) || !(tpg))
+	if (!sess || !tpg)
 		return 0;
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -220,10 +220,10 @@ int core_scsi2_emulate_crh(struct se_cmd *cmd)
 	int crh = (su_dev->t10_pr.res_type == SPC3_PERSISTENT_RESERVATIONS);
 	int conflict = 0;
 
-	if (!(se_sess))
+	if (!se_sess)
 		return 0;
 
-	if (!(crh))
+	if (!crh)
 		goto after_crh;
 
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
@@ -481,7 +481,7 @@ static int core_scsi3_pr_seq_non_holder(
 	 * Case where the CDB is explicitly allowed in the above switch
 	 * statement.
 	 */
-	if (!(ret) && !(other_cdb)) {
+	if (!ret && !other_cdb) {
 #if 0
 		pr_debug("Allowing explict CDB: 0x%02x for %s"
 			" reservation holder\n", cdb[0],
@@ -515,7 +515,7 @@ static int core_scsi3_pr_seq_non_holder(
 			 * nexuses to issue CDBs.
 			 */
 #if 0
-			if (!(registered_nexus)) {
+			if (!registered_nexus) {
 				pr_debug("Allowing implict CDB: 0x%02x"
 					" for %s reservation on unregistered"
 					" nexus\n", cdb[0],
@@ -575,7 +575,7 @@ static int core_scsi3_pr_reservation_check(
 	struct se_session *sess = cmd->se_sess;
 	int ret;
 
-	if (!(sess))
+	if (!sess)
 		return 0;
 	/*
 	 * A legacy SPC-2 reservation is being held.
@@ -584,7 +584,7 @@ static int core_scsi3_pr_reservation_check(
 		return core_scsi2_reservation_check(cmd, pr_reg_type);
 
 	spin_lock(&dev->dev_reservation_lock);
-	if (!(dev->dev_pr_res_holder)) {
+	if (!dev->dev_pr_res_holder) {
 		spin_unlock(&dev->dev_reservation_lock);
 		return 0;
 	}
@@ -594,7 +594,7 @@ static int core_scsi3_pr_reservation_check(
 		spin_unlock(&dev->dev_reservation_lock);
 		return -EINVAL;
 	}
-	if (!(dev->dev_pr_res_holder->isid_present_at_reg)) {
+	if (!dev->dev_pr_res_holder->isid_present_at_reg) {
 		spin_unlock(&dev->dev_reservation_lock);
 		return 0;
 	}
@@ -624,14 +624,14 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	struct t10_pr_registration *pr_reg;
 
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_ATOMIC);
-	if (!(pr_reg)) {
+	if (!pr_reg) {
 		pr_err("Unable to allocate struct t10_pr_registration\n");
 		return NULL;
 	}
 
 	pr_reg->pr_aptpl_buf = kzalloc(su_dev->t10_pr.pr_aptpl_buf_len,
 					GFP_ATOMIC);
-	if (!(pr_reg->pr_aptpl_buf)) {
+	if (!pr_reg->pr_aptpl_buf) {
 		pr_err("Unable to allocate pr_reg->pr_aptpl_buf\n");
 		kmem_cache_free(t10_pr_reg_cache, pr_reg);
 		return NULL;
@@ -692,12 +692,12 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 */
 	pr_reg = __core_scsi3_do_alloc_registration(dev, nacl, deve, isid,
 			sa_res_key, all_tg_pt, aptpl);
-	if (!(pr_reg))
+	if (!pr_reg)
 		return NULL;
 	/*
 	 * Return pointer to pr_reg for ALL_TG_PT=0
 	 */
-	if (!(all_tg_pt))
+	if (!all_tg_pt)
 		return pr_reg;
 	/*
 	 * Create list of matching SCSI Initiator Port registrations
@@ -717,7 +717,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			 * that have not been make explict via a ConfigFS
 			 * MappedLUN group for the SCSI Initiator Node ACL.
 			 */
-			if (!(deve_tmp->se_lun_acl))
+			if (!deve_tmp->se_lun_acl)
 				continue;
 
 			nacl_tmp = deve_tmp->se_lun_acl->se_lun_nacl;
@@ -769,7 +769,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			pr_reg_atp = __core_scsi3_do_alloc_registration(dev,
 						nacl_tmp, deve_tmp, NULL,
 						sa_res_key, all_tg_pt, aptpl);
-			if (!(pr_reg_atp)) {
+			if (!pr_reg_atp) {
 				atomic_dec(&port->sep_tg_pt_ref_cnt);
 				smp_mb__after_atomic_dec();
 				atomic_dec(&deve_tmp->pr_ref_count);
@@ -817,13 +817,13 @@ int core_scsi3_alloc_aptpl_registration(
 {
 	struct t10_pr_registration *pr_reg;
 
-	if (!(i_port) || !(t_port) || !(sa_res_key)) {
+	if (!i_port || !t_port || !sa_res_key) {
 		pr_err("Illegal parameters for APTPL registration\n");
 		return -EINVAL;
 	}
 
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_KERNEL);
-	if (!(pr_reg)) {
+	if (!pr_reg) {
 		pr_err("Unable to allocate struct t10_pr_registration\n");
 		return -ENOMEM;
 	}
@@ -936,7 +936,7 @@ static int __core_scsi3_check_aptpl_registration(
 	spin_lock(&pr_tmpl->aptpl_reg_lock);
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp, &pr_tmpl->aptpl_reg_list,
 				pr_reg_aptpl_list) {
-		if (!(strcmp(pr_reg->pr_iport, i_port)) &&
+		if (!strcmp(pr_reg->pr_iport, i_port) &&
 		     (pr_reg->pr_res_mapped_lun == deve->mapped_lun) &&
 		    !(strcmp(pr_reg->pr_tport, t_port)) &&
 		     (pr_reg->pr_reg_tpgt == tpgt) &&
@@ -1062,7 +1062,7 @@ static void __core_scsi3_add_registration(
 	/*
 	 * Skip extra processing for ALL_TG_PT=0 or REGISTER_AND_MOVE.
 	 */
-	if (!(pr_reg->pr_reg_all_tg_pt) || (register_move))
+	if (!pr_reg->pr_reg_all_tg_pt || register_move)
 		return;
 	/*
 	 * Walk pr_reg->pr_reg_atp_list and add registrations for ALL_TG_PT=1
@@ -1106,7 +1106,7 @@ static int core_scsi3_alloc_registration(
 
 	pr_reg = __core_scsi3_alloc_registration(dev, nacl, deve, isid,
 			sa_res_key, all_tg_pt, aptpl);
-	if (!(pr_reg))
+	if (!pr_reg)
 		return -EPERM;
 
 	__core_scsi3_add_registration(dev, nacl, pr_reg,
@@ -1137,7 +1137,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 		 * If this registration does NOT contain a fabric provided
 		 * ISID, then we have found a match.
 		 */
-		if (!(pr_reg->isid_present_at_reg)) {
+		if (!pr_reg->isid_present_at_reg) {
 			/*
 			 * Determine if this SCSI device server requires that
 			 * SCSI Intiatior TransportID w/ ISIDs is enforced
@@ -1157,7 +1157,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 		 * SCSI Initiator Port TransportIDs, then we expect a valid
 		 * matching ISID to be provided by the local SCSI Initiator Port.
 		 */
-		if (!(isid))
+		if (!isid)
 			continue;
 		if (strcmp(isid, pr_reg->pr_reg_isid))
 			continue;
@@ -1206,7 +1206,7 @@ static int core_scsi3_check_implict_release(
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
-	if (!(pr_res_holder)) {
+	if (!pr_res_holder) {
 		spin_unlock(&dev->dev_reservation_lock);
 		return ret;
 	}
@@ -1301,7 +1301,7 @@ static void __core_scsi3_free_registration(
 		" 0x%08x\n", tfo->get_fabric_name(), pr_reg->pr_res_key,
 		pr_reg->pr_res_generation);
 
-	if (!(preempt_and_abort_list)) {
+	if (!preempt_and_abort_list) {
 		pr_reg->pr_reg_deve = NULL;
 		pr_reg->pr_reg_nacl = NULL;
 		kfree(pr_reg->pr_aptpl_buf);
@@ -1430,7 +1430,7 @@ static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
 	/*
 	 * For nacl->dynamic_node_acl=1
 	 */
-	if (!(lun_acl))
+	if (!lun_acl)
 		return 0;
 
 	nacl = lun_acl->se_lun_nacl;
@@ -1448,7 +1448,7 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 	/*
 	 * For nacl->dynamic_node_acl=1
 	 */
-	if (!(lun_acl)) {
+	if (!lun_acl) {
 		atomic_dec(&se_deve->pr_ref_count);
 		smp_mb__after_atomic_dec();
 		return;
@@ -1500,7 +1500,7 @@ static int core_scsi3_decode_spec_i_port(
 	 * processing in the loop of tid_dest_list below.
 	 */
 	tidh_new = kzalloc(sizeof(struct pr_transport_id_holder), GFP_KERNEL);
-	if (!(tidh_new)) {
+	if (!tidh_new) {
 		pr_err("Unable to allocate tidh_new\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -1512,7 +1512,7 @@ static int core_scsi3_decode_spec_i_port(
 	local_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
 				se_sess->se_node_acl, local_se_deve, l_isid,
 				sa_res_key, all_tg_pt, aptpl);
-	if (!(local_pr_reg)) {
+	if (!local_pr_reg) {
 		kfree(tidh_new);
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -1557,13 +1557,13 @@ static int core_scsi3_decode_spec_i_port(
 		spin_lock(&dev->se_port_lock);
 		list_for_each_entry(tmp_port, &dev->dev_sep_list, sep_list) {
 			tmp_tpg = tmp_port->sep_tpg;
-			if (!(tmp_tpg))
+			if (!tmp_tpg)
 				continue;
 			tmp_tf_ops = tmp_tpg->se_tpg_tfo;
-			if (!(tmp_tf_ops))
+			if (!tmp_tf_ops)
 				continue;
-			if (!(tmp_tf_ops->get_fabric_proto_ident) ||
-			    !(tmp_tf_ops->tpg_parse_pr_out_transport_id))
+			if (!tmp_tf_ops->get_fabric_proto_ident ||
+			    !tmp_tf_ops->tpg_parse_pr_out_transport_id)
 				continue;
 			/*
 			 * Look for the matching proto_ident provided by
@@ -1577,7 +1577,7 @@ static int core_scsi3_decode_spec_i_port(
 			i_str = tmp_tf_ops->tpg_parse_pr_out_transport_id(
 					tmp_tpg, (const char *)ptr, &tid_len,
 					&iport_ptr);
-			if (!(i_str))
+			if (!i_str)
 				continue;
 
 			atomic_inc(&tmp_tpg->tpg_pr_ref_count);
@@ -1607,7 +1607,7 @@ static int core_scsi3_decode_spec_i_port(
 			}
 			spin_unlock_bh(&tmp_tpg->acl_node_lock);
 
-			if (!(dest_node_acl)) {
+			if (!dest_node_acl) {
 				core_scsi3_tpg_undepend_item(tmp_tpg);
 				spin_lock(&dev->se_port_lock);
 				continue;
@@ -1635,7 +1635,7 @@ static int core_scsi3_decode_spec_i_port(
 		}
 		spin_unlock(&dev->se_port_lock);
 
-		if (!(dest_tpg)) {
+		if (!dest_tpg) {
 			pr_err("SPC-3 PR SPEC_I_PT: Unable to locate"
 					" dest_tpg\n");
 			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
@@ -1662,7 +1662,7 @@ static int core_scsi3_decode_spec_i_port(
 		 */
 		dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl,
 					dest_rtpi);
-		if (!(dest_se_deve)) {
+		if (!dest_se_deve) {
 			pr_err("Unable to locate %s dest_se_deve"
 				" from destination RTPI: %hu\n",
 				dest_tpg->se_tpg_tfo->get_fabric_name(),
@@ -1714,7 +1714,7 @@ static int core_scsi3_decode_spec_i_port(
 		 */
 		tidh_new = kzalloc(sizeof(struct pr_transport_id_holder),
 				GFP_KERNEL);
-		if (!(tidh_new)) {
+		if (!tidh_new) {
 			pr_err("Unable to allocate tidh_new\n");
 			core_scsi3_lunacl_undepend_item(dest_se_deve);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
@@ -1746,7 +1746,7 @@ static int core_scsi3_decode_spec_i_port(
 		dest_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
 				dest_node_acl, dest_se_deve, iport_ptr,
 				sa_res_key, all_tg_pt, aptpl);
-		if (!(dest_pr_reg)) {
+		if (!dest_pr_reg) {
 			core_scsi3_lunacl_undepend_item(dest_se_deve);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1951,7 +1951,7 @@ static int __core_scsi3_update_aptpl_buf(
 	}
 	spin_unlock(&su_dev->t10_pr.registration_lock);
 
-	if (!(reg_count))
+	if (!reg_count)
 		len += sprintf(buf+len, "No Registrations or Reservations");
 
 	return 0;
@@ -2007,7 +2007,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	}
 
 	iov[0].iov_base = &buf[0];
-	if (!(pr_aptpl_buf_len))
+	if (!pr_aptpl_buf_len)
 		iov[0].iov_len = (strlen(&buf[0]) + 1); /* Add extra for NULL */
 	else
 		iov[0].iov_len = pr_aptpl_buf_len;
@@ -2038,7 +2038,7 @@ static int core_scsi3_update_and_write_aptpl(
 	/*
 	 * Can be called with a NULL pointer from PROUT service action CLEAR
 	 */
-	if (!(in_buf)) {
+	if (!in_buf) {
 		memset(null_buf, 0, 64);
 		buf = &null_buf[0];
 		/*
@@ -2088,7 +2088,7 @@ static int core_scsi3_emulate_pro_register(
 	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
 	int pr_holder = 0, ret = 0, type;
 
-	if (!(se_sess) || !(se_lun)) {
+	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -2105,7 +2105,7 @@ static int core_scsi3_emulate_pro_register(
 	 * Follow logic from spc4r17 Section 5.7.7, Register Behaviors Table 47
 	 */
 	pr_reg_e = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
-	if (!(pr_reg_e)) {
+	if (!pr_reg_e) {
 		if (res_key) {
 			pr_warn("SPC-3 PR: Reservation Key non-zero"
 				" for SA REGISTER, returning CONFLICT\n");
@@ -2114,10 +2114,10 @@ static int core_scsi3_emulate_pro_register(
 		/*
 		 * Do nothing but return GOOD status.
 		 */
-		if (!(sa_res_key))
+		if (!sa_res_key)
 			return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 
-		if (!(spec_i_pt)) {
+		if (!spec_i_pt) {
 			/*
 			 * Perform the Service Action REGISTER on the Initiator
 			 * Port Endpoint that the PRO was received from on the
@@ -2149,7 +2149,7 @@ static int core_scsi3_emulate_pro_register(
 		/*
 		 * Nothing left to do for the APTPL=0 case.
 		 */
-		if (!(aptpl)) {
+		if (!aptpl) {
 			pr_tmpl->pr_aptpl_active = 0;
 			core_scsi3_update_and_write_aptpl(cmd->se_dev, NULL, 0);
 			pr_debug("SPC-3 PR: Set APTPL Bit Deactivated for"
@@ -2167,7 +2167,7 @@ static int core_scsi3_emulate_pro_register(
 		ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
-		if (!(ret)) {
+		if (!ret) {
 			pr_tmpl->pr_aptpl_active = 1;
 			pr_debug("SPC-3 PR: Set APTPL Bit Activated for REGISTER\n");
 		}
@@ -2181,7 +2181,7 @@ static int core_scsi3_emulate_pro_register(
 		pr_reg = pr_reg_e;
 		type = pr_reg->pr_res_type;
 
-		if (!(ignore_key)) {
+		if (!ignore_key) {
 			if (res_key != pr_reg->pr_res_key) {
 				pr_err("SPC-3 PR REGISTER: Received"
 					" res_key: 0x%016Lx does not match"
@@ -2215,7 +2215,7 @@ static int core_scsi3_emulate_pro_register(
 		if (aptpl) {
 			pr_aptpl_buf = kzalloc(pr_tmpl->pr_aptpl_buf_len,
 						GFP_KERNEL);
-			if (!(pr_aptpl_buf)) {
+			if (!pr_aptpl_buf) {
 				pr_err("Unable to allocate"
 					" pr_aptpl_buf\n");
 				core_scsi3_put_pr_reg(pr_reg);
@@ -2227,7 +2227,7 @@ static int core_scsi3_emulate_pro_register(
 		 * Nexus sa_res_key=1 Change Reservation Key for registered I_T
 		 * Nexus.
 		 */
-		if (!(sa_res_key)) {
+		if (!sa_res_key) {
 			pr_holder = core_scsi3_check_implict_release(
 					cmd->se_dev, pr_reg);
 			if (pr_holder < 0) {
@@ -2246,7 +2246,7 @@ static int core_scsi3_emulate_pro_register(
 						&pr_tmpl->registration_list,
 						pr_reg_list) {
 
-					if (!(pr_reg_p->pr_reg_all_tg_pt))
+					if (!pr_reg_p->pr_reg_all_tg_pt)
 						continue;
 
 					if (pr_reg_p->pr_res_key != res_key)
@@ -2295,7 +2295,7 @@ static int core_scsi3_emulate_pro_register(
 			}
 			spin_unlock(&pr_tmpl->registration_lock);
 
-			if (!(aptpl)) {
+			if (!aptpl) {
 				pr_tmpl->pr_aptpl_active = 0;
 				core_scsi3_update_and_write_aptpl(dev, NULL, 0);
 				pr_debug("SPC-3 PR: Set APTPL Bit Deactivated"
@@ -2306,7 +2306,7 @@ static int core_scsi3_emulate_pro_register(
 			ret = core_scsi3_update_and_write_aptpl(dev,
 					&pr_aptpl_buf[0],
 					pr_tmpl->pr_aptpl_buf_len);
-			if (!(ret)) {
+			if (!ret) {
 				pr_tmpl->pr_aptpl_active = 1;
 				pr_debug("SPC-3 PR: Set APTPL Bit Activated"
 						" for UNREGISTER\n");
@@ -2330,7 +2330,7 @@ static int core_scsi3_emulate_pro_register(
 				pr_reg->pr_reg_nacl->initiatorname,
 				pr_reg->pr_res_key, pr_reg->pr_res_generation);
 
-			if (!(aptpl)) {
+			if (!aptpl) {
 				pr_tmpl->pr_aptpl_active = 0;
 				core_scsi3_update_and_write_aptpl(dev, NULL, 0);
 				core_scsi3_put_pr_reg(pr_reg);
@@ -2342,7 +2342,7 @@ static int core_scsi3_emulate_pro_register(
 			ret = core_scsi3_update_and_write_aptpl(dev,
 					&pr_aptpl_buf[0],
 					pr_tmpl->pr_aptpl_buf_len);
-			if (!(ret)) {
+			if (!ret) {
 				pr_tmpl->pr_aptpl_active = 1;
 				pr_debug("SPC-3 PR: Set APTPL Bit Activated"
 						" for REGISTER\n");
@@ -2395,7 +2395,7 @@ static int core_scsi3_pro_reserve(
 
 	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 
-	if (!(se_sess) || !(se_lun)) {
+	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -2406,7 +2406,7 @@ static int core_scsi3_pro_reserve(
 	 */
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
-	if (!(pr_reg)) {
+	if (!pr_reg) {
 		pr_err("SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for RESERVE\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
@@ -2536,7 +2536,7 @@ static int core_scsi3_pro_reserve(
 		ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
-		if (!(ret))
+		if (!ret)
 			pr_debug("SPC-3 PR: Updated APTPL metadata"
 					" for RESERVE\n");
 	}
@@ -2620,7 +2620,7 @@ static int core_scsi3_emulate_pro_release(
 	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	int ret, all_reg = 0;
 
-	if (!(se_sess) || !(se_lun)) {
+	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -2628,7 +2628,7 @@ static int core_scsi3_emulate_pro_release(
 	 * Locate the existing *pr_reg via struct se_node_acl pointers
 	 */
 	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
-	if (!(pr_reg)) {
+	if (!pr_reg) {
 		pr_err("SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for RELEASE\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
@@ -2647,7 +2647,7 @@ static int core_scsi3_emulate_pro_release(
 	 */
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
-	if (!(pr_res_holder)) {
+	if (!pr_res_holder) {
 		/*
 		 * No persistent reservation, return GOOD status.
 		 */
@@ -2767,7 +2767,7 @@ write_aptpl:
 		ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
-		if (!(ret))
+		if (!ret)
 			pr_debug("SPC-3 PR: Updated APTPL metadata for RELEASE\n");
 	}
 
@@ -2791,7 +2791,7 @@ static int core_scsi3_emulate_pro_clear(
 	 */
 	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev,
 			se_sess->se_node_acl, se_sess);
-	if (!(pr_reg_n)) {
+	if (!pr_reg_n) {
 		pr_err("SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for CLEAR\n");
 			return PYX_TRANSPORT_LU_COMM_FAILURE;
@@ -2845,7 +2845,7 @@ static int core_scsi3_emulate_pro_clear(
 		 *    command with CLEAR service action was received, with the
 		 *    additional sense code set to RESERVATIONS PREEMPTED.
 		 */
-		if (!(calling_it_nexus))
+		if (!calling_it_nexus)
 			core_scsi3_ua_allocate(pr_reg_nacl, pr_res_mapped_lun,
 				0x2A, ASCQ_2AH_RESERVATIONS_PREEMPTED);
 	}
@@ -2971,13 +2971,13 @@ static int core_scsi3_pro_preempt(
 	int all_reg = 0, calling_it_nexus = 0, released_regs = 0;
 	int prh_type = 0, prh_scope = 0, ret;
 
-	if (!(se_sess))
+	if (!se_sess)
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
-	if (!(pr_reg_n)) {
+	if (!pr_reg_n) {
 		pr_err("SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for PREEMPT%s\n",
 			(abort) ? "_AND_ABORT" : "");
@@ -3001,7 +3001,7 @@ static int core_scsi3_pro_preempt(
 	    (pr_res_holder->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)))
 		all_reg = 1;
 
-	if (!(all_reg) && !(sa_res_key)) {
+	if (!all_reg && !sa_res_key) {
 		spin_unlock(&dev->dev_reservation_lock);
 		core_scsi3_put_pr_reg(pr_reg_n);
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
@@ -3015,7 +3015,7 @@ static int core_scsi3_pro_preempt(
 	 * server shall perform a preempt by doing the following in an
 	 * uninterrupted series of actions. (See below..)
 	 */
-	if (!(pr_res_holder) || (pr_res_holder->pr_res_key != sa_res_key)) {
+	if (!pr_res_holder || (pr_res_holder->pr_res_key != sa_res_key)) {
 		/*
 		 * No existing or SA Reservation Key matching reservations..
 		 *
@@ -3042,7 +3042,7 @@ static int core_scsi3_pro_preempt(
 			 *    was received, with the additional sense code set
 			 *    to REGISTRATIONS PREEMPTED.
 			 */
-			if (!(all_reg)) {
+			if (!all_reg) {
 				if (pr_reg->pr_res_key != sa_res_key)
 					continue;
 
@@ -3082,7 +3082,7 @@ static int core_scsi3_pro_preempt(
 						NULL, 0);
 				released_regs++;
 			}
-			if (!(calling_it_nexus))
+			if (!calling_it_nexus)
 				core_scsi3_ua_allocate(pr_reg_nacl,
 					pr_res_mapped_lun, 0x2A,
 					ASCQ_2AH_RESERVATIONS_PREEMPTED);
@@ -3095,7 +3095,7 @@ static int core_scsi3_pro_preempt(
 		 * registered reservation key, then the device server shall
 		 * complete the command with RESERVATION CONFLICT status.
 		 */
-		if (!(released_regs)) {
+		if (!released_regs) {
 			spin_unlock(&dev->dev_reservation_lock);
 			core_scsi3_put_pr_reg(pr_reg_n);
 			return PYX_TRANSPORT_RESERVATION_CONFLICT;
@@ -3120,7 +3120,7 @@ static int core_scsi3_pro_preempt(
 			ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 					&pr_reg_n->pr_aptpl_buf[0],
 					pr_tmpl->pr_aptpl_buf_len);
-			if (!(ret))
+			if (!ret)
 				pr_debug("SPC-3 PR: Updated APTPL"
 					" metadata for  PREEMPT%s\n", (abort) ?
 					"_AND_ABORT" : "");
@@ -3256,7 +3256,7 @@ static int core_scsi3_pro_preempt(
 		ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 				&pr_reg_n->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
-		if (!(ret))
+		if (!ret)
 			pr_debug("SPC-3 PR: Updated APTPL metadata for PREEMPT"
 				"%s\n", (abort) ? "_AND_ABORT" : "");
 	}
@@ -3321,7 +3321,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	unsigned short rtpi;
 	unsigned char proto_ident;
 
-	if (!(se_sess) || !(se_lun)) {
+	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -3338,7 +3338,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	 */
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
-	if (!(pr_reg)) {
+	if (!pr_reg) {
 		pr_err("SPC-3 PR: Unable to locate PR_REGISTERED"
 			" *pr_reg for REGISTER_AND_MOVE\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
@@ -3357,7 +3357,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	/*
 	 * The service active reservation key needs to be non zero
 	 */
-	if (!(sa_res_key)) {
+	if (!sa_res_key) {
 		pr_warn("SPC-3 PR REGISTER_AND_MOVE: Received zero"
 			" sa_res_key\n");
 		core_scsi3_put_pr_reg(pr_reg);
@@ -3392,10 +3392,10 @@ static int core_scsi3_emulate_pro_register_and_move(
 		if (se_port->sep_rtpi != rtpi)
 			continue;
 		dest_se_tpg = se_port->sep_tpg;
-		if (!(dest_se_tpg))
+		if (!dest_se_tpg)
 			continue;
 		dest_tf_ops = dest_se_tpg->se_tpg_tfo;
-		if (!(dest_tf_ops))
+		if (!dest_tf_ops)
 			continue;
 
 		atomic_inc(&dest_se_tpg->tpg_pr_ref_count);
@@ -3417,7 +3417,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	}
 	spin_unlock(&dev->se_port_lock);
 
-	if (!(dest_se_tpg) || (!dest_tf_ops)) {
+	if (!dest_se_tpg || !dest_tf_ops) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
 			" fabric ops from Relative Target Port Identifier:"
 			" %hu\n", rtpi);
@@ -3449,7 +3449,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	}
 	initiator_str = dest_tf_ops->tpg_parse_pr_out_transport_id(dest_se_tpg,
 			(const char *)&buf[24], &tmp_tid_len, &iport_ptr);
-	if (!(initiator_str)) {
+	if (!initiator_str) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
 			" initiator_str from Transport ID\n");
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
@@ -3474,17 +3474,17 @@ static int core_scsi3_emulate_pro_register_and_move(
 	pr_reg_nacl = pr_reg->pr_reg_nacl;
 	matching_iname = (!strcmp(initiator_str,
 				  pr_reg_nacl->initiatorname)) ? 1 : 0;
-	if (!(matching_iname))
+	if (!matching_iname)
 		goto after_iport_check;
 
-	if (!(iport_ptr) || !(pr_reg->isid_present_at_reg)) {
+	if (!iport_ptr || !pr_reg->isid_present_at_reg) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s"
 			" matches: %s on received I_T Nexus\n", initiator_str,
 			pr_reg_nacl->initiatorname);
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		goto out;
 	}
-	if (!(strcmp(iport_ptr, pr_reg->pr_reg_isid))) {
+	if (!strcmp(iport_ptr, pr_reg->pr_reg_isid)) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s %s"
 			" matches: %s %s on received I_T Nexus\n",
 			initiator_str, iport_ptr, pr_reg_nacl->initiatorname,
@@ -3505,7 +3505,7 @@ after_iport_check:
 	}
 	spin_unlock_bh(&dest_se_tpg->acl_node_lock);
 
-	if (!(dest_node_acl)) {
+	if (!dest_node_acl) {
 		pr_err("Unable to locate %s dest_node_acl for"
 			" TransportID%s\n", dest_tf_ops->get_fabric_name(),
 			initiator_str);
@@ -3532,7 +3532,7 @@ after_iport_check:
 	 * PORT IDENTIFIER.
 	 */
 	dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl, rtpi);
-	if (!(dest_se_deve)) {
+	if (!dest_se_deve) {
 		pr_err("Unable to locate %s dest_se_deve from RTPI:"
 			" %hu\n",  dest_tf_ops->get_fabric_name(), rtpi);
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
@@ -3560,7 +3560,7 @@ after_iport_check:
 	 */
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
-	if (!(pr_res_holder)) {
+	if (!pr_res_holder) {
 		pr_warn("SPC-3 PR REGISTER_AND_MOVE: No reservation"
 			" currently held\n");
 		spin_unlock(&dev->dev_reservation_lock);
@@ -3626,7 +3626,7 @@ after_iport_check:
 	 */
 	dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
 					iport_ptr);
-	if (!(dest_pr_reg)) {
+	if (!dest_pr_reg) {
 		ret = core_scsi3_alloc_registration(cmd->se_dev,
 				dest_node_acl, dest_se_deve, iport_ptr,
 				sa_res_key, 0, aptpl, 2, 1);
@@ -3659,7 +3659,7 @@ after_iport_check:
 	/*
 	 * Increment PRGeneration for existing registrations..
 	 */
-	if (!(new_reg))
+	if (!new_reg)
 		dest_pr_reg->pr_res_generation = pr_tmpl->pr_generation++;
 	spin_unlock(&dev->dev_reservation_lock);
 
@@ -3696,7 +3696,7 @@ after_iport_check:
 	 * Clear the APTPL metadata if APTPL has been disabled, otherwise
 	 * write out the updated metadata to struct file for this SCSI device.
 	 */
-	if (!(aptpl)) {
+	if (!aptpl) {
 		pr_tmpl->pr_aptpl_active = 0;
 		core_scsi3_update_and_write_aptpl(cmd->se_dev, NULL, 0);
 		pr_debug("SPC-3 PR: Set APTPL Bit Deactivated for"
@@ -3706,7 +3706,7 @@ after_iport_check:
 		ret = core_scsi3_update_and_write_aptpl(cmd->se_dev,
 				&dest_pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
-		if (!(ret))
+		if (!ret)
 			pr_debug("SPC-3 PR: Set APTPL Bit Activated for"
 					" REGISTER_AND_MOVE\n");
 	}
@@ -3750,7 +3750,7 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 	 * FIXME: A NULL struct se_session pointer means an this is not coming from
 	 * a $FABRIC_MOD's nexus, but from internal passthrough ops.
 	 */
-	if (!(cmd->se_sess))
+	if (!cmd->se_sess)
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 
 	if (cmd->data_length < 24) {
@@ -3800,7 +3800,7 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 	 * the sense key set to ILLEGAL REQUEST, and the additional sense
 	 * code set to PARAMETER LIST LENGTH ERROR.
 	 */
-	if (!(spec_i_pt) && ((cdb[1] & 0x1f) != PRO_REGISTER_AND_MOVE) &&
+	if (!spec_i_pt && ((cdb[1] & 0x1f) != PRO_REGISTER_AND_MOVE) &&
 	    (cmd->data_length != 24)) {
 		pr_warn("SPC-PR: Received PR OUT illegal parameter"
 			" list length: %u\n", cmd->data_length);
@@ -4141,7 +4141,7 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		 * bit is set to one, the contents of the RELATIVE TARGET PORT
 		 * IDENTIFIER field are not defined by this standard.
 		 */
-		if (!(pr_reg->pr_reg_all_tg_pt)) {
+		if (!pr_reg->pr_reg_all_tg_pt) {
 			struct se_port *port = pr_reg->pr_reg_tg_pt_lun->lun_sep;
 
 			buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 04db999..ebc83ca 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -65,7 +65,7 @@ static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 	struct pscsi_hba_virt *phv;
 
 	phv = kzalloc(sizeof(struct pscsi_hba_virt), GFP_KERNEL);
-	if (!(phv)) {
+	if (!phv) {
 		pr_err("Unable to allocate struct pscsi_hba_virt\n");
 		return -ENOMEM;
 	}
@@ -110,8 +110,8 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 	/*
 	 * Release the struct Scsi_Host
 	 */
-	if (!(mode_flag)) {
-		if (!(sh))
+	if (!mode_flag) {
+		if (!sh)
 			return 0;
 
 		phv->phv_lld_host = NULL;
@@ -355,7 +355,7 @@ static struct se_device *pscsi_add_device_to_list(
 	dev = transport_add_device_to_core_hba(hba, &pscsi_template,
 				se_dev, dev_flags, pdv,
 				&dev_limits, NULL, NULL);
-	if (!(dev)) {
+	if (!dev) {
 		pdv->pdv_sd = NULL;
 		return NULL;
 	}
@@ -385,7 +385,7 @@ static void *pscsi_allocate_virtdevice(struct se_hba *hba, const char *name)
 	struct pscsi_dev_virt *pdv;
 
 	pdv = kzalloc(sizeof(struct pscsi_dev_virt), GFP_KERNEL);
-	if (!(pdv)) {
+	if (!pdv) {
 		pr_err("Unable to allocate memory for struct pscsi_dev_virt\n");
 		return NULL;
 	}
@@ -432,7 +432,7 @@ static struct se_device *pscsi_create_type_disk(
 	pdv->pdv_bd = bd;
 
 	dev = pscsi_add_device_to_list(hba, se_dev, pdv, sd, dev_flags);
-	if (!(dev)) {
+	if (!dev) {
 		blkdev_put(pdv->pdv_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
 		scsi_device_put(sd);
 		return NULL;
@@ -467,7 +467,7 @@ static struct se_device *pscsi_create_type_rom(
 	spin_unlock_irq(sh->host_lock);
 
 	dev = pscsi_add_device_to_list(hba, se_dev, pdv, sd, dev_flags);
-	if (!(dev)) {
+	if (!dev) {
 		scsi_device_put(sd);
 		return NULL;
 	}
@@ -495,7 +495,7 @@ static struct se_device *pscsi_create_type_other(
 
 	spin_unlock_irq(sh->host_lock);
 	dev = pscsi_add_device_to_list(hba, se_dev, pdv, sd, dev_flags);
-	if (!(dev))
+	if (!dev)
 		return NULL;
 
 	pr_debug("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%d\n",
@@ -517,7 +517,7 @@ static struct se_device *pscsi_create_virtdevice(
 	struct Scsi_Host *sh = phv->phv_lld_host;
 	int legacy_mode_enable = 0;
 
-	if (!(pdv)) {
+	if (!pdv) {
 		pr_err("Unable to locate struct pscsi_dev_virt"
 				" parameter\n");
 		return ERR_PTR(-EINVAL);
@@ -526,7 +526,7 @@ static struct se_device *pscsi_create_virtdevice(
 	 * If not running in PHV_LLD_SCSI_HOST_NO mode, locate the
 	 * struct Scsi_Host we will need to bring the TCM/pSCSI object online
 	 */
-	if (!(sh)) {
+	if (!sh) {
 		if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
 			pr_err("pSCSI: Unable to locate struct"
 				" Scsi_Host for PHV_LLD_SCSI_HOST_NO\n");
@@ -548,7 +548,7 @@ static struct se_device *pscsi_create_virtdevice(
 		 */
 		if (!(pdv->pdv_flags & PDF_HAS_VIRT_HOST_ID)) {
 			spin_lock(&hba->device_lock);
-			if (!(list_empty(&hba->hba_dev_list))) {
+			if (!list_empty(&hba->hba_dev_list)) {
 				pr_err("pSCSI: Unable to set hba_mode"
 					" with active devices\n");
 				spin_unlock(&hba->device_lock);
@@ -601,7 +601,7 @@ static struct se_device *pscsi_create_virtdevice(
 			break;
 		}
 
-		if (!(dev)) {
+		if (!dev) {
 			if (phv->phv_mode == PHV_VIRUTAL_HOST_ID)
 				scsi_host_put(sh);
 			else if (legacy_mode_enable) {
@@ -729,7 +729,7 @@ after_mode_sense:
 		u32 blocksize;
 
 		buf = sg_virt(&sg[0]);
-		if (!(buf)) {
+		if (!buf) {
 			pr_err("Unable to get buf for scatterlist\n");
 			goto after_mode_select;
 		}
@@ -779,7 +779,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
 	if (cmd->t_task_cdb != cmd->__t_task_cdb) {
 
 		pt->pscsi_cdb = kzalloc(scsi_command_size(cdb), GFP_KERNEL);
-		if (!(pt->pscsi_cdb)) {
+		if (!pt->pscsi_cdb) {
 			pr_err("pSCSI: Unable to allocate extended"
 					" pt->pscsi_cdb\n");
 			kfree(pt);
@@ -837,7 +837,7 @@ static int pscsi_blk_get_request(struct se_task *task)
 	pt->pscsi_req = blk_get_request(pdv->pdv_sd->request_queue,
 			(task->task_data_direction == DMA_TO_DEVICE),
 			GFP_KERNEL);
-	if (!(pt->pscsi_req) || IS_ERR(pt->pscsi_req)) {
+	if (!pt->pscsi_req || IS_ERR(pt->pscsi_req)) {
 		pr_err("PSCSI: blk_get_request() failed: %ld\n",
 				IS_ERR(pt->pscsi_req));
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
@@ -1061,7 +1061,7 @@ static inline struct bio *pscsi_get_bio(int sg_num)
 	 * in block/blk-core.c:blk_make_request()
 	 */
 	bio = bio_kmalloc(GFP_KERNEL, sg_num);
-	if (!(bio)) {
+	if (!bio) {
 		pr_err("PSCSI: bio_kmalloc() failed\n");
 		return NULL;
 	}
@@ -1114,14 +1114,14 @@ static int __pscsi_map_task_SG(
 			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
 			bytes = min(bytes, data_len);
 
-			if (!(bio)) {
+			if (!bio) {
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
 				nr_pages -= nr_vecs;
 				/*
 				 * Calls bio_kmalloc() and sets bio->bi_end_io()
 				 */
 				bio = pscsi_get_bio(nr_vecs);
-				if (!(bio))
+				if (!bio)
 					goto fail;
 
 				if (rw)
@@ -1177,14 +1177,14 @@ static int __pscsi_map_task_SG(
 	 * Setup the primary pt->pscsi_req used for non BIDI and BIDI-COMMAND
 	 * primary SCSI WRITE poayload mapped for struct se_task->task_sg[]
 	 */
-	if (!(bidi_read)) {
+	if (!bidi_read) {
 		/*
 		 * Starting with v2.6.31, call blk_make_request() passing in *hbio to
 		 * allocate the pSCSI task a struct request.
 		 */
 		pt->pscsi_req = blk_make_request(pdv->pdv_sd->request_queue,
 					hbio, GFP_KERNEL);
-		if (!(pt->pscsi_req)) {
+		if (!pt->pscsi_req) {
 			pr_err("pSCSI: blk_make_request() failed\n");
 			goto fail;
 		}
@@ -1202,7 +1202,7 @@ static int __pscsi_map_task_SG(
 	 */
 	pt->pscsi_req->next_rq = blk_make_request(pdv->pdv_sd->request_queue,
 					hbio, GFP_KERNEL);
-	if (!(pt->pscsi_req->next_rq)) {
+	if (!pt->pscsi_req->next_rq) {
 		pr_err("pSCSI: blk_make_request() failed for BIDI\n");
 		goto fail;
 	}
@@ -1313,7 +1313,7 @@ static inline void pscsi_process_SAM_status(
 	struct pscsi_plugin_task *pt)
 {
 	task->task_scsi_status = status_byte(pt->pscsi_result);
-	if ((task->task_scsi_status)) {
+	if (task->task_scsi_status) {
 		task->task_scsi_status <<= 1;
 		pr_debug("PSCSI Status Byte exception at task: %p CDB:"
 			" 0x%02x Result: 0x%08x\n", task, pt->pscsi_cdb[0],
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index d9be7b4..5778bed 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -55,7 +55,7 @@ static int rd_attach_hba(struct se_hba *hba, u32 host_id)
 	struct rd_host *rd_host;
 
 	rd_host = kzalloc(sizeof(struct rd_host), GFP_KERNEL);
-	if (!(rd_host)) {
+	if (!rd_host) {
 		pr_err("Unable to allocate memory for struct rd_host\n");
 		return -ENOMEM;
 	}
@@ -107,7 +107,7 @@ static void rd_release_device_space(struct rd_dev *rd_dev)
 
 		for (j = 0; j < sg_per_table; j++) {
 			pg = sg_page(&sg[j]);
-			if ((pg)) {
+			if (pg) {
 				__free_page(pg);
 				page_count++;
 			}
@@ -150,7 +150,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
 
 	sg_table = kzalloc(sg_tables * sizeof(struct rd_dev_sg_table), GFP_KERNEL);
-	if (!(sg_table)) {
+	if (!sg_table) {
 		pr_err("Unable to allocate memory for Ramdisk"
 			" scatterlist tables\n");
 		return -ENOMEM;
@@ -165,7 +165,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 
 		sg = kzalloc(sg_per_table * sizeof(struct scatterlist),
 				GFP_KERNEL);
-		if (!(sg)) {
+		if (!sg) {
 			pr_err("Unable to allocate scatterlist array"
 				" for struct rd_dev\n");
 			return -ENOMEM;
@@ -181,7 +181,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 
 		for (j = 0; j < sg_per_table; j++) {
 			pg = alloc_pages(GFP_KERNEL, 0);
-			if (!(pg)) {
+			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
 				return -ENOMEM;
@@ -211,7 +211,7 @@ static void *rd_allocate_virtdevice(
 	struct rd_host *rd_host = hba->hba_ptr;
 
 	rd_dev = kzalloc(sizeof(struct rd_dev), GFP_KERNEL);
-	if (!(rd_dev)) {
+	if (!rd_dev) {
 		pr_err("Unable to allocate memory for struct rd_dev\n");
 		return NULL;
 	}
@@ -263,7 +263,7 @@ static struct se_device *rd_create_virtdevice(
 	dev = transport_add_device_to_core_hba(hba,
 			&rd_mcp_template, se_dev, dev_flags, rd_dev,
 			&dev_limits, prod, rev);
-	if (!(dev))
+	if (!dev)
 		goto fail;
 
 	rd_dev->rd_dev_id = rd_host->rd_host_dev_id_count++;
@@ -361,7 +361,7 @@ static int rd_MEMCPY_read(struct rd_request *req)
 	u32 rd_offset = req->rd_offset;
 
 	table = rd_get_sg_table(dev, req->rd_page);
-	if (!(table))
+	if (!table)
 		return -EINVAL;
 
 	table_sg_end = (table->page_end_offset - req->rd_page);
@@ -440,7 +440,7 @@ static int rd_MEMCPY_read(struct rd_request *req)
 			(req->rd_size - length), length, i, j);
 
 		req->rd_size -= length;
-		if (!(req->rd_size))
+		if (!req->rd_size)
 			return 0;
 
 		if (!page_end)
@@ -456,7 +456,7 @@ static int rd_MEMCPY_read(struct rd_request *req)
 				req->rd_page);
 
 		table = rd_get_sg_table(dev, req->rd_page);
-		if (!(table))
+		if (!table)
 			return -EINVAL;
 
 		sg_s = &table->sg_table[j = 0];
@@ -481,7 +481,7 @@ static int rd_MEMCPY_write(struct rd_request *req)
 	u32 rd_offset = req->rd_offset;
 
 	table = rd_get_sg_table(dev, req->rd_page);
-	if (!(table))
+	if (!table)
 		return -EINVAL;
 
 	table_sg_end = (table->page_end_offset - req->rd_page);
@@ -560,7 +560,7 @@ static int rd_MEMCPY_write(struct rd_request *req)
 			(req->rd_size - length), length, i, j);
 
 		req->rd_size -= length;
-		if (!(req->rd_size))
+		if (!req->rd_size)
 			return 0;
 
 		if (!page_end)
@@ -576,7 +576,7 @@ static int rd_MEMCPY_write(struct rd_request *req)
 				req->rd_page);
 
 		table = rd_get_sg_table(dev, req->rd_page);
-		if (!(table))
+		if (!table)
 			return -EINVAL;
 
 		sg_d = &table->sg_table[j = 0];
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 8b87ea6..27d4925 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -50,7 +50,7 @@ struct se_tmr_req *core_tmr_alloc_req(
 
 	tmr = kmem_cache_zalloc(se_tmr_req_cache, (in_interrupt()) ?
 					GFP_ATOMIC : GFP_KERNEL);
-	if (!(tmr)) {
+	if (!tmr) {
 		pr_err("Unable to allocate struct se_tmr_req\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -86,14 +86,14 @@ static void core_tmr_handle_tas_abort(
 	int tas,
 	int fe_count)
 {
-	if (!(fe_count)) {
+	if (!fe_count) {
 		transport_cmd_finish_abort(cmd, 1);
 		return;
 	}
 	/*
 	 * TASK ABORTED status (TAS) bit support
 	*/
-	if (((tmr_nacl != NULL) &&
+	if ((tmr_nacl &&
 	     (tmr_nacl == cmd->se_sess->se_node_acl)) || tas)
 		transport_send_task_abort(cmd);
 
@@ -156,7 +156,7 @@ int core_tmr_lun_reset(
 			continue;
 
 		cmd = tmr_p->task_cmd;
-		if (!(cmd)) {
+		if (!cmd) {
 			pr_err("Unable to locate struct se_cmd for TMR\n");
 			continue;
 		}
@@ -165,14 +165,14 @@ int core_tmr_lun_reset(
 		 * parameter (eg: for PROUT PREEMPT_AND_ABORT service action
 		 * skip non regisration key matching TMRs.
 		 */
-		if ((preempt_and_abort_list != NULL) &&
+		if (preempt_and_abort_list &&
 		    (core_scsi3_check_cdb_abort_and_preempt(
 					preempt_and_abort_list, cmd) != 0))
 			continue;
 		spin_unlock_irq(&dev->se_tmr_lock);
 
 		spin_lock_irqsave(&cmd->t_state_lock, flags);
-		if (!(atomic_read(&cmd->t_transport_active))) {
+		if (!atomic_read(&cmd->t_transport_active)) {
 			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 			spin_lock_irq(&dev->se_tmr_lock);
 			continue;
@@ -226,7 +226,7 @@ int core_tmr_lun_reset(
 		 * For PREEMPT_AND_ABORT usage, only process commands
 		 * with a matching reservation key.
 		 */
-		if ((preempt_and_abort_list != NULL) &&
+		if (preempt_and_abort_list &&
 		    (core_scsi3_check_cdb_abort_and_preempt(
 					preempt_and_abort_list, cmd) != 0))
 			continue;
@@ -281,7 +281,7 @@ int core_tmr_lun_reset(
 		}
 		__transport_stop_task_timer(task, &flags);
 
-		if (!(atomic_dec_and_test(&cmd->t_task_cdbs_ex_left))) {
+		if (!atomic_dec_and_test(&cmd->t_task_cdbs_ex_left)) {
 			spin_unlock_irqrestore(
 					&cmd->t_state_lock, flags);
 			pr_debug("LUN_RESET: Skipping task: %p, dev: %p for"
@@ -328,7 +328,7 @@ int core_tmr_lun_reset(
 		 * For PREEMPT_AND_ABORT usage, only process commands
 		 * with a matching reservation key.
 		 */
-		if ((preempt_and_abort_list != NULL) &&
+		if (preempt_and_abort_list &&
 		    (core_scsi3_check_cdb_abort_and_preempt(
 					preempt_and_abort_list, cmd) != 0))
 			continue;
@@ -361,7 +361,7 @@ int core_tmr_lun_reset(
 	 * Clear any legacy SPC-2 reservation when called during
 	 * LOGICAL UNIT RESET
 	 */
-	if (!(preempt_and_abort_list) &&
+	if (!preempt_and_abort_list &&
 	     (dev->dev_flags & DF_SPC2_RESERVATIONS)) {
 		spin_lock(&dev->dev_reservation_lock);
 		dev->dev_reserved_node_acl = NULL;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d2b0a67..4f1ba4c 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -86,9 +86,8 @@ static void core_clear_initiator_node_from_tpg(
 		spin_lock(&lun->lun_acl_lock);
 		list_for_each_entry_safe(acl, acl_tmp,
 					&lun->lun_acl_list, lacl_list) {
-			if (!(strcmp(acl->initiatorname,
-					nacl->initiatorname)) &&
-			     (acl->mapped_lun == deve->mapped_lun))
+			if (!strcmp(acl->initiatorname, nacl->initiatorname) &&
+			    (acl->mapped_lun == deve->mapped_lun))
 				break;
 		}
 
@@ -121,7 +120,7 @@ struct se_node_acl *__core_tpg_get_initiator_node_acl(
 	struct se_node_acl *acl;
 
 	list_for_each_entry(acl, &tpg->acl_node_list, acl_list) {
-		if (!(strcmp(acl->initiatorname, initiatorname)))
+		if (!strcmp(acl->initiatorname, initiatorname))
 			return acl;
 	}
 
@@ -140,8 +139,8 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
 
 	spin_lock_bh(&tpg->acl_node_lock);
 	list_for_each_entry(acl, &tpg->acl_node_list, acl_list) {
-		if (!(strcmp(acl->initiatorname, initiatorname)) &&
-		   (!(acl->dynamic_node_acl))) {
+		if (!strcmp(acl->initiatorname, initiatorname) &&
+		    !acl->dynamic_node_acl) {
 			spin_unlock_bh(&tpg->acl_node_lock);
 			return acl;
 		}
@@ -177,7 +176,7 @@ void core_tpg_add_node_to_devs(
 		 * By default in LIO-Target $FABRIC_MOD,
 		 * demo_mode_write_protect is ON, or READ_ONLY;
 		 */
-		if (!(tpg->se_tpg_tfo->tpg_check_demo_mode_write_protect(tpg))) {
+		if (!tpg->se_tpg_tfo->tpg_check_demo_mode_write_protect(tpg)) {
 			if (dev->dev_flags & DF_READ_ONLY)
 				lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
 			else
@@ -236,7 +235,7 @@ static int core_create_device_list_for_node(struct se_node_acl *nacl)
 
 	nacl->device_list = kzalloc(sizeof(struct se_dev_entry) *
 				TRANSPORT_MAX_LUNS_PER_TPG, GFP_KERNEL);
-	if (!(nacl->device_list)) {
+	if (!nacl->device_list) {
 		pr_err("Unable to allocate memory for"
 			" struct se_node_acl->device_list\n");
 		return -ENOMEM;
@@ -265,14 +264,14 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	struct se_node_acl *acl;
 
 	acl = core_tpg_get_initiator_node_acl(tpg, initiatorname);
-	if ((acl))
+	if (acl)
 		return acl;
 
-	if (!(tpg->se_tpg_tfo->tpg_check_demo_mode(tpg)))
+	if (!tpg->se_tpg_tfo->tpg_check_demo_mode(tpg))
 		return NULL;
 
 	acl =  tpg->se_tpg_tfo->tpg_alloc_fabric_acl(tpg);
-	if (!(acl))
+	if (!acl)
 		return NULL;
 
 	INIT_LIST_HEAD(&acl->acl_list);
@@ -357,7 +356,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 
 	spin_lock_bh(&tpg->acl_node_lock);
 	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
-	if ((acl)) {
+	if (acl) {
 		if (acl->dynamic_node_acl) {
 			acl->dynamic_node_acl = 0;
 			pr_debug("%s_TPG[%u] - Replacing dynamic ACL"
@@ -384,7 +383,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	}
 	spin_unlock_bh(&tpg->acl_node_lock);
 
-	if (!(se_nacl)) {
+	if (!se_nacl) {
 		pr_err("struct se_node_acl pointer is NULL\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -463,7 +462,7 @@ int core_tpg_del_initiator_node_acl(
 		/*
 		 * Determine if the session needs to be closed by our context.
 		 */
-		if (!(tpg->se_tpg_tfo->shutdown_session(sess)))
+		if (!tpg->se_tpg_tfo->shutdown_session(sess))
 			continue;
 
 		spin_unlock_bh(&tpg->session_lock);
@@ -506,7 +505,7 @@ int core_tpg_set_initiator_node_queue_depth(
 
 	spin_lock_bh(&tpg->acl_node_lock);
 	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
-	if (!(acl)) {
+	if (!acl) {
 		pr_err("Access Control List entry for %s Initiator"
 			" Node %s does not exists for TPG %hu, ignoring"
 			" request.\n", tpg->se_tpg_tfo->get_fabric_name(),
@@ -543,7 +542,7 @@ int core_tpg_set_initiator_node_queue_depth(
 		/*
 		 * Determine if the session needs to be closed by our context.
 		 */
-		if (!(tpg->se_tpg_tfo->shutdown_session(sess)))
+		if (!tpg->se_tpg_tfo->shutdown_session(sess))
 			continue;
 
 		init_sess = sess;
@@ -644,7 +643,7 @@ int core_tpg_register(
 
 	se_tpg->tpg_lun_list = kzalloc((sizeof(struct se_lun) *
 				TRANSPORT_MAX_LUNS_PER_TPG), GFP_KERNEL);
-	if (!(se_tpg->tpg_lun_list)) {
+	if (!se_tpg->tpg_lun_list) {
 		pr_err("Unable to allocate struct se_portal_group->"
 				"tpg_lun_list\n");
 		return -ENOMEM;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8d84af1..5812756 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -99,14 +99,14 @@ int init_se_kmem_caches(void)
 {
 	se_cmd_cache = kmem_cache_create("se_cmd_cache",
 			sizeof(struct se_cmd), __alignof__(struct se_cmd), 0, NULL);
-	if (!(se_cmd_cache)) {
+	if (!se_cmd_cache) {
 		pr_err("kmem_cache_create for struct se_cmd failed\n");
 		goto out;
 	}
 	se_tmr_req_cache = kmem_cache_create("se_tmr_cache",
 			sizeof(struct se_tmr_req), __alignof__(struct se_tmr_req),
 			0, NULL);
-	if (!(se_tmr_req_cache)) {
+	if (!se_tmr_req_cache) {
 		pr_err("kmem_cache_create() for struct se_tmr_req"
 				" failed\n");
 		goto out;
@@ -114,7 +114,7 @@ int init_se_kmem_caches(void)
 	se_sess_cache = kmem_cache_create("se_sess_cache",
 			sizeof(struct se_session), __alignof__(struct se_session),
 			0, NULL);
-	if (!(se_sess_cache)) {
+	if (!se_sess_cache) {
 		pr_err("kmem_cache_create() for struct se_session"
 				" failed\n");
 		goto out;
@@ -122,14 +122,14 @@ int init_se_kmem_caches(void)
 	se_ua_cache = kmem_cache_create("se_ua_cache",
 			sizeof(struct se_ua), __alignof__(struct se_ua),
 			0, NULL);
-	if (!(se_ua_cache)) {
+	if (!se_ua_cache) {
 		pr_err("kmem_cache_create() for struct se_ua failed\n");
 		goto out;
 	}
 	t10_pr_reg_cache = kmem_cache_create("t10_pr_reg_cache",
 			sizeof(struct t10_pr_registration),
 			__alignof__(struct t10_pr_registration), 0, NULL);
-	if (!(t10_pr_reg_cache)) {
+	if (!t10_pr_reg_cache) {
 		pr_err("kmem_cache_create() for struct t10_pr_registration"
 				" failed\n");
 		goto out;
@@ -137,7 +137,7 @@ int init_se_kmem_caches(void)
 	t10_alua_lu_gp_cache = kmem_cache_create("t10_alua_lu_gp_cache",
 			sizeof(struct t10_alua_lu_gp), __alignof__(struct t10_alua_lu_gp),
 			0, NULL);
-	if (!(t10_alua_lu_gp_cache)) {
+	if (!t10_alua_lu_gp_cache) {
 		pr_err("kmem_cache_create() for t10_alua_lu_gp_cache"
 				" failed\n");
 		goto out;
@@ -145,7 +145,7 @@ int init_se_kmem_caches(void)
 	t10_alua_lu_gp_mem_cache = kmem_cache_create("t10_alua_lu_gp_mem_cache",
 			sizeof(struct t10_alua_lu_gp_member),
 			__alignof__(struct t10_alua_lu_gp_member), 0, NULL);
-	if (!(t10_alua_lu_gp_mem_cache)) {
+	if (!t10_alua_lu_gp_mem_cache) {
 		pr_err("kmem_cache_create() for t10_alua_lu_gp_mem_"
 				"cache failed\n");
 		goto out;
@@ -153,7 +153,7 @@ int init_se_kmem_caches(void)
 	t10_alua_tg_pt_gp_cache = kmem_cache_create("t10_alua_tg_pt_gp_cache",
 			sizeof(struct t10_alua_tg_pt_gp),
 			__alignof__(struct t10_alua_tg_pt_gp), 0, NULL);
-	if (!(t10_alua_tg_pt_gp_cache)) {
+	if (!t10_alua_tg_pt_gp_cache) {
 		pr_err("kmem_cache_create() for t10_alua_tg_pt_gp_"
 				"cache failed\n");
 		goto out;
@@ -163,7 +163,7 @@ int init_se_kmem_caches(void)
 			sizeof(struct t10_alua_tg_pt_gp_member),
 			__alignof__(struct t10_alua_tg_pt_gp_member),
 			0, NULL);
-	if (!(t10_alua_tg_pt_gp_mem_cache)) {
+	if (!t10_alua_tg_pt_gp_mem_cache) {
 		pr_err("kmem_cache_create() for t10_alua_tg_pt_gp_"
 				"mem_t failed\n");
 		goto out;
@@ -279,7 +279,7 @@ struct se_session *transport_init_session(void)
 	struct se_session *se_sess;
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
-	if (!(se_sess)) {
+	if (!se_sess) {
 		pr_err("Unable to allocate struct se_session from"
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
@@ -359,7 +359,7 @@ void transport_deregister_session_configfs(struct se_session *se_sess)
 	 * Used by struct se_node_acl's under ConfigFS to locate active struct se_session
 	 */
 	se_nacl = se_sess->se_node_acl;
-	if ((se_nacl)) {
+	if (se_nacl) {
 		spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
 		list_del(&se_sess->sess_acl_list);
 		/*
@@ -390,7 +390,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	struct se_portal_group *se_tpg = se_sess->se_tpg;
 	struct se_node_acl *se_nacl;
 
-	if (!(se_tpg)) {
+	if (!se_tpg) {
 		transport_free_session(se_sess);
 		return;
 	}
@@ -406,11 +406,11 @@ void transport_deregister_session(struct se_session *se_sess)
 	 * struct se_node_acl if it had been previously dynamically generated.
 	 */
 	se_nacl = se_sess->se_node_acl;
-	if ((se_nacl)) {
+	if (se_nacl) {
 		spin_lock_bh(&se_tpg->acl_node_lock);
 		if (se_nacl->dynamic_node_acl) {
-			if (!(se_tpg->se_tpg_tfo->tpg_check_demo_mode_cache(
-					se_tpg))) {
+			if (!se_tpg->se_tpg_tfo->tpg_check_demo_mode_cache(
+					se_tpg)) {
 				list_del(&se_nacl->acl_list);
 				se_tpg->num_node_acls--;
 				spin_unlock_bh(&se_tpg->acl_node_lock);
@@ -443,13 +443,13 @@ static void transport_all_task_dev_remove_state(struct se_cmd *cmd)
 
 	list_for_each_entry(task, &cmd->t_task_list, t_list) {
 		dev = task->se_dev;
-		if (!(dev))
+		if (!dev)
 			continue;
 
 		if (atomic_read(&task->task_active))
 			continue;
 
-		if (!(atomic_read(&task->task_state_active)))
+		if (!atomic_read(&task->task_state_active))
 			continue;
 
 		spin_lock_irqsave(&dev->execute_task_lock, flags);
@@ -569,7 +569,7 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 		return;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (!(atomic_read(&cmd->transport_dev_active))) {
+	if (!atomic_read(&cmd->transport_dev_active)) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		goto check_lun;
 	}
@@ -671,7 +671,7 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 	unsigned long flags;
 
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
-	if (!(atomic_read(&cmd->t_transport_queue_active))) {
+	if (!atomic_read(&cmd->t_transport_queue_active)) {
 		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 		return;
 	}
@@ -773,8 +773,8 @@ void transport_complete_task(struct se_task *task, int success)
 	 * the processing thread.
 	 */
 	if (atomic_read(&task->task_timeout)) {
-		if (!(atomic_dec_and_test(
-				&cmd->t_task_cdbs_timeout_left))) {
+		if (!atomic_dec_and_test(
+				&cmd->t_task_cdbs_timeout_left)) {
 			spin_unlock_irqrestore(&cmd->t_state_lock,
 				flags);
 			return;
@@ -792,7 +792,7 @@ void transport_complete_task(struct se_task *task, int success)
 	 * struct se_task from struct se_cmd will complete itself into the
 	 * device queue depending upon int success.
 	 */
-	if (!(atomic_dec_and_test(&cmd->t_task_cdbs_left))) {
+	if (!atomic_dec_and_test(&cmd->t_task_cdbs_left)) {
 		if (!success)
 			cmd->t_tasks_failed = 1;
 
@@ -1411,7 +1411,7 @@ struct se_device *transport_add_device_to_core_hba(
 	struct se_device  *dev;
 
 	dev = kzalloc(sizeof(struct se_device), GFP_KERNEL);
-	if (!(dev)) {
+	if (!dev) {
 		pr_err("Unable to allocate memory for se_dev_t\n");
 		return NULL;
 	}
@@ -1691,7 +1691,7 @@ int transport_generic_allocate_tasks(
 	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
 		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb),
 						GFP_KERNEL);
-		if (!(cmd->t_task_cdb)) {
+		if (!cmd->t_task_cdb) {
 			pr_err("Unable to allocate cmd->t_task_cdb"
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),
@@ -2038,7 +2038,7 @@ static void transport_generic_request_failure(
 
 check_stop:
 	transport_lun_remove_cmd(cmd);
-	if (!(transport_cmd_check_stop_to_fabric(cmd)))
+	if (!transport_cmd_check_stop_to_fabric(cmd))
 		;
 	return;
 
@@ -2052,7 +2052,7 @@ static void transport_direct_request_timeout(struct se_cmd *cmd)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (!(atomic_read(&cmd->t_transport_timeout))) {
+	if (!atomic_read(&cmd->t_transport_timeout)) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}
@@ -2148,7 +2148,7 @@ static void transport_task_timeout_handler(unsigned long data)
 	/*
 	 * Determine if transport_complete_task() has already been called.
 	 */
-	if (!(atomic_read(&task->task_active))) {
+	if (!atomic_read(&task->task_active)) {
 		pr_debug("transport task: %p cmd: %p timeout task_active"
 				" == 0\n", task, cmd);
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
@@ -2171,7 +2171,7 @@ static void transport_task_timeout_handler(unsigned long data)
 		return;
 	}
 
-	if (!(atomic_dec_and_test(&cmd->t_task_cdbs_left))) {
+	if (!atomic_dec_and_test(&cmd->t_task_cdbs_left)) {
 		pr_debug("transport task: %p cmd: %p timeout non zero"
 				" t_task_cdbs_left\n", task, cmd);
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
@@ -2200,7 +2200,7 @@ static void transport_start_task_timer(struct se_task *task)
 	 * If the task_timeout is disabled, exit now.
 	 */
 	timeout = dev->se_sub_dev->se_dev_attrib.task_timeout;
-	if (!(timeout))
+	if (!timeout)
 		return;
 
 	init_timer(&task->task_timer);
@@ -2223,7 +2223,7 @@ void __transport_stop_task_timer(struct se_task *task, unsigned long *flags)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 
-	if (!(task->task_flags & TF_RUNNING))
+	if (!task->task_flags & TF_RUNNING)
 		return;
 
 	task->task_flags |= TF_STOP;
@@ -2301,7 +2301,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 		 * no other older commands exist that need to be
 		 * completed first.
 		 */
-		if (!(atomic_read(&cmd->se_dev->simple_cmds)))
+		if (!atomic_read(&cmd->se_dev->simple_cmds))
 			return 1;
 	} else {
 		/*
@@ -2360,7 +2360,7 @@ static int transport_execute_tasks(struct se_cmd *cmd)
 	 * Call transport_cmd_check_stop() to see if a fabric exception
 	 * has occurred that prevents execution.
 	 */
-	if (!(transport_cmd_check_stop(cmd, 0, TRANSPORT_PROCESSING))) {
+	if (!transport_cmd_check_stop(cmd, 0, TRANSPORT_PROCESSING)) {
 		/*
 		 * Check for SAM Task Attribute emulation and HEAD_OF_QUEUE
 		 * attribute for the tasks of the received struct se_cmd CDB
@@ -2706,7 +2706,7 @@ static void transport_xor_callback(struct se_cmd *cmd)
 	 * 5) transfer the resulting XOR data to the data-in buffer.
 	 */
 	buf = kmalloc(cmd->data_length, GFP_KERNEL);
-	if (!(buf)) {
+	if (!buf) {
 		pr_err("Unable to allocate xor_callback buf\n");
 		return;
 	}
@@ -2767,7 +2767,7 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 			continue;
 
 		dev = task->se_dev;
-		if (!(dev))
+		if (!dev)
 			continue;
 
 		if (!dev->transport->get_sense_buffer) {
@@ -2777,7 +2777,7 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 		}
 
 		sense_buffer = dev->transport->get_sense_buffer(task);
-		if (!(sense_buffer)) {
+		if (!sense_buffer) {
 			pr_err("ITT[0x%08x]_TASK[%d]: Unable to locate"
 				" sense buffer for task with sense\n",
 				cmd->se_tfo->get_task_tag(cmd), task->task_no);
@@ -2843,8 +2843,7 @@ static int transport_cmd_get_valid_sectors(struct se_cmd *cmd)
 
 	sectors = (cmd->data_length / dev->se_sub_dev->se_dev_attrib.block_size);
 
-	if ((cmd->t_task_lba + sectors) >
-	     transport_dev_end_lba(dev)) {
+	if ((cmd->t_task_lba + sectors) > transport_dev_end_lba(dev)) {
 		pr_err("LBA: %llu Sectors: %u exceeds"
 			" transport_dev_end_lba(): %llu\n",
 			cmd->t_task_lba, sectors,
@@ -3363,7 +3362,7 @@ static int transport_generic_cmd_sequencer(
 		 * emulation for -> Linux/BLOCK disbard with TCM/IBLOCK and
 		 * TCM/FILEIO subsystem plugin backstores.
 		 */
-		if (!(passthrough)) {
+		if (!passthrough) {
 			if ((cdb[1] & 0x04) || (cdb[1] & 0x02)) {
 				pr_err("WRITE_SAME PBDATA and LBDATA"
 					" bits not supported for Block Discard"
@@ -3435,7 +3434,7 @@ static int transport_generic_cmd_sequencer(
 		 * Reject READ_* or WRITE_* with overflow/underflow for
 		 * type SCF_SCSI_DATA_SG_IO_CDB.
 		 */
-		if (!(ret) && (dev->se_sub_dev->se_dev_attrib.block_size != 512))  {
+		if (!ret && (dev->se_sub_dev->se_dev_attrib.block_size != 512))  {
 			pr_err("Failing OVERFLOW/UNDERFLOW for LBA op"
 				" CDB on non 512-byte sector setup subsystem"
 				" plugin: %s\n", dev->transport->name);
@@ -3759,7 +3758,7 @@ static inline int transport_dec_and_check(struct se_cmd *cmd)
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (atomic_read(&cmd->t_fe_count)) {
-		if (!(atomic_dec_and_test(&cmd->t_fe_count))) {
+		if (!atomic_dec_and_test(&cmd->t_fe_count)) {
 			spin_unlock_irqrestore(&cmd->t_state_lock,
 					flags);
 			return 1;
@@ -3767,7 +3766,7 @@ static inline int transport_dec_and_check(struct se_cmd *cmd)
 	}
 
 	if (atomic_read(&cmd->t_se_count)) {
-		if (!(atomic_dec_and_test(&cmd->t_se_count))) {
+		if (!atomic_dec_and_test(&cmd->t_se_count)) {
 			spin_unlock_irqrestore(&cmd->t_state_lock,
 					flags);
 			return 1;
@@ -3786,7 +3785,7 @@ static void transport_release_fe_cmd(struct se_cmd *cmd)
 		return;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (!(atomic_read(&cmd->transport_dev_active))) {
+	if (!atomic_read(&cmd->transport_dev_active)) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		goto free_pages;
 	}
@@ -3817,7 +3816,7 @@ transport_generic_remove(struct se_cmd *cmd, int session_reinstatement)
 	}
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (!(atomic_read(&cmd->transport_dev_active))) {
+	if (!atomic_read(&cmd->transport_dev_active)) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		goto free_pages;
 	}
@@ -4482,7 +4481,7 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 
 		spin_unlock_irqrestore(&lun->lun_cmd_lock, lun_flags);
 
-		if (!(cmd->se_lun)) {
+		if (!cmd->se_lun) {
 			pr_err("ITT: 0x%08x, [i,t]_state: %u/%u\n",
 				cmd->se_tfo->get_task_tag(cmd),
 				cmd->se_tfo->get_cmd_state(cmd), cmd->t_state);
@@ -4507,7 +4506,7 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 			cmd->se_tfo->get_task_tag(cmd));
 
 		spin_lock_irqsave(&cmd->t_state_lock, cmd_flags);
-		if (!(atomic_read(&cmd->transport_dev_active))) {
+		if (!atomic_read(&cmd->transport_dev_active)) {
 			spin_unlock_irqrestore(&cmd->t_state_lock, cmd_flags);
 			goto check_cond;
 		}
@@ -4862,7 +4861,7 @@ int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 	int ret = 0;
 
 	if (atomic_read(&cmd->t_transport_aborted) != 0) {
-		if (!(send_status) ||
+		if (!send_status ||
 		     (cmd->se_cmd_flags & SCF_SENT_DELAYED_TAS))
 			return 1;
 #if 0
@@ -5030,7 +5029,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 		}
 		__transport_stop_task_timer(task, &flags);
 
-		if (!(atomic_dec_and_test(&cmd->t_task_cdbs_ex_left))) {
+		if (!atomic_dec_and_test(&cmd->t_task_cdbs_ex_left)) {
 			spin_unlock_irqrestore(
 					&cmd->t_state_lock, flags);
 
@@ -5159,7 +5158,7 @@ get_cmd:
 
 		switch (cmd->t_state) {
 		case TRANSPORT_NEW_CMD_MAP:
-			if (!(cmd->se_tfo->new_cmd_map)) {
+			if (!cmd->se_tfo->new_cmd_map) {
 				pr_err("cmd->se_tfo->new_cmd_map is"
 					" NULL for TRANSPORT_NEW_CMD_MAP\n");
 				BUG();
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index dfa5664..31e3c65 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -49,15 +49,15 @@ int core_scsi3_ua_check(
 	struct se_session *sess = cmd->se_sess;
 	struct se_node_acl *nacl;
 
-	if (!(sess))
+	if (!sess)
 		return 0;
 
 	nacl = sess->se_node_acl;
-	if (!(nacl))
+	if (!nacl)
 		return 0;
 
 	deve = &nacl->device_list[cmd->orig_fe_lun];
-	if (!(atomic_read(&deve->ua_count)))
+	if (!atomic_read(&deve->ua_count))
 		return 0;
 	/*
 	 * From sam4r14, section 5.14 Unit attention condition:
@@ -97,11 +97,11 @@ int core_scsi3_ua_allocate(
 	/*
 	 * PASSTHROUGH OPS
 	 */
-	if (!(nacl))
+	if (!nacl)
 		return -EINVAL;
 
 	ua = kmem_cache_zalloc(se_ua_cache, GFP_ATOMIC);
-	if (!(ua)) {
+	if (!ua) {
 		pr_err("Unable to allocate struct se_ua\n");
 		return -ENOMEM;
 	}
@@ -215,16 +215,16 @@ void core_scsi3_ua_for_check_condition(
 	struct se_ua *ua = NULL, *ua_p;
 	int head = 1;
 
-	if (!(sess))
+	if (!sess)
 		return;
 
 	nacl = sess->se_node_acl;
-	if (!(nacl))
+	if (!nacl)
 		return;
 
 	spin_lock_irq(&nacl->device_list_lock);
 	deve = &nacl->device_list[cmd->orig_fe_lun];
-	if (!(atomic_read(&deve->ua_count))) {
+	if (!atomic_read(&deve->ua_count)) {
 		spin_unlock_irq(&nacl->device_list_lock);
 		return;
 	}
@@ -284,16 +284,16 @@ int core_scsi3_ua_clear_for_request_sense(
 	struct se_ua *ua = NULL, *ua_p;
 	int head = 1;
 
-	if (!(sess))
+	if (!sess)
 		return -EINVAL;
 
 	nacl = sess->se_node_acl;
-	if (!(nacl))
+	if (!nacl)
 		return -EINVAL;
 
 	spin_lock_irq(&nacl->device_list_lock);
 	deve = &nacl->device_list[cmd->orig_fe_lun];
-	if (!(atomic_read(&deve->ua_count))) {
+	if (!atomic_read(&deve->ua_count)) {
 		spin_unlock_irq(&nacl->device_list_lock);
 		return -EPERM;
 	}
-- 
1.7.6

