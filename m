From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] scsi: libsas: fix length error in sas_smp_handler()
Date: Tue, 5 Dec 2017 17:39:43 +0800
Message-ID: <20171205093943.40116-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:11910 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753086AbdLEJd5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 04:33:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>, Christoph Hellwig <hch@lst.de>

The bsg_job_done() requires the length of payload received, but we give
it the untransferred residual.

Fixes: 651a01364994 ("scsi: scsi_transport_sas: switch to bsg-lib for SMP")
Reported-and-tested-by: chenqilin <chenqilin2@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/libsas/sas_expander.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 50cb0f3..8323dc1 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2177,9 +2177,9 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 
 	ret = smp_execute_task_sg(dev, job->request_payload.sg_list,
 			job->reply_payload.sg_list);
-	if (ret > 0) {
+	if (ret >= 0) {
 		/* positive number is the untransferred residual */
-		reslen = ret;
+		reslen = job->reply_payload.payload_len - ret;
 		ret = 0;
 	}
 
-- 
2.9.5
