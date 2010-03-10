From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: [PATCH] SCSI: improve arcmsr's error handlers on lk2.6.33
Date: Wed, 10 Mar 2010 12:39:21 +0800
Message-ID: <5218DF384A2B48489336901AC84E6C09@areca4e4f859d4>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is to principally improve arcmsr's error handlers, eh_bus_reset_handler
and eh_abort_handler.
Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >
---
diff -uprN -X Documentation/dontdiff drivers/scsi/arcmsr/arcmsr_attr.c
drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr_attr.c
--- drivers/scsi/arcmsr/arcmsr_attr.c	2010-02-25 02:52:17.000000000 +0800
+++ drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr_attr.c	2008-06-13
11:02:58.000000000 +0800
@@ -189,6 +189,7 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_read",
 		.mode = S_IRUSR ,
+		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.read = arcmsr_sysfs_iop_message_read,
@@ -198,6 +199,7 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_write",
 		.mode = S_IWUSR,
+		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.write = arcmsr_sysfs_iop_message_write,
@@ -207,6 +209,7 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_clear",
 		.mode = S_IWUSR,
+		.owner = THIS_MODULE,
 	},
 	.size = 1,
 	.write = arcmsr_sysfs_iop_message_clear,
diff -uprN -X Documentation/dontdiff drivers/scsi/arcmsr/arcmsr.h
drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr.h
--- drivers/scsi/arcmsr/arcmsr.h	2010-02-25 02:52:17.000000000 +0800
+++ drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr.h	2010-02-01
12:41:34.000000000 +0800
@@ -48,16 +48,22 @@ struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
 #define ARCMSR_MAX_OUTSTANDING_CMD
256
 #define ARCMSR_MAX_FREECCB_NUM
320
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15
2008/02/27"
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15
2009/12/09"
 #define ARCMSR_SCSI_INITIATOR_ID
255
 #define ARCMSR_MAX_XFER_SECTORS
512
 #define ARCMSR_MAX_XFER_SECTORS_B
4096
+#define ARCMSR_MAX_XFER_SECTORS_C
304
 #define ARCMSR_MAX_TARGETID
17
 #define ARCMSR_MAX_TARGETLUN
8
 #define ARCMSR_MAX_CMD_PERLUN
ARCMSR_MAX_OUTSTANDING_CMD
 #define ARCMSR_MAX_QBUFFER
4096
-#define ARCMSR_MAX_SG_ENTRIES
38
+#define ARCMSR_DEFAULT_SG_ENTRIES
38
 #define ARCMSR_MAX_HBB_POSTQUEUE
264
+#define ARCMSR_MAX_XFER_LEN
0x26000 /* 152K */
+#define ARCMSR_CDB_SG_PAGE_LENGTH
256 
+#ifndef PCI_DEVICE_ID_ARECA_1880
+#define PCI_DEVICE_ID_ARECA_1880 0x1880
+ #endif
 /*
 
****************************************************************************
******
 **
@@ -66,6 +72,17 @@ struct device_attribute;
 #define ARC_SUCCESS                                                       0
 #define ARC_FAILURE                                                       1
 /*
+***************************************************************************
*******
+**
+***************************************************************************
*******
+*/
+#ifndef TRUE
+#define TRUE 1
+#endif
+#ifndef FALSE
+#define FALSE 0
+#endif
+/*
 
****************************************************************************
***
 **        split 64bits dma addressing
 
****************************************************************************
***
@@ -110,6 +127,8 @@ struct CMD_MESSAGE_FIELD
 #define FUNCTION_SAY_HELLO			0x0807
 #define FUNCTION_SAY_GOODBYE			0x0808
 #define FUNCTION_FLUSH_ADAPTER_CACHE		0x0809
+#define FUNCTION_GET_FIRMWARE_STATUS			0x080A
+#define FUNCTION_HARDWARE_RESET			0x080B
 /* ARECA IO CONTROL CODE*/
 #define ARCMSR_MESSAGE_READ_RQBUFFER       \
 	ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER
@@ -130,34 +149,28 @@ struct CMD_MESSAGE_FIELD
 #define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE \
 	ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE
 /* ARECA IOCTL ReturnCode */
-#define ARCMSR_MESSAGE_RETURNCODE_OK              0x00000001
-#define ARCMSR_MESSAGE_RETURNCODE_ERROR           0x00000006
-#define ARCMSR_MESSAGE_RETURNCODE_3F              0x0000003F
+#define ARCMSR_MESSAGE_RETURNCODE_OK		0x00000001
+#define ARCMSR_MESSAGE_RETURNCODE_ERROR		0x00000006
+#define ARCMSR_MESSAGE_RETURNCODE_3F		0x0000003F
+#define ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON	0x00000088
 /*
 *************************************************************
 **   structure for holding DMA address data
 *************************************************************
 */
+#define IS_DMA64			(sizeof(dma_addr_t) == 8)
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
@@ -184,6 +197,9 @@ struct FIRMWARE_INFO
 	char          model[8];			/*15, 60-67*/
 	char          firmware_ver[16];     	/*17, 68-83*/
 	char          device_map[16];		/*21, 84-99*/
+	uint32_t		cfgVersion;               	/*25,100-103
Added for checking of new firmware capability*/
+	uint8_t		cfgSerial[16];           	/*26,104-119*/
+	uint32_t		cfgPicStatus;
/*30,120-123*/	
 };
 /* signature of set and get firmware config */
 #define ARCMSR_SIGNATURE_GET_CONFIG		      0x87974060
@@ -210,6 +226,8 @@ struct FIRMWARE_INFO
 #define ARCMSR_CCBREPLY_FLAG_ERROR                    0x10000000
 /* outbound firmware ok */
 #define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000
+/* ARC-1680 Bus Reset*/
+#define ARCMSR_ARC1680_BUS_RESET				0x00000003
 
 /*
 ************************************************************************
@@ -261,11 +279,11 @@ struct FIRMWARE_INFO
 
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
 
****************************************************************************
***
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
@@ -287,7 +305,7 @@ struct ARCMSR_CDB
 #define ARCMSR_CDB_FLAG_HEADQ              0x08
 #define ARCMSR_CDB_FLAG_ORDEREDQ           0x10
 
-	uint8_t							Reserved1;
+	uint8_t							msgPages;
 	uint32_t						Context;
 	uint32_t						DataLength;
 	uint8_t							Cdb[16];
@@ -300,10 +318,10 @@ struct ARCMSR_CDB
 	uint8_t
SenseData[15];
 	union
 	{
-		struct SG32ENTRY
sg32entry[ARCMSR_MAX_SG_ENTRIES];
-		struct SG64ENTRY
sg64entry[ARCMSR_MAX_SG_ENTRIES];
+		struct SG32ENTRY                sg32entry[1];
+		struct SG64ENTRY                sg64entry[1];
 	} u;
-};
+}__attribute__ ((packed));
 /*
 
****************************************************************************
***
 **     Messaging Unit (MU) of the Intel R 80331 I/O processor(Type A) and
Type B processor
@@ -341,13 +359,13 @@ struct MessageUnit_B
 	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
 	uint32_t	postq_index;
 	uint32_t	doneq_index;
-	void		__iomem *drv2iop_doorbell_reg;
-	void		__iomem *drv2iop_doorbell_mask_reg;
-	void		__iomem *iop2drv_doorbell_reg;
-	void		__iomem *iop2drv_doorbell_mask_reg;
-	void		__iomem *msgcode_rwbuffer_reg;
-	void		__iomem *ioctl_wbuffer_reg;
-	void		__iomem *ioctl_rbuffer_reg;
+	uint32_t		__iomem *drv2iop_doorbell;
+	uint32_t		__iomem *drv2iop_doorbell_mask;
+	uint32_t		__iomem *iop2drv_doorbell;
+	uint32_t		__iomem *iop2drv_doorbell_mask;
+	uint32_t		__iomem *message_rwbuffer;
+	uint32_t		__iomem *message_wbuffer;
+	uint32_t		__iomem *message_rbuffer;
 };
 
 /*
@@ -367,14 +385,18 @@ struct AdapterControlBlock
 	unsigned long			vir2phy_offset;
 	/* Offset is used in making arc cdb physical to virtual calculations
*/
 	uint32_t			outbound_int_enable;
-
+	spinlock_t                      			eh_lock;
+	spinlock_t
ccblist_lock;
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
+	uint8_t                   		adapter_index;
 	#define ACB_F_SCSISTOPADAPTER         	0x0001
 	#define ACB_F_MSG_STOP_BGRB     	0x0002
 	/* stop RAID background rebuild */
@@ -390,7 +412,8 @@ struct AdapterControlBlock
 	#define ACB_F_BUS_RESET               	0x0080
 	#define ACB_F_IOP_INITED              	0x0100
 	/* iop init */
-
+	#define ACB_F_ABORT				0x0200
+	#define ACB_F_FIRMWARE_TRAP           		0x0400
 	struct CommandControlBlock *
pccb_pool[ARCMSR_MAX_FREECCB_NUM];
 	/* used for memory free */
 	struct list_head		ccb_free_list;
@@ -404,7 +427,8 @@ struct AdapterControlBlock
 	/* dma_coherent used for memory free */
 	dma_addr_t			dma_coherent_handle;
 	/* dma_coherent_handle used for memory free */
-
+	dma_addr_t				dma_coherent_handle_hbb_mu;
+	unsigned int				uncache_size;
 	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];
 	/* data collection buffer for read from 80331 */
 	int32_t				rqbuf_firstindex;
@@ -423,12 +447,23 @@ struct AdapterControlBlock
 #define ARECA_RAID_GOOD               0xaa
 	uint32_t			num_resets;
 	uint32_t			num_aborts;
+	uint32_t			signature;
 	uint32_t			firm_request_len;
 	uint32_t			firm_numbers_queue;
 	uint32_t			firm_sdram_size;
 	uint32_t			firm_hd_channels;
-	char				firm_model[12];
-	char				firm_version[20];
+	uint32_t                           	firm_cfg_version;	
+	char			firm_model[12];
+	char			firm_version[20];
+	char			device_map[20];			/*21,84-99*/
+	struct work_struct 		arcmsr_do_message_isr_bh;
+	struct timer_list		eternal_timer;
+	unsigned short		fw_flag;
+				#define	FW_NORMAL	0x0000
+				#define	FW_BOG		0x0001
+				#define	FW_DEADLOCK	0x0010
+	atomic_t 			rq_map_token;
+	atomic_t			ante_token_value;
 };/* HW_DEVICE_EXTENSION */
 /*
 
****************************************************************************
***
@@ -437,66 +472,31 @@ struct AdapterControlBlock
 
****************************************************************************
***
 */
 struct CommandControlBlock
-{
-	struct ARCMSR_CDB		arcmsr_cdb;
-	/*
-	** 0-503 (size of CDB = 504):
-	** arcmsr messenger scsi command descriptor size 504 bytes
-	*/
-	uint32_t			cdb_shifted_phyaddr;
-	/* 504-507 */
-	uint32_t			reserved1;
-	/* 508-511 */
-#if BITS_PER_LONG == 64
+{	/*x32:sizeof struct_CCB=(32+60)byte, x64:sizeof
struct_CCB=(64+60)byte*/
+	struct list_head		list;
/*x32: 8byte, x64: 16byte*/
+	struct scsi_cmnd		*pcmd;				/*8
bytes pointer of linux scsi command */
+	struct AdapterControlBlock	*acb;
/*x32: 4byte, x64: 8byte*/
+	uint32_t			shifted_cdb_phyaddr;
/*x32: 4byte, x64: 4byte*/
+	uint16_t			ccb_flags;
/*x32: 2byte, x64: 2byte*/
+	#define			CCB_FLAG_READ			0x0000
+	#define			CCB_FLAG_WRITE		0x0001
+	#define			CCB_FLAG_ERROR		0x0002
+	#define			CCB_FLAG_FLUSHCACHE		0x0004
+	#define			CCB_FLAG_MASTER_ABORTED	0x0008	
+	uint16_t                        	startdone;
/*x32:2byte,x32:2byte*/
+	#define			ARCMSR_CCB_DONE
0x0000
+	#define			ARCMSR_CCB_START		0x55AA
+	#define			ARCMSR_CCB_ABORTED		0xAA55
+	#define			ARCMSR_CCB_ILLEGAL		0xFFFF
+	#if BITS_PER_LONG == 64
 	/*  ======================512+64 bytes========================  */
-	struct list_head		list;
-	/* 512-527 16 bytes next/prev ptrs for ccb lists */
-	struct scsi_cmnd *		pcmd;
-	/* 528-535 8 bytes pointer of linux scsi command */
-	struct AdapterControlBlock *	acb;
-	/* 536-543 8 bytes pointer of acb */
-
-	uint16_t			ccb_flags;
-	/* 544-545 */
-	#define		CCB_FLAG_READ			0x0000
-	#define		CCB_FLAG_WRITE			0x0001
-	#define		CCB_FLAG_ERROR			0x0002
-	#define		CCB_FLAG_FLUSHCACHE		0x0004
-	#define		CCB_FLAG_MASTER_ABORTED		0x0008
-	uint16_t			startdone;
-	/* 546-547 */
-	#define		ARCMSR_CCB_DONE			0x0000
-	#define		ARCMSR_CCB_START		0x55AA
-	#define		ARCMSR_CCB_ABORTED		0xAA55
-	#define		ARCMSR_CCB_ILLEGAL		0xFFFF
-	uint32_t			reserved2[7];
-	/* 548-551 552-555 556-559 560-563 564-567 568-571 572-575 */
-#else
+		uint32_t                        	reserved[6];
/*24 byte*/
+	#else
 	/*  ======================512+32 bytes========================  */
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
-#endif
-	/*  ==========================================================  */
+		uint32_t                        	reserved[2];
/*8  byte*/
+	#endif
+	/*  =======================================================   */
+	struct ARCMSR_CDB		arcmsr_cdb;
 };
 /*
 
****************************************************************************
***
diff -uprN -X Documentation/dontdiff drivers/scsi/arcmsr/arcmsr_hba.c
drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr_hba.c
--- drivers/scsi/arcmsr/arcmsr_hba.c	2010-02-25 02:52:17.000000000 +0800
+++ drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr_hba.c	2010-03-10
11:52:14.000000000 +0800
@@ -70,12 +70,13 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
-
-MODULE_AUTHOR("Erich Chen <support@areca.com.tw>");
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID HOST
Adapter");
+MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");
+MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx) SATA/SAS RAID Host Bus
Adapter");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
-
+static int sleeptime = 20;
+static int retrycount = 12;
+wait_queue_head_t wait_q;
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 					struct scsi_cmnd *cmd);
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);
@@ -95,14 +96,18 @@ static u32 arcmsr_disable_outbound_ints(
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
 static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
+static void arcmsr_request_device_map(unsigned long pacb);
+static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_message_isr_bh_fn(struct work_struct *work);
+static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
+static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
+
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
-					  int queue_depth, int reason)
+								int
queue_depth)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
 		queue_depth = ARCMSR_MAX_CMD_PERLUN;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
@@ -111,18 +116,18 @@ static int arcmsr_adjust_disk_queue_dept
 
 static struct scsi_host_template arcmsr_scsi_host_template = {
 	.module			= THIS_MODULE,
-	.name			= "ARCMSR ARECA SATA/SAS RAID HOST Adapter"
-
ARCMSR_DRIVER_VERSION,
+	.name			= "ARCMSR ARECA SATA/SAS RAID Host Bus
Adapter"
+				ARCMSR_DRIVER_VERSION,
 	.info			= arcmsr_info,
 	.queuecommand		= arcmsr_queue_command,
-	.eh_abort_handler	= arcmsr_abort,
+	.eh_abort_handler		= arcmsr_abort,
 	.eh_bus_reset_handler	= arcmsr_bus_reset,
 	.bios_param		= arcmsr_bios_param,
 	.change_queue_depth	= arcmsr_adjust_disk_queue_depth,
-	.can_queue		= ARCMSR_MAX_OUTSTANDING_CMD,
-	.this_id		= ARCMSR_SCSI_INITIATOR_ID,
-	.sg_tablesize		= ARCMSR_MAX_SG_ENTRIES,
-	.max_sectors    	= ARCMSR_MAX_XFER_SECTORS,
+	.can_queue		= ARCMSR_MAX_FREECCB_NUM,
+	.this_id			= ARCMSR_SCSI_INITIATOR_ID,
+	.sg_tablesize	        	= ARCMSR_DEFAULT_SG_ENTRIES, 
+	.max_sectors    	    	= ARCMSR_MAX_XFER_SECTORS_C, 
 	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= arcmsr_host_attrs,
@@ -156,12 +161,13 @@ static struct pci_device_id arcmsr_devic
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},
 	{0, 0}, /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
 static struct pci_driver arcmsr_pci_driver = {
 	.name			= "arcmsr",
-	.id_table		= arcmsr_device_id_table,
+	.id_table			= arcmsr_device_id_table,
 	.probe			= arcmsr_probe,
 	.remove			= arcmsr_remove,
 	.shutdown		= arcmsr_shutdown,
@@ -170,15 +176,72 @@ static struct pci_driver arcmsr_pci_driv
 	#endif
 };
 
+static void arcmsr_free_mu(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A:
+			break;
+		case ACB_ADAPTER_TYPE_B:{
+			struct MessageUnit_B *reg = acb->pmuB;
+			dma_free_coherent(&acb->pdev->dev,
+				sizeof(struct MessageUnit_B),
+				reg, acb->dma_coherent_handle_hbb_mu);
+		}
+	}
+}
+
+static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)
+{
+	struct pci_dev *pdev = acb->pdev;
+
+	switch (acb->adapter_type){
+		case ACB_ADAPTER_TYPE_A:{
+			acb->pmuA = ioremap(pci_resource_start(pdev,0),
pci_resource_len(pdev,0));
+			if (!acb->pmuA) {
+				printk(KERN_NOTICE "arcmsr%d: memory mapping
region fail \n", acb->host->host_no);
+				return false;
+			}
+			break;
+		}
+		case ACB_ADAPTER_TYPE_B:{
+			void __iomem *mem_base0, *mem_base1;
+			mem_base0 = ioremap(pci_resource_start(pdev, 0),
pci_resource_len(pdev, 0));
+			if (!mem_base0) {
+				printk(KERN_NOTICE "arcmsr%d: memory mapping
region fail \n", acb->host->host_no);
+				return false;
+			}
+			mem_base1 = ioremap(pci_resource_start(pdev, 2),
pci_resource_len(pdev, 2));
+			if (!mem_base1) {
+				iounmap(mem_base0);
+				printk(KERN_NOTICE "arcmsr%d: memory mapping
region fail \n", acb->host->host_no);
+				return false;
+			}
+			acb->mem_base0 = mem_base0;
+			acb->mem_base1 = mem_base1;
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
 	struct AdapterControlBlock *acb = dev_id;
 
-	spin_lock(acb->host->host_lock);
 	handle_state = arcmsr_interrupt(acb);
-	spin_unlock(acb->host->host_lock);
-
 	return handle_state;
 }
 
@@ -215,6 +278,7 @@ static void arcmsr_define_adapter_type(s
 	struct pci_dev *pdev = acb->pdev;
 	u16 dev_id;
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
+	acb->dev_id = dev_id;
 	switch (dev_id) {
 	case 0x1201 : {
 		acb->adapter_type = ACB_ADAPTER_TYPE_B;
@@ -223,334 +287,460 @@ static void arcmsr_define_adapter_type(s
 
 	default : acb->adapter_type = ACB_ADAPTER_TYPE_A;
 	}
-}
+}	
 
-static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock
*acb)
 {
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
+	uint32_t Index;
+	uint8_t Retries = 0x00;
 
-	switch (acb->adapter_type) {
+	do {
+		for (Index = 0; Index < 100; Index++) {
+			if (readl(&reg->outbound_intstatus) &
+					ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
+				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,
+					&reg->outbound_intstatus);
+				return 0x00;
+			}
+			msleep(10);
+		}/*max 1 seconds*/
 
-	case ACB_ADAPTER_TYPE_A: {
-		struct pci_dev *pdev = acb->pdev;
-		void *dma_coherent;
-		dma_addr_t dma_coherent_handle, dma_addr;
-		struct CommandControlBlock *ccb_tmp;
-		uint32_t intmask_org;
-		int i, j;
+	} while (Retries++ < 20);/*max 20 sec*/
+	return 0xff;
+}
 
-		acb->pmuA = pci_ioremap_bar(pdev, 0);
-		if (!acb->pmuA) {
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region
fail \n",
-							acb->host->host_no);
-			return -ENOMEM;
-		}
+static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock
*acb)
+{
+	struct MessageUnit_B *reg = acb->pmuB;
+	uint32_t Index;
+	uint8_t Retries = 0x00;
 
-		dma_coherent = dma_alloc_coherent(&pdev->dev,
-			ARCMSR_MAX_FREECCB_NUM *
-			sizeof (struct CommandControlBlock) + 0x20,
-			&dma_coherent_handle, GFP_KERNEL);
+	do {
+		for (Index = 0; Index < 100; Index++) {
+			if (readl(reg->iop2drv_doorbell)
+				& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
+				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN
+					, reg->iop2drv_doorbell);
+				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
reg->drv2iop_doorbell);
+				return 0x00;
+			}
+			msleep(10);
+		}/*max 1 seconds*/
 
-		if (!dma_coherent) {
-			iounmap(acb->pmuA);
-			return -ENOMEM;
-		}
+	} while (Retries++ < 20);/*max 20 sec*/
+	return 0xff;
+}
 
-		acb->dma_coherent = dma_coherent;
-		acb->dma_coherent_handle = dma_coherent_handle;
+static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
+	int retry_count = 30;
 
-		if (((unsigned long)dma_coherent & 0x1F)) {
-			dma_coherent = dma_coherent +
-				(0x20 - ((unsigned long)dma_coherent &
0x1F));
-			dma_coherent_handle = dma_coherent_handle +
-				(0x20 - ((unsigned long)dma_coherent_handle
& 0x1F));
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
+	do {
+		if (!arcmsr_hba_wait_msgint_ready(acb))
+			break;
+		else {
+			retry_count--;
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' \
+			timeout, retry count down = %d \n",
acb->host->host_no, retry_count);
 		}
+	} while (retry_count != 0);
+}
 
-		dma_addr = dma_coherent_handle;
-		ccb_tmp = (struct CommandControlBlock *)dma_coherent;
-		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-			ccb_tmp->cdb_shifted_phyaddr = dma_addr >> 5;
-			ccb_tmp->acb = acb;
-			acb->pccb_pool[i] = ccb_tmp;
-			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
-			dma_addr = dma_addr + sizeof(struct
CommandControlBlock);
-			ccb_tmp++;
+static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_B *reg = acb->pmuB;
+	int retry_count = 30;
+
+	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);
+	do {
+		if (!arcmsr_hbb_wait_msgint_ready(acb))
+			break;
+		else {
+			retry_count--;
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' \
+			timeout,retry count down = %d \n",
acb->host->host_no, retry_count);
 		}
+	} while (retry_count != 0);
+}
 
-		acb->vir2phy_offset = (unsigned long)ccb_tmp -(unsigned
long)dma_addr;
-		for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
-			for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
-				acb->devstate[i][j] = ARECA_RAID_GONE;
+static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
 
-		/*
-		** here we need to tell iop 331 our ccb_tmp.HighPart
-		** if ccb_tmp.HighPart is not zero
-		*/
-		intmask_org = arcmsr_disable_outbound_ints(acb);
+	case ACB_ADAPTER_TYPE_A: {
+		arcmsr_flush_hba_cache(acb);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
+		arcmsr_flush_hbb_cache(acb);
+		}
+	}
+}
 
-		struct pci_dev *pdev = acb->pdev;
-		struct MessageUnit_B *reg;
-		void __iomem *mem_base0, *mem_base1;
-		void *dma_coherent;
-		dma_addr_t dma_coherent_handle, dma_addr;
-		uint32_t intmask_org;
-		struct CommandControlBlock *ccb_tmp;
-		int i, j;
+static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
+{
+	struct pci_dev *pdev = acb->pdev;
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A: {
 
-		dma_coherent = dma_alloc_coherent(&pdev->dev,
-			((ARCMSR_MAX_FREECCB_NUM *
-			sizeof(struct CommandControlBlock) + 0x20) +
-			sizeof(struct MessageUnit_B)),
-			&dma_coherent_handle, GFP_KERNEL);
-		if (!dma_coherent)
-			return -ENOMEM;
-
-		acb->dma_coherent = dma_coherent;
-		acb->dma_coherent_handle = dma_coherent_handle;
-
-		if (((unsigned long)dma_coherent & 0x1F)) {
-			dma_coherent = dma_coherent +
-				(0x20 - ((unsigned long)dma_coherent &
0x1F));
-			dma_coherent_handle = dma_coherent_handle +
-				(0x20 - ((unsigned long)dma_coherent_handle
& 0x1F));
+			void *dma_coherent;
+			dma_addr_t dma_coherent_handle;
+			struct CommandControlBlock *ccb_tmp;
+			int i = 0, j = 0;
+			dma_addr_t cdb_phyaddr;
+			unsigned long roundup_ccbsize = 0;
+			unsigned long max_xfer_len;
+			unsigned long max_sg_entrys;
+			uint32_t  firm_config_version;
+
+			for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
+				for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
+					acb->devstate[i][j] =
ARECA_RAID_GONE;
+
+			max_xfer_len = ARCMSR_MAX_XFER_LEN;
+			max_sg_entrys = ARCMSR_DEFAULT_SG_ENTRIES;
+			firm_config_version = acb->firm_cfg_version;
+			if((firm_config_version & 0xFF) >= 3){
+				max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<
((firm_config_version >> 8) & 0xFF)) * 1024;/* max 16M byte */
+				max_sg_entrys = (max_xfer_len/4096);	
+			}
+			acb->host->max_sectors = max_xfer_len/512;
+			acb->host->sg_tablesize = max_sg_entrys;
+			roundup_ccbsize = roundup(sizeof(struct
CommandControlBlock) + max_sg_entrys * sizeof(struct SG64ENTRY), 32);
+			acb->uncache_size = roundup_ccbsize *
ARCMSR_MAX_FREECCB_NUM;
+			dma_coherent = dma_alloc_coherent(&pdev->dev,
acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
+			if (!dma_coherent) {
+				printk("arcmsr%d: dma_alloc_coherent got
error \n", acb->host->host_no);
+				return -ENOMEM;
+			}
+			memset(dma_coherent, 0, acb->uncache_size);
+			acb->dma_coherent = dma_coherent;
+			acb->dma_coherent_handle = dma_coherent_handle;
+			ccb_tmp = (struct CommandControlBlock
*)dma_coherent;
+			acb->vir2phy_offset = (unsigned long)dma_coherent -
(unsigned long)dma_coherent_handle;
+			for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
+				cdb_phyaddr = dma_coherent_handle +
offsetof(struct CommandControlBlock, arcmsr_cdb);
+				ccb_tmp->shifted_cdb_phyaddr = cdb_phyaddr
>> 5;
+				acb->pccb_pool[i] = ccb_tmp;
+				ccb_tmp->acb = acb;
+				INIT_LIST_HEAD(&ccb_tmp->list);
+				list_add_tail(&ccb_tmp->list,
&acb->ccb_free_list);
+				ccb_tmp = (struct CommandControlBlock
*)((unsigned long)ccb_tmp + roundup_ccbsize);
+				dma_coherent_handle = dma_coherent_handle +
roundup_ccbsize;
+			}
+			break;
 		}
+		case ACB_ADAPTER_TYPE_B: {
 
-		dma_addr = dma_coherent_handle;
-		ccb_tmp = (struct CommandControlBlock *)dma_coherent;
-		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-			ccb_tmp->cdb_shifted_phyaddr = dma_addr >> 5;
-			ccb_tmp->acb = acb;
-			acb->pccb_pool[i] = ccb_tmp;
-			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
-			dma_addr = dma_addr + sizeof(struct
CommandControlBlock);
-			ccb_tmp++;
-		}
-
-		reg = (struct MessageUnit_B *)(dma_coherent +
-		ARCMSR_MAX_FREECCB_NUM * sizeof(struct
CommandControlBlock));
-		acb->pmuB = reg;
-		mem_base0 = pci_ioremap_bar(pdev, 0);
-		if (!mem_base0)
-			goto out;
-
-		mem_base1 = pci_ioremap_bar(pdev, 2);
-		if (!mem_base1) {
-			iounmap(mem_base0);
-			goto out;
-		}
-
-		reg->drv2iop_doorbell_reg = mem_base0 +
ARCMSR_DRV2IOP_DOORBELL;
-		reg->drv2iop_doorbell_mask_reg = mem_base0 +
-
ARCMSR_DRV2IOP_DOORBELL_MASK;
-		reg->iop2drv_doorbell_reg = mem_base0 +
ARCMSR_IOP2DRV_DOORBELL;
-		reg->iop2drv_doorbell_mask_reg = mem_base0 +
-
ARCMSR_IOP2DRV_DOORBELL_MASK;
-		reg->ioctl_wbuffer_reg = mem_base1 + ARCMSR_IOCTL_WBUFFER;
-		reg->ioctl_rbuffer_reg = mem_base1 + ARCMSR_IOCTL_RBUFFER;
-		reg->msgcode_rwbuffer_reg = mem_base1 +
ARCMSR_MSGCODE_RWBUFFER;
-
-		acb->vir2phy_offset = (unsigned long)ccb_tmp -(unsigned
long)dma_addr;
-		for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
-			for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
-				acb->devstate[i][j] = ARECA_RAID_GOOD;
-
-		/*
-		** here we need to tell iop 331 our ccb_tmp.HighPart
-		** if ccb_tmp.HighPart is not zero
-		*/
-		intmask_org = arcmsr_disable_outbound_ints(acb);
+			void *dma_coherent;
+			dma_addr_t dma_coherent_handle;
+			struct CommandControlBlock *ccb_tmp;
+			uint32_t cdb_phyaddr;
+			unsigned int roundup_ccbsize = 0;
+			unsigned long max_xfer_len;
+			unsigned long max_sg_entrys;
+			unsigned long firm_config_version;
+			unsigned long max_freeccb_num=0;
+			int i = 0, j = 0;
+
+			max_freeccb_num = ARCMSR_MAX_FREECCB_NUM;
+			max_xfer_len = ARCMSR_MAX_XFER_LEN;
+			max_sg_entrys = ARCMSR_DEFAULT_SG_ENTRIES;
+			firm_config_version = acb->firm_cfg_version;
+			if((firm_config_version & 0xFF) >= 3){
+				max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<

+						((firm_config_version >> 8)
& 0xFF)) * 1024;/* max 16M byte */
+				max_sg_entrys = (max_xfer_len/4096);/* max
4097 sg entry*/
+			}
+			acb->host->max_sectors = max_xfer_len / 512;
+			acb->host->sg_tablesize = max_sg_entrys;
+			roundup_ccbsize = roundup(sizeof(struct
CommandControlBlock)+
+				(max_sg_entrys - 1) * sizeof(struct
SG64ENTRY), 32);
+			acb->uncache_size = roundup_ccbsize *
ARCMSR_MAX_FREECCB_NUM;
+			dma_coherent =
dma_alloc_coherent(&pdev->dev,acb->uncache_size,
+				&dma_coherent_handle, GFP_KERNEL);
+
+			if (!dma_coherent) {
+				printk(KERN_NOTICE "DMA allocation
failed...........................\n");
+				return -ENOMEM;
+			}
+			memset(dma_coherent, 0, acb->uncache_size);
+			acb->dma_coherent = dma_coherent;
+			acb->dma_coherent_handle = dma_coherent_handle;
+			ccb_tmp = (struct CommandControlBlock
*)dma_coherent;
+			acb->vir2phy_offset = (unsigned long)dma_coherent -
+					(unsigned long)dma_coherent_handle;
+			for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
+				cdb_phyaddr = dma_coherent_handle +
+					offsetof(struct CommandControlBlock,
arcmsr_cdb);
+				ccb_tmp->shifted_cdb_phyaddr = cdb_phyaddr
>> 5;
+				acb->pccb_pool[i] = ccb_tmp;
+				ccb_tmp->acb = acb;
+				INIT_LIST_HEAD(&ccb_tmp->list);
+				list_add_tail(&ccb_tmp->list,
&acb->ccb_free_list);
+				ccb_tmp = (struct CommandControlBlock
*)((unsigned long)ccb_tmp +
+
roundup_ccbsize);
+				dma_coherent_handle = dma_coherent_handle +
roundup_ccbsize;
+			}
+			for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
+				for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
+					acb->devstate[i][j] =
ARECA_RAID_GONE;
 		}
 		break;
 	}
 	return 0;
+}
+static void arcmsr_message_isr_bh_fn(struct work_struct *work) 
+{
+	struct AdapterControlBlock *acb = container_of(work,struct
AdapterControlBlock, arcmsr_do_message_isr_bh);
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A: {
+
+			struct MessageUnit_A __iomem *reg  = acb->pmuA;
+			char *acb_dev_map = (char *)acb->device_map;
+			uint32_t __iomem *signature = (uint32_t __iomem*)
(&reg->message_rwbuffer[0]);
+			char __iomem *devicemap = (char __iomem*)
(&reg->message_rwbuffer[21]);
+			int target, lun;
+			struct scsi_device *psdev;
+			char diff;
+
+			atomic_inc(&acb->rq_map_token);
+			if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG)
{
+				for(target = 0; target < ARCMSR_MAX_TARGETID
-1; target++) {
+					diff =
(*acb_dev_map)^readb(devicemap);
+					if (diff != 0) {
+						char temp;
+						*acb_dev_map =
readb(devicemap);
+						temp =*acb_dev_map;
+						for(lun = 0; lun <
ARCMSR_MAX_TARGETLUN; lun++) {
+							if((temp & 0x01)==1
&& (diff & 0x01) == 1) {	
+
scsi_add_device(acb->host, 0, target, lun);
+							}else if((temp &
0x01) == 0 && (diff & 0x01) == 1) {
+								psdev =
scsi_device_lookup(acb->host, 0, target, lun);
+								if (psdev !=
NULL ) {
+
scsi_remove_device(psdev);
+
scsi_device_put(psdev);
+								}
+							}
+							temp >>= 1;
+							diff >>= 1;
+						}
+					}
+					devicemap++;
+					acb_dev_map++;
+				}
+			}
+			break;
+		}
 
-out:
-	dma_free_coherent(&acb->pdev->dev,
-		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock)
+ 0x20 +
-		sizeof(struct MessageUnit_B)), acb->dma_coherent,
acb->dma_coherent_handle);
-	return -ENOMEM;
+		case ACB_ADAPTER_TYPE_B: {
+			struct MessageUnit_B *reg  = acb->pmuB;
+			char *acb_dev_map = (char *)acb->device_map;
+			uint32_t __iomem *signature = (uint32_t
__iomem*)(&reg->message_rwbuffer[0]);
+			char __iomem *devicemap = (char
__iomem*)(&reg->message_rwbuffer[21]);
+			int target, lun;
+			struct scsi_device *psdev;
+			char diff;
+
+			atomic_inc(&acb->rq_map_token);
+			if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG)
{
+				for(target = 0; target < ARCMSR_MAX_TARGETID
-1; target++) {
+					diff =
(*acb_dev_map)^readb(devicemap);
+					if (diff != 0) {
+						char temp;
+						*acb_dev_map =
readb(devicemap);
+						temp =*acb_dev_map;
+						for(lun = 0; lun <
ARCMSR_MAX_TARGETLUN; lun++) {
+							if((temp & 0x01)==1
&& (diff & 0x01) == 1) {	
+
scsi_add_device(acb->host, 0, target, lun);
+							}else if((temp &
0x01) == 0 && (diff & 0x01) == 1) {
+								psdev =
scsi_device_lookup(acb->host, 0, target, lun);
+								if (psdev !=
NULL ) {
+
scsi_remove_device(psdev);
+
scsi_device_put(psdev);
+								}
+							}
+							temp >>= 1;
+							diff >>= 1;
+						}
+					}
+					devicemap++;
+					acb_dev_map++;
+				}
+			}
+		}
+	}
 }
 
-static int arcmsr_probe(struct pci_dev *pdev,
-	const struct pci_device_id *id)
+static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id
*id)
 {
 	struct Scsi_Host *host;
 	struct AdapterControlBlock *acb;
-	uint8_t bus, dev_fun;
+	uint8_t bus,dev_fun;
 	int error;
 
 	error = pci_enable_device(pdev);
-	if (error)
-		goto out;
-	pci_set_master(pdev);
-
-	host = scsi_host_alloc(&arcmsr_scsi_host_template,
-			sizeof(struct AdapterControlBlock));
-	if (!host) {
-		error = -ENOMEM;
-		goto out_disable_device;
-	}
-	acb = (struct AdapterControlBlock *)host->hostdata;
-	memset(acb, 0, sizeof (struct AdapterControlBlock));
-
-	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (error) {
-		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (error) {
+	if(error){
+		return -ENODEV;
+	}
+	host = scsi_host_alloc(&arcmsr_scsi_host_template, sizeof(struct
AdapterControlBlock));
+	if(!host){
+    		goto pci_disable_dev;
+	}
+	error = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	if(error){
+		error = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		if(error){
 			printk(KERN_WARNING
 			       "scsi%d: No suitable DMA mask available\n",
 			       host->host_no);
-			goto out_host_put;
+			goto scsi_host_release;
 		}
 	}
+	init_waitqueue_head(&wait_q);
 	bus = pdev->bus->number;
 	dev_fun = pdev->devfn;
-	acb->host = host;
+	acb = (struct AdapterControlBlock *) host->hostdata;
+	memset(acb,0,sizeof(struct AdapterControlBlock));
 	acb->pdev = pdev;
-	host->max_sectors = ARCMSR_MAX_XFER_SECTORS;
+	acb->host = host;
 	host->max_lun = ARCMSR_MAX_TARGETLUN;
-	host->max_id = ARCMSR_MAX_TARGETID;/*16:8*/
-	host->max_cmd_len = 16;    /*this is issue of 64bit LBA, over 2T
byte*/
-	host->sg_tablesize = ARCMSR_MAX_SG_ENTRIES;
-	host->can_queue = ARCMSR_MAX_FREECCB_NUM; /* max simultaneous cmds
*/
-	host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;
+	host->max_id = ARCMSR_MAX_TARGETID;		/*16:8*/
+	host->max_cmd_len = 16;	 			/*this is issue of
64bit LBA ,over 2T byte*/
+	host->can_queue = ARCMSR_MAX_FREECCB_NUM;	/* max simultaneous
cmds */		
+	host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;	    
 	host->this_id = ARCMSR_SCSI_INITIATOR_ID;
 	host->unique_id = (bus << 8) | dev_fun;
-	host->irq = pdev->irq;
+	pci_set_drvdata(pdev, host);
+	pci_set_master(pdev);
 	error = pci_request_regions(pdev, "arcmsr");
-	if (error) {
-		goto out_host_put;
+	if(error){
+		goto scsi_host_release;
 	}
-	arcmsr_define_adapter_type(acb);
-
+	spin_lock_init(&acb->eh_lock);
+	spin_lock_init(&acb->ccblist_lock);
 	acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
-			   ACB_F_MESSAGE_RQBUFFER_CLEARED |
-			   ACB_F_MESSAGE_WQBUFFER_READED);
+			ACB_F_MESSAGE_RQBUFFER_CLEARED |
+			ACB_F_MESSAGE_WQBUFFER_READED);
 	acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
 	INIT_LIST_HEAD(&acb->ccb_free_list);
-
+	arcmsr_define_adapter_type(acb);
+	error = arcmsr_remap_pciregion(acb);
+	if(!error){
+		goto pci_release_regs;
+	}
+	error = arcmsr_get_firmware_spec(acb);
+	if(!error){
+		goto unmap_pci_region;
+	}
 	error = arcmsr_alloc_ccb_pool(acb);
-	if (error)
-		goto out_release_regions;
-
-	error = request_irq(pdev->irq, arcmsr_do_interrupt,
-			    IRQF_SHARED, "arcmsr", acb);
-	if (error)
-		goto out_free_ccb_pool;
-
+	if(error){
+		goto free_hbb_mu;
+	}
 	arcmsr_iop_init(acb);
-	pci_set_drvdata(pdev, host);
-	if (strncmp(acb->firm_version, "V1.42", 5) >= 0)
-		host->max_sectors= ARCMSR_MAX_XFER_SECTORS_B;
-
 	error = scsi_add_host(host, &pdev->dev);
-	if (error)
-		goto out_free_irq;
-
-	error = arcmsr_alloc_sysfs_attr(acb);
-	if (error)
-		goto out_free_sysfs;
-
-	scsi_scan_host(host);
+	if(error){
+		goto RAID_controller_stop;
+	}
+	error = request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED,
"arcmsr", acb);
+	if(error){
+		goto scsi_host_remove;
+	}
+	host->irq = pdev->irq;
+    	scsi_scan_host(host);
+	INIT_WORK (&acb->arcmsr_do_message_isr_bh,
arcmsr_message_isr_bh_fn);
+	atomic_set(&acb->rq_map_token, 16);
+	atomic_set(&acb->ante_token_value, 16);
+	acb->fw_flag = FW_NORMAL;
+	init_timer(&acb->eternal_timer);
+	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
+	acb->eternal_timer.data = (unsigned long) acb;
+	acb->eternal_timer.function = &arcmsr_request_device_map;
+	add_timer(&acb->eternal_timer);
 	#ifdef CONFIG_SCSI_ARCMSR_AER
-	pci_enable_pcie_error_reporting(pdev);
+		pci_enable_pcie_error_reporting(pdev);
 	#endif
+	if(arcmsr_alloc_sysfs_attr(acb))
+		goto out_free_sysfs;
 	return 0;
- out_free_sysfs:
- out_free_irq:
-	free_irq(pdev->irq, acb);
- out_free_ccb_pool:
-	arcmsr_free_ccb_pool(acb);
- out_release_regions:
-	pci_release_regions(pdev);
- out_host_put:
-	scsi_host_put(host);
- out_disable_device:
-	pci_disable_device(pdev);
- out:
-	return error;
-}
-
-static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock
*acb)
-{
-	struct MessageUnit_A __iomem *reg = acb->pmuA;
-	uint32_t Index;
-	uint8_t Retries = 0x00;
-
-	do {
-		for (Index = 0; Index < 100; Index++) {
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
-static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock
*acb)
-{
-	struct MessageUnit_B *reg = acb->pmuB;
-	uint32_t Index;
-	uint8_t Retries = 0x00;
-
-	do {
-		for (Index = 0; Index < 100; Index++) {
-			if (readl(reg->iop2drv_doorbell_reg)
-				& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
-				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN
-					, reg->iop2drv_doorbell_reg);
-				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
reg->drv2iop_doorbell_reg);
-				return 0x00;
-			}
-			msleep(10);
-		}/*max 1 seconds*/
-
-	} while (Retries++ < 20);/*max 20 sec*/
-	return 0xff;
+	out_free_sysfs:
+	scsi_host_remove:
+		scsi_remove_host(host);
+	RAID_controller_stop:
+		arcmsr_stop_adapter_bgrb(acb);
+		arcmsr_flush_adapter_cache(acb);
+		arcmsr_free_ccb_pool(acb);
+	free_hbb_mu:
+		arcmsr_free_mu(acb);
+	unmap_pci_region:
+		arcmsr_unmap_pciregion(acb);
+	pci_release_regs:
+		pci_release_regions(pdev);
+	scsi_host_release:
+		scsi_host_put(host);
+	pci_disable_dev:
+		pci_disable_device(pdev);
+	return -ENODEV;
 }
 
-static void arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
-	if (arcmsr_hba_wait_msgint_ready(acb))
+	if (arcmsr_hba_wait_msgint_ready(acb)){
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command'
timeout \n"
 			, acb->host->host_no);
+		return 0xff;
+	}
+	return 0x00;
 }
 
-static void arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 
-	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell_reg);
-	if (arcmsr_hbb_wait_msgint_ready(acb))
+	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);
+	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command'
timeout \n"
 			, acb->host->host_no);
+		return 0xff;
+	}
+	return 0x00;
 }
 
-static void arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 {
+	uint8_t rtnval = 0;
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_abort_hba_allcmd(acb);
+		rtnval = arcmsr_abort_hba_allcmd(acb);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_abort_hbb_allcmd(acb);
+		rtnval = arcmsr_abort_hbb_allcmd(acb);
 		}
 	}
+	return rtnval;
+}
+
+static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)
+{
+	struct MessageUnit_B *reg = pacb->pmuB;
+
+	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
+	if(arcmsr_hbb_wait_msgint_ready(pacb)){
+		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n",
pacb->host->host_no);
+		return false;
+	}
+    	return true;
 }
 
 static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
@@ -560,69 +750,22 @@ static void arcmsr_pci_unmap_dma(struct 
 	scsi_dma_unmap(pcmd);
 }
 
-static void arcmsr_ccb_complete(struct CommandControlBlock *ccb, int
stand_flag)
+static void arcmsr_ccb_complete(struct CommandControlBlock *ccb)
 {
 	struct AdapterControlBlock *acb = ccb->acb;
 	struct scsi_cmnd *pcmd = ccb->pcmd;
+	unsigned long flags;
 
+	atomic_dec(&acb->ccboutstandingcount);
 	arcmsr_pci_unmap_dma(ccb);
-	if (stand_flag == 1)
-		atomic_dec(&acb->ccboutstandingcount);
 	ccb->startdone = ARCMSR_CCB_DONE;
 	ccb->ccb_flags = 0;
+	spin_lock_irqsave(&acb->ccblist_lock, flags);
 	list_add_tail(&ccb->list, &acb->ccb_free_list);
+	spin_unlock_irqrestore(&acb->ccblist_lock, flags);
 	pcmd->scsi_done(pcmd);
 }
 
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
-{
-	struct MessageUnit_A __iomem *reg = acb->pmuA;
-	int retry_count = 30;
-
-	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
-	do {
-		if (!arcmsr_hba_wait_msgint_ready(acb))
-			break;
-		else {
-			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' \
-			timeout, retry count down = %d \n",
acb->host->host_no, retry_count);
-		}
-	} while (retry_count != 0);
-}
-
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
-{
-	struct MessageUnit_B *reg = acb->pmuB;
-	int retry_count = 30;
-
-	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell_reg);
-	do {
-		if (!arcmsr_hbb_wait_msgint_ready(acb))
-			break;
-		else {
-			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' \
-			timeout,retry count down = %d \n",
acb->host->host_no, retry_count);
-		}
-	} while (retry_count != 0);
-}
-
-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
-{
-	switch (acb->adapter_type) {
-
-	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_flush_hba_cache(acb);
-		}
-		break;
-
-	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_flush_hbb_cache(acb);
-		}
-	}
-}
-
 static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 {
 
@@ -648,8 +791,7 @@ static u32 arcmsr_disable_outbound_ints(
 
 	case ACB_ADAPTER_TYPE_A : {
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
-		orig_mask = readl(&reg->outbound_intmask)|\
-				ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE;
+		orig_mask = readl(&reg->outbound_intmask);
 		writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \
 						&reg->outbound_intmask);
 		}
@@ -657,16 +799,15 @@ static u32 arcmsr_disable_outbound_ints(
 
 	case ACB_ADAPTER_TYPE_B : {
 		struct MessageUnit_B *reg = acb->pmuB;
-		orig_mask = readl(reg->iop2drv_doorbell_mask_reg) & \
-					(~ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);
-		writel(0, reg->iop2drv_doorbell_mask_reg);
+		orig_mask = readl(reg->iop2drv_doorbell_mask);
+		writel(0, reg->iop2drv_doorbell_mask);
 		}
 		break;
 	}
 	return orig_mask;
 }
 
-static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb, \
+static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb, 
 			struct CommandControlBlock *ccb, uint32_t flag_ccb)
 {
 
@@ -677,13 +818,13 @@ static void arcmsr_report_ccb_state(stru
 		if (acb->devstate[id][lun] == ARECA_RAID_GONE)
 			acb->devstate[id][lun] = ARECA_RAID_GOOD;
 			ccb->pcmd->result = DID_OK << 16;
-			arcmsr_ccb_complete(ccb, 1);
+			arcmsr_ccb_complete(ccb);
 	} else {
 		switch (ccb->arcmsr_cdb.DeviceStatus) {
 		case ARCMSR_DEV_SELECT_TIMEOUT: {
 			acb->devstate[id][lun] = ARECA_RAID_GONE;
 			ccb->pcmd->result = DID_NO_CONNECT << 16;
-			arcmsr_ccb_complete(ccb, 1);
+			arcmsr_ccb_complete(ccb);
 			}
 			break;
 
@@ -692,14 +833,14 @@ static void arcmsr_report_ccb_state(stru
 		case ARCMSR_DEV_INIT_FAIL: {
 			acb->devstate[id][lun] = ARECA_RAID_GONE;
 			ccb->pcmd->result = DID_BAD_TARGET << 16;
-			arcmsr_ccb_complete(ccb, 1);
+			arcmsr_ccb_complete(ccb);
 			}
 			break;
 
 		case ARCMSR_DEV_CHECK_CONDITION: {
 			acb->devstate[id][lun] = ARECA_RAID_GOOD;
 			arcmsr_report_sense_info(ccb);
-			arcmsr_ccb_complete(ccb, 1);
+			arcmsr_ccb_complete(ccb);
 			}
 			break;
 
@@ -714,7 +855,7 @@ static void arcmsr_report_ccb_state(stru
 					, ccb->arcmsr_cdb.DeviceStatus);
 					acb->devstate[id][lun] =
ARECA_RAID_GONE;
 					ccb->pcmd->result = DID_NO_CONNECT
<< 16;
-					arcmsr_ccb_complete(ccb, 1);
+					arcmsr_ccb_complete(ccb);
 			break;
 		}
 	}
@@ -724,14 +865,19 @@ static void arcmsr_drain_donequeue(struc
 
 {
 	struct CommandControlBlock *ccb;
+	struct ARCMSR_CDB *arcmsr_cdb;
+	int id, lun;
 
-	ccb = (struct CommandControlBlock *)(acb->vir2phy_offset + (flag_ccb
<< 5));
+	arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb
<< 5));
+	ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
arcmsr_cdb);
 	if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
 		if (ccb->startdone == ARCMSR_CCB_ABORTED) {
 			struct scsi_cmnd *abortcmd = ccb->pcmd;
 			if (abortcmd) {
+				id = abortcmd->device->id;
+				lun = abortcmd->device->lun;

 				abortcmd->result |= DID_ABORT << 16;
-				arcmsr_ccb_complete(ccb, 1);
+				arcmsr_ccb_complete(ccb);
 				printk(KERN_NOTICE "arcmsr%d: ccb ='0x%p' \
 				isr got aborted command \n",
acb->host->host_no, ccb);
 			}
@@ -794,16 +940,18 @@ static void arcmsr_remove(struct pci_dev
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *) host->hostdata;
 	int poll_count = 0;
-
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
-	arcmsr_stop_adapter_bgrb(acb);
-	arcmsr_flush_adapter_cache(acb);
+	scsi_host_put(host);
+	flush_scheduled_work();
+	del_timer_sync(&acb->eternal_timer);
 	arcmsr_disable_outbound_ints(acb);
+	arcmsr_stop_adapter_bgrb(acb);
+	arcmsr_flush_adapter_cache(acb);	
 	acb->acb_flags |= ACB_F_SCSISTOPADAPTER;
 	acb->acb_flags &= ~ACB_F_IOP_INITED;
 
-	for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;
poll_count++) {
+	for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;
poll_count++){
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
 		arcmsr_interrupt(acb);/* FIXME: need spinlock */
@@ -820,17 +968,14 @@ static void arcmsr_remove(struct pci_dev
 			if (ccb->startdone == ARCMSR_CCB_START) {
 				ccb->startdone = ARCMSR_CCB_ABORTED;
 				ccb->pcmd->result = DID_ABORT << 16;
-				arcmsr_ccb_complete(ccb, 1);
+				arcmsr_ccb_complete(ccb);
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
@@ -840,7 +985,9 @@ static void arcmsr_shutdown(struct pci_d
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)host->hostdata;
-
+	del_timer_sync(&acb->eternal_timer);
+	arcmsr_disable_outbound_ints(acb);
+	flush_scheduled_work();
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
 }
@@ -860,7 +1007,7 @@ static void arcmsr_module_exit(void)
 module_init(arcmsr_module_init);
 module_exit(arcmsr_module_exit);
 
-static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb, \
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
 						u32 intmask_org)
 {
 	u32 mask;
@@ -870,7 +1017,8 @@ static void arcmsr_enable_outbound_ints(
 	case ACB_ADAPTER_TYPE_A : {
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		mask = intmask_org &
~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
-			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
+			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE|
+			     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);
 		writel(mask, &reg->outbound_intmask);
 		acb->outbound_int_enable = ~(intmask_org & mask) &
0x000000ff;
 		}
@@ -878,9 +1026,11 @@ static void arcmsr_enable_outbound_ints(
 
 	case ACB_ADAPTER_TYPE_B : {
 		struct MessageUnit_B *reg = acb->pmuB;
-		mask = intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK | \
-			ARCMSR_IOP2DRV_DATA_READ_OK |
ARCMSR_IOP2DRV_CDB_DONE);
-		writel(mask, reg->iop2drv_doorbell_mask_reg);
+		mask = intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK |
+			ARCMSR_IOP2DRV_DATA_READ_OK |
+			ARCMSR_IOP2DRV_CDB_DONE |
+			ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);
+		writel(mask, reg->iop2drv_doorbell_mask);
 		acb->outbound_int_enable = (intmask_org | mask) &
0x0000000f;
 		}
 	}
@@ -893,6 +1043,9 @@ static int arcmsr_build_ccb(struct Adapt
 	int8_t *psge = (int8_t *)&arcmsr_cdb->u;
 	__le32 address_lo, address_hi;
 	int arccdbsize = 0x30;
+	__le32 length = 0;
+	int i, cdb_sgcount = 0;
+	struct scatterlist *sg;
 	int nseg;
 
 	ccb->pcmd = pcmd;
@@ -902,49 +1055,42 @@ static int arcmsr_build_ccb(struct Adapt
 	arcmsr_cdb->LUN = pcmd->device->lun;
 	arcmsr_cdb->Function = 1;
 	arcmsr_cdb->CdbLength = (uint8_t)pcmd->cmd_len;
-	arcmsr_cdb->Context = (unsigned long)arcmsr_cdb;
+	arcmsr_cdb->Context = 0;
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
 
 	nseg = scsi_dma_map(pcmd);
-	if (nseg > ARCMSR_MAX_SG_ENTRIES)
+	if(nseg > acb->host->sg_tablesize || nseg < 0)
 		return FAILED;
-	BUG_ON(nseg < 0);
-
-	if (nseg) {
-		__le32 length;
-		int i, cdb_sgcount = 0;
-		struct scatterlist *sg;
-
-		/* map stor port SG list to our iop SG List. */
-		scsi_for_each_sg(pcmd, sg, nseg, i) {
-			/* Get the physical address of the current data
pointer */
-			length = cpu_to_le32(sg_dma_len(sg));
-			address_lo =
cpu_to_le32(dma_addr_lo32(sg_dma_address(sg)));
-			address_hi =
cpu_to_le32(dma_addr_hi32(sg_dma_address(sg)));
-			if (address_hi == 0) {
-				struct SG32ENTRY *pdma_sg = (struct
SG32ENTRY *)psge;
-
-				pdma_sg->address = address_lo;
-				pdma_sg->length = length;
-				psge += sizeof (struct SG32ENTRY);
-				arccdbsize += sizeof (struct SG32ENTRY);
-			} else {
-				struct SG64ENTRY *pdma_sg = (struct
SG64ENTRY *)psge;
+	/* map stor port SG list to our iop SG List. */
+	scsi_for_each_sg(pcmd, sg, nseg, i) {
+		/* Get the physical address of the current data pointer */
+		length = cpu_to_le32(sg_dma_len(sg));
+		address_lo = cpu_to_le32(dma_addr_lo32(sg_dma_address(sg)));
+		address_hi = cpu_to_le32(dma_addr_hi32(sg_dma_address(sg)));
+		if (address_hi == 0) {
+			struct SG32ENTRY *pdma_sg = (struct SG32ENTRY
*)psge;
+
+			pdma_sg->address = address_lo;
+			pdma_sg->length = length;
+			psge += sizeof (struct SG32ENTRY);
+			arccdbsize += sizeof (struct SG32ENTRY);
+		} else {
+			struct SG64ENTRY *pdma_sg = (struct SG64ENTRY
*)psge;
 
-				pdma_sg->addresshigh = address_hi;
-				pdma_sg->address = address_lo;
-				pdma_sg->length =
length|cpu_to_le32(IS_SG64_ADDR);
-				psge += sizeof (struct SG64ENTRY);
-				arccdbsize += sizeof (struct SG64ENTRY);
-			}
-			cdb_sgcount++;
-		}
-		arcmsr_cdb->sgcount = (uint8_t)cdb_sgcount;
-		arcmsr_cdb->DataLength = scsi_bufflen(pcmd);
-		if ( arccdbsize > 256)
-			arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
-	}
-	if (pcmd->sc_data_direction == DMA_TO_DEVICE ) {
+			pdma_sg->addresshigh = address_hi;
+			pdma_sg->address = address_lo;
+			pdma_sg->length = length|cpu_to_le32(IS_SG64_ADDR);
+			psge += sizeof (struct SG64ENTRY);
+			arccdbsize += sizeof (struct SG64ENTRY);
+		}
+		cdb_sgcount++;
+	}
+	arcmsr_cdb->sgcount = (uint8_t)cdb_sgcount;
+	arcmsr_cdb->DataLength = scsi_bufflen(pcmd);
+	arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 :
0);
+	if ( arccdbsize > 256)
+		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
+	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 ||
pcmd->cmnd[0]|WRITE_12 ){
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
 		ccb->ccb_flags |= CCB_FLAG_WRITE;
 	}
@@ -953,7 +1099,7 @@ static int arcmsr_build_ccb(struct Adapt
 
 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct
CommandControlBlock *ccb)
 {
-	uint32_t cdb_shifted_phyaddr = ccb->cdb_shifted_phyaddr;
+	uint32_t shifted_cdb_phyaddr = ccb->shifted_cdb_phyaddr;
 	struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB
*)&ccb->arcmsr_cdb;
 	atomic_inc(&acb->ccboutstandingcount);
 	ccb->startdone = ARCMSR_CCB_START;
@@ -963,10 +1109,10 @@ static void arcmsr_post_ccb(struct Adapt
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
-			writel(cdb_shifted_phyaddr |
ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
+			writel(shifted_cdb_phyaddr |
ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
 			&reg->inbound_queueport);
 		else {
-				writel(cdb_shifted_phyaddr,
&reg->inbound_queueport);
+				writel(shifted_cdb_phyaddr,
&reg->inbound_queueport);
 		}
 		}
 		break;
@@ -978,16 +1124,16 @@ static void arcmsr_post_ccb(struct Adapt
 		ending_index = ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
 		writel(0, &reg->post_qbuffer[ending_index]);
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
-			writel(cdb_shifted_phyaddr |
ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
+			writel(shifted_cdb_phyaddr |
ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
 						 &reg->post_qbuffer[index]);
 		}
 		else {
-			writel(cdb_shifted_phyaddr,
&reg->post_qbuffer[index]);
+			writel(shifted_cdb_phyaddr,
&reg->post_qbuffer[index]);
 		}
 		index++;
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set
it to 0 */
 		reg->postq_index = index;
-		writel(ARCMSR_DRV2IOP_CDB_POSTED,
reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell);
 		}
 		break;
 	}
@@ -1010,7 +1156,7 @@ static void arcmsr_stop_hbb_bgrb(struct 
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell_reg);
+	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);
 
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
@@ -1038,23 +1184,14 @@ static void arcmsr_free_ccb_pool(struct 
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
acb->dma_coherent, acb->dma_coherent_handle);
 		iounmap(acb->pmuA);
-		dma_free_coherent(&acb->pdev->dev,
-		ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock)
+ 0x20,
-		acb->dma_coherent,
-		acb->dma_coherent_handle);
-		break;
 	}
+		break;
 	case ACB_ADAPTER_TYPE_B: {
-		struct MessageUnit_B *reg = acb->pmuB;
-		iounmap(reg->drv2iop_doorbell_reg -
ARCMSR_DRV2IOP_DOORBELL);
-		iounmap(reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);
-		dma_free_coherent(&acb->pdev->dev,
-		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock)
+ 0x20 +
-		sizeof(struct MessageUnit_B)), acb->dma_coherent,
acb->dma_coherent_handle);
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
acb->dma_coherent, acb->dma_coherent_handle);
 	}
 	}
-
 }
 
 void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
@@ -1068,7 +1205,7 @@ void arcmsr_iop_message_read(struct Adap
 
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK,
reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
 		}
 		break;
 	}
@@ -1093,7 +1230,7 @@ static void arcmsr_iop_message_wrote(str
 		** push inbound doorbell tell iop, driver data write ok
 		** and wait reply on next hwinterrupt for next Qbuffer post
 		*/
-		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK,
reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell);
 		}
 		break;
 	}
@@ -1113,7 +1250,7 @@ struct QBUFFER __iomem *arcmsr_get_iop_r
 
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
-		qbuffer = (struct QBUFFER __iomem *)reg->ioctl_rbuffer_reg;
+		qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;
 		}
 		break;
 	}
@@ -1134,7 +1271,7 @@ static struct QBUFFER __iomem *arcmsr_ge
 
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B  *reg = acb->pmuB;
-		pqbuffer = (struct QBUFFER __iomem *)reg->ioctl_wbuffer_reg;
+		pqbuffer = (struct QBUFFER __iomem *)reg->message_wbuffer;
 		}
 		break;
 	}
@@ -1248,14 +1385,36 @@ static void arcmsr_hbb_postqueue_isr(str
 		reg->doneq_index = index;
 	}
 }
-
+/*
+***************************************************************************
*******
+** Handle a message interrupt
+**
+** The only message interrupt we expect is in response to a query for the
current adapter config.  
+** We want this in order to compare the drivemap so that we can detect
newly-attached drives.
+***************************************************************************
*******
+*/
+static void arcmsr_hba_message_isr(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_A *reg  = acb->pmuA;
+	/*clear interrupt and message state*/
+	writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);
+	schedule_work(&acb->arcmsr_do_message_isr_bh);
+}
+static void arcmsr_hbb_message_isr(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_B *reg  = acb->pmuB;
+
+	/*clear interrupt and message state*/
+	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
+	schedule_work(&acb->arcmsr_do_message_isr_bh);
+}
 static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_intstatus;
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 
-	outbound_intstatus = readl(&reg->outbound_intstatus) & \
-
acb->outbound_int_enable;
+	outbound_intstatus = readl(&reg->outbound_intstatus) &
+		acb->outbound_int_enable;
 	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))	{
 		return 1;
 	}
@@ -1266,6 +1425,10 @@ static int arcmsr_handle_hba_isr(struct 
 	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {
 		arcmsr_hba_postqueue_isr(acb);
 	}
+	if(outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT) 	{
+		/* messenger of "driver to iop commands" */
+		arcmsr_hba_message_isr(acb);
+	}
 	return 0;
 }
 
@@ -1274,16 +1437,17 @@ static int arcmsr_handle_hbb_isr(struct 
 	uint32_t outbound_doorbell;
 	struct MessageUnit_B *reg = acb->pmuB;
 
-	outbound_doorbell = readl(reg->iop2drv_doorbell_reg) & \
-
acb->outbound_int_enable;
+	outbound_doorbell = readl(reg->iop2drv_doorbell) &
+				acb->outbound_int_enable;
 	if (!outbound_doorbell)
 		return 1;
 
-	writel(~outbound_doorbell, reg->iop2drv_doorbell_reg);
-	/*in case the last action of doorbell interrupt clearance is cached,
this action can push HW to write down the clear bit*/
-	readl(reg->iop2drv_doorbell_reg);
-	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);
-	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) 	{
+	writel(~outbound_doorbell, reg->iop2drv_doorbell);
+	/*in case the last action of doorbell interrupt clearance is cached,
+	this action can push HW to write down the clear bit*/
+	readl(reg->iop2drv_doorbell);
+	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
+	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {
 		arcmsr_iop2drv_data_wrote_handle(acb);
 	}
 	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK) {
@@ -1292,10 +1456,13 @@ static int arcmsr_handle_hbb_isr(struct 
 	if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {
 		arcmsr_hbb_postqueue_isr(acb);
 	}
+	if(outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
+		/* messenger of "driver to iop commands" */
+		arcmsr_hbb_message_isr(acb);
+	}
 
 	return 0;
 }
-
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -1359,7 +1526,7 @@ void arcmsr_post_ioctldata2iop(struct Ad
 	}
 }
 
-static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
+static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 					struct scsi_cmnd *cmd)
 {
 	struct CMD_MESSAGE_FIELD *pcmdmessagefld;
@@ -1397,6 +1564,7 @@ static int arcmsr_iop_message_xfer(struc
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
+				
 		ptmpQbuffer = ver_addr;
 		while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
 			&& (allxfer_len < 1031)) {
@@ -1428,7 +1596,11 @@ static int arcmsr_iop_message_xfer(struc
 		}
 		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr,
allxfer_len);
 		pcmdmessagefld->cmdmessage.Length = allxfer_len;
-		pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_OK;
+		if(acb->fw_flag == FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_OK;
+		}
 		kfree(ver_addr);
 		}
 		break;
@@ -1443,6 +1615,13 @@ static int arcmsr_iop_message_xfer(struc
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
+		if(acb->fw_flag == FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode = 
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode = 
+			ARCMSR_MESSAGE_RETURNCODE_OK;
+		}
 		ptmpuserbuffer = ver_addr;
 		user_len = pcmdmessagefld->cmdmessage.Length;
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer,
user_len);
@@ -1495,7 +1674,6 @@ static int arcmsr_iop_message_xfer(struc
 
 	case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {
 		uint8_t *pQbuffer = acb->rqbuffer;
-
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
 			arcmsr_iop_message_read(acb);
@@ -1504,12 +1682,25 @@ static int arcmsr_iop_message_xfer(struc
 		acb->rqbuf_firstindex = 0;
 		acb->rqbuf_lastindex = 0;
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
-		pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_OK;
+		if(acb->fw_flag == FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_OK;
+		}
 		}
 		break;
 
 	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {
 		uint8_t *pQbuffer = acb->wqbuffer;
+		if(acb->fw_flag == FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_OK;
+		}
 
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
@@ -1521,8 +1712,6 @@ static int arcmsr_iop_message_xfer(struc
 		acb->wqbuf_firstindex = 0;
 		acb->wqbuf_lastindex = 0;
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
-		pcmdmessagefld->cmdmessage.ReturnCode =
-			ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
 		break;
 
@@ -1545,29 +1734,53 @@ static int arcmsr_iop_message_xfer(struc
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));
 		pQbuffer = acb->wqbuffer;
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));
-		pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_OK;
+		if(acb->fw_flag == FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_OK;
+		}
 		}
 		break;
 
 	case ARCMSR_MESSAGE_RETURN_CODE_3F: {
-		pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_3F;
+		if(acb->fw_flag == FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_3F;
 		}
 		break;
-
+		}
 	case ARCMSR_MESSAGE_SAY_HELLO: {
 		int8_t *hello_string = "Hello! I am ARCMSR";
-
+		if(acb->fw_flag == FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}else{
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_OK;
+		}
 		memcpy(pcmdmessagefld->messagedatabuffer, hello_string
 			, (int16_t)strlen(hello_string));
-		pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
 		break;
 
 	case ARCMSR_MESSAGE_SAY_GOODBYE:
+		if(acb->fw_flag == FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}
 		arcmsr_iop_parking(acb);
 		break;
 
 	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:
+		if(acb->fw_flag == FW_DEADLOCK) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+		}
 		arcmsr_flush_adapter_cache(acb);
 		break;
 
@@ -1584,11 +1797,16 @@ static struct CommandControlBlock *arcms
 {
 	struct list_head *head = &acb->ccb_free_list;
 	struct CommandControlBlock *ccb = NULL;
-
+	unsigned long flags;
+	spin_lock_irqsave(&acb->ccblist_lock, flags);
 	if (!list_empty(head)) {
 		ccb = list_entry(head->next, struct CommandControlBlock,
list);
-		list_del(head->next);
+		list_del_init(&ccb->list);
+	}else{
+		spin_unlock_irqrestore(&acb->ccblist_lock, flags);
+		return 0;
 	}
+	spin_unlock_irqrestore(&acb->ccblist_lock, flags);
 	return ccb;
 }
 
@@ -1650,38 +1868,25 @@ static int arcmsr_queue_command(struct s
 	struct CommandControlBlock *ccb;
 	int target = cmd->device->id;
 	int lun = cmd->device->lun;
-
+	uint8_t scsicmd = cmd->cmnd[0];
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 	cmd->result = 0;
-	if (acb->acb_flags & ACB_F_BUS_RESET) {
-		printk(KERN_NOTICE "arcmsr%d: bus reset"
-			" and return busy \n"
-			, acb->host->host_no);
-		return SCSI_MLQUEUE_HOST_BUSY;
+
+	if((scsicmd == SYNCHRONIZE_CACHE) ||(scsicmd == SEND_DIAGNOSTIC)) {
+		if(acb->devstate[target][lun] == ARECA_RAID_GONE) {
+    			cmd->result = (DID_NO_CONNECT << 16);
+		}
+		cmd->scsi_done(cmd);
+		return 0;
 	}
+
 	if (target == 16) {
 		/* virtual device for iop message transfer */
 		arcmsr_handle_virtual_command(acb, cmd);
 		return 0;
 	}
-	if (acb->devstate[target][lun] == ARECA_RAID_GONE) {
-		uint8_t block_cmd;
 
-		block_cmd = cmd->cmnd[0] & 0x0f;
-		if (block_cmd == 0x08 || block_cmd == 0x0a) {
-			printk(KERN_NOTICE
-				"arcmsr%d: block 'read/write'"
-				"command with gone raid volume"
-				" Cmd = %2x, TargetId = %d, Lun = %d \n"
-				, acb->host->host_no
-				, cmd->cmnd[0]
-				, target, lun);
-			cmd->result = (DID_NO_CONNECT << 16);
-			cmd->scsi_done(cmd);
-			return 0;
-		}
-	}
 	if (atomic_read(&acb->ccboutstandingcount) >=
 			ARCMSR_MAX_OUTSTANDING_CMD)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1698,23 +1903,24 @@ static int arcmsr_queue_command(struct s
 	return 0;
 }
 
-static void arcmsr_get_hba_config(struct AdapterControlBlock *acb)
-{
+static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb){
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	char *acb_firm_model = acb->firm_model;
 	char *acb_firm_version = acb->firm_version;
+	char *acb_device_map = acb->device_map;
 	char __iomem *iop_firm_model = (char __iomem
*)(&reg->message_rwbuffer[15]);
 	char __iomem *iop_firm_version = (char __iomem
*)(&reg->message_rwbuffer[17]);
+	char __iomem *iop_device_map = (char __iomem *)
(&reg->message_rwbuffer[21]);
 	int count;
 
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
 	if (arcmsr_hba_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n",
acb->host->host_no);
+		return false;
 	}
-
 	count = 8;
-	while (count) {
+	while (count){
 		*acb_firm_model = readb(iop_firm_model);
 		acb_firm_model++;
 		iop_firm_model++;
@@ -1722,95 +1928,131 @@ static void arcmsr_get_hba_config(struct
 	}
 
 	count = 16;
-	while (count) {
+	while (count){
 		*acb_firm_version = readb(iop_firm_version);
 		acb_firm_version++;
 		iop_firm_version++;
 		count--;
 	}
 
-	printk(KERN_INFO 	"ARECA RAID ADAPTER%d: FIRMWARE VERSION %s
\n"
-		, acb->host->host_no
-		, acb->firm_version);
-
+	count=16;
+	while(count){
+		*acb_device_map=readb(iop_device_map);
+		acb_device_map++;
+		iop_device_map++;
+		count--;
+	}
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n", 
+		acb->host->host_no,
+		acb->firm_version,
+		acb->firm_model);
+	acb->signature = readl(&reg->message_rwbuffer[0]);
 	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
 	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
 	acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
 	acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
+	acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
+	return true;
 }
-
-static void arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
+static bool arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
-	uint32_t __iomem *lrwbuffer = reg->msgcode_rwbuffer_reg;
+	struct pci_dev *pdev = acb->pdev;
+	void *dma_coherent;
+	dma_addr_t dma_coherent_handle;
 	char *acb_firm_model = acb->firm_model;
 	char *acb_firm_version = acb->firm_version;
-	char __iomem *iop_firm_model = (char __iomem *)(&lrwbuffer[15]);
+	char *acb_device_map = acb->device_map;
+	char __iomem *iop_firm_model;
 	/*firm_model,15,60-67*/
-	char __iomem *iop_firm_version = (char __iomem *)(&lrwbuffer[17]);
+	char __iomem *iop_firm_version;
 	/*firm_version,17,68-83*/
+	char __iomem *iop_device_map;
+	/*firm_version,21,84-99*/
 	int count;
+	dma_coherent = dma_alloc_coherent(&pdev->dev, sizeof(struct
MessageUnit_B), &dma_coherent_handle, GFP_KERNEL);
+	if (!dma_coherent){
+		printk("arcmsr%d: dma_alloc_coherent got error for hbb
mu\n", acb->host->host_no);
+		return false;
+	}
+	acb->dma_coherent_handle_hbb_mu = dma_coherent_handle;
+	reg = (struct MessageUnit_B *)dma_coherent;
+	acb->pmuB = reg;
+	reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
+	reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
+	reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
+	reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
+	reg->message_wbuffer = (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_WBUFFER);
+	reg->message_rbuffer =  (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_RBUFFER);
+	reg->message_rwbuffer = (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_RWBUFFER);
+	iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);
/*firm_model,15,60-67*/
+	iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);
/*firm_version,17,68-83*/
+	iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);
/*firm_version,21,84-99*/
 
-	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);
-	if (arcmsr_hbb_wait_msgint_ready(acb)) {
+	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
+	if (arcmsr_hbb_wait_msgint_ready(acb)){
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n",
acb->host->host_no);
+		return false;
 	}
-
 	count = 8;
-	while (count)
-	{
+	while (count){
 		*acb_firm_model = readb(iop_firm_model);
 		acb_firm_model++;
 		iop_firm_model++;
 		count--;
 	}
-
 	count = 16;
-	while (count)
-	{
+	while (count){
 		*acb_firm_version = readb(iop_firm_version);
 		acb_firm_version++;
 		iop_firm_version++;
 		count--;
 	}
 
-	printk(KERN_INFO "ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n",
-			acb->host->host_no,
-			acb->firm_version);
-
-	lrwbuffer++;
-	acb->firm_request_len = readl(lrwbuffer++);
+	count=16;
+	while(count){
+		*acb_device_map=readb(iop_device_map);
+		acb_device_map++;
+		iop_device_map++;
+		count--;
+	}
+	
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+		acb->host->host_no,
+		acb->firm_version,
+		acb->firm_model);
+
+	acb->signature = readl(&reg->message_rwbuffer[1]);
+	/*firm_signature,1,00-03*/
+	acb->firm_request_len=readl(&reg->message_rwbuffer[2]); 
 	/*firm_request_len,1,04-07*/
-	acb->firm_numbers_queue = readl(lrwbuffer++);
+	acb->firm_numbers_queue=readl(&reg->message_rwbuffer[3]); 
 	/*firm_numbers_queue,2,08-11*/
-	acb->firm_sdram_size = readl(lrwbuffer++);
+	acb->firm_sdram_size=readl(&reg->message_rwbuffer[4]); 
 	/*firm_sdram_size,3,12-15*/
-	acb->firm_hd_channels = readl(lrwbuffer);
+	acb->firm_hd_channels=readl(&reg->message_rwbuffer[5]); 
 	/*firm_ide_channels,4,16-19*/
+	acb->firm_cfg_version=readl(&reg->message_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
+	/*firm_ide_channels,4,16-19*/
+	return true;
 }
-
-static void arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
+static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
-	switch (acb->adapter_type) {
-	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_get_hba_config(acb);
-		}
-		break;
-
-	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_get_hbb_config(acb);
-		}
-		break;
-	}
+	if(acb->adapter_type == ACB_ADAPTER_TYPE_A)
+		return arcmsr_get_hba_config(acb);
+	else
+		return arcmsr_get_hbb_config(acb);
 }
 
-static void arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
 	struct CommandControlBlock *poll_ccb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	struct CommandControlBlock *ccb;
+	struct ARCMSR_CDB *arcmsr_cdb;
 	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0, poll_count
= 0;
+	int rtn;
 
 	polling_hba_ccb_retry:
 	poll_count++;
@@ -1818,16 +2060,19 @@ static void arcmsr_polling_hba_ccbdone(s
 	writel(outbound_intstatus, &reg->outbound_intstatus);/*clear
interrupt*/
 	while (1) {
 		if ((flag_ccb = readl(&reg->outbound_queueport)) ==
0xFFFFFFFF) {
-			if (poll_ccb_done)
+			if (poll_ccb_done){
+				rtn = SUCCESS;
 				break;
-			else {
-				msleep(25);
-				if (poll_count > 100)
+			}else {
+				if (poll_count > 100){
+					rtn = FAILED;
 					break;
+				}
 				goto polling_hba_ccb_retry;
 			}
 		}
-		ccb = (struct CommandControlBlock *)(acb->vir2phy_offset +
(flag_ccb << 5));
+		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
(flag_ccb << 5));
+		ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
arcmsr_cdb);
 		poll_ccb_done = (ccb == poll_ccb) ? 1:0;
 		if ((ccb->acb != acb) || (ccb->startdone !=
ARCMSR_CCB_START)) {
 			if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb
== poll_ccb)) {
@@ -1838,8 +2083,7 @@ static void arcmsr_polling_hba_ccbdone(s
 					, ccb->pcmd->device->lun
 					, ccb);
 				ccb->pcmd->result = DID_ABORT << 16;
-				arcmsr_ccb_complete(ccb, 1);
-				poll_ccb_done = 1;
+				arcmsr_ccb_complete(ccb);
 				continue;
 			}
 			printk(KERN_NOTICE "arcmsr%d: polling get an illegal
ccb"
@@ -1849,87 +2093,97 @@ static void arcmsr_polling_hba_ccbdone(s
 				, ccb
 				, atomic_read(&acb->ccboutstandingcount));
 			continue;
+		}else{
+			arcmsr_report_ccb_state(acb, ccb, flag_ccb);
 		}
-		arcmsr_report_ccb_state(acb, ccb, flag_ccb);
 	}
+	return rtn;
 }
 
-static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock
*poll_ccb)
 {
-		struct MessageUnit_B *reg = acb->pmuB;
-		struct CommandControlBlock *ccb;
-		uint32_t flag_ccb, poll_ccb_done = 0, poll_count = 0;
-		int index;
-
+	struct MessageUnit_B *reg = acb->pmuB;
+	struct ARCMSR_CDB *arcmsr_cdb;
+	struct CommandControlBlock *ccb;
+	uint32_t flag_ccb, poll_ccb_done = 0, poll_count = 0;
+	int index, rtn;
+	
 	polling_hbb_ccb_retry:
-		poll_count++;
-		/* clear doorbell interrupt */
-		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
reg->iop2drv_doorbell_reg);
-		while (1) {
-			index = reg->doneq_index;
-			if ((flag_ccb = readl(&reg->done_qbuffer[index])) ==
0) {
-				if (poll_ccb_done)
+	poll_count++;
+	/* clear doorbell interrupt */
+	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
+	while(1){
+		index = reg->doneq_index;
+		if ((flag_ccb = readl(&reg->done_qbuffer[index])) == 0) {
+			if (poll_ccb_done){
+				rtn = SUCCESS;
+				break;
+			}else {
+				msleep(25);
+				if (poll_count > 100){
+					rtn = FAILED;
 					break;
-				else {
-					msleep(25);
-					if (poll_count > 100)
-						break;
-					goto polling_hbb_ccb_retry;
 				}
+				goto polling_hbb_ccb_retry;
 			}
-			writel(0, &reg->done_qbuffer[index]);
-			index++;
-			/*if last index number set it to 0 */
-			index %= ARCMSR_MAX_HBB_POSTQUEUE;
-			reg->doneq_index = index;
-			/* check ifcommand done with no error*/
-			ccb = (struct CommandControlBlock *)\
-      (acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes
aligned*/
-			poll_ccb_done = (ccb == poll_ccb) ? 1:0;
-			if ((ccb->acb != acb) || (ccb->startdone !=
ARCMSR_CCB_START)) {
-				if ((ccb->startdone == ARCMSR_CCB_ABORTED)
|| (ccb == poll_ccb)) {
-					printk(KERN_NOTICE "arcmsr%d: \
-		scsi id = %d lun = %d ccb = '0x%p' poll command abort
successfully \n"
-						,acb->host->host_no
-						,ccb->pcmd->device->id
-						,ccb->pcmd->device->lun
-						,ccb);
-					ccb->pcmd->result = DID_ABORT << 16;
-					arcmsr_ccb_complete(ccb, 1);
-					continue;
-				}
-				printk(KERN_NOTICE "arcmsr%d: polling get an
illegal ccb"
-					" command done ccb = '0x%p'"
-					"ccboutstandingcount = %d \n"
-					, acb->host->host_no
-					, ccb
-					,
atomic_read(&acb->ccboutstandingcount));
+		}
+		writel(0, &reg->done_qbuffer[index]);
+		index++;
+		/*if last index number set it to 0 */
+		index %= ARCMSR_MAX_HBB_POSTQUEUE;
+		reg->doneq_index = index;
+		/* check if command done with no error*/
+		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
(flag_ccb << 5));
+		ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
arcmsr_cdb);
+		poll_ccb_done = (ccb == poll_ccb) ? 1:0;
+		if ((ccb->acb != acb) || (ccb->startdone !=
ARCMSR_CCB_START)) {
+			if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb
== poll_ccb)) {
+				printk(KERN_NOTICE "arcmsr%d: scsi id = %d
lun = %d ccb = '0x%p'"
+					" poll command abort successfully
\n"
+					,acb->host->host_no
+					,ccb->pcmd->device->id
+					,ccb->pcmd->device->lun
+					,ccb);
+				ccb->pcmd->result = DID_ABORT << 16;
+				arcmsr_ccb_complete(ccb);
 				continue;
 			}
+			printk(KERN_NOTICE "arcmsr%d: polling get an illegal
ccb"
+				" command done ccb = '0x%p'"
+				"ccboutstandingcount = %d \n"
+				, acb->host->host_no
+				, ccb
+				, atomic_read(&acb->ccboutstandingcount));
+			continue;
+		}else{
 			arcmsr_report_ccb_state(acb, ccb, flag_ccb);
-		}	/*drain reply FIFO*/
+		}
+	}	/*drain reply FIFO*/
+	return rtn;
 }
 
-static void arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock
*poll_ccb)
 {
+	int rtn = 0;
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_polling_hba_ccbdone(acb,poll_ccb);
+		rtn = arcmsr_polling_hba_ccbdone(acb,poll_ccb);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_polling_hbb_ccbdone(acb,poll_ccb);
+		rtn = arcmsr_polling_hbb_ccbdone(acb,poll_ccb);
 		}
 	}
+	return rtn;
 }
 
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
-	uint32_t cdb_phyaddr, ccb_phyaddr_hi32;
+	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
 	dma_addr_t dma_coherent_handle;
 	/*
 	********************************************************************
@@ -1939,7 +2193,7 @@ static int arcmsr_iop_confirm(struct Ada
 	*/
 	dma_coherent_handle = acb->dma_coherent_handle;
 	cdb_phyaddr = (uint32_t)(dma_coherent_handle);
-	ccb_phyaddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);
+	cdb_phyaddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);
 	/*
 
***********************************************************************
 	**    if adapter type B, set window of "post command Q"
@@ -1948,13 +2202,13 @@ static int arcmsr_iop_confirm(struct Ada
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A: {
-		if (ccb_phyaddr_hi32 != 0) {
+		if (cdb_phyaddr_hi32 != 0) {
 			struct MessageUnit_A __iomem *reg = acb->pmuA;
 			uint32_t intmask_org;
 			intmask_org = arcmsr_disable_outbound_ints(acb);
 			writel(ARCMSR_SIGNATURE_SET_CONFIG, \
 						&reg->message_rwbuffer[0]);
-			writel(ccb_phyaddr_hi32, &reg->message_rwbuffer[1]);
+			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
 
&reg->inbound_msgaddr0);
 			if (arcmsr_hba_wait_msgint_ready(acb)) {
@@ -1977,19 +2231,18 @@ static int arcmsr_iop_confirm(struct Ada
 		intmask_org = arcmsr_disable_outbound_ints(acb);
 		reg->postq_index = 0;
 		reg->doneq_index = 0;
-		writel(ARCMSR_MESSAGE_SET_POST_WINDOW,
reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_MESSAGE_SET_POST_WINDOW,
reg->drv2iop_doorbell);
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d:can not set diver
mode\n", \
 				acb->host->host_no);
 			return 1;
 		}
-		post_queue_phyaddr = cdb_phyaddr + ARCMSR_MAX_FREECCB_NUM *
\
-		sizeof(struct CommandControlBlock) + offsetof(struct
MessageUnit_B, post_qbuffer) ;
-		rwbuffer = reg->msgcode_rwbuffer_reg;
+		post_queue_phyaddr = acb->dma_coherent_handle_hbb_mu;
+		rwbuffer = reg->message_rwbuffer;
 		/* driver "set config" signature */
 		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
 		/* normal should be zero */
-		writel(ccb_phyaddr_hi32, rwbuffer++);
+		writel(cdb_phyaddr_hi32, rwbuffer++);
 		/* postQ size (256 + 8)*4	 */
 		writel(post_queue_phyaddr, rwbuffer++);
 		/* doneQ size (256 + 8)*4	 */
@@ -1997,19 +2250,13 @@ static int arcmsr_iop_confirm(struct Ada
 		/* ccb maxQ size must be --> [(256 + 8)*4]*/
 		writel(1056, rwbuffer);
 
-		writel(ARCMSR_MESSAGE_SET_CONFIG,
reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d: 'set command Q window'
\
 			timeout \n",acb->host->host_no);
 			return 1;
 		}
-
-		writel(ARCMSR_MESSAGE_START_DRIVER_MODE,
reg->drv2iop_doorbell_reg);
-		if (arcmsr_hbb_wait_msgint_ready(acb)) {
-			printk(KERN_NOTICE "arcmsr%d: 'can not set diver
mode \n"\
-			,acb->host->host_no);
-			return 1;
-		}
+		arcmsr_hbb_enable_driver_mode(acb);
 		arcmsr_enable_outbound_ints(acb, intmask_org);
 		}
 		break;
@@ -2034,9 +2281,64 @@ static void arcmsr_wait_firmware_ready(s
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
 		do {
-			firmware_state = readl(reg->iop2drv_doorbell_reg);
+			firmware_state = readl(reg->iop2drv_doorbell);
 		} while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) ==
0);
-		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
reg->drv2iop_doorbell);
+		}
+		break;
+	}
+}
+
+static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
+	if(unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
+		return;
+	}else{
+		acb->fw_flag = FW_NORMAL;
+		if(atomic_read(&acb->ante_token_value) ==
atomic_read(&acb->rq_map_token)){
+			atomic_set(&acb->rq_map_token,16);
+		}
+		atomic_set(&acb->ante_token_value,
atomic_read(&acb->rq_map_token));
+		if(atomic_dec_and_test(&acb->rq_map_token))
+			return;
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
&reg->inbound_msgaddr0);
+		mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6*HZ));
+	}
+	return;
+}
+
+static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_B __iomem *reg = acb->pmuB;
+
+	if(unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
+		return;
+	}else{
+		acb->fw_flag = FW_NORMAL;
+		if(atomic_read(&acb->ante_token_value) ==
atomic_read(&acb->rq_map_token)){
+			atomic_set(&acb->rq_map_token,16);
+		}
+		atomic_set(&acb->ante_token_value,
atomic_read(&acb->rq_map_token));
+		if(atomic_dec_and_test(&acb->rq_map_token))
+			return;
+		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
+		mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6*HZ));
+	}
+	return;
+}
+
+static void arcmsr_request_device_map(unsigned long pacb)
+{
+	struct AdapterControlBlock *acb = (struct AdapterControlBlock
*)pacb;
+
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A: {
+			arcmsr_request_hba_device_map(acb);
+		}
+		break;
+		case ACB_ADAPTER_TYPE_B: {
+			arcmsr_request_hbb_device_map(acb);
 		}
 		break;
 	}
@@ -2057,7 +2359,7 @@ static void arcmsr_start_hbb_bgrb(struct
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell_reg);
+	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background
\
 				rebulid' timeout \n",acb->host->host_no);
@@ -2093,8 +2395,8 @@ static void arcmsr_clear_doorbell_queue_
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
 		/*clear interrupt and message state*/
-		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,
reg->iop2drv_doorbell_reg);
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK,
reg->drv2iop_doorbell_reg);
+		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,
reg->iop2drv_doorbell);
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
 		/* let IOP know data has been read */
 		}
 		break;
@@ -2109,7 +2411,7 @@ static void arcmsr_enable_eoi_mode(struc
 	case ACB_ADAPTER_TYPE_B:
 		{
 			struct MessageUnit_B *reg = acb->pmuB;
-			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,
reg->drv2iop_doorbell_reg);
+			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,
reg->drv2iop_doorbell);
 			if(arcmsr_hbb_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "ARCMSR IOP enables
EOI_MODE TIMEOUT");
 				return;
@@ -2120,15 +2422,62 @@ static void arcmsr_enable_eoi_mode(struc
 	return;
 }
 
+static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
+{
+	uint8_t value[64];
+	int i;	
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
+
+	/* backup pci config data */
+	printk(KERN_ERR "arcmsr%d: executing hw bus reset .....\n",
acb->host->host_no);
+	for (i=0; i<64; i++) {
+		pci_read_config_byte(acb->pdev, i, &value[i]);
+	}
+	/* hardware reset signal */
+	if((acb->dev_id == 0x1680)){
+		writel(ARCMSR_ARC1680_BUS_RESET, &reg->reserved1[0]);
+	}else{
+		pci_write_config_byte(acb->pdev, 0x84, 0x20);
+	}
+	msleep(1000);
+	/* write back pci config data */
+	for (i=0;i<64;i++) {
+		pci_write_config_byte(acb->pdev, i, value[i]);
+	}
+	msleep(1000);
+	return;
+}
+/*
+***************************************************************************
*
+***************************************************************************
*
+*/
+int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)
+{
+		struct Scsi_Host *shost = NULL;
+		int i, isleep;
+
+		shost = cmd->device->host;
+		isleep = sleeptime / 10;
+		if (isleep > 0) {
+			for (i = 0; i < isleep; i ++) {
+				msleep(10000);
+			}
+		}
+
+		isleep = sleeptime % 10;
+		if (isleep > 0) {
+			msleep(isleep*1000);
+		}
+		return 0;
+}
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)
 {
 	uint32_t intmask_org;
 
-       /* disable all outbound interrupt */
-       intmask_org = arcmsr_disable_outbound_ints(acb);
+	/* disable all outbound interrupt */
+	intmask_org = arcmsr_disable_outbound_ints(acb);
 	arcmsr_wait_firmware_ready(acb);
 	arcmsr_iop_confirm(acb);
-	arcmsr_get_firmware_spec(acb);
 	/*start background rebuild*/
 	arcmsr_start_adapter_bgrb(acb);
 	/* empty doorbell Qbuffer if door bell ringed */
@@ -2139,69 +2488,156 @@ static void arcmsr_iop_init(struct Adapt
 	acb->acb_flags |= ACB_F_IOP_INITED;
 }
 
-static void arcmsr_iop_reset(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)
 {
 	struct CommandControlBlock *ccb;
 	uint32_t intmask_org;
+	uint8_t rtnval = 0x00;
 	int i = 0;
-
 	if (atomic_read(&acb->ccboutstandingcount) != 0) {
-		/* talk to iop 331 outstanding command aborted */
-		arcmsr_abort_allcmd(acb);
-
-		/* wait for 3 sec for all command aborted*/
-		ssleep(3);
-
 		/* disable all outbound interrupt */
 		intmask_org = arcmsr_disable_outbound_ints(acb);
+		/* talk to iop 331 outstanding command aborted */
+		rtnval = arcmsr_abort_allcmd(acb);
 		/* clear all outbound posted Q */
 		arcmsr_done4abort_postqueue(acb);
 		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
 			ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
-				ccb->startdone = ARCMSR_CCB_ABORTED;
-				arcmsr_ccb_complete(ccb, 1);
+				arcmsr_ccb_complete(ccb);
 			}
 		}
+		atomic_set(&acb->ccboutstandingcount, 0);
 		/* enable all outbound interrupt */
 		arcmsr_enable_outbound_ints(acb, intmask_org);
+		return rtnval;
 	}
+	return rtnval;
 }
 
 static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;
-	int i;
-
+	uint32_t intmask_org, outbound_doorbell;
+	int retry_count = 0;
+	int rtn = FAILED;
+
+	acb = (struct AdapterControlBlock *) cmd->device->host->hostdata;
+	printk(KERN_ERR "arcmsr: executing eh bus reset .....num_resets =
%d, 
+		num_aborts = %d \n", acb->num_resets, acb->num_aborts);
 	acb->num_resets++;
-	acb->acb_flags |= ACB_F_BUS_RESET;
-	for (i = 0; i < 400; i++) {
-		if (!atomic_read(&acb->ccboutstandingcount))
+
+	switch(acb->adapter_type){
+		case ACB_ADAPTER_TYPE_A:{
+			if(acb->acb_flags & ACB_F_BUS_RESET){
+				long timeout;
+				timeout = wait_event_timeout(wait_q, 
+					(acb->acb_flags & ACB_F_BUS_RESET)
== 0, 220*HZ);
+				if(timeout){
+					return SUCCESS;
+				}
+			}
+			acb->acb_flags |= ACB_F_BUS_RESET;
+			if(arcmsr_iop_reset(acb)){
+				struct MessageUnit_A __iomem *reg;
+				reg = acb->pmuA;
+				arcmsr_hardware_reset(acb);
+				acb->acb_flags &= ~ACB_F_IOP_INITED;
+				sleep_again:
+				arcmsr_sleep_for_bus_reset(cmd);
+				if((readl(&reg->outbound_msgaddr1) &
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0){
+					printk(KERN_ERR "arcmsr%d: waiting
for hw bus reset return, 
+						retry=%d \n",
acb->host->host_no, retry_count);
+					if(retry_count > retrycount){
+						acb->fw_flag = FW_DEADLOCK;
+						printk(KERN_ERR "arcmsr%d:
waiting for hw bus reset return, 
+							RETRY TERMINATED!!
\n", acb->host->host_no);
+						return FAILED;
+					}
+					retry_count++;
+					goto sleep_again;
+				}
+				acb->acb_flags |= ACB_F_IOP_INITED;
+				/* disable all outbound interrupt */
+				intmask_org =
arcmsr_disable_outbound_ints(acb);
+				arcmsr_get_firmware_spec(acb);
+				arcmsr_start_adapter_bgrb(acb);
+				/* clear Qbuffer if door bell ringed */
+				outbound_doorbell =
readl(&reg->outbound_doorbell);
+				writel(outbound_doorbell,
&reg->outbound_doorbell); /*clear interrupt */
+   				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
&reg->inbound_doorbell);
+				/* enable outbound Post Queue,outbound
doorbell Interrupt */
+				arcmsr_enable_outbound_ints(acb,
intmask_org);
+				atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);
+				acb->fw_flag = FW_NORMAL;
+				init_timer(&acb->eternal_timer);
+				acb->eternal_timer.expires = jiffies +
msecs_to_jiffies(6*HZ);
+				acb->eternal_timer.data = (unsigned long)
acb;
+				acb->eternal_timer.function =
&arcmsr_request_device_map;
+				add_timer(&acb->eternal_timer);
+				acb->acb_flags &= ~ACB_F_BUS_RESET;
+				rtn = SUCCESS;
+				printk(KERN_ERR "arcmsr: scsi eh bus reset
succeeds\n");
+			}else{
+				acb->acb_flags &= ~ACB_F_BUS_RESET;
+				if(atomic_read(&acb->rq_map_token) == 0){
+					atomic_set(&acb->rq_map_token, 16);
+					atomic_set(&acb->ante_token_value,
16);
+					acb->fw_flag = FW_NORMAL;
+					init_timer(&acb->eternal_timer);
+						acb->eternal_timer.expires =
jiffies + msecs_to_jiffies(6*HZ);
+					acb->eternal_timer.data = (unsigned
long) acb;
+					acb->eternal_timer.function =
&arcmsr_request_device_map;
+					add_timer(&acb->eternal_timer);
+				}else{
+					atomic_set(&acb->rq_map_token, 16);
+					atomic_set(&acb->ante_token_value,
16);
+					acb->fw_flag = FW_NORMAL;
+					mod_timer(&acb->eternal_timer,
jiffies + msecs_to_jiffies(6*HZ));
+				}
+				rtn = SUCCESS;
+			}
 			break;
-		arcmsr_interrupt(acb);/* FIXME: need spinlock */
-		msleep(25);
+		}
+		case ACB_ADAPTER_TYPE_B:{
+			acb->acb_flags |= ACB_F_BUS_RESET;
+			if(arcmsr_iop_reset(acb)){
+				acb->acb_flags &= ~ACB_F_BUS_RESET;
+				rtn = FAILED;
+			}else{
+				acb->acb_flags &= ~ACB_F_BUS_RESET;
+				if(atomic_read(&acb->rq_map_token) == 0){
+					atomic_set(&acb->rq_map_token, 16);
+					atomic_set(&acb->ante_token_value,
16);
+					acb->fw_flag = FW_NORMAL;
+					init_timer(&acb->eternal_timer);
+						acb->eternal_timer.expires =
jiffies + msecs_to_jiffies(6*HZ);
+					acb->eternal_timer.data = (unsigned
long) acb;
+					acb->eternal_timer.function =
&arcmsr_request_device_map;
+					add_timer(&acb->eternal_timer);
+				}else{
+					atomic_set(&acb->rq_map_token, 16);
+					atomic_set(&acb->ante_token_value,
16);
+					acb->fw_flag = FW_NORMAL;
+					mod_timer(&acb->eternal_timer,
jiffies + msecs_to_jiffies(6*HZ));
+				}
+				rtn = SUCCESS;
+			}
+		}
 	}
-	arcmsr_iop_reset(acb);
-	acb->acb_flags &= ~ACB_F_BUS_RESET;
-	return SUCCESS;
+	return rtn;
 }
 
-static void arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
+static int arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
 		struct CommandControlBlock *ccb)
 {
-	u32 intmask;
-
-	ccb->startdone = ARCMSR_CCB_ABORTED;
-
-	/*
-	** Wait for 3 sec for all command done.
-	*/
-	ssleep(3);
-
-	intmask = arcmsr_disable_outbound_ints(acb);
-	arcmsr_polling_ccbdone(acb, ccb);
-	arcmsr_enable_outbound_ints(acb, intmask);
+	int rtn;
+	spin_lock_irq(&acb->eh_lock);
+	rtn = arcmsr_polling_ccbdone(acb, ccb);
+	spin_unlock_irq(&acb->eh_lock);
+	return rtn;
 }
 
 static int arcmsr_abort(struct scsi_cmnd *cmd)
@@ -2209,10 +2645,12 @@ static int arcmsr_abort(struct scsi_cmnd
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;
 	int i = 0;
+	int rtn = FAILED;
 
 	printk(KERN_NOTICE
 		"arcmsr%d: abort device command of scsi id = %d lun = %d
\n",
 		acb->host->host_no, cmd->device->id, cmd->device->lun);
+	acb->acb_flags |= ACB_F_ABORT;
 	acb->num_aborts++;
 	/*
 	************************************************
@@ -2221,17 +2659,20 @@ static int arcmsr_abort(struct scsi_cmnd
 	************************************************
 	*/
 	if (!atomic_read(&acb->ccboutstandingcount))
-		return SUCCESS;
+		return rtn;
 
 	for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+		printk("%s: loop %d\n", __FUNCTION__, i);
 		struct CommandControlBlock *ccb = acb->pccb_pool[i];
 		if (ccb->startdone == ARCMSR_CCB_START && ccb->pcmd == cmd)
{
-			arcmsr_abort_one_cmd(acb, ccb);
+			ccb->startdone = ARCMSR_CCB_ABORTED;
+			rtn = arcmsr_abort_one_cmd(acb, ccb);
 			break;
 		}
 	}
-
-	return SUCCESS;
+	acb->acb_flags &= ~ACB_F_ABORT;
+	printk("%s: leaving\n", __FUNCTION__);
+	return rtn;
 }
 
 static const char *arcmsr_info(struct Scsi_Host *host)
@@ -2336,7 +2777,7 @@ static void arcmsr_pci_ers_need_reset_fo
 			ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
 				ccb->startdone = ARCMSR_CCB_ABORTED;
-				arcmsr_ccb_complete(ccb, 1);
+				arcmsr_ccb_complete(ccb);
 			}
 		}
 		/* enable all outbound interrupt */
