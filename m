From: John Garry <john.garry@huawei.com>
Subject: [PATCH 05/11] hisi_sas: replace WARN_ON() with dev_warn() for internal abort
Date: Mon, 7 Nov 2016 20:48:34 +0800
Message-ID: <1478522920-108145-6-git-send-email-john.garry@huawei.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, john.garry2@mail.dcu.ie, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Replace WARN_ON() with dev_warn() print when internal abort fails.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 486aa92..9133238 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -764,7 +764,8 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		task = NULL;
 	}
 ex_err:
-	WARN_ON(retry == TASK_RETRY);
+	if (retry == TASK_RETRY)
+		dev_warn(dev, "abort tmf: executing internal task failed!\n");
 	sas_free_task(task);
 	return res;
 }
-- 
1.9.1
