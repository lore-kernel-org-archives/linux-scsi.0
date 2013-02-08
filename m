From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 10/23] qla2xxx: Extra loopback error handling for ISP83xx.
Date: Fri,  8 Feb 2013 01:57:51 -0500
Message-ID: <1360306684-8286-11-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:34273 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759977Ab3BHHTK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:10 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Add the following error handling for loopback diagnostic mode with ISP83xx:

1. If we do not receive an MBA_DCBX_COMPLETE after our initial set port
configuration command, try to reset the port back into normal operation.
If that fails, take a FCoE dump and then reset the chip.
2. After completing the loopback diagnostic operation, if the reset of the port
back into normal operation fails then reset the port so we take a FCoE dump
and then reset the chip.
3. When we receive an IDC notification and the requested operation is loopback
extend the loop down timer so the link does not appear to down for an
extended period of time.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |  127 +++++++++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_isr.c |   16 ++++-
 2 files changed, 87 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 79babab..5478fff 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -531,6 +531,58 @@ done_unmap_sg:
 done:
 	return rval;
 }
+
+/* Disable loopback mode */
+static inline int
+qla81xx_reset_loopback_mode(scsi_qla_host_t *vha, uint16_t *config,
+    int wait)
+{
+	int ret = 0;
+	int rval = 0;
+	uint16_t new_config[4];
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_QLA81XX(ha) && !IS_QLA8031(ha))
+		goto done_reset_internal;
+
+	memset(new_config, 0 , sizeof(new_config));
+	if ((config[0] & INTERNAL_LOOPBACK_MASK) >> 1 ==
+	    ENABLE_INTERNAL_LOOPBACK ||
+	    (config[0] & INTERNAL_LOOPBACK_MASK) >> 1 ==
+	    ENABLE_EXTERNAL_LOOPBACK) {
+		new_config[0] = config[0] & ~INTERNAL_LOOPBACK_MASK;
+		ql_dbg(ql_dbg_user, vha, 0x70bf, "new_config[0]=%02x\n",
+		    (new_config[0] & INTERNAL_LOOPBACK_MASK));
+		memcpy(&new_config[1], &config[1], sizeof(uint16_t) * 3) ;
+
+		ha->notify_dcbx_comp = wait;
+		ret = qla81xx_set_port_config(vha, new_config);
+		if (ret != QLA_SUCCESS) {
+			ql_log(ql_log_warn, vha, 0x7025,
+			    "Set port config failed.\n");
+			ha->notify_dcbx_comp = 0;
+			rval = -EINVAL;
+			goto done_reset_internal;
+		}
+
+		/* Wait for DCBX complete event */
+		if (wait && !wait_for_completion_timeout(&ha->dcbx_comp,
+			(20 * HZ))) {
+			ql_dbg(ql_dbg_user, vha, 0x7026,
+			    "State change notification not received.\n");
+			ha->notify_dcbx_comp = 0;
+			rval = -EINVAL;
+			goto done_reset_internal;
+		} else
+			ql_dbg(ql_dbg_user, vha, 0x7027,
+			    "State change received.\n");
+
+		ha->notify_dcbx_comp = 0;
+	}
+done_reset_internal:
+	return rval;
+}
+
 /*
  * Set the port configuration to enable the internal or external loopback
  * depending on the loopback mode.
@@ -569,6 +621,15 @@ qla81xx_set_loopback_mode(scsi_qla_host_t *vha, uint16_t *config,
 	if (!wait_for_completion_timeout(&ha->dcbx_comp, (20 * HZ))) {
 		ql_dbg(ql_dbg_user, vha, 0x7022,
 		    "State change notification not received.\n");
+		ret = qla81xx_reset_loopback_mode(vha, new_config, 0);
+		/*
+		 * If the reset of the loopback mode doesn't work take a FCoE
+		 * dump and reset the chip.
+		 */
+		if (ret) {
+			ha->isp_ops->fw_dump(vha, 0);
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		}
 		rval = -EINVAL;
 	} else {
 		if (ha->flags.idc_compl_status) {
@@ -587,57 +648,6 @@ done_set_internal:
 	return rval;
 }
 
-/* Disable loopback mode */
-static inline int
-qla81xx_reset_loopback_mode(scsi_qla_host_t *vha, uint16_t *config,
-    int wait)
-{
-	int ret = 0;
-	int rval = 0;
-	uint16_t new_config[4];
-	struct qla_hw_data *ha = vha->hw;
-
-	if (!IS_QLA81XX(ha) && !IS_QLA8031(ha))
-		goto done_reset_internal;
-
-	memset(new_config, 0 , sizeof(new_config));
-	if ((config[0] & INTERNAL_LOOPBACK_MASK) >> 1 ==
-	    ENABLE_INTERNAL_LOOPBACK ||
-	    (config[0] & INTERNAL_LOOPBACK_MASK) >> 1 ==
-	    ENABLE_EXTERNAL_LOOPBACK) {
-		new_config[0] = config[0] & ~INTERNAL_LOOPBACK_MASK;
-		ql_dbg(ql_dbg_user, vha, 0x70bf, "new_config[0]=%02x\n",
-		    (new_config[0] & INTERNAL_LOOPBACK_MASK));
-		memcpy(&new_config[1], &config[1], sizeof(uint16_t) * 3) ;
-
-		ha->notify_dcbx_comp = wait;
-		ret = qla81xx_set_port_config(vha, new_config);
-		if (ret != QLA_SUCCESS) {
-			ql_log(ql_log_warn, vha, 0x7025,
-			    "Set port config failed.\n");
-			ha->notify_dcbx_comp = 0;
-			rval = -EINVAL;
-			goto done_reset_internal;
-		}
-
-		/* Wait for DCBX complete event */
-		if (wait && !wait_for_completion_timeout(&ha->dcbx_comp,
-			(20 * HZ))) {
-			ql_dbg(ql_dbg_user, vha, 0x7026,
-			    "State change notification not received.\n");
-			ha->notify_dcbx_comp = 0;
-			rval = -EINVAL;
-			goto done_reset_internal;
-		} else
-			ql_dbg(ql_dbg_user, vha, 0x7027,
-			    "State change received.\n");
-
-		ha->notify_dcbx_comp = 0;
-	}
-done_reset_internal:
-	return rval;
-}
-
 static int
 qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 {
@@ -781,11 +791,24 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			rval = qla2x00_loopback_test(vha, &elreq, response);
 
 			if (new_config[0]) {
+				int ret;
+
 				/* Revert back to original port config
 				 * Also clear internal loopback
 				 */
-				qla81xx_reset_loopback_mode(vha,
+				ret = qla81xx_reset_loopback_mode(vha,
 				    new_config, 0);
+				if (ret) {
+					/*
+					 * If the reset of the loopback mode
+					 * doesn't work take FCoE dump and then
+					 * reset the chip.
+					 */
+					ha->isp_ops->fw_dump(vha, 0);
+					set_bit(ISP_ABORT_NEEDED,
+					    &vha->dpc_flags);
+				}
+
 			}
 
 			if (response[0] == MBS_COMMAND_ERROR &&
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 26a3086..9380d96 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -985,13 +985,21 @@ skip_rio:
 		    mb[1], mb[2], mb[3]);
 		break;
 	case MBA_IDC_NOTIFY:
-		/* See if we need to quiesce any I/O */
-		if (IS_QLA8031(vha->hw))
-			if ((mb[2] & 0x7fff) == MBC_PORT_RESET ||
-			    (mb[2] & 0x7fff) == MBC_SET_PORT_CONFIG) {
+		if (IS_QLA8031(vha->hw)) {
+			mb[4] = RD_REG_WORD(&reg24->mailbox4);
+			if (((mb[2] & 0x7fff) == MBC_PORT_RESET ||
+			    (mb[2] & 0x7fff) == MBC_SET_PORT_CONFIG) &&
+			    (mb[4] & INTERNAL_LOOPBACK_MASK) != 0) {
 				set_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags);
+				/*
+				 * Extend loop down timer since port is active.
+				 */
+				if (atomic_read(&vha->loop_state) == LOOP_DOWN)
+					atomic_set(&vha->loop_down_timer,
+					    LOOP_DOWN_TIME);
 				qla2xxx_wake_dpc(vha);
 			}
+		}
 	case MBA_IDC_COMPLETE:
 	case MBA_IDC_TIME_EXT:
 		if (IS_QLA81XX(vha->hw) || IS_QLA8031(vha->hw))
-- 
1.7.7

