From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: [PATCH v1.3 2/11] arcmsr: Support MSI and MSI-X interrupt service
Date: Fri, 21 Feb 2014 11:26:39 +0800
Message-ID: <CAKiknE_B643O53hiMwKRGgdrx9zOtbOiwnBj40stmxb+M_mc0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:55786 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaBUD0l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 22:26:41 -0500
Received: by mail-lb0-f173.google.com with SMTP id s7so1957299lbd.18
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2014 19:26:39 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>, =?UTF-8?B?5ZCz56Kn5ra8?= <billion.wu@areca.com.tw>

From: Ching <ching2048@areca.com.tw>

Supporting MSI and MSI-X interrupt service.

Singed-off-by: Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h      2014-01-11 02:53:22.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h      2014-01-11 03:14:14.000000000 +0800
@@ -64,6 +64,7 @@ struct device_attribute;
 #define ARCMSR_MAX_HBB_POSTQUEUE       264
 #define ARCMSR_MAX_XFER_LEN            0x26000 /* 152K */
 #define ARCMSR_CDB_SG_PAGE_LENGTH      256
+#define ARCMST_NUM_MSIX_VECTORS                4
 #ifndef PCI_DEVICE_ID_ARECA_1880
 #define PCI_DEVICE_ID_ARECA_1880       0x1880
 #endif
@@ -508,6 +509,7 @@ struct AdapterControlBlock
        struct pci_dev *                pdev;
        struct Scsi_Host *              host;
        unsigned long                   vir2phy_offset;
+       struct msix_entry       entries[ARCMST_NUM_MSIX_VECTORS];
        /* Offset is used in making arc cdb physical to virtual calculations */
        uint32_t                        outbound_int_enable;
        uint32_t                        cdb_phyaddr_hi32;
@@ -542,8 +544,10 @@ struct AdapterControlBlock

        #define ACB_F_IOP_INITED                0x0100
        /* iop init */
-       #define ACB_F_ABORT                             0x0200
-       #define ACB_F_FIRMWARE_TRAP                     0x0400
+       #define ACB_F_ABORT                     0x0200
+       #define ACB_F_FIRMWARE_TRAP             0x0400
+       #define ACB_F_MSI_ENABLED               0x1000
+       #define ACB_F_MSIX_ENABLED              0x2000
        struct CommandControlBlock *
pccb_pool[ARCMSR_MAX_FREECCB_NUM];
        /* used for memory free */
        struct list_head                ccb_free_list;
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 01:59:18.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 01:59:56.000000000 +0800
@@ -607,20 +607,19 @@ static int arcmsr_probe(struct pci_dev *
 {
        struct Scsi_Host *host;
        struct AdapterControlBlock *acb;
-       uint8_t bus,dev_fun;
-       int error;
+       uint8_t bus, dev_fun;
+       struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
+       int error, i, j;
        error = pci_enable_device(pdev);
-       if(error){
+       if (error)
                return -ENODEV;
-       }
        host = scsi_host_alloc(&arcmsr_scsi_host_template,
sizeof(struct AdapterControlBlock));
-       if(!host){
+       if (!host)
                goto pci_disable_dev;
-       }
        error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
-       if(error){
+       if (error) {
                error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-               if(error){
+               if (error) {
                        printk(KERN_WARNING
                               "scsi%d: No suitable DMA mask available\n",
                               host->host_no);
@@ -644,9 +643,8 @@ static int arcmsr_probe(struct pci_dev *
        pci_set_drvdata(pdev, host);
        pci_set_master(pdev);
        error = pci_request_regions(pdev, "arcmsr");
-       if(error){
+       if (error)
                goto scsi_host_release;
-       }
        spin_lock_init(&acb->eh_lock);
        spin_lock_init(&acb->ccblist_lock);
        acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
@@ -656,28 +654,58 @@ static int arcmsr_probe(struct pci_dev *
        INIT_LIST_HEAD(&acb->ccb_free_list);
        arcmsr_define_adapter_type(acb);
        error = arcmsr_remap_pciregion(acb);
-       if(!error){
+       if (!error)
                goto pci_release_regs;
-       }
        error = arcmsr_get_firmware_spec(acb);
-       if(!error){
+       if (!error)
                goto unmap_pci_region;
-       }
        error = arcmsr_alloc_ccb_pool(acb);
-       if(error){
-               goto free_hbb_mu;
-       }
-       arcmsr_iop_init(acb);
+       if (error)
+               goto free_mu;
        error = scsi_add_host(host, &pdev->dev);
-       if(error){
+       if (error)
                goto RAID_controller_stop;
-       }
-       error = request_irq(pdev->irq, arcmsr_do_interrupt,
IRQF_SHARED, "arcmsr", acb);
-       if(error){
-               goto scsi_host_remove;
+       if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+               if (!pci_enable_msix(pdev, entries, ARCMST_NUM_MSIX_VECTORS)) {
+                       for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
+                               entries[i].entry = i;
+                               if (request_irq(entries[i].vector,
+                                       arcmsr_do_interrupt, 0,
"arcmsr", acb)) {
+                                       for (j = 0 ; j < i ; j++)
+
free_irq(entries[i].vector, acb);
+                                       goto scsi_host_remove;
+                               }
+                               acb->entries[i] = entries[i];
+                       }
+                       acb->acb_flags |= ACB_F_MSIX_ENABLED;
+               } else {
+                       if (request_irq(pdev->irq, arcmsr_do_interrupt,
+                               IRQF_SHARED, "arcmsr", acb)) {
+                               pr_warn("arcmsr%d: request_irq = %d failed!\n",
+                                       acb->host->host_no, pdev->irq);
+                               goto scsi_host_remove;
+                       }
+               }
+       } else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
+               if (!pci_enable_msi(pdev))
+                       acb->acb_flags |= ACB_F_MSI_ENABLED;
+               if (request_irq(pdev->irq, arcmsr_do_interrupt,
+                       IRQF_SHARED, "arcmsr", acb)) {
+                       pr_warn("arcmsr%d: request_irq =%d failed!\n",
+                               acb->host->host_no, pdev->irq);
+                       goto scsi_host_remove;
+               }
+       } else {
+               if (request_irq(pdev->irq, arcmsr_do_interrupt,
+                       IRQF_SHARED, "arcmsr", acb)) {
+                       pr_warn("arcmsr%d: request_irq = %d failed!\n",
+                               acb->host->host_no, pdev->irq);
+                       goto scsi_host_remove;
+               }
        }
        host->irq = pdev->irq;
-       scsi_scan_host(host);
+       arcmsr_iop_init(acb);
+       scsi_scan_host(host);
        INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
        atomic_set(&acb->rq_map_token, 16);
        atomic_set(&acb->ante_token_value, 16);
@@ -692,12 +720,16 @@ static int arcmsr_probe(struct pci_dev *
        return 0;
 out_free_sysfs:
 scsi_host_remove:
+       if (acb->acb_flags & ACB_F_MSI_ENABLED)
+               pci_disable_msi(pdev);
+       else if (acb->acb_flags & ACB_F_MSIX_ENABLED)
+               pci_disable_msix(pdev);
        scsi_remove_host(host);
 RAID_controller_stop:
        arcmsr_stop_adapter_bgrb(acb);
        arcmsr_flush_adapter_cache(acb);
        arcmsr_free_ccb_pool(acb);
-free_hbb_mu:
+free_mu:
        arcmsr_free_hbb_mu(acb);
 unmap_pci_region:
        arcmsr_unmap_pciregion(acb);
@@ -997,7 +1029,7 @@ static void arcmsr_remove(struct pci_dev
        struct Scsi_Host *host = pci_get_drvdata(pdev);
        struct AdapterControlBlock *acb =
                (struct AdapterControlBlock *) host->hostdata;
-       int poll_count = 0;
+       int poll_count = 0, i;
        arcmsr_free_sysfs_attr(acb);
        scsi_remove_host(host);
        flush_work(&acb->arcmsr_do_message_isr_bh);
@@ -1016,8 +1048,6 @@ static void arcmsr_remove(struct pci_dev
        }

        if (atomic_read(&acb->ccboutstandingcount)) {
-               int i;
-
                arcmsr_abort_allcmd(acb);
                arcmsr_done4abort_postqueue(acb);
                for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
@@ -1029,7 +1059,15 @@ static void arcmsr_remove(struct pci_dev
                        }
                }
        }
-       free_irq(pdev->irq, acb);
+       if (acb->acb_flags & ACB_F_MSI_ENABLED) {
+               free_irq(pdev->irq, acb);
+               pci_disable_msi(pdev);
+       } else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+               for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)
+                       free_irq(acb->entries[i].vector, acb);
+               pci_disable_msix(pdev);
+       } else
+               free_irq(pdev->irq, acb);
        arcmsr_free_ccb_pool(acb);
        arcmsr_free_hbb_mu(acb);
        arcmsr_unmap_pciregion(acb);
@@ -1040,11 +1078,21 @@ static void arcmsr_remove(struct pci_dev

 static void arcmsr_shutdown(struct pci_dev *pdev)
 {
+       int i;
        struct Scsi_Host *host = pci_get_drvdata(pdev);
        struct AdapterControlBlock *acb =
                (struct AdapterControlBlock *)host->hostdata;
        del_timer_sync(&acb->eternal_timer);
        arcmsr_disable_outbound_ints(acb);
+       if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+               for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)
+                       free_irq(acb->entries[i].vector, acb);
+               pci_disable_msix(pdev);
+       } else if (acb->acb_flags & ACB_F_MSI_ENABLED) {
+               free_irq(pdev->irq, acb);
+               pci_disable_msi(pdev);
+       } else
+               free_irq(pdev->irq, acb);
        flush_work(&acb->arcmsr_do_message_isr_bh);
        arcmsr_stop_adapter_bgrb(acb);
        arcmsr_flush_adapter_cache(acb);
@@ -2515,8 +2563,6 @@ static int arcmsr_iop_confirm(struct Ada
        case ACB_ADAPTER_TYPE_A: {
                if (cdb_phyaddr_hi32 != 0) {
                        struct MessageUnit_A __iomem *reg = acb->pmuA;
-                       uint32_t intmask_org;
-                       intmask_org = arcmsr_disable_outbound_ints(acb);
                        writel(ARCMSR_SIGNATURE_SET_CONFIG, \
                                                &reg->message_rwbuffer[0]);
                        writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
@@ -2528,7 +2574,6 @@ static int arcmsr_iop_confirm(struct Ada
                                acb->host->host_no);
                                return 1;
                        }
-                       arcmsr_enable_outbound_ints(acb, intmask_org);
                }
                }
                break;
@@ -2538,8 +2583,6 @@ static int arcmsr_iop_confirm(struct Ada
                uint32_t __iomem *rwbuffer;

                struct MessageUnit_B *reg = acb->pmuB;
-               uint32_t intmask_org;
-               intmask_org = arcmsr_disable_outbound_ints(acb);
                reg->postq_index = 0;
                reg->doneq_index = 0;
                writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
@@ -2568,7 +2611,6 @@ static int arcmsr_iop_confirm(struct Ada
                        return 1;
                }
                arcmsr_hbb_enable_driver_mode(acb);
-               arcmsr_enable_outbound_ints(acb, intmask_org);
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
