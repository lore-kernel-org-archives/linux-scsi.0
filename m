From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/8] target: consolidate se_global externs
Date: Tue, 23 Nov 2010 17:30:54 -0500
Message-ID: <20101123223109.322454076@bombadil.infradead.org>
References: <20101123223053.574330460@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50168 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab0KWWbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 17:31:10 -0500
Content-Disposition: inline; filename=lio-kill-se_global-externs
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/lio-target/iscsi_target_mib.h
===================================================================
--- lio-core.orig/drivers/target/lio-target/iscsi_target_mib.h	2010-11-22 22:58:54.556005310 +0100
+++ lio-core/drivers/target/lio-target/iscsi_target_mib.h	2010-11-22 22:58:58.684264410 +0100
@@ -76,7 +76,6 @@ extern void remove_iscsi_target_mib(void
 extern void init_iscsi_index_table(void);
 extern u32 iscsi_get_new_index(iscsi_index_t);
 
-extern struct se_global *se_global;
 extern struct iscsi_global *iscsi_global;
 
 #endif   /*** ISCSI_TARGET_MIB_H ***/
Index: lio-core/drivers/target/target_core_alua.h
===================================================================
--- lio-core.orig/drivers/target/target_core_alua.h	2010-11-22 23:00:47.665254437 +0100
+++ lio-core/drivers/target/target_core_alua.h	2010-11-22 23:00:49.664255060 +0100
@@ -61,8 +61,6 @@
  */
 #define ALUA_SECONDARY_METADATA_WWN_LEN			256
 
-extern struct se_global *se_global;
-
 extern struct kmem_cache *t10_alua_lu_gp_cache;
 extern struct kmem_cache *t10_alua_lu_gp_mem_cache;
 extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
Index: lio-core/drivers/target/target_core_file.h
===================================================================
--- lio-core.orig/drivers/target/target_core_file.h	2010-11-22 22:59:15.077260722 +0100
+++ lio-core/drivers/target/target_core_file.h	2010-11-22 22:59:17.612255907 +0100
@@ -11,8 +11,6 @@
 #define FD_BLOCKSIZE		512
 #define FD_MAX_SECTORS		1024
 
-extern struct se_global *se_global;
-
 #define RRF_EMULATE_CDB		0x01
 #define RRF_GOT_LBA		0x02
 
Index: lio-core/drivers/target/target_core_hba.h
===================================================================
--- lio-core.orig/drivers/target/target_core_hba.h	2010-11-22 23:01:00.589012434 +0100
+++ lio-core/drivers/target/target_core_hba.h	2010-11-22 23:01:02.425281117 +0100
@@ -1,8 +1,6 @@
 #ifndef TARGET_CORE_HBA_H
 #define TARGET_CORE_HBA_H
 
-extern struct se_global *se_global;
-
 extern struct kmem_cache *se_hba_cache;
 
 extern int core_get_hba(struct se_hba *);
Index: lio-core/drivers/target/target_core_iblock.h
===================================================================
--- lio-core.orig/drivers/target/target_core_iblock.h	2010-11-22 23:01:05.726255904 +0100
+++ lio-core/drivers/target/target_core_iblock.h	2010-11-22 23:01:07.752284613 +0100
@@ -9,8 +9,6 @@
 #define IBLOCK_MAX_CDBS		16
 #define IBLOCK_LBA_SHIFT	9
 
-extern struct se_global *se_global;
-
 struct iblock_req {
 	struct se_task ib_task;
 	unsigned char ib_scsi_cdb[TCM_MAX_COMMAND_SIZE];
Index: lio-core/drivers/target/target_core_mib.h
===================================================================
--- lio-core.orig/drivers/target/target_core_mib.h	2010-11-22 23:01:20.790010409 +0100
+++ lio-core/drivers/target/target_core_mib.h	2010-11-22 23:01:22.762065871 +0100
@@ -1,8 +1,6 @@
 #ifndef TARGET_CORE_MIB_H
 #define TARGET_CORE_MIB_H
 
-extern struct se_global *se_global;
-
 typedef enum {
 	SCSI_INST_INDEX,
 	SCSI_DEVICE_INDEX,
Index: lio-core/drivers/target/target_core_pscsi.h
===================================================================
--- lio-core.orig/drivers/target/target_core_pscsi.h	2010-11-22 23:01:26.717260165 +0100
+++ lio-core/drivers/target/target_core_pscsi.h	2010-11-22 23:01:31.137267076 +0100
@@ -16,8 +16,6 @@
 #define PS_TIMEOUT_DISK		(15*HZ)
 #define PS_TIMEOUT_OTHER	(500*HZ)
 
-extern struct se_global *se_global;
-
 #include <linux/device.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_device.h>
Index: lio-core/drivers/target/target_core_rd.h
===================================================================
--- lio-core.orig/drivers/target/target_core_rd.h	2010-11-22 23:01:35.306022911 +0100
+++ lio-core/drivers/target/target_core_rd.h	2010-11-22 23:01:37.089005878 +0100
@@ -14,8 +14,6 @@
 #define RD_BLOCKSIZE		512
 #define RD_MAX_SECTORS		1024
 
-extern struct se_global *se_global;
-
 extern struct kmem_cache *se_mem_cache;
 
 /* Used in target_core_init_configfs() for virtual LUN 0 access */
Index: lio-core/drivers/target/target_core_stgt.h
===================================================================
--- lio-core.orig/drivers/target/target_core_stgt.h	2010-11-22 23:01:42.267003356 +0100
+++ lio-core/drivers/target/target_core_stgt.h	2010-11-22 23:01:44.354026748 +0100
@@ -11,8 +11,6 @@
 #define PS_TIMEOUT_DISK		(15*HZ)
 #define PS_TIMEOUT_OTHER	(500*HZ)
 
-extern struct se_global *se_global;
-
 #include <linux/device.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_device.h>
Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2010-11-22 23:02:15.221260794 +0100
+++ lio-core/drivers/target/target_core_transport.c	2010-11-22 23:02:18.795255486 +0100
@@ -186,7 +186,6 @@
 #endif
 
 struct se_global *se_global;
-EXPORT_SYMBOL(se_global);
 
 static struct kmem_cache *se_cmd_cache;
 static struct kmem_cache *se_sess_cache;
Index: lio-core/include/target/target_core_configfs.h
===================================================================
--- lio-core.orig/include/target/target_core_configfs.h	2010-11-22 22:59:34.818253040 +0100
+++ lio-core/include/target/target_core_configfs.h	2010-11-22 22:59:37.451028987 +0100
@@ -5,8 +5,6 @@
 #define TARGET_CORE_NAME_MAX_LEN	64
 #define TARGET_FABRIC_NAME_SIZE		32
 
-extern struct se_global *se_global;
-
 extern struct target_fabric_configfs *target_fabric_configfs_init(
 				struct module *, const char *);
 extern void target_fabric_configfs_free(struct target_fabric_configfs *);
Index: lio-core/include/target/target_core_device.h
===================================================================
--- lio-core.orig/include/target/target_core_device.h	2010-11-22 23:00:14.935004123 +0100
+++ lio-core/include/target/target_core_device.h	2010-11-22 23:00:19.264030183 +0100
@@ -1,8 +1,6 @@
 #ifndef TARGET_CORE_DEVICE_H
 #define TARGET_CORE_DEVICE_H
 
-extern struct se_global *se_global;
-
 extern int transport_get_lun_for_cmd(struct se_cmd *, unsigned char *, u32);
 extern int transport_get_lun_for_tmr(struct se_cmd *, u32);
 extern struct se_dev_entry *core_get_se_deve_from_rtpi(
Index: lio-core/include/target/target_core_tpg.h
===================================================================
--- lio-core.orig/include/target/target_core_tpg.h	2010-11-22 23:00:29.978003774 +0100
+++ lio-core/include/target/target_core_tpg.h	2010-11-22 23:00:32.143068375 +0100
@@ -1,8 +1,6 @@
 #ifndef TARGET_CORE_TPG_H
 #define TARGET_CORE_TPG_H
 
-extern struct se_global *se_global;
- 
 extern struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 						const char *);
 extern struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
Index: lio-core/include/target/target_core_transport.h
===================================================================
--- lio-core.orig/include/target/target_core_transport.h	2010-11-22 23:00:14.947004472 +0100
+++ lio-core/include/target/target_core_transport.h	2010-11-22 23:00:25.745263933 +0100
@@ -374,5 +374,6 @@ struct se_subsystem_api {
 #define TRANSPORT(dev)		((dev)->transport)
 #define HBA_TRANSPORT(hba)	((hba)->transport)
 
-#endif /* TARGET_CORE_TRANSPORT_H */
+extern struct se_global *se_global;
 
+#endif /* TARGET_CORE_TRANSPORT_H */

