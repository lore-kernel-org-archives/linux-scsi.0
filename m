From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ipr: add test for MSI interrupt support
Date: Tue, 16 Jun 2009 15:13:28 -0700
Message-ID: <4A381908.8090000@linux.vnet.ibm.com>
References: <20090616220853.799518360@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:39727 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZFPWNb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 18:13:31 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5GM9AQ2024024
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 16:09:10 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5GMDYIm258488
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 16:13:34 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5GMDYXJ029000
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 16:13:34 -0600
Received: from [9.47.17.47] (wboyer.beaverton.ibm.com [9.47.17.47])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id n5GMDXBn028923
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 16:13:33 -0600
In-Reply-To: <20090616220853.799518360@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The return value from pci_enable_msi() can not always be trusted.  This patch
adds code to generate an interrupt after MSI has been enabled and tests
whether or not we can receive and process it.  If the tests fails, then fall
back to LSI.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/ipr.h |    6 +-
 2 files changed, 105 insertions(+), 9 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2009-06-03 16:04:14.000000000 -0700
+++ b/drivers/scsi/ipr.c	2009-06-15 16:36:36.000000000 -0700
@@ -7366,6 +7366,7 @@
 	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
 	INIT_WORK(&ioa_cfg->work_q, ipr_worker_thread);
 	init_waitqueue_head(&ioa_cfg->reset_wait_q);
+	init_waitqueue_head(&ioa_cfg->msi_wait_q);
 	ioa_cfg->sdt_state = INACTIVE;
 	if (ipr_enable_cache)
 		ioa_cfg->cache_state = CACHE_ENABLED;
@@ -7416,6 +7417,89 @@
 }

 /**
+ * ipr_test_intr - Handle the interrupt generated in ipr_test_msi().
+ * @pdev:		PCI device struct
+ *
+ * Description: Simply set the msi_received flag to 1 indicating that
+ * Message Signaled Interrupts are supported.
+ *
+ * Return value:
+ * 	0 on success / non-zero on failure
+ **/
+static irqreturn_t __devinit ipr_test_intr(int irq, void *devp)
+{
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)devp;
+	unsigned long lock_flags = 0;
+	irqreturn_t rc = IRQ_HANDLED;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+
+	ioa_cfg->msi_received = 1;
+	wake_up(&ioa_cfg->msi_wait_q);
+
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	return rc;
+}
+
+/**
+ * ipr_test_msi - Test for Message Signaled Interrupt (MSI) support.
+ * @pdev:		PCI device struct
+ *
+ * Description: The return value from pci_enable_msi() can not always be
+ * trusted.  This routine sets up and initiates a test interrupt to determine
+ * if the interrupt is received via the ipr_test_intr() service routine.
+ * If the tests fails, the driver will fall back to LSI.
+ *
+ * Return value:
+ * 	0 on success / non-zero on failure
+ **/
+static int __devinit ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg,
+				  struct pci_dev *pdev)
+{
+	int rc;
+	volatile u32 int_reg;
+	unsigned long lock_flags = 0;
+
+	ENTER;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	init_waitqueue_head(&ioa_cfg->msi_wait_q);
+	ioa_cfg->msi_received = 0;
+	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
+	writel(IPR_PCII_IO_DEBUG_ACKNOWLEDGE, ioa_cfg->regs.clr_interrupt_mask_reg);
+	int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+
+	rc = request_irq(pdev->irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
+	if (rc) {
+		dev_err(&pdev->dev, "Can not assign irq %d\n", pdev->irq);
+		return rc;
+	} else if (ipr_debug)
+		dev_info(&pdev->dev, "IRQ assigned: %d\n", pdev->irq);
+
+	writel(IPR_PCII_IO_DEBUG_ACKNOWLEDGE, ioa_cfg->regs.sense_interrupt_reg);
+	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
+	wait_event_timeout(ioa_cfg->msi_wait_q, ioa_cfg->msi_received, HZ);
+	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	if (!ioa_cfg->msi_received) {
+		/* MSI test failed */
+		dev_info(&pdev->dev, "MSI test failed.  Falling back to LSI.\n");
+		rc = -EOPNOTSUPP;
+	} else if (ipr_debug)
+		dev_info(&pdev->dev, "MSI test succeeded.\n");
+
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+
+	free_irq(pdev->irq, ioa_cfg);
+
+	LEAVE;
+
+	return rc;
+}
+
+/**
  * ipr_probe_ioa - Allocates memory and does first stage of initialization
  * @pdev:		PCI device struct
  * @dev_id:		PCI device id struct
@@ -7440,11 +7524,6 @@
 		goto out;
 	}

-	if (!(rc = pci_enable_msi(pdev)))
-		dev_info(&pdev->dev, "MSI enabled\n");
-	else if (ipr_debug)
-		dev_info(&pdev->dev, "Cannot enable MSI\n");
-
 	dev_info(&pdev->dev, "Found IOA with IRQ: %d\n", pdev->irq);

 	host = scsi_host_alloc(&driver_template, sizeof(*ioa_cfg));
@@ -7518,6 +7597,18 @@
 		goto cleanup_nomem;
 	}

+	/* Enable MSI style interrupts if they are supported. */
+	if (!(rc = pci_enable_msi(pdev))) {
+		rc = ipr_test_msi(ioa_cfg, pdev);
+		if (rc == -EOPNOTSUPP)
+			pci_disable_msi(pdev);
+		else if (rc)
+			goto out_msi_disable;
+		else
+			dev_info(&pdev->dev, "MSI enabled with IRQ: %d\n", pdev->irq);
+	} else if (ipr_debug)
+		dev_info(&pdev->dev, "Cannot enable MSI.\n");
+
 	/* Save away PCI config space for use following IOA reset */
 	rc = pci_save_state(pdev);

@@ -7555,7 +7646,9 @@
 		ioa_cfg->ioa_unit_checked = 1;

 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
-	rc = request_irq(pdev->irq, ipr_isr, IRQF_SHARED, IPR_NAME, ioa_cfg);
+	rc = request_irq(pdev->irq, ipr_isr,
+			 ioa_cfg->msi_received ? 0 : IRQF_SHARED,
+			 IPR_NAME, ioa_cfg);

 	if (rc) {
 		dev_err(&pdev->dev, "Couldn't register IRQ %d! rc=%d\n",
@@ -7582,12 +7675,13 @@
 	ipr_free_mem(ioa_cfg);
 cleanup_nomem:
 	iounmap(ipr_regs);
+out_msi_disable:
+	pci_disable_msi(pdev);
 out_release_regions:
 	pci_release_regions(pdev);
 out_scsi_host_put:
 	scsi_host_put(host);
 out_disable:
-	pci_disable_msi(pdev);
 	pci_disable_device(pdev);
 	goto out;
 }
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2009-06-03 16:04:15.000000000 -0700
+++ b/drivers/scsi/ipr.h	2009-06-15 16:35:43.000000000 -0700
@@ -37,8 +37,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.4.2"
-#define IPR_DRIVER_DATE "(January 21, 2009)"
+#define IPR_DRIVER_VERSION "2.4.3"
+#define IPR_DRIVER_DATE "(June 10, 2009)"

 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
@@ -1094,6 +1094,7 @@
 	u8 needs_hard_reset:1;
 	u8 dual_raid:1;
 	u8 needs_warm_reset:1;
+	u8 msi_received:1;

 	u8 revid;

@@ -1179,6 +1180,7 @@
 	struct work_struct work_q;

 	wait_queue_head_t reset_wait_q;
+	wait_queue_head_t msi_wait_q;

 	struct ipr_dump *dump;
 	enum ipr_sdt_state sdt_state;

