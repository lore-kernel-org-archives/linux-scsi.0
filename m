From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/22] fcoe,
	libfc: adds offload EM per eth device with only single xid range per
	EM
Date: Wed, 29 Jul 2009 17:05:21 -0700
Message-ID: <20090730000521.24658.75102.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29392 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481AbZG3AFV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:05:21 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Updates fcoe_em_config to allocate a single instance of sharable offload
EM for supported lp->lro_xid per eth device, and then share this EM
for subsequently more lports creation on same eth device (e.g when using
VLAN).

Adds tiny fcoe_oem_match function for offload EM to return true for read
types IO to have read IO exchanges allocated from offload shared EM.

Removes fc_em_alloc_xid function completely which was needed to manage
two xid ranges within a EM, this is not needed any more with allocation
of separate sharable offload EM per eth device. Instead this patch adds
simple xid allocation logic to manage single xid range.

Adds fc_exch_em_alloc with mp->next_xid as cursor to allocate new xid
from single xid range of EM, uses mp->next_xid instead removed mp->last_xid
which slightly increase probability of finding empty xid on exch allocation.

Removes restriction of not allowing use of xid zero along with changing
two xid range change to single xid range.

Makes fc_fcp_ddp_setup calling conditional to only xid allocated from
shared offload EM.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c     |   67 +++++++++++++++++++++++++++++-
 drivers/scsi/fcoe/fcoe.h     |    3 +
 drivers/scsi/libfc/fc_exch.c |   94 ++++++++----------------------------------
 3 files changed, 85 insertions(+), 79 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 86410b9..0306aa9 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -415,6 +415,17 @@ static int fcoe_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
 	return 0;
 }
 
+/*
+ * fcoe_oem_match() - match for read types IO
+ * @fp: the fc_frame for new IO.
+ *
+ * Returns : true for read types IO, otherwise returns false.
+ */
+bool fcoe_oem_match(struct fc_frame *fp)
+{
+	return fc_fcp_is_read(fr_fsp(fp));
+}
+
 /**
  * fcoe_em_config() - allocates em for this lport
  * @lp: the port that em is to allocated for
@@ -425,9 +436,61 @@ static int fcoe_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
  */
 static inline int fcoe_em_config(struct fc_lport *lp)
 {
-	if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, FCOE_MIN_XID,
-			       FCOE_MAX_XID, NULL))
+	struct fcoe_softc *fc = lport_priv(lp);
+	struct fcoe_softc *oldfc = NULL;
+	u16 min_xid = FCOE_MIN_XID;
+	u16 max_xid = FCOE_MAX_XID;
+
+	/*
+	 * Check if need to allocate an em instance for
+	 * offload exchange ids to be shared across all VN_PORTs/lport.
+	 */
+	if (!lp->lro_enabled || !lp->lro_xid || (lp->lro_xid >= max_xid)) {
+		lp->lro_xid = 0;
+		goto skip_oem;
+	}
+
+	/*
+	 * Reuse existing offload em instance in case
+	 * it is already allocated on phys_dev.
+	 */
+	list_for_each_entry(oldfc, &fcoe_hostlist, list) {
+		if (oldfc->phys_dev == fc->phys_dev) {
+			fc->oem = oldfc->oem;
+			break;
+		}
+	}
+
+	if (fc->oem) {
+		if (!fc_exch_mgr_add(lp, fc->oem, fcoe_oem_match)) {
+			printk(KERN_ERR "fcoe_em_config: failed to add "
+			       "offload em:%p on interface:%s\n",
+			       fc->oem, fc->real_dev->name);
+			return -ENOMEM;
+		}
+	} else {
+		fc->oem = fc_exch_mgr_alloc(lp, FC_CLASS_3,
+					    FCOE_MIN_XID, lp->lro_xid,
+					    fcoe_oem_match);
+		if (!fc->oem) {
+			printk(KERN_ERR "fcoe_em_config: failed to allocate "
+			       "em for offload exches on interface:%s\n",
+			       fc->real_dev->name);
+			return -ENOMEM;
+		}
+	}
+
+	/*
+	 * Exclude offload EM xid range from next EM xid range.
+	 */
+	min_xid += lp->lro_xid + 1;
+
+skip_oem:
+	if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, min_xid, max_xid, NULL)) {
+		printk(KERN_ERR "fcoe_em_config: failed to "
+		       "allocate em on interface %s\n", fc->real_dev->name);
 		return -ENOMEM;
+	}
 
 	return 0;
 }
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 0d724fa..6905efc 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -37,7 +37,7 @@
 
 #define FCOE_MAX_OUTSTANDING_COMMANDS	1024
 
-#define FCOE_MIN_XID		0x0001	/* the min xid supported by fcoe_sw */
+#define FCOE_MIN_XID		0x0000	/* the min xid supported by fcoe_sw */
 #define FCOE_MAX_XID		0x07ef	/* the max xid supported by fcoe_sw */
 
 unsigned int fcoe_debug_logging;
@@ -81,6 +81,7 @@ struct fcoe_softc {
 	struct list_head list;
 	struct net_device *real_dev;
 	struct net_device *phys_dev;		/* device with ethtool_ops */
+	struct fc_exch_mgr *oem;		/* offload exchange manger */
 	struct packet_type  fcoe_packet_type;
 	struct packet_type  fip_packet_type;
 	struct sk_buff_head fcoe_pending_queue;
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 324589a..11ddd11 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -58,7 +58,7 @@ struct fc_exch_mgr {
 	struct kref	kref;		/* exchange mgr reference count */
 	spinlock_t	em_lock;	/* exchange manager lock,
 					   must be taken before ex_lock */
-	u16		last_xid;	/* last allocated exchange ID */
+	u16		next_xid;	/* next possible free exchange ID */
 	u16		min_xid;	/* min exchange ID */
 	u16		max_xid;	/* max exchange ID */
 	u16		max_read;	/* max exchange ID for read */
@@ -464,68 +464,21 @@ static struct fc_seq *fc_seq_alloc(struct fc_exch *ep, u8 seq_id)
 	return sp;
 }
 
-/*
- * fc_em_alloc_xid - returns an xid based on request type
- * @lp : ptr to associated lport
- * @fp : ptr to the assocated frame
- *
- * check the associated fc_fsp_pkt to get scsi command type and
- * command direction to decide from which range this exch id
- * will be allocated from.
- *
- * Returns : 0 or an valid xid
- */
-static u16 fc_em_alloc_xid(struct fc_exch_mgr *mp, const struct fc_frame *fp)
-{
-	u16 xid, min, max;
-	u16 *plast;
-	struct fc_exch *ep = NULL;
-
-	if (mp->max_read) {
-		if (fc_fcp_is_read(fr_fsp(fp))) {
-			min = mp->min_xid;
-			max = mp->max_read;
-			plast = &mp->last_read;
-		} else {
-			min = mp->max_read + 1;
-			max = mp->max_xid;
-			plast = &mp->last_xid;
-		}
-	} else {
-		min = mp->min_xid;
-		max = mp->max_xid;
-		plast = &mp->last_xid;
-	}
-	xid = *plast;
-	do {
-		xid = (xid == max) ? min : xid + 1;
-		ep = mp->exches[xid - mp->min_xid];
-	} while ((ep != NULL) && (xid != *plast));
-
-	if (unlikely(ep))
-		xid = 0;
-	else
-		*plast = xid;
-
-	return xid;
-}
-
 /**
  * fc_exch_em_alloc() - allocate an exchange from a specified EM.
  * @lport:	ptr to the local port
  * @mp:		ptr to the exchange manager
- * @fp:		ptr to the FC frame
- * @xid:	input xid
  *
- * if xid is supplied zero then assign next free exchange ID
- * from exchange manager, otherwise use supplied xid.
- * Returns with exch lock held.
+ * Returns pointer to allocated fc_exch with exch lock held.
  */
 static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
-					struct fc_exch_mgr *mp,
-					struct fc_frame *fp, u16 xid)
+					struct fc_exch_mgr *mp)
 {
 	struct fc_exch *ep;
+	u16 min, max, xid;
+
+	min = mp->min_xid;
+	max = mp->max_xid;
 
 	/* allocate memory for exchange */
 	ep = mempool_alloc(mp->ep_pool, GFP_ATOMIC);
@@ -536,15 +489,14 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 	memset(ep, 0, sizeof(*ep));
 
 	spin_lock_bh(&mp->em_lock);
-	/* alloc xid if input xid 0 */
-	if (!xid) {
-		/* alloc a new xid */
-		xid = fc_em_alloc_xid(mp, fp);
-		if (!xid) {
-			printk(KERN_WARNING "libfc: Failed to allocate an exhange\n");
+	xid = mp->next_xid;
+	/* alloc a new xid */
+	while (mp->exches[xid - min]) {
+		xid = (xid == max) ? min : xid + 1;
+		if (xid == mp->next_xid)
 			goto err;
-		}
 	}
+	mp->next_xid = (xid == max) ? min : xid + 1;
 
 	fc_exch_hold(ep);	/* hold for exch in mp */
 	spin_lock_init(&ep->ex_lock);
@@ -597,7 +549,7 @@ struct fc_exch *fc_exch_alloc(struct fc_lport *lport, struct fc_frame *fp)
 
 	list_for_each_entry(ema, &lport->ema_list, ema_list) {
 		if (!ema->match || ema->match(fp)) {
-			ep = fc_exch_em_alloc(lport, ema->mp, fp, 0);
+			ep = fc_exch_em_alloc(lport, ema->mp);
 			if (ep)
 				return ep;
 		}
@@ -1817,7 +1769,7 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	struct fc_exch_mgr *mp;
 	size_t len;
 
-	if (max_xid <= min_xid || min_xid == 0 || max_xid == FC_XID_UNKNOWN) {
+	if (max_xid <= min_xid || max_xid == FC_XID_UNKNOWN) {
 		FC_LPORT_DBG(lp, "Invalid min_xid 0x:%x and max_xid 0x:%x\n",
 			     min_xid, max_xid);
 		return NULL;
@@ -1826,7 +1778,6 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	/*
 	 * Memory need for EM
 	 */
-#define xid_ok(i, m1, m2) (((i) >= (m1)) && ((i) <= (m2)))
 	len = (max_xid - min_xid + 1) * (sizeof(struct fc_exch *));
 	len += sizeof(struct fc_exch_mgr);
 
@@ -1840,17 +1791,7 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	/* adjust em exch xid range for offload */
 	mp->min_xid = min_xid;
 	mp->max_xid = max_xid;
-	mp->last_xid = min_xid - 1;
-	mp->max_read = 0;
-	mp->last_read = 0;
-	if (lp->lro_enabled && xid_ok(lp->lro_xid, min_xid, max_xid)) {
-		mp->max_read = lp->lro_xid;
-		mp->last_read = min_xid - 1;
-		mp->last_xid = mp->max_read;
-	} else {
-		/* disable lro if no xid control over read */
-		lp->lro_enabled = 0;
-	}
+	mp->next_xid = min_xid;
 
 	INIT_LIST_HEAD(&mp->ex_list);
 	spin_lock_init(&mp->em_lock);
@@ -1922,7 +1863,8 @@ struct fc_seq *fc_exch_seq_send(struct fc_lport *lp,
 	fc_exch_setup_hdr(ep, fp, ep->f_ctl);
 	sp->cnt++;
 
-	fc_fcp_ddp_setup(fr_fsp(fp), ep->xid);
+	if (ep->xid <= lp->lro_xid)
+		fc_fcp_ddp_setup(fr_fsp(fp), ep->xid);
 
 	if (unlikely(lp->tt.frame_send(lp, fp)))
 		goto err;

