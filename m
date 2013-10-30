From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 06/22] qla2xxx: Don't consider the drivers knocked out of IDC participation for future reset recovery process.
Date: Wed, 30 Oct 2013 03:38:13 -0400
Message-ID: <1383118709-5569-7-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.156.153] ([67.231.156.153]:12726 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753014Ab3J3ILZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:25 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 8164cc9..6f509f8 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -1555,6 +1555,15 @@ qla8044_need_reset_handler(struct scsi_qla_host *vha)
 		qla8044_idc_lock(ha);
 	}
 
+	drv_state = qla8044_rd_direct(vha,
+	    QLA8044_CRB_DRV_STATE_INDEX);
+	drv_active = qla8044_rd_direct(vha,
+	    QLA8044_CRB_DRV_ACTIVE_INDEX);
+
+	ql_log(ql_log_info, vha, 0xb0c5,
+	    "%s(%ld): drv_state = 0x%x, drv_active = 0x%x\n",
+	    __func__, vha->host_no, drv_state, drv_active);
+
 	if (!ha->flags.nic_core_reset_owner) {
 		ql_dbg(ql_dbg_p3p, vha, 0xb0c3,
 		    "%s(%ld): reset acknowledged\n",
@@ -1580,23 +1589,15 @@ qla8044_need_reset_handler(struct scsi_qla_host *vha)
 
 			dev_state = qla8044_rd_direct(vha,
 					QLA8044_CRB_DEV_STATE_INDEX);
-		} while (dev_state == QLA8XXX_DEV_NEED_RESET);
+		} while (((drv_state & drv_active) != drv_active) &&
+		    (dev_state == QLA8XXX_DEV_NEED_RESET));
 	} else {
 		qla8044_set_rst_ready(vha);
 
 		/* wait for 10 seconds for reset ack from all functions */
 		reset_timeout = jiffies + (ha->fcoe_reset_timeout * HZ);
 
-		drv_state = qla8044_rd_direct(vha,
-		    QLA8044_CRB_DRV_STATE_INDEX);
-		drv_active = qla8044_rd_direct(vha,
-		    QLA8044_CRB_DRV_ACTIVE_INDEX);
-
-		ql_log(ql_log_info, vha, 0xb0c5,
-		    "%s(%ld): drv_state = 0x%x, drv_active = 0x%x\n",
-		    __func__, vha->host_no, drv_state, drv_active);
-
-		while (drv_state != drv_active) {
+		while ((drv_state & drv_active) != drv_active) {
 			if (time_after_eq(jiffies, reset_timeout)) {
 				ql_log(ql_log_info, vha, 0xb0c6,
 				    "%s: RESET TIMEOUT!"
-- 
1.7.7

