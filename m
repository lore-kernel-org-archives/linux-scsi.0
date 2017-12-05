From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 12/17] scsi: arcmsr: spin off duplicate code of timer init
 for message isr BH in arcmsr_probe and arcmsr_resume as a function
Date: Tue, 05 Dec 2017 10:11:23 +0800
Message-ID: <1512439883.4577.68.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:38827 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753296AbdLEKLc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 05:11:32 -0500
Received: by mail-pg0-f53.google.com with SMTP id f12so10360395pgo.5
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2017 02:11:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au

From: Ching Huang <ching2048@areca.com.tw>

spin off duplicate code of timer init for message isr BH in arcmsr_probe and arcmsr_resume as a function arcmsr_init_get_devmap_timer

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:45:34.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:45:06.000000000 +0800
@@ -857,6 +857,17 @@ out_free_irq:
 	return FAILED;
 }
 
+static void arcmsr_init_get_devmap_timer(struct AdapterControlBlock *pacb)
+{
+	INIT_WORK(&pacb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
+	atomic_set(&pacb->rq_map_token, 16);
+	atomic_set(&pacb->ante_token_value, 16);
+	pacb->fw_flag = FW_NORMAL;
+	timer_setup(&pacb->eternal_timer, arcmsr_request_device_map, 0);
+	pacb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
+	add_timer(&pacb->eternal_timer);
+}
+
 static void arcmsr_init_set_datetime_timer(struct AdapterControlBlock *pacb)
 {
 	timer_setup(&pacb->refresh_timer, arcmsr_set_iop_datetime, 0);
@@ -946,13 +957,7 @@ static int arcmsr_probe(struct pci_dev *
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto scsi_host_remove;
 	arcmsr_iop_init(acb);
-	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
-	atomic_set(&acb->rq_map_token, 16);
-	atomic_set(&acb->ante_token_value, 16);
-	acb->fw_flag = FW_NORMAL;
-	timer_setup(&acb->eternal_timer, arcmsr_request_device_map, 0);
-	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
-	add_timer(&acb->eternal_timer);
+	arcmsr_init_get_devmap_timer(acb);
 	if (set_date_time)
 		arcmsr_init_set_datetime_timer(acb);
 	if(arcmsr_alloc_sysfs_attr(acb))
@@ -1043,13 +1048,7 @@ static int arcmsr_resume(struct pci_dev 
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto controller_stop;
 	arcmsr_iop_init(acb);
-	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
-	atomic_set(&acb->rq_map_token, 16);
-	atomic_set(&acb->ante_token_value, 16);
-	acb->fw_flag = FW_NORMAL;
-	timer_setup(&acb->eternal_timer, arcmsr_request_device_map, 0);
-	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
-	add_timer(&acb->eternal_timer);
+	arcmsr_init_get_devmap_timer(acb);
 	if (set_date_time)
 		arcmsr_init_set_datetime_timer(acb);
 	return 0;
