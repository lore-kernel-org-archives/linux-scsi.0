From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/3] Make SCSI error handler code easier to understand
Date: Mon, 26 May 2014 17:15:41 +0200
Message-ID: <53835A9D.3090104@acm.org>
References: <538359DB.9080601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:46934 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaEZPPm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 May 2014 11:15:42 -0400
In-Reply-To: <538359DB.9080601@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Joe Lawrence <jdl1291@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Every now and then someone asks how it is avoided that the SCSI error
handler and the SCSI completion handler are invoked concurrently for
the same SCSI command. Add a few WARN_ON_ONCE() statements that make
it clear how this is avoided.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/scsi_error.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5232583..aee0dc0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -120,6 +120,8 @@ scmd_eh_abort_handler(struct work_struct *work)
 	struct scsi_device *sdev = scmd->device;
 	int rtn;
 
+	WARN_ON_ONCE(!blk_rq_completed(scmd->request));
+
 	if (scsi_host_eh_past_deadline(sdev->host)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
@@ -185,6 +187,8 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 
+	WARN_ON_ONCE(!blk_rq_completed(scmd->request));
+
 	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
 		/*
 		 * Retry after abort failed, escalate to next level.
@@ -237,6 +241,8 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 	unsigned long flags;
 	int ret = 0;
 
+	WARN_ON_ONCE(!blk_rq_completed(scmd->request));
+
 	if (!shost->ehandler)
 		return 0;
 
-- 
1.8.4.5

