From: John Garry <john.garry@huawei.com>
Subject: [PATCH 06/23] scsi: hisi_sas: error hisi_sas_task_prep() when port down
Date: Thu, 23 Mar 2017 01:25:22 +0800
Message-ID: <1490203539-228029-7-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4376 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760873AbdCVQ6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:58:43 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>

When sas_port is NULL, then return SAS_PHY_DOWN.

In addition, when the sas_dev is gone then explicitly
return SAS_PHY_DOWN.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f64c1b6..7c1fb75 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -200,7 +200,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 		 */
 		if (device->dev_type != SAS_SATA_DEV)
 			task->task_done(task);
-		return 0;
+		return SAS_PHY_DOWN;
 	}
 
 	if (DEV_IS_GONE(sas_dev)) {
@@ -211,8 +211,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 			dev_info(dev, "task prep: device %016llx not ready\n",
 				 SAS_ADDR(device->sas_addr));
 
-		rc = SAS_PHY_DOWN;
-		return rc;
+		return SAS_PHY_DOWN;
 	}
 
 	port = to_hisi_sas_port(sas_port);
-- 
1.9.1
