From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 4/6] target: Rename core_tpg_post_dellun to remove_lun
Date: Thu,  6 Mar 2014 14:15:29 -0800
Message-ID: <1394144131-31499-5-git-send-email-agrover@redhat.com>
References: <1394144131-31499-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaCFWPi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Mar 2014 17:15:38 -0500
In-Reply-To: <1394144131-31499-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

A clearer name, now that pre_dellun is gone.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c   | 2 +-
 drivers/target/target_core_internal.h | 2 +-
 drivers/target/target_core_tpg.c      | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c98a82a..cb69413 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1270,7 +1270,7 @@ void core_dev_del_lun(
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
 		tpg->se_tpg_tfo->get_fabric_name());
 
-	core_tpg_post_dellun(tpg, lun);
+	core_tpg_remove_lun(tpg, lun);
 }
 
 struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_lun)
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 22c4261..42ef4ab 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -82,7 +82,7 @@ void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		u32, struct se_device *);
-void core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
+void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
 
 /* target_core_transport.c */
 extern struct kmem_cache *se_tmr_req_cache;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 3b07e27..914a0a6 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -655,7 +655,7 @@ static void core_tpg_release_virtual_lun0(struct se_portal_group *se_tpg)
 {
 	struct se_lun *lun = &se_tpg->tpg_virt_lun0;
 
-	core_tpg_post_dellun(se_tpg, lun);
+	core_tpg_remove_lun(se_tpg, lun);
 }
 
 int core_tpg_register(
@@ -825,7 +825,7 @@ int core_tpg_add_lun(
 	return 0;
 }
 
-void core_tpg_post_dellun(
+void core_tpg_remove_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
-- 
1.8.5.3

