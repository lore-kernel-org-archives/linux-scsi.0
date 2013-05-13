From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 07/17] bfa: Fix FDISC timeout handling
Date: Mon, 13 May 2013 02:33:25 -0700
Message-ID: <1368437615-9867-8-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34607 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220Ab3EMKEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 06:04:55 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>, Anil Gurumurthy <agurumur@Brocade.COM>

Retry FDISC a max of 6 times. Introduce new events to handle vport
login fails due to max logins to fabric/switch.

Signed-off-by: Anil Gurumurthy <agurumur@brocade.com>
Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 8773d5e..2f61a5a 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5988,6 +5988,7 @@ enum bfa_fcs_vport_event {
 	BFA_FCS_VPORT_SM_RSP_DUP_WWN = 12,	/*  Dup wnn error*/
 	BFA_FCS_VPORT_SM_RSP_FAILED = 13,	/*  non-retryable failure */
 	BFA_FCS_VPORT_SM_STOPCOMP = 14,	/* vport delete completion */
+	BFA_FCS_VPORT_SM_FABRIC_MAX = 15, /* max vports on fabric */
 };
 
 static void     bfa_fcs_vport_sm_uninit(struct bfa_fcs_vport_s *vport,
@@ -6173,6 +6174,7 @@ bfa_fcs_vport_sm_fdisc(struct bfa_fcs_vport_s *vport,
 		break;
 
 	case BFA_FCS_VPORT_SM_RSP_FAILED:
+	case BFA_FCS_VPORT_SM_FABRIC_MAX:
 		bfa_sm_set_state(vport, bfa_fcs_vport_sm_offline);
 		break;
 
@@ -6243,6 +6245,7 @@ bfa_fcs_vport_sm_fdisc_rsp_wait(struct bfa_fcs_vport_s *vport,
 	case BFA_FCS_VPORT_SM_OFFLINE:
 	case BFA_FCS_VPORT_SM_RSP_ERROR:
 	case BFA_FCS_VPORT_SM_RSP_FAILED:
+	case BFA_FCS_VPORT_SM_FABRIC_MAX:
 	case BFA_FCS_VPORT_SM_RSP_DUP_WWN:
 		bfa_sm_set_state(vport, bfa_fcs_vport_sm_cleanup);
 		bfa_sm_send_event(vport->lps, BFA_LPS_SM_OFFLINE);
@@ -6528,7 +6531,7 @@ bfa_fcs_vport_fdisc_rejected(struct bfa_fcs_vport_s *vport)
 		else {
 			bfa_fcs_vport_aen_post(&vport->lport,
 					BFA_LPORT_AEN_NPIV_FABRIC_MAX);
-			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_FAILED);
+			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_FABRIC_MAX);
 		}
 		break;
 
@@ -6914,7 +6917,19 @@ bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status)
 			break;
 		}
 
-		bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
+		if (vport->fdisc_retries < BFA_FCS_VPORT_MAX_RETRIES)
+			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
+		else
+			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_FAILED);
+
+		break;
+
+	case BFA_STATUS_ETIMER:
+		vport->vport_stats.fdisc_timeouts++;
+		if (vport->fdisc_retries < BFA_FCS_VPORT_MAX_RETRIES)
+			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
+		else
+			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_FAILED);
 		break;
 
 	case BFA_STATUS_FABRIC_RJT:
-- 
1.7.12

