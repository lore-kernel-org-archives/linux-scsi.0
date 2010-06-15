From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 14/23] bfa: fix uf post and rport fcpim state machine
Date: Tue, 15 Jun 2010 11:44:15 -0700
Message-ID: <1276627455-24788-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:42222 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932355Ab0FOSou (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:44:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

BFA UF module did not hold lock when seding uf post buffer message to firmware
causing CPE-Q corruption. Fix is to check present of FCS and if FCS present
hold lock while posting UF buffers.

Handle PRLO with sending acc to it and relogin with rport. Discard fcxp
before any state change

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_uf.c                    |    5 ++-
 drivers/scsi/bfa/fcpim.c                     |   16 +++---
 drivers/scsi/bfa/fcs_rport.h                 |    1 +
 drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h |    1 +
 drivers/scsi/bfa/rport.c                     |   76 +++++++++++++++++++++++++-
 5 files changed, 89 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_uf.c b/drivers/scsi/bfa/bfa_uf.c
index b2a37fc..b9a9a68 100644
--- a/drivers/scsi/bfa/bfa_uf.c
+++ b/drivers/scsi/bfa/bfa_uf.c
@@ -251,7 +251,10 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
 				      (struct fchs_s *) buf, pld_w0);
 	}
 
-	bfa_cb_queue(bfa, &uf->hcb_qe, __bfa_cb_uf_recv, uf);
+	if (bfa->fcs)
+		__bfa_cb_uf_recv(uf, BFA_TRUE);
+	else
+		bfa_cb_queue(bfa, &uf->hcb_qe, __bfa_cb_uf_recv, uf);
 }
 
 static void
diff --git a/drivers/scsi/bfa/fcpim.c b/drivers/scsi/bfa/fcpim.c
index d090f7a..6b8976a 100644
--- a/drivers/scsi/bfa/fcpim.c
+++ b/drivers/scsi/bfa/fcpim.c
@@ -175,8 +175,12 @@ bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
 
 	switch (event) {
 	case BFA_FCS_ITNIM_SM_RSP_OK:
-		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_hcb_online);
-		bfa_itnim_online(itnim->bfa_itnim, itnim->seq_rec);
+		if (itnim->rport->scsi_function == BFA_RPORT_INITIATOR) {
+			bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_initiator);
+		} else {
+			bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_hcb_online);
+			bfa_itnim_online(itnim->bfa_itnim, itnim->seq_rec);
+		}
 		break;
 
 	case BFA_FCS_ITNIM_SM_RSP_ERROR:
@@ -194,9 +198,7 @@ bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
 
 	case BFA_FCS_ITNIM_SM_INITIATOR:
 		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_initiator);
-		/*
-		 * dont discard fcxp. accept will reach same state
-		 */
+		bfa_fcxp_discard(itnim->fcxp);
 		break;
 
 	case BFA_FCS_ITNIM_SM_DELETE:
@@ -476,7 +478,7 @@ bfa_fcs_itnim_prli_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 					BFA_RPORT_INITIATOR;
 				itnim->stats.prli_rsp_acc++;
 				bfa_sm_send_event(itnim,
-						  BFA_FCS_ITNIM_SM_INITIATOR);
+						  BFA_FCS_ITNIM_SM_RSP_OK);
 				return;
 			}
 
@@ -803,7 +805,7 @@ bfa_fcs_fcpim_uf_recv(struct bfa_fcs_itnim_s *itnim, struct fchs_s *fchs,
 
 	switch (els_cmd->els_code) {
 	case FC_ELS_PRLO:
-		/* bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_PRLO); */
+		bfa_fcs_rport_prlo(itnim->rport, fchs->ox_id);
 		break;
 
 	default:
diff --git a/drivers/scsi/bfa/fcs_rport.h b/drivers/scsi/bfa/fcs_rport.h
index 5242ee0..e634fb7 100644
--- a/drivers/scsi/bfa/fcs_rport.h
+++ b/drivers/scsi/bfa/fcs_rport.h
@@ -43,6 +43,7 @@ void bfa_fcs_rport_plogi_create(struct bfa_fcs_port_s *port,
 void bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
 			struct fc_logi_s *plogi);
 void bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_rport_prlo(struct bfa_fcs_rport_s *rport, uint16_t ox_id);
 void bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_itntm_ack(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_tin_ack(struct bfa_fcs_rport_s *rport);
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h b/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h
index 702b95b..3027fc6 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h
@@ -58,6 +58,7 @@ struct bfa_fcs_rport_s {
 	u16        reply_oxid;	/*  OX_ID of inbound requests */
 	enum fc_cos        fc_cos;	/*  FC classes of service supp */
 	bfa_boolean_t   cisc;	/*  CISC capable device */
+	bfa_boolean_t   prlo;   /*  processing prlo or LOGO */
 	wwn_t           pwwn;	/*  port wwn of rport */
 	wwn_t           nwwn;	/*  node wwn of rport */
 	struct bfa_rport_symname_s psym_name; /*  port symbolic name  */
diff --git a/drivers/scsi/bfa/rport.c b/drivers/scsi/bfa/rport.c
index 4e1fff2..9b4c2c9 100644
--- a/drivers/scsi/bfa/rport.c
+++ b/drivers/scsi/bfa/rport.c
@@ -93,6 +93,7 @@ static void     bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport,
 			u8 reason_code_expl);
 static void     bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
 			struct fchs_s *rx_fchs, u16 len);
+static void	bfa_fcs_rport_send_prlo_acc(struct bfa_fcs_rport_s *rport);
 /**
  *  fcs_rport_sm FCS rport state machine events
  */
@@ -113,7 +114,8 @@ enum rport_event {
 	RPSM_EVENT_HCB_OFFLINE = 13,	/*  BFA rport offline callback */
 	RPSM_EVENT_FC4_OFFLINE = 14,	/*  FC-4 offline complete */
 	RPSM_EVENT_ADDRESS_CHANGE = 15,	/*  Rport's PID has changed */
-	RPSM_EVENT_ADDRESS_DISC = 16	/*  Need to Discover rport's PID */
+	RPSM_EVENT_ADDRESS_DISC = 16,	/*  Need to Discover rport's PID */
+	RPSM_EVENT_PRLO_RCVD = 17,      /*  PRLO from remote device      */
 };
 
 static void     bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport,
@@ -373,6 +375,7 @@ bfa_fcs_rport_sm_plogi_retry(struct bfa_fcs_rport_s *rport,
 		bfa_fcs_rport_free(rport);
 		break;
 
+	case RPSM_EVENT_PRLO_RCVD:
 	case RPSM_EVENT_LOGO_RCVD:
 		break;
 
@@ -428,6 +431,13 @@ bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport, enum rport_event event)
 
 	case RPSM_EVENT_LOGO_RCVD:
 		bfa_fcs_rport_send_logo_acc(rport);
+		/*
+		 * !! fall through !!
+		 */
+	case RPSM_EVENT_PRLO_RCVD:
+		if (rport->prlo == BFA_TRUE)
+			bfa_fcs_rport_send_prlo_acc(rport);
+
 		bfa_fcxp_discard(rport->fcxp);
 		/*
 		 * !! fall through !!
@@ -502,6 +512,9 @@ bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
 		bfa_fcs_rport_online_action(rport);
 		break;
 
+	case RPSM_EVENT_PRLO_RCVD:
+		break;
+
 	case RPSM_EVENT_LOGO_RCVD:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_logorcv);
 		bfa_rport_offline(rport->bfa_rport);
@@ -580,6 +593,7 @@ bfa_fcs_rport_sm_online(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logorcv);
 		bfa_fcs_rport_offline_action(rport);
 		break;
@@ -622,6 +636,7 @@ bfa_fcs_rport_sm_nsquery_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logorcv);
 		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
 		bfa_fcs_rport_offline_action(rport);
@@ -688,6 +703,7 @@ bfa_fcs_rport_sm_nsquery(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logorcv);
 		bfa_fcxp_discard(rport->fcxp);
 		bfa_fcs_rport_offline_action(rport);
@@ -738,6 +754,7 @@ bfa_fcs_rport_sm_adisc_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logorcv);
 		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
 		bfa_fcs_rport_offline_action(rport);
@@ -809,6 +826,7 @@ bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logorcv);
 		bfa_fcxp_discard(rport->fcxp);
 		bfa_fcs_rport_offline_action(rport);
@@ -841,6 +859,7 @@ bfa_fcs_rport_sm_fc4_logorcv(struct bfa_fcs_rport_s *rport,
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 	case RPSM_EVENT_ADDRESS_CHANGE:
 		break;
 
@@ -892,6 +911,7 @@ bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
 	case RPSM_EVENT_SCN:
 	case RPSM_EVENT_LOGO_IMP:
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 	case RPSM_EVENT_ADDRESS_CHANGE:
 		/**
 		 * rport is already going offline.
@@ -951,6 +971,7 @@ bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
 
 	case RPSM_EVENT_SCN:
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 		/**
 		 * Ignore, already offline.
 		 */
@@ -976,8 +997,11 @@ bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
 	switch (event) {
 	case RPSM_EVENT_HCB_OFFLINE:
 	case RPSM_EVENT_ADDRESS_CHANGE:
-		if (rport->pid)
+		if (rport->pid && (rport->prlo == BFA_TRUE))
+			bfa_fcs_rport_send_prlo_acc(rport);
+		if (rport->pid && (rport->prlo == BFA_FALSE))
 			bfa_fcs_rport_send_logo_acc(rport);
+
 		/*
 		 * If the lport is online and if the rport is not a well known
 		 * address port, we try to re-discover the r-port.
@@ -1011,6 +1035,7 @@ bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 		/**
 		 * Ignore - already processing a LOGO.
 		 */
@@ -1040,6 +1065,7 @@ bfa_fcs_rport_sm_hcb_logosend(struct bfa_fcs_rport_s *rport,
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 	case RPSM_EVENT_ADDRESS_CHANGE:
 		break;
 
@@ -1073,6 +1099,7 @@ bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
 		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
 		bfa_fcs_rport_free(rport);
@@ -1121,6 +1148,7 @@ bfa_fcs_rport_sm_offline(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 	case RPSM_EVENT_LOGO_IMP:
 		break;
 
@@ -1172,6 +1200,7 @@ bfa_fcs_rport_sm_nsdisc_sending(struct bfa_fcs_rport_s *rport,
 
 	case RPSM_EVENT_SCN:
 	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PRLO_RCVD:
 	case RPSM_EVENT_PLOGI_SEND:
 		break;
 
@@ -1248,6 +1277,10 @@ bfa_fcs_rport_sm_nsdisc_retry(struct bfa_fcs_rport_s *rport,
 		bfa_fcs_rport_send_logo_acc(rport);
 		break;
 
+	case RPSM_EVENT_PRLO_RCVD:
+		bfa_fcs_rport_send_prlo_acc(rport);
+		break;
+
 	case RPSM_EVENT_PLOGI_COMP:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hal_online);
 		bfa_timer_stop(&rport->timer);
@@ -1320,6 +1353,10 @@ bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 				bfa_fcs_rport_del_timeout);
 		break;
 
+	case RPSM_EVENT_PRLO_RCVD:
+		bfa_fcs_rport_send_prlo_acc(rport);
+		break;
+
 	case RPSM_EVENT_SCN:
 		/**
 		 * ignore, wait for NS query response
@@ -2182,6 +2219,7 @@ bfa_fcs_rport_process_logo(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs)
 	rport->reply_oxid = fchs->ox_id;
 	bfa_trc(rport->fcs, rport->reply_oxid);
 
+	rport->prlo = BFA_FALSE;
 	rport->stats.logo_rcvd++;
 	bfa_sm_send_event(rport, RPSM_EVENT_LOGO_RCVD);
 }
@@ -2551,6 +2589,30 @@ bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
 	}
 }
 
+/* Send best case acc to prlo */
+static void
+bfa_fcs_rport_send_prlo_acc(struct bfa_fcs_rport_s *rport)
+{
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fchs_s fchs;
+	struct bfa_fcxp_s *fcxp;
+	int len;
+
+	bfa_trc(rport->fcs, rport->pid);
+
+	fcxp = bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp)
+		return;
+
+	len = fc_prlo_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			rport->pid, bfa_fcs_port_get_fcid(port),
+			rport->reply_oxid, 0);
+
+	bfa_fcxp_send(fcxp, rport->bfa_rport, port->fabric->vf_id,
+			port->lp_tag, BFA_FALSE, FC_CLASS_3, len, &fchs,
+			NULL, NULL, FC_MAX_PDUSZ, 0);
+}
+
 /*
  * Send a LS reject
  */
@@ -2602,3 +2664,13 @@ bfa_fcs_rport_set_del_timeout(u8 rport_tmo)
 	if (rport_tmo > 0)
 		bfa_fcs_rport_del_timeout = rport_tmo * 1000;
 }
+
+void
+bfa_fcs_rport_prlo(struct bfa_fcs_rport_s *rport, uint16_t ox_id)
+{
+	bfa_trc(rport->fcs, rport->pid);
+
+	rport->prlo = BFA_TRUE;
+	rport->reply_oxid = ox_id;
+	bfa_sm_send_event(rport, RPSM_EVENT_PRLO_RCVD);
+}
-- 
1.6.5.2

