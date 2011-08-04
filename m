From: <kashyap.desai@lsi.com>
Subject: [PATCH 02/05] mptfusion: Better handling of DEAD IOC PCI-E LInk
 down error condition
Date: Thu, 4 Aug 2011 16:42:15 +0530
Message-ID: <201108041050.p74Aowqc005784@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38028 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287Ab1HDKwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2011 06:52:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com, JBottomley@parallels.com

New feature: 
Find Non-Operation IOC and remove it from OS.
Detecting dead(non-functional) ioc will be done reading doorbell register 
value from fault reset thread, which has been called from work thread context 
after each specific interval. If doorbell value is 0xFFFFFFFF, 
it will be considered as IOC is non-operational and marked as dead ioc.

Once Dead IOC has been detected, it will be removed at pci layer using 
"pci_remove_bus_device" API.
 
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 7956a10..517621f 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -63,6 +63,8 @@
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
 #endif
+#include <linux/kthread.h>
+#include <scsi/scsi_host.h>
 
 #include "mptbase.h"
 #include "lsi/mpi_log_fc.h"
@@ -323,6 +325,32 @@ mpt_is_discovery_complete(MPT_ADAPTER *ioc)
 	return rc;
 }
 
+
+/**
+ *  mpt_remove_dead_ioc_func - kthread context to remove dead ioc
+ * @arg: input argument, used to derive ioc
+ *
+ * Return 0 if controller is removed from pci subsystem.
+ * Return -1 for other case.
+ */
+static int mpt_remove_dead_ioc_func(void *arg)
+{
+	MPT_ADAPTER *ioc = (MPT_ADAPTER *)arg;
+	struct pci_dev *pdev;
+
+	if ((ioc == NULL))
+		return -1;
+
+	pdev = ioc->pcidev;
+	if ((pdev == NULL))
+		return -1;
+
+	pci_remove_bus_device(pdev);
+	return 0;
+}
+
+
+
 /**
  *	mpt_fault_reset_work - work performed on workq after ioc fault
  *	@work: input argument, used to derive ioc
@@ -336,12 +364,45 @@ mpt_fault_reset_work(struct work_struct *work)
 	u32		 ioc_raw_state;
 	int		 rc;
 	unsigned long	 flags;
+	MPT_SCSI_HOST	*hd;
+	struct task_struct *p;
 
 	if (ioc->ioc_reset_in_progress || !ioc->active)
 		goto out;
 
+
 	ioc_raw_state = mpt_GetIocState(ioc, 0);
-	if ((ioc_raw_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_FAULT) {
+	if ((ioc_raw_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_MASK) {
+		printk(MYIOC_s_INFO_FMT "%s: IOC is non-operational !!!!\n",
+		    ioc->name, __func__);
+
+		/*
+		 * Call mptscsih_flush_pending_cmds callback so that we
+		 * flush all pending commands back to OS.
+		 * This call is required to aovid deadlock at block layer.
+		 * Dead IOC will fail to do diag reset,and this call is safe
+		 * since dead ioc will never return any command back from HW.
+		 */
+		hd = shost_priv(ioc->sh);
+		ioc->schedule_dead_ioc_flush_running_cmds(hd);
+
+		/*Remove the Dead Host */
+		p = kthread_run(mpt_remove_dead_ioc_func, ioc,
+				"mpt_dead_ioc_%d", ioc->id);
+		if (IS_ERR(p))	{
+			printk(MYIOC_s_ERR_FMT
+				"%s: Running mpt_dead_ioc thread failed !\n",
+				ioc->name, __func__);
+		} else {
+			printk(MYIOC_s_WARN_FMT
+				"%s: Running mpt_dead_ioc thread success !\n",
+				ioc->name, __func__);
+		}
+		return; /* don't rearm timer */
+	}
+
+	if ((ioc_raw_state & MPI_IOC_STATE_MASK)
+			== MPI_IOC_STATE_FAULT) {
 		printk(MYIOC_s_WARN_FMT "IOC is in FAULT state (%04xh)!!!\n",
 		       ioc->name, ioc_raw_state & MPI_DOORBELL_DATA_MASK);
 		printk(MYIOC_s_WARN_FMT "Issuing HardReset from %s!!\n",
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index fe90233..69ddabd 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -554,10 +554,47 @@ struct mptfc_rport_info
 	u8		flags;
 };
 
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+
+/*
+ * MPT_SCSI_HOST defines - Used by the IOCTL and the SCSI drivers
+ * Private to the driver.
+ */
+
+#define MPT_HOST_BUS_UNKNOWN		(0xFF)
+#define MPT_HOST_TOO_MANY_TM		(0x05)
+#define MPT_HOST_NVRAM_INVALID		(0xFFFFFFFF)
+#define MPT_HOST_NO_CHAIN		(0xFFFFFFFF)
+#define MPT_NVRAM_MASK_TIMEOUT		(0x000000FF)
+#define MPT_NVRAM_SYNC_MASK		(0x0000FF00)
+#define MPT_NVRAM_SYNC_SHIFT		(8)
+#define MPT_NVRAM_DISCONNECT_ENABLE	(0x00010000)
+#define MPT_NVRAM_ID_SCAN_ENABLE	(0x00020000)
+#define MPT_NVRAM_LUN_SCAN_ENABLE	(0x00040000)
+#define MPT_NVRAM_TAG_QUEUE_ENABLE	(0x00080000)
+#define MPT_NVRAM_WIDE_DISABLE		(0x00100000)
+#define MPT_NVRAM_BOOT_CHOICE		(0x00200000)
+
+typedef enum {
+	FC,
+	SPI,
+	SAS
+} BUS_TYPE;
+
+typedef struct _MPT_SCSI_HOST {
+	struct _MPT_ADAPTER		 *ioc;
+	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];
+	char			  *info_kbuf;
+	long			  last_queue_full;
+	u16			  spi_pending;
+	struct list_head	  target_reset_list;
+} MPT_SCSI_HOST;
+
 typedef void (*MPT_ADD_SGE)(void *pAddr, u32 flagslength, dma_addr_t dma_addr);
 typedef void (*MPT_ADD_CHAIN)(void *pAddr, u8 next, u16 length,
 		dma_addr_t dma_addr);
 typedef void (*MPT_SCHEDULE_TARGET_RESET)(void *ioc);
+typedef void (*MPT_FLUSH_RUNNING_CMDS)(MPT_SCSI_HOST *hd);
 
 /*
  *  Adapter Structure - pci_dev specific. Maximum: MPT_MAX_ADAPTERS
@@ -717,6 +754,7 @@ typedef struct _MPT_ADAPTER
 	u8			 taskmgmt_quiesce_io;
 	u8			 ioc_reset_in_progress;
 	MPT_SCHEDULE_TARGET_RESET schedule_target_reset;
+	MPT_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
 	struct work_struct	 sas_persist_task;
 
 	struct work_struct	 fc_setup_reset_work;
@@ -830,19 +868,6 @@ typedef struct _MPT_LOCAL_REPLY {
 	u32	pad;
 } MPT_LOCAL_REPLY;
 
-#define MPT_HOST_BUS_UNKNOWN		(0xFF)
-#define MPT_HOST_TOO_MANY_TM		(0x05)
-#define MPT_HOST_NVRAM_INVALID		(0xFFFFFFFF)
-#define MPT_HOST_NO_CHAIN		(0xFFFFFFFF)
-#define MPT_NVRAM_MASK_TIMEOUT		(0x000000FF)
-#define MPT_NVRAM_SYNC_MASK		(0x0000FF00)
-#define MPT_NVRAM_SYNC_SHIFT		(8)
-#define MPT_NVRAM_DISCONNECT_ENABLE	(0x00010000)
-#define MPT_NVRAM_ID_SCAN_ENABLE	(0x00020000)
-#define MPT_NVRAM_LUN_SCAN_ENABLE	(0x00040000)
-#define MPT_NVRAM_TAG_QUEUE_ENABLE	(0x00080000)
-#define MPT_NVRAM_WIDE_DISABLE		(0x00100000)
-#define MPT_NVRAM_BOOT_CHOICE		(0x00200000)
 
 /* The TM_STATE variable is used to provide strict single threading of TM
  * requests as well as communicate TM error conditions.
@@ -851,21 +876,6 @@ typedef struct _MPT_LOCAL_REPLY {
 #define	TM_STATE_IN_PROGRESS   (1)
 #define	TM_STATE_ERROR	       (2)
 
-typedef enum {
-	FC,
-	SPI,
-	SAS
-} BUS_TYPE;
-
-typedef struct _MPT_SCSI_HOST {
-	MPT_ADAPTER		 *ioc;
-	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];
-	char 			  *info_kbuf;
-	long			  last_queue_full;
-	u16			  spi_pending;
-	struct list_head	  target_reset_list;
-} MPT_SCSI_HOST;
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	More Dynamic Multi-Pathing stuff...
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index c03b8be..83f5f79 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5147,6 +5147,8 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->TaskCtx = mptsasTaskCtx;
 	ioc->InternalCtx = mptsasInternalCtx;
 	ioc->schedule_target_reset = &mptsas_schedule_target_reset;
+	ioc->schedule_dead_ioc_flush_running_cmds =
+				&mptscsih_flush_running_cmds;
 	/*  Added sanity check on readiness of the MPT adapter.
 	 */
 	if (ioc->last_state != MPI_IOC_STATE_OPERATIONAL) {
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index a1d4ee6..c9a7109 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1024,7 +1024,7 @@ out:
  *
  *	Must be called while new I/Os are being queued.
  */
-static void
+void
 mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 {
 	MPT_ADAPTER *ioc = hd->ioc;
@@ -1055,6 +1055,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 		sc->scsi_done(sc);
 	}
 }
+EXPORT_SYMBOL(mptscsih_flush_running_cmds);
 
 /*
  *	mptscsih_search_running_cmds - Delete any commands associated
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 45a5ff3..43e75ff 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -135,3 +135,4 @@ extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern struct device_attribute *mptscsih_host_attrs[];
 extern struct scsi_cmnd	*mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i);
 extern void mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code);
+extern void mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd);
