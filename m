From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] switch fusion to use <linux/list.h> everywhere
Date: Mon, 6 Sep 2004 12:54:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040906105436.GA18139@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:22912 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267685AbUIFKyl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 06:54:41 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org


--- 1.31/drivers/message/fusion/mptbase.c	2004-08-27 17:36:38 +02:00
+++ edited/drivers/message/fusion/mptbase.c	2004-09-06 12:46:20 +02:00
@@ -437,7 +437,7 @@
 
 			/*  Put Request back on FreeQ!  */
 			spin_lock_irqsave(&ioc->FreeQlock, flags);
-			Q_ADD_TAIL(&ioc->FreeQ, &mf->u.frame.linkage, MPT_FRAME_HDR);
+			list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);
 #ifdef MFCNT
 			ioc->mfcnt--;
 #endif
@@ -533,7 +533,7 @@
 			del_timer(&pCfg->timer);
 
 			spin_lock_irqsave(&ioc->FreeQlock, flags);
-			Q_DEL_ITEM(&pCfg->linkage);
+			list_del(&pCfg->linkage);
 			spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 			/*
@@ -819,11 +819,12 @@
 		return NULL;
 
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	if (! Q_IS_EMPTY(&ioc->FreeQ)) {
+	if (!list_empty(&ioc->FreeQ)) {
 		int req_offset;
 
-		mf = ioc->FreeQ.head;
-		Q_DEL_ITEM(&mf->u.frame.linkage);
+		mf = list_entry(ioc->FreeQ.next, MPT_FRAME_HDR,
+				u.frame.linkage.list);
+		list_del(&mf->u.frame.linkage.list);
 		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;	/* byte */
 		req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
 								/* u16! */
@@ -919,7 +920,7 @@
 
 	/*  Put Request back on FreeQ!  */
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	Q_ADD_TAIL(&ioc->FreeQ, &mf->u.frame.linkage, MPT_FRAME_HDR);
+	list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);
 #ifdef MFCNT
 	ioc->mfcnt--;
 #endif
@@ -1198,7 +1199,7 @@
 
 	/* Initialize the running configQ head.
 	 */
-	Q_INIT(&ioc->configQ, Q_ITEM);
+	INIT_LIST_HEAD(&ioc->configQ);
 
 	/* Find lookup slot. */
 	INIT_LIST_HEAD(&ioc->list);
@@ -3592,14 +3593,14 @@
 		/* Initialize the free chain Q.
 	 	*/
 
-		Q_INIT(&ioc->FreeChainQ, MPT_FRAME_HDR);
+		INIT_LIST_HEAD(&ioc->FreeChainQ);
 
 		/* Post the chain buffers to the FreeChainQ.
 	 	*/
 		mem = (u8 *)ioc->ChainBuffer;
 		for (i=0; i < num_chain; i++) {
 			mf = (MPT_FRAME_HDR *) mem;
-			Q_ADD_TAIL(&ioc->FreeChainQ.head, &mf->u.frame.linkage, MPT_FRAME_HDR);
+			list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeChainQ);
 			mem += ioc->req_sz;
 		}
 
@@ -3609,12 +3610,13 @@
 		mem = (u8 *) ioc->req_frames;
 
 		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		Q_INIT(&ioc->FreeQ, MPT_FRAME_HDR);
+		INIT_LIST_HEAD(&ioc->FreeQ);
 		for (i = 0; i < ioc->req_depth; i++) {
 			mf = (MPT_FRAME_HDR *) mem;
 
 			/*  Queue REQUESTs *internally*!  */
-			Q_ADD_TAIL(&ioc->FreeQ.head, &mf->u.frame.linkage, MPT_FRAME_HDR);
+			list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);
+
 			mem += ioc->req_sz;
 		}
 		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
@@ -4903,7 +4905,7 @@
 
 	/* Add to end of Q, set timer and then issue this command */
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	Q_ADD_TAIL(&ioc->configQ.head, &pCfg->linkage, Q_ITEM);
+	list_add_tail(&pCfg->linkage, &ioc->configQ);
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 	add_timer(&pCfg->timer);
@@ -5014,7 +5016,7 @@
 
 	/* Add to end of Q, set timer and then issue this command */
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	Q_ADD_TAIL(&ioc->configQ.head, &pCfg->linkage, Q_ITEM);
+	list_add_tail(&pCfg->linkage, &ioc->configQ);
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 	add_timer(&pCfg->timer);
@@ -5081,13 +5083,8 @@
 		 * the FIFO's are primed.
 		 */
 		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		if (! Q_IS_EMPTY(&ioc->configQ)){
-			pCfg = (CONFIGPARMS *)ioc->configQ.head;
-			do {
-				del_timer(&pCfg->timer);
-				pCfg = (CONFIGPARMS *) (pCfg->linkage.forw);
-			} while (pCfg != (CONFIGPARMS *)&ioc->configQ);
-		}
+		list_for_each_entry(pCfg, &ioc->configQ, linkage)
+			del_timer(&pCfg->timer);
 		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 	} else {
@@ -5097,19 +5094,12 @@
 		 * Flush the Q, and wake up all suspended threads.
 		 */
 		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		if (! Q_IS_EMPTY(&ioc->configQ)){
-			pCfg = (CONFIGPARMS *)ioc->configQ.head;
-			do {
-				pNext = (CONFIGPARMS *) pCfg->linkage.forw;
-
-				Q_DEL_ITEM(&pCfg->linkage);
-
-				pCfg->status = MPT_CONFIG_ERROR;
-				pCfg->wait_done = 1;
-				wake_up(&mpt_waitq);
+		list_for_each_entry_safe(pCfg, pNext, &ioc->configQ, linkage) {
+			list_del(&pCfg->linkage);
 
-				pCfg = pNext;
-			} while (pCfg != (CONFIGPARMS *)&ioc->configQ);
+			pCfg->status = MPT_CONFIG_ERROR;
+			pCfg->wait_done = 1;
+			wake_up(&mpt_waitq);
 		}
 		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 	}
--- 1.26/drivers/message/fusion/mptbase.h	2004-08-27 00:41:13 +02:00
+++ edited/drivers/message/fusion/mptbase.h	2004-09-06 12:45:44 +02:00
@@ -226,8 +226,7 @@
 
 typedef union _MPT_FRAME_TRACKER {
 	struct {
-		struct _MPT_FRAME_HDR	*forw;
-		struct _MPT_FRAME_HDR	*back;
+		struct list_head	list;
 		u32			 arg1;
 		u32			 pad;
 		void			*argp1;
@@ -290,15 +289,6 @@
 
 #define MPT_REQ_MSGFLAGS_DROPME		0x80
 
-/* Used for tracking the free request frames
- * and free reply frames.
- */
-typedef struct _MPT_Q_TRACKER {
-	MPT_FRAME_HDR	*head;
-	MPT_FRAME_HDR	*tail;
-} MPT_Q_TRACKER;
-
-
 typedef struct _MPT_SGL_HDR {
 	SGESimple32_t	 sge[1];
 } MPT_SGL_HDR;
@@ -308,16 +298,6 @@
 } MPT_SGL64_HDR;
 
 
-typedef struct _Q_ITEM {
-	struct _Q_ITEM	*forw;
-	struct _Q_ITEM	*back;
-} Q_ITEM;
-
-typedef struct _Q_TRACKER {
-	struct _Q_ITEM	*head;
-	struct _Q_ITEM	*tail;
-} Q_TRACKER;
-
 /*
  *  Chip-specific stuff... FC929 delineates break between
  *  FC and Parallel SCSI parts. Do NOT re-order.
@@ -401,8 +381,6 @@
  *	(used to be FCSCSI_TARGET)
  */
 typedef struct _VirtDevice {
-	struct _VirtDevice	*forw;
-	struct _VirtDevice	*back;
 	struct scsi_device	*device;
 	rwlock_t		 VdevLock;
 	int			 ref_cnt;
@@ -426,9 +404,6 @@
 	struct timer_list	 stall_timer;
 	struct timer_list	 retry_timer;
 	struct timer_list	 gone_timer;
-	ScsiCmndTracker		 WaitQ;
-	ScsiCmndTracker		 SentQ;
-	ScsiCmndTracker		 DoneQ;
 	u32			 num_luns;
 	u32			 luns[8];		/* Max LUNs is 256 */
 	u8			 pad[4];
@@ -575,8 +550,6 @@
  */
 typedef struct _MPT_ADAPTER
 {
-	struct _MPT_ADAPTER	*forw;
-	struct _MPT_ADAPTER	*back;
 	int			 id;		/* Unique adapter id N {0,1,2,...} */
 	int			 pci_irq;	/* This irq           */
 	char			 name[MPT_NAME_LENGTH];	/* "iocN"             */
@@ -607,7 +580,7 @@
 	int			*ChainToChain;
 	u8			*ChainBuffer;
 	dma_addr_t		 ChainBufferDMA;
-	MPT_Q_TRACKER		 FreeChainQ;
+	struct list_head	 FreeChainQ;
 	spinlock_t		 FreeChainQlock;
 	CHIP_TYPE		 chip_type;
 		/* We (host driver) get to manage our own RequestQueue! */
@@ -617,7 +590,7 @@
 	int			 req_depth;	/* Number of request frames */
 	int			 req_sz;	/* Request frame size (bytes) */
 	spinlock_t		 FreeQlock;
-	MPT_Q_TRACKER		 FreeQ;
+	struct list_head	 FreeQ;
 		/* Pool of SCSI sense buffers for commands coming from
 		 * the SCSI mid-layer.  We have one 256 byte sense buffer
 		 * for each REQ entry.
@@ -648,7 +621,7 @@
 	struct _mpt_ioctl_events *events;	/* pointer to event log */
 	u8			*cached_fw;	/* Pointer to FW */
 	dma_addr_t	 	cached_fw_dma;
-	Q_TRACKER		 configQ;	/* linked list of config. requests */
+	struct list_head	 configQ;	/* linked list of config. requests */
 	int			 hs_reply_idx;
 #ifndef MFCNT
 	u32			 pad0;
@@ -902,34 +875,6 @@
 #define MPT_INDEX_2_RFPTR(ioc,idx) \
 	(MPT_FRAME_HDR*)( (u8*)(ioc)->reply_frames + (ioc)->req_sz * (idx) )
 
-#define Q_INIT(q,type)  (q)->head = (q)->tail = (type*)(q)
-#define Q_IS_EMPTY(q)   ((Q_ITEM*)(q)->head == (Q_ITEM*)(q))
-
-#define Q_ADD_TAIL(qt,i,type) { \
-	Q_TRACKER	*_qt = (Q_TRACKER*)(qt); \
-	Q_ITEM		*oldTail = _qt->tail; \
-	(i)->forw = (type*)_qt; \
-	(i)->back = (type*)oldTail; \
-	oldTail->forw = (Q_ITEM*)(i); \
-	_qt->tail = (Q_ITEM*)(i); \
-}
-
-#define Q_ADD_HEAD(qt,i,type) { \
-	Q_TRACKER	*_qt = (Q_TRACKER*)(qt); \
-	Q_ITEM		*oldHead = _qt->head; \
-	(i)->forw = (type*)oldHead; \
-	(i)->back = (type*)_qt; \
-	oldHead->back = (Q_ITEM*)(i); \
-	_qt->head = (Q_ITEM*)(i); \
-}
-
-#define Q_DEL_ITEM(i) { \
-	Q_ITEM  *_forw = (Q_ITEM*)(i)->forw; \
-	Q_ITEM  *_back = (Q_ITEM*)(i)->back; \
-	_back->forw = _forw; \
-	_forw->back = _back; \
-}
-
 #define SWAB4(value) \
 	(u32)(   (((value) & 0x000000ff) << 24) \
 	       | (((value) & 0x0000ff00) << 8)  \
@@ -1017,8 +962,6 @@
 		/* Pool of memory for holding SCpnts before doing
 		 * OS callbacks. freeQ is the free pool.
 		 */
-	MPT_Q_TRACKER		  taskQ;		/* TM request Q */
-	int			  taskQcnt;
 	u8			  tmPending;
 	u8			  resetPending;
 	u8			  is_spi;		/* Parallel SCSI i/f */
@@ -1069,7 +1012,7 @@
  * Generic structure passed to the base mpt_config function.
  */
 typedef struct _x_config_parms {
-	Q_ITEM			 linkage;	/* linked list */
+	struct list_head	 linkage;	/* linked list */
 	struct timer_list	 timer;		/* timer function for this request  */
 	ConfigPageHeader_t	*hdr;
 	dma_addr_t		 physAddr;
--- 1.47/drivers/message/fusion/mptscsih.c	2004-09-03 11:08:35 +02:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-09-06 12:39:08 +02:00
@@ -340,19 +340,18 @@
 	dsgprintk((MYIOC_s_INFO_FMT "getFreeChainBuffer called\n",
 			ioc->name));
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	if (!Q_IS_EMPTY(&ioc->FreeChainQ)) {
-
+	if (!list_empty(&ioc->FreeChainQ)) {
 		int offset;
 
-		chainBuf = ioc->FreeChainQ.head;
-		Q_DEL_ITEM(&chainBuf->u.frame.linkage);
+		chainBuf = list_entry(ioc->FreeChainQ.next, MPT_FRAME_HDR,
+				u.frame.linkage.list);
+		list_del(&chainBuf->u.frame.linkage.list);
 		offset = (u8 *)chainBuf - (u8 *)ioc->ChainBuffer;
 		chain_idx = offset / ioc->req_sz;
 		rc = SUCCESS;
 		dsgprintk((MYIOC_s_INFO_FMT "getFreeChainBuffer (index %d), got buf=%p\n",
 			ioc->name, *retIndex, chainBuf));
-	}
-	else {
+	} else {
 		rc = FAILED;
 		chain_idx = MPT_HOST_NO_CHAIN;
 		dfailprintk((MYIOC_s_ERR_FMT "getFreeChainBuffer failed\n",
@@ -360,9 +359,7 @@
 	}
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
-
 	*retIndex = chain_idx;
-
 	return rc;
 } /* mptscsih_getFreeChainBuffer() */
 
@@ -1218,12 +1215,6 @@
 	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=%d\n",
 		 ioc->name, hd->ScsiLookup, sz));
 		
-	/* Initialize this Scsi_Host
-	 * internal task Q.
-	 */
-	Q_INIT(&hd->taskQ, MPT_FRAME_HDR);
-	hd->taskQcnt = 0;
-		
 	/* Allocate memory for the device structures.
 	 * A non-Null pointer at an offset
 	 * indicates a device exists.
@@ -2102,9 +2093,9 @@
 
 		chain = (MPT_FRAME_HDR *) (ioc->ChainBuffer
 					+ (chain_idx * ioc->req_sz));
+
 		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		Q_ADD_TAIL(&ioc->FreeChainQ.head,
-					&chain->u.frame.linkage, MPT_FRAME_HDR);
+		list_add_tail(&chain->u.frame.linkage.list, &ioc->FreeChainQ);
 		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 		dmfprintk((MYIOC_s_INFO_FMT "FreeChainBuffers (index %d)\n",
@@ -2664,8 +2655,6 @@
 		if (hd->tmPtr) {
 			del_timer(&hd->TMtimer);
 		}
-		dtmprintk((MYIOC_s_WARN_FMT "taskQcnt (%d)\n",
-			ioc->name, hd->taskQcnt));
 	} else {
 		dtmprintk((MYIOC_s_WARN_FMT "TaskMgmt Complete: NULL Scsi Host Ptr\n",
 			ioc->name));
@@ -2799,9 +2788,6 @@
 		} else {
 			memset(vdev, 0, sizeof(VirtDevice));
 			rwlock_init(&vdev->VdevLock);
-			Q_INIT(&vdev->WaitQ, void);
-			Q_INIT(&vdev->SentQ, void);
-			Q_INIT(&vdev->DoneQ, void);
 			vdev->tflags = MPT_TARGET_FLAGS_Q_YES;
 			vdev->ioc_id = hd->ioc->id;
 			vdev->target_id = device->id;
