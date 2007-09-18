From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 4/9] mpt fusion: error recovery improvements, and synchronizing internal commands
Date: Mon, 17 Sep 2007 19:58:01 -0600
Message-ID: <20070918015801.GA22729@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61886 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbXIRCGr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2007 22:06:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

1) mpt_fault_reset_work - new workthread to quickly handle a card that goes into FAULT state.  Previously handled by eh threads, requiring commands to timeout (SD_TIMEOUT) to recover a card.
2) mpt_SoftResetHandler - less expensive method to reset card, other known as MESSAGE_UNIT_RESET-MUR.  The MUR doesn't perform a start_of_day recovery as does mpt_HardResetHandler, hence its quicker recovery time.  Also with MUR, the firmware is not reloaded, and only single pci function will be reset, whereas mpt_HardResetHandler will reset both functions.  An example of dual function card is the U320 1030 chip.
3) rewrite of all internal generated functions that issue commands to firmware, porting them to be single threaded using the generic MPT_MGMT struct. Killing all the watchdog timer functions that were previously handling timeout of internal commands, thus addressing race conditions reported by several customers.
4) cleanup MPT_SCSI_HOST struct, deleting unused struct members
5) cleanup ioc_reset callback handlers, introducing wrappers for synronizing error recovery (mpt_set_taskmgmt_in_progress_flag, mpt_clear_taskmgmt_in_progress_flag), as the fusion firmware only handles one task management request at a time.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

--- b/drivers/message/fusion/mptbase.c	2007-09-17 15:39:28.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2007-09-17 15:40:47.000000000 -0600
@@ -135,8 +135,7 @@ static u8 last_drv_idx;
 /*
  *  Forward protos...
  */
-static irqreturn_t mpt_interrupt(int irq, void *bus_id);
-static int	mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);
+static int	mptbase_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);
 static int	mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes,
 			u32 *req, int replyBytes, u16 *u16reply, int maxwait,
 			int sleepFlag);
@@ -167,9 +166,8 @@ static int	mpt_GetScsiPortSettings(MPT_A
 static int	mpt_readScsiDevicePageHeaders(MPT_ADAPTER *ioc, int portnum);
 static void 	mpt_read_ioc_pg_1(MPT_ADAPTER *ioc);
 static void 	mpt_read_ioc_pg_4(MPT_ADAPTER *ioc);
-static void	mpt_timer_expired(unsigned long data);
 static void	mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc);
-static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch);
+static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch, int sleepFlag);
 static int	SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp);
 static int	mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int sleepFlag);
 static int	mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init);
@@ -184,7 +182,6 @@ static int	procmpt_iocinfo_read(char *bu
 #endif
 static void	mpt_get_fw_exp_ver(char *buf, MPT_ADAPTER *ioc);
 
-//int		mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
 static int	ProcessEventNotification(MPT_ADAPTER *ioc, EventNotificationReply_t *evReply, int *evHandlers);
 static void	mpt_iocstatus_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf);
 static void	mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info);
@@ -223,7 +220,16 @@ pci_enable_io_access(struct pci_dev *pde
 	pci_write_config_word(pdev, PCI_COMMAND, command_reg);
 }
 
-static int mpt_set_debug_level(const char *val, struct kernel_param *kp)
+/**
+ *	mpt_set_debug_level - global setting of the mpt_debug_level
+ *	found via /sys/module/mptbase/parameters/mpt_debug_level
+ *	@val:
+ *	@kp:
+ *
+ *	Returns
+ **/
+static int
+mpt_set_debug_level(const char *val, struct kernel_param *kp)
 {
 	int ret = param_set_int(val, kp);
 	MPT_ADAPTER *ioc;
@@ -253,6 +259,54 @@ mpt_get_cb_idx(MPT_DRIVER_CLASS dclass)
 	return 0;
 }
 
+/**
+ *	mpt_fault_reset_work - work performed on workq after ioc fault
+ *	@work: input argument, used to derive ioc
+ *
+**/
+static void
+mpt_fault_reset_work(struct work_struct *work)
+{
+	MPT_ADAPTER	*ioc =
+	    container_of(work, MPT_ADAPTER, fault_reset_work.work);
+	u32		 ioc_raw_state;
+	int		 rc;
+	unsigned long	 flags;
+
+	if (ioc->ioc_reset_in_progress || !ioc->active)
+		goto out;
+
+	ioc_raw_state = mpt_GetIocState(ioc, 0);
+	if ((ioc_raw_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_FAULT) {
+		printk(MYIOC_s_WARN_FMT "IOC is in FAULT state (%04xh)!!!\n",
+		    ioc->name, ioc_raw_state & MPI_DOORBELL_DATA_MASK);
+		printk(MYIOC_s_WARN_FMT "Issuing HardReset from %s!!\n",
+		    ioc->name, __FUNCTION__);
+		rc = mpt_HardResetHandler(ioc, CAN_SLEEP);
+		printk(MYIOC_s_WARN_FMT "%s: HardReset: %s\n", ioc->name,
+		    __FUNCTION__, (rc == 0) ? "success" : "failed");
+		ioc_raw_state = mpt_GetIocState(ioc, 0);
+		if ((ioc_raw_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_FAULT)
+			printk(MYIOC_s_WARN_FMT "IOC is in FAULT state after "
+			    "reset (%04xh)\n", ioc->name, ioc_raw_state &
+			    MPI_DOORBELL_DATA_MASK);
+	}
+
+ out:
+	/*
+	 * Take turns polling alternate controller
+	 */
+	if (ioc->alt_ioc)
+		ioc = ioc->alt_ioc;
+
+	/* rearm the timer */
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->reset_work_q)
+		queue_delayed_work(ioc->reset_work_q, &ioc->fault_reset_work,
+			msecs_to_jiffies(MPT_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+}
+
 /*
  *  Process turbo (context) reply...
  */
@@ -427,11 +481,10 @@ mpt_interrupt(int irq, void *bus_id)
 	return IRQ_HANDLED;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_base_reply - MPT base driver's callback routine
+ *	mptbase_reply - MPT base driver's callback routine
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@mf: Pointer to original MPT request frame
+ *	@req: Pointer to original MPT request frame
  *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
  *
  *	MPT base driver's callback routine; all base driver
@@ -442,122 +495,49 @@ mpt_interrupt(int irq, void *bus_id)
  *	should be freed, or 0 if it shouldn't.
  */
 static int
-mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *reply)
+mptbase_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 {
+	EventNotificationReply_t *pEventReply;
+	u8 event;
+	int evHandlers;
 	int freereq = 1;
-	u8 func;
 
-	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_base_reply() called\n", ioc->name));
-#ifdef CONFIG_FUSION_LOGGING
-	if ((ioc->debug_level & MPT_DEBUG_MSG_FRAME) &&
-			!(reply->u.hdr.MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY)) {
-		dmfprintk(ioc, printk(MYIOC_s_INFO_FMT ": Original request frame (@%p) header\n",
-		    ioc->name, mf));
-		DBG_DUMP_REQUEST_FRAME_HDR(ioc, (u32 *)mf);
-	}
-#endif
-
-	func = reply->u.hdr.Function;
-	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_base_reply, Function=%02Xh\n",
-			ioc->name, func));
-
-	if (func == MPI_FUNCTION_EVENT_NOTIFICATION) {
-		EventNotificationReply_t *pEvReply = (EventNotificationReply_t *) reply;
-		int evHandlers = 0;
-		int results;
-
-		results = ProcessEventNotification(ioc, pEvReply, &evHandlers);
-		if (results != evHandlers) {
-			/* CHECKME! Any special handling needed here? */
-			devtverboseprintk(ioc, printk(MYIOC_s_WARN_FMT "Called %d event handlers, sum results = %d\n",
-					ioc->name, evHandlers, results));
-		}
-
-		/*
-		 *	Hmmm...  It seems that EventNotificationReply is an exception
-		 *	to the rule of one reply per request.
-		 */
-		if (pEvReply->MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY) {
+	switch (reply->u.hdr.Function) {
+	case MPI_FUNCTION_EVENT_NOTIFICATION:
+		pEventReply = (EventNotificationReply_t *)reply;
+		evHandlers = 0;
+		ProcessEventNotification(ioc, pEventReply, &evHandlers);
+		event = le32_to_cpu(pEventReply->Event) & 0xFF;
+		if (pEventReply->MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY)
 			freereq = 0;
-		} else {
-			devtverboseprintk(ioc, printk(MYIOC_s_WARN_FMT "EVENT_NOTIFICATION reply %p returns Request frame\n",
-				ioc->name, pEvReply));
-		}
-
-#ifdef CONFIG_PROC_FS
-//		LogEvent(ioc, pEvReply);
-#endif
-
-	} else if (func == MPI_FUNCTION_EVENT_ACK) {
-		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_base_reply, EventAck reply received\n",
-				ioc->name));
-	} else if (func == MPI_FUNCTION_CONFIG) {
-		CONFIGPARMS *pCfg;
-		unsigned long flags;
-
-		dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "config_complete (mf=%p,mr=%p)\n",
-				ioc->name, mf, reply));
-
-		pCfg = * ((CONFIGPARMS **)((u8 *) mf + ioc->req_sz - sizeof(void *)));
-
-		if (pCfg) {
-			/* disable timer and remove from linked list */
-			del_timer(&pCfg->timer);
-
-			spin_lock_irqsave(&ioc->FreeQlock, flags);
-			list_del(&pCfg->linkage);
-			spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-
-			/*
-			 *	If IOC Status is SUCCESS, save the header
-			 *	and set the status code to GOOD.
-			 */
-			pCfg->status = MPT_CONFIG_ERROR;
-			if (reply) {
-				ConfigReply_t	*pReply = (ConfigReply_t *)reply;
-				u16		 status;
-
-				status = le16_to_cpu(pReply->IOCStatus) & MPI_IOCSTATUS_MASK;
-				dcprintk(ioc, printk(MYIOC_s_NOTE_FMT "  IOCStatus=%04xh, IOCLogInfo=%08xh\n",
-				     ioc->name, status, le32_to_cpu(pReply->IOCLogInfo)));
-
-				pCfg->status = status;
-				if (status == MPI_IOCSTATUS_SUCCESS) {
-					if ((pReply->Header.PageType &
-					    MPI_CONFIG_PAGETYPE_MASK) ==
-					    MPI_CONFIG_PAGETYPE_EXTENDED) {
-						pCfg->cfghdr.ehdr->ExtPageLength =
-						    le16_to_cpu(pReply->ExtPageLength);
-						pCfg->cfghdr.ehdr->ExtPageType =
-						    pReply->ExtPageType;
-					}
-					pCfg->cfghdr.hdr->PageVersion = pReply->Header.PageVersion;
-
-					/* If this is a regular header, save PageLength. */
-					/* LMP Do this better so not using a reserved field! */
-					pCfg->cfghdr.hdr->PageLength = pReply->Header.PageLength;
-					pCfg->cfghdr.hdr->PageNumber = pReply->Header.PageNumber;
-					pCfg->cfghdr.hdr->PageType = pReply->Header.PageType;
-				}
-			}
-
-			/*
-			 *	Wake up the original calling thread
-			 */
-			pCfg->wait_done = 1;
-			wake_up(&mpt_waitq);
-		}
-	} else if (func == MPI_FUNCTION_SAS_IO_UNIT_CONTROL) {
-		/* we should be always getting a reply frame */
-		memcpy(ioc->persist_reply_frame, reply,
-		    min(MPT_DEFAULT_FRAME_SIZE,
-		    4*reply->u.reply.MsgLength));
-		del_timer(&ioc->persist_timer);
-		ioc->persist_wait_done = 1;
-		wake_up(&mpt_waitq);
-	} else {
-		printk(MYIOC_s_ERR_FMT "Unexpected msg function (=%02Xh) reply received!\n",
-				ioc->name, func);
+		if (event != MPI_EVENT_EVENT_CHANGE)
+			break;
+	case MPI_FUNCTION_CONFIG:
+	case MPI_FUNCTION_SAS_IO_UNIT_CONTROL:
+		ioc->mptbase_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
+		if (reply) {
+			ioc->mptbase_cmds.status |= MPT_MGMT_STATUS_RF_VALID;
+			memcpy(ioc->mptbase_cmds.reply, reply,
+			    min(MPT_DEFAULT_FRAME_SIZE,
+				4 * reply->u.reply.MsgLength));
+		}
+		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->mptbase_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
+			complete(&ioc->mptbase_cmds.done);
+		} else
+			freereq = 0;
+		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_FREE_MF)
+			freereq = 1;
+		break;
+	case MPI_FUNCTION_EVENT_ACK:
+		devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "EventAck reply received\n", ioc->name));
+		break;
+	default:
+		printk(MYIOC_s_ERR_FMT
+		    "Unexpected msg function (=%02Xh) reply received!\n",
+		    ioc->name, reply->u.hdr.Function);
+		break;
 	}
 
 	/*
@@ -802,7 +782,6 @@ mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER
 		mf->u.frame.linkage.arg1 = 0;
 		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = cb_idx;	/* byte */
 		req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
-								/* u16! */
 		req_idx = req_offset / ioc->req_sz;
 		mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(req_idx);
 		mf->u.frame.hwhdr.msgctxu.fld.rsvd = 0;
@@ -853,14 +832,14 @@ mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER
 	/* ensure values are reset properly! */
 	mf->u.frame.hwhdr.msgctxu.fld.cb_idx = cb_idx;		/* byte */
 	req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
-								/* u16! */
 	req_idx = req_offset / ioc->req_sz;
 	mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(req_idx);
 	mf->u.frame.hwhdr.msgctxu.fld.rsvd = 0;
 
 	DBG_DUMP_PUT_MSG_FRAME(ioc, (u32 *)mf);
 
-	mf_dma_addr = (ioc->req_frames_low_dma + req_offset) | ioc->RequestNB[req_idx];
+	mf_dma_addr = (ioc->req_frames_low_dma + req_offset) |
+	    ioc->RequestNB[req_idx];
 	dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mf_dma_addr=%x req_idx=%d "
 	    "RequestNB=%x\n", ioc->name, mf_dma_addr, req_idx,
 	    ioc->RequestNB[req_idx]));
@@ -973,7 +952,7 @@ mpt_add_sge(char *pAddr, u32 flagslength
 int
 mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag)
 {
-	int	r = 0;
+	int	 r = 0;
 	u8	*req_as_bytes;
 	int	 ii;
 
@@ -988,7 +967,7 @@ mpt_send_handshake_request(u8 cb_idx, MP
 	 * is in proper (pre-alloc'd) request buffer range...
 	 */
 	ii = MFPTR_2_MPT_INDEX(ioc,(MPT_FRAME_HDR*)req);
-	if (reqBytes >= 12 && ii >= 0 && ii < ioc->req_depth) {
+	if (ii >= 0 && ii < ioc->req_depth) {
 		MPT_FRAME_HDR *mf = (MPT_FRAME_HDR*)req;
 		mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(ii);
 		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = cb_idx;
@@ -1507,9 +1486,13 @@ mpt_attach(struct pci_dev *pdev, const s
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
 
 	ioc->pcidev = pdev;
-	ioc->diagPending = 0;
-	spin_lock_init(&ioc->diagLock);
-	spin_lock_init(&ioc->initializing_hba_lock);
+	spin_lock_init(&ioc->taskmgmt_lock);
+	mutex_init(&ioc->internal_cmds.mutex);
+	init_completion(&ioc->internal_cmds.done);
+	mutex_init(&ioc->mptbase_cmds.mutex);
+	init_completion(&ioc->mptbase_cmds.done);
+	mutex_init(&ioc->taskmgmt_cmds.mutex);
+	init_completion(&ioc->taskmgmt_cmds.done);
 
 	/* Initialize the event logging.
 	 */
@@ -1522,16 +1505,13 @@ mpt_attach(struct pci_dev *pdev, const s
 	ioc->mfcnt = 0;
 #endif
 
+	ioc->sh = NULL;
 	ioc->cached_fw = NULL;
 
 	/* Initilize SCSI Config Data structure
 	 */
 	memset(&ioc->spi_data, 0, sizeof(SpiCfgData));
 
-	/* Initialize the running configQ head.
-	 */
-	INIT_LIST_HEAD(&ioc->configQ);
-
 	/* Initialize the fc rport list head.
 	 */
 	INIT_LIST_HEAD(&ioc->fc_rports);
@@ -1539,6 +1519,20 @@ mpt_attach(struct pci_dev *pdev, const s
 	/* Find lookup slot. */
 	INIT_LIST_HEAD(&ioc->list);
 
+	/* Initialize work */
+	INIT_DELAYED_WORK(&ioc->fault_reset_work, mpt_fault_reset_work);
+
+	/* Initialize workqueue */
+	snprintf(ioc->reset_work_q_name, KOBJ_NAME_LEN, "mpt_poll_%d", ioc->id);
+	ioc->reset_work_q =
+		create_singlethread_workqueue(ioc->reset_work_q_name);
+	if (!ioc->reset_work_q) {
+		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
+		    ioc->name);
+		kfree(ioc);
+		return -ENOMEM;
+	}
+
 	mem_phys = msize = 0;
 	port = psize = 0;
 	for (ii=0; ii < DEVICE_COUNT_RESOURCE; ii++) {
@@ -1706,6 +1700,9 @@ mpt_attach(struct pci_dev *pdev, const s
 	}
 #endif
 
+	if (!ioc->alt_ioc)
+		queue_delayed_work(ioc->reset_work_q, &ioc->fault_reset_work,
+			msecs_to_jiffies(MPT_POLLING_INTERVAL));
 	return 0;
 }
 
@@ -1721,6 +1718,18 @@ mpt_detach(struct pci_dev *pdev)
 	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
 	char pname[32];
 	u8 cb_idx;
+	unsigned long	 flags;
+	struct workqueue_struct *wq;
+
+	/*
+	 * Stop polling ioc for fault condition
+	 */
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	wq = ioc->reset_work_q;
+	ioc->reset_work_q = NULL;
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+	cancel_delayed_work(&ioc->fault_reset_work);
+	destroy_workqueue(wq);
 
 	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/summary", ioc->name);
 	remove_proc_entry(pname, NULL);
@@ -1819,10 +1828,6 @@ mpt_resume(struct pci_dev *pdev)
 	if (err)
 		return err;
 
-	/* enable interrupts */
-	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
-	ioc->active = 1;
-
 	printk(MYIOC_s_INFO_FMT
 		"pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
 		ioc->name,
@@ -1830,8 +1835,7 @@ mpt_resume(struct pci_dev *pdev)
 		CHIPREG_READ32(&ioc->chip->Doorbell));
 
 	/* bring ioc to operational state */
-	if ((recovery_state = mpt_do_ioc_recovery(ioc,
-	    MPT_HOSTEVENT_IOC_RECOVER, CAN_SLEEP)) != 0) {
+	if ((recovery_state = mpt_HardResetHandler(ioc, CAN_SLEEP)) != 0) {
 		printk(MYIOC_s_INFO_FMT
 			"pci-resume: Cannot recover, error:[%x]\n",
 			ioc->name, recovery_state);
@@ -1887,8 +1891,6 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 	int	 hard;
 	int	 rc=0;
 	int	 ii;
-	u8	 cb_idx;
-	int	 handlers;
 	int	 ret = 0;
 	int	 reset_alt_ioc_active = 0;
 	int	 irq_allocated = 0;
@@ -1902,7 +1904,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 	ioc->active = 0;
 
 	if (ioc->alt_ioc) {
-		if (ioc->alt_ioc->active)
+		if (ioc->alt_ioc->active || reason == MPT_HOSTEVENT_IOC_RECOVER)
 			reset_alt_ioc_active = 1;
 
 		/* Disable alt-IOC's reply interrupts (and FreeQ) for a bit ... */
@@ -1930,7 +1932,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		} else {
 			printk(MYIOC_s_WARN_FMT "NOT READY!\n", ioc->name);
 		}
-		return -1;
+		ret = -1;
+		goto out;
 	}
 
 	/* hard_reset_done = 0 if a soft reset was performed
@@ -1987,14 +1990,19 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 			if (mpt_msi_enable && !pci_enable_msi(ioc->pcidev))
 				printk(MYIOC_s_INFO_FMT "PCI-MSI enabled\n",
 				    ioc->name);
+			else
+				mpt_msi_enable = 0;
+
 			rc = request_irq(ioc->pcidev->irq, mpt_interrupt,
 			    IRQF_SHARED, ioc->name, ioc);
+
 			if (rc < 0) {
 				printk(MYIOC_s_ERR_FMT "Unable to allocate "
 				    "interrupt %d!\n", ioc->name, ioc->pcidev->irq);
 				if (mpt_msi_enable)
 					pci_disable_msi(ioc->pcidev);
-				return -EBUSY;
+				ret = -EBUSY;
+				goto out;
 			}
 			irq_allocated = 1;
 			ioc->pci_irq = ioc->pcidev->irq;
@@ -2056,7 +2064,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 						ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 						    "mpt_upload:  alt_%s has cached_fw=%p \n",
 						    ioc->name, ioc->alt_ioc->name, ioc->alt_ioc->cached_fw));
-						ioc->alt_ioc->cached_fw = NULL;
+						ioc->cached_fw = NULL;
 					}
 				} else {
 					printk(MYIOC_s_WARN_FMT
@@ -2067,28 +2075,30 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		}
 	}
 
+	/*  Enable MPT base driver management of EventNotification
+	 *  and EventAck handling.
+	 */
+	if ((ret == 0) && (!ioc->facts.EventState))
+		ret = SendEventNotification(ioc, 1, sleepFlag);	/* 1=Enable */
+
+	if (ioc->alt_ioc && alt_ioc_ready && !ioc->alt_ioc->facts.EventState)
+		rc = SendEventNotification(ioc->alt_ioc, 1, sleepFlag);
+
 	if (ret == 0) {
 		/* Enable! (reply interrupt) */
 		CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
 		ioc->active = 1;
 	}
-
-	if (reset_alt_ioc_active && ioc->alt_ioc) {
-		/* (re)Enable alt-IOC! (reply interrupt) */
-		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "alt_ioc reply irq re-enabled\n",
-		    ioc->alt_ioc->name));
-		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
-		ioc->alt_ioc->active = 1;
+	if (rc == 0) {	/* alt ioc */
+		if (reset_alt_ioc_active && ioc->alt_ioc) {
+			/* (re)Enable alt-IOC! (reply interrupt) */
+			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "alt-ioc reply irq re-enabled\n",
+				ioc->alt_ioc->name));
+			CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
+			ioc->alt_ioc->active = 1;
+		}
 	}
 
-	/*  Enable MPT base driver management of EventNotification
-	 *  and EventAck handling.
-	 */
-	if ((ret == 0) && (!ioc->facts.EventState))
-		(void) SendEventNotification(ioc, 1);	/* 1=Enable EventNotification */
-
-	if (ioc->alt_ioc && alt_ioc_ready && !ioc->alt_ioc->facts.EventState)
-		(void) SendEventNotification(ioc->alt_ioc, 1);	/* 1=Enable EventNotification */
 
 	/*	Add additional "reason" check before call to GetLanConfigPages
 	 *	(combined with GetIoUnitPage2 call).  This prevents a somewhat
@@ -2104,8 +2114,9 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		init_MUTEX(&ioc->raid_data.inactive_list_mutex);
 		INIT_LIST_HEAD(&ioc->raid_data.inactive_list);
 
-		if (ioc->bus_type == SAS) {
+		switch (ioc->bus_type) {
 
+		case SAS:
 			/* clear persistency table */
 			if(ioc->facts.IOCExceptions &
 			    MPI_IOCFACTS_EXCEPT_PERSISTENT_TABLE_FULL) {
@@ -2119,8 +2130,15 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 			 */
 			mpt_findImVolumes(ioc);
 
-		} else if (ioc->bus_type == FC) {
-			if ((ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) &&
+			/* Check, and possibly reset, the coalescing value
+			 */
+			mpt_read_ioc_pg_1(ioc);
+
+			break;
+
+		case FC:
+			if ((ioc->pfacts[0].ProtocolFlags &
+				MPI_PORTFACTS_PROTOCOL_LAN) &&
 			    (ioc->lan_cnfg_page0.Header.PageLength == 0)) {
 				/*
 				 *  Pre-fetch the ports LAN MAC address!
@@ -2131,9 +2149,10 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				    "LanAddr = %02X:%02X:%02X:%02X:%02X:%02X\n",
 				    ioc->name, a[5], a[4], a[3], a[2], a[1], a[0]));
-
 			}
-		} else {
+			break;
+
+		case SPI:
 			/* Get NVRAM and adapter maximums from SPP 0 and 2
 			 */
 			mpt_GetScsiPortSettings(ioc, 0);
@@ -2152,41 +2171,16 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 			mpt_read_ioc_pg_1(ioc);
 
 			mpt_read_ioc_pg_4(ioc);
+
+			break;
 		}
 
 		GetIoUnitPage2(ioc);
 		mpt_get_manufacturing_pg_0(ioc);
 	}
 
-	/*
-	 * Call each currently registered protocol IOC reset handler
-	 * with post-reset indication.
-	 * NOTE: If we're doing _IOC_BRINGUP, there can be no
-	 * MptResetHandlers[] registered yet.
-	 */
-	if (hard_reset_done) {
-		rc = handlers = 0;
-		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
-			if ((ret == 0) && MptResetHandlers[cb_idx]) {
-				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-				    "Calling IOC post_reset handler #%d\n",
-				    ioc->name, cb_idx));
-				rc += mpt_signal_reset(cb_idx, ioc, MPT_IOC_POST_RESET);
-				handlers++;
-			}
-
-			if (alt_ioc_ready && MptResetHandlers[cb_idx]) {
-				drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-				    "Calling IOC post_reset handler #%d\n",
-				    ioc->alt_ioc->name, cb_idx));
-				rc += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_POST_RESET);
-				handlers++;
-			}
-		}
-		/* FIXME?  Examine results here? */
-	}
-
  out:
+
 	if ((ret != 0) && irq_allocated) {
 		free_irq(ioc->pci_irq, ioc);
 		if (mpt_msi_enable)
@@ -2279,7 +2273,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 	if (ioc->alloc != NULL) {
 		sz = ioc->alloc_sz;
 		dexitprintk(ioc, printk(MYIOC_s_INFO_FMT "free  @ %p, sz=%d bytes\n",
-		    ioc->name, ioc->alloc, ioc->alloc_sz));
+		 	ioc->name, ioc->alloc, ioc->alloc_sz));
 		pci_free_consistent(ioc->pcidev, sz,
 				ioc->alloc, ioc->alloc_dma);
 		ioc->reply_frames = NULL;
@@ -2303,13 +2297,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 		ioc->alloc_total -= sz;
 	}
 
-	if (ioc->cached_fw != NULL) {
-		sz = ioc->facts.FWImageSize;
-		pci_free_consistent(ioc->pcidev, sz,
-			ioc->cached_fw, ioc->cached_fw_dma);
-		ioc->cached_fw = NULL;
-		ioc->alloc_total -= sz;
-	}
+	mpt_free_fw_memory(ioc);
 
 	kfree(ioc->spi_data.nvram);
 	mpt_inactive_raid_list_free(ioc);
@@ -2563,8 +2551,8 @@ MakeIocReady(MPT_ADAPTER *ioc, int force
 
 		ii++; cntdn--;
 		if (!cntdn) {
-			printk(MYIOC_s_ERR_FMT "Wait IOC_READY state timeout(%d)!\n",
-					ioc->name, (int)((ii+5)/HZ));
+			printk(MYIOC_s_ERR_FMT "Wait IOC_READY state (0x%x) timeout(%d)!\n",
+					ioc->name, ioc_state, (int)((ii+5)/HZ));
 			return -ETIME;
 		}
 
@@ -2807,8 +2795,8 @@ GetPortFacts(MPT_ADAPTER *ioc, int portn
 
 	/* IOC *must* NOT be in RESET state! */
 	if (ioc->last_state == MPI_IOC_STATE_RESET) {
-		printk(MYIOC_s_ERR_FMT "Can't get PortFacts NOT READY! (%08x)\n",
-		    ioc->name, ioc->last_state );
+		printk(MYIOC_s_ERR_FMT "Can't get PortFacts, "
+		   " NOT READY! (%08x)\n", ioc->name, ioc->last_state );
 		return -4;
 	}
 
@@ -2827,13 +2815,13 @@ GetPortFacts(MPT_ADAPTER *ioc, int portn
 	/* Assert: All other get_pfacts fields are zero! */
 
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending get PortFacts(%d) request\n",
-			ioc->name, portnum));
+		ioc->name, portnum));
 
 	/* No non-zero fields in the get_pfacts request are greater than
 	 * 1 byte in size, so we can just fire it off as is.
 	 */
 	ii = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&get_pfacts,
-				reply_sz, (u16*)pfacts, 5 /*seconds*/, sleepFlag);
+		reply_sz, (u16*)pfacts, 5 /*seconds*/, sleepFlag);
 	if (ii != 0)
 		return ii;
 
@@ -3047,22 +3035,39 @@ SendPortEnable(MPT_ADAPTER *ioc, int por
  *
  *	If memory has already been allocated, the same (cached) value
  *	is returned.
- */
-void
+ *
+ *	Return 0 if successfull, or non-zero for failure
+ **/
+int
 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size)
 {
-	if (ioc->cached_fw)
-		return;  /* use already allocated memory */
-	if (ioc->alt_ioc && ioc->alt_ioc->cached_fw) {
+	int rc;
+
+	if (ioc->cached_fw) {
+		rc = 0;  /* use already allocated memory */
+		goto out;
+	}
+	else if (ioc->alt_ioc && ioc->alt_ioc->cached_fw) {
 		ioc->cached_fw = ioc->alt_ioc->cached_fw;  /* use alt_ioc's memory */
 		ioc->cached_fw_dma = ioc->alt_ioc->cached_fw_dma;
-		ioc->alloc_total += size;
-		ioc->alt_ioc->alloc_total -= size;
+		rc = 0;
+		goto out;
+	}
+	ioc->cached_fw = pci_alloc_consistent(ioc->pcidev, size, &ioc->cached_fw_dma);
+	if (!ioc->cached_fw) {
+		printk(MYIOC_s_ERR_FMT "Unable to memory for the cached firmware image!\n",
+		    ioc->name);
+		rc = -1;
 	} else {
-		if ( (ioc->cached_fw = pci_alloc_consistent(ioc->pcidev, size, &ioc->cached_fw_dma) ) )
-			ioc->alloc_total += size;
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "FW Image  @ %p[%p], sz=%d[%x] bytes\n",
+		    ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, size, size));
+		ioc->alloc_total += size;
+		rc = 0;
 	}
+ out:
+	return rc;
 }
+
 /**
  *	mpt_free_fw_memory - free firmware memory
  *	@ioc: Pointer to MPT_ADAPTER structure
@@ -3075,16 +3080,17 @@ mpt_free_fw_memory(MPT_ADAPTER *ioc)
 {
 	int sz;
 
+	if (!ioc->cached_fw)
+		return;
+
 	sz = ioc->facts.FWImageSize;
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "free_fw_memory: FW Image  @ %p[%p], sz=%d[%x] bytes\n",
-	    ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "free_fw_memory: FW Image  @ %p[%p], sz=%d[%x] bytes\n",
+		 ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
 	pci_free_consistent(ioc->pcidev, sz, ioc->cached_fw, ioc->cached_fw_dma);
+	ioc->alloc_total -= sz;
 	ioc->cached_fw = NULL;
-
-	return;
 }
 
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_do_upload - Construct and Send FWUpload request to MPT adapter port.
@@ -3106,27 +3112,20 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 	FWUpload_t		*prequest;
 	FWUploadReply_t		*preply;
 	FWUploadTCSGE_t		*ptcsge;
-	int			 sgeoffset;
 	u32			 flagsLength;
-	int			 ii, sz, reply_sz;
+	int			 ii, reply_sz;
 	int			 cmdStatus;
+	int			 request_size;
 
 	/* If the image size is 0, we are done.
 	 */
-	if ((sz = ioc->facts.FWImageSize) == 0)
+	if (!ioc->facts.FWImageSize)
 		return 0;
 
-	mpt_alloc_fw_memory(ioc, sz);
-
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": FW Image  @ %p[%p], sz=%d[%x] bytes\n",
-	    ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
-
-	if (ioc->cached_fw == NULL) {
-		/* Major Failure.
-		 */
+	if (mpt_alloc_fw_memory(ioc, ioc->facts.FWImageSize) != 0)
 		return -ENOMEM;
-	}
 
+	preply = (FWUploadReply_t *)&reply;
 	prequest = (sleepFlag == NO_SLEEP) ? kzalloc(ioc->req_sz, GFP_ATOMIC) :
 	    kzalloc(ioc->req_sz, GFP_KERNEL);
 	if (!prequest) {
@@ -3136,56 +3135,52 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 		return -ENOMEM;
 	}
 
-	preply = (FWUploadReply_t *)&reply;
-
 	reply_sz = sizeof(reply);
 	memset(preply, 0, reply_sz);
 
 	prequest->ImageType = MPI_FW_UPLOAD_ITYPE_FW_IOC_MEM;
 	prequest->Function = MPI_FUNCTION_FW_UPLOAD;
-
 	ptcsge = (FWUploadTCSGE_t *) &prequest->SGL;
 	ptcsge->DetailsLength = 12;
 	ptcsge->Flags = MPI_SGE_FLAGS_TRANSACTION_ELEMENT;
-	ptcsge->ImageSize = cpu_to_le32(sz);
+	ptcsge->ImageSize = cpu_to_le32(ioc->facts.FWImageSize);
 	ptcsge++;
 
-	sgeoffset = sizeof(FWUpload_t) - sizeof(SGE_MPI_UNION) + sizeof(FWUploadTCSGE_t);
-
-	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ | sz;
+	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ | ioc->facts.FWImageSize;
 	mpt_add_sge((char *)ptcsge, flagsLength, ioc->cached_fw_dma);
-
-	sgeoffset += sizeof(u32) + sizeof(dma_addr_t);
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": Sending FW Upload (req @ %p) sgeoffset=%d \n",
-	    ioc->name, prequest, sgeoffset));
+	request_size = offsetof(FWUpload_t, SGL) + sizeof(FWUploadTCSGE_t) +
+	    sizeof(u32) + sizeof(dma_addr_t);
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending FW Upload "
+	    " (req @ %p) fw_size=%d mf_request_size=%d\n", ioc->name, prequest,
+	    ioc->facts.FWImageSize, request_size));
 	DBG_DUMP_FW_REQUEST_FRAME(ioc, (u32 *)prequest);
 
-	ii = mpt_handshake_req_reply_wait(ioc, sgeoffset, (u32*)prequest,
-				reply_sz, (u16*)preply, 65 /*seconds*/, sleepFlag);
+	ii = mpt_handshake_req_reply_wait(ioc, request_size, (u32*)prequest,
+	    reply_sz, (u16*)preply, 65 /*seconds*/, sleepFlag);
 
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": FW Upload completed rc=%x \n", ioc->name, ii));
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "FW Upload completed "
+	    "rc=%x \n", ioc->name, ii));
 
 	cmdStatus = -EFAULT;
 	if (ii == 0) {
 		/* Handshake transfer was complete and successful.
 		 * Check the Reply Frame.
 		 */
-		int status, transfer_sz;
-		status = le16_to_cpu(preply->IOCStatus);
-		if (status == MPI_IOCSTATUS_SUCCESS) {
-			transfer_sz = le32_to_cpu(preply->ActualImageSize);
-			if (transfer_sz == sz)
-				cmdStatus = 0;
-		}
+		int status;
+		status = le16_to_cpu(preply->IOCStatus) &
+	            MPI_IOCSTATUS_MASK;
+		if (status == MPI_IOCSTATUS_SUCCESS &&
+		    ioc->facts.FWImageSize ==
+		    le32_to_cpu(preply->ActualImageSize));
+			cmdStatus = 0;
 	}
-	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": do_upload cmdStatus=%d \n",
-			ioc->name, cmdStatus));
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "do_upload cmdStatus=%d \n",
+		ioc->name, cmdStatus));
 
 
 	if (cmdStatus) {
-
-		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": fw upload failed, freeing image \n",
-			ioc->name));
+		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "fw upload failed, "
+		    "freeing image \n", ioc->name));
 		mpt_free_fw_memory(ioc);
 	}
 	kfree(prequest);
@@ -3218,10 +3213,10 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 	u32			 diagRwData;
 	u32			 nextImage;
 	u32			 load_addr;
-	u32 			 ioc_state=0;
+	u32			 doorbell;
 
 	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "downloadboot: fw size 0x%x (%d), FW Ptr %p\n",
-				ioc->name, pFwHeader->ImageSize, pFwHeader->ImageSize, pFwHeader));
+	    ioc->name, pFwHeader->ImageSize, pFwHeader->ImageSize, pFwHeader));
 
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_1ST_KEY_VALUE);
@@ -3233,11 +3228,10 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, (MPI_DIAG_PREVENT_IOC_BOOT | MPI_DIAG_DISABLE_ARM));
 
 	/* wait 1 msec */
-	if (sleepFlag == CAN_SLEEP) {
+	if (sleepFlag == CAN_SLEEP)
 		msleep(1);
-	} else {
-		mdelay (1);
-	}
+	else
+		udelay (1000);
 
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val | MPI_DIAG_RESET_ADAPTER);
@@ -3250,11 +3244,10 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 			break;
 		}
 		/* wait .1 sec */
-		if (sleepFlag == CAN_SLEEP) {
+		if (sleepFlag == CAN_SLEEP)
 			msleep (100);
-		} else {
+		else
 			mdelay (100);
-		}
 	}
 
 	if ( count == 30 ) {
@@ -3272,6 +3265,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_5TH_KEY_VALUE);
 
 	/* Set the DiagRwEn and Disable ARM bits */
+	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, (MPI_DIAG_RW_ENABLE | MPI_DIAG_DISABLE_ARM));
 
 	fwSize = (pFwHeader->ImageSize + 3)/4;
@@ -3285,13 +3279,12 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, pFwHeader->LoadStartAddress);
 	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "LoadStart addr written 0x%x \n",
-		ioc->name, pFwHeader->LoadStartAddress));
+	    ioc->name, pFwHeader->LoadStartAddress));
 
 	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Write FW Image: 0x%x bytes @ %p\n",
-				ioc->name, fwSize*4, ptrFw));
-	while (fwSize--) {
+	    ioc->name, fwSize*4, ptrFw));
+	while (fwSize--)
 		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, *ptrFw++);
-	}
 
 	nextImage = pFwHeader->NextImageHeaderOffset;
 	while (nextImage) {
@@ -3303,21 +3296,22 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 		ptrFw = (u32 *)pExtImage;
 
 		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Write Ext Image: 0x%x (%d) bytes @ %p load_addr=%x\n",
-						ioc->name, fwSize*4, fwSize*4, ptrFw, load_addr));
+		    ioc->name, fwSize*4, fwSize*4, ptrFw, load_addr));
 		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, load_addr);
 
-		while (fwSize--) {
+		while (fwSize--)
 			CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, *ptrFw++);
-		}
 		nextImage = pExtImage->NextImageHeaderOffset;
 	}
 
 	/* Write the IopResetVectorRegAddr */
-	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Write IopResetVector Addr=%x! \n", ioc->name, 	pFwHeader->IopResetRegAddr));
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Write IopResetVector Addr=%x! \n",
+	    ioc->name, pFwHeader->IopResetRegAddr));
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, pFwHeader->IopResetRegAddr);
 
 	/* Write the IopResetVectorValue */
-	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Write IopResetVector Value=%x! \n", ioc->name, pFwHeader->IopResetVectorValue));
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Write IopResetVector Value=%x! \n",
+	    ioc->name, pFwHeader->IopResetVectorValue));
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, pFwHeader->IopResetVectorValue);
 
 	/* Clear the internal flash bad bit - autoincrementing register,
@@ -3334,71 +3328,72 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);
 		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, diagRwData);
 
-	} else /* if((ioc->bus_type == SAS) || (ioc->bus_type == FC)) */ {
-		diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
-		CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val |
-		    MPI_DIAG_CLEAR_FLASH_BAD_SIG);
-
-		/* wait 1 msec */
-		if (sleepFlag == CAN_SLEEP) {
-			msleep (1);
-		} else {
-			mdelay (1);
-		}
 	}
 
 	if (ioc->errata_flag_1064)
 		pci_disable_io_access(ioc->pcidev);
 
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
-	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "downloadboot diag0val=%x, "
-		"turning off PREVENT_IOC_BOOT, DISABLE_ARM, RW_ENABLE\n",
-		ioc->name, diag0val));
-	diag0val &= ~(MPI_DIAG_PREVENT_IOC_BOOT | MPI_DIAG_DISABLE_ARM | MPI_DIAG_RW_ENABLE);
-	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "downloadboot now diag0val=%x\n",
-		ioc->name, diag0val));
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "diag0val=%x, turning off"
+	    " PREVENT_IOC_BOOT and DISABLE_ARM\n", ioc->name, diag0val));
+	diag0val &= ~(MPI_DIAG_PREVENT_IOC_BOOT | MPI_DIAG_DISABLE_ARM);
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "diag0val=%x\n",
+	    ioc->name, diag0val));
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
 
-	/* Write 0xFF to reset the sequencer */
-	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
+	if (ioc->bus_type == SAS ) {
+		/* wait 1 sec */
+		if (sleepFlag == CAN_SLEEP)
+			msleep(1000);
+		else
+			mdelay(1000);
 
-	if (ioc->bus_type == SAS) {
-		ioc_state = mpt_GetIocState(ioc, 0);
-		if ( (GetIocFacts(ioc, sleepFlag,
-				MPT_HOSTEVENT_IOC_BRINGUP)) != 0 ) {
-			ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "GetIocFacts failed: IocState=%x\n",
-					ioc->name, ioc_state));
-			return -EFAULT;
+		diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+		ddlprintk(ioc, printk (MYIOC_s_DEBUG_FMT
+		    "diag0val=%x, turning off RW_ENABLE\n", ioc->name,
+		    diag0val));
+		diag0val &= ~(MPI_DIAG_RW_ENABLE);
+		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "now diag0val=%x\n", ioc->name, diag0val));
+		CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
+
+		diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+		if (diag0val & MPI_DIAG_FLASH_BAD_SIG) {
+			diag0val |= MPI_DIAG_CLEAR_FLASH_BAD_SIG;
+			CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
+			diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
 		}
+		diag0val &= ~(MPI_DIAG_DISABLE_ARM);
+		CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
+		diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+		CHIPREG_WRITE32(&ioc->chip->DiagRwAddress, 0x3f000004);
 	}
 
-	for (count=0; count<HZ*20; count++) {
-		if ((ioc_state = mpt_GetIocState(ioc, 0)) & MPI_IOC_STATE_READY) {
-			ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-				"downloadboot successful! (count=%d) IocState=%x\n",
-				ioc->name, count, ioc_state));
-			if (ioc->bus_type == SAS) {
+	/* Write 0xFF to reset the sequencer */
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
+
+	for (count = 0; count < 30; count ++) {
+		doorbell = CHIPREG_READ32(&ioc->chip->Doorbell) & MPI_IOC_STATE_MASK;
+		if (doorbell == MPI_IOC_STATE_READY) {
+			if (ioc->bus_type == SAS)
 				return 0;
-			}
 			if ((SendIocInit(ioc, sleepFlag)) != 0) {
-				ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-					"downloadboot: SendIocInit failed\n",
-					ioc->name));
+				ddlprintk(ioc, printk(MYIOC_s_WARN_FMT
+				    "SendIocInit failed\n", ioc->name));
 				return -EFAULT;
 			}
 			ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-					"downloadboot: SendIocInit successful\n",
-					ioc->name));
+			    "SendIocInit successful\n", ioc->name));
 			return 0;
 		}
-		if (sleepFlag == CAN_SLEEP) {
-			msleep (10);
-		} else {
-			mdelay (10);
-		}
+		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "looking for READY STATE:"
+		    " doorbell=%x count=%d\n", ioc->name, doorbell, count));
+		if (sleepFlag == CAN_SLEEP)
+			msleep(1000);
+		else
+			mdelay(1000);
 	}
-	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-		"downloadboot failed! IocState=%x\n",ioc->name, ioc_state));
+	ddlprintk(ioc, printk(MYIOC_s_WARN_FMT "downloadboot failed! count=%d\n", ioc->name, count));
 	return -EFAULT;
 }
 
@@ -3453,6 +3448,7 @@ KickStart(MPT_ADAPTER *ioc, int force, i
 	if (hard_reset_done < 0)
 		return hard_reset_done;
 
+	/* may not have worked but hard_reset_done doesn't always signal failure */
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Diagnostic reset successful!\n",
 		ioc->name));
 
@@ -3467,7 +3463,7 @@ KickStart(MPT_ADAPTER *ioc, int force, i
 		if (sleepFlag == CAN_SLEEP) {
 			msleep (10);
 		} else {
-			mdelay (10);
+			udelay (10000);
 		}
 	}
 
@@ -3498,25 +3494,41 @@ KickStart(MPT_ADAPTER *ioc, int force, i
 static int
 mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 {
-	MPT_ADAPTER	*iocp=NULL;
 	u32 diag0val;
-	u32 doorbell;
+	u32 doorbell = 0;
 	int hard_reset_done = 0;
 	int count = 0;
 	u32 diag1val = 0;
+	MpiFwHeader_t *cached_fw;	/* Pointer to FW */
+	u8	 cb_idx;
 
 	/* Clear any existing interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
 	if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078) {
+
+		if (!ignore)
+			return 0;
+
 		drsprintk(ioc, printk(MYIOC_s_WARN_FMT "%s: Doorbell=%p; 1078 reset "
-			"address=%p\n",  ioc->name, __FUNCTION__,
-			&ioc->chip->Doorbell, &ioc->chip->Reset_1078));
+		    "address=%p\n",  ioc->name, __FUNCTION__, &ioc->chip->Doorbell,
+		    &ioc->chip->Reset_1078));
 		CHIPREG_WRITE32(&ioc->chip->Reset_1078, 0x07);
 		if (sleepFlag == CAN_SLEEP)
 			msleep(1);
 		else
-			mdelay(1);
+			udelay(1000);
+
+		/*
+		 * Call each currently registered protocol IOC reset handler
+		 * with pre-reset indication.
+		 * NOTE: If we're doing _IOC_BRINGUP, there can be no
+		 * MptResetHandlers[] registered yet.
+		 */
+		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+			if (MptResetHandlers[cb_idx])
+				(*(MptResetHandlers[cb_idx]))(ioc, MPT_IOC_PRE_RESET);
+		}
 
 		for (count = 0; count < 60; count ++) {
 			doorbell = CHIPREG_READ32(&ioc->chip->Doorbell);
@@ -3526,9 +3538,15 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 				"looking for READY STATE: doorbell=%x"
 			        " count=%d\n",
 				ioc->name, doorbell, count));
-			if (doorbell == MPI_IOC_STATE_READY) {
+
+			if (doorbell == MPI_IOC_STATE_READY)
 				return 1;
-			}
+
+			/*
+			 * Early out for hard fault
+			 */
+			if (count && doorbell == MPI_IOC_STATE_FAULT)
+				break;
 
 			/* wait 1 sec */
 			if (sleepFlag == CAN_SLEEP)
@@ -3536,6 +3554,10 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 			else
 				mdelay(1000);
 		}
+
+		if (doorbell != MPI_IOC_STATE_READY)
+			printk(MYIOC_s_ERR_FMT "Failed to come READY after "
+			    "reset! IocState=%x", ioc->name, doorbell);
 		return -1;
 	}
 
@@ -3565,11 +3587,10 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 			CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_5TH_KEY_VALUE);
 
 			/* wait 100 msec */
-			if (sleepFlag == CAN_SLEEP) {
+			if (sleepFlag == CAN_SLEEP)
 				msleep (100);
-			} else {
+			else
 				mdelay (100);
-			}
 
 			count++;
 			if (count > 20) {
@@ -3596,7 +3617,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 		 *
 		 */
 		CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val | MPI_DIAG_DISABLE_ARM);
-		mdelay(1);
+		udelay(1000);
 
 		/*
 		 * Now hit the reset bit in the Diagnostic register
@@ -3613,57 +3634,44 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 		 * NOTE: If we're doing _IOC_BRINGUP, there can be no
 		 * MptResetHandlers[] registered yet.
 		 */
-		{
-			u8	 cb_idx;
-			int	 r = 0;
-
-			for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
-				if (MptResetHandlers[cb_idx]) {
-					dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-						"Calling IOC pre_reset handler #%d\n",
-						ioc->name, cb_idx));
-					r += mpt_signal_reset(cb_idx, ioc, MPT_IOC_PRE_RESET);
-					if (ioc->alt_ioc) {
-						dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-							"Calling alt-%s pre_reset handler #%d\n",
-							ioc->name, ioc->alt_ioc->name, cb_idx));
-						r += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_PRE_RESET);
-					}
+		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+			if (MptResetHandlers[cb_idx]) {
+				mpt_signal_reset(cb_idx, ioc, MPT_IOC_PRE_RESET);
+				if (ioc->alt_ioc) {
+					mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_PRE_RESET);
 				}
 			}
-			/* FIXME?  Examine results here? */
 		}
 
 		if (ioc->cached_fw)
-			iocp = ioc;
+			cached_fw = (MpiFwHeader_t *)ioc->cached_fw;
 		else if (ioc->alt_ioc && ioc->alt_ioc->cached_fw)
-			iocp = ioc->alt_ioc;
-		if (iocp) {
+			cached_fw = (MpiFwHeader_t *)ioc->alt_ioc->cached_fw;
+		else
+			cached_fw = NULL;
+		if (cached_fw) {
 			/* If the DownloadBoot operation fails, the
 			 * IOC will be left unusable. This is a fatal error
 			 * case.  _diag_reset will return < 0
 			 */
 			for (count = 0; count < 30; count ++) {
-				diag0val = CHIPREG_READ32(&iocp->chip->Diagnostic);
+				diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
 				if (!(diag0val & MPI_DIAG_RESET_ADAPTER)) {
 					break;
 				}
 
 				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "cached_fw: diag0val=%x count=%d\n",
-					iocp->name, diag0val, count));
+					ioc->name, diag0val, count));
 				/* wait 1 sec */
-				if (sleepFlag == CAN_SLEEP) {
+				if (sleepFlag == CAN_SLEEP)
 					msleep (1000);
-				} else {
+				else
 					mdelay (1000);
-				}
 			}
-			if ((count = mpt_downloadboot(ioc,
-				(MpiFwHeader_t *)iocp->cached_fw, sleepFlag)) < 0) {
+			if ((count = mpt_downloadboot(ioc, cached_fw, sleepFlag)) < 0) {
 				printk(MYIOC_s_WARN_FMT
 					"firmware downloadboot failure (%d)!\n", ioc->name, count);
 			}
-
 		} else {
 			/* Wait for FW to reload and for board
 			 * to go to the READY state.
@@ -3675,17 +3683,30 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 				doorbell = CHIPREG_READ32(&ioc->chip->Doorbell);
 				doorbell &= MPI_IOC_STATE_MASK;
 
-				if (doorbell == MPI_IOC_STATE_READY) {
+				drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				    "looking for READY STATE: doorbell=%x"
+				    " count=%d\n", ioc->name, doorbell, count));
+
+				if (doorbell == MPI_IOC_STATE_READY)
+					break;
+
+				/*
+				 * Early out for hard fault
+				 */
+				if (count && doorbell == MPI_IOC_STATE_FAULT)
 					break;
-				}
 
 				/* wait 1 sec */
-				if (sleepFlag == CAN_SLEEP) {
+				if (sleepFlag == CAN_SLEEP)
 					msleep (1000);
-				} else {
+				else
 					mdelay (1000);
-				}
 			}
+
+			if (doorbell != MPI_IOC_STATE_READY)
+				printk(MYIOC_s_ERR_FMT "Failed to come READY "
+				    "after reset! IocState=%x", ioc->name,
+				    doorbell);
 		}
 	}
 
@@ -3714,11 +3735,10 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 		CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_5TH_KEY_VALUE);
 
 		/* wait 100 msec */
-		if (sleepFlag == CAN_SLEEP) {
+		if (sleepFlag == CAN_SLEEP)
 			msleep (100);
-		} else {
+		else
 			mdelay (100);
-		}
 
 		count++;
 		if (count > 20) {
@@ -3789,7 +3809,7 @@ SendIocReset(MPT_ADAPTER *ioc, u8 reset_
 	drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending IOC reset(0x%02x)!\n",
 			ioc->name, reset_type));
 	CHIPREG_WRITE32(&ioc->chip->Doorbell, reset_type<<MPI_DOORBELL_FUNCTION_SHIFT);
-	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0)
+	if ((r = WaitForDoorbellAck(ioc, 15, sleepFlag)) < 0)
 		return r;
 
 	/* FW ACK'd request, wait for READY state
@@ -3804,8 +3824,8 @@ SendIocReset(MPT_ADAPTER *ioc, u8 reset_
 			if (sleepFlag != CAN_SLEEP)
 				count *= 10;
 
-			printk(MYIOC_s_ERR_FMT "Wait IOC_READY state timeout(%d)!\n",
-			    ioc->name, (int)((count+5)/HZ));
+			printk(MYIOC_s_ERR_FMT "Wait IOC_READY state (0x%x) timeout(%d)!\n",
+					ioc->name, state, (int)((count+5)/HZ));
 			return -ETIME;
 		}
 
@@ -4297,18 +4317,18 @@ WaitForDoorbellInt(MPT_ADAPTER *ioc, int
 	cntdn = 1000 * howlong;
 	if (sleepFlag == CAN_SLEEP) {
 		while (--cntdn) {
+			msleep(1);
 			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
 			if (intstat & MPI_HIS_DOORBELL_INTERRUPT)
 				break;
-			msleep(1);
 			count++;
 		}
 	} else {
 		while (--cntdn) {
+			udelay (1000);
 			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
 			if (intstat & MPI_HIS_DOORBELL_INTERRUPT)
 				break;
-			udelay (1000);
 			count++;
 		}
 	}
@@ -4521,7 +4541,6 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 	return rc;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptbase_sas_persist_operation - Perform operation on SAS Persistent Table
  *	@ioc: Pointer to MPT_ADAPTER structure
@@ -4534,9 +4553,7 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
  *	NOTE: Don't use not this function during interrupt time.
  *
  *	Returns 0 for success, non-zero error
- */
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+ **/
 int
 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
 {
@@ -4544,7 +4561,14 @@ mptbase_sas_persist_operation(MPT_ADAPTE
 	SasIoUnitControlReply_t		*sasIoUnitCntrReply;
 	MPT_FRAME_HDR			*mf = NULL;
 	MPIHeader_t			*mpi_hdr;
+	int				ret = 0;
+	unsigned long 	 		timeleft;
 
+	mutex_lock(&ioc->mptbase_cmds.mutex);
+
+	/* init the internal cmd struct */
+	memset(ioc->mptbase_cmds.reply, 0 , MPT_DEFAULT_FRAME_SIZE);
+	INITIALIZE_MGMT_STATUS(ioc->mptbase_cmds.status)
 
 	/* insure garbage is not sent to fw */
 	switch(persist_opcode) {
@@ -4554,8 +4578,8 @@ mptbase_sas_persist_operation(MPT_ADAPTE
 		break;
 
 	default:
-		return -1;
-		break;
+		ret = -1;
+		goto out;
 	}
 
 	printk("%s: persist_opcode=%x\n",__FUNCTION__, persist_opcode);
@@ -4564,7 +4588,8 @@ mptbase_sas_persist_operation(MPT_ADAPTE
 	 */
 	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
 		printk("%s: no msg frames!\n",__FUNCTION__);
-		return -1;
+		ret = -1;
+		goto out;
         }
 
 	mpi_hdr = (MPIHeader_t *) mf;
@@ -4574,27 +4599,42 @@ mptbase_sas_persist_operation(MPT_ADAPTE
 	sasIoUnitCntrReq->MsgContext = mpi_hdr->MsgContext;
 	sasIoUnitCntrReq->Operation = persist_opcode;
 
-	init_timer(&ioc->persist_timer);
-	ioc->persist_timer.data = (unsigned long) ioc;
-	ioc->persist_timer.function = mpt_timer_expired;
-	ioc->persist_timer.expires = jiffies + HZ*10 /* 10 sec */;
-	ioc->persist_wait_done=0;
-	add_timer(&ioc->persist_timer);
 	mpt_put_msg_frame(mpt_base_index, ioc, mf);
-	wait_event(mpt_waitq, ioc->persist_wait_done);
+	timeleft = wait_for_completion_timeout(&ioc->mptbase_cmds.done, 10*HZ);
+	if (!(ioc->mptbase_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		printk("%s: failed\n", __FUNCTION__);
+		mpt_free_msg_frame(ioc, mf);
+		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out;
+		if (!timeleft) {
+			printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
+			    ioc->name, __FUNCTION__);
+			if (mpt_SoftResetHandler(ioc, CAN_SLEEP) != 0)
+				mpt_HardResetHandler(ioc, CAN_SLEEP);
+		}
+		goto out;
+	}
+
+	if (!(ioc->mptbase_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
+		ret = -1;
+		goto out;
+	}
 
 	sasIoUnitCntrReply =
-	    (SasIoUnitControlReply_t *)ioc->persist_reply_frame;
+	    (SasIoUnitControlReply_t *)ioc->mptbase_cmds.reply;
 	if (le16_to_cpu(sasIoUnitCntrReply->IOCStatus) != MPI_IOCSTATUS_SUCCESS) {
-		printk("%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
-		    __FUNCTION__,
-		    sasIoUnitCntrReply->IOCStatus,
-		    sasIoUnitCntrReply->IOCLogInfo);
-		return -1;
-	}
+		printk("%s: IOCStatus=0x%X IOCLogInfo=0x%X\n", __FUNCTION__,
+		    sasIoUnitCntrReply->IOCStatus, sasIoUnitCntrReply->IOCLogInfo);
+		printk("%s: failed\n",__FUNCTION__);
+		ret = -1;
+	} else
+		printk("%s: success\n",__FUNCTION__);
+ out:
 
-	printk("%s: success\n",__FUNCTION__);
-	return 0;
+	CLEAR_MGMT_STATUS(ioc->mptbase_cmds.status)
+	mutex_unlock(&ioc->mptbase_cmds.mutex);
+	return ret;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -5556,35 +5596,32 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *
 		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	SendEventNotification - Send EventNotification (on or off) request to adapter
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@EvSwitch: Event switch flags
- */
+ *	@sleepFlag: Specifies whether the process can sleep
+ **/
 static int
-SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch)
+SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch, int sleepFlag)
 {
-	EventNotification_t	*evnp;
+	EventNotification_t	evn;
+	MPIDefaultReply_t	reply_buf;
 
-	evnp = (EventNotification_t *) mpt_get_msg_frame(mpt_base_index, ioc);
-	if (evnp == NULL) {
-		devtverboseprintk(ioc, printk(MYIOC_s_WARN_FMT "Unable to allocate event request frame!\n",
-				ioc->name));
-		return 0;
-	}
-	memset(evnp, 0, sizeof(*evnp));
+	memset(&evn, 0, sizeof(EventNotification_t));
+	memset(&reply_buf, 0, sizeof(MPIDefaultReply_t));
 
-	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending EventNotification (%d) request %p\n", ioc->name, EvSwitch, evnp));
+	evn.Function = MPI_FUNCTION_EVENT_NOTIFICATION;
+	evn.Switch = EvSwitch;
+	evn.MsgContext = cpu_to_le32(mpt_base_index << 16);
 
-	evnp->Function = MPI_FUNCTION_EVENT_NOTIFICATION;
-	evnp->ChainOffset = 0;
-	evnp->MsgFlags = 0;
-	evnp->Switch = EvSwitch;
-
-	mpt_put_msg_frame(mpt_base_index, ioc, (MPT_FRAME_HDR *)evnp);
+	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "Sending EventNotification (%d) request %p\n",
+	    ioc->name, EvSwitch, &evn));
 
-	return 0;
+	return mpt_handshake_req_reply_wait(ioc, sizeof(EventNotification_t),
+	    (u32*)&evn, sizeof(MPIDefaultReply_t), (u16*)&reply_buf, 30,
+	    sleepFlag);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -5632,35 +5669,61 @@ SendEventAck(MPT_ADAPTER *ioc, EventNoti
  *	-EPERM if not allowed due to ISR context
  *	-EAGAIN if no msg frames currently available
  *	-EFAULT for non-successful reply or no reply (timeout)
- */
+ **/
 int
 mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 {
 	Config_t	*pReq;
+	ConfigReply_t	*pReply;
 	ConfigExtendedPageHeader_t  *pExtHdr = NULL;
 	MPT_FRAME_HDR	*mf;
-	unsigned long	 flags;
-	int		 ii, rc;
+	int		 ii;
 	int		 flagsLength;
-	int		 in_isr;
+	long		 timeout;
+	int		 ret;
+	u8		 page_type, extend_page;
+	unsigned long 	 timeleft;
+	unsigned long	 flags;
+	u8		 issue_hard_reset = 0;
 
-	/*	Prevent calling wait_event() (below), if caller happens
-	 *	to be in ISR context, because that is fatal!
-	 */
-	in_isr = in_interrupt();
-	if (in_isr) {
-		dcprintk(ioc, printk(MYIOC_s_WARN_FMT "Config request not allowed in ISR context!\n",
-				ioc->name));
+	if (in_interrupt())
 		return -EPERM;
+
+	/* don't send a config page during diag reset */
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: busy with host reset\n", ioc->name, __FUNCTION__));
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		return -EBUSY;
+	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+
+	/* don't send if no chance of success */
+	if (!ioc->active ||
+	    mpt_GetIocState(ioc, 1) != MPI_IOC_STATE_OPERATIONAL) {
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: ioc not operational, %d, %xh\n",
+		    ioc->name, __FUNCTION__, ioc->active,
+		    mpt_GetIocState(ioc, 0)));
+		return -EFAULT;
 	}
 
+	mutex_lock(&ioc->mptbase_cmds.mutex);
+
+	/* init the internal cmd struct */
+	memset(ioc->mptbase_cmds.reply, 0 , MPT_DEFAULT_FRAME_SIZE);
+	INITIALIZE_MGMT_STATUS(ioc->mptbase_cmds.status)
+
 	/* Get and Populate a free Frame
 	 */
 	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
-		dcprintk(ioc, printk(MYIOC_s_WARN_FMT "mpt_config: no msg frames!\n",
-				ioc->name));
-		return -EAGAIN;
+		dcprintk(ioc, printk(MYIOC_s_WARN_FMT
+		"mpt_config: no msg frames!\n", ioc->name));
+		ret = -EAGAIN;
+		goto out;
 	}
+
 	pReq = (Config_t *)mf;
 	pReq->Action = pCfg->action;
 	pReq->Reserved = 0;
@@ -5686,7 +5749,9 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 		pReq->ExtPageType = pExtHdr->ExtPageType;
 		pReq->Header.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
 
-		/* Page Length must be treated as a reserved field for the extended header. */
+		/* Page Length must be treated as a reserved field for the
+		 * extended header.
+		 */
 		pReq->Header.PageLength = 0;
 	}
 
@@ -5699,78 +5764,74 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 	else
 		flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
 
-	if ((pCfg->cfghdr.hdr->PageType & MPI_CONFIG_PAGETYPE_MASK) == MPI_CONFIG_PAGETYPE_EXTENDED) {
+	if ((pCfg->cfghdr.hdr->PageType & MPI_CONFIG_PAGETYPE_MASK) ==
+	    MPI_CONFIG_PAGETYPE_EXTENDED) {
 		flagsLength |= pExtHdr->ExtPageLength * 4;
-
-		dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending Config request type %d, page %d and action %d\n",
-			ioc->name, pReq->ExtPageType, pReq->Header.PageNumber, pReq->Action));
+		page_type = pReq->ExtPageType;
+		extend_page = 1;
 	}
 	else {
 		flagsLength |= pCfg->cfghdr.hdr->PageLength * 4;
-
-		dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending Config request type %d, page %d and action %d\n",
-			ioc->name, pReq->Header.PageType, pReq->Header.PageNumber, pReq->Action));
+		page_type = pReq->Header.PageType;
+		extend_page = 0;
 	}
 
-	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, pCfg->physAddr);
-
-	/* Append pCfg pointer to end of mf
-	 */
-	*((void **) (((u8 *) mf) + (ioc->req_sz - sizeof(void *)))) =  (void *) pCfg;
-
-	/* Initalize the timer
-	 */
-	init_timer(&pCfg->timer);
-	pCfg->timer.data = (unsigned long) ioc;
-	pCfg->timer.function = mpt_timer_expired;
-	pCfg->wait_done = 0;
-
-	/* Set the timer; ensure 10 second minimum */
-	if (pCfg->timeout < 10)
-		pCfg->timer.expires = jiffies + HZ*10;
-	else
-		pCfg->timer.expires = jiffies + HZ*pCfg->timeout;
-
-	/* Add to end of Q, set timer and then issue this command */
-	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	list_add_tail(&pCfg->linkage, &ioc->configQ);
-	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
+	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "Sending Config request type %d, page %d and action %d\n",
+	    ioc->name, page_type, pReq->Header.PageNumber, pReq->Action));
 
-	add_timer(&pCfg->timer);
+	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, pCfg->physAddr);
+	timeout = (pCfg->timeout < 15) ? HZ*15 : HZ*pCfg->timeout;
 	mpt_put_msg_frame(mpt_base_index, ioc, mf);
-	wait_event(mpt_waitq, pCfg->wait_done);
-
-	/* mf has been freed - do not access */
-
-	rc = pCfg->status;
-
-	return rc;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mpt_timer_expired - Callback for timer process.
- *	Used only internal config functionality.
- *	@data: Pointer to MPT_SCSI_HOST recast as an unsigned long
- */
-static void
-mpt_timer_expired(unsigned long data)
-{
-	MPT_ADAPTER *ioc = (MPT_ADAPTER *) data;
+	timeleft = wait_for_completion_timeout(&ioc->mptbase_cmds.done, timeout);
+	if (!(ioc->mptbase_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "Failed Sending Config request type %d, page %d and "
+		    "action %d, status %xh, time left %ld\n\n",
+			ioc->name, page_type, pReq->Header.PageNumber,
+			pReq->Action, ioc->mptbase_cmds.status, timeleft));
+		mpt_free_msg_frame(ioc, mf);
+		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out;
+		if (!timeleft)
+			issue_hard_reset = 1;
+		goto out;
+	}
 
-	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_timer_expired! \n", ioc->name));
+	if (!(ioc->mptbase_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
+		ret = -1;
+		goto out;
+	}
+	pReply = (ConfigReply_t	*)ioc->mptbase_cmds.reply;
+	ret = le16_to_cpu(pReply->IOCStatus) & MPI_IOCSTATUS_MASK;
+	if (ret == MPI_IOCSTATUS_SUCCESS) {
+		if (extend_page) {
+			pCfg->cfghdr.ehdr->ExtPageLength =
+			    le16_to_cpu(pReply->ExtPageLength);
+			pCfg->cfghdr.ehdr->ExtPageType =
+			    pReply->ExtPageType;
+		}
+		pCfg->cfghdr.hdr->PageVersion = pReply->Header.PageVersion;
+		pCfg->cfghdr.hdr->PageLength = pReply->Header.PageLength;
+		pCfg->cfghdr.hdr->PageNumber = pReply->Header.PageNumber;
+		pCfg->cfghdr.hdr->PageType = pReply->Header.PageType;
+	}
 
-	/* Perform a FW reload */
-	if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0)
-		printk(MYIOC_s_WARN_FMT "Firmware Reload FAILED!\n", ioc->name);
+	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "IOCStatus=%04xh, IOCLogInfo=%08xh\n",
+	     ioc->name, ret, le32_to_cpu(pReply->IOCLogInfo)));
 
-	/* No more processing.
-	 * Hard reset clean-up will wake up
-	 * process and free all resources.
-	 */
-	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_timer_expired complete!\n", ioc->name));
+ out:
 
-	return;
+	CLEAR_MGMT_STATUS(ioc->mptbase_cmds.status)
+	mutex_unlock(&ioc->mptbase_cmds.mutex);
+	if (issue_hard_reset) {
+		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
+		    ioc->name, __FUNCTION__);
+		if (mpt_SoftResetHandler(ioc, CAN_SLEEP) != 0)
+			mpt_HardResetHandler(ioc, CAN_SLEEP);
+	}
+	return ret;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -5780,45 +5841,36 @@ mpt_timer_expired(unsigned long data)
  *	@reset_phase: Indicates pre- or post-reset functionality
  *
  *	Remark: Frees resources with internally generated commands.
- */
+ **/
 static int
 mpt_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	CONFIGPARMS *pCfg;
-	unsigned long flags;
-
-	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-	    ": IOC %s_reset routed to MPT base driver!\n",
-	    ioc->name, reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
-	    reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
-
-	if (reset_phase == MPT_IOC_SETUP_RESET) {
-		;
-	} else if (reset_phase == MPT_IOC_PRE_RESET) {
-		/* If the internal config Q is not empty -
-		 * delete timer. MF resources will be freed when
-		 * the FIFO's are primed.
-		 */
-		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		list_for_each_entry(pCfg, &ioc->configQ, linkage)
-			del_timer(&pCfg->timer);
-		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-
-	} else {
-		CONFIGPARMS *pNext;
-
-		/* Search the configQ for internal commands.
-		 * Flush the Q, and wake up all suspended threads.
-		 */
-		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		list_for_each_entry_safe(pCfg, pNext, &ioc->configQ, linkage) {
-			list_del(&pCfg->linkage);
-
-			pCfg->status = MPT_CONFIG_ERROR;
-			pCfg->wait_done = 1;
-			wake_up(&mpt_waitq);
+	switch(reset_phase) {
+	case MPT_IOC_SETUP_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __FUNCTION__));
+		ioc->taskmgmt_quiesce_io = 1;
+		break;
+	case MPT_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __FUNCTION__));
+		break;
+	case MPT_IOC_POST_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_POST_RESET\n",  ioc->name, __FUNCTION__));
+/* wake up mptbase_cmds */
+		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->mptbase_cmds.status |= MPT_MGMT_STATUS_DID_IOCRESET;
+			complete(&ioc->mptbase_cmds.done);
+		}
+/* wake up taskmgmt_cmds */
+		if (ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->taskmgmt_cmds.status |= MPT_MGMT_STATUS_DID_IOCRESET;
+			complete(&ioc->taskmgmt_cmds.done);
 		}
-		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
+		break;
+	default:
+		break;
 	}
 
 	return 1;		/* currently means nothing really */
@@ -5826,11 +5878,6 @@ mpt_ioc_reset(MPT_ADAPTER *ioc, int rese
 
 
 #ifdef CONFIG_PROC_FS		/* { */
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *	procfs (%MPT_PROCFS_MPTBASEDIR/...) support stuff...
- */
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	procmpt_create - Create %MPT_PROCFS_MPTBASEDIR entries.
  *
@@ -6135,6 +6182,179 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, 
 /*
  *	Reset Handling
  */
+
+/**
+ *	mpt_set_taskmgmt_in_progress_flag - set flags associated with task managment
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *
+ *	Returns 0 for SUCCESS or -1 if FAILED.
+ *
+ *	If -1 is return, then it was not possible to set the flags
+ **/
+int
+mpt_set_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc)
+{
+	unsigned long	 flags;
+	int		 retval;
+
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress || ioc->taskmgmt_in_progress ||
+	    (ioc->alt_ioc && ioc->alt_ioc->taskmgmt_in_progress)) {
+		retval = -1;
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		goto out;
+	}
+	retval = 0;
+	ioc->taskmgmt_in_progress = 1;
+	ioc->taskmgmt_quiesce_io = 1;
+	if (ioc->alt_ioc) {
+		ioc->alt_ioc->taskmgmt_in_progress = 1;
+		ioc->alt_ioc->taskmgmt_quiesce_io = 1;
+	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+
+ out:
+	return retval;
+}
+
+/**
+ *	mpt_clear_taskmgmt_in_progress_flag - clear flags associated with task managment
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *
+ **/
+void
+mpt_clear_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc)
+{
+	unsigned long	 flags;
+
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	ioc->taskmgmt_in_progress = 0;
+	ioc->taskmgmt_quiesce_io = 0;
+	if (ioc->alt_ioc) {
+		ioc->alt_ioc->taskmgmt_in_progress = 0;
+		ioc->alt_ioc->taskmgmt_quiesce_io = 0;
+	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+}
+
+/**
+ *	mpt_SoftResetHandler - Issues a less expensive reset
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@sleepFlag: Indicates if sleep or schedule must be called.
+
+ *
+ *	Returns 0 for SUCCESS or -1 if FAILED.
+ *
+ *	Message Unit Reset - instructs the IOC to reset the Reply Post and
+ *	Free FIFO's. All the Message Frames on Reply Free FIFO are discarded.
+ *	All posted buffers are freed, and event notification is turned off.
+ *	IOC doesnt reply to any outstanding request. This will transfer IOC
+ *	to READY state.
+ **/
+int
+mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
+{
+	int		 rc;
+	int		 ii;
+	u8		 cb_idx;
+	unsigned long	 flags;
+	u32		 ioc_state;
+	unsigned long	 time_count;
+
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SoftResetHandler Entered!\n", ioc->name));
+
+	ioc_state = mpt_GetIocState(ioc, 0) & MPI_IOC_STATE_MASK;
+	if (ioc_state == MPI_IOC_STATE_FAULT || ioc_state == MPI_IOC_STATE_RESET) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "skipping, either in FAULT or RESET state!\n", ioc->name));
+		return -1;
+	}
+
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		return -1;
+	}
+	ioc->ioc_reset_in_progress = 1;
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+
+	rc = -1;
+
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptResetHandlers[cb_idx])
+			mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
+	}
+
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptResetHandlers[cb_idx])
+			mpt_signal_reset(cb_idx, ioc, MPT_IOC_PRE_RESET);
+	}
+
+	/* Disable reply interrupts (also blocks FreeQ) */
+	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
+	ioc->active = 0;
+	time_count = jiffies;
+	if ((rc = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET,
+	    sleepFlag)) != 0)
+		goto out;
+	ioc_state = mpt_GetIocState(ioc, 0) & MPI_IOC_STATE_MASK;
+	if (ioc_state != MPI_IOC_STATE_READY)
+		goto out;
+
+	for (ii = 0; ii < 5; ii++) {
+		/* Get IOC facts! Allow 5 retries */
+		if ((rc = GetIocFacts(ioc, sleepFlag,
+			    MPT_HOSTEVENT_IOC_RECOVER)) == 0)
+			break;
+		if (sleepFlag == CAN_SLEEP) {
+			msleep(100);
+		} else {
+			mdelay(100);
+		}
+	}
+	if (ii == 5)
+		goto out;
+
+	if ((rc = PrimeIocFifos(ioc)) != 0)
+		goto out;
+
+	if ((rc = SendIocInit(ioc, sleepFlag)) != 0)
+		goto out;
+
+	if ((rc = SendEventNotification(ioc, 1, sleepFlag)) != 0)
+		goto out;
+
+	if (ioc->hard_resets < -1)
+		ioc->hard_resets++;
+
+	/*
+	 * At this point, we know soft reset succeeded.
+	 */
+
+	ioc->active = 1;
+	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
+
+ out:
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	ioc->ioc_reset_in_progress = 0;
+	ioc->taskmgmt_quiesce_io = 0;
+	ioc->taskmgmt_in_progress = 0;
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+
+	if (ioc->active) {	/* otherwise, hard reset coming */
+		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+			if (MptResetHandlers[cb_idx])
+				mpt_signal_reset(cb_idx, ioc, MPT_IOC_POST_RESET);
+		}
+	}
+
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SoftResetHandler: completed (%d seconds): %s\n",
+	    ioc->name, jiffies_to_msecs(jiffies - time_count)/1000,
+	    ((rc == 0) ? "SUCCESS" : "FAILED")));
+
+	return rc;
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_HardResetHandler - Generic reset handler
@@ -6151,12 +6371,14 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, 
  *	FW reload/initialization failed.
  *
  *	Returns 0 for SUCCESS or -1 if FAILED.
- */
+ **/
 int
 mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 {
-	int		 rc;
+	int	 rc;
+	u8	 cb_idx;
 	unsigned long	 flags;
+	unsigned long	 time_count;
 
 	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler Entered!\n", ioc->name));
 #ifdef MFCNT
@@ -6167,56 +6389,60 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 	/* Reset the adapter. Prevent more than 1 call to
 	 * mpt_do_ioc_recovery at any instant in time.
 	 */
-	spin_lock_irqsave(&ioc->diagLock, flags);
-	if ((ioc->diagPending) || (ioc->alt_ioc && ioc->alt_ioc->diagPending)){
-		spin_unlock_irqrestore(&ioc->diagLock, flags);
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 		return 0;
-	} else {
-		ioc->diagPending = 1;
 	}
-	spin_unlock_irqrestore(&ioc->diagLock, flags);
+	ioc->ioc_reset_in_progress = 1;
+	if (ioc->alt_ioc)
+	    ioc->alt_ioc->ioc_reset_in_progress = 1;
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
-	/* FIXME: If do_ioc_recovery fails, repeat....
-	 */
 
 	/* The SCSI driver needs to adjust timeouts on all current
 	 * commands prior to the diagnostic reset being issued.
 	 * Prevents timeouts occurring during a diagnostic reset...very bad.
 	 * For all other protocol drivers, this is a no-op.
 	 */
-	{
-		u8	 cb_idx;
-		int	 r = 0;
-
-		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
-			if (MptResetHandlers[cb_idx]) {
-				dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling IOC reset_setup handler #%d\n",
-						ioc->name, cb_idx));
-				r += mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
-				if (ioc->alt_ioc) {
-					dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling alt-%s setup reset handler #%d\n",
-							ioc->name, ioc->alt_ioc->name, cb_idx));
-					r += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
-				}
-			}
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptResetHandlers[cb_idx]) {
+			mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
+			if (ioc->alt_ioc)
+				mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
 		}
 	}
 
+	time_count = jiffies;
 	if ((rc = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_RECOVER, sleepFlag)) != 0) {
 		printk(MYIOC_s_WARN_FMT "Cannot recover rc = %d!\n", ioc->name, rc);
+	} else {
+		if (ioc->hard_resets < -1)
+			ioc->hard_resets++;
 	}
-	ioc->reload_fw = 0;
-	if (ioc->alt_ioc)
-		ioc->alt_ioc->reload_fw = 0;
 
-	spin_lock_irqsave(&ioc->diagLock, flags);
-	ioc->diagPending = 0;
-	if (ioc->alt_ioc)
-		ioc->alt_ioc->diagPending = 0;
-	spin_unlock_irqrestore(&ioc->diagLock, flags);
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	ioc->ioc_reset_in_progress = 0;
+	ioc->taskmgmt_quiesce_io = 0;
+	ioc->taskmgmt_in_progress = 0;
+	if (ioc->alt_ioc) {
+	    ioc->alt_ioc->ioc_reset_in_progress = 0;
+	    ioc->alt_ioc->taskmgmt_quiesce_io = 0;
+	    ioc->alt_ioc->taskmgmt_in_progress = 0;
+	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler rc = %d!\n", ioc->name, rc));
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptResetHandlers[cb_idx]) {
+			mpt_signal_reset(cb_idx, ioc, MPT_IOC_POST_RESET);
+			if (ioc->alt_ioc)
+				mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_POST_RESET);
+		}
+	}
 
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler: completed (%d seconds): %s\n",
+	    ioc->name, jiffies_to_msecs(jiffies - time_count)/1000,
+	    ((rc == 0) ? "SUCCESS" : "FAILED")));
 	return rc;
 }
 
@@ -6769,8 +6995,6 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 l
 	switch (info) {
 	case 0x00010000:
 		desc = "bug! MID not found";
-		if (ioc->reload_fw == 0)
-			ioc->reload_fw++;
 		break;
 
 	case 0x00020000:
@@ -7378,12 +7602,15 @@ EXPORT_SYMBOL(mpt_verify_adapter);
 EXPORT_SYMBOL(mpt_GetIocState);
 EXPORT_SYMBOL(mpt_print_ioc_summary);
 EXPORT_SYMBOL(mpt_HardResetHandler);
+EXPORT_SYMBOL(mpt_SoftResetHandler);
 EXPORT_SYMBOL(mpt_config);
 EXPORT_SYMBOL(mpt_findImVolumes);
 EXPORT_SYMBOL(mpt_alloc_fw_memory);
 EXPORT_SYMBOL(mpt_free_fw_memory);
 EXPORT_SYMBOL(mptbase_sas_persist_operation);
 EXPORT_SYMBOL(mpt_raid_phys_disk_pg0);
+EXPORT_SYMBOL(mpt_set_taskmgmt_in_progress_flag);
+EXPORT_SYMBOL(mpt_clear_taskmgmt_in_progress_flag);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
@@ -7409,7 +7636,7 @@ fusion_init(void)
 	/*  Register ourselves (mptbase) in order to facilitate
 	 *  EventNotification handling.
 	 */
-	mpt_base_index = mpt_register(mpt_base_reply, MPTBASE_DRIVER);
+	mpt_base_index = mpt_register(mptbase_reply, MPTBASE_DRIVER);
 
 	/* Register for hard reset handling callbacks.
 	 */
--- b/drivers/message/fusion/mptbase.h	2007-09-17 16:34:14.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2007-09-17 15:05:32.000000000 -0600
@@ -86,6 +86,7 @@
 /*
  *  Fusion MPT(linux) driver configurable stuff...
  */
+#define MPT_POLLING_INTERVAL		1000	/* in milliseconds */
 #define MPT_MAX_ADAPTERS		18
 #define MPT_MAX_PROTOCOL_DRIVERS	16
 #define MPT_MAX_BUS			1	/* Do not change */
@@ -368,8 +369,8 @@ typedef struct _VirtTarget {
 	struct scsi_target	*starget;
 	u8			 tflags;
 	u8			 ioc_id;
-	u8			 id;
-	u8			 channel;
+	u8			 id;		/* logical target id */
+	u8			 channel;	/* logical channel number */
 	u8			 minSyncFactor;	/* 0xFF is async */
 	u8			 maxOffset;	/* 0 if async */
 	u8			 maxWidth;	/* 0 if narrow, 1 if wide */
@@ -377,7 +378,7 @@ typedef struct _VirtTarget {
 	u8			 raidVolume;	/* set, if RAID Volume */
 	u8			 type;		/* byte 0 of Inquiry data */
 	u8			 deleted;	/* target in process of being removed */
-	u32			 num_luns;
+	int			 num_luns;
 } VirtTarget;
 
 typedef struct _VirtDevice {
@@ -422,43 +423,30 @@ do { \
 	return len;			\
 } while (0)
 
+#define MPT_MGMT_STATUS_RF_VALID	0x01	/* The Reply Frame is VALID */
+#define MPT_MGMT_STATUS_COMMAND_GOOD	0x02	/* Command Status GOOD */
+#define MPT_MGMT_STATUS_PENDING		0x04	/* command is pending */
+#define MPT_MGMT_STATUS_DID_IOCRESET	0x08	/* IOC Reset occurred on the current*/
+#define MPT_MGMT_STATUS_SENSE_VALID	0x10	/* valid sense info */
+#define MPT_MGMT_STATUS_TIMER_ACTIVE	0x20	/* obsolete */
+#define MPT_MGMT_STATUS_FREE_MF		0x40	/* free the mf from complete routine */
+
+
+#define INITIALIZE_MGMT_STATUS(status) \
+	status = MPT_MGMT_STATUS_PENDING;
+#define CLEAR_MGMT_STATUS(status) \
+	status = 0;
+#define CLEAR_MGMT_PENDING_STATUS(status) \
+	status &= ~MPT_MGMT_STATUS_PENDING;
 
-/*
- *	IOCTL structure and associated defines
- */
-
-#define MPT_IOCTL_STATUS_DID_IOCRESET	0x01	/* IOC Reset occurred on the current*/
-#define MPT_IOCTL_STATUS_RF_VALID	0x02	/* The Reply Frame is VALID */
-#define MPT_IOCTL_STATUS_TIMER_ACTIVE	0x04	/* The timer is running */
-#define MPT_IOCTL_STATUS_SENSE_VALID	0x08	/* Sense data is valid */
-#define MPT_IOCTL_STATUS_COMMAND_GOOD	0x10	/* Command Status GOOD */
-#define MPT_IOCTL_STATUS_TMTIMER_ACTIVE	0x20	/* The TM timer is running */
-#define MPT_IOCTL_STATUS_TM_FAILED	0x40	/* User TM request failed */
-
-#define MPTCTL_RESET_OK			0x01	/* Issue Bus Reset */
-
-typedef struct _MPT_IOCTL {
-	struct _MPT_ADAPTER	*ioc;
-	u8			 ReplyFrame[MPT_DEFAULT_FRAME_SIZE];	/* reply frame data */
-	u8			 sense[MPT_SENSE_BUFFER_ALLOC];
-	int			 wait_done;	/* wake-up value for this ioc */
-	u8			 rsvd;
-	u8			 status;	/* current command status */
-	u8			 reset;		/* 1 if bus reset allowed */
-	u8			 id;		/* target for reset */
-	struct mutex		 ioctl_mutex;
-} MPT_IOCTL;
-
-#define MPT_SAS_MGMT_STATUS_RF_VALID	0x02	/* The Reply Frame is VALID */
-#define MPT_SAS_MGMT_STATUS_COMMAND_GOOD	0x10	/* Command Status GOOD */
-#define MPT_SAS_MGMT_STATUS_TM_FAILED	0x40	/* User TM request failed */
-
-typedef struct _MPT_SAS_MGMT {
+typedef struct _MPT_MGMT {
 	struct mutex		 mutex;
 	struct completion	 done;
 	u8			 reply[MPT_DEFAULT_FRAME_SIZE]; /* reply frame data */
+	u8			 sense[MPT_SENSE_BUFFER_ALLOC];
 	u8			 status;	/* current command status */
-}MPT_SAS_MGMT;
+	int			 completion_code;
+}MPT_MGMT;
 
 /*
  *  Event Structure and define
@@ -580,8 +568,8 @@ typedef struct _MPT_ADAPTER
 	SYSIF_REGS __iomem	*chip;		/* == c8817000 (mmap) */
 	SYSIF_REGS __iomem	*pio_chip;	/* Programmed IO (downloadboot) */
 	u8			 bus_type;
-	u32			 mem_phys;	/* == f4020000 (mmap) */
-	u32			 pio_mem_phys;	/* Programmed IO (downloadboot) */
+	unsigned long		 mem_phys;	/* == f4020000 (mmap) */
+	unsigned long		 pio_mem_phys;	/* Programmed IO (downloadboot) */
 	int			 mem_size;	/* mmap memory size */
 	int			 number_of_buses;
 	int			 devices_per_bus;
@@ -624,29 +612,25 @@ typedef struct _MPT_ADAPTER
 	dma_addr_t		 sense_buf_pool_dma;
 	u32			 sense_buf_low_dma;
 	u8			*HostPageBuffer; /* SAS - host page buffer support */
-	u32			HostPageBuffer_sz;
-	dma_addr_t		HostPageBuffer_dma;
+	u32			 HostPageBuffer_sz;
+	dma_addr_t		 HostPageBuffer_dma;
 	int			 mtrr_reg;
 	struct pci_dev		*pcidev;	/* struct pci_dev pointer */
 	u8			__iomem *memmap;	/* mmap address */
 	struct Scsi_Host	*sh;		/* Scsi Host pointer */
-	SpiCfgData		spi_data;	/* Scsi config. data */
-	RaidCfgData		raid_data;	/* Raid config. data */
-	SasCfgData		sas_data;	/* Sas config. data */
-	FcCfgData		fc_data;	/* Fc config. data */
-	MPT_IOCTL		*ioctl;		/* ioctl data pointer */
+	SpiCfgData		 spi_data;	/* Scsi config. data */
+	RaidCfgData		 raid_data;	/* Raid config. data */
+	SasCfgData		 sas_data;	/* Sas config. data */
+	FcCfgData		 fc_data;	/* Fc config. data */
 	struct proc_dir_entry	*ioc_dentry;
 	struct _MPT_ADAPTER	*alt_ioc;	/* ptr to 929 bound adapter port */
-	spinlock_t		 diagLock;	/* diagnostic reset lock */
-	int			 diagPending;
 	u32			 biosVersion;	/* BIOS version from IO Unit Page 2 */
 	int			 eventTypes;	/* Event logging parameters */
 	int			 eventContext;	/* Next event context */
 	int			 eventLogSize;	/* Max number of cached events */
 	struct _mpt_ioctl_events *events;	/* pointer to event log */
 	u8			*cached_fw;	/* Pointer to FW */
-	dma_addr_t	 	cached_fw_dma;
-	struct list_head	 configQ;	/* linked list of config. requests */
+	dma_addr_t		 cached_fw_dma;
 	int			 hs_reply_idx;
 #ifndef MFCNT
 	u32			 pad0;
@@ -659,9 +643,6 @@ typedef struct _MPT_ADAPTER
 	IOCFactsReply_t		 facts;
 	PortFactsReply_t	 pfacts[2];
 	FCPortPage0_t		 fc_port_page0[2];
-	struct timer_list	 persist_timer;	/* persist table timer */
-	int			 persist_wait_done; /* persist completion flag */
-	u8			 persist_reply_frame[MPT_DEFAULT_FRAME_SIZE]; /* persist reply */
 	LANPage0_t		 lan_cnfg_page0;
 	LANPage1_t		 lan_cnfg_page1;
 
@@ -676,14 +657,10 @@ typedef struct _MPT_ADAPTER
 	int			 aen_event_read_flag; /* flag to indicate event log was read*/
 	u8			 FirstWhoInit;
 	u8			 upload_fw;	/* If set, do a fw upload */
-	u8			 reload_fw;	/* Force a FW Reload on next reset */
 	u8			 NBShiftFactor;  /* NB Shift Factor based on Block Size (Facts)  */
-	u8			 pad1[4];
 	u8			 DoneCtx;
 	u8			 TaskCtx;
 	u8			 InternalCtx;
-	spinlock_t		 initializing_hba_lock;
-	int 	 		 initializing_hba_lock_flag;
 	struct list_head	 list;
 	struct net_device	*netdev;
 	struct list_head	 sas_topology;
@@ -693,9 +670,19 @@ typedef struct _MPT_ADAPTER
 	u8			 sas_discovery_ignore_events;
 	u16			 handle;
 	int			 sas_index; /* index refrencing */
-	MPT_SAS_MGMT		 sas_mgmt;
+	MPT_MGMT		 sas_mgmt;
+	MPT_MGMT		 internal_cmds;
+	MPT_MGMT		 mptbase_cmds; /* for sending config pages */
+	MPT_MGMT		 taskmgmt_cmds;
+	MPT_MGMT		 ioctl_cmds;		/* ioctl data pointer */
+	spinlock_t		 taskmgmt_lock;	/* diagnostic reset lock */
+	int			 taskmgmt_in_progress;
+	u8			 taskmgmt_quiesce_io;
+	u8			 ioc_reset_in_progress;
 	struct work_struct	 sas_persist_task;
-
+	char			 reset_work_q_name[KOBJ_NAME_LEN];
+	struct workqueue_struct *reset_work_q;
+	struct delayed_work	 fault_reset_work;
 	struct work_struct	 fc_setup_reset_work;
 	struct list_head	 fc_rports;
 	struct work_struct	 fc_lsc_work;
@@ -704,6 +691,9 @@ typedef struct _MPT_ADAPTER
 	struct work_struct	 fc_rescan_work;
 	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
 	struct workqueue_struct *fc_rescan_work_q;
+	unsigned long		  hard_resets;		/* driver forced bus resets count */
+	unsigned long		  soft_resets;		/* fw/external bus resets count */
+	unsigned long		  timeouts;		/* cmd timeouts */
 	struct scsi_cmnd	**ScsiLookup;
 	spinlock_t		  scsi_lookup_lock;
 } MPT_ADAPTER;
@@ -767,26 +757,10 @@ typedef struct _mpt_sge {
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
-#define SCSI_STD_SENSE_BYTES    18
-#define SCSI_STD_INQUIRY_BYTES  36
-#define SCSI_MAX_INQUIRY_BYTES  96
-
 /*
  * MPT_SCSI_HOST defines - Used by the IOCTL and the SCSI drivers
  * Private to the driver.
  */
-/* LOCAL structure and fields used when processing
- * internally generated commands. These include:
- * bus scan, dv and config requests.
- */
-typedef struct _MPT_LOCAL_REPLY {
-	ConfigPageHeader_t header;
-	int	completion;
-	u8	sense[SCSI_STD_SENSE_BYTES];
-	u8	scsiStatus;
-	u8	skip;
-	u32	pad;
-} MPT_LOCAL_REPLY;
 
 #define MPT_HOST_BUS_UNKNOWN		(0xFF)
 #define MPT_HOST_TOO_MANY_TM		(0x05)
@@ -802,13 +776,6 @@ typedef struct _MPT_LOCAL_REPLY {
 #define MPT_NVRAM_WIDE_DISABLE		(0x00100000)
 #define MPT_NVRAM_BOOT_CHOICE		(0x00200000)
 
-/* The TM_STATE variable is used to provide strict single threading of TM
- * requests as well as communicate TM error conditions.
- */
-#define TM_STATE_NONE          (0)
-#define	TM_STATE_IN_PROGRESS   (1)
-#define	TM_STATE_ERROR	       (2)
-
 typedef enum {
 	FC,
 	SPI,
@@ -817,63 +784,28 @@ typedef enum {
 
 typedef struct _MPT_SCSI_HOST {
 	MPT_ADAPTER		 *ioc;
-	int			  port;
-	u32			  pad0;
-	MPT_LOCAL_REPLY		 *pLocal;		/* used for internal commands */
-	struct timer_list	  timer;
-		/* Pool of memory for holding SCpnts before doing
-		 * OS callbacks. freeQ is the free pool.
-		 */
-	u8			  tmPending;
-	u8			  resetPending;
-	u8			  negoNvram;		/* DV disabled, nego NVRAM */
-	u8			  pad1;
-	u8                        tmState;
-	u8			  rsvd[2];
-	MPT_FRAME_HDR		 *cmdPtr;		/* Ptr to nonOS request */
-	struct scsi_cmnd	 *abortSCpnt;
-	MPT_LOCAL_REPLY		  localReply;		/* internal cmd reply struct */
-	unsigned long		  hard_resets;		/* driver forced bus resets count */
-	unsigned long		  soft_resets;		/* fw/external bus resets count */
-	unsigned long		  timeouts;		/* cmd timeouts */
 	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];
 	char 			  *info_kbuf;
-	wait_queue_head_t	  scandv_waitq;
-	int			  scandv_wait_done;
 	long			  last_queue_full;
-	u16			  tm_iocstatus;
 	u16			  spi_pending;
 	struct list_head	  target_reset_list;
 } MPT_SCSI_HOST;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
- *	More Dynamic Multi-Pathing stuff...
- */
-
-/* Forward decl, a strange C thing, to prevent gcc compiler warnings */
-struct scsi_cmnd;
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
  * Generic structure passed to the base mpt_config function.
  */
 typedef struct _x_config_parms {
-	struct list_head	 linkage;	/* linked list */
-	struct timer_list	 timer;		/* timer function for this request  */
 	union {
 		ConfigExtendedPageHeader_t	*ehdr;
 		ConfigPageHeader_t	*hdr;
 	} cfghdr;
 	dma_addr_t		 physAddr;
-	int			 wait_done;	/* wait for this request */
 	u32			 pageAddr;	/* properly formatted */
+	u16			 status;
 	u8			 action;
 	u8			 dir;
 	u8			 timeout;	/* seconds */
-	u8			 pad1;
-	u16			 status;
-	u16			 pad2;
 } CONFIGPARMS;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -905,13 +837,17 @@ extern int	 mpt_verify_adapter(int iocid
 extern u32	 mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);
 extern void	 mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buf, int *size, int len, int showlan);
 extern int	 mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
+extern int	 mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
 extern int	 mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *cfg);
-extern void	 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size);
+extern int	 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size);
 extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
 extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
 extern int	 mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num, pRaidPhysDiskPage0_t phys_disk);
 
+extern int	 mpt_set_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc);
+extern void	 mpt_clear_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc);
+
 /*
  *  Public data decl's...
  */
