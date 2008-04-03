From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/21] qla2xxx: Add support for host supported speeds FC transport attribute.
Date: Thu,  3 Apr 2008 13:13:14 -0700
Message-ID: <1207253612-15538-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6395 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761671AbYDCUNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:35 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Use generic FC transport #defines for speed values.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 27111b1..aee0322 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -849,20 +849,20 @@ static void
 qla2x00_get_host_speed(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *ha = to_qla_parent(shost_priv(shost));
-	uint32_t speed = 0;
+	u32 speed = FC_PORTSPEED_UNKNOWN;
 
 	switch (ha->link_data_rate) {
 	case PORT_SPEED_1GB:
-		speed = 1;
+		speed = FC_PORTSPEED_1GBIT;
 		break;
 	case PORT_SPEED_2GB:
-		speed = 2;
+		speed = FC_PORTSPEED_2GBIT;
 		break;
 	case PORT_SPEED_4GB:
-		speed = 4;
+		speed = FC_PORTSPEED_4GBIT;
 		break;
 	case PORT_SPEED_8GB:
-		speed = 8;
+		speed = FC_PORTSPEED_8GBIT;
 		break;
 	}
 	fc_host_speed(shost) = speed;
@@ -1196,6 +1196,7 @@ struct fc_function_template qla2xxx_transport_functions = {
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_supported_classes = 1,
+	.show_host_supported_speeds = 1,
 
 	.get_host_port_id = qla2x00_get_host_port_id,
 	.show_host_port_id = 1,
@@ -1276,9 +1277,23 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 void
 qla2x00_init_host_attr(scsi_qla_host_t *ha)
 {
+	u32 speed = FC_PORTSPEED_UNKNOWN;
+
 	fc_host_node_name(ha->host) = wwn_to_u64(ha->node_name);
 	fc_host_port_name(ha->host) = wwn_to_u64(ha->port_name);
 	fc_host_supported_classes(ha->host) = FC_COS_CLASS3;
 	fc_host_max_npiv_vports(ha->host) = ha->max_npiv_vports;;
 	fc_host_npiv_vports_inuse(ha->host) = ha->cur_vport_count;
+
+	if (IS_QLA25XX(ha))
+		speed = FC_PORTSPEED_8GBIT | FC_PORTSPEED_4GBIT |
+		    FC_PORTSPEED_2GBIT | FC_PORTSPEED_1GBIT;
+	else if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		speed = FC_PORTSPEED_4GBIT | FC_PORTSPEED_2GBIT |
+		    FC_PORTSPEED_1GBIT;
+	else if (IS_QLA23XX(ha))
+		speed = FC_PORTSPEED_2GBIT | FC_PORTSPEED_1GBIT;
+	else
+		speed = FC_PORTSPEED_1GBIT;
+	fc_host_supported_speeds(ha->host) = speed;
 }
-- 
1.5.5.rc2

