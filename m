Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D07CA9ECE
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 993BB2086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfJaLFd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 07:05:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:37430 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727468AbfJaLFc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Oct 2019 07:05:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CEDAAB350;
        Thu, 31 Oct 2019 11:05:27 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/24] scsi: change status_byte() to return the standard SCSI status
Date:   Thu, 31 Oct 2019 12:04:34 +0100
Message-Id: <20191031110452.73463-7-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191031110452.73463-1-hare@suse.de>
References: <20191031110452.73463-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of returning the linux-special status (which is shifted
by 1 to the right) change the status_byte() macro to return the
correct SCSI standard status.
And audit all callers to handle this change.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/53c700.c            |  6 ++---
 drivers/scsi/NCR5380.c           |  2 +-
 drivers/scsi/arm/acornscsi.c     | 10 ++++-----
 drivers/scsi/arm/fas216.c        | 10 ++++-----
 drivers/scsi/dc395x.c            |  8 +++----
 drivers/scsi/ibmvscsi/ibmvscsi.c |  2 +-
 drivers/scsi/scsi.c              |  2 +-
 drivers/scsi/scsi_error.c        | 48 ++++++++++++++++++++--------------------
 drivers/scsi/scsi_lib.c          |  2 +-
 drivers/scsi/sg.c                |  4 ++--
 include/scsi/scsi.h              |  2 +-
 11 files changed, 47 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 0068963bb933..432f904e8d13 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -954,8 +954,8 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 						  NCR_700_FINISHED_TAG_NEGOTIATION);
 			
 		/* check for contingent allegiance contitions */
-		if(status_byte(hostdata->status[0]) == CHECK_CONDITION ||
-		   status_byte(hostdata->status[0]) == COMMAND_TERMINATED) {
+		if(status_byte(hostdata->status[0]) == SAM_STAT_CHECK_CONDITION ||
+		   status_byte(hostdata->status[0]) == SAM_STAT_COMMAND_TERMINATED) {
 			struct NCR_700_command_slot *slot =
 				(struct NCR_700_command_slot *)SCp->host_scribble;
 			if(slot->flags == NCR_700_FLAG_AUTOSENSE) {
@@ -1021,7 +1021,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 			// Currently rely on the mid layer evaluation
 			// of the tag queuing capability
 			//
-			//if(status_byte(hostdata->status[0]) == GOOD &&
+			//if(status_byte(hostdata->status[0]) == SAM_STAT_GOOD &&
 			//   SCp->cmnd[0] == INQUIRY && SCp->use_sg == 0) {
 			//	/* Piggy back the tag queueing support
 			//	 * on this command */
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 536426f25e86..5559d39a00b7 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -522,7 +522,7 @@ static void complete_cmd(struct Scsi_Host *instance,
 
 	if (hostdata->sensing == cmd) {
 		/* Autosense processing ends here */
-		if (status_byte(cmd->result) != GOOD) {
+		if (status_byte(cmd->result) != SAM_STAT_GOOD) {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
 		} else {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 8ceb1663bdb5..a07413169ec0 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -834,11 +834,11 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 
 		if (xfer_warn) {
 		    switch (status_byte(SCpnt->result)) {
-		    case CHECK_CONDITION:
-		    case COMMAND_TERMINATED:
-		    case BUSY:
-		    case QUEUE_FULL:
-		    case RESERVATION_CONFLICT:
+		    case SAM_STAT_CHECK_CONDITION:
+		    case SAM_STAT_COMMAND_TERMINATED:
+		    case SAM_STAT_BUSY:
+		    case SAM_STAT_TASK_SET_FULL:
+		    case SAM_STAT_RESERVATION_CONFLICT:
 			break;
 
 		    default:
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 6c68c2303638..a860f89de4ae 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2056,18 +2056,18 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 		goto done;
 
 	/*
-	 * If the command returned CHECK_CONDITION or COMMAND_TERMINATED
-	 * status, request the sense information.
+	 * If the command returned SAM_STAT_CHECK_CONDITION or
+	 * SAM_STAT_COMMAND_TERMINATED status, request the sense information.
 	 */
-	if (status_byte(SCpnt->result) == CHECK_CONDITION ||
-	    status_byte(SCpnt->result) == COMMAND_TERMINATED)
+	if (status_byte(SCpnt->result) == SAM_STAT_CHECK_CONDITION ||
+	    status_byte(SCpnt->result) == SAM_STAT_COMMAND_TERMINATED)
 		goto request_sense;
 
 	/*
 	 * If the command did not complete with GOOD status,
 	 * we are all done here.
 	 */
-	if (status_byte(SCpnt->result) != GOOD)
+	if (status_byte(SCpnt->result) != SAM_STAT_GOOD)
 		goto done;
 
 	/*
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index a56893bc681e..e79db03196f7 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3292,10 +3292,10 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		/*
 		 * target status..........................
 		 */
-		if (status_byte(status) == CHECK_CONDITION) {
+		if (status_byte(status) == SAM_STAT_CHECK_CONDITION) {
 			request_sense(acb, dcb, srb);
 			return;
-		} else if (status_byte(status) == QUEUE_FULL) {
+		} else if (status_byte(status) == SAM_STAT_TASK_SET_FULL) {
 			tempcnt = (u8)list_size(&dcb->srb_going_list);
 			dprintkl(KERN_INFO, "QUEUE_FULL for dev <%02i-%i> with %i cmnds\n",
 			     dcb->target_id, dcb->target_lun, tempcnt);
@@ -3361,10 +3361,8 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		    && dir != PCI_DMA_NONE && ptr && (ptr->Vers & 0x07) >= 2)
 			dcb->inquiry7 = ptr->Flags;
 
-	/*if( srb->cmd->cmnd[0] == INQUIRY && */
-	/*  (host_byte(cmd->result) == DID_OK || status_byte(cmd->result) & CHECK_CONDITION) ) */
 		if ((cmd->result == (DID_OK << 16) ||
-		     status_byte(cmd->result) == CHECK_CONDITION)) {
+		     status_byte(cmd->result) == SAM_STAT_CHECK_CONDITION)) {
 			if (!dcb->init_tcq_flag) {
 				add_dev(acb, dcb, ptr);
 				dcb->init_tcq_flag = 1;
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 7f66a7783209..73d0dded83fe 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -986,7 +986,7 @@ static void handle_cmd_rsp(struct srp_event_struct *evt_struct)
 	
 	if (cmnd) {
 		cmnd->result |= rsp->status;
-		if (((cmnd->result >> 1) & 0x1f) == CHECK_CONDITION)
+		if (status_byte(cmnd->result) == SAM_STAT_CHECK_CONDITION)
 			memcpy(cmnd->sense_buffer,
 			       rsp->data,
 			       be32_to_cpu(rsp->sense_data_len));
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4f76841a7038..59443e0184fd 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -158,7 +158,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 		    (level > 1)) {
 			scsi_print_result(cmd, "Done", disposition);
 			scsi_print_command(cmd);
-			if (status_byte(cmd->result) == CHECK_CONDITION)
+			if (status_byte(cmd->result) == SAM_STAT_CHECK_CONDITION)
 				scsi_print_sense(cmd);
 			if (level > 3)
 				scmd_printk(KERN_INFO, cmd,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ae2fa170f6ad..bfaac355454b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -732,31 +732,31 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	 * anything special.
 	 */
 	switch (status_byte(scmd->result)) {
-	case GOOD:
+	case SAM_STAT_GOOD:
 		scsi_handle_queue_ramp_up(scmd->device);
 		/* FALLTHROUGH */
-	case COMMAND_TERMINATED:
+	case SAM_STAT_COMMAND_TERMINATED:
 		return SUCCESS;
-	case CHECK_CONDITION:
+	case SAM_STAT_CHECK_CONDITION:
 		return scsi_check_sense(scmd);
-	case CONDITION_GOOD:
-	case INTERMEDIATE_GOOD:
-	case INTERMEDIATE_C_GOOD:
+	case SAM_STAT_CONDITION_MET:
+	case SAM_STAT_INTERMEDIATE:
+	case SAM_STAT_INTERMEDIATE_CONDITION_MET:
 		/*
 		 * who knows?  FIXME(eric)
 		 */
 		return SUCCESS;
-	case RESERVATION_CONFLICT:
+	case SAM_STAT_RESERVATION_CONFLICT:
 		if (scmd->cmnd[0] == TEST_UNIT_READY)
 			/* it is a success, we probed the device and
 			 * found it */
 			return SUCCESS;
 		/* otherwise, we failed to send the command */
 		return FAILED;
-	case QUEUE_FULL:
+	case SAM_STAT_TASK_SET_FULL:
 		scsi_handle_queue_full(scmd->device);
 		/* fall through */
-	case BUSY:
+	case SAM_STAT_BUSY:
 		return NEEDS_RETRY;
 	default:
 		return FAILED;
@@ -1237,7 +1237,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 					     current->comm));
 			break;
 		}
-		if (status_byte(scmd->result) != CHECK_CONDITION)
+		if (status_byte(scmd->result) != SAM_STAT_CHECK_CONDITION)
 			/*
 			 * don't request sense if there's no check condition
 			 * status because the error we're processing isn't one
@@ -1735,14 +1735,14 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
-		    status_byte(scmd->result) == RESERVATION_CONFLICT)
+		    status_byte(scmd->result) == SAM_STAT_RESERVATION_CONFLICT)
 			return 0;
 		/* fall through */
 	case DID_SOFT_ERROR:
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
 	}
 
-	if (status_byte(scmd->result) != CHECK_CONDITION)
+	if (status_byte(scmd->result) != SAM_STAT_CHECK_CONDITION)
 		return 0;
 
 check_type:
@@ -1846,7 +1846,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
-		    status_byte(scmd->result) == RESERVATION_CONFLICT)
+		    status_byte(scmd->result) == SAM_STAT_RESERVATION_CONFLICT)
 			/*
 			 * execute reservation conflict processing code
 			 * lower down
@@ -1884,14 +1884,14 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * check the status byte to see if this indicates anything special.
 	 */
 	switch (status_byte(scmd->result)) {
-	case QUEUE_FULL:
+	case SAM_STAT_TASK_SET_FULL:
 		scsi_handle_queue_full(scmd->device);
 		/*
 		 * the case of trying to send too many commands to a
 		 * tagged queueing device.
 		 */
 		/* FALLTHROUGH */
-	case BUSY:
+	case SAM_STAT_BUSY:
 		/*
 		 * device can't talk to us at the moment.  Should only
 		 * occur (SAM-3) when the task queue is empty, so will cause
@@ -1899,16 +1899,16 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * device.
 		 */
 		return ADD_TO_MLQUEUE;
-	case GOOD:
+	case SAM_STAT_GOOD:
 		if (scmd->cmnd[0] == REPORT_LUNS)
 			scmd->device->sdev_target->expecting_lun_change = 0;
 		scsi_handle_queue_ramp_up(scmd->device);
 		/* FALLTHROUGH */
-	case COMMAND_TERMINATED:
+	case SAM_STAT_COMMAND_TERMINATED:
 		return SUCCESS;
-	case TASK_ABORTED:
+	case SAM_STAT_TASK_ABORTED:
 		goto maybe_retry;
-	case CHECK_CONDITION:
+	case SAM_STAT_CHECK_CONDITION:
 		rtn = scsi_check_sense(scmd);
 		if (rtn == NEEDS_RETRY)
 			goto maybe_retry;
@@ -1917,16 +1917,16 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * to collect the sense and redo the decide
 		 * disposition */
 		return rtn;
-	case CONDITION_GOOD:
-	case INTERMEDIATE_GOOD:
-	case INTERMEDIATE_C_GOOD:
-	case ACA_ACTIVE:
+	case SAM_STAT_CONDITION_MET:
+	case SAM_STAT_INTERMEDIATE:
+	case SAM_STAT_INTERMEDIATE_CONDITION_MET:
+	case SAM_STAT_ACA_ACTIVE:
 		/*
 		 * who knows?  FIXME(eric)
 		 */
 		return SUCCESS;
 
-	case RESERVATION_CONFLICT:
+	case SAM_STAT_RESERVATION_CONFLICT:
 		sdev_printk(KERN_INFO, scmd->device,
 			    "reservation conflict\n");
 		set_host_byte(scmd, DID_NEXUS_FAILURE);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dc210b9d4896..a0db8d8766a8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2180,7 +2180,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			data->block_descriptor_length = buffer[3];
 		}
 		data->header_length = header_length;
-	} else if ((status_byte(result) == CHECK_CONDITION) &&
+	} else if ((status_byte(result) == SAM_STAT_CHECK_CONDITION) &&
 		   scsi_sense_valid(sshdr) &&
 		   sshdr->sense_key == UNIT_ATTENTION && retry_count) {
 		retry_count--;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index cce757506383..e88fb3daebcc 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1349,8 +1349,8 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	if (0 != result) {
 		struct scsi_sense_hdr sshdr;
 
-		srp->header.status = 0xff & result;
-		srp->header.masked_status = status_byte(result);
+		srp->header.status = status_byte(result);
+		srp->header.masked_status = status_byte(result) >> 1;
 		srp->header.msg_status = msg_byte(result);
 		srp->header.host_status = host_byte(result);
 		srp->header.driver_status = driver_byte(result);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5339baadc082..ce8096a99981 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -207,7 +207,7 @@ static inline int scsi_is_wlun(u64 lun)
  *      host_byte   = set by low-level driver to indicate status.
  *      driver_byte = set by mid-level.
  */
-#define status_byte(result) (((result) >> 1) & 0x7f)
+#define status_byte(result) ((result) & 0xff)
 #define msg_byte(result)    (((result) >> 8) & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 #define driver_byte(result) (((result) >> 24) & 0xff)
-- 
2.16.4

