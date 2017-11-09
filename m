From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 11/13] scsi: arcmsr: spin off duplicate code of timer init
 for message isr BH in arcmsr_probe and arcmsr_resume as a function
Date: Thu, 09 Nov 2017 08:27:47 +0800
Message-ID: <1510187267.4523.94.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:49327 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753363AbdKII1z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 03:27:55 -0500
Received: by mail-it0-f48.google.com with SMTP id y15so10245991ita.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 00:27:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org

From: Ching Huang <ching2048@areca.com.tw>

spin off duplicate code of timer init for message isr BH in arcmsr_probe and arcmsr_resume as a function arcmsr_init_get_devmap_timer

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:54:58.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:55:50.000000000 +0800
@@ -857,6 +857,19 @@ out_free_irq:
 	return FAILED;
 }
 
+static void arcmsr_init_get_devmap_timer(struct AdapterControlBlock *pacb)
+{
+	INIT_WORK(&pacb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
+	atomic_set(&pacb->rq_map_token, 16);
+	atomic_set(&pacb->ante_token_value, 16);
+	pacb->fw_flag = FW_NORMAL;
+	init_timer(&pacb->eternal_timer);
+	pacb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
+	pacb->eternal_timer.data = (unsigned long)pacb;
+	pacb->eternal_timer.function = &arcmsr_request_device_map;
+	add_timer(&pacb->eternal_timer);
+}
+
 static void arcmsr_init_set_datetime_timer(struct AdapterControlBlock *pacb)
 {
 	init_timer(&pacb->refresh_timer);
@@ -948,15 +961,7 @@ static int arcmsr_probe(struct pci_dev *
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto scsi_host_remove;
 	arcmsr_iop_init(acb);
-	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
-	atomic_set(&acb->rq_map_token, 16);
-	atomic_set(&acb->ante_token_value, 16);
-	acb->fw_flag = FW_NORMAL;
-	init_timer(&acb->eternal_timer);
-	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
-	acb->eternal_timer.data = (unsigned long) acb;
-	acb->eternal_timer.function = &arcmsr_request_device_map;
-	add_timer(&acb->eternal_timer);
+	arcmsr_init_get_devmap_timer(acb);
 	if (set_date_time)
 		arcmsr_init_set_datetime_timer(acb);
 	if(arcmsr_alloc_sysfs_attr(acb))
@@ -1047,15 +1052,7 @@ static int arcmsr_resume(struct pci_dev 
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto controller_stop;
 	arcmsr_iop_init(acb);
-	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
-	atomic_set(&acb->rq_map_token, 16);
-	atomic_set(&acb->ante_token_value, 16);
-	acb->fw_flag = FW_NORMAL;
-	init_timer(&acb->eternal_timer);
-	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
-	acb->eternal_timer.data = (unsigned long) acb;
-	acb->eternal_timer.function = &arcmsr_request_device_map;
-	add_timer(&acb->eternal_timer);
+	arcmsr_init_get_devmap_timer(acb);
 	if (set_date_time)
 		arcmsr_init_set_datetime_timer(acb);
 	return 0;
