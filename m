From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] avoid scsi.h in qla2xxx
Date: Mon, 7 Jun 2004 12:30:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040607103020.GA13164@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:24542 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264391AbUFGKab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2004 06:30:31 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

and while we're at it switch to including the scsi headers only where
we actually need them.


--- 1.5/drivers/scsi/qla2xxx/qla_dbg.c	2004-05-03 17:12:51 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_dbg.c	2004-06-06 15:17:38 +02:00
@@ -16,8 +16,12 @@
  * General Public License for more details.
  *
  */
-#include "qla_os.h"
 
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#include "qla_os.h"
 #include "qla_def.h"
 
 static int qla_uprintf(char **, char *, ...);
--- 1.20/drivers/scsi/qla2xxx/qla_init.c	2004-05-11 00:29:10 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_init.c	2004-06-06 15:13:22 +02:00
@@ -16,6 +16,10 @@
  * General Public License for more details.
  *
  */
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+
 #include "qla_os.h"
 #include "qla_def.h"
 #include "qla_devtbl.h"
@@ -107,8 +111,8 @@
 	uint32_t wait_time;
 
 	/* Clear adapter flags. */
-	ha->flags.online = FALSE;
-	ha->flags.reset_active = FALSE;
+	ha->flags.online = 0;
+	ha->flags.reset_active = 0;
 	atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 	atomic_set(&ha->loop_state, LOOP_DOWN);
 	ha->device_flags = 0;
@@ -230,7 +234,7 @@
 		qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
 		ha->marker_needed = 0;
 
-		ha->flags.online = TRUE;
+		ha->flags.online = 1;
 	} else {
 		DEBUG2_3(printk("%s(): **** FAILED ****\n", __func__));
 	}
@@ -1539,20 +1543,20 @@
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
@@ -3095,7 +3099,7 @@
 				wait_time &&
 				(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
 		}
-		qla2x00_restart_queues(ha, TRUE);
+		qla2x00_restart_queues(ha, 1);
 	}
 
 	if (test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) {
@@ -4098,7 +4102,7 @@
 	uint8_t        status = 0;
 
 	if (ha->flags.online) {
-		ha->flags.online = FALSE;
+		ha->flags.online = 0;
 		clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 		qla2x00_stats.ispAbort++;
 		ha->total_isp_aborts++;  /* used by ioctl */
@@ -4155,20 +4159,20 @@
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
@@ -4179,8 +4183,8 @@
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
@@ -4235,7 +4239,7 @@
 
 	/* If firmware needs to be loaded */
 	if (qla2x00_isp_firmware(ha)) {
-		ha->flags.online = FALSE;
+		ha->flags.online = 0;
 		if (!(status = qla2x00_chip_diag(ha))) {
 			if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 				status = qla2x00_setup_chip(ha);
@@ -4274,7 +4278,7 @@
 					"status = %d\n",
 					__func__,
 					status);)
-			ha->flags.online = TRUE;
+			ha->flags.online = 1;
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
 			wait_time = 256;
 			do {
@@ -4311,7 +4315,7 @@
 	unsigned long flags = 0;
 	device_reg_t *reg = ha->iobase;
 
-	ha->flags.online = FALSE;
+	ha->flags.online = 0;
 	qla2x00_disable_intrs(ha);
 	/* Reset RISC processor. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
--- 1.6/drivers/scsi/qla2xxx/qla_iocb.c	2004-05-03 17:15:38 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-06 15:15:25 +02:00
@@ -17,6 +17,9 @@
  *
  ******************************************************************************/
 
+#include <scsi/scsi.h>
+#include <scsi/scsi_tcq.h>
+
 #include "qla_os.h"
 #include "qla_def.h"
 
--- 1.10/drivers/scsi/qla2xxx/qla_isr.c	2004-05-03 17:15:38 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_isr.c	2004-06-06 15:16:49 +02:00
@@ -17,8 +17,11 @@
  *
  */
 
-#include "qla_os.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
 
+#include "qla_os.h"
 #include "qla_def.h"
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
@@ -235,7 +238,7 @@
 	device_reg_t	*reg = ha->iobase;
 
 	/* Load return mailbox registers. */
-	ha->flags.mbox_int = TRUE;
+	ha->flags.mbox_int = 1;
 	ha->mailbox_out[0] = mb0;
 	wptr = (uint16_t *)MAILBOX_REG(ha, reg, 1);
 
--- 1.2/drivers/scsi/qla2xxx/qla_listops.h	2004-03-12 18:06:10 +01:00
+++ edited/drivers/scsi/qla2xxx/qla_listops.h	2004-06-06 15:07:41 +02:00
@@ -17,6 +17,8 @@
  *
  ******************************************************************************/
 
+#include <scsi/scsi_cmnd.h>
+
 /* Management functions for various lists */
 
 /* __add_to_done_queue()
--- 1.9/drivers/scsi/qla2xxx/qla_mbx.c	2004-05-03 17:16:34 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_mbx.c	2004-06-06 15:14:11 +02:00
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
--- 1.25/drivers/scsi/qla2xxx/qla_os.c	2004-05-11 00:29:10 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2004-06-06 15:10:58 +02:00
@@ -17,6 +17,14 @@
  *
  */
 
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
+
 #include "qla_os.h"
 #include "qla_def.h"
 
@@ -968,7 +976,7 @@
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(HZ);
 	}
-	if (ha->flags.online == TRUE) 
+	if (ha->flags.online) 
 		return_status = QLA_SUCCESS; 
 	else
 		/* Adapter is disabled/offline */
@@ -2233,8 +2241,7 @@
 
 	qla2x00_mem_free(ha);
 
-
-	ha->flags.online = FALSE;
+	ha->flags.online = 0;
 
 	/* Detach interrupts */
 	if (ha->pdev->irq)
@@ -2358,7 +2365,7 @@
 		return (retval);
 	}
 
-	if (inout == TRUE) {
+	if (inout) {
 		/* Has data been written to the file? */
 		DEBUG3(printk(
 		    "%s: has data been written to the file. \n",
@@ -3494,7 +3501,7 @@
 			DEBUG(printk("scsi(%ld): qla2x00_restart_queues()\n",
 			    ha->host_no));
 
-			qla2x00_restart_queues(ha,FALSE);
+			qla2x00_restart_queues(ha, 0);
 
 			DEBUG(printk("scsi(%ld): qla2x00_restart_queues - end\n",
 			    ha->host_no));
@@ -3505,7 +3512,7 @@
 			DEBUG(printk("scsi(%ld): qla2x00_abort_queues()\n",
 			    ha->host_no));
 				
-			qla2x00_abort_queues(ha, FALSE);
+			qla2x00_abort_queues(ha, 0);
 
 			DEBUG(printk("scsi(%ld): qla2x00_abort_queues - end\n",
 			    ha->host_no));
===== drivers/scsi/qla2xxx/qla_os.h 1.5 vs edited =====
--- 1.5/drivers/scsi/qla2xxx/qla_os.h	2004-05-12 17:46:27 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_os.h	2004-06-06 15:18:43 +02:00
@@ -58,14 +58,6 @@
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 
-#include "scsi.h"
-#include <scsi/scsi_host.h>
-
-#include <scsi/scsicam.h>
-#include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_fc.h>
-
 //TODO Fix this!!!
 /*
 * String arrays
