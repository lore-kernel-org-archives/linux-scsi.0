From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/7] mptsas : Removed mptscsih_timer_expired.
Date: Wed, 5 Aug 2009 12:50:02 +0530
Message-ID: <20090805071940.GC14031@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:44880 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbZHEHlB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 03:41:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Removed mptscsih_timer_expired. This timer is no more use.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 73810fa..bf446d4 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -880,23 +880,9 @@ typedef enum {
 
 typedef struct _MPT_SCSI_HOST {
 	MPT_ADAPTER		 *ioc;
-	int			  port;
-	u32			  pad0;
-	MPT_LOCAL_REPLY		 *pLocal;		/* used for internal commands */
-	struct timer_list	  timer;
-		/* Pool of memory for holding SCpnts before doing
-		 * OS callbacks. freeQ is the free pool.
-		 */
-	u8			  negoNvram;		/* DV disabled, nego NVRAM */
-	u8			  pad1;
-	u8			  rsvd[2];
-	MPT_FRAME_HDR		 *cmdPtr;		/* Ptr to nonOS request */
-	struct scsi_cmnd	 *abortSCpnt;
-	MPT_LOCAL_REPLY		  localReply;		/* internal cmd reply struct */
 	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];
 	char 			  *info_kbuf;
 	long			  last_queue_full;
-	u16			  tm_iocstatus;
 	u16			  spi_pending;
 	struct list_head	  target_reset_list;
 } MPT_SCSI_HOST;
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index e61df13..ebf6ae0 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1288,25 +1288,6 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
index c03968b..54fc73c 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4821,25 +4821,6 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
 
 	hd->last_queue_full = 0;
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 8440f78..abdc727 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1729,9 +1729,6 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	 */
 	mf = MPT_INDEX_2_MFPTR(ioc, scpnt_idx);
 	ctx2abort = mf->u.frame.hwhdr.msgctxu.MsgContext;
-
-	hd->abortSCpnt = SCpnt;
-
 	retval = mptscsih_IssueTaskMgmt(hd,
 			 MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 			 vdevice->vtarget->channel,
@@ -2627,50 +2624,6 @@ mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
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
 
 /**
  *	mptscsih_get_completion_code -
@@ -3265,6 +3218,5 @@ EXPORT_SYMBOL(mptscsih_scandv_complete);
 EXPORT_SYMBOL(mptscsih_event_process);
 EXPORT_SYMBOL(mptscsih_ioc_reset);
 EXPORT_SYMBOL(mptscsih_change_queue_depth);
-EXPORT_SYMBOL(mptscsih_timer_expired);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index eb3f677..e0b33e0 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -129,7 +129,6 @@ extern int mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRA
 extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
-extern void mptscsih_timer_expired(unsigned long data);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern struct device_attribute *mptscsih_host_attrs[];
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index c5b808f..69f4257 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1472,28 +1472,7 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
-
-	hd->negoNvram = MPT_SCSICFG_USE_NVRAM;
 	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"saf_te %x\n",
 		ioc->name,
