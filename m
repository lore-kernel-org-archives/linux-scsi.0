From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 11/41] scsi: bfa: bfa_fcs_rport: Mark expected switch
 fall-throughs
Date: Tue, 27 Nov 2018 22:27:23 -0600
Message-ID: <c2a6667094f80fd7f72c887b2e7844b6341ce961.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Notice that I replaced "!! fall through !!" and "!!! fall through !!!"
comments with "fall through" annotations, which is what GCC is
expecting to find.

Addresses-Coverity-ID: 744899 ("Missing break in switch")
Addresses-Coverity-ID: 744900 ("Missing break in switch")
Addresses-Coverity-ID: 744901 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/bfa/bfa_fcs_rport.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index de50349a39ce..1e400f2aaece 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -427,17 +427,13 @@ bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport, enum rport_event event)
 
 	case RPSM_EVENT_LOGO_RCVD:
 		bfa_fcs_rport_send_logo_acc(rport);
-		/*
-		 * !! fall through !!
-		 */
+		/* fall through */
 	case RPSM_EVENT_PRLO_RCVD:
 		if (rport->prlo == BFA_TRUE)
 			bfa_fcs_rport_send_prlo_acc(rport);
 
 		bfa_fcxp_discard(rport->fcxp);
-		/*
-		 * !! fall through !!
-		 */
+		/* fall through */
 	case RPSM_EVENT_FAILED:
 		if (rport->plogi_retries < BFA_FCS_RPORT_MAX_RETRIES) {
 			rport->plogi_retries++;
@@ -868,9 +864,7 @@ bfa_fcs_rport_sm_adisc_online(struct bfa_fcs_rport_s *rport,
 		 * At least go offline when a PLOGI is received.
 		 */
 		bfa_fcxp_discard(rport->fcxp);
-		/*
-		 * !!! fall through !!!
-		 */
+		/* fall through */
 
 	case RPSM_EVENT_FAILED:
 	case RPSM_EVENT_ADDRESS_CHANGE:
@@ -1056,6 +1050,7 @@ bfa_fcs_rport_sm_fc4_logosend(struct bfa_fcs_rport_s *rport,
 
 	case RPSM_EVENT_LOGO_RCVD:
 		bfa_fcs_rport_send_logo_acc(rport);
+		/* fall through */
 	case RPSM_EVENT_PRLO_RCVD:
 		if (rport->prlo == BFA_TRUE)
 			bfa_fcs_rport_send_prlo_acc(rport);
@@ -1144,9 +1139,7 @@ bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
 			bfa_fcs_rport_send_plogiacc(rport, NULL);
 			break;
 		}
-		/*
-		 * !! fall through !!
-		 */
+		/* fall through */
 
 	case RPSM_EVENT_ADDRESS_CHANGE:
 		if (!bfa_fcs_lport_is_online(rport->port)) {
@@ -1303,6 +1296,7 @@ bfa_fcs_rport_sm_hcb_logosend(struct bfa_fcs_rport_s *rport,
 
 	case RPSM_EVENT_LOGO_RCVD:
 		bfa_fcs_rport_send_logo_acc(rport);
+		/* fall through */
 	case RPSM_EVENT_PRLO_RCVD:
 		if (rport->prlo == BFA_TRUE)
 			bfa_fcs_rport_send_prlo_acc(rport);
@@ -1346,6 +1340,7 @@ bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
 
 	case RPSM_EVENT_LOGO_RCVD:
 		bfa_fcs_rport_send_logo_acc(rport);
+		/* fall through */
 	case RPSM_EVENT_PRLO_RCVD:
 		if (rport->prlo == BFA_TRUE)
 			bfa_fcs_rport_send_prlo_acc(rport);
-- 
2.17.1
