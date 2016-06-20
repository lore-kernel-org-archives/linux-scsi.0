From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] scsi: make eh_eflags persistent
Date: Mon, 20 Jun 2016 11:35:38 +0200
Message-ID: <1466415340-104465-4-git-send-email-hare@suse.de>
References: <1466415340-104465-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbcFTJf5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 05:35:57 -0400
In-Reply-To: <1466415340-104465-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

To detect if a failed command has been retried we must not
clear scmd->eh_eflags when EH finishes.
The flag should be persistent throughout the lifetime
of the command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/scsi/scsi_eh.txt | 3 ---
 drivers/scsi/scsi_error.c      | 4 ++--
 include/scsi/scsi_eh.h         | 1 +
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index 8638f61..745eed5 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -264,7 +264,6 @@ scmd->allowed.
  3. scmd recovered
     ACTION: scsi_eh_finish_cmd() is invoked to EH-finish scmd
 	- shost->host_failed--
-	- clear scmd->eh_eflags
 	- scsi_setup_cmd_retry()
 	- move from local eh_work_q to local eh_done_q
     LOCKING: none
@@ -452,8 +451,6 @@ except for #1 must be implemented by eh_strategy_handler().
 
  - shost->host_failed is zero.
 
- - Each scmd's eh_eflags field is cleared.
-
  - Each scmd is in such a state that scsi_setup_cmd_retry() on the
    scmd doesn't make any difference.
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index deb35737..eb0f19f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -182,7 +182,6 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		/*
 		 * Retry after abort failed, escalate to next level.
 		 */
-		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "previous abort failed\n"));
@@ -919,6 +918,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->result = scmd->result;
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
+	ses->eh_eflags = scmd->eh_eflags;
 
 	scmd->prot_op = SCSI_PROT_NORMAL;
 	scmd->eh_eflags = 0;
@@ -982,6 +982,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->result = ses->result;
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
+	scmd->eh_eflags = ses->eh_eflags;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
 
@@ -1115,7 +1116,6 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
 void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
 {
 	scmd->device->host->host_failed--;
-	scmd->eh_eflags = 0;
 	list_move_tail(&scmd->eh_entry, done_q);
 }
 EXPORT_SYMBOL(scsi_eh_finish_cmd);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index dbb8c64..f2f876c 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -30,6 +30,7 @@ extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 struct scsi_eh_save {
 	/* saved state */
 	int result;
+	int eh_eflags;
 	enum dma_data_direction data_direction;
 	unsigned underflow;
 	unsigned char cmd_len;
-- 
1.8.5.6

