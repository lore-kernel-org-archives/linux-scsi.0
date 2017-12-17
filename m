From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH] qla2xxx: Fix smatch warning in qla25xx_delete_{rsp|req}_que
Date: Sat, 16 Dec 2017 16:05:09 -0800
Message-ID: <20171217000509.6129-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0058.outbound.protection.outlook.com ([104.47.38.58]:26560
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751512AbdLQAFN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Dec 2017 19:05:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

This patch fixes following warnings reported by smatch

drivers/scsi/qla2xxx/qla_mid.c:586 qla25xx_delete_req_que()
error: we previously assumed 'req' could be null (see line 580)

drivers/scsi/qla2xxx/qla_mid.c:602 qla25xx_delete_rsp_que()
error: we previously assumed 'rsp' could be null (see line 596)

Fixes: 7867b98dceb7 ("scsi: qla2xxx: Fix memory leak in dual/target mode")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_mid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index e538e6308885..522d585a1a08 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -582,8 +582,9 @@ qla25xx_delete_req_que(struct scsi_qla_host *vha, struct req_que *req)
 		ret = qla25xx_init_req_que(vha, req);
 		if (ret != QLA_SUCCESS)
 			return QLA_FUNCTION_FAILED;
+
+		qla25xx_free_req_que(vha, req);
 	}
-	qla25xx_free_req_que(vha, req);
 
 	return ret;
 }
@@ -598,8 +599,9 @@ qla25xx_delete_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 		ret = qla25xx_init_rsp_que(vha, rsp);
 		if (ret != QLA_SUCCESS)
 			return QLA_FUNCTION_FAILED;
+
+		qla25xx_free_rsp_que(vha, rsp);
 	}
-	qla25xx_free_rsp_que(vha, rsp);
 
 	return ret;
 }
-- 
2.12.0
