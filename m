From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 16/24] bfa: fix link state structure
Date: Thu, 8 Jul 2010 19:58:01 -0700
Message-ID: <1278644281-2019-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:36426 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177Ab0GIC6H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:58:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

When the FCoE Linkup event is sent to the host, the link_state
(struct bfa_pport_link_s) structure is copied to the RME buf to be sent to
the host. But the size of this structure(164 bytes) is larger than the
reserved RME buffer size(128 byes). The following changes reduce the size
of the structure to be less than RME buffer size(128 bytes):
- Remove the trunk and loop info from link_state structure, because both trunk
  and loop are not supported.
- Combine qos_vc_attr and fcf into an union.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_fcport.c                  |   15 +++++++++------
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h |   22 +++-------------------
 2 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index e0e7a0d..c855e22 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -311,10 +311,12 @@ bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport,
 
 		if (!bfa_ioc_get_fcmode(&fcport->bfa->ioc)) {
 
-			bfa_trc(fcport->bfa, pevent->link_state.fcf.fipenabled);
-			bfa_trc(fcport->bfa, pevent->link_state.fcf.fipfailed);
+			bfa_trc(fcport->bfa,
+				pevent->link_state.vc_fcf.fcf.fipenabled);
+			bfa_trc(fcport->bfa,
+				pevent->link_state.vc_fcf.fcf.fipfailed);
 
-			if (pevent->link_state.fcf.fipfailed)
+			if (pevent->link_state.vc_fcf.fcf.fipfailed)
 				bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 					BFA_PL_EID_FIP_FCF_DISC, 0,
 					"FIP FCF Discovery Failed");
@@ -960,14 +962,15 @@ bfa_fcport_update_linkinfo(struct bfa_fcport_s *fcport)
 	fcport->topology = pevent->link_state.topology;
 
 	if (fcport->topology == BFA_PPORT_TOPOLOGY_LOOP)
-		fcport->myalpa =
-			pevent->link_state.tl.loop_info.myalpa;
+		fcport->myalpa = 0;
 
 	/*
 	 * QoS Details
 	 */
 	bfa_os_assign(fcport->qos_attr, pevent->link_state.qos_attr);
-	bfa_os_assign(fcport->qos_vc_attr, pevent->link_state.qos_vc_attr);
+	bfa_os_assign(fcport->qos_vc_attr,
+		pevent->link_state.vc_fcf.qos_vc_attr);
+
 
 	bfa_trc(fcport->bfa, fcport->speed);
 	bfa_trc(fcport->bfa, fcport->topology);
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
index 2c2cec5..2de6758 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
@@ -384,26 +384,10 @@ struct bfa_pport_link_s {
 	u8         trunked;	/*  Trunked or not (1 or 0) */
 	u8         resvd[3];
 	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
-	struct bfa_qos_vc_attr_s qos_vc_attr;  /*  VC info from ELP */
 	union {
-		struct {
-			u8         tmaster;/*  Trunk Master or
-						 *    not (1 or 0) */
-			u8         tlinks;	/*  Trunk links bitmap
-						 *    (linkup) */
-			u8         resv1;	/*  Reserved */
-		} trunk_info;
-
-		struct {
-			u8         myalpa;	   /*  alpa claimed */
-			u8         login_req; /*  Login required or
-						    *    not (1 or 0) */
-			u8         alpabm_val;/*  alpa bitmap valid
-						    *    or not (1 or 0) */
-			struct fc_alpabm_s     alpabm;	   /*  alpa bitmap */
-		} loop_info;
-	} tl;
-	struct bfa_fcport_fcf_s fcf;    /*!< FCF information (for FCoE) */
+		struct bfa_qos_vc_attr_s qos_vc_attr;  /* VC info from ELP */
+		struct bfa_fcport_fcf_s fcf;    /* FCF information (for FCoE) */
+	} vc_fcf;
 };
 
 #endif /* __BFA_DEFS_PPORT_H__ */
-- 
1.6.5.2

