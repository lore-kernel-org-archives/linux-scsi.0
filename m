From: <kgudipat@brocade.com>
Subject: [PATCH 1/3] bfa: Fix possible NULL pointer dereference in lunmask add/delete.
Date: Tue, 20 Dec 2011 18:54:30 -0800
Message-ID: <1324436070-17297-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:35005 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771Ab1LUDqN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Dec 2011 22:46:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Patch fixes the possible NULL pointer dereference when
	  we try to add or delete a rpwwn to the lunmask config which is not
	  zoned to this port.
	- Check if the FCS rport is not NULL before de-referencing it.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcpim.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index e07bd47..846f15b 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2647,7 +2647,8 @@ bfa_fcpim_lunmask_add(struct bfa_s *bfa, u16 vf_id, wwn_t *pwwn,
 	if (port) {
 		*pwwn = port->port_cfg.pwwn;
 		rp_fcs = bfa_fcs_lport_get_rport_by_pwwn(port, rpwwn);
-		rp = rp_fcs->bfa_rport;
+		if (rp_fcs)
+			rp = rp_fcs->bfa_rport;
 	}
 
 	lunm_list = bfa_get_lun_mask_list(bfa);
@@ -2715,7 +2716,8 @@ bfa_fcpim_lunmask_delete(struct bfa_s *bfa, u16 vf_id, wwn_t *pwwn,
 		if (port) {
 			*pwwn = port->port_cfg.pwwn;
 			rp_fcs = bfa_fcs_lport_get_rport_by_pwwn(port, rpwwn);
-			rp = rp_fcs->bfa_rport;
+			if (rp_fcs)
+				rp = rp_fcs->bfa_rport;
 		}
 	}
 
-- 
1.7.3.rc1

