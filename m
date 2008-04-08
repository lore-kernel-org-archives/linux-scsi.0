From: Ke Wei <kewei@marvell.com>
Subject: [PATCH scsi-rc-fixes-2.6] mvsas: fix error handling.
Date: Tue, 08 Apr 2008 18:31:38 +0800
Message-ID: <47FB498A.2010107@marvell.com>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:24550 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752380AbYDHKbl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Apr 2008 06:31:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, jeff@garzik.org

 Changed error handling: Add a internal queue to send command in mvs_task_abort function.
 Set max_id and max_lun to a valid value. It's good for 64xx chip.
 BTW, DVD-ROM compatibility needs to test carefully.


Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |  101 +++++++++++++++++++++++--------------------------
 1 files changed, 47 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index e55b903..b45185e 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -639,6 +639,7 @@ struct mvs_slot_info {
 
 	void			*response;
 	struct mvs_port		*port;
+	struct completion	*completion;
 };
 
 struct mvs_info {
@@ -674,9 +675,6 @@ struct mvs_info {
 				/* further per-slot information */
 	struct mvs_phy		phy[MVS_MAX_PHYS];
 	struct mvs_port		port[MVS_MAX_PHYS];
-#ifdef MVS_USE_TASKLET
-	struct tasklet_struct	tasklet;
-#endif
 };
 
 static int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
@@ -1225,7 +1223,7 @@ static void mvs_int_sata(struct mvs_info *mvi)
 }
 
 static void mvs_slot_reset(struct mvs_info *mvi, struct sas_task *task,
-				u32 slot_idx)
+				u32 slot_idx, struct completion *completion)
 {
 	void __iomem *regs = mvi->regs;
 	struct domain_device *dev = task->dev;
@@ -1233,6 +1231,7 @@ static void mvs_slot_reset(struct mvs_info *mvi, struct sas_task *task,
 	struct mvs_port *port = mvi->slot_info[slot_idx].port;
 	u32 reg_set, phy_mask;
 
+	mvi->slot_info[slot_idx].completion = completion;
 	if (!sas_protocol_ata(task->task_proto)) {
 		reg_set = 0;
 		phy_mask = (port->wide_port_phymap) ? port->wide_port_phymap :
@@ -1313,7 +1312,7 @@ static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
 
 	if (err_dw1 & SLOT_BSY_ERR) {
 		stat = SAS_QUEUE_FULL;
-		mvs_slot_reset(mvi, task, slot_idx);
+		mvs_slot_reset(mvi, task, slot_idx, NULL);
 	}
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SSP:
@@ -1350,17 +1349,17 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	mvs_hba_cq_dump(mvi);
 
 	spin_lock(&task->task_state_lock);
+	task->task_state_flags &=
+		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
-	if (!aborted) {
-		task->task_state_flags &=
-		    ~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
-		task->task_state_flags |= SAS_TASK_STATE_DONE;
-	}
 	spin_unlock(&task->task_state_lock);
-
-	if (aborted) {
+	if (unlikely(aborted)) {
+		struct completion *completion = slot->completion;
 		mvs_slot_task_free(mvi, task, slot, slot_idx);
 		mvs_slot_free(mvi, rx_desc);
+		if (completion)
+			complete(completion);
 		return -1;
 	}
 
@@ -1426,7 +1425,7 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 
 out:
 	mvs_slot_task_free(mvi, task, slot, slot_idx);
-	if (unlikely(tstat->stat != SAS_QUEUE_FULL))
+	if (tstat->stat != SAS_QUEUE_FULL)
 		mvs_slot_free(mvi, rx_desc);
 
 	spin_unlock(&mvi->lock);
@@ -1521,9 +1520,9 @@ static int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
 			dev_printk(KERN_DEBUG, &pdev->dev, "RXQ_ERR %X\n",
 				rx_desc);
 		} else if (rx_desc & RXQ_SLOT_RESET) {
+			mvs_slot_free(mvi, rx_desc);
 			dev_printk(KERN_DEBUG, &pdev->dev, "Slot reset[%X]\n",
 				rx_desc);
-			mvs_slot_free(mvi, rx_desc);
 		}
 	}
 
@@ -1533,23 +1532,6 @@ static int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
 	return 0;
 }
 
-#ifdef MVS_USE_TASKLET
-static void mvs_tasklet(unsigned long data)
-{
-	struct mvs_info *mvi = (struct mvs_info *) data;
-	unsigned long flags;
-
-	spin_lock_irqsave(&mvi->lock, flags);
-
-#ifdef MVS_DISABLE_MSI
-	mvs_int_full(mvi);
-#else
-	mvs_int_rx(mvi, true);
-#endif
-	spin_unlock_irqrestore(&mvi->lock, flags);
-}
-#endif
-
 static irqreturn_t mvs_interrupt(int irq, void *opaque)
 {
 	struct mvs_info *mvi = opaque;
@@ -1564,15 +1546,12 @@ static irqreturn_t mvs_interrupt(int irq, void *opaque)
 	/* clear CMD_CMPLT ASAP */
 	mw32_f(INT_STAT, CINT_DONE);
 
-#ifndef MVS_USE_TASKLET
 	spin_lock(&mvi->lock);
 
 	mvs_int_full(mvi);
 
 	spin_unlock(&mvi->lock);
-#else
-	tasklet_schedule(&mvi->tasklet);
-#endif
+
 	return IRQ_HANDLED;
 }
 
@@ -1581,15 +1560,12 @@ static irqreturn_t mvs_msi_interrupt(int irq, void *opaque)
 {
 	struct mvs_info *mvi = opaque;
 
-#ifndef MVS_USE_TASKLET
 	spin_lock(&mvi->lock);
 
 	mvs_int_rx(mvi, true);
 
 	spin_unlock(&mvi->lock);
-#else
-	tasklet_schedule(&mvi->tasklet);
-#endif
+
 	return IRQ_HANDLED;
 }
 #endif
@@ -2037,7 +2013,8 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	return 0;
 }
 
-static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
+static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
+				struct completion *completion)
 {
 	struct domain_device *dev = task->dev;
 	struct mvs_info *mvi = dev->port->ha->lldd_ha;
@@ -2093,6 +2070,8 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
 		t->lldd_task = NULL;
 		slot->n_elem = n_elem;
 		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
+		slot->completion = completion;
+
 		tei.task = t;
 		tei.hdr = &mvi->slot[tag];
 		tei.tag = tag;
@@ -2157,6 +2136,12 @@ out_done:
 	return rc;
 }
 
+static int mvs_queue_command(struct sas_task *task, const int num,
+				gfp_t gfp_flags)
+{
+	return mvs_task_exec(task, num, gfp_flags, NULL);
+}
+
 static int mvs_task_abort(struct sas_task *task)
 {
 	int rc;
@@ -2164,6 +2149,7 @@ static int mvs_task_abort(struct sas_task *task)
 	struct mvs_info *mvi = task->dev->port->ha->lldd_ha;
 	struct pci_dev *pdev = mvi->pdev;
 	int tag;
+	DECLARE_COMPLETION_ONSTACK(completion);
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
@@ -2208,10 +2194,18 @@ static int mvs_task_abort(struct sas_task *task)
 		mvs_slot_task_free(mvi, task, &mvi->slot_info[tag], tag);
 		spin_unlock_irqrestore(&mvi->lock, flags);
 	}
-	if (!mvs_task_exec(task, 1, GFP_ATOMIC))
+	mvs_task_exec(task, 1, GFP_ATOMIC, &completion);
+	wait_for_completion_timeout(&completion, 5 * HZ);
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		rc = TMF_RESP_FUNC_COMPLETE;
-	else
-		rc = TMF_RESP_FUNC_FAILED;
+		dev_printk(KERN_DEBUG, &pdev->dev, "%s: task 0x%p done\n",
+			__func__, task);
+		goto out_done;
+	}
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	rc = TMF_RESP_FUNC_FAILED;
 out_done:
 	return rc;
 }
@@ -2348,9 +2342,7 @@ static struct mvs_info *__devinit mvs_alloc(struct pci_dev *pdev,
 		return NULL;
 
 	spin_lock_init(&mvi->lock);
-#ifdef MVS_USE_TASKLET
-	tasklet_init(&mvi->tasklet, mvs_tasklet, (unsigned long)mvi);
-#endif
+
 	mvi->pdev = pdev;
 	mvi->chip = chip;
 
@@ -2382,8 +2374,8 @@ static struct mvs_info *__devinit mvs_alloc(struct pci_dev *pdev,
 
 	SHOST_TO_SAS_HA(mvi->shost) = &mvi->sas;
 	mvi->shost->transportt = mvs_stt;
-	mvi->shost->max_id = 21;
-	mvi->shost->max_lun = ~0;
+	mvi->shost->max_id = 128;
+	mvi->shost->max_lun = 1;
 	mvi->shost->max_channel = 0;
 	mvi->shost->max_cmd_len = 16;
 
@@ -2812,7 +2804,7 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
 			} else {
 				dev_printk(KERN_DEBUG, &pdev->dev,
 					"No sig fis\n");
-				phy->phy_type &= ~(PORT_TYPE_SATA);
+				phy->phy_type &= ~PORT_TYPE_SATA;
 				goto out_done;
 			}
 		}
@@ -2822,7 +2814,9 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			"phy[%d] Get Attached Address 0x%llX ,"
 			" SAS Address 0x%llX\n",
-			i, phy->att_dev_sas_addr, phy->dev_sas_addr);
+			i,
+			(unsigned long long)phy->att_dev_sas_addr,
+			(unsigned long long)phy->dev_sas_addr);
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			"Rate = %x , type = %d\n",
 			sas_phy->linkrate, phy->phy_type);
@@ -2918,7 +2912,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 	else
 		mw32_f(CTL, cctl | CCTL_RST);
 
-	/* write to device control _AND_ device status register? - A.C. */
+	/* write to device control _AND_ device status register */
 	pci_read_config_dword(mvi->pdev, PCR_DEV_CTRL, &tmp);
 	tmp &= ~PRD_REQ_MASK;
 	tmp |= PRD_REQ_SIZE;
@@ -2998,8 +2992,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 	/* FIXME: update wide port bitmaps */
 
 	/* little endian for open address and command table, etc. */
-	/* A.C.
-	 * it seems that ( from the spec ) turning on big-endian won't
+	/* it seems that ( from the spec ) turning on big-endian won't
 	 * do us any good on big-endian machines, need further confirmation
 	 */
 	cctl = mr32(CTL);
@@ -3153,7 +3146,7 @@ static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 }
 
 static struct sas_domain_function_template mvs_transport_ops = {
-	.lldd_execute_task	= mvs_task_exec,
+	.lldd_execute_task	= mvs_queue_command,
 	.lldd_control_phy	= mvs_phy_control,
 	.lldd_abort_task	= mvs_task_abort,
 	.lldd_port_formed	= mvs_port_formed,
-- 
1.5.4


