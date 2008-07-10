From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/18] qla2xxx: Set an rport's dev_loss_tmo value in a consistent manner.
Date: Thu, 10 Jul 2008 16:55:48 -0700
Message-ID: <1215734163-40825-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbYGJX4H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:07 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

As there's no point in adding a fixed-fudge value (originally 5
seconds), honor the user settings only.  We also remove the
driver's dead-callback get_rport_dev_loss_tmo function
(qla2x00_get_rport_loss_tmo()).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   20 ++------------------
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index f2fa373..2a3bc35 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -947,26 +947,12 @@ qla2x00_get_starget_port_id(struct scsi_target *starget)
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
@@ -1250,7 +1236,6 @@ struct fc_function_template qla2xxx_transport_functions = {
 	.get_starget_port_id  = qla2x00_get_starget_port_id,
 	.show_starget_port_id = 1,
 
-	.get_rport_dev_loss_tmo = qla2x00_get_rport_loss_tmo,
 	.set_rport_dev_loss_tmo = qla2x00_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
@@ -1295,7 +1280,6 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
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
1.5.6.2.292.ga9a3

