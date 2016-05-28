From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH] scsi: fix race between simultaneous decrements of ->host_failed
Date: Sat, 28 May 2016 11:51:11 +0800
Message-ID: <1464407471-3712-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Wei Fang <fangwei1@huawei.com>
List-Id: linux-scsi@vger.kernel.org

async_sas_ata_eh(), which will call scsi_eh_finish_cmd() in some case,
would be performed simultaneously in sas_ata_strategy_handler(). In this
case, ->host_failed may be decreased simultaneously in
scsi_eh_finish_cmd() on different CPUs, and become abnormal.

It will lead to permanently inequal between ->host_failed and
 ->host_busy. Then SCSI error handler thread won't become running,
SCSI errors after that won't be handled forever.

Use atomic type for ->host_failed to fix this race.

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 drivers/ata/libata-eh.c             |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c |    5 +++--
 drivers/scsi/scsi.c                 |    2 +-
 drivers/scsi/scsi_error.c           |   15 +++++++++------
 drivers/scsi/scsi_lib.c             |    3 ++-
 include/scsi/scsi_host.h            |    2 +-
 6 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 961acc7..a0e7612 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -606,7 +606,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 	ata_scsi_port_error_handler(host, ap);
 
 	/* finish or retry handled scmd's and clean up */
-	WARN_ON(host->host_failed || !list_empty(&eh_work_q));
+	WARN_ON(atomic_read(&host->host_failed) || !list_empty(&eh_work_q));
 
 	DPRINTK("EXIT\n");
 }
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 519dac4..8d74003 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -757,7 +757,8 @@ retry:
 	spin_unlock_irq(shost->host_lock);
 
 	SAS_DPRINTK("Enter %s busy: %d failed: %d\n",
-		    __func__, atomic_read(&shost->host_busy), shost->host_failed);
+		    __func__, atomic_read(&shost->host_busy),
+		    atomic_read(&shost->host_failed));
 	/*
 	 * Deal with commands that still have SAS tasks (i.e. they didn't
 	 * complete via the normal sas_task completion mechanism),
@@ -800,7 +801,7 @@ out:
 
 	SAS_DPRINTK("--- Exit %s: busy: %d failed: %d tries: %d\n",
 		    __func__, atomic_read(&shost->host_busy),
-		    shost->host_failed, tries);
+		    atomic_read(&shost->host_failed), tries);
 }
 
 enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1deb6ad..7840915 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -527,7 +527,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 				scmd_printk(KERN_INFO, cmd,
 					    "scsi host busy %d failed %d\n",
 					    atomic_read(&cmd->device->host->host_busy),
-					    cmd->device->host->host_failed);
+					    atomic_read(&cmd->device->host->host_failed));
 		}
 	}
 }
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 984ddcb..f37666f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -62,7 +62,8 @@ static int scsi_try_to_abort_cmd(struct scsi_host_template *,
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
-	if (atomic_read(&shost->host_busy) == shost->host_failed) {
+	if (atomic_read(&shost->host_busy) ==
+	    atomic_read(&shost->host_failed)) {
 		trace_scsi_eh_wakeup(shost);
 		wake_up_process(shost->ehandler);
 		SCSI_LOG_ERROR_RECOVERY(5, shost_printk(KERN_INFO, shost,
@@ -250,7 +251,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 		eh_flag &= ~SCSI_EH_CANCEL_CMD;
 	scmd->eh_eflags |= eh_flag;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
-	shost->host_failed++;
+	atomic_inc(&shost->host_failed);
 	scsi_eh_wakeup(shost);
  out_unlock:
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1127,7 +1128,7 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
  */
 void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
 {
-	scmd->device->host->host_failed--;
+	atomic_dec(&scmd->device->host->host_failed);
 	scmd->eh_eflags = 0;
 	list_move_tail(&scmd->eh_entry, done_q);
 }
@@ -2190,8 +2191,10 @@ int scsi_error_handler(void *data)
 		if (kthread_should_stop())
 			break;
 
-		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
-		    shost->host_failed != atomic_read(&shost->host_busy)) {
+		if ((atomic_read(&shost->host_failed) == 0 &&
+		     shost->host_eh_scheduled == 0) ||
+		    (atomic_read(&shost->host_failed) !=
+		     atomic_read(&shost->host_busy))) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				shost_printk(KERN_INFO, shost,
 					     "scsi_eh_%d: sleeping\n",
@@ -2205,7 +2208,7 @@ int scsi_error_handler(void *data)
 			shost_printk(KERN_INFO, shost,
 				     "scsi_eh_%d: waking up %d/%d/%d\n",
 				     shost->host_no, shost->host_eh_scheduled,
-				     shost->host_failed,
+				     atomic_read(&shost->host_failed),
 				     atomic_read(&shost->host_busy)));
 
 		/*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..fb3cc5d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -318,7 +318,8 @@ void scsi_device_unbusy(struct scsi_device *sdev)
 		atomic_dec(&starget->target_busy);
 
 	if (unlikely(scsi_host_in_recovery(shost) &&
-		     (shost->host_failed || shost->host_eh_scheduled))) {
+		     (atomic_read(&shost->host_failed) ||
+		      shost->host_eh_scheduled))) {
 		spin_lock_irqsave(shost->host_lock, flags);
 		scsi_eh_wakeup(shost);
 		spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index fcfa3d7..654435f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -576,7 +576,7 @@ struct Scsi_Host {
 	atomic_t host_busy;		   /* commands actually active on low-level */
 	atomic_t host_blocked;
 
-	unsigned int host_failed;	   /* commands that failed.
+	atomic_t host_failed;		   /* commands that failed.
 					      protected by host_lock */
 	unsigned int host_eh_scheduled;    /* EH scheduled without command */
     
-- 
1.7.1

