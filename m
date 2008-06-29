From: michaelc@cs.wisc.edu
Subject: [PATCH 11/13] libfc: mv scsi pkt cache to module
Date: Sun, 29 Jun 2008 13:24:01 -0500
Message-ID: <1214763843-5548-12-git-send-email-michaelc@cs.wisc.edu>
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
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578AbYF2SYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 14:24:11 -0400
In-Reply-To: <1214763843-5548-11-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

A per host cache is overkill. For other storage drivers we do
a cache per module. This moves the scsi pkt cache to the module
instead of per host.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libfc/fc_scsi.c |   78 +++++++++++++----------------------------
 1 files changed, 25 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/libfc/fc_scsi.c b/drivers/scsi/libfc/fc_scsi.c
index c41807b..257962a 100644
--- a/drivers/scsi/libfc/fc_scsi.c
+++ b/drivers/scsi/libfc/fc_scsi.c
@@ -38,6 +38,7 @@
 #include <scsi/libfc/fc_dbg.h>
 
 int openfc_debug;
+static struct kmem_cache *scsi_pkt_cachep;
 
 #define CMD_SP(Cmnd)		    ((Cmnd)->SCp.ptr)
 #define CMD_ENTRY_STATUS(Cmnd)	    ((Cmnd)->SCp.have_data_in)
@@ -115,7 +116,6 @@ struct fc_cmdq {
 };
 
 struct fc_scsi_internal {
-	struct	kmem_cache   *scsi_pkt_cachep;
 	struct fc_cmdq outstandingcmd[FC_MAX_OUTSTANDING_COMMANDS];
 	int	       current_cmd_indx;
 	____cacheline_aligned spinlock_t outstandingcmd_lock;
@@ -192,9 +192,8 @@ static void fc_scsi_srr_error(struct fc_scsi_pkt *, struct fc_frame *);
 static struct fc_scsi_pkt *fc_scsi_pkt_alloc(struct fc_lport *lp)
 {
 	struct fc_scsi_pkt *sp;
-	struct fc_scsi_internal *si = fc_get_scsi_internal(lp);
 
-	sp = kmem_cache_zalloc(si->scsi_pkt_cachep, 0);
+	sp = kmem_cache_zalloc(scsi_pkt_cachep, 0);
 	if (sp) {
 		sp->lp = (void *)lp;
 		atomic_set(&sp->ref_cnt, 1);
@@ -214,15 +213,11 @@ static struct fc_scsi_pkt *fc_scsi_pkt_alloc(struct fc_lport *lp)
  */
 static int fc_scsi_pkt_free(struct fc_scsi_pkt *sp)
 {
-	struct fc_lport *lp = sp->lp;
-	struct fc_scsi_internal *si = fc_get_scsi_internal(lp);
-
 	if (atomic_dec_and_test(&sp->ref_cnt)) {
-		if (sp->state == FC_SRB_FREE) {
-			kmem_cache_free(si->scsi_pkt_cachep, sp);
-		} else {
+		if (sp->state == FC_SRB_FREE)
+			kmem_cache_free(scsi_pkt_cachep, sp);
+		else
 			FC_DBG("freeing scsi_pkt not marked free\n");
-		}
 	}
 	return 0;
 }
@@ -237,40 +232,6 @@ static void fc_scsi_pkt_release(struct fc_scsi_pkt *sp)
 	fc_scsi_pkt_free(sp);
 }
 
-
-static int fc_destroy_scsi_slab(struct fc_lport *lp)
-{
-	int rc = -1;
-	struct fc_scsi_internal *si = fc_get_scsi_internal(lp);
-
-	if (si->scsi_pkt_cachep != NULL) {
-		kmem_cache_destroy(si->scsi_pkt_cachep);
-		si->scsi_pkt_cachep = NULL;
-		rc = 0;
-	}
-	return rc;
-}
-
-static int fc_create_scsi_slab(struct fc_lport *lp)
-{
-	struct fc_scsi_internal *si = fc_get_scsi_internal(lp);
-	char scsi_pkt_cachep_name[FC_SRB_CACHEP_NAME];
-
-	sprintf(scsi_pkt_cachep_name, "openfc%d", lp->host->host_no);
-
-	si->scsi_pkt_cachep =
-		kmem_cache_create(scsi_pkt_cachep_name,
-				  sizeof(struct fc_scsi_pkt) +
-				  0, 0, SLAB_HWCACHE_ALIGN,
-				  NULL);
-
-	if (si->scsi_pkt_cachep == NULL) {
-		FC_DBG("Unable to allocate SRB cache...module load failed!");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
 /*
  * Lock fc_scsi_pkt.
  * The outstandingcmd queue lock is used to serialize access to the fc_scsi_pkt.
@@ -2137,7 +2098,6 @@ EXPORT_SYMBOL(fc_change_queue_type);
  */
 void fc_put_dev(struct fc_lport *lp)
 {
-	fc_destroy_scsi_slab(lp);
 	kfree(fc_get_scsi_internal(lp));
 	lp->scsi_priv = NULL;
 }
@@ -2160,14 +2120,6 @@ int fc_scsi_init(struct fc_lport *lp,
 	lp->scsi_priv = (void*)si;
 
 	/*
-	 * create slab for pkt buffer
-	 */
-	if (fc_create_scsi_slab(lp) < 0) {
-		FC_DBG("scsi pkt slab create failed");
-		return -1;
-	}
-
-	/*
 	 * we will use openfc's scsi i/f only when lower level driver
 	 * does not have a fast path.
 	 */
@@ -2184,3 +2136,23 @@ int fc_scsi_init(struct fc_lport *lp,
 	return 0;
 }
 EXPORT_SYMBOL(fc_scsi_init);
+
+static int __init libfc_init(void)
+{
+	scsi_pkt_cachep = kmem_cache_create("libfc_scsi_pkt",
+					    sizeof(struct fc_scsi_pkt),
+					    0, SLAB_HWCACHE_ALIGN, NULL);
+	if (scsi_pkt_cachep == NULL) {
+		FC_DBG("Unable to allocate SRB cache...module load failed!");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void __exit libfc_exit(void)
+{
+	kmem_cache_destroy(scsi_pkt_cachep);
+}
+
+module_init(libfc_init);
+module_exit(libfc_exit);
-- 
1.5.4.1

