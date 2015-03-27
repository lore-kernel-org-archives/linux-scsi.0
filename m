From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 16/22] target: Drop se_lun->lun_acl_list
Date: Fri, 27 Mar 2015 08:05:06 +0000
Message-ID: <1427443512-8925-17-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35254 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbbC0IG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:26 -0400
Received: by oiag65 with SMTP id g65so69894224oia.2
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:26 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 13 -------------
 drivers/target/target_core_tpg.c    |  4 ----
 include/target/target_core_base.h   |  3 ---
 3 files changed, 20 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2a5fa88..80d1b04 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1338,7 +1338,6 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 		return NULL;
 	}
 
-	INIT_LIST_HEAD(&lacl->lacl_list);
 	lacl->mapped_lun = mapped_lun;
 	lacl->se_lun_nacl = nacl;
 	snprintf(lacl->initiatorname, TRANSPORT_IQN_LEN, "%s",
@@ -1379,11 +1378,6 @@ int core_dev_add_initiator_node_lun_acl(
 			lun_access, nacl, tpg) < 0)
 		return -EINVAL;
 
-	spin_lock(&lun->lun_acl_lock);
-	list_add_tail(&lacl->lacl_list, &lun->lun_acl_list);
-	atomic_inc_mb(&lun->lun_acl_count);
-	spin_unlock(&lun->lun_acl_lock);
-
 	pr_debug("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
 		" InitiatorNode: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), unpacked_lun, lacl->mapped_lun,
@@ -1413,11 +1407,6 @@ int core_dev_del_initiator_node_lun_acl(
 	if (!nacl)
 		return -EINVAL;
 
-	spin_lock(&lun->lun_acl_lock);
-	list_del(&lacl->lacl_list);
-	atomic_dec_mb(&lun->lun_acl_count);
-	spin_unlock(&lun->lun_acl_lock);
-
 	core_disable_device_list_for_node(lun, NULL, lacl->mapped_lun,
 		TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
 
@@ -1552,8 +1541,6 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	xcopy_lun = &dev->xcopy_lun;
 	xcopy_lun->lun_se_dev = dev;
 	init_completion(&xcopy_lun->lun_shutdown_comp);
-	INIT_LIST_HEAD(&xcopy_lun->lun_acl_list);
-	spin_lock_init(&xcopy_lun->lun_acl_lock);
 	spin_lock_init(&xcopy_lun->lun_sep_lock);
 	init_completion(&xcopy_lun->lun_ref_comp);
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index b5b4053..a1849ce 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -655,8 +655,6 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
-	INIT_LIST_HEAD(&lun->lun_acl_list);
-	spin_lock_init(&lun->lun_acl_lock);
 	spin_lock_init(&lun->lun_sep_lock);
 	init_completion(&lun->lun_ref_comp);
 
@@ -692,8 +690,6 @@ int core_tpg_register(
 		lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 		atomic_set(&lun->lun_acl_count, 0);
 		init_completion(&lun->lun_shutdown_comp);
-		INIT_LIST_HEAD(&lun->lun_acl_list);
-		spin_lock_init(&lun->lun_acl_lock);
 		spin_lock_init(&lun->lun_sep_lock);
 		init_completion(&lun->lun_ref_comp);
 	}
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index ab25709..f24976d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -646,7 +646,6 @@ struct se_lun_acl {
 	u32			mapped_lun;
 	struct se_node_acl	*se_lun_nacl;
 	struct se_lun		*se_lun;
-	struct list_head	lacl_list;
 	struct config_group	se_lun_group;
 	struct se_ml_stat_grps	ml_stat_grps;
 };
@@ -724,10 +723,8 @@ struct se_lun {
 	u32			lun_flags;
 	u32			unpacked_lun;
 	atomic_t		lun_acl_count;
-	spinlock_t		lun_acl_lock;
 	spinlock_t		lun_sep_lock;
 	struct completion	lun_shutdown_comp;
-	struct list_head	lun_acl_list;
 	struct se_device	*lun_se_dev;
 	struct se_port		*lun_sep;
 	struct config_group	lun_group;
-- 
1.9.1

