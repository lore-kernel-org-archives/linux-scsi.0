From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] zfcp: add point-2-point support
Date: Wed, 6 Apr 2005 16:49:45 +0200
Message-ID: <20050406144945.GB7644@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:28835 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S262219AbVDFOsv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Apr 2005 10:48:51 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j36Emo0Q150556
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 14:48:50 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j36EmoGV216446
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 16:48:50 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j36Emnkp017337
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 16:48:50 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>

Hi,

This patch mainly introduces support for point-2-point
topology.


Regards,

Andreas

From: Heiko Carstens <heiko.carstens@de.ibm.com>
From: Maxim Shchetynin <maxim@de.ibm.com>
From: Andreas Herrmann <aherrman@de.ibm.com>

zfcp changes:
 - add support for point-2-point topology
 - correct permissions for module parameters
 - add log mesage if CFDC was hardened

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -bBrauN zfcp-bk/zfcp_aux.c zfcp-bk-adapt/zfcp_aux.c
--- zfcp-bk/zfcp_aux.c	2005-04-06 15:48:24.620792000 +0200
+++ zfcp-bk-adapt/zfcp_aux.c	2005-04-06 15:53:44.489164616 +0200
@@ -88,10 +88,10 @@
     ("FCP (SCSI over Fibre Channel) HBA driver for IBM eServer zSeries");
 MODULE_LICENSE("GPL");
 
-module_param(device, charp, 0);
+module_param(device, charp, 0400);
 MODULE_PARM_DESC(device, "specify initial device");
 
-module_param(loglevel, uint, 0);
+module_param(loglevel, uint, 0400);
 MODULE_PARM_DESC(loglevel,
 		 "log levels, 8 nibbles: "
 		 "FC ERP QDIO CIO Config FSF SCSI Other, "
diff -bBrauN zfcp-bk/zfcp_def.h zfcp-bk-adapt/zfcp_def.h
--- zfcp-bk/zfcp_def.h	2005-04-06 15:48:24.681782728 +0200
+++ zfcp-bk-adapt/zfcp_def.h	2005-04-06 15:53:44.490164464 +0200
@@ -69,7 +69,7 @@
 /********************* GENERAL DEFINES *********************************/
 
 /* zfcp version number, it consists of major, minor, and patch-level number */
-#define ZFCP_VERSION		"4.2.0"
+#define ZFCP_VERSION		"4.3.0"
 
 /**
  * zfcp_sg_to_address - determine kernel address from struct scatterlist
@@ -850,6 +850,9 @@
 	wwn_t			wwnn;	           /* WWNN */
 	wwn_t			wwpn;	           /* WWPN */
 	fc_id_t			s_id;	           /* N_Port ID */
+	wwn_t			peer_wwnn;	   /* P2P peer WWNN */
+	wwn_t			peer_wwpn;	   /* P2P peer WWPN */
+	fc_id_t			peer_d_id;	   /* P2P peer D_ID */
 	struct ccw_device       *ccw_device;	   /* S/390 ccw device */
 	u8			fc_service_class;
 	u32			fc_topology;	   /* FC topology */
diff -bBrauN zfcp-bk/zfcp_erp.c zfcp-bk-adapt/zfcp_erp.c
--- zfcp-bk/zfcp_erp.c	2005-04-06 15:48:24.681782728 +0200
+++ zfcp-bk-adapt/zfcp_erp.c	2005-04-06 15:53:44.490164464 +0200
@@ -2568,6 +2568,23 @@
 	case ZFCP_ERP_STEP_UNINITIALIZED:
 	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
 	case ZFCP_ERP_STEP_PORT_CLOSING:
+		if (adapter->fc_topology == FSF_TOPO_P2P) {
+			if (port->wwpn != adapter->peer_wwpn) {
+				ZFCP_LOG_NORMAL("Failed to open port 0x%016Lx "
+						"on adapter %s.\nPeer WWPN "
+						"0x%016Lx does not match\n",
+						port->wwpn,
+						zfcp_get_busid_by_adapter(adapter),
+						adapter->peer_wwpn);
+				zfcp_erp_port_failed(port);
+				retval = ZFCP_ERP_FAILED;
+				break;
+			}
+			port->d_id = adapter->peer_d_id;
+			atomic_set_mask(ZFCP_STATUS_PORT_DID_DID, &port->status);
+			retval = zfcp_erp_port_strategy_open_port(erp_action);
+			break;
+		}
 		if (!(adapter->nameserver_port)) {
 			retval = zfcp_nameserver_enqueue(adapter);
 			if (retval != 0) {
@@ -3516,8 +3533,9 @@
 	debug_text_event(adapter->erp_dbf, 3, "a_access_unblock");
 	debug_event(adapter->erp_dbf, 3, &adapter->name, 8);
 
-	zfcp_erp_port_access_changed(adapter->nameserver_port);
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	if (adapter->nameserver_port)
+		zfcp_erp_port_access_changed(adapter->nameserver_port);
 	list_for_each_entry(port, &adapter->port_list_head, list)
 		if (port != adapter->nameserver_port)
 			zfcp_erp_port_access_changed(port);
diff -bBrauN zfcp-bk/zfcp_fsf.c zfcp-bk-adapt/zfcp_fsf.c
--- zfcp-bk/zfcp_fsf.c	2005-04-06 15:48:24.682782576 +0200
+++ zfcp-bk-adapt/zfcp_fsf.c	2005-04-06 15:53:44.491164312 +0200
@@ -2107,6 +2107,9 @@
 		       bottom->low_qtcb_version, bottom->high_qtcb_version);
 	adapter->fsf_lic_version = bottom->lic_version;
 	adapter->supported_features = bottom->supported_features;
+	adapter->peer_wwpn = 0;
+	adapter->peer_wwnn = 0;
+	adapter->peer_d_id = 0;
 
 	if (xchg_ok) {
 		adapter->wwnn = bottom->nport_serv_param.wwnn;
@@ -2124,13 +2127,19 @@
 		adapter->hydra_version = 0;
 	}
 
+	if (adapter->fc_topology == FSF_TOPO_P2P) {
+		adapter->peer_d_id = bottom->peer_d_id & ZFCP_DID_MASK;
+		adapter->peer_wwpn = bottom->plogi_payload.wwpn;
+		adapter->peer_wwnn = bottom->plogi_payload.wwnn;
+	}
+
 	if(adapter->supported_features & FSF_FEATURE_HBAAPI_MANAGEMENT){
 		adapter->hardware_version = bottom->hardware_version;
 		memcpy(adapter->serial_number, bottom->serial_number, 17);
 		EBCASC(adapter->serial_number, sizeof(adapter->serial_number));
 	}
 
-	ZFCP_LOG_INFO("The adapter %s reported the following characteristics:\n"
+	ZFCP_LOG_NORMAL("The adapter %s reported the following characteristics:\n"
 		      "WWNN 0x%016Lx, "
 		      "WWPN 0x%016Lx, "
 		      "S_ID 0x%08x,\n"
@@ -2194,14 +2203,18 @@
 		switch (adapter->fc_topology) {
 		case FSF_TOPO_P2P:
 			ZFCP_LOG_FLAGS(1, "FSF_TOPO_P2P\n");
-			ZFCP_LOG_NORMAL("error: Point-to-point fibrechannel "
-					"configuration detected at adapter %s "
-					"unsupported, shutting down adapter\n",
-					zfcp_get_busid_by_adapter(adapter));
+			ZFCP_LOG_NORMAL("Point-to-Point fibrechannel "
+					"configuration detected at adapter %s\n"
+					"Peer WWNN 0x%016llx, "
+					"peer WWPN 0x%016llx, "
+					"peer d_id 0x%06x\n",
+					zfcp_get_busid_by_adapter(adapter),
+					adapter->peer_wwnn,
+					adapter->peer_wwpn,
+					adapter->peer_d_id);
 			debug_text_event(fsf_req->adapter->erp_dbf, 0,
 					 "top-p-to-p");
-			zfcp_erp_adapter_shutdown(adapter, 0);
-			return -EIO;
+			break;
 		case FSF_TOPO_AL:
 			ZFCP_LOG_FLAGS(1, "FSF_TOPO_AL\n");
 			ZFCP_LOG_NORMAL("error: Arbitrated loop fibrechannel "
@@ -2226,6 +2239,7 @@
 					"of a type known to the zfcp "
 					"driver, shutting down adapter\n",
 					zfcp_get_busid_by_adapter(adapter));
+			adapter->fc_topology = FSF_TOPO_ERROR;
 			debug_text_exception(fsf_req->adapter->erp_dbf, 0,
 					     "unknown-topo");
 			zfcp_erp_adapter_shutdown(adapter, 0);
@@ -4281,6 +4295,7 @@
 				      bottom.io.fcp_cmnd, FSF_FCP_CMND_SIZE);
 			zfcp_cmd_dbf_event_fsf("undeffcp", fsf_req, NULL, 0);
 			set_host_byte(&scpnt->result, DID_ERROR);
+			goto skip_fsfstatus;
 		}
 	}
 
@@ -4334,7 +4349,7 @@
 
 		scpnt->resid = fcp_rsp_iu->fcp_resid;
 		if (scpnt->request_bufflen - scpnt->resid < scpnt->underflow)
-			scpnt->result |= DID_ERROR << 16;
+			set_host_byte(&scpnt->result, DID_ERROR);
 	}
 
  skip_fsfstatus:
@@ -4607,6 +4622,13 @@
 		if (bottom->operation_subtype == FSF_CFDC_OPERATION_SUBTYPE) {
 			switch (header->fsf_status_qual.word[0]) {
 
+			case FSF_SQ_CFDC_HARDENED_ON_SE:
+				ZFCP_LOG_NORMAL(
+					"CFDC on the adapter %s has being "
+					"hardened on primary and secondary SE\n",
+					zfcp_get_busid_by_adapter(adapter));
+				break;
+
 			case FSF_SQ_CFDC_COULD_NOT_HARDEN_ON_SE:
 				ZFCP_LOG_NORMAL(
 					"CFDC of the adapter %s could not "
diff -bBrauN zfcp-bk/zfcp_fsf.h zfcp-bk-adapt/zfcp_fsf.h
--- zfcp-bk/zfcp_fsf.h	2005-04-06 15:48:24.682782576 +0200
+++ zfcp-bk-adapt/zfcp_fsf.h	2005-04-06 16:00:02.929632920 +0200
@@ -129,6 +129,7 @@
 #define FSF_SQ_NO_RETRY_POSSIBLE		0x07
 
 /* FSF status qualifier for CFDC commands */
+#define FSF_SQ_CFDC_HARDENED_ON_SE		0x00000000
 #define FSF_SQ_CFDC_COULD_NOT_HARDEN_ON_SE	0x00000001
 #define FSF_SQ_CFDC_COULD_NOT_HARDEN_ON_SE2	0x00000002
 /* CFDC subtable codes */
@@ -357,7 +358,6 @@
 	u8  class3_serv_param[16];
 	u8  class4_serv_param[16];
 	u8  vendor_version_level[16];
-	u8  res1[16];
 } __attribute__ ((packed));
 
 struct fsf_plogi {
@@ -415,11 +415,13 @@
 	u8 res2[12];
 	u32 s_id;
 	struct fsf_nport_serv_param nport_serv_param;
+	u8 reserved_nport_serv_param[16];
 	u8 res3[8];
 	u32 adapter_ports;
 	u32 hardware_version;
 	u8 serial_number[32];
-	u8 res4[272];
+	struct fsf_nport_serv_param plogi_payload;
+	u8 res4[160];
 } __attribute__ ((packed));
 
 struct fsf_qtcb_bottom_port {
diff -bBrauN zfcp-bk/zfcp_sysfs_adapter.c zfcp-bk-adapt/zfcp_sysfs_adapter.c
--- zfcp-bk/zfcp_sysfs_adapter.c	2005-04-06 15:48:24.682782576 +0200
+++ zfcp-bk-adapt/zfcp_sysfs_adapter.c	2005-04-06 15:53:44.491164312 +0200
@@ -65,6 +65,9 @@
 ZFCP_DEFINE_ADAPTER_ATTR(wwnn, "0x%016llx\n", adapter->wwnn);
 ZFCP_DEFINE_ADAPTER_ATTR(wwpn, "0x%016llx\n", adapter->wwpn);
 ZFCP_DEFINE_ADAPTER_ATTR(s_id, "0x%06x\n", adapter->s_id);
+ZFCP_DEFINE_ADAPTER_ATTR(peer_wwnn, "0x%016llx\n", adapter->peer_wwnn);
+ZFCP_DEFINE_ADAPTER_ATTR(peer_wwpn, "0x%016llx\n", adapter->peer_wwpn);
+ZFCP_DEFINE_ADAPTER_ATTR(peer_d_id, "0x%06x\n", adapter->peer_d_id);
 ZFCP_DEFINE_ADAPTER_ATTR(card_version, "0x%04x\n", adapter->hydra_version);
 ZFCP_DEFINE_ADAPTER_ATTR(lic_version, "0x%08x\n", adapter->fsf_lic_version);
 ZFCP_DEFINE_ADAPTER_ATTR(fc_link_speed, "%d Gb/s\n", adapter->fc_link_speed);
@@ -255,6 +258,9 @@
 	&dev_attr_wwnn.attr,
 	&dev_attr_wwpn.attr,
 	&dev_attr_s_id.attr,
+	&dev_attr_peer_wwnn.attr,
+	&dev_attr_peer_wwpn.attr,
+	&dev_attr_peer_d_id.attr,
 	&dev_attr_card_version.attr,
 	&dev_attr_lic_version.attr,
 	&dev_attr_fc_link_speed.attr,

