From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH] scsi: lpfc error path fix
Date: Tue, 2 Jan 2007 01:07:32 +0100
Message-ID: <200701020107.32742.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932573AbXABAGN@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

	Add kmalloc failure check and fix the loop on error path. Without the
patch pool element at index [0] will not be freed.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_mem.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -upr linux-2.6.20-rc2-mm1-a/drivers/scsi/lpfc/lpfc_mem.c linux-2.6.20-rc2-mm1-b/drivers/scsi/lpfc/lpfc_mem.c
--- linux-2.6.20-rc2-mm1-a/drivers/scsi/lpfc/lpfc_mem.c	2006-12-24 05:00:32.000000000 +0100
+++ linux-2.6.20-rc2-mm1-b/drivers/scsi/lpfc/lpfc_mem.c	2007-01-02 00:17:25.000000000 +0100
@@ -56,6 +56,9 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
 
 	pool->elements = kmalloc(sizeof(struct lpfc_dmabuf) *
 					 LPFC_MBUF_POOL_SIZE, GFP_KERNEL);
+	if (!pool->elements)
+		goto fail_free_lpfc_mbuf_pool;
+
 	pool->max_count = 0;
 	pool->current_count = 0;
 	for ( i = 0; i < LPFC_MBUF_POOL_SIZE; i++) {
@@ -82,10 +85,11 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
  fail_free_mbox_pool:
 	mempool_destroy(phba->mbox_mem_pool);
  fail_free_mbuf_pool:
-	while (--i)
+	while (i--)
 		pci_pool_free(phba->lpfc_mbuf_pool, pool->elements[i].virt,
 						 pool->elements[i].phys);
 	kfree(pool->elements);
+ fail_free_lpfc_mbuf_pool:
 	pci_pool_destroy(phba->lpfc_mbuf_pool);
  fail_free_dma_buf_pool:
 	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);


-- 
Regards,

	Mariusz Kozlowski
