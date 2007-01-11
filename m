From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 10/21] libsas: Remove SAS_TASK_INITIATOR_ABORTED flag
Date: Thu, 11 Jan 2007 14:15:15 -0800
Message-ID: <20070111221515.3543.54614.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39859 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbXAKWOz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:55 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMEtbD015298
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:55 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMEtfv284324
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:55 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMEs4V017551
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:54 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


This flag is no longer necessary because we push tasks to be aborted into
the EH as soon as we possibly can, and let the SCSI EH code take care of
the coordination for which this flag was used.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |   17 -----------------
 include/scsi/libsas.h               |    1 -
 2 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 3f647c6..f90c332 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -310,15 +310,6 @@ static enum task_disposition sas_scsi_fi
 		spin_unlock_irqrestore(&core->task_queue_lock, flags);
 	}
 
-	spin_lock_irqsave(&task->task_state_lock, flags);
-	if (task->task_state_flags & SAS_TASK_INITIATOR_ABORTED) {
-		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		SAS_DPRINTK("%s: task 0x%p already aborted\n",
-			    __FUNCTION__, task);
-		return TASK_IS_ABORTED;
-	}
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
-
 	for (i = 0; i < 5; i++) {
 		SAS_DPRINTK("%s: aborting task 0x%p\n", __FUNCTION__, task);
 		res = si->dft->lldd_abort_task(task);
@@ -534,12 +525,6 @@ enum scsi_eh_timer_return sas_scsi_timed
 	}
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
-	if (task->task_state_flags & SAS_TASK_INITIATOR_ABORTED) {
-		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		SAS_DPRINTK("command 0x%p, task 0x%p, aborted by initiator: "
-			    "EH_NOT_HANDLED\n", cmd, task);
-		return EH_NOT_HANDLED;
-	}
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		SAS_DPRINTK("command 0x%p, task 0x%p, timed out: EH_HANDLED\n",
@@ -826,7 +811,6 @@ static int do_sas_task_abort(struct sas_
 		return 0;
 	}
 
-	task->task_state_flags |= SAS_TASK_INITIATOR_ABORTED;
 	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
 		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -849,7 +833,6 @@ static int do_sas_task_abort(struct sas_
 	}
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
-	task->task_state_flags &= ~SAS_TASK_INITIATOR_ABORTED;
 	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
 		task->task_state_flags &= ~SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 0689d66..1d39485 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -553,7 +553,6 @@ struct sas_task {
 #define SAS_TASK_STATE_PENDING      1
 #define SAS_TASK_STATE_DONE         2
 #define SAS_TASK_STATE_ABORTED      4
-#define SAS_TASK_INITIATOR_ABORTED  8
 #define SAS_TASK_AT_INITIATOR       16
 
 static inline struct sas_task *sas_alloc_task(gfp_t flags)
