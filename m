From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ALUA]: Fix core_alua_free_*() locking
	logic
Date: Fri, 06 Feb 2009 01:01:49 -0800
Message-ID: <1233910909.12375.375.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:21494 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752095AbZBFJC4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2009 04:02:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, Rafiu Fakunle <rafiu@openfiler.com>

>From 1656e4dd155664a0b864c01a0f5d1fcdcddde4e7 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 6 Feb 2009 00:55:06 -0800
Subject: [PATCH] [Target_Core_Mod/ALUA]: Fix core_alua_free_*() locking logic

This patch releases the lu_gp->lu_gp_ref_lock in core_alua_free_lu_gp()
and tg_pt_gp->tg_pt_gp_ref_lock in core_alua_free_tg_pt_gp() before
clearing se_device_t->dev_alua_lu_gp and se_port_t->sep_alua_tg_pt_gp
pointers respectively.

It also moves list_del() in core_alua_free_lu_gp() and
core_alua_free_tg_pt_gp() to before the "loop through group list and release".
This is to prevent any concurrent ALUA association attempts by other
userspace processes into Target_Core_Mod/ConfigFS.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_alua.c |   42 ++++++++++++++++++++++++++--------
 1 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/lio-core/target_core_alua.c b/drivers/lio-core/target_core_alua.c
index b5f5d66..722be1a 100644
--- a/drivers/lio-core/target_core_alua.c
+++ b/drivers/lio-core/target_core_alua.c
@@ -166,21 +166,32 @@ again:
 extern void core_alua_free_lu_gp (t10_alua_lu_gp_t *lu_gp)
 {
 	se_device_t *dev, *dev_tmp;
+	/*
+	 * Once we have reached this point, config_item_put() has
+	 * already been called from target_core_alua_drop_lu_gp().
+	 * 
+	 * Here, we remove the *lu_gp from the global list so that
+	 * no associations can be made while we are releasing
+	 * t10_alua_lu_gp_t.
+	 */
+	spin_lock(&se_global->lu_gps_lock);
+	list_del(&lu_gp->lu_gp_list);
+	se_global->alua_lu_gps_count--;
+	spin_unlock(&se_global->lu_gps_lock);
 
 	spin_lock(&lu_gp->lu_gp_ref_lock);
 	list_for_each_entry_safe(dev, dev_tmp, &lu_gp->lu_gp_ref_list, dev_lu_gp_list) {
 		list_del(&dev->dev_lu_gp_list);	
+		spin_unlock(&lu_gp->lu_gp_ref_lock);
+
 		spin_lock(&dev->dev_alua_lock);
 		dev->dev_alua_lu_gp = NULL;
 		spin_unlock(&dev->dev_alua_lock);
+		
+		spin_lock(&lu_gp->lu_gp_ref_lock);
 	}
 	spin_unlock(&lu_gp->lu_gp_ref_lock);
 
-	spin_lock(&se_global->lu_gps_lock);
-	list_del(&lu_gp->lu_gp_list);
-	se_global->alua_lu_gps_count--;
-	spin_unlock(&se_global->lu_gps_lock);
-
 	kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
 	return;
 }
@@ -305,22 +316,33 @@ again:
 extern void core_alua_free_tg_pt_gp (t10_alua_tg_pt_gp_t *tg_pt_gp)
 {
 	se_port_t *port, *port_tmp;
+	/*
+	 * Once we have reached this point, config_item_put() has already
+	 * been called from target_core_alua_drop_tg_pt_gp().
+	 *
+	 * Here we remove *tg_pt_gp from the global list so that
+	 * no assications *OR* explict ALUA via SET_TARGET_PORT_GROUPS
+	 * can be made while we are releasing t10_alua_tg_pt_gp_t.
+	 */
+	spin_lock(&se_global->tg_pt_gps_lock);
+	list_del(&tg_pt_gp->tg_pt_gp_list);
+	se_global->alua_tg_pt_gps_counter--;
+	spin_unlock(&se_global->tg_pt_gps_lock);
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
 	list_for_each_entry_safe(port, port_tmp, &tg_pt_gp->tg_pt_gp_ref_list,
 			sep_tg_pt_gp_list) {
 		list_del(&port->sep_tg_pt_gp_list);
+		spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+
 		spin_lock(&port->sep_alua_lock);
 		port->sep_alua_tg_pt_gp = NULL;
 		spin_unlock(&port->sep_alua_lock);
+
+		spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
 
-	spin_lock(&se_global->tg_pt_gps_lock);
-	list_del(&tg_pt_gp->tg_pt_gp_list);
-	se_global->alua_tg_pt_gps_counter--;
-	spin_unlock(&se_global->tg_pt_gps_lock);
-
 	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
 	return;
 }
-- 
1.5.4.1



