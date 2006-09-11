From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 1/2] struct scsi_lun preparation
Date: Mon, 11 Sep 2006 10:34:58 -0400
Message-ID: <20060911143458.GA13318@havoc.gtf.org>
References: <20060911143406.GA12991@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:42119 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751134AbWIKOe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 10:34:59 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 99DD91C24E8A
	for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2006 10:34:58 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id k8BEYw7v013382
	for linux-scsi@vger.kernel.org; Mon, 11 Sep 2006 10:34:58 -0400
Content-Disposition: inline
In-Reply-To: <20060911143406.GA12991@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


DO NOT APPLY.

Not-signed-off-by:  Jeff Garzik <jeff@garzik.org>

 drivers/scsi/NCR5380.c    |   11 ++++++++---
 drivers/scsi/NCR5380.h    |    8 ++++++++
 drivers/scsi/constants.c  |    3 +--
 drivers/scsi/eata.c       |   12 +++++-------
 drivers/scsi/scsi_error.c |    9 ++++-----
 drivers/scsi/sd.c         |    3 +--
 6 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 616810a..060a3bb 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1118,7 +1118,8 @@ static void NCR5380_main(void *p)
 				   this is needed for Mustek scanners, that
 				   do not respond to commands immediately
 				   after a scan */
-				printk(KERN_DEBUG "scsi%d: device %d did not respond in time\n", instance->host_no, tmp->device->id);
+				scmd_printk(KERN_DEBUG, tmp,
+					"device did not respond in time\n");
 				LIST(tmp, hostdata->issue_queue);
 				tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
 				hostdata->issue_queue = tmp;
@@ -2242,7 +2243,8 @@ #ifdef LINKED
 					/* The next command is still part of this process */
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun));
+					ddprintk(KERN_DEBUG, cmd,
+						"linked request done, calling scsi_done().\n");
 					collect_stats(hostdata, cmd);
 					cmd->scsi_done(cmd);
 					cmd = hostdata->connected;
@@ -2337,7 +2339,10 @@ #endif				/* def AUTOSENSE */
 						    hostdata->disconnected_queue;
 						hostdata->connected = NULL;
 						hostdata->disconnected_queue = cmd;
-						dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, cmd->device->lun));
+						ddprintk(KERN_DEBUG, cmd,
+						"command for target was moved from connected to"
+						"  the disconnected_queue\n");
+
 						/* 
 						 * Restore phase bits to 0 so an interrupted selection, 
 						 * arbitration can resume.
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index c3462e3..298b2df 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -289,6 +289,14 @@ #define dprintk(a,b)			do {} while(0)
 #define NCR5380_dprint(a,b)		do {} while(0)
 #define NCR5380_dprint_phase(a,b)	do {} while(0)
 
+#if 0
+#define ddprintk(prefix, scmd, fmt, a...) \
+	scmd_printk(prefix, scmd, fmt, ##a)
+#else
+#define ddprintk(prefix, scmd, fmt, a...) \
+	do {} while (0)
+#endif
+
 #if defined(AUTOPROBE_IRQ)
 static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);
 #endif
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 61f6024..c00ec0d 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1313,8 +1313,7 @@ EXPORT_SYMBOL(scsi_print_sense);
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
 	/* Assume appended output (i.e. not at start of line) */
-	sdev_printk("", cmd->device, "\n");
-	printk(KERN_INFO "        command: ");
+	scmd_printk(KERN_INFO, cmd, "command:\n\t");
 	scsi_print_cdb(cmd->cmnd, cmd->cmd_len, 0);
 }
 EXPORT_SYMBOL(scsi_print_command);
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index a5ff43b..dda36f5 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -2455,20 +2455,18 @@ #endif
 			status = DID_OK << 16;
 
 		if (tstatus == GOOD)
-			ha->target_redo[SCpnt->device->id][SCpnt->device->
-							      channel] = 0;
+			ha->target_redo[scmd_id(SCpnt)][scmd_channel(SCpnt)] = 0;
 
 		if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
 		    (!(tstatus == CHECK_CONDITION && ha->iocount <= 1000 &&
 		       (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
-			printk("%s: ihdlr, target %d.%d:%d, pid %ld, "
+			scmd_printk(KERN_INFO, SCpnt,
+				"ihdlr, pid %ld, "
 			       "target_status 0x%x, sense key 0x%x.\n",
-			       ha->board_name,
-			       SCpnt->device->channel, SCpnt->device->id,
-			       SCpnt->device->lun, SCpnt->pid,
+			       SCpnt->pid,
 			       spp->target_status, SCpnt->sense_buffer[2]);
 
-		ha->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
+		ha->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] = 0;
 
 		if (ha->last_retried_pid == SCpnt->pid)
 			ha->retries = 0;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a8ed5a2..6478188 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1117,9 +1117,9 @@ static void scsi_eh_offline_sdevs(struct
 	struct scsi_cmnd *scmd, *next;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-		sdev_printk(KERN_INFO, scmd->device,
-			    "scsi: Device offlined - not"
-			    " ready after error recovery\n");
+		scmd_printk(KERN_INFO, scmd,
+			    "Device offlined - not"
+		       	    " ready after error recovery\n");
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
 		if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD) {
 			/*
@@ -1281,8 +1281,7 @@ int scsi_decide_disposition(struct scsi_
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		sdev_printk(KERN_INFO, scmd->device,
-			    "reservation conflict\n");
+		scmd_printk(KERN_INFO, scmd, "reservation conflict\n");
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 98bd3aa..1ba2a50 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1623,8 +1623,7 @@ static int sd_probe(struct device *dev)
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
 		goto out;
 
-	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
-					"sd_attach\n"));
+	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp, "sd_attach\n"));
 
 	error = -ENOMEM;
 	sdkp = kzalloc(sizeof(*sdkp), GFP_KERNEL);
