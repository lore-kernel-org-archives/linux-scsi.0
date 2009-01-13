From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] [Target_Core_Mod]: Complete conversion to generic
	REPORT_LUNS functionality
Date: Tue, 13 Jan 2009 13:15:57 -0800
Message-ID: <1231881357.1274.43.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:22026 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752828AbZAMVQY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 16:16:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greetings all,

This patch is made against lio-core-2.6.git/master
and tested on v2.6.28.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Thanks,

--nab

>From 01242e6614cc442b862c428d11fb593b1168b064 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 13 Jan 2009 12:56:48 -0800
Subject: [PATCH 1/2] [Target_Core_Mod]: Complete conversion to generic REPORT_LUNS functionality

This patch completes the $FABRIC_MOD independent conversion for REPORT_LUNS in
v3.0 target_core_mod code.  This patch removes the target_core_reportluns.[c,h]
files all together, and adds the following:

I) Move REPORT_LUNS response emulation support to transport_core_report_lun_response()
   in target_core_device.c.
II) REPORT_LUNS support to transport_generic_cmd_sequencer()
III) New se_cmd_t->transport_emulate_cdb() to catch REPORT_LUNS in
     __transport_execute_tasks()

Also, this patch fixes a BUG that was brought forward from v2.9 code for
REPORT_LUNS response emulation where the following check:

       spin_lock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
       for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
               deve = &SE_NODE_ACL(se_sess)->device_list[i];
               if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
                       continue;
               se_lun = deve->se_lun;
               /*
                * We determine the correct LUN LIST LENGTH even once we
                * have reached the initial allocation length.
                * See SPC2-R20 7.19.
                */
               lun_count++;
               if ((cdb_offset + 8) > se_cmd->data_length)
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                       continue;

would overflow the REPORT_LUNS reponse buffer by 1 LUN Listing (8 bytes)
when the cdb_offset + 8 exceeded the received data length.  This patch correctly
changes the conditional test to:

		if ((cdb_offset + 8) >= se_cmd->data_length)

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/Makefile                 |    1 -
 drivers/lio-core/target_core_base.h       |   36 ++--
 drivers/lio-core/target_core_device.c     |   99 +++++++--
 drivers/lio-core/target_core_device.h     |    1 +
 drivers/lio-core/target_core_reportluns.c |  340 -----------------------------
 drivers/lio-core/target_core_reportluns.h |   55 -----
 drivers/lio-core/target_core_transport.c  |   44 +++--
 7 files changed, 129 insertions(+), 447 deletions(-)
 delete mode 100644 drivers/lio-core/target_core_reportluns.c
 delete mode 100644 drivers/lio-core/target_core_reportluns.h

diff --git a/drivers/lio-core/Makefile b/drivers/lio-core/Makefile
index 7bab803..7e18cae 100644
--- a/drivers/lio-core/Makefile
+++ b/drivers/lio-core/Makefile
@@ -33,7 +33,6 @@ target_core_mod-objs			:=	target_core_configfs.o \
 						target_core_device.o \
 						target_core_hba.o \
 						target_core_plugin.o \
-						target_core_reportluns.o \
 						target_core_scdb.o \
 						target_core_seobj.o \
 						target_core_tpg.o \
diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 7349131..058173e 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -166,24 +166,23 @@
 #define TRANSPORT_FREE				255
 
 #define SCF_SUPPORTED_SAM_OPCODE                0x00000001
-#define SCF_REPORT_LUNS                         0x00000002
-#define SCF_TRANSPORT_TASK_SENSE                0x00000004
-#define SCF_EMULATED_TASK_SENSE                 0x00000008
-#define SCF_SCSI_DATA_SG_IO_CDB                 0x00000010
-#define SCF_SCSI_CONTROL_SG_IO_CDB              0x00000020
-#define SCF_SCSI_CONTROL_NONSG_IO_CDB           0x00000040
-#define SCF_SCSI_NON_DATA_CDB                   0x00000080
-#define SCF_SCSI_CDB_EXCEPTION                  0x00000100
-#define SCF_SCSI_RESERVATION_CONFLICT           0x00000200
-#define SCF_CMD_PASSTHROUGH                     0x00000400
-#define SCF_CMD_PASSTHROUGH_NOALLOC             0x00000800
-#define SCF_SE_CMD_FAILED                       0x00001000
-#define SCF_SE_LUN_CMD                          0x00002000
-#define SCF_SE_ALLOW_EOO                        0x00004000
-#define SCF_SE_DISABLE_ONLINE_CHECK             0x00008000
-#define SCF_SENT_CHECK_CONDITION		0x00010000
-#define SCF_OVERFLOW_BIT                        0x00020000
-#define SCF_UNDERFLOW_BIT                       0x00040000
+#define SCF_TRANSPORT_TASK_SENSE                0x00000002
+#define SCF_EMULATED_TASK_SENSE                 0x00000004
+#define SCF_SCSI_DATA_SG_IO_CDB                 0x00000008
+#define SCF_SCSI_CONTROL_SG_IO_CDB              0x00000010
+#define SCF_SCSI_CONTROL_NONSG_IO_CDB           0x00000020
+#define SCF_SCSI_NON_DATA_CDB                   0x00000040
+#define SCF_SCSI_CDB_EXCEPTION                  0x00000080
+#define SCF_SCSI_RESERVATION_CONFLICT           0x00000100
+#define SCF_CMD_PASSTHROUGH                     0x00000200
+#define SCF_CMD_PASSTHROUGH_NOALLOC             0x00000400
+#define SCF_SE_CMD_FAILED                       0x00000800
+#define SCF_SE_LUN_CMD                          0x00001000
+#define SCF_SE_ALLOW_EOO                        0x00002000
+#define SCF_SE_DISABLE_ONLINE_CHECK             0x00004000
+#define SCF_SENT_CHECK_CONDITION		0x00008000
+#define SCF_OVERFLOW_BIT                        0x00010000
+#define SCF_UNDERFLOW_BIT                       0x00020000
 
 /* se_device_t->type */
 #define PSCSI					1
@@ -414,6 +413,7 @@ typedef struct se_cmd_s {
 	int (*transport_allocate_resources)(struct se_cmd_s *, u32, u32);
 	int (*transport_cdb_transform)(struct se_cmd_s *, struct se_transform_info_s *);
 	int (*transport_do_transform)(struct se_cmd_s *, struct se_transform_info_s *);
+	int (*transport_emulate_cdb)(struct se_cmd_s *);
 	void (*transport_free_resources)(struct se_cmd_s *);
 	u32 (*transport_get_lba)(unsigned char *);
 	unsigned long long (*transport_get_long_lba)(unsigned char *);
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 9aa2f51..95dd89d 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -40,6 +40,7 @@
 #include <linux/in.h>
 #include <net/sock.h>
 #include <net/tcp.h>
+#include <scsi/scsi.h>
 
 #include <iscsi_linux_os.h>
 #include <iscsi_linux_defs.h>
@@ -55,9 +56,6 @@
 
 #include <target_core_plugin.h>
 #include <target_core_seobj.h>
-#define RL_INCLUDE_STRUCTS
-#include <target_core_reportluns.h>
-#undef RL_INCLUDE_STRUCTS
 
 #undef TARGET_CORE_DEVICE_C
 
@@ -315,12 +313,6 @@ out:
 	spin_unlock(&dev->stats_lock);
 	}
 #endif /* SNMP_SUPPORT */
-        /*
-         * REPORT_LUN never gets added to the LUN list because it never makes
-         * it to the storage engine queue.
-         */
-        if (se_cmd->se_cmd_flags & SCF_REPORT_LUNS)
-                return(1);
 
         /*
          * Add the iscsi_cmd_t to the se_lun_t's cmd list.  This list is used
@@ -498,6 +490,87 @@ extern void core_clear_lun_from_tpg (se_lun_t *lun, se_portal_group_t *tpg)
         return;
 }
 
+extern int transport_core_report_lun_response (se_cmd_t *se_cmd)
+{
+	se_dev_entry_t *deve;
+	se_lun_t *se_lun;
+	se_session_t *se_sess = SE_SESS(se_cmd);
+	se_task_t *se_task;
+	unsigned char *buf = (unsigned char *)T_TASK(se_cmd)->t_task_buf;
+	u32 cdb_offset = 0, lun_count = 0, offset = 8;
+	u64 i, lun;
+
+	list_for_each_entry(se_task, &T_TASK(se_cmd)->t_task_list, t_list)
+		break;
+	
+	if (!(se_task)) {
+		printk(KERN_ERR "Unable to locate se_task_t for se_cmd_t\n");
+		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+	}
+
+	/*
+	 * If no se_session_t pointer is present, this se_cmd_t is
+	 * coming via a target_core_mod PASSTHROUGH op, and not through
+	 * a $FABRIC_MOD.  In that case, report LUN=0 only.
+	 */
+	if (!(se_sess)) {
+		lun = 0;
+		buf[offset++] = ((lun >> 56) & 0xff);
+		buf[offset++] = ((lun >> 48) & 0xff);
+		buf[offset++] = ((lun >> 40) & 0xff);
+		buf[offset++] = ((lun >> 32) & 0xff);
+		buf[offset++] = ((lun >> 24) & 0xff);
+		buf[offset++] = ((lun >> 16) & 0xff);
+		buf[offset++] = ((lun >> 8) & 0xff);
+		buf[offset++] = (lun & 0xff);
+		lun_count = 1;
+		goto done;	
+	}
+
+	spin_lock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
+	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
+		deve = &SE_NODE_ACL(se_sess)->device_list[i];
+		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+			continue;
+		se_lun = deve->se_lun; 
+		/*
+		 * We determine the correct LUN LIST LENGTH even once we
+		 * have reached the initial allocation length.
+		 * See SPC2-R20 7.19.
+		 */
+		lun_count++;
+		if ((cdb_offset + 8) >= se_cmd->data_length)
+			continue;
+
+		lun = cpu_to_be64(CMD_TFO(se_cmd)->pack_lun(deve->mapped_lun));
+		buf[offset++] = ((lun >> 56) & 0xff);
+		buf[offset++] = ((lun >> 48) & 0xff);
+		buf[offset++] = ((lun >> 40) & 0xff);
+		buf[offset++] = ((lun >> 32) & 0xff);
+		buf[offset++] = ((lun >> 24) & 0xff);
+		buf[offset++] = ((lun >> 16) & 0xff);
+		buf[offset++] = ((lun >> 8) & 0xff);
+		buf[offset++] = (lun & 0xff);
+		cdb_offset += 8;
+	}
+	spin_unlock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
+
+	/*
+	 * See SPC3 r07, page 159.
+	 */
+done:
+	lun_count *= 8;
+	buf[0] = ((lun_count >> 24) & 0xff);
+	buf[1] = ((lun_count >> 16) & 0xff);
+	buf[2] = ((lun_count >> 8) & 0xff);
+	buf[3] = (lun_count & 0xff);
+
+	se_task->task_scsi_status = GOOD;
+	transport_complete_task(se_task, 1);
+
+	return(PYX_TRANSPORT_SENT_TO_TRANSPORT);
+}
+
 /*	se_release_device_for_hba():
  *
  *
@@ -532,14 +605,6 @@ extern int transport_get_lun_for_cmd (
 	unsigned char *cdb,
         u32 unpacked_lun)
 {
-	/*
-	 * REPORT_LUNS never actually goes to the transport layer.
-	 */
-	if (cdb[0] == REPORT_LUNS) {
-		if (se_allocate_rl_cmd(se_cmd, cdb, unpacked_lun) < 0)
-			return(PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES);
-	}
-
 	return(__transport_get_lun_for_cmd(se_cmd, unpacked_lun));
 }
 
diff --git a/drivers/lio-core/target_core_device.h b/drivers/lio-core/target_core_device.h
index 128aae8..ea3046b 100644
--- a/drivers/lio-core/target_core_device.h
+++ b/drivers/lio-core/target_core_device.h
@@ -40,6 +40,7 @@ extern void core_dec_lacl_count (struct se_node_acl_s *, struct se_cmd_s *);
 extern void core_update_device_list_access (u32, u32, se_node_acl_t *);
 extern void core_update_device_list_for_node (se_lun_t *lun, u32, u32, se_node_acl_t *, se_portal_group_t *, int);
 extern void core_clear_lun_from_tpg (se_lun_t *, se_portal_group_t *);
+extern int transport_core_report_lun_response (se_cmd_t *);
 extern void se_release_device_for_hba (se_device_t *);
 extern void se_clear_dev_ports (se_device_t *);
 extern int se_free_virtual_device (se_device_t *, se_hba_t *);
diff --git a/drivers/lio-core/target_core_reportluns.c b/drivers/lio-core/target_core_reportluns.c
deleted file mode 100644
index 57401e4..0000000
--- a/drivers/lio-core/target_core_reportluns.c
+++ /dev/null
@@ -1,340 +0,0 @@
-/*********************************************************************************
- * Filename:  target_core_reportluns.c
- *
- * Copyright (c) 2004 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc. 
- * Copyright (c) 2007 Rising Tide Software, Inc.
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
- *********************************************************************************/
-
-
-#define TARGET_CORE_REPORTLUNS_C
-
-#include <linux/net.h>
-#include <linux/string.h>
-#include <linux/timer.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/smp_lock.h>
-#include <linux/in.h>
-#include <net/sock.h>
-#include <net/tcp.h>
-
-#include <iscsi_linux_os.h>
-#include <iscsi_linux_defs.h>
-
-#include <iscsi_debug.h>
-#include <iscsi_protocol.h>
-#include <iscsi_debug_opcodes.h>
-#include <iscsi_debug.h>
-#include <iscsi_target_core.h>
-#include <target_core_base.h>
-#include <iscsi_target_device.h>
-#include <target_core_transport.h>
-#include <iscsi_target_util.h>
-#include <target_core_reportluns.h>
-
-#include <target_core_fabric_ops.h>
-
-#undef TARGET_CORE_REPORTLUNS_C
-
-static se_subsystem_api_t *rl_template = &_rl_template;
-
-/*	rl_set_iovec_ptrs():
- *
- *	Assumes non-scatterlist buffers.
- */
-static int rl_set_iovec_ptrs (
-	se_map_sg_t *map_sg,
-	se_unmap_sg_t *unmap_sg)
-{
-	se_cmd_t *se_cmd = map_sg->se_cmd;
-	se_task_t *task = NULL;
-	rl_cmd_t *rl_cmd = NULL;
-	struct iovec *iov = map_sg->iov;
-
-	list_for_each_entry(task, &T_TASK(se_cmd)->t_task_list, t_list) {
-		rl_cmd = (rl_cmd_t *) task->transport_req;
-	}
-	
-	iov[0].iov_base = (unsigned char *) rl_cmd->rl_buf + map_sg->data_offset;
-	iov[0].iov_len = map_sg->data_length;
-
-	return(1);
-}
-
-/*	rl_wait_for_tasks():
- *
- *
- */
-static void rl_wait_for_tasks (se_cmd_t *cmd, int remove_cmd, int session_reinstatement)
-{
-	return;
-}
-
-static void rl_nop_SG_segments (se_unmap_sg_t *unmap_sg)
-{
-	return;
-}
-
-/*	rl_allocate_cmd():
- *
- *
- */
-static rl_cmd_t *rl_allocate_cmd (se_cmd_t *cmd, u32 size)
-{
-	rl_cmd_t *rl_cmd;
-
-	if (!(rl_cmd = (rl_cmd_t *) kzalloc(sizeof(rl_cmd_t), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate rl_cmd_t for REPORT_LUNS\n");
-		return(NULL);
-	}
-	
-	if (!(rl_cmd->rl_buf = (unsigned char *) kzalloc(cmd->data_length, GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate buffer for REPORT_LUNS\n");
-		return(NULL);
-	}
-	
-	rl_cmd->rl_size	= cmd->data_length;
-	/*
-	 * Setup any additional transport related function pointers now.
-	 */
-	cmd->transport_set_iovec_ptrs = &rl_set_iovec_ptrs;
-	cmd->transport_wait_for_tasks = &rl_wait_for_tasks;
-	cmd->transport_map_SG_segments = &rl_nop_SG_segments;
-	cmd->transport_unmap_SG_segments = &rl_nop_SG_segments;
-	
-	return(rl_cmd);
-}
-
-/*	rl_allocate_fake_lun():
- *
- *
- */
-static int rl_allocate_fake_lun (se_cmd_t *cmd, u32 lun)
-{
-	se_lun_t *lun_p;
-	
-	if (!(cmd->se_lun = (se_lun_t *)
-			kzalloc(sizeof(se_lun_t), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate se_lun_t\n");
-		return(-1);
-	}
-	ISCSI_LUN(cmd)->unpacked_lun = lun;
-	lun_p = ISCSI_LUN(cmd);
-	
-	if (!(lun_p->se_dev = (se_device_t *)
-			kzalloc(sizeof(se_device_t), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate se_device_t\n");
-		kfree(ISCSI_LUN(cmd));
-		return(-1);
-	}
-	ISCSI_DEV(cmd)->transport = rl_template;
-
-	return(0);
-}
-
-/*	se_allocate_rl_cmd():
- *
- *
- */
-extern int se_allocate_rl_cmd (
-	se_cmd_t *cmd,
-	unsigned char *cdb,
-	u32 unpacked_lun)
-{
-	rl_cmd_t *rl_cmd = NULL;
-	se_task_t *task = NULL;
-	unsigned long flags;
-	
-	cmd->se_cmd_flags |= SCF_REPORT_LUNS;
-	cmd->data_length = (cdb[6] << 24) + (cdb[7] << 16) +
-			   (cdb[8] << 8) + cdb[9];
-
-	if (rl_allocate_fake_lun(cmd, unpacked_lun) < 0)
-		goto failure;
-	
-	if (!(rl_cmd = rl_allocate_cmd(cmd, cmd->data_length)))
-		goto failure;
-
-	rl_cmd->rl_se_cmd = cmd;
-
-	if (!(cmd->t_task = (se_transport_task_t *) kzalloc(
-			sizeof(se_transport_task_t), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate se_transport_task_t\n");
-		goto failure;
-	}
-	
-	init_MUTEX_LOCKED(&T_TASK(cmd)->t_transport_stop_sem);
-	spin_lock_init(&T_TASK(cmd)->t_state_lock);
-	INIT_LIST_HEAD(&T_TASK(cmd)->t_task_list);
-
-	memcpy(T_TASK(cmd)->t_task_cdb, cdb, SCSI_CDB_SIZE);
-	
-        if (!(task = kzalloc(sizeof(se_task_t), GFP_KERNEL))) {
-                TRACE_ERROR("Unable to allocate se_task_t\n");
-		goto failure;
-	}
-
-	INIT_LIST_HEAD(&task->t_list);
-	init_MUTEX_LOCKED(&task->task_stop_sem);
-	task->task_no = 0;
-	task->task_se_cmd = cmd;
-	task->se_dev = ISCSI_DEV(cmd);
-	task->transport_req = (void *) rl_cmd;
-
-        spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-        list_add(&task->t_list, &T_TASK(cmd)->t_task_list);
-        spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
-	
-	if (transport_allocate_iovecs_for_cmd(cmd, TRANSPORT_IOV_DATA_BUFFER + 1) < 0)
-		goto failure;
-
-	transport_set_supported_SAM_opcode(cmd);
-
-	return(0);
-failure:
-	if (ISCSI_LUN(cmd)) {
-		if (ISCSI_DEV(cmd)) {
-			kfree(ISCSI_DEV(cmd));
-			cmd->se_lun->se_dev = NULL;
-		}
-		kfree(ISCSI_LUN(cmd));
-		cmd->se_lun = NULL;
-	}
-	if (T_TASK(cmd)) {
-		kfree(cmd->t_task);
-		cmd->t_task = NULL;
-	}
-	kfree(task);
-
-	if (rl_cmd) {
-		if (rl_cmd->rl_buf) {
-			kfree(rl_cmd->rl_buf);
-			rl_cmd->rl_buf = NULL;
-		}
-		kfree(rl_cmd);
-	}
-	return(-1);
-}
-
-/*	iscsi_build_report_luns_response():
- *
- *
- */
-extern int iscsi_build_report_luns_response (
-	se_cmd_t *se_cmd)
-{
-	unsigned char *buf = NULL;
-	u32 cdb_offset = 0, lun_count = 0, offset = 8;
-	u64 i, lun;
-	se_dev_entry_t *deve;
-	se_lun_t *se_lun;
-	se_session_t *sess = SE_SESS(se_cmd);
-	se_task_t *task;
-	rl_cmd_t *rl_cmd;
-	
-	list_for_each_entry(task, &T_TASK(se_cmd)->t_task_list, t_list) {
-		rl_cmd = (rl_cmd_t *) task->transport_req;
-		buf = rl_cmd->rl_buf;
-	}
-	
-	spin_lock_bh(&SE_NODE_ACL(sess)->device_list_lock);
-	for (i = 0; i < ISCSI_MAX_LUNS_PER_TPG; i++) {
-		deve = &SE_NODE_ACL(sess)->device_list[i];
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
-			continue;
-		se_lun = deve->se_lun;
-
-		/*
-		 * We determine the correct LUN LIST LENGTH even once we
-		 * have reached the initial allocation length.
-		 * See SPC2-R20 7.19.
-		 */
-		lun_count++;
-		if ((cdb_offset + 8) > se_cmd->data_length)
-			continue;
-
-		lun = cpu_to_be64(CMD_TFO(se_cmd)->pack_lun(deve->mapped_lun));
-		buf[offset++] = ((lun >> 56) & 0xff);
-		buf[offset++] = ((lun >> 48) & 0xff);
-		buf[offset++] = ((lun >> 40) & 0xff);
-		buf[offset++] = ((lun >> 32) & 0xff);
-		buf[offset++] = ((lun >> 24) & 0xff);
-		buf[offset++] = ((lun >> 16) & 0xff);
-		buf[offset++] = ((lun >> 8) & 0xff);
-		buf[offset++] = (lun & 0xff);
-		cdb_offset += 8;
-	}
-	spin_unlock_bh(&SE_NODE_ACL(sess)->device_list_lock);
-
-	/*
-	 * See SPC3 r07, page 159.
-	 */
-	lun_count *= 8;
-	buf[0] = ((lun_count >> 24) & 0xff);
-	buf[1] = ((lun_count >> 16) & 0xff);
-	buf[2] = ((lun_count >> 8) & 0xff);
-	buf[3] = (lun_count & 0xff);
-	
-	CMD_TFO(se_cmd)->queue_data_in(se_cmd);
-
-	return(0);
-}
-
-/*	rl_check_for_SG():
- *
- *
- */
-extern int rl_check_for_SG (se_task_t *task)
-{
-	return(0);
-}
-
-/*	rl_free_task():
- *
- *
- */
-extern void rl_free_task (se_task_t *task)
-{
-	rl_cmd_t *rl_cmd = (rl_cmd_t *) task->transport_req;
-	se_cmd_t *se_cmd = rl_cmd->rl_se_cmd;
-	
-	/*
-	 * Free the pseudo device.
-	 */
-	if (task->se_dev) {
-		kfree(task->se_dev);
-		task->se_dev = NULL;
-	}
-
-	if (se_cmd->se_lun) {
-		kfree(se_cmd->se_lun);
-		se_cmd->se_lun = NULL;
-	}
-	
-	if (rl_cmd->rl_buf) {
-		kfree(rl_cmd->rl_buf);
-		rl_cmd->rl_buf = NULL;
-	}
-
-	kfree(rl_cmd);
-	
-	return;
-}
diff --git a/drivers/lio-core/target_core_reportluns.h b/drivers/lio-core/target_core_reportluns.h
deleted file mode 100644
index 3296675..0000000
--- a/drivers/lio-core/target_core_reportluns.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/*********************************************************************************
- * Filename:  target_core_reportluns.h 
- *
- * This file contains the iSCSI Target REPORT_LUNS definitions.
- *
- * Copyright (c) 2004 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc. 
- * Copyright (c) 2007 Rising Tide Software, Inc.
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
- *********************************************************************************/
-
-
-#ifndef TARGET_CORE_REPORTLUNS_H
-#define TARGET_CORE_REPORTLUNS_H
-
-typedef struct rl_cmd_s {
-	struct se_cmd_s *rl_se_cmd;
-	unsigned char *rl_buf;
-	u32 rl_size;
-} rl_cmd_t;
-
-extern int se_allocate_rl_cmd (se_cmd_t *, unsigned char *, u32);
-extern int se_build_report_luns_response (se_cmd_t *);
-
-#ifndef RL_INCLUDE_STRUCTS
-extern int rl_check_for_SG (se_task_t *);
-extern void rl_free_task (se_task_t *);
-
-#define TARGET_CORE_RL { 				\
-	name:			"RL",			\
-	check_for_SG:		rl_check_for_SG,	\
-	free_task:		rl_free_task,		\
-};
-
-se_subsystem_api_t _rl_template = TARGET_CORE_RL;
-#endif /* RL_INCLUDE_STRUCTS */
-
-#endif   /*** TARGET_CORE_REPORTLUNS_H ***/
-
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 83727d2..f02bf56 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -904,13 +904,6 @@ static void transport_lun_remove_cmd (se_cmd_t *cmd)
 	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
 		return;
 
-	/*
-	 * REPORT_LUNS will be coming from the FE, and should not
-	 * be tracked.
-	 */
-	if (cmd->se_cmd_flags & SCF_REPORT_LUNS)
-		return;
-	
 	spin_lock_irqsave(&lun->lun_cmd_lock, flags);
 	if (atomic_read(&T_TASK(cmd)->transport_lun_active)) {
 		REMOVE_ENTRY_FROM_LIST_PREFIX(l, cmd,
@@ -3560,13 +3553,27 @@ check_depth:
 
 	transport_start_task_timer(task);
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
-
-	if ((error = TRANSPORT(dev)->do_task(task)) != 0) {
-		cmd->transport_error_status = error;
-		atomic_set(&task->task_active, 0);
-		atomic_set(&cmd->transport_sent, 0);
-		transport_stop_tasks_for_cmd(cmd);
-		transport_generic_request_failure(cmd, dev, 0, 1);
+	/*
+	 * The se_cmd_t->transport_emulate_cdb() function pointer is used
+	 * to grab REPORT_LUNS CDBs before they hit the
+	 * se_subsystem_api_t->do_task() caller below.
+	 */
+	if (cmd->transport_emulate_cdb) {
+		if ((error = cmd->transport_emulate_cdb(cmd)) != 0) {
+			cmd->transport_error_status = error;
+			atomic_set(&task->task_active, 0);
+			atomic_set(&cmd->transport_sent, 0);
+			transport_stop_tasks_for_cmd(cmd);
+			transport_generic_request_failure(cmd, dev, 0, 1);
+		}
+	} else {
+		if ((error = TRANSPORT(dev)->do_task(task)) != 0) {
+			cmd->transport_error_status = error;
+			atomic_set(&task->task_active, 0);
+			atomic_set(&cmd->transport_sent, 0);
+			transport_stop_tasks_for_cmd(cmd);
+			transport_generic_request_failure(cmd, dev, 0, 1);
+		}
 	}
 
 	goto check_depth;
@@ -4363,8 +4370,13 @@ static int transport_generic_cmd_sequencer (
 		ret = 3;
 		break;
 	case REPORT_LUNS:
-		TRACE_ERROR("Huh? REPORT_LUNS in sequencer.\n");
-		BUG();
+		SET_GENERIC_PYX_TRANSPORT_FUNCTIONS(cmd);
+		cmd->transport_emulate_cdb = &transport_core_report_lun_response;
+		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
+		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_get_maps(cmd);
+		ret = 2;
+		break;
 	default:
 		TRACE_ERROR("Unsupported SCSI Opcode 0x%02x, sending"
 			" CHECK_CONDITION.\n", cdb[0]);
-- 
1.5.4.1



