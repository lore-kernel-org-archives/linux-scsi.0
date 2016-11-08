From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aacraid: switch to pci_alloc_irq_vectors
Date: Tue,  8 Nov 2016 08:11:30 +0100
Message-ID: <1478589090-74217-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43412 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751687AbcKHHLi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 02:11:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>

Use pci_alloc_irq_vectors and drop the hand-crafted
interrupt affinity routines.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h  |  1 -
 drivers/scsi/aacraid/comminit.c | 10 +++-------
 drivers/scsi/aacraid/commsup.c  | 25 +++++--------------------
 drivers/scsi/aacraid/linit.c    | 20 ++++----------------
 4 files changed, 12 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 969c312..f059c14 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1246,7 +1246,6 @@ struct aac_dev
 	u32			max_msix;	/* max. MSI-X vectors */
 	u32			vector_cap;	/* MSI-X vector capab.*/
 	int			msi_enabled;	/* MSI/MSI-X enabled */
-	struct msix_entry	msixentry[AAC_MAX_MSIX];
 	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
 	u8			adapter_shutdown;
 	u32			handle_pci_error;
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 341ea32..4f56b10 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -378,16 +378,12 @@ void aac_define_int_mode(struct aac_dev *dev)
 	if (msi_count > AAC_MAX_MSIX)
 		msi_count = AAC_MAX_MSIX;
 
-	for (i = 0; i < msi_count; i++)
-		dev->msixentry[i].entry = i;
-
 	if (msi_count > 1 &&
 	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
 		min_msix = 2;
-		i = pci_enable_msix_range(dev->pdev,
-				    dev->msixentry,
-				    min_msix,
-				    msi_count);
+		i = pci_alloc_irq_vectors(dev->pdev,
+					  min_msix, msi_count,
+					  PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
 		if (i > 0) {
 			dev->msi_enabled = 1;
 			msi_count = i;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 0aeecec..9e7551f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2043,30 +2043,22 @@ int aac_acquire_irq(struct aac_dev *dev)
 	int i;
 	int j;
 	int ret = 0;
-	int cpu;
 
-	cpu = cpumask_first(cpu_online_mask);
 	if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
 		for (i = 0; i < dev->max_msix; i++) {
 			dev->aac_msix[i].vector_no = i;
 			dev->aac_msix[i].dev = dev;
-			if (request_irq(dev->msixentry[i].vector,
+			if (request_irq(pci_irq_vector(dev->pdev, i),
 					dev->a_ops.adapter_intr,
 					0, "aacraid", &(dev->aac_msix[i]))) {
 				printk(KERN_ERR "%s%d: Failed to register IRQ for vector %d.\n",
 						dev->name, dev->id, i);
 				for (j = 0 ; j < i ; j++)
-					free_irq(dev->msixentry[j].vector,
+					free_irq(pci_irq_vector(dev->pdev, j),
 						 &(dev->aac_msix[j]));
 				pci_disable_msix(dev->pdev);
 				ret = -1;
 			}
-			if (irq_set_affinity_hint(dev->msixentry[i].vector,
-							get_cpu_mask(cpu))) {
-				printk(KERN_ERR "%s%d: Failed to set IRQ affinity for cpu %d\n",
-					    dev->name, dev->id, cpu);
-			}
-			cpu = cpumask_next(cpu, cpu_online_mask);
 		}
 	} else {
 		dev->aac_msix[0].vector_no = 0;
@@ -2096,16 +2088,9 @@ void aac_free_irq(struct aac_dev *dev)
 	    dev->pdev->device == PMC_DEVICE_S8 ||
 	    dev->pdev->device == PMC_DEVICE_S9) {
 		if (dev->max_msix > 1) {
-			for (i = 0; i < dev->max_msix; i++) {
-				if (irq_set_affinity_hint(
-					dev->msixentry[i].vector, NULL)) {
-					printk(KERN_ERR "%s%d: Failed to reset IRQ affinity for cpu %d\n",
-					    dev->name, dev->id, cpu);
-				}
-				cpu = cpumask_next(cpu, cpu_online_mask);
-				free_irq(dev->msixentry[i].vector,
-						&(dev->aac_msix[i]));
-			}
+			for (i = 0; i < dev->max_msix; i++)
+				free_irq(pci_irq_vector(dev->pdev, i),
+					 &(dev->aac_msix[i]));
 		} else {
 			free_irq(dev->pdev->irq, &(dev->aac_msix[0]));
 		}
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 79871f3..e4f3e22 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1071,7 +1071,6 @@ ssize_t aac_get_serial_number(struct device *device, char *buf)
 static void __aac_shutdown(struct aac_dev * aac)
 {
 	int i;
-	int cpu;
 
 	aac_send_shutdown(aac);
 
@@ -1087,24 +1086,13 @@ static void __aac_shutdown(struct aac_dev * aac)
 		kthread_stop(aac->thread);
 	}
 	aac_adapter_disable_int(aac);
-	cpu = cpumask_first(cpu_online_mask);
 	if (aac->pdev->device == PMC_DEVICE_S6 ||
 	    aac->pdev->device == PMC_DEVICE_S7 ||
 	    aac->pdev->device == PMC_DEVICE_S8 ||
 	    aac->pdev->device == PMC_DEVICE_S9) {
 		if (aac->max_msix > 1) {
 			for (i = 0; i < aac->max_msix; i++) {
-				if (irq_set_affinity_hint(
-				    aac->msixentry[i].vector,
-				    NULL)) {
-					printk(KERN_ERR "%s%d: Failed to reset IRQ affinity for cpu %d\n",
-						aac->name,
-						aac->id,
-						cpu);
-				}
-				cpu = cpumask_next(cpu,
-						cpu_online_mask);
-				free_irq(aac->msixentry[i].vector,
+				free_irq(pci_irq_vector(aac->pdev, i),
 					 &(aac->aac_msix[i]));
 			}
 		} else {
@@ -1350,7 +1338,7 @@ static void aac_release_resources(struct aac_dev *aac)
 	    aac->pdev->device == PMC_DEVICE_S9) {
 		if (aac->max_msix > 1) {
 			for (i = 0; i < aac->max_msix; i++)
-				free_irq(aac->msixentry[i].vector,
+				free_irq(pci_irq_vector(aac->pdev, i),
 					&(aac->aac_msix[i]));
 		} else {
 			free_irq(aac->pdev->irq, &(aac->aac_msix[0]));
@@ -1396,13 +1384,13 @@ static int aac_acquire_resources(struct aac_dev *dev)
 			dev->aac_msix[i].vector_no = i;
 			dev->aac_msix[i].dev = dev;
 
-			if (request_irq(dev->msixentry[i].vector,
+			if (request_irq(pci_irq_vector(dev->pdev, i),
 					dev->a_ops.adapter_intr,
 					0, "aacraid", &(dev->aac_msix[i]))) {
 				printk(KERN_ERR "%s%d: Failed to register IRQ for vector %d.\n",
 						name, instance, i);
 				for (j = 0 ; j < i ; j++)
-					free_irq(dev->msixentry[j].vector,
+					free_irq(pci_irq_vector(dev->pdev, j),
 						 &(dev->aac_msix[j]));
 				pci_disable_msix(dev->pdev);
 				goto error_iounmap;
-- 
1.8.5.6

