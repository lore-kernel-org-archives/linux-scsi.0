From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 04/16] target: Move dev_wwn_cit to struct se_subsystem_api
Date: Fri, 28 Nov 2014 09:06:30 +0000
Message-ID: <1417165602-32359-5-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48412 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaK1Jhh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 04:37:37 -0500
Received: by mail-ob0-f175.google.com with SMTP id wp4so4787706obc.20
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2014 01:37:36 -0800 (PST)
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for dev_wwn_cit as an external config_item_type
using TB_CIT_SETUP() helper macro, and sets both ct_item_ops + ct_attr
following existing code.

It updates target_core_make_subdev() + target_core_setup_dev_attrib_cit() +
struct target_backend_cits, and drops left-over target_core_dev_wwn_cit
from target_core_configfs.c code and update comments.

This patch introduces no functional change from existing code.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 13 +++++--------
 include/target/target_core_backend.h  |  1 +
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 49d51ba..43d180e 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -772,7 +772,7 @@ TB_CIT_SETUP(dev_attrib, &target_core_dev_attrib_ops, NULL,
 
 /* End functions for struct config_item_type tb_dev_attrib_cit */
 
-/*  Start functions for struct config_item_type target_core_dev_wwn_cit */
+/*  Start functions for struct config_item_type tb_dev_wwn_cit */
 
 CONFIGFS_EATTR_STRUCT(target_core_dev_wwn, t10_wwn);
 #define SE_DEV_WWN_ATTR(_name, _mode)					\
@@ -1003,13 +1003,9 @@ static struct configfs_item_operations target_core_dev_wwn_ops = {
 	.store_attribute	= target_core_dev_wwn_attr_store,
 };
 
-static struct config_item_type target_core_dev_wwn_cit = {
-	.ct_item_ops		= &target_core_dev_wwn_ops,
-	.ct_attrs		= target_core_dev_wwn_attrs,
-	.ct_owner		= THIS_MODULE,
-};
+TB_CIT_SETUP(dev_wwn, &target_core_dev_wwn_ops, NULL, target_core_dev_wwn_attrs);
 
-/*  End functions for struct config_item_type target_core_dev_wwn_cit */
+/*  End functions for struct config_item_type tb_dev_wwn_cit */
 
 /*  Start functions for struct config_item_type tb_dev_pr_cit */
 
@@ -2823,7 +2819,7 @@ static struct config_group *target_core_make_subdev(
 	config_group_init_type_name(&dev->dev_pr_group, "pr",
 			&t->tb_cits.tb_dev_pr_cit);
 	config_group_init_type_name(&dev->t10_wwn.t10_wwn_group, "wwn",
-			&target_core_dev_wwn_cit);
+			&t->tb_cits.tb_dev_wwn_cit);
 	config_group_init_type_name(&dev->t10_alua.alua_tg_pt_gps_group,
 			"alua", &target_core_alua_tg_pt_gps_cit);
 	config_group_init_type_name(&dev->dev_stat_grps.stat_group,
@@ -3126,6 +3122,7 @@ void target_core_setup_sub_cits(struct se_subsystem_api *sa)
 	target_core_setup_dev_cit(sa);
 	target_core_setup_dev_attrib_cit(sa);
 	target_core_setup_dev_pr_cit(sa);
+	target_core_setup_dev_wwn_cit(sa);
 }
 EXPORT_SYMBOL(target_core_setup_sub_cits);
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index a47e789..68fad78 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -9,6 +9,7 @@ struct target_backend_cits {
 	struct config_item_type tb_dev_cit;
 	struct config_item_type tb_dev_attrib_cit;
 	struct config_item_type tb_dev_pr_cit;
+	struct config_item_type tb_dev_wwn_cit;
 };
 
 struct se_subsystem_api {
-- 
1.9.1

