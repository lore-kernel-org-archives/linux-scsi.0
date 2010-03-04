From: <kgudipat@brocade.com>
Subject: [PATCH 08/32] bfa: Fix to allow creation of only 190 vports on CNA.
Date: Wed, 3 Mar 2010 17:43:45 -0800
Message-ID: <1267667025-21851-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:33953 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0CDBoF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:44:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Brocade CNA currently supports only 190 vports (instead of 191),
	  since there are only 192 unicast cam entries reserved for FCoE.

	- Brocade CNA has a total of 256 unicast cam entries (192 FCoE + 64 LL)

		192 cam entries = 1 burned in mac + 1 baseport FPMA mac + 190 vport FPMA macs.

	- Made changes to the code to support only 190 vports.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_lps.c                   |   20 ++++++++++++++++++++
 drivers/scsi/bfa/fcs_vport.h                 |    1 -
 drivers/scsi/bfa/include/bfa_svc.h           |    1 +
 drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h |    8 --------
 drivers/scsi/bfa/lport_api.c                 |    3 ++-
 drivers/scsi/bfa/vport.c                     |   17 +----------------
 6 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_lps.c b/drivers/scsi/bfa/bfa_lps.c
index c8c2564..66b9b15 100644
--- a/drivers/scsi/bfa/bfa_lps.c
+++ b/drivers/scsi/bfa/bfa_lps.c
@@ -18,6 +18,7 @@
 #include <bfa.h>
 #include <bfi/bfi_lps.h>
 #include <cs/bfa_debug.h>
+#include <defs/bfa_defs_pci.h>
 
 BFA_TRC_FILE(HAL, LPS);
 BFA_MODULE(lps);
@@ -25,6 +26,12 @@ BFA_MODULE(lps);
 #define BFA_LPS_MIN_LPORTS	(1)
 #define BFA_LPS_MAX_LPORTS	(256)
 
+/*
+ * Maximum Vports supported per physical port or vf.
+ */
+#define BFA_LPS_MAX_VPORTS_SUPP_CB  255
+#define BFA_LPS_MAX_VPORTS_SUPP_CT  190
+
 /**
  * forward declarations
  */
@@ -598,6 +605,19 @@ bfa_lps_cvl_event(struct bfa_lps_s *lps)
 		bfa_cb_lps_cvl_event(lps->bfa->bfad, lps->uarg);
 }
 
+u32
+bfa_lps_get_max_vport(struct bfa_s *bfa)
+{
+	struct bfa_ioc_attr_s ioc_attr;
+
+	bfa_get_attr(bfa, &ioc_attr);
+
+	if (ioc_attr.pci_attr.device_id == BFA_PCI_DEVICE_ID_CT)
+		return (BFA_LPS_MAX_VPORTS_SUPP_CT);
+	else
+		return (BFA_LPS_MAX_VPORTS_SUPP_CB);
+}
+
 /**
  *  lps_public BFA LPS public functions
  */
diff --git a/drivers/scsi/bfa/fcs_vport.h b/drivers/scsi/bfa/fcs_vport.h
index 32565ba..13c32eb 100644
--- a/drivers/scsi/bfa/fcs_vport.h
+++ b/drivers/scsi/bfa/fcs_vport.h
@@ -26,7 +26,6 @@ void bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport);
-u32 bfa_fcs_vport_get_max(struct bfa_fcs_s *fcs);
 
 #endif /* __FCS_VPORT_H__ */
 
diff --git a/drivers/scsi/bfa/include/bfa_svc.h b/drivers/scsi/bfa/include/bfa_svc.h
index 2e4372f..0d7ed4d 100644
--- a/drivers/scsi/bfa/include/bfa_svc.h
+++ b/drivers/scsi/bfa/include/bfa_svc.h
@@ -293,6 +293,7 @@ void bfa_uf_free(struct bfa_uf_s *uf);
  * bfa lport service api
  */
 
+u32	bfa_lps_get_max_vport(struct bfa_s *bfa);
 struct bfa_lps_s *bfa_lps_alloc(struct bfa_s *bfa);
 void bfa_lps_delete(struct bfa_lps_s *lps);
 void bfa_lps_discard(struct bfa_lps_s *lps);
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h b/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h
index 967ceb0..ceaefd3 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h
@@ -34,14 +34,6 @@ struct bfa_fcs_s;
 struct bfa_fcs_fabric_s;
 
 /*
-* @todo : need to move to a global config file.
- * Maximum Vports supported per physical port or vf.
- */
-#define BFA_FCS_MAX_VPORTS_SUPP_CB  255
-#define BFA_FCS_MAX_VPORTS_SUPP_CT  191
-
-/*
-* @todo : need to move to a global config file.
  * Maximum Rports supported per port (physical/logical).
  */
 #define BFA_FCS_MAX_RPORTS_SUPP  256	/* @todo : tentative value */
diff --git a/drivers/scsi/bfa/lport_api.c b/drivers/scsi/bfa/lport_api.c
index 1e06792..4a4ccce 100644
--- a/drivers/scsi/bfa/lport_api.c
+++ b/drivers/scsi/bfa/lport_api.c
@@ -235,7 +235,8 @@ bfa_fcs_port_get_info(struct bfa_fcs_port_s *port,
 		port_info->port_wwn = bfa_fcs_port_get_pwwn(port);
 		port_info->node_wwn = bfa_fcs_port_get_nwwn(port);
 
-		port_info->max_vports_supp = bfa_fcs_vport_get_max(port->fcs);
+		port_info->max_vports_supp =
+			bfa_lps_get_max_vport(port->fcs->bfa);
 		port_info->num_vports_inuse =
 			bfa_fcs_fabric_vport_count(port->fabric);
 		port_info->max_rports_supp = BFA_FCS_MAX_RPORTS_SUPP;
diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index 75d6f05..3dce9e1 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -616,21 +616,6 @@ bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport)
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_DELCOMP);
 }
 
-u32
-bfa_fcs_vport_get_max(struct bfa_fcs_s *fcs)
-{
-	struct bfa_ioc_attr_s ioc_attr;
-
-	bfa_get_attr(fcs->bfa, &ioc_attr);
-
-	if (ioc_attr.pci_attr.device_id == BFA_PCI_DEVICE_ID_CT)
-		return BFA_FCS_MAX_VPORTS_SUPP_CT;
-	else
-		return BFA_FCS_MAX_VPORTS_SUPP_CB;
-}
-
-
-
 /**
  *  fcs_vport_api Virtual port API
  */
@@ -667,7 +652,7 @@ bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 		return BFA_STATUS_VPORT_EXISTS;
 
 	if (bfa_fcs_fabric_vport_count(&fcs->fabric) ==
-	    bfa_fcs_vport_get_max(fcs))
+		bfa_lps_get_max_vport(fcs->bfa))
 		return BFA_STATUS_VPORT_MAX;
 
 	vport->lps = bfa_lps_alloc(fcs->bfa);
-- 
1.6.5.3

