From: <vmohan@brocade.com>
Subject: [PATCH RESEND 3/8] bfa: LUN discovery issue in direct attach mode
Date: Thu, 21 Nov 2013 01:37:45 -0800
Message-ID: <1385026670-7006-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:18832 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190Ab3KUJhx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Nov 2013 04:37:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: agurumur@brocade.com, james.bottomley@hansenpartnership.com

From: Vijaya Mohan Guvva <vmohan@brocade.com>

In direct attach mode, if port features like QoS/Trunk/FEC/CR are
enabled, driver can receive PLOGI from the target before firmware
notifies lport online to the driver. In case the lport is not yet online
and a PLOGI is received, send a reject to the peer port, instead of
dropping it on the floor.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 2f61a5a..06bae2b 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -773,7 +773,20 @@ bfa_fcs_lport_uf_recv(struct bfa_fcs_lport_s *lport,
 	bfa_trc(lport->fcs, fchs->type);
 
 	if (!bfa_fcs_lport_is_online(lport)) {
-		bfa_stats(lport, uf_recv_drops);
+		/*
+		 * In direct attach topology, it is possible to get a PLOGI
+		 * before the lport is online due to port feature
+		 * (QoS/Trunk/FEC/CR), so send a rjt
+		 */
+		if ((fchs->type == FC_TYPE_ELS) &&
+			(els_cmd->els_code == FC_ELS_PLOGI)) {
+			bfa_fcs_lport_send_ls_rjt(lport, fchs,
+				FC_LS_RJT_RSN_UNABLE_TO_PERF_CMD,
+				FC_LS_RJT_EXP_NO_ADDL_INFO);
+			bfa_stats(lport, plogi_rcvd);
+		} else
+			bfa_stats(lport, uf_recv_drops);
+
 		return;
 	}
 
-- 
1.8.2.1

