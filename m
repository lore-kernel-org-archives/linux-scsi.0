From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/14] qla2xxx: Remove unnecessary spinlock primitive - mbx_reg_lock.
Date: Mon, 29 Jan 2007 10:22:30 -0800
Message-ID: <1170094951220-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbXA2SWi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:38 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

Since, mailbox commands are executed in a synchronous
manner, there is no need to have a separate spinlock
primitive to protect data/register access shared by callers.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 --
 drivers/scsi/qla2xxx/qla_isr.c |   16 ----------------
 drivers/scsi/qla2xxx/qla_mbx.c |   16 ----------------
 drivers/scsi/qla2xxx/qla_os.c  |    8 --------
 4 files changed, 0 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index aba63b0..05f4f2a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2340,8 +2340,6 @@ typedef struct scsi_qla_host {
 #define MBX_INTR_WAIT	2
 #define MBX_UPDATE_FLASH_ACTIVE	3
 
-	spinlock_t	mbx_reg_lock;   /* Mbx Cmd Register Lock */
-
 	struct semaphore mbx_cmd_sem;	/* Serialialize mbx access */
 	struct semaphore mbx_intr_sem;  /* Used for completion notification */
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 3cd34ba..d488561 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -86,12 +86,8 @@ qla2100_intr_handler(int irq, void *dev_id)
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-		spin_lock_irqsave(&ha->mbx_reg_lock, flags);
-
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 		up(&ha->mbx_intr_sem);
-
-		spin_unlock_irqrestore(&ha->mbx_reg_lock, flags);
 	}
 
 	return (IRQ_HANDLED);
@@ -199,12 +195,8 @@ qla2300_intr_handler(int irq, void *dev_id)
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-		spin_lock_irqsave(&ha->mbx_reg_lock, flags);
-
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 		up(&ha->mbx_intr_sem);
-
-		spin_unlock_irqrestore(&ha->mbx_reg_lock, flags);
 	}
 
 	return (IRQ_HANDLED);
@@ -1494,12 +1486,8 @@ qla24xx_intr_handler(int irq, void *dev_id)
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-		spin_lock_irqsave(&ha->mbx_reg_lock, flags);
-
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 		up(&ha->mbx_intr_sem);
-
-		spin_unlock_irqrestore(&ha->mbx_reg_lock, flags);
 	}
 
 	return IRQ_HANDLED;
@@ -1632,12 +1620,8 @@ qla24xx_msix_default(int irq, void *dev_id)
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-		spin_lock_irqsave(&ha->mbx_reg_lock, flags);
-
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 		up(&ha->mbx_intr_sem);
-
-		spin_unlock_irqrestore(&ha->mbx_reg_lock, flags);
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7a70ead..83376f6 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -55,7 +55,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *ha, mbx_cmd_t *mcp)
 	uint16_t __iomem *optr;
 	uint32_t	cnt;
 	uint32_t	mboxes;
-	unsigned long	mbx_flags = 0;
 	unsigned long	wait_time;
 
 	rval = QLA_SUCCESS;
@@ -81,10 +80,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *ha, mbx_cmd_t *mcp)
 	/* Save mailbox command for debug */
 	ha->mcp = mcp;
 
-	/* Try to get mailbox register access */
-	if (!abort_active)
-		spin_lock_irqsave(&ha->mbx_reg_lock, mbx_flags);
-
 	DEBUG11(printk("scsi(%ld): prepare to issue mbox cmd=0x%x.\n",
 	    ha->host_no, mcp->mb[0]));
 
@@ -161,9 +156,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *ha, mbx_cmd_t *mcp)
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		if (!abort_active)
-			spin_unlock_irqrestore(&ha->mbx_reg_lock, mbx_flags);
-
 		/* Wait for either the timer to expire
 		 * or the mbox completion interrupt
 		 */
@@ -184,8 +176,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *ha, mbx_cmd_t *mcp)
 		else
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		if (!abort_active)
-			spin_unlock_irqrestore(&ha->mbx_reg_lock, mbx_flags);
 
 		wait_time = jiffies + mcp->tov * HZ; /* wait at most tov secs */
 		while (!ha->flags.mbox_int) {
@@ -201,9 +191,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *ha, mbx_cmd_t *mcp)
 		} /* while */
 	}
 
-	if (!abort_active)
-		spin_lock_irqsave(&ha->mbx_reg_lock, mbx_flags);
-
 	/* Check whether we timed out */
 	if (ha->flags.mbox_int) {
 		uint16_t *iptr2;
@@ -256,9 +243,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *ha, mbx_cmd_t *mcp)
 		rval = QLA_FUNCTION_TIMEOUT;
 	}
 
-	if (!abort_active)
-		spin_unlock_irqrestore(&ha->mbx_reg_lock, mbx_flags);
-
 	ha->flags.mbox_busy = 0;
 
 	/* Clean up */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fc99398..68f5d24 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1566,14 +1566,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ha->list);
 	INIT_LIST_HEAD(&ha->fcports);
 
-	/*
-	 * These locks are used to prevent more than one CPU
-	 * from modifying the queue at the same time. The
-	 * higher level "host_lock" will reduce most
-	 * contention for these locks.
-	 */
-	spin_lock_init(&ha->mbx_reg_lock);
-
 	qla2x00_config_dma_addressing(ha);
 	if (qla2x00_mem_alloc(ha)) {
 		qla_printk(KERN_WARNING, ha,
-- 
1.5.0.rc2.gdbaa0

