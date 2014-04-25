From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.15-rc3
Date: Fri, 25 Apr 2014 07:59:20 -0700
Message-ID: <1398437960.2159.4.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of seven fixes, three (hpsa) and free'd command references
correcting bugs in the last round of updates and the remaining four
correcting problems within the SCSI error handler that was causing a
deadlock within USB.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Alan Stern (1):
      Fix command result state propagation

Christoph Hellwig (2):
      don't reference freed command in scsi_prep_return
      don't reference freed command in scsi_init_sgtable

Hannes Reinecke (1):
      Fix USB deadlock caused by SCSI error handling

James Bottomley (2):
      More USB deadlock fixes
      Fix spurious request sense in error handling

scameron@beardog.cce.hp.com (1):
      hpsa: fix NULL dereference in hpsa_put_ctlr_into_performant_mode()

And the diffstat:

 drivers/scsi/hpsa.c       |  8 ++++----
 drivers/scsi/scsi_error.c | 12 ++++++++++++
 drivers/scsi/scsi_lib.c   |  6 ++++--
 3 files changed, 20 insertions(+), 6 deletions(-)

With full diffs below.

James

---

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8cf4a0c..9a6e4a2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7463,6 +7463,10 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	if (hpsa_simple_mode)
 		return;
 
+	trans_support = readl(&(h->cfgtable->TransportSupport));
+	if (!(trans_support & PERFORMANT_MODE))
+		return;
+
 	/* Check for I/O accelerator mode support */
 	if (trans_support & CFGTBL_Trans_io_accel1) {
 		transMethod |= CFGTBL_Trans_io_accel1 |
@@ -7479,10 +7483,6 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	}
 
 	/* TODO, check that this next line h->nreply_queues is correct */
-	trans_support = readl(&(h->cfgtable->TransportSupport));
-	if (!(trans_support & PERFORMANT_MODE))
-		return;
-
 	h->nreply_queues = h->msix_vector > 0 ? h->msix_vector : 1;
 	hpsa_get_max_perf_mode_cmds(h);
 	/* Performant mode ring buffer and supporting data structures */
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 771c16b..f17aa7a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -189,6 +189,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		/*
 		 * Retry after abort failed, escalate to next level.
 		 */
+		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "scmd %p previous abort failed\n", scmd));
@@ -920,10 +921,12 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->prot_op = scmd->prot_op;
 
 	scmd->prot_op = SCSI_PROT_NORMAL;
+	scmd->eh_eflags = 0;
 	scmd->cmnd = ses->eh_cmnd;
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 	scmd->request->next_rq = NULL;
+	scmd->result = 0;
 
 	if (sense_bytes) {
 		scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
@@ -1157,6 +1160,15 @@ int scsi_eh_get_sense(struct list_head *work_q,
 					     __func__));
 			break;
 		}
+		if (status_byte(scmd->result) != CHECK_CONDITION)
+			/*
+			 * don't request sense if there's no check condition
+			 * status because the error we're processing isn't one
+			 * that has a sense code (and some devices get
+			 * confused by sense requests out of the blue)
+			 */
+			continue;
+
 		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
 						  "%s: requesting sense\n",
 						  current->comm));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 65a123d..9db097a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -137,6 +137,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	 * lock such that the kblockd_schedule_work() call happens
 	 * before blk_cleanup_queue() finishes.
 	 */
+	cmd->result = 0;
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, cmd->request);
 	kblockd_schedule_work(q, &device->requeue_work);
@@ -1044,6 +1045,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
  */
 int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
+	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
 
 	int error = scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
@@ -1091,7 +1093,7 @@ err_exit:
 	scsi_release_buffers(cmd);
 	cmd->request->special = NULL;
 	scsi_put_command(cmd);
-	put_device(&cmd->device->sdev_gendev);
+	put_device(&sdev->sdev_gendev);
 	return error;
 }
 EXPORT_SYMBOL(scsi_init_io);
@@ -1273,7 +1275,7 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 			struct scsi_cmnd *cmd = req->special;
 			scsi_release_buffers(cmd);
 			scsi_put_command(cmd);
-			put_device(&cmd->device->sdev_gendev);
+			put_device(&sdev->sdev_gendev);
 			req->special = NULL;
 		}
 		break;
