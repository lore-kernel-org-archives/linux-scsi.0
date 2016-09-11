From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] vfio_pci: use pci_irq_allocate_vectors
Date: Sun, 11 Sep 2016 15:31:26 +0200
Message-ID: <1473600688-24043-5-git-send-email-hch@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473600688-24043-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Simply the interrupt setup by using the new PCI layer helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/pci/vfio_pci_intrs.c   | 45 +++++++++----------------------------
 drivers/vfio/pci/vfio_pci_private.h |  1 -
 2 files changed, 10 insertions(+), 36 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 152b438..a1d283e 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -250,6 +250,7 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
 static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	unsigned int flag = msix ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
 	int ret;
 
 	if (!is_irq_none(vdev))
@@ -259,35 +260,13 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 	if (!vdev->ctx)
 		return -ENOMEM;
 
-	if (msix) {
-		int i;
-
-		vdev->msix = kzalloc(nvec * sizeof(struct msix_entry),
-				     GFP_KERNEL);
-		if (!vdev->msix) {
-			kfree(vdev->ctx);
-			return -ENOMEM;
-		}
-
-		for (i = 0; i < nvec; i++)
-			vdev->msix[i].entry = i;
-
-		ret = pci_enable_msix_range(pdev, vdev->msix, 1, nvec);
-		if (ret < nvec) {
-			if (ret > 0)
-				pci_disable_msix(pdev);
-			kfree(vdev->msix);
-			kfree(vdev->ctx);
-			return ret;
-		}
-	} else {
-		ret = pci_enable_msi_range(pdev, 1, nvec);
-		if (ret < nvec) {
-			if (ret > 0)
-				pci_disable_msi(pdev);
-			kfree(vdev->ctx);
-			return ret;
-		}
+	/* return the number of supported vectors if we can't get all: */
+	ret = pci_alloc_irq_vectors(pdev, 1, nvec, flag);
+	if (ret < nvec) {
+		if (ret > 0)
+			pci_free_irq_vectors(pdev);
+		kfree(vdev->ctx);
+		return ret;
 	}
 
 	vdev->num_ctx = nvec;
@@ -315,7 +294,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	if (vector < 0 || vector >= vdev->num_ctx)
 		return -EINVAL;
 
-	irq = msix ? vdev->msix[vector].vector : pdev->irq + vector;
+	irq = pci_irq_vector(pdev, vector);
 
 	if (vdev->ctx[vector].trigger) {
 		free_irq(irq, vdev->ctx[vector].trigger);
@@ -408,11 +387,7 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 
 	vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
 
-	if (msix) {
-		pci_disable_msix(vdev->pdev);
-		kfree(vdev->msix);
-	} else
-		pci_disable_msi(pdev);
+	pci_free_irq_vectors(pdev);
 
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 2128de8..f561ac1 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -72,7 +72,6 @@ struct vfio_pci_device {
 	struct perm_bits	*msi_perm;
 	spinlock_t		irqlock;
 	struct mutex		igate;
-	struct msix_entry	*msix;
 	struct vfio_pci_irq_ctx	*ctx;
 	int			num_ctx;
 	int			irq_type;
-- 
2.1.4
