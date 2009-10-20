From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: add workaround for MSI interrupts on P7
Date: Tue, 20 Oct 2009 11:09:00 -0700
Message-ID: <4ADDFCBC.9050608@linux.vnet.ibm.com>
References: <20090930212120.556737609@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56881 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZJTSI7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Oct 2009 14:08:59 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9KI18Tk019823
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2009 14:01:08 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9KI918w238012
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2009 14:09:04 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9KI91uq026158
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2009 14:09:01 -0400
In-Reply-To: <20090930212120.556737609@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Brian King <brking@linux.vnet.ibm.com>

This patch adds some additional logic to the interrupt service routine to fix
a potential problem where an MSI interrupt does not get cleared the first time.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---
 ipr.c |   42 +++++++++++++++++++++++++++++++++---------
 ipr.h |    1 +
 2 files changed, 34 insertions(+), 9 deletions(-)

Index: b/ipr.c
===================================================================
--- a/ipr.c	2009-09-29 09:34:08.000000000 -0700
+++ b/ipr.c	2009-09-30 14:16:51.000000000 -0700
@@ -4189,6 +4189,25 @@ static irqreturn_t ipr_handle_other_inte
 }

 /**
+ * ipr_isr_eh - Interrupt service routine error handler
+ * @ioa_cfg:	ioa config struct
+ * @msg:	message to log
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_isr_eh(struct ipr_ioa_cfg *ioa_cfg, char *msg)
+{
+	ioa_cfg->errors_logged++;
+	dev_err(&ioa_cfg->pdev->dev, "%s\n", msg);
+
+	if (WAIT_FOR_DUMP == ioa_cfg->sdt_state)
+		ioa_cfg->sdt_state = GET_DUMP;
+
+	ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+}
+
+/**
  * ipr_isr - Interrupt service routine
  * @irq:	irq number
  * @devp:	pointer to ioa config struct
@@ -4203,6 +4222,7 @@ static irqreturn_t ipr_isr(int irq, void
 	volatile u32 int_reg, int_mask_reg;
 	u32 ioasc;
 	u16 cmd_index;
+	int num_hrrq = 0;
 	struct ipr_cmnd *ipr_cmd;
 	irqreturn_t rc = IRQ_NONE;

@@ -4233,13 +4253,7 @@ static irqreturn_t ipr_isr(int irq, void
 				     IPR_HRRQ_REQ_RESP_HANDLE_MASK) >> IPR_HRRQ_REQ_RESP_HANDLE_SHIFT;

 			if (unlikely(cmd_index >= IPR_NUM_CMD_BLKS)) {
-				ioa_cfg->errors_logged++;
-				dev_err(&ioa_cfg->pdev->dev, "Invalid response handle from IOA\n");
-
-				if (WAIT_FOR_DUMP == ioa_cfg->sdt_state)
-					ioa_cfg->sdt_state = GET_DUMP;
-
-				ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+				ipr_isr_eh(ioa_cfg, "Invalid response handle from IOA");
 				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 				return IRQ_HANDLED;
 			}
@@ -4266,8 +4280,18 @@ static irqreturn_t ipr_isr(int irq, void

 		if (ipr_cmd != NULL) {
 			/* Clear the PCI interrupt */
-			writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg);
-			int_reg = readl(ioa_cfg->regs.sense_interrupt_reg) & ~int_mask_reg;
+			do {
+				writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg);
+				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg) & ~int_mask_reg;
+			} while (int_reg & IPR_PCII_HRRQ_UPDATED &&
+					num_hrrq++ < IPR_MAX_HRRQ_RETRIES);
+
+			if (int_reg & IPR_PCII_HRRQ_UPDATED) {
+				ipr_isr_eh(ioa_cfg, "Error clearing HRRQ");
+				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+				return IRQ_HANDLED;
+			}
+
 		} else
 			break;
 	}
Index: b/ipr.h
===================================================================
--- a/ipr.h	2009-09-29 14:59:33.000000000 -0700
+++ b/ipr.h	2009-09-29 15:00:35.000000000 -0700
@@ -144,6 +144,7 @@
 #define IPR_IOA_MAX_SECTORS				32767
 #define IPR_VSET_MAX_SECTORS				512
 #define IPR_MAX_CDB_LEN					16
+#define IPR_MAX_HRRQ_RETRIES				3

 #define IPR_DEFAULT_BUS_WIDTH				16
 #define IPR_80MBs_SCSI_RATE		((80 * 10) / (IPR_DEFAULT_BUS_WIDTH / 8))

