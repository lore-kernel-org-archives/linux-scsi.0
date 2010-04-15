From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 3/3 ] SCSI: Support Type C RAID controller
Date: Thu, 15 Apr 2010 14:01:28 +0800
Message-ID: <60FF59AA20D44726B3BB8DCBA9775ADC@areca4e4f859d4>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0009_01CADCA4.26EBB810"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43909 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab0DOGBp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2010 02:01:45 -0400
References: 
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0009_01CADCA4.26EBB810
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

1. To support Type C RAID controller, ACB_ADAPTER_TYPE_C, i.e. PCI device
ID: 0x1880.
Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >
---

------=_NextPart_000_0009_01CADCA4.26EBB810
Content-Type: application/octet-stream;
	name="patch3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch3"

diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr.h =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-100202/arcmsr.h=0A=
--- linux-2.6/drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr.h	2010-04-14 =
19:25:24.000000000 +0800=0A=
+++ linux-2.6/drivers/scsi/arcmsr.1.20.00.15-100202/arcmsr.h	2010-04-14 =
19:29:02.000000000 +0800=0A=
@@ -48,7 +47,7 @@ struct device_attribute;=0A=
 /*The limit of outstanding scsi command that firmware can handle*/=0A=
 #define ARCMSR_MAX_OUTSTANDING_CMD						256=0A=
 #define ARCMSR_MAX_FREECCB_NUM							320=0A=
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2009/12/09"=0A=
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2010/02/02"=0A=
 #define ARCMSR_SCSI_INITIATOR_ID						255=0A=
 #define ARCMSR_MAX_XFER_SECTORS							512=0A=
 #define ARCMSR_MAX_XFER_SECTORS_B						4096=0A=
@@ -61,6 +60,7 @@ struct device_attribute;=0A=
 #define ARCMSR_MAX_HBB_POSTQUEUE						264=0A=
 #define ARCMSR_MAX_XFER_LEN							0x26000 /* 152K */=0A=
 #define ARCMSR_CDB_SG_PAGE_LENGTH						256=0A=
+#define SCSI_CMD_ARECA_SPECIFIC						0xE1=0A=
 #ifndef PCI_DEVICE_ID_ARECA_1880=0A=
 #define PCI_DEVICE_ID_ARECA_1880 0x1880=0A=
  #endif=0A=
@@ -223,11 +223,15 @@ struct FIRMWARE_INFO=0A=
 #define ARCMSR_CCBPOST_FLAG_SGL_BSIZE                 0x80000000=0A=
 #define ARCMSR_CCBPOST_FLAG_IAM_BIOS                  0x40000000=0A=
 #define ARCMSR_CCBREPLY_FLAG_IAM_BIOS                 0x40000000=0A=
-#define ARCMSR_CCBREPLY_FLAG_ERROR                    0x10000000=0A=
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0              0x10000000=0A=
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1              0x00000001=0A=
 /* outbound firmware ok */=0A=
 #define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000=0A=
 /* ARC-1680 Bus Reset*/=0A=
 #define ARCMSR_ARC1680_BUS_RESET				0x00000003=0A=
+/* ARC-1880 Bus Reset*/=0A=
+#define ARCMSR_ARC1880_RESET_ADAPTER				0x00000024=0A=
+#define ARCMSR_ARC1880_DiagWrite_ENABLE			0x00000080=0A=
 =0A=
 /*=0A=
 ************************************************************************=0A=
@@ -285,6 +289,61 @@ struct FIRMWARE_INFO=0A=
 /* iop message_rwbuffer for message command */=0A=
 #define ARCMSR_MESSAGE_RWBUFFER			      0x0000fa00=0A=
 /*=0A=
+************************************************************************=0A=
+**                SPEC. for Areca HBC adapter=0A=
+************************************************************************=0A=
+*/=0A=
+#define ARCMSR_HBC_ISR_THROTTLING_LEVEL		12=0A=
+#define ARCMSR_HBC_ISR_MAX_DONE_QUEUE		20=0A=
+/* Host Interrupt Mask */=0A=
+#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK		0x00000001 /* When clear, the =
Utility_A interrupt routes to the host.*/=0A=
+#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK	0x00000004 /* When =
clear, the General Outbound Doorbell interrupt routes to the host.*/=0A=
+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK	0x00000008 /* When =
clear, the Outbound Post List FIFO Not Empty interrupt routes to the =
host.*/=0A=
+#define ARCMSR_HBCMU_ALL_INTMASKENABLE		0x0000000D /* disable all ISR */=0A=
+/* Host Interrupt Status */=0A=
+#define ARCMSR_HBCMU_UTILITY_A_ISR			0x00000001=0A=
+	/*=0A=
+	** Set when the Utility_A Interrupt bit is set in the Outbound =
Doorbell Register.=0A=
+	** It clears by writing a 1 to the Utility_A bit in the Outbound =
Doorbell Clear Register or through automatic clearing (if enabled).=0A=
+	*/=0A=
+#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR		0x00000004=0A=
+	/*=0A=
+	** Set if Outbound Doorbell register bits 30:1 have a non-zero=0A=
+	** value. This bit clears only when Outbound Doorbell bits=0A=
+	** 30:1 are ALL clear. Only a write to the Outbound Doorbell=0A=
+	** Clear register clears bits in the Outbound Doorbell register.=0A=
+	*/=0A=
+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR	0x00000008=0A=
+	/*=0A=
+	** Set whenever the Outbound Post List Producer/Consumer=0A=
+	** Register (FIFO) is not empty. It clears when the Outbound=0A=
+	** Post List FIFO is empty.=0A=
+	*/=0A=
+#define ARCMSR_HBCMU_SAS_ALL_INT			0x00000010=0A=
+	/*=0A=
+	** This bit indicates a SAS interrupt from a source external to=0A=
+	** the PCIe core. This bit is not maskable.=0A=
+	*/=0A=
+/* DoorBell*/=0A=
+#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK			0x00000002=0A=
+#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK			0x00000004=0A=
+/*inbound message 0 ready*/=0A=
+#define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE		0x00000008=0A=
+/*more than 12 request completed in a time*/=0A=
+#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING		0x00000010=0A=
+#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK			0x00000002=0A=
+/*outbound DATA WRITE isr door bell clear*/=0A=
+#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_DOORBELL_CLEAR	0x00000002=0A=
+#define ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK			0x00000004=0A=
+/*outbound DATA READ isr door bell clear*/=0A=
+#define ARCMSR_HBCMU_IOP2DRV_DATA_READ_DOORBELL_CLEAR	0x00000004=0A=
+/*outbound message 0 ready*/=0A=
+#define ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE		0x00000008=0A=
+/*outbound message cmd isr door bell clear*/=0A=
+#define ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR	0x00000008=0A=
+/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/=0A=
+#define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK			0x80000000=0A=
+/*=0A=
 =
*************************************************************************=
******=0A=
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)=0A=
 =
*************************************************************************=
******=0A=
@@ -321,7 +380,7 @@ struct ARCMSR_CDB=0A=
 		struct SG32ENTRY                sg32entry[1];=0A=
 		struct SG64ENTRY                sg64entry[1];=0A=
 	} u;=0A=
-} __attribute__ ((packed));=0A=
+};=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **     Messaging Unit (MU) of the Intel R 80331 I/O processor(Type A) =
and Type B processor=0A=
@@ -367,7 +426,81 @@ struct MessageUnit_B=0A=
 	uint32_t		__iomem *message_wbuffer;=0A=
 	uint32_t		__iomem *message_rbuffer;=0A=
 };=0A=
-=0A=
+/*=0A=
+*********************************************************************=0A=
+** LSI=0A=
+*********************************************************************=0A=
+*/=0A=
+struct MessageUnit_C{=0A=
+	uint32_t	message_unit_status;			/*0000 0003*/=0A=
+	uint32_t	slave_error_attribute;			/*0004 0007*/=0A=
+	uint32_t	slave_error_address;			/*0008 000B*/=0A=
+	uint32_t	posted_outbound_doorbell;		/*000C 000F*/=0A=
+	uint32_t	master_error_attribute;			/*0010 0013*/=0A=
+	uint32_t	master_error_address_low;		/*0014 0017*/=0A=
+	uint32_t	master_error_address_high;		/*0018 001B*/=0A=
+	uint32_t	hcb_size;				/*001C 001F*/=0A=
+	uint32_t	inbound_doorbell;			/*0020 0023*/=0A=
+	uint32_t	diagnostic_rw_data;			/*0024 0027*/=0A=
+	uint32_t	diagnostic_rw_address_low;		/*0028 002B*/=0A=
+	uint32_t	diagnostic_rw_address_high;		/*002C 002F*/=0A=
+	uint32_t	host_int_status;				/*0030 0033*/=0A=
+	uint32_t	host_int_mask;				/*0034 0037*/=0A=
+	uint32_t	dcr_data;				/*0038 003B*/=0A=
+	uint32_t	dcr_address;				/*003C 003F*/=0A=
+	uint32_t	inbound_queueport;			/*0040 0043*/=0A=
+	uint32_t	outbound_queueport;			/*0044 0047*/=0A=
+	uint32_t	hcb_pci_address_low;			/*0048 004B*/=0A=
+	uint32_t	hcb_pci_address_high;			/*004C 004F*/=0A=
+	uint32_t	iop_int_status;				/*0050 0053*/=0A=
+	uint32_t	iop_int_mask;				/*0054 0057*/=0A=
+	uint32_t	iop_inbound_queue_port;			/*0058 005B*/=0A=
+	uint32_t	iop_outbound_queue_port;		/*005C 005F*/=0A=
+	uint32_t	inbound_free_list_index;			/*0060 0063*/=0A=
+	uint32_t	inbound_post_list_index;			/*0064 0067*/=0A=
+	uint32_t	outbound_free_list_index;			/*0068 006B*/=0A=
+	uint32_t	outbound_post_list_index;			/*006C 006F*/=0A=
+	uint32_t	inbound_doorbell_clear;			/*0070 0073*/=0A=
+	uint32_t	i2o_message_unit_control;			/*0074 0077*/=0A=
+	uint32_t	last_used_message_source_address_low;	/*0078 007B*/=0A=
+	uint32_t	last_used_message_source_address_high;	/*007C 007F*/=0A=
+	uint32_t	pull_mode_data_byte_count[4];		/*0080 008F*/=0A=
+	uint32_t	message_dest_address_index;		/*0090 0093*/=0A=
+	uint32_t	done_queue_not_empty_int_counter_timer;	/*0094 0097*/=0A=
+	uint32_t	utility_A_int_counter_timer;		/*0098 009B*/=0A=
+	uint32_t	outbound_doorbell;			/*009C 009F*/=0A=
+	uint32_t	outbound_doorbell_clear;			/*00A0 00A3*/=0A=
+	uint32_t	message_source_address_index;		/*00A4 00A7*/=0A=
+	uint32_t	message_done_queue_index;		/*00A8 00AB*/=0A=
+	uint32_t	reserved0;				/*00AC 00AF*/=0A=
+	uint32_t	inbound_msgaddr0;			/*00B0 00B3*/=0A=
+	uint32_t	inbound_msgaddr1;			/*00B4 00B7*/=0A=
+	uint32_t	outbound_msgaddr0;			/*00B8 00BB*/=0A=
+	uint32_t	outbound_msgaddr1;			/*00BC 00BF*/=0A=
+	uint32_t	inbound_queueport_low;			/*00C0 00C3*/=0A=
+	uint32_t	inbound_queueport_high;			/*00C4 00C7*/=0A=
+	uint32_t	outbound_queueport_low;			/*00C8 00CB*/=0A=
+	uint32_t	outbound_queueport_high;		/*00CC 00CF*/=0A=
+	uint32_t	iop_inbound_queue_port_low;		/*00D0 00D3*/=0A=
+	uint32_t	iop_inbound_queue_port_high;		/*00D4 00D7*/=0A=
+	uint32_t	iop_outbound_queue_port_low;		/*00D8 00DB*/=0A=
+	uint32_t	iop_outbound_queue_port_high;		/*00DC 00DF*/=0A=
+	uint32_t	message_dest_queue_port_low;		/*00E0 00E3*/=0A=
+	uint32_t	message_dest_queue_port_high;		/*00E4 00E7*/=0A=
+	uint32_t	last_used_message_dest_address_low;	/*00E8 00EB*/=0A=
+	uint32_t	last_used_message_dest_address_high;	/*00EC 00EF*/=0A=
+	uint32_t	message_done_queue_base_address_low;	/*00F0 00F3*/=0A=
+	uint32_t	message_done_queue_base_address_high;	/*00F4 00F7*/=0A=
+	uint32_t	host_diagnostic;				/*00F8 00FB*/=0A=
+	uint32_t	write_sequence;				/*00FC 00FF*/=0A=
+	uint32_t	reserved1[34];				/*0100 0187*/=0A=
+	uint32_t	reserved2[1950];				/*0188 1FFF*/=0A=
+	uint32_t	message_wbuffer[32];			/*2000 207F*/=0A=
+	uint32_t	reserved3[32];				/*2080 20FF*/=0A=
+	uint32_t	message_rbuffer[32];			/*2100 217F*/=0A=
+	uint32_t	reserved4[32];				/*2180 21FF*/=0A=
+	uint32_t	msgcode_rwbuffer[256];			/*2200 23FF*/=0A=
+};=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **                 Adapter Control Block=0A=
@@ -385,11 +518,14 @@ struct AdapterControlBlock=0A=
 	unsigned long			vir2phy_offset;=0A=
 	/* Offset is used in making arc cdb physical to virtual calculations */=0A=
 	uint32_t			outbound_int_enable;=0A=
+	uint32_t			cdb_phyaddr_hi32;=0A=
+	uint32_t			reg_mu_acc_handle0;=0A=
 	spinlock_t                      			eh_lock;=0A=
 	spinlock_t                      			ccblist_lock;=0A=
 	union {=0A=
 		struct MessageUnit_A __iomem *	pmuA;=0A=
 		struct MessageUnit_B *		pmuB;=0A=
+		struct MessageUnit_C __iomem *pmuC;=0A=
 	};=0A=
 	/* message unit ATU inbound base address0 */=0A=
 	void __iomem *mem_base0;=0A=
@@ -410,6 +546,8 @@ struct AdapterControlBlock=0A=
 	/* message clear rqbuffer */=0A=
 	#define ACB_F_MESSAGE_WQBUFFER_READED   0x0040=0A=
 	#define ACB_F_BUS_RESET               	0x0080=0A=
+	#define ACB_F_BUS_HANG_ON		0x0800/* need hardware reset bus */=0A=
+=0A=
 	#define ACB_F_IOP_INITED              	0x0100=0A=
 	/* iop init */=0A=
 	#define ACB_F_ABORT				0x0200=0A=
@@ -477,7 +615,8 @@ struct CommandControlBlock=0A=
 	struct list_head		list;				/*x32: 8byte, x64: 16byte*/=0A=
 	struct scsi_cmnd		*pcmd;				/*8 bytes pointer of linux scsi command */=0A=
 	struct AdapterControlBlock	*acb;				/*x32: 4byte, x64: 8byte*/=0A=
-	uint32_t			shifted_cdb_phyaddr;		/*x32: 4byte, x64: 4byte*/=0A=
+	uint32_t			cdb_phyaddr_pattern;		/*x32: 4byte, x64: 4byte*/=0A=
+	uint32_t			arc_cdb_size;			/*x32:4byte,x64:4byte*/=0A=
 	uint16_t			ccb_flags;			/*x32: 2byte, x64: 2byte*/=0A=
 	#define			CCB_FLAG_READ			0x0000=0A=
 	#define			CCB_FLAG_WRITE		0x0001=0A=
@@ -491,10 +630,10 @@ struct CommandControlBlock=0A=
 	#define			ARCMSR_CCB_ILLEGAL		0xFFFF=0A=
 	#if BITS_PER_LONG =3D=3D 64=0A=
 	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+64 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */=0A=
-		uint32_t                        	reserved[6];		/*24 byte*/=0A=
+		uint32_t                        	reserved[5];		/*24 byte*/=0A=
 	#else=0A=
 	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+32 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */=0A=
-		uint32_t                        	reserved[2];		/*8  byte*/=0A=
+		uint32_t                        	reserved;		/*8  byte*/=0A=
 	#endif=0A=
 	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D   */=0A=
 	struct ARCMSR_CDB		arcmsr_cdb;=0A=
diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr_hba.c =
linux-2.6/drivers/scsi/arcmsr.1.20.00.15-100202/arcmsr_hba.c=0A=
--- linux-2.6/drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr_hba.c	=
2010-04-14 19:25:15.000000000 +0800=0A=
+++ linux-2.6/drivers/scsi/arcmsr.1.20.00.15-100202/arcmsr_hba.c	=
2010-04-14 19:28:55.000000000 +0800=0A=
@@ -71,11 +71,11 @@=0A=
 #include <scsi/scsicam.h>=0A=
 #include "arcmsr.h"=0A=
 MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");=0A=
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx) SATA/SAS RAID Host Bus =
Adapter");=0A=
+MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host =
Bus Adapter");=0A=
 MODULE_LICENSE("Dual BSD/GPL");=0A=
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);=0A=
-static int sleeptime =3D 20;=0A=
-static int retrycount =3D 12;=0A=
+static int sleeptime =3D 10;=0A=
+static int retrycount =3D 30;=0A=
 wait_queue_head_t wait_q;=0A=
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
 					struct scsi_cmnd *cmd);=0A=
@@ -99,10 +99,12 @@ static void arcmsr_flush_hbb_cache(struc=0A=
 static void arcmsr_request_device_map(unsigned long pacb);=0A=
 static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb);=0A=
 static void arcmsr_request_hbb_device_map(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_request_hbc_device_map(struct AdapterControlBlock =
*acb);=0A=
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);=0A=
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);=0A=
-=0A=
+static void arcmsr_hbc_message_isr(struct AdapterControlBlock *pACB);=0A=
+static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);=0A=
 static const char *arcmsr_info(struct Scsi_Host *);=0A=
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);=0A=
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,=0A=
@@ -110,13 +112,13 @@ static int arcmsr_adjust_disk_queue_dept=0A=
 {=0A=
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)=0A=
 		queue_depth =3D ARCMSR_MAX_CMD_PERLUN;=0A=
-	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);=0A=
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), queue_depth);=0A=
 	return queue_depth;=0A=
 }=0A=
 =0A=
 static struct scsi_host_template arcmsr_scsi_host_template =3D {=0A=
 	.module			=3D THIS_MODULE,=0A=
-	.name			=3D "ARCMSR ARECA SATA/SAS RAID Host Bus Adapter"=0A=
+	.name			=3D "ARCMSR ARECA SATA/SAS RAID Controller"=0A=
 				ARCMSR_DRIVER_VERSION,=0A=
 	.info			=3D arcmsr_info,=0A=
 	.queuecommand		=3D arcmsr_queue_command,=0A=
@@ -175,17 +177,40 @@ static struct pci_driver arcmsr_pci_driv=0A=
 	.err_handler		=3D &arcmsr_pci_error_handlers,=0A=
 	#endif=0A=
 };=0A=
+/*=0A=
+************************************************************************=
****=0A=
+************************************************************************=
****=0A=
+*/=0A=
+int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)=0A=
+{=0A=
+		struct Scsi_Host *shost =3D NULL;=0A=
+		int i, isleep;=0A=
+		shost =3D cmd->device->host;=0A=
+		isleep =3D sleeptime / 10;=0A=
+		if (isleep > 0) {=0A=
+			for (i =3D 0; i < isleep; i++) {=0A=
+				msleep(10000);=0A=
+			}=0A=
+		}=0A=
 =0A=
-static void arcmsr_free_mu(struct AdapterControlBlock *acb)=0A=
+		isleep =3D sleeptime % 10;=0A=
+		if (isleep > 0) {=0A=
+			msleep(isleep*1000);=0A=
+		}=0A=
+		printk("wake-up\n");=0A=
+		return 0;=0A=
+}=0A=
+=0A=
+static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A:=0A=
+	case ACB_ADAPTER_TYPE_C:=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_B:{=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 			dma_free_coherent(&acb->pdev->dev,=0A=
 				sizeof(struct MessageUnit_B),=0A=
-				reg, acb->dma_coherent_handle_hbb_mu);=0A=
+			acb->pmuB, acb->dma_coherent_handle_hbb_mu);=0A=
 	}=0A=
 	}=0A=
 }=0A=
@@ -218,6 +242,19 @@ static bool arcmsr_remap_pciregion(struc=0A=
 		}=0A=
 		acb->mem_base0 =3D mem_base0;=0A=
 		acb->mem_base1 =3D mem_base1;=0A=
+			break;=0A=
+		}=0A=
+		case ACB_ADAPTER_TYPE_C:{=0A=
+			acb->pmuC =3D ioremap_nocache(pci_resource_start(pdev, 1), =
pci_resource_len(pdev, 1));=0A=
+			if (!acb->pmuC) {=0A=
+				printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+				return false;=0A=
+			}=0A=
+			if (readl(&acb->pmuC->outbound_doorbell) & =
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+				writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/=0A=
+				return TRUE;=0A=
+			}=0A=
+			break;=0A=
 	}=0A=
 	}=0A=
 	return true;=0A=
@@ -229,10 +266,16 @@ static void arcmsr_unmap_pciregion(struc=0A=
 		case ACB_ADAPTER_TYPE_A:{=0A=
 			iounmap(acb->pmuA);=0A=
 		}=0A=
+		break;=0A=
 		case ACB_ADAPTER_TYPE_B:{=0A=
 			iounmap(acb->mem_base0);=0A=
 			iounmap(acb->mem_base1);=0A=
 		}=0A=
+=0A=
+		break;=0A=
+		case ACB_ADAPTER_TYPE_C:{=0A=
+			iounmap(acb->pmuC);=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -280,6 +323,10 @@ static void arcmsr_define_adapter_type(s=0A=
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);=0A=
 	acb->dev_id =3D dev_id;=0A=
 	switch (dev_id) {=0A=
+	case 0x1880: {=0A=
+		acb->adapter_type =3D ACB_ADAPTER_TYPE_C;=0A=
+		}=0A=
+		break;=0A=
 	case 0x1201 : {=0A=
 		acb->adapter_type =3D ACB_ADAPTER_TYPE_B;=0A=
 		}=0A=
@@ -301,13 +347,13 @@ static uint8_t arcmsr_hba_wait_msgint_re=0A=
 					ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {=0A=
 				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,=0A=
 					&reg->outbound_intstatus);=0A=
-				return 0x00;=0A=
+				return TRUE;=0A=
 			}=0A=
 			msleep(10);=0A=
 		} /*max 1 seconds*/=0A=
 =0A=
 	} while (Retries++ < 20);/*max 20 sec*/=0A=
-	return 0xff;=0A=
+	return FALSE;=0A=
 }=0A=
 =0A=
 static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock =
*acb)=0A=
@@ -323,15 +368,32 @@ static uint8_t arcmsr_hbb_wait_msgint_re=0A=
 				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN=0A=
 					, reg->iop2drv_doorbell);=0A=
 				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);=0A=
-				return 0x00;=0A=
+				return TRUE;=0A=
 			}=0A=
 			msleep(10);=0A=
 		} /*max 1 seconds*/=0A=
 =0A=
 	} while (Retries++ < 20);/*max 20 sec*/=0A=
-	return 0xff;=0A=
+	return FALSE;=0A=
 }=0A=
 =0A=
+static uint8_t arcmsr_hbc_wait_msgint_ready(struct AdapterControlBlock =
*pACB)=0A=
+{=0A=
+	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	unsigned char Retries =3D 0x00;=0A=
+	uint32_t Index;=0A=
+	do {=0A=
+		for (Index =3D 0; Index < 100; Index++) {=0A=
+			if (readl(&phbcmu->outbound_doorbell) & =
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+				writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&phbcmu->outbound_doorbell_clear);/*clear interrupt*/=0A=
+				return TRUE;=0A=
+			}=0A=
+			/* one us delay	*/=0A=
+			msleep(10);=0A=
+		} /*max 1 seconds*/=0A=
+	} while (Retries++ < 20); /*max 20 sec*/=0A=
+	return FALSE;=0A=
+}=0A=
 static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
@@ -336,10 +398,9 @@ static void arcmsr_flush_hba_cache(struc=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	int retry_count =3D 30;=0A=
-=0A=
 	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);=0A=
 	do {=0A=
-		if (!arcmsr_hba_wait_msgint_ready(acb))=0A=
+		if (arcmsr_hba_wait_msgint_ready(acb))=0A=
 			break;=0A=
 		else {=0A=
 			retry_count--;=0A=
@@ -353,10 +414,9 @@ static void arcmsr_flush_hbb_cache(struc=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	int retry_count =3D 30;=0A=
-=0A=
 	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);=0A=
 	do {=0A=
-		if (!arcmsr_hbb_wait_msgint_ready(acb))=0A=
+		if (arcmsr_hbb_wait_msgint_ready(acb))=0A=
 			break;=0A=
 		else {=0A=
 			retry_count--;=0A=
@@ -366,6 +426,23 @@ static void arcmsr_flush_hbb_cache(struc=0A=
 	} while (retry_count !=3D 0);=0A=
 }=0A=
 =0A=
+static void arcmsr_flush_hbc_cache(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	int retry_count =3D 30;/* enlarge wait flush adapter cache time: 10 =
minute */=0A=
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
+	do {=0A=
+		if (arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
+			break;=0A=
+		} else {=0A=
+			retry_count--;=0A=
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
+			timeout,retry count down =3D %d \n", pACB->host->host_no, =
retry_count);=0A=
+		}=0A=
+	} while (retry_count !=3D 0);=0A=
+	return;=0A=
+}=0A=
 static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
@@ -378,21 +455,22 @@ static void arcmsr_flush_adapter_cache(s=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		arcmsr_flush_hbb_cache(acb);=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		arcmsr_flush_hbc_cache(acb);=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
 static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct pci_dev *pdev =3D acb->pdev;=0A=
-	switch (acb->adapter_type) {=0A=
-		case ACB_ADAPTER_TYPE_A: {=0A=
-=0A=
 			void *dma_coherent;=0A=
 			dma_addr_t dma_coherent_handle;=0A=
 			struct CommandControlBlock *ccb_tmp;=0A=
 			int i =3D 0, j =3D 0;=0A=
 			dma_addr_t cdb_phyaddr;=0A=
-			unsigned long roundup_ccbsize =3D 0;=0A=
+	unsigned long roundup_ccbsize =3D 0, offset;=0A=
 			unsigned long max_xfer_len;=0A=
 			unsigned long max_sg_entrys;=0A=
 			uint32_t  firm_config_version;=0A=
@@ -405,26 +482,29 @@ static int arcmsr_alloc_ccb_pool(struct =0A=
 			max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;=0A=
 			firm_config_version =3D acb->firm_cfg_version;=0A=
 			if ((firm_config_version & 0xFF) >=3D 3) {=0A=
-				max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH << =
((firm_config_version >> 8) & 0xFF)) * 1024;/* max 16M byte */=0A=
+		max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH << ((firm_config_version =
>> 8) & 0xFF)) * 1024;/* max 4M byte */=0A=
 				max_sg_entrys =3D (max_xfer_len/4096);=0A=
 			}=0A=
 			acb->host->max_sectors =3D max_xfer_len/512;=0A=
 			acb->host->sg_tablesize =3D max_sg_entrys;=0A=
-			roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) + =
max_sg_entrys * sizeof(struct SG64ENTRY), 32);=0A=
-			acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;=0A=
+	roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) + =
(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
+	acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM + 32;=0A=
 			dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size, =
&dma_coherent_handle, GFP_KERNEL);=0A=
 			if (!dma_coherent) {=0A=
 				printk("arcmsr%d: dma_alloc_coherent got error \n", =
acb->host->host_no);=0A=
 				return -ENOMEM;=0A=
 			}=0A=
-			memset(dma_coherent, 0, acb->uncache_size);=0A=
 			acb->dma_coherent =3D dma_coherent;=0A=
 			acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
-			ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;=0A=
+	memset(dma_coherent, 0, acb->uncache_size);=0A=
+	offset =3D roundup((unsigned long)dma_coherent, 32) - (unsigned =
long)dma_coherent;=0A=
+	dma_coherent_handle =3D dma_coherent_handle + offset;=0A=
+	dma_coherent =3D (struct CommandControlBlock *)dma_coherent + offset;=0A=
+	ccb_tmp =3D dma_coherent;=0A=
 			acb->vir2phy_offset =3D (unsigned long)dma_coherent - (unsigned =
long)dma_coherent_handle;=0A=
 			for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++){=0A=
 				cdb_phyaddr =3D dma_coherent_handle + offsetof(struct =
CommandControlBlock, arcmsr_cdb);=0A=
-				ccb_tmp->shifted_cdb_phyaddr =3D cdb_phyaddr >> 5;=0A=
+		ccb_tmp->cdb_phyaddr_pattern =3D ((acb->adapter_type =3D=3D =
ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));=0A=
 				acb->pccb_pool[i] =3D ccb_tmp;=0A=
 				ccb_tmp->acb =3D acb;=0A=
 				INIT_LIST_HEAD(&ccb_tmp->list);=0A=
@@ -432,68 +512,9 @@ static int arcmsr_alloc_ccb_pool(struct =0A=
 				ccb_tmp =3D (struct CommandControlBlock *)((unsigned long)ccb_tmp + =
roundup_ccbsize);=0A=
 				dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;=0A=
 			}=0A=
-			break;=0A=
-		}=0A=
-		case ACB_ADAPTER_TYPE_B: {=0A=
-=0A=
-			void *dma_coherent;=0A=
-			dma_addr_t dma_coherent_handle;=0A=
-			struct CommandControlBlock *ccb_tmp;=0A=
-			uint32_t cdb_phyaddr;=0A=
-			unsigned int roundup_ccbsize =3D 0;=0A=
-			unsigned long max_xfer_len;=0A=
-			unsigned long max_sg_entrys;=0A=
-			unsigned long firm_config_version;=0A=
-			unsigned long max_freeccb_num =3D 0;=0A=
-			int i =3D 0, j =3D 0;=0A=
-=0A=
-			max_freeccb_num =3D ARCMSR_MAX_FREECCB_NUM;=0A=
-			max_xfer_len =3D ARCMSR_MAX_XFER_LEN;=0A=
-			max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;=0A=
-			firm_config_version =3D acb->firm_cfg_version;=0A=
-			if ((firm_config_version & 0xFF) >=3D 3) {=0A=
-				max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH <<=0A=
-						((firm_config_version >> 8) & 0xFF)) * 1024;/* max 16M byte */=0A=
-				max_sg_entrys =3D (max_xfer_len/4096);/* max 4097 sg entry*/=0A=
-			}=0A=
-			acb->host->max_sectors =3D max_xfer_len / 512;=0A=
-			acb->host->sg_tablesize =3D max_sg_entrys;=0A=
-			roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock)+=0A=
-				(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
-			acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;=0A=
-			dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size,=0A=
-				&dma_coherent_handle, GFP_KERNEL);=0A=
-=0A=
-			if (!dma_coherent) {=0A=
-				printk(KERN_NOTICE "DMA allocation =
failed...........................\n");=0A=
-				return -ENOMEM;=0A=
-			}=0A=
-			memset(dma_coherent, 0, acb->uncache_size);=0A=
-			acb->dma_coherent =3D dma_coherent;=0A=
-			acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
-			ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;=0A=
-			acb->vir2phy_offset =3D (unsigned long)dma_coherent -=0A=
-					(unsigned long)dma_coherent_handle;=0A=
-			for(i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++){=0A=
-				cdb_phyaddr =3D dma_coherent_handle +=0A=
-					offsetof(struct CommandControlBlock, arcmsr_cdb);=0A=
-				ccb_tmp->shifted_cdb_phyaddr =3D cdb_phyaddr >> 5;=0A=
-				acb->pccb_pool[i] =3D ccb_tmp;=0A=
-				ccb_tmp->acb =3D acb;=0A=
-				INIT_LIST_HEAD(&ccb_tmp->list);=0A=
-				list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);=0A=
-				ccb_tmp =3D (struct CommandControlBlock *)((unsigned long)ccb_tmp +=0A=
-									roundup_ccbsize);=0A=
-				dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;=0A=
-			}=0A=
-			for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
-				for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
-					acb->devstate[i][j] =3D ARECA_RAID_GONE;=0A=
-		}=0A=
-		break;=0A=
-	}=0A=
 	return 0;=0A=
 }=0A=
+=0A=
 static void arcmsr_message_isr_bh_fn(struct work_struct *work) =0A=
 {=0A=
 	struct AdapterControlBlock *acb =3D container_of(work,struct =
AdapterControlBlock, arcmsr_do_message_isr_bh);=0A=
@@ -573,6 +594,43 @@ static void arcmsr_message_isr_bh_fn(str=0A=
 				}=0A=
 			}=0A=
 		}=0A=
+		break;=0A=
+		case ACB_ADAPTER_TYPE_C: {=0A=
+			struct MessageUnit_C *reg  =3D acb->pmuC;=0A=
+			char *acb_dev_map =3D (char *)acb->device_map;=0A=
+			uint32_t __iomem *signature =3D (uint32_t __iomem =
*)(&reg->msgcode_rwbuffer[0]);=0A=
+			char __iomem *devicemap =3D (char __iomem =
*)(&reg->msgcode_rwbuffer[21]);=0A=
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
 	}=0A=
 }=0A=
 =0A=
@@ -591,9 +648,9 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	if (!host) {=0A=
 		goto pci_disable_dev;=0A=
 	}=0A=
-	error =3D pci_set_dma_mask(pdev, DMA_64BIT_MASK);=0A=
+	error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));=0A=
 	if (error) {=0A=
-		error =3D pci_set_dma_mask(pdev, DMA_32BIT_MASK);=0A=
+		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
 		if (error) {=0A=
 			printk(KERN_WARNING=0A=
 			       "scsi%d: No suitable DMA mask available\n",=0A=
@@ -675,7 +732,7 @@ static int arcmsr_probe(struct pci_dev *=0A=
 		arcmsr_flush_adapter_cache(acb);=0A=
 		arcmsr_free_ccb_pool(acb);=0A=
 	free_hbb_mu:=0A=
-		arcmsr_free_mu(acb);=0A=
+		arcmsr_free_hbb_mu(acb);=0A=
 	unmap_pci_region:=0A=
 		arcmsr_unmap_pciregion(acb);=0A=
 	pci_release_regs:=0A=
@@ -690,15 +747,14 @@ static int arcmsr_probe(struct pci_dev *=0A=
 static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-=0A=
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);=0A=
-	if (arcmsr_hba_wait_msgint_ready(acb)){=0A=
+	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE=0A=
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
 			, acb->host->host_no);=0A=
-		return 0xff;=0A=
+		return FALSE;=0A=
 	}=0A=
-	return 0x00;=0A=
+	return TRUE;=0A=
 }=0A=
 =0A=
 static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)=0A=
@@ -706,15 +762,27 @@ static uint8_t arcmsr_abort_hbb_allcmd(s=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 =0A=
 	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);=0A=
-	if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
+	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE=0A=
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
 			, acb->host->host_no);=0A=
-		return 0xff;=0A=
+		return FALSE;=0A=
 	}=0A=
-	return 0x00;=0A=
+	return TRUE;=0A=
+}=0A=
+static uint8_t arcmsr_abort_hbc_allcmd(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
+	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
+		printk(KERN_NOTICE=0A=
+			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
+			, pACB->host->host_no);=0A=
+		return FALSE;=0A=
+	}=0A=
+	return TRUE;=0A=
 }=0A=
-=0A=
 static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint8_t rtnval =3D 0;=0A=
@@ -727,6 +795,11 @@ static uint8_t arcmsr_abort_allcmd(struc=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		rtnval =3D arcmsr_abort_hbb_allcmd(acb);=0A=
 		}=0A=
+		break;=0A=
+=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		rtnval =3D arcmsr_abort_hbc_allcmd(acb);=0A=
+		}=0A=
 	}=0A=
 	return rtnval;=0A=
 }=0A=
@@ -734,9 +807,8 @@ static uint8_t arcmsr_abort_allcmd(struc=0A=
 static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock =
*pacb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D pacb->pmuB;=0A=
-=0A=
 	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);=0A=
-	if (arcmsr_hbb_wait_msgint_ready(pacb)) {=0A=
+	if (!arcmsr_hbb_wait_msgint_ready(pacb)) {=0A=
 		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", =
pacb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
@@ -759,7 +830,6 @@ static void arcmsr_ccb_complete(struct C=0A=
 	atomic_dec(&acb->ccboutstandingcount);=0A=
 	arcmsr_pci_unmap_dma(ccb);=0A=
 	ccb->startdone =3D ARCMSR_CCB_DONE;=0A=
-	ccb->ccb_flags =3D 0;=0A=
 	spin_lock_irqsave(&acb->ccblist_lock, flags);=0A=
 	list_add_tail(&ccb->list, &acb->ccb_free_list);=0A=
 	spin_unlock_irqrestore(&acb->ccblist_lock, flags);=0A=
@@ -803,14 +870,20 @@ static u32 arcmsr_disable_outbound_ints(=0A=
 		writel(0, reg->iop2drv_doorbell_mask);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C:{=0A=
+		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		/* disable all outbound interrupt */=0A=
+		orig_mask =3D readl(&reg->host_int_mask); /* disable outbound =
message0 int */=0A=
+		writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);=0A=
+		}=0A=
+		break;=0A=
 	}=0A=
 	return orig_mask;=0A=
 }=0A=
 =0A=
 static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,=0A=
-			struct CommandControlBlock *ccb, uint32_t flag_ccb)=0A=
+			struct CommandControlBlock *ccb, bool error)=0A=
 {=0A=
-=0A=
 	uint8_t id, lun;=0A=
 	id =3D ccb->pcmd->device->id;=0A=
 	lun =3D ccb->pcmd->device->lun;=0A=
@@ -814,7 +887,7 @@ static void arcmsr_report_ccb_state(stru=0A=
 	uint8_t id, lun;=0A=
 	id =3D ccb->pcmd->device->id;=0A=
 	lun =3D ccb->pcmd->device->lun;=0A=
-	if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {=0A=
+	if (!error) {=0A=
 		if (acb->devstate[id][lun] =3D=3D ARECA_RAID_GONE)=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GOOD;=0A=
 			ccb->pcmd->result =3D DID_OK << 16;=0A=
@@ -846,9 +919,8 @@ static void arcmsr_report_ccb_state(stru=0A=
 =0A=
 		default:=0A=
 				printk(KERN_NOTICE=0A=
-					"arcmsr%d: scsi id =3D %d lun =3D %d"=0A=
-					" isr get command error done, "=0A=
-					"but got unknown DeviceStatus =3D 0x%x \n"=0A=
+				"arcmsr%d: scsi id =3D %d lun =3D %d isr get command error done, \=0A=
+				but got unknown DeviceStatus =3D 0x%x \n"=0A=
 					, acb->host->host_no=0A=
 					, id=0A=
 					, lun=0A=
@@ -861,25 +933,20 @@ static void arcmsr_report_ccb_state(stru=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, =
uint32_t flag_ccb)=0A=
+static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, =
struct CommandControlBlock *pCCB, bool error)=0A=
 =0A=
 {=0A=
-	struct CommandControlBlock *ccb;=0A=
-	struct ARCMSR_CDB *arcmsr_cdb;=0A=
 	int id, lun;=0A=
-=0A=
-	arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));=0A=
-	ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-	if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
-		if (ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
-			struct scsi_cmnd *abortcmd =3D ccb->pcmd;=0A=
+	if ((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
+		if (pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
+			struct scsi_cmnd *abortcmd =3D pCCB->pcmd;=0A=
 			if (abortcmd) {=0A=
 				id =3D abortcmd->device->id;=0A=
 				lun =3D abortcmd->device->lun;=0A=
 				abortcmd->result |=3D DID_ABORT << 16;=0A=
-				arcmsr_ccb_complete(ccb);=0A=
-				printk(KERN_NOTICE "arcmsr%d: ccb =3D'0x%p' \=0A=
-				isr got aborted command \n", acb->host->host_no, ccb);=0A=
+				arcmsr_ccb_complete(pCCB);=0A=
+				printk(KERN_NOTICE "arcmsr%d: pCCB =3D'0x%p' isr got aborted =
command \n",=0A=
+				acb->host->host_no, pCCB);=0A=
 			}=0A=
 		}=0A=
 		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \=0A=
@@ -888,20 +955,21 @@ static void arcmsr_drain_donequeue(struc=0A=
 				" ccboutstandingcount =3D %d \n"=0A=
 				, acb->host->host_no=0A=
 				, acb=0A=
-				, ccb=0A=
-				, ccb->acb=0A=
-				, ccb->startdone=0A=
+				, pCCB=0A=
+				, pCCB->acb=0A=
+				, pCCB->startdone=0A=
 				, atomic_read(&acb->ccboutstandingcount));=0A=
 		}=0A=
-	else=0A=
-	arcmsr_report_ccb_state(acb, ccb, flag_ccb);=0A=
+	arcmsr_report_ccb_state(acb, pCCB, error);=0A=
 }=0A=
 =0A=
 static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	int i =3D 0;=0A=
 	uint32_t flag_ccb;=0A=
-=0A=
+	struct ARCMSR_CDB *pARCMSR_CDB;=0A=
+	bool error;=0A=
+	struct CommandControlBlock *pCCB;=0A=
 	switch (acb->adapter_type) {=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
@@ -913,7 +981,10 @@ static void arcmsr_done4abort_postqueue(=0A=
 		writel(outbound_intstatus, &reg->outbound_intstatus);/*clear =
interrupt*/=0A=
 		while (((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D =
0xFFFFFFFF)=0A=
 				&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {=0A=
-			arcmsr_drain_donequeue(acb, flag_ccb);=0A=
+			pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
(flag_ccb << 5));/*frame must be 32 bytes aligned*/=0A=
+			pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? TRUE : =
FALSE;=0A=
+			arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 		}=0A=
 		}=0A=
 		break;=0A=
@@ -921,17 +992,37 @@ static void arcmsr_done4abort_postqueue(=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 		/*clear all outbound posted Q*/=0A=
+		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, &reg->iop2drv_doorbell); /* =
clear doorbell interrupt */=0A=
 		for (i =3D 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {=0A=
 			if ((flag_ccb =3D readl(&reg->done_qbuffer[i])) !=3D 0) {=0A=
 				writel(0, &reg->done_qbuffer[i]);=0A=
-				arcmsr_drain_donequeue(acb, flag_ccb);=0A=
+				pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/=0A=
+				pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+				error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? TRUE : =
FALSE;=0A=
+				arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 			}=0A=
-			writel(0, &reg->post_qbuffer[i]);=0A=
+			reg->post_qbuffer[i] =3D 0;=0A=
 		}=0A=
 		reg->doneq_index =3D 0;=0A=
 		reg->postq_index =3D 0;=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C *reg =3D acb->pmuC;=0A=
+		struct  ARCMSR_CDB *pARCMSR_CDB;=0A=
+		uint32_t flag_ccb, ccb_cdb_phy;=0A=
+		bool error;=0A=
+		struct CommandControlBlock *pCCB;=0A=
+		while ((readl(&reg->host_int_status) & =
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < =
ARCMSR_MAX_OUTSTANDING_CMD)) {=0A=
+			/*need to do*/=0A=
+			flag_ccb =3D readl(&reg->outbound_queueport_low);=0A=
+			ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
+			pARCMSR_CDB =3D (struct  ARCMSR_CDB =
*)(acb->vir2phy_offset+ccb_cdb_phy);/*frame must be 32 bytes aligned*/=0A=
+			pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? TRUE : =
FALSE;=0A=
+			arcmsr_drain_donequeue(acb, pCCB, error);=0A=
+		}=0A=
+	}=0A=
 	}=0A=
 }=0A=
 static void arcmsr_remove(struct pci_dev *pdev)=0A=
@@ -942,7 +1033,6 @@ static void arcmsr_remove(struct pci_dev=0A=
 	int poll_count =3D 0;=0A=
 	arcmsr_free_sysfs_attr(acb);=0A=
 	scsi_remove_host(host);=0A=
-	scsi_host_put(host);=0A=
 	flush_scheduled_work();=0A=
 	del_timer_sync(&acb->eternal_timer);=0A=
 	arcmsr_disable_outbound_ints(acb);=0A=
@@ -974,8 +1064,10 @@ static void arcmsr_remove(struct pci_dev=0A=
 	}=0A=
 	free_irq(pdev->irq, acb);=0A=
 	arcmsr_free_ccb_pool(acb);=0A=
-	arcmsr_free_mu(acb);=0A=
+	arcmsr_free_hbb_mu(acb);=0A=
+	arcmsr_unmap_pciregion(acb);=0A=
 	pci_release_regions(pdev);=0A=
+	scsi_host_put(host);=0A=
 	pci_disable_device(pdev);=0A=
 	pci_set_drvdata(pdev, NULL);=0A=
 }=0A=
@@ -1033,6 +1123,13 @@ static void arcmsr_enable_outbound_ints(=0A=
 		writel(mask, reg->iop2drv_doorbell_mask);=0A=
 		acb->outbound_int_enable =3D (intmask_org | mask) & 0x0000000f;=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C *reg =3D acb->pmuC;=0A=
+		mask =3D ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK | =
ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_I=
SR_MASK);=0A=
+		writel(intmask_org & mask, &reg->host_int_mask);=0A=
+		acb->outbound_int_enable =3D ~(intmask_org & mask) & 0x0000000f;=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -1044,24 +1141,20 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 	__le32 address_lo, address_hi;=0A=
 	int arccdbsize =3D 0x30;=0A=
 	__le32 length =3D 0;=0A=
-	int i, cdb_sgcount =3D 0;=0A=
+	int i;=0A=
 	struct scatterlist *sg;=0A=
 	int nseg;=0A=
-=0A=
 	ccb->pcmd =3D pcmd;=0A=
 	memset(arcmsr_cdb, 0, sizeof(struct ARCMSR_CDB));=0A=
-	arcmsr_cdb->Bus =3D 0;=0A=
 	arcmsr_cdb->TargetID =3D pcmd->device->id;=0A=
 	arcmsr_cdb->LUN =3D pcmd->device->lun;=0A=
 	arcmsr_cdb->Function =3D 1;=0A=
-	arcmsr_cdb->CdbLength =3D (uint8_t)pcmd->cmd_len;=0A=
 	arcmsr_cdb->Context =3D 0;=0A=
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);=0A=
 =0A=
 	nseg =3D scsi_dma_map(pcmd);=0A=
-	if (nseg > acb->host->sg_tablesize || nseg < 0)=0A=
+	if (unlikely(nseg > acb->host->sg_tablesize || nseg < 0))=0A=
 		return FAILED;=0A=
-	/* map stor port SG list to our iop SG List. */=0A=
 	scsi_for_each_sg(pcmd, sg, nseg, i) {=0A=
 		/* Get the physical address of the current data pointer */=0A=
 		length =3D cpu_to_le32(sg_dma_len(sg));=0A=
@@ -1083,23 +1176,22 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 			psge +=3D sizeof (struct SG64ENTRY);=0A=
 			arccdbsize +=3D sizeof (struct SG64ENTRY);=0A=
 		}=0A=
-		cdb_sgcount++;=0A=
 	}=0A=
-	arcmsr_cdb->sgcount =3D (uint8_t)cdb_sgcount;=0A=
+	arcmsr_cdb->sgcount =3D (uint8_t)nseg;=0A=
 	arcmsr_cdb->DataLength =3D scsi_bufflen(pcmd);=0A=
 	arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : =
0);=0A=
 	if ( arccdbsize > 256)=0A=
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_SGL_BSIZE;=0A=
 	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0] | WRITE_10 || =
pcmd->cmnd[0]|WRITE_12) {=0A=
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_WRITE;=0A=
-		ccb->ccb_flags |=3D CCB_FLAG_WRITE;=0A=
 	}=0A=
+	ccb->arc_cdb_size =3D arccdbsize;=0A=
 	return SUCCESS;=0A=
 }=0A=
 =0A=
 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct =
CommandControlBlock *ccb)=0A=
 {=0A=
-	uint32_t shifted_cdb_phyaddr =3D ccb->shifted_cdb_phyaddr;=0A=
+	uint32_t cdb_phyaddr_pattern =3D ccb->cdb_phyaddr_pattern;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb =3D (struct ARCMSR_CDB =
*)&ccb->arcmsr_cdb;=0A=
 	atomic_inc(&acb->ccboutstandingcount);=0A=
 	ccb->startdone =3D ARCMSR_CCB_START;=0A=
@@ -1109,10 +1200,10 @@ static void arcmsr_post_ccb(struct Adapt=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 =0A=
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)=0A=
-			writel(shifted_cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
+			writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
 			&reg->inbound_queueport);=0A=
 		else {=0A=
-				writel(shifted_cdb_phyaddr, &reg->inbound_queueport);=0A=
+				writel(cdb_phyaddr_pattern, &reg->inbound_queueport);=0A=
 		}=0A=
 		}=0A=
 		break;=0A=
@@ -1124,11 +1215,10 @@ static void arcmsr_post_ccb(struct Adapt=0A=
 		ending_index =3D ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);=0A=
 		writel(0, &reg->post_qbuffer[ending_index]);=0A=
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {=0A=
-			writel(shifted_cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\=0A=
+			writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\=0A=
 						 &reg->post_qbuffer[index]);=0A=
-		}=0A=
-		else {=0A=
-			writel(shifted_cdb_phyaddr, &reg->post_qbuffer[index]);=0A=
+		} else {=0A=
+			writel(cdb_phyaddr_pattern, &reg->post_qbuffer[index]);=0A=
 		}=0A=
 		index++;=0A=
 		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to =
0 */=0A=
@@ -1136,6 +1226,19 @@ static void arcmsr_post_ccb(struct Adapt=0A=
 		writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		uint32_t ccb_post_stamp, arc_cdb_size;=0A=
+=0A=
+		arc_cdb_size =3D (ccb->arc_cdb_size > 0x300) ? 0x300 : =
ccb->arc_cdb_size;=0A=
+		ccb_post_stamp =3D (cdb_phyaddr_pattern | ((arc_cdb_size - 1) >> 6) | =
1);=0A=
+		if (acb->cdb_phyaddr_hi32) {=0A=
+			writel(acb->cdb_phyaddr_hi32, &phbcmu->inbound_queueport_high);=0A=
+			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);=0A=
+		} else {=0A=
+			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);=0A=
+		}=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -1144,8 +1247,7 @@ static void arcmsr_stop_hba_bgrb(struct =0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);=0A=
-=0A=
-	if (arcmsr_hba_wait_msgint_ready(acb)) {=0A=
+	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE=0A=
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"=0A=
 			, acb->host->host_no);=0A=
@@ -1158,13 +1260,26 @@ static void arcmsr_stop_hbb_bgrb(struct =0A=
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);=0A=
 =0A=
-	if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
+	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE=0A=
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"=0A=
 			, acb->host->host_no);=0A=
 	}=0A=
 }=0A=
 =0A=
+static void arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	pACB->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
+	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
+	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
+		printk(KERN_NOTICE=0A=
+			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"=0A=
+			, pACB->host->host_no);=0A=
+	}=0A=
+	return;=0A=
+}=0A=
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
@@ -1177,22 +1292,16 @@ static void arcmsr_stop_adapter_bgrb(str=0A=
 		arcmsr_stop_hbb_bgrb(acb);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		arcmsr_stop_hbc_bgrb(acb);=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	switch (acb->adapter_type) {=0A=
-	case ACB_ADAPTER_TYPE_A: {=0A=
-		dma_free_coherent(&acb->pdev->dev, acb->uncache_size, =
acb->dma_coherent, acb->dma_coherent_handle);=0A=
-		iounmap(acb->pmuA);=0A=
-	}=0A=
-		break;=0A=
-	case ACB_ADAPTER_TYPE_B: {=0A=
 		dma_free_coherent(&acb->pdev->dev, acb->uncache_size, =
acb->dma_coherent, acb->dma_coherent_handle);=0A=
 	}=0A=
-	}=0A=
-}=0A=
 =0A=
 void arcmsr_iop_message_read(struct AdapterControlBlock *acb)=0A=
 {=0A=
@@ -1208,6 +1317,10 @@ void arcmsr_iop_message_read(struct Adap=0A=
 		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -1233,6 +1346,15 @@ static void arcmsr_iop_message_wrote(str=0A=
 		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
+		/*=0A=
+		** push inbound doorbell tell iop, driver data write ok=0A=
+		** and wait reply on next hwinterrupt for next Qbuffer post=0A=
+		*/=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK, &reg->inbound_doorbell);=0A=
+		}=0A=
+		break;=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -1253,6 +1374,10 @@ struct QBUFFER __iomem *arcmsr_get_iop_r=0A=
 		qbuffer =3D (struct QBUFFER __iomem *)reg->message_rbuffer;=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		qbuffer =3D (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;=0A=
+		}=0A=
 	}=0A=
 	return qbuffer;=0A=
 }=0A=
@@ -1274,6 +1398,11 @@ static struct QBUFFER __iomem *arcmsr_ge=0A=
 		pqbuffer =3D (struct QBUFFER __iomem *)reg->message_wbuffer;=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		pqbuffer =3D (struct QBUFFER __iomem *)&reg->message_wbuffer;=0A=
+	}=0A=
+=0A=
 	}=0A=
 	return pqbuffer;=0A=
 }=0A=
@@ -1358,14 +1485,42 @@ static void arcmsr_hba_doorbell_isr(stru=0A=
 		arcmsr_iop2drv_data_read_handle(acb);=0A=
 	}=0A=
 }=0A=
-=0A=
+static void arcmsr_hbc_doorbell_isr(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	uint32_t outbound_doorbell;=0A=
+	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	/*=0A=
+	*******************************************************************=0A=
+	**  Maybe here we need to check wrqbuffer_lock is lock or not=0A=
+	**  DOORBELL: din! don!=0A=
+	**  check if there are any mail need to pack from firmware=0A=
+	*******************************************************************=0A=
+	*/=0A=
+	outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+	writel(outbound_doorbell, &reg->outbound_doorbell_clear);/*clear =
interrupt*/=0A=
+	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {=0A=
+		arcmsr_iop2drv_data_wrote_handle(pACB);=0A=
+	}=0A=
+	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {=0A=
+		arcmsr_iop2drv_data_read_handle(pACB);=0A=
+	}=0A=
+	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+		arcmsr_hbc_message_isr(pACB);    /* messenger of "driver to iop =
commands" */=0A=
+	}=0A=
+	return;=0A=
+}=0A=
 static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t flag_ccb;=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-=0A=
+	struct ARCMSR_CDB *pARCMSR_CDB;=0A=
+	struct CommandControlBlock *pCCB;=0A=
+	bool error;=0A=
 	while ((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D 0xFFFFFFFF) =
{=0A=
-		arcmsr_drain_donequeue(acb, flag_ccb);=0A=
+		pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/=0A=
+		pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? TRUE : =
FALSE;=0A=
+		arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -1374,17 +1529,51 @@ static void arcmsr_hbb_postqueue_isr(str=0A=
 	uint32_t index;=0A=
 	uint32_t flag_ccb;=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-=0A=
+	struct ARCMSR_CDB *pARCMSR_CDB;=0A=
+	struct CommandControlBlock *pCCB;=0A=
+	bool error;=0A=
 	index =3D reg->doneq_index;=0A=
-=0A=
 	while ((flag_ccb =3D readl(&reg->done_qbuffer[index])) !=3D 0) {=0A=
 		writel(0, &reg->done_qbuffer[index]);=0A=
-		arcmsr_drain_donequeue(acb, flag_ccb);=0A=
+		pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/=0A=
+		pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? TRUE : =
FALSE;=0A=
+		arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 		index++;=0A=
 		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;=0A=
 		reg->doneq_index =3D index;=0A=
 	}=0A=
 }=0A=
+=0A=
+static void arcmsr_hbc_postqueue_isr(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	struct MessageUnit_C *phbcmu;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
+	struct CommandControlBlock *ccb;=0A=
+	uint32_t flag_ccb, ccb_cdb_phy, throttling =3D 0;=0A=
+	int error;=0A=
+=0A=
+	phbcmu =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+	/* areca cdb command done */=0A=
+	/* Use correct offset and size for syncing */=0A=
+=0A=
+	while (readl(&phbcmu->host_int_status) &=0A=
+	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR){=0A=
+	/* check if command done with no error*/=0A=
+	flag_ccb =3D readl(&phbcmu->outbound_queueport_low);=0A=
+	ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);/*frame must be 32 bytes =
aligned*/=0A=
+	arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
ccb_cdb_phy);=0A=
+	ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+	error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? TRUE : FALSE;=0A=
+	/* check if command done with no error */=0A=
+	arcmsr_drain_donequeue(acb, ccb, error);=0A=
+	if (throttling =3D=3D ARCMSR_HBC_ISR_THROTTLING_LEVEL) {=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING, =
&phbcmu->inbound_doorbell);=0A=
+		break;=0A=
+	}=0A=
+	throttling++;=0A=
+	}=0A=
+}=0A=
 /*=0A=
 =
*************************************************************************=
*********=0A=
 ** Handle a message interrupt=0A=
@@ -1408,6 +1597,23 @@ static void arcmsr_hbb_message_isr(struc=0A=
 	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
 	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
 }=0A=
+/*=0A=
+************************************************************************=
**********=0A=
+** Handle a message interrupt=0A=
+**=0A=
+** The only message interrupt we expect is in response to a query for =
the=0A=
+** current adapter config.=0A=
+** We want this in order to compare the drivemap so that we can detect =
newly-attached drives.=0A=
+************************************************************************=
**********=0A=
+*/=0A=
+static void arcmsr_hbc_message_isr(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	struct MessageUnit_C *reg  =3D acb->pmuC;=0A=
+	/*clear interrupt and message state*/=0A=
+	writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&reg->outbound_doorbell_clear);=0A=
+	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
+}=0A=
+=0A=
 static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_intstatus;=0A=
@@ -1463,6 +1667,31 @@ static int arcmsr_handle_hbb_isr(struct =0A=
 =0A=
 	return 0;=0A=
 }=0A=
+=0A=
+static int arcmsr_handle_hbc_isr(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	uint32_t host_interrupt_status;=0A=
+	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	/*=0A=
+	*********************************************=0A=
+	**   check outbound intstatus=0A=
+	*********************************************=0A=
+	*/=0A=
+	host_interrupt_status =3D readl(&phbcmu->host_int_status);=0A=
+	if (!host_interrupt_status) {=0A=
+		/*it must be share irq*/=0A=
+		return FALSE;=0A=
+	}=0A=
+	/* MU ioctl transfer doorbell interrupts*/=0A=
+	if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {=0A=
+		arcmsr_hbc_doorbell_isr(pACB);   /* messenger of "ioctl message read =
write" */=0A=
+	}=0A=
+	/* MU post queue interrupts*/=0A=
+	if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {=0A=
+		arcmsr_hbc_postqueue_isr(pACB);  /* messenger of "scsi commands" */=0A=
+	}=0A=
+	return TRUE;=0A=
+}=0A=
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
@@ -1479,6 +1708,11 @@ static irqreturn_t arcmsr_interrupt(stru=0A=
 		}=0A=
 		}=0A=
 		break;=0A=
+	 case ACB_ADAPTER_TYPE_C: {=0A=
+		if (arcmsr_handle_hbc_isr(acb)) {=0A=
+			return IRQ_NONE;=0A=
+		}=0A=
+		}=0A=
 	}=0A=
 	return IRQ_HANDLED;=0A=
 }=0A=
@@ -1890,7 +2119,10 @@ static int arcmsr_queue_command(struct s=0A=
 	if (atomic_read(&acb->ccboutstandingcount) >=3D=0A=
 			ARCMSR_MAX_OUTSTANDING_CMD)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
-=0A=
+	if ((scsicmd =3D=3D SCSI_CMD_ARECA_SPECIFIC)) {=0A=
+		printk("Receiveing SCSI_CMD_ARECA_SPECIFIC command..\n");=0A=
+		return 0;=0A=
+	}=0A=
 	ccb =3D arcmsr_get_freeccb(acb);=0A=
 	if (!ccb)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
@@ -1913,9 +2145,8 @@ static bool arcmsr_get_hba_config(struct=0A=
 	char __iomem *iop_firm_version =3D (char __iomem =
*)(&reg->message_rwbuffer[17]);=0A=
 	char __iomem *iop_device_map =3D (char __iomem *) =
(&reg->message_rwbuffer[21]);=0A=
 	int count;=0A=
-=0A=
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
-	if (arcmsr_hba_wait_msgint_ready(acb)) {=0A=
+	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
 			miscellaneous data' timeout \n", acb->host->host_no);=0A=
 		return false;=0A=
@@ -1991,7 +2222,7 @@ static bool arcmsr_get_hbb_config(struct=0A=
 	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]);	=
/*firm_version,21,84-99*/=0A=
 =0A=
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);=0A=
-	if (arcmsr_hbb_wait_msgint_ready(acb)){=0A=
+	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
 			miscellaneous data' timeout \n", acb->host->host_no);=0A=
 		return false;=0A=
@@ -2038,12 +2269,73 @@ static bool arcmsr_get_hbb_config(struct=0A=
 	/*firm_ide_channels,4,16-19*/=0A=
 	return true;=0A=
 }=0A=
+=0A=
+static bool arcmsr_get_hbc_config(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	uint32_t intmask_org, Index, firmware_state =3D 0;=0A=
+	struct MessageUnit_C *reg =3D pACB->pmuC;=0A=
+	char *acb_firm_model =3D pACB->firm_model;=0A=
+	char *acb_firm_version =3D pACB->firm_version;=0A=
+	char *iop_firm_model =3D (char *)(&reg->msgcode_rwbuffer[15]);    =
/*firm_model,15,60-67*/=0A=
+	char *iop_firm_version =3D (char *)(&reg->msgcode_rwbuffer[17]);  =
/*firm_version,17,68-83*/=0A=
+	int count;=0A=
+	/* disable all outbound interrupt */=0A=
+	intmask_org =3D readl(&reg->host_int_mask); /* disable outbound =
message0 int */=0A=
+	writel(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE, =
&reg->host_int_mask);=0A=
+	/* wait firmware ready */=0A=
+	do {=0A=
+		firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
+	} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
+	/* post "get config" instruction */=0A=
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
+	/* wait message ready */=0A=
+	for (Index =3D 0; Index < 2000; Index++) {=0A=
+		if (readl(&reg->outbound_doorbell) & =
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&reg->outbound_doorbell_clear);/*clear interrupt*/=0A=
+			break;=0A=
+		}=0A=
+		udelay(10);=0A=
+	} /*max 1 seconds*/=0A=
+	if (Index >=3D 2000) {=0A=
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
+			miscellaneous data' timeout \n", pACB->host->host_no);=0A=
+		return false;=0A=
+	}=0A=
+	count =3D 8;=0A=
+	while (count) {=0A=
+		*acb_firm_model =3D readb(iop_firm_model);=0A=
+		acb_firm_model++;=0A=
+		iop_firm_model++;=0A=
+		count--;=0A=
+	}=0A=
+	count =3D 16;=0A=
+	while (count) {=0A=
+		*acb_firm_version =3D readb(iop_firm_version);=0A=
+		acb_firm_version++;=0A=
+		iop_firm_version++;=0A=
+		count--;=0A=
+	}=0A=
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",=0A=
+		pACB->host->host_no,=0A=
+		pACB->firm_version,=0A=
+		pACB->firm_model);=0A=
+	pACB->firm_request_len =3D readl(&reg->msgcode_rwbuffer[1]);   =
/*firm_request_len,1,04-07*/=0A=
+	pACB->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[2]); =
/*firm_numbers_queue,2,08-11*/=0A=
+	pACB->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[3]);    =
/*firm_sdram_size,3,12-15*/=0A=
+	pACB->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[4]);  =
/*firm_ide_channels,4,16-19*/=0A=
+	pACB->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/=0A=
+	/*all interrupt service will be enable at arcmsr_iop_init*/=0A=
+	return true;=0A=
+}=0A=
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	if (acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_A)=0A=
 		return arcmsr_get_hba_config(acb);=0A=
-	else=0A=
+	else if (acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_B)=0A=
 		return arcmsr_get_hbb_config(acb);=0A=
+	else=0A=
+		return arcmsr_get_hbc_config(acb);=0A=
 }=0A=
 =0A=
 static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,=0A=
@@ -2054,7 +2346,7 @@ static int arcmsr_polling_hba_ccbdone(st=0A=
 	struct ARCMSR_CDB *arcmsr_cdb;=0A=
 	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done =3D 0, poll_count =
=3D 0;=0A=
 	int rtn;=0A=
-=0A=
+	bool error;=0A=
 	polling_hba_ccb_retry:=0A=
 	poll_count++;=0A=
 	outbound_intstatus =3D readl(&reg->outbound_intstatus) & =
acb->outbound_int_enable;=0A=
@@ -2065,6 +2357,7 @@ static int arcmsr_polling_hba_ccbdone(st=0A=
 				rtn =3D SUCCESS;=0A=
 				break;=0A=
 			} else {=0A=
+				msleep(25);=0A=
 				if (poll_count > 100) {=0A=
 					rtn =3D FAILED;=0A=
 					break;=0A=
@@ -2094,9 +2387,9 @@ static int arcmsr_polling_hba_ccbdone(st=0A=
 				, ccb=0A=
 				, atomic_read(&acb->ccboutstandingcount));=0A=
 			continue;=0A=
-		} else {=0A=
-			arcmsr_report_ccb_state(acb, ccb, flag_ccb);=0A=
 		}=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? TRUE : =
FALSE;=0A=
+		arcmsr_report_ccb_state(acb, ccb, error);=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
@@ -2109,7 +2402,7 @@ static int arcmsr_polling_hbb_ccbdone(st=0A=
 	struct CommandControlBlock *ccb;=0A=
 	uint32_t flag_ccb, poll_ccb_done =3D 0, poll_count =3D 0;=0A=
 	int index, rtn;=0A=
-	=0A=
+	bool error;=0A=
 	polling_hbb_ccb_retry:=0A=
 	poll_count++;=0A=
 	/* clear doorbell interrupt */=0A=
@@ -2157,13 +2450,69 @@ static int arcmsr_polling_hbb_ccbdone(st=0A=
 				, ccb=0A=
 				, atomic_read(&acb->ccboutstandingcount));=0A=
 			continue;=0A=
-		} else {=0A=
-			arcmsr_report_ccb_state(acb, ccb, flag_ccb);=0A=
 		}=0A=
-	}	/*drain reply FIFO*/=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? TRUE : =
FALSE;=0A=
+		arcmsr_report_ccb_state(acb, ccb, error);=0A=
+	}=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
+static int arcmsr_polling_hbc_ccbdone(struct AdapterControlBlock *acb, =
struct CommandControlBlock *poll_ccb)=0A=
+{=0A=
+	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+	uint32_t flag_ccb, ccb_cdb_phy;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
+	bool error;=0A=
+	struct CommandControlBlock *pCCB;=0A=
+	uint32_t poll_ccb_done =3D 0, poll_count =3D 0;=0A=
+	int rtn;=0A=
+	polling_hbc_ccb_retry:=0A=
+	poll_count++;=0A=
+	while (1) {=0A=
+		if ((readl(&reg->host_int_status) & =
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) =3D=3D 0) {=0A=
+			if (poll_ccb_done) {=0A=
+				rtn =3D SUCCESS;=0A=
+				break;=0A=
+			} else {=0A=
+				msleep(25);=0A=
+				if (poll_count > 100) {=0A=
+					rtn =3D FAILED;=0A=
+					break;=0A=
+				}=0A=
+				goto polling_hbc_ccb_retry;=0A=
+			}=0A=
+		}=0A=
+		flag_ccb =3D readl(&reg->outbound_queueport_low);=0A=
+		ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
ccb_cdb_phy);/*frame must be 32 bytes aligned*/=0A=
+		pCCB =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+		poll_ccb_done =3D (pCCB =3D=3D poll_ccb) ? 1 : 0;=0A=
+		/* check ifcommand done with no error*/=0A=
+		if ((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
+			if (pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
+				printk(KERN_NOTICE "arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D =
'0x%p'"=0A=
+					" poll command abort successfully \n"=0A=
+					, acb->host->host_no=0A=
+					, pCCB->pcmd->device->id=0A=
+					, pCCB->pcmd->device->lun=0A=
+					, pCCB);=0A=
+					pCCB->pcmd->result =3D DID_ABORT << 16;=0A=
+					arcmsr_ccb_complete(pCCB);=0A=
+				continue;=0A=
+			}=0A=
+			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"=0A=
+				" command done ccb =3D '0x%p'"=0A=
+				"ccboutstandingcount =3D %d \n"=0A=
+				, acb->host->host_no=0A=
+				, pCCB=0A=
+				, atomic_read(&acb->ccboutstandingcount));=0A=
+			continue;=0A=
+		}=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? TRUE : =
FALSE;=0A=
+		arcmsr_report_ccb_state(acb, pCCB, error);=0A=
+	}=0A=
+	return rtn;=0A=
+}=0A=
 static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
 					struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
@@ -2178,6 +2527,10 @@ static int arcmsr_polling_ccbdone(struct=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		rtn =3D arcmsr_polling_hbb_ccbdone(acb, poll_ccb);=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		rtn =3D arcmsr_polling_hbc_ccbdone(acb, poll_ccb);=0A=
+		}=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
@@ -2195,6 +2548,7 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 	dma_coherent_handle =3D acb->dma_coherent_handle;=0A=
 	cdb_phyaddr =3D (uint32_t)(dma_coherent_handle);=0A=
 	cdb_phyaddr_hi32 =3D (uint32_t)((cdb_phyaddr >> 16) >> 16);=0A=
+	acb->cdb_phyaddr_hi32 =3D cdb_phyaddr_hi32;=0A=
 	/*=0A=
 	***********************************************************************=0A=
 	**    if adapter type B, set window of "post command Q"=0A=
@@ -2212,7 +2566,7 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);=0A=
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \=0A=
 							&reg->inbound_msgaddr0);=0A=
-			if (arcmsr_hba_wait_msgint_ready(acb)) {=0A=
+			if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
 				printk(KERN_NOTICE "arcmsr%d: ""set ccb high \=0A=
 				part physical address timeout\n",=0A=
 				acb->host->host_no);=0A=
@@ -2233,7 +2587,7 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 		reg->postq_index =3D 0;=0A=
 		reg->doneq_index =3D 0;=0A=
 		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);=0A=
-		if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
+		if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \=0A=
 				acb->host->host_no);=0A=
 			return 1;=0A=
@@ -2252,7 +2606,7 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 		writel(1056, rwbuffer);=0A=
 =0A=
 		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);=0A=
-		if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
+		if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \=0A=
 			timeout \n",acb->host->host_no);=0A=
 			return 1;=0A=
@@ -2261,6 +2615,27 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 		arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		if (cdb_phyaddr_hi32 !=3D 0) {=0A=
+			struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+=0A=
+				if (cdb_phyaddr_hi32 !=3D 0) {=0A=
+				unsigned char Retries =3D 0x00;=0A=
+				do {=0A=
+					printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=3D0x%x \n", =
acb->adapter_index, cdb_phyaddr_hi32);=0A=
+				} while (Retries++ < 100);=0A=
+			}=0A=
+			writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->msgcode_rwbuffer[0]);=0A=
+			writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);=0A=
+			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);=0A=
+			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, =
&reg->inbound_doorbell);=0A=
+			if (!arcmsr_hbc_wait_msgint_ready(acb)) {=0A=
+				printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \=0A=
+				timeout \n", acb->host->host_no);=0A=
+				return 1;=0A=
+			}=0A=
+		}=0A=
+		}=0A=
 	}=0A=
 	return 0;=0A=
 }=0A=
@@ -2287,6 +2661,12 @@ static void arcmsr_wait_firmware_ready(s=0A=
 		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		do {=0A=
+			firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
+		} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D =
0);=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -2329,6 +2708,26 @@ static void arcmsr_request_hbb_device_ma=0A=
 	return;=0A=
 }=0A=
 =0A=
+static void arcmsr_request_hbc_device_map(struct AdapterControlBlock =
*acb)=0A=
+{=0A=
+	struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0)) {=0A=
+		return;=0A=
+	} else {=0A=
+		acb->fw_flag =3D FW_NORMAL;=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)) {=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+		}=0A=
+		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
+		if (atomic_dec_and_test(&acb->rq_map_token))=0A=
+			return;=0A=
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+	}=0A=
+	return;=0A=
+}=0A=
+=0A=
 static void arcmsr_request_device_map(unsigned long pacb)=0A=
 {=0A=
 	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *)pacb;=0A=
@@ -2342,6 +2740,9 @@ static void arcmsr_request_device_map(un=0A=
 			arcmsr_request_hbb_device_map(acb);=0A=
 		}=0A=
 		break;=0A=
+		case ACB_ADAPTER_TYPE_C: {=0A=
+			arcmsr_request_hbc_device_map(acb);=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -2350,7 +2751,7 @@ static void arcmsr_start_hba_bgrb(struct=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	acb->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);=0A=
-	if (arcmsr_hba_wait_msgint_ready(acb)) {=0A=
+	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \=0A=
 				rebulid' timeout \n", acb->host->host_no);=0A=
 	}=0A=
@@ -2361,12 +2762,24 @@ static void arcmsr_start_hbb_bgrb(struct=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	acb->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);=0A=
-	if (arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
+	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \=0A=
 				rebulid' timeout \n",acb->host->host_no);=0A=
 	}=0A=
 }=0A=
 =0A=
+static void arcmsr_start_hbc_bgrb(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	pACB->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, =
&phbcmu->inbound_doorbell);=0A=
+	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \=0A=
+				rebulid' timeout \n", pACB->host->host_no);=0A=
+	}=0A=
+	return;=0A=
+}=0A=
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
@@ -2376,6 +2789,8 @@ static void arcmsr_start_adapter_bgrb(st=0A=
 	case ACB_ADAPTER_TYPE_B:=0A=
 		arcmsr_start_hbb_bgrb(acb);=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C:=0A=
+		arcmsr_start_hbc_bgrb(acb);=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -2401,6 +2816,14 @@ static void arcmsr_clear_doorbell_queue_=0A=
 		/* let IOP know data has been read */=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		uint32_t outbound_doorbell;=0A=
+		/* empty doorbell Qbuffer if door bell ringed */=0A=
+		outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+		writel(outbound_doorbell, &reg->outbound_doorbell_clear);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -2413,12 +2836,14 @@ static void arcmsr_enable_eoi_mode(struc=0A=
 		{=0A=
 			struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);=0A=
-			if(arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
+			if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
 				printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");=0A=
 				return;=0A=
 			}=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_C:=0A=
+		return;=0A=
 	}=0A=
 	return;=0A=
 }=0A=
@@ -2426,21 +2851,33 @@ static void arcmsr_enable_eoi_mode(struc=0A=
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint8_t value[64];=0A=
-	int i;	=0A=
-	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-=0A=
+	int i, count =3D 0;=0A=
+	struct MessageUnit_A __iomem *pmuA =3D acb->pmuA;=0A=
+	struct MessageUnit_C __iomem *pmuC =3D acb->pmuC;=0A=
+	u32 temp =3D 0;=0A=
 	/* backup pci config data */=0A=
-	printk(KERN_ERR "arcmsr%d: executing hw bus reset .....\n", =
acb->host->host_no);=0A=
+	printk("arcmsr%d: executing hw bus reset .....\n", acb->host->host_no);=0A=
 	for (i=3D0; i<64; i++) {=0A=
 		pci_read_config_byte(acb->pdev, i, &value[i]);=0A=
 	}=0A=
 	/* hardware reset signal */=0A=
 	if ((acb->dev_id =3D=3D 0x1680)) {=0A=
-		writel(ARCMSR_ARC1680_BUS_RESET, &reg->reserved1[0]);=0A=
+		writel(ARCMSR_ARC1680_BUS_RESET, &pmuA->reserved1[0]);=0A=
+	} else if ((acb->dev_id =3D=3D 0x1880)) {=0A=
+		do {=0A=
+			count++;=0A=
+			writel(0xF, &pmuC->write_sequence);=0A=
+			writel(0x4, &pmuC->write_sequence);=0A=
+			writel(0xB, &pmuC->write_sequence);=0A=
+			writel(0x2, &pmuC->write_sequence);=0A=
+			writel(0x7, &pmuC->write_sequence);=0A=
+			writel(0xD, &pmuC->write_sequence);=0A=
+		} while ((((temp =3D readl(&pmuC->host_diagnostic)) | =
ARCMSR_ARC1880_DiagWrite_ENABLE) =3D=3D 0) && (count < 5));=0A=
+		writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);=0A=
 	} else {=0A=
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);=0A=
 	}=0A=
-	msleep(1000);=0A=
+	msleep(2000);=0A=
 	/* write back pci config data */=0A=
 	for (i=3D0;i<64;i++) {=0A=
 		pci_write_config_byte(acb->pdev, i, value[i]);=0A=
@@ -2448,29 +2885,6 @@ static void arcmsr_hardware_reset(struct=0A=
 	msleep(1000);=0A=
 	return;=0A=
 }=0A=
-/*=0A=
-************************************************************************=
****=0A=
-************************************************************************=
****=0A=
-*/=0A=
-int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)=0A=
-{=0A=
-		struct Scsi_Host *shost =3D NULL;=0A=
-		int i, isleep;=0A=
-=0A=
-		shost =3D cmd->device->host;=0A=
-		isleep =3D sleeptime / 10;=0A=
-		if (isleep > 0) {=0A=
-			for (i =3D 0; i < isleep; i ++) {=0A=
-				msleep(10000);=0A=
-			}=0A=
-		}=0A=
-=0A=
-		isleep =3D sleeptime % 10;=0A=
-		if (isleep > 0) {=0A=
-			msleep(isleep*1000);=0A=
-		}=0A=
-		return 0;=0A=
-}=0A=
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t intmask_org;=0A=
@@ -2523,37 +2936,35 @@ static int arcmsr_bus_reset(struct scsi_=0A=
 	uint32_t intmask_org, outbound_doorbell;=0A=
 	int retry_count =3D 0;=0A=
 	int rtn =3D FAILED;=0A=
-=0A=
 	acb =3D (struct AdapterControlBlock *) cmd->device->host->hostdata;=0A=
-	printk(KERN_ERR "arcmsr: executing eh bus reset .....num_resets =3D %d,=0A=
-		num_aborts =3D %d \n", acb->num_resets, acb->num_aborts);=0A=
+	printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets =3D %d, =
num_aborts =3D %d \n", acb->num_resets, acb->num_aborts);=0A=
 	acb->num_resets++;=0A=
 =0A=
 	switch(acb->adapter_type){=0A=
 		case ACB_ADAPTER_TYPE_A:{=0A=
 			if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
 				long timeout;=0A=
-				timeout =3D wait_event_timeout(wait_q,=0A=
-					(acb->acb_flags & ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);=0A=
+				printk(KERN_ERR "arcmsr: there is an  bus reset eh =
proceeding.......\n");=0A=
+				timeout =3D wait_event_timeout(wait_q, (acb->acb_flags & =
ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);=0A=
 				if (timeout) {=0A=
 					return SUCCESS;=0A=
 				}=0A=
 			}=0A=
 			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
-			if (arcmsr_iop_reset(acb)) {=0A=
+			if (!arcmsr_iop_reset(acb)) {=0A=
 				struct MessageUnit_A __iomem *reg;=0A=
 				reg =3D acb->pmuA;=0A=
+				spin_unlock_irq(acb->host->host_lock);=0A=
 				arcmsr_hardware_reset(acb);=0A=
 				acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
 				sleep_again:=0A=
 				arcmsr_sleep_for_bus_reset(cmd);=0A=
 				if ((readl(&reg->outbound_msgaddr1) & =
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0) {=0A=
-					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,=0A=
-						retry=3D%d \n", acb->host->host_no, retry_count);=0A=
+					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, =
retry=3D%d \n", acb->host->host_no, retry_count);=0A=
 					if (retry_count > retrycount) {=0A=
 						acb->fw_flag =3D FW_DEADLOCK;=0A=
-						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,=0A=
-							RETRY TERMINATED!! \n", acb->host->host_no);=0A=
+						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRY =
TERMINATED!! \n", acb->host->host_no);=0A=
+						spin_lock_irq(acb->host->host_lock);=0A=
 						return FAILED;=0A=
 					}=0A=
 					retry_count++;=0A=
@@ -2580,7 +2991,8 @@ static int arcmsr_bus_reset(struct scsi_=0A=
 				add_timer(&acb->eternal_timer);=0A=
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
 				rtn =3D SUCCESS;=0A=
-				printk(KERN_ERR "arcmsr: scsi eh bus reset succeeds\n");=0A=
+				printk(KERN_ERR "arcmsr: scsi  bus reset eh returns with =
success\n");=0A=
+				spin_lock_irq(acb->host->host_lock);=0A=
 			} else {=0A=
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
 				if (atomic_read(&acb->rq_map_token) =3D=3D 0) {=0A=
@@ -2604,7 +3016,7 @@ static int arcmsr_bus_reset(struct scsi_=0A=
 		}=0A=
 		case ACB_ADAPTER_TYPE_B:{=0A=
 			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
-			if (arcmsr_iop_reset(acb)) {=0A=
+			if (!arcmsr_iop_reset(acb)) {=0A=
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
 				rtn =3D FAILED;=0A=
 			} else {=0A=
@@ -2626,6 +3038,77 @@ static int arcmsr_bus_reset(struct scsi_=0A=
 				}=0A=
 				rtn =3D SUCCESS;=0A=
 			}=0A=
+			break;=0A=
+		}=0A=
+		case ACB_ADAPTER_TYPE_C:{=0A=
+			if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
+				long timeout;=0A=
+				printk(KERN_ERR "arcmsr: there is an bus reset eh =
proceeding.......\n");=0A=
+				timeout =3D wait_event_timeout(wait_q, (acb->acb_flags & =
ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);=0A=
+				if (timeout) {=0A=
+					return SUCCESS;=0A=
+				}=0A=
+			}=0A=
+			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+			if (!arcmsr_iop_reset(acb)) {=0A=
+				struct MessageUnit_C __iomem *reg;=0A=
+				reg =3D acb->pmuC;=0A=
+				arcmsr_hardware_reset(acb);=0A=
+				acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
+				sleep:=0A=
+				arcmsr_sleep_for_bus_reset(cmd);=0A=
+				if ((readl(&reg->host_diagnostic) & 0x04) !=3D 0) {=0A=
+					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, =
retry=3D%d \n", acb->host->host_no, retry_count);=0A=
+					if (retry_count > retrycount) {=0A=
+						acb->fw_flag =3D FW_DEADLOCK;=0A=
+						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRY =
TERMINATED!! \n", acb->host->host_no);=0A=
+						return FAILED;=0A=
+					}=0A=
+					retry_count++;=0A=
+					goto sleep;=0A=
+				}=0A=
+				acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
+				/* disable all outbound interrupt */=0A=
+				intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+				arcmsr_get_firmware_spec(acb);=0A=
+				arcmsr_start_adapter_bgrb(acb);=0A=
+				/* clear Qbuffer if door bell ringed */=0A=
+				outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+				writel(outbound_doorbell, &reg->outbound_doorbell_clear); /*clear =
interrupt */=0A=
+				writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+				/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
+				arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+				atomic_set(&acb->rq_map_token, 16);=0A=
+				atomic_set(&acb->ante_token_value, 16);=0A=
+				acb->fw_flag =3D FW_NORMAL;=0A=
+				init_timer(&acb->eternal_timer);=0A=
+				acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6 * HZ);=0A=
+				acb->eternal_timer.data =3D (unsigned long) acb;=0A=
+				acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
+				add_timer(&acb->eternal_timer);=0A=
+				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+				rtn =3D SUCCESS;=0A=
+				printk(KERN_ERR "arcmsr: scsi bus reset eh returns with success\n");=0A=
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
+				}=0A=
+				rtn =3D SUCCESS;=0A=
+			}=0A=
+			break;=0A=
 		}=0A=
 	}=0A=
 	return rtn;=0A=
@@ -2635,9 +3118,7 @@ static int arcmsr_abort_one_cmd(struct A=0A=
 		struct CommandControlBlock *ccb)=0A=
 {=0A=
 	int rtn;=0A=
-	spin_lock_irq(&acb->eh_lock);=0A=
 	rtn =3D arcmsr_polling_ccbdone(acb, ccb);=0A=
-	spin_unlock_irq(&acb->eh_lock);=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
@@ -2663,7 +3143,6 @@ static int arcmsr_abort(struct scsi_cmnd=0A=
 		return rtn;=0A=
 =0A=
 	for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
-		printk("%s: loop %d\n", __FUNCTION__, i);=0A=
 		struct CommandControlBlock *ccb =3D acb->pccb_pool[i];=0A=
 		if (ccb->startdone =3D=3D ARCMSR_CCB_START && ccb->pcmd =3D=3D cmd) {=0A=
 			ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
@@ -2672,7 +3151,6 @@ static int arcmsr_abort(struct scsi_cmnd=0A=
 		}=0A=
 	}=0A=
 	acb->acb_flags &=3D ~ACB_F_ABORT;=0A=
-	printk("%s: leaving\n", __FUNCTION__);=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
@@ -2707,6 +3184,7 @@ static const char *arcmsr_info(struct Sc=0A=
 	case PCI_DEVICE_ID_ARECA_1381:=0A=
 	case PCI_DEVICE_ID_ARECA_1680:=0A=
 	case PCI_DEVICE_ID_ARECA_1681:=0A=
+	case PCI_DEVICE_ID_ARECA_1880:=0A=
 		type =3D "SAS";=0A=
 		break;=0A=
 	default:=0A=

------=_NextPart_000_0009_01CADCA4.26EBB810--

