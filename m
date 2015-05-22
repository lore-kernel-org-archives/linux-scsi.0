From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 5/9] target: Convert se_portal_group->tpg_lun_list[] to RCU hlist
Date: Fri, 22 May 2015 06:11:07 +0000
Message-ID: <1432275071-28882-6-git-send-email-nab@daterainc.com>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33406 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbbEVGN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 02:13:57 -0400
Received: by oiww2 with SMTP id w2so6899163oiw.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 23:13:57 -0700 (PDT)
In-Reply-To: <1432275071-28882-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Chris Boot <bootc@bootc.net>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the fixed size se_portal_group->tpg_lun_list[]
to use modern RCU with hlist_head in order to support an arbitary
number of se_lun ports per target endpoint.

It includes dropping core_tpg_alloc_lun() from core_dev_add_lun(),
and calling it directly from target_fabric_make_lun() to allocate
a new se_lun.

Also add a new target_fabric_port_release() configfs item callback
to invoke kfree_rcu() to release memory during se_lun->lun_group
shutdown.

Also now that se_node_acl->lun_entry_hlist is using RCU, convert
existing tpg_lun_lock to struct mutex so core_tpg_add_node_to_devs()
can perform RCU updater logic without releasing ->tpg_lun_mutex.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Chris Boot <bootc@bootc.net>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_tpg.c      |   2 -
 drivers/target/sbp/sbp_target.c              |  97 +++++++++-----------
 drivers/target/sbp/sbp_target.h              |   2 +-
 drivers/target/target_core_device.c          |  92 ++-----------------
 drivers/target/target_core_fabric_configfs.c |  34 ++++---
 drivers/target/target_core_internal.h        |   6 +-
 drivers/target/target_core_tpg.c             | 132 ++++++---------------------
 drivers/xen/xen-scsiback.c                   |  27 +++---
 include/target/target_core_base.h            |   6 +-
 include/target/target_core_fabric.h          |   1 -
 10 files changed, 122 insertions(+), 277 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 3af76e3..86f888e 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -281,8 +281,6 @@ int iscsit_tpg_del_portal_group(
 		return -EPERM;
 	}
 
-	core_tpg_clear_object_luns(&tpg->tpg_se_tpg);
-
 	if (tpg->param_list) {
 		iscsi_release_param_list(tpg->param_list);
 		tpg->param_list = NULL;
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 5d7755e..47fb12f 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -108,13 +108,13 @@ static struct sbp_session *sbp_session_find_by_guid(
 }
 
 static struct sbp_login_descriptor *sbp_login_find_by_lun(
-		struct sbp_session *session, struct se_lun *lun)
+		struct sbp_session *session, u32 unpacked_lun)
 {
 	struct sbp_login_descriptor *login, *found = NULL;
 
 	spin_lock_bh(&session->lock);
 	list_for_each_entry(login, &session->login_list, link) {
-		if (login->lun == lun)
+		if (login->login_lun == unpacked_lun)
 			found = login;
 	}
 	spin_unlock_bh(&session->lock);
@@ -124,7 +124,7 @@ static struct sbp_login_descriptor *sbp_login_find_by_lun(
 
 static int sbp_login_count_all_by_lun(
 		struct sbp_tpg *tpg,
-		struct se_lun *lun,
+		u32 unpacked_lun,
 		int exclusive)
 {
 	struct se_session *se_sess;
@@ -138,7 +138,7 @@ static int sbp_login_count_all_by_lun(
 
 		spin_lock_bh(&sess->lock);
 		list_for_each_entry(login, &sess->login_list, link) {
-			if (login->lun != lun)
+			if (login->login_lun != unpacked_lun)
 				continue;
 
 			if (!exclusive || login->exclusive)
@@ -174,23 +174,23 @@ static struct sbp_login_descriptor *sbp_login_find_by_id(
 	return found;
 }
 
-static struct se_lun *sbp_get_lun_from_tpg(struct sbp_tpg *tpg, int lun)
+static u32 sbp_get_lun_from_tpg(struct sbp_tpg *tpg, u32 login_lun, int *err)
 {
 	struct se_portal_group *se_tpg = &tpg->se_tpg;
 	struct se_lun *se_lun;
 
-	if (lun >= TRANSPORT_MAX_LUNS_PER_TPG)
-		return ERR_PTR(-EINVAL);
-
-	spin_lock(&se_tpg->tpg_lun_lock);
-	se_lun = se_tpg->tpg_lun_list[lun];
-
-	if (se_lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
-		se_lun = ERR_PTR(-ENODEV);
-
-	spin_unlock(&se_tpg->tpg_lun_lock);
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(se_lun, &se_tpg->tpg_lun_hlist, link) {
+		if (se_lun->unpacked_lun == login_lun) {
+			rcu_read_unlock();
+			*err = 0;
+			return login_lun;
+		}
+	}
+	rcu_read_unlock();
 
-	return se_lun;
+	*err = -ENODEV;
+	return login_lun;
 }
 
 static struct sbp_session *sbp_session_create(
@@ -294,17 +294,16 @@ static void sbp_management_request_login(
 {
 	struct sbp_tport *tport = agent->tport;
 	struct sbp_tpg *tpg = tport->tpg;
-	struct se_lun *se_lun;
-	int ret;
-	u64 guid;
 	struct sbp_session *sess;
 	struct sbp_login_descriptor *login;
 	struct sbp_login_response_block *response;
-	int login_response_len;
+	u64 guid;
+	u32 unpacked_lun;
+	int login_response_len, ret;
 
-	se_lun = sbp_get_lun_from_tpg(tpg,
-			LOGIN_ORB_LUN(be32_to_cpu(req->orb.misc)));
-	if (IS_ERR(se_lun)) {
+	unpacked_lun = sbp_get_lun_from_tpg(tpg,
+			LOGIN_ORB_LUN(be32_to_cpu(req->orb.misc)), &ret);
+	if (ret) {
 		pr_notice("login to unknown LUN: %d\n",
 			LOGIN_ORB_LUN(be32_to_cpu(req->orb.misc)));
 
@@ -325,11 +324,11 @@ static void sbp_management_request_login(
 	}
 
 	pr_notice("mgt_agent LOGIN to LUN %d from %016llx\n",
-		se_lun->unpacked_lun, guid);
+		unpacked_lun, guid);
 
 	sess = sbp_session_find_by_guid(tpg, guid);
 	if (sess) {
-		login = sbp_login_find_by_lun(sess, se_lun);
+		login = sbp_login_find_by_lun(sess, unpacked_lun);
 		if (login) {
 			pr_notice("initiator already logged-in\n");
 
@@ -357,7 +356,7 @@ static void sbp_management_request_login(
 	 * reject with access_denied if any logins present
 	 */
 	if (LOGIN_ORB_EXCLUSIVE(be32_to_cpu(req->orb.misc)) &&
-			sbp_login_count_all_by_lun(tpg, se_lun, 0)) {
+			sbp_login_count_all_by_lun(tpg, unpacked_lun, 0)) {
 		pr_warn("refusing exclusive login with other active logins\n");
 
 		req->status.status = cpu_to_be32(
@@ -370,7 +369,7 @@ static void sbp_management_request_login(
 	 * check exclusive bit in any existing login descriptor
 	 * reject with access_denied if any exclusive logins present
 	 */
-	if (sbp_login_count_all_by_lun(tpg, se_lun, 1)) {
+	if (sbp_login_count_all_by_lun(tpg, unpacked_lun, 1)) {
 		pr_warn("refusing login while another exclusive login present\n");
 
 		req->status.status = cpu_to_be32(
@@ -383,7 +382,7 @@ static void sbp_management_request_login(
 	 * check we haven't exceeded the number of allowed logins
 	 * reject with resources_unavailable if we have
 	 */
-	if (sbp_login_count_all_by_lun(tpg, se_lun, 0) >=
+	if (sbp_login_count_all_by_lun(tpg, unpacked_lun, 0) >=
 			tport->max_logins_per_lun) {
 		pr_warn("max number of logins reached\n");
 
@@ -439,7 +438,7 @@ static void sbp_management_request_login(
 	}
 
 	login->sess = sess;
-	login->lun = se_lun;
+	login->login_lun = unpacked_lun;
 	login->status_fifo_addr = sbp2_pointer_to_addr(&req->orb.status_fifo);
 	login->exclusive = LOGIN_ORB_EXCLUSIVE(be32_to_cpu(req->orb.misc));
 	login->login_id = atomic_inc_return(&login_id);
@@ -601,7 +600,7 @@ static void sbp_management_request_logout(
 	}
 
 	pr_info("mgt_agent LOGOUT from LUN %d session %d\n",
-		login->lun->unpacked_lun, login->login_id);
+		login->login_lun, login->login_id);
 
 	if (req->node_addr != login->sess->node_id) {
 		pr_warn("logout from different node ID\n");
@@ -1227,7 +1226,7 @@ static void sbp_handle_command(struct sbp_target_request *req)
 		goto err;
 	}
 
-	unpacked_lun = req->login->lun->unpacked_lun;
+	unpacked_lun = req->login->login_lun;
 	sbp_calc_data_length_direction(req, &data_length, &data_dir);
 
 	pr_debug("sbp_handle_command ORB:0x%llx unpacked_lun:%d data_len:%d data_dir:%d\n",
@@ -1826,25 +1825,21 @@ static int sbp_check_stop_free(struct se_cmd *se_cmd)
 
 static int sbp_count_se_tpg_luns(struct se_portal_group *tpg)
 {
-	int i, count = 0;
-
-	spin_lock(&tpg->tpg_lun_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		struct se_lun *se_lun = tpg->tpg_lun_list[i];
-
-		if (se_lun->lun_status == TRANSPORT_LUN_STATUS_FREE)
-			continue;
+	struct se_lun *lun;
+	int count = 0;
 
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link)
 		count++;
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	rcu_read_unlock();
 
 	return count;
 }
 
 static int sbp_update_unit_directory(struct sbp_tport *tport)
 {
-	int num_luns, num_entries, idx = 0, mgt_agt_addr, ret, i;
+	struct se_lun *lun;
+	int num_luns, num_entries, idx = 0, mgt_agt_addr, ret;
 	u32 *data;
 
 	if (tport->unit_directory.data) {
@@ -1906,28 +1901,20 @@ static int sbp_update_unit_directory(struct sbp_tport *tport)
 	/* unit unique ID (leaf is just after LUNs) */
 	data[idx++] = 0x8d000000 | (num_luns + 1);
 
-	spin_lock(&tport->tpg->se_tpg.tpg_lun_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		struct se_lun *se_lun = tport->tpg->se_tpg.tpg_lun_list[i];
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(lun, &tport->tpg->se_tpg.tpg_lun_hlist, link) {
 		struct se_device *dev;
 		int type;
 
-		if (se_lun->lun_status == TRANSPORT_LUN_STATUS_FREE)
-			continue;
-
-		spin_unlock(&tport->tpg->se_tpg.tpg_lun_lock);
-
-		dev = se_lun->lun_se_dev;
+		dev = lun->lun_se_dev;
 		type = dev->transport->get_device_type(dev);
 
 		/* logical_unit_number */
 		data[idx++] = 0x14000000 |
 			((type << 16) & 0x1f0000) |
-			(se_lun->unpacked_lun & 0xffff);
-
-		spin_lock(&tport->tpg->se_tpg.tpg_lun_lock);
+			(lun->unpacked_lun & 0xffff);
 	}
-	spin_unlock(&tport->tpg->se_tpg.tpg_lun_lock);
+	rcu_read_unlock();
 
 	/* unit unique ID leaf */
 	data[idx++] = 2 << 16;
diff --git a/drivers/target/sbp/sbp_target.h b/drivers/target/sbp/sbp_target.h
index e1b0b84..73bcb12 100644
--- a/drivers/target/sbp/sbp_target.h
+++ b/drivers/target/sbp/sbp_target.h
@@ -125,7 +125,7 @@ struct sbp_login_descriptor {
 	struct sbp_session *sess;
 	struct list_head link;
 
-	struct se_lun *lun;
+	u32 login_lun;
 
 	u64 status_fifo_addr;
 	int exclusive;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 6432d26..5b74c33 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1161,22 +1161,17 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 }
 EXPORT_SYMBOL(se_dev_set_block_size);
 
-struct se_lun *core_dev_add_lun(
+int core_dev_add_lun(
 	struct se_portal_group *tpg,
 	struct se_device *dev,
-	u32 unpacked_lun)
+	struct se_lun *lun)
 {
-	struct se_lun *lun;
 	int rc;
 
-	lun = core_tpg_alloc_lun(tpg, unpacked_lun);
-	if (IS_ERR(lun))
-		return lun;
-
 	rc = core_tpg_add_lun(tpg, lun,
 				TRANSPORT_LUNFLAGS_READ_WRITE, dev);
 	if (rc < 0)
-		return ERR_PTR(rc);
+		return rc;
 
 	pr_debug("%s_TPG[%u]_LUN[%u] - Activated %s Logical Unit from"
 		" CORE HBA: %u\n", tpg->se_tpg_tfo->get_fabric_name(),
@@ -1201,7 +1196,7 @@ struct se_lun *core_dev_add_lun(
 		spin_unlock_irq(&tpg->acl_node_lock);
 	}
 
-	return lun;
+	return 0;
 }
 
 /*      core_dev_del_lun():
@@ -1220,68 +1215,6 @@ void core_dev_del_lun(
 	core_tpg_remove_lun(tpg, lun);
 }
 
-struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_lun)
-{
-	struct se_lun *lun;
-
-	spin_lock(&tpg->tpg_lun_lock);
-	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS"
-			"_PER_TPG-1: %u for Target Portal Group: %hu\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			TRANSPORT_MAX_LUNS_PER_TPG-1,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return NULL;
-	}
-	lun = tpg->tpg_lun_list[unpacked_lun];
-
-	if (lun->lun_status != TRANSPORT_LUN_STATUS_FREE) {
-		pr_err("%s Logical Unit Number: %u is not free on"
-			" Target Portal Group: %hu, ignoring request.\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return NULL;
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	return lun;
-}
-
-/*      core_dev_get_lun():
- *
- *
- */
-static struct se_lun *core_dev_get_lun(struct se_portal_group *tpg, u32 unpacked_lun)
-{
-	struct se_lun *lun;
-
-	spin_lock(&tpg->tpg_lun_lock);
-	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER"
-			"_TPG-1: %u for Target Portal Group: %hu\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			TRANSPORT_MAX_LUNS_PER_TPG-1,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return NULL;
-	}
-	lun = tpg->tpg_lun_list[unpacked_lun];
-
-	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
-		pr_err("%s Logical Unit Number: %u is not active on"
-			" Target Portal Group: %hu, ignoring request.\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return NULL;
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	return lun;
-}
-
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_node_acl *nacl,
@@ -1315,22 +1248,11 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 int core_dev_add_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_lun_acl *lacl,
-	u32 unpacked_lun,
+	struct se_lun *lun,
 	u32 lun_access)
 {
-	struct se_lun *lun;
-	struct se_node_acl *nacl;
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
 
-	lun = core_dev_get_lun(tpg, unpacked_lun);
-	if (!lun) {
-		pr_err("%s Logical Unit Number: %u is not active on"
-			" Target Portal Group: %hu, ignoring request.\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		return -EINVAL;
-	}
-
-	nacl = lacl->se_lun_nacl;
 	if (!nacl)
 		return -EINVAL;
 
@@ -1351,7 +1273,7 @@ int core_dev_add_initiator_node_lun_acl(
 
 	pr_debug("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
 		" InitiatorNode: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), unpacked_lun, lacl->mapped_lun,
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun, lacl->mapped_lun,
 		(lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) ? "RW" : "RO",
 		lacl->initiatorname);
 	/*
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 0939a54..9be8030 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -81,7 +81,7 @@ static int target_fabric_mappedlun_link(
 			struct se_lun_acl, se_lun_group);
 	struct se_portal_group *se_tpg;
 	struct config_item *nacl_ci, *tpg_ci, *tpg_ci_s, *wwn_ci, *wwn_ci_s;
-	int ret = 0, lun_access;
+	int lun_access;
 
 	if (lun->lun_link_magic != SE_LUN_LINK_MAGIC) {
 		pr_err("Bad lun->lun_link_magic, not a valid lun_ci pointer:"
@@ -137,12 +137,9 @@ static int target_fabric_mappedlun_link(
 	 * Determine the actual mapped LUN value user wants..
 	 *
 	 * This value is what the SCSI Initiator actually sees the
-	 * iscsi/$IQN/$TPGT/lun/lun_* as on their SCSI Initiator Ports.
+	 * $FABRIC/$WWPN/$TPGT/lun/lun_* as on their SCSI Initiator Ports.
 	 */
-	ret = core_dev_add_initiator_node_lun_acl(se_tpg, lacl,
-			lun->unpacked_lun, lun_access);
-
-	return (ret < 0) ? -EINVAL : 0;
+	return core_dev_add_initiator_node_lun_acl(se_tpg, lacl, lun, lun_access);
 }
 
 static int target_fabric_mappedlun_unlink(
@@ -761,7 +758,6 @@ static int target_fabric_port_link(
 	struct config_item *tpg_ci;
 	struct se_lun *lun = container_of(to_config_group(lun_ci),
 				struct se_lun, lun_group);
-	struct se_lun *lun_p;
 	struct se_portal_group *se_tpg;
 	struct se_device *dev =
 		container_of(to_config_group(se_dev_ci), struct se_device, dev_group);
@@ -789,10 +785,9 @@ static int target_fabric_port_link(
 		return -EEXIST;
 	}
 
-	lun_p = core_dev_add_lun(se_tpg, dev, lun->unpacked_lun);
-	if (IS_ERR(lun_p)) {
-		pr_err("core_dev_add_lun() failed\n");
-		ret = PTR_ERR(lun_p);
+	ret = core_dev_add_lun(se_tpg, dev, lun);
+	if (ret) {
+		pr_err("core_dev_add_lun() failed: %d\n", ret);
 		goto out;
 	}
 
@@ -832,9 +827,18 @@ static int target_fabric_port_unlink(
 	return 0;
 }
 
+static void target_fabric_port_release(struct config_item *item)
+{
+	struct se_lun *lun = container_of(to_config_group(item),
+					  struct se_lun, lun_group);
+
+	kfree_rcu(lun, rcu_head);
+}
+
 static struct configfs_item_operations target_fabric_port_item_ops = {
 	.show_attribute		= target_fabric_port_attr_show,
 	.store_attribute	= target_fabric_port_attr_store,
+	.release		= target_fabric_port_release,
 	.allow_link		= target_fabric_port_link,
 	.drop_link		= target_fabric_port_unlink,
 };
@@ -893,15 +897,16 @@ static struct config_group *target_fabric_make_lun(
 	if (unpacked_lun > UINT_MAX)
 		return ERR_PTR(-EINVAL);
 
-	lun = core_get_lun_from_tpg(se_tpg, unpacked_lun);
-	if (!lun)
-		return ERR_PTR(-EINVAL);
+	lun = core_tpg_alloc_lun(se_tpg, unpacked_lun);
+	if (IS_ERR(lun))
+		return ERR_CAST(lun);
 
 	lun_cg = &lun->lun_group;
 	lun_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
 				GFP_KERNEL);
 	if (!lun_cg->default_groups) {
 		pr_err("Unable to allocate lun_cg->default_groups\n");
+		kfree(lun);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -918,6 +923,7 @@ static struct config_group *target_fabric_make_lun(
 	if (!port_stat_grp->default_groups) {
 		pr_err("Unable to allocate port_stat_grp->default_groups\n");
 		kfree(lun_cg->default_groups);
+		kfree(lun);
 		return ERR_PTR(-ENOMEM);
 	}
 	target_stat_setup_port_default_groups(lun);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index a04a6e3..2c160ce 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -23,13 +23,13 @@ int	core_dev_export(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
 void	core_dev_unexport(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
-struct se_lun *core_dev_add_lun(struct se_portal_group *, struct se_device *, u32);
+int	core_dev_add_lun(struct se_portal_group *, struct se_device *,
+		struct se_lun *lun);
 void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
-struct se_lun *core_get_lun_from_tpg(struct se_portal_group *, u32);
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_node_acl *, u32, int *);
 int	core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
-		struct se_lun_acl *, u32, u32);
+		struct se_lun_acl *, struct se_lun *lun, u32);
 int	core_dev_del_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_lun *, struct se_lun_acl *);
 void	core_dev_free_initiator_node_lun_acl(struct se_portal_group *,
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 0519923..13d34e2 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -91,19 +91,15 @@ void core_tpg_add_node_to_devs(
 	struct se_node_acl *acl,
 	struct se_portal_group *tpg)
 {
-	int i = 0;
 	u32 lun_access = 0;
 	struct se_lun *lun;
 	struct se_device *dev;
 
-	spin_lock(&tpg->tpg_lun_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		lun = tpg->tpg_lun_list[i];
+	mutex_lock(&tpg->tpg_lun_mutex);
+	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link) {
 		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
 			continue;
 
-		spin_unlock(&tpg->tpg_lun_lock);
-
 		dev = lun->lun_se_dev;
 		/*
 		 * By default in LIO-Target $FABRIC_MOD,
@@ -130,7 +126,7 @@ void core_tpg_add_node_to_devs(
 			"READ-WRITE" : "READ-ONLY");
 
 		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
-				lun_access, acl, tpg);
+						 lun_access, acl, tpg);
 		/*
 		 * Check to see if there are any existing persistent reservation
 		 * APTPL pre-registrations that need to be enabled for this dynamic
@@ -138,9 +134,8 @@ void core_tpg_add_node_to_devs(
 		 */
 		core_scsi3_check_aptpl_registration(dev, tpg, lun, acl,
 						    lun->unpacked_lun);
-		spin_lock(&tpg->tpg_lun_lock);
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 }
 
 /*      core_set_queue_depth_for_node():
@@ -161,34 +156,6 @@ static int core_set_queue_depth_for_node(
 	return 0;
 }
 
-void array_free(void *array, int n)
-{
-	void **a = array;
-	int i;
-
-	for (i = 0; i < n; i++)
-		kfree(a[i]);
-	kfree(a);
-}
-
-static void *array_zalloc(int n, size_t size, gfp_t flags)
-{
-	void **a;
-	int i;
-
-	a = kzalloc(n * sizeof(void*), flags);
-	if (!a)
-		return NULL;
-	for (i = 0; i < n; i++) {
-		a[i] = kzalloc(size, flags);
-		if (!a[i]) {
-			array_free(a, n);
-			return NULL;
-		}
-	}
-	return a;
-}
-
 static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
 		const unsigned char *initiatorname)
 {
@@ -284,27 +251,6 @@ void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
 		cpu_relax();
 }
 
-void core_tpg_clear_object_luns(struct se_portal_group *tpg)
-{
-	int i;
-	struct se_lun *lun;
-
-	spin_lock(&tpg->tpg_lun_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		lun = tpg->tpg_lun_list[i];
-
-		if ((lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) ||
-		    (lun->lun_se_dev == NULL))
-			continue;
-
-		spin_unlock(&tpg->tpg_lun_lock);
-		core_dev_del_lun(tpg, lun);
-		spin_lock(&tpg->tpg_lun_lock);
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-}
-EXPORT_SYMBOL(core_tpg_clear_object_luns);
-
 struct se_node_acl *core_tpg_add_initiator_node_acl(
 	struct se_portal_group *tpg,
 	const char *initiatorname)
@@ -567,30 +513,7 @@ int core_tpg_register(
 	struct se_portal_group *se_tpg,
 	int proto_id)
 {
-	struct se_lun *lun;
-	u32 i;
-
-	se_tpg->tpg_lun_list = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
-			sizeof(struct se_lun), GFP_KERNEL);
-	if (!se_tpg->tpg_lun_list) {
-		pr_err("Unable to allocate struct se_portal_group->"
-				"tpg_lun_list\n");
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		lun = se_tpg->tpg_lun_list[i];
-		lun->unpacked_lun = i;
-		lun->lun_link_magic = SE_LUN_LINK_MAGIC;
-		lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
-		atomic_set(&lun->lun_acl_count, 0);
-		init_completion(&lun->lun_shutdown_comp);
-		INIT_LIST_HEAD(&lun->lun_acl_list);
-		spin_lock_init(&lun->lun_acl_lock);
-		spin_lock_init(&lun->lun_sep_lock);
-		init_completion(&lun->lun_ref_comp);
-	}
-
+	INIT_HLIST_HEAD(&se_tpg->tpg_lun_hlist);
 	se_tpg->proto_id = proto_id;
 	se_tpg->se_tpg_tfo = tfo;
 	se_tpg->se_tpg_wwn = se_wwn;
@@ -600,14 +523,11 @@ int core_tpg_register(
 	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
 	spin_lock_init(&se_tpg->acl_node_lock);
 	spin_lock_init(&se_tpg->session_lock);
-	spin_lock_init(&se_tpg->tpg_lun_lock);
+	mutex_init(&se_tpg->tpg_lun_mutex);
 
 	if (se_tpg->proto_id >= 0) {
-		if (core_tpg_setup_virtual_lun0(se_tpg) < 0) {
-			array_free(se_tpg->tpg_lun_list,
-				   TRANSPORT_MAX_LUNS_PER_TPG);
+		if (core_tpg_setup_virtual_lun0(se_tpg) < 0)
 			return -ENOMEM;
-		}
 	}
 
 	spin_lock_bh(&tpg_lock);
@@ -662,7 +582,6 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	if (se_tpg->proto_id >= 0)
 		core_tpg_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
 
-	array_free(se_tpg->tpg_lun_list, TRANSPORT_MAX_LUNS_PER_TPG);
 	return 0;
 }
 EXPORT_SYMBOL(core_tpg_deregister);
@@ -682,17 +601,20 @@ struct se_lun *core_tpg_alloc_lun(
 		return ERR_PTR(-EOVERFLOW);
 	}
 
-	spin_lock(&tpg->tpg_lun_lock);
-	lun = tpg->tpg_lun_list[unpacked_lun];
-	if (lun->lun_status == TRANSPORT_LUN_STATUS_ACTIVE) {
-		pr_err("TPG Logical Unit Number: %u is already active"
-			" on %s Target Portal Group: %u, ignoring request.\n",
-			unpacked_lun, tpg->se_tpg_tfo->get_fabric_name(),
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return ERR_PTR(-EINVAL);
+	lun = kzalloc(sizeof(*lun), GFP_KERNEL);
+	if (!lun) {
+		pr_err("Unable to allocate se_lun memory\n");
+		return ERR_PTR(-ENOMEM);
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	lun->unpacked_lun = unpacked_lun;
+	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
+	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
+	atomic_set(&lun->lun_acl_count, 0);
+	init_completion(&lun->lun_shutdown_comp);
+	INIT_LIST_HEAD(&lun->lun_acl_list);
+	spin_lock_init(&lun->lun_acl_lock);
+	spin_lock_init(&lun->lun_sep_lock);
+	init_completion(&lun->lun_ref_comp);
 
 	return lun;
 }
@@ -716,10 +638,12 @@ int core_tpg_add_lun(
 		return ret;
 	}
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	lun->lun_access = lun_access;
 	lun->lun_status = TRANSPORT_LUN_STATUS_ACTIVE;
-	spin_unlock(&tpg->tpg_lun_lock);
+	if (!(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
+		hlist_add_head_rcu(&lun->link, &tpg->tpg_lun_hlist);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	return 0;
 }
@@ -728,14 +652,18 @@ void core_tpg_remove_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
+	struct se_device *dev = lun->lun_se_dev;
+
 	core_clear_lun_from_tpg(lun, tpg);
 	transport_clear_lun_ref(lun);
 
 	core_dev_unexport(lun->lun_se_dev, tpg, lun);
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
-	spin_unlock(&tpg->tpg_lun_lock);
+	if (!(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
+		hlist_del_rcu(&lun->link);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	percpu_ref_exit(&lun->lun_ref);
 }
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 8b7dd47..555033b 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -866,7 +866,8 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	struct list_head *head = &(info->v2p_entry_lists);
 	unsigned long flags;
 	char *lunp;
-	unsigned int lun;
+	unsigned int unpacked_lun;
+	struct se_lun *se_lun;
 	struct scsiback_tpg *tpg_entry, *tpg = NULL;
 	char *error = "doesn't exist";
 
@@ -877,7 +878,7 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	}
 	*lunp = 0;
 	lunp++;
-	if (kstrtouint(lunp, 10, &lun) || lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
+	if (kstrtouint(lunp, 10, &unpacked_lun) || unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
 		pr_err("lun number not valid: %s\n", lunp);
 		return -EINVAL;
 	}
@@ -886,15 +887,17 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	list_for_each_entry(tpg_entry, &scsiback_list, tv_tpg_list) {
 		if (!strcmp(phy, tpg_entry->tport->tport_name) ||
 		    !strcmp(phy, tpg_entry->param_alias)) {
-			spin_lock(&tpg_entry->se_tpg.tpg_lun_lock);
-			if (tpg_entry->se_tpg.tpg_lun_list[lun]->lun_status ==
-			    TRANSPORT_LUN_STATUS_ACTIVE) {
-				if (!tpg_entry->tpg_nexus)
-					error = "nexus undefined";
-				else
-					tpg = tpg_entry;
+			mutex_lock(&tpg_entry->se_tpg.tpg_lun_mutex);
+			hlist_for_each_entry(se_lun, &tpg_entry->se_tpg.tpg_lun_hlist, link) {
+				if (se_lun->unpacked_lun == unpacked_lun) {
+					if (!tpg_entry->tpg_nexus)
+						error = "nexus undefined";
+					else
+						tpg = tpg_entry;
+					break;
+				}
 			}
-			spin_unlock(&tpg_entry->se_tpg.tpg_lun_lock);
+			mutex_unlock(&tpg_entry->se_tpg.tpg_lun_mutex);
 			break;
 		}
 	}
@@ -906,7 +909,7 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	mutex_unlock(&scsiback_mutex);
 
 	if (!tpg) {
-		pr_err("%s:%d %s\n", phy, lun, error);
+		pr_err("%s:%d %s\n", phy, unpacked_lun, error);
 		return -ENODEV;
 	}
 
@@ -934,7 +937,7 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	kref_init(&new->kref);
 	new->v = *v;
 	new->tpg = tpg;
-	new->lun = lun;
+	new->lun = unpacked_lun;
 	list_add_tail(&new->l, head);
 
 out:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 034f4a6..1049f6c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -724,6 +724,8 @@ struct se_lun {
 	struct se_port_stat_grps port_stat_grps;
 	struct completion	lun_ref_comp;
 	struct percpu_ref	lun_ref;
+	struct hlist_node	link;
+	struct rcu_head		rcu_head;
 };
 
 struct se_dev_stat_grps {
@@ -876,11 +878,11 @@ struct se_portal_group {
 	spinlock_t		acl_node_lock;
 	/* Spinlock for adding/removing sessions */
 	spinlock_t		session_lock;
-	spinlock_t		tpg_lun_lock;
+	struct mutex		tpg_lun_mutex;
 	struct list_head	se_tpg_node;
 	/* linked list for initiator ACL list */
 	struct list_head	acl_node_list;
-	struct se_lun		**tpg_lun_list;
+	struct hlist_head	tpg_lun_hlist;
 	struct se_lun		tpg_virt_lun0;
 	/* List of TCM sessions associated wth this TPG */
 	struct list_head	tpg_sess_list;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 55654c9..b1e00a7 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -157,7 +157,6 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		unsigned char *);
 struct se_node_acl *core_tpg_check_initiator_node_acl(struct se_portal_group *,
 		unsigned char *);
-void	core_tpg_clear_object_luns(struct se_portal_group *);
 int	core_tpg_set_initiator_node_queue_depth(struct se_portal_group *,
 		unsigned char *, u32, int);
 int	core_tpg_set_initiator_node_tag(struct se_portal_group *,
-- 
1.9.1

