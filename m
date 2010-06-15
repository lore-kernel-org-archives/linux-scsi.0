From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 11/23] bfa: add PBC port disable handling
Date: Tue, 15 Jun 2010 11:40:32 -0700
Message-ID: <1276627232-16032-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44178 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485Ab0FOSkh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:40:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Add PBC port disable handling in BFA and return the appropriate status from
BFA APIs. In bfa_fcs_lport.c, handle OFFLINE event to avoid BFA_ASSERT.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_fcport.c    |   38 +++++++++++++++++++++++++++++++++-----
 drivers/scsi/bfa/bfa_fcs_lport.c |    3 +++
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index 18d3307..d3b5efb 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -18,6 +18,7 @@
 #include <bfa.h>
 #include <bfa_svc.h>
 #include <bfi/bfi_pport.h>
+#include <bfi/bfi_pbc.h>
 #include <cs/bfa_debug.h>
 #include <aen/bfa_aen.h>
 #include <cs/bfa_plog.h>
@@ -1380,6 +1381,14 @@ bfa_status_t
 bfa_fcport_enable(struct bfa_s *bfa)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+	struct bfi_iocfc_cfgrsp_s *cfgrsp = iocfc->cfgrsp;
+
+	/* if port is PBC disabled, return error */
+	if (cfgrsp->pbc_cfg.port_enabled == BFI_PBC_PORT_DISABLED) {
+		bfa_trc(bfa, fcport->pwwn);
+		return BFA_STATUS_PBC;
+	}
 
 	if (fcport->diag_busy)
 		return BFA_STATUS_DIAG_BUSY;
@@ -1394,6 +1403,16 @@ bfa_fcport_enable(struct bfa_s *bfa)
 bfa_status_t
 bfa_fcport_disable(struct bfa_s *bfa)
 {
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+	struct bfi_iocfc_cfgrsp_s *cfgrsp = iocfc->cfgrsp;
+
+	/* if port is PBC disabled, return error */
+	if (cfgrsp->pbc_cfg.port_enabled == BFI_PBC_PORT_DISABLED) {
+		bfa_trc(bfa, fcport->pwwn);
+		return BFA_STATUS_PBC;
+	}
+
 	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_DISABLE);
 	return BFA_STATUS_OK;
 }
@@ -1584,6 +1603,8 @@ void
 bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+	struct bfi_iocfc_cfgrsp_s *cfgrsp = iocfc->cfgrsp;
 
 	bfa_os_memset(attr, 0, sizeof(struct bfa_pport_attr_s));
 
@@ -1618,11 +1639,18 @@ bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr)
 
 	attr->pport_cfg.path_tov = bfa_fcpim_path_tov_get(bfa);
 	attr->pport_cfg.q_depth = bfa_fcpim_qdepth_get(bfa);
-	attr->port_state = bfa_sm_to_state(hal_pport_sm_table, fcport->sm);
-	if (bfa_ioc_is_disabled(&fcport->bfa->ioc))
-		attr->port_state = BFA_PPORT_ST_IOCDIS;
-	else if (bfa_ioc_fw_mismatch(&fcport->bfa->ioc))
-		attr->port_state = BFA_PPORT_ST_FWMISMATCH;
+
+	/* PBC Disabled State */
+	if (cfgrsp->pbc_cfg.port_enabled == BFI_PBC_PORT_DISABLED)
+		attr->port_state = BFA_PPORT_ST_PREBOOT_DISABLED;
+	else {
+		attr->port_state = bfa_sm_to_state(
+				hal_pport_sm_table, fcport->sm);
+		if (bfa_ioc_is_disabled(&fcport->bfa->ioc))
+			attr->port_state = BFA_PPORT_ST_IOCDIS;
+		else if (bfa_ioc_fw_mismatch(&fcport->bfa->ioc))
+			attr->port_state = BFA_PPORT_ST_FWMISMATCH;
+	}
 }
 
 #define BFA_FCPORT_STATS_TOV	1000
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 7c1251c..35df20e 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -135,6 +135,9 @@ bfa_fcs_port_sm_init(struct bfa_fcs_port_s *port, enum bfa_fcs_port_event event)
 		bfa_fcs_port_deleted(port);
 		break;
 
+	case BFA_FCS_PORT_SM_OFFLINE:
+		break;
+
 	default:
 		bfa_sm_fault(port->fcs, event);
 	}
-- 
1.6.5.2

