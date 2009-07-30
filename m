From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/22] fcoe,
	libfc: adds exchange manager(EM) anchor list per lport and related
	APIs
Date: Wed, 29 Jul 2009 17:05:00 -0700
Message-ID: <20090730000459.24658.80908.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39498 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbZG3AE7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:59 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Adds EM list using a anchor struct fc_exch_mgr_anchor, anchor is used
to allow same EM instance sharing across more than one lport on a eth
device, this implementation is per discussed design posted at
http://www.open-fcoe.org/pipermail/devel/2009-June/002566.html.

The shared EM is required for multiple lports on eth device when
using multiple VLANs or NPIV.

Adds fc_exch_mgr_add API to add a EM to the lport and fc_exch_mgr_del
API to delete previously added EM.

Also adds function fc_exch_mgr_destroy() to destroy allocated EM.
The kref is added to the EM to keep track of EM usage count, the EM is
destroyed when no longer in use upon kref reaching to zero.

The caller can specify match function to fc_exch_mgr_add, this
will be used in determining exchange allocation from its EM or not.

Moved calling of fcoe_em_config below fcoe_libfc_config calling,
so that list head lp->ema_list is initialized before configuring
EM.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c      |   14 ++++++------
 drivers/scsi/libfc/fc_exch.c  |   48 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_lport.c |    1 +
 include/scsi/libfc.h          |   24 +++++++++++++++++++++
 4 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 14a4017..719a99d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -603,18 +603,18 @@ static int fcoe_if_create(struct net_device *netdev)
 		goto out_netdev_cleanup;
 	}
 
-	/* lport exch manager allocation */
-	rc = fcoe_em_config(lp);
+	/* Initialize the library */
+	rc = fcoe_libfc_config(lp, &fcoe_libfc_fcn_templ);
 	if (rc) {
-		FCOE_NETDEV_DBG(netdev, "Could not configure the EM for the "
+		FCOE_NETDEV_DBG(netdev, "Could not configure libfc for the "
 				"interface\n");
-		goto out_netdev_cleanup;
+		goto out_lp_destroy;
 	}
 
-	/* Initialize the library */
-	rc = fcoe_libfc_config(lp, &fcoe_libfc_fcn_templ);
+	/* lport exch manager allocation */
+	rc = fcoe_em_config(lp);
 	if (rc) {
-		FCOE_NETDEV_DBG(netdev, "Could not configure libfc for the "
+		FCOE_NETDEV_DBG(netdev, "Could not configure the EM for the "
 				"interface\n");
 		goto out_lp_destroy;
 	}
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index cab5499..f1fa2b1 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -55,6 +55,7 @@ static struct kmem_cache *fc_em_cachep;        /* cache for exchanges */
  */
 struct fc_exch_mgr {
 	enum fc_class	class;		/* default class for sequences */
+	struct kref	kref;		/* exchange mgr reference count */
 	spinlock_t	em_lock;	/* exchange manager lock,
 					   must be taken before ex_lock */
 	u16		last_xid;	/* last allocated exchange ID */
@@ -84,6 +85,12 @@ struct fc_exch_mgr {
 };
 #define	fc_seq_exch(sp) container_of(sp, struct fc_exch, seq)
 
+struct fc_exch_mgr_anchor {
+	struct list_head ema_list;
+	struct fc_exch_mgr *mp;
+	bool (*match)(struct fc_frame *);
+};
+
 static void fc_exch_rrq(struct fc_exch *);
 static void fc_seq_ls_acc(struct fc_seq *);
 static void fc_seq_ls_rjt(struct fc_seq *, enum fc_els_rjt_reason,
@@ -1729,6 +1736,47 @@ reject:
 	fc_frame_free(fp);
 }
 
+struct fc_exch_mgr_anchor *fc_exch_mgr_add(struct fc_lport *lport,
+					   struct fc_exch_mgr *mp,
+					   bool (*match)(struct fc_frame *))
+{
+	struct fc_exch_mgr_anchor *ema;
+
+	ema = kmalloc(sizeof(*ema), GFP_ATOMIC);
+	if (!ema)
+		return ema;
+
+	ema->mp = mp;
+	ema->match = match;
+	/* add EM anchor to EM anchors list */
+	list_add_tail(&ema->ema_list, &lport->ema_list);
+	kref_get(&mp->kref);
+	return ema;
+}
+EXPORT_SYMBOL(fc_exch_mgr_add);
+
+static void fc_exch_mgr_destroy(struct kref *kref)
+{
+	struct fc_exch_mgr *mp = container_of(kref, struct fc_exch_mgr, kref);
+
+	/*
+	 * The total exch count must be zero
+	 * before freeing exchange manager.
+	 */
+	WARN_ON(mp->total_exches != 0);
+	mempool_destroy(mp->ep_pool);
+	kfree(mp);
+}
+
+void fc_exch_mgr_del(struct fc_exch_mgr_anchor *ema)
+{
+	/* remove EM anchor from EM anchors list */
+	list_del(&ema->ema_list);
+	kref_put(&ema->mp->kref, fc_exch_mgr_destroy);
+	kfree(ema);
+}
+EXPORT_SYMBOL(fc_exch_mgr_del);
+
 struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 				      enum fc_class class,
 				      u16 min_xid, u16 max_xid)
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a430335..ca8ea26 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1618,6 +1618,7 @@ int fc_lport_init(struct fc_lport *lport)
 	if (lport->link_supported_speeds & FC_PORTSPEED_10GBIT)
 		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_10GBIT;
 
+	INIT_LIST_HEAD(&lport->ema_list);
 	return 0;
 }
 EXPORT_SYMBOL(fc_lport_init);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 04db7a9..b381b1c 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -348,6 +348,7 @@ static inline bool fc_fcp_is_read(const struct fc_fcp_pkt *fsp)
  */
 
 struct fc_exch_mgr;
+struct fc_exch_mgr_anchor;
 
 /*
  * Sequence.
@@ -709,6 +710,7 @@ struct fc_lport {
 	/* Associations */
 	struct Scsi_Host	*host;
 	struct fc_exch_mgr	*emp;
+	struct list_head	ema_list;
 	struct fc_rport		*dns_rp;
 	struct fc_rport		*ptp_rp;
 	void			*scsi_priv;
@@ -964,6 +966,28 @@ int fc_elsct_init(struct fc_lport *lp);
 int fc_exch_init(struct fc_lport *lp);
 
 /*
+ * Adds Exchange Manager (EM) mp to lport.
+ *
+ * Adds specified mp to lport using struct fc_exch_mgr_anchor,
+ * the struct fc_exch_mgr_anchor allows same EM sharing by
+ * more than one lport with their specified match function,
+ * the match function is used in allocating exchange from
+ * added mp.
+ */
+struct fc_exch_mgr_anchor *fc_exch_mgr_add(struct fc_lport *lport,
+					   struct fc_exch_mgr *mp,
+					   bool (*match)(struct fc_frame *));
+
+/*
+ * Deletes Exchange Manager (EM) from lport by removing
+ * its anchor ema from lport.
+ *
+ * If removed anchor ema was the last user of its associated EM
+ * then also destroys associated EM.
+ */
+void fc_exch_mgr_del(struct fc_exch_mgr_anchor *ema);
+
+/*
  * Allocates an Exchange Manager (EM).
  *
  * The EM manages exchanges for their allocation and

