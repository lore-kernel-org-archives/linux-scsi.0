From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 7/7] mptfusion: tweak null pointer checks
Date: Wed, 4 Jun 2014 12:52:26 -0400
Message-ID: <1401900747-19894-1-git-send-email-joe.lawrence@stratus.com>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:58881 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFDQwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 12:52:32 -0400
In-Reply-To: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

Fixes the following smatch warnings:

  drivers/message/fusion/mptbase.c:652 mptbase_reply() warn: variable
    dereferenced before check 'reply' (see line 639)

  drivers/message/fusion/mptsas.c:1255 mptsas_taskmgmt_complete() error:
    we previously assumed 'pScsiTmReply' could be null (see line 1227)


  drivers/message/fusion/mptsas.c:3888 mptsas_not_responding_devices()
    error: we previously assumed 'port_info->phy_info' could be null
    (see line 3875)

  drivers/message/fusion/mptscsih.c:1284 mptscsih_info() error:
    we previously assumed 'h' could be null (see line 1274)

  drivers/message/fusion/mptscsih.c:1388 mptscsih_qcmd() error: we
    previously assumed 'vdevice' could be null (see line 1373)

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

JL: Comments on the above warnings, in order:

    No-brainer, the enclosing switch statement dereferences 'reply',
    so we can't get here unless 'reply' is valid.

    "Retry target reset" needs to know the target ID and channel, so
    enclose that entire block inside a if (pScsiTmReply) block.

    The code before the loop checks for 'port_info->phy_info', but not
    many other places in the driver bother.  Not sure what to do here.

    'hostdata' is checked and then immediately dereferenced after
    that block.  How about a default return string of "N/A" to indicate
    one isn't available? 

    Not sure what to do here.  'vdevice' is needed to "set up the
    message frame" target ID and channel, so it should probably return
    an error in in this case.

 drivers/message/fusion/mptbase.c  |   10 ++++------
 drivers/message/fusion/mptsas.c   |   27 ++++++++++++++-------------
 drivers/message/fusion/mptscsih.c |    7 ++++---
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 03263d6..c68a951 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -649,12 +649,10 @@ mptbase_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 	case MPI_FUNCTION_CONFIG:
 	case MPI_FUNCTION_SAS_IO_UNIT_CONTROL:
 		ioc->mptbase_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
-		if (reply) {
-			ioc->mptbase_cmds.status |= MPT_MGMT_STATUS_RF_VALID;
-			memcpy(ioc->mptbase_cmds.reply, reply,
-			    min(MPT_DEFAULT_FRAME_SIZE,
-				4 * reply->u.reply.MsgLength));
-		}
+		ioc->mptbase_cmds.status |= MPT_MGMT_STATUS_RF_VALID;
+		memcpy(ioc->mptbase_cmds.reply, reply,
+		    min(MPT_DEFAULT_FRAME_SIZE,
+			4 * reply->u.reply.MsgLength));
 		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_PENDING) {
 			ioc->mptbase_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
 			complete(&ioc->mptbase_cmds.done);
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 35c87b1..72e464fc 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1252,17 +1252,19 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 	    ioc->name, jiffies_to_msecs(jiffies -
 	    target_reset_list->time_count)/1000));
 
-	id = pScsiTmReply->TargetID;
-	channel = pScsiTmReply->Bus;
-	target_reset_list->time_count = jiffies;
+	if (pScsiTmReply) {
+		id = pScsiTmReply->TargetID;
+		channel = pScsiTmReply->Bus;
+		target_reset_list->time_count = jiffies;
 
-	/*
-	 * retry target reset
-	 */
-	if (!target_reset_list->target_reset_issued) {
-		if (mptsas_target_reset(ioc, channel, id))
-			target_reset_list->target_reset_issued = 1;
-		return 1;
+		/*
+		 * retry target reset
+		 */
+		if (!target_reset_list->target_reset_issued) {
+			if (mptsas_target_reset(ioc, channel, id))
+				target_reset_list->target_reset_issued = 1;
+			return 1;
+		}
 	}
 
 	/*
@@ -3872,9 +3874,8 @@ retry_page:
  redo_expander_scan:
 	list_for_each_entry(port_info, &ioc->sas_topology, list) {
 
-		if (port_info->phy_info &&
-		    (!(port_info->phy_info[0].identify.device_info &
-		    MPI_SAS_DEVICE_INFO_SMP_TARGET)))
+		if (!(port_info->phy_info[0].identify.device_info &
+		    MPI_SAS_DEVICE_INFO_SMP_TARGET))
 			continue;
 		found_expander = 0;
 		handle = 0xFFFF;
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 727819c..475e3c9 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1266,6 +1266,7 @@ mptscsih_resume(struct pci_dev *pdev)
 const char *
 mptscsih_info(struct Scsi_Host *SChost)
 {
+	const char *ret = "N/A";
 	MPT_SCSI_HOST *h;
 	int size = 0;
 
@@ -1279,9 +1280,10 @@ mptscsih_info(struct Scsi_Host *SChost)
 
 		mpt_print_ioc_summary(h->ioc, h->info_kbuf, &size, 0, 0);
 		h->info_kbuf[size-1] = '\0';
+		ret = h->info_kbuf;
 	}
 
-	return h->info_kbuf;
+	return ret;
 }
 
 int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
@@ -1370,8 +1372,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	/* Default to untagged. Once a target structure has been allocated,
 	 * use the Inquiry data to determine if device supports tagged.
 	 */
-	if (vdevice
-	    && (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
+	if ((vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
 	    && (SCpnt->device->tagged_supported)) {
 		scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
 		if (SCpnt->request && SCpnt->request->ioprio) {
-- 
1.7.10.4

