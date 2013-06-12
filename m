From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v11 8/9] Save and restore host_scribble during error handling
Date: Wed, 12 Jun 2013 14:57:16 +0200
Message-ID: <51B8702C.6030508@acm.org>
References: <51B86E26.6030108@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:50437 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3FLM5R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 08:57:17 -0400
In-Reply-To: <51B86E26.6030108@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>

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
index 2c99eab..728d573 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -771,6 +771,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->result = scmd->result;
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
+	ses->host_scribble = scmd->host_scribble;
 
 	scmd->prot_op = SCSI_PROT_NORMAL;
 	scmd->cmnd = ses->eh_cmnd;
@@ -832,6 +833,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
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

