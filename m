From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 1/5] scsi abort
Date: Fri, 12 Sep 2008 20:59:11 +0200
Message-ID: <200809122059.12060.bs@q-leap.de>
References: <200809122057.41565.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:41590 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbYILS7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2008 14:59:16 -0400
In-Reply-To: <200809122057.41565.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, Sathya Prakash <Sathya.Prakash@lsi.com>

For some (unknown) reasons, on task aborts the mptscsih_TMHandler() will
cause trouble on the second port of dual port 53C1030 based HBAs.
The mptscsih_IssueTaskMgmt() function takes the same arguments as 
mptscsih_TMHandler() but doesn't have this issue.
This is a backport of the fusion-4.x driver from LSI.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

 drivers/message/fusion/mptscsih.c |   55 ++++++++++++++++++----------
  1 file changed, 37 insertions(+), 18 deletions(-)


Index: linux-2.6.26/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptscsih.c
+++ linux-2.6.26/drivers/message/fusion/mptscsih.c
@@ -1810,7 +1810,22 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		    ioc->name, SCpnt));
 		SCpnt->result = DID_NO_CONNECT << 16;
 		SCpnt->scsi_done(SCpnt);
-		retval = 0;
+		retval = SUCCESS;
+		goto out;
+	}
+
+	/* Find this command
+	 */
+	scpnt_idx = SCPNT_TO_LOOKUP_IDX(ioc, SCpnt);
+	if (scpnt_idx < 0) {
+		/* Cmd not found in ScsiLookup.
+		 * Do OS callback.
+		 */
+		SCpnt->result = DID_RESET << 16;
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: command not in the active list! (sc=%p)\n",
+		    ioc->name, SCpnt));
+		retval = SUCCESS;
 		goto out;
 	}
 
@@ -1825,21 +1840,16 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		goto out;
 	}
 
-	/* Find this command
+	/* Task aborts are not supported for volumes.
 	 */
-	if ((scpnt_idx = SCPNT_TO_LOOKUP_IDX(ioc, SCpnt)) < 0) {
-		/* Cmd not found in ScsiLookup.
-		 * Do OS callback.
-		 */
+	if (vdevice->vtarget->raidVolume) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: raid volume (sc=%p)\n",
+		    ioc->name, SCpnt));
 		SCpnt->result = DID_RESET << 16;
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: "
 		   "Command not in the active list! (sc=%p)\n", ioc->name,
 		   SCpnt));
-		retval = 0;
-		goto out;
-	}
-
-	if (hd->resetPending) {
 		retval = FAILED;
 		goto out;
 	}
@@ -1859,22 +1869,31 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 	hd->abortSCpnt = SCpnt;
 
-	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
+	mptscsih_IssueTaskMgmt(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 	    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun,
 	    ctx2abort, mptscsih_get_tm_timeout(ioc));
 
+	/* check to see whether command actually completed and/or
+	 * terminated
+	 */
 	if (SCPNT_TO_LOOKUP_IDX(ioc, SCpnt) == scpnt_idx &&
-	    SCpnt->serial_number == sn)
+	    SCpnt->serial_number == sn) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: command still in active list! (sc=%p)\n",
+		    ioc->name, SCpnt));
 		retval = FAILED;
+	} else {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: command cleared from active list! (sc=%p)\n",
+		    ioc->name, SCpnt));
+		retval = SUCCESS;
+	}
 
  out:
 	printk(MYIOC_s_INFO_FMT "task abort: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), SCpnt);
 
-	if (retval == 0)
-		return SUCCESS;
-	else
-		return FAILED;
+	return retval;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
