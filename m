From: <kashyap.desai@lsi.com>
Subject: [PATCH] RESEND mptfusion: Fix for device offline while doing
 aggressive HBA reset
Date: Fri, 5 Aug 2011 11:04:37 +0530
Message-ID: <201108050513.p755DRFn002220@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57294 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150Ab1HEFNd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2011 01:13:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com, JBottomley@parallels.com

[Resend patch as per Bernd Schubert comment ]
Issue: 
Device goes offline while doing aggressive HBA reset 
along with IO using some utility.

Root cause:
FW goes into bad state due to aggressive reset. Softreset does
not help to recover FW. And also aggressive reset open up the
window for Error handling thread to kicked off at the same time
HBA will be in constant RESET loop as part of aggressive reset
test case can lead Device to goes offline.

Changes: 
1. Added extra check as below inside eh_timed_out call back as below.
if(ioc->ioc_reset_in_progress)
    Rc = EH_TIMER_RESET                                          
2. Removed " DOORBELL_ACTIVE" check for SAS controller from task management context.
   Since SAS controller uses high priority queue for task management. This check is 
   not required for SAS controller.
3. Moved SoftReset call to HardReset from Task Mgmt context.
   
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 517621f..e9c6a60 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6474,8 +6474,19 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 			pReq->Action, ioc->mptbase_cmds.status, timeleft));
 		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
 			goto out;
-		if (!timeleft)
+		if (!timeleft) {
+			spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+			if (ioc->ioc_reset_in_progress) {
+				spin_unlock_irqrestore(&ioc->taskmgmt_lock,
+					flags);
+				printk(MYIOC_s_INFO_FMT "%s: host reset in"
+					" progress mpt_config timed out.!!\n",
+					__func__, ioc->name);
+				return -EFAULT;
+			}
+			spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 			issue_hard_reset = 1;
+		}
 		goto out;
 	}
 
@@ -7189,7 +7200,18 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
 	if (ioc->ioc_reset_in_progress) {
 		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
-		return 0;
+		ioc->wait_on_reset_completion = 1;
+		do {
+			ssleep(1);
+		} while (ioc->ioc_reset_in_progress == 1);
+		ioc->wait_on_reset_completion = 0;
+		return ioc->reset_status;
+	}
+	if (ioc->wait_on_reset_completion) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		rc = 0;
+		time_count = jiffies;
+		goto exit;
 	}
 	ioc->ioc_reset_in_progress = 1;
 	if (ioc->alt_ioc)
@@ -7226,6 +7248,7 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	ioc->ioc_reset_in_progress = 0;
 	ioc->taskmgmt_quiesce_io = 0;
 	ioc->taskmgmt_in_progress = 0;
+	ioc->reset_status = rc;
 	if (ioc->alt_ioc) {
 		ioc->alt_ioc->ioc_reset_in_progress = 0;
 		ioc->alt_ioc->taskmgmt_quiesce_io = 0;
@@ -7241,7 +7264,7 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 					ioc->alt_ioc, MPT_IOC_POST_RESET);
 		}
 	}
-
+exit:
 	dtmprintk(ioc,
 	    printk(MYIOC_s_DEBUG_FMT
 		"HardResetHandler: completed (%d seconds): %s\n", ioc->name,
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 69ddabd..66e6f7b 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -753,6 +753,8 @@ typedef struct _MPT_ADAPTER
 	int			 taskmgmt_in_progress;
 	u8			 taskmgmt_quiesce_io;
 	u8			 ioc_reset_in_progress;
+	u8			 reset_status;
+	u8			 wait_on_reset_completion;
 	MPT_SCHEDULE_TARGET_RESET schedule_target_reset;
 	MPT_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
 	struct work_struct	 sas_persist_task;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 074e522..9d95042 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1950,6 +1950,15 @@ static enum blk_eh_timer_return mptsas_eh_timed_out(struct scsi_cmnd *sc)
 		goto done;
 	}
 
+	/* In case if IOC is in reset from internal context.
+	*  Do not execute EEH for the same IOC. SML should to reset timer.
+	*/
+	if (ioc->ioc_reset_in_progress) {
+		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT ": %s: ioc is in reset,"
+		    "SML need to reset the timer (sc=%p)\n",
+		    ioc->name, __func__, sc));
+		rc = BLK_EH_RESET_TIMER;
+	}
 	vdevice = sc->device->hostdata;
 	if (vdevice && vdevice->vtarget && (vdevice->vtarget->inDMD
 		|| vdevice->vtarget->deleted)) {
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index c9a7109..35ff3de 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1630,7 +1630,13 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun,
 		return 0;
 	}
 
-	if (ioc_raw_state & MPI_DOORBELL_ACTIVE) {
+	/* DOORBELL ACTIVE check is not required if
+	*  MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q is supported.
+	*/
+
+	if (!((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q)
+		 && (ioc->facts.MsgVersion >= MPI_VERSION_01_05)) &&
+		(ioc_raw_state & MPI_DOORBELL_ACTIVE)) {
 		printk(MYIOC_s_WARN_FMT
 			"TaskMgmt type=%x: ioc_state: "
 			"DOORBELL_ACTIVE (0x%x)!\n",
@@ -1729,7 +1735,9 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun,
 		printk(MYIOC_s_WARN_FMT
 		       "Issuing Reset from %s!! doorbell=0x%08x\n",
 		       ioc->name, __func__, mpt_GetIocState(ioc, 0));
-		retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+		retval = (ioc->bus_type == SAS) ? 
+			mpt_HardResetHandler(ioc, CAN_SLEEP):
+			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
 		mpt_free_msg_frame(ioc, mf);
 	}
 
