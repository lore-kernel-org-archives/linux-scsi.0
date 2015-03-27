From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 12/22] target: Convert se_tpg->tpg_lun_lock to ->tpg_lun_mutex
Date: Fri, 27 Mar 2015 08:05:02 +0000
Message-ID: <1427443512-8925-13-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35049 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbbC0IGU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:20 -0400
Received: by obcjt1 with SMTP id jt1so65621750obc.2
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:19 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Now that se_node_acl->lun_entry_hlist[] is using RCU, convert existing
se_tpg->tpg_lun_lock to struct mutex so core_tpg_add_node_to_devs()
can perform RCU updater logic without releasing ->tpg_lun_mutex.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/sbp/sbp_target.c     | 16 ++++++----------
 drivers/target/target_core_device.c | 18 ++++++++----------
 drivers/target/target_core_tpg.c    | 25 +++++++++++--------------
 include/target/target_core_base.h   |  2 +-
 4 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 9512af6..ec46968 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -184,13 +184,13 @@ static struct se_lun *sbp_get_lun_from_tpg(struct sbp_tpg *tpg, int lun)
 	if (lun >= TRANSPORT_MAX_LUNS_PER_TPG)
 		return ERR_PTR(-EINVAL);
 
-	spin_lock(&se_tpg->tpg_lun_lock);
+	mutex_lock(&se_tpg->tpg_lun_mutex);
 	se_lun = se_tpg->tpg_lun_list[lun];
 
 	if (se_lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
 		se_lun = ERR_PTR(-ENODEV);
 
-	spin_unlock(&se_tpg->tpg_lun_lock);
+	mutex_unlock(&se_tpg->tpg_lun_mutex);
 
 	return se_lun;
 }
@@ -1943,7 +1943,7 @@ static int sbp_count_se_tpg_luns(struct se_portal_group *tpg)
 {
 	int i, count = 0;
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		struct se_lun *se_lun = tpg->tpg_lun_list[i];
 
@@ -1952,7 +1952,7 @@ static int sbp_count_se_tpg_luns(struct se_portal_group *tpg)
 
 		count++;
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	return count;
 }
@@ -2021,7 +2021,7 @@ static int sbp_update_unit_directory(struct sbp_tport *tport)
 	/* unit unique ID (leaf is just after LUNs) */
 	data[idx++] = 0x8d000000 | (num_luns + 1);
 
-	spin_lock(&tport->tpg->se_tpg.tpg_lun_lock);
+	mutex_lock(&tport->tpg->se_tpg.tpg_lun_mutex);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		struct se_lun *se_lun = tport->tpg->se_tpg.tpg_lun_list[i];
 		struct se_device *dev;
@@ -2030,8 +2030,6 @@ static int sbp_update_unit_directory(struct sbp_tport *tport)
 		if (se_lun->lun_status == TRANSPORT_LUN_STATUS_FREE)
 			continue;
 
-		spin_unlock(&tport->tpg->se_tpg.tpg_lun_lock);
-
 		dev = se_lun->lun_se_dev;
 		type = dev->transport->get_device_type(dev);
 
@@ -2039,10 +2037,8 @@ static int sbp_update_unit_directory(struct sbp_tport *tport)
 		data[idx++] = 0x14000000 |
 			((type << 16) & 0x1f0000) |
 			(se_lun->unpacked_lun & 0xffff);
-
-		spin_lock(&tport->tpg->se_tpg.tpg_lun_lock);
 	}
-	spin_unlock(&tport->tpg->se_tpg.tpg_lun_lock);
+	mutex_unlock(&tport->tpg->se_tpg.tpg_lun_mutex);
 
 	/* unit unique ID leaf */
 	data[idx++] = 2 << 16;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 670b1b5..014c1b6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1267,27 +1267,26 @@ struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_l
 {
 	struct se_lun *lun;
 
-	spin_lock(&tpg->tpg_lun_lock);
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
 		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS"
 			"_PER_TPG-1: %u for Target Portal Group: %hu\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			TRANSPORT_MAX_LUNS_PER_TPG-1,
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
 		return NULL;
 	}
-	lun = tpg->tpg_lun_list[unpacked_lun];
 
+	mutex_lock(&tpg->tpg_lun_mutex);
+	lun = tpg->tpg_lun_list[unpacked_lun];
 	if (lun->lun_status != TRANSPORT_LUN_STATUS_FREE) {
 		pr_err("%s Logical Unit Number: %u is not free on"
 			" Target Portal Group: %hu, ignoring request.\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
+		mutex_unlock(&tpg->tpg_lun_mutex);
 		return NULL;
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	return lun;
 }
@@ -1300,27 +1299,26 @@ static struct se_lun *core_dev_get_lun(struct se_portal_group *tpg, u32 unpacked
 {
 	struct se_lun *lun;
 
-	spin_lock(&tpg->tpg_lun_lock);
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
 		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER"
 			"_TPG-1: %u for Target Portal Group: %hu\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			TRANSPORT_MAX_LUNS_PER_TPG-1,
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
 		return NULL;
 	}
-	lun = tpg->tpg_lun_list[unpacked_lun];
 
+	mutex_lock(&tpg->tpg_lun_mutex);
+	lun = tpg->tpg_lun_list[unpacked_lun];
 	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
 		pr_err("%s Logical Unit Number: %u is not active on"
 			" Target Portal Group: %hu, ignoring request.\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
+		mutex_unlock(&tpg->tpg_lun_mutex);
 		return NULL;
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	return lun;
 }
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 2813bd4..1a12532 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -132,14 +132,12 @@ void core_tpg_add_node_to_devs(
 	struct se_lun *lun;
 	struct se_device *dev;
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		lun = tpg->tpg_lun_list[i];
 		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
 			continue;
 
-		spin_unlock(&tpg->tpg_lun_lock);
-
 		dev = lun->lun_se_dev;
 		/*
 		 * By default in LIO-Target $FABRIC_MOD,
@@ -166,7 +164,7 @@ void core_tpg_add_node_to_devs(
 			"READ-WRITE" : "READ-ONLY");
 
 		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
-				lun_access, acl, tpg);
+						 lun_access, acl, tpg);
 		/*
 		 * Check to see if there are any existing persistent reservation
 		 * APTPL pre-registrations that need to be enabled for this dynamic
@@ -174,9 +172,8 @@ void core_tpg_add_node_to_devs(
 		 */
 		core_scsi3_check_aptpl_registration(dev, tpg, lun, acl,
 						    lun->unpacked_lun);
-		spin_lock(&tpg->tpg_lun_lock);
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 }
 
 /*      core_set_queue_depth_for_node():
@@ -713,7 +710,7 @@ int core_tpg_register(
 	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
 	spin_lock_init(&se_tpg->acl_node_lock);
 	spin_lock_init(&se_tpg->session_lock);
-	spin_lock_init(&se_tpg->tpg_lun_lock);
+	mutex_init(&se_tpg->tpg_lun_mutex);
 
 	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) {
 		if (core_tpg_setup_virtual_lun0(se_tpg) < 0) {
@@ -798,17 +795,17 @@ struct se_lun *core_tpg_alloc_lun(
 		return ERR_PTR(-EOVERFLOW);
 	}
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	lun = tpg->tpg_lun_list[unpacked_lun];
 	if (lun->lun_status == TRANSPORT_LUN_STATUS_ACTIVE) {
 		pr_err("TPG Logical Unit Number: %u is already active"
 			" on %s Target Portal Group: %u, ignoring request.\n",
 			unpacked_lun, tpg->se_tpg_tfo->get_fabric_name(),
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
+		mutex_unlock(&tpg->tpg_lun_mutex);
 		return ERR_PTR(-EINVAL);
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	return lun;
 }
@@ -832,10 +829,10 @@ int core_tpg_add_lun(
 		return ret;
 	}
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	lun->lun_access = lun_access;
 	lun->lun_status = TRANSPORT_LUN_STATUS_ACTIVE;
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	return 0;
 }
@@ -849,9 +846,9 @@ void core_tpg_remove_lun(
 
 	core_dev_unexport(lun->lun_se_dev, tpg, lun);
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	percpu_ref_exit(&lun->lun_ref);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 040138a..5a7a8fa 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -883,7 +883,7 @@ struct se_portal_group {
 	spinlock_t		acl_node_lock;
 	/* Spinlock for adding/removing sessions */
 	spinlock_t		session_lock;
-	spinlock_t		tpg_lun_lock;
+	struct mutex		tpg_lun_mutex;
 	/* Pointer to $FABRIC_MOD portal group */
 	void			*se_tpg_fabric_ptr;
 	struct list_head	se_tpg_node;
-- 
1.9.1

