Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AB210E
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 19:40:30 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SrJ5g7537zZdKP;
	Thu, 14 Dec 2023 11:40:23 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id 5631B1400CD;
	Thu, 14 Dec 2023 11:40:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 11:40:27 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>, Yihang Li
	<liyihang9@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [RESEND PATCH 3/5] scsi: hisi_sas: Check before using pointer variables
Date: Thu, 14 Dec 2023 11:45:14 +0800
Message-ID: <1702525516-51258-4-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1702525516-51258-1-git-send-email-chenxiang66@hisilicon.com>
References: <1702525516-51258-1-git-send-email-chenxiang66@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500025.china.huawei.com (7.221.188.170)

From: Yihang Li <liyihang9@huawei.com>

In commit 4b329abc91800 ("scsi: hisi_sas: Move slot variable definition in
hisi_sas_abort_task()"), we move the variables slot to the function head.
However, the variable slot may be NULL, we should check it in each branch.

Fixes: 4b329abc9180 ("scsi: hisi_sas: Move slot variable definition in hisi_sas_abort_task()")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1601706..bbb7b2d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1641,7 +1641,10 @@ static int hisi_sas_abort_task(struct sas_task *task)
 	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	if (slot && task->task_proto & SAS_PROTOCOL_SSP) {
+	if (!slot)
+		goto out;
+
+	if (task->task_proto & SAS_PROTOCOL_SSP) {
 		u16 tag = slot->idx;
 		int rc2;
 
@@ -1688,7 +1691,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 				rc = hisi_sas_softreset_ata_disk(device);
 			}
 		}
-	} else if (slot && task->task_proto & SAS_PROTOCOL_SMP) {
+	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
 		/* SMP */
 		u32 tag = slot->idx;
 		struct hisi_sas_cq *cq = &hisi_hba->cq[slot->dlvry_queue];
-- 
2.8.1

