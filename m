From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv3 3/8] target: Allocate se_dev_entrys in device list only when used
Date: Mon, 30 Jun 2014 16:39:42 -0700
Message-ID: <1404171587-28845-4-git-send-email-agrover@redhat.com>
References: <1404171587-28845-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1404171587-28845-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

Remove TRANSPORT_LUNFLAGS_INITIATOR_ACCESS and just look at if a
non-NULL value is in the node_acl->device_list for the given lun. Since
usually nowhere near all se_dev_entrys are used, this nets a sizable
reduction in memory use.

In core_disable_device_list_for_node, move all calls to functions
referencing deve inside the spinlock, since it's not safe to access deve
outside it. Skip reinitializing, since the deve is actually being freed.

Do not allocate device_list array separately, but include it in
se_node_acl.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c          | 93 ++++++++++++++++------------
 drivers/target/target_core_fabric_configfs.c |  4 +-
 drivers/target/target_core_spc.c             |  2 +-
 drivers/target/target_core_tpg.c             | 41 +-----------
 include/target/target_core_base.h            |  7 +--
 5 files changed, 59 insertions(+), 88 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 5d4a8b3..0bac890 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -67,7 +67,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 
 	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
 	se_cmd->se_deve = se_sess->se_node_acl->device_list[unpacked_lun];
-	if (se_cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
+	if (se_cmd->se_deve) {
 		struct se_dev_entry *deve = se_cmd->se_deve;
 
 		deve->total_cmds++;
@@ -143,7 +143,6 @@ EXPORT_SYMBOL(transport_lookup_cmd_lun);
 
 int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 {
-	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
@@ -154,9 +153,9 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 
 	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
 	se_cmd->se_deve = se_sess->se_node_acl->device_list[unpacked_lun];
-	deve = se_cmd->se_deve;
+	if (se_cmd->se_deve) {
+		struct se_dev_entry *deve = se_cmd->se_deve;
 
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
 		se_tmr->tmr_lun = deve->se_lun;
 		se_cmd->se_lun = deve->se_lun;
 		se_lun = deve->se_lun;
@@ -204,7 +203,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = nacl->device_list[i];
 
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		if (!deve)
 			continue;
 
 		lun = deve->se_lun;
@@ -243,14 +242,11 @@ int core_free_device_list_for_node(
 	struct se_lun *lun;
 	u32 i;
 
-	if (!nacl->device_list)
-		return 0;
-
 	spin_lock_irq(&nacl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = nacl->device_list[i];
 
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		if (!deve)
 			continue;
 
 		if (!deve->se_lun) {
@@ -268,9 +264,6 @@ int core_free_device_list_for_node(
 	}
 	spin_unlock_irq(&nacl->device_list_lock);
 
-	array_free(nacl->device_list, TRANSPORT_MAX_LUNS_PER_TPG);
-	nacl->device_list = NULL;
-
 	return 0;
 }
 
@@ -283,12 +276,14 @@ void core_update_device_list_access(
 
 	spin_lock_irq(&nacl->device_list_lock);
 	deve = nacl->device_list[mapped_lun];
-	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-	} else {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+	if (deve) {
+		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
+			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
+			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
+		} else {
+			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+		}
 	}
 	spin_unlock_irq(&nacl->device_list_lock);
 }
@@ -320,7 +315,7 @@ int core_enable_device_list_for_node(
 	 * transition.  This transition must be for the same struct se_lun
 	 * + mapped_lun that was setup in demo mode..
 	 */
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
+	if (deve) {
 		if (deve->se_lun_acl != NULL) {
 			pr_err("struct se_dev_entry->se_lun_acl"
 			       " already set for demo mode -> explicit"
@@ -348,18 +343,27 @@ int core_enable_device_list_for_node(
 		goto out;
 	}
 
+	deve = kzalloc(sizeof(*deve), GFP_ATOMIC);
+	if (!deve) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENOMEM;
+	}
+
+	nacl->device_list[mapped_lun] = deve;
+
+	atomic_set(&deve->ua_count, 0);
+	atomic_set(&deve->pr_ref_count, 0);
+	spin_lock_init(&deve->ua_lock);
+	INIT_LIST_HEAD(&deve->alua_port_list);
+	INIT_LIST_HEAD(&deve->ua_list);
 	deve->se_lun = lun;
 	deve->se_lun_acl = lun_acl;
 	deve->mapped_lun = mapped_lun;
-	deve->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
 
-	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
+	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE)
 		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-	} else {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+	else
 		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
-	}
 
 	deve->creation_time = get_jiffies_64();
 	deve->attach_count++;
@@ -387,7 +391,16 @@ int core_disable_device_list_for_node(
 	struct se_portal_group *tpg)
 {
 	struct se_port *port = lun->lun_sep;
-	struct se_dev_entry *deve = nacl->device_list[mapped_lun];
+	struct se_dev_entry *deve;
+
+	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = nacl->device_list[mapped_lun];
+	if (!deve) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return 0;
+	}
 
 	/*
 	 * If the MappedLUN entry is being disabled, the entry in
@@ -402,9 +415,18 @@ int core_disable_device_list_for_node(
 	 * NodeACL context specific PR metadata for demo-mode
 	 * MappedLUN *deve will be released below..
 	 */
-	spin_lock_bh(&port->sep_alua_lock);
+	spin_lock(&port->sep_alua_lock);
 	list_del(&deve->alua_port_list);
-	spin_unlock_bh(&port->sep_alua_lock);
+	spin_unlock(&port->sep_alua_lock);
+
+	/*
+	 * Disable struct se_dev_entry LUN ACL mapping
+	 */
+	core_scsi3_ua_release_all(deve);
+	nacl->device_list[mapped_lun] = NULL;
+
+	spin_unlock_irq(&nacl->device_list_lock);
+
 	/*
 	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
 	 * PR operation to complete.
@@ -412,19 +434,8 @@ int core_disable_device_list_for_node(
 	while (atomic_read(&deve->pr_ref_count) != 0)
 		cpu_relax();
 
-	spin_lock_irq(&nacl->device_list_lock);
-	/*
-	 * Disable struct se_dev_entry LUN ACL mapping
-	 */
-	core_scsi3_ua_release_all(deve);
-	deve->se_lun = NULL;
-	deve->se_lun_acl = NULL;
-	deve->lun_flags = 0;
-	deve->creation_time = 0;
-	deve->attach_count--;
-	spin_unlock_irq(&nacl->device_list_lock);
+	kfree(deve);
 
-	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
 	return 0;
 }
 
@@ -445,7 +456,7 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 		spin_lock_irq(&nacl->device_list_lock);
 		for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 			deve = nacl->device_list[i];
-			if (lun != deve->se_lun)
+			if (!deve || lun != deve->se_lun)
 				continue;
 			spin_unlock_irq(&nacl->device_list_lock);
 
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 804e7f0..0955c948 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -113,7 +113,7 @@ static int target_fabric_mappedlun_link(
 	 */
 	spin_lock_irq(&lacl->se_lun_nacl->device_list_lock);
 	deve = lacl->se_lun_nacl->device_list[lacl->mapped_lun];
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
+	if (deve)
 		lun_access = deve->lun_flags;
 	else
 		lun_access =
@@ -149,7 +149,7 @@ static int target_fabric_mappedlun_unlink(
 	/*
 	 * Determine if the underlying MappedLUN has already been released..
 	 */
-	if (!deve->se_lun) {
+	if (!deve || !deve->se_lun) {
 		spin_unlock_irq(&nacl->device_list_lock);
 		return 0;
 	}
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 6cd7222..cb47ffe 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1250,7 +1250,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 	spin_lock_irq(&sess->se_node_acl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = sess->se_node_acl->device_list[i];
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		if (!deve)
 			continue;
 		/*
 		 * We determine the correct LUN LIST LENGTH even once we
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 88fddcf..82a25e1 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -62,7 +62,7 @@ static void core_clear_initiator_node_from_tpg(
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = nacl->device_list[i];
 
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		if (!deve)
 			continue;
 
 		if (!deve->se_lun) {
@@ -214,35 +214,6 @@ static void *array_zalloc(int n, size_t size, gfp_t flags)
 	return a;
 }
 
-/*      core_create_device_list_for_node():
- *
- *
- */
-static int core_create_device_list_for_node(struct se_node_acl *nacl)
-{
-	struct se_dev_entry *deve;
-	int i;
-
-	nacl->device_list = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
-			sizeof(struct se_dev_entry), GFP_KERNEL);
-	if (!nacl->device_list) {
-		pr_err("Unable to allocate memory for"
-			" struct se_node_acl->device_list\n");
-		return -ENOMEM;
-	}
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = nacl->device_list[i];
-
-		atomic_set(&deve->ua_count, 0);
-		atomic_set(&deve->pr_ref_count, 0);
-		spin_lock_init(&deve->ua_lock);
-		INIT_LIST_HEAD(&deve->alua_port_list);
-		INIT_LIST_HEAD(&deve->ua_list);
-	}
-
-	return 0;
-}
-
 /*	core_tpg_check_initiator_node_acl()
  *
  *
@@ -279,11 +250,6 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 
 	tpg->se_tpg_tfo->set_default_node_attributes(acl);
 
-	if (core_create_device_list_for_node(acl) < 0) {
-		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
-		return NULL;
-	}
-
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
 		core_free_device_list_for_node(acl, tpg);
 		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
@@ -405,11 +371,6 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 
 	tpg->se_tpg_tfo->set_default_node_attributes(acl);
 
-	if (core_create_device_list_for_node(acl) < 0) {
-		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
 		core_free_device_list_for_node(acl, tpg);
 		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9ec9864..f3761da 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -174,9 +174,8 @@ enum se_cmd_flags_table {
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
 enum transport_lunflags_table {
 	TRANSPORT_LUNFLAGS_NO_ACCESS		= 0x00,
-	TRANSPORT_LUNFLAGS_INITIATOR_ACCESS	= 0x01,
-	TRANSPORT_LUNFLAGS_READ_ONLY		= 0x02,
-	TRANSPORT_LUNFLAGS_READ_WRITE		= 0x04,
+	TRANSPORT_LUNFLAGS_READ_ONLY		= 0x01,
+	TRANSPORT_LUNFLAGS_READ_WRITE		= 0x02,
 };
 
 /*
@@ -589,7 +588,7 @@ struct se_node_acl {
 	char			acl_tag[MAX_ACL_TAG_SIZE];
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		acl_pr_ref_count;
-	struct se_dev_entry	**device_list;
+	struct se_dev_entry	*device_list[TRANSPORT_MAX_LUNS_PER_TPG];
 	struct se_session	*nacl_sess;
 	struct se_portal_group *se_tpg;
 	spinlock_t		device_list_lock;
-- 
1.9.3
