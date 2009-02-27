From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 19/24] libfc: do not change the fh_rx_id of a recevied frame
Date: Fri, 27 Feb 2009 10:56:11 -0800
Message-ID: <20090227185611.25509.38157.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20523 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbZB0S4N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:56:13 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

From: Yi Zou <yi.zou@intel.com>

We shouldn't be altering inbound frames.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 7b93395..505825b 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -625,7 +625,6 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 {
 	struct fc_exch *ep;
 	struct fc_frame_header *fh;
-	u16 rxid;
 
 	ep = mp->lp->tt.exch_get(mp->lp, fp);
 	if (ep) {
@@ -652,18 +651,6 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		if ((ntoh24(fh->fh_f_ctl) & FC_FC_SEQ_INIT) == 0)
 			ep->esb_stat &= ~ESB_ST_SEQ_INIT;
 
-		/*
-		 * Set the responder ID in the frame header.
-		 * The old one should've been 0xffff.
-		 * If it isn't, don't assign one.
-		 * Incoming basic link service frames may specify
-		 * a referenced RX_ID.
-		 */
-		if (fh->fh_type != FC_TYPE_BLS) {
-			rxid = ntohs(fh->fh_rx_id);
-			WARN_ON(rxid != FC_XID_UNKNOWN);
-			fh->fh_rx_id = htons(ep->rxid);
-		}
 		fc_exch_hold(ep);	/* hold for caller */
 		spin_unlock_bh(&ep->ex_lock);	/* lock from exch_get */
 	}

