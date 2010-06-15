From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 04/23] bfa: vport state machine fix
Date: Tue, 15 Jun 2010 11:22:56 -0700
Message-ID: <1276626176-5547-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44279 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932331Ab0FOSn0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:43:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Vport state machine does not cleanup associated lport in some states: while
waiting for fdisc response or fdisc failure state. The fixe is to cleanup lport
on vport delete in all states.  In fdisc state, discard fdisc response and
delete lport and wait for lport deletecompletion. in error state, delete lport
and wait for delete completion.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/vport.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index f14e9f2..66f30a0 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -218,9 +218,9 @@ bfa_fcs_vport_sm_fdisc(struct bfa_fcs_vport_s *vport,
 
 	switch (event) {
 	case BFA_FCS_VPORT_SM_DELETE:
-		bfa_sm_set_state(vport, bfa_fcs_vport_sm_logo);
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_cleanup);
 		bfa_lps_discard(vport->lps);
-		bfa_fcs_vport_do_logo(vport);
+		bfa_fcs_port_delete(&vport->lport);
 		break;
 
 	case BFA_FCS_VPORT_SM_OFFLINE:
@@ -357,8 +357,9 @@ bfa_fcs_vport_sm_error(struct bfa_fcs_vport_s *vport,
 
 	switch (event) {
 	case BFA_FCS_VPORT_SM_DELETE:
-		bfa_sm_set_state(vport, bfa_fcs_vport_sm_uninit);
-		bfa_fcs_vport_free(vport);
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_cleanup);
+		bfa_fcs_port_delete(&vport->lport);
+
 		break;
 
 	default:
-- 
1.6.5.2

