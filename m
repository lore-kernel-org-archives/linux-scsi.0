From: James Smart <james.smart@emulex.com>
Subject: [PATCH 14/18] lpfc 8.3.42: Fixed failure to allocate SCSI buffer on
 PPC64 platform for SLI4 devices
Date: Fri, 6 Sep 2013 12:21:50 -0400
Message-ID: <1378484510.14051.33.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:49816 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab3IFQW2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:22:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed failure to allocate SCSI buffer on PPC64 platform for SLI4 devices


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:08.267058402 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:26.569058818 -0400
@@ -1000,9 +1000,12 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 		}
 		memset(psb->data, 0, phba->cfg_sg_dma_buf_size);
 
-		/* Page alignment is CRITICAL, double check to be sure */
-		if (((unsigned long)(psb->data) &
-		    (unsigned long)(SLI4_PAGE_SIZE - 1)) != 0) {
+		/*
+		 * 4K Page alignment is CRITICAL to BlockGuard, double check
+		 * to be sure.
+		 */
+		if (phba->cfg_enable_bg  && (((unsigned long)(psb->data) &
+		    (unsigned long)(SLI4_PAGE_SIZE - 1)) != 0)) {
 			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
 				      psb->data, psb->dma_handle);
 			kfree(psb);



