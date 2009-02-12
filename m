From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [Target_Core_Mod/ALUA]: Add t10_alua_tg_pt_gp_member_t
	usage for Target Port Groups
Date: Wed, 11 Feb 2009 22:37:06 -0800
Message-ID: <1234420626.12375.518.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:22677 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757865AbZBLGig (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2009 01:38:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@lst.de>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>

>From b4a9bf638df93dafd3e77d011f1dc64292bcf587 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 11 Feb 2009 22:05:14 -0800
Subject: [PATCH 2/2] [Target_Core_Mod/ALUA]: Add t10_alua_tg_pt_gp_member_t usage for Target Port Groups

This patch defines t10_alua_tg_pt_gp_member_t and changes se_port_t->sep_alua_tg_pt_gp
to a pointer at se_port_t->sep_alua_tg_pt_gp_mem that is allocated/released by
se_port_t.  This allows the shutdown logic for se_port and ALUA Target Port
associated for said se_port_t much cleaner and prevents a potential OOPs with the
existing code.

This patch also adds the following logic to ALUA target port groups:

*) The deletion of target port groups with 'rmdir core/alua/tg_pt_gps/$TG_PT_GROUP'
will cause any associated se_port_t to be put back into core/alua/tg_pt_gps/default_tg_pt_gp
*) Emulated INQUIRY EVPD Target Port Group Identifier will also return a value if there
is an association to default_tg_pt_gp or a user defined target port group.
Completely releasing a given associated via:
echo NULL > core/iscsi/$TARGETNAME/$TPGT/lun/$LUN_ID/alua_tg_pt_gp
will return no EVPD Target Port Group Identifier.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_alua.c      |  279 ++++++++++++++++++++----------
 drivers/lio-core/target_core_alua.h      |   10 +-
 drivers/lio-core/target_core_base.h      |    9 +-
 drivers/lio-core/target_core_configfs.c  |   21 ++-
 drivers/lio-core/target_core_device.c    |   16 ++-
 drivers/lio-core/target_core_transport.c |   16 ++-
 6 files changed, 235 insertions(+), 116 deletions(-)

diff --git a/drivers/lio-core/target_core_alua.c b/drivers/lio-core/target_core_alua.c
index 86a1546..735f81e 100644
--- a/drivers/lio-core/target_core_alua.c
+++ b/drivers/lio-core/target_core_alua.c
@@ -59,6 +59,7 @@ extern int core_scsi3_emulate_report_target_port_groups (se_cmd_t *cmd)
 {
 	se_port_t *port;
 	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	u32 rd_len = 0, off = 4;
 	
@@ -102,8 +103,10 @@ extern int core_scsi3_emulate_report_target_port_groups (se_cmd_t *cmd)
 		buf[off++] = (tg_pt_gp->tg_pt_gp_members & 0xff);
 		rd_len += 8;
 		
-		spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
-		list_for_each_entry(port, &tg_pt_gp->tg_pt_gp_ref_list, sep_tg_pt_gp_list) {
+		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+		list_for_each_entry(tg_pt_gp_mem, &tg_pt_gp->tg_pt_gp_mem_list,
+				tg_pt_gp_mem_list) {
+			port = tg_pt_gp_mem->tg_pt;
 			/*
 			 * Start Target Port descriptor format
 			 *
@@ -117,7 +120,7 @@ extern int core_scsi3_emulate_report_target_port_groups (se_cmd_t *cmd)
 			buf[off++] = (port->sep_rtpi & 0xff);
 			rd_len += 4;
 		}
-		spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	}
 	spin_unlock(&se_global->tg_pt_gps_lock);
 	/*
@@ -142,6 +145,7 @@ extern t10_alua_lu_gp_t *core_alua_allocate_lu_gp (const char *name)
 	INIT_LIST_HEAD(&lu_gp->lu_gp_list);
 	INIT_LIST_HEAD(&lu_gp->lu_gp_mem_list);
 	spin_lock_init(&lu_gp->lu_gp_lock);
+	atomic_set(&lu_gp->lu_gp_ref_cnt, 0);
 	lu_gp->lu_gp_alua_access_state = ALUA_ACCESS_STATE_ACTIVE_OPTMIZED;
 
 	spin_lock(&se_global->lu_gps_lock);
@@ -340,8 +344,9 @@ extern t10_alua_tg_pt_gp_t *core_alua_allocate_tg_pt_gp (const char *name)
 		return(NULL);
 	}
 	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_list);
-	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_ref_list);
-	spin_lock_init(&tg_pt_gp->tg_pt_gp_ref_lock);
+	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_mem_list);
+	spin_lock_init(&tg_pt_gp->tg_pt_gp_lock);
+	atomic_set(&tg_pt_gp->tg_pt_gp_ref_cnt, 0);
 	tg_pt_gp->tg_pt_gp_alua_access_state = ALUA_ACCESS_STATE_ACTIVE_OPTMIZED;
 
 	spin_lock(&se_global->tg_pt_gps_lock);
@@ -365,9 +370,27 @@ again:
 	return(tg_pt_gp);
 }
 
+extern t10_alua_tg_pt_gp_member_t *core_alua_allocate_tg_pt_gp_mem (
+	se_port_t *port)
+{
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;
+
+	if (!(tg_pt_gp_mem = kmem_cache_zalloc(t10_alua_tg_pt_gp_mem_cache, GFP_KERNEL))) {
+		printk(KERN_ERR "Unable to allocate t10_alua_tg_pt_gp_member_t\n");
+		return(ERR_PTR(-ENOMEM));
+	}
+	INIT_LIST_HEAD(&tg_pt_gp_mem->tg_pt_gp_mem_list);
+	spin_lock_init(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+
+	tg_pt_gp_mem->tg_pt = port;
+	port->sep_alua_tg_pt_gp_mem = tg_pt_gp_mem;
+
+	return(tg_pt_gp_mem);
+}
+
 extern void core_alua_free_tg_pt_gp (t10_alua_tg_pt_gp_t *tg_pt_gp)
 {
-	se_port_t *port, *port_tmp;
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem, *tg_pt_gp_mem_tmp;
 	/*
 	 * Once we have reached this point, config_item_put() has already
 	 * been called from target_core_alua_drop_tg_pt_gp().
@@ -380,26 +403,83 @@ extern void core_alua_free_tg_pt_gp (t10_alua_tg_pt_gp_t *tg_pt_gp)
 	list_del(&tg_pt_gp->tg_pt_gp_list);
 	se_global->alua_tg_pt_gps_counter--;
 	spin_unlock(&se_global->tg_pt_gps_lock);
+	/*
+	 * Allow a t10_alua_tg_pt_gp_member_t * referenced by
+	 * core_alua_get_tg_pt_gp_by_name() in
+	 * target_core_configfs.c:target_core_store_alua_tg_pt_gp()
+	 * to be released with core_alua_put_tg_pt_gp_from_name().
+	 */
+	while(atomic_read(&tg_pt_gp->tg_pt_gp_ref_cnt))
+		msleep(10);
+	/*
+	 * Release reference to t10_alua_tg_pt_gp_t from all associated
+	 * se_port_t.
+	 */
+	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+	list_for_each_entry_safe(tg_pt_gp_mem, tg_pt_gp_mem_tmp,
+			&tg_pt_gp->tg_pt_gp_mem_list, tg_pt_gp_mem_list) {
+		if (tg_pt_gp_mem->tg_pt_gp_assoc) {
+			list_del(&tg_pt_gp_mem->tg_pt_gp_mem_list);
+			tg_pt_gp->tg_pt_gp_members--;
+			tg_pt_gp_mem->tg_pt_gp_assoc = 0;
+		}
+		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+		/*
+		 * tg_pt_gp_mem is assoicated with a single
+		 * se_portt->sep_alua_tg_pt_gp_mem, and is released via
+		 * core_alua_free_tg_pt_gp_mem().	
+		 *
+		 * If the passed tg_pt_gp does NOT match the default_tg_pt_gp,
+		 * assume we want to re-assocate a given tg_pt_gp_mem with
+		 * default_tg_pt_gp.
+		 */
+		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+		if (tg_pt_gp != se_global->default_tg_pt_gp) {	
+			__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem, 
+					se_global->default_tg_pt_gp);
+		} else
+			tg_pt_gp_mem->tg_pt_gp = NULL;
+		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+		
+		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+	}
+	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+
+	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
+	return;
+}
 
-	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
-	list_for_each_entry_safe(port, port_tmp, &tg_pt_gp->tg_pt_gp_ref_list,
-			sep_tg_pt_gp_list) {
-		list_del(&port->sep_tg_pt_gp_list);
-		spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+extern void core_alua_free_tg_pt_gp_mem (se_port_t *port)
+{
+	se_subsystem_dev_t *su_dev = port->sep_lun->se_dev->se_sub_dev;
+	t10_alua_t *alua = T10_ALUA(su_dev);
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;	
 
-		spin_lock(&port->sep_alua_lock);
-		port->sep_alua_tg_pt_gp = NULL;
-		spin_unlock(&port->sep_alua_lock);
+	if (alua->alua_type != SPC3_ALUA_EMULATED)
+		return;
+
+	if (!(tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem))	
+		return;
 
-		spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	if ((tg_pt_gp = tg_pt_gp_mem->tg_pt_gp)) {
+		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+		if (tg_pt_gp_mem->tg_pt_gp_assoc) {	
+			list_del(&tg_pt_gp_mem->tg_pt_gp_mem_list);
+			tg_pt_gp->tg_pt_gp_members--;
+			tg_pt_gp_mem->tg_pt_gp_assoc = 0;
+		}	
+		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+		tg_pt_gp_mem->tg_pt_gp = NULL;
 	}
-	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
-	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
+	kmem_cache_free(t10_alua_tg_pt_gp_mem_cache, tg_pt_gp_mem);
 	return;
 }
 
-extern t10_alua_tg_pt_gp_t *core_alua_get_tg_pt_gp_by_name (se_port_t *port, const char *name)
+extern t10_alua_tg_pt_gp_t *core_alua_get_tg_pt_gp_by_name (const char *name)
 {
 	t10_alua_tg_pt_gp_t *tg_pt_gp;
 	struct config_item *ci;
@@ -418,83 +498,71 @@ extern t10_alua_tg_pt_gp_t *core_alua_get_tg_pt_gp_by_name (se_port_t *port, con
 	return(NULL);
 }
 
-extern void core_alua_attach_tg_pt_gp (se_port_t *port, t10_alua_tg_pt_gp_t *tg_pt_gp)
+extern void core_alua_put_tg_pt_gp_from_name (t10_alua_tg_pt_gp_t *tg_pt_gp)
 {
-	spin_lock(&port->sep_alua_lock);
-	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
-	list_add_tail(&port->sep_tg_pt_gp_list, &tg_pt_gp->tg_pt_gp_ref_list);
-	tg_pt_gp->tg_pt_gp_members++;
-	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
-	port->sep_alua_tg_pt_gp = tg_pt_gp;
-	spin_unlock(&port->sep_alua_lock);
+	spin_lock(&se_global->tg_pt_gps_lock);
+	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
+	spin_unlock(&se_global->tg_pt_gps_lock);
 
 	return;
 }
 
 /*
- * Called with se_port_t->sep_alua_lock held.
+ * Called with t10_alua_tg_pt_gp_member_t->tg_pt_gp_mem_lock held
  */
-extern void __core_alua_put_tg_pt_gp (se_port_t *port, int clear)
+extern void __core_alua_attach_tg_pt_gp_mem (
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem,
+	t10_alua_tg_pt_gp_t *tg_pt_gp)
 {
-	t10_alua_tg_pt_gp_t *tg_pt_gp;
-
-	if (!(tg_pt_gp = port->sep_alua_tg_pt_gp))
-		return;
-
-	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
-	list_del(&port->sep_tg_pt_gp_list);
-	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
-	tg_pt_gp->tg_pt_gp_members--;
-
-	if (!(clear)) {
-		spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
-		return;
-	}
-	port->sep_alua_tg_pt_gp = NULL;
-	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+	tg_pt_gp_mem->tg_pt_gp = tg_pt_gp;	
+	tg_pt_gp_mem->tg_pt_gp_assoc = 1;
+	list_add_tail(&tg_pt_gp_mem->tg_pt_gp_mem_list, &tg_pt_gp->tg_pt_gp_mem_list);
+	tg_pt_gp->tg_pt_gp_members++;
+	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
 	return;
 }
 
-extern void core_alua_put_tg_pt_gp (se_port_t *port, int clear)
+/*
+ * Called with t10_alua_tg_pt_gp_member_t->tg_pt_gp_mem_lock held
+ */
+extern void __core_alua_drop_tg_pt_gp_mem (
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem,
+	t10_alua_tg_pt_gp_t *tg_pt_gp)
 {
-	t10_alua_tg_pt_gp_t *tg_pt_gp;
-
-	spin_lock(&port->sep_alua_lock);
-	if (!(tg_pt_gp = port->sep_alua_tg_pt_gp)) {
-		spin_unlock(&port->sep_alua_lock);
-		return;
-	}
-	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
-	list_del(&port->sep_tg_pt_gp_list);
-	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
+	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+	list_del(&tg_pt_gp_mem->tg_pt_gp_mem_list);
+	tg_pt_gp_mem->tg_pt_gp = NULL;	
+	tg_pt_gp_mem->tg_pt_gp_assoc = 0;
 	tg_pt_gp->tg_pt_gp_members--;
+	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
-	if (!(clear)) {
-		spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
-		spin_unlock(&port->sep_alua_lock);
-		return;
-	}
-	port->sep_alua_tg_pt_gp = NULL;
-	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
-	spin_unlock(&port->sep_alua_lock);
-	
 	return;
 }
 
 extern ssize_t core_alua_show_tg_pt_gp_info (se_port_t *port, char *page)
 {
+	se_subsystem_dev_t *su_dev = port->sep_lun->se_dev->se_sub_dev;
 	struct config_item *tg_pt_ci;
+	t10_alua_t *alua = T10_ALUA(su_dev);
 	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;
 	ssize_t len = 0;
 
-	spin_lock(&port->sep_alua_lock);
-	if ((tg_pt_gp = port->sep_alua_tg_pt_gp)) {	
+	if (alua->alua_type != SPC3_ALUA_EMULATED)
+		return(len);
+
+	if (!(tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem))
+		return(len);
+
+	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	if ((tg_pt_gp = tg_pt_gp_mem->tg_pt_gp)) {
 		tg_pt_ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
 		len += sprintf(page, "TG Port Alias: %s\nTG Port Group ID: %hu\n",
 			config_item_name(tg_pt_ci), tg_pt_gp->tg_pt_gp_id);
 	}
-	spin_unlock(&port->sep_alua_lock);
+	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
 	return(len);
 }
@@ -505,23 +573,54 @@ extern ssize_t core_alua_store_tg_pt_gp_info (se_port_t *port, const char *page,
 {
 	se_portal_group_t *tpg;
 	se_lun_t *lun;
-	t10_alua_tg_pt_gp_t *tg_pt_gp = NULL, *tg_pt_gp_new;
-	unsigned char buf[256];
+	se_subsystem_dev_t *su_dev = port->sep_lun->se_dev->se_sub_dev;
+	t10_alua_tg_pt_gp_t *tg_pt_gp = NULL, *tg_pt_gp_new = NULL;
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;
+	unsigned char buf[TG_PT_GROUP_NAME_BUF];
 	int move = 0;
 
-	if (count > 256) {
+	tpg = port->sep_tpg;
+	lun = port->sep_lun;
+
+	if (T10_ALUA(su_dev)->alua_type != SPC3_ALUA_EMULATED) {
+		printk(KERN_WARNING "SPC3_ALUA_EMULATED not enabled for"
+			" %s/tpgt_%hu/%s\n", TPG_TFO(tpg)->tpg_get_wwn(tpg),
+			TPG_TFO(tpg)->tpg_get_tag(tpg),
+			config_item_name(&lun->lun_group.cg_item));
+		return(-EINVAL);
+	}
+	if (count > TG_PT_GROUP_NAME_BUF) {
 		printk(KERN_ERR "ALUA Target Port Group alias too large!\n");
 		return(-EINVAL);
 	}
-	memset(buf, 0, 256);
+	memset(buf, 0, TG_PT_GROUP_NAME_BUF);
 	memcpy(buf, page, count);
+	/*
+	 * Any ALUA target port group alias besides "NULL" means we will be
+	 * making a new group association.
+	 */
+	if (strcmp(strstrip(buf), "NULL")) {
+		/*
+		 * core_alua_get_tg_pt_gp_by_name() will increment reference to
+		 * t10_alua_tg_pt_gp_t.  This reference is released with
+		 * core_alua_put_tg_pt_gp_from_name() below.
+		 */
+		if (!(tg_pt_gp_new = core_alua_get_tg_pt_gp_by_name(strstrip(buf))))
+			return(-ENODEV);	
+	}
+	if (!(tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem)) {
+		if (tg_pt_gp_new)
+			core_alua_put_tg_pt_gp_from_name(tg_pt_gp_new);
+		printk(KERN_ERR "NULL se_port_t->sep_alua_tg_pt_gp_mem pointer\n");
+		return(-EINVAL);
+	}
 
-	tpg = port->sep_tpg;
-	lun = port->sep_lun;
-
-	spin_lock(&port->sep_alua_lock);
-	if ((tg_pt_gp = port->sep_alua_tg_pt_gp)) {
-		if (!(strcmp(strstrip(buf), "NULL"))) {
+	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	if ((tg_pt_gp = tg_pt_gp_mem->tg_pt_gp)) {
+		/*
+		 * Clearing an existing tg_pt_gp association, and replacing with NULL
+		 */
+		if (!(tg_pt_gp_new)) {
 			printk("Target_Core_ConfigFS: Releasing %s/tpgt_%hu/%s"
 				" from ALUA Target Port Group: core/alua/tg_pt"
 				"_gps/%s, ID: %hu\n",
@@ -531,22 +630,22 @@ extern ssize_t core_alua_store_tg_pt_gp_info (se_port_t *port, const char *page,
 				config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
 				tg_pt_gp->tg_pt_gp_id);
 			
-			__core_alua_put_tg_pt_gp(port, 1);
-			spin_unlock(&port->sep_alua_lock);
+			__core_alua_drop_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp);
+			spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 			
 			return(count);
 		}
-	}
-	spin_unlock(&port->sep_alua_lock);
-
-	if (!(tg_pt_gp_new = core_alua_get_tg_pt_gp_by_name(port, strstrip(buf))))
-		return(-ENODEV);
-
-	if (tg_pt_gp) {
-		core_alua_put_tg_pt_gp(port, 0);
+		/*
+		 * Removing existing association of tg_pt_gp_mem with tg_pt_gp
+		 */
+		__core_alua_drop_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp);
 		move = 1;
 	}
-	core_alua_attach_tg_pt_gp(port, tg_pt_gp_new);
+	/*
+	 * Associate tg_pt_gp_mem with tg_pt_gp_new.
+	 */
+	__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp_new);
+	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
 	printk("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA Target Port"
 		" Group: core/alua/tg_pt_gps/%s, ID: %hu\n", (move) ?
@@ -556,6 +655,7 @@ extern ssize_t core_alua_store_tg_pt_gp_info (se_port_t *port, const char *page,
 		config_item_name(&tg_pt_gp_new->tg_pt_gp_group.cg_item),
 		tg_pt_gp_new->tg_pt_gp_id);
 	
+	core_alua_put_tg_pt_gp_from_name(tg_pt_gp_new);
 	return(count);
 }
 
@@ -590,7 +690,8 @@ extern int core_setup_alua (se_device_t *dev)
 		 * Assoicate this se_device_t with the default ALUA
 		 * LUN Group.
 		 */
-		if (!(lu_gp_mem = core_alua_allocate_lu_gp_mem(dev)))
+		lu_gp_mem = core_alua_allocate_lu_gp_mem(dev);
+		if (IS_ERR(lu_gp_mem) || !lu_gp_mem)
 			return(-1);
 		
 		alua->alua_type = SPC3_ALUA_EMULATED;
diff --git a/drivers/lio-core/target_core_alua.h b/drivers/lio-core/target_core_alua.h
index 714692d..b082063 100644
--- a/drivers/lio-core/target_core_alua.h
+++ b/drivers/lio-core/target_core_alua.h
@@ -43,11 +43,13 @@ extern void __core_alua_attach_lu_gp_mem (struct t10_alua_lu_gp_member_s *, stru
 extern void __core_alua_drop_lu_gp_mem (struct t10_alua_lu_gp_member_s *, struct t10_alua_lu_gp_s *);
 extern void core_alua_drop_lu_gp_dev (struct se_device_s *);
 extern struct t10_alua_tg_pt_gp_s *core_alua_allocate_tg_pt_gp (const char *);
+extern struct t10_alua_tg_pt_gp_member_s *core_alua_allocate_tg_pt_gp_mem (struct se_port_s *);
 extern void core_alua_free_tg_pt_gp (struct t10_alua_tg_pt_gp_s *);
-extern struct t10_alua_tg_pt_gp_s *core_alua_get_tg_pt_gp_by_name (struct se_port_s *, const char *);
-extern void core_alua_attach_tg_pt_gp (struct se_port_s *, struct t10_alua_tg_pt_gp_s *);
-extern void __core_alua_put_tg_pt_gp (struct se_port_s *, int);
-extern void core_alua_put_tg_pt_gp (struct se_port_s *, int);
+extern void core_alua_free_tg_pt_gp_mem (struct se_port_s *);
+extern struct t10_alua_tg_pt_gp_s *core_alua_get_tg_pt_gp_by_name (const char *);
+extern void core_alua_put_tg_pt_gp_from_name (struct t10_alua_tg_pt_gp_s *);
+extern void __core_alua_attach_tg_pt_gp_mem (struct t10_alua_tg_pt_gp_member_s *, struct t10_alua_tg_pt_gp_s *);
+extern void __core_alua_drop_tg_pt_gp_mem (struct t10_alua_tg_pt_gp_member_s *, struct t10_alua_tg_pt_gp_s *);
 extern ssize_t core_alua_show_tg_pt_gp_info (struct se_port_s *, char *);
 extern ssize_t core_alua_store_tg_pt_gp_info (struct se_port_s *, const char *, size_t);
 extern int core_setup_alua (struct se_device_s *);
diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index fc5dc29..b17b177 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -51,6 +51,7 @@
 
 #define TRANSPORT_IQN_LEN			224 /* Currently same as ISCSI_IQN_LEN */
 #define LU_GROUP_NAME_BUF			256
+#define TG_PT_GROUP_NAME_BUF			256
 #define EVPD_TMP_BUF_SIZE			128 /* Used to parse EVPD into t10_evpd_t */
 
 /* used by PSCSI and iBlock Transport drivers */
@@ -214,10 +215,10 @@ typedef struct t10_alua_tg_pt_gp_s {
 	int	tg_pt_gp_alua_access_state;
 	u32	tg_pt_gp_members;
 	atomic_t tg_pt_gp_ref_cnt;
-	spinlock_t tg_pt_gp_ref_lock;
+	spinlock_t tg_pt_gp_lock;
 	struct config_group tg_pt_gp_group;
 	struct list_head tg_pt_gp_list;
-	struct list_head tg_pt_gp_ref_list;
+	struct list_head tg_pt_gp_mem_list;
 } ____cacheline_aligned t10_alua_tg_pt_gp_t;
 
 typedef struct t10_alua_tg_pt_gp_member_s {
@@ -712,12 +713,10 @@ typedef struct se_port_s {
         u32             sep_index;
         scsi_port_stats_t sep_stats;
 #endif
-	spinlock_t	sep_alua_lock;
-	struct t10_alua_tg_pt_gp_s *sep_alua_tg_pt_gp; /* Used for ALUA Target Port Groups */
+	struct t10_alua_tg_pt_gp_member_s *sep_alua_tg_pt_gp_mem; /* Used for ALUA Target Port Groups membership */
         struct se_lun_s *sep_lun;
         struct se_portal_group_s *sep_tpg;
         struct list_head sep_list;
-	struct list_head sep_tg_pt_gp_list;
 } ____cacheline_aligned se_port_t;
 
 typedef struct se_portal_group_s {
diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 5b5f7a6..46324a6 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -1469,9 +1469,9 @@ static ssize_t target_core_alua_lu_gp_show_attr_members (
 	se_subsystem_dev_t *su_dev;
 	t10_alua_lu_gp_member_t *lu_gp_mem;
 	ssize_t len = 0, cur_len;
-	unsigned char buf[256];
+	unsigned char buf[LU_GROUP_NAME_BUF];
 
-	memset(buf, 0, 256);
+	memset(buf, 0, LU_GROUP_NAME_BUF);
 
 	spin_lock(&lu_gp->lu_gp_lock);
 	list_for_each_entry(lu_gp_mem, &lu_gp->lu_gp_mem_list, lu_gp_mem_list) {
@@ -1479,7 +1479,7 @@ static ssize_t target_core_alua_lu_gp_show_attr_members (
 		su_dev = dev->se_sub_dev;
 		hba = su_dev->se_dev_hba;
 
-		cur_len = snprintf(buf, 256, "%s/%s\n",
+		cur_len = snprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
 			config_item_name(&su_dev->se_dev_group.cg_item),
 			config_item_name(&hba->hba_group.cg_item));
 		cur_len++; // Extra byte for NULL terminator
@@ -1618,17 +1618,20 @@ static ssize_t target_core_alua_tg_pt_gp_show_attr_members (
 	se_port_t *port;
 	se_portal_group_t *tpg;
 	se_lun_t *lun;
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;
 	ssize_t len = 0, cur_len;
-	unsigned char buf[256];
+	unsigned char buf[TG_PT_GROUP_NAME_BUF];
 
-	memset(buf, 0, 256);
+	memset(buf, 0, TG_PT_GROUP_NAME_BUF);
 
-	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
-	list_for_each_entry(port, &tg_pt_gp->tg_pt_gp_ref_list, sep_tg_pt_gp_list) {
+	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+	list_for_each_entry(tg_pt_gp_mem, &tg_pt_gp->tg_pt_gp_mem_list,
+			tg_pt_gp_mem_list) {
+		port = tg_pt_gp_mem->tg_pt;
 		tpg = port->sep_tpg;
 		lun = port->sep_lun;
 
-		cur_len = snprintf(buf, 256, "%s/tpgt_%hu/%s\n",
+		cur_len = snprintf(buf, TG_PT_GROUP_NAME_BUF, "%s/tpgt_%hu/%s\n",
 			TPG_TFO(tpg)->tpg_get_wwn(tpg),
 			TPG_TFO(tpg)->tpg_get_tag(tpg),
 			config_item_name(&lun->lun_group.cg_item));
@@ -1642,7 +1645,7 @@ static ssize_t target_core_alua_tg_pt_gp_show_attr_members (
 		memcpy(page+len, buf, cur_len);
 		len += cur_len;
 	}
-	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
 	return(len);
 }
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 2c9566e..1c189b4 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -501,8 +501,6 @@ extern se_port_t *core_alloc_port (se_device_t *dev)
 		return(NULL);
 	}
 	INIT_LIST_HEAD(&port->sep_list);
-	INIT_LIST_HEAD(&port->sep_tg_pt_gp_list);
-	spin_lock_init(&port->sep_alua_lock);
 
 	spin_lock(&dev->se_port_lock);
 	if (dev->dev_port_count == 0x0000ffff) {
@@ -546,6 +544,7 @@ extern void core_export_port (
 	se_lun_t *lun)
 {
 	se_subsystem_dev_t *su_dev = SU_DEV(dev);
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem = NULL;
 
 	spin_lock(&dev->se_port_lock);
 	spin_lock(&lun->lun_sep_lock);
@@ -558,7 +557,16 @@ extern void core_export_port (
 	spin_unlock(&dev->se_port_lock);
 
 	if (T10_ALUA(su_dev)->alua_type == SPC3_ALUA_EMULATED) {
-		core_alua_attach_tg_pt_gp(port, se_global->default_tg_pt_gp);
+		tg_pt_gp_mem = core_alua_allocate_tg_pt_gp_mem(port);
+		if (IS_ERR(tg_pt_gp_mem) || !tg_pt_gp_mem) {
+			printk(KERN_ERR "Unable to allocate t10_alua_tg_pt_gp_member_t\n");
+			return;
+		}
+		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+		__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
+			se_global->default_tg_pt_gp);
+		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+
 		printk("%s/%s: Adding to default ALUA Target Port Group:"
 			" core/alua/tg_pt_gps/default_tg_pt_gp\n",
 			TRANSPORT(dev)->name, TPG_TFO(tpg)->get_fabric_name());
@@ -576,7 +584,7 @@ extern void core_export_port (
  */
 extern void core_release_port (se_device_t *dev, se_port_t *port)
 {
-	core_alua_put_tg_pt_gp(port, 1);
+	core_alua_free_tg_pt_gp_mem(port);
 
 	list_del(&port->sep_list);
 	dev->dev_port_count--;
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 18c3693..7544c46 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -4212,7 +4212,7 @@ extern int transport_generic_emulate_inquiry (
 check_port:
 		if ((port = lun->lun_sep)) {	
 			t10_alua_lu_gp_t *lu_gp;
-			t10_alua_tg_pt_gp_t *tg_pt_gp_p;
+			t10_alua_tg_pt_gp_t *tg_pt_gp;
 			u32 padding, scsi_name_len;
 			u16 lu_gp_id = 0;
 			u16 tg_pt_gp_id = 0;
@@ -4254,10 +4254,16 @@ check_tpgi:
 				len += 8;
 				goto check_lu_gp;
 			}
-			spin_lock(&port->sep_alua_lock);
-			if ((tg_pt_gp_p = port->sep_alua_tg_pt_gp))
-				tg_pt_gp_id = tg_pt_gp_p->tg_pt_gp_id;
-			spin_unlock(&port->sep_alua_lock);
+			if (!(port->sep_alua_tg_pt_gp_mem))
+				goto check_lu_gp;
+
+			spin_lock(&port->sep_alua_tg_pt_gp_mem->tg_pt_gp_mem_lock);
+			if (!(tg_pt_gp = port->sep_alua_tg_pt_gp_mem->tg_pt_gp)) {
+				spin_unlock(&port->sep_alua_tg_pt_gp_mem->tg_pt_gp_mem_lock);
+				goto check_lu_gp;
+			}
+			tg_pt_gp_id = tg_pt_gp->tg_pt_gp_id;
+			spin_unlock(&port->sep_alua_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
 			buf[off] = (TPG_TFO(tpg)->get_fabric_proto_ident() << 4);
 			buf[off++] |= 0x1; // CODE SET == Binary
-- 
1.5.4.1



