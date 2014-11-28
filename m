From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 05/16] target: Move dev_alua_tg_pt_gps_cit to struct se_subsystem_api
Date: Fri, 28 Nov 2014 09:06:31 +0000
Message-ID: <1417165602-32359-6-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36205 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaK1Jhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 04:37:39 -0500
Received: by mail-oi0-f51.google.com with SMTP id e131so4466867oig.10
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2014 01:37:38 -0800 (PST)
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for dev_alua_tg_pt_gps_cit as an external config_item_type
using TB_CIT_SETUP() helper macro, and sets only ct_group_ops following
existing code.

It updates target_core_make_subdev() + target_core_setup_dev_attrib_cit() +
struct target_backend_cits, and drops left-over target_core_dev_alua_tg_pt_gps_cit
from target_core_configfs.c code and update comments.

This patch introduces no functional change from existing code.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 12 +++++-------
 include/target/target_core_backend.h  |  1 +
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 43d180e..0cf41ad 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2677,7 +2677,7 @@ static struct config_item_type target_core_alua_tg_pt_gp_cit = {
 
 /* End functions for struct config_item_type target_core_alua_tg_pt_gp_cit */
 
-/* Start functions for struct config_item_type target_core_alua_tg_pt_gps_cit */
+/* Start functions for struct config_item_type tb_alua_tg_pt_gps_cit */
 
 static struct config_group *target_core_alua_create_tg_pt_gp(
 	struct config_group *group,
@@ -2728,12 +2728,9 @@ static struct configfs_group_operations target_core_alua_tg_pt_gps_group_ops = {
 	.drop_item		= &target_core_alua_drop_tg_pt_gp,
 };
 
-static struct config_item_type target_core_alua_tg_pt_gps_cit = {
-	.ct_group_ops		= &target_core_alua_tg_pt_gps_group_ops,
-	.ct_owner		= THIS_MODULE,
-};
+TB_CIT_SETUP(dev_alua_tg_pt_gps, NULL, &target_core_alua_tg_pt_gps_group_ops, NULL);
 
-/* End functions for struct config_item_type target_core_alua_tg_pt_gps_cit */
+/* End functions for struct config_item_type tb_alua_tg_pt_gps_cit */
 
 /* Start functions for struct config_item_type target_core_alua_cit */
 
@@ -2821,7 +2818,7 @@ static struct config_group *target_core_make_subdev(
 	config_group_init_type_name(&dev->t10_wwn.t10_wwn_group, "wwn",
 			&t->tb_cits.tb_dev_wwn_cit);
 	config_group_init_type_name(&dev->t10_alua.alua_tg_pt_gps_group,
-			"alua", &target_core_alua_tg_pt_gps_cit);
+			"alua", &t->tb_cits.tb_dev_alua_tg_pt_gps_cit);
 	config_group_init_type_name(&dev->dev_stat_grps.stat_group,
 			"statistics", &target_core_stat_cit);
 
@@ -3123,6 +3120,7 @@ void target_core_setup_sub_cits(struct se_subsystem_api *sa)
 	target_core_setup_dev_attrib_cit(sa);
 	target_core_setup_dev_pr_cit(sa);
 	target_core_setup_dev_wwn_cit(sa);
+	target_core_setup_dev_alua_tg_pt_gps_cit(sa);
 }
 EXPORT_SYMBOL(target_core_setup_sub_cits);
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 68fad78..157d173 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -10,6 +10,7 @@ struct target_backend_cits {
 	struct config_item_type tb_dev_attrib_cit;
 	struct config_item_type tb_dev_pr_cit;
 	struct config_item_type tb_dev_wwn_cit;
+	struct config_item_type tb_dev_alua_tg_pt_gps_cit;
 };
 
 struct se_subsystem_api {
-- 
1.9.1

