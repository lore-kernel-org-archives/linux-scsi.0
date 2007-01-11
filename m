From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 03/21] libsas: Don't give scsi_cmnds to the EH if they never made it to the SAS LLDD or have already returned
Date: Thu, 11 Jan 2007 14:14:55 -0800
Message-ID: <20070111221455.3543.53564.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38774 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbXAKWOf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:35 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMEZVA014869
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:35 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMEZbv201950
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:35 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMEYKL016680
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:34 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


On a system with many SAS targets, it appears possible that a scsi_cmnd
can time out without ever making it to the SAS LLDD or at the same time
that a completion is occurring.  In both of these cases, telling the
LLDD to abort the sas_task makes no sense because the LLDD won't know
about the sas_task; what we really want to do is to increase the timer.
Note that this involves creating another sas_task bit to indicate
whether or not the task has been sent to the LLDD; I could have
implemented this by slightly redefining SAS_TASK_STATE_PENDING, but
this way seems cleaner.

This second version amends the aic94xx portion to set the
TASK_AT_INITIATOR flag for all sas_tasks that were passed to
lldd_execute_task.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_task.c |    9 +++++++++
 drivers/scsi/libsas/sas_scsi_host.c |    7 +++++++
 include/scsi/libsas.h               |    1 +
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index d202ed5..e2ad5be 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -349,6 +349,7 @@ Again:
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	task->task_state_flags &= ~SAS_TASK_STATE_PENDING;
+	task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((task->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -557,6 +558,7 @@ int asd_execute_task(struct sas_task *ta
 	struct sas_task *t = task;
 	struct asd_ascb *ascb = NULL, *a;
 	struct asd_ha_struct *asd_ha = task->dev->port->ha->lldd_ha;
+	unsigned long flags;
 
 	res = asd_can_queue(asd_ha, num);
 	if (res)
@@ -599,6 +601,10 @@ int asd_execute_task(struct sas_task *ta
 		}
 		if (res)
 			goto out_err_unmap;
+
+		spin_lock_irqsave(&t->task_state_lock, flags);
+		t->task_state_flags |= SAS_TASK_AT_INITIATOR;
+		spin_unlock_irqrestore(&t->task_state_lock, flags);
 	}
 	list_del_init(&alist);
 
@@ -617,6 +623,9 @@ out_err_unmap:
 			if (a == b)
 				break;
 			t = a->uldd_task;
+			spin_lock_irqsave(&t->task_state_lock, flags);
+			t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
+			spin_unlock_irqrestore(&t->task_state_lock, flags);
 			switch (t->task_proto) {
 			case SATA_PROTO:
 			case SAS_PROTO_STP:
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 22672d5..21bd247 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -542,6 +542,13 @@ enum scsi_eh_timer_return sas_scsi_timed
 			    cmd, task);
 		return EH_HANDLED;
 	}
+	if (!(task->task_state_flags & SAS_TASK_AT_INITIATOR)) {
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
+		SAS_DPRINTK("command 0x%p, task 0x%p, not at initiator: "
+			    "EH_RESET_TIMER\n",
+			    cmd, task);
+		return EH_RESET_TIMER;
+	}
 	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 0c775fc..da96bcf 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -554,6 +554,7 @@ #define SAS_TASK_STATE_PENDING      1
 #define SAS_TASK_STATE_DONE         2
 #define SAS_TASK_STATE_ABORTED      4
 #define SAS_TASK_INITIATOR_ABORTED  8
+#define SAS_TASK_AT_INITIATOR       16
 
 static inline struct sas_task *sas_alloc_task(gfp_t flags)
 {
