From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] [Target_Core_Mod/ALUA]: Add t10_alua_lu_gp_member_t
	usage for Logical Unit Groups
Date: Wed, 11 Feb 2009 22:35:59 -0800
Message-ID: <1234420559.12375.516.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:20348 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757587AbZBLGia (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2009 01:38:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@lst.de>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>

>From 5574e3e0240e1bf5e54529bfeca51aec5025dd13 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 11 Feb 2009 20:13:07 -0800
Subject: [PATCH 1/2] [Target_Core_Mod/ALUA]: Add t10_alua_lu_gp_member_t usage for Logical Unit Groups

This patch defines t10_alua_lu_gp_member_t and changes se_device_t->dev_alua_lu_gp
to a pointer at se_device_t->dev_alua_lu_gp_mem that is allocated/released by
se_device_t.  This allows the shutdown logic for se_device_t and ALUA Logical Unit
associated for said se_device_t much cleaner and prevents a potential OOPs with the
existing code.

This patch also adds the following logic to ALUA logical unit groups:

*) The deletion of logical unit groups with 'rmdir core/alua/lu_gps/$LU_GROUP' will cause
   any associated se_device_t to be put back into core/alua/lu_gps/default_lu_gp
*) Emulated INQUIRY EVPD Logical Unit Identifier will also return a value if there
   is an association to default_lu_gp or a user defined logical unit group.
   Completely releasing a given associated via echo NULL > core/$HBA/$DEV/alua_lu_gp
   will return no EVPD Logical Unit Identifier.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_alua.c      |  185 ++++++++++++++++++++----------
 drivers/lio-core/target_core_alua.h      |   11 +-
 drivers/lio-core/target_core_base.h      |   27 ++++-
 drivers/lio-core/target_core_configfs.c  |   85 ++++++++++----
 drivers/lio-core/target_core_device.c    |    3 +-
 drivers/lio-core/target_core_transport.c |   41 ++++++--
 6 files changed, 244 insertions(+), 108 deletions(-)

diff --git a/drivers/lio-core/target_core_alua.c b/drivers/lio-core/target_core_alua.c
index 722be1a..86a1546 100644
--- a/drivers/lio-core/target_core_alua.c
+++ b/drivers/lio-core/target_core_alua.c
@@ -46,7 +46,9 @@
 extern se_global_t *se_global;
 
 extern struct kmem_cache *t10_alua_lu_gp_cache;
+extern struct kmem_cache *t10_alua_lu_gp_mem_cache;
 extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
+extern struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
 
 /*
  * REPORT_TARGET_PORT_GROUPS
@@ -138,8 +140,8 @@ extern t10_alua_lu_gp_t *core_alua_allocate_lu_gp (const char *name)
 		return(NULL);
 	}
 	INIT_LIST_HEAD(&lu_gp->lu_gp_list);
-	INIT_LIST_HEAD(&lu_gp->lu_gp_ref_list);
-	spin_lock_init(&lu_gp->lu_gp_ref_lock);
+	INIT_LIST_HEAD(&lu_gp->lu_gp_mem_list);
+	spin_lock_init(&lu_gp->lu_gp_lock);
 	lu_gp->lu_gp_alua_access_state = ALUA_ACCESS_STATE_ACTIVE_OPTMIZED;
 
 	spin_lock(&se_global->lu_gps_lock);
@@ -163,9 +165,27 @@ again:
 	return(lu_gp);
 }
 
+extern t10_alua_lu_gp_member_t *core_alua_allocate_lu_gp_mem (
+	se_device_t *dev)
+{
+	t10_alua_lu_gp_member_t *lu_gp_mem;
+
+	if (!(lu_gp_mem = kmem_cache_zalloc(t10_alua_lu_gp_mem_cache, GFP_KERNEL))) {
+		printk(KERN_ERR "Unable to allocate t10_alua_lu_gp_member_t\n");
+		return(ERR_PTR(-ENOMEM));
+	}
+	INIT_LIST_HEAD(&lu_gp_mem->lu_gp_mem_list);
+	spin_lock_init(&lu_gp_mem->lu_gp_mem_lock);
+
+	lu_gp_mem->lu_gp_mem_dev = dev;
+	dev->dev_alua_lu_gp_mem = lu_gp_mem;
+
+	return(lu_gp_mem);
+}
+
 extern void core_alua_free_lu_gp (t10_alua_lu_gp_t *lu_gp)
 {
-	se_device_t *dev, *dev_tmp;
+	t10_alua_lu_gp_member_t *lu_gp_mem, *lu_gp_mem_tmp;
 	/*
 	 * Once we have reached this point, config_item_put() has
 	 * already been called from target_core_alua_drop_lu_gp().
@@ -175,28 +195,85 @@ extern void core_alua_free_lu_gp (t10_alua_lu_gp_t *lu_gp)
 	 * t10_alua_lu_gp_t.
 	 */
 	spin_lock(&se_global->lu_gps_lock);
+	atomic_set(&lu_gp->lu_gp_shutdown, 1);
 	list_del(&lu_gp->lu_gp_list);
 	se_global->alua_lu_gps_count--;
 	spin_unlock(&se_global->lu_gps_lock);
+	/*
+	 * Allow a t10_alua_lu_gp_t * referenced by core_alua_get_lu_gp_by_name()
+	 * in target_core_configfs.c:target_core_store_alua_lu_gp() to be released
+	 * with core_alua_put_lu_gp_from_name()
+	 */
+	while(atomic_read(&lu_gp->lu_gp_ref_cnt))
+		msleep(10);
+	/*
+	 * Release reference to t10_alua_lu_gp_t * from all associated
+	 * se_device_t.
+	 */
+	spin_lock(&lu_gp->lu_gp_lock);
+	list_for_each_entry_safe(lu_gp_mem, lu_gp_mem_tmp,
+				&lu_gp->lu_gp_mem_list, lu_gp_mem_list) {
+		if (lu_gp_mem->lu_gp_assoc) {
+			list_del(&lu_gp_mem->lu_gp_mem_list);
+			lu_gp->lu_gp_members--;
+			lu_gp_mem->lu_gp_assoc = 0;
+		}
+		spin_unlock(&lu_gp->lu_gp_lock);
+		/*
+		 *
+		 * lu_gp_mem is assoicated with a single se_device_t->dev_alua_lu_gp_mem,
+		 * and is released when se_device_t is released via
+		 * core_alua_free_lu_gp_mem().
+		 *
+		 * If the passed lu_gp does NOT match the default_lu_gp, assume we
+		 * want to re-assocate a given lu_gp_mem with default_lu_gp.
+		 */
+		spin_lock(&lu_gp_mem->lu_gp_mem_lock);
+		if (lu_gp != se_global->default_lu_gp)
+			__core_alua_attach_lu_gp_mem(lu_gp_mem, se_global->default_lu_gp);
+		else
+			lu_gp_mem->lu_gp = NULL;
+		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
+
+		spin_lock(&lu_gp->lu_gp_lock);
+	}
+	spin_unlock(&lu_gp->lu_gp_lock);
 
-	spin_lock(&lu_gp->lu_gp_ref_lock);
-	list_for_each_entry_safe(dev, dev_tmp, &lu_gp->lu_gp_ref_list, dev_lu_gp_list) {
-		list_del(&dev->dev_lu_gp_list);	
-		spin_unlock(&lu_gp->lu_gp_ref_lock);
+	kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
+	return;
+}
 
-		spin_lock(&dev->dev_alua_lock);
-		dev->dev_alua_lu_gp = NULL;
-		spin_unlock(&dev->dev_alua_lock);
-		
-		spin_lock(&lu_gp->lu_gp_ref_lock);
+extern void core_alua_free_lu_gp_mem (se_device_t *dev)
+{
+	se_subsystem_dev_t *su_dev = dev->se_sub_dev;
+	t10_alua_t *alua = T10_ALUA(su_dev);
+	t10_alua_lu_gp_t *lu_gp;
+	t10_alua_lu_gp_member_t *lu_gp_mem;
+
+	if (alua->alua_type != SPC3_ALUA_EMULATED)
+		return;
+
+	if (!(lu_gp_mem = dev->dev_alua_lu_gp_mem))
+		return;
+
+	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
+	if ((lu_gp = lu_gp_mem->lu_gp)) {
+		spin_lock(&lu_gp->lu_gp_lock);
+		if (lu_gp_mem->lu_gp_assoc) {
+			list_del(&lu_gp_mem->lu_gp_mem_list);
+			lu_gp->lu_gp_members--;
+			lu_gp_mem->lu_gp_assoc = 0;
+		}
+		spin_unlock(&lu_gp->lu_gp_lock);
+		lu_gp_mem->lu_gp = NULL;
 	}
-	spin_unlock(&lu_gp->lu_gp_ref_lock);
+	spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
-	kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
+	kmem_cache_free(t10_alua_lu_gp_mem_cache, lu_gp_mem);
 	return;
 }
 
-extern t10_alua_lu_gp_t *core_alua_get_lu_gp_by_name (se_device_t *dev, const char *name)
+extern t10_alua_lu_gp_t *core_alua_get_lu_gp_by_name (const char *name)
 {
 	t10_alua_lu_gp_t *lu_gp;
 	struct config_item *ci;
@@ -215,66 +292,41 @@ extern t10_alua_lu_gp_t *core_alua_get_lu_gp_by_name (se_device_t *dev, const ch
 	return(NULL);
 }
 
-extern void core_alua_attach_lu_gp (se_device_t *dev, t10_alua_lu_gp_t *lu_gp)
+extern void core_alua_put_lu_gp_from_name (t10_alua_lu_gp_t *lu_gp)
 {
-	spin_lock(&lu_gp->lu_gp_ref_lock);
-	list_add_tail(&dev->dev_lu_gp_list, &lu_gp->lu_gp_ref_list);
-	lu_gp->lu_gp_members++;
-	spin_lock(&dev->dev_alua_lock);
-	dev->dev_alua_lu_gp = lu_gp;
-	spin_unlock(&dev->dev_alua_lock);
-	spin_unlock(&lu_gp->lu_gp_ref_lock);
+	spin_lock(&se_global->lu_gps_lock);
+	atomic_dec(&lu_gp->lu_gp_ref_cnt);
+	spin_unlock(&se_global->lu_gps_lock);
 
 	return;
 }
 
 /*
- * Called with se_device_t->dev_alua_lock held.
+ * Called with t10_alua_lu_gp_member_t->lu_gp_mem_lock
  */
-extern void __core_alua_put_lu_gp (se_device_t *dev, int clear)
+extern void __core_alua_attach_lu_gp_mem (t10_alua_lu_gp_member_t *lu_gp_mem, t10_alua_lu_gp_t *lu_gp)
 {
-	t10_alua_lu_gp_t *lu_gp;
-
-	if (!(lu_gp = dev->dev_alua_lu_gp)) 
-		return;
-
-	spin_lock(&lu_gp->lu_gp_ref_lock);
-	list_del(&dev->dev_lu_gp_list);
-	atomic_dec(&lu_gp->lu_gp_ref_cnt);
-	lu_gp->lu_gp_members--;
-	
-	if (!(clear)) {
-		spin_unlock(&lu_gp->lu_gp_ref_lock);
-		return;
-	}
-	dev->dev_alua_lu_gp = NULL;
-	spin_unlock(&lu_gp->lu_gp_ref_lock);
+	spin_lock(&lu_gp->lu_gp_lock);
+	lu_gp_mem->lu_gp = lu_gp;
+	lu_gp_mem->lu_gp_assoc = 1;
+	list_add_tail(&lu_gp_mem->lu_gp_mem_list, &lu_gp->lu_gp_mem_list);
+	lu_gp->lu_gp_members++;
+	spin_unlock(&lu_gp->lu_gp_lock);
 
 	return;
 }
 
-extern void core_alua_put_lu_gp (se_device_t *dev, int clear)
+/*
+ * Called with t10_alua_lu_gp_member_t->lu_gp_mem_lock
+ */
+extern void __core_alua_drop_lu_gp_mem (t10_alua_lu_gp_member_t *lu_gp_mem, t10_alua_lu_gp_t *lu_gp)
 {
-	t10_alua_lu_gp_t *lu_gp;
-
-	spin_lock(&dev->dev_alua_lock);
-	if (!(lu_gp = dev->dev_alua_lu_gp)) {
-		spin_unlock(&dev->dev_alua_lock);
-		return;
-	}
-	spin_lock(&lu_gp->lu_gp_ref_lock);
-	list_del(&dev->dev_lu_gp_list);
-	atomic_dec(&lu_gp->lu_gp_ref_cnt);
+	spin_lock(&lu_gp->lu_gp_lock);
+	list_del(&lu_gp_mem->lu_gp_mem_list);
+	lu_gp_mem->lu_gp = NULL;
+	lu_gp_mem->lu_gp_assoc = 0;
 	lu_gp->lu_gp_members--;
-
-	if (!(clear)) {
-		spin_unlock(&lu_gp->lu_gp_ref_lock);
-		spin_unlock(&dev->dev_alua_lock);
-		return;
-	}
-	dev->dev_alua_lu_gp = NULL;
-	spin_unlock(&lu_gp->lu_gp_ref_lock);
-	spin_unlock(&dev->dev_alua_lock);
+	spin_unlock(&lu_gp->lu_gp_lock);
 
 	return;
 }
@@ -513,6 +565,7 @@ extern int core_setup_alua (se_device_t *dev)
 {
 	se_subsystem_dev_t *su_dev = dev->se_sub_dev;
 	t10_alua_t *alua = T10_ALUA(su_dev);
+	t10_alua_lu_gp_member_t *lu_gp_mem;
 	/*
 	 * If this device is from Target_Core_Mod/pSCSI, use the ALUA logic
 	 * of the Underlying SCSI hardware.  In Linux/SCSI terms, this can
@@ -531,14 +584,20 @@ extern int core_setup_alua (se_device_t *dev)
 	 * use emulated ALUA.
 	 */
 	if (TRANSPORT(dev)->get_device_rev(dev) >= SCSI_3) {
-		alua->alua_type = SPC3_ALUA_EMULATED;
 		printk("%s: Enabling ALUA Emulation for SPC-3 device\n",
 				TRANSPORT(dev)->name);
 		/*
 		 * Assoicate this se_device_t with the default ALUA
 		 * LUN Group.
 		 */
-		core_alua_attach_lu_gp(dev, se_global->default_lu_gp);	
+		if (!(lu_gp_mem = core_alua_allocate_lu_gp_mem(dev)))
+			return(-1);
+		
+		alua->alua_type = SPC3_ALUA_EMULATED;
+		spin_lock(&lu_gp_mem->lu_gp_mem_lock);
+		__core_alua_attach_lu_gp_mem(lu_gp_mem, se_global->default_lu_gp);	
+		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
+
 		printk("%s: Adding to default ALUA LU Group: core/alua"
 			"/lu_gps/default_lu_gp\n", TRANSPORT(dev)->name);
 	} else {
diff --git a/drivers/lio-core/target_core_alua.h b/drivers/lio-core/target_core_alua.h
index 335847a..714692d 100644
--- a/drivers/lio-core/target_core_alua.h
+++ b/drivers/lio-core/target_core_alua.h
@@ -34,11 +34,14 @@
 
 extern int core_scsi3_emulate_report_target_port_groups (struct se_cmd_s *);
 extern struct t10_alua_lu_gp_s *core_alua_allocate_lu_gp (const char *);
+extern struct t10_alua_lu_gp_member_s *core_alua_allocate_lu_gp_mem (struct se_device_s *);
 extern void core_alua_free_lu_gp (struct t10_alua_lu_gp_s *);
-extern struct t10_alua_lu_gp_s *core_alua_get_lu_gp_by_name (struct se_device_s *, const char *);
-extern void core_alua_attach_lu_gp (struct se_device_s *, struct t10_alua_lu_gp_s *);
-extern void __core_alua_put_lu_gp (struct se_device_s *, int);
-extern void core_alua_put_lu_gp (struct se_device_s *, int);
+extern void core_alua_free_lu_gp_mem (struct se_device_s *);
+extern struct t10_alua_lu_gp_s *core_alua_get_lu_gp_by_name (const char *);
+extern void core_alua_put_lu_gp_from_name (struct t10_alua_lu_gp_s *);
+extern void __core_alua_attach_lu_gp_mem (struct t10_alua_lu_gp_member_s *, struct t10_alua_lu_gp_s *);
+extern void __core_alua_drop_lu_gp_mem (struct t10_alua_lu_gp_member_s *, struct t10_alua_lu_gp_s *);
+extern void core_alua_drop_lu_gp_dev (struct se_device_s *);
 extern struct t10_alua_tg_pt_gp_s *core_alua_allocate_tg_pt_gp (const char *);
 extern void core_alua_free_tg_pt_gp (struct t10_alua_tg_pt_gp_s *);
 extern struct t10_alua_tg_pt_gp_s *core_alua_get_tg_pt_gp_by_name (struct se_port_s *, const char *);
diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 08859a3..fc5dc29 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -50,7 +50,7 @@
 #define TRANSPORT_SENSE_SEGMENT_TOTAL       68 /* TRANSPORT_SENSE_SEGMENT_LENGTH + Padding */
 
 #define TRANSPORT_IQN_LEN			224 /* Currently same as ISCSI_IQN_LEN */
-
+#define LU_GROUP_NAME_BUF			256
 #define EVPD_TMP_BUF_SIZE			128 /* Used to parse EVPD into t10_evpd_t */
 
 /* used by PSCSI and iBlock Transport drivers */
@@ -193,13 +193,22 @@ typedef struct t10_alua_lu_gp_s {
 	u16	lu_gp_id;
 	int	lu_gp_alua_access_state;
 	u32	lu_gp_members;
+	atomic_t lu_gp_shutdown;
 	atomic_t lu_gp_ref_cnt;
-	spinlock_t lu_gp_ref_lock;
+	spinlock_t lu_gp_lock;
 	struct config_group lu_gp_group;
 	struct list_head lu_gp_list;
-	struct list_head lu_gp_ref_list;
+	struct list_head lu_gp_mem_list;
 } ____cacheline_aligned t10_alua_lu_gp_t;
 
+typedef struct t10_alua_lu_gp_member_s {
+	int lu_gp_assoc;
+	spinlock_t lu_gp_mem_lock;
+	t10_alua_lu_gp_t *lu_gp;
+	struct se_device_s *lu_gp_mem_dev;
+	struct list_head lu_gp_mem_list;
+} ____cacheline_aligned t10_alua_lu_gp_member_t;
+
 typedef struct t10_alua_tg_pt_gp_s {
 	u16	tg_pt_gp_id;
 	int	tg_pt_gp_alua_access_state;
@@ -211,6 +220,14 @@ typedef struct t10_alua_tg_pt_gp_s {
 	struct list_head tg_pt_gp_ref_list;
 } ____cacheline_aligned t10_alua_tg_pt_gp_t;
 
+typedef struct t10_alua_tg_pt_gp_member_s {
+	int tg_pt_gp_assoc;
+	spinlock_t tg_pt_gp_mem_lock;
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	struct se_port_s *tg_pt;
+	struct list_head tg_pt_gp_mem_list;
+} ____cacheline_aligned t10_alua_tg_pt_gp_member_t;
+
 typedef struct t10_evpd_s {
 	unsigned char device_identifier[INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN];
 	int protocol_identifier_set;
@@ -602,15 +619,13 @@ typedef struct se_device_s {
 	spinlock_t		execute_task_lock;
 	spinlock_t		state_task_lock;
 	spinlock_t		dev_reservation_lock;
-	spinlock_t		dev_alua_lock;
 	spinlock_t		dev_state_lock;
 	spinlock_t		dev_status_lock;
 	spinlock_t		dev_status_thr_lock;
 	spinlock_t		se_port_lock;
 	struct se_node_acl_s	*dev_reserved_node_acl; /* Used for legacy SPC-2 reservationsa */
-	struct t10_alua_lu_gp_s *dev_alua_lu_gp;	/* Used for ALUA Logical Unit Groups */
+	struct t10_alua_lu_gp_member_s *dev_alua_lu_gp_mem; /* Used for ALUA Logical Unit Group membership */
 	struct t10_pr_registration_s *dev_pr_res_holder; /* Used for SPC-3 Persistent Reservations */
-	struct list_head	dev_lu_gp_list;
 	struct list_head	dev_sep_list;
 	struct timer_list		dev_status_timer;
 	struct task_struct		*process_thread; /* Pointer to descriptor for processing thread */
diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 888522b..5b5f7a6 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -651,7 +651,7 @@ static ssize_t target_core_dev_wwn_store_attr_evpd_protocol_identifier (
 SE_DEV_WWN_ATTR(evpd_protocol_identifier, S_IRUGO | S_IWUSR);
 
 /*
- * Generic wrapper for dumping EVPD identifiers by assoication.
+ * Generic wrapper for dumping EVPD identifiers by association.
  */
 #define DEF_DEV_WWN_ASSOC_SHOW(_name, _assoc)					\
 static ssize_t target_core_dev_wwn_show_attr_##_name (				\
@@ -1252,18 +1252,27 @@ static ssize_t target_core_show_alua_lu_gp (void *p, char *page)
 	se_subsystem_dev_t *su_dev = (se_subsystem_dev_t *)p;
 	struct config_item *lu_ci;
 	t10_alua_lu_gp_t *lu_gp;
+	t10_alua_lu_gp_member_t *lu_gp_mem;
 	ssize_t len = 0;
 
 	if (!(dev = su_dev->se_dev_ptr)) 
 		return(-ENODEV);
 
-	spin_lock(&dev->dev_alua_lock);
-	if ((lu_gp = dev->dev_alua_lu_gp)) {
+	if (T10_ALUA(su_dev)->alua_type != SPC3_ALUA_EMULATED)
+		return(len);
+
+	if (!(lu_gp_mem = dev->dev_alua_lu_gp_mem)) {
+		printk(KERN_ERR "NULL se_device_t->dev_alua_lu_gp_mem pointer\n");
+		return(-EINVAL);
+	}
+
+	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
+	if ((lu_gp = lu_gp_mem->lu_gp)) {
 		lu_ci = &lu_gp->lu_gp_group.cg_item;
 		len += sprintf(page, "LU Group Alias: %s\nLU Group ID: %hu\n",
 			config_item_name(lu_ci), lu_gp->lu_gp_id);
 	}
-	spin_unlock(&dev->dev_alua_lock);	
+	spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
 	return(len);
 }
@@ -1273,8 +1282,9 @@ static ssize_t target_core_store_alua_lu_gp (void *p, const char *page, size_t c
 	se_device_t *dev;
 	se_subsystem_dev_t *su_dev = (se_subsystem_dev_t *)p;
 	se_hba_t *hba = su_dev->se_dev_hba;
-	t10_alua_lu_gp_t *lu_gp = NULL, *lu_gp_new;
-	unsigned char buf[256];
+	t10_alua_lu_gp_t *lu_gp = NULL, *lu_gp_new = NULL;
+	t10_alua_lu_gp_member_t *lu_gp_mem;
+	unsigned char buf[LU_GROUP_NAME_BUF];
 	int move = 0;
 
 	if (!(dev = su_dev->se_dev_ptr)) 
@@ -1286,16 +1296,38 @@ static ssize_t target_core_store_alua_lu_gp (void *p, const char *page, size_t c
 			config_item_name(&su_dev->se_dev_group.cg_item));
 		return(-EINVAL);
 	}
-	if (count > 256) {
+	if (count > LU_GROUP_NAME_BUF) {
 		printk(KERN_ERR "ALUA LU Group Alias too large!\n");
 		return(-EINVAL);
 	}
-	memset(buf, 0, 256);
+	memset(buf, 0, LU_GROUP_NAME_BUF);
 	memcpy(buf, page, count);
+	/*
+	 * Any ALUA logical unit alias besides "NULL" means we will be
+	 * making a new group association.
+	 */
+	if (strcmp(strstrip(buf), "NULL")) {
+		/*
+		 * core_alua_get_lu_gp_by_name() will increment reference to
+		 * t10_alua_lu_gp_t.  This reference is released with
+		 * core_alua_get_lu_gp_by_name below().
+		 */
+		if (!(lu_gp_new = core_alua_get_lu_gp_by_name(strstrip(buf))))
+			return(-ENODEV);
+	}
+	if (!(lu_gp_mem = dev->dev_alua_lu_gp_mem)) {
+		if (lu_gp_new)
+			core_alua_put_lu_gp_from_name(lu_gp_new);
+		printk(KERN_ERR "NULL se_device_t->dev_alua_lu_gp_mem pointer\n");
+		return(-EINVAL);
+	}
 
-	spin_lock(&dev->dev_alua_lock);
-	if ((lu_gp = dev->dev_alua_lu_gp)) {
-		if (!(strcmp(strstrip(buf), "NULL"))) {
+	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
+	if ((lu_gp = lu_gp_mem->lu_gp)) {
+		/*
+		 * Clearing an existing lu_gp association, and replacing with NULL
+		 */
+		if (!(lu_gp_new)) {
 			printk("Target_Core_ConfigFS: Releasing %s/%s from ALUA"
 				" LU Group: core/alua/lu_gps/%s, ID: %hu\n",  
 				config_item_name(&hba->hba_group.cg_item),
@@ -1303,22 +1335,22 @@ static ssize_t target_core_store_alua_lu_gp (void *p, const char *page, size_t c
 				config_item_name(&lu_gp->lu_gp_group.cg_item),
 				lu_gp->lu_gp_id);
 
-			__core_alua_put_lu_gp(dev, 1);
-			spin_unlock(&dev->dev_alua_lock);
+			__core_alua_drop_lu_gp_mem(lu_gp_mem, lu_gp);
+			spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
 			return(count);
 		}
-	}
-	spin_unlock(&dev->dev_alua_lock);
-
-	if (!(lu_gp_new = core_alua_get_lu_gp_by_name(dev, strstrip(buf))))
-		return(-ENODEV);
-
-	if (lu_gp) {
-		core_alua_put_lu_gp(dev, 0);
+		/*
+		 * Removing existing association of lu_gp_mem with lu_gp
+		 */
+		__core_alua_drop_lu_gp_mem(lu_gp_mem, lu_gp);
 		move = 1;
 	}
-	core_alua_attach_lu_gp(dev, lu_gp_new);
+	/*
+	 * Associate lu_gp_mem with lu_gp_new.
+	 */
+	__core_alua_attach_lu_gp_mem(lu_gp_mem, lu_gp_new);
+	spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
 	printk("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group:"
 		" core/alua/lu_gps/%s, ID: %hu\n",
@@ -1328,6 +1360,7 @@ static ssize_t target_core_store_alua_lu_gp (void *p, const char *page, size_t c
 		config_item_name(&lu_gp_new->lu_gp_group.cg_item),
 		lu_gp_new->lu_gp_id);
 
+	core_alua_put_lu_gp_from_name(lu_gp_new);
 	return(count);
 }
 
@@ -1434,13 +1467,15 @@ static ssize_t target_core_alua_lu_gp_show_attr_members (
 	se_device_t *dev;
 	se_hba_t *hba;
 	se_subsystem_dev_t *su_dev;
+	t10_alua_lu_gp_member_t *lu_gp_mem;
 	ssize_t len = 0, cur_len;
 	unsigned char buf[256];
 
 	memset(buf, 0, 256);
 
-	spin_lock(&lu_gp->lu_gp_ref_lock);
-	list_for_each_entry(dev, &lu_gp->lu_gp_ref_list, dev_lu_gp_list) {
+	spin_lock(&lu_gp->lu_gp_lock);
+	list_for_each_entry(lu_gp_mem, &lu_gp->lu_gp_mem_list, lu_gp_mem_list) {
+		dev = lu_gp_mem->lu_gp_mem_dev;
 		su_dev = dev->se_sub_dev;
 		hba = su_dev->se_dev_hba;
 
@@ -1457,7 +1492,7 @@ static ssize_t target_core_alua_lu_gp_show_attr_members (
 		memcpy(page+len, buf, cur_len);
 		len += cur_len;
 	}
-	spin_unlock(&lu_gp->lu_gp_ref_lock);
+	spin_unlock(&lu_gp->lu_gp_lock);
 
 	return(len);
 }
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index f7ad451..2c9566e 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -764,8 +764,7 @@ extern int se_free_virtual_device (se_device_t *dev, se_hba_t *hba)
 	se_clear_dev_ports(dev);
 	spin_unlock(&hba->device_lock);
 
-	core_alua_put_lu_gp(dev, 1);	
-	
+	core_alua_free_lu_gp_mem(dev);	
 	se_release_device_for_hba(dev);
 	
 	return(0);
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 82ccd3c..18c3693 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -210,7 +210,9 @@ struct kmem_cache *se_task_cache = NULL;
 struct kmem_cache *se_sess_cache = NULL;
 struct kmem_cache *t10_pr_reg_cache = NULL;
 struct kmem_cache *t10_alua_lu_gp_cache = NULL;
+struct kmem_cache *t10_alua_lu_gp_mem_cache = NULL;
 struct kmem_cache *t10_alua_tg_pt_gp_cache = NULL;
+struct kmem_cache *t10_alua_tg_pt_gp_mem_cache = NULL;
 
 EXPORT_SYMBOL(se_global);
 static int transport_generic_write_pending (se_cmd_t *);
@@ -292,12 +294,24 @@ extern int init_se_global (void)
 		printk(KERN_ERR "kmem_cache_create() for t10_alua_lu_gp_cache failed\n");
 		goto out;
 	}
+	if (!(t10_alua_lu_gp_mem_cache = kmem_cache_create("t10_alua_lu_gp_mem_cache",
+			sizeof(t10_alua_lu_gp_member_t), __alignof__(t10_alua_lu_gp_member_t),
+			0, NULL))) {
+		printk(KERN_ERR "kmem_cache_create() for t10_alua_lu_gp_mem_cache failed\n");
+		goto out;
+	}
 	if (!(t10_alua_tg_pt_gp_cache = kmem_cache_create("t10_alua_tg_pt_gp_cache",
 			sizeof(t10_alua_tg_pt_gp_t), __alignof__(t10_alua_tg_pt_gp_t),
 			0, NULL))) {
 		printk(KERN_ERR "kmem_cache_create() for t10_alua_tg_pt_gp_cache failed\n");
 		goto out;
 	}
+	if (!(t10_alua_tg_pt_gp_mem_cache = kmem_cache_create("t10_alua_tg_pt_gp_mem_cache",
+			sizeof(t10_alua_tg_pt_gp_member_t), __alignof__(t10_alua_tg_pt_gp_member_t),
+			0, NULL))) {
+		printk(KERN_ERR "kmem_cache_create() for t10_alua_tg_pt_gp_mem_t failed\n");
+		goto out;
+	}
 
         if (!(global->hba_list = kzalloc((sizeof(se_hba_t) *
 				TRANSPORT_MAX_GLOBAL_HBAS), GFP_KERNEL))) {
@@ -340,8 +354,12 @@ out:
 		kmem_cache_destroy(t10_pr_reg_cache);
 	if (t10_alua_lu_gp_cache)
 		kmem_cache_destroy(t10_alua_lu_gp_cache);
+	if (t10_alua_lu_gp_mem_cache)
+		kmem_cache_destroy(t10_alua_lu_gp_mem_cache);
 	if (t10_alua_tg_pt_gp_cache)
 		kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
+	if (t10_alua_tg_pt_gp_mem_cache)
+		kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
 	kfree(global);
         return(-1);
 }
@@ -360,7 +378,9 @@ extern void release_se_global (void)
 	kmem_cache_destroy(se_sess_cache);
 	kmem_cache_destroy(t10_pr_reg_cache);
 	kmem_cache_destroy(t10_alua_lu_gp_cache);
+	kmem_cache_destroy(t10_alua_lu_gp_mem_cache);
 	kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
+	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
 	kfree(global);
 
 	se_global = NULL;
@@ -2084,13 +2104,11 @@ extern se_device_t *transport_add_device_to_core_hba (
 	dev->transport		= transport;
 	atomic_set(&dev->active_cmds, 0);
 	INIT_LIST_HEAD(&dev->dev_sep_list);
-	INIT_LIST_HEAD(&dev->dev_lu_gp_list);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_create_sem);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_done_sem);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_sem);
 	spin_lock_init(&dev->execute_task_lock);
 	spin_lock_init(&dev->state_task_lock);
-	spin_lock_init(&dev->dev_alua_lock);
 	spin_lock_init(&dev->dev_reservation_lock);
 	spin_lock_init(&dev->dev_status_lock);
 	spin_lock_init(&dev->dev_status_thr_lock);
@@ -2129,7 +2147,8 @@ extern se_device_t *transport_add_device_to_core_hba (
 	/*
 	 * Setup the Asymmetric Logical Unit Assignment for se_device_t
 	 */
-	core_setup_alua(dev);
+	if (core_setup_alua(dev) < 0)
+		goto out;
 	/*
 	 * Startup the se_device_t processing thread
 	 */	
@@ -4192,7 +4211,7 @@ extern int transport_generic_emulate_inquiry (
 		 */
 check_port:
 		if ((port = lun->lun_sep)) {	
-			t10_alua_lu_gp_t *lu_gp_p;
+			t10_alua_lu_gp_t *lu_gp;
 			t10_alua_tg_pt_gp_t *tg_pt_gp_p;
 			u32 padding, scsi_name_len;
 			u16 lu_gp_id = 0;
@@ -4259,10 +4278,16 @@ check_lu_gp:
 				len += 8;
 				goto check_scsi_name;
 			}
-			spin_lock(&dev->dev_alua_lock);
-			if ((lu_gp_p = dev->dev_alua_lu_gp))
-				lu_gp_id = lu_gp_p->lu_gp_id;
-			spin_unlock(&dev->dev_alua_lock);
+			if (!(dev->dev_alua_lu_gp_mem))
+				goto check_scsi_name;
+
+			spin_lock(&dev->dev_alua_lu_gp_mem->lu_gp_mem_lock);
+			if (!(lu_gp = dev->dev_alua_lu_gp_mem->lu_gp)) {
+				spin_unlock(&dev->dev_alua_lu_gp_mem->lu_gp_mem_lock);
+				goto check_scsi_name;
+			}
+			lu_gp_id = lu_gp->lu_gp_id;
+			spin_unlock(&dev->dev_alua_lu_gp_mem->lu_gp_mem_lock);
 
 			buf[off++] |= 0x1; // CODE SET == Binary
 			buf[off++] |= 0x6; // DESIGNATOR TYPE == Logical Unit Group identifier
-- 
1.5.4.1



