From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 3/3 ] SCSI: Support Type C RAID controller
Date: Fri, 9 Apr 2010 10:27:59 +0800
Message-ID: <97886D73EF8E4C6BAD90E8BD878EBE4B@areca4e4f859d4>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0014_01CAD7CF.56076DD0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.211.194]:45697 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab0DICfe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2010 22:35:34 -0400
References: 
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0014_01CAD7CF.56076DD0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

1. To support Type C RAID controller, ACB_ADAPTER_TYPE_C, i.e. PCI device
ID: 0x1880.
Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >
---

------=_NextPart_000_0014_01CAD7CF.56076DD0
Content-Type: application/octet-stream;
	name="patch3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch3"

diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change arcmsr.1.20.00.15-91209/arcmsr.h =
arcmsr.1.20.00.15-100202/arcmsr.h
--- arcmsr.1.20.00.15-91209/arcmsr.h	2010-02-01 12:41:34.000000000 +0800
+++ arcmsr.1.20.00.15-100202/arcmsr.h	2010-04-02 12:55:27.000000000 =
+0800
@@ -48,7 +47,7 @@ struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
 #define ARCMSR_MAX_OUTSTANDING_CMD						256
 #define ARCMSR_MAX_FREECCB_NUM							320
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2009/12/09"
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2010/02/02"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
 #define ARCMSR_MAX_XFER_SECTORS_B						4096
@@ -61,6 +60,7 @@ struct device_attribute;
 #define ARCMSR_MAX_HBB_POSTQUEUE						264
 #define ARCMSR_MAX_XFER_LEN							0x26000 /* 152K */
 #define ARCMSR_CDB_SG_PAGE_LENGTH						256=20
+#define SCSI_CMD_ARECA_SPECIFIC						0xE1
 #ifndef PCI_DEVICE_ID_ARECA_1880
 #define PCI_DEVICE_ID_ARECA_1880 0x1880
  #endif
@@ -223,11 +223,15 @@ struct FIRMWARE_INFO
 #define ARCMSR_CCBPOST_FLAG_SGL_BSIZE                 0x80000000
 #define ARCMSR_CCBPOST_FLAG_IAM_BIOS                  0x40000000
 #define ARCMSR_CCBREPLY_FLAG_IAM_BIOS                 0x40000000
-#define ARCMSR_CCBREPLY_FLAG_ERROR                    0x10000000
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0              0x10000000
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1              0x00000001
 /* outbound firmware ok */
 #define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000
 /* ARC-1680 Bus Reset*/
 #define ARCMSR_ARC1680_BUS_RESET				0x00000003
+/* ARC-1880 Bus Reset*/
+#define ARCMSR_ARC1880_RESET_ADAPTER				0x00000024
+#define ARCMSR_ARC1880_DiagWrite_ENABLE			0x00000080
=20
 /*
 =
************************************************************************
@@ -285,6 +289,61 @@ struct FIRMWARE_INFO
 /* iop message_rwbuffer for message command */
 #define ARCMSR_MESSAGE_RWBUFFER			      0x0000fa00
 /*
+************************************************************************=

+**                SPEC. for Areca HBC adapter
+************************************************************************=

+*/
+#define ARCMSR_HBC_ISR_THROTTLING_LEVEL		12
+#define ARCMSR_HBC_ISR_MAX_DONE_QUEUE		20
+/* Host Interrupt Mask */
+#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK		0x00000001 /* When clear, the =
Utility_A interrupt routes to the host.*/
+#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK	0x00000004 /* When =
clear, the General Outbound Doorbell interrupt routes to the host.*/
+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK	0x00000008 /* When =
clear, the Outbound Post List FIFO Not Empty interrupt routes to the =
host.*/
+#define ARCMSR_HBCMU_ALL_INTMASKENABLE		0x0000000D /* disable all ISR =
*/
+/* Host Interrupt Status */
+#define ARCMSR_HBCMU_UTILITY_A_ISR			0x00000001
+        /*
+        ** Set when the Utility_A Interrupt bit is set in the Outbound =
Doorbell Register.=20
+        ** It clears by writing a 1 to the Utility_A bit in the =
Outbound Doorbell Clear Register or through automatic clearing (if =
enabled).
+        */
+#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR		0x00000004
+        /*
+        ** Set if Outbound Doorbell register bits 30:1 have a non-zero
+        ** value. This bit clears only when Outbound Doorbell bits
+        ** 30:1 are ALL clear. Only a write to the Outbound Doorbell
+        ** Clear register clears bits in the Outbound Doorbell =
register.
+        */
+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR	0x00000008
+        /*
+        ** Set whenever the Outbound Post List Producer/Consumer
+        ** Register (FIFO) is not empty. It clears when the Outbound
+        ** Post List FIFO is empty.
+        */
+#define ARCMSR_HBCMU_SAS_ALL_INT			0x00000010
+        /*
+        ** This bit indicates a SAS interrupt from a source external to
+        ** the PCIe core. This bit is not maskable.
+        */
+/* DoorBell*/
+#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK			0x00000002
+#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK			0x00000004
+/*inbound message 0 ready*/
+#define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE		0x00000008
+/*more than 12 request completed in a time*/
+#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING		0x00000010
+#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK			0x00000002
+/*outbound DATA WRITE isr door bell clear*/
+#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_DOORBELL_CLEAR	0x00000002
+#define ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK			0x00000004
+/*outbound DATA READ isr door bell clear*/
+#define ARCMSR_HBCMU_IOP2DRV_DATA_READ_DOORBELL_CLEAR	0x00000004
+/*outbound message 0 ready*/
+#define ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE		0x00000008
+/*outbound message cmd isr door bell clear*/
+#define ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR	0x00000008
+/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/
+#define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK			0x80000000
+/*
 =
*************************************************************************=
******
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
 =
*************************************************************************=
******
@@ -321,7 +380,7 @@ struct ARCMSR_CDB
 		struct SG32ENTRY                sg32entry[1];
 		struct SG64ENTRY                sg64entry[1];
 	} u;
-}__attribute__ ((packed));
+};
 /*
 =
*************************************************************************=
******
 **     Messaging Unit (MU) of the Intel R 80331 I/O processor(Type A) =
and Type B processor
@@ -367,7 +426,82 @@ struct MessageUnit_B
 	uint32_t		__iomem *message_wbuffer;
 	uint32_t		__iomem *message_rbuffer;
 };
-
+/*
+*********************************************************************
+** LSI
+*********************************************************************
+*/
+struct MessageUnit_C
+{
+	uint32_t	message_unit_status;			/*0000 0003*/
+	uint32_t	slave_error_attribute;			/*0004 0007*/
+	uint32_t	slave_error_address;			/*0008 000B*/
+	uint32_t	posted_outbound_doorbell;		/*000C 000F*/
+	uint32_t	master_error_attribute;			/*0010 0013*/
+	uint32_t	master_error_address_low;		/*0014 0017*/
+	uint32_t	master_error_address_high;		/*0018 001B*/
+	uint32_t	hcb_size;				/*001C 001F*/
+	uint32_t	inbound_doorbell;			/*0020 0023*/
+	uint32_t	diagnostic_rw_data;			/*0024 0027*/
+	uint32_t	diagnostic_rw_address_low;		/*0028 002B*/
+	uint32_t	diagnostic_rw_address_high;		/*002C 002F*/
+	uint32_t	host_int_status;				/*0030 0033*/
+	uint32_t	host_int_mask;				/*0034 0037*/
+	uint32_t	dcr_data;				/*0038 003B*/
+	uint32_t	dcr_address;				/*003C 003F*/
+	uint32_t	inbound_queueport;			/*0040 0043*/
+	uint32_t	outbound_queueport;			/*0044 0047*/
+	uint32_t	hcb_pci_address_low;			/*0048 004B*/
+	uint32_t	hcb_pci_address_high;			/*004C 004F*/
+	uint32_t	iop_int_status;				/*0050 0053*/
+	uint32_t	iop_int_mask;				/*0054 0057*/
+	uint32_t	iop_inbound_queue_port;			/*0058 005B*/
+	uint32_t	iop_outbound_queue_port;		/*005C 005F*/
+	uint32_t	inbound_free_list_index;			/*0060 0063*/
+	uint32_t	inbound_post_list_index;			/*0064 0067*/
+	uint32_t	outbound_free_list_index;			/*0068 006B*/
+	uint32_t	outbound_post_list_index;			/*006C 006F*/
+	uint32_t	inbound_doorbell_clear;			/*0070 0073*/
+	uint32_t	i2o_message_unit_control;			/*0074 0077*/
+	uint32_t	last_used_message_source_address_low;	/*0078 007B*/
+	uint32_t	last_used_message_source_address_high;	/*007C 007F*/
+	uint32_t	pull_mode_data_byte_count[4];		/*0080 008F*/
+	uint32_t	message_dest_address_index;		/*0090 0093*/
+	uint32_t	done_queue_not_empty_int_counter_timer;	/*0094 0097*/
+	uint32_t	utility_A_int_counter_timer;		/*0098 009B*/
+	uint32_t	outbound_doorbell;			/*009C 009F*/
+	uint32_t	outbound_doorbell_clear;			/*00A0 00A3*/
+	uint32_t	message_source_address_index;		/*00A4 00A7*/
+	uint32_t	message_done_queue_index;		/*00A8 00AB*/
+	uint32_t	reserved0;				/*00AC 00AF*/
+	uint32_t	inbound_msgaddr0;			/*00B0 00B3*/
+	uint32_t	inbound_msgaddr1;			/*00B4 00B7*/
+	uint32_t	outbound_msgaddr0;			/*00B8 00BB*/
+	uint32_t	outbound_msgaddr1;			/*00BC 00BF*/
+	uint32_t	inbound_queueport_low;			/*00C0 00C3*/
+	uint32_t	inbound_queueport_high;			/*00C4 00C7*/
+	uint32_t	outbound_queueport_low;			/*00C8 00CB*/
+	uint32_t	outbound_queueport_high;		/*00CC 00CF*/
+	uint32_t	iop_inbound_queue_port_low;		/*00D0 00D3*/
+	uint32_t	iop_inbound_queue_port_high;		/*00D4 00D7*/
+	uint32_t	iop_outbound_queue_port_low;		/*00D8 00DB*/
+	uint32_t	iop_outbound_queue_port_high;		/*00DC 00DF*/
+	uint32_t	message_dest_queue_port_low;		/*00E0 00E3*/
+	uint32_t	message_dest_queue_port_high;		/*00E4 00E7*/
+	uint32_t	last_used_message_dest_address_low;	/*00E8 00EB*/
+	uint32_t	last_used_message_dest_address_high;	/*00EC 00EF*/
+	uint32_t	message_done_queue_base_address_low;	/*00F0 00F3*/
+	uint32_t	message_done_queue_base_address_high;	/*00F4 00F7*/
+	uint32_t	host_diagnostic;				/*00F8 00FB*/
+	uint32_t	write_sequence;				/*00FC 00FF*/
+	uint32_t	reserved1[34];				/*0100 0187*/
+	uint32_t	reserved2[1950];				/*0188 1FFF*/
+	uint32_t	message_wbuffer[32];			/*2000 207F*/
+	uint32_t	reserved3[32];				/*2080 20FF*/
+	uint32_t	message_rbuffer[32];			/*2100 217F*/
+	uint32_t	reserved4[32];				/*2180 21FF*/
+	uint32_t	msgcode_rwbuffer[256];			/*2200 23FF*/
+};
 /*
 =
*************************************************************************=
******
 **                 Adapter Control Block
@@ -385,11 +519,14 @@ struct AdapterControlBlock
 	unsigned long			vir2phy_offset;
 	/* Offset is used in making arc cdb physical to virtual calculations =
*/
 	uint32_t			outbound_int_enable;
+	uint32_t			cdb_phyaddr_hi32;
+	uint32_t			reg_mu_acc_handle0;
 	spinlock_t                      			eh_lock;
 	spinlock_t                      			ccblist_lock;
 	union {
 		struct MessageUnit_A __iomem *	pmuA;
 		struct MessageUnit_B *		pmuB;
+		struct MessageUnit_C __iomem *pmuC;
 	};
 	/* message unit ATU inbound base address0 */
 	void __iomem *mem_base0;
@@ -410,6 +547,8 @@ struct AdapterControlBlock
 	/* message clear rqbuffer */
 	#define ACB_F_MESSAGE_WQBUFFER_READED   0x0040
 	#define ACB_F_BUS_RESET               	0x0080
+	#define ACB_F_BUS_HANG_ON		0x0800/* need hardware reset bus */
+
 	#define ACB_F_IOP_INITED              	0x0100
 	/* iop init */
 	#define ACB_F_ABORT				0x0200
@@ -476,7 +615,8 @@ struct CommandControlBlock
 	struct list_head		list;				/*x32: 8byte, x64: 16byte*/
 	struct scsi_cmnd		*pcmd;				/*8 bytes pointer of linux scsi command */
 	struct AdapterControlBlock	*acb;				/*x32: 4byte, x64: 8byte*/
-	uint32_t			shifted_cdb_phyaddr;		/*x32: 4byte, x64: 4byte*/
+	uint32_t			cdb_phyaddr_pattern;		/*x32: 4byte, x64: 4byte*/
+	uint32_t			arc_cdb_size;			/*x32:4byte,x64:4byte*/
 	uint16_t			ccb_flags;			/*x32: 2byte, x64: 2byte*/
 	#define			CCB_FLAG_READ			0x0000
 	#define			CCB_FLAG_WRITE		0x0001
@@ -490,10 +630,10 @@ struct CommandControlBlock
 	#define			ARCMSR_CCB_ILLEGAL		0xFFFF
 	#if BITS_PER_LONG =3D=3D 64
 	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+64 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */
-		uint32_t                        	reserved[6];		/*24 byte*/
+		uint32_t                        	reserved[5];		/*24 byte*/
 	#else
 	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+32 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */
-		uint32_t                        	reserved[2];		/*8  byte*/
+		uint32_t                        	reserved;		/*8  byte*/
 	#endif
 	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D   */
 	struct ARCMSR_CDB		arcmsr_cdb;
diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change arcmsr.1.20.00.15-91209/arcmsr_hba.c =
arcmsr.1.20.00.15-100202/arcmsr_hba.c
--- arcmsr.1.20.00.15-91209/arcmsr_hba.c	2010-03-10 11:52:14.000000000 =
+0800
+++ arcmsr.1.20.00.15-100202/arcmsr_hba.c	2010-04-02 12:55:22.000000000 =
+0800
@@ -71,11 +71,12 @@
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
 MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx) SATA/SAS RAID Host Bus =
Adapter");
+MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host =
Bus Adapter");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
-static int sleeptime =3D 20;
-static int retrycount =3D 12;
+static int DEBUG =3D 1;
+static int sleeptime =3D 10;
+static int retrycount =3D 30;
 wait_queue_head_t wait_q;
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 					struct scsi_cmnd *cmd);
@@ -99,10 +100,12 @@ static void arcmsr_flush_hbb_cache(struc
 static void arcmsr_request_device_map(unsigned long pacb);
 static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb);
 static void arcmsr_request_hbb_device_map(struct AdapterControlBlock =
*acb);
+static void arcmsr_request_hbc_device_map(struct AdapterControlBlock =
*acb);
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
-
+static void arcmsr_hbc_message_isr(struct AdapterControlBlock *pACB);
+static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
@@ -110,13 +113,13 @@ static int arcmsr_adjust_disk_queue_dept
 {
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
 		queue_depth =3D ARCMSR_MAX_CMD_PERLUN;
-	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), queue_depth);
 	return queue_depth;
 }
=20
 static struct scsi_host_template arcmsr_scsi_host_template =3D {
 	.module			=3D THIS_MODULE,
-	.name			=3D "ARCMSR ARECA SATA/SAS RAID Host Bus Adapter"
+	.name			=3D "ARCMSR ARECA SATA/SAS RAID Controller"
 				ARCMSR_DRIVER_VERSION,
 	.info			=3D arcmsr_info,
 	.queuecommand		=3D arcmsr_queue_command,
@@ -175,17 +178,40 @@ static struct pci_driver arcmsr_pci_driv
 	.err_handler		=3D &arcmsr_pci_error_handlers,
 	#endif
 };
+/*
+************************************************************************=
****
+************************************************************************=
****
+*/
+int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)
+{
+		struct Scsi_Host *shost =3D NULL;
+		int i, isleep;
+		shost =3D cmd->device->host;
+		isleep =3D sleeptime / 10;
+		if (isleep > 0) {
+			for (i =3D 0; i < isleep; i ++) {
+				msleep(10000);
+			}
+		}
=20
-static void arcmsr_free_mu(struct AdapterControlBlock *acb)
+		isleep =3D sleeptime % 10;
+		if (isleep > 0) {
+			msleep(isleep*1000);
+		}
+		printk("wake-up\n");
+		return 0;
+}
+
+static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 		case ACB_ADAPTER_TYPE_A:
+		case ACB_ADAPTER_TYPE_C:
 			break;
 		case ACB_ADAPTER_TYPE_B:{
-			struct MessageUnit_B *reg =3D acb->pmuB;
 			dma_free_coherent(&acb->pdev->dev,
 				sizeof(struct MessageUnit_B),
-				reg, acb->dma_coherent_handle_hbb_mu);
+				acb->pmuB, acb->dma_coherent_handle_hbb_mu);
 		}
 	}
 }
@@ -218,6 +243,19 @@ static bool arcmsr_remap_pciregion(struc
 			}
 			acb->mem_base0 =3D mem_base0;
 			acb->mem_base1 =3D mem_base1;
+			break;
+		}
+		case ACB_ADAPTER_TYPE_C:{
+			acb->pmuC =3D ioremap_nocache(pci_resource_start(pdev, 1), =
pci_resource_len(pdev, 1));
+			if (!acb->pmuC){
+				printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);
+				return false;
+			}
+			if(readl(&acb->pmuC->outbound_doorbell) & =
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE){
+				=
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,&acb->pmuC->o=
utbound_doorbell_clear);/*clear interrupt*/
+				return TRUE;
+			}
+			break;
 		}
 	}
 	return true;
@@ -229,10 +267,16 @@ static void arcmsr_unmap_pciregion(struc
 		case ACB_ADAPTER_TYPE_A:{
 			iounmap(acb->pmuA);
 		}
+		break;
 		case ACB_ADAPTER_TYPE_B:{
 			iounmap(acb->mem_base0);
 			iounmap(acb->mem_base1);
 		}
+
+		break;
+		case ACB_ADAPTER_TYPE_C:{
+			iounmap(acb->pmuC);
+		}
 	}
 }
=20
@@ -280,6 +324,10 @@ static void arcmsr_define_adapter_type(s
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
 	acb->dev_id =3D dev_id;
 	switch (dev_id) {
+	case 0x1880 : {
+		acb->adapter_type =3D ACB_ADAPTER_TYPE_C;
+		}
+		break;
 	case 0x1201 : {
 		acb->adapter_type =3D ACB_ADAPTER_TYPE_B;
 		}
@@ -301,13 +348,13 @@ static uint8_t arcmsr_hba_wait_msgint_re
 					ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
 				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,
 					&reg->outbound_intstatus);
-				return 0x00;
+				return TRUE;
 			}
 			msleep(10);
 		}/*max 1 seconds*/
=20
 	} while (Retries++ < 20);/*max 20 sec*/
-	return 0xff;
+	return FALSE;
 }
=20
 static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock =
*acb)
@@ -323,15 +369,32 @@ static uint8_t arcmsr_hbb_wait_msgint_re
 				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN
 					, reg->iop2drv_doorbell);
 				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
-				return 0x00;
+				return TRUE;
 			}
 			msleep(10);
 		}/*max 1 seconds*/
=20
 	} while (Retries++ < 20);/*max 20 sec*/
-	return 0xff;
+	return FALSE;
 }
=20
+static uint8_t arcmsr_hbc_wait_msgint_ready(struct AdapterControlBlock =
*pACB)
+{
+	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;
+	unsigned char Retries =3D 0x00;
+	uint32_t Index;
+	do{
+		for(Index=3D 0; Index < 100; Index++){
+			if(readl(&phbcmu->outbound_doorbell) & =
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE){
+				=
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,&phbcmu->outb=
ound_doorbell_clear);/*clear interrupt*/
+				return TRUE;
+			}
+			/* one us delay	*/
+			msleep(10);
+		}/*max 1 seconds*/
+	}while(Retries++ < 20);/*max 20 sec*/
+	return FALSE;
+}
 static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
@@ -336,10 +399,9 @@ static void arcmsr_flush_hba_cache(struc
 {
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
 	int retry_count =3D 30;
-
 	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
 	do {
-		if (!arcmsr_hba_wait_msgint_ready(acb))
+		if (arcmsr_hba_wait_msgint_ready(acb))
 			break;
 		else {
 			retry_count--;
@@ -353,10 +415,9 @@ static void arcmsr_flush_hbb_cache(struc
 {
 	struct MessageUnit_B *reg =3D acb->pmuB;
 	int retry_count =3D 30;
-
 	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);
 	do {
-		if (!arcmsr_hbb_wait_msgint_ready(acb))
+		if (arcmsr_hbb_wait_msgint_ready(acb))
 			break;
 		else {
 			retry_count--;
@@ -366,6 +427,23 @@ static void arcmsr_flush_hbb_cache(struc
 	} while (retry_count !=3D 0);
 }
=20
+static void arcmsr_flush_hbc_cache(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;
+	int retry_count =3D 30;/* enlarge wait flush adapter cache time: 10 =
minute */
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+	do{
+		if(arcmsr_hbc_wait_msgint_ready(pACB)){
+			break;
+		}else{
+			retry_count--;
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
+			timeout,retry count down =3D %d \n", pACB->host->host_no, =
retry_count);
+		}
+	}while(retry_count!=3D0);
+	return;
+}
 static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -378,21 +456,22 @@ static void arcmsr_flush_adapter_cache(s
 	case ACB_ADAPTER_TYPE_B: {
 		arcmsr_flush_hbb_cache(acb);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_C: {
+		arcmsr_flush_hbc_cache(acb);
+		}
 	}
 }
=20
 static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 {
 	struct pci_dev *pdev =3D acb->pdev;
-	switch (acb->adapter_type) {
-		case ACB_ADAPTER_TYPE_A: {
-
 			void *dma_coherent;
 			dma_addr_t dma_coherent_handle;
 			struct CommandControlBlock *ccb_tmp;
 			int i =3D 0, j =3D 0;
 			dma_addr_t cdb_phyaddr;
-			unsigned long roundup_ccbsize =3D 0;
+	unsigned long roundup_ccbsize =3D 0, offset;
 			unsigned long max_xfer_len;
 			unsigned long max_sg_entrys;
 			uint32_t  firm_config_version;
@@ -405,26 +483,29 @@ static int arcmsr_alloc_ccb_pool(struct=20
 			max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;
 			firm_config_version =3D acb->firm_cfg_version;
 			if((firm_config_version & 0xFF) >=3D 3){
-				max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH << =
((firm_config_version >> 8) & 0xFF)) * 1024;/* max 16M byte */
+		max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH << ((firm_config_version =
>> 8) & 0xFF)) * 1024;/* max 4M byte */
 				max_sg_entrys =3D (max_xfer_len/4096);=09
 			}
 			acb->host->max_sectors =3D max_xfer_len/512;
 			acb->host->sg_tablesize =3D max_sg_entrys;
-			roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) + =
max_sg_entrys * sizeof(struct SG64ENTRY), 32);
-			acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
+	roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) + =
(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+	acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM + 32;
 			dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size, =
&dma_coherent_handle, GFP_KERNEL);
 			if (!dma_coherent) {
 				printk("arcmsr%d: dma_alloc_coherent got error \n", =
acb->host->host_no);
 				return -ENOMEM;
 			}
-			memset(dma_coherent, 0, acb->uncache_size);
 			acb->dma_coherent =3D dma_coherent;
 			acb->dma_coherent_handle =3D dma_coherent_handle;
-			ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;
+	memset(dma_coherent, 0, acb->uncache_size);
+	offset =3D roundup((unsigned long)dma_coherent, 32) - (unsigned =
long)dma_coherent;
+	dma_coherent_handle =3D dma_coherent_handle + offset;
+	dma_coherent =3D (struct CommandControlBlock *)dma_coherent + offset;
+	ccb_tmp =3D dma_coherent;
 			acb->vir2phy_offset =3D (unsigned long)dma_coherent - (unsigned =
long)dma_coherent_handle;
 			for(i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
 				cdb_phyaddr =3D dma_coherent_handle + offsetof(struct =
CommandControlBlock, arcmsr_cdb);
-				ccb_tmp->shifted_cdb_phyaddr =3D cdb_phyaddr >> 5;
+		ccb_tmp->cdb_phyaddr_pattern =3D ((acb->adapter_type =3D=3D =
ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));
 				acb->pccb_pool[i] =3D ccb_tmp;
 				ccb_tmp->acb =3D acb;
 				INIT_LIST_HEAD(&ccb_tmp->list);
@@ -432,68 +513,9 @@ static int arcmsr_alloc_ccb_pool(struct=20
 				ccb_tmp =3D (struct CommandControlBlock *)((unsigned long)ccb_tmp + =
roundup_ccbsize);
 				dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;
 			}
-			break;
-		}
-		case ACB_ADAPTER_TYPE_B: {
-
-			void *dma_coherent;
-			dma_addr_t dma_coherent_handle;
-			struct CommandControlBlock *ccb_tmp;
-			uint32_t cdb_phyaddr;
-			unsigned int roundup_ccbsize =3D 0;
-			unsigned long max_xfer_len;
-			unsigned long max_sg_entrys;
-			unsigned long firm_config_version;
-			unsigned long max_freeccb_num=3D0;
-			int i =3D 0, j =3D 0;
-
-			max_freeccb_num =3D ARCMSR_MAX_FREECCB_NUM;
-			max_xfer_len =3D ARCMSR_MAX_XFER_LEN;
-			max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;
-			firm_config_version =3D acb->firm_cfg_version;
-			if((firm_config_version & 0xFF) >=3D 3){
-				max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH <<=20
-						((firm_config_version >> 8) & 0xFF)) * 1024;/* max 16M byte */
-				max_sg_entrys =3D (max_xfer_len/4096);/* max 4097 sg entry*/
-			}
-			acb->host->max_sectors =3D max_xfer_len / 512;
-			acb->host->sg_tablesize =3D max_sg_entrys;
-			roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock)+
-				(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
-			acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
-			dma_coherent =3D dma_alloc_coherent(&pdev->dev,acb->uncache_size,
-				&dma_coherent_handle, GFP_KERNEL);
-
-			if (!dma_coherent) {
-				printk(KERN_NOTICE "DMA allocation =
failed...........................\n");
-				return -ENOMEM;
-			}
-			memset(dma_coherent, 0, acb->uncache_size);
-			acb->dma_coherent =3D dma_coherent;
-			acb->dma_coherent_handle =3D dma_coherent_handle;
-			ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;
-			acb->vir2phy_offset =3D (unsigned long)dma_coherent -
-					(unsigned long)dma_coherent_handle;
-			for(i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
-				cdb_phyaddr =3D dma_coherent_handle +
-					offsetof(struct CommandControlBlock, arcmsr_cdb);
-				ccb_tmp->shifted_cdb_phyaddr =3D cdb_phyaddr >> 5;
-				acb->pccb_pool[i] =3D ccb_tmp;
-				ccb_tmp->acb =3D acb;
-				INIT_LIST_HEAD(&ccb_tmp->list);
-				list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
-				ccb_tmp =3D (struct CommandControlBlock *)((unsigned long)ccb_tmp +
-									roundup_ccbsize);
-				dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;
-			}
-			for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)
-				for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)
-					acb->devstate[i][j] =3D ARECA_RAID_GONE;
-		}
-		break;
-	}
 	return 0;
 }
+
 static void arcmsr_message_isr_bh_fn(struct work_struct *work)=20
 {
 	struct AdapterControlBlock *acb =3D container_of(work,struct =
AdapterControlBlock, arcmsr_do_message_isr_bh);
@@ -573,6 +595,43 @@ static void arcmsr_message_isr_bh_fn(str
 				}
 			}
 		}
+		break;
+		case ACB_ADAPTER_TYPE_C: {
+			struct MessageUnit_C *reg  =3D acb->pmuC;
+			char *acb_dev_map =3D (char *)acb->device_map;
+			uint32_t __iomem *signature =3D (uint32_t =
__iomem*)(&reg->msgcode_rwbuffer[0]);
+			char __iomem *devicemap =3D (char =
__iomem*)(&reg->msgcode_rwbuffer[21]);
+			int target, lun;
+			struct scsi_device *psdev;
+			char diff;
+
+			atomic_inc(&acb->rq_map_token);
+			if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {
+				for(target =3D 0; target < ARCMSR_MAX_TARGETID -1; target++) {
+					diff =3D (*acb_dev_map)^readb(devicemap);
+					if (diff !=3D 0) {
+						char temp;
+						*acb_dev_map =3D readb(devicemap);
+						temp =3D*acb_dev_map;
+						for(lun =3D 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {
+							if((temp & 0x01)=3D=3D1 && (diff & 0x01) =3D=3D 1) {=09
+								scsi_add_device(acb->host, 0, target, lun);
+							}else if((temp & 0x01) =3D=3D 0 && (diff & 0x01) =3D=3D 1) {
+								psdev =3D scsi_device_lookup(acb->host, 0, target, lun);
+								if (psdev !=3D NULL ) {
+									scsi_remove_device(psdev);
+									scsi_device_put(psdev);
+								}
+							}
+							temp >>=3D 1;
+							diff >>=3D 1;
+						}
+					}
+					devicemap++;
+					acb_dev_map++;
+				}
+			}
+		}
 	}
 }
=20
@@ -591,9 +649,9 @@ static int arcmsr_probe(struct pci_dev *
 	if(!host){
     		goto pci_disable_dev;
 	}
-	error =3D pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if(error){
-		error =3D pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if(error){
 			printk(KERN_WARNING
 			       "scsi%d: No suitable DMA mask available\n",
@@ -675,7 +733,7 @@ static int arcmsr_probe(struct pci_dev *
 		arcmsr_flush_adapter_cache(acb);
 		arcmsr_free_ccb_pool(acb);
 	free_hbb_mu:
-		arcmsr_free_mu(acb);
+		arcmsr_free_hbb_mu(acb);
 	unmap_pci_region:
 		arcmsr_unmap_pciregion(acb);
 	pci_release_regs:
@@ -690,15 +748,14 @@ static int arcmsr_probe(struct pci_dev *
 static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
-
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
-	if (arcmsr_hba_wait_msgint_ready(acb)){
+	if (!arcmsr_hba_wait_msgint_ready(acb)){
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"
 			, acb->host->host_no);
-		return 0xff;
+		return FALSE;
 	}
-	return 0x00;
+	return TRUE;
 }
=20
 static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)
@@ -706,15 +763,27 @@ static uint8_t arcmsr_abort_hbb_allcmd(s
 	struct MessageUnit_B *reg =3D acb->pmuB;
=20
 	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);
-	if (arcmsr_hbb_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"
 			, acb->host->host_no);
-		return 0xff;
+		return FALSE;
 	}
-	return 0x00;
+	return TRUE;
+}
+static uint8_t arcmsr_abort_hbc_allcmd(struct AdapterControlBlock =
*pACB)
+{
+	struct MessageUnit_C *reg =3D(struct MessageUnit_C *)pACB->pmuC;
+	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+	if(!arcmsr_hbc_wait_msgint_ready(pACB)){
+		printk(KERN_NOTICE
+			"arcmsr%d: wait 'abort all outstanding command' timeout \n"
+			, pACB->host->host_no);
+		return FALSE;
+	}
+	return TRUE;
 }
-
 static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 {
 	uint8_t rtnval =3D 0;
@@ -727,6 +796,11 @@ static uint8_t arcmsr_abort_allcmd(struc
 	case ACB_ADAPTER_TYPE_B: {
 		rtnval =3D arcmsr_abort_hbb_allcmd(acb);
 		}
+		break;
+	=09
+	case ACB_ADAPTER_TYPE_C: {
+		rtnval =3D arcmsr_abort_hbc_allcmd(acb);
+		}=09
 	}
 	return rtnval;
 }
@@ -734,9 +808,8 @@ static uint8_t arcmsr_abort_allcmd(struc
 static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock =
*pacb)
 {
 	struct MessageUnit_B *reg =3D pacb->pmuB;
-
 	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
-	if(arcmsr_hbb_wait_msgint_ready(pacb)){
+	if(!arcmsr_hbb_wait_msgint_ready(pacb)){
 		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", =
pacb->host->host_no);
 		return false;
 	}
@@ -759,7 +831,6 @@ static void arcmsr_ccb_complete(struct C
 	atomic_dec(&acb->ccboutstandingcount);
 	arcmsr_pci_unmap_dma(ccb);
 	ccb->startdone =3D ARCMSR_CCB_DONE;
-	ccb->ccb_flags =3D 0;
 	spin_lock_irqsave(&acb->ccblist_lock, flags);
 	list_add_tail(&ccb->list, &acb->ccb_free_list);
 	spin_unlock_irqrestore(&acb->ccblist_lock, flags);
@@ -803,14 +871,20 @@ static u32 arcmsr_disable_outbound_ints(
 		writel(0, reg->iop2drv_doorbell_mask);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C:{
+		struct MessageUnit_C *reg=3D(struct MessageUnit_C *)acb->pmuC;
+		/* disable all outbound interrupt */
+		orig_mask =3D readl(&reg->host_int_mask); /* disable outbound =
message0 int */
+		writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE, =
&reg->host_int_mask);
+		}
+		break;
 	}
 	return orig_mask;
 }
=20
 static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,=20
-			struct CommandControlBlock *ccb, uint32_t flag_ccb)
+			struct CommandControlBlock *ccb, bool error)
 {
-
 	uint8_t id, lun;
 	id =3D ccb->pcmd->device->id;
 	lun =3D ccb->pcmd->device->lun;
@@ -814,7 +888,7 @@ static void arcmsr_report_ccb_state(stru
 	uint8_t id, lun;
 	id =3D ccb->pcmd->device->id;
 	lun =3D ccb->pcmd->device->lun;
-	if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {
+	if (!error) {
 		if (acb->devstate[id][lun] =3D=3D ARECA_RAID_GONE)
 			acb->devstate[id][lun] =3D ARECA_RAID_GOOD;
 			ccb->pcmd->result =3D DID_OK << 16;
@@ -846,9 +920,8 @@ static void arcmsr_report_ccb_state(stru
=20
 		default:
 				printk(KERN_NOTICE
-					"arcmsr%d: scsi id =3D %d lun =3D %d"
-					" isr get command error done, "
-					"but got unknown DeviceStatus =3D 0x%x \n"
+				"arcmsr%d: scsi id =3D %d lun =3D %d isr get command error done, \
+				but got unknown DeviceStatus =3D 0x%x \n"
 					, acb->host->host_no
 					, id
 					, lun
@@ -861,25 +934,20 @@ static void arcmsr_report_ccb_state(stru
 	}
 }
=20
-static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, =
uint32_t flag_ccb)
+static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, =
struct CommandControlBlock *pCCB, bool error)
=20
 {
-	struct CommandControlBlock *ccb;
-	struct ARCMSR_CDB *arcmsr_cdb;
 	int id, lun;
-
-	arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));
-	ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);
-	if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {
-		if (ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) {
-			struct scsi_cmnd *abortcmd =3D ccb->pcmd;
+	if ((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)) {
+		if (pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED) {
+			struct scsi_cmnd *abortcmd =3D pCCB->pcmd;
 			if (abortcmd) {
 				id =3D abortcmd->device->id;
 				lun =3D abortcmd->device->lun;			=09
 				abortcmd->result |=3D DID_ABORT << 16;
-				arcmsr_ccb_complete(ccb);
-				printk(KERN_NOTICE "arcmsr%d: ccb =3D'0x%p' \
-				isr got aborted command \n", acb->host->host_no, ccb);
+				arcmsr_ccb_complete(pCCB);
+				printk(KERN_NOTICE "arcmsr%d: pCCB =3D'0x%p' isr got aborted =
command \n",
+				acb->host->host_no, pCCB);
 			}
 		}
 		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \
@@ -888,20 +956,21 @@ static void arcmsr_drain_donequeue(struc
 				" ccboutstandingcount =3D %d \n"
 				, acb->host->host_no
 				, acb
-				, ccb
-				, ccb->acb
-				, ccb->startdone
+				, pCCB
+				, pCCB->acb
+				, pCCB->startdone
 				, atomic_read(&acb->ccboutstandingcount));
 		}
-	else
-	arcmsr_report_ccb_state(acb, ccb, flag_ccb);
+	arcmsr_report_ccb_state(acb, pCCB, error);
 }
=20
 static void arcmsr_done4abort_postqueue(struct AdapterControlBlock =
*acb)
 {
 	int i =3D 0;
 	uint32_t flag_ccb;
-
+	struct ARCMSR_CDB *pARCMSR_CDB;
+	bool error;
+	struct CommandControlBlock *pCCB;
 	switch (acb->adapter_type) {
=20
 	case ACB_ADAPTER_TYPE_A: {
@@ -913,7 +982,10 @@ static void arcmsr_done4abort_postqueue(
 		writel(outbound_intstatus, &reg->outbound_intstatus);/*clear =
interrupt*/
 		while (((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D =
0xFFFFFFFF)
 				&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
-			arcmsr_drain_donequeue(acb, flag_ccb);
+			pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/=09
+			pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);
+			error=3D(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)?TRUE:FALSE;
+			arcmsr_drain_donequeue(acb, pCCB, error);
 		}
 		}
 		break;
@@ -921,17 +993,37 @@ static void arcmsr_done4abort_postqueue(
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg =3D acb->pmuB;
 		/*clear all outbound posted Q*/
+		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, &reg->iop2drv_doorbell); /* =
clear doorbell interrupt */
 		for (i =3D 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
 			if ((flag_ccb =3D readl(&reg->done_qbuffer[i])) !=3D 0) {
 				writel(0, &reg->done_qbuffer[i]);
-				arcmsr_drain_donequeue(acb, flag_ccb);
+				pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/
+				pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);
+				error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)?TRUE:FALSE;
+				arcmsr_drain_donequeue(acb, pCCB, error);
 			}
-			writel(0, &reg->post_qbuffer[i]);
+			reg->post_qbuffer[i]=3D0;
 		}
 		reg->doneq_index =3D 0;
 		reg->postq_index =3D 0;
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C: {
+		struct MessageUnit_C *reg =3D acb->pmuC;
+		struct  ARCMSR_CDB *pARCMSR_CDB;
+		uint32_t flag_ccb, ccb_cdb_phy;
+		bool error;
+		struct CommandControlBlock *pCCB;
+		while((readl(&reg->host_int_status) & =
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < =
ARCMSR_MAX_OUTSTANDING_CMD)){
+			/*need to do*/
+			flag_ccb =3D readl(&reg->outbound_queueport_low);
+			ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);
+			pARCMSR_CDB =3D (struct  ARCMSR_CDB =
*)(acb->vir2phy_offset+ccb_cdb_phy);/*frame must be 32 bytes aligned*/
+			pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);
+			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)?TRUE:FALSE;
+			arcmsr_drain_donequeue(acb, pCCB, error);
+		}	=09
+	}
 	}
 }
 static void arcmsr_remove(struct pci_dev *pdev)
@@ -942,7 +1034,6 @@ static void arcmsr_remove(struct pci_dev
 	int poll_count =3D 0;
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
-	scsi_host_put(host);
 	flush_scheduled_work();
 	del_timer_sync(&acb->eternal_timer);
 	arcmsr_disable_outbound_ints(acb);
@@ -974,8 +1065,10 @@ static void arcmsr_remove(struct pci_dev
 	}
 	free_irq(pdev->irq, acb);
 	arcmsr_free_ccb_pool(acb);
-	arcmsr_free_mu(acb);
+	arcmsr_free_hbb_mu(acb);
+	arcmsr_unmap_pciregion(acb);
 	pci_release_regions(pdev);
+	scsi_host_put(host);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 }
@@ -1033,6 +1124,13 @@ static void arcmsr_enable_outbound_ints(
 		writel(mask, reg->iop2drv_doorbell_mask);
 		acb->outbound_int_enable =3D (intmask_org | mask) & 0x0000000f;
 		}
+		break;
+	case ACB_ADAPTER_TYPE_C : {
+		struct MessageUnit_C *reg =3D acb->pmuC;
+		mask=3D~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK =
|ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_=
ISR_MASK);
+		writel(intmask_org & mask, &reg->host_int_mask);
+		acb->outbound_int_enable =3D ~(intmask_org & mask) & 0x0000000f;
+		}=09
 	}
 }
=20
@@ -1044,24 +1142,20 @@ static int arcmsr_build_ccb(struct Adapt
 	__le32 address_lo, address_hi;
 	int arccdbsize =3D 0x30;
 	__le32 length =3D 0;
-	int i, cdb_sgcount =3D 0;
+	int i;
 	struct scatterlist *sg;
 	int nseg;
-
 	ccb->pcmd =3D pcmd;
 	memset(arcmsr_cdb, 0, sizeof(struct ARCMSR_CDB));
-	arcmsr_cdb->Bus =3D 0;
 	arcmsr_cdb->TargetID =3D pcmd->device->id;
 	arcmsr_cdb->LUN =3D pcmd->device->lun;
 	arcmsr_cdb->Function =3D 1;
-	arcmsr_cdb->CdbLength =3D (uint8_t)pcmd->cmd_len;
 	arcmsr_cdb->Context =3D 0;
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
=20
 	nseg =3D scsi_dma_map(pcmd);
-	if(nseg > acb->host->sg_tablesize || nseg < 0)
+	if(unlikely(nseg > acb->host->sg_tablesize || nseg < 0))
 		return FAILED;
-	/* map stor port SG list to our iop SG List. */
 	scsi_for_each_sg(pcmd, sg, nseg, i) {
 		/* Get the physical address of the current data pointer */
 		length =3D cpu_to_le32(sg_dma_len(sg));
@@ -1083,23 +1177,22 @@ static int arcmsr_build_ccb(struct Adapt
 			psge +=3D sizeof (struct SG64ENTRY);
 			arccdbsize +=3D sizeof (struct SG64ENTRY);
 		}
-		cdb_sgcount++;
 	}
-	arcmsr_cdb->sgcount =3D (uint8_t)cdb_sgcount;
+	arcmsr_cdb->sgcount =3D (uint8_t)nseg;
 	arcmsr_cdb->DataLength =3D scsi_bufflen(pcmd);
 	arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : =
0);
 	if ( arccdbsize > 256)
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_SGL_BSIZE;
 	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || =
pcmd->cmnd[0]|WRITE_12 ){
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_WRITE;
-		ccb->ccb_flags |=3D CCB_FLAG_WRITE;
 	}
+	ccb->arc_cdb_size =3D arccdbsize;
 	return SUCCESS;
 }
=20
 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct =
CommandControlBlock *ccb)
 {
-	uint32_t shifted_cdb_phyaddr =3D ccb->shifted_cdb_phyaddr;
+	uint32_t cdb_phyaddr_pattern =3D ccb->cdb_phyaddr_pattern;
 	struct ARCMSR_CDB *arcmsr_cdb =3D (struct ARCMSR_CDB =
*)&ccb->arcmsr_cdb;
 	atomic_inc(&acb->ccboutstandingcount);
 	ccb->startdone =3D ARCMSR_CCB_START;
@@ -1109,10 +1201,10 @@ static void arcmsr_post_ccb(struct Adapt
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;
=20
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
-			writel(shifted_cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
+			writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
 			&reg->inbound_queueport);
 		else {
-				writel(shifted_cdb_phyaddr, &reg->inbound_queueport);
+				writel(cdb_phyaddr_pattern, &reg->inbound_queueport);
 		}
 		}
 		break;
@@ -1124,11 +1216,10 @@ static void arcmsr_post_ccb(struct Adapt
 		ending_index =3D ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
 		writel(0, &reg->post_qbuffer[ending_index]);
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
-			writel(shifted_cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
+			writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
 						 &reg->post_qbuffer[index]);
-		}
-		else {
-			writel(shifted_cdb_phyaddr, &reg->post_qbuffer[index]);
+		}else{
+			writel(cdb_phyaddr_pattern, &reg->post_qbuffer[index]);
 		}
 		index++;
 		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to =
0 */
@@ -1136,6 +1227,19 @@ static void arcmsr_post_ccb(struct Adapt
 		writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C: {
+		struct MessageUnit_C *phbcmu=3D(struct MessageUnit_C *)acb->pmuC;
+		uint32_t ccb_post_stamp, arc_cdb_size;
+
+		arc_cdb_size =3D (ccb->arc_cdb_size > 0x300) ? =
0x300:ccb->arc_cdb_size;
+		ccb_post_stamp =3D (cdb_phyaddr_pattern | ((arc_cdb_size-1) >> 6) =
|1);
+		if(acb->cdb_phyaddr_hi32){
+			writel(acb->cdb_phyaddr_hi32, &phbcmu->inbound_queueport_high);
+			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
+		}else{
+			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
+		}
+		}
 	}
 }
=20
@@ -1144,8 +1248,7 @@ static void arcmsr_stop_hba_bgrb(struct=20
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
-
-	if (arcmsr_hba_wait_msgint_ready(acb)) {
+	if (!arcmsr_hba_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
 			, acb->host->host_no);
@@ -1158,13 +1261,26 @@ static void arcmsr_stop_hbb_bgrb(struct=20
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);
=20
-	if (arcmsr_hbb_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
 			, acb->host->host_no);
 	}
 }
=20
+static void arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;
+	pACB->acb_flags &=3D ~ACB_F_MSG_START_BGRB;
+	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+	if(!arcmsr_hbc_wait_msgint_ready(pACB)){
+		printk(KERN_NOTICE
+			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
+			, pACB->host->host_no);
+	}
+	return;
+}
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -1177,22 +1293,16 @@ static void arcmsr_stop_adapter_bgrb(str
 		arcmsr_stop_hbb_bgrb(acb);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C: {
+		arcmsr_stop_hbc_bgrb(acb);
+		}	=09
 	}
 }
=20
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)
 {
-	switch (acb->adapter_type) {
-	case ACB_ADAPTER_TYPE_A: {
-		dma_free_coherent(&acb->pdev->dev, acb->uncache_size, =
acb->dma_coherent, acb->dma_coherent_handle);
-		iounmap(acb->pmuA);
-	}
-		break;
-	case ACB_ADAPTER_TYPE_B: {
 		dma_free_coherent(&acb->pdev->dev, acb->uncache_size, =
acb->dma_coherent, acb->dma_coherent_handle);
 	}
-	}
-}
=20
 void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
 {
@@ -1208,6 +1318,10 @@ void arcmsr_iop_message_read(struct Adap
 		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C: {
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);
+		}
 	}
 }
=20
@@ -1233,6 +1347,15 @@ static void arcmsr_iop_message_wrote(str
 		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C: {
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;
+		/*
+		** push inbound doorbell tell iop, driver data write ok
+		** and wait reply on next hwinterrupt for next Qbuffer post
+		*/
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK, &reg->inbound_doorbell);
+		}
+		break;	=09
 	}
 }
=20
@@ -1253,6 +1375,10 @@ struct QBUFFER __iomem *arcmsr_get_iop_r
 		qbuffer =3D (struct QBUFFER __iomem *)reg->message_rbuffer;
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C: {
+		struct MessageUnit_C *phbcmu=3D(struct MessageUnit_C *)acb->pmuC;
+		qbuffer =3D (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;
+		}=09
 	}
 	return qbuffer;
 }
@@ -1274,6 +1399,11 @@ static struct QBUFFER __iomem *arcmsr_ge
 		pqbuffer =3D (struct QBUFFER __iomem *)reg->message_wbuffer;
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C: {
+		struct MessageUnit_C *reg=3D(struct MessageUnit_C *)acb->pmuC;
+		pqbuffer =3D (struct QBUFFER __iomem *)&reg->message_wbuffer;
+        }
+
 	}
 	return pqbuffer;
 }
@@ -1358,14 +1486,42 @@ static void arcmsr_hba_doorbell_isr(stru
 		arcmsr_iop2drv_data_read_handle(acb);
 	}
 }
-
+static void arcmsr_hbc_doorbell_isr(struct AdapterControlBlock *pACB)
+{
+	uint32_t outbound_doorbell;
+	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;
+	/*
+	*******************************************************************
+	**  Maybe here we need to check wrqbuffer_lock is lock or not
+	**  DOORBELL: din! don!=20
+	**  check if there are any mail need to pack from firmware
+	*******************************************************************
+	*/
+	outbound_doorbell =3D readl(&reg->outbound_doorbell);
+	writel(outbound_doorbell, &reg->outbound_doorbell_clear);/*clear =
interrupt*/
+	if(outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK){
+		arcmsr_iop2drv_data_wrote_handle(pACB);
+	}
+	if(outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK){
+		arcmsr_iop2drv_data_read_handle(pACB);
+	}
+	if(outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE){
+		arcmsr_hbc_message_isr(pACB);    /* messenger of "driver to iop =
commands" */
+	}
+	return;
+}
 static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t flag_ccb;
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
-
+	struct ARCMSR_CDB *pARCMSR_CDB;
+	struct CommandControlBlock *pCCB;
+	bool error;
 	while ((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D 0xFFFFFFFF) =
{
-		arcmsr_drain_donequeue(acb, flag_ccb);
+		pARCMSR_CDB=3D(struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb << =
5));/*frame must be 32 bytes aligned*/
+		pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);
+		error=3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)?TRUE:FALSE;
+		arcmsr_drain_donequeue(acb, pCCB, error);
 	}
 }
=20
@@ -1374,17 +1530,51 @@ static void arcmsr_hbb_postqueue_isr(str
 	uint32_t index;
 	uint32_t flag_ccb;
 	struct MessageUnit_B *reg =3D acb->pmuB;
-
+	struct ARCMSR_CDB *pARCMSR_CDB;
+	struct CommandControlBlock *pCCB;
+	bool error;
 	index =3D reg->doneq_index;
-
 	while ((flag_ccb =3D readl(&reg->done_qbuffer[index])) !=3D 0) {
 		writel(0, &reg->done_qbuffer[index]);
-		arcmsr_drain_donequeue(acb, flag_ccb);
+		pARCMSR_CDB=3D(struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb << =
5));/*frame must be 32 bytes aligned*/
+		pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);
+		error=3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)?TRUE:FALSE;	=09
+		arcmsr_drain_donequeue(acb, pCCB, error);
 		index++;
 		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;
 		reg->doneq_index =3D index;
 	}
 }
+
+static void arcmsr_hbc_postqueue_isr(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_C *phbcmu;
+	struct ARCMSR_CDB *arcmsr_cdb;
+	struct CommandControlBlock *ccb;
+	uint32_t flag_ccb, ccb_cdb_phy, throttling =3D 0;
+	int error;
+
+	phbcmu =3D (struct MessageUnit_C *)acb->pmuC;
+	/* areca cdb command done */
+	/* Use correct offset and size for syncing */
+
+	while (readl(&phbcmu->host_int_status) &=20
+	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR){
+	/* check if command done with no error*/
+	flag_ccb =3D readl(&phbcmu->outbound_queueport_low);
+	ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);/*frame must be 32 bytes =
aligned*/
+	arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
ccb_cdb_phy);
+	ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);
+	error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)?TRUE:FALSE;
+	/* check if command done with no error */
+	arcmsr_drain_donequeue(acb, ccb, error);
+	if(throttling =3D=3D ARCMSR_HBC_ISR_THROTTLING_LEVEL) {
+		writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING, =
&phbcmu->inbound_doorbell);
+		break;
+	}
+	throttling++;
+	}
+}
 /*
 =
*************************************************************************=
*********
 ** Handle a message interrupt
@@ -1408,6 +1598,23 @@ static void arcmsr_hbb_message_isr(struc
 	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
+/*
+************************************************************************=
**********
+** Handle a message interrupt
+**
+** The only message interrupt we expect is in response to a query for =
the
+** current adapter config. =20
+** We want this in order to compare the drivemap so that we can detect =
newly-attached drives.
+************************************************************************=
**********
+*/
+static void arcmsr_hbc_message_isr(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_C *reg  =3D acb->pmuC;
+	/*clear interrupt and message state*/
+	writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&reg->outbound_doorbell_clear);
+	schedule_work(&acb->arcmsr_do_message_isr_bh);
+}
+
 static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_intstatus;
@@ -1463,6 +1668,31 @@ static int arcmsr_handle_hbb_isr(struct=20
=20
 	return 0;
 }
+
+static int arcmsr_handle_hbc_isr(struct AdapterControlBlock *pACB)
+{
+	uint32_t host_interrupt_status;=09
+	struct MessageUnit_C *phbcmu=3D(struct MessageUnit_C *)pACB->pmuC;
+	/*
+	*********************************************
+	**   check outbound intstatus=20
+	*********************************************
+	*/
+	host_interrupt_status =3D readl(&phbcmu->host_int_status);
+	if(!host_interrupt_status){
+		/*it must be share irq*/
+		return FALSE;
+	}
+	/* MU ioctl transfer doorbell interrupts*/
+	if(host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR){
+		arcmsr_hbc_doorbell_isr(pACB);   /* messenger of "ioctl message read =
write" */
+	}
+	/* MU post queue interrupts*/
+	if(host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR){
+		arcmsr_hbc_postqueue_isr(pACB);  /* messenger of "scsi commands" */
+	}
+	return TRUE;
+}
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -1479,6 +1709,11 @@ static irqreturn_t arcmsr_interrupt(stru
 		}
 		}
 		break;
+	 case ACB_ADAPTER_TYPE_C: {
+		if(arcmsr_handle_hbc_isr(acb)) {
+			return IRQ_NONE;
+		}
+        		}
 	}
 	return IRQ_HANDLED;
 }
@@ -1890,7 +2120,10 @@ static int arcmsr_queue_command(struct s
 	if (atomic_read(&acb->ccboutstandingcount) >=3D
 			ARCMSR_MAX_OUTSTANDING_CMD)
 		return SCSI_MLQUEUE_HOST_BUSY;
-
+	if((scsicmd =3D=3D SCSI_CMD_ARECA_SPECIFIC)){
+		printk("Receiveing SCSI_CMD_ARECA_SPECIFIC command..\n");
+		return 0;
+	}
 	ccb =3D arcmsr_get_freeccb(acb);
 	if (!ccb)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1912,9 +2145,8 @@ static bool arcmsr_get_hba_config(struct
 	char __iomem *iop_firm_version =3D (char __iomem =
*)(&reg->message_rwbuffer[17]);
 	char __iomem *iop_device_map =3D (char __iomem *) =
(&reg->message_rwbuffer[21]);
 	int count;
-
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-	if (arcmsr_hba_wait_msgint_ready(acb)) {
+	if (!arcmsr_hba_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", acb->host->host_no);
 		return false;
@@ -1990,7 +2222,7 @@ static bool arcmsr_get_hbb_config(struct
 	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]);	=
/*firm_version,21,84-99*/
=20
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
-	if (arcmsr_hbb_wait_msgint_ready(acb)){
+	if (!arcmsr_hbb_wait_msgint_ready(acb)){
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", acb->host->host_no);
 		return false;
@@ -2037,12 +2269,73 @@ static bool arcmsr_get_hbb_config(struct
 	/*firm_ide_channels,4,16-19*/
 	return true;
 }
+
+static bool arcmsr_get_hbc_config(struct AdapterControlBlock *pACB)
+{
+	uint32_t intmask_org, Index, firmware_state =3D 0;
+	struct MessageUnit_C *reg =3D pACB->pmuC;
+	char *acb_firm_model =3D pACB->firm_model;
+	char *acb_firm_version=3D pACB->firm_version;
+	char *iop_firm_model =3D (char *)(&reg->msgcode_rwbuffer[15]);    =
/*firm_model,15,60-67*/
+	char *iop_firm_version =3D (char *)(&reg->msgcode_rwbuffer[17]);  =
/*firm_version,17,68-83*/
+	int count;
+	/* disable all outbound interrupt */
+	intmask_org =3D readl(&reg->host_int_mask); /* disable outbound =
message0 int */
+	writel(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE, =
&reg->host_int_mask);
+	/* wait firmware ready */
+	do{
+		firmware_state =3D readl(&reg->outbound_msgaddr1);
+	}while((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK)=3D=3D0);
+	/* post "get config" instruction */
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,&reg->inbound_msgaddr0);
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,&reg->inbound_doorbell);
+	/* wait message ready */
+	for(Index=3D 0; Index < 2000; Index++){
+		if(readl(&reg->outbound_doorbell) & =
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE){
+			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&reg->outbound_doorbell_clear);/*clear interrupt*/
+			break;
+		}
+		udelay(10);
+	}/*max 1 seconds*/
+	if(Index >=3D 2000){
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
+			miscellaneous data' timeout \n", pACB->host->host_no);
+		return false;
+	}
+	count=3D8;
+	while(count){
+		*acb_firm_model =3D readb(iop_firm_model);
+		acb_firm_model++;
+		iop_firm_model++;
+		count--;
+	}
+	count=3D16;
+	while(count){
+		*acb_firm_version =3D readb(iop_firm_version);
+		acb_firm_version++;
+		iop_firm_version++;
+		count--;
+	}
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+		pACB->host->host_no,
+		pACB->firm_version,
+		pACB->firm_model);
+	pACB->firm_request_len =3D readl(&reg->msgcode_rwbuffer[1]);   =
/*firm_request_len,1,04-07*/
+	pACB->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[2]); =
/*firm_numbers_queue,2,08-11*/
+	pACB->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[3]);    =
/*firm_sdram_size,3,12-15*/
+	pACB->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[4]);  =
/*firm_ide_channels,4,16-19*/
+	pACB->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/
+	/*all interrupt service will be enable at arcmsr_iop_init*/
+	return true;
+}
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
 	if(acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_A)
 		return arcmsr_get_hba_config(acb);
-	else
+	else if(acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_B)
 		return arcmsr_get_hbb_config(acb);
+	else
+		return arcmsr_get_hbc_config(acb);=09
 }
=20
 static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
@@ -2053,7 +2346,7 @@ static int arcmsr_polling_hba_ccbdone(st
 	struct ARCMSR_CDB *arcmsr_cdb;
 	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done =3D 0, poll_count =
=3D 0;
 	int rtn;
-
+	bool error;
 	polling_hba_ccb_retry:
 	poll_count++;
 	outbound_intstatus =3D readl(&reg->outbound_intstatus) & =
acb->outbound_int_enable;
@@ -2064,6 +2357,7 @@ static int arcmsr_polling_hba_ccbdone(st
 				rtn =3D SUCCESS;
 				break;
 			}else {
+				msleep(25);
 				if (poll_count > 100){
 					rtn =3D FAILED;
 					break;
@@ -2093,9 +2387,9 @@ static int arcmsr_polling_hba_ccbdone(st
 				, ccb
 				, atomic_read(&acb->ccboutstandingcount));
 			continue;
-		}else{
-			arcmsr_report_ccb_state(acb, ccb, flag_ccb);
 		}
+		error=3D(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)?TRUE:FALSE;
+		arcmsr_report_ccb_state(acb, ccb, error);
 	}
 	return rtn;
 }
@@ -2108,7 +2402,7 @@ static int arcmsr_polling_hbb_ccbdone(st
 	struct CommandControlBlock *ccb;
 	uint32_t flag_ccb, poll_ccb_done =3D 0, poll_count =3D 0;
 	int index, rtn;
-=09
+	bool error;
 	polling_hbb_ccb_retry:
 	poll_count++;
 	/* clear doorbell interrupt */
@@ -2156,13 +2450,69 @@ static int arcmsr_polling_hbb_ccbdone(st
 				, ccb
 				, atomic_read(&acb->ccboutstandingcount));
 			continue;
-		}else{
-			arcmsr_report_ccb_state(acb, ccb, flag_ccb);
 		}
-	}	/*drain reply FIFO*/
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)?TRUE:FALSE;
+		arcmsr_report_ccb_state(acb, ccb, error);
+	}
 	return rtn;
 }
=20
+static int arcmsr_polling_hbc_ccbdone(struct AdapterControlBlock *acb, =
struct CommandControlBlock *poll_ccb)
+{
+	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;
+	uint32_t flag_ccb, ccb_cdb_phy;
+	struct ARCMSR_CDB *arcmsr_cdb;
+	bool error;
+	struct CommandControlBlock *pCCB;
+	uint32_t poll_ccb_done =3D 0, poll_count =3D 0;
+	int rtn;
+	polling_hbc_ccb_retry:
+	poll_count++;
+	while(1){
+		if((readl(&reg->host_int_status) & =
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) =3D=3D 0){
+			if (poll_ccb_done){
+				rtn =3D SUCCESS;
+				break;
+			}else {
+				msleep(25);
+				if (poll_count > 100){
+					rtn =3D FAILED;
+					break;
+				}
+				goto polling_hbc_ccb_retry;
+			}
+		}=09
+		flag_ccb=3D  readl(&reg->outbound_queueport_low);
+		ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
ccb_cdb_phy);/*frame must be 32 bytes aligned*/
+		pCCB =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);
+		poll_ccb_done =3D (pCCB =3D=3D poll_ccb) ? 1:0;
+		/* check ifcommand done with no error*/
+		if((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)){
+			if(pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED){
+				printk(KERN_NOTICE "arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D =
'0x%p'"
+					" poll command abort successfully \n"
+					,acb->host->host_no
+					,pCCB->pcmd->device->id
+					,pCCB->pcmd->device->lun
+					,pCCB);
+					pCCB->pcmd->result =3D DID_ABORT << 16;
+					arcmsr_ccb_complete(pCCB);
+				continue;
+			}
+			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
+				" command done ccb =3D '0x%p'"
+				"ccboutstandingcount =3D %d \n"
+				, acb->host->host_no
+				, pCCB
+				, atomic_read(&acb->ccboutstandingcount));
+			continue;
+		}
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)?TRUE : FALSE;
+		arcmsr_report_ccb_state(acb, pCCB, error);
+	}
+	return rtn;
+}
 static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock *poll_ccb)
 {
@@ -2177,6 +2527,10 @@ static int arcmsr_polling_ccbdone(struct
 	case ACB_ADAPTER_TYPE_B: {
 		rtn =3D arcmsr_polling_hbb_ccbdone(acb,poll_ccb);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_C: {
+		rtn =3D arcmsr_polling_hbc_ccbdone(acb,poll_ccb);
+		}
 	}
 	return rtn;
 }
@@ -2194,6 +2548,7 @@ static int arcmsr_iop_confirm(struct Ada
 	dma_coherent_handle =3D acb->dma_coherent_handle;
 	cdb_phyaddr =3D (uint32_t)(dma_coherent_handle);
 	cdb_phyaddr_hi32 =3D (uint32_t)((cdb_phyaddr >> 16) >> 16);
+	acb->cdb_phyaddr_hi32 =3D cdb_phyaddr_hi32;
 	/*
 	=
***********************************************************************
 	**    if adapter type B, set window of "post command Q"
@@ -2211,7 +2566,7 @@ static int arcmsr_iop_confirm(struct Ada
 			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
 							&reg->inbound_msgaddr0);
-			if (arcmsr_hba_wait_msgint_ready(acb)) {
+			if (!arcmsr_hba_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "arcmsr%d: ""set ccb high \
 				part physical address timeout\n",
 				acb->host->host_no);
@@ -2232,7 +2587,7 @@ static int arcmsr_iop_confirm(struct Ada
 		reg->postq_index =3D 0;
 		reg->doneq_index =3D 0;
 		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
-		if (arcmsr_hbb_wait_msgint_ready(acb)) {
+		if (!arcmsr_hbb_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \
 				acb->host->host_no);
 			return 1;
@@ -2251,7 +2606,7 @@ static int arcmsr_iop_confirm(struct Ada
 		writel(1056, rwbuffer);
=20
 		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
-		if (arcmsr_hbb_wait_msgint_ready(acb)) {
+		if (!arcmsr_hbb_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
 			timeout \n",acb->host->host_no);
 			return 1;
@@ -2260,6 +2615,27 @@ static int arcmsr_iop_confirm(struct Ada
 		arcmsr_enable_outbound_ints(acb, intmask_org);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C: {
+		if(cdb_phyaddr_hi32!=3D0){
+			struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;
+
+		                if(cdb_phyaddr_hi32!=3D0){
+				unsigned char Retries=3D0x00;
+				do{
+					printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=3D0x%x \n", =
acb->adapter_index, cdb_phyaddr_hi32);
+				} while(Retries++ < 100);
+			}
+			writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->msgcode_rwbuffer[0]);
+			writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);
+			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
+			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, =
&reg->inbound_doorbell);
+			if(!arcmsr_hbc_wait_msgint_ready(acb)){
+				printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
+				timeout \n",acb->host->host_no);
+				return 1;
+			}
+		}
+		}	=09
 	}
 	return 0;
 }
@@ -2286,6 +2661,12 @@ static void arcmsr_wait_firmware_ready(s
 		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C: {
+		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;
+		do{
+			firmware_state =3D readl(&reg->outbound_msgaddr1);
+		}while((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK)=3D=3D0);
+		}
 	}
 }
=20
@@ -2328,6 +2708,26 @@ static void arcmsr_request_hbb_device_ma
 	return;
 }
=20
+static void arcmsr_request_hbc_device_map(struct AdapterControlBlock =
*acb)
+{
+	struct MessageUnit_C __iomem *reg =3D acb->pmuC;
+	if(unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0 ) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0 )){
+		return;
+	}else{
+		acb->fw_flag =3D FW_NORMAL;
+		if(atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)){
+			atomic_set(&acb->rq_map_token,16);
+		}
+		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
+		if(atomic_dec_and_test(&acb->rq_map_token))
+			return;
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, =
&reg->inbound_doorbell);
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
+	}
+	return;
+}
+
 static void arcmsr_request_device_map(unsigned long pacb)
 {
 	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock =
*)pacb;
@@ -2341,6 +2740,9 @@ static void arcmsr_request_device_map(un
 			arcmsr_request_hbb_device_map(acb);
 		}
 		break;
+		case ACB_ADAPTER_TYPE_C: {
+			arcmsr_request_hbc_device_map(acb);
+		}
 	}
 }
=20
@@ -2349,7 +2751,7 @@ static void arcmsr_start_hba_bgrb(struct
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
 	acb->acb_flags |=3D ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
-	if (arcmsr_hba_wait_msgint_ready(acb)) {
+	if (!arcmsr_hba_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
 				rebulid' timeout \n", acb->host->host_no);
 	}
@@ -2360,12 +2762,24 @@ static void arcmsr_start_hbb_bgrb(struct
 	struct MessageUnit_B *reg =3D acb->pmuB;
 	acb->acb_flags |=3D ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
-	if (arcmsr_hbb_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
 				rebulid' timeout \n",acb->host->host_no);
 	}
 }
=20
+static void arcmsr_start_hbc_bgrb(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_C *phbcmu=3D(struct MessageUnit_C *)pACB->pmuC;
+	pACB->acb_flags |=3D ACB_F_MSG_START_BGRB;
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, =
&phbcmu->inbound_doorbell);
+	if(!arcmsr_hbc_wait_msgint_ready(pACB)){
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
+				rebulid' timeout \n",pACB->host->host_no);
+	}
+	return;
+}
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -2375,6 +2789,8 @@ static void arcmsr_start_adapter_bgrb(st
 	case ACB_ADAPTER_TYPE_B:
 		arcmsr_start_hbb_bgrb(acb);
 		break;
+	case ACB_ADAPTER_TYPE_C:
+		arcmsr_start_hbc_bgrb(acb);
 	}
 }
=20
@@ -2400,6 +2816,14 @@ static void arcmsr_clear_doorbell_queue_
 		/* let IOP know data has been read */
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C: {
+		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;
+		uint32_t outbound_doorbell;
+		/* empty doorbell Qbuffer if door bell ringed */
+		outbound_doorbell =3D readl(&reg->outbound_doorbell);
+		writel(outbound_doorbell, &reg->outbound_doorbell_clear);
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);
+		}
 	}
 }
=20
@@ -2412,12 +2836,14 @@ static void arcmsr_enable_eoi_mode(struc
 		{
 			struct MessageUnit_B *reg =3D acb->pmuB;
 			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);
-			if(arcmsr_hbb_wait_msgint_ready(acb)) {
+			if(!arcmsr_hbb_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");
 				return;
 			}
 		}
 		break;
+	case ACB_ADAPTER_TYPE_C:
+		return;
 	}
 	return;
 }
@@ -2425,21 +2851,33 @@ static void arcmsr_enable_eoi_mode(struc
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 {
 	uint8_t value[64];
-	int i;=09
-	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
-
+	int i, count =3D 0;=09
+	struct MessageUnit_A __iomem *pmuA =3D acb->pmuA;
+	struct MessageUnit_C __iomem *pmuC =3D acb->pmuC;
+	u32 temp =3D 0;
 	/* backup pci config data */
-	printk(KERN_ERR "arcmsr%d: executing hw bus reset .....\n", =
acb->host->host_no);
+	printk("arcmsr%d: executing hw bus reset .....\n", =
acb->host->host_no);
 	for (i=3D0; i<64; i++) {
 		pci_read_config_byte(acb->pdev, i, &value[i]);
 	}
 	/* hardware reset signal */
 	if((acb->dev_id =3D=3D 0x1680)){
-		writel(ARCMSR_ARC1680_BUS_RESET, &reg->reserved1[0]);
+		writel(ARCMSR_ARC1680_BUS_RESET, &pmuA->reserved1[0]);
+	}else if((acb->dev_id =3D=3D 0x1880)){
+		do{
+			count++;
+			writel(0xF, &pmuC->write_sequence);
+			writel(0x4, &pmuC->write_sequence);
+			writel(0xB, &pmuC->write_sequence);
+			writel(0x2, &pmuC->write_sequence);
+			writel(0x7, &pmuC->write_sequence);
+			writel(0xD, &pmuC->write_sequence);
+		}while((((temp =3D readl(&pmuC->host_diagnostic)) | =
ARCMSR_ARC1880_DiagWrite_ENABLE) =3D=3D 0) && (count < 5));
+		writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
 	}else{
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);
 	}
-	msleep(1000);
+	msleep(2000);
 	/* write back pci config data */
 	for (i=3D0;i<64;i++) {
 		pci_write_config_byte(acb->pdev, i, value[i]);
@@ -2447,29 +2885,6 @@ static void arcmsr_hardware_reset(struct
 	msleep(1000);
 	return;
 }
-/*
-************************************************************************=
****
-************************************************************************=
****
-*/
-int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)
-{
-		struct Scsi_Host *shost =3D NULL;
-		int i, isleep;
-
-		shost =3D cmd->device->host;
-		isleep =3D sleeptime / 10;
-		if (isleep > 0) {
-			for (i =3D 0; i < isleep; i ++) {
-				msleep(10000);
-			}
-		}
-
-		isleep =3D sleeptime % 10;
-		if (isleep > 0) {
-			msleep(isleep*1000);
-		}
-		return 0;
-}
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)
 {
 	uint32_t intmask_org;
@@ -2494,6 +2908,7 @@ static uint8_t arcmsr_iop_reset(struct A
 	uint32_t intmask_org;
 	uint8_t rtnval =3D 0x00;
 	int i =3D 0;
+	//spin_unlock_irq(acb->host->host_lock);
 	if (atomic_read(&acb->ccboutstandingcount) !=3D 0) {
 		/* disable all outbound interrupt */
 		intmask_org =3D arcmsr_disable_outbound_ints(acb);
@@ -2510,8 +2925,10 @@ static uint8_t arcmsr_iop_reset(struct A
 		atomic_set(&acb->ccboutstandingcount, 0);
 		/* enable all outbound interrupt */
 		arcmsr_enable_outbound_ints(acb, intmask_org);
+		//spin_lock_irq(acb->host->host_lock);
 		return rtnval;
 	}
+	//spin_lock_irq(acb->host->host_lock);=09
 	return rtnval;
 }
=20
@@ -2522,37 +2939,35 @@ static int arcmsr_bus_reset(struct scsi_
 	uint32_t intmask_org, outbound_doorbell;
 	int retry_count =3D 0;
 	int rtn =3D FAILED;
-
 	acb =3D (struct AdapterControlBlock *) cmd->device->host->hostdata;
-	printk(KERN_ERR "arcmsr: executing eh bus reset .....num_resets =3D =
%d,=20
-		num_aborts =3D %d \n", acb->num_resets, acb->num_aborts);
+	printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets =3D %d, =
num_aborts =3D %d \n", acb->num_resets, acb->num_aborts);
 	acb->num_resets++;
=20
 	switch(acb->adapter_type){
 		case ACB_ADAPTER_TYPE_A:{
 			if(acb->acb_flags & ACB_F_BUS_RESET){
 				long timeout;
-				timeout =3D wait_event_timeout(wait_q,=20
-					(acb->acb_flags & ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);
+				printk(KERN_ERR "arcmsr: there is an  bus reset eh =
proceeding.......\n");
+				timeout =3D wait_event_timeout(wait_q, (acb->acb_flags & =
ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);
 				if(timeout){
 					return SUCCESS;
 				}
 			}
 			acb->acb_flags |=3D ACB_F_BUS_RESET;
-			if(arcmsr_iop_reset(acb)){
+			if(!arcmsr_iop_reset(acb)){
 				struct MessageUnit_A __iomem *reg;
 				reg =3D acb->pmuA;
+				spin_unlock_irq(acb->host->host_lock);
 				arcmsr_hardware_reset(acb);
 				acb->acb_flags &=3D ~ACB_F_IOP_INITED;
 				sleep_again:
 				arcmsr_sleep_for_bus_reset(cmd);
 				if((readl(&reg->outbound_msgaddr1) & =
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0){
-					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,=20
-						retry=3D%d \n", acb->host->host_no, retry_count);
+					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, =
retry=3D%d \n", acb->host->host_no, retry_count);
 					if(retry_count > retrycount){
 						acb->fw_flag =3D FW_DEADLOCK;
-						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,=20
-							RETRY TERMINATED!! \n", acb->host->host_no);
+						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRY =
TERMINATED!! \n", acb->host->host_no);
+						spin_lock_irq(acb->host->host_lock);
 						return FAILED;
 					}
 					retry_count++;
@@ -2562,6 +2977,7 @@ static int arcmsr_bus_reset(struct scsi_
 				/* disable all outbound interrupt */
 				intmask_org =3D arcmsr_disable_outbound_ints(acb);
 				arcmsr_get_firmware_spec(acb);
+				//arcmsr_iop_confirm(acb);
 				arcmsr_start_adapter_bgrb(acb);
 				/* clear Qbuffer if door bell ringed */
 				outbound_doorbell =3D readl(&reg->outbound_doorbell);
@@ -2579,7 +2995,8 @@ static int arcmsr_bus_reset(struct scsi_
 				add_timer(&acb->eternal_timer);
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;
 				rtn =3D SUCCESS;
-				printk(KERN_ERR "arcmsr: scsi eh bus reset succeeds\n");
+				printk(KERN_ERR "arcmsr: scsi  bus reset eh returns with =
success\n");
+				spin_lock_irq(acb->host->host_lock);
 			}else{
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;
 				if(atomic_read(&acb->rq_map_token) =3D=3D 0){
@@ -2603,7 +3020,7 @@ static int arcmsr_bus_reset(struct scsi_
 		}
 		case ACB_ADAPTER_TYPE_B:{
 			acb->acb_flags |=3D ACB_F_BUS_RESET;
-			if(arcmsr_iop_reset(acb)){
+			if(!arcmsr_iop_reset(acb)){
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;
 				rtn =3D FAILED;
 			}else{
@@ -2626,6 +3043,79 @@ static int arcmsr_bus_reset(struct scsi_
 				rtn =3D SUCCESS;
 			}
 		}
+		case ACB_ADAPTER_TYPE_C:{
+			if(acb->acb_flags & ACB_F_BUS_RESET){
+				long timeout;
+				printk(KERN_ERR "arcmsr: there is an bus reset eh =
proceeding.......\n");
+				timeout =3D wait_event_timeout(wait_q, (acb->acb_flags & =
ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);
+				if(timeout){
+					return SUCCESS;
+				}
+			}
+			acb->acb_flags |=3D ACB_F_BUS_RESET;
+			if(!arcmsr_iop_reset(acb)){
+				struct MessageUnit_C __iomem *reg;
+				reg =3D acb->pmuC;
+				//spin_unlock_irq(acb->host->host_lock);
+				arcmsr_hardware_reset(acb);
+				acb->acb_flags &=3D ~ACB_F_IOP_INITED;
+				sleep:
+				arcmsr_sleep_for_bus_reset(cmd);
+				if((readl(&reg->host_diagnostic) & 0x04) !=3D 0 ){
+					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, =
retry=3D%d \n", acb->host->host_no, retry_count);
+					if(retry_count > retrycount){
+						acb->fw_flag =3D FW_DEADLOCK;
+						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRY =
TERMINATED!! \n", acb->host->host_no);
+						//spin_lock_irq(acb->host->host_lock);
+						return FAILED;
+					}
+					retry_count++;
+					goto sleep;
+				}
+				acb->acb_flags |=3D ACB_F_IOP_INITED;
+				/* disable all outbound interrupt */
+				intmask_org =3D arcmsr_disable_outbound_ints(acb);
+				arcmsr_get_firmware_spec(acb);
+				arcmsr_start_adapter_bgrb(acb);
+				/* clear Qbuffer if door bell ringed */
+				outbound_doorbell =3D readl(&reg->outbound_doorbell);
+				writel(outbound_doorbell, &reg->outbound_doorbell_clear); /*clear =
interrupt */
+   				writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, =
&reg->inbound_doorbell);
+				/* enable outbound Post Queue,outbound doorbell Interrupt */
+				arcmsr_enable_outbound_ints(acb, intmask_org);
+				atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);
+				acb->fw_flag =3D FW_NORMAL;
+				init_timer(&acb->eternal_timer);
+				acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6*HZ);
+				acb->eternal_timer.data =3D (unsigned long) acb;
+				acb->eternal_timer.function =3D &arcmsr_request_device_map;
+				add_timer(&acb->eternal_timer);
+				acb->acb_flags &=3D ~ACB_F_BUS_RESET;
+				rtn =3D SUCCESS;
+				printk(KERN_ERR "arcmsr: scsi bus reset eh returns with =
success\n");
+				//spin_lock_irq(acb->host->host_lock);
+			}else{
+				acb->acb_flags &=3D ~ACB_F_BUS_RESET;
+				if(atomic_read(&acb->rq_map_token) =3D=3D 0){
+					atomic_set(&acb->rq_map_token, 16);
+					atomic_set(&acb->ante_token_value, 16);
+					acb->fw_flag =3D FW_NORMAL;
+					init_timer(&acb->eternal_timer);
+						acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6*HZ);
+					acb->eternal_timer.data =3D (unsigned long) acb;
+					acb->eternal_timer.function =3D &arcmsr_request_device_map;
+					add_timer(&acb->eternal_timer);
+				}else{
+					atomic_set(&acb->rq_map_token, 16);
+					atomic_set(&acb->ante_token_value, 16);
+					acb->fw_flag =3D FW_NORMAL;
+					mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
+				}
+				rtn =3D SUCCESS;
+			}
+			break;
+		}
 	}
 	return rtn;
 }
@@ -2634,9 +3124,7 @@ static int arcmsr_abort_one_cmd(struct A
 		struct CommandControlBlock *ccb)
 {
 	int rtn;
-	spin_lock_irq(&acb->eh_lock);
 	rtn =3D arcmsr_polling_ccbdone(acb, ccb);
-	spin_unlock_irq(&acb->eh_lock);
 	return rtn;
 }
=20
@@ -2662,7 +3149,6 @@ static int arcmsr_abort(struct scsi_cmnd
 		return rtn;
=20
 	for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-		printk("%s: loop %d\n", __FUNCTION__, i);
 		struct CommandControlBlock *ccb =3D acb->pccb_pool[i];
 		if (ccb->startdone =3D=3D ARCMSR_CCB_START && ccb->pcmd =3D=3D cmd) {
 			ccb->startdone =3D ARCMSR_CCB_ABORTED;
@@ -2671,7 +3157,6 @@ static int arcmsr_abort(struct scsi_cmnd
 		}
 	}
 	acb->acb_flags &=3D ~ACB_F_ABORT;
-	printk("%s: leaving\n", __FUNCTION__);
 	return rtn;
 }
=20
@@ -2706,6 +3190,7 @@ static const char *arcmsr_info(struct Sc
 	case PCI_DEVICE_ID_ARECA_1381:
 	case PCI_DEVICE_ID_ARECA_1680:
 	case PCI_DEVICE_ID_ARECA_1681:
+	case PCI_DEVICE_ID_ARECA_1880:=09
 		type =3D "SAS";
 		break;
 	default:

------=_NextPart_000_0014_01CAD7CF.56076DD0--

