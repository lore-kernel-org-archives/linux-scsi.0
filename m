From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] [LIO-Target]: Add TPG attributes
	demo_mode_write_protect and prod_mode_write_protect
Date: Wed, 03 Dec 2008 20:35:07 -0800
Message-ID: <1228365307.4153.107.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:42109 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755141AbYLDEfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 23:35:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 803e18513e360e8d1c52573bcce8936996db8806 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 3 Dec 2008 18:56:56 -0800
Subject: [PATCH] [LIO-Target]: Add TPG attributes demo_mode_write_protect and prod_mode_write_protect

Renamed the v2.9 TPG attrib "demo_mode_lun_access" to "demo_mode_write_protect" and
added TPG ATTRIB prdo_mode_write_protect.  By default values are as follows from
iscsi_target_core.h:

+#define TA_DEMO_MODE_WRITE_PROTECT     1 // Enabled by default in demo mode (generic_node_acls=1)
+#define TA_PROD_MODE_WRITE_PROTECT     0 // Disabled by default in production mode w/ explict ACLs

This patch adds iscsi_ta_demo_mode_write_protect() and iscsi_ta_prod_mode_write_protect(), which
are used in iscsi_target_configfs.c.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_core.h |    6 ++++--
 drivers/lio-core/iscsi_target_tpg.c  |   33 ++++++++++++++++++++++++++-------
 drivers/lio-core/iscsi_target_tpg.h  |    3 ++-
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_core.h b/drivers/lio-core/iscsi_target_core.h
index 4a6ec34..ef15254 100644
--- a/drivers/lio-core/iscsi_target_core.h
+++ b/drivers/lio-core/iscsi_target_core.h
@@ -110,7 +110,8 @@
 #define TA_DEFAULT_CMDSN_DEPTH_MAX	512
 #define TA_DEFAULT_CMDSN_DEPTH_MIN	1
 #define TA_CACHE_DYNAMIC_ACLS		0
-#define TA_DEMO_MODE_LUN_ACCESS		0 // READ-ONLY by default in demo mode
+#define TA_DEMO_MODE_WRITE_PROTECT	1 // Enabled by default in demo mode (generic_node_acls=1)
+#define TA_PROD_MODE_WRITE_PROTECT	0 // Disabled by default in production mode w/ explict ACLs
 #define TA_CACHE_CORE_NPS		0
 
 /* iscsi_map_sg_t->map_flags */
@@ -815,7 +816,8 @@ typedef struct iscsi_tpg_attrib_s {
 	u32			generate_node_acls;
 	u32			cache_dynamic_acls;
 	u32			default_cmdsn_depth;
-	u32			demo_mode_lun_access;
+	u32			demo_mode_write_protect;
+	u32			prod_mode_write_protect;
 	u32			cache_core_nps;
 	struct iscsi_portal_group_s *tpg;
 	struct config_group	tpg_attrib_group;
diff --git a/drivers/lio-core/iscsi_target_tpg.c b/drivers/lio-core/iscsi_target_tpg.c
index 9e793c6..da3e13d 100644
--- a/drivers/lio-core/iscsi_target_tpg.c
+++ b/drivers/lio-core/iscsi_target_tpg.c
@@ -399,9 +399,9 @@ extern void iscsi_tpg_add_node_to_devs (
 		spin_unlock(&tpg->tpg_lun_lock);
 
 		/*
-		 * By default, demo_mode_lun_access is ZERO, or READ_ONLY;
+		 * By default, demo_mode_write_protect is ON, or READ_ONLY;
 		 */
-		if (ISCSI_TPG_ATTRIB(tpg)->demo_mode_lun_access) {
+		if (!(ISCSI_TPG_ATTRIB(tpg)->demo_mode_write_protect)) {
 			if (LUN_OBJ_API(lun)->get_device_access) {
 				if (LUN_OBJ_API(lun)->get_device_access(lun->lun_type_ptr) == 0)
 					lun_access = ISCSI_LUNFLAGS_READ_ONLY;
@@ -595,7 +595,8 @@ static void iscsi_set_default_tpg_attribs (iscsi_portal_group_t *tpg)
 	a->default_cmdsn_depth = TA_DEFAULT_CMDSN_DEPTH;
 	a->generate_node_acls = TA_GENERATE_NODE_ACLS;
 	a->cache_dynamic_acls = TA_CACHE_DYNAMIC_ACLS;
-	a->demo_mode_lun_access = TA_DEMO_MODE_LUN_ACCESS;
+	a->demo_mode_write_protect = TA_DEMO_MODE_WRITE_PROTECT;
+	a->prod_mode_write_protect = TA_PROD_MODE_WRITE_PROTECT;
 	a->cache_core_nps = TA_CACHE_CORE_NPS;
 		
 	return;
@@ -1602,7 +1603,7 @@ extern int iscsi_ta_cache_dynamic_acls (
 	return(0);
 }
 
-extern int iscsi_ta_demo_mode_lun_access (
+extern int iscsi_ta_demo_mode_write_protect (
 	iscsi_portal_group_t *tpg,
 	u32 flag)
 {
@@ -1613,9 +1614,27 @@ extern int iscsi_ta_demo_mode_lun_access (
 		return(-EINVAL);
 	}
 
-	a->demo_mode_lun_access = flag;
-	PYXPRINT("iSCSI_TPG[%hu] - Demo Mode iSCSI LUN Access: %s\n",
-		tpg->tpgt, (a->demo_mode_lun_access) ? "READ-WRITE" : "READ-ONLY");
+	a->demo_mode_write_protect = flag;
+	PYXPRINT("iSCSI_TPG[%hu] - Demo Mode Write Protect bit: %s\n",
+		tpg->tpgt, (a->demo_mode_write_protect) ? "ON" : "OFF");
+
+	return(0);
+}
+
+extern int iscsi_ta_prod_mode_write_protect (
+	iscsi_portal_group_t *tpg,
+	u32 flag)
+{
+	iscsi_tpg_attrib_t *a = &tpg->tpg_attrib;
+
+	if ((flag != 0) && (flag != 1)) {
+		TRACE_ERROR("Illegal value %d\n", flag);
+		return(-EINVAL);
+	}
+
+	a->prod_mode_write_protect = flag;
+	PYXPRINT("iSCSI_TPG[%hu] - Production Mode Write Protect bit: %s\n",
+		tpg->tpgt, (a->prod_mode_write_protect) ? "ON" : "OFF");
 
 	return(0);
 }
diff --git a/drivers/lio-core/iscsi_target_tpg.h b/drivers/lio-core/iscsi_target_tpg.h
index fe93538..7e8fa42 100644
--- a/drivers/lio-core/iscsi_target_tpg.h
+++ b/drivers/lio-core/iscsi_target_tpg.h
@@ -62,7 +62,8 @@ extern int iscsi_ta_netif_timeout (iscsi_portal_group_t *, u32);
 extern int iscsi_ta_generate_node_acls (iscsi_portal_group_t *, u32);
 extern int iscsi_ta_default_cmdsn_depth (iscsi_portal_group_t *, u32);
 extern int iscsi_ta_cache_dynamic_acls (iscsi_portal_group_t *, u32);
-extern int iscsi_ta_demo_mode_lun_access (iscsi_portal_group_t *, u32);
+extern int iscsi_ta_demo_mode_write_protect (iscsi_portal_group_t *, u32);
+extern int iscsi_ta_prod_mode_write_protect (iscsi_portal_group_t *, u32);
 extern void iscsi_disable_tpgs (struct iscsi_tiqn_s *);
 extern void iscsi_disable_all_tpgs (void);
 extern void iscsi_remove_tpgs (struct iscsi_tiqn_s *);
-- 
1.5.4.1



