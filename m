From: <kgudipat@brocade.com>
Subject: [PATCH 1/4] bfa: Fix to defer vport delete handler invocation till firmware logo response.
Date: Mon, 9 Apr 2012 18:40:01 -0700
Message-ID: <1334022001-23987-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:57663 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890Ab2DJBko (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Apr 2012 21:40:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Made changes to avoid queuing the vport delete work to IM driver
	  work queue in the bfa_fcb_lport_delete() - since at this stage we
	  are not completely done with using the vport structure as we are
	  still waiting for the LOGO response from the fw in online state or
	  just doing some cleanup. Since queuing up the vport delete work at
	  this stage will result in the FC transport layer to clean up the vport
	  before we get the response from firmware.
	- Made changes to queue the port delete work to the IM driver work queue -
	  from the bfa_fcs_vport_free() function since at this state we are done
	  with using the vport data structure and the FCS state machine is completely
	  cleaned up.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs.h       |    3 ---
 drivers/scsi/bfa/bfa_fcs_lport.c |   26 ++++++++++++++------------
 drivers/scsi/bfa/bfad.c          |   17 -----------------
 drivers/scsi/bfa/bfad_attr.c     |    1 +
 4 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index e75e07d..51c9e13 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -799,9 +799,6 @@ struct bfad_port_s *bfa_fcb_lport_new(struct bfad_s *bfad,
 				      enum bfa_lport_role roles,
 				      struct bfad_vf_s *vf_drv,
 				      struct bfad_vport_s *vp_drv);
-void bfa_fcb_lport_delete(struct bfad_s *bfad, enum bfa_lport_role roles,
-			  struct bfad_vf_s *vf_drv,
-			  struct bfad_vport_s *vp_drv);
 
 /*
  * vport callbacks
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 5d2a130..cd01fc0 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -709,14 +709,10 @@ bfa_fcs_lport_deleted(struct bfa_fcs_lport_s *port)
 	bfa_fcs_lport_aen_post(port, BFA_LPORT_AEN_DELETE);
 
 	/* Base port will be deleted by the OS driver */
-	if (port->vport) {
-		bfa_fcb_lport_delete(port->fcs->bfad, port->port_cfg.roles,
-				port->fabric->vf_drv,
-				port->vport ? port->vport->vport_drv : NULL);
+	if (port->vport)
 		bfa_fcs_vport_delete_comp(port->vport);
-	} else {
+	else
 		bfa_wc_down(&port->fabric->wc);
-	}
 }
 
 
@@ -5714,17 +5710,23 @@ bfa_fcs_vport_free(struct bfa_fcs_vport_s *vport)
 			(struct bfad_vport_s *)vport->vport_drv;
 
 	bfa_fcs_fabric_delvport(__vport_fabric(vport), vport);
+	bfa_lps_delete(vport->lps);
 
-	if (vport_drv->comp_del)
+	if (vport_drv->comp_del) {
 		complete(vport_drv->comp_del);
-	else
-		kfree(vport_drv);
+		return;
+	}
 
-	bfa_lps_delete(vport->lps);
+	/*
+	 * We queue the vport delete work to the IM work_q from here.
+	 * The memory for the bfad_vport_s is freed from the FC function
+	 * template vport_delete entry point.
+	 */
+	if (vport_drv)
+		bfad_im_port_delete(vport_drv->drv_port.bfad,
+				&vport_drv->drv_port);
 }
 
-
-
 /*
  *  fcs_vport_public FCS virtual port public interfaces
  */
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 404fd10..2e4b0be 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -456,23 +456,6 @@ bfa_fcb_lport_new(struct bfad_s *bfad, struct bfa_fcs_lport_s *port,
 	return port_drv;
 }
 
-void
-bfa_fcb_lport_delete(struct bfad_s *bfad, enum bfa_lport_role roles,
-		    struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv)
-{
-	struct bfad_port_s    *port_drv;
-
-	/* this will be only called from rmmod context */
-	if (vp_drv && !vp_drv->comp_del) {
-		port_drv = (vp_drv) ? (&(vp_drv)->drv_port) :
-				((vf_drv) ? (&(vf_drv)->base_port) :
-				(&(bfad)->pport));
-		bfa_trc(bfad, roles);
-		if (roles & BFA_LPORT_ROLE_FCP_IM)
-			bfad_im_port_delete(bfad, port_drv);
-	}
-}
-
 /*
  * FCS RPORT alloc callback, after successful PLOGI by FCS
  */
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 7b1ecd2..d12be9d 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -497,6 +497,7 @@ bfad_im_vport_delete(struct fc_vport *fc_vport)
 	if (im_port->flags & BFAD_PORT_DELETE) {
 		bfad_scsi_host_free(bfad, im_port);
 		list_del(&vport->list_entry);
+		kfree(vport);
 		return 0;
 	}
 
-- 
1.7.3.rc1

