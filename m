From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 4/9][RESEND] mvsas: check hd whether unplugged
Date: Thu, 27 Mar 2008 14:54:50 +0800
Message-ID: <47EB44BA.2060505@marvell.com>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:45348 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753635AbYC0Gyx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 02:54:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

if unplugged, driver's queuecommand function will return SAS_PHY_DOWN.
task->lldd_task is used for saving its slot info.

Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |   76 +++++++++++++++++++++++++++++--------------------
 1 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index f302970..ebfe164 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -1784,15 +1784,19 @@ static u8 mvs_assign_reg_set(struct mvs_info *mvi, struct mvs_port *port)
 	return MVS_ID_NOT_MAPPED;
 }
 
-static u32 mvs_get_ncq_tag(struct sas_task *task)
+static u32 mvs_get_ncq_tag(struct sas_task *task, u32 *tag)
 {
-	u32 tag = 0;
 	struct ata_queued_cmd *qc = task->uldd_task;
 
-	if (qc)
-		tag = qc->tag;
+	if (qc) {
+		if (qc->tf.command == ATA_CMD_FPDMA_WRITE ||
+			qc->tf.command == ATA_CMD_FPDMA_READ) {
+			*tag = qc->tag;
+			return 1;
+		}
+	}
 
-	return tag;
+	return 0;
 }
 
 static int mvs_task_prep_ata(struct mvs_info *mvi,
@@ -1836,11 +1840,9 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	hdr->flags = cpu_to_le32(flags);
 
 	/* FIXME: the low order order 5 bits for the TAG if enable NCQ */
-	if (task->ata_task.use_ncq) {
-		hdr->tags = cpu_to_le32(mvs_get_ncq_tag(task));
-		/*Fill in task file */
-		task->ata_task.fis.sector_count = hdr->tags << 3;
-	} else
+	if (task->ata_task.use_ncq && mvs_get_ncq_tag(task, &hdr->tags))
+		task->ata_task.fis.sector_count |= hdr->tags << 3;
+	else
 		hdr->tags = cpu_to_le32(tag);
 	hdr->data_len = cpu_to_le32(task->total_xfer_len);
 
@@ -1933,13 +1935,16 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	u32 flags;
 	u32 resp_len, req_len, i, tag = tei->tag;
 	const u32 max_resp_len = SB_RFB_MAX;
+	u8 phy_mask;
 
 	slot = &mvi->slot_info[tag];
 
+	phy_mask = (port->wide_port_phymap) ? port->wide_port_phymap :
+		task->dev->port->phy_mask;
 	slot->tx = mvi->tx_prod;
 	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
 				(TXQ_CMD_SSP << TXQ_CMD_SHIFT) |
-				(port->wide_port_phymap << TXQ_PHY_SHIFT));
+				(phy_mask << TXQ_PHY_SHIFT));
 
 	flags = MCH_RETRY;
 	if (task->ssp_task.enable_first_burst) {
@@ -2040,22 +2045,32 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
 	void __iomem *regs = mvi->regs;
 	struct mvs_task_exec_info tei;
 	struct sas_task *t = task;
+	struct mvs_slot_info *slot;
 	u32 tag = 0xdeadbeef, rc, n_elem = 0;
 	unsigned long flags;
 	u32 n = num, pass = 0;
 
 	spin_lock_irqsave(&mvi->lock, flags);
-
 	do {
+		dev = t->dev;
 		tei.port = &mvi->port[dev->port->id];
 
 		if (!tei.port->port_attached) {
-			struct task_status_struct *ts = &t->task_status;
-			ts->stat = SAS_PHY_DOWN;
-			t->task_done(t);
-			rc = 0;
-			goto exec_exit;
+			if (sas_protocol_ata(t->task_proto)) {
+				rc = SAS_PHY_DOWN;
+				goto out_done;
+			} else {
+				struct task_status_struct *ts = &t->task_status;
+				ts->resp = SAS_TASK_UNDELIVERED;
+				ts->stat = SAS_PHY_DOWN;
+				t->task_done(t);
+				if (n > 1)
+					t = list_entry(t->list.next,
+							struct sas_task, list);
+				continue;
+			}
 		}
+
 		if (!sas_protocol_ata(t->task_proto)) {
 			if (t->num_scatter) {
 				n_elem = pci_map_sg(mvi->pdev, t->scatter,
@@ -2074,9 +2089,10 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
 		if (rc)
 			goto err_out;
 
-		mvi->slot_info[tag].task = t;
-		mvi->slot_info[tag].n_elem = n_elem;
-		memset(mvi->slot_info[tag].buf, 0, MVS_SLOT_BUF_SZ);
+		slot = &mvi->slot_info[tag];
+		t->lldd_task = NULL;
+		slot->n_elem = n_elem;
+		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
 		tei.task = t;
 		tei.hdr = &mvi->slot[tag];
 		tei.tag = tag;
@@ -2105,28 +2121,26 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
 		if (rc)
 			goto err_out_tag;
 
+		slot->task = t;
+		slot->port = tei.port;
+		t->lldd_task = (void *) slot;
+		list_add_tail(&slot->list, &slot->port->list);
 		/* TODO: select normal or high priority */
 
 		spin_lock(&t->task_state_lock);
 		t->task_state_flags |= SAS_TASK_AT_INITIATOR;
 		spin_unlock(&t->task_state_lock);
 
-		if (n == 1) {
-			spin_unlock_irqrestore(&mvi->lock, flags);
-			mw32(TX_PROD_IDX, mvi->tx_prod);
-		}
 		mvs_hba_memory_dump(mvi, tag, t->task_proto);
 
 		++pass;
 		mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
-
-		if (n == 1)
-			break;
-
-		t = list_entry(t->list.next, struct sas_task, list);
+		if (n > 1)
+			t = list_entry(t->list.next, struct sas_task, list);
 	} while (--n);
 
-	return 0;
+	rc = 0;
+	goto out_done;
 
 err_out_tag:
 	mvs_tag_free(mvi, tag);
@@ -2136,7 +2150,7 @@ err_out:
 		if (n_elem)
 			pci_unmap_sg(mvi->pdev, t->scatter, n_elem,
 				     t->data_dir);
-exec_exit:
+out_done:
 	if (pass)
 		mw32(TX_PROD_IDX, (mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
 	spin_unlock_irqrestore(&mvi->lock, flags);
-- 
1.5.4



