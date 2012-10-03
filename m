From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 2/5]  arcmsr: Support Hibernation
Date: Wed, 3 Oct 2012 20:39:48 +0800
Message-ID: <AF09A61410894CDFA32F0C74FBDABF60@arecaaebe11fae>
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
diff -uprN -X linux-vanilla/Documentation/dontdiff
linux-vanilla//drivers/scsi/arcmsr/arcmsr_hba.c
linux-development//drivers/scsi/arcmsr/arcmsr_hba.c
--- linux-vanilla//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-03
19:08:33.338634210 +0800
+++ linux-development//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-03
18:50:32.694644708 +0800
@@ -42,7 +42,7 @@
 ** THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
****************************************************************************
***
 ** For history of changes, see Documentation/scsi/ChangeLog.arcmsr
-**     Firmware Specification, see Documentation/scsi/arcmsr_spec.txt
+** Firmware Specification, see Documentation/scsi/arcmsr_spec.txt
 
****************************************************************************
***
 */
 #include <linux/module.h>
@@ -90,6 +90,8 @@ static int arcmsr_bios_param(struct scsi
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd
*cmd);
 static int arcmsr_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
+static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);
+static int arcmsr_resume(struct pci_dev *pdev);
 static void arcmsr_remove(struct pci_dev *pdev);
 static void arcmsr_shutdown(struct pci_dev *pdev);
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);
@@ -167,6 +169,8 @@ static struct pci_driver arcmsr_pci_driv
 	.id_table			= arcmsr_device_id_table,
 	.probe			= arcmsr_probe,
 	.remove			= arcmsr_remove,
+	.suspend			= arcmsr_suspend,
+	.resume			= arcmsr_resume,
 	.shutdown		= arcmsr_shutdown,
 };
 /*
@@ -603,6 +607,80 @@ static void arcmsr_message_isr_bh_fn(str
 	}
 }
 
+static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int i;
+	uint32_t intmask_org;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct AdapterControlBlock *acb = (struct AdapterControlBlock
*)host->hostdata;
+
+	intmask_org = arcmsr_disable_outbound_ints(acb);
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
+	int error, i, j;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct AdapterControlBlock *acb = (struct AdapterControlBlock
*)host->hostdata;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+	if (pci_enable_device(pdev)) {
+		printk("%s: pci_enable_device error \n", __func__);
+		return -ENODEV;
+	}
+	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (error) {
+		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (error) {
+			printk(KERN_WARNING
+			       "scsi%d: No suitable DMA mask available\n",
+			       host->host_no);
+			goto controller_unregister;
+		}
+	}
+	pci_set_master(pdev);
+	arcmsr_iop_init(acb);
+	if (request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED,
"arcmsr", acb)) {
+		printk("arcmsr%d: request_irq =%d failed!\n",
acb->host->host_no, pdev->irq);
+		goto controller_stop;
+	}
+	timer_init:
+		INIT_WORK(&acb->arcmsr_do_message_isr_bh,
+			arcmsr_message_isr_bh_fn);
+		atomic_set(&acb->rq_map_token, 16);
+		atomic_set(&acb->ante_token_value, 16);
+		acb->fw_flag = FW_NORMAL;
+		init_timer(&acb->eternal_timer);
+		acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 *
HZ);
+		acb->eternal_timer.data = (unsigned long) acb;
+		acb->eternal_timer.function = &arcmsr_request_device_map;
+		add_timer(&acb->eternal_timer);
+	return 0;
+	controller_stop:
+		arcmsr_stop_adapter_bgrb(acb);
+		arcmsr_flush_adapter_cache(acb);
+	controller_unregister:
+		scsi_remove_host(host);
+		arcmsr_free_ccb_pool(acb);
+		arcmsr_unmap_pciregion(acb);
+		pci_release_regions(pdev);
+		scsi_host_put(host);	
+		pci_disable_device(pdev);
+	return -ENODEV;
+}
+
 static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id
*id)
 {
 	struct Scsi_Host *host;
@@ -1539,14 +1617,7 @@ static void arcmsr_hbaC_postqueue_isr(st
 	throttling++;
 	}
 }
-/*
-***************************************************************************
*******
-** Handle a message interrupt
-**
-** The only message interrupt we expect is in response to a query for the
current adapter config.  
-** We want this in order to compare the drivemap so that we can detect
newly-attached drives.
-***************************************************************************
*******
-*/
+
 static void arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A *reg  = acb->pmuA;
@@ -1562,15 +1633,7 @@ static void arcmsr_hbaB_message_isr(stru
 	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
-/*
-***************************************************************************
*******
-** Handle a message interrupt
-**
-** The only message interrupt we expect is in response to a query for the
-** current adapter config.
-** We want this in order to compare the drivemap so that we can detect
newly-attached drives.
-***************************************************************************
*******
-*/
+
 static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_C *reg  = acb->pmuC;
