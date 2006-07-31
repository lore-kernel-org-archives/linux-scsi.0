From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 4/4] fusion: fibre channel: don't sync cache if remote port
 deleted
Date: Mon, 31 Jul 2006 12:20:00 -0500
Message-ID: <44CE3BC0.8020901@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040307010200080403050206"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:46017 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030272AbWGaRUB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 13:20:01 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k6VJmY4v023226
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2006 12:48:34 -0700
Received: from [128.162.233.78] (hd28.americas.sgi.com [128.162.233.78])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k6VHK02742991241
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2006 10:20:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040307010200080403050206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

mptscsih_slave_destroy issues an unconditional synchronize cache.
It is not necessary for fibre channel devices for which the rport
has been deleted.  This patch creates a new function,
mptfc_slave_destroy(), which implements the appropriate test.

Additionally, Eric's review of the original version of this patch
pointed me at some unnecessary tests of the rport dd_data field.
I've removed one and made two others bugs.

Signed-off-by: Michael Reed <mdr@sgi.com>



--------------040307010200080403050206
Content-Type: text/x-patch;
 name="fusion_sync_cache.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fusion_sync_cache.patch"

--- srfu/drivers/message/fusion/mptscsih.h	2006-07-19 11:12:34.000000000 -0500
+++ srf/drivers/message/fusion/mptscsih.h	2006-07-28 16:57:49.720602724 -0500
@@ -101,3 +101,5 @@ extern void mptscsih_timer_expired(unsig
 extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
 extern int mptscsih_raid_id_to_num(MPT_SCSI_HOST *hd, uint physdiskid);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);
+extern void mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
+extern void mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
--- srfu/drivers/message/fusion/mptscsih.c	2006-07-19 11:12:34.000000000 -0500
+++ srf/drivers/message/fusion/mptscsih.c	2006-07-28 16:57:49.704603374 -0500
@@ -140,7 +140,7 @@ static void	mptscsih_setTargetNegoParms(
 static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, int bus);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
-static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
+void		mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
 
 void 		mptscsih_remove(struct pci_dev *);
 void 		mptscsih_shutdown(struct pci_dev *);
@@ -936,7 +936,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
  *
  *	Called from slave_destroy.
  */
-static void
+void
 mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
 {
 	SCSIIORequest_t	*mf = NULL;
@@ -3436,7 +3436,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
  *	MUST be single-threaded.
  *
  */
-static void
+void
 mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
 {
 	INTERNAL_CMD		 iocmd;
@@ -3460,6 +3460,8 @@ mptscsih_synchronize_cache(MPT_SCSI_HOST
 		mptscsih_do_cmd(hd, &iocmd);
 }
 
+EXPORT_SYMBOL(mptscsih_search_running_cmds);
+EXPORT_SYMBOL(mptscsih_synchronize_cache);
 EXPORT_SYMBOL(mptscsih_remove);
 EXPORT_SYMBOL(mptscsih_shutdown);
 #ifdef CONFIG_PM
--- srfu/drivers/message/fusion/mptfc.c	2006-07-28 16:57:34.189233269 -0500
+++ srf/drivers/message/fusion/mptfc.c	2006-07-28 16:59:31.192409766 -0500
@@ -96,6 +96,7 @@ static int mptfc_qcmd(struct scsi_cmnd *
 static void mptfc_target_destroy(struct scsi_target *starget);
 static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout);
 static void __devexit mptfc_remove(struct pci_dev *pdev);
+static void mptfc_slave_destroy(struct scsi_device *sdev);
 
 static struct scsi_host_template mptfc_driver_template = {
 	.module				= THIS_MODULE,
@@ -108,7 +109,7 @@ static struct scsi_host_template mptfc_d
 	.slave_alloc			= mptfc_slave_alloc,
 	.slave_configure		= mptscsih_slave_configure,
 	.target_destroy			= mptfc_target_destroy,
-	.slave_destroy			= mptscsih_slave_destroy,
+	.slave_destroy			= mptfc_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
@@ -433,8 +434,8 @@ mptfc_target_destroy(struct scsi_target 
 	rport = starget_to_rport(starget);
 	if (rport) {
 		ri = *((struct mptfc_rport_info **)rport->dd_data);
-		if (ri)	/* better be! */
-			ri->starget = NULL;
+		BUG_ON(ri==NULL);
+		ri->starget = NULL;
 	}
 	if (starget->hostdata)
 		kfree(starget->hostdata);
@@ -463,12 +464,11 @@ mptfc_target_alloc(struct scsi_target *s
 	rport = starget_to_rport(starget);
 	if (rport) {
 		ri = *((struct mptfc_rport_info **)rport->dd_data);
-		if (ri) {	/* better be! */
-			vtarget->target_id = ri->pg0.CurrentTargetID;
-			vtarget->bus_id = ri->pg0.CurrentBus;
-			ri->starget = starget;
-			rc = 0;
-		}
+		BUG_ON(ri==NULL);
+		vtarget->target_id = ri->pg0.CurrentTargetID;
+		vtarget->bus_id = ri->pg0.CurrentBus;
+		ri->starget = starget;
+		rc = 0;
 	}
 	if (rc != 0) {
 		kfree(vtarget);
@@ -492,13 +492,18 @@ mptfc_slave_alloc(struct scsi_device *sd
 	VirtDevice		*vdev;
 	struct scsi_target	*starget;
 	struct fc_rport		*rport;
+	unsigned long		flags;
 
 
 	starget = scsi_target(sdev);
 	rport = starget_to_rport(starget);
 
-	if (!rport || fc_remote_port_chkready(rport))
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	if (!rport || fc_remote_port_chkready(rport)) {
+		spin_unlock_irqrestore(sdev->host->host_lock, flags);
 		return -ENXIO;
+	}
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
 
@@ -548,10 +553,42 @@ mptfc_slave_alloc(struct scsi_device *sd
 	return 0;
 }
 
+/*
+ *	OS entry point to allow for host driver to free allocated memory
+ *	Called if no device present or device being unloaded
+ */
+static void
+mptfc_slave_destroy(struct scsi_device *sdev)
+{
+	struct Scsi_Host	*host = sdev->host;
+	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	VirtTarget		*vtarget;
+	VirtDevice		*vdev;
+	struct scsi_target 	*starget;
+	struct fc_rport		*rport = starget_to_rport(scsi_target(sdev));
+	struct mptfc_rport_info	*ri;
+
+	starget = scsi_target(sdev);
+	vtarget = starget->hostdata;
+	vdev = sdev->hostdata;
+
+	mptscsih_search_running_cmds(hd, vdev);
+	vtarget->luns[0] &= ~(1 << vdev->lun);
+	vtarget->num_luns--;
+	if (vtarget->num_luns == 0)
+		hd->Targets[sdev->id] = NULL;
+
+	ri = *((struct mptfc_rport_info **)rport->dd_data);
+	if (ri && ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED)
+		mptscsih_synchronize_cache(hd, vdev);
+
+	kfree(vdev);
+	sdev->hostdata = NULL;
+}
+
 static int
 mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
-	struct mptfc_rport_info	*ri;
 	struct fc_rport	*rport = starget_to_rport(scsi_target(SCpnt->device));
 	int		err;
 
@@ -562,19 +599,6 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void
 		return 0;
 	}
 
-	/* dd_data is null until finished adding target */
-	ri = *((struct mptfc_rport_info **)rport->dd_data);
-	if (unlikely(!ri)) {
-		dfcprintk ((MYIOC_s_INFO_FMT
-			"mptfc_qcmd.%d: %d:%d, dd_data is null.\n",
-			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->name,
-			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->sh->host_no,
-			SCpnt->device->id,SCpnt->device->lun));
-		SCpnt->result = DID_IMM_RETRY << 16;
-		done(SCpnt);
-		return 0;
-	}
-
 	err = mptscsih_qcmd(SCpnt,done);
 #ifdef DMPT_DEBUG_FC
 	if (unlikely(err)) {


--------------040307010200080403050206--
