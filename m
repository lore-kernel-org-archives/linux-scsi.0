From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 2/3] qla2xxx: Fix response queue count for Target mode.
Date: Wed, 15 Feb 2017 15:37:20 -0800
Message-ID: <1487201841-28846-3-git-send-email-himanshu.madhani@cavium.com>
References: <1487201841-28846-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0086.outbound.protection.outlook.com ([104.47.34.86]:2912
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755421AbdBOXiW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 18:38:22 -0500
In-Reply-To: <1487201841-28846-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Michael Hernandez <michael.hernandez@cavium.com>

Target mode initialization was not calculating response
queue values correctly resulting into one less MSI-X vector.

Fixes: 093df73 ("scsi: qla2xxx: Fix Target mode handling with Multiqueue changes.")
Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8174cee..71b6b20 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1916,12 +1916,13 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		if (ql2xmqsupport) {
 			/* MB interrupt uses 1 vector */
 			ha->max_req_queues = ha->msix_count - 1;
-			ha->max_rsp_queues = ha->max_req_queues;
 
 			/* ATIOQ needs 1 vector. That's 1 less QPair */
 			if (QLA_TGT_MODE_ENABLED())
 				ha->max_req_queues--;
 
+			ha->max_rsp_queues = ha->max_req_queues;
+
 			/* Queue pairs is the max value minus
 			 * the base queue pair */
 			ha->max_qpairs = ha->max_req_queues - 1;
-- 
1.8.3.1
