From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (3/4)
Date: Tue, 11 Feb 2003 00:17:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211081744.GC1368@beaverton.ibm.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <20030211081536.GB1368@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e34.co.us.ibm.com (8.12.7/8.12.2) with ESMTP id h1B8G0Iv066814
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 03:16:00 -0500
Received: from hmsbounty (sig-9-65-26-42.mts.ibm.com [9.65.26.42])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.5) with ESMTP id h1B8Fvih113676
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 01:15:58 -0700
Content-Disposition: inline
In-Reply-To: <20030211081536.GB1368@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch series is against scsi-misc-2.5.

02_serror-hndlr-1.diff:
	- Change to using eh_cmd_list.
	- Change scsi_unjam_host to get sense, abort cmds, ready
	  devices, and disposition cmds for retry or finish.
	- Moved retries outside of eh.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 scsi_error.c |  477 +++++++++++++++++++++++++++++------------------------------
 1 files changed, 241 insertions(+), 236 deletions(-)
------

diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Mon Feb 10 22:25:47 2003
+++ b/drivers/scsi/scsi_error.c	Mon Feb 10 22:25:47 2003
@@ -211,36 +211,36 @@
  * @sc_list:	List for failed cmds.
  * @shost:	scsi host being recovered.
  **/
-static void scsi_eh_prt_fail_stats(Scsi_Cmnd *sc_list, struct Scsi_Host *shost)
+static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost)
 {
-	Scsi_Cmnd *scmd;
-	Scsi_Device *sdev;
+	struct scsi_cmnd *scmd;
+	struct scsi_device *sdev;
 	int total_failures = 0;
 	int cmd_failed = 0;
-	int cmd_timed_out = 0;
+	int cmd_cancel = 0;
 	int devices_failed = 0;
 
 
 	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		for (scmd = sc_list; scmd; scmd = scmd->bh_next) {
+		list_for_each_entry(scmd, &shost->eh_cmd_list, eh_list) {
 			if (scmd->device == sdev) {
 				++total_failures;
 				if (scsi_eh_eflags_chk(scmd,
-						       SCSI_EH_CMD_TIMEOUT))
-					++cmd_timed_out;
-				else
+						       SCSI_EH_CANCEL_CMD))
+					++cmd_cancel;
+				else 
 					++cmd_failed;
 			}
 		}
 
-		if (cmd_timed_out || cmd_failed) {
+		if (cmd_cancel || cmd_failed) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				printk("%s: %d:%d:%d:%d cmds failed: %d,"
-				       " timedout: %d\n",
+				       " cancel: %d\n",
 				       __FUNCTION__, shost->host_no,
 				       sdev->channel, sdev->id, sdev->lun,
-				       cmd_failed, cmd_timed_out));
-			cmd_timed_out = 0;
+				       cmd_failed, cmd_cancel));
+			cmd_cancel = 0;
 			cmd_failed = 0;
 			++devices_failed;
 		}
@@ -253,68 +253,6 @@
 #endif
 
 /**
- * scsi_eh_get_failed - Gather failed cmds.
- * @sc_list:	A pointer to a list for failed cmds.
- * @shost:	Scsi host being recovered.
- *
- * XXX Add opaque interator for device / shost. Investigate direct
- * addition to per eh list on error allowing skipping of this step.
- **/
-static void scsi_eh_get_failed(Scsi_Cmnd **sc_list, struct Scsi_Host *shost)
-{
-	int found;
-	Scsi_Device *sdev;
-	Scsi_Cmnd *scmd;
-
-	found = 0;
-	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&sdev->list_lock, flags);
-		list_for_each_entry(scmd, &sdev->cmd_list, list) {
-			if (scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR)) {
-				scmd->bh_next = *sc_list;
-				*sc_list = scmd;
-				found++;
-			} else {
-				/*
-				 * FIXME Verify how this can happen and if
-				 * this is still needed??
-				 */
-			    if (scmd->state != SCSI_STATE_INITIALIZING
-			    && scmd->state != SCSI_STATE_UNUSED) {
-				/*
-				 * Rats.  Something is still floating
-				 * around out there This could be the
-				 * result of the fact that the upper level
-				 * drivers are still frobbing commands
-				 * that might have succeeded.  There are
-				 * two outcomes. One is that the command
-				 * block will eventually be freed, and the
-				 * other one is that the command will be
-				 * queued and will be finished along the
-				 * way.
-				 */
-				SCSI_LOG_ERROR_RECOVERY(1, printk("Error hdlr"
-							  " prematurely woken"
-							  " cmds still active"
-							  " (%p %x %d)\n",
-					       scmd, scmd->state,
-					       scmd->device->id));
-				}
-			}
-		}
-		spin_unlock_irqrestore(&sdev->list_lock, flags);
-	}
-
-	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(*sc_list, shost));
-
-	if (shost->host_failed != found)
-		printk(KERN_ERR "%s: host_failed: %d != found: %d\n", 
-		       __FUNCTION__, shost->host_failed, found);
-}
-
-/**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
  *
@@ -570,7 +508,8 @@
 			spin_lock_irqsave(scmd->device->host->host_lock, flags);
 			if (scmd->device->host->hostt->eh_abort_handler)
 				scmd->device->host->hostt->eh_abort_handler(scmd);
-			spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+			spin_unlock_irqrestore(scmd->device->host->host_lock,
+					       flags);
 			
 			scmd->request->rq_status = RQ_SCSI_DONE;
 			scmd->owner = SCSI_OWNER_ERROR_HANDLER;
@@ -712,6 +651,7 @@
  * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
  * @scmd:	Original SCSI cmd that eh has finished.
  * @shost:	SCSI host that cmd originally failed on.
+ * @done_list:	list_head for processed commands.
  *
  * Notes:
  *    We don't want to use the normal command completion while we are are
@@ -720,7 +660,8 @@
  *    keep a list of pending commands for final completion, and once we
  *    are ready to leave error handling we handle completion for real.
  **/
-static void scsi_eh_finish_cmd(Scsi_Cmnd *scmd, struct Scsi_Host *shost)
+static void scsi_eh_finish_cmd(Scsi_Cmnd *scmd, struct Scsi_Host *shost,
+			       struct list_head *done_list )
 {
 	shost->host_failed--;
 	scmd->state = SCSI_STATE_BHQUEUE;
@@ -731,12 +672,14 @@
 	 * things.
 	 */
 	scsi_setup_cmd_retry(scmd);
+
+	list_move_tail(&scmd->eh_list, done_list);
 }
 
 /**
  * scsi_eh_get_sense - Get device sense data.
- * @sc_todo:	list of cmds that have failed.
  * @shost:	scsi host being recovered.
+ * @done_list:	list_head for processed commands.
  *
  * Description:
  *    See if we need to request sense information.  if so, then get it
@@ -754,23 +697,23 @@
  *
  *    In 2.5 this capability will be going away.
  **/
-static int scsi_eh_get_sense(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
+static int scsi_eh_get_sense(struct Scsi_Host *shost,
+			     struct list_head *done_list)
 {
 	int rtn;
+	struct list_head *lh, *lh_sf;
 	Scsi_Cmnd *scmd;
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: checking to see if we need"
-					  " to request sense\n",
-					  __FUNCTION__));
-
-	for (scmd = sc_todo; scmd; scmd = scmd->bh_next) {
-		if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_FAILED) ||
+	list_for_each_safe(lh, lh_sf, &shost->eh_cmd_list) {
+		scmd = list_entry(lh, struct scsi_cmnd, eh_list);
+		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD) ||
 		    SCSI_SENSE_VALID(scmd))
 			continue;
 
 		SCSI_LOG_ERROR_RECOVERY(2, printk("%s: requesting sense"
-						  " for tgt: %d\n",
-						  __FUNCTION__, scmd->device->id));
+						  " for id: %d\n",
+						  current->comm,
+						  scmd->device->id));
 		rtn = scsi_request_sense(scmd);
 		if (rtn != SUCCESS)
 			continue;
@@ -787,7 +730,7 @@
 		 * upper level.
 		 */
 		if (rtn == SUCCESS)
-			scsi_eh_finish_cmd(scmd, shost);
+			scsi_eh_finish_cmd(scmd, shost, done_list);
 		if (rtn != NEEDS_RETRY)
 			continue;
 
@@ -806,10 +749,10 @@
 		/*
 		 * we eventually hand this one back to the top level.
 		 */
-		scsi_eh_finish_cmd(scmd, shost);
+		scsi_eh_finish_cmd(scmd, shost, done_list);
 	}
 
-	return shost->host_failed;
+	return list_empty(&shost->eh_cmd_list);
 }
 
 /**
@@ -899,9 +842,9 @@
 }
 
 /**
- * scsi_eh_abort_cmd - abort a timed-out cmd.
- * @sc_todo:	A list of cmds that have failed.
+ * scsi_eh_abort_cmds - abort canceled commands.
  * @shost:	scsi host being recovered.
+ * @done_list:	list_head for processed commands.
  *
  * Decription:
  *    Try and see whether or not it makes sense to try and abort the
@@ -910,29 +853,36 @@
  *    no sense to try and abort the command, since as far as the shost
  *    adapter is concerned, it isn't running.
  **/
-static int scsi_eh_abort_cmd(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
+static int scsi_eh_abort_cmds(struct Scsi_Host *shost,
+			      struct list_head *done_list)
 {
-
 	int rtn;
-	Scsi_Cmnd *scmd;
+	struct list_head *lh, *lh_sf;
+	struct scsi_cmnd *scmd;
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: checking to see if we need"
-					  " to abort cmd\n", __FUNCTION__));
-
-	for (scmd = sc_todo; scmd; scmd = scmd->bh_next) {
-		if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_TIMEOUT))
+	list_for_each_safe(lh, lh_sf, &shost->eh_cmd_list) {
+		scmd = list_entry(lh, struct scsi_cmnd, eh_list);
+		if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD))
 			continue;
-
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
+						  "0x%p\n", current->comm,
+						  scmd));
 		rtn = scsi_try_to_abort_cmd(scmd);
 		if (rtn == SUCCESS) {
-			if (!scsi_eh_tur(scmd)) {
-				rtn = scsi_eh_retry_cmd(scmd);
-				if (rtn == SUCCESS)
-					scsi_eh_finish_cmd(scmd, shost);
+			scsi_eh_eflags_clr(scmd,  SCSI_EH_CANCEL_CMD);
+			if (!scmd->device->online || !scsi_eh_tur(scmd)) {
+				scsi_eh_finish_cmd(scmd, shost, done_list);
 			}
-		}
+				
+		} else
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting"
+							  " cmd failed:"
+							  "0x%p\n",
+							  current->comm,
+							  scmd));
 	}
-	return shost->host_failed;
+
+	return list_empty(&shost->eh_cmd_list);
 }
 
 /**
@@ -968,9 +918,9 @@
 }
 
 /**
- * scsi_eh_bus_device_reset - send bdr is needed
- * @sc_todo:	a list of cmds that have failed.
+ * scsi_eh_bus_device_reset - send bdr if needed
  * @shost:	scsi host being recovered.
+ * @done_list:	list_head for processed commands.
  *
  * Notes:
  *    Try a bus device reset.  still, look to see whether we have multiple
@@ -978,39 +928,52 @@
  *    makes no sense to try bus_device_reset - we really would need to try
  *    a bus_reset instead. 
  **/
-static int scsi_eh_bus_device_reset(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
+static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
+				    struct list_head *done_list)
 {
 	int rtn;
-	Scsi_Cmnd *scmd;
-	Scsi_Device *sdev;
-
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Trying BDR\n", __FUNCTION__));
+	struct list_head *lh, *lh_sf;
+	struct scsi_cmnd *scmd, *bdr_scmd;
+	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		for (scmd = sc_todo; scmd; scmd = scmd->bh_next)
-			if ((scmd->device == sdev) &&
-			    scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR))
+		bdr_scmd = NULL;
+		list_for_each_entry(scmd, &shost->eh_cmd_list, eh_list)
+			if (scmd->device == sdev) {
+				bdr_scmd = scmd;
 				break;
+			}
 
-		if (!scmd)
+		if (!bdr_scmd)
 			continue;
 
-		/*
-		 * ok, we have a device that is having problems.  try and send
-		 * a bus device reset to it.
-		 */
-		rtn = scsi_try_bus_device_reset(scmd);
-		if ((rtn == SUCCESS) && (!scsi_eh_tur(scmd)))
-				for (scmd = sc_todo; scmd; scmd = scmd->bh_next)
-					if ((scmd->device == sdev) &&
-					    scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR)) {
-						rtn = scsi_eh_retry_cmd(scmd);
-						if (rtn == SUCCESS)
-							scsi_eh_finish_cmd(scmd, shost);
-					}
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BDR sdev:"
+						  " 0x%p\n", current->comm,
+						  sdev));
+		rtn = scsi_try_bus_device_reset(bdr_scmd);
+		if (rtn == SUCCESS) {
+			if (!sdev->online || !scsi_eh_tur(bdr_scmd)) {
+				list_for_each_safe(lh, lh_sf,
+						   &shost->eh_cmd_list) {
+					scmd = list_entry(lh, struct
+							  scsi_cmnd,
+							  eh_list);
+					if (scmd->device == sdev)
+						scsi_eh_finish_cmd(scmd,
+								   shost,
+								   done_list);
+				}
+			}
+		} else {
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: BDR"
+							  " failed sdev:"
+							  "0x%p\n",
+							  current->comm,
+							   sdev));
+		}
 	}
 
-	return shost->host_failed;
+	return list_empty(&shost->eh_cmd_list);
 }
 
 /**
@@ -1040,7 +1003,8 @@
 		/*
 		 * Mark all affected devices to expect a unit attention.
 		 */
-		list_for_each_entry(sdev, &scmd->device->host->my_devices, siblings)
+		list_for_each_entry(sdev, &scmd->device->host->my_devices,
+				    siblings)
 			if (scmd->device->channel == sdev->channel) {
 				sdev->was_reset = 1;
 				sdev->expecting_cc_ua = 1;
@@ -1076,7 +1040,8 @@
 		/*
 		 * Mark all affected devices to expect a unit attention.
 		 */
-		list_for_each_entry(sdev, &scmd->device->host->my_devices, siblings)
+		list_for_each_entry(sdev, &scmd->device->host->my_devices,
+				    siblings)
 			if (scmd->device->channel == sdev->channel) {
 				sdev->was_reset = 1;
 				sdev->expecting_cc_ua = 1;
@@ -1086,26 +1051,20 @@
 }
 
 /**
- * scsi_eh_bus_host_reset - send a bus reset and on failure try host reset
- * @sc_todo:	a list of cmds that have failed.
+ * scsi_eh_bus_reset - send a bus reset 
  * @shost:	scsi host being recovered.
+ * @done_list:	list_head for processed commands.
  **/
-static int scsi_eh_bus_host_reset(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
+static int scsi_eh_bus_reset(struct Scsi_Host *shost,
+			     struct list_head *done_list)
 {
 	int rtn;
+	struct list_head *lh, *lh_sf;
 	Scsi_Cmnd *scmd;
 	Scsi_Cmnd *chan_scmd;
 	unsigned int channel;
 
 	/*
-	 * if we ended up here, we have serious problems.  the only thing left
-	 * to try is a full bus reset.  if someone has grabbed the bus and isn't
-	 * letting go, then perhaps this will help.
-	 */
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Try Bus/Host RST\n",
-					  __FUNCTION__));
-
-	/* 
 	 * we really want to loop over the various channels, and do this on
 	 * a channel by channel basis.  we should also check to see if any
 	 * of the failed commands are on soft_reset devices, and if so, skip
@@ -1113,9 +1072,8 @@
 	 */
 
 	for (channel = 0; channel <= shost->max_channel; channel++) {
-		for (scmd = sc_todo; scmd; scmd = scmd->bh_next) {
-			if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR))
-				continue;
+		chan_scmd = NULL;
+		list_for_each_entry(scmd, &shost->eh_cmd_list, eh_list) {
 			if (channel == scmd->device->channel) {
 				chan_scmd = scmd;
 				break;
@@ -1126,63 +1084,97 @@
 			}
 		}
 
-		if (!scmd)
+		if (!chan_scmd)
 			continue;
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BRST chan:"
+						  " %d\n", current->comm,
+						  channel));
+		rtn = scsi_try_bus_reset(chan_scmd);
+		if (rtn == SUCCESS) {
+			list_for_each_safe(lh, lh_sf, &shost->eh_cmd_list) {
+				scmd = list_entry(lh, struct scsi_cmnd,
+						  eh_list);
+				if (channel == scmd->device->channel)
+					if (!scmd->device->online ||
+					    !scsi_eh_tur(scmd))
+						scsi_eh_finish_cmd(scmd,
+								   shost,
+								   done_list);
+			}
+		} else {
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: BRST"
+							  " failed chan: %d\n",
+							  current->comm,
+							  channel));
+		}
+	}
+	return list_empty(&shost->eh_cmd_list);
+}
 
-		/*
-		 * we now know that we are able to perform a reset for the
-		 * channel that scmd points to.
-		 */
-		rtn = scsi_try_bus_reset(scmd);
-		if (rtn != SUCCESS)
-			rtn = scsi_try_host_reset(scmd);
+/**
+ * scsi_eh_host_reset - send a host reset 
+ * @shost:	scsi host being recovered.
+ * @done_list:	list_head for processed commands.
+ **/
+static int scsi_eh_host_reset(struct Scsi_Host *shost,
+			      struct list_head *done_list)
+{
+	int rtn;
+	struct list_head *lh, *lh_sf;
+	Scsi_Cmnd *scmd;
 
-		if (rtn == SUCCESS) {
-			for (scmd = sc_todo; scmd; scmd = scmd->bh_next) {
-				if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR)
-				    || channel != scmd->device->channel)
-					continue;
-				if (!scsi_eh_tur(scmd)) {
-					rtn = scsi_eh_retry_cmd(scmd);
+	if (!list_empty(&shost->eh_cmd_list)) {
+		scmd = list_entry(shost->eh_cmd_list.next,
+				  struct scsi_cmnd, eh_list);
 
-					if (rtn == SUCCESS)
-						scsi_eh_finish_cmd(scmd, shost);
-				}
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending HRST\n"
+						  , current->comm));
+
+		rtn = scsi_try_host_reset(scmd);
+		if (rtn == SUCCESS) {
+			list_for_each_safe(lh, lh_sf, &shost->eh_cmd_list) {
+				scmd = list_entry(lh, struct scsi_cmnd, eh_list);
+				if (!scmd->device->online || !scsi_eh_tur(scmd)) 
+					scsi_eh_finish_cmd(scmd, shost,
+							   done_list);
 			}
+		} else {
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: HRST"
+							  " failed\n",
+							  current->comm));
 		}
-
 	}
-	return shost->host_failed;
+	return list_empty(&shost->eh_cmd_list);
 }
 
 /**
  * scsi_eh_offline_sdevs - offline scsi devices that fail to recover
- * @sc_todo:	a list of cmds that have failed.
  * @shost:	scsi host being recovered.
+ * @done_list:	list_head for processed commands.
  *
  **/
-static void scsi_eh_offline_sdevs(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
+static void scsi_eh_offline_sdevs(struct Scsi_Host *shost,
+				  struct list_head *done_list)
 {
+	struct list_head *lh, *lh_sf;
 	Scsi_Cmnd *scmd;
 
-	for (scmd = sc_todo; scmd; scmd = scmd->bh_next) {
-		if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR))
-			continue;
-
+	list_for_each_safe(lh, lh_sf, &shost->eh_cmd_list) {
+		scmd = list_entry(lh, struct scsi_cmnd, eh_list);
 		printk(KERN_INFO "scsi: Device offlined - not"
-				" ready or command retry failed"
-				" after error recovery: host"
+		       		" ready after error recovery: host"
 				" %d channel %d id %d lun %d\n",
 				shost->host_no,
 				scmd->device->channel,
 				scmd->device->id,
 				scmd->device->lun);
-
-		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_TIMEOUT))
-			scmd->result |= (DRIVER_TIMEOUT << 24);
-
-		scmd->device->online = 0;
-		scsi_eh_finish_cmd(scmd, shost);
+		scmd->device->online = FALSE;
+		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD)) {
+			/*
+			 * FIXME: Handle lost cmds.
+			 */
+		}
+		scsi_eh_finish_cmd(scmd, shost, done_list);
 	}
 	return;
 }
@@ -1477,6 +1469,8 @@
 
 	ASSERT_LOCK(shost->host_lock, 0);
 
+	shost->in_recovery = 0;
+
 	/*
 	 * If the door was locked, we need to insert a door lock request
 	 * onto the head of the SCSI request queue for the device.  There
@@ -1517,6 +1511,56 @@
 }
 
 /**
+ * scsi_eh_ready_devs - check device ready state and recover if not.
+ * @shost: 	host to be recovered.
+ * @done_list:	list_head for processed commands.
+ *
+ **/
+static void scsi_eh_ready_devs(struct Scsi_Host *shost,
+			       struct list_head *done_list)
+{
+	if (scsi_eh_bus_device_reset(shost, done_list))
+		if (scsi_eh_bus_reset(shost, done_list))
+			if (scsi_eh_host_reset(shost, done_list))
+				scsi_eh_offline_sdevs(shost, done_list);
+}
+
+/**
+ * scsi_eh_flush_done_list - finish processed commands or retry them.
+ * @shost: 	host to be recovered.
+ * @done_list:	list_head of processed commands.
+ *
+ **/
+static void scsi_eh_flush_done_list(struct Scsi_Host *shost,
+				    struct list_head *done_list)
+{
+	struct list_head *lh, *lh_sf;
+	Scsi_Cmnd *scmd;
+
+	list_for_each_safe(lh, lh_sf, done_list) {
+		scmd = list_entry(lh, struct scsi_cmnd, eh_list);
+		list_del_init(lh);
+		if (!scmd->device->online) {
+			 scmd->result |= (DRIVER_TIMEOUT << 24);
+		} else {
+			if (++scmd->retries < scmd->allowed) {
+				SCSI_LOG_ERROR_RECOVERY(3,
+					printk("%s: flush retry"
+					       " cmd: %p\n",
+						  current->comm,
+						  scmd));
+				scsi_retry_command(scmd);
+				continue;
+			}
+		}
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
+				       " cmd: %p\n",
+					  current->comm, scmd));
+		scsi_finish_command(scmd);
+	}
+}
+
+/**
  * scsi_unjam_host - Attempt to fix a host which has a cmd that failed.
  * @shost:	Host to unjam.
  *
@@ -1541,60 +1585,15 @@
  **/
 static void scsi_unjam_host(struct Scsi_Host *shost)
 {
-	Scsi_Cmnd *sc_todo = NULL;
-	Scsi_Cmnd *scmd;
-
-	/*
-	 * Is this assert really ok anymore (andmike). Should we at least
-	 * be using spin_lock_unlocked.
-	 */
-	ASSERT_LOCK(shost->host_lock, 0);
-
-	scsi_eh_get_failed(&sc_todo, shost);
-
-	if (scsi_eh_get_sense(sc_todo, shost))
-		if (scsi_eh_abort_cmd(sc_todo, shost))
-			if (scsi_eh_bus_device_reset(sc_todo, shost))
-				if (scsi_eh_bus_host_reset(sc_todo, shost))
-					scsi_eh_offline_sdevs(sc_todo, shost);
+	LIST_HEAD(done_list);
 
-	BUG_ON(shost->host_failed);
+	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(shost));
 
+	if (!scsi_eh_get_sense(shost, &done_list))
+		if (!scsi_eh_abort_cmds(shost, &done_list))
+			scsi_eh_ready_devs(shost, &done_list);
 
-	/*
-	 * We are currently holding these things in a linked list - we
-	 * didn't put them in the bottom half queue because we wanted to
-	 * keep things quiet while we were working on recovery, and
-	 * passing them up to the top level could easily cause the top
-	 * level to try and queue something else again.
-	 *
-	 * start by marking that the host is no longer in error recovery.
-	 */
-	shost->in_recovery = 0;
-
-	/*
-	 * take the list of commands, and stick them in the bottom half queue.
-	 * the current implementation of scsi_done will do this for us - if need
-	 * be we can create a special version of this function to do the
-	 * same job for us.
-	 */
-	for (scmd = sc_todo; scmd; scmd = sc_todo) {
-		sc_todo = scmd->bh_next;
-		scmd->bh_next = NULL;
-		/*
-		 * Oh, this is a vile hack.  scsi_done() expects a timer
-		 * to be running on the command.  If there isn't, it assumes
-		 * that the command has actually timed out, and a timer
-		 * handler is running.  That may well be how we got into
-		 * this fix, but right now things are stable.  We add
-		 * a timer back again so that we can report completion.
-		 * scsi_done() will immediately remove said timer from
-		 * the command, and then process it.
-		 */
-		scsi_add_timer(scmd, 100, scsi_eh_times_out);
-		scsi_done(scmd);
-	}
-
+	scsi_eh_flush_done_list(shost, &done_list);
 }
 
 /**
@@ -1642,7 +1641,8 @@
 	/*
 	 * Wake up the thread that created us.
 	 */
-	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of scsi_eh_%d\n",shost->host_no));
+	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of"
+					  " scsi_eh_%d\n",shost->host_no));
 
 	complete(shost->eh_notify);
 
@@ -1652,7 +1652,9 @@
 		 * away and die.  This typically happens if the user is
 		 * trying to unload a module.
 		 */
-		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d sleeping\n",shost->host_no));
+		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
+						  " scsi_eh_%d"
+						  " sleeping\n",shost->host_no));
 
 		/*
 		 * Note - we always use down_interruptible with the semaphore
@@ -1667,7 +1669,9 @@
 		if (shost->eh_kill)
 			break;
 
-		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d waking up\n",shost->host_no));
+		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
+						  " scsi_eh_%d waking"
+						  " up\n",shost->host_no));
 
 		shost->eh_active = 1;
 
@@ -1695,7 +1699,8 @@
 
 	}
 
-	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d exiting\n",shost->host_no));
+	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d"
+					  " exiting\n",shost->host_no));
 
 	/*
 	 * Make sure that nobody tries to wake us up again.
