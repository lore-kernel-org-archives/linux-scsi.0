From: Spencer Baugh <spencer.baugh@purestorage.com>
Subject: [PATCH 2/2] target: remove initiatorname field in se_acl_lun
Date: Mon, 20 Jul 2015 16:29:50 -0700
Message-ID: <1437434990-13452-2-git-send-email-Spencer.baugh@purestorage.com>
References: <1437434990-13452-1-git-send-email-Spencer.baugh@purestorage.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34399 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247AbbGTXaE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2015 19:30:04 -0400
Received: by pdbbh15 with SMTP id bh15so63180700pdb.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2015 16:30:03 -0700 (PDT)
In-Reply-To: <1437434990-13452-1-git-send-email-Spencer.baugh@purestorage.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Spencer Baugh <sbaugh@catern.com>, Chris Zankel <czankel@purestorage.com>

From: Spencer Baugh <sbaugh@catern.com>

From: Chris Zankel <czankel@purestorage.com>

The initiatorname field in se_acl_lun is only a copy of the same field
in se_node_acl, so remove it and use the version in se_node_acl where
needed (it's actually only used for pr_debug)

Signed-off-by: Chris Zankel <czankel@purestorage.com>
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
2.4.3

