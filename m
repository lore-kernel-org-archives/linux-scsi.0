From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: [PATCH v1.3 3/11] arcmsr: Support hibernation
Date: Fri, 21 Feb 2014 11:35:23 +0800
Message-ID: <CAKiknE-y2ZUnL6sBeE-wYDyndLGKAZikFAnrjj1jUcCxK-bwgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44572 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaBUDfZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 22:35:25 -0500
Received: by mail-lb0-f181.google.com with SMTP id z11so1945469lbi.40
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2014 19:35:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>

From: Ching <ching2048@areca.com.tw>

Supporting hibernation.

Singed-off-by: Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 01:59:56.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:00:16.000000000 +0800
@@ -87,13 +87,16 @@ static int arcmsr_bus_reset(struct scsi_
 static int arcmsr_bios_param(struct scsi_device *sdev,
                struct block_device *bdev, sector_t capacity, int *info);
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
-static int arcmsr_probe(struct pci_dev *pdev,
-                               const struct pci_device_id *id);
+static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id);
+static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);
+static int arcmsr_resume(struct pci_dev *pdev);
 static void arcmsr_remove(struct pci_dev *pdev);
 static void arcmsr_shutdown(struct pci_dev *pdev);
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb);
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
+       u32 intmask_org);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
 static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
@@ -164,9 +167,11 @@ static struct pci_device_id arcmsr_devic
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
 static struct pci_driver arcmsr_pci_driver = {
        .name                   = "arcmsr",
-       .id_table                       = arcmsr_device_id_table,
+       .id_table               = arcmsr_device_id_table,
        .probe                  = arcmsr_probe,
        .remove                 = arcmsr_remove,
+       .suspend                = arcmsr_suspend,
+       .resume                 = arcmsr_resume,
        .shutdown               = arcmsr_shutdown,
 };
 /*
@@ -603,6 +608,121 @@ static void arcmsr_message_isr_bh_fn(str
        }
 }

+static int
+arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+       int i;
+       uint32_t intmask_org;
+       struct Scsi_Host *host = pci_get_drvdata(pdev);
+       struct AdapterControlBlock *acb =
+               (struct AdapterControlBlock *)host->hostdata;
+
+       intmask_org = arcmsr_disable_outbound_ints(acb);
+       if (acb->acb_flags & ACB_F_MSI_ENABLED) {
+               free_irq(pdev->irq, acb);
+               pci_disable_msi(pdev);
+       } else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+               for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)
+                       free_irq(acb->entries[i].vector, acb);
+               pci_disable_msix(pdev);
+       } else
+               free_irq(pdev->irq, acb);
+       del_timer_sync(&acb->eternal_timer);
+       flush_scheduled_work();
+       arcmsr_stop_adapter_bgrb(acb);
+       arcmsr_flush_adapter_cache(acb);
+       arcmsr_enable_outbound_ints(acb, intmask_org);
+       pci_set_drvdata(pdev, host);
+       pci_save_state(pdev);
+       pci_disable_device(pdev);
+       pci_set_power_state(pdev, pci_choose_state(pdev, state));
+       return 0;
+}
+
+static int
+arcmsr_resume(struct pci_dev *pdev)
+{
+       int error, i, j;
+       struct Scsi_Host *host = pci_get_drvdata(pdev);
+       struct AdapterControlBlock *acb =
+               (struct AdapterControlBlock *)host->hostdata;
+       struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
+       pci_set_power_state(pdev, PCI_D0);
+       pci_enable_wake(pdev, PCI_D0, 0);
+       pci_restore_state(pdev);
+       if (pci_enable_device(pdev)) {
+               pr_warn("%s: pci_enable_device error\n", __func__);
+               return -ENODEV;
+       }
+       error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+       if (error) {
+               error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+               if (error) {
+                       pr_warn("scsi%d: No suitable DMA mask available\n",
+                              host->host_no);
+                       goto controller_unregister;
+               }
+       }
+       pci_set_master(pdev);
+       if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+               if (!pci_enable_msix(pdev, entries,
+                       ARCMST_NUM_MSIX_VECTORS)) {
+                       for (i = 0; i < ARCMST_NUM_MSIX_VECTORS;
+                               i++) {
+                               entries[i].entry = i;
+                               if (request_irq(entries[i].vector,
+                                       arcmsr_do_interrupt, 0,
+                                       "arcmsr", acb)) {
+                                       for (j = 0 ; j < i ; j++)
+
free_irq(entries[i].vector, acb);
+                                       goto controller_stop;
+                               }
+                               acb->entries[i] = entries[i];
+                       }
+                       acb->acb_flags |= ACB_F_MSIX_ENABLED;
+               } else {
+                       pr_warn("arcmsr%d: MSI-X failed to enable\n",
+                               acb->host->host_no);
+                       if (request_irq(pdev->irq, arcmsr_do_interrupt,
+                               IRQF_SHARED, "arcmsr", acb)) {
+                               goto controller_stop;
+                       }
+               }
+       } else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
+               if (!pci_enable_msi(pdev))
+                       acb->acb_flags |= ACB_F_MSI_ENABLED;
+               if (request_irq(pdev->irq, arcmsr_do_interrupt,
+                       IRQF_SHARED, "arcmsr", acb))
+                       goto controller_stop;
+       } else {
+               if (request_irq(pdev->irq, arcmsr_do_interrupt,
+                       IRQF_SHARED, "arcmsr", acb))
+                       goto controller_stop;
+       }
+       arcmsr_iop_init(acb);
+       INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
+       atomic_set(&acb->rq_map_token, 16);
+       atomic_set(&acb->ante_token_value, 16);
+       acb->fw_flag = FW_NORMAL;
+       init_timer(&acb->eternal_timer);
+       acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
+       acb->eternal_timer.data = (unsigned long) acb;
+       acb->eternal_timer.function = &arcmsr_request_device_map;
+       add_timer(&acb->eternal_timer);
+       return 0;
+controller_stop:
+       arcmsr_stop_adapter_bgrb(acb);
+       arcmsr_flush_adapter_cache(acb);
+controller_unregister:
+       scsi_remove_host(host);
+       arcmsr_free_ccb_pool(acb);
+       arcmsr_unmap_pciregion(acb);
+       pci_release_regions(pdev);
+       scsi_host_put(host);
+       pci_disable_device(pdev);
+       return -ENODEV;
+}
+
 static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
        struct Scsi_Host *host;
