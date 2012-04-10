From: <kgudipat@brocade.com>
Subject: [PATCH 3/4] bfa: Fix bfa logging for Logical port state change notification
Date: Mon, 9 Apr 2012 18:41:18 -0700
Message-ID: <1334022078-24500-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56875 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758281Ab2DJBln (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Apr 2012 21:41:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Made changes to have the same logging level for Logical port
	  online and offline events, to display these events in pairs.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index cd01fc0..937000d 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -616,7 +616,7 @@ bfa_fcs_lport_online_actions(struct bfa_fcs_lport_s *port)
 	__port_action[port->fabric->fab_type].online(port);
 
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(port));
-	BFA_LOG(KERN_INFO, bfad, bfa_log_level,
+	BFA_LOG(KERN_WARNING, bfad, bfa_log_level,
 		"Logical port online: WWN = %s Role = %s\n",
 		lpwwn_buf, "Initiator");
 	bfa_fcs_lport_aen_post(port, BFA_LPORT_AEN_ONLINE);
@@ -639,12 +639,12 @@ bfa_fcs_lport_offline_actions(struct bfa_fcs_lport_s *port)
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(port));
 	if (bfa_sm_cmp_state(port->fabric,
 			bfa_fcs_fabric_sm_online) == BFA_TRUE) {
-		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
+		BFA_LOG(KERN_WARNING, bfad, bfa_log_level,
 		"Logical port lost fabric connectivity: WWN = %s Role = %s\n",
 		lpwwn_buf, "Initiator");
 		bfa_fcs_lport_aen_post(port, BFA_LPORT_AEN_DISCONNECT);
 	} else {
-		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
+		BFA_LOG(KERN_WARNING, bfad, bfa_log_level,
 		"Logical port taken offline: WWN = %s Role = %s\n",
 		lpwwn_buf, "Initiator");
 		bfa_fcs_lport_aen_post(port, BFA_LPORT_AEN_OFFLINE);
-- 
1.7.3.rc1

