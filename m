From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: lpfc: Remove unnecessary null check before kfree
Date: Thu, 11 Jul 2019 22:10:37 +0800
Message-ID: <20190711141037.57880-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

A null check before a kfree is redundant, so remove it.
This is detected by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index b7216d6..c7f6623 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1276,9 +1276,7 @@ lpfc_bsg_hba_set_event(struct bsg_job *job)
 	return 0; /* call job done later */
 
 job_error:
-	if (dd_data != NULL)
-		kfree(dd_data);
-
+	kfree(dd_data);
 	job->dd_data = NULL;
 	return rc;
 }
-- 
2.7.4
