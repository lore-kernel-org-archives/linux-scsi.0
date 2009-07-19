From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 3/8] lpfc 8.3.4: Various SLI3 fixes
Date: Sun, 19 Jul 2009 10:01:16 -0400
Message-ID: <1248012076.15009.26.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34682 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbZGSOBR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2009 10:01:17 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n6JE1HWr021582
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2009 07:01:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Various SLI3 fixes

- Fix for firmware dump failure
- Fix inband remote management

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc.h      |    1 +
 drivers/scsi/lpfc/lpfc_init.c |    3 ---
 drivers/scsi/lpfc/lpfc_mem.c  |   41 +++++++++++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_sli.c  |    2 +-
 4 files changed, 31 insertions(+), 16 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -685,6 +685,7 @@ struct lpfc_hba {
 	struct pci_pool *lpfc_mbuf_pool;
 	struct pci_pool *lpfc_hrb_pool;	/* header receive buffer pool */
 	struct pci_pool *lpfc_drb_pool; /* data receive buffer pool */
+	struct pci_pool *lpfc_hbq_pool;	/* SLI3 hbq buffer pool */
 	struct lpfc_dma_pool lpfc_mbuf_safety_pool;
 
 	mempool_t *mbox_mem_pool;
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -527,9 +527,6 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	/* Set up error attention (ERATT) polling timer */
 	mod_timer(&phba->eratt_poll, jiffies + HZ * LPFC_ERATT_POLL_INTERVAL);
 
-	/* Check if the port is disabled */
-	lpfc_sli_read_serdes_param(phba);
-
 	if (phba->hba_flag & LINK_DISABLED) {
 		lpfc_printf_log(phba,
 			KERN_ERR, LOG_INIT,
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -110,17 +110,28 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 						sizeof(struct lpfc_nodelist));
 	if (!phba->nlp_mem_pool)
 		goto fail_free_mbox_pool;
-	phba->lpfc_hrb_pool = pci_pool_create("lpfc_hrb_pool",
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		phba->lpfc_hrb_pool = pci_pool_create("lpfc_hrb_pool",
 					      phba->pcidev,
 					      LPFC_HDR_BUF_SIZE, align, 0);
-	if (!phba->lpfc_hrb_pool)
-		goto fail_free_nlp_mem_pool;
-	phba->lpfc_drb_pool = pci_pool_create("lpfc_drb_pool",
+		if (!phba->lpfc_hrb_pool)
+			goto fail_free_nlp_mem_pool;
+
+		phba->lpfc_drb_pool = pci_pool_create("lpfc_drb_pool",
 					      phba->pcidev,
 					      LPFC_DATA_BUF_SIZE, align, 0);
-	if (!phba->lpfc_drb_pool)
-		goto fail_free_hbq_pool;
-
+		if (!phba->lpfc_drb_pool)
+			goto fail_free_hrb_pool;
+		phba->lpfc_hbq_pool = NULL;
+	} else {
+		phba->lpfc_hbq_pool = pci_pool_create("lpfc_hbq_pool",
+			phba->pcidev, LPFC_BPL_SIZE, align, 0);
+		if (!phba->lpfc_hbq_pool)
+			goto fail_free_nlp_mem_pool;
+		phba->lpfc_hrb_pool = NULL;
+		phba->lpfc_drb_pool = NULL;
+	}
 	/* vpi zero is reserved for the physical port so add 1 to max */
 	longs = ((phba->max_vpi + 1) + BITS_PER_LONG - 1) / BITS_PER_LONG;
 	phba->vpi_bmask = kzalloc(longs * sizeof(unsigned long), GFP_KERNEL);
@@ -132,7 +143,7 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
  fail_free_dbq_pool:
 	pci_pool_destroy(phba->lpfc_drb_pool);
 	phba->lpfc_drb_pool = NULL;
- fail_free_hbq_pool:
+ fail_free_hrb_pool:
 	pci_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
  fail_free_nlp_mem_pool:
@@ -176,11 +187,17 @@ lpfc_mem_free(struct lpfc_hba *phba)
 
 	/* Free HBQ pools */
 	lpfc_sli_hbqbuf_free_all(phba);
-	pci_pool_destroy(phba->lpfc_drb_pool);
+	if (phba->lpfc_drb_pool)
+		pci_pool_destroy(phba->lpfc_drb_pool);
 	phba->lpfc_drb_pool = NULL;
-	pci_pool_destroy(phba->lpfc_hrb_pool);
+	if (phba->lpfc_hrb_pool)
+		pci_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
 
+	if (phba->lpfc_hbq_pool)
+		pci_pool_destroy(phba->lpfc_hbq_pool);
+	phba->lpfc_hbq_pool = NULL;
+
 	/* Free NLP memory pool */
 	mempool_destroy(phba->nlp_mem_pool);
 	phba->nlp_mem_pool = NULL;
@@ -380,7 +397,7 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba)
 	if (!hbqbp)
 		return NULL;
 
-	hbqbp->dbuf.virt = pci_pool_alloc(phba->lpfc_hrb_pool, GFP_KERNEL,
+	hbqbp->dbuf.virt = pci_pool_alloc(phba->lpfc_hbq_pool, GFP_KERNEL,
 					  &hbqbp->dbuf.phys);
 	if (!hbqbp->dbuf.virt) {
 		kfree(hbqbp);
@@ -405,7 +422,7 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba)
 void
 lpfc_els_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp)
 {
-	pci_pool_free(phba->lpfc_hrb_pool, hbqbp->dbuf.virt, hbqbp->dbuf.phys);
+	pci_pool_free(phba->lpfc_hbq_pool, hbqbp->dbuf.virt, hbqbp->dbuf.phys);
 	kfree(hbqbp);
 	return;
 }
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4702,13 +4702,13 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 
 	spin_lock_irqsave(&phba->hbalock, drvr_flag);
 	if (!pmbox) {
+		phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 		/* processing mbox queue from intr_handler */
 		if (unlikely(psli->sli_flag & LPFC_SLI_ASYNC_MBX_BLK)) {
 			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 			return MBX_SUCCESS;
 		}
 		processing_queue = 1;
-		phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 		pmbox = lpfc_mbox_get(phba);
 		if (!pmbox) {
 			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);


