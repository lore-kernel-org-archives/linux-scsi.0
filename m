From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] tcm: Remove remaining code out of target_core_seobj.c
Date: Thu, 19 Aug 2010 15:13:08 -0700
Message-ID: <1282255988-12897-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:20849 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753883Ab0HSWNN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2010 18:13:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the remaining code in target_core_seobj.c into target_core_device.c
and target_core_transport.c.  It changes the 'void *p' pointer for these functions to
'struct se_device *dev', and also changes the function names to the following:

	dev_obj_export() -> core_dev_export()
	dev_obj_unexport() -> core_dev_unexport()
	dev_obj_max_sectors() -> transport_dev_max_sectors() (static inline)
	dev_obj_end_lba() -> transport_dev_end_lba() (static inline)
	dev_obj_do_se_mem_map() -> transport_do_se_mem_map() (static)
	dev_obj_get_mem_buf() -> transport_dev_get_mem_buf() (static inline)
	dev_obj_get_mem_SG() -> transport_dev_get_mem_SG() (static inline)
	dev_obj_get_map_SG() -> transport_dev_get_map_SG() (static inline)
	dev_obj_get_map_non_SG() -> transport_dev_get_map_non_SG() (static inline)
	dev_obj_get_map_none() -> transport_dev_get_map_none() (static inline)
	dev_obj_check_online() -> se_dev_check_online()
	dev_obj_check_shutdown() -> se_dev_check_shutdown()

The existing logic is left untouched, with the expection of one item in core_dev_export().
The original code in dev_obj_export() would obtain struct se_dev->se_port_lock
then struct se_lun->lun_sep_lock, and since there is no reason to be doing this with
a configfs control path which is enforcing individual LUN context control with
struct se_lun->lun_group, the order of the locks has been changed to be held individually.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Kbuild                        |    1 -
 drivers/target/target_core_configfs.c        |    1 -
 drivers/target/target_core_device.c          |   70 ++++++++-
 drivers/target/target_core_fabric_configfs.c |    1 -
 drivers/target/target_core_seobj.c           |  214 -------------------------
 drivers/target/target_core_seobj.h           |   47 ------
 drivers/target/target_core_tpg.c             |    5 +-
 drivers/target/target_core_transport.c       |  222 +++++++++++++++++++-------
 include/target/target_core_device.h          |    6 +
 9 files changed, 239 insertions(+), 328 deletions(-)
 delete mode 100644 drivers/target/target_core_seobj.c
 delete mode 100644 drivers/target/target_core_seobj.h

diff --git a/drivers/target/Kbuild b/drivers/target/Kbuild
index 7a1b473..3626934 100644
--- a/drivers/target/Kbuild
+++ b/drivers/target/Kbuild
@@ -8,7 +8,6 @@ target_core_mod-y		:= target_core_configfs.o \
 				   target_core_pr.o \
 				   target_core_alua.o \
 				   target_core_scdb.o \
-				   target_core_seobj.o \
 				   target_core_tmr.o \
 				   target_core_tpg.o \
 				   target_core_transport.o \
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f3635c4..b48340a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -49,7 +49,6 @@
 #include "target_core_alua.h"
 #include "target_core_hba.h"
 #include "target_core_pr.h"
-#include "target_core_seobj.h"
 #include "target_core_rd.h"
 
 struct list_head g_tf_list;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 082c914..ec30ddf 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -48,7 +48,6 @@
 #include "target_core_alua.h"
 #include "target_core_hba.h"
 #include "target_core_pr.h"
-#include "target_core_seobj.h"
 #include "target_core_ua.h"
 
 struct block_device *__linux_blockdevice_claim(
@@ -276,7 +275,7 @@ out:
 	 * Determine if the struct se_lun is online.
 	 */
 /* #warning FIXME: Check for LUN_RESET + UNIT Attention */
-	if (dev_obj_check_online(se_lun->lun_type_ptr) != 0) {
+	if (se_dev_check_online(se_lun->lun_type_ptr) != 0) {
 		se_cmd->scsi_sense_reason = NON_EXISTENT_LUN;
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		return -1;
@@ -344,7 +343,7 @@ extern int transport_get_lun_for_tmr(
 	 * Determine if the struct se_lun is online.
 	 */
 /* #warning FIXME: Check for LUN_RESET + UNIT Attention */
-	if (dev_obj_check_online(se_lun->lun_type_ptr) != 0) {
+	if (se_dev_check_online(se_lun->lun_type_ptr) != 0) {
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		return -1;
 	}
@@ -732,6 +731,48 @@ void core_release_port(struct se_device *dev, struct se_port *port)
 	return;
 }
 
+int core_dev_export(
+	struct se_device *dev,
+	struct se_portal_group *tpg,
+	struct se_lun *lun)
+{
+	struct se_port *port;
+	
+	port = core_alloc_port(dev);
+	if (!(port))
+		return -1;
+
+	lun->se_dev = dev;
+	se_dev_start(dev);
+
+	atomic_inc(&dev->dev_export_obj.obj_access_count);
+	core_export_port(dev, tpg, port, lun);
+	return 0;
+}
+
+void core_dev_unexport(
+	struct se_device *dev,
+	struct se_portal_group *tpg,
+	struct se_lun *lun)
+{
+	struct se_port *port = lun->lun_sep;
+
+	spin_lock(&lun->lun_sep_lock);
+	if (lun->lun_type_ptr == NULL) {
+		spin_unlock(&lun->lun_sep_lock);
+		return;
+	}
+	spin_unlock(&lun->lun_sep_lock);
+
+	spin_lock(&dev->se_port_lock);
+	atomic_dec(&dev->dev_export_obj.obj_access_count);
+	core_release_port(dev, port);
+	spin_unlock(&dev->se_port_lock);
+
+	se_dev_stop(dev);
+	lun->se_dev = NULL;
+}
+
 int transport_core_report_lun_response(struct se_cmd *se_cmd)
 {
 	struct se_dev_entry *deve;
@@ -959,6 +1000,29 @@ void se_dev_stop(struct se_device *dev)
 		msleep(10);
 }
 
+int se_dev_check_online(struct se_device *dev)
+{
+	int ret;
+
+	spin_lock(&dev->dev_status_lock);
+	ret = ((dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) ||
+	       (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED)) ? 0 : 1;
+	spin_unlock(&dev->dev_status_lock);
+	
+	return ret;
+}
+
+int se_dev_check_shutdown(struct se_device *dev)
+{
+	int ret;
+
+	spin_lock(&dev->dev_status_lock);
+	ret = (dev->dev_status & TRANSPORT_DEVICE_SHUTDOWN);
+	spin_unlock(&dev->dev_status_lock);
+
+	return ret;
+}
+
 void se_dev_set_default_attribs(struct se_device *dev)
 {
 	DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl = DA_EMULATE_UA_INTLLCK_CTRL;
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index f6015f7..d5eb1ad 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -48,7 +48,6 @@
 #include "target_core_alua.h"
 #include "target_core_hba.h"
 #include "target_core_pr.h"
-#include "target_core_seobj.h"
 
 #define TF_CIT_SETUP(_name, _item_ops, _group_ops, _attrs)		\
 static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf) \
diff --git a/drivers/target/target_core_seobj.c b/drivers/target/target_core_seobj.c
deleted file mode 100644
index 7ba4512..0000000
--- a/drivers/target/target_core_seobj.c
+++ /dev/null
@@ -1,214 +0,0 @@
-/*******************************************************************************
- * Filename:  target_core_seobj.c
- *
- * Copyright (c) 2006-2007 SBE, Inc.  All Rights Reserved.
- * Copyright (c) 2007-2009 Rising Tide Software, Inc.
- * Copyright (c) 2008-2009 Linux-iSCSI.org
- *
- * Nicholas A. Bellinger <nab@kernel.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- ******************************************************************************/
-
-
-#include <linux/string.h>
-#include <linux/timer.h>
-#include <linux/slab.h>
-#include <linux/blkdev.h>
-#include <linux/spinlock.h>
-#include <linux/smp_lock.h>
-#include <linux/in.h>
-
-#include <target/target_core_base.h>
-#include <target/target_core_device.h>
-#include <target/target_core_tpg.h>
-#include <target/target_core_transport.h>
-#include <target/target_core_fabric_ops.h>
-#include <target/target_core_configfs.h>
-
-#include "target_core_seobj.h"
-
-int dev_obj_export(void *p, struct se_portal_group *tpg, struct se_lun *lun)
-{
-	struct se_device *dev  = (struct se_device *)p;
-	struct se_port *port;
-
-	port = core_alloc_port(dev);
-	if (!(port))
-		return -1;
-
-	lun->se_dev = dev;
-	se_dev_start(p);
-
-	atomic_inc(&dev->dev_export_obj.obj_access_count);
-	core_export_port(dev, tpg, port, lun);
-	return 0;
-}
-
-void dev_obj_unexport(void *p, struct se_portal_group *tpg, struct se_lun *lun)
-{
-	struct se_device *dev  = (struct se_device *)p;
-	struct se_port *port = lun->lun_sep;
-
-	spin_lock(&dev->se_port_lock);
-	spin_lock(&lun->lun_sep_lock);
-	if (lun->lun_type_ptr == NULL) {
-		spin_unlock(&dev->se_port_lock);
-		spin_unlock(&lun->lun_sep_lock);
-		return;
-	}
-	spin_unlock(&lun->lun_sep_lock);
-
-	atomic_dec(&dev->dev_export_obj.obj_access_count);
-	core_release_port(dev, port);
-	spin_unlock(&dev->se_port_lock);
-
-	se_dev_stop(p);
-	lun->se_dev = NULL;
-}
-
-int dev_obj_max_sectors(void *p)
-{
-	struct se_device *dev  = (struct se_device *)p;
-
-	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		return (DEV_ATTRIB(dev)->max_sectors >
-			TRANSPORT(dev)->get_max_sectors(dev) ?
-			TRANSPORT(dev)->get_max_sectors(dev) :
-			DEV_ATTRIB(dev)->max_sectors);
-	} else
-		return DEV_ATTRIB(dev)->max_sectors;
-}
-
-unsigned long long dev_obj_end_lba(void *p)
-{
-	struct se_device *dev  = (struct se_device *)p;
-
-	 return dev->dev_sectors_total + 1;
-}
-
-int dev_obj_do_se_mem_map(
-	void *p,
-	struct se_task *task,
-	struct list_head *se_mem_list,
-	void *in_mem,
-	struct se_mem *in_se_mem,
-	struct se_mem **out_se_mem,
-	u32 *se_mem_cnt,
-	u32 *task_offset_in)
-{
-	struct se_device *dev  = (struct se_device *)p;
-	u32 task_offset = *task_offset_in;
-	int ret = 0;
-	/*
-	 * se_subsystem_api_t->do_se_mem_map is used when internal allocation
-	 * has been done by the transport plugin.
-	 */
-	if (TRANSPORT(dev)->do_se_mem_map) {
-		ret = TRANSPORT(dev)->do_se_mem_map(task, se_mem_list,
-				in_mem, in_se_mem, out_se_mem, se_mem_cnt,
-				task_offset_in);
-		if (ret == 0)
-			T_TASK(task->task_se_cmd)->t_task_se_num += *se_mem_cnt;
-
-		return ret;
-	}
-
-	/*
-	 * Assume default that transport plugin speaks preallocated
-	 * scatterlists.
-	 */
-	if (!(transport_calc_sg_num(task, in_se_mem, task_offset)))
-		return -1;
-
-	/*
-	 * struct se_task->task_sg now contains the struct scatterlist array.
-	 */
-	return transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
-		in_se_mem, out_se_mem, se_mem_cnt, task_offset_in);
-}
-
-int dev_obj_get_mem_buf(void *p, struct se_cmd *cmd)
-{
-	struct se_device *dev  = (struct se_device *)p;
-
-	cmd->transport_allocate_resources = (TRANSPORT(dev)->allocate_buf) ?
-		TRANSPORT(dev)->allocate_buf : &transport_generic_allocate_buf;
-	cmd->transport_free_resources = (TRANSPORT(dev)->free_buf) ?
-		TRANSPORT(dev)->free_buf : NULL;
-
-	return 0;
-}
-
-int dev_obj_get_mem_SG(void *p, struct se_cmd *cmd)
-{
-	struct se_device *dev  = (struct se_device *)p;
-
-	cmd->transport_allocate_resources = (TRANSPORT(dev)->allocate_DMA) ?
-		TRANSPORT(dev)->allocate_DMA : &transport_generic_get_mem;
-	cmd->transport_free_resources = (TRANSPORT(dev)->free_DMA) ?
-		TRANSPORT(dev)->free_DMA : NULL;
-
-	return 0;
-}
-
-map_func_t dev_obj_get_map_SG(void *p, int rw)
-{
-	struct se_device *dev  = (struct se_device *)p;
-
-	return (rw == SE_DIRECTION_WRITE) ? dev->transport->cdb_write_SG :
-		dev->transport->cdb_read_SG;
-}
-
-map_func_t dev_obj_get_map_non_SG(void *p, int rw)
-{
-	struct se_device *dev  = (struct se_device *)p;
-
-	return (rw == SE_DIRECTION_WRITE) ? dev->transport->cdb_write_non_SG :
-		dev->transport->cdb_read_non_SG;
-}
-
-map_func_t dev_obj_get_map_none(void *p)
-{
-	struct se_device *dev  = (struct se_device *)p;
-
-	return dev->transport->cdb_none;
-}
-
-int dev_obj_check_online(void *p)
-{
-	struct se_device *dev  = (struct se_device *)p;
-	int ret;
-
-	spin_lock(&dev->dev_status_lock);
-	ret = ((dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) ||
-	       (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED)) ? 0 : 1;
-	spin_unlock(&dev->dev_status_lock);
-
-	return ret;
-}
-
-int dev_obj_check_shutdown(void *p)
-{
-	struct se_device *dev  = (struct se_device *)p;
-	int ret;
-
-	spin_lock(&dev->dev_status_lock);
-	ret = (dev->dev_status & TRANSPORT_DEVICE_SHUTDOWN);
-	spin_unlock(&dev->dev_status_lock);
-
-	return ret;
-}
diff --git a/drivers/target/target_core_seobj.h b/drivers/target/target_core_seobj.h
deleted file mode 100644
index 4fbf4e7..0000000
--- a/drivers/target/target_core_seobj.h
+++ /dev/null
@@ -1,47 +0,0 @@
-/*******************************************************************************
- * Filename:  target_core_seobj.h
- *
- * Copyright (c) 2006-2007 SBE, Inc.  All Rights Reserved.
- * Copyright (c) 2007-2009 Rising Tide Software, Inc.
- * Copyright (c) 2008-2009 Linux-iSCSI.org
- *
- * Nicholas A. Bellinger <nab@kernel.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- ******************************************************************************/
-
-
-#ifndef TARGET_CORE_SEOBJ_H
-#define TARGET_CORE_SEOBJ_H
-
-typedef int (*map_func_t)(struct se_task *, u32);
-
-extern int dev_obj_export(void *, struct se_portal_group *, struct se_lun *);
-extern void dev_obj_unexport(void *, struct se_portal_group *, struct se_lun *);
-extern int dev_obj_max_sectors(void *);
-extern unsigned long long dev_obj_end_lba(void *);
-extern int dev_obj_do_se_mem_map(void *, struct se_task *, struct list_head *,
-			void *, struct se_mem *, struct se_mem **,
-			u32 *, u32 *);
-extern int dev_obj_get_mem_buf(void *, struct se_cmd *);
-extern int dev_obj_get_mem_SG(void *, struct se_cmd *);
-extern map_func_t dev_obj_get_map_SG(void *, int);
-extern map_func_t dev_obj_get_map_non_SG(void *, int);
-extern map_func_t dev_obj_get_map_none(void *);
-extern int dev_obj_check_online(void *);
-extern int dev_obj_check_shutdown(void *);
-
-#endif /* TARGET_CORE_SEOBJ_H */
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 925a486..d273698 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -45,7 +45,6 @@
 #include <target/target_core_fabric_ops.h>
 
 #include "target_core_hba.h"
-#include "target_core_seobj.h"
 
 /*	core_clear_initiator_node_from_tpg():
  *
@@ -759,7 +758,7 @@ int core_tpg_post_addlun(
 	void *lun_ptr)
 {
 	lun->lun_type_ptr = lun_ptr;
-	if (dev_obj_export(lun_ptr, tpg, lun) < 0) {
+	if (core_dev_export(lun_ptr, tpg, lun) < 0) {
 		lun->lun_type_ptr = NULL;
 		return -1;
 	}
@@ -832,7 +831,7 @@ int core_tpg_post_dellun(
 
 	core_tpg_shutdown_lun(tpg, lun);
 
-	dev_obj_unexport(lun->lun_type_ptr, tpg, lun);
+	core_dev_unexport(lun->lun_type_ptr, tpg, lun);
 
 	spin_lock(&tpg->tpg_lun_lock);
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8e9a2b9..1e5bd70 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -57,7 +57,6 @@
 #include "target_core_hba.h"
 #include "target_core_pr.h"
 #include "target_core_scdb.h"
-#include "target_core_seobj.h"
 #include "target_core_ua.h"
 
 /* #define DEBUG_CDB_HANDLER */
@@ -203,6 +202,9 @@ struct kmem_cache *t10_alua_lu_gp_mem_cache;
 struct kmem_cache *t10_alua_tg_pt_gp_cache;
 struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
 
+/* Used for transport_dev_get_map_*() */
+typedef int (*map_func_t)(struct se_task *, u32);
+
 static int transport_generic_write_pending(struct se_cmd *);
 static int transport_processing_thread(void *);
 
@@ -2448,6 +2450,20 @@ static inline void transport_generic_prepare_cdb(
 	}
 }
 
+static inline u32 transport_dev_max_sectors(struct se_device *dev)
+{
+	/*
+	 * Always enforce the underlying max_sectors for TCM/pSCSI
+	 */
+	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)
+		return (DEV_ATTRIB(dev)->max_sectors >
+			TRANSPORT(dev)->get_max_sectors(dev) ?
+			TRANSPORT(dev)->get_max_sectors(dev) :
+			DEV_ATTRIB(dev)->max_sectors);
+
+	return DEV_ATTRIB(dev)->max_sectors;
+}
+
 /*	transport_check_device_cdb_sector_count():
  *
  *	returns:
@@ -2460,9 +2476,9 @@ static inline int transport_check_device_cdb_sector_count(
 {
 	u32 max_sectors;
 
-	max_sectors = dev_obj_max_sectors(se_obj_ptr);
+	max_sectors = transport_dev_max_sectors(se_obj_ptr);
 	if (!(max_sectors)) {
-		printk(KERN_ERR "TRANSPORT->get_max_sectors returned zero!\n");
+		printk(KERN_ERR "transport_dev_max_sectors returned zero!\n");
 		return 1;
 	}
 
@@ -2527,6 +2543,28 @@ static inline int transport_generic_obj_start(
 	return 0;
 }
 
+static inline map_func_t transport_dev_get_map_SG(
+	struct se_device *dev,
+	int rw)
+{
+	return (rw == SE_DIRECTION_WRITE) ? dev->transport->cdb_write_SG :
+		dev->transport->cdb_read_SG;
+}
+
+static inline map_func_t transport_dev_get_map_non_SG(
+	struct se_device *dev,
+	int rw)
+{
+	return (rw == SE_DIRECTION_WRITE) ? dev->transport->cdb_write_non_SG :
+		dev->transport->cdb_read_non_SG;
+}
+
+static inline map_func_t transport_dev_get_map_none(
+	struct se_device *dev)
+{
+	return dev->transport->cdb_none;
+}
+
 static int transport_process_data_sg_transform(
 	struct se_cmd *cmd,
 	struct se_transform_info *ti)
@@ -2537,6 +2575,10 @@ static int transport_process_data_sg_transform(
 	return 0;
 }
 
+static int transport_do_se_mem_map(struct se_device *, struct se_task *,
+	struct list_head *, void *, struct se_mem *, struct se_mem **,
+	u32 *, u32 *);
+
 /*	transport_process_control_sg_transform():
  *
  *
@@ -2564,7 +2606,7 @@ static int transport_process_control_sg_transform(
 	if (!(task))
 		return -1;
 
-	task->transport_map_task = dev_obj_get_map_SG(ti->se_obj_ptr,
+	task->transport_map_task = transport_dev_get_map_SG(ti->se_obj_ptr,
 				cmd->data_direction);
 
 	cdb = TRANSPORT(dev)->get_cdb(task);
@@ -2577,7 +2619,7 @@ static int transport_process_control_sg_transform(
 	atomic_inc(&T_TASK(cmd)->t_fe_count);
 	atomic_inc(&T_TASK(cmd)->t_se_count);
 
-	ret = dev_obj_do_se_mem_map(ti->se_obj_ptr, task,
+	ret = transport_do_se_mem_map(ti->se_obj_ptr, task,
 			T_TASK(cmd)->t_mem_list, NULL, se_mem, &se_mem_lout,
 			&se_mem_cnt, &task_offset);
 	if (ret < 0)
@@ -2604,7 +2646,7 @@ static int transport_process_control_nonsg_transform(
 	if (!(task))
 		return -1;
 
-	task->transport_map_task = dev_obj_get_map_non_SG(ti->se_obj_ptr,
+	task->transport_map_task = transport_dev_get_map_non_SG(ti->se_obj_ptr,
 				cmd->data_direction);
 
 	cdb = TRANSPORT(dev)->get_cdb(task);
@@ -2638,7 +2680,7 @@ static int transport_process_non_data_transform(
 	if (!(task))
 		return -1;
 
-	task->transport_map_task = dev_obj_get_map_none(ti->se_obj_ptr);
+	task->transport_map_task = transport_dev_get_map_none(ti->se_obj_ptr);
 
 	cdb = TRANSPORT(dev)->get_cdb(task);
 	if (cdb)
@@ -4007,7 +4049,7 @@ int transport_execute_tasks(struct se_cmd *cmd)
 	int add_tasks;
 
 	if (!(cmd->se_cmd_flags & SCF_SE_DISABLE_ONLINE_CHECK)) {
-		if (dev_obj_check_online(cmd->se_orig_obj_ptr) != 0) {
+		if (se_dev_check_online(cmd->se_orig_obj_ptr) != 0) {
 			cmd->transport_error_status =
 				PYX_TRANSPORT_LU_COMM_FAILURE;
 			transport_generic_request_failure(cmd, NULL, 0, 1);
@@ -5110,6 +5152,26 @@ int transport_get_sense_data(struct se_cmd *cmd)
 	return -1;
 }
 
+static inline void transport_dev_get_mem_buf(
+	struct se_device *dev,
+	struct se_cmd *cmd)
+{
+	cmd->transport_allocate_resources = (TRANSPORT(dev)->allocate_buf) ?
+		TRANSPORT(dev)->allocate_buf : &transport_generic_allocate_buf;
+	cmd->transport_free_resources = (TRANSPORT(dev)->free_buf) ?
+		TRANSPORT(dev)->free_buf : NULL;
+}
+
+static inline void transport_dev_get_mem_SG(
+	struct se_device *dev,
+	struct se_cmd *cmd)
+{
+	cmd->transport_allocate_resources = (TRANSPORT(dev)->allocate_DMA) ?
+		TRANSPORT(dev)->allocate_DMA : &transport_generic_get_mem;
+	cmd->transport_free_resources = (TRANSPORT(dev)->free_DMA) ?
+		TRANSPORT(dev)->free_DMA : NULL;
+}
+
 /*
  * Generic function pointers for target_core_mod/ConfigFS
  */
@@ -5198,7 +5260,7 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_6;
 		cmd->transport_get_lba = &transport_lba_21;
@@ -5210,7 +5272,7 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->transport_get_lba = &transport_lba_32;
@@ -5222,7 +5284,7 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_12;
 		cmd->transport_get_lba = &transport_lba_32;
@@ -5234,7 +5296,7 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_16;
 		cmd->transport_get_long_lba = &transport_lba_64;
@@ -5246,7 +5308,7 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_6;
 		cmd->transport_get_lba = &transport_lba_21;
@@ -5258,7 +5320,7 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->transport_get_lba = &transport_lba_32;
@@ -5270,7 +5332,7 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_12;
 		cmd->transport_get_lba = &transport_lba_32;
@@ -5282,7 +5344,7 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_16;
 		cmd->transport_get_long_lba = &transport_lba_64;
@@ -5308,28 +5370,28 @@ static int transport_generic_cmd_sequencer(
 			/* GPCMD_SEND_KEY from multi media commands */
 			size = (cdb[8] << 8) + cdb[9];
 		}
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case MODE_SELECT:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = cdb[4];
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_SG_IO_CDB;
 		break;
 	case MODE_SELECT_10:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[7] << 8) + cdb[8];
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_SG_IO_CDB;
 		break;
 	case MODE_SENSE:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = cdb[4];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
@@ -5340,14 +5402,14 @@ static int transport_generic_cmd_sequencer(
 	case LOG_SENSE:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[7] << 8) + cdb[8];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case READ_BLOCK_LIMITS:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = READ_BLOCK_LEN;
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
@@ -5357,7 +5419,7 @@ static int transport_generic_cmd_sequencer(
 	case GPCMD_READ_TRACK_RZONE_INFO:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[7] << 8) + cdb[8];
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_SG_IO_CDB;
 		break;
@@ -5369,7 +5431,7 @@ static int transport_generic_cmd_sequencer(
 			 SPC3_PERSISTENT_RESERVATIONS) ?
 			&core_scsi3_emulate_pr : NULL;
 		size = (cdb[7] << 8) + cdb[8];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
@@ -5377,14 +5439,14 @@ static int transport_generic_cmd_sequencer(
 	case GPCMD_READ_DVD_STRUCTURE:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[8] << 8) + cdb[9];
-		dev_obj_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_SG_IO_CDB;
 		break;
 	case READ_POSITION:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = READ_POSITION_LEN;
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
@@ -5409,14 +5471,14 @@ static int transport_generic_cmd_sequencer(
 			/* GPCMD_REPORT_KEY from multi media commands */
 			size = (cdb[8] << 8) + cdb[9];
 		}
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case INQUIRY:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[3] << 8) + cdb[4];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		/*
 		 * Do implict HEAD_OF_QUEUE processing for INQUIRY.
@@ -5429,14 +5491,14 @@ static int transport_generic_cmd_sequencer(
 	case READ_BUFFER:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case READ_CAPACITY:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = READ_CAP_LEN;
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
@@ -5445,7 +5507,7 @@ static int transport_generic_cmd_sequencer(
 	case SECURITY_PROTOCOL_OUT:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
@@ -5459,14 +5521,14 @@ static int transport_generic_cmd_sequencer(
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[10] << 24) | (cdb[11] << 16) |
 		       (cdb[12] << 8) | cdb[13];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case VARIABLE_LENGTH_CMD:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[10] << 8) | cdb[11];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
@@ -5474,7 +5536,7 @@ static int transport_generic_cmd_sequencer(
 	case SEND_DIAGNOSTIC:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[3] << 8) | cdb[4];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
@@ -5484,7 +5546,7 @@ static int transport_generic_cmd_sequencer(
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		sectors = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
 		size = (2336 * sectors);
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
@@ -5492,28 +5554,28 @@ static int transport_generic_cmd_sequencer(
 	case READ_TOC:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = cdb[8];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case REQUEST_SENSE:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = cdb[4];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case READ_ELEMENT_STATUS:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = 65536 * cdb[7] + 256 * cdb[8] + cdb[9];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case WRITE_BUFFER:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
@@ -5592,7 +5654,7 @@ static int transport_generic_cmd_sequencer(
 		cmd->transport_emulate_cdb =
 				&transport_core_report_lun_response;
 		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
-		dev_obj_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
 		/*
 		 * Do implict HEAD_OF_QUEUE processing for REPORT_LUNS
@@ -5695,8 +5757,8 @@ struct se_cmd *transport_allocate_passthrough(
 	/*
 	 * Double check that the passed object is currently accepting CDBs
 	 */
-	if (dev_obj_check_online(type_ptr) != 0) {
-		DEBUG_SO("dev_obj_check_online() failed!\n");
+	if (se_dev_check_online(type_ptr) != 0) {
+		DEBUG_SO("se_dev_check_online() failed!\n");
 		goto fail;
 	}
 
@@ -5794,7 +5856,7 @@ EXPORT_SYMBOL(transport_passthrough_release);
 int transport_passthrough_complete(
 	struct se_cmd *cmd)
 {
-	if (dev_obj_check_shutdown(cmd->se_orig_obj_ptr) != 0)
+	if (se_dev_check_shutdown(cmd->se_orig_obj_ptr) != 0)
 		return -2;
 
 	switch (cmd->scsi_status) {
@@ -6381,6 +6443,11 @@ int transport_generic_do_transform(struct se_cmd *cmd, struct se_transform_info
 	return 0;
 }
 
+static inline long long transport_dev_end_lba(struct se_device *dev)
+{
+	return dev->dev_sectors_total + 1;
+}
+
 int transport_get_sectors(
 	struct se_cmd *cmd,
 	void *obj_ptr)
@@ -6399,11 +6466,11 @@ int transport_get_sectors(
 		return 0;
 
 	if ((T_TASK(cmd)->t_task_lba + T_TASK(cmd)->t_task_sectors) >
-	     dev_obj_end_lba(obj_ptr)) {
+	     transport_dev_end_lba(obj_ptr)) {
 		printk(KERN_ERR "LBA: %llu Sectors: %u exceeds"
-			" dev_obj_end_lba(): %llu\n",
+			" transport_dev_end_lba(): %llu\n",
 			T_TASK(cmd)->t_task_lba, T_TASK(cmd)->t_task_sectors,
-			dev_obj_end_lba(obj_ptr));
+			transport_dev_end_lba(obj_ptr));
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason = SECTOR_COUNT_TOO_MANY;
 		return PYX_TRANSPORT_REQ_TOO_MANY_SECTORS;
@@ -6630,16 +6697,16 @@ static inline int transport_set_task_sectors_disk(
 	u32 sectors,
 	int *max_sectors_set)
 {
-	if ((lba + sectors) > dev_obj_end_lba(obj_ptr)) {
-		task->task_sectors = ((dev_obj_end_lba(obj_ptr) - lba) + 1);
+	if ((lba + sectors) > transport_dev_end_lba(obj_ptr)) {
+		task->task_sectors = ((transport_dev_end_lba(obj_ptr) - lba) + 1);
 
-		if (task->task_sectors > dev_obj_max_sectors(obj_ptr)) {
-			task->task_sectors = dev_obj_max_sectors(obj_ptr);
+		if (task->task_sectors > transport_dev_max_sectors(obj_ptr)) {
+			task->task_sectors = transport_dev_max_sectors(obj_ptr);
 			*max_sectors_set = 1;
 		}
 	} else {
-		if (sectors > dev_obj_max_sectors(obj_ptr)) {
-			task->task_sectors = dev_obj_max_sectors(obj_ptr);
+		if (sectors > transport_dev_max_sectors(obj_ptr)) {
+			task->task_sectors = transport_dev_max_sectors(obj_ptr);
 			*max_sectors_set = 1;
 		} else
 			task->task_sectors = sectors;
@@ -6655,8 +6722,8 @@ static inline int transport_set_task_sectors_non_disk(
 	u32 sectors,
 	int *max_sectors_set)
 {
-	if (sectors > dev_obj_max_sectors(obj_ptr)) {
-		task->task_sectors = dev_obj_max_sectors(obj_ptr);
+	if (sectors > transport_dev_max_sectors(obj_ptr)) {
+		task->task_sectors = transport_dev_max_sectors(obj_ptr);
 		*max_sectors_set = 1;
 	} else
 		task->task_sectors = sectors;
@@ -6843,6 +6910,45 @@ next:
 	return 0;
 }
 
+static int transport_do_se_mem_map(
+	struct se_device *dev,
+	struct se_task *task,
+	struct list_head *se_mem_list,
+	void *in_mem,
+	struct se_mem *in_se_mem,
+	struct se_mem **out_se_mem,
+	u32 *se_mem_cnt,
+	u32 *task_offset_in)
+{
+	u32 task_offset = *task_offset_in;
+	int ret = 0;
+	/*
+	 * se_subsystem_api_t->do_se_mem_map is used when internal allocation
+	 * has been done by the transport plugin.
+	 */
+	if (TRANSPORT(dev)->do_se_mem_map) {
+		ret = TRANSPORT(dev)->do_se_mem_map(task, se_mem_list,
+				in_mem, in_se_mem, out_se_mem, se_mem_cnt,
+				task_offset_in);
+		if (ret == 0)
+			T_TASK(task->task_se_cmd)->t_task_se_num += *se_mem_cnt;
+
+		return ret;
+	}
+	/*
+	 * Assume default that transport plugin speaks preallocated
+	 * scatterlists.
+	 */
+	if (!(transport_calc_sg_num(task, in_se_mem, task_offset)))
+		return -1;
+	/*
+	 * struct se_task->task_sg now contains the struct scatterlist array.
+	 */
+	return transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
+					in_se_mem, out_se_mem, se_mem_cnt,
+					task_offset_in);
+}
+
 u32 transport_generic_get_cdb_count(
 	struct se_cmd *cmd,
 	struct se_transform_info *ti,
@@ -6890,7 +6996,7 @@ u32 transport_generic_get_cdb_count(
 
 		DEBUG_VOL("ITT[0x%08x] LBA(%llu) SectorsLeft(%u) EOBJ(%llu)\n",
 			CMD_TFO(cmd)->get_task_tag(cmd), lba, sectors,
-			dev_obj_end_lba(obj_ptr));
+			transport_dev_end_lba(obj_ptr));
 
 		task = cmd->transport_get_task(ti, cmd, obj_ptr);
 		if (!(task))
@@ -6904,8 +7010,8 @@ u32 transport_generic_get_cdb_count(
 		sectors -= task->task_sectors;
 		task->task_size = (task->task_sectors *
 				   DEV_ATTRIB(dev)->block_size);
-		task->transport_map_task = dev_obj_get_map_SG(
-				obj_ptr, cmd->data_direction);
+		task->transport_map_task = transport_dev_get_map_SG(obj_ptr,
+					cmd->data_direction);
 
 		cdb = TRANSPORT(dev)->get_cdb(task);
 		if ((cdb)) {
@@ -6918,7 +7024,7 @@ u32 transport_generic_get_cdb_count(
 		 * Perform the SE OBJ plugin and/or Transport plugin specific
 		 * mapping for T_TASK(cmd)->t_mem_list.
 		 */
-		ret = dev_obj_do_se_mem_map(obj_ptr, task,
+		ret = transport_do_se_mem_map((struct se_device *)obj_ptr, task,
 				T_TASK(cmd)->t_mem_list, NULL, se_mem,
 				&se_mem_lout, &se_mem_cnt, &task_offset_in);
 		if (ret < 0)
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index aebfb4e..e895604 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -51,6 +51,10 @@ extern struct se_port *core_alloc_port(struct se_device *);
 extern void core_export_port(struct se_device *, struct se_portal_group *,
 					struct se_port *, struct se_lun *);
 extern void core_release_port(struct se_device *, struct se_port *);
+extern int core_dev_export(struct se_device *, struct se_portal_group *,
+					struct se_lun *);
+extern void core_dev_unexport(struct se_device *, struct se_portal_group *,
+					struct se_lun *);
 extern int transport_core_report_lun_response(struct se_cmd *);
 extern void se_release_device_for_hba(struct se_device *);
 extern void se_release_vpd_for_dev(struct se_device *);
@@ -58,6 +62,8 @@ extern void se_clear_dev_ports(struct se_device *);
 extern int se_free_virtual_device(struct se_device *, struct se_hba *);
 extern void se_dev_start(struct se_device *);
 extern void se_dev_stop(struct se_device *);
+extern int se_dev_check_online(struct se_device *);
+extern int se_dev_check_shutdown(struct se_device *);
 extern void se_dev_set_default_attribs(struct se_device *);
 extern int se_dev_set_task_timeout(struct se_device *, u32);
 extern int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *, int);
-- 
1.5.6.5

