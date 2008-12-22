From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] eata: fix the data buffer accessors conversion regression
Date: Tue, 23 Dec 2008 04:01:35 +0900
Message-ID: <20081223034945V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:52743 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbYLVTBq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2008 14:01:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, arthur.marsh@internode.on.net

This fixes the regression introduced by the commit
58e2a02eb18393e76a469580fedf7caec190eb5e (eata: convert to use the
data buffer accessors), reported:

http://marc.info/?t=122987621300006&r=1&w=2

- fix DMA_NONE handling in map_dma()

- this driver can't use scsi_dma_map since host->shost_gendev.parent
is not set properly (it uses scsi_register).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: stable@kernel.org
---
 drivers/scsi/eata.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index a73a6bb..976cdd5 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1626,8 +1626,15 @@ static void map_dma(unsigned int i, struct hostdata *ha)
 
 	cpp->sense_len = SCSI_SENSE_BUFFERSIZE;
 
-	count = scsi_dma_map(SCpnt);
-	BUG_ON(count < 0);
+	if (!scsi_sg_count(SCpnt)) {
+		cpp->data_len = 0;
+		return;
+	}
+
+	count = pci_map_sg(ha->pdev, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
+			   pci_dir);
+	BUG_ON(!count);
+
 	scsi_for_each_sg(SCpnt, sg, count, k) {
 		cpp->sglist[k].address = H2DEV(sg_dma_address(sg));
 		cpp->sglist[k].num_bytes = H2DEV(sg_dma_len(sg));
@@ -1655,7 +1662,9 @@ static void unmap_dma(unsigned int i, struct hostdata *ha)
 		pci_unmap_single(ha->pdev, DEV2H(cpp->sense_addr),
 				 DEV2H(cpp->sense_len), PCI_DMA_FROMDEVICE);
 
-	scsi_dma_unmap(SCpnt);
+	if (scsi_sg_count(SCpnt))
+		pci_unmap_sg(ha->pdev, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
+			     pci_dir);
 
 	if (!DEV2H(cpp->data_len))
 		pci_dir = PCI_DMA_BIDIRECTIONAL;
-- 
1.5.5.GIT

