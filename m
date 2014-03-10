From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 8/9] target: Remove core_tpg_release_virtual_lun0 function
Date: Mon, 10 Mar 2014 15:45:52 -0700
Message-ID: <1394491553-3939-9-git-send-email-agrover@redhat.com>
References: <1394491553-3939-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbaCJWp6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2014 18:45:58 -0400
In-Reply-To: <1394491553-3939-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Simple and just called from one place.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_tpg.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index a63a3d7..bc0299a 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -591,13 +591,6 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	return 0;
 }
 
-static void core_tpg_release_virtual_lun0(struct se_portal_group *se_tpg)
-{
-	struct se_lun *lun = &se_tpg->tpg_virt_lun0;
-
-	core_tpg_remove_lun(se_tpg, lun);
-}
-
 int core_tpg_register(
 	struct target_core_fabric_ops *tfo,
 	struct se_wwn *se_wwn,
@@ -673,7 +666,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	spin_unlock_irq(&se_tpg->acl_node_lock);
 
 	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL)
-		core_tpg_release_virtual_lun0(se_tpg);
+		core_tpg_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
 
 	se_tpg->se_tpg_fabric_ptr = NULL;
 
-- 
1.8.5.3

