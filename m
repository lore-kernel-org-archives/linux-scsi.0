From: santosh nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH 2/2] [SCSI] pm8001: Fix possible racing codition.
Date: Sun, 26 Feb 2012 19:05:03 +0530
Message-ID: <1330263303-25177-1-git-send-email-santoshprasadnayak@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jack_wang@usish.com
Cc: lindar_liu@usish.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Santosh Nayak <santoshprasadnayak@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

There is a possble racing scenario.

'process_oq' is called by two routines, as shown below.

pm8001_8001_dispatch = {
         .......

        .isr             = pm8001_chip_isr --> process_oq,// A
        .isr_process_oq  = process_oq,                   //  B
        .....
}

process_oq() --> process_one_iomb() --> mpi_sata_completion()

In 'mpi_sata_completion', "pm8001_ha->lock" is first released.
It means lock is taken before,  which is true for
the context A, as 'pm8001_ha->lock' is taken in 'pm8001_chip_isr()'

But for context B there is no lock taken before and pm8001_ha->lock
is unlocked in 'mpi_sata_completion()'. This may unlock the lock
taken in context A. Possible racing ??

If 'pm8001_ha->lock' is taken in 'process_oq()' instead of
'pm8001_chip_isr' then the above issue can be avoided.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 838e3e2..6d9973b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3663,7 +3663,9 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha)
 	void *pMsg1 = NULL;
 	u8 uninitialized_var(bc);
 	u32 ret = MPI_IO_STATUS_FAIL;
+	unsigned long flags;
 
+	spin_lock_irqsave(&pm8001_ha->lock, flags);
 	circularQ = &pm8001_ha->outbnd_q_tbl[0];
 	do {
 		ret = mpi_msg_consume(pm8001_ha, circularQ, &pMsg1, &bc);
@@ -3682,6 +3684,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha)
 				break;
 		}
 	} while (1);
+	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 	return ret;
 }
 
@@ -4087,12 +4090,9 @@ static u32 pm8001_chip_is_our_interupt(struct pm8001_hba_info *pm8001_ha)
 static irqreturn_t
 pm8001_chip_isr(struct pm8001_hba_info *pm8001_ha)
 {
-	unsigned long flags;
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
 	pm8001_chip_interrupt_disable(pm8001_ha);
 	process_oq(pm8001_ha);
 	pm8001_chip_interrupt_enable(pm8001_ha);
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 	return IRQ_HANDLED;
 }
 
-- 
1.7.4.4
