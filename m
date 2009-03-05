From: michaelc@cs.wisc.edu
Subject: [PATCH 04/14] libiscsi: replace scsi_debug logging with session/conn logging
Date: Thu,  5 Mar 2009 14:45:58 -0600
Message-ID: <12362859734023-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52788 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbZCEUqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:19 -0500
In-Reply-To: <123628597367-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This makes the logging a compile time option and replaces
the scsi_debug macro with session and connection ones
that print out a driver model id prefix.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |  164 +++++++++++++++++++++++++++++-----------------
 include/scsi/libiscsi.h |    7 --
 2 files changed, 103 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c33e28f..701457c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -38,6 +38,28 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/libiscsi.h>
 
+static int iscsi_dbg_lib;
+module_param_named(debug_libiscsi, iscsi_dbg_lib, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug_libiscsi, "Turn on debugging for libiscsi module. "
+		 "Set to 1 to turn on, and zero to turn off. Default "
+		 "is off.");
+
+#define ISCSI_DBG_CONN(_conn, dbg_fmt, arg...)			\
+	do {							\
+		if (iscsi_dbg_lib)				\
+			iscsi_conn_printk(KERN_INFO, _conn,	\
+					     "%s " dbg_fmt,	\
+					     __func__, ##arg);	\
+	} while (0);
+
+#define ISCSI_DBG_SESSION(_session, dbg_fmt, arg...)			\
+	do {								\
+		if (iscsi_dbg_lib)					\
+			iscsi_session_printk(KERN_INFO, _session,	\
+					     "%s " dbg_fmt,		\
+					     __func__, ##arg);		\
+	} while (0);
+
 /* Serial Number Arithmetic, 32 bits, less than, RFC1982 */
 #define SNA32_CHECK 2147483648UL
 
@@ -176,10 +198,11 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_task *task)
 	ecdb_ahdr->reserved = 0;
 	memcpy(ecdb_ahdr->ecdb, cmd->cmnd + ISCSI_CDB_SIZE, rlen);
 
-	debug_scsi("iscsi_prep_ecdb_ahs: varlen_cdb_len %d "
-		   "rlen %d pad_len %d ahs_length %d iscsi_headers_size %u\n",
-		   cmd->cmd_len, rlen, pad_len, ahslength, task->hdr_len);
-
+	ISCSI_DBG_SESSION(task->conn->session,
+			  "iscsi_prep_ecdb_ahs: varlen_cdb_len %d "
+		          "rlen %d pad_len %d ahs_length %d iscsi_headers_size "
+		          "%u\n", cmd->cmd_len, rlen, pad_len, ahslength,
+		          task->hdr_len);
 	return 0;
 }
 
@@ -201,10 +224,11 @@ static int iscsi_prep_bidi_ahs(struct iscsi_task *task)
 	rlen_ahdr->reserved = 0;
 	rlen_ahdr->read_length = cpu_to_be32(scsi_in(sc)->length);
 
-	debug_scsi("bidi-in rlen_ahdr->read_length(%d) "
-		   "rlen_ahdr->ahslength(%d)\n",
-		   be32_to_cpu(rlen_ahdr->read_length),
-		   be16_to_cpu(rlen_ahdr->ahslength));
+	ISCSI_DBG_SESSION(task->conn->session,
+			  "bidi-in rlen_ahdr->read_length(%d) "
+		          "rlen_ahdr->ahslength(%d)\n",
+		          be32_to_cpu(rlen_ahdr->read_length),
+		          be16_to_cpu(rlen_ahdr->ahslength));
 	return 0;
 }
 
@@ -335,13 +359,15 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	list_move_tail(&task->running, &conn->run_list);
 
 	conn->scsicmd_pdus_cnt++;
-	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x len %d "
-		   "bidi_len %d cmdsn %d win %d]\n", scsi_bidi_cmnd(sc) ?
-		   "bidirectional" : sc->sc_data_direction == DMA_TO_DEVICE ?
-		   "write" : "read", conn->id, sc, sc->cmnd[0], task->itt,
-		   scsi_bufflen(sc),
-		   scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
-		   session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
+	ISCSI_DBG_SESSION(session, "iscsi prep [%s cid %d sc %p cdb 0x%x "
+			  "itt 0x%x len %d bidi_len %d cmdsn %d win %d]\n",
+			  scsi_bidi_cmnd(sc) ? "bidirectional" :
+			  sc->sc_data_direction == DMA_TO_DEVICE ?
+			  "write" : "read", conn->id, sc, sc->cmnd[0],
+			  task->itt, scsi_bufflen(sc),
+			  scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
+			  session->cmdsn,
+			  session->max_cmdsn - session->exp_cmdsn + 1);
 	return 0;
 }
 
@@ -483,9 +509,9 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 
 	task->state = ISCSI_TASK_RUNNING;
 	list_move_tail(&task->running, &conn->mgmt_run_list);
-	debug_scsi("mgmtpdu [op 0x%x hdr->itt 0x%x datalen %d]\n",
-		   hdr->opcode & ISCSI_OPCODE_MASK, hdr->itt,
-		   task->data_count);
+	ISCSI_DBG_SESSION(session, "mgmtpdu [op 0x%x hdr->itt 0x%x "
+			  "datalen %d]\n", hdr->opcode & ISCSI_OPCODE_MASK,
+			  hdr->itt, task->data_count);
 	return 0;
 }
 
@@ -637,8 +663,9 @@ invalid_datalen:
 
 		memcpy(sc->sense_buffer, data + 2,
 		       min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
-		debug_scsi("copied %d bytes of sense\n",
-			   min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
+		ISCSI_DBG_SESSION(session, "copied %d bytes of sense\n",
+				  min_t(uint16_t, senselen,
+				  SCSI_SENSE_BUFFERSIZE));
 	}
 
 	if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
@@ -666,8 +693,8 @@ invalid_datalen:
 			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	}
 out:
-	debug_scsi("done [sc %lx res %d itt 0x%x]\n",
-		   (long)sc, sc->result, task->itt);
+	ISCSI_DBG_SESSION(session, "done [sc %p res %d itt 0x%x]\n",
+			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
 
 	__iscsi_put_task(task);
@@ -835,8 +862,8 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	else
 		itt = ~0U;
 
-	debug_scsi("[op 0x%x cid %d itt 0x%x len %d]\n",
-		   opcode, conn->id, itt, datalen);
+	ISCSI_DBG_SESSION(session, "[op 0x%x cid %d itt 0x%x len %d]\n",
+			  opcode, conn->id, itt, datalen);
 
 	if (itt == ~0U) {
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
@@ -1095,10 +1122,10 @@ static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
 	 * Check for iSCSI window and take care of CmdSN wrap-around
 	 */
 	if (!iscsi_sna_lte(session->queued_cmdsn, session->max_cmdsn)) {
-		debug_scsi("iSCSI CmdSN closed. ExpCmdSn %u MaxCmdSN %u "
-			   "CmdSN %u/%u\n", session->exp_cmdsn,
-			   session->max_cmdsn, session->cmdsn,
-			   session->queued_cmdsn);
+		ISCSI_DBG_SESSION(session, "iSCSI CmdSN closed. ExpCmdSn "
+				  "%u MaxCmdSN %u CmdSN %u/%u\n",
+				  session->exp_cmdsn, session->max_cmdsn,
+				  session->cmdsn, session->queued_cmdsn);
 		return -ENOSPC;
 	}
 	return 0;
@@ -1152,7 +1179,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 
 	spin_lock_bh(&conn->session->lock);
 	if (unlikely(conn->suspend_tx)) {
-		debug_scsi("conn %d Tx suspended!\n", conn->id);
+		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
 		spin_unlock_bh(&conn->session->lock);
 		return -ENODATA;
 	}
@@ -1398,7 +1425,8 @@ prepd_reject:
 	iscsi_complete_command(task);
 reject:
 	spin_unlock(&session->lock);
-	debug_scsi("cmd 0x%x rejected (%d)\n", sc->cmnd[0], reason);
+	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
+			  sc->cmnd[0], reason);
 	spin_lock(host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
@@ -1407,7 +1435,8 @@ prepd_fault:
 	iscsi_complete_command(task);
 fault:
 	spin_unlock(&session->lock);
-	debug_scsi("iscsi: cmd 0x%x is not queued (%d)\n", sc->cmnd[0], reason);
+	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
+			  sc->cmnd[0], reason);
 	if (!scsi_bidi_cmnd(sc))
 		scsi_set_resid(sc, scsi_bufflen(sc));
 	else {
@@ -1457,8 +1486,10 @@ int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_TERMINATE) {
 failed:
-		debug_scsi("failing target reset: session terminated "
-			   "[CID %d age %d]\n", conn->id, session->age);
+		iscsi_session_printk(KERN_INFO, session,
+				     "failing target reset: Could not log "
+				     "back into target [age %d]\n",
+				     session->age);
 		spin_unlock_bh(&session->lock);
 		mutex_unlock(&session->eh_mutex);
 		return FAILED;
@@ -1472,7 +1503,7 @@ failed:
 	 */
 	iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 
-	debug_scsi("iscsi_eh_target_reset wait for relogin\n");
+	ISCSI_DBG_SESSION(session, "wait for relogin\n");
 	wait_event_interruptible(conn->ehwait,
 				 session->state == ISCSI_STATE_TERMINATE ||
 				 session->state == ISCSI_STATE_LOGGED_IN ||
@@ -1501,7 +1532,7 @@ static void iscsi_tmf_timedout(unsigned long data)
 	spin_lock(&session->lock);
 	if (conn->tmf_state == TMF_QUEUED) {
 		conn->tmf_state = TMF_TIMEDOUT;
-		debug_scsi("tmf timedout\n");
+		ISCSI_DBG_SESSION(session, "tmf timedout\n");
 		/* unblock eh_abort() */
 		wake_up(&conn->ehwait);
 	}
@@ -1521,7 +1552,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 		spin_unlock_bh(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		spin_lock_bh(&session->lock);
-		debug_scsi("tmf exec failure\n");
+		ISCSI_DBG_SESSION(session, "tmf exec failure\n");
 		return -EPERM;
 	}
 	conn->tmfcmd_pdus_cnt++;
@@ -1529,7 +1560,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	conn->tmf_timer.function = iscsi_tmf_timedout;
 	conn->tmf_timer.data = (unsigned long)conn;
 	add_timer(&conn->tmf_timer);
-	debug_scsi("tmf set timeout\n");
+	ISCSI_DBG_SESSION(session, "tmf set timeout\n");
 
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
@@ -1573,16 +1604,18 @@ static void fail_all_commands(struct iscsi_conn *conn, unsigned lun,
 	/* flush pending */
 	list_for_each_entry_safe(task, tmp, &conn->xmitqueue, running) {
 		if (lun == task->sc->device->lun || lun == -1) {
-			debug_scsi("failing pending sc %p itt 0x%x\n",
-				   task->sc, task->itt);
+			ISCSI_DBG_SESSION(conn->session,
+					  "failing pending sc %p itt 0x%x\n",
+					  task->sc, task->itt);
 			fail_command(conn, task, error << 16);
 		}
 	}
 
 	list_for_each_entry_safe(task, tmp, &conn->requeue, running) {
 		if (lun == task->sc->device->lun || lun == -1) {
-			debug_scsi("failing requeued sc %p itt 0x%x\n",
-				   task->sc, task->itt);
+			ISCSI_DBG_SESSION(conn->session,
+					  "failing requeued sc %p itt 0x%x\n",
+					  task->sc, task->itt);
 			fail_command(conn, task, error << 16);
 		}
 	}
@@ -1590,8 +1623,9 @@ static void fail_all_commands(struct iscsi_conn *conn, unsigned lun,
 	/* fail all other running */
 	list_for_each_entry_safe(task, tmp, &conn->run_list, running) {
 		if (lun == task->sc->device->lun || lun == -1) {
-			debug_scsi("failing in progress sc %p itt 0x%x\n",
-				   task->sc, task->itt);
+			ISCSI_DBG_SESSION(conn->session,
+					 "failing in progress sc %p itt 0x%x\n",
+					 task->sc, task->itt);
 			fail_command(conn, task, error << 16);
 		}
 	}
@@ -1622,7 +1656,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
 	cls_session = starget_to_session(scsi_target(scmd->device));
 	session = cls_session->dd_data;
 
-	debug_scsi("scsi cmd %p timedout\n", scmd);
+	ISCSI_DBG_SESSION(session, "scsi cmd %p timedout\n", scmd);
 
 	spin_lock(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
@@ -1662,8 +1696,8 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
 		rc = BLK_EH_RESET_TIMER;
 done:
 	spin_unlock(&session->lock);
-	debug_scsi("return %s\n", rc == BLK_EH_RESET_TIMER ?
-					"timer reset" : "nh");
+	ISCSI_DBG_SESSION(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
+			  "timer reset" : "nh");
 	return rc;
 }
 
@@ -1697,13 +1731,13 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 
 	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
 		/* send a ping to try to provoke some traffic */
-		debug_scsi("Sending nopout as ping on conn %p\n", conn);
+		ISCSI_DBG_CONN(conn, "Sending nopout as ping\n");
 		iscsi_send_nopout(conn, NULL);
 		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
 	} else
 		next_timeout = last_recv + recv_timeout;
 
-	debug_scsi("Setting next tmo %lu\n", next_timeout);
+	ISCSI_DBG_CONN(conn, "Setting next tmo %lu\n", next_timeout);
 	mod_timer(&conn->transport_timer, next_timeout);
 done:
 	spin_unlock(&session->lock);
@@ -1740,7 +1774,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	 * got the command.
 	 */
 	if (!sc->SCp.ptr) {
-		debug_scsi("sc never reached iscsi layer or it completed.\n");
+		ISCSI_DBG_SESSION(session, "sc never reached iscsi layer or "
+				  "it completed.\n");
 		spin_unlock_bh(&session->lock);
 		mutex_unlock(&session->eh_mutex);
 		return SUCCESS;
@@ -1762,11 +1797,13 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	age = session->age;
 
 	task = (struct iscsi_task *)sc->SCp.ptr;
-	debug_scsi("aborting [sc %p itt 0x%x]\n", sc, task->itt);
+	ISCSI_DBG_SESSION(session, "aborting [sc %p itt 0x%x]\n",
+			  sc, task->itt);
 
 	/* task completed before time out */
 	if (!task->sc) {
-		debug_scsi("sc completed while abort in progress\n");
+		ISCSI_DBG_SESSION(session, "sc completed while abort in "
+				  "progress\n");
 		goto success;
 	}
 
@@ -1815,7 +1852,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		if (!sc->SCp.ptr) {
 			conn->tmf_state = TMF_INITIAL;
 			/* task completed before tmf abort response */
-			debug_scsi("sc completed while abort in progress\n");
+			ISCSI_DBG_SESSION(session, "sc completed while abort "
+					  "in progress\n");
 			goto success;
 		}
 		/* fall through */
@@ -1827,15 +1865,16 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 success:
 	spin_unlock_bh(&session->lock);
 success_unlocked:
-	debug_scsi("abort success [sc %lx itt 0x%x]\n", (long)sc, task->itt);
+	ISCSI_DBG_SESSION(session, "abort success [sc %p itt 0x%x]\n",
+			  sc, task->itt);
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 
 failed:
 	spin_unlock_bh(&session->lock);
 failed_unlocked:
-	debug_scsi("abort failed [sc %p itt 0x%x]\n", sc,
-		    task ? task->itt : 0);
+	ISCSI_DBG_SESSION(session, "abort failed [sc %p itt 0x%x]\n", sc,
+			  task ? task->itt : 0);
 	mutex_unlock(&session->eh_mutex);
 	return FAILED;
 }
@@ -1862,7 +1901,8 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
-	debug_scsi("LU Reset [sc %p lun %u]\n", sc, sc->device->lun);
+	ISCSI_DBG_SESSION(session, "LU Reset [sc %p lun %u]\n",
+			  sc, sc->device->lun);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
@@ -1916,8 +1956,8 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 unlock:
 	spin_unlock_bh(&session->lock);
 done:
-	debug_scsi("iscsi_eh_device_reset %s\n",
-		  rc == SUCCESS ? "SUCCESS" : "FAILED");
+	ISCSI_DBG_SESSION(session, "dev reset result = %s\n",
+			 rc == SUCCESS ? "SUCCESS" : "FAILED");
 	mutex_unlock(&session->eh_mutex);
 	return rc;
 }
@@ -2466,14 +2506,16 @@ flush_control_queues(struct iscsi_session *session, struct iscsi_conn *conn)
 
 	/* handle pending */
 	list_for_each_entry_safe(task, tmp, &conn->mgmtqueue, running) {
-		debug_scsi("flushing pending mgmt task itt 0x%x\n", task->itt);
+		ISCSI_DBG_SESSION(session, "flushing pending mgmt task "
+				  "itt 0x%x\n", task->itt);
 		/* release ref from prep task */
 		__iscsi_put_task(task);
 	}
 
 	/* handle running */
 	list_for_each_entry_safe(task, tmp, &conn->mgmt_run_list, running) {
-		debug_scsi("flushing running mgmt task itt 0x%x\n", task->itt);
+		ISCSI_DBG_SESSION(session, "flushing running mgmt task "
+				  "itt 0x%x\n", task->itt);
 		/* release ref from prep task */
 		__iscsi_put_task(task);
 	}
@@ -2523,7 +2565,7 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 		conn->datadgst_en = 0;
 		if (session->state == ISCSI_STATE_IN_RECOVERY &&
 		    old_stop_stage != STOP_CONN_RECOVER) {
-			debug_scsi("blocking session\n");
+			ISCSI_DBG_SESSION(session, "blocking session\n");
 			iscsi_block_session(session->cls_session);
 		}
 	}
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7360e19..67542aa 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -45,13 +45,6 @@ struct iscsi_session;
 struct iscsi_nopin;
 struct device;
 
-/* #define DEBUG_SCSI */
-#ifdef DEBUG_SCSI
-#define debug_scsi(fmt...) printk(KERN_INFO "iscsi: " fmt)
-#else
-#define debug_scsi(fmt...)
-#endif
-
 #define ISCSI_DEF_XMIT_CMDS_MAX	128	/* must be power of 2 */
 #define ISCSI_MGMT_CMDS_MAX	15
 
-- 
1.6.0.6

