From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 2/3] stex: add support for reset request from firmware
Date: Mon, 28 Sep 2009 22:58:33 -0800
Message-ID: <200909282258216055237@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:57248 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751657AbZI2GNj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 02:13:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>

Add support for reset request from firmware for controllers
of st_shasta and st_yel type. Code adjustments necessary
for this change are also included.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
 drivers/scsi/stex.c |  249 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 166 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index af5bafc..79216ee 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -64,24 +64,24 @@ enum {
 	YH2I_REQ_HI				= 0xc4,
 
 	/* MU register value */
-	MU_INBOUND_DOORBELL_HANDSHAKE		= 1,
-	MU_INBOUND_DOORBELL_REQHEADCHANGED	= 2,
-	MU_INBOUND_DOORBELL_STATUSTAILCHANGED	= 4,
-	MU_INBOUND_DOORBELL_HMUSTOPPED		= 8,
-	MU_INBOUND_DOORBELL_RESET		= 16,
-
-	MU_OUTBOUND_DOORBELL_HANDSHAKE		= 1,
-	MU_OUTBOUND_DOORBELL_REQUESTTAILCHANGED	= 2,
-	MU_OUTBOUND_DOORBELL_STATUSHEADCHANGED	= 4,
-	MU_OUTBOUND_DOORBELL_BUSCHANGE		= 8,
-	MU_OUTBOUND_DOORBELL_HASEVENT		= 16,
+	MU_INBOUND_DOORBELL_HANDSHAKE		= (1 << 0),
+	MU_INBOUND_DOORBELL_REQHEADCHANGED	= (1 << 1),
+	MU_INBOUND_DOORBELL_STATUSTAILCHANGED	= (1 << 2),
+	MU_INBOUND_DOORBELL_HMUSTOPPED		= (1 << 3),
+	MU_INBOUND_DOORBELL_RESET		= (1 << 4),
+
+	MU_OUTBOUND_DOORBELL_HANDSHAKE		= (1 << 0),
+	MU_OUTBOUND_DOORBELL_REQUESTTAILCHANGED	= (1 << 1),
+	MU_OUTBOUND_DOORBELL_STATUSHEADCHANGED	= (1 << 2),
+	MU_OUTBOUND_DOORBELL_BUSCHANGE		= (1 << 3),
+	MU_OUTBOUND_DOORBELL_HASEVENT		= (1 << 4),
+	MU_OUTBOUND_DOORBELL_REQUEST_RESET	= (1 << 27),
 
 	/* MU status code */
 	MU_STATE_STARTING			= 1,
-	MU_STATE_FMU_READY_FOR_HANDSHAKE	= 2,
-	MU_STATE_SEND_HANDSHAKE_FRAME		= 3,
-	MU_STATE_STARTED			= 4,
-	MU_STATE_RESETTING			= 5,
+	MU_STATE_STARTED			= 2,
+	MU_STATE_RESETTING			= 3,
+	MU_STATE_FAILED				= 4,
 
 	MU_MAX_DELAY				= 120,
 	MU_HANDSHAKE_SIGNATURE			= 0x55aaaa55,
@@ -111,6 +111,8 @@ enum {
 
 	SS_H2I_INT_RESET			= 0x100,
 
+	SS_I2H_REQUEST_RESET			= 0x2000,
+
 	SS_MU_OPERATIONAL			= 0x80000000,
 
 	STEX_CDB_LENGTH				= 16,
@@ -312,6 +314,10 @@ struct st_hba {
 	struct st_ccb *wait_ccb;
 	__le32 *scratch;
 
+	char work_q_name[20];
+	struct workqueue_struct *work_q;
+	struct work_struct reset_work;
+	wait_queue_head_t reset_waitq;
 	unsigned int mu_status;
 	unsigned int cardtype;
 	int msi_enabled;
@@ -578,6 +584,9 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 	lun = cmd->device->lun;
 	hba = (struct st_hba *) &host->hostdata[0];
 
+	if (unlikely(hba->mu_status == MU_STATE_RESETTING))
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	switch (cmd->cmnd[0]) {
 	case MODE_SENSE_10:
 	{
@@ -842,7 +851,6 @@ static irqreturn_t stex_intr(int irq, void *__hba)
 	void __iomem *base = hba->mmio_base;
 	u32 data;
 	unsigned long flags;
-	int handled = 0;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 
@@ -853,12 +861,16 @@ static irqreturn_t stex_intr(int irq, void *__hba)
 		writel(data, base + ODBL);
 		readl(base + ODBL); /* flush */
 		stex_mu_intr(hba, data);
-		handled = 1;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		if (unlikely(data & MU_OUTBOUND_DOORBELL_REQUEST_RESET &&
+			hba->cardtype == st_shasta))
+			queue_work(hba->work_q, &hba->reset_work);
+		return IRQ_HANDLED;
 	}
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	return IRQ_RETVAL(handled);
+	return IRQ_NONE;
 }
 
 static void stex_ss_mu_intr(struct st_hba *hba)
@@ -940,7 +952,6 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
 	void __iomem *base = hba->mmio_base;
 	u32 data;
 	unsigned long flags;
-	int handled = 0;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 
@@ -949,12 +960,15 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
 		/* clear the interrupt */
 		writel(data, base + YI2H_INT_C);
 		stex_ss_mu_intr(hba);
-		handled = 1;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		if (unlikely(data & SS_I2H_REQUEST_RESET))
+			queue_work(hba->work_q, &hba->reset_work);
+		return IRQ_HANDLED;
 	}
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	return IRQ_RETVAL(handled);
+	return IRQ_NONE;
 }
 
 static int stex_common_handshake(struct st_hba *hba)
@@ -1047,7 +1061,7 @@ static int stex_ss_handshake(struct st_hba *hba)
 	struct st_msg_header *msg_h;
 	struct handshake_frame *h;
 	__le32 *scratch;
-	u32 data;
+	u32 data, scratch_size;
 	unsigned long before;
 	int ret = 0;
 
@@ -1075,13 +1089,16 @@ static int stex_ss_handshake(struct st_hba *hba)
 	stex_gettime(&h->hosttime);
 	h->partner_type = HMU_PARTNER_TYPE;
 	h->extra_offset = h->extra_size = 0;
-	h->scratch_size = cpu_to_le32((hba->sts_count+1)*sizeof(u32));
+	scratch_size = (hba->sts_count+1)*sizeof(u32);
+	h->scratch_size = cpu_to_le32(scratch_size);
 
 	data = readl(base + YINT_EN);
 	data &= ~4;
 	writel(data, base + YINT_EN);
 	writel((hba->dma_handle >> 16) >> 16, base + YH2I_REQ_HI);
+	readl(base + YH2I_REQ_HI);
 	writel(hba->dma_handle, base + YH2I_REQ);
+	readl(base + YH2I_REQ); /* flush */
 
 	scratch = hba->scratch;
 	before = jiffies;
@@ -1097,7 +1114,7 @@ static int stex_ss_handshake(struct st_hba *hba)
 		msleep(1);
 	}
 
-	*scratch = 0;
+	memset(scratch, 0, scratch_size);
 	msg_h->flag = 0;
 	return ret;
 }
@@ -1106,19 +1123,24 @@ static int stex_handshake(struct st_hba *hba)
 {
 	int err;
 	unsigned long flags;
+	unsigned int mu_status;
 
 	err = (hba->cardtype == st_yel) ?
 		stex_ss_handshake(hba) : stex_common_handshake(hba);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	mu_status = hba->mu_status;
 	if (err == 0) {
-		spin_lock_irqsave(hba->host->host_lock, flags);
 		hba->req_head = 0;
 		hba->req_tail = 0;
 		hba->status_head = 0;
 		hba->status_tail = 0;
 		hba->out_req_cnt = 0;
 		hba->mu_status = MU_STATE_STARTED;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	}
+	} else
+		hba->mu_status = MU_STATE_FAILED;
+	if (mu_status == MU_STATE_RESETTING)
+		wake_up_all(&hba->reset_waitq);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	return err;
 }
 
@@ -1138,17 +1160,11 @@ static int stex_abort(struct scsi_cmnd *cmd)
 
 	base = hba->mmio_base;
 	spin_lock_irqsave(host->host_lock, flags);
-	if (tag < host->can_queue && hba->ccb[tag].cmd == cmd)
+	if (tag < host->can_queue &&
+		hba->ccb[tag].req && hba->ccb[tag].cmd == cmd)
 		hba->wait_ccb = &hba->ccb[tag];
-	else {
-		for (tag = 0; tag < host->can_queue; tag++)
-			if (hba->ccb[tag].cmd == cmd) {
-				hba->wait_ccb = &hba->ccb[tag];
-				break;
-			}
-		if (tag >= host->can_queue)
-			goto out;
-	}
+	else
+		goto out;
 
 	if (hba->cardtype == st_yel) {
 		data = readl(base + YI2H_INT);
@@ -1222,6 +1238,37 @@ static void stex_hard_reset(struct st_hba *hba)
 			hba->pdev->saved_config_space[i]);
 }
 
+static int stex_yos_reset(struct st_hba *hba)
+{
+	void __iomem *base;
+	unsigned long flags, before;
+	int ret = 0;
+
+	base = hba->mmio_base;
+	writel(MU_INBOUND_DOORBELL_RESET, base + IDBL);
+	readl(base + IDBL); /* flush */
+	before = jiffies;
+	while (hba->out_req_cnt > 0) {
+		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ)) {
+			printk(KERN_WARNING DRV_NAME
+				"(%s): reset timeout\n", pci_name(hba->pdev));
+			ret = -1;
+			break;
+		}
+		msleep(1);
+	}
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (ret == -1)
+		hba->mu_status = MU_STATE_FAILED;
+	else
+		hba->mu_status = MU_STATE_STARTED;
+	wake_up_all(&hba->reset_waitq);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	return ret;
+}
+
 static void stex_ss_reset(struct st_hba *hba)
 {
 	writel(SS_H2I_INT_RESET, hba->mmio_base + YH2I_INT);
@@ -1229,66 +1276,86 @@ static void stex_ss_reset(struct st_hba *hba)
 	ssleep(5);
 }
 
-static int stex_reset(struct scsi_cmnd *cmd)
+static int stex_do_reset(struct st_hba *hba)
 {
-	struct st_hba *hba;
-	void __iomem *base;
-	unsigned long flags, before;
+	struct st_ccb *ccb;
+	unsigned long flags;
+	unsigned int mu_status = MU_STATE_RESETTING;
+	u16 tag;
 
-	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->mu_status == MU_STATE_STARTING) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		printk(KERN_INFO DRV_NAME "(%s): request reset during init\n",
+			pci_name(hba->pdev));
+		return 0;
+	}
+	while (hba->mu_status == MU_STATE_RESETTING) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		wait_event_timeout(hba->reset_waitq,
+				   hba->mu_status != MU_STATE_RESETTING,
+				   MU_MAX_DELAY * HZ);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		mu_status = hba->mu_status;
+	}
 
-	printk(KERN_INFO DRV_NAME
-		"(%s): resetting host\n", pci_name(hba->pdev));
-	scsi_print_command(cmd);
+	if (mu_status != MU_STATE_RESETTING) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		return (mu_status == MU_STATE_STARTED) ? 0 : -1;
+	}
 
 	hba->mu_status = MU_STATE_RESETTING;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (hba->cardtype == st_yosemite)
+		return stex_yos_reset(hba);
 
 	if (hba->cardtype == st_shasta)
 		stex_hard_reset(hba);
 	else if (hba->cardtype == st_yel)
 		stex_ss_reset(hba);
 
-	if (hba->cardtype != st_yosemite) {
-		if (stex_handshake(hba)) {
-			printk(KERN_WARNING DRV_NAME
-				"(%s): resetting: handshake failed\n",
-				pci_name(hba->pdev));
-			return FAILED;
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	for (tag = 0; tag < hba->host->can_queue; tag++) {
+		ccb = &hba->ccb[tag];
+		if (ccb->req == NULL)
+			continue;
+		ccb->req = NULL;
+		if (ccb->cmd) {
+			scsi_dma_unmap(ccb->cmd);
+			ccb->cmd->result = DID_RESET << 16;
+			ccb->cmd->scsi_done(ccb->cmd);
+			ccb->cmd = NULL;
 		}
-		return SUCCESS;
 	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	/* st_yosemite */
-	writel(MU_INBOUND_DOORBELL_RESET, hba->mmio_base + IDBL);
-	readl(hba->mmio_base + IDBL); /* flush */
-	before = jiffies;
-	while (hba->out_req_cnt > 0) {
-		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ)) {
-			printk(KERN_WARNING DRV_NAME
-				"(%s): reset timeout\n", pci_name(hba->pdev));
-			return FAILED;
-		}
-		msleep(1);
-	}
+	if (stex_handshake(hba) == 0)
+		return 0;
 
-	base = hba->mmio_base;
-	writel(0, base + IMR0);
-	readl(base + IMR0);
-	writel(0, base + OMR0);
-	readl(base + OMR0);
-	writel(0, base + IMR1);
-	readl(base + IMR1);
-	writel(0, base + OMR1);
-	readl(base + OMR1); /* flush */
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->req_head = 0;
-	hba->req_tail = 0;
-	hba->status_head = 0;
-	hba->status_tail = 0;
-	hba->out_req_cnt = 0;
-	hba->mu_status = MU_STATE_STARTED;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	return SUCCESS;
+	printk(KERN_WARNING DRV_NAME "(%s): resetting: handshake failed\n",
+		pci_name(hba->pdev));
+	return -1;
+}
+
+static int stex_reset(struct scsi_cmnd *cmd)
+{
+	struct st_hba *hba;
+
+	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
+
+	printk(KERN_INFO DRV_NAME
+		"(%s): resetting host\n", pci_name(hba->pdev));
+	scsi_print_command(cmd);
+
+	return stex_do_reset(hba) ? FAILED : SUCCESS;
+}
+
+static void stex_reset_work(struct work_struct *work)
+{
+	struct st_hba *hba = container_of(work, struct st_hba, reset_work);
+
+	stex_do_reset(hba);
 }
 
 static int stex_biosparam(struct scsi_device *sdev,
@@ -1583,12 +1650,24 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	hba->host = host;
 	hba->pdev = pdev;
+	init_waitqueue_head(&hba->reset_waitq);
+
+	snprintf(hba->work_q_name, sizeof(hba->work_q_name),
+		 "stex_wq_%d", host->host_no);
+	hba->work_q = create_singlethread_workqueue(hba->work_q_name);
+	if (!hba->work_q) {
+		printk(KERN_ERR DRV_NAME "(%s): create workqueue failed\n",
+			pci_name(pdev));
+		err = -ENOMEM;
+		goto out_ccb_free;
+	}
+	INIT_WORK(&hba->reset_work, stex_reset_work);
 
 	err = stex_request_irq(hba);
 	if (err) {
 		printk(KERN_ERR DRV_NAME "(%s): request irq failed\n",
 			pci_name(pdev));
-		goto out_ccb_free;
+		goto out_free_wq;
 	}
 
 	err = stex_handshake(hba);
@@ -1617,6 +1696,8 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 out_free_irq:
 	stex_free_irq(hba);
+out_free_wq:
+	destroy_workqueue(hba->work_q);
 out_ccb_free:
 	kfree(hba->ccb);
 out_pci_free:
@@ -1684,6 +1765,8 @@ static void stex_hba_free(struct st_hba *hba)
 {
 	stex_free_irq(hba);
 
+	destroy_workqueue(hba->work_q);
+
 	iounmap(hba->mmio_base);
 
 	pci_release_regions(hba->pdev);


