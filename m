From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 02/10] qla2xxx: Clean up qla84xx_mgmt_cmd()
Date: Wed, 05 Jun 2013 15:03:47 +0200
Message-ID: <51AF3733.2010601@acm.org>
References: <51AF36BF.3030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:59638 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab3FENDt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 09:03:49 -0400
In-Reply-To: <51AF36BF.3030602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

Remove dead code, simplify a pointer computation and move the
ql84_mgmt assignment to just before its first use.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 7221521..cf07491 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1084,14 +1084,6 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
-	ql84_mgmt = (struct qla_bsg_a84_mgmt *)((char *)bsg_job->request +
-		sizeof(struct fc_bsg_request));
-	if (!ql84_mgmt) {
-		ql_log(ql_log_warn, vha, 0x703b,
-		    "MGMT header not provided, exiting.\n");
-		return -EINVAL;
-	}
-
 	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
 	if (!mn) {
 		ql_log(ql_log_warn, vha, 0x703c,
@@ -1103,6 +1095,7 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 	mn->entry_type = ACCESS_CHIP_IOCB_TYPE;
 	mn->entry_count = 1;
 
+	ql84_mgmt = (void *)bsg_job->request + sizeof(struct fc_bsg_request);
 	switch (ql84_mgmt->mgmt.cmd) {
 	case QLA84_MGMT_READ_MEM:
 	case QLA84_MGMT_GET_INFO:
-- 
1.7.10.4

