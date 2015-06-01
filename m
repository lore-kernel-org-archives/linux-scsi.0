From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] regression, megaraid - fix irq setup process
Date: Mon,  1 Jun 2015 19:26:45 +0200
Message-ID: <1433179605-31821-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbbFAR0t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jun 2015 13:26:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@avagotech.com, Sumit.Saxena@avagotech.com

This fixes a regression caused by commit
d3557fc8be11d25f316884581f487684f8e7dad3
megaraid_sas : Add separate function for setting up IRQs
This makes boot end with 'root does not exist' message on certain adapters.

The bug is that the driver does not setup ints for cards
without msi-x support.
This patch fixes it, in addition to that it moves irq-enable call
after tasklet initialisation - otherwise a kernel panic may occur,
when an int arrives before the tasklet is ready.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a022c39153..3771d6fff5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4619,18 +4619,16 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			instance->msix_vectors = i;
 		else
 			instance->msix_vectors = 0;
+	}
 
-		dev_info(&instance->pdev->dev,
-			"firmware supports msix\t: (%d)", fw_msix_count);
-		dev_info(&instance->pdev->dev,
-			"current msix/online cpus\t: (%d/%d)\n",
-			instance->msix_vectors, (unsigned int)num_online_cpus());
+	dev_info(&instance->pdev->dev, "firmware supports msix\t: (%d)",
+		fw_msix_count);
+	dev_info(&instance->pdev->dev, "current msix/online cpus\t: (%d/%d)\n",
+		instance->msix_vectors, (unsigned int)num_online_cpus());
 
-		if (instance->msix_vectors ?
-				megasas_setup_irqs_msix(instance, 1) :
-				megasas_setup_irqs_ioapic(instance))
-			goto fail_setup_irqs;
-	}
+	if (instance->msix_vectors ? megasas_setup_irqs_msix(instance, 1) :
+				     megasas_setup_irqs_ioapic(instance))
+		goto fail_setup_irqs;
 
 	instance->ctrl_info = kzalloc(sizeof(struct megasas_ctrl_info),
 				GFP_KERNEL);
@@ -4646,8 +4644,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	/* Get operational params, sge flags, send init cmd to controller */
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
-	instance->instancet->enable_intr(instance);
-
 	printk(KERN_ERR "megasas: INIT adapter done\n");
 
 	/** for passthrough
@@ -4769,6 +4765,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		(unsigned long)instance);
 
+	instance->instancet->enable_intr(instance);
+
 	/* Launch SR-IOV heartbeat timer */
 	if (instance->requestorId) {
 		if (!megasas_sriov_start_heartbeat(instance, 1))
-- 
1.9.3

