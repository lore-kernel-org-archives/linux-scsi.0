From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.0-rc7
Date: Sat, 02 Mar 2019 07:49:48 -0800
Message-ID: <1551541788.5893.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Nine small fixes.  The resume fix is a cosmetic removal of a warning
with an incorrect condition causing it to alarm people wrongly.  The
other eight patches correct a thinko in Christoph Hellwig's DMA
conversion series.  Without it all these drivers end up with 32 bit DMA
masks meaning they bounce any page over 4GB before sending it to the
controller.  Nowadays, even laptops mostly have memory above 4GB, so
this can lead to significant performance degradation with all the
bouncing.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: core: Avoid that system resume triggers a kernel warning

Hannes Reinecke (8):
      scsi: hptiop: fix calls to dma_set_mask()
      scsi: hisi_sas: fix calls to dma_set_mask_and_coherent()
      scsi: csiostor: fix calls to dma_set_mask_and_coherent()
      scsi: bfa: fix calls to dma_set_mask_and_coherent()
      scsi: aic94xx: fix calls to dma_set_mask_and_coherent()
      scsi: 3w-sas: fix calls to dma_set_mask_and_coherent()
      scsi: 3w-9xxx: fix calls to dma_set_mask_and_coherent()
      scsi: lpfc: fix calls to dma_set_mask_and_coherent()

And the diffstat:

 drivers/scsi/3w-9xxx.c                 | 14 +++++++++-----
 drivers/scsi/3w-sas.c                  | 12 ++++++++----
 drivers/scsi/aic94xx/aic94xx_init.c    |  8 +++++---
 drivers/scsi/bfa/bfad.c                | 18 +++++++++++++-----
 drivers/scsi/csiostor/csio_init.c      |  7 +++++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  8 ++++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  8 +++++---
 drivers/scsi/hptiop.c                  | 10 +++++++---
 drivers/scsi/lpfc/lpfc_init.c          | 19 ++++++++++++-------
 drivers/scsi/scsi_lib.c                |  1 -
 10 files changed, 70 insertions(+), 35 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index a3c20e3a8b7c..3337b1e80412 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2009,7 +2009,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	struct Scsi_Host *host = NULL;
 	TW_Device_Extension *tw_dev;
 	unsigned long mem_addr, mem_len;
-	int retval = -ENODEV;
+	int retval;
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
@@ -2020,8 +2020,10 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (retval)
+		retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
 		retval = -ENODEV;
 		goto out_disable_device;
@@ -2240,8 +2242,10 @@ static int twa_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (retval)
+		retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x40, "Failed to set dma mask during resume");
 		retval = -ENODEV;
 		goto out_disable_device;
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index e8f5f7c63190..2d15b878bd94 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1572,8 +1572,10 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (retval)
+		retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x18, "Failed to set dma mask");
 		retval = -ENODEV;
 		goto out_disable_device;
@@ -1804,8 +1806,10 @@ static int twl_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (retval)
+		retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x25, "Failed to set dma mask during resume");
 		retval = -ENODEV;
 		goto out_disable_device;
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 07efcb9b5b94..bbdae67774f0 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -769,9 +769,11 @@ static int asd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (err)
 		goto Err_remove;
 
-	err = -ENODEV;
-	if (dma_set_mask_and_coherent(&dev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32))) {
+	err = dma_set_mask_and_coherent(&dev->dev, DMA_BIT_MASK(64));
+	if (err)
+		err = dma_set_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32));
+	if (err) {
+		err = -ENODEV;
 		asd_printk("no suitable DMA mask for %s\n", pci_name(dev));
 		goto Err_remove;
 	}
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
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index cf629380a981..616b25bf7941 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -210,8 +210,11 @@ csio_pci_init(struct pci_dev *pdev, int *bars)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	rv = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (rv)
+		rv = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (rv) {
+		rv = -ENODEV;
 		dev_err(&pdev->dev, "No suitable DMA available.\n");
 		goto err_release_regions;
 	}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index eed7fc5b3389..bc17fa0d8375 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2323,6 +2323,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	struct Scsi_Host *shost;
 	struct hisi_hba *hisi_hba;
 	struct device *dev = &pdev->dev;
+	int error;
 
 	shost = scsi_host_alloc(hw->sht, sizeof(*hisi_hba));
 	if (!shost) {
@@ -2343,8 +2344,11 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	if (hisi_sas_get_fw_info(hisi_hba) < 0)
 		goto err_out;
 
-	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) &&
-	    dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
+	error = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	if (error)
+		error = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+
+	if (error) {
 		dev_err(dev, "No usable DMA addressing method\n");
 		goto err_out;
 	}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index c92b3822c408..e0570fd8466e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2447,10 +2447,12 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		goto err_out_disable_device;
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (rc)
+		rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (rc) {
 		dev_err(dev, "No usable DMA addressing method\n");
-		rc = -EIO;
+		rc = -ENODEV;
 		goto err_out_regions;
 	}
 
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 3eedfd4f8f57..251c084a6ff0 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1292,6 +1292,7 @@ static int hptiop_probe(struct pci_dev *pcidev, const struct pci_device_id *id)
 	dma_addr_t start_phy;
 	void *start_virt;
 	u32 offset, i, req_size;
+	int rc;
 
 	dprintk("hptiop_probe(%p)\n", pcidev);
 
@@ -1308,9 +1309,12 @@ static int hptiop_probe(struct pci_dev *pcidev, const struct pci_device_id *id)
 
 	/* Enable 64bit DMA if possible */
 	iop_ops = (struct hptiop_adapter_ops *)id->driver_data;
-	if (dma_set_mask(&pcidev->dev,
-			 DMA_BIT_MASK(iop_ops->hw_dma_bit_mask)) ||
-	    dma_set_mask(&pcidev->dev, DMA_BIT_MASK(32))) {
+	rc = dma_set_mask(&pcidev->dev,
+			  DMA_BIT_MASK(iop_ops->hw_dma_bit_mask));
+	if (rc)
+		rc = dma_set_mask(&pcidev->dev, DMA_BIT_MASK(32));
+
+	if (rc) {
 		printk(KERN_ERR "hptiop: fail to set dma_mask\n");
 		goto disable_pci_device;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c1c36812c3d2..a588dfad4b11 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7361,15 +7361,18 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 	unsigned long bar0map_len, bar2map_len;
 	int i, hbq_count;
 	void *ptr;
-	int error = -ENODEV;
+	int error;
 
 	if (!pdev)
-		return error;
+		return -ENODEV;
 
 	/* Set the device DMA mask size */
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
+	error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (error)
+		error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (error)
 		return error;
+	error = -ENODEV;
 
 	/* Get the bus address of Bar0 and Bar2 and the number of bytes
 	 * required by each mapping.
@@ -9742,11 +9745,13 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 	uint32_t if_type;
 
 	if (!pdev)
-		return error;
+		return -ENODEV;
 
 	/* Set the device DMA mask size */
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
+	error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (error)
+		error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (error)
 		return error;
 
 	/*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f8d51c3d5582..a6828391d6b3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2598,7 +2598,6 @@ void scsi_device_resume(struct scsi_device *sdev)
 	 * device deleted during suspend)
 	 */
 	mutex_lock(&sdev->state_mutex);
-	WARN_ON_ONCE(!sdev->quiesced_by);
 	sdev->quiesced_by = NULL;
 	blk_clear_pm_only(sdev->request_queue);
 	if (sdev->sdev_state == SDEV_QUIESCE)
