From: michaelc@cs.wisc.edu
Subject: [PATCH 3/5] qla2xxx: prep for fc host dev loss tmo support
Date: Wed, 15 Sep 2010 16:52:30 -0500
Message-ID: <1284587552-7617-4-git-send-email-michaelc@cs.wisc.edu>
References: <1284587552-7617-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab0IOVrM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 17:47:12 -0400
In-Reply-To: <1284587552-7617-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This removes the driver's get_host_def_dev_loss_tmo
callback and just has the driver set the dev loss
using the fc class fc_host_dev_loss_tmo macro like is
done for other fc params.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index c978105..029fe6b 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1530,15 +1530,6 @@ qla2x00_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 }
 
 static void
-qla2x00_get_host_def_loss_tmo(struct Scsi_Host *shost)
-{
-	scsi_qla_host_t *vha = shost_priv(shost);
-	struct qla_hw_data *ha = vha->hw;
-
-	fc_host_def_dev_loss_tmo(shost) = ha->port_down_retry_count;
-}
-
-static void
 qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 {
 	struct Scsi_Host *host = rport_to_shost(rport);
@@ -1785,6 +1776,7 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 	}
 
 	/* initialize attributes */
+	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
 	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
 	fc_host_port_name(vha->host) = wwn_to_u64(vha->port_name);
 	fc_host_supported_classes(vha->host) =
@@ -1912,7 +1904,6 @@ struct fc_function_template qla2xxx_transport_functions = {
 	.show_host_fabric_name = 1,
 	.get_host_port_state = qla2x00_get_host_port_state,
 	.show_host_port_state = 1,
-	.get_host_def_dev_loss_tmo = qla2x00_get_host_def_loss_tmo,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
 	.show_rport_supported_classes = 1,
@@ -1959,7 +1950,6 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.show_host_fabric_name = 1,
 	.get_host_port_state = qla2x00_get_host_port_state,
 	.show_host_port_state = 1,
-	.get_host_def_dev_loss_tmo = qla2x00_get_host_def_loss_tmo,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
 	.show_rport_supported_classes = 1,
@@ -1988,6 +1978,7 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	u32 speed = FC_PORTSPEED_UNKNOWN;
 
+	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
 	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
 	fc_host_port_name(vha->host) = wwn_to_u64(vha->port_name);
 	fc_host_supported_classes(vha->host) = FC_COS_CLASS3;
-- 
1.7.2.2

