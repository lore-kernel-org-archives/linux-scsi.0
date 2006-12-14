From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/9] qla2xxx: Correct reset handling logic.
Date: Wed, 13 Dec 2006 19:20:30 -0800
Message-ID: <11660664332606-git-send-email-andrew.vasquez@qlogic.com>
References: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39867 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbWLNDdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 22:33:47 -0500
In-Reply-To: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

- honor ISP24XX NVRAM settings for lip-reset, full-login-lip, and
  device-reset.
- correct LIP_FULL_LOGIN mailbox command issuance.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    8 +++--
 drivers/scsi/qla2xxx/qla_mbx.c  |   10 +++---
 drivers/scsi/qla2xxx/qla_os.c   |   55 ++++++++++++++++++++-------------------
 3 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bd32848..b3dac26 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3476,9 +3476,11 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 
 	/* Set host adapter parameters. */
 	ha->flags.disable_risc_code_load = 0;
-	ha->flags.enable_lip_reset = 1;
-	ha->flags.enable_lip_full_login = 1;
-	ha->flags.enable_target_reset = 1;
+	ha->flags.enable_lip_reset = 0;
+	ha->flags.enable_lip_full_login =
+	    le32_to_cpu(nv->host_p) & BIT_10 ? 1: 0;
+	ha->flags.enable_target_reset =
+	    le32_to_cpu(nv->host_p) & BIT_11 ? 1: 0;
 	ha->flags.enable_led_scheme = 0;
 	ha->flags.disable_serdes = le32_to_cpu(nv->host_p) & BIT_5 ? 1: 0;
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index afe7310..077e578 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1339,9 +1339,9 @@ qla2x00_lip_reset(scsi_qla_host_t *ha)
 
 	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[0] = MBC_LIP_FULL_LOGIN;
-		mcp->mb[1] = BIT_0;
-		mcp->mb[2] = 0xff;
-		mcp->mb[3] = 0;
+		mcp->mb[1] = BIT_6;
+		mcp->mb[2] = 0;
+		mcp->mb[3] = ha->loop_reset_delay;
 		mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	} else {
 		mcp->mb[0] = MBC_LIP_RESET;
@@ -1823,8 +1823,8 @@ qla2x00_full_login_lip(scsi_qla_host_t *ha)
 	    ha->host_no));
 
 	mcp->mb[0] = MBC_LIP_FULL_LOGIN;
-	mcp->mb[1] = 0;
-	mcp->mb[2] = 0xff;
+	mcp->mb[1] = IS_QLA24XX(ha) || IS_QLA54XX(ha) ? BIT_3: 0;
+	mcp->mb[2] = 0;
 	mcp->mb[3] = 0;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 36657fa..d6445ae 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1037,48 +1037,49 @@ eh_host_reset_lock:
 static int
 qla2x00_loop_reset(scsi_qla_host_t *ha)
 {
-	int status = QLA_SUCCESS;
+	int ret;
 	struct fc_port *fcport;
 
+	if (ha->flags.enable_lip_full_login) {
+		ret = qla2x00_full_login_lip(ha);
+		if (ret != QLA_SUCCESS) {
+			DEBUG2_3(printk("%s(%ld): bus_reset failed: "
+			    "full_login_lip=%d.\n", __func__, ha->host_no,
+			    ret));
+		}
+		atomic_set(&ha->loop_state, LOOP_DOWN);
+		atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
+		qla2x00_mark_all_devices_lost(ha, 0);
+		qla2x00_wait_for_loop_ready(ha);
+	}
+
 	if (ha->flags.enable_lip_reset) {
-		status = qla2x00_lip_reset(ha);
+		ret = qla2x00_lip_reset(ha);
+		if (ret != QLA_SUCCESS) {
+			DEBUG2_3(printk("%s(%ld): bus_reset failed: "
+			    "lip_reset=%d.\n", __func__, ha->host_no, ret));
+		}
+		qla2x00_wait_for_loop_ready(ha);
 	}
 
-	if (status == QLA_SUCCESS && ha->flags.enable_target_reset) {
+	if (ha->flags.enable_target_reset) {
 		list_for_each_entry(fcport, &ha->fcports, list) {
 			if (fcport->port_type != FCT_TARGET)
 				continue;
 
-			status = qla2x00_device_reset(ha, fcport);
-			if (status != QLA_SUCCESS)
-				break;
+			ret = qla2x00_device_reset(ha, fcport);
+			if (ret != QLA_SUCCESS) {
+				DEBUG2_3(printk("%s(%ld): bus_reset failed: "
+				    "target_reset=%d d_id=%x.\n", __func__,
+				    ha->host_no, ret, fcport->d_id.b24));
+			}
 		}
 	}
 
-	if (status == QLA_SUCCESS &&
-		((!ha->flags.enable_target_reset &&
-		  !ha->flags.enable_lip_reset) ||
-		ha->flags.enable_lip_full_login)) {
-
-		status = qla2x00_full_login_lip(ha);
-	}
-
 	/* Issue marker command only when we are going to start the I/O */
 	ha->marker_needed = 1;
 
-	if (status) {
-		/* Empty */
-		DEBUG2_3(printk("%s(%ld): **** FAILED ****\n",
-				__func__,
-				ha->host_no));
-	} else {
-		/* Empty */
-		DEBUG3(printk("%s(%ld): exiting normally.\n",
-				__func__,
-				ha->host_no));
-	}
-
-	return(status);
+	return QLA_SUCCESS;
 }
 
 /*
-- 
1.4.4.2.g4cfec

