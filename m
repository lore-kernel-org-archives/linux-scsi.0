From: Dan Williams <dan.j.williams@intel.com>
Subject: [libsas PATCH v10 2/9] libsas: cleanup spurious calls to
 scsi_schedule_eh
Date: Sat, 10 Mar 2012 20:39:07 -0800
Message-ID: <20120311043906.27797.28938.stgit@dwillia2-linux.jf.intel.com>
References: <20120311043722.27797.97791.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120311043722.27797.97791.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

eh is woken up automatically by the presence of failed commands,
scsi_schedule_eh is reserved for cases where there are no failed
commands.  This guarantees that host_eh_sceduled is only incremented
when an explicit eh request is made.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c       |   25 -------------------------
 drivers/scsi/libsas/sas_scsi_host.c |    5 -----
 include/scsi/sas_ata.h              |    4 ----
 3 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index bc0cecc..729a7b6 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -574,31 +574,6 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev)
 	return 0;
 }
 
-void sas_ata_task_abort(struct sas_task *task)
-{
-	struct ata_queued_cmd *qc = task->uldd_task;
-	struct completion *waiting;
-
-	/* Bounce SCSI-initiated commands to the SCSI EH */
-	if (qc->scsicmd) {
-		struct request_queue *q = qc->scsicmd->device->request_queue;
-		unsigned long flags;
-
-		spin_lock_irqsave(q->queue_lock, flags);
-		blk_abort_request(qc->scsicmd->request);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-		scsi_schedule_eh(qc->scsicmd->device->host);
-		return;
-	}
-
-	/* Internal command, fake a timeout and complete. */
-	qc->flags &= ~ATA_QCFLAG_ACTIVE;
-	qc->flags |= ATA_QCFLAG_FAILED;
-	qc->err_mask |= AC_ERR_TIMEOUT;
-	waiting = qc->private_data;
-	complete(waiting);
-}
-
 static void sas_get_ata_command_set(struct domain_device *dev)
 {
 	struct dev_to_host_fis *fis =
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f0b9b7b..49a9113 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -992,10 +992,6 @@ void sas_task_abort(struct sas_task *task)
 			return;
 		task->timer.function(task->timer.data);
 		return;
-	}
-
-	if (dev_is_sata(task->dev)) {
-		sas_ata_task_abort(task);
 	} else {
 		struct request_queue *q = sc->device->request_queue;
 		unsigned long flags;
@@ -1003,7 +999,6 @@ void sas_task_abort(struct sas_task *task)
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(sc->request);
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		scsi_schedule_eh(sc->device->host);
 	}
 }
 
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index cdccd2e..6d5d60c 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -38,7 +38,6 @@ static inline int dev_is_sata(struct domain_device *dev)
 
 int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy);
 int sas_ata_init_host_and_port(struct domain_device *found_dev);
-void sas_ata_task_abort(struct sas_task *task);
 void sas_ata_strategy_handler(struct Scsi_Host *shost);
 void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 		struct list_head *done_q);
@@ -56,9 +55,6 @@ static inline int sas_ata_init_host_and_port(struct domain_device *found_dev)
 {
 	return 0;
 }
-static inline void sas_ata_task_abort(struct sas_task *task)
-{
-}
 
 static inline void sas_ata_strategy_handler(struct Scsi_Host *shost)
 {

