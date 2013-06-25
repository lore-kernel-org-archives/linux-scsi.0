From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 08/16] qla2xxx: Clean up qla84xx_mgmt_cmd()
Date: Tue, 25 Jun 2013 11:27:23 -0400
Message-ID: <1372174051-4211-9-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:55366 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977Ab3FYPxu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:50 -0400
Received: from mail212-tx2 (localhost [127.0.0.1])	by
 mail212-tx2-R.bigfish.com (Postfix) with ESMTP id 3B7BC9002C0	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:49 +0000 (UTC)
Received: from TX2EHSMHS009.bigfish.com (unknown [10.9.14.246])	by
 mail212-tx2.bigfish.com (Postfix) with ESMTP id 17BFBB00077	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:48 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Remove dead code, simplify a pointer computation and move the
ql84_mgmt assignment to just before its first use.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   10 +---------
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 9a30b69..b85f002 100644
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
@@ -1102,7 +1094,7 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 	memset(mn, 0, sizeof(struct access_chip_84xx));
 	mn->entry_type = ACCESS_CHIP_IOCB_TYPE;
 	mn->entry_count = 1;
-
+	ql84_mgmt = (void *)bsg_job->request + sizeof(struct fc_bsg_request);
 	switch (ql84_mgmt->mgmt.cmd) {
 	case QLA84_MGMT_READ_MEM:
 	case QLA84_MGMT_GET_INFO:
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 91a1166..74a2121 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -36,7 +36,7 @@
  * |                              |                    | 0x70a8,0x70ab, |
  * |                              |                    | 0x70ad-0x70ae, |
  * |                              |                    | 0x70d1-0x70da, |
- * |                              |                    | 0x7047		|
+ * |                              |                    | 0x7047,0x703b	|
  * | Task Management              |       0x803c       | 0x8025-0x8026  |
  * |                              |                    | 0x800b,0x8039  |
  * | AER/EEH                      |       0x9011       |		|
-- 
1.7.7


