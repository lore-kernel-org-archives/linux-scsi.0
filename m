From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH 6/9] [SCSI] aacraid: Reset irq affinity hints before releasing irq
Date: Wed, 13 May 2015 17:12:55 -0700
Message-ID: <1431562378-8514-7-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57824 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933920AbbENAOi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 20:14:38 -0400
In-Reply-To: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
        Reset irq affinity hints before releasing IRQ
        Removed duplicate code of IRQ acquire/release

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |   2 +
 drivers/scsi/aacraid/commsup.c | 114 ++++++++++++++++++++++++++++++-----------
 drivers/scsi/aacraid/linit.c   |  93 ++-------------------------------
 drivers/scsi/aacraid/src.c     |  50 ++----------------
 4 files changed, 94 insertions(+), 165 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 9e69e3e..ec32a2bdd 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2113,6 +2113,8 @@ static inline unsigned int cap_to_cyls(sector_t capacity, unsigned divisor)
 #define AAC_OWNER_ERROR_HANDLER	0x103
 #define AAC_OWNER_FIRMWARE	0x106
 
+int aac_acquire_irq(struct aac_dev *dev);
+void aac_free_irq(struct aac_dev *dev);
 const char *aac_driverinfo(struct Scsi_Host *);
 struct fib *aac_fib_alloc(struct aac_dev *dev);
 int aac_fib_setup(struct aac_dev *dev);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 4da5749..3ff18f4 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1270,13 +1270,12 @@ retry_next:
 static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 {
 	int index, quirks;
-	int retval, i;
+	int retval;
 	struct Scsi_Host *host;
 	struct scsi_device *dev;
 	struct scsi_cmnd *command;
 	struct scsi_cmnd *command_list;
 	int jafo = 0;
-	int cpu;
 
 	/*
 	 * Assumptions:
@@ -1339,35 +1338,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	aac->comm_phys = 0;
 	kfree(aac->queues);
 	aac->queues = NULL;
-	cpu = cpumask_first(cpu_online_mask);
-	if (aac->pdev->device == PMC_DEVICE_S6 ||
-	    aac->pdev->device == PMC_DEVICE_S7 ||
-	    aac->pdev->device == PMC_DEVICE_S8 ||
-	    aac->pdev->device == PMC_DEVICE_S9) {
-		if (aac->max_msix > 1) {
-			for (i = 0; i < aac->max_msix; i++) {
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
-					 &(aac->aac_msix[i]));
-			}
-			pci_disable_msix(aac->pdev);
-		} else {
-			free_irq(aac->pdev->irq, &(aac->aac_msix[0]));
-		}
-	} else {
-		free_irq(aac->pdev->irq, aac);
-	}
-	if (aac->msi)
-		pci_disable_msi(aac->pdev);
+	aac_free_irq(aac);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
 	quirks = aac_get_driver_ident(index)->quirks;
@@ -1978,3 +1949,84 @@ int aac_command_thread(void *data)
 	dev->aif_thread = 0;
 	return 0;
 }
+
+int aac_acquire_irq(struct aac_dev *dev)
+{
+	int i;
+	int j;
+	int ret = 0;
+	int cpu;
+
+	cpu = cpumask_first(cpu_online_mask);
+	if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
+		for (i = 0; i < dev->max_msix; i++) {
+			dev->aac_msix[i].vector_no = i;
+			dev->aac_msix[i].dev = dev;
+			if (request_irq(dev->msixentry[i].vector,
+					dev->a_ops.adapter_intr,
+					0, "aacraid", &(dev->aac_msix[i]))) {
+				printk(KERN_ERR "%s%d: Failed to register IRQ for vector %d.\n",
+						dev->name, dev->id, i);
+				for (j = 0 ; j < i ; j++)
+					free_irq(dev->msixentry[j].vector,
+						 &(dev->aac_msix[j]));
+				pci_disable_msix(dev->pdev);
+				ret = -1;
+			}
+			if (irq_set_affinity_hint(dev->msixentry[i].vector,
+							get_cpu_mask(cpu))) {
+				printk(KERN_ERR "%s%d: Failed to set IRQ affinity for cpu %d\n",
+					    dev->name, dev->id, cpu);
+			}
+			cpu = cpumask_next(cpu, cpu_online_mask);
+		}
+	} else {
+		dev->aac_msix[0].vector_no = 0;
+		dev->aac_msix[0].dev = dev;
+
+		if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
+			IRQF_SHARED|IRQF_DISABLED, "aacraid",
+			&(dev->aac_msix[0])) < 0) {
+			if (dev->msi)
+				pci_disable_msi(dev->pdev);
+			printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
+					dev->name, dev->id);
+			ret = -1;
+		}
+	}
+	return ret;
+}
+
+void aac_free_irq(struct aac_dev *dev)
+{
+	int i;
+	int cpu;
+
+	cpu = cpumask_first(cpu_online_mask);
+	if (dev->pdev->device == PMC_DEVICE_S6 ||
+	    dev->pdev->device == PMC_DEVICE_S7 ||
+	    dev->pdev->device == PMC_DEVICE_S8 ||
+	    dev->pdev->device == PMC_DEVICE_S9) {
+		if (dev->max_msix > 1) {
+			for (i = 0; i < dev->max_msix; i++) {
+				if (irq_set_affinity_hint(
+					dev->msixentry[i].vector, NULL)) {
+					printk(KERN_ERR "%s%d: Failed to reset IRQ affinity for cpu %d\n",
+					    dev->name, dev->id, cpu);
+				}
+				cpu = cpumask_next(cpu, cpu_online_mask);
+				free_irq(dev->msixentry[i].vector,
+						&(dev->aac_msix[i]));
+			}
+		} else {
+			free_irq(dev->pdev->irq, &(dev->aac_msix[0]));
+		}
+	} else {
+		free_irq(dev->pdev->irq, dev);
+	}
+	if (dev->msi)
+		pci_disable_msi(dev->pdev);
+	else if (dev->max_msix > 1)
+		pci_disable_msix(dev->pdev);
+}
+
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index be30e43..62a928f 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1072,9 +1072,6 @@ static struct scsi_host_template aac_driver_template = {
 
 static void __aac_shutdown(struct aac_dev * aac)
 {
-	int i;
-	int cpu;
-
 	if (aac->aif_thread) {
 		int i;
 		/* Clear out events first */
@@ -1088,37 +1085,7 @@ static void __aac_shutdown(struct aac_dev * aac)
 	}
 	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
-	cpu = cpumask_first(cpu_online_mask);
-	if (aac->pdev->device == PMC_DEVICE_S6 ||
-	    aac->pdev->device == PMC_DEVICE_S7 ||
-	    aac->pdev->device == PMC_DEVICE_S8 ||
-	    aac->pdev->device == PMC_DEVICE_S9) {
-		if (aac->max_msix > 1) {
-			for (i = 0; i < aac->max_msix; i++) {
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
-					 &(aac->aac_msix[i]));
-			}
-		} else {
-			free_irq(aac->pdev->irq,
-				 &(aac->aac_msix[0]));
-		}
-	} else {
-		free_irq(aac->pdev->irq, aac);
-	}
-	if (aac->msi)
-		pci_disable_msi(aac->pdev);
-	else if (aac->max_msix > 1)
-		pci_disable_msix(aac->pdev);
+	aac_free_irq(aac);
 }
 
 static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -1320,35 +1287,12 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 #if (defined(CONFIG_PM))
 void aac_release_resources(struct aac_dev *aac)
 {
-	int i;
-
 	aac_adapter_disable_int(aac);
-	if (aac->pdev->device == PMC_DEVICE_S6 ||
-	    aac->pdev->device == PMC_DEVICE_S7 ||
-	    aac->pdev->device == PMC_DEVICE_S8 ||
-	    aac->pdev->device == PMC_DEVICE_S9) {
-		if (aac->max_msix > 1) {
-			for (i = 0; i < aac->max_msix; i++)
-				free_irq(aac->msixentry[i].vector,
-					&(aac->aac_msix[i]));
-		} else {
-			free_irq(aac->pdev->irq, &(aac->aac_msix[0]));
-		}
-	} else {
-		free_irq(aac->pdev->irq, aac);
-	}
-	if (aac->msi)
-		pci_disable_msi(aac->pdev);
-	else if (aac->max_msix > 1)
-		pci_disable_msix(aac->pdev);
-
+	aac_free_irq(aac);
 }
 
 static int aac_acquire_resources(struct aac_dev *dev)
 {
-	int i, j;
-	int instance = dev->id;
-	const char *name = dev->name;
 	unsigned long status;
 	/*
 	 *	First clear out all interrupts.  Then enable the one's that we
@@ -1370,37 +1314,8 @@ static int aac_acquire_resources(struct aac_dev *dev)
 	if (dev->msi_enabled)
 		aac_src_access_devreg(dev, AAC_ENABLE_MSIX);
 
-	if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
-		for (i = 0; i < dev->max_msix; i++) {
-			dev->aac_msix[i].vector_no = i;
-			dev->aac_msix[i].dev = dev;
-
-			if (request_irq(dev->msixentry[i].vector,
-					dev->a_ops.adapter_intr,
-					0, "aacraid", &(dev->aac_msix[i]))) {
-				printk(KERN_ERR "%s%d: Failed to register IRQ for vector %d.\n",
-						name, instance, i);
-				for (j = 0 ; j < i ; j++)
-					free_irq(dev->msixentry[j].vector,
-						 &(dev->aac_msix[j]));
-				pci_disable_msix(dev->pdev);
-				goto error_iounmap;
-			}
-		}
-	} else {
-		dev->aac_msix[0].vector_no = 0;
-		dev->aac_msix[0].dev = dev;
-
-		if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED|IRQF_DISABLED, "aacraid",
-			&(dev->aac_msix[0])) < 0) {
-			if (dev->msi)
-				pci_disable_msi(dev->pdev);
-			printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
-					name, instance);
-			goto error_iounmap;
-		}
-	}
+	if (aac_acquire_irq(dev))
+		goto error_iounmap;
 
 	aac_adapter_enable_int(dev);
 
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 109863a..f3e830c 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -798,9 +798,7 @@ int aac_srcv_init(struct aac_dev *dev)
 	unsigned long status;
 	int restart = 0;
 	int instance = dev->id;
-	int i, j;
 	const char *name = dev->name;
-	int cpu;
 
 	dev->a_ops.adapter_ioremap = aac_srcv_ioremap;
 	dev->a_ops.adapter_comm = aac_src_select_comm;
@@ -918,48 +916,10 @@ int aac_srcv_init(struct aac_dev *dev)
 		goto error_iounmap;
 	if (dev->msi_enabled)
 		aac_src_access_devreg(dev, AAC_ENABLE_MSIX);
-	if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
-		cpu = cpumask_first(cpu_online_mask);
-		for (i = 0; i < dev->max_msix; i++) {
-			dev->aac_msix[i].vector_no = i;
-			dev->aac_msix[i].dev = dev;
-
-			if (request_irq(dev->msixentry[i].vector,
-					dev->a_ops.adapter_intr,
-					0,
-					"aacraid",
-					&(dev->aac_msix[i]))) {
-				printk(KERN_ERR "%s%d: Failed to register IRQ for vector %d.\n",
-						name, instance, i);
-				for (j = 0 ; j < i ; j++)
-					free_irq(dev->msixentry[j].vector,
-						 &(dev->aac_msix[j]));
-				pci_disable_msix(dev->pdev);
-				goto error_iounmap;
-			}
-			if (irq_set_affinity_hint(
-			   dev->msixentry[i].vector,
-			   get_cpu_mask(cpu))) {
-				printk(KERN_ERR "%s%d: Failed to set IRQ affinity for cpu %d\n",
-						name, instance, cpu);
-			}
-			cpu = cpumask_next(cpu, cpu_online_mask);
-		}
-	} else {
-		dev->aac_msix[0].vector_no = 0;
-		dev->aac_msix[0].dev = dev;
-
-		if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-				IRQF_SHARED,
-				"aacraid",
-				&(dev->aac_msix[0])) < 0) {
-			if (dev->msi)
-				pci_disable_msi(dev->pdev);
-			printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
-					name, instance);
-			goto error_iounmap;
-		}
-	}
+
+	if (aac_acquire_irq(dev))
+		goto error_iounmap;
+
 	dev->dbg_base = dev->base_start;
 	dev->dbg_base_mapped = dev->base;
 	dev->dbg_size = dev->base_size;
-- 
1.9.3

