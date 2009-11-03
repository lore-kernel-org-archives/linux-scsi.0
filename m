From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 42/54] libfcoe: fcoe: simplify receive FLOGI response
Date: Tue, 03 Nov 2009 11:49:16 -0800
Message-ID: <20091103194916.4085.70354.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28842 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbZKCTtM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:49:12 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

There was a locking problem where the fip->lock was held during
the call to update_mac().  The rtnl_lock() must be taken before
the fip->lock, not the other way around.  This fixes that.

Now that fcoe_ctlr_recv_flog() is called only from the response handler
to a FLOGI request, some checking can be eliminated.  Instead of calling
update_mac(), just fill in the granted_mac address for the passed-in
frame (skb).

Eliminate the passed-in source MAC address since it is also in the skb.

Also, in fcoe, call fcoe_set_src_mac() directly instead of going thru
the fip function pointer.  This will generate less code.
Then, since fip isn't needed for LOGO response, use lport as the arg.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c    |   15 +++++----------
 drivers/scsi/fcoe/libfcoe.c |   12 ++++++------
 include/scsi/libfcoe.h      |    2 +-
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index b15ec99..343900a 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2247,15 +2247,12 @@ static void fcoe_flogi_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 	mac = fr_cb(fp)->granted_mac;
 	if (is_zero_ether_addr(mac)) {
 		/* pre-FIP */
-		mac = eth_hdr(&fp->skb)->h_source;
-		if (fcoe_ctlr_recv_flogi(fip, lport, fp, mac)) {
+		if (fcoe_ctlr_recv_flogi(fip, lport, fp)) {
 			fc_frame_free(fp);
 			return;
 		}
-	} else {
-		/* FIP, libfcoe has already seen it */
-		fip->update_mac(lport, fr_cb(fp)->granted_mac);
 	}
+	fcoe_update_src_mac(lport, mac);
 done:
 	fc_lport_flogi_resp(seq, fp, lport);
 }
@@ -2271,13 +2268,11 @@ done:
  */
 static void fcoe_logo_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 {
-	struct fcoe_ctlr *fip = arg;
-	struct fc_exch *exch = fc_seq_exch(seq);
-	struct fc_lport *lport = exch->lp;
+	struct fc_lport *lport = arg;
 	static u8 zero_mac[ETH_ALEN] = { 0 };
 
 	if (!IS_ERR(fp))
-		fip->update_mac(lport, zero_mac);
+		fcoe_update_src_mac(lport, zero_mac);
 	fc_lport_logo_resp(seq, fp, lport);
 }
 
@@ -2312,7 +2307,7 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *lport, u32 did,
 		if (ntoh24(fh->fh_d_id) != FC_FID_FLOGI)
 			break;
 		return fc_elsct_send(lport, did, fp, op, fcoe_logo_resp,
-				     fip, timeout);
+				     lport, timeout);
 	}
 	return fc_elsct_send(lport, did, fp, op, resp, arg, timeout);
 }
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 2aab972..2988b71 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1254,10 +1254,9 @@ static void fcoe_ctlr_recv_work(struct work_struct *recv_work)
 }
 
 /**
- * fcoe_ctlr_recv_flogi() - Snoop pre-FIP receipt of FLOGI response or request
+ * fcoe_ctlr_recv_flogi() - Snoop pre-FIP receipt of FLOGI response
  * @fip: The FCoE controller
  * @fp:	 The FC frame to snoop
- * @sa:	 Ethernet source MAC address from received FCoE frame
  *
  * Snoop potential response to FLOGI or even incoming FLOGI.
  *
@@ -1265,16 +1264,18 @@ static void fcoe_ctlr_recv_work(struct work_struct *recv_work)
  * by fip->flogi_oxid != FC_XID_UNKNOWN.
  *
  * The caller is responsible for freeing the frame.
+ * Fill in the granted_mac address.
  *
  * Return non-zero if the frame should not be delivered to libfc.
  */
 int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
-			 struct fc_frame *fp, u8 *sa)
+			 struct fc_frame *fp)
 {
 	struct fc_frame_header *fh;
 	u8 op;
-	u8 mac[ETH_ALEN];
+	u8 *sa;
 
+	sa = eth_hdr(&fp->skb)->h_source;
 	fh = fc_frame_header_get(fp);
 	if (fh->fh_type != FC_TYPE_ELS)
 		return 0;
@@ -1305,9 +1306,8 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 			fip->map_dest = 0;
 		}
 		fip->flogi_oxid = FC_XID_UNKNOWN;
-		fc_fcoe_set_mac(mac, fh->fh_d_id);
-		fip->update_mac(lport, mac);
 		spin_unlock_bh(&fip->lock);
+		fc_fcoe_set_mac(fr_cb(fp)->granted_mac, fh->fh_d_id);
 	} else if (op == ELS_FLOGI && fh->fh_r_ctl == FC_RCTL_ELS_REQ && sa) {
 		/*
 		 * Save source MAC for point-to-point responses.
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index e38ffa0..3837872 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -165,7 +165,7 @@ int fcoe_ctlr_link_down(struct fcoe_ctlr *);
 int fcoe_ctlr_els_send(struct fcoe_ctlr *, struct fc_lport *, struct sk_buff *);
 void fcoe_ctlr_recv(struct fcoe_ctlr *, struct sk_buff *);
 int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
-			 struct fc_frame *, u8 *);
+			 struct fc_frame *);
 
 /* libfcoe funcs */
 u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);

