From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v2] regression, megaraid - fix irq setup process
Date: Tue, 2 Jun 2015 16:09:46 +0530
Message-ID: <201506021043.t52Ah6Cb032634@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:63408
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755048AbbFBKkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jun 2015 06:40:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com

From:Tomas Henzl<thenzl@redhat.com>

This fixes a regression caused by commit
d3557fc8be11d25f316884581f487684f8e7dad3
megaraid_sas : Add separate function for setting up IRQs This makes boot end with 'root does not exist' message on certain adapters.

The bug is that the driver does not setup ints for cards without msi-x support.
This patch fixes it, in addition to that it moves tasklet initialisation before enable_intr, otherwise a kernel panic may occur, when an
interrupt arrives before the tasklet is ready.

Signed-off-by: Tomas Henzl<thenzl@redhat.com>
Signed-off-by: Sumit Saxena<sumit.saxena@avagotech.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a022c39..da26ac4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4619,18 +4619,18 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			instance->msix_vectors = i;
 		else
 			instance->msix_vectors = 0;
+	}
 
-		dev_info(&instance->pdev->dev,
-			"firmware supports msix\t: (%d)", fw_msix_count);
-		dev_info(&instance->pdev->dev,
-			"current msix/online cpus\t: (%d/%d)\n",
-			instance->msix_vectors, (unsigned int)num_online_cpus());
+	dev_info(&instance->pdev->dev,
+		"firmware supports msix\t: (%d)", fw_msix_count);
+	dev_info(&instance->pdev->dev,
+		"current msix/online cpus\t: (%d/%d)\n",
+		instance->msix_vectors, (unsigned int)num_online_cpus());
 
-		if (instance->msix_vectors ?
-				megasas_setup_irqs_msix(instance, 1) :
-				megasas_setup_irqs_ioapic(instance))
-			goto fail_setup_irqs;
-	}
+	if (instance->msix_vectors ?
+		megasas_setup_irqs_msix(instance, 1) :
+		megasas_setup_irqs_ioapic(instance))
+		goto fail_setup_irqs;
 
 	instance->ctrl_info = kzalloc(sizeof(struct megasas_ctrl_info),
 				GFP_KERNEL);
@@ -4646,6 +4646,10 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	/* Get operational params, sge flags, send init cmd to controller */
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
+
+	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
+		(unsigned long)instance);
+
 	instance->instancet->enable_intr(instance);
 
 	printk(KERN_ERR "megasas: INIT adapter done\n");
@@ -4762,12 +4766,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		instance->throttlequeuedepth =
 				MEGASAS_THROTTLE_QUEUE_DEPTH;
 
-        /*
-	* Setup tasklet for cmd completion
-	*/
-
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		(unsigned long)instance);
 
 	/* Launch SR-IOV heartbeat timer */
 	if (instance->requestorId) {
