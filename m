From: John Garry <john.garry@huawei.com>
Subject: [PATCH 22/23] scsi: hisi_sas: use dev_is_sata to identify SATA or SAS disk
Date: Thu, 23 Mar 2017 01:25:38 +0800
Message-ID: <1490203539-228029-23-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4370 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760808AbdCVQ6S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:58:18 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

When SMP IO is sent, sas_protocol_ata couldn't judge whether
the disk is SATA or SAS disk.
So use dev_is_sata to identify SATA or SAS disk.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index dcceff9..9890dfd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -218,7 +218,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	port = to_hisi_sas_port(sas_port);
 	if (port && !port->port_attached) {
 		dev_info(dev, "task prep: %s port%d not attach device\n",
-			 (sas_protocol_ata(task->task_proto)) ?
+			 (dev_is_sata(device)) ?
 			 "SATA/STP" : "SAS",
 			 device->port->id);
 
-- 
1.9.1
