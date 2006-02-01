From: andrew.vasquez@qlogic.com
Subject: [PATCH 2/6] qla2xxx: Add host port-type FC transport attribute.
Date: Tue, 31 Jan 2006 16:04:56 -0800
Message-ID: <11387522913809-git-send-email-andrew.vasquez@qlogic.com>
References: <20060201000146.GA4456@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:44226 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751129AbWBAAE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 19:04:57 -0500
In-Reply-To: <20060201000146.GA4456@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_attr.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

27403854d2fe07eee382d04b1a5d0b9c342561e7
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e03140f..5501632 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -446,6 +446,29 @@ qla2x00_get_host_speed(struct Scsi_Host 
 }
 
 static void
+qla2x00_get_host_port_type(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = to_qla_host(shost);
+	uint32_t port_type = FC_PORTTYPE_UNKNOWN;
+
+	switch (ha->current_topology) {
+	case ISP_CFG_NL:
+		port_type = FC_PORTTYPE_LPORT;
+		break;
+	case ISP_CFG_FL:
+		port_type = FC_PORTTYPE_NLPORT;
+		break;
+	case ISP_CFG_N:
+		port_type = FC_PORTTYPE_PTP;
+		break;
+	case ISP_CFG_F:
+		port_type = FC_PORTTYPE_NPORT;
+		break;
+	}
+	fc_host_port_type(shost) = port_type;
+}
+
+static void
 qla2x00_get_starget_node_name(struct scsi_target *starget)
 {
 	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
@@ -542,6 +565,8 @@ struct fc_function_template qla2xxx_tran
 	.show_host_port_id = 1,
 	.get_host_speed = qla2x00_get_host_speed,
 	.show_host_speed = 1,
+	.get_host_port_type = qla2x00_get_host_port_type,
+	.show_host_port_type = 1,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
 	.show_rport_supported_classes = 1,
-- 
1.1.6.g1506


