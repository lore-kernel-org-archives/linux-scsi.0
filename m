From: John Garry <john.garry@huawei.com>
Subject: [PATCH 02/19] scsi: hisi_sas: fix internal abort slot timeout bug
Date: Tue, 24 Oct 2017 23:51:32 +0800
Message-ID: <1508860309-212397-3-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When an internal abort times out in
hisi_sas_internal_task_abort(), goto the exit label in
and not go through the other task status checks.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9e29902..0eb9174 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1469,6 +1469,7 @@ static int hisi_sas_query_task(struct sas_task *task)
 			if (slot)
 				slot->task = NULL;
 			dev_err(dev, "internal task abort: timeout.\n");
+			goto exit;
 		}
 	}
 
-- 
1.9.1
