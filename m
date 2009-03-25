From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] [Target_Core_Mod]: Add support for UNIT_ATTENTION
	conditions
Date: Tue, 24 Mar 2009 23:06:20 -0700
Message-ID: <1237961180.4138.418.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:44494 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753134AbZCYGG1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 02:06:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>From 2fed7603d2b4b8f0fb7a6bd1f3087eb6cbe0d21a Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 24 Mar 2009 22:14:27 -0700
Subject: [PATCH 1/2] [Target_Core_Mod]: Add support for UNIT_ATTENTION conditions

This patch adds support for UNIT_ATTENTION and ua_intlck_ctrl emulation
following spc4r17, section 7.4.6 Control Mode Page, Table 349.

Upon reception of a REQUEST_SENSE, this patch will report and release a
UNIT_ATTENTION condition for a given I_T Nexus. It adds a se_ua_t structure
defs, and new UA related structure members to se_dev_entry_t in
se_node_acl->device_list[] coming from se_lun_acl_t mapped se_lun_t objects.
Upon release of mapped target_core_mod LUN ACL, this patch will release all
associated UNIT ATTENTION conditions.

By default, this patch uses ua_intlck_ctrl code 00b, and clears UNIT
ATTENTION conditions by sending CHECK_CONDITION with a SENSE KEY of
UNIT ATTENTION + the associated highest priority ASC+ASCQ when a UNIT
ATTENTION condition has been established.  Note that this is the current
behaviour of Linux/SCSI and linux/drivers/scsi midlayer code for ua_intlck_ctrl.

This patch also supports the optional 2nd and 3rd modes of ua_intlck_ctrl
(code 10b and 11b), with the latter using:
 target_core_ua.h:ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS.
Both of these modes have been tested with this code and require manual
intervention with sg_requests and REQUEST_SENSE for Linux/SCSI Initiator ports
to explictly release a target_core_mod established UNIT ATTENTION condition.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/Makefile                |    1 +
 drivers/lio-core/target_core_base.h      |   13 ++
 drivers/lio-core/target_core_configfs.c  |    4 +
 drivers/lio-core/target_core_device.c    |   27 +++-
 drivers/lio-core/target_core_device.h    |    1 +
 drivers/lio-core/target_core_tpg.c       |   10 +
 drivers/lio-core/target_core_transport.c |  127 ++++++++++--
 drivers/lio-core/target_core_transport.h |    2 +
 drivers/lio-core/target_core_ua.c        |  333 ++++++++++++++++++++++++++++++
 drivers/lio-core/target_core_ua.h        |   36 ++++
 10 files changed, 534 insertions(+), 20 deletions(-)
 create mode 100644 drivers/lio-core/target_core_ua.c
 create mode 100644 drivers/lio-core/target_core_ua.h

diff --git a/drivers/lio-core/Makefile b/drivers/lio-core/Makefile
index a171db3..66eba19 100644
--- a/drivers/lio-core/Makefile
+++ b/drivers/lio-core/Makefile
@@ -40,6 +40,7 @@ target_core_mod-objs			:=	target_core_configfs.o \
 						target_core_tmr.o \
 						target_core_tpg.o \
 						target_core_transport.o \
+						target_core_ua.o \
 						div64.o
 
 ifeq ($(LINUX_IBLOCK), 1)
diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index cab978f..cb56d6a 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -197,6 +197,7 @@
 #define UNKNOWN_MODE_PAGE			0xb
 #define WRITE_PROTECTED				0xc
 #define CHECK_CONDITION_ABORT_CMD		0xd
+#define CHECK_CONDITION_UNIT_ATTENTION		0xe
 
 typedef struct se_obj_s {
 	atomic_t obj_access_count;
@@ -539,6 +540,14 @@ typedef struct se_tmr_req_s {
 	struct list_head	tmr_list;
 } ____cacheline_aligned se_tmr_req_t;
 
+typedef struct se_ua_s {
+	u8			ua_asc;
+	u8			ua_ascq;
+	struct se_node_acl_s	*ua_nacl;
+	struct list_head	ua_dev_list;
+	struct list_head	ua_nacl_list;
+} ____cacheline_aligned se_ua_t;
+
 typedef struct se_node_acl_s {
 	char			initiatorname[TRANSPORT_IQN_LEN];
 	int			nodeacl_flags;
@@ -600,12 +609,16 @@ typedef struct se_dev_entry_s {
 	u64			read_bytes;
 	u64			write_bytes;
 #endif /* SNMP_SUPPORT */
+	atomic_t		ua_count;
+	spinlock_t		ua_lock;
 	struct se_lun_s		*se_lun;
+	struct list_head	ua_list;
 }  ____cacheline_aligned se_dev_entry_t;
 
 typedef struct se_dev_attrib_s {
 	int		status_thread;
 	int		status_thread_tur;
+	int		emulate_ua_intlck_ctrl;
 	int		emulate_tas;
 	int		emulate_reservations;
 	int		emulate_alua;
diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 5473d4c..975ecb8 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -478,6 +478,9 @@ SE_DEV_ATTR(status_thread, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(status_thread_tur);
 SE_DEV_ATTR(status_thread_tur, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(emulate_ua_intlck_ctrl);
+SE_DEV_ATTR(emulate_ua_intlck_ctrl, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB(emulate_tas);
 SE_DEV_ATTR(emulate_tas, S_IRUGO | S_IWUSR);
 
@@ -507,6 +510,7 @@ CONFIGFS_EATTR_OPS(target_core_dev_attrib, se_dev_attrib_s, da_group);
 static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_status_thread.attr,
 	&target_core_dev_attrib_status_thread_tur.attr,
+	&target_core_dev_attrib_emulate_ua_intlck_ctrl.attr,
 	&target_core_dev_attrib_emulate_tas.attr,
 	&target_core_dev_attrib_hw_block_size.attr,
 	&target_core_dev_attrib_block_size.attr,
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index a1c5c95..95ab18d 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -49,6 +49,7 @@
 #include <target_core_pr.h>
 #include <target_core_tpg.h>
 #include <target_core_transport.h>
+#include <target_core_ua.h>
 #include <target_core_fabric_ops.h>
 #include <target_core_plugin.h>
 #include <target_core_seobj.h>
@@ -483,12 +484,12 @@ void core_update_device_list_for_node(
 		deve->attach_count++;
 #endif /* SNMP_SUPPORT */
 		spin_unlock_bh(&nacl->device_list_lock);
-
 		return;
 	}
 	/*
 	 * Disable se_dev_entry_t LUN ACL mapping
 	 */
+	core_scsi3_ua_release_all(deve);
 	deve->se_lun = NULL;
 	deve->lun_flags = 0;
 	deve->creation_time = 0;
@@ -869,6 +870,7 @@ void se_dev_set_default_attribs(se_device_t *dev)
 {
 	DEV_ATTRIB(dev)->status_thread = DA_STATUS_THREAD;
 	DEV_ATTRIB(dev)->status_thread_tur = DA_STATUS_THREAD_TUR;
+	DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl = DA_EMULATE_UA_INTLLCK_CTRL;
 	DEV_ATTRIB(dev)->emulate_tas = DA_EMULATE_TAS;
 	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
 	DEV_ATTRIB(dev)->emulate_alua = DA_EMULATE_ALUA;
@@ -970,11 +972,32 @@ int se_dev_set_status_thread_tur(se_device_t *dev, int flag)
 	return 0;
 }
 
+int se_dev_set_emulate_ua_intlck_ctrl(se_device_t *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1) && (flag != 2)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -1;
+	}
+
+	if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
+		printk(KERN_ERR "dev[%p]: Unable to change SE Device"
+			" UA_INTRLCK_CTRL while dev_export_obj: %d count"
+			" exists\n", dev,
+			DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj));
+		return -1;
+	}
+	DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl = flag;
+	printk(KERN_INFO "dev[%p]: SE Device UA_INTRLCK_CTRL flag: %d\n",
+		dev, DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl);
+
+	return 0;
+}
+
 int se_dev_set_emulate_tas(se_device_t *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
-		return 1;
+		return -1;
 	}
 
 	if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
diff --git a/drivers/lio-core/target_core_device.h b/drivers/lio-core/target_core_device.h
index 3b46ef1..2877d01 100644
--- a/drivers/lio-core/target_core_device.h
+++ b/drivers/lio-core/target_core_device.h
@@ -62,6 +62,7 @@ extern void se_dev_set_default_attribs(se_device_t *);
 extern int se_dev_set_task_timeout(se_device_t *, u32);
 extern int se_dev_set_status_thread(se_device_t *, int);
 extern int se_dev_set_status_thread_tur(se_device_t *, int);
+extern int se_dev_set_emulate_ua_intlck_ctrl(se_device_t *, int);
 extern int se_dev_set_emulate_tas(se_device_t *, int);
 extern int se_dev_set_queue_depth(se_device_t *, u32);
 extern int se_dev_set_max_sectors(se_device_t *, u32);
diff --git a/drivers/lio-core/target_core_tpg.c b/drivers/lio-core/target_core_tpg.c
index 406cbae..e406022 100644
--- a/drivers/lio-core/target_core_tpg.c
+++ b/drivers/lio-core/target_core_tpg.c
@@ -235,6 +235,9 @@ static int core_set_queue_depth_for_node(
  */
 static int core_create_device_list_for_node(se_node_acl_t *nacl)
 {
+	se_dev_entry_t *deve;
+	int i;
+
 	nacl->device_list = kzalloc(sizeof(se_dev_entry_t) *
 				TRANSPORT_MAX_LUNS_PER_TPG, GFP_KERNEL);
 	if (!(nacl->device_list)) {
@@ -242,6 +245,13 @@ static int core_create_device_list_for_node(se_node_acl_t *nacl)
 			" se_node_acl_t->device_list\n");
 		return -1;
 	}
+	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
+		deve = &nacl->device_list[i];
+
+		atomic_set(&deve->ua_count, 0);
+		spin_lock_init(&deve->ua_lock);
+		INIT_LIST_HEAD(&deve->ua_list);
+	}
 
 	return 0;
 }
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 6fa358d..07c49f9 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -53,6 +53,7 @@
 #include <target_core_pr.h>
 #include <target_core_alua.h>
 #include <target_core_tmr.h>
+#include <target_core_ua.h>
 #include <target_core_transport.h>
 #include <target_core_plugin.h>
 #include <target_core_seobj.h>
@@ -189,6 +190,7 @@ struct kmem_cache *se_cmd_cache;
 struct kmem_cache *se_task_cache;
 struct kmem_cache *se_tmr_req_cache;
 struct kmem_cache *se_sess_cache;
+struct kmem_cache *se_ua_cache;
 struct kmem_cache *t10_pr_reg_cache;
 struct kmem_cache *t10_alua_lu_gp_cache;
 struct kmem_cache *t10_alua_lu_gp_mem_cache;
@@ -288,6 +290,12 @@ int init_se_global(void)
 				" failed\n");
 		goto out;
 	}
+	se_ua_cache = kmem_cache_create("se_ua_cache",
+			sizeof(se_ua_t), __alignof__(se_ua_t), 0, NULL);
+	if (!(se_ua_cache)) {
+		printk(KERN_ERR "kmem_cache_create() for se_ua_t failed\n");
+		goto out;
+	}
 	t10_pr_reg_cache = kmem_cache_create("t10_pr_reg_cache",
 			sizeof(t10_pr_registration_t),
 			__alignof__(t10_pr_registration_t), 0, NULL);
@@ -374,6 +382,8 @@ out:
 		kmem_cache_destroy(se_tmr_req_cache);
 	if (se_sess_cache)
 		kmem_cache_destroy(se_sess_cache);
+	if (se_ua_cache)
+		kmem_cache_destroy(se_ua_cache);
 	if (t10_pr_reg_cache)
 		kmem_cache_destroy(t10_pr_reg_cache);
 	if (t10_alua_lu_gp_cache)
@@ -402,6 +412,7 @@ void release_se_global(void)
 	kmem_cache_destroy(se_task_cache);
 	kmem_cache_destroy(se_tmr_req_cache);
 	kmem_cache_destroy(se_sess_cache);
+	kmem_cache_destroy(se_ua_cache);
 	kmem_cache_destroy(t10_pr_reg_cache);
 	kmem_cache_destroy(t10_alua_lu_gp_cache);
 	kmem_cache_destroy(t10_alua_lu_gp_mem_cache);
@@ -2778,6 +2789,18 @@ int transport_generic_allocate_tasks(
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->se_cmd_flags |= SCF_SCSI_RESERVATION_CONFLICT;
 		cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
+		/*
+		 * For UA Interlock Code 11b, a RESERVATION CONFLICT will
+		 * establish a UNIT ATTENTION with PREVIOUS RESERVATION
+		 * CONFLICT STATUS.
+		 *
+		 * See spc4r17, section 7.4.6 Control Mode Page, Table 349
+		 */
+		if (SE_SESS(cmd) &&
+		    DEV_ATTRIB(cmd->se_dev)->emulate_ua_intlck_ctrl == 2)
+			core_scsi3_ua_allocate(SE_SESS(cmd)->se_node_acl,
+				cmd->orig_fe_lun, 0x2C,
+				ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
 		return -2;
 	case 6:
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
@@ -2787,6 +2810,10 @@ int transport_generic_allocate_tasks(
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason = ILLEGAL_REQUEST;
 		return -2;
+	case 8:
+		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+		cmd->scsi_sense_reason = CHECK_CONDITION_UNIT_ATTENTION;
+		return -2;
 	default:
 		break;
 	}
@@ -4511,8 +4538,27 @@ static int transport_modesense_control(se_device_t *dev, unsigned char *p)
 	 * status and shall not establish a unit attention condition when a com-
 	 * mand is completed with BUSY, TASK SET FULL, or RESERVATION CONFLICT
 	 * status.
+	 *
+	 * 10b: The logical unit shall not clear any unit attention condition
+	 * reported in the same I_T_L_Q nexus transaction as a CHECK CONDITION
+	 * status and shall not establish a unit attention condition when
+	 * a command is completed with BUSY, TASK SET FULL, or RESERVATION
+	 * CONFLICT status.
+	 *
+	 * 11b a The logical unit shall not clear any unit attention condition
+	 * reported in the same I_T_L_Q nexus transaction as a CHECK CONDITION
+	 * status and shall establish a unit attention condition for the
+	 * initiator port associated with the I_T nexus on which the BUSY,
+	 * TASK SET FULL, or RESERVATION CONFLICT status is being returned.
+	 * Depending on the status, the additional sense code shall be set to
+	 * PREVIOUS BUSY STATUS, PREVIOUS TASK SET FULL STATUS, or PREVIOUS
+	 * RESERVATION CONFLICT STATUS. Until it is cleared by a REQUEST SENSE
+	 * command, a unit attention condition shall be established only once
+	 * for a BUSY, TASK SET FULL, or RESERVATION CONFLICT status regardless
+	 * to the number of commands completed with one of those status codes.
 	 */
-	p[4] = 0x00;
+	p[4] = (DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl == 2) ? 0x30 :
+	       (DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl == 1) ? 0x20 : 0x00;
 	/*
 	 * From spc4r17, section 7.4.6 Control mode Page
 	 *
@@ -4651,29 +4697,53 @@ int transport_generic_emulate_request_sense(
 	unsigned char *cdb)
 {
 	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
+	u8 ua_asc = 0, ua_ascq = 0;
 
 	if (cdb[1] & 0x01) {
 		printk(KERN_ERR "REQUEST_SENSE description emulation not"
 			" supported\n");
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
-	/*
-	 * CURRENT ERROR
-	 */
-	buf[0] = 0x70;
-	buf[SPC_SENSE_KEY_OFFSET] = NO_SENSE;
-	/*
-	 * Make sure request data length is enough for additional sense data.
-	 */
-	if (cmd->data_length <= 18) {
-		buf[7] = 0x00;
-		return 0;
+	if (!(core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq))) {
+		/*
+		 * CURRENT ERROR, UNIT ATTENTION
+		 */
+		buf[0] = 0x70;
+		buf[SPC_SENSE_KEY_OFFSET] = UNIT_ATTENTION;
+		/*
+		 * Make sure request data length is enough for additional
+		 * sense data.
+		 */
+		if (cmd->data_length <= 18) {
+			buf[7] = 0x00;
+			return 0;
+		}
+		/*
+		 * The Additional Sense Code (ASC) from the UNIT ATTENTION
+		 */
+		buf[SPC_ASC_KEY_OFFSET] = ua_asc;
+		buf[SPC_ASCQ_KEY_OFFSET] = ua_ascq;
+		buf[7] = 0x0A;
+	} else {
+		/*
+		 * CURRENT ERROR, NO SENSE
+		 */
+		buf[0] = 0x70;
+		buf[SPC_SENSE_KEY_OFFSET] = NO_SENSE;
+		/*
+		 * Make sure request data length is enough for additional
+		 * sense data.
+		 */
+		if (cmd->data_length <= 18) {
+			buf[7] = 0x00;
+			return 0;
+		}
+		/*
+		 * NO ADDITIONAL SENSE INFORMATION
+		 */
+		buf[SPC_ASC_KEY_OFFSET] = 0x00;
+		buf[7] = 0x0A;
 	}
-	/*
-	 * NO ADDITIONAL SENSE INFORMATION
-	 */
-	buf[SPC_ASC_KEY_OFFSET] = 0x00;
-	buf[7] = 0x0A;
 
 	return 0;
 }
@@ -4777,7 +4847,18 @@ static int transport_generic_cmd_sequencer(
 	se_subsystem_dev_t *su_dev = dev->se_sub_dev;
 	int ret = 0, sector_ret = 0;
 	u32 sectors = 0, size = 0, pr_reg_type = 0;
-
+	/*
+	 * Check for an existing UNIT ATTENTION condition
+	 */
+	if (core_scsi3_ua_check(cmd, cdb) < 0) {
+		cmd->transport_wait_for_tasks =
+				&transport_nop_wait_for_tasks;
+		transport_get_maps(cmd);
+		return 8; /* UNIT ATTENTION */
+	}
+	/*
+	 * Check status for SPC-3 Persistent Reservations
+	 */
 	if (T10_RES(su_dev)->t10_reservation_check(cmd, &pr_reg_type) != 0) {
 		if (T10_RES(su_dev)->t10_seq_non_holder(
 					cmd, cdb, pr_reg_type) != 0) {
@@ -7104,6 +7185,7 @@ int transport_send_check_condition_and_sense(
 	unsigned char *buffer = cmd->sense_buffer;
 	unsigned long flags;
 	int offset;
+	u8 asc = 0, ascq = 0;
 
 	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
@@ -7222,6 +7304,15 @@ int transport_send_check_condition_and_sense(
 		/* WRITE PROTECTED */
 		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x27;
 		break;
+	case CHECK_CONDITION_UNIT_ATTENTION:
+		/* CURRENT ERROR */
+		buffer[offset] = 0x70;
+		/* UNIT ATTENTION */
+		buffer[offset+SPC_SENSE_KEY_OFFSET] = UNIT_ATTENTION;
+		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
+		buffer[offset+SPC_ASC_KEY_OFFSET] = asc;
+		buffer[offset+SPC_ASCQ_KEY_OFFSET] = ascq;
+		break;
 	case LOGICAL_UNIT_COMMUNICATION_FAILURE:
 	default:
 		/* CURRENT ERROR */
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index f3637ec..d207462 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -102,6 +102,8 @@
 #define DA_STATUS_THREAD			0
 /* Disabled by default */
 #define DA_STATUS_THREAD_TUR			0
+/* Emulation for UNIT ATTENTION Interlock Control */
+#define DA_EMULATE_UA_INTLLCK_CTRL		0
 /* Emulation for TASK_ABORTED status (TAS) by default */
 #define DA_EMULATE_TAS				1
 /* No Emulation for PSCSI by default */
diff --git a/drivers/lio-core/target_core_ua.c b/drivers/lio-core/target_core_ua.c
new file mode 100644
index 0000000..2e88b07
--- /dev/null
+++ b/drivers/lio-core/target_core_ua.c
@@ -0,0 +1,333 @@
+/*******************************************************************************
+ * Filename: target_core_ua.c
+ *
+ * This file contains logic for SPC-3 Unit Attention emulation
+ *
+ * Copyright (c) 2009 Rising Tide, Inc.
+ * Copyright (c) 2009 Linux-iSCSI.org
+ *
+ * Nicholas A. Bellinger <nab@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ ******************************************************************************/
+
+#define TARGET_CORE_UA_C
+
+#include <linux/version.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+
+#include <target_core_base.h>
+#include <target_core_device.h>
+#include <target_core_hba.h>
+#include <target_core_transport.h>
+#include <target_core_alua.h>
+#include <target_core_pr.h>
+#include <target_core_ua.h>
+#include <target_core_transport_plugin.h>
+#include <target_core_fabric_ops.h>
+#include <target_core_configfs.h>
+
+#undef TARGET_CORE_UA_C
+
+int core_scsi3_ua_check(
+	se_cmd_t *cmd,
+	unsigned char *cdb)
+{
+	se_dev_entry_t *deve;
+	se_session_t *sess = cmd->se_sess;
+	se_node_acl_t *nacl;
+
+	if (!(sess))
+		return 0;
+
+	nacl = sess->se_node_acl;
+	if (!(nacl))
+		return 0;
+
+	deve = &nacl->device_list[cmd->orig_fe_lun];
+	if (!(atomic_read(&deve->ua_count)))
+		return 0;
+	/*
+	 * From sam4r14, section 5.14 Unit attention condition:
+	 *
+	 * a) if an INQUIRY command enters the enabled command state, the
+	 *    device server shall process the INQUIRY command and shall neither
+	 *    report nor clear any unit attention condition;
+	 * b) if a REPORT LUNS command enters the enabled command state, the
+	 *    device server shall process the REPORT LUNS command and shall not
+	 *    report any unit attention condition;
+	 * e) if a REQUEST SENSE command enters the enabled command state while
+	 *    a unit attention condition exists for the SCSI initiator port
+	 *    associated with the I_T nexus on which the REQUEST SENSE command
+	 *    was received, then the device server shall process the command
+	 *    and either:
+	 */
+	switch (cdb[0]) {
+	case INQUIRY:
+	case REPORT_LUNS:
+	case REQUEST_SENSE:
+		return 0;
+	default:
+		return -1;
+	}
+
+	return -1;
+}
+
+int core_scsi3_ua_allocate(
+	se_node_acl_t *nacl,
+	u32 unpacked_lun,
+	u8 asc,
+	u8 ascq)
+{
+	se_dev_entry_t *deve;
+	se_ua_t *ua, *ua_p, *ua_tmp;
+	/*
+	 * PASSTHROUGH OPS
+	 */
+	if (!(nacl))
+		return -1;
+
+	ua = kmem_cache_zalloc(se_ua_cache, GFP_KERNEL);
+	if (!(ua)) {
+		printk(KERN_ERR "Unable to allocate se_ua_t\n");
+		return -1;
+	}
+	INIT_LIST_HEAD(&ua->ua_dev_list);
+	INIT_LIST_HEAD(&ua->ua_nacl_list);
+
+	ua->ua_nacl = nacl;
+	ua->ua_asc = asc;
+	ua->ua_ascq = ascq;
+
+	spin_lock(&nacl->device_list_lock);
+	deve = &nacl->device_list[unpacked_lun];
+
+	spin_lock(&deve->ua_lock);
+	list_for_each_entry_safe(ua_p, ua_tmp, &deve->ua_list, ua_nacl_list) {
+		/*
+		 * Do not report the same UNIT ATTENTION twice..
+		 */
+		if ((ua_p->ua_asc == asc) && (ua_p->ua_ascq == ascq)) {
+			spin_unlock(&deve->ua_lock);
+			kmem_cache_free(se_ua_cache, ua);
+			return 0;
+		}
+		/*
+		 * Attach the highest priority Unit Attention to
+		 * the head of the list following sam4r14,
+		 * Section 5.14 Unit Attention Condition:
+		 *
+		 * POWER ON, RESET, OR BUS DEVICE RESET OCCURRED highest
+		 * POWER ON OCCURRED or
+		 * DEVICE INTERNAL RESET
+		 * SCSI BUS RESET OCCURRED or
+		 * MICROCODE HAS BEEN CHANGED or
+		 * protocol specific
+		 * BUS DEVICE RESET FUNCTION OCCURRED
+		 * I_T NEXUS LOSS OCCURRED
+		 * COMMANDS CLEARED BY POWER LOSS NOTIFICATION
+		 * all others                                    Lowest
+		 *
+		 * Each of the ASCQ codes listed above are defined in
+		 * the 29h ASC family, see spc4r17 Table D.1
+		 */
+		if (ua_p->ua_asc == 0x29) {
+			if ((asc == 0x29) && (ascq > ua_p->ua_ascq))
+				list_add(&ua->ua_nacl_list,
+						&deve->ua_list);
+			else
+				list_add_tail(&ua->ua_nacl_list,
+						&deve->ua_list);
+		} else if (ua_p->ua_asc == 0x2a) {
+			/*
+			 * Incoming Family 29h ASCQ codes will override
+			 * Family 2AHh ASCQ codes for Unit Attention condition.
+			 */
+			if ((asc == 0x29) || (ascq > ua_p->ua_asc))
+				list_add(&ua->ua_nacl_list,
+					&deve->ua_list);
+			else
+				list_add_tail(&ua->ua_nacl_list,
+						&deve->ua_list);
+		} else
+			list_add_tail(&ua->ua_nacl_list,
+				&deve->ua_list);
+		spin_unlock(&deve->ua_lock);
+
+		atomic_inc(&deve->ua_count);
+		smp_mb__after_atomic_inc();
+		return 0;
+	}
+	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
+	spin_unlock(&deve->ua_lock);
+	spin_unlock(&nacl->device_list_lock);
+
+	printk(KERN_INFO "[%s]: Allocated UNIT ATTENTION, mapped LUN: %u, ASC:"
+		" 0x%02x, ASCQ: 0x%02x\n",
+		TPG_TFO(nacl->se_tpg)->get_fabric_name(), unpacked_lun,
+		asc, ascq);
+
+	atomic_inc(&deve->ua_count);
+	smp_mb__after_atomic_inc();
+	return 0;
+}
+
+void core_scsi3_ua_release_all(
+	se_dev_entry_t *deve)
+{
+	se_ua_t *ua, *ua_p;
+
+	spin_lock(&deve->ua_lock);
+	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_list) {
+		list_del(&ua->ua_nacl_list);
+		kmem_cache_free(se_ua_cache, ua);
+
+		atomic_dec(&deve->ua_count);
+		smp_mb__after_atomic_dec();
+	}
+	spin_unlock(&deve->ua_lock);
+}
+
+void core_scsi3_ua_for_check_condition(
+	se_cmd_t *cmd,
+	u8 *asc,
+	u8 *ascq)
+{
+	se_device_t *dev = SE_DEV(cmd);
+	se_dev_entry_t *deve;
+	se_session_t *sess = cmd->se_sess;
+	se_node_acl_t *nacl;
+	se_ua_t *ua = NULL, *ua_p;
+	int head = 1;
+
+	if (!(sess))
+		return;
+
+	nacl = sess->se_node_acl;
+	if (!(nacl))
+		return;
+
+	spin_lock(&nacl->device_list_lock);
+	deve = &nacl->device_list[cmd->orig_fe_lun];
+	if (!(atomic_read(&deve->ua_count))) {
+		spin_unlock(&nacl->device_list_lock);
+		return;
+	}
+	/*
+	 * The highest priority Unit Attentions are placed at the head of the
+	 * se_dev_entry_t->ua_list, and will be returned in CHECK_CONDITION +
+	 * sense data for the received CDB.
+	 */
+	spin_lock(&deve->ua_lock);
+	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_list) {
+		/*
+		 * For ua_intlck_ctrl code not equal to 00b, only report the
+		 * highest priority UNIT_ATTENTION and ASC/ASCQ without
+		 * clearing it.
+		 */
+		if (DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl != 0) {
+			*asc = ua->ua_asc;
+			*ascq = ua->ua_ascq;
+			break;
+		}
+		/*
+		 * Otherwise for the default 00b, release the UNIT ATTENTION
+		 * condition.  Return the ASC/ASCQ of the higest priority UA
+		 * (head of the list) in the outgoing CHECK_CONDITION + sense.
+		 */
+		if (head) {
+			*asc = ua->ua_asc;
+			*ascq = ua->ua_ascq;
+			head = 0;
+		}
+		list_del(&ua->ua_nacl_list);
+		kmem_cache_free(se_ua_cache, ua);
+
+		atomic_dec(&deve->ua_count);
+		smp_mb__after_atomic_dec();
+	}
+	spin_unlock(&deve->ua_lock);
+	spin_unlock(&nacl->device_list_lock);
+
+	printk(KERN_INFO "[%s]: %s UNIT ATTENTION condition with"
+		" INTLCK_CTRL: %d, mapped LUN: %u, reported ASC: 0x%02x, ASCQ:"
+		" 0x%02x\n", TPG_TFO(nacl->se_tpg)->get_fabric_name(),
+		(DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl != 0) ? "Reporting" :
+		"Releasing", DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl,
+		cmd->orig_fe_lun, *asc, *ascq);
+}
+
+int core_scsi3_ua_clear_for_request_sense(
+	se_cmd_t *cmd,
+	u8 *asc,
+	u8 *ascq)
+{
+	se_dev_entry_t *deve;
+	se_session_t *sess = cmd->se_sess;
+	se_node_acl_t *nacl;
+	se_ua_t *ua = NULL, *ua_p;
+	int head = 1;
+
+	if (!(sess))
+		return -1;
+
+	nacl = sess->se_node_acl;
+	if (!(nacl))
+		return -1;
+
+	spin_lock(&nacl->device_list_lock);
+	deve = &nacl->device_list[cmd->orig_fe_lun];
+	if (!(atomic_read(&deve->ua_count))) {
+		spin_unlock(&nacl->device_list_lock);
+		return -1;
+	}
+	/*
+	 * The highest priority Unit Attentions are placed at the head of the
+	 * se_dev_entry_t->ua_list.  The First (and hence highest priority)
+	 * ASC/ASCQ will be returned in REQUEST_SENSE payload data for the
+	 * matching se_lun_t.
+	 *
+	 * Once the returning ASC/ASCQ values are set, we go ahead and
+	 * release all of the Unit Attention conditions for the assoicated
+	 * se_lun_t.
+	 */
+	spin_lock(&deve->ua_lock);
+	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_list) {
+		if (head) {
+			*asc = ua->ua_asc;
+			*ascq = ua->ua_ascq;
+			head = 0;
+		}
+		list_del(&ua->ua_nacl_list);
+		kmem_cache_free(se_ua_cache, ua);
+
+		atomic_dec(&deve->ua_count);
+		smp_mb__after_atomic_dec();
+	}
+	spin_unlock(&deve->ua_lock);
+	spin_unlock(&nacl->device_list_lock);
+
+	printk(KERN_INFO "[%s]: Released UNIT ATTENTION condition, mapped"
+		" LUN: %u, reported ASC: 0x%02x, ASCQ: 0x%02x\n",
+		TPG_TFO(nacl->se_tpg)->get_fabric_name(), cmd->orig_fe_lun,
+		*asc, *ascq);
+
+	return (head) ? -1 : 0;
+}
diff --git a/drivers/lio-core/target_core_ua.h b/drivers/lio-core/target_core_ua.h
new file mode 100644
index 0000000..9e600d0
--- /dev/null
+++ b/drivers/lio-core/target_core_ua.h
@@ -0,0 +1,36 @@
+#ifndef TARGET_CORE_UA_H
+
+/*
+ * From spc4r17, Table D.1: ASC and ASCQ Assignement
+ */
+#define ASCQ_29H_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURED	0x00
+#define ASCQ_29H_POWER_ON_OCCURRED				0x01
+#define ASCQ_29H_SCSI_BUS_RESET_OCCURED				0x02
+#define ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED		0x03
+#define ASCQ_29H_DEVICE_INTERNAL_RESET				0x04
+#define ASCQ_29H_TRANSCEIVER_MODE_CHANGED_TO_SINGLE_ENDED	0x05
+#define ASCQ_29H_TRANSCEIVER_MODE_CHANGED_TO_LVD		0x06
+#define ASCQ_29H_NEXUS_LOSS_OCCURRED				0x07
+
+#define ASCQ_2AH_PARAMETERS_CHANGED				0x00
+#define ASCQ_2AH_MODE_PARAMETERS_CHANGED			0x01
+#define ASCQ_2AH_LOG_PARAMETERS_CHANGED				0x02
+#define ASCQ_2AH_RESERVATIONS_PREEMPTED				0x03
+#define ASCQ_2AH_RESERVATIONS_RELEASED				0x04
+#define ASCQ_2AH_REGISTRATIONS_PREEMPTED			0x05
+#define ASCQ_2AH_ASYMMETRIC_ACCESS_STATE_CHANGED		0x06
+#define ASCQ_2AH_IMPLICT_ASYMMETRIC_ACCESS_STATE_TRANSITION_FAILED 0x07
+#define ASCQ_2AH_PRIORITY_CHANGED				0x08
+
+#define ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS		0x09
+
+extern struct kmem_cache *se_ua_cache;
+
+extern int core_scsi3_ua_check(struct se_cmd_s *, unsigned char *);
+extern int core_scsi3_ua_allocate(struct se_node_acl_s *, u32, u8, u8);
+extern void core_scsi3_ua_release_all(struct se_dev_entry_s *);
+extern void core_scsi3_ua_for_check_condition(struct se_cmd_s *, u8 *, u8 *);
+extern int core_scsi3_ua_clear_for_request_sense(struct se_cmd_s *,
+						u8 *, u8 *);
+
+#endif /* TARGET_CORE_UA_H */
-- 
1.5.4.1



