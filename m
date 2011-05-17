From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: fix possible false positive detection of stuck interrupt
Date: Tue, 17 May 2011 09:18:53 -0700
Message-ID: <4DD29FED.60707@linux.vnet.ibm.com>
References: <20110517161648.403401807@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45465 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab1EQQS4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2011 12:18:56 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4HFnUFs005701
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2011 11:49:30 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4HGItku118206
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2011 12:18:55 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4HCIguJ014908
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2011 09:18:43 -0300
In-Reply-To: <20110517161648.403401807@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@br.ibm.com>

If the driver is getting flooded with interrupts, there's a possibility
that the interrupt service routine could falsely detect a stuck interrupt
condition and reset the adapter.

This patch changes the logic such that the routine will loop back into
the command processing code one more time after detecting the stuck
interrupt signature.  If there are no commands to process after that pass,
and the interrupt is still not cleared, then the driver will print the
"Error clearing HRRQ" message and reset the adapter.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2011-05-03 09:09:53.389771489 -0700
+++ b/drivers/scsi/ipr.c	2011-05-04 11:50:18.855071813 -0700
@@ -5149,21 +5149,21 @@ static irqreturn_t ipr_isr(int irq, void

 		if (ipr_cmd != NULL) {
 			/* Clear the PCI interrupt */
+			num_hrrq = 0;
 			do {
 				writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg32);
 				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
 			} while (int_reg & IPR_PCII_HRRQ_UPDATED &&
 					num_hrrq++ < IPR_MAX_HRRQ_RETRIES);

-			if (int_reg & IPR_PCII_HRRQ_UPDATED) {
-				ipr_isr_eh(ioa_cfg, "Error clearing HRRQ");
-				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-				return IRQ_HANDLED;
-			}
-
 		} else if (rc == IRQ_NONE && irq_none == 0) {
 			int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
 			irq_none++;
+		} else if (num_hrrq == IPR_MAX_HRRQ_RETRIES &&
+			   int_reg & IPR_PCII_HRRQ_UPDATED) {
+			ipr_isr_eh(ioa_cfg, "Error clearing HRRQ");
+			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+			return IRQ_HANDLED;
 		} else
 			break;
 	}

