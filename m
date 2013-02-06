From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 2/5]  arcmsr: Support Hibernation
Date: Wed, 6 Feb 2013 16:36:08 +0800
Message-ID: <C9CA5F0351AD4BD282E0579486DA7AB8@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0003_01CE0488.14A760A0"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org, =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0003_01CE0488.14A760A0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Support hibernation for whole series of RAID controllers
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_0003_01CE0488.14A760A0
Content-Type: application/octet-stream;
	name="patch2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch2"

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h	2013-02-06 16:27:33.655790583 +0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h	2013-02-06 16:27:59.615397282 +0800=0A=
@@ -64,6 +64,7 @@ struct device_attribute;=0A=
 #define ARCMSR_MAX_HBB_POSTQUEUE		264=0A=
 #define ARCMSR_MAX_XFER_LEN			0x26000=0A=
 #define ARCMSR_CDB_SG_PAGE_LENGTH		256=0A=
+#define ARCMST_NUM_MSIX_VECTORS		4=0A=
 #ifndef PCI_DEVICE_ID_ARECA_1880=0A=
 	#define PCI_DEVICE_ID_ARECA_1880	0x1880=0A=
  #endif=0A=
@@ -510,6 +511,7 @@ struct AdapterControlBlock=0A=
 	struct pci_dev *pdev;=0A=
 	struct Scsi_Host *host;=0A=
 	unsigned long vir2phy_offset;=0A=
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];=0A=
 	/* Offset is used in making arc cdb physical to virtual calculations */=0A=
 	uint32_t outbound_int_enable;=0A=
 	uint32_t cdb_phyaddr_hi32;=0A=
@@ -546,6 +548,8 @@ struct AdapterControlBlock=0A=
 	/* iop init */=0A=
 	#define ACB_F_ABORT				0x0200=0A=
 	#define ACB_F_FIRMWARE_TRAP			0x0400=0A=
+	#define ACB_F_MSI_ENABLED			0x1000=0A=
+	#define ACB_F_MSIX_ENABLED			0x2000=0A=
 	struct CommandControlBlock *pccb_pool[ARCMSR_MAX_FREECCB_NUM];=0A=
 	/* used for memory free */=0A=
 	struct list_head ccb_free_list;=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2013-02-06 16:27:34.139804136 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2013-02-06 16:27:59.960413119 =
+0800=0A=
@@ -89,11 +89,18 @@ static int arcmsr_bios_param(struct scsi=0A=
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd =
*cmd);=0A=
 static int arcmsr_probe(struct pci_dev *pdev,=0A=
 				const struct pci_device_id *id);=0A=
+#ifdef CONFIG_PM=0A=
+	static int arcmsr_suspend(struct pci_dev *pdev,=0A=
+	pm_message_t state);=0A=
+	static int arcmsr_resume(struct pci_dev *pdev);=0A=
+#endif=0A=
 static void arcmsr_remove(struct pci_dev *pdev);=0A=
 static void arcmsr_shutdown(struct pci_dev *pdev);=0A=
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);=0A=
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,=0A=
+	u32 orig_mask);=0A=
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);=0A=
@@ -166,6 +173,10 @@ static struct pci_driver arcmsr_pci_driv=0A=
 	.id_table			=3D arcmsr_device_id_table,=0A=
 	.probe			=3D arcmsr_probe,=0A=
 	.remove			=3D arcmsr_remove,=0A=
+	#ifdef CONFIG_PM=0A=
+		.suspend		=3D arcmsr_suspend,=0A=
+		.resume		=3D arcmsr_resume,=0A=
+	#endif=0A=
 	.shutdown		=3D arcmsr_shutdown,=0A=
 };=0A=
 /*=0A=
@@ -553,10 +564,10 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 							psdev =3D=0A=
 							scsi_device_lookup(acb->host,=0A=
 							0, target, lun);=0A=
-						if (psdev !=3D NULL) {=0A=
-							scsi_remove_device(psdev);=0A=
-							scsi_device_put(psdev);=0A=
-						}=0A=
+							if (psdev !=3D NULL) {=0A=
+								scsi_remove_device(psdev);=0A=
+								scsi_device_put(psdev);=0A=
+							}=0A=
 						}=0A=
 						temp >>=3D 1;=0A=
 						diff >>=3D 1;=0A=
@@ -663,6 +674,133 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 	}=0A=
 }=0A=
 =0A=
+#ifdef CONFIG_PM=0A=
+	static int=0A=
+	arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
+	{=0A=
+		int i;=0A=
+		uint32_t intmask_org;=0A=
+		struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
+		struct AdapterControlBlock *acb =3D=0A=
+			(struct AdapterControlBlock *)host->hostdata;=0A=
+=0A=
+		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+		if (acb->acb_flags & ACB_F_MSI_ENABLED) {=0A=
+			free_irq(pdev->irq, acb);=0A=
+			pci_disable_msi(pdev);=0A=
+		} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
+			for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {=0A=
+				free_irq(acb->entries[i].vector, acb);=0A=
+			}=0A=
+			pci_disable_msix(pdev);=0A=
+		} else {=0A=
+			free_irq(pdev->irq, acb);=0A=
+		}=0A=
+		del_timer_sync(&acb->eternal_timer);=0A=
+		flush_scheduled_work();=0A=
+		arcmsr_stop_adapter_bgrb(acb);=0A=
+		arcmsr_flush_adapter_cache(acb);=0A=
+		arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+		pci_set_drvdata(pdev, host);=0A=
+		pci_save_state(pdev);=0A=
+		pci_disable_device(pdev);=0A=
+		pci_set_power_state(pdev, pci_choose_state(pdev, state));=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	static int=0A=
+	arcmsr_resume(struct pci_dev *pdev)=0A=
+	{=0A=
+		int error, i, j;=0A=
+		struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
+		struct AdapterControlBlock *acb =3D=0A=
+			(struct AdapterControlBlock *)host->hostdata;=0A=
+		struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];=0A=
+		pci_set_power_state(pdev, PCI_D0);=0A=
+		pci_enable_wake(pdev, PCI_D0, 0);=0A=
+		pci_restore_state(pdev);=0A=
+		if (pci_enable_device(pdev)) {=0A=
+			printk("%s: pci_enable_device error\n", __func__);=0A=
+			return -ENODEV;=0A=
+		}=0A=
+		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));=0A=
+		if (error) {=0A=
+			error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
+			if (error) {=0A=
+				pr_warn("scsi%d: No suitable DMA mask available\n",=0A=
+				       host->host_no);=0A=
+				goto controller_unregister;=0A=
+			}=0A=
+		}=0A=
+		pci_set_master(pdev);=0A=
+		arcmsr_iop_init(acb);=0A=
+		if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {=0A=
+			if (!pci_enable_msix(pdev, entries,=0A=
+				ARCMST_NUM_MSIX_VECTORS)) {=0A=
+				for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS;=0A=
+				i++) {=0A=
+					entries[i].entry =3D i;=0A=
+					if (request_irq(entries[i].vector,=0A=
+					arcmsr_do_interrupt, 0,=0A=
+					"arcmsr", acb)) {=0A=
+						for (j =3D 0 ; j < i ; j++)=0A=
+							free_irq(entries[i].vector,=0A=
+							acb);=0A=
+						goto controller_stop;=0A=
+					}=0A=
+					acb->entries[i] =3D entries[i];=0A=
+				}=0A=
+				acb->acb_flags |=3D ACB_F_MSIX_ENABLED;=0A=
+			} else {=0A=
+				printk("arcmsr%d: MSI-X"=0A=
+				"failed to enable\n", acb->host->host_no);=0A=
+				if (request_irq(pdev->irq,=0A=
+				arcmsr_do_interrupt, IRQF_SHARED,=0A=
+				"arcmsr", acb)) {=0A=
+					goto controller_stop;=0A=
+				}=0A=
+			}=0A=
+		} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {=0A=
+			if (!pci_enable_msi(pdev)) {=0A=
+				acb->acb_flags |=3D ACB_F_MSI_ENABLED;=0A=
+			}=0A=
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+				IRQF_SHARED, "arcmsr", acb)) {=0A=
+				goto controller_stop;=0A=
+			}=0A=
+		} else {=0A=
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+				IRQF_SHARED, "arcmsr", acb)) {=0A=
+				goto controller_stop;=0A=
+			}=0A=
+		}=0A=
+		INIT_WORK(&acb->arcmsr_do_message_isr_bh,=0A=
+		arcmsr_message_isr_bh_fn);=0A=
+		atomic_set(&acb->rq_map_token, 16);=0A=
+		atomic_set(&acb->ante_token_value, 16);=0A=
+		acb->fw_flag =3D FW_NORMAL;=0A=
+		init_timer(&acb->eternal_timer);=0A=
+		acb->eternal_timer.expires =3D jiffies +=0A=
+			msecs_to_jiffies(6 * HZ);=0A=
+		acb->eternal_timer.data =3D (unsigned long) acb;=0A=
+		acb->eternal_timer.function =3D=0A=
+			&arcmsr_request_device_map;=0A=
+		add_timer(&acb->eternal_timer);=0A=
+		return 0;=0A=
+controller_stop:=0A=
+			arcmsr_stop_adapter_bgrb(acb);=0A=
+			arcmsr_flush_adapter_cache(acb);=0A=
+controller_unregister:=0A=
+			scsi_remove_host(host);=0A=
+			arcmsr_free_ccb_pool(acb);=0A=
+			arcmsr_unmap_pciregion(acb);=0A=
+			pci_release_regions(pdev);=0A=
+			scsi_host_put(host);=0A=
+			pci_disable_device(pdev);=0A=
+		return -ENODEV;=0A=
+	}=0A=
+#endif=0A=
+=0A=
 static int arcmsr_probe(struct pci_dev *pdev, const struct =
pci_device_id *id)=0A=
 {=0A=
 	struct Scsi_Host *host;=0A=
@@ -680,8 +818,7 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	if (error) {=0A=
 		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
 		if (error) {=0A=
-			printk(KERN_WARNING=0A=
-			       "scsi%d: No suitable DMA mask available\n",=0A=
+			pr_warn("scsi%d: No suitable DMA mask available\n",=0A=
 			       host->host_no);=0A=
 			goto scsi_host_release;=0A=
 		}=0A=
@@ -960,12 +1097,12 @@ arcmsr_report_ccb_state(struct AdapterCo=0A=
 =0A=
 		default:=0A=
 			pr_notice("arcmsr%d: scsi id =3D %d lun =3D %d"=0A=
-			"isr get command error done, but got unknown"=0A=
-			"DeviceStatus =3D 0x%x\n"=0A=
-			, acb->host->host_no=0A=
-			, id=0A=
-			, lun=0A=
-			, ccb->arcmsr_cdb.DeviceStatus);=0A=
+				"isr get command error done, but got unknown"=0A=
+				"DeviceStatus =3D 0x%x\n"=0A=
+				, acb->host->host_no=0A=
+				, id=0A=
+				, lun=0A=
+				, ccb->arcmsr_cdb.DeviceStatus);=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
 			ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
 			arcmsr_ccb_complete(ccb);=0A=
@@ -996,7 +1133,7 @@ struct CommandControlBlock *pCCB, bool e=0A=
 		pr_notice("arcmsr%d: isr get an illegal ccb command"=0A=
 			"done acb =3D '0x%p'"=0A=
 			"ccb =3D '0x%p' ccbacb =3D '0x%p' startdone =3D 0x%x"=0A=
-			" ccboutstandingcount =3D %d\n"=0A=
+			"ccboutstandingcount =3D %d\n"=0A=
 			, acb->host->host_no=0A=
 			, acb=0A=
 			, pCCB=0A=
@@ -1023,6 +1160,7 @@ arcmsr_done4abort_postqueue(struct Adapt=0A=
 		uint32_t outbound_intstatus;=0A=
 		outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
 					acb->outbound_int_enable;=0A=
+		/*clear and abort all outbound posted Q*/=0A=
 		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
 		while (((flag_ccb =3D readl(&reg->outbound_queueport))=0A=
 			!=3D 0xFFFFFFFF)=0A=
@@ -2262,8 +2400,8 @@ arcmsr_hbaA_get_config(struct AdapterCon=0A=
 		&reg->inbound_msgaddr0);=0A=
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
 		pr_notice("arcmsr%d: wait 'get adapter firmware"=0A=
-		"miscellaneous data' timeout\n",=0A=
-		acb->host->host_no);=0A=
+			"miscellaneous data' timeout\n",=0A=
+			acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	count =3D 8;=0A=
@@ -3368,8 +3506,8 @@ arcmsr_abort(struct scsi_cmnd *cmd)=0A=
 	int rtn =3D FAILED;=0A=
 	pr_notice("arcmsr%d: abort device command of"=0A=
 	"scsi id =3D %d lun =3D %d\n",=0A=
-	acb->host->host_no,=0A=
-	cmd->device->id, cmd->device->lun);=0A=
+		acb->host->host_no,=0A=
+		cmd->device->id, cmd->device->lun);=0A=
 	acb->acb_flags |=3D ACB_F_ABORT;=0A=
 	acb->num_aborts++;=0A=
 	/*=0A=

------=_NextPart_000_0003_01CE0488.14A760A0--
