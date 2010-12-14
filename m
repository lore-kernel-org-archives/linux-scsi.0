From: <kgudipat@brocade.com>
Subject: [PATCH 4/6] bfa: direct attach mode fix.
Date: Mon, 13 Dec 2010 16:17:42 -0800
Message-ID: <1292285862-8468-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:59132 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758013Ab0LNAXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2010 19:23:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Direct attach is not working due to the check of PID in fcxp_send request.
	- Added logic to set the lps->lp_pid with the PID assigned for n2n mode.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs.h       |    1 +
 drivers/scsi/bfa/bfa_fcs_lport.c |    3 +
 drivers/scsi/bfa/bfa_svc.c       |   99 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bfa/bfa_svc.h       |    1 +
 drivers/scsi/bfa/bfi_ms.h        |    8 +++
 5 files changed, 111 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index f0e652b..0fd6316 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -38,6 +38,7 @@ enum bfa_lps_event {
 	BFA_LPS_SM_DELETE	= 5,	/* lps delete from user         */
 	BFA_LPS_SM_OFFLINE	= 6,	/* Link is offline              */
 	BFA_LPS_SM_RX_CVL	= 7,	/* Rx clear virtual link        */
+	BFA_LPS_SM_SET_N2N_PID  = 8,	/* Set assigned PID for n2n */
 };
 
 
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index bf96626..a153646 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -309,6 +309,7 @@ bfa_fcs_lport_plogi(struct bfa_fcs_lport_s *port,
 			return;
 		}
 		port->pid  = rx_fchs->d_id;
+		bfa_lps_set_n2n_pid(port->fabric->lps, rx_fchs->d_id);
 	}
 
 	/*
@@ -323,6 +324,7 @@ bfa_fcs_lport_plogi(struct bfa_fcs_lport_s *port,
 			(memcmp((void *)&bfa_fcs_lport_get_pwwn(port),
 			(void *)&plogi->port_name, sizeof(wwn_t)) < 0)) {
 			port->pid  = rx_fchs->d_id;
+			bfa_lps_set_n2n_pid(port->fabric->lps, rx_fchs->d_id);
 			rport->pid = rx_fchs->s_id;
 		}
 		bfa_fcs_rport_plogi(rport, rx_fchs, plogi);
@@ -979,6 +981,7 @@ bfa_fcs_lport_n2n_online(struct bfa_fcs_lport_s *port)
 	    ((void *)&pcfg->pwwn, (void *)&n2n_port->rem_port_wwn,
 	     sizeof(wwn_t)) > 0) {
 		port->pid = N2N_LOCAL_PID;
+		bfa_lps_set_n2n_pid(port->fabric->lps, N2N_LOCAL_PID);
 		/*
 		 * First, check if we know the device by pwwn.
 		 */
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index bbd8fbb..698a2d6 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -131,6 +131,7 @@ static void bfa_lps_reqq_resume(void *lps_arg);
 static void bfa_lps_free(struct bfa_lps_s *lps);
 static void bfa_lps_send_login(struct bfa_lps_s *lps);
 static void bfa_lps_send_logout(struct bfa_lps_s *lps);
+static void bfa_lps_send_set_n2n_pid(struct bfa_lps_s *lps);
 static void bfa_lps_login_comp(struct bfa_lps_s *lps);
 static void bfa_lps_logout_comp(struct bfa_lps_s *lps);
 static void bfa_lps_cvl_event(struct bfa_lps_s *lps);
@@ -143,6 +144,8 @@ static void bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event);
 static void bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event
 					event);
 static void bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event);
+static void bfa_lps_sm_online_n2n_pid_wait(struct bfa_lps_s *lps,
+					enum bfa_lps_event event);
 static void bfa_lps_sm_logout(struct bfa_lps_s *lps, enum bfa_lps_event event);
 static void bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event
 					event);
@@ -1254,6 +1257,12 @@ bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
 			else
 				bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
 					BFA_PL_EID_LOGIN, 0, "FLOGI Accept");
+			/* If N2N, send the assigned PID to FW */
+			bfa_trc(lps->bfa, lps->fport);
+			bfa_trc(lps->bfa, lps->lp_pid);
+
+			if (!lps->fport && lps->lp_pid)
+				bfa_sm_send_event(lps, BFA_LPS_SM_SET_N2N_PID);
 		} else {
 			bfa_sm_set_state(lps, bfa_lps_sm_init);
 			if (lps->fdisc)
@@ -1272,6 +1281,11 @@ bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		bfa_sm_set_state(lps, bfa_lps_sm_init);
 		break;
 
+	case BFA_LPS_SM_SET_N2N_PID:
+		bfa_trc(lps->bfa, lps->fport);
+		bfa_trc(lps->bfa, lps->lp_pid);
+		break;
+
 	default:
 		bfa_sm_fault(lps->bfa, event);
 	}
@@ -1340,9 +1354,59 @@ bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
 			BFA_PL_EID_FIP_FCF_CVL, 0, "FCF Clear Virt. Link Rx");
 		break;
 
+	case BFA_LPS_SM_SET_N2N_PID:
+		if (bfa_reqq_full(lps->bfa, lps->reqq)) {
+			bfa_sm_set_state(lps, bfa_lps_sm_online_n2n_pid_wait);
+			bfa_reqq_wait(lps->bfa, lps->reqq, &lps->wqe);
+		} else
+			bfa_lps_send_set_n2n_pid(lps);
+                break;
+
+	case BFA_LPS_SM_OFFLINE:
+	case BFA_LPS_SM_DELETE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		break;
+
+	default:
+		bfa_sm_fault(lps->bfa, event);
+	}
+}
+
+/**
+ * login complete
+ */
+static void
+bfa_lps_sm_online_n2n_pid_wait(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_RESUME:
+		bfa_sm_set_state(lps, bfa_lps_sm_online);
+		bfa_lps_send_set_n2n_pid(lps);
+		break;
+
+	case BFA_LPS_SM_LOGOUT:
+		bfa_sm_set_state(lps, bfa_lps_sm_logowait);
+		bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+			BFA_PL_EID_LOGO, 0, "Logout");
+		break;
+
+	case BFA_LPS_SM_RX_CVL:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		bfa_reqq_wcancel(&lps->wqe);
+
+		/* Let the vport module know about this event */
+		bfa_lps_cvl_event(lps);
+		bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+			BFA_PL_EID_FIP_FCF_CVL, 0, "FCF Clear Virt. Link Rx");
+		break;
+
 	case BFA_LPS_SM_OFFLINE:
 	case BFA_LPS_SM_DELETE:
 		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		bfa_reqq_wcancel(&lps->wqe);
 		break;
 
 	default:
@@ -1498,8 +1562,9 @@ bfa_lps_login_rsp(struct bfa_s *bfa, struct bfi_lps_login_rsp_s *rsp)
 	switch (rsp->status) {
 	case BFA_STATUS_OK:
 		lps->fport	= rsp->f_port;
+		if (lps->fport)
+			lps->lp_pid = rsp->lp_pid;
 		lps->npiv_en	= rsp->npiv_en;
-		lps->lp_pid	= rsp->lp_pid;
 		lps->pr_bbcred	= be16_to_cpu(rsp->bb_credit);
 		lps->pr_pwwn	= rsp->port_name;
 		lps->pr_nwwn	= rsp->node_name;
@@ -1626,6 +1691,25 @@ bfa_lps_send_logout(struct bfa_lps_s *lps)
 	bfa_reqq_produce(lps->bfa, lps->reqq);
 }
 
+/**
+ * send n2n pid set request to firmware
+ */
+static void
+bfa_lps_send_set_n2n_pid(struct bfa_lps_s *lps)
+{
+	struct bfi_lps_n2n_pid_req_s *m;
+
+	m = bfa_reqq_next(lps->bfa, lps->reqq);
+	bfa_assert(m);
+
+	bfi_h2i_set(m->mh, BFI_MC_LPS, BFI_LPS_H2I_N2N_PID_REQ,
+		bfa_lpuid(lps->bfa));
+
+	m->lp_tag = lps->lp_tag;
+	m->lp_pid = lps->lp_pid;
+	bfa_reqq_produce(lps->bfa, lps->reqq);
+}
+
 /*
  * Indirect login completion handler for non-fcs
  */
@@ -1846,6 +1930,19 @@ bfa_lps_get_base_pid(struct bfa_s *bfa)
 	return BFA_LPS_FROM_TAG(mod, 0)->lp_pid;
 }
 
+/**
+ * Set PID in case of n2n (which is assigned during PLOGI)
+ */
+void
+bfa_lps_set_n2n_pid(struct bfa_lps_s *lps, uint32_t n2n_pid)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, n2n_pid);
+
+	lps->lp_pid = n2n_pid;
+	bfa_sm_send_event(lps, BFA_LPS_SM_SET_N2N_PID);
+}
+
 /*
  * LPS firmware message class handler.
  */
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index 36c81c7..331ad99 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -610,6 +610,7 @@ void bfa_lps_flogi(struct bfa_lps_s *lps, void *uarg, u8 alpa,
 void bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz,
 		   wwn_t pwwn, wwn_t nwwn);
 void bfa_lps_fdisclogo(struct bfa_lps_s *lps);
+void bfa_lps_set_n2n_pid(struct bfa_lps_s *lps, u32 n2n_pid);
 u32 bfa_lps_get_base_pid(struct bfa_s *bfa);
 u8 bfa_lps_get_tag_from_pid(struct bfa_s *bfa, u32 pid);
 void bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status);
diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
index 8f22ef1..8d1ded3 100644
--- a/drivers/scsi/bfa/bfi_ms.h
+++ b/drivers/scsi/bfa/bfi_ms.h
@@ -342,6 +342,7 @@ struct bfi_uf_frm_rcvd_s {
 enum bfi_lps_h2i_msgs {
 	BFI_LPS_H2I_LOGIN_REQ	= 1,
 	BFI_LPS_H2I_LOGOUT_REQ	= 2,
+	BFI_LPS_H2I_N2N_PID_REQ = 3,
 };
 
 enum bfi_lps_i2h_msgs {
@@ -401,10 +402,17 @@ struct bfi_lps_cvl_event_s {
 	u8		rsvd[3];
 };
 
+struct bfi_lps_n2n_pid_req_s {
+	struct bfi_mhdr_s	mh;	/*  common msg header		*/
+	u8	lp_tag;
+	u32	lp_pid : 24;
+};
+
 union bfi_lps_h2i_msg_u {
 	struct bfi_mhdr_s		*msg;
 	struct bfi_lps_login_req_s	*login_req;
 	struct bfi_lps_logout_req_s	*logout_req;
+	struct bfi_lps_n2n_pid_req_s	*n2n_pid_req;
 };
 
 union bfi_lps_i2h_msg_u {
-- 
1.7.3.rc1

