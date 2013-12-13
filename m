From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 15/32] target: Refer to u32 luns as unpacked_lun
Date: Fri, 13 Dec 2013 15:59:03 -0800
Message-ID: <1386979160-6928-16-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab3LMX7d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:33 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

It's clearer to refer to pointers to the struct se_lun as "lun" and the
actual number itself as "unpacked_lun".

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7b5697a..da290f6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1096,23 +1096,23 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 struct se_lun *core_dev_add_lun(
 	struct se_portal_group *tpg,
 	struct se_device *dev,
-	u32 lun)
+	u32 unpacked_lun)
 {
-	struct se_lun *lun_p;
+	struct se_lun *lun;
 	int rc;
 
-	lun_p = core_tpg_pre_addlun(tpg, lun);
-	if (IS_ERR(lun_p))
-		return lun_p;
+	lun = core_tpg_pre_addlun(tpg, unpacked_lun);
+	if (IS_ERR(lun))
+		return lun;
 
-	rc = core_tpg_post_addlun(tpg, lun_p,
+	rc = core_tpg_post_addlun(tpg, lun,
 				TRANSPORT_LUNFLAGS_READ_WRITE, dev);
 	if (rc < 0)
 		return ERR_PTR(rc);
 
 	pr_debug("%s_TPG[%u]_LUN[%u] - Activated %s Logical Unit from"
 		" CORE HBA: %u\n", tpg->se_tpg_tfo->get_fabric_name(),
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun_p->unpacked_lun,
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
 		tpg->se_tpg_tfo->get_fabric_name(), dev->se_hba->hba_id);
 	/*
 	 * Update LUN maps for dynamically added initiators when
@@ -1133,7 +1133,7 @@ struct se_lun *core_dev_add_lun(
 		spin_unlock_irq(&tpg->acl_node_lock);
 	}
 
-	return lun_p;
+	return lun;
 }
 
 /*      core_dev_del_lun():
-- 
1.7.1

