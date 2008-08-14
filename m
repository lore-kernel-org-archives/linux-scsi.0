From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/2] qla2xxx: Set an rport's dev_loss_tmo value in a
	consistent manner.
Date: Thu, 14 Aug 2008 09:39:35 -0700
Message-ID: <20080814163935.GD75223@plap4-2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:17269 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYHNQji (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 12:39:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stable@kernel.org
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

[ Upstream commit 85821c906cf3563a00a3d98fa380a2581a7a5ff1 ]

As there's no point in adding a fixed-fudge value (originally 5
seconds), honor the user settings only.  We also remove the
driver's dead-callback get_rport_dev_loss_tmo function
(qla2x00_get_rport_loss_tmo()).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---

        Infrastructure patch needed to address issue noted in this thread:
        http://article.gmane.org/gmane.linux.scsi/43723

        Final (corrective patch to be CCd to stable through the
        scsi-rc-fixes-2.6 tree.

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3112518..8728e87 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -972,26 +972,12 @@ qla2x00_get_starget_port_id(struct scsi_target *starget)
 }
 
 static void
-qla2x00_get_rport_loss_tmo(struct fc_rport *rport)
-{
-	struct Scsi_Host *host = rport_to_shost(rport);
-	scsi_qla_host_t *ha = shost_priv(host);
-
-	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
-}
-
-static void
 qla2x00_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
-	struct Scsi_Host *host = rport_to_shost(rport);
-	scsi_qla_host_t *ha = shost_priv(host);
-
 	if (timeout)
-		ha->port_down_retry_count = timeout;
+		rport->dev_loss_tmo = timeout;
 	else
-		ha->port_down_retry_count = 1;
-
-	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
+		rport->dev_loss_tmo = 1;
 }
 
 static void
@@ -1275,7 +1261,6 @@ struct fc_function_template qla2xxx_transport_functions = {
 	.get_starget_port_id  = qla2x00_get_starget_port_id,
 	.show_starget_port_id = 1,
 
-	.get_rport_dev_loss_tmo = qla2x00_get_rport_loss_tmo,
 	.set_rport_dev_loss_tmo = qla2x00_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
@@ -1320,7 +1305,6 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.get_starget_port_id  = qla2x00_get_starget_port_id,
 	.show_starget_port_id = 1,
 
-	.get_rport_dev_loss_tmo = qla2x00_get_rport_loss_tmo,
 	.set_rport_dev_loss_tmo = qla2x00_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c5ad858..047ee64 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1107,7 +1107,7 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 	else
 		scsi_deactivate_tcq(sdev, ha->max_q_depth);
 
-	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
+	rport->dev_loss_tmo = ha->port_down_retry_count;
 
 	return 0;
 }
-- 
1.6.0.rc2.22.g71b9

