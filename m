From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH] scsi:NCR5380: remove same check condition in NCR5380_select
Date: Thu, 2 Aug 2018 11:10:08 +0800
Message-ID: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: fthain@telegraphics.com.au, schmitzmic@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: andy.shevchenko@gmail.com, john.garry@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The same check condition is redundant, so remove one of them.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/scsi/NCR5380.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 90ea0f5..2ecaf3f 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -999,8 +999,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 
 	/* Check for lost arbitration */
 	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
-	    (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) ||
-	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
+	    (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		dsprintk(NDEBUG_ARBITRATION, instance, "lost arbitration, deasserting MR_ARBITRATE\n");
 		spin_lock_irq(&hostdata->lock);
-- 
1.7.12.4
