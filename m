From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [13/18] qla2xxx: Remove TRUE/FALSE usage
Date: Mon, 21 Jun 2004 22:58:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055802.GA8476@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:34735 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266606AbUFVFyS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:54:18 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1849 04/06/17 10:04:59 andrew.vasquez@apc.qlogic.com +5 -0
  Christoph Hellwig <hch () lst !de>:
  
  o Remove TRUE/FALSE #define usage within the driver.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_init.c   |   34 +++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_inline.h |    4 ++--
 drivers/scsi/qla2xxx/qla_isr.c    |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c    |    8 ++++----
 drivers/scsi/qla2xxx/qla_os.c     |   23 ++++++++++-------------
 5 files changed, 34 insertions(+), 37 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:39:31 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:39:31 -07:00
@@ -107,8 +107,8 @@
 	uint32_t wait_time;
 
 	/* Clear adapter flags. */
-	ha->flags.online = FALSE;
-	ha->flags.reset_active = FALSE;
+	ha->flags.online = 0;
+	ha->flags.reset_active = 0;
 	atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 	atomic_set(&ha->loop_state, LOOP_DOWN);
 	ha->device_flags = 0;
@@ -225,7 +225,7 @@
 		qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
 		ha->marker_needed = 0;
 
-		ha->flags.online = TRUE;
+		ha->flags.online = 1;
 	} else {
 		DEBUG2_3(printk("%s(): **** FAILED ****\n", __func__));
 	}
@@ -1552,20 +1552,20 @@
 	if (ha->current_topology == ISP_CFG_FL &&
 	    (test_bit(LOCAL_LOOP_UPDATE, &flags))) {
 
-		ha->flags.rscn_queue_overflow = TRUE;
+		ha->flags.rscn_queue_overflow = 1;
 		set_bit(RSCN_UPDATE, &flags);
 
 	} else if (ha->current_topology == ISP_CFG_F &&
 	    (test_bit(LOCAL_LOOP_UPDATE, &flags))) {
 
-		ha->flags.rscn_queue_overflow = TRUE;
+		ha->flags.rscn_queue_overflow = 1;
 		set_bit(RSCN_UPDATE, &flags);
 		clear_bit(LOCAL_LOOP_UPDATE, &flags);
 
 	} else if (!ha->flags.online ||
 	    (test_bit(ABORT_ISP_ACTIVE, &flags))) {
 
-		ha->flags.rscn_queue_overflow = TRUE;
+		ha->flags.rscn_queue_overflow = 1;
 		set_bit(RSCN_UPDATE, &flags);
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	}
@@ -3103,7 +3103,7 @@
 				wait_time &&
 				(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
 		}
-		qla2x00_restart_queues(ha, TRUE);
+		qla2x00_restart_queues(ha, 1);
 	}
 
 	if (test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) {
@@ -4106,7 +4106,7 @@
 	uint8_t        status = 0;
 
 	if (ha->flags.online) {
-		ha->flags.online = FALSE;
+		ha->flags.online = 0;
 		clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 		qla2x00_stats.ispAbort++;
 		ha->total_isp_aborts++;  /* used by ioctl */
@@ -4171,20 +4171,20 @@
 				ha->marker_needed = 1;
 			}
 
-			ha->flags.online = TRUE;
+			ha->flags.online = 1;
 
 			/* Enable ISP interrupts. */
 			qla2x00_enable_intrs(ha);
 
 			/* v2.19.5b6 Return all commands */
-			qla2x00_abort_queues(ha, TRUE);
+			qla2x00_abort_queues(ha, 1);
 
 			/* Restart queues that may have been stopped. */
-			qla2x00_restart_queues(ha,TRUE);
+			qla2x00_restart_queues(ha, 1);
 			ha->isp_abort_cnt = 0; 
 			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 		} else {	/* failed the ISP abort */
-			ha->flags.online = TRUE;
+			ha->flags.online = 1;
 			if (test_bit(ISP_ABORT_RETRY, &ha->dpc_flags)) {
 				if (ha->isp_abort_cnt == 0) {
  					qla_printk(KERN_WARNING, ha,
@@ -4195,8 +4195,8 @@
 					 * completely.
 					 */
 					qla2x00_reset_adapter(ha);
-					qla2x00_abort_queues(ha, FALSE);
-					ha->flags.online = FALSE;
+					qla2x00_abort_queues(ha, 0);
+					ha->flags.online = 0;
 					clear_bit(ISP_ABORT_RETRY,
 					    &ha->dpc_flags);
 					status = 0;
@@ -4251,7 +4251,7 @@
 
 	/* If firmware needs to be loaded */
 	if (qla2x00_isp_firmware(ha)) {
-		ha->flags.online = FALSE;
+		ha->flags.online = 0;
 		if (!(status = qla2x00_chip_diag(ha))) {
 			if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 				status = qla2x00_setup_chip(ha);
@@ -4290,7 +4290,7 @@
 					"status = %d\n",
 					__func__,
 					status);)
-			ha->flags.online = TRUE;
+			ha->flags.online = 1;
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
 			wait_time = 256;
 			do {
@@ -4327,7 +4327,7 @@
 	unsigned long flags = 0;
 	device_reg_t *reg = ha->iobase;
 
-	ha->flags.online = FALSE;
+	ha->flags.online = 0;
 	qla2x00_disable_intrs(ha);
 	/* Reset RISC processor. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
diff -Nru a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h	2004-06-21 15:39:31 -07:00
+++ b/drivers/scsi/qla2xxx/qla_inline.h	2004-06-21 15:39:31 -07:00
@@ -165,7 +165,7 @@
  *      wwn = Pointer to WW name to check
  *
  * Returns:
- *      TRUE if name is 0 else FALSE
+ *      1 if name is 0x00 else 0
  *
  * Context:
  *      Kernel context.
@@ -179,7 +179,7 @@
 		if (*wwn != 0)
 			break;
 	}
-	/* if zero return TRUE */
+	/* if zero return 1 */
 	if (cnt == WWN_SIZE)
 		return (1);
 	else
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	2004-06-21 15:39:31 -07:00
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2004-06-21 15:39:31 -07:00
@@ -233,7 +233,7 @@
 	device_reg_t	*reg = ha->iobase;
 
 	/* Load return mailbox registers. */
-	ha->flags.mbox_int = TRUE;
+	ha->flags.mbox_int = 1;
 	ha->mailbox_out[0] = mb0;
 	wptr = (uint16_t *)MAILBOX_REG(ha, reg, 1);
 
diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	2004-06-21 15:39:31 -07:00
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	2004-06-21 15:39:31 -07:00
@@ -89,7 +89,7 @@
 		}
 	}
 
-	ha->flags.mbox_busy = TRUE;
+	ha->flags.mbox_busy = 1;
 	/* Save mailbox command for debug */
 	ha->mcp = mcp;
 
@@ -135,7 +135,7 @@
 #endif
 
 	/* Issue set host interrupt command to send cmd out. */
-	ha->flags.mbox_int = FALSE;
+	ha->flags.mbox_int = 0;
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 
 	/* Unlock mbx registers and wait for interrupt */
@@ -216,7 +216,7 @@
 		    command);)
 
 		/* Got interrupt. Clear the flag. */
-		ha->flags.mbox_int = FALSE;
+		ha->flags.mbox_int = 0;
 		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 
 		if (ha->mailbox_out[0] != MBS_COMMAND_COMPLETE) {
@@ -257,7 +257,7 @@
 	if (!abort_active)
 		spin_unlock_irqrestore(&ha->mbx_reg_lock, mbx_flags);
 
-	ha->flags.mbox_busy = FALSE;
+	ha->flags.mbox_busy = 0;
 
 	/* Clean up */
 	ha->mcp = NULL;
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:39:31 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:39:31 -07:00
@@ -971,7 +971,7 @@
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(HZ);
 	}
-	if (ha->flags.online == TRUE) 
+	if (ha->flags.online) 
 		return_status = QLA_SUCCESS; 
 	else
 		return_status = QLA_FUNCTION_FAILED;
@@ -2216,7 +2216,7 @@
 	qla2x00_mem_free(ha);
 
 
-	ha->flags.online = FALSE;
+	ha->flags.online = 0;
 
 	/* Detach interrupts */
 	if (ha->pdev->irq)
@@ -2287,12 +2287,12 @@
 *
 * inout : decides the direction of the dataflow and the meaning of the
 *         variables
-* buffer: If inout==FALSE data is being written to it else read from it
+* buffer: If inout==0 data is being written to it else read from it
 *         (ptr to a page buffer)
-* *start: If inout==FALSE start of the valid data in the buffer
-* offset: If inout==FALSE starting offset from the beginning of all
+* *start: If inout==0 start of the valid data in the buffer
+* offset: If inout==0 starting offset from the beginning of all
 *         possible data to return.
-* length: If inout==FALSE max number of bytes to be written into the buffer
+* length: If inout==0 max number of bytes to be written into the buffer
 *         else number of bytes in "buffer"
 * Returns:
 *         < 0:  error. errno value.
@@ -2319,7 +2319,7 @@
 
 	ha = (scsi_qla_host_t *) shost->hostdata;
 
-	if (inout == TRUE) {
+	if (inout) {
 		/* Has data been written to the file? */
 		DEBUG3(printk(
 		    "%s: has data been written to the file. \n",
@@ -2483,6 +2483,7 @@
 		    tq->port_name[4], tq->port_name[5],
 		    tq->port_name[6], tq->port_name[7]);
 	}
+
 	copy_info(&info, "\nSCSI LUN Information:\n");
 	copy_info(&info,
 	    "(Id:Lun)  * - indicates lun is not registered with the OS.\n");
@@ -3460,7 +3461,7 @@
 			DEBUG(printk("scsi(%ld): qla2x00_restart_queues()\n",
 			    ha->host_no));
 
-			qla2x00_restart_queues(ha,FALSE);
+			qla2x00_restart_queues(ha, 0);
 
 			DEBUG(printk("scsi(%ld): qla2x00_restart_queues - end\n",
 			    ha->host_no));
@@ -3471,7 +3472,7 @@
 			DEBUG(printk("scsi(%ld): qla2x00_abort_queues()\n",
 			    ha->host_no));
 				
-			qla2x00_abort_queues(ha, FALSE);
+			qla2x00_abort_queues(ha, 0);
 
 			DEBUG(printk("scsi(%ld): qla2x00_abort_queues - end\n",
 			    ha->host_no));
@@ -3562,8 +3563,6 @@
 	if (ha->flags.online && !ha->flags.reset_active &&
 	    !atomic_read(&ha->loop_down_timer) &&
 	    !(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags))) {
-
-		/* 10/15 ha->flags.reset_active = TRUE; */
 		do {
 			clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 
@@ -3574,8 +3573,6 @@
 			ha->marker_needed = 1;
 		} while (!atomic_read(&ha->loop_down_timer) &&
 		    (test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags)));
-
-		/* 10/15 ha->flags.reset_active = FALSE; */
 	}
 }
 
