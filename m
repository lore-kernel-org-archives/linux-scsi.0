From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 5/8] bfa: fix calls to dma_set_mask_and_coherent()
Date: Mon, 25 Feb 2019 19:34:23 -0500 (EST)
Message-ID: <999117296.3870120.1551141263203.JavaMail.zimbra@redhat.com>
References: <20190218073426.111853-1-hare@suse.de> <20190218073426.111853-6-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190218073426.111853-6-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The change to use dma_set_mask_and_coherent() incorrectly made a second
call with the 32 bit DMA mask value when the call with the 64 bit DMA
mask value succeeded.  This resulted in FC connections failing due
to corrupted data buffers, and various other SCSI/FCP I/O errors.

Fixes: a69b080025ea ("scsi: bfa: use dma_set_mask_and_coherent")
Cc: <stable@vger.kernel.org>
Suggested-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/bfa/bfad.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 42a0caf6740d..88880a66a189 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -727,7 +727,7 @@ bfad_init_timer(struct bfad_s *bfad)
 int
 bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 {
-	int		rc = -ENODEV;
+	int rc = -ENODEV;
 
 	if (pci_enable_device(pdev)) {
 		printk(KERN_ERR "pci_enable_device fail %p\n", pdev);
@@ -739,8 +739,12 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 
 	pci_set_master(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (rc)
+		rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+
+	if (rc) {
+		rc = -ENODEV;
 		printk(KERN_ERR "dma_set_mask_and_coherent fail %p\n", pdev);
 		goto out_release_region;
 	}
@@ -1534,6 +1538,7 @@ bfad_pci_slot_reset(struct pci_dev *pdev)
 {
 	struct bfad_s *bfad = pci_get_drvdata(pdev);
 	u8 byte;
+	int rc;
 
 	dev_printk(KERN_ERR, &pdev->dev,
 		   "bfad_pci_slot_reset flags: 0x%x\n", bfad->bfad_flags);
@@ -1561,8 +1566,11 @@ bfad_pci_slot_reset(struct pci_dev *pdev)
 	pci_save_state(pdev);
 	pci_set_master(pdev);
 
-	if (dma_set_mask_and_coherent(&bfad->pcidev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&bfad->pcidev->dev, DMA_BIT_MASK(32)))
+	rc = dma_set_mask_and_coherent(&bfad->pcidev->dev, DMA_BIT_MASK(64));
+	if (rc)
+		rc = dma_set_mask_and_coherent(&bfad->pcidev->dev,
+					       DMA_BIT_MASK(32));
+	if (rc)
 		goto out_disable_device;
 
 	if (restart_bfa(bfad) == -1)
-- 
2.16.4

Can we remove the last sentence "This resulted in...", Martin?

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
