From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 13/17] bfa: Fix bug_on condition in RPSC rsp handling
Date: Mon, 13 May 2013 02:33:31 -0700
Message-ID: <1368437615-9867-14-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50285 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200Ab3EMJtO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:49:14 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

Fix bug_on condition check in RPSC (Report Port Speed Capabilities)
response processing.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_rport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 807622b..891aab6 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -3430,9 +3430,10 @@ bfa_fcs_rpf_rpsc2_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 		num_ents = be16_to_cpu(rpsc2_acc->num_pids);
 		bfa_trc(rport->fcs, num_ents);
 		if (num_ents > 0) {
-			WARN_ON(rpsc2_acc->port_info[0].pid == rport->pid);
+			WARN_ON(be32_to_cpu(rpsc2_acc->port_info[0].pid) !=
+						bfa_ntoh3b(rport->pid));
 			bfa_trc(rport->fcs,
-				be16_to_cpu(rpsc2_acc->port_info[0].pid));
+				be32_to_cpu(rpsc2_acc->port_info[0].pid));
 			bfa_trc(rport->fcs,
 				be16_to_cpu(rpsc2_acc->port_info[0].speed));
 			bfa_trc(rport->fcs,
-- 
1.7.12

