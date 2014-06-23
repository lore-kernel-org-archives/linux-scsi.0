From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 RESENDv2 4/9] target: core_tpg_post_dellun can return void
Date: Mon, 23 Jun 2014 16:55:33 -0700
Message-ID: <1403567738-13310-5-git-send-email-agrover@redhat.com>
References: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

Nothing in it can raise an error.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_internal.h | 2 +-
 drivers/target/target_core_tpg.c      | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index de9cab7..463fddc 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -83,7 +83,7 @@ struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		u32, struct se_device *);
 struct se_lun *core_tpg_pre_dellun(struct se_portal_group *, u32 unpacked_lun);
-int	core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
+void core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
 
 /* target_core_transport.c */
 extern struct kmem_cache *se_tmr_req_cache;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 82a25e1..321268d 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -825,18 +825,15 @@ struct se_lun *core_tpg_pre_dellun(
 	return lun;
 }
 
-int core_tpg_post_dellun(
+void core_tpg_post_dellun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
 	core_clear_lun_from_tpg(lun, tpg);
 	transport_clear_lun_ref(lun);
-
 	core_dev_unexport(lun->lun_se_dev, tpg, lun);
 
 	spin_lock(&tpg->tpg_lun_lock);
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	spin_unlock(&tpg->tpg_lun_lock);
-
-	return 0;
 }
-- 
1.9.3
