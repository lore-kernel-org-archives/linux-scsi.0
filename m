From: <kgudipat@brocade.com>
Subject: [PATCH 03/32] bfa: Defined a new LPS event to clear virtual link on a vport
Date: Wed, 3 Mar 2010 17:42:39 -0800
Message-ID: <1267666959-20618-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:33945 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab0CDBmw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:42:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Clear virtual links was not propagated upwards to bfa from fw.
	  This resulted in HBA and switch being in an inconsistent state.

	- So defined a new LPS event for clear virtual link on a vport,
	  and also now clear virtual link on a baseport, is sent as a
	  link down event from the fw.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_lps.c             |   71 +++++++++++++++++++++++++++++++-
 drivers/scsi/bfa/include/bfa_svc.h     |    1 +
 drivers/scsi/bfa/include/bfi/bfi_lps.h |    8 ++++
 drivers/scsi/bfa/include/cs/bfa_plog.h |    9 +++-
 drivers/scsi/bfa/vport.c               |   11 +++++
 5 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_lps.c b/drivers/scsi/bfa/bfa_lps.c
index 9844b45..c8c2564 100644
--- a/drivers/scsi/bfa/bfa_lps.c
+++ b/drivers/scsi/bfa/bfa_lps.c
@@ -49,7 +49,7 @@ static void bfa_lps_send_login(struct bfa_lps_s *lps);
 static void bfa_lps_send_logout(struct bfa_lps_s *lps);
 static void bfa_lps_login_comp(struct bfa_lps_s *lps);
 static void bfa_lps_logout_comp(struct bfa_lps_s *lps);
-
+static void bfa_lps_cvl_event(struct bfa_lps_s *lps);
 
 /**
  *  lps_pvt BFA LPS private functions
@@ -62,6 +62,7 @@ enum bfa_lps_event {
 	BFA_LPS_SM_RESUME	= 4,	/* space present in reqq queue	*/
 	BFA_LPS_SM_DELETE	= 5,	/* lps delete from user		*/
 	BFA_LPS_SM_OFFLINE	= 6,	/* Link is offline		*/
+	BFA_LPS_SM_RX_CVL       = 7,	/* Rx clear virtual link        */
 };
 
 static void bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event);
@@ -101,6 +102,7 @@ bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		bfa_lps_free(lps);
 		break;
 
+	case BFA_LPS_SM_RX_CVL:
 	case BFA_LPS_SM_OFFLINE:
 		break;
 
@@ -162,6 +164,14 @@ bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		bfa_reqq_wcancel(&lps->wqe);
 		break;
 
+	case BFA_LPS_SM_RX_CVL:
+		/*
+		 * Login was not even sent out; so when getting out
+		 * of this state, it will appear like a login retry
+		 * after Clear virtual link
+		 */
+		break;
+
 	default:
 		bfa_assert(0);
 	}
@@ -187,6 +197,15 @@ bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		}
 		break;
 
+	case BFA_LPS_SM_RX_CVL:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
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
@@ -396,6 +415,20 @@ bfa_lps_logout_rsp(struct bfa_s *bfa, struct bfi_lps_logout_rsp_s *rsp)
 }
 
 /**
+ * Firmware received a Clear virtual link request (for FCoE)
+ */
+static void
+bfa_lps_rx_cvl_event(struct bfa_s *bfa, struct bfi_lps_cvl_event_s *cvl)
+{
+	struct bfa_lps_mod_s    *mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s        *lps;
+
+	lps = BFA_LPS_FROM_TAG(mod, cvl->lp_tag);
+
+	bfa_sm_send_event(lps, BFA_LPS_SM_RX_CVL);
+}
+
+/**
  * Space is available in request queue, resume queueing request to firmware.
  */
 static void
@@ -531,7 +564,39 @@ bfa_lps_logout_comp(struct bfa_lps_s *lps)
 		bfa_cb_lps_flogo_comp(lps->bfa->bfad, lps->uarg);
 }
 
+/**
+ * Clear virtual link completion handler for non-fcs
+ */
+static void
+bfa_lps_cvl_event_cb(void *arg, bfa_boolean_t complete)
+{
+	struct bfa_lps_s *lps   = arg;
+
+	if (!complete)
+		return;
+
+	/* Clear virtual link to base port will result in link down */
+	if (lps->fdisc)
+		bfa_cb_lps_cvl_event(lps->bfa->bfad, lps->uarg);
+}
+
+/**
+ * Received Clear virtual link event --direct call for fcs,
+ * queue for others
+ */
+static void
+bfa_lps_cvl_event(struct bfa_lps_s *lps)
+{
+	if (!lps->bfa->fcs) {
+		bfa_cb_queue(lps->bfa, &lps->hcb_qe, bfa_lps_cvl_event_cb,
+				lps);
+		return;
+	}
 
+	/* Clear virtual link to base port will result in link down */
+	if (lps->fdisc)
+		bfa_cb_lps_cvl_event(lps->bfa->bfad, lps->uarg);
+}
 
 /**
  *  lps_public BFA LPS public functions
@@ -773,6 +838,10 @@ bfa_lps_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 		bfa_lps_logout_rsp(bfa, msg.logout_rsp);
 		break;
 
+	case BFI_LPS_H2I_CVL_EVENT:
+		bfa_lps_rx_cvl_event(bfa, msg.cvl_event);
+		break;
+
 	default:
 		bfa_trc(bfa, m->mhdr.msg_id);
 		bfa_assert(0);
diff --git a/drivers/scsi/bfa/include/bfa_svc.h b/drivers/scsi/bfa/include/bfa_svc.h
index 268d956..2e4372f 100644
--- a/drivers/scsi/bfa/include/bfa_svc.h
+++ b/drivers/scsi/bfa/include/bfa_svc.h
@@ -319,6 +319,7 @@ void bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status);
 void bfa_cb_lps_flogo_comp(void *bfad, void *uarg);
 void bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status);
 void bfa_cb_lps_fdisclogo_comp(void *bfad, void *uarg);
+void bfa_cb_lps_cvl_event(void *bfad, void *uarg);
 
 #endif /* __BFA_SVC_H__ */
 
diff --git a/drivers/scsi/bfa/include/bfi/bfi_lps.h b/drivers/scsi/bfa/include/bfi/bfi_lps.h
index c59d47b..7ed31bb 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_lps.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_lps.h
@@ -30,6 +30,7 @@ enum bfi_lps_h2i_msgs {
 enum bfi_lps_i2h_msgs {
 	BFI_LPS_H2I_LOGIN_RSP	= BFA_I2HM(1),
 	BFI_LPS_H2I_LOGOUT_RSP	= BFA_I2HM(2),
+	BFI_LPS_H2I_CVL_EVENT   = BFA_I2HM(3),
 };
 
 struct bfi_lps_login_req_s {
@@ -77,6 +78,12 @@ struct bfi_lps_logout_rsp_s {
 	u8		rsvd[2];
 };
 
+struct bfi_lps_cvl_event_s {
+	struct bfi_mhdr_s  mh;      /* common msg header      */
+	u8		lp_tag;
+	u8		rsvd[3];
+};
+
 union bfi_lps_h2i_msg_u {
 	struct bfi_mhdr_s		*msg;
 	struct bfi_lps_login_req_s	*login_req;
@@ -87,6 +94,7 @@ union bfi_lps_i2h_msg_u {
 	struct bfi_msg_s		*msg;
 	struct bfi_lps_login_rsp_s	*login_rsp;
 	struct bfi_lps_logout_rsp_s	*logout_rsp;
+	struct bfi_lps_cvl_event_s	*cvl_event;
 };
 
 #pragma pack()
diff --git a/drivers/scsi/bfa/include/cs/bfa_plog.h b/drivers/scsi/bfa/include/cs/bfa_plog.h
index 670f86e..f5bef63 100644
--- a/drivers/scsi/bfa/include/cs/bfa_plog.h
+++ b/drivers/scsi/bfa/include/cs/bfa_plog.h
@@ -80,7 +80,8 @@ enum bfa_plog_mid {
 	BFA_PL_MID_HAL_FCXP 	= 4,
 	BFA_PL_MID_HAL_UF 	= 5,
 	BFA_PL_MID_FCS 		= 6,
-	BFA_PL_MID_MAX 		= 7
+	BFA_PL_MID_LPS		= 7,
+	BFA_PL_MID_MAX 		= 8
 };
 
 #define BFA_PL_MID_STRLEN    8
@@ -118,7 +119,11 @@ enum bfa_plog_eid {
 	BFA_PL_EID_RSCN 		= 17,
 	BFA_PL_EID_DEBUG 		= 18,
 	BFA_PL_EID_MISC 		= 19,
-	BFA_PL_EID_MAX 			= 20
+	BFA_PL_EID_FIP_FCF_DISC		= 20,
+	BFA_PL_EID_FIP_FCF_CVL		= 21,
+	BFA_PL_EID_LOGIN		= 22,
+	BFA_PL_EID_LOGO			= 23,
+	BFA_PL_EID_MAX			= 24
 };
 
 #define BFA_PL_ENAME_STRLEN    	8
diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index e90f1e3..8d18589 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -888,4 +888,15 @@ bfa_cb_lps_fdisclogo_comp(void *bfad, void *uarg)
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_OK);
 }
 
+/**
+ * Received clear virtual link
+ */
+void
+bfa_cb_lps_cvl_event(void *bfad, void *uarg)
+{
+	struct bfa_fcs_vport_s *vport = uarg;
 
+	/* Send an Offline followed by an ONLINE */
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_OFFLINE);
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_ONLINE);
+}
-- 
1.6.5.3

