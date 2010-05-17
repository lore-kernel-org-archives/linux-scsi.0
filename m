From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 1/4] SCSI: Support HW reset for EH and polling scheme for scsi device
Date: Mon, 17 May 2010 11:22:42 +0800
Message-ID: <6464C97C23D24B9F911F1CD229286A9E@areca4e4f859d4>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_01CAF5B3.45DAD1C0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:45502 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0EQDWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 May 2010 23:22:53 -0400
References: 
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0012_01CAF5B3.45DAD1C0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

1. To support instantaneous report for SCSI device existing by periodic
polling
2. In arcmsr_iop_xfer(), inform AP of F/W's deadlock state to prevent
endless waiting
3. To block the coming SCSI command while the driver is handling bus reset
4. To support HW reset in bus reset error handler
Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >

------=_NextPart_000_0012_01CAF5B3.45DAD1C0
Content-Type: application/octet-stream;
	name="patch1-4"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch1-4"

diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change linux-2.6/drivers/scsi/arcmsr/arcmsr_attr.c =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr_attr.c=0A=
--- linux-2.6/drivers/scsi/arcmsr/arcmsr_attr.c	2010-05-04 =
12:13:49.000000000 +0800=0A=
+++ linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr_attr.c	=
2008-06-13 11:02:58.000000000 +0800=0A=
@@ -189,6 +189,7 @@ static struct bin_attribute arcmsr_sysfs=0A=
 	.attr =3D {=0A=
 		.name =3D "mu_read",=0A=
 		.mode =3D S_IRUSR ,=0A=
+		.owner =3D THIS_MODULE,=0A=
 	},=0A=
 	.size =3D 1032,=0A=
 	.read =3D arcmsr_sysfs_iop_message_read,=0A=
@@ -198,6 +199,7 @@ static struct bin_attribute arcmsr_sysfs=0A=
 	.attr =3D {=0A=
 		.name =3D "mu_write",=0A=
 		.mode =3D S_IWUSR,=0A=
+		.owner =3D THIS_MODULE,=0A=
 	},=0A=
 	.size =3D 1032,=0A=
 	.write =3D arcmsr_sysfs_iop_message_write,=0A=
@@ -207,6 +209,7 @@ static struct bin_attribute arcmsr_sysfs=0A=
 	.attr =3D {=0A=
 		.name =3D "mu_clear",=0A=
 		.mode =3D S_IWUSR,=0A=
+		.owner =3D THIS_MODULE,=0A=
 	},=0A=
 	.size =3D 1,=0A=
 	.write =3D arcmsr_sysfs_iop_message_clear,=0A=
diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change linux-2.6/drivers/scsi/arcmsr/arcmsr.h =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr.h=0A=
--- linux-2.6/drivers/scsi/arcmsr/arcmsr.h	2010-05-04 12:13:46.000000000 =
+0800=0A=
+++ linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr.h	2010-05-03 =
11:35:24.000000000 +0800=0A=
@@ -48,7 +48,7 @@ struct device_attribute;=0A=
 /*The limit of outstanding scsi command that firmware can handle*/=0A=
 #define ARCMSR_MAX_OUTSTANDING_CMD						256=0A=
 #define ARCMSR_MAX_FREECCB_NUM							320=0A=
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2008/02/27"=0A=
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2008/11/03"=0A=
 #define ARCMSR_SCSI_INITIATOR_ID						255=0A=
 #define ARCMSR_MAX_XFER_SECTORS							512=0A=
 #define ARCMSR_MAX_XFER_SECTORS_B						4096=0A=
@@ -110,6 +110,8 @@ struct CMD_MESSAGE_FIELD=0A=
 #define FUNCTION_SAY_HELLO			0x0807=0A=
 #define FUNCTION_SAY_GOODBYE			0x0808=0A=
 #define FUNCTION_FLUSH_ADAPTER_CACHE		0x0809=0A=
+#define FUNCTION_GET_FIRMWARE_STATUS			0x080A=0A=
+#define FUNCTION_HARDWARE_RESET			0x080B=0A=
 /* ARECA IO CONTROL CODE*/=0A=
 #define ARCMSR_MESSAGE_READ_RQBUFFER       \=0A=
 	ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER=0A=
@@ -133,6 +135,7 @@ struct CMD_MESSAGE_FIELD=0A=
 #define ARCMSR_MESSAGE_RETURNCODE_OK              0x00000001=0A=
 #define ARCMSR_MESSAGE_RETURNCODE_ERROR           0x00000006=0A=
 #define ARCMSR_MESSAGE_RETURNCODE_3F              0x0000003F=0A=
+#define ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON	0x00000088=0A=
 /*=0A=
 *************************************************************=0A=
 **   structure for holding DMA address data=0A=
@@ -341,13 +344,13 @@ struct MessageUnit_B=0A=
 	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
 	uint32_t	postq_index;=0A=
 	uint32_t	doneq_index;=0A=
-	void		__iomem *drv2iop_doorbell_reg;=0A=
-	void		__iomem *drv2iop_doorbell_mask_reg;=0A=
-	void		__iomem *iop2drv_doorbell_reg;=0A=
-	void		__iomem *iop2drv_doorbell_mask_reg;=0A=
-	void		__iomem *msgcode_rwbuffer_reg;=0A=
-	void		__iomem *ioctl_wbuffer_reg;=0A=
-	void		__iomem *ioctl_rbuffer_reg;=0A=
+	uint32_t		__iomem *drv2iop_doorbell_reg;=0A=
+	uint32_t		__iomem *drv2iop_doorbell_mask_reg;=0A=
+	uint32_t		__iomem *iop2drv_doorbell_reg;=0A=
+	uint32_t		__iomem *iop2drv_doorbell_mask_reg;=0A=
+	uint32_t		__iomem *msgcode_rwbuffer_reg;=0A=
+	uint32_t		__iomem *ioctl_wbuffer_reg;=0A=
+	uint32_t		__iomem *ioctl_rbuffer_reg;=0A=
 };=0A=
 =0A=
 /*=0A=
@@ -375,6 +378,7 @@ struct AdapterControlBlock=0A=
 	/* message unit ATU inbound base address0 */=0A=
 =0A=
 	uint32_t			acb_flags;=0A=
+	uint8_t                   		adapter_index;=0A=
 	#define ACB_F_SCSISTOPADAPTER         	0x0001=0A=
 	#define ACB_F_MSG_STOP_BGRB     	0x0002=0A=
 	/* stop RAID background rebuild */=0A=
@@ -390,7 +394,7 @@ struct AdapterControlBlock=0A=
 	#define ACB_F_BUS_RESET               	0x0080=0A=
 	#define ACB_F_IOP_INITED              	0x0100=0A=
 	/* iop init */=0A=
-=0A=
+	#define ACB_F_FIRMWARE_TRAP           		0x0400=0A=
 	struct CommandControlBlock *			pccb_pool[ARCMSR_MAX_FREECCB_NUM];=0A=
 	/* used for memory free */=0A=
 	struct list_head		ccb_free_list;=0A=
@@ -423,12 +427,19 @@ struct AdapterControlBlock=0A=
 #define ARECA_RAID_GOOD               0xaa=0A=
 	uint32_t			num_resets;=0A=
 	uint32_t			num_aborts;=0A=
+	uint32_t			signature;=0A=
 	uint32_t			firm_request_len;=0A=
 	uint32_t			firm_numbers_queue;=0A=
 	uint32_t			firm_sdram_size;=0A=
 	uint32_t			firm_hd_channels;=0A=
 	char				firm_model[12];=0A=
 	char				firm_version[20];=0A=
+	char			device_map[20];			/*21,84-99*/=0A=
+	struct work_struct 		arcmsr_do_message_isr_bh;=0A=
+	struct timer_list		eternal_timer;=0A=
+	unsigned short		fw_state;=0A=
+	atomic_t 			rq_map_token;=0A=
+	int			ante_token_value;=0A=
 };/* HW_DEVICE_EXTENSION */=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change linux-2.6/drivers/scsi/arcmsr/arcmsr_hba.c =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr_hba.c=0A=
--- linux-2.6/drivers/scsi/arcmsr/arcmsr_hba.c	2010-05-04 =
12:13:54.000000000 +0800=0A=
+++ linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr_hba.c	=
2010-05-17 11:07:20.000000000 +0800=0A=
@@ -71,8 +71,16 @@=0A=
 #include <scsi/scsicam.h>=0A=
 #include "arcmsr.h"=0A=
 =0A=
+#ifdef CONFIG_SCSI_ARCMSR_RESET=0A=
+	static int sleeptime =3D 20;=0A=
+	static int retrycount =3D 12;=0A=
+	module_param(sleeptime, int, S_IRUGO|S_IWUSR);=0A=
+	MODULE_PARM_DESC(sleeptime, "The waiting period for FW ready while bus =
reset");=0A=
+	module_param(retrycount, int, S_IRUGO|S_IWUSR);=0A=
+	MODULE_PARM_DESC(retrycount, "The retry count for FW ready while bus =
reset");=0A=
+#endif=0A=
 MODULE_AUTHOR("Erich Chen <support@areca.com.tw>");=0A=
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID HOST =
Adapter");=0A=
+MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host =
Bus Adapter");=0A=
 MODULE_LICENSE("Dual BSD/GPL");=0A=
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);=0A=
 =0A=
@@ -95,6 +103,13 @@ static u32 arcmsr_disable_outbound_ints(=0A=
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);=0A=
+static void arcmsr_request_device_map(unsigned long pacb);=0A=
+static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_request_hbb_device_map(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_message_isr_bh_fn(struct work_struct *work);=0A=
+static void *arcmsr_get_firmware_spec(struct AdapterControlBlock *acb, =
int mode);=0A=
+static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);=0A=
+=0A=
 static const char *arcmsr_info(struct Scsi_Host *);=0A=
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);=0A=
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,=0A=
@@ -111,7 +126,7 @@ static int arcmsr_adjust_disk_queue_dept=0A=
 =0A=
 static struct scsi_host_template arcmsr_scsi_host_template =3D {=0A=
 	.module			=3D THIS_MODULE,=0A=
-	.name			=3D "ARCMSR ARECA SATA/SAS RAID HOST Adapter"=0A=
+	.name			=3D "ARCMSR ARECA SATA/SAS RAID Host Bus Adapter"=0A=
 							ARCMSR_DRIVER_VERSION,=0A=
 	.info			=3D arcmsr_info,=0A=
 	.queuecommand		=3D arcmsr_queue_command,=0A=
@@ -127,16 +142,6 @@ static struct scsi_host_template arcmsr_=0A=
 	.use_clustering		=3D ENABLE_CLUSTERING,=0A=
 	.shost_attrs		=3D arcmsr_host_attrs,=0A=
 };=0A=
-#ifdef CONFIG_SCSI_ARCMSR_AER=0A=
-static pci_ers_result_t arcmsr_pci_slot_reset(struct pci_dev *pdev);=0A=
-static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev,=0A=
-						pci_channel_state_t state);=0A=
-=0A=
-static struct pci_error_handlers arcmsr_pci_error_handlers =3D {=0A=
-	.error_detected		=3D arcmsr_pci_error_detected,=0A=
-	.slot_reset		=3D arcmsr_pci_slot_reset,=0A=
-};=0A=
-#endif=0A=
 static struct pci_device_id arcmsr_device_id_table[] =3D {=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1120)},=0A=
@@ -165,9 +170,6 @@ static struct pci_driver arcmsr_pci_driv=0A=
 	.probe			=3D arcmsr_probe,=0A=
 	.remove			=3D arcmsr_remove,=0A=
 	.shutdown		=3D arcmsr_shutdown,=0A=
-	#ifdef CONFIG_SCSI_ARCMSR_AER=0A=
-	.err_handler		=3D &arcmsr_pci_error_handlers,=0A=
-	#endif=0A=
 };=0A=
 =0A=
 static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id)=0A=
@@ -235,10 +237,9 @@ static int arcmsr_alloc_ccb_pool(struct =0A=
 		void *dma_coherent;=0A=
 		dma_addr_t dma_coherent_handle, dma_addr;=0A=
 		struct CommandControlBlock *ccb_tmp;=0A=
-		uint32_t intmask_org;=0A=
 		int i, j;=0A=
 =0A=
-		acb->pmuA =3D pci_ioremap_bar(pdev, 0);=0A=
+		acb->pmuA =3D ioremap(pci_resource_start(pdev, 0), =
pci_resource_len(pdev, 0));=0A=
 		if (!acb->pmuA) {=0A=
 			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",=0A=
 							acb->host->host_no);=0A=
@@ -280,12 +281,6 @@ static int arcmsr_alloc_ccb_pool(struct =0A=
 		for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
 			for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
 				acb->devstate[i][j] =3D ARECA_RAID_GONE;=0A=
-=0A=
-		/*=0A=
-		** here we need to tell iop 331 our ccb_tmp.HighPart=0A=
-		** if ccb_tmp.HighPart is not zero=0A=
-		*/=0A=
-		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 		}=0A=
 		break;=0A=
 =0A=
@@ -296,7 +291,6 @@ static int arcmsr_alloc_ccb_pool(struct =0A=
 		void __iomem *mem_base0, *mem_base1;=0A=
 		void *dma_coherent;=0A=
 		dma_addr_t dma_coherent_handle, dma_addr;=0A=
-		uint32_t intmask_org;=0A=
 		struct CommandControlBlock *ccb_tmp;=0A=
 		int i, j;=0A=
 =0A=
@@ -332,11 +326,13 @@ static int arcmsr_alloc_ccb_pool(struct =0A=
 		reg =3D (struct MessageUnit_B *)(dma_coherent +=0A=
 		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock));=0A=
 		acb->pmuB =3D reg;=0A=
-		mem_base0 =3D pci_ioremap_bar(pdev, 0);=0A=
+		mem_base0 =3D ioremap(pci_resource_start(pdev, 0),=0A=
+					pci_resource_len(pdev, 0));=0A=
 		if (!mem_base0)=0A=
 			goto out;=0A=
 =0A=
-		mem_base1 =3D pci_ioremap_bar(pdev, 2);=0A=
+		mem_base1 =3D ioremap(pci_resource_start(pdev, 2),=0A=
+					pci_resource_len(pdev, 2));=0A=
 		if (!mem_base1) {=0A=
 			iounmap(mem_base0);=0A=
 			goto out;=0A=
@@ -356,12 +352,6 @@ static int arcmsr_alloc_ccb_pool(struct =0A=
 		for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
 			for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
 				acb->devstate[i][j] =3D ARECA_RAID_GOOD;=0A=
-=0A=
-		/*=0A=
-		** here we need to tell iop 331 our ccb_tmp.HighPart=0A=
-		** if ccb_tmp.HighPart is not zero=0A=
-		*/=0A=
-		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
@@ -373,6 +363,88 @@ out:=0A=
 		sizeof(struct MessageUnit_B)), acb->dma_coherent, =
acb->dma_coherent_handle);=0A=
 	return -ENOMEM;=0A=
 }=0A=
+static void arcmsr_message_isr_bh_fn(struct work_struct *work)=0A=
+{=0A=
+	struct AdapterControlBlock *acb =3D container_of(work, struct =
AdapterControlBlock, arcmsr_do_message_isr_bh);=0A=
+=0A=
+	switch (acb->adapter_type) {=0A=
+		case ACB_ADAPTER_TYPE_A: {=0A=
+=0A=
+			struct MessageUnit_A __iomem *reg  =3D acb->pmuA;=0A=
+			char *acb_dev_map =3D (char *)acb->device_map;=0A=
+			uint32_t __iomem *signature =3D (uint32_t __iomem *) =
(&reg->message_rwbuffer[0]);=0A=
+			char __iomem *devicemap =3D (char __iomem *) =
(&reg->message_rwbuffer[21]);=0A=
+			int target, lun;=0A=
+			struct scsi_device *psdev;=0A=
+			char diff;=0A=
+=0A=
+			atomic_inc(&acb->rq_map_token);=0A=
+			if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
+				for (target =3D 0; target < ARCMSR_MAX_TARGETID - 1; target++) {=0A=
+					diff =3D (*acb_dev_map)^readb(devicemap);=0A=
+					if (diff !=3D 0) {=0A=
+						char temp;=0A=
+						*acb_dev_map =3D readb(devicemap);=0A=
+						temp =3D *acb_dev_map;=0A=
+						for (lun =3D 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {=0A=
+							if ((temp & 0x01) =3D=3D 1 && (diff & 0x01) =3D=3D 1) {=0A=
+								scsi_add_device(acb->host, 0, target, lun);=0A=
+							} else if ((temp & 0x01) =3D=3D 0 && (diff & 0x01) =3D=3D 1) {=0A=
+								psdev =3D scsi_device_lookup(acb->host, 0, target, lun);=0A=
+								if (psdev !=3D NULL) {=0A=
+									scsi_remove_device(psdev);=0A=
+									scsi_device_put(psdev);=0A=
+								}=0A=
+							}=0A=
+							temp >>=3D 1;=0A=
+							diff >>=3D 1;=0A=
+						}=0A=
+					}=0A=
+					devicemap++;=0A=
+					acb_dev_map++;=0A=
+				}=0A=
+			}=0A=
+			break;=0A=
+		}=0A=
+=0A=
+		case ACB_ADAPTER_TYPE_B: {=0A=
+			struct MessageUnit_B *reg  =3D acb->pmuB;=0A=
+			char *acb_dev_map =3D (char *)acb->device_map;=0A=
+			uint32_t __iomem *signature =3D (uint32_t __iomem =
*)(&reg->msgcode_rwbuffer_reg[0]);=0A=
+			char __iomem *devicemap =3D (char __iomem =
*)(&reg->msgcode_rwbuffer_reg[21]);=0A=
+			int target, lun;=0A=
+			struct scsi_device *psdev;=0A=
+			char diff;=0A=
+=0A=
+			atomic_inc(&acb->rq_map_token);=0A=
+			if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
+				for (target =3D 0; target < ARCMSR_MAX_TARGETID - 1; target++) {=0A=
+					diff =3D (*acb_dev_map)^readb(devicemap);=0A=
+					if (diff !=3D 0) {=0A=
+						char temp;=0A=
+						*acb_dev_map =3D readb(devicemap);=0A=
+						temp =3D *acb_dev_map;=0A=
+						for (lun =3D 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {=0A=
+							if ((temp & 0x01) =3D=3D 1 && (diff & 0x01) =3D=3D 1) {=0A=
+								scsi_add_device(acb->host, 0, target, lun);=0A=
+							} else if ((temp & 0x01) =3D=3D 0 && (diff & 0x01) =3D=3D 1) {=0A=
+								psdev =3D scsi_device_lookup(acb->host, 0, target, lun);=0A=
+								if (psdev !=3D NULL) {=0A=
+									scsi_remove_device(psdev);=0A=
+									scsi_device_put(psdev);=0A=
+								}=0A=
+							}=0A=
+							temp >>=3D 1;=0A=
+							diff >>=3D 1;=0A=
+						}=0A=
+					}=0A=
+					devicemap++;=0A=
+					acb_dev_map++;=0A=
+				}=0A=
+			}=0A=
+		}=0A=
+	}=0A=
+}=0A=
 =0A=
 static int arcmsr_probe(struct pci_dev *pdev,=0A=
 	const struct pci_device_id *id)=0A=
@@ -431,17 +503,17 @@ static int arcmsr_probe(struct pci_dev *=0A=
 			   ACB_F_MESSAGE_WQBUFFER_READED);=0A=
 	acb->acb_flags &=3D ~ACB_F_SCSISTOPADAPTER;=0A=
 	INIT_LIST_HEAD(&acb->ccb_free_list);=0A=
-=0A=
+	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);=0A=
 	error =3D arcmsr_alloc_ccb_pool(acb);=0A=
 	if (error)=0A=
 		goto out_release_regions;=0A=
 =0A=
+	arcmsr_iop_init(acb);=0A=
 	error =3D request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
 			    IRQF_SHARED, "arcmsr", acb);=0A=
 	if (error)=0A=
 		goto out_free_ccb_pool;=0A=
 =0A=
-	arcmsr_iop_init(acb);=0A=
 	pci_set_drvdata(pdev, host);=0A=
 	if (strncmp(acb->firm_version, "V1.42", 5) >=3D 0)=0A=
 		host->max_sectors=3D ARCMSR_MAX_XFER_SECTORS_B;=0A=
@@ -458,6 +530,14 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	#ifdef CONFIG_SCSI_ARCMSR_AER=0A=
 	pci_enable_pcie_error_reporting(pdev);=0A=
 	#endif=0A=
+	atomic_set(&acb->rq_map_token, 16);=0A=
+	acb->fw_state =3D true;=0A=
+	init_timer(&acb->eternal_timer);=0A=
+	acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(10*HZ);=0A=
+	acb->eternal_timer.data =3D (unsigned long) acb;=0A=
+	acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
+	add_timer(&acb->eternal_timer);=0A=
+=0A=
 	return 0;=0A=
  out_free_sysfs:=0A=
  out_free_irq:=0A=
@@ -517,40 +597,48 @@ static uint8_t arcmsr_hbb_wait_msgint_re=0A=
 	return 0xff;=0A=
 }=0A=
 =0A=
-static void arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)=0A=
+static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 =0A=
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);=0A=
-	if (arcmsr_hba_wait_msgint_ready(acb))=0A=
+	if (arcmsr_hba_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE=0A=
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
 			, acb->host->host_no);=0A=
+		return 0xff;=0A=
+	}=0A=
+	return 0x00;=0A=
 }=0A=
 =0A=
-static void arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)=0A=
+static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 =0A=
 	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell_reg);=0A=
-	if (arcmsr_hbb_wait_msgint_ready(acb))=0A=
+	if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE=0A=
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
 			, acb->host->host_no);=0A=
+		return 0xff;=0A=
+	}=0A=
+	return 0x00;=0A=
 }=0A=
 =0A=
-static void arcmsr_abort_allcmd(struct AdapterControlBlock *acb)=0A=
+static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
+	uint8_t rtnval =3D 0;=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		arcmsr_abort_hba_allcmd(acb);=0A=
+		rtnval =3D arcmsr_abort_hba_allcmd(acb);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		arcmsr_abort_hbb_allcmd(acb);=0A=
+		rtnval =3D arcmsr_abort_hbb_allcmd(acb);=0A=
 		}=0A=
 	}=0A=
+	return rtnval;=0A=
 }=0A=
 =0A=
 static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)=0A=
@@ -648,8 +736,7 @@ static u32 arcmsr_disable_outbound_ints(=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A : {=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-		orig_mask =3D readl(&reg->outbound_intmask)|\=0A=
-				ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE;=0A=
+		orig_mask =3D readl(&reg->outbound_intmask);=0A=
 		writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \=0A=
 						&reg->outbound_intmask);=0A=
 		}=0A=
@@ -657,8 +744,7 @@ static u32 arcmsr_disable_outbound_ints(=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B : {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		orig_mask =3D readl(reg->iop2drv_doorbell_mask_reg) & \=0A=
-					(~ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);=0A=
+		orig_mask =3D readl(reg->iop2drv_doorbell_mask_reg);=0A=
 		writel(0, reg->iop2drv_doorbell_mask_reg);=0A=
 		}=0A=
 		break;=0A=
@@ -794,12 +880,13 @@ static void arcmsr_remove(struct pci_dev=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *) host->hostdata;=0A=
 	int poll_count =3D 0;=0A=
-=0A=
 	arcmsr_free_sysfs_attr(acb);=0A=
 	scsi_remove_host(host);=0A=
+	flush_scheduled_work();=0A=
+	del_timer_sync(&acb->eternal_timer);=0A=
+	arcmsr_disable_outbound_ints(acb);=0A=
 	arcmsr_stop_adapter_bgrb(acb);=0A=
 	arcmsr_flush_adapter_cache(acb);=0A=
-	arcmsr_disable_outbound_ints(acb);=0A=
 	acb->acb_flags |=3D ACB_F_SCSISTOPADAPTER;=0A=
 	acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
 =0A=
@@ -840,7 +927,9 @@ static void arcmsr_shutdown(struct pci_d=0A=
 	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *)host->hostdata;=0A=
-=0A=
+	del_timer_sync(&acb->eternal_timer);=0A=
+	arcmsr_disable_outbound_ints(acb);=0A=
+	flush_scheduled_work();=0A=
 	arcmsr_stop_adapter_bgrb(acb);=0A=
 	arcmsr_flush_adapter_cache(acb);=0A=
 }=0A=
@@ -860,7 +949,7 @@ static void arcmsr_module_exit(void)=0A=
 module_init(arcmsr_module_init);=0A=
 module_exit(arcmsr_module_exit);=0A=
 =0A=
-static void arcmsr_enable_outbound_ints(struct AdapterControlBlock =
*acb, \=0A=
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,=0A=
 						u32 intmask_org)=0A=
 {=0A=
 	u32 mask;=0A=
@@ -870,7 +959,8 @@ static void arcmsr_enable_outbound_ints(=0A=
 	case ACB_ADAPTER_TYPE_A : {=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 		mask =3D intmask_org & ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |=0A=
-			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);=0A=
+			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE|=0A=
+			     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);=0A=
 		writel(mask, &reg->outbound_intmask);=0A=
 		acb->outbound_int_enable =3D ~(intmask_org & mask) & 0x000000ff;=0A=
 		}=0A=
@@ -878,8 +968,10 @@ static void arcmsr_enable_outbound_ints(=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B : {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		mask =3D intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK | \=0A=
-			ARCMSR_IOP2DRV_DATA_READ_OK | ARCMSR_IOP2DRV_CDB_DONE);=0A=
+		mask =3D intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK |=0A=
+			ARCMSR_IOP2DRV_DATA_READ_OK |=0A=
+			ARCMSR_IOP2DRV_CDB_DONE |=0A=
+			ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);=0A=
 		writel(mask, reg->iop2drv_doorbell_mask_reg);=0A=
 		acb->outbound_int_enable =3D (intmask_org | mask) & 0x0000000f;=0A=
 		}=0A=
@@ -1047,8 +1139,8 @@ static void arcmsr_free_ccb_pool(struct =0A=
 	}=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		iounmap(reg->drv2iop_doorbell_reg - ARCMSR_DRV2IOP_DOORBELL);=0A=
-		iounmap(reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);=0A=
+		iounmap((u8 *)reg->drv2iop_doorbell_reg - ARCMSR_DRV2IOP_DOORBELL);=0A=
+		iounmap((u8 *)reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);=0A=
 		dma_free_coherent(&acb->pdev->dev,=0A=
 		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20 +=0A=
 		sizeof(struct MessageUnit_B)), acb->dma_coherent, =
acb->dma_coherent_handle);=0A=
@@ -1248,13 +1340,36 @@ static void arcmsr_hbb_postqueue_isr(str=0A=
 		reg->doneq_index =3D index;=0A=
 	}=0A=
 }=0A=
+/*=0A=
+************************************************************************=
**********=0A=
+** Handle a message interrupt=0A=
+**=0A=
+** The only message interrupt we expect is in response to a query for =
the current adapter config.=0A=
+** We want this in order to compare the drivemap so that we can detect =
newly-attached drives.=0A=
+************************************************************************=
**********=0A=
+*/=0A=
+static void arcmsr_hba_message_isr(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	struct MessageUnit_A *reg  =3D acb->pmuA;=0A=
+=0A=
+	/*clear interrupt and message state*/=0A=
+	writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);=0A=
+	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
+}=0A=
+static void arcmsr_hbb_message_isr(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	struct MessageUnit_B *reg  =3D acb->pmuB;=0A=
 =0A=
+	/*clear interrupt and message state*/=0A=
+	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);=0A=
+	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
+}=0A=
 static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_intstatus;=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 =0A=
-	outbound_intstatus =3D readl(&reg->outbound_intstatus) & \=0A=
+	outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
 							acb->outbound_int_enable;=0A=
 	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))	{=0A=
 		return 1;=0A=
@@ -1266,6 +1381,10 @@ static int arcmsr_handle_hba_isr(struct =0A=
 	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {=0A=
 		arcmsr_hba_postqueue_isr(acb);=0A=
 	}=0A=
+	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT) 	{=0A=
+		/* messenger of "driver to iop commands" */=0A=
+		arcmsr_hba_message_isr(acb);=0A=
+	}=0A=
 	return 0;=0A=
 }=0A=
 =0A=
@@ -1274,13 +1393,14 @@ static int arcmsr_handle_hbb_isr(struct =0A=
 	uint32_t outbound_doorbell;=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 =0A=
-	outbound_doorbell =3D readl(reg->iop2drv_doorbell_reg) & \=0A=
+	outbound_doorbell =3D readl(reg->iop2drv_doorbell_reg) &=0A=
 							acb->outbound_int_enable;=0A=
 	if (!outbound_doorbell)=0A=
 		return 1;=0A=
 =0A=
 	writel(~outbound_doorbell, reg->iop2drv_doorbell_reg);=0A=
-	/*in case the last action of doorbell interrupt clearance is cached, =
this action can push HW to write down the clear bit*/=0A=
+	/*in case the last action of doorbell interrupt clearance is cached,=0A=
+	this action can push HW to write down the clear bit*/=0A=
 	readl(reg->iop2drv_doorbell_reg);=0A=
 	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);=0A=
 	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) 	{=0A=
@@ -1292,6 +1412,10 @@ static int arcmsr_handle_hbb_isr(struct =0A=
 	if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {=0A=
 		arcmsr_hbb_postqueue_isr(acb);=0A=
 	}=0A=
+	if (outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+		/* messenger of "driver to iop commands" */=0A=
+		arcmsr_hbb_message_isr(acb);=0A=
+	}=0A=
 =0A=
 	return 0;=0A=
 }=0A=
@@ -1359,7 +1482,7 @@ void arcmsr_post_ioctldata2iop(struct Ad=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \=0A=
+static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
 					struct scsi_cmnd *cmd)=0A=
 {=0A=
 	struct CMD_MESSAGE_FIELD *pcmdmessagefld;=0A=
@@ -1397,6 +1520,13 @@ static int arcmsr_iop_message_xfer(struc=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			goto message_out;=0A=
 		}=0A=
+=0A=
+		if (!acb->fw_state) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+			goto message_out;=0A=
+		}=0A=
+=0A=
 		ptmpQbuffer =3D ver_addr;=0A=
 		while ((acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex)=0A=
 			&& (allxfer_len < 1031)) {=0A=
@@ -1443,6 +1573,12 @@ static int arcmsr_iop_message_xfer(struc=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			goto message_out;=0A=
 		}=0A=
+		if (!acb->fw_state) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+			goto message_out;=0A=
+		}=0A=
+=0A=
 		ptmpuserbuffer =3D ver_addr;=0A=
 		user_len =3D pcmdmessagefld->cmdmessage.Length;=0A=
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);=0A=
@@ -1495,6 +1631,11 @@ static int arcmsr_iop_message_xfer(struc=0A=
 =0A=
 	case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->rqbuffer;=0A=
+		if (!acb->fw_state) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+			goto message_out;=0A=
+		}=0A=
 =0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
@@ -1510,6 +1651,11 @@ static int arcmsr_iop_message_xfer(struc=0A=
 =0A=
 	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->wqbuffer;=0A=
+		if (!acb->fw_state) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+			goto message_out;=0A=
+		}=0A=
 =0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
@@ -1528,6 +1674,11 @@ static int arcmsr_iop_message_xfer(struc=0A=
 =0A=
 	case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {=0A=
 		uint8_t *pQbuffer;=0A=
+		if (!acb->fw_state) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+			goto message_out;=0A=
+		}=0A=
 =0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
@@ -1550,13 +1701,22 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_RETURN_CODE_3F: {=0A=
+		if (!acb->fw_state) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+			goto message_out;=0A=
+		}=0A=
 		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_3F;=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_SAY_HELLO: {=0A=
 		int8_t *hello_string =3D "Hello! I am ARCMSR";=0A=
-=0A=
+		if (!acb->fw_state) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+			goto message_out;=0A=
+		}=0A=
 		memcpy(pcmdmessagefld->messagedatabuffer, hello_string=0A=
 			, (int16_t)strlen(hello_string));=0A=
 		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
@@ -1564,10 +1724,20 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_SAY_GOODBYE:=0A=
+		if (!acb->fw_state) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+			goto message_out;=0A=
+		}=0A=
 		arcmsr_iop_parking(acb);=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:=0A=
+		if (!acb->fw_state) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+			goto message_out;=0A=
+		}=0A=
 		arcmsr_flush_adapter_cache(acb);=0A=
 		break;=0A=
 =0A=
@@ -1650,16 +1820,57 @@ static int arcmsr_queue_command(struct s=0A=
 	struct CommandControlBlock *ccb;=0A=
 	int target =3D cmd->device->id;=0A=
 	int lun =3D cmd->device->lun;=0A=
-=0A=
+	uint8_t scsicmd =3D cmd->cmnd[0];=0A=
 	cmd->scsi_done =3D done;=0A=
 	cmd->host_scribble =3D NULL;=0A=
 	cmd->result =3D 0;=0A=
+=0A=
+	if ((scsicmd =3D=3D SYNCHRONIZE_CACHE) || (scsicmd =3D=3D =
SEND_DIAGNOSTIC)) {=0A=
+		if (acb->devstate[target][lun] =3D=3D ARECA_RAID_GONE) {=0A=
+			cmd->result =3D (DID_NO_CONNECT << 16);=0A=
+		}=0A=
+		cmd->scsi_done(cmd);=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
 	if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: bus reset"=0A=
-			" and return busy \n"=0A=
-			, acb->host->host_no);=0A=
+		switch (acb->adapter_type) {=0A=
+			case ACB_ADAPTER_TYPE_A: {=0A=
+				struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
+				uint32_t intmask_org, outbound_doorbell;=0A=
+=0A=
+				if ((readl(&reg->outbound_msgaddr1) &=0A=
+					ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0) {=0A=
+					printk(KERN_NOTICE "arcmsr%d: bus reset and return busy\n",=0A=
+						acb->host->host_no);=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
 	}=0A=
+=0A=
+				acb->acb_flags &=3D ~ACB_F_FIRMWARE_TRAP;=0A=
+				printk(KERN_NOTICE "arcmsr%d: hardware bus reset and reset ok\n",=0A=
+					acb->host->host_no);=0A=
+				/* disable all outbound interrupt */=0A=
+				intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+				arcmsr_get_firmware_spec(acb, 1);=0A=
+				/*start background rebuild*/=0A=
+				arcmsr_start_adapter_bgrb(acb);=0A=
+				/* clear Qbuffer if door bell ringed */=0A=
+				outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+				/*clear interrupt */=0A=
+				writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
+				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,=0A=
+					&reg->inbound_doorbell);=0A=
+				/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
+				arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+				acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
+				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			}=0A=
+			break;=0A=
+			case ACB_ADAPTER_TYPE_B: {=0A=
+			}=0A=
+		}=0A=
+	}=0A=
+=0A=
 	if (target =3D=3D 16) {=0A=
 		/* virtual device for iop message transfer */=0A=
 		arcmsr_handle_virtual_command(acb, cmd);=0A=
@@ -1698,21 +1909,25 @@ static int arcmsr_queue_command(struct s=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void arcmsr_get_hba_config(struct AdapterControlBlock *acb)=0A=
+static void *arcmsr_get_hba_config(struct AdapterControlBlock *acb, int =
mode)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	char *acb_firm_model =3D acb->firm_model;=0A=
 	char *acb_firm_version =3D acb->firm_version;=0A=
+	char *acb_device_map =3D acb->device_map;=0A=
 	char __iomem *iop_firm_model =3D (char __iomem =
*)(&reg->message_rwbuffer[15]);=0A=
 	char __iomem *iop_firm_version =3D (char __iomem =
*)(&reg->message_rwbuffer[17]);=0A=
+	char __iomem *iop_device_map =3D (char __iomem *) =
(&reg->message_rwbuffer[21]);=0A=
 	int count;=0A=
 =0A=
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
 	if (arcmsr_hba_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
 			miscellaneous data' timeout \n", acb->host->host_no);=0A=
+		return NULL;=0A=
 	}=0A=
 =0A=
+	if (mode =3D=3D 1) {=0A=
 	count =3D 8;=0A=
 	while (count) {=0A=
 		*acb_firm_model =3D readb(iop_firm_model);=0A=
@@ -1729,34 +1944,48 @@ static void arcmsr_get_hba_config(struct=0A=
 		count--;=0A=
 	}=0A=
 =0A=
+		count =3D 16;=0A=
+		while (count) {=0A=
+			*acb_device_map =3D readb(iop_device_map);=0A=
+			acb_device_map++;=0A=
+			iop_device_map++;=0A=
+			count--;=0A=
+		}=0A=
+=0A=
 	printk(KERN_INFO 	"ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n"=0A=
 		, acb->host->host_no=0A=
 		, acb->firm_version);=0A=
-=0A=
+		acb->signature =3D readl(&reg->message_rwbuffer[0]);=0A=
 	acb->firm_request_len =3D readl(&reg->message_rwbuffer[1]);=0A=
 	acb->firm_numbers_queue =3D readl(&reg->message_rwbuffer[2]);=0A=
 	acb->firm_sdram_size =3D readl(&reg->message_rwbuffer[3]);=0A=
 	acb->firm_hd_channels =3D readl(&reg->message_rwbuffer[4]);=0A=
 }=0A=
-=0A=
-static void arcmsr_get_hbb_config(struct AdapterControlBlock *acb)=0A=
+	return reg->message_rwbuffer;=0A=
+}=0A=
+static void __iomem *arcmsr_get_hbb_config(struct AdapterControlBlock =
*acb, int mode)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	uint32_t __iomem *lrwbuffer =3D reg->msgcode_rwbuffer_reg;=0A=
 	char *acb_firm_model =3D acb->firm_model;=0A=
 	char *acb_firm_version =3D acb->firm_version;=0A=
+	char *acb_device_map =3D acb->device_map;=0A=
 	char __iomem *iop_firm_model =3D (char __iomem *)(&lrwbuffer[15]);=0A=
 	/*firm_model,15,60-67*/=0A=
 	char __iomem *iop_firm_version =3D (char __iomem *)(&lrwbuffer[17]);=0A=
 	/*firm_version,17,68-83*/=0A=
+	char __iomem *iop_device_map =3D (char __iomem *) (&lrwbuffer[21]);=0A=
+	/*firm_version,21,84-99*/=0A=
 	int count;=0A=
 =0A=
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);=0A=
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
 			miscellaneous data' timeout \n", acb->host->host_no);=0A=
+		return NULL;=0A=
 	}=0A=
 =0A=
+	if (mode =3D=3D 1) {=0A=
 	count =3D 8;=0A=
 	while (count)=0A=
 	{=0A=
@@ -1775,11 +2004,20 @@ static void arcmsr_get_hbb_config(struct=0A=
 		count--;=0A=
 	}=0A=
 =0A=
+		count =3D 16;=0A=
+		while (count) {=0A=
+			*acb_device_map =3D readb(iop_device_map);=0A=
+			acb_device_map++;=0A=
+			iop_device_map++;=0A=
+			count--;=0A=
+		}=0A=
+=0A=
 	printk(KERN_INFO "ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n",=0A=
 			acb->host->host_no,=0A=
 			acb->firm_version);=0A=
 =0A=
-	lrwbuffer++;=0A=
+		acb->signature =3D readl(lrwbuffer++);=0A=
+		/*firm_signature,1,00-03*/=0A=
 	acb->firm_request_len =3D readl(lrwbuffer++);=0A=
 	/*firm_request_len,1,04-07*/=0A=
 	acb->firm_numbers_queue =3D readl(lrwbuffer++);=0A=
@@ -1789,20 +2027,23 @@ static void arcmsr_get_hbb_config(struct=0A=
 	acb->firm_hd_channels =3D readl(lrwbuffer);=0A=
 	/*firm_ide_channels,4,16-19*/=0A=
 }=0A=
-=0A=
-static void arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)=0A=
+	return reg->msgcode_rwbuffer_reg;=0A=
+}=0A=
+static void *arcmsr_get_firmware_spec(struct AdapterControlBlock *acb, =
int mode)=0A=
 {=0A=
+	void *rtnval =3D 0;=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		arcmsr_get_hba_config(acb);=0A=
+		rtnval =3D arcmsr_get_hba_config(acb, mode);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		arcmsr_get_hbb_config(acb);=0A=
+		rtnval =3D arcmsr_get_hbb_config(acb, mode);=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
+	return rtnval;=0A=
 }=0A=
 =0A=
 static void arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,=0A=
@@ -2042,6 +2283,66 @@ static void arcmsr_wait_firmware_ready(s=0A=
 	}=0A=
 }=0A=
 =0A=
+static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb)=0A=
+{=0A=
+	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
+=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0)) {=0A=
+		acb->fw_state =3D false;=0A=
+	} else {=0A=
+	/*to prevent rq_map_token from changing by other interrupt, then=0A=
+	avoid the dead-lock*/=0A=
+		acb->fw_state =3D true;=0A=
+		atomic_dec(&acb->rq_map_token);=0A=
+		if (!(acb->fw_state) ||=0A=
+			(acb->ante_token_value =3D=3D atomic_read(&acb->rq_map_token))) {=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+		}=0A=
+		acb->ante_token_value =3D atomic_read(&acb->rq_map_token);=0A=
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
+	}=0A=
+	mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6000));=0A=
+	return;=0A=
+}=0A=
+=0A=
+static void arcmsr_request_hbb_device_map(struct AdapterControlBlock =
*acb)=0A=
+{=0A=
+	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
+=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0)) {=0A=
+		acb->fw_state =3D false;=0A=
+	} else {=0A=
+	/*to prevent rq_map_token from changing by other interrupt, then=0A=
+	avoid the dead-lock*/=0A=
+		acb->fw_state =3D true;=0A=
+		atomic_dec(&acb->rq_map_token);=0A=
+		if (!(acb->fw_state) ||=0A=
+			(acb->ante_token_value =3D=3D atomic_read(&acb->rq_map_token))) {=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+		}=0A=
+		acb->ante_token_value =3D atomic_read(&acb->rq_map_token);=0A=
+		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);=0A=
+	}=0A=
+	mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6000));=0A=
+	return;=0A=
+}=0A=
+=0A=
+static void arcmsr_request_device_map(unsigned long pacb)=0A=
+{=0A=
+	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *)pacb;=0A=
+=0A=
+	switch (acb->adapter_type) {=0A=
+		case ACB_ADAPTER_TYPE_A: {=0A=
+			arcmsr_request_hba_device_map(acb);=0A=
+		}=0A=
+		break;=0A=
+		case ACB_ADAPTER_TYPE_B: {=0A=
+			arcmsr_request_hbb_device_map(acb);=0A=
+		}=0A=
+		break;=0A=
+	}=0A=
+}=0A=
+=0A=
 static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
@@ -2120,6 +2421,60 @@ static void arcmsr_enable_eoi_mode(struc=0A=
 	return;=0A=
 }=0A=
 =0A=
+static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	uint8_t value[64];=0A=
+	int i;=0A=
+=0A=
+	/* backup pci config data */=0A=
+	for (i =3D 0; i < 64; i++) {=0A=
+		pci_read_config_byte(acb->pdev, i, &value[i]);=0A=
+	}=0A=
+	/* hardware reset signal */=0A=
+	pci_write_config_byte(acb->pdev, 0x84, 0x20);=0A=
+	msleep(1000);=0A=
+	/* write back pci config data */=0A=
+	for (i =3D 0; i < 64; i++) {=0A=
+		pci_write_config_byte(acb->pdev, i, value[i]);=0A=
+	}=0A=
+	msleep(1000);=0A=
+	return;=0A=
+}=0A=
+/*=0A=
+************************************************************************=
****=0A=
+************************************************************************=
****=0A=
+*/=0A=
+#ifdef CONFIG_SCSI_ARCMSR_RESET=0A=
+	int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)=0A=
+	{=0A=
+			struct Scsi_Host *shost =3D NULL;=0A=
+			spinlock_t *host_lock =3D NULL;=0A=
+			int i, isleep;=0A=
+=0A=
+			shost =3D cmd->device->host;=0A=
+			host_lock =3D shost->host_lock;=0A=
+=0A=
+			printk(KERN_NOTICE "Host %d bus reset over, sleep %d seconds (busy =
%d, can queue %d) ...........\n",=0A=
+					shost->host_no, sleeptime, shost->host_busy, shost->can_queue);=0A=
+			isleep =3D sleeptime / 10;=0A=
+			spin_unlock_irq(host_lock);=0A=
+			if (isleep > 0) {=0A=
+				for (i =3D 0; i < isleep; i++) {=0A=
+					msleep(10000);=0A=
+					printk(KERN_NOTICE "^%d^\n", i);=0A=
+				}=0A=
+			}=0A=
+=0A=
+			isleep =3D sleeptime % 10;=0A=
+			if (isleep > 0) {=0A=
+				msleep(isleep * 1000);=0A=
+				printk(KERN_NOTICE "^v^\n");=0A=
+			}=0A=
+			spin_lock_irq(host_lock);=0A=
+			printk(KERN_NOTICE "***** wake up *****\n");=0A=
+			return 0;=0A=
+	}=0A=
+#endif=0A=
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t intmask_org;=0A=
@@ -2128,7 +2483,7 @@ static void arcmsr_iop_init(struct Adapt=0A=
        intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 	arcmsr_wait_firmware_ready(acb);=0A=
 	arcmsr_iop_confirm(acb);=0A=
-	arcmsr_get_firmware_spec(acb);=0A=
+	arcmsr_get_firmware_spec(acb, 1);=0A=
 	/*start background rebuild*/=0A=
 	arcmsr_start_adapter_bgrb(acb);=0A=
 	/* empty doorbell Qbuffer if door bell ringed */=0A=
@@ -2139,51 +2494,110 @@ static void arcmsr_iop_init(struct Adapt=0A=
 	acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
 }=0A=
 =0A=
-static void arcmsr_iop_reset(struct AdapterControlBlock *acb)=0A=
+static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct CommandControlBlock *ccb;=0A=
 	uint32_t intmask_org;=0A=
+	uint8_t rtnval =3D 0x00;=0A=
 	int i =3D 0;=0A=
 =0A=
 	if (atomic_read(&acb->ccboutstandingcount) !=3D 0) {=0A=
+		/* disable all outbound interrupt */=0A=
+		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 		/* talk to iop 331 outstanding command aborted */=0A=
-		arcmsr_abort_allcmd(acb);=0A=
-=0A=
+		rtnval =3D arcmsr_abort_allcmd(acb);=0A=
 		/* wait for 3 sec for all command aborted*/=0A=
 		ssleep(3);=0A=
-=0A=
-		/* disable all outbound interrupt */=0A=
-		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 		/* clear all outbound posted Q */=0A=
 		arcmsr_done4abort_postqueue(acb);=0A=
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
 			ccb =3D acb->pccb_pool[i];=0A=
 			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {=0A=
-				ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
 				arcmsr_ccb_complete(ccb, 1);=0A=
 			}=0A=
 		}=0A=
+		atomic_set(&acb->ccboutstandingcount, 0);=0A=
 		/* enable all outbound interrupt */=0A=
 		arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+		return rtnval;=0A=
 	}=0A=
+	return rtnval;=0A=
 }=0A=
 =0A=
 static int arcmsr_bus_reset(struct scsi_cmnd *cmd)=0A=
 {=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;=0A=
-	int i;=0A=
+	int retry =3D 0;=0A=
 =0A=
-	acb->num_resets++;=0A=
+	if (acb->acb_flags & ACB_F_BUS_RESET)=0A=
+		return SUCCESS;=0A=
+=0A=
+	printk(KERN_NOTICE "arcmsr%d: bus reset ..... \n", acb->adapter_index);=0A=
 	acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
-	for (i =3D 0; i < 400; i++) {=0A=
-		if (!atomic_read(&acb->ccboutstandingcount))=0A=
+	acb->num_resets++;=0A=
+	while (atomic_read(&acb->ccboutstandingcount) !=3D 0 && retry < 4) {=0A=
+		arcmsr_interrupt(acb);=0A=
+		retry++;=0A=
+	}=0A=
+=0A=
+	if (arcmsr_iop_reset(acb)) {=0A=
+		switch (acb->adapter_type) {=0A=
+		case ACB_ADAPTER_TYPE_A: {=0A=
+			printk(KERN_NOTICE "arcmsr%d: do hardware bus reset, num_resets =3D =
%d num_aborts =3D %d \n",=0A=
+				acb->adapter_index, acb->num_resets, acb->num_aborts);=0A=
+			arcmsr_hardware_reset(acb);=0A=
+			acb->acb_flags |=3D ACB_F_FIRMWARE_TRAP;=0A=
+			acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
+			#ifdef CONFIG_SCSI_ARCMSR_RESET=0A=
+			struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
+			uint32_t intmask_org, outbound_doorbell;=0A=
+			int retry_count =3D 0;=0A=
+sleep_again:=0A=
+			arcmsr_sleep_for_bus_reset(cmd);=0A=
+			if ((readl(&reg->outbound_msgaddr1) &=0A=
+			ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0) {=0A=
+			printk(KERN_NOTICE "arcmsr%d: hardware bus reset and return busy, =
retry=3D%d \n",=0A=
+			acb->host->host_no, retry_count);=0A=
+			if (retry_count > retrycount) {=0A=
+				printk(KERN_NOTICE "arcmsr%d: hardware bus reset and return busy, =
retry aborted \n",=0A=
+				acb->host->host_no);=0A=
+			return SUCCESS;=0A=
+			}=0A=
+			retry_count++;=0A=
+			goto sleep_again;=0A=
+			}=0A=
+			acb->acb_flags &=3D ~ACB_F_FIRMWARE_TRAP;=0A=
+			acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			printk(KERN_NOTICE "arcmsr%d: hardware bus reset and reset ok \n",=0A=
+				acb->host->host_no);=0A=
+			/* disable all outbound interrupt */=0A=
+			intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+			arcmsr_get_firmware_spec(acb, 1);=0A=
+			/*start	background rebuild*/=0A=
+			arcmsr_start_adapter_bgrb(acb);=0A=
+			/* clear Qbuffer if door bell ringed */=0A=
+			outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+			writel(outbound_doorbell, &reg->outbound_doorbell); /*clear =
interrupt */=0A=
+			writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+			/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
+			arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			init_timer(&acb->eternal_timer);=0A=
+			acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(20*HZ);=0A=
+			acb->eternal_timer.data =3D (unsigned long) acb;=0A=
+			acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
+			add_timer(&acb->eternal_timer);=0A=
+			#endif=0A=
+		}=0A=
 			break;=0A=
-		arcmsr_interrupt(acb);/* FIXME: need spinlock */=0A=
-		msleep(25);=0A=
+		case ACB_ADAPTER_TYPE_B: {=0A=
 	}=0A=
-	arcmsr_iop_reset(acb);=0A=
+		}=0A=
+	} else {=0A=
 	acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+	}=0A=
 	return SUCCESS;=0A=
 }=0A=
 =0A=
@@ -2276,98 +2690,3 @@ static const char *arcmsr_info(struct Sc=0A=
 			ARCMSR_DRIVER_VERSION);=0A=
 	return buf;=0A=
 }=0A=
-#ifdef CONFIG_SCSI_ARCMSR_AER=0A=
-static pci_ers_result_t arcmsr_pci_slot_reset(struct pci_dev *pdev)=0A=
-{=0A=
-	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
-	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
-	uint32_t intmask_org;=0A=
-	int i, j;=0A=
-=0A=
-	if (pci_enable_device(pdev)) {=0A=
-		return PCI_ERS_RESULT_DISCONNECT;=0A=
-	}=0A=
-	pci_set_master(pdev);=0A=
-	intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-	acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
-			   ACB_F_MESSAGE_RQBUFFER_CLEARED |=0A=
-			   ACB_F_MESSAGE_WQBUFFER_READED);=0A=
-	acb->acb_flags &=3D ~ACB_F_SCSISTOPADAPTER;=0A=
-	for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
-		for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
-			acb->devstate[i][j] =3D ARECA_RAID_GONE;=0A=
-=0A=
-	arcmsr_wait_firmware_ready(acb);=0A=
-	arcmsr_iop_confirm(acb);=0A=
-       /* disable all outbound interrupt */=0A=
-	arcmsr_get_firmware_spec(acb);=0A=
-	/*start background rebuild*/=0A=
-	arcmsr_start_adapter_bgrb(acb);=0A=
-	/* empty doorbell Qbuffer if door bell ringed */=0A=
-	arcmsr_clear_doorbell_queue_buffer(acb);=0A=
-	arcmsr_enable_eoi_mode(acb);=0A=
-	/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
-	arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
-	acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
-=0A=
-	pci_enable_pcie_error_reporting(pdev);=0A=
-	return PCI_ERS_RESULT_RECOVERED;=0A=
-}=0A=
-=0A=
-static void arcmsr_pci_ers_need_reset_forepart(struct pci_dev *pdev)=0A=
-{=0A=
-	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock =
*)host->hostdata;=0A=
-	struct CommandControlBlock *ccb;=0A=
-	uint32_t intmask_org;=0A=
-	int i =3D 0;=0A=
-=0A=
-	if (atomic_read(&acb->ccboutstandingcount) !=3D 0) {=0A=
-		/* talk to iop 331 outstanding command aborted */=0A=
-		arcmsr_abort_allcmd(acb);=0A=
-		/* wait for 3 sec for all command aborted*/=0A=
-		ssleep(3);=0A=
-		/* disable all outbound interrupt */=0A=
-		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-		/* clear all outbound posted Q */=0A=
-		arcmsr_done4abort_postqueue(acb);=0A=
-		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
-			ccb =3D acb->pccb_pool[i];=0A=
-			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {=0A=
-				ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
-				arcmsr_ccb_complete(ccb, 1);=0A=
-			}=0A=
-		}=0A=
-		/* enable all outbound interrupt */=0A=
-		arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
-	}=0A=
-	pci_disable_device(pdev);=0A=
-}=0A=
-=0A=
-static void arcmsr_pci_ers_disconnect_forepart(struct pci_dev *pdev)=0A=
-{=0A=
-			struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
-			struct AdapterControlBlock *acb	=3D \=0A=
-				(struct AdapterControlBlock *)host->hostdata;=0A=
-=0A=
-			arcmsr_stop_adapter_bgrb(acb);=0A=
-			arcmsr_flush_adapter_cache(acb);=0A=
-}=0A=
-=0A=
-static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev,=0A=
-						pci_channel_state_t state)=0A=
-{=0A=
-	switch (state) {=0A=
-	case pci_channel_io_frozen:=0A=
-			arcmsr_pci_ers_need_reset_forepart(pdev);=0A=
-			return PCI_ERS_RESULT_NEED_RESET;=0A=
-	case pci_channel_io_perm_failure:=0A=
-			arcmsr_pci_ers_disconnect_forepart(pdev);=0A=
-			return PCI_ERS_RESULT_DISCONNECT;=0A=
-			break;=0A=
-	default:=0A=
-			return PCI_ERS_RESULT_NEED_RESET;=0A=
-	  }=0A=
-}=0A=
-#endif=0A=

------=_NextPart_000_0012_01CAF5B3.45DAD1C0--

