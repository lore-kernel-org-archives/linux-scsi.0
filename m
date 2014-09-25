From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 2/2] target: Implement report lun data change unit attention.
Date: Thu, 25 Sep 2014 06:22:29 -0400
Message-ID: <1411640549-8013-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640549-8013-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:56158 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375AbaIYK43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 06:56:29 -0400
In-Reply-To: <1411640549-8013-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/target/target_core_fabric_configfs.c |   28 ++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7de9f04..f97866e 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -42,6 +42,7 @@
 #include "target_core_internal.h"
 #include "target_core_alua.h"
 #include "target_core_pr.h"
+#include "target_core_ua.h"
 
 #define TF_CIT_SETUP(_name, _item_ops, _group_ops, _attrs)		\
 static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf) \
@@ -326,6 +327,8 @@ static struct config_group *target_fabric_make_mappedlun(
 	char *buf;
 	unsigned long mapped_lun;
 	int ret = 0;
+	struct se_lun *lun;
+	int i = 0;
 
 	acl_ci = &group->cg_item;
 	if (!acl_ci) {
@@ -400,6 +403,16 @@ static struct config_group *target_fabric_make_mappedlun(
 		goto out;
 	}
 	target_stat_setup_mappedlun_default_groups(lacl);
+	spin_lock(&se_tpg->tpg_lun_lock);
+	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
+		lun = se_tpg->tpg_lun_list[i];
+		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
+			continue;
+		spin_unlock(&se_tpg->tpg_lun_lock);
+		core_scsi3_ua_allocate(se_nacl, lun->unpacked_lun, 0x3f, 0xe);
+		spin_lock(&se_tpg->tpg_lun_lock);
+	}
+	spin_unlock(&se_tpg->tpg_lun_lock);
 
 	kfree(buf);
 	return &lacl->se_lun_group;
@@ -419,6 +432,8 @@ static void target_fabric_drop_mappedlun(
 	struct config_item *df_item;
 	struct config_group *lacl_cg = NULL, *ml_stat_grp = NULL;
 	int i;
+	struct se_lun *lun;
+	struct se_portal_group *se_tpg = lacl->se_lun_nacl->se_tpg;
 
 	ml_stat_grp = &lacl->ml_stat_grps.stat_group;
 	for (i = 0; ml_stat_grp->default_groups[i]; i++) {
@@ -437,6 +452,19 @@ static void target_fabric_drop_mappedlun(
 	kfree(lacl_cg->default_groups);
 
 	config_item_put(item);
+
+	spin_lock(&se_tpg->tpg_lun_lock);
+	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
+		lun = se_tpg->tpg_lun_list[i];
+		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
+			continue;
+		spin_unlock(&se_tpg->tpg_lun_lock);
+		core_scsi3_ua_allocate(lacl->se_lun_nacl, lun->unpacked_lun,
+		    0x3f, 0xe);
+		spin_lock(&se_tpg->tpg_lun_lock);
+	}
+	spin_unlock(&se_tpg->tpg_lun_lock);
+
 }
 
 static void target_fabric_nacl_base_release(struct config_item *item)
-- 
1.7.7

