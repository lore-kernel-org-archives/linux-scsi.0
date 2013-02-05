From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v8 10/10] Save and restore host_scribble during error handling
Date: Tue, 05 Feb 2013 13:51:55 +0100
Message-ID: <5111006B.6030708@acm.org>
References: <5110FE98.8030209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:41694 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3BEMv4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2013 07:51:56 -0500
In-Reply-To: <5110FE98.8030209@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

A SCSI LLD may overwrite host_scribble in its queuecommand()
implementation. Several drivers need that field to process
requests and aborts correctly. Hence this field must be saved
by scsi_eh_prep_cmnd() and must be restored by
scsi_eh_restore_cmnd().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi_error.c |    2 ++
 include/scsi/scsi_eh.h    |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d50af13..a4a9ec9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -769,6 +769,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->result = scmd->result;
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
+	ses->host_scribble = scmd->host_scribble;
 
 	scmd->prot_op = SCSI_PROT_NORMAL;
 	scmd->cmnd = ses->eh_cmnd;
@@ -830,6 +831,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->result = ses->result;
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
+	scmd->host_scribble = ses->host_scribble;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 06a8790..7bdb02f 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -83,6 +83,7 @@ struct scsi_eh_save {
 	/* new command support */
 	unsigned char eh_cmnd[BLK_MAX_CDB];
 	struct scatterlist sense_sgl;
+	unsigned char *host_scribble;
 };
 
 extern void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
-- 
1.7.10.4

