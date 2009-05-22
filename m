From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 23/24] mpt fusion: [2.6.30-rc6]  Module parameters to change queue depth for FC,SPI,SAS
Date: Fri, 22 May 2009 16:41:55 +0530
Message-ID: <20090522111147.GQ16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:51159 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292AbZEVLcz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 07:32:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


1. Unused mptscsih_timer_expired() function is removed.
2. Module parameter mpt_sdev_queue_depth to support different queue depth for different Buses (FC/SPI/SAS).
3. changed driver versiont to 3.04.11.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 1c8514d..44ef2a0 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.10"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.09"
+#define MPT_LINUX_VERSION_COMMON	"3.04.11"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.11"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -157,8 +157,9 @@
 /*
  *	Try to keep these at 2^N-1
  */
-#define MPT_FC_CAN_QUEUE	127
+#define MPT_FC_CAN_QUEUE	1024
 #define MPT_SCSI_CAN_QUEUE	127
+#define MPT_SAS_CAN_QUEUE	127
 
 /*
  * Set the MAX_SGE value based on user input.
@@ -757,6 +758,7 @@ typedef struct _MPT_ADAPTER
 
 	struct scsi_cmnd	**ScsiLookup;
 	spinlock_t		  scsi_lookup_lock;
+	int			  sdev_queue_depth;	/* sdev queue depth */
 	u64			dma_mask;
 	u32			  broadcast_aen_busy;
 	char			 reset_work_q_name[MPT_KOBJ_NAME_LEN];
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index e61df13..1a3975c 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -84,6 +84,14 @@ MODULE_PARM_DESC(mptfc_dev_loss_tmo, " Initial time the driver programs the "
 				     " return following a device loss event."
 				     "  Default=60.");
 
+static int mpt_sdev_queue_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
+static int mptfc_set_sdev_queue_depth(const char *val, struct kernel_param *kp);
+module_param_call(mpt_sdev_queue_depth, mptfc_set_sdev_queue_depth,
+    param_get_int,  &mpt_sdev_queue_depth, 0600);
+MODULE_PARM_DESC(mpt_sdev_queue_depth,
+    " Max Device Queue Depth (default="
+    __MODULE_STRING(MPT_SCSI_CMD_PER_DEV_HIGH) ")");
+
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPTFC_MAX_LUN (16895)
 static int max_lun = MPTFC_MAX_LUN;
@@ -183,6 +191,34 @@ static struct fc_function_template mptfc_transport_functions = {
 	.show_host_symbolic_name = 1,
 };
 
+/**
+ *	mptfc_set_sdev_queue_depth - global setting of the mpt_sdev_queue_depth
+ *	found via /sys/module/mptfc/parameters/mpt_sdev_queue_depth
+ *	@val:
+ *	@kp:
+ *
+ *	Returns
+ **/
+static int
+mptfc_set_sdev_queue_depth(const char *val, struct kernel_param *kp)
+{
+	int ret = param_set_int(val, kp);
+	MPT_ADAPTER *ioc;
+	struct scsi_device	*sdev;
+
+	if (ret)
+		return ret;
+
+	list_for_each_entry(ioc, &ioc_list, list) {
+		if (ioc->bus_type != FC)
+			continue;
+		shost_for_each_device(sdev, ioc->sh)
+			mptscsih_change_queue_depth(sdev, mpt_sdev_queue_depth);
+		ioc->sdev_queue_depth = mpt_sdev_queue_depth;
+	}
+	return 0;
+}
+
 static int
 mptfc_block_error_handler(struct scsi_cmnd *SCpnt,
 			  int (*func)(struct scsi_cmnd *SCpnt),
@@ -1238,6 +1274,8 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sh->max_id = ioc->pfacts->MaxDevices;
 	sh->max_lun = max_lun;
 
+	ioc->sdev_queue_depth = mpt_sdev_queue_depth;
+
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;
@@ -1288,25 +1326,6 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
 		 ioc->name, ioc->ScsiLookup));
 
-	/* Clear the TM flags
-	 */
-	hd->abortSCpnt = NULL;
-
-	/* Clear the pointer used to store
-	 * single-threaded commands, i.e., those
-	 * issued during a bus scan, dv and
-	 * configuration pages.
-	 */
-	hd->cmdPtr = NULL;
-
-	/* Initialize this SCSI Hosts' timers
-	 * To use, set the timer expires field
-	 * and add_timer
-	 */
-	init_timer(&hd->timer);
-	hd->timer.data = (unsigned long) hd;
-	hd->timer.function = mptscsih_timer_expired;
-
 	hd->last_queue_full = 0;
 
 	sh->transportt = mptfc_transport_template;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index ffb2bf3..5562894 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -83,6 +83,15 @@ MODULE_PARM_DESC(mpt_pt_clear,
 		" Clear persistency table: enable=1  "
 		"(default=MPTSCSIH_PT_CLEAR=0)");
 
+static int mpt_sdev_queue_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
+static int mptsas_set_sdev_queue_depth(const char *val,
+    struct kernel_param *kp);
+module_param_call(mpt_sdev_queue_depth, mptsas_set_sdev_queue_depth,
+    param_get_int, &mpt_sdev_queue_depth, 0600);
+MODULE_PARM_DESC(mpt_sdev_queue_depth,
+    " Max Device Queue Depth (default="
+    __MODULE_STRING(MPT_SCSI_CMD_PER_DEV_HIGH) ")");
+
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPTSAS_MAX_LUN (16895)
 static int max_lun = MPTSAS_MAX_LUN;
@@ -125,6 +134,34 @@ static void mptsas_broadcast_primative_work(struct fw_event_work *fw_event);
 static void mptsas_handle_queue_full_event(struct fw_event_work *fw_event);
 static void mptsas_volume_delete(MPT_ADAPTER *ioc, u8 id);
 
+/**
+ *	mptsas_set_sdev_queue_depth - global setting of the mpt_sdev_queue_depth
+ *	found via /sys/module/mptsas/parameters/mpt_sdev_queue_depth
+ *	@val:
+ *	@kp:
+ *
+ *	Returns
+ **/
+static int
+mptsas_set_sdev_queue_depth(const char *val, struct kernel_param *kp)
+{
+	int ret = param_set_int(val, kp);
+	MPT_ADAPTER *ioc;
+	struct scsi_device	*sdev;
+
+	if (ret)
+		return ret;
+
+	list_for_each_entry(ioc, &ioc_list, list) {
+		if (ioc->bus_type != SAS)
+			continue;
+		shost_for_each_device(sdev, ioc->sh)
+			mptscsih_change_queue_depth(sdev, mpt_sdev_queue_depth);
+		ioc->sdev_queue_depth = mpt_sdev_queue_depth;
+	}
+	return 0;
+}
+
 static void mptsas_print_phy_data(MPT_ADAPTER *ioc,
 					MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
 {
@@ -1892,7 +1929,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.eh_bus_reset_handler		= mptscsih_bus_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
-	.can_queue			= MPT_FC_CAN_QUEUE,
+	.can_queue			= MPT_SAS_CAN_QUEUE,
 	.this_id			= -1,
 	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
 	.max_sectors			= 8192,
@@ -4751,7 +4788,7 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* set 16 byte cdb's */
 	sh->max_cmd_len = 16;
-
+	sh->can_queue = min_t(int, ioc->req_depth - 10, sh->can_queue);
 	sh->max_id = ioc->pfacts[0].PortSCSIID;
 	sh->max_lun = max_lun;
 
@@ -4812,27 +4849,9 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
 		 ioc->name, ioc->ScsiLookup));
 
-	/* Clear the TM flags
-	 */
-	hd->abortSCpnt = NULL;
-
-	/* Clear the pointer used to store
-	 * single-threaded commands, i.e., those
-	 * issued during a bus scan, dv and
-	 * configuration pages.
-	 */
-	hd->cmdPtr = NULL;
-
-	/* Initialize this SCSI Hosts' timers
-	 * To use, set the timer expires field
-	 * and add_timer
-	 */
-	init_timer(&hd->timer);
-	hd->timer.data = (unsigned long) hd;
-	hd->timer.function = mptscsih_timer_expired;
-
 	ioc->sas_data.ptClear = mpt_pt_clear;
 
+	ioc->sdev_queue_depth = mpt_sdev_queue_depth;
 	hd->last_queue_full = 0;
 	INIT_LIST_HEAD(&hd->target_reset_list);
 	INIT_LIST_HEAD(&ioc->sas_device_info_list);
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 841d396..69e798c 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2286,15 +2286,16 @@ mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 	vtarget = starget->hostdata;
 
 	if (ioc->bus_type == SPI) {
-		if (!(vtarget->tflags & MPT_TARGET_FLAGS_Q_YES))
-			max_depth = 1;
-		else if (sdev->type == TYPE_DISK &&
-			 vtarget->minSyncFactor <= MPT_ULTRA160)
+		if (sdev->type == TYPE_DISK &&
+		    vtarget->minSyncFactor <= MPT_ULTRA160)
 			max_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
 		else
 			max_depth = MPT_SCSI_CMD_PER_DEV_LOW;
 	} else
-		max_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
+		max_depth = ioc->sh->can_queue;
+
+	if (!sdev->tagged_supported)
+		max_depth = 1;
 
 	if (qdepth > max_depth)
 		qdepth = max_depth;
@@ -2304,6 +2305,15 @@ mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 		tagged = MSG_SIMPLE_TAG;
 
 	scsi_adjust_queue_depth(sdev, tagged, qdepth);
+
+	if (sdev->inquiry_len > 7)
+		sdev_printk(KERN_INFO, sdev, MYIOC_s_FMT "qdepth=%d, "
+		    "tagged=%d, simple=%d, ordered=%d, scsi_level=%d, "
+		    "cmd_que=%d\n", ioc->name, sdev->queue_depth,
+		    sdev->tagged_supported, sdev->simple_tags,
+		    sdev->ordered_tags, sdev->scsi_level,
+		    (sdev->inquiry[7] & 2) >> 1);
+
 	return sdev->queue_depth;
 }
 
@@ -2348,7 +2358,7 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		    ioc->name, vtarget->negoFlags, vtarget->maxOffset,
 		    vtarget->minSyncFactor));
 
-	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
+	mptscsih_change_queue_depth(sdev, ioc->sdev_queue_depth);
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"tagged %d, simple %d, ordered %d\n",
 		ioc->name,sdev->tagged_supported, sdev->simple_tags,
@@ -2635,51 +2645,6 @@ mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
 	return 1;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*	mptscsih_timer_expired - Call back for timer process.
- *	Used only for dv functionality.
- *	@data: Pointer to MPT_SCSI_HOST recast as an unsigned long
- *
- */
-void
-mptscsih_timer_expired(unsigned long data)
-{
-	MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *) data;
-	MPT_ADAPTER 	*ioc = hd->ioc;
-
-	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Timer Expired! Cmd %p\n", ioc->name, hd->cmdPtr));
-
-	if (hd->cmdPtr) {
-		MPIHeader_t *cmd = (MPIHeader_t *)hd->cmdPtr;
-
-		if (cmd->Function == MPI_FUNCTION_SCSI_IO_REQUEST) {
-			/* Desire to issue a task management request here.
-			 * TM requests MUST be single threaded.
-			 * If old eh code and no TM current, issue request.
-			 * If new eh code, do nothing. Wait for OS cmd timeout
-			 *	for bus reset.
-			 */
-		} else {
-			/* Perform a FW reload */
-			if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0) {
-				printk(MYIOC_s_WARN_FMT "Firmware Reload FAILED!\n", ioc->name);
-			}
-		}
-	} else {
-		/* This should NEVER happen */
-		printk(MYIOC_s_WARN_FMT "Null cmdPtr!!!!\n", ioc->name);
-	}
-
-	/* No more processing.
-	 * TM call will generate an interrupt for SCSI TM Management.
-	 * The FW will reply to all outstanding commands, callback will finish cleanup.
-	 * Hard reset clean-up will free all resources.
-	 */
-	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Timer Expired Complete!\n", ioc->name));
-
-	return;
-}
-
 /**
  *	mptscsih_get_completion_code -
  *	@ioc: Pointer to MPT_ADAPTER structure
@@ -3273,6 +3238,5 @@ EXPORT_SYMBOL(mptscsih_scandv_complete);
 EXPORT_SYMBOL(mptscsih_event_process);
 EXPORT_SYMBOL(mptscsih_ioc_reset);
 EXPORT_SYMBOL(mptscsih_change_queue_depth);
-EXPORT_SYMBOL(mptscsih_timer_expired);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 77f021e..17d6ea6 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -128,7 +128,6 @@ extern int mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRA
 extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
-extern void mptscsih_timer_expired(unsigned long data);
 extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index c9fa919..d6f658d 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1472,26 +1472,8 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
 		 ioc->name, ioc->ScsiLookup));
 
-	/* Clear the TM flags
-	 */
-	hd->abortSCpnt = NULL;
-
-	/* Clear the pointer used to store
-	 * single-threaded commands, i.e., those
-	 * issued during a bus scan, dv and
-	 * configuration pages.
-	 */
-	hd->cmdPtr = NULL;
-
-	/* Initialize this SCSI Hosts' timers
-	 * To use, set the timer expires field
-	 * and add_timer
-	 */
-	init_timer(&hd->timer);
-	hd->timer.data = (unsigned long) hd;
-	hd->timer.function = mptscsih_timer_expired;
-
 	ioc->spi_data.Saf_Te = mpt_saf_te;
+	ioc->sdev_queue_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
 
 	hd->negoNvram = MPT_SCSICFG_USE_NVRAM;
 	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
