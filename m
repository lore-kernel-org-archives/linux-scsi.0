From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] fusion: Remove queuecommand wrapper
Date: Mon, 4 Jul 2011 15:28:13 -0400
Message-ID: <20110704192813.GA4061@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:9524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab1GDT2V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2011 15:28:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: DL-MPTFusionLinux@lsi.com

Now that fusion no longer uses the serial_number, we can remove the
wrapper that acquires the host_lock around queuecommand.  This is the
most contended lock for one benchmark, and on a 8-socket machine this
patch leads to a 70% application-level improvement.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index d784c36..77248a0 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -649,7 +649,7 @@ mptfc_slave_alloc(struct scsi_device *sdev)
 }
 
 static int
-mptfc_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 {
 	struct mptfc_rport_info	*ri;
 	struct fc_rport	*rport = starget_to_rport(scsi_target(SCpnt->device));
@@ -658,14 +658,14 @@ mptfc_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 
 	if (!vdevice || !vdevice->vtarget) {
 		SCpnt->result = DID_NO_CONNECT << 16;
-		done(SCpnt);
+		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
 
 	err = fc_remote_port_chkready(rport);
 	if (unlikely(err)) {
 		SCpnt->result = err;
-		done(SCpnt);
+		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
 
@@ -673,15 +673,13 @@ mptfc_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	ri = *((struct mptfc_rport_info **)rport->dd_data);
 	if (unlikely(!ri)) {
 		SCpnt->result = DID_IMM_RETRY << 16;
-		done(SCpnt);
+		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
 
-	return mptscsih_qcmd(SCpnt,done);
+	return mptscsih_qcmd(shost, SCpnt);
 }
 
-static DEF_SCSI_QCMD(mptfc_qcmd)
-
 /*
  *	mptfc_display_port_link_speed - displaying link speed
  *	@ioc: Pointer to MPT_ADAPTER structure
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 7596aec..24b051e 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1889,7 +1889,7 @@ mptsas_slave_alloc(struct scsi_device *sdev)
 }
 
 static int
-mptsas_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+mptsas_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
 	MPT_ADAPTER	*ioc;
@@ -1897,7 +1897,7 @@ mptsas_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 
 	if (!vdevice || !vdevice->vtarget || vdevice->vtarget->deleted) {
 		SCpnt->result = DID_NO_CONNECT << 16;
-		done(SCpnt);
+		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
 
@@ -1910,11 +1910,9 @@ mptsas_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	if (ioc->debug_level & MPT_DEBUG_SCSI)
 		scsi_print_command(SCpnt);
 
-	return mptscsih_qcmd(SCpnt,done);
+	return mptscsih_qcmd(shost, SCpnt);
 }
 
-static DEF_SCSI_QCMD(mptsas_qcmd)
-
 /**
  *	mptsas_mptsas_eh_timed_out - resets the scsi_cmnd timeout
  *		if the device under question is currently in the
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index a1d4ee6..edf49f7 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1384,8 +1384,8 @@ mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t off
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_qcmd - Primary Fusion MPT SCSI initiator IO start routine.
+ *	@shost: Pointer to Scsi_Host
  *	@SCpnt: Pointer to scsi_cmnd structure
- *	@done: Pointer SCSI mid-layer IO completion function
  *
  *	(linux scsi_host_template.queuecommand routine)
  *	This is the primary SCSI IO start routine.  Create a MPI SCSIIORequest
@@ -1394,7 +1394,7 @@ mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t off
  *	Returns 0. (rtn value discarded by linux scsi mid-layer)
  */
 int
-mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+mptscsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST		*hd;
 	MPT_FRAME_HDR		*mf;
@@ -1408,12 +1408,11 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	int	 ii;
 	MPT_ADAPTER *ioc;
 
-	hd = shost_priv(SCpnt->device->host);
+	hd = shost_priv(shost);
 	ioc = hd->ioc;
-	SCpnt->scsi_done = done;
 
-	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "qcmd: SCpnt=%p, done()=%p\n",
-		ioc->name, SCpnt, done));
+	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "qcmd: SCpnt=%p\n",
+		ioc->name, SCpnt));
 
 	if (ioc->taskmgmt_quiesce_io)
 		return SCSI_MLQUEUE_HOST_BUSY;
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 45a5ff3..4b8f14c 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -113,7 +113,7 @@ extern int mptscsih_resume(struct pci_dev *pdev);
 #endif
 extern int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int func);
 extern const char * mptscsih_info(struct Scsi_Host *SChost);
-extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *));
+extern int mptscsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt);
 extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
 	u8 id, int lun, int ctx2abort, ulong timeout);
 extern void mptscsih_slave_destroy(struct scsi_device *device);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 8f61ba6..180850e 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -780,7 +780,7 @@ static int mptspi_slave_configure(struct scsi_device *sdev)
 }
 
 static int
-mptspi_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+mptspi_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 {
 	struct _MPT_SCSI_HOST *hd = shost_priv(SCpnt->device->host);
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
@@ -788,25 +788,23 @@ mptspi_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 
 	if (!vdevice || !vdevice->vtarget) {
 		SCpnt->result = DID_NO_CONNECT << 16;
-		done(SCpnt);
+		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
 
 	if (SCpnt->device->channel == 1 &&
 		mptscsih_is_phys_disk(ioc, 0, SCpnt->device->id) == 0) {
 		SCpnt->result = DID_NO_CONNECT << 16;
-		done(SCpnt);
+		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
 
 	if (spi_dv_pending(scsi_target(SCpnt->device)))
 		ddvprintk(ioc, scsi_print_command(SCpnt));
 
-	return mptscsih_qcmd(SCpnt,done);
+	return mptscsih_qcmd(shost, SCpnt);
 }
 
-static DEF_SCSI_QCMD(mptspi_qcmd)
-
 static void mptspi_slave_destroy(struct scsi_device *sdev)
 {
 	struct scsi_target *starget = scsi_target(sdev);
