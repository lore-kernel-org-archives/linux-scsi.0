From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 28/31] target: Remove procfs based target_core_mib.c code
Date: Wed,  9 Feb 2011 15:35:03 -0800
Message-ID: <1297294506-23579-29-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm5.bullet.mail.ne1.yahoo.com ([98.138.90.68]:46691 "HELO
	nm5.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756123Ab1BIXgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:36:03 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the legacy procfs based target_core_mib.c code,
and moves the necessary scsi_index_tables functions and defines into
target_core_transport.c and target_core_base.h code to allow existing
fabric independent statistics to function.

This includes the removal of a handful of 'atomic_t mib_ref_count'
counters used in struct se_node_acl, se_session and se_hba to prevent
removal while using seq_list procfs walking logic.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Makefile                |    3 +-
 drivers/target/target_core_configfs.c  |   16 -
 drivers/target/target_core_device.c    |    3 -
 drivers/target/target_core_hba.c       |    1 -
 drivers/target/target_core_mib.c       | 1078 --------------------------------
 drivers/target/target_core_mib.h       |   21 -
 drivers/target/target_core_tpg.c       |   10 -
 drivers/target/target_core_transport.c |   43 +-
 include/target/target_core_base.h      |   20 +-
 include/target/target_core_transport.h |    2 +
 10 files changed, 52 insertions(+), 1145 deletions(-)
 delete mode 100644 drivers/target/target_core_mib.c
 delete mode 100644 drivers/target/target_core_mib.h

diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 5cfd708..973bb19 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -13,8 +13,7 @@ target_core_mod-y		:= target_core_configfs.o \
 				   target_core_transport.o \
 				   target_core_cdb.o \
 				   target_core_ua.o \
-				   target_core_rd.o \
-				   target_core_mib.o
+				   target_core_rd.o
 
 obj-$(CONFIG_TARGET_CORE)	+= target_core_mod.o
 
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c54c4c0..9721ef2 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -37,7 +37,6 @@
 #include <linux/parser.h>
 #include <linux/syscalls.h>
 #include <linux/configfs.h>
-#include <linux/proc_fs.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
@@ -51,7 +50,6 @@
 #include "target_core_hba.h"
 #include "target_core_pr.h"
 #include "target_core_rd.h"
-#include "target_core_mib.h"
 
 static struct list_head g_tf_list;
 static struct mutex g_tf_lock;
@@ -3082,7 +3080,6 @@ static int target_core_init_configfs(void)
 	struct config_group *target_cg, *hba_cg = NULL, *alua_cg = NULL;
 	struct config_group *lu_gp_cg = NULL;
 	struct configfs_subsystem *subsys;
-	struct proc_dir_entry *scsi_target_proc = NULL;
 	struct t10_alua_lu_gp *lu_gp;
 	int ret;
 
@@ -3188,21 +3185,10 @@ static int target_core_init_configfs(void)
 	if (core_dev_setup_virtual_lun0() < 0)
 		goto out;
 
-	scsi_target_proc = proc_mkdir("scsi_target", 0);
-	if (!(scsi_target_proc)) {
-		printk(KERN_ERR "proc_mkdir(scsi_target, 0) failed\n");
-		goto out;
-	}
-	ret = init_scsi_target_mib();
-	if (ret < 0)
-		goto out;
-
 	return 0;
 
 out:
 	configfs_unregister_subsystem(subsys);
-	if (scsi_target_proc)
-		remove_proc_entry("scsi_target", 0);
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
 out_global:
@@ -3270,8 +3256,6 @@ static void target_core_exit_configfs(void)
 	printk(KERN_INFO "TARGET_CORE[0]: Released ConfigFS Fabric"
 			" Infrastructure\n");
 
-	remove_scsi_target_mib();
-	remove_proc_entry("scsi_target", 0);
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
 	release_se_global();
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 9551ab5..5da051a 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -867,9 +867,6 @@ static void se_dev_stop(struct se_device *dev)
 		}
 	}
 	spin_unlock(&hba->device_lock);
-
-	while (atomic_read(&hba->dev_mib_access_count))
-		cpu_relax();
 }
 
 int se_dev_check_online(struct se_device *dev)
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 29dc3fa..4bbe820 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -43,7 +43,6 @@
 #include <target/target_core_transport.h>
 
 #include "target_core_hba.h"
-#include "target_core_mib.h"
 
 static LIST_HEAD(subsystem_list);
 static DEFINE_MUTEX(subsystem_mutex);
diff --git a/drivers/target/target_core_mib.c b/drivers/target/target_core_mib.c
deleted file mode 100644
index d5a48aa..0000000
--- a/drivers/target/target_core_mib.c
+++ /dev/null
@@ -1,1078 +0,0 @@
-/*******************************************************************************
- * Filename:  target_core_mib.c
- *
- * Copyright (c) 2006-2007 SBE, Inc.  All Rights Reserved.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
- *
- * Nicholas A. Bellinger <nab@linux-iscsi.org>
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
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/string.h>
-#include <linux/version.h>
-#include <generated/utsrelease.h>
-#include <linux/utsname.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/blkdev.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_host.h>
-
-#include <target/target_core_base.h>
-#include <target/target_core_transport.h>
-#include <target/target_core_fabric_ops.h>
-#include <target/target_core_configfs.h>
-
-#include "target_core_hba.h"
-#include "target_core_mib.h"
-
-/* SCSI mib table index */
-static struct scsi_index_table scsi_index_table;
-
-#ifndef INITIAL_JIFFIES
-#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
-#endif
-
-/* SCSI Instance Table */
-#define SCSI_INST_SW_INDEX		1
-#define SCSI_TRANSPORT_INDEX		1
-
-#define NONE		"None"
-#define ISPRINT(a)   ((a >= ' ') && (a <= '~'))
-
-static inline int list_is_first(const struct list_head *list,
-				const struct list_head *head)
-{
-	return list->prev == head;
-}
-
-static void *locate_hba_start(
-	struct seq_file *seq,
-	loff_t *pos)
-{
-	spin_lock(&se_global->g_device_lock);
-	return seq_list_start(&se_global->g_se_dev_list, *pos);
-}
-
-static void *locate_hba_next(
-	struct seq_file *seq,
-	void *v,
-	loff_t *pos)
-{
-	return seq_list_next(v, &se_global->g_se_dev_list, pos);
-}
-
-static void locate_hba_stop(struct seq_file *seq, void *v)
-{
-	spin_unlock(&se_global->g_device_lock);
-}
-
-/****************************************************************************
- * SCSI MIB Tables
- ****************************************************************************/
-
-/*
- * SCSI Instance Table
- */
-static void *scsi_inst_seq_start(
-	struct seq_file *seq,
-	loff_t *pos)
-{
-	spin_lock(&se_global->hba_lock);
-	return seq_list_start(&se_global->g_hba_list, *pos);
-}
-
-static void *scsi_inst_seq_next(
-	struct seq_file *seq,
-	void *v,
-	loff_t *pos)
-{
-	return seq_list_next(v, &se_global->g_hba_list, pos);
-}
-
-static void scsi_inst_seq_stop(struct seq_file *seq, void *v)
-{
-	spin_unlock(&se_global->hba_lock);
-}
-
-static int scsi_inst_seq_show(struct seq_file *seq, void *v)
-{
-	struct se_hba *hba = list_entry(v, struct se_hba, hba_list);
-
-	if (list_is_first(&hba->hba_list, &se_global->g_hba_list))
-		seq_puts(seq, "inst sw_indx\n");
-
-	seq_printf(seq, "%u %u\n", hba->hba_index, SCSI_INST_SW_INDEX);
-	seq_printf(seq, "plugin: %s version: %s\n",
-			hba->transport->name, TARGET_CORE_VERSION);
-
-	return 0;
-}
-
-static const struct seq_operations scsi_inst_seq_ops = {
-	.start	= scsi_inst_seq_start,
-	.next	= scsi_inst_seq_next,
-	.stop	= scsi_inst_seq_stop,
-	.show	= scsi_inst_seq_show
-};
-
-static int scsi_inst_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scsi_inst_seq_ops);
-}
-
-static const struct file_operations scsi_inst_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = scsi_inst_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
-/*
- * SCSI Device Table
- */
-static void *scsi_dev_seq_start(struct seq_file *seq, loff_t *pos)
-{
-	return locate_hba_start(seq, pos);
-}
-
-static void *scsi_dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-{
-	return locate_hba_next(seq, v, pos);
-}
-
-static void scsi_dev_seq_stop(struct seq_file *seq, void *v)
-{
-	locate_hba_stop(seq, v);
-}
-
-static int scsi_dev_seq_show(struct seq_file *seq, void *v)
-{
-	struct se_hba *hba;
-	struct se_subsystem_dev *se_dev = list_entry(v, struct se_subsystem_dev,
-						g_se_dev_list);
-	struct se_device *dev = se_dev->se_dev_ptr;
-	char str[28];
-	int k;
-
-	if (list_is_first(&se_dev->g_se_dev_list, &se_global->g_se_dev_list))
-		seq_puts(seq, "inst indx role ports\n");
-
-	if (!(dev))
-		return 0;
-
-	hba = dev->se_hba;
-	if (!(hba)) {
-		/* Log error ? */
-		return 0;
-	}
-
-	seq_printf(seq, "%u %u %s %u\n", hba->hba_index,
-		   dev->dev_index, "Target", dev->dev_port_count);
-
-	memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
-
-	/* vendor */
-	for (k = 0; k < 8; k++)
-		str[k] = ISPRINT(DEV_T10_WWN(dev)->vendor[k]) ?
-				DEV_T10_WWN(dev)->vendor[k] : 0x20;
-	str[k] = 0x20;
-
-	/* model */
-	for (k = 0; k < 16; k++)
-		str[k+9] = ISPRINT(DEV_T10_WWN(dev)->model[k]) ?
-				DEV_T10_WWN(dev)->model[k] : 0x20;
-	str[k + 9] = 0;
-
-	seq_printf(seq, "dev_alias: %s\n", str);
-
-	return 0;
-}
-
-static const struct seq_operations scsi_dev_seq_ops = {
-	.start  = scsi_dev_seq_start,
-	.next   = scsi_dev_seq_next,
-	.stop   = scsi_dev_seq_stop,
-	.show   = scsi_dev_seq_show
-};
-
-static int scsi_dev_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scsi_dev_seq_ops);
-}
-
-static const struct file_operations scsi_dev_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = scsi_dev_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
-/*
- * SCSI Port Table
- */
-static void *scsi_port_seq_start(struct seq_file *seq, loff_t *pos)
-{
-	return locate_hba_start(seq, pos);
-}
-
-static void *scsi_port_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-{
-	return locate_hba_next(seq, v, pos);
-}
-
-static void scsi_port_seq_stop(struct seq_file *seq, void *v)
-{
-	locate_hba_stop(seq, v);
-}
-
-static int scsi_port_seq_show(struct seq_file *seq, void *v)
-{
-	struct se_hba *hba;
-	struct se_subsystem_dev *se_dev = list_entry(v, struct se_subsystem_dev,
-						g_se_dev_list);
-	struct se_device *dev = se_dev->se_dev_ptr;
-	struct se_port *sep, *sep_tmp;
-
-	if (list_is_first(&se_dev->g_se_dev_list, &se_global->g_se_dev_list))
-		seq_puts(seq, "inst device indx role busy_count\n");
-
-	if (!(dev))
-		return 0;
-
-	hba = dev->se_hba;
-	if (!(hba)) {
-		/* Log error ? */
-		return 0;
-	}
-
-	/* FIXME: scsiPortBusyStatuses count */
-	spin_lock(&dev->se_port_lock);
-	list_for_each_entry_safe(sep, sep_tmp, &dev->dev_sep_list, sep_list) {
-		seq_printf(seq, "%u %u %u %s%u %u\n", hba->hba_index,
-			dev->dev_index, sep->sep_index, "Device",
-			dev->dev_index, 0);
-	}
-	spin_unlock(&dev->se_port_lock);
-
-	return 0;
-}
-
-static const struct seq_operations scsi_port_seq_ops = {
-	.start  = scsi_port_seq_start,
-	.next   = scsi_port_seq_next,
-	.stop   = scsi_port_seq_stop,
-	.show   = scsi_port_seq_show
-};
-
-static int scsi_port_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scsi_port_seq_ops);
-}
-
-static const struct file_operations scsi_port_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = scsi_port_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
-/*
- * SCSI Transport Table
- */
-static void *scsi_transport_seq_start(struct seq_file *seq, loff_t *pos)
-{
-	return locate_hba_start(seq, pos);
-}
-
-static void *scsi_transport_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-{
-	return locate_hba_next(seq, v, pos);
-}
-
-static void scsi_transport_seq_stop(struct seq_file *seq, void *v)
-{
-	locate_hba_stop(seq, v);
-}
-
-static int scsi_transport_seq_show(struct seq_file *seq, void *v)
-{
-	struct se_hba *hba;
-	struct se_subsystem_dev *se_dev = list_entry(v, struct se_subsystem_dev,
-						g_se_dev_list);
-	struct se_device *dev = se_dev->se_dev_ptr;
-	struct se_port *se, *se_tmp;
-	struct se_portal_group *tpg;
-	struct t10_wwn *wwn;
-	char buf[64];
-
-	if (list_is_first(&se_dev->g_se_dev_list, &se_global->g_se_dev_list))
-		seq_puts(seq, "inst device indx dev_name\n");
-
-	if (!(dev))
-		return 0;
-
-	hba = dev->se_hba;
-	if (!(hba)) {
-		/* Log error ? */
-		return 0;
-	}
-
-	wwn = DEV_T10_WWN(dev);
-
-	spin_lock(&dev->se_port_lock);
-	list_for_each_entry_safe(se, se_tmp, &dev->dev_sep_list, sep_list) {
-		tpg = se->sep_tpg;
-		sprintf(buf, "scsiTransport%s",
-				TPG_TFO(tpg)->get_fabric_name());
-
-		seq_printf(seq, "%u %s %u %s+%s\n",
-			hba->hba_index, /* scsiTransportIndex */
-			buf,  /* scsiTransportType */
-			(TPG_TFO(tpg)->tpg_get_inst_index != NULL) ?
-			TPG_TFO(tpg)->tpg_get_inst_index(tpg) :
-			0,
-			TPG_TFO(tpg)->tpg_get_wwn(tpg),
-			(strlen(wwn->unit_serial)) ?
-			/* scsiTransportDevName */
-			wwn->unit_serial : wwn->vendor);
-	}
-	spin_unlock(&dev->se_port_lock);
-
-	return 0;
-}
-
-static const struct seq_operations scsi_transport_seq_ops = {
-	.start  = scsi_transport_seq_start,
-	.next   = scsi_transport_seq_next,
-	.stop   = scsi_transport_seq_stop,
-	.show   = scsi_transport_seq_show
-};
-
-static int scsi_transport_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scsi_transport_seq_ops);
-}
-
-static const struct file_operations scsi_transport_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = scsi_transport_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
-/*
- * SCSI Target Device Table
- */
-static void *scsi_tgt_dev_seq_start(struct seq_file *seq, loff_t *pos)
-{
-	return locate_hba_start(seq, pos);
-}
-
-static void *scsi_tgt_dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-{
-	return locate_hba_next(seq, v, pos);
-}
-
-static void scsi_tgt_dev_seq_stop(struct seq_file *seq, void *v)
-{
-	locate_hba_stop(seq, v);
-}
-
-
-#define LU_COUNT	1  /* for now */
-static int scsi_tgt_dev_seq_show(struct seq_file *seq, void *v)
-{
-	struct se_hba *hba;
-	struct se_subsystem_dev *se_dev = list_entry(v, struct se_subsystem_dev,
-						g_se_dev_list);
-	struct se_device *dev = se_dev->se_dev_ptr;
-	int non_accessible_lus = 0;
-	char status[16];
-
-	if (list_is_first(&se_dev->g_se_dev_list, &se_global->g_se_dev_list))
-		seq_puts(seq, "inst indx num_LUs status non_access_LUs"
-			" resets\n");
-
-	if (!(dev))
-		return 0;
-
-	hba = dev->se_hba;
-	if (!(hba)) {
-		/* Log error ? */
-		return 0;
-	}
-
-	switch (dev->dev_status) {
-	case TRANSPORT_DEVICE_ACTIVATED:
-		strcpy(status, "activated");
-		break;
-	case TRANSPORT_DEVICE_DEACTIVATED:
-		strcpy(status, "deactivated");
-		non_accessible_lus = 1;
-		break;
-	case TRANSPORT_DEVICE_SHUTDOWN:
-		strcpy(status, "shutdown");
-		non_accessible_lus = 1;
-		break;
-	case TRANSPORT_DEVICE_OFFLINE_ACTIVATED:
-	case TRANSPORT_DEVICE_OFFLINE_DEACTIVATED:
-		strcpy(status, "offline");
-		non_accessible_lus = 1;
-		break;
-	default:
-		sprintf(status, "unknown(%d)", dev->dev_status);
-		non_accessible_lus = 1;
-	}
-
-	seq_printf(seq, "%u %u %u %s %u %u\n",
-		   hba->hba_index, dev->dev_index, LU_COUNT,
-		   status, non_accessible_lus, dev->num_resets);
-
-	return 0;
-}
-
-static const struct seq_operations scsi_tgt_dev_seq_ops = {
-	.start  = scsi_tgt_dev_seq_start,
-	.next   = scsi_tgt_dev_seq_next,
-	.stop   = scsi_tgt_dev_seq_stop,
-	.show   = scsi_tgt_dev_seq_show
-};
-
-static int scsi_tgt_dev_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scsi_tgt_dev_seq_ops);
-}
-
-static const struct file_operations scsi_tgt_dev_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = scsi_tgt_dev_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
-/*
- * SCSI Target Port Table
- */
-static void *scsi_tgt_port_seq_start(struct seq_file *seq, loff_t *pos)
-{
-	return locate_hba_start(seq, pos);
-}
-
-static void *scsi_tgt_port_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-{
-	return locate_hba_next(seq, v, pos);
-}
-
-static void scsi_tgt_port_seq_stop(struct seq_file *seq, void *v)
-{
-	locate_hba_stop(seq, v);
-}
-
-static int scsi_tgt_port_seq_show(struct seq_file *seq, void *v)
-{
-	struct se_hba *hba;
-	struct se_subsystem_dev *se_dev = list_entry(v, struct se_subsystem_dev,
-						g_se_dev_list);
-	struct se_device *dev = se_dev->se_dev_ptr;
-	struct se_port *sep, *sep_tmp;
-	struct se_portal_group *tpg;
-	u32 rx_mbytes, tx_mbytes;
-	unsigned long long num_cmds;
-	char buf[64];
-
-	if (list_is_first(&se_dev->g_se_dev_list, &se_global->g_se_dev_list))
-		seq_puts(seq, "inst device indx name port_index in_cmds"
-			" write_mbytes read_mbytes hs_in_cmds\n");
-
-	if (!(dev))
-		return 0;
-
-	hba = dev->se_hba;
-	if (!(hba)) {
-		/* Log error ? */
-		return 0;
-	}
-
-	spin_lock(&dev->se_port_lock);
-	list_for_each_entry_safe(sep, sep_tmp, &dev->dev_sep_list, sep_list) {
-		tpg = sep->sep_tpg;
-		sprintf(buf, "%sPort#",
-			TPG_TFO(tpg)->get_fabric_name());
-
-		seq_printf(seq, "%u %u %u %s%d %s%s%d ",
-		     hba->hba_index,
-		     dev->dev_index,
-		     sep->sep_index,
-		     buf, sep->sep_index,
-		     TPG_TFO(tpg)->tpg_get_wwn(tpg), "+t+",
-		     TPG_TFO(tpg)->tpg_get_tag(tpg));
-
-		spin_lock(&sep->sep_lun->lun_sep_lock);
-		num_cmds = sep->sep_stats.cmd_pdus;
-		rx_mbytes = (sep->sep_stats.rx_data_octets >> 20);
-		tx_mbytes = (sep->sep_stats.tx_data_octets >> 20);
-		spin_unlock(&sep->sep_lun->lun_sep_lock);
-
-		seq_printf(seq, "%llu %u %u %u\n", num_cmds,
-			rx_mbytes, tx_mbytes, 0);
-	}
-	spin_unlock(&dev->se_port_lock);
-
-	return 0;
-}
-
-static const struct seq_operations scsi_tgt_port_seq_ops = {
-	.start  = scsi_tgt_port_seq_start,
-	.next   = scsi_tgt_port_seq_next,
-	.stop   = scsi_tgt_port_seq_stop,
-	.show   = scsi_tgt_port_seq_show
-};
-
-static int scsi_tgt_port_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scsi_tgt_port_seq_ops);
-}
-
-static const struct file_operations scsi_tgt_port_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = scsi_tgt_port_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
-/*
- * SCSI Authorized Initiator Table:
- * It contains the SCSI Initiators authorized to be attached to one of the
- * local Target ports.
- * Iterates through all active TPGs and extracts the info from the ACLs
- */
-static void *scsi_auth_intr_seq_start(struct seq_file *seq, loff_t *pos)
-{
-	spin_lock_bh(&se_global->se_tpg_lock);
-	return seq_list_start(&se_global->g_se_tpg_list, *pos);
-}
-
-static void *scsi_auth_intr_seq_next(struct seq_file *seq, void *v,
-					 loff_t *pos)
-{
-	return seq_list_next(v, &se_global->g_se_tpg_list, pos);
-}
-
-static void scsi_auth_intr_seq_stop(struct seq_file *seq, void *v)
-{
-	spin_unlock_bh(&se_global->se_tpg_lock);
-}
-
-static int scsi_auth_intr_seq_show(struct seq_file *seq, void *v)
-{
-	struct se_portal_group *se_tpg = list_entry(v, struct se_portal_group,
-						se_tpg_list);
-	struct se_dev_entry *deve;
-	struct se_lun *lun;
-	struct se_node_acl *se_nacl;
-	int j;
-
-	if (list_is_first(&se_tpg->se_tpg_list,
-			  &se_global->g_se_tpg_list))
-		seq_puts(seq, "inst dev port indx dev_or_port intr_name "
-			 "map_indx att_count num_cmds read_mbytes "
-			 "write_mbytes hs_num_cmds creation_time row_status\n");
-
-	if (!(se_tpg))
-		return 0;
-
-	spin_lock(&se_tpg->acl_node_lock);
-	list_for_each_entry(se_nacl, &se_tpg->acl_node_list, acl_list) {
-
-		atomic_inc(&se_nacl->mib_ref_count);
-		smp_mb__after_atomic_inc();
-		spin_unlock(&se_tpg->acl_node_lock);
-
-		spin_lock_irq(&se_nacl->device_list_lock);
-		for (j = 0; j < TRANSPORT_MAX_LUNS_PER_TPG; j++) {
-			deve = &se_nacl->device_list[j];
-			if (!(deve->lun_flags &
-					TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) ||
-			    (!deve->se_lun))
-				continue;
-			lun = deve->se_lun;
-			if (!lun->lun_se_dev)
-				continue;
-
-			seq_printf(seq, "%u %u %u %u %u %s %u %u %u %u %u %u"
-					" %u %s\n",
-				/* scsiInstIndex */
-				(TPG_TFO(se_tpg)->tpg_get_inst_index != NULL) ?
-				TPG_TFO(se_tpg)->tpg_get_inst_index(se_tpg) :
-				0,
-				/* scsiDeviceIndex */
-				lun->lun_se_dev->dev_index,
-				/* scsiAuthIntrTgtPortIndex */
-				TPG_TFO(se_tpg)->tpg_get_tag(se_tpg),
-				/* scsiAuthIntrIndex */
-				se_nacl->acl_index,
-				/* scsiAuthIntrDevOrPort */
-				1,
-				/* scsiAuthIntrName */
-				se_nacl->initiatorname[0] ?
-					se_nacl->initiatorname : NONE,
-				/* FIXME: scsiAuthIntrLunMapIndex */
-				0,
-				/* scsiAuthIntrAttachedTimes */
-				deve->attach_count,
-				/* scsiAuthIntrOutCommands */
-				deve->total_cmds,
-				/* scsiAuthIntrReadMegaBytes */
-				(u32)(deve->read_bytes >> 20),
-				/* scsiAuthIntrWrittenMegaBytes */
-				(u32)(deve->write_bytes >> 20),
-				/* FIXME: scsiAuthIntrHSOutCommands */
-				0,
-				/* scsiAuthIntrLastCreation */
-				(u32)(((u32)deve->creation_time -
-					    INITIAL_JIFFIES) * 100 / HZ),
-				/* FIXME: scsiAuthIntrRowStatus */
-				"Ready");
-		}
-		spin_unlock_irq(&se_nacl->device_list_lock);
-
-		spin_lock(&se_tpg->acl_node_lock);
-		atomic_dec(&se_nacl->mib_ref_count);
-		smp_mb__after_atomic_dec();
-	}
-	spin_unlock(&se_tpg->acl_node_lock);
-
-	return 0;
-}
-
-static const struct seq_operations scsi_auth_intr_seq_ops = {
-	.start	= scsi_auth_intr_seq_start,
-	.next	= scsi_auth_intr_seq_next,
-	.stop	= scsi_auth_intr_seq_stop,
-	.show	= scsi_auth_intr_seq_show
-};
-
-static int scsi_auth_intr_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scsi_auth_intr_seq_ops);
-}
-
-static const struct file_operations scsi_auth_intr_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = scsi_auth_intr_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
-/*
- * SCSI Attached Initiator Port Table:
- * It lists the SCSI Initiators attached to one of the local Target ports.
- * Iterates through all active TPGs and use active sessions from each TPG
- * to list the info fo this table.
- */
-static void *scsi_att_intr_port_seq_start(struct seq_file *seq, loff_t *pos)
-{
-	spin_lock_bh(&se_global->se_tpg_lock);
-	return seq_list_start(&se_global->g_se_tpg_list, *pos);
-}
-
-static void *scsi_att_intr_port_seq_next(struct seq_file *seq, void *v,
-					 loff_t *pos)
-{
-	return seq_list_next(v, &se_global->g_se_tpg_list, pos);
-}
-
-static void scsi_att_intr_port_seq_stop(struct seq_file *seq, void *v)
-{
-	spin_unlock_bh(&se_global->se_tpg_lock);
-}
-
-static int scsi_att_intr_port_seq_show(struct seq_file *seq, void *v)
-{
-	struct se_portal_group *se_tpg = list_entry(v, struct se_portal_group,
-						se_tpg_list);
-	struct se_dev_entry *deve;
-	struct se_lun *lun;
-	struct se_node_acl *se_nacl;
-	struct se_session *se_sess;
-	unsigned char buf[64];
-	int j;
-
-	if (list_is_first(&se_tpg->se_tpg_list,
-			  &se_global->g_se_tpg_list))
-		seq_puts(seq, "inst dev port indx port_auth_indx port_name"
-			" port_ident\n");
-
-	if (!(se_tpg))
-		return 0;
-
-	spin_lock(&se_tpg->session_lock);
-	list_for_each_entry(se_sess, &se_tpg->tpg_sess_list, sess_list) {
-		if ((TPG_TFO(se_tpg)->sess_logged_in(se_sess)) ||
-		    (!se_sess->se_node_acl) ||
-		    (!se_sess->se_node_acl->device_list))
-			continue;
-
-		atomic_inc(&se_sess->mib_ref_count);
-		smp_mb__after_atomic_inc();
-		se_nacl = se_sess->se_node_acl;
-		atomic_inc(&se_nacl->mib_ref_count);
-		smp_mb__after_atomic_inc();
-		spin_unlock(&se_tpg->session_lock);
-
-		spin_lock_irq(&se_nacl->device_list_lock);
-		for (j = 0; j < TRANSPORT_MAX_LUNS_PER_TPG; j++) {
-			deve = &se_nacl->device_list[j];
-			if (!(deve->lun_flags &
-					TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) ||
-			   (!deve->se_lun))
-				continue;
-
-			lun = deve->se_lun;
-			if (!lun->lun_se_dev)
-				continue;
-
-			memset(buf, 0, 64);
-			if (TPG_TFO(se_tpg)->sess_get_initiator_sid != NULL)
-				TPG_TFO(se_tpg)->sess_get_initiator_sid(
-					se_sess, (unsigned char *)&buf[0], 64);
-
-			seq_printf(seq, "%u %u %u %u %u %s+i+%s\n",
-				/* scsiInstIndex */
-				(TPG_TFO(se_tpg)->tpg_get_inst_index != NULL) ?
-				TPG_TFO(se_tpg)->tpg_get_inst_index(se_tpg) :
-				0,
-				/* scsiDeviceIndex */
-				lun->lun_se_dev->dev_index,
-				/* scsiPortIndex */
-				TPG_TFO(se_tpg)->tpg_get_tag(se_tpg),
-				/* scsiAttIntrPortIndex */
-				(TPG_TFO(se_tpg)->sess_get_index != NULL) ?
-				TPG_TFO(se_tpg)->sess_get_index(se_sess) :
-				0,
-				/* scsiAttIntrPortAuthIntrIdx */
-				se_nacl->acl_index,
-				/* scsiAttIntrPortName */
-				se_nacl->initiatorname[0] ?
-					se_nacl->initiatorname : NONE,
-				/* scsiAttIntrPortIdentifier */
-				buf);
-		}
-		spin_unlock_irq(&se_nacl->device_list_lock);
-
-		spin_lock(&se_tpg->session_lock);
-		atomic_dec(&se_nacl->mib_ref_count);
-		smp_mb__after_atomic_dec();
-		atomic_dec(&se_sess->mib_ref_count);
-		smp_mb__after_atomic_dec();
-	}
-	spin_unlock(&se_tpg->session_lock);
-
-	return 0;
-}
-
-static const struct seq_operations scsi_att_intr_port_seq_ops = {
-	.start	= scsi_att_intr_port_seq_start,
-	.next	= scsi_att_intr_port_seq_next,
-	.stop	= scsi_att_intr_port_seq_stop,
-	.show	= scsi_att_intr_port_seq_show
-};
-
-static int scsi_att_intr_port_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scsi_att_intr_port_seq_ops);
-}
-
-static const struct file_operations scsi_att_intr_port_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = scsi_att_intr_port_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
-/*
- * SCSI Logical Unit Table
- */
-static void *scsi_lu_seq_start(struct seq_file *seq, loff_t *pos)
-{
-	return locate_hba_start(seq, pos);
-}
-
-static void *scsi_lu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-{
-	return locate_hba_next(seq, v, pos);
-}
-
-static void scsi_lu_seq_stop(struct seq_file *seq, void *v)
-{
-	locate_hba_stop(seq, v);
-}
-
-#define SCSI_LU_INDEX		1
-static int scsi_lu_seq_show(struct seq_file *seq, void *v)
-{
-	struct se_hba *hba;
-	struct se_subsystem_dev *se_dev = list_entry(v, struct se_subsystem_dev,
-						g_se_dev_list);
-	struct se_device *dev = se_dev->se_dev_ptr;
-	int j;
-	char str[28];
-
-	if (list_is_first(&se_dev->g_se_dev_list, &se_global->g_se_dev_list))
-		seq_puts(seq, "inst dev indx LUN lu_name vend prod rev"
-		" dev_type status state-bit num_cmds read_mbytes"
-		" write_mbytes resets full_stat hs_num_cmds creation_time\n");
-
-	if (!(dev))
-		return 0;
-
-	hba = dev->se_hba;
-	if (!(hba)) {
-		/* Log error ? */
-		return 0;
-	}
-
-	/* Fix LU state, if we can read it from the device */
-	seq_printf(seq, "%u %u %u %llu %s", hba->hba_index,
-			dev->dev_index, SCSI_LU_INDEX,
-			(unsigned long long)0, /* FIXME: scsiLuDefaultLun */
-			(strlen(DEV_T10_WWN(dev)->unit_serial)) ?
-			/* scsiLuWwnName */
-			(char *)&DEV_T10_WWN(dev)->unit_serial[0] :
-			"None");
-
-	memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
-	/* scsiLuVendorId */
-	for (j = 0; j < 8; j++)
-		str[j] = ISPRINT(DEV_T10_WWN(dev)->vendor[j]) ?
-			DEV_T10_WWN(dev)->vendor[j] : 0x20;
-	str[8] = 0;
-	seq_printf(seq, " %s", str);
-
-	/* scsiLuProductId */
-	for (j = 0; j < 16; j++)
-		str[j] = ISPRINT(DEV_T10_WWN(dev)->model[j]) ?
-			DEV_T10_WWN(dev)->model[j] : 0x20;
-	str[16] = 0;
-	seq_printf(seq, " %s", str);
-
-	/* scsiLuRevisionId */
-	for (j = 0; j < 4; j++)
-		str[j] = ISPRINT(DEV_T10_WWN(dev)->revision[j]) ?
-			DEV_T10_WWN(dev)->revision[j] : 0x20;
-	str[4] = 0;
-	seq_printf(seq, " %s", str);
-
-	seq_printf(seq, " %u %s %s %llu %u %u %u %u %u %u\n",
-		/* scsiLuPeripheralType */
-		   TRANSPORT(dev)->get_device_type(dev),
-		   (dev->dev_status == TRANSPORT_DEVICE_ACTIVATED) ?
-		"available" : "notavailable", /* scsiLuStatus */
-		"exposed", 	/* scsiLuState */
-		(unsigned long long)dev->num_cmds,
-		/* scsiLuReadMegaBytes */
-		(u32)(dev->read_bytes >> 20),
-		/* scsiLuWrittenMegaBytes */
-		(u32)(dev->write_bytes >> 20),
-		dev->num_resets, /* scsiLuInResets */
-		0, /* scsiLuOutTaskSetFullStatus */
-		0, /* scsiLuHSInCommands */
-		(u32)(((u32)dev->creation_time - INITIAL_JIFFIES) *
-							100 / HZ));
-
-	return 0;
-}
-
-static const struct seq_operations scsi_lu_seq_ops = {
-	.start  = scsi_lu_seq_start,
-	.next   = scsi_lu_seq_next,
-	.stop   = scsi_lu_seq_stop,
-	.show   = scsi_lu_seq_show
-};
-
-static int scsi_lu_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scsi_lu_seq_ops);
-}
-
-static const struct file_operations scsi_lu_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = scsi_lu_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
-/****************************************************************************/
-
-/*
- * Remove proc fs entries
- */
-void remove_scsi_target_mib(void)
-{
-	remove_proc_entry("scsi_target/mib/scsi_inst", NULL);
-	remove_proc_entry("scsi_target/mib/scsi_dev", NULL);
-	remove_proc_entry("scsi_target/mib/scsi_port", NULL);
-	remove_proc_entry("scsi_target/mib/scsi_transport", NULL);
-	remove_proc_entry("scsi_target/mib/scsi_tgt_dev", NULL);
-	remove_proc_entry("scsi_target/mib/scsi_tgt_port", NULL);
-	remove_proc_entry("scsi_target/mib/scsi_auth_intr", NULL);
-	remove_proc_entry("scsi_target/mib/scsi_att_intr_port", NULL);
-	remove_proc_entry("scsi_target/mib/scsi_lu", NULL);
-	remove_proc_entry("scsi_target/mib", NULL);
-}
-
-/*
- * Create proc fs entries for the mib tables
- */
-int init_scsi_target_mib(void)
-{
-	struct proc_dir_entry *dir_entry;
-	struct proc_dir_entry *scsi_inst_entry;
-	struct proc_dir_entry *scsi_dev_entry;
-	struct proc_dir_entry *scsi_port_entry;
-	struct proc_dir_entry *scsi_transport_entry;
-	struct proc_dir_entry *scsi_tgt_dev_entry;
-	struct proc_dir_entry *scsi_tgt_port_entry;
-	struct proc_dir_entry *scsi_auth_intr_entry;
-	struct proc_dir_entry *scsi_att_intr_port_entry;
-	struct proc_dir_entry *scsi_lu_entry;
-
-	dir_entry = proc_mkdir("scsi_target/mib", NULL);
-	if (!(dir_entry)) {
-		printk(KERN_ERR "proc_mkdir() failed.\n");
-		return -1;
-	}
-
-	scsi_inst_entry =
-		create_proc_entry("scsi_target/mib/scsi_inst", 0, NULL);
-	if (scsi_inst_entry)
-		scsi_inst_entry->proc_fops = &scsi_inst_seq_fops;
-	else
-		goto error;
-
-	scsi_dev_entry =
-		create_proc_entry("scsi_target/mib/scsi_dev", 0, NULL);
-	if (scsi_dev_entry)
-		scsi_dev_entry->proc_fops = &scsi_dev_seq_fops;
-	else
-		goto error;
-
-	scsi_port_entry =
-		create_proc_entry("scsi_target/mib/scsi_port", 0, NULL);
-	if (scsi_port_entry)
-		scsi_port_entry->proc_fops = &scsi_port_seq_fops;
-	else
-		goto error;
-
-	scsi_transport_entry =
-		create_proc_entry("scsi_target/mib/scsi_transport", 0, NULL);
-	if (scsi_transport_entry)
-		scsi_transport_entry->proc_fops = &scsi_transport_seq_fops;
-	else
-		goto error;
-
-	scsi_tgt_dev_entry =
-		create_proc_entry("scsi_target/mib/scsi_tgt_dev", 0, NULL);
-	if (scsi_tgt_dev_entry)
-		scsi_tgt_dev_entry->proc_fops = &scsi_tgt_dev_seq_fops;
-	else
-		goto error;
-
-	scsi_tgt_port_entry =
-		create_proc_entry("scsi_target/mib/scsi_tgt_port", 0, NULL);
-	if (scsi_tgt_port_entry)
-		scsi_tgt_port_entry->proc_fops = &scsi_tgt_port_seq_fops;
-	else
-		goto error;
-
-	scsi_auth_intr_entry =
-		create_proc_entry("scsi_target/mib/scsi_auth_intr", 0, NULL);
-	if (scsi_auth_intr_entry)
-		scsi_auth_intr_entry->proc_fops = &scsi_auth_intr_seq_fops;
-	else
-		goto error;
-
-	scsi_att_intr_port_entry =
-	      create_proc_entry("scsi_target/mib/scsi_att_intr_port", 0, NULL);
-	if (scsi_att_intr_port_entry)
-		scsi_att_intr_port_entry->proc_fops =
-				&scsi_att_intr_port_seq_fops;
-	else
-		goto error;
-
-	scsi_lu_entry = create_proc_entry("scsi_target/mib/scsi_lu", 0, NULL);
-	if (scsi_lu_entry)
-		scsi_lu_entry->proc_fops = &scsi_lu_seq_fops;
-	else
-		goto error;
-
-	return 0;
-
-error:
-	printk(KERN_ERR "create_proc_entry() failed.\n");
-	remove_scsi_target_mib();
-	return -1;
-}
-
-/*
- * Initialize the index table for allocating unique row indexes to various mib
- * tables
- */
-void init_scsi_index_table(void)
-{
-	memset(&scsi_index_table, 0, sizeof(struct scsi_index_table));
-	spin_lock_init(&scsi_index_table.lock);
-}
-
-/*
- * Allocate a new row index for the entry type specified
- */
-u32 scsi_get_new_index(scsi_index_t type)
-{
-	u32 new_index;
-
-	if ((type < 0) || (type >= SCSI_INDEX_TYPE_MAX)) {
-		printk(KERN_ERR "Invalid index type %d\n", type);
-		return -1;
-	}
-
-	spin_lock(&scsi_index_table.lock);
-	new_index = ++scsi_index_table.scsi_mib_index[type];
-	if (new_index == 0)
-		new_index = ++scsi_index_table.scsi_mib_index[type];
-	spin_unlock(&scsi_index_table.lock);
-
-	return new_index;
-}
-EXPORT_SYMBOL(scsi_get_new_index);
diff --git a/drivers/target/target_core_mib.h b/drivers/target/target_core_mib.h
deleted file mode 100644
index 5172674..0000000
--- a/drivers/target/target_core_mib.h
+++ /dev/null
@@ -1,21 +0,0 @@
-#ifndef TARGET_CORE_MIB_H
-#define TARGET_CORE_MIB_H
-
-typedef enum {
-	SCSI_INST_INDEX,
-	SCSI_DEVICE_INDEX,
-	SCSI_AUTH_INTR_INDEX,
-	SCSI_INDEX_TYPE_MAX
-} scsi_index_t;
-
-struct scsi_index_table {
-	spinlock_t	lock;
-	u32 		scsi_mib_index[SCSI_INDEX_TYPE_MAX];
-} ____cacheline_aligned;
-
-extern int init_scsi_target_mib(void);
-extern void remove_scsi_target_mib(void);
-extern void init_scsi_index_table(void);
-extern u32 scsi_get_new_index(scsi_index_t);
-
-#endif   /*** TARGET_CORE_MIB_H ***/
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 1f69be1..c26f674 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -45,7 +45,6 @@
 #include <target/target_core_fabric_ops.h>
 
 #include "target_core_hba.h"
-#include "target_core_mib.h"
 
 /*	core_clear_initiator_node_from_tpg():
  *
@@ -276,7 +275,6 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
 	atomic_set(&acl->acl_pr_ref_count, 0);
-	atomic_set(&acl->mib_ref_count, 0);
 	acl->queue_depth = TPG_TFO(tpg)->tpg_get_default_depth(tpg);
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
 	acl->se_tpg = tpg;
@@ -319,12 +317,6 @@ void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
 		cpu_relax();
 }
 
-void core_tpg_wait_for_mib_ref(struct se_node_acl *nacl)
-{
-	while (atomic_read(&nacl->mib_ref_count) != 0)
-		cpu_relax();
-}
-
 void core_tpg_clear_object_luns(struct se_portal_group *tpg)
 {
 	int i, ret;
@@ -481,7 +473,6 @@ int core_tpg_del_initiator_node_acl(
 	spin_unlock_bh(&tpg->session_lock);
 
 	core_tpg_wait_for_nacl_pr_ref(acl);
-	core_tpg_wait_for_mib_ref(acl);
 	core_clear_initiator_node_from_tpg(acl, tpg);
 	core_free_device_list_for_node(acl, tpg);
 
@@ -730,7 +721,6 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 		spin_unlock_bh(&se_tpg->acl_node_lock);
 
 		core_tpg_wait_for_nacl_pr_ref(nacl);
-		core_tpg_wait_for_mib_ref(nacl);
 		core_free_device_list_for_node(nacl, se_tpg);
 		TPG_TFO(se_tpg)->tpg_release_fabric_acl(se_tpg, nacl);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 04c68c9..73e45e9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -58,7 +58,6 @@
 #include "target_core_pr.h"
 #include "target_core_scdb.h"
 #include "target_core_ua.h"
-#include "target_core_mib.h"
 
 /* #define DEBUG_CDB_HANDLER */
 #ifdef DEBUG_CDB_HANDLER
@@ -380,6 +379,40 @@ void release_se_global(void)
 	se_global = NULL;
 }
 
+/* SCSI statistics table index */
+static struct scsi_index_table scsi_index_table;
+
+/*
+ * Initialize the index table for allocating unique row indexes to various mib
+ * tables.
+ */
+void init_scsi_index_table(void)
+{
+	memset(&scsi_index_table, 0, sizeof(struct scsi_index_table));
+	spin_lock_init(&scsi_index_table.lock);
+}
+
+/*
+ * Allocate a new row index for the entry type specified
+ */
+u32 scsi_get_new_index(scsi_index_t type)
+{
+	u32 new_index;
+
+	if ((type < 0) || (type >= SCSI_INDEX_TYPE_MAX)) {
+		printk(KERN_ERR "Invalid index type %d\n", type);
+		return -EINVAL;
+	}
+
+	spin_lock(&scsi_index_table.lock);
+	new_index = ++scsi_index_table.scsi_mib_index[type];
+	if (new_index == 0)
+		new_index = ++scsi_index_table.scsi_mib_index[type];
+	spin_unlock(&scsi_index_table.lock);
+
+	return new_index;
+}
+
 void transport_init_queue_obj(struct se_queue_obj *qobj)
 {
 	atomic_set(&qobj->queue_cnt, 0);
@@ -438,7 +471,6 @@ struct se_session *transport_init_session(void)
 	}
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
-	atomic_set(&se_sess->mib_ref_count, 0);
 
 	return se_sess;
 }
@@ -547,12 +579,6 @@ void transport_deregister_session(struct se_session *se_sess)
 		transport_free_session(se_sess);
 		return;
 	}
-	/*
-	 * Wait for possible reference in drivers/target/target_core_mib.c:
-	 * scsi_att_intr_port_seq_show()
-	 */
-	while (atomic_read(&se_sess->mib_ref_count) != 0)
-		cpu_relax();
 
 	spin_lock_bh(&se_tpg->session_lock);
 	list_del(&se_sess->sess_list);
@@ -575,7 +601,6 @@ void transport_deregister_session(struct se_session *se_sess)
 				spin_unlock_bh(&se_tpg->acl_node_lock);
 
 				core_tpg_wait_for_nacl_pr_ref(se_nacl);
-				core_tpg_wait_for_mib_ref(se_nacl);
 				core_free_device_list_for_node(se_nacl, se_tpg);
 				TPG_TFO(se_tpg)->tpg_release_fabric_acl(se_tpg,
 						se_nacl);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 4cb4522..0f1b0d7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -201,6 +201,21 @@ typedef enum {
 	SAM_TASK_ATTR_EMULATED
 } t10_task_attr_index_t;
 
+/*
+ * Used for target SCSI statistics
+ */
+typedef enum {
+	SCSI_INST_INDEX,
+	SCSI_DEVICE_INDEX,
+	SCSI_AUTH_INTR_INDEX,
+	SCSI_INDEX_TYPE_MAX
+} scsi_index_t;
+
+struct scsi_index_table {
+	spinlock_t	lock;
+	u32		scsi_mib_index[SCSI_INDEX_TYPE_MAX];
+} ____cacheline_aligned;
+
 struct se_cmd;
 
 struct t10_alua {
@@ -584,8 +599,6 @@ struct se_node_acl {
 	spinlock_t		stats_lock;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		acl_pr_ref_count;
-	/* Used for MIB access */
-	atomic_t		mib_ref_count;
 	struct se_dev_entry	*device_list;
 	struct se_session	*nacl_sess;
 	struct se_portal_group *se_tpg;
@@ -601,8 +614,6 @@ struct se_node_acl {
 } ____cacheline_aligned;
 
 struct se_session {
-	/* Used for MIB access */
-	atomic_t		mib_ref_count;
 	u64			sess_bin_isid;
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
@@ -812,7 +823,6 @@ struct se_hba {
 	/* Virtual iSCSI devices attached. */
 	u32			dev_count;
 	u32			hba_index;
-	atomic_t		dev_mib_access_count;
 	atomic_t		load_balance_queue;
 	atomic_t		left_queue_depth;
 	/* Maximum queue depth the HBA can handle. */
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 66f44e5..2469405 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -111,6 +111,8 @@ struct se_subsystem_api;
 
 extern int init_se_global(void);
 extern void release_se_global(void);
+extern void init_scsi_index_table(void);
+extern u32 scsi_get_new_index(scsi_index_t);
 extern void transport_init_queue_obj(struct se_queue_obj *);
 extern int transport_subsystem_check_init(void);
 extern int transport_subsystem_register(struct se_subsystem_api *);
-- 
1.7.4

