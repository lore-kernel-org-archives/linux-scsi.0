From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/22] libfc: frame alloc failure messages
Date: Wed,  3 Aug 2016 15:13:15 +0200
Message-ID: <1470230002-37737-16-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895AbcHCNNg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:36 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>

---
 drivers/scsi/libfc/fc_exch.c | 41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 51e7fb1..26a43b3 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1264,8 +1264,10 @@ static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
 	 */
 	if (fc_sof_needs_ack(fr_sof(rx_fp))) {
 		fp = fc_frame_alloc(lport, 0);
-		if (!fp)
+		if (!fp) {
+			FC_EXCH_DBG(ep, "Drop ACK request, out of memory\n");
 			return;
+		}
 
 		fh = fc_frame_header_get(fp);
 		fh->fh_r_ctl = FC_RCTL_ACK_1;
@@ -1318,13 +1320,18 @@ static void fc_exch_send_ba_rjt(struct fc_frame *rx_fp,
 	struct fc_frame_header *rx_fh;
 	struct fc_frame_header *fh;
 	struct fc_ba_rjt *rp;
+	struct fc_seq *sp;
 	struct fc_lport *lport;
 	unsigned int f_ctl;
 
 	lport = fr_dev(rx_fp);
+	sp = fr_seq(rx_fp);
 	fp = fc_frame_alloc(lport, sizeof(*rp));
-	if (!fp)
+	if (!fp) {
+		FC_EXCH_DBG(fc_seq_exch(sp),
+			     "Drop BA_RJT request, out of memory\n");
 		return;
+	}
 	fh = fc_frame_header_get(fp);
 	rx_fh = fc_frame_header_get(rx_fp);
 
@@ -1391,13 +1398,15 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
 
 	FC_EXCH_DBG(ep, "exch: ABTS received\n");
 	fp = fc_frame_alloc(ep->lp, sizeof(*ap));
-	if (!fp)
+	if (!fp) {
+		FC_EXCH_DBG(ep, "Drop ABTS request, out of memory\n");
 		goto free;
+	}
 
 	spin_lock_bh(&ep->ex_lock);
 	if (ep->esb_stat & ESB_ST_COMPLETE) {
 		spin_unlock_bh(&ep->ex_lock);
-
+		FC_EXCH_DBG(ep, "exch: ABTS rejected, exchange complete\n");
 		fc_frame_free(fp);
 		goto reject;
 	}
@@ -1791,11 +1800,16 @@ static void fc_seq_ls_acc(struct fc_frame *rx_fp)
 	struct fc_lport *lport;
 	struct fc_els_ls_acc *acc;
 	struct fc_frame *fp;
+	struct fc_seq *sp;
 
 	lport = fr_dev(rx_fp);
+	sp = fr_seq(rx_fp);
 	fp = fc_frame_alloc(lport, sizeof(*acc));
-	if (!fp)
+	if (!fp) {
+		FC_EXCH_DBG(fc_seq_exch(sp),
+			    "exch: drop LS_ACC, out of memory\n");
 		return;
+	}
 	acc = fc_frame_payload_get(fp, sizeof(*acc));
 	memset(acc, 0, sizeof(*acc));
 	acc->la_cmd = ELS_LS_ACC;
@@ -1818,11 +1832,16 @@ static void fc_seq_ls_rjt(struct fc_frame *rx_fp, enum fc_els_rjt_reason reason,
 	struct fc_lport *lport;
 	struct fc_els_ls_rjt *rjt;
 	struct fc_frame *fp;
+	struct fc_seq *sp;
 
 	lport = fr_dev(rx_fp);
+	sp = fr_seq(rx_fp);
 	fp = fc_frame_alloc(lport, sizeof(*rjt));
-	if (!fp)
+	if (!fp) {
+		FC_EXCH_DBG(fc_seq_exch(sp),
+			    "exch: drop LS_ACC, out of memory\n");
 		return;
+	}
 	rjt = fc_frame_payload_get(fp, sizeof(*rjt));
 	memset(rjt, 0, sizeof(*rjt));
 	rjt->er_cmd = ELS_LS_RJT;
@@ -1983,8 +2002,12 @@ static void fc_exch_els_rec(struct fc_frame *rfp)
 	ep = fc_exch_lookup(lport,
 			    sid == fc_host_port_id(lport->host) ? oxid : rxid);
 	explan = ELS_EXPL_OXID_RXID;
-	if (!ep)
+	if (!ep) {
+		FC_LPORT_DBG(lport, "REC request from %x: "
+			     "xid %4.4x-%4.4x not found\n",
+			     sid, rxid, oxid);
 		goto reject;
+	}
 	FC_EXCH_DBG(ep, "REC request from %x: rxid %x oxid %x\n",
 		    sid, rxid, oxid);
 	if (ep->oid != sid || oxid != ep->oxid)
@@ -1992,8 +2015,10 @@ static void fc_exch_els_rec(struct fc_frame *rfp)
 	if (rxid != FC_XID_UNKNOWN && rxid != ep->rxid)
 		goto rel;
 	fp = fc_frame_alloc(lport, sizeof(*acc));
-	if (!fp)
+	if (!fp) {
+		FC_EXCH_DBG(ep, "Drop REC request, out of memory\n");
 		goto out;
+	}
 
 	acc = fc_frame_payload_get(fp, sizeof(*acc));
 	memset(acc, 0, sizeof(*acc));
-- 
1.8.5.6

