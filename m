From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [1/3]   qla2xxx: remove internal queuing.
Date: Fri, 04 Feb 2005 11:24:31 -0800
Message-ID: <1107545071.14183.15.camel@plap.san.rr.com>
References: <1107544908.14183.11.camel@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from avexch01.qlogic.com ([198.70.193.200]:37946 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S264895AbVBDTYN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 14:24:13 -0500
In-Reply-To: <1107544908.14183.11.camel@plap.san.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: andrew.vasquez@qlogic.com

  Remove internal command queuing from the driver.  As is, this
  driver cannot tolerate cable-pulls as I/Os will begin to fail
  by the upper layers.
  
     o Should be used in conjuction with the 
       11-fc_rport_adds.diff patch.
     o Removes qla_listops.h file -- no longer needed.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_listops.h |  351 ------
 drivers/scsi/qla2xxx/qla_def.h     |   22 
 drivers/scsi/qla2xxx/qla_gbl.h     |    6 
 drivers/scsi/qla2xxx/qla_init.c    |  106 -
 drivers/scsi/qla2xxx/qla_iocb.c    |   13 
 drivers/scsi/qla2xxx/qla_isr.c     |  147 --
 drivers/scsi/qla2xxx/qla_os.c      | 1911 ++++-------------------------------
 7 files changed, 276 insertions(+), 2280 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2005-02-04 08:36:55 -08:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2005-02-04 08:36:55 -08:00
@@ -2175,27 +2175,6 @@
 	uint32_t	current_outstanding_cmd; 
 	srb_t		*status_srb;	/* Status continuation entry. */
 
-	/*
-	 * Need to hold the list_lock with irq's disabled in order to access
-	 * the following list.
-	 *
-	 * This list_lock is of lower priority than the host_lock.
-	 */
-	spinlock_t		list_lock ____cacheline_aligned;
-						/* lock to guard lists which
-						 * hold srb_t's */
-        struct list_head        retry_queue;    /* watchdog queue */
-        struct list_head        done_queue;     /* job on done queue */
-        struct list_head        failover_queue; /* failover list link. */
-	struct list_head        scsi_retry_queue;     /* SCSI retry queue */
-	struct list_head        pending_queue;	/* SCSI command pending queue */
-
-	unsigned long    done_q_cnt;
-	unsigned long    pending_in_q;
-        uint32_t	retry_q_cnt; 
-        uint32_t	scsi_retry_q_cnt; 
-        uint32_t	failover_cnt; 
-
 	unsigned long	last_irq_cpu;	/* cpu where we got our last irq */
 
 	uint16_t           revision;
@@ -2479,7 +2458,6 @@
 #include "qla_gbl.h"
 #include "qla_dbg.h"
 #include "qla_inline.h"
-#include "qla_listops.h"
 
 /*
 * String arrays
diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	2005-02-04 08:36:55 -08:00
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2005-02-04 08:36:55 -08:00
@@ -74,6 +74,7 @@
 #if defined(MODULE)
 extern char *ql2xopts;
 #endif
+extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
 
 extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
@@ -82,16 +83,11 @@
 extern int __qla2x00_suspend_lun(scsi_qla_host_t *, os_lun_t *, int, int, int);
 
 extern void qla2x00_done(scsi_qla_host_t *);
-extern void qla2x00_next(scsi_qla_host_t *);
 extern void qla2x00_flush_failover_q(scsi_qla_host_t *, os_lun_t *);
 extern void qla2x00_reset_lun_fo_counts(scsi_qla_host_t *, os_lun_t *);
 
-extern void qla2x00_extend_timeout(struct scsi_cmnd *, int);
-
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *);
-
-extern void qla2x00_abort_queues(scsi_qla_host_t *, uint8_t);
 
 extern void qla2x00_blink_led(scsi_qla_host_t *);
 
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2005-02-04 08:36:55 -08:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2005-02-04 08:36:55 -08:00
@@ -3146,7 +3146,6 @@
 				wait_time &&
 				(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
 		}
-		qla2x00_restart_queues(ha, 1);
 	}
 
 	if (test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) {
@@ -3160,87 +3159,6 @@
 	return (rval);
 }
 
-/*
- *  qla2x00_restart_queues
- *	Restart device queues.
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Context:
- *	Kernel/Interrupt context.
- */
-void
-qla2x00_restart_queues(scsi_qla_host_t *ha, uint8_t flush) 
-{
-	srb_t  		*sp;
-	int		retry_q_cnt = 0;
-	int		pending_q_cnt = 0;
-	struct list_head *list, *temp;
-	unsigned long flags = 0;
-
-	clear_bit(RESTART_QUEUES_NEEDED, &ha->dpc_flags);
-
-	/* start pending queue */
-	pending_q_cnt = ha->qthreads;
-	if (flush) {
-		spin_lock_irqsave(&ha->list_lock,flags);
-		list_for_each_safe(list, temp, &ha->pending_queue) {
-			sp = list_entry(list, srb_t, list);
-
-			if ((sp->flags & SRB_TAPE))
-				continue;
-			 
-			/* 
-			 * When time expire return request back to OS as BUSY 
-			 */
-			__del_from_pending_queue(ha, sp);
-			sp->cmd->result = DID_BUS_BUSY << 16;
-			sp->cmd->host_scribble = (unsigned char *)NULL;
-			__add_to_done_queue(ha, sp);
-		}
-		spin_unlock_irqrestore(&ha->list_lock, flags);
-	} else {
-		if (!list_empty(&ha->pending_queue))
-			qla2x00_next(ha);
-	}
-
-	/*
-	 * Clear out our retry queue
-	 */
-	if (flush) {
-		spin_lock_irqsave(&ha->list_lock, flags);
-		retry_q_cnt = ha->retry_q_cnt;
-		list_for_each_safe(list, temp, &ha->retry_queue) {
-			sp = list_entry(list, srb_t, list);
-			/* when time expire return request back to OS as BUSY */
-			__del_from_retry_queue(ha, sp);
-			sp->cmd->result = DID_BUS_BUSY << 16;
-			sp->cmd->host_scribble = (unsigned char *)NULL;
-			__add_to_done_queue(ha, sp);
-		}
-		spin_unlock_irqrestore(&ha->list_lock, flags);
-
-		DEBUG2(printk("%s(%ld): callback %d commands.\n",
-				__func__,
-				ha->host_no,
-				retry_q_cnt);)
-	}
-
-	DEBUG2(printk("%s(%ld): active=%ld, retry=%d, pending=%d, "
-			"done=%ld, scsi retry=%d commands.\n",
-			__func__,
-			ha->host_no,
-			ha->actthreads,
-			ha->retry_q_cnt,
-			pending_q_cnt,
-			ha->done_q_cnt,
-			ha->scsi_retry_q_cnt);)
-
-	if (!list_empty(&ha->done_queue))
-		qla2x00_done(ha);
-}
-
 void
 qla2x00_rescan_fcports(scsi_qla_host_t *ha)
 {
@@ -3699,24 +3617,10 @@
 					ha->actthreads--;
 				sp->lun_queue->out_cnt--;
 
-				/*
-				 * Set the cmd host_byte status depending on
-				 * whether the scsi_error_handler is
-				 * active or not.
- 				 */
-				if (sp->flags & SRB_TAPE) {
-					sp->cmd->result = DID_NO_CONNECT << 16;
-				} else {
-					if (ha->host->eh_active != EH_ACTIVE)
-						sp->cmd->result =
-						    DID_BUS_BUSY << 16;
-					else
-						sp->cmd->result =
-						    DID_RESET << 16;
-				}
 				sp->flags = 0;
+				sp->cmd->result = DID_RESET << 16;
 				sp->cmd->host_scribble = (unsigned char *)NULL;
-				add_to_done_queue(ha, sp);
+				qla2x00_sp_compl(ha, sp);
 			}
 		}
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -3739,11 +3643,6 @@
 			/* Enable ISP interrupts. */
 			qla2x00_enable_intrs(ha);
 
-			/* v2.19.5b6 Return all commands */
-			qla2x00_abort_queues(ha, 1);
-
-			/* Restart queues that may have been stopped. */
-			qla2x00_restart_queues(ha, 1);
 			ha->isp_abort_cnt = 0; 
 			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 		} else {	/* failed the ISP abort */
@@ -3758,7 +3657,6 @@
 					 * completely.
 					 */
 					qla2x00_reset_adapter(ha);
-					qla2x00_abort_queues(ha, 0);
 					ha->flags.online = 0;
 					clear_bit(ISP_ABORT_RETRY,
 					    &ha->dpc_flags);
diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	2005-02-04 08:36:55 -08:00
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	2005-02-04 08:36:55 -08:00
@@ -334,7 +334,6 @@
 	uint32_t        index;
 	uint32_t	handle;
 	cmd_entry_t	*cmd_pkt;
-	uint32_t        timeout;
 	struct scatterlist *sg;
 	uint16_t	cnt;
 	uint16_t	req_cnt;
@@ -432,18 +431,6 @@
 			break;
 		}
 	}
-
-	/*
-	 * Allocate at least 5 (+ QLA_CMD_TIMER_DELTA) seconds for RISC timeout.
-	 */
-	timeout = (uint32_t)(cmd->timeout_per_command / HZ);
-	if (timeout > 65535)
-		cmd_pkt->timeout = __constant_cpu_to_le16(0);
-	else if (timeout > 25)
-		cmd_pkt->timeout = cpu_to_le16((uint16_t)timeout -
-		    (5 + QLA_CMD_TIMER_DELTA));
-	else
-		cmd_pkt->timeout = cpu_to_le16((uint16_t)timeout);
 
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->scsi_cdb, cmd->cmnd, cmd->cmd_len);
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	2005-02-04 08:36:55 -08:00
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2005-02-04 08:36:55 -08:00
@@ -27,8 +27,6 @@
 static void qla2x00_error_entry(scsi_qla_host_t *, sts_entry_t *);
 static void qla2x00_ms_entry(scsi_qla_host_t *, ms_iocb_entry_t *);
 
-static int qla2x00_check_sense(struct scsi_cmnd *cp, os_lun_t *);
-
 /**
  * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
  * @irq:
@@ -93,7 +91,6 @@
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	qla2x00_next(ha);
 	ha->last_irq_cpu = smp_processor_id();
 	ha->total_isr_cnt++;
 
@@ -107,9 +104,6 @@
 		spin_unlock_irqrestore(&ha->mbx_reg_lock, flags);
 	}
 
-	if (!list_empty(&ha->done_queue))
-		qla2x00_done(ha);
-
 	return (IRQ_HANDLED);
 }
 
@@ -206,7 +200,6 @@
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	qla2x00_next(ha);
 	ha->last_irq_cpu = smp_processor_id();
 	ha->total_isr_cnt++;
 
@@ -220,9 +213,6 @@
 		spin_unlock_irqrestore(&ha->mbx_reg_lock, flags);
 	}
 
-	if (!list_empty(&ha->done_queue))
-		qla2x00_done(ha);
-
 	return (IRQ_HANDLED);
 }
 
@@ -714,7 +704,7 @@
 		/* Save ISP completion status */
 		sp->cmd->result = DID_OK << 16;
 		sp->fo_retry_cnt = 0;
-		add_to_done_queue(ha, sp);
+		qla2x00_sp_compl(ha, sp);
 	} else {
 		DEBUG2(printk("scsi(%ld): Invalid ISP SCSI completion handle\n",
 		    ha->host_no));
@@ -914,24 +904,6 @@
 	tq = sp->tgt_queue;
 	lq = sp->lun_queue;
 
-	/*
-	 * If loop is in transient state Report DID_BUS_BUSY
-	 */
-	if ((comp_status != CS_COMPLETE || scsi_status != 0)) {
-		if (!(sp->flags & (SRB_IOCTL | SRB_TAPE)) &&
-		    (atomic_read(&ha->loop_down_timer) ||
-			atomic_read(&ha->loop_state) != LOOP_READY)) {
-
-			DEBUG2(printk("scsi(%ld:%d:%d:%d): Loop Not Ready - "
-			    "pid=%lx.\n",
-			    ha->host_no, b, t, l, cp->serial_number));
-
-			qla2x00_extend_timeout(cp, EXTEND_CMD_TIMEOUT);
-			add_to_retry_queue(ha, sp);
-			return;
-		}
-	}
-
 	/* Check for any FCP transport errors. */
 	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
 		rsp_info_len = le16_to_cpu(pkt->rsp_info_len);
@@ -945,7 +917,7 @@
 			    pkt->rsp_info[6], pkt->rsp_info[7]));
 
 			cp->result = DID_BUS_BUSY << 16;
-			add_to_done_queue(ha, sp);
+			qla2x00_sp_compl(ha, sp);
 			return;
 		}
 	}
@@ -964,11 +936,6 @@
 			cp->resid = resid;
 			CMD_RESID_LEN(cp) = resid;
 		}
-		if (lscsi_status == SS_BUSY_CONDITION) {
-			cp->result = DID_BUS_BUSY << 16 | lscsi_status;
-			break;
-		}
-
 		cp->result = DID_OK << 16 | lscsi_status;
 
 		if (lscsi_status != SS_CHECK_CONDITION)
@@ -1002,14 +969,6 @@
 		if (sp->request_sense_length != 0)
 			ha->status_srb = sp;
 
-		if (!(sp->flags & (SRB_IOCTL | SRB_TAPE)) &&
-		    qla2x00_check_sense(cp, lq) == QLA_SUCCESS) {
-			/* Throw away status_cont if any */
-			ha->status_srb = NULL;
-			add_to_scsi_retry_queue(ha, sp);
-			return;
-		}
-
 		DEBUG5(printk("%s(): Check condition Sense data, "
 		    "scsi(%ld:%d:%d:%d) cmd=%p pid=%ld\n",
 		    __func__, ha->host_no, b, t, l, cp,
@@ -1035,12 +994,6 @@
 		 * Status.
 		 */
 		if (lscsi_status != 0) {
-			if (lscsi_status == SS_BUSY_CONDITION) {
-				cp->result = DID_BUS_BUSY << 16 |
-				    lscsi_status;
-				break;
-			}
-
 			cp->result = DID_OK << 16 | lscsi_status;
 
 			if (lscsi_status != SS_CHECK_CONDITION)
@@ -1072,12 +1025,6 @@
 			if (sp->request_sense_length != 0)
 				ha->status_srb = sp;
 
-			if (!(sp->flags & (SRB_IOCTL | SRB_TAPE)) &&
-			    (qla2x00_check_sense(cp, lq) == QLA_SUCCESS)) {
-				ha->status_srb = NULL;
-				add_to_scsi_retry_queue(ha, sp);
-				return;
-			}
 			DEBUG5(printk("%s(): Check condition Sense data, "
 			    "scsi(%ld:%d:%d:%d) cmd=%p pid=%ld\n",
 			    __func__, ha->host_no, b, t, l, cp,
@@ -1155,24 +1102,10 @@
 		    ha->host_no, t, l, cp->serial_number, comp_status,
 		    atomic_read(&fcport->state)));
 
-		if ((sp->flags & (SRB_IOCTL | SRB_TAPE)) ||
-		    atomic_read(&fcport->state) == FCS_DEVICE_DEAD) {
-			cp->result = DID_NO_CONNECT << 16;
-			if (atomic_read(&ha->loop_state) == LOOP_DOWN) 
-				sp->err_id = SRB_ERR_LOOP;
-			else
-				sp->err_id = SRB_ERR_PORT;
-			add_to_done_queue(ha, sp);
-		} else {
-			qla2x00_extend_timeout(cp, EXTEND_CMD_TIMEOUT);
-			add_to_retry_queue(ha, sp);
-		}
-
+		cp->result = DID_BUS_BUSY << 16;
 		if (atomic_read(&fcport->state) == FCS_ONLINE) {
 			qla2x00_mark_device_lost(ha, fcport, 1);
 		}
-
-		return;
 		break;
 
 	case CS_RESET:
@@ -1180,13 +1113,7 @@
 		    "scsi(%ld): RESET status detected 0x%x-0x%x.\n",
 		    ha->host_no, comp_status, scsi_status));
 
-		if (sp->flags & (SRB_IOCTL | SRB_TAPE)) {
-			cp->result = DID_RESET << 16;
-		} else {
-			qla2x00_extend_timeout(cp, EXTEND_CMD_TIMEOUT);
-			add_to_retry_queue(ha, sp);
-			return;
-		}
+		cp->result = DID_RESET << 16;
 		break;
 
 	case CS_ABORTED:
@@ -1253,7 +1180,7 @@
 
 	/* Place command on done queue. */
 	if (ha->status_srb == NULL)
-		add_to_done_queue(ha, sp);
+		qla2x00_sp_compl(ha, sp);
 }
 
 /**
@@ -1298,8 +1225,8 @@
 
 		/* Place command on done queue. */
 		if (sp->request_sense_length == 0) {
-			add_to_done_queue(ha, sp);
 			ha->status_srb = NULL;
+			qla2x00_sp_compl(ha, sp);
 		}
 	}
 }
@@ -1353,8 +1280,7 @@
 		} else {
 			sp->cmd->result = DID_ERROR << 16;
 		}
-		/* Place command on done queue. */
-		add_to_done_queue(ha, sp);
+		qla2x00_sp_compl(ha, sp);
 
 	} else if (pkt->entry_type == COMMAND_A64_TYPE ||
 	    pkt->entry_type == COMMAND_TYPE) {
@@ -1403,62 +1329,5 @@
 	/* Free outstanding command slot. */
 	ha->outstanding_cmds[pkt->handle1] = NULL;
 
-	add_to_done_queue(ha, sp);
-}
-
-/**
- * qla2x00_check_sense() - Perform any sense data interrogation.
- * @cp: SCSI Command
- * @lq: Lun queue
- *
- * Returns QLA_SUCCESS if the lun queue is suspended, else
- * QLA_FUNCTION_FAILED  (lun queue not suspended).
- */
-static int 
-qla2x00_check_sense(struct scsi_cmnd *cp, os_lun_t *lq)
-{
-	scsi_qla_host_t	*ha;
-	srb_t		*sp;
-	fc_port_t	*fcport;
-
-	ha = (scsi_qla_host_t *) cp->device->host->hostdata;
-	if ((cp->sense_buffer[0] & 0x70) != 0x70) {
-		return (QLA_FUNCTION_FAILED);
-	}
-
-	sp = (srb_t * )CMD_SP(cp);
-	sp->flags |= SRB_GOT_SENSE;
-
-	switch (cp->sense_buffer[2] & 0xf) {
-	case RECOVERED_ERROR:
-		cp->result = DID_OK << 16;
-		cp->sense_buffer[0] = 0;
-		break;
-
-	case NOT_READY:
-		fcport = lq->fclun->fcport;
-
-		/*
-		 * Suspend the lun only for hard disk device type.
-		 */
-		if ((fcport->flags & FCF_TAPE_PRESENT) == 0 &&
-		    lq->q_state != LUN_STATE_TIMEOUT) {
-			/*
-			 * If target is in process of being ready then suspend
-			 * lun for 6 secs and retry all the commands.
-			 */
-			if (cp->sense_buffer[12] == 0x4 &&
-			    cp->sense_buffer[13] == 0x1) {
-
-				/* Suspend the lun for 6 secs */
-				qla2x00_suspend_lun(ha, lq, 6,
-				    ql2xsuspendcount);
-
-				return (QLA_SUCCESS);
-			}
-		}
-		break;
-	}
-
-	return (QLA_FUNCTION_FAILED);
+	qla2x00_sp_compl(ha, sp);
 }
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2005-02-04 08:36:55 -08:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2005-02-04 08:36:55 -08:00
@@ -151,6 +151,8 @@
  * SCSI host template entry points 
  */
 static int qla2xxx_slave_configure(struct scsi_device * device);
+static int qla2xxx_slave_alloc(struct scsi_device *);
+static void qla2xxx_slave_destroy(struct scsi_device *);
 static int qla2x00_queuecommand(struct scsi_cmnd *cmd,
 		void (*fn)(struct scsi_cmnd *));
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
@@ -177,6 +179,8 @@
 
 	.slave_configure	= qla2xxx_slave_configure,
 
+	.slave_alloc		= qla2xxx_slave_alloc,
+	.slave_destroy		= qla2xxx_slave_destroy,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
@@ -230,168 +234,6 @@
 	ha->timer_active = 0;
 }
 
-void qla2x00_cmd_timeout(srb_t *);
-
-static __inline__ void qla2x00_callback(scsi_qla_host_t *, struct scsi_cmnd *);
-static __inline__ void sp_put(struct scsi_qla_host * ha, srb_t *sp);
-static __inline__ void sp_get(struct scsi_qla_host * ha, srb_t *sp);
-static __inline__ void
-qla2x00_delete_from_done_queue(scsi_qla_host_t *, srb_t *); 
-
-/*
-* qla2x00_callback
-*      Returns the completed SCSI command to LINUX.
-*
-* Input:
-*	ha -- Host adapter structure
-*	cmd -- SCSI mid-level command structure.
-* Returns:
-*      None
-* Note:From failover point of view we always get the sp
-*      from vis_ha pool in queuecommand.So when we put it 
-*      back to the pool it has to be the vis_ha.	 
-*      So rely on struct scsi_cmnd to get the vis_ha and not on sp. 		 	
-*/
-static inline void
-qla2x00_callback(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
-{
-	srb_t *sp = (srb_t *) CMD_SP(cmd);
-	scsi_qla_host_t *vis_ha;
-	os_lun_t *lq;
-	int got_sense;
-	unsigned long	cpu_flags = 0;
-
-	cmd->host_scribble = (unsigned char *) NULL;
-	vis_ha = (scsi_qla_host_t *) cmd->device->host->hostdata;
-
-	if (sp == NULL) {
-		qla_printk(KERN_INFO, ha,
-			"%s(): **** CMD derives a NULL SP\n",
-			__func__);
-                DEBUG2(BUG();)
-		return;
-	}
-
-	/*
-	 * If command status is not DID_BUS_BUSY then go ahead and freed sp.
-	 */
-	/*
-	 * Cancel command timeout
-	 */
-	qla2x00_delete_timer_from_cmd(sp);
-
-	/*
-	 * Put SP back in the free queue
-	 */
-	sp->cmd   = NULL;
-	CMD_SP(cmd) = NULL;
-	lq = sp->lun_queue;
-	got_sense = (sp->flags & SRB_GOT_SENSE)? 1: 0;
-	add_to_free_queue(vis_ha, sp);
-
-	if (host_byte(cmd->result) == DID_OK) {
-		/* device ok */
-		ha->total_bytes += cmd->bufflen;
-		if (!got_sense) {
-			/* If lun was suspended then clear retry count */
-			spin_lock_irqsave(&lq->q_lock, cpu_flags);
-			if (!test_bit(LUN_EXEC_DELAYED, &lq->q_flag))
-				lq->q_state = LUN_STATE_READY;
-			spin_unlock_irqrestore(&lq->q_lock, cpu_flags);
-		}
-	} else if (host_byte(cmd->result) == DID_ERROR) {
-		/* device error */
-		ha->total_dev_errs++;
-	}
-
-	/* Call the mid-level driver interrupt handler */
-	(*(cmd)->scsi_done)(cmd);
-}
-
-/**************************************************************************
-* sp_put
-*
-* Description:
-*   Decrement reference count and call the callback if we're the last
-*   owner of the specified sp. Will get the host_lock before calling
-*   the callback.
-*
-* Input:
-*   ha - pointer to the scsi_qla_host_t where the callback is to occur.
-*   sp - pointer to srb_t structure to use.
-*
-* Returns:
-*
-**************************************************************************/
-static inline void
-sp_put(struct scsi_qla_host * ha, srb_t *sp)
-{
-        if (atomic_read(&sp->ref_count) == 0) {
-		qla_printk(KERN_INFO, ha,
-			"%s(): **** SP->ref_count not zero\n",
-			__func__);
-                DEBUG2(BUG();)
-
-                return;
-	}
-
-        if (!atomic_dec_and_test(&sp->ref_count)) {
-                return;
-        }
-
-        qla2x00_callback(ha, sp->cmd);
-}
-
-/**************************************************************************
-* sp_get
-*
-* Description:
-*   Increment reference count of the specified sp.
-*
-* Input:
-*   sp - pointer to srb_t structure to use.
-*
-* Returns:
-*
-**************************************************************************/
-static inline void
-sp_get(struct scsi_qla_host * ha, srb_t *sp)
-{
-        atomic_inc(&sp->ref_count);
-
-        if (atomic_read(&sp->ref_count) > 2) {
-		qla_printk(KERN_INFO, ha,
-			"%s(): **** SP->ref_count greater than two\n",
-			__func__);
-                DEBUG2(BUG();)
-
-		return;
-	}
-}
-
-static inline void 
-qla2x00_delete_from_done_queue(scsi_qla_host_t *dest_ha, srb_t *sp) 
-{
-	/* remove command from done list */
-	list_del_init(&sp->list);
-	dest_ha->done_q_cnt--;
-	sp->state = SRB_NO_QUEUE_STATE;
-
-	if (sp->flags & SRB_DMA_VALID) {
-		sp->flags &= ~SRB_DMA_VALID;
-
-		/* Release memory used for this I/O */
-		if (sp->cmd->use_sg) {
-			pci_unmap_sg(dest_ha->pdev, sp->cmd->request_buffer,
-			    sp->cmd->use_sg, sp->cmd->sc_data_direction);
-		} else if (sp->cmd->request_bufflen) {
-			pci_unmap_page(dest_ha->pdev, sp->dma_handle,
-			    sp->cmd->request_bufflen,
-			    sp->cmd->sc_data_direction);
-		}
-	}
-}
-
 static int qla2x00_do_dpc(void *data);
 
 static void qla2x00_rst_aen(scsi_qla_host_t *);
@@ -400,7 +242,9 @@
 static void qla2x00_mem_free(scsi_qla_host_t *ha);
 static int qla2x00_allocate_sp_pool( scsi_qla_host_t *ha);
 static void qla2x00_free_sp_pool(scsi_qla_host_t *ha);
-static srb_t *qla2x00_get_new_sp(scsi_qla_host_t *ha);
+static srb_t *qla2x00_get_new_sp(scsi_qla_host_t *);
+static void qla2x00_sp_free_dma(scsi_qla_host_t *, srb_t *);
+void qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *);
 
 static ssize_t qla2x00_sysfs_read_fw_dump(struct kobject *, char *, loff_t,
     size_t);
@@ -661,210 +505,84 @@
 * handling).
 **************************************************************************/
 static int
-qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
+qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
-	fc_port_t	*fcport;
-	os_lun_t	*lq;
-	os_tgt_t	*tq;
-	scsi_qla_host_t	*ha, *ha2;
-	srb_t		*sp;
-	struct Scsi_Host *host;
-	unsigned int	b, t, l;
-	unsigned long	handle;
-	int		was_empty;
-
+	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
+	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
+	fc_port_t *fcport = tq->fcport;
+	os_lun_t *lq;
+	srb_t *sp;
+	int rval;
 
-	host = cmd->device->host;
-	ha = (scsi_qla_host_t *) host->hostdata;
-	was_empty = 1;
+	lq = GET_LU_Q(ha, cmd->device->id, cmd->device->lun);
+	if (!fcport || !lq) {
+		cmd->result = DID_NO_CONNECT << 16;
+		goto qc_fail_command;
+	}
 
-	cmd->scsi_done = fn;
+	if (atomic_read(&fcport->state) != FCS_ONLINE) {
+		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
+		    atomic_read(&ha->loop_state) == LOOP_DEAD) {
+			cmd->result = DID_NO_CONNECT << 16;
+			goto qc_fail_command;
+		}
+		goto qc_host_busy;
+	}
 
 	spin_unlock_irq(ha->host->host_lock);
 
-	/*
-	 * Allocate a command packet from the "sp" pool.  If we cant get back
-	 * one then let scsi layer come back later.
-	 */
+	/* Allocate a command packet from the "sp" pool. */
 	if ((sp = qla2x00_get_new_sp(ha)) == NULL) {
-		qla_printk(KERN_WARNING, ha,
-		    "Couldn't allocate memory for sp - retried.\n");
-
-		spin_lock_irq(ha->host->host_lock);
-
-		return (1);
+		goto qc_host_busy_lock;
 	}
 
+	sp->ha = ha;
 	sp->cmd = cmd;
-	CMD_SP(cmd) = (void *)sp;
-
-	sp->flags = 0;
-	if (CMD_RESID_LEN(cmd) & SRB_IOCTL) {
-		/* Need to set sp->flags */
-		sp->flags |= SRB_IOCTL;
-		CMD_RESID_LEN(cmd) = 0; /* Clear it since no more use. */
-	}
-
-	sp->fo_retry_cnt = 0;
-	sp->err_id = 0;
-
-	/* Generate LU queue on bus, target, LUN */
-	b = cmd->device->channel;
-	t = cmd->device->id;
-	l = cmd->device->lun;
-
-	/*
-	 * Start Command Timer. Typically it will be 2 seconds less than what
-	 * is requested by the Host such that we can return the IO before
-	 * aborts are called.
-	 */
-	if ((cmd->timeout_per_command / HZ) > QLA_CMD_TIMER_DELTA)
-		qla2x00_add_timer_to_cmd(sp,
-		    (cmd->timeout_per_command / HZ) - QLA_CMD_TIMER_DELTA);
-	else
-		qla2x00_add_timer_to_cmd(sp, cmd->timeout_per_command / HZ);
-
-	if (l >= ha->max_luns) {
-		cmd->result = DID_NO_CONNECT << 16;
-		sp->err_id = SRB_ERR_PORT;
-
-		spin_lock_irq(ha->host->host_lock);
-
-		sp_put(ha, sp);
-
-		return (0);
-	}
-
-	if ((tq = (os_tgt_t *) TGT_Q(ha, t)) != NULL &&
-	    (lq = (os_lun_t *) LUN_Q(ha, t, l)) != NULL) {
-		fcport = lq->fclun->fcport;
-		ha2 = fcport->ha;
-	} else {
-		lq = NULL;
-		fcport = NULL;
-		ha2 = ha;
-	}
-
-	/* Set an invalid handle until we issue the command to ISP */
-	/* then we will set the real handle value.                 */
-	handle = INVALID_HANDLE;
-	cmd->host_scribble = (unsigned char *)handle;
-
-	/* Bookkeeping information */
-	sp->r_start = jiffies;		/* Time the request was recieved. */
-	sp->u_start = 0;
-
-	/* Setup device queue pointers. */
 	sp->tgt_queue = tq;
-	sp->lun_queue = lq;
-
-	/*
-	 * NOTE : q is NULL
-	 *
-	 * 1. When device is added from persistent binding but has not been
-	 *    discovered yet.The state of loopid == PORT_AVAIL.
-	 * 2. When device is never found on the bus.(loopid == UNUSED)
-	 *
-	 * IF Device Queue is not created, or device is not in a valid state
-	 * and link down error reporting is enabled, reject IO.
-	 */
-	if (fcport == NULL) {
-		DEBUG3(printk("scsi(%ld:%2d:%2d): port unavailable\n",
-		    ha->host_no,t,l));
-
-		cmd->result = DID_NO_CONNECT << 16;
-		sp->err_id = SRB_ERR_PORT;
-
-		spin_lock_irq(ha->host->host_lock);
-
-		sp_put(ha, sp);
-
-		return (0);
-	}
-
-	/* Only modify the allowed count if the target is a *non* tape device */
-	if ((fcport->flags & FCF_TAPE_PRESENT) == 0) {
-		sp->flags &= ~SRB_TAPE;
-		if (cmd->allowed < ql2xretrycount) {
-			cmd->allowed = ql2xretrycount;
-		}
-	} else
-		sp->flags |= SRB_TAPE;
-
-	DEBUG5(printk("scsi(%ld:%2d:%2d): (queuecmd) queue sp = %p, "
-	    "flags=0x%x fo retry=%d, pid=%ld\n",
-	    ha->host_no, t, l, sp, sp->flags, sp->fo_retry_cnt,
-	    cmd->serial_number));
-	DEBUG5(qla2x00_print_scsi_cmd(cmd));
 
+	sp->lun_queue = lq;
+	lq->io_cnt++;
 	sp->fclun = lq->fclun;
-	sp->ha = ha2;
 
-	if (cmd->sc_data_direction == DMA_BIDIRECTIONAL &&
-	    cmd->request_bufflen != 0) {
+	sp->flags = 0;
+	sp->err_id = 0;
+
+	CMD_SP(cmd) = (void *)sp;
+	cmd->scsi_done = done;
 
-		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld): Incorrect data direction - transfer "
-		    "length=%d, direction=%d, pid=%ld, opcode=%x\n",
-		    ha->host_no, cmd->request_bufflen, cmd->sc_data_direction,
-		    cmd->serial_number, cmd->cmnd[0]));
+	rval = qla2x00_start_scsi(sp);
+	if (rval != QLA_SUCCESS)
+		goto qc_host_busy_free_sp;
+
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (ha->flags.online && ha->flags.process_response_queue &&
+	    ha->response_ring_ptr->signature != RESPONSE_PROCESSED) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		qla2x00_process_response_queue(ha);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
 
-	/* Final pre-check :
-	 *
-	 *	Either PORT_DOWN_TIMER OR LINK_DOWN_TIMER Expired.
-	 */
-	if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-	    atomic_read(&ha2->loop_state) == LOOP_DEAD) {
-		/*
-		 * Add the command to the done-queue for later failover
-		 * processing.
-		 */
-		cmd->result = DID_NO_CONNECT << 16;
-		if (atomic_read(&ha2->loop_state) == LOOP_DOWN) 
-			sp->err_id = SRB_ERR_LOOP;
-		else
-			sp->err_id = SRB_ERR_PORT;
+	spin_lock_irq(ha->host->host_lock);
 
-		add_to_done_queue(ha, sp);
-		qla2x00_done(ha);
+	return 0;
 
-		spin_lock_irq(ha->host->host_lock);
-		return (0);
-	}
+qc_host_busy_free_sp:
+	qla2x00_sp_free_dma(ha, sp);
+	CMD_SP(cmd) = NULL;
+	mempool_free(sp, ha->srb_mempool);
 
-	if (tq && test_bit(TQF_SUSPENDED, &tq->flags) &&
-	    (sp->flags & SRB_TAPE) == 0) {
-		/* If target suspended put incoming I/O in retry_q. */
-		qla2x00_extend_timeout(sp->cmd, 10);
-		add_to_scsi_retry_queue(ha, sp);
-	} else
-		was_empty = add_to_pending_queue(ha, sp);
-
-	if ((IS_QLA2100(ha) || IS_QLA2200(ha)) && ha->flags.online) {
-		if (ha->response_ring_ptr->signature != RESPONSE_PROCESSED) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&ha->hardware_lock, flags);	
-			qla2x00_process_response_queue(ha);
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		}
-	}
+qc_host_busy_lock:
+	spin_lock_irq(ha->host->host_lock);
 
-	/* We submit to the hardware if:
-	 *
-	 *	1) we're on the cpu the irq's arrive on or
-	 *	2) there are very few io's outstanding.
-	 *
-	 * In all other cases we'll let an irq pick up our IO and submit it
-	 * to the controller to improve affinity.
-	 */
-	if (smp_processor_id() == ha->last_irq_cpu || was_empty)
-		qla2x00_next(ha);
+qc_host_busy:
+	return SCSI_MLQUEUE_HOST_BUSY;
 
-	spin_lock_irq(ha->host->host_lock);
+qc_fail_command:
+	done(cmd);
 
-	return (0);
+	return 0;
 }
 
 /*
@@ -886,54 +604,21 @@
 qla2x00_eh_wait_on_command(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
 {
 #define ABORT_POLLING_PERIOD	HZ
-#define ABORT_WAIT_TIME		((10 * HZ) / (ABORT_POLLING_PERIOD))
-
-	int		found = 0;
-	int		done = 0;
-	srb_t		*rp = NULL;
-	struct list_head *list, *temp;
-	u_long		max_wait_time = ABORT_WAIT_TIME;
-
-	do {
-		/* Check on done queue */
-		spin_lock(&ha->list_lock);
-		list_for_each_safe(list, temp, &ha->done_queue) {
-			rp = list_entry(list, srb_t, list);
-
-			/*
-			 * Found command. Just exit and wait for the cmd sent
-			 * to OS.
-			*/
-			if (cmd == rp->cmd) {
-				found++;
-				DEBUG3(printk("%s: found in done queue.\n",
-				    __func__);)
-				break;
-			}
-		}
-		spin_unlock(&ha->list_lock);
-
-		/* Complete the cmd right away. */
-		if (found) { 
-			qla2x00_delete_from_done_queue(ha, rp);
-			sp_put(ha, rp);
-			done++;
-			break;
-		}
-
-		spin_unlock_irq(ha->host->host_lock);
+#define ABORT_WAIT_ITER		((10 * HZ) / (ABORT_POLLING_PERIOD))
+	unsigned long wait_iter = ABORT_WAIT_ITER;
+	int ret = QLA_SUCCESS;
 
+	while (CMD_SP(cmd)) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(ABORT_POLLING_PERIOD);
 
-		spin_lock_irq(ha->host->host_lock);
-
-	} while ((max_wait_time--));
-
-	if (done)
-		DEBUG2(printk(KERN_INFO "%s: found cmd=%p.\n", __func__, cmd));
+		if (--wait_iter)
+			break;
+	}
+	if (CMD_SP(cmd))
+		ret = QLA_FUNCTION_FAILED;
 
-	return (done);
+	return ret;
 }
 
 /*
@@ -965,7 +650,8 @@
 	    test_bit(ISP_ABORT_RETRY, &ha->dpc_flags) ||
 	    ha->dpc_active) && time_before(jiffies, wait_online)) {
 
-		msleep(1000);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ);
 	}
 	if (ha->flags.online) 
 		return_status = QLA_SUCCESS; 
@@ -1006,7 +692,8 @@
 	    atomic_read(&ha->loop_state) == LOOP_DOWN) ||
 	    test_bit(CFG_ACTIVE, &ha->cfg_flags) ||
 	    atomic_read(&ha->loop_state) != LOOP_READY) {
-		msleep(1000);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ);
 		if (time_after_eq(jiffies, loop_timeout)) {
 			return_status = QLA_FUNCTION_FAILED;
 			break;
@@ -1032,245 +719,69 @@
 int
 qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
-	int		i;
-	int		return_status = FAILED;
-	os_lun_t	*q;
-	scsi_qla_host_t *ha;
-	scsi_qla_host_t *vis_ha;
-	srb_t		*sp;
-	srb_t		*rp;
-	struct list_head *list, *temp;
-	struct Scsi_Host *host;
-	uint8_t		found = 0;
-	unsigned int	b, t, l;
-
-	/* Get the SCSI request ptr */
-	sp = (srb_t *) CMD_SP(cmd);
-
-	/*
-	 * If sp is NULL, command is already returned.
-	 * sp is NULLED just before we call back scsi_done
-	 *
-	 */
-	if ((sp == NULL)) {
-		/* no action - we don't have command */
-		qla_printk(KERN_INFO, to_qla_host(cmd->device->host),
-		    "qla2xxx_eh_abort: cmd already done sp=%p\n", sp);
-		DEBUG(printk("qla2xxx_eh_abort: cmd already done sp=%p\n", sp);)
-		return SUCCESS;
-	}
-	if (sp) {
-		DEBUG(printk("qla2xxx_eh_abort: refcount %i \n",
-		    atomic_read(&sp->ref_count));)
-	}
-
-	vis_ha = (scsi_qla_host_t *) cmd->device->host->hostdata;
-	ha = (scsi_qla_host_t *)cmd->device->host->hostdata;
-
-	host = ha->host;
-
-	/* Generate LU queue on bus, target, LUN */
-	b = cmd->device->channel;
-	t = cmd->device->id;
-	l = cmd->device->lun;
-	q = GET_LU_Q(vis_ha, t, l);
-
-	qla_printk(KERN_INFO, ha, 
-	    "%s scsi(%ld:%d:%d:%d): cmd_timeout_in_sec=0x%x.\n", __func__,
-	    ha->host_no, (int)b, (int)t, (int)l,
-	    cmd->timeout_per_command / HZ);
-
-	/*
-	 * if no LUN queue then something is very wrong!!!
-	 */
-	if (q == NULL) {
-		qla_printk(KERN_WARNING, ha,
-			"qla2x00: (%x:%x:%x) No LUN queue.\n", b, t, l);
+	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
+	srb_t *sp;
+	int ret, i;
+	unsigned int id, lun;
+	unsigned long serial;
 
-		/* no action - we don't have command */
+	if (!CMD_SP(cmd))
 		return FAILED;
-	}
 
-	DEBUG2(printk("scsi(%ld): ABORTing cmd=%p sp=%p jiffies = 0x%lx, "
-	    "timeout=%x, dpc_flags=%lx, vis_ha->dpc_flags=%lx q->flag=%lx\n",
-	    ha->host_no, cmd, sp, jiffies, cmd->timeout_per_command / HZ,
-	    ha->dpc_flags, vis_ha->dpc_flags, q->q_flag));
-	DEBUG2(qla2x00_print_scsi_cmd(cmd));
+	ret = FAILED;
 
-	spin_unlock_irq(ha->host->host_lock);
-	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
-		DEBUG2(printk("%s failed:board disabled\n", __func__);)
-		spin_lock_irq(ha->host->host_lock);
-		return FAILED;
-	}
-	spin_lock_irq(ha->host->host_lock);
+	id = cmd->device->id;
+	lun = cmd->device->lun;
+	serial = cmd->serial_number;
 
-	/* Search done queue */
-	spin_lock(&ha->list_lock);
-	list_for_each_safe(list, temp, &ha->done_queue) {
-		rp = list_entry(list, srb_t, list);
+	/* Check active list for command command. */
+	spin_unlock_irq(ha->host->host_lock);
+	spin_lock(&ha->hardware_lock);
+	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
+		sp = ha->outstanding_cmds[i];
 
-		if (cmd != rp->cmd)
+		if (sp == NULL)
 			continue;
 
-		/*
-		 * Found command.Remove it from done list.
-		 * And proceed to post completion to scsi mid layer.
-		 */
-		return_status = SUCCESS;
-		found++;
-		qla2x00_delete_from_done_queue(ha, sp);
-
-		break;
-	} /* list_for_each_safe() */
-	spin_unlock(&ha->list_lock);
-
-	/*
-	 * Return immediately if the aborted command was already in the done
-	 * queue
-	 */
-	if (found) {
-		qla_printk(KERN_INFO, ha,
-		    "qla2xxx_eh_abort: Returning completed command=%p sp=%p\n",
-		    cmd, sp);
-		sp_put(ha, sp);
-		return (return_status);
-	}
-	
-
-	/*
-	 * See if this command is in the retry queue
-	 */
-	DEBUG3(printk("qla2xxx_eh_abort: searching sp %p in retry "
-		    "queue.\n", sp);)
-
-	spin_lock(&ha->list_lock);
-	list_for_each_safe(list, temp, &ha->retry_queue) {
-		rp = list_entry(list, srb_t, list);
-
-		if (cmd != rp->cmd)
+		if (sp->cmd != cmd)
 			continue;
 
+		DEBUG2(printk("%s(%ld): aborting sp %p from RISC. pid=%ld "
+		    "sp->state=%x\n", __func__, ha->host_no, sp, serial,
+		    sp->state));
+		DEBUG3(qla2x00_print_scsi_cmd(cmd);)
 
-		DEBUG2(printk("qla2xxx_eh_abort: found "
-		    "in retry queue. SP=%p\n", sp);)
-
-		__del_from_retry_queue(ha, rp);
-		cmd->result = DID_ABORT << 16;
-		__add_to_done_queue(ha, rp);
-
-		return_status = SUCCESS;
-		found++;
-
-		break;
-
-	} 
-	spin_unlock(&ha->list_lock);
-
-
-	/*
-	 * Our SP pointer points at the command we want to remove from the
-	 * pending queue providing we haven't already sent it to the adapter.
-	 */
-	if (!found) {
-		DEBUG3(printk("qla2xxx_eh_abort: searching sp %p "
-		    "in pending queue.\n", sp);)
-
-		spin_lock(&vis_ha->list_lock);
-		list_for_each_safe(list, temp, &vis_ha->pending_queue) {
-			rp = list_entry(list, srb_t, list);
-
-			if (rp->cmd != cmd)
-				continue;
-
-			/* Remove srb from LUN queue. */
-			rp->flags |=  SRB_ABORTED;
-
-			DEBUG2(printk("qla2xxx_eh_abort: Cmd in pending queue."
-			    " serial_number %ld.\n",
-			    sp->cmd->serial_number);)
-
-			__del_from_pending_queue(vis_ha, rp);
-			cmd->result = DID_ABORT << 16;
-
-			__add_to_done_queue(vis_ha, rp);
-
-			return_status = SUCCESS;
-
-			found++;
-			break;
-		} /* list_for_each_safe() */
-		spin_unlock(&vis_ha->list_lock);
-	} /*End of if !found */
-
-	if (!found) {  /* find the command in our active list */
-		DEBUG3(printk("qla2xxx_eh_abort: searching sp %p "
-		    "in outstanding queue.\n", sp);)
-
-		spin_lock(&ha->hardware_lock);
-		for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
-			sp = ha->outstanding_cmds[i];
-
-			if (sp == NULL)
-				continue;
-
-			if (sp->cmd != cmd)
-				continue;
-
-			DEBUG2(printk("qla2xxx_eh_abort(%ld): aborting sp %p "
-			    "from RISC. pid=%ld sp->state=%x q->q_flag=%lx\n",
-			    ha->host_no, sp, sp->cmd->serial_number,
-			    sp->state, q->q_flag);)
-			DEBUG(qla2x00_print_scsi_cmd(cmd);)
-
-			/* Get a reference to the sp and drop the lock.*/
-			sp_get(ha, sp);
-
-			spin_unlock(&ha->hardware_lock);
-			spin_unlock_irq(ha->host->host_lock);
-
-			if (qla2x00_abort_command(ha, sp)) {
-				DEBUG2(printk("qla2xxx_eh_abort: abort_command "
-				    "mbx failed.\n");)
-				return_status = FAILED;
-			} else {
-				DEBUG3(printk("qla2xxx_eh_abort: abort_command "
-				    " mbx success.\n");)
-				return_status = SUCCESS;
-			}
-
-			sp_put(ha,sp);
-
-			spin_lock_irq(ha->host->host_lock);
-			spin_lock(&ha->hardware_lock);
-
-			/*
-			 * Regardless of mailbox command status, go check on
-			 * done queue just in case the sp is already done.
-			 */
-			break;
-
-		}/*End of for loop */
 		spin_unlock(&ha->hardware_lock);
+		if (qla2x00_abort_command(ha, sp)) {
+			DEBUG2(printk("%s(%ld): abort_command "
+			    "mbx failed.\n", __func__, ha->host_no));
+		} else {
+			DEBUG3(printk("%s(%ld): abort_command "
+			    "mbx success.\n", __func__, ha->host_no));
+			ret = SUCCESS;
+		}
+		spin_lock(&ha->hardware_lock);
 
-	} /*End of if !found */
-
-	/* Waiting for our command in done_queue to be returned to OS.*/
-	if (qla2x00_eh_wait_on_command(ha, cmd) != 0) {
-		DEBUG2(printk("qla2xxx_eh_abort: cmd returned back to OS.\n");)
-		return_status = SUCCESS;
+		break;
 	}
 
-	if (return_status == FAILED) {
-		qla_printk(KERN_INFO, ha, 
-			"qla2xxx_eh_abort Exiting: status=Failed\n");
-		return FAILED;
+	/* Wait for the command to be returned. */
+	if (ret == SUCCESS) {
+		spin_unlock(&ha->hardware_lock);
+		if (qla2x00_eh_wait_on_command(ha, cmd) != QLA_SUCCESS) {
+			qla_printk(KERN_ERR, ha, 
+			    "scsi(%ld:%d:%d): Abort handler timed out -- %lx "
+			    "%x.\n", ha->host_no, id, lun, serial, ret);
+		}
+		spin_lock(&ha->hardware_lock);
 	}
+	spin_lock_irq(ha->host->host_lock);
 
-	DEBUG2(printk("qla2xxx_eh_abort: Exiting. return_status=0x%x.\n",
-	    return_status));
+	qla_printk(KERN_INFO, ha, 
+	    "scsi(%ld:%d:%d): Abort command issued -- %lx %x.\n", ha->host_no,
+	    id, lun, serial, ret);
 
-	return return_status;
+	return ret;
 }
 
 /**************************************************************************
@@ -1313,8 +824,7 @@
 					break;
 				}
 			}
-		}
-		else {
+		} else {
 			spin_unlock(&ha->hardware_lock);
 		}
 	}
@@ -1344,96 +854,45 @@
 int
 qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
-	int		return_status;
-	unsigned int	b, t, l;
-	scsi_qla_host_t	*ha;
-	os_tgt_t	*tq;
-	os_lun_t	*lq;
-	fc_port_t	*fcport_to_reset;
-	srb_t		*rp;
-	struct list_head *list, *temp;
-
-	return_status = FAILED;
-	if (cmd == NULL) {
-		printk(KERN_INFO
-		    "%s(): **** SCSI mid-layer passing in NULL cmd\n",
-		    __func__);
-
-		return (return_status);
-	}
-
-	b = cmd->device->channel;
-	t = cmd->device->id;
-	l = cmd->device->lun;
-	ha = (scsi_qla_host_t *)cmd->device->host->hostdata;
-
-	tq = TGT_Q(ha, t);
-	if (tq == NULL) {
-		qla_printk(KERN_INFO, ha,
-		    "%s(): **** CMD derives a NULL TGT_Q\n", __func__);
+	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
+	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
+	fc_port_t *fcport = tq->fcport;
+	os_lun_t *lq;
+	srb_t *sp;
+	int ret;
+	unsigned int id, lun;
+	unsigned long serial;
 
-		return (return_status);
-	}
-	lq = (os_lun_t *)LUN_Q(ha, t, l);
-	if (lq == NULL) {
-		printk(KERN_INFO
-		    "%s(): **** CMD derives a NULL LUN_Q\n", __func__);
+	ret = FAILED;
 
-		return (return_status);
-	}
-	fcport_to_reset = lq->fclun->fcport;
+	id = cmd->device->id;
+	lun = cmd->device->lun;
+	serial = cmd->serial_number;
 
-	/* If we are coming in from the back-door, stall I/O until complete. */
-	if (!cmd->device->host->eh_active)
-		set_bit(TQF_SUSPENDED, &tq->flags);
+	sp = (srb_t *) CMD_SP(cmd);
+	lq = GET_LU_Q(ha, id, lun);
+	if (!sp || !fcport || !lq)
+		return ret;
 
 	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d:%d): DEVICE RESET ISSUED.\n", ha->host_no, b, t, l);
-
-	DEBUG2(printk(KERN_INFO
-	    "scsi(%ld): DEVICE_RESET cmd=%p jiffies = 0x%lx, timeout=%x, "
-	    "dpc_flags=%lx, status=%x allowed=%d cmd.state=%x\n",
-	    ha->host_no, cmd, jiffies, cmd->timeout_per_command / HZ,
-	    ha->dpc_flags, cmd->result, cmd->allowed, cmd->state));
-
- 	/* Clear commands from the retry queue. */
- 	spin_lock(&ha->list_lock);
- 	list_for_each_safe(list, temp, &ha->retry_queue) {
- 		rp = list_entry(list, srb_t, list);
- 
- 		if (t != rp->cmd->device->id) 
- 			continue;
- 
- 		DEBUG2(printk(KERN_INFO
-		    "qla2xxx_eh_reset: found in retry queue. SP=%p\n", rp));
- 
- 		__del_from_retry_queue(ha, rp);
- 		rp->cmd->result = DID_RESET << 16;
- 		__add_to_done_queue(ha, rp);
- 	}
- 	spin_unlock(&ha->list_lock);
+	    "scsi(%ld:%d:%d): DEVICE RESET ISSUED.\n", ha->host_no, id, lun);
 
 	spin_unlock_irq(ha->host->host_lock);
 
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
-		DEBUG2(printk(KERN_INFO
-		    "%s failed:board disabled\n",__func__));
-
 		spin_lock_irq(ha->host->host_lock);
 		goto eh_dev_reset_done;
 	}
 
 	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
-		if (qla2x00_device_reset(ha, fcport_to_reset) == 0) {
-			return_status = SUCCESS;
-		}
+		if (qla2x00_device_reset(ha, fcport) == 0)
+			ret = SUCCESS;
 
 #if defined(LOGOUT_AFTER_DEVICE_RESET)
-		if (return_status == SUCCESS) {
-			if (fcport_to_reset->flags & FC_FABRIC_DEVICE) {
-				qla2x00_fabric_logout(ha,
-				    fcport_to_reset->loop_id);
-				qla2x00_mark_device_lost(ha, fcport_to_reset);
+		if (ret == SUCCESS) {
+			if (fcport->flags & FC_FABRIC_DEVICE) {
+				qla2x00_fabric_logout(ha, fcport->loop_id);
+				qla2x00_mark_device_lost(ha, fcport);
 			}
 		}
 #endif
@@ -1442,9 +901,7 @@
 		    "%s failed: loop not ready\n",__func__);)
 	}
 
-	spin_lock_irq(ha->host->host_lock);
-
-	if (return_status == FAILED) {
+	if (ret == FAILED) {
 		DEBUG3(printk("%s(%ld): device reset failed\n",
 		    __func__, ha->host_no));
 		qla_printk(KERN_INFO, ha, "%s: device reset failed\n",
@@ -1458,10 +915,10 @@
 	 * complete for the device.
 	 */
 	if (cmd->device->host->eh_active) {
-		if (qla2x00_eh_wait_for_pending_target_commands(ha, t))
-			return_status = FAILED;
+		if (qla2x00_eh_wait_for_pending_target_commands(ha, id))
+			ret = FAILED;
 
-		if (return_status == FAILED) {
+		if (ret == FAILED) {
 			DEBUG3(printk("%s(%ld): failed while waiting for "
 			    "commands\n", __func__, ha->host_no));
 			qla_printk(KERN_INFO, ha,
@@ -1473,15 +930,12 @@
 	}
 
 	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d:%d): DEVICE RESET SUCCEEDED.\n",
-	    ha->host_no, b, t, l);
+	    "scsi(%ld:%d:%d): DEVICE RESET SUCCEEDED.\n", ha->host_no, id, lun);
 
 eh_dev_reset_done:
+	spin_lock_irq(ha->host->host_lock);
 
-	if (!cmd->device->host->eh_active)
-		clear_bit(TQF_SUSPENDED, &tq->flags);
-
-	return (return_status);
+	return ret;
 }
 
 /**************************************************************************
@@ -1549,44 +1003,55 @@
 int
 qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha;
+	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
+	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
+	fc_port_t *fcport = tq->fcport;
+	os_lun_t *lq;
 	srb_t *sp;
-	int rval = FAILED;
+	int ret;
+	unsigned int id, lun;
+	unsigned long serial;
+
+	ret = FAILED;
+
+	id = cmd->device->id;
+	lun = cmd->device->lun;
+	serial = cmd->serial_number;
 
-	ha = (scsi_qla_host_t *) cmd->device->host->hostdata;
 	sp = (srb_t *) CMD_SP(cmd);
+	lq = GET_LU_Q(ha, id, lun);
+	if (!sp || !fcport || !lq)
+		return ret;
 
 	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d:%d): LOOP RESET ISSUED.\n", ha->host_no,
-	    cmd->device->channel, cmd->device->id, cmd->device->lun);
+	    "scsi(%ld:%d:%d): LOOP RESET ISSUED.\n", ha->host_no, id, lun);
 
 	spin_unlock_irq(ha->host->host_lock);
 
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
 		DEBUG2(printk("%s failed:board disabled\n",__func__));
-		spin_lock_irq(ha->host->host_lock);
-		return FAILED;
+		goto eh_bus_reset_done;
 	}
 
 	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
-		if (qla2x00_loop_reset(ha) == QLA_SUCCESS) 
-			rval = SUCCESS;
+		if (qla2x00_loop_reset(ha) == QLA_SUCCESS)
+			ret = SUCCESS;
 	}
-
-	spin_lock_irq(ha->host->host_lock);
-	if (rval == FAILED)
-		goto out;
+	if (ret == FAILED)
+		goto eh_bus_reset_done;
 
 	/* Waiting for our command in done_queue to be returned to OS.*/
 	if (cmd->device->host->eh_active)
 		if (!qla2x00_eh_wait_for_pending_commands(ha))
-			rval = FAILED;
+			ret = FAILED;
 
- out:
+eh_bus_reset_done:
 	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
-			(rval == FAILED) ? "failed" : "succeded");
+	    (ret == FAILED) ? "failed" : "succeded");
 
-	return rval;
+	spin_lock_irq(ha->host->host_lock);
+
+	return ret;
 }
 
 /**************************************************************************
@@ -1607,24 +1072,33 @@
 int
 qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = (scsi_qla_host_t *)cmd->device->host->hostdata;
-	int		rval = SUCCESS;
+	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
+	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
+	fc_port_t *fcport = tq->fcport;
+	os_lun_t *lq;
+	srb_t *sp;
+	int ret;
+	unsigned int id, lun;
+	unsigned long serial;
 
-	/* Display which one we're actually resetting for debug. */
-	DEBUG(printk("qla2xxx_eh_host_reset:Resetting scsi(%ld).\n",
-	    ha->host_no));
+	ret = FAILED;
+
+	id = cmd->device->id;
+	lun = cmd->device->lun;
+	serial = cmd->serial_number;
+
+	sp = (srb_t *) CMD_SP(cmd);
+	lq = GET_LU_Q(ha, id, lun);
+	if (!sp || !fcport || !lq)
+		return ret;
 
-	/*
-	 *  Now issue reset.
-	 */
 	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d:%d): ADAPTER RESET issued.\n", ha->host_no,
-	    cmd->device->channel, cmd->device->id, cmd->device->lun);
+	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", ha->host_no, id, lun);
 
 	spin_unlock_irq(ha->host->host_lock);
 
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
-		goto board_disabled;
+		goto eh_host_reset_lock;
 
 	/*
 	 * Fixme-may be dpc thread is active and processing
@@ -1634,7 +1108,6 @@
 	 * devices as lost kicking of the port_down_timer
 	 * while dpc is stuck for the mailbox to complete.
 	 */
-	/* Blocking call-Does context switching if loop is Not Ready */
 	qla2x00_wait_for_loop_ready(ha);
 	set_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 	if (qla2x00_abort_isp(ha)) {
@@ -1643,32 +1116,22 @@
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 
 		if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
-			goto board_disabled;
+			goto eh_host_reset_lock;
 	} 
-
 	clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 
-	spin_lock_irq(ha->host->host_lock);
-	if (rval == FAILED)
-		goto out;
-
 	/* Waiting for our command in done_queue to be returned to OS.*/
-	if (!qla2x00_eh_wait_for_pending_commands(ha))
-		rval = FAILED;
+	if (qla2x00_eh_wait_for_pending_commands(ha))
+		ret = SUCCESS;
 
- out:
-	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
-			(rval == FAILED) ? "failed" : "succeded");
-
-	return rval;
-
- board_disabled:
+eh_host_reset_lock:
 	spin_lock_irq(ha->host->host_lock);
 
-	qla_printk(KERN_INFO, ha, "%s: failed:board disabled\n", __func__);
-	return FAILED;
-}
+	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
+	    (ret == FAILED) ? "failed" : "succeded");
 
+	return ret;
+}
 
 /*
 * qla2x00_loop_reset
@@ -1752,41 +1215,39 @@
 	return qla2x00_abort_target(reset_fcport);
 }
 
-/**************************************************************************
-* qla2xxx_slave_configure
-*
-* Description:
-**************************************************************************/
-int
-qla2xxx_slave_configure(struct scsi_device *sdev)
+static int
+qla2xxx_slave_alloc(struct scsi_device *sdev)
 {
 	scsi_qla_host_t *ha = to_qla_host(sdev->host);
-	int queue_depth;
+	os_tgt_t *tq;
 
-	if (IS_QLA2100(ha) || IS_QLA2200(ha))
-		queue_depth = 16;
-	else
-		queue_depth = 32;
+	tq = (os_tgt_t *) TGT_Q(ha, sdev->id);
+	if (!tq)
+		return -ENXIO;
+	if (!tq->fcport)
+		return -ENXIO;
 
-	if (sdev->tagged_supported) {
-		if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
-			queue_depth = ql2xmaxqdepth;
+	sdev->hostdata = tq;
 
-		ql2xmaxqdepth = queue_depth;
+	return 0;
+}
 
-		scsi_activate_tcq(sdev, queue_depth);
+static int
+qla2xxx_slave_configure(struct scsi_device *sdev)
+{
+	if (sdev->tagged_supported)
+		scsi_activate_tcq(sdev, 32);
+	else
+		scsi_deactivate_tcq(sdev, 32);
 
-		qla_printk(KERN_INFO, ha,
-		    "scsi(%d:%d:%d:%d): Enabled tagged queuing, queue "
-		    "depth %d.\n",
-		    sdev->host->host_no, sdev->channel, sdev->id, sdev->lun,
-		    sdev->queue_depth);
-	} else {
-		 scsi_adjust_queue_depth(sdev, 0 /* TCQ off */,
-		     sdev->host->hostt->cmd_per_lun /* 3 */);
-	}
+	return 0;
+}
 
-	return (0);
+static void
+qla2xxx_slave_destroy(struct scsi_device *sdev)
+{
+	sdev->hostdata = NULL;
+	return;
 }
 
 /**
@@ -1993,10 +1454,6 @@
 	INIT_LIST_HEAD(&ha->list);
 	INIT_LIST_HEAD(&ha->fcports);
 	INIT_LIST_HEAD(&ha->rscn_fcports);
-	INIT_LIST_HEAD(&ha->done_queue);
-	INIT_LIST_HEAD(&ha->retry_queue);
-	INIT_LIST_HEAD(&ha->scsi_retry_queue);
-	INIT_LIST_HEAD(&ha->pending_queue);
 
 	/*
 	 * These locks are used to prevent more than one CPU
@@ -2005,7 +1462,6 @@
 	 * contention for these locks.
 	 */
 	spin_lock_init(&ha->mbx_reg_lock);
-	spin_lock_init(&ha->list_lock);
 
 	ha->dpc_pid = -1;
 	init_completion(&ha->dpc_inited);
@@ -2381,13 +1837,6 @@
 	    "Number of retries for empty slots = %ld\n",
 	    qla2x00_stats.outarray_full);
 
-	copy_info(&info,
-	    "Number of reqs in pending_q= %ld, retry_q= %d, "
-	    "done_q= %ld, scsi_retry_q= %d\n",
-	    ha->qthreads, ha->retry_q_cnt,
-	    ha->done_q_cnt, ha->scsi_retry_q_cnt);
-
-
 	flags = (uint32_t *) &ha->flags;
 
 	if (atomic_read(&ha->loop_state) == LOOP_DOWN) {
@@ -2631,93 +2080,6 @@
 	}
 }
 
-/*
- *  qla2x00_suspend_lun
- *	Suspend lun and start port down timer
- *
- * Input:
- *	ha = visable adapter block pointer.
- *  lq = lun queue
- *  cp = Scsi command pointer 
- *  time = time in seconds
- *  count = number of times to let time expire
- *  delay_lun = non-zero, if lun should be delayed rather than suspended
- *
- * Return:
- *     QLA_SUCCESS  -- suspended lun 
- *     QLA_FUNCTION_FAILED  -- Didn't suspend lun
- *
- * Context:
- *	Interrupt context.
- */
-int
-__qla2x00_suspend_lun(scsi_qla_host_t *ha,
-		os_lun_t *lq, int time, int count, int delay_lun)
-{
-	int	rval;
-	srb_t *sp;
-	struct list_head *list, *temp;
-	unsigned long flags;
-
-	rval = QLA_SUCCESS;
-
-	/* if the lun_q is already suspended then don't do it again */
-	if (lq->q_state == LUN_STATE_READY ||lq->q_state == LUN_STATE_RUN) {
-
-		spin_lock_irqsave(&lq->q_lock, flags);
-		if (lq->q_state == LUN_STATE_READY) {
-			lq->q_max = count;
-			lq->q_count = 0;
-		}
-		/* Set the suspend time usually 6 secs */
-		atomic_set(&lq->q_timer, time);
-
-		/* now suspend the lun */
-		lq->q_state = LUN_STATE_WAIT;
-
-		if (delay_lun) {
-			set_bit(LUN_EXEC_DELAYED, &lq->q_flag);
-			DEBUG(printk(KERN_INFO
-			    "scsi(%ld): Delay lun execution for %d secs, "
-			    "count=%d, max count=%d, state=%d\n",
-			    ha->host_no,
-			    time,
-			    lq->q_count, lq->q_max, lq->q_state));
-		} else {
-			DEBUG(printk(KERN_INFO
-			    "scsi(%ld): Suspend lun for %d secs, count=%d, "
-			    "max count=%d, state=%d\n",
-			    ha->host_no,
-			    time,
-			    lq->q_count, lq->q_max, lq->q_state));
-		}
-		spin_unlock_irqrestore(&lq->q_lock, flags);
-
-		/*
-		 * Remove all pending commands from request queue and  put them
-		 * in the scsi_retry queue.
-		 */
-		spin_lock_irqsave(&ha->list_lock, flags);
-		list_for_each_safe(list, temp, &ha->pending_queue) {
-			sp = list_entry(list, srb_t, list);
-			if (sp->lun_queue != lq)
-				continue;
-
-			__del_from_pending_queue(ha, sp);
-
-			if (sp->cmd->allowed < count)
-				sp->cmd->allowed = count;
-			__add_to_scsi_retry_queue(ha, sp);
-
-		} /* list_for_each_safe */
-		spin_unlock_irqrestore(&ha->list_lock, flags);
-		rval = QLA_SUCCESS;
-	} else {
-		rval = QLA_FUNCTION_FAILED;
-	}
-
-	return (rval);
-}
 
 /*
  * qla2x00_mark_device_lost Updates fcport state when device goes offline.
@@ -3188,16 +2550,8 @@
 	DECLARE_MUTEX_LOCKED(sem);
 	scsi_qla_host_t *ha;
 	fc_port_t	*fcport;
-	os_lun_t        *q;
-	srb_t           *sp;
 	uint8_t		status;
-	unsigned long	flags = 0;
-	struct list_head *list, *templist;
-	int	dead_cnt, online_cnt;
-	int	retry_cmds = 0;
 	uint16_t	next_loopid;
-	int t;
-	os_tgt_t *tq;
 
 	ha = (scsi_qla_host_t *)data;
 
@@ -3233,139 +2587,7 @@
 
 		ha->dpc_active = 1;
 
-		if (!list_empty(&ha->done_queue))
-			qla2x00_done(ha);
-
-		/* Process commands in retry queue */
-		if (test_and_clear_bit(PORT_RESTART_NEEDED, &ha->dpc_flags)) {
-			DEBUG(printk("scsi(%ld): DPC checking retry_q. "
-			    "total=%d\n",
-			    ha->host_no, ha->retry_q_cnt));
-
-			spin_lock_irqsave(&ha->list_lock, flags);
-			dead_cnt = online_cnt = 0;
-			list_for_each_safe(list, templist, &ha->retry_queue) {
-				sp = list_entry(list, srb_t, list);
-				q = sp->lun_queue;
-				DEBUG3(printk("scsi(%ld): pid=%ld sp=%p, "
-				    "spflags=0x%x, q_flag= 0x%lx\n",
-				    ha->host_no, sp->cmd->serial_number, sp,
-				    sp->flags, q->q_flag));
-
-				if (q == NULL)
-					continue;
-				fcport = q->fclun->fcport;
-
-				if (atomic_read(&fcport->state) ==
-				    FCS_DEVICE_DEAD ||
-				    atomic_read(&fcport->ha->loop_state) == LOOP_DEAD) {
-
-					__del_from_retry_queue(ha, sp);
-					sp->cmd->result = DID_NO_CONNECT << 16;
-					if (atomic_read(&fcport->ha->loop_state) ==
-					    LOOP_DOWN) 
-						sp->err_id = SRB_ERR_LOOP;
-					else
-						sp->err_id = SRB_ERR_PORT;
-					sp->cmd->host_scribble =
-					    (unsigned char *) NULL;
-					__add_to_done_queue(ha, sp);
-					dead_cnt++;
-				} else if (atomic_read(&fcport->state) !=
-				    FCS_DEVICE_LOST) {
-
-					__del_from_retry_queue(ha, sp);
-					sp->cmd->result = DID_BUS_BUSY << 16;
-					sp->cmd->host_scribble =
-					    (unsigned char *) NULL;
-					__add_to_done_queue(ha, sp);
-					online_cnt++;
-				}
-			} /* list_for_each_safe() */
-			spin_unlock_irqrestore(&ha->list_lock, flags);
-
-			DEBUG(printk("scsi(%ld): done processing retry queue "
-			    "- dead=%d, online=%d\n ",
-			    ha->host_no, dead_cnt, online_cnt));
-		}
-
-		/* Process commands in scsi retry queue */
-		if (test_and_clear_bit(SCSI_RESTART_NEEDED, &ha->dpc_flags)) {
-			/*
-			 * Any requests we want to delay for some period is put
-			 * in the scsi retry queue with a delay added. The
-			 * timer will schedule a "scsi_restart_needed" every 
-			 * second as long as there are requests in the scsi
-			 * queue. 
-			 */
-			DEBUG(printk("scsi(%ld): DPC checking scsi "
-			    "retry_q.total=%d\n",
-			    ha->host_no, ha->scsi_retry_q_cnt));
-
-			online_cnt = 0;
-			spin_lock_irqsave(&ha->list_lock, flags);
-			list_for_each_safe(list, templist,
-			    &ha->scsi_retry_queue) {
-
-				sp = list_entry(list, srb_t, list);
-				q = sp->lun_queue;
-				tq = sp->tgt_queue;
-
-				DEBUG3(printk("scsi(%ld): scsi_retry_q: "
-				    "pid=%ld sp=%p, spflags=0x%x, "
-				    "q_flag= 0x%lx,q_state=%d\n",
-				    ha->host_no, sp->cmd->serial_number,
-				    sp, sp->flags, q->q_flag, q->q_state));
-
-				/* Was this lun suspended */
-				if (q->q_state != LUN_STATE_WAIT) {
-					online_cnt++;
-					__del_from_scsi_retry_queue(ha, sp);
-
-					if (test_bit(TQF_RETRY_CMDS,
-					    &tq->flags)) {
-						qla2x00_extend_timeout(sp->cmd,
-						    (sp->cmd->timeout_per_command / HZ) - QLA_CMD_TIMER_DELTA);
-						__add_to_pending_queue(ha, sp);
-						retry_cmds++;
-					} else
-						__add_to_retry_queue(ha, sp);
-				}
-
-				/* Was this command suspended for N secs */
-				if (sp->delay != 0) {
-					sp->delay--;
-					if (sp->delay == 0) {
-						online_cnt++;
-						__del_from_scsi_retry_queue(
-						    ha, sp);
-						__add_to_retry_queue(ha,sp);
-					}
-				}
-			}
-			spin_unlock_irqrestore(&ha->list_lock, flags);
-
-			/* Clear all Target Unsuspended bits */
-			for (t = 0; t < ha->max_targets; t++) {
-				if ((tq = ha->otgt[t]) == NULL)
-					continue;
-
-				if (test_bit(TQF_RETRY_CMDS, &tq->flags))
-					clear_bit(TQF_RETRY_CMDS, &tq->flags);
-			}
-			if (retry_cmds)
-				qla2x00_next(ha);
-
-			DEBUG(if (online_cnt > 0))
-			DEBUG(printk("scsi(%ld): dpc() found scsi reqs to "
-			    "restart= %d\n",
-			    ha->host_no, online_cnt));
-		}
-
 		if (ha->flags.mbox_busy) {
-			if (!list_empty(&ha->done_queue))
-				qla2x00_done(ha);
-
 			ha->dpc_active = 0;
 			continue;
 		}
@@ -3493,28 +2715,6 @@
 			    ha->host_no));
 		}
 
-
-		if (test_bit(RESTART_QUEUES_NEEDED, &ha->dpc_flags)) {
-			DEBUG(printk("scsi(%ld): qla2x00_restart_queues()\n",
-			    ha->host_no));
-
-			qla2x00_restart_queues(ha, 0);
-
-			DEBUG(printk("scsi(%ld): qla2x00_restart_queues - end\n",
-			    ha->host_no));
-		}
-
-		if (test_bit(ABORT_QUEUES_NEEDED, &ha->dpc_flags)) {
-
-			DEBUG(printk("scsi(%ld): qla2x00_abort_queues()\n",
-			    ha->host_no));
-				
-			qla2x00_abort_queues(ha, 0);
-
-			DEBUG(printk("scsi(%ld): qla2x00_abort_queues - end\n",
-			    ha->host_no));
-		}
-
 		if (test_and_clear_bit(FCPORT_RESCAN_NEEDED, &ha->dpc_flags)) {
 
 			DEBUG(printk("scsi(%ld): Rescan flagged fcports...\n",
@@ -3527,13 +2727,9 @@
 			    ha->host_no));
 		}
 
-
 		if (!ha->interrupts_on)
 			qla2x00_enable_intrs(ha);
 
-		if (!list_empty(&ha->done_queue))
-			qla2x00_done(ha);
-
 		ha->dpc_active = 0;
 	} /* End of while(1) */
 
@@ -3549,45 +2745,6 @@
 }
 
 /*
- *  qla2x00_abort_queues
- *	Abort all commands on queues on device
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Context:
- *	Interrupt context.
- */
-void
-qla2x00_abort_queues(scsi_qla_host_t *ha, uint8_t doneqflg) 
-{
-
-	srb_t       *sp;
-	struct list_head *list, *temp;
-	unsigned long flags;
-
-	clear_bit(ABORT_QUEUES_NEEDED, &ha->dpc_flags);
-
-	/* Return all commands device queues. */
-	spin_lock_irqsave(&ha->list_lock,flags);
-	list_for_each_safe(list, temp, &ha->pending_queue) {
-		sp = list_entry(list, srb_t, list);
-
-		if (sp->flags & SRB_ABORTED)
-			continue;
-
-		/* Remove srb from LUN queue. */
-		__del_from_pending_queue(ha, sp);
-
-		/* Set ending status. */
-		sp->cmd->result = DID_BUS_BUSY << 16;
-
-		__add_to_done_queue(ha, sp);
-	}
-	spin_unlock_irqrestore(&ha->list_lock, flags);
-}
-
-/*
 *  qla2x00_rst_aen
 *      Processes asynchronous reset.
 *
@@ -3632,6 +2789,36 @@
 	return (sp);
 }
 
+static void
+qla2x00_sp_free_dma(scsi_qla_host_t *ha, srb_t *sp)
+{
+	struct scsi_cmnd *cmd = sp->cmd;
+
+	if (sp->flags & SRB_DMA_VALID) {
+		if (cmd->use_sg) {
+			dma_unmap_sg(&ha->pdev->dev, cmd->request_buffer,
+			    cmd->use_sg, cmd->sc_data_direction);
+		} else if (cmd->request_bufflen) {
+			dma_unmap_single(&ha->pdev->dev, sp->dma_handle,
+			    cmd->request_bufflen, cmd->sc_data_direction);
+		}
+		sp->flags &= ~SRB_DMA_VALID;
+	}
+}
+
+void
+qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *sp)
+{
+	struct scsi_cmnd *cmd = sp->cmd;
+
+	qla2x00_sp_free_dma(ha, sp);
+
+	CMD_SP(cmd) = NULL;
+	mempool_free(sp, ha->srb_mempool);
+
+	cmd->scsi_done(cmd);
+}
+
 /**************************************************************************
 *   qla2x00_timer
 *
@@ -3643,30 +2830,12 @@
 static void
 qla2x00_timer(scsi_qla_host_t *ha)
 {
-	int		t,l;
 	unsigned long	cpu_flags = 0;
 	fc_port_t	*fcport;
-	os_lun_t *lq;
-	os_tgt_t *tq;
 	int		start_dpc = 0;
 	int		index;
 	srb_t		*sp;
-
-	/*
-	 * We try and restart any request in the retry queue every second.
-	 */
-	if (!list_empty(&ha->retry_queue)) {
-		set_bit(PORT_RESTART_NEEDED, &ha->dpc_flags);
-		start_dpc++;
-	}
-
-	/*
-	 * We try and restart any request in the scsi_retry queue every second.
-	 */
-	if (!list_empty(&ha->scsi_retry_queue)) {
-		set_bit(SCSI_RESTART_NEEDED, &ha->dpc_flags);
-		start_dpc++;
-	}
+	int		t;
 
 	/*
 	 * Ports - Port down timer.
@@ -3696,59 +2865,6 @@
 		t++;
 	} /* End of for fcport  */
 
-	/*
-	 * LUNS - lun suspend timer.
-	 *
-	 * Whenever, a lun is suspended the timer starts decrementing its
-	 * suspend timer every second until it reaches zero. Once  it reaches
-	 * zero the lun retry count is decremented. 
-	 */
-
-	/*
-	 * FIXME(dg) - Need to convert this linear search of luns into a search
-	 * of a list of suspended luns.
-	 */
-	for (t = 0; t < ha->max_targets; t++) {
-		if ((tq = ha->otgt[t]) == NULL)
-			continue;
-
-		for (l = 0; l < ha->max_luns; l++) {
-			if ((lq = (os_lun_t *) tq->olun[l]) == NULL)
-				continue;
-
-			spin_lock_irqsave(&lq->q_lock, cpu_flags);
-			if (lq->q_state == LUN_STATE_WAIT &&
-				atomic_read(&lq->q_timer) != 0) {
-
-				if (atomic_dec_and_test(&lq->q_timer) != 0) {
-					/*
-					 * A delay should immediately
-					 * transition to a READY state
-					 */
-					if (test_and_clear_bit(LUN_EXEC_DELAYED,
-					    &lq->q_flag)) {
-						lq->q_state = LUN_STATE_READY;
-					}
-					else {
-						lq->q_count++;
-						if (lq->q_count == lq->q_max)
-							lq->q_state =
-							    LUN_STATE_TIMEOUT;
-						else
-							lq->q_state =
-							    LUN_STATE_RUN;
-					}
-				}
-				DEBUG3(printk("scsi(%ld): lun%d - timer %d, "
-				    "count=%d, max=%d, state=%d\n",
-				    ha->host_no,
-				    l,
-				    atomic_read(&lq->q_timer),
-				    lq->q_count, lq->q_max, lq->q_state));
-			}
-			spin_unlock_irqrestore(&lq->q_lock, cpu_flags);
-		} /* End of for luns  */
-	} /* End of for targets  */
 
 	/* Loop down handler. */
 	if (atomic_read(&ha->loop_down_timer) > 0 &&
@@ -3808,19 +2924,12 @@
 		    atomic_read(&ha->loop_down_timer)));
 	}
 
-	/*
-	 * Done Q Handler -- dgFIXME This handler will kick off doneq if we
-	 * haven't process it in 2 seconds.
-	 */
-	if (!list_empty(&ha->done_queue))
-		qla2x00_done(ha);
-
-
 	/* Schedule the DPC routine if needed */
 	if ((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) ||
 	    start_dpc ||
 	    test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags) ||
+	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
 	    test_bit(RELOGIN_NEEDED, &ha->dpc_flags)) &&
 	    ha->dpc_wait && !ha->dpc_active) {
 
@@ -3828,496 +2937,6 @@
 	}
 
 	qla2x00_restart_timer(ha, WATCH_INTERVAL);
-}
-
-/*
- * qla2x00_extend_timeout
- *      This routine will extend the timeout to the specified value.
- *
- * Input:
- *      cmd = SCSI command structure
- *
- * Returns:
- *      None.
- */
-void 
-qla2x00_extend_timeout(struct scsi_cmnd *cmd, int timeout) 
-{
-	srb_t *sp = (srb_t *) CMD_SP(cmd);
-	u_long our_jiffies = (timeout * HZ) + jiffies;
-
-    	sp->ext_history= 0; 
-	sp->e_start = jiffies;
-	if (cmd->eh_timeout.function) {
-		mod_timer(&cmd->eh_timeout,our_jiffies);
-		sp->ext_history |= 1;
-	}
-	if (sp->timer.function != NULL) {
-		/* 
-		 * Our internal timer should timeout before the midlayer has a
-		 * chance begin the abort process
-		 */
-		mod_timer(&sp->timer,our_jiffies - (QLA_CMD_TIMER_DELTA * HZ));
-
-    	 	sp->ext_history |= 2;
-	}
-}
-
-/**************************************************************************
-*   qla2x00_cmd_timeout
-*
-* Description:
-*       Handles the command if it times out in any state.
-*
-* Input:
-*     sp - pointer to validate
-*
-* Returns:
-* None.
-* Note:Need to add the support for if( sp->state == SRB_FAILOVER_STATE).
-**************************************************************************/
-void
-qla2x00_cmd_timeout(srb_t *sp)
-{
-	int t, l;
-	int processed;
-	scsi_qla_host_t *vis_ha, *dest_ha;
-	struct scsi_cmnd *cmd;
-	unsigned long flags, cpu_flags;
-	fc_port_t *fcport;
-
-	cmd = sp->cmd;
-	vis_ha = (scsi_qla_host_t *)cmd->device->host->hostdata;
-
-	DEBUG3(printk("cmd_timeout: Entering sp->state = %x\n", sp->state));
-
-	t = cmd->device->id;
-	l = cmd->device->lun;
-	fcport = sp->fclun->fcport;
-	dest_ha = sp->ha;
-
-	/*
-	 * If IO is found either in retry Queue 
-	 *    OR in Lun Queue
-	 * Return this IO back to host
-	 */
-	spin_lock_irqsave(&vis_ha->list_lock, flags);
-	processed = 0;
-	if (sp->state == SRB_PENDING_STATE) {
-		__del_from_pending_queue(vis_ha, sp);
-		DEBUG2(printk("scsi(%ld): Found in Pending queue pid %ld, "
-		    "State = %x., fcport state=%d sjiffs=%lx njiffs=%lx\n",
-		    vis_ha->host_no, cmd->serial_number, sp->state,
-		    atomic_read(&fcport->state), sp->r_start, jiffies));
-
-		/*
-		 * If FC_DEVICE is marked as dead return the cmd with
-		 * DID_NO_CONNECT status.  Otherwise set the host_byte to
-		 * DID_BUS_BUSY to let the OS  retry this cmd.
-		 */
-		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-		    atomic_read(&fcport->ha->loop_state) == LOOP_DEAD) {
-			cmd->result = DID_NO_CONNECT << 16;
-			if (atomic_read(&fcport->ha->loop_state) == LOOP_DOWN) 
-				sp->err_id = SRB_ERR_LOOP;
-			else
-				sp->err_id = SRB_ERR_PORT;
-		} else {
-			cmd->result = DID_BUS_BUSY << 16;
-		}
-		__add_to_done_queue(vis_ha, sp);
-		processed++;
-	} 
-	spin_unlock_irqrestore(&vis_ha->list_lock, flags);
-
-	if (processed) {
-		qla2x00_done(vis_ha);
-		return;
-	}
-
-	spin_lock_irqsave(&dest_ha->list_lock, flags);
-	if ((sp->state == SRB_RETRY_STATE) ||
-	    (sp->state == SRB_SCSI_RETRY_STATE)) {
-
-		DEBUG2(printk("scsi(%ld): Found in (Scsi) Retry queue or "
-		    "failover Q pid %ld, State = %x., fcport state=%d "
-		    "jiffies=%lx retried=%d\n",
-		    dest_ha->host_no, cmd->serial_number, sp->state,
-		    atomic_read(&fcport->state), jiffies, cmd->retries));
-
-		if ((sp->state == SRB_RETRY_STATE)) {
-			__del_from_retry_queue(dest_ha, sp);
-		} else if ((sp->state == SRB_SCSI_RETRY_STATE)) {
-			__del_from_scsi_retry_queue(dest_ha, sp);
-		} 
-
-		/*
-		 * If FC_DEVICE is marked as dead return the cmd with
-		 * DID_NO_CONNECT status.  Otherwise set the host_byte to
-		 * DID_BUS_BUSY to let the OS  retry this cmd.
-		 */
-		if ((atomic_read(&fcport->state) == FCS_DEVICE_DEAD) ||
-		    atomic_read(&dest_ha->loop_state) == LOOP_DEAD) {
-			qla2x00_extend_timeout(cmd, EXTEND_CMD_TIMEOUT);
-			cmd->result = DID_NO_CONNECT << 16;
-			if (atomic_read(&dest_ha->loop_state) == LOOP_DOWN) 
-				sp->err_id = SRB_ERR_LOOP;
-			else
-				sp->err_id = SRB_ERR_PORT;
-		} else {
-			cmd->result = DID_BUS_BUSY << 16;
-		}
-
-		__add_to_done_queue(dest_ha, sp);
-		processed++;
-	} 
-	spin_unlock_irqrestore(&dest_ha->list_lock, flags);
-
-	if (processed) {
-		qla2x00_done(dest_ha);
-		return;
-	}
-
-	spin_lock_irqsave(&dest_ha->list_lock, cpu_flags);
-	if (sp->state == SRB_DONE_STATE) {
-		/* IO in done_q  -- leave it */
-		DEBUG(printk("scsi(%ld): Found in Done queue pid %ld sp=%p.\n",
-		    dest_ha->host_no, cmd->serial_number, sp));
-	} else if (sp->state == SRB_SUSPENDED_STATE) {
-		DEBUG(printk("scsi(%ld): Found SP %p in suspended state  "
-		    "- pid %ld:\n",
-		    dest_ha->host_no, sp, cmd->serial_number));
-		DEBUG(qla2x00_dump_buffer((uint8_t *)sp, sizeof(srb_t));)
-	} else if (sp->state == SRB_ACTIVE_STATE) {
-		/*
-		 * IO is with ISP find the command in our active list.
-		 */
-		spin_unlock_irqrestore(&dest_ha->list_lock, cpu_flags);
-		spin_lock_irqsave(&dest_ha->hardware_lock, flags);
-		if (sp == dest_ha->outstanding_cmds[
-		    (unsigned long)sp->cmd->host_scribble]) {
-
-			DEBUG(printk("cmd_timeout: Found in ISP \n"));
-
-			if (sp->flags & SRB_TAPE) {
-				/*
-				 * We cannot allow the midlayer error handler
-				 * to wakeup and begin the abort process.
-				 * Extend the timer so that the firmware can
-				 * properly return the IOCB.
-				 */
-				DEBUG(printk("cmd_timeout: Extending timeout "
-				    "of FCP2 tape command!\n"));
-				qla2x00_extend_timeout(sp->cmd,
-				    EXTEND_CMD_TIMEOUT);
-			}
-			sp->state = SRB_ACTIVE_TIMEOUT_STATE;
-			spin_unlock_irqrestore(&dest_ha->hardware_lock, flags);
-		} else {
-			spin_unlock_irqrestore(&dest_ha->hardware_lock, flags);
-			printk(KERN_INFO 
-				"qla_cmd_timeout: State indicates it is with "
-				"ISP, But not in active array\n");
-		}
-		spin_lock_irqsave(&dest_ha->list_lock, cpu_flags);
-	} else if (sp->state == SRB_ACTIVE_TIMEOUT_STATE) {
-		DEBUG(printk("qla2100%ld: Found in Active timeout state"
-				"pid %ld, State = %x., \n",
-				dest_ha->host_no,
-				sp->cmd->serial_number, sp->state);)
-	} else {
-		/* EMPTY */
-		DEBUG2(printk("cmd_timeout%ld: LOST command state = "
-				"0x%x, sp=%p\n",
-				vis_ha->host_no, sp->state,sp);)
-
-		qla_printk(KERN_INFO, vis_ha,
-			"cmd_timeout: LOST command state = 0x%x\n", sp->state);
-	}
-	spin_unlock_irqrestore(&dest_ha->list_lock, cpu_flags);
-
-	DEBUG3(printk("cmd_timeout: Leaving\n");)
-}
-
-/**************************************************************************
-* qla2x00_done
-*      Process completed commands.
-*
-* Input:
-*      old_ha           = adapter block pointer.
-*
-**************************************************************************/
-void
-qla2x00_done(scsi_qla_host_t *old_ha)
-{
-	os_lun_t	*lq;
-	struct scsi_cmnd *cmd;
-	unsigned long	flags = 0;
-	scsi_qla_host_t	*ha;
-	scsi_qla_host_t	*vis_ha;
-	int	send_marker_once = 0;
-	srb_t           *sp, *sptemp;
-	LIST_HEAD(local_sp_list);
-
-	/*
-	 * Get into local queue such that we do not wind up calling done queue
-	 * tasklet for the same IOs from DPC or any other place.
-	 */
-	spin_lock_irqsave(&old_ha->list_lock, flags);
-	list_splice_init(&old_ha->done_queue, &local_sp_list);
-	spin_unlock_irqrestore(&old_ha->list_lock, flags);
-
-	/*
-	 * All done commands are in the local queue, now do the call back.
-	 */
-	list_for_each_entry_safe(sp, sptemp, &local_sp_list, list) {
-		old_ha->done_q_cnt--;
-        	sp->state = SRB_NO_QUEUE_STATE;
-
-		/* remove command from local list */
-		list_del_init(&sp->list);
-
-		cmd = sp->cmd;
-		if (cmd == NULL)
-		 	continue;
-
-		vis_ha = (scsi_qla_host_t *)cmd->device->host->hostdata;
-		lq = sp->lun_queue;
-		ha = sp->ha;
-
-		if (sp->flags & SRB_DMA_VALID) {
-			sp->flags &= ~SRB_DMA_VALID;
-
-			/* Release memory used for this I/O */
-			if (cmd->use_sg) {
-				pci_unmap_sg(ha->pdev, cmd->request_buffer,
-				    cmd->use_sg, cmd->sc_data_direction);
-			} else if (cmd->request_bufflen) {
-				pci_unmap_page(ha->pdev, sp->dma_handle,
-				    cmd->request_bufflen,
-				    cmd->sc_data_direction);
-			}
-		}
-
-
-		switch (host_byte(cmd->result)) {
-			case DID_OK:
-			case DID_ERROR:
-				break;
-
-			case DID_RESET:
-				/*
-				 * Set marker needed, so we don't have to
-				 * send multiple markers
-				 */
-				if (!send_marker_once) {
-					ha->marker_needed = 1;
-					send_marker_once++;
-				}
-
-				/*
-				 * WORKAROUND
-				 *
-				 * A backdoor device-reset requires different
-				 * error handling.  This code differentiates
-				 * between normal error handling and the
-				 * backdoor method.
-				 *
-				 */
-				if (ha->host->eh_active != EH_ACTIVE)
-					cmd->result = DID_BUS_BUSY << 16;
-				break;
-
-
-			case DID_ABORT:
-				sp->flags &= ~SRB_ABORT_PENDING;
-				sp->flags |= SRB_ABORTED;
-
-				if (sp->flags & SRB_TIMEOUT)
-					cmd->result = DID_TIME_OUT << 16;
-
-				break;
-
-			default:
-				DEBUG2(printk("scsi(%ld:%d:%d) %s: did_error "
-				    "= %d, comp-scsi= 0x%x-0x%x pid=%ld.\n",
-				    vis_ha->host_no,
-				    cmd->device->id, cmd->device->lun,
-				    __func__,
-				    host_byte(cmd->result),
-				    CMD_COMPL_STATUS(cmd),
-				    CMD_SCSI_STATUS(cmd), cmd->serial_number));
-				break;
-		}
-
-		/*
-		 * Call the mid-level driver interrupt handler -- via sp_put()
-		 */
-		sp_put(ha, sp);
-	} /* end of while */
-}
-
-/*
- * qla2x00_process_response_queue_in_zio_mode
- *	Process response queue completion as fast as possible
- *	to achieve Zero Interrupt Opertions-ZIO
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Context:
- *	Kernel context.
- */
-static inline void
-qla2x00_process_response_queue_in_zio_mode(scsi_qla_host_t *ha)
-{
-	unsigned long flags;
-
-	/* Check for unprocessed commands in response queue. */
-	if (!ha->flags.process_response_queue)
-		return;
-	if (!ha->flags.online)
-		return;
-	if (ha->response_ring_ptr->signature == RESPONSE_PROCESSED)
-		return;
-	
-	spin_lock_irqsave(&ha->hardware_lock,flags);
-	qla2x00_process_response_queue(ha);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-}
-
-/*
- * qla2x00_next
- *	Retrieve and process next job in the LUN queue.
- *
- * Input:
- *	tq = SCSI target queue pointer.
- *	lq = SCSI LUN queue pointer.
- *	TGT_LOCK must be already obtained.
- *
- * Output:
- *	Releases TGT_LOCK upon exit.
- *
- * Context:
- *	Kernel/Interrupt context.
- * 
- * Note: This routine will always try to start I/O from visible HBA.
- */
-void
-qla2x00_next(scsi_qla_host_t *vis_ha) 
-{
-	int		rval;
-	unsigned long   flags;
-	scsi_qla_host_t *dest_ha;
-	fc_port_t	*fcport;
-	srb_t           *sp, *sptemp;
-	LIST_HEAD(local_sp_list);
-
-	dest_ha = NULL;
-
-	spin_lock_irqsave(&vis_ha->list_lock, flags);
-	list_splice_init(&vis_ha->pending_queue, &local_sp_list);
-	vis_ha->qthreads = 0;
-	spin_unlock_irqrestore(&vis_ha->list_lock, flags);
-
-	list_for_each_entry_safe(sp, sptemp, &local_sp_list, list) {
-		list_del_init(&sp->list);
-        	sp->state = SRB_NO_QUEUE_STATE;
-
-		fcport = sp->fclun->fcport;
-		dest_ha = fcport->ha;
-
-		/* If device is dead then send request back to OS */
-		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD) {
-			sp->cmd->result = DID_NO_CONNECT << 16;
-			if (atomic_read(&dest_ha->loop_state) == LOOP_DOWN) 
-				sp->err_id = SRB_ERR_LOOP;
-			else
-				sp->err_id = SRB_ERR_PORT;
-
-			DEBUG3(printk("scsi(%ld): loop/port is down - pid=%ld, "
-			    "sp=%p err_id=%d loopid=0x%x queued to dest HBA "
-			    "scsi%ld.\n", dest_ha->host_no,
-			    sp->cmd->serial_number, sp, sp->err_id,
-			    fcport->loop_id, dest_ha->host_no));
-			/* 
-			 * Initiate a failover - done routine will initiate.
-			 */
-			add_to_done_queue(vis_ha, sp);
-
-			continue;
-		}
-
-		/*
-		 * SCSI Kluge: Whenever, we need to wait for an event such as
-		 * loop down (i.e. loop_down_timer ) or port down (i.e.  LUN
-		 * request qeueue is suspended) then we will recycle new
-		 * commands back to the SCSI layer.  We do this because this is
-		 * normally a temporary condition and we don't want the
-		 * mid-level scsi.c driver to get upset and start aborting
-		 * commands.  The timeout value is extracted from the command
-		 * minus 1-second and put on a retry queue (watchdog). Once the
-		 * command timeout it is returned to the mid-level with a BUSY
-		 * status, so the mid-level will retry it. This process
-		 * continues until the LOOP DOWN time expires or the condition
-		 * goes away.
-		 */
-		if (!(sp->flags & (SRB_IOCTL | SRB_TAPE)) &&
-		    (atomic_read(&fcport->state) != FCS_ONLINE ||
-			test_bit(ABORT_ISP_ACTIVE, &dest_ha->dpc_flags) ||
-			atomic_read(&dest_ha->loop_state) != LOOP_READY)) {
-
-			DEBUG3(printk("scsi(%ld): pid=%ld port=0x%x state=%d "
-			    "loop state=%d, loop counter=0x%x "
-			    "dpc_flags=0x%lx\n", sp->cmd->serial_number,
-			    dest_ha->host_no, fcport->loop_id,
-			    atomic_read(&fcport->state),
-			    atomic_read(&dest_ha->loop_state),
-			    atomic_read(&dest_ha->loop_down_timer),
-			    dest_ha->dpc_flags));
-
-			qla2x00_extend_timeout(sp->cmd, EXTEND_CMD_TIMEOUT);
-			add_to_retry_queue(vis_ha, sp);
-
-			continue;
-		} 
-
-		/*
-		 * If this request's lun is suspended then put the request on
-		 * the  scsi_retry queue. 
-		 */
-	 	if (!(sp->flags & (SRB_IOCTL | SRB_TAPE)) &&
-		    sp->lun_queue->q_state == LUN_STATE_WAIT) {
-			DEBUG3(printk("scsi(%ld): lun wait state - pid=%ld, "
-			    "opcode=%d, allowed=%d, retries=%d\n",
-			    dest_ha->host_no,
-			    sp->cmd->serial_number,
-			    sp->cmd->cmnd[0],
-			    sp->cmd->allowed,
-			    sp->cmd->retries));
-				
-			add_to_scsi_retry_queue(vis_ha, sp);
-
-			continue;
-		}
-
-		sp->lun_queue->io_cnt++;
-
-		rval = qla2x00_start_scsi(sp);
-		if (rval != QLA_SUCCESS) {
-			/* Place request back on top of device queue */
-			/* add to the top of queue */
-			add_to_pending_queue_head(vis_ha, sp);
-
-			sp->lun_queue->io_cnt--;
-		}
-	}
-
-	if (!IS_QLA2100(vis_ha) && !IS_QLA2200(vis_ha)) {
-		/* Process response_queue if ZIO support is enabled*/ 
-		qla2x00_process_response_queue_in_zio_mode(vis_ha);
-
-	}
 }
 
 /* XXX(hch): crude hack to emulate a down_timeout() */
diff -Nru a/drivers/scsi/qla2xxx/qla_listops.h /dev/null
--- a/drivers/scsi/qla2xxx/qla_listops.h	2005-02-04 08:36:55 -08:00
+++ /dev/null	2005-02-04 08:36:55 -08:00
@@ -1,351 +0,0 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- ******************************************************************************/
-
-/* Management functions for various lists */
-
-/* __add_to_done_queue()
- * 
- * Place SRB command on done queue.
- *
- * Input:
- *      ha           = host pointer
- *      sp           = srb pointer.
- * Locking:
- * 	this function assumes the ha->list_lock is already taken
- */
-static inline void 
-__add_to_done_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-	/*
-        if (sp->state != SRB_NO_QUEUE_STATE && 
-        	sp->state != SRB_ACTIVE_STATE)
-		BUG();
-	*/
-
-        /* Place block on done queue */
-        sp->cmd->host_scribble = (unsigned char *) NULL;
-        sp->state = SRB_DONE_STATE;
-        list_add_tail(&sp->list,&ha->done_queue);
-        ha->done_q_cnt++;
-	sp->ha = ha;
-}
-
-static inline void 
-__add_to_retry_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-	/*
-        if( sp->state != SRB_NO_QUEUE_STATE && 
-        	sp->state != SRB_ACTIVE_STATE)
-		BUG();
-	*/
-
-        /* Place block on retry queue */
-        list_add_tail(&sp->list,&ha->retry_queue);
-        ha->retry_q_cnt++;
-        sp->flags |= SRB_WATCHDOG;
-        sp->state = SRB_RETRY_STATE;
-	sp->ha = ha;
-}
-
-static inline void 
-__add_to_scsi_retry_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-	/*
-        if( sp->state != SRB_NO_QUEUE_STATE && 
-        	sp->state != SRB_ACTIVE_STATE)
-		BUG();
-	*/
-
-        /* Place block on retry queue */
-        list_add_tail(&sp->list,&ha->scsi_retry_queue);
-        ha->scsi_retry_q_cnt++;
-        sp->state = SRB_SCSI_RETRY_STATE;
-	sp->ha = ha;
-}
-
-static inline void 
-add_to_done_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-        unsigned long flags;
-
-        spin_lock_irqsave(&ha->list_lock, flags);
-        __add_to_done_queue(ha,sp);
-        spin_unlock_irqrestore(&ha->list_lock, flags);
-}
-
-static inline void 
-add_to_free_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-	mempool_free(sp, ha->srb_mempool);
-}
-
-static inline void 
-add_to_retry_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-        unsigned long flags;
-
-        spin_lock_irqsave(&ha->list_lock, flags);
-        __add_to_retry_queue(ha,sp);
-        spin_unlock_irqrestore(&ha->list_lock, flags);
-}
-
-static inline void 
-add_to_scsi_retry_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-        unsigned long flags;
-
-        spin_lock_irqsave(&ha->list_lock, flags);
-        __add_to_scsi_retry_queue(ha,sp);
-        spin_unlock_irqrestore(&ha->list_lock, flags);
-}
-
-/*
- * __del_from_retry_queue
- *      Function used to remove a command block from the
- *      watchdog timer queue.
- *
- *      Note: Must insure that command is on watchdog
- *            list before calling del_from_retry_queue
- *            if (sp->flags & SRB_WATCHDOG)
- *
- * Input: 
- *      ha = adapter block pointer.
- *      sp = srb pointer.
- * Locking:
- *	this function assumes the list_lock is already taken
- */
-static inline void 
-__del_from_retry_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-        list_del_init(&sp->list);
-
-        sp->flags &= ~(SRB_WATCHDOG | SRB_BUSY);
-        sp->state = SRB_NO_QUEUE_STATE;
-        ha->retry_q_cnt--;
-}
-
-/*
- * __del_from_scsi_retry_queue
- *      Function used to remove a command block from the
- *      scsi retry queue.
- *
- * Input: 
- *      ha = adapter block pointer.
- *      sp = srb pointer.
- * Locking:
- *	this function assumes the list_lock is already taken
- */
-static inline void 
-__del_from_scsi_retry_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-        list_del_init(&sp->list);
-
-        ha->scsi_retry_q_cnt--;
-        sp->state = SRB_NO_QUEUE_STATE;
-}
-
-/*
- * del_from_retry_queue
- *      Function used to remove a command block from the
- *      watchdog timer queue.
- *
- *      Note: Must insure that command is on watchdog
- *            list before calling del_from_retry_queue
- *            if (sp->flags & SRB_WATCHDOG)
- *
- * Input: 
- *      ha = adapter block pointer.
- *      sp = srb pointer.
- * Locking:
- *	this function takes and releases the list_lock
- */
-static inline void 
-del_from_retry_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-        unsigned long flags;
-
-        /*	if (unlikely(!(sp->flags & SRB_WATCHDOG)))
-        		BUG();*/
-        spin_lock_irqsave(&ha->list_lock, flags);
-
-        /*	if (unlikely(list_empty(&ha->retry_queue)))
-        		BUG();*/
-
-        __del_from_retry_queue(ha,sp);
-
-        spin_unlock_irqrestore(&ha->list_lock, flags);
-}
-/*
- * del_from_scsi_retry_queue
- *      Function used to remove a command block from the
- *      scsi retry queue.
- *
- * Input: 
- *      ha = adapter block pointer.
- *      sp = srb pointer.
- * Locking:
- *	this function takes and releases the list_lock
- */
-static inline void 
-del_from_scsi_retry_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-        unsigned long flags;
-
-        spin_lock_irqsave(&ha->list_lock, flags);
-
-        /*	if (unlikely(list_empty(&ha->scsi_retry_queue)))
-        		BUG();*/
-
-        __del_from_scsi_retry_queue(ha,sp);
-
-        spin_unlock_irqrestore(&ha->list_lock, flags);
-}
-
-/*
- * __add_to_pending_queue
- *      Add the standard SCB job to the bottom of standard SCB commands.
- *
- * Input:
- * COMPLETE!!!
- *      q  = SCSI LU pointer.
- *      sp = srb pointer.
- *      SCSI_LU_Q lock must be already obtained.
- */
-static inline int 
-__add_to_pending_queue(struct scsi_qla_host *ha, srb_t * sp)
-{
-	int	empty;
-	/*
-        if( sp->state != SRB_NO_QUEUE_STATE &&
-        	sp->state != SRB_FREE_STATE &&
-        	sp->state != SRB_ACTIVE_STATE)
-		BUG();
-	*/
-
-	empty = list_empty(&ha->pending_queue);
-	list_add_tail(&sp->list, &ha->pending_queue);
-	ha->qthreads++;
-	sp->state = SRB_PENDING_STATE;
-
-	return (empty);
-}
-
-static inline void 
-__add_to_pending_queue_head(struct scsi_qla_host *ha, srb_t * sp)
-{
-	/*
-        if( sp->state != SRB_NO_QUEUE_STATE && 
-        	sp->state != SRB_FREE_STATE &&
-        	sp->state != SRB_ACTIVE_STATE)
-		BUG();
-	*/
-
-	list_add(&sp->list, &ha->pending_queue);
-	ha->qthreads++;
-	sp->state = SRB_PENDING_STATE;
-}
-
-static inline int
-add_to_pending_queue(struct scsi_qla_host *ha, srb_t *sp)
-{
-	int	empty;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ha->list_lock, flags);
-	empty = __add_to_pending_queue(ha, sp);
-	spin_unlock_irqrestore(&ha->list_lock, flags);
-
-	return (empty);
-}
-static inline void
-add_to_pending_queue_head(struct scsi_qla_host *ha, srb_t *sp)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ha->list_lock, flags);
-	__add_to_pending_queue_head(ha, sp);
-	spin_unlock_irqrestore(&ha->list_lock, flags);
-}
-
-static inline void
-__del_from_pending_queue(struct scsi_qla_host *ha, srb_t *sp)
-{
-	list_del_init(&sp->list);
-	ha->qthreads--;
-	sp->state = SRB_NO_QUEUE_STATE;
-}
-
-/*
- * Failover Stuff.
- */
-static inline void
-__add_to_failover_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-	/*
-        if( sp->state != SRB_NO_QUEUE_STATE && 
-        	sp->state != SRB_ACTIVE_STATE)
-		BUG();
-	*/
-
-        list_add_tail(&sp->list,&ha->failover_queue);
-        ha->failover_cnt++;
-        sp->state = SRB_FAILOVER_STATE;
-	sp->ha = ha;
-}
-
-static inline void add_to_failover_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-        unsigned long flags;
-
-        spin_lock_irqsave(&ha->list_lock, flags);
-
-        __add_to_failover_queue(ha,sp);
-
-        spin_unlock_irqrestore(&ha->list_lock, flags);
-}
-static inline void __del_from_failover_queue(struct scsi_qla_host * ha, srb_t *
-                sp)
-{
-        ha->failover_cnt--;
-        list_del_init(&sp->list);
-        sp->state = SRB_NO_QUEUE_STATE;
-}
-
-static inline void del_from_failover_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-        unsigned long flags;
-
-        spin_lock_irqsave(&ha->list_lock, flags);
-
-        __del_from_failover_queue(ha,sp);
-
-        spin_unlock_irqrestore(&ha->list_lock, flags);
-}
-
-static inline void 
-del_from_pending_queue(struct scsi_qla_host * ha, srb_t * sp)
-{
-        unsigned long flags;
-
-        spin_lock_irqsave(&ha->list_lock, flags);
-
-        __del_from_pending_queue(ha,sp);
-
-        spin_unlock_irqrestore(&ha->list_lock, flags);
-}

