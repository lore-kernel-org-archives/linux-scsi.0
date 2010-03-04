From: <kgudipat@brocade.com>
Subject: [PATCH 13/32] bfa: RPORT state machine: direct attach mode fix.
Date: Wed, 3 Mar 2010 17:44:47 -0800
Message-ID: <1267667087-25200-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:47663 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0CDBpA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:45:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Make sure that in direct attach mode, we do not query the name server after a
	  target is marked offline.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/rport.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/rport.c b/drivers/scsi/bfa/rport.c
index 32cf180..d7fc97a 100644
--- a/drivers/scsi/bfa/rport.c
+++ b/drivers/scsi/bfa/rport.c
@@ -925,10 +925,17 @@ bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
 	case RPSM_EVENT_HCB_OFFLINE:
 	case RPSM_EVENT_ADDRESS_CHANGE:
 		if (bfa_fcs_port_is_online(rport->port)) {
-			bfa_sm_set_state(rport,
-					 bfa_fcs_rport_sm_nsdisc_sending);
-			rport->ns_retries = 0;
-			bfa_fcs_rport_send_gidpn(rport, NULL);
+			if (bfa_fcs_fabric_is_switched(rport->port->fabric)) {
+				bfa_sm_set_state(rport,
+						bfa_fcs_rport_sm_nsdisc_sending);
+				rport->ns_retries = 0;
+				bfa_fcs_rport_send_gidpn(rport, NULL);
+			} else {
+				bfa_sm_set_state(rport,
+					bfa_fcs_rport_sm_plogi_sending);
+				rport->plogi_retries = 0;
+				bfa_fcs_rport_send_plogi(rport, NULL);
+			}
 		} else {
 			rport->pid = 0;
 			bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
-- 
1.6.5.3

