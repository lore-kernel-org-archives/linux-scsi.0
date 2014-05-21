From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH RFC] Remove the cancel_delayed_work() call from scsi_put_command()
Date: Wed, 21 May 2014 15:30:33 +0200
Message-ID: <537CAA79.2030304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:60281 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaEUNam (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 09:30:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

scmd->abort_work is only scheduled after the block layer has marked
the request associated with a command as complete and for commands
that are not on the eh_cmd_q list. A SCSI command is only requeued
after the scmd->abort_work handler has started (requeueing clears
the "complete" flag). This means that the cancel_delayed_work()
statement in scsi_put_command() is a no-op. Hence remove it.

Additionally, document how it is avoided that scsi_finish_command()
and the SCSI error handler code are invoked concurrently for the
same command via WARN_ON_ONCE() statements. This should avoid that
the scsi error handler code confuses its readers.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Joe Lawrence <jdl1291@gmail.com>
---
 block/blk-softirq.c       |  6 ++++++
 drivers/scsi/scsi.c       |  2 --
 drivers/scsi/scsi_error.c | 28 ++++++++++++++++++++++++++++
 include/linux/blkdev.h    |  1 +
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 53b1737..59bb52d 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -172,6 +172,12 @@ void blk_complete_request(struct request *req)
 }
 EXPORT_SYMBOL(blk_complete_request);
 
+bool blk_rq_completed(struct request *rq)
+{
+	return test_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
+}
+EXPORT_SYMBOL(blk_rq_completed);
+
 static __init int blk_softirq_init(void)
 {
 	int i;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..04a282a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -334,8 +334,6 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 	list_del_init(&cmd->list);
 	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
 
-	cancel_delayed_work(&cmd->abort_work);
-
 	__scsi_put_command(cmd->device->host, cmd);
 }
 EXPORT_SYMBOL(scsi_put_command);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 14ce3b4..32a8cd1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -108,6 +108,28 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 	return 1;
 }
 
+static bool scmd_being_handled_in_other_context(struct scsi_cmnd *scmd)
+{
+	struct Scsi_Host *shost = scmd->device->host;
+	struct scsi_cmnd *c;
+	unsigned long flags;
+	bool ret = false;
+
+	if (!blk_rq_completed(scmd->request))
+		return true;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(c, &shost->eh_cmd_q, eh_entry) {
+		if (c == scmd) {
+			ret = true;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	return ret;
+}
+
 /**
  * scmd_eh_abort_handler - Handle command aborts
  * @work:	command to be aborted.
@@ -120,6 +142,8 @@ scmd_eh_abort_handler(struct work_struct *work)
 	struct scsi_device *sdev = scmd->device;
 	int rtn;
 
+	WARN_ON_ONCE(scmd_being_handled_in_other_context(scmd));
+
 	if (scsi_host_eh_past_deadline(sdev->host)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
@@ -185,6 +209,8 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 
+	WARN_ON_ONCE(scmd_being_handled_in_other_context(scmd));
+
 	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
 		/*
 		 * Retry after abort failed, escalate to next level.
@@ -237,6 +263,8 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 	unsigned long flags;
 	int ret = 0;
 
+	WARN_ON_ONCE(scmd_being_handled_in_other_context(scmd));
+
 	if (!shost->ehandler)
 		return 0;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0d84981..a621bc5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -952,6 +952,7 @@ extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
 extern void blk_unprep_request(struct request *);
+extern bool blk_rq_completed(struct request *);
 
 /*
  * Access functions for manipulating queue properties
-- 
1.8.4.5

