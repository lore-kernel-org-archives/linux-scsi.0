From: David Howells <dhowells@redhat.com>
Subject: [PATCH] IPR: Remove spurious volatiles
Date: Fri, 17 Sep 2010 13:27:19 +0100
Message-ID: <20100917122719.3125.16739.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: brking@us.ibm.com, wayneb@linux.vnet.ibm.com, James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
List-Id: linux-scsi@vger.kernel.org

The IPR driver has some spurious volatiles in it.  It's not entirely clear why
they are there, but if it's to prevent readl() calls from being merged,
reordered or discarded due to unused return value, then readl() must be wrong.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/scsi/ipr.c |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5256858..f0a80ad 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -645,8 +645,6 @@ struct ipr_cmnd *ipr_get_free_ipr_cmnd(struct ipr_ioa_cfg *ioa_cfg)
 static void ipr_mask_and_clear_interrupts(struct ipr_ioa_cfg *ioa_cfg,
 					  u32 clr_ints)
 {
-	volatile u32 int_reg;
-
 	/* Stop new interrupts */
 	ioa_cfg->allow_interrupts = 0;
 
@@ -660,7 +658,7 @@ static void ipr_mask_and_clear_interrupts(struct ipr_ioa_cfg *ioa_cfg,
 	if (ioa_cfg->sis64)
 		writel(~0, ioa_cfg->regs.clr_interrupt_reg);
 	writel(clr_ints, ioa_cfg->regs.clr_interrupt_reg32);
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
+	readl(ioa_cfg->regs.sense_interrupt_reg);
 }
 
 /**
@@ -2564,7 +2562,7 @@ static u32 ipr_get_max_scsi_speed(struct ipr_ioa_cfg *ioa_cfg, u8 bus, u8 bus_wi
  **/
 static int ipr_wait_iodbg_ack(struct ipr_ioa_cfg *ioa_cfg, int max_delay)
 {
-	volatile u32 pcii_reg;
+	u32 pcii_reg;
 	int delay = 1;
 
 	/* Read interrupt reg until IOA signals IO Debug Acknowledge */
@@ -2624,7 +2622,7 @@ static int ipr_get_ldump_data_section(struct ipr_ioa_cfg *ioa_cfg,
 				      u32 start_addr,
 				      __be32 *dest, u32 length_in_words)
 {
-	volatile u32 temp_pcii_reg;
+	u32 temp_pcii_reg;
 	int i, delay = 0;
 
 	if (ioa_cfg->sis64)
@@ -4905,7 +4903,7 @@ static int ipr_eh_abort(struct scsi_cmnd * scsi_cmd)
 static irqreturn_t ipr_handle_other_interrupt(struct ipr_ioa_cfg *ioa_cfg)
 {
 	irqreturn_t rc = IRQ_HANDLED;
-	volatile u32 int_reg, int_mask_reg;
+	u32 int_reg, int_mask_reg;
 
 	int_mask_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg32);
 	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32) & ~int_mask_reg;
@@ -4991,7 +4989,7 @@ static irqreturn_t ipr_isr(int irq, void *devp)
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)devp;
 	unsigned long lock_flags = 0;
-	volatile u32 int_reg;
+	u32 int_reg;
 	u32 ioasc;
 	u16 cmd_index;
 	int num_hrrq = 0;
@@ -7211,7 +7209,7 @@ static int ipr_reset_next_stage(struct ipr_cmnd *ipr_cmd)
 {
 	unsigned long stage, stage_time;
 	u32 feedback;
-	volatile u32 int_reg;
+	u32 int_reg;
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	u64 maskval = 0;
 
@@ -7269,8 +7267,8 @@ static int ipr_reset_next_stage(struct ipr_cmnd *ipr_cmd)
 static int ipr_reset_enable_ioa(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
-	volatile u32 int_reg;
-	volatile u64 maskval;
+	u32 int_reg;
+	u64 maskval;
 
 	ENTER;
 	ipr_cmd->job_step = ipr_ioafp_identify_hrrq;
@@ -7440,7 +7438,6 @@ static void ipr_get_unit_check_buffer(struct ipr_ioa_cfg *ioa_cfg)
 static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
-	volatile u32 int_reg;
 	int rc;
 
 	ENTER;
@@ -7462,7 +7459,7 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 	if (ioa_cfg->sis64) {
 		/* Set the adapter to the correct endian mode. */
 		writel(IPR_ENDIAN_SWAP_KEY, ioa_cfg->regs.endian_swap_reg);
-		int_reg = readl(ioa_cfg->regs.endian_swap_reg);
+		readl(ioa_cfg->regs.endian_swap_reg);
 	}
 
 	if (ioa_cfg->ioa_unit_checked) {
@@ -7596,7 +7593,7 @@ static int ipr_reset_slot_reset(struct ipr_cmnd *ipr_cmd)
  **/
 static int ipr_reset_allowed(struct ipr_ioa_cfg *ioa_cfg)
 {
-	volatile u32 temp_reg;
+	u32 temp_reg;
 
 	temp_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
 	return ((temp_reg & IPR_PCII_CRITICAL_OPERATION) == 0);
@@ -8469,7 +8466,6 @@ static int __devinit ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg,
 				  struct pci_dev *pdev)
 {
 	int rc;
-	volatile u32 int_reg;
 	unsigned long lock_flags = 0;
 
 	ENTER;
@@ -8479,7 +8475,7 @@ static int __devinit ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg,
 	ioa_cfg->msi_received = 0;
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
 	writel(IPR_PCII_IO_DEBUG_ACKNOWLEDGE, ioa_cfg->regs.clr_interrupt_mask_reg32);
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
+	readl(ioa_cfg->regs.sense_interrupt_mask_reg);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
 	rc = request_irq(pdev->irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
@@ -8490,7 +8486,7 @@ static int __devinit ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg,
 		dev_info(&pdev->dev, "IRQ assigned: %d\n", pdev->irq);
 
 	writel(IPR_PCII_IO_DEBUG_ACKNOWLEDGE, ioa_cfg->regs.sense_interrupt_reg32);
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
+	readl(ioa_cfg->regs.sense_interrupt_reg);
 	wait_event_timeout(ioa_cfg->msi_wait_q, ioa_cfg->msi_received, HZ);
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
 
@@ -8527,7 +8523,7 @@ static int __devinit ipr_probe_ioa(struct pci_dev *pdev,
 	unsigned long ipr_regs_pci;
 	void __iomem *ipr_regs;
 	int rc = PCIBIOS_SUCCESSFUL;
-	volatile u32 mask, uproc, interrupts;
+	u32 mask, uproc, interrupts;
 
 	ENTER;
 
