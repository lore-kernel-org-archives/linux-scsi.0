From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 23/27] libfcoe: retry rejected FLOGI to another FCF if possible
Date: Tue, 30 Nov 2010 16:19:56 -0800
Message-ID: <20101201001956.18369.12069.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab0LAAT5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:57 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Switches using multiple-FCFs may reject FLOGI in order to
balance the load between multiple FCFs.  Even though the FCF
was available, it may have more load at the point we actually
send the FLOGI.

If the FLOGI fails, select a different FCF
if possible, among those with the same priority.  If no other
FCF is available, just deliver the reject to libfc for retry.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |  207 +++++++++++++++++++++++++++++++++++++------
 include/scsi/libfcoe.h      |    8 ++
 2 files changed, 185 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 826c260..c90622c 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -54,6 +54,8 @@ MODULE_LICENSE("GPL v2");
 static void fcoe_ctlr_timeout(unsigned long);
 static void fcoe_ctlr_timer_work(struct work_struct *);
 static void fcoe_ctlr_recv_work(struct work_struct *);
+static int fcoe_ctlr_flogi_retry(struct fcoe_ctlr *);
+static void fcoe_ctlr_select(struct fcoe_ctlr *);
 
 static void fcoe_ctlr_vn_start(struct fcoe_ctlr *);
 static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *, struct sk_buff *);
@@ -176,6 +178,7 @@ void fcoe_ctlr_init(struct fcoe_ctlr *fip, enum fip_state mode)
 	fip->mode = mode;
 	INIT_LIST_HEAD(&fip->fcfs);
 	mutex_init(&fip->ctlr_mutex);
+	spin_lock_init(&fip->ctlr_lock);
 	fip->flogi_oxid = FC_XID_UNKNOWN;
 	setup_timer(&fip->timer, fcoe_ctlr_timeout, (unsigned long)fip);
 	INIT_WORK(&fip->timer_work, fcoe_ctlr_timer_work);
@@ -231,17 +234,31 @@ void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 EXPORT_SYMBOL(fcoe_ctlr_destroy);
 
 /**
- * fcoe_ctlr_announce() - announce new selection
+ * fcoe_ctlr_announce() - announce new FCF selection
  * @fip: The FCoE controller
  *
  * Also sets the destination MAC for FCoE and control packets
+ *
+ * Called with neither ctlr_mutex nor ctlr_lock held.
  */
 static void fcoe_ctlr_announce(struct fcoe_ctlr *fip)
 {
-	struct fcoe_fcf *sel = fip->sel_fcf;
+	struct fcoe_fcf *sel;
+	struct fcoe_fcf *fcf;
+
+	mutex_lock(&fip->ctlr_mutex);
+	spin_lock_bh(&fip->ctlr_lock);
+
+	kfree_skb(fip->flogi_req);
+	fip->flogi_req = NULL;
+	list_for_each_entry(fcf, &fip->fcfs, list)
+		fcf->flogi_sent = 0;
+
+	spin_unlock_bh(&fip->ctlr_lock);
+	sel = fip->sel_fcf;
 
 	if (sel && !compare_ether_addr(sel->fcf_mac, fip->dest_addr))
-		return;
+		goto unlock;
 	if (!is_zero_ether_addr(fip->dest_addr)) {
 		printk(KERN_NOTICE "libfcoe: host%d: "
 		       "FIP Fibre-Channel Forwarder MAC %pM deselected\n",
@@ -255,6 +272,8 @@ static void fcoe_ctlr_announce(struct fcoe_ctlr *fip)
 		memcpy(fip->dest_addr, sel->fcf_mac, ETH_ALEN);
 		fip->map_dest = 0;
 	}
+unlock:
+	mutex_unlock(&fip->ctlr_mutex);
 }
 
 /**
@@ -591,6 +610,9 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
  * The caller must check that the length is a multiple of 4.
  * The SKB must have enough headroom (28 bytes) and tailroom (8 bytes).
  * The the skb must also be an fc_frame.
+ *
+ * This is called from the lower-level driver with spinlocks held,
+ * so we must not take a mutex here.
  */
 int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
 		       struct sk_buff *skb)
@@ -628,7 +650,15 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
 	switch (op) {
 	case ELS_FLOGI:
 		op = FIP_DT_FLOGI;
-		break;
+		if (fip->mode == FIP_MODE_VN2VN)
+			break;
+		spin_lock_bh(&fip->ctlr_lock);
+		kfree_skb(fip->flogi_req);
+		fip->flogi_req = skb;
+		fip->flogi_req_send = 1;
+		spin_unlock_bh(&fip->ctlr_lock);
+		schedule_work(&fip->timer_work);
+		return -EINPROGRESS;
 	case ELS_FDISC:
 		if (ntoh24(fh->fh_s_id))
 			return 0;
@@ -1088,18 +1118,24 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	els_op = *(u8 *)(fh + 1);
 
 	if ((els_dtype == FIP_DT_FLOGI || els_dtype == FIP_DT_FDISC) &&
-	    sub == FIP_SC_REP && els_op == ELS_LS_ACC &&
-	    fip->mode != FIP_MODE_VN2VN) {
-		if (!is_valid_ether_addr(granted_mac)) {
-			LIBFCOE_FIP_DBG(fip,
-				"Invalid MAC address %pM in FIP ELS\n",
-				granted_mac);
-			goto drop;
-		}
-		memcpy(fr_cb(fp)->granted_mac, granted_mac, ETH_ALEN);
+	    sub == FIP_SC_REP && fip->mode != FIP_MODE_VN2VN) {
+		if (els_op == ELS_LS_ACC) {
+			if (!is_valid_ether_addr(granted_mac)) {
+				LIBFCOE_FIP_DBG(fip,
+					"Invalid MAC address %pM in FIP ELS\n",
+					granted_mac);
+				goto drop;
+			}
+			memcpy(fr_cb(fp)->granted_mac, granted_mac, ETH_ALEN);
 
-		if (fip->flogi_oxid == ntohs(fh->fh_ox_id))
-			fip->flogi_oxid = FC_XID_UNKNOWN;
+			if (fip->flogi_oxid == ntohs(fh->fh_ox_id)) {
+				fip->flogi_oxid = FC_XID_UNKNOWN;
+				if (els_dtype == FIP_DT_FLOGI)
+					fcoe_ctlr_announce(fip);
+			}
+		} else if (els_dtype == FIP_DT_FLOGI &&
+			   !fcoe_ctlr_flogi_retry(fip))
+			goto drop;	/* retrying FLOGI so drop reject */
 	}
 
 	if ((desc_cnt == 0) || ((els_op != ELS_LS_RJT) &&
@@ -1355,12 +1391,15 @@ drop:
  *
  * If there are conflicting advertisements, no FCF can be chosen.
  *
+ * If there is already a selected FCF, this will choose a better one or
+ * an equivalent one that hasn't already been sent a FLOGI.
+ *
  * Called with lock held.
  */
 static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 {
 	struct fcoe_fcf *fcf;
-	struct fcoe_fcf *best = NULL;
+	struct fcoe_fcf *best = fip->sel_fcf;
 	struct fcoe_fcf *first;
 
 	first = list_first_entry(&fip->fcfs, struct fcoe_fcf, list);
@@ -1377,6 +1416,8 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 					"or FC-MAP\n");
 			return NULL;
 		}
+		if (fcf->flogi_sent)
+			continue;
 		if (!fcoe_ctlr_fcf_usable(fcf)) {
 			LIBFCOE_FIP_DBG(fip, "FCF for fab %16.16llx "
 					"map %x %svalid %savailable\n",
@@ -1386,11 +1427,7 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 					"" : "un");
 			continue;
 		}
-		if (!best) {
-			best = fcf;
-			continue;
-		}
-		if (fcf->pri < best->pri)
+		if (!best || fcf->pri < best->pri || best->flogi_sent)
 			best = fcf;
 	}
 	fip->sel_fcf = best;
@@ -1404,6 +1441,121 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 }
 
 /**
+ * fcoe_ctlr_flogi_send_locked() - send FIP-encapsulated FLOGI to current FCF
+ * @fip: The FCoE controller
+ *
+ * Returns non-zero error if it could not be sent.
+ *
+ * Called with ctlr_mutex and ctlr_lock held.
+ * Caller must verify that fip->sel_fcf is not NULL.
+ */
+static int fcoe_ctlr_flogi_send_locked(struct fcoe_ctlr *fip)
+{
+	struct sk_buff *skb;
+	struct sk_buff *skb_orig;
+	struct fc_frame_header *fh;
+	int error;
+
+	skb_orig = fip->flogi_req;
+	if (!skb_orig)
+		return -EINVAL;
+
+	/*
+	 * Clone and send the FLOGI request.  If clone fails, use original.
+	 */
+	skb = skb_clone(skb_orig, GFP_ATOMIC);
+	if (!skb) {
+		skb = skb_orig;
+		fip->flogi_req = NULL;
+	}
+	fh = (struct fc_frame_header *)skb->data;
+	error = fcoe_ctlr_encaps(fip, fip->lp, FIP_DT_FLOGI, skb,
+				 ntoh24(fh->fh_d_id));
+	if (error) {
+		kfree_skb(skb);
+		return error;
+	}
+	fip->send(fip, skb);
+	fip->sel_fcf->flogi_sent = 1;
+	return 0;
+}
+
+/**
+ * fcoe_ctlr_flogi_retry() - resend FLOGI request to a new FCF if possible
+ * @fip: The FCoE controller
+ *
+ * Returns non-zero error code if there's no FLOGI request to retry or
+ * no alternate FCF available.
+ */
+static int fcoe_ctlr_flogi_retry(struct fcoe_ctlr *fip)
+{
+	struct fcoe_fcf *fcf;
+	int error;
+
+	mutex_lock(&fip->ctlr_mutex);
+	spin_lock_bh(&fip->ctlr_lock);
+	LIBFCOE_FIP_DBG(fip, "re-sending FLOGI - reselect\n");
+	fcoe_ctlr_select(fip);
+	fcf = fip->sel_fcf;
+	if (!fcf || fcf->flogi_sent) {
+		kfree_skb(fip->flogi_req);
+		fip->flogi_req = NULL;
+		error = -ENOENT;
+	} else {
+		fcoe_ctlr_solicit(fip, NULL);
+		error = fcoe_ctlr_flogi_send_locked(fip);
+	}
+	spin_unlock_bh(&fip->ctlr_lock);
+	mutex_unlock(&fip->ctlr_mutex);
+	return error;
+}
+
+
+/**
+ * fcoe_ctlr_flogi_send() - Handle sending of FIP FLOGI.
+ * @fip: The FCoE controller that timed out
+ *
+ * Done here because fcoe_ctlr_els_send() can't get mutex.
+ *
+ * Called with ctlr_mutex held.  The caller must not hold ctlr_lock.
+ */
+static void fcoe_ctlr_flogi_send(struct fcoe_ctlr *fip)
+{
+	struct fcoe_fcf *fcf;
+
+	spin_lock_bh(&fip->ctlr_lock);
+	fcf = fip->sel_fcf;
+	if (!fcf || !fip->flogi_req_send)
+		goto unlock;
+
+	LIBFCOE_FIP_DBG(fip, "sending FLOGI\n");
+
+	/*
+	 * If this FLOGI is being sent due to a timeout retry
+	 * to the same FCF as before, select a different FCF if possible.
+	 */
+	if (fcf->flogi_sent) {
+		LIBFCOE_FIP_DBG(fip, "sending FLOGI - reselect\n");
+		fcoe_ctlr_select(fip);
+		fcf = fip->sel_fcf;
+		if (!fcf || fcf->flogi_sent) {
+			LIBFCOE_FIP_DBG(fip, "sending FLOGI - clearing\n");
+			list_for_each_entry(fcf, &fip->fcfs, list)
+				fcf->flogi_sent = 0;
+			fcoe_ctlr_select(fip);
+			fcf = fip->sel_fcf;
+		}
+	}
+	if (fcf) {
+		fcoe_ctlr_flogi_send_locked(fip);
+		fip->flogi_req_send = 0;
+	} else /* XXX */
+		LIBFCOE_FIP_DBG(fip, "No FCF selected - defer send\n");
+unlock:
+	spin_unlock_bh(&fip->ctlr_lock);
+}
+
+/**
  * fcoe_ctlr_timeout() - FIP timeout handler
  * @arg: The FCoE controller that timed out
  */
@@ -1455,15 +1607,10 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 			next_timer = fip->sel_time;
 	}
 
-	if (sel != fcf) {
-		fcf = sel;		/* the old FCF may have been freed */
-		fcoe_ctlr_announce(fip);
-		if (sel) {
-			if (time_after(next_timer, fip->ctlr_ka_time))
-				next_timer = fip->ctlr_ka_time;
-		} else
-			reset = 1;
-	}
+	if (sel && fip->flogi_req_send)
+		fcoe_ctlr_flogi_send(fip);
+	else if (!sel && fcf)
+		reset = 1;
 
 	if (sel && !sel->fd_flags) {
 		if (time_after_eq(jiffies, fip->ctlr_ka_time)) {
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 06f1b5a..feb6a94 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -92,10 +92,12 @@ enum fip_state {
  * @timer_work:	   &work_struct for doing keep-alives and resets.
  * @recv_work:	   &work_struct for receiving FIP frames.
  * @fip_recv_list: list of received FIP frames.
+ * @flogi_req:	   clone of FLOGI request sent
  * @rnd_state:	   state for pseudo-random number generator.
  * @port_id:	   proposed or selected local-port ID.
  * @user_mfs:	   configured maximum FC frame size, including FC header.
  * @flogi_oxid:    exchange ID of most recent fabric login.
+ * @flogi_req_send: send of FLOGI requested
  * @flogi_count:   number of FLOGI attempts in AUTO mode.
  * @map_dest:	   use the FC_MAP mode for destination MAC addresses.
  * @spma:	   supports SPMA server-provided MACs mode
@@ -106,6 +108,7 @@ enum fip_state {
  * @update_mac:    LLD-supplied function to handle changes to MAC addresses.
  * @get_src_addr:  LLD-supplied function to supply a source MAC address.
  * @ctlr_mutex:	   lock protecting this structure.
+ * @ctlr_lock:     spinlock covering flogi_req
  *
  * This structure is used by all FCoE drivers.  It contains information
  * needed by all FCoE low-level drivers (LLDs) as well as internal state
@@ -126,12 +129,14 @@ struct fcoe_ctlr {
 	struct work_struct timer_work;
 	struct work_struct recv_work;
 	struct sk_buff_head fip_recv_list;
+	struct sk_buff *flogi_req;
 
 	struct rnd_state rnd_state;
 	u32 port_id;
 
 	u16 user_mfs;
 	u16 flogi_oxid;
+	u8 flogi_req_send;
 	u8 flogi_count;
 	u8 map_dest;
 	u8 spma;
@@ -143,6 +148,7 @@ struct fcoe_ctlr {
 	void (*update_mac)(struct fc_lport *, u8 *addr);
 	u8 * (*get_src_addr)(struct fc_lport *);
 	struct mutex ctlr_mutex;
+	spinlock_t ctlr_lock;
 };
 
 /**
@@ -155,6 +161,7 @@ struct fcoe_ctlr {
  * @fcf_mac:	 Ethernet address of the FCF
  * @vfid:	 virtual fabric ID
  * @pri:	 selection priority, smaller values are better
+ * @flogi_sent:	 current FLOGI sent to this FCF
  * @flags:	 flags received from advertisement
  * @fka_period:	 keep-alive period, in jiffies
  *
@@ -176,6 +183,7 @@ struct fcoe_fcf {
 	u8 fcf_mac[ETH_ALEN];
 
 	u8 pri;
+	u8 flogi_sent;
 	u16 flags;
 	u32 fka_period;
 	u8 fd_flags:1;

