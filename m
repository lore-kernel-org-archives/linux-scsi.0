From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: hpsa: Use 'pci_dma_mapping_error()' instead of 'dma_mapping_error()'
Date: Sat, 18 Feb 2017 20:07:36 +0100
Message-ID: <20170218190736.31555-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

Use 'pci_dma_mapping_error()' instead of 'dma_mapping_error()' because it
is more consistent with the rest of the code. It is also a little less
verbove.

While at it, remove some '(dma_addr_t)' casts in order to be consistent
within the file.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/hpsa.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 524a0c755ed7..bd9df28cc4f0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2169,7 +2169,7 @@ static int hpsa_map_ioaccel2_sg_chain_block(struct ctlr_info *h,
 	chain_size = le32_to_cpu(cp->sg[0].length);
 	temp64 = pci_map_single(h->pdev, chain_block, chain_size,
 				PCI_DMA_TODEVICE);
-	if (dma_mapping_error(&h->pdev->dev, temp64)) {
+	if (pci_dma_mapping_error(h->pdev, temp64)) {
 		/* prevent subsequent unmapping */
 		cp->sg->address = 0;
 		return -1;
@@ -2206,7 +2206,7 @@ static int hpsa_map_sg_chain_block(struct ctlr_info *h,
 	chain_sg->Len = cpu_to_le32(chain_len);
 	temp64 = pci_map_single(h->pdev, chain_block, chain_len,
 				PCI_DMA_TODEVICE);
-	if (dma_mapping_error(&h->pdev->dev, temp64)) {
+	if (pci_dma_mapping_error(h->pdev, temp64)) {
 		/* prevent subsequent unmapping */
 		chain_sg->Addr = cpu_to_le64(0);
 		return -1;
@@ -2743,7 +2743,7 @@ static int hpsa_map_one(struct pci_dev *pdev,
 	}
 
 	addr64 = pci_map_single(pdev, buf, buflen, data_direction);
-	if (dma_mapping_error(&pdev->dev, addr64)) {
+	if (pci_dma_mapping_error(pdev, addr64)) {
 		/* Prevent subsequent unmap of something never mapped */
 		cp->Header.SGList = 0;
 		cp->Header.SGTotal = cpu_to_le16(0);
@@ -6632,7 +6632,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	if (iocommand.buf_size > 0) {
 		temp64 = pci_map_single(h->pdev, buff,
 			iocommand.buf_size, PCI_DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(&h->pdev->dev, (dma_addr_t) temp64)) {
+		if (pci_dma_mapping_error(h->pdev, temp64)) {
 			c->SG[0].Addr = cpu_to_le64(0);
 			c->SG[0].Len = cpu_to_le32(0);
 			rc = -ENOMEM;
@@ -6759,8 +6759,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		for (i = 0; i < sg_used; i++) {
 			temp64 = pci_map_single(h->pdev, buff[i],
 				    buff_size[i], PCI_DMA_BIDIRECTIONAL);
-			if (dma_mapping_error(&h->pdev->dev,
-							(dma_addr_t) temp64)) {
+			if (pci_dma_mapping_error(h->pdev, temp64)) {
 				c->SG[i].Addr = cpu_to_le64(0);
 				c->SG[i].Len = cpu_to_le32(0);
 				hpsa_pci_unmap(h->pdev, c, i,
-- 
2.9.3
