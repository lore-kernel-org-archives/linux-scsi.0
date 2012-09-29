From: James Smart <james.smart@emulex.com>
Subject: [PATCH 02/16] lpfc 8.3.35: Added checking BMBX register for RDY bit
 before writing the first address in
Date: Sat, 29 Sep 2012 11:29:06 -0400
Message-ID: <1348932546.23909.21.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:33774 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab2I2Pei (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:34:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Added checking BMBX register for RDY bit before writing the first address in


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   75 ++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 28 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-09-26 21:11:18.464153500 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-09-26 21:11:28.318153726 -0400
@@ -7072,6 +7072,40 @@ lpfc_sli4_async_mbox_unblock(struct lpfc
 }
 
 /**
+ * lpfc_sli4_wait_bmbx_ready - Wait for bootstrap mailbox register ready
+ * @phba: Pointer to HBA context object.
+ * @mboxq: Pointer to mailbox object.
+ *
+ * The function waits for the bootstrap mailbox register ready bit from
+ * port for twice the regular mailbox command timeout value.
+ *
+ *      0 - no timeout on waiting for bootstrap mailbox register ready.
+ *      MBXERR_ERROR - wait for bootstrap mailbox register timed out.
+ **/
+static int
+lpfc_sli4_wait_bmbx_ready(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	uint32_t db_ready;
+	unsigned long timeout;
+	struct lpfc_register bmbx_reg;
+
+	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mboxq)
+				   * 1000) + jiffies;
+
+	do {
+		bmbx_reg.word0 = readl(phba->sli4_hba.BMBXregaddr);
+		db_ready = bf_get(lpfc_bmbx_rdy, &bmbx_reg);
+		if (!db_ready)
+			msleep(2);
+
+		if (time_after(jiffies, timeout))
+			return MBXERR_ERROR;
+	} while (!db_ready);
+
+	return 0;
+}
+
+/**
  * lpfc_sli4_post_sync_mbox - Post an SLI4 mailbox to the bootstrap mailbox
  * @phba: Pointer to HBA context object.
  * @mboxq: Pointer to mailbox object.
@@ -7092,15 +7126,12 @@ lpfc_sli4_post_sync_mbox(struct lpfc_hba
 {
 	int rc = MBX_SUCCESS;
 	unsigned long iflag;
-	uint32_t db_ready;
 	uint32_t mcqe_status;
 	uint32_t mbx_cmnd;
-	unsigned long timeout;
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_mqe *mb = &mboxq->u.mqe;
 	struct lpfc_bmbx_create *mbox_rgn;
 	struct dma_address *dma_address;
-	struct lpfc_register bmbx_reg;
 
 	/*
 	 * Only one mailbox can be active to the bootstrap mailbox region
@@ -7124,6 +7155,11 @@ lpfc_sli4_post_sync_mbox(struct lpfc_hba
 	phba->sli.mbox_active = mboxq;
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 
+	/* wait for bootstrap mbox register for readyness */
+	rc = lpfc_sli4_wait_bmbx_ready(phba, mboxq);
+	if (rc)
+		goto exit;
+
 	/*
 	 * Initialize the bootstrap memory region to avoid stale data areas
 	 * in the mailbox post.  Then copy the caller's mailbox contents to
@@ -7138,35 +7174,18 @@ lpfc_sli4_post_sync_mbox(struct lpfc_hba
 	dma_address = &phba->sli4_hba.bmbx.dma_address;
 	writel(dma_address->addr_hi, phba->sli4_hba.BMBXregaddr);
 
-	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mboxq)
-				   * 1000) + jiffies;
-	do {
-		bmbx_reg.word0 = readl(phba->sli4_hba.BMBXregaddr);
-		db_ready = bf_get(lpfc_bmbx_rdy, &bmbx_reg);
-		if (!db_ready)
-			msleep(2);
-
-		if (time_after(jiffies, timeout)) {
-			rc = MBXERR_ERROR;
-			goto exit;
-		}
-	} while (!db_ready);
+	/* wait for bootstrap mbox register for hi-address write done */
+	rc = lpfc_sli4_wait_bmbx_ready(phba, mboxq);
+	if (rc)
+		goto exit;
 
 	/* Post the low mailbox dma address to the port. */
 	writel(dma_address->addr_lo, phba->sli4_hba.BMBXregaddr);
-	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mboxq)
-				   * 1000) + jiffies;
-	do {
-		bmbx_reg.word0 = readl(phba->sli4_hba.BMBXregaddr);
-		db_ready = bf_get(lpfc_bmbx_rdy, &bmbx_reg);
-		if (!db_ready)
-			msleep(2);
 
-		if (time_after(jiffies, timeout)) {
-			rc = MBXERR_ERROR;
-			goto exit;
-		}
-	} while (!db_ready);
+	/* wait for bootstrap mbox register for low address write done */
+	rc = lpfc_sli4_wait_bmbx_ready(phba, mboxq);
+	if (rc)
+		goto exit;
 
 	/*
 	 * Read the CQ to ensure the mailbox has completed.



