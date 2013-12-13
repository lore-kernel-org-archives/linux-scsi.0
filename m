From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 16/32] target: Rename core_tpg_{pre,post}_addlun for clarity
Date: Fri, 13 Dec 2013 15:59:04 -0800
Message-ID: <1386979160-6928-17-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab3LMX7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:34 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

"pre" is really an allocation function. The only time it isn't called is
for virtual_lun0, which is statically allocated. Renaming that to "alloc"
lets the other function not need to be "post", and just be called
core_tpg_add_lun.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c   |    4 ++--
 drivers/target/target_core_internal.h |    4 ++--
 drivers/target/target_core_tpg.c      |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index da290f6..faa17a4 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1101,11 +1101,11 @@ struct se_lun *core_dev_add_lun(
 	struct se_lun *lun;
 	int rc;
 
-	lun = core_tpg_pre_addlun(tpg, unpacked_lun);
+	lun = core_tpg_alloc_lun(tpg, unpacked_lun);
 	if (IS_ERR(lun))
 		return lun;
 
-	rc = core_tpg_post_addlun(tpg, lun,
+	rc = core_tpg_add_lun(tpg, lun,
 				TRANSPORT_LUNFLAGS_READ_WRITE, dev);
 	if (rc < 0)
 		return ERR_PTR(rc);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index fddf44c..4093936 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -87,8 +87,8 @@ struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tp
 		const char *);
 void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *);
 void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
-struct se_lun *core_tpg_pre_addlun(struct se_portal_group *, u32);
-int	core_tpg_post_addlun(struct se_portal_group *, struct se_lun *,
+struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
+int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		u32, void *);
 struct se_lun *core_tpg_pre_dellun(struct se_portal_group *, u32 unpacked_lun);
 int	core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 2f6df57..55a9d38 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -658,7 +658,7 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	spin_lock_init(&lun->lun_sep_lock);
 	init_completion(&lun->lun_ref_comp);
 
-	ret = core_tpg_post_addlun(se_tpg, lun, lun_access, dev);
+	ret = core_tpg_add_lun(se_tpg, lun, lun_access, dev);
 	if (ret < 0) {
 		percpu_ref_cancel_init(&lun->lun_ref);
 		return ret;
@@ -785,7 +785,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 }
 EXPORT_SYMBOL(core_tpg_deregister);
 
-struct se_lun *core_tpg_pre_addlun(
+struct se_lun *core_tpg_alloc_lun(
 	struct se_portal_group *tpg,
 	u32 unpacked_lun)
 {
@@ -815,7 +815,7 @@ struct se_lun *core_tpg_pre_addlun(
 	return lun;
 }
 
-int core_tpg_post_addlun(
+int core_tpg_add_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun,
 	u32 lun_access,
-- 
1.7.1

