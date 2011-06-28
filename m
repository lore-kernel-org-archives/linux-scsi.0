From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 04/15] target: Disable rd_dr
Date: Tue, 28 Jun 2011 12:29:26 -0700
Message-ID: <1309289377-8029-5-git-send-email-agrover@redhat.com>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1F1T3t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 15:29:49 -0400
In-Reply-To: <1309289377-8029-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

The rd_dr ramdisk implementation is closely tied with struct se_mem.
Disable it before removing struct se_mem. I'm not sure if we want to
fix up and re-enable it, or maybe just decide we can live without it and
remove it entirely.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c |    2 +-
 drivers/target/target_core_rd.c     |   17 +++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index fcd312b..875d64f 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1563,7 +1563,7 @@ int core_dev_setup_virtual_lun0(void)
 	char buf[16];
 	int ret;
 
-	hba = core_alloc_hba("rd_dr", 0, HBA_FLAGS_INTERNAL_USE);
+	hba = core_alloc_hba("rd_mcp", 0, HBA_FLAGS_INTERNAL_USE);
 	if (IS_ERR(hba))
 		return PTR_ERR(hba);
 
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 4f9416d..a30c02e 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -44,7 +44,7 @@
 
 #include "target_core_rd.h"
 
-static struct se_subsystem_api rd_dr_template;
+//static struct se_subsystem_api rd_dr_template;
 static struct se_subsystem_api rd_mcp_template;
 
 /* #define DEBUG_RAMDISK_MCP */
@@ -226,10 +226,12 @@ static void *rd_allocate_virtdevice(
 	return rd_dev;
 }
 
+#if 0
 static void *rd_DIRECT_allocate_virtdevice(struct se_hba *hba, const char *name)
 {
 	return rd_allocate_virtdevice(hba, name, 1);
 }
+#endif
 
 static void *rd_MEMCPY_allocate_virtdevice(struct se_hba *hba, const char *name)
 {
@@ -270,7 +272,6 @@ static struct se_device *rd_create_virtdevice(
 	dev_limits.queue_depth = RD_DEVICE_QUEUE_DEPTH;
 
 	dev = transport_add_device_to_core_hba(hba,
-			(rd_dev->rd_direct) ? &rd_dr_template :
 			&rd_mcp_template, se_dev, dev_flags, rd_dev,
 			&dev_limits, prod, rev);
 	if (!(dev))
@@ -293,6 +294,7 @@ fail:
 	return ERR_PTR(ret);
 }
 
+#if 0
 static struct se_device *rd_DIRECT_create_virtdevice(
 	struct se_hba *hba,
 	struct se_subsystem_dev *se_dev,
@@ -300,6 +302,7 @@ static struct se_device *rd_DIRECT_create_virtdevice(
 {
 	return rd_create_virtdevice(hba, se_dev, p, 1);
 }
+#endif
 
 static struct se_device *rd_MEMCPY_create_virtdevice(
 	struct se_hba *hba,
@@ -641,6 +644,7 @@ static int rd_MEMCPY_do_task(struct se_task *task)
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
+#if 0
 /*	rd_DIRECT_with_offset():
  *
  *
@@ -907,6 +911,7 @@ static int rd_DIRECT_do_task(struct se_task *task)
 
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
+#endif
 
 /*	rd_free_task(): (Part of se_subsystem_api_t template)
  *
@@ -1022,6 +1027,7 @@ static sector_t rd_get_blocks(struct se_device *dev)
 	return blocks_long;
 }
 
+#if 0
 static struct se_subsystem_api rd_dr_template = {
 	.name			= "rd_dr",
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_VDEV,
@@ -1042,6 +1048,7 @@ static struct se_subsystem_api rd_dr_template = {
 	.get_blocks		= rd_get_blocks,
 	.do_se_mem_map		= rd_DIRECT_do_se_mem_map,
 };
+#endif
 
 static struct se_subsystem_api rd_mcp_template = {
 	.name			= "rd_mcp",
@@ -1067,13 +1074,17 @@ int __init rd_module_init(void)
 {
 	int ret;
 
+#if 0
 	ret = transport_subsystem_register(&rd_dr_template);
 	if (ret < 0)
 		return ret;
+#endif
 
 	ret = transport_subsystem_register(&rd_mcp_template);
 	if (ret < 0) {
+#if 0
 		transport_subsystem_release(&rd_dr_template);
+#endif
 		return ret;
 	}
 
@@ -1082,6 +1093,8 @@ int __init rd_module_init(void)
 
 void rd_module_exit(void)
 {
+#if 0
 	transport_subsystem_release(&rd_dr_template);
+#endif
 	transport_subsystem_release(&rd_mcp_template);
 }
-- 
1.7.1

