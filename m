From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/6] target: Allocate se_dev_entrys in device list only when used
Date: Thu,  6 Mar 2014 14:15:26 -0800
Message-ID: <1394144131-31499-2-git-send-email-agrover@redhat.com>
References: <1394144131-31499-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1394144131-31499-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove TRANSPORT_LUNFLAGS_INITIATOR_ACCESS and just look at if a
non-NULL value is in the node_acl->device_list for the given lun. Since
usually nowhere near all se_dev_entrys are used, this nets a sizable
reduction in memory use.

In core_disable_device_list_for_node, move all calls to functions
referencing deve inside the spinlock, since it's not safe to access deve
outside it. Skip reinitializing, since the deve is actually being freed.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c          | 108 +++++++++++++++------------
 drivers/target/target_core_fabric_configfs.c |   2 +-
 drivers/target/target_core_spc.c             |   2 +-
 drivers/target/target_core_tpg.c             |  18 +----
 include/target/target_core_base.h            |   5 +-
 5 files changed, 69 insertions(+), 66 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 65001e1..234498b 100644
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
@@ -250,7 +249,7 @@ int core_free_device_list_for_node(
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = nacl->device_list[i];
 
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		if (!deve)
 			continue;
 
 		if (!deve->se_lun) {
@@ -268,7 +267,7 @@ int core_free_device_list_for_node(
 	}
 	spin_unlock_irq(&nacl->device_list_lock);
 
-	array_free(nacl->device_list, TRANSPORT_MAX_LUNS_PER_TPG);
+	kfree(nacl->device_list);
 	nacl->device_list = NULL;
 
 	return 0;
@@ -283,12 +282,14 @@ void core_update_device_list_access(
 
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
@@ -306,7 +307,12 @@ int core_enable_device_list_for_node(
 	struct se_portal_group *tpg)
 {
 	struct se_port *port = lun->lun_sep;
-	struct se_dev_entry *deve;
+	struct se_dev_entry *deve, *new_deve;
+
+	/* Likely allocing a new deve, so alloc first, outside lock */
+	new_deve = kzalloc(sizeof(*new_deve), GFP_KERNEL);
+	if (!new_deve)
+		return -ENOMEM;
 
 	spin_lock_irq(&nacl->device_list_lock);
 
@@ -317,7 +323,8 @@ int core_enable_device_list_for_node(
 	 * transition.  This transition must be for the same struct se_lun
 	 * + mapped_lun that was setup in demo mode..
 	 */
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
+	if (deve) {
+		kfree(new_deve);
 		if (deve->se_lun_acl != NULL) {
 			pr_err("struct se_dev_entry->se_lun_acl"
 			       " already set for demo mode -> explicit"
@@ -346,25 +353,28 @@ int core_enable_device_list_for_node(
 		return 0;
 	}
 
-	deve->se_lun = lun;
-	deve->se_lun_acl = lun_acl;
-	deve->mapped_lun = mapped_lun;
-	deve->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
+	nacl->device_list[mapped_lun] = new_deve;
 
-	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-	} else {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
-	}
+	atomic_set(&new_deve->ua_count, 0);
+	atomic_set(&new_deve->pr_ref_count, 0);
+	spin_lock_init(&new_deve->ua_lock);
+	INIT_LIST_HEAD(&new_deve->alua_port_list);
+	INIT_LIST_HEAD(&new_deve->ua_list);
+	new_deve->se_lun = lun;
+	new_deve->se_lun_acl = lun_acl;
+	new_deve->mapped_lun = mapped_lun;
 
-	deve->creation_time = get_jiffies_64();
-	deve->attach_count++;
+	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE)
+		new_deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
+	else
+		new_deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+
+	new_deve->creation_time = get_jiffies_64();
+	new_deve->attach_count++;
 	spin_unlock_irq(&nacl->device_list_lock);
 
 	spin_lock_bh(&port->sep_alua_lock);
-	list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
+	list_add_tail(&new_deve->alua_port_list, &port->sep_alua_list);
 	spin_unlock_bh(&port->sep_alua_lock);
 
 	return 0;
@@ -383,7 +393,23 @@ int core_disable_device_list_for_node(
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
+
+	/*
+	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
+	 * PR operation to complete.
+	 */
+	while (atomic_read(&deve->pr_ref_count) != 0)
+		cpu_relax();
 
 	/*
 	 * If the MappedLUN entry is being disabled, the entry in
@@ -398,29 +424,19 @@ int core_disable_device_list_for_node(
 	 * NodeACL context specific PR metadata for demo-mode
 	 * MappedLUN *deve will be released below..
 	 */
-	spin_lock_bh(&port->sep_alua_lock);
+	spin_lock(&port->sep_alua_lock);
 	list_del(&deve->alua_port_list);
-	spin_unlock_bh(&port->sep_alua_lock);
-	/*
-	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
-	 * PR operation to complete.
-	 */
-	while (atomic_read(&deve->pr_ref_count) != 0)
-		cpu_relax();
+	spin_unlock(&port->sep_alua_lock);
 
-	spin_lock_irq(&nacl->device_list_lock);
 	/*
 	 * Disable struct se_dev_entry LUN ACL mapping
 	 */
 	core_scsi3_ua_release_all(deve);
-	deve->se_lun = NULL;
-	deve->se_lun_acl = NULL;
-	deve->lun_flags = 0;
-	deve->creation_time = 0;
-	deve->attach_count--;
+	nacl->device_list[mapped_lun] = NULL;
+	kfree(deve);
+
 	spin_unlock_irq(&nacl->device_list_lock);
 
-	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
 	return 0;
 }
 
@@ -441,7 +457,7 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 		spin_lock_irq(&nacl->device_list_lock);
 		for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 			deve = nacl->device_list[i];
-			if (lun != deve->se_lun)
+			if (!deve || lun != deve->se_lun)
 				continue;
 			spin_unlock_irq(&nacl->device_list_lock);
 
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7de9f04..635c857 100644
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
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 43c5ca98..d91cce7 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1239,7 +1239,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 	spin_lock_irq(&sess->se_node_acl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = sess->se_node_acl->device_list[i];
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		if (!deve)
 			continue;
 		/*
 		 * We determine the correct LUN LIST LENGTH even once we
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c036595..fbed75f 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -62,7 +62,7 @@ static void core_clear_initiator_node_from_tpg(
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = nacl->device_list[i];
 
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		if (!deve)
 			continue;
 
 		if (!deve->se_lun) {
@@ -223,25 +223,13 @@ static void *array_zalloc(int n, size_t size, gfp_t flags)
  */
 static int core_create_device_list_for_node(struct se_node_acl *nacl)
 {
-	struct se_dev_entry *deve;
-	int i;
-
-	nacl->device_list = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
-			sizeof(struct se_dev_entry), GFP_KERNEL);
+	nacl->device_list = kzalloc(TRANSPORT_MAX_LUNS_PER_TPG * sizeof(void*),
+				    GFP_KERNEL);
 	if (!nacl->device_list) {
 		pr_err("Unable to allocate memory for"
 			" struct se_node_acl->device_list\n");
 		return -ENOMEM;
 	}
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = nacl->device_list[i];
-
-		atomic_set(&deve->ua_count, 0);
-		atomic_set(&deve->pr_ref_count, 0);
-		spin_lock_init(&deve->ua_lock);
-		INIT_LIST_HEAD(&deve->alua_port_list);
-		INIT_LIST_HEAD(&deve->ua_list);
-	}
 
 	return 0;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c9c7912..0c10d75 100644
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
-- 
1.8.5.3
