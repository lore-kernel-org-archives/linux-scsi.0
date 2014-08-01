From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v1.3 3/18] arcmsr: Add code to support system hibernation
Date: Fri, 01 Aug 2014 16:36:13 +0800
Message-ID: <1406882173.10378.42.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59023 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaHAIgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2014 04:36:22 -0400
Received: by mail-pd0-f176.google.com with SMTP id y10so5147289pdj.21
        for <linux-scsi@vger.kernel.org>; Fri, 01 Aug 2014 01:36:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


This patch adds code to support system hibernation.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-01 11:03:00.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-01 11:04:28.000000000 +0800
@@ -89,11 +89,15 @@ static int arcmsr_bios_param(struct scsi
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int arcmsr_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
+static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);
+static int arcmsr_resume(struct pci_dev *pdev);
 static void arcmsr_remove(struct pci_dev *pdev);
 static void arcmsr_shutdown(struct pci_dev *pdev);
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb);
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
+	u32 intmask_org);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
 static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
@@ -167,6 +171,8 @@ static struct pci_driver arcmsr_pci_driv
 	.id_table			= arcmsr_device_id_table,
 	.probe			= arcmsr_probe,
 	.remove			= arcmsr_remove,
+	.suspend		= arcmsr_suspend,
+	.resume			= arcmsr_resume,
 	.shutdown		= arcmsr_shutdown,
 };
 /*
@@ -776,6 +782,77 @@ static void arcmsr_free_irq(struct pci_d
 		free_irq(pdev->irq, acb);
 }
 
+static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	uint32_t intmask_org;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *)host->hostdata;
+
+	intmask_org = arcmsr_disable_outbound_ints(acb);
+	arcmsr_free_irq(pdev, acb);
+	del_timer_sync(&acb->eternal_timer);
+	flush_scheduled_work();
+	arcmsr_stop_adapter_bgrb(acb);
+	arcmsr_flush_adapter_cache(acb);
+	arcmsr_enable_outbound_ints(acb, intmask_org);
+	pci_set_drvdata(pdev, host);
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	return 0;
+}
+
+static int arcmsr_resume(struct pci_dev *pdev)
+{
+	int error;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *)host->hostdata;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+	if (pci_enable_device(pdev)) {
+		pr_warn("%s: pci_enable_device error\n", __func__);
+		return -ENODEV;
+	}
+	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (error) {
+		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (error) {
+			pr_warn("scsi%d: No suitable DMA mask available\n",
+			       host->host_no);
+			goto controller_unregister;
+		}
+	}
+	pci_set_master(pdev);
+	if (arcmsr_request_irq(pdev, acb) == ARC_FAILURE)
+		goto controller_stop;
+	arcmsr_iop_init(acb);
+	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
+	atomic_set(&acb->rq_map_token, 16);
+	atomic_set(&acb->ante_token_value, 16);
+	acb->fw_flag = FW_NORMAL;
+	init_timer(&acb->eternal_timer);
+	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
+	acb->eternal_timer.data = (unsigned long) acb;
+	acb->eternal_timer.function = &arcmsr_request_device_map;
+	add_timer(&acb->eternal_timer);
+	return 0;
+controller_stop:
+	arcmsr_stop_adapter_bgrb(acb);
+	arcmsr_flush_adapter_cache(acb);
+controller_unregister:
+	scsi_remove_host(host);
+	arcmsr_free_ccb_pool(acb);
+	arcmsr_unmap_pciregion(acb);
+	pci_release_regions(pdev);
+	scsi_host_put(host);
+	pci_disable_device(pdev);
+	return -ENODEV;
+}
+
 static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;


