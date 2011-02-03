From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI fixes for 2.6.38-rc3
Date: Thu, 03 Feb 2011 15:24:37 -0600
Message-ID: <1296768277.3022.498.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56628 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab1BCVYn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2011 16:24:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a set of misc fixes; mostly in mpt2sas, although there's a SCSI
scatterlist compile issue and a fix to the libsas error handler as well.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short change log is:

David Dillow (1):
      fix incorrect value of SCSI_MAX_SG_CHAIN_SEGMENTS due to include file ordering

James Bottomley (1):
      libsas: fix runaway error handler problem

Kashyap, Desai (6):
      mpt2sas: fix Integrated Raid unsynced on shutdown problem
      mpt2sas: Kernel Panic during Large Topology discovery
      mpt2sas: Fix the race between broadcast asyn event and scsi command completion
      mpt2sas: Correct resizing calculation for max_queue_depth
      mpt2sas: fix internal device reset for older firmware prior to MPI Rev K
      mpt2sas: Fix device removal handshake for zoned devices

NickCheng (1):
      arcmsr: Fix the issue of system hangup after commands timeout on ARC-1200


and the diffstat:

 drivers/scsi/arcmsr/arcmsr.h         |   11 ++-
 drivers/scsi/arcmsr/arcmsr_attr.c    |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c     |  114 ++++++++++++----------------------
 drivers/scsi/libsas/sas_scsi_host.c  |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c  |   19 ++++--
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   64 +++++++++++++++----
 include/scsi/scsi.h                  |    1 +
 7 files changed, 117 insertions(+), 95 deletions(-)

The full diff is below.

James

---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 475c31a..77b26f5 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -2,7 +2,7 @@
 *******************************************************************************
 **        O.S   : Linux
 **   FILE NAME  : arcmsr.h
-**        BY    : Erich Chen
+**        BY    : Nick Cheng
 **   Description: SCSI RAID Device Driver for
 **                ARECA RAID Host adapter
 *******************************************************************************
@@ -46,8 +46,12 @@
 struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
 #define ARCMSR_MAX_OUTSTANDING_CMD						256
-#define ARCMSR_MAX_FREECCB_NUM							320
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2010/02/02"
+#ifdef CONFIG_XEN
+	#define ARCMSR_MAX_FREECCB_NUM	160
+#else
+	#define ARCMSR_MAX_FREECCB_NUM	320
+#endif
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2010/08/05"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
 #define ARCMSR_MAX_XFER_SECTORS_B						4096
@@ -60,7 +64,6 @@ struct device_attribute;
 #define ARCMSR_MAX_HBB_POSTQUEUE						264
 #define ARCMSR_MAX_XFER_LEN							0x26000 /* 152K */
 #define ARCMSR_CDB_SG_PAGE_LENGTH						256 
-#define SCSI_CMD_ARECA_SPECIFIC						0xE1
 #ifndef PCI_DEVICE_ID_ARECA_1880
 #define PCI_DEVICE_ID_ARECA_1880 0x1880
  #endif
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index a4e04c5..acdae33 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **        O.S   : Linux
 **   FILE NAME  : arcmsr_attr.c
-**        BY    : Erich Chen
+**        BY    : Nick Cheng
 **   Description: attributes exported to sysfs and device host
 *******************************************************************************
 ** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights reserved
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 1cadcd6..984bd52 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **        O.S   : Linux
 **   FILE NAME  : arcmsr_hba.c
-**        BY    : Erich Chen
+**        BY    : Nick Cheng
 **   Description: SCSI RAID Device Driver for
 **                ARECA RAID Host adapter
 *******************************************************************************
@@ -76,7 +76,7 @@ MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host Bus Adapte
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
 
@@ -921,7 +920,6 @@ static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
 }
 
 static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, struct CommandControlBlock *pCCB, bool error)
-
 {
 	int id, lun;
 	if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
@@ -948,7 +946,7 @@ static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, struct Comma
 				, pCCB->startdone
 				, atomic_read(&acb->ccboutstandingcount));
 		  return;
-		}
+	}
 	arcmsr_report_ccb_state(acb, pCCB, error);
 }
 
@@ -981,7 +979,7 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
 		/*clear all outbound posted Q*/
-		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, &reg->iop2drv_doorbell); /* clear doorbell interrupt */
+		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /* clear doorbell interrupt */
 		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
 			if ((flag_ccb = readl(&reg->done_qbuffer[i])) != 0) {
 				writel(0, &reg->done_qbuffer[i]);
@@ -1511,7 +1509,6 @@ static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)
 		arcmsr_drain_donequeue(acb, pCCB, error);
 	}
 }
-
 static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t index;
@@ -2106,10 +2103,6 @@ static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
 	if (atomic_read(&acb->ccboutstandingcount) >=
 			ARCMSR_MAX_OUTSTANDING_CMD)
 		return SCSI_MLQUEUE_HOST_BUSY;
-	if ((scsicmd == SCSI_CMD_ARECA_SPECIFIC)) {
-		printk(KERN_NOTICE "Receiveing SCSI_CMD_ARECA_SPECIFIC command..\n");
-		return 0;
-	}
 	ccb = arcmsr_get_freeccb(acb);
 	if (!ccb)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -2393,6 +2386,7 @@ static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
 	int index, rtn;
 	bool error;
 	polling_hbb_ccb_retry:
+
 	poll_count++;
 	/* clear doorbell interrupt */
 	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
@@ -2663,6 +2657,7 @@ static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags & ACB_F_ABORT) != 0 )){
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 		return;
 	} else {
 		acb->fw_flag = FW_NORMAL;
@@ -2670,8 +2665,10 @@ static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb)
 			atomic_set(&acb->rq_map_token, 16);
 		}
 		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
-		if (atomic_dec_and_test(&acb->rq_map_token))
+		if (atomic_dec_and_test(&acb->rq_map_token)) {
+			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 			return;
+		}
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 	}
@@ -2682,15 +2679,18 @@ static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B __iomem *reg = acb->pmuB;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags & ACB_F_ABORT) != 0 )){
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 		return;
 	} else {
 		acb->fw_flag = FW_NORMAL;
 		if (atomic_read(&acb->ante_token_value) == atomic_read(&acb->rq_map_token)) {
-			atomic_set(&acb->rq_map_token,16);
+			atomic_set(&acb->rq_map_token, 16);
 		}
 		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
-		if(atomic_dec_and_test(&acb->rq_map_token))
+		if (atomic_dec_and_test(&acb->rq_map_token)) {
+			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 			return;
+		}
 		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 	}
@@ -2701,6 +2701,7 @@ static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_C __iomem *reg = acb->pmuC;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags & ACB_F_BUS_RESET) != 0) || ((acb->acb_flags & ACB_F_ABORT) != 0)) {
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 		return;
 	} else {
 		acb->fw_flag = FW_NORMAL;
@@ -2708,8 +2709,10 @@ static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb)
 			atomic_set(&acb->rq_map_token, 16);
 		}
 		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
-		if (atomic_dec_and_test(&acb->rq_map_token))
+		if (atomic_dec_and_test(&acb->rq_map_token)) {
+			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 			return;
+		}
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
 		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
@@ -2897,6 +2900,8 @@ static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)
 	uint32_t intmask_org;
 	uint8_t rtnval = 0x00;
 	int i = 0;
+	unsigned long flags;
+
 	if (atomic_read(&acb->ccboutstandingcount) != 0) {
 		/* disable all outbound interrupt */
 		intmask_org = arcmsr_disable_outbound_ints(acb);
@@ -2907,7 +2912,12 @@ static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)
 		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
 			ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
-				arcmsr_ccb_complete(ccb);
+				scsi_dma_unmap(ccb->pcmd);
+				ccb->startdone = ARCMSR_CCB_DONE;
+				ccb->ccb_flags = 0;
+				spin_lock_irqsave(&acb->ccblist_lock, flags);
+				list_add_tail(&ccb->list, &acb->ccb_free_list);
+				spin_unlock_irqrestore(&acb->ccblist_lock, flags);
 			}
 		}
 		atomic_set(&acb->ccboutstandingcount, 0);
@@ -2920,8 +2930,7 @@ static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)
 
 static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
 {
-	struct AdapterControlBlock *acb =
-		(struct AdapterControlBlock *)cmd->device->host->hostdata;
+	struct AdapterControlBlock *acb;
 	uint32_t intmask_org, outbound_doorbell;
 	int retry_count = 0;
 	int rtn = FAILED;
@@ -2971,31 +2980,16 @@ sleep_again:
 				atomic_set(&acb->rq_map_token, 16);
 				atomic_set(&acb->ante_token_value, 16);
 				acb->fw_flag = FW_NORMAL;
-				init_timer(&acb->eternal_timer);
-				acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6*HZ);
-				acb->eternal_timer.data = (unsigned long) acb;
-				acb->eternal_timer.function = &arcmsr_request_device_map;
-				add_timer(&acb->eternal_timer);
+				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 				acb->acb_flags &= ~ACB_F_BUS_RESET;
 				rtn = SUCCESS;
 				printk(KERN_ERR "arcmsr: scsi  bus reset eh returns with success\n");
 			} else {
 				acb->acb_flags &= ~ACB_F_BUS_RESET;
-				if (atomic_read(&acb->rq_map_token) == 0) {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value, 16);
-					acb->fw_flag = FW_NORMAL;
-					init_timer(&acb->eternal_timer);
-						acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6*HZ);
-					acb->eternal_timer.data = (unsigned long) acb;
-					acb->eternal_timer.function = &arcmsr_request_device_map;
-					add_timer(&acb->eternal_timer);
-				} else {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value, 16);
-					acb->fw_flag = FW_NORMAL;
-					mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
-				}
+				atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);
+				acb->fw_flag = FW_NORMAL;
+				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
 				rtn = SUCCESS;
 			}
 			break;
@@ -3007,21 +3001,10 @@ sleep_again:
 				rtn = FAILED;
 			} else {
 				acb->acb_flags &= ~ACB_F_BUS_RESET;
-				if (atomic_read(&acb->rq_map_token) == 0) {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value, 16);
-					acb->fw_flag = FW_NORMAL;
-					init_timer(&acb->eternal_timer);
-						acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6*HZ);
-					acb->eternal_timer.data = (unsigned long) acb;
-					acb->eternal_timer.function = &arcmsr_request_device_map;
-					add_timer(&acb->eternal_timer);
-				} else {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value, 16);
-					acb->fw_flag = FW_NORMAL;
-					mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
-				}
+				atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);
+				acb->fw_flag = FW_NORMAL;
+				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 				rtn = SUCCESS;
 			}
 			break;
@@ -3067,31 +3050,16 @@ sleep:
 				atomic_set(&acb->rq_map_token, 16);
 				atomic_set(&acb->ante_token_value, 16);
 				acb->fw_flag = FW_NORMAL;
-				init_timer(&acb->eternal_timer);
-				acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
-				acb->eternal_timer.data = (unsigned long) acb;
-				acb->eternal_timer.function = &arcmsr_request_device_map;
-				add_timer(&acb->eternal_timer);
+				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 				acb->acb_flags &= ~ACB_F_BUS_RESET;
 				rtn = SUCCESS;
 				printk(KERN_ERR "arcmsr: scsi bus reset eh returns with success\n");
 			} else {
 				acb->acb_flags &= ~ACB_F_BUS_RESET;
-				if (atomic_read(&acb->rq_map_token) == 0) {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value, 16);
-					acb->fw_flag = FW_NORMAL;
-					init_timer(&acb->eternal_timer);
-						acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6*HZ);
-					acb->eternal_timer.data = (unsigned long) acb;
-					acb->eternal_timer.function = &arcmsr_request_device_map;
-					add_timer(&acb->eternal_timer);
-				} else {
-					atomic_set(&acb->rq_map_token, 16);
-					atomic_set(&acb->ante_token_value, 16);
-					acb->fw_flag = FW_NORMAL;
-					mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
-				}
+				atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);
+				acb->fw_flag = FW_NORMAL;
+				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
 				rtn = SUCCESS;
 			}
 			break;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 5815cbe..9a7aaf5 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -646,6 +646,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
+	shost->host_eh_scheduled = 0;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	SAS_DPRINTK("Enter %s\n", __func__);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index b2a8170..9ead039 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2176,9 +2176,9 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 		/* adjust hba_queue_depth, reply_free_queue_depth,
 		 * and queue_size
 		 */
-		ioc->hba_queue_depth -= queue_diff;
-		ioc->reply_free_queue_depth -= queue_diff;
-		queue_size -= queue_diff;
+		ioc->hba_queue_depth -= (queue_diff / 2);
+		ioc->reply_free_queue_depth -= (queue_diff / 2);
+		queue_size = facts->MaxReplyDescriptorPostQueueDepth;
 	}
 	ioc->reply_post_queue_depth = queue_size;
 
@@ -3941,6 +3941,8 @@ mpt2sas_base_detach(struct MPT2SAS_ADAPTER *ioc)
 static void
 _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 {
+	mpt2sas_scsih_reset_handler(ioc, reset_phase);
+	mpt2sas_ctl_reset_handler(ioc, reset_phase);
 	switch (reset_phase) {
 	case MPT2_IOC_PRE_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
@@ -3971,8 +3973,6 @@ _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
 		break;
 	}
-	mpt2sas_scsih_reset_handler(ioc, reset_phase);
-	mpt2sas_ctl_reset_handler(ioc, reset_phase);
 }
 
 /**
@@ -4026,6 +4026,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 {
 	int r;
 	unsigned long flags;
+	u8 pe_complete = ioc->wait_for_port_enable_to_complete;
 
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
@@ -4068,6 +4069,14 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	if (r)
 		goto out;
 	_base_reset_handler(ioc, MPT2_IOC_AFTER_RESET);
+
+	/* If this hard reset is called while port enable is active, then
+	 * there is no reason to call make_ioc_operational
+	 */
+	if (pe_complete) {
+		r = -EFAULT;
+		goto out;
+	}
 	r = _base_make_ioc_operational(ioc, sleep_flag);
 	if (!r)
 		_base_reset_handler(ioc, MPT2_IOC_DONE_RESET);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index eda347c..5ded3db 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -819,7 +819,7 @@ _scsih_is_end_device(u32 device_info)
 }
 
 /**
- * mptscsih_get_scsi_lookup - returns scmd entry
+ * _scsih_scsi_lookup_get - returns scmd entry
  * @ioc: per adapter object
  * @smid: system request message index
  *
@@ -832,6 +832,28 @@ _scsih_scsi_lookup_get(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 }
 
 /**
+ * _scsih_scsi_lookup_get_clear - returns scmd entry
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns the smid stored scmd pointer.
+ * Then will derefrence the stored scmd pointer.
+ */
+static inline struct scsi_cmnd *
+_scsih_scsi_lookup_get_clear(struct MPT2SAS_ADAPTER *ioc, u16 smid)
+{
+	unsigned long flags;
+	struct scsi_cmnd *scmd;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	scmd = ioc->scsi_lookup[smid - 1].scmd;
+	ioc->scsi_lookup[smid - 1].scmd = NULL;
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+
+	return scmd;
+}
+
+/**
  * _scsih_scsi_lookup_find_by_scmd - scmd lookup
  * @ioc: per adapter object
  * @smid: system request message index
@@ -2981,9 +3003,6 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
 	u16 handle;
 
 	for (i = 0 ; i < event_data->NumEntries; i++) {
-		if (event_data->PHY[i].PhyStatus &
-		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT)
-			continue;
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
 		if (!handle)
 			continue;
@@ -3210,7 +3229,7 @@ _scsih_flush_running_cmds(struct MPT2SAS_ADAPTER *ioc)
 	u16 count = 0;
 
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		scmd = _scsih_scsi_lookup_get(ioc, smid);
+		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
 		if (!scmd)
 			continue;
 		count++;
@@ -3804,7 +3823,7 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	u32 response_code = 0;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
-	scmd = _scsih_scsi_lookup_get(ioc, smid);
+	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
 	if (scmd == NULL)
 		return 1;
 
@@ -5005,6 +5024,12 @@ _scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
 		     event_data);
 #endif
 
+	/* In MPI Revision K (0xC), the internal device reset complete was
+	 * implemented, so avoid setting tm_busy flag for older firmware.
+	 */
+	if ((ioc->facts.HeaderVersion >> 8) < 0xC)
+		return;
+
 	if (event_data->ReasonCode !=
 	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
 	   event_data->ReasonCode !=
@@ -5099,6 +5124,7 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
     struct fw_event_work *fw_event)
 {
 	struct scsi_cmnd *scmd;
+	struct scsi_device *sdev;
 	u16 smid, handle;
 	u32 lun;
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
@@ -5109,12 +5135,17 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
 #endif
 	u16 ioc_status;
+	unsigned long flags;
+	int r;
+
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "broadcast primative: "
 	    "phy number(%d), width(%d)\n", ioc->name, event_data->PhyNum,
 	    event_data->PortWidth));
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	ioc->broadcast_aen_busy = 0;
 	termination_count = 0;
 	query_count = 0;
 	mpi_reply = ioc->tm_cmds.reply;
@@ -5122,7 +5153,8 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 		scmd = _scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
-		sas_device_priv_data = scmd->device->hostdata;
+		sdev = scmd->device;
+		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
 			continue;
 		 /* skip hidden raid components */
@@ -5138,6 +5170,7 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 		lun = sas_device_priv_data->lun;
 		query_count++;
 
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 		mpt2sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
 		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30, NULL);
 		ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
@@ -5147,14 +5180,20 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 		    (mpi_reply->ResponseCode ==
 		     MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
 		     mpi_reply->ResponseCode ==
-		     MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC))
+		     MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC)) {
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 			continue;
-
-		mpt2sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET, 0, 30, NULL);
+		}
+		r = mpt2sas_scsih_issue_tm(ioc, handle, sdev->channel, sdev->id,
+		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
+		    scmd);
+		if (r == FAILED)
+			sdev_printk(KERN_WARNING, sdev, "task abort: FAILED "
+			    "scmd(%p)\n", scmd);
 		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
+		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	}
-	ioc->broadcast_aen_busy = 0;
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT
 	    "%s - exit, query_count = %d termination_count = %d\n",
@@ -6626,6 +6665,7 @@ _scsih_remove(struct pci_dev *pdev)
 		destroy_workqueue(wq);
 
 	/* release all the volumes */
+	_scsih_ir_shutdown(ioc);
 	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
 	    list) {
 		if (raid_device->starget) {
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 648d233..b76d400 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -9,6 +9,7 @@
 #define _SCSI_SCSI_H
 
 #include <linux/types.h>
+#include <linux/scatterlist.h>
 
 struct scsi_cmnd;
 


