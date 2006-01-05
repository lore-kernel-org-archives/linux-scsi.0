From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] zfcp: use fc_host attributes physical_port_name and physical_port_id
Date: Thu, 5 Jan 2006 10:05:28 +0100
Message-ID: <20060105090528.GA11219@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:54671 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750723AbWAEJFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2006 04:05:44 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id k0595fg7204852
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 09:05:42 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0595W7M137496
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 10:05:32 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k0595Wwn020483
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 10:05:32 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

From: Andreas Herrmann <aherrman@de.ibm.com>

(This patch makes sense only if the previous patch of adding
physical_port_name and physical_port_id to fc transport is
accepted.)

[PATCH] zfcp: use fc_host attributes physical_port_name and physical_port_id

Make use of fc_host attributes physical_port_name and
physical_port_id instead of using zfcp specific attributes.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/s390/scsi/zfcp_def.h           |    2 --
 drivers/s390/scsi/zfcp_fsf.c           |   20 ++++++++++++--------
 drivers/s390/scsi/zfcp_scsi.c          |    2 ++
 drivers/s390/scsi/zfcp_sysfs_adapter.c |    4 ----
 4 files changed, 14 insertions(+), 14 deletions(-)

a74bf07f0b9b8c5c304b2e52cf03f4007e56e86b
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 3785b3c..31abc23 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -917,8 +917,6 @@ struct zfcp_adapter {
 	wwn_t			peer_wwnn;	   /* P2P peer WWNN */
 	wwn_t			peer_wwpn;	   /* P2P peer WWPN */
 	u32			peer_d_id;	   /* P2P peer D_ID */
-	wwn_t			physical_wwpn;     /* WWPN of physical port */
-	u32			physical_s_id;     /* local FC port ID */
 	struct ccw_device       *ccw_device;	   /* S/390 ccw device */
 	u8			fc_service_class;
 	u32			fc_topology;	   /* FC topology */
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index bf859c9..25370db 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2045,10 +2045,12 @@ zfcp_fsf_exchange_config_evaluate(struct
 		fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
 		adapter->fc_topology = bottom->fc_topology;
 		adapter->hydra_version = bottom->adapter_type;
-		if (adapter->physical_wwpn == 0)
-			adapter->physical_wwpn = fc_host_port_name(shost);
-		if (adapter->physical_s_id == 0)
-			adapter->physical_s_id = fc_host_port_id(shost);
+		if (fc_host_physical_port_name(shost) == -1)
+			fc_host_physical_port_name(shost) =
+				fc_host_port_name(shost);
+		if (fc_host_physical_port_id(shost) == -1)
+			fc_host_physical_port_id(shost) =
+				fc_host_port_id(shost);
 	} else {
 		fc_host_node_name(shost) = 0;
 		fc_host_port_name(shost) = 0;
@@ -2329,11 +2331,13 @@ zfcp_fsf_exchange_port_data_handler(stru
 		if (data)
 			memcpy(data, bottom, sizeof(struct fsf_qtcb_bottom_port));
 		if (adapter->connection_features & FSF_FEATURE_NPIV_MODE) {
-			adapter->physical_wwpn = bottom->wwpn;
-			adapter->physical_s_id = bottom->fc_port_id;
+			fc_host_physical_port_name(shost) = bottom->wwpn;
+			fc_host_physical_port_id(shost) = bottom->fc_port_id;
 		} else {
-			adapter->physical_wwpn = fc_host_port_name(shost);
-			adapter->physical_s_id = fc_host_port_id(shost);
+			fc_host_physical_port_name(shost) =
+				fc_host_port_name(shost);
+			fc_host_physical_port_id(shost) =
+				fc_host_port_id(shost);
 		}
 		fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
 		break;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 5ca0992..dc3b083 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -865,6 +865,7 @@ struct fc_function_template zfcp_transpo
 	.show_rport_supported_classes = 1,
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
+ 	.show_host_physical_port_name = 1,
 	.show_host_supported_classes = 1,
 	.show_host_maxframe_size = 1,
 	.show_host_serial_number = 1,
@@ -874,6 +875,7 @@ struct fc_function_template zfcp_transpo
 	   directly set by LLDD */
 	.show_host_speed = 1,
 	.show_host_port_id = 1,
+ 	.show_host_physical_port_id = 1,
 };
 
 /**
diff --git a/drivers/s390/scsi/zfcp_sysfs_adapter.c b/drivers/s390/scsi/zfcp_sysfs_adapter.c
index c85df9c..da5b56f 100644
--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c
+++ b/drivers/s390/scsi/zfcp_sysfs_adapter.c
@@ -65,8 +65,6 @@ ZFCP_DEFINE_ADAPTER_ATTR(status, "0x%08x
 ZFCP_DEFINE_ADAPTER_ATTR(peer_wwnn, "0x%016llx\n", adapter->peer_wwnn);
 ZFCP_DEFINE_ADAPTER_ATTR(peer_wwpn, "0x%016llx\n", adapter->peer_wwpn);
 ZFCP_DEFINE_ADAPTER_ATTR(peer_d_id, "0x%06x\n", adapter->peer_d_id);
-ZFCP_DEFINE_ADAPTER_ATTR(physical_wwpn, "0x%016llx\n", adapter->physical_wwpn);
-ZFCP_DEFINE_ADAPTER_ATTR(physical_s_id, "0x%06x\n", adapter->physical_s_id);
 ZFCP_DEFINE_ADAPTER_ATTR(card_version, "0x%04x\n", adapter->hydra_version);
 ZFCP_DEFINE_ADAPTER_ATTR(lic_version, "0x%08x\n", adapter->fsf_lic_version);
 ZFCP_DEFINE_ADAPTER_ATTR(fc_topology, "%s\n",
@@ -253,8 +251,6 @@ static struct attribute *zfcp_adapter_at
 	&dev_attr_peer_wwnn.attr,
 	&dev_attr_peer_wwpn.attr,
 	&dev_attr_peer_d_id.attr,
-	&dev_attr_physical_wwpn.attr,
-	&dev_attr_physical_s_id.attr,
 	&dev_attr_card_version.attr,
 	&dev_attr_lic_version.attr,
 	&dev_attr_fc_topology.attr,
-- 
0.99.9n-g58e3
