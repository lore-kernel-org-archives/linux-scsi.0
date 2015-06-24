From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [Patch V2 6/9] [SCSI] aacraid: Reset irq affinity hints before
 releasing irq
Date: Wed, 24 Jun 2015 05:41:45 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F78888@BBYEXM01.pmc-sierra.internal>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1433986951-9033-8-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60612 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbbFXFlq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jun 2015 01:41:46 -0400
In-Reply-To: <1433986951-9033-8-git-send-email-rajinikanth.pandurangan@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>


-----Original Message-----
From: Rajinikanth Pandurangan 
Sent: Thursday, June 11, 2015 7:12 AM
To: jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Mahesh Rajashekhara; Rich Bono; Achim Leubner; Murthy Bhat; Rajinikanth Pandurangan
Subject: [Patch V2 6/9] [SCSI] aacraid: Reset irq affinity hints before releasing irq

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
        Reset irq affinity hints before releasing IRQ
        Removed duplicate code of IRQ acquire/release

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |   2 +
 drivers/scsi/aacraid/commsup.c | 113 ++++++++++++++++++++++++++++++-----------
 drivers/scsi/aacraid/src.c     |  48 ++---------------
 3 files changed, 88 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h index e54f597..7b95227 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2110,6 +2110,8 @@ static inline unsigned int cap_to_cyls(sector_t capacity, unsigned divisor)
 #define AAC_OWNER_ERROR_HANDLER	0x103
 #define AAC_OWNER_FIRMWARE	0x106
 
+int aac_acquire_irq(struct aac_dev *dev); void aac_free_irq(struct 
+aac_dev *dev);
 const char *aac_driverinfo(struct Scsi_Host *);  struct fib *aac_fib_alloc(struct aac_dev *dev);  int aac_fib_setup(struct aac_dev *dev); diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c index 4da5749..a1f90fe 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1270,13 +1270,12 @@ retry_next:
 static int _aac_reset_adapter(struct aac_dev *aac, int forced)  {
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
@@ -1978,3 +1949,83 @@ int aac_command_thread(void *data)
 	dev->aif_thread = 0;
 	return 0;
 }
+
+int aac_acquire_irq(struct aac_dev *dev) {
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
+			IRQF_SHARED, "aacraid",
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
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c index 1409a0b..2aa34ea 100644
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
 	dev->a_ops.adapter_comm = aac_src_select_comm; @@ -918,48 +916,10 @@ int aac_srcv_init(struct aac_dev *dev)
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

