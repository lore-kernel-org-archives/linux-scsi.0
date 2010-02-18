From: giridhar.malavali@qlogic.com
Subject: [PATCH 3/8] qla2xxx: Correct EH bus-reset handling.
Date: Thu, 18 Feb 2010 08:38:29 -0800
Message-ID: <1266511114-307-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1266511114-307-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:34758 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1758567Ab0BRQik (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 11:38:40 -0500
In-Reply-To: <1266511114-307-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Target-level resets are unlikely to complete if done after the
bus (LIP/OLS/NOS) has been reset.  Perform target-level resets,
if necessary, prior to hitting the bus.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7649005..cdb089c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1095,6 +1095,20 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	struct fc_port *fcport;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (ha->flags.enable_target_reset) {
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->port_type != FCT_TARGET)
+				continue;
+
+			ret = ha->isp_ops->target_reset(fcport, 0, 0);
+			if (ret != QLA_SUCCESS) {
+				DEBUG2_3(printk("%s(%ld): bus_reset failed: "
+				    "target_reset=%d d_id=%x.\n", __func__,
+				    vha->host_no, ret, fcport->d_id.b24));
+			}
+		}
+	}
+
 	if (ha->flags.enable_lip_full_login && !IS_QLA81XX(ha)) {
 		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
@@ -1117,19 +1131,6 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 			qla2x00_wait_for_loop_ready(vha);
 	}
 
-	if (ha->flags.enable_target_reset) {
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->port_type != FCT_TARGET)
-				continue;
-
-			ret = ha->isp_ops->target_reset(fcport, 0, 0);
-			if (ret != QLA_SUCCESS) {
-				DEBUG2_3(printk("%s(%ld): bus_reset failed: "
-				    "target_reset=%d d_id=%x.\n", __func__,
-				    vha->host_no, ret, fcport->d_id.b24));
-			}
-		}
-	}
 	/* Issue marker command only when we are going to start the I/O */
 	vha->marker_needed = 1;
 
-- 
1.6.2.rc1.30.gd43c

