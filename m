From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 02/31] qla2xxx: Fix target multiqueue configuration
Date: Wed, 23 Aug 2017 15:04:56 -0700
Message-ID: <20170823220525.3115-3-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0061.outbound.protection.outlook.com ([104.47.34.61]:44352
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751085AbdHWWFd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:33 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Michael Hernandez <michael.hernandez@cavium.com>

Following error will be logged in to message file
while trying to configure target with multiqueue.

"Cmd 0x1f aborted with timeout since ISP Abort is pending"
"qla25xx_init_queues Rsp que: 1 init failed."

Fixes: 82de802ad46e ("scsi: qla2xxx: Preparation for Target MQ.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_isr.c    | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c    | 1 +
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 916f685872aa..d3a51df27b0d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3454,7 +3454,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	}
 
 	/* Enable MSI-X vector for response queue update for queue 0 */
-	if (IS_QLA25XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
 		if (ha->msixbase && ha->mqiobase &&
 		    (ha->max_rsp_queues > 1 || ha->max_req_queues > 1 ||
 		     ql2xmqsupport))
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 1f91b87b6416..234ef442ef5d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -54,6 +54,7 @@ static struct rom_cmd {
 	{ MBC_GET_MEM_OFFLOAD_CNTRL_STAT },
 	{ MBC_GET_RETRY_COUNT },
 	{ MBC_TRACE_CONTROL },
+	{ MBC_INITIALIZE_MULTIQ },
 };
 
 static int is_rom_cmd(uint16_t cmd)
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e101cd3043b9..4e2a64773060 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6796,7 +6796,7 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
-	if  (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
+	if  (IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
 		ISP_ATIO_Q_IN(base_vha) = &ha->mqiobase->isp25mq.atio_q_in;
 		ISP_ATIO_Q_OUT(base_vha) = &ha->mqiobase->isp25mq.atio_q_out;
 	} else {
-- 
2.12.0
