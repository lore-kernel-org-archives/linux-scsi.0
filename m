From: John Garry <john.garry@huawei.com>
Subject: [PATCH 21/23] scsi: hisi_sas: check hisi_sas_lu_reset() error message
Date: Thu, 23 Mar 2017 01:25:37 +0800
Message-ID: <1490203539-228029-22-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4382 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S935489AbdCVQ7G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:59:06 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>

Unless we actually get some sort of failure in
hisi_sas_lu_reset(), don't print a message.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1391f2d..dcceff9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1070,8 +1070,9 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 		}
 	}
 out:
-	dev_err(dev, "lu_reset: for device[%llx]:rc= %d\n",
-		sas_dev->device_id, rc);
+	if (rc != TMF_RESP_FUNC_COMPLETE)
+		dev_err(dev, "lu_reset: for device[%llx]:rc= %d\n",
+			     sas_dev->device_id, rc);
 	return rc;
 }
 
-- 
1.9.1
