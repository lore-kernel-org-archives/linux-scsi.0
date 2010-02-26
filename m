From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 25/32] bfa: New portlog entries for events (FIP/FLOGI/FDISC/LOGO).
Date: Thu, 25 Feb 2010 17:49:48 -0800
Message-ID: <1267148988-23438-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:59511 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934929Ab0BZBwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:52:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Change details:

	- Add portlog entries for FIP/FLOGI/FDISC/LOGO events.
---
 drivers/scsi/bfa/bfa_fcport.c                   |   24 +++++-
 drivers/scsi/bfa/bfa_lps.c                      |   27 ++++++-
 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h |   94 +++++++++++++++++++++++
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h  |   21 +++++-
 drivers/scsi/bfa/include/protocol/fc.h          |    5 +
 5 files changed, 162 insertions(+), 9 deletions(-)
 create mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index 6266b5c..29fb129 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -324,6 +324,7 @@ bfa_fcport_sm_enabling(struct bfa_fcport_s *fcport, enum bfa_fcport_sm_event eve
 static void
 bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport, enum bfa_fcport_sm_event event)
 {
+	struct bfi_fcport_event_s *pevent = fcport->event_arg.i2hmsg.event;
 	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
@@ -333,6 +334,22 @@ bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport, enum bfa_fcport_sm_event eve
 		bfa_assert(fcport->event_cbfn);
 		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 			     BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkup");
+
+		if (!bfa_ioc_get_fcmode(&fcport->bfa->ioc)) {
+
+			bfa_trc(fcport->bfa, pevent->link_state.fcf.fipenabled);
+			bfa_trc(fcport->bfa, pevent->link_state.fcf.fipfailed);
+
+			if (pevent->link_state.fcf.fipfailed)
+				bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+					BFA_PL_EID_FIP_FCF_DISC, 0,
+					"FIP FCF Discovery Failed");
+			else
+				bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+					BFA_PL_EID_FIP_FCF_DISC, 0,
+					"FIP FCF Discovered");
+		}
+
 		bfa_fcport_callback(fcport, BFA_PPORT_LINKUP);
 		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_ONLINE);
 		/**
@@ -382,7 +399,8 @@ bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport, enum bfa_fcport_sm_event eve
 }
 
 static void
-bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport, enum bfa_fcport_sm_event event)
+bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport,
+		enum bfa_fcport_sm_event event)
 {
 	bfa_trc(fcport->bfa, event);
 
@@ -1497,8 +1515,6 @@ bfa_port_stats_query(void *cbarg)
 	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_GET_STATS_REQ,
 		    bfa_lpuid(fcport->bfa));
 	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
-
-	return;
 }
 
 static void
@@ -1523,7 +1539,6 @@ bfa_port_stats_clear(void *cbarg)
 	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_STATS_REQ,
 		    bfa_lpuid(fcport->bfa));
 	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
-	return;
 }
 
 static void
@@ -1596,7 +1611,6 @@ bfa_port_qos_stats_clear(void *cbarg)
 	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ,
 		    bfa_lpuid(fcport->bfa));
 	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
-	return;
 }
 
 static void
diff --git a/drivers/scsi/bfa/bfa_lps.c b/drivers/scsi/bfa/bfa_lps.c
index 38d0c8d..1b4c883 100644
--- a/drivers/scsi/bfa/bfa_lps.c
+++ b/drivers/scsi/bfa/bfa_lps.c
@@ -99,6 +99,12 @@ bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event)
 			bfa_sm_set_state(lps, bfa_lps_sm_login);
 			bfa_lps_send_login(lps);
 		}
+		if (lps->fdisc)
+			bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+			BFA_PL_EID_LOGIN, 0, "FDISC Request");
+		else
+			bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+			BFA_PL_EID_LOGIN, 0, "FLOGI Request");
 		break;
 
 	case BFA_LPS_SM_LOGOUT:
@@ -136,10 +142,25 @@ bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
 
 	switch (event) {
 	case BFA_LPS_SM_FWRSP:
-		if (lps->status == BFA_STATUS_OK)
+		if (lps->status == BFA_STATUS_OK) {
 			bfa_sm_set_state(lps, bfa_lps_sm_online);
-		else
+			if (lps->fdisc)
+				bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+				BFA_PL_EID_LOGIN, 0, "FDISC Accept");
+			else
+				bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+				BFA_PL_EID_LOGIN, 0, "FLOGI Accept");
+		} else {
 			bfa_sm_set_state(lps, bfa_lps_sm_init);
+			if (lps->fdisc)
+				bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+				BFA_PL_EID_LOGIN, 0,
+				"FDISC Fail (RJT or timeout)");
+			else
+				bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+				BFA_PL_EID_LOGIN, 0,
+				"FLOGI Fail (RJT or timeout)");
+		}
 		bfa_lps_login_comp(lps);
 		break;
 
@@ -202,6 +223,8 @@ bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
 			bfa_sm_set_state(lps, bfa_lps_sm_logout);
 			bfa_lps_send_logout(lps);
 		}
+		bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+			BFA_PL_EID_LOGO, 0, "Logout");
 		break;
 
 	case BFA_LPS_SM_RX_CVL:
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_fcport.h b/drivers/scsi/bfa/include/defs/bfa_defs_fcport.h
new file mode 100644
index 0000000..a07ef4a
--- /dev/null
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_fcport.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ *  bfa_defs_fcport.h
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_FCPORT_H__
+#define __BFA_DEFS_FCPORT_H__
+
+#include <defs/bfa_defs_types.h>
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+/**
+ * FCoE statistics
+ */
+struct bfa_fcoe_stats_s {
+	u64	secs_reset;	/*  Seconds since stats reset	     */
+	u64	cee_linkups;	/*  CEE link up		     */
+	u64	cee_linkdns;	/*  CEE link down		     */
+	u64	fip_linkups;	/*  FIP link up		     */
+	u64	fip_linkdns;	/*  FIP link down		     */
+	u64	fip_fails;	/*  FIP failures		     */
+	u64	mac_invalids;	/*  Invalid mac assignments	     */
+	u64	vlan_req;	/*  Vlan requests		     */
+	u64	vlan_notify;	/*  Vlan notifications		     */
+	u64	vlan_err;	/*  Vlan notification errors	     */
+	u64	vlan_timeouts;	/*  Vlan request timeouts	     */
+	u64	vlan_invalids;	/*  Vlan invalids		     */
+	u64	disc_req;	/*  Discovery requests		     */
+	u64	disc_rsp;	/*  Discovery responses	     */
+	u64	disc_err;	/*  Discovery error frames	     */
+	u64	disc_unsol;	/*  Discovery unsolicited	     */
+	u64	disc_timeouts;	/*  Discovery timeouts		     */
+	u64	disc_fcf_unavail; /*  Discovery FCF not avail	     */
+	u64	linksvc_unsupp;	/*  FIP link service req unsupp.    */
+	u64	linksvc_err;	/*  FIP link service req errors     */
+	u64	logo_req;	/*  FIP logo			     */
+	u64	clrvlink_req;	/*  Clear virtual link requests     */
+	u64	op_unsupp;	/*  FIP operation unsupp.	     */
+	u64	untagged;	/*  FIP untagged frames	     */
+	u64	txf_ucast;	/*  Tx FCoE unicast frames	     */
+	u64	txf_ucast_vlan;	/*  Tx FCoE unicast vlan frames     */
+	u64	txf_ucast_octets; /*  Tx FCoE unicast octets	     */
+	u64	txf_mcast;	/*  Tx FCoE mutlicast frames	     */
+	u64	txf_mcast_vlan;	/*  Tx FCoE mutlicast vlan frames   */
+	u64	txf_mcast_octets; /*  Tx FCoE multicast octets	     */
+	u64	txf_bcast;	/*  Tx FCoE broadcast frames	     */
+	u64	txf_bcast_vlan;	/*  Tx FCoE broadcast vlan frames   */
+	u64	txf_bcast_octets; /*  Tx FCoE broadcast octets	     */
+	u64	txf_timeout;	/*  Tx timeouts		     */
+	u64	txf_parity_errors; /*  Transmit parity err	     */
+	u64	txf_fid_parity_errors; /*  Transmit FID parity err  */
+	u64	tx_pause;	/*  Tx pause frames		     */
+	u64	tx_zero_pause;	/*  Tx zero pause frames	     */
+	u64	tx_first_pause;	/*  Tx first pause frames	     */
+	u64	rx_pause;	/*  Rx pause frames		     */
+	u64	rx_zero_pause;	/*  Rx zero pause frames	     */
+	u64	rx_first_pause;	/*  Rx first pause frames	     */
+	u64	rxf_ucast_octets; /*  Rx unicast octets	     */
+	u64	rxf_ucast;	/*  Rx unicast frames		     */
+	u64	rxf_ucast_vlan;	/*  Rx unicast vlan frames	     */
+	u64	rxf_mcast_octets; /*  Rx multicast octets	     */
+	u64	rxf_mcast;	/*  Rx multicast frames	     */
+	u64	rxf_mcast_vlan;	/*  Rx multicast vlan frames	     */
+	u64	rxf_bcast_octets; /*  Rx broadcast octests	     */
+	u64	rxf_bcast;	/*  Rx broadcast frames	     */
+	u64	rxf_bcast_vlan;	/*  Rx broadcast vlan frames	     */
+};
+
+/**
+ * QoS or FCoE stats (fcport stats excluding physical FC port stats)
+ */
+union bfa_fcport_stats_u {
+	struct bfa_qos_stats_s	fcqos;
+	struct bfa_fcoe_stats_s	fcoe;
+};
+
+#pragma pack()
+
+#endif  /* __BFA_DEFS_FCPORT_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
index 88662a1..164cfbe 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
@@ -333,8 +333,7 @@ struct bfa_pport_fcpmap_s {
 };
 
 /**
- *              Port RNID info.
- */
+ *              Port RNI	 */
 struct bfa_pport_rnid_s {
 	wwn_t             wwn;
 	u32          unittype;
@@ -347,6 +346,23 @@ struct bfa_pport_rnid_s {
 	u16          topologydiscoveryflags;
 };
 
+struct bfa_fcport_fcf_s {
+	wwn_t           name;           /* FCF name                 */
+	wwn_t           fabric_name;    /* Fabric Name              */
+	u8		fipenabled;     /* FIP enabled or not       */
+	u8		fipfailed;      /* FIP failed or not        */
+	u8         	resv[2];
+	u8         	pri;            /* FCF priority             */
+	u8         	version;        /* FIP version used         */
+	u8         	available;      /* Available  for  login    */
+	u8         	fka_disabled;   /* FKA is disabled          */
+	u8         	maxsz_verified; /* FCoE max size verified   */
+	u8         	fc_map[3];      /* FC map                   */
+	u16		vlan;           /* FCoE vlan tag/priority   */
+	u32        	fka_adv_per;    /* FIP  ka advert. period   */
+	struct mac_s	mac;            /* FCF mac                  */
+};
+
 /**
  * 		Link state information
  */
@@ -378,6 +394,7 @@ struct bfa_pport_link_s {
 			struct fc_alpabm_s     alpabm;	   /*  alpa bitmap */
 		} loop_info;
 	} tl;
+	struct bfa_fcport_fcf_s fcf;    /*!< FCF information (for FCoE) */
 };
 
 #endif /* __BFA_DEFS_PPORT_H__ */
diff --git a/drivers/scsi/bfa/include/protocol/fc.h b/drivers/scsi/bfa/include/protocol/fc.h
index 14969ee..8d10380 100644
--- a/drivers/scsi/bfa/include/protocol/fc.h
+++ b/drivers/scsi/bfa/include/protocol/fc.h
@@ -50,6 +50,11 @@ struct fchs_s {
 
 	u32        ro;		/* relative offset */
 };
+
+#define FC_SOF_LEN      4
+#define FC_EOF_LEN      4
+#define FC_CRC_LEN      4
+
 /*
  * Fibre Channel BB_E Header Structure
  */
-- 
1.6.5.3

