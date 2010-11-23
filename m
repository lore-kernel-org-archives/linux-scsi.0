From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/8] target: simplify hba allocation and freeing
Date: Tue, 23 Nov 2010 17:30:57 -0500
Message-ID: <20101123223110.170620880@bombadil.infradead.org>
References: <20101123223053.574330460@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50175 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0KWWbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 17:31:10 -0500
Content-Disposition: inline; filename=lio-simplify-core_alloc_hba
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Merge se_core_add_hba into core_alloc_hba to simplify life for the
callers.  To make this happen it gains a new hba_flags variable.
Also simplify se_core_del_hba and rename it to core_delete_hba to
match the allocation function.

The allocation simplification also allows to remove the hba_flags
field in struct se_hba as we will not never expose half-initialized
hba structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_configfs.c
===================================================================
--- lio-core.orig/drivers/target/target_core_configfs.c	2010-11-23 22:34:07.952253878 +0100
+++ lio-core/drivers/target/target_core_configfs.c	2010-11-23 22:34:08.600253040 +0100
@@ -3150,24 +3150,16 @@ static struct config_group *target_core_
 	if (transport_subsystem_check_init() < 0)
 		return ERR_PTR(-EINVAL);
 
-	hba = core_alloc_hba();
-	if (!(hba))
-		return ERR_PTR(-EINVAL);
-
-	ret = se_core_add_hba(hba, se_plugin_str, (u32)plugin_dep_id);
-	if (ret < 0)
-		goto out;
+	hba = core_alloc_hba(se_plugin_str, plugin_dep_id, 0);
+	if (IS_ERR(hba))
+		return ERR_CAST(hba);
 
 	config_group_init_type_name(&hba->hba_group, name,
 			&target_core_hba_cit);
 
 	return &hba->hba_group;
-out:
-	kfree(hba);
-	return ERR_PTR(ret);
 }
 
-
 static void target_core_call_delhbafromtarget(
 	struct config_group *group,
 	struct config_item *item)
@@ -3175,7 +3167,7 @@ static void target_core_call_delhbafromt
 	struct se_hba *hba = item_to_hba(item);
 
 	config_item_put(item);
-	se_core_del_hba(hba);
+	core_delete_hba(hba);
 }
 
 static struct configfs_group_operations target_core_group_ops = {
Index: lio-core/drivers/target/target_core_device.c
===================================================================
--- lio-core.orig/drivers/target/target_core_device.c	2010-11-23 22:34:07.953253948 +0100
+++ lio-core/drivers/target/target_core_device.c	2010-11-23 22:34:08.601253390 +0100
@@ -1611,17 +1611,9 @@ int core_dev_setup_virtual_lun0(void)
 	char buf[16];
 	int ret;
 
-	hba = core_alloc_hba();
-	if (!(hba))
-		return -ENOMEM;
-
-	hba->hba_flags |= HBA_FLAGS_INTERNAL_USE;
-	ret = se_core_add_hba(hba, "rd_dr", 0);
-	if (ret < 0) {
-		printk("se_core_add_hba() with %d\n", ret);
-		kfree(hba);
-		return ret;
-	}
+	hba = core_alloc_hba("rd_dr", 0, HBA_FLAGS_INTERNAL_USE);
+	if (IS_ERR(hba))
+		return PTR_ERR(hba);
 
 	se_global->g_lun0_hba = hba;
 	t = hba->transport;
@@ -1675,7 +1667,7 @@ out:
 	se_global->g_lun0_su_dev = NULL;
 	kfree(se_dev);
 	if (se_global->g_lun0_hba) {
-		se_core_del_hba(se_global->g_lun0_hba);
+		core_delete_hba(se_global->g_lun0_hba);
 		se_global->g_lun0_hba = NULL;
 	}
 	return ret;
@@ -1694,5 +1686,5 @@ void core_dev_release_virtual_lun0(void)
 		se_free_virtual_device(se_global->g_lun0_dev, hba);
 
 	kfree(su_dev);
-	se_core_del_hba(hba);
+	core_delete_hba(hba);
 }
Index: lio-core/drivers/target/target_core_hba.c
===================================================================
--- lio-core.orig/drivers/target/target_core_hba.c	2010-11-23 22:34:07.955252830 +0100
+++ lio-core/drivers/target/target_core_hba.c	2010-11-23 22:36:42.645253529 +0100
@@ -44,47 +44,35 @@
 
 #include "target_core_hba.h"
 
-struct se_hba *core_alloc_hba(void)
+struct se_hba *
+core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 {
+	struct se_subsystem_api *t;
 	struct se_hba *hba;
+	int ret = 0;
 
 	hba = kmalloc(sizeof(*hba), GFP_KERNEL);
 	if (!hba) {
 		printk(KERN_ERR "Unable to allocate struct se_hba\n");
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
-	hba->hba_status |= HBA_STATUS_FREE;
 	INIT_LIST_HEAD(&hba->hba_dev_list);
 	spin_lock_init(&hba->device_lock);
 	spin_lock_init(&hba->hba_queue_lock);
 	mutex_init(&hba->hba_access_mutex);
-	hba->hba_index = scsi_get_new_index(SCSI_INST_INDEX);
 
-	return hba;
-}
-
-/*	se_core_add_hba():
- *
- *
- */
-int se_core_add_hba(
-	struct se_hba *hba,
-	const char *plugin_name,
-	u32 plugin_dep_id)
-{
-	struct se_subsystem_api *t;
-	int ret = 0;
-
-	if (hba->hba_status & HBA_STATUS_ACTIVE)
-		return -EEXIST;
+	hba->hba_index = scsi_get_new_index(SCSI_INST_INDEX);
+	hba->hba_flags |= hba_flags;
 
 	atomic_set(&hba->max_queue_depth, 0);
 	atomic_set(&hba->left_queue_depth, 0);
 
 	t = transport_core_get_sub_by_name(plugin_name);
-	if (!(t))
-		return -EINVAL;
+	if (!t) {
+		ret = -EINVAL;
+		goto out_free_hba;
+	}
 
 	hba->transport = t;
 
@@ -98,23 +86,14 @@ int se_core_add_hba(
 		if (!try_module_get(t->owner)) {
 			printk(KERN_ERR "try_module_get() failed for %s\n",
 				t->owner->name);
-			hba->transport = NULL;
-			transport_core_put_sub(t);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_put_subsystem;
 		}
 	}
 
 	ret = t->attach_hba(hba, plugin_dep_id);
-	if (ret < 0) {
-		hba->transport = NULL;
-		if (t->owner)
-			module_put(t->owner);
-		transport_core_put_sub(t);
-		return ret;
-	}
-
-	hba->hba_status &= ~HBA_STATUS_FREE;
-	hba->hba_status |= HBA_STATUS_ACTIVE;
+	if (ret < 0)
+		goto out_module_put;
 
 	spin_lock(&se_global->hba_lock);
 	hba->hba_id = se_global->g_hba_id_counter++;
@@ -124,40 +103,24 @@ int se_core_add_hba(
 	printk(KERN_INFO "CORE_HBA[%d] - Attached HBA to Generic Target"
 			" Core\n", hba->hba_id);
 
-	return 0;
-}
-
-static int se_core_shutdown_hba(
-	struct se_hba *hba)
-{
-	struct se_subsystem_api *t = hba->transport;;
+	return hba;
 
-	if (t->detach_hba(hba) < 0)
-		return -1;
-	/*
-	 * Release TCM subsystem api struct module reference from struct se_hba
-	 */
+out_module_put:
 	if (t->owner)
 		module_put(t->owner);
-
-	return 0;
+out_put_subsystem:
+	hba->transport = NULL;
+	transport_core_put_sub(t);
+out_free_hba:
+	kfree(hba);
+	return ERR_PTR(ret);
 }
 
-/*	se_core_del_hba():
- *
- *
- */
-int se_core_del_hba(
-	struct se_hba *hba)
+int
+core_delete_hba(struct se_hba *hba)
 {
 	struct se_device *dev, *dev_tmp;
 
-	if (!(hba->hba_status & HBA_STATUS_ACTIVE)) {
-		printk(KERN_ERR "HBA ID: %d Status: INACTIVE, ignoring"
-			" delhbafromtarget request\n", hba->hba_id);
-		return -EINVAL;
-	}
-
 	spin_lock(&hba->device_lock);
 	list_for_each_entry_safe(dev, dev_tmp, &hba->hba_dev_list, dev_list) {
 
@@ -170,7 +133,10 @@ int se_core_del_hba(
 	}
 	spin_unlock(&hba->device_lock);
 
-	se_core_shutdown_hba(hba);
+	hba->transport->detach_hba(hba);
+	if (hba->transport->owner)
+		module_put(hba->transport->owner);
+
 	if (!(hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		transport_core_put_sub(hba->transport);
 
@@ -179,8 +145,6 @@ int se_core_del_hba(
 	spin_unlock(&se_global->hba_lock);
 
 	hba->transport = NULL;
-	hba->hba_status &= ~HBA_STATUS_ACTIVE;
-	hba->hba_status |= HBA_STATUS_FREE;
 
 	printk(KERN_INFO "CORE_HBA[%d] - Detached HBA from Generic Target"
 			" Core\n", hba->hba_id);
Index: lio-core/drivers/target/target_core_hba.h
===================================================================
--- lio-core.orig/drivers/target/target_core_hba.h	2010-11-23 22:34:07.969252900 +0100
+++ lio-core/drivers/target/target_core_hba.h	2010-11-23 22:34:08.612253320 +0100
@@ -1,8 +1,7 @@
 #ifndef TARGET_CORE_HBA_H
 #define TARGET_CORE_HBA_H
 
-extern struct se_hba *core_alloc_hba(void);
-extern int se_core_add_hba(struct se_hba *, const char *, u32);
-extern int se_core_del_hba(struct se_hba *);
+extern struct se_hba *core_alloc_hba(const char *, u32, u32);
+extern int core_delete_hba(struct se_hba *);
 
 #endif /* TARGET_CORE_HBA_H */
Index: lio-core/drivers/target/target_core_mib.c
===================================================================
--- lio-core.orig/drivers/target/target_core_mib.c	2010-11-23 22:33:25.053253040 +0100
+++ lio-core/drivers/target/target_core_mib.c	2010-11-23 22:34:08.617253390 +0100
@@ -123,9 +123,6 @@ static int scsi_inst_seq_show(struct seq
 	if (list_is_first(&hba->hba_list, &se_global->g_hba_list))
 		seq_puts(seq, "inst sw_indx\n");
 
-	if (!(hba->hba_status & HBA_STATUS_ACTIVE))
-		return 0;
-
 	seq_printf(seq, "%u %u\n", hba->hba_index, SCSI_INST_SW_INDEX);
 	seq_printf(seq, "plugin: %s version: %s\n",
 			hba->transport->name, TARGET_CORE_VERSION);
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2010-11-23 22:33:25.120252691 +0100
+++ lio-core/include/target/target_core_base.h	2010-11-23 22:34:08.622252761 +0100
@@ -62,14 +62,6 @@ enum hba_flags_table {
 	HBA_FLAGS_PSCSI_MODE	= 0x02,
 };
 
-/* struct se_hba->hba_status and iscsi_tpg_hba->thba_status */
-enum hba_status_table {
-	HBA_STATUS_FREE		= 0x01,
-	HBA_STATUS_ACTIVE	= 0x02,
-	HBA_STATUS_INACTIVE	= 0x04,
-	HBA_STATUS_SHUTDOWN	= 0x08,
-};
-
 /* struct se_lun->lun_status */
 enum transport_lun_status_table {
 	TRANSPORT_LUN_STATUS_FREE = 0,
@@ -865,8 +857,6 @@ struct se_device {
 
 struct se_hba {
 	u16			hba_tpgt;
-	/* See hba_status_table */
-	u32			hba_status;
 	u32			hba_id;
 	/* See hba_flags_table */
 	u32			hba_flags;
Index: lio-core/drivers/target/target_core_file.c
===================================================================
--- lio-core.orig/drivers/target/target_core_file.c	2010-11-23 22:33:25.059253040 +0100
+++ lio-core/drivers/target/target_core_file.c	2010-11-23 22:34:08.624253459 +0100
@@ -88,27 +88,15 @@ static int fd_attach_hba(struct se_hba *
 	return 0;
 }
 
-/*	fd_detach_hba(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static int fd_detach_hba(struct se_hba *hba)
+static void fd_detach_hba(struct se_hba *hba)
 {
-	struct fd_host *fd_host;
-
-	if (!hba->hba_ptr) {
-		printk(KERN_ERR "hba->hba_ptr is NULL!\n");
-		return -1;
-	}
-	fd_host = (struct fd_host *) hba->hba_ptr;
+	struct fd_host *fd_host = hba->hba_ptr;
 
 	printk(KERN_INFO "CORE_HBA[%d] - Detached FILEIO HBA: %u from Generic"
 		" Target Core\n", hba->hba_id, fd_host->fd_host_id);
 
 	kfree(fd_host);
 	hba->hba_ptr = NULL;
-
-	return 0;
 }
 
 static void *fd_allocate_virtdevice(struct se_hba *hba, const char *name)
Index: lio-core/drivers/target/target_core_iblock.c
===================================================================
--- lio-core.orig/drivers/target/target_core_iblock.c	2010-11-23 22:33:25.073253110 +0100
+++ lio-core/drivers/target/target_core_iblock.c	2010-11-23 22:34:08.629253809 +0100
@@ -90,27 +90,15 @@ static int iblock_attach_hba(struct se_h
 	return 0;
 }
 
-/*	iblock_detach_hba(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static int iblock_detach_hba(struct se_hba *hba)
+static void iblock_detach_hba(struct se_hba *hba)
 {
-	struct iblock_hba *ib_host;
-
-	if (!hba->hba_ptr) {
-		printk(KERN_ERR "hba->hba_ptr is NULL!\n");
-		return -1;
-	}
-	ib_host = hba->hba_ptr;
+	struct iblock_hba *ib_host = hba->hba_ptr;
 
 	printk(KERN_INFO "CORE_HBA[%d] - Detached iBlock HBA: %u from Generic"
 		" Target Core\n", hba->hba_id, ib_host->iblock_host_id);
 
 	kfree(ib_host);
 	hba->hba_ptr = NULL;
-
-	return 0;
 }
 
 static void *iblock_allocate_virtdevice(struct se_hba *hba, const char *name)
Index: lio-core/drivers/target/target_core_pscsi.c
===================================================================
--- lio-core.orig/drivers/target/target_core_pscsi.c	2010-11-23 22:33:25.086253250 +0100
+++ lio-core/drivers/target/target_core_pscsi.c	2010-11-23 22:34:08.634252901 +0100
@@ -107,13 +107,9 @@ static int pscsi_attach_hba(struct se_hb
 	return 0;
 }
 
-/*	pscsi_detach_hba(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static int pscsi_detach_hba(struct se_hba *hba)
+static void pscsi_detach_hba(struct se_hba *hba)
 {
-	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt *)hba->hba_ptr;
+	struct pscsi_hba_virt *phv = hba->hba_ptr;
 	struct Scsi_Host *scsi_host = phv->phv_lld_host;
 
 	if (scsi_host) {
@@ -129,8 +125,6 @@ static int pscsi_detach_hba(struct se_hb
 
 	kfree(phv);
 	hba->hba_ptr = NULL;
-
-	return 0;
 }
 
 static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
Index: lio-core/drivers/target/target_core_rd.c
===================================================================
--- lio-core.orig/drivers/target/target_core_rd.c	2010-11-23 22:33:25.092252621 +0100
+++ lio-core/drivers/target/target_core_rd.c	2010-11-23 22:34:08.640253390 +0100
@@ -82,28 +82,15 @@ static int rd_attach_hba(struct se_hba *
 	return 0;
 }
 
-/*	rd_detach_hba(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static int rd_detach_hba(struct se_hba *hba)
+static void rd_detach_hba(struct se_hba *hba)
 {
-	struct rd_host *rd_host;
-
-	if (!hba->hba_ptr) {
-		printk(KERN_ERR "hba->hba_ptr is NULL!\n");
-		return -1;
-	}
-
-	rd_host = hba->hba_ptr;
+	struct rd_host *rd_host = hba->hba_ptr;
 
 	printk(KERN_INFO "CORE_HBA[%d] - Detached Ramdisk HBA: %u from"
 		" Generic Target Core\n", hba->hba_id, rd_host->rd_host_id);
 
 	kfree(rd_host);
 	hba->hba_ptr = NULL;
-
-	return 0;
 }
 
 /*	rd_release_device_space():
Index: lio-core/drivers/target/target_core_stgt.c
===================================================================
--- lio-core.orig/drivers/target/target_core_stgt.c	2010-11-23 22:33:25.113252971 +0100
+++ lio-core/drivers/target/target_core_stgt.c	2010-11-23 22:34:08.646253040 +0100
@@ -215,11 +215,7 @@ static int stgt_lld_remove(struct device
 	return 0;
 }
 
-/*	stgt_detach_hba(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static int stgt_detach_hba(struct se_hba *hba)
+static void stgt_detach_hba(struct se_hba *hba)
 {
 	struct Scsi_Host *scsi_host = hba->hba_ptr;
 	struct stgt_hba *stgt_hba = *(struct stgt_hba **)shost_priv(scsi_host);
@@ -231,8 +227,6 @@ static int stgt_detach_hba(struct se_hba
 
 	device_unregister(&stgt_hba->dev);
 	hba->hba_ptr = NULL;
-
-	return 0;
 }
 
 static void *stgt_allocate_virtdevice(struct se_hba *hba, const char *name)
Index: lio-core/include/target/target_core_transport.h
===================================================================
--- lio-core.orig/include/target/target_core_transport.h	2010-11-23 22:33:25.142253390 +0100
+++ lio-core/include/target/target_core_transport.h	2010-11-23 22:34:08.653253040 +0100
@@ -264,7 +264,7 @@ struct se_subsystem_api {
 	/*
 	 * detach_hba():
 	 */
-	int (*detach_hba)(struct se_hba *);
+	void (*detach_hba)(struct se_hba *);
 	/*
 	 * pmode_hba(): Used for TCM/pSCSI subsystem plugin HBA ->
 	 *		Linux/SCSI struct Scsi_Host passthrough

