From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: lpfc: Remove set but not used variables 'qp'
Date: Fri, 31 May 2019 23:27:45 +0800
Message-ID: <20190531152745.7928-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, jsmart2021@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warnings:

drivers/scsi/lpfc/lpfc_init.c: In function lpfc_setup_cq_lookup:
drivers/scsi/lpfc/lpfc_init.c:9359:30: warning: variable qp set but not used [-Wunused-but-set-variable]

It's not used since commit e70596a60f88 ("scsi: lpfc: Fix
poor use of hardware queues if fewer irq vectors")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 24965a06f55d..cd8e47544d07 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9356,10 +9356,8 @@ static void
 lpfc_setup_cq_lookup(struct lpfc_hba *phba)
 {
 	struct lpfc_queue *eq, *childq;
-	struct lpfc_sli4_hdw_queue *qp;
 	int qidx;
 
-	qp = phba->sli4_hba.hdwq;
 	memset(phba->sli4_hba.cq_lookup, 0,
 	       (sizeof(struct lpfc_queue *) * (phba->sli4_hba.cq_max + 1)));
 	/* Loop thru all IRQ vectors */
-- 
2.17.1
