From: michaelc@cs.wisc.edu
Subject: [PATCH 2/5] qla2xxx: do not reset dev_loss_tmo in slave callout
Date: Fri,  6 Aug 2010 03:02:38 -0500
Message-ID: <1281081761-24586-3-git-send-email-michaelc@cs.wisc.edu>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu>
 <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760545Ab0HFH6m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 03:58:42 -0400
In-Reply-To: <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jeykholt@cisco.com, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, James.Smart@Emulex.Com, brking@us.ibm.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This fixes a bug where the driver was resetting the
rport dev_loss_tmo when devices were added by adding
support for the get_host_def_dev_loss_tmo callout.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla2xxx/qla_attr.c |   11 +++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    5 -----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 420238c..679a432 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1530,6 +1530,15 @@ qla2x00_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 }
 
 static void
+qla2x00_get_host_def_loss_tmo(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *vha = shost_priv(shost);
+	struct qla_hw_data *ha = vha->hw;
+
+	fc_host_def_dev_loss_tmo(shost) = ha->port_down_retry_count;
+}
+
+static void
 qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 {
 	struct Scsi_Host *host = rport_to_shost(rport);
@@ -1903,6 +1912,7 @@ struct fc_function_template qla2xxx_transport_functions = {
 	.show_host_fabric_name = 1,
 	.get_host_port_state = qla2x00_get_host_port_state,
 	.show_host_port_state = 1,
+	.get_host_def_dev_loss_tmo = qla2x00_get_host_def_loss_tmo,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
 	.show_rport_supported_classes = 1,
@@ -1949,6 +1959,7 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.show_host_fabric_name = 1,
 	.get_host_port_state = qla2x00_get_host_port_state,
 	.show_host_port_state = 1,
+	.get_host_def_dev_loss_tmo = qla2x00_get_host_def_loss_tmo,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
 	.show_rport_supported_classes = 1,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ff2172d..61e6aac 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1295,17 +1295,12 @@ static int
 qla2xxx_slave_configure(struct scsi_device *sdev)
 {
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
-	struct qla_hw_data *ha = vha->hw;
-	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
 	struct req_que *req = vha->req;
 
 	if (sdev->tagged_supported)
 		scsi_activate_tcq(sdev, req->max_q_depth);
 	else
 		scsi_deactivate_tcq(sdev, req->max_q_depth);
-
-	rport->dev_loss_tmo = ha->port_down_retry_count;
-
 	return 0;
 }
 
-- 
1.6.6.1

