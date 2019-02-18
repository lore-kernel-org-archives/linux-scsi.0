From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/8] hisi_sas: fix calls to dma_set_mask_and_coherent()
Date: Mon, 18 Feb 2019 08:34:25 +0100
Message-ID: <20190218073426.111853-8-hare@suse.de>
References: <20190218073426.111853-1-hare@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190218073426.111853-1-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

The change to use dma_set_mask_and_coherent() incorrectly made a second
call with the 32 bit DMA mask value when the call with the 64 bit DMA
mask value succeeded.  This resulted in FC connections failing due
to corrupted data buffers, and various other SCSI/FCP I/O errors.

Fixes: e4db40e7a1a2 ("scsi: hisi_sas: use dma_set_mask_and_coherent")
Cc: <stable@vger.kernel.org>
Suggested-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 8 ++++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 8 +++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 923296653ed7..13ca5a0bdf6b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2484,6 +2484,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	struct Scsi_Host *shost;
 	struct hisi_hba *hisi_hba;
 	struct device *dev = &pdev->dev;
+	int error;
 
 	shost = scsi_host_alloc(hw->sht, sizeof(*hisi_hba));
 	if (!shost) {
@@ -2504,8 +2505,11 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
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
index 00738d0673fe..79390f235c7e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2742,10 +2742,12 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
 
-- 
2.16.4
