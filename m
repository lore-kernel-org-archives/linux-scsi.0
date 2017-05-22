From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: hisi_sas: add null check before indirect pointer
 dereference
Date: Mon, 22 May 2017 13:00:29 -0500
Message-ID: <20170522180029.GA19381@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.50.45]:39823 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759987AbdEVSAd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 May 2017 14:00:33 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 8CDF4117943
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2017 13:00:30 -0500 (CDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>

Add null check before indirectly dereferencing pointer task->lldd_task
in statement u32 tag = slot->idx;

Addresses-Coverity-ID: 1373843
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d622db5..f720d3c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -963,7 +963,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 						     HISI_SAS_INT_ABT_DEV, 0);
 			rc = hisi_sas_softreset_ata_disk(device);
 		}
-	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
+	} else if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SMP) {
 		/* SMP */
 		struct hisi_sas_slot *slot = task->lldd_task;
 		u32 tag = slot->idx;
-- 
2.5.0
