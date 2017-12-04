From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 21/22] qla2xxx: Fix memory leak in dual/target mode
Date: Mon, 4 Dec 2017 14:45:16 -0800
Message-ID: <20171204224517.3409-22-himanshu.madhani@cavium.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0040.outbound.protection.outlook.com ([104.47.38.40]:41602
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752149AbdLDWqH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 17:46:07 -0500
In-Reply-To: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

When driver is loaded in Target/Dual mode, it creates QPair
to support MQ and allocates resources for each QPair. This Qpair
initialization is delayed until the FW personality is changed to
Dual/Target mode by issuing chip reset. At the time of chip reset
firmware is re-initilized in correct personality all the QPairs
are initialized by sending MBC_INITIALIZE_MULTIQ (001Fh).

This patch fixes memory leak by adding check to issue
MBC_INITIALIZE_MULTIQ command only while deleting rsp/req queue
when the flag is set for initiator mode, and clean up QPair resources
correctly during the driver unload. This MBX does not need to be
issued for Target/Dual mode because chip reset will reset ISP.

Fixes: d65237c7f0860 ("scsi: qla2xxx: Fix mailbox failure while deleting Queue pairs")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla2xxx/qla_init.c |  4 +---
 drivers/scsi/qla2xxx/qla_mid.c  | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 57b8f43c5980..58663df38627 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8220,9 +8220,6 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
 	int ret = QLA_FUNCTION_FAILED;
 	struct qla_hw_data *ha = qpair->hw;
 
-	if (!vha->flags.qpairs_req_created && !vha->flags.qpairs_rsp_created)
-		goto fail;
-
 	qpair->delete_in_progress = 1;
 	while (atomic_read(&qpair->ref_count))
 		msleep(500);
@@ -8230,6 +8227,7 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
 	ret = qla25xx_delete_req_que(vha, qpair->req);
 	if (ret != QLA_SUCCESS)
 		goto fail;
+
 	ret = qla25xx_delete_rsp_que(vha, qpair->rsp);
 	if (ret != QLA_SUCCESS)
 		goto fail;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 618ca272d01a..e538e6308885 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -575,14 +575,15 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 int
 qla25xx_delete_req_que(struct scsi_qla_host *vha, struct req_que *req)
 {
-	int ret = -1;
+	int ret = QLA_SUCCESS;
 
-	if (req) {
+	if (req && vha->flags.qpairs_req_created) {
 		req->options |= BIT_0;
 		ret = qla25xx_init_req_que(vha, req);
+		if (ret != QLA_SUCCESS)
+			return QLA_FUNCTION_FAILED;
 	}
-	if (ret == QLA_SUCCESS)
-		qla25xx_free_req_que(vha, req);
+	qla25xx_free_req_que(vha, req);
 
 	return ret;
 }
@@ -590,14 +591,15 @@ qla25xx_delete_req_que(struct scsi_qla_host *vha, struct req_que *req)
 int
 qla25xx_delete_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
-	int ret = -1;
+	int ret = QLA_SUCCESS;
 
-	if (rsp) {
+	if (rsp && vha->flags.qpairs_rsp_created) {
 		rsp->options |= BIT_0;
 		ret = qla25xx_init_rsp_que(vha, rsp);
+		if (ret != QLA_SUCCESS)
+			return QLA_FUNCTION_FAILED;
 	}
-	if (ret == QLA_SUCCESS)
-		qla25xx_free_rsp_que(vha, rsp);
+	qla25xx_free_rsp_que(vha, rsp);
 
 	return ret;
 }
-- 
2.12.0
