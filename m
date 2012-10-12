From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/10] scsi: Use sdev_printk() for logging
Date: Fri, 12 Oct 2012 10:33:44 +0200
Message-ID: <1350030830-25614-5-git-send-email-hare@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255Ab2JLId5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 04:33:57 -0400
In-Reply-To: <1350030830-25614-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay@vrfy.org>

Most scsi logging messages are using a plain printk, making it
hard to relate to the originating device.
This patchs moves the scsi logging messages to use sdev_printk()
and friends.

Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c       |   16 +++--
 drivers/scsi/scsi_error.c |  147 ++++++++++++++++++++++++++-------------------
 drivers/scsi/scsi_lib.c   |   13 +++--
 drivers/scsi/scsi_scan.c  |   68 +++++++++++----------
 4 files changed, 139 insertions(+), 105 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 28b294b..5797f61 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -691,7 +691,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 
-		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));
+		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
+			"queuecommand : device blocked"));
 
 		/*
 		 * NOTE: rtn is still zero here because we don't need the
@@ -739,8 +740,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	 */
 	if (cmd->cmd_len > cmd->device->host->max_cmd_len) {
 		SCSI_LOG_MLQUEUE(3,
-			printk("queuecommand : command too long. "
-			       "cdb_size=%d host->max_cmd_len=%d\n",
+			       scmd_printk(KERN_INFO, cmd,
+			       "queuecommand : command too long. "
+			       "cdb_size=%d host->max_cmd_len=%d",
 			       cmd->cmd_len, cmd->device->host->max_cmd_len));
 		cmd->result = (DID_ABORT << 16);
 
@@ -766,11 +768,13 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		scsi_queue_insert(cmd, rtn);
 
 		SCSI_LOG_MLQUEUE(3,
-		    printk("queuecommand : request rejected\n"));
+			scmd_printk(KERN_INFO, cmd,
+				    "queuecommand : request rejected"));
 	}
 
  out:
-	SCSI_LOG_MLQUEUE(3, printk("leaving scsi_dispatch_cmnd()\n"));
+	SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
+					"leaving scsi_dispatch_cmnd()"));
 	return rtn;
 }
 
@@ -830,7 +834,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 	if (SCSI_SENSE_VALID(cmd))
 		cmd->result |= (DRIVER_SENSE << 24);
 
-	SCSI_LOG_MLCOMPLETE(4, sdev_printk(KERN_INFO, sdev,
+	SCSI_LOG_MLCOMPLETE(4, scmd_printk(KERN_INFO, cmd,
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..f8d51c5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -62,7 +62,8 @@ void scsi_eh_wakeup(struct Scsi_Host *shost)
 		trace_scsi_eh_wakeup(shost);
 		wake_up_process(shost->ehandler);
 		SCSI_LOG_ERROR_RECOVERY(5,
-				printk("Waking error handler thread\n"));
+			shost_printk(KERN_INFO, shost,
+				     "Waking error handler thread"));
 	}
 }
 
@@ -172,8 +173,9 @@ int scsi_block_when_processing_errors(struct scsi_device *sdev)
 
 	online = scsi_device_online(sdev);
 
-	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: rtn: %d\n", __func__,
-					  online));
+	SCSI_LOG_ERROR_RECOVERY(5, sdev_printk(KERN_INFO, sdev,
+					       "%s: rtn: %d", __func__,
+					       online));
 
 	return online;
 }
@@ -218,7 +220,8 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 		}
 	}
 
-	SCSI_LOG_ERROR_RECOVERY(2, printk("Total of %d commands on %d"
+	SCSI_LOG_ERROR_RECOVERY(2, shost_printk(KERN_INFO, shost,
+					  "Total of %d commands on %d"
 					  " devices require eh work\n",
 				   total_failures, devices_failed));
 }
@@ -527,7 +530,8 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 	struct completion *eh_action;
 
 	SCSI_LOG_ERROR_RECOVERY(3,
-		printk("%s scmd: %p result: %x\n",
+			scmd_printk(KERN_INFO, scmd,
+			"%s scmd: %p result: %x\n",
 			__func__, scmd, scmd->result));
 
 	eh_action = scmd->device->host->eh_action;
@@ -546,7 +550,8 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
+	SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, scmd->device,
+					  "%s: Snd Host RST\n",
 					  __func__));
 
 	if (!hostt->eh_host_reset_handler)
@@ -576,8 +581,8 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
-					  __func__));
+	SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, scmd->device,
+					       "%s: Snd Bus RST\n", __func__));
 
 	if (!hostt->eh_bus_reset_handler)
 		return FAILED;
@@ -809,7 +814,8 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	scsi_log_completion(scmd, SUCCESS);
 
 	SCSI_LOG_ERROR_RECOVERY(3,
-		printk("%s: scmd: %p, timeleft: %ld\n",
+			sdev_printk(KERN_INFO, scmd->device,
+			"%s: scmd: %p, timeleft: %ld",
 			__func__, scmd, timeleft));
 
 	/*
@@ -821,8 +827,9 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	if (timeleft) {
 		rtn = scsi_eh_completed_normally(scmd);
 		SCSI_LOG_ERROR_RECOVERY(3,
-			printk("%s: scsi_eh_completed_normally %x\n",
-			       __func__, rtn));
+				sdev_printk(KERN_INFO, scmd->device,
+				"%s: scsi_eh_completed_normally %x",
+				__func__, rtn));
 
 		switch (rtn) {
 		case SUCCESS:
@@ -925,7 +932,8 @@ int scsi_eh_get_sense(struct list_head *work_q,
 		if (rtn != SUCCESS)
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(3, printk("sense requested for %p"
+		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+						  "sense requested for %p"
 						  " result %x\n", scmd,
 						  scmd->result));
 		SCSI_LOG_ERROR_RECOVERY(3, scsi_print_sense("bh", scmd));
@@ -967,8 +975,8 @@ static int scsi_eh_tur(struct scsi_cmnd *scmd)
 retry_tur:
 	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6, SENSE_TIMEOUT, 0);
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
-		__func__, scmd, rtn));
+	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+		"%s: scmd %p rtn %x", __func__, scmd, rtn));
 
 	switch (rtn) {
 	case NEEDS_RETRY:
@@ -1046,7 +1054,8 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
 			continue;
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
+		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+						  "%s: aborting cmd:"
 						  "0x%p\n", current->comm,
 						  scmd));
 		rtn = scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd);
@@ -1057,7 +1066,8 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 			else
 				list_move_tail(&scmd->eh_entry, &check_list);
 		} else
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting"
+			SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+							  "%s: aborting"
 							  " cmd failed:"
 							  "0x%p\n",
 							  current->comm,
@@ -1120,8 +1130,10 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 		if (!stu_scmd)
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending START_UNIT to sdev:"
-						  " 0x%p\n", current->comm, sdev));
+		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+						"%s: Sending START_UNIT to"
+						" sdev: 0x%p\n",
+						current->comm, sdev));
 
 		if (!scsi_eh_try_stu(stu_scmd)) {
 			if (!scsi_device_online(sdev) ||
@@ -1134,8 +1146,9 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			}
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
-						printk("%s: START_UNIT failed to sdev:"
-						       " 0x%p\n", current->comm, sdev));
+				scmd_printk(KERN_INFO, scmd,
+					    "%s: START_UNIT failed to sdev:"
+					    " 0x%p\n", current->comm, sdev));
 		}
 	}
 
@@ -1174,7 +1187,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 		if (!bdr_scmd)
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BDR sdev:"
+		SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, sdev,
+						  "%s: Sending BDR sdev:"
 						  " 0x%p\n", current->comm,
 						  sdev));
 		rtn = scsi_try_bus_device_reset(bdr_scmd);
@@ -1190,7 +1204,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				}
 			}
 		} else {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: BDR"
+			SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, sdev,
+							  "%s: BDR"
 							  " failed sdev:"
 							  "0x%p\n",
 							  current->comm,
@@ -1227,15 +1242,15 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
 		id = scmd_id(scmd);
 
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
-						  "to target %d\n",
-						  current->comm, id));
+		SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, scmd->device,
+						  "%s: Sending target reset",
+						  current->comm));
 		rtn = scsi_try_target_reset(scmd);
 		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Target reset"
-							  " failed target: "
-							  "%d\n",
-							  current->comm, id));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				sdev_printk(KERN_INFO, scmd->device,
+					    "%s: Target reset failed",
+					    current->comm));
 		list_for_each_entry_safe(scmd, next, &tmp_list, eh_entry) {
 			if (scmd_id(scmd) != id)
 				continue;
@@ -1290,9 +1305,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 
 		if (!chan_scmd)
 			continue;
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BRST chan:"
-						  " %d\n", current->comm,
-						  channel));
+		SCSI_LOG_ERROR_RECOVERY(3,
+			sdev_printk(KERN_INFO, chan_scmd->device,
+				    "%s: Sending BRST", current->comm));
 		rtn = scsi_try_bus_reset(chan_scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
@@ -1306,10 +1321,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 				}
 			}
 		} else {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: BRST"
-							  " failed chan: %d\n",
-							  current->comm,
-							  channel));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				sdev_printk(KERN_INFO, chan_scmd->device,
+					    "%s: BRST failed", current->comm));
 		}
 	}
 	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
@@ -1331,8 +1345,9 @@ static int scsi_eh_host_reset(struct list_head *work_q,
 		scmd = list_entry(work_q->next,
 				  struct scsi_cmnd, eh_entry);
 
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending HRST\n"
-						  , current->comm));
+		SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, scmd->device,
+						       "%s: Sending HRST",
+						       current->comm));
 
 		rtn = scsi_try_host_reset(scmd);
 		if (rtn == SUCCESS) {
@@ -1342,9 +1357,10 @@ static int scsi_eh_host_reset(struct list_head *work_q,
 					scsi_eh_finish_cmd(scmd, done_q);
 			}
 		} else {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: HRST"
-							  " failed\n",
-							  current->comm));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				sdev_printk(KERN_INFO, scmd->device,
+					    "%s: HRST failed",
+					    current->comm));
 		}
 	}
 	return scsi_eh_test_devices(&check_list, work_q, done_q, 1);
@@ -1433,7 +1449,8 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * up to the top level.
 	 */
 	if (!scsi_device_online(scmd->device)) {
-		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: device offline - report"
+		SCSI_LOG_ERROR_RECOVERY(5, sdev_printk(KERN_INFO, scmd->device,
+						  "%s: device offline - report"
 						  " as SUCCESS\n",
 						  __func__));
 		return SUCCESS;
@@ -1681,8 +1698,9 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * will be requests for character device operations, and also for
 	 * ioctls to queued block devices.
 	 */
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
-					  __func__));
+	SCSI_LOG_ERROR_RECOVERY(3, shost_printk(KERN_INFO, shost,
+					"%s: waking up host to restart",
+					__func__));
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_RUNNING))
@@ -1748,10 +1766,10 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 		if (scsi_device_online(scmd->device) &&
 		    !scsi_noretry_cmd(scmd) &&
 		    (++scmd->retries <= scmd->allowed)) {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
-							  " retry cmd: %p\n",
-							  current->comm,
-							  scmd));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_INFO, scmd,
+					    "%s: flush retry cmd: %p\n",
+					    current->comm, scmd));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 		} else {
 			/*
@@ -1761,9 +1779,10 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 			 */
 			if (!scmd->result)
 				scmd->result |= (DRIVER_TIMEOUT << 24);
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
-							" cmd: %p\n",
-							current->comm, scmd));
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_INFO, scmd,
+					    "%s: flush finish cmd: %p\n",
+					    current->comm, scmd));
 			scsi_finish_command(scmd);
 		}
 	}
@@ -1835,16 +1854,18 @@ int scsi_error_handler(void *data)
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
 		    shost->host_failed != shost->host_busy) {
 			SCSI_LOG_ERROR_RECOVERY(1,
-				printk("Error handler scsi_eh_%d sleeping\n",
-					shost->host_no));
+				shost_printk(KERN_INFO, shost,
+					     "Error handler scsi_eh_%d"
+					     " sleeping", shost->host_no));
 			schedule();
 			continue;
 		}
 
 		__set_current_state(TASK_RUNNING);
 		SCSI_LOG_ERROR_RECOVERY(1,
-			printk("Error handler scsi_eh_%d waking up\n",
-				shost->host_no));
+			shost_printk(KERN_INFO, shost,
+				     "Error handler scsi_eh_%d waking up",
+				     shost->host_no));
 
 		/*
 		 * We have a host that is failing for some reason.  Figure out
@@ -1853,9 +1874,10 @@ int scsi_error_handler(void *data)
 		 */
 		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
-				printk(KERN_ERR "Error handler scsi_eh_%d "
-						"unable to autoresume\n",
-						shost->host_no));
+				shost_printk(KERN_ERR, shost,
+					     "Error handler scsi_eh_%d "
+					     "unable to autoresume\n",
+					     shost->host_no));
 			continue;
 		}
 
@@ -1878,7 +1900,9 @@ int scsi_error_handler(void *data)
 	__set_current_state(TASK_RUNNING);
 
 	SCSI_LOG_ERROR_RECOVERY(1,
-		printk("Error handler scsi_eh_%d exiting\n", shost->host_no));
+		shost_printk(KERN_INFO, shost,
+			     "Error handler scsi_eh_%d exiting",
+			     shost->host_no));
 	shost->ehandler = NULL;
 	return 0;
 }
@@ -2028,8 +2052,9 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	 * suspended while we performed the TMF.
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3,
-		printk("%s: waking up host to restart after TMF\n",
-		__func__));
+		shost_printk(KERN_INFO, shost,
+			     "%s: waking up host to restart after TMF",
+			     __func__));
 
 	wake_up(&shost->host_wait);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index da36a3a..a8dbbb1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -135,7 +135,8 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	unsigned long flags;
 
 	SCSI_LOG_MLQUEUE(1,
-		 printk("Inserting command %p into mlqueue\n", cmd));
+		scmd_printk(KERN_INFO, cmd,
+			    "Inserting command %p into mlqueue", cmd));
 
 	/*
 	 * Set the appropriate busy bit for the device/host.
@@ -820,8 +821,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * Next deal with any sectors which we were able to correctly
 	 * handle.
 	 */
-	SCSI_LOG_HLCOMPLETE(1, printk("%u sectors total, "
-				      "%d bytes done.\n",
+	SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, cmd,
+				      "%u sectors total, %d bytes done.",
 				      blk_rq_sectors(req), good_bytes));
 
 	/*
@@ -1370,7 +1371,8 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 		 */
 		if (--shost->host_blocked == 0) {
 			SCSI_LOG_MLQUEUE(3,
-				printk("scsi%d unblocking host at zero depth\n",
+				sdev_printk(KERN_INFO, sdev,
+					"scsi%d unblocking host at zero depth",
 					shost->host_no));
 		} else {
 			return 0;
@@ -1555,7 +1557,8 @@ static void scsi_request_fn(struct request_queue *q)
 		spin_unlock(q->queue_lock);
 		cmd = req->special;
 		if (unlikely(cmd == NULL)) {
-			printk(KERN_CRIT "impossible request in %s.\n"
+			sdev_printk(KERN_CRIT, sdev,
+					 "impossible request in %s.\n"
 					 "please mail a stack trace to "
 					 "linux-scsi@vger.kernel.org\n",
 					 __func__);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..cbf36e1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -198,7 +198,7 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 
-	printk(KERN_NOTICE "scsi: unlocking floptical drive\n");
+	sdev_printk(KERN_NOTICE, sdev, "scsi: unlocking floptical drive");
 	scsi_cmd[0] = MODE_SENSE;
 	scsi_cmd[1] = 0;
 	scsi_cmd[2] = 0x2e;
@@ -396,7 +396,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 
 	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
-		printk(KERN_ERR "%s: allocation failure\n", __func__);
+		shost_printk(KERN_ERR, shost,
+			   "%s: allocation failure", __func__);
 		return NULL;
 	}
 	dev = &starget->dev;
@@ -576,8 +577,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 					  HZ / 2 + HZ * scsi_inq_timeout, 3,
 					  &resid);
 
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY %s "
-				"with code 0x%x\n",
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
 		if (result) {
@@ -647,7 +648,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		}
 
 	} else if (pass == 2) {
-		printk(KERN_INFO "scsi scan: %d byte inquiry failed.  "
+		sdev_printk(KERN_INFO, sdev,
+				"scsi scan: %d byte inquiry failed.  "
 				"Consider BLIST_INQUIRY_36 for this device\n",
 				try_inquiry_len);
 
@@ -682,7 +684,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * strings.
 	 */
 	if (sdev->inquiry_len < 36) {
-		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
+		sdev_printk(KERN_INFO, sdev,
+				"scsi scan: INQUIRY result too short (%d),"
 				" using 36\n", sdev->inquiry_len);
 		sdev->inquiry_len = 36;
 	}
@@ -802,7 +805,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		sdev->writeable = 0;
 		break;
 	default:
-		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
+		sdev_printk(KERN_INFO, sdev, "unknown device type %d",
+			    sdev->type);
 	}
 
 	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
@@ -1016,7 +1020,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
 		if (rescan || !scsi_device_created(sdev)) {
-			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: device exists on %s\n",
 				dev_name(&sdev->sdev_gendev)));
 			if (sdevp)
@@ -1103,9 +1107,9 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
 	    (result[0] & 0x1f) == 0x1f &&
 	    !scsi_is_wlun(lun)) {
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 					"scsi scan: peripheral device type"
-					" of 31, no device added\n"));
+					" of 31, no device added"));
 		res = SCSI_SCAN_TARGET_PRESENT;
 		goto out_free_result;
 	}
@@ -1156,8 +1160,8 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 	unsigned int sparse_lun, lun, max_dev_lun;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sequential scan of"
-				    "%s\n", dev_name(&starget->dev)));
+	SCSI_LOG_SCAN_BUS(3, dev_printk(KERN_INFO, &(starget->dev),
+					"scsi scan: Sequential scan"));
 
 	max_dev_lun = min(max_scsi_luns, shost->max_lun);
 	/*
@@ -1365,7 +1369,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	lun_data = kmalloc(length, GFP_ATOMIC |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!lun_data) {
-		printk(ALLOC_FAILURE_MSG, __func__);
+		sdev_printk(KERN_INFO, sdev, ALLOC_FAILURE_MSG, __func__);
 		goto out;
 	}
 
@@ -1398,16 +1402,17 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	 * a retry.
 	 */
 	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: Sending"
-				" REPORT LUNS to %s (try %d)\n", devname,
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"scsi scan: Sending REPORT LUNS (try %d)",
 				retries));
 
 		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
 					  lun_data, length, &sshdr,
 					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
 
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n", result
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"scsi scan: REPORT LUNS"
+				" %s (try %d) result 0x%x", result
 				?  "failed" : "successful", retries, result));
 		if (result == 0)
 			break;
@@ -1434,9 +1439,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 
 	num_luns = (length / sizeof(struct scsi_lun));
 	if (num_luns > max_scsi_report_luns) {
-		printk(KERN_WARNING "scsi: On %s only %d (max_scsi_report_luns)"
+		sdev_printk(KERN_WARNING, sdev,
+		       "scsi: only %d (max_scsi_report_luns)"
 		       " of %d luns reported, try increasing"
-		       " max_scsi_report_luns.\n", devname,
+		       " max_scsi_report_luns.\n",
 		       max_scsi_report_luns, num_luns);
 		num_luns = max_scsi_report_luns;
 	}
@@ -1456,20 +1462,18 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		 * does not fit in lun.
 		 */
 		if (memcmp(&lunp->scsi_lun[sizeof(lun)], "\0\0\0\0", 4)) {
-			int i;
-
 			/*
 			 * Output an error displaying the LUN in byte order,
 			 * this differs from what linux would print for the
 			 * integer LUN value.
 			 */
-			printk(KERN_WARNING "scsi: %s lun 0x", devname);
-			data = (char *)lunp->scsi_lun;
-			for (i = 0; i < sizeof(struct scsi_lun); i++)
-				printk("%02x", data[i]);
-			printk(" has a LUN larger than currently supported.\n");
+			sdev_printk(KERN_WARNING, sdev,
+			       "scsi: %s lun 0x%08phN has a LUN larger "
+				    " than currently supported.",
+				    devname, lunp->scsi_lun);
 		} else if (lun > sdev->host->max_lun) {
-			printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
+			sdev_printk(KERN_WARNING, sdev,
+			       "scsi: %s lun%d has a LUN larger"
 			       " than allowed by the host adapter\n",
 			       devname, lun);
 		} else {
@@ -1483,8 +1487,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				 */
 				sdev_printk(KERN_ERR, sdev,
 					"Unexpected response"
-				        " from lun %d while scanning, scan"
-				        " aborted\n", lun);
+					" from lun %d while scanning, scan"
+					" aborted\n", lun);
 				break;
 			}
 		}
@@ -1743,8 +1747,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		return NULL;
 
 	if (shost->async_scan) {
-		printk("%s called twice for host %d", __func__,
-				shost->host_no);
+		shost_printk(KERN_INFO, shost, "%s called twice", __func__);
 		dump_stack();
 		return NULL;
 	}
@@ -1797,8 +1800,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 	mutex_lock(&shost->scan_mutex);
 
 	if (!shost->async_scan) {
-		printk("%s called twice for host %d", __func__,
-				shost->host_no);
+		shost_printk(KERN_INFO, shost, "%s called twice", __func__);
 		dump_stack();
 		mutex_unlock(&shost->scan_mutex);
 		return;
-- 
1.7.4.2

