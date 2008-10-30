From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ConfigFS]: Updates for target_core_cit
Date: Thu, 30 Oct 2008 16:28:01 -0700
Message-ID: <1225409281.4387.256.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:41067 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753987AbYJ3X2G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 19:28:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 1bfa0c16284c97121229e82d2be1838873b1178e Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 30 Oct 2008 16:10:49 -0700
Subject: [PATCH] [Target_Core_Mod/ConfigFS]: Updates for target_core_cit

Remove last remaining IOCTL bits from /sys/kernel/config/target/core/$PLUGIN_HBA
in target_core_ops->make_group() and target_core_ops->drop_item().

Also, updated some ERR_PTR() return values in target_core_call_freedev(),
and removed incorrect FIXME: from early devel days before it was understood
that ConfigFS protects se_hba_t->hba_id, but we still want to block when
when access se_hba_t across different $STORAGE_OBJECTS.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |   71 ++++--------------------------
 1 files changed, 10 insertions(+), 61 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index a5792e3..77950c1 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -41,8 +41,6 @@
 #include <iscsi_target_core.h>
 #include <target_core_base.h>
 #include <iscsi_target_error.h>
-#include <iscsi_target_ioctl.h>
-#include <iscsi_target_ioctl_defs.h>
 #include <target_core_device.h>
 #include <iscsi_target_device.h>
 #include <target_core_hba.h>
@@ -831,7 +829,6 @@ static struct config_item_type target_core_dev_cit = {
 
 // Start functions for struct config_item_type target_core_hba_cit
 
-#warning Fix unprotected reference to hba_p
 static struct config_group *target_core_call_createdev (
 	struct config_group *group,
 	const char *name)
@@ -907,7 +904,6 @@ out:
 	return(NULL);
 }
 
-#warning Fix unprotected reference to hba_p
 static void target_core_call_freedev (
 	struct config_group *group,
 	struct config_item *item)
@@ -1009,9 +1005,7 @@ static struct config_group *target_core_call_addhbatotarget (
 {
 	char *se_plugin_str, *str, *str2, *endptr;
 	se_hba_t *hba;
-	se_hbainfo_t hba_info;
 	se_plugin_t *se_plugin;
-	struct iscsi_target *tg;
 	char buf[TARGET_CORE_NAME_MAX_LEN];
 	u32 plugin_dep_id;
 	int hba_type = 0, ret;
@@ -1021,13 +1015,13 @@ static struct config_group *target_core_call_addhbatotarget (
 		printk(KERN_ERR "Passed *name strlen(): %d exceeds"
 			" TARGET_CORE_NAME_MAX_LEN: %d\n", (int)strlen(name),
 			TARGET_CORE_NAME_MAX_LEN);
-		return(NULL);
+		return(ERR_PTR(-ENAMETOOLONG));
 	}
 	snprintf(buf, TARGET_CORE_NAME_MAX_LEN, "%s", name);
 
 	if (!(str = strstr(buf, "_"))) {
 		printk(KERN_ERR "Unable to locate \"_\" for $SUBSYSTEM_PLUGIN_$HOST_ID\n");
-		return(NULL);
+		return(ERR_PTR(-EINVAL));
 	}
 	se_plugin_str = buf;
 
@@ -1044,7 +1038,7 @@ static struct config_group *target_core_call_addhbatotarget (
 	}
 
 	if (!(se_plugin = transport_core_get_plugin_by_name(se_plugin_str)))
-		return(NULL);
+		return(ERR_PTR(-EINVAL));
 
 	hba_type = se_plugin->plugin_type;
 	plugin_dep_id = simple_strtoul(str, &endptr, 0);
@@ -1053,70 +1047,30 @@ static struct config_group *target_core_call_addhbatotarget (
 		se_plugin->plugin_name, hba_type, plugin_dep_id);
 
 	if (!(hba = core_get_next_free_hba()))
-		return(NULL);
-	
-	if (!(tg = kzalloc(sizeof(struct iscsi_target), GFP_KERNEL)))
-		return(ERR_PTR(-ENOMEM));
+		return(ERR_PTR(-EINVAL));
 	
-#warning This should go into se_subsystem_api_t API
-	switch (hba_type) {
-	case PSCSI:
-		tg->scsi_host_id = plugin_dep_id;
-		tg->hba_params_set |= PARAM_HBA_SCSI_HOST_ID;	
-		break;
-	case IBLOCK:
-		tg->iblock_host_id = plugin_dep_id;
-		tg->hba_params_set |= PARAM_HBA_IBLOCK_HOST_ID;
-		break;
-	case FILEIO:
-		tg->fd_host_id = plugin_dep_id;
-		tg->hba_params_set |= PARAM_HBA_FD_HOST_ID;
-		break;
-	case RAMDISK_DR:
-	case RAMDISK_MCP:
-		tg->rd_host_id = plugin_dep_id;
-		tg->hba_params_set |= PARAM_HBA_RD_HOST_ID;
-		break;
-	default:
-		printk(KERN_ERR "Unable to setup hba_type: %d name: %s\n",
-			hba_type, se_plugin_str);
-		goto out;
-	}
-	tg->hba_type = hba_type;
-	tg->params_set |= PARAM_HBA_TYPE;
-	tg->hba_id = hba->hba_id;
-	tg->params_set |= PARAM_HBA_ID;
-
-	memset(&hba_info, 0, sizeof(se_hbainfo_t));
-	hba_info.hba_id = hba->hba_id;
-	hba_info.hba_type = hba_type;
+	hba->type = hba_type;
 
-	if ((ret = iscsi_hba_check_addhba_params(tg, &hba_info)) < 0)
-		goto out;
-
-	if ((ret = iscsi_hba_add_hba(hba, &hba_info, tg)) < 0)
+	if ((ret = se_core_add_hba(hba, plugin_dep_id)) < 0)
 		goto out;
 
 	config_group_init_type_name(&hba->hba_group, name, &target_core_hba_cit);
 
-	kfree(tg);
 	core_put_hba(hba);
 	return(&hba->hba_group);
 out:
-	kfree(tg);
+	hba->type = 0;
 	core_put_hba(hba);
-	return(NULL);
+	return(ERR_PTR(ret));
 }
 
 
-#warning Fix unprotected reference to hba_p
 static void target_core_call_delhbafromtarget (
 	struct config_group *group,
 	struct config_item *item)
 {
 	se_hba_t *hba_p = container_of(to_config_group(item), se_hba_t, hba_group);
 	se_hba_t *hba = NULL;
-	struct iscsi_target *tg;
 	int ret;
 
 	if (!(hba_p)) {
@@ -1124,18 +1078,13 @@ static void target_core_call_delhbafromtarget (
 		return;
 	}
 
-	if (!(tg = kzalloc(sizeof(struct iscsi_target), GFP_KERNEL)))
-		return;
-
 	if (!(hba = core_get_hba_from_id(hba_p->hba_id, 0)))
-		goto out;
+		return;
 	
 	config_item_put(item);
 
-	ret = iscsi_hba_del_hba(hba);
+	ret = se_core_del_hba(hba);
 	core_put_hba(hba);
-out:
-	kfree(tg);
 	return;
 
 }
-- 
1.5.4.1



