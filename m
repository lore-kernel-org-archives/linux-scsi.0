From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/16] libfc: fixes unnecessary seq id jump
Date: Fri, 12 Mar 2010 16:08:34 -0800
Message-ID: <20100313000834.22251.20272.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11868 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAIe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:34 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

In some cases seq is incremented twice causing unnecessary
seq jump, for instance fc_exch_recv_seq_resp increments
seq id when fc_sof_is_init is true and that is true for
each incoming xfer ready but then fc_fcp_send_data does
another seq increment to send data for xfer ready.

This patch removes all such seq id jumps, at least it
eliminates few calls to fc_seq_start_next using ex_lock.

Also removes seq id update with incoming frame's seq id
as this is not needed since each end (I or T) just need
to send incremented their own seq id on each TSI from
other end & before sending new sequence within a
exchange.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 1ad1ded..dd7e188 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -920,12 +920,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 	 * Find or create the sequence.
 	 */
 	if (fc_sof_is_init(fr_sof(fp))) {
-		sp = fc_seq_start_next(&ep->seq);
-		if (!sp) {
-			reject = FC_RJT_SEQ_XS;	/* exchange shortage */
-			goto rel;
-		}
-		sp->id = fh->fh_seq_id;
+		sp = &ep->seq;
 		sp->ssb_stat |= SSB_ST_RESP;
 	} else {
 		sp = &ep->seq;
@@ -1336,17 +1331,14 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		goto rel;
 	}
 	sof = fr_sof(fp);
-	if (fc_sof_is_init(sof)) {
-		sp = fc_seq_start_next(&ep->seq);
-		sp->id = fh->fh_seq_id;
+	sp = &ep->seq;
+	if (fc_sof_is_init(sof))
 		sp->ssb_stat |= SSB_ST_RESP;
-	} else {
-		sp = &ep->seq;
-		if (sp->id != fh->fh_seq_id) {
+	else if (sp->id != fh->fh_seq_id) {
 			atomic_inc(&mp->stats.seq_not_found);
 			goto rel;
-		}
 	}
+
 	f_ctl = ntoh24(fh->fh_f_ctl);
 	fr_seq(fp) = sp;
 	if (f_ctl & FC_FC_SEQ_INIT)
@@ -1763,7 +1755,6 @@ static void fc_exch_els_rec(struct fc_seq *sp, struct fc_frame *rfp)
 		fc_exch_done(sp);
 		goto out;
 	}
-	sp = fc_seq_start_next(sp);
 	acc = fc_frame_payload_get(fp, sizeof(*acc));
 	memset(acc, 0, sizeof(*acc));
 	acc->reca_cmd = ELS_LS_ACC;

