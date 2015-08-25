From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] megaraid_sas: init tasklet earlier
Date: Tue, 25 Aug 2015 15:31:47 +0200
Message-ID: <1440509507-3337-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbbHYNbv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2015 09:31:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@avagotech.com, kiran-kumar.kasturi@avagotech.com, Sumit.Saxena@avagotech.com

It may happen (kdump), that an interrupt is invoked just
after the setup_irqs function was called but before
the tasklet was initialised.
At this phase the hw ints should have been disabled, but for
unknown reason this mechanism seems to not work properly.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 71b884dae2..c8e0c6de80 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4627,6 +4627,9 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		"current msix/online cpus\t: (%d/%d)\n",
 		instance->msix_vectors, (unsigned int)num_online_cpus());
 
+	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
+		(unsigned long)instance);
+
 	if (instance->msix_vectors ?
 		megasas_setup_irqs_msix(instance, 1) :
 		megasas_setup_irqs_ioapic(instance))
@@ -4647,9 +4650,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
 
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		(unsigned long)instance);
-
 	instance->instancet->enable_intr(instance);
 
 	printk(KERN_ERR "megasas: INIT adapter done\n");
-- 
2.4.3

