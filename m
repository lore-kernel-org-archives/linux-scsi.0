From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 1/7] zfcp: introduce eh_timed_out handler
Date: Sat, 3 Sep 2005 14:30:42 +0200
Message-ID: <20050903123042.GA7902@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:57748 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751062AbVICMc6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 08:32:58 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j83CWvOI136720
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 12:32:57 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j83CWvih181670
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:32:57 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j83CWvRG014364
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:32:57 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: introduce eh_timed_out handler

This handler is required to avoid offlined SCSI devices in a multipath
setup if scsi commands time out on cable pulls lasting longer than 30
seconds.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_scsi.c linux-2.6.13/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_scsi.c	2005-09-03 12:17:16.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_scsi.c	2005-09-03 12:17:53.000000000 +0200
@@ -44,6 +44,7 @@ static int zfcp_scsi_eh_abort_handler(st
 static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *);
 static int zfcp_scsi_eh_bus_reset_handler(struct scsi_cmnd *);
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *);
+static enum scsi_eh_timer_return zfcp_scsi_eh_timed_out(struct scsi_cmnd *);
 static int zfcp_task_management_function(struct zfcp_unit *, u8);
 
 static struct zfcp_unit *zfcp_unit_lookup(struct zfcp_adapter *, int, scsi_id_t,
@@ -69,6 +70,7 @@ struct zfcp_data zfcp_data = {
 	      eh_device_reset_handler: zfcp_scsi_eh_device_reset_handler,
 	      eh_bus_reset_handler:    zfcp_scsi_eh_bus_reset_handler,
 	      eh_host_reset_handler:   zfcp_scsi_eh_host_reset_handler,
+	      eh_timed_out:            zfcp_scsi_eh_timed_out,
 			               /* FIXME(openfcp): Tune */
 	      can_queue:               4096,
 	      this_id:	               0,
@@ -242,7 +244,6 @@ static void
 zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
 {
 	set_host_byte(&scpnt->result, result);
-	zfcp_cmd_dbf_event_scsi("failing", scpnt);
 	/* return directly */
 	scpnt->scsi_done(scpnt);
 }
@@ -414,59 +415,18 @@ zfcp_port_lookup(struct zfcp_adapter *ad
 	return (struct zfcp_port *) NULL;
 }
 
-/*
- * function:	zfcp_scsi_eh_abort_handler
- *
- * purpose:	tries to abort the specified (timed out) SCSI command
- *
- * note: 	We do not need to care for a SCSI command which completes
- *		normally but late during this abort routine runs.
- *		We are allowed to return late commands to the SCSI stack.
- *		It tracks the state of commands and will handle late commands.
- *		(Usually, the normal completion of late commands is ignored with
- *		respect to the running abort operation. Grep for 'done_late'
- *		in the SCSI stacks sources.)
- *
- * returns:	SUCCESS	- command has been aborted and cleaned up in internal
- *			  bookkeeping,
- *			  SCSI stack won't be called for aborted command
- *		FAILED	- otherwise
- */
 int
-__zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
+zfcp_scsi_abort_async(struct scsi_cmnd *scpnt,
+ 		      struct zfcp_fsf_req **fsf_req_ptr)
 {
-	int retval = SUCCESS;
-	struct zfcp_fsf_req *new_fsf_req, *old_fsf_req;
-	struct zfcp_adapter *adapter = (struct zfcp_adapter *) scpnt->device->host->hostdata[0];
+ 	struct Scsi_Host *host = scpnt->device->host;
+ 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) host->hostdata[0];
 	struct zfcp_unit *unit = (struct zfcp_unit *) scpnt->device->hostdata;
-	struct zfcp_port *port = unit->port;
-	struct Scsi_Host *scsi_host = scpnt->device->host;
 	union zfcp_req_data *req_data = NULL;
+  	struct zfcp_fsf_req *new_fsf_req;
+  	struct zfcp_fsf_req *old_fsf_req;
+  	int req_flags;
 	unsigned long flags;
-	u32 status = 0;
-
-	/* the components of a abort_dbf record (fixed size record) */
-	u64 dbf_scsi_cmnd = (unsigned long) scpnt;
-	char dbf_opcode[ZFCP_ABORT_DBF_LENGTH];
-	wwn_t dbf_wwn = port->wwpn;
-	fcp_lun_t dbf_fcp_lun = unit->fcp_lun;
-	u64 dbf_retries = scpnt->retries;
-	u64 dbf_allowed = scpnt->allowed;
-	u64 dbf_timeout = 0;
-	u64 dbf_fsf_req = 0;
-	u64 dbf_fsf_status = 0;
-	u64 dbf_fsf_qual[2] = { 0, 0 };
-	char dbf_result[ZFCP_ABORT_DBF_LENGTH] = "##undef";
-
-	memset(dbf_opcode, 0, ZFCP_ABORT_DBF_LENGTH);
-	memcpy(dbf_opcode,
-	       scpnt->cmnd,
-	       min(scpnt->cmd_len, (unsigned char) ZFCP_ABORT_DBF_LENGTH));
-
-	ZFCP_LOG_INFO("aborting scsi_cmnd=%p on adapter %s\n",
-		      scpnt, zfcp_get_busid_by_adapter(adapter));
-
-	spin_unlock_irq(scsi_host->host_lock);
 
 	/*
 	 * Race condition between normal (late) completion and abort has
@@ -494,31 +454,18 @@ __zfcp_scsi_eh_abort_handler(struct scsi
 		 * Do not initiate abort but return SUCCESS.
 		 */
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
-		retval = SUCCESS;
-		strncpy(dbf_result, "##late1", ZFCP_ABORT_DBF_LENGTH);
-		goto out;
+		return SUCCESS;
 	}
 
 	/* Figure out which fsf_req needs to be aborted. */
 	old_fsf_req = req_data->send_fcp_command_task.fsf_req;
 
-	dbf_fsf_req = (unsigned long) old_fsf_req;
-	dbf_timeout =
-	    (jiffies - req_data->send_fcp_command_task.start_jiffies) / HZ;
-
 	ZFCP_LOG_DEBUG("old_fsf_req=%p\n", old_fsf_req);
 	if (!old_fsf_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
-		ZFCP_LOG_NORMAL("bug: no old fsf request found\n");
-		ZFCP_LOG_NORMAL("req_data:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
-			      (char *) req_data, sizeof (union zfcp_req_data));
-		ZFCP_LOG_NORMAL("scsi_cmnd:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
-			      (char *) scpnt, sizeof (struct scsi_cmnd));
-		retval = FAILED;
-		strncpy(dbf_result, "##bug:r", ZFCP_ABORT_DBF_LENGTH);
-		goto out;
+		if (fsf_req_ptr)
+			*fsf_req_ptr = NULL;
+		return SUCCESS;
 	}
 	old_fsf_req->data.send_fcp_command_task.scsi_cmnd = NULL;
 	/* mark old request as being aborted */
@@ -543,83 +490,101 @@ __zfcp_scsi_eh_abort_handler(struct scsi
 	 * all critical accesses to scsi_req are done.
 	 */
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
+
+	req_flags = (!fsf_req_ptr) ? ZFCP_REQ_AUTO_CLEANUP : 0;
+	new_fsf_req = zfcp_fsf_abort_fcp_command(
+			(unsigned long) old_fsf_req, adapter, unit, req_flags);
+
 	/* call FSF routine which does the abort */
-	new_fsf_req = zfcp_fsf_abort_fcp_command((unsigned long) old_fsf_req,
-						 adapter, unit, 0);
-	ZFCP_LOG_DEBUG("new_fsf_req=%p\n", new_fsf_req);
 	if (!new_fsf_req) {
-		retval = FAILED;
-		ZFCP_LOG_NORMAL("error: initiation of Abort FCP Cmnd "
-				"failed\n");
-		strncpy(dbf_result, "##nores", ZFCP_ABORT_DBF_LENGTH);
-		goto out;
+		ZFCP_LOG_INFO("error: initiation of Abort FCP Command failed\n");
+		if (fsf_req_ptr)
+			*fsf_req_ptr = NULL;
+		return FAILED;
 	}
 
-	/* wait for completion of abort */
-	ZFCP_LOG_DEBUG("waiting for cleanup...\n");
-#if 1
-	/*
-	 * FIXME:
-	 * copying zfcp_fsf_req_wait_and_cleanup code is not really nice
-	 */
-	__wait_event(new_fsf_req->completion_wq,
-		     new_fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
-	status = new_fsf_req->status;
-	dbf_fsf_status = new_fsf_req->qtcb->header.fsf_status;
-	/*
-	 * Ralphs special debug load provides timestamps in the FSF
-	 * status qualifier. This might be specified later if being
-	 * useful for debugging aborts.
-	 */
-	dbf_fsf_qual[0] =
-	    *(u64 *) & new_fsf_req->qtcb->header.fsf_status_qual.word[0];
-	dbf_fsf_qual[1] =
-	    *(u64 *) & new_fsf_req->qtcb->header.fsf_status_qual.word[2];
-	zfcp_fsf_req_free(new_fsf_req);
-#else
-	retval = zfcp_fsf_req_wait_and_cleanup(new_fsf_req,
-					       ZFCP_UNINTERRUPTIBLE, &status);
-#endif
-	ZFCP_LOG_DEBUG("Waiting for cleanup complete, status=0x%x\n", status);
-	/* status should be valid since signals were not permitted */
-	if (status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED) {
-		retval = SUCCESS;
-		strncpy(dbf_result, "##succ", ZFCP_ABORT_DBF_LENGTH);
-	} else if (status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED) {
-		retval = SUCCESS;
-		strncpy(dbf_result, "##late2", ZFCP_ABORT_DBF_LENGTH);
-	} else {
-		retval = FAILED;
-		strncpy(dbf_result, "##fail", ZFCP_ABORT_DBF_LENGTH);
-	}
+	if (fsf_req_ptr)
+		*fsf_req_ptr = new_fsf_req;
+	return SUCCESS;
+}
 
- out:
-	debug_event(adapter->abort_dbf, 1, &dbf_scsi_cmnd, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_opcode, ZFCP_ABORT_DBF_LENGTH);
-	debug_event(adapter->abort_dbf, 1, &dbf_wwn, sizeof (wwn_t));
-	debug_event(adapter->abort_dbf, 1, &dbf_fcp_lun, sizeof (fcp_lun_t));
-	debug_event(adapter->abort_dbf, 1, &dbf_retries, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_allowed, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_timeout, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_fsf_req, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_fsf_status, sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_fsf_qual[0], sizeof (u64));
-	debug_event(adapter->abort_dbf, 1, &dbf_fsf_qual[1], sizeof (u64));
-	debug_text_event(adapter->abort_dbf, 1, dbf_result);
 
-	spin_lock_irq(scsi_host->host_lock);
+int
+zfcp_scsi_abort_sync(struct scsi_cmnd *scpnt)
+{
+	struct zfcp_fsf_req *fsf_req;
+	int retval;
+
+	retval = zfcp_scsi_abort_async(scpnt, &fsf_req);
+	if (!fsf_req)
+		return retval;
+
+  	/* wait for completion of abort */
+  	__wait_event(
+		fsf_req->completion_wq,
+		fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+
+ 	/* status should be valid since signals were not permitted */
+	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED) {
+  		retval = SUCCESS;
+	} else if (fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED) {
+  		retval = SUCCESS;
+  	} else {
+  		retval = FAILED;
+  	}
+  
+	zfcp_fsf_req_free(fsf_req);
+
 	return retval;
 }
 
+/**
+ * zfcp_scsi_eh_abort_handler - abort the specified SCSI command
+ * @scpnt: pointer to scsi_cmnd to be aborted 
+ * Return: SUCCESS - command has been aborted and cleaned up in internal
+ *          bookkeeping, SCSI stack won't be called for aborted command
+ *         FAILED - otherwise
+ *
+ * We do not need to care for a SCSI command which completes normally
+ * but late during this abort routine runs.  We are allowed to return
+ * late commands to the SCSI stack.  It tracks the state of commands and
+ * will handle late commands.  (Usually, the normal completion of late
+ * commands is ignored with respect to the running abort operation.)
+ */
 int
 zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 {
-	int rc;
-	struct Scsi_Host *scsi_host = scpnt->device->host;
-	spin_lock_irq(scsi_host->host_lock);
-	rc = __zfcp_scsi_eh_abort_handler(scpnt);
-	spin_unlock_irq(scsi_host->host_lock);
-	return rc;
+	struct Scsi_Host *host = scpnt->device->host;
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *) host->hostdata[0];
+	int retval;
+
+	ZFCP_LOG_INFO("aborting scsi_cmnd %p on adapter %s\n",
+		      scpnt, zfcp_get_busid_by_adapter(adapter));
+
+	retval = zfcp_scsi_abort_sync(scpnt);
+  
+  	return retval;
+}
+  
+/**
+ * zfcp_scsi_eh_timed_out - handle timed out SCSI command
+ * @scsi_cmnd: pointer to scsi command which timed out
+ * Return: EH_HANDLED - to notify SCSI layer that we would never call
+ *          scsi_done() for that command
+ */
+enum scsi_eh_timer_return
+zfcp_scsi_eh_timed_out(struct scsi_cmnd *scpnt)
+{
+	struct Scsi_Host *host = scpnt->device->host;
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *) host->hostdata[0];
+
+	ZFCP_LOG_INFO("scsi_cmnd %p on adapter %s timed out\n",
+		      scpnt, zfcp_get_busid_by_adapter(adapter));
+
+        set_host_byte(&scpnt->result, DID_NO_CONNECT);
+	zfcp_scsi_abort_async(scpnt, NULL);
+
+	return EH_HANDLED;
 }
 
 /*
