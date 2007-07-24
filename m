From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 5/5] mpt fusion: Changes in mptctl.c for logging support
Date: Tue, 24 Jul 2007 15:49:05 +0530
Message-ID: <20070724101904.GF1831@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42989 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540AbXGXKVb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 06:21:31 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l6OAKBQ6000746
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 03:20:11 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com


This patch contains changes in mptctl.c to support logging in MPT fusion drivers

The changes are majorly in debug printks, the existing debugprintk are
modified accroding to new debug macros defined in the file mptbdebug.h

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff -Naurp b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2007-07-23 14:24:35.000000000 +0530
+++ a/drivers/message/fusion/mptctl.c	2007-07-23 16:46:23.000000000 +0530
@@ -181,7 +181,7 @@ static inline int
 mptctl_syscall_down(MPT_ADAPTER *ioc, int nonblock)
 {
 	int rc = 0;
-	dctlprintk((KERN_INFO MYNAM "::mptctl_syscall_down(%p,%d) called\n", ioc, nonblock));
+//	dctlprintk(ioc, printk(KERN_DEBUG MYNAM "::mptctl_syscall_down(%p,%d) called\n", ioc, nonblock));
 
 	if (nonblock) {
 		if (!mutex_trylock(&ioc->ioctl->ioctl_mutex))
@@ -190,7 +190,7 @@ mptctl_syscall_down(MPT_ADAPTER *ioc, in
 		if (mutex_lock_interruptible(&ioc->ioctl->ioctl_mutex))
 			rc = -ERESTARTSYS;
 	}
-	dctlprintk((KERN_INFO MYNAM "::mptctl_syscall_down return %d\n", rc));
+//	dctlprintk(ioc, printk(KERN_DEBUG MYNAM "::mptctl_syscall_down return %d\n", rc));
 	return rc;
 }
 
@@ -209,18 +209,19 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME
 	u16 iocStatus;
 	u8 cmd;
 
-	dctlprintk(("mptctl_reply()!\n"));
 	if (req)
 		 cmd = req->u.hdr.Function;
 	else
 		return 1;
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\tcompleting mpi function (0x%02X), req=%p, "
+	    "reply=%p\n", ioc->name,  req->u.hdr.Function, req, reply));
 
 	if (ioc->ioctl) {
 
 		if (reply==NULL) {
 
-			dctlprintk(("mptctl_reply() NULL Reply "
-				"Function=%x!\n", cmd));
+			dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_reply() NULL Reply "
+				"Function=%x!\n", ioc->name, cmd));
 
 			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
 			ioc->ioctl->reset &= ~MPTCTL_RESET_OK;
@@ -233,14 +234,9 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME
 
 		}
 
-		dctlprintk(("mptctl_reply() with req=%p "
-			"reply=%p Function=%x!\n", req, reply, cmd));
-
 		/* Copy the reply frame (which much exist
 		 * for non-SCSI I/O) to the IOC structure.
 		 */
-		dctlprintk(("Copying Reply Frame @%p to ioc%d!\n",
-			reply, ioc->id));
 		memcpy(ioc->ioctl->ReplyFrame, reply,
 			min(ioc->reply_sz, 4*reply->u.reply.MsgLength));
 		ioc->ioctl->status |= MPT_IOCTL_STATUS_RF_VALID;
@@ -252,8 +248,24 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME
 		if (iocStatus  == MPI_IOCSTATUS_SUCCESS)
 			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
 
+		if (iocStatus || reply->u.reply.IOCLogInfo)
+			dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\tiocstatus (0x%04X), "
+		    		"loginfo (0x%08X)\n", ioc->name,
+		    		iocStatus,
+		    		le32_to_cpu(reply->u.reply.IOCLogInfo)));
+
 		if ((cmd == MPI_FUNCTION_SCSI_IO_REQUEST) ||
 			(cmd == MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {
+
+			if (reply->u.sreply.SCSIStatus || reply->u.sreply.SCSIState)
+				dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+					"\tscsi_status (0x%02x), scsi_state (0x%02x), "
+					"tag = (0x%04x), transfer_count (0x%08x)\n", ioc->name,
+					reply->u.sreply.SCSIStatus,
+					reply->u.sreply.SCSIState,
+					le16_to_cpu(reply->u.sreply.TaskTag),
+					le32_to_cpu(reply->u.sreply.TransferCount)));
+
 			ioc->ioctl->reset &= ~MPTCTL_RESET_OK;
 
 			if ((iocStatus == MPI_IOCSTATUS_SCSI_DATA_UNDERRUN) ||
@@ -298,8 +310,8 @@ static void mptctl_timeout_expired (MPT_
 {
 	int rc = 1;
 
-	dctlprintk((KERN_NOTICE MYNAM ": Timeout Expired! Host %d\n",
-				ioctl->ioc->id));
+	dctlprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT ": Timeout Expired! Host %d\n",
+				ioctl->ioc->name, ioctl->ioc->id));
 	if (ioctl == NULL)
 		return;
 
@@ -311,7 +323,7 @@ static void mptctl_timeout_expired (MPT_
 		/* Issue a reset for this device.
 		 * The IOC is not responding.
 		 */
-		dctlprintk((MYIOC_s_INFO_FMT "Calling HardReset! \n",
+		dctlprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
 			 ioctl->ioc->name));
 		mpt_HardResetHandler(ioctl->ioc, CAN_SLEEP);
 	}
@@ -350,14 +362,14 @@ static int mptctl_bus_reset(MPT_IOCTL *i
 	/* Send request
 	 */
 	if ((mf = mpt_get_msg_frame(mptctl_id, ioctl->ioc)) == NULL) {
-		dctlprintk((MYIOC_s_WARN_FMT "IssueTaskMgmt, no msg frames!!\n",
+		dtmprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT "IssueTaskMgmt, no msg frames!!\n",
 				ioctl->ioc->name));
 
 		mptctl_free_tm_flags(ioctl->ioc);
 		return -ENOMEM;
 	}
 
-	dtmprintk((MYIOC_s_INFO_FMT "IssueTaskMgmt request @ %p\n",
+	dtmprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT "IssueTaskMgmt request @ %p\n",
 			ioctl->ioc->name, mf));
 
 	pScsiTm = (SCSITaskMgmt_t *) mf;
@@ -377,15 +389,15 @@ static int mptctl_bus_reset(MPT_IOCTL *i
 		pScsiTm->Reserved2[ii] = 0;
 
 	pScsiTm->TaskMsgContext = 0;
-	dtmprintk((MYIOC_s_INFO_FMT
+	dtmprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT
 		"mptctl_bus_reset: issued.\n", ioctl->ioc->name));
 
-	DBG_DUMP_TM_REQUEST_FRAME((u32 *)mf);
+	DBG_DUMP_TM_REQUEST_FRAME(ioctl->ioc, (u32 *)mf);
 
 	ioctl->wait_done=0;
 	if ((retval = mpt_send_handshake_request(mptctl_id, ioctl->ioc,
 	     sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP)) != 0) {
-		dfailprintk((MYIOC_s_ERR_FMT "_send_handshake FAILED!"
+		dfailprintk(ioctl->ioc, printk(MYIOC_s_ERR_FMT "_send_handshake FAILED!"
 			" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,
 			hd->ioc, mf));
 		goto mptctl_bus_reset_done;
@@ -456,7 +468,7 @@ static int
 mptctl_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
 	MPT_IOCTL *ioctl = ioc->ioctl;
-	dctlprintk((KERN_INFO MYNAM ": IOC %s_reset routed to IOCTL driver!\n",
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": IOC %s_reset routed to IOCTL driver!\n",ioc->name,
 		reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
 		reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
 
@@ -487,7 +499,8 @@ mptctl_event_process(MPT_ADAPTER *ioc, E
 
 	event = le32_to_cpu(pEvReply->Event) & 0xFF;
 
-	dctlprintk(("%s() called\n", __FUNCTION__));
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s() called\n",
+	    ioc->name, __FUNCTION__));
 	if(async_queue == NULL)
 		return 1;
 
@@ -497,8 +510,10 @@ mptctl_event_process(MPT_ADAPTER *ioc, E
 	 */
 	 if (event == 0x21 ) {
 		ioc->aen_event_read_flag=1;
-		dctlprintk(("Raised SIGIO to application\n"));
-		devtverboseprintk(("Raised SIGIO to application\n"));
+		dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Raised SIGIO to application\n",
+		    ioc->name));
+		devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "Raised SIGIO to application\n", ioc->name));
 		kill_fasync(&async_queue, SIGIO, POLL_IN);
 		return 1;
 	 }
@@ -515,8 +530,10 @@ mptctl_event_process(MPT_ADAPTER *ioc, E
 	 */
 	if (ioc->events && (ioc->eventTypes & ( 1 << event))) {
 		ioc->aen_event_read_flag=1;
-		dctlprintk(("Raised SIGIO to application\n"));
-		devtverboseprintk(("Raised SIGIO to application\n"));
+		dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "Raised SIGIO to application\n", ioc->name));
+		devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "Raised SIGIO to application\n", ioc->name));
 		kill_fasync(&async_queue, SIGIO, POLL_IN);
 	}
 	return 1;
@@ -530,14 +547,12 @@ mptctl_fasync(int fd, struct file *filep
 	list_for_each_entry(ioc, &ioc_list, list)
 		ioc->aen_event_read_flag=0;
 
-	dctlprintk(("%s() called\n", __FUNCTION__));
 	return fasync_helper(fd, filep, mode, &async_queue);
 }
 
 static int
 mptctl_release(struct inode *inode, struct file *filep)
 {
-	dctlprintk(("%s() called\n", __FUNCTION__));
 	return fasync_helper(-1, filep, 0, &async_queue);
 }
 
@@ -558,8 +573,6 @@ __mptctl_ioctl(struct file *file, unsign
 	int ret;
 	MPT_ADAPTER *iocp = NULL;
 
-	dctlprintk(("mptctl_ioctl() called\n"));
-
 	if (copy_from_user(&khdr, uhdr, sizeof(khdr))) {
 		printk(KERN_ERR "%s::mptctl_ioctl() @%d - "
 				"Unable to copy mpt_ioctl_header data @ %p\n",
@@ -574,13 +587,13 @@ __mptctl_ioctl(struct file *file, unsign
 	iocnumX = khdr.iocnum & 0xFF;
 	if (((iocnum = mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
 	    (iocp == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_ioctl() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnumX));
+		printk(KERN_DEBUG "%s::mptctl_ioctl() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnumX);
 		return -ENODEV;
 	}
 
 	if (!iocp->active) {
-		printk(KERN_ERR "%s::mptctl_ioctl() @%d - Controller disabled.\n",
+		printk(KERN_DEBUG "%s::mptctl_ioctl() @%d - Controller disabled.\n",
 				__FILE__, __LINE__);
 		return -EFAULT;
 	}
@@ -612,8 +625,6 @@ __mptctl_ioctl(struct file *file, unsign
 	if ((ret = mptctl_syscall_down(iocp, nonblock)) != 0)
 		return ret;
 
-	dctlprintk((MYIOC_s_INFO_FMT ": mptctl_ioctl()\n", iocp->name));
-
 	if (cmd == MPTFWDOWNLOAD)
 		ret = mptctl_fw_download(arg);
 	else if (cmd == MPTCOMMAND)
@@ -648,8 +659,6 @@ static int mptctl_do_reset(unsigned long
 	struct mpt_ioctl_diag_reset krinfo;
 	MPT_ADAPTER		*iocp;
 
-	dctlprintk((KERN_INFO "mptctl_do_reset called.\n"));
-
 	if (copy_from_user(&krinfo, urinfo, sizeof(struct mpt_ioctl_diag_reset))) {
 		printk(KERN_ERR "%s@%d::mptctl_do_reset - "
 				"Unable to copy mpt_ioctl_diag_reset struct @ %p\n",
@@ -658,11 +667,14 @@ static int mptctl_do_reset(unsigned long
 	}
 
 	if (mpt_verify_adapter(krinfo.hdr.iocnum, &iocp) < 0) {
-		dctlprintk((KERN_ERR "%s@%d::mptctl_do_reset - ioc%d not found!\n",
-				__FILE__, __LINE__, krinfo.hdr.iocnum));
+		printk(KERN_DEBUG "%s@%d::mptctl_do_reset - ioc%d not found!\n",
+				__FILE__, __LINE__, krinfo.hdr.iocnum);
 		return -ENODEV; /* (-6) No such device or address */
 	}
 
+	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "mptctl_do_reset called.\n",
+	    iocp->name));
+
 	if (mpt_HardResetHandler(iocp, CAN_SLEEP) != 0) {
 		printk (KERN_ERR "%s@%d::mptctl_do_reset - reset failed.\n",
 			__FILE__, __LINE__);
@@ -695,7 +707,6 @@ mptctl_fw_download(unsigned long arg)
 	struct mpt_fw_xfer __user *ufwdl = (void __user *) arg;
 	struct mpt_fw_xfer	 kfwdl;
 
-	dctlprintk((KERN_INFO "mptctl_fwdl called. mptctl_id = %xh\n", mptctl_id)); //tc
 	if (copy_from_user(&kfwdl, ufwdl, sizeof(struct mpt_fw_xfer))) {
 		printk(KERN_ERR "%s@%d::_ioctl_fwdl - "
 				"Unable to copy mpt_fw_xfer struct @ %p\n",
@@ -744,15 +755,8 @@ mptctl_do_fw_download(int ioc, char __us
 	u16			 iocstat;
 	pFWDownloadReply_t	 ReplyMsg = NULL;
 
-	dctlprintk(("mptctl_do_fwdl called. mptctl_id = %xh.\n", mptctl_id));
-
-	dctlprintk(("DbG: kfwdl.bufp  = %p\n", ufwbuf));
-	dctlprintk(("DbG: kfwdl.fwlen = %d\n", (int)fwlen));
-	dctlprintk(("DbG: kfwdl.ioc   = %04xh\n", ioc));
-
 	if (mpt_verify_adapter(ioc, &iocp) < 0) {
-		dctlprintk(("ioctl_fwdl - ioc%d not found!\n",
-				 ioc));
+		printk(KERN_DEBUG "ioctl_fwdl - ioc%d not found!\n",				 ioc);
 		return -ENODEV; /* (-6) No such device or address */
 	} else {
 
@@ -761,6 +765,16 @@ mptctl_do_fw_download(int ioc, char __us
 		if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
 			return -EAGAIN;
 	}
+
+	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT
+	    "mptctl_do_fwdl called. mptctl_id = %xh.\n", iocp->name, mptctl_id));
+	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.bufp  = %p\n",
+	    iocp->name, ufwbuf));
+	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.fwlen = %d\n",
+	    iocp->name, (int)fwlen));
+	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.ioc   = %04xh\n",
+	    iocp->name, ioc));
+
 	dlmsg = (FWDownload_t*) mf;
 	ptsge = (FWDownloadTCSGE_t *) &dlmsg->SGL;
 	sgOut = (char *) (ptsge + 1);
@@ -829,7 +843,8 @@ mptctl_do_fw_download(int ioc, char __us
 		goto fwdl_out;
 	}
 
-	dctlprintk(("DbG: sgl buffer  = %p, sgfrags = %d\n", sgl, numfrags));
+	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: sgl buffer = %p, sgfrags = %d\n",
+	    iocp->name, sgl, numfrags));
 
 	/*
 	 * Parse SG list, copying sgl itself,
@@ -865,15 +880,7 @@ mptctl_do_fw_download(int ioc, char __us
 		sgOut += (sizeof(dma_addr_t) + sizeof(u32));
 	}
 
-#ifdef MPT_DEBUG
-	{
-		u32 *m = (u32 *)mf;
-		printk(KERN_INFO MYNAM ": F/W download request:\n" KERN_INFO " ");
-		for (i=0; i < 7+numfrags*2; i++)
-			printk(" %08x", le32_to_cpu(m[i]));
-		printk("\n");
-	}
-#endif
+	DBG_DUMP_FW_DOWNLOAD(iocp, (u32 *)mf, numfrags);
 
 	/*
 	 * Finally, perform firmware download.
@@ -1049,13 +1056,11 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 	*frags = numfrags;
 	*blp = buflist;
 
-	dctlprintk((KERN_INFO MYNAM "-SG: kbuf_alloc_2_sgl() - "
-			   "%d SG frags generated!\n",
-			   numfrags));
-
-	dctlprintk((KERN_INFO MYNAM "-SG: kbuf_alloc_2_sgl() - "
-			   "last (big) alloc_sz=%d\n",
-			   alloc_sz));
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "-SG: kbuf_alloc_2_sgl() - "
+	   "%d SG frags generated!\n", ioc->name, numfrags));
+
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "-SG: kbuf_alloc_2_sgl() - "
+	   "last (big) alloc_sz=%d\n", ioc->name, alloc_sz));
 
 	return sglbuf;
 
@@ -1139,7 +1144,8 @@ kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_
 
 	pci_free_consistent(ioc->pcidev, MAX_SGL_BYTES, sgl, sgl_dma);
 	kfree(buflist);
-	dctlprintk((KERN_INFO MYNAM "-SG: Free'd 1 SGL buf + %d kbufs!\n", n));
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "-SG: Free'd 1 SGL buf + %d kbufs!\n",
+	    ioc->name, n));
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1166,7 +1172,6 @@ mptctl_getiocinfo (unsigned long arg, un
 	struct scsi_device 	*sdev;
 	VirtDevice		*vdev;
 
-	dctlprintk((": mptctl_getiocinfo called.\n"));
 	/* Add of PCI INFO results in unaligned access for
 	 * IA64 and Sparc. Reset long to int. Return no PCI
 	 * data for obsolete format.
@@ -1199,8 +1204,8 @@ mptctl_getiocinfo (unsigned long arg, un
 
 	if (((iocnum = mpt_verify_adapter(karg->hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_getiocinfo() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_getiocinfo() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		kfree(karg);
 		return -ENODEV;
 	}
@@ -1214,6 +1219,9 @@ mptctl_getiocinfo (unsigned long arg, un
 		return -EFAULT;
 	}
 
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_getiocinfo called.\n",
+	    ioc->name));
+
 	/* Fill in the data and return the structure to the calling
 	 * program
 	 */
@@ -1320,7 +1328,6 @@ mptctl_gettargetinfo (unsigned long arg)
 	u8			port;
 	struct scsi_device 	*sdev;
 
-	dctlprintk(("mptctl_gettargetinfo called.\n"));
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_targetinfo))) {
 		printk(KERN_ERR "%s@%d::mptctl_gettargetinfo - "
 			"Unable to read in mpt_ioctl_targetinfo struct @ %p\n",
@@ -1330,11 +1337,13 @@ mptctl_gettargetinfo (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_gettargetinfo() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_gettargetinfo() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
 
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_gettargetinfo called.\n",
+	    ioc->name));
 	/* Get the port number and set the maximum number of bytes
 	 * in the returned structure.
 	 * Ignore the port setting.
@@ -1434,7 +1443,6 @@ mptctl_readtest (unsigned long arg)
 	MPT_ADAPTER *ioc;
 	int iocnum;
 
-	dctlprintk(("mptctl_readtest called.\n"));
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_test))) {
 		printk(KERN_ERR "%s@%d::mptctl_readtest - "
 			"Unable to read in mpt_ioctl_test struct @ %p\n",
@@ -1444,11 +1452,13 @@ mptctl_readtest (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_readtest() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_readtest() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
 
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_readtest called.\n",
+	    ioc->name));
 	/* Fill in the data and return the structure to the calling
 	 * program
 	 */
@@ -1494,7 +1504,6 @@ mptctl_eventquery (unsigned long arg)
 	MPT_ADAPTER *ioc;
 	int iocnum;
 
-	dctlprintk(("mptctl_eventquery called.\n"));
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventquery))) {
 		printk(KERN_ERR "%s@%d::mptctl_eventquery - "
 			"Unable to read in mpt_ioctl_eventquery struct @ %p\n",
@@ -1504,11 +1513,13 @@ mptctl_eventquery (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_eventquery() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_eventquery() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
 
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_eventquery called.\n",
+	    ioc->name));
 	karg.eventEntries = MPTCTL_EVENT_LOG_SIZE;
 	karg.eventTypes = ioc->eventTypes;
 
@@ -1532,7 +1543,6 @@ mptctl_eventenable (unsigned long arg)
 	MPT_ADAPTER *ioc;
 	int iocnum;
 
-	dctlprintk(("mptctl_eventenable called.\n"));
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventenable))) {
 		printk(KERN_ERR "%s@%d::mptctl_eventenable - "
 			"Unable to read in mpt_ioctl_eventenable struct @ %p\n",
@@ -1542,11 +1552,13 @@ mptctl_eventenable (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_eventenable() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_eventenable() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
 
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_eventenable called.\n",
+	    ioc->name));
 	if (ioc->events == NULL) {
 		/* Have not yet allocated memory - do so now.
 		 */
@@ -1579,7 +1591,6 @@ mptctl_eventreport (unsigned long arg)
 	int			 iocnum;
 	int			 numBytes, maxEvents, max;
 
-	dctlprintk(("mptctl_eventreport called.\n"));
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventreport))) {
 		printk(KERN_ERR "%s@%d::mptctl_eventreport - "
 			"Unable to read in mpt_ioctl_eventreport struct @ %p\n",
@@ -1589,10 +1600,12 @@ mptctl_eventreport (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_eventreport() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_eventreport() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_eventreport called.\n",
+	    ioc->name));
 
 	numBytes = karg.hdr.maxDataSize - sizeof(mpt_ioctl_header);
 	maxEvents = numBytes/sizeof(MPT_IOCTL_EVENTS);
@@ -1632,7 +1645,6 @@ mptctl_replace_fw (unsigned long arg)
 	int			 iocnum;
 	int			 newFwSize;
 
-	dctlprintk(("mptctl_replace_fw called.\n"));
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_replace_fw))) {
 		printk(KERN_ERR "%s@%d::mptctl_replace_fw - "
 			"Unable to read in mpt_ioctl_replace_fw struct @ %p\n",
@@ -1642,11 +1654,13 @@ mptctl_replace_fw (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_replace_fw() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_replace_fw() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
 
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_replace_fw called.\n",
+	    ioc->name));
 	/* If caching FW, Free the old FW image
 	 */
 	if (ioc->cached_fw == NULL)
@@ -1704,7 +1718,6 @@ mptctl_mpt_command (unsigned long arg)
 	int		iocnum;
 	int		rc;
 
-	dctlprintk(("mptctl_command called.\n"));
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_command))) {
 		printk(KERN_ERR "%s@%d::mptctl_mpt_command - "
@@ -1715,8 +1728,8 @@ mptctl_mpt_command (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_mpt_command() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_mpt_command() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
 
@@ -1756,13 +1769,12 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	ulong 		timeout;
 	struct scsi_device *sdev;
 
-	dctlprintk(("mptctl_do_mpt_command called.\n"));
 	bufIn.kptr = bufOut.kptr = NULL;
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_do_mpt_command() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_do_mpt_command() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
 	if (!ioc->ioctl) {
@@ -1816,6 +1828,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 
 	/* Verify that this request is allowed.
 	 */
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "sending mpi function (0x%02X), req=%p\n",
+	    ioc->name, hdr->Function, mf));
+
 	switch (hdr->Function) {
 	case MPI_FUNCTION_IOC_FACTS:
 	case MPI_FUNCTION_PORT_FACTS:
@@ -1823,6 +1838,18 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 		break;
 
 	case MPI_FUNCTION_CONFIG:
+	{
+		Config_t *config_frame;
+		config_frame = (Config_t *)mf;
+		dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\ttype=0x%02x ext_type=0x%02x "
+		    "number=0x%02x action=0x%02x\n", ioc->name,
+		    config_frame->Header.PageType,
+		    config_frame->ExtPageType,
+		    config_frame->Header.PageNumber,
+		    config_frame->Action));
+		break;
+	}
+
 	case MPI_FUNCTION_FC_COMMON_TRANSPORT_SEND:
 	case MPI_FUNCTION_FC_EX_LINK_SRVC_SEND:
 	case MPI_FUNCTION_FW_UPLOAD:
@@ -2158,12 +2185,12 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	ioc->ioctl->wait_done = 0;
 	if (hdr->Function == MPI_FUNCTION_SCSI_TASK_MGMT) {
 
-		DBG_DUMP_TM_REQUEST_FRAME((u32 *)mf);
+		DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)mf);
 
 		if (mpt_send_handshake_request(mptctl_id, ioc,
 			sizeof(SCSITaskMgmt_t), (u32*)mf,
 			CAN_SLEEP) != 0) {
-			dfailprintk((MYIOC_s_ERR_FMT "_send_handshake FAILED!"
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "_send_handshake FAILED!"
 				" (ioc %p, mf %p) \n", ioc->name,
 				ioc, mf));
 			mptctl_free_tm_flags(ioc);
@@ -2303,7 +2330,6 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	MPT_FRAME_HDR		*mf = NULL;
 	MPIHeader_t		*mpi_hdr;
 
-	dctlprintk((": mptctl_hp_hostinfo called.\n"));
 	/* Reset long to int. Should affect IA64 and SPARC only
 	 */
 	if (data_size == sizeof(hp_host_info_t))
@@ -2322,10 +2348,12 @@ mptctl_hp_hostinfo(unsigned long arg, un
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_hp_hostinfo() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_hp_hostinfo() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": mptctl_hp_hostinfo called.\n",
+	    ioc->name));
 
 	/* Fill in the data and return the structure to the calling
 	 * program
@@ -2441,7 +2469,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	 * Gather ISTWI(Industry Standard Two Wire Interface) Data
 	 */
 	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
-		dfailprintk((MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
 		    ioc->name,__FUNCTION__));
 		goto out;
 	}
@@ -2474,7 +2502,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	     HZ*MPT_IOCTL_DEFAULT_TIMEOUT /* 10 sec */);
 
 	if(rc <=0 && (ioc->ioctl->wait_done != 1 )) {
-		/* 
+		/*
 		 * Now we need to reset the board
 		 */
 		mpt_free_msg_frame(ioc, mf);
@@ -2482,7 +2510,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 		goto out;
 	}
 
-	/* 
+	/*
 	 *ISTWI Data Definition
 	 * pbuf[0] = FW_VERSION = 0x4
 	 * pbuf[1] = Bay Count = 6 or 4 or 2, depending on
@@ -2538,7 +2566,6 @@ mptctl_hp_targetinfo(unsigned long arg)
 	ConfigPageHeader_t	hdr;
 	int			tmp, np, rc = 0;
 
-	dctlprintk((": mptctl_hp_targetinfo called.\n"));
 	if (copy_from_user(&karg, uarg, sizeof(hp_target_info_t))) {
 		printk(KERN_ERR "%s@%d::mptctl_hp_targetinfo - "
 			"Unable to read in hp_host_targetinfo struct @ %p\n",
@@ -2548,10 +2575,12 @@ mptctl_hp_targetinfo(unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 		(ioc == NULL)) {
-		dctlprintk((KERN_ERR "%s::mptctl_hp_targetinfo() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum));
+		printk(KERN_DEBUG "%s::mptctl_hp_targetinfo() @%d - ioc%d not found!\n",
+				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": mptctl_hp_targetinfo called.\n",
+	    ioc->name));
 
 	/*  There is nothing to do for FCP parts.
 	 */
@@ -2694,7 +2723,6 @@ compat_mptfwxfer_ioctl(struct file *filp
 	int nonblock = (filp->f_flags & O_NONBLOCK);
 	int ret;
 
-	dctlprintk((KERN_INFO MYNAM "::compat_mptfwxfer_ioctl() called\n"));
 
 	if (copy_from_user(&kfw32, (char __user *)arg, sizeof(kfw32)))
 		return -EFAULT;
@@ -2703,14 +2731,16 @@ compat_mptfwxfer_ioctl(struct file *filp
 	iocnumX = kfw32.iocnum & 0xFF;
 	if (((iocnum = mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
 	    (iocp == NULL)) {
-		dctlprintk((KERN_ERR MYNAM "::compat_mptfwxfer_ioctl @%d - ioc%d not found!\n",
-				__LINE__, iocnumX));
+		printk(KERN_DEBUG MYNAM "::compat_mptfwxfer_ioctl @%d - ioc%d not found!\n",
+				__LINE__, iocnumX);
 		return -ENODEV;
 	}
 
 	if ((ret = mptctl_syscall_down(iocp, nonblock)) != 0)
 		return ret;
 
+	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "compat_mptfwxfer_ioctl() called\n",
+	    iocp->name));
 	kfw.iocnum = iocnum;
 	kfw.fwlen = kfw32.fwlen;
 	kfw.bufp = compat_ptr(kfw32.bufp);
@@ -2734,8 +2764,6 @@ compat_mpt_command(struct file *filp, un
 	int nonblock = (filp->f_flags & O_NONBLOCK);
 	int ret;
 
-	dctlprintk((KERN_INFO MYNAM "::compat_mpt_command() called\n"));
-
 	if (copy_from_user(&karg32, (char __user *)arg, sizeof(karg32)))
 		return -EFAULT;
 
@@ -2743,14 +2771,16 @@ compat_mpt_command(struct file *filp, un
 	iocnumX = karg32.hdr.iocnum & 0xFF;
 	if (((iocnum = mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
 	    (iocp == NULL)) {
-		dctlprintk((KERN_ERR MYNAM "::compat_mpt_command @%d - ioc%d not found!\n",
-				__LINE__, iocnumX));
+		printk(KERN_DEBUG MYNAM "::compat_mpt_command @%d - ioc%d not found!\n",
+				__LINE__, iocnumX);
 		return -ENODEV;
 	}
 
 	if ((ret = mptctl_syscall_down(iocp, nonblock)) != 0)
 		return ret;
 
+	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "compat_mpt_command() called\n",
+	    iocp->name));
 	/* Copy data to karg */
 	karg.hdr.iocnum = karg32.hdr.iocnum;
 	karg.hdr.port = karg32.hdr.port;
@@ -2878,11 +2908,7 @@ static int __init mptctl_init(void)
 
 	show_mptmod_ver(my_NAME, my_VERSION);
 
-	if(mpt_device_driver_register(&mptctl_driver,
-	  MPTCTL_DRIVER) != 0 ) {
-		dprintk((KERN_INFO MYNAM
-		": failed to register dd callbacks\n"));
-	}
+	mpt_device_driver_register(&mptctl_driver, MPTCTL_DRIVER);
 
 	/* Register this device */
 	err = misc_register(&mptctl_miscdev);
@@ -2905,16 +2931,8 @@ static int __init mptctl_init(void)
 		goto out_fail;
 	}
 
-	if (mpt_reset_register(mptctl_id, mptctl_ioc_reset) == 0) {
-		dprintk((KERN_INFO MYNAM ": Registered for IOC reset notifications\n"));
-	} else {
-		/* FIXME! */
-	}
-
-	if (mpt_event_register(mptctl_id, mptctl_event_process) == 0) {
-		devtverboseprintk((KERN_INFO MYNAM
-		  ": Registered for IOC event notifications\n"));
-	}
+	mpt_reset_register(mptctl_id, mptctl_ioc_reset);
+	mpt_event_register(mptctl_id, mptctl_event_process);
 
 	return 0;
 
@@ -2934,11 +2952,9 @@ static void mptctl_exit(void)
 
 	/* De-register reset handler from base module */
 	mpt_reset_deregister(mptctl_id);
-	dprintk((KERN_INFO MYNAM ": Deregistered for IOC reset notifications\n"));
 
 	/* De-register callback handler from base module */
 	mpt_deregister(mptctl_id);
-	printk(KERN_INFO MYNAM ": Deregistered from Fusion MPT base driver\n");
 
         mpt_device_driver_deregister(MPTCTL_DRIVER);
 
