From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 01/16] target: Move dev_cit to struct se_subsystem_api
Date: Fri, 28 Nov 2014 09:06:27 +0000
Message-ID: <1417165602-32359-2-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:63729 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaK1Jhb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 04:37:31 -0500
Received: by mail-oi0-f50.google.com with SMTP id a141so4388543oig.37
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2014 01:37:31 -0800 (PST)
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds initial support for dev_cit as external config_item_type.

This includes a new struct target_backend_cits to hold the external CITs
within struct se_subsystem_api, and target_core_setup_sub_cits() to be
used by backend drivers ahead of transport_subsystem_register().

It adds a TB_CIT_SETUP() helper following target_core_fabric_configfs.c
to perform the config_item_type assignments.

Also, drop left-over target_core_dev_cit from target_core_configfs.c code
and update comments.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 33 ++++++++++++++++++++++++---------
 drivers/target/target_core_hba.c      |  1 +
 include/target/target_core_backend.h  |  9 +++++++++
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 41498b6..f7b2186 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -50,6 +50,19 @@
 #include "target_core_rd.h"
 #include "target_core_xcopy.h"
 
+#define TB_CIT_SETUP(_name, _item_ops, _group_ops, _attrs)		\
+static void target_core_setup_##_name##_cit(struct se_subsystem_api *sa) \
+{									\
+	struct target_backend_cits *tbc = &sa->tb_cits;			\
+	struct config_item_type *cit = &tbc->tb_##_name##_cit;		\
+									\
+	cit->ct_item_ops = _item_ops;					\
+	cit->ct_group_ops = _group_ops;					\
+	cit->ct_attrs = _attrs;						\
+	cit->ct_owner = sa->owner;					\
+	pr_debug("Setup generic %s\n", __stringify(_name));		\
+}
+
 extern struct t10_alua_lu_gp *default_lu_gp;
 
 static LIST_HEAD(g_tf_list);
@@ -1470,7 +1483,7 @@ static struct config_item_type target_core_dev_pr_cit = {
 
 /*  End functions for struct config_item_type target_core_dev_pr_cit */
 
-/*  Start functions for struct config_item_type target_core_dev_cit */
+/*  Start functions for struct config_item_type tb_dev_cit */
 
 static ssize_t target_core_show_dev_info(void *p, char *page)
 {
@@ -1934,7 +1947,7 @@ static struct target_core_configfs_attribute target_core_attr_dev_lba_map = {
 	.store	= target_core_store_dev_lba_map,
 };
 
-static struct configfs_attribute *lio_core_dev_attrs[] = {
+static struct configfs_attribute *target_core_dev_attrs[] = {
 	&target_core_attr_dev_info.attr,
 	&target_core_attr_dev_control.attr,
 	&target_core_attr_dev_alias.attr,
@@ -1993,13 +2006,9 @@ static struct configfs_item_operations target_core_dev_item_ops = {
 	.store_attribute	= target_core_dev_store,
 };
 
-static struct config_item_type target_core_dev_cit = {
-	.ct_item_ops		= &target_core_dev_item_ops,
-	.ct_attrs		= lio_core_dev_attrs,
-	.ct_owner		= THIS_MODULE,
-};
+TB_CIT_SETUP(dev, &target_core_dev_item_ops, NULL, target_core_dev_attrs);
 
-/* End functions for struct config_item_type target_core_dev_cit */
+/* End functions for struct config_item_type tb_dev_cit */
 
 /* Start functions for struct config_item_type target_core_alua_lu_gp_cit */
 
@@ -2815,7 +2824,7 @@ static struct config_group *target_core_make_subdev(
 	if (!dev_cg->default_groups)
 		goto out_free_device;
 
-	config_group_init_type_name(dev_cg, name, &target_core_dev_cit);
+	config_group_init_type_name(dev_cg, name, &t->tb_cits.tb_dev_cit);
 	config_group_init_type_name(&dev->dev_attrib.da_group, "attrib",
 			&target_core_dev_attrib_cit);
 	config_group_init_type_name(&dev->dev_pr_group, "pr",
@@ -3119,6 +3128,12 @@ static struct config_item_type target_core_cit = {
 
 /* Stop functions for struct config_item_type target_core_hba_cit */
 
+void target_core_setup_sub_cits(struct se_subsystem_api *sa)
+{
+	target_core_setup_dev_cit(sa);
+}
+EXPORT_SYMBOL(target_core_setup_sub_cits);
+
 static int __init target_core_init_configfs(void)
 {
 	struct config_group *target_cg, *hba_cg = NULL, *alua_cg = NULL;
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index e6e496f..ff95f95 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -36,6 +36,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
 #include <target/target_core_fabric.h>
+#include <target/target_core_configfs.h>
 
 #include "target_core_internal.h"
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 9adc1bc..7b84436 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -5,6 +5,10 @@
 #define TRANSPORT_PLUGIN_VHBA_PDEV		2
 #define TRANSPORT_PLUGIN_VHBA_VDEV		3
 
+struct target_backend_cits {
+	struct config_item_type tb_dev_cit;
+};
+
 struct se_subsystem_api {
 	struct list_head sub_api_list;
 
@@ -44,6 +48,8 @@ struct se_subsystem_api {
 	int (*init_prot)(struct se_device *);
 	int (*format_prot)(struct se_device *);
 	void (*free_prot)(struct se_device *);
+
+	struct target_backend_cits tb_cits;
 };
 
 struct sbc_ops {
@@ -96,4 +102,7 @@ sense_reason_t	transport_generic_map_mem_to_cmd(struct se_cmd *,
 
 void	array_free(void *array, int n);
 
+/* From target_core_configfs.c to setup default backend config_item_types */
+void	target_core_setup_sub_cits(struct se_subsystem_api *);
+
 #endif /* TARGET_CORE_BACKEND_H */
-- 
1.9.1

