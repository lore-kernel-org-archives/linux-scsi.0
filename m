From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [13/15] qla2xxx: Device reset fix
Date: Sun, 14 Mar 2004 00:26:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082605.GA3472@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:62653 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263326AbUCNIXg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:23:36 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1669 04/03/02 07:19:11 andrew.vasquez@apc.qlogic.com +1 -0
  During a back-door device reset call, hold off execution of
  commands until the reset is complete.

 drivers/scsi/qla2xxx/qla_os.c |   63 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 59 insertions(+), 4 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/22_device_reset_stall.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:09:42 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:09:42 2004
@@ -664,6 +664,7 @@
 
 	host = cmd->device->host;
 	ha = (scsi_qla_host_t *) host->hostdata;
+	was_empty = 1;
 
 	cmd->scsi_done = fn;
 
@@ -812,13 +813,17 @@
 			sp->err_id = SRB_ERR_PORT;
 
 		add_to_done_queue(ha, sp);
-		if (!list_empty(&ha->done_queue))
-			qla2x00_done(ha);
+		qla2x00_done(ha);
 
 		spin_lock_irq(ha->host->host_lock);
 		return (0);
 	}
-	was_empty = add_to_pending_queue(ha, sp);
+	if (tq && test_bit(TQF_SUSPENDED, &tq->flags)) {
+		/* If target suspended put incoming I/O in retry_q. */
+		qla2x00_extend_timeout(sp->cmd, 10);
+		add_to_scsi_retry_queue(ha, sp);
+	} else
+		was_empty = add_to_pending_queue(ha, sp);
 
 	if ((IS_QLA2100(ha) || IS_QLA2200(ha)) && ha->flags.online) {
 		unsigned long flags;
@@ -1344,6 +1349,9 @@
 	os_tgt_t	*tq;
 	os_lun_t	*lq;
 	fc_port_t	*fcport_to_reset;
+	unsigned long	flags;
+	srb_t		*rp;
+	struct list_head *list, *temp;
 
 	return_status = FAILED;
 	if (cmd == NULL) {
@@ -1375,6 +1383,10 @@
 	}
 	fcport_to_reset = lq->fclun->fcport;
 
+	/* If we are coming in from the back-door, stall I/O until complete. */
+	if (!cmd->device->host->eh_active)
+		set_bit(TQF_SUSPENDED, &tq->flags);
+
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d:%d): DEVICE RESET ISSUED.\n", ha->host_no, b, t, l);
 
@@ -1384,6 +1396,23 @@
 	    ha->host_no, cmd, jiffies, cmd->timeout_per_command / HZ,
 	    ha->dpc_flags, cmd->result, cmd->allowed, cmd->state));
 
+ 	/* Clear commands from the retry queue. */
+ 	spin_lock_irqsave(&ha->list_lock, flags);
+ 	list_for_each_safe(list, temp, &ha->retry_queue) {
+ 		rp = list_entry(list, srb_t, list);
+ 
+ 		if (t != rp->cmd->device->id) 
+ 			continue;
+ 
+ 		DEBUG2(printk(KERN_INFO
+		    "qla2xxx_eh_reset: found in retry queue. SP=%p\n", rp));
+ 
+ 		__del_from_retry_queue(ha, rp);
+ 		rp->cmd->result = DID_RESET << 16;
+ 		__add_to_done_queue(ha, rp);
+ 	}
+ 	spin_unlock_irqrestore(&ha->list_lock, flags);
+
 	spin_unlock_irq(ha->host->host_lock);
 
 	/* Blocking call-Does context switching if abort isp is active etc */  
@@ -1451,6 +1480,9 @@
 
 eh_dev_reset_done:
 
+	if (!cmd->device->host->eh_active)
+		clear_bit(TQF_SUSPENDED, &tq->flags);
+
 	return (return_status);
 }
 
@@ -3155,7 +3187,10 @@
 	unsigned long	flags = 0;
 	struct list_head *list, *templist;
 	int	dead_cnt, online_cnt;
+	int	retry_cmds = 0;
 	uint16_t	next_loopid;
+	int t;
+	os_tgt_t *tq;
 
 	ha = (scsi_qla_host_t *)data;
 
@@ -3267,6 +3302,7 @@
 
 				sp = list_entry(list, srb_t, list);
 				q = sp->lun_queue;
+				tq = sp->tgt_queue;
 
 				DEBUG3(printk("scsi(%ld): scsi_retry_q: "
 				    "pid=%ld sp=%p, spflags=0x%x, "
@@ -3278,7 +3314,15 @@
 				if (q->q_state != LUN_STATE_WAIT) {
 					online_cnt++;
 					__del_from_scsi_retry_queue(ha, sp);
-					__add_to_retry_queue(ha,sp);
+
+					if (test_bit(TQF_RETRY_CMDS,
+					    &tq->flags)) {
+						qla2x00_extend_timeout(sp->cmd,
+						    (sp->cmd->timeout_per_command / HZ) - QLA_CMD_TIMER_DELTA);
+						__add_to_pending_queue(ha, sp);
+						retry_cmds++;
+					} else
+						__add_to_retry_queue(ha, sp);
 				}
 
 				/* Was this command suspended for N secs */
@@ -3293,6 +3337,17 @@
 				}
 			}
 			spin_unlock_irqrestore(&ha->list_lock, flags);
+
+			/* Clear all Target Unsuspended bits */
+			for (t = 0; t < ha->max_targets; t++) {
+				if ((tq = ha->otgt[t]) == NULL)
+					continue;
+
+				if (test_bit(TQF_RETRY_CMDS, &tq->flags))
+					clear_bit(TQF_RETRY_CMDS, &tq->flags);
+			}
+			if (retry_cmds)
+				qla2x00_next(ha);
 
 			DEBUG(if (online_cnt > 0))
 			DEBUG(printk("scsi(%ld): dpc() found scsi reqs to "
