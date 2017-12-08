From: John Garry <john.garry@huawei.com>
Subject: [PATCH 01/19] scsi: hisi_sas: initialize dq spinlock before use
Date: Sat, 9 Dec 2017 01:16:32 +0800
Message-ID: <1512753410-50924-2-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

It is required to initialize the dq spinlock before use, which
was not being done, so fix it. This issue can be detected when
CONFIG_DEBUG_SPINLOCK is enabled.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5f503cb..359ec52 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1657,6 +1657,7 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 		cq->hisi_hba = hisi_hba;
 
 		/* Delivery queue structure */
+		spin_lock_init(&dq->lock);
 		dq->id = i;
 		dq->hisi_hba = hisi_hba;
 
-- 
1.9.1
