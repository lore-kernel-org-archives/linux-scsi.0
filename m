From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [5/8]  qla2xxx: Rework ISR registration
Date: Mon, 6 Sep 2004 21:28:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907042834.GA29637@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:60097 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267583AbUIGEaW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 00:30:22 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

ChangeSet
  1.1875 04/09/06 11:51:36 andrew.vasquez@qlogic.com +4 -0
  Rework interrupt-handler registration in anticipation of future
  chip types.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_gbl.h    |    3 
 drivers/scsi/qla2xxx/qla_inline.h |    5 
 drivers/scsi/qla2xxx/qla_isr.c    |  269 +++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_os.c     |    9 -
 4 files changed, 152 insertions(+), 134 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	2004-09-06 12:07:52 -07:00
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2004-09-06 12:07:52 -07:00
@@ -246,7 +246,8 @@
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
-extern irqreturn_t qla2x00_intr_handler(int, void *, struct pt_regs *);
+extern irqreturn_t qla2100_intr_handler(int, void *, struct pt_regs *);
+extern irqreturn_t qla2300_intr_handler(int, void *, struct pt_regs *);
 extern void qla2x00_process_response_queue(struct scsi_qla_host *);
 
 /*
diff -Nru a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h	2004-09-06 12:07:52 -07:00
+++ b/drivers/scsi/qla2xxx/qla_inline.h	2004-09-06 12:07:52 -07:00
@@ -117,7 +117,10 @@
 static inline void 
 qla2x00_poll(scsi_qla_host_t *ha)
 {
-	qla2x00_intr_handler(0, ha, NULL);
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		qla2100_intr_handler(0, ha, NULL);
+	else
+		qla2300_intr_handler(0, ha, NULL);
 }
 
 
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	2004-09-06 12:07:52 -07:00
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2004-09-06 12:07:52 -07:00
@@ -30,7 +30,7 @@
 static int qla2x00_check_sense(struct scsi_cmnd *cp, os_lun_t *);
 
 /**
- * qla2x00_intr_handler() - Process interrupts for the ISP.
+ * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
  * @irq:
  * @dev_id: SCSI driver HA context
  * @regs:
@@ -40,20 +40,14 @@
  * Returns handled flag.
  */
 irqreturn_t
-qla2x00_intr_handler(int irq, void *dev_id, struct pt_regs *regs)
+qla2100_intr_handler(int irq, void *dev_id, struct pt_regs *regs)
 {
 	scsi_qla_host_t	*ha;
 	device_reg_t	*reg;
+	int		status;
+	unsigned long	flags;
+	unsigned long	iter;
 	uint32_t	mbx;
-	int		status = 0;
-	unsigned long	flags = 0;
-	unsigned long	mbx_flags = 0;
-	unsigned long	intr_iter;
-	uint32_t	stat;
-	uint16_t	hccr;
-
-	/* Don't loop forever, interrupt are OFF */
-	intr_iter = 50; 
 
 	ha = (scsi_qla_host_t *) dev_id;
 	if (!ha) {
@@ -63,107 +57,40 @@
 	}
 
 	reg = ha->iobase;
+	status = 0;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (iter = 50; iter--; ) {
+		if ((RD_REG_WORD(&reg->istatus) & ISR_RISC_INT) == 0)
+			break;
 
-	for (;;) {
-		/* Relax CPU! */
-		if (!(intr_iter--))
-			break;
-
-		if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-			if ((RD_REG_WORD(&reg->istatus) & ISR_RISC_INT) == 0)
-				break;
-
-			if (RD_REG_WORD(&reg->semaphore) & BIT_0) {
-				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-				RD_REG_WORD(&reg->hccr);
-
-				/* Get mailbox data. */
-				mbx = RD_MAILBOX_REG(ha, reg, 0);
-				if (mbx > 0x3fff && mbx < 0x8000) {
-					qla2x00_mbx_completion(ha,
-					    (uint16_t)mbx);
-					status |= MBX_INTERRUPT;
-				} else if (mbx > 0x7fff && mbx < 0xc000) {
-					qla2x00_async_event(ha, mbx);
-				} else {
-					/*EMPTY*/
-					DEBUG2(printk("scsi(%ld): Unrecognized "
-					    "interrupt type (%d)\n",
-					    ha->host_no, mbx));
-				}
-				/* Release mailbox registers. */
-				WRT_REG_WORD(&reg->semaphore, 0);
-				/* Workaround for ISP2100 chip. */
-				if (IS_QLA2100(ha))
-					RD_REG_WORD(&reg->semaphore);
-			} else {
-				qla2x00_process_response_queue(ha);
-	
-				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-				RD_REG_WORD(&reg->hccr);
-			}
-		} else /* IS_QLA23XX(ha) */ {
-			stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
-			if (stat & HSR_RISC_PAUSED) {
-				hccr = RD_REG_WORD(&reg->hccr);
-				if (hccr & (BIT_15 | BIT_13 | BIT_11 | BIT_8))
-					qla_printk(KERN_INFO, ha,
-					    "Parity error -- HCCR=%x.\n", hccr);
-				else
-					qla_printk(KERN_INFO, ha,
-					    "RISC paused -- HCCR=%x\n", hccr);
-
-				/*
-				 * Issue a "HARD" reset in order for the RISC
-				 * interrupt bit to be cleared.  Schedule a big
-				 * hammmer to get out of the RISC PAUSED state.
-				 */
-				WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
-				RD_REG_WORD(&reg->hccr);
-				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-				break;
-			} else if ((stat & HSR_RISC_INT) == 0)
-				break;
-
-			mbx = MSW(stat);
-			switch (stat & 0xff) {
-			case 0x13:
-				qla2x00_process_response_queue(ha);
-				break;
-			case 0x1:
-			case 0x2:
-			case 0x10:
-			case 0x11:
+		if (RD_REG_WORD(&reg->semaphore) & BIT_0) {
+			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
+			RD_REG_WORD(&reg->hccr);
+
+			/* Get mailbox data. */
+			mbx = RD_MAILBOX_REG(ha, reg, 0);
+			if (mbx > 0x3fff && mbx < 0x8000) {
 				qla2x00_mbx_completion(ha, (uint16_t)mbx);
 				status |= MBX_INTERRUPT;
-
-				/* Release mailbox registers. */
-				WRT_REG_WORD(&reg->semaphore, 0);
-				break;
-			case 0x12:
-				qla2x00_async_event(ha, mbx);
-				break;
-			case 0x15:
-				mbx = mbx << 16 | MBA_CMPLT_1_16BIT;
+			} else if (mbx > 0x7fff && mbx < 0xc000) {
 				qla2x00_async_event(ha, mbx);
-				break;
-			case 0x16:
-				mbx = mbx << 16 | MBA_SCSI_COMPLETION;
-				qla2x00_async_event(ha, mbx);
-				break;
-			default:
+			} else {
+				/*EMPTY*/
 				DEBUG2(printk("scsi(%ld): Unrecognized "
 				    "interrupt type (%d)\n",
-				    ha->host_no, stat & 0xff));
-				break;
+				    ha->host_no, mbx));
 			}
+			/* Release mailbox registers. */
+			WRT_REG_WORD(&reg->semaphore, 0);
+			RD_REG_WORD(&reg->semaphore);
+		} else {
+			qla2x00_process_response_queue(ha);
+
 			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-			RD_REG_WORD_RELAXED(&reg->hccr);
+			RD_REG_WORD(&reg->hccr);
 		}
 	}
-
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	qla2x00_next(ha);
@@ -172,47 +99,129 @@
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
+		spin_lock_irqsave(&ha->mbx_reg_lock, flags);
 
-		/* There was a mailbox completion */
-		DEBUG3(printk("%s(%ld): Going to get mbx reg lock.\n",
-		    __func__, ha->host_no));
-
-		spin_lock_irqsave(&ha->mbx_reg_lock, mbx_flags);
-
-		if (ha->mcp == NULL) {
-			DEBUG3(printk("%s(%ld): Error mbx pointer.\n",
-			    __func__, ha->host_no));
-		} else {
-			DEBUG3(printk("%s(%ld): Going to set mbx intr flags. "
-			    "cmd=%x.\n",
-			    __func__, ha->host_no, ha->mcp->mb[0]));
-		}
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-
-		DEBUG3(printk("%s(%ld): Going to wake up mbx function for "
-		    "completion.\n",
-		    __func__, ha->host_no));
-
 		up(&ha->mbx_intr_sem);
 
-		DEBUG3(printk("%s(%ld): Going to release mbx reg lock.\n",
-		    __func__, ha->host_no));
-
-		spin_unlock_irqrestore(&ha->mbx_reg_lock, mbx_flags);
+		spin_unlock_irqrestore(&ha->mbx_reg_lock, flags);
 	}
 
 	if (!list_empty(&ha->done_queue))
 		qla2x00_done(ha);
 
-	/* Wakeup the DPC routine */
-	if ((!ha->flags.mbox_busy &&
-	    (test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
-		test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
-		test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))) &&
-		    ha->dpc_wait && !ha->dpc_active) {
+	return (IRQ_HANDLED);
+}
+
+/**
+ * qla2300_intr_handler() - Process interrupts for the ISP23xx and ISP63xx.
+ * @irq:
+ * @dev_id: SCSI driver HA context
+ * @regs:
+ *
+ * Called by system whenever the host adapter generates an interrupt.
+ *
+ * Returns handled flag.
+ */
+irqreturn_t
+qla2300_intr_handler(int irq, void *dev_id, struct pt_regs *regs)
+{
+	scsi_qla_host_t	*ha;
+	device_reg_t	*reg;
+	int		status;
+	unsigned long	flags;
+	unsigned long	iter;
+	uint32_t	stat;
+	uint32_t	mbx;
+	uint16_t	hccr;
 
-		up(ha->dpc_wait);
+	ha = (scsi_qla_host_t *) dev_id;
+	if (!ha) {
+		printk(KERN_INFO
+		    "%s(): NULL host pointer\n", __func__);
+		return (IRQ_NONE);
+	}
+
+	reg = ha->iobase;
+	status = 0;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (iter = 50; iter--; ) {
+		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
+		if (stat & HSR_RISC_PAUSED) {
+			hccr = RD_REG_WORD(&reg->hccr);
+			if (hccr & (BIT_15 | BIT_13 | BIT_11 | BIT_8))
+				qla_printk(KERN_INFO, ha,
+				    "Parity error -- HCCR=%x.\n", hccr);
+			else
+				qla_printk(KERN_INFO, ha,
+				    "RISC paused -- HCCR=%x\n", hccr);
+
+			/*
+			 * Issue a "HARD" reset in order for the RISC
+			 * interrupt bit to be cleared.  Schedule a big
+			 * hammmer to get out of the RISC PAUSED state.
+			 */
+			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
+			RD_REG_WORD(&reg->hccr);
+			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			break;
+		} else if ((stat & HSR_RISC_INT) == 0)
+			break;
+
+		mbx = MSW(stat);
+		switch (stat & 0xff) {
+		case 0x13:
+			qla2x00_process_response_queue(ha);
+			break;
+		case 0x1:
+		case 0x2:
+		case 0x10:
+		case 0x11:
+			qla2x00_mbx_completion(ha, (uint16_t)mbx);
+			status |= MBX_INTERRUPT;
+
+			/* Release mailbox registers. */
+			WRT_REG_WORD(&reg->semaphore, 0);
+			break;
+		case 0x12:
+			qla2x00_async_event(ha, mbx);
+			break;
+		case 0x15:
+			mbx = mbx << 16 | MBA_CMPLT_1_16BIT;
+			qla2x00_async_event(ha, mbx);
+			break;
+		case 0x16:
+			mbx = mbx << 16 | MBA_SCSI_COMPLETION;
+			qla2x00_async_event(ha, mbx);
+			break;
+		default:
+			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
+			    "(%d)\n",
+			    ha->host_no, stat & 0xff));
+			break;
+		}
+		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
+		RD_REG_WORD_RELAXED(&reg->hccr);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	qla2x00_next(ha);
+	ha->last_irq_cpu = smp_processor_id();
+	ha->total_isr_cnt++;
+
+	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
+	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
+		spin_lock_irqsave(&ha->mbx_reg_lock, flags);
+
+		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		up(&ha->mbx_intr_sem);
+
+		spin_unlock_irqrestore(&ha->mbx_reg_lock, flags);
 	}
+
+	if (!list_empty(&ha->done_queue))
+		qla2x00_done(ha);
 
 	return (IRQ_HANDLED);
 }
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-09-06 12:07:52 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-09-06 12:07:52 -07:00
@@ -2063,8 +2063,13 @@
 	host->unique_id = ha->instance;
 	host->max_id = ha->max_targets;
 
-	if (request_irq(host->irq, qla2x00_intr_handler, SA_INTERRUPT|SA_SHIRQ,
-	    ha->brd_info->drv_name, ha)) {
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		ret = request_irq(host->irq, qla2100_intr_handler,
+		    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
+	else
+		ret = request_irq(host->irq, qla2300_intr_handler,
+		    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
+	if (ret != 0) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
 		    host->irq);
