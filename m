From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 10/29] qla2xxx: Handle failure cases during fabric_login
Date: Thu, 9 Feb 2012 11:15:42 -0800
Message-ID: <1328814961-21866-11-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:3207
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758419Ab2BITcY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:24 -0500
Received: from mail164-ch1 (localhost [127.0.0.1])	by
 mail164-ch1-R.bigfish.com (Postfix) with ESMTP id 0A2C0300589	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:32:12 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Make sure that all calls to ha->isp_ops->fabric_login() check the
return value for failure.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    4 ++--
 drivers/scsi/qla2xxx/qla_gs.c   |   22 ++++++++++++++--------
 drivers/scsi/qla2xxx/qla_init.c |   35 ++++++++++++++++++++++++++---------
 3 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index cd278a0..b85ba1e 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,9 +11,9 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x011f       | 0x4b,0xfa      |
+ * | Module Init and Probe        |       0x0120       | 0x4b,0xba,0xfa |
  * | Mailbox commands             |       0x1139       | 0x112c-0x112e  |
- * | Device Discovery             |       0x2084       |                |
+ * | Device Discovery             |       0x2085       | 0x2020-0x2022  |
  * | Queue Command and IO tracing |       0x302f       | 0x3006,0x3008  |
  * |                              |                    | 0x302d-0x302e  |
  * | DPC Thread                   |       0x401c       |		|
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index dd83399..6924303 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1107,20 +1107,26 @@ qla2x00_sns_rnn_id(scsi_qla_host_t *vha)
 static int
 qla2x00_mgmt_svr_login(scsi_qla_host_t *vha)
 {
-	int ret;
+	int ret, rval;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct qla_hw_data *ha = vha->hw;
 	ret = QLA_SUCCESS;
 	if (vha->flags.management_server_logged_in)
 		return ret;
 
-	ha->isp_ops->fabric_login(vha, vha->mgmt_svr_loop_id, 0xff, 0xff, 0xfa,
-	    mb, BIT_1|BIT_0);
-	if (mb[0] != MBS_COMMAND_COMPLETE) {
-		ql_dbg(ql_dbg_disc, vha, 0x2024,
-		    "Failed management_server login: loopid=%x mb[0]=%x "
-		    "mb[1]=%x mb[2]=%x mb[6]=%x mb[7]=%x.\n",
-		    vha->mgmt_svr_loop_id, mb[0], mb[1], mb[2], mb[6], mb[7]);
+	rval = ha->isp_ops->fabric_login(vha, vha->mgmt_svr_loop_id, 0xff, 0xff,
+	    0xfa, mb, BIT_1|BIT_0);
+	if (rval != QLA_SUCCESS || mb[0] != MBS_COMMAND_COMPLETE) {
+		if (rval == QLA_MEMORY_ALLOC_FAILED)
+			ql_dbg(ql_dbg_disc, vha, 0x2085,
+			    "Failed management_server login: loopid=%x "
+			    "rval=%d\n", vha->mgmt_svr_loop_id, rval);
+		else
+			ql_dbg(ql_dbg_disc, vha, 0x2024,
+			    "Failed management_server login: loopid=%x "
+			    "mb[0]=%x mb[1]=%x mb[2]=%x mb[6]=%x mb[7]=%x.\n",
+			    vha->mgmt_svr_loop_id, mb[0], mb[1], mb[2], mb[6],
+			    mb[7]);
 		ret = QLA_FUNCTION_FAILED;
 	} else
 		vha->flags.management_server_logged_in = 1;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ff841d7..abd095c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2949,8 +2949,12 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			loop_id = NPH_SNS;
 		else
 			loop_id = SIMPLE_NAME_SERVER;
-		ha->isp_ops->fabric_login(vha, loop_id, 0xff, 0xff,
-		    0xfc, mb, BIT_1 | BIT_0);
+		rval = ha->isp_ops->fabric_login(vha, loop_id, 0xff, 0xff,
+		    0xfc, mb, BIT_1|BIT_0);
+		if (rval != QLA_SUCCESS) {
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+			return rval;
+		}
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
 			ql_dbg(ql_dbg_disc, vha, 0x2042,
 			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x "
@@ -3487,6 +3491,9 @@ qla2x00_fabric_dev_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 		} else {
 			qla2x00_update_fcport(vha, fcport);
 		}
+	} else {
+		/* Retry Login. */
+		qla2x00_mark_device_lost(vha, fcport, 1, 0);
 	}
 
 	return (rval);
@@ -3527,9 +3534,12 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 		/* Login fcport on switch. */
-		ha->isp_ops->fabric_login(vha, fcport->loop_id,
+		rval = ha->isp_ops->fabric_login(vha, fcport->loop_id,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa, mb, BIT_0);
+		if (rval != QLA_SUCCESS) {
+			return rval;
+		}
 		if (mb[0] == MBS_PORT_ID_USED) {
 			/*
 			 * Device has another loop ID.  The firmware team
@@ -4844,6 +4854,7 @@ int
 qla24xx_configure_vhba(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
+	int rval2;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
@@ -4868,12 +4879,18 @@ qla24xx_configure_vhba(scsi_qla_host_t *vha)
 	vha->flags.management_server_logged_in = 0;
 
 	/* Login to SNS first */
-	ha->isp_ops->fabric_login(vha, NPH_SNS, 0xff, 0xff, 0xfc, mb, BIT_1);
-	if (mb[0] != MBS_COMMAND_COMPLETE) {
-		ql_dbg(ql_dbg_init, vha, 0x0103,
-		    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x "
-		    "mb[6]=%x mb[7]=%x.\n",
-		    NPH_SNS, mb[0], mb[1], mb[2], mb[6], mb[7]);
+	rval2 = ha->isp_ops->fabric_login(vha, NPH_SNS, 0xff, 0xff, 0xfc, mb,
+	    BIT_1);
+	if (rval2 != QLA_SUCCESS || mb[0] != MBS_COMMAND_COMPLETE) {
+		if (rval2 == QLA_MEMORY_ALLOC_FAILED)
+			ql_dbg(ql_dbg_init, vha, 0x0120,
+			    "Failed SNS login: loop_id=%x, rval2=%d\n",
+			    NPH_SNS, rval2);
+		else
+			ql_dbg(ql_dbg_init, vha, 0x0103,
+			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x "
+			    "mb[2]=%x mb[6]=%x mb[7]=%x.\n",
+			    NPH_SNS, mb[0], mb[1], mb[2], mb[6], mb[7]);
 		return (QLA_FUNCTION_FAILED);
 	}
 
-- 
1.6.0.2


