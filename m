From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 3/6] scsi: lpfc: Cocci spatch "pool_zalloc-simple"
Date: Thu, 21 Sep 2017 08:15:26 +0200
Message-ID: <1505974468535-735692655-3-diffsplit-thomas@m3y3r.de>
References: <1505974468535-2047238743-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505974468535-2047238743-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.
Found by coccinelle spatch "api/alloc/pool_zalloc-simple.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1938,14 +1938,13 @@ lpfc_new_nvme_buf(struct lpfc_vport *vpo
 		 * pci bus space for an I/O. The DMA buffer includes the
 		 * number of SGE's necessary to support the sg_tablesize.
 		 */
-		lpfc_ncmd->data = dma_pool_alloc(phba->lpfc_sg_dma_buf_pool,
-						 GFP_KERNEL,
-						 &lpfc_ncmd->dma_handle);
+		lpfc_ncmd->data = dma_pool_zalloc(phba->lpfc_sg_dma_buf_pool,
+						  GFP_KERNEL,
+						  &lpfc_ncmd->dma_handle);
 		if (!lpfc_ncmd->data) {
 			kfree(lpfc_ncmd);
 			break;
 		}
-		memset(lpfc_ncmd->data, 0, phba->cfg_sg_dma_buf_size);
 
 		lxri = lpfc_sli4_next_xritag(phba);
 		if (lxri == NO_XRI) {
