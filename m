From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 13/21] aic94xx: Remove workqueue code from REQ_TASK_ABORT/REQ_DEVICE_RESET code
Date: Thu, 11 Jan 2007 14:15:23 -0800
Message-ID: <20070111221523.3543.9150.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35478 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbXAKWPF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:15:05 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMF3uZ026324
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:03 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMF3Ol279876
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:03 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMF3oT002869
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:03 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Now that task aborts and device port resets are done by the EH, we can
remove all the code that set up workqueues and such and simply call
sas_task_abort and let libsas figure things out.
---

 drivers/scsi/aic94xx/aic94xx_scb.c |  122 +++++++++++++++++++-----------------
 1 files changed, 66 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 75ed6b0..8f43ff7 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -413,40 +413,6 @@ void asd_invalidate_edb(struct asd_ascb 
 	}
 }
 
-/* hard reset a phy later */
-static void do_phy_reset_later(struct work_struct *work)
-{
-	struct sas_phy *sas_phy =
-		container_of(work, struct sas_phy, reset_work);
-	int error;
-
-	ASD_DPRINTK("%s: About to hard reset phy %d\n", __FUNCTION__,
-		    sas_phy->identify.phy_identifier);
-	/* Reset device port */
-	error = sas_phy_reset(sas_phy, 1);
-	if (error)
-		ASD_DPRINTK("%s: Hard reset of phy %d failed (%d).\n",
-			    __FUNCTION__, sas_phy->identify.phy_identifier, error);
-}
-
-static void phy_reset_later(struct sas_phy *sas_phy, struct Scsi_Host *shost)
-{
-	INIT_WORK(&sas_phy->reset_work, do_phy_reset_later);
-	queue_work(shost->work_q, &sas_phy->reset_work);
-}
-
-/* start up the ABORT TASK tmf... */
-static void task_kill_later(struct asd_ascb *ascb)
-{
-	struct asd_ha_struct *asd_ha = ascb->ha;
-	struct sas_ha_struct *sas_ha = &asd_ha->sas_ha;
-	struct Scsi_Host *shost = sas_ha->core.shost;
-	struct sas_task *task = ascb->uldd_task;
-
-	INIT_WORK(&task->abort_work, sas_task_abort);
-	queue_work(shost->work_q, &task->abort_work);
-}
-
 static void escb_tasklet_complete(struct asd_ascb *ascb,
 				  struct done_list_struct *dl)
 {
@@ -479,26 +445,55 @@ static void escb_tasklet_complete(struct
 	case REQ_TASK_ABORT: {
 		struct asd_ascb *a, *b;
 		u16 tc_abort;
+		struct domain_device *failed_dev = NULL;
+
+		ASD_DPRINTK("%s: REQ_TASK_ABORT, reason=0x%X\n",
+			    __FUNCTION__, dl->status_block[3]);
 
+		/*
+		 * Find the task that caused the abort and abort it first.
+		 * The sequencer won't put anything on the done list until
+		 * that happens.
+		 */
 		tc_abort = *((u16*)(&dl->status_block[1]));
 		tc_abort = le16_to_cpu(tc_abort);
 
-		ASD_DPRINTK("%s: REQ_TASK_ABORT, reason=0x%X\n",
-			    __FUNCTION__, dl->status_block[3]);
+		list_for_each_entry_safe(a, b, &asd_ha->seq.pend_q, list) {
+			struct sas_task *task = ascb->uldd_task;
 
-		/* Find the pending task and abort it. */
-		list_for_each_entry_safe(a, b, &asd_ha->seq.pend_q, list)
-			if (a->tc_index == tc_abort) {
-				task_kill_later(a);
+			if (task && a->tc_index == tc_abort) {
+				failed_dev = task->dev;
+				sas_task_abort(task);
 				break;
 			}
+		}
+
+		if (!failed_dev) {
+			ASD_DPRINTK("%s: Can't find task (tc=%d) to abort!\n",
+				    __FUNCTION__, tc_abort);
+			goto out;
+		}
+
+		/*
+		 * Now abort everything else for that device (hba?) so
+		 * that the EH will wake up and do something.
+		 */
+		list_for_each_entry_safe(a, b, &asd_ha->seq.pend_q, list) {
+			struct sas_task *task = ascb->uldd_task;
+
+			if (task &&
+			    task->dev == failed_dev &&
+			    a->tc_index != tc_abort)
+				sas_task_abort(task);
+		}
+
 		goto out;
 	}
 	case REQ_DEVICE_RESET: {
-		struct Scsi_Host *shost = sas_ha->core.shost;
-		struct sas_phy *dev_phy;
 		struct asd_ascb *a;
 		u16 conn_handle;
+		unsigned long flags;
+		struct sas_task *last_dev_task = NULL;
 
 		conn_handle = *((u16*)(&dl->status_block[1]));
 		conn_handle = le16_to_cpu(conn_handle);
@@ -506,32 +501,47 @@ static void escb_tasklet_complete(struct
 		ASD_DPRINTK("%s: REQ_DEVICE_RESET, reason=0x%X\n", __FUNCTION__,
 			    dl->status_block[3]);
 
-		/* Kill all pending tasks and reset the device */
-		dev_phy = NULL;
+		/* Find the last pending task for the device... */
 		list_for_each_entry(a, &asd_ha->seq.pend_q, list) {
-			struct sas_task *task;
-			struct domain_device *dev;
 			u16 x;
+			struct domain_device *dev;
+			struct sas_task *task = a->uldd_task;
 
-			task = a->uldd_task;
 			if (!task)
 				continue;
 			dev = task->dev;
 
 			x = (unsigned long)dev->lldd_dev;
-			if (x == conn_handle) {
-				dev_phy = dev->port->phy;
-				task_kill_later(a);
-			}
+			if (x == conn_handle)
+				last_dev_task = task;
 		}
 
-		/* Reset device port */
-		if (!dev_phy) {
-			ASD_DPRINTK("%s: No pending commands; can't reset.\n",
-				    __FUNCTION__);
+		if (!last_dev_task) {
+			ASD_DPRINTK("%s: Device reset for idle device %d?\n",
+				    __FUNCTION__, conn_handle);
 			goto out;
 		}
-		phy_reset_later(dev_phy, shost);
+
+		/* ...and set the reset flag */
+		spin_lock_irqsave(&last_dev_task->task_state_lock, flags);
+		last_dev_task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
+		spin_unlock_irqrestore(&last_dev_task->task_state_lock, flags);
+
+		/* Kill all pending tasks for the device */
+		list_for_each_entry(a, &asd_ha->seq.pend_q, list) {
+			u16 x;
+			struct domain_device *dev;
+			struct sas_task *task = a->uldd_task;
+
+			if (!task)
+				continue;
+			dev = task->dev;
+
+			x = (unsigned long)dev->lldd_dev;
+			if (x == conn_handle)
+				sas_task_abort(task);
+		}
+
 		goto out;
 	}
 	case SIGNAL_NCQ_ERROR:
