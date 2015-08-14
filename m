From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH v2] target: remove initiatorname field in se_acl_lun
Date: Thu, 13 Aug 2015 22:43:27 -0700
Message-ID: <1439531007-2250-2-git-send-email-sbaugh@catern.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Chris Zankel <czankel@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Chris Zankel <czankel@purestorage.com>

The initiatorname field in se_acl_lun is only a copy of the same field
in se_node_acl, so remove it and use the version in se_node_acl where
needed (it's actually only used for pr_debug)

Signed-off-by: Chris Zankel <czankel@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/target/target_core_device.c          | 8 +++-----
 drivers/target/target_core_fabric_configfs.c | 2 +-
 include/target/target_core_base.h            | 1 -
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 09e682b..c4a8db6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -620,8 +620,6 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 
 	lacl->mapped_lun = mapped_lun;
 	lacl->se_lun_nacl = nacl;
-	snprintf(lacl->initiatorname, TRANSPORT_IQN_LEN, "%s",
-		 nacl->initiatorname);
 
 	return lacl;
 }
@@ -656,7 +654,7 @@ int core_dev_add_initiator_node_lun_acl(
 		" InitiatorNode: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun, lacl->mapped_lun,
 		(lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) ? "RW" : "RO",
-		lacl->initiatorname);
+		nacl->initiatorname);
 	/*
 	 * Check to see if there are any existing persistent reservation APTPL
 	 * pre-registrations that need to be enabled for this LUN ACL..
@@ -688,7 +686,7 @@ int core_dev_del_initiator_node_lun_acl(
 		" InitiatorNode: %s Mapped LUN: %llu\n",
 		tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
-		lacl->initiatorname, lacl->mapped_lun);
+		nacl->initiatorname, lacl->mapped_lun);
 
 	return 0;
 }
@@ -701,7 +699,7 @@ void core_dev_free_initiator_node_lun_acl(
 		" Mapped LUN: %llu\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		tpg->se_tpg_tfo->get_fabric_name(),
-		lacl->initiatorname, lacl->mapped_lun);
+		lacl->se_lun_nacl->initiatorname, lacl->mapped_lun);
 
 	kfree(lacl);
 }
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 48a3698..be42429 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -203,7 +203,7 @@ static ssize_t target_fabric_mappedlun_store_write_protect(
 	pr_debug("%s_ConfigFS: Changed Initiator ACL: %s"
 		" Mapped LUN: %llu Write Protect bit to %s\n",
 		se_tpg->se_tpg_tfo->get_fabric_name(),
-		lacl->initiatorname, lacl->mapped_lun, (op) ? "ON" : "OFF");
+		se_nacl->initiatorname, lacl->mapped_lun, (op) ? "ON" : "OFF");
 
 	return count;
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 0a7c44e..b59b61a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -598,7 +598,6 @@ struct se_ml_stat_grps {
 };
 
 struct se_lun_acl {
-	char			initiatorname[TRANSPORT_IQN_LEN];
 	u64			mapped_lun;
 	struct se_node_acl	*se_lun_nacl;
 	struct se_lun		*se_lun;
-- 
2.5.0.rc3
