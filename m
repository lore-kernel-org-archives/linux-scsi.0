From: Viswas G <Viswas.G@pmcs.com>
Subject: [PATCH V2] pm80xx: Spinlock fix
Date: Thu, 16 Jan 2014 15:45:07 +0530
Message-ID: <1389867307-4982-1-git-send-email-Viswas.G@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:47940 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbaAPLq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 06:46:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, jason.seba42@gmail.com, JBottomley@parallels.com, oleg@redhat.com, Rich.Bono@pmcs.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

>From dfaae38ba7b6b7260fb3209d2dd12d70f0a8e306 Mon Sep 17 00:00:00 2001
From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Date: Thu, 16 Jan 2014 15:26:21 +0530
Subject: [PATCH V2] pm80xx: Spinlock fix

spin_lock_irqsave for the HBA lock is called in one function where flag
is local to that function. Another function is called from the first
function where lock has to be released using spin_unlock_irqrestore for 
calling task_done of libsas. In the second function also flag is declared
and used. For calling task_done there is no need to enable the irq. So 
instead of using spin_lock_irqsave and spin_unlock_irqrestore, spin_lock
and spin_unlock is used now. This also avoids passing the flags across all
the functions where HBA lock is being used. Also removed redundant code. 


Reported-by: Jason Seba <jason.seba42@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Signed-off-by: Viswas G <viswas.g@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |   84 ++++++--------------------------------
 drivers/scsi/pm8001/pm8001_sas.h |   12 +++++
 drivers/scsi/pm8001/pm80xx_hwi.c |   84 ++++++--------------------------------
 3 files changed, 38 insertions(+), 142 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 46ace52..d6a4b17 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2502,11 +2502,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*in order to force CPU ordering*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2522,11 +2518,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2550,11 +2542,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/* ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2617,11 +2605,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				    IO_DS_NON_OPERATIONAL);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2641,11 +2625,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				    IO_DS_IN_ERROR);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2674,20 +2654,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else if (t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
-	} else if (!t->uldd_task) {
+	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 	}
 }
 
@@ -2796,11 +2765,7 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2909,20 +2874,9 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, event, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else if (t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
-	} else if (!t->uldd_task) {
+	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 	}
 }
 
@@ -4467,23 +4421,11 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 					" stat 0x%x but aborted by upper layer "
 					"\n", task, ts->resp, ts->stat));
 				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
-			} else if (task->uldd_task) {
-				spin_unlock_irqrestore(&task->task_state_lock,
-							flags);
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
-				mb();/* ditto */
-				spin_unlock_irq(&pm8001_ha->lock);
-				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
-				return 0;
-			} else if (!task->uldd_task) {
+			} else {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
-				mb();/*ditto*/
-				spin_unlock_irq(&pm8001_ha->lock);
-				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
+				pm8001_ccb_task_free_done(pm8001_ha, task,
+								ccb, tag);
 				return 0;
 			}
 		}
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 6c5fd5e..1ee06f2 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -708,5 +708,17 @@ ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
 /* ctl shared API */
 extern struct device_attribute *pm8001_host_attrs[];
 
+static inline void
+pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
+			struct sas_task *task, struct pm8001_ccb_info *ccb,
+			u32 ccb_idx)
+{
+	pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb_idx);
+	smp_mb(); /*in order to force CPU ordering*/
+	spin_unlock(&pm8001_ha->lock);
+	task->task_done(task);
+	spin_lock(&pm8001_ha->lock);
+}
+
 #endif
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 65de79c..617c37f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2168,11 +2168,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*in order to force CPU ordering*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2188,11 +2184,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2214,11 +2206,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/* ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2281,11 +2269,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 					IO_DS_NON_OPERATIONAL);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2305,11 +2289,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 					IO_DS_IN_ERROR);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2338,20 +2318,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else if (t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
-	} else if (!t->uldd_task) {
+	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 	}
 }
 
@@ -2463,11 +2432,7 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2589,20 +2554,9 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, event, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else if (t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
-	} else if (!t->uldd_task) {
+	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 	}
 }
 
@@ -4297,23 +4251,11 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 					"\n", task, ts->resp, ts->stat));
 				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
 				return 0;
-			} else if (task->uldd_task) {
-				spin_unlock_irqrestore(&task->task_state_lock,
-							flags);
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
-				mb();/* ditto */
-				spin_unlock_irq(&pm8001_ha->lock);
-				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
-				return 0;
-			} else if (!task->uldd_task) {
+			} else {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
-				mb();/*ditto*/
-				spin_unlock_irq(&pm8001_ha->lock);
-				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
+				pm8001_ccb_task_free_done(pm8001_ha, task,
+								ccb, tag);
 				return 0;
 			}
 		}
-- 
1.7.6

