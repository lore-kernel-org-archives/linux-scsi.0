From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/22] fcoe, fnic,
	libfc: modifies current code paths to use EM anchor list
Date: Wed, 29 Jul 2009 17:05:10 -0700
Message-ID: <20090730000510.24658.54897.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22573 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbZG3AFK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:05:10 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Modifies current code to use EM anchor list in EM allocation, EM free,
EM reset, exch allocation and exch lookup code paths.

 1. Modifies fc_exch_mgr_alloc to accept EM match function and then
    have allocated EM added to the lport using fc_exch_mgr_add API
    while also updating EM kref for newly added EM.

 2. Updates fc_exch_mgr_free API to accept only lport pointer instead
    EM and then have this API free all EMs of the lport from EM anchor
    list.

 3. Removes single lport pointer link from the EM, which was used in
    associating lport pointer in newly allocated exchange. Instead have
    lport pointer passed along new exchange allocation call path and
    then store passed lport pointer in newly allocated exchange, this
    will allow a single EM instance to be used across more than one
    lport and used in EM reset to reset only lport specific exchanges.

 4. Modifies fc_exch_mgr_reset to reset all EMs from the EM anchor list
    of the lport, adds additional exch lport pointer (ep->lp) check for
    shared EM case to reset exchange specific to a lport requested reset.

 5. Updates exch allocation API fc_exch_alloc to use EM anchor list and
    its anchor match func pointer. The fc_exch_alloc will walk the list
    of EMs until it finds a match, a match will be either null match
    func pointer or call to match function returning true value.

 6. Updates fc_exch_recv to accept incoming frame on local port using
    only lport pointer and frame pointer without specifying EM instance
    of incoming frame. Instead modified fc_exch_recv to locate EM for the
    incoming frame by matching xid of incoming frame against a EM xid range.
    This change was required to use EM list in libfc Rx path and after this
    change the lport fc_exch_mgr pointer emp is not needed anymore, so
    removed emp pointer.

 7. Updates fnic for removed lport emp pointer and above modified libfc APIs
    fc_exch_recv, fc_exch_mgr_alloc and fc_exch_mgr_free.

 8. Removes exch_get and exch_put from libfc_function_template as these
    are no longer needed with EM anchor list and its match function use.
    Also removes its default function fc_exch_get.

A defect this patch introduced regarding the libfc initialization order in
the fnic driver was fixed by Joe Eykholt <jeykholt@cisco.com>.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c      |   16 +--
 drivers/scsi/fcoe/libfcoe.c   |    2 
 drivers/scsi/fnic/fnic_fcs.c  |    2 
 drivers/scsi/fnic/fnic_main.c |   20 ++--
 drivers/scsi/libfc/fc_exch.c  |  191 +++++++++++++++++++++++++----------------
 include/scsi/libfc.h          |   48 ++--------
 6 files changed, 142 insertions(+), 137 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 719a99d..ebf2e20 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -423,11 +423,8 @@ static int fcoe_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
  */
 static inline int fcoe_em_config(struct fc_lport *lp)
 {
-	BUG_ON(lp->emp);
-
-	lp->emp = fc_exch_mgr_alloc(lp, FC_CLASS_3,
-				    FCOE_MIN_XID, FCOE_MAX_XID);
-	if (!lp->emp)
+	if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, FCOE_MIN_XID,
+			       FCOE_MAX_XID, NULL))
 		return -ENOMEM;
 
 	return 0;
@@ -478,8 +475,7 @@ static int fcoe_if_destroy(struct net_device *netdev)
 	scsi_remove_host(lp->host);
 
 	/* There are no more rports or I/O, free the EM */
-	if (lp->emp)
-		fc_exch_mgr_free(lp->emp);
+	fc_exch_mgr_free(lp);
 
 	/* Free existing skbs */
 	fcoe_clean_pending_queue(lp);
@@ -634,7 +630,7 @@ static int fcoe_if_create(struct net_device *netdev)
 	return rc;
 
 out_lp_destroy:
-	fc_exch_mgr_free(lp->emp); /* Free the EM */
+	fc_exch_mgr_free(lp);
 out_netdev_cleanup:
 	fcoe_netdev_cleanup(fc);
 out_host_put:
@@ -1277,7 +1273,7 @@ int fcoe_percpu_receive_thread(void *arg)
 		fh = fc_frame_header_get(fp);
 		if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA &&
 		    fh->fh_type == FC_TYPE_FCP) {
-			fc_exch_recv(lp, lp->emp, fp);
+			fc_exch_recv(lp, fp);
 			continue;
 		}
 		if (fr_flags(fp) & FCPHF_CRC_UNCHECKED) {
@@ -1298,7 +1294,7 @@ int fcoe_percpu_receive_thread(void *arg)
 			fc_frame_free(fp);
 			continue;
 		}
-		fc_exch_recv(lp, lp->emp, fp);
+		fc_exch_recv(lp, fp);
 	}
 	return 0;
 }
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 78caa6b..4db719d 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -885,7 +885,7 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	stats->RxFrames++;
 	stats->RxWords += skb->len / FIP_BPW;
 
-	fc_exch_recv(lp, lp->emp, fp);
+	fc_exch_recv(lp, fp);
 	return;
 
 len_err:
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 07e6eed..50db3e3 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -115,7 +115,7 @@ void fnic_handle_frame(struct work_struct *work)
 		}
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-		fc_exch_recv(lp, lp->emp, fp);
+		fc_exch_recv(lp, fp);
 	}
 
 }
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 2c266c0..71c7bbe 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -671,14 +671,6 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	lp->link_up = 0;
 	lp->tt = fnic_transport_template;
 
-	lp->emp = fc_exch_mgr_alloc(lp, FC_CLASS_3,
-				    FCPIO_HOST_EXCH_RANGE_START,
-				    FCPIO_HOST_EXCH_RANGE_END);
-	if (!lp->emp) {
-		err = -ENOMEM;
-		goto err_out_remove_scsi_host;
-	}
-
 	lp->max_retry_count = fnic->config.flogi_retries;
 	lp->max_rport_retry_count = fnic->config.plogi_retries;
 	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
@@ -693,12 +685,18 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	fc_set_wwnn(lp, fnic->config.node_wwn);
 	fc_set_wwpn(lp, fnic->config.port_wwn);
 
-	fc_exch_init(lp);
 	fc_lport_init(lp);
+	fc_exch_init(lp);
 	fc_elsct_init(lp);
 	fc_rport_init(lp);
 	fc_disc_init(lp);
 
+	if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, FCPIO_HOST_EXCH_RANGE_START,
+			       FCPIO_HOST_EXCH_RANGE_END, NULL)) {
+		err = -ENOMEM;
+		goto err_out_remove_scsi_host;
+	}
+
 	fc_lport_config(lp);
 
 	if (fc_set_mfs(lp, fnic->config.maxdatafieldsize +
@@ -738,7 +736,7 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	return 0;
 
 err_out_free_exch_mgr:
-	fc_exch_mgr_free(lp->emp);
+	fc_exch_mgr_free(lp);
 err_out_remove_scsi_host:
 	fc_remove_host(fnic->lport->host);
 	scsi_remove_host(fnic->lport->host);
@@ -827,7 +825,7 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 
 	fc_remove_host(fnic->lport->host);
 	scsi_remove_host(fnic->lport->host);
-	fc_exch_mgr_free(fnic->lport->emp);
+	fc_exch_mgr_free(fnic->lport);
 	vnic_dev_notify_unset(fnic->vdev);
 	fnic_free_vnic_resources(fnic);
 	fnic_free_intr(fnic);
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 3ad7f88..324589a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -65,7 +65,6 @@ struct fc_exch_mgr {
 	u16		last_read;	/* last xid allocated for read */
 	u32	total_exches;		/* total allocated exchanges */
 	struct list_head	ex_list;	/* allocated exchanges list */
-	struct fc_lport	*lp;		/* fc device instance */
 	mempool_t	*ep_pool;	/* reserve ep's */
 
 	/*
@@ -275,8 +274,6 @@ static void fc_exch_release(struct fc_exch *ep)
 		mp = ep->em;
 		if (ep->destructor)
 			ep->destructor(&ep->seq, ep->arg);
-		if (ep->lp->tt.exch_put)
-			ep->lp->tt.exch_put(ep->lp, mp, ep->xid);
 		WARN_ON(!(ep->esb_stat & ESB_ST_COMPLETE));
 		mempool_free(ep, mp->ep_pool);
 	}
@@ -513,17 +510,20 @@ static u16 fc_em_alloc_xid(struct fc_exch_mgr *mp, const struct fc_frame *fp)
 	return xid;
 }
 
-/*
- * fc_exch_alloc - allocate an exchange.
- * @mp : ptr to the exchange manager
- * @xid: input xid
+/**
+ * fc_exch_em_alloc() - allocate an exchange from a specified EM.
+ * @lport:	ptr to the local port
+ * @mp:		ptr to the exchange manager
+ * @fp:		ptr to the FC frame
+ * @xid:	input xid
  *
  * if xid is supplied zero then assign next free exchange ID
  * from exchange manager, otherwise use supplied xid.
  * Returns with exch lock held.
  */
-struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp,
-			      struct fc_frame *fp, u16 xid)
+static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
+					struct fc_exch_mgr *mp,
+					struct fc_frame *fp, u16 xid)
 {
 	struct fc_exch *ep;
 
@@ -566,7 +566,7 @@ struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp,
 	 */
 	ep->oxid = ep->xid = xid;
 	ep->em = mp;
-	ep->lp = mp->lp;
+	ep->lp = lport;
 	ep->f_ctl = FC_FC_FIRST_SEQ;	/* next seq is first seq */
 	ep->rxid = FC_XID_UNKNOWN;
 	ep->class = mp->class;
@@ -579,6 +579,31 @@ err:
 	mempool_free(ep, mp->ep_pool);
 	return NULL;
 }
+
+/**
+ * fc_exch_alloc() - allocate an exchange.
+ * @lport:	ptr to the local port
+ * @fp:		ptr to the FC frame
+ *
+ * This function walks the list of the exchange manager(EM)
+ * anchors to select a EM for new exchange allocation. The
+ * EM is selected having either a NULL match function pointer
+ * or call to match function returning true.
+ */
+struct fc_exch *fc_exch_alloc(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct fc_exch_mgr_anchor *ema;
+	struct fc_exch *ep;
+
+	list_for_each_entry(ema, &lport->ema_list, ema_list) {
+		if (!ema->match || ema->match(fp)) {
+			ep = fc_exch_em_alloc(lport, ema->mp, fp, 0);
+			if (ep)
+				return ep;
+		}
+	}
+	return NULL;
+}
 EXPORT_SYMBOL(fc_exch_alloc);
 
 /*
@@ -617,12 +642,14 @@ EXPORT_SYMBOL(fc_exch_done);
  * Allocate a new exchange as responder.
  * Sets the responder ID in the frame header.
  */
-static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
+static struct fc_exch *fc_exch_resp(struct fc_lport *lport,
+				    struct fc_exch_mgr *mp,
+				    struct fc_frame *fp)
 {
 	struct fc_exch *ep;
 	struct fc_frame_header *fh;
 
-	ep = mp->lp->tt.exch_get(mp->lp, fp);
+	ep = fc_exch_alloc(lport, fp);
 	if (ep) {
 		ep->class = fc_frame_class(fp);
 
@@ -648,7 +675,7 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 			ep->esb_stat &= ~ESB_ST_SEQ_INIT;
 
 		fc_exch_hold(ep);	/* hold for caller */
-		spin_unlock_bh(&ep->ex_lock);	/* lock from exch_get */
+		spin_unlock_bh(&ep->ex_lock);	/* lock from fc_exch_alloc */
 	}
 	return ep;
 }
@@ -658,7 +685,8 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
  * If fc_pf_rjt_reason is FC_RJT_NONE then this function will have a hold
  * on the ep that should be released by the caller.
  */
-static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_exch_mgr *mp,
+static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
+						 struct fc_exch_mgr *mp,
 						 struct fc_frame *fp)
 {
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
@@ -712,7 +740,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_exch_mgr *mp,
 				reject = FC_RJT_RX_ID;
 				goto rel;
 			}
-			ep = fc_exch_resp(mp, fp);
+			ep = fc_exch_resp(lport, mp, fp);
 			if (!ep) {
 				reject = FC_RJT_EXCH_EST;	/* XXX */
 				goto out;
@@ -1103,7 +1131,7 @@ static void fc_exch_recv_req(struct fc_lport *lp, struct fc_exch_mgr *mp,
 	enum fc_pf_rjt_reason reject;
 
 	fr_seq(fp) = NULL;
-	reject = fc_seq_lookup_recip(mp, fp);
+	reject = fc_seq_lookup_recip(lp, mp, fp);
 	if (reject == FC_RJT_NONE) {
 		sp = fr_seq(fp);	/* sequence will be held */
 		ep = fc_seq_exch(sp);
@@ -1467,29 +1495,34 @@ void fc_exch_mgr_reset(struct fc_lport *lp, u32 sid, u32 did)
 {
 	struct fc_exch *ep;
 	struct fc_exch *next;
-	struct fc_exch_mgr *mp = lp->emp;
+	struct fc_exch_mgr *mp;
+	struct fc_exch_mgr_anchor *ema;
 
-	spin_lock_bh(&mp->em_lock);
+	list_for_each_entry(ema, &lp->ema_list, ema_list) {
+		mp = ema->mp;
+		spin_lock_bh(&mp->em_lock);
 restart:
-	list_for_each_entry_safe(ep, next, &mp->ex_list, ex_list) {
-		if ((sid == 0 || sid == ep->sid) &&
-		    (did == 0 || did == ep->did)) {
-			fc_exch_hold(ep);
-			spin_unlock_bh(&mp->em_lock);
-
-			fc_exch_reset(ep);
-
-			fc_exch_release(ep);
-			spin_lock_bh(&mp->em_lock);
-
-			/*
-			 * must restart loop incase while lock was down
-			 * multiple eps were released.
-			 */
-			goto restart;
+		list_for_each_entry_safe(ep, next, &mp->ex_list, ex_list) {
+			if ((lp == ep->lp) &&
+			    (sid == 0 || sid == ep->sid) &&
+			    (did == 0 || did == ep->did)) {
+				fc_exch_hold(ep);
+				spin_unlock_bh(&mp->em_lock);
+
+				fc_exch_reset(ep);
+
+				fc_exch_release(ep);
+				spin_lock_bh(&mp->em_lock);
+
+				/*
+				 * must restart loop incase while lock
+				 * was down multiple eps were released.
+				 */
+				goto restart;
+			}
 		}
+		spin_unlock_bh(&mp->em_lock);
 	}
-	spin_unlock_bh(&mp->em_lock);
 }
 EXPORT_SYMBOL(fc_exch_mgr_reset);
 
@@ -1778,7 +1811,8 @@ EXPORT_SYMBOL(fc_exch_mgr_del);
 
 struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 				      enum fc_class class,
-				      u16 min_xid, u16 max_xid)
+				      u16 min_xid, u16 max_xid,
+				      bool (*match)(struct fc_frame *))
 {
 	struct fc_exch_mgr *mp;
 	size_t len;
@@ -1803,7 +1837,6 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	mp->class = class;
 	mp->total_exches = 0;
 	mp->exches = (struct fc_exch **)(mp + 1);
-	mp->lp = lp;
 	/* adjust em exch xid range for offload */
 	mp->min_xid = min_xid;
 	mp->max_xid = max_xid;
@@ -1826,6 +1859,18 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	if (!mp->ep_pool)
 		goto free_mp;
 
+	kref_init(&mp->kref);
+	if (!fc_exch_mgr_add(lp, mp, match)) {
+		mempool_destroy(mp->ep_pool);
+		goto free_mp;
+	}
+
+	/*
+	 * Above kref_init() sets mp->kref to 1 and then
+	 * call to fc_exch_mgr_add incremented mp->kref again,
+	 * so adjust that extra increment.
+	 */
+	kref_put(&mp->kref, fc_exch_mgr_destroy);
 	return mp;
 
 free_mp:
@@ -1834,27 +1879,15 @@ free_mp:
 }
 EXPORT_SYMBOL(fc_exch_mgr_alloc);
 
-void fc_exch_mgr_free(struct fc_exch_mgr *mp)
+void fc_exch_mgr_free(struct fc_lport *lport)
 {
-	WARN_ON(!mp);
-	/*
-	 * The total exch count must be zero
-	 * before freeing exchange manager.
-	 */
-	WARN_ON(mp->total_exches != 0);
-	mempool_destroy(mp->ep_pool);
-	kfree(mp);
+	struct fc_exch_mgr_anchor *ema, *next;
+
+	list_for_each_entry_safe(ema, next, &lport->ema_list, ema_list)
+		fc_exch_mgr_del(ema);
 }
 EXPORT_SYMBOL(fc_exch_mgr_free);
 
-struct fc_exch *fc_exch_get(struct fc_lport *lp, struct fc_frame *fp)
-{
-	if (!lp || !lp->emp)
-		return NULL;
-
-	return fc_exch_alloc(lp->emp, fp, 0);
-}
-EXPORT_SYMBOL(fc_exch_get);
 
 struct fc_seq *fc_exch_seq_send(struct fc_lport *lp,
 				struct fc_frame *fp,
@@ -1869,7 +1902,7 @@ struct fc_seq *fc_exch_seq_send(struct fc_lport *lp,
 	struct fc_frame_header *fh;
 	int rc = 1;
 
-	ep = lp->tt.exch_get(lp, fp);
+	ep = fc_exch_alloc(lp, fp);
 	if (!ep) {
 		fc_frame_free(fp);
 		return NULL;
@@ -1914,24 +1947,44 @@ EXPORT_SYMBOL(fc_exch_seq_send);
 /*
  * Receive a frame
  */
-void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
-		  struct fc_frame *fp)
+void fc_exch_recv(struct fc_lport *lp, struct fc_frame *fp)
 {
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
-	u32 f_ctl;
+	struct fc_exch_mgr_anchor *ema;
+	u32 f_ctl, found = 0;
+	u16 oxid;
 
 	/* lport lock ? */
-	if (!lp || !mp || lp->state == LPORT_ST_DISABLED) {
+	if (!lp || lp->state == LPORT_ST_DISABLED) {
 		FC_LPORT_DBG(lp, "Receiving frames for an lport that "
 			     "has not been initialized correctly\n");
 		fc_frame_free(fp);
 		return;
 	}
 
+	f_ctl = ntoh24(fh->fh_f_ctl);
+	oxid = ntohs(fh->fh_ox_id);
+	if (f_ctl & FC_FC_EX_CTX) {
+		list_for_each_entry(ema, &lp->ema_list, ema_list) {
+			if ((oxid >= ema->mp->min_xid) &&
+			    (oxid <= ema->mp->max_xid)) {
+				found = 1;
+				break;
+			}
+		}
+
+		if (!found) {
+			FC_LPORT_DBG(lp, "Received response for out "
+				     "of range oxid:%hx\n", oxid);
+			fc_frame_free(fp);
+			return;
+		}
+	} else
+		ema = list_entry(lp->ema_list.prev, typeof(*ema), ema_list);
+
 	/*
 	 * If frame is marked invalid, just drop it.
 	 */
-	f_ctl = ntoh24(fh->fh_f_ctl);
 	switch (fr_eof(fp)) {
 	case FC_EOF_T:
 		if (f_ctl & FC_FC_END_SEQ)
@@ -1939,34 +1992,24 @@ void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
 		/* fall through */
 	case FC_EOF_N:
 		if (fh->fh_type == FC_TYPE_BLS)
-			fc_exch_recv_bls(mp, fp);
+			fc_exch_recv_bls(ema->mp, fp);
 		else if ((f_ctl & (FC_FC_EX_CTX | FC_FC_SEQ_CTX)) ==
 			 FC_FC_EX_CTX)
-			fc_exch_recv_seq_resp(mp, fp);
+			fc_exch_recv_seq_resp(ema->mp, fp);
 		else if (f_ctl & FC_FC_SEQ_CTX)
-			fc_exch_recv_resp(mp, fp);
+			fc_exch_recv_resp(ema->mp, fp);
 		else
-			fc_exch_recv_req(lp, mp, fp);
+			fc_exch_recv_req(lp, ema->mp, fp);
 		break;
 	default:
 		FC_LPORT_DBG(lp, "dropping invalid frame (eof %x)", fr_eof(fp));
 		fc_frame_free(fp);
-		break;
 	}
 }
 EXPORT_SYMBOL(fc_exch_recv);
 
 int fc_exch_init(struct fc_lport *lp)
 {
-	if (!lp->tt.exch_get) {
-		/*
-		 *  exch_put() should be NULL if
-		 *  exch_get() is NULL
-		 */
-		WARN_ON(lp->tt.exch_put);
-		lp->tt.exch_get = fc_exch_get;
-	}
-
 	if (!lp->tt.seq_start_next)
 		lp->tt.seq_start_next = fc_seq_start_next;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index f1bde91..c2b928c 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -518,25 +518,6 @@ struct libfc_function_template {
 	void (*exch_done)(struct fc_seq *sp);
 
 	/*
-	 * Assigns a EM and a free XID for an new exchange and then
-	 * allocates a new exchange and sequence pair.
-	 * The fp can be used to determine free XID.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	struct fc_exch *(*exch_get)(struct fc_lport *lp, struct fc_frame *fp);
-
-	/*
-	 * Release previously assigned XID by exch_get API.
-	 * The LLD may implement this if XID is assigned by LLD
-	 * in exch_get().
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	void (*exch_put)(struct fc_lport *lp, struct fc_exch_mgr *mp,
-			 u16 ex_id);
-
-	/*
 	 * Start a new sequence on the same exchange/sequence tuple.
 	 *
 	 * STATUS: OPTIONAL
@@ -703,7 +684,6 @@ struct fc_lport {
 
 	/* Associations */
 	struct Scsi_Host	*host;
-	struct fc_exch_mgr	*emp;
 	struct list_head	ema_list;
 	struct fc_rport		*dns_rp;
 	struct fc_rport		*ptp_rp;
@@ -996,27 +976,25 @@ void fc_exch_mgr_del(struct fc_exch_mgr_anchor *ema);
  * a new exchange.
  * The LLD may choose to have multiple EMs,
  * e.g. one EM instance per CPU receive thread in LLD.
- * The LLD can use exch_get() of struct libfc_function_template
- * to specify XID for a new exchange within
- * a specified EM instance.
  *
- * The em_idx to uniquely identify an EM instance.
+ * Specified match function is used in allocating exchanges
+ * from newly allocated EM.
  */
 struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 				      enum fc_class class,
 				      u16 min_xid,
-				      u16 max_xid);
+				      u16 max_xid,
+				      bool (*match)(struct fc_frame *));
 
 /*
- * Free an exchange manager.
+ * Free all exchange managers of a lport.
  */
-void fc_exch_mgr_free(struct fc_exch_mgr *mp);
+void fc_exch_mgr_free(struct fc_lport *lport);
 
 /*
  * Receive a frame on specified local port and exchange manager.
  */
-void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
-		  struct fc_frame *fp);
+void fc_exch_recv(struct fc_lport *lp, struct fc_frame *fp);
 
 /*
  * This function is for exch_seq_send function pointer in
@@ -1058,19 +1036,9 @@ int fc_seq_exch_abort(const struct fc_seq *req_sp, unsigned int timer_msec);
 void fc_exch_done(struct fc_seq *sp);
 
 /*
- * Assigns a EM and XID for a frame and then allocates
- * a new exchange and sequence pair.
- * The fp can be used to determine free XID.
- */
-struct fc_exch *fc_exch_get(struct fc_lport *lp, struct fc_frame *fp);
-
-/*
  * Allocate a new exchange and sequence pair.
- * if ex_id is zero then next free exchange id
- * from specified exchange manger mp will be assigned.
  */
-struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp,
-			      struct fc_frame *fp, u16 ex_id);
+struct fc_exch *fc_exch_alloc(struct fc_lport *lport, struct fc_frame *fp);
 /*
  * Start a new sequence on the same exchange as the supplied sequence.
  */

