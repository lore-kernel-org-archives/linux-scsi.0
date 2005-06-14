From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/11]  qla2xxx: ISP24xx ISR routines.
Date: Mon, 13 Jun 2005 22:32:12 -0700 (PDT)
Message-ID: <20050614053212.12127.18682.sendpatchset@plap.qlogic.com>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:46486 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261210AbVFNFcN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 01:32:13 -0400
In-Reply-To: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ISP24xx ISR routines.

Add appropriate glue-code for ISP24xx support -- this
included generalizing some of the core handling
routines (qla2x00_async_event() [pull-up retrieval of
mailbox values] and qla2x00_status_entry()].  Fixup
2100/2300 ISRs to handle the new conventions.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_gbl.h    |    1 
 drivers/scsi/qla2xxx/qla_inline.h |   29 +-
 drivers/scsi/qla2xxx/qla_isr.c    |  577 ++++++++++++++++++++++++++-----------
 3 files changed, 428 insertions(+), 179 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -193,6 +193,7 @@ qla2x00_set_serdes_params(scsi_qla_host_
  */
 extern irqreturn_t qla2100_intr_handler(int, void *, struct pt_regs *);
 extern irqreturn_t qla2300_intr_handler(int, void *, struct pt_regs *);
+extern irqreturn_t qla24xx_intr_handler(int, void *, struct pt_regs *);
 extern void qla2x00_process_response_queue(struct scsi_qla_host *);
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -119,8 +119,10 @@ qla2x00_poll(scsi_qla_host_t *ha)
 {
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		qla2100_intr_handler(0, ha, NULL);
-	else
+	else if (IS_QLA23XX(ha))
 		qla2300_intr_handler(0, ha, NULL);
+	else
+		qla24xx_intr_handler(0, ha, NULL);
 }
 
 
@@ -132,12 +134,18 @@ qla2x00_enable_intrs(scsi_qla_host_t *ha
 {
 	unsigned long flags = 0;
 	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_24xx __iomem *reg24;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		reg24 = (struct device_reg_24xx __iomem *)ha->iobase;
+		WRT_REG_DWORD(&reg24->ictrl, ICRX_EN_RISC_INT);
+		RD_REG_DWORD(&reg24->ictrl);
+	} else {
+		WRT_REG_WORD(&reg->ictrl, ICR_EN_INT | ICR_EN_RISC);
+		RD_REG_WORD(&reg->ictrl);
+	}
 	ha->interrupts_on = 1;
-	/* enable risc and host interrupts */
-	WRT_REG_WORD(&reg->ictrl, ICR_EN_INT | ICR_EN_RISC);
-	RD_REG_WORD(&reg->ictrl);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 }
@@ -147,12 +155,19 @@ qla2x00_disable_intrs(scsi_qla_host_t *h
 {
 	unsigned long flags = 0;
 	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_24xx __iomem *reg24;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->interrupts_on = 0;
-	/* disable risc and host interrupts */
-	WRT_REG_WORD(&reg->ictrl, 0);
-	RD_REG_WORD(&reg->ictrl);
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		reg24 = (struct device_reg_24xx __iomem *)ha->iobase;
+		WRT_REG_DWORD(&reg24->ictrl, 0);
+		RD_REG_DWORD(&reg24->ictrl);
+
+	} else {
+		WRT_REG_WORD(&reg->ictrl, 0);
+		RD_REG_WORD(&reg->ictrl);
+	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -19,14 +19,17 @@
 #include "qla_def.h"
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
-static void qla2x00_async_event(scsi_qla_host_t *, uint32_t);
+static void qla2x00_async_event(scsi_qla_host_t *, uint16_t *);
 static void qla2x00_process_completed_request(struct scsi_qla_host *, uint32_t);
 void qla2x00_process_response_queue(struct scsi_qla_host *);
-static void qla2x00_status_entry(scsi_qla_host_t *, sts_entry_t *);
+static void qla2x00_status_entry(scsi_qla_host_t *, void *);
 static void qla2x00_status_cont_entry(scsi_qla_host_t *, sts_cont_entry_t *);
 static void qla2x00_error_entry(scsi_qla_host_t *, sts_entry_t *);
 static void qla2x00_ms_entry(scsi_qla_host_t *, ms_iocb_entry_t *);
 
+void qla24xx_process_response_queue(scsi_qla_host_t *);
+static void qla24xx_ms_entry(scsi_qla_host_t *, struct ct_entry_24xx *);
+
 /**
  * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
  * @irq:
@@ -45,7 +48,7 @@ qla2100_intr_handler(int irq, void *dev_
 	int		status;
 	unsigned long	flags;
 	unsigned long	iter;
-	uint32_t	mbx;
+	uint16_t	mb[4];
 
 	ha = (scsi_qla_host_t *) dev_id;
 	if (!ha) {
@@ -67,17 +70,20 @@ qla2100_intr_handler(int irq, void *dev_
 			RD_REG_WORD(&reg->hccr);
 
 			/* Get mailbox data. */
-			mbx = RD_MAILBOX_REG(ha, reg, 0);
-			if (mbx > 0x3fff && mbx < 0x8000) {
-				qla2x00_mbx_completion(ha, (uint16_t)mbx);
+			mb[0] = RD_MAILBOX_REG(ha, reg, 0);
+			if (mb[0] > 0x3fff && mb[0] < 0x8000) {
+				qla2x00_mbx_completion(ha, mb[0]);
 				status |= MBX_INTERRUPT;
-			} else if (mbx > 0x7fff && mbx < 0xc000) {
-				qla2x00_async_event(ha, mbx);
+			} else if (mb[0] > 0x7fff && mb[0] < 0xc000) {
+				mb[1] = RD_MAILBOX_REG(ha, reg, 1);
+				mb[2] = RD_MAILBOX_REG(ha, reg, 2);
+				mb[3] = RD_MAILBOX_REG(ha, reg, 3);
+				qla2x00_async_event(ha, mb);
 			} else {
 				/*EMPTY*/
 				DEBUG2(printk("scsi(%ld): Unrecognized "
-				    "interrupt type (%d)\n",
-				    ha->host_no, mbx));
+				    "interrupt type (%d).\n",
+				    ha->host_no, mb[0]));
 			}
 			/* Release mailbox registers. */
 			WRT_REG_WORD(&reg->semaphore, 0);
@@ -123,8 +129,8 @@ qla2300_intr_handler(int irq, void *dev_
 	unsigned long	flags;
 	unsigned long	iter;
 	uint32_t	stat;
-	uint32_t	mbx;
 	uint16_t	hccr;
+	uint16_t	mb[4];
 
 	ha = (scsi_qla_host_t *) dev_id;
 	if (!ha) {
@@ -146,7 +152,7 @@ qla2300_intr_handler(int irq, void *dev_
 				    "Parity error -- HCCR=%x.\n", hccr);
 			else
 				qla_printk(KERN_INFO, ha,
-				    "RISC paused -- HCCR=%x\n", hccr);
+				    "RISC paused -- HCCR=%x.\n", hccr);
 
 			/*
 			 * Issue a "HARD" reset in order for the RISC
@@ -160,35 +166,41 @@ qla2300_intr_handler(int irq, void *dev_
 		} else if ((stat & HSR_RISC_INT) == 0)
 			break;
 
-		mbx = MSW(stat);
 		switch (stat & 0xff) {
-		case 0x13:
-			qla2x00_process_response_queue(ha);
-			break;
 		case 0x1:
 		case 0x2:
 		case 0x10:
 		case 0x11:
-			qla2x00_mbx_completion(ha, (uint16_t)mbx);
+			qla2x00_mbx_completion(ha, MSW(stat));
 			status |= MBX_INTERRUPT;
 
 			/* Release mailbox registers. */
 			WRT_REG_WORD(&reg->semaphore, 0);
 			break;
 		case 0x12:
-			qla2x00_async_event(ha, mbx);
+			mb[0] = MSW(stat);
+			mb[1] = RD_MAILBOX_REG(ha, reg, 1);
+			mb[2] = RD_MAILBOX_REG(ha, reg, 2);
+			mb[3] = RD_MAILBOX_REG(ha, reg, 3);
+			qla2x00_async_event(ha, mb);
+			break;
+		case 0x13:
+			qla2x00_process_response_queue(ha);
 			break;
 		case 0x15:
-			mbx = mbx << 16 | MBA_CMPLT_1_16BIT;
-			qla2x00_async_event(ha, mbx);
+			mb[0] = MBA_CMPLT_1_16BIT;
+			mb[1] = MSW(stat);
+			qla2x00_async_event(ha, mb);
 			break;
 		case 0x16:
-			mbx = mbx << 16 | MBA_SCSI_COMPLETION;
-			qla2x00_async_event(ha, mbx);
+			mb[0] = MBA_SCSI_COMPLETION;
+			mb[1] = MSW(stat);
+			mb[2] = RD_MAILBOX_REG(ha, reg, 2);
+			qla2x00_async_event(ha, mb);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
-			    "(%d)\n",
+			    "(%d).\n",
 			    ha->host_no, stat & 0xff));
 			break;
 		}
@@ -221,16 +233,22 @@ qla2x00_mbx_completion(scsi_qla_host_t *
 	uint16_t	cnt;
 	uint16_t __iomem *wptr;
 	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_24xx __iomem *reg24 =
+	    (struct device_reg_24xx __iomem *)ha->iobase;
 
 	/* Load return mailbox registers. */
 	ha->flags.mbox_int = 1;
 	ha->mailbox_out[0] = mb0;
-	wptr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 1);
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		wptr = (uint16_t __iomem *)&reg24->mailbox1;
+	else
+		wptr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 1);
 
 	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
 		if (IS_QLA2200(ha) && cnt == 8) 
 			wptr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 8);
-		if (cnt == 4 || cnt == 5)
+		if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha) && (cnt == 4 ||
+		    cnt == 5))
 			ha->mailbox_out[cnt] = qla2x00_debounce_register(wptr);
 		else
 			ha->mailbox_out[cnt] = RD_REG_WORD(wptr);
@@ -250,14 +268,14 @@ qla2x00_mbx_completion(scsi_qla_host_t *
 /**
  * qla2x00_async_event() - Process aynchronous events.
  * @ha: SCSI driver HA context
- * @mb0: Mailbox0 register
+ * @mb: Mailbox registers (0 - 3)
  */
 static void
-qla2x00_async_event(scsi_qla_host_t *ha, uint32_t mbx)
+qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 {
-	static char	*link_speeds[5] = { "1", "2", "4", "?", "10" };
+#define LS_UNKNOWN	2
+	static char	*link_speeds[5] = { "1", "2", "?", "4", "10" };
 	char		*link_speed;
-	uint16_t	mb[4];
 	uint16_t	handle_cnt;
 	uint16_t	cnt;
 	uint32_t	handles[5];
@@ -267,61 +285,48 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;
-	mb[0] = LSW(mbx);
 	switch (mb[0]) {
 	case MBA_SCSI_COMPLETION:
-		if (IS_QLA2100(ha) || IS_QLA2200(ha))
-			handles[0] = le32_to_cpu(
-			    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 2) << 16)) |
-			    RD_MAILBOX_REG(ha, reg, 1));
-		else
-			handles[0] = le32_to_cpu(
-			    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 2) << 16)) |
-			    MSW(mbx));
+		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
 		handle_cnt = 1;
 		break;
 	case MBA_CMPLT_1_16BIT:
-		if (IS_QLA2100(ha) || IS_QLA2200(ha))
-			handles[0] = (uint32_t)RD_MAILBOX_REG(ha, reg, 1);
-		else
-			handles[0] = MSW(mbx);
+		handles[0] = mb[1];
 		handle_cnt = 1;
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
 	case MBA_CMPLT_2_16BIT:
-		handles[0] = (uint32_t)RD_MAILBOX_REG(ha, reg, 1);
-		handles[1] = (uint32_t)RD_MAILBOX_REG(ha, reg, 2);
+		handles[0] = mb[1];
+		handles[1] = mb[2];
 		handle_cnt = 2;
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
 	case MBA_CMPLT_3_16BIT:
-		handles[0] = (uint32_t)RD_MAILBOX_REG(ha, reg, 1);
-		handles[1] = (uint32_t)RD_MAILBOX_REG(ha, reg, 2);
-		handles[2] = (uint32_t)RD_MAILBOX_REG(ha, reg, 3);
+		handles[0] = mb[1];
+		handles[1] = mb[2];
+		handles[2] = mb[3];
 		handle_cnt = 3;
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
 	case MBA_CMPLT_4_16BIT:
-		handles[0] = (uint32_t)RD_MAILBOX_REG(ha, reg, 1);
-		handles[1] = (uint32_t)RD_MAILBOX_REG(ha, reg, 2);
-		handles[2] = (uint32_t)RD_MAILBOX_REG(ha, reg, 3);
+		handles[0] = mb[1];
+		handles[1] = mb[2];
+		handles[2] = mb[3];
 		handles[3] = (uint32_t)RD_MAILBOX_REG(ha, reg, 6);
 		handle_cnt = 4;
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
 	case MBA_CMPLT_5_16BIT:
-		handles[0] = (uint32_t)RD_MAILBOX_REG(ha, reg, 1);
-		handles[1] = (uint32_t)RD_MAILBOX_REG(ha, reg, 2);
-		handles[2] = (uint32_t)RD_MAILBOX_REG(ha, reg, 3);
+		handles[0] = mb[1];
+		handles[1] = mb[2];
+		handles[2] = mb[3];
 		handles[3] = (uint32_t)RD_MAILBOX_REG(ha, reg, 6);
 		handles[4] = (uint32_t)RD_MAILBOX_REG(ha, reg, 7);
 		handle_cnt = 5;
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
 	case MBA_CMPLT_2_32BIT:
-		handles[0] = le32_to_cpu(
-		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 2) << 16)) |
-		    RD_MAILBOX_REG(ha, reg, 1));
+		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
 		handles[1] = le32_to_cpu(
 		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 7) << 16)) |
 		    RD_MAILBOX_REG(ha, reg, 6));
@@ -348,21 +353,27 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		break;
 
 	case MBA_SYSTEM_ERR:		/* System Error */
-		mb[1] = RD_MAILBOX_REG(ha, reg, 1);
-		mb[2] = RD_MAILBOX_REG(ha, reg, 2);
-		mb[3] = RD_MAILBOX_REG(ha, reg, 3);
-
 		qla_printk(KERN_INFO, ha,
 		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n",
 		    mb[1], mb[2], mb[3]);
 
 		if (IS_QLA2100(ha) || IS_QLA2200(ha))
 			qla2100_fw_dump(ha, 1);
-		else
+		else if (IS_QLA23XX(ha))
 	    		qla2300_fw_dump(ha, 1);
+		else if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			qla24xx_fw_dump(ha, 1);
 
-		if (mb[1] == 0) {
-			qla_printk(KERN_INFO, ha,
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+			if (mb[1] == 0 && mb[2] == 0) {
+				qla_printk(KERN_ERR, ha,
+				    "Unrecoverable Hardware Error: adapter "
+				    "marked OFFLINE!\n");
+				ha->flags.online = 0;
+			} else
+				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		} else if (mb[1] == 0) {
+			qla_printk(KERN_ERR, ha,
 			    "Unrecoverable Hardware Error: adapter marked "
 			    "OFFLINE!\n");
 			ha->flags.online = 0;
@@ -392,8 +403,6 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		break;
 
 	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
-		mb[1] = RD_MAILBOX_REG(ha, reg, 1);
-
 		DEBUG2(printk("scsi(%ld): LIP occured (%x).\n", ha->host_no,
 		    mb[1]));
 		qla_printk(KERN_INFO, ha, "LIP occured (%x).\n", mb[1]);
@@ -414,13 +423,11 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		break;
 
 	case MBA_LOOP_UP:		/* Loop Up Event */
-		mb[1] = RD_MAILBOX_REG(ha, reg, 1);
-
 		ha->link_data_rate = 0;
 		if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 			link_speed = link_speeds[0];
 		} else {
-			link_speed = link_speeds[3];
+			link_speed = link_speeds[LS_UNKNOWN];
 			if (mb[1] < 5)
 				link_speed = link_speeds[mb[1]];
 			ha->link_data_rate = mb[1];
@@ -438,9 +445,9 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		break;
 
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
-		DEBUG2(printk("scsi(%ld): Asynchronous LOOP DOWN.\n",
-		    ha->host_no));
-		qla_printk(KERN_INFO, ha, "LOOP DOWN detected.\n");
+		DEBUG2(printk("scsi(%ld): Asynchronous LOOP DOWN (%x).\n",
+		    ha->host_no, mb[1]));
+		qla_printk(KERN_INFO, ha, "LOOP DOWN detected (%x).\n", mb[1]);
 
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
 			atomic_set(&ha->loop_state, LOOP_DOWN);
@@ -457,8 +464,6 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		break;
 
 	case MBA_LIP_RESET:		/* LIP reset occurred */
-		mb[1] = RD_MAILBOX_REG(ha, reg, 1);
-
 		DEBUG2(printk("scsi(%ld): Asynchronous LIP RESET (%x).\n",
 		    ha->host_no, mb[1]));
 		qla_printk(KERN_INFO, ha,
@@ -509,8 +514,6 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		if (IS_QLA2100(ha))
 			break;
 
-		mb[1] = RD_MAILBOX_REG(ha, reg, 1);
-
 		DEBUG2(printk("scsi(%ld): Asynchronous Change In Connection "
 		    "received.\n",
 		    ha->host_no));
@@ -530,16 +533,14 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		break;
 
 	case MBA_PORT_UPDATE:		/* Port database update */
-		mb[1] = RD_MAILBOX_REG(ha, reg, 1);
-		mb[2] = RD_MAILBOX_REG(ha, reg, 2);
-
 		/*
 		 * If a single remote port just logged into (or logged out of)
 		 * us, create a new entry in our rscn fcports list and handle
 		 * the event like an RSCN.
 		 */
 		if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA6312(ha) &&
-		    !IS_QLA6322(ha) && ha->flags.init_done && mb[1] != 0xffff &&
+		    !IS_QLA6322(ha) && !IS_QLA24XX(ha) && !IS_QLA25XX(ha) &&
+		    ha->flags.init_done && mb[1] != 0xffff &&
 		    ((ha->operating_mode == P2P && mb[1] != 0) ||
 		    (ha->operating_mode != P2P && mb[1] !=
 			SNS_FIRST_LOOP_ID)) && (mb[2] == 6 || mb[2] == 7)) {
@@ -550,8 +551,9 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 			rscn_fcport = qla2x00_alloc_rscn_fcport(ha, GFP_ATOMIC);
 			if (rscn_fcport) {
 				DEBUG14(printk("scsi(%ld): Port Update -- "
-				    "creating RSCN fcport %p for %x/%x.\n",
-				    ha->host_no, rscn_fcport, mb[1], mb[2]));
+				    "creating RSCN fcport %p for %x/%x/%x.\n",
+				    ha->host_no, rscn_fcport, mb[1], mb[2],
+				    mb[3]));
 
 				rscn_fcport->loop_id = mb[1];
 				rscn_fcport->d_id.b24 = INVALID_PORT_ID;
@@ -580,15 +582,16 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN &&
 		    atomic_read(&ha->loop_state) != LOOP_DEAD) {
 			DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE "
-			    "ignored.\n", ha->host_no));
+			    "ignored %04x/%04x/%04x.\n", ha->host_no, mb[1],
+			    mb[2], mb[3]));
 			break;
 		}
 
 		DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE.\n",
 		    ha->host_no));
 		DEBUG(printk(KERN_INFO
-		    "scsi(%ld): Port database changed %04x %04x.\n",
-		    ha->host_no, mb[1], mb[2]));
+		    "scsi(%ld): Port database changed %04x %04x %04x.\n",
+		    ha->host_no, mb[1], mb[2], mb[3]));
 
 		/*
 		 * Mark all devices as missing so we will login again.
@@ -607,9 +610,6 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
-		mb[1] = RD_MAILBOX_REG(ha, reg, 1);
-		mb[2] = RD_MAILBOX_REG(ha, reg, 2);
-
 		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
 		    ha->host_no));
 		DEBUG(printk(KERN_INFO
@@ -658,6 +658,11 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 
 		qla2x00_process_response_queue(ha);
 		break;
+
+	case MBA_DISCARD_RND_FRAME:
+		DEBUG2(printk("scsi(%ld): Discard RND Frame -- %04x %04x "
+		    "%04x.\n", ha->host_no, mb[1], mb[2], mb[3]));
+		break;
 	}
 }
 
@@ -804,31 +809,41 @@ qla2x00_process_response_queue(struct sc
  * @pkt: Entry pointer
  */
 static void
-qla2x00_status_entry(scsi_qla_host_t *ha, sts_entry_t *pkt)
+qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 {
-	unsigned	b, t, l;
 	srb_t		*sp;
 	fc_port_t	*fcport;
 	struct scsi_cmnd *cp;
+	sts_entry_t *sts;
+	struct sts_entry_24xx *sts24;
 	uint16_t	comp_status;
 	uint16_t	scsi_status;
 	uint8_t		lscsi_status;
 	int32_t		resid;
-	uint8_t		sense_sz = 0;
-	uint16_t	rsp_info_len;
+	uint32_t	sense_len, rsp_info_len, resid_len;
+	uint8_t		*rsp_info, *sense_data;
+
+	sts = (sts_entry_t *) pkt;
+	sts24 = (struct sts_entry_24xx *) pkt;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		comp_status = le16_to_cpu(sts24->comp_status);
+		scsi_status = le16_to_cpu(sts24->scsi_status) & SS_MASK;
+	} else {
+		comp_status = le16_to_cpu(sts->comp_status);
+		scsi_status = le16_to_cpu(sts->scsi_status) & SS_MASK;
+	}
 
 	/* Fast path completion. */
-	if (le16_to_cpu(pkt->comp_status) == CS_COMPLETE &&
-	    (le16_to_cpu(pkt->scsi_status) & SS_MASK) == 0) {
-		qla2x00_process_completed_request(ha, pkt->handle);
+	if (comp_status == CS_COMPLETE && scsi_status == 0) {
+		qla2x00_process_completed_request(ha, sts->handle);
 
 		return;
 	}
 
 	/* Validate handle. */
-	if (pkt->handle < MAX_OUTSTANDING_COMMANDS) {
-		sp = ha->outstanding_cmds[pkt->handle];
-		ha->outstanding_cmds[pkt->handle] = NULL;
+	if (sts->handle < MAX_OUTSTANDING_COMMANDS) {
+		sp = ha->outstanding_cmds[sts->handle];
+		ha->outstanding_cmds[sts->handle] = NULL;
 	} else
 		sp = NULL;
 
@@ -847,40 +862,49 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	if (cp == NULL) {
 		DEBUG2(printk("scsi(%ld): Command already returned back to OS "
 		    "pkt->handle=%d sp=%p sp->state:%d\n",
-		    ha->host_no, pkt->handle, sp, sp->state));
+		    ha->host_no, sts->handle, sp, sp->state));
 		qla_printk(KERN_WARNING, ha,
 		    "Command is NULL: already returned to OS (sp=%p)\n", sp);
 
 		return;
 	}
 
-	comp_status = le16_to_cpu(pkt->comp_status);
-	/* Mask of reserved bits 12-15, before we examine the scsi status */
-	scsi_status = le16_to_cpu(pkt->scsi_status) & SS_MASK;
-	lscsi_status = scsi_status & STATUS_MASK;
-
-	CMD_ENTRY_STATUS(cp) = pkt->entry_status;
+  	lscsi_status = scsi_status & STATUS_MASK;
+	CMD_ENTRY_STATUS(cp) = sts->entry_status;
 	CMD_COMPL_STATUS(cp) = comp_status;
 	CMD_SCSI_STATUS(cp) = scsi_status;
 
-	/* Generate LU queue on cntrl, target, LUN */
-	b = cp->device->channel;
-	t = cp->device->id;
-	l = cp->device->lun,
-
 	fcport = sp->fcport;
 
+	sense_len = rsp_info_len = resid_len = 0;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		sense_len = le32_to_cpu(sts24->sense_len);
+		rsp_info_len = le32_to_cpu(sts24->rsp_data_len);
+		resid_len = le32_to_cpu(sts24->rsp_residual_count);
+		rsp_info = sts24->data;
+		sense_data = sts24->data;
+		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
+	} else {
+		sense_len = le16_to_cpu(sts->req_sense_length);
+		rsp_info_len = le16_to_cpu(sts->rsp_info_len);
+		resid_len = le32_to_cpu(sts->residual_length);
+		rsp_info = sts->rsp_info;
+		sense_data = sts->req_sense_data;
+	}
+
 	/* Check for any FCP transport errors. */
 	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
-		rsp_info_len = le16_to_cpu(pkt->rsp_info_len);
-		if (rsp_info_len > 3 && pkt->rsp_info[3]) {
+		/* Sense data lies beyond any FCP RESPONSE data. */
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			sense_data += rsp_info_len;
+		if (rsp_info_len > 3 && rsp_info[3]) {
 			DEBUG2(printk("scsi(%ld:%d:%d:%d) FCP I/O protocol "
 			    "failure (%x/%02x%02x%02x%02x%02x%02x%02x%02x)..."
-			    "retrying command\n", ha->host_no, b, t, l,
-			    rsp_info_len, pkt->rsp_info[0], pkt->rsp_info[1],
-			    pkt->rsp_info[2], pkt->rsp_info[3],
-			    pkt->rsp_info[4], pkt->rsp_info[5],
-			    pkt->rsp_info[6], pkt->rsp_info[7]));
+			    "retrying command\n", ha->host_no,
+			    cp->device->channel, cp->device->id,
+			    cp->device->lun, rsp_info_len, rsp_info[0],
+			    rsp_info[1], rsp_info[2], rsp_info[3], rsp_info[4],
+			    rsp_info[5], rsp_info[6], rsp_info[7]));
 
 			cp->result = DID_BUS_BUSY << 16;
 			qla2x00_sp_compl(ha, sp);
@@ -898,7 +922,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			break;
 		}
 		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER)) {
-			resid = le32_to_cpu(pkt->residual_length);
+			resid = resid_len;
 			cp->resid = resid;
 			CMD_RESID_LEN(cp) = resid;
 		}
@@ -907,39 +931,34 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		if (lscsi_status != SS_CHECK_CONDITION)
 			break;
 
-		/*
-		 * Copy Sense Data into sense buffer
-		 */
+		/* Copy Sense Data into sense buffer. */
 		memset(cp->sense_buffer, 0, sizeof(cp->sense_buffer));
 
 		if (!(scsi_status & SS_SENSE_LEN_VALID))
 			break;
 
-		if (le16_to_cpu(pkt->req_sense_length) <
-		    sizeof(cp->sense_buffer))
-			sense_sz = le16_to_cpu(pkt->req_sense_length);
-		else
-			sense_sz = sizeof(cp->sense_buffer);
+		if (sense_len >= sizeof(cp->sense_buffer))
+			sense_len = sizeof(cp->sense_buffer);
 
-		CMD_ACTUAL_SNSLEN(cp) = sense_sz;
-		sp->request_sense_length = sense_sz;
+		CMD_ACTUAL_SNSLEN(cp) = sense_len;
+		sp->request_sense_length = sense_len;
 		sp->request_sense_ptr = cp->sense_buffer;
 
 		if (sp->request_sense_length > 32)
-			sense_sz = 32;
+			sense_len = 32;
 
-		memcpy(cp->sense_buffer, pkt->req_sense_data, sense_sz);
+		memcpy(cp->sense_buffer, sense_data, sense_len);
 
-		sp->request_sense_ptr += sense_sz;
-		sp->request_sense_length -= sense_sz;
+		sp->request_sense_ptr += sense_len;
+		sp->request_sense_length -= sense_len;
 		if (sp->request_sense_length != 0)
 			ha->status_srb = sp;
 
 		DEBUG5(printk("%s(): Check condition Sense data, "
-		    "scsi(%ld:%d:%d:%d) cmd=%p pid=%ld\n",
-		    __func__, ha->host_no, b, t, l, cp,
-		    cp->serial_number));
-		if (sense_sz)
+		    "scsi(%ld:%d:%d:%d) cmd=%p pid=%ld\n", __func__,
+		    ha->host_no, cp->device->channel, cp->device->id,
+		    cp->device->lun, cp, cp->serial_number));
+		if (sense_len)
 			DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
 			    CMD_ACTUAL_SNSLEN(cp)));
 		break;
@@ -947,9 +966,10 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	case CS_DATA_UNDERRUN:
 		DEBUG2(printk(KERN_INFO
 		    "scsi(%ld:%d:%d) UNDERRUN status detected 0x%x-0x%x.\n",
-		    ha->host_no, t, l, comp_status, scsi_status));
+		    ha->host_no, cp->device->id, cp->device->lun, comp_status,
+		    scsi_status));
 
-		resid = le32_to_cpu(pkt->residual_length);
+		resid = resid_len;
 		if (scsi_status & SS_RESIDUAL_UNDER) {
 			cp->resid = resid;
 			CMD_RESID_LEN(cp) = resid;
@@ -971,31 +991,30 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			if (!(scsi_status & SS_SENSE_LEN_VALID))
 				break;
 
-			if (le16_to_cpu(pkt->req_sense_length) <
-			    sizeof(cp->sense_buffer))
-				sense_sz = le16_to_cpu(pkt->req_sense_length);
-			else
-				sense_sz = sizeof(cp->sense_buffer);
+			if (sense_len >= sizeof(cp->sense_buffer))
+				sense_len = sizeof(cp->sense_buffer);
 
-			CMD_ACTUAL_SNSLEN(cp) = sense_sz;
-			sp->request_sense_length = sense_sz;
+			CMD_ACTUAL_SNSLEN(cp) = sense_len;
+			sp->request_sense_length = sense_len;
 			sp->request_sense_ptr = cp->sense_buffer;
 
 			if (sp->request_sense_length > 32) 
-				sense_sz = 32;
+				sense_len = 32;
 
-			memcpy(cp->sense_buffer, pkt->req_sense_data, sense_sz);
+			memcpy(cp->sense_buffer, sense_data, sense_len);
 
-			sp->request_sense_ptr += sense_sz;
-			sp->request_sense_length -= sense_sz;
+			sp->request_sense_ptr += sense_len;
+			sp->request_sense_length -= sense_len;
 			if (sp->request_sense_length != 0)
 				ha->status_srb = sp;
 
 			DEBUG5(printk("%s(): Check condition Sense data, "
 			    "scsi(%ld:%d:%d:%d) cmd=%p pid=%ld\n",
-			    __func__, ha->host_no, b, t, l, cp,
+			    __func__, ha->host_no, cp->device->channel,
+			    cp->device->id, cp->device->lun, cp,
 			    cp->serial_number));
-			if (sense_sz)
+
+			if (sense_len)
 				DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
 				    CMD_ACTUAL_SNSLEN(cp)));
 		} else {
@@ -1007,8 +1026,9 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			if (!(scsi_status & SS_RESIDUAL_UNDER)) {
 				DEBUG2(printk("scsi(%ld:%d:%d:%d) Dropped "
 				    "frame(s) detected (%x of %x bytes)..."
-				    "retrying command.\n",
-				    ha->host_no, b, t, l, resid,
+				    "retrying command.\n", ha->host_no,
+				    cp->device->channel, cp->device->id,
+				    cp->device->lun, resid,
 				    cp->request_bufflen));
 
 				cp->result = DID_BUS_BUSY << 16;
@@ -1021,8 +1041,9 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 				qla_printk(KERN_INFO, ha,
 				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
 				    "detected (%x of %x bytes)...returning "
-				    "error status.\n",
-				    ha->host_no, b, t, l, resid,
+				    "error status.\n", ha->host_no,
+				    cp->device->channel, cp->device->id,
+				    cp->device->lun, resid,
 				    cp->request_bufflen);
 
 				cp->result = DID_ERROR << 16;
@@ -1037,7 +1058,8 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	case CS_DATA_OVERRUN:
 		DEBUG2(printk(KERN_INFO
 		    "scsi(%ld:%d:%d): OVERRUN status detected 0x%x-0x%x\n",
-		    ha->host_no, t, l, comp_status, scsi_status));
+		    ha->host_no, cp->device->id, cp->device->lun, comp_status,
+		    scsi_status));
 		DEBUG2(printk(KERN_INFO
 		    "CDB: 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
 		    cp->cmnd[0], cp->cmnd[1], cp->cmnd[2], cp->cmnd[3],
@@ -1045,8 +1067,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		DEBUG2(printk(KERN_INFO
 		    "PID=0x%lx req=0x%x xtra=0x%x -- returning DID_ERROR "
 		    "status!\n",
-		    cp->serial_number, cp->request_bufflen,
-		    le32_to_cpu(pkt->residual_length)));
+		    cp->serial_number, cp->request_bufflen, resid_len));
 
 		cp->result = DID_ERROR << 16;
 		break;
@@ -1063,7 +1084,8 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		 */
 		DEBUG2(printk("scsi(%ld:%d:%d): status_entry: Port Down "
 		    "pid=%ld, compl status=0x%x, port state=0x%x\n",
-		    ha->host_no, t, l, cp->serial_number, comp_status,
+		    ha->host_no, cp->device->id, cp->device->lun,
+		    cp->serial_number, comp_status,
 		    atomic_read(&fcport->state)));
 
 		cp->result = DID_BUS_BUSY << 16;
@@ -1094,17 +1116,25 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		break;
 
 	case CS_TIMEOUT:
+		cp->result = DID_BUS_BUSY << 16;
+
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+			DEBUG2(printk(KERN_INFO
+			    "scsi(%ld:%d:%d:%d): TIMEOUT status detected "
+			    "0x%x-0x%x\n", ha->host_no, cp->device->channel,
+			    cp->device->id, cp->device->lun, comp_status,
+			    scsi_status));
+			break;
+		}
 		DEBUG2(printk(KERN_INFO
 		    "scsi(%ld:%d:%d:%d): TIMEOUT status detected 0x%x-0x%x "
-		    "sflags=%x.\n", ha->host_no, b, t, l, comp_status,
-		    scsi_status, le16_to_cpu(pkt->status_flags)));
+		    "sflags=%x.\n", ha->host_no, cp->device->channel,
+		    cp->device->id, cp->device->lun, comp_status, scsi_status,
+		    le16_to_cpu(sts->status_flags)));
 
-		cp->result = DID_BUS_BUSY << 16;
-
-		/* Check to see if logout occurred */
-		if ((le16_to_cpu(pkt->status_flags) & SF_LOGOUT_SENT)) {
+		/* Check to see if logout occurred. */
+		if ((le16_to_cpu(sts->status_flags) & SF_LOGOUT_SENT))
 			qla2x00_mark_device_lost(ha, fcport, 1);
-		}
 		break;
 
 	case CS_QUEUE_FULL:
@@ -1120,8 +1150,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 
 	default:
 		DEBUG3(printk("scsi(%ld): Error detected (unknown status) "
-		    "0x%x-0x%x.\n",
-		    ha->host_no, comp_status, scsi_status));
+		    "0x%x-0x%x.\n", ha->host_no, comp_status, scsi_status));
 		qla_printk(KERN_INFO, ha,
 		    "Unknown status detected 0x%x-0x%x.\n",
 		    comp_status, scsi_status);
@@ -1169,6 +1198,8 @@ qla2x00_status_cont_entry(scsi_qla_host_
 		}
 
 		/* Move sense data. */
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			host_to_fcp_swap(pkt->data, sizeof(pkt->data));
 		memcpy(sp->request_sense_ptr, pkt->data, sense_sz);
 		DEBUG5(qla2x00_dump_buffer(sp->request_sense_ptr, sense_sz));
 
@@ -1189,7 +1220,7 @@ qla2x00_status_cont_entry(scsi_qla_host_
  * @pkt: Entry pointer
  */
 static void
-qla2x00_error_entry(scsi_qla_host_t *ha, sts_entry_t *pkt) 
+qla2x00_error_entry(scsi_qla_host_t *ha, sts_entry_t *pkt)
 {
 	srb_t *sp;
 
@@ -1231,15 +1262,15 @@ qla2x00_error_entry(scsi_qla_host_t *ha,
 		}
 		qla2x00_sp_compl(ha, sp);
 
-	} else if (pkt->entry_type == COMMAND_A64_TYPE ||
-	    pkt->entry_type == COMMAND_TYPE) {
+	} else if (pkt->entry_type == COMMAND_A64_TYPE || pkt->entry_type ==
+	    COMMAND_TYPE || pkt->entry_type == COMMAND_TYPE_7) {
 		DEBUG2(printk("scsi(%ld): Error entry - invalid handle\n",
 		    ha->host_no));
 		qla_printk(KERN_WARNING, ha,
 		    "Error entry - invalid handle\n");
 
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		if (ha->dpc_wait && !ha->dpc_active) 
+		if (ha->dpc_wait && !ha->dpc_active)
 			up(ha->dpc_wait);
 	}
 }
@@ -1250,7 +1281,7 @@ qla2x00_error_entry(scsi_qla_host_t *ha,
  * @index: Response queue out pointer
  */
 static void
-qla2x00_ms_entry(scsi_qla_host_t *ha, ms_iocb_entry_t *pkt) 
+qla2x00_ms_entry(scsi_qla_host_t *ha, ms_iocb_entry_t *pkt)
 {
 	srb_t          *sp;
 
@@ -1280,3 +1311,205 @@ qla2x00_ms_entry(scsi_qla_host_t *ha, ms
 
 	qla2x00_sp_compl(ha, sp);
 }
+
+// ISP24xx
+//
+/*****************************************************************************/
+/* qla_isr.c additions                                                       */
+/*****************************************************************************/
+
+/**
+ * qla24xx_process_response_queue() - Process response queue entries.
+ * @ha: SCSI driver HA context
+ */
+void
+qla24xx_process_response_queue(struct scsi_qla_host *ha)
+{
+	struct device_reg_24xx __iomem *reg;
+	struct sts_entry_24xx *pkt;
+
+	if (!ha->flags.online)
+		return;
+
+	reg = (struct device_reg_24xx __iomem *)ha->iobase;
+	while (ha->response_ring_ptr->signature != RESPONSE_PROCESSED) {
+		pkt = (struct sts_entry_24xx *)ha->response_ring_ptr;
+
+		ha->rsp_ring_index++;
+		if (ha->rsp_ring_index == ha->response_q_length) {
+			ha->rsp_ring_index = 0;
+			ha->response_ring_ptr = ha->response_ring;
+		} else {
+			ha->response_ring_ptr++;
+		}
+
+		if (pkt->entry_status != 0) {
+			DEBUG3(printk(KERN_INFO
+			    "scsi(%ld): Process error entry.\n", ha->host_no));
+
+			//FIXME
+			qla2x00_error_entry(ha, (sts_entry_t *) pkt);
+			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
+			wmb();
+			continue;
+		}
+
+		switch (pkt->entry_type) {
+		case STATUS_TYPE:
+			qla2x00_status_entry(ha, pkt);
+			break;
+		case STATUS_CONT_TYPE:
+			qla2x00_status_cont_entry(ha, (sts_cont_entry_t *)pkt);
+			break;
+		case MS_IOCB_TYPE:
+			qla24xx_ms_entry(ha, (struct ct_entry_24xx *)pkt);
+			break;
+		default:
+			/* Type Not Supported. */
+			DEBUG4(printk(KERN_WARNING
+			    "scsi(%ld): Received unknown response pkt type %x "
+			    "entry status=%x.\n",
+			    ha->host_no, pkt->entry_type, pkt->entry_status));
+			break;
+		}
+		((response_t *)pkt)->signature = RESPONSE_PROCESSED;
+		wmb();
+	}
+
+	/* Adjust ring index */
+	WRT_REG_DWORD(&reg->rsp_q_out, ha->rsp_ring_index);
+}
+
+/**
+ * qla24xx_intr_handler() - Process interrupts for the ISP23xx and ISP63xx.
+ * @irq:
+ * @dev_id: SCSI driver HA context
+ * @regs:
+ *
+ * Called by system whenever the host adapter generates an interrupt.
+ *
+ * Returns handled flag.
+ */
+irqreturn_t
+qla24xx_intr_handler(int irq, void *dev_id, struct pt_regs *regs)
+{
+	scsi_qla_host_t	*ha;
+	struct device_reg_24xx __iomem *reg;
+	int		status;
+	unsigned long	flags;
+	unsigned long	iter;
+	uint32_t	stat;
+	uint32_t	hccr;
+	uint16_t	mb[4];
+
+	ha = (scsi_qla_host_t *) dev_id;
+	if (!ha) {
+		printk(KERN_INFO
+		    "%s(): NULL host pointer\n", __func__);
+		return IRQ_NONE;
+	}
+
+	reg = (struct device_reg_24xx __iomem *)ha->iobase;
+	status = 0;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (iter = 50; iter--; ) {
+		stat = RD_REG_DWORD(&reg->host_status);
+		if (stat & HSRX_RISC_PAUSED) {
+			hccr = RD_REG_DWORD(&reg->hccr);
+
+			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
+			    "Dumping firmware!\n", hccr);
+			qla24xx_fw_dump(ha, 1);
+
+			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			break;
+		} else if ((stat & HSRX_RISC_INT) == 0)
+			break;
+
+		switch (stat & 0xff) {
+		case 0x1:
+		case 0x2:
+		case 0x10:
+		case 0x11:
+			qla2x00_mbx_completion(ha, MSW(stat));
+			status |= MBX_INTERRUPT;
+
+			break;
+		case 0x12:
+			mb[0] = MSW(stat);
+			mb[1] = RD_REG_WORD(&reg->mailbox1);
+			mb[2] = RD_REG_WORD(&reg->mailbox2);
+			mb[3] = RD_REG_WORD(&reg->mailbox3);
+			qla2x00_async_event(ha, mb);
+			break;
+		case 0x13:
+			qla24xx_process_response_queue(ha);
+			break;
+		default:
+			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
+			    "(%d).\n",
+			    ha->host_no, stat & 0xff));
+			break;
+		}
+		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+		RD_REG_DWORD_RELAXED(&reg->hccr);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
+	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
+		spin_lock_irqsave(&ha->mbx_reg_lock, flags);
+
+		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		up(&ha->mbx_intr_sem);
+
+		spin_unlock_irqrestore(&ha->mbx_reg_lock, flags);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * qla24xx_ms_entry() - Process a Management Server entry.
+ * @ha: SCSI driver HA context
+ * @index: Response queue out pointer
+ */
+static void
+qla24xx_ms_entry(scsi_qla_host_t *ha, struct ct_entry_24xx *pkt)
+{
+	srb_t          *sp;
+
+	DEBUG3(printk("%s(%ld): pkt=%p pkthandle=%d.\n",
+	    __func__, ha->host_no, pkt, pkt->handle));
+
+	DEBUG9(printk("%s: ct pkt dump:\n", __func__);)
+	DEBUG9(qla2x00_dump_buffer((void *)pkt, sizeof(struct ct_entry_24xx));)
+
+	/* Validate handle. */
+ 	if (pkt->handle < MAX_OUTSTANDING_COMMANDS)
+ 		sp = ha->outstanding_cmds[pkt->handle];
+	else
+		sp = NULL;
+
+	if (sp == NULL) {
+		DEBUG2(printk("scsi(%ld): MS entry - invalid handle\n",
+		    ha->host_no));
+		DEBUG10(printk("scsi(%ld): MS entry - invalid handle\n",
+		    ha->host_no));
+		qla_printk(KERN_WARNING, ha, "MS entry - invalid handle %d\n",
+		    pkt->handle);
+
+		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		return;
+	}
+
+	CMD_COMPL_STATUS(sp->cmd) = le16_to_cpu(pkt->comp_status);
+	CMD_ENTRY_STATUS(sp->cmd) = pkt->entry_status;
+
+	/* Free outstanding command slot. */
+	ha->outstanding_cmds[pkt->handle] = NULL;
+
+	qla2x00_sp_compl(ha, sp);
+}
+
------------

-- 
Andrew Vasquez
