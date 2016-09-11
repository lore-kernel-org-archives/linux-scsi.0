From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] skd: use pci_alloc_irq_vectors
Date: Sun, 11 Sep 2016 15:31:25 +0200
Message-ID: <1473600688-24043-4-git-send-email-hch@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60107 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbcIKNbm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 09:31:42 -0400
In-Reply-To: <1473600688-24043-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org

Switch the skd driver to use pci_alloc_irq_vectors.  We need to two calls to
pci_alloc_irq_vectors as skd only supports multiple MSI-X vectors, but not
multiple MSI vectors.

Otherwise this cleans up a lot of cruft and allows to a lot more common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/skd_main.c | 212 +++++++++++++++--------------------------------
 1 file changed, 66 insertions(+), 146 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 3822eae..702f543 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -270,8 +270,6 @@ struct skd_device {
 	resource_size_t mem_phys[SKD_MAX_BARS];
 	u32 mem_size[SKD_MAX_BARS];
 
-	skd_irq_type_t irq_type;
-	u32 msix_count;
 	struct skd_msix_entry *msix_entries;
 
 	struct pci_dev *pdev;
@@ -3821,10 +3819,6 @@ static irqreturn_t skd_qfull_isr(int irq, void *skd_host_data)
  */
 
 struct skd_msix_entry {
-	int have_irq;
-	u32 vector;
-	u32 entry;
-	struct skd_device *rsp;
 	char isr_name[30];
 };
 
@@ -3853,56 +3847,21 @@ static struct skd_init_msix_entry msix_entries[SKD_MAX_MSIX_COUNT] = {
 	{ "(Queue Full 3)", skd_qfull_isr    },
 };
 
-static void skd_release_msix(struct skd_device *skdev)
-{
-	struct skd_msix_entry *qentry;
-	int i;
-
-	if (skdev->msix_entries) {
-		for (i = 0; i < skdev->msix_count; i++) {
-			qentry = &skdev->msix_entries[i];
-			skdev = qentry->rsp;
-
-			if (qentry->have_irq)
-				devm_free_irq(&skdev->pdev->dev,
-					      qentry->vector, qentry->rsp);
-		}
-
-		kfree(skdev->msix_entries);
-	}
-
-	if (skdev->msix_count)
-		pci_disable_msix(skdev->pdev);
-
-	skdev->msix_count = 0;
-	skdev->msix_entries = NULL;
-}
-
 static int skd_acquire_msix(struct skd_device *skdev)
 {
 	int i, rc;
 	struct pci_dev *pdev = skdev->pdev;
-	struct msix_entry *entries;
-	struct skd_msix_entry *qentry;
-
-	entries = kzalloc(sizeof(struct msix_entry) * SKD_MAX_MSIX_COUNT,
-			  GFP_KERNEL);
-	if (!entries)
-		return -ENOMEM;
 
-	for (i = 0; i < SKD_MAX_MSIX_COUNT; i++)
-		entries[i].entry = i;
-
-	rc = pci_enable_msix_exact(pdev, entries, SKD_MAX_MSIX_COUNT);
-	if (rc) {
+	rc = pci_alloc_irq_vectors(pdev, SKD_MAX_MSIX_COUNT, SKD_MAX_MSIX_COUNT,
+			PCI_IRQ_MSIX);
+	if (rc < 0) {
 		pr_err("(%s): failed to enable MSI-X %d\n",
 		       skd_name(skdev), rc);
 		goto msix_out;
 	}
 
-	skdev->msix_count = SKD_MAX_MSIX_COUNT;
-	skdev->msix_entries = kzalloc(sizeof(struct skd_msix_entry) *
-				      skdev->msix_count, GFP_KERNEL);
+	skdev->msix_entries = kcalloc(SKD_MAX_MSIX_COUNT,
+			sizeof(struct skd_msix_entry), GFP_KERNEL);
 	if (!skdev->msix_entries) {
 		rc = -ENOMEM;
 		pr_err("(%s): msix table allocation error\n",
@@ -3910,136 +3869,98 @@ static int skd_acquire_msix(struct skd_device *skdev)
 		goto msix_out;
 	}
 
-	for (i = 0; i < skdev->msix_count; i++) {
-		qentry = &skdev->msix_entries[i];
-		qentry->vector = entries[i].vector;
-		qentry->entry = entries[i].entry;
-		qentry->rsp = NULL;
-		qentry->have_irq = 0;
-		pr_debug("%s:%s:%d %s: <%s> msix (%d) vec %d, entry %x\n",
-			 skdev->name, __func__, __LINE__,
-			 pci_name(pdev), skdev->name,
-			 i, qentry->vector, qentry->entry);
-	}
-
 	/* Enable MSI-X vectors for the base queue */
-	for (i = 0; i < skdev->msix_count; i++) {
-		qentry = &skdev->msix_entries[i];
+	for (i = 0; i < SKD_MAX_MSIX_COUNT; i++) {
+		struct skd_msix_entry *qentry = &skdev->msix_entries[i];
+
 		snprintf(qentry->isr_name, sizeof(qentry->isr_name),
 			 "%s%d-msix %s", DRV_NAME, skdev->devno,
 			 msix_entries[i].name);
-		rc = devm_request_irq(&skdev->pdev->dev, qentry->vector,
-				      msix_entries[i].handler, 0,
-				      qentry->isr_name, skdev);
+
+		rc = devm_request_irq(&skdev->pdev->dev,
+				pci_irq_vector(skdev->pdev, i),
+				msix_entries[i].handler, 0,
+				qentry->isr_name, skdev);
 		if (rc) {
 			pr_err("(%s): Unable to register(%d) MSI-X "
 			       "handler %d: %s\n",
 			       skd_name(skdev), rc, i, qentry->isr_name);
 			goto msix_out;
-		} else {
-			qentry->have_irq = 1;
-			qentry->rsp = skdev;
 		}
 	}
+
 	pr_debug("%s:%s:%d %s: <%s> msix %d irq(s) enabled\n",
 		 skdev->name, __func__, __LINE__,
-		 pci_name(pdev), skdev->name, skdev->msix_count);
+		 pci_name(pdev), skdev->name, SKD_MAX_MSIX_COUNT);
 	return 0;
 
 msix_out:
-	if (entries)
-		kfree(entries);
-	skd_release_msix(skdev);
+	while (--i >= 0)
+		devm_free_irq(&pdev->dev, pci_irq_vector(pdev, i), skdev);
+	kfree(skdev->msix_entries);
+	skdev->msix_entries = NULL;
 	return rc;
 }
 
 static int skd_acquire_irq(struct skd_device *skdev)
 {
+	struct pci_dev *pdev = skdev->pdev;
+	unsigned int irq_flag = PCI_IRQ_LEGACY;
 	int rc;
-	struct pci_dev *pdev;
 
-	pdev = skdev->pdev;
-	skdev->msix_count = 0;
-
-RETRY_IRQ_TYPE:
-	switch (skdev->irq_type) {
-	case SKD_IRQ_MSIX:
+	if (skd_isr_type == SKD_IRQ_MSIX) {
 		rc = skd_acquire_msix(skdev);
 		if (!rc)
-			pr_info("(%s): MSI-X %d irqs enabled\n",
-			       skd_name(skdev), skdev->msix_count);
-		else {
-			pr_err(
-			       "(%s): failed to enable MSI-X, re-trying with MSI %d\n",
-			       skd_name(skdev), rc);
-			skdev->irq_type = SKD_IRQ_MSI;
-			goto RETRY_IRQ_TYPE;
-		}
-		break;
-	case SKD_IRQ_MSI:
-		snprintf(skdev->isr_name, sizeof(skdev->isr_name), "%s%d-msi",
-			 DRV_NAME, skdev->devno);
-		rc = pci_enable_msi_range(pdev, 1, 1);
-		if (rc > 0) {
-			rc = devm_request_irq(&pdev->dev, pdev->irq, skd_isr, 0,
-					      skdev->isr_name, skdev);
-			if (rc) {
-				pci_disable_msi(pdev);
-				pr_err(
-				       "(%s): failed to allocate the MSI interrupt %d\n",
-				       skd_name(skdev), rc);
-				goto RETRY_IRQ_LEGACY;
-			}
-			pr_info("(%s): MSI irq %d enabled\n",
-			       skd_name(skdev), pdev->irq);
-		} else {
-RETRY_IRQ_LEGACY:
-			pr_err(
-			       "(%s): failed to enable MSI, re-trying with LEGACY %d\n",
-			       skd_name(skdev), rc);
-			skdev->irq_type = SKD_IRQ_LEGACY;
-			goto RETRY_IRQ_TYPE;
-		}
-		break;
-	case SKD_IRQ_LEGACY:
-		snprintf(skdev->isr_name, sizeof(skdev->isr_name),
-			 "%s%d-legacy", DRV_NAME, skdev->devno);
-		rc = devm_request_irq(&pdev->dev, pdev->irq, skd_isr,
-				      IRQF_SHARED, skdev->isr_name, skdev);
-		if (!rc)
-			pr_info("(%s): LEGACY irq %d enabled\n",
-			       skd_name(skdev), pdev->irq);
-		else
-			pr_err("(%s): request LEGACY irq error %d\n",
-			       skd_name(skdev), rc);
-		break;
-	default:
-		pr_info("(%s): irq_type %d invalid, re-set to %d\n",
-		       skd_name(skdev), skdev->irq_type, SKD_IRQ_DEFAULT);
-		skdev->irq_type = SKD_IRQ_LEGACY;
-		goto RETRY_IRQ_TYPE;
+			return 0;
+
+		pr_err("(%s): failed to enable MSI-X, re-trying with MSI %d\n",
+		       skd_name(skdev), rc);
 	}
-	return rc;
+
+	snprintf(skdev->isr_name, sizeof(skdev->isr_name), "%s%d", DRV_NAME,
+			skdev->devno);
+
+	if (skd_isr_type != SKD_IRQ_LEGACY)
+		irq_flag |= PCI_IRQ_MSI;
+	rc = pci_alloc_irq_vectors(pdev, 1, 1, irq_flag);
+	if (rc < 0) {
+		pr_err("(%s): failed to allocate the MSI interrupt %d\n",
+			skd_name(skdev), rc);
+		return rc;
+	}
+
+	rc = devm_request_irq(&pdev->dev, pdev->irq, skd_isr,
+			pdev->msi_enabled ? 0 : IRQF_SHARED,
+			skdev->isr_name, skdev);
+	if (rc) {
+		pci_free_irq_vectors(pdev);
+		pr_err("(%s): failed to allocate interrupt %d\n",
+			skd_name(skdev), rc);
+		return rc;
+	}
+
+	return 0;
 }
 
 static void skd_release_irq(struct skd_device *skdev)
 {
-	switch (skdev->irq_type) {
-	case SKD_IRQ_MSIX:
-		skd_release_msix(skdev);
-		break;
-	case SKD_IRQ_MSI:
-		devm_free_irq(&skdev->pdev->dev, skdev->pdev->irq, skdev);
-		pci_disable_msi(skdev->pdev);
-		break;
-	case SKD_IRQ_LEGACY:
-		devm_free_irq(&skdev->pdev->dev, skdev->pdev->irq, skdev);
-		break;
-	default:
-		pr_err("(%s): wrong irq type %d!",
-		       skd_name(skdev), skdev->irq_type);
-		break;
+	struct pci_dev *pdev = skdev->pdev;
+
+	if (skdev->msix_entries) {
+		int i;
+
+		for (i = 0; i < SKD_MAX_MSIX_COUNT; i++) {
+			devm_free_irq(&pdev->dev, pci_irq_vector(pdev, i),
+					skdev);
+		}
+
+		kfree(skdev->msix_entries);
+		skdev->msix_entries = NULL;
+	} else {
+		devm_free_irq(&pdev->dev, pdev->irq, skdev);
 	}
+
+	pci_free_irq_vectors(pdev);
 }
 
 /*
@@ -4402,7 +4323,6 @@ static struct skd_device *skd_construct(struct pci_dev *pdev)
 	skdev->pdev = pdev;
 	skdev->devno = skd_next_devno++;
 	skdev->major = blk_major;
-	skdev->irq_type = skd_isr_type;
 	sprintf(skdev->name, DRV_NAME "%d", skdev->devno);
 	skdev->dev_max_queue_depth = 0;
 
-- 
2.1.4

