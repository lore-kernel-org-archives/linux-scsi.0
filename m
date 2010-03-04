From: <kgudipat@brocade.com>
Subject: [PATCH 14/32] bfa: Fix to copy fpma MAC when requested by user space application.
Date: Wed, 3 Mar 2010 17:44:59 -0800
Message-ID: <1267667099-25392-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:47665 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0CDBpM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:45:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Copy fpma MAC when requested by user space application.
	- Added FPMA mac address to the lport attributes structure.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c              |    7 ++++++-
 drivers/scsi/bfa/bfa_lps.c                    |    8 ++++++++
 drivers/scsi/bfa/include/bfa_svc.h            |    1 +
 drivers/scsi/bfa/include/defs/bfa_defs_port.h |    4 +++-
 4 files changed, 18 insertions(+), 2 deletions(-)

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
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_port.h b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
index de0696c..1c74a8b 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_port.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
@@ -185,6 +185,8 @@ struct bfa_port_attr_s {
 	wwn_t		fabric_name; /*  attached switch's nwwn */
 	u8		fabric_ip_addr[BFA_FCS_FABRIC_IPADDR_SZ]; /*  attached
 							* fabric's ip addr */
+	struct mac_s    fpma_mac;	/*  Lport's FPMA Mac address */
+	u16     authfail;		/*  auth failed state */
 };
 
 /**
@@ -235,7 +237,7 @@ struct bfa_port_aen_data_s {
 	enum bfa_ioc_type_e ioc_type;
 	wwn_t           pwwn;	      /*  WWN of the physical port */
 	wwn_t           fwwn;	      /*  WWN of the fabric port */
-	mac_t           mac;	      /*  MAC addres of the ethernet port,
+	mac_t           mac;	      /*  MAC address of the ethernet port,
 				       * applicable to CNA port only */
 	int             phy_port_num; /*! For SFP related events */
 	enum bfa_port_aen_sfp_pom level; /*  Only transitions will
-- 
1.6.5.3

