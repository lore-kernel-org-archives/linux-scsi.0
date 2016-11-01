From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] megaraid-sas: request irqs later
Date: Tue,  1 Nov 2016 17:32:02 +0100
Message-ID: <1478017922-22655-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750918AbcKAQcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 12:32:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sumit.saxena@broadcom.com, kashyap.desai@broadcom.com

It is not good when an irq arrives before
driver structures are allocated.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c3efcc7255..e207410150 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5155,11 +5155,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		(unsigned long)instance);
 
-	if (instance->msix_vectors ?
-		megasas_setup_irqs_msix(instance, 1) :
-		megasas_setup_irqs_ioapic(instance))
-		goto fail_setup_irqs;
-
 	instance->ctrl_info = kzalloc(sizeof(struct megasas_ctrl_info),
 				GFP_KERNEL);
 	if (instance->ctrl_info == NULL)
@@ -5175,6 +5170,10 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
 
+	if (instance->msix_vectors ?
+		megasas_setup_irqs_msix(instance, 1) :
+		megasas_setup_irqs_ioapic(instance))
+		goto fail_init_adapter;
 
 	instance->instancet->enable_intr(instance);
 
@@ -5314,9 +5313,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 fail_get_pd_list:
 	instance->instancet->disable_intr(instance);
-fail_init_adapter:
 	megasas_destroy_irqs(instance);
-fail_setup_irqs:
+fail_init_adapter:
 	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
 	instance->msix_vectors = 0;
-- 
2.7.4

