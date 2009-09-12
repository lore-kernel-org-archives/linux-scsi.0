From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC PATCH 5/19] Target_Core_Mod HBA core infrastructure
Date: Fri, 11 Sep 2009 18:56:08 -0700
Message-ID: <1252720568.2067.206.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n23a.bullet.mail.mud.yahoo.com ([68.142.207.189]:43530 "HELO
	n23a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757275AbZILCCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 22:02:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>

[RFC PATCH 5/19] Target_Core_Mod HBA core infrastructure

This patch adds the core se_hba_t functionality that is used internally by
target_core_mod to group the same subsystem storage objects types until a single
/sys/kernel/config/target/core/$HBA directory.  The HBA code supports boths
physical storage objects (from Linux/SCSI) and virtual storage objects (from Linux/BLOCK,
Linux/VFS, RAMDISK)

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
new file mode 100644
index 0000000..59c9289
--- /dev/null
+++ b/drivers/target/target_core_hba.c
@@ -0,0 +1,200 @@
+/*******************************************************************************
+ * Filename:  target_core_hba.c
+ *
+ * This file copntains the iSCSI HBA Transport related functions.
+ *
+ * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
+ * Copyright (c) 2005, 2006, 2007 SBE, Inc.
+ * Copyright (c) 2007-2009 Rising Tide Software, Inc.
+ * Copyright (c) 2008-2009 Linux-iSCSI.org
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
+
+#define TARGET_CORE_HBA_C
+
+#include <linux/net.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/smp_lock.h>
+#include <linux/in.h>
+#include <net/sock.h>
+#include <net/tcp.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_device.h>
+#include <target/target_core_device.h>
+#include <target/target_core_hba.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_plugin.h>
+#include <target/target_core_seobj.h>
+
+#undef TARGET_CORE_HBA_C
+
+int core_get_hba(se_hba_t *hba)
+{
+	return ((down_interruptible(&hba->hba_access_sem) != 0) ? -1 : 0);
+}
+
+se_hba_t *core_alloc_hba(int hba_type)
+{
+	se_hba_t *hba;
+
+	hba = kmem_cache_zalloc(se_hba_cache, GFP_KERNEL);
+	if (!(hba)) {
+		printk(KERN_ERR "Unable to allocate se_hba_t\n");
+		return NULL;
+	}
+
+	hba->hba_status |= HBA_STATUS_FREE;
+	hba->type = hba_type;
+	INIT_LIST_HEAD(&hba->hba_dev_list);
+	spin_lock_init(&hba->device_lock);
+	spin_lock_init(&hba->hba_queue_lock);
+	init_MUTEX(&hba->hba_access_sem);
+#ifdef SNMP_SUPPORT
+	hba->hba_index = scsi_get_new_index(SCSI_INST_INDEX);
+#endif
+
+	return hba;
+}
+EXPORT_SYMBOL(core_alloc_hba);
+
+void core_put_hba(se_hba_t *hba)
+{
+	up(&hba->hba_access_sem);
+}
+EXPORT_SYMBOL(core_put_hba);
+
+/*	se_core_add_hba():
+ *
+ *
+ */
+int se_core_add_hba(
+	se_hba_t *hba,
+	u32 plugin_dep_id)
+{
+	se_subsystem_api_t *t;
+	int ret = 0;
+
+	if (hba->hba_status & HBA_STATUS_ACTIVE)
+		return -EEXIST;
+
+	atomic_set(&hba->max_queue_depth, 0);
+	atomic_set(&hba->left_queue_depth, 0);
+
+	t = (se_subsystem_api_t *)plugin_get_obj(PLUGIN_TYPE_TRANSPORT,
+				hba->type, &ret);
+	if (!(t))
+		return -EINVAL;
+
+	ret = t->attach_hba(hba, plugin_dep_id);
+	if (ret < 0)
+		return ret;
+
+	hba->hba_status &= ~HBA_STATUS_FREE;
+	hba->hba_status |= HBA_STATUS_ACTIVE;
+
+	spin_lock(&se_global->hba_lock);
+	hba->hba_id = se_global->g_hba_id_counter++;
+	list_add_tail(&hba->hba_list, &se_global->g_hba_list);
+	spin_unlock(&se_global->hba_lock);
+
+	printk(KERN_INFO "CORE_HBA[%d] - Attached HBA to Generic Target"
+			" Core\n", hba->hba_id);
+
+	return 0;
+}
+EXPORT_SYMBOL(se_core_add_hba);
+
+static int se_core_shutdown_hba(
+	se_hba_t *hba)
+{
+	int ret = 0;
+	se_subsystem_api_t *t;
+
+	t = (se_subsystem_api_t *)plugin_get_obj(PLUGIN_TYPE_TRANSPORT,
+				hba->type, &ret);
+	if (!(t))
+		return ret;
+
+	if (t->detach_hba(hba) < 0)
+		return -1;
+
+	return 0;
+}
+
+/*	se_core_del_hba():
+ *
+ *
+ */
+int se_core_del_hba(
+	se_hba_t *hba)
+{
+	se_device_t *dev, *dev_tmp;
+
+	if (!(hba->hba_status & HBA_STATUS_ACTIVE)) {
+		printk(KERN_ERR "HBA ID: %d Status: INACTIVE, ignoring"
+			" delhbafromtarget request\n", hba->hba_id);
+		return -EINVAL;
+	}
+
+	/*
+	 * Do not allow the se_hba_t to be released if references exist to
+	 * from se_device_t->se_lun_t.
+	 */
+	if (se_check_devices_access(hba) < 0) {
+		printk(KERN_ERR "CORE_HBA[%u] - **ERROR** - Unable to release"
+			" HBA with active LUNs\n", hba->hba_id);
+		return -EINVAL;
+	}
+
+	spin_lock(&hba->device_lock);
+	list_for_each_entry_safe(dev, dev_tmp, &hba->hba_dev_list, dev_list) {
+
+		se_clear_dev_ports(dev);
+		spin_unlock(&hba->device_lock);
+
+		se_release_device_for_hba(dev);
+
+		spin_lock(&hba->device_lock);
+	}
+	spin_unlock(&hba->device_lock);
+
+	se_core_shutdown_hba(hba);
+
+	spin_lock(&se_global->hba_lock);
+	list_del(&hba->hba_list);
+	spin_unlock(&se_global->hba_lock);
+
+	hba->type = 0;
+	hba->transport = NULL;
+	hba->hba_status &= ~HBA_STATUS_ACTIVE;
+	hba->hba_status |= HBA_STATUS_FREE;
+
+	printk(KERN_INFO "CORE_HBA[%d] - Detached HBA from Generic Target"
+			" Core\n", hba->hba_id);
+
+	kmem_cache_free(se_hba_cache, hba);
+	return 0;
+}
+EXPORT_SYMBOL(se_core_del_hba);
diff --git a/include/target/target_core_hba.h b/include/target/target_core_hba.h
new file mode 100644
index 0000000..8a14512
--- /dev/null
+++ b/include/target/target_core_hba.h
@@ -0,0 +1,43 @@
+/*******************************************************************************
+ * Filename:  target_core_hba.h
+ *
+ * This file contains the iSCSI HBA Transport related definitions.
+ *
+ * Copyright (c) 2003-2004 PyX Technologies, Inc.
+ * Copyright (c) 2005, 2006, 2007 SBE, Inc.
+ * Copyright (c) 2007-2009 Rising Tide Software, Inc.
+ * Copyright (c) 2008-2009 Linux-iSCSI.org
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
+
+#ifndef TARGET_CORE_HBA_H
+#define TARGET_CORE_HBA_H
+
+extern se_global_t *se_global;
+
+extern struct kmem_cache *se_hba_cache;
+
+extern int core_get_hba(struct se_hba_s *);
+extern se_hba_t *core_alloc_hba(int);
+extern void core_put_hba(struct se_hba_s *);
+extern int se_core_add_hba(struct se_hba_s *, u32);
+extern int se_core_del_hba(struct se_hba_s *);
+
+#endif /* TARGET_CORE_HBA_H */



