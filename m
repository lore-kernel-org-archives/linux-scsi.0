From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] media/cobalt: use pci_irq_allocate_vectors
Date: Sun, 11 Sep 2016 15:31:28 +0200
Message-ID: <1473600688-24043-7-git-send-email-hch@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473600688-24043-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Simply the interrupt setup by using the new PCI layer helpers.

Despite using pci_enable_msi_range, this driver was only requesting a
single MSI vector anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/media/pci/cobalt/cobalt-driver.c | 8 ++------
 drivers/media/pci/cobalt/cobalt-driver.h | 2 --
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 476f7f0..5a0a9e4 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -307,9 +307,7 @@ static void cobalt_pci_iounmap(struct cobalt *cobalt, struct pci_dev *pci_dev)
 static void cobalt_free_msi(struct cobalt *cobalt, struct pci_dev *pci_dev)
 {
 	free_irq(pci_dev->irq, (void *)cobalt);
-
-	if (cobalt->msi_enabled)
-		pci_disable_msi(pci_dev);
+	pci_free_irq_vectors(pci_dev);
 }
 
 static int cobalt_setup_pci(struct cobalt *cobalt, struct pci_dev *pci_dev,
@@ -386,14 +384,12 @@ static int cobalt_setup_pci(struct cobalt *cobalt, struct pci_dev *pci_dev,
 	   from being generated. */
 	cobalt_set_interrupt(cobalt, false);
 
-	if (pci_enable_msi_range(pci_dev, 1, 1) < 1) {
+	if (pci_alloc_irq_vectors(pci_dev, 1, 1, PCI_IRQ_MSI) < 1) {
 		cobalt_err("Could not enable MSI\n");
-		cobalt->msi_enabled = false;
 		ret = -EIO;
 		goto err_release;
 	}
 	msi_config_show(cobalt, pci_dev);
-	cobalt->msi_enabled = true;
 
 	/* Register IRQ */
 	if (request_irq(pci_dev->irq, cobalt_irq_handler, IRQF_SHARED,
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index ed00dc9..00f773e 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -287,8 +287,6 @@ struct cobalt {
 	u32 irq_none;
 	u32 irq_full_fifo;
 
-	bool msi_enabled;
-
 	/* omnitek dma */
 	int dma_channels;
 	int first_fifo_channel;
-- 
2.1.4
