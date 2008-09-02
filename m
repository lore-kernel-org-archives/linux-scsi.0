From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 07/14] scsi: change return codes in scsi_decide_disposition
Date: Tue,  2 Sep 2008 09:05:36 -0700
Message-ID: <1220371543-15099-8-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36169 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbYIBQHF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:07:05 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G74Hj004660
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:07:04 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5mHp233746
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:48 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5lcB021215
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:48 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Created new return codes for scsi_decide_disposition
and scsi_check_sense so that retry restrictions and
disposition can be implied directly from the return
code.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |   80 +++++++++++++++++++++++----------------------
 drivers/scsi/scsi_lib.c   |   33 +++++++++---------
 include/scsi/scsi.h       |   30 +++++++++++++++--
 3 files changed, 85 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ffe5e70..6b8cbb1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -290,7 +290,9 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  * @scmd:	Cmd to have sense checked.
  *
  * Return value:
- * 	SUCCESS or FAILED or NEEDS_RETRY
+ * 	SCSI_MLQUEUE_DIS_FINISH
+ * 	SCSI_MLQUEUE_DIS_RETRY
+ * 	SCSI_MLQUEUE_DIS_FAIL
  *
  * Notes:
  *	When a deferred error is detected the current command has
@@ -302,10 +304,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	struct scsi_sense_hdr sshdr;
 
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
-		return FAILED;	/* no valid sense data */
+		return SCSI_MLQUEUE_DIS_FAIL;	/* no valid sense data */
 
 	if (scsi_sense_is_deferred(&sshdr))
-		return NEEDS_RETRY;
+		return SCSI_MLQUEUE_DIS_RETRY;
 
 	if (sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh &&
 			sdev->scsi_dh_data->scsi_dh->check_sense) {
@@ -324,7 +326,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (sshdr.response_code == 0x70) {
 		/* fixed format */
 		if (scmd->sense_buffer[2] & 0xe0)
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 	} else {
 		/*
 		 * descriptor format: look for "stream commands sense data
@@ -334,20 +336,20 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if ((sshdr.additional_length > 3) &&
 		    (scmd->sense_buffer[8] == 0x4) &&
 		    (scmd->sense_buffer[11] & 0xe0))
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 	}
 
 	switch (sshdr.sense_key) {
 	case NO_SENSE:
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 	case RECOVERED_ERROR:
-		return /* soft_error */ SUCCESS;
+		return /* soft_error */ SCSI_MLQUEUE_DIS_FINISH;
 
 	case ABORTED_COMMAND:
 		if (sshdr.asc == 0x10) /* DIF */
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 
-		return NEEDS_RETRY;
+		return SCSI_MLQUEUE_DIS_RETRY;
 	case NOT_READY:
 	case UNIT_ATTENTION:
 		/*
@@ -358,48 +360,48 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		 */
 		if (scmd->device->expecting_cc_ua) {
 			scmd->device->expecting_cc_ua = 0;
-			return NEEDS_RETRY;
+			return SCSI_MLQUEUE_DIS_RETRY;
 		}
 		/*
 		 * if the device is in the process of becoming ready, we 
 		 * should retry.
 		 */
 		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
-			return NEEDS_RETRY;
+			return SCSI_MLQUEUE_DIS_RETRY;
 		/*
 		 * if the device is not started, we need to wake
 		 * the error handler to start the motor
 		 */
 		if (scmd->device->allow_restart &&
 		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
-			return FAILED;
-		return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FAIL;
+		return SCSI_MLQUEUE_DIS_FINISH;
 
 		/* these three are not supported */
 	case COPY_ABORTED:
 	case VOLUME_OVERFLOW:
 	case MISCOMPARE:
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 
 	case MEDIUM_ERROR:
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		}
-		return NEEDS_RETRY;
+		return SCSI_MLQUEUE_DIS_RETRY;
 
 	case HARDWARE_ERROR:
 		if (scmd->device->retry_hwerror)
-			return NEEDS_RETRY;
+			return SCSI_MLQUEUE_DIS_RETRY;
 		else
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 
 	case ILLEGAL_REQUEST:
 	case BLANK_CHECK:
 	case DATA_PROTECT:
 	default:
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 	}
 }
 
@@ -1304,7 +1306,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: device offline - report"
 						  " as SUCCESS\n",
 						  __func__));
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 	}
 
 	/*
@@ -1319,7 +1321,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * did_ok.
 		 */
 		scmd->result &= 0xff00ffff;
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 	case DID_OK:
 		/*
 		 * looks good.  drop through, and check the next byte.
@@ -1333,7 +1335,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * to the top level driver, not that we actually think
 		 * that it indicates SUCCESS.
 		 */
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 		/*
 		 * when the low level driver returns did_soft_error,
 		 * it is responsible for keeping an internal retry counter 
@@ -1344,10 +1346,10 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * and not get stuck in a loop.
 		 */
 	case DID_SOFT_ERROR:
-		return NEEDS_RETRY;
+		return SCSI_MLQUEUE_DIS_RETRY;
 	case DID_IMM_RETRY:
 	case DID_REQUEUE:
-		return ADD_TO_MLQUEUE;
+		return SCSI_MLQUEUE_IMM_RETRY;
 	case DID_TRANSPORT_DISRUPTED:
 		/*
 		 * LLD/transport was disrupted during processing of the IO.
@@ -1355,13 +1357,13 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * and the transport will decide what to do with the IO
 		 * based on its timers and recovery capablilities.
 		 */
-		return ADD_TO_MLQUEUE;
+		return SCSI_MLQUEUE_IMM_RETRY;
 	case DID_TRANSPORT_FAILFAST:
 		/*
 		 * The transport decided to failfast the IO (most likely
 		 * the fast io fail tmo fired), so send IO directly upwards.
 		 */
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
 		    status_byte(scmd->result) == RESERVATION_CONFLICT)
@@ -1374,7 +1376,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 
 	case DID_BUS_BUSY:
 	case DID_PARITY:
-		return NEEDS_RETRY;
+		return SCSI_MLQUEUE_DIS_RETRY;
 	case DID_TIME_OUT:
 		/*
 		 * when we scan the bus, we get timeout messages for
@@ -1383,21 +1385,21 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 */
 		if ((scmd->cmnd[0] == TEST_UNIT_READY ||
 		     scmd->cmnd[0] == INQUIRY)) {
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		} else {
-			return FAILED;
+			return SCSI_MLQUEUE_DIS_FAIL;
 		}
 	case DID_RESET:
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 	default:
-		return FAILED;
+		return SCSI_MLQUEUE_DIS_FAIL;
 	}
 
 	/*
 	 * next, check the message byte.
 	 */
 	if (msg_byte(scmd->result) != COMMAND_COMPLETE)
-		return FAILED;
+		return SCSI_MLQUEUE_DIS_FAIL;
 
 	/*
 	 * check the status byte to see if this indicates anything special.
@@ -1415,11 +1417,11 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * the empty queue handling to trigger a stall in the
 		 * device.
 		 */
-		return ADD_TO_MLQUEUE;
+		return SCSI_MLQUEUE_IMM_RETRY;
 	case GOOD:
 	case COMMAND_TERMINATED:
 	case TASK_ABORTED:
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 	case CHECK_CONDITION:
 		return scsi_check_sense(scmd);
 	case CONDITION_GOOD:
@@ -1429,16 +1431,16 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		/*
 		 * who knows?  FIXME(eric)
 		 */
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 
 	case RESERVATION_CONFLICT:
 		sdev_printk(KERN_INFO, scmd->device,
 			    "reservation conflict\n");
-		return SUCCESS; /* causes immediate i/o error */
+		return SCSI_MLQUEUE_DIS_FINISH; /* causes immediate i/o error */
 	default:
-		return FAILED;
+		return SCSI_MLQUEUE_DIS_FAIL;
 	}
-	return FAILED;
+	return SCSI_MLQUEUE_DIS_FAIL;
 
 }
 
@@ -1561,7 +1563,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 							  " retry cmd: %p\n",
 							  current->comm,
 							  scmd));
-				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+			scsi_queue_insert(scmd, SCSI_MLQUEUE_DIS_RETRY);
 		} else {
 			/*
 			 * If just we got sense for the device (called
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a085973..51a737f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -146,9 +146,17 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 		host->host_blocked = host->max_host_blocked;
 	else if (reason == SCSI_MLQUEUE_DEVICE_BUSY)
 		device->device_blocked = device->max_device_blocked;
-	else if (reason == SCSI_MLQUEUE_EH_RETRY) {
-		if (blk_noretry_request(cmd->request) ||
-		    ++cmd->retries > cmd->allowed) {
+
+	if (!scsi_ign_failfast(reason)) {
+		if (blk_noretry_request(cmd->request)) {
+			set_driver_byte(cmd, DRIVER_TIMEOUT);
+			scsi_finish_command(cmd);
+			return 0;
+		}
+	}
+
+	if (!scsi_ign_cmd_retries(reason)) {
+		if (++cmd->retries > cmd->allowed) {
 			set_driver_byte(cmd, DRIVER_TIMEOUT);
 			scsi_finish_command(cmd);
 			return 0;
@@ -1446,20 +1454,13 @@ static void scsi_softirq_done(struct request *rq)
 			
 	scsi_log_completion(cmd, disposition);
 
-	switch (disposition) {
-		case SUCCESS:
+	if (scsi_disposition_finish(disposition))
+		scsi_finish_command(cmd);
+	else if (scsi_disposition_retry(disposition))
+		scsi_queue_insert(cmd, disposition);
+	else
+		if (!scsi_eh_scmd_add(cmd, 0))
 			scsi_finish_command(cmd);
-			break;
-		case NEEDS_RETRY:
-			scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
-			break;
-		case ADD_TO_MLQUEUE:
-			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
-			break;
-		default:
-			if (!scsi_eh_scmd_add(cmd, 0))
-				scsi_finish_command(cmd);
-	}
 }
 
 /*
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8740a16..a3083de 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -414,9 +414,33 @@ struct scsi_lun {
 /*
  * Midlevel queue return values.
  */
-#define SCSI_MLQUEUE_HOST_BUSY   0x1055
-#define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
-#define SCSI_MLQUEUE_EH_RETRY    0x1057
+
+enum {
+	/*
+	 * Retry Constraints
+	 *
+	 * SCSI_IGN_ALLOWED		: Ignore cmd retries allowed check
+	 * SCSI_IGN_BLK_FAILFAST	: Ignore blk_failfast check.
+	 */
+	SCSI_IGN_ALLOWED	= 0x01,
+	SCSI_IGN_BLK_FAILFAST	= 0x02,
+
+	SCSI_MLQUEUE_DIS_FINISH	= 0x10,
+	SCSI_MLQUEUE_DIS_RETRY	= 0x20,
+	SCSI_MLQUEUE_DIS_FAIL	= 0x40,
+
+	SCSI_MLQUEUE_HOST_BUSY		= 0x100 | SCSI_MLQUEUE_DIS_RETRY |
+		SCSI_IGN_BLK_FAILFAST | SCSI_IGN_ALLOWED,
+	SCSI_MLQUEUE_DEVICE_BUSY	= 0x101 | SCSI_MLQUEUE_DIS_RETRY |
+		SCSI_IGN_BLK_FAILFAST | SCSI_IGN_ALLOWED,
+	SCSI_MLQUEUE_IMM_RETRY		= 0x102 | SCSI_MLQUEUE_DIS_RETRY |
+		SCSI_IGN_BLK_FAILFAST | SCSI_IGN_ALLOWED,
+};
+
+#define scsi_disposition_finish(dis) (dis & SCSI_MLQUEUE_DIS_FINISH)
+#define scsi_disposition_retry(dis) (dis & SCSI_MLQUEUE_DIS_RETRY)
+#define scsi_ign_cmd_retries(dis) (dis & SCSI_IGN_ALLOWED)
+#define scsi_ign_failfast(dis) (dis & SCSI_IGN_BLK_FAILFAST)
 
 /*
  *  Use these to separate status msg and our bytes
-- 
1.5.5.1

