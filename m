From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 07/24] bfa: use standards defined timeout for ELS/CT
Date: Thu, 8 Jul 2010 19:50:15 -0700
Message-ID: <1278643815-29979-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:36206 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737Ab0GICuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:50:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Use standards defined 2 * RA_TOV as a timeout for ELS Request retries.
And standards defined 3 * RA_TOV as a timeout for FC-CT Request retries.
Also, added a check to send RPSC2 to a Brocade Fabric only.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/fabric.c              |   26 ++++++++++++++++++++++++++
 drivers/scsi/bfa/fcpim.c               |    2 +-
 drivers/scsi/bfa/fcs_fabric.h          |    3 +++
 drivers/scsi/bfa/fdmi.c                |    6 +++---
 drivers/scsi/bfa/include/protocol/fc.h |    1 +
 drivers/scsi/bfa/ms.c                  |    6 +++---
 drivers/scsi/bfa/ns.c                  |   10 +++++-----
 drivers/scsi/bfa/rport.c               |    8 ++++----
 drivers/scsi/bfa/rport_ftrs.c          |   13 +++++++++----
 drivers/scsi/bfa/scn.c                 |    2 +-
 10 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/bfa/fabric.c b/drivers/scsi/bfa/fabric.c
index c646d6d..ddd4ba9 100644
--- a/drivers/scsi/bfa/fabric.c
+++ b/drivers/scsi/bfa/fabric.c
@@ -1027,6 +1027,32 @@ bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric)
 	return fabric->num_vports;
 }
 
+/*
+ *  Get OUI of the attached switch.
+ *
+ *  Note : Use of this function should be avoided as much as possible.
+ *         This function should be used only if there is any requirement
+ *         to check for FOS version below 6.3.
+ *         To check if the attached fabric is a brocade fabric, use
+ *         bfa_lps_is_brcd_fabric() which works for FOS versions 6.3
+ *         or above only.
+ */
+
+u16
+bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric)
+{
+	wwn_t fab_nwwn;
+	u8 *tmp;
+	u16 oui;
+
+	fab_nwwn = bfa_lps_get_peer_nwwn(fabric->lps);
+
+	tmp = (uint8_t *)&fab_nwwn;
+	oui = (tmp[3] << 8) | tmp[4];
+
+	return oui;
+}
+
 /**
  * 		Unsolicited frame receive handling.
  */
diff --git a/drivers/scsi/bfa/fcpim.c b/drivers/scsi/bfa/fcpim.c
index 4120181..7a0207e 100644
--- a/drivers/scsi/bfa/fcpim.c
+++ b/drivers/scsi/bfa/fcpim.c
@@ -422,7 +422,7 @@ bfa_fcs_itnim_send_prli(void *itnim_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	bfa_fcxp_send(fcxp, rport->bfa_rport, port->fabric->vf_id, port->lp_tag,
 		      BFA_FALSE, FC_CLASS_3, len, &fchs,
 		      bfa_fcs_itnim_prli_response, (void *)itnim, FC_MAX_PDUSZ,
-		      FC_RA_TOV);
+		      FC_ELS_TOV);
 
 	itnim->stats.prli_sent++;
 	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_FRMSENT);
diff --git a/drivers/scsi/bfa/fcs_fabric.h b/drivers/scsi/bfa/fcs_fabric.h
index ed532db..432ab8a 100644
--- a/drivers/scsi/bfa/fcs_fabric.h
+++ b/drivers/scsi/bfa/fcs_fabric.h
@@ -26,6 +26,8 @@
 #include <fcs/bfa_fcs_vport.h>
 #include <fcs/bfa_fcs_lport.h>
 
+#define BFA_FCS_BRCD_SWITCH_OUI  0x051e
+
 /*
 * fcs friend functions: only between fcs modules
  */
@@ -60,6 +62,7 @@ void bfa_fcs_auth_finished(struct bfa_fcs_fabric_s *fabric,
 
 void bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 			wwn_t fabric_name);
+u16 bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_get_sym_name(const struct bfa_fcs_s *fcs, char *node_symname);
 
 #endif /* __FCS_FABRIC_H__ */
diff --git a/drivers/scsi/bfa/fdmi.c b/drivers/scsi/bfa/fdmi.c
index 8f17076..2b50eab 100644
--- a/drivers/scsi/bfa/fdmi.c
+++ b/drivers/scsi/bfa/fdmi.c
@@ -532,7 +532,7 @@ bfa_fcs_port_fdmi_send_rhba(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, (len + attr_len), &fchs,
 		      bfa_fcs_port_fdmi_rhba_response, (void *)fdmi,
-		      FC_MAX_PDUSZ, FC_RA_TOV);
+		      FC_MAX_PDUSZ, FC_FCCT_TOV);
 
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RHBA_SENT);
 }
@@ -823,7 +823,7 @@ bfa_fcs_port_fdmi_send_rprt(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len + attr_len, &fchs,
 		      bfa_fcs_port_fdmi_rprt_response, (void *)fdmi,
-		      FC_MAX_PDUSZ, FC_RA_TOV);
+		      FC_MAX_PDUSZ, FC_FCCT_TOV);
 
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RPRT_SENT);
 }
@@ -1043,7 +1043,7 @@ bfa_fcs_port_fdmi_send_rpa(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len + attr_len, &fchs,
 		      bfa_fcs_port_fdmi_rpa_response, (void *)fdmi,
-		      FC_MAX_PDUSZ, FC_RA_TOV);
+		      FC_MAX_PDUSZ, FC_FCCT_TOV);
 
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RPA_SENT);
 }
diff --git a/drivers/scsi/bfa/include/protocol/fc.h b/drivers/scsi/bfa/include/protocol/fc.h
index 8d10380..436dd7c 100644
--- a/drivers/scsi/bfa/include/protocol/fc.h
+++ b/drivers/scsi/bfa/include/protocol/fc.h
@@ -1080,6 +1080,7 @@ struct fc_alpabm_s{
 #define FC_REC_TOV		(FC_ED_TOV + 1)
 #define FC_RA_TOV		10
 #define FC_ELS_TOV		(2 * FC_RA_TOV)
+#define FC_FCCT_TOV		(3 * FC_RA_TOV)
 
 /*
  * virtual fabric related defines
diff --git a/drivers/scsi/bfa/ms.c b/drivers/scsi/bfa/ms.c
index e776bcb..1d579ef 100644
--- a/drivers/scsi/bfa/ms.c
+++ b/drivers/scsi/bfa/ms.c
@@ -361,7 +361,7 @@ bfa_fcs_port_ms_send_gmal(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ms_gmal_response,
-		      (void *)ms, FC_MAX_PDUSZ, FC_RA_TOV);
+		      (void *)ms, FC_MAX_PDUSZ, FC_FCCT_TOV);
 
 	bfa_sm_send_event(ms, MSSM_EVENT_FCXP_SENT);
 }
@@ -560,7 +560,7 @@ bfa_fcs_port_ms_send_gfn(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ms_gfn_response,
-		      (void *)ms, FC_MAX_PDUSZ, FC_RA_TOV);
+		      (void *)ms, FC_MAX_PDUSZ, FC_FCCT_TOV);
 
 	bfa_sm_send_event(ms, MSSM_EVENT_FCXP_SENT);
 }
@@ -640,7 +640,7 @@ bfa_fcs_port_ms_send_plogi(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ms_plogi_response,
-		      (void *)ms, FC_MAX_PDUSZ, FC_RA_TOV);
+		      (void *)ms, FC_MAX_PDUSZ, FC_ELS_TOV);
 
 	port->stats.ms_plogi_sent++;
 	bfa_sm_send_event(ms, MSSM_EVENT_FCXP_SENT);
diff --git a/drivers/scsi/bfa/ns.c b/drivers/scsi/bfa/ns.c
index 2d6d2d6..ae0edcc 100644
--- a/drivers/scsi/bfa/ns.c
+++ b/drivers/scsi/bfa/ns.c
@@ -664,7 +664,7 @@ bfa_fcs_port_ns_send_plogi(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_plogi_response,
-		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+		      (void *)ns, FC_MAX_PDUSZ, FC_ELS_TOV);
 	port->stats.ns_plogi_sent++;
 
 	bfa_sm_send_event(ns, NSSM_EVENT_PLOGI_SENT);
@@ -791,7 +791,7 @@ bfa_fcs_port_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_rspn_id_response,
-		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+		      (void *)ns, FC_MAX_PDUSZ, FC_FCCT_TOV);
 
 	port->stats.ns_rspnid_sent++;
 
@@ -865,7 +865,7 @@ bfa_fcs_port_ns_send_rft_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_rft_id_response,
-		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+		      (void *)ns, FC_MAX_PDUSZ, FC_FCCT_TOV);
 
 	port->stats.ns_rftid_sent++;
 	bfa_sm_send_event(ns, NSSM_EVENT_RFTID_SENT);
@@ -943,7 +943,7 @@ bfa_fcs_port_ns_send_rff_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_rff_id_response,
-		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+		      (void *)ns, FC_MAX_PDUSZ, FC_FCCT_TOV);
 
 	port->stats.ns_rffid_sent++;
 	bfa_sm_send_event(ns, NSSM_EVENT_RFFID_SENT);
@@ -1029,7 +1029,7 @@ bfa_fcs_port_ns_send_gid_ft(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_gid_ft_response,
 		      (void *)ns, bfa_fcxp_get_maxrsp(port->fcs->bfa),
-		      FC_RA_TOV);
+		      FC_FCCT_TOV);
 
 	port->stats.ns_gidft_sent++;
 
diff --git a/drivers/scsi/bfa/rport.c b/drivers/scsi/bfa/rport.c
index 7b096f2..2796403 100644
--- a/drivers/scsi/bfa/rport.c
+++ b/drivers/scsi/bfa/rport.c
@@ -1378,7 +1378,7 @@ bfa_fcs_rport_send_plogi(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_rport_plogi_response,
-		      (void *)rport, FC_MAX_PDUSZ, FC_RA_TOV);
+		      (void *)rport, FC_MAX_PDUSZ, FC_ELS_TOV);
 
 	rport->stats.plogis++;
 	bfa_sm_send_event(rport, RPSM_EVENT_FCXP_SENT);
@@ -1519,7 +1519,7 @@ bfa_fcs_rport_send_adisc(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_rport_adisc_response,
-		      rport, FC_MAX_PDUSZ, FC_RA_TOV);
+		      rport, FC_MAX_PDUSZ, FC_ELS_TOV);
 
 	rport->stats.adisc_sent++;
 	bfa_sm_send_event(rport, RPSM_EVENT_FCXP_SENT);
@@ -1580,7 +1580,7 @@ bfa_fcs_rport_send_gidpn(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_rport_gidpn_response,
-		      (void *)rport, FC_MAX_PDUSZ, FC_RA_TOV);
+		      (void *)rport, FC_MAX_PDUSZ, FC_FCCT_TOV);
 
 	bfa_sm_send_event(rport, RPSM_EVENT_FCXP_SENT);
 }
@@ -1692,7 +1692,7 @@ bfa_fcs_rport_send_logo(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, NULL, rport, FC_MAX_PDUSZ,
-		      FC_ED_TOV);
+		      FC_ELS_TOV);
 
 	rport->stats.logos++;
 	bfa_fcxp_discard(rport->fcxp);
diff --git a/drivers/scsi/bfa/rport_ftrs.c b/drivers/scsi/bfa/rport_ftrs.c
index ae7bba6..acecab8 100644
--- a/drivers/scsi/bfa/rport_ftrs.c
+++ b/drivers/scsi/bfa/rport_ftrs.c
@@ -73,6 +73,7 @@ static void
 bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 {
 	struct bfa_fcs_rport_s *rport = rpf->rport;
+	struct bfa_fcs_fabric_s *fabric = &rport->fcs->fabric;
 
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -80,12 +81,16 @@ bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 
 	switch (event) {
 	case RPFSM_EVENT_RPORT_ONLINE:
-		if (!BFA_FCS_PID_IS_WKA(rport->pid)) {
+		/* Send RPSC2 to a Brocade fabric only. */
+		if ((!BFA_FCS_PID_IS_WKA(rport->pid)) &&
+			((bfa_lps_is_brcd_fabric(rport->port->fabric->lps)) ||
+			(bfa_fcs_fabric_get_switch_oui(fabric) ==
+						BFA_FCS_BRCD_SWITCH_OUI))) {
 			bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc_sending);
 			rpf->rpsc_retries = 0;
 			bfa_fcs_rpf_send_rpsc2(rpf, NULL);
-			break;
-		};
+		}
+		break;
 
 	case RPFSM_EVENT_RPORT_OFFLINE:
 		break;
@@ -307,7 +312,7 @@ bfa_fcs_rpf_send_rpsc2(void *rpf_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 			  FC_CLASS_3, len, &fchs, bfa_fcs_rpf_rpsc2_response,
-			  rpf, FC_MAX_PDUSZ, FC_RA_TOV);
+			  rpf, FC_MAX_PDUSZ, FC_ELS_TOV);
 	rport->stats.rpsc_sent++;
 	bfa_sm_send_event(rpf, RPFSM_EVENT_FCXP_SENT);
 
diff --git a/drivers/scsi/bfa/scn.c b/drivers/scsi/bfa/scn.c
index 8fe09ba..8a60129 100644
--- a/drivers/scsi/bfa/scn.c
+++ b/drivers/scsi/bfa/scn.c
@@ -218,7 +218,7 @@ bfa_fcs_port_scn_send_scr(void *scn_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_scn_scr_response,
-		      (void *)scn, FC_MAX_PDUSZ, FC_RA_TOV);
+		      (void *)scn, FC_MAX_PDUSZ, FC_ELS_TOV);
 
 	bfa_sm_send_event(scn, SCNSM_EVENT_SCR_SENT);
 }
-- 
1.6.5.2

