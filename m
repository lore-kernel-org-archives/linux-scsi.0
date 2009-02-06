From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/6] [Target_Core_Mod/ALUA]: Add ALUA struct kmem_caches
	and update EVPD 0x83 information
Date: Fri, 06 Feb 2009 00:00:38 -0800
Message-ID: <1233907238.12375.364.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:32900 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753349AbZBFIBp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2009 03:01:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, Rafiu Fakunle <rafiu@openfiler.com>

>From 26cab633d02f548bba95b2b6c4677ce493165854 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 5 Feb 2009 23:18:29 -0800
Subject: [PATCH 4/6] [Target_Core_Mod/ALUA]: Add ALUA struct kmem_caches and update EVPD 0x83 information

This patch adds t10_alua_lu_gp_cache and t10_alua_tg_pt_gp_cache for use with
ALUA Logical Unit Group and Target Port Group emulation.

This patch also updates transport_generic_emulate_inquiry() to set the values
from different ALUA Logical Unit Group and Target Port Group assocations in
EVPD 0x83 response data.

Also, this patch also adds the logic EVPD 0x83 Target port group identifier and
 Logical Unit Group identifier are not returned in response data unless said
T10_ALUA(se_subsystem_dev_t)->alue_type == SPC3_ALUA_EMULATED.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_transport.c |   56 ++++++++++++++++++++++++++----
 1 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 28f3126..82ccd3c 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -209,6 +209,8 @@ struct kmem_cache *se_cmd_cache = NULL;
 struct kmem_cache *se_task_cache = NULL;
 struct kmem_cache *se_sess_cache = NULL;
 struct kmem_cache *t10_pr_reg_cache = NULL;
+struct kmem_cache *t10_alua_lu_gp_cache = NULL;
+struct kmem_cache *t10_alua_tg_pt_gp_cache = NULL;
 
 EXPORT_SYMBOL(se_global);
 static int transport_generic_write_pending (se_cmd_t *);
@@ -254,8 +256,12 @@ extern int init_se_global (void)
 		return(-1);
 	};
 
+	INIT_LIST_HEAD(&global->g_lu_gps_list);
+	INIT_LIST_HEAD(&global->g_tg_pt_gps_list);
 	INIT_LIST_HEAD(&global->g_se_tpg_list);
 	spin_lock_init(&global->hba_lock);
+	spin_lock_init(&global->lu_gps_lock);
+	spin_lock_init(&global->tg_pt_gps_lock);
 	spin_lock_init(&global->plugin_class_lock);
 
 	if (!(se_cmd_cache = kmem_cache_create("se_cmd_cache",
@@ -280,6 +286,19 @@ extern int init_se_global (void)
 		printk(KERN_ERR "kmem_cache_create() for t10_pr_registration_t failed\n");
 		goto out;
 	}
+	if (!(t10_alua_lu_gp_cache = kmem_cache_create("t10_alua_lu_gp_cache",
+			sizeof(t10_alua_lu_gp_t), __alignof__(t10_alua_lu_gp_t),
+			0, NULL))) {
+		printk(KERN_ERR "kmem_cache_create() for t10_alua_lu_gp_cache failed\n");
+		goto out;
+	}
+	if (!(t10_alua_tg_pt_gp_cache = kmem_cache_create("t10_alua_tg_pt_gp_cache",
+			sizeof(t10_alua_tg_pt_gp_t), __alignof__(t10_alua_tg_pt_gp_t),
+			0, NULL))) {
+		printk(KERN_ERR "kmem_cache_create() for t10_alua_tg_pt_gp_cache failed\n");
+		goto out;
+	}
+
         if (!(global->hba_list = kzalloc((sizeof(se_hba_t) *
 				TRANSPORT_MAX_GLOBAL_HBAS), GFP_KERNEL))) {
                 TRACE_ERROR("Unable to allocate global->hba_list\n");
@@ -319,6 +338,10 @@ out:
 		kmem_cache_destroy(se_sess_cache);
 	if (t10_pr_reg_cache)
 		kmem_cache_destroy(t10_pr_reg_cache);
+	if (t10_alua_lu_gp_cache)
+		kmem_cache_destroy(t10_alua_lu_gp_cache);
+	if (t10_alua_tg_pt_gp_cache)
+		kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
 	kfree(global);
         return(-1);
 }
@@ -336,6 +359,8 @@ extern void release_se_global (void)
 	kmem_cache_destroy(se_task_cache);
 	kmem_cache_destroy(se_sess_cache);
 	kmem_cache_destroy(t10_pr_reg_cache);
+	kmem_cache_destroy(t10_alua_lu_gp_cache);
+	kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
 	kfree(global);
 
 	se_global = NULL;
@@ -2059,11 +2084,13 @@ extern se_device_t *transport_add_device_to_core_hba (
 	dev->transport		= transport;
 	atomic_set(&dev->active_cmds, 0);
 	INIT_LIST_HEAD(&dev->dev_sep_list);
+	INIT_LIST_HEAD(&dev->dev_lu_gp_list);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_create_sem);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_done_sem);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_sem);
 	spin_lock_init(&dev->execute_task_lock);
 	spin_lock_init(&dev->state_task_lock);
+	spin_lock_init(&dev->dev_alua_lock);
 	spin_lock_init(&dev->dev_reservation_lock);
 	spin_lock_init(&dev->dev_status_lock);
 	spin_lock_init(&dev->dev_status_thr_lock);
@@ -4036,7 +4063,7 @@ extern int transport_generic_emulate_inquiry (
 	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
 	unsigned char *cdb = T_TASK(cmd)->t_task_cdb;
 	unsigned char *iqn_sn;
-	u32 vend_len, prod_len, iqn_sn_len, se_location_len;
+	u32 prod_len, iqn_sn_len, se_location_len;
 	u32 unit_serial_len, off = 0;
 	u16 len = 0;
 	
@@ -4165,9 +4192,11 @@ extern int transport_generic_emulate_inquiry (
 		 */
 check_port:
 		if ((port = lun->lun_sep)) {	
+			t10_alua_lu_gp_t *lu_gp_p;
+			t10_alua_tg_pt_gp_t *tg_pt_gp_p;
 			u32 padding, scsi_name_len;
-			u16 lun_gp = 0;	// Set to zero for implict ALUA
-			u16 tg_pg_i = 0; // Set to zero for implict ALUA
+			u16 lu_gp_id = 0;
+			u16 tg_pt_gp_id = 0;
 			u16 tpgt;
 
 			tpg = port->sep_tpg;
@@ -4199,10 +4228,18 @@ check_port:
 			 * section 7.5.1 Table 362 
 			 */
 check_tpgi:
+			if (T10_ALUA(dev->se_sub_dev)->alua_type != SPC3_ALUA_EMULATED)			
+				goto check_scsi_name;
+
 			if (((len + 4) + 8) > cmd->data_length) {
 				len += 8;
 				goto check_lu_gp;
 			}
+			spin_lock(&port->sep_alua_lock);
+			if ((tg_pt_gp_p = port->sep_alua_tg_pt_gp))
+				tg_pt_gp_id = tg_pt_gp_p->tg_pt_gp_id;
+			spin_unlock(&port->sep_alua_lock);
+
 			buf[off] = (TPG_TFO(tpg)->get_fabric_proto_ident() << 4);
 			buf[off++] |= 0x1; // CODE SET == Binary
 			buf[off] = 0x80; // Set PIV=1
@@ -4211,8 +4248,8 @@ check_tpgi:
 			off++; // Skip over Reserved
 			buf[off++] = 4; /* DESIGNATOR LENGTH */
 			off += 2; // Skip over Reserved Field
-			buf[off++] = ((tg_pg_i >> 8) & 0xff);
-			buf[off++] = (tg_pg_i & 0xff);
+			buf[off++] = ((tg_pt_gp_id >> 8) & 0xff);
+			buf[off++] = (tg_pt_gp_id & 0xff);
 			len += 8; // Header size + Designation descriptor
 			/*
 			 * Logical Unit Group identifier, see spc4r17 section 7.7.3.8
@@ -4222,13 +4259,18 @@ check_lu_gp:
 				len += 8;
 				goto check_scsi_name;
 			}
+			spin_lock(&dev->dev_alua_lock);
+			if ((lu_gp_p = dev->dev_alua_lu_gp))
+				lu_gp_id = lu_gp_p->lu_gp_id;
+			spin_unlock(&dev->dev_alua_lock);
+
 			buf[off++] |= 0x1; // CODE SET == Binary
 			buf[off++] |= 0x6; // DESIGNATOR TYPE == Logical Unit Group identifier
 			off++; // Skip over Reserved
 			buf[off++] = 4; /* DESIGNATOR LENGTH */
 			off += 2; // Skip over Reserved Field
-			buf[off++] = ((lun_gp >> 8) & 0xff);
-			buf[off++] = (lun_gp & 0xff);
+			buf[off++] = ((lu_gp_id >> 8) & 0xff);
+			buf[off++] = (lu_gp_id & 0xff);
 			len += 8; // Header size + Designation descriptor
 			/*
 			 * SCSI name string designator, see spc4r17 section 7.7.3.11
-- 
1.5.4.1



