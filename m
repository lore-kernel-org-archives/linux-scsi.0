From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/16] qla2xxx: Generalize WWN to u64 interger conversions.
Date: Fri, 26 Aug 2005 19:09:50 -0700 (PDT)
Message-ID: <20050827020950.27275.51550.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:21608 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751621AbVH0CJv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:09:51 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Generalize WWN to u64 interger conversions.

On some platforms the hard-casting of the 8 byte node_name
and port_name arrays to an u64 would cause unaligned-access
warnings.  Generalize the conversions with consistent
shifting of WWN bytes.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_attr.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

c7a5df1dc950e8a1cc04aa9a184619dfc78e5ed6
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -345,6 +345,15 @@ struct class_device_attribute *qla2x00_h
 
 /* Host attributes. */
 
+static u64
+wwn_to_u64(uint8_t *wwn)
+{
+	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
+	    (u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
+	    (u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
+	    (u64)wwn[6] <<  8 | (u64)wwn[7];
+}
+
 static void
 qla2x00_get_host_port_id(struct Scsi_Host *shost)
 {
@@ -360,16 +369,16 @@ qla2x00_get_starget_node_name(struct scs
 	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
 	scsi_qla_host_t *ha = to_qla_host(host);
 	fc_port_t *fcport;
-	uint64_t node_name = 0;
+	u64 node_name = 0;
 
 	list_for_each_entry(fcport, &ha->fcports, list) {
 		if (starget->id == fcport->os_target_id) {
-			node_name = *(uint64_t *)fcport->node_name;
+			node_name = wwn_to_u64(fcport->node_name);
 			break;
 		}
 	}
 
-	fc_starget_node_name(starget) = be64_to_cpu(node_name);
+	fc_starget_node_name(starget) = node_name;
 }
 
 static void
@@ -378,16 +387,16 @@ qla2x00_get_starget_port_name(struct scs
 	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
 	scsi_qla_host_t *ha = to_qla_host(host);
 	fc_port_t *fcport;
-	uint64_t port_name = 0;
+	u64 port_name = 0;
 
 	list_for_each_entry(fcport, &ha->fcports, list) {
 		if (starget->id == fcport->os_target_id) {
-			port_name = *(uint64_t *)fcport->port_name;
+			port_name = wwn_to_u64(fcport->port_name);
 			break;
 		}
 	}
 
-	fc_starget_port_name(starget) = be64_to_cpu(port_name);
+	fc_starget_port_name(starget) = port_name;
 }
 
 static void
@@ -460,9 +469,7 @@ struct fc_function_template qla2xxx_tran
 void
 qla2x00_init_host_attr(scsi_qla_host_t *ha)
 {
-	fc_host_node_name(ha->host) =
-	    be64_to_cpu(*(uint64_t *)ha->init_cb->node_name);
-	fc_host_port_name(ha->host) =
-	    be64_to_cpu(*(uint64_t *)ha->init_cb->port_name);
+	fc_host_node_name(ha->host) = wwn_to_u64(ha->init_cb->node_name);
+	fc_host_port_name(ha->host) = wwn_to_u64(ha->init_cb->port_name);
 	fc_host_supported_classes(ha->host) = FC_COS_CLASS3;
 }

-- 
Andrew Vasquez
