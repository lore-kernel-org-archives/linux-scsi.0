From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 03/16] target: Move dev_pr_cit to struct se_subsystem_api
Date: Fri, 28 Nov 2014 09:06:29 +0000
Message-ID: <1417165602-32359-4-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for dev_pr_cit as an external config_item_type
using TB_CIT_SETUP() helper macro, and sets both ct_item_ops + ct_attr
following existing code.

It updates target_core_make_subdev() + target_core_setup_dev_attrib_cit() +
struct target_backend_cits, and drops left-over target_core_dev_pr_cit
from target_core_configfs.c code and update comments.

This patch introduces no functional change from existing code.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 13 +++++--------
 include/target/target_core_backend.h  |  1 +
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 78ed857..49d51ba 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1011,7 +1011,7 @@ static struct config_item_type target_core_dev_wwn_cit = {
 
 /*  End functions for struct config_item_type target_core_dev_wwn_cit */
 
-/*  Start functions for struct config_item_type target_core_dev_pr_cit */
+/*  Start functions for struct config_item_type tb_dev_pr_cit */
 
 CONFIGFS_EATTR_STRUCT(target_core_dev_pr, se_device);
 #define SE_DEV_PR_ATTR(_name, _mode)					\
@@ -1472,13 +1472,9 @@ static struct configfs_item_operations target_core_dev_pr_ops = {
 	.store_attribute	= target_core_dev_pr_attr_store,
 };
 
-static struct config_item_type target_core_dev_pr_cit = {
-	.ct_item_ops		= &target_core_dev_pr_ops,
-	.ct_attrs		= target_core_dev_pr_attrs,
-	.ct_owner		= THIS_MODULE,
-};
+TB_CIT_SETUP(dev_pr, &target_core_dev_pr_ops, NULL, target_core_dev_pr_attrs);
 
-/*  End functions for struct config_item_type target_core_dev_pr_cit */
+/*  End functions for struct config_item_type tb_dev_pr_cit */
 
 /*  Start functions for struct config_item_type tb_dev_cit */
 
@@ -2825,7 +2821,7 @@ static struct config_group *target_core_make_subdev(
 	config_group_init_type_name(&dev->dev_attrib.da_group, "attrib",
 			&t->tb_cits.tb_dev_attrib_cit);
 	config_group_init_type_name(&dev->dev_pr_group, "pr",
-			&target_core_dev_pr_cit);
+			&t->tb_cits.tb_dev_pr_cit);
 	config_group_init_type_name(&dev->t10_wwn.t10_wwn_group, "wwn",
 			&target_core_dev_wwn_cit);
 	config_group_init_type_name(&dev->t10_alua.alua_tg_pt_gps_group,
@@ -3129,6 +3125,7 @@ void target_core_setup_sub_cits(struct se_subsystem_api *sa)
 {
 	target_core_setup_dev_cit(sa);
 	target_core_setup_dev_attrib_cit(sa);
+	target_core_setup_dev_pr_cit(sa);
 }
 EXPORT_SYMBOL(target_core_setup_sub_cits);
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 735f8567..a47e789 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -8,6 +8,7 @@
 struct target_backend_cits {
 	struct config_item_type tb_dev_cit;
 	struct config_item_type tb_dev_attrib_cit;
+	struct config_item_type tb_dev_pr_cit;
 };
 
 struct se_subsystem_api {
-- 
1.9.1
