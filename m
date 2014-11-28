From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 02/16] target: Move dev_attrib_cit to struct se_subsystem_api
Date: Fri, 28 Nov 2014 09:06:28 +0000
Message-ID: <1417165602-32359-3-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for dev_attrib_cit as an external config_item_type
using TB_CIT_SETUP() helper macro, and sets both ct_item_ops + ct_attr
following existing code.

It updates target_core_make_subdev() + target_core_setup_dev_attrib_cit() +
struct target_backend_cits, and drops left-over target_core_dev_attrib_cit
from target_core_configfs.c code and update comments.

This patch introduces no functional change from existing code.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 14 ++++++--------
 include/target/target_core_backend.h  |  1 +
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f7b2186..78ed857 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -584,7 +584,7 @@ EXPORT_SYMBOL(target_fabric_configfs_deregister);
 // Stop functions called by external Target Fabrics Modules
 //############################################################################*/
 
-/* Start functions for struct config_item_type target_core_dev_attrib_cit */
+/* Start functions for struct config_item_type tb_dev_attrib_cit */
 
 #define DEF_DEV_ATTRIB_SHOW(_name)					\
 static ssize_t target_core_dev_show_attr_##_name(			\
@@ -767,13 +767,10 @@ static struct configfs_item_operations target_core_dev_attrib_ops = {
 	.store_attribute	= target_core_dev_attrib_attr_store,
 };
 
-static struct config_item_type target_core_dev_attrib_cit = {
-	.ct_item_ops		= &target_core_dev_attrib_ops,
-	.ct_attrs		= target_core_dev_attrib_attrs,
-	.ct_owner		= THIS_MODULE,
-};
+TB_CIT_SETUP(dev_attrib, &target_core_dev_attrib_ops, NULL,
+	     target_core_dev_attrib_attrs);
 
-/* End functions for struct config_item_type target_core_dev_attrib_cit */
+/* End functions for struct config_item_type tb_dev_attrib_cit */
 
 /*  Start functions for struct config_item_type target_core_dev_wwn_cit */
 
@@ -2826,7 +2823,7 @@ static struct config_group *target_core_make_subdev(
 
 	config_group_init_type_name(dev_cg, name, &t->tb_cits.tb_dev_cit);
 	config_group_init_type_name(&dev->dev_attrib.da_group, "attrib",
-			&target_core_dev_attrib_cit);
+			&t->tb_cits.tb_dev_attrib_cit);
 	config_group_init_type_name(&dev->dev_pr_group, "pr",
 			&target_core_dev_pr_cit);
 	config_group_init_type_name(&dev->t10_wwn.t10_wwn_group, "wwn",
@@ -3131,6 +3128,7 @@ static struct config_item_type target_core_cit = {
 void target_core_setup_sub_cits(struct se_subsystem_api *sa)
 {
 	target_core_setup_dev_cit(sa);
+	target_core_setup_dev_attrib_cit(sa);
 }
 EXPORT_SYMBOL(target_core_setup_sub_cits);
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 7b84436..735f8567 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -7,6 +7,7 @@
 
 struct target_backend_cits {
 	struct config_item_type tb_dev_cit;
+	struct config_item_type tb_dev_attrib_cit;
 };
 
 struct se_subsystem_api {
-- 
1.9.1
