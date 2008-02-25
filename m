From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 4/5] Fixed style error reported by checkpatch
Date: Mon, 25 Feb 2008 03:20:26 -0800
Message-ID: <20080225112026.22380.24050.stgit@vdinit.jf.intel.com>
References: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:13115 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbYBYTkW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 14:40:22 -0500
In-Reply-To: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org

Fixed checkpatch ERROR here: do not use assignment in if condition (+ }
else if ((fp = fc_frame_alloc(lp->dev, sizeof(*pl))) == NULL)

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/ofc/libfc/fc_sess.c |   57 +++++++++++++++++++++-----------------
 1 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/libfc/fc_sess.c
index 0d5f611..ff570e5 100644
--- a/drivers/scsi/ofc/libfc/fc_sess.c
+++ b/drivers/scsi/ofc/libfc/fc_sess.c
@@ -1189,35 +1189,40 @@ static void fc_sess_recv_plogi_req(struct fc_sess *sess,
 	if (reject) {
 		fc_seq_ls_rjt(sp, reject, ELS_EXPL_NONE);
 		fc_frame_free(fp);
-	} else if ((fp = fc_frame_alloc(lp->fl_port, sizeof(*pl))) == NULL) {
-		fp = rx_fp;
-		fc_seq_ls_rjt(sp, ELS_RJT_UNAB, ELS_EXPL_NONE);
-		fc_frame_free(fp);
 	} else {
-		sp = fc_seq_start_next(sp);
-		WARN_ON(!sp);
-		fc_frame_free(rx_fp);
-		fc_remote_port_set_name(rp, wwpn, wwnn);
+		fp = fc_frame_alloc(lp->fl_port, sizeof(*pl));
+		if (fp == NULL) {
+			fp = rx_fp;
+			fc_seq_ls_rjt(sp, ELS_RJT_UNAB, ELS_EXPL_NONE);
+			fc_frame_free(fp);
+		} else {
+			sp = fc_seq_start_next(sp);
+			WARN_ON(!sp);
+			fc_frame_free(rx_fp);
+			fc_remote_port_set_name(rp, wwpn, wwnn);
 
-		/*
-		 * Get session payload size from incoming PLOGI.
-		 */
-		sess->fs_max_payload = (uint16_t)
-		    fc_local_port_get_payload_size(pl, lp->fl_max_payload);
-		pl = fc_frame_payload_get(fp, sizeof(*pl));
-		WARN_ON(!pl);
-		fc_local_port_flogi_fill(lp, pl, ELS_LS_ACC);
+			/*
+			 * Get session payload size from incoming PLOGI.
+			 */
+			sess->fs_max_payload = (uint16_t)
+			    fc_local_port_get_payload_size(pl,
+							lp->fl_max_payload);
+			pl = fc_frame_payload_get(fp, sizeof(*pl));
+			WARN_ON(!pl);
+			fc_local_port_flogi_fill(lp, pl, ELS_LS_ACC);
 
-		/*
-		 * Send LS_ACC.  If this fails, the originator should retry.
-		 */
-		fc_seq_send_last(sp, fp, FC_RCTL_ELS_REP, FC_TYPE_ELS);
-		if (sess->fs_state == SESS_ST_PLOGI)
-			fc_sess_enter_prli(sess);
-		else
-			fc_sess_state_enter(sess, SESS_ST_PLOGI_RECV);
-		fc_sess_hold(sess);	/* represents login */
-		sess->fs_plogi_held = 1;
+			/*
+			 * Send LS_ACC.  If this fails,
+			 * the originator should retry.
+			 */
+			fc_seq_send_last(sp, fp, FC_RCTL_ELS_REP, FC_TYPE_ELS);
+			if (sess->fs_state == SESS_ST_PLOGI)
+				fc_sess_enter_prli(sess);
+			else
+				fc_sess_state_enter(sess, SESS_ST_PLOGI_RECV);
+			fc_sess_hold(sess);	/* represents login */
+			sess->fs_plogi_held = 1;
+		}
 	}
 	fc_sess_unlock_send(sess);
 }

