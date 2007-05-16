From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] aic94xx: asd_clear_nexus should fail if the cleared task does not complete
Date: Wed, 16 May 2007 14:01:48 -0700
Message-ID: <20070516210148.GH9936@tree>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38710 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934138AbXEPVAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2007 17:00:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, "Tan, Dennis" <Dennis_Tan@adaptec.com>, Alexis Bruemmer <alexisb@us.ibm.com>, "Chim, Ed" <ed_chim@adaptec.com>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Every so often, the driver will call asd_clear_nexus to clean out a task.
It is supposed to be the case that the CLEAR NEXUS does not go on the done
list until after the task itself has been put on the done list, but for
some reason this doesn't always happen.  Thus, the
wait_for_completion_timeout call times out, and we return success.  This
makes libsas free the task even though the task hasn't completed, leading
to a BUG_ON message from aic94xx_hwi.c around line 341.  We should return
failure from asd_clear_nexus so that libsas tries again; at a bare minimum
it shouldn't be freeing active tasks.  I _think_ this will fix one of
the SCB timeout crash problems (though I've not been able to reproduce
it lately...)

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_tmf.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 9a14a6d..c0d0b7d 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -290,6 +290,7 @@ static void asd_tmf_tasklet_complete(str
 static inline int asd_clear_nexus(struct sas_task *task)
 {
 	int res = TMF_RESP_FUNC_FAILED;
+	int leftover;
 	struct asd_ascb *tascb = task->lldd_task;
 	unsigned long flags;
 
@@ -298,10 +299,12 @@ static inline int asd_clear_nexus(struct
 		res = asd_clear_nexus_tag(task);
 	else
 		res = asd_clear_nexus_index(task);
-	wait_for_completion_timeout(&tascb->completion,
-				    AIC94XX_SCB_TIMEOUT);
+	leftover = wait_for_completion_timeout(&tascb->completion,
+					       AIC94XX_SCB_TIMEOUT);
 	ASD_DPRINTK("came back from clear nexus\n");
 	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (leftover < 1)
+		res = TMF_RESP_FUNC_FAILED;
 	if (task->task_state_flags & SAS_TASK_STATE_DONE)
 		res = TMF_RESP_FUNC_COMPLETE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -350,6 +353,7 @@ int asd_abort_task(struct sas_task *task
 	unsigned long flags;
 	struct asd_ascb *ascb = NULL;
 	struct scb *scb;
+	int leftover;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
@@ -455,9 +459,11 @@ int asd_abort_task(struct sas_task *task
 		break;
 	case TF_TMF_TASK_DONE + 0xFF00:	/* done but not reported yet */
 		res = TMF_RESP_FUNC_FAILED;
-		wait_for_completion_timeout(&tascb->completion,
-					    AIC94XX_SCB_TIMEOUT);
+		leftover = wait_for_completion_timeout(&tascb->completion,
+						       AIC94XX_SCB_TIMEOUT);
 		spin_lock_irqsave(&task->task_state_lock, flags);
+		if (leftover < 1)
+			res = TMF_RESP_FUNC_FAILED;
 		if (task->task_state_flags & SAS_TASK_STATE_DONE)
 			res = TMF_RESP_FUNC_COMPLETE;
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
