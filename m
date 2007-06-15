From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/2] mpt fusion: cleanup eh handlers
Date: Fri, 15 Jun 2007 17:24:14 -0600
Message-ID: <20070615232414.GA12815@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:59347 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947AbXFOX2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 19:28:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, DL-MPTFusionLinux@lsi.com

nice cosmetic cleaning of eh thread callback funtions

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-06-13 15:37:26.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2007-06-15 17:05:12.000000000 -0600
@@ -1727,20 +1727,35 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	u32		 ctx2abort;
 	int		 scpnt_idx;
 	int		 retval;
-	VirtDevice	 *vdev;
+	VirtDevice	 *vdevice;
 	ulong	 	 sn = SCpnt->serial_number;
+	MPT_ADAPTER	*ioc;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL) {
 		SCpnt->result = DID_RESET << 16;
 		SCpnt->scsi_done(SCpnt);
-		dfailprintk((KERN_INFO MYNAM ": mptscsih_abort: "
-			   "Can't locate host! (sc=%p)\n",
-			   SCpnt));
+		dfailprintk((KERN_INFO MYNAM ": mptscsih_abort: Can't locate "
+		    "host! (sc=%p)\n", SCpnt));
 		return FAILED;
 	}
 
+	ioc = hd->ioc;
+	printk(MYIOC_s_INFO_FMT "attempting task abort! (sc=%p)\n",
+	       ioc->name, SCpnt);
+	scsi_print_command(SCpnt);
+
+	vdevice = SCpnt->device->hostdata;
+	if (!vdevice || !vdevice->vtarget) {
+		dtmprintk((MYIOC_s_DEBUG_FMT "task abort: device has been "
+		    "deleted (sc=%p)\n", ioc->name, SCpnt));
+		SCpnt->result = DID_NO_CONNECT << 16;
+		SCpnt->scsi_done(SCpnt);
+		retval = 0;
+		goto out;
+	}
+
 	/* Find this command
 	 */
 	if ((scpnt_idx = SCPNT_TO_LOOKUP_IDX(SCpnt)) < 0) {
@@ -1749,21 +1764,20 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		 */
 		SCpnt->result = DID_RESET << 16;
 		dtmprintk((KERN_INFO MYNAM ": %s: mptscsih_abort: "
-			   "Command not in the active list! (sc=%p)\n",
-			   hd->ioc->name, SCpnt));
-		return SUCCESS;
+		   "Command not in the active list! (sc=%p)\n", ioc->name,
+		   SCpnt));
+		retval = 0;
+		goto out;
 	}
 
-	if (hd->resetPending)
-		return FAILED;
+	if (hd->resetPending) {
+		retval = FAILED;
+		goto out;
+	}
 
 	if (hd->timeouts < -1)
 		hd->timeouts++;
 
-	printk(KERN_WARNING MYNAM ": %s: attempting task abort! (sc=%p)\n",
-	       hd->ioc->name, SCpnt);
-	scsi_print_command(SCpnt);
-
 	/* Most important!  Set TaskMsgContext to SCpnt's MsgContext!
 	 * (the IO to be ABORT'd)
 	 *
@@ -1776,18 +1790,17 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 	hd->abortSCpnt = SCpnt;
 
-	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
-		vdev->vtarget->channel, vdev->vtarget->id, vdev->lun,
-		ctx2abort, mptscsih_get_tm_timeout(hd->ioc));
+	    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun,
+	    ctx2abort, mptscsih_get_tm_timeout(ioc));
 
 	if (SCPNT_TO_LOOKUP_IDX(SCpnt) == scpnt_idx &&
 	    SCpnt->serial_number == sn)
 		retval = FAILED;
 
-	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=%p)\n",
-		hd->ioc->name,
-		((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+ out:
+	printk(MYIOC_s_INFO_FMT "task abort: %s (sc=%p)\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
 
 	if (retval == 0)
 		return SUCCESS;
@@ -1809,32 +1822,40 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
-	VirtDevice	 *vdev;
+	VirtDevice	 *vdevice;
+	MPT_ADAPTER	*ioc;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-		dtmprintk((KERN_INFO MYNAM ": mptscsih_dev_reset: "
-			   "Can't locate host! (sc=%p)\n",
-			   SCpnt));
+		dtmprintk((KERN_INFO MYNAM ": mptscsih_dev_reset: Can't "
+		    "locate host! (sc=%p)\n", SCpnt));
 		return FAILED;
 	}
 
-	if (hd->resetPending)
-		return FAILED;
-
-	printk(KERN_WARNING MYNAM ": %s: attempting target reset! (sc=%p)\n",
-	       hd->ioc->name, SCpnt);
+	ioc = hd->ioc;
+	printk(MYIOC_s_INFO_FMT "attempting target reset! (sc=%p)\n",
+	       ioc->name, SCpnt);
 	scsi_print_command(SCpnt);
 
-	vdev = SCpnt->device->hostdata;
+	if (hd->resetPending) {
+		retval = FAILED;
+		goto out;
+	}
+
+	vdevice = SCpnt->device->hostdata;
+	if (!vdevice || !vdevice->vtarget) {
+		retval = 0;
+		goto out;
+	}
+
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-		vdev->vtarget->channel, vdev->vtarget->id,
-		0, 0, mptscsih_get_tm_timeout(hd->ioc));
+	    vdevice->vtarget->channel, vdevice->vtarget->id, 0, 0,
+	    mptscsih_get_tm_timeout(ioc));
 
-	printk (KERN_WARNING MYNAM ": %s: target reset: %s (sc=%p)\n",
-		hd->ioc->name,
-		((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+ out:
+	printk (MYIOC_s_INFO_FMT "target reset: %s (sc=%p)\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
 
 	if (retval == 0)
 		return SUCCESS;
@@ -1858,18 +1879,19 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
 	VirtDevice	 *vdev;
+	MPT_ADAPTER	*ioc;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-		dtmprintk((KERN_INFO MYNAM ": mptscsih_bus_reset: "
-			   "Can't locate host! (sc=%p)\n",
-			   SCpnt ) );
+		dtmprintk((KERN_INFO MYNAM ": mptscsih_bus_reset: Can't "
+		    "locate host! (sc=%p)\n", SCpnt ));
 		return FAILED;
 	}
 
-	printk(KERN_WARNING MYNAM ": %s: attempting bus reset! (sc=%p)\n",
-	       hd->ioc->name, SCpnt);
+	ioc = hd->ioc;
+	printk(MYIOC_s_INFO_FMT "attempting bus reset! (sc=%p)\n",
+	       ioc->name, SCpnt);
 	scsi_print_command(SCpnt);
 
 	if (hd->timeouts < -1)
@@ -1877,11 +1899,10 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-		vdev->vtarget->channel, 0, 0, 0, mptscsih_get_tm_timeout(hd->ioc));
+	    vdev->vtarget->channel, 0, 0, 0, mptscsih_get_tm_timeout(ioc));
 
-	printk (KERN_WARNING MYNAM ": %s: bus reset: %s (sc=%p)\n",
-		hd->ioc->name,
-		((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	printk(MYIOC_s_INFO_FMT "bus reset: %s (sc=%p)\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
 
 	if (retval == 0)
 		return SUCCESS;
@@ -1902,37 +1923,38 @@ int
 mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST *  hd;
-	int              status = SUCCESS;
+	int              retval;
+	MPT_ADAPTER	*ioc;
 
 	/*  If we can't locate the host to reset, then we failed. */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-		dtmprintk( ( KERN_INFO MYNAM ": mptscsih_host_reset: "
-			     "Can't locate host! (sc=%p)\n",
-			     SCpnt ) );
+		dtmprintk( ( KERN_INFO MYNAM ": mptscsih_host_reset: Can't "
+		    "locate host! (sc=%p)\n", SCpnt));
 		return FAILED;
 	}
 
-	printk(KERN_WARNING MYNAM ": %s: Attempting host reset! (sc=%p)\n",
-	       hd->ioc->name, SCpnt);
+	ioc = hd->ioc;
+	printk(MYIOC_s_INFO_FMT "attempting host reset! (sc=%p)\n",
+	    ioc->name, SCpnt);
 
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
-	if (mpt_HardResetHandler(hd->ioc, CAN_SLEEP) < 0){
-		status = FAILED;
+	if (mpt_HardResetHandler(hd->ioc, CAN_SLEEP) < 0) {
+		retval = FAILED;
 	} else {
 		/*  Make sure TM pending is cleared and TM state is set to
 		 *  NONE.
 		 */
+		retval = 0;
 		hd->tmPending = 0;
 		hd->tmState = TM_STATE_NONE;
 	}
 
-	dtmprintk( ( KERN_INFO MYNAM ": mptscsih_host_reset: "
-		     "Status = %s\n",
-		     (status == SUCCESS) ? "SUCCESS" : "FAILED" ) );
+	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
 
-	return status;
+	return retval;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
