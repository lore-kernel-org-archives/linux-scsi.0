From: John Garry <john.garry@huawei.com>
Subject: [PATCH 08/23] scsi: hisi_sas: modify error handling for v2 hw
Date: Thu, 23 Mar 2017 01:25:24 +0800
Message-ID: <1490203539-228029-9-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4368 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760807AbdCVQ6S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:58:18 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

For error codes which need abort-and-retry, simulate IO
timeout and let SCSI+ATA layers process those errors.

Previously for SSP, we should try to abort the IO in
the LLDD and then pass back to upper layer, but sometimes
this would also error. So Instead of adding special error
handling for this scenario in the LLDD, allow the upper
layer to handle completely.

No performance hit is seen by taking this approach.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index b9d5132..a35f881 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1747,7 +1747,6 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 
 	task->task_state_flags &=
 		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
-	task->task_state_flags |= SAS_TASK_STATE_DONE;
 
 	memset(ts, 0, sizeof(*ts));
 	ts->resp = SAS_TASK_COMPLETE;
@@ -1786,11 +1785,9 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		(!(complete_hdr->dw0 & CMPLT_HDR_RSPNS_XFRD_MSK))) {
 
 		slot_err_v2_hw(hisi_hba, task, slot);
-		if (unlikely(slot->abort)) {
-			queue_work(hisi_hba->wq, &slot->abort_slot);
-			/* immediately return and do not complete */
+
+		if (unlikely(slot->abort))
 			return ts->stat;
-		}
 		goto out;
 	}
 
@@ -1842,7 +1839,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	}
 
 out:
-
+	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	hisi_sas_slot_task_free(hisi_hba, task, slot);
 	sts = ts->stat;
 
-- 
1.9.1
