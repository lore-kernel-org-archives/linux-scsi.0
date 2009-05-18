From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 3/5] mpt2sas: add query task support for MPT2COMMAND  ioctl
Date: Mon, 18 May 2009 13:01:29 -0600
Message-ID: <20090518190127.GD26609@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:33371 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZERSzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2009 14:55:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

This patch will find an active mid for a query_task request via the ioctl path.

This code is already there for task_abort, so this patch combining code using
the same fuction _ctl_set_task_mid(), previously _ctl_do_task_abort().

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c	2009-05-18 12:23:24.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c	2009-05-18 12:23:24.000000000 -0600
@@ -473,7 +473,7 @@ _ctl_poll(struct file *filep, poll_table
 }
 
 /**
- * _ctl_do_task_abort - assign an active smid to the abort_task
+ * _ctl_set_task_mid - assign an active smid to tm request
  * @ioc: per adapter object
  * @karg - (struct mpt2_ioctl_command)
  * @tm_request - pointer to mf from user space
@@ -482,7 +482,7 @@ _ctl_poll(struct file *filep, poll_table
  * during failure, the reply frame is filled.
  */
 static int
-_ctl_do_task_abort(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
+_ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
     Mpi2SCSITaskManagementRequest_t *tm_request)
 {
 	u8 found = 0;
@@ -494,6 +494,14 @@ _ctl_do_task_abort(struct MPT2SAS_ADAPTE
 	Mpi2SCSITaskManagementReply_t *tm_reply;
 	u32 sz;
 	u32 lun;
+	char *desc = NULL;
+
+	if (tm_request->TaskType == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
+		desc = "abort_task";
+	else if (tm_request->TaskType == MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK)
+		desc = "query_task";
+	else
+		return 0;
 
 	lun = scsilun_to_int((struct scsi_lun *)tm_request->LUN);
 
@@ -517,13 +525,13 @@ _ctl_do_task_abort(struct MPT2SAS_ADAPTE
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 	if (!found) {
-		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "ABORT_TASK: "
-		    "DevHandle(0x%04x), lun(%d), no active mid!!\n", ioc->name,
-		    tm_request->DevHandle, lun));
+		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "handle(0x%04x), lun(%d), no active mid!!\n", ioc->name,
+		    desc, tm_request->DevHandle, lun));
 		tm_reply = ioc->ctl_cmds.reply;
 		tm_reply->DevHandle = tm_request->DevHandle;
 		tm_reply->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
-		tm_reply->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK;
+		tm_reply->TaskType = tm_request->TaskType;
 		tm_reply->MsgLength = sizeof(Mpi2SCSITaskManagementReply_t)/4;
 		tm_reply->VP_ID = tm_request->VP_ID;
 		tm_reply->VF_ID = tm_request->VF_ID;
@@ -535,9 +543,9 @@ _ctl_do_task_abort(struct MPT2SAS_ADAPTE
 		return 1;
 	}
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "ABORT_TASK: "
-	    "DevHandle(0x%04x), lun(%d), smid(%d)\n", ioc->name,
-	    tm_request->DevHandle, lun, tm_request->TaskMID));
+	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+	    "handle(0x%04x), lun(%d), task_mid(%d)\n", ioc->name,
+	    desc, tm_request->DevHandle, lun, tm_request->TaskMID));
 	return 0;
 }
 
@@ -739,8 +747,10 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPT
 		    (Mpi2SCSITaskManagementRequest_t *)mpi_request;
 
 		if (tm_request->TaskType ==
-		    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
-			if (_ctl_do_task_abort(ioc, &karg, tm_request)) {
+		    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK ||
+		    tm_request->TaskType ==
+		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK) {
+			if (_ctl_set_task_mid(ioc, &karg, tm_request)) {
 				mpt2sas_base_free_smid(ioc, smid);
 				goto out;
 			}
