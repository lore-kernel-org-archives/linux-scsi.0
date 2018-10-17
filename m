From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: bfa: Mark expected switch fall-throughs
Date: Wed, 17 Oct 2018 06:47:00 +0200
Message-ID: <20181017044700.GA5579@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114971 ("Missing break in switch")
Addresses-Coverity-ID: 744899 ("Missing break in switch")
Addresses-Coverity-ID: 744900 ("Missing break in switch")
Addresses-Coverity-ID: 744901 ("Missing break in switch")
Addresses-Coverity-ID: 146155 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/bfa/bfa_fcpim.c     |  6 +++---
 drivers/scsi/bfa/bfa_fcs_lport.c |  8 ++------
 drivers/scsi/bfa/bfa_fcs_rport.c | 19 +++++++------------
 drivers/scsi/bfa/bfa_ioc.c       |  9 +++------
 4 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 2c85f5b..e36afa4 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2586,6 +2586,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	case FCP_IODIR_RW:
 		bfa_stats(itnim, input_reqs);
 		bfa_stats(itnim, output_reqs);
+		/* fall through */
 	default:
 		bfi_h2i_set(m->mh, BFI_MC_IOIM_IO, 0, bfa_fn_lpu(ioim->bfa));
 	}
@@ -2820,6 +2821,7 @@ bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 
 	case BFI_IOIM_STS_TIMEDOUT:
 		bfa_stats(ioim->itnim, iocomp_timedout);
+		/* fall through */
 	case BFI_IOIM_STS_ABORTED:
 		rsp->io_status = BFI_IOIM_STS_ABORTED;
 		bfa_stats(ioim->itnim, iocomp_aborted);
@@ -3215,9 +3217,7 @@ bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 	switch (event) {
 	case BFA_TSKIM_SM_DONE:
 		bfa_reqq_wcancel(&tskim->reqq_wait);
-		/*
-		 * Fall through !!!
-		 */
+		/* Fall through */
 	case BFA_TSKIM_SM_QRESUME:
 		bfa_sm_set_state(tskim, bfa_tskim_sm_cleanup);
 		bfa_tskim_send_abort(tskim);
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index b4f2c1d..646f09f 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -6430,9 +6430,7 @@ bfa_fcs_vport_sm_logo_for_stop(struct bfa_fcs_vport_s *vport,
 	switch (event) {
 	case BFA_FCS_VPORT_SM_OFFLINE:
 		bfa_sm_send_event(vport->lps, BFA_LPS_SM_OFFLINE);
-		/*
-		 * !!! fall through !!!
-		 */
+		/* fall through */
 
 	case BFA_FCS_VPORT_SM_RSP_OK:
 	case BFA_FCS_VPORT_SM_RSP_ERROR:
@@ -6458,9 +6456,7 @@ bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
 	switch (event) {
 	case BFA_FCS_VPORT_SM_OFFLINE:
 		bfa_sm_send_event(vport->lps, BFA_LPS_SM_OFFLINE);
-		/*
-		 * !!! fall through !!!
-		 */
+		/* fall through */
 
 	case BFA_FCS_VPORT_SM_RSP_OK:
 	case BFA_FCS_VPORT_SM_RSP_ERROR:
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index de50349..1e400f2 100644
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
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 16d3aeb..32b24e5 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -978,9 +978,7 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 
 	case IOCPF_E_INITFAIL:
 		bfa_iocpf_timer_stop(ioc);
-		/*
-		 * !!! fall through !!!
-		 */
+		/* fall through */
 
 	case IOCPF_E_TIMEOUT:
 		writel(1, ioc->ioc_regs.ioc_sem_reg);
@@ -1056,9 +1054,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 
 	case IOCPF_E_FAIL:
 		bfa_iocpf_timer_stop(ioc);
-		/*
-		 * !!! fall through !!!
-		 */
+		/* fall through */
 
 	case IOCPF_E_TIMEOUT:
 		bfa_ioc_set_cur_ioc_fwstate(ioc, BFI_IOC_FAIL);
@@ -6007,6 +6003,7 @@ bfa_dconf_sm_final_sync(struct bfa_dconf_mod_s *dconf,
 	case BFA_DCONF_SM_IOCDISABLE:
 	case BFA_DCONF_SM_FLASH_COMP:
 		bfa_timer_stop(&dconf->timer);
+		/* fall through */
 	case BFA_DCONF_SM_TIMEOUT:
 		bfa_sm_set_state(dconf, bfa_dconf_sm_uninit);
 		bfa_fsm_send_event(&dconf->bfa->iocfc, IOCFC_E_DCONF_DONE);
-- 
2.7.4
