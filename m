From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: Fix the issue of system hangup after commands timeout on ARC-1200(Type_B controller)
Date: Thu, 6 Jan 2011 17:32:41 +0800
Message-ID: <DDD2521416374E20B1DA60AC6177C279@arecaaebe11fae>
References: <4D1F5A17.4010807@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0006_01CBADC7.BB4576A0"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D1F5A17.4010807@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de, 'Andrew Morton' <akpm@linux-foundation.org>
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0006_01CBADC7.BB4576A0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit


Fix the issue of system hangup after commands timeout on ARC-1200

Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---
diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 475c31a..77b26f5 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -2,7 +2,7 @@
 
****************************************************************************
***
 **        O.S   : Linux
 **   FILE NAME  : arcmsr.h
-**        BY    : Erich Chen
+**        BY    : Nick Cheng
 **   Description: SCSI RAID Device Driver for
 **                ARECA RAID Host adapter
 
****************************************************************************
***
@@ -46,8 +46,12 @@
 struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
 #define ARCMSR_MAX_OUTSTANDING_CMD
256
-#define ARCMSR_MAX_FREECCB_NUM
320
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15
2010/02/02"
+#ifdef CONFIG_XEN
+	#define ARCMSR_MAX_FREECCB_NUM	160
+#else
+	#define ARCMSR_MAX_FREECCB_NUM	320
+#endif
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15
2010/08/05"
 #define ARCMSR_SCSI_INITIATOR_ID
255
 #define ARCMSR_MAX_XFER_SECTORS
512
 #define ARCMSR_MAX_XFER_SECTORS_B
4096
@@ -60,7 +64,6 @@ struct device_attribute;
 #define ARCMSR_MAX_HBB_POSTQUEUE
264
 #define ARCMSR_MAX_XFER_LEN
0x26000 /* 152K */
 #define ARCMSR_CDB_SG_PAGE_LENGTH
256 
-#define SCSI_CMD_ARECA_SPECIFIC
0xE1
 #ifndef PCI_DEVICE_ID_ARECA_1880
 #define PCI_DEVICE_ID_ARECA_1880 0x1880
  #endif
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c
b/drivers/scsi/arcmsr/arcmsr_attr.c
index a4e04c5..acdae33 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -2,7 +2,7 @@
 
****************************************************************************
***
 **        O.S   : Linux
 **   FILE NAME  : arcmsr_attr.c
-**        BY    : Erich Chen
+**        BY    : Nick Cheng
 **   Description: attributes exported to sysfs and device host
 
****************************************************************************
***
 ** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights
reserved
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
b/drivers/scsi/arcmsr/arcmsr_hba.c
index 17e3df4..c650310 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2,7 +2,7 @@
 
****************************************************************************
***
 **        O.S   : Linux
 **   FILE NAME  : arcmsr_hba.c
-**        BY    : Erich Chen
+**        BY    : Nick Cheng
 **   Description: SCSI RAID Device Driver for
 **                ARECA RAID Host adapter
 
****************************************************************************
***
@@ -76,7 +76,7 @@ MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880)
SATA/SAS RAID Host Bus Adapte
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 static int sleeptime = 10;
-static int retrycount = 30;
+static int retrycount = 12;
 wait_queue_head_t wait_q;
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 					struct scsi_cmnd *cmd);
@@ -187,7 +187,6 @@ int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)
 		if (isleep > 0) {
 			msleep(isleep*1000);
 		}
-		printk(KERN_NOTICE "wake-up\n");
 		return 0;
 }
 
@@ -921,7 +920,6 @@ static void arcmsr_report_ccb_state(struct
AdapterControlBlock *acb,
 }
 
 static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, struct
CommandControlBlock *pCCB, bool error)
-
 {
 	int id, lun;
 	if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
@@ -948,7 +946,7 @@ static void arcmsr_drain_donequeue(struct
AdapterControlBlock *acb, struct Comma
 				, pCCB->startdone
 				, atomic_read(&acb->ccboutstandingcount));
 		  return;
-		}
+	}
 	arcmsr_report_ccb_state(acb, pCCB, error);
 }
 
@@ -981,7 +979,7 @@ static void arcmsr_done4abort_postqueue(struct
AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
 		/*clear all outbound posted Q*/
-		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
&reg->iop2drv_doorbell); /* clear doorbell interrupt */
+		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
reg->iop2drv_doorbell); /* clear doorbell interrupt */
 		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
 			if ((flag_ccb = readl(&reg->done_qbuffer[i])) != 0)
{
 				writel(0, &reg->done_qbuffer[i]);
@@ -1171,7 +1169,7 @@ static int arcmsr_build_ccb(struct AdapterControlBlock
*acb,
 	arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 :
0);
 	if ( arccdbsize > 256)
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
-	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 ||
pcmd->cmnd[0]|WRITE_12 ){
+	if (pcmd->sc_data_direction == DMA_TO_DEVICE) {
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
 	}
 	ccb->arc_cdb_size = arccdbsize;
@@ -1512,7 +1510,6 @@ static void arcmsr_hba_postqueue_isr(struct
AdapterControlBlock *acb)
 		arcmsr_drain_donequeue(acb, pCCB, error);
 	}
 }
-
 static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t index;
@@ -2107,10 +2104,6 @@ static int arcmsr_queue_command_lck(struct scsi_cmnd
*cmd,
 	if (atomic_read(&acb->ccboutstandingcount) >=
 			ARCMSR_MAX_OUTSTANDING_CMD)
 		return SCSI_MLQUEUE_HOST_BUSY;
-	if ((scsicmd == SCSI_CMD_ARECA_SPECIFIC)) {
-		printk(KERN_NOTICE "Receiveing SCSI_CMD_ARECA_SPECIFIC
command..\n");
-		return 0;
-	}
 	ccb = arcmsr_get_freeccb(acb);
 	if (!ccb)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -2394,6 +2387,7 @@ static int arcmsr_polling_hbb_ccbdone(struct
AdapterControlBlock *acb,
 	int index, rtn;
 	bool error;
 	polling_hbb_ccb_retry:
+
 	poll_count++;
 	/* clear doorbell interrupt */
 	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
@@ -2664,6 +2658,7 @@ static void arcmsr_request_hba_device_map(struct
AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6
* HZ));
 		return;
 	} else {
 		acb->fw_flag = FW_NORMAL;
@@ -2671,8 +2666,10 @@ static void arcmsr_request_hba_device_map(struct
AdapterControlBlock *acb)
 			atomic_set(&acb->rq_map_token, 16);
 		}
 		atomic_set(&acb->ante_token_value,
atomic_read(&acb->rq_map_token));
-		if (atomic_dec_and_test(&acb->rq_map_token))
+		if (atomic_dec_and_test(&acb->rq_map_token)) {
+			mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
 			return;
+		}
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
&reg->inbound_msgaddr0);
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6
* HZ));
 	}
@@ -2683,15 +2680,18 @@ static void arcmsr_request_hbb_device_map(struct
AdapterControlBlock *acb)
 {
 	struct MessageUnit_B __iomem *reg = acb->pmuB;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6
* HZ));
 		return;
 	} else {
 		acb->fw_flag = FW_NORMAL;
 		if (atomic_read(&acb->ante_token_value) ==
atomic_read(&acb->rq_map_token)) {
-			atomic_set(&acb->rq_map_token,16);
+			atomic_set(&acb->rq_map_token, 16);
 		}
 		atomic_set(&acb->ante_token_value,
atomic_read(&acb->rq_map_token));
-		if(atomic_dec_and_test(&acb->rq_map_token))
+		if(atomic_dec_and_test(&acb->rq_map_token)) {
+			mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
 			return;
+		}
 		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6
* HZ));
 	}
@@ -2702,6 +2702,7 @@ static void arcmsr_request_hbc_device_map(struct
AdapterControlBlock *acb)
 {
 	struct MessageUnit_C __iomem *reg = acb->pmuC;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0) || ((acb->acb_flags & ACB_F_ABORT)
!= 0)) {
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6
* HZ));
 		return;
 	} else {
 		acb->fw_flag = FW_NORMAL;
@@ -2709,8 +2710,10 @@ static void arcmsr_request_hbc_device_map(struct
AdapterControlBlock *acb)
 			atomic_set(&acb->rq_map_token, 16);
 		}
 		atomic_set(&acb->ante_token_value,
atomic_read(&acb->rq_map_token));
-		if (atomic_dec_and_test(&acb->rq_map_token))
+		if (atomic_dec_and_test(&acb->rq_map_token)) {
+			mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
 			return;
+		}
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
&reg->inbound_msgaddr0);
 		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6
* HZ));
@@ -2898,6 +2901,8 @@ static uint8_t arcmsr_iop_reset(struct
AdapterControlBlock *acb)
 	uint32_t intmask_org;
 	uint8_t rtnval = 0x00;
 	int i = 0;
+	unsigned long flags;
+
 	if (atomic_read(&acb->ccboutstandingcount) != 0) {
 		/* disable all outbound interrupt */
 		intmask_org = arcmsr_disable_outbound_ints(acb);
@@ -2908,7 +2913,12 @@ static uint8_t arcmsr_iop_reset(struct
AdapterControlBlock *acb)
 		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
 			ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
-				arcmsr_ccb_complete(ccb);
+				scsi_dma_unmap(ccb->pcmd);
+				ccb->startdone = ARCMSR_CCB_DONE;
+				ccb->ccb_flags = 0;
+				spin_lock_irqsave(&acb->ccblist_lock,
flags);
+				list_add_tail(&ccb->list,
&acb->ccb_free_list);
+				spin_unlock_irqrestore(&acb->ccblist_lock,
flags);
 			}
 		}
 		atomic_set(&acb->ccboutstandingcount, 0);
@@ -2921,8 +2931,7 @@ static uint8_t arcmsr_iop_reset(struct
AdapterControlBlock *acb)
 
 static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
 {
-	struct AdapterControlBlock *acb =
-		(struct AdapterControlBlock *)cmd->device->host->hostdata;
+	struct AdapterControlBlock *acb;
 	uint32_t intmask_org, outbound_doorbell;
 	int retry_count = 0;
 	int rtn = FAILED;
@@ -2972,31 +2981,16 @@ sleep_again:
 				atomic_set(&acb->rq_map_token, 16);
 				atomic_set(&acb->ante_token_value, 16);
 				acb->fw_flag = FW_NORMAL;
-				init_timer(&acb->eternal_timer);
-				acb->eternal_timer.expires = jiffies +
msecs_to_jiffies(6*HZ);
-				acb->eternal_timer.data = (unsigned long)
acb;
-				acb->eternal_timer.function =
&arcmsr_request_device_map;
-				add_timer(&acb->eternal_timer);
+				mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
 				acb->acb_flags &= ~ACB_F_BUS_RESET;
 				rtn = SUCCESS;
 				printk(KERN_ERR "arcmsr: scsi  bus reset eh
returns with success\n");
 			} else {
 				acb->acb_flags &= ~ACB_F_BUS_RESET;
-				if (atomic_read(&acb->rq_map_token) == 0) {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value,
16);
-					acb->fw_flag = FW_NORMAL;
-					init_timer(&acb->eternal_timer);
-						acb->eternal_timer.expires =
jiffies + msecs_to_jiffies(6*HZ);
-					acb->eternal_timer.data = (unsigned
long) acb;
-					acb->eternal_timer.function =
&arcmsr_request_device_map;
-					add_timer(&acb->eternal_timer);
-				} else {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value,
16);
-					acb->fw_flag = FW_NORMAL;
-					mod_timer(&acb->eternal_timer,
jiffies + msecs_to_jiffies(6*HZ));
-				}
+				atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);
+				acb->fw_flag = FW_NORMAL;
+				mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6*HZ));
 				rtn = SUCCESS;
 			}
 			break;
@@ -3008,21 +3002,10 @@ sleep_again:
 				rtn = FAILED;
 			} else {
 				acb->acb_flags &= ~ACB_F_BUS_RESET;
-				if (atomic_read(&acb->rq_map_token) == 0) {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value,
16);
-					acb->fw_flag = FW_NORMAL;
-					init_timer(&acb->eternal_timer);
-						acb->eternal_timer.expires =
jiffies + msecs_to_jiffies(6*HZ);
-					acb->eternal_timer.data = (unsigned
long) acb;
-					acb->eternal_timer.function =
&arcmsr_request_device_map;
-					add_timer(&acb->eternal_timer);
-				} else {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value,
16);
-					acb->fw_flag = FW_NORMAL;
-					mod_timer(&acb->eternal_timer,
jiffies + msecs_to_jiffies(6*HZ));
-				}
+				atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);
+				acb->fw_flag = FW_NORMAL;
+				mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
 				rtn = SUCCESS;
 			}
 			break;
@@ -3068,31 +3051,16 @@ sleep:
 				atomic_set(&acb->rq_map_token, 16);
 				atomic_set(&acb->ante_token_value, 16);
 				acb->fw_flag = FW_NORMAL;
-				init_timer(&acb->eternal_timer);
-				acb->eternal_timer.expires = jiffies +
msecs_to_jiffies(6 * HZ);
-				acb->eternal_timer.data = (unsigned long)
acb;
-				acb->eternal_timer.function =
&arcmsr_request_device_map;
-				add_timer(&acb->eternal_timer);
+				mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
 				acb->acb_flags &= ~ACB_F_BUS_RESET;
 				rtn = SUCCESS;
 				printk(KERN_ERR "arcmsr: scsi bus reset eh
returns with success\n");
 			} else {
 				acb->acb_flags &= ~ACB_F_BUS_RESET;
-				if (atomic_read(&acb->rq_map_token) == 0) {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value,
16);
-					acb->fw_flag = FW_NORMAL;
-					init_timer(&acb->eternal_timer);
-						acb->eternal_timer.expires =
jiffies + msecs_to_jiffies(6*HZ);
-					acb->eternal_timer.data = (unsigned
long) acb;
-					acb->eternal_timer.function =
&arcmsr_request_device_map;
-					add_timer(&acb->eternal_timer);
-				} else {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value,
16);
-					acb->fw_flag = FW_NORMAL;
-					mod_timer(&acb->eternal_timer,
jiffies + msecs_to_jiffies(6*HZ));
-				}
+				atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);
+				acb->fw_flag = FW_NORMAL;
+				mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6*HZ));
 				rtn = SUCCESS;
 			}
 			break;

------=_NextPart_000_0006_01CBADC7.BB4576A0
Content-Type: application/octet-stream;
	name="patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch"

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
index 475c31a..77b26f5 100644=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h=0A=
@@ -2,7 +2,7 @@=0A=
 =
*************************************************************************=
******=0A=
 **        O.S   : Linux=0A=
 **   FILE NAME  : arcmsr.h=0A=
-**        BY    : Erich Chen=0A=
+**        BY    : Nick Cheng=0A=
 **   Description: SCSI RAID Device Driver for=0A=
 **                ARECA RAID Host adapter=0A=
 =
*************************************************************************=
******=0A=
@@ -46,8 +46,12 @@=0A=
 struct device_attribute;=0A=
 /*The limit of outstanding scsi command that firmware can handle*/=0A=
 #define ARCMSR_MAX_OUTSTANDING_CMD						256=0A=
-#define ARCMSR_MAX_FREECCB_NUM							320=0A=
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2010/02/02"=0A=
+#ifdef CONFIG_XEN=0A=
+	#define ARCMSR_MAX_FREECCB_NUM	160=0A=
+#else=0A=
+	#define ARCMSR_MAX_FREECCB_NUM	320=0A=
+#endif=0A=
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2010/08/05"=0A=
 #define ARCMSR_SCSI_INITIATOR_ID						255=0A=
 #define ARCMSR_MAX_XFER_SECTORS							512=0A=
 #define ARCMSR_MAX_XFER_SECTORS_B						4096=0A=
@@ -60,7 +64,6 @@ struct device_attribute;=0A=
 #define ARCMSR_MAX_HBB_POSTQUEUE						264=0A=
 #define ARCMSR_MAX_XFER_LEN							0x26000 /* 152K */=0A=
 #define ARCMSR_CDB_SG_PAGE_LENGTH						256 =0A=
-#define SCSI_CMD_ARECA_SPECIFIC						0xE1=0A=
 #ifndef PCI_DEVICE_ID_ARECA_1880=0A=
 #define PCI_DEVICE_ID_ARECA_1880 0x1880=0A=
  #endif=0A=
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c =
b/drivers/scsi/arcmsr/arcmsr_attr.c=0A=
index a4e04c5..acdae33 100644=0A=
--- a/drivers/scsi/arcmsr/arcmsr_attr.c=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c=0A=
@@ -2,7 +2,7 @@=0A=
 =
*************************************************************************=
******=0A=
 **        O.S   : Linux=0A=
 **   FILE NAME  : arcmsr_attr.c=0A=
-**        BY    : Erich Chen=0A=
+**        BY    : Nick Cheng=0A=
 **   Description: attributes exported to sysfs and device host=0A=
 =
*************************************************************************=
******=0A=
 ** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights =
reserved=0A=
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
index 17e3df4..c650310 100644=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
@@ -2,7 +2,7 @@=0A=
 =
*************************************************************************=
******=0A=
 **        O.S   : Linux=0A=
 **   FILE NAME  : arcmsr_hba.c=0A=
-**        BY    : Erich Chen=0A=
+**        BY    : Nick Cheng=0A=
 **   Description: SCSI RAID Device Driver for=0A=
 **                ARECA RAID Host adapter=0A=
 =
*************************************************************************=
******=0A=
@@ -76,7 +76,7 @@ MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) =
SATA/SAS RAID Host Bus Adapte=0A=
 MODULE_LICENSE("Dual BSD/GPL");=0A=
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);=0A=
 static int sleeptime =3D 10;=0A=
-static int retrycount =3D 30;=0A=
+static int retrycount =3D 12;=0A=
 wait_queue_head_t wait_q;=0A=
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
 					struct scsi_cmnd *cmd);=0A=
@@ -187,7 +187,6 @@ int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)=0A=
 		if (isleep > 0) {=0A=
 			msleep(isleep*1000);=0A=
 		}=0A=
-		printk(KERN_NOTICE "wake-up\n");=0A=
 		return 0;=0A=
 }=0A=
 =0A=
@@ -921,7 +920,6 @@ static void arcmsr_report_ccb_state(struct =
AdapterControlBlock *acb,=0A=
 }=0A=
 =0A=
 static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, =
struct CommandControlBlock *pCCB, bool error)=0A=
-=0A=
 {=0A=
 	int id, lun;=0A=
 	if ((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
@@ -948,7 +946,7 @@ static void arcmsr_drain_donequeue(struct =
AdapterControlBlock *acb, struct Comma=0A=
 				, pCCB->startdone=0A=
 				, atomic_read(&acb->ccboutstandingcount));=0A=
 		  return;=0A=
-		}=0A=
+	}=0A=
 	arcmsr_report_ccb_state(acb, pCCB, error);=0A=
 }=0A=
 =0A=
@@ -981,7 +979,7 @@ static void arcmsr_done4abort_postqueue(struct =
AdapterControlBlock *acb)=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 		/*clear all outbound posted Q*/=0A=
-		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, &reg->iop2drv_doorbell); /* =
clear doorbell interrupt */=0A=
+		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /* =
clear doorbell interrupt */=0A=
 		for (i =3D 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {=0A=
 			if ((flag_ccb =3D readl(&reg->done_qbuffer[i])) !=3D 0) {=0A=
 				writel(0, &reg->done_qbuffer[i]);=0A=
@@ -1171,7 +1169,7 @@ static int arcmsr_build_ccb(struct =
AdapterControlBlock *acb,=0A=
 	arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : =
0);=0A=
 	if ( arccdbsize > 256)=0A=
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_SGL_BSIZE;=0A=
-	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || =
pcmd->cmnd[0]|WRITE_12 ){=0A=
+	if (pcmd->sc_data_direction =3D=3D DMA_TO_DEVICE) {=0A=
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_WRITE;=0A=
 	}=0A=
 	ccb->arc_cdb_size =3D arccdbsize;=0A=
@@ -1512,7 +1510,6 @@ static void arcmsr_hba_postqueue_isr(struct =
AdapterControlBlock *acb)=0A=
 		arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 	}=0A=
 }=0A=
-=0A=
 static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t index;=0A=
@@ -2107,10 +2104,6 @@ static int arcmsr_queue_command_lck(struct =
scsi_cmnd *cmd,=0A=
 	if (atomic_read(&acb->ccboutstandingcount) >=3D=0A=
 			ARCMSR_MAX_OUTSTANDING_CMD)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
-	if ((scsicmd =3D=3D SCSI_CMD_ARECA_SPECIFIC)) {=0A=
-		printk(KERN_NOTICE "Receiveing SCSI_CMD_ARECA_SPECIFIC command..\n");=0A=
-		return 0;=0A=
-	}=0A=
 	ccb =3D arcmsr_get_freeccb(acb);=0A=
 	if (!ccb)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
@@ -2394,6 +2387,7 @@ static int arcmsr_polling_hbb_ccbdone(struct =
AdapterControlBlock *acb,=0A=
 	int index, rtn;=0A=
 	bool error;=0A=
 	polling_hbb_ccb_retry:=0A=
+=0A=
 	poll_count++;=0A=
 	/* clear doorbell interrupt */=0A=
 	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
@@ -2664,6 +2658,7 @@ static void arcmsr_request_hba_device_map(struct =
AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0 ) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0 )){=0A=
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 		return;=0A=
 	} else {=0A=
 		acb->fw_flag =3D FW_NORMAL;=0A=
@@ -2671,8 +2666,10 @@ static void arcmsr_request_hba_device_map(struct =
AdapterControlBlock *acb)=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
 		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
-		if (atomic_dec_and_test(&acb->rq_map_token))=0A=
+		if (atomic_dec_and_test(&acb->rq_map_token)) {=0A=
+			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 			return;=0A=
+		}=0A=
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
@@ -2683,15 +2680,18 @@ static void arcmsr_request_hbb_device_map(struct =
AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0 ) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0 )){=0A=
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 		return;=0A=
 	} else {=0A=
 		acb->fw_flag =3D FW_NORMAL;=0A=
 		if (atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)) {=0A=
-			atomic_set(&acb->rq_map_token,16);=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
 		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
-		if(atomic_dec_and_test(&acb->rq_map_token))=0A=
+		if(atomic_dec_and_test(&acb->rq_map_token)) {=0A=
+			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 			return;=0A=
+		}=0A=
 		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);=0A=
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
@@ -2702,6 +2702,7 @@ static void arcmsr_request_hbc_device_map(struct =
AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0)) {=0A=
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 		return;=0A=
 	} else {=0A=
 		acb->fw_flag =3D FW_NORMAL;=0A=
@@ -2709,8 +2710,10 @@ static void arcmsr_request_hbc_device_map(struct =
AdapterControlBlock *acb)=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
 		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
-		if (atomic_dec_and_test(&acb->rq_map_token))=0A=
+		if (atomic_dec_and_test(&acb->rq_map_token)) {=0A=
+			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 			return;=0A=
+		}=0A=
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
 		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
@@ -2898,6 +2901,8 @@ static uint8_t arcmsr_iop_reset(struct =
AdapterControlBlock *acb)=0A=
 	uint32_t intmask_org;=0A=
 	uint8_t rtnval =3D 0x00;=0A=
 	int i =3D 0;=0A=
+	unsigned long flags;=0A=
+=0A=
 	if (atomic_read(&acb->ccboutstandingcount) !=3D 0) {=0A=
 		/* disable all outbound interrupt */=0A=
 		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
@@ -2908,7 +2913,12 @@ static uint8_t arcmsr_iop_reset(struct =
AdapterControlBlock *acb)=0A=
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
 			ccb =3D acb->pccb_pool[i];=0A=
 			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {=0A=
-				arcmsr_ccb_complete(ccb);=0A=
+				scsi_dma_unmap(ccb->pcmd);=0A=
+				ccb->startdone =3D ARCMSR_CCB_DONE;=0A=
+				ccb->ccb_flags =3D 0;=0A=
+				spin_lock_irqsave(&acb->ccblist_lock, flags);=0A=
+				list_add_tail(&ccb->list, &acb->ccb_free_list);=0A=
+				spin_unlock_irqrestore(&acb->ccblist_lock, flags);=0A=
 			}=0A=
 		}=0A=
 		atomic_set(&acb->ccboutstandingcount, 0);=0A=
@@ -2921,8 +2931,7 @@ static uint8_t arcmsr_iop_reset(struct =
AdapterControlBlock *acb)=0A=
 =0A=
 static int arcmsr_bus_reset(struct scsi_cmnd *cmd)=0A=
 {=0A=
-	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *)cmd->device->host->hostdata;=0A=
+	struct AdapterControlBlock *acb;=0A=
 	uint32_t intmask_org, outbound_doorbell;=0A=
 	int retry_count =3D 0;=0A=
 	int rtn =3D FAILED;=0A=
@@ -2972,31 +2981,16 @@ sleep_again:=0A=
 				atomic_set(&acb->rq_map_token, 16);=0A=
 				atomic_set(&acb->ante_token_value, 16);=0A=
 				acb->fw_flag =3D FW_NORMAL;=0A=
-				init_timer(&acb->eternal_timer);=0A=
-				acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6*HZ);=0A=
-				acb->eternal_timer.data =3D (unsigned long) acb;=0A=
-				acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
-				add_timer(&acb->eternal_timer);=0A=
+				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
 				rtn =3D SUCCESS;=0A=
 				printk(KERN_ERR "arcmsr: scsi  bus reset eh returns with =
success\n");=0A=
 			} else {=0A=
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				if (atomic_read(&acb->rq_map_token) =3D=3D 0) {=0A=
-					atomic_set(&acb->rq_map_token, 16);=0A=
-					atomic_set(&acb->ante_token_value, 16);=0A=
-					acb->fw_flag =3D FW_NORMAL;=0A=
-					init_timer(&acb->eternal_timer);=0A=
-						acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6*HZ);=0A=
-					acb->eternal_timer.data =3D (unsigned long) acb;=0A=
-					acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
-					add_timer(&acb->eternal_timer);=0A=
-				} else {=0A=
-					atomic_set(&acb->rq_map_token, 16);=0A=
-					atomic_set(&acb->ante_token_value, 16);=0A=
-					acb->fw_flag =3D FW_NORMAL;=0A=
-					mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
-				}=0A=
+				atomic_set(&acb->rq_map_token, 16);=0A=
+				atomic_set(&acb->ante_token_value, 16);=0A=
+				acb->fw_flag =3D FW_NORMAL;=0A=
+				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
 				rtn =3D SUCCESS;=0A=
 			}=0A=
 			break;=0A=
@@ -3008,21 +3002,10 @@ sleep_again:=0A=
 				rtn =3D FAILED;=0A=
 			} else {=0A=
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				if (atomic_read(&acb->rq_map_token) =3D=3D 0) {=0A=
-					atomic_set(&acb->rq_map_token, 16);=0A=
-					atomic_set(&acb->ante_token_value, 16);=0A=
-					acb->fw_flag =3D FW_NORMAL;=0A=
-					init_timer(&acb->eternal_timer);=0A=
-						acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6*HZ);=0A=
-					acb->eternal_timer.data =3D (unsigned long) acb;=0A=
-					acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
-					add_timer(&acb->eternal_timer);=0A=
-				} else {=0A=
-					atomic_set(&acb->rq_map_token, 16);=0A=
-					atomic_set(&acb->ante_token_value, 16);=0A=
-					acb->fw_flag =3D FW_NORMAL;=0A=
-					mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
-				}=0A=
+				atomic_set(&acb->rq_map_token, 16);=0A=
+				atomic_set(&acb->ante_token_value, 16);=0A=
+				acb->fw_flag =3D FW_NORMAL;=0A=
+				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 				rtn =3D SUCCESS;=0A=
 			}=0A=
 			break;=0A=
@@ -3068,31 +3051,16 @@ sleep:=0A=
 				atomic_set(&acb->rq_map_token, 16);=0A=
 				atomic_set(&acb->ante_token_value, 16);=0A=
 				acb->fw_flag =3D FW_NORMAL;=0A=
-				init_timer(&acb->eternal_timer);=0A=
-				acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6 * HZ);=0A=
-				acb->eternal_timer.data =3D (unsigned long) acb;=0A=
-				acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
-				add_timer(&acb->eternal_timer);=0A=
+				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
 				rtn =3D SUCCESS;=0A=
 				printk(KERN_ERR "arcmsr: scsi bus reset eh returns with success\n");=0A=
 			} else {=0A=
 				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				if (atomic_read(&acb->rq_map_token) =3D=3D 0) {=0A=
-					atomic_set(&acb->rq_map_token, 16);=0A=
-					atomic_set(&acb->ante_token_value, 16);=0A=
-					acb->fw_flag =3D FW_NORMAL;=0A=
-					init_timer(&acb->eternal_timer);=0A=
-						acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6*HZ);=0A=
-					acb->eternal_timer.data =3D (unsigned long) acb;=0A=
-					acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
-					add_timer(&acb->eternal_timer);=0A=
-				} else {=0A=
-					atomic_set(&acb->rq_map_token, 16);=0A=
-					atomic_set(&acb->ante_token_value, 16);=0A=
-					acb->fw_flag =3D FW_NORMAL;=0A=
-					mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
-				}=0A=
+				atomic_set(&acb->rq_map_token, 16);=0A=
+				atomic_set(&acb->ante_token_value, 16);=0A=
+				acb->fw_flag =3D FW_NORMAL;=0A=
+				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
 				rtn =3D SUCCESS;=0A=
 			}=0A=
 			break;=0A=

------=_NextPart_000_0006_01CBADC7.BB4576A0--
