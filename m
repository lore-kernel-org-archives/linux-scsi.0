From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] scsi: use dev_printk variants where possible
Date: Wed, 25 Jun 2014 16:39:59 +0200
Message-ID: <1403707199-102664-7-git-send-email-hare@suse.de>
References: <1403707199-102664-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbaFYOkF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2014 10:40:05 -0400
In-Reply-To: <1403707199-102664-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Using dev_printk variants prefixes the logging message with
the originating device, which makes debugging easier.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/hosts.c      |  15 ++--
 drivers/scsi/scsi.c       |  18 ++---
 drivers/scsi/scsi_error.c | 179 +++++++++++++++++++++++++---------------------
 drivers/scsi/scsi_lib.c   |  22 +++---
 drivers/scsi/scsi_scan.c  |  62 ++++++++--------
 5 files changed, 157 insertions(+), 139 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3cbb57a..0632eee 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -204,12 +204,12 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	struct scsi_host_template *sht = shost->hostt;
 	int error = -EINVAL;
 
-	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
+	shost_printk(KERN_INFO, shost, "%s\n",
 			sht->info ? sht->info(shost) : sht->name);
 
 	if (!shost->can_queue) {
-		printk(KERN_ERR "%s: can_queue = 0 no longer supported\n",
-				sht->name);
+		shost_printk(KERN_ERR, shost,
+			     "can_queue = 0 no longer supported\n");
 		goto fail;
 	}
 
@@ -450,8 +450,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->ehandler = kthread_run(scsi_error_handler, shost,
 			"scsi_eh_%d", shost->host_no);
 	if (IS_ERR(shost->ehandler)) {
-		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error = %ld\n",
-			shost->host_no, PTR_ERR(shost->ehandler));
+		shost_printk(KERN_WARNING, shost,
+			"error handler thread failed to spawn, error = %ld\n",
+			PTR_ERR(shost->ehandler));
 		goto fail_kfree;
 	}
 
@@ -584,7 +585,7 @@ EXPORT_SYMBOL(scsi_is_host_device);
 int scsi_queue_work(struct Scsi_Host *shost, struct work_struct *work)
 {
 	if (unlikely(!shost->work_q)) {
-		printk(KERN_ERR
+		shost_printk(KERN_ERR, shost,
 			"ERROR: Scsi host '%s' attempted to queue scsi-work, "
 			"when no workqueue created.\n", shost->hostt->name);
 		dump_stack();
@@ -603,7 +604,7 @@ EXPORT_SYMBOL_GPL(scsi_queue_work);
 void scsi_flush_work(struct Scsi_Host *shost)
 {
 	if (!shost->work_q) {
-		printk(KERN_ERR
+		shost_printk(KERN_ERR, shost,
 			"ERROR: Scsi host '%s' attempted to flush scsi-work, "
 			"when no workqueue created.\n", shost->hostt->name);
 		dump_stack();
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index bff351b..ce5b4e5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -655,7 +655,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 	/* Check to see if the scsi lld made this device blocked. */
 	if (unlikely(scsi_device_blocked(cmd->device))) {
-		/* 
+		/*
 		 * in blocked state, the command is just put back on
 		 * the device queue.  The suspend state has already
 		 * blocked the queue so future requests should not
@@ -665,7 +665,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 
-		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));
+		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
+			"queuecommand : device blocked\n"));
 
 		/*
 		 * NOTE: rtn is still zero here because we don't need the
@@ -674,7 +675,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	/* 
+	/*
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
 	 */
 	if (cmd->device->scsi_level <= SCSI_2 &&
@@ -690,8 +691,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	 * length exceeds what the host adapter can handle.
 	 */
 	if (cmd->cmd_len > cmd->device->host->max_cmd_len) {
-		SCSI_LOG_MLQUEUE(3,
-			printk("queuecommand : command too long. "
+		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
+			       "queuecommand : command too long. "
 			       "cdb_size=%d host->max_cmd_len=%d\n",
 			       cmd->cmd_len, cmd->device->host->max_cmd_len));
 		cmd->result = (DID_ABORT << 16);
@@ -715,14 +716,13 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		    rtn != SCSI_MLQUEUE_TARGET_BUSY)
 			rtn = SCSI_MLQUEUE_HOST_BUSY;
 
-		scsi_queue_insert(cmd, rtn);
+		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
+			"queuecommand : request rejected\n"));
 
-		SCSI_LOG_MLQUEUE(3,
-		    printk("queuecommand : request rejected\n"));
+		scsi_queue_insert(cmd, rtn);
 	}
 
  out:
-	SCSI_LOG_MLQUEUE(3, printk("leaving scsi_dispatch_cmnd()\n"));
 	return rtn;
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4f36ae2..e4a5324 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -62,8 +62,8 @@ void scsi_eh_wakeup(struct Scsi_Host *shost)
 	if (shost->host_busy == shost->host_failed) {
 		trace_scsi_eh_wakeup(shost);
 		wake_up_process(shost->ehandler);
-		SCSI_LOG_ERROR_RECOVERY(5,
-				printk("Waking error handler thread\n"));
+		SCSI_LOG_ERROR_RECOVERY(5, shost_printk(KERN_INFO, shost,
+			"Waking error handler thread\n"));
 	}
 }
 
@@ -319,8 +319,8 @@ int scsi_block_when_processing_errors(struct scsi_device *sdev)
 
 	online = scsi_device_online(sdev);
 
-	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: rtn: %d\n", __func__,
-					  online));
+	SCSI_LOG_ERROR_RECOVERY(5, sdev_printk(KERN_INFO, sdev,
+		"%s: rtn: %d\n", __func__, online));
 
 	return online;
 }
@@ -365,8 +365,9 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 		}
 	}
 
-	SCSI_LOG_ERROR_RECOVERY(2, printk("Total of %d commands on %d"
-					  " devices require eh work\n",
+	SCSI_LOG_ERROR_RECOVERY(2, shost_printk(KERN_INFO, shost,
+				   "Total of %d commands on %d"
+				   " devices require eh work\n",
 				   total_failures, devices_failed));
 }
 #endif
@@ -738,8 +739,8 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 {
 	struct completion *eh_action;
 
-	SCSI_LOG_ERROR_RECOVERY(3,
-		printk("%s scmd: %p result: %x\n",
+	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+			"%s scmd: %p result: %x\n",
 			__func__, scmd, scmd->result));
 
 	eh_action = scmd->device->host->eh_action;
@@ -758,8 +759,8 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
-					  __func__));
+	SCSI_LOG_ERROR_RECOVERY(3,
+		shost_printk(KERN_INFO, host, "Snd Host RST\n"));
 
 	if (!hostt->eh_host_reset_handler)
 		return FAILED;
@@ -788,8 +789,8 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
-					  __func__));
+	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+		"%s: Snd Bus RST\n", __func__));
 
 	if (!hostt->eh_bus_reset_handler)
 		return FAILED;
@@ -1036,8 +1037,8 @@ retry:
 
 	scsi_log_completion(scmd, rtn);
 
-	SCSI_LOG_ERROR_RECOVERY(3,
-		printk("%s: scmd: %p, timeleft: %ld\n",
+	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+			"%s: scmd: %p, timeleft: %ld\n",
 			__func__, scmd, timeleft));
 
 	/*
@@ -1051,9 +1052,8 @@ retry:
 	 */
 	if (timeleft) {
 		rtn = scsi_eh_completed_normally(scmd);
-		SCSI_LOG_ERROR_RECOVERY(3,
-			printk("%s: scsi_eh_completed_normally %x\n",
-			       __func__, rtn));
+		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+			"%s: scsi_eh_completed_normally %x\n", __func__, rtn));
 
 		switch (rtn) {
 		case SUCCESS:
@@ -1177,9 +1177,9 @@ int scsi_eh_get_sense(struct list_head *work_q,
 		if (rtn != SUCCESS)
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(3, printk("sense requested for %p"
-						  " result %x\n", scmd,
-						  scmd->result));
+		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+			"sense requested for %p result %x\n",
+			scmd, scmd->result));
 		SCSI_LOG_ERROR_RECOVERY(3, scsi_print_sense("bh", scmd));
 
 		rtn = scsi_decide_disposition(scmd);
@@ -1220,8 +1220,8 @@ retry_tur:
 	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6,
 				scmd->device->eh_timeout, 0);
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
-		__func__, scmd, rtn));
+	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+		"%s: scmd %p rtn %x\n", __func__, scmd, rtn));
 
 	switch (rtn) {
 	case NEEDS_RETRY:
@@ -1323,16 +1323,16 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 					     __func__));
 			return list_empty(work_q);
 		}
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
-						  "0x%p\n", current->comm,
-						  scmd));
+		SCSI_LOG_ERROR_RECOVERY(3,
+			shost_printk(KERN_INFO, shost,
+				     "%s: aborting cmd: 0x%p\n",
+				     current->comm, scmd));
 		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
 		if (rtn == FAILED) {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting"
-							  " cmd failed:"
-							  "0x%p\n",
-							  current->comm,
-							  scmd));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					     "%s: aborting cmd failed: 0x%p\n",
+					     current->comm, scmd));
 			list_splice_init(&check_list, work_q);
 			return list_empty(work_q);
 		}
@@ -1406,8 +1406,10 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 		if (!stu_scmd)
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending START_UNIT to sdev:"
-						  " 0x%p\n", current->comm, sdev));
+		SCSI_LOG_ERROR_RECOVERY(3,
+			shost_printk(KERN_INFO, shost,
+				     "%s: Sending START_UNIT to sdev: 0x%p\n",
+				     current->comm, sdev));
 
 		if (!scsi_eh_try_stu(stu_scmd)) {
 			if (!scsi_device_online(sdev) ||
@@ -1421,8 +1423,9 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			}
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
-						printk("%s: START_UNIT failed to sdev:"
-						       " 0x%p\n", current->comm, sdev));
+				shost_printk(KERN_INFO, shost,
+					     "%s: START_UNIT failed to sdev:"
+					     " 0x%p\n", current->comm, sdev));
 		}
 	}
 
@@ -1468,9 +1471,10 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 		if (!bdr_scmd)
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BDR sdev:"
-						  " 0x%p\n", current->comm,
-						  sdev));
+		SCSI_LOG_ERROR_RECOVERY(3,
+			shost_printk(KERN_INFO, shost,
+				     "%s: Sending BDR sdev: 0x%p\n",
+				     current->comm, sdev));
 		rtn = scsi_try_bus_device_reset(bdr_scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			if (!scsi_device_online(sdev) ||
@@ -1485,11 +1489,10 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				}
 			}
 		} else {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: BDR"
-							  " failed sdev:"
-							  "0x%p\n",
-							  current->comm,
-							   sdev));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					     "%s: BDR failed sdev: 0x%p\n",
+					     current->comm, sdev));
 		}
 	}
 
@@ -1533,15 +1536,17 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
 		id = scmd_id(scmd);
 
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
-						  "to target %d\n",
-						  current->comm, id));
+		SCSI_LOG_ERROR_RECOVERY(3,
+			shost_printk(KERN_INFO, shost,
+				     "%s: Sending target reset to target %d\n",
+				     current->comm, id));
 		rtn = scsi_try_target_reset(scmd);
 		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Target reset"
-							  " failed target: "
-							  "%d\n",
-							  current->comm, id));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					     "%s: Target reset failed"
+					     " target: %d\n",
+					     current->comm, id));
 		list_for_each_entry_safe(scmd, next, &tmp_list, eh_entry) {
 			if (scmd_id(scmd) != id)
 				continue;
@@ -1605,9 +1610,10 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 
 		if (!chan_scmd)
 			continue;
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BRST chan:"
-						  " %d\n", current->comm,
-						  channel));
+		SCSI_LOG_ERROR_RECOVERY(3,
+			shost_printk(KERN_INFO, shost,
+				     "%s: Sending BRST chan: %d\n",
+				     current->comm, channel));
 		rtn = scsi_try_bus_reset(chan_scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
@@ -1621,10 +1627,10 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 				}
 			}
 		} else {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: BRST"
-							  " failed chan: %d\n",
-							  current->comm,
-							  channel));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					     "%s: BRST failed chan: %d\n",
+					     current->comm, channel));
 		}
 	}
 	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
@@ -1635,7 +1641,8 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
  * @work_q:	list_head for processed commands.
  * @done_q:	list_head for processed commands.
  */
-static int scsi_eh_host_reset(struct list_head *work_q,
+static int scsi_eh_host_reset(struct Scsi_Host *shost,
+			      struct list_head *work_q,
 			      struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
@@ -1646,8 +1653,10 @@ static int scsi_eh_host_reset(struct list_head *work_q,
 		scmd = list_entry(work_q->next,
 				  struct scsi_cmnd, eh_entry);
 
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending HRST\n"
-						  , current->comm));
+		SCSI_LOG_ERROR_RECOVERY(3,
+			shost_printk(KERN_INFO, shost,
+				     "%s: Sending HRST\n",
+				     current->comm));
 
 		rtn = scsi_try_host_reset(scmd);
 		if (rtn == SUCCESS) {
@@ -1657,9 +1666,10 @@ static int scsi_eh_host_reset(struct list_head *work_q,
 					scsi_eh_finish_cmd(scmd, done_q);
 			}
 		} else {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: HRST"
-							  " failed\n",
-							  current->comm));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					     "%s: HRST failed\n",
+					     current->comm));
 		}
 	}
 	return scsi_eh_test_devices(&check_list, work_q, done_q, 1);
@@ -1751,9 +1761,8 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * up to the top level.
 	 */
 	if (!scsi_device_online(scmd->device)) {
-		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: device offline - report"
-						  " as SUCCESS\n",
-						  __func__));
+		SCSI_LOG_ERROR_RECOVERY(5, scmd_printk(KERN_INFO, scmd,
+			"%s: device offline - report as SUCCESS\n", __func__));
 		return SUCCESS;
 	}
 
@@ -1999,8 +2008,7 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * ioctls to queued block devices.
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3,
-		printk("scsi_eh_%d waking up host to restart\n",
-		       shost->host_no));
+		shost_printk(KERN_INFO, shost, "waking up host to restart\n"));
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_RUNNING))
@@ -2047,7 +2055,7 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 		if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
 			if (!scsi_eh_target_reset(shost, work_q, done_q))
 				if (!scsi_eh_bus_reset(shost, work_q, done_q))
-					if (!scsi_eh_host_reset(work_q, done_q))
+					if (!scsi_eh_host_reset(shost, work_q, done_q))
 						scsi_eh_offline_sdevs(work_q,
 								      done_q);
 }
@@ -2066,10 +2074,10 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 		if (scsi_device_online(scmd->device) &&
 		    !scsi_noretry_cmd(scmd) &&
 		    (++scmd->retries <= scmd->allowed)) {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
-							  " retry cmd: %p\n",
-							  current->comm,
-							  scmd));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_INFO, scmd,
+					     "%s: flush retry cmd: %p\n",
+					     current->comm, scmd));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 		} else {
 			/*
@@ -2079,9 +2087,10 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 			 */
 			if (!scmd->result)
 				scmd->result |= (DRIVER_TIMEOUT << 24);
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
-							" cmd: %p\n",
-							current->comm, scmd));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_INFO, scmd,
+					     "%s: flush finish cmd: %p\n",
+					     current->comm, scmd));
 			scsi_finish_command(scmd);
 		}
 	}
@@ -2157,17 +2166,19 @@ int scsi_error_handler(void *data)
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
 		    shost->host_failed != shost->host_busy) {
 			SCSI_LOG_ERROR_RECOVERY(1,
-				printk("scsi_eh_%d: sleeping\n",
-					shost->host_no));
+				shost_printk(KERN_INFO, shost,
+					     "scsi_eh_%d: sleeping\n",
+					     shost->host_no));
 			schedule();
 			continue;
 		}
 
 		__set_current_state(TASK_RUNNING);
 		SCSI_LOG_ERROR_RECOVERY(1,
-			printk("scsi_eh_%d: waking up %d/%d/%d\n",
-			       shost->host_no, shost->host_eh_scheduled,
-			       shost->host_failed, shost->host_busy));
+			shost_printk(KERN_INFO, shost,
+				     "scsi_eh_%d: waking up %d/%d/%d\n",
+				     shost->host_no, shost->host_eh_scheduled,
+				     shost->host_failed, shost->host_busy));
 
 		/*
 		 * We have a host that is failing for some reason.  Figure out
@@ -2201,7 +2212,9 @@ int scsi_error_handler(void *data)
 	__set_current_state(TASK_RUNNING);
 
 	SCSI_LOG_ERROR_RECOVERY(1,
-		printk("Error handler scsi_eh_%d exiting\n", shost->host_no));
+		shost_printk(KERN_INFO, shost,
+			     "Error handler scsi_eh_%d exiting\n",
+			     shost->host_no));
 	shost->ehandler = NULL;
 	return 0;
 }
@@ -2362,8 +2375,8 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	 * suspended while we performed the TMF.
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3,
-		printk("%s: waking up host to restart after TMF\n",
-		__func__));
+		shost_printk(KERN_INFO, shost,
+			     "waking up host to restart after TMF\n"));
 
 	wake_up(&shost->host_wait);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7e3163..d5d22e4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -95,8 +95,8 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	struct request_queue *q = device->request_queue;
 	unsigned long flags;
 
-	SCSI_LOG_MLQUEUE(1,
-		 printk("Inserting command %p into mlqueue\n", cmd));
+	SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
+		"Inserting command %p into mlqueue\n", cmd));
 
 	/*
 	 * Set the appropriate busy bit for the device/host.
@@ -742,9 +742,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * Next deal with any sectors which we were able to correctly
 	 * handle.
 	 */
-	SCSI_LOG_HLCOMPLETE(1, printk("%u sectors total, "
-				      "%d bytes done.\n",
-				      blk_rq_sectors(req), good_bytes));
+	SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, cmd,
+		"%u sectors total, %d bytes done.\n",
+		blk_rq_sectors(req), good_bytes));
 
 	/*
 	 * Recovered errors need reporting, but they're always treated
@@ -1343,8 +1343,8 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 		 */
 		if (--shost->host_blocked == 0) {
 			SCSI_LOG_MLQUEUE(3,
-				printk("scsi%d unblocking host at zero depth\n",
-					shost->host_no));
+				shost_printk(KERN_INFO, shost,
+					     "unblocking host at zero depth\n"));
 		} else {
 			return 0;
 		}
@@ -1453,7 +1453,7 @@ static void scsi_softirq_done(struct request *rq)
 			    wait_for/HZ);
 		disposition = SUCCESS;
 	}
-			
+
 	scsi_log_completion(cmd, disposition);
 
 	switch (disposition) {
@@ -1501,7 +1501,7 @@ static void scsi_request_fn(struct request_queue *q)
 		int rtn;
 		/*
 		 * get next queueable request.  We do this early to make sure
-		 * that the request is fully prepared even if we cannot 
+		 * that the request is fully prepared even if we cannot
 		 * accept it.
 		 */
 		req = blk_peek_request(q);
@@ -2139,9 +2139,9 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 	return 0;
 
  illegal:
-	SCSI_LOG_ERROR_RECOVERY(1, 
+	SCSI_LOG_ERROR_RECOVERY(1,
 				sdev_printk(KERN_ERR, sdev,
-					    "Illegal state transition %s->%s\n",
+					    "Illegal state transition %s->%s",
 					    scsi_device_state_name(oldstate),
 					    scsi_device_state_name(state))
 				);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 553e1c7..f12dca7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -194,7 +194,7 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 
-	printk(KERN_NOTICE "scsi: unlocking floptical drive\n");
+	sdev_printk(KERN_NOTICE, sdev, "unlocking floptical drive\n");
 	scsi_cmd[0] = MODE_SENSE;
 	scsi_cmd[1] = 0;
 	scsi_cmd[2] = 0x2e;
@@ -596,8 +596,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 					  HZ / 2 + HZ * scsi_inq_timeout, 3,
 					  &resid);
 
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY %s "
-				"with code 0x%x\n",
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
 		if (result) {
@@ -667,9 +667,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		}
 
 	} else if (pass == 2) {
-		printk(KERN_INFO "scsi scan: %d byte inquiry failed.  "
-				"Consider BLIST_INQUIRY_36 for this device\n",
-				try_inquiry_len);
+		sdev_printk(KERN_INFO, sdev,
+			    "scsi scan: %d byte inquiry failed.  "
+			    "Consider BLIST_INQUIRY_36 for this device\n",
+			    try_inquiry_len);
 
 		/* If this pass failed, the third pass goes back and transfers
 		 * the same amount as we successfully got in the first pass. */
@@ -702,8 +703,9 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * strings.
 	 */
 	if (sdev->inquiry_len < 36) {
-		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
-				" using 36\n", sdev->inquiry_len);
+		sdev_printk(KERN_INFO, sdev,
+			    "scsi scan: INQUIRY result too short (%d),"
+			    " using 36\n", sdev->inquiry_len);
 		sdev->inquiry_len = 36;
 	}
 
@@ -822,7 +824,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		sdev->writeable = 0;
 		break;
 	default:
-		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
+		sdev_printk(KERN_INFO, sdev, "unknown device type %d\n",
+			    sdev->type);
 	}
 
 	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
@@ -1044,7 +1047,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
 		if (rescan || !scsi_device_created(sdev)) {
-			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: device exists on %s\n",
 				dev_name(&sdev->sdev_gendev)));
 			if (sdevp)
@@ -1131,7 +1134,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
 	    (result[0] & 0x1f) == 0x1f &&
 	    !scsi_is_wlun(lun)) {
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 					"scsi scan: peripheral device type"
 					" of 31, no device added\n"));
 		res = SCSI_SCAN_TARGET_PRESENT;
@@ -1185,8 +1188,8 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 	u64 sparse_lun, lun;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sequential scan of"
-				    "%s\n", dev_name(&starget->dev)));
+	SCSI_LOG_SCAN_BUS(3, starget_printk(KERN_INFO, starget,
+		"scsi scan: Sequential scan\n"));
 
 	max_dev_lun = min(max_scsi_luns, shost->max_lun);
 	/*
@@ -1431,17 +1434,19 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	 * a retry.
 	 */
 	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: Sending"
-				" REPORT LUNS to %s (try %d)\n", devname,
+		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+				"scsi scan: Sending REPORT LUNS to (try %d)\n",
 				retries));
 
 		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
 					  lun_data, length, &sshdr,
 					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
 
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n", result
-				?  "failed" : "successful", retries, result));
+		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+				"scsi scan: REPORT LUNS"
+				" %s (try %d) result 0x%x\n",
+				result ?  "failed" : "successful",
+				retries, result));
 		if (result == 0)
 			break;
 		else if (scsi_sense_valid(&sshdr)) {
@@ -1467,10 +1472,11 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 
 	num_luns = (length / sizeof(struct scsi_lun));
 	if (num_luns > max_scsi_report_luns) {
-		printk(KERN_WARNING "scsi: On %s only %d (max_scsi_report_luns)"
-		       " of %d luns reported, try increasing"
-		       " max_scsi_report_luns.\n", devname,
-		       max_scsi_report_luns, num_luns);
+		sdev_printk(KERN_WARNING, sdev,
+			    "Only %d (max_scsi_report_luns)"
+			    " of %d luns reported, try increasing"
+			    " max_scsi_report_luns.\n",
+			    max_scsi_report_luns, num_luns);
 		num_luns = max_scsi_report_luns;
 	}
 
@@ -1485,9 +1491,9 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		lun = scsilun_to_int(lunp);
 
 		if (lun > sdev->host->max_lun) {
-			printk(KERN_WARNING "scsi: %s lun%llu has a LUN larger"
-			       " than allowed by the host adapter\n",
-			       devname, lun);
+			sdev_printk(KERN_WARNING, sdev,
+				    "lun%llu has a LUN larger than"
+				    " allowed by the host adapter\n", lun);
 		} else {
 			int res;
 
@@ -1765,8 +1771,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		return NULL;
 
 	if (shost->async_scan) {
-		printk("%s called twice for host %d", __func__,
-				shost->host_no);
+		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
 		dump_stack();
 		return NULL;
 	}
@@ -1819,8 +1824,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 	mutex_lock(&shost->scan_mutex);
 
 	if (!shost->async_scan) {
-		printk("%s called twice for host %d", __func__,
-				shost->host_no);
+		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
 		dump_stack();
 		mutex_unlock(&shost->scan_mutex);
 		return;
-- 
1.7.12.4

