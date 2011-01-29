From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 17/28] libfc: Enhanced exchange ID selection mechanism and fix
	related EMA selection logic.
Date: Fri, 28 Jan 2011 16:04:39 -0800
Message-ID: <20110129000439.1784.57517.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29268 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab1A2AEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:04:40 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Problem: In case of exchange responder case, EMA selection was defaulted to the last EMA
         from EMA list (lport.ema_list).  If exchange ID is selected from offload pool
         and not setup DDP, resulting into incorrect selection of EMA, and eventually
         dropping the packet because unable to find exchange.

Fix:     Enhanced the exchange ID selection (depending upon request type and exchange responder)
         Made necessary enhancement in EMA selection algorithm.

Technical Notes: N/A

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   64 ++++++++++++++++++++++++++++--------------
 1 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index a3d6402..08bf5fa 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2281,16 +2281,45 @@ void fc_exch_mgr_free(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_exch_mgr_free);
 
 /**
+ * fc_find_ema() - Lookup and return appropriate Exchange Manager Anchor depending
+ * upon 'xid'.
+ * @f_ctl: f_ctl
+ * @lport: The local port the frame was received on
+ * @fh: The received frame header
+ */
+static struct fc_exch_mgr_anchor *fc_find_ema(u32 f_ctl,
+					      struct fc_lport *lport,
+					      struct fc_frame_header *fh)
+{
+	struct fc_exch_mgr_anchor *ema;
+	u16 xid;
+
+	if (f_ctl & FC_FC_EX_CTX)
+		xid = ntohs(fh->fh_ox_id);
+	else {
+		xid = ntohs(fh->fh_rx_id);
+		if (xid == FC_XID_UNKNOWN)
+			return list_entry(lport->ema_list.prev,
+					  typeof(*ema), ema_list);
+	}
+
+	list_for_each_entry(ema, &lport->ema_list, ema_list) {
+		if ((xid >= ema->mp->min_xid) &&
+		    (xid <= ema->mp->max_xid))
+			return ema;
+	}
+	return NULL;
+}
+/**
  * fc_exch_recv() - Handler for received frames
  * @lport: The local port the frame was received on
- * @fp:	   The received frame
+ * @fp:	The received frame
  */
 void fc_exch_recv(struct fc_lport *lport, struct fc_frame *fp)
 {
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 	struct fc_exch_mgr_anchor *ema;
-	u32 f_ctl, found = 0;
-	u16 oxid;
+	u32 f_ctl;
 
 	/* lport lock ? */
 	if (!lport || lport->state == LPORT_ST_DISABLED) {
@@ -2301,24 +2330,17 @@ void fc_exch_recv(struct fc_lport *lport, struct fc_frame *fp)
 	}
 
 	f_ctl = ntoh24(fh->fh_f_ctl);
-	oxid = ntohs(fh->fh_ox_id);
-	if (f_ctl & FC_FC_EX_CTX) {
-		list_for_each_entry(ema, &lport->ema_list, ema_list) {
-			if ((oxid >= ema->mp->min_xid) &&
-			    (oxid <= ema->mp->max_xid)) {
-				found = 1;
-				break;
-			}
-		}
-
-		if (!found) {
-			FC_LPORT_DBG(lport, "Received response for out "
-				     "of range oxid:%hx\n", oxid);
-			fc_frame_free(fp);
-			return;
-		}
-	} else
-		ema = list_entry(lport->ema_list.prev, typeof(*ema), ema_list);
+	ema = fc_find_ema(f_ctl, lport, fh);
+	if (!ema) {
+		FC_LPORT_DBG(lport, "Unable to find Exchange Manager Anchor,"
+				    "fc_ctl <0x%x>, xid <0x%x>\n",
+				     f_ctl,
+				     (f_ctl & FC_FC_EX_CTX) ?
+				     ntohs(fh->fh_ox_id) :
+				     ntohs(fh->fh_rx_id));
+		fc_frame_free(fp);
+		return;
+	}
 
 	/*
 	 * If frame is marked invalid, just drop it.

