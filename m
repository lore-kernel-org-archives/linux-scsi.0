From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/16] libfc: Protect ep->esb_stat changes via ex_lock
Date: Thu, 05 Sep 2013 12:13:06 -0700
Message-ID: <20130905191306.15235.4217.stgit@fritz>
References: <20130905191218.15235.85917.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab3IETNH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 15:13:07 -0400
In-Reply-To: <20130905191218.15235.85917.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

This patch avoids that the WARN_ON(!(ep->esb_stat & ESB_ST_SEQ_INIT))
statement in fc_seq_send_locked() gets triggered sporadically when
running FCoE target code due to concurrent ep->esb_stat modifications.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 7000203..bc0aba4 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -988,6 +988,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 		}
 	}
 
+	spin_lock_bh(&ep->ex_lock);
 	/*
 	 * At this point, we have the exchange held.
 	 * Find or create the sequence.
@@ -1015,11 +1016,11 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 				 * sending RSP, hence write request on other
 				 * end never finishes.
 				 */
-				spin_lock_bh(&ep->ex_lock);
 				sp->ssb_stat |= SSB_ST_RESP;
 				sp->id = fh->fh_seq_id;
-				spin_unlock_bh(&ep->ex_lock);
 			} else {
+				spin_unlock_bh(&ep->ex_lock);
+
 				/* sequence/exch should exist */
 				reject = FC_RJT_SEQ_ID;
 				goto rel;
@@ -1030,6 +1031,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 
 	if (f_ctl & FC_FC_SEQ_INIT)
 		ep->esb_stat |= ESB_ST_SEQ_INIT;
+	spin_unlock_bh(&ep->ex_lock);
 
 	fr_seq(fp) = sp;
 out:
@@ -1479,8 +1481,11 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 
 	f_ctl = ntoh24(fh->fh_f_ctl);
 	fr_seq(fp) = sp;
+
+	spin_lock_bh(&ep->ex_lock);
 	if (f_ctl & FC_FC_SEQ_INIT)
 		ep->esb_stat |= ESB_ST_SEQ_INIT;
+	spin_unlock_bh(&ep->ex_lock);
 
 	if (fc_sof_needs_ack(sof))
 		fc_seq_send_ack(sp, fp);

