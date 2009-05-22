From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 5/24] mpt fusion: [2.6.30-rc6] config path optimized, completion queue is used
Date: Fri, 22 May 2009 16:12:50 +0530
Message-ID: <20090522104250.GG16245@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:37807 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbZEVLDy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 07:03:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


1) 	Previously we had mutliple #defines to use same values.
	Now those #defines are optimized.
	MPT_IOCTL_STATUS_* is removed and  MPT_MGMT_STATUS_* are new 
	#defines.
2.)	config path is optimized.
	Instead of wait Queue and timer, using completion Q.
3.)	mpt_timer_expired is not used. (For readability of patche this function
	deletion is in next patch )
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 0d2fb0e..0d3fc0a 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -146,7 +146,6 @@ static MPT_EVHANDLER		 MptEvHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 static MPT_RESETHANDLER		 MptResetHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 static struct mpt_pci_driver 	*MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 
-static DECLARE_WAIT_QUEUE_HEAD(mpt_waitq);
 
 /*
  *  Driver Callback Index's
@@ -159,7 +158,8 @@ static u8 last_drv_idx;
  *  Forward protos...
  */
 static irqreturn_t mpt_interrupt(int irq, void *bus_id);
-static int	mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);
+static int	mptbase_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
+		MPT_FRAME_HDR *reply);
 static int	mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes,
 			u32 *req, int replyBytes, u16 *u16reply, int maxwait,
 			int sleepFlag);
@@ -190,7 +190,6 @@ static int	mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum);
 static int	mpt_readScsiDevicePageHeaders(MPT_ADAPTER *ioc, int portnum);
 static void 	mpt_read_ioc_pg_1(MPT_ADAPTER *ioc);
 static void 	mpt_read_ioc_pg_4(MPT_ADAPTER *ioc);
-static void	mpt_timer_expired(unsigned long data);
 static void	mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc);
 static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch,
 	int sleepFlag);
@@ -559,9 +558,9 @@ mpt_interrupt(int irq, void *bus_id)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_base_reply - MPT base driver's callback routine
+ *	mptbase_reply - MPT base driver's callback routine
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@mf: Pointer to original MPT request frame
+ *	@req: Pointer to original MPT request frame
  *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
  *
  *	MPT base driver's callback routine; all base driver
@@ -572,122 +571,49 @@ mpt_interrupt(int irq, void *bus_id)
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
-
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
 		}
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
@@ -1849,6 +1775,9 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ioc->diagLock);
 	spin_lock_init(&ioc->initializing_hba_lock);
 
+	mutex_init(&ioc->mptbase_cmds.mutex);
+	init_completion(&ioc->mptbase_cmds.done);
+
 	/* Initialize the event logging.
 	 */
 	ioc->eventTypes = 0;	/* None */
@@ -1866,10 +1795,6 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	memset(&ioc->spi_data, 0, sizeof(SpiCfgData));
 
-	/* Initialize the running configQ head.
-	 */
-	INIT_LIST_HEAD(&ioc->configQ);
-
 	/* Initialize the fc rport list head.
 	 */
 	INIT_LIST_HEAD(&ioc->fc_rports);
@@ -5013,7 +4938,14 @@ mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
 	SasIoUnitControlReply_t		*sasIoUnitCntrReply;
 	MPT_FRAME_HDR			*mf = NULL;
 	MPIHeader_t			*mpi_hdr;
+	int				ret = 0;
+	unsigned long 	 		timeleft;
+
+	mutex_lock(&ioc->mptbase_cmds.mutex);
 
+	/* init the internal cmd struct */
+	memset(ioc->mptbase_cmds.reply, 0 , MPT_DEFAULT_FRAME_SIZE);
+	INITIALIZE_MGMT_STATUS(ioc->mptbase_cmds.status)
 
 	/* insure garbage is not sent to fw */
 	switch(persist_opcode) {
@@ -5023,17 +4955,19 @@ mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
 		break;
 
 	default:
-		return -1;
-		break;
+		ret = -1;
+		goto out;
 	}
 
-	printk("%s: persist_opcode=%x\n",__func__, persist_opcode);
+	printk(KERN_DEBUG  "%s: persist_opcode=%x\n",
+		__func__, persist_opcode);
 
 	/* Get a MF for this command.
 	 */
 	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
-		printk("%s: no msg frames!\n",__func__);
-		return -1;
+		printk(KERN_DEBUG "%s: no msg frames!\n", __func__);
+		ret = -1;
+		goto out;
         }
 
 	mpi_hdr = (MPIHeader_t *) mf;
@@ -5043,27 +4977,42 @@ mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
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
+		printk(KERN_DEBUG "%s: failed\n", __func__);
+		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out;
+		if (!timeleft) {
+			printk(KERN_DEBUG "%s: Issuing Reset from %s!!\n",
+			    ioc->name, __func__);
+			mpt_HardResetHandler(ioc, CAN_SLEEP);
+			mpt_free_msg_frame(ioc, mf);
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
-		    __func__,
-		    sasIoUnitCntrReply->IOCStatus,
+		printk(KERN_DEBUG "%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
+		    __func__, sasIoUnitCntrReply->IOCStatus,
 		    sasIoUnitCntrReply->IOCLogInfo);
-		return -1;
-	}
+		printk(KERN_DEBUG "%s: failed\n", __func__);
+		ret = -1;
+	} else
+		printk(KERN_DEBUG "%s: success\n", __func__);
+ out:
 
-	printk("%s: success\n",__func__);
-	return 0;
+	CLEAR_MGMT_STATUS(ioc->mptbase_cmds.status)
+	mutex_unlock(&ioc->mptbase_cmds.mutex);
+	return ret;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -6066,7 +6015,7 @@ SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp)
 
 	if ((pAck = (EventAck_t *) mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
-		    ioc->name,__func__));
+		    ioc->name, __func__));
 		return -1;
 	}
 
@@ -6103,12 +6052,18 @@ int
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
+	long		 timeout;
+	int		 ret;
+	u8		 page_type = 0, extend_page;
+	unsigned long 	 timeleft;
 	int		 in_isr;
+	u8		 issue_hard_reset = 0;
+	u8		 retry_count = 0;
 
 	/*	Prevent calling wait_event() (below), if caller happens
 	 *	to be in ISR context, because that is fatal!
@@ -6120,13 +6075,31 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 		return -EPERM;
 	}
 
+	/* don't send if no chance of success */
+	if (!ioc->active ||
+	    mpt_GetIocState(ioc, 1) != MPI_IOC_STATE_OPERATIONAL) {
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: ioc not operational, %d, %xh\n",
+		    ioc->name, __func__, ioc->active,
+		    mpt_GetIocState(ioc, 0)));
+		return -EFAULT;
+	}
+
+ retry_config:
+	mutex_lock(&ioc->mptbase_cmds.mutex);
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
@@ -6152,7 +6125,9 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 		pReq->ExtPageType = pExtHdr->ExtPageType;
 		pReq->Header.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
 
-		/* Page Length must be treated as a reserved field for the extended header. */
+		/* Page Length must be treated as a reserved field for the
+		 * extended header.
+		 */
 		pReq->Header.PageLength = 0;
 	}
 
@@ -6165,52 +6140,91 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 	else
 		flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
 
-	if ((pCfg->cfghdr.hdr->PageType & MPI_CONFIG_PAGETYPE_MASK) == MPI_CONFIG_PAGETYPE_EXTENDED) {
+	if ((pCfg->cfghdr.hdr->PageType & MPI_CONFIG_PAGETYPE_MASK) ==
+	    MPI_CONFIG_PAGETYPE_EXTENDED) {
 		flagsLength |= pExtHdr->ExtPageLength * 4;
-
-		dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending Config request type %d, page %d and action %d\n",
-			ioc->name, pReq->ExtPageType, pReq->Header.PageNumber, pReq->Action));
-	}
-	else {
+		page_type = pReq->ExtPageType;
+		extend_page = 1;
+	} else {
 		flagsLength |= pCfg->cfghdr.hdr->PageLength * 4;
-
-		dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending Config request type %d, page %d and action %d\n",
-			ioc->name, pReq->Header.PageType, pReq->Header.PageNumber, pReq->Action));
+		page_type = pReq->Header.PageType;
+		extend_page = 0;
 	}
 
+	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "Sending Config request type 0x%x, page 0x%x and action %d\n",
+	    ioc->name, page_type, pReq->Header.PageNumber, pReq->Action));
+
 	ioc->add_sge((char *)&pReq->PageBufferSGE, flagsLength, pCfg->physAddr);
+	timeout = (pCfg->timeout < 15) ? HZ*15 : HZ*pCfg->timeout;
+	mpt_put_msg_frame(mpt_base_index, ioc, mf);
+	timeleft = wait_for_completion_timeout(&ioc->mptbase_cmds.done,
+		timeout);
+	if (!(ioc->mptbase_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "Failed Sending Config request type 0x%x, page 0x%x,"
+		    " action %d, status %xh, time left %ld\n\n",
+			ioc->name, page_type, pReq->Header.PageNumber,
+			pReq->Action, ioc->mptbase_cmds.status, timeleft));
+		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out;
+		if (!timeleft)
+			issue_hard_reset = 1;
+		goto out;
+	}
 
-	/* Append pCfg pointer to end of mf
-	 */
-	*((void **) (((u8 *) mf) + (ioc->req_sz - sizeof(void *)))) =  (void *) pCfg;
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
 
-	/* Initalize the timer
-	 */
-	init_timer_on_stack(&pCfg->timer);
-	pCfg->timer.data = (unsigned long) ioc;
-	pCfg->timer.function = mpt_timer_expired;
-	pCfg->wait_done = 0;
-
-	/* Set the timer; ensure 10 second minimum */
-	if (pCfg->timeout < 10)
-		pCfg->timer.expires = jiffies + HZ*10;
-	else
-		pCfg->timer.expires = jiffies + HZ*pCfg->timeout;
+	}
 
-	/* Add to end of Q, set timer and then issue this command */
-	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	list_add_tail(&pCfg->linkage, &ioc->configQ);
-	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
+	if (retry_count)
+		printk(MYIOC_s_INFO_FMT "Retry completed "
+		    "ret=0x%x timeleft=%ld\n",
+		    ioc->name, ret, timeleft);
 
-	add_timer(&pCfg->timer);
-	mpt_put_msg_frame(mpt_base_index, ioc, mf);
-	wait_event(mpt_waitq, pCfg->wait_done);
+	dcprintk(ioc, printk(KERN_DEBUG "IOCStatus=%04xh, IOCLogInfo=%08xh\n",
+	     ret, le32_to_cpu(pReply->IOCLogInfo)));
 
-	/* mf has been freed - do not access */
+out:
 
-	rc = pCfg->status;
+	CLEAR_MGMT_STATUS(ioc->mptbase_cmds.status)
+	mutex_unlock(&ioc->mptbase_cmds.mutex);
+	if (issue_hard_reset) {
+		issue_hard_reset = 0;
+		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
+		    ioc->name, __func__);
+		mpt_HardResetHandler(ioc, CAN_SLEEP);
+		mpt_free_msg_frame(ioc, mf);
+		/* attempt one retry for a timed out command */
+		if (!retry_count) {
+			printk(MYIOC_s_INFO_FMT
+			    "Attempting Retry Config request"
+			    " type 0x%x, page 0x%x,"
+			    " action %d\n", ioc->name, page_type,
+			    pCfg->cfghdr.hdr->PageNumber, pCfg->action);
+			retry_count++;
+			goto retry_config;
+		}
+	}
+	return ret;
 
-	return rc;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -6250,41 +6264,27 @@ mpt_timer_expired(unsigned long data)
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
+	switch (reset_phase) {
+	case MPT_IOC_SETUP_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __func__));
+		break;
+	case MPT_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __func__));
+		break;
+	case MPT_IOC_POST_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_POST_RESET\n",  ioc->name, __func__));
+/* wake up mptbase_cmds */
+		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->mptbase_cmds.status |=
+			    MPT_MGMT_STATUS_DID_IOCRESET;
+			complete(&ioc->mptbase_cmds.done);
 		}
-		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
+		break;
+	default:
+		break;
 	}
 
 	return 1;		/* currently means nothing really */
@@ -7901,7 +7901,7 @@ fusion_init(void)
 	/*  Register ourselves (mptbase) in order to facilitate
 	 *  EventNotification handling.
 	 */
-	mpt_base_index = mpt_register(mpt_base_reply, MPTBASE_DRIVER);
+	mpt_base_index = mpt_register(mptbase_reply, MPTBASE_DRIVER);
 
 	/* Register for hard reset handling callbacks.
 	 */
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 8cd0a16..41273ff 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -432,14 +432,6 @@ do { \
  *	IOCTL structure and associated defines
  */
 
-#define MPT_IOCTL_STATUS_DID_IOCRESET	0x01	/* IOC Reset occurred on the current*/
-#define MPT_IOCTL_STATUS_RF_VALID	0x02	/* The Reply Frame is VALID */
-#define MPT_IOCTL_STATUS_TIMER_ACTIVE	0x04	/* The timer is running */
-#define MPT_IOCTL_STATUS_SENSE_VALID	0x08	/* Sense data is valid */
-#define MPT_IOCTL_STATUS_COMMAND_GOOD	0x10	/* Command Status GOOD */
-#define MPT_IOCTL_STATUS_TMTIMER_ACTIVE	0x20	/* The TM timer is running */
-#define MPT_IOCTL_STATUS_TM_FAILED	0x40	/* User TM request failed */
-
 #define MPTCTL_RESET_OK			0x01	/* Issue Bus Reset */
 
 typedef struct _MPT_IOCTL {
@@ -454,16 +446,27 @@ typedef struct _MPT_IOCTL {
 	struct mutex		 ioctl_mutex;
 } MPT_IOCTL;
 
-#define MPT_SAS_MGMT_STATUS_RF_VALID	0x02	/* The Reply Frame is VALID */
-#define MPT_SAS_MGMT_STATUS_COMMAND_GOOD	0x10	/* Command Status GOOD */
-#define MPT_SAS_MGMT_STATUS_TM_FAILED	0x40	/* User TM request failed */
-
-typedef struct _MPT_SAS_MGMT {
+#define MPT_MGMT_STATUS_RF_VALID	0x01	/* The Reply Frame is VALID */
+#define MPT_MGMT_STATUS_COMMAND_GOOD	0x02	/* Command Status GOOD */
+#define MPT_MGMT_STATUS_PENDING		0x04	/* command is pending */
+#define MPT_MGMT_STATUS_DID_IOCRESET	0x08	/* IOC Reset occurred
+						   on the current*/
+#define MPT_MGMT_STATUS_SENSE_VALID	0x10	/* valid sense info */
+#define MPT_MGMT_STATUS_TIMER_ACTIVE	0x20	/* obsolete */
+#define MPT_MGMT_STATUS_FREE_MF		0x40	/* free the mf from
+						   complete routine */
+
+#define INITIALIZE_MGMT_STATUS(status) \
+	status = MPT_MGMT_STATUS_PENDING;
+#define CLEAR_MGMT_STATUS(status) \
+	status = 0;
+
+typedef struct _MPT_MGMT {
 	struct mutex		 mutex;
 	struct completion	 done;
 	u8			 reply[MPT_DEFAULT_FRAME_SIZE]; /* reply frame data */
 	u8			 status;	/* current command status */
-}MPT_SAS_MGMT;
+} MPT_MGMT;
 
 /*
  *  Event Structure and define
@@ -661,7 +664,6 @@ typedef struct _MPT_ADAPTER
 	struct _mpt_ioctl_events *events;	/* pointer to event log */
 	u8			*cached_fw;	/* Pointer to FW */
 	dma_addr_t	 	cached_fw_dma;
-	struct list_head	 configQ;	/* linked list of config. requests */
 	int			 hs_reply_idx;
 #ifndef MFCNT
 	u32			 pad0;
@@ -674,9 +676,6 @@ typedef struct _MPT_ADAPTER
 	IOCFactsReply_t		 facts;
 	PortFactsReply_t	 pfacts[2];
 	FCPortPage0_t		 fc_port_page0[2];
-	struct timer_list	 persist_timer;	/* persist table timer */
-	int			 persist_wait_done; /* persist completion flag */
-	u8			 persist_reply_frame[MPT_DEFAULT_FRAME_SIZE]; /* persist reply */
 	LANPage0_t		 lan_cnfg_page0;
 	LANPage1_t		 lan_cnfg_page1;
 
@@ -708,7 +707,8 @@ typedef struct _MPT_ADAPTER
 	u8			 sas_discovery_ignore_events;
 	u8			 sas_discovery_quiesce_io;
 	int			 sas_index; /* index refrencing */
-	MPT_SAS_MGMT		 sas_mgmt;
+	MPT_MGMT		 sas_mgmt;
+	MPT_MGMT		 mptbase_cmds; /* for sending config pages */
 	struct work_struct	 sas_persist_task;
 
 	struct work_struct	 fc_setup_reset_work;
@@ -884,21 +884,16 @@ struct scsi_cmnd;
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
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index bece386..6ffb982 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -221,7 +221,7 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 			dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_reply() NULL Reply "
 				"Function=%x!\n", ioc->name, cmd));
 
-			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
+			ioc->ioctl->status |= MPT_MGMT_STATUS_COMMAND_GOOD;
 			ioc->ioctl->reset &= ~MPTCTL_RESET_OK;
 
 			/* We are done, issue wake up
@@ -237,14 +237,14 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 		 */
 		memcpy(ioc->ioctl->ReplyFrame, reply,
 			min(ioc->reply_sz, 4*reply->u.reply.MsgLength));
-		ioc->ioctl->status |= MPT_IOCTL_STATUS_RF_VALID;
+		ioc->ioctl->status |= MPT_MGMT_STATUS_RF_VALID;
 
 		/* Set the command status to GOOD if IOC Status is GOOD
 		 * OR if SCSI I/O cmd and data underrun or recovered error.
 		 */
 		iocStatus = le16_to_cpu(reply->u.reply.IOCStatus) & MPI_IOCSTATUS_MASK;
 		if (iocStatus  == MPI_IOCSTATUS_SUCCESS)
-			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
+			ioc->ioctl->status |= MPT_MGMT_STATUS_COMMAND_GOOD;
 
 		if (iocStatus || reply->u.reply.IOCLogInfo)
 			dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\tiocstatus (0x%04X), "
@@ -268,7 +268,7 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 
 			if ((iocStatus == MPI_IOCSTATUS_SCSI_DATA_UNDERRUN) ||
 			(iocStatus == MPI_IOCSTATUS_SCSI_RECOVERED_ERROR)) {
-			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
+			ioc->ioctl->status |= MPT_MGMT_STATUS_COMMAND_GOOD;
 			}
 		}
 
@@ -284,7 +284,7 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 			    ((u8 *)ioc->sense_buf_pool +
 			     (req_index * MPT_SENSE_BUFFER_ALLOC));
 			memcpy(ioc->ioctl->sense, sense_data, sz);
-			ioc->ioctl->status |= MPT_IOCTL_STATUS_SENSE_VALID;
+			ioc->ioctl->status |= MPT_MGMT_STATUS_SENSE_VALID;
 		}
 
 		if (cmd == MPI_FUNCTION_SCSI_TASK_MGMT)
@@ -483,10 +483,10 @@ mptctl_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 
 	switch(reset_phase) {
 	case MPT_IOC_SETUP_RESET:
-		ioctl->status |= MPT_IOCTL_STATUS_DID_IOCRESET;
+		ioctl->status |= MPT_MGMT_STATUS_DID_IOCRESET;
 		break;
 	case MPT_IOC_POST_RESET:
-		ioctl->status &= ~MPT_IOCTL_STATUS_DID_IOCRESET;
+		ioctl->status &= ~MPT_MGMT_STATUS_DID_IOCRESET;
 		break;
 	case MPT_IOC_PRE_RESET:
 	default:
@@ -1791,7 +1791,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 			"No memory available during driver init.\n",
 				__FILE__, __LINE__);
 		return -ENOMEM;
-	} else if (ioc->ioctl->status & MPT_IOCTL_STATUS_DID_IOCRESET) {
+	} else if (ioc->ioctl->status & MPT_MGMT_STATUS_DID_IOCRESET) {
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_do_mpt_command - "
 			"Busy with IOC Reset \n", __FILE__, __LINE__);
 		return -EBUSY;
@@ -2231,7 +2231,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 	/* If a valid reply frame, copy to the user.
 	 * Offset 2: reply length in U32's
 	 */
-	if (ioc->ioctl->status & MPT_IOCTL_STATUS_RF_VALID) {
+	if (ioc->ioctl->status & MPT_MGMT_STATUS_RF_VALID) {
 		if (karg.maxReplyBytes < ioc->reply_sz) {
 			 sz = min(karg.maxReplyBytes, 4*ioc->ioctl->ReplyFrame[2]);
 		} else {
@@ -2253,7 +2253,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 
 	/* If valid sense data, copy to user.
 	 */
-	if (ioc->ioctl->status & MPT_IOCTL_STATUS_SENSE_VALID) {
+	if (ioc->ioctl->status & MPT_MGMT_STATUS_SENSE_VALID) {
 		sz = min(karg.maxSenseBytes, MPT_SENSE_BUFFER_SIZE);
 		if (sz > 0) {
 			if (copy_to_user(karg.senseDataPtr, ioc->ioctl->sense, sz)) {
@@ -2270,7 +2270,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 	/* If the overall status is _GOOD and data in, copy data
 	 * to user.
 	 */
-	if ((ioc->ioctl->status & MPT_IOCTL_STATUS_COMMAND_GOOD) &&
+	if ((ioc->ioctl->status & MPT_MGMT_STATUS_COMMAND_GOOD) &&
 				(karg.dataInSize > 0) && (bufIn.kptr)) {
 
 		if (copy_to_user(karg.dataInBufPtr,
@@ -2285,9 +2285,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 
 done_free_mem:
 
-	ioc->ioctl->status &= ~(MPT_IOCTL_STATUS_COMMAND_GOOD |
-		MPT_IOCTL_STATUS_SENSE_VALID |
-		MPT_IOCTL_STATUS_RF_VALID );
+	ioc->ioctl->status &= ~(MPT_MGMT_STATUS_COMMAND_GOOD |
+		MPT_MGMT_STATUS_SENSE_VALID |
+		MPT_MGMT_STATUS_RF_VALID );
 
 	/* Free the allocated memory.
 	 */
@@ -2527,7 +2527,7 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	 *   bays have drives in them
 	 * pbuf[3] = Checksum (0x100 = (byte0 + byte2 + byte3)
 	 */
-	if (ioc->ioctl->status & MPT_IOCTL_STATUS_RF_VALID)
+	if (ioc->ioctl->status & MPT_MGMT_STATUS_RF_VALID)
 		karg.rsvd = *(u32 *)pbuf;
 
  out:
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 40dbaaa..dc23adf 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1122,9 +1122,9 @@ static int mptsas_get_linkerrors(struct sas_phy *phy)
 static int mptsas_mgmt_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
 		MPT_FRAME_HDR *reply)
 {
-	ioc->sas_mgmt.status |= MPT_SAS_MGMT_STATUS_COMMAND_GOOD;
+	ioc->sas_mgmt.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
 	if (reply != NULL) {
-		ioc->sas_mgmt.status |= MPT_SAS_MGMT_STATUS_RF_VALID;
+		ioc->sas_mgmt.status |= MPT_MGMT_STATUS_RF_VALID;
 		memcpy(ioc->sas_mgmt.reply, reply,
 		    min(ioc->reply_sz, 4 * reply->u.reply.MsgLength));
 	}
@@ -1182,7 +1182,7 @@ static int mptsas_phy_reset(struct sas_phy *phy, int hard_reset)
 
 	/* a reply frame is expected */
 	if ((ioc->sas_mgmt.status &
-	    MPT_IOCTL_STATUS_RF_VALID) == 0) {
+	    MPT_MGMT_STATUS_RF_VALID) == 0) {
 		error = -ENXIO;
 		goto out_unlock;
 	}
@@ -1359,7 +1359,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 	mf = NULL;
 
-	if (ioc->sas_mgmt.status & MPT_IOCTL_STATUS_RF_VALID) {
+	if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_RF_VALID) {
 		SmpPassthroughReply_t *smprep;
 
 		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
