From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 14/32] bfa: Fix to copy fpma MAC when requested by user space application.
Date: Thu, 25 Feb 2010 17:48:45 -0800
Message-ID: <1267148925-22730-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:27240 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934920Ab0BZBv5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:51:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Change details:

	- Copy fpma MAC when requested by user space application.
	- Added FPMA mac address to the lport attributes structure.
---
 drivers/scsi/bfa/bfa_fcs_lport.c   |    7 ++++++-
 drivers/scsi/bfa/bfa_lps.c         |    8 ++++++++
 drivers/scsi/bfa/include/bfa_svc.h |    1 +
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 960ae1a..7bb182d 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -936,8 +936,13 @@ bfa_fcs_port_get_attr(struct bfa_fcs_port_s *port,
 		       bfa_fcs_port_get_fabric_ipaddr(port),
 		       BFA_FCS_FABRIC_IPADDR_SZ);
 
-		if (port->vport != NULL)
+		if (port->vport != NULL) {
 			port_attr->port_type = BFA_PPORT_TYPE_VPORT;
+			port_attr->fpma_mac =
+				bfa_lps_get_lp_mac(port->vport->lps);
+		} else
+			port_attr->fpma_mac =
+				bfa_lps_get_lp_mac(port->fabric->lps);
 
 	} else {
 		port_attr->port_type = BFA_PPORT_TYPE_UNKNOWN;
diff --git a/drivers/scsi/bfa/bfa_lps.c b/drivers/scsi/bfa/bfa_lps.c
index 4c98bda..38d0c8d 100644
--- a/drivers/scsi/bfa/bfa_lps.c
+++ b/drivers/scsi/bfa/bfa_lps.c
@@ -837,6 +837,14 @@ bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps)
 	return lps->lsrjt_expl;
 }
 
+/**
+ * Return fpma/spma MAC for lport
+ */
+struct mac_s
+bfa_lps_get_lp_mac(struct bfa_lps_s *lps)
+{
+	return lps->lp_mac;
+}
 
 /**
  * LPS firmware message class handler.
diff --git a/drivers/scsi/bfa/include/bfa_svc.h b/drivers/scsi/bfa/include/bfa_svc.h
index 0d7ed4d..71ffb75 100644
--- a/drivers/scsi/bfa/include/bfa_svc.h
+++ b/drivers/scsi/bfa/include/bfa_svc.h
@@ -316,6 +316,7 @@ wwn_t bfa_lps_get_peer_pwwn(struct bfa_lps_s *lps);
 wwn_t bfa_lps_get_peer_nwwn(struct bfa_lps_s *lps);
 u8 bfa_lps_get_lsrjt_rsn(struct bfa_lps_s *lps);
 u8 bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps);
+mac_t bfa_lps_get_lp_mac(struct bfa_lps_s *lps);
 void bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status);
 void bfa_cb_lps_flogo_comp(void *bfad, void *uarg);
 void bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status);
-- 
1.6.5.3

