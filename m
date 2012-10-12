From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 2/5]  arcmsr: Support Hibernation
Date: Fri, 12 Oct 2012 17:06:29 +0800
Message-ID: <AEA947CFF0EA4AAEB8CDFABFD90A85A4@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Nick Cheng <nick.cheng@areca.com.tw>

Support hibernation for whole series of RAID controllers
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---
diff -uprN a//drivers/scsi/arcmsr/arcmsr.h b//drivers/scsi/arcmsr/arcmsr.h
--- a//drivers/scsi/arcmsr/arcmsr.h	2012-10-12 16:28:42.175958900 +0800
+++ b//drivers/scsi/arcmsr/arcmsr.h	2012-10-12 16:29:10.215958628 +0800
@@ -63,7 +63,8 @@ struct device_attribute;
 #define ARCMSR_DEFAULT_SG_ENTRIES		38
 #define ARCMSR_MAX_HBB_POSTQUEUE		264
 #define ARCMSR_MAX_XFER_LEN			0x26000
-#define ARCMSR_CDB_SG_PAGE_LENGTH		256 
+#define ARCMSR_CDB_SG_PAGE_LENGTH		256
+#define ARCMST_NUM_MSIX_VECTORS		4
 #ifndef PCI_DEVICE_ID_ARECA_1880
 	#define PCI_DEVICE_ID_ARECA_1880	0x1880
  #endif
@@ -511,6 +512,7 @@ struct AdapterControlBlock
 	struct pci_dev *pdev;
 	struct Scsi_Host *host;
 	unsigned long vir2phy_offset;
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
 	/* Offset is used in making arc cdb physical to virtual calculations */
 	uint32_t outbound_int_enable;
 	uint32_t cdb_phyaddr_hi32;
@@ -547,6 +549,8 @@ struct AdapterControlBlock
 	/* iop init */
 	#define ACB_F_ABORT				0x0200
 	#define ACB_F_FIRMWARE_TRAP			0x0400
+	#define ACB_F_MSI_ENABLED           			0x1000
+	#define ACB_F_MSIX_ENABLED           		0x2000
 	struct CommandControlBlock *pccb_pool[ARCMSR_MAX_FREECCB_NUM];
 	/* used for memory free */
 	struct list_head ccb_free_list;
diff -uprN a//drivers/scsi/arcmsr/arcmsr_hba.c b//drivers/scsi/arcmsr/arcmsr_hba.c
--- a//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-12 16:28:42.175958900 +0800
+++ b//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-12 16:29:10.239958629 +0800
@@ -89,11 +89,18 @@ static int arcmsr_bios_param(struct scsi
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int arcmsr_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
+#ifdef CONFIG_PM
+	static int arcmsr_suspend(struct pci_dev *pdev,
+	pm_message_t state);
+	static int arcmsr_resume(struct pci_dev *pdev);
+#endif
 static void arcmsr_remove(struct pci_dev *pdev);
 static void arcmsr_shutdown(struct pci_dev *pdev);
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb);
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
+	u32 orig_mask);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);
 static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);
@@ -166,6 +173,10 @@ static struct pci_driver arcmsr_pci_driv
 	.id_table			= arcmsr_device_id_table,
 	.probe			= arcmsr_probe,
 	.remove			= arcmsr_remove,
+	#ifdef CONFIG_PM
+		.suspend		= arcmsr_suspend,
+		.resume		= arcmsr_resume,
+	#endif
 	.shutdown		= arcmsr_shutdown,
 };
 /*
@@ -662,6 +673,134 @@ arcmsr_message_isr_bh_fn(struct work_str
 	}
 }
 
+#ifdef CONFIG_PM
+	static int
+	arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
+	{
+		int i;
+		uint32_t intmask_org;
+		struct Scsi_Host *host = pci_get_drvdata(pdev);
+		struct AdapterControlBlock *acb =
+			(struct AdapterControlBlock *)host->hostdata;
+
+		intmask_org = arcmsr_disable_outbound_ints(acb);
+		if (acb->acb_flags & ACB_F_MSI_ENABLED) {
+			free_irq(pdev->irq, acb);
+			pci_disable_msi(pdev);
+		} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+			for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
+				free_irq(acb->entries[i].vector, acb);
+			}
+			pci_disable_msix(pdev);
+		} else {
+			free_irq(pdev->irq, acb);
+		}
+		del_timer_sync(&acb->eternal_timer);
+		flush_scheduled_work();
+		arcmsr_stop_adapter_bgrb(acb);
+		arcmsr_flush_adapter_cache(acb);
+		arcmsr_enable_outbound_ints(acb, intmask_org);
+		pci_set_drvdata(pdev, host);
+		pci_save_state(pdev);
+		pci_disable_device(pdev);
+		pci_set_power_state(pdev, pci_choose_state(pdev, state));
+		return 0;
+	}
+	
+	static int
+	arcmsr_resume(struct pci_dev *pdev)
+	{
+		int error, i, j;
+		struct Scsi_Host *host = pci_get_drvdata(pdev);
+		struct AdapterControlBlock *acb =
+			(struct AdapterControlBlock *)host->hostdata;
+		struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
+		pci_set_power_state(pdev, PCI_D0);
+		pci_enable_wake(pdev, PCI_D0, 0);
+		pci_restore_state(pdev);
+		if (pci_enable_device(pdev)) {
+			printk("%s: pci_enable_device error \n", __func__);
+			return -ENODEV;
+		}
+		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+		if (error) {
+			error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+			if (error) {
+				printk(KERN_WARNING
+				       "scsi%d: No suitable DMA mask available\n",
+				       host->host_no);
+				goto controller_unregister;
+			}
+		}
+		pci_set_master(pdev);
+		arcmsr_iop_init(acb);
+		if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+			if (!pci_enable_msix(pdev, entries,
+				ARCMST_NUM_MSIX_VECTORS)) {
+				for (i = 0; i < ARCMST_NUM_MSIX_VECTORS;
+				i++) {
+					entries[i].entry = i;
+					if (request_irq(entries[i].vector,
+					arcmsr_do_interrupt, 0,
+					"arcmsr", acb)) {
+					for (j = 0 ; j < i ; j++)
+						free_irq(entries[i].vector,
+						acb);
+					goto controller_stop;
+					}
+					acb->entries[i] = entries[i];
+				}
+				acb->acb_flags |= ACB_F_MSIX_ENABLED;
+			} else {
+				printk("arcmsr%d: MSI-X"
+				"failed to enable\n", acb->host->host_no);
+				if (request_irq(pdev->irq,
+				arcmsr_do_interrupt, IRQF_SHARED,
+				"arcmsr", acb)) {
+					goto controller_stop;
+				}
+			}
+		} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
+			if (!pci_enable_msi(pdev)) {
+				acb->acb_flags |= ACB_F_MSI_ENABLED;
+			}
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,
+				IRQF_SHARED, "arcmsr", acb)) {
+				goto controller_stop;
+			}
+		} else {
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,
+				IRQF_SHARED, "arcmsr", acb)) {
+				goto controller_stop;
+			}
+		}
+		INIT_WORK(&acb->arcmsr_do_message_isr_bh,
+		arcmsr_message_isr_bh_fn);
+		atomic_set(&acb->rq_map_token, 16);
+		atomic_set(&acb->ante_token_value, 16);
+		acb->fw_flag = FW_NORMAL;
+		init_timer(&acb->eternal_timer);
+		acb->eternal_timer.expires = jiffies +
+			msecs_to_jiffies(6 * HZ);
+		acb->eternal_timer.data = (unsigned long) acb;
+		acb->eternal_timer.function =
+			&arcmsr_request_device_map;
+		add_timer(&acb->eternal_timer);
+		return 0;
+		controller_stop:
+			arcmsr_stop_adapter_bgrb(acb);
+			arcmsr_flush_adapter_cache(acb);
+		controller_unregister:
+			scsi_remove_host(host);
+			arcmsr_free_ccb_pool(acb);
+			arcmsr_unmap_pciregion(acb);
+			pci_release_regions(pdev);
+			scsi_host_put(host);	
+			pci_disable_device(pdev);
+		return -ENODEV;
+	}
+#endif
+
 static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct Scsi_Host *host;
