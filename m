From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 2/3 ] SCSI: Support several features in arcmsr driver
Date: Fri, 9 Apr 2010 10:26:31 +0800
Message-ID: <646F6D3C739945058A1D42F85E96C360@areca4e4f859d4>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0011_01CAD7CF.21B76670"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45413 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0DIC0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2010 22:26:43 -0400
References: 
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0011_01CAD7CF.21B76670
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

1. To support 4M/1024 scatter-gather list entry, reorganize struct
ARCMSR_CDB and struct CommandControlBlock
2. To modify arcmsr_probe
3. In order to help fix F/W issue, add the driver mode for type B card
4. To improve AP's behavior while F/W resets
5. To unify struct MessageUnit_B's members' naming in all OS drivers'
6. To improve error handlers, arcmsr_bus_reset(), arcmsr_abort()
7. To fix the arcmsr_queue_command() in bus reset stage, just let the
commands pass down to FW, don't block
Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >
---

------=_NextPart_000_0011_01CAD7CF.21B76670
Content-Type: application/octet-stream;
	name="patch2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch2"

diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change arcmsr.1.20.00.15-81103/arcmsr.h =
arcmsr.1.20.00.15-91209/arcmsr.h
--- arcmsr.1.20.00.15-81103/arcmsr.h	2008-11-05 17:12:40.000000000 +0800
+++ arcmsr.1.20.00.15-91209/arcmsr.h	2010-02-01 12:41:34.000000000 +0800
@@ -48,16 +48,22 @@ struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
 #define ARCMSR_MAX_OUTSTANDING_CMD						256
 #define ARCMSR_MAX_FREECCB_NUM							320
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2008/11/03"
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2009/12/09"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
 #define ARCMSR_MAX_XFER_SECTORS_B						4096
+#define ARCMSR_MAX_XFER_SECTORS_C						304
 #define ARCMSR_MAX_TARGETID							17
 #define ARCMSR_MAX_TARGETLUN							8
 #define ARCMSR_MAX_CMD_PERLUN		                 =
ARCMSR_MAX_OUTSTANDING_CMD
 #define ARCMSR_MAX_QBUFFER							4096
-#define ARCMSR_MAX_SG_ENTRIES							38
+#define ARCMSR_DEFAULT_SG_ENTRIES						38
 #define ARCMSR_MAX_HBB_POSTQUEUE						264
+#define ARCMSR_MAX_XFER_LEN							0x26000 /* 152K */
+#define ARCMSR_CDB_SG_PAGE_LENGTH						256=20
+#ifndef PCI_DEVICE_ID_ARECA_1880
+#define PCI_DEVICE_ID_ARECA_1880 0x1880
+ #endif
 /*
 =
*************************************************************************=
*********
 **
@@ -152,26 +158,19 @@ struct CMD_MESSAGE_FIELD
 **   structure for holding DMA address data
 *************************************************************
 */
+#define IS_DMA64			(sizeof(dma_addr_t) =3D=3D 8)
 #define IS_SG64_ADDR                0x01000000 /* bit24 */
 struct  SG32ENTRY
 {
 	__le32					length;
 	__le32					address;
-};
+}__attribute__ ((packed));
 struct  SG64ENTRY
 {
 	__le32					length;
 	__le32					address;
 	__le32					addresshigh;
-};
-struct SGENTRY_UNION
-{
-	union
-	{
-		struct SG32ENTRY            sg32entry;
-		struct SG64ENTRY            sg64entry;
-	}u;
-};
+}__attribute__ ((packed));
 /*
 ********************************************************************
 **      Q Buffer of IOP Message Transfer
@@ -198,6 +197,9 @@ struct FIRMWARE_INFO
 	char          model[8];			/*15, 60-67*/
 	char          firmware_ver[16];     	/*17, 68-83*/
 	char          device_map[16];		/*21, 84-99*/
+	uint32_t		cfgVersion;               	/*25,100-103 Added for checking =
of new firmware capability*/
+	uint8_t		cfgSerial[16];           	/*26,104-119*/
+	uint32_t		cfgPicStatus;            	/*30,120-123*/=09
 };
 /* signature of set and get firmware config */
 #define ARCMSR_SIGNATURE_GET_CONFIG		      0x87974060
@@ -224,6 +226,8 @@ struct FIRMWARE_INFO
 #define ARCMSR_CCBREPLY_FLAG_ERROR                    0x10000000
 /* outbound firmware ok */
 #define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000
+/* ARC-1680 Bus Reset*/
+#define ARCMSR_ARC1680_BUS_RESET				0x00000003
=20
 /*
 =
************************************************************************
@@ -275,11 +279,11 @@ struct FIRMWARE_INFO
=20
 /* data tunnel buffer between user space program and its firmware */
 /* user space data to iop 128bytes */
-#define ARCMSR_IOCTL_WBUFFER			      0x0000fe00
+#define ARCMSR_MESSAGE_WBUFFER			      0x0000fe00
 /* iop data to user space 128bytes */
-#define ARCMSR_IOCTL_RBUFFER			      0x0000ff00
+#define ARCMSR_MESSAGE_RBUFFER			      0x0000ff00
 /* iop message_rwbuffer for message command */
-#define ARCMSR_MSGCODE_RWBUFFER			      0x0000fa00
+#define ARCMSR_MESSAGE_RWBUFFER			      0x0000fa00
 /*
 =
*************************************************************************=
******
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
@@ -301,7 +305,7 @@ struct ARCMSR_CDB
 #define ARCMSR_CDB_FLAG_HEADQ              0x08
 #define ARCMSR_CDB_FLAG_ORDEREDQ           0x10
=20
-	uint8_t							Reserved1;
+	uint8_t							msgPages;
 	uint32_t						Context;
 	uint32_t						DataLength;
 	uint8_t							Cdb[16];
@@ -314,10 +318,10 @@ struct ARCMSR_CDB
 	uint8_t							SenseData[15];
 	union
 	{
-		struct SG32ENTRY                sg32entry[ARCMSR_MAX_SG_ENTRIES];
-		struct SG64ENTRY                sg64entry[ARCMSR_MAX_SG_ENTRIES];
+		struct SG32ENTRY                sg32entry[1];
+		struct SG64ENTRY                sg64entry[1];
 	} u;
-};
+}__attribute__ ((packed));
 /*
 =
*************************************************************************=
******
 **     Messaging Unit (MU) of the Intel R 80331 I/O processor(Type A) =
and Type B processor
@@ -355,13 +359,13 @@ struct MessageUnit_B
 	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
 	uint32_t	postq_index;
 	uint32_t	doneq_index;
-	uint32_t		__iomem *drv2iop_doorbell_reg;
-	uint32_t		__iomem *drv2iop_doorbell_mask_reg;
-	uint32_t		__iomem *iop2drv_doorbell_reg;
-	uint32_t		__iomem *iop2drv_doorbell_mask_reg;
-	uint32_t		__iomem *msgcode_rwbuffer_reg;
-	uint32_t		__iomem *ioctl_wbuffer_reg;
-	uint32_t		__iomem *ioctl_rbuffer_reg;
+	uint32_t		__iomem *drv2iop_doorbell;
+	uint32_t		__iomem *drv2iop_doorbell_mask;
+	uint32_t		__iomem *iop2drv_doorbell;
+	uint32_t		__iomem *iop2drv_doorbell_mask;
+	uint32_t		__iomem *message_rwbuffer;
+	uint32_t		__iomem *message_wbuffer;
+	uint32_t		__iomem *message_rbuffer;
 };
=20
 /*
@@ -381,14 +385,17 @@ struct AdapterControlBlock
 	unsigned long			vir2phy_offset;
 	/* Offset is used in making arc cdb physical to virtual calculations =
*/
 	uint32_t			outbound_int_enable;
-
+	spinlock_t                      			eh_lock;
+	spinlock_t                      			ccblist_lock;
 	union {
 		struct MessageUnit_A __iomem *	pmuA;
 		struct MessageUnit_B *		pmuB;
 	};
 	/* message unit ATU inbound base address0 */
-
+	void __iomem *mem_base0;
+	void __iomem *mem_base1;
 	uint32_t			acb_flags;
+	u16			dev_id;
 	uint8_t                   		adapter_index;
 	#define ACB_F_SCSISTOPADAPTER         	0x0001
 	#define ACB_F_MSG_STOP_BGRB     	0x0002
@@ -405,6 +412,7 @@ struct AdapterControlBlock
 	#define ACB_F_BUS_RESET               	0x0080
 	#define ACB_F_IOP_INITED              	0x0100
 	/* iop init */
+	#define ACB_F_ABORT				0x0200
 	#define ACB_F_FIRMWARE_TRAP           		0x0400
 	struct CommandControlBlock *			pccb_pool[ARCMSR_MAX_FREECCB_NUM];
 	/* used for memory free */
@@ -419,7 +427,8 @@ struct AdapterControlBlock
 	/* dma_coherent used for memory free */
 	dma_addr_t			dma_coherent_handle;
 	/* dma_coherent_handle used for memory free */
-
+	dma_addr_t				dma_coherent_handle_hbb_mu;
+	unsigned int				uncache_size;
 	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];
 	/* data collection buffer for read from 80331 */
 	int32_t				rqbuf_firstindex;
@@ -443,14 +452,18 @@ struct AdapterControlBlock
 	uint32_t			firm_numbers_queue;
 	uint32_t			firm_sdram_size;
 	uint32_t			firm_hd_channels;
+	uint32_t                           	firm_cfg_version;=09
 	char			firm_model[12];
 	char			firm_version[20];
 	char			device_map[20];			/*21,84-99*/
 	struct work_struct 		arcmsr_do_message_isr_bh;
 	struct timer_list		eternal_timer;
-	unsigned short		fw_state;
+	unsigned short		fw_flag;
+				#define	FW_NORMAL	0x0000
+				#define	FW_BOG		0x0001
+				#define	FW_DEADLOCK	0x0010
 	atomic_t 			rq_map_token;
-	int			ante_token_value;
+	atomic_t			ante_token_value;
 };/* HW_DEVICE_EXTENSION */
 /*
 =
*************************************************************************=
******
@@ -459,66 +472,31 @@ struct AdapterControlBlock
 =
*************************************************************************=
******
 */
 struct CommandControlBlock
-{
-	struct ARCMSR_CDB		arcmsr_cdb;
-	/*
-	** 0-503 (size of CDB =3D 504):
-	** arcmsr messenger scsi command descriptor size 504 bytes
-	*/
-	uint32_t			cdb_shifted_phyaddr;
-	/* 504-507 */
-	uint32_t			reserved1;
-	/* 508-511 */
-#if BITS_PER_LONG =3D=3D 64
-	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+64 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */
-	struct list_head		list;
-	/* 512-527 16 bytes next/prev ptrs for ccb lists */
-	struct scsi_cmnd *		pcmd;
-	/* 528-535 8 bytes pointer of linux scsi command */
-	struct AdapterControlBlock *	acb;
-	/* 536-543 8 bytes pointer of acb */
-
-	uint16_t			ccb_flags;
-	/* 544-545 */
+{	/*x32:sizeof struct_CCB=3D(32+60)byte, x64:sizeof =
struct_CCB=3D(64+60)byte*/
+	struct list_head		list;				/*x32: 8byte, x64: 16byte*/
+	struct scsi_cmnd		*pcmd;				/*8 bytes pointer of linux scsi command */
+	struct AdapterControlBlock	*acb;				/*x32: 4byte, x64: 8byte*/
+	uint32_t			shifted_cdb_phyaddr;		/*x32: 4byte, x64: 4byte*/
+	uint16_t			ccb_flags;			/*x32: 2byte, x64: 2byte*/
 	#define		CCB_FLAG_READ			0x0000
 	#define		CCB_FLAG_WRITE			0x0001
 	#define		CCB_FLAG_ERROR			0x0002
 	#define		CCB_FLAG_FLUSHCACHE		0x0004
 	#define		CCB_FLAG_MASTER_ABORTED		0x0008
-	uint16_t			startdone;
-	/* 546-547 */
+	uint16_t                        	startdone;			/*x32:2byte,x32:2byte*/
 	#define		ARCMSR_CCB_DONE			0x0000
 	#define		ARCMSR_CCB_START		0x55AA
 	#define		ARCMSR_CCB_ABORTED		0xAA55
 	#define		ARCMSR_CCB_ILLEGAL		0xFFFF
-	uint32_t			reserved2[7];
-	/* 548-551 552-555 556-559 560-563 564-567 568-571 572-575 */
+	#if BITS_PER_LONG =3D=3D 64
+	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+64 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */
+		uint32_t                        	reserved[6];		/*24 byte*/
 #else
 	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+32 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */
-	struct list_head		list;
-	/* 512-519 8 bytes next/prev ptrs for ccb lists */
-	struct scsi_cmnd *		pcmd;
-	/* 520-523 4 bytes pointer of linux scsi command */
-	struct AdapterControlBlock *	acb;
-	/* 524-527 4 bytes pointer of acb */
-
-	uint16_t			ccb_flags;
-	/* 528-529 */
-	#define		CCB_FLAG_READ			0x0000
-	#define		CCB_FLAG_WRITE			0x0001
-	#define		CCB_FLAG_ERROR			0x0002
-	#define		CCB_FLAG_FLUSHCACHE		0x0004
-	#define		CCB_FLAG_MASTER_ABORTED		0x0008
-	uint16_t			startdone;
-	/* 530-531 */
-	#define		ARCMSR_CCB_DONE			0x0000
-	#define		ARCMSR_CCB_START		0x55AA
-	#define		ARCMSR_CCB_ABORTED		0xAA55
-	#define		ARCMSR_CCB_ILLEGAL		0xFFFF
-	uint32_t			reserved2[3];
-	/* 532-535 536-539 540-543 */
+		uint32_t                        	reserved[2];		/*8  byte*/
 #endif
-	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D  */
+	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D   */
+	struct ARCMSR_CDB		arcmsr_cdb;
 };
 /*
 =
*************************************************************************=
******
diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change arcmsr.1.20.00.15-81103/arcmsr_hba.c =
arcmsr.1.20.00.15-91209/arcmsr_hba.c
--- arcmsr.1.20.00.15-81103/arcmsr_hba.c	2008-11-11 12:03:04.000000000 =
+0800
+++ arcmsr.1.20.00.15-91209/arcmsr_hba.c	2010-03-10 11:52:14.000000000 =
+0800
@@ -70,20 +70,13 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
-
-#ifdef CONFIG_SCSI_ARCMSR_RESET
-	static int sleeptime =3D 20;
-	static int retrycount =3D 12;
-	module_param(sleeptime, int, S_IRUGO|S_IWUSR);
-	MODULE_PARM_DESC(sleeptime,"The waiting period for FW ready while bus =
reset");
-	module_param(retrycount, int, S_IRUGO|S_IWUSR);
-	MODULE_PARM_DESC(retrycount,"The retry count for FW ready while bus =
reset");
-#endif
-MODULE_AUTHOR("Erich Chen <support@areca.com.tw>");
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host =
Bus Adapter");
+MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");
+MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx) SATA/SAS RAID Host Bus =
Adapter");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
-
+static int sleeptime =3D 20;
+static int retrycount =3D 12;
+wait_queue_head_t wait_q;
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 					struct scsi_cmnd *cmd);
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);
@@ -107,7 +100,7 @@ static void arcmsr_request_device_map(un
 static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb);
 static void arcmsr_request_hbb_device_map(struct AdapterControlBlock =
*acb);
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);
-static void *arcmsr_get_firmware_spec(struct AdapterControlBlock *acb, =
int mode);
+static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
=20
 static const char *arcmsr_info(struct Scsi_Host *);
@@ -131,10 +124,10 @@ static struct scsi_host_template arcmsr_
 	.eh_bus_reset_handler	=3D arcmsr_bus_reset,
 	.bios_param		=3D arcmsr_bios_param,
 	.change_queue_depth	=3D arcmsr_adjust_disk_queue_depth,
-	.can_queue		=3D ARCMSR_MAX_OUTSTANDING_CMD,
+	.can_queue		=3D ARCMSR_MAX_FREECCB_NUM,
 	.this_id			=3D ARCMSR_SCSI_INITIATOR_ID,
-	.sg_tablesize		=3D ARCMSR_MAX_SG_ENTRIES,
-	.max_sectors    		=3D ARCMSR_MAX_XFER_SECTORS,
+	.sg_tablesize	        	=3D ARCMSR_DEFAULT_SG_ENTRIES,=20
+	.max_sectors    	    	=3D ARCMSR_MAX_XFER_SECTORS_C,=20
 	.cmd_per_lun		=3D ARCMSR_MAX_CMD_PERLUN,
 	.use_clustering		=3D ENABLE_CLUSTERING,
 	.shost_attrs		=3D arcmsr_host_attrs,
@@ -168,6 +161,7 @@ static struct pci_device_id arcmsr_devic
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},
 	{0, 0}, /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
@@ -182,15 +176,72 @@ static struct pci_driver arcmsr_pci_driv
 	#endif
 };
=20
+static void arcmsr_free_mu(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A:
+			break;
+		case ACB_ADAPTER_TYPE_B:{
+			struct MessageUnit_B *reg =3D acb->pmuB;
+			dma_free_coherent(&acb->pdev->dev,
+				sizeof(struct MessageUnit_B),
+				reg, acb->dma_coherent_handle_hbb_mu);
+		}
+	}
+}
+
+static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)
+{
+	struct pci_dev *pdev =3D acb->pdev;
+
+	switch (acb->adapter_type){
+		case ACB_ADAPTER_TYPE_A:{
+			acb->pmuA =3D ioremap(pci_resource_start(pdev,0), =
pci_resource_len(pdev,0));
+			if (!acb->pmuA) {
+				printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);
+				return false;
+			}
+			break;
+		}
+		case ACB_ADAPTER_TYPE_B:{
+			void __iomem *mem_base0, *mem_base1;
+			mem_base0 =3D ioremap(pci_resource_start(pdev, 0), =
pci_resource_len(pdev, 0));
+			if (!mem_base0) {
+				printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);
+				return false;
+			}
+			mem_base1 =3D ioremap(pci_resource_start(pdev, 2), =
pci_resource_len(pdev, 2));
+			if (!mem_base1) {
+				iounmap(mem_base0);
+				printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);
+				return false;
+			}
+			acb->mem_base0 =3D mem_base0;
+			acb->mem_base1 =3D mem_base1;
+		}
+	}
+	return true;
+}
+
+static void arcmsr_unmap_pciregion(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A:{
+			iounmap(acb->pmuA);
+		}
+		case ACB_ADAPTER_TYPE_B:{
+			iounmap(acb->mem_base0);
+			iounmap(acb->mem_base1);
+		}
+	}
+}
+
 static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id)
 {
 	irqreturn_t handle_state;
 	struct AdapterControlBlock *acb =3D dev_id;
=20
-	spin_lock(acb->host->host_lock);
 	handle_state =3D arcmsr_interrupt(acb);
-	spin_unlock(acb->host->host_lock);
-
 	return handle_state;
 }
=20
@@ -227,6 +278,7 @@ static void arcmsr_define_adapter_type(s
 	struct pci_dev *pdev =3D acb->pdev;
 	u16 dev_id;
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
+	acb->dev_id =3D dev_id;
 	switch (dev_id) {
 	case 0x1201 : {
 		acb->adapter_type =3D ACB_ADAPTER_TYPE_B;
@@ -237,141 +289,210 @@ static void arcmsr_define_adapter_type(s
 	}
 }
=20
-static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock =
*acb)
+{
+	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
+	uint32_t Index;
+	uint8_t Retries =3D 0x00;
+
+	do {
+		for (Index =3D 0; Index < 100; Index++) {
+			if (readl(&reg->outbound_intstatus) &
+					ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
+				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,
+					&reg->outbound_intstatus);
+				return 0x00;
+			}
+			msleep(10);
+		}/*max 1 seconds*/
+
+	} while (Retries++ < 20);/*max 20 sec*/
+	return 0xff;
+}
+
+static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock =
*acb)
+{
+	struct MessageUnit_B *reg =3D acb->pmuB;
+	uint32_t Index;
+	uint8_t Retries =3D 0x00;
+
+	do {
+		for (Index =3D 0; Index < 100; Index++) {
+			if (readl(reg->iop2drv_doorbell)
+				& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
+				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN
+					, reg->iop2drv_doorbell);
+				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
+				return 0x00;
+			}
+			msleep(10);
+		}/*max 1 seconds*/
+
+	} while (Retries++ < 20);/*max 20 sec*/
+	return 0xff;
+}
+
+static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
+	int retry_count =3D 30;
+
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
+	do {
+		if (!arcmsr_hba_wait_msgint_ready(acb))
+			break;
+		else {
+			retry_count--;
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
+			timeout, retry count down =3D %d \n", acb->host->host_no, =
retry_count);
+		}
+	} while (retry_count !=3D 0);
+}
+
+static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
 {
+	struct MessageUnit_B *reg =3D acb->pmuB;
+	int retry_count =3D 30;
=20
+	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);
+	do {
+		if (!arcmsr_hbb_wait_msgint_ready(acb))
+			break;
+		else {
+			retry_count--;
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
+			timeout,retry count down =3D %d \n", acb->host->host_no, =
retry_count);
+		}
+	} while (retry_count !=3D 0);
+}
+
+static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
+{
 	switch (acb->adapter_type) {
=20
 	case ACB_ADAPTER_TYPE_A: {
+		arcmsr_flush_hba_cache(acb);
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		arcmsr_flush_hbb_cache(acb);
+		}
+	}
+}
+
+static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
+{
 		struct pci_dev *pdev =3D acb->pdev;
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A: {
+
 		void *dma_coherent;
-		dma_addr_t dma_coherent_handle, dma_addr;
+			dma_addr_t dma_coherent_handle;
 		struct CommandControlBlock *ccb_tmp;
-		int i, j;
-
-		acb->pmuA =3D ioremap(pci_resource_start(pdev, 0), =
pci_resource_len(pdev, 0));
-		if (!acb->pmuA) {
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
-							acb->host->host_no);
-			return -ENOMEM;
-		}
+			int i =3D 0, j =3D 0;
+			dma_addr_t cdb_phyaddr;
+			unsigned long roundup_ccbsize =3D 0;
+			unsigned long max_xfer_len;
+			unsigned long max_sg_entrys;
+			uint32_t  firm_config_version;
=20
-		dma_coherent =3D dma_alloc_coherent(&pdev->dev,
-			ARCMSR_MAX_FREECCB_NUM *
-			sizeof (struct CommandControlBlock) + 0x20,
-			&dma_coherent_handle, GFP_KERNEL);
+			for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)
+				for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)
+					acb->devstate[i][j] =3D ARECA_RAID_GONE;
=20
+			max_xfer_len =3D ARCMSR_MAX_XFER_LEN;
+			max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;
+			firm_config_version =3D acb->firm_cfg_version;
+			if((firm_config_version & 0xFF) >=3D 3){
+				max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH << =
((firm_config_version >> 8) & 0xFF)) * 1024;/* max 16M byte */
+				max_sg_entrys =3D (max_xfer_len/4096);=09
+			}
+			acb->host->max_sectors =3D max_xfer_len/512;
+			acb->host->sg_tablesize =3D max_sg_entrys;
+			roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) + =
max_sg_entrys * sizeof(struct SG64ENTRY), 32);
+			acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
+			dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size, =
&dma_coherent_handle, GFP_KERNEL);
 		if (!dma_coherent) {
-			iounmap(acb->pmuA);
+				printk("arcmsr%d: dma_alloc_coherent got error \n", =
acb->host->host_no);
 			return -ENOMEM;
 		}
-
+			memset(dma_coherent, 0, acb->uncache_size);
 		acb->dma_coherent =3D dma_coherent;
 		acb->dma_coherent_handle =3D dma_coherent_handle;
-
-		if (((unsigned long)dma_coherent & 0x1F)) {
-			dma_coherent =3D dma_coherent +
-				(0x20 - ((unsigned long)dma_coherent & 0x1F));
-			dma_coherent_handle =3D dma_coherent_handle +
-				(0x20 - ((unsigned long)dma_coherent_handle & 0x1F));
-		}
-
-		dma_addr =3D dma_coherent_handle;
 		ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;
+			acb->vir2phy_offset =3D (unsigned long)dma_coherent - (unsigned =
long)dma_coherent_handle;
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-			ccb_tmp->cdb_shifted_phyaddr =3D dma_addr >> 5;
-			ccb_tmp->acb =3D acb;
+				cdb_phyaddr =3D dma_coherent_handle + offsetof(struct =
CommandControlBlock, arcmsr_cdb);
+				ccb_tmp->shifted_cdb_phyaddr =3D cdb_phyaddr >> 5;
 			acb->pccb_pool[i] =3D ccb_tmp;
+				ccb_tmp->acb =3D acb;
+				INIT_LIST_HEAD(&ccb_tmp->list);
 			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
-			dma_addr =3D dma_addr + sizeof(struct CommandControlBlock);
-			ccb_tmp++;
-		}
-
-		acb->vir2phy_offset =3D (unsigned long)ccb_tmp -(unsigned =
long)dma_addr;
-		for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)
-			for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)
-				acb->devstate[i][j] =3D ARECA_RAID_GONE;
+				ccb_tmp =3D (struct CommandControlBlock *)((unsigned long)ccb_tmp + =
roundup_ccbsize);
+				dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;
 		}
 		break;
-
+		}
 	case ACB_ADAPTER_TYPE_B: {
=20
-		struct pci_dev *pdev =3D acb->pdev;
-		struct MessageUnit_B *reg;
-		void __iomem *mem_base0, *mem_base1;
 		void *dma_coherent;
-		dma_addr_t dma_coherent_handle, dma_addr;
+			dma_addr_t dma_coherent_handle;
 		struct CommandControlBlock *ccb_tmp;
-		int i, j;
-
-		dma_coherent =3D dma_alloc_coherent(&pdev->dev,
-			((ARCMSR_MAX_FREECCB_NUM *
-			sizeof(struct CommandControlBlock) + 0x20) +
-			sizeof(struct MessageUnit_B)),
+			uint32_t cdb_phyaddr;
+			unsigned int roundup_ccbsize =3D 0;
+			unsigned long max_xfer_len;
+			unsigned long max_sg_entrys;
+			unsigned long firm_config_version;
+			unsigned long max_freeccb_num=3D0;
+			int i =3D 0, j =3D 0;
+
+			max_freeccb_num =3D ARCMSR_MAX_FREECCB_NUM;
+			max_xfer_len =3D ARCMSR_MAX_XFER_LEN;
+			max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;
+			firm_config_version =3D acb->firm_cfg_version;
+			if((firm_config_version & 0xFF) >=3D 3){
+				max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH <<=20
+						((firm_config_version >> 8) & 0xFF)) * 1024;/* max 16M byte */
+				max_sg_entrys =3D (max_xfer_len/4096);/* max 4097 sg entry*/
+			}
+			acb->host->max_sectors =3D max_xfer_len / 512;
+			acb->host->sg_tablesize =3D max_sg_entrys;
+			roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock)+
+				(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+			acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
+			dma_coherent =3D dma_alloc_coherent(&pdev->dev,acb->uncache_size,
 			&dma_coherent_handle, GFP_KERNEL);
-		if (!dma_coherent)
-			return -ENOMEM;
=20
+			if (!dma_coherent) {
+				printk(KERN_NOTICE "DMA allocation =
failed...........................\n");
+				return -ENOMEM;
+			}
+			memset(dma_coherent, 0, acb->uncache_size);
 		acb->dma_coherent =3D dma_coherent;
 		acb->dma_coherent_handle =3D dma_coherent_handle;
-
-		if (((unsigned long)dma_coherent & 0x1F)) {
-			dma_coherent =3D dma_coherent +
-				(0x20 - ((unsigned long)dma_coherent & 0x1F));
-			dma_coherent_handle =3D dma_coherent_handle +
-				(0x20 - ((unsigned long)dma_coherent_handle & 0x1F));
-		}
-
-		dma_addr =3D dma_coherent_handle;
 		ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;
+			acb->vir2phy_offset =3D (unsigned long)dma_coherent -
+					(unsigned long)dma_coherent_handle;
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-			ccb_tmp->cdb_shifted_phyaddr =3D dma_addr >> 5;
-			ccb_tmp->acb =3D acb;
+				cdb_phyaddr =3D dma_coherent_handle +
+					offsetof(struct CommandControlBlock, arcmsr_cdb);
+				ccb_tmp->shifted_cdb_phyaddr =3D cdb_phyaddr >> 5;
 			acb->pccb_pool[i] =3D ccb_tmp;
+				ccb_tmp->acb =3D acb;
+				INIT_LIST_HEAD(&ccb_tmp->list);
 			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
-			dma_addr =3D dma_addr + sizeof(struct CommandControlBlock);
-			ccb_tmp++;
+				ccb_tmp =3D (struct CommandControlBlock *)((unsigned long)ccb_tmp +
+									roundup_ccbsize);
+				dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;
 		}
-
-		reg =3D (struct MessageUnit_B *)(dma_coherent +
-		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock));
-		acb->pmuB =3D reg;
-		mem_base0 =3D ioremap(pci_resource_start(pdev, 0),
-					pci_resource_len(pdev, 0));
-		if (!mem_base0)
-			goto out;
-
-		mem_base1 =3D ioremap(pci_resource_start(pdev, 2),
-					pci_resource_len(pdev, 2));
-		if (!mem_base1) {
-			iounmap(mem_base0);
-			goto out;
-		}
-
-		reg->drv2iop_doorbell_reg =3D mem_base0 + ARCMSR_DRV2IOP_DOORBELL;
-		reg->drv2iop_doorbell_mask_reg =3D mem_base0 +
-						ARCMSR_DRV2IOP_DOORBELL_MASK;
-		reg->iop2drv_doorbell_reg =3D mem_base0 + ARCMSR_IOP2DRV_DOORBELL;
-		reg->iop2drv_doorbell_mask_reg =3D mem_base0 +
-						ARCMSR_IOP2DRV_DOORBELL_MASK;
-		reg->ioctl_wbuffer_reg =3D mem_base1 + ARCMSR_IOCTL_WBUFFER;
-		reg->ioctl_rbuffer_reg =3D mem_base1 + ARCMSR_IOCTL_RBUFFER;
-		reg->msgcode_rwbuffer_reg =3D mem_base1 + ARCMSR_MSGCODE_RWBUFFER;
-
-		acb->vir2phy_offset =3D (unsigned long)ccb_tmp -(unsigned =
long)dma_addr;
 		for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)
 			for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)
-				acb->devstate[i][j] =3D ARECA_RAID_GOOD;
+					acb->devstate[i][j] =3D ARECA_RAID_GONE;
 		}
 		break;
 	}
 	return 0;
-
-out:
-	dma_free_coherent(&acb->pdev->dev,
-		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20 +
-		sizeof(struct MessageUnit_B)), acb->dma_coherent, =
acb->dma_coherent_handle);
-	return -ENOMEM;
 }
 static void arcmsr_message_isr_bh_fn(struct work_struct *work)=20
 {
@@ -420,8 +540,8 @@ static void arcmsr_message_isr_bh_fn(str
 		case ACB_ADAPTER_TYPE_B: {
 			struct MessageUnit_B *reg  =3D acb->pmuB;
 			char *acb_dev_map =3D (char *)acb->device_map;
-			uint32_t __iomem *signature =3D (uint32_t =
__iomem*)(&reg->msgcode_rwbuffer_reg[0]);
-			char __iomem *devicemap =3D (char =
__iomem*)(&reg->msgcode_rwbuffer_reg[21]);
+			uint32_t __iomem *signature =3D (uint32_t =
__iomem*)(&reg->message_rwbuffer[0]);
+			char __iomem *devicemap =3D (char =
__iomem*)(&reg->message_rwbuffer[21]);
 			int target, lun;
 			struct scsi_device *psdev;
 			char diff;
@@ -456,8 +576,7 @@ static void arcmsr_message_isr_bh_fn(str
 	}
 }
=20
-static int arcmsr_probe(struct pci_dev *pdev,
-	const struct pci_device_id *id)
+static int arcmsr_probe(struct pci_dev *pdev, const struct =
pci_device_id *id)
 {
 	struct Scsi_Host *host;
 	struct AdapterControlBlock *acb;
@@ -465,19 +584,13 @@ static int arcmsr_probe(struct pci_dev *
 	int error;
=20
 	error =3D pci_enable_device(pdev);
-	if (error)
-		goto out;
-	pci_set_master(pdev);
-
-	host =3D scsi_host_alloc(&arcmsr_scsi_host_template,
-			sizeof(struct AdapterControlBlock));
+	if(error){
+		return -ENODEV;
+	}
+	host =3D scsi_host_alloc(&arcmsr_scsi_host_template, sizeof(struct =
AdapterControlBlock));
 	if (!host) {
-		error =3D -ENOMEM;
-		goto out_disable_device;
+    		goto pci_disable_dev;
 	}
-	acb =3D (struct AdapterControlBlock *)host->hostdata;
-	memset(acb, 0, sizeof (struct AdapterControlBlock));
-
 	error =3D pci_set_dma_mask(pdev, DMA_64BIT_MASK);
 	if (error) {
 		error =3D pci_set_dma_mask(pdev, DMA_32BIT_MASK);
@@ -485,126 +598,93 @@ static int arcmsr_probe(struct pci_dev *
 			printk(KERN_WARNING
 			       "scsi%d: No suitable DMA mask available\n",
 			       host->host_no);
-			goto out_host_put;
+			goto scsi_host_release;
 		}
 	}
+	init_waitqueue_head(&wait_q);
 	bus =3D pdev->bus->number;
 	dev_fun =3D pdev->devfn;
-	acb->host =3D host;
+	acb =3D (struct AdapterControlBlock *) host->hostdata;
+	memset(acb,0,sizeof(struct AdapterControlBlock));
 	acb->pdev =3D pdev;
-	host->max_sectors =3D ARCMSR_MAX_XFER_SECTORS;
+	acb->host =3D host;
 	host->max_lun =3D ARCMSR_MAX_TARGETLUN;
 	host->max_id =3D ARCMSR_MAX_TARGETID;/*16:8*/
 	host->max_cmd_len =3D 16;    /*this is issue of 64bit LBA, over 2T =
byte*/
-	host->sg_tablesize =3D ARCMSR_MAX_SG_ENTRIES;
 	host->can_queue =3D ARCMSR_MAX_FREECCB_NUM; /* max simultaneous cmds =
*/
 	host->cmd_per_lun =3D ARCMSR_MAX_CMD_PERLUN;
 	host->this_id =3D ARCMSR_SCSI_INITIATOR_ID;
 	host->unique_id =3D (bus << 8) | dev_fun;
-	host->irq =3D pdev->irq;
+	pci_set_drvdata(pdev, host);
+	pci_set_master(pdev);
 	error =3D pci_request_regions(pdev, "arcmsr");
 	if (error) {
-		goto out_host_put;
+		goto scsi_host_release;
 	}
-	arcmsr_define_adapter_type(acb);
-
+	spin_lock_init(&acb->eh_lock);
+	spin_lock_init(&acb->ccblist_lock);
 	acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |
 			   ACB_F_MESSAGE_RQBUFFER_CLEARED |
 			   ACB_F_MESSAGE_WQBUFFER_READED);
 	acb->acb_flags &=3D ~ACB_F_SCSISTOPADAPTER;
 	INIT_LIST_HEAD(&acb->ccb_free_list);
-	INIT_WORK (&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
+	arcmsr_define_adapter_type(acb);
+	error =3D arcmsr_remap_pciregion(acb);
+	if(!error){
+		goto pci_release_regs;
+	}
+	error =3D arcmsr_get_firmware_spec(acb);
+	if(!error){
+		goto unmap_pci_region;
+	}
 	error =3D arcmsr_alloc_ccb_pool(acb);
-	if (error)
-		goto out_release_regions;
-
+	if(error){
+		goto free_hbb_mu;
+	}
 	arcmsr_iop_init(acb);
-	error =3D request_irq(pdev->irq, arcmsr_do_interrupt,
-			    IRQF_SHARED, "arcmsr", acb);
-	if (error)
-		goto out_free_ccb_pool;
-
-	pci_set_drvdata(pdev, host);
-	if (strncmp(acb->firm_version, "V1.42", 5) >=3D 0)
-		host->max_sectors=3D ARCMSR_MAX_XFER_SECTORS_B;
-
 	error =3D scsi_add_host(host, &pdev->dev);
-	if (error)
-		goto out_free_irq;
-
-	error =3D arcmsr_alloc_sysfs_attr(acb);
-	if (error)
-		goto out_free_sysfs;
-
+	if(error){
+		goto RAID_controller_stop;
+	}
+	error =3D request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED, =
"arcmsr", acb);
+	if(error){
+		goto scsi_host_remove;
+	}
+	host->irq =3D pdev->irq;
 	scsi_scan_host(host);
-	#ifdef CONFIG_SCSI_ARCMSR_AER
-	pci_enable_pcie_error_reporting(pdev);
-	#endif
+	INIT_WORK (&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
 	atomic_set(&acb->rq_map_token, 16);
-	acb->fw_state =3D TRUE;
+	atomic_set(&acb->ante_token_value, 16);
+	acb->fw_flag =3D FW_NORMAL;
 	init_timer(&acb->eternal_timer);
-	acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(10*HZ);
+	acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6 * HZ);
 	acb->eternal_timer.data =3D (unsigned long) acb;
 	acb->eternal_timer.function =3D &arcmsr_request_device_map;
 	add_timer(&acb->eternal_timer);
-
+	#ifdef CONFIG_SCSI_ARCMSR_AER
+		pci_enable_pcie_error_reporting(pdev);
+	#endif
+	if(arcmsr_alloc_sysfs_attr(acb))
+		goto out_free_sysfs;
 	return 0;
  out_free_sysfs:
- out_free_irq:
-	free_irq(pdev->irq, acb);
- out_free_ccb_pool:
+	scsi_host_remove:
+		scsi_remove_host(host);
+	RAID_controller_stop:
+		arcmsr_stop_adapter_bgrb(acb);
+		arcmsr_flush_adapter_cache(acb);
 	arcmsr_free_ccb_pool(acb);
- out_release_regions:
+	free_hbb_mu:
+		arcmsr_free_mu(acb);
+	unmap_pci_region:
+		arcmsr_unmap_pciregion(acb);
+	pci_release_regs:
 	pci_release_regions(pdev);
- out_host_put:
+	scsi_host_release:
 	scsi_host_put(host);
- out_disable_device:
+	pci_disable_dev:
 	pci_disable_device(pdev);
- out:
-	return error;
-}
-
-static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock =
*acb)
-{
-	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
-	uint32_t Index;
-	uint8_t Retries =3D 0x00;
-
-	do {
-		for (Index =3D 0; Index < 100; Index++) {
-			if (readl(&reg->outbound_intstatus) &
-					ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
-				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,
-					&reg->outbound_intstatus);
-				return 0x00;
-			}
-			msleep(10);
-		}/*max 1 seconds*/
-
-	} while (Retries++ < 20);/*max 20 sec*/
-	return 0xff;
-}
-
-static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock =
*acb)
-{
-	struct MessageUnit_B *reg =3D acb->pmuB;
-	uint32_t Index;
-	uint8_t Retries =3D 0x00;
-
-	do {
-		for (Index =3D 0; Index < 100; Index++) {
-			if (readl(reg->iop2drv_doorbell_reg)
-				& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
-				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN
-					, reg->iop2drv_doorbell_reg);
-				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);
-				return 0x00;
-			}
-			msleep(10);
-		}/*max 1 seconds*/
-
-	} while (Retries++ < 20);/*max 20 sec*/
-	return 0xff;
+	return -ENODEV;
 }
=20
 static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
@@ -625,7 +705,7 @@ static uint8_t arcmsr_abort_hbb_allcmd(s
 {
 	struct MessageUnit_B *reg =3D acb->pmuB;
=20
-	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell_reg);
+	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"
@@ -651,74 +731,39 @@ static uint8_t arcmsr_abort_allcmd(struc
 	return rtnval;
 }
=20
-static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
-{
-	struct scsi_cmnd *pcmd =3D ccb->pcmd;
-
-	scsi_dma_unmap(pcmd);
-}
-
-static void arcmsr_ccb_complete(struct CommandControlBlock *ccb, int =
stand_flag)
-{
-	struct AdapterControlBlock *acb =3D ccb->acb;
-	struct scsi_cmnd *pcmd =3D ccb->pcmd;
-
-	arcmsr_pci_unmap_dma(ccb);
-	if (stand_flag =3D=3D 1)
-		atomic_dec(&acb->ccboutstandingcount);
-	ccb->startdone =3D ARCMSR_CCB_DONE;
-	ccb->ccb_flags =3D 0;
-	list_add_tail(&ccb->list, &acb->ccb_free_list);
-	pcmd->scsi_done(pcmd);
-}
-
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
-{
-	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
-	int retry_count =3D 30;
-
-	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
-	do {
-		if (!arcmsr_hba_wait_msgint_ready(acb))
-			break;
-		else {
-			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
-			timeout, retry count down =3D %d \n", acb->host->host_no, =
retry_count);
-		}
-	} while (retry_count !=3D 0);
-}
-
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
+static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock =
*pacb)
 {
-	struct MessageUnit_B *reg =3D acb->pmuB;
-	int retry_count =3D 30;
+	struct MessageUnit_B *reg =3D pacb->pmuB;
=20
-	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell_reg);
-	do {
-		if (!arcmsr_hbb_wait_msgint_ready(acb))
-			break;
-		else {
-			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
-			timeout,retry count down =3D %d \n", acb->host->host_no, =
retry_count);
+	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
+	if(arcmsr_hbb_wait_msgint_ready(pacb)){
+		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", =
pacb->host->host_no);
+		return false;
 		}
-	} while (retry_count !=3D 0);
+    	return true;
 }
=20
-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
+static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
 {
-	switch (acb->adapter_type) {
-
-	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_flush_hba_cache(acb);
-		}
-		break;
+	struct scsi_cmnd *pcmd =3D ccb->pcmd;
=20
-	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_flush_hbb_cache(acb);
-		}
+	scsi_dma_unmap(pcmd);
 	}
+
+static void arcmsr_ccb_complete(struct CommandControlBlock *ccb)
+{
+	struct AdapterControlBlock *acb =3D ccb->acb;
+	struct scsi_cmnd *pcmd =3D ccb->pcmd;
+	unsigned long flags;
+
+	atomic_dec(&acb->ccboutstandingcount);
+	arcmsr_pci_unmap_dma(ccb);
+	ccb->startdone =3D ARCMSR_CCB_DONE;
+	ccb->ccb_flags =3D 0;
+	spin_lock_irqsave(&acb->ccblist_lock, flags);
+	list_add_tail(&ccb->list, &acb->ccb_free_list);
+	spin_unlock_irqrestore(&acb->ccblist_lock, flags);
+	pcmd->scsi_done(pcmd);
 }
=20
 static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
@@ -754,15 +799,15 @@ static u32 arcmsr_disable_outbound_ints(
=20
 	case ACB_ADAPTER_TYPE_B : {
 		struct MessageUnit_B *reg =3D acb->pmuB;
-		orig_mask =3D readl(reg->iop2drv_doorbell_mask_reg);
-		writel(0, reg->iop2drv_doorbell_mask_reg);
+		orig_mask =3D readl(reg->iop2drv_doorbell_mask);
+		writel(0, reg->iop2drv_doorbell_mask);
 		}
 		break;
 	}
 	return orig_mask;
 }
=20
-static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb, \
+static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,=20
 			struct CommandControlBlock *ccb, uint32_t flag_ccb)
 {
=20
@@ -773,13 +818,13 @@ static void arcmsr_report_ccb_state(stru
 		if (acb->devstate[id][lun] =3D=3D ARECA_RAID_GONE)
 			acb->devstate[id][lun] =3D ARECA_RAID_GOOD;
 			ccb->pcmd->result =3D DID_OK << 16;
-			arcmsr_ccb_complete(ccb, 1);
+			arcmsr_ccb_complete(ccb);
 	} else {
 		switch (ccb->arcmsr_cdb.DeviceStatus) {
 		case ARCMSR_DEV_SELECT_TIMEOUT: {
 			acb->devstate[id][lun] =3D ARECA_RAID_GONE;
 			ccb->pcmd->result =3D DID_NO_CONNECT << 16;
-			arcmsr_ccb_complete(ccb, 1);
+			arcmsr_ccb_complete(ccb);
 			}
 			break;
=20
@@ -788,14 +833,14 @@ static void arcmsr_report_ccb_state(stru
 		case ARCMSR_DEV_INIT_FAIL: {
 			acb->devstate[id][lun] =3D ARECA_RAID_GONE;
 			ccb->pcmd->result =3D DID_BAD_TARGET << 16;
-			arcmsr_ccb_complete(ccb, 1);
+			arcmsr_ccb_complete(ccb);
 			}
 			break;
=20
 		case ARCMSR_DEV_CHECK_CONDITION: {
 			acb->devstate[id][lun] =3D ARECA_RAID_GOOD;
 			arcmsr_report_sense_info(ccb);
-			arcmsr_ccb_complete(ccb, 1);
+			arcmsr_ccb_complete(ccb);
 			}
 			break;
=20
@@ -810,7 +855,7 @@ static void arcmsr_report_ccb_state(stru
 					, ccb->arcmsr_cdb.DeviceStatus);
 					acb->devstate[id][lun] =3D ARECA_RAID_GONE;
 					ccb->pcmd->result =3D DID_NO_CONNECT << 16;
-					arcmsr_ccb_complete(ccb, 1);
+					arcmsr_ccb_complete(ccb);
 			break;
 		}
 	}
@@ -820,14 +865,19 @@ static void arcmsr_drain_donequeue(struc
=20
 {
 	struct CommandControlBlock *ccb;
+	struct ARCMSR_CDB *arcmsr_cdb;
+	int id, lun;
=20
-	ccb =3D (struct CommandControlBlock *)(acb->vir2phy_offset + (flag_ccb =
<< 5));
+	arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));
+	ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);
 	if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {
 		if (ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) {
 			struct scsi_cmnd *abortcmd =3D ccb->pcmd;
 			if (abortcmd) {
+				id =3D abortcmd->device->id;
+				lun =3D abortcmd->device->lun;			=09
 				abortcmd->result |=3D DID_ABORT << 16;
-				arcmsr_ccb_complete(ccb, 1);
+				arcmsr_ccb_complete(ccb);
 				printk(KERN_NOTICE "arcmsr%d: ccb =3D'0x%p' \
 				isr got aborted command \n", acb->host->host_no, ccb);
 			}
@@ -892,6 +942,7 @@ static void arcmsr_remove(struct pci_dev
 	int poll_count =3D 0;
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
+	scsi_host_put(host);
 	flush_scheduled_work();
 	del_timer_sync(&acb->eternal_timer);
 	arcmsr_disable_outbound_ints(acb);
@@ -917,7 +968,7 @@ static void arcmsr_remove(struct pci_dev
 			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {
 				ccb->startdone =3D ARCMSR_CCB_ABORTED;
 				ccb->pcmd->result =3D DID_ABORT << 16;
-				arcmsr_ccb_complete(ccb, 1);
+				arcmsr_ccb_complete(ccb);
 			}
 		}
 	}
@@ -921,13 +972,10 @@ static void arcmsr_remove(struct pci_dev
 			}
 		}
 	}
-
 	free_irq(pdev->irq, acb);
 	arcmsr_free_ccb_pool(acb);
+	arcmsr_free_mu(acb);
 	pci_release_regions(pdev);
-
-	scsi_host_put(host);
-
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 }
@@ -982,7 +1030,7 @@ static void arcmsr_enable_outbound_ints(
 			ARCMSR_IOP2DRV_DATA_READ_OK |
 			ARCMSR_IOP2DRV_CDB_DONE |
 			ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);
-		writel(mask, reg->iop2drv_doorbell_mask_reg);
+		writel(mask, reg->iop2drv_doorbell_mask);
 		acb->outbound_int_enable =3D (intmask_org | mask) & 0x0000000f;
 		}
 	}
@@ -995,6 +1043,9 @@ static int arcmsr_build_ccb(struct Adapt
 	int8_t *psge =3D (int8_t *)&arcmsr_cdb->u;
 	__le32 address_lo, address_hi;
 	int arccdbsize =3D 0x30;
+	__le32 length =3D 0;
+	int i, cdb_sgcount =3D 0;
+	struct scatterlist *sg;
 	int nseg;
=20
 	ccb->pcmd =3D pcmd;
@@ -1004,19 +1055,12 @@ static int arcmsr_build_ccb(struct Adapt
 	arcmsr_cdb->LUN =3D pcmd->device->lun;
 	arcmsr_cdb->Function =3D 1;
 	arcmsr_cdb->CdbLength =3D (uint8_t)pcmd->cmd_len;
-	arcmsr_cdb->Context =3D (unsigned long)arcmsr_cdb;
+	arcmsr_cdb->Context =3D 0;
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
=20
 	nseg =3D scsi_dma_map(pcmd);
-	if (nseg > ARCMSR_MAX_SG_ENTRIES)
+	if(nseg > acb->host->sg_tablesize || nseg < 0)
 		return FAILED;
-	BUG_ON(nseg < 0);
-
-	if (nseg) {
-		__le32 length;
-		int i, cdb_sgcount =3D 0;
-		struct scatterlist *sg;
-
 		/* map stor port SG list to our iop SG List. */
 		scsi_for_each_sg(pcmd, sg, nseg, i) {
 			/* Get the physical address of the current data pointer */
@@ -1043,10 +1087,10 @@ static int arcmsr_build_ccb(struct Adapt
 		}
 		arcmsr_cdb->sgcount =3D (uint8_t)cdb_sgcount;
 		arcmsr_cdb->DataLength =3D scsi_bufflen(pcmd);
+	arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : =
0);
 		if ( arccdbsize > 256)
 			arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_SGL_BSIZE;
-	}
-	if (pcmd->sc_data_direction =3D=3D DMA_TO_DEVICE ) {
+	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || =
pcmd->cmnd[0]|WRITE_12 ){
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_WRITE;
 		ccb->ccb_flags |=3D CCB_FLAG_WRITE;
 	}
@@ -1055,7 +1099,7 @@ static int arcmsr_build_ccb(struct Adapt
=20
 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct =
CommandControlBlock *ccb)
 {
-	uint32_t cdb_shifted_phyaddr =3D ccb->cdb_shifted_phyaddr;
+	uint32_t shifted_cdb_phyaddr =3D ccb->shifted_cdb_phyaddr;
 	struct ARCMSR_CDB *arcmsr_cdb =3D (struct ARCMSR_CDB =
*)&ccb->arcmsr_cdb;
 	atomic_inc(&acb->ccboutstandingcount);
 	ccb->startdone =3D ARCMSR_CCB_START;
@@ -1065,10 +1109,10 @@ static void arcmsr_post_ccb(struct Adapt
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;
=20
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
-			writel(cdb_shifted_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
+			writel(shifted_cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
 			&reg->inbound_queueport);
 		else {
-				writel(cdb_shifted_phyaddr, &reg->inbound_queueport);
+				writel(shifted_cdb_phyaddr, &reg->inbound_queueport);
 		}
 		}
 		break;
@@ -1080,16 +1124,16 @@ static void arcmsr_post_ccb(struct Adapt
 		ending_index =3D ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
 		writel(0, &reg->post_qbuffer[ending_index]);
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
-			writel(cdb_shifted_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
+			writel(shifted_cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
 						 &reg->post_qbuffer[index]);
 		}
 		else {
-			writel(cdb_shifted_phyaddr, &reg->post_qbuffer[index]);
+			writel(shifted_cdb_phyaddr, &reg->post_qbuffer[index]);
 		}
 		index++;
 		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to =
0 */
 		reg->postq_index =3D index;
-		writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell);
 		}
 		break;
 	}
@@ -1112,7 +1156,7 @@ static void arcmsr_stop_hbb_bgrb(struct=20
 {
 	struct MessageUnit_B *reg =3D acb->pmuB;
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell_reg);
+	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);
=20
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
@@ -1140,23 +1184,14 @@ static void arcmsr_free_ccb_pool(struct=20
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size, =
acb->dma_coherent, acb->dma_coherent_handle);
 		iounmap(acb->pmuA);
-		dma_free_coherent(&acb->pdev->dev,
-		ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock) + 0x20,
-		acb->dma_coherent,
-		acb->dma_coherent_handle);
-		break;
 	}
+		break;
 	case ACB_ADAPTER_TYPE_B: {
-		struct MessageUnit_B *reg =3D acb->pmuB;
-		iounmap((u8 *)reg->drv2iop_doorbell_reg - ARCMSR_DRV2IOP_DOORBELL);
-		iounmap((u8 *)reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);
-		dma_free_coherent(&acb->pdev->dev,
-		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20 +
-		sizeof(struct MessageUnit_B)), acb->dma_coherent, =
acb->dma_coherent_handle);
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size, =
acb->dma_coherent, acb->dma_coherent_handle);
 	}
 	}
-
 }
=20
 void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
@@ -1170,7 +1205,7 @@ void arcmsr_iop_message_read(struct Adap
=20
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg =3D acb->pmuB;
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
 		}
 		break;
 	}
@@ -1195,7 +1230,7 @@ static void arcmsr_iop_message_wrote(str
 		** push inbound doorbell tell iop, driver data write ok
 		** and wait reply on next hwinterrupt for next Qbuffer post
 		*/
-		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell);
 		}
 		break;
 	}
@@ -1215,7 +1250,7 @@ struct QBUFFER __iomem *arcmsr_get_iop_r
=20
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg =3D acb->pmuB;
-		qbuffer =3D (struct QBUFFER __iomem *)reg->ioctl_rbuffer_reg;
+		qbuffer =3D (struct QBUFFER __iomem *)reg->message_rbuffer;
 		}
 		break;
 	}
@@ -1236,7 +1271,7 @@ static struct QBUFFER __iomem *arcmsr_ge
=20
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B  *reg =3D acb->pmuB;
-		pqbuffer =3D (struct QBUFFER __iomem *)reg->ioctl_wbuffer_reg;
+		pqbuffer =3D (struct QBUFFER __iomem *)reg->message_wbuffer;
 		}
 		break;
 	}
@@ -1371,7 +1405,7 @@ static void arcmsr_hbb_message_isr(struc
 	struct MessageUnit_B *reg  =3D acb->pmuB;
=20
 	/*clear interrupt and message state*/
-	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);
+	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
@@ -1403,16 +1437,16 @@ static int arcmsr_handle_hbb_isr(struct=20
 	uint32_t outbound_doorbell;
 	struct MessageUnit_B *reg =3D acb->pmuB;
=20
-	outbound_doorbell =3D readl(reg->iop2drv_doorbell_reg) &
+	outbound_doorbell =3D readl(reg->iop2drv_doorbell) &
 				acb->outbound_int_enable;
 	if (!outbound_doorbell)
 		return 1;
=20
-	writel(~outbound_doorbell, reg->iop2drv_doorbell_reg);
+	writel(~outbound_doorbell, reg->iop2drv_doorbell);
 	/*in case the last action of doorbell interrupt clearance is cached,
 	this action can push HW to write down the clear bit*/
-	readl(reg->iop2drv_doorbell_reg);
-	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);
+	readl(reg->iop2drv_doorbell);
+	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
 	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {
 		arcmsr_iop2drv_data_wrote_handle(acb);
 	}
@@ -1531,12 +1565,6 @@ static int arcmsr_iop_message_xfer(struc
 			goto message_out;
 		}
 			=09
-		if(acb->fw_state =3D=3D FALSE) {
-			pcmdmessagefld->cmdmessage.ReturnCode =3D
-			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-			goto message_out;
-		}
-
 		ptmpQbuffer =3D ver_addr;
 		while ((acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex)
 			&& (allxfer_len < 1031)) {
@@ -1568,7 +1596,11 @@ static int arcmsr_iop_message_xfer(struc
 		}
 		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);
 		pcmdmessagefld->cmdmessage.Length =3D allxfer_len;
+		if(acb->fw_flag =3D=3D FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}else{
 		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;
+		}
 		kfree(ver_addr);
 		}
 		break;
@@ -1583,12 +1615,13 @@ static int arcmsr_iop_message_xfer(struc
 			retvalue =3D ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
-		if(acb->fw_state =3D=3D FALSE) {
+		if(acb->fw_flag =3D=3D FW_DEADLOCK) {
 			pcmdmessagefld->cmdmessage.ReturnCode =3D
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-			goto message_out;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=20
+			ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
-
 		ptmpuserbuffer =3D ver_addr;
 		user_len =3D pcmdmessagefld->cmdmessage.Length;
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);
@@ -1641,12 +1674,6 @@ static int arcmsr_iop_message_xfer(struc
=20
 	case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {
 		uint8_t *pQbuffer =3D acb->rqbuffer;
-		if(acb->fw_state =3D=3D FALSE) {
-			pcmdmessagefld->cmdmessage.ReturnCode =3D
-			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-			goto message_out;
-		}
-
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;
 			arcmsr_iop_message_read(acb);
@@ -1655,16 +1682,24 @@ static int arcmsr_iop_message_xfer(struc
 		acb->rqbuf_firstindex =3D 0;
 		acb->rqbuf_lastindex =3D 0;
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
-		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;
+		if(acb->fw_flag =3D=3D FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =3D
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =3D
+			ARCMSR_MESSAGE_RETURNCODE_OK;
+		}
 		}
 		break;
=20
 	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {
 		uint8_t *pQbuffer =3D acb->wqbuffer;
-		if(acb->fw_state =3D=3D FALSE) {
+		if(acb->fw_flag =3D=3D FW_DEADLOCK) {
 			pcmdmessagefld->cmdmessage.ReturnCode =3D
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-			goto message_out;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =3D
+			ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
=20
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
@@ -1677,18 +1712,11 @@ static int arcmsr_iop_message_xfer(struc
 		acb->wqbuf_firstindex =3D 0;
 		acb->wqbuf_lastindex =3D 0;
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
-		pcmdmessagefld->cmdmessage.ReturnCode =3D
-			ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
 		break;
=20
 	case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {
 		uint8_t *pQbuffer;
-		if(acb->fw_state =3D=3D FALSE) {
-			pcmdmessagefld->cmdmessage.ReturnCode =3D
-			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-			goto message_out;
-		}
=20
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;
@@ -1706,47 +1734,52 @@ static int arcmsr_iop_message_xfer(struc
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));
 		pQbuffer =3D acb->wqbuffer;
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));
-		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;
+		if(acb->fw_flag =3D=3D FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =3D
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =3D
+			ARCMSR_MESSAGE_RETURNCODE_OK;
+		}
 		}
 		break;
=20
 	case ARCMSR_MESSAGE_RETURN_CODE_3F: {
-		if(acb->fw_state =3D=3D FALSE) {
+		if(acb->fw_flag =3D=3D FW_DEADLOCK) {
 			pcmdmessagefld->cmdmessage.ReturnCode =3D
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-			goto message_out;
-		}
-		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_3F;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =3D
+			ARCMSR_MESSAGE_RETURNCODE_3F;
 		}
 		break;
-
+		}
 	case ARCMSR_MESSAGE_SAY_HELLO: {
 		int8_t *hello_string =3D "Hello! I am ARCMSR";
-		if(acb->fw_state =3D=3D FALSE) {
+		if(acb->fw_flag =3D=3D FW_DEADLOCK) {
 			pcmdmessagefld->cmdmessage.ReturnCode =3D
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-			goto message_out;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =3D
+			ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
 		memcpy(pcmdmessagefld->messagedatabuffer, hello_string
 			, (int16_t)strlen(hello_string));
-		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
 		break;
=20
 	case ARCMSR_MESSAGE_SAY_GOODBYE:
-		if(acb->fw_state =3D=3D FALSE) {
+		if(acb->fw_flag =3D=3D FW_DEADLOCK) {
 			pcmdmessagefld->cmdmessage.ReturnCode =3D
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-			goto message_out;
 		}
 		arcmsr_iop_parking(acb);
 		break;
=20
 	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:
-		if(acb->fw_state =3D=3D FALSE) {
+		if(acb->fw_flag =3D=3D FW_DEADLOCK) {
 			pcmdmessagefld->cmdmessage.ReturnCode =3D
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-			goto message_out;
 		}
 		arcmsr_flush_adapter_cache(acb);
 		break;
@@ -1764,11 +1797,16 @@ static struct CommandControlBlock *arcms
 {
 	struct list_head *head =3D &acb->ccb_free_list;
 	struct CommandControlBlock *ccb =3D NULL;
-
+	unsigned long flags;
+	spin_lock_irqsave(&acb->ccblist_lock, flags);
 	if (!list_empty(head)) {
 		ccb =3D list_entry(head->next, struct CommandControlBlock, list);
-		list_del(head->next);
+		list_del_init(&ccb->list);
+	}else{
+		spin_unlock_irqrestore(&acb->ccblist_lock, flags);
+		return 0;
 	}
+	spin_unlock_irqrestore(&acb->ccblist_lock, flags);
 	return ccb;
 }
=20
@@ -1843,66 +1881,12 @@ static int arcmsr_queue_command(struct s
 		return 0;
 	}
=20
-	if (acb->acb_flags & ACB_F_BUS_RESET) {
-		switch (acb->adapter_type) {
-			case ACB_ADAPTER_TYPE_A: {
-				struct MessageUnit_A __iomem *reg =3D acb->pmuA;
-				uint32_t intmask_org,outbound_doorbell;
-
-				if((readl(&reg->outbound_msgaddr1) &
-					ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0 ) {
-					printk(KERN_NOTICE "arcmsr%d: bus reset and return busy \n",
-						acb->host->host_no);
-					return SCSI_MLQUEUE_HOST_BUSY;
-				}
-
-				acb->acb_flags &=3D ~ACB_F_FIRMWARE_TRAP;
-				printk(KERN_NOTICE "arcmsr%d: hardware bus reset and reset ok \n",
-					acb->host->host_no);
-				/* disable all outbound interrupt */
-				intmask_org =3D arcmsr_disable_outbound_ints(acb);
- 				arcmsr_get_firmware_spec(acb,1);
-				/*start background rebuild*/
-				arcmsr_start_adapter_bgrb(acb);
-				/* clear Qbuffer if door bell ringed */
-				outbound_doorbell =3D readl(&reg->outbound_doorbell);
-				/*clear interrupt */
-				writel(outbound_doorbell, &reg->outbound_doorbell);
-   				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
-					&reg->inbound_doorbell);
-				/* enable outbound Post Queue,outbound doorbell Interrupt */
-				arcmsr_enable_outbound_ints(acb, intmask_org);
-				acb->acb_flags |=3D ACB_F_IOP_INITED;
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;
-			}
-			break;
-			case ACB_ADAPTER_TYPE_B: {
-			}
-		}
-	}
-
 	if (target =3D=3D 16) {
 		/* virtual device for iop message transfer */
 		arcmsr_handle_virtual_command(acb, cmd);
 		return 0;
 	}
-	if (acb->devstate[target][lun] =3D=3D ARECA_RAID_GONE) {
-		uint8_t block_cmd;
=20
-		block_cmd =3D cmd->cmnd[0] & 0x0f;
-		if (block_cmd =3D=3D 0x08 || block_cmd =3D=3D 0x0a) {
-			printk(KERN_NOTICE
-				"arcmsr%d: block 'read/write'"
-				"command with gone raid volume"
-				" Cmd =3D %2x, TargetId =3D %d, Lun =3D %d \n"
-				, acb->host->host_no
-				, cmd->cmnd[0]
-				, target, lun);
-			cmd->result =3D (DID_NO_CONNECT << 16);
-			cmd->scsi_done(cmd);
-			return 0;
-		}
-	}
 	if (atomic_read(&acb->ccboutstandingcount) >=3D
 			ARCMSR_MAX_OUTSTANDING_CMD)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1919,7 +1903,7 @@ static int arcmsr_queue_command(struct s
 	return 0;
 }
=20
-static void *arcmsr_get_hba_config(struct AdapterControlBlock *acb, int =
mode){
+static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb){
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
 	char *acb_firm_model =3D acb->firm_model;
 	char *acb_firm_version =3D acb->firm_version;
@@ -1933,10 +1917,8 @@ static void *arcmsr_get_hba_config(struc
 	if (arcmsr_hba_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", acb->host->host_no);
-		return NULL;
+		return false;
 	}
-
-	if(mode =3D=3D 1) {
 		count =3D 8;
 		while (count) {
 			*acb_firm_model =3D readb(iop_firm_model);
@@ -1960,44 +1942,61 @@ static void *arcmsr_get_hba_config(struc
 			iop_device_map++;
 			count--;
  		}
-	=09
-		printk(KERN_INFO 	"ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n"
-			, acb->host->host_no
-			, acb->firm_version);
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",=20
+		acb->host->host_no,
+		acb->firm_version,
+		acb->firm_model);
 		acb->signature =3D readl(&reg->message_rwbuffer[0]);
 		acb->firm_request_len =3D readl(&reg->message_rwbuffer[1]);
 		acb->firm_numbers_queue =3D readl(&reg->message_rwbuffer[2]);
 		acb->firm_sdram_size =3D readl(&reg->message_rwbuffer[3]);
 		acb->firm_hd_channels =3D readl(&reg->message_rwbuffer[4]);
+	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/
+	return true;
 	}
-	return (reg->message_rwbuffer);
-}
-static void __iomem *arcmsr_get_hbb_config(struct AdapterControlBlock =
*acb, int mode)
+static bool arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg =3D acb->pmuB;
-	uint32_t __iomem *lrwbuffer =3D reg->msgcode_rwbuffer_reg;
+	struct pci_dev *pdev =3D acb->pdev;
+	void *dma_coherent;
+	dma_addr_t dma_coherent_handle;
 	char *acb_firm_model =3D acb->firm_model;
 	char *acb_firm_version =3D acb->firm_version;
 	char *acb_device_map =3D acb->device_map;
-	char __iomem *iop_firm_model =3D (char __iomem *)(&lrwbuffer[15]);
+	char __iomem *iop_firm_model;
 	/*firm_model,15,60-67*/
-	char __iomem *iop_firm_version =3D (char __iomem *)(&lrwbuffer[17]);
+	char __iomem *iop_firm_version;
 	/*firm_version,17,68-83*/
-	char __iomem *iop_device_map =3D (char __iomem *) (&lrwbuffer[21]);
+	char __iomem *iop_device_map;
 	/*firm_version,21,84-99*/
 	int count;
+	dma_coherent =3D dma_alloc_coherent(&pdev->dev, sizeof(struct =
MessageUnit_B), &dma_coherent_handle, GFP_KERNEL);
+	if (!dma_coherent){
+		printk("arcmsr%d: dma_alloc_coherent got error for hbb mu\n", =
acb->host->host_no);
+		return false;
+	}
+	acb->dma_coherent_handle_hbb_mu =3D dma_coherent_handle;
+	reg =3D (struct MessageUnit_B *)dma_coherent;
+	acb->pmuB =3D reg;
+	reg->drv2iop_doorbell=3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
+	reg->drv2iop_doorbell_mask =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
+	reg->iop2drv_doorbell =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
+	reg->iop2drv_doorbell_mask =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
+	reg->message_wbuffer =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_WBUFFER);
+	reg->message_rbuffer =3D  (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_RBUFFER);
+	reg->message_rwbuffer =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_RWBUFFER);
+	iop_firm_model =3D (char __iomem *)(&reg->message_rwbuffer[15]);	=
/*firm_model,15,60-67*/
+	iop_firm_version =3D (char __iomem *)(&reg->message_rwbuffer[17]);	=
/*firm_version,17,68-83*/
+	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]);	=
/*firm_version,21,84-99*/
=20
-	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);
+	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", acb->host->host_no);
-		return NULL;
+		return false;
 	}
-
-	if(mode =3D=3D 1) {
 		count =3D 8;
-		while (count)
-		{
+	while (count){
 			*acb_firm_model =3D readb(iop_firm_model);
 			acb_firm_model++;
 			iop_firm_model++;
@@ -2003,10 +2002,8 @@ static void __iomem *arcmsr_get_hbb_conf
 			iop_firm_model++;
 			count--;
 		}
-
 		count =3D 16;
-		while (count)
-		{
+	while (count){
 			*acb_firm_version =3D readb(iop_firm_version);
 			acb_firm_version++;
 			iop_firm_version++;
@@ -2021,46 +2018,41 @@ static void __iomem *arcmsr_get_hbb_conf
 			count--;
  		}
 	=09
-		printk(KERN_INFO "ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n",
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
 				acb->host->host_no,
-				acb->firm_version);
+		acb->firm_version,
+		acb->firm_model);
=20
-		acb->signature =3D readl(lrwbuffer++);
+	acb->signature =3D readl(&reg->message_rwbuffer[1]);
 		/*firm_signature,1,00-03*/
-		acb->firm_request_len =3D readl(lrwbuffer++);
+	acb->firm_request_len=3Dreadl(&reg->message_rwbuffer[2]);=20
 		/*firm_request_len,1,04-07*/
-		acb->firm_numbers_queue =3D readl(lrwbuffer++);
+	acb->firm_numbers_queue=3Dreadl(&reg->message_rwbuffer[3]);=20
 		/*firm_numbers_queue,2,08-11*/
-		acb->firm_sdram_size =3D readl(lrwbuffer++);
+	acb->firm_sdram_size=3Dreadl(&reg->message_rwbuffer[4]);=20
 		/*firm_sdram_size,3,12-15*/
-		acb->firm_hd_channels =3D readl(lrwbuffer);
+	acb->firm_hd_channels=3Dreadl(&reg->message_rwbuffer[5]);=20
 		/*firm_ide_channels,4,16-19*/
+	acb->firm_cfg_version=3Dreadl(&reg->message_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/
+	/*firm_ide_channels,4,16-19*/
+	return true;
 	}
-	return (reg->msgcode_rwbuffer_reg);
-}
-static void *arcmsr_get_firmware_spec(struct AdapterControlBlock *acb, =
int mode)
+static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
-	void *rtnval =3D 0;
-	switch (acb->adapter_type) {
-	case ACB_ADAPTER_TYPE_A: {
-		rtnval =3D arcmsr_get_hba_config(acb, mode);
-		}
-		break;
-
-	case ACB_ADAPTER_TYPE_B: {
-		rtnval =3D arcmsr_get_hbb_config(acb, mode);
-		}
-		break;
-	}
-	return rtnval;
+	if(acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_A)
+		return arcmsr_get_hba_config(acb);
+	else
+		return arcmsr_get_hbb_config(acb);
 }
=20
-static void arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
 	struct CommandControlBlock *poll_ccb)
 {
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
 	struct CommandControlBlock *ccb;
+	struct ARCMSR_CDB *arcmsr_cdb;
 	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done =3D 0, poll_count =
=3D 0;
+	int rtn;
=20
 	polling_hba_ccb_retry:
 	poll_count++;
@@ -2068,16 +2060,19 @@ static void arcmsr_polling_hba_ccbdone(s
 	writel(outbound_intstatus, &reg->outbound_intstatus);/*clear =
interrupt*/
 	while (1) {
 		if ((flag_ccb =3D readl(&reg->outbound_queueport)) =3D=3D 0xFFFFFFFF) =
{
-			if (poll_ccb_done)
+			if (poll_ccb_done){
+				rtn =3D SUCCESS;
 				break;
-			else {
-				msleep(25);
-				if (poll_count > 100)
+			}else {
+				if (poll_count > 100){
+					rtn =3D FAILED;
 					break;
+				}
 				goto polling_hba_ccb_retry;
 			}
 		}
-		ccb =3D (struct CommandControlBlock *)(acb->vir2phy_offset + =
(flag_ccb << 5));
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));
+		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);
 		poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1:0;
 		if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {
 			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) || (ccb =3D=3D =
poll_ccb)) {
@@ -2088,8 +2083,7 @@ static void arcmsr_polling_hba_ccbdone(s
 					, ccb->pcmd->device->lun
 					, ccb);
 				ccb->pcmd->result =3D DID_ABORT << 16;
-				arcmsr_ccb_complete(ccb, 1);
-				poll_ccb_done =3D 1;
+				arcmsr_ccb_complete(ccb);
 				continue;
 			}
 			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
@@ -2099,32 +2093,38 @@ static void arcmsr_polling_hba_ccbdone(s
 				, ccb
 				, atomic_read(&acb->ccboutstandingcount));
 			continue;
-		}
+		}else{
 		arcmsr_report_ccb_state(acb, ccb, flag_ccb);
 	}
 }
+	return rtn;
+}
=20
-static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock *poll_ccb)
 {
 		struct MessageUnit_B *reg =3D acb->pmuB;
+	struct ARCMSR_CDB *arcmsr_cdb;
 		struct CommandControlBlock *ccb;
 		uint32_t flag_ccb, poll_ccb_done =3D 0, poll_count =3D 0;
-		int index;
+	int index, rtn;
=20
 	polling_hbb_ccb_retry:
 		poll_count++;
 		/* clear doorbell interrupt */
-		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);
+	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 		while (1) {
 			index =3D reg->doneq_index;
 			if ((flag_ccb =3D readl(&reg->done_qbuffer[index])) =3D=3D 0) {
-				if (poll_ccb_done)
+			if (poll_ccb_done){
+				rtn =3D SUCCESS;
 					break;
-				else {
+			}else {
 					msleep(25);
-					if (poll_count > 100)
+				if (poll_count > 100){
+					rtn =3D FAILED;
 						break;
+				}
 					goto polling_hbb_ccb_retry;
 				}
 			}
@@ -2134,19 +2134,19 @@ static void arcmsr_polling_hbb_ccbdone(s
 			index %=3D ARCMSR_MAX_HBB_POSTQUEUE;
 			reg->doneq_index =3D index;
 			/* check ifcommand done with no error*/
-			ccb =3D (struct CommandControlBlock *)\
-      (acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes =
aligned*/
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));
+		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);
 			poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1:0;
 			if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {
 				if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) || (ccb =3D=3D =
poll_ccb)) {
-					printk(KERN_NOTICE "arcmsr%d: \
-		scsi id =3D %d lun =3D %d ccb =3D '0x%p' poll command abort =
successfully \n"
+				printk(KERN_NOTICE "arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D =
'0x%p'"
+					" poll command abort successfully \n"
 						,acb->host->host_no
 						,ccb->pcmd->device->id
 						,ccb->pcmd->device->lun
 						,ccb);
 					ccb->pcmd->result =3D DID_ABORT << 16;
-					arcmsr_ccb_complete(ccb, 1);
+				arcmsr_ccb_complete(ccb);
 					continue;
 				}
 				printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
@@ -2156,30 +2156,34 @@ static void arcmsr_polling_hbb_ccbdone(s
 					, ccb
 					, atomic_read(&acb->ccboutstandingcount));
 				continue;
-			}
+		}else{
 			arcmsr_report_ccb_state(acb, ccb, flag_ccb);
+		}
 		}	/*drain reply FIFO*/
+	return rtn;
 }
=20
-static void arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock *poll_ccb)
 {
+	int rtn =3D 0;
 	switch (acb->adapter_type) {
=20
 	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_polling_hba_ccbdone(acb,poll_ccb);
+		rtn =3D arcmsr_polling_hba_ccbdone(acb,poll_ccb);
 		}
 		break;
=20
 	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_polling_hbb_ccbdone(acb,poll_ccb);
+		rtn =3D arcmsr_polling_hbb_ccbdone(acb,poll_ccb);
 		}
 	}
+	return rtn;
 }
=20
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
-	uint32_t cdb_phyaddr, ccb_phyaddr_hi32;
+	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
 	dma_addr_t dma_coherent_handle;
 	/*
 	********************************************************************
@@ -2189,7 +2193,7 @@ static int arcmsr_iop_confirm(struct Ada
 	*/
 	dma_coherent_handle =3D acb->dma_coherent_handle;
 	cdb_phyaddr =3D (uint32_t)(dma_coherent_handle);
-	ccb_phyaddr_hi32 =3D (uint32_t)((cdb_phyaddr >> 16) >> 16);
+	cdb_phyaddr_hi32 =3D (uint32_t)((cdb_phyaddr >> 16) >> 16);
 	/*
 	=
***********************************************************************
 	**    if adapter type B, set window of "post command Q"
@@ -2198,13 +2202,13 @@ static int arcmsr_iop_confirm(struct Ada
 	switch (acb->adapter_type) {
=20
 	case ACB_ADAPTER_TYPE_A: {
-		if (ccb_phyaddr_hi32 !=3D 0) {
+		if (cdb_phyaddr_hi32 !=3D 0) {
 			struct MessageUnit_A __iomem *reg =3D acb->pmuA;
 			uint32_t intmask_org;
 			intmask_org =3D arcmsr_disable_outbound_ints(acb);
 			writel(ARCMSR_SIGNATURE_SET_CONFIG, \
 						&reg->message_rwbuffer[0]);
-			writel(ccb_phyaddr_hi32, &reg->message_rwbuffer[1]);
+			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
 							&reg->inbound_msgaddr0);
 			if (arcmsr_hba_wait_msgint_ready(acb)) {
@@ -2227,19 +2231,18 @@ static int arcmsr_iop_confirm(struct Ada
 		intmask_org =3D arcmsr_disable_outbound_ints(acb);
 		reg->postq_index =3D 0;
 		reg->doneq_index =3D 0;
-		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \
 				acb->host->host_no);
 			return 1;
 		}
-		post_queue_phyaddr =3D cdb_phyaddr + ARCMSR_MAX_FREECCB_NUM * \
-		sizeof(struct CommandControlBlock) + offsetof(struct MessageUnit_B, =
post_qbuffer) ;
-		rwbuffer =3D reg->msgcode_rwbuffer_reg;
+		post_queue_phyaddr =3D acb->dma_coherent_handle_hbb_mu;
+		rwbuffer =3D reg->message_rwbuffer;
 		/* driver "set config" signature */
 		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
 		/* normal should be zero */
-		writel(ccb_phyaddr_hi32, rwbuffer++);
+		writel(cdb_phyaddr_hi32, rwbuffer++);
 		/* postQ size (256 + 8)*4	 */
 		writel(post_queue_phyaddr, rwbuffer++);
 		/* doneQ size (256 + 8)*4	 */
@@ -2247,19 +2250,13 @@ static int arcmsr_iop_confirm(struct Ada
 		/* ccb maxQ size must be --> [(256 + 8)*4]*/
 		writel(1056, rwbuffer);
=20
-		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
 			timeout \n",acb->host->host_no);
 			return 1;
 		}
-
-		writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell_reg);
-		if (arcmsr_hbb_wait_msgint_ready(acb)) {
-			printk(KERN_NOTICE "arcmsr%d: 'can not set diver mode \n"\
-			,acb->host->host_no);
-			return 1;
-		}
+		arcmsr_hbb_enable_driver_mode(acb);
 		arcmsr_enable_outbound_ints(acb, intmask_org);
 		}
 		break;
@@ -2284,9 +2281,9 @@ static void arcmsr_wait_firmware_ready(s
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg =3D acb->pmuB;
 		do {
-			firmware_state =3D readl(reg->iop2drv_doorbell_reg);
+			firmware_state =3D readl(reg->iop2drv_doorbell);
 		} while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) =3D=3D 0);
-		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
 		}
 		break;
 	}
@@ -2295,23 +2292,19 @@ static void arcmsr_wait_firmware_ready(s
 static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb)
 {
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
-
-	if(unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0)) {
-		acb->fw_state =3D FALSE;
+	if(unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0 ) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0 )){
+		return;
 	} else {
-	/*to prevent rq_map_token from changing by other interrupt, then
-	avoid the dead-lock*/
-		acb->fw_state =3D TRUE;
-		atomic_dec(&acb->rq_map_token);
-		if((acb->fw_state =3D=3D FALSE)||
-			(acb->ante_token_value=3D=3Datomic_read(&acb->rq_map_token))){
-
+		acb->fw_flag =3D FW_NORMAL;
+		if(atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)){
 			atomic_set(&acb->rq_map_token,16);
 		}
-		acb->ante_token_value=3Datomic_read(&acb->rq_map_token);
+		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
+		if(atomic_dec_and_test(&acb->rq_map_token))
+			return;
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
 	}
-	mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6000));
 	return;
 }
=20
@@ -2319,21 +2312,19 @@ static void arcmsr_request_hbb_device_ma
 {
 	struct MessageUnit_B __iomem *reg =3D acb->pmuB;
=20
-	if(unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0)) {
-		acb->fw_state =3D FALSE;
+	if(unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0 ) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0 )){
+		return;
 	} else {
-	/*to prevent rq_map_token from changing by other interrupt, then
-	avoid the dead-lock*/
-		acb->fw_state =3D TRUE;
-		atomic_dec(&acb->rq_map_token);
-		if((acb->fw_state =3D=3D FALSE)||
-			(acb->ante_token_value=3D=3Datomic_read(&acb->rq_map_token))){
+		acb->fw_flag =3D FW_NORMAL;
+		if(atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)){
 			atomic_set(&acb->rq_map_token,16);
 		}
-		acb->ante_token_value=3Datomic_read(&acb->rq_map_token);
-		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);
+		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
+		if(atomic_dec_and_test(&acb->rq_map_token))
+			return;
+		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
 	}
-	mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6000));
 	return;
 }
=20
@@ -2368,7 +2359,7 @@ static void arcmsr_start_hbb_bgrb(struct
 {
 	struct MessageUnit_B *reg =3D acb->pmuB;
 	acb->acb_flags |=3D ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell_reg);
+	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
 				rebulid' timeout \n",acb->host->host_no);
@@ -2404,8 +2395,8 @@ static void arcmsr_clear_doorbell_queue_
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg =3D acb->pmuB;
 		/*clear interrupt and message state*/
-		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
 		/* let IOP know data has been read */
 		}
 		break;
@@ -2420,7 +2411,7 @@ static void arcmsr_enable_eoi_mode(struc
 	case ACB_ADAPTER_TYPE_B:
 		{
 			struct MessageUnit_B *reg =3D acb->pmuB;
-			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell_reg);
+			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);
 			if(arcmsr_hbb_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");
 				return;
@@ -2435,13 +2426,19 @@ static void arcmsr_hardware_reset(struct
 {
 	uint8_t value[64];
 	int i;
+	struct MessageUnit_A __iomem *reg =3D acb->pmuA;
=20
 	/* backup pci config data */
+	printk(KERN_ERR "arcmsr%d: executing hw bus reset .....\n", =
acb->host->host_no);
 	for (i=3D0; i<64; i++) {
 		pci_read_config_byte(acb->pdev, i, &value[i]);
 	}
 	/* hardware reset signal */
+	if((acb->dev_id =3D=3D 0x1680)){
+		writel(ARCMSR_ARC1680_BUS_RESET, &reg->reserved1[0]);
+	}else{
 	pci_write_config_byte(acb->pdev, 0x84, 0x20);
+	}
 	msleep(1000);
 	/* write back pci config data */
 	for (i=3D0;i<64;i++) {
@@ -2454,37 +2451,25 @@ static void arcmsr_hardware_reset(struct
 =
*************************************************************************=
***
 =
*************************************************************************=
***
 */
-#ifdef CONFIG_SCSI_ARCMSR_RESET
 	int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)
 	{
 			struct Scsi_Host *shost =3D NULL;
-			spinlock_t *host_lock =3D NULL;
 			int i, isleep;
=20
 			shost =3D cmd->device->host;
-			host_lock =3D shost->host_lock;
-
-			printk("Host %d bus reset over, sleep %d seconds (busy %d, can queue =
%d) ...........\n",=20
-					shost->host_no, sleeptime, shost->host_busy, shost->can_queue);
 			isleep =3D sleeptime / 10;
-			spin_unlock_irq(host_lock);
 			if (isleep > 0) {
 				for (i =3D 0; i < isleep; i ++) {
 					msleep(10000);
-					printk("^%d^\n", i);
 				}
 			}
=20
 			isleep =3D sleeptime % 10;
 			if (isleep > 0) {
 				msleep(isleep*1000);
-				printk("^v^\n");
 			}
-			spin_lock_irq(host_lock);	       =20
-			printk("***** wake up *****\n");
 			return 0;
 	}
-#endif
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)
 {
 	uint32_t intmask_org;
@@ -2493,7 +2478,6 @@ static void arcmsr_iop_init(struct Adapt
        intmask_org =3D arcmsr_disable_outbound_ints(acb);
 	arcmsr_wait_firmware_ready(acb);
 	arcmsr_iop_confirm(acb);
-	arcmsr_get_firmware_spec(acb, 1);
 	/*start background rebuild*/
 	arcmsr_start_adapter_bgrb(acb);
 	/* empty doorbell Qbuffer if door bell ringed */
@@ -2516,14 +2499,12 @@ static uint8_t arcmsr_iop_reset(struct A
 		intmask_org =3D arcmsr_disable_outbound_ints(acb);
 		/* talk to iop 331 outstanding command aborted */
 		rtnval =3D arcmsr_abort_allcmd(acb);
-		/* wait for 3 sec for all command aborted*/
-		ssleep(3);
 		/* clear all outbound posted Q */
 		arcmsr_done4abort_postqueue(acb);
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
 			ccb =3D acb->pccb_pool[i];
 			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {
-				arcmsr_ccb_complete(ccb, 1);
+				arcmsr_ccb_complete(ccb);
 			}
 		}
 		atomic_set(&acb->ccboutstandingcount, 0);
@@ -2538,54 +2519,49 @@ static int arcmsr_bus_reset(struct scsi_
 {
 	struct AdapterControlBlock *acb =3D
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;
-	int retry =3D 0;
-=09
-	if(acb->acb_flags & ACB_F_BUS_RESET)
-		return SUCCESS;
+	uint32_t intmask_org, outbound_doorbell;
+	int retry_count =3D 0;
+	int rtn =3D FAILED;
=20
-	printk("arcmsr%d: bus reset ..... \n", acb->adapter_index);
-	acb->acb_flags |=3D ACB_F_BUS_RESET;
+	acb =3D (struct AdapterControlBlock *) cmd->device->host->hostdata;
+	printk(KERN_ERR "arcmsr: executing eh bus reset .....num_resets =3D =
%d,=20
+		num_aborts =3D %d \n", acb->num_resets, acb->num_aborts);
 	acb->num_resets++;
-	while(atomic_read(&acb->ccboutstandingcount) !=3D 0 && retry < 4) {
-		arcmsr_interrupt(acb);
-		retry++;
-	}
=20
-	if(arcmsr_iop_reset(acb)) {
 		switch (acb->adapter_type) {
 		case ACB_ADAPTER_TYPE_A: {
-			printk("arcmsr%d: do hardware bus reset, num_resets =3D %d =
num_aborts =3D %d \n",
-				acb->adapter_index, acb->num_resets, acb->num_aborts);
+			if(acb->acb_flags & ACB_F_BUS_RESET){
+				long timeout;
+				timeout =3D wait_event_timeout(wait_q,=20
+					(acb->acb_flags & ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);
+				if(timeout){
+					return SUCCESS;
+				}
+			}
+			acb->acb_flags |=3D ACB_F_BUS_RESET;
+			if(arcmsr_iop_reset(acb)){
+				struct MessageUnit_A __iomem *reg;
+				reg =3D acb->pmuA;
 			arcmsr_hardware_reset(acb);
-			acb->acb_flags |=3D ACB_F_FIRMWARE_TRAP;
 			acb->acb_flags &=3D ~ACB_F_IOP_INITED;
-			#ifdef CONFIG_SCSI_ARCMSR_RESET
-			struct MessageUnit_A __iomem *reg =3D acb->pmuA;
-			uint32_t intmask_org, outbound_doorbell;
-			int retry_count =3D 0;
 			sleep_again:
 			arcmsr_sleep_for_bus_reset(cmd);
-			if(( readl(&reg->outbound_msgaddr1) &
-			ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0 ) {
-			printk(KERN_NOTICE "arcmsr%d: hardware bus reset and return busy, =
retry=3D%d \n",
-			acb->host->host_no, retry_count);
+				if((readl(&reg->outbound_msgaddr1) & =
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0){
+					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,=20
+						retry=3D%d \n", acb->host->host_no, retry_count);
 			if(retry_count > retrycount) {
-				printk(KERN_NOTICE "arcmsr%d: hardware bus reset and return busy, =
retry aborted \n",
-				acb->host->host_no);
-			return SUCCESS;
+						acb->fw_flag =3D FW_DEADLOCK;
+						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,=20
+							RETRY TERMINATED!! \n", acb->host->host_no);
+						return FAILED;
 			}
 			retry_count++;
 			goto sleep_again;
 			}
-			acb->acb_flags &=3D ~ACB_F_FIRMWARE_TRAP;
 			acb->acb_flags |=3D ACB_F_IOP_INITED;
-			acb->acb_flags &=3D ~ACB_F_BUS_RESET;
-			printk(KERN_NOTICE "arcmsr%d: hardware bus reset and reset ok \n",
-				acb->host->host_no);
 			/* disable all outbound interrupt */
 			intmask_org=3Darcmsr_disable_outbound_ints(acb);
-				arcmsr_get_firmware_spec(acb,1);
-			/*start	background rebuild*/
+				arcmsr_get_firmware_spec(acb);
 			arcmsr_start_adapter_bgrb(acb);
 			/* clear Qbuffer if door bell ringed */
 			outbound_doorbell=3Dreadl(&reg->outbound_doorbell);
@@ -2594,42 +2570,74 @@ static int arcmsr_bus_reset(struct scsi_
 			/* enable outbound Post Queue,outbound doorbell Interrupt */
 			arcmsr_enable_outbound_ints(acb, intmask_org);
 			atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);
+				acb->fw_flag =3D FW_NORMAL;
 			init_timer(&acb->eternal_timer);
-			acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(20*HZ);
+				acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6*HZ);
 			acb->eternal_timer.data =3D (unsigned long) acb;
 			acb->eternal_timer.function =3D &arcmsr_request_device_map;
 			add_timer(&acb->eternal_timer);
-			#endif
+				acb->acb_flags &=3D ~ACB_F_BUS_RESET;
+				rtn =3D SUCCESS;
+				printk(KERN_ERR "arcmsr: scsi eh bus reset succeeds\n");
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
 		}
 		break;
+		}
 		case ACB_ADAPTER_TYPE_B: {
+			acb->acb_flags |=3D ACB_F_BUS_RESET;
+			if(arcmsr_iop_reset(acb)){
+				acb->acb_flags &=3D ~ACB_F_BUS_RESET;
+				rtn =3D FAILED;
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
 		}
+				rtn =3D SUCCESS;
 		}
 	}
-	else {
-       		 acb->acb_flags &=3D ~ACB_F_BUS_RESET;
 	}=09
-
-//	arcmsr_iop_reset(acb);
-//	acb->acb_flags &=3D ~ACB_F_BUS_RESET;
-	return SUCCESS;
+	return rtn;
 }
=20
-static void arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
+static int arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
 		struct CommandControlBlock *ccb)
 {
-	u32 intmask;
-
-	ccb->startdone =3D ARCMSR_CCB_ABORTED;
-
-	/*
-	** Wait for 3 sec for all command done.
-	*/
-	ssleep(3);
-
-	intmask =3D arcmsr_disable_outbound_ints(acb);
-	arcmsr_polling_ccbdone(acb, ccb);
-	arcmsr_enable_outbound_ints(acb, intmask);
+	int rtn;
+	spin_lock_irq(&acb->eh_lock);
+	rtn =3D arcmsr_polling_ccbdone(acb, ccb);
+	spin_unlock_irq(&acb->eh_lock);
+	return rtn;
 }
=20
 static int arcmsr_abort(struct scsi_cmnd *cmd)
@@ -2637,10 +2645,12 @@ static int arcmsr_abort(struct scsi_cmnd
 	struct AdapterControlBlock *acb =3D
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;
 	int i =3D 0;
+	int rtn =3D FAILED;
=20
 	printk(KERN_NOTICE
 		"arcmsr%d: abort device command of scsi id =3D %d lun =3D %d \n",
 		acb->host->host_no, cmd->device->id, cmd->device->lun);
+	acb->acb_flags |=3D ACB_F_ABORT;
 	acb->num_aborts++;
 	/*
 	************************************************
@@ -2649,17 +2659,20 @@ static int arcmsr_abort(struct scsi_cmnd
 	************************************************
 	*/
 	if (!atomic_read(&acb->ccboutstandingcount))
-		return SUCCESS;
+		return rtn;
=20
 	for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+		printk("%s: loop %d\n", __FUNCTION__, i);
 		struct CommandControlBlock *ccb =3D acb->pccb_pool[i];
 		if (ccb->startdone =3D=3D ARCMSR_CCB_START && ccb->pcmd =3D=3D cmd) {
-			arcmsr_abort_one_cmd(acb, ccb);
+			ccb->startdone =3D ARCMSR_CCB_ABORTED;
+			rtn =3D arcmsr_abort_one_cmd(acb, ccb);
 			break;
 		}
 	}
-
-	return SUCCESS;
+	acb->acb_flags &=3D ~ACB_F_ABORT;
+	printk("%s: leaving\n", __FUNCTION__);
+	return rtn;
 }
=20
 static const char *arcmsr_info(struct Scsi_Host *host)
@@ -2764,7 +2777,7 @@ static void arcmsr_pci_ers_need_reset_fo
 			ccb =3D acb->pccb_pool[i];
 			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {
 				ccb->startdone =3D ARCMSR_CCB_ABORTED;
-				arcmsr_ccb_complete(ccb, 1);
+				arcmsr_ccb_complete(ccb);
 			}
 		}
 		/* enable all outbound interrupt */

------=_NextPart_000_0011_01CAD7CF.21B76670--

