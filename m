From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 06/16] target: Move dev_stat_cit to struct se_subsystem_api
Date: Fri, 28 Nov 2014 09:06:32 +0000
Message-ID: <1417165602-32359-7-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for dev_stat_cit as an external config_item_type
using TB_CIT_SETUP() helper macro, and sets only ct_group_ops following
existing code.

It updates target_core_make_subdev() + target_core_setup_dev_attrib_cit() +
struct target_backend_cits, and drops left-over target_core_dev_stat_cit
from target_core_configfs.c code and update comments.

This patch introduces no functional change from existing code.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 12 +++++-------
 include/target/target_core_backend.h  |  1 +
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 0cf41ad..2903d89 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2748,7 +2748,7 @@ static struct config_item_type target_core_alua_cit = {
 
 /* End functions for struct config_item_type target_core_alua_cit */
 
-/* Start functions for struct config_item_type target_core_stat_cit */
+/* Start functions for struct config_item_type tb_dev_stat_cit */
 
 static struct config_group *target_core_stat_mkdir(
 	struct config_group *group,
@@ -2769,12 +2769,9 @@ static struct configfs_group_operations target_core_stat_group_ops = {
 	.drop_item		= &target_core_stat_rmdir,
 };
 
-static struct config_item_type target_core_stat_cit = {
-	.ct_group_ops		= &target_core_stat_group_ops,
-	.ct_owner		= THIS_MODULE,
-};
+TB_CIT_SETUP(dev_stat, NULL, &target_core_stat_group_ops, NULL);
 
-/* End functions for struct config_item_type target_core_stat_cit */
+/* End functions for struct config_item_type tb_dev_stat_cit */
 
 /* Start functions for struct config_item_type target_core_hba_cit */
 
@@ -2820,7 +2817,7 @@ static struct config_group *target_core_make_subdev(
 	config_group_init_type_name(&dev->t10_alua.alua_tg_pt_gps_group,
 			"alua", &t->tb_cits.tb_dev_alua_tg_pt_gps_cit);
 	config_group_init_type_name(&dev->dev_stat_grps.stat_group,
-			"statistics", &target_core_stat_cit);
+			"statistics", &t->tb_cits.tb_dev_stat_cit);
 
 	dev_cg->default_groups[0] = &dev->dev_attrib.da_group;
 	dev_cg->default_groups[1] = &dev->dev_pr_group;
@@ -3121,6 +3118,7 @@ void target_core_setup_sub_cits(struct se_subsystem_api *sa)
 	target_core_setup_dev_pr_cit(sa);
 	target_core_setup_dev_wwn_cit(sa);
 	target_core_setup_dev_alua_tg_pt_gps_cit(sa);
+	target_core_setup_dev_stat_cit(sa);
 }
 EXPORT_SYMBOL(target_core_setup_sub_cits);
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 157d173..83a3726 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -11,6 +11,7 @@ struct target_backend_cits {
 	struct config_item_type tb_dev_pr_cit;
 	struct config_item_type tb_dev_wwn_cit;
 	struct config_item_type tb_dev_alua_tg_pt_gps_cit;
+	struct config_item_type tb_dev_stat_cit;
 };
 
 struct se_subsystem_api {
-- 
1.9.1
