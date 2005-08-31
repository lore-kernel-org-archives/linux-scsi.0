From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/3] qla2xxx: use wwn_to_u64() transport helper
Date: Wed, 31 Aug 2005 15:21:20 -0700
Message-ID: <20050831222120.GJ11577@plap.qlogic.org>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com> <20050827020950.27275.51550.sendpatchset@plap.qlogic.com> <20050827104053.GA21026@infradead.org> <20050831221835.GI11577@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:7131 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S964942AbVHaWVZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 18:21:25 -0400
Content-Disposition: inline
In-Reply-To: <20050831221835.GI11577@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, "Smart, James" <James.Smart@emulex.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com> 
---

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -360,16 +360,16 @@ qla2x00_get_starget_node_name(struct scs
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
@@ -378,16 +378,16 @@ qla2x00_get_starget_port_name(struct scs
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
@@ -460,9 +460,7 @@ struct fc_function_template qla2xxx_tran
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
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2070,8 +2070,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 		return;
 	}
 
-	rport_ids.node_name = be64_to_cpu(*(uint64_t *)fcport->node_name);
-	rport_ids.port_name = be64_to_cpu(*(uint64_t *)fcport->port_name);
+	rport_ids.node_name = wwn_to_u64(fcport->node_name);
+	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
 	    fcport->d_id.b.area << 8 | fcport->d_id.b.al_pa;
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
