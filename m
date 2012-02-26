From: santosh nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH 1/2] [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Sun, 26 Feb 2012 19:03:30 +0530
Message-ID: <1330263210-25134-1-git-send-email-santoshprasadnayak@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f66.google.com ([209.85.160.66]:60575 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2BZNeL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Feb 2012 08:34:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang@usish.com
Cc: lindar_liu@usish.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Santosh Nayak <santoshprasadnayak@gmail.com>

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Static checker is giving following warning:
" error: calling 'spin_unlock_irqrestore()' with bogus flags"

The code flow is as shown below:
process_oq() --> process_one_iomb --> mpi_sata_completion

In 'mpi_sata_completion'
the first call for 'spin_unlock_irqrestore()' is with flags=0,
which is as good as 'spin_unlock_irq()' ( unconditional interrupt
enabling).

So for better performance 'spin_unlock_irqrestore()' can be replaced
with 'spin_unlock_irq()' and 'spin_lock_irqsave()' can be replaced by
'spin_lock_irq()'.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |   58 ++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 833e720..838e3e2 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1877,7 +1877,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	struct sas_task *t;
 	struct pm8001_ccb_info *ccb;
-	unsigned long flags = 0;
 	u32 param;
 	u32 status;
 	u32 tag;
@@ -2016,9 +2015,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*in order to force CPU ordering*/
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irq(&pm8001_ha->lock);
 			t->task_done(t);
-			spin_lock_irqsave(&pm8001_ha->lock, flags);
+			spin_lock_irq(&pm8001_ha->lock);
 			return;
 		}
 		break;
@@ -2036,9 +2035,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irq(&pm8001_ha->lock);
 			t->task_done(t);
-			spin_lock_irqsave(&pm8001_ha->lock, flags);
+			spin_lock_irq(&pm8001_ha->lock);
 			return;
 		}
 		break;
@@ -2064,9 +2063,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/* ditto*/
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irq(&pm8001_ha->lock);
 			t->task_done(t);
-			spin_lock_irqsave(&pm8001_ha->lock, flags);
+			spin_lock_irq(&pm8001_ha->lock);
 			return;
 		}
 		break;
@@ -2131,9 +2130,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irq(&pm8001_ha->lock);
 			t->task_done(t);
-			spin_lock_irqsave(&pm8001_ha->lock, flags);
+			spin_lock_irq(&pm8001_ha->lock);
 			return;
 		}
 		break;
@@ -2155,9 +2154,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irq(&pm8001_ha->lock);
 			t->task_done(t);
-			spin_lock_irqsave(&pm8001_ha->lock, flags);
+			spin_lock_irq(&pm8001_ha->lock);
 			return;
 		}
 		break;
@@ -2175,31 +2174,31 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		break;
 	}
-	spin_lock_irqsave(&t->task_state_lock, flags);
+	spin_lock_irq(&t->task_state_lock);
 	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
 	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
+		spin_unlock_irq(&t->task_state_lock);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("task 0x%p done with io_status 0x%x"
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else if (t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
+		spin_unlock_irq(&t->task_state_lock);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/* ditto */
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irq(&pm8001_ha->lock);
 		t->task_done(t);
-		spin_lock_irqsave(&pm8001_ha->lock, flags);
+		spin_lock_irq(&pm8001_ha->lock);
 	} else if (!t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
+		spin_unlock_irq(&t->task_state_lock);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/*ditto*/
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irq(&pm8001_ha->lock);
 		t->task_done(t);
-		spin_lock_irqsave(&pm8001_ha->lock, flags);
+		spin_lock_irq(&pm8001_ha->lock);
 	}
 }
 
@@ -2207,7 +2206,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 {
 	struct sas_task *t;
-	unsigned long flags = 0;
 	struct task_status_struct *ts;
 	struct pm8001_ccb_info *ccb;
 	struct pm8001_device *pm8001_dev;
@@ -2287,9 +2285,9 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irq(&pm8001_ha->lock);
 			t->task_done(t);
-			spin_lock_irqsave(&pm8001_ha->lock, flags);
+			spin_lock_irq(&pm8001_ha->lock);
 			return;
 		}
 		break;
@@ -2387,31 +2385,31 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_OPEN_TO;
 		break;
 	}
-	spin_lock_irqsave(&t->task_state_lock, flags);
+	spin_lock_irq(&t->task_state_lock);
 	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
 	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
+		spin_unlock_irq(&t->task_state_lock);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("task 0x%p done with io_status 0x%x"
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, event, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else if (t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
+		spin_unlock_irq(&t->task_state_lock);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/* ditto */
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irq(&pm8001_ha->lock);
 		t->task_done(t);
-		spin_lock_irqsave(&pm8001_ha->lock, flags);
+		spin_lock_irq(&pm8001_ha->lock);
 	} else if (!t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
+		spin_unlock_irq(&t->task_state_lock);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/*ditto*/
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irq(&pm8001_ha->lock);
 		t->task_done(t);
-		spin_lock_irqsave(&pm8001_ha->lock, flags);
+		spin_lock_irq(&pm8001_ha->lock);
 	}
 }
 
-- 
1.7.4.4

