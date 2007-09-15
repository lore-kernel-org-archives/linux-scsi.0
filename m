From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 4/8] mpt fusion: rename vdev to vdevice
Date: Fri, 14 Sep 2007 18:48:19 -0600
Message-ID: <20070915004819.GA16833@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48373 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758992AbXIOA4f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 20:56:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

common naming of vdevice through out driver

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2007-09-14 12:35:20.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2007-09-14 16:42:19.000000000 -0600
@@ -1175,7 +1175,7 @@ mptctl_getiocinfo (unsigned long arg, un
 	int			cim_rev;
 	u8			revision;
 	struct scsi_device 	*sdev;
-	VirtDevice		*vdev;
+	VirtDevice		*vdevice;
 
 	/* Add of PCI INFO results in unaligned access for
 	 * IA64 and Sparc. Reset long to int. Return no PCI
@@ -1270,8 +1270,8 @@ mptctl_getiocinfo (unsigned long arg, un
 	karg->numDevices = 0;
 	if (ioc->sh) {
 		shost_for_each_device(sdev, ioc->sh) {
-			vdev = sdev->hostdata;
-			if (vdev->vtarget->tflags &
+			vdevice = sdev->hostdata;
+			if (vdevice->vtarget->tflags &
 			    MPT_TARGET_FLAGS_RAID_COMPONENT)
 				continue;
 			karg->numDevices++;
@@ -1322,7 +1322,7 @@ mptctl_gettargetinfo (unsigned long arg)
 	struct mpt_ioctl_targetinfo __user *uarg = (void __user *) arg;
 	struct mpt_ioctl_targetinfo karg;
 	MPT_ADAPTER		*ioc;
-	VirtDevice		*vdev;
+	VirtDevice		*vdevice;
 	char			*pmem;
 	int			*pdata;
 	int			iocnum;
@@ -1391,13 +1391,13 @@ mptctl_gettargetinfo (unsigned long arg)
 		shost_for_each_device(sdev, ioc->sh) {
 			if (!maxWordsLeft)
 				continue;
-			vdev = sdev->hostdata;
-			if (vdev->vtarget->tflags &
+			vdevice = sdev->hostdata;
+			if (vdevice->vtarget->tflags &
 			    MPT_TARGET_FLAGS_RAID_COMPONENT)
 				continue;
-			lun = (vdev->vtarget->raidVolume) ? 0x80 : vdev->lun;
-			*pdata = (((u8)lun << 16) + (vdev->vtarget->channel << 8) +
-			    (vdev->vtarget->id ));
+			lun = (vdevice->vtarget->raidVolume) ? 0x80 : vdevice->lun;
+			*pdata = (((u8)lun << 16) + (vdevice->vtarget->channel << 8) +
+			    (vdevice->vtarget->id ));
 			pdata++;
 			numDevices++;
 			--maxWordsLeft;
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-09-14 14:08:51.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2007-09-14 16:39:53.000000000 -0600
@@ -213,7 +213,7 @@ mptfc_block_error_handler(struct scsi_cm
 	if (ready == DID_NO_CONNECT || !SCpnt->device->hostdata) {
 		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
 			"%s.%d: %d:%d, failing recovery, "
-			"port state %d, vdev %p.\n", caller,
+			"port state %d, vdevice %p.\n", caller,
 			((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
 			((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
 			SCpnt->device->id, SCpnt->device->lun, ready,
@@ -470,7 +470,7 @@ mptfc_register_dev(MPT_ADAPTER *ioc, int
 			/*
 			 * if already mapped, remap here.  If not mapped,
 			 * target_alloc will allocate vtarget and map,
-			 * slave_alloc will fill in vdev from vtarget.
+			 * slave_alloc will fill in vdevice from vtarget.
 			 */
 			if (ri->starget) {
 				vtarget = ri->starget->hostdata;
@@ -602,7 +602,7 @@ mptfc_slave_alloc(struct scsi_device *sd
 {
 	MPT_SCSI_HOST		*hd;
 	VirtTarget		*vtarget;
-	VirtDevice		*vdev;
+	VirtDevice		*vdevice;
 	struct scsi_target	*starget;
 	struct fc_rport		*rport;
 
@@ -615,15 +615,15 @@ mptfc_slave_alloc(struct scsi_device *sd
 
 	hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
 
-	vdev = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
-	if (!vdev) {
+	vdevice = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
+	if (!vdevice) {
 		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
 				hd->ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
 
 
-	sdev->hostdata = vdev;
+	sdev->hostdata = vdevice;
 	vtarget = starget->hostdata;
 
 	if (vtarget->num_luns == 0) {
@@ -631,8 +631,8 @@ mptfc_slave_alloc(struct scsi_device *sd
 		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES;
 	}
 
-	vdev->vtarget = vtarget;
-	vdev->lun = sdev->lun;
+	vdevice->vtarget = vtarget;
+	vdevice->lun = sdev->lun;
 
 	vtarget->num_luns++;
 
@@ -648,9 +648,9 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void
 	struct mptfc_rport_info	*ri;
 	struct fc_rport	*rport = starget_to_rport(scsi_target(SCpnt->device));
 	int		err;
-	VirtDevice	*vdev = SCpnt->device->hostdata;
+	VirtDevice	*vdevice = SCpnt->device->hostdata;
 
-	if (!vdev || !vdev->vtarget) {
+	if (!vdevice || !vdevice->vtarget) {
 		SCpnt->result = DID_NO_CONNECT << 16;
 		done(SCpnt);
 		return 0;
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-09-14 15:05:35.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2007-09-14 16:41:07.000000000 -0600
@@ -506,15 +506,15 @@ static VirtTarget *
 mptsas_find_vtarget(MPT_ADAPTER *ioc, u8 channel, u8 id)
 {
 	struct scsi_device 		*sdev;
-	VirtDevice			*vdev;
+	VirtDevice			*vdevice;
 	VirtTarget 			*vtarget = NULL;
 
 	shost_for_each_device(sdev, ioc->sh) {
-		if ((vdev = sdev->hostdata) == NULL)
+		if ((vdevice = sdev->hostdata) == NULL)
 			continue;
-		if (vdev->vtarget->id == id &&
-		    vdev->vtarget->channel == channel)
-			vtarget = vdev->vtarget;
+		if (vdevice->vtarget->id == id &&
+		    vdevice->vtarget->channel == channel)
+			vtarget = vdevice->vtarget;
 	}
 	return vtarget;
 }
@@ -943,18 +943,18 @@ mptsas_slave_alloc(struct scsi_device *s
 	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
 	struct sas_rphy		*rphy;
 	struct mptsas_portinfo	*p;
-	VirtDevice		*vdev;
+	VirtDevice		*vdevice;
 	struct scsi_target 	*starget;
 	int 			i;
 
-	vdev = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
-	if (!vdev) {
+	vdevice = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
+	if (!vdevice) {
 		printk(MYIOC_s_ERR_FMT "slave_alloc kzalloc(%zd) FAILED!\n",
 				hd->ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
 	starget = scsi_target(sdev);
-	vdev->vtarget = starget->hostdata;
+	vdevice->vtarget = starget->hostdata;
 
 	if (sdev->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
@@ -966,7 +966,7 @@ mptsas_slave_alloc(struct scsi_device *s
 			if (p->phy_info[i].attached.sas_address !=
 					rphy->identify.sas_address)
 				continue;
-			vdev->lun = sdev->lun;
+			vdevice->lun = sdev->lun;
 			/*
 			 * Exposing hidden raid components
 			 */
@@ -980,21 +980,21 @@ mptsas_slave_alloc(struct scsi_device *s
 	}
 	mutex_unlock(&hd->ioc->sas_topology_mutex);
 
-	kfree(vdev);
+	kfree(vdevice);
 	return -ENXIO;
 
  out:
-	vdev->vtarget->num_luns++;
-	sdev->hostdata = vdev;
+	vdevice->vtarget->num_luns++;
+	sdev->hostdata = vdevice;
 	return 0;
 }
 
 static int
 mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
-	VirtDevice	*vdev = SCpnt->device->hostdata;
+	VirtDevice	*vdevice = SCpnt->device->hostdata;
 
-	if (!vdev || !vdev->vtarget || vdev->vtarget->deleted) {
+	if (!vdevice || !vdevice->vtarget || vdevice->vtarget->deleted) {
 		SCpnt->result = DID_NO_CONNECT << 16;
 		done(SCpnt);
 		return 0;
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-09-14 14:58:22.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2007-09-14 16:43:32.000000000 -0600
@@ -644,7 +644,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 	SCSIIORequest_t	*pScsiReq;
 	SCSIIOReply_t	*pScsiReply;
 	u16		 req_idx, req_idx_MR;
-	VirtDevice	 *vdev;
+	VirtDevice	 *vdevice;
 	VirtTarget	 *vtarget;
 
 	hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
@@ -770,10 +770,10 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			if (hd->sel_timeout[pScsiReq->TargetID] < 0xFFFF)
 				hd->sel_timeout[pScsiReq->TargetID]++;
 
-			vdev = sc->device->hostdata;
-			if (!vdev)
+			vdevice = sc->device->hostdata;
+			if (!vdevice)
 				break;
-			vtarget = vdev->vtarget;
+			vtarget = vdevice->vtarget;
 			if (vtarget->tflags & MPT_TARGET_FLAGS_LED_ON) {
 				mptscsih_issue_sep_command(ioc, vtarget,
 				    MPI_SEP_REQ_SLOTSTATUS_UNCONFIGURED);
@@ -1359,7 +1359,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	MPT_SCSI_HOST		*hd;
 	MPT_FRAME_HDR		*mf;
 	SCSIIORequest_t		*pScsiReq;
-	VirtDevice		*vdev = SCpnt->device->hostdata;
+	VirtDevice		*vdevice = SCpnt->device->hostdata;
 	int	 lun;
 	u32	 datalen;
 	u32	 scsictl;
@@ -1416,8 +1416,8 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	/* Default to untagged. Once a target structure has been allocated,
 	 * use the Inquiry data to determine if device supports tagged.
 	 */
-	if (vdev
-	    && (vdev->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
+	if (vdevice
+	    && (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
 	    && (SCpnt->device->tagged_supported)) {
 		scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
 	} else {
@@ -1426,10 +1426,10 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 
 	/* Use the above information to set up the message frame
 	 */
-	pScsiReq->TargetID = (u8) vdev->vtarget->id;
-	pScsiReq->Bus = vdev->vtarget->channel;
+	pScsiReq->TargetID = (u8) vdevice->vtarget->id;
+	pScsiReq->Bus = vdevice->vtarget->channel;
 	pScsiReq->ChainOffset = 0;
-	if (vdev->vtarget->tflags &  MPT_TARGET_FLAGS_RAID_COMPONENT)
+	if (vdevice->vtarget->tflags &  MPT_TARGET_FLAGS_RAID_COMPONENT)
 		pScsiReq->Function = MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH;
 	else
 		pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
@@ -1968,7 +1968,7 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
-	VirtDevice	 *vdev;
+	VirtDevice	 *vdevice;
 	MPT_ADAPTER	*ioc;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
@@ -1987,9 +1987,9 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 	if (hd->timeouts < -1)
 		hd->timeouts++;
 
-	vdev = SCpnt->device->hostdata;
+	vdevice = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-	    vdev->vtarget->channel, 0, 0, 0, mptscsih_get_tm_timeout(ioc));
+	    vdevice->vtarget->channel, 0, 0, 0, mptscsih_get_tm_timeout(ioc));
 
 	printk(MYIOC_s_INFO_FMT "bus reset: %s (sc=%p)\n",
 	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
@@ -2503,14 +2503,14 @@ slave_configure_exit:
 static void
 mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply)
 {
-	VirtDevice	*vdev;
+	VirtDevice	*vdevice;
 	SCSIIORequest_t	*pReq;
 	u32		 sense_count = le32_to_cpu(pScsiReply->SenseCount);
 
 	/* Get target structure
 	 */
 	pReq = (SCSIIORequest_t *) mf;
-	vdev = sc->device->hostdata;
+	vdevice = sc->device->hostdata;
 
 	if (sense_count) {
 		u8 *sense_data;
@@ -2524,7 +2524,7 @@ mptscsih_copy_sense_data(struct scsi_cmn
 		/* Log SMART data (asc = 0x5D, non-IM case only) if required.
 		 */
 		if ((hd->ioc->events) && (hd->ioc->eventTypes & (1 << MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE))) {
-			if ((sense_data[12] == 0x5D) && (vdev->vtarget->raidVolume == 0)) {
+			if ((sense_data[12] == 0x5D) && (vdevice->vtarget->raidVolume == 0)) {
 				int idx;
 				MPT_ADAPTER *ioc = hd->ioc;
 
@@ -2542,8 +2542,8 @@ mptscsih_copy_sense_data(struct scsi_cmn
 				if (hd->ioc->pcidev->vendor ==
 				    PCI_VENDOR_ID_IBM) {
 					mptscsih_issue_sep_command(hd->ioc,
-					    vdev->vtarget, MPI_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT);
-					vdev->vtarget->tflags |=
+					    vdevice->vtarget, MPI_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT);
+					vdevice->vtarget->tflags |=
 					    MPT_TARGET_FLAGS_LED_ON;
 				}
 			}
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-09-14 17:24:59.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-09-14 17:25:14.000000000 -0600
@@ -698,26 +698,26 @@ static int mptspi_slave_alloc(struct scs
 {
 	MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
 	VirtTarget		*vtarget;
-	VirtDevice		*vdev;
+	VirtDevice		*vdevice;
 	struct scsi_target 	*starget;
 
 	if (sdev->channel == 1 &&
 		mptscsih_is_phys_disk(hd->ioc, 0, sdev->id) == 0)
 			return -ENXIO;
 
-	vdev = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
-	if (!vdev) {
+	vdevice = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
+	if (!vdevice) {
 		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
 				hd->ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
 
-	vdev->lun = sdev->lun;
-	sdev->hostdata = vdev;
+	vdevice->lun = sdev->lun;
+	sdev->hostdata = vdevice;
 
 	starget = scsi_target(sdev);
 	vtarget = starget->hostdata;
-	vdev->vtarget = vtarget;
+	vdevice->vtarget = vtarget;
 	vtarget->num_luns++;
 
 	if (sdev->channel == 1)
@@ -758,9 +758,9 @@ static int
 mptspi_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	struct _MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
-	VirtDevice	*vdev = SCpnt->device->hostdata;
+	VirtDevice	*vdevice = SCpnt->device->hostdata;
 
-	if (!vdev || !vdev->vtarget) {
+	if (!vdevice || !vdevice->vtarget) {
 		SCpnt->result = DID_NO_CONNECT << 16;
 		done(SCpnt);
 		return 0;
