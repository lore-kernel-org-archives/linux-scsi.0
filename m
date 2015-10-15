From: sumit.saxena@avagotech.com
Subject: [PATCH 08/12] megaraid_sas : Initialize tasklet before setting up IRQs
Date: Thu, 15 Oct 2015 13:40:34 +0530
Message-ID: <201510150817.t9F8Hrh8029649@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([202.86.248.48]:60967 "EHLO
	rndsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbbJOIUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:20:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

It may happen (kdump), that an interrupt is invoked just after the setup_irqs function was called but before the tasklet was initialised.
At this phase the hw ints should have been disabled, but for unknown reason this mechanism seems to not work properly.

From: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3214c7e..43e6193 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4745,6 +4745,9 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		"current msix/online cpus\t: (%d/%d)\n",
 		instance->msix_vectors, (unsigned int)num_online_cpus());
 
+	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
+		(unsigned long)instance);
+
 	if (instance->msix_vectors ?
 		megasas_setup_irqs_msix(instance, 1) :
 		megasas_setup_irqs_ioapic(instance))
@@ -4765,8 +4768,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
 
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		(unsigned long)instance);
 
 	instance->instancet->enable_intr(instance);
 
-- 
1.7.1

