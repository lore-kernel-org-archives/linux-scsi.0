From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] genwqe: use pci_irq_allocate_vectors
Date: Sun, 11 Sep 2016 15:31:27 +0200
Message-ID: <1473600688-24043-6-git-send-email-hch@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473600688-24043-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Simply the interrupt setup by using the new PCI layer helpers.

One odd thing about this driver is that it looks like it could request
multiple MSI vectors, but it will then only ever use a single one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/misc/genwqe/card_base.h  |  1 -
 drivers/misc/genwqe/card_utils.c | 12 ++----------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/genwqe/card_base.h b/drivers/misc/genwqe/card_base.h
index cb851c1..5813b5f 100644
--- a/drivers/misc/genwqe/card_base.h
+++ b/drivers/misc/genwqe/card_base.h
@@ -41,7 +41,6 @@
 #include "genwqe_driver.h"
 
 #define GENWQE_MSI_IRQS			4  /* Just one supported, no MSIx */
-#define GENWQE_FLAG_MSI_ENABLED		(1 << 0)
 
 #define GENWQE_MAX_VFS			15 /* maximum 15 VFs are possible */
 #define GENWQE_MAX_FUNCS		16 /* 1 PF and 15 VFs */
diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 222367c..da424c2 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -730,13 +730,10 @@ int genwqe_read_softreset(struct genwqe_dev *cd)
 int genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count)
 {
 	int rc;
-	struct pci_dev *pci_dev = cd->pci_dev;
 
-	rc = pci_enable_msi_range(pci_dev, 1, count);
+	rc = pci_alloc_irq_vectors(cd->pci_dev, 1, count, PCI_IRQ_MSI);
 	if (rc < 0)
 		return rc;
-
-	cd->flags |= GENWQE_FLAG_MSI_ENABLED;
 	return 0;
 }
 
@@ -746,12 +743,7 @@ int genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count)
  */
 void genwqe_reset_interrupt_capability(struct genwqe_dev *cd)
 {
-	struct pci_dev *pci_dev = cd->pci_dev;
-
-	if (cd->flags & GENWQE_FLAG_MSI_ENABLED) {
-		pci_disable_msi(pci_dev);
-		cd->flags &= ~GENWQE_FLAG_MSI_ENABLED;
-	}
+	pci_free_irq_vectors(cd->pci_dev);
 }
 
 /**
-- 
2.1.4
