From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] zfcp: transport class adaptations II
Date: Fri, 13 Jan 2006 02:26:11 +0100
Message-ID: <20060113012611.GA6048@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:42468 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP
	id S1161631AbWAMB0Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 20:26:25 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id k0D1QOWs225326
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 01:26:24 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0D1QNwA202940
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 02:26:24 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k0D1QNDD015426
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 02:26:23 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

This patch replaces my patch from 2006-01-05
"zfcp: use fc_host attributes physical_port_name and physical_port_id"
http://marc.theaimsgroup.com/?l=linux-scsi&m=113645196121540&w=2

It depends on following patches
zfcp: handle unsolicited status notification lost
zfcp: transport class adaptations
fc transport: add permanent_port_name fc_host attribute

Please apply.


Regards,

Andreas

zfcp: transport class adaptations II

Replaced zfcp adapter attributes with fc_host attributes:
fc_topology by port_type, physical_wwpn by permanent_port_name.
Make use of fc_host attribute supported_speeds.
Removed zfcp adapter attribute physical_s_id.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/s390/scsi/zfcp_def.h           |    1 -
 drivers/s390/scsi/zfcp_erp.c           |    2 +
 drivers/s390/scsi/zfcp_fsf.c           |   49 ++++++++++++++++----------------
 drivers/s390/scsi/zfcp_fsf.h           |    1 -
 drivers/s390/scsi/zfcp_scsi.c          |    3 ++
 drivers/s390/scsi/zfcp_sysfs_adapter.c |   11 -------
 6 files changed, 29 insertions(+), 38 deletions(-)

4fe5c0d2b1953543c64c462ed5ad2b6de77747be
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 3785b3c..9bb5110 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -921,7 +921,6 @@ struct zfcp_adapter {
 	u32			physical_s_id;     /* local FC port ID */
 	struct ccw_device       *ccw_device;	   /* S/390 ccw device */
 	u8			fc_service_class;
-	u32			fc_topology;	   /* FC topology */
 	u32			hydra_version;	   /* Hydra version */
 	u32			fsf_lic_version;
 	u32			adapter_features;  /* FCP channel features */
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index ee7314d..7bdb00b 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -2613,7 +2613,7 @@ zfcp_erp_port_strategy_open_common(struc
 	case ZFCP_ERP_STEP_UNINITIALIZED:
 	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
 	case ZFCP_ERP_STEP_PORT_CLOSING:
-		if (adapter->fc_topology == FSF_TOPO_P2P) {
+		if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP) {
 			if (port->wwpn != adapter->peer_wwpn) {
 				ZFCP_LOG_NORMAL("Failed to open port 0x%016Lx "
 						"on adapter %s.\nPeer WWPN "
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index bf859c9..cbfab09 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2043,27 +2043,30 @@ zfcp_fsf_exchange_config_evaluate(struct
 		fc_host_port_id(shost) = bottom->s_id & ZFCP_DID_MASK;
 		fc_host_speed(shost) = bottom->fc_link_speed;
 		fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
-		adapter->fc_topology = bottom->fc_topology;
 		adapter->hydra_version = bottom->adapter_type;
-		if (adapter->physical_wwpn == 0)
-			adapter->physical_wwpn = fc_host_port_name(shost);
-		if (adapter->physical_s_id == 0)
-			adapter->physical_s_id = fc_host_port_id(shost);
+		if (fc_host_permanent_port_name(shost) == -1)
+			fc_host_permanent_port_name(shost) =
+				fc_host_port_name(shost);
+		if (bottom->fc_topology == FSF_TOPO_P2P) {
+			adapter->peer_d_id = bottom->peer_d_id & ZFCP_DID_MASK;
+			adapter->peer_wwpn = bottom->plogi_payload.wwpn;
+			adapter->peer_wwnn = bottom->plogi_payload.wwnn;
+			fc_host_port_type(shost) = FC_PORTTYPE_PTP;
+		} else if (bottom->fc_topology == FSF_TOPO_FABRIC)
+			fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
+		else if (bottom->fc_topology == FSF_TOPO_AL)
+			fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
+		else
+			fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 	} else {
 		fc_host_node_name(shost) = 0;
 		fc_host_port_name(shost) = 0;
 		fc_host_port_id(shost) = 0;
 		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
-		adapter->fc_topology = 0;
+		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 		adapter->hydra_version = 0;
 	}
 
-	if (adapter->fc_topology == FSF_TOPO_P2P) {
-		adapter->peer_d_id = bottom->peer_d_id & ZFCP_DID_MASK;
-		adapter->peer_wwpn = bottom->plogi_payload.wwpn;
-		adapter->peer_wwnn = bottom->plogi_payload.wwnn;
-	}
-
 	if (adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT) {
 		adapter->hardware_version = bottom->hardware_version;
 		memcpy(fc_host_serial_number(shost), bottom->serial_number,
@@ -2132,8 +2135,8 @@ zfcp_fsf_exchange_config_data_handler(st
 		if (zfcp_fsf_exchange_config_evaluate(fsf_req, 1))
 			return -EIO;
 
-		switch (adapter->fc_topology) {
-		case FSF_TOPO_P2P:
+		switch (fc_host_port_type(adapter->scsi_host)) {
+		case FC_PORTTYPE_PTP:
 			ZFCP_LOG_NORMAL("Point-to-Point fibrechannel "
 					"configuration detected at adapter %s\n"
 					"Peer WWNN 0x%016llx, "
@@ -2146,7 +2149,7 @@ zfcp_fsf_exchange_config_data_handler(st
 			debug_text_event(fsf_req->adapter->erp_dbf, 0,
 					 "top-p-to-p");
 			break;
-		case FSF_TOPO_AL:
+		case FC_PORTTYPE_NLPORT:
 			ZFCP_LOG_NORMAL("error: Arbitrated loop fibrechannel "
 					"topology detected at adapter %s "
 					"unsupported, shutting down adapter\n",
@@ -2155,7 +2158,7 @@ zfcp_fsf_exchange_config_data_handler(st
 					 "top-al");
 			zfcp_erp_adapter_shutdown(adapter, 0);
 			return -EIO;
-		case FSF_TOPO_FABRIC:
+		case FC_PORTTYPE_NPORT:
 			ZFCP_LOG_NORMAL("Switched fabric fibrechannel "
 				      "network detected at adapter %s.\n",
 				      zfcp_get_busid_by_adapter(adapter));
@@ -2168,7 +2171,6 @@ zfcp_fsf_exchange_config_data_handler(st
 					"of a type known to the zfcp "
 					"driver, shutting down adapter\n",
 					zfcp_get_busid_by_adapter(adapter));
-			adapter->fc_topology = FSF_TOPO_ERROR;
 			debug_text_exception(fsf_req->adapter->erp_dbf, 0,
 					     "unknown-topo");
 			zfcp_erp_adapter_shutdown(adapter, 0);
@@ -2328,14 +2330,13 @@ zfcp_fsf_exchange_port_data_handler(stru
 		data = (struct fsf_qtcb_bottom_port*) fsf_req->data;
 		if (data)
 			memcpy(data, bottom, sizeof(struct fsf_qtcb_bottom_port));
-		if (adapter->connection_features & FSF_FEATURE_NPIV_MODE) {
-			adapter->physical_wwpn = bottom->wwpn;
-			adapter->physical_s_id = bottom->fc_port_id;
-		} else {
-			adapter->physical_wwpn = fc_host_port_name(shost);
-			adapter->physical_s_id = fc_host_port_id(shost);
-		}
+		if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
+			fc_host_permanent_port_name(shost) = bottom->wwpn;
+		else
+			fc_host_permanent_port_name(shost) =
+				fc_host_port_name(shost);
 		fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
+		fc_host_supported_speeds(shost) = bottom->supported_speed;
 		break;
 
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 39475db..e734415 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -199,7 +199,6 @@
 #define FSF_TOPO_P2P				0x00000001
 #define FSF_TOPO_FABRIC				0x00000002
 #define FSF_TOPO_AL				0x00000003
-#define FSF_TOPO_FABRIC_VIRT			0x00000004
 
 /* data direction for FCP commands */
 #define FSF_DATADIR_WRITE			0x00000001
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 5ca0992..3c2cbcc 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -865,13 +865,16 @@ struct fc_function_template zfcp_transpo
 	.show_rport_supported_classes = 1,
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
+	.show_host_permanent_port_name = 1,
 	.show_host_supported_classes = 1,
+	.show_host_supported_speeds = 1,
 	.show_host_maxframe_size = 1,
 	.show_host_serial_number = 1,
 	.get_fc_host_stats = zfcp_get_fc_host_stats,
 	.reset_fc_host_stats = zfcp_reset_fc_host_stats,
 	/* no functions registered for following dynamic attributes but
 	   directly set by LLDD */
+	.show_host_port_type = 1,
 	.show_host_speed = 1,
 	.show_host_port_id = 1,
 };
diff --git a/drivers/s390/scsi/zfcp_sysfs_adapter.c b/drivers/s390/scsi/zfcp_sysfs_adapter.c
index c85df9c..9f26225 100644
--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c
+++ b/drivers/s390/scsi/zfcp_sysfs_adapter.c
@@ -33,14 +33,6 @@
 
 #define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_CONFIG
 
-static const char fc_topologies[5][25] = {
-	"<error>",
-	"point-to-point",
-	"fabric",
-	"arbitrated loop",
-	"fabric (virt. adapter)"
-};
-
 /**
  * ZFCP_DEFINE_ADAPTER_ATTR
  * @_name:   name of show attribute
@@ -69,8 +61,6 @@ ZFCP_DEFINE_ADAPTER_ATTR(physical_wwpn, 
 ZFCP_DEFINE_ADAPTER_ATTR(physical_s_id, "0x%06x\n", adapter->physical_s_id);
 ZFCP_DEFINE_ADAPTER_ATTR(card_version, "0x%04x\n", adapter->hydra_version);
 ZFCP_DEFINE_ADAPTER_ATTR(lic_version, "0x%08x\n", adapter->fsf_lic_version);
-ZFCP_DEFINE_ADAPTER_ATTR(fc_topology, "%s\n",
-			 fc_topologies[adapter->fc_topology]);
 ZFCP_DEFINE_ADAPTER_ATTR(hardware_version, "0x%08x\n",
 			 adapter->hardware_version);
 ZFCP_DEFINE_ADAPTER_ATTR(in_recovery, "%d\n", atomic_test_mask
@@ -257,7 +247,6 @@ static struct attribute *zfcp_adapter_at
 	&dev_attr_physical_s_id.attr,
 	&dev_attr_card_version.attr,
 	&dev_attr_lic_version.attr,
-	&dev_attr_fc_topology.attr,
 	&dev_attr_status.attr,
 	&dev_attr_hardware_version.attr,
 	NULL
-- 
0.99.9n-g5a22
