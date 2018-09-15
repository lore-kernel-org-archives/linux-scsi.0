From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: lpfc: Fix three sleep-in-atomic-context bugs in lpfc_sli4_nvmet_alloc()
Date: Sat, 15 Sep 2018 11:41:15 +0800
Message-ID: <20180915034115.6543-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The driver may sleep with holding a spinlock.
The function call paths (from bottom to top) in Linux-4.17 are:

[FUNC] kzalloc(GFP_KERNEL)
drivers/scsi/lpfc/lpfc_mem.c, 633: 
	kzalloc in lpfc_sli4_nvmet_alloc
drivers/scsi/lpfc/lpfc_sli.c, 6729: 
	[FUNC_PTR]lpfc_sli4_nvmet_alloc in lpfc_post_rq_buffer
drivers/scsi/lpfc/lpfc_sli.c, 6723: 
	_raw_spin_lock_irqsave in lpfc_post_rq_buffer

[FUNC] dma_pool_alloc(GFP_KERNEL)
drivers/scsi/lpfc/lpfc_mem.c, 637: 
	dma_pool_alloc in lpfc_sli4_nvmet_alloc
drivers/scsi/lpfc/lpfc_sli.c, 6729: 
	[FUNC_PTR]lpfc_sli4_nvmet_alloc in lpfc_post_rq_buffer
drivers/scsi/lpfc/lpfc_sli.c, 6723: 
	_raw_spin_lock_irqsave in lpfc_post_rq_buffer

[FUNC] dma_pool_alloc(GFP_KERNEL)
drivers/scsi/lpfc/lpfc_mem.c, 643: 
	dma_pool_alloc in lpfc_sli4_nvmet_alloc
drivers/scsi/lpfc/lpfc_sli.c, 6729: 
	[FUNC_PTR]lpfc_sli4_nvmet_alloc in lpfc_post_rq_buffer
drivers/scsi/lpfc/lpfc_sli.c, 6723: 
	_raw_spin_lock_irqsave in lpfc_post_rq_buffer

Note that [FUNC_PTR] means a function pointer call is used.

To fix these bugs, GFP_KERNEL is replaced with GFP_ATOMIC.

These bugs are found by my static analysis tool DSAC.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/lpfc/lpfc_mem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 9c22a2c93462..20359e5d0016 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -631,18 +631,18 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
 {
 	struct rqb_dmabuf *dma_buf;
 
-	dma_buf = kzalloc(sizeof(struct rqb_dmabuf), GFP_KERNEL);
+	dma_buf = kzalloc(sizeof(struct rqb_dmabuf), GFP_ATOMIC);
 	if (!dma_buf)
 		return NULL;
 
-	dma_buf->hbuf.virt = dma_pool_alloc(phba->lpfc_hrb_pool, GFP_KERNEL,
+	dma_buf->hbuf.virt = dma_pool_alloc(phba->lpfc_hrb_pool, GFP_ATOMIC,
 					    &dma_buf->hbuf.phys);
 	if (!dma_buf->hbuf.virt) {
 		kfree(dma_buf);
 		return NULL;
 	}
 	dma_buf->dbuf.virt = dma_pool_alloc(phba->lpfc_nvmet_drb_pool,
-					    GFP_KERNEL, &dma_buf->dbuf.phys);
+					    GFP_ATOMIC, &dma_buf->dbuf.phys);
 	if (!dma_buf->dbuf.virt) {
 		dma_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
 			      dma_buf->hbuf.phys);
-- 
2.17.0
