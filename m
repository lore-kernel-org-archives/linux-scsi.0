From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] target: Remove TARGET_MAX_LUNS_PER_TRANSPORT
Date: Wed, 10 Jun 2015 08:41:23 +0200
Message-ID: <1433918483-46849-3-git-send-email-hare@suse.de>
References: <1433918483-46849-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbbFJGl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 02:41:26 -0400
In-Reply-To: <1433918483-46849-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

LUN allocation is now fully dynamic, so there is no need to
artificially restrain the number of exported LUNs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_device.c          | 9 ---------
 drivers/target/target_core_fabric_configfs.c | 8 --------
 drivers/target/target_core_tpg.c             | 9 ---------
 drivers/xen/xen-scsiback.c                   | 7 ++++---
 include/target/target_core_base.h            | 3 ---
 5 files changed, 4 insertions(+), 32 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 6fe4223..650613e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -63,9 +63,6 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_dev_entry *deve;
 
-	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG)
-		return TCM_NON_EXISTENT_LUN;
-
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, unpacked_lun);
 	if (deve) {
@@ -156,9 +153,6 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 	unsigned long flags;
 
-	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG)
-		return -ENODEV;
-
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, unpacked_lun);
 	if (deve) {
@@ -197,9 +191,6 @@ bool target_lun_is_rdonly(struct se_cmd *cmd)
 	struct se_dev_entry *deve;
 	bool ret;
 
-	if (cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY)
-		return true;
-
 	rcu_read_lock();
 	deve = target_nacl_find_deve(se_sess->se_node_acl, cmd->orig_fe_lun);
 	ret = (deve && deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 2fd493e..6cfee59 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -353,14 +353,6 @@ static struct config_group *target_fabric_make_mappedlun(
 	ret = kstrtoull(buf + 4, 0, &mapped_lun);
 	if (ret)
 		goto out;
-	if (mapped_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		pr_err("Mapped LUN: %llu exceeds TRANSPORT_MAX_LUNS_PER_TPG"
-			"-1: %u for Target Portal Group: %u\n", mapped_lun,
-			TRANSPORT_MAX_LUNS_PER_TPG-1,
-			se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
-		ret = -EINVAL;
-		goto out;
-	}
 
 	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, se_nacl,
 			mapped_lun, &ret);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 82ed8a0..aa39bc8 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -602,15 +602,6 @@ struct se_lun *core_tpg_alloc_lun(
 {
 	struct se_lun *lun;
 
-	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		pr_err("%s LUN: %llu exceeds TRANSPORT_MAX_LUNS_PER_TPG"
-			"-1: %u for Target Portal Group: %u\n",
-			tpg->se_tpg_tfo->get_fabric_name(),
-			unpacked_lun, TRANSPORT_MAX_LUNS_PER_TPG-1,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		return ERR_PTR(-EOVERFLOW);
-	}
-
 	lun = kzalloc(sizeof(*lun), GFP_KERNEL);
 	if (!lun) {
 		pr_err("Unable to allocate se_lun memory\n");
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 25144a0..10d6780 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -864,7 +864,7 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	struct list_head *head = &(info->v2p_entry_lists);
 	unsigned long flags;
 	char *lunp;
-	unsigned int unpacked_lun;
+	unsigned long long unpacked_lun;
 	struct se_lun *se_lun;
 	struct scsiback_tpg *tpg_entry, *tpg = NULL;
 	char *error = "doesn't exist";
@@ -876,9 +876,10 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	}
 	*lunp = 0;
 	lunp++;
-	if (kstrtouint(lunp, 10, &unpacked_lun) || unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
+	err = kstrtoull(lunp, 10, &unpacked_lun);
+	if (err < 0) {
 		pr_err("lun number not valid: %s\n", lunp);
-		return -EINVAL;
+		return err;
 	}
 
 	mutex_lock(&scsiback_mutex);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 64de2bd..d30271e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -13,9 +13,6 @@
 #define TARGET_CORE_MOD_VERSION		"v4.1.0"
 #define TARGET_CORE_VERSION		TARGET_CORE_MOD_VERSION
 
-/* Maximum Number of LUNs per Target Portal Group */
-/* Don't raise above 511 or REPORT_LUNS needs to handle >1 page */
-#define TRANSPORT_MAX_LUNS_PER_TPG		256
 /*
  * By default we use 32-byte CDBs in TCM Core and subsystem plugin code.
  *
-- 
1.8.5.2

