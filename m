From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/6] [Target_Core_Mod/ALUA]: Add support for SPC-3 Target
	Port and Logical Unit Groups
Date: Thu, 05 Feb 2009 23:56:52 -0800
Message-ID: <1233907012.12375.355.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:26588 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752610AbZBFH57 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2009 02:57:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, Rafiu Fakunle <rafiu@openfiler.com>

>From d796aa7f4d5474ced5c97557fb52fcc326dab31e Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 5 Feb 2009 23:03:20 -0800
Subject: [PATCH 1/6] [Target_Core_Mod/ALUA]: Add support for SPC-3 Target Port and Logical Unit Groups

This patch adds the necessary infrastructure for ALUA defined Target Port Group
and Logical Unit Group abstractions with Target_Core_Mod.  It adds the following
data structures:

*) t10_alua_tg_pt_gp_t (References se_port_t)
*) t10_alua_lu_gp_t (References se_device_t)

it also places these lists in se_global_t.

Also, patch also updates REPORT_TARGET_PORT_GROUP CDB emulation to scan
through the t10_alua_tg_pt_gp_t list.

Finally, this patch adds new functions core_alua_show_tg_pt_gp_info() and
core_alua_store_tg_pt_gp_info() as EXPORT_SYMBOL().  These wrapper functions
are used by ConfigFS aware $FABRIC_MOD (like LIO-Target v3.0) to modify
Target Port Group assocation for a given Target_Core_Mod/ConfigFS symlinked
SCSI Target Port.

Here is what it looks like with sg_rtpg with DEFAULT Target Port Group "
core/alua/tg_pt_gps/default_tg_pt_gp:

initiator# sg_rtpg -v /dev/sde
    report target port groups cdb: a3 0a 00 00 00 00 00 00 04 00 00 00
Report list length = 20
Report target port groups:
  target port group id : 0x0 , Pref=0
    target port group asymmetric access state : 0x00
    T_SUP : 0, O_SUP : 0, U_SUP : 0, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x01
      0x02

with the same Target_Core_Mod/IBLOCK storage object exported on
two different Relative target port ids.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_alua.c |  496 ++++++++++++++++++++++++++++++-----
 drivers/lio-core/target_core_alua.h |   14 +
 drivers/lio-core/target_core_base.h |   42 +++
 3 files changed, 490 insertions(+), 62 deletions(-)

diff --git a/drivers/lio-core/target_core_alua.c b/drivers/lio-core/target_core_alua.c
index b43356e..b5f5d66 100644
--- a/drivers/lio-core/target_core_alua.c
+++ b/drivers/lio-core/target_core_alua.c
@@ -43,74 +43,81 @@
 
 #undef TARGET_CORE_ALUA_C
 
+extern se_global_t *se_global;
+
+extern struct kmem_cache *t10_alua_lu_gp_cache;
+extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
+
+/*
+ * REPORT_TARGET_PORT_GROUPS
+ *
+ * See spc4r17 6.2.7
+ */
 extern int core_scsi3_emulate_report_target_port_groups (se_cmd_t *cmd)
 {
-	se_lun_t *lun = SE_LUN(cmd);
 	se_port_t *port;
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	u32 rd_len = 0, off = 4;
-	u16 tg_pg = 0;
-	u8 tg_pg_count = 1; // Assume 1 for now
 	
-	if (!(lun)) {
-		printk(KERN_ERR "SPC-3 ALUA se_lun_t is NULL!\n");
-		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
-	}
-	if (!(port = lun->lun_sep)) {
-		printk(KERN_ERR "SPC-3 ALUA se_port_t is NULL\n");
-		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
-	}
-	/*
-	 * PREF: Preferred target port bit
-	 */
-//	buf[off] = 0x80;
-	/*
-	 * Set the ASYMMETRIC ACCESS State
-	 */
-	buf[off++] |= ALUA_ACCESS_STATE_ACTIVE_OPTMIZED;
-	/*
-	 * Set supported ASYMMETRIC ACCESS State bits
-	 */
-//	buf[off] = 0x80; // T_SUP
-//	buf[off] |= 0x40; // O_SUP
-//	buf[off] |= 0x8; // U_SUP
-//	buf[off] |= 0x4; // S_SUP
-//	buf[off] |= 0x2; // AN_SUP
-	buf[off++] |= 0x1; // AO_SUP
-	/*
-	 * TARGET PORT GROUP
-	 */
-	buf[off++] = ((tg_pg >> 8) & 0xff);
-	buf[off++] = (tg_pg & 0xff);
+	spin_lock(&se_global->tg_pt_gps_lock);
+	list_for_each_entry(tg_pt_gp, &se_global->g_tg_pt_gps_list, tg_pt_gp_list) {
+		/*
+		 * PREF: Preferred target port bit
+		 */
+//		buf[off] = 0x80;
+		/*
+		 * Set the ASYMMETRIC ACCESS State
+		 */
+		buf[off++] |= (tg_pt_gp->tg_pt_gp_alua_access_state & 0xff);
+		/*
+		 * Set supported ASYMMETRIC ACCESS State bits
+		 */
+//		buf[off] = 0x80; // T_SUP
+//		buf[off] |= 0x40; // O_SUP
+//		buf[off] |= 0x8; // U_SUP
+//		buf[off] |= 0x4; // S_SUP
+		buf[off] |= 0x2; // AN_SUP
+		buf[off++] |= 0x1; // AO_SUP
+		/*
+		 * TARGET PORT GROUP
+		 */
+		buf[off++] = ((tg_pt_gp->tg_pt_gp_id >> 8) & 0xff);
+		buf[off++] = (tg_pt_gp->tg_pt_gp_id & 0xff);
 	
-	off++; // Skip over Reserved
-	/*
-	 * STATUS CODE
-	 */
-	buf[off++] = ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
-	/*
-	 * Vendor Specific field
-	 */
-	buf[off++] = 0x00;
-	/*
-	 * TARGET PORT COUNT
-	 */
-	buf[off++] = tg_pg_count;
-
-	rd_len += 8;
-	/*
-	 * Start Target Port descriptor format
-	 *
-	 * See spc4r17 section 6.2.7 Table 247
-	 */
-	off += 2; // Skip over Obsolete
-	/*
-	 * Set RELATIVE TARGET PORT IDENTIFIER
-	 */
-	buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
-	buf[off++] = (port->sep_rtpi & 0xff);
-
-	rd_len += 4;
+		off++; // Skip over Reserved
+		/*
+		 * STATUS CODE
+		 */
+		buf[off++] = ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
+		/*
+		 * Vendor Specific field
+		 */
+		buf[off++] = 0x00;
+		/*
+		 * TARGET PORT COUNT
+		 */
+		buf[off++] = (tg_pt_gp->tg_pt_gp_members & 0xff);
+		rd_len += 8;
+		
+		spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
+		list_for_each_entry(port, &tg_pt_gp->tg_pt_gp_ref_list, sep_tg_pt_gp_list) {
+			/*
+			 * Start Target Port descriptor format
+			 *
+			 * See spc4r17 section 6.2.7 Table 247
+			 */
+			off += 2; // Skip over Obsolete
+			/*
+			 * Set RELATIVE TARGET PORT IDENTIFIER
+			 */
+			buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
+			buf[off++] = (port->sep_rtpi & 0xff);
+			rd_len += 4;
+		}
+		spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	}
+	spin_unlock(&se_global->tg_pt_gps_lock);
 	/*
 	 * Set the RETURN DATA LENGTH set in the header of the DataIN Payload
 	 */
@@ -122,6 +129,364 @@ extern int core_scsi3_emulate_report_target_port_groups (se_cmd_t *cmd)
 	return(0);	
 }
 
+extern t10_alua_lu_gp_t *core_alua_allocate_lu_gp (const char *name)
+{
+	t10_alua_lu_gp_t *lu_gp, *lu_gp_tmp;
+
+	if (!(lu_gp = kmem_cache_zalloc(t10_alua_lu_gp_cache, GFP_KERNEL))) {
+		printk("Unable to allocate t10_alua_lu_gp_t\n");
+		return(NULL);
+	}
+	INIT_LIST_HEAD(&lu_gp->lu_gp_list);
+	INIT_LIST_HEAD(&lu_gp->lu_gp_ref_list);
+	spin_lock_init(&lu_gp->lu_gp_ref_lock);
+	lu_gp->lu_gp_alua_access_state = ALUA_ACCESS_STATE_ACTIVE_OPTMIZED;
+
+	spin_lock(&se_global->lu_gps_lock);
+	if (se_global->alua_lu_gps_count == 0x0000ffff) {
+		spin_unlock(&se_global->lu_gps_lock);
+		kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
+		return(NULL);
+	}
+again:
+	lu_gp->lu_gp_id = se_global->alua_lu_gps_counter++;
+
+	list_for_each_entry(lu_gp_tmp, &se_global->g_lu_gps_list, lu_gp_list) {
+		if (lu_gp_tmp->lu_gp_id == lu_gp->lu_gp_id)	
+			goto again;
+	}
+
+	list_add_tail(&lu_gp->lu_gp_list, &se_global->g_lu_gps_list);	
+	se_global->alua_lu_gps_count++;
+	spin_unlock(&se_global->lu_gps_lock);
+
+	return(lu_gp);
+}
+
+extern void core_alua_free_lu_gp (t10_alua_lu_gp_t *lu_gp)
+{
+	se_device_t *dev, *dev_tmp;
+
+	spin_lock(&lu_gp->lu_gp_ref_lock);
+	list_for_each_entry_safe(dev, dev_tmp, &lu_gp->lu_gp_ref_list, dev_lu_gp_list) {
+		list_del(&dev->dev_lu_gp_list);	
+		spin_lock(&dev->dev_alua_lock);
+		dev->dev_alua_lu_gp = NULL;
+		spin_unlock(&dev->dev_alua_lock);
+	}
+	spin_unlock(&lu_gp->lu_gp_ref_lock);
+
+	spin_lock(&se_global->lu_gps_lock);
+	list_del(&lu_gp->lu_gp_list);
+	se_global->alua_lu_gps_count--;
+	spin_unlock(&se_global->lu_gps_lock);
+
+	kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
+	return;
+}
+
+extern t10_alua_lu_gp_t *core_alua_get_lu_gp_by_name (se_device_t *dev, const char *name)
+{
+	t10_alua_lu_gp_t *lu_gp;
+	struct config_item *ci;
+
+	spin_lock(&se_global->lu_gps_lock);
+	list_for_each_entry(lu_gp, &se_global->g_lu_gps_list, lu_gp_list) {
+		ci = &lu_gp->lu_gp_group.cg_item;
+		if (!(strcmp(config_item_name(ci), name))) {
+			atomic_inc(&lu_gp->lu_gp_ref_cnt);			
+			spin_unlock(&se_global->lu_gps_lock);
+			return(lu_gp);
+		}
+	}
+	spin_unlock(&se_global->lu_gps_lock);
+
+	return(NULL);
+}
+
+extern void core_alua_attach_lu_gp (se_device_t *dev, t10_alua_lu_gp_t *lu_gp)
+{
+	spin_lock(&lu_gp->lu_gp_ref_lock);
+	list_add_tail(&dev->dev_lu_gp_list, &lu_gp->lu_gp_ref_list);
+	lu_gp->lu_gp_members++;
+	spin_lock(&dev->dev_alua_lock);
+	dev->dev_alua_lu_gp = lu_gp;
+	spin_unlock(&dev->dev_alua_lock);
+	spin_unlock(&lu_gp->lu_gp_ref_lock);
+
+	return;
+}
+
+/*
+ * Called with se_device_t->dev_alua_lock held.
+ */
+extern void __core_alua_put_lu_gp (se_device_t *dev, int clear)
+{
+	t10_alua_lu_gp_t *lu_gp;
+
+	if (!(lu_gp = dev->dev_alua_lu_gp)) 
+		return;
+
+	spin_lock(&lu_gp->lu_gp_ref_lock);
+	list_del(&dev->dev_lu_gp_list);
+	atomic_dec(&lu_gp->lu_gp_ref_cnt);
+	lu_gp->lu_gp_members--;
+	
+	if (!(clear)) {
+		spin_unlock(&lu_gp->lu_gp_ref_lock);
+		return;
+	}
+	dev->dev_alua_lu_gp = NULL;
+	spin_unlock(&lu_gp->lu_gp_ref_lock);
+
+	return;
+}
+
+extern void core_alua_put_lu_gp (se_device_t *dev, int clear)
+{
+	t10_alua_lu_gp_t *lu_gp;
+
+	spin_lock(&dev->dev_alua_lock);
+	if (!(lu_gp = dev->dev_alua_lu_gp)) {
+		spin_unlock(&dev->dev_alua_lock);
+		return;
+	}
+	spin_lock(&lu_gp->lu_gp_ref_lock);
+	list_del(&dev->dev_lu_gp_list);
+	atomic_dec(&lu_gp->lu_gp_ref_cnt);
+	lu_gp->lu_gp_members--;
+
+	if (!(clear)) {
+		spin_unlock(&lu_gp->lu_gp_ref_lock);
+		spin_unlock(&dev->dev_alua_lock);
+		return;
+	}
+	dev->dev_alua_lu_gp = NULL;
+	spin_unlock(&lu_gp->lu_gp_ref_lock);
+	spin_unlock(&dev->dev_alua_lock);
+
+	return;
+}
+
+extern t10_alua_tg_pt_gp_t *core_alua_allocate_tg_pt_gp (const char *name)
+{
+	t10_alua_tg_pt_gp_t *tg_pt_gp, *tg_pt_gp_tmp;
+
+	if (!(tg_pt_gp = kmem_cache_zalloc(t10_alua_tg_pt_gp_cache, GFP_KERNEL))) {
+		printk("Unable to allocate t10_alua_tg_pt_gp_t\n");
+		return(NULL);
+	}
+	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_list);
+	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_ref_list);
+	spin_lock_init(&tg_pt_gp->tg_pt_gp_ref_lock);
+	tg_pt_gp->tg_pt_gp_alua_access_state = ALUA_ACCESS_STATE_ACTIVE_OPTMIZED;
+
+	spin_lock(&se_global->tg_pt_gps_lock);
+	if (se_global->alua_tg_pt_gps_count == 0x0000ffff) {
+		spin_unlock(&se_global->tg_pt_gps_lock);
+		kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
+		return(NULL);
+	}
+again:
+	tg_pt_gp->tg_pt_gp_id = se_global->alua_tg_pt_gps_counter++;
+
+	list_for_each_entry(tg_pt_gp_tmp, &se_global->g_tg_pt_gps_list, tg_pt_gp_list) {
+		if (tg_pt_gp_tmp->tg_pt_gp_id == tg_pt_gp->tg_pt_gp_id)
+			goto again;
+	}
+
+	list_add_tail(&tg_pt_gp->tg_pt_gp_list, &se_global->g_tg_pt_gps_list);	
+	se_global->alua_tg_pt_gps_count++;
+	spin_unlock(&se_global->tg_pt_gps_lock);
+
+	return(tg_pt_gp);
+}
+
+extern void core_alua_free_tg_pt_gp (t10_alua_tg_pt_gp_t *tg_pt_gp)
+{
+	se_port_t *port, *port_tmp;
+
+	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	list_for_each_entry_safe(port, port_tmp, &tg_pt_gp->tg_pt_gp_ref_list,
+			sep_tg_pt_gp_list) {
+		list_del(&port->sep_tg_pt_gp_list);
+		spin_lock(&port->sep_alua_lock);
+		port->sep_alua_tg_pt_gp = NULL;
+		spin_unlock(&port->sep_alua_lock);
+	}
+	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+
+	spin_lock(&se_global->tg_pt_gps_lock);
+	list_del(&tg_pt_gp->tg_pt_gp_list);
+	se_global->alua_tg_pt_gps_counter--;
+	spin_unlock(&se_global->tg_pt_gps_lock);
+
+	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
+	return;
+}
+
+extern t10_alua_tg_pt_gp_t *core_alua_get_tg_pt_gp_by_name (se_port_t *port, const char *name)
+{
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	struct config_item *ci;
+
+	spin_lock(&se_global->tg_pt_gps_lock);
+	list_for_each_entry(tg_pt_gp, &se_global->g_tg_pt_gps_list, tg_pt_gp_list) {
+		ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
+		if (!(strcmp(config_item_name(ci), name))) {
+			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
+			spin_unlock(&se_global->tg_pt_gps_lock);
+			return(tg_pt_gp);
+		}
+	}
+	spin_unlock(&se_global->tg_pt_gps_lock);
+
+	return(NULL);
+}
+
+extern void core_alua_attach_tg_pt_gp (se_port_t *port, t10_alua_tg_pt_gp_t *tg_pt_gp)
+{
+	spin_lock(&port->sep_alua_lock);
+	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	list_add_tail(&port->sep_tg_pt_gp_list, &tg_pt_gp->tg_pt_gp_ref_list);
+	tg_pt_gp->tg_pt_gp_members++;
+	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	port->sep_alua_tg_pt_gp = tg_pt_gp;
+	spin_unlock(&port->sep_alua_lock);
+
+	return;
+}
+
+/*
+ * Called with se_port_t->sep_alua_lock held.
+ */
+extern void __core_alua_put_tg_pt_gp (se_port_t *port, int clear)
+{
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
+
+	if (!(tg_pt_gp = port->sep_alua_tg_pt_gp))
+		return;
+
+	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	list_del(&port->sep_tg_pt_gp_list);
+	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
+	tg_pt_gp->tg_pt_gp_members--;
+
+	if (!(clear)) {
+		spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+		return;
+	}
+	port->sep_alua_tg_pt_gp = NULL;
+	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+
+	return;
+}
+
+extern void core_alua_put_tg_pt_gp (se_port_t *port, int clear)
+{
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
+
+	spin_lock(&port->sep_alua_lock);
+	if (!(tg_pt_gp = port->sep_alua_tg_pt_gp)) {
+		spin_unlock(&port->sep_alua_lock);
+		return;
+	}
+	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	list_del(&port->sep_tg_pt_gp_list);
+	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
+	tg_pt_gp->tg_pt_gp_members--;
+
+	if (!(clear)) {
+		spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+		spin_unlock(&port->sep_alua_lock);
+		return;
+	}
+	port->sep_alua_tg_pt_gp = NULL;
+	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	spin_unlock(&port->sep_alua_lock);
+	
+	return;
+}
+
+extern ssize_t core_alua_show_tg_pt_gp_info (se_port_t *port, char *page)
+{
+	struct config_item *tg_pt_ci;
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	ssize_t len = 0;
+
+	spin_lock(&port->sep_alua_lock);
+	if ((tg_pt_gp = port->sep_alua_tg_pt_gp)) {	
+		tg_pt_ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
+		len += sprintf(page, "TG Port Alias: %s\nTG Port Group ID: %hu\n",
+			config_item_name(tg_pt_ci), tg_pt_gp->tg_pt_gp_id);
+	}
+	spin_unlock(&port->sep_alua_lock);
+
+	return(len);
+}
+
+EXPORT_SYMBOL(core_alua_show_tg_pt_gp_info);
+
+extern ssize_t core_alua_store_tg_pt_gp_info (se_port_t *port, const char *page, size_t count)
+{
+	se_portal_group_t *tpg;
+	se_lun_t *lun;
+	t10_alua_tg_pt_gp_t *tg_pt_gp = NULL, *tg_pt_gp_new;
+	unsigned char buf[256];
+	int move = 0;
+
+	if (count > 256) {
+		printk(KERN_ERR "ALUA Target Port Group alias too large!\n");
+		return(-EINVAL);
+	}
+	memset(buf, 0, 256);
+	memcpy(buf, page, count);
+
+	tpg = port->sep_tpg;
+	lun = port->sep_lun;
+
+	spin_lock(&port->sep_alua_lock);
+	if ((tg_pt_gp = port->sep_alua_tg_pt_gp)) {
+		if (!(strcmp(strstrip(buf), "NULL"))) {
+			printk("Target_Core_ConfigFS: Releasing %s/tpgt_%hu/%s"
+				" from ALUA Target Port Group: core/alua/tg_pt"
+				"_gps/%s, ID: %hu\n",
+				TPG_TFO(tpg)->tpg_get_wwn(tpg),
+				TPG_TFO(tpg)->tpg_get_tag(tpg),
+				config_item_name(&lun->lun_group.cg_item),
+				config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
+				tg_pt_gp->tg_pt_gp_id);
+			
+			__core_alua_put_tg_pt_gp(port, 1);
+			spin_unlock(&port->sep_alua_lock);
+			
+			return(count);
+		}
+	}
+	spin_unlock(&port->sep_alua_lock);
+
+	if (!(tg_pt_gp_new = core_alua_get_tg_pt_gp_by_name(port, strstrip(buf))))
+		return(-ENODEV);
+
+	if (tg_pt_gp) {
+		core_alua_put_tg_pt_gp(port, 0);
+		move = 1;
+	}
+	core_alua_attach_tg_pt_gp(port, tg_pt_gp_new);
+
+	printk("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA Target Port"
+		" Group: core/alua/tg_pt_gps/%s, ID: %hu\n", (move) ?
+		"Moving" : "Adding", TPG_TFO(tpg)->tpg_get_wwn(tpg),
+		TPG_TFO(tpg)->tpg_get_tag(tpg),
+		config_item_name(&lun->lun_group.cg_item),
+		config_item_name(&tg_pt_gp_new->tg_pt_gp_group.cg_item),
+		tg_pt_gp_new->tg_pt_gp_id);
+	
+	return(count);
+}
+
+EXPORT_SYMBOL(core_alua_store_tg_pt_gp_info);
+
 extern int core_setup_alua (se_device_t *dev)
 {
 	se_subsystem_dev_t *su_dev = dev->se_sub_dev;
@@ -147,9 +512,16 @@ extern int core_setup_alua (se_device_t *dev)
 		alua->alua_type = SPC3_ALUA_EMULATED;
 		printk("%s: Enabling ALUA Emulation for SPC-3 device\n",
 				TRANSPORT(dev)->name);
+		/*
+		 * Assoicate this se_device_t with the default ALUA
+		 * LUN Group.
+		 */
+		core_alua_attach_lu_gp(dev, se_global->default_lu_gp);	
+		printk("%s: Adding to default ALUA LU Group: core/alua"
+			"/lu_gps/default_lu_gp\n", TRANSPORT(dev)->name);
 	} else {
 		alua->alua_type = SPC2_ALUA_DISABLED;
-		printk("%s: Disabling ALUA for SPC-2 device\n",
+		printk("%s: Disabling ALUA Emulation for SPC-2 device\n",
 				TRANSPORT(dev)->name);
 	}
 
diff --git a/drivers/lio-core/target_core_alua.h b/drivers/lio-core/target_core_alua.h
index e08cbf4..335847a 100644
--- a/drivers/lio-core/target_core_alua.h
+++ b/drivers/lio-core/target_core_alua.h
@@ -33,6 +33,20 @@
 #define ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA		0x02
 
 extern int core_scsi3_emulate_report_target_port_groups (struct se_cmd_s *);
+extern struct t10_alua_lu_gp_s *core_alua_allocate_lu_gp (const char *);
+extern void core_alua_free_lu_gp (struct t10_alua_lu_gp_s *);
+extern struct t10_alua_lu_gp_s *core_alua_get_lu_gp_by_name (struct se_device_s *, const char *);
+extern void core_alua_attach_lu_gp (struct se_device_s *, struct t10_alua_lu_gp_s *);
+extern void __core_alua_put_lu_gp (struct se_device_s *, int);
+extern void core_alua_put_lu_gp (struct se_device_s *, int);
+extern struct t10_alua_tg_pt_gp_s *core_alua_allocate_tg_pt_gp (const char *);
+extern void core_alua_free_tg_pt_gp (struct t10_alua_tg_pt_gp_s *);
+extern struct t10_alua_tg_pt_gp_s *core_alua_get_tg_pt_gp_by_name (struct se_port_s *, const char *);
+extern void core_alua_attach_tg_pt_gp (struct se_port_s *, struct t10_alua_tg_pt_gp_s *);
+extern void __core_alua_put_tg_pt_gp (struct se_port_s *, int);
+extern void core_alua_put_tg_pt_gp (struct se_port_s *, int);
+extern ssize_t core_alua_show_tg_pt_gp_info (struct se_port_s *, char *);
+extern ssize_t core_alua_store_tg_pt_gp_info (struct se_port_s *, const char *, size_t);
 extern int core_setup_alua (struct se_device_s *);
 
 #endif // TARGET_CORE_ALUA_H
diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index a5208e8..08859a3 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -189,6 +189,28 @@ typedef struct t10_alua_s {
 	t10_alua_index_t alua_type;	
 } ____cacheline_aligned t10_alua_t;
 
+typedef struct t10_alua_lu_gp_s {
+	u16	lu_gp_id;
+	int	lu_gp_alua_access_state;
+	u32	lu_gp_members;
+	atomic_t lu_gp_ref_cnt;
+	spinlock_t lu_gp_ref_lock;
+	struct config_group lu_gp_group;
+	struct list_head lu_gp_list;
+	struct list_head lu_gp_ref_list;
+} ____cacheline_aligned t10_alua_lu_gp_t;
+
+typedef struct t10_alua_tg_pt_gp_s {
+	u16	tg_pt_gp_id;
+	int	tg_pt_gp_alua_access_state;
+	u32	tg_pt_gp_members;
+	atomic_t tg_pt_gp_ref_cnt;
+	spinlock_t tg_pt_gp_ref_lock;
+	struct config_group tg_pt_gp_group;
+	struct list_head tg_pt_gp_list;
+	struct list_head tg_pt_gp_ref_list;
+} ____cacheline_aligned t10_alua_tg_pt_gp_t;
+
 typedef struct t10_evpd_s {
 	unsigned char device_identifier[INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN];
 	int protocol_identifier_set;
@@ -580,12 +602,15 @@ typedef struct se_device_s {
 	spinlock_t		execute_task_lock;
 	spinlock_t		state_task_lock;
 	spinlock_t		dev_reservation_lock;
+	spinlock_t		dev_alua_lock;
 	spinlock_t		dev_state_lock;
 	spinlock_t		dev_status_lock;
 	spinlock_t		dev_status_thr_lock;
 	spinlock_t		se_port_lock;
 	struct se_node_acl_s	*dev_reserved_node_acl; /* Used for legacy SPC-2 reservationsa */
+	struct t10_alua_lu_gp_s *dev_alua_lu_gp;	/* Used for ALUA Logical Unit Groups */
 	struct t10_pr_registration_s *dev_pr_res_holder; /* Used for SPC-3 Persistent Reservations */
+	struct list_head	dev_lu_gp_list;
 	struct list_head	dev_sep_list;
 	struct timer_list		dev_status_timer;
 	struct task_struct		*process_thread; /* Pointer to descriptor for processing thread */
@@ -672,9 +697,12 @@ typedef struct se_port_s {
         u32             sep_index;
         scsi_port_stats_t sep_stats;
 #endif
+	spinlock_t	sep_alua_lock;
+	struct t10_alua_tg_pt_gp_s *sep_alua_tg_pt_gp; /* Used for ALUA Target Port Groups */
         struct se_lun_s *sep_lun;
         struct se_portal_group_s *sep_tpg;
         struct list_head sep_list;
+	struct list_head sep_tg_pt_gp_list;
 } ____cacheline_aligned se_port_t;
 
 typedef struct se_portal_group_s {
@@ -695,11 +723,25 @@ typedef struct se_portal_group_s {
 #define TPG_TFO(se_tpg)		((struct target_core_fabric_ops *)(se_tpg)->se_tpg_tfo)
 
 typedef struct se_global_s {
+	u16			alua_lu_gps_counter;
+	u16			alua_tg_pt_gps_counter;
 	u32			in_shutdown;
+	u32			alua_lu_gps_count;
+	u32			alua_tg_pt_gps_count;
+	struct config_group	target_core_hbagroup;
+	struct config_group	alua_group;
+	struct config_group	alua_lu_gps_group;
+	struct config_group	alua_tg_pt_gps_group;
+	struct list_head	g_lu_gps_list;
+	struct list_head	g_tg_pt_gps_list;
 	struct list_head	g_se_tpg_list;
         struct se_plugin_class_s *plugin_class_list;
         se_hba_t                *hba_list;
+	t10_alua_lu_gp_t	*default_lu_gp;
+	t10_alua_tg_pt_gp_t	*default_tg_pt_gp;
 	spinlock_t		hba_lock;
+	spinlock_t		lu_gps_lock;
+	spinlock_t		tg_pt_gps_lock;
 	spinlock_t		plugin_class_lock;
 #ifdef DEBUG_DEV
         spinlock_t              debug_dev_lock;
-- 
1.5.4.1



