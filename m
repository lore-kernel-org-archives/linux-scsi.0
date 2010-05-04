From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: PATCH 2/4 ] SCSI: Support 1024 scatter-gather list entries and improve AP while FW trapped and behaviors of EHs
Date: Tue, 4 May 2010 11:15:46 +0800
Message-ID: <397812166D304671A364A211F28CCFAB@areca4e4f859d4>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000C_01CAEB7B.26347FC0"
Return-path: <linux-kernel-owner@vger.kernel.org>
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_000C_01CAEB7B.26347FC0
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

------=_NextPart_000_000C_01CAEB7B.26347FC0
Content-Type: application/octet-stream;
	name="patch2-4"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch2-4"

diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr.h =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr.h=0A=
--- linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr.h	2010-05-03 =
11:35:24.000000000 +0800=0A=
+++ linux-2.6/drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr.h	2010-05-03 =
14:32:42.000000000 +0800=0A=
@@ -48,16 +48,22 @@ struct device_attribute;=0A=
 /*The limit of outstanding scsi command that firmware can handle*/=0A=
 #define ARCMSR_MAX_OUTSTANDING_CMD						256=0A=
 #define ARCMSR_MAX_FREECCB_NUM							320=0A=
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2008/11/03"=0A=
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2009/12/09"=0A=
 #define ARCMSR_SCSI_INITIATOR_ID						255=0A=
 #define ARCMSR_MAX_XFER_SECTORS							512=0A=
 #define ARCMSR_MAX_XFER_SECTORS_B						4096=0A=
+#define ARCMSR_MAX_XFER_SECTORS_C						304=0A=
 #define ARCMSR_MAX_TARGETID							17=0A=
 #define ARCMSR_MAX_TARGETLUN							8=0A=
 #define ARCMSR_MAX_CMD_PERLUN		                 =
ARCMSR_MAX_OUTSTANDING_CMD=0A=
 #define ARCMSR_MAX_QBUFFER							4096=0A=
-#define ARCMSR_MAX_SG_ENTRIES							38=0A=
+#define ARCMSR_DEFAULT_SG_ENTRIES						38=0A=
 #define ARCMSR_MAX_HBB_POSTQUEUE						264=0A=
+#define ARCMSR_MAX_XFER_LEN							0x26000 /* 152K */=0A=
+#define ARCMSR_CDB_SG_PAGE_LENGTH						256=0A=
+#ifndef PCI_DEVICE_ID_ARECA_1880=0A=
+#define PCI_DEVICE_ID_ARECA_1880 0x1880=0A=
+ #endif=0A=
 /*=0A=
 =
*************************************************************************=
*********=0A=
 **=0A=
@@ -141,26 +147,19 @@ struct CMD_MESSAGE_FIELD=0A=
 **   structure for holding DMA address data=0A=
 *************************************************************=0A=
 */=0A=
+#define IS_DMA64			(sizeof(dma_addr_t) =3D=3D 8)=0A=
 #define IS_SG64_ADDR                0x01000000 /* bit24 */=0A=
 struct  SG32ENTRY=0A=
 {=0A=
 	__le32					length;=0A=
 	__le32					address;=0A=
-};=0A=
+} __attribute__ ((packed));=0A=
 struct  SG64ENTRY=0A=
 {=0A=
 	__le32					length;=0A=
 	__le32					address;=0A=
 	__le32					addresshigh;=0A=
-};=0A=
-struct SGENTRY_UNION=0A=
-{=0A=
-	union=0A=
-	{=0A=
-		struct SG32ENTRY            sg32entry;=0A=
-		struct SG64ENTRY            sg64entry;=0A=
-	}u;=0A=
-};=0A=
+} __attribute__ ((packed));=0A=
 /*=0A=
 ********************************************************************=0A=
 **      Q Buffer of IOP Message Transfer=0A=
@@ -187,6 +186,9 @@ struct FIRMWARE_INFO=0A=
 	char          model[8];			/*15, 60-67*/=0A=
 	char          firmware_ver[16];     	/*17, 68-83*/=0A=
 	char          device_map[16];		/*21, 84-99*/=0A=
+	uint32_t		cfgVersion;	/*25,100-103 Added for checking of new firmware =
capability*/=0A=
+	uint8_t		cfgSerial[16];		/*26,104-119*/=0A=
+	uint32_t		cfgPicStatus;	/*30,120-123*/=0A=
 };=0A=
 /* signature of set and get firmware config */=0A=
 #define ARCMSR_SIGNATURE_GET_CONFIG		      0x87974060=0A=
@@ -213,6 +215,8 @@ struct FIRMWARE_INFO=0A=
 #define ARCMSR_CCBREPLY_FLAG_ERROR                    0x10000000=0A=
 /* outbound firmware ok */=0A=
 #define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000=0A=
+/* ARC-1680 Bus Reset*/=0A=
+#define ARCMSR_ARC1680_BUS_RESET				0x00000003=0A=
 =0A=
 /*=0A=
 ************************************************************************=0A=
@@ -264,11 +268,11 @@ struct FIRMWARE_INFO=0A=
 =0A=
 /* data tunnel buffer between user space program and its firmware */=0A=
 /* user space data to iop 128bytes */=0A=
-#define ARCMSR_IOCTL_WBUFFER			      0x0000fe00=0A=
+#define ARCMSR_MESSAGE_WBUFFER			      0x0000fe00=0A=
 /* iop data to user space 128bytes */=0A=
-#define ARCMSR_IOCTL_RBUFFER			      0x0000ff00=0A=
+#define ARCMSR_MESSAGE_RBUFFER			      0x0000ff00=0A=
 /* iop message_rwbuffer for message command */=0A=
-#define ARCMSR_MSGCODE_RWBUFFER			      0x0000fa00=0A=
+#define ARCMSR_MESSAGE_RWBUFFER			      0x0000fa00=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)=0A=
@@ -290,7 +294,7 @@ struct ARCMSR_CDB=0A=
 #define ARCMSR_CDB_FLAG_HEADQ              0x08=0A=
 #define ARCMSR_CDB_FLAG_ORDEREDQ           0x10=0A=
 =0A=
-	uint8_t							Reserved1;=0A=
+	uint8_t							msgPages;=0A=
 	uint32_t						Context;=0A=
 	uint32_t						DataLength;=0A=
 	uint8_t							Cdb[16];=0A=
@@ -303,10 +307,10 @@ struct ARCMSR_CDB=0A=
 	uint8_t							SenseData[15];=0A=
 	union=0A=
 	{=0A=
-		struct SG32ENTRY                sg32entry[ARCMSR_MAX_SG_ENTRIES];=0A=
-		struct SG64ENTRY                sg64entry[ARCMSR_MAX_SG_ENTRIES];=0A=
+		struct SG32ENTRY                sg32entry[1];=0A=
+		struct SG64ENTRY                sg64entry[1];=0A=
 	} u;=0A=
-};=0A=
+} __attribute__ ((packed));=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **     Messaging Unit (MU) of the Intel R 80331 I/O processor(Type A) =
and Type B processor=0A=
@@ -344,13 +348,13 @@ struct MessageUnit_B=0A=
 	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
 	uint32_t	postq_index;=0A=
 	uint32_t	doneq_index;=0A=
-	uint32_t		__iomem *drv2iop_doorbell_reg;=0A=
-	uint32_t		__iomem *drv2iop_doorbell_mask_reg;=0A=
-	uint32_t		__iomem *iop2drv_doorbell_reg;=0A=
-	uint32_t		__iomem *iop2drv_doorbell_mask_reg;=0A=
-	uint32_t		__iomem *msgcode_rwbuffer_reg;=0A=
-	uint32_t		__iomem *ioctl_wbuffer_reg;=0A=
-	uint32_t		__iomem *ioctl_rbuffer_reg;=0A=
+	uint32_t		__iomem *drv2iop_doorbell;=0A=
+	uint32_t		__iomem *drv2iop_doorbell_mask;=0A=
+	uint32_t		__iomem *iop2drv_doorbell;=0A=
+	uint32_t		__iomem *iop2drv_doorbell_mask;=0A=
+	uint32_t		__iomem *message_rwbuffer;=0A=
+	uint32_t		__iomem *message_wbuffer;=0A=
+	uint32_t		__iomem *message_rbuffer;=0A=
 };=0A=
 =0A=
 /*=0A=
@@ -370,14 +374,17 @@ struct AdapterControlBlock=0A=
 	unsigned long			vir2phy_offset;=0A=
 	/* Offset is used in making arc cdb physical to virtual calculations */=0A=
 	uint32_t			outbound_int_enable;=0A=
-=0A=
+	spinlock_t                      			eh_lock;=0A=
+	spinlock_t                      			ccblist_lock;=0A=
 	union {=0A=
 		struct MessageUnit_A __iomem *	pmuA;=0A=
 		struct MessageUnit_B *		pmuB;=0A=
 	};=0A=
 	/* message unit ATU inbound base address0 */=0A=
-=0A=
+	void __iomem *mem_base0;=0A=
+	void __iomem *mem_base1;=0A=
 	uint32_t			acb_flags;=0A=
+	u16			dev_id;=0A=
 	uint8_t                   		adapter_index;=0A=
 	#define ACB_F_SCSISTOPADAPTER         	0x0001=0A=
 	#define ACB_F_MSG_STOP_BGRB     	0x0002=0A=
@@ -394,6 +401,7 @@ struct AdapterControlBlock=0A=
 	#define ACB_F_BUS_RESET               	0x0080=0A=
 	#define ACB_F_IOP_INITED              	0x0100=0A=
 	/* iop init */=0A=
+	#define ACB_F_ABORT				0x0200=0A=
 	#define ACB_F_FIRMWARE_TRAP           		0x0400=0A=
 	struct CommandControlBlock *			pccb_pool[ARCMSR_MAX_FREECCB_NUM];=0A=
 	/* used for memory free */=0A=
@@ -408,7 +416,8 @@ struct AdapterControlBlock=0A=
 	/* dma_coherent used for memory free */=0A=
 	dma_addr_t			dma_coherent_handle;=0A=
 	/* dma_coherent_handle used for memory free */=0A=
-=0A=
+	dma_addr_t				dma_coherent_handle_hbb_mu;=0A=
+	unsigned int				uncache_size;=0A=
 	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];=0A=
 	/* data collection buffer for read from 80331 */=0A=
 	int32_t				rqbuf_firstindex;=0A=
@@ -432,14 +441,18 @@ struct AdapterControlBlock=0A=
 	uint32_t			firm_numbers_queue;=0A=
 	uint32_t			firm_sdram_size;=0A=
 	uint32_t			firm_hd_channels;=0A=
+	uint32_t                           	firm_cfg_version;=0A=
 	char			firm_model[12];=0A=
 	char			firm_version[20];=0A=
 	char			device_map[20];			/*21,84-99*/=0A=
 	struct work_struct 		arcmsr_do_message_isr_bh;=0A=
 	struct timer_list		eternal_timer;=0A=
-	unsigned short		fw_state;=0A=
+	unsigned short		fw_flag;=0A=
+				#define	FW_NORMAL	0x0000=0A=
+				#define	FW_BOG		0x0001=0A=
+				#define	FW_DEADLOCK	0x0010=0A=
 	atomic_t 			rq_map_token;=0A=
-	int			ante_token_value;=0A=
+	atomic_t			ante_token_value;=0A=
 };/* HW_DEVICE_EXTENSION */=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -449,65 +462,31 @@ struct AdapterControlBlock=0A=
 */=0A=
 struct CommandControlBlock=0A=
 {=0A=
-	struct ARCMSR_CDB		arcmsr_cdb;=0A=
-	/*=0A=
-	** 0-503 (size of CDB =3D 504):=0A=
-	** arcmsr messenger scsi command descriptor size 504 bytes=0A=
-	*/=0A=
-	uint32_t			cdb_shifted_phyaddr;=0A=
-	/* 504-507 */=0A=
-	uint32_t			reserved1;=0A=
-	/* 508-511 */=0A=
-#if BITS_PER_LONG =3D=3D 64=0A=
-	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+64 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */=0A=
-	struct list_head		list;=0A=
-	/* 512-527 16 bytes next/prev ptrs for ccb lists */=0A=
-	struct scsi_cmnd *		pcmd;=0A=
-	/* 528-535 8 bytes pointer of linux scsi command */=0A=
-	struct AdapterControlBlock *	acb;=0A=
-	/* 536-543 8 bytes pointer of acb */=0A=
-=0A=
-	uint16_t			ccb_flags;=0A=
-	/* 544-545 */=0A=
+	/*x32:sizeof struct_CCB=3D(32+60)byte, x64:sizeof =
struct_CCB=3D(64+60)byte*/=0A=
+	struct list_head		list;				/*x32: 8byte, x64: 16byte*/=0A=
+	struct scsi_cmnd		*pcmd;				/*8 bytes pointer of linux scsi command */=0A=
+	struct AdapterControlBlock	*acb;				/*x32: 4byte, x64: 8byte*/=0A=
+	uint32_t			shifted_cdb_phyaddr;		/*x32: 4byte, x64: 4byte*/=0A=
+	uint16_t			ccb_flags;			/*x32: 2byte, x64: 2byte*/=0A=
 	#define		CCB_FLAG_READ			0x0000=0A=
 	#define		CCB_FLAG_WRITE			0x0001=0A=
 	#define		CCB_FLAG_ERROR			0x0002=0A=
 	#define		CCB_FLAG_FLUSHCACHE		0x0004=0A=
 	#define		CCB_FLAG_MASTER_ABORTED		0x0008=0A=
-	uint16_t			startdone;=0A=
-	/* 546-547 */=0A=
+	uint16_t                        	startdone;			/*x32:2byte,x32:2byte*/=0A=
 	#define		ARCMSR_CCB_DONE			0x0000=0A=
 	#define		ARCMSR_CCB_START		0x55AA=0A=
 	#define		ARCMSR_CCB_ABORTED		0xAA55=0A=
 	#define		ARCMSR_CCB_ILLEGAL		0xFFFF=0A=
-	uint32_t			reserved2[7];=0A=
-	/* 548-551 552-555 556-559 560-563 564-567 568-571 572-575 */=0A=
+	#if BITS_PER_LONG =3D=3D 64=0A=
+	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+64 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */=0A=
+		uint32_t                        	reserved[6];		/*24 byte*/=0A=
 #else=0A=
 	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+32 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */=0A=
-	struct list_head		list;=0A=
-	/* 512-519 8 bytes next/prev ptrs for ccb lists */=0A=
-	struct scsi_cmnd *		pcmd;=0A=
-	/* 520-523 4 bytes pointer of linux scsi command */=0A=
-	struct AdapterControlBlock *	acb;=0A=
-	/* 524-527 4 bytes pointer of acb */=0A=
-=0A=
-	uint16_t			ccb_flags;=0A=
-	/* 528-529 */=0A=
-	#define		CCB_FLAG_READ			0x0000=0A=
-	#define		CCB_FLAG_WRITE			0x0001=0A=
-	#define		CCB_FLAG_ERROR			0x0002=0A=
-	#define		CCB_FLAG_FLUSHCACHE		0x0004=0A=
-	#define		CCB_FLAG_MASTER_ABORTED		0x0008=0A=
-	uint16_t			startdone;=0A=
-	/* 530-531 */=0A=
-	#define		ARCMSR_CCB_DONE			0x0000=0A=
-	#define		ARCMSR_CCB_START		0x55AA=0A=
-	#define		ARCMSR_CCB_ABORTED		0xAA55=0A=
-	#define		ARCMSR_CCB_ILLEGAL		0xFFFF=0A=
-	uint32_t			reserved2[3];=0A=
-	/* 532-535 536-539 540-543 */=0A=
+		uint32_t                        	reserved[2];		/*8  byte*/=0A=
 #endif=0A=
-	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D  */=0A=
+	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D   */=0A=
+	struct ARCMSR_CDB		arcmsr_cdb;=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr_hba.c =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr_hba.c=0A=
--- linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr_hba.c	=
2010-05-04 09:36:48.000000000 +0800=0A=
+++ linux-2.6/drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr_hba.c	=
2010-05-04 09:37:38.000000000 +0800=0A=
@@ -70,20 +70,13 @@=0A=
 #include <scsi/scsi_transport.h>=0A=
 #include <scsi/scsicam.h>=0A=
 #include "arcmsr.h"=0A=
-=0A=
-#ifdef CONFIG_SCSI_ARCMSR_RESET=0A=
-	static int sleeptime =3D 20;=0A=
-	static int retrycount =3D 12;=0A=
-	module_param(sleeptime, int, S_IRUGO|S_IWUSR);=0A=
-	MODULE_PARM_DESC(sleeptime, "The waiting period for FW ready while bus =
reset");=0A=
-	module_param(retrycount, int, S_IRUGO|S_IWUSR);=0A=
-	MODULE_PARM_DESC(retrycount, "The retry count for FW ready while bus =
reset");=0A=
-#endif=0A=
-MODULE_AUTHOR("Erich Chen <support@areca.com.tw>");=0A=
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host =
Bus Adapter");=0A=
+MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");=0A=
+MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx) SATA/SAS RAID Host Bus =
Adapter");=0A=
 MODULE_LICENSE("Dual BSD/GPL");=0A=
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);=0A=
-=0A=
+static int sleeptime =3D 20;=0A=
+static int retrycount =3D 12;=0A=
+wait_queue_head_t wait_q;=0A=
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
 					struct scsi_cmnd *cmd);=0A=
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);=0A=
@@ -107,7 +100,7 @@ static void arcmsr_request_device_map(un=0A=
 static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb);=0A=
 static void arcmsr_request_hbb_device_map(struct AdapterControlBlock =
*acb);=0A=
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);=0A=
-static void *arcmsr_get_firmware_spec(struct AdapterControlBlock *acb, =
int mode);=0A=
+static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);=0A=
 =0A=
 static const char *arcmsr_info(struct Scsi_Host *);=0A=
@@ -134,10 +127,10 @@ static struct scsi_host_template arcmsr_=0A=
 	.eh_bus_reset_handler	=3D arcmsr_bus_reset,=0A=
 	.bios_param		=3D arcmsr_bios_param,=0A=
 	.change_queue_depth	=3D arcmsr_adjust_disk_queue_depth,=0A=
-	.can_queue		=3D ARCMSR_MAX_OUTSTANDING_CMD,=0A=
+	.can_queue		=3D ARCMSR_MAX_FREECCB_NUM,=0A=
 	.this_id			=3D ARCMSR_SCSI_INITIATOR_ID,=0A=
-	.sg_tablesize		=3D ARCMSR_MAX_SG_ENTRIES,=0A=
-	.max_sectors    		=3D ARCMSR_MAX_XFER_SECTORS,=0A=
+	.sg_tablesize	        	=3D ARCMSR_DEFAULT_SG_ENTRIES,=0A=
+	.max_sectors    	    	=3D ARCMSR_MAX_XFER_SECTORS_C,=0A=
 	.cmd_per_lun		=3D ARCMSR_MAX_CMD_PERLUN,=0A=
 	.use_clustering		=3D ENABLE_CLUSTERING,=0A=
 	.shost_attrs		=3D arcmsr_host_attrs,=0A=
@@ -161,6 +154,7 @@ static struct pci_device_id arcmsr_devic=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},=0A=
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},=0A=
 	{0, 0}, /* Terminating entry */=0A=
 };=0A=
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);=0A=
@@ -175,15 +169,72 @@ static struct pci_driver arcmsr_pci_driv=0A=
 	#endif=0A=
 };=0A=
 =0A=
+static void arcmsr_free_mu(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A:=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_B:{=0A=
+		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+			dma_free_coherent(&acb->pdev->dev,=0A=
+				sizeof(struct MessageUnit_B),=0A=
+				reg, acb->dma_coherent_handle_hbb_mu);=0A=
+	}=0A=
+	}=0A=
+}=0A=
+=0A=
+static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	struct pci_dev *pdev =3D acb->pdev;=0A=
+=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A:{=0A=
+		acb->pmuA =3D ioremap(pci_resource_start(pdev, 0), =
pci_resource_len(pdev, 0));=0A=
+		if (!acb->pmuA) {=0A=
+			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			return false;=0A=
+		}=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_B:{=0A=
+		void __iomem *mem_base0, *mem_base1;=0A=
+		mem_base0 =3D ioremap(pci_resource_start(pdev, 0), =
pci_resource_len(pdev, 0));=0A=
+		if (!mem_base0) {=0A=
+			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			return false;=0A=
+		}=0A=
+		mem_base1 =3D ioremap(pci_resource_start(pdev, 2), =
pci_resource_len(pdev, 2));=0A=
+		if (!mem_base1) {=0A=
+			iounmap(mem_base0);=0A=
+			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			return false;=0A=
+		}=0A=
+		acb->mem_base0 =3D mem_base0;=0A=
+		acb->mem_base1 =3D mem_base1;=0A=
+	}=0A=
+	}=0A=
+	return true;=0A=
+}=0A=
+=0A=
+static void arcmsr_unmap_pciregion(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	switch (acb->adapter_type) {=0A=
+		case ACB_ADAPTER_TYPE_A:{=0A=
+			iounmap(acb->pmuA);=0A=
+		}=0A=
+		case ACB_ADAPTER_TYPE_B:{=0A=
+			iounmap(acb->mem_base0);=0A=
+			iounmap(acb->mem_base1);=0A=
+		}=0A=
+	}=0A=
+}=0A=
+=0A=
 static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id)=0A=
 {=0A=
 	irqreturn_t handle_state;=0A=
 	struct AdapterControlBlock *acb =3D dev_id;=0A=
 =0A=
-	spin_lock(acb->host->host_lock);=0A=
 	handle_state =3D arcmsr_interrupt(acb);=0A=
-	spin_unlock(acb->host->host_lock);=0A=
-=0A=
 	return handle_state;=0A=
 }=0A=
 =0A=
@@ -220,6 +271,7 @@ static void arcmsr_define_adapter_type(s=0A=
 	struct pci_dev *pdev =3D acb->pdev;=0A=
 	u16 dev_id;=0A=
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);=0A=
+	acb->dev_id =3D dev_id;=0A=
 	switch (dev_id) {=0A=
 	case 0x1201 : {=0A=
 		acb->adapter_type =3D ACB_ADAPTER_TYPE_B;=0A=
@@ -230,141 +282,210 @@ static void arcmsr_define_adapter_type(s=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)=0A=
+static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock =
*acb)=0A=
+{=0A=
+	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
+	uint32_t Index;=0A=
+	uint8_t Retries =3D 0x00;=0A=
+=0A=
+	do {=0A=
+		for (Index =3D 0; Index < 100; Index++) {=0A=
+			if (readl(&reg->outbound_intstatus) &=0A=
+					ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {=0A=
+				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,=0A=
+					&reg->outbound_intstatus);=0A=
+				return 0x00;=0A=
+			}=0A=
+			msleep(10);=0A=
+		} /*max 1 seconds*/=0A=
+=0A=
+	} while (Retries++ < 20);/*max 20 sec*/=0A=
+	return 0xff;=0A=
+}=0A=
+=0A=
+static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock =
*acb)=0A=
+{=0A=
+	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	uint32_t Index;=0A=
+	uint8_t Retries =3D 0x00;=0A=
+=0A=
+	do {=0A=
+		for (Index =3D 0; Index < 100; Index++) {=0A=
+			if (readl(reg->iop2drv_doorbell)=0A=
+				& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN=0A=
+					, reg->iop2drv_doorbell);=0A=
+				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);=0A=
+				return 0x00;=0A=
+			}=0A=
+			msleep(10);=0A=
+		} /*max 1 seconds*/=0A=
+=0A=
+	} while (Retries++ < 20);/*max 20 sec*/=0A=
+	return 0xff;=0A=
+}=0A=
+=0A=
+static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
+	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
+	int retry_count =3D 30;=0A=
 =0A=
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);=0A=
+	do {=0A=
+		if (!arcmsr_hba_wait_msgint_ready(acb))=0A=
+			break;=0A=
+		else {=0A=
+			retry_count--;=0A=
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
+			timeout, retry count down =3D %d \n", acb->host->host_no, =
retry_count);=0A=
+		}=0A=
+	} while (retry_count !=3D 0);=0A=
+}=0A=
+=0A=
+static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	int retry_count =3D 30;=0A=
+=0A=
+	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);=0A=
+	do {=0A=
+		if (!arcmsr_hbb_wait_msgint_ready(acb))=0A=
+			break;=0A=
+		else {=0A=
+			retry_count--;=0A=
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
+			timeout,retry count down =3D %d \n", acb->host->host_no, =
retry_count);=0A=
+		}=0A=
+	} while (retry_count !=3D 0);=0A=
+}=0A=
+=0A=
+static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)=0A=
+{=0A=
 	switch (acb->adapter_type) {=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
+		arcmsr_flush_hba_cache(acb);=0A=
+		}=0A=
+		break;=0A=
+=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		arcmsr_flush_hbb_cache(acb);=0A=
+		}=0A=
+	}=0A=
+}=0A=
+=0A=
+static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)=0A=
+{=0A=
 		struct pci_dev *pdev =3D acb->pdev;=0A=
+	switch (acb->adapter_type) {=0A=
+		case ACB_ADAPTER_TYPE_A: {=0A=
+=0A=
 		void *dma_coherent;=0A=
-		dma_addr_t dma_coherent_handle, dma_addr;=0A=
+			dma_addr_t dma_coherent_handle;=0A=
 		struct CommandControlBlock *ccb_tmp;=0A=
-		int i, j;=0A=
+			int i =3D 0, j =3D 0;=0A=
+			dma_addr_t cdb_phyaddr;=0A=
+			unsigned long roundup_ccbsize =3D 0;=0A=
+			unsigned long max_xfer_len;=0A=
+			unsigned long max_sg_entrys;=0A=
+			uint32_t  firm_config_version;=0A=
 =0A=
-		acb->pmuA =3D ioremap(pci_resource_start(pdev, 0), =
pci_resource_len(pdev, 0));=0A=
-		if (!acb->pmuA) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",=0A=
-							acb->host->host_no);=0A=
-			return -ENOMEM;=0A=
-		}=0A=
-=0A=
-		dma_coherent =3D dma_alloc_coherent(&pdev->dev,=0A=
-			ARCMSR_MAX_FREECCB_NUM *=0A=
-			sizeof (struct CommandControlBlock) + 0x20,=0A=
-			&dma_coherent_handle, GFP_KERNEL);=0A=
+			for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
+				for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
+					acb->devstate[i][j] =3D ARECA_RAID_GONE;=0A=
 =0A=
+			max_xfer_len =3D ARCMSR_MAX_XFER_LEN;=0A=
+			max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;=0A=
+			firm_config_version =3D acb->firm_cfg_version;=0A=
+			if ((firm_config_version & 0xFF) >=3D 3) {=0A=
+				max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH << =
((firm_config_version >> 8) & 0xFF)) * 1024;/* max 16M byte */=0A=
+				max_sg_entrys =3D (max_xfer_len/4096);=0A=
+			}=0A=
+			acb->host->max_sectors =3D max_xfer_len/512;=0A=
+			acb->host->sg_tablesize =3D max_sg_entrys;=0A=
+			roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) + =
max_sg_entrys * sizeof(struct SG64ENTRY), 32);=0A=
+			acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;=0A=
+			dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size, =
&dma_coherent_handle, GFP_KERNEL);=0A=
 		if (!dma_coherent) {=0A=
-			iounmap(acb->pmuA);=0A=
+				printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error \n", =
acb->host->host_no);=0A=
 			return -ENOMEM;=0A=
 		}=0A=
-=0A=
+			memset(dma_coherent, 0, acb->uncache_size);=0A=
 		acb->dma_coherent =3D dma_coherent;=0A=
 		acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
-=0A=
-		if (((unsigned long)dma_coherent & 0x1F)) {=0A=
-			dma_coherent =3D dma_coherent +=0A=
-				(0x20 - ((unsigned long)dma_coherent & 0x1F));=0A=
-			dma_coherent_handle =3D dma_coherent_handle +=0A=
-				(0x20 - ((unsigned long)dma_coherent_handle & 0x1F));=0A=
-		}=0A=
-=0A=
-		dma_addr =3D dma_coherent_handle;=0A=
 		ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;=0A=
+			acb->vir2phy_offset =3D (unsigned long)dma_coherent - (unsigned =
long)dma_coherent_handle;=0A=
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
-			ccb_tmp->cdb_shifted_phyaddr =3D dma_addr >> 5;=0A=
-			ccb_tmp->acb =3D acb;=0A=
+				cdb_phyaddr =3D dma_coherent_handle + offsetof(struct =
CommandControlBlock, arcmsr_cdb);=0A=
+				ccb_tmp->shifted_cdb_phyaddr =3D cdb_phyaddr >> 5;=0A=
 			acb->pccb_pool[i] =3D ccb_tmp;=0A=
+				ccb_tmp->acb =3D acb;=0A=
+				INIT_LIST_HEAD(&ccb_tmp->list);=0A=
 			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);=0A=
-			dma_addr =3D dma_addr + sizeof(struct CommandControlBlock);=0A=
-			ccb_tmp++;=0A=
-		}=0A=
-=0A=
-		acb->vir2phy_offset =3D (unsigned long)ccb_tmp -(unsigned =
long)dma_addr;=0A=
-		for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
-			for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
-				acb->devstate[i][j] =3D ARECA_RAID_GONE;=0A=
+				ccb_tmp =3D (struct CommandControlBlock *)((unsigned long)ccb_tmp + =
roundup_ccbsize);=0A=
+				dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;=0A=
 		}=0A=
 		break;=0A=
-=0A=
+		}=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 =0A=
-		struct pci_dev *pdev =3D acb->pdev;=0A=
-		struct MessageUnit_B *reg;=0A=
-		void __iomem *mem_base0, *mem_base1;=0A=
 		void *dma_coherent;=0A=
-		dma_addr_t dma_coherent_handle, dma_addr;=0A=
+			dma_addr_t dma_coherent_handle;=0A=
 		struct CommandControlBlock *ccb_tmp;=0A=
-		int i, j;=0A=
-=0A=
-		dma_coherent =3D dma_alloc_coherent(&pdev->dev,=0A=
-			((ARCMSR_MAX_FREECCB_NUM *=0A=
-			sizeof(struct CommandControlBlock) + 0x20) +=0A=
-			sizeof(struct MessageUnit_B)),=0A=
+			uint32_t cdb_phyaddr;=0A=
+			unsigned int roundup_ccbsize =3D 0;=0A=
+			unsigned long max_xfer_len;=0A=
+			unsigned long max_sg_entrys;=0A=
+			unsigned long firm_config_version;=0A=
+			unsigned long max_freeccb_num =3D 0;=0A=
+			int i =3D 0, j =3D 0;=0A=
+=0A=
+			max_freeccb_num =3D ARCMSR_MAX_FREECCB_NUM;=0A=
+			max_xfer_len =3D ARCMSR_MAX_XFER_LEN;=0A=
+			max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;=0A=
+			firm_config_version =3D acb->firm_cfg_version;=0A=
+			if ((firm_config_version & 0xFF) >=3D 3) {=0A=
+				max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH <<=0A=
+						((firm_config_version >> 8) & 0xFF)) * 1024;/* max 16M byte */=0A=
+				max_sg_entrys =3D (max_xfer_len/4096);/* max 4097 sg entry*/=0A=
+			}=0A=
+			acb->host->max_sectors =3D max_xfer_len / 512;=0A=
+			acb->host->sg_tablesize =3D max_sg_entrys;=0A=
+			roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock)+=0A=
+				(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
+			acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;=0A=
+			dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size,=0A=
 			&dma_coherent_handle, GFP_KERNEL);=0A=
-		if (!dma_coherent)=0A=
-			return -ENOMEM;=0A=
 =0A=
+			if (!dma_coherent) {=0A=
+				printk(KERN_NOTICE "DMA allocation =
failed...........................\n");=0A=
+				return -ENOMEM;=0A=
+			}=0A=
+			memset(dma_coherent, 0, acb->uncache_size);=0A=
 		acb->dma_coherent =3D dma_coherent;=0A=
 		acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
-=0A=
-		if (((unsigned long)dma_coherent & 0x1F)) {=0A=
-			dma_coherent =3D dma_coherent +=0A=
-				(0x20 - ((unsigned long)dma_coherent & 0x1F));=0A=
-			dma_coherent_handle =3D dma_coherent_handle +=0A=
-				(0x20 - ((unsigned long)dma_coherent_handle & 0x1F));=0A=
-		}=0A=
-=0A=
-		dma_addr =3D dma_coherent_handle;=0A=
 		ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;=0A=
+			acb->vir2phy_offset =3D (unsigned long)dma_coherent -=0A=
+					(unsigned long)dma_coherent_handle;=0A=
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
-			ccb_tmp->cdb_shifted_phyaddr =3D dma_addr >> 5;=0A=
-			ccb_tmp->acb =3D acb;=0A=
+				cdb_phyaddr =3D dma_coherent_handle +=0A=
+					offsetof(struct CommandControlBlock, arcmsr_cdb);=0A=
+				ccb_tmp->shifted_cdb_phyaddr =3D cdb_phyaddr >> 5;=0A=
 			acb->pccb_pool[i] =3D ccb_tmp;=0A=
+				ccb_tmp->acb =3D acb;=0A=
+				INIT_LIST_HEAD(&ccb_tmp->list);=0A=
 			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);=0A=
-			dma_addr =3D dma_addr + sizeof(struct CommandControlBlock);=0A=
-			ccb_tmp++;=0A=
-		}=0A=
-=0A=
-		reg =3D (struct MessageUnit_B *)(dma_coherent +=0A=
-		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock));=0A=
-		acb->pmuB =3D reg;=0A=
-		mem_base0 =3D ioremap(pci_resource_start(pdev, 0),=0A=
-					pci_resource_len(pdev, 0));=0A=
-		if (!mem_base0)=0A=
-			goto out;=0A=
-=0A=
-		mem_base1 =3D ioremap(pci_resource_start(pdev, 2),=0A=
-					pci_resource_len(pdev, 2));=0A=
-		if (!mem_base1) {=0A=
-			iounmap(mem_base0);=0A=
-			goto out;=0A=
+				ccb_tmp =3D (struct CommandControlBlock *)((unsigned long)ccb_tmp +=0A=
+									roundup_ccbsize);=0A=
+				dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;=0A=
 		}=0A=
-=0A=
-		reg->drv2iop_doorbell_reg =3D mem_base0 + ARCMSR_DRV2IOP_DOORBELL;=0A=
-		reg->drv2iop_doorbell_mask_reg =3D mem_base0 +=0A=
-						ARCMSR_DRV2IOP_DOORBELL_MASK;=0A=
-		reg->iop2drv_doorbell_reg =3D mem_base0 + ARCMSR_IOP2DRV_DOORBELL;=0A=
-		reg->iop2drv_doorbell_mask_reg =3D mem_base0 +=0A=
-						ARCMSR_IOP2DRV_DOORBELL_MASK;=0A=
-		reg->ioctl_wbuffer_reg =3D mem_base1 + ARCMSR_IOCTL_WBUFFER;=0A=
-		reg->ioctl_rbuffer_reg =3D mem_base1 + ARCMSR_IOCTL_RBUFFER;=0A=
-		reg->msgcode_rwbuffer_reg =3D mem_base1 + ARCMSR_MSGCODE_RWBUFFER;=0A=
-=0A=
-		acb->vir2phy_offset =3D (unsigned long)ccb_tmp -(unsigned =
long)dma_addr;=0A=
 		for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
 			for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
-				acb->devstate[i][j] =3D ARECA_RAID_GOOD;=0A=
+					acb->devstate[i][j] =3D ARECA_RAID_GONE;=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
 	return 0;=0A=
-=0A=
-out:=0A=
-	dma_free_coherent(&acb->pdev->dev,=0A=
-		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20 +=0A=
-		sizeof(struct MessageUnit_B)), acb->dma_coherent, =
acb->dma_coherent_handle);=0A=
-	return -ENOMEM;=0A=
 }=0A=
 static void arcmsr_message_isr_bh_fn(struct work_struct *work)=0A=
 {=0A=
@@ -413,8 +533,8 @@ static void arcmsr_message_isr_bh_fn(str=0A=
 		case ACB_ADAPTER_TYPE_B: {=0A=
 			struct MessageUnit_B *reg  =3D acb->pmuB;=0A=
 			char *acb_dev_map =3D (char *)acb->device_map;=0A=
-			uint32_t __iomem *signature =3D (uint32_t __iomem =
*)(&reg->msgcode_rwbuffer_reg[0]);=0A=
-			char __iomem *devicemap =3D (char __iomem =
*)(&reg->msgcode_rwbuffer_reg[21]);=0A=
+			uint32_t __iomem *signature =3D (uint32_t __iomem =
*)(&reg->message_rwbuffer[0]);=0A=
+			char __iomem *devicemap =3D (char __iomem =
*)(&reg->message_rwbuffer[21]);=0A=
 			int target, lun;=0A=
 			struct scsi_device *psdev;=0A=
 			char diff;=0A=
@@ -449,8 +569,7 @@ static void arcmsr_message_isr_bh_fn(str=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_probe(struct pci_dev *pdev,=0A=
-	const struct pci_device_id *id)=0A=
+static int arcmsr_probe(struct pci_dev *pdev, const struct =
pci_device_id *id)=0A=
 {=0A=
 	struct Scsi_Host *host;=0A=
 	struct AdapterControlBlock *acb;=0A=
@@ -458,19 +577,13 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	int error;=0A=
 =0A=
 	error =3D pci_enable_device(pdev);=0A=
-	if (error)=0A=
-		goto out;=0A=
-	pci_set_master(pdev);=0A=
-=0A=
-	host =3D scsi_host_alloc(&arcmsr_scsi_host_template,=0A=
-			sizeof(struct AdapterControlBlock));=0A=
+	if (error) {=0A=
+		return -ENODEV;=0A=
+	}=0A=
+	host =3D scsi_host_alloc(&arcmsr_scsi_host_template, sizeof(struct =
AdapterControlBlock));=0A=
 	if (!host) {=0A=
-		error =3D -ENOMEM;=0A=
-		goto out_disable_device;=0A=
+		goto pci_disable_dev;=0A=
 	}=0A=
-	acb =3D (struct AdapterControlBlock *)host->hostdata;=0A=
-	memset(acb, 0, sizeof (struct AdapterControlBlock));=0A=
-=0A=
 	error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));=0A=
 	if (error) {=0A=
 		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
@@ -478,126 +591,93 @@ static int arcmsr_probe(struct pci_dev *=0A=
 			printk(KERN_WARNING=0A=
 			       "scsi%d: No suitable DMA mask available\n",=0A=
 			       host->host_no);=0A=
-			goto out_host_put;=0A=
+			goto scsi_host_release;=0A=
 		}=0A=
 	}=0A=
+	init_waitqueue_head(&wait_q);=0A=
 	bus =3D pdev->bus->number;=0A=
 	dev_fun =3D pdev->devfn;=0A=
-	acb->host =3D host;=0A=
+	acb =3D (struct AdapterControlBlock *) host->hostdata;=0A=
+	memset(acb, 0, sizeof(struct AdapterControlBlock));=0A=
 	acb->pdev =3D pdev;=0A=
-	host->max_sectors =3D ARCMSR_MAX_XFER_SECTORS;=0A=
+	acb->host =3D host;=0A=
 	host->max_lun =3D ARCMSR_MAX_TARGETLUN;=0A=
 	host->max_id =3D ARCMSR_MAX_TARGETID;/*16:8*/=0A=
 	host->max_cmd_len =3D 16;    /*this is issue of 64bit LBA, over 2T =
byte*/=0A=
-	host->sg_tablesize =3D ARCMSR_MAX_SG_ENTRIES;=0A=
 	host->can_queue =3D ARCMSR_MAX_FREECCB_NUM; /* max simultaneous cmds */=0A=
 	host->cmd_per_lun =3D ARCMSR_MAX_CMD_PERLUN;=0A=
 	host->this_id =3D ARCMSR_SCSI_INITIATOR_ID;=0A=
 	host->unique_id =3D (bus << 8) | dev_fun;=0A=
-	host->irq =3D pdev->irq;=0A=
+	pci_set_drvdata(pdev, host);=0A=
+	pci_set_master(pdev);=0A=
 	error =3D pci_request_regions(pdev, "arcmsr");=0A=
 	if (error) {=0A=
-		goto out_host_put;=0A=
+		goto scsi_host_release;=0A=
 	}=0A=
-	arcmsr_define_adapter_type(acb);=0A=
-=0A=
+	spin_lock_init(&acb->eh_lock);=0A=
+	spin_lock_init(&acb->ccblist_lock);=0A=
 	acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
 			   ACB_F_MESSAGE_RQBUFFER_CLEARED |=0A=
 			   ACB_F_MESSAGE_WQBUFFER_READED);=0A=
 	acb->acb_flags &=3D ~ACB_F_SCSISTOPADAPTER;=0A=
 	INIT_LIST_HEAD(&acb->ccb_free_list);=0A=
-	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);=0A=
+	arcmsr_define_adapter_type(acb);=0A=
+	error =3D arcmsr_remap_pciregion(acb);=0A=
+	if (!error) {=0A=
+		goto pci_release_regs;=0A=
+	}=0A=
+	error =3D arcmsr_get_firmware_spec(acb);=0A=
+	if (!error) {=0A=
+		goto unmap_pci_region;=0A=
+	}=0A=
 	error =3D arcmsr_alloc_ccb_pool(acb);=0A=
-	if (error)=0A=
-		goto out_release_regions;=0A=
-=0A=
+	if (error) {=0A=
+		goto free_hbb_mu;=0A=
+	}=0A=
 	arcmsr_iop_init(acb);=0A=
-	error =3D request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
-			    IRQF_SHARED, "arcmsr", acb);=0A=
-	if (error)=0A=
-		goto out_free_ccb_pool;=0A=
-=0A=
-	pci_set_drvdata(pdev, host);=0A=
-	if (strncmp(acb->firm_version, "V1.42", 5) >=3D 0)=0A=
-		host->max_sectors=3D ARCMSR_MAX_XFER_SECTORS_B;=0A=
-=0A=
 	error =3D scsi_add_host(host, &pdev->dev);=0A=
-	if (error)=0A=
-		goto out_free_irq;=0A=
-=0A=
-	error =3D arcmsr_alloc_sysfs_attr(acb);=0A=
-	if (error)=0A=
-		goto out_free_sysfs;=0A=
-=0A=
+	if (error) {=0A=
+		goto RAID_controller_stop;=0A=
+	}=0A=
+	error =3D request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED, =
"arcmsr", acb);=0A=
+	if (error) {=0A=
+		goto scsi_host_remove;=0A=
+	}=0A=
+	host->irq =3D pdev->irq;=0A=
 	scsi_scan_host(host);=0A=
-	#ifdef CONFIG_SCSI_ARCMSR_AER=0A=
-	pci_enable_pcie_error_reporting(pdev);=0A=
-	#endif=0A=
+	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);=0A=
 	atomic_set(&acb->rq_map_token, 16);=0A=
-	acb->fw_state =3D true;=0A=
+	atomic_set(&acb->ante_token_value, 16);=0A=
+	acb->fw_flag =3D FW_NORMAL;=0A=
 	init_timer(&acb->eternal_timer);=0A=
-	acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(10*HZ);=0A=
+	acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6 * HZ);=0A=
 	acb->eternal_timer.data =3D (unsigned long) acb;=0A=
 	acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
 	add_timer(&acb->eternal_timer);=0A=
-=0A=
+	#ifdef CONFIG_SCSI_ARCMSR_AER=0A=
+		pci_enable_pcie_error_reporting(pdev);=0A=
+	#endif=0A=
+	if (arcmsr_alloc_sysfs_attr(acb))=0A=
+		goto out_free_sysfs;=0A=
 	return 0;=0A=
  out_free_sysfs:=0A=
- out_free_irq:=0A=
-	free_irq(pdev->irq, acb);=0A=
- out_free_ccb_pool:=0A=
+scsi_host_remove:=0A=
+	scsi_remove_host(host);=0A=
+RAID_controller_stop:=0A=
+	arcmsr_stop_adapter_bgrb(acb);=0A=
+	arcmsr_flush_adapter_cache(acb);=0A=
 	arcmsr_free_ccb_pool(acb);=0A=
- out_release_regions:=0A=
+free_hbb_mu:=0A=
+	arcmsr_free_mu(acb);=0A=
+unmap_pci_region:=0A=
+	arcmsr_unmap_pciregion(acb);=0A=
+pci_release_regs:=0A=
 	pci_release_regions(pdev);=0A=
- out_host_put:=0A=
+scsi_host_release:=0A=
 	scsi_host_put(host);=0A=
- out_disable_device:=0A=
+pci_disable_dev:=0A=
 	pci_disable_device(pdev);=0A=
- out:=0A=
-	return error;=0A=
-}=0A=
-=0A=
-static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock =
*acb)=0A=
-{=0A=
-	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-	uint32_t Index;=0A=
-	uint8_t Retries =3D 0x00;=0A=
-=0A=
-	do {=0A=
-		for (Index =3D 0; Index < 100; Index++) {=0A=
-			if (readl(&reg->outbound_intstatus) &=0A=
-					ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {=0A=
-				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,=0A=
-					&reg->outbound_intstatus);=0A=
-				return 0x00;=0A=
-			}=0A=
-			msleep(10);=0A=
-		}/*max 1 seconds*/=0A=
-=0A=
-	} while (Retries++ < 20);/*max 20 sec*/=0A=
-	return 0xff;=0A=
-}=0A=
-=0A=
-static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock =
*acb)=0A=
-{=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-	uint32_t Index;=0A=
-	uint8_t Retries =3D 0x00;=0A=
-=0A=
-	do {=0A=
-		for (Index =3D 0; Index < 100; Index++) {=0A=
-			if (readl(reg->iop2drv_doorbell_reg)=0A=
-				& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN=0A=
-					, reg->iop2drv_doorbell_reg);=0A=
-				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);=0A=
-				return 0x00;=0A=
-			}=0A=
-			msleep(10);=0A=
-		}/*max 1 seconds*/=0A=
-=0A=
-	} while (Retries++ < 20);/*max 20 sec*/=0A=
-	return 0xff;=0A=
+	return -ENODEV;=0A=
 }=0A=
 =0A=
 static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)=0A=
@@ -618,7 +698,7 @@ static uint8_t arcmsr_abort_hbb_allcmd(s=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 =0A=
-	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell_reg);=0A=
+	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);=0A=
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE=0A=
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
@@ -644,74 +724,39 @@ static uint8_t arcmsr_abort_allcmd(struc=0A=
 	return rtnval;=0A=
 }=0A=
 =0A=
-static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)=0A=
+static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock =
*pacb)=0A=
 {=0A=
-	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
+	struct MessageUnit_B *reg =3D pacb->pmuB;=0A=
 =0A=
-	scsi_dma_unmap(pcmd);=0A=
+	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);=0A=
+	if (arcmsr_hbb_wait_msgint_ready(pacb)) {=0A=
+		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", =
pacb->host->host_no);=0A=
+		return false;=0A=
 }=0A=
-=0A=
-static void arcmsr_ccb_complete(struct CommandControlBlock *ccb, int =
stand_flag)=0A=
-{=0A=
-	struct AdapterControlBlock *acb =3D ccb->acb;=0A=
-	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
-=0A=
-	arcmsr_pci_unmap_dma(ccb);=0A=
-	if (stand_flag =3D=3D 1)=0A=
-		atomic_dec(&acb->ccboutstandingcount);=0A=
-	ccb->startdone =3D ARCMSR_CCB_DONE;=0A=
-	ccb->ccb_flags =3D 0;=0A=
-	list_add_tail(&ccb->list, &acb->ccb_free_list);=0A=
-	pcmd->scsi_done(pcmd);=0A=
-}=0A=
-=0A=
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)=0A=
-{=0A=
-	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-	int retry_count =3D 30;=0A=
-=0A=
-	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);=0A=
-	do {=0A=
-		if (!arcmsr_hba_wait_msgint_ready(acb))=0A=
-			break;=0A=
-		else {=0A=
-			retry_count--;=0A=
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
-			timeout, retry count down =3D %d \n", acb->host->host_no, =
retry_count);=0A=
-		}=0A=
-	} while (retry_count !=3D 0);=0A=
-}=0A=
-=0A=
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)=0A=
-{=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-	int retry_count =3D 30;=0A=
-=0A=
-	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell_reg);=0A=
-	do {=0A=
-		if (!arcmsr_hbb_wait_msgint_ready(acb))=0A=
-			break;=0A=
-		else {=0A=
-			retry_count--;=0A=
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
-			timeout,retry count down =3D %d \n", acb->host->host_no, =
retry_count);=0A=
-		}=0A=
-	} while (retry_count !=3D 0);=0A=
+	return true;=0A=
 }=0A=
 =0A=
-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)=0A=
+static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)=0A=
 {=0A=
-	switch (acb->adapter_type) {=0A=
+	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
 =0A=
-	case ACB_ADAPTER_TYPE_A: {=0A=
-		arcmsr_flush_hba_cache(acb);=0A=
+	scsi_dma_unmap(pcmd);=0A=
 		}=0A=
-		break;=0A=
 =0A=
-	case ACB_ADAPTER_TYPE_B: {=0A=
-		arcmsr_flush_hbb_cache(acb);=0A=
-		}=0A=
-	}=0A=
+static void arcmsr_ccb_complete(struct CommandControlBlock *ccb)=0A=
+{=0A=
+	struct AdapterControlBlock *acb =3D ccb->acb;=0A=
+	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
+	unsigned long flags;=0A=
+=0A=
+	atomic_dec(&acb->ccboutstandingcount);=0A=
+	arcmsr_pci_unmap_dma(ccb);=0A=
+	ccb->startdone =3D ARCMSR_CCB_DONE;=0A=
+	ccb->ccb_flags =3D 0;=0A=
+	spin_lock_irqsave(&acb->ccblist_lock, flags);=0A=
+	list_add_tail(&ccb->list, &acb->ccb_free_list);=0A=
+	spin_unlock_irqrestore(&acb->ccblist_lock, flags);=0A=
+	pcmd->scsi_done(pcmd);=0A=
 }=0A=
 =0A=
 static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)=0A=
@@ -747,15 +792,15 @@ static u32 arcmsr_disable_outbound_ints(=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B : {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		orig_mask =3D readl(reg->iop2drv_doorbell_mask_reg);=0A=
-		writel(0, reg->iop2drv_doorbell_mask_reg);=0A=
+		orig_mask =3D readl(reg->iop2drv_doorbell_mask);=0A=
+		writel(0, reg->iop2drv_doorbell_mask);=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
 	return orig_mask;=0A=
 }=0A=
 =0A=
-static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb, \=0A=
+static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,=0A=
 			struct CommandControlBlock *ccb, uint32_t flag_ccb)=0A=
 {=0A=
 =0A=
@@ -766,13 +811,13 @@ static void arcmsr_report_ccb_state(stru=0A=
 		if (acb->devstate[id][lun] =3D=3D ARECA_RAID_GONE)=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GOOD;=0A=
 			ccb->pcmd->result =3D DID_OK << 16;=0A=
-			arcmsr_ccb_complete(ccb, 1);=0A=
+			arcmsr_ccb_complete(ccb);=0A=
 	} else {=0A=
 		switch (ccb->arcmsr_cdb.DeviceStatus) {=0A=
 		case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
 			ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
-			arcmsr_ccb_complete(ccb, 1);=0A=
+			arcmsr_ccb_complete(ccb);=0A=
 			}=0A=
 			break;=0A=
 =0A=
@@ -781,14 +826,14 @@ static void arcmsr_report_ccb_state(stru=0A=
 		case ARCMSR_DEV_INIT_FAIL: {=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
 			ccb->pcmd->result =3D DID_BAD_TARGET << 16;=0A=
-			arcmsr_ccb_complete(ccb, 1);=0A=
+			arcmsr_ccb_complete(ccb);=0A=
 			}=0A=
 			break;=0A=
 =0A=
 		case ARCMSR_DEV_CHECK_CONDITION: {=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GOOD;=0A=
 			arcmsr_report_sense_info(ccb);=0A=
-			arcmsr_ccb_complete(ccb, 1);=0A=
+			arcmsr_ccb_complete(ccb);=0A=
 			}=0A=
 			break;=0A=
 =0A=
@@ -803,7 +848,7 @@ static void arcmsr_report_ccb_state(stru=0A=
 					, ccb->arcmsr_cdb.DeviceStatus);=0A=
 					acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
 					ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
-					arcmsr_ccb_complete(ccb, 1);=0A=
+					arcmsr_ccb_complete(ccb);=0A=
 			break;=0A=
 		}=0A=
 	}=0A=
@@ -813,14 +858,19 @@ static void arcmsr_drain_donequeue(struc=0A=
 =0A=
 {=0A=
 	struct CommandControlBlock *ccb;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
+	int id, lun;=0A=
 =0A=
-	ccb =3D (struct CommandControlBlock *)(acb->vir2phy_offset + (flag_ccb =
<< 5));=0A=
+	arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));=0A=
+	ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
 	if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
 		if (ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
 			struct scsi_cmnd *abortcmd =3D ccb->pcmd;=0A=
 			if (abortcmd) {=0A=
+				id =3D abortcmd->device->id;=0A=
+				lun =3D abortcmd->device->lun;=0A=
 				abortcmd->result |=3D DID_ABORT << 16;=0A=
-				arcmsr_ccb_complete(ccb, 1);=0A=
+				arcmsr_ccb_complete(ccb);=0A=
 				printk(KERN_NOTICE "arcmsr%d: ccb =3D'0x%p' \=0A=
 				isr got aborted command \n", acb->host->host_no, ccb);=0A=
 			}=0A=
@@ -885,6 +935,7 @@ static void arcmsr_remove(struct pci_dev=0A=
 	int poll_count =3D 0;=0A=
 	arcmsr_free_sysfs_attr(acb);=0A=
 	scsi_remove_host(host);=0A=
+	scsi_host_put(host);=0A=
 	flush_scheduled_work();=0A=
 	del_timer_sync(&acb->eternal_timer);=0A=
 	arcmsr_disable_outbound_ints(acb);=0A=
@@ -910,7 +961,7 @@ static void arcmsr_remove(struct pci_dev=0A=
 			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {=0A=
 				ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
 				ccb->pcmd->result =3D DID_ABORT << 16;=0A=
-				arcmsr_ccb_complete(ccb, 1);=0A=
+				arcmsr_ccb_complete(ccb);=0A=
 			}=0A=
 		}=0A=
 	}=0A=
@@ -914,13 +965,10 @@ static void arcmsr_remove(struct pci_dev=0A=
 			}=0A=
 		}=0A=
 	}=0A=
-=0A=
 	free_irq(pdev->irq, acb);=0A=
 	arcmsr_free_ccb_pool(acb);=0A=
+	arcmsr_free_mu(acb);=0A=
 	pci_release_regions(pdev);=0A=
-=0A=
-	scsi_host_put(host);=0A=
-=0A=
 	pci_disable_device(pdev);=0A=
 	pci_set_drvdata(pdev, NULL);=0A=
 }=0A=
@@ -975,7 +1023,7 @@ static void arcmsr_enable_outbound_ints(=0A=
 			ARCMSR_IOP2DRV_DATA_READ_OK |=0A=
 			ARCMSR_IOP2DRV_CDB_DONE |=0A=
 			ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);=0A=
-		writel(mask, reg->iop2drv_doorbell_mask_reg);=0A=
+		writel(mask, reg->iop2drv_doorbell_mask);=0A=
 		acb->outbound_int_enable =3D (intmask_org | mask) & 0x0000000f;=0A=
 		}=0A=
 	}=0A=
@@ -988,6 +1036,9 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 	int8_t *psge =3D (int8_t *)&arcmsr_cdb->u;=0A=
 	__le32 address_lo, address_hi;=0A=
 	int arccdbsize =3D 0x30;=0A=
+	__le32 length =3D 0;=0A=
+	int i, cdb_sgcount =3D 0;=0A=
+	struct scatterlist *sg;=0A=
 	int nseg;=0A=
 =0A=
 	ccb->pcmd =3D pcmd;=0A=
@@ -997,19 +1048,12 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 	arcmsr_cdb->LUN =3D pcmd->device->lun;=0A=
 	arcmsr_cdb->Function =3D 1;=0A=
 	arcmsr_cdb->CdbLength =3D (uint8_t)pcmd->cmd_len;=0A=
-	arcmsr_cdb->Context =3D (unsigned long)arcmsr_cdb;=0A=
+	arcmsr_cdb->Context =3D 0;=0A=
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);=0A=
 =0A=
 	nseg =3D scsi_dma_map(pcmd);=0A=
-	if (nseg > ARCMSR_MAX_SG_ENTRIES)=0A=
+	if (nseg > acb->host->sg_tablesize || nseg < 0)=0A=
 		return FAILED;=0A=
-	BUG_ON(nseg < 0);=0A=
-=0A=
-	if (nseg) {=0A=
-		__le32 length;=0A=
-		int i, cdb_sgcount =3D 0;=0A=
-		struct scatterlist *sg;=0A=
-=0A=
 		/* map stor port SG list to our iop SG List. */=0A=
 		scsi_for_each_sg(pcmd, sg, nseg, i) {=0A=
 			/* Get the physical address of the current data pointer */=0A=
@@ -1036,10 +1080,10 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 		}=0A=
 		arcmsr_cdb->sgcount =3D (uint8_t)cdb_sgcount;=0A=
 		arcmsr_cdb->DataLength =3D scsi_bufflen(pcmd);=0A=
+	arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : =
0);=0A=
 		if ( arccdbsize > 256)=0A=
 			arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_SGL_BSIZE;=0A=
-	}=0A=
-	if (pcmd->sc_data_direction =3D=3D DMA_TO_DEVICE ) {=0A=
+	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0] | WRITE_10 || =
pcmd->cmnd[0]|WRITE_12) {=0A=
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_WRITE;=0A=
 		ccb->ccb_flags |=3D CCB_FLAG_WRITE;=0A=
 	}=0A=
@@ -1048,7 +1092,7 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 =0A=
 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct =
CommandControlBlock *ccb)=0A=
 {=0A=
-	uint32_t cdb_shifted_phyaddr =3D ccb->cdb_shifted_phyaddr;=0A=
+	uint32_t shifted_cdb_phyaddr =3D ccb->shifted_cdb_phyaddr;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb =3D (struct ARCMSR_CDB =
*)&ccb->arcmsr_cdb;=0A=
 	atomic_inc(&acb->ccboutstandingcount);=0A=
 	ccb->startdone =3D ARCMSR_CCB_START;=0A=
@@ -1058,10 +1102,10 @@ static void arcmsr_post_ccb(struct Adapt=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 =0A=
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)=0A=
-			writel(cdb_shifted_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
+			writel(shifted_cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
 			&reg->inbound_queueport);=0A=
 		else {=0A=
-				writel(cdb_shifted_phyaddr, &reg->inbound_queueport);=0A=
+				writel(shifted_cdb_phyaddr, &reg->inbound_queueport);=0A=
 		}=0A=
 		}=0A=
 		break;=0A=
@@ -1073,16 +1117,16 @@ static void arcmsr_post_ccb(struct Adapt=0A=
 		ending_index =3D ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);=0A=
 		writel(0, &reg->post_qbuffer[ending_index]);=0A=
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {=0A=
-			writel(cdb_shifted_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\=0A=
+			writel(shifted_cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\=0A=
 						 &reg->post_qbuffer[index]);=0A=
 		}=0A=
 		else {=0A=
-			writel(cdb_shifted_phyaddr, &reg->post_qbuffer[index]);=0A=
+			writel(shifted_cdb_phyaddr, &reg->post_qbuffer[index]);=0A=
 		}=0A=
 		index++;=0A=
 		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to =
0 */=0A=
 		reg->postq_index =3D index;=0A=
-		writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell_reg);=0A=
+		writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
@@ -1105,7 +1149,7 @@ static void arcmsr_stop_hbb_bgrb(struct =0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
-	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell_reg);=0A=
+	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);=0A=
 =0A=
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE=0A=
@@ -1133,23 +1177,14 @@ static void arcmsr_free_ccb_pool(struct =0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size, =
acb->dma_coherent, acb->dma_coherent_handle);=0A=
 		iounmap(acb->pmuA);=0A=
-		dma_free_coherent(&acb->pdev->dev,=0A=
-		ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock) + 0x20,=0A=
-		acb->dma_coherent,=0A=
-		acb->dma_coherent_handle);=0A=
-		break;=0A=
 	}=0A=
+		break;=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		iounmap((u8 *)reg->drv2iop_doorbell_reg - ARCMSR_DRV2IOP_DOORBELL);=0A=
-		iounmap((u8 *)reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);=0A=
-		dma_free_coherent(&acb->pdev->dev,=0A=
-		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20 +=0A=
-		sizeof(struct MessageUnit_B)), acb->dma_coherent, =
acb->dma_coherent_handle);=0A=
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size, =
acb->dma_coherent, acb->dma_coherent_handle);=0A=
 	}=0A=
 	}=0A=
-=0A=
 }=0A=
 =0A=
 void arcmsr_iop_message_read(struct AdapterControlBlock *acb)=0A=
@@ -1163,7 +1198,7 @@ void arcmsr_iop_message_read(struct Adap=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell_reg);=0A=
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
@@ -1188,7 +1223,7 @@ static void arcmsr_iop_message_wrote(str=0A=
 		** push inbound doorbell tell iop, driver data write ok=0A=
 		** and wait reply on next hwinterrupt for next Qbuffer post=0A=
 		*/=0A=
-		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell_reg);=0A=
+		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
@@ -1208,7 +1243,7 @@ struct QBUFFER __iomem *arcmsr_get_iop_r=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		qbuffer =3D (struct QBUFFER __iomem *)reg->ioctl_rbuffer_reg;=0A=
+		qbuffer =3D (struct QBUFFER __iomem *)reg->message_rbuffer;=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
@@ -1229,7 +1264,7 @@ static struct QBUFFER __iomem *arcmsr_ge=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B  *reg =3D acb->pmuB;=0A=
-		pqbuffer =3D (struct QBUFFER __iomem *)reg->ioctl_wbuffer_reg;=0A=
+		pqbuffer =3D (struct QBUFFER __iomem *)reg->message_wbuffer;=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
@@ -1364,7 +1398,7 @@ static void arcmsr_hbb_message_isr(struc=0A=
 	struct MessageUnit_B *reg  =3D acb->pmuB;=0A=
 =0A=
 	/*clear interrupt and message state*/=0A=
-	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);=0A=
+	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
 	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
 }=0A=
 static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)=0A=
@@ -1396,16 +1430,16 @@ static int arcmsr_handle_hbb_isr(struct =0A=
 	uint32_t outbound_doorbell;=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 =0A=
-	outbound_doorbell =3D readl(reg->iop2drv_doorbell_reg) &=0A=
+	outbound_doorbell =3D readl(reg->iop2drv_doorbell) &=0A=
 				acb->outbound_int_enable;=0A=
 	if (!outbound_doorbell)=0A=
 		return 1;=0A=
 =0A=
-	writel(~outbound_doorbell, reg->iop2drv_doorbell_reg);=0A=
+	writel(~outbound_doorbell, reg->iop2drv_doorbell);=0A=
 	/*in case the last action of doorbell interrupt clearance is cached,=0A=
 	this action can push HW to write down the clear bit*/=0A=
-	readl(reg->iop2drv_doorbell_reg);=0A=
-	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);=0A=
+	readl(reg->iop2drv_doorbell);=0A=
+	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);=0A=
 	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {=0A=
 		arcmsr_iop2drv_data_wrote_handle(acb);=0A=
 	}=0A=
@@ -1524,12 +1558,6 @@ static int arcmsr_iop_message_xfer(struc=0A=
 			goto message_out;=0A=
 		}=0A=
 =0A=
-		if (!acb->fw_state) {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
-			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-			goto message_out;=0A=
-		}=0A=
-=0A=
 		ptmpQbuffer =3D ver_addr;=0A=
 		while ((acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex)=0A=
 			&& (allxfer_len < 1031)) {=0A=
@@ -1561,7 +1589,11 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		}=0A=
 		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);=0A=
 		pcmdmessagefld->cmdmessage.Length =3D allxfer_len;=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
 		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
+		}=0A=
 		kfree(ver_addr);=0A=
 		}=0A=
 		break;=0A=
@@ -1576,12 +1608,13 @@ static int arcmsr_iop_message_xfer(struc=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			goto message_out;=0A=
 		}=0A=
-		if (!acb->fw_state) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-			goto message_out;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
-=0A=
 		ptmpuserbuffer =3D ver_addr;=0A=
 		user_len =3D pcmdmessagefld->cmdmessage.Length;=0A=
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);=0A=
@@ -1634,12 +1667,6 @@ static int arcmsr_iop_message_xfer(struc=0A=
 =0A=
 	case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->rqbuffer;=0A=
-		if (!acb->fw_state) {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
-			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-			goto message_out;=0A=
-		}=0A=
-=0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
 			arcmsr_iop_message_read(acb);=0A=
@@ -1648,16 +1675,24 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		acb->rqbuf_firstindex =3D 0;=0A=
 		acb->rqbuf_lastindex =3D 0;=0A=
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);=0A=
-		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
+		}=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->wqbuffer;=0A=
-		if (!acb->fw_state) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-			goto message_out;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 =0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
@@ -1670,18 +1705,11 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		acb->wqbuf_firstindex =3D 0;=0A=
 		acb->wqbuf_lastindex =3D 0;=0A=
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);=0A=
-		pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
-			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {=0A=
 		uint8_t *pQbuffer;=0A=
-		if (!acb->fw_state) {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
-			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-			goto message_out;=0A=
-		}=0A=
 =0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
@@ -1699,47 +1727,52 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));=0A=
 		pQbuffer =3D acb->wqbuffer;=0A=
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));=0A=
-		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
+		}=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_RETURN_CODE_3F: {=0A=
-		if (!acb->fw_state) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-			goto message_out;=0A=
-		}=0A=
-		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_3F;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_3F;=0A=
 		}=0A=
 		break;=0A=
-=0A=
+		}=0A=
 	case ARCMSR_MESSAGE_SAY_HELLO: {=0A=
 		int8_t *hello_string =3D "Hello! I am ARCMSR";=0A=
-		if (!acb->fw_state) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-			goto message_out;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		memcpy(pcmdmessagefld->messagedatabuffer, hello_string=0A=
 			, (int16_t)strlen(hello_string));=0A=
-		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_SAY_GOODBYE:=0A=
-		if (!acb->fw_state) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-			goto message_out;=0A=
 		}=0A=
 		arcmsr_iop_parking(acb);=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:=0A=
-		if (!acb->fw_state) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-			goto message_out;=0A=
 		}=0A=
 		arcmsr_flush_adapter_cache(acb);=0A=
 		break;=0A=
@@ -1757,11 +1790,16 @@ static struct CommandControlBlock *arcms=0A=
 {=0A=
 	struct list_head *head =3D &acb->ccb_free_list;=0A=
 	struct CommandControlBlock *ccb =3D NULL;=0A=
-=0A=
+	unsigned long flags;=0A=
+	spin_lock_irqsave(&acb->ccblist_lock, flags);=0A=
 	if (!list_empty(head)) {=0A=
 		ccb =3D list_entry(head->next, struct CommandControlBlock, list);=0A=
-		list_del(head->next);=0A=
+		list_del_init(&ccb->list);=0A=
+	} else {=0A=
+		spin_unlock_irqrestore(&acb->ccblist_lock, flags);=0A=
+		return 0;=0A=
 	}=0A=
+	spin_unlock_irqrestore(&acb->ccblist_lock, flags);=0A=
 	return ccb;=0A=
 }=0A=
 =0A=
@@ -1836,66 +1874,12 @@ static int arcmsr_queue_command(struct s=0A=
 		return 0;=0A=
 	}=0A=
 =0A=
-	if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
-		switch (acb->adapter_type) {=0A=
-			case ACB_ADAPTER_TYPE_A: {=0A=
-				struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-				uint32_t intmask_org, outbound_doorbell;=0A=
-=0A=
-				if ((readl(&reg->outbound_msgaddr1) &=0A=
-					ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0) {=0A=
-					printk(KERN_NOTICE "arcmsr%d: bus reset and return busy\n",=0A=
-						acb->host->host_no);=0A=
-					return SCSI_MLQUEUE_HOST_BUSY;=0A=
-				}=0A=
-=0A=
-				acb->acb_flags &=3D ~ACB_F_FIRMWARE_TRAP;=0A=
-				printk(KERN_NOTICE "arcmsr%d: hardware bus reset and reset ok\n",=0A=
-					acb->host->host_no);=0A=
-				/* disable all outbound interrupt */=0A=
-				intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-				arcmsr_get_firmware_spec(acb, 1);=0A=
-				/*start background rebuild*/=0A=
-				arcmsr_start_adapter_bgrb(acb);=0A=
-				/* clear Qbuffer if door bell ringed */=0A=
-				outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
-				/*clear interrupt */=0A=
-				writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
-				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,=0A=
-					&reg->inbound_doorbell);=0A=
-				/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
-				arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
-				acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-			}=0A=
-			break;=0A=
-			case ACB_ADAPTER_TYPE_B: {=0A=
-			}=0A=
-		}=0A=
-	}=0A=
-=0A=
 	if (target =3D=3D 16) {=0A=
 		/* virtual device for iop message transfer */=0A=
 		arcmsr_handle_virtual_command(acb, cmd);=0A=
 		return 0;=0A=
 	}=0A=
-	if (acb->devstate[target][lun] =3D=3D ARECA_RAID_GONE) {=0A=
-		uint8_t block_cmd;=0A=
 =0A=
-		block_cmd =3D cmd->cmnd[0] & 0x0f;=0A=
-		if (block_cmd =3D=3D 0x08 || block_cmd =3D=3D 0x0a) {=0A=
-			printk(KERN_NOTICE=0A=
-				"arcmsr%d: block 'read/write'"=0A=
-				"command with gone raid volume"=0A=
-				" Cmd =3D %2x, TargetId =3D %d, Lun =3D %d \n"=0A=
-				, acb->host->host_no=0A=
-				, cmd->cmnd[0]=0A=
-				, target, lun);=0A=
-			cmd->result =3D (DID_NO_CONNECT << 16);=0A=
-			cmd->scsi_done(cmd);=0A=
-			return 0;=0A=
-		}=0A=
-	}=0A=
 	if (atomic_read(&acb->ccboutstandingcount) >=3D=0A=
 			ARCMSR_MAX_OUTSTANDING_CMD)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
@@ -1912,7 +1896,7 @@ static int arcmsr_queue_command(struct s=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void *arcmsr_get_hba_config(struct AdapterControlBlock *acb, int =
mode)=0A=
+static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	char *acb_firm_model =3D acb->firm_model;=0A=
@@ -1927,10 +1911,8 @@ static void *arcmsr_get_hba_config(struc=0A=
 	if (arcmsr_hba_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
 			miscellaneous data' timeout \n", acb->host->host_no);=0A=
-		return NULL;=0A=
+		return false;=0A=
 	}=0A=
-=0A=
-	if (mode =3D=3D 1) {=0A=
 		count =3D 8;=0A=
 		while (count) {=0A=
 			*acb_firm_model =3D readb(iop_firm_model);=0A=
@@ -1954,44 +1936,61 @@ static void *arcmsr_get_hba_config(struc=0A=
 			iop_device_map++;=0A=
 			count--;=0A=
 		}=0A=
-=0A=
-		printk(KERN_INFO 	"ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n"=0A=
-			, acb->host->host_no=0A=
-			, acb->firm_version);=0A=
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",=0A=
+		acb->host->host_no,=0A=
+		acb->firm_version,=0A=
+		acb->firm_model);=0A=
 		acb->signature =3D readl(&reg->message_rwbuffer[0]);=0A=
 		acb->firm_request_len =3D readl(&reg->message_rwbuffer[1]);=0A=
 		acb->firm_numbers_queue =3D readl(&reg->message_rwbuffer[2]);=0A=
 		acb->firm_sdram_size =3D readl(&reg->message_rwbuffer[3]);=0A=
 		acb->firm_hd_channels =3D readl(&reg->message_rwbuffer[4]);=0A=
+	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/=0A=
+	return true;=0A=
 	}=0A=
-	return reg->message_rwbuffer;=0A=
-}=0A=
-static void __iomem *arcmsr_get_hbb_config(struct AdapterControlBlock =
*acb, int mode)=0A=
+static bool arcmsr_get_hbb_config(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-	uint32_t __iomem *lrwbuffer =3D reg->msgcode_rwbuffer_reg;=0A=
+	struct pci_dev *pdev =3D acb->pdev;=0A=
+	void *dma_coherent;=0A=
+	dma_addr_t dma_coherent_handle;=0A=
 	char *acb_firm_model =3D acb->firm_model;=0A=
 	char *acb_firm_version =3D acb->firm_version;=0A=
 	char *acb_device_map =3D acb->device_map;=0A=
-	char __iomem *iop_firm_model =3D (char __iomem *)(&lrwbuffer[15]);=0A=
+	char __iomem *iop_firm_model;=0A=
 	/*firm_model,15,60-67*/=0A=
-	char __iomem *iop_firm_version =3D (char __iomem *)(&lrwbuffer[17]);=0A=
+	char __iomem *iop_firm_version;=0A=
 	/*firm_version,17,68-83*/=0A=
-	char __iomem *iop_device_map =3D (char __iomem *) (&lrwbuffer[21]);=0A=
+	char __iomem *iop_device_map;=0A=
 	/*firm_version,21,84-99*/=0A=
 	int count;=0A=
+	dma_coherent =3D dma_alloc_coherent(&pdev->dev, sizeof(struct =
MessageUnit_B), &dma_coherent_handle, GFP_KERNEL);=0A=
+	if (!dma_coherent) {=0A=
+		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error for hbb =
mu\n", acb->host->host_no);=0A=
+		return false;=0A=
+	}=0A=
+	acb->dma_coherent_handle_hbb_mu =3D dma_coherent_handle;=0A=
+	reg =3D (struct MessageUnit_B *)dma_coherent;=0A=
+	acb->pmuB =3D reg;=0A=
+	reg->drv2iop_doorbell =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);=0A=
+	reg->drv2iop_doorbell_mask =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);=0A=
+	reg->iop2drv_doorbell =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);=0A=
+	reg->iop2drv_doorbell_mask =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);=0A=
+	reg->message_wbuffer =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_WBUFFER);=0A=
+	reg->message_rbuffer =3D  (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_RBUFFER);=0A=
+	reg->message_rwbuffer =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_RWBUFFER);=0A=
+	iop_firm_model =3D (char __iomem *)(&reg->message_rwbuffer[15]);	=
/*firm_model,15,60-67*/=0A=
+	iop_firm_version =3D (char __iomem *)(&reg->message_rwbuffer[17]);	=
/*firm_version,17,68-83*/=0A=
+	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]);	=
/*firm_version,21,84-99*/=0A=
 =0A=
-	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);=0A=
+	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);=0A=
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
 			miscellaneous data' timeout \n", acb->host->host_no);=0A=
-		return NULL;=0A=
+		return false;=0A=
 	}=0A=
-=0A=
-	if (mode =3D=3D 1) {=0A=
 		count =3D 8;=0A=
-		while (count)=0A=
-		{=0A=
+	while (count) {=0A=
 			*acb_firm_model =3D readb(iop_firm_model);=0A=
 			acb_firm_model++;=0A=
 			iop_firm_model++;=0A=
@@ -1997,10 +1996,8 @@ static void __iomem *arcmsr_get_hbb_conf=0A=
 			iop_firm_model++;=0A=
 			count--;=0A=
 		}=0A=
-=0A=
 		count =3D 16;=0A=
-		while (count)=0A=
-		{=0A=
+	while (count) {=0A=
 			*acb_firm_version =3D readb(iop_firm_version);=0A=
 			acb_firm_version++;=0A=
 			iop_firm_version++;=0A=
@@ -2015,46 +2012,41 @@ static void __iomem *arcmsr_get_hbb_conf=0A=
 			count--;=0A=
 		}=0A=
 =0A=
-		printk(KERN_INFO "ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n",=0A=
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",=0A=
 				acb->host->host_no,=0A=
-				acb->firm_version);=0A=
+		acb->firm_version,=0A=
+		acb->firm_model);=0A=
 =0A=
-		acb->signature =3D readl(lrwbuffer++);=0A=
+	acb->signature =3D readl(&reg->message_rwbuffer[1]);=0A=
 		/*firm_signature,1,00-03*/=0A=
-		acb->firm_request_len =3D readl(lrwbuffer++);=0A=
+	acb->firm_request_len =3D readl(&reg->message_rwbuffer[2]);=0A=
 		/*firm_request_len,1,04-07*/=0A=
-		acb->firm_numbers_queue =3D readl(lrwbuffer++);=0A=
+	acb->firm_numbers_queue =3D readl(&reg->message_rwbuffer[3]);=0A=
 		/*firm_numbers_queue,2,08-11*/=0A=
-		acb->firm_sdram_size =3D readl(lrwbuffer++);=0A=
+	acb->firm_sdram_size =3D readl(&reg->message_rwbuffer[4]);=0A=
 		/*firm_sdram_size,3,12-15*/=0A=
-		acb->firm_hd_channels =3D readl(lrwbuffer);=0A=
+	acb->firm_hd_channels =3D readl(&reg->message_rwbuffer[5]);=0A=
 		/*firm_ide_channels,4,16-19*/=0A=
+	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/=0A=
+	/*firm_ide_channels,4,16-19*/=0A=
+	return true;=0A=
 	}=0A=
-	return reg->msgcode_rwbuffer_reg;=0A=
-}=0A=
-static void *arcmsr_get_firmware_spec(struct AdapterControlBlock *acb, =
int mode)=0A=
+static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	void *rtnval =3D 0;=0A=
-	switch (acb->adapter_type) {=0A=
-	case ACB_ADAPTER_TYPE_A: {=0A=
-		rtnval =3D arcmsr_get_hba_config(acb, mode);=0A=
-		}=0A=
-		break;=0A=
-=0A=
-	case ACB_ADAPTER_TYPE_B: {=0A=
-		rtnval =3D arcmsr_get_hbb_config(acb, mode);=0A=
-		}=0A=
-		break;=0A=
-	}=0A=
-	return rtnval;=0A=
+	if (acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_A)=0A=
+		return arcmsr_get_hba_config(acb);=0A=
+	else=0A=
+		return arcmsr_get_hbb_config(acb);=0A=
 }=0A=
 =0A=
-static void arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,=0A=
+static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,=0A=
 	struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	struct CommandControlBlock *ccb;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
 	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done =3D 0, poll_count =
=3D 0;=0A=
+	int rtn;=0A=
 =0A=
 	polling_hba_ccb_retry:=0A=
 	poll_count++;=0A=
@@ -2062,16 +2054,19 @@ static void arcmsr_polling_hba_ccbdone(s=0A=
 	writel(outbound_intstatus, &reg->outbound_intstatus);/*clear =
interrupt*/=0A=
 	while (1) {=0A=
 		if ((flag_ccb =3D readl(&reg->outbound_queueport)) =3D=3D 0xFFFFFFFF) =
{=0A=
-			if (poll_ccb_done)=0A=
+			if (poll_ccb_done) {=0A=
+				rtn =3D SUCCESS;=0A=
 				break;=0A=
-			else {=0A=
-				msleep(25);=0A=
-				if (poll_count > 100)=0A=
+			} else {=0A=
+				if (poll_count > 100) {=0A=
+					rtn =3D FAILED;=0A=
 					break;=0A=
+				}=0A=
 				goto polling_hba_ccb_retry;=0A=
 			}=0A=
 		}=0A=
-		ccb =3D (struct CommandControlBlock *)(acb->vir2phy_offset + =
(flag_ccb << 5));=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));=0A=
+		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
 		poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1:0;=0A=
 		if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
 			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) || (ccb =3D=3D =
poll_ccb)) {=0A=
@@ -2082,8 +2077,7 @@ static void arcmsr_polling_hba_ccbdone(s=0A=
 					, ccb->pcmd->device->lun=0A=
 					, ccb);=0A=
 				ccb->pcmd->result =3D DID_ABORT << 16;=0A=
-				arcmsr_ccb_complete(ccb, 1);=0A=
-				poll_ccb_done =3D 1;=0A=
+				arcmsr_ccb_complete(ccb);=0A=
 				continue;=0A=
 			}=0A=
 			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"=0A=
@@ -2093,32 +2087,38 @@ static void arcmsr_polling_hba_ccbdone(s=0A=
 				, ccb=0A=
 				, atomic_read(&acb->ccboutstandingcount));=0A=
 			continue;=0A=
-		}=0A=
+		} else {=0A=
 		arcmsr_report_ccb_state(acb, ccb, flag_ccb);=0A=
 	}=0A=
 }=0A=
+	return rtn;=0A=
+}=0A=
 =0A=
-static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,=0A=
+static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,=0A=
 					struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
 		struct CommandControlBlock *ccb;=0A=
 		uint32_t flag_ccb, poll_ccb_done =3D 0, poll_count =3D 0;=0A=
-		int index;=0A=
+	int index, rtn;=0A=
 =0A=
 	polling_hbb_ccb_retry:=0A=
 		poll_count++;=0A=
 		/* clear doorbell interrupt */=0A=
-		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);=0A=
+	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
 		while (1) {=0A=
 			index =3D reg->doneq_index;=0A=
 			if ((flag_ccb =3D readl(&reg->done_qbuffer[index])) =3D=3D 0) {=0A=
-				if (poll_ccb_done)=0A=
+			if (poll_ccb_done) {=0A=
+				rtn =3D SUCCESS;=0A=
 					break;=0A=
-				else {=0A=
+			} else {=0A=
 					msleep(25);=0A=
-					if (poll_count > 100)=0A=
+				if (poll_count > 100) {=0A=
+					rtn =3D FAILED;=0A=
 						break;=0A=
+				}=0A=
 					goto polling_hbb_ccb_retry;=0A=
 				}=0A=
 			}=0A=
@@ -2128,19 +2128,19 @@ static void arcmsr_polling_hbb_ccbdone(s=0A=
 			index %=3D ARCMSR_MAX_HBB_POSTQUEUE;=0A=
 			reg->doneq_index =3D index;=0A=
 			/* check ifcommand done with no error*/=0A=
-			ccb =3D (struct CommandControlBlock *)\=0A=
-      (acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes =
aligned*/=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));=0A=
+		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
 			poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1:0;=0A=
 			if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
 				if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) || (ccb =3D=3D =
poll_ccb)) {=0A=
-					printk(KERN_NOTICE "arcmsr%d: \=0A=
-		scsi id =3D %d lun =3D %d ccb =3D '0x%p' poll command abort =
successfully \n"=0A=
+				printk(KERN_NOTICE "arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D =
'0x%p'"=0A=
+					" poll command abort successfully \n"=0A=
 						,acb->host->host_no=0A=
 						,ccb->pcmd->device->id=0A=
 						,ccb->pcmd->device->lun=0A=
 						,ccb);=0A=
 					ccb->pcmd->result =3D DID_ABORT << 16;=0A=
-					arcmsr_ccb_complete(ccb, 1);=0A=
+				arcmsr_ccb_complete(ccb);=0A=
 					continue;=0A=
 				}=0A=
 				printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"=0A=
@@ -2150,30 +2150,34 @@ static void arcmsr_polling_hbb_ccbdone(s=0A=
 					, ccb=0A=
 					, atomic_read(&acb->ccboutstandingcount));=0A=
 				continue;=0A=
-			}=0A=
+		} else {=0A=
 			arcmsr_report_ccb_state(acb, ccb, flag_ccb);=0A=
+		}=0A=
 		}	/*drain reply FIFO*/=0A=
+	return rtn;=0A=
 }=0A=
 =0A=
-static void arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
+static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
 					struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
+	int rtn =3D 0;=0A=
 	switch (acb->adapter_type) {=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		arcmsr_polling_hba_ccbdone(acb,poll_ccb);=0A=
+		rtn =3D arcmsr_polling_hba_ccbdone(acb, poll_ccb);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		arcmsr_polling_hbb_ccbdone(acb,poll_ccb);=0A=
+		rtn =3D arcmsr_polling_hbb_ccbdone(acb, poll_ccb);=0A=
 		}=0A=
 	}=0A=
+	return rtn;=0A=
 }=0A=
 =0A=
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	uint32_t cdb_phyaddr, ccb_phyaddr_hi32;=0A=
+	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;=0A=
 	dma_addr_t dma_coherent_handle;=0A=
 	/*=0A=
 	********************************************************************=0A=
@@ -2183,7 +2187,7 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 	*/=0A=
 	dma_coherent_handle =3D acb->dma_coherent_handle;=0A=
 	cdb_phyaddr =3D (uint32_t)(dma_coherent_handle);=0A=
-	ccb_phyaddr_hi32 =3D (uint32_t)((cdb_phyaddr >> 16) >> 16);=0A=
+	cdb_phyaddr_hi32 =3D (uint32_t)((cdb_phyaddr >> 16) >> 16);=0A=
 	/*=0A=
 	***********************************************************************=0A=
 	**    if adapter type B, set window of "post command Q"=0A=
@@ -2192,13 +2196,13 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 	switch (acb->adapter_type) {=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		if (ccb_phyaddr_hi32 !=3D 0) {=0A=
+		if (cdb_phyaddr_hi32 !=3D 0) {=0A=
 			struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 			uint32_t intmask_org;=0A=
 			intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 			writel(ARCMSR_SIGNATURE_SET_CONFIG, \=0A=
 						&reg->message_rwbuffer[0]);=0A=
-			writel(ccb_phyaddr_hi32, &reg->message_rwbuffer[1]);=0A=
+			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);=0A=
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \=0A=
 							&reg->inbound_msgaddr0);=0A=
 			if (arcmsr_hba_wait_msgint_ready(acb)) {=0A=
@@ -2221,19 +2225,18 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 		reg->postq_index =3D 0;=0A=
 		reg->doneq_index =3D 0;=0A=
-		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell_reg);=0A=
+		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);=0A=
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \=0A=
 				acb->host->host_no);=0A=
 			return 1;=0A=
 		}=0A=
-		post_queue_phyaddr =3D cdb_phyaddr + ARCMSR_MAX_FREECCB_NUM * \=0A=
-		sizeof(struct CommandControlBlock) + offsetof(struct MessageUnit_B, =
post_qbuffer) ;=0A=
-		rwbuffer =3D reg->msgcode_rwbuffer_reg;=0A=
+		post_queue_phyaddr =3D acb->dma_coherent_handle_hbb_mu;=0A=
+		rwbuffer =3D reg->message_rwbuffer;=0A=
 		/* driver "set config" signature */=0A=
 		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);=0A=
 		/* normal should be zero */=0A=
-		writel(ccb_phyaddr_hi32, rwbuffer++);=0A=
+		writel(cdb_phyaddr_hi32, rwbuffer++);=0A=
 		/* postQ size (256 + 8)*4	 */=0A=
 		writel(post_queue_phyaddr, rwbuffer++);=0A=
 		/* doneQ size (256 + 8)*4	 */=0A=
@@ -2241,19 +2244,13 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 		/* ccb maxQ size must be --> [(256 + 8)*4]*/=0A=
 		writel(1056, rwbuffer);=0A=
 =0A=
-		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell_reg);=0A=
+		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);=0A=
 		if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \=0A=
 			timeout \n",acb->host->host_no);=0A=
 			return 1;=0A=
 		}=0A=
-=0A=
-		writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell_reg);=0A=
-		if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: 'can not set diver mode \n"\=0A=
-			,acb->host->host_no);=0A=
-			return 1;=0A=
-		}=0A=
+		arcmsr_hbb_enable_driver_mode(acb);=0A=
 		arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
 		}=0A=
 		break;=0A=
@@ -2278,9 +2275,9 @@ static void arcmsr_wait_firmware_ready(s=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 		do {=0A=
-			firmware_state =3D readl(reg->iop2drv_doorbell_reg);=0A=
+			firmware_state =3D readl(reg->iop2drv_doorbell);=0A=
 		} while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
-		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);=0A=
+		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
@@ -2289,22 +2286,19 @@ static void arcmsr_wait_firmware_ready(s=0A=
 static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-=0A=
-	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0)) {=0A=
-		acb->fw_state =3D false;=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0)) {=0A=
+		return;=0A=
 	} else {=0A=
-	/*to prevent rq_map_token from changing by other interrupt, then=0A=
-	avoid the dead-lock*/=0A=
-		acb->fw_state =3D true;=0A=
-		atomic_dec(&acb->rq_map_token);=0A=
-		if (!(acb->fw_state) ||=0A=
-			(acb->ante_token_value =3D=3D atomic_read(&acb->rq_map_token))) {=0A=
+		acb->fw_flag =3D FW_NORMAL;=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)) {=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
-		acb->ante_token_value =3D atomic_read(&acb->rq_map_token);=0A=
+		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
+		if (atomic_dec_and_test(&acb->rq_map_token))=0A=
+			return;=0A=
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
 	}=0A=
-	mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6000));=0A=
 	return;=0A=
 }=0A=
 =0A=
@@ -2312,21 +2306,19 @@ static void arcmsr_request_hbb_device_ma=0A=
 {=0A=
 	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 =0A=
-	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0)) {=0A=
-		acb->fw_state =3D false;=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0)) {=0A=
+		return;=0A=
 	} else {=0A=
-	/*to prevent rq_map_token from changing by other interrupt, then=0A=
-	avoid the dead-lock*/=0A=
-		acb->fw_state =3D true;=0A=
-		atomic_dec(&acb->rq_map_token);=0A=
-		if (!(acb->fw_state) ||=0A=
-			(acb->ante_token_value =3D=3D atomic_read(&acb->rq_map_token))) {=0A=
+		acb->fw_flag =3D FW_NORMAL;=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)) {=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
-		acb->ante_token_value =3D atomic_read(&acb->rq_map_token);=0A=
-		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);=0A=
+		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
+		if (atomic_dec_and_test(&acb->rq_map_token))=0A=
+			return;=0A=
+		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);=0A=
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
 	}=0A=
-	mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6000));=0A=
 	return;=0A=
 }=0A=
 =0A=
@@ -2361,7 +2353,7 @@ static void arcmsr_start_hbb_bgrb(struct=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	acb->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
-	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell_reg);=0A=
+	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);=0A=
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \=0A=
 				rebulid' timeout \n",acb->host->host_no);=0A=
@@ -2397,8 +2389,8 @@ static void arcmsr_clear_doorbell_queue_=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 		/*clear interrupt and message state*/=0A=
-		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);=0A=
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell_reg);=0A=
+		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);=0A=
 		/* let IOP know data has been read */=0A=
 		}=0A=
 		break;=0A=
@@ -2413,7 +2405,7 @@ static void arcmsr_enable_eoi_mode(struc=0A=
 	case ACB_ADAPTER_TYPE_B:=0A=
 		{=0A=
 			struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell_reg);=0A=
+			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);=0A=
 			if(arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 				printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");=0A=
 				return;=0A=
@@ -2428,13 +2420,19 @@ static void arcmsr_hardware_reset(struct=0A=
 {=0A=
 	uint8_t value[64];=0A=
 	int i;=0A=
+	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 =0A=
 	/* backup pci config data */=0A=
+	printk(KERN_ERR "arcmsr%d: executing hw bus reset .....\n", =
acb->host->host_no);=0A=
 	for (i =3D 0; i < 64; i++) {=0A=
 		pci_read_config_byte(acb->pdev, i, &value[i]);=0A=
 	}=0A=
 	/* hardware reset signal */=0A=
+	if ((acb->dev_id =3D=3D 0x1680)) {=0A=
+		writel(ARCMSR_ARC1680_BUS_RESET, &reg->reserved1[0]);=0A=
+	} else {=0A=
 	pci_write_config_byte(acb->pdev, 0x84, 0x20);=0A=
+	}=0A=
 	msleep(1000);=0A=
 	/* write back pci config data */=0A=
 	for (i =3D 0; i < 64; i++) {=0A=
@@ -2447,37 +2445,25 @@ static void arcmsr_hardware_reset(struct=0A=
 =
*************************************************************************=
***=0A=
 =
*************************************************************************=
***=0A=
 */=0A=
-#ifdef CONFIG_SCSI_ARCMSR_RESET=0A=
 	int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)=0A=
 	{=0A=
 			struct Scsi_Host *shost =3D NULL;=0A=
-			spinlock_t *host_lock =3D NULL;=0A=
 			int i, isleep;=0A=
 =0A=
 			shost =3D cmd->device->host;=0A=
-			host_lock =3D shost->host_lock;=0A=
-=0A=
-			printk(KERN_NOTICE "Host %d bus reset over, sleep %d seconds (busy =
%d, can queue %d) ...........\n",=0A=
-					shost->host_no, sleeptime, shost->host_busy, shost->can_queue);=0A=
 			isleep =3D sleeptime / 10;=0A=
-			spin_unlock_irq(host_lock);=0A=
 			if (isleep > 0) {=0A=
 				for (i =3D 0; i < isleep; i++) {=0A=
 					msleep(10000);=0A=
-					printk(KERN_NOTICE "^%d^\n", i);=0A=
 				}=0A=
 			}=0A=
 =0A=
 			isleep =3D sleeptime % 10;=0A=
 			if (isleep > 0) {=0A=
 				msleep(isleep * 1000);=0A=
-				printk(KERN_NOTICE "^v^\n");=0A=
 			}=0A=
-			spin_lock_irq(host_lock);=0A=
-			printk(KERN_NOTICE "***** wake up *****\n");=0A=
 			return 0;=0A=
 	}=0A=
-#endif=0A=
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t intmask_org;=0A=
@@ -2486,7 +2472,6 @@ static void arcmsr_iop_init(struct Adapt=0A=
        intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 	arcmsr_wait_firmware_ready(acb);=0A=
 	arcmsr_iop_confirm(acb);=0A=
-	arcmsr_get_firmware_spec(acb, 1);=0A=
 	/*start background rebuild*/=0A=
 	arcmsr_start_adapter_bgrb(acb);=0A=
 	/* empty doorbell Qbuffer if door bell ringed */=0A=
@@ -2509,14 +2493,12 @@ static uint8_t arcmsr_iop_reset(struct A=0A=
 		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 		/* talk to iop 331 outstanding command aborted */=0A=
 		rtnval =3D arcmsr_abort_allcmd(acb);=0A=
-		/* wait for 3 sec for all command aborted*/=0A=
-		ssleep(3);=0A=
 		/* clear all outbound posted Q */=0A=
 		arcmsr_done4abort_postqueue(acb);=0A=
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
 			ccb =3D acb->pccb_pool[i];=0A=
 			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {=0A=
-				arcmsr_ccb_complete(ccb, 1);=0A=
+				arcmsr_ccb_complete(ccb);=0A=
 			}=0A=
 		}=0A=
 		atomic_set(&acb->ccboutstandingcount, 0);=0A=
@@ -2531,54 +2513,49 @@ static int arcmsr_bus_reset(struct scsi_=0A=
 {=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;=0A=
-	int retry =3D 0;=0A=
-=0A=
-	if (acb->acb_flags & ACB_F_BUS_RESET)=0A=
-		return SUCCESS;=0A=
+	uint32_t intmask_org, outbound_doorbell;=0A=
+	int retry_count =3D 0;=0A=
+	int rtn =3D FAILED;=0A=
 =0A=
-	printk(KERN_NOTICE "arcmsr%d: bus reset ..... \n", acb->adapter_index);=0A=
-	acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+	acb =3D (struct AdapterControlBlock *) cmd->device->host->hostdata;=0A=
+	printk(KERN_ERR "arcmsr: executing eh bus reset .....num_resets =3D %d,=0A=
+		num_aborts =3D %d \n", acb->num_resets, acb->num_aborts);=0A=
 	acb->num_resets++;=0A=
-	while (atomic_read(&acb->ccboutstandingcount) !=3D 0 && retry < 4) {=0A=
-		arcmsr_interrupt(acb);=0A=
-		retry++;=0A=
-	}=0A=
 =0A=
-	if (arcmsr_iop_reset(acb)) {=0A=
 		switch (acb->adapter_type) {=0A=
 		case ACB_ADAPTER_TYPE_A: {=0A=
-			printk(KERN_NOTICE "arcmsr%d: do hardware bus reset, num_resets =3D =
%d num_aborts =3D %d \n",=0A=
-				acb->adapter_index, acb->num_resets, acb->num_aborts);=0A=
+			if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
+				long timeout;=0A=
+				timeout =3D wait_event_timeout(wait_q,=0A=
+					(acb->acb_flags & ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);=0A=
+				if (timeout) {=0A=
+					return SUCCESS;=0A=
+				}=0A=
+			}=0A=
+			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+			if (arcmsr_iop_reset(acb)) {=0A=
+				struct MessageUnit_A __iomem *reg;=0A=
+				reg =3D acb->pmuA;=0A=
 			arcmsr_hardware_reset(acb);=0A=
-			acb->acb_flags |=3D ACB_F_FIRMWARE_TRAP;=0A=
 			acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
-			#ifdef CONFIG_SCSI_ARCMSR_RESET=0A=
-			struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-			uint32_t intmask_org, outbound_doorbell;=0A=
-			int retry_count =3D 0;=0A=
 sleep_again:=0A=
 			arcmsr_sleep_for_bus_reset(cmd);=0A=
-			if ((readl(&reg->outbound_msgaddr1) &=0A=
-			ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: hardware bus reset and return busy, =
retry=3D%d \n",=0A=
-			acb->host->host_no, retry_count);=0A=
+				if ((readl(&reg->outbound_msgaddr1) & =
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0) {=0A=
+					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,=0A=
+						retry=3D%d \n", acb->host->host_no, retry_count);=0A=
 			if (retry_count > retrycount) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: hardware bus reset and return busy, =
retry aborted \n",=0A=
-				acb->host->host_no);=0A=
-			return SUCCESS;=0A=
+						acb->fw_flag =3D FW_DEADLOCK;=0A=
+						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,=0A=
+							RETRY TERMINATED!! \n", acb->host->host_no);=0A=
+						return FAILED;=0A=
 			}=0A=
 			retry_count++;=0A=
 			goto sleep_again;=0A=
 			}=0A=
-			acb->acb_flags &=3D ~ACB_F_FIRMWARE_TRAP;=0A=
 			acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
-			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-			printk(KERN_NOTICE "arcmsr%d: hardware bus reset and reset ok \n",=0A=
-				acb->host->host_no);=0A=
 			/* disable all outbound interrupt */=0A=
 			intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-			arcmsr_get_firmware_spec(acb, 1);=0A=
-			/*start	background rebuild*/=0A=
+				arcmsr_get_firmware_spec(acb);=0A=
 			arcmsr_start_adapter_bgrb(acb);=0A=
 			/* clear Qbuffer if door bell ringed */=0A=
 			outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
@@ -2587,38 +2564,74 @@ sleep_again:=0A=
 			/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
 			arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
+				atomic_set(&acb->ante_token_value, 16);=0A=
+				acb->fw_flag =3D FW_NORMAL;=0A=
 			init_timer(&acb->eternal_timer);=0A=
-			acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(20*HZ);=0A=
+				acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6*HZ);=0A=
 			acb->eternal_timer.data =3D (unsigned long) acb;=0A=
 			acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
 			add_timer(&acb->eternal_timer);=0A=
-			#endif=0A=
+				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+				rtn =3D SUCCESS;=0A=
+				printk(KERN_ERR "arcmsr: scsi eh bus reset succeeds\n");=0A=
+			} else {=0A=
+				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+				if (atomic_read(&acb->rq_map_token) =3D=3D 0) {=0A=
+					atomic_set(&acb->rq_map_token, 16);=0A=
+					atomic_set(&acb->ante_token_value, 16);=0A=
+					acb->fw_flag =3D FW_NORMAL;=0A=
+					init_timer(&acb->eternal_timer);=0A=
+						acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6*HZ);=0A=
+					acb->eternal_timer.data =3D (unsigned long) acb;=0A=
+					acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
+					add_timer(&acb->eternal_timer);=0A=
+				} else {=0A=
+					atomic_set(&acb->rq_map_token, 16);=0A=
+					atomic_set(&acb->ante_token_value, 16);=0A=
+					acb->fw_flag =3D FW_NORMAL;=0A=
+					mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
 		}=0A=
-		break;=0A=
-		case ACB_ADAPTER_TYPE_B: {=0A=
+				rtn =3D SUCCESS;=0A=
 		}=0A=
+			break;=0A=
 		}=0A=
+		case ACB_ADAPTER_TYPE_B:{=0A=
+			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+			if (arcmsr_iop_reset(acb)) {=0A=
+				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+				rtn =3D FAILED;=0A=
 	} else {=0A=
        		 acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+				if (atomic_read(&acb->rq_map_token) =3D=3D 0) {=0A=
+					atomic_set(&acb->rq_map_token, 16);=0A=
+					atomic_set(&acb->ante_token_value, 16);=0A=
+					acb->fw_flag =3D FW_NORMAL;=0A=
+					init_timer(&acb->eternal_timer);=0A=
+						acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6*HZ);=0A=
+					acb->eternal_timer.data =3D (unsigned long) acb;=0A=
+					acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
+					add_timer(&acb->eternal_timer);=0A=
+				} else {=0A=
+					atomic_set(&acb->rq_map_token, 16);=0A=
+					atomic_set(&acb->ante_token_value, 16);=0A=
+					acb->fw_flag =3D FW_NORMAL;=0A=
+					mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
+				}=0A=
+				rtn =3D SUCCESS;=0A=
 	}=0A=
-	return SUCCESS;=0A=
+		}=0A=
+	}=0A=
+	return rtn;=0A=
 }=0A=
 =0A=
-static void arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,=0A=
+static int arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,=0A=
 		struct CommandControlBlock *ccb)=0A=
 {=0A=
-	u32 intmask;=0A=
-=0A=
-	ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
-=0A=
-	/*=0A=
-	** Wait for 3 sec for all command done.=0A=
-	*/=0A=
-	ssleep(3);=0A=
-=0A=
-	intmask =3D arcmsr_disable_outbound_ints(acb);=0A=
-	arcmsr_polling_ccbdone(acb, ccb);=0A=
-	arcmsr_enable_outbound_ints(acb, intmask);=0A=
+	int rtn;=0A=
+	spin_lock_irq(&acb->eh_lock);=0A=
+	rtn =3D arcmsr_polling_ccbdone(acb, ccb);=0A=
+	spin_unlock_irq(&acb->eh_lock);=0A=
+	return rtn;=0A=
 }=0A=
 =0A=
 static int arcmsr_abort(struct scsi_cmnd *cmd)=0A=
@@ -2626,10 +2639,12 @@ static int arcmsr_abort(struct scsi_cmnd=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;=0A=
 	int i =3D 0;=0A=
+	int rtn =3D FAILED;=0A=
 =0A=
 	printk(KERN_NOTICE=0A=
 		"arcmsr%d: abort device command of scsi id =3D %d lun =3D %d \n",=0A=
 		acb->host->host_no, cmd->device->id, cmd->device->lun);=0A=
+	acb->acb_flags |=3D ACB_F_ABORT;=0A=
 	acb->num_aborts++;=0A=
 	/*=0A=
 	************************************************=0A=
@@ -2638,17 +2653,19 @@ static int arcmsr_abort(struct scsi_cmnd=0A=
 	************************************************=0A=
 	*/=0A=
 	if (!atomic_read(&acb->ccboutstandingcount))=0A=
-		return SUCCESS;=0A=
+		return rtn;=0A=
 =0A=
 	for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
+		printk(KERN_NOTICE "%s: loop %d\n", __func__, i);=0A=
 		struct CommandControlBlock *ccb =3D acb->pccb_pool[i];=0A=
 		if (ccb->startdone =3D=3D ARCMSR_CCB_START && ccb->pcmd =3D=3D cmd) {=0A=
-			arcmsr_abort_one_cmd(acb, ccb);=0A=
+			ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
+			rtn =3D arcmsr_abort_one_cmd(acb, ccb);=0A=
 			break;=0A=
 		}=0A=
 	}=0A=
-=0A=
-	return SUCCESS;=0A=
+	acb->acb_flags &=3D ~ACB_F_ABORT;=0A=
+	return rtn;=0A=
 }=0A=
 =0A=
 static const char *arcmsr_info(struct Scsi_Host *host)=0A=

------=_NextPart_000_000C_01CAEB7B.26347FC0--
