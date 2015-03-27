From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 17/22] target: Drop core_tpg_clear_object_luns
Date: Fri, 27 Mar 2015 08:05:07 +0000
Message-ID: <1427443512-8925-18-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33837 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbbC0IG2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:28 -0400
Received: by oigz129 with SMTP id z129so25143640oig.1
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:27 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_tpg.c |  2 --
 drivers/target/target_core_tpg.c        | 21 ---------------------
 include/target/target_core_fabric.h     |  1 -
 3 files changed, 24 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index bdd127c..2261c8c 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -284,8 +284,6 @@ int iscsit_tpg_del_portal_group(
 		return -EPERM;
 	}
 
-	core_tpg_clear_object_luns(&tpg->tpg_se_tpg);
-
 	if (tpg->param_list) {
 		iscsi_release_param_list(tpg->param_list);
 		tpg->param_list = NULL;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index a1849ce..f197618 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -325,27 +325,6 @@ void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
 		cpu_relax();
 }
 
-void core_tpg_clear_object_luns(struct se_portal_group *tpg)
-{
-	int i;
-	struct se_lun *lun;
-
-	mutex_lock(&tpg->tpg_lun_mutex);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		lun = tpg->tpg_lun_list[i];
-
-		if ((lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) ||
-		    (lun->lun_se_dev == NULL))
-			continue;
-
-		mutex_unlock(&tpg->tpg_lun_mutex);
-		core_dev_del_lun(tpg, lun);
-		mutex_lock(&tpg->tpg_lun_mutex);
-	}
-	mutex_unlock(&tpg->tpg_lun_mutex);
-}
-EXPORT_SYMBOL(core_tpg_clear_object_luns);
-
 /*	core_tpg_add_initiator_node_acl():
  *
  *
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 9811c85..578fc93 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -152,7 +152,6 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		unsigned char *);
 struct se_node_acl *core_tpg_check_initiator_node_acl(struct se_portal_group *,
 		unsigned char *);
-void	core_tpg_clear_object_luns(struct se_portal_group *);
 struct se_node_acl *core_tpg_add_initiator_node_acl(struct se_portal_group *,
 		struct se_node_acl *, const char *, u32);
 int	core_tpg_del_initiator_node_acl(struct se_portal_group *,
-- 
1.9.1

