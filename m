From: <kgudipat@brocade.com>
Subject: [PATCH 7/9] bfa: Fix to avoid vport delete hang on request queue full scenario.
Date: Tue, 13 Mar 2012 17:40:31 -0700
Message-ID: <1331685631-21993-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34993 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759598Ab2CNAlC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Mar 2012 20:41:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Fixed the LPS (Logical Port Services) state machine to send a
	  FDISC/FLOGI to the FW from the request queue wait state, when
	  there is space available again on the request queue.
	- Made changes to free the vport on LOGO/cleanup complete instead
	  of free'ing it from vport_delete_handler in the module unload scenario.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    2 ++
 drivers/scsi/bfa/bfa_svc.c       |    3 ++-
 drivers/scsi/bfa/bfad_attr.c     |    8 +++++---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index d4f951f..5d2a130 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5717,6 +5717,8 @@ bfa_fcs_vport_free(struct bfa_fcs_vport_s *vport)
 
 	if (vport_drv->comp_del)
 		complete(vport_drv->comp_del);
+	else
+		kfree(vport_drv);
 
 	bfa_lps_delete(vport->lps);
 }
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 3abe2be..6583b2d 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -1280,6 +1280,7 @@ bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event event)
 	switch (event) {
 	case BFA_LPS_SM_RESUME:
 		bfa_sm_set_state(lps, bfa_lps_sm_login);
+		bfa_lps_send_login(lps);
 		break;
 
 	case BFA_LPS_SM_OFFLINE:
@@ -1578,7 +1579,7 @@ bfa_lps_login_rsp(struct bfa_s *bfa, struct bfi_lps_login_rsp_s *rsp)
 		break;
 
 	case BFA_STATUS_VPORT_MAX:
-		if (!rsp->ext_status)
+		if (rsp->ext_status)
 			bfa_lps_no_res(lps, rsp->ext_status);
 		break;
 
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 06310b8..7b1ecd2 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -494,8 +494,11 @@ bfad_im_vport_delete(struct fc_vport *fc_vport)
 	unsigned long flags;
 	struct completion fcomp;
 
-	if (im_port->flags & BFAD_PORT_DELETE)
-		goto free_scsi_host;
+	if (im_port->flags & BFAD_PORT_DELETE) {
+		bfad_scsi_host_free(bfad, im_port);
+		list_del(&vport->list_entry);
+		return 0;
+	}
 
 	port = im_port->port;
 
@@ -526,7 +529,6 @@ bfad_im_vport_delete(struct fc_vport *fc_vport)
 
 	wait_for_completion(vport->comp_del);
 
-free_scsi_host:
 	bfad_scsi_host_free(bfad, im_port);
 	list_del(&vport->list_entry);
 	kfree(vport);
-- 
1.7.3.rc1

