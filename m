From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Ensure that the SCSI error handler gets woken up
Date: Wed, 22 Nov 2017 17:05:05 -0800
Message-ID: <20171123010505.9603-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, Stuart Hayes <stuart.w.hayes@gmail.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If scsi_eh_scmd_add() is called concurrently with scsi_host_queue_ready()
while shost->host_blocked > 0 then it can happen that neither function
wakes up the SCSI error handler. Fix this by making every function that
decreases the host_busy counter to wake up the error handler if necessary.

Reported-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Fixes: commit 746650160866 ("scsi: convert host_busy to atomic_t")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_error.c |  3 ++-
 drivers/scsi/scsi_lib.c   | 22 ++++++++++++++--------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5e89049e9b4e..f7f014c755d7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -61,9 +61,10 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
 static int scsi_try_to_abort_cmd(struct scsi_host_template *,
 				 struct scsi_cmnd *);
 
-/* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
+	lockdep_assert_held(shost->host_lock);
+
 	if (atomic_read(&shost->host_busy) == shost->host_failed) {
 		trace_scsi_eh_wakeup(shost);
 		wake_up_process(shost->ehandler);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1e05e1885ac8..abd37d77af2d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -318,22 +318,28 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 }
 
-void scsi_device_unbusy(struct scsi_device *sdev)
+static void scsi_dec_host_busy(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = sdev->host;
-	struct scsi_target *starget = scsi_target(sdev);
 	unsigned long flags;
 
 	atomic_dec(&shost->host_busy);
-	if (starget->can_queue > 0)
-		atomic_dec(&starget->target_busy);
-
 	if (unlikely(scsi_host_in_recovery(shost) &&
 		     (shost->host_failed || shost->host_eh_scheduled))) {
 		spin_lock_irqsave(shost->host_lock, flags);
 		scsi_eh_wakeup(shost);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
+}
+
+void scsi_device_unbusy(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_target *starget = scsi_target(sdev);
+
+	scsi_dec_host_busy(shost);
+
+	if (starget->can_queue > 0)
+		atomic_dec(&starget->target_busy);
 
 	atomic_dec(&sdev->device_busy);
 }
@@ -1532,7 +1538,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 		list_add_tail(&sdev->starved_entry, &shost->starved_list);
 	spin_unlock_irq(shost->host_lock);
 out_dec:
-	atomic_dec(&shost->host_busy);
+	scsi_dec_host_busy(shost);
 	return 0;
 }
 
@@ -2020,7 +2026,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_STS_OK;
 
 out_dec_host_busy:
-       atomic_dec(&shost->host_busy);
+	scsi_dec_host_busy(shost);
 out_dec_target_busy:
 	if (scsi_target(sdev)->can_queue > 0)
 		atomic_dec(&scsi_target(sdev)->target_busy);
-- 
2.15.0
