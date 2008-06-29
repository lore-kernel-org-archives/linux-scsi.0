From: michaelc@cs.wisc.edu
Subject: [PATCH 12/13] libfc: mv em exch cache to module
Date: Sun, 29 Jun 2008 13:24:02 -0500
Message-ID: <1214763843-5548-13-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-4-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-5-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-6-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-7-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-8-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-9-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-10-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-11-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-12-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520AbYF2SYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 14:24:11 -0400
In-Reply-To: <1214763843-5548-12-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

A per host cache is overkill. For other storage drivers we do
a cache per module. This moves the em exch cache to the module
instead of per host.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/fcoe/fcoe_if.c  |    2 +-
 drivers/scsi/libfc/fc_exch.c |   35 +++++++++++++++++------------------
 drivers/scsi/libfc/fc_scsi.c |    9 ++++++++-
 include/scsi/libfc/libfc.h   |    7 ++++++-
 4 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_if.c b/drivers/scsi/fcoe/fcoe_if.c
index 3c21e05..fe9364f 100644
--- a/drivers/scsi/fcoe/fcoe_if.c
+++ b/drivers/scsi/fcoe/fcoe_if.c
@@ -489,7 +489,7 @@ int fcoe_create_interface(const char *ifname)
 	shost->max_channel = 0;
 
 	/* Allocate an EM for this driver */
-	lp->emp = fc_exch_mgr_alloc(FC_CLASS_3, 0, 0);
+	lp->emp = fc_exch_mgr_alloc(FC_CLASS_3, 0);
 	if (!lp->emp)
 		goto out_host_put;
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index d861963..5f2433c 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -37,7 +37,7 @@
  * fc_exch_debug can be set in debugger or at compile time to get more logs.
  */
 static int fc_exch_debug;
-
+static struct kmem_cache *em_cachep;	/* cache for exchanges */
 
 /*
  * Structure and function definitions for managing Fibre Channel Exchanges
@@ -115,8 +115,6 @@ struct fc_exch_mgr {
 	enum fc_class	em_class;	/* default class for sequences */
 	spinlock_t 	em_lock;	/* exchange manager lock */
 	fc_xid_t	em_xid;		/* default initiator exchange IDs */
-	char em_name[16];		/* cache name string */
-	struct 	kmem_cache	*em_cp;	/* cache for exchanges */
 	void	*em_llddata;		/* Points to LLD privdate data */
 	u32	em_exch_total;		/* total allocated exchanges */
 	struct list_head	em_exch_list;	/* allocated exchanges list */
@@ -1662,7 +1660,6 @@ reject:
 }
 
 struct fc_exch_mgr *fc_exch_mgr_alloc(enum fc_class class,
-				      u32 em_idx,
 				      u32 privsize)
 {
 	struct fc_exch_mgr *mp;
@@ -1679,17 +1676,6 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(enum fc_class class,
 		INIT_LIST_HEAD(&mp->em_exch_list);
 
 		spin_lock_init(&mp->em_lock);
-
-		sprintf(mp->em_name, "libfcEM%d", em_idx);
-		mp->em_cp = kmem_cache_create(mp->em_name,
-					      sizeof(struct fc_exch),
-					      0, SLAB_HWCACHE_ALIGN,
-					      NULL);
-
-		if (!mp->em_cp) {
-			kfree(mp);
-			mp = NULL;
-		}
 	}
 	return mp;
 }
@@ -1699,7 +1685,6 @@ void fc_exch_mgr_free(struct fc_exch_mgr *mp)
 {
 	WARN_ON(!mp);
 
-	kmem_cache_destroy(mp->em_cp);
 	kfree(mp);
 }
 EXPORT_SYMBOL(fc_exch_mgr_free);
@@ -1708,7 +1693,7 @@ struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp, fc_xid_t ex_id)
 {
 	struct fc_exch *ep = NULL;
 
-	ep = kmem_cache_zalloc(mp->em_cp, GFP_ATOMIC);
+	ep = kmem_cache_zalloc(em_cachep, GFP_ATOMIC);
 	if (ep) {
 		ep->ex_f_ctl = FC_FC_FIRST_SEQ;	/* next seq is first seq */
 		ep->ex_rx_id = FC_XID_UNKNOWN;
@@ -1752,7 +1737,7 @@ static void fc_exch_release(struct fc_exch *ep)
 		mp->em_exch_total--;
 		list_del(&ep->ex_list);
 		spin_unlock_bh(&mp->em_lock);
-		kmem_cache_free(mp->em_cp, ep);
+		kmem_cache_free(em_cachep, ep);
 	}
 }
 
@@ -1984,3 +1969,17 @@ int fc_exch_init(struct fc_lport *lp,
 	return 0;
 }
 EXPORT_SYMBOL(fc_exch_init);
+
+int fc_setup_exch_mgr(void)
+{
+	em_cachep = kmem_cache_create("libfc_em", sizeof(struct fc_exch),
+				      0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!em_cachep)
+		return -ENOMEM;
+	return 0;
+}
+
+void fc_destroy_exch_mgr(void)
+{
+	kmem_cache_destroy(em_cachep);
+}
diff --git a/drivers/scsi/libfc/fc_scsi.c b/drivers/scsi/libfc/fc_scsi.c
index 257962a..2ca1db2 100644
--- a/drivers/scsi/libfc/fc_scsi.c
+++ b/drivers/scsi/libfc/fc_scsi.c
@@ -2139,6 +2139,8 @@ EXPORT_SYMBOL(fc_scsi_init);
 
 static int __init libfc_init(void)
 {
+	int rc;
+
 	scsi_pkt_cachep = kmem_cache_create("libfc_scsi_pkt",
 					    sizeof(struct fc_scsi_pkt),
 					    0, SLAB_HWCACHE_ALIGN, NULL);
@@ -2146,12 +2148,17 @@ static int __init libfc_init(void)
 		FC_DBG("Unable to allocate SRB cache...module load failed!");
 		return -ENOMEM;
 	}
-	return 0;
+
+	rc = fc_setup_exch_mgr();
+	if (rc)
+		kmem_cache_destroy(scsi_pkt_cachep);
+	return rc;
 }
 
 static void __exit libfc_exit(void)
 {
 	kmem_cache_destroy(scsi_pkt_cachep);
+	fc_destroy_exch_mgr();
 }
 
 module_init(libfc_init);
diff --git a/include/scsi/libfc/libfc.h b/include/scsi/libfc/libfc.h
index 49cabad..3014bb6 100644
--- a/include/scsi/libfc/libfc.h
+++ b/include/scsi/libfc/libfc.h
@@ -750,7 +750,6 @@ int fc_exch_init(struct fc_lport *lp,
  * help the LLD manage the exchange ID allocation.
  */
 struct fc_exch_mgr *fc_exch_mgr_alloc(enum fc_class class,
-				      u32 em_idx,
 				      u32 privsize);
 
 
@@ -854,4 +853,10 @@ void fc_get_rport_loss_tmo(struct fc_rport *rport);
 void fc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout);
 struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *);
 
+/*
+ * module setup functions.
+ */
+int fc_setup_exch_mgr(void);
+void fc_destroy_exch_mgr(void);
+
 #endif /* _LIBFC_H_ */
-- 
1.5.4.1

