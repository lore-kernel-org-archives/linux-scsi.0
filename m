From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 26/29] qla2xxx: Handle device mapping changes due to device logout.
Date: Thu, 9 Feb 2012 11:15:58 -0800
Message-ID: <1328814961-21866-27-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:3207
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758400Ab2BITc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:27 -0500
Received: from mail70-ch1 (localhost [127.0.0.1])	by mail70-ch1-R.bigfish.com
 (Postfix) with ESMTP id 912601A0584	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:13 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

A device logout sent in the delete path of a fcport would clear the
port handle binding inside the firmware. This could lead to queued
work items for the fcport, if any, getting incorrect results. This
patch fixes the issue by checking for device name changes after a
call to get port database.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    8 ++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |   19 +++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2627c87..b946564 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -350,6 +350,13 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 		 * requests.
 		 */
 		rval = qla2x00_get_port_database(vha, fcport, 0);
+		if (rval == QLA_NOT_LOGGED_IN) {
+			fcport->flags &= ~FCF_ASYNC_SENT;
+			fcport->flags |= FCF_LOGIN_NEEDED;
+			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			break;
+		}
+
 		if (rval != QLA_SUCCESS) {
 			qla2x00_post_async_logout_work(vha, fcport, NULL);
 			qla2x00_post_async_login_work(vha, fcport, NULL);
@@ -3318,6 +3325,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 			fcport->flags |= FCF_LOGIN_NEEDED;
 			if (fcport->loop_id != FC_NO_LOOP_ID &&
 			    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
+			    (fcport->flags & FCF_ASYNC_SENT) == 0 &&
 			    fcport->port_type != FCT_INITIATOR &&
 			    fcport->port_type != FCT_BROADCAST) {
 				ha->isp_ops->fabric_logout(vha, fcport->loop_id,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index adc2b14..b4a2339 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1289,6 +1289,7 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		goto gpd_error_out;
 
 	if (IS_FWI2_CAPABLE(ha)) {
+		uint64_t zero = 0;
 		pd24 = (struct port_database_24xx *) pd;
 
 		/* Check for logged in state. */
@@ -1302,6 +1303,14 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 			goto gpd_error_out;
 		}
 
+		if (fcport->loop_id == FC_NO_LOOP_ID ||
+		    (memcmp(fcport->port_name, (uint8_t *)&zero, 8) &&
+		     memcmp(fcport->port_name, pd24->port_name, 8))) {
+			/* We lost the device mid way. */
+			rval = QLA_NOT_LOGGED_IN;
+			goto gpd_error_out;
+		}
+
 		/* Names are little-endian. */
 		memcpy(fcport->node_name, pd24->node_name, WWN_SIZE);
 		memcpy(fcport->port_name, pd24->port_name, WWN_SIZE);
@@ -1318,6 +1327,8 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		else
 			fcport->port_type = FCT_TARGET;
 	} else {
+		uint64_t zero = 0;
+
 		/* Check for logged in state. */
 		if (pd->master_state != PD_STATE_PORT_LOGGED_IN &&
 		    pd->slave_state != PD_STATE_PORT_LOGGED_IN) {
@@ -1330,6 +1341,14 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 			goto gpd_error_out;
 		}
 
+		if (fcport->loop_id == FC_NO_LOOP_ID ||
+		    (memcmp(fcport->port_name, (uint8_t *)&zero, 8) &&
+		     memcmp(fcport->port_name, pd->port_name, 8))) {
+			/* We lost the device mid way. */
+			rval = QLA_NOT_LOGGED_IN;
+			goto gpd_error_out;
+		}
+
 		/* Names are little-endian. */
 		memcpy(fcport->node_name, pd->node_name, WWN_SIZE);
 		memcpy(fcport->port_name, pd->port_name, WWN_SIZE);
-- 
1.6.0.2


