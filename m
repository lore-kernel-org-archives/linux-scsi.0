From: akpm@linux-foundation.org
Subject: [patch 19/19] scsi: lpfc, fix memory leak
Date: Mon, 21 Dec 2009 16:27:55 -0800
Message-ID: <200912220027.nBM0Rtko005431@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618AbZLVAcN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2009 19:32:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jirislaby@gmail.com, james.smart@emulex.com

From: Jiri Slaby <jirislaby@gmail.com>

Stanse found a memory leak on one fail path in lpfc_sli4_read_rev.

Add there kfree.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_sli.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/lpfc/lpfc_sli.c~scsi-lpfc-fix-memory-leak drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c~scsi-lpfc-fix-memory-leak
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -4110,6 +4110,7 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba
 	if (rc) {
 		dma_free_coherent(&phba->pcidev->dev, dma_size,
 				  dmabuf->virt, dmabuf->phys);
+		kfree(dmabuf);
 		return -EIO;
 	}
 
_
