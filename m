From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: Wed, 23 Jun 2004 17:13:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040623161303.GA25285@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E5704925031@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:61080 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265807AbUFWQNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 12:13:12 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704925031@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

On Mon, Jun 21, 2004 at 12:16:08PM -0400, Moore, Eric Dean wrote:
> All,
> 
> We are pleased to announce the MPT Fusion release candidate for lk 2.6

I've worked with Eric offline to resolve the issue we had and get some
more changes in, but he has left for his vacation today.  He send me
a patch though and left it to me whether we'd merged it despite only
moderate testing.  Given 2.6.7 was just done and he'll certainly be
back before 2.6.8 I'd go for it.  Below is the patch rediffed against
scsi-misc-2.6:


--- 1.12/drivers/message/fusion/linux_compat.h	2004-05-29 17:10:51 +02:00
+++ edited/drivers/message/fusion/linux_compat.h	2004-06-23 16:48:43 +02:00
@@ -3,6 +3,16 @@
 #ifndef FUSION_LINUX_COMPAT_H
 #define FUSION_LINUX_COMPAT_H
 
+#include <linux/version.h>
+#include <scsi/scsi_device.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
+static int inline scsi_device_online(struct scsi_device *sdev)
+{
+	return sdev->online;
+}
+#endif
+
 
 /*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif /* _LINUX_COMPAT_H */
===== drivers/message/fusion/mptbase.c 1.24 vs edited =====
--- 1.24/drivers/message/fusion/mptbase.c	2004-05-29 17:10:51 +02:00
+++ edited/drivers/message/fusion/mptbase.c	2004-06-23 16:48:43 +02:00
@@ -150,9 +150,8 @@
 /*
  *  Private data...
  */
-					/* Adapter lookup table */
-       MPT_ADAPTER		*mpt_adapters[MPT_MAX_ADAPTERS];
-static MPT_ADAPTER_TRACKER	 MptAdapters;
+					/* Adapter link list */
+LIST_HEAD(ioc_list);
 					/* Callback lookup table */
 static MPT_CALLBACK		 MptCallbacks[MPT_MAX_PROTOCOL_DRIVERS];
 					/* Protocol driver class lookup table */
@@ -210,8 +209,6 @@
 static int	SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp);
 
 #ifdef CONFIG_PROC_FS
-static int	procmpt_create(void);
-static int	procmpt_destroy(void);
 static int	procmpt_summary_read(char *buf, char **start, off_t offset,
 				int request, int *eof, void *data);
 static int	procmpt_version_read(char *buf, char **start, off_t offset,
@@ -234,31 +231,6 @@
 static int  __init    fusion_init  (void);
 static void __exit    fusion_exit  (void);
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *  more Private data...
- */
-#ifdef CONFIG_PROC_FS
-struct _mpt_proc_list {
-	const char	*name;
-	int		(*f)(char *, char **, off_t, int, int *, void *);
-} mpt_proc_list[] = {
-	{ "summary", procmpt_summary_read},
-	{ "version", procmpt_version_read},
-};
-#define MPT_PROC_ENTRIES (sizeof(mpt_proc_list)/sizeof(mpt_proc_list[0]))
-
-struct _mpt_ioc_proc_list {
-	const char	*name;
-	int		(*f)(char *, char **, off_t, int, int *, void *);
-} mpt_ioc_proc_list[] = {
-	{ "info", procmpt_iocinfo_read},
-	{ "summary", procmpt_summary_read},
-};
-#define MPT_IOC_PROC_ENTRIES (sizeof(mpt_ioc_proc_list)/sizeof(mpt_ioc_proc_list[0]))
-
-#endif
-
 /****************************************************************************
  * Supported hardware
  */
@@ -282,7 +254,8 @@
 };
 MODULE_DEVICE_TABLE(pci, mptbase_pci_table);
 
-#define CHIPREG_READ32(addr) 		readl(addr)
+#define CHIPREG_READ32(addr) 		readl_relaxed(addr)
+#define CHIPREG_READ32_dmasync(addr)	readl(addr)
 #define CHIPREG_WRITE32(addr,val) 	writel(val, addr)
 #define CHIPREG_PIO_WRITE32(addr,val)	outl(val, (unsigned long)addr)
 #define CHIPREG_PIO_READ32(addr) 	inl((unsigned long)addr)
@@ -320,23 +293,6 @@
 
 	ioc = bus_id;
 
-#ifdef MPT_DEBUG_IRQ
-	/*
-	 * Verify ioc pointer is ok
-	 */
-	{
-		MPT_ADAPTER	*iocCmp;
-		iocCmp = mpt_adapter_find_first();
-		while ((ioc != iocCmp)  && iocCmp)
-			iocCmp = mpt_adapter_find_next(iocCmp);
-
-		if (!iocCmp) {
-			printk(KERN_WARNING "mpt_interrupt: Invalid ioc!\n");
-			return IRQ_NONE;
-		}
-	}
-#endif
-
 	/*
 	 *  Drain the reply FIFO!
 	 *
@@ -347,7 +303,7 @@
 	 */
 	while (1) {
 
-		if ((pa = CHIPREG_READ32(&ioc->chip->ReplyFifo)) == 0xFFFFFFFF)
+		if ((pa = CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo)) == 0xFFFFFFFF)
 			return IRQ_HANDLED;
 
 		cb_idx = 0;
@@ -806,8 +762,7 @@
 	MptDeviceDriverHandlers[cb_idx] = dd_cbfunc;
 
 	/* call per pci device probe entry point */
-	for(ioc = mpt_adapter_find_first(); ioc != NULL;
-	  ioc = mpt_adapter_find_next(ioc)) {
+	list_for_each_entry(ioc, &ioc_list, list) {
 		if(dd_cbfunc->probe) {
 			error = dd_cbfunc->probe(ioc->pcidev,
 			  ioc->pcidev->driver->id_table);
@@ -826,9 +781,19 @@
 void
 mpt_device_driver_deregister(int cb_idx)
 {
+	struct mpt_pci_driver *dd_cbfunc;
+	MPT_ADAPTER	*ioc;
+
 	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return;
 
+	dd_cbfunc = MptDeviceDriverHandlers[cb_idx];
+
+	list_for_each_entry(ioc, &ioc_list, list) {
+		if (dd_cbfunc->remove)
+			dd_cbfunc->remove(ioc->pcidev);
+	}
+	
 	MptDeviceDriverHandlers[cb_idx] = NULL;
 }
 
@@ -844,15 +809,11 @@
  *	or IOC is not active.
  */
 MPT_FRAME_HDR*
-mpt_get_msg_frame(int handle, int iocid)
+mpt_get_msg_frame(int handle, MPT_ADAPTER *iocp)
 {
 	MPT_FRAME_HDR *mf;
-	MPT_ADAPTER *iocp;
 	unsigned long flags;
 
-	/* validate handle and ioc identifier */
-	iocp = mpt_adapters[iocid];
-
 #ifdef MFCNT
 	if (!iocp->active)
 		printk(KERN_WARNING "IOC Not Active! mpt_get_msg_frame returning NULL!\n");
@@ -907,48 +868,39 @@
  *	specific MPT adapter.
  */
 void
-mpt_put_msg_frame(int handle, int iocid, MPT_FRAME_HDR *mf)
+mpt_put_msg_frame(int handle, MPT_ADAPTER *iocp, MPT_FRAME_HDR *mf)
 {
-	MPT_ADAPTER *iocp;
+	u32 mf_dma_addr;
+	int req_offset;
 
-	iocp = mpt_adapters[iocid];
-	if (iocp != NULL) {
-		u32 mf_dma_addr;
-		int req_offset;
-
-		/* ensure values are reset properly! */
-		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;		/* byte */
-		req_offset = (u8 *)mf - (u8 *)iocp->req_frames;
+	/* ensure values are reset properly! */
+	mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;		/* byte */
+	req_offset = (u8 *)mf - (u8 *)iocp->req_frames;
 									/* u16! */
-		mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(req_offset / iocp->req_sz);
-		mf->u.frame.hwhdr.msgctxu.fld.rsvd = 0;
+	mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(req_offset / iocp->req_sz);
+	mf->u.frame.hwhdr.msgctxu.fld.rsvd = 0;
 
 #ifdef MPT_DEBUG_MSG_FRAME
-		{
-			u32	*m = mf->u.frame.hwhdr.__hdr;
-			int	 ii, n;
+	{
+		u32	*m = mf->u.frame.hwhdr.__hdr;
+		int	 ii, n;
 
-			printk(KERN_INFO MYNAM ": %s: About to Put msg frame @ %p:\n" KERN_INFO " ",
-					iocp->name, m);
-			n = iocp->req_sz/4 - 1;
-			while (m[n] == 0)
-				n--;
-			for (ii=0; ii<=n; ii++) {
-				if (ii && ((ii%8)==0))
-					printk("\n" KERN_INFO " ");
-				printk(" %08x", le32_to_cpu(m[ii]));
-			}
-			printk("\n");
+		printk(KERN_INFO MYNAM ": %s: About to Put msg frame @ %p:\n" KERN_INFO " ",
+				iocp->name, m);
+		n = iocp->req_sz/4 - 1;
+		while (m[n] == 0)
+			n--;
+		for (ii=0; ii<=n; ii++) {
+			if (ii && ((ii%8)==0))
+				printk("\n" KERN_INFO " ");
+			printk(" %08x", le32_to_cpu(m[ii]));
 		}
-#endif
-
-		mf_dma_addr = iocp->req_frames_low_dma + req_offset;
-		CHIPREG_WRITE32(&iocp->chip->RequestFifo, mf_dma_addr);
-	} else {
-		printk (KERN_ERR
-		    "mpt_put_msg_frame: Invalid iocid=%d\n", iocid);
+		printk("\n");
 	}
+#endif
 
+	mf_dma_addr = iocp->req_frames_low_dma + req_offset;
+	CHIPREG_WRITE32(&iocp->chip->RequestFifo, mf_dma_addr);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -962,21 +914,17 @@
  *	FreeQ.
  */
 void
-mpt_free_msg_frame(int handle, int iocid, MPT_FRAME_HDR *mf)
+mpt_free_msg_frame(int handle, MPT_ADAPTER *iocp, MPT_FRAME_HDR *mf)
 {
-	MPT_ADAPTER *iocp;
 	unsigned long flags;
 
-	iocp = mpt_adapters[iocid];
-	if (iocp != NULL) {
-		/*  Put Request back on FreeQ!  */
-		spin_lock_irqsave(&iocp->FreeQlock, flags);
-		Q_ADD_TAIL(&iocp->FreeQ, &mf->u.frame.linkage, MPT_FRAME_HDR);
+	/*  Put Request back on FreeQ!  */
+	spin_lock_irqsave(&iocp->FreeQlock, flags);
+	Q_ADD_TAIL(&iocp->FreeQ, &mf->u.frame.linkage, MPT_FRAME_HDR);
 #ifdef MFCNT
-		iocp->mfcnt--;
+	iocp->mfcnt--;
 #endif
-		spin_unlock_irqrestore(&iocp->FreeQlock, flags);
-	}
+	spin_unlock_irqrestore(&iocp->FreeQlock, flags);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1062,127 +1010,80 @@
  *	Returns 0 for success, non-zero for failure.
  */
 int
-mpt_send_handshake_request(int handle, int iocid, int reqBytes, u32 *req, int sleepFlag)
+mpt_send_handshake_request(int handle, MPT_ADAPTER *iocp, int reqBytes, u32 *req, int sleepFlag)
 {
-	MPT_ADAPTER	*iocp;
 	int		 r = 0;
+	u8	*req_as_bytes;
+	int	 ii;
 
-	iocp = mpt_adapters[iocid];
-	if (iocp != NULL) {
-		u8	*req_as_bytes;
-		int	 ii;
-
-		/* State is known to be good upon entering
-		 * this function so issue the bus reset
-		 * request.
-		 */
-
-		/*
-		 * Emulate what mpt_put_msg_frame() does /wrt to sanity
-		 * setting cb_idx/req_idx.  But ONLY if this request
-		 * is in proper (pre-alloc'd) request buffer range...
-		 */
-		ii = MFPTR_2_MPT_INDEX(iocp,(MPT_FRAME_HDR*)req);
-		if (reqBytes >= 12 && ii >= 0 && ii < iocp->req_depth) {
-			MPT_FRAME_HDR *mf = (MPT_FRAME_HDR*)req;
-			mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(ii);
-			mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;
-		}
-
-		/* Make sure there are no doorbells */
-		CHIPREG_WRITE32(&iocp->chip->IntStatus, 0);
+	/* State is known to be good upon entering
+	 * this function so issue the bus reset
+	 * request.
+	 */
 
-		CHIPREG_WRITE32(&iocp->chip->Doorbell,
-				((MPI_FUNCTION_HANDSHAKE<<MPI_DOORBELL_FUNCTION_SHIFT) |
-				 ((reqBytes/4)<<MPI_DOORBELL_ADD_DWORDS_SHIFT)));
+	/*
+	 * Emulate what mpt_put_msg_frame() does /wrt to sanity
+	 * setting cb_idx/req_idx.  But ONLY if this request
+	 * is in proper (pre-alloc'd) request buffer range...
+	 */
+	ii = MFPTR_2_MPT_INDEX(iocp,(MPT_FRAME_HDR*)req);
+	if (reqBytes >= 12 && ii >= 0 && ii < iocp->req_depth) {
+		MPT_FRAME_HDR *mf = (MPT_FRAME_HDR*)req;
+		mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(ii);
+		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;
+	}
 
-		/* Wait for IOC doorbell int */
-		if ((ii = WaitForDoorbellInt(iocp, 5, sleepFlag)) < 0) {
-			return ii;
-		}
+	/* Make sure there are no doorbells */
+	CHIPREG_WRITE32(&iocp->chip->IntStatus, 0);
+	CHIPREG_WRITE32(&iocp->chip->Doorbell,
+			((MPI_FUNCTION_HANDSHAKE<<MPI_DOORBELL_FUNCTION_SHIFT) |
+			 ((reqBytes/4)<<MPI_DOORBELL_ADD_DWORDS_SHIFT)));
 
-		/* Read doorbell and check for active bit */
-		if (!(CHIPREG_READ32(&iocp->chip->Doorbell) & MPI_DOORBELL_ACTIVE))
-				return -5;
+	/* Wait for IOC doorbell int */
+	ii = WaitForDoorbellInt(iocp, 5, sleepFlag);
+	if (ii < 0)
+		return ii;
 
-		dhsprintk((KERN_INFO MYNAM ": %s: mpt_send_handshake_request start, WaitCnt=%d\n",
-				iocp->name, ii));
+	/* Read doorbell and check for active bit */
+	if (!(CHIPREG_READ32(&iocp->chip->Doorbell) & MPI_DOORBELL_ACTIVE))
+		return -5;
 
-		CHIPREG_WRITE32(&iocp->chip->IntStatus, 0);
+	dhsprintk((KERN_INFO MYNAM ": %s: mpt_send_handshake_request start, WaitCnt=%d\n",
+			iocp->name, ii));
 
-		if ((r = WaitForDoorbellAck(iocp, 5, sleepFlag)) < 0) {
-			return -2;
-		}
+	CHIPREG_WRITE32(&iocp->chip->IntStatus, 0);
 
-		/* Send request via doorbell handshake */
-		req_as_bytes = (u8 *) req;
-		for (ii = 0; ii < reqBytes/4; ii++) {
-			u32 word;
+	r = WaitForDoorbellAck(iocp, 5, sleepFlag);
+	if (r < 0)
+		return -2;
 
-			word = ((req_as_bytes[(ii*4) + 0] <<  0) |
-				(req_as_bytes[(ii*4) + 1] <<  8) |
-				(req_as_bytes[(ii*4) + 2] << 16) |
-				(req_as_bytes[(ii*4) + 3] << 24));
-			CHIPREG_WRITE32(&iocp->chip->Doorbell, word);
-			if ((r = WaitForDoorbellAck(iocp, 5, sleepFlag)) < 0) {
-				r = -3;
-				break;
-			}
+	/* Send request via doorbell handshake */
+	req_as_bytes = (u8 *) req;
+	for (ii = 0; ii < reqBytes/4; ii++) {
+		u32 word;
+
+		word = ((req_as_bytes[(ii*4) + 0] <<  0) |
+			(req_as_bytes[(ii*4) + 1] <<  8) |
+			(req_as_bytes[(ii*4) + 2] << 16) |
+			(req_as_bytes[(ii*4) + 3] << 24));
+		CHIPREG_WRITE32(&iocp->chip->Doorbell, word);
+		r = WaitForDoorbellAck(iocp, 5, sleepFlag);
+		if (r < 0) {
+			r = -3;
+			break;
 		}
-
-		if (r >= 0 && WaitForDoorbellInt(iocp, 10, sleepFlag) >= 0)
-			r = 0;
-		else
-			r = -4;
-
-		/* Make sure there are no doorbells */
-		CHIPREG_WRITE32(&iocp->chip->IntStatus, 0);
 	}
 
-	return r;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mpt_adapter_find_first - Find first MPT adapter pointer.
- *
- *	Returns first MPT adapter pointer or %NULL if no MPT adapters
- *	are present.
- */
-MPT_ADAPTER *
-mpt_adapter_find_first(void)
-{
-	MPT_ADAPTER *this;
-
-	if (! Q_IS_EMPTY(&MptAdapters))
-		this = MptAdapters.head;
+	if (r >= 0 && WaitForDoorbellInt(iocp, 10, sleepFlag) >= 0)
+		r = 0;
 	else
-		this = NULL;
+		r = -4;
 
-	return this;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mpt_adapter_find_next - Find next MPT adapter pointer.
- *	@prev: Pointer to previous MPT adapter
- *
- *	Returns next MPT adapter pointer or %NULL if there are no more.
- */
-MPT_ADAPTER *
-mpt_adapter_find_next(MPT_ADAPTER *prev)
-{
-	MPT_ADAPTER *next;
-
-	if (prev && (prev->forw != (MPT_ADAPTER*)&MptAdapters.head))
-		next = prev->forw;
-	else
-		next = NULL;
-
-	return next;
+	/* Make sure there are no doorbells */
+	CHIPREG_WRITE32(&iocp->chip->IntStatus, 0);
+	return r;
 }
 
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_verify_adapter - Given a unique IOC identifier, set pointer to
@@ -1195,18 +1096,17 @@
 int
 mpt_verify_adapter(int iocid, MPT_ADAPTER **iocpp)
 {
-	MPT_ADAPTER *p;
+	MPT_ADAPTER *ioc;
 
+	list_for_each_entry(ioc,&ioc_list,list) {
+		if (ioc->id == iocid) {
+			*iocpp =ioc;
+			return iocid;
+		} 
+	}
+	
 	*iocpp = NULL;
-	if (iocid >= MPT_MAX_ADAPTERS)
-		return -1;
-
-	p = mpt_adapters[iocid];
-	if (p == NULL)
-		return -1;
-
-	*iocpp = p;
-	return iocid;
+	return -1;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1240,6 +1140,8 @@
 	u64		 mask = 0xffffffffffffffffULL;
 	u8		 revision;
 	u8		 pcixcmd;
+	static int	 mpt_ids = 0;
+	struct proc_dir_entry *dent, *ent;
 
 	if (pci_enable_device(pdev))
 		return r;
@@ -1296,18 +1198,9 @@
 	Q_INIT(&ioc->configQ, Q_ITEM);
 
 	/* Find lookup slot. */
-	for (ii=0; ii < MPT_MAX_ADAPTERS; ii++) {
-		if (mpt_adapters[ii] == NULL) {
-			ioc->id = ii;		/* Assign adapter unique id (lookup) */
-			break;
-		}
-	}
-	if (ii == MPT_MAX_ADAPTERS) {
-		printk(KERN_ERR MYNAM ": ERROR - mpt_adapters[%d] table overflow!\n", ii);
-		kfree(ioc);
-		return -ENFILE;
-	}
-
+	INIT_LIST_HEAD(&ioc->list);
+	ioc->id = mpt_ids++;
+	
 	mem_phys = msize = 0;
 	port = psize = 0;
 	for (ii=0; ii < DEVICE_COUNT_RESOURCE; ii++) {
@@ -1429,11 +1322,8 @@
 	ioc->active = 0;
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
-	/* tack onto tail of our MPT adapter list */
-	Q_ADD_TAIL(&MptAdapters, ioc, MPT_ADAPTER);
-
 	/* Set lookup ptr. */
-	mpt_adapters[ioc->id] = ioc;
+	list_add_tail(&ioc->list, &ioc_list);
 
 	ioc->pci_irq = -1;
 	if (pdev->irq) {
@@ -1448,7 +1338,7 @@
 					ioc->name, __irq_itoa(pdev->irq));
 #endif
 			Q_DEL_ITEM(ioc);
-			mpt_adapters[ioc->id] = NULL;
+			list_del(&ioc->list);
 			iounmap(mem);
 			kfree(ioc);
 			return -EBUSY;
@@ -1480,7 +1370,7 @@
 		  ioc->name, r);
 
 		Q_DEL_ITEM(ioc);
-		mpt_adapters[ioc->id] = NULL;
+		list_del(&ioc->list);
 		free_irq(ioc->pci_irq, ioc);
 		iounmap(mem);
 		kfree(ioc);
@@ -1496,6 +1386,23 @@
 		}
 	}
 
+	/*
+	 *  Create "/proc/mpt/iocN" subdirectory entry for each MPT adapter.
+	 */
+	dent = proc_mkdir(ioc->name, mpt_proc_root_dir);
+	if (dent) {
+		ent = create_proc_entry("info", S_IFREG|S_IRUGO, dent);
+		if (ent) {
+			ent->read_proc = procmpt_iocinfo_read;
+			ent->data = ioc;
+		}
+		ent = create_proc_entry("summary", S_IFREG|S_IRUGO, dent);
+		if (ent) {
+			ent->read_proc = procmpt_summary_read;
+			ent->data = ioc;
+		}
+	}
+
 	return 0;
 }
 
@@ -1510,8 +1417,16 @@
 mptbase_remove(struct pci_dev *pdev)
 {
 	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
+	char pname[32];
 	int ii;
 
+	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/summary", ioc->name);
+	remove_proc_entry(pname, NULL);
+	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/info", ioc->name);
+	remove_proc_entry(pname, NULL);
+	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s", ioc->name);
+	remove_proc_entry(pname, NULL);
+	
 	/* call per device driver remove entry point */
 	for(ii=0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {
 		if(MptDeviceDriverHandlers[ii] &&
@@ -1519,7 +1434,7 @@
 			MptDeviceDriverHandlers[ii]->remove(pdev);
 		}
 	}
-
+	
 	/* Disable interrupts! */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
 
@@ -1531,7 +1446,6 @@
 
 	CHIPREG_READ32(&ioc->chip->IntStatus);
 
-	Q_DEL_ITEM(ioc);
 	mpt_adapter_dispose(ioc);
 
 	pci_set_drvdata(pdev, NULL);
@@ -1769,11 +1683,17 @@
 					ioc->alt_ioc->name, r);
 	}
 
-	/* Get IOC facts! Allow 1 retry */
-	if ((r = GetIocFacts(ioc, sleepFlag, reason)) != 0)
-		r = GetIocFacts(ioc, sleepFlag, reason);
+	for (ii=0; ii<5; ii++) {
+		/* Get IOC facts! Allow 1 retry */
+		if ((r = GetIocFacts(ioc, sleepFlag, reason)) != 0) {
+			dinitprintk((MYIOC_s_INFO_FMT 
+			     "ii=%d IocFacts failed r=%x\n", ioc->name, ii, r));
+		} else
+			break;
+	}
 
 	if (r) {
+		dinitprintk((MYIOC_s_INFO_FMT "Retry IocFacts failed r=%x\n", ioc->name, r));
 		ret = -2;
 	} else if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
 		MptDisplayIocCapabilities(ioc);
@@ -1781,11 +1701,13 @@
 
 	if (alt_ioc_ready) {
 		if ((r = GetIocFacts(ioc->alt_ioc, sleepFlag, reason)) != 0) {
+			dinitprintk((MYIOC_s_INFO_FMT "Initial Alt IocFacts failed r=%x\n", ioc->name, r));
 			/* Retry - alt IOC was initialized once
 			 */
 			r = GetIocFacts(ioc->alt_ioc, sleepFlag, reason);
 		}
 		if (r) {
+			dinitprintk((MYIOC_s_INFO_FMT "Retry Alt IocFacts failed r=%x\n", ioc->name, r));
 			alt_ioc_ready = 0;
 			reset_alt_ioc_active = 0;
 		} else if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
@@ -1973,15 +1895,15 @@
 static void
 mpt_detect_bound_ports(MPT_ADAPTER *ioc, struct pci_dev *pdev)
 {
-	MPT_ADAPTER *ioc_srch = mpt_adapter_find_first();
 	unsigned int match_lo, match_hi;
+	MPT_ADAPTER *ioc_srch;
 
 	match_lo = pdev->devfn-1;
 	match_hi = pdev->devfn+1;
 	dprintk((MYIOC_s_INFO_FMT "PCI bus/devfn=%x/%x, searching for devfn match on %x or %x\n",
 			ioc->name, pdev->bus->number, pdev->devfn, match_lo, match_hi));
 
-	while (ioc_srch != NULL) {
+	list_for_each_entry(ioc_srch, &ioc_list, list) {
 		struct pci_dev *_pcidev = ioc_srch->pcidev;
 
 		if ((_pcidev->device == pdev->device) &&
@@ -2003,7 +1925,6 @@
 			ioc->alt_ioc = ioc_srch;
 			break;
 		}
-		ioc_srch = mpt_adapter_find_next(ioc_srch);
 	}
 }
 
@@ -2018,15 +1939,8 @@
 {
 	if (this != NULL) {
 		int sz=0;
-		u32 state;
 		int ret;
 
-		/* Disable the FW */
-		state = mpt_GetIocState(this, 1);
-		if (state == MPI_IOC_STATE_OPERATIONAL) {
-			SendIocReset(this, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, NO_SLEEP);
-		}
-
 		if (this->cached_fw != NULL) {
 			ddlprintk((KERN_INFO MYNAM ": Pushing FW onto adapter\n"));
 
@@ -2070,25 +1984,11 @@
 		}
 
 		if (freeup && this->cached_fw != NULL) {
-			int ii = 0;
 
-			while ((ii < this->num_fw_frags) && (this->cached_fw[ii]!= NULL)) {
-				sz = this->cached_fw[ii]->size;
-				pci_free_consistent(this->pcidev, sz,
-					this->cached_fw[ii]->fw, this->cached_fw[ii]->fw_dma);
-				this->cached_fw[ii]->fw = NULL;
-				this->alloc_total -= sz;
-
-				kfree(this->cached_fw[ii]);
-				this->cached_fw[ii] = NULL;
-				this->alloc_total -= sizeof(fw_image_t);
-
-				ii++;
-			}
-
-			kfree(this->cached_fw);
+			sz = this->facts.FWImageSize;
+			pci_free_consistent(this->pcidev, sz,
+				this->cached_fw, this->cached_fw_dma);
 			this->cached_fw = NULL;
-			sz = this->num_fw_frags * sizeof(void *);
 			this->alloc_total -= sz;
 		}
 
@@ -2130,11 +2030,6 @@
 
 		sz_first = this->alloc_total;
 
-		if (this->alt_ioc != NULL) {
-			this->alt_ioc->alt_ioc = NULL;
-			this->alt_ioc = NULL;
-		}
-
 		mpt_adapter_disable(this, 1);
 
 		if (this->pci_irq != -1) {
@@ -2153,7 +2048,7 @@
 #endif
 
 		/*  Zap the adapter lookup ptr!  */
-		mpt_adapters[this->id] = NULL;
+		list_del(&this->list);
 
 		sz_last = this->alloc_total;
 		dprintk((KERN_INFO MYNAM ": %s: free'd %d of %d bytes\n",
@@ -2250,13 +2145,14 @@
 		if ((int)ioc->chip_type <= (int)FC929)
 			return 0;
 		else {
+			return 0;
 			/* Workaround from broken 1030 FW.
 			 * Force a diagnostic reset if fails.
 			 */
-			if ((r = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag)) == 0)
+/*			if ((r = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag)) == 0)
 				return 0;
 			else
-				statefault = 4;
+				statefault = 4; */
 		}
 	}
 
@@ -2275,7 +2171,7 @@
 	 *	Hmmm...  Did it get left operational?
 	 */
 	if ((ioc_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_OPERATIONAL) {
-		dprintk((MYIOC_s_WARN_FMT "IOC operational unexpected\n",
+		dinitprintk((MYIOC_s_WARN_FMT "IOC operational unexpected\n",
 				ioc->name));
 
 		/* Check WhoInit.
@@ -2419,7 +2315,7 @@
 	get_facts.Function = MPI_FUNCTION_IOC_FACTS;
 	/* Assert: All other get_facts fields are zero! */
 
-	dprintk((MYIOC_s_INFO_FMT "Sending get IocFacts request\n", ioc->name));
+	dinitprintk((MYIOC_s_INFO_FMT "Sending get IocFacts request\n", ioc->name));
 
 	/* No non-zero fields in the get_facts request are greater than
 	 * 1 byte in size, so we can just fire it off as is.
@@ -2519,8 +2415,10 @@
 				return r;
 		}
 	} else {
-		printk(MYIOC_s_ERR_FMT "Invalid IOC facts reply!\n",
-				ioc->name);
+		printk(MYIOC_s_ERR_FMT 
+		     "Invalid IOC facts reply, msgLength=%d offsetof=%d!\n",
+		     ioc->name, facts->MsgLength, (offsetof(IOCFactsReply_t,
+		     RequestFrameSize)/sizeof(u32)));
 		return -66;
 	}
 
@@ -2665,7 +2563,7 @@
 	ioc->facts.CurrentHostMfaHighAddr = ioc_init.HostMfaHighAddr;
 	ioc->facts.CurrentSenseBufferHighAddr = ioc_init.SenseBufferHighAddr;
 
-	dprintk((MYIOC_s_INFO_FMT "Sending IOCInit (req @ %p)\n",
+	dhsprintk((MYIOC_s_INFO_FMT "Sending IOCInit (req @ %p)\n",
 			ioc->name, &ioc_init));
 
 	r = mpt_handshake_req_reply_wait(ioc, sizeof(IOCInit_t), (u32*)&ioc_init,
@@ -2677,6 +2575,9 @@
 	 * since we don't even look at it's contents.
 	 */
 
+	dhsprintk((MYIOC_s_INFO_FMT "Sending PortEnable (req @ %p)\n",
+			ioc->name, &ioc_init));
+	
 	if ((r = SendPortEnable(ioc, 0, sleepFlag)) != 0)
 		return r;
 
@@ -2771,86 +2672,14 @@
  * Outputs: frags - number of fragments needed
  * Return NULL if failed.
  */
-void *
-mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size, int *frags, int *alloc_sz)
+void
+mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size)
 {
-	fw_image_t	**cached_fw;
-	u8		*mem;
-	dma_addr_t	fw_dma;
-	int		alloc_total = 0;
-	int		bytes_left, bytes, num_frags;
-	int		sz, ii;
-
 	/* cached_fw
 	 */
-	sz = ioc->num_fw_frags * sizeof(void *);
-	mem = kmalloc(sz, GFP_ATOMIC);
-	if (mem == NULL)
-		return NULL;
-
-	memset(mem, 0, sz);
-	cached_fw = (fw_image_t **)mem;
-	alloc_total += sz;
-
-	/* malloc fragment memory
-	 * fw_image_t struct and dma for fw data
-	 */
-	bytes_left = size;
-	ii = 0;
-	num_frags = 0;
-	bytes = bytes_left;
-	while((bytes_left) && (num_frags < ioc->num_fw_frags)) {
-		if (cached_fw[ii] == NULL) {
-			mem = kmalloc(sizeof(fw_image_t), GFP_ATOMIC);
-			if (mem == NULL)
-				break;
-
-			memset(mem, 0, sizeof(fw_image_t));
-			cached_fw[ii] = (fw_image_t *)mem;
-			alloc_total += sizeof(fw_image_t);
-		}
-
-		mem = pci_alloc_consistent(ioc->pcidev, bytes, &fw_dma);
-		if (mem == NULL) {
-			if (bytes > 0x10000)
-				bytes = 0x10000;
-			else if (bytes > 0x8000)
-				bytes = 0x8000;
-			else if (bytes > 0x4000)
-				bytes = 0x4000;
-			else if (bytes > 0x2000)
-				bytes = 0x2000;
-			else if (bytes > 0x1000)
-				bytes = 0x1000;
-			else
-				break;
-
-			continue;
-		}
-
-		cached_fw[ii]->fw = mem;
-		cached_fw[ii]->fw_dma = fw_dma;
-		cached_fw[ii]->size = bytes;
-		memset(mem, 0, bytes);
-		alloc_total += bytes;
-
-		bytes_left -= bytes;
-
-		num_frags++;
-		ii++;
-	}
-
-	if (bytes_left ) {
-		/* Major Failure.
-		 */
-		mpt_free_fw_memory(ioc, cached_fw);
-		return NULL;
-	}
 
-	*frags = num_frags;
-	*alloc_sz = alloc_total;
-
-	return (void *) cached_fw;
+	if ( (ioc->cached_fw = pci_alloc_consistent(ioc->pcidev, size, &ioc->cached_fw_dma) ) )
+		ioc->alloc_total += size;
 }
 
 /*
@@ -2858,45 +2687,14 @@
  * Else, delete a secondary image in same format.
  */
 void
-mpt_free_fw_memory(MPT_ADAPTER *ioc, fw_image_t **alt_img)
+mpt_free_fw_memory(MPT_ADAPTER *ioc)
 {
-	fw_image_t **cached_fw;
-	int ii;
 	int sz;
-	int alloc_freed = 0;
-
-	if (alt_img != NULL)
-		cached_fw = alt_img;
-	else
-		cached_fw = ioc->cached_fw;
-
-	if (cached_fw == NULL)
-		return;
 
-	ii = 0;
-	while ((ii < ioc->num_fw_frags) && (cached_fw[ii]!= NULL)) {
-		sz = cached_fw[ii]->size;
-		if (sz > 0) {
-			pci_free_consistent(ioc->pcidev, sz,
-						cached_fw[ii]->fw, cached_fw[ii]->fw_dma);
-		}
-		cached_fw[ii]->fw = NULL;
-		alloc_freed += sz;
-
-		kfree(cached_fw[ii]);
-		cached_fw[ii] = NULL;
-		alloc_freed += sizeof(fw_image_t);
-
-		ii++;
-	}
-
-	kfree(cached_fw);
-	cached_fw = NULL;
-	sz = ioc->num_fw_frags * sizeof(void *);
-	alloc_freed += sz;
-
-	if (alt_img == NULL)
-		ioc->alloc_total -= alloc_freed;
+	sz = ioc->facts.FWImageSize;
+	pci_free_consistent(ioc->pcidev, sz,
+			ioc->cached_fw, ioc->cached_fw_dma);
+	ioc->cached_fw = NULL;
 
 	return;
 }
@@ -2925,9 +2723,9 @@
 	FWUploadReply_t		*preply;
 	FWUploadTCSGE_t		*ptcsge;
 	int			 sgeoffset;
+	u32			 flagsLength;
 	int			 ii, sz, reply_sz;
 	int			 cmdStatus, freeMem = 0;
-	int			 num_frags, alloc_sz;
 
 	/* If the image size is 0 or if the pointer is
 	 * not NULL (error), we are done.
@@ -2935,24 +2733,21 @@
 	if (((sz = ioc->facts.FWImageSize) == 0) || ioc->cached_fw)
 		return 0;
 
-	ioc->num_fw_frags = ioc->req_sz - sizeof(FWUpload_t) + sizeof(dma_addr_t) + sizeof(u32) -1;
-	ioc->num_fw_frags /= sizeof(dma_addr_t) + sizeof(u32);
+	if ( sz & 0x01 )
+		sz += 1;
+	if ( sz & 0x02 )
+		sz += 2;
 
-	ioc->cached_fw = (fw_image_t **) mpt_alloc_fw_memory(ioc,
-			ioc->facts.FWImageSize, &num_frags, &alloc_sz);
+	mpt_alloc_fw_memory(ioc, sz);
 
 	if (ioc->cached_fw == NULL) {
 		/* Major Failure.
 		 */
-		mpt_free_fw_memory(ioc, NULL);
-		ioc->cached_fw = NULL;
-		
 		return -ENOMEM;
 	}
-	ioc->alloc_total += alloc_sz;
 
-	ddlprintk((KERN_INFO MYNAM ": FW Image  @ %p, sz=%d bytes\n",
-		 (void *)(ulong)ioc->cached_fw, ioc->facts.FWImageSize));
+	dinitprintk((KERN_WARNING MYNAM ": FW Image  @ %p[%p], sz=%d[%x] bytes\n",
+		 ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
 
 	prequest = (FWUpload_t *)&request;
 	preply = (FWUploadReply_t *)&reply;
@@ -2965,39 +2760,27 @@
 
 	prequest->ImageType = MPI_FW_UPLOAD_ITYPE_FW_IOC_MEM;
 	prequest->Function = MPI_FUNCTION_FW_UPLOAD;
-	prequest->MsgContext = 0;		/* anything */
 
 	ptcsge = (FWUploadTCSGE_t *) &prequest->SGL;
-	ptcsge->Reserved = 0;
-	ptcsge->ContextSize = 0;
 	ptcsge->DetailsLength = 12;
 	ptcsge->Flags = MPI_SGE_FLAGS_TRANSACTION_ELEMENT;
-	ptcsge->Reserved1 = 0;
-	ptcsge->ImageOffset = 0;
 	ptcsge->ImageSize = cpu_to_le32(sz);
 
 	sgeoffset = sizeof(FWUpload_t) - sizeof(SGE_MPI_UNION) + sizeof(FWUploadTCSGE_t);
 
-	for (ii = 0; ii < (num_frags-1); ii++) {
-		mpt_add_sge(&request[sgeoffset], MPT_SGE_FLAGS_SIMPLE_ELEMENT |	
-			MPT_SGE_FLAGS_ADDRESSING | MPT_TRANSFER_IOC_TO_HOST |
-			(u32) ioc->cached_fw[ii]->size, ioc->cached_fw[ii]->fw_dma);
-
-		sgeoffset += sizeof(u32) + sizeof(dma_addr_t);
-	}
-
-	mpt_add_sge(&request[sgeoffset],
-			MPT_SGE_FLAGS_SSIMPLE_READ |(u32) ioc->cached_fw[ii]->size,
-			ioc->cached_fw[ii]->fw_dma);
+	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ | sz;
+	mpt_add_sge(&request[sgeoffset], flagsLength, ioc->cached_fw_dma);
 
 	sgeoffset += sizeof(u32) + sizeof(dma_addr_t);
-
-	dprintk((MYIOC_s_INFO_FMT "Sending FW Upload (req @ %p) size %d \n",
-			ioc->name, prequest, sgeoffset));
+	dinitprintk((KERN_WARNING MYNAM "Sending FW Upload (req @ %p) sgeoffset=%d \n",
+			prequest, sgeoffset));
+	DBG_DUMP_FW_REQUEST_FRAME(prequest)
 
 	ii = mpt_handshake_req_reply_wait(ioc, sgeoffset, (u32*)prequest,
 				reply_sz, (u16*)preply, 65 /*seconds*/, sleepFlag);
 
+	dinitprintk((KERN_WARNING MYNAM "FW Upload completed rc=%x \n", ii));
+
 	cmdStatus = -EFAULT;
 	if (ii == 0) {
 		/* Handshake transfer was complete and successful.
@@ -3011,7 +2794,7 @@
 				cmdStatus = 0;
 		}
 	}
-	ddlprintk((MYIOC_s_INFO_FMT ": do_upload status %d \n",
+	dinitprintk((MYIOC_s_INFO_FMT ": do_upload status %d \n",
 			ioc->name, cmdStatus));
 
 	/* Check to see if we have a copy of this image in
@@ -3031,8 +2814,7 @@
 
 		ddlprintk((MYIOC_s_INFO_FMT ": do_upload freeing %s image \n",
 			ioc->name, cmdStatus ? "incomplete" : "duplicate"));
-		mpt_free_fw_memory(ioc, NULL);
-		ioc->cached_fw = NULL;
+		mpt_free_fw_memory(ioc);
 	}
 
 	return cmdStatus;
@@ -3055,241 +2837,138 @@
 static int
 mpt_downloadboot(MPT_ADAPTER *ioc, int sleepFlag)
 {
-	MpiFwHeader_t		*FwHdr;
-	MpiExtImageHeader_t 	*ExtHdr;
-	fw_image_t		**pCached=NULL;
-	int			 fw_sz;
+	MpiFwHeader_t		*pFwHeader;
+	MpiExtImageHeader_t	*pExtImage;
+	u32			 fwSize;
 	u32			 diag0val;
 #ifdef MPT_DEBUG
 	u32			 diag1val = 0;
 #endif
 	int			 count = 0;
-	u32			*ptru32;
+	u32			*ptrFw;
 	u32			 diagRwData;
 	u32			 nextImage;
-	u32			 ext_offset;
 	u32			 load_addr;
-	int			 max_idx, fw_idx, ext_idx;
-	int			 left_u32s;
+	u32 			 ioc_state;
 
-	ddlprintk((MYIOC_s_INFO_FMT "DbGb0: downloadboot entered.\n",
-				ioc->name));
-#ifdef MPT_DEBUG
-	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
-	if (ioc->alt_ioc)
-		diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
-	ddlprintk((MYIOC_s_INFO_FMT "DbGb1: diag0=%08x, diag1=%08x\n",
-				ioc->name, diag0val, diag1val));
-#endif
-
-	ddlprintk((MYIOC_s_INFO_FMT "fw size 0x%x, ioc FW Ptr %p\n",
+	ddlprintk((MYIOC_s_INFO_FMT "downloadboot: fw size 0x%x, ioc FW Ptr %p\n",
 				ioc->name, ioc->facts.FWImageSize, ioc->cached_fw));
-	if (ioc->alt_ioc)
-		ddlprintk((MYIOC_s_INFO_FMT "alt ioc FW Ptr %p\n",
-				ioc->name, ioc->alt_ioc->cached_fw));
 
 	/* Get dma_addr and data transfer size.
 	 */
-	if ((fw_sz = ioc->facts.FWImageSize) == 0)
+	if ( ioc->facts.FWImageSize == 0 )
 		return -1;
 
 	/* Get the DMA from ioc or ioc->alt_ioc */
-	if (ioc->cached_fw != NULL)
-		pCached = (fw_image_t **)ioc->cached_fw;
-	else if (ioc->alt_ioc && (ioc->alt_ioc->cached_fw != NULL))
-		pCached = (fw_image_t **)ioc->alt_ioc->cached_fw;
-	else
+	if (ioc->cached_fw == NULL)
 		return -2;
 
-	ddlprintk((MYIOC_s_INFO_FMT "DbGb2: FW Image @ %p\n",
-			ioc->name, pCached));
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_1ST_KEY_VALUE);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_2ND_KEY_VALUE);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_3RD_KEY_VALUE);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_4TH_KEY_VALUE);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_5TH_KEY_VALUE);
 
-	/* Write magic sequence to WriteSequence register
-	 * until enter diagnostic mode
-	 */
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
-	while ((diag0val & MPI_DIAG_DRWE) == 0) {
-		CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
-		CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_1ST_KEY_VALUE);
-		CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_2ND_KEY_VALUE);
-		CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_3RD_KEY_VALUE);
-		CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_4TH_KEY_VALUE);
-		CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_5TH_KEY_VALUE);
+	diag0val |= (MPI_DIAG_PREVENT_IOC_BOOT | MPI_DIAG_DISABLE_ARM);
+	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
 
-		/* wait 100 msec */
+	/* wait 100 msec */
+	if (sleepFlag == CAN_SLEEP) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(100 * HZ / 1000);
+	} else {
+		mdelay (100);
+	}
+
+	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val | MPI_DIAG_RESET_ADAPTER);
+
+	for (count = 0; count < 30; count ++) {
+		diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+		if (!(diag0val & MPI_DIAG_RESET_ADAPTER)) {
+			ddlprintk((MYIOC_s_INFO_FMT "RESET_ADAPTER cleared, count=%d\n",
+				ioc->name, count));
+			break;
+		}
+		/* wait 1 sec */
 		if (sleepFlag == CAN_SLEEP) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(100 * HZ / 1000);
+			schedule_timeout(HZ);
 		} else {
-			mdelay (100);
-		}
-
-		count++;
-		if (count > 20) {
-			printk(MYIOC_s_ERR_FMT "Enable Diagnostic mode FAILED! (%02xh)\n",
-					ioc->name, diag0val);
-			return -EFAULT;
-
+			mdelay (1000);
 		}
-
-		diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
-#ifdef MPT_DEBUG
-		if (ioc->alt_ioc)
-			diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
-		ddlprintk((MYIOC_s_INFO_FMT "DbGb3: diag0=%08x, diag1=%08x\n",
-				ioc->name, diag0val, diag1val));
-#endif
-		ddlprintk((MYIOC_s_INFO_FMT "Wrote magic DiagWriteEn sequence (%x)\n",
-				ioc->name, diag0val));
 	}
 
-	/* Set the DiagRwEn and Disable ARM bits */
-	diag0val |= (MPI_DIAG_RW_ENABLE | MPI_DIAG_DISABLE_ARM);
-	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
+	if ( count == 30 ) {
+		ddlprintk((MYIOC_s_INFO_FMT "downloadboot failed! Unable to RESET_ADAPTER diag0val=%x\n",
+		ioc->name, diag0val));
+		return -3;
+	}
 
-#ifdef MPT_DEBUG
-	if (ioc->alt_ioc)
-		diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_1ST_KEY_VALUE);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_2ND_KEY_VALUE);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_3RD_KEY_VALUE);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_4TH_KEY_VALUE);
+	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_5TH_KEY_VALUE);
 
-	ddlprintk((MYIOC_s_INFO_FMT "DbGb3: diag0=%08x, diag1=%08x\n",
-			ioc->name, diag0val, diag1val));
-#endif
+	/* Set the DiagRwEn and Disable ARM bits */
+	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+	CHIPREG_WRITE32(&ioc->chip->Diagnostic, (diag0val | MPI_DIAG_RW_ENABLE | MPI_DIAG_DISABLE_ARM));
 
-	/* max_idx = 1 + maximum valid buffer index
-	 */
-	max_idx = 0;
-	while (pCached[max_idx])
-		max_idx++;
-
-	fw_idx = 0;
-	FwHdr = (MpiFwHeader_t *) pCached[fw_idx]->fw;
-	ptru32 = (u32 *) FwHdr;
-	count = (FwHdr->ImageSize + 3)/4;
-	nextImage = FwHdr->NextImageHeaderOffset;
+	pFwHeader = (MpiFwHeader_t *) ioc->cached_fw;
+	fwSize = (pFwHeader->ImageSize + 3)/4;
+	ptrFw = (u32 *) pFwHeader;
 
 	/* Write the LoadStartAddress to the DiagRw Address Register
 	 * using Programmed IO
 	 */
-	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, FwHdr->LoadStartAddress);
+	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, pFwHeader->LoadStartAddress);
 	ddlprintk((MYIOC_s_INFO_FMT "LoadStart addr written 0x%x \n",
-		ioc->name, FwHdr->LoadStartAddress));
+		ioc->name, pFwHeader->LoadStartAddress));
 
-	ddlprintk((MYIOC_s_INFO_FMT "Write FW Image: 0x%x u32's @ %p\n",
-				ioc->name, count, ptru32));
-	left_u32s = pCached[fw_idx]->size/4;
-	while (count--) {
-		if (left_u32s == 0) {
-			fw_idx++;
-			if (fw_idx >= max_idx) {
-				/* FIXME
-				ERROR CASE
-				*/
-				;
-			}
-			ptru32 = (u32 *) pCached[fw_idx]->fw;
-			left_u32s = pCached[fw_idx]->size / 4;
-		}
-		left_u32s--;
-		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, *ptru32);
-		ptru32++;
+	ddlprintk((MYIOC_s_INFO_FMT "Write FW Image: 0x%x bytes @ %p\n",
+				ioc->name, fwSize*4, ptrFw));
+	while (fwSize--) {
+		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, *ptrFw++);
 	}
 
-	/* left_u32s, fw_idx and ptru32 are all valid
-	 */
+	nextImage = pFwHeader->NextImageHeaderOffset;
 	while (nextImage) {
-		ext_idx = 0;
-		ext_offset = nextImage;
-		while (ext_offset > pCached[ext_idx]->size) {
-			ext_idx++;
-			if (ext_idx >= max_idx) {
-				/* FIXME
-				ERROR CASE
-				*/
-				;
-			}
-			ext_offset -= pCached[ext_idx]->size;
-		}
-		ptru32 = (u32 *) ((char *)pCached[ext_idx]->fw + ext_offset);
-		left_u32s = pCached[ext_idx]->size - ext_offset;
+		pExtImage = (MpiExtImageHeader_t *) ((char *)pFwHeader + nextImage);
 
-		if ((left_u32s * 4) >= sizeof(MpiExtImageHeader_t)) {
-			ExtHdr = (MpiExtImageHeader_t *) ptru32;
-			count = (ExtHdr->ImageSize + 3 )/4;
-			nextImage = ExtHdr->NextImageHeaderOffset;
-			load_addr = ExtHdr->LoadStartAddress;
-		} else {
-			u32 * ptmp = (u32 *)pCached[ext_idx+1]->fw;
-
-			switch (left_u32s) {
-			case 5:
-				count = *(ptru32 + 2);
-				nextImage = *(ptru32 + 3);
-				load_addr = *(ptru32 + 4);
-				break;
-			case 4:
-				count = *(ptru32 + 2);
-				nextImage = *(ptru32 + 3);
-				load_addr = *ptmp;
-				break;
-			case 3:
-				count = *(ptru32 + 2);
-				nextImage = *ptmp;
-				load_addr = *(ptmp + 1);
-				break;
-			case 2:
-				count = *ptmp;
-				nextImage = *(ptmp + 1);
-				load_addr = *(ptmp + 2);
-				break;
-
-			case 1:
-				count = *(ptmp + 1);
-				nextImage = *(ptmp + 2);
-				load_addr = *(ptmp + 3);
-				break;
+		load_addr = pExtImage->LoadStartAddress;
 
-			default:
-				count = 0;
-				nextImage = 0;
-				load_addr = 0;
-				/* FIXME
-				ERROR CASE
-				*/
-				;
+		fwSize = (pExtImage->ImageSize + 3) >> 2;
+		ptrFw = (u32 *)pExtImage;
 
-			}
-			count = (count +3)/4;
-		}
-
-		ddlprintk((MYIOC_s_INFO_FMT "Write Ext Image: 0x%x u32's @ %p\n",
-						ioc->name, count, ptru32));
+		ddlprintk((MYIOC_s_INFO_FMT "Write Ext Image: 0x%x bytes @ %p load_addr=%x\n",
+						ioc->name, fwSize*4, ptrFw, load_addr));
 		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, load_addr);
 
-		while (count--) {
-			if (left_u32s == 0) {
-				fw_idx++;
-				if (fw_idx >= max_idx) {
-					/* FIXME
-					ERROR CASE
-					*/
-					;
-				}
-				ptru32 = (u32 *) pCached[fw_idx]->fw;
-				left_u32s = pCached[fw_idx]->size / 4;
-			}
-			left_u32s--;
-			CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, *ptru32);
-			ptru32++;
+		while (fwSize--) {
+			CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, *ptrFw++);
 		}
+		nextImage = pExtImage->NextImageHeaderOffset;
 	}
 
 	/* Write the IopResetVectorRegAddr */
-	ddlprintk((MYIOC_s_INFO_FMT "Write IopResetVector Addr! \n", ioc->name));
-	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, FwHdr->IopResetRegAddr);
+	ddlprintk((MYIOC_s_INFO_FMT "Write IopResetVector Addr=%x! \n", ioc->name, 	pFwHeader->IopResetRegAddr));
+	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, pFwHeader->IopResetRegAddr);
 
 	/* Write the IopResetVectorValue */
-	ddlprintk((MYIOC_s_INFO_FMT "Write IopResetVector Value! \n", ioc->name));
-	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, FwHdr->IopResetVectorValue);
+	ddlprintk((MYIOC_s_INFO_FMT "Write IopResetVector Value=%x! \n", ioc->name, pFwHeader->IopResetVectorValue));
+	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, pFwHeader->IopResetVectorValue);
+
+	/* clear the PREVENT_IOC_BOOT bit */
+	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+	ddlprintk((MYIOC_s_INFO_FMT "downloadboot diag0val=%x, turning off PREVENT_IOC_BOOT\n",
+		ioc->name, diag0val));
+	diag0val &= ~(MPI_DIAG_PREVENT_IOC_BOOT);
+	ddlprintk((MYIOC_s_INFO_FMT "downloadboot now diag0val=%x\n",
+		ioc->name, diag0val));
+	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
 
 	/* Clear the internal flash bad bit - autoincrementing register,
 	 * so must do two writes.
@@ -3300,15 +2979,63 @@
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, diagRwData);
 
-	/* clear the RW enable and DISARM bits */
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
-	diag0val &= ~(MPI_DIAG_DISABLE_ARM | MPI_DIAG_RW_ENABLE | MPI_DIAG_FLASH_BAD_SIG);
+	ddlprintk((MYIOC_s_INFO_FMT "downloadboot diag0val=%x, turning off DISABLE_ARM, RW_ENABLE, RESET_HISTORY\n",
+		ioc->name, diag0val));
+	diag0val &= ~(MPI_DIAG_DISABLE_ARM | MPI_DIAG_RW_ENABLE | MPI_DIAG_RESET_HISTORY);
+	ddlprintk((MYIOC_s_INFO_FMT "downloadboot now diag0val=%x\n",
+		ioc->name, diag0val));
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
 
+	/* wait 100 msec */
+	if (sleepFlag == CAN_SLEEP) {
+		ddlprintk((MYIOC_s_INFO_FMT "CAN_SLEEP 100 msec before reset the sequencer\n", ioc->name));
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(100 * HZ / 1000);
+	} else {
+		ddlprintk((MYIOC_s_INFO_FMT "mdelay 100 msec before reset the sequencer\n", ioc->name));
+		mdelay (100);
+	}
+
+	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+	if ( diag0val & (MPI_DIAG_FLASH_BAD_SIG | MPI_DIAG_DISABLE_ARM) ) {
+		ddlprintk((MYIOC_s_INFO_FMT "downloadboot failed, diag0val=%x FLASH_BAD_SIG | DISABLE_ARM on\n ",
+			ioc->name, diag0val));
+	}
 	/* Write 0xFF to reset the sequencer */
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
 
-	return 0;
+	for (count=0; count<HZ*20; count++) {
+		if ((ioc_state = mpt_GetIocState(ioc, 0)) & MPI_IOC_STATE_READY) {
+			ddlprintk((MYIOC_s_INFO_FMT "downloadboot successful! (count=%d) IocState=%x\n",
+					ioc->name, count, ioc_state));
+/*			if ((r = GetIocFacts(ioc, sleepFlag, MPT_HOSTEVENT_IOC_BRINGUP)) != 0) {
+				if ((r = GetIocFacts(ioc, sleepFlag, MPT_HOSTEVENT_IOC_BRINGUP)) != 0) {
+					ddlprintk((MYIOC_s_INFO_FMT "GetIocFacts failed\n",
+						ioc->name));
+						return -EFAULT;
+				}
+			} */
+			/* wait 2 sec */
+/*			if (sleepFlag == CAN_SLEEP) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				schedule_timeout(5000 * HZ / 1000);
+			} else {
+				mdelay (5000);
+			} */
+
+			return 0;
+		}
+		if (sleepFlag == CAN_SLEEP) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(1);
+		} else {
+			mdelay (10);
+		}
+	}
+	ddlprintk((MYIOC_s_INFO_FMT "downloadboot failed! IocState=%x\n",
+		ioc->name, ioc_state));
+	return -EFAULT;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -3344,7 +3071,7 @@
 	u32 ioc_state;
 	int cntdn, cnt = 0;
 
-	dprintk((KERN_WARNING MYNAM ": KickStarting %s!\n", ioc->name));
+	dinitprintk((KERN_WARNING MYNAM ": KickStarting %s!\n", ioc->name));
 	if ((int)ioc->chip_type > (int)FC929) {
 		/* Always issue a Msg Unit Reset first. This will clear some
 		 * SCSI bus hang conditions.
@@ -3593,6 +3320,7 @@
 		/* Write magic sequence to WriteSequence register
 		 * Loop until in diagnostic mode
 		 */
+		CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
 		CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_1ST_KEY_VALUE);
 		CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_2ND_KEY_VALUE);
 		CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_3RD_KEY_VALUE);
@@ -3672,7 +3400,7 @@
 	u32 state;
 	int cntdn, count;
 
-	dprintk((KERN_WARNING MYNAM ": %s: Sending IOC reset(0x%02x)!\n",
+	drsprintk((KERN_WARNING MYNAM ": %s: Sending IOC reset(0x%02x)!\n",
 			ioc->name, reset_type));
 	CHIPREG_WRITE32(&ioc->chip->Doorbell, reset_type<<MPI_DOORBELL_FUNCTION_SHIFT);
 	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0)
@@ -4011,6 +3739,9 @@
 		 */
 		if (!failcnt && (t = WaitForDoorbellReply(ioc, maxwait, sleepFlag)) < 0)
 			failcnt++;
+		
+		dhsprintk((MYIOC_s_INFO_FMT "HandShake reply count=%d%s\n",
+				ioc->name, t, failcnt ? " - MISSING DOORBELL REPLY!" : ""));
 
 		/*
 		 * Copy out the cached reply...
@@ -4042,7 +3773,7 @@
 {
 	int cntdn;
 	int count = 0;
-	u32 intstat;
+	u32 intstat=0;
 
 	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * howlong;
 
@@ -4066,13 +3797,13 @@
 	}
 
 	if (cntdn) {
-		dhsprintk((MYIOC_s_INFO_FMT "WaitForDoorbell ACK (cnt=%d)\n",
+		dprintk((MYIOC_s_INFO_FMT "WaitForDoorbell ACK (count=%d)\n",
 				ioc->name, count));
 		return count;
 	}
 
-	printk(MYIOC_s_ERR_FMT "Doorbell ACK timeout(%d)!\n",
-			ioc->name, (count+5)/HZ);
+	printk(MYIOC_s_ERR_FMT "Doorbell ACK timeout (count=%d), IntStatus=%x!\n",
+			ioc->name, count, intstat);
 	return -1;
 }
 
@@ -4093,7 +3824,7 @@
 {
 	int cntdn;
 	int count = 0;
-	u32 intstat;
+	u32 intstat=0;
 
 	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * howlong;
 	if (sleepFlag == CAN_SLEEP) {
@@ -4116,13 +3847,13 @@
 	}
 
 	if (cntdn) {
-		dhsprintk((MYIOC_s_INFO_FMT "WaitForDoorbell INT (cnt=%d)\n",
-				ioc->name, count));
+		dprintk((MYIOC_s_INFO_FMT "WaitForDoorbell INT (cnt=%d) howlong=%d\n",
+				ioc->name, count, howlong));
 		return count;
 	}
 
-	printk(MYIOC_s_ERR_FMT "Doorbell INT timeout(%d)!\n",
-			ioc->name, (count+5)/HZ);
+	printk(MYIOC_s_ERR_FMT "Doorbell INT timeout (count=%d), IntStatus=%x!\n",
+			ioc->name, count, intstat);
 	return -1;
 }
 
@@ -4168,8 +3899,8 @@
 		}
 	}
 
-	dhsprintk((MYIOC_s_INFO_FMT "First handshake reply word=%08x%s\n",
-			ioc->name, le32_to_cpu(*(u32 *)hs_reply),
+	dhsprintk((MYIOC_s_INFO_FMT "WaitCnt=%d First handshake reply word=%08x%s\n",
+			ioc->name, t, le32_to_cpu(*(u32 *)hs_reply), 
 			failcnt ? " - MISSING DOORBELL HANDSHAKE!" : ""));
 
 	/*
@@ -4207,8 +3938,8 @@
 	dmfprintk((MYIOC_s_INFO_FMT "Got Handshake reply:\n", ioc->name));
 	DBG_DUMP_REPLY_FRAME(mptReply)
 
-	dhsprintk((MYIOC_s_INFO_FMT "WaitForDoorbell REPLY (sz=%d)\n",
-			ioc->name, u16cnt/2));
+	dhsprintk((MYIOC_s_INFO_FMT "WaitForDoorbell REPLY WaitCnt=%d (sz=%d)\n",
+			ioc->name, t, u16cnt/2));
 	return u16cnt/2;
 }
 
@@ -5000,7 +4731,7 @@
 {
 	EventNotification_t	*evnp;
 
-	evnp = (EventNotification_t *) mpt_get_msg_frame(mpt_base_index, ioc->id);
+	evnp = (EventNotification_t *) mpt_get_msg_frame(mpt_base_index, ioc);
 	if (evnp == NULL) {
 		dprintk((MYIOC_s_WARN_FMT "Unable to allocate event request frame!\n",
 				ioc->name));
@@ -5015,7 +4746,7 @@
 	evnp->MsgFlags = 0;
 	evnp->Switch = EvSwitch;
 
-	mpt_put_msg_frame(mpt_base_index, ioc->id, (MPT_FRAME_HDR *)evnp);
+	mpt_put_msg_frame(mpt_base_index, ioc, (MPT_FRAME_HDR *)evnp);
 
 	return 0;
 }
@@ -5031,7 +4762,7 @@
 {
 	EventAck_t	*pAck;
 
-	if ((pAck = (EventAck_t *) mpt_get_msg_frame(mpt_base_index, ioc->id)) == NULL) {
+	if ((pAck = (EventAck_t *) mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
 		printk(MYIOC_s_WARN_FMT "Unable to allocate event ACK request frame!\n",
 				ioc->name);
 		return -1;
@@ -5046,7 +4777,7 @@
 	pAck->Event        = evnp->Event;
 	pAck->EventContext = evnp->EventContext;
 
-	mpt_put_msg_frame(mpt_base_index, ioc->id, (MPT_FRAME_HDR *)pAck);
+	mpt_put_msg_frame(mpt_base_index, ioc, (MPT_FRAME_HDR *)pAck);
 
 	return 0;
 }
@@ -5072,7 +4803,7 @@
 	MPT_FRAME_HDR	*mf;
 	unsigned long	 flags;
 	int		 ii, rc;
-	int		 flagsLength;
+	u32		 flagsLength;
 	int		 in_isr;
 
 	/* (Bugzilla:fibrebugs, #513)
@@ -5089,7 +4820,7 @@
 
 	/* Get and Populate a free Frame
 	 */
-	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc->id)) == NULL) {
+	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
 		dcprintk((MYIOC_s_WARN_FMT "mpt_config: no msg frames!\n",
 				ioc->name));
 		return -EAGAIN;
@@ -5148,7 +4879,7 @@
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 	add_timer(&pCfg->timer);
-	mpt_put_msg_frame(mpt_base_index, ioc->id, mf);
+	mpt_put_msg_frame(mpt_base_index, ioc, mf);
 	wait_event(mpt_waitq, pCfg->wait_done);
 
 	/* mf has been freed - do not access */
@@ -5176,10 +4907,11 @@
 mpt_toolbox(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 {
 	ToolboxIstwiReadWriteRequest_t	*pReq;
+	struct pci_dev	*pdev;
 	MPT_FRAME_HDR	*mf;
 	unsigned long	 flags;
 	int		 rc;
-	int		 flagsLength;
+	u32		 flagsLength;
 	int		 in_isr;
 
 	/* (Bugzilla:fibrebugs, #513)
@@ -5196,7 +4928,7 @@
 
 	/* Get and Populate a free Frame
 	 */
-	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc->id)) == NULL) {
+	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
 		dcprintk((MYIOC_s_WARN_FMT "mpt_toolbox: no msg frames!\n",
 				ioc->name));
 		return -EAGAIN;
@@ -5215,7 +4947,11 @@
 	pReq->NumAddressBytes = 0x01;
 	pReq->Reserved4 = 0;
 	pReq->DataLength = 0x04;
-	pReq->DeviceAddr = 0xB0;
+	pdev = (struct pci_dev *) ioc->pcidev;
+	if (pdev->devfn & 1)
+		pReq->DeviceAddr = 0xB2;
+	else
+		pReq->DeviceAddr = 0xB0;
 	pReq->Addr1 = 0;
 	pReq->Addr2 = 0;
 	pReq->Addr3 = 0;
@@ -5254,7 +4990,7 @@
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 	add_timer(&pCfg->timer);
-	mpt_put_msg_frame(mpt_base_index, ioc->id, mf);
+	mpt_put_msg_frame(mpt_base_index, ioc, mf);
 	wait_event(mpt_waitq, pCfg->wait_done);
 
 	/* mf has been freed - do not access */
@@ -5368,61 +5104,19 @@
 static int
 procmpt_create(void)
 {
-	MPT_ADAPTER		*ioc;
 	struct proc_dir_entry	*ent;
-	int	 ii;
 
-	/*
-	 *	BEWARE: If/when MPT_PROCFS_MPTBASEDIR changes from "mpt"
-	 *	(single level) to multi level (e.g. "driver/message/fusion")
-	 *	something here needs to change.  -sralston
-	 */
 	mpt_proc_root_dir = proc_mkdir(MPT_PROCFS_MPTBASEDIR, NULL);
 	if (mpt_proc_root_dir == NULL)
 		return -ENOTDIR;
 
-	for (ii=0; ii < MPT_PROC_ENTRIES; ii++) {
-		ent = create_proc_entry(mpt_proc_list[ii].name,
-				S_IFREG|S_IRUGO, mpt_proc_root_dir);
-		if (!ent) {
-			printk(KERN_WARNING MYNAM
-					": WARNING - Could not create /proc/mpt/%s entry\n",
-					mpt_proc_list[ii].name);
-			continue;
-		}
-		ent->read_proc = mpt_proc_list[ii].f;
-		ent->data      = NULL;
-	}
-
-	ioc = mpt_adapter_find_first();
-	while (ioc != NULL) {
-		struct proc_dir_entry	*dent;
-		/*
-		 *  Create "/proc/mpt/iocN" subdirectory entry for each MPT adapter.
-		 */
-		if ((dent = proc_mkdir(ioc->name, mpt_proc_root_dir)) != NULL) {
-			/*
-			 *  And populate it with mpt_ioc_proc_list[] entries.
-			 */
-			for (ii=0; ii < MPT_IOC_PROC_ENTRIES; ii++) {
-				ent = create_proc_entry(mpt_ioc_proc_list[ii].name,
-						S_IFREG|S_IRUGO, dent);
-				if (!ent) {
-					printk(KERN_WARNING MYNAM
-							": WARNING - Could not create /proc/mpt/%s/%s entry!\n",
-							ioc->name,
-							mpt_ioc_proc_list[ii].name);
-					continue;
-				}
-				ent->read_proc = mpt_ioc_proc_list[ii].f;
-				ent->data      = ioc;
-			}
-		} else {
-			printk(MYIOC_s_WARN_FMT "Could not create /proc/mpt/%s subdir entry!\n",
-					ioc->name, mpt_ioc_proc_list[ii].name);
-		}
-		ioc = mpt_adapter_find_next(ioc);
-	}
+	ent = create_proc_entry("summary", S_IFREG|S_IRUGO, mpt_proc_root_dir);
+	if (ent)
+		ent->read_proc = procmpt_summary_read;
+
+	ent = create_proc_entry("version", S_IFREG|S_IRUGO, mpt_proc_root_dir);
+	if (ent)
+		ent->read_proc = procmpt_version_read;
 
 	return 0;
 }
@@ -5433,49 +5127,12 @@
  *
  *	Returns 0 for success, non-zero for failure.
  */
-static int
+static void
 procmpt_destroy(void)
 {
-	MPT_ADAPTER	*ioc;
-	int		 ii;
-
-	if (!mpt_proc_root_dir)
-		return 0;
-
-	/*
-	 *	BEWARE: If/when MPT_PROCFS_MPTBASEDIR changes from "mpt"
-	 *	(single level) to multi level (e.g. "driver/message/fusion")
-	 *	something here needs to change.  -sralston
-	 */
-
-	ioc = mpt_adapter_find_first();
-	while (ioc != NULL) {
-		char pname[32];
-		int namelen;
-
-		namelen = sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s", ioc->name);
-
-		/*
-		 *  Tear down each "/proc/mpt/iocN" subdirectory.
-		 */
-		for (ii=0; ii < MPT_IOC_PROC_ENTRIES; ii++) {
-			(void) sprintf(pname+namelen, "/%s", mpt_ioc_proc_list[ii].name);
-			remove_proc_entry(pname, NULL);
-		}
-		remove_proc_entry(ioc->name, mpt_proc_root_dir);
-		ioc = mpt_adapter_find_next(ioc);
-	}
-
-	for (ii=0; ii < MPT_PROC_ENTRIES; ii++)
-		remove_proc_entry(mpt_proc_list[ii].name, mpt_proc_root_dir);
-
-	if (atomic_read((atomic_t *)&mpt_proc_root_dir->count) == 0) {
-		remove_proc_entry(MPT_PROCFS_MPTBASEDIR, NULL);
-		mpt_proc_root_dir = NULL;
-		return 0;
-	}
-
-	return -1;
+	remove_proc_entry("version", mpt_proc_root_dir);
+	remove_proc_entry("summary", mpt_proc_root_dir);
+	remove_proc_entry(MPT_PROCFS_MPTBASEDIR, NULL);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -5498,26 +5155,25 @@
 	char *out = buf;
 	int len;
 
-	if (data == NULL)
-		ioc = mpt_adapter_find_first();
-	else
+	if (data) {
 		ioc = data;
-
-	while (ioc) {
 		int	more = 0;
 
 		mpt_print_ioc_summary(ioc, out, &more, 0, 1);
 
 		out += more;
-		if ((out-buf) >= request) {
-			break;
-		}
+	} else {
+		list_for_each_entry(ioc, &ioc_list, list) {
+			int	more = 0;
 
-		if (data == NULL)
-			ioc = mpt_adapter_find_next(ioc);
-		else
-			ioc = NULL;		/* force exit for iocN */
+			mpt_print_ioc_summary(ioc, out, &more, 0, 1);
+
+			out += more;
+			if ((out-buf) >= request)
+				break;
+		}
 	}
+
 	len = out - buf;
 
 	MPT_PROC_READ_RETURN(buf,start,offset,request,eof,len);
@@ -6295,7 +5951,7 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
-EXPORT_SYMBOL(mpt_adapters);
+EXPORT_SYMBOL(ioc_list);
 EXPORT_SYMBOL(mpt_proc_root_dir);
 EXPORT_SYMBOL(DmpService);
 EXPORT_SYMBOL(mpt_register);
@@ -6313,8 +5969,6 @@
 EXPORT_SYMBOL(mpt_add_chain);
 EXPORT_SYMBOL(mpt_send_handshake_request);
 EXPORT_SYMBOL(mpt_handshake_req_reply_wait);
-EXPORT_SYMBOL(mpt_adapter_find_first);
-EXPORT_SYMBOL(mpt_adapter_find_next);
 EXPORT_SYMBOL(mpt_verify_adapter);
 EXPORT_SYMBOL(mpt_GetIocState);
 EXPORT_SYMBOL(mpt_print_ioc_summary);
@@ -6369,7 +6023,6 @@
 	show_mptmod_ver(my_NAME, my_VERSION);
 	printk(KERN_INFO COPYRIGHT "\n");
 
-	Q_INIT(&MptAdapters, MPT_ADAPTER);			/* set to empty */
 	for (i = 0; i < MPT_MAX_PROTOCOL_DRIVERS; i++) {
 		MptCallbacks[i] = NULL;
 		MptDriverClass[i] = MPTUNKNOWN_DRIVER;
@@ -6393,13 +6046,12 @@
 		/* FIXME! */
 	}
 
-	r = pci_module_init(&mptbase_driver);
-	if(r)
-		return(r);
-
 #ifdef CONFIG_PROC_FS
 	(void) procmpt_create();
 #endif
+	r = pci_module_init(&mptbase_driver);
+	if(r)
+		return(r);
 
 	return r;
 }
@@ -6415,16 +6067,14 @@
 fusion_exit(void)
 {
 
-	dprintk((KERN_INFO MYNAM ": fusion_exit() called!\n"));
+	dexitprintk((KERN_INFO MYNAM ": fusion_exit() called!\n"));
 
-	/* Whups?  20010120 -sralston
-	 *  Moved this *above* removal of all MptAdapters!
-	 */
-#ifdef CONFIG_PROC_FS
-	(void) procmpt_destroy();
-#endif
 	pci_unregister_driver(&mptbase_driver);
 	mpt_reset_deregister(mpt_base_index);
+
+#ifdef CONFIG_PROC_FS
+	procmpt_destroy();
+#endif
 }
 
 
===== drivers/message/fusion/mptbase.h 1.22 vs edited =====
--- 1.22/drivers/message/fusion/mptbase.h	2004-05-29 17:10:51 +02:00
+++ edited/drivers/message/fusion/mptbase.h	2004-06-23 16:48:43 +02:00
@@ -85,8 +85,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.01.07"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.07"
+#define MPT_LINUX_VERSION_COMMON	"3.01.09"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.09"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -581,13 +581,6 @@
 	u8		 rsvd[1];
 } ScsiCfgData;
 
-typedef struct _fw_image {
-	char		*fw;
-	dma_addr_t	 fw_dma;
-	u32		 size;
-	u32		 rsvd;
-} fw_image_t;
-
 /*
  *  Adapter Structure - pci_dev specific. Maximum: MPT_MAX_ADAPTERS
  */
@@ -659,9 +652,9 @@
 	int			timeout_maxcnt;
 #endif
 	struct _mpt_ioctl_events *events;	/* pointer to event log */
-	fw_image_t		**cached_fw;	/* Pointer to FW SG List */
+	u8			*cached_fw;	/* Pointer to FW */
+	dma_addr_t	 	cached_fw_dma;
 	Q_TRACKER		 configQ;	/* linked list of config. requests */
-	int			 num_fw_frags;	/* Number of SGE in FW SG List */
 	int			 hs_reply_idx;
 #ifndef MFCNT
 	u32			 pad0;
@@ -682,6 +675,7 @@
 	u8			 upload_fw;	/* If set, do a fw upload */
 	u8			 reload_fw;	/* Force a FW Reload on next reset */
 	u8			 pad1[5];
+	struct list_head	 list; 
 } MPT_ADAPTER;
 
 
@@ -742,6 +736,33 @@
 #define dprintk(x)
 #endif
 
+#ifdef MPT_DEBUG_INIT
+#define dinitprintk(x)  printk x
+#define DBG_DUMP_FW_REQUEST_FRAME(mfp) \
+	{	int  i, n = 10;						\
+		u32 *m = (u32 *)(mfp);					\
+		printk(KERN_INFO " ");					\
+		for (i=0; i<n; i++)					\
+			printk(" %08x", le32_to_cpu(m[i]));		\
+		printk("\n");						\
+	}
+#else
+#define dinitprintk(x)
+#define DBG_DUMP_FW_REQUEST_FRAME(mfp)
+#endif
+
+#ifdef MPT_DEBUG_EXIT
+#define dexitprintk(x)  printk x
+#else
+#define dexitprintk(x)
+#endif
+
+#ifdef MPT_DEBUG_RESET
+#define drsprintk(x)  printk x
+#else
+#define drsprintk(x)
+#endif
+
 #ifdef MPT_DEBUG_HANDSHAKE
 #define dhsprintk(x)  printk x
 #else
@@ -975,19 +996,6 @@
 	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];
 } MPT_SCSI_HOST;
 
-/*
- *	Structure for overlaying onto scsi_cmnd->SCp area
- *	NOTE: SCp area is 36 bytes min, 44 bytes max?
- */
-typedef struct _scPrivate {
-	struct scsi_cmnd	*forw;
-	struct scsi_cmnd	*back;
-	void			*p1;
-	void			*p2;
-	u8			 io_path_id;	/* DMP */
-	u8			 pad[7];
-} scPrivate;
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	More Dynamic Multi-Pathing stuff...
@@ -1049,31 +1057,29 @@
 extern void	 mpt_device_driver_deregister(int cb_idx);
 extern int	 mpt_register_ascqops_strings(void *ascqTable, int ascqtbl_sz, const char **opsTable);
 extern void	 mpt_deregister_ascqops_strings(void);
-extern MPT_FRAME_HDR	*mpt_get_msg_frame(int handle, int iocid);
-extern void	 mpt_free_msg_frame(int handle, int iocid, MPT_FRAME_HDR *mf);
-extern void	 mpt_put_msg_frame(int handle, int iocid, MPT_FRAME_HDR *mf);
+extern MPT_FRAME_HDR	*mpt_get_msg_frame(int handle, MPT_ADAPTER *ioc);
+extern void	 mpt_free_msg_frame(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
+extern void	 mpt_put_msg_frame(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 extern void	 mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr);
 extern void	 mpt_add_chain(char *pAddr, u8 next, u16 length, dma_addr_t dma_addr);
 
-extern int	 mpt_send_handshake_request(int handle, int iocid, int reqBytes, u32 *req, int sleepFlag);
+extern int	 mpt_send_handshake_request(int handle, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag);
 extern int	 mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes, u32 *req, int replyBytes, u16 *u16reply, int maxwait, int sleepFlag);
 extern int	 mpt_verify_adapter(int iocid, MPT_ADAPTER **iocpp);
-extern MPT_ADAPTER	*mpt_adapter_find_first(void);
-extern MPT_ADAPTER	*mpt_adapter_find_next(MPT_ADAPTER *prev);
 extern u32	 mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);
 extern void	 mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buf, int *size, int len, int showlan);
 extern int	 mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
 extern int	 mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *cfg);
 extern int	 mpt_toolbox(MPT_ADAPTER *ioc, CONFIGPARMS *cfg);
-extern void	*mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size, int *frags, int *alloc_sz);
-extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc, fw_image_t **alt_img);
+extern void	 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size);
+extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
 extern int	 mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);
 
 /*
  *  Public data decl's...
  */
-extern MPT_ADAPTER	 	*mpt_adapters[MPT_MAX_ADAPTERS];
+extern struct list_head	  ioc_list;
 extern struct proc_dir_entry	*mpt_proc_root_dir;
 extern DmpServices_t		*DmpService;
 
===== drivers/message/fusion/mptctl.c 1.23 vs edited =====
--- 1.23/drivers/message/fusion/mptctl.c	2004-06-19 17:24:45 +02:00
+++ edited/drivers/message/fusion/mptctl.c	2004-06-23 16:57:56 +02:00
@@ -87,10 +87,11 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
-#include <linux/kdev_t.h>	/* needed for access to Scsi_Host struct */
-#include <linux/blkdev.h>
-#include "../../scsi/scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 
 #define COPYRIGHT	"Copyright (c) 1999-2004 LSI Logic Corporation"
 #define MODULEAUTHOR	"Steven J. Ralston, Noah Romer, Pamela Delaney"
@@ -399,7 +400,7 @@
 
 	/* Send request
 	 */
-	if ((mf = mpt_get_msg_frame(mptctl_id, ioctl->ioc->id)) == NULL) {
+	if ((mf = mpt_get_msg_frame(mptctl_id, ioctl->ioc)) == NULL) {
 		dctlprintk((MYIOC_s_WARN_FMT "IssueTaskMgmt, no msg frames!!\n",
 				ioctl->ioc->name));
 
@@ -434,7 +435,7 @@
 	ioctl->status |= MPT_IOCTL_STATUS_TMTIMER_ACTIVE;
 	add_timer(&ioctl->TMtimer);
 
-	retval = mpt_send_handshake_request(mptctl_id, ioctl->ioc->id,
+	retval = mpt_send_handshake_request(mptctl_id, ioctl->ioc,
 			sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, NO_SLEEP);
 
 	if (retval != 0) {
@@ -443,7 +444,7 @@
 
 		mptctl_free_tm_flags(ioctl->ioc);
 		del_timer(&ioctl->TMtimer);
-		mpt_free_msg_frame(mptctl_id, ioctl->ioc->id, mf);
+		mpt_free_msg_frame(mptctl_id, ioctl->ioc, mf);
 		ioctl->tmPtr = NULL;
 	}
 
@@ -518,7 +519,7 @@
 		if (ioctl && (ioctl->status & MPT_IOCTL_STATUS_TMTIMER_ACTIVE)){
 			ioctl->status &= ~MPT_IOCTL_STATUS_TMTIMER_ACTIVE;
 			del_timer(&ioctl->TMtimer);
-			mpt_free_msg_frame(mptctl_id, ioc->id, ioctl->tmPtr);
+			mpt_free_msg_frame(mptctl_id, ioc, ioctl->tmPtr);
 		}
 
 	} else {
@@ -750,7 +751,7 @@
 
 	/*  Valid device. Get a message frame and construct the FW download message.
 	 */
-	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL)
+	if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
 		return -EAGAIN;
 	dlmsg = (FWDownload_t*) mf;
 	ptsge = (FWDownloadTCSGE_t *) &dlmsg->SGL;
@@ -866,7 +867,7 @@
 	 * Finally, perform firmware download.
 	 */
 	ReplyMsg = NULL;
-	mpt_put_msg_frame(mptctl_id, ioc, mf);
+	mpt_put_msg_frame(mptctl_id, iocp, mf);
 
 	/*
 	 *  Wait until the reply has been received
@@ -1317,6 +1318,7 @@
 	char			*pmem;
 	int			*pdata;
 	IOCPage2_t		*pIoc2;
+	IOCPage3_t		*pIoc3;
 	int			iocnum;
 	int			numDevices = 0;
 	unsigned int		max_id;
@@ -1393,53 +1395,57 @@
 		if (hd && hd->Targets) {
 			mpt_findImVolumes(ioc);
 			pIoc2 = ioc->spi_data.pIocPg2;
-			for ( id = 0; id <= max_id; id++ ) {
-				if ( pIoc2 && pIoc2->NumActiveVolumes &&
-					( id == pIoc2->RaidVolume[0].VolumeID ) ) {
-					if (maxWordsLeft <= 0) {
-						printk(KERN_ERR "mptctl_gettargetinfo - "
+			for ( id = 0; id <= max_id; ) {
+				if ( pIoc2 && pIoc2->NumActiveVolumes ) {
+					if ( id == pIoc2->RaidVolume[0].VolumeID ) {
+						if (maxWordsLeft <= 0) {
+							printk(KERN_ERR "mptctl_gettargetinfo - "
 			"buffer is full but volume is available on ioc %d\n, numDevices=%d", iocnum, numDevices);
-						goto data_space_full;
-					}
-                    			if ( ( pIoc2->RaidVolume[0].Flags & MPI_IOCPAGE2_FLAG_VOLUME_INACTIVE ) == 0 )
-                        			devType = 0x80;
-                    			else
-                        			devType = 0xC0;
-					bus_id = pIoc2->RaidVolume[0].VolumeBus;
-	            			numDevices++;
-                    			*pdata = ( (devType << 24) | (bus_id << 8) | id );
-					dctlprintk((KERN_ERR "mptctl_gettargetinfo - "
+							goto data_space_full;
+						}
+						if ( ( pIoc2->RaidVolume[0].Flags & MPI_IOCPAGE2_FLAG_VOLUME_INACTIVE ) == 0 )
+                        				devType = 0x80;
+                    				else
+                        				devType = 0xC0;
+						bus_id = pIoc2->RaidVolume[0].VolumeBus;
+	            				numDevices++;
+                    				*pdata = ( (devType << 24) | (bus_id << 8) | id );
+						dctlprintk((KERN_ERR "mptctl_gettargetinfo - "
 		"volume ioc=%d target=%x numDevices=%d pdata=%p\n", iocnum, *pdata, numDevices, pdata));
-                    			pdata++;
-					--maxWordsLeft;
-            			} else {
-					vdev = hd->Targets[id];
-					if (vdev) {
-						for (jj = 0; jj <= MPT_LAST_LUN; jj++) {
-							lun_index = (jj >> 5);
-							indexed_lun = (jj % 32);
-							lun = (1 << indexed_lun);
-							if (vdev->luns[lun_index] & lun) {
-								if (maxWordsLeft <= 0) {
-									printk(KERN_ERR
-									"mptctl_gettargetinfo - "
-									"buffer is full but more targets are available on ioc %d numDevices=%d\n",
-									iocnum, numDevices);
-									goto data_space_full;
-								}
-								bus_id = vdev->bus_id;
-								numDevices++;
-                            					*pdata = ( (jj << 16) | (bus_id << 8) | id );
-								dctlprintk((KERN_ERR
-								 "mptctl_gettargetinfo - "
-								 "target ioc=%d target=%x numDevices=%d pdata=%p\n",
-								 iocnum, *pdata, numDevices, pdata));
-								pdata++;
-								--maxWordsLeft;
+                    				pdata++;
+						--maxWordsLeft;
+						goto next_id;
+					} else {
+						pIoc3 = ioc->spi_data.pIocPg3;
+            					for ( jj = 0; jj < pIoc3->NumPhysDisks; jj++ ) {
+                    					if ( pIoc3->PhysDisk[jj].PhysDiskID == id )
+								goto next_id;
+						}
+					}
+				}
+				if ( (vdev = hd->Targets[id]) ) {
+					for (jj = 0; jj <= MPT_LAST_LUN; jj++) {
+						lun_index = (jj >> 5);
+						indexed_lun = (jj % 32);
+						lun = (1 << indexed_lun);
+						if (vdev->luns[lun_index] & lun) {
+							if (maxWordsLeft <= 0) {
+								printk(KERN_ERR "mptctl_gettargetinfo - "
+			"buffer is full but more targets are available on ioc %d numDevices=%d\n", iocnum, numDevices);
+								goto data_space_full;
 							}
+							bus_id = vdev->bus_id;
+							numDevices++;
+                            				*pdata = ( (jj << 16) | (bus_id << 8) | id );
+							dctlprintk((KERN_ERR "mptctl_gettargetinfo - "
+		"target ioc=%d target=%x numDevices=%d pdata=%p\n", iocnum, *pdata, numDevices, pdata));
+							pdata++;
+							--maxWordsLeft;
 						}
 					}
 				}
+next_id:
+				id++;
 			}
 		}
 	}
@@ -1681,12 +1687,8 @@
 	struct mpt_ioctl_replace_fw	*uarg = (struct mpt_ioctl_replace_fw *) arg;
 	struct mpt_ioctl_replace_fw	 karg;
 	MPT_ADAPTER		 *ioc;
-	fw_image_t		 **fwmem = NULL;
 	int			 iocnum;
 	int			 newFwSize;
-	int			 num_frags, alloc_sz;
-	int			 ii;
-	u32			 offset;
 
 	dctlprintk(("mptctl_replace_fw called.\n"));
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_replace_fw))) {
@@ -1703,52 +1705,39 @@
 		return -ENODEV;
 	}
 
-	/* If not caching FW, return 0
+	/* If caching FW, Free the old FW image
 	 */
-	if ((ioc->cached_fw == NULL) && (ioc->alt_ioc) && (ioc->alt_ioc->cached_fw == NULL))
+	if (ioc->cached_fw == NULL)
 		return 0;
 
+	mpt_free_fw_memory(ioc);
+
 	/* Allocate memory for the new FW image
 	 */
 	newFwSize = karg.newImageSize;
-	fwmem = mpt_alloc_fw_memory(ioc, newFwSize, &num_frags, &alloc_sz);
-	if (fwmem == NULL)
-		return -ENOMEM;
 
-	offset = 0;
-	for (ii = 0; ii < num_frags; ii++) {
-		/* Copy the data from user memory to kernel space
-		 */
-		if (copy_from_user(fwmem[ii]->fw, uarg->newImage + offset, fwmem[ii]->size)) {
-			printk(KERN_ERR "%s@%d::mptctl_replace_fw - "
-				"Unable to read in mpt_ioctl_replace_fw image @ %p\n",
-					__FILE__, __LINE__, (void*)uarg);
-
-			mpt_free_fw_memory(ioc, fwmem);
-			return -EFAULT;
-		}
-		offset += fwmem[ii]->size;
-	}
+	if (newFwSize & 0x01)
+		newFwSize += 1;
+	if (newFwSize & 0x02)
+		newFwSize += 2;
 
+	mpt_alloc_fw_memory(ioc, newFwSize);
+	if (ioc->cached_fw == NULL)
+		return -ENOMEM;
 
-	/* Free the old FW image
+	/* Copy the data from user memory to kernel space
 	 */
-	if (ioc->cached_fw) {
-		mpt_free_fw_memory(ioc, 0);
-		ioc->cached_fw = fwmem;
-		ioc->alloc_total += alloc_sz;
-	} else if ((ioc->alt_ioc) && (ioc->alt_ioc->cached_fw)) {
-		mpt_free_fw_memory(ioc->alt_ioc, 0);
-		ioc->alt_ioc->cached_fw = fwmem;
-		ioc->alt_ioc->alloc_total += alloc_sz;
+	if (copy_from_user(ioc->cached_fw, uarg->newImage, newFwSize)) {
+		printk(KERN_ERR "%s@%d::mptctl_replace_fw - "
+				"Unable to read in mpt_ioctl_replace_fw image "
+				"@ %p\n", __FILE__, __LINE__, uarg);
+		mpt_free_fw_memory(ioc);
+		return -EFAULT;
 	}
 
 	/* Update IOCFactsReply
 	 */
 	ioc->facts.FWImageSize = newFwSize;
-	if (ioc->alt_ioc)
-		ioc->alt_ioc->facts.FWImageSize = newFwSize;
-
 	return 0;
 }
 
@@ -1862,7 +1851,7 @@
 
 	/* Get a free request frame and save the message context.
 	 */
-        if ((mf = mpt_get_msg_frame(mptctl_id, ioc->id)) == NULL)
+        if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL)
                 return -EAGAIN;
 
 	hdr = (MPIHeader_t *) mf;
@@ -2214,7 +2203,7 @@
 	add_timer(&ioc->ioctl->timer);
 
 	if (hdr->Function == MPI_FUNCTION_SCSI_TASK_MGMT) {
-		rc = mpt_send_handshake_request(mptctl_id, ioc->id,
+		rc = mpt_send_handshake_request(mptctl_id, ioc,
 				sizeof(SCSITaskMgmt_t), (u32*)mf, CAN_SLEEP);
 		if (rc == 0) {
 			wait_event(mptctl_wait, ioc->ioctl->wait_done);
@@ -2224,10 +2213,10 @@
 			del_timer(&ioc->ioctl->timer);
 			ioc->ioctl->status &= ~MPT_IOCTL_STATUS_TIMER_ACTIVE;
 			ioc->ioctl->status |= MPT_IOCTL_STATUS_TM_FAILED;
-			mpt_free_msg_frame(mptctl_id, ioc->id, mf);
+			mpt_free_msg_frame(mptctl_id, ioc, mf);
 		}
 	} else {
-		mpt_put_msg_frame(mptctl_id, ioc->id, mf);
+		mpt_put_msg_frame(mptctl_id, ioc, mf);
 		wait_event(mptctl_wait, ioc->ioctl->wait_done);
 	}
 
@@ -2342,7 +2331,7 @@
 	 * otherwise, failure occured after mf acquired.
 	 */
 	if (mf)
-		mpt_free_msg_frame(mptctl_id, ioc->id, mf);
+		mpt_free_msg_frame(mptctl_id, ioc, mf);
 
 	return rc;
 }
===== drivers/message/fusion/mptlan.c 1.17 vs edited =====
--- 1.17/drivers/message/fusion/mptlan.c	2004-05-29 17:10:51 +02:00
+++ edited/drivers/message/fusion/mptlan.c	2004-06-23 16:48:44 +02:00
@@ -502,7 +502,7 @@
 	LANResetRequest_t *pResetReq;
 	struct mpt_lan_priv *priv = netdev_priv(dev);
 
-	mf = mpt_get_msg_frame(LanCtx, priv->mpt_dev->id);
+	mf = mpt_get_msg_frame(LanCtx, priv->mpt_dev);
 
 	if (mf == NULL) {
 /*		dlprintk((KERN_ERR MYNAM "/reset: Evil funkiness abounds! "
@@ -520,7 +520,7 @@
 	pResetReq->MsgFlags	= 0;
 	pResetReq->Reserved2	= 0;
 
-	mpt_put_msg_frame(LanCtx, priv->mpt_dev->id, mf);
+	mpt_put_msg_frame(LanCtx, priv->mpt_dev, mf);
 
 	return 0;
 }
@@ -754,7 +754,7 @@
 		return 1;
 	}
 
-	mf = mpt_get_msg_frame(LanCtx, mpt_dev->id);
+	mf = mpt_get_msg_frame(LanCtx, mpt_dev);
 	if (mf == NULL) {
 		netif_stop_queue(dev);
 		spin_unlock_irqrestore(&priv->txfidx_lock, flags);
@@ -859,7 +859,7 @@
 	else
 		pSimple->Address.High = 0;
 
-	mpt_put_msg_frame (LanCtx, mpt_dev->id, mf);
+	mpt_put_msg_frame (LanCtx, mpt_dev, mf);
 	dev->trans_start = jiffies;
 
 	dioprintk((KERN_INFO MYNAM ": %s/%s: Sending packet. FlagsLength = %08x.\n",
@@ -1244,7 +1244,7 @@
 			(MPT_LAN_TRANSACTION32_SIZE + sizeof(SGESimple64_t));
 
 	while (buckets) {
-		mf = mpt_get_msg_frame(LanCtx, mpt_dev->id);
+		mf = mpt_get_msg_frame(LanCtx, mpt_dev);
 		if (mf == NULL) {
 			printk (KERN_ERR "%s: Unable to alloc request frame\n",
 				__FUNCTION__);
@@ -1334,7 +1334,7 @@
 		if (pSimple == NULL) {
 /**/			printk (KERN_WARNING MYNAM "/%s: No buckets posted\n",
 /**/				__FUNCTION__);
-			mpt_free_msg_frame(LanCtx, mpt_dev->id, mf);
+			mpt_free_msg_frame(LanCtx, mpt_dev, mf);
 			goto out;
 		}
 
@@ -1348,7 +1348,7 @@
  *	printk ("\n");
  */
 
-		mpt_put_msg_frame(LanCtx, mpt_dev->id, mf);
+		mpt_put_msg_frame(LanCtx, mpt_dev, mf);
 
 		priv->total_posted += i;
 		buckets -= i;
@@ -1489,7 +1489,7 @@
 		mpt_landev[j] = NULL;
 	}
 
-	for (p = mpt_adapter_find_first(); p; p = mpt_adapter_find_next(p)) {
+	list_for_each_entry(p, &ioc_list, list) {
 		for (i = 0; i < p->facts.NumberOfPorts; i++) {
 			printk (KERN_INFO MYNAM ": %s: PortNum=%x, ProtocolFlags=%02Xh (%c%c%c%c)\n",
 					p->name,
===== drivers/message/fusion/mptscsih.c 1.41 vs edited =====
--- 1.41/drivers/message/fusion/mptscsih.c	2004-05-29 17:10:51 +02:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-06-23 16:48:44 +02:00
@@ -65,6 +65,7 @@
 */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
+#include "linux_compat.h"	/* linux-2.6 tweaks */
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -76,9 +77,12 @@
 #include <linux/reboot.h>	/* notifier code */
 #include <linux/sched.h>
 #include <linux/workqueue.h>
-#include "../../scsi/scsi.h"
-#include <scsi/scsi_host.h>
 
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -154,16 +158,16 @@
  *  Other private/forward protos...
  */
 static int	mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
-static void	mptscsih_report_queue_full(Scsi_Cmnd *sc, SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq);
+static void	mptscsih_report_queue_full(struct scsi_cmnd *sc, SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq);
 static int	mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 
-static int	mptscsih_AddSGE(MPT_SCSI_HOST *hd, Scsi_Cmnd *SCpnt,
+static int	mptscsih_AddSGE(MPT_SCSI_HOST *hd, struct scsi_cmnd *SCpnt,
 				 SCSIIORequest_t *pReq, int req_idx);
 static void	mptscsih_freeChainBuffers(MPT_SCSI_HOST *hd, int req_idx);
 static int	mptscsih_initChainBuffers (MPT_SCSI_HOST *hd, int init);
-static void	copy_sense_data(Scsi_Cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
+static void	copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
 static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);
-static u32	SCPNT_TO_LOOKUP_IDX(Scsi_Cmnd *sc);
+static u32	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
 static MPT_FRAME_HDR *mptscsih_search_pendingQ(MPT_SCSI_HOST *hd, int scpnt_idx);
 static void	post_pendingQ_commands(MPT_SCSI_HOST *hd);
 
@@ -248,105 +252,12 @@
 	driver_setup = MPTSCSIH_DRIVER_SETUP;
 
 #ifdef MPTSCSIH_DBG_TIMEOUT
-static Scsi_Cmnd *foo_to[8];
+static struct scsi_cmnd *foo_to[8];
 #endif
 
 static struct scsi_host_template driver_template;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *  Private inline routines...
- */
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* 19991030 -sralston
- *  Return absolute SCSI data direction:
- *     1 = _DATA_OUT
- *     0 = _DIR_NONE
- *    -1 = _DATA_IN
- *
- * Changed: 3-20-2002 pdelaney to use the default data
- * direction and the defines set up in the
- * 2.4 kernel series
- *     1 = _DATA_OUT	changed to SCSI_DATA_WRITE (1)
- *     0 = _DIR_NONE	changed to SCSI_DATA_NONE (3)
- *    -1 = _DATA_IN	changed to SCSI_DATA_READ (2)
- * If the direction is unknown, fall through to original code.
- *
- * Mid-layer bug fix(): sg interface generates the wrong data
- * direction in some cases. Set the direction the hard way for
- * the most common commands.
- */
-static inline int
-mptscsih_io_direction(Scsi_Cmnd *cmd)
-{
-	switch (cmd->cmnd[0]) {
-	case WRITE_6:
-	case WRITE_10:
-	case WRITE_16:
-		return SCSI_DATA_WRITE;
-		break;
-	case READ_6:
-	case READ_10:
-	case READ_16:
-		return SCSI_DATA_READ;
-		break;
-	}
-
-	if (cmd->sc_data_direction != SCSI_DATA_UNKNOWN)
-		return cmd->sc_data_direction;
-
-	switch (cmd->cmnd[0]) {
-	/*  _DATA_OUT commands	*/
-	case WRITE_6:		case WRITE_10:		case WRITE_12:
-	case WRITE_16:
-	case WRITE_LONG:	case WRITE_SAME:	case WRITE_BUFFER:
-	case WRITE_VERIFY:	case WRITE_VERIFY_12:
-	case COMPARE:		case COPY:		case COPY_VERIFY:
-	case SEARCH_EQUAL:	case SEARCH_HIGH:	case SEARCH_LOW:
-	case SEARCH_EQUAL_12:	case SEARCH_HIGH_12:	case SEARCH_LOW_12:
-	case MODE_SELECT:	case MODE_SELECT_10:	case LOG_SELECT:
-	case SEND_DIAGNOSTIC:	case CHANGE_DEFINITION: case UPDATE_BLOCK:
-	case SET_WINDOW:	case MEDIUM_SCAN:	case SEND_VOLUME_TAG:
-	case REASSIGN_BLOCKS:
-	case PERSISTENT_RESERVE_OUT:
-	case 0xea:
-	case 0xa3:
-		return SCSI_DATA_WRITE;
-
-	/*  No data transfer commands  */
-	case SEEK_6:		case SEEK_10:
-	case RESERVE:		case RELEASE:
-	case TEST_UNIT_READY:
-	case START_STOP:
-	case ALLOW_MEDIUM_REMOVAL:
-		return SCSI_DATA_NONE;
-
-	/*  Conditional data transfer commands	*/
-	case FORMAT_UNIT:
-		if (cmd->cmnd[1] & 0x10)	/* FmtData (data out phase)? */
-			return SCSI_DATA_WRITE;
-		else
-			return SCSI_DATA_NONE;
-
-	case VERIFY:
-		if (cmd->cmnd[1] & 0x02)	/* VERIFY:BYTCHK (data out phase)? */
-			return SCSI_DATA_WRITE;
-		else
-			return SCSI_DATA_NONE;
-
-	case RESERVE_10:
-		if (cmd->cmnd[1] & 0x03)	/* RESERVE:{LongID|Extent} (data out phase)? */
-			return SCSI_DATA_WRITE;
-		else
-			return SCSI_DATA_NONE;
-
-	/*  Must be data _IN!  */
-	default:
-		return SCSI_DATA_READ;
-	}
-} /* mptscsih_io_direction() */
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_add_sge - Place a simple SGE at address pAddr.
  *	@pAddr: virtual address for SGE
@@ -458,13 +369,13 @@
  *	mptscsih_AddSGE - Add a SGE (plus chain buffers) to the
  *	SCSIIORequest_t Message Frame.
  *	@hd: Pointer to MPT_SCSI_HOST structure
- *	@SCpnt: Pointer to Scsi_Cmnd structure
+ *	@SCpnt: Pointer to scsi_cmnd structure
  *	@pReq: Pointer to SCSIIORequest_t structure
  *
  *	Returns ...
  */
 static int
-mptscsih_AddSGE(MPT_SCSI_HOST *hd, Scsi_Cmnd *SCpnt,
+mptscsih_AddSGE(MPT_SCSI_HOST *hd, struct scsi_cmnd *SCpnt,
 		SCSIIORequest_t *pReq, int req_idx)
 {
 	char 	*psge;
@@ -497,29 +408,20 @@
 	if ( (sges_left = SCpnt->use_sg) ) {
 		sges_left = pci_map_sg(hd->ioc->pcidev,
 			       (struct scatterlist *) SCpnt->request_buffer,
-			       SCpnt->use_sg,
-			       scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+ 			       SCpnt->use_sg,
+			       SCpnt->sc_data_direction);
 		if (sges_left == 0)
 			return FAILED;
 	} else if (SCpnt->request_bufflen) {
-		dma_addr_t	 buf_dma_addr;
-		scPrivate	*my_priv;
-
-		buf_dma_addr = pci_map_single(hd->ioc->pcidev,
+		SCpnt->SCp.dma_handle = pci_map_single(hd->ioc->pcidev,
 				      SCpnt->request_buffer,
 				      SCpnt->request_bufflen,
-				      scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
-
-		/* We hide it here for later unmap. */
-		my_priv = (scPrivate *) &SCpnt->SCp;
-		my_priv->p1 = (void *)(ulong) buf_dma_addr;
-
+				      SCpnt->sc_data_direction);
 		dsgprintk((MYIOC_s_INFO_FMT "SG: non-SG for %p, len=%d\n",
 				hd->ioc->name, SCpnt, SCpnt->request_bufflen));
-
 		mptscsih_add_sge((char *) &pReq->SGL,
 			0xD1000000|MPT_SGE_FLAGS_ADDRESSING|sgdir|SCpnt->request_bufflen,
-			buf_dma_addr);
+			SCpnt->SCp.dma_handle);
 
 		return SUCCESS;
 	}
@@ -708,7 +610,7 @@
 static int
 mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 {
-	Scsi_Cmnd	*sc;
+	struct scsi_cmnd	*sc;
 	MPT_SCSI_HOST	*hd;
 	SCSIIORequest_t	*pScsiReq;
 	SCSIIOReply_t	*pScsiReply;
@@ -829,6 +731,15 @@
 			break;
 
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
+			sc->result = (DRIVER_SENSE << 24) | (DID_OK << 16) | 
+					(CHECK_CONDITION << 1);
+			sc->sense_buffer[0] = 0x70;
+			sc->sense_buffer[2] = NO_SENSE;
+			sc->sense_buffer[12] = 0;
+			sc->sense_buffer[13] = 0;
+			dprintk((KERN_NOTICE "RESIDUAL_MISMATCH: result=%x on id=%d\n", sc->result, sc->target));
+			break;
+		
 		case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */
 			/*
 			 *  Do upfront check for valid SenseData and give it
@@ -946,14 +857,10 @@
 	/* Unmap the DMA buffers, if any. */
 	if (sc->use_sg) {
 		pci_unmap_sg(ioc->pcidev, (struct scatterlist *) sc->request_buffer,
-			    sc->use_sg, scsi_to_pci_dma_dir(sc->sc_data_direction));
+			    sc->use_sg, sc->sc_data_direction);
 	} else if (sc->request_bufflen) {
-		scPrivate	*my_priv;
-
-		my_priv = (scPrivate *) &sc->SCp;
-		pci_unmap_single(ioc->pcidev, (dma_addr_t)(ulong)my_priv->p1,
-			   sc->request_bufflen,
-			   scsi_to_pci_dma_dir(sc->sc_data_direction));
+		pci_unmap_single(ioc->pcidev, sc->SCp.dma_handle,
+				sc->request_bufflen, sc->sc_data_direction);
 	}
 
 	hd->ScsiLookup[req_idx] = NULL;
@@ -974,7 +881,7 @@
 flush_doneQ(MPT_SCSI_HOST *hd)
 {
 	MPT_DONE_Q	*buffer;
-	Scsi_Cmnd	*SCpnt;
+	struct scsi_cmnd	*SCpnt;
 	unsigned long	 flags;
 
 	/* Flush the doneQ.
@@ -992,9 +899,9 @@
 		 */
 		Q_DEL_ITEM(buffer);
 
-		/* Set the Scsi_Cmnd pointer
+		/* Set the struct scsi_cmnd pointer
 		 */
-		SCpnt = (Scsi_Cmnd *) buffer->argp;
+		SCpnt = (struct scsi_cmnd *) buffer->argp;
 		buffer->argp = NULL;
 
 		/* Add to the freeQ
@@ -1015,7 +922,7 @@
  * Calling function will finish processing.
  */
 static void
-search_doneQ_for_cmd(MPT_SCSI_HOST *hd, Scsi_Cmnd *SCpnt)
+search_doneQ_for_cmd(MPT_SCSI_HOST *hd, struct scsi_cmnd *SCpnt)
 {
 	unsigned long	 flags;
 	MPT_DONE_Q	*buffer;
@@ -1024,12 +931,12 @@
 	if (!Q_IS_EMPTY(&hd->doneQ)) {
 		buffer = hd->doneQ.head;
 		do {
-			Scsi_Cmnd *sc = (Scsi_Cmnd *) buffer->argp;
+			struct scsi_cmnd *sc = (struct scsi_cmnd *) buffer->argp;
 			if (SCpnt == sc) {
 				Q_DEL_ITEM(buffer);
 				SCpnt->result = sc->result;
 
-				/* Set the Scsi_Cmnd pointer
+				/* Set the struct scsi_cmnd pointer
 				 */
 				buffer->argp = NULL;
 
@@ -1057,7 +964,7 @@
 static void
 mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 {
-	Scsi_Cmnd	*SCpnt;
+	struct scsi_cmnd	*SCpnt;
 	MPT_FRAME_HDR	*mf;
 	MPT_DONE_Q	*buffer;
 	int		 ii;
@@ -1093,15 +1000,12 @@
 					pci_unmap_sg(hd->ioc->pcidev,
 						(struct scatterlist *) SCpnt->request_buffer,
 						SCpnt->use_sg,
-						scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+						SCpnt->sc_data_direction);
 				} else if (SCpnt->request_bufflen) {
-					scPrivate	*my_priv;
-
-					my_priv = (scPrivate *) &SCpnt->SCp;
 					pci_unmap_single(hd->ioc->pcidev,
-						(dma_addr_t)(ulong)my_priv->p1,
+						SCpnt->SCp.dma_handle,
 						SCpnt->request_bufflen,
-						scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+						SCpnt->sc_data_direction);
 				}
 			}
 			SCpnt->result = DID_RESET << 16;
@@ -1111,7 +1015,7 @@
 			mptscsih_freeChainBuffers(hd, ii);
 
 			/* Free Message frames */
-			mpt_free_msg_frame(ScsiDoneCtx, hd->ioc->id, mf);
+			mpt_free_msg_frame(ScsiDoneCtx, hd->ioc, mf);
 
 #if 1
 			/* Post to doneQ, do not reply until POST phase
@@ -1123,7 +1027,7 @@
 				buffer = hd->freeQ.head;
 				Q_DEL_ITEM(buffer);
 
-				/* Set the Scsi_Cmnd pointer
+				/* Set the struct scsi_cmnd pointer
 				 */
 				buffer->argp = (void *)SCpnt;
 
@@ -1149,7 +1053,7 @@
  *	mptscsih_search_running_cmds - Delete any commands associated
  *		with the specified target and lun. Function called only
  *		when a lun is disable by mid-layer.
- *		Do NOT access the referenced Scsi_Cmnd structure or
+ *		Do NOT access the referenced scsi_cmnd structure or
  *		members. Will cause either a paging or NULL ptr error.
  *	@hd: Pointer to a SCSI HOST structure
  *	@target: target id
@@ -1184,7 +1088,7 @@
 			 */
 			hd->ScsiLookup[ii] = NULL;
 			mptscsih_freeChainBuffers(hd, ii);
-			mpt_free_msg_frame(ScsiDoneCtx, hd->ioc->id, (MPT_FRAME_HDR *)mf);
+			mpt_free_msg_frame(ScsiDoneCtx, hd->ioc, (MPT_FRAME_HDR *)mf);
 		}
 	}
 
@@ -1307,7 +1211,7 @@
 /*
  *	mptscsih_report_queue_full - Report QUEUE_FULL status returned
  *	from a SCSI target device.
- *	@sc: Pointer to Scsi_Cmnd structure
+ *	@sc: Pointer to scsi_cmnd structure
  *	@pScsiReply: Pointer to SCSIIOReply_t
  *	@pScsiReq: Pointer to original SCSI request
  *
@@ -1316,7 +1220,7 @@
  *	printk() API call, not more than once every 10 seconds.
  */
 static void
-mptscsih_report_queue_full(Scsi_Cmnd *sc, SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq)
+mptscsih_report_queue_full(struct scsi_cmnd *sc, SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq)
 {
 	long time = jiffies;
 
@@ -1492,7 +1396,7 @@
 		hd->is_multipath = 1;
 	}
 
-	/* SCSI needs Scsi_Cmnd lookup table!
+	/* SCSI needs scsi_cmnd lookup table!
 	 * (with size equal to req_depth*PtrSz!)
 	 */
 	sz = hd->ioc->req_depth * sizeof(void *);
@@ -1932,16 +1836,7 @@
 static void __exit
 mptscsih_exit(void)
 {
-	MPT_ADAPTER	*ioc;
-
-	/* removing devices */
-	for(ioc = mpt_adapter_find_first(); ioc != NULL;
-	  ioc = mpt_adapter_find_next(ioc)) {
-		if ((ioc->last_state != MPI_IOC_STATE_OPERATIONAL) ||
-		  (ioc->sh == NULL))
-			continue;
-		mptscsih_remove(ioc->pcidev);
-	}
+	mpt_device_driver_deregister(MPTSCSIH_DRIVER);
 
 	mpt_reset_deregister(ScsiDoneCtx);
 	dprintk((KERN_INFO MYNAM
@@ -1951,7 +1846,6 @@
 	dprintk((KERN_INFO MYNAM
 	  ": Deregistered for IOC event notifications\n"));
 
-	mpt_device_driver_deregister(MPTSCSIH_DRIVER);
 	mpt_deregister(ScsiScanDvCtx);
 	mpt_deregister(ScsiTaskCtx);
 	mpt_deregister(ScsiDoneCtx);
@@ -1966,7 +1860,7 @@
  *	mptscsih_info - Return information about MPT adapter
  *	@SChost: Pointer to Scsi_Host structure
  *
- *	(linux Scsi_Host_Template.info routine)
+ *	(linux scsi_host_template.info routine)
  *
  *	Returns pointer to buffer where information was written.
  */
@@ -2176,7 +2070,7 @@
 /**
  *	mptscsih_proc_info - Return information about MPT adapter
  *
- *	(linux Scsi_Host_Template.info routine)
+ *	(linux scsi_host_template.info routine)
  *
  * 	buffer: if write, user data; if read, buffer for user
  * 	length: if write, return length;
@@ -2188,23 +2082,10 @@
 int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
 			int length, int func)
 {
-	MPT_ADAPTER	*ioc;
-	MPT_SCSI_HOST	*hd = NULL;
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER	*ioc = hd->ioc;
 	int size = 0;
 
-	dprintk(("Called mptscsih_proc_info: hostno=%d, func=%d\n", host->host_no, func));
-	dprintk(("buffer %p, start=%p (%p) offset=%ld length = %d\n",
-			buffer, start, *start, offset, length));
-
-	for (ioc = mpt_adapter_find_first(); ioc != NULL; ioc = mpt_adapter_find_next(ioc)) {
-		if ((ioc->sh) && (ioc->sh == host)) {
-			hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
-			break;
-		}
-	}
-	if ((ioc == NULL) || (ioc->sh == NULL) || (hd == NULL))
-		return 0;
-
 	if (func) {
 		size = mptscsih_user_command(ioc, buffer, length);
 	} else {
@@ -2224,17 +2105,17 @@
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_qcmd - Primary Fusion MPT SCSI initiator IO start routine.
- *	@SCpnt: Pointer to Scsi_Cmnd structure
+ *	@SCpnt: Pointer to scsi_cmnd structure
  *	@done: Pointer SCSI mid-layer IO completion function
  *
- *	(linux Scsi_Host_Template.queuecommand routine)
+ *	(linux scsi_host_template.queuecommand routine)
  *	This is the primary SCSI IO start routine.  Create a MPI SCSIIORequest
- *	from a linux Scsi_Cmnd request and send it to the IOC.
+ *	from a linux scsi_cmnd request and send it to the IOC.
  *
  *	Returns 0. (rtn value discarded by linux scsi mid-layer)
  */
 int
-mptscsih_qcmd(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	MPT_SCSI_HOST		*hd;
 	MPT_FRAME_HDR		*mf;
@@ -2244,7 +2125,6 @@
 	unsigned long		 flags;
 	int	 target;
 	int	 lun;
-	int	 datadir;
 	u32	 datalen;
 	u32	 scsictl;
 	u32	 scsidir;
@@ -2282,7 +2162,7 @@
 	/*
 	 *  Put together a MPT SCSI request...
 	 */
-	if ((mf = mpt_get_msg_frame(ScsiDoneCtx, hd->ioc->id)) == NULL) {
+	if ((mf = mpt_get_msg_frame(ScsiDoneCtx, hd->ioc)) == NULL) {
 		dprintk((MYIOC_s_WARN_FMT "QueueCmd, no msg frames!!\n",
 				hd->ioc->name));
 		did_errcode = 2;
@@ -2295,21 +2175,15 @@
 
 	ADD_INDEX_LOG(my_idx);
 
-	/*
-	 *  The scsi layer should be handling this stuff
-	 *  (In 2.3.x it does -DaveM)
-	 */
-
 	/*  BUG FIX!  19991030 -sralston
 	 *    TUR's being issued with scsictl=0x02000000 (DATA_IN)!
 	 *    Seems we may receive a buffer (datalen>0) even when there
 	 *    will be no data transfer!  GRRRRR...
 	 */
-	datadir = mptscsih_io_direction(SCpnt);
-	if (datadir == SCSI_DATA_READ) {
+	if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
 		datalen = SCpnt->request_bufflen;
 		scsidir = MPI_SCSIIO_CONTROL_READ;	/* DATA IN  (host<--ioc<--dev) */
-	} else if (datadir == SCSI_DATA_WRITE) {
+	} else if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
 		datalen = SCpnt->request_bufflen;
 		scsidir = MPI_SCSIIO_CONTROL_WRITE;	/* DATA OUT (host-->ioc-->dev) */
 	} else {
@@ -2390,17 +2264,6 @@
 
 			if (dvStatus || hd->ioc->spi_data.forceDv) {
 
-				/* Write SDP1 on this I/O to this target */
-				if (dvStatus & MPT_SCSICFG_NEGOTIATE) {
-					mptscsih_writeSDP1(hd, 0, target, hd->negoNvram);
-					dvStatus &= ~MPT_SCSICFG_NEGOTIATE;
-					hd->ioc->spi_data.dvStatus[target] =  dvStatus;
-				} else if (dvStatus & MPT_SCSICFG_BLK_NEGO) {
-					mptscsih_writeSDP1(hd, 0, target, MPT_SCSICFG_BLK_NEGO);
-					dvStatus &= ~MPT_SCSICFG_BLK_NEGO;
-					hd->ioc->spi_data.dvStatus[target] =  dvStatus;
-				}
-
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 				if ((dvStatus & MPT_SCSICFG_NEED_DV) ||
 					(hd->ioc->spi_data.forceDv & MPT_SCSICFG_NEED_DV)) {
@@ -2448,7 +2311,7 @@
 #endif
 
 		if (issueCmd) {
-			mpt_put_msg_frame(ScsiDoneCtx, hd->ioc->id, mf);
+			mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);
 			dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
 					hd->ioc->name, SCpnt, mf, my_idx));
 		} else {
@@ -2476,7 +2339,7 @@
 		}
 	} else {
 		mptscsih_freeChainBuffers(hd, my_idx);
-		mpt_free_msg_frame(ScsiDoneCtx, hd->ioc->id, mf);
+		mpt_free_msg_frame(ScsiDoneCtx, hd->ioc, mf);
 		did_errcode = 3;
 		goto did_error;
 	}
@@ -2495,7 +2358,7 @@
 		buffer = hd->freeQ.head;
 		Q_DEL_ITEM(buffer);
 
-		/* Set the Scsi_Cmnd pointer
+		/* Set the scsi_cmnd pointer
 		 */
 		buffer->argp = (void *)SCpnt;
 
@@ -2729,7 +2592,7 @@
 
 	/* Return Fail to calling function if no message frames available.
 	 */
-	if ((mf = mpt_get_msg_frame(ScsiTaskCtx, hd->ioc->id)) == NULL) {
+	if ((mf = mpt_get_msg_frame(ScsiTaskCtx, hd->ioc)) == NULL) {
 		dtmprintk((MYIOC_s_WARN_FMT "IssueTaskMgmt, no msg frames!!\n",
 				hd->ioc->name));
 		//return FAILED;
@@ -2773,7 +2636,7 @@
 	hd->TMtimer.expires = jiffies + timeout;
 	add_timer(&hd->TMtimer);
 
-	if ((retval = mpt_send_handshake_request(ScsiTaskCtx, hd->ioc->id,
+	if ((retval = mpt_send_handshake_request(ScsiTaskCtx, hd->ioc,
 				sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, sleepFlag))
 	!= 0) {
 		dtmprintk((MYIOC_s_WARN_FMT "_send_handshake FAILED!"
@@ -2781,7 +2644,7 @@
 		hd->numTMrequests--;
 		hd->tmPtr = NULL;
 		del_timer(&hd->TMtimer);
-		mpt_free_msg_frame(ScsiTaskCtx, hd->ioc->id, mf);
+		mpt_free_msg_frame(ScsiTaskCtx, hd->ioc, mf);
 	}
 
 	return retval;
@@ -2789,15 +2652,15 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_abort - Abort linux Scsi_Cmnd routine, new_eh variant
- *	@SCpnt: Pointer to Scsi_Cmnd structure, IO to be aborted
+ *	mptscsih_abort - Abort linux scsi_cmnd routine, new_eh variant
+ *	@SCpnt: Pointer to scsi_cmnd structure, IO to be aborted
  *
- *	(linux Scsi_Host_Template.eh_abort_handler routine)
+ *	(linux scsi_host_template.eh_abort_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  */
 int
-mptscsih_abort(Scsi_Cmnd * SCpnt)
+mptscsih_abort(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
 	MPT_FRAME_HDR	*mf;
@@ -2845,7 +2708,7 @@
 	 * and then following up with the reset request.
 	 */
 	if ((mf = mptscsih_search_pendingQ(hd, scpnt_idx)) != NULL) {
-		mpt_put_msg_frame(ScsiDoneCtx, hd->ioc->id, mf);
+		mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);
 		post_pendingQ_commands(hd);
 		dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "
 			   "Posting pended cmd! (sc=%p)\n",
@@ -2892,14 +2755,14 @@
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_dev_reset - Perform a SCSI TARGET_RESET!  new_eh variant
- *	@SCpnt: Pointer to Scsi_Cmnd structure, IO which reset is due to
+ *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
  *
- *	(linux Scsi_Host_Template.eh_dev_reset_handler routine)
+ *	(linux scsi_host_template.eh_dev_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  */
 int
-mptscsih_dev_reset(Scsi_Cmnd * SCpnt)
+mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
 	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
@@ -2947,14 +2810,14 @@
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_bus_reset - Perform a SCSI BUS_RESET!	new_eh variant
- *	@SCpnt: Pointer to Scsi_Cmnd structure, IO which reset is due to
+ *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
  *
- *	(linux Scsi_Host_Template.eh_bus_reset_handler routine)
+ *	(linux scsi_host_template.eh_bus_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  */
 int
-mptscsih_bus_reset(Scsi_Cmnd * SCpnt)
+mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
 	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
@@ -3002,14 +2865,14 @@
 /**
  *	mptscsih_host_reset - Perform a SCSI host adapter RESET!
  *	new_eh variant
- *	@SCpnt: Pointer to Scsi_Cmnd structure, IO which reset is due to
+ *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
  *
- *	(linux Scsi_Host_Template.eh_host_reset_handler routine)
+ *	(linux scsi_host_template.eh_host_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  */
 int
-mptscsih_host_reset(Scsi_Cmnd *SCpnt)
+mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST *  hd;
 	int              status = SUCCESS;
@@ -3245,7 +3108,7 @@
  *	Init memory once per id (not LUN).
  */
 int
-mptscsih_slave_alloc(Scsi_Device *device)
+mptscsih_slave_alloc(struct scsi_device *device)
 {
 	struct Scsi_Host	*host = device->host;
 	MPT_SCSI_HOST		*hd;
@@ -3285,7 +3148,7 @@
  *	Called if no device present or device being unloaded
  */
 void
-mptscsih_slave_destroy(Scsi_Device *device)
+mptscsih_slave_destroy(struct scsi_device *device)
 {
 	struct Scsi_Host	*host = device->host;
 	MPT_SCSI_HOST		*hd;
@@ -3350,7 +3213,7 @@
  *	Return non-zero if fails.
  */
 int
-mptscsih_slave_configure(Scsi_Device *device)
+mptscsih_slave_configure(struct scsi_device *device)
 {
 	struct Scsi_Host	*sh = device->host;
 	VirtDevice		*pTarget;
@@ -3433,7 +3296,7 @@
  *
  */
 static void
-copy_sense_data(Scsi_Cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply)
+copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply)
 {
 	VirtDevice	*target;
 	SCSIIORequest_t	*pReq;
@@ -3511,7 +3374,7 @@
 }
 
 static u32
-SCPNT_TO_LOOKUP_IDX(Scsi_Cmnd *sc)
+SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc)
 {
 	MPT_SCSI_HOST *hd;
 	int i;
@@ -3608,12 +3471,12 @@
 			continue;
 		}
 
-		mpt_put_msg_frame(ScsiDoneCtx, hd->ioc->id, mf);
+		mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);
 
 #if defined(MPT_DEBUG_DV) || defined(MPT_DEBUG_DV_TINY)
 		{
 			u16		 req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
-			Scsi_Cmnd	*sc = hd->ScsiLookup[req_idx];
+			struct scsi_cmnd	*sc = hd->ScsiLookup[req_idx];
 			printk(MYIOC_s_INFO_FMT "Issued SCSI cmd (sc=%p) idx=%d (mf=%p)\n",
 					hd->ioc->name, sc, req_idx, mf);
 		}
@@ -3675,7 +3538,7 @@
 		 */
 		if (hd->cmdPtr) {
 			del_timer(&hd->timer);
-			mpt_free_msg_frame(ScsiScanDvCtx, ioc->id, hd->cmdPtr);
+			mpt_free_msg_frame(ScsiScanDvCtx, ioc, hd->cmdPtr);
 		}
 
 		/* 2d. If a task management has not completed,
@@ -3683,7 +3546,7 @@
 		 */
 		if (hd->tmPtr) {
 			del_timer(&hd->TMtimer);
-			mpt_free_msg_frame(ScsiTaskCtx, ioc->id, hd->tmPtr);
+			mpt_free_msg_frame(ScsiTaskCtx, ioc, hd->tmPtr);
 		}
 
 #ifdef MPTSCSIH_DBG_TIMEOUT
@@ -4377,7 +4240,7 @@
 			}
 		}
 
-		data_56 = 0;
+		data_56 = 0x0F;  /* Default to full capabilities if Inq data length is < 57 */
 		if (dlen > 56) {
 			if ( (!(vdev->tflags & MPT_TARGET_FLAGS_VALID_56))) {
 			/* Update the target capabilities
@@ -4442,14 +4305,16 @@
 			}
 
 			if (target->inq_data[7] & 0x10) {
-				/* bits 2 & 3 show DT support
+				/* bits 2 & 3 show Clocking support
 				 */
-				if ((byte56 & 0x04) == 0)
+				if ((byte56 & 0x0C) == 0)
 					factor = MPT_ULTRA2;
-				else if ((byte56 & 0x03) == 0)
-					factor = MPT_ULTRA160;
-				else
-					factor = MPT_ULTRA320;
+				else {
+					if ((byte56 & 0x03) == 0)
+						factor = MPT_ULTRA160;
+					else
+						factor = MPT_ULTRA320;
+				}
 				offset = pspi_data->maxSyncOffset;
 
 				/* If RAID, never disable QAS
@@ -4458,8 +4323,9 @@
 				 * bit 1 QAS support, non-raid only
 				 * bit 0 IU support
 				 */
-				if ((target->raidVolume == 1) || ((byte56 & 0x02) != 0))
+				if ((target->raidVolume == 1) || (byte56 & 0x02)) {
 					noQas = 0;
+				}
 			} else {
 				factor = MPT_ASYNC;
 				offset = 0;
@@ -4538,7 +4404,7 @@
 				/* Disable QAS in a mixed configuration case
 		 		*/
 
-//				ddvtprintk((KERN_INFO "Disabling QAS!\n"));
+				ddvtprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
 				for (ii = 0; ii < id; ii++) {
 					if ( (vdev = hd->Targets[ii]) ) {
 						vdev->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
@@ -4546,6 +4412,15 @@
 				}
 			}
 		}
+		
+		/* Write SDP1 on this I/O to this target */
+		if (pspi_data->dvStatus[id] & MPT_SCSICFG_NEGOTIATE) {
+			mptscsih_writeSDP1(hd, 0, id, hd->negoNvram);
+			pspi_data->dvStatus[id] &= ~MPT_SCSICFG_NEGOTIATE;
+		} else if (pspi_data->dvStatus[id] & MPT_SCSICFG_BLK_NEGO) {
+			mptscsih_writeSDP1(hd, 0, id, MPT_SCSICFG_BLK_NEGO);
+			pspi_data->dvStatus[id] &= ~MPT_SCSICFG_BLK_NEGO;
+		}
 	}
 
 	return;
@@ -4778,7 +4653,7 @@
 
 		/* Get a MF for this command.
 		 */
-		if ((mf = mpt_get_msg_frame(ScsiDoneCtx, ioc->id)) == NULL) {
+		if ((mf = mpt_get_msg_frame(ScsiDoneCtx, ioc)) == NULL) {
 			dprintk((MYIOC_s_WARN_FMT "write SDP1: no msg frames!\n",
 						ioc->name));
 			return -EAGAIN;
@@ -4842,7 +4717,7 @@
 				ioc->name, id, (id | (bus<<8)),
 				requested, configuration));
 
-		mpt_put_msg_frame(ScsiDoneCtx, ioc->id, mf);
+		mpt_put_msg_frame(ScsiDoneCtx, ioc, mf);
 	}
 
 	return 0;
@@ -4873,7 +4748,7 @@
 
 	/* Get a MF for this command.
 	 */
-	if ((mf = mpt_get_msg_frame(ScsiDoneCtx, ioc->id)) == NULL) {
+	if ((mf = mpt_get_msg_frame(ScsiDoneCtx, ioc)) == NULL) {
 		dprintk((MYIOC_s_WARN_FMT "writeIOCPage4 : no msg frames!\n",
 					ioc->name));
 		return -EAGAIN;
@@ -4922,7 +4797,7 @@
 		"writeIOCPage4: pgaddr 0x%x\n",
 			ioc->name, (target_id | (bus<<8))));
 
-	mpt_put_msg_frame(ScsiDoneCtx, ioc->id, mf);
+	mpt_put_msg_frame(ScsiDoneCtx, ioc, mf);
 
 	return 0;
 }
@@ -5234,7 +5109,7 @@
 
 	/* Get and Populate a free Frame
 	 */
-	if ((mf = mpt_get_msg_frame(ScsiScanDvCtx, hd->ioc->id)) == NULL) {
+	if ((mf = mpt_get_msg_frame(ScsiScanDvCtx, hd->ioc)) == NULL) {
 		ddvprintk((MYIOC_s_WARN_FMT "_do_raid: no msg frames!\n",
 					hd->ioc->name));
 		return -EAGAIN;
@@ -5259,7 +5134,7 @@
 			hd->ioc->name, action, io->id));
 
 	hd->pLocal = NULL;
-	hd->timer.expires = jiffies + HZ*2; /* 2 second timeout */
+	hd->timer.expires = jiffies + HZ*10; /* 10 second timeout */
 	scandv_wait_done = 0;
 
 	/* Save cmd pointer, for resource free if timeout or
@@ -5268,7 +5143,7 @@
 	hd->cmdPtr = mf;
 
 	add_timer(&hd->timer);
-	mpt_put_msg_frame(ScsiScanDvCtx, hd->ioc->id, mf);
+	mpt_put_msg_frame(ScsiScanDvCtx, hd->ioc, mf);
 	wait_event(scandv_waitq, scandv_wait_done);
 
 	if ((hd->pLocal == NULL) || (hd->pLocal->completion != MPT_SCANDV_GOOD))
@@ -5415,7 +5290,7 @@
 
 	/* Get and Populate a free Frame
 	 */
-	if ((mf = mpt_get_msg_frame(ScsiScanDvCtx, hd->ioc->id)) == NULL) {
+	if ((mf = mpt_get_msg_frame(ScsiScanDvCtx, hd->ioc)) == NULL) {
 		ddvprintk((MYIOC_s_WARN_FMT "No msg frames!\n",
 					hd->ioc->name));
 		return -EBUSY;
@@ -5505,7 +5380,7 @@
 	hd->cmdPtr = mf;
 
 	add_timer(&hd->timer);
-	mpt_put_msg_frame(ScsiScanDvCtx, hd->ioc->id, mf);
+	mpt_put_msg_frame(ScsiScanDvCtx, hd->ioc, mf);
 	wait_event(scandv_waitq, scandv_wait_done);
 
 	if (hd->pLocal) {
@@ -5713,7 +5588,7 @@
 	did = 1;
 	while (did) {
 		did = 0;
-		for (ioc = mpt_adapter_find_first(); ioc != NULL; ioc = mpt_adapter_find_next(ioc)) {
+		list_for_each_entry(ioc, &ioc_list, list) {
 			spin_lock_irqsave(&dvtaskQ_lock, flags);
 			if (dvtaskQ_release) {
 				dvtaskQ_active = 0;
