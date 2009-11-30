From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 6/8] bfa: fcs changes part 2
Date: Sun, 29 Nov 2009 17:42:12 -0800
Message-ID: <1259545332-4930-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:30861 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZK3BmI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 20:42:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

fcs changes part 2:
 - Call fdmi offline when ms module receives a port offline.
 - Changes related to port structures renaming.
 - Rport state machine fixes. In direct attach mode, do not query the name
   server after a target is marked offline.
 - Fixed issue of vport not being removed after FIP Clear Virtual Links command
   received for the vport.
 - Changes to provide separate functions to do attach time FCS initialization
   and initialization after IOC is up for better firmware upgrade handling.
 - Changed max vport for FCOE from 191 to 190.
 - Changes to remove ioc_attr local variable from stack.
 - Misc style and formatting changes.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/ms.c         |  214 ++++++-------
 drivers/scsi/bfa/n2n.c        |    6 +-
 drivers/scsi/bfa/ns.c         |  228 +++++++-------
 drivers/scsi/bfa/rport.c      |  724 ++++++++++++++++++++---------------------
 drivers/scsi/bfa/rport_api.c  |    8 +-
 drivers/scsi/bfa/rport_ftrs.c |   25 +-
 drivers/scsi/bfa/scn.c        |   86 +++---
 drivers/scsi/bfa/vport.c      |  174 ++++------
 8 files changed, 697 insertions(+), 768 deletions(-)

diff --git a/drivers/scsi/bfa/ms.c b/drivers/scsi/bfa/ms.c
index c96b3ca..ff0b7cf 100644
--- a/drivers/scsi/bfa/ms.c
+++ b/drivers/scsi/bfa/ms.c
@@ -41,24 +41,24 @@ static void     bfa_fcs_port_ms_plogi_response(void *fcsarg,
 					       u32 resid_len,
 					       struct fchs_s *rsp_fchs);
 
-static void     bfa_fcs_port_ms_send_gmal(void *ms_cbarg,
-					  struct bfa_fcxp_s *fcxp_alloced);
+static void 	bfa_fcs_port_ms_send_gmal(void *ms_cbarg,
+					struct bfa_fcxp_s *fcxp_alloced);
 static void     bfa_fcs_port_ms_gmal_response(void *fcsarg,
-					      struct bfa_fcxp_s *fcxp,
-					      void *cbarg,
-					      bfa_status_t req_status,
-					      u32 rsp_len,
-					      u32 resid_len,
-					      struct fchs_s *rsp_fchs);
-static void     bfa_fcs_port_ms_send_gfn(void *ms_cbarg,
-					 struct bfa_fcxp_s *fcxp_alloced);
+					       struct bfa_fcxp_s *fcxp,
+					       void *cbarg,
+					       bfa_status_t req_status,
+					       u32 rsp_len,
+					       u32 resid_len,
+					       struct fchs_s *rsp_fchs);
+static void 	bfa_fcs_port_ms_send_gfn(void *ms_cbarg,
+					struct bfa_fcxp_s *fcxp_alloced);
 static void     bfa_fcs_port_ms_gfn_response(void *fcsarg,
-					     struct bfa_fcxp_s *fcxp,
-					     void *cbarg,
-					     bfa_status_t req_status,
-					     u32 rsp_len,
-					     u32 resid_len,
-					     struct fchs_s *rsp_fchs);
+					       struct bfa_fcxp_s *fcxp,
+					       void *cbarg,
+					       bfa_status_t req_status,
+					       u32 rsp_len,
+					       u32 resid_len,
+					       struct fchs_s *rsp_fchs);
 /**
  *  fcs_ms_sm FCS MS state machine
  */
@@ -85,17 +85,17 @@ static void     bfa_fcs_port_ms_sm_plogi(struct bfa_fcs_port_ms_s *ms,
 static void     bfa_fcs_port_ms_sm_plogi_retry(struct bfa_fcs_port_ms_s *ms,
 					       enum port_ms_event event);
 static void     bfa_fcs_port_ms_sm_gmal_sending(struct bfa_fcs_port_ms_s *ms,
-						enum port_ms_event event);
+						 enum port_ms_event event);
 static void     bfa_fcs_port_ms_sm_gmal(struct bfa_fcs_port_ms_s *ms,
-					enum port_ms_event event);
+					 enum port_ms_event event);
 static void     bfa_fcs_port_ms_sm_gmal_retry(struct bfa_fcs_port_ms_s *ms,
-					      enum port_ms_event event);
-static void     bfa_fcs_port_ms_sm_gfn_sending(struct bfa_fcs_port_ms_s *ms,
 					       enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_gfn_sending(struct bfa_fcs_port_ms_s *ms,
+						 enum port_ms_event event);
 static void     bfa_fcs_port_ms_sm_gfn(struct bfa_fcs_port_ms_s *ms,
-				       enum port_ms_event event);
+					 enum port_ms_event event);
 static void     bfa_fcs_port_ms_sm_gfn_retry(struct bfa_fcs_port_ms_s *ms,
-					     enum port_ms_event event);
+					       enum port_ms_event event);
 static void     bfa_fcs_port_ms_sm_online(struct bfa_fcs_port_ms_s *ms,
 					  enum port_ms_event event);
 /**
@@ -103,7 +103,7 @@ static void     bfa_fcs_port_ms_sm_online(struct bfa_fcs_port_ms_s *ms,
  */
 static void
 bfa_fcs_port_ms_sm_offline(struct bfa_fcs_port_ms_s *ms,
-			   enum port_ms_event event)
+				enum port_ms_event event)
 {
 	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
 	bfa_trc(ms->port->fcs, event);
@@ -118,13 +118,13 @@ bfa_fcs_port_ms_sm_offline(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ms_sm_plogi_sending(struct bfa_fcs_port_ms_s *ms,
-				 enum port_ms_event event)
+					enum port_ms_event event)
 {
 	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
 	bfa_trc(ms->port->fcs, event);
@@ -137,11 +137,11 @@ bfa_fcs_port_ms_sm_plogi_sending(struct bfa_fcs_port_ms_s *ms,
 	case MSSM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
-				       &ms->fcxp_wqe);
+					   &ms->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -157,9 +157,9 @@ bfa_fcs_port_ms_sm_plogi(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		 * Start timer for a delayed retry
 		 */
 		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_plogi_retry);
-		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ms->port), &ms->timer,
-				bfa_fcs_port_ms_timeout, ms,
-				BFA_FCS_RETRY_TIMEOUT);
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
+				    &ms->timer, bfa_fcs_port_ms_timeout, ms,
+				    BFA_FCS_RETRY_TIMEOUT);
 		break;
 
 	case MSSM_EVENT_RSP_OK:
@@ -190,13 +190,13 @@ bfa_fcs_port_ms_sm_plogi(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ms_sm_plogi_retry(struct bfa_fcs_port_ms_s *ms,
-			       enum port_ms_event event)
+					enum port_ms_event event)
 {
 	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
 	bfa_trc(ms->port->fcs, event);
@@ -216,13 +216,13 @@ bfa_fcs_port_ms_sm_plogi_retry(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ms_sm_online(struct bfa_fcs_port_ms_s *ms,
-			  enum port_ms_event event)
+				enum port_ms_event event)
 {
 	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
 	bfa_trc(ms->port->fcs, event);
@@ -230,10 +230,6 @@ bfa_fcs_port_ms_sm_online(struct bfa_fcs_port_ms_s *ms,
 	switch (event) {
 	case MSSM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
-		/*
-		 * now invoke MS related sub-modules
-		 */
-		bfa_fcs_port_fdmi_offline(ms);
 		break;
 
 	case MSSM_EVENT_PORT_FABRIC_RSCN:
@@ -243,13 +239,13 @@ bfa_fcs_port_ms_sm_online(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ms_sm_gmal_sending(struct bfa_fcs_port_ms_s *ms,
-				enum port_ms_event event)
+					enum port_ms_event event)
 {
 	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
 	bfa_trc(ms->port->fcs, event);
@@ -262,11 +258,11 @@ bfa_fcs_port_ms_sm_gmal_sending(struct bfa_fcs_port_ms_s *ms,
 	case MSSM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
-				       &ms->fcxp_wqe);
+					   &ms->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -304,13 +300,13 @@ bfa_fcs_port_ms_sm_gmal(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ms_sm_gmal_retry(struct bfa_fcs_port_ms_s *ms,
-			      enum port_ms_event event)
+					enum port_ms_event event)
 {
 	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
 	bfa_trc(ms->port->fcs, event);
@@ -330,10 +326,9 @@ bfa_fcs_port_ms_sm_gmal_retry(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
-
 /**
  *  ms_pvt MS local functions
  */
@@ -352,35 +347,36 @@ bfa_fcs_port_ms_send_gmal(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
 	if (!fcxp) {
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &ms->fcxp_wqe,
-				    bfa_fcs_port_ms_send_gmal, ms);
+					bfa_fcs_port_ms_send_gmal, ms);
 		return;
 	}
 	ms->fcxp = fcxp;
 
 	len = fc_gmal_req_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-				bfa_fcs_port_get_fcid(port),
-				bfa_lps_get_peer_nwwn(port->fabric->lps));
+			     bfa_fcs_port_get_fcid(port),
+				 bfa_lps_get_peer_nwwn(port->fabric->lps));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ms_gmal_response,
-		      (void *)ms, FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, len, &fchs,
+			  bfa_fcs_port_ms_gmal_response, (void *)ms,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
 
 	bfa_sm_send_event(ms, MSSM_EVENT_FCXP_SENT);
 }
 
 static void
 bfa_fcs_port_ms_gmal_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
-			      void *cbarg, bfa_status_t req_status,
-			      u32 rsp_len, u32 resid_len,
-			      struct fchs_s *rsp_fchs)
+				void *cbarg, bfa_status_t req_status,
+				u32 rsp_len, u32 resid_len,
+				struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *)cbarg;
+	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *) cbarg;
 	struct bfa_fcs_port_s *port = ms->port;
 	struct ct_hdr_s       *cthdr = NULL;
 	struct fcgs_gmal_resp_s *gmal_resp;
 	struct fc_gmal_entry_s *gmal_entry;
-	u32        num_entries;
-	u8        *rsp_str;
+	u32		num_entries;
+	u8 		*rsp_str;
 
 	bfa_trc(port->fcs, req_status);
 	bfa_trc(port->fcs, port->port_cfg.pwwn);
@@ -399,35 +395,34 @@ bfa_fcs_port_ms_gmal_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		gmal_resp = (struct fcgs_gmal_resp_s *)(cthdr + 1);
+
 		num_entries = bfa_os_ntohl(gmal_resp->ms_len);
 		if (num_entries == 0) {
 			bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
 			return;
 		}
 		/*
-		 * The response could contain multiple Entries.
-		 * Entries for SNMP interface, etc.
-		 * We look for the entry with a telnet prefix.
-		 * First "http://" entry refers to IP addr
-		 */
+		* The response could contain multiple Entries.
+		* Entries for SNMP interface, etc.
+		* We look for the entry with a telnet prefix.
+		* First "http://" entry refers to IP addr
+		*/
 
 		gmal_entry = (struct fc_gmal_entry_s *)gmal_resp->ms_ma;
 		while (num_entries > 0) {
-			if (strncmp
-			    (gmal_entry->prefix, CT_GMAL_RESP_PREFIX_HTTP,
-			     sizeof(gmal_entry->prefix)) == 0) {
+			if (strncmp(gmal_entry->prefix,
+					CT_GMAL_RESP_PREFIX_HTTP,
+					sizeof(gmal_entry->prefix)) == 0) {
 
-				/*
-				 * if the IP address is terminating with a '/',
-				 * remove it. *Byte 0 consists of the length
+				/* If the IP address is terminating with a '/',
+				 * remove it. Byte 0 consists of the length
 				 * of the string.
 				 */
 				rsp_str = &(gmal_entry->prefix[0]);
-				if (rsp_str[gmal_entry->len - 1] == '/')
-					rsp_str[gmal_entry->len - 1] = 0;
-				/*
-				 * copy IP Address to fabric
-				 */
+				if (rsp_str[gmal_entry->len-1] == '/')
+					rsp_str[gmal_entry->len-1] = 0;
+
+				/* copy IP Address to fabric */
 				strncpy(bfa_fcs_port_get_fabric_ipaddr(port),
 					gmal_entry->ip_addr,
 					BFA_FCS_FABRIC_IPADDR_SZ);
@@ -449,7 +444,7 @@ bfa_fcs_port_ms_gmal_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 
 static void
 bfa_fcs_port_ms_sm_gfn_sending(struct bfa_fcs_port_ms_s *ms,
-			       enum port_ms_event event)
+					enum port_ms_event event)
 {
 	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
 	bfa_trc(ms->port->fcs, event);
@@ -462,11 +457,11 @@ bfa_fcs_port_ms_sm_gfn_sending(struct bfa_fcs_port_ms_s *ms,
 	case MSSM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
-				       &ms->fcxp_wqe);
+					   &ms->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -484,8 +479,9 @@ bfa_fcs_port_ms_sm_gfn(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		if (ms->retry_cnt++ < BFA_FCS_MS_CMD_MAX_RETRIES) {
 			bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gfn_retry);
 			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
-					&ms->timer, bfa_fcs_port_ms_timeout, ms,
-					BFA_FCS_RETRY_TIMEOUT);
+						&ms->timer,
+						bfa_fcs_port_ms_timeout, ms,
+						BFA_FCS_RETRY_TIMEOUT);
 		} else {
 			bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_online);
 			ms->retry_cnt = 0;
@@ -502,13 +498,13 @@ bfa_fcs_port_ms_sm_gfn(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ms_sm_gfn_retry(struct bfa_fcs_port_ms_s *ms,
-			     enum port_ms_event event)
+					enum port_ms_event event)
 {
 	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
 	bfa_trc(ms->port->fcs, event);
@@ -528,10 +524,9 @@ bfa_fcs_port_ms_sm_gfn_retry(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
-
 /**
  *  ms_pvt MS local functions
  */
@@ -550,31 +545,32 @@ bfa_fcs_port_ms_send_gfn(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
 	if (!fcxp) {
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &ms->fcxp_wqe,
-				    bfa_fcs_port_ms_send_gfn, ms);
+					bfa_fcs_port_ms_send_gfn, ms);
 		return;
 	}
 	ms->fcxp = fcxp;
 
 	len = fc_gfn_req_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-			       bfa_fcs_port_get_fcid(port),
-			       bfa_lps_get_peer_nwwn(port->fabric->lps));
+			     bfa_fcs_port_get_fcid(port),
+				 bfa_lps_get_peer_nwwn(port->fabric->lps));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ms_gfn_response,
-		      (void *)ms, FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, len, &fchs,
+			  bfa_fcs_port_ms_gfn_response, (void *)ms,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
 
 	bfa_sm_send_event(ms, MSSM_EVENT_FCXP_SENT);
 }
 
 static void
 bfa_fcs_port_ms_gfn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
-			     bfa_status_t req_status, u32 rsp_len,
+			       bfa_status_t req_status, u32 rsp_len,
 			       u32 resid_len, struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *)cbarg;
+	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *) cbarg;
 	struct bfa_fcs_port_s *port = ms->port;
 	struct ct_hdr_s       *cthdr = NULL;
-	wwn_t          *gfn_resp;
+	wwn_t	       *gfn_resp;
 
 	bfa_trc(port->fcs, req_status);
 	bfa_trc(port->fcs, port->port_cfg.pwwn);
@@ -592,14 +588,12 @@ bfa_fcs_port_ms_gfn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
-		gfn_resp = (wwn_t *) (cthdr + 1);
-		/*
-		 * check if it has actually changed
-		 */
-		if ((memcmp
-		     ((void *)&bfa_fcs_port_get_fabric_name(port), gfn_resp,
-		      sizeof(wwn_t)) != 0))
+		gfn_resp = (wwn_t *)(cthdr + 1);
+		/* check if it has actually changed */
+		if ((memcmp((void *)&bfa_fcs_port_get_fabric_name(port),
+				gfn_resp, sizeof(wwn_t)) != 0)) {
 			bfa_fcs_fabric_set_fabric_name(port->fabric, *gfn_resp);
+		}
 		bfa_sm_send_event(ms, MSSM_EVENT_RSP_OK);
 		return;
 	}
@@ -628,7 +622,7 @@ bfa_fcs_port_ms_send_plogi(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	if (!fcxp) {
 		port->stats.ms_plogi_alloc_wait++;
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &ms->fcxp_wqe,
-				    bfa_fcs_port_ms_send_plogi, ms);
+					bfa_fcs_port_ms_send_plogi, ms);
 		return;
 	}
 	ms->fcxp = fcxp;
@@ -637,11 +631,12 @@ bfa_fcs_port_ms_send_plogi(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 			     bfa_os_hton3b(FC_MGMT_SERVER),
 			     bfa_fcs_port_get_fcid(port), 0,
 			     port->port_cfg.pwwn, port->port_cfg.nwwn,
-			     bfa_pport_get_maxfrsize(port->fcs->bfa));
+				 bfa_fcport_get_maxfrsize(port->fcs->bfa));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ms_plogi_response,
-		      (void *)ms, FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, len, &fchs,
+			  bfa_fcs_port_ms_plogi_response, (void *)ms,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
 
 	port->stats.ms_plogi_sent++;
 	bfa_sm_send_event(ms, MSSM_EVENT_FCXP_SENT);
@@ -649,12 +644,11 @@ bfa_fcs_port_ms_send_plogi(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 static void
 bfa_fcs_port_ms_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
-			       void *cbarg, bfa_status_t req_status,
-			       u32 rsp_len, u32 resid_len,
-			       struct fchs_s *rsp_fchs)
+				void *cbarg, bfa_status_t req_status,
+				u32 rsp_len, u32 resid_len,
+				struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *)cbarg;
-
+	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *) cbarg;
 	struct bfa_fcs_port_s *port = ms->port;
 	struct fc_els_cmd_s   *els_cmd;
 	struct fc_ls_rjt_s    *ls_rjt;
@@ -707,7 +701,7 @@ bfa_fcs_port_ms_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 static void
 bfa_fcs_port_ms_timeout(void *arg)
 {
-	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *)arg;
+	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *) arg;
 
 	ms->port->stats.ms_timeouts++;
 	bfa_sm_send_event(ms, MSSM_EVENT_TIMEOUT);
@@ -735,6 +729,7 @@ bfa_fcs_port_ms_offline(struct bfa_fcs_port_s *port)
 
 	ms->port = port;
 	bfa_sm_send_event(ms, MSSM_EVENT_PORT_OFFLINE);
+	bfa_fcs_port_fdmi_offline(ms);
 }
 
 void
@@ -745,15 +740,12 @@ bfa_fcs_port_ms_online(struct bfa_fcs_port_s *port)
 	ms->port = port;
 	bfa_sm_send_event(ms, MSSM_EVENT_PORT_ONLINE);
 }
-
 void
 bfa_fcs_port_ms_fabric_rscn(struct bfa_fcs_port_s *port)
 {
 	struct bfa_fcs_port_ms_s *ms = BFA_FCS_GET_MS_FROM_PORT(port);
 
-	/*
-	 * @todo.  Handle this only when in Online state
-	 */
+	/* todo.  Handle this only  when in Online state */
 	if (bfa_sm_cmp_state(ms, bfa_fcs_port_ms_sm_online))
 		bfa_sm_send_event(ms, MSSM_EVENT_PORT_FABRIC_RSCN);
 }
diff --git a/drivers/scsi/bfa/n2n.c b/drivers/scsi/bfa/n2n.c
index 7354568..ac66bf0 100644
--- a/drivers/scsi/bfa/n2n.c
+++ b/drivers/scsi/bfa/n2n.c
@@ -63,7 +63,7 @@ bfa_fcs_port_n2n_online(struct bfa_fcs_port_s *port)
 		 * First, check if we know the device by pwwn.
 		 */
 		rport = bfa_fcs_port_get_rport_by_pwwn(port,
-						       n2n_port->rem_port_wwn);
+							n2n_port->rem_port_wwn);
 		if (rport) {
 			bfa_trc(port->fcs, rport->pid);
 			bfa_trc(port->fcs, rport->pwwn);
@@ -73,8 +73,8 @@ bfa_fcs_port_n2n_online(struct bfa_fcs_port_s *port)
 		}
 
 		/*
-		 * In n2n there can be only one rport. Delete the old one whose
-		 * pid should be zero, because it is offline.
+		 * In n2n there can be only one rport. Delete the old one
+		 * whose pid should be zero, because it is offline.
 		 */
 		if (port->num_rports > 0) {
 			rport = bfa_fcs_port_get_rport_by_pid(port, 0);
diff --git a/drivers/scsi/bfa/ns.c b/drivers/scsi/bfa/ns.c
index 2f8b880..7ffdef6 100644
--- a/drivers/scsi/bfa/ns.c
+++ b/drivers/scsi/bfa/ns.c
@@ -88,7 +88,7 @@ static void     bfa_fcs_port_ns_process_gidft_pids(struct bfa_fcs_port_s *port,
 						   u32 *pid_buf,
 						   u32 n_pids);
 
-static void     bfa_fcs_port_ns_boot_target_disc(struct bfa_fcs_port_s *port);
+static void bfa_fcs_port_ns_boot_target_disc(struct bfa_fcs_port_s *port);
 /**
  *  fcs_ns_sm FCS nameserver interface state machine
  */
@@ -149,7 +149,7 @@ static void     bfa_fcs_port_ns_sm_online(struct bfa_fcs_port_ns_s *ns,
  */
 static void
 bfa_fcs_port_ns_sm_offline(struct bfa_fcs_port_ns_s *ns,
-			   enum vport_ns_event event)
+			enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
@@ -164,13 +164,13 @@ bfa_fcs_port_ns_sm_offline(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ns_sm_plogi_sending(struct bfa_fcs_port_ns_s *ns,
-				 enum vport_ns_event event)
+					enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
@@ -183,17 +183,17 @@ bfa_fcs_port_ns_sm_plogi_sending(struct bfa_fcs_port_ns_s *ns,
 	case NSSM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
-				       &ns->fcxp_wqe);
+					   &ns->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ns_sm_plogi(struct bfa_fcs_port_ns_s *ns,
-			 enum vport_ns_event event)
+				enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
@@ -205,9 +205,9 @@ bfa_fcs_port_ns_sm_plogi(struct bfa_fcs_port_ns_s *ns,
 		 */
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_plogi_retry);
 		ns->port->stats.ns_retries++;
-		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port), &ns->timer,
-				bfa_fcs_port_ns_timeout, ns,
-				BFA_FCS_RETRY_TIMEOUT);
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
+				    &ns->timer, bfa_fcs_port_ns_timeout, ns,
+				    BFA_FCS_RETRY_TIMEOUT);
 		break;
 
 	case NSSM_EVENT_RSP_OK:
@@ -221,13 +221,13 @@ bfa_fcs_port_ns_sm_plogi(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ns_sm_plogi_retry(struct bfa_fcs_port_ns_s *ns,
-			       enum vport_ns_event event)
+				enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
@@ -247,7 +247,7 @@ bfa_fcs_port_ns_sm_plogi_retry(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -266,17 +266,17 @@ bfa_fcs_port_ns_sm_sending_rspn_id(struct bfa_fcs_port_ns_s *ns,
 	case NSSM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
-				       &ns->fcxp_wqe);
+					   &ns->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ns_sm_rspn_id(struct bfa_fcs_port_ns_s *ns,
-			   enum vport_ns_event event)
+				enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
@@ -288,9 +288,9 @@ bfa_fcs_port_ns_sm_rspn_id(struct bfa_fcs_port_ns_s *ns,
 		 */
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_rspn_id_retry);
 		ns->port->stats.ns_retries++;
-		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port), &ns->timer,
-				bfa_fcs_port_ns_timeout, ns,
-				BFA_FCS_RETRY_TIMEOUT);
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
+				    &ns->timer, bfa_fcs_port_ns_timeout, ns,
+				    BFA_FCS_RETRY_TIMEOUT);
 		break;
 
 	case NSSM_EVENT_RSP_OK:
@@ -304,13 +304,13 @@ bfa_fcs_port_ns_sm_rspn_id(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ns_sm_rspn_id_retry(struct bfa_fcs_port_ns_s *ns,
-				 enum vport_ns_event event)
+					enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
@@ -330,7 +330,7 @@ bfa_fcs_port_ns_sm_rspn_id_retry(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -349,26 +349,24 @@ bfa_fcs_port_ns_sm_sending_rft_id(struct bfa_fcs_port_ns_s *ns,
 	case NSSM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
-				       &ns->fcxp_wqe);
+					   &ns->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ns_sm_rft_id(struct bfa_fcs_port_ns_s *ns,
-			  enum vport_ns_event event)
+					enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
 
 	switch (event) {
 	case NSSM_EVENT_RSP_OK:
-		/*
-		 * Now move to register FC4 Features
-		 */
+		/* Now move to register FC4 Features */
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_sending_rff_id);
 		bfa_fcs_port_ns_send_rff_id(ns, NULL);
 		break;
@@ -379,9 +377,9 @@ bfa_fcs_port_ns_sm_rft_id(struct bfa_fcs_port_ns_s *ns,
 		 */
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_rft_id_retry);
 		ns->port->stats.ns_retries++;
-		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port), &ns->timer,
-				bfa_fcs_port_ns_timeout, ns,
-				BFA_FCS_RETRY_TIMEOUT);
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
+				    &ns->timer, bfa_fcs_port_ns_timeout, ns,
+				    BFA_FCS_RETRY_TIMEOUT);
 		break;
 
 	case NSSM_EVENT_PORT_OFFLINE:
@@ -390,13 +388,13 @@ bfa_fcs_port_ns_sm_rft_id(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ns_sm_rft_id_retry(struct bfa_fcs_port_ns_s *ns,
-				enum vport_ns_event event)
+					enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
@@ -413,7 +411,7 @@ bfa_fcs_port_ns_sm_rft_id_retry(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -432,17 +430,17 @@ bfa_fcs_port_ns_sm_sending_rff_id(struct bfa_fcs_port_ns_s *ns,
 	case NSSM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
-				       &ns->fcxp_wqe);
+					   &ns->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ns_sm_rff_id(struct bfa_fcs_port_ns_s *ns,
-			  enum vport_ns_event event)
+				enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
@@ -483,9 +481,9 @@ bfa_fcs_port_ns_sm_rff_id(struct bfa_fcs_port_ns_s *ns,
 		 */
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_rff_id_retry);
 		ns->port->stats.ns_retries++;
-		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port), &ns->timer,
-				bfa_fcs_port_ns_timeout, ns,
-				BFA_FCS_RETRY_TIMEOUT);
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
+				    &ns->timer, bfa_fcs_port_ns_timeout, ns,
+				    BFA_FCS_RETRY_TIMEOUT);
 		break;
 
 	case NSSM_EVENT_PORT_OFFLINE:
@@ -494,7 +492,7 @@ bfa_fcs_port_ns_sm_rff_id(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -517,7 +515,7 @@ bfa_fcs_port_ns_sm_rff_id_retry(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 static void
@@ -535,17 +533,17 @@ bfa_fcs_port_ns_sm_sending_gid_ft(struct bfa_fcs_port_ns_s *ns,
 	case NSSM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
-				       &ns->fcxp_wqe);
+					   &ns->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ns_sm_gid_ft(struct bfa_fcs_port_ns_s *ns,
-			  enum vport_ns_event event)
+					enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
@@ -564,9 +562,9 @@ bfa_fcs_port_ns_sm_gid_ft(struct bfa_fcs_port_ns_s *ns,
 		 */
 		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_gid_ft_retry);
 		ns->port->stats.ns_retries++;
-		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port), &ns->timer,
-				bfa_fcs_port_ns_timeout, ns,
-				BFA_FCS_RETRY_TIMEOUT);
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
+				    &ns->timer, bfa_fcs_port_ns_timeout, ns,
+				    BFA_FCS_RETRY_TIMEOUT);
 		break;
 
 	case NSSM_EVENT_PORT_OFFLINE:
@@ -575,7 +573,7 @@ bfa_fcs_port_ns_sm_gid_ft(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -598,13 +596,13 @@ bfa_fcs_port_ns_sm_gid_ft_retry(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_ns_sm_online(struct bfa_fcs_port_ns_s *ns,
-			  enum vport_ns_event event)
+				enum vport_ns_event event)
 {
 	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
 	bfa_trc(ns->port->fcs, event);
@@ -626,7 +624,7 @@ bfa_fcs_port_ns_sm_online(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -651,7 +649,7 @@ bfa_fcs_port_ns_send_plogi(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	if (!fcxp) {
 		port->stats.ns_plogi_alloc_wait++;
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
-				    bfa_fcs_port_ns_send_plogi, ns);
+					bfa_fcs_port_ns_send_plogi, ns);
 		return;
 	}
 	ns->fcxp = fcxp;
@@ -660,11 +658,12 @@ bfa_fcs_port_ns_send_plogi(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 			     bfa_os_hton3b(FC_NAME_SERVER),
 			     bfa_fcs_port_get_fcid(port), 0,
 			     port->port_cfg.pwwn, port->port_cfg.nwwn,
-			     bfa_pport_get_maxfrsize(port->fcs->bfa));
+				 bfa_fcport_get_maxfrsize(port->fcs->bfa));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_plogi_response,
-		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, len, &fchs,
+			  bfa_fcs_port_ns_plogi_response, (void *)ns,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
 	port->stats.ns_plogi_sent++;
 
 	bfa_sm_send_event(ns, NSSM_EVENT_PLOGI_SENT);
@@ -672,11 +671,11 @@ bfa_fcs_port_ns_send_plogi(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 static void
 bfa_fcs_port_ns_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
-			       void *cbarg, bfa_status_t req_status,
-			       u32 rsp_len, u32 resid_len,
-			       struct fchs_s *rsp_fchs)
+				void *cbarg, bfa_status_t req_status,
+				u32 rsp_len, u32 resid_len,
+				struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)cbarg;
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *) cbarg;
 	struct bfa_fcs_port_s *port = ns->port;
 	/* struct fc_logi_s *plogi_resp; */
 	struct fc_els_cmd_s   *els_cmd;
@@ -740,7 +739,7 @@ bfa_fcs_port_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	int             len;
 	struct bfa_fcxp_s *fcxp;
 	u8         symbl[256];
-	u8        *psymbl = &symbl[0];
+	u8         *psymbl = &symbl[0];
 
 	bfa_os_memset(symbl, 0, sizeof(symbl));
 
@@ -750,7 +749,7 @@ bfa_fcs_port_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	if (!fcxp) {
 		port->stats.ns_rspnid_alloc_wait++;
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
-				    bfa_fcs_port_ns_send_rspn_id, ns);
+					bfa_fcs_port_ns_send_rspn_id, ns);
 		return;
 	}
 	ns->fcxp = fcxp;
@@ -764,24 +763,21 @@ bfa_fcs_port_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 		 */
 
 		strncpy((char *)psymbl,
-			(char *)
-			&(bfa_fcs_port_get_psym_name
-			  (bfa_fcs_get_base_port(port->fcs))),
-			strlen((char *)
-			       &bfa_fcs_port_get_psym_name(bfa_fcs_get_base_port
-							   (port->fcs))));
-
-		/*
-		 * Ensure we have a null terminating string.
-		 */
-		((char *)
-		 psymbl)[strlen((char *)
-				&bfa_fcs_port_get_psym_name
-				(bfa_fcs_get_base_port(port->fcs)))] = 0;
+			(char *) &
+			(bfa_fcs_port_get_psym_name
+			 (bfa_fcs_get_base_port(port->fcs))),
+			strlen((char *) &
+			       bfa_fcs_port_get_psym_name(bfa_fcs_get_base_port
+							  (port->fcs))));
+
+	/* Ensure we have a null terminating string. */
+	((char *)psymbl)[strlen((char *) &
+			bfa_fcs_port_get_psym_name(bfa_fcs_get_base_port
+							  (port->fcs)))] = 0;
 
 		strncat((char *)psymbl,
-			(char *)&(bfa_fcs_port_get_psym_name(port)),
-			strlen((char *)&bfa_fcs_port_get_psym_name(port)));
+			(char *) &(bfa_fcs_port_get_psym_name(port)),
+			strlen((char *) &bfa_fcs_port_get_psym_name(port)));
 	} else {
 		psymbl = (u8 *) &(bfa_fcs_port_get_psym_name(port));
 	}
@@ -790,8 +786,9 @@ bfa_fcs_port_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 			      bfa_fcs_port_get_fcid(port), 0, psymbl);
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_rspn_id_response,
-		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, len, &fchs,
+			  bfa_fcs_port_ns_rspn_id_response, (void *)ns,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
 
 	port->stats.ns_rspnid_sent++;
 
@@ -804,7 +801,7 @@ bfa_fcs_port_ns_rspn_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 				 u32 rsp_len, u32 resid_len,
 				 struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)cbarg;
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *) cbarg;
 	struct bfa_fcs_port_s *port = ns->port;
 	struct ct_hdr_s       *cthdr = NULL;
 
@@ -854,18 +851,19 @@ bfa_fcs_port_ns_send_rft_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	if (!fcxp) {
 		port->stats.ns_rftid_alloc_wait++;
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
-				    bfa_fcs_port_ns_send_rft_id, ns);
+					bfa_fcs_port_ns_send_rft_id, ns);
 		return;
 	}
 	ns->fcxp = fcxp;
 
 	len = fc_rftid_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-			     bfa_fcs_port_get_fcid(port), 0,
-			     port->port_cfg.roles);
+				bfa_fcs_port_get_fcid(port), 0,
+				port->port_cfg.roles);
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_rft_id_response,
-		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, len, &fchs,
+			  bfa_fcs_port_ns_rft_id_response, (void *)ns,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
 
 	port->stats.ns_rftid_sent++;
 	bfa_sm_send_event(ns, NSSM_EVENT_RFTID_SENT);
@@ -877,7 +875,7 @@ bfa_fcs_port_ns_rft_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 				u32 rsp_len, u32 resid_len,
 				struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)cbarg;
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *) cbarg;
 	struct bfa_fcs_port_s *port = ns->port;
 	struct ct_hdr_s       *cthdr = NULL;
 
@@ -909,7 +907,7 @@ bfa_fcs_port_ns_rft_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 }
 
 /**
-* Register FC4-Features : Should be done after RFT_ID
+ * Register FC4-Features : Should be done after RFT_ID
  */
 static void
 bfa_fcs_port_ns_send_rff_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
@@ -919,7 +917,7 @@ bfa_fcs_port_ns_send_rff_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	struct fchs_s          fchs;
 	int             len;
 	struct bfa_fcxp_s *fcxp;
-	u8         fc4_ftrs = 0;
+	u8			fc4_ftrs = 0;
 
 	bfa_trc(port->fcs, port->port_cfg.pwwn);
 
@@ -927,7 +925,7 @@ bfa_fcs_port_ns_send_rff_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	if (!fcxp) {
 		port->stats.ns_rffid_alloc_wait++;
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
-				    bfa_fcs_port_ns_send_rff_id, ns);
+					bfa_fcs_port_ns_send_rff_id, ns);
 		return;
 	}
 	ns->fcxp = fcxp;
@@ -938,12 +936,13 @@ bfa_fcs_port_ns_send_rff_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 		fc4_ftrs = FC_GS_FCP_FC4_FEATURE_TARGET;
 
 	len = fc_rffid_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-			     bfa_fcs_port_get_fcid(port), 0, FC_TYPE_FCP,
-			     fc4_ftrs);
+			     bfa_fcs_port_get_fcid(port), 0,
+				 FC_TYPE_FCP, fc4_ftrs);
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_rff_id_response,
-		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, len, &fchs,
+			  bfa_fcs_port_ns_rff_id_response, (void *)ns,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
 
 	port->stats.ns_rffid_sent++;
 	bfa_sm_send_event(ns, NSSM_EVENT_RFFID_SENT);
@@ -955,7 +954,7 @@ bfa_fcs_port_ns_rff_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 				u32 rsp_len, u32 resid_len,
 				struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)cbarg;
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *) cbarg;
 	struct bfa_fcs_port_s *port = ns->port;
 	struct ct_hdr_s       *cthdr = NULL;
 
@@ -985,19 +984,16 @@ bfa_fcs_port_ns_rff_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	bfa_trc(port->fcs, cthdr->exp_code);
 
 	if (cthdr->reason_code == CT_RSN_NOT_SUPP) {
-		/*
-		 * if this command is not supported, we don't retry
-		 */
+		/* if this command is not supported, we don't retry */
 		bfa_sm_send_event(ns, NSSM_EVENT_RSP_OK);
 	} else {
 		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
 	}
 }
-
 /**
  * Query Fabric for FC4-Types Devices.
  *
-*  TBD : Need to use a local (FCS private) response buffer, since the response
+* TBD : Need to use a local (FCS private) response buffer, since the response
  * can be larger than 2K.
  */
 static void
@@ -1015,7 +1011,7 @@ bfa_fcs_port_ns_send_gid_ft(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	if (!fcxp) {
 		port->stats.ns_gidft_alloc_wait++;
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
-				    bfa_fcs_port_ns_send_gid_ft, ns);
+					bfa_fcs_port_ns_send_gid_ft, ns);
 		return;
 	}
 	ns->fcxp = fcxp;
@@ -1023,13 +1019,13 @@ bfa_fcs_port_ns_send_gid_ft(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	/*
 	 * This query is only initiated for FCP initiator mode.
 	 */
-	len = fc_gid_ft_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), ns->port->pid,
-			      FC_TYPE_FCP);
+	len = fc_gid_ft_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			      ns->port->pid, FC_TYPE_FCP);
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_gid_ft_response,
-		      (void *)ns, bfa_fcxp_get_maxrsp(port->fcs->bfa),
-		      FC_RA_TOV);
+			  FC_CLASS_3, len, &fchs,
+			  bfa_fcs_port_ns_gid_ft_response, (void *)ns,
+			  bfa_fcxp_get_maxrsp(port->fcs->bfa), FC_RA_TOV);
 
 	port->stats.ns_gidft_sent++;
 
@@ -1042,7 +1038,7 @@ bfa_fcs_port_ns_gid_ft_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 				u32 rsp_len, u32 resid_len,
 				struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)cbarg;
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *) cbarg;
 	struct bfa_fcs_port_s *port = ns->port;
 	struct ct_hdr_s       *cthdr = NULL;
 	u32        n_pids;
@@ -1117,19 +1113,19 @@ bfa_fcs_port_ns_gid_ft_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 /**
  *     This routine will be called by bfa_timer on timer timeouts.
  *
- * 	param[in] 	port 	- pointer to bfa_fcs_port_t.
+ * 	param[in] 	port 	- pointer to struct bfa_fcs_port_s.
  *
  * 	return
  * 		void
  *
-* 	Special Considerations:
+ * 	Special Considerations:
  *
  * 	note
  */
 static void
 bfa_fcs_port_ns_timeout(void *arg)
 {
-	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)arg;
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *) arg;
 
 	ns->port->stats.ns_timeouts++;
 	bfa_sm_send_event(ns, NSSM_EVENT_TIMEOUT);
@@ -1139,8 +1135,8 @@ bfa_fcs_port_ns_timeout(void *arg)
  * Process the PID list in GID_FT response
  */
 static void
-bfa_fcs_port_ns_process_gidft_pids(struct bfa_fcs_port_s *port,
-				   u32 *pid_buf, u32 n_pids)
+bfa_fcs_port_ns_process_gidft_pids(struct bfa_fcs_port_s *port, u32 *pid_buf,
+				   u32 n_pids)
 {
 	struct fcgs_gidft_resp_s *gidft_entry;
 	struct bfa_fcs_rport_s *rport;
@@ -1227,13 +1223,13 @@ bfa_fcs_port_ns_boot_target_disc(struct bfa_fcs_port_s *port)
 {
 
 	struct bfa_fcs_rport_s *rport;
-	u8         nwwns;
-	wwn_t          *wwns;
-	int             ii;
+	u8 nwwns;
+	wwn_t  *wwns;
+	int ii;
 
 	bfa_iocfc_get_bootwwns(port->fcs->bfa, &nwwns, &wwns);
 
-	for (ii = 0; ii < nwwns; ++ii) {
+	for (ii = 0 ; ii < nwwns; ++ii) {
 		rport = bfa_fcs_rport_create_by_wwn(port, wwns[ii]);
 		bfa_assert(rport);
 	}
diff --git a/drivers/scsi/bfa/rport.c b/drivers/scsi/bfa/rport.c
index 9cf58bb..3269b14 100644
--- a/drivers/scsi/bfa/rport.c
+++ b/drivers/scsi/bfa/rport.c
@@ -37,131 +37,130 @@ BFA_TRC_FILE(FCS, RPORT);
 
 #define BFA_FCS_RPORT_MAX_RETRIES		(5)
 
-/* In millisecs */
-static u32 bfa_fcs_rport_del_timeout =
-			BFA_FCS_RPORT_DEF_DEL_TIMEOUT * 1000;
-
+static u32
+bfa_fcs_rport_del_timeout =
+		BFA_FCS_RPORT_DEF_DEL_TIMEOUT * 1000; /* In millisecs */
 /*
  * forward declarations
  */
-static struct bfa_fcs_rport_s *bfa_fcs_rport_alloc(struct bfa_fcs_port_s *port,
-						   wwn_t pwwn, u32 rpid);
-static void     bfa_fcs_rport_free(struct bfa_fcs_rport_s *rport);
-static void     bfa_fcs_rport_hal_online(struct bfa_fcs_rport_s *rport);
-static void     bfa_fcs_rport_online_action(struct bfa_fcs_rport_s *rport);
-static void     bfa_fcs_rport_offline_action(struct bfa_fcs_rport_s *rport);
-static void     bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport,
+static struct bfa_fcs_rport_s*
+bfa_fcs_rport_alloc(struct bfa_fcs_port_s *port, wwn_t pwwn,
+			   u32 rpid);
+static void	bfa_fcs_rport_free(struct bfa_fcs_rport_s *rport);
+static void	bfa_fcs_rport_hal_online(struct bfa_fcs_rport_s *rport);
+static void	bfa_fcs_rport_online_action(struct bfa_fcs_rport_s *rport);
+static void	bfa_fcs_rport_offline_action(struct bfa_fcs_rport_s *rport);
+static void	bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport,
 				     struct fc_logi_s *plogi);
-static void     bfa_fcs_rport_fc4_pause(struct bfa_fcs_rport_s *rport);
-static void     bfa_fcs_rport_fc4_resume(struct bfa_fcs_rport_s *rport);
-static void     bfa_fcs_rport_timeout(void *arg);
-static void     bfa_fcs_rport_send_plogi(void *rport_cbarg,
+static void	bfa_fcs_rport_fc4_pause(struct bfa_fcs_rport_s *rport);
+static void	bfa_fcs_rport_fc4_resume(struct bfa_fcs_rport_s *rport);
+static void	bfa_fcs_rport_timeout(void *arg);
+static void	bfa_fcs_rport_send_plogi(void *rport_cbarg,
 					 struct bfa_fcxp_s *fcxp_alloced);
-static void     bfa_fcs_rport_send_plogiacc(void *rport_cbarg,
+static void	bfa_fcs_rport_send_plogiacc(void *rport_cbarg,
 					    struct bfa_fcxp_s *fcxp_alloced);
-static void     bfa_fcs_rport_plogi_response(void *fcsarg,
-					     struct bfa_fcxp_s *fcxp,
-					     void *cbarg,
-					     bfa_status_t req_status,
-					     u32 rsp_len,
-					     u32 resid_len,
-					     struct fchs_s *rsp_fchs);
-static void     bfa_fcs_rport_send_adisc(void *rport_cbarg,
+static void	bfa_fcs_rport_plogi_response(void *fcsarg,
+					struct bfa_fcxp_s *fcxp, void *cbarg,
+					bfa_status_t req_status,
+					u32 rsp_len,
+					u32 resid_len,
+					struct fchs_s *rsp_fchs);
+static void	bfa_fcs_rport_send_adisc(void *rport_cbarg,
 					 struct bfa_fcxp_s *fcxp_alloced);
-static void     bfa_fcs_rport_adisc_response(void *fcsarg,
-					     struct bfa_fcxp_s *fcxp,
-					     void *cbarg,
-					     bfa_status_t req_status,
-					     u32 rsp_len,
-					     u32 resid_len,
-					     struct fchs_s *rsp_fchs);
-static void     bfa_fcs_rport_send_gidpn(void *rport_cbarg,
+static void	bfa_fcs_rport_adisc_response(void *fcsarg,
+					struct bfa_fcxp_s *fcxp,
+					void *cbarg,
+					bfa_status_t req_status,
+					u32 rsp_len,
+					u32 resid_len,
+					struct fchs_s *rsp_fchs);
+static void	bfa_fcs_rport_send_gidpn(void *rport_cbarg,
 					 struct bfa_fcxp_s *fcxp_alloced);
-static void     bfa_fcs_rport_gidpn_response(void *fcsarg,
-					     struct bfa_fcxp_s *fcxp,
-					     void *cbarg,
-					     bfa_status_t req_status,
-					     u32 rsp_len,
-					     u32 resid_len,
-					     struct fchs_s *rsp_fchs);
-static void     bfa_fcs_rport_send_logo(void *rport_cbarg,
+static void	bfa_fcs_rport_gidpn_response(void *fcsarg,
+					struct bfa_fcxp_s *fcxp,
+					void *cbarg,
+					bfa_status_t req_status,
+					u32 rsp_len,
+					u32 resid_len,
+					struct fchs_s *rsp_fchs);
+static void	bfa_fcs_rport_send_logo(void *rport_cbarg,
 					struct bfa_fcxp_s *fcxp_alloced);
-static void     bfa_fcs_rport_send_logo_acc(void *rport_cbarg);
-static void     bfa_fcs_rport_process_prli(struct bfa_fcs_rport_s *rport,
-			struct fchs_s *rx_fchs, u16 len);
-static void     bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport,
-			struct fchs_s *rx_fchs, u8 reason_code,
-			u8 reason_code_expl);
-static void     bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
-			struct fchs_s *rx_fchs, u16 len);
+static void	bfa_fcs_rport_send_logo_acc(void *rport_cbarg);
+static void	bfa_fcs_rport_process_prli(struct bfa_fcs_rport_s *rport,
+					   struct fchs_s *rx_fchs, u16 len);
+static void	bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport,
+				struct fchs_s *rx_fchs, u8 reason_code,
+					  u8 reason_code_expl);
+static void	bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
+					  struct fchs_s *rx_fchs, u16 len);
 /**
  *  fcs_rport_sm FCS rport state machine events
  */
 
 enum rport_event {
-	RPSM_EVENT_PLOGI_SEND = 1,	/*  new rport; start with PLOGI */
-	RPSM_EVENT_PLOGI_RCVD = 2,	/*  Inbound PLOGI from remote port */
-	RPSM_EVENT_PLOGI_COMP = 3,	/*  PLOGI completed to rport */
-	RPSM_EVENT_LOGO_RCVD = 4,	/*  LOGO from remote device */
-	RPSM_EVENT_LOGO_IMP = 5,	/*  implicit logo for SLER */
-	RPSM_EVENT_FCXP_SENT = 6,	/*  Frame from has been sent */
-	RPSM_EVENT_DELETE = 7,	/*  RPORT delete request */
-	RPSM_EVENT_SCN = 8,	/*  state change notification */
-	RPSM_EVENT_ACCEPTED = 9,/*  Good response from remote device */
-	RPSM_EVENT_FAILED = 10,	/*  Request to rport failed.  */
-	RPSM_EVENT_TIMEOUT = 11,	/*  Rport SM timeout event */
-	RPSM_EVENT_HCB_ONLINE = 12,	/*  BFA rport online callback */
-	RPSM_EVENT_HCB_OFFLINE = 13,	/*  BFA rport offline callback */
-	RPSM_EVENT_FC4_OFFLINE = 14,	/*  FC-4 offline complete */
-	RPSM_EVENT_ADDRESS_CHANGE = 15,	/*  Rport's PID has changed */
-	RPSM_EVENT_ADDRESS_DISC = 16	/*  Need to Discover rport's PID */
+	RPSM_EVENT_PLOGI_SEND  = 1,	 /*  new rport; start with PLOGI     */
+	RPSM_EVENT_PLOGI_RCVD  = 2,	 /*  Inbound PLOGI from remote port  */
+	RPSM_EVENT_PLOGI_COMP  = 3,	 /*  PLOGI completed to rport	      */
+	RPSM_EVENT_LOGO_RCVD   = 4,	 /*  LOGO from remote device	      */
+	RPSM_EVENT_LOGO_IMP    = 5,	 /*  implicit logo for SLER	      */
+	RPSM_EVENT_FCXP_SENT   = 6,	 /*  Frame from has been sent	      */
+	RPSM_EVENT_DELETE      = 7,	/*  RPORT delete request	      */
+	RPSM_EVENT_SCN	       = 8,	 /*  state change notification	      */
+	RPSM_EVENT_ACCEPTED    = 9,	 /*  Good response from remote device*/
+	RPSM_EVENT_FAILED      = 10,	 /*  Request to rport failed.	      */
+	RPSM_EVENT_TIMEOUT     = 11,	 /*  Rport SM timeout event	      */
+	RPSM_EVENT_HCB_ONLINE  = 12,	 /*  BFA rport online callback	      */
+	RPSM_EVENT_HCB_OFFLINE = 13,	 /*  BFA rport offline callback      */
+	RPSM_EVENT_FC4_OFFLINE = 14,	 /*  FC-4 offline complete	      */
+	RPSM_EVENT_ADDRESS_CHANGE = 15,	 /*  Rport's PID has changed	      */
+	RPSM_EVENT_ADDRESS_DISC = 16	/*  Need to Discover rport's PID     */
 };
 
-static void     bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport,
 					enum rport_event event);
-static void     bfa_fcs_rport_sm_plogi_sending(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_plogi_sending(struct bfa_fcs_rport_s *rport,
 					       enum rport_event event);
-static void     bfa_fcs_rport_sm_plogiacc_sending(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_plogiacc_sending(struct bfa_fcs_rport_s *rport,
 						  enum rport_event event);
-static void     bfa_fcs_rport_sm_plogi_retry(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_plogi_retry(struct bfa_fcs_rport_s *rport,
 					     enum rport_event event);
-static void     bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport,
 				       enum rport_event event);
-static void     bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
 					    enum rport_event event);
-static void     bfa_fcs_rport_sm_online(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_online(struct bfa_fcs_rport_s *rport,
 					enum rport_event event);
-static void     bfa_fcs_rport_sm_nsquery_sending(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_nsquery_sending(struct bfa_fcs_rport_s *rport,
 						 enum rport_event event);
-static void     bfa_fcs_rport_sm_nsquery(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_nsquery(struct bfa_fcs_rport_s *rport,
 					 enum rport_event event);
-static void     bfa_fcs_rport_sm_adisc_sending(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_adisc_sending(struct bfa_fcs_rport_s *rport,
 					       enum rport_event event);
-static void     bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport,
 				       enum rport_event event);
-static void     bfa_fcs_rport_sm_fc4_logorcv(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_fc4_logorcv(struct bfa_fcs_rport_s *rport,
 					     enum rport_event event);
-static void     bfa_fcs_rport_sm_fc4_logosend(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_fc4_logosend(struct bfa_fcs_rport_s *rport,
 					      enum rport_event event);
-static void     bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
 					     enum rport_event event);
-static void     bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
 					     enum rport_event event);
-static void     bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
 					     enum rport_event event);
-static void     bfa_fcs_rport_sm_hcb_logosend(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_hcb_logosend(struct bfa_fcs_rport_s *rport,
 					      enum rport_event event);
-static void     bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
 					      enum rport_event event);
-static void     bfa_fcs_rport_sm_offline(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_offline(struct bfa_fcs_rport_s *rport,
 					 enum rport_event event);
-static void     bfa_fcs_rport_sm_nsdisc_sending(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_nsdisc_sending(struct bfa_fcs_rport_s *rport,
 						enum rport_event event);
-static void     bfa_fcs_rport_sm_nsdisc_retry(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_nsdisc_retry(struct bfa_fcs_rport_s *rport,
 					      enum rport_event event);
-static void     bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 					     enum rport_event event);
-static void     bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
+static void	bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 					     enum rport_event event);
 
 static struct bfa_sm_table_s rport_sm_table[] = {
@@ -190,7 +189,7 @@ static struct bfa_sm_table_s rport_sm_table[] = {
 };
 
 /**
- * 		Beginning state.
+ *		Beginning state.
  */
 static void
 bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport, enum rport_event event)
@@ -224,16 +223,16 @@ bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		PLOGI is being sent.
+ *		PLOGI is being sent.
  */
 static void
 bfa_fcs_rport_sm_plogi_sending(struct bfa_fcs_rport_s *rport,
-			       enum rport_event event)
+					enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -276,16 +275,16 @@ bfa_fcs_rport_sm_plogi_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		PLOGI is being sent.
+ *		PLOGI is being sent.
  */
 static void
 bfa_fcs_rport_sm_plogiacc_sending(struct bfa_fcs_rport_s *rport,
-				  enum rport_event event)
+					enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -332,16 +331,16 @@ bfa_fcs_rport_sm_plogiacc_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		PLOGI is sent.
+ *		PLOGI is sent.
  */
 static void
 bfa_fcs_rport_sm_plogi_retry(struct bfa_fcs_rport_s *rport,
-			enum rport_event event)
+				enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -406,15 +405,16 @@ bfa_fcs_rport_sm_plogi_retry(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		PLOGI is sent.
+ *		PLOGI is sent.
  */
 static void
-bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport, enum rport_event event)
+bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport,
+				enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -440,6 +440,7 @@ bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport, enum rport_event event)
 				BFA_FCS_RETRY_TIMEOUT);
 		break;
 
+
 	case RPSM_EVENT_LOGO_IMP:
 		rport->pid = 0;
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
@@ -481,17 +482,17 @@ bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		PLOGI is complete. Awaiting BFA rport online callback. FC-4s
- * 		are offline.
+ *		PLOGI is complete. Awaiting BFA rport online callback. FC-4s
+ *		are offline.
  */
 static void
 bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
-			enum rport_event event)
+					enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -534,15 +535,16 @@ bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		Rport is ONLINE. FC-4s active.
+ *		Rport is ONLINE. FC-4s active.
  */
 static void
-bfa_fcs_rport_sm_online(struct bfa_fcs_rport_s *rport, enum rport_event event)
+bfa_fcs_rport_sm_online(struct bfa_fcs_rport_s *rport,
+				enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -589,17 +591,17 @@ bfa_fcs_rport_sm_online(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		An SCN event is received in ONLINE state. NS query is being sent
- * 		prior to ADISC authentication with rport. FC-4s are paused.
+ *		An SCN event is received in ONLINE state. NS query is being sent
+ *		prior to ADISC authentication with rport. FC-4s are paused.
  */
 static void
 bfa_fcs_rport_sm_nsquery_sending(struct bfa_fcs_rport_s *rport,
-				 enum rport_event event)
+					enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -646,13 +648,13 @@ bfa_fcs_rport_sm_nsquery_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 	An SCN event is received in ONLINE state. NS query is sent to rport.
- * 	FC-4s are paused.
+ *	An SCN event is received in ONLINE state. NS query is sent to rport.
+ *	FC-4s are paused.
  */
 static void
 bfa_fcs_rport_sm_nsquery(struct bfa_fcs_rport_s *rport, enum rport_event event)
@@ -704,17 +706,17 @@ bfa_fcs_rport_sm_nsquery(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 	An SCN event is received in ONLINE state. ADISC is being sent for
- * 	authenticating with rport. FC-4s are paused.
+ *	An SCN event is received in ONLINE state. ADISC is being sent for
+ *	authenticating with rport. FC-4s are paused.
  */
 static void
 bfa_fcs_rport_sm_adisc_sending(struct bfa_fcs_rport_s *rport,
-			       enum rport_event event)
+					enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -754,13 +756,13 @@ bfa_fcs_rport_sm_adisc_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		An SCN event is received in ONLINE state. ADISC is to rport.
- * 		FC-4s are paused.
+ *		An SCN event is received in ONLINE state. ADISC is to rport.
+ *		FC-4s are paused.
  */
 static void
 bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport, enum rport_event event)
@@ -816,16 +818,16 @@ bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		Rport has sent LOGO. Awaiting FC-4 offline completion callback.
+ *		Rport has sent LOGO. Awaiting FC-4 offline completion callback.
  */
 static void
 bfa_fcs_rport_sm_fc4_logorcv(struct bfa_fcs_rport_s *rport,
-			enum rport_event event)
+				enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -846,17 +848,17 @@ bfa_fcs_rport_sm_fc4_logorcv(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		LOGO needs to be sent to rport. Awaiting FC-4 offline completion
- * 		callback.
+ *		LOGO needs to be sent to rport. Awaiting FC-4 offline completion
+ *		callback.
  */
 static void
 bfa_fcs_rport_sm_fc4_logosend(struct bfa_fcs_rport_s *rport,
-			      enum rport_event event)
+					enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -869,16 +871,16 @@ bfa_fcs_rport_sm_fc4_logosend(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 	Rport is going offline. Awaiting FC-4 offline completion callback.
+ *	Rport is going offline. Awaiting FC-4 offline completion callback.
  */
 static void
 bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
-			enum rport_event event)
+					enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -905,17 +907,17 @@ bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		Rport is offline. FC-4s are offline. Awaiting BFA rport offline
- * 		callback.
+ *		Rport is offline. FC-4s are offline. Awaiting BFA rport offline
+ *		callback.
  */
 static void
 bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
-			enum rport_event event)
+				enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -925,10 +927,17 @@ bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
 	case RPSM_EVENT_HCB_OFFLINE:
 	case RPSM_EVENT_ADDRESS_CHANGE:
 		if (bfa_fcs_port_is_online(rport->port)) {
-			bfa_sm_set_state(rport,
-					 bfa_fcs_rport_sm_nsdisc_sending);
-			rport->ns_retries = 0;
-			bfa_fcs_rport_send_gidpn(rport, NULL);
+			if (bfa_fcs_fabric_is_switched(rport->port->fabric)) {
+				bfa_sm_set_state(rport,
+					bfa_fcs_rport_sm_nsdisc_sending);
+				rport->ns_retries = 0;
+				bfa_fcs_rport_send_gidpn(rport, NULL);
+			} else {
+			    bfa_sm_set_state(rport,
+					bfa_fcs_rport_sm_plogi_sending);
+			    rport->plogi_retries = 0;
+			    bfa_fcs_rport_send_plogi(rport, NULL);
+			}
 		} else {
 			rport->pid = 0;
 			bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
@@ -951,17 +960,17 @@ bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		Rport is offline. FC-4s are offline. Awaiting BFA rport offline
- * 		callback to send LOGO accept.
+ *		Rport is offline. FC-4s are offline. Awaiting BFA rport offline
+ *		callback to send LOGO accept.
  */
 static void
 bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
-			enum rport_event event)
+					enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -973,19 +982,20 @@ bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
 		if (rport->pid)
 			bfa_fcs_rport_send_logo_acc(rport);
 		/*
-		 * If the lport is online and if the rport is not a well known
-		 * address port, we try to re-discover the r-port.
+		 * If the lport is online and if the rport is not
+		 * a well known address port, we try to re-discover
+		 * the r-port.
 		 */
-		if (bfa_fcs_port_is_online(rport->port)
-		    && (!BFA_FCS_PID_IS_WKA(rport->pid))) {
+		if (bfa_fcs_port_is_online(rport->port) &&
+		    (!BFA_FCS_PID_IS_WKA(rport->pid))) {
 			bfa_sm_set_state(rport,
-					 bfa_fcs_rport_sm_nsdisc_sending);
+					bfa_fcs_rport_sm_nsdisc_sending);
 			rport->ns_retries = 0;
 			bfa_fcs_rport_send_gidpn(rport, NULL);
 		} else {
 			/*
-			 * if it is not a well known address, reset the pid to
-			 *
+			 * if it is not a well known address,
+			 * reset the pid to 0
 			 */
 			if (!BFA_FCS_PID_IS_WKA(rport->pid))
 				rport->pid = 0;
@@ -1011,17 +1021,17 @@ bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * Rport is being deleted. FC-4s are offline. Awaiting BFA rport offline
- * callback to send LOGO.
+ *	Rport is being deleted. FC-4s are offline. Awaiting BFA rport offline
+ *	callback to send LOGO.
  */
 static void
 bfa_fcs_rport_sm_hcb_logosend(struct bfa_fcs_rport_s *rport,
-			      enum rport_event event)
+				enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -1038,16 +1048,16 @@ bfa_fcs_rport_sm_hcb_logosend(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		Rport is being deleted. FC-4s are offline. LOGO is being sent.
+ *	Rport is being deleted. FC-4s are offline. LOGO is being sent.
  */
 static void
 bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
-			      enum rport_event event)
+				enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -1055,9 +1065,7 @@ bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
 
 	switch (event) {
 	case RPSM_EVENT_FCXP_SENT:
-		/*
-		 * Once LOGO is sent, we donot wait for the response
-		 */
+		/* Once LOGO is sent, we donot wait for the response */
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
 		bfa_fcs_rport_free(rport);
 		break;
@@ -1073,16 +1081,17 @@ bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		Rport is offline. FC-4s are offline. BFA rport is offline.
- * 		Timer active to delete stale rport.
+ *	Rport is offline. FC-4s are offline. BFA rport is offline.
+ *	Timer active to delete stale rport.
  */
 static void
-bfa_fcs_rport_sm_offline(struct bfa_fcs_rport_s *rport, enum rport_event event)
+bfa_fcs_rport_sm_offline(struct bfa_fcs_rport_s *rport,
+				enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -1132,12 +1141,12 @@ bfa_fcs_rport_sm_offline(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 	Rport address has changed. Nameserver discovery request is being sent.
+ *	Rport address has changed. Nameserver discovery request is being sent.
  */
 static void
 bfa_fcs_rport_sm_nsdisc_sending(struct bfa_fcs_rport_s *rport,
@@ -1170,7 +1179,7 @@ bfa_fcs_rport_sm_nsdisc_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	case RPSM_EVENT_ADDRESS_CHANGE:
-		rport->ns_retries = 0;	/* reset the retry count */
+		rport->ns_retries = 0; /* reset the retry count */
 		break;
 
 	case RPSM_EVENT_LOGO_IMP:
@@ -1188,16 +1197,16 @@ bfa_fcs_rport_sm_nsdisc_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * 		Nameserver discovery failed. Waiting for timeout to retry.
+ *	Nameserver discovery failed. Waiting for timeout to retry.
  */
 static void
 bfa_fcs_rport_sm_nsdisc_retry(struct bfa_fcs_rport_s *rport,
-			      enum rport_event event)
+				enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -1249,16 +1258,16 @@ bfa_fcs_rport_sm_nsdisc_retry(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
 /**
- * Rport address has changed. Nameserver discovery request is sent.
+ *		Rport address has changed. Nameserver discovery request is sent.
  */
 static void
 bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
-			enum rport_event event)
+					enum rport_event event)
 {
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_trc(rport->fcs, rport->pid);
@@ -1272,7 +1281,7 @@ bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 			bfa_fcs_rport_send_plogi(rport, NULL);
 		} else {
 			bfa_sm_set_state(rport,
-					 bfa_fcs_rport_sm_nsdisc_sending);
+				bfa_fcs_rport_sm_nsdisc_sending);
 			rport->ns_retries = 0;
 			bfa_fcs_rport_send_gidpn(rport, NULL);
 		}
@@ -1282,7 +1291,7 @@ bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 		rport->ns_retries++;
 		if (rport->ns_retries < BFA_FCS_RPORT_MAX_RETRIES) {
 			bfa_sm_set_state(rport,
-					 bfa_fcs_rport_sm_nsdisc_sending);
+				bfa_fcs_rport_sm_nsdisc_sending);
 			bfa_fcs_rport_send_gidpn(rport, NULL);
 		} else {
 			rport->pid = 0;
@@ -1334,7 +1343,7 @@ bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -1349,8 +1358,8 @@ bfa_fcs_rport_send_plogi(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 {
 	struct bfa_fcs_rport_s *rport = rport_cbarg;
 	struct bfa_fcs_port_s *port = rport->port;
-	struct fchs_s          fchs;
-	int             len;
+	struct fchs_s		fchs;
+	int		len;
 	struct bfa_fcxp_s *fcxp;
 
 	bfa_trc(rport->fcs, rport->pwwn);
@@ -1366,7 +1375,7 @@ bfa_fcs_rport_send_plogi(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	len = fc_plogi_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
 			     bfa_fcs_port_get_fcid(port), 0,
 			     port->port_cfg.pwwn, port->port_cfg.nwwn,
-			     bfa_pport_get_maxfrsize(port->fcs->bfa));
+			     bfa_fcport_get_maxfrsize(port->fcs->bfa));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_rport_plogi_response,
@@ -1381,11 +1390,11 @@ bfa_fcs_rport_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			     bfa_status_t req_status, u32 rsp_len,
 			     u32 resid_len, struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *) cbarg;
 	struct fc_logi_s	*plogi_rsp;
 	struct fc_ls_rjt_s	*ls_rjt;
 	struct bfa_fcs_rport_s *twin;
-	struct list_head *qe;
+	struct list_head	*qe;
 
 	bfa_trc(rport->fcs, rport->pwwn);
 
@@ -1420,22 +1429,23 @@ bfa_fcs_rport_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 	 * device with a new FC port address.
 	 */
 	list_for_each(qe, &rport->port->rport_q) {
-		twin = (struct bfa_fcs_rport_s *)qe;
+		twin = (struct bfa_fcs_rport_s *) qe;
 		if (twin == rport)
 			continue;
 		if (!rport->pwwn && (plogi_rsp->port_name == twin->pwwn)) {
 			bfa_trc(rport->fcs, twin->pid);
 			bfa_trc(rport->fcs, rport->pid);
 
-			/*
-			 * Update plogi stats in twin
-			 */
-			twin->stats.plogis += rport->stats.plogis;
-			twin->stats.plogi_rejects += rport->stats.plogi_rejects;
+			/* Update plogi stats in twin */
+			twin->stats.plogis  += rport->stats.plogis;
+			twin->stats.plogi_rejects +=
+						rport->stats.plogi_rejects;
 			twin->stats.plogi_timeouts +=
-				rport->stats.plogi_timeouts;
-			twin->stats.plogi_failed += rport->stats.plogi_failed;
-			twin->stats.plogi_rcvd += rport->stats.plogi_rcvd;
+						rport->stats.plogi_timeouts;
+			twin->stats.plogi_failed +=
+						rport->stats.plogi_failed;
+			twin->stats.plogi_rcvd +=
+						rport->stats.plogi_rcvd;
 			twin->stats.plogi_accs++;
 
 			bfa_fcs_rport_delete(rport);
@@ -1460,8 +1470,8 @@ bfa_fcs_rport_send_plogiacc(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 {
 	struct bfa_fcs_rport_s *rport = rport_cbarg;
 	struct bfa_fcs_port_s *port = rport->port;
-	struct fchs_s          fchs;
-	int             len;
+	struct fchs_s		fchs;
+	int		len;
 	struct bfa_fcxp_s *fcxp;
 
 	bfa_trc(rport->fcs, rport->pwwn);
@@ -1475,10 +1485,11 @@ bfa_fcs_rport_send_plogiacc(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	}
 	rport->fcxp = fcxp;
 
-	len = fc_plogi_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
-				 bfa_fcs_port_get_fcid(port), rport->reply_oxid,
-				 port->port_cfg.pwwn, port->port_cfg.nwwn,
-				 bfa_pport_get_maxfrsize(port->fcs->bfa));
+	len = fc_plogi_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+				 rport->pid, bfa_fcs_port_get_fcid(port),
+				 rport->reply_oxid, port->port_cfg.pwwn,
+				 port->port_cfg.nwwn,
+				 bfa_fcport_get_maxfrsize(port->fcs->bfa));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
@@ -1491,8 +1502,8 @@ bfa_fcs_rport_send_adisc(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 {
 	struct bfa_fcs_rport_s *rport = rport_cbarg;
 	struct bfa_fcs_port_s *port = rport->port;
-	struct fchs_s          fchs;
-	int             len;
+	struct fchs_s		fchs;
+	int		len;
 	struct bfa_fcxp_s *fcxp;
 
 	bfa_trc(rport->fcs, rport->pwwn);
@@ -1522,8 +1533,8 @@ bfa_fcs_rport_adisc_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			     bfa_status_t req_status, u32 rsp_len,
 			     u32 resid_len, struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
-	void           *pld = bfa_fcxp_get_rspbuf(fcxp);
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *) cbarg;
+	void	       *pld = bfa_fcxp_get_rspbuf(fcxp);
 	struct fc_ls_rjt_s    *ls_rjt;
 
 	if (req_status != BFA_STATUS_OK) {
@@ -1534,7 +1545,7 @@ bfa_fcs_rport_adisc_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 	}
 
 	if (fc_adisc_rsp_parse((struct fc_adisc_s *)pld, rsp_len, rport->pwwn,
-		rport->nwwn)  == FC_PARSE_OK) {
+			       rport->nwwn)  == FC_PARSE_OK) {
 		rport->stats.adisc_accs++;
 		bfa_sm_send_event(rport, RPSM_EVENT_ACCEPTED);
 		return;
@@ -1553,9 +1564,9 @@ bfa_fcs_rport_send_gidpn(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 {
 	struct bfa_fcs_rport_s *rport = rport_cbarg;
 	struct bfa_fcs_port_s *port = rport->port;
-	struct fchs_s          fchs;
+	struct fchs_s		fchs;
 	struct bfa_fcxp_s *fcxp;
-	int             len;
+	int		len;
 
 	bfa_trc(rport->fcs, rport->pid);
 
@@ -1582,11 +1593,11 @@ bfa_fcs_rport_gidpn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			     bfa_status_t req_status, u32 rsp_len,
 			     u32 resid_len, struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
-	struct bfa_fcs_rport_s *twin;
-	struct list_head *qe;
-	struct ct_hdr_s       	*cthdr;
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *) cbarg;
+	struct ct_hdr_s	*cthdr;
 	struct fcgs_gidpn_resp_s	*gidpn_rsp;
+	struct bfa_fcs_rport_s	*twin;
+	struct list_head	*qe;
 
 	bfa_trc(rport->fcs, rport->pwwn);
 
@@ -1594,25 +1605,21 @@ bfa_fcs_rport_gidpn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
-		/*
-		 * Check if the pid is the same as before.
-		 */
+		/* Check if the pid is the same as before.*/
 		gidpn_rsp = (struct fcgs_gidpn_resp_s *) (cthdr + 1);
 
 		if (gidpn_rsp->dap == rport->pid) {
-			/*
-			 * Device is online
-			 */
+			/* Device is online  */
 			bfa_sm_send_event(rport, RPSM_EVENT_ACCEPTED);
 		} else {
 			/*
-			 * Device's PID has changed. We need to cleanup and
-			 * re-login. If there is another device with the the
-			 * newly discovered pid, send an scn notice so that its
-			 * new pid can be discovered.
+			 * Device's PID has changed. We need to cleanup
+			 * and re-login. If there is another device with
+			 * the the newly discovered pid, send an scn notice
+			 * so that its new pid can be discovered.
 			 */
 			list_for_each(qe, &rport->port->rport_q) {
-				twin = (struct bfa_fcs_rport_s *)qe;
+				twin = (struct bfa_fcs_rport_s *) qe;
 				if (twin == rport)
 					continue;
 				if (gidpn_rsp->dap == twin->pid) {
@@ -1662,9 +1669,9 @@ bfa_fcs_rport_send_logo(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 {
 	struct bfa_fcs_rport_s *rport = rport_cbarg;
 	struct bfa_fcs_port_s *port;
-	struct fchs_s          fchs;
+	struct fchs_s		fchs;
 	struct bfa_fcxp_s *fcxp;
-	u16        len;
+	u16	len;
 
 	bfa_trc(rport->fcs, rport->pid);
 
@@ -1683,8 +1690,8 @@ bfa_fcs_rport_send_logo(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 			    bfa_fcs_port_get_pwwn(port));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, NULL, rport, FC_MAX_PDUSZ,
-		      FC_ED_TOV);
+		      FC_CLASS_3, len, &fchs, NULL,
+		      rport, FC_MAX_PDUSZ, FC_ED_TOV);
 
 	rport->stats.logos++;
 	bfa_fcxp_discard(rport->fcxp);
@@ -1699,9 +1706,9 @@ bfa_fcs_rport_send_logo_acc(void *rport_cbarg)
 {
 	struct bfa_fcs_rport_s *rport = rport_cbarg;
 	struct bfa_fcs_port_s *port;
-	struct fchs_s          fchs;
+	struct fchs_s		fchs;
 	struct bfa_fcxp_s *fcxp;
-	u16        len;
+	u16	len;
 
 	bfa_trc(rport->fcs, rport->pid);
 
@@ -1712,30 +1719,32 @@ bfa_fcs_rport_send_logo_acc(void *rport_cbarg)
 		return;
 
 	rport->stats.logo_rcvd++;
-	len = fc_logo_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
-				bfa_fcs_port_get_fcid(port), rport->reply_oxid);
+	len = fc_logo_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+				rport->pid, bfa_fcs_port_get_fcid(port),
+				rport->reply_oxid);
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
 }
 
 /**
+ *	brief
  *     This routine will be called by bfa_timer on timer timeouts.
  *
- * 	param[in] 	rport 			- pointer to bfa_fcs_port_ns_t.
- * 	param[out]	rport_status 	- pointer to return vport status in
+ *	param[in]	rport			- pointer to bfa_fcs_port_ns_t.
+ *	param[out]	rport_status	- pointer to return vport status in
  *
- * 	return
- * 		void
+ *	return
+ *		void
  *
-*  	Special Considerations:
+ *	Special Considerations:
  *
- * 	note
+ *	note
  */
 static void
 bfa_fcs_rport_timeout(void *arg)
 {
-	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)arg;
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *) arg;
 
 	rport->stats.plogi_timeouts++;
 	bfa_sm_send_event(rport, RPSM_EVENT_TIMEOUT);
@@ -1746,7 +1755,7 @@ bfa_fcs_rport_process_prli(struct bfa_fcs_rport_s *rport,
 			struct fchs_s *rx_fchs, u16 len)
 {
 	struct bfa_fcxp_s *fcxp;
-	struct fchs_s          fchs;
+	struct fchs_s		fchs;
 	struct bfa_fcs_port_s *port = rport->port;
 	struct fc_prli_s      *prli;
 
@@ -1784,9 +1793,9 @@ bfa_fcs_rport_process_prli(struct bfa_fcs_rport_s *rport,
 	if (!fcxp)
 		return;
 
-	len = fc_prli_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
-				bfa_fcs_port_get_fcid(port), rx_fchs->ox_id,
-				port->port_cfg.roles);
+	len = fc_prli_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+				rx_fchs->s_id, bfa_fcs_port_get_fcid(port),
+				rx_fchs->ox_id, port->port_cfg.roles);
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
@@ -1797,7 +1806,7 @@ bfa_fcs_rport_process_rpsc(struct bfa_fcs_rport_s *rport,
 			struct fchs_s *rx_fchs, u16 len)
 {
 	struct bfa_fcxp_s *fcxp;
-	struct fchs_s          fchs;
+	struct fchs_s		fchs;
 	struct bfa_fcs_port_s *port = rport->port;
 	struct fc_rpsc_speed_info_s speeds;
 	struct bfa_pport_attr_s pport_attr;
@@ -1813,7 +1822,7 @@ bfa_fcs_rport_process_rpsc(struct bfa_fcs_rport_s *rport,
 	/*
 	 * get curent speed from pport attributes from BFA
 	 */
-	bfa_pport_get_attr(port->fcs->bfa, &pport_attr);
+	bfa_fcport_get_attr(port->fcs->bfa, &pport_attr);
 
 	speeds.port_op_speed = fc_bfa_speed_to_rpsc_operspeed(pport_attr.speed);
 
@@ -1821,9 +1830,9 @@ bfa_fcs_rport_process_rpsc(struct bfa_fcs_rport_s *rport,
 	if (!fcxp)
 		return;
 
-	len = fc_rpsc_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
-				bfa_fcs_port_get_fcid(port), rx_fchs->ox_id,
-				&speeds);
+	len = fc_rpsc_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+				rx_fchs->s_id, bfa_fcs_port_get_fcid(port),
+				rx_fchs->ox_id, &speeds);
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
@@ -1834,9 +1843,9 @@ bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
 			struct fchs_s *rx_fchs, u16 len)
 {
 	struct bfa_fcxp_s *fcxp;
-	struct fchs_s          fchs;
+	struct fchs_s		fchs;
 	struct bfa_fcs_port_s *port = rport->port;
-	struct fc_adisc_s      *adisc;
+	struct fc_adisc_s	*adisc;
 
 	bfa_trc(port->fcs, rx_fchs->s_id);
 	bfa_trc(port->fcs, rx_fchs->d_id);
@@ -1844,9 +1853,7 @@ bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
 	rport->stats.adisc_rcvd++;
 
 	if (BFA_FCS_VPORT_IS_TARGET_MODE(port)) {
-		/*
-		 * @todo : Target Mode handling
-		 */
+		/* @todo :  Target Mode	 handling */
 		bfa_trc(port->fcs, rx_fchs->d_id);
 		bfa_assert(0);
 		return;
@@ -1855,7 +1862,8 @@ bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
 	adisc = (struct fc_adisc_s *) (rx_fchs + 1);
 
 	/*
-	 * Accept if the itnim for this rport is online. Else reject the ADISC
+	 * Accept if the itnim for this rport is online.
+	 * Else reject the ADISC
 	 */
 	if (bfa_fcs_itnim_get_online_state(rport->itnim) == BFA_STATUS_OK) {
 
@@ -1921,9 +1929,9 @@ bfa_fcs_rport_fc4_resume(struct bfa_fcs_rport_s *rport)
 static struct bfa_fcs_rport_s *
 bfa_fcs_rport_alloc(struct bfa_fcs_port_s *port, wwn_t pwwn, u32 rpid)
 {
-	struct bfa_fcs_s *fcs = port->fcs;
+	struct bfa_fcs_s      *fcs = port->fcs;
 	struct bfa_fcs_rport_s *rport;
-	struct bfad_rport_s *rport_drv;
+	struct bfad_rport_s   *rport_drv;
 
 	/**
 	 * allocate rport
@@ -1983,9 +1991,7 @@ bfa_fcs_rport_alloc(struct bfa_fcs_port_s *port, wwn_t pwwn, u32 rpid)
 
 	bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
 
-	/*
-	 * Initialize the Rport Features(RPF) Sub Module
-	 */
+	/* Initialize the Rport Features(RPF) Sub Module  */
 	if (!BFA_FCS_PID_IS_WKA(rport->pid))
 		bfa_fcs_rpf_init(rport);
 
@@ -2016,29 +2022,26 @@ bfa_fcs_rport_free(struct bfa_fcs_rport_s *rport)
 
 static void
 bfa_fcs_rport_aen_post(struct bfa_fcs_rport_s *rport,
-		       enum bfa_rport_aen_event event,
-		       struct bfa_rport_aen_data_s *data)
+			enum bfa_rport_aen_event event,
+			struct bfa_rport_aen_data_s *data)
 {
-	union bfa_aen_data_u aen_data;
+	union bfa_aen_data_u  aen_data;
 	struct bfa_log_mod_s *logmod = rport->fcs->logm;
-	wwn_t           lpwwn = bfa_fcs_port_get_pwwn(rport->port);
-	wwn_t           rpwwn = rport->pwwn;
-	char            lpwwn_ptr[BFA_STRING_32];
-	char            rpwwn_ptr[BFA_STRING_32];
-	char           *prio_str[] = { "unknown", "high", "medium", "low" };
+	wwn_t		lpwwn = bfa_fcs_port_get_pwwn(rport->port);
+	wwn_t		rpwwn = rport->pwwn;
+	char		lpwwn_ptr[BFA_STRING_32];
+	char		rpwwn_ptr[BFA_STRING_32];
+	char		*prio_str[] = { "unknown", "high", "medium", "low" };
 
 	wwn2str(lpwwn_ptr, lpwwn);
 	wwn2str(rpwwn_ptr, rpwwn);
 
 	switch (event) {
 	case BFA_RPORT_AEN_ONLINE:
-		bfa_log(logmod, BFA_AEN_RPORT_ONLINE, rpwwn_ptr, lpwwn_ptr);
-		break;
 	case BFA_RPORT_AEN_OFFLINE:
-		bfa_log(logmod, BFA_AEN_RPORT_OFFLINE, rpwwn_ptr, lpwwn_ptr);
-		break;
 	case BFA_RPORT_AEN_DISCONNECT:
-		bfa_log(logmod, BFA_AEN_RPORT_DISCONNECT, rpwwn_ptr, lpwwn_ptr);
+		bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, event),
+					rpwwn_ptr, lpwwn_ptr);
 		break;
 	case BFA_RPORT_AEN_QOS_PRIO:
 		aen_data.rport.priv.qos = data->priv.qos;
@@ -2049,8 +2052,8 @@ bfa_fcs_rport_aen_post(struct bfa_fcs_rport_s *rport,
 	case BFA_RPORT_AEN_QOS_FLOWID:
 		aen_data.rport.priv.qos = data->priv.qos;
 		bfa_log(logmod, BFA_AEN_RPORT_QOS_FLOWID,
-			aen_data.rport.priv.qos.qos_flow_id, rpwwn_ptr,
-			lpwwn_ptr);
+			aen_data.rport.priv.qos.qos_flow_id,
+			rpwwn_ptr, lpwwn_ptr);
 		break;
 	default:
 		break;
@@ -2079,9 +2082,7 @@ bfa_fcs_rport_online_action(struct bfa_fcs_rport_s *rport)
 	if (bfa_fcs_port_is_target(port))
 		bfa_fcs_tin_rport_online(rport->tin);
 
-	/*
-	 * Don't post events for well known addresses
-	 */
+	/* Don't post events for well known addresses */
 	if (!BFA_FCS_PID_IS_WKA(rport->pid))
 		bfa_fcs_rport_aen_post(rport, BFA_RPORT_AEN_ONLINE, NULL);
 }
@@ -2093,17 +2094,14 @@ bfa_fcs_rport_offline_action(struct bfa_fcs_rport_s *rport)
 
 	rport->stats.offlines++;
 
-	/*
-	 * Don't post events for well known addresses
-	 */
+	/* Don't post events for well known addresses */
 	if (!BFA_FCS_PID_IS_WKA(rport->pid)) {
-		if (bfa_fcs_port_is_online(rport->port) == BFA_TRUE) {
-			bfa_fcs_rport_aen_post(rport, BFA_RPORT_AEN_DISCONNECT,
-					       NULL);
-		} else {
-			bfa_fcs_rport_aen_post(rport, BFA_RPORT_AEN_OFFLINE,
-					       NULL);
-		}
+		if (bfa_fcs_port_is_online(rport->port) == BFA_TRUE)
+			bfa_fcs_rport_aen_post(rport,
+					BFA_RPORT_AEN_DISCONNECT, NULL);
+		else
+			bfa_fcs_rport_aen_post(rport,
+					BFA_RPORT_AEN_OFFLINE, NULL);
 	}
 
 	if (bfa_fcs_port_is_initiator(port)) {
@@ -2152,19 +2150,20 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 	bfa_trc(port->fcs, port->fabric->bb_credit);
 	/**
 	 * Direct Attach P2P mode :
-	 * This is to handle a bug (233476) in IBM targets in Direct Attach
-	 * Mode. Basically, in FLOGI Accept the target would have erroneously
-	 * set the BB Credit to the value used in the FLOGI sent by the HBA.
+	 * This is to handle a bug (233476) in IBM targets in
+	 * Direct Attach Mode. Basically, in FLOGI Accept the target
+	 * would have erroneously set the BB Credit to the value used
+	 * in the FLOGI sent by the HBA.
 	 * It uses the correct value (its own BB credit) in PLOGI.
 	 */
-	if ((!bfa_fcs_fabric_is_switched(port->fabric))
-	    && (bfa_os_ntohs(plogi->csp.bbcred) < port->fabric->bb_credit)) {
+	if ((!bfa_fcs_fabric_is_switched(port->fabric))	&&
+	    (bfa_os_ntohs(plogi->csp.bbcred) < port->fabric->bb_credit)) {
 
 		bfa_trc(port->fcs, bfa_os_ntohs(plogi->csp.bbcred));
 		bfa_trc(port->fcs, port->fabric->bb_credit);
 
 		port->fabric->bb_credit = bfa_os_ntohs(plogi->csp.bbcred);
-		bfa_pport_set_tx_bbcredit(port->fcs->bfa,
+		bfa_fcport_set_tx_bbcredit(port->fcs->bfa,
 					  port->fabric->bb_credit);
 	}
 
@@ -2190,8 +2189,8 @@ bfa_fcs_rport_process_logo(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs)
  */
 
 /**
- * 	Called by bport/vport to create a remote port instance for a discovered
- * 	remote device.
+ *	Called by bport/vport to create a remote port instance for a discovered
+ *	remote device.
  *
  * @param[in] port	- base port or vport
  * @param[in] rpid	- remote port ID
@@ -2233,7 +2232,6 @@ bfa_fcs_rport_create_by_wwn(struct bfa_fcs_port_s *port, wwn_t rpwwn)
 	bfa_sm_send_event(rport, RPSM_EVENT_ADDRESS_DISC);
 	return rport;
 }
-
 /**
  * Called by bport in private loop topology to indicate that a
  * rport has been discovered and plogi has been completed.
@@ -2282,9 +2280,9 @@ bfa_fcs_rport_plogi_create(struct bfa_fcs_port_s *port, struct fchs_s *fchs,
 static int
 wwn_compare(wwn_t wwn1, wwn_t wwn2)
 {
-	u8        *b1 = (u8 *) &wwn1;
-	u8        *b2 = (u8 *) &wwn2;
-	int             i;
+	u8	       *b1 = (u8 *) &wwn1;
+	u8	       *b2 = (u8 *) &wwn2;
+	int		i;
 
 	for (i = 0; i < sizeof(wwn_t); i++) {
 		if (b1[i] < b2[i])
@@ -2297,7 +2295,7 @@ wwn_compare(wwn_t wwn1, wwn_t wwn2)
 
 /**
  *   Called by bport/vport to handle PLOGI received from an existing
- * 	 remote port.
+ *	 remote port.
  */
 void
 bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
@@ -2320,8 +2318,8 @@ bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
 	 * this Plogi should be accepted.
 	 */
 	if ((wwn_compare(rport->port->port_cfg.pwwn, rport->pwwn) == -1)
-	    && (bfa_fcs_fabric_is_switched(rport->port->fabric))
-	    && (!BFA_FCS_PID_IS_WKA(rport->pid))) {
+	    && (bfa_fcs_fabric_is_switched(rport->port->fabric)) &&
+	    (!BFA_FCS_PID_IS_WKA(rport->pid))) {
 		bfa_trc(rport->fcs, rport->pid);
 		return;
 	}
@@ -2333,10 +2331,10 @@ bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
 /**
  * Called by bport/vport to delete a remote port instance.
  *
-* Rport delete is called under the following conditions:
- * 		- vport is deleted
- * 		- vf is deleted
- * 		- explicit request from OS to delete rport (vmware)
+ * Rport delete is called under the following conditions:
+ *		- vport is deleted
+ *		- vf is deleted
+ *		- explicit request from OS to delete rport (vmware)
  */
 void
 bfa_fcs_rport_delete(struct bfa_fcs_rport_s *rport)
@@ -2363,20 +2361,18 @@ bfa_fcs_rport_online(struct bfa_fcs_rport_s *rport)
 {
 	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_SEND);
 }
-
 /**
  *   Called by bport/vport to notify SCN for the remote port
  */
 void
 bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport)
 {
-
 	rport->stats.rscns++;
 	bfa_sm_send_event(rport, RPSM_EVENT_SCN);
 }
 
 /**
- *   Called by  fcpim to notify that the ITN cleanup is done.
+ *   Called by	fcpim to notify that the ITN cleanup is done.
  */
 void
 bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport)
@@ -2385,75 +2381,70 @@ bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport)
 }
 
 /**
- *   Called by fcptm to notify that the ITN cleanup is done.
- */
-void
-bfa_fcs_rport_tin_ack(struct bfa_fcs_rport_s *rport)
-{
-	bfa_sm_send_event(rport, RPSM_EVENT_FC4_OFFLINE);
-}
-
-/**
+ *	brief
  *     This routine BFA callback for bfa_rport_online() call.
  *
- * 	param[in] 	cb_arg	-  rport struct.
+ *	param[in]	cb_arg	-  rport struct.
  *
- * 	return
- * 		void
+ *	return
+ *		void
  *
-* 	Special Considerations:
+ *	Special Considerations:
  *
- * 	note
+ *	note
  */
 void
 bfa_cb_rport_online(void *cbarg)
 {
 
-	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *) cbarg;
 
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_sm_send_event(rport, RPSM_EVENT_HCB_ONLINE);
 }
 
 /**
+ *	brief
  *     This routine BFA callback for bfa_rport_offline() call.
  *
- * 	param[in] 	rport 	-
+ *	param[in]	rport	-
  *
- * 	return
- * 		void
+ *	return
+ *		void
  *
- * 	Special Considerations:
+ *	Special Considerations:
  *
- * 	note
+ *	note
  */
 void
 bfa_cb_rport_offline(void *cbarg)
 {
-	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *) cbarg;
 
 	bfa_trc(rport->fcs, rport->pwwn);
 	bfa_sm_send_event(rport, RPSM_EVENT_HCB_OFFLINE);
 }
 
 /**
- * This routine is a static BFA callback when there is a QoS flow_id
- * change notification
+ *	brief
+ *	This routine is a static BFA callback when there is a QoS flow_id
+ *	change notification
  *
- * @param[in] 	rport 	-
+ *	param[in]	rport	-
  *
- * @return  	void
+ *	return
+ *		void
  *
- * Special Considerations:
+ *	Special Considerations:
  *
- * @note
+ *	note
  */
 void
 bfa_cb_rport_qos_scn_flowid(void *cbarg,
-			    struct bfa_rport_qos_attr_s old_qos_attr,
-			    struct bfa_rport_qos_attr_s new_qos_attr)
+			struct bfa_rport_qos_attr_s old_qos_attr,
+			struct bfa_rport_qos_attr_s new_qos_attr)
 {
-	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *) cbarg;
 	struct bfa_rport_aen_data_s aen_data;
 
 	bfa_trc(rport->fcs, rport->pwwn);
@@ -2462,22 +2453,24 @@ bfa_cb_rport_qos_scn_flowid(void *cbarg,
 }
 
 /**
- * This routine is a static BFA callback when there is a QoS priority
- * change notification
+ *	brief
+ *	This routine is a static BFA callback when there is a QoS priority
+ *	change notification
  *
- * @param[in] 	rport 	-
+ *	param[in]	rport	-
  *
- * @return 	void
+ *	return
+ *		void
  *
- * Special Considerations:
+ *	Special Considerations:
  *
- * @note
+ *	note
  */
 void
 bfa_cb_rport_qos_scn_prio(void *cbarg, struct bfa_rport_qos_attr_s old_qos_attr,
-			  struct bfa_rport_qos_attr_s new_qos_attr)
+			   struct bfa_rport_qos_attr_s new_qos_attr)
 {
-	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *) cbarg;
 	struct bfa_rport_aen_data_s aen_data;
 
 	bfa_trc(rport->fcs, rport->pwwn);
@@ -2486,7 +2479,7 @@ bfa_cb_rport_qos_scn_prio(void *cbarg, struct bfa_rport_qos_attr_s old_qos_attr,
 }
 
 /**
- * 		Called to process any unsolicted frames from this remote port
+ *		Called to process any unsolicted frames from this remote port
  */
 void
 bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport)
@@ -2495,11 +2488,11 @@ bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport)
 }
 
 /**
- * 		Called to process any unsolicted frames from this remote port
+ *		Called to process any unsolicted frames from this remote port
  */
 void
 bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
-			u16 len)
+				u16 len)
 {
 	struct bfa_fcs_port_s *port = rport->port;
 	struct fc_els_cmd_s   *els_cmd;
@@ -2556,9 +2549,9 @@ bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
 			  u8 reason_code, u8 reason_code_expl)
 {
 	struct bfa_fcs_port_s *port = rport->port;
-	struct fchs_s          fchs;
+	struct fchs_s		fchs;
 	struct bfa_fcxp_s *fcxp;
-	int             len;
+	int		len;
 
 	bfa_trc(rport->fcs, rx_fchs->s_id);
 
@@ -2566,29 +2559,13 @@ bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
 	if (!fcxp)
 		return;
 
-	len = fc_ls_rjt_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
-			      bfa_fcs_port_get_fcid(port), rx_fchs->ox_id,
-			      reason_code, reason_code_expl);
+	len = fc_ls_rjt_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			      rx_fchs->s_id, bfa_fcs_port_get_fcid(port),
+			      rx_fchs->ox_id, reason_code, reason_code_expl);
 
-	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
-}
-
-/**
- *   Module initialization
- */
-void
-bfa_fcs_rport_modinit(struct bfa_fcs_s *fcs)
-{
-}
-
-/**
- *   Module cleanup
- */
-void
-bfa_fcs_rport_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag,
+		      BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
+		      FC_MAX_PDUSZ, 0);
 }
 
 /**
@@ -2601,18 +2578,17 @@ bfa_fcs_rport_get_state(struct bfa_fcs_rport_s *rport)
 }
 
 /**
- * 		 Called by the Driver to set rport delete/ageout timeout
+ *	brief
+ *		 Called by the Driver to set rport delete/ageout timeout
  *
- * 	param[in]		rport timeout value in seconds.
+ *	param[in]		rport timeout value in seconds.
  *
- * 	return None
+ *	return None
  */
 void
 bfa_fcs_rport_set_del_timeout(u8 rport_tmo)
 {
-	/*
-	 * convert to Millisecs
-	 */
+	/* convert to Millisecs */
 	if (rport_tmo > 0)
 		bfa_fcs_rport_del_timeout = rport_tmo * 1000;
 }
diff --git a/drivers/scsi/bfa/rport_api.c b/drivers/scsi/bfa/rport_api.c
index 3dae177..329bbee 100644
--- a/drivers/scsi/bfa/rport_api.c
+++ b/drivers/scsi/bfa/rport_api.c
@@ -37,8 +37,7 @@ BFA_TRC_FILE(FCS, RPORT_API);
  */
 bfa_status_t
 bfa_fcs_rport_add(struct bfa_fcs_port_s *port, wwn_t *pwwn,
-			struct bfa_fcs_rport_s *rport,
-			struct bfad_rport_s *rport_drv)
+		struct bfa_fcs_rport_s *rport, struct bfad_rport_s *rport_drv)
 {
 	bfa_trc(port->fcs, *pwwn);
 
@@ -102,11 +101,12 @@ bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
 	rport_attr->qos_attr = qos_attr;
 
 	rport_attr->trl_enforced = BFA_FALSE;
-	if (bfa_pport_is_ratelim(port->fcs->bfa)) {
+	if (bfa_fcport_is_ratelim(port->fcs->bfa)) {
 		if ((rport->rpf.rpsc_speed == BFA_PPORT_SPEED_UNKNOWN) ||
 			(rport->rpf.rpsc_speed <
-			bfa_fcs_port_get_rport_max_speed(port)))
+				bfa_fcs_port_get_rport_max_speed(port))) {
 			rport_attr->trl_enforced = BFA_TRUE;
+		}
 	}
 
 	/*
diff --git a/drivers/scsi/bfa/rport_ftrs.c b/drivers/scsi/bfa/rport_ftrs.c
index e1932c8..ba97fdb 100644
--- a/drivers/scsi/bfa/rport_ftrs.c
+++ b/drivers/scsi/bfa/rport_ftrs.c
@@ -34,12 +34,12 @@ BFA_TRC_FILE(FCS, RPORT_FTRS);
 #define BFA_FCS_RPF_RETRY_TIMEOUT  (1000) /* 1 sec (In millisecs) */
 
 static void     bfa_fcs_rpf_send_rpsc2(void *rport_cbarg,
-			struct bfa_fcxp_s *fcxp_alloced);
+					struct bfa_fcxp_s *fcxp_alloced);
 static void     bfa_fcs_rpf_rpsc2_response(void *fcsarg,
-			struct bfa_fcxp_s *fcxp, void *cbarg,
-			bfa_status_t req_status, u32 rsp_len,
-			u32 resid_len,
-			struct fchs_s *rsp_fchs);
+					struct bfa_fcxp_s *fcxp,
+					void *cbarg, bfa_status_t req_status,
+					u32 rsp_len, u32 resid_len,
+					struct fchs_s *rsp_fchs);
 static void     bfa_fcs_rpf_timeout(void *arg);
 
 /**
@@ -56,7 +56,7 @@ enum rpf_event {
 	RPFSM_EVENT_RPSC_ERROR     = 7,
 };
 
-static void	bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf_s *rpf,
+static void		bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf_s *rpf,
 					enum rpf_event event);
 static void     bfa_fcs_rpf_sm_rpsc_sending(struct bfa_fcs_rpf_s *rpf,
 					       enum rpf_event event);
@@ -91,7 +91,7 @@ bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -114,7 +114,7 @@ bfa_fcs_rpf_sm_rpsc_sending(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -134,6 +134,7 @@ bfa_fcs_rpf_sm_rpsc(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 			bfa_rport_speed(rport->bfa_rport, rpf->rpsc_speed);
 		else if (rpf->assigned_speed != BFA_PPORT_SPEED_UNKNOWN)
 			bfa_rport_speed(rport->bfa_rport, rpf->assigned_speed);
+
 		break;
 
 	case RPFSM_EVENT_RPSC_FAIL:
@@ -160,7 +161,7 @@ bfa_fcs_rpf_sm_rpsc(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -186,7 +187,7 @@ bfa_fcs_rpf_sm_rpsc_retry(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -206,7 +207,7 @@ bfa_fcs_rpf_sm_online(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -229,7 +230,7 @@ bfa_fcs_rpf_sm_offline(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 /**
diff --git a/drivers/scsi/bfa/scn.c b/drivers/scsi/bfa/scn.c
index bd4771f..c2343ec 100644
--- a/drivers/scsi/bfa/scn.c
+++ b/drivers/scsi/bfa/scn.c
@@ -78,7 +78,7 @@ static void     bfa_fcs_port_scn_sm_online(struct bfa_fcs_port_scn_s *scn,
  */
 static void
 bfa_fcs_port_scn_sm_offline(struct bfa_fcs_port_scn_s *scn,
-			    enum port_scn_event event)
+				enum port_scn_event event)
 {
 	switch (event) {
 	case SCNSM_EVENT_PORT_ONLINE:
@@ -90,7 +90,7 @@ bfa_fcs_port_scn_sm_offline(struct bfa_fcs_port_scn_s *scn,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(scn->port->fcs, event);
 	}
 }
 
@@ -109,13 +109,13 @@ bfa_fcs_port_scn_sm_sending_scr(struct bfa_fcs_port_scn_s *scn,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(scn->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_scn_sm_scr(struct bfa_fcs_port_scn_s *scn,
-			enum port_scn_event event)
+				enum port_scn_event event)
 {
 	struct bfa_fcs_port_s *port = scn->port;
 
@@ -127,8 +127,8 @@ bfa_fcs_port_scn_sm_scr(struct bfa_fcs_port_scn_s *scn,
 	case SCNSM_EVENT_RSP_ERROR:
 		bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_scr_retry);
 		bfa_timer_start(port->fcs->bfa, &scn->timer,
-				bfa_fcs_port_scn_timeout, scn,
-				BFA_FCS_RETRY_TIMEOUT);
+				    bfa_fcs_port_scn_timeout, scn,
+				    BFA_FCS_RETRY_TIMEOUT);
 		break;
 
 	case SCNSM_EVENT_PORT_OFFLINE:
@@ -137,13 +137,13 @@ bfa_fcs_port_scn_sm_scr(struct bfa_fcs_port_scn_s *scn,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_scn_sm_scr_retry(struct bfa_fcs_port_scn_s *scn,
-			      enum port_scn_event event)
+				enum port_scn_event event)
 {
 	switch (event) {
 	case SCNSM_EVENT_TIMEOUT:
@@ -157,13 +157,13 @@ bfa_fcs_port_scn_sm_scr_retry(struct bfa_fcs_port_scn_s *scn,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(scn->port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_scn_sm_online(struct bfa_fcs_port_scn_s *scn,
-			   enum port_scn_event event)
+				enum port_scn_event event)
 {
 	switch (event) {
 	case SCNSM_EVENT_PORT_OFFLINE:
@@ -171,7 +171,7 @@ bfa_fcs_port_scn_sm_online(struct bfa_fcs_port_scn_s *scn,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(scn->port->fcs, event);
 	}
 }
 
@@ -199,37 +199,34 @@ bfa_fcs_port_scn_send_scr(void *scn_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
 	if (!fcxp) {
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &scn->fcxp_wqe,
-				    bfa_fcs_port_scn_send_scr, scn);
+					bfa_fcs_port_scn_send_scr, scn);
 		return;
 	}
 	scn->fcxp = fcxp;
 
-	/*
-	 * Handle VU registrations for Base port only
-	 */
+	/* Handle VU registrations for Base port only */
 	if ((!port->vport) && bfa_ioc_get_fcmode(&port->fcs->bfa->ioc)) {
 		len = fc_scr_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-				   bfa_lps_is_brcd_fabric(port->fabric->lps),
-				   port->pid, 0);
+				bfa_lps_is_brcd_fabric(port->fabric->lps),
+				port->pid, 0);
 	} else {
-		len = fc_scr_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), BFA_FALSE,
-				   port->pid, 0);
+		len = fc_scr_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+				BFA_FALSE, port->pid, 0);
 	}
-
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len, &fchs, bfa_fcs_port_scn_scr_response,
-		      (void *)scn, FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, len, &fchs, bfa_fcs_port_scn_scr_response,
+			  (void *)scn, FC_MAX_PDUSZ, FC_RA_TOV);
 
 	bfa_sm_send_event(scn, SCNSM_EVENT_SCR_SENT);
 }
 
 static void
 bfa_fcs_port_scn_scr_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
-			      void *cbarg, bfa_status_t req_status,
-			      u32 rsp_len, u32 resid_len,
-			      struct fchs_s *rsp_fchs)
+				void *cbarg, bfa_status_t req_status,
+				u32 rsp_len, u32 resid_len,
+				struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_scn_s *scn = (struct bfa_fcs_port_scn_s *)cbarg;
+	struct bfa_fcs_port_scn_s *scn = (struct bfa_fcs_port_scn_s *) cbarg;
 	struct bfa_fcs_port_s *port = scn->port;
 	struct fc_els_cmd_s   *els_cmd;
 	struct fc_ls_rjt_s    *ls_rjt;
@@ -273,7 +270,7 @@ bfa_fcs_port_scn_scr_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
  */
 static void
 bfa_fcs_port_scn_send_ls_acc(struct bfa_fcs_port_s *port,
-			struct fchs_s *rx_fchs)
+				struct fchs_s *rx_fchs)
 {
 	struct fchs_s          fchs;
 	struct bfa_fcxp_s *fcxp;
@@ -286,12 +283,13 @@ bfa_fcs_port_scn_send_ls_acc(struct bfa_fcs_port_s *port,
 	if (!fcxp)
 		return;
 
-	len = fc_ls_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
-			      bfa_fcs_port_get_fcid(port), rx_fchs->ox_id);
+	len = fc_ls_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			      rx_fchs->s_id, bfa_fcs_port_get_fcid(port),
+			      rx_fchs->ox_id);
 
 	bfa_fcxp_send(fcxp, bfa_rport, port->fabric->vf_id, port->lp_tag,
-		      BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
-		      FC_MAX_PDUSZ, 0);
+			  BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
+			  FC_MAX_PDUSZ, 0);
 }
 
 /**
@@ -303,14 +301,14 @@ bfa_fcs_port_scn_send_ls_acc(struct bfa_fcs_port_s *port,
  * 	return
  * 		void
  *
-*  	Special Considerations:
+ * 	Special Considerations:
  *
  * 	note
  */
 static void
 bfa_fcs_port_scn_timeout(void *arg)
 {
-	struct bfa_fcs_port_scn_s *scn = (struct bfa_fcs_port_scn_s *)arg;
+	struct bfa_fcs_port_scn_s *scn = (struct bfa_fcs_port_scn_s *) arg;
 
 	bfa_sm_send_event(scn, SCNSM_EVENT_TIMEOUT);
 }
@@ -381,17 +379,18 @@ bfa_fcs_port_scn_portid_rscn(struct bfa_fcs_port_s *port, u32 rpid)
 #define __fc_pid_match(__c0, __c1, __fmt)		\
 	(((__fmt) == FC_RSCN_FORMAT_FABRIC) ||		\
 	 (((__fmt) == FC_RSCN_FORMAT_DOMAIN) &&		\
-	  ((__c0)[0] == (__c1)[0])) ||			\
+	  ((__c0)[0] == (__c1)[0])) ||				\
 	 (((__fmt) == FC_RSCN_FORMAT_AREA) &&		\
-	  ((__c0)[0] == (__c1)[0]) &&			\
+	  ((__c0)[0] == (__c1)[0]) &&				\
 	  ((__c0)[1] == (__c1)[1])))
 
 static void
 bfa_fcs_port_scn_multiport_rscn(struct bfa_fcs_port_s *port,
-			enum fc_rscn_format format, u32 rscn_pid)
+				enum fc_rscn_format format,
+				u32 rscn_pid)
 {
 	struct bfa_fcs_rport_s *rport;
-	struct list_head *qe, *qe_next;
+	struct list_head        *qe, *qe_next;
 	u8        *c0, *c1;
 
 	bfa_trc(port->fcs, format);
@@ -400,13 +399,14 @@ bfa_fcs_port_scn_multiport_rscn(struct bfa_fcs_port_s *port,
 	c0 = (u8 *) &rscn_pid;
 
 	list_for_each_safe(qe, qe_next, &port->rport_q) {
-		rport = (struct bfa_fcs_rport_s *)qe;
+		rport = (struct bfa_fcs_rport_s *) qe;
 		c1 = (u8 *) &rport->pid;
 		if (__fc_pid_match(c0, c1, format))
 			bfa_fcs_rport_scn(rport);
 	}
 }
 
+
 void
 bfa_fcs_port_scn_process_rscn(struct bfa_fcs_port_s *port, struct fchs_s *fchs,
 			      u32 len)
@@ -438,24 +438,22 @@ bfa_fcs_port_scn_process_rscn(struct bfa_fcs_port_s *port, struct fchs_s *fchs,
 			if (rscn->event[i].qualifier == FC_QOS_RSCN_EVENT) {
 				/*
 				 * Ignore this event. f/w would have processed
-				 * it
+				 * it.
 				 */
 				bfa_trc(port->fcs, rscn_pid);
 			} else {
 				port->stats.num_portid_rscn++;
 				bfa_fcs_port_scn_portid_rscn(port, rscn_pid);
 			}
-			break;
+		break;
 
 		case FC_RSCN_FORMAT_FABRIC:
 			if (rscn->event[i].qualifier ==
-			    FC_FABRIC_NAME_RSCN_EVENT) {
+					FC_FABRIC_NAME_RSCN_EVENT) {
 				bfa_fcs_port_ms_fabric_rscn(port);
 				break;
 			}
-			/*
-			 * !!!!!!!!! Fall Through !!!!!!!!!!!!!
-			 */
+			/* !!!!!!!!! Fall Through !!!!!!!!!!!!! */
 
 		case FC_RSCN_FORMAT_AREA:
 		case FC_RSCN_FORMAT_DOMAIN:
diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index e90f1e3..94b2b55 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -67,7 +67,7 @@ enum bfa_fcs_vport_event {
 	BFA_FCS_VPORT_SM_RSP_ERROR = 9,	/*  error/bad response */
 	BFA_FCS_VPORT_SM_TIMEOUT = 10,	/*  delay timer event */
 	BFA_FCS_VPORT_SM_DELCOMP = 11,	/*  lport delete completion */
-	BFA_FCS_VPORT_SM_RSP_DUP_WWN = 12,	/*  Dup wnn error */
+	BFA_FCS_VPORT_SM_RSP_DUP_WWN = 12,	/*  Dup wnn error*/
 	BFA_FCS_VPORT_SM_RSP_FAILED = 13,	/*  non-retryable failure */
 };
 
@@ -90,9 +90,9 @@ static void     bfa_fcs_vport_sm_cleanup(struct bfa_fcs_vport_s *vport,
 static void     bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
 				      enum bfa_fcs_vport_event event);
 static void     bfa_fcs_vport_sm_error(struct bfa_fcs_vport_s *vport,
-				       enum bfa_fcs_vport_event event);
+				      enum bfa_fcs_vport_event event);
 
-static struct bfa_sm_table_s vport_sm_table[] = {
+static struct bfa_sm_table_s  vport_sm_table[] = {
 	{BFA_SM(bfa_fcs_vport_sm_uninit), BFA_FCS_VPORT_UNINIT},
 	{BFA_SM(bfa_fcs_vport_sm_created), BFA_FCS_VPORT_CREATED},
 	{BFA_SM(bfa_fcs_vport_sm_offline), BFA_FCS_VPORT_OFFLINE},
@@ -110,7 +110,7 @@ static struct bfa_sm_table_s vport_sm_table[] = {
  */
 static void
 bfa_fcs_vport_sm_uninit(struct bfa_fcs_vport_s *vport,
-			enum bfa_fcs_vport_event event)
+				enum bfa_fcs_vport_event event)
 {
 	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
 	bfa_trc(__vport_fcs(vport), event);
@@ -122,7 +122,7 @@ bfa_fcs_vport_sm_uninit(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -131,7 +131,7 @@ bfa_fcs_vport_sm_uninit(struct bfa_fcs_vport_s *vport,
  */
 static void
 bfa_fcs_vport_sm_created(struct bfa_fcs_vport_s *vport,
-			 enum bfa_fcs_vport_event event)
+				enum bfa_fcs_vport_event event)
 {
 	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
 	bfa_trc(__vport_fcs(vport), event);
@@ -165,7 +165,7 @@ bfa_fcs_vport_sm_created(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -174,7 +174,7 @@ bfa_fcs_vport_sm_created(struct bfa_fcs_vport_s *vport,
  */
 static void
 bfa_fcs_vport_sm_offline(struct bfa_fcs_vport_s *vport,
-			 enum bfa_fcs_vport_event event)
+				enum bfa_fcs_vport_event event)
 {
 	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
 	bfa_trc(__vport_fcs(vport), event);
@@ -202,16 +202,17 @@ bfa_fcs_vport_sm_offline(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
+
 /**
  * FDISC is sent and awaiting reply from fabric.
  */
 static void
 bfa_fcs_vport_sm_fdisc(struct bfa_fcs_vport_s *vport,
-		       enum bfa_fcs_vport_event event)
+				enum bfa_fcs_vport_event event)
 {
 	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
 	bfa_trc(__vport_fcs(vport), event);
@@ -236,8 +237,8 @@ bfa_fcs_vport_sm_fdisc(struct bfa_fcs_vport_s *vport,
 	case BFA_FCS_VPORT_SM_RSP_ERROR:
 		bfa_sm_set_state(vport, bfa_fcs_vport_sm_fdisc_retry);
 		bfa_timer_start(__vport_bfa(vport), &vport->timer,
-				bfa_fcs_vport_timeout, vport,
-				BFA_FCS_RETRY_TIMEOUT);
+				    bfa_fcs_vport_timeout, vport,
+				    BFA_FCS_RETRY_TIMEOUT);
 		break;
 
 	case BFA_FCS_VPORT_SM_RSP_FAILED:
@@ -249,7 +250,7 @@ bfa_fcs_vport_sm_fdisc(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -283,7 +284,7 @@ bfa_fcs_vport_sm_fdisc_retry(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -292,7 +293,7 @@ bfa_fcs_vport_sm_fdisc_retry(struct bfa_fcs_vport_s *vport,
  */
 static void
 bfa_fcs_vport_sm_online(struct bfa_fcs_vport_s *vport,
-			enum bfa_fcs_vport_event event)
+				enum bfa_fcs_vport_event event)
 {
 	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
 	bfa_trc(__vport_fcs(vport), event);
@@ -310,7 +311,7 @@ bfa_fcs_vport_sm_online(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -320,7 +321,7 @@ bfa_fcs_vport_sm_online(struct bfa_fcs_vport_s *vport,
  */
 static void
 bfa_fcs_vport_sm_deleting(struct bfa_fcs_vport_s *vport,
-			  enum bfa_fcs_vport_event event)
+				enum bfa_fcs_vport_event event)
 {
 	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
 	bfa_trc(__vport_fcs(vport), event);
@@ -339,18 +340,19 @@ bfa_fcs_vport_sm_deleting(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
 /**
- * Error State.
- * This state will be set when the Vport Creation fails due to errors like
- * Dup WWN. In this state only operation allowed is a Vport Delete.
+ *  Error State.
+ *  This state will be set when the Vport Creation fails due
+ *  to errors like Dup WWN.
+ *  In this state only operation allowed is a Vport Delete.
  */
 static void
 bfa_fcs_vport_sm_error(struct bfa_fcs_vport_s *vport,
-		       enum bfa_fcs_vport_event event)
+				enum bfa_fcs_vport_event event)
 {
 	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
 	bfa_trc(__vport_fcs(vport), event);
@@ -372,7 +374,7 @@ bfa_fcs_vport_sm_error(struct bfa_fcs_vport_s *vport,
  */
 static void
 bfa_fcs_vport_sm_cleanup(struct bfa_fcs_vport_s *vport,
-			 enum bfa_fcs_vport_event event)
+				enum bfa_fcs_vport_event event)
 {
 	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
 	bfa_trc(__vport_fcs(vport), event);
@@ -387,7 +389,7 @@ bfa_fcs_vport_sm_cleanup(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -397,7 +399,7 @@ bfa_fcs_vport_sm_cleanup(struct bfa_fcs_vport_s *vport,
  */
 static void
 bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
-		      enum bfa_fcs_vport_event event)
+				enum bfa_fcs_vport_event event)
 {
 	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
 	bfa_trc(__vport_fcs(vport), event);
@@ -419,7 +421,7 @@ bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -435,34 +437,19 @@ bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
 static void
 bfa_fcs_vport_aen_post(bfa_fcs_lport_t *port, enum bfa_lport_aen_event event)
 {
-	union bfa_aen_data_u aen_data;
-	struct bfa_log_mod_s *logmod = port->fcs->logm;
+	union bfa_aen_data_u  aen_data;
+	struct bfa_log_mod_s   *logmod = port->fcs->logm;
 	enum bfa_port_role role = port->port_cfg.roles;
 	wwn_t           lpwwn = bfa_fcs_port_get_pwwn(port);
 	char            lpwwn_ptr[BFA_STRING_32];
-	char           *role_str[BFA_PORT_ROLE_FCP_MAX / 2 + 1] =
-		{ "Initiator", "Target", "IPFC" };
+	char            *role_str[BFA_PORT_ROLE_FCP_MAX/2 + 1] =
+				{"Initiator", "Target", "IPFC"};
 
 	wwn2str(lpwwn_ptr, lpwwn);
 
 	bfa_assert(role <= BFA_PORT_ROLE_FCP_MAX);
-
-	switch (event) {
-	case BFA_LPORT_AEN_NPIV_DUP_WWN:
-		bfa_log(logmod, BFA_AEN_LPORT_NPIV_DUP_WWN, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_NPIV_FABRIC_MAX:
-		bfa_log(logmod, BFA_AEN_LPORT_NPIV_FABRIC_MAX, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_NPIV_UNKNOWN:
-		bfa_log(logmod, BFA_AEN_LPORT_NPIV_UNKNOWN, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, event), lpwwn_ptr,
+			role_str[role/2]);
 
 	aen_data.lport.vf_id = port->fabric->vf_id;
 	aen_data.lport.roles = role;
@@ -478,36 +465,34 @@ static void
 bfa_fcs_vport_do_fdisc(struct bfa_fcs_vport_s *vport)
 {
 	bfa_lps_fdisc(vport->lps, vport,
-		      bfa_pport_get_maxfrsize(__vport_bfa(vport)),
-		      __vport_pwwn(vport), __vport_nwwn(vport));
+		bfa_fcport_get_maxfrsize(__vport_bfa(vport)),
+		__vport_pwwn(vport), __vport_nwwn(vport));
 	vport->vport_stats.fdisc_sent++;
 }
 
 static void
 bfa_fcs_vport_fdisc_rejected(struct bfa_fcs_vport_s *vport)
 {
-	u8         lsrjt_rsn = bfa_lps_get_lsrjt_rsn(vport->lps);
-	u8         lsrjt_expl = bfa_lps_get_lsrjt_expl(vport->lps);
+	u8		lsrjt_rsn = bfa_lps_get_lsrjt_rsn(vport->lps);
+	u8		lsrjt_expl = bfa_lps_get_lsrjt_expl(vport->lps);
 
 	bfa_trc(__vport_fcs(vport), lsrjt_rsn);
 	bfa_trc(__vport_fcs(vport), lsrjt_expl);
 
-	/*
-	 * For certain reason codes, we don't want to retry.
-	 */
+	/* For certain reason codes, we don't want to retry. */
 	switch (bfa_lps_get_lsrjt_expl(vport->lps)) {
-	case FC_LS_RJT_EXP_INV_PORT_NAME:	/* by brocade */
-	case FC_LS_RJT_EXP_INVALID_NPORT_ID:	/* by Cisco */
+	case  FC_LS_RJT_EXP_INV_PORT_NAME: /* by brocade */
+	case  FC_LS_RJT_EXP_INVALID_NPORT_ID: /* by Cisco */
 		if (vport->fdisc_retries < BFA_FCS_VPORT_MAX_RETRIES)
 			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
 		else {
 			bfa_fcs_vport_aen_post(&vport->lport,
-					       BFA_LPORT_AEN_NPIV_DUP_WWN);
+				BFA_LPORT_AEN_NPIV_DUP_WWN);
 			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_DUP_WWN);
 		}
 		break;
 
-	case FC_LS_RJT_EXP_INSUFF_RES:
+	case  FC_LS_RJT_EXP_INSUFF_RES:
 		/*
 		 * This means max logins per port/switch setting on the
 		 * switch was exceeded.
@@ -516,15 +501,15 @@ bfa_fcs_vport_fdisc_rejected(struct bfa_fcs_vport_s *vport)
 			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
 		else {
 			bfa_fcs_vport_aen_post(&vport->lport,
-					       BFA_LPORT_AEN_NPIV_FABRIC_MAX);
+				BFA_LPORT_AEN_NPIV_FABRIC_MAX);
 			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_FAILED);
 		}
 		break;
 
 	default:
-		if (vport->fdisc_retries == 0)	/* Print only once */
+		if (vport->fdisc_retries == 0) 	/* Print only once */
 			bfa_fcs_vport_aen_post(&vport->lport,
-					       BFA_LPORT_AEN_NPIV_UNKNOWN);
+					BFA_LPORT_AEN_NPIV_UNKNOWN);
 		bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
 	}
 }
@@ -542,6 +527,7 @@ bfa_fcs_vport_do_logo(struct bfa_fcs_vport_s *vport)
 	bfa_lps_fdisclogo(vport->lps);
 }
 
+
 /**
  *     This routine will be called by bfa_timer on timer timeouts.
  *
@@ -551,14 +537,14 @@ bfa_fcs_vport_do_logo(struct bfa_fcs_vport_s *vport)
  * 	return
  * 		void
  *
-* 	Special Considerations:
+ * 	Special Considerations:
  *
  * 	note
  */
 static void
 bfa_fcs_vport_timeout(void *vport_arg)
 {
-	struct bfa_fcs_vport_s *vport = (struct bfa_fcs_vport_s *)vport_arg;
+	struct bfa_fcs_vport_s *vport = (struct bfa_fcs_vport_s *) vport_arg;
 
 	vport->vport_stats.fdisc_timeouts++;
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_TIMEOUT);
@@ -616,36 +602,6 @@ bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport)
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_DELCOMP);
 }
 
-/**
- *   Module initialization
- */
-void
-bfa_fcs_vport_modinit(struct bfa_fcs_s *fcs)
-{
-}
-
-/**
- *   Module cleanup
- */
-void
-bfa_fcs_vport_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
-}
-
-u32
-bfa_fcs_vport_get_max(struct bfa_fcs_s *fcs)
-{
-	struct bfa_ioc_attr_s ioc_attr;
-
-	bfa_get_attr(fcs->bfa, &ioc_attr);
-
-	if (ioc_attr.pci_attr.device_id == BFA_PCI_DEVICE_ID_CT)
-		return BFA_FCS_MAX_VPORTS_SUPP_CT;
-	else
-		return BFA_FCS_MAX_VPORTS_SUPP_CB;
-}
-
 
 
 /**
@@ -658,7 +614,7 @@ bfa_fcs_vport_get_max(struct bfa_fcs_s *fcs)
  * 	done in vport_start() call)
  *
  * 	param[in] vport	- 	pointer to bfa_fcs_vport_t. This space
- * 					needs to be allocated by the driver.
+ *					needs to be allocated by the driver.
  * 	param[in] fcs 		- 	FCS instance
  * 	param[in] vport_cfg	- 	vport configuration
  * 	param[in] vf_id    	- 	VF_ID if vport is created within a VF.
@@ -671,8 +627,8 @@ bfa_fcs_vport_get_max(struct bfa_fcs_s *fcs)
  */
 bfa_status_t
 bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
-		     u16 vf_id, struct bfa_port_cfg_s *vport_cfg,
-		     struct bfad_vport_s *vport_drv)
+			u16 vf_id, struct bfa_port_cfg_s *vport_cfg,
+			struct bfad_vport_s *vport_drv)
 {
 	if (vport_cfg->pwwn == 0)
 		return BFA_STATUS_INVALID_WWN;
@@ -684,7 +640,7 @@ bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 		return BFA_STATUS_VPORT_EXISTS;
 
 	if (bfa_fcs_fabric_vport_count(&fcs->fabric) ==
-	    bfa_fcs_vport_get_max(fcs))
+			bfa_lps_get_max_vport(fcs->bfa))
 		return BFA_STATUS_VPORT_MAX;
 
 	vport->lps = bfa_lps_alloc(fcs->bfa);
@@ -693,9 +649,8 @@ bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 
 	vport->vport_drv = vport_drv;
 	bfa_sm_set_state(vport, bfa_fcs_vport_sm_uninit);
-
-	bfa_fcs_lport_init(&vport->lport, fcs, vf_id, vport_cfg, vport);
-
+	bfa_fcs_lport_attach(&vport->lport, fcs, vf_id, vport);
+	bfa_fcs_lport_init(&vport->lport, vport_cfg);
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_CREATE);
 
 	return BFA_STATUS_OK;
@@ -759,7 +714,7 @@ bfa_fcs_vport_delete(struct bfa_fcs_vport_s *vport)
  */
 void
 bfa_fcs_vport_get_attr(struct bfa_fcs_vport_s *vport,
-		       struct bfa_vport_attr_s *attr)
+			struct bfa_vport_attr_s *attr)
 {
 	if (vport == NULL || attr == NULL)
 		return;
@@ -842,9 +797,7 @@ bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status)
 		break;
 
 	case BFA_STATUS_INVALID_MAC:
-		/*
-		 * Only for CNA
-		 */
+		/* Only for CNA */
 		vport->vport_stats.fdisc_acc_bad++;
 		bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
 
@@ -888,4 +841,17 @@ bfa_cb_lps_fdisclogo_comp(void *bfad, void *uarg)
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_OK);
 }
 
+/**
+ * Received clear virtual link
+ */
+void
+bfa_cb_lps_cvl_event(void *bfad, void *uarg)
+{
+	struct bfa_fcs_vport_s *vport = uarg;
+
+	/* Send an Offline followed by an ONLINE */
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_OFFLINE);
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_ONLINE);
+}
+
 
-- 
1.6.5.2

