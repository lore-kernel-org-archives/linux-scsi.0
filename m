From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] Allow $STORAGE_OBJECT/attrib/queue_depth for virtual
	subsystem plugins (RAMDISK, IBLOCK, FILEIO) beyond default hardcoded value.
Date: Wed, 19 Nov 2008 17:37:11 -0800
Message-ID: <1227145031.4192.316.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:35058 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752663AbYKTBhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2008 20:37:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 17e6a1e8dac7fceb2507ccd690206564b5bdf08a Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 19 Nov 2008 11:52:44 -0800
Subject: [PATCH] Allow $STORAGE_OBJECT/attrib/queue_depth for virtual subsystem plugins (RAMDISK, IBLOCK, FILEIO)
 beyond default hardcoded value.

Previously, /sys/kernel/config/target/core/$PLUGIN_HBA/$STORAGE_OBJECT/attrib/queue_depth
was only able to change the value below the return of se_subsystem_api_t->get_queue_depth().
This patch changes se_dev_set_queue_depth() to allow all non TRANSPORT_PLUGIN_PHBA_PDEV type
plugins (eg: non PSCSI) to increase the device object's queue_depth up to
se_subsystem_api_t->get_max_queue_depth().

This patch also adds the se_subsystem_api_t->get_max_queue_depth() to RAMDISK, IBLOCK and FILEIO
subsystem plugins.

Forward port to v3.0 Target_Core_Mod/ConfigFS from v2.9-STABLE r404

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_device.c    |   28 +++++++++++++++++++++++-----
 drivers/lio-core/target_core_file.c      |    5 +++++
 drivers/lio-core/target_core_file.h      |    3 +++
 drivers/lio-core/target_core_iblock.c    |    5 +++++
 drivers/lio-core/target_core_iblock.h    |    3 +++
 drivers/lio-core/target_core_rd.c        |    5 +++++
 drivers/lio-core/target_core_rd.h        |    4 ++++
 drivers/lio-core/target_core_transport.h |    4 ++++
 8 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 77462a9..974574a 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -461,11 +461,29 @@ extern int se_dev_set_queue_depth (se_device_t *dev, u32 queue_depth)
 		TRACE_ERROR("dev[%p]: Illegal ZERO value for queue_depth\n", dev);
 		return(-1);
 	}
-	if (queue_depth > TRANSPORT(dev)->get_queue_depth(dev)) {
-		TRACE_ERROR("dev[%p]: Passed queue_depth: %u exceeds"
-			" LIO-Core/SE_Device TCQ: %u\n", dev, queue_depth,
-			TRANSPORT(dev)->get_queue_depth(dev));
-		return(-1);
+	
+	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
+		if (queue_depth > TRANSPORT(dev)->get_queue_depth(dev)) {
+			TRACE_ERROR("dev[%p]: Passed queue_depth: %u exceeds"
+				" LIO-Core/SE_Device TCQ: %u\n", dev, queue_depth,
+				TRANSPORT(dev)->get_queue_depth(dev));
+			return(-1);
+		}
+	} else {
+		if (queue_depth > TRANSPORT(dev)->get_queue_depth(dev)) {
+			if (!(TRANSPORT(dev)->get_max_queue_depth)) {
+				TRACE_ERROR("dev[%p]: Unable to locate "
+					"get_max_queue_depth() function"
+					" pointer\n", dev);
+				return(-1);
+			}
+			if (queue_depth > TRANSPORT(dev)->get_max_queue_depth(dev)) {
+				TRACE_ERROR("dev[%p]: Passed queue_depth: %u exceeds"
+				" LIO-Core/SE_Device MAX TCQ: %u\n", dev, queue_depth,
+					TRANSPORT(dev)->get_max_queue_depth(dev));
+				return(-1);
+			}
+		}
 	}
 		
 	DEV_ATTRIB(dev)->queue_depth = dev->queue_depth = queue_depth;
diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index 9bd83d4..8c7c202 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -1251,6 +1251,11 @@ extern u32 fd_get_queue_depth (se_device_t *dev)
 	return(FD_DEVICE_QUEUE_DEPTH);
 }
 
+extern u32 fd_get_max_queue_depth (se_device_t *dev)
+{
+	return(FD_MAX_DEVICE_QUEUE_DEPTH);
+}
+
 /*	fd_get_non_SG(): (Part of se_subsystem_api_t template)
  *
  *
diff --git a/drivers/lio-core/target_core_file.h b/drivers/lio-core/target_core_file.h
index aba8f2d..7b7f59d 100644
--- a/drivers/lio-core/target_core_file.h
+++ b/drivers/lio-core/target_core_file.h
@@ -35,6 +35,7 @@
 #define FD_MAX_DEV_NAME		256
 #define FD_HBA_QUEUE_DEPTH	256		/* Maximum queuedepth for the FILEIO HBA */
 #define FD_DEVICE_QUEUE_DEPTH	32
+#define FD_MAX_DEVICE_QUEUE_DEPTH 128
 #define FD_BLOCKSIZE		512
 #define FD_MAX_SECTORS		1024
 
@@ -80,6 +81,7 @@ extern u32 fd_get_device_type (se_device_t *);
 extern u32 fd_get_dma_length (u32, se_device_t *);
 extern u32 fd_get_max_sectors (se_device_t *);
 extern u32 fd_get_queue_depth (se_device_t *);
+extern u32 fd_get_max_queue_depth (se_device_t *);
 extern unsigned char *fd_get_non_SG (se_task_t *);
 extern struct scatterlist *fd_get_SG (se_task_t *);
 extern u32 fd_get_SG_count (se_task_t *);
@@ -193,6 +195,7 @@ se_subsystem_spc_t fileio_template_spc = ISCSI_FILEIO_SPC;
 	get_evpd_sn:		fd_get_evpd_sn,			\
 	get_max_sectors:	fd_get_max_sectors,		\
 	get_queue_depth:	fd_get_queue_depth,		\
+	get_max_queue_depth:	fd_get_max_queue_depth,		\
 	get_non_SG:		fd_get_non_SG,			\
 	get_SG:			fd_get_SG,			\
 	get_SG_count:		fd_get_SG_count,		\
diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index 5ae04d1..1794806 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -901,6 +901,11 @@ extern u32 iblock_get_queue_depth (se_device_t *dev)
 	return(IBLOCK_DEVICE_QUEUE_DEPTH);
 }
 
+extern u32 iblock_get_max_queue_depth (se_device_t *dev)
+{
+	return(IBLOCK_MAX_DEVICE_QUEUE_DEPTH);
+}
+
 extern unsigned char *iblock_get_non_SG (se_task_t *task)
 {
 	return((unsigned char *)task->iscsi_cmd->t_task->t_task_buf);
diff --git a/drivers/lio-core/target_core_iblock.h b/drivers/lio-core/target_core_iblock.h
index d0d8da1..3a2b910 100644
--- a/drivers/lio-core/target_core_iblock.h
+++ b/drivers/lio-core/target_core_iblock.h
@@ -34,6 +34,7 @@
 #define IBLOCK_MAX_SECTORS	128
 #define IBLOCK_HBA_QUEUE_DEPTH	512
 #define IBLOCK_DEVICE_QUEUE_DEPTH	32
+#define IBLOCK_MAX_DEVICE_QUEUE_DEPTH	128
 #define IBLOCK_MAX_CDBS		16
 #define IBLOCK_LBA_SHIFT	9
 
@@ -76,6 +77,7 @@ extern u32 iblock_get_device_type (se_device_t *);
 extern u32 iblock_get_dma_length (u32, se_device_t *);
 extern u32 iblock_get_max_sectors (se_device_t *);
 extern u32 iblock_get_queue_depth (se_device_t *);
+extern u32 iblock_get_max_queue_depth (se_device_t *);
 extern unsigned char *iblock_get_non_SG (se_task_t *);
 extern struct scatterlist *iblock_get_SG (se_task_t *);
 extern u32 iblock_get_SG_count (se_task_t *);
@@ -168,6 +170,7 @@ se_subsystem_spc_t iblock_template_spc = ISCSI_IBLOCK_SPC;
 	get_evpd_sn:		iblock_get_evpd_sn,		\
 	get_max_sectors:	iblock_get_max_sectors,		\
 	get_queue_depth:	iblock_get_queue_depth,		\
+	get_max_queue_depth:	iblock_get_max_queue_depth,	\
 	get_non_SG:		iblock_get_non_SG,		\
 	get_SG:			iblock_get_SG,			\
 	get_SG_count:		iblock_get_SG_count,		\
diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index 135999c..3c268ca 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -1382,6 +1382,11 @@ extern u32 rd_get_queue_depth (se_device_t *dev)
 	return(RD_DEVICE_QUEUE_DEPTH);
 }
 
+extern u32 rd_get_max_queue_depth (se_device_t *dev)
+{
+	return(RD_MAX_DEVICE_QUEUE_DEPTH);
+}
+
 /*	rd_get_non_SG(): (Part of se_subsystem_api_t template)
  *
  *
diff --git a/drivers/lio-core/target_core_rd.h b/drivers/lio-core/target_core_rd.h
index 829c568..165ecad 100644
--- a/drivers/lio-core/target_core_rd.h
+++ b/drivers/lio-core/target_core_rd.h
@@ -37,6 +37,7 @@
 #define RD_MAX_ALLOCATION_SIZE	65536		/* Largest piece of memory kmalloc can allocate */
 #define RD_HBA_QUEUE_DEPTH	256		/* Maximum queuedepth for the Ramdisk HBA */
 #define RD_DEVICE_QUEUE_DEPTH	32
+#define RD_MAX_DEVICE_QUEUE_DEPTH 128
 #define RD_BLOCKSIZE		512
 #define RD_MAX_SECTORS		1024
 
@@ -88,6 +89,7 @@ extern u32 rd_get_device_type (se_device_t *);
 extern u32 rd_get_dma_length (u32, se_device_t *);
 extern u32 rd_get_max_sectors (se_device_t *);
 extern u32 rd_get_queue_depth (se_device_t *);
+extern u32 rd_get_max_queue_depth (se_device_t *);
 extern unsigned char *rd_get_non_SG (se_task_t *);
 extern struct scatterlist *rd_get_SG (se_task_t *);
 extern u32 rd_get_SG_count (se_task_t *);
@@ -188,6 +190,7 @@ se_subsystem_spc_t rd_template_spc = ISCSI_RD_SPC;
 	get_evpd_sn:		rd_get_evpd_sn,			\
 	get_max_sectors:	rd_get_max_sectors,		\
 	get_queue_depth:	rd_get_queue_depth,		\
+	get_max_queue_depth:	rd_get_max_queue_depth,		\
 	do_se_mem_map:		rd_DIRECT_do_se_mem_map,	\
 	get_non_SG:		rd_get_non_SG,			\
 	get_SG:			rd_get_SG,			\
@@ -231,6 +234,7 @@ se_subsystem_api_t rd_dr_template = ISCSI_RD_DR;
 	get_evpd_sn:		rd_get_evpd_sn,			\
 	get_max_sectors:	rd_get_max_sectors,		\
 	get_queue_depth:	rd_get_queue_depth,		\
+	get_max_queue_depth:	rd_get_max_queue_depth,		\
 	get_non_SG:		rd_get_non_SG,			\
 	get_SG:			rd_get_SG,			\
 	get_SG_count:		rd_get_SG_count,		\
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 909050e..c2fd11a 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -405,6 +405,10 @@ typedef struct se_subsystem_api_s {
 	 */
 	__u32 (*get_queue_depth)(se_device_t *);
 	/*
+	 * get_max_queue_depth():
+	 */
+	__u32 (*get_max_queue_depth)(se_device_t *);
+	/*
 	 * do_se_mem_map():
 	 */
 	int (*do_se_mem_map)(se_task_t *, struct list_head *, void *, se_mem_t *, se_mem_t **, u32 *, u32 *);
-- 
1.5.4.1



