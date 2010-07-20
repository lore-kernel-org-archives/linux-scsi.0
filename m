From: akpm@linux-foundation.org
Subject: [patch 26/27] drivers/scsi/mvsas/mv_sas.c: fix potential NULL dereference
Date: Tue, 20 Jul 2010 15:29:05 -0700
Message-ID: <201007202229.o6KMT50l021800@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932884Ab0GTW3w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:29:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz, James.Bottomley@suse.de, satyasrinivasp@hcl.in

From: Jiri Slaby <jslaby@suse.cz>

Stanse found that in mvs_abort_task, mvi_dev is dereferenced earlier than
tested for being NULL.  Move the assignment below the test.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Srinivas <satyasrinivasp@hcl.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mvsas/mv_sas.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/mvsas/mv_sas.c~scsi-mvsas-fix-potential-null-dereference drivers/scsi/mvsas/mv_sas.c
--- a/drivers/scsi/mvsas/mv_sas.c~scsi-mvsas-fix-potential-null-dereference
+++ a/drivers/scsi/mvsas/mv_sas.c
@@ -1640,7 +1640,7 @@ int mvs_abort_task(struct sas_task *task
 	struct mvs_tmf_task tmf_task;
 	struct domain_device *dev = task->dev;
 	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
-	struct mvs_info *mvi = mvi_dev->mvi_info;
+	struct mvs_info *mvi;
 	int rc = TMF_RESP_FUNC_FAILED;
 	unsigned long flags;
 	u32 tag;
@@ -1650,6 +1650,8 @@ int mvs_abort_task(struct sas_task *task
 		rc = TMF_RESP_FUNC_FAILED;
 	}
 
+	mvi = mvi_dev->mvi_info;
+
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
_
