From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: lpfc: Fix a possible sleep-in-atomic-context bug in lpfc_mbuf_alloc()
Date: Sat, 15 Sep 2018 11:42:00 +0800
Message-ID: <20180915034200.6706-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The driver may sleep with holding a spinlock.
The function call path (from bottom to top) in Linux-4.17 is:

[FUNC] dma_pool_alloc(GFP_KERNEL)
drivers/scsi/lpfc/lpfc_mem.c, 400: 
	dma_pool_alloc in lpfc_mbuf_alloc
drivers/scsi/lpfc/lpfc_els.c, 228: 
	lpfc_mbuf_alloc in lpfc_prep_els_iocb
drivers/scsi/lpfc/lpfc_els.c, 2010: 
	lpfc_prep_els_iocb in lpfc_issue_els_plogi
drivers/scsi/lpfc/lpfc_els.c, 4914: 
	lpfc_issue_els_plogi in lpfc_els_disc_plogi
drivers/scsi/lpfc/lpfc_els.c, 1486: 
	lpfc_els_disc_plogi in lpfc_more_plogi
drivers/scsi/lpfc/lpfc_els.c, 3123: 
	lpfc_more_plogi in lpfc_cancel_retry_delay_tmo
drivers/scsi/lpfc/lpfc_nportdisc.c, 279: 
	lpfc_cancel_retry_delay_tmo in lpfc_els_abort
drivers/scsi/lpfc/lpfc_nportdisc.c, 236: 
	spin_lock_irq in lpfc_els_abort

To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.

This bug is found by my static analysis tool DSAC.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/lpfc/lpfc_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 9c22a2c93462..7eae5508bfa3 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -398,7 +398,7 @@ lpfc_mbuf_alloc(struct lpfc_hba *phba, int mem_flags, dma_addr_t *handle)
 	unsigned long iflags;
 	void *ret;
 
-	ret = dma_pool_alloc(phba->lpfc_mbuf_pool, GFP_KERNEL, handle);
+	ret = dma_pool_alloc(phba->lpfc_mbuf_pool, GFP_ATOMIC, handle);
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	if (!ret && (mem_flags & MEM_PRI) && pool->current_count) {
-- 
2.17.0
