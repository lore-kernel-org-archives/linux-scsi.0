From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/3] Remove two cancel_delayed_work() calls from the error
 handler
Date: Mon, 26 May 2014 17:14:26 +0200
Message-ID: <53835A52.9010306@acm.org>
References: <538359DB.9080601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:46934 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaEZPO1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 May 2014 11:14:27 -0400
In-Reply-To: <538359DB.9080601@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Joe Lawrence <jdl1291@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

scsi_put_command() is either invoked before a command is queued or
after a command has completed. scsi_cmnd.abort_work is scheduled
after a command has timed out and before it is finished. The block
layer guarantees that either the softirq_done_fn() or the
rq_timed_out_fn() function is invoked but not both. This means that
scsi_put_command() is never invoked while abort_work is scheduled.
Hence remove the cancel_delayed_work() call from scsi_put_command().

Similarly, scsi_abort_command() is only invoked from the SCSI
timeout handler. If scsi_abort_command() is invoked for a SCSI
command with the SCSI_EH_ABORT_SCHEDULED flag set this means that
scmd_eh_abort_handler() has already invoked scsi_queue_insert() and
hence that scsi_cmnd.abort_work is no longer pending. Hence also
remove the cancel_delayed_work() call from scsi_abort_command().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/scsi.c       | 2 +-
 drivers/scsi/scsi_error.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..c972eab 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -334,7 +334,7 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 	list_del_init(&cmd->list);
 	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
 
-	cancel_delayed_work(&cmd->abort_work);
+	WARN_ON_ONCE(delayed_work_pending(&cmd->abort_work));
 
 	__scsi_put_command(cmd->device->host, cmd);
 }
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f17aa7a..5232583 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -193,7 +193,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "scmd %p previous abort failed\n", scmd));
-		cancel_delayed_work(&scmd->abort_work);
+		WARN_ON_ONCE(delayed_work_pending(&scmd->abort_work));
 		return FAILED;
 	}
 
-- 
1.8.4.5

