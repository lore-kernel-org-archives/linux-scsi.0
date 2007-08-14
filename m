From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 2/6] mpt fusion: Usage of high priority request FIFO to send task management commands
Date: Tue, 14 Aug 2007 16:08:40 +0530
Message-ID: <20070814103840.GB9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39225 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbXHNKmF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2007 06:42:05 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l7EAeY8b024508
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2007 03:40:34 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

Added support for sending the task management requests through High priority 
request FIFO instead of Doorbell writes when firmware support High priority
FIFO.

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 81e9e9c..290f126 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -842,6 +842,38 @@ mpt_put_msg_frame(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 	CHIPREG_WRITE32(&ioc->chip->RequestFifo, mf_dma_addr);
 }
 
+/**
+ *	mpt_put_msg_frame_hi_pri - Send a protocol specific MPT request frame
+ *	to a IOC using hi priority request queue.
+ *	@handle: Handle of registered MPT protocol driver
+ *	@ioc: Pointer to MPT adapter structure
+ *	@mf: Pointer to MPT request frame
+ *
+ *	This routine posts a MPT request frame to the request post FIFO of a
+ *	specific MPT adapter.
+ **/
+void
+mpt_put_msg_frame_hi_pri(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
+{
+	u32 mf_dma_addr;
+	int req_offset;
+	u16	 req_idx;	/* Request index */
+
+	/* ensure values are reset properly! */
+	mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;
+	req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
+	req_idx = req_offset / ioc->req_sz;
+	mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(req_idx);
+	mf->u.frame.hwhdr.msgctxu.fld.rsvd = 0;
+
+	DBG_DUMP_PUT_MSG_FRAME(ioc, (u32 *)mf);
+
+	mf_dma_addr = (ioc->req_frames_low_dma + req_offset);
+	dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mf_dma_addr=%x req_idx=%d\n",
+		ioc->name, mf_dma_addr, req_idx));
+	CHIPREG_WRITE32(&ioc->chip->RequestHiPriFifo, mf_dma_addr);
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_free_msg_frame - Place MPT request frame back on FreeQ.
@@ -7315,6 +7347,7 @@ EXPORT_SYMBOL(mpt_device_driver_register);
 EXPORT_SYMBOL(mpt_device_driver_deregister);
 EXPORT_SYMBOL(mpt_get_msg_frame);
 EXPORT_SYMBOL(mpt_put_msg_frame);
+EXPORT_SYMBOL(mpt_put_msg_frame_hi_pri);
 EXPORT_SYMBOL(mpt_free_msg_frame);
 EXPORT_SYMBOL(mpt_add_sge);
 EXPORT_SYMBOL(mpt_send_handshake_request);
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index a8c8080..012be5e 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -336,7 +336,8 @@ typedef struct _SYSIF_REGS
 	u32	Reserved2[2];	/* 38-3F  reserved for future use    */
 	u32	RequestFifo;	/* 40     Request Post/Free FIFO     */
 	u32	ReplyFifo;	/* 44     Reply   Post/Free FIFO     */
-	u32	Reserved3[2];	/* 48-4F  reserved for future use    */
+	u32	RequestHiPriFifo; /* 48   Hi Priority Request FIFO   */
+	u32	Reserved3;	/* 4C-4F  reserved for future use    */
 	u32	HostIndex;	/* 50     Host Index register        */
 	u32	Reserved4[15];	/* 54-8F                             */
 	u32	Fubar;		/* 90     For Fubar usage            */
@@ -893,6 +894,7 @@ extern void	 mpt_device_driver_deregister(int cb_idx);
 extern MPT_FRAME_HDR	*mpt_get_msg_frame(int handle, MPT_ADAPTER *ioc);
 extern void	 mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 extern void	 mpt_put_msg_frame(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
+extern void	 mpt_put_msg_frame_hi_pri(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 extern void	 mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr);
 
 extern int	 mpt_send_handshake_request(int handle, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag);
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 89695e7..ca75ee8 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -342,7 +342,7 @@ static int mptctl_bus_reset(MPT_IOCTL *ioctl)
 	SCSITaskMgmt_t	*pScsiTm;
 	MPT_SCSI_HOST	*hd;
 	int		 ii;
-	int		 retval;
+	int		 retval=0;
 
 
 	ioctl->reset &= ~MPTCTL_RESET_OK;
@@ -395,12 +395,19 @@ static int mptctl_bus_reset(MPT_IOCTL *ioctl)
 	DBG_DUMP_TM_REQUEST_FRAME(ioctl->ioc, (u32 *)mf);
 
 	ioctl->wait_done=0;
-	if ((retval = mpt_send_handshake_request(mptctl_id, ioctl->ioc,
-	     sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP)) != 0) {
-		dfailprintk(ioctl->ioc, printk(MYIOC_s_ERR_FMT "_send_handshake FAILED!"
-			" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,
-			hd->ioc, mf));
-		goto mptctl_bus_reset_done;
+
+	if ((ioctl->ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
+	    (ioctl->ioc->facts.MsgVersion >= MPI_VERSION_01_05))
+		mpt_put_msg_frame_hi_pri(mptctl_id, ioctl->ioc, mf);
+	else {
+		retval = mpt_send_handshake_request(mptctl_id, ioctl->ioc,
+	     		sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP);
+		if (retval != 0) {
+			dfailprintk(ioctl->ioc, printk(MYIOC_s_ERR_FMT "_send_handshake FAILED!"
+				" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,
+				hd->ioc, mf));
+			goto mptctl_bus_reset_done;
+		}
 	}
 
 	/* Now wait for the command to complete */
@@ -2187,15 +2194,20 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 
 		DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)mf);
 
-		if (mpt_send_handshake_request(mptctl_id, ioc,
-			sizeof(SCSITaskMgmt_t), (u32*)mf,
-			CAN_SLEEP) != 0) {
-			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "_send_handshake FAILED!"
-				" (ioc %p, mf %p) \n", ioc->name,
-				ioc, mf));
-			mptctl_free_tm_flags(ioc);
-			rc = -ENODATA;
-			goto done_free_mem;
+		if ((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
+		    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
+			mpt_put_msg_frame_hi_pri(mptctl_id, ioc, mf);
+		else {
+			rc =mpt_send_handshake_request(mptctl_id, ioc,
+				sizeof(SCSITaskMgmt_t), (u32*)mf, CAN_SLEEP);
+			if (rc != 0) {
+				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+				    "_send_handshake FAILED! (ioc %p, mf %p)\n",
+				    ioc->name, ioc, mf));
+				mptctl_free_tm_flags(ioc);
+				rc = -ENODATA;
+				goto done_free_mem;
+			}
 		}
 
 	} else
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index b9c69bf..fe3b505 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -623,13 +623,7 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8 channel, u8 id)
 
 	DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)mf);
 
-	if (mpt_send_handshake_request(ioc->TaskCtx, ioc,
-	    sizeof(SCSITaskMgmt_t), (u32 *)mf, NO_SLEEP)) {
-		mpt_free_msg_frame(ioc, mf);
-		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, tm handshake failed @%d!!\n",
-		    ioc->name,__FUNCTION__, __LINE__));
-		return 0;
-	}
+	mpt_put_msg_frame_hi_pri(ioc->TaskCtx, ioc, mf);
 
 	return 1;
 }
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 5431529..b8b0598 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1717,12 +1717,18 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, i
 
 	DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)pScsiTm);
 
-	if ((retval = mpt_send_handshake_request(hd->ioc->TaskCtx, hd->ioc,
-		sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP)) != 0) {
-		dfailprintk(hd->ioc, printk(MYIOC_s_ERR_FMT "send_handshake FAILED!"
+	if ((hd->ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
+	    (hd->ioc->facts.MsgVersion >= MPI_VERSION_01_05))
+		mpt_put_msg_frame_hi_pri(hd->ioc->TaskCtx, hd->ioc, mf);
+	else {
+		retval = mpt_send_handshake_request(hd->ioc->TaskCtx, hd->ioc,
+			sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP);
+		if (retval) {
+			dfailprintk(hd->ioc, printk(MYIOC_s_ERR_FMT "send_handshake FAILED!"
 			" (hd %p, ioc %p, mf %p, rc=%d) \n", hd->ioc->name, hd,
 			hd->ioc, mf, retval));
-		goto fail_out;
+			goto fail_out;
+		}
 	}
 
 	if(mptscsih_tm_wait_for_completion(hd, timeout) == FAILED) {
