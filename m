From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v3 17/17] arcmsr: modify calling scsi_scan_host after all
 initialization done
Date: Tue, 19 Aug 2014 15:28:36 +0800
Message-ID: <1408433316.4748.76.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46025 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaHSH2n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 03:28:43 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so9199512pdj.36
        for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2014 00:28:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Modify calling scsi_scan_host until all initialization done.
And fix error path of free allocation resource.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:38:46.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 17:43:04.000000000 +0800
@@ -112,6 +112,7 @@ static void arcmsr_hbaD_message_isr(stru
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
+static void arcmsr_free_irq(struct pci_dev *, struct AdapterControlBlock *);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
 					  int queue_depth, int reason)
 {
@@ -730,12 +731,11 @@ static int arcmsr_probe(struct pci_dev *
 	}
 	error = scsi_add_host(host, &pdev->dev);
 	if(error){
-		goto RAID_controller_stop;
+		goto free_ccb_pool;
 	}
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto scsi_host_remove;
 	arcmsr_iop_init(acb);
-    	scsi_scan_host(host);
 	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
 	atomic_set(&acb->rq_map_token, 16);
 	atomic_set(&acb->ante_token_value, 16);
@@ -747,13 +747,17 @@ static int arcmsr_probe(struct pci_dev *
 	add_timer(&acb->eternal_timer);
 	if(arcmsr_alloc_sysfs_attr(acb))
 		goto out_free_sysfs;
+    	scsi_scan_host(host);
 	return 0;
 out_free_sysfs:
-scsi_host_remove:
-	scsi_remove_host(host);
-RAID_controller_stop:
+	del_timer_sync(&acb->eternal_timer);
+ 	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
+	arcmsr_free_irq(pdev, acb);
+scsi_host_remove:
+	scsi_remove_host(host);
+free_ccb_pool:
 	arcmsr_free_ccb_pool(acb);
 free_hbb_mu:
 	arcmsr_free_mu(acb);


