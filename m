From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 3/6] mpt fusion: Changing call back indices to u8 from int
Date: Tue, 14 Aug 2007 16:12:53 +0530
Message-ID: <20070814104253.GC9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39431 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbXHNKqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2007 06:46:19 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l7EAil8H024679
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2007 03:44:47 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

The call back index requires only u8 but in lot of places it is referred as int, now everywhere the call back index variables are declared as u8 with uniform name cb_idx

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 290f126..71d967d 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -102,8 +102,6 @@ static int mfcounter = 0;
 /*
  *  Public data...
  */
-int mpt_lan_index = -1;
-int mpt_stm_index = -1;
 
 struct proc_dir_entry *mpt_proc_root_dir;
 
@@ -125,11 +123,14 @@ static MPT_EVHANDLER		 MptEvHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 static MPT_RESETHANDLER		 MptResetHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 static struct mpt_pci_driver 	*MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 
-static int	mpt_base_index = -1;
-static int	last_drv_idx = -1;
-
 static DECLARE_WAIT_QUEUE_HEAD(mpt_waitq);
 
+/*
+ *  Driver Callback Index's
+ */
+static u8 mpt_base_index = MPT_MAX_PROTOCOL_DRIVERS;
+static u8 last_drv_idx;
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *  Forward protos...
@@ -235,6 +236,23 @@ static int mpt_set_debug_level(const char *val, struct kernel_param *kp)
 	return 0;
 }
 
+/**
+ *	mpt_get_cb_idx - obtain cb_idx for registered driver
+ *	@dclass: class driver enum
+ *
+ *	Returns cb_idx, or zero means it wasn't found
+ **/
+static u8
+mpt_get_cb_idx(MPT_DRIVER_CLASS dclass)
+{
+	u8 cb_idx;
+
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--)
+		if (MptDriverClass[cb_idx] == dclass)
+			return cb_idx;
+	return 0;
+}
+
 /*
  *  Process turbo (context) reply...
  */
@@ -243,8 +261,8 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)
 {
 	MPT_FRAME_HDR *mf = NULL;
 	MPT_FRAME_HDR *mr = NULL;
-	int req_idx = 0;
-	int cb_idx;
+	u16 req_idx = 0;
+	u8 cb_idx;
 
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Got TURBO reply req_idx=%08x\n",
 				ioc->name, pa));
@@ -256,7 +274,7 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)
 		mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
 		break;
 	case MPI_CONTEXT_REPLY_TYPE_LAN:
-		cb_idx = mpt_lan_index;
+		cb_idx = mpt_get_cb_idx(MPTLAN_DRIVER);
 		/*
 		 *  Blind set of mf to NULL here was fatal
 		 *  after lan_reply says "freeme"
@@ -277,7 +295,7 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)
 		mr = (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);
 		break;
 	case MPI_CONTEXT_REPLY_TYPE_SCSI_TARGET:
-		cb_idx = mpt_stm_index;
+		cb_idx = mpt_get_cb_idx(MPTSTM_DRIVER);
 		mr = (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);
 		break;
 	default:
@@ -286,7 +304,7 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)
 	}
 
 	/*  Check for (valid) IO callback!  */
-	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
+	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
 			MptCallbacks[cb_idx] == NULL) {
 		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",
 				__FUNCTION__, ioc->name, cb_idx);
@@ -304,8 +322,8 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 {
 	MPT_FRAME_HDR	*mf;
 	MPT_FRAME_HDR	*mr;
-	int		 req_idx;
-	int		 cb_idx;
+	u16		 req_idx;
+	u8		 cb_idx;
 	int		 freeme;
 
 	u32 reply_dma_low;
@@ -350,7 +368,7 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 		mpt_iocstatus_info(ioc, (u32)ioc_stat, mf);
 
 	/*  Check for (valid) IO callback!  */
-	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
+	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
 			MptCallbacks[cb_idx] == NULL) {
 		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",
 				__FUNCTION__, ioc->name, cb_idx);
@@ -563,28 +581,27 @@ mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *reply)
  *	in order to register separate callbacks; one for "normal" SCSI IO;
  *	one for MptScsiTaskMgmt requests; one for Scan/DV requests.
  *
- *	Returns a positive integer valued "handle" in the
- *	range (and S.O.D. order) {N,...,7,6,5,...,1} if successful.
- *	Any non-positive return value (including zero!) should be considered
- *	an error by the caller.
+ *	Returns u8 valued "handle" in the range (and S.O.D. order)
+ *	{N,...,7,6,5,...,1} if successful.
+ *	A return value of MPT_MAX_PROTOCOL_DRIVERS (including zero!) should be
+ *	considered an error by the caller.
  */
-int
+u8
 mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass)
 {
-	int i;
-
-	last_drv_idx = -1;
+	u8 cb_idx;
+	last_drv_idx = MPT_MAX_PROTOCOL_DRIVERS;
 
 	/*
 	 *  Search for empty callback slot in this order: {N,...,7,6,5,...,1}
 	 *  (slot/handle 0 is reserved!)
 	 */
-	for (i = MPT_MAX_PROTOCOL_DRIVERS-1; i; i--) {
-		if (MptCallbacks[i] == NULL) {
-			MptCallbacks[i] = cbfunc;
-			MptDriverClass[i] = dclass;
-			MptEvHandlers[i] = NULL;
-			last_drv_idx = i;
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptCallbacks[cb_idx] == NULL) {
+			MptCallbacks[cb_idx] = cbfunc;
+			MptDriverClass[cb_idx] = dclass;
+			MptEvHandlers[cb_idx] = NULL;
+			last_drv_idx = cb_idx;
 			break;
 		}
 	}
@@ -601,9 +618,9 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass)
  *	module is unloaded.
  */
 void
-mpt_deregister(int cb_idx)
+mpt_deregister(u8 cb_idx)
 {
-	if ((cb_idx >= 0) && (cb_idx < MPT_MAX_PROTOCOL_DRIVERS)) {
+	if (cb_idx  && (cb_idx < MPT_MAX_PROTOCOL_DRIVERS)) {
 		MptCallbacks[cb_idx] = NULL;
 		MptDriverClass[cb_idx] = MPTUNKNOWN_DRIVER;
 		MptEvHandlers[cb_idx] = NULL;
@@ -625,9 +642,9 @@ mpt_deregister(int cb_idx)
  *	Returns 0 for success.
  */
 int
-mpt_event_register(int cb_idx, MPT_EVHANDLER ev_cbfunc)
+mpt_event_register(u8 cb_idx, MPT_EVHANDLER ev_cbfunc)
 {
-	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+	if (!cb_idx  || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return -1;
 
 	MptEvHandlers[cb_idx] = ev_cbfunc;
@@ -645,9 +662,9 @@ mpt_event_register(int cb_idx, MPT_EVHANDLER ev_cbfunc)
  *	or when its module is unloaded.
  */
 void
-mpt_event_deregister(int cb_idx)
+mpt_event_deregister(u8 cb_idx)
 {
-	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+	if (!cb_idx  || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return;
 
 	MptEvHandlers[cb_idx] = NULL;
@@ -665,9 +682,9 @@ mpt_event_deregister(int cb_idx)
  *	Returns 0 for success.
  */
 int
-mpt_reset_register(int cb_idx, MPT_RESETHANDLER reset_func)
+mpt_reset_register(u8 cb_idx, MPT_RESETHANDLER reset_func)
 {
-	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return -1;
 
 	MptResetHandlers[cb_idx] = reset_func;
@@ -684,9 +701,9 @@ mpt_reset_register(int cb_idx, MPT_RESETHANDLER reset_func)
  *	or when its module is unloaded.
  */
 void
-mpt_reset_deregister(int cb_idx)
+mpt_reset_deregister(u8 cb_idx)
 {
-	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return;
 
 	MptResetHandlers[cb_idx] = NULL;
@@ -699,12 +716,12 @@ mpt_reset_deregister(int cb_idx)
  *	@cb_idx: MPT protocol driver index
  */
 int
-mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, int cb_idx)
+mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, u8 cb_idx)
 {
 	MPT_ADAPTER	*ioc;
 	const struct pci_device_id *id;
 
-	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+	if (!cb_idx  || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return -EINVAL;
 
 	MptDeviceDriverHandlers[cb_idx] = dd_cbfunc;
@@ -726,12 +743,12 @@ mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, int cb_idx)
  *	@cb_idx: MPT protocol driver index
  */
 void
-mpt_device_driver_deregister(int cb_idx)
+mpt_device_driver_deregister(u8 cb_idx)
 {
 	struct mpt_pci_driver *dd_cbfunc;
 	MPT_ADAPTER	*ioc;
 
-	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+	if (!cb_idx  || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return;
 
 	dd_cbfunc = MptDeviceDriverHandlers[cb_idx];
@@ -749,14 +766,14 @@ mpt_device_driver_deregister(int cb_idx)
 /**
  *	mpt_get_msg_frame - Obtain a MPT request frame from the pool (of 1024)
  *	allocated per MPT adapter.
- *	@handle: Handle of registered MPT protocol driver
+ *	@cb_idx: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *
  *	Returns pointer to a MPT request frame or %NULL if none are available
  *	or IOC is not active.
  */
 MPT_FRAME_HDR*
-mpt_get_msg_frame(int handle, MPT_ADAPTER *ioc)
+mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc)
 {
 	MPT_FRAME_HDR *mf;
 	unsigned long flags;
@@ -781,7 +798,7 @@ mpt_get_msg_frame(int handle, MPT_ADAPTER *ioc)
 				u.frame.linkage.list);
 		list_del(&mf->u.frame.linkage.list);
 		mf->u.frame.linkage.arg1 = 0;
-		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;	/* byte */
+		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = cb_idx;	/* byte */
 		req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
 								/* u16! */
 		req_idx = req_offset / ioc->req_sz;
@@ -805,7 +822,7 @@ mpt_get_msg_frame(int handle, MPT_ADAPTER *ioc)
 #endif
 
 	dmfprintk(ioc, printk(KERN_INFO MYNAM ": %s: mpt_get_msg_frame(%d,%d), got mf=%p\n",
-			ioc->name, handle, ioc->id, mf));
+			ioc->name, cb_idx, ioc->id, mf));
 	return mf;
 }
 
@@ -813,7 +830,7 @@ mpt_get_msg_frame(int handle, MPT_ADAPTER *ioc)
 /**
  *	mpt_put_msg_frame - Send a protocol specific MPT request frame
  *	to a IOC.
- *	@handle: Handle of registered MPT protocol driver
+ *	@cb_idx: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *	@mf: Pointer to MPT request frame
  *
@@ -821,14 +838,14 @@ mpt_get_msg_frame(int handle, MPT_ADAPTER *ioc)
  *	specific MPT adapter.
  */
 void
-mpt_put_msg_frame(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
+mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 {
 	u32 mf_dma_addr;
 	int req_offset;
 	u16	 req_idx;	/* Request index */
 
 	/* ensure values are reset properly! */
-	mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;		/* byte */
+	mf->u.frame.hwhdr.msgctxu.fld.cb_idx = cb_idx;		/* byte */
 	req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
 								/* u16! */
 	req_idx = req_offset / ioc->req_sz;
@@ -845,7 +862,7 @@ mpt_put_msg_frame(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 /**
  *	mpt_put_msg_frame_hi_pri - Send a protocol specific MPT request frame
  *	to a IOC using hi priority request queue.
- *	@handle: Handle of registered MPT protocol driver
+ *	@cb_idx: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *	@mf: Pointer to MPT request frame
  *
@@ -853,14 +870,14 @@ mpt_put_msg_frame(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
  *	specific MPT adapter.
  **/
 void
-mpt_put_msg_frame_hi_pri(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
+mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 {
 	u32 mf_dma_addr;
 	int req_offset;
 	u16	 req_idx;	/* Request index */
 
 	/* ensure values are reset properly! */
-	mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;
+	mf->u.frame.hwhdr.msgctxu.fld.cb_idx = cb_idx;
 	req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
 	req_idx = req_offset / ioc->req_sz;
 	mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(req_idx);
@@ -931,7 +948,7 @@ mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr)
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_send_handshake_request - Send MPT request via doorbell handshake method.
- *	@handle: Handle of registered MPT protocol driver
+ *	@cb_idx: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *	@reqBytes: Size of the request in bytes
  *	@req: Pointer to MPT request frame
@@ -946,7 +963,7 @@ mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr)
  *	Returns 0 for success, non-zero for failure.
  */
 int
-mpt_send_handshake_request(int handle, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag)
+mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag)
 {
 	int	r = 0;
 	u8	*req_as_bytes;
@@ -966,7 +983,7 @@ mpt_send_handshake_request(int handle, MPT_ADAPTER *ioc, int reqBytes, u32 *req,
 	if (reqBytes >= 12 && ii >= 0 && ii < ioc->req_depth) {
 		MPT_FRAME_HDR *mf = (MPT_FRAME_HDR*)req;
 		mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(ii);
-		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;
+		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = cb_idx;
 	}
 
 	/* Make sure there are no doorbells */
@@ -1432,6 +1449,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	u32		 msize;
 	u32		 psize;
 	int		 ii;
+	u8		 cb_idx;
 	int		 r = -ENODEV;
 	u8		 revision;
 	u8		 pcixcmd;
@@ -1655,10 +1673,10 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* call per device driver probe entry point */
-	for(ii=0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {
-		if(MptDeviceDriverHandlers[ii] &&
-		  MptDeviceDriverHandlers[ii]->probe) {
-			MptDeviceDriverHandlers[ii]->probe(pdev,id);
+	for(cb_idx=0; cb_idx<MPT_MAX_PROTOCOL_DRIVERS; cb_idx++) {
+		if(MptDeviceDriverHandlers[cb_idx] &&
+		  MptDeviceDriverHandlers[cb_idx]->probe) {
+			MptDeviceDriverHandlers[cb_idx]->probe(pdev,id);
 		}
 	}
 
@@ -1695,7 +1713,7 @@ mpt_detach(struct pci_dev *pdev)
 {
 	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
 	char pname[32];
-	int ii;
+	u8 cb_idx;
 
 	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/summary", ioc->name);
 	remove_proc_entry(pname, NULL);
@@ -1705,10 +1723,10 @@ mpt_detach(struct pci_dev *pdev)
 	remove_proc_entry(pname, NULL);
 
 	/* call per device driver remove entry point */
-	for(ii=0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {
-		if(MptDeviceDriverHandlers[ii] &&
-		  MptDeviceDriverHandlers[ii]->remove) {
-			MptDeviceDriverHandlers[ii]->remove(pdev);
+	for(cb_idx=0; cb_idx<MPT_MAX_PROTOCOL_DRIVERS; cb_idx++) {
+		if(MptDeviceDriverHandlers[cb_idx] &&
+		  MptDeviceDriverHandlers[cb_idx]->remove) {
+			MptDeviceDriverHandlers[cb_idx]->remove(pdev);
 		}
 	}
 
@@ -1820,7 +1838,7 @@ mpt_resume(struct pci_dev *pdev)
 #endif
 
 static int
-mpt_signal_reset(int index, MPT_ADAPTER *ioc, int reset_phase)
+mpt_signal_reset(u8 index, MPT_ADAPTER *ioc, int reset_phase)
 {
 	if ((MptDriverClass[index] == MPTSPI_DRIVER &&
 	     ioc->bus_type != SPI) ||
@@ -1862,6 +1880,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	int	 hard;
 	int	 rc=0;
 	int	 ii;
+	u8	 cb_idx;
 	int	 handlers;
 	int	 ret = 0;
 	int	 reset_alt_ioc_active = 0;
@@ -2146,20 +2165,20 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	 */
 	if (hard_reset_done) {
 		rc = handlers = 0;
-		for (ii=MPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {
-			if ((ret == 0) && MptResetHandlers[ii]) {
+		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+			if ((ret == 0) && MptResetHandlers[cb_idx]) {
 				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 					"Calling IOC post_reset handler #%d\n",
-					ioc->name, ii));
-				rc += mpt_signal_reset(ii, ioc, MPT_IOC_POST_RESET);
+					ioc->name, cb_idx));
+				rc += mpt_signal_reset(cb_idx, ioc, MPT_IOC_POST_RESET);
 				handlers++;
 			}
 
-			if (alt_ioc_ready && MptResetHandlers[ii]) {
+			if (alt_ioc_ready && MptResetHandlers[cb_idx]) {
 				drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 					"Calling alt-%s post_reset handler #%d\n",
-					ioc->name, ioc->alt_ioc->name, ii));
-				rc += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_POST_RESET);
+					ioc->name, ioc->alt_ioc->name, cb_idx));
+				rc += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_POST_RESET);
 				handlers++;
 			}
 		}
@@ -3592,20 +3611,20 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 		 * MptResetHandlers[] registered yet.
 		 */
 		{
-			int	 ii;
+			u8	 cb_idx;
 			int	 r = 0;
 
-			for (ii=MPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {
-				if (MptResetHandlers[ii]) {
+			for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+				if (MptResetHandlers[cb_idx]) {
 					dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 						"Calling IOC pre_reset handler #%d\n",
-						ioc->name, ii));
-					r += mpt_signal_reset(ii, ioc, MPT_IOC_PRE_RESET);
+						ioc->name, cb_idx));
+					r += mpt_signal_reset(cb_idx, ioc, MPT_IOC_PRE_RESET);
 					if (ioc->alt_ioc) {
 						dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 							"Calling alt-%s pre_reset handler #%d\n",
-							ioc->name, ioc->alt_ioc->name, ii));
-						r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_PRE_RESET);
+							ioc->name, ioc->alt_ioc->name, cb_idx));
+						r += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_PRE_RESET);
 					}
 				}
 			}
@@ -5907,7 +5926,7 @@ procmpt_summary_read(char *buf, char **start, off_t offset, int request, int *eo
 static int
 procmpt_version_read(char *buf, char **start, off_t offset, int request, int *eof, void *data)
 {
-	int	 ii;
+	u8	 cb_idx;
 	int	 scsi, fc, sas, lan, ctl, targ, dmp;
 	char	*drvname;
 	int	 len;
@@ -5916,10 +5935,10 @@ procmpt_version_read(char *buf, char **start, off_t offset, int request, int *eo
 	len += sprintf(buf+len, "  Fusion MPT base driver\n");
 
 	scsi = fc = sas = lan = ctl = targ = dmp = 0;
-	for (ii=MPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {
+	for (cb_idx=MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
 		drvname = NULL;
-		if (MptCallbacks[ii]) {
-			switch (MptDriverClass[ii]) {
+		if (MptCallbacks[cb_idx]) {
+			switch (MptDriverClass[cb_idx]) {
 			case MPTSPI_DRIVER:
 				if (!scsi++) drvname = "SPI host";
 				break;
@@ -6163,18 +6182,18 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	 * For all other protocol drivers, this is a no-op.
 	 */
 	{
-		int	 ii;
+		u8	 cb_idx;
 		int	 r = 0;
 
-		for (ii=MPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {
-			if (MptResetHandlers[ii]) {
+		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+			if (MptResetHandlers[cb_idx]) {
 				dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling IOC reset_setup handler #%d\n",
-						ioc->name, ii));
-				r += mpt_signal_reset(ii, ioc, MPT_IOC_SETUP_RESET);
+						ioc->name, cb_idx));
+				r += mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
 				if (ioc->alt_ioc) {
 					dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling alt-%s setup reset handler #%d\n",
-							ioc->name, ioc->alt_ioc->name, ii));
-					r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
+							ioc->name, ioc->alt_ioc->name, cb_idx));
+					r += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
 				}
 			}
 		}
@@ -6579,6 +6598,7 @@ ProcessEventNotification(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply
 	u32 evData0 = 0;
 //	u32 evCtx;
 	int ii;
+	u8 cb_idx;
 	int r = 0;
 	int handlers = 0;
 	char evStr[EVENT_DESCR_STR_SZ];
@@ -6659,11 +6679,11 @@ ProcessEventNotification(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply
 	/*
 	 *  Call each currently registered protocol event handler.
 	 */
-	for (ii=MPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {
-		if (MptEvHandlers[ii]) {
+	for (cb_idx=MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptEvHandlers[cb_idx]) {
 			devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Routing Event to event handler #%d\n",
-					ioc->name, ii));
-			r += (*(MptEvHandlers[ii]))(ioc, pEventReply);
+					ioc->name, cb_idx));
+			r += (*(MptEvHandlers[cb_idx]))(ioc, pEventReply);
 			handlers++;
 		}
 	}
@@ -7354,8 +7374,6 @@ EXPORT_SYMBOL(mpt_send_handshake_request);
 EXPORT_SYMBOL(mpt_verify_adapter);
 EXPORT_SYMBOL(mpt_GetIocState);
 EXPORT_SYMBOL(mpt_print_ioc_summary);
-EXPORT_SYMBOL(mpt_lan_index);
-EXPORT_SYMBOL(mpt_stm_index);
 EXPORT_SYMBOL(mpt_HardResetHandler);
 EXPORT_SYMBOL(mpt_config);
 EXPORT_SYMBOL(mpt_findImVolumes);
@@ -7373,16 +7391,16 @@ EXPORT_SYMBOL(mpt_raid_phys_disk_pg0);
 static int __init
 fusion_init(void)
 {
-	int i;
+	u8 cb_idx;
 
 	show_mptmod_ver(my_NAME, my_VERSION);
 	printk(KERN_INFO COPYRIGHT "\n");
 
-	for (i = 0; i < MPT_MAX_PROTOCOL_DRIVERS; i++) {
-		MptCallbacks[i] = NULL;
-		MptDriverClass[i] = MPTUNKNOWN_DRIVER;
-		MptEvHandlers[i] = NULL;
-		MptResetHandlers[i] = NULL;
+	for (cb_idx = 0; cb_idx < MPT_MAX_PROTOCOL_DRIVERS; cb_idx++) {
+		MptCallbacks[cb_idx] = NULL;
+		MptDriverClass[cb_idx] = MPTUNKNOWN_DRIVER;
+		MptEvHandlers[cb_idx] = NULL;
+		MptResetHandlers[cb_idx] = NULL;
 	}
 
 	/*  Register ourselves (mptbase) in order to facilitate
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 012be5e..04ef0a3 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -679,9 +679,9 @@ typedef struct _MPT_ADAPTER
 	u8			 reload_fw;	/* Force a FW Reload on next reset */
 	u8			 NBShiftFactor;  /* NB Shift Factor based on Block Size (Facts)  */
 	u8			 pad1[4];
-	int			 DoneCtx;
-	int			 TaskCtx;
-	int			 InternalCtx;
+	u8			 DoneCtx;
+	u8			 TaskCtx;
+	u8			 InternalCtx;
 	spinlock_t		 initializing_hba_lock;
 	int 	 		 initializing_hba_lock_flag;
 	struct list_head	 list;
@@ -883,21 +883,21 @@ extern void	 mpt_detach(struct pci_dev *pdev);
 extern int	 mpt_suspend(struct pci_dev *pdev, pm_message_t state);
 extern int	 mpt_resume(struct pci_dev *pdev);
 #endif
-extern int	 mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass);
-extern void	 mpt_deregister(int cb_idx);
-extern int	 mpt_event_register(int cb_idx, MPT_EVHANDLER ev_cbfunc);
-extern void	 mpt_event_deregister(int cb_idx);
-extern int	 mpt_reset_register(int cb_idx, MPT_RESETHANDLER reset_func);
-extern void	 mpt_reset_deregister(int cb_idx);
-extern int	 mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, int cb_idx);
-extern void	 mpt_device_driver_deregister(int cb_idx);
-extern MPT_FRAME_HDR	*mpt_get_msg_frame(int handle, MPT_ADAPTER *ioc);
+extern u8	 mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass);
+extern void	 mpt_deregister(u8 cb_idx);
+extern int	 mpt_event_register(u8 cb_idx, MPT_EVHANDLER ev_cbfunc);
+extern void	 mpt_event_deregister(u8 cb_idx);
+extern int	 mpt_reset_register(u8 cb_idx, MPT_RESETHANDLER reset_func);
+extern void	 mpt_reset_deregister(u8 cb_idx);
+extern int	 mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, u8 cb_idx);
+extern void	 mpt_device_driver_deregister(u8 cb_idx);
+extern MPT_FRAME_HDR	*mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc);
 extern void	 mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
-extern void	 mpt_put_msg_frame(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
-extern void	 mpt_put_msg_frame_hi_pri(int handle, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
+extern void	 mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
+extern void	 mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 extern void	 mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr);
 
-extern int	 mpt_send_handshake_request(int handle, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag);
+extern int	 mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag);
 extern int	 mpt_verify_adapter(int iocid, MPT_ADAPTER **iocpp);
 extern u32	 mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);
 extern void	 mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buf, int *size, int len, int showlan);
@@ -915,9 +915,6 @@ extern int	 mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num, pRaidPhys
 extern struct list_head	  ioc_list;
 extern struct proc_dir_entry	*mpt_proc_root_dir;
 
-extern int		  mpt_lan_index;	/* needed by mptlan.c */
-extern int		  mpt_stm_index;	/* needed by mptstm.c */
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif		/* } __KERNEL__ */
 
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index ca75ee8..0801b30 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -83,7 +83,7 @@ MODULE_VERSION(my_VERSION);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
-static int mptctl_id = -1;
+static u8 mptctl_id = MPT_MAX_PROTOCOL_DRIVERS;
 
 static DECLARE_WAIT_QUEUE_HEAD ( mptctl_wait );
 
@@ -2936,7 +2936,8 @@ static int __init mptctl_init(void)
 	 *  Install our handler
 	 */
 	++where;
-	if ((mptctl_id = mpt_register(mptctl_reply, MPTCTL_DRIVER)) < 0) {
+	mptctl_id = mpt_register(mptctl_reply, MPTCTL_DRIVER);
+	if (!mptctl_id || mptctl_id >= MPT_MAX_PROTOCOL_DRIVERS) {
 		printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
 		misc_deregister(&mptctl_miscdev);
 		err = -EBUSY;
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 8422c25..2b3e27a 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -90,9 +90,9 @@ static int max_lun = MPTFC_MAX_LUN;
 module_param(max_lun, int, 0);
 MODULE_PARM_DESC(max_lun, " max lun, default=16895 ");
 
-static int	mptfcDoneCtx = -1;
-static int	mptfcTaskCtx = -1;
-static int	mptfcInternalCtx = -1; /* Used only for internal commands */
+static u8	mptfcDoneCtx = MPT_MAX_PROTOCOL_DRIVERS;
+static u8	mptfcTaskCtx = MPT_MAX_PROTOCOL_DRIVERS;
+static u8	mptfcInternalCtx = MPT_MAX_PROTOCOL_DRIVERS;
 
 static int mptfc_target_alloc(struct scsi_target *starget);
 static int mptfc_slave_alloc(struct scsi_device *sdev);
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 01fc397..9d9eb76 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -154,7 +154,7 @@ static unsigned short mpt_lan_type_trans(struct sk_buff *skb,
 /*
  *  Fusion MPT LAN private data
  */
-static int LanCtx = -1;
+static u8 LanCtx = MPT_MAX_PROTOCOL_DRIVERS;
 
 static u32 max_buckets_out = 127;
 static u32 tx_max_out_p = 127 - 16;
@@ -165,12 +165,6 @@ DEFINE_RWLOCK(bad_naa_lock);
 #endif
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- * Fusion MPT LAN external data
- */
-extern int mpt_lan_index;
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	lan_reply - Handle all data sent from the hardware.
  *	@ioc: Pointer to MPT_ADAPTER structure
@@ -1510,9 +1504,6 @@ static int __init mpt_lan_init (void)
 		return -EBUSY;
 	}
 
-	/* Set the callback index to be used by driver core for turbo replies */
-	mpt_lan_index = LanCtx;
-
 	dlprintk((KERN_INFO MYNAM ": assigned context of %d\n", LanCtx));
 
 	if (mpt_reset_register(LanCtx, mpt_lan_ioc_reset)) {
@@ -1533,10 +1524,9 @@ static void __exit mpt_lan_exit(void)
 	mpt_device_driver_deregister(MPTLAN_DRIVER);
 	mpt_reset_deregister(LanCtx);
 
-	if (LanCtx >= 0) {
+	if (LanCtx) {
 		mpt_deregister(LanCtx);
-		LanCtx = -1;
-		mpt_lan_index = 0;
+		LanCtx = MPT_MAX_PROTOCOL_DRIVERS;
 	}
 }
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index fe3b505..ffbf0e5 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -89,10 +89,10 @@ static int max_lun = MPTSAS_MAX_LUN;
 module_param(max_lun, int, 0);
 MODULE_PARM_DESC(max_lun, " max lun, default=16895 ");
 
-static int	mptsasDoneCtx = -1;
-static int	mptsasTaskCtx = -1;
-static int	mptsasInternalCtx = -1; /* Used only for internal commands */
-static int	mptsasMgmtCtx = -1;
+static u8	mptsasDoneCtx = MPT_MAX_PROTOCOL_DRIVERS;
+static u8	mptsasTaskCtx = MPT_MAX_PROTOCOL_DRIVERS;
+static u8	mptsasInternalCtx = MPT_MAX_PROTOCOL_DRIVERS; /* Used only for internal commands */
+static u8	mptsasMgmtCtx = MPT_MAX_PROTOCOL_DRIVERS;
 
 static void mptsas_hotplug_work(struct work_struct *work);
 
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index be59bbc..406d045 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -90,9 +90,9 @@ static int mptspi_write_spi_device_pg1(struct scsi_target *,
 
 static struct scsi_transport_template *mptspi_transport_template = NULL;
 
-static int	mptspiDoneCtx = -1;
-static int	mptspiTaskCtx = -1;
-static int	mptspiInternalCtx = -1; /* Used only for internal commands */
+static u8	mptspiDoneCtx = MPT_MAX_PROTOCOL_DRIVERS;
+static u8	mptspiTaskCtx = MPT_MAX_PROTOCOL_DRIVERS;
+static u8	mptspiInternalCtx = MPT_MAX_PROTOCOL_DRIVERS; /* Used only for internal commands */
 
 /**
  * 	mptspi_setTargetNegoParms  - Update the target negotiation parameters
