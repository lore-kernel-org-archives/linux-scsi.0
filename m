From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 06/42] qla2xxx: Log when device state is moved to failed state.
Date: Fri, 11 Apr 2014 16:54:11 -0400
Message-ID: <1397249687-32666-7-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:18001 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbaDKVc2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:28 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 86cf108..e381835 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -1655,6 +1655,19 @@ qla8044_set_drv_active(struct scsi_qla_host *vha)
 	qla8044_wr_direct(vha, QLA8044_CRB_DRV_ACTIVE_INDEX, drv_active);
 }
 
+static int
+qla8044_check_drv_active(struct scsi_qla_host *vha)
+{
+	uint32_t drv_active;
+	struct qla_hw_data *ha = vha->hw;
+
+	drv_active = qla8044_rd_direct(vha, QLA8044_CRB_DRV_ACTIVE_INDEX);
+	if (drv_active & (1 << ha->portnum))
+		return QLA_SUCCESS;
+	else
+		return QLA_TEST_FAILED;
+}
+
 static void
 qla8044_clear_idc_dontreset(struct scsi_qla_host *vha)
 {
@@ -1837,14 +1850,16 @@ qla8044_device_state_handler(struct scsi_qla_host *vha)
 
 	while (1) {
 		if (time_after_eq(jiffies, dev_init_timeout)) {
-			ql_log(ql_log_warn, vha, 0xb0cf,
-			    "%s: Device Init Failed 0x%x = %s\n",
-			    QLA2XXX_DRIVER_NAME, dev_state,
-			    dev_state < MAX_STATES ?
-			    qdev_state(dev_state) : "Unknown");
-
-			qla8044_wr_direct(vha, QLA8044_CRB_DEV_STATE_INDEX,
-			    QLA8XXX_DEV_FAILED);
+			if (qla8044_check_drv_active(vha) == QLA_SUCCESS) {
+				ql_log(ql_log_warn, vha, 0xb0cf,
+				    "%s: Device Init Failed 0x%x = %s\n",
+				    QLA2XXX_DRIVER_NAME, dev_state,
+				    dev_state < MAX_STATES ?
+				    qdev_state(dev_state) : "Unknown");
+				qla8044_wr_direct(vha,
+				    QLA8044_CRB_DEV_STATE_INDEX,
+				    QLA8XXX_DEV_FAILED);
+			}
 		}
 
 		dev_state = qla8044_rd_direct(vha, QLA8044_CRB_DEV_STATE_INDEX);
-- 
1.7.7

