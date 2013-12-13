From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 23/32] target: Add lun->lun_tpg pointer
Date: Fri, 13 Dec 2013 15:59:11 -0800
Message-ID: <1386979160-6928-24-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab3LMX7f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:35 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Although the port also has a tpg pointer, if there's no port to link
(lun->lun_sep is NULL) then we can't get to it. So we need one in se_lun.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_tpg.c  |    2 ++
 include/target/target_core_base.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 6b4b0e6..c63f6cd 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -614,6 +614,7 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	INIT_LIST_HEAD(&lun->lun_acl_list);
 	spin_lock_init(&lun->lun_acl_lock);
 	spin_lock_init(&lun->lun_sep_lock);
+	lun->lun_tpg = se_tpg;
 
 	return core_tpg_add_lun(se_tpg, lun, lun_access, dev);
 }
@@ -739,6 +740,7 @@ struct se_lun *core_tpg_alloc_lun(
 	spin_lock_init(&lun->lun_acl_lock);
 	spin_lock_init(&lun->lun_sep_lock);
 	kref_init(&lun->refcount);
+	lun->lun_tpg = tpg;
 
 	spin_lock(&tpg->tpg_lun_lock);
 	if (!core_insert_lun(tpg, lun)) {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6d67c31..e4d5119 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -639,6 +639,7 @@ struct se_lun {
 	struct list_head	lun_acl_list;
 	struct se_device	*lun_se_dev;
 	struct se_port		*lun_sep;
+	struct se_portal_group	*lun_tpg;
 	struct config_group	lun_group;
 	struct se_port_stat_grps port_stat_grps;
 	struct kref		refcount;
-- 
1.7.1

