From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 6/7]  mptfusion - mapping fixs required support for transport layers.
Date: Wed, 16 Nov 2005 18:54:25 -0700
Message-ID: <200511161854.25500.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_RL+eD7wd8l1B0lK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7298 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161096AbVKQCAB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 21:00:01 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id jAH1tFSW011553
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:55:15 -0800 (PST)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id jAH1xuof001989
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:59:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_RL+eD7wd8l1B0lK
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This utilizes the hostdata area that is hung off of scsi_target and scsi_device for
saving unique firmware mapping. This will be required for supporting new
Fibre and SPI transport support.

This also fixs problems in error handling error code for SAS controllers, in which 
the incorrect mapping was passed to the firmware.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>




--Boundary-00=_RL+eD7wd8l1B0lK
Content-Type: text/x-diff;
  charset="us-ascii";
  name="6-mapping-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="6-mapping-fix.patch"

diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2005-11-16 17:33:57.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2005-11-16 18:05:52.000000000 -0700
@@ -321,7 +321,7 @@
  *	Dynamic Multi-Pathing specific stuff...
  */
 
-/* VirtDevice negoFlags field */
+/* VirtTarget negoFlags field */
 #define MPT_TARGET_NO_NEGO_WIDE		0x01
 #define MPT_TARGET_NO_NEGO_SYNC		0x02
 #define MPT_TARGET_NO_NEGO_QAS		0x04
@@ -330,8 +330,7 @@
 /*
  *	VirtDevice - FC LUN device or SCSI target device
  */
-typedef struct _VirtDevice {
-	struct scsi_device	*device;
+typedef struct _VirtTarget {
 	u8			 tflags;
 	u8			 ioc_id;
 	u8			 target_id;
@@ -342,21 +341,18 @@
 	u8			 negoFlags;	/* bit field, see above */
 	u8			 raidVolume;	/* set, if RAID Volume */
 	u8			 type;		/* byte 0 of Inquiry data */
-	u8			 cflags;	/* controller flags */
-	u8			 rsvd1raid;
-	u16			 fc_phys_lun;
-	u16			 fc_xlat_lun;
 	u32			 num_luns;
 	u32			 luns[8];		/* Max LUNs is 256 */
-	u8			 pad[4];
 	u8			 inq_data[8];
-		/* IEEE Registered Extended Identifier
-		   obtained via INQUIRY VPD page 0x83 */
-		/* NOTE: Do not separate uniq_prepad and uniq_data
-		   as they are treateed as a single entity in the code */
-	u8			 uniq_prepad[8];
-	u8			 uniq_data[20];
-	u8			 pad2[4];
+} VirtTarget;
+
+typedef struct _VirtDevice {
+	VirtTarget	 	*vtarget;
+	u8			 ioc_id;
+	u8			 bus_id;
+	u8			 target_id;
+	u8			 configured_lun;
+	u32			 lun;
 } VirtDevice;
 
 /*
@@ -912,7 +908,7 @@
 	int			  port;
 	u32			  pad0;
 	struct scsi_cmnd	**ScsiLookup;
-	VirtDevice		**Targets;
+	VirtTarget		**Targets;
 	MPT_LOCAL_REPLY		 *pLocal;		/* used for internal commands */
 	struct timer_list	  timer;
 		/* Pool of memory for holding SCpnts before doing
diff -uarN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2005-11-16 12:54:28.000000000 -0700
+++ a/drivers/message/fusion/mptctl.c	2005-11-16 18:00:45.000000000 -0700
@@ -1245,7 +1245,7 @@
 	MPT_ADAPTER		*ioc;
 	struct Scsi_Host	*sh;
 	MPT_SCSI_HOST		*hd;
-	VirtDevice		*vdev;
+	VirtTarget		*vdev;
 	char			*pmem;
 	int			*pdata;
 	IOCPage2_t		*pIoc2;
@@ -1822,7 +1822,7 @@
 	case MPI_FUNCTION_SCSI_IO_REQUEST:
 		if (ioc->sh) {
 			SCSIIORequest_t *pScsiReq = (SCSIIORequest_t *) mf;
-			VirtDevice	*pTarget = NULL;
+			VirtTarget	*pTarget = NULL;
 			MPT_SCSI_HOST	*hd = NULL;
 			int qtag = MPI_SCSIIO_CONTROL_UNTAGGED;
 			int scsidir = 0;
diff -uarN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2005-11-16 17:29:13.000000000 -0700
+++ a/drivers/message/fusion/mptfc.c	2005-11-16 17:57:46.000000000 -0700
@@ -90,8 +90,10 @@
 	.name				= "MPT FC Host",
 	.info				= mptscsih_info,
 	.queuecommand			= mptscsih_qcmd,
+	.target_alloc			= mptscsih_target_alloc,
 	.slave_alloc			= mptscsih_slave_alloc,
 	.slave_configure		= mptscsih_slave_configure,
+	.target_destroy			= mptscsih_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
@@ -292,10 +294,10 @@
 	}
 
 	memset(mem, 0, sz);
-	hd->Targets = (VirtDevice **) mem;
+	hd->Targets = (VirtTarget **) mem;
 
 	dprintk((KERN_INFO
-	  "  Targets @ %p, sz=%d\n", hd->Targets, sz));
+	  "  vdev @ %p, sz=%d\n", hd->Targets, sz));
 
 	/* Clear the TM flags
 	 */
diff -uarN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2005-11-16 17:27:57.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2005-11-16 17:54:48.000000000 -0700
@@ -228,31 +228,35 @@
  * implement ->target_alloc.
  */
 static int
-mptsas_slave_alloc(struct scsi_device *device)
+mptsas_slave_alloc(struct scsi_device *sdev)
 {
-	struct Scsi_Host	*host = device->host;
+	struct Scsi_Host	*host = sdev->host;
 	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
 	struct sas_rphy		*rphy;
 	struct mptsas_portinfo	*p;
+	VirtTarget		*vtarget;
 	VirtDevice		*vdev;
-	uint			target = device->id;
+	struct scsi_target 	*starget;
 	int i;
 
-	if ((vdev = hd->Targets[target]) != NULL)
-		goto out;
-
 	vdev = kmalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdev) {
 		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
 				hd->ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
-
 	memset(vdev, 0, sizeof(VirtDevice));
-	vdev->tflags = MPT_TARGET_FLAGS_Q_YES|MPT_TARGET_FLAGS_VALID_INQUIRY;
 	vdev->ioc_id = hd->ioc->id;
+	sdev->hostdata = vdev;
+	starget = scsi_target(sdev);
+	vtarget = starget->hostdata;
+	vdev->vtarget = vtarget;
+	if (vtarget->num_luns == 0) {
+		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES|MPT_TARGET_FLAGS_VALID_INQUIRY;
+		hd->Targets[sdev->id] = vtarget;
+	}
 
-	rphy = dev_to_rphy(device->sdev_target->dev.parent);
+	rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
 	list_for_each_entry(p, &hd->ioc->sas_topology, list) {
 		for (i = 0; i < p->num_phys; i++) {
 			if (p->phy_info[i].attached.sas_address ==
@@ -260,7 +264,7 @@
 				vdev->target_id =
 					p->phy_info[i].attached.target;
 				vdev->bus_id = p->phy_info[i].attached.bus;
-				hd->Targets[device->id] = vdev;
+				vdev->lun = sdev->lun;
 				goto out;
 			}
 		}
@@ -271,8 +275,10 @@
 	return -ENODEV;
 
  out:
-	vdev->num_luns++;
-	device->hostdata = vdev;
+	vtarget->ioc_id = vdev->ioc_id;
+	vtarget->target_id = vdev->target_id;
+	vtarget->bus_id = vdev->bus_id;
+	vtarget->num_luns++;
 	return 0;
 }
 
@@ -283,8 +289,10 @@
 	.name				= "MPT SPI Host",
 	.info				= mptscsih_info,
 	.queuecommand			= mptscsih_qcmd,
+	.target_alloc			= mptscsih_target_alloc,
 	.slave_alloc			= mptsas_slave_alloc,
 	.slave_configure		= mptscsih_slave_configure,
+	.target_destroy			= mptscsih_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
@@ -987,7 +995,6 @@
 		goto out_free_port_info;
 
 	list_add_tail(&port_info->list, &ioc->sas_topology);
-
 	for (i = 0; i < port_info->num_phys; i++) {
 		mptsas_sas_phy_pg0(ioc, &port_info->phy_info[i],
 			(MPI_SAS_PHY_PGAD_FORM_PHY_NUMBER <<
@@ -1263,10 +1270,10 @@
 	}
 
 	memset(mem, 0, sz);
-	hd->Targets = (VirtDevice **) mem;
+	hd->Targets = (VirtTarget **) mem;
 
 	dprintk((KERN_INFO
-	  "  Targets @ %p, sz=%d\n", hd->Targets, sz));
+	  "  vtarget @ %p, sz=%d\n", hd->Targets, sz));
 
 	/* Clear the TM flags
 	 */
diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2005-11-16 18:10:22.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2005-11-16 18:13:35.000000000 -0700
@@ -150,15 +150,16 @@
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
-static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id, u8 lun, char *data, int dlen);
-static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56);
+static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, u8 lun, char *data, int dlen);
+static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *vtarget, char byte56);
 static void	mptscsih_setDevicePage1Flags (u8 width, u8 factor, u8 offset, int *requestedPtr, int *configurationPtr, u8 flags);
-static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int target_id);
+static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, struct scsi_cmnd *sc);
 static int	mptscsih_writeSDP1(MPT_SCSI_HOST *hd, int portnum, int target, int flags);
 static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, int bus);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
-static int	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int portnum);
+static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
+static void	mptscsih_negotiate_to_asyn_narrow(MPT_SCSI_HOST *hd, VirtTarget *vtarget);
 static int	mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);
 
 static struct work_struct   mptscsih_persistTask;
@@ -171,7 +172,7 @@
 static void	mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void *pPage);
 static void	mptscsih_fillbuf(char *buffer, int size, int index, int width);
 static void	mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id);
-static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq);
+static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, struct scsi_cmnd *sc);
 #endif
 
 void 		mptscsih_remove(struct pci_dev *);
@@ -627,7 +628,7 @@
 		dreplyprintk((KERN_NOTICE "Reply ha=%d id=%d lun=%d:\n"
 			"IOCStatus=%04xh SCSIState=%02xh SCSIStatus=%02xh\n"
 			"resid=%d bufflen=%d xfer_cnt=%d\n",
-			ioc->id, pScsiReq->TargetID, pScsiReq->LUN[1],
+			ioc->id, sc->device->id, sc->device->lun,
 			status, scsi_state, scsi_status, sc->resid,
 			sc->request_bufflen, xfer_cnt));
 
@@ -641,7 +642,7 @@
 		    pScsiReply->ResponseInfo) {
 			printk(KERN_NOTICE "ha=%d id=%d lun=%d: "
 			"FCP_ResponseInfo=%08xh\n",
-			ioc->id, pScsiReq->TargetID, pScsiReq->LUN[1],
+			ioc->id, sc->device->id, sc->device->lun,
 			le32_to_cpu(pScsiReply->ResponseInfo));
 		}
 
@@ -678,7 +679,7 @@
 
 			/* GEM Workaround. */
 			if (ioc->bus_type == SPI)
-				mptscsih_no_negotiate(hd, sc->device->id);
+				mptscsih_no_negotiate(hd, sc);
 			break;
 
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
@@ -892,16 +893,15 @@
  *		when a lun is disable by mid-layer.
  *		Do NOT access the referenced scsi_cmnd structure or
  *		members. Will cause either a paging or NULL ptr error.
- *	@hd: Pointer to a SCSI HOST structure
- *	@target: target id
- *	@lun: lun
+ *      @hd: Pointer to a SCSI HOST structure
+ *	@vdevice: per device private data
  *
  *	Returns: None.
  *
  *	Called from slave_destroy.
  */
 static void
-mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, uint target, uint lun)
+mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
 {
 	SCSIIORequest_t	*mf = NULL;
 	int		 ii;
@@ -909,7 +909,7 @@
 	struct scsi_cmnd *sc;
 
 	dsprintk((KERN_INFO MYNAM ": search_running target %d lun %d max %d\n",
-			target, lun, max));
+			vdevice->target_id, vdevice->lun, max));
 
 	for (ii=0; ii < max; ii++) {
 		if ((sc = hd->ScsiLookup[ii]) != NULL) {
@@ -919,7 +919,7 @@
 			dsprintk(( "search_running: found (sc=%p, mf = %p) target %d, lun %d \n",
 					hd->ScsiLookup[ii], mf, mf->TargetID, mf->LUN[1]));
 
-			if ((mf->TargetID != ((u8)target)) || (mf->LUN[1] != ((u8) lun)))
+			if ((mf->TargetID != ((u8)vdevice->target_id)) || (mf->LUN[1] != ((u8) vdevice->lun)))
 				continue;
 
 			/* Cleanup
@@ -996,7 +996,7 @@
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 	int 		 	count;
 	unsigned long	 	flags;
-#endif
+#endif	
 	int sz1;
 
 	if(!host) {
@@ -1077,11 +1077,6 @@
 
 	hd = (MPT_SCSI_HOST *)host->hostdata;
 
-	/* Flush the cache of this adapter
-	 */
-	if(hd != NULL)
-		mptscsih_synchronize_cache(hd, 0);
-
 }
 
 #ifdef CONFIG_PM
@@ -1288,7 +1283,7 @@
 	MPT_SCSI_HOST		*hd;
 	MPT_FRAME_HDR		*mf;
 	SCSIIORequest_t		*pScsiReq;
-	VirtDevice		*pTarget = SCpnt->device->hostdata;
+	VirtDevice		*vdev = SCpnt->device->hostdata;
 	int	 lun;
 	u32	 datalen;
 	u32	 scsictl;
@@ -1343,8 +1338,8 @@
 	/* Default to untagged. Once a target structure has been allocated,
 	 * use the Inquiry data to determine if device supports tagged.
 	 */
-	if (pTarget
-	    && (pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)
+	if (vdev
+	    && (vdev->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
 	    && (SCpnt->device->tagged_supported)) {
 		scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
 	} else {
@@ -1353,8 +1348,8 @@
 
 	/* Use the above information to set up the message frame
 	 */
-	pScsiReq->TargetID = (u8) pTarget->target_id;
-	pScsiReq->Bus = pTarget->bus_id;
+	pScsiReq->TargetID = (u8) vdev->target_id;
+	pScsiReq->Bus = vdev->bus_id;
 	pScsiReq->ChainOffset = 0;
 	pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
 	pScsiReq->CDBLength = SCpnt->cmd_len;
@@ -1406,7 +1401,7 @@
 
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 	if (hd->ioc->bus_type == SPI) {
-		int dvStatus = hd->ioc->spi_data.dvStatus[pTarget->target_id];
+		int dvStatus = hd->ioc->spi_data.dvStatus[vdev->target_id];
 		int issueCmd = 1;
 
 		if (dvStatus || hd->ioc->spi_data.forceDv) {
@@ -1439,7 +1434,7 @@
 			/* Set the DV flags.
 			 */
 			if (dvStatus & MPT_SCSICFG_DV_NOT_DONE)
-				mptscsih_set_dvflags(hd, pScsiReq);
+				mptscsih_set_dvflags(hd, SCpnt);
 
 			if (!issueCmd)
 				goto fail;
@@ -1743,6 +1738,7 @@
 	u32		 ctx2abort;
 	int		 scpnt_idx;
 	int		 retval;
+	VirtDevice	 *vdev;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1792,8 +1788,9 @@
 
 	hd->abortSCpnt = SCpnt;
 
+	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
-		SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,
+		vdev->bus_id, vdev->target_id, vdev->lun,
 		ctx2abort, 2 /* 2 second timeout */);
 
 	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=%p)\n",
@@ -1824,6 +1821,7 @@
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
+	VirtDevice	 *vdev;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1841,8 +1839,9 @@
 	       hd->ioc->name, SCpnt);
 	scsi_print_command(SCpnt);
 
+	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-		SCpnt->device->channel, SCpnt->device->id,
+		vdev->bus_id, vdev->target_id,
 		0, 0, 5 /* 5 second timeout */);
 
 	printk (KERN_WARNING MYNAM ": %s: target reset: %s (sc=%p)\n",
@@ -1873,6 +1872,7 @@
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
+	VirtDevice	 *vdev;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1890,8 +1890,9 @@
 	if (hd->timeouts < -1)
 		hd->timeouts++;
 
+	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */);
+		vdev->bus_id, 0, 0, 0, 5 /* 5 second timeout */);
 
 	printk (KERN_WARNING MYNAM ": %s: bus reset: %s (sc=%p)\n",
 		hd->ioc->name,
@@ -2153,23 +2154,36 @@
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	OS entry point to allow host driver to alloc memory
+ *	for each scsi target. Called once per device the bus scan.
+ *	Return non-zero if allocation fails.
+ */
+int
+mptscsih_target_alloc(struct scsi_target *starget)
+{
+	VirtTarget		*vtarget;
+
+	vtarget = kmalloc(sizeof(VirtTarget), GFP_KERNEL);
+	if (!vtarget)
+		return -ENOMEM;
+	memset(vtarget, 0, sizeof(VirtTarget));
+	starget->hostdata = vtarget;
+	return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+ *	OS entry point to allow host driver to alloc memory
  *	for each scsi device. Called once per device the bus scan.
  *	Return non-zero if allocation fails.
- *	Init memory once per id (not LUN).
  */
 int
-mptscsih_slave_alloc(struct scsi_device *device)
+mptscsih_slave_alloc(struct scsi_device *sdev)
 {
-	struct Scsi_Host	*host = device->host;
+	struct Scsi_Host	*host = sdev->host;
 	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	VirtTarget		*vtarget;
 	VirtDevice		*vdev;
-	uint			target = device->id;
-
-	if (hd == NULL)
-		return -ENODEV;
-
-	if ((vdev = hd->Targets[target]) != NULL)
-		goto out;
+	struct scsi_target 	*starget;
 
 	vdev = kmalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdev) {
@@ -2179,25 +2193,33 @@
 	}
 
 	memset(vdev, 0, sizeof(VirtDevice));
-	vdev->tflags = MPT_TARGET_FLAGS_Q_YES;
 	vdev->ioc_id = hd->ioc->id;
-	vdev->target_id = device->id;
-	vdev->bus_id = device->channel;
-	vdev->raidVolume = 0;
-	hd->Targets[device->id] = vdev;
-	if (hd->ioc->bus_type == SPI) {
-		if (hd->ioc->raid_data.isRaid & (1 << device->id)) {
-			vdev->raidVolume = 1;
-			ddvtprintk((KERN_INFO
-			    "RAID Volume @ id %d\n", device->id));
+	vdev->target_id = sdev->id;
+	vdev->bus_id = sdev->channel;
+	vdev->lun = sdev->lun;
+	sdev->hostdata = vdev;
+
+	starget = scsi_target(sdev);
+	vtarget = starget->hostdata;
+	vdev->vtarget = vtarget;
+
+	if (vtarget->num_luns == 0) {
+		hd->Targets[sdev->id] = vtarget;
+		vtarget->ioc_id = hd->ioc->id;
+		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES;
+		vtarget->target_id = sdev->id;
+		vtarget->bus_id = sdev->channel;
+		if (hd->ioc->bus_type == SPI) {
+			if (hd->ioc->raid_data.isRaid & (1 << sdev->id)) {
+				vtarget->raidVolume = 1;
+				ddvtprintk((KERN_INFO
+				    "RAID Volume @ id %d\n", sdev->id));
+			}
+		} else {
+			vtarget->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
 		}
-	} else {
-		vdev->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
 	}
-
- out:
-	vdev->num_luns++;
-	device->hostdata = vdev;
+	vtarget->num_luns++;
 	return 0;
 }
 
@@ -2206,40 +2228,52 @@
  *	Called if no device present or device being unloaded
  */
 void
-mptscsih_slave_destroy(struct scsi_device *device)
+mptscsih_target_destroy(struct scsi_target *starget)
 {
-	struct Scsi_Host	*host = device->host;
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
-	VirtDevice		*vdev;
-	uint			target = device->id;
-	uint			lun = device->lun;
-
-	if (hd == NULL)
-		return;
-
-	mptscsih_search_running_cmds(hd, target, lun);
-
-	vdev = hd->Targets[target];
-	vdev->luns[0] &= ~(1 << lun);
-	if (--vdev->num_luns)
-		return;
-
-	kfree(hd->Targets[target]);
-	hd->Targets[target] = NULL;
-
-	if (hd->ioc->bus_type == SPI) {
-		if (mptscsih_is_phys_disk(hd->ioc, target)) {
-			hd->ioc->spi_data.forceDv |= MPT_SCSICFG_RELOAD_IOC_PG3;
-		} else {
-			hd->ioc->spi_data.dvStatus[target] =
-				MPT_SCSICFG_NEGOTIATE;
+	if (starget->hostdata)
+		kfree(starget->hostdata);
+	starget->hostdata = NULL;
+}
 
-			if (!hd->negoNvram) {
-				hd->ioc->spi_data.dvStatus[target] |=
-					MPT_SCSICFG_DV_NOT_DONE;
+/*
+ *	OS entry point to allow for host driver to free allocated memory
+ *	Called if no device present or device being unloaded
+ */
+void
+mptscsih_slave_destroy(struct scsi_device *sdev)
+{
+	struct Scsi_Host	*host = sdev->host;
+	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	VirtTarget		*vtarget;
+	VirtDevice		*vdevice;
+	struct scsi_target 	*starget;
+
+	starget = scsi_target(sdev);
+	vtarget = starget->hostdata;
+	vdevice = sdev->hostdata;
+
+	mptscsih_search_running_cmds(hd, vdevice);
+	vtarget->luns[0] &= ~(1 << vdevice->lun);
+	vtarget->num_luns--;
+	if (vtarget->num_luns == 0) {
+		mptscsih_negotiate_to_asyn_narrow(hd, vtarget);
+		if (hd->ioc->bus_type == SPI) {
+			if (mptscsih_is_phys_disk(hd->ioc, vtarget->target_id)) {
+				hd->ioc->spi_data.forceDv |= MPT_SCSICFG_RELOAD_IOC_PG3;
+			} else {
+				hd->ioc->spi_data.dvStatus[vtarget->target_id] =
+					MPT_SCSICFG_NEGOTIATE;
+				if (!hd->negoNvram) {
+					hd->ioc->spi_data.dvStatus[vtarget->target_id] |=
+						MPT_SCSICFG_DV_NOT_DONE;
+				}
 			}
 		}
+		hd->Targets[sdev->id] = NULL;
 	}
+	mptscsih_synchronize_cache(hd, vdevice);
+	kfree(vdevice);
+	sdev->hostdata = NULL;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2253,22 +2287,21 @@
 int
 mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
-	VirtDevice *pTarget;
-	int	max_depth;
-	int	tagged;
+	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
+	VirtTarget 		*vtarget;
+	struct scsi_target 	*starget;
+	int			max_depth;
+	int			tagged;
 
-	if (hd == NULL)
-		return 0;
-	if (!(pTarget = hd->Targets[sdev->id]))
-		return 0;
+	starget = scsi_target(sdev);
+	vtarget = starget->hostdata;
 
 	if (hd->ioc->bus_type == SPI) {
-		if (pTarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {
-			if (!(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES))
+		if (vtarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {
+			if (!(vtarget->tflags & MPT_TARGET_FLAGS_Q_YES))
 				max_depth = 1;
-			else if (((pTarget->inq_data[0] & 0x1f) == 0x00) &&
-			         (pTarget->minSyncFactor <= MPT_ULTRA160 ))
+			else if (((vtarget->inq_data[0] & 0x1f) == 0x00) &&
+			         (vtarget->minSyncFactor <= MPT_ULTRA160 ))
 				max_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
 			else
 				max_depth = MPT_SCSI_CMD_PER_DEV_LOW;
@@ -2297,64 +2330,58 @@
  *	Return non-zero if fails.
  */
 int
-mptscsih_slave_configure(struct scsi_device *device)
+mptscsih_slave_configure(struct scsi_device *sdev)
 {
-	struct Scsi_Host	*sh = device->host;
-	VirtDevice		*pTarget;
+	struct Scsi_Host	*sh = sdev->host;
+	VirtTarget		*vtarget;
+	VirtDevice		*vdevice;
+	struct scsi_target 	*starget;
 	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)sh->hostdata;
+	int			indexed_lun, lun_index;
 
-	if ((hd == NULL) || (hd->Targets == NULL)) {
-		return 0;
-	}
+	starget = scsi_target(sdev);
+	vtarget = starget->hostdata;
+	vdevice = sdev->hostdata;
 
 	dsprintk((MYIOC_s_INFO_FMT
 		"device @ %p, id=%d, LUN=%d, channel=%d\n",
-		hd->ioc->name, device, device->id, device->lun, device->channel));
-	dsprintk((MYIOC_s_INFO_FMT
-		"sdtr %d wdtr %d ppr %d inq length=%d\n",
-		hd->ioc->name, device->sdtr, device->wdtr,
-		device->ppr, device->inquiry_len));
+		hd->ioc->name, sdev, sdev->id, sdev->lun, sdev->channel));
+	if (hd->ioc->bus_type == SPI)
+		dsprintk((MYIOC_s_INFO_FMT
+		    "sdtr %d wdtr %d ppr %d inq length=%d\n",
+		    hd->ioc->name, sdev->sdtr, sdev->wdtr,
+		    sdev->ppr, sdev->inquiry_len));
 
-	if (device->id > sh->max_id) {
+	if (sdev->id > sh->max_id) {
 		/* error case, should never happen */
-		scsi_adjust_queue_depth(device, 0, 1);
-		goto slave_configure_exit;
-	}
-
-	pTarget = hd->Targets[device->id];
-
-	if (pTarget == NULL) {
-		/* Driver doesn't know about this device.
-		 * Kernel may generate a "Dummy Lun 0" which
-		 * may become a real Lun if a
-		 * "scsi add-single-device" command is executed
-		 * while the driver is active (hot-plug a
-		 * device).  LSI Raid controllers need
-		 * queue_depth set to DEV_HIGH for this reason.
-		 */
-		scsi_adjust_queue_depth(device, MSG_SIMPLE_TAG,
-			MPT_SCSI_CMD_PER_DEV_HIGH);
+		scsi_adjust_queue_depth(sdev, 0, 1);
 		goto slave_configure_exit;
 	}
 
-	mptscsih_initTarget(hd, device->channel, device->id, device->lun,
-		device->inquiry, device->inquiry_len );
-	mptscsih_change_queue_depth(device, MPT_SCSI_CMD_PER_DEV_HIGH);
+	vdevice->configured_lun=1;
+	lun_index = (vdevice->lun >> 5);  /* 32 luns per lun_index */
+	indexed_lun = (vdevice->lun % 32);
+	vtarget->luns[lun_index] |= (1 << indexed_lun);
+	mptscsih_initTarget(hd, vtarget, sdev->lun, sdev->inquiry,
+	    sdev->inquiry_len );
+	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 
 	dsprintk((MYIOC_s_INFO_FMT
 		"Queue depth=%d, tflags=%x\n",
-		hd->ioc->name, device->queue_depth, pTarget->tflags));
+		hd->ioc->name, sdev->queue_depth, vtarget->tflags));
 
-	dsprintk((MYIOC_s_INFO_FMT
-		"negoFlags=%x, maxOffset=%x, SyncFactor=%x\n",
-		hd->ioc->name, pTarget->negoFlags, pTarget->maxOffset, pTarget->minSyncFactor));
+	if (hd->ioc->bus_type == SPI)
+		dsprintk((MYIOC_s_INFO_FMT
+		    "negoFlags=%x, maxOffset=%x, SyncFactor=%x\n",
+		    hd->ioc->name, vtarget->negoFlags, vtarget->maxOffset,
+		    vtarget->minSyncFactor));
 
 slave_configure_exit:
 
 	dsprintk((MYIOC_s_INFO_FMT
 		"tagged %d, simple %d, ordered %d\n",
-		hd->ioc->name,device->tagged_supported, device->simple_tags,
-		device->ordered_tags));
+		hd->ioc->name,sdev->tagged_supported, sdev->simple_tags,
+		sdev->ordered_tags));
 
 	return 0;
 }
@@ -2372,16 +2399,14 @@
 static void
 mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply)
 {
-	VirtDevice	*target;
+	VirtDevice	*vdev;
 	SCSIIORequest_t	*pReq;
 	u32		 sense_count = le32_to_cpu(pScsiReply->SenseCount);
-	int		 index;
 
 	/* Get target structure
 	 */
 	pReq = (SCSIIORequest_t *) mf;
-	index = (int) pReq->TargetID;
-	target = hd->Targets[index];
+	vdev = sc->device->hostdata;
 
 	if (sense_count) {
 		u8 *sense_data;
@@ -2395,7 +2420,7 @@
 		/* Log SMART data (asc = 0x5D, non-IM case only) if required.
 		 */
 		if ((hd->ioc->events) && (hd->ioc->eventTypes & (1 << MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE))) {
-			if ((sense_data[12] == 0x5D) && (target->raidVolume == 0)) {
+			if ((sense_data[12] == 0x5D) && (vdev->vtarget->raidVolume == 0)) {
 				int idx;
 				MPT_ADAPTER *ioc = hd->ioc;
 
@@ -2405,7 +2430,7 @@
 
 				ioc->events[idx].data[0] = (pReq->LUN[1] << 24) ||
 					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) ||
-					(pReq->Bus << 8) || pReq->TargetID;
+					(sc->device->channel << 8) || sc->device->id;
 
 				ioc->events[idx].data[1] = (sense_data[13] << 8) || sense_data[12];
 
@@ -2634,8 +2659,7 @@
 /*
  *	mptscsih_initTarget - Target, LUN alloc/free functionality.
  *	@hd: Pointer to MPT_SCSI_HOST structure
- *	@bus_id: Bus number (?)
- *	@target_id: SCSI target id
+ *	@vtarget: per target private data
  *	@lun: SCSI LUN id
  *	@data: Pointer to data
  *	@dlen: Number of INQUIRY bytes
@@ -2648,15 +2672,14 @@
  *
  */
 static void
-mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id, u8 lun, char *data, int dlen)
+mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, u8 lun, char *data, int dlen)
 {
-	int		indexed_lun, lun_index;
-	VirtDevice	*vdev;
 	SpiCfgData	*pSpi;
 	char		data_56;
+	int		inq_len;
 
 	dinitprintk((MYIOC_s_INFO_FMT "initTarget bus=%d id=%d lun=%d hd=%p\n",
-			hd->ioc->name, bus_id, target_id, lun, hd));
+		hd->ioc->name, vtarget->bus_id, vtarget->target_id, lun, hd));
 
 	/*
 	 * If the peripheral qualifier filter is enabled then if the target reports a 0x1
@@ -2676,75 +2699,68 @@
 	if (data[0] & 0xe0)
 		return;
 
-	if ((vdev = hd->Targets[target_id]) == NULL) {
+	if (vtarget == NULL)
 		return;
-	}
 
-	lun_index = (lun >> 5);  /* 32 luns per lun_index */
-	indexed_lun = (lun % 32);
-	vdev->luns[lun_index] |= (1 << indexed_lun);
+	if (data)
+		vtarget->type = data[0];
 
-	if (hd->ioc->bus_type == SPI) {
-		if ((data[0] == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
-			/* Treat all Processors as SAF-TE if
-			 * command line option is set */
-			vdev->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
-			mptscsih_writeIOCPage4(hd, target_id, bus_id);
-		}else if ((data[0] == TYPE_PROCESSOR) &&
-			!(vdev->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {
-			if ( dlen > 49 ) {
-				vdev->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
-				if ( data[44] == 'S' &&
-				     data[45] == 'A' &&
-				     data[46] == 'F' &&
-				     data[47] == '-' &&
-				     data[48] == 'T' &&
-				     data[49] == 'E' ) {
-					vdev->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
-					mptscsih_writeIOCPage4(hd, target_id, bus_id);
-				}
+	if (hd->ioc->bus_type != SPI)
+		return;
+
+	if ((data[0] == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
+		/* Treat all Processors as SAF-TE if
+		 * command line option is set */
+		vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
+		mptscsih_writeIOCPage4(hd, vtarget->target_id, vtarget->bus_id);
+	}else if ((data[0] == TYPE_PROCESSOR) &&
+		!(vtarget->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {
+		if ( dlen > 49 ) {
+			vtarget->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
+			if ( data[44] == 'S' &&
+			     data[45] == 'A' &&
+			     data[46] == 'F' &&
+			     data[47] == '-' &&
+			     data[48] == 'T' &&
+			     data[49] == 'E' ) {
+				vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
+				mptscsih_writeIOCPage4(hd, vtarget->target_id, vtarget->bus_id);
 			}
 		}
-		if (!(vdev->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY)) {
-			if ( dlen > 8 ) {
-				memcpy (vdev->inq_data, data, 8);
-			} else {
-				memcpy (vdev->inq_data, data, dlen);
-			}
-
-			/* If have not done DV, set the DV flag.
+	}
+	if (!(vtarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY)) {
+		inq_len = dlen < 8 ? dlen : 8;
+		memcpy (vtarget->inq_data, data, inq_len);
+		/* If have not done DV, set the DV flag.
+		 */
+		pSpi = &hd->ioc->spi_data;
+		if ((data[0] == TYPE_TAPE) || (data[0] == TYPE_PROCESSOR)) {
+			if (pSpi->dvStatus[vtarget->target_id] & MPT_SCSICFG_DV_NOT_DONE)
+				pSpi->dvStatus[vtarget->target_id] |= MPT_SCSICFG_NEED_DV;
+		}
+		vtarget->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
+
+		data_56 = 0x0F;  /* Default to full capabilities if Inq data length is < 57 */
+		if (dlen > 56) {
+			if ( (!(vtarget->tflags & MPT_TARGET_FLAGS_VALID_56))) {
+			/* Update the target capabilities
 			 */
-			pSpi = &hd->ioc->spi_data;
-			if ((data[0] == TYPE_TAPE) || (data[0] == TYPE_PROCESSOR)) {
-				if (pSpi->dvStatus[target_id] & MPT_SCSICFG_DV_NOT_DONE)
-					pSpi->dvStatus[target_id] |= MPT_SCSICFG_NEED_DV;
+				data_56 = data[56];
+				vtarget->tflags |= MPT_TARGET_FLAGS_VALID_56;
 			}
-
-			vdev->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
-
-
-			data_56 = 0x0F;  /* Default to full capabilities if Inq data length is < 57 */
-			if (dlen > 56) {
-				if ( (!(vdev->tflags & MPT_TARGET_FLAGS_VALID_56))) {
-				/* Update the target capabilities
-				 */
-					data_56 = data[56];
-					vdev->tflags |= MPT_TARGET_FLAGS_VALID_56;
-				}
-			}
-			mptscsih_setTargetNegoParms(hd, vdev, data_56);
-		} else {
-			/* Initial Inquiry may not request enough data bytes to
-			 * obtain byte 57.  DV will; if target doesn't return
-			 * at least 57 bytes, data[56] will be zero. */
-			if (dlen > 56) {
-				if ( (!(vdev->tflags & MPT_TARGET_FLAGS_VALID_56))) {
-				/* Update the target capabilities
-				 */
-					data_56 = data[56];
-					vdev->tflags |= MPT_TARGET_FLAGS_VALID_56;
-					mptscsih_setTargetNegoParms(hd, vdev, data_56);
-				}
+		}
+		mptscsih_setTargetNegoParms(hd, vtarget, data_56);
+	} else {
+		/* Initial Inquiry may not request enough data bytes to
+		 * obtain byte 57.  DV will; if target doesn't return
+		 * at least 57 bytes, data[56] will be zero. */
+		if (dlen > 56) {
+			if ( (!(vtarget->tflags & MPT_TARGET_FLAGS_VALID_56))) {
+			/* Update the target capabilities
+			 */
+				data_56 = data[56];
+				vtarget->tflags |= MPT_TARGET_FLAGS_VALID_56;
+				mptscsih_setTargetNegoParms(hd, vtarget, data_56);
 			}
 		}
 	}
@@ -2757,12 +2773,12 @@
  *
  */
 static void
-mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56)
+mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target, char byte56)
 {
 	SpiCfgData *pspi_data = &hd->ioc->spi_data;
 	int  id = (int) target->target_id;
 	int  nvram;
-	VirtDevice	*vdev;
+	VirtTarget	*vtarget;
 	int ii;
 	u8 width = MPT_NARROW;
 	u8 factor = MPT_ASYNC;
@@ -2907,9 +2923,9 @@
 
 			ddvtprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
 			for (ii = 0; ii < id; ii++) {
-				if ( (vdev = hd->Targets[ii]) ) {
-					vdev->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
-					mptscsih_writeSDP1(hd, 0, ii, vdev->negoFlags);
+				if ( (vtarget = hd->Targets[ii]) ) {
+					vtarget->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
+					mptscsih_writeSDP1(hd, 0, ii, vtarget->negoFlags);
 				}
 			}
 		}
@@ -2933,12 +2949,12 @@
  * prevent any future negotiations to this device.
  */
 static void
-mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int target_id)
+mptscsih_no_negotiate(MPT_SCSI_HOST *hd, struct scsi_cmnd *sc)
 {
+	VirtDevice	*vdev;
 
-	if ((hd->Targets) && (hd->Targets[target_id] == NULL))
-		hd->ioc->spi_data.dvStatus[target_id] |= MPT_SCSICFG_BLK_NEGO;
-
+	if ((vdev = sc->device->hostdata) != NULL)
+		hd->ioc->spi_data.dvStatus[vdev->target_id] |= MPT_SCSICFG_BLK_NEGO;
 	return;
 }
 
@@ -3014,7 +3030,7 @@
 	MPT_ADAPTER		*ioc = hd->ioc;
 	Config_t		*pReq;
 	SCSIDevicePage1_t	*pData;
-	VirtDevice		*pTarget=NULL;
+	VirtTarget		*vtarget=NULL;
 	MPT_FRAME_HDR		*mf;
 	dma_addr_t		 dataDma;
 	u16			 req_idx;
@@ -3094,11 +3110,11 @@
 		/* If id is not a raid volume, get the updated
 		 * transmission settings from the target structure.
 		 */
-		if (hd->Targets && (pTarget = hd->Targets[id]) && !pTarget->raidVolume) {
-			width = pTarget->maxWidth;
-			factor = pTarget->minSyncFactor;
-			offset = pTarget->maxOffset;
-			negoFlags = pTarget->negoFlags;
+		if (hd->Targets && (vtarget = hd->Targets[id]) && !vtarget->raidVolume) {
+			width = vtarget->maxWidth;
+			factor = vtarget->minSyncFactor;
+			offset = vtarget->maxOffset;
+			negoFlags = vtarget->negoFlags;
 		}
 
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
@@ -3830,152 +3846,122 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_synchronize_cache - Send SYNCHRONIZE_CACHE to all disks.
- *	@hd: Pointer to MPT_SCSI_HOST structure
- *	@portnum: IOC port number
+ *	mptscsih_negotiate_to_asyn_narrow - Restore devices to default state
+ *	@hd: Pointer to a SCSI HOST structure
+ *	@vtarget: per device private data
  *
  *	Uses the ISR, but with special processing.
  *	MUST be single-threaded.
  *
- *	Return: 0 on completion
  */
-static int
-mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int portnum)
+static void
+mptscsih_negotiate_to_asyn_narrow(MPT_SCSI_HOST *hd, VirtTarget *vtarget)
 {
 	MPT_ADAPTER		*ioc= hd->ioc;
-	VirtDevice		*pTarget;
-	SCSIDevicePage1_t	*pcfg1Data = NULL;
-	INTERNAL_CMD		 iocmd;
+	SCSIDevicePage1_t	*pcfg1Data;
 	CONFIGPARMS		 cfg;
-	dma_addr_t		 cfg1_dma_addr = -1;
-	ConfigPageHeader_t	 header1;
-	int			 bus = 0;
-	int			 id = 0;
-	int			 lun;
-	int			 indexed_lun, lun_index;
-	int			 hostId = ioc->pfacts[portnum].PortSCSIID;
-	int			 max_id;
-	int			 requested, configuration, data;
-	int			 doConfig = 0;
+	dma_addr_t		 cfg1_dma_addr;
+	ConfigPageHeader_t	 header;
+	int			 id;
+	int			 requested, configuration, data,i;
 	u8			 flags, factor;
 
-	max_id = ioc->sh->max_id - 1;
-
-	/* Following parameters will not change
-	 * in this routine.
-	 */
-	iocmd.cmd = SYNCHRONIZE_CACHE;
-	iocmd.flags = 0;
-	iocmd.physDiskNum = -1;
-	iocmd.data = NULL;
-	iocmd.data_dma = -1;
-	iocmd.size = 0;
-	iocmd.rsvd = iocmd.rsvd2 = 0;
-
-	/* No SCSI hosts
-	 */
-	if (hd->Targets == NULL)
-		return 0;
-
-	/* Skip the host
-	 */
-	if (id == hostId)
-		id++;
-
-	/* Write SDP1 for all SPI devices
-	 * Alloc memory and set up config buffer
-	 */
-	if (ioc->bus_type == SPI) {
-		if (ioc->spi_data.sdp1length > 0) {
-			pcfg1Data = (SCSIDevicePage1_t *)pci_alloc_consistent(ioc->pcidev,
-					 ioc->spi_data.sdp1length * 4, &cfg1_dma_addr);
-
-			if (pcfg1Data != NULL) {
-				doConfig = 1;
-				header1.PageVersion = ioc->spi_data.sdp1version;
-				header1.PageLength = ioc->spi_data.sdp1length;
-				header1.PageNumber = 1;
-				header1.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
-				cfg.cfghdr.hdr = &header1;
-				cfg.physAddr = cfg1_dma_addr;
-				cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-				cfg.dir = 1;
-				cfg.timeout = 0;
-			}
-		}
-	}
+	if (ioc->bus_type != SPI)
+		return;
 
-	/* loop through all devices on this port
-	 */
-	while (bus < MPT_MAX_BUS) {
-		iocmd.bus = bus;
-		iocmd.id = id;
-		pTarget = hd->Targets[(int)id];
+	if (!ioc->spi_data.sdp1length)
+		return;
 
-		if (doConfig) {
+	pcfg1Data = (SCSIDevicePage1_t *)pci_alloc_consistent(ioc->pcidev,
+		 ioc->spi_data.sdp1length * 4, &cfg1_dma_addr);
 
-			/* Set the negotiation flags */
-			if (pTarget && (pTarget = hd->Targets[id]) && !pTarget->raidVolume) {
-				flags = pTarget->negoFlags;
-			} else {
-				flags = hd->ioc->spi_data.noQas;
-				if (hd->ioc->spi_data.nvram && (hd->ioc->spi_data.nvram[id] != MPT_HOST_NVRAM_INVALID)) {
-					data = hd->ioc->spi_data.nvram[id];
+	if (pcfg1Data == NULL)
+		return;
 
-					if (data & MPT_NVRAM_WIDE_DISABLE)
-						flags |= MPT_TARGET_NO_NEGO_WIDE;
+	header.PageVersion = ioc->spi_data.sdp1version;
+	header.PageLength = ioc->spi_data.sdp1length;
+	header.PageNumber = 1;
+	header.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
+	cfg.cfghdr.hdr = &header;
+	cfg.physAddr = cfg1_dma_addr;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	cfg.dir = 1;
+	cfg.timeout = 0;
 
-					factor = (data & MPT_NVRAM_SYNC_MASK) >> MPT_NVRAM_SYNC_SHIFT;
-					if ((factor == 0) || (factor == MPT_ASYNC))
-						flags |= MPT_TARGET_NO_NEGO_SYNC;
-				}
+	if (vtarget->raidVolume && ioc->raid_data.pIocPg3) {
+		for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
+			id = ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID;
+			flags = hd->ioc->spi_data.noQas;
+			if (hd->ioc->spi_data.nvram && (hd->ioc->spi_data.nvram[id] != MPT_HOST_NVRAM_INVALID)) {
+				data = hd->ioc->spi_data.nvram[id];
+				if (data & MPT_NVRAM_WIDE_DISABLE)
+					flags |= MPT_TARGET_NO_NEGO_WIDE;
+				factor = (data & MPT_NVRAM_SYNC_MASK) >> MPT_NVRAM_SYNC_SHIFT;
+				if ((factor == 0) || (factor == MPT_ASYNC))
+					flags |= MPT_TARGET_NO_NEGO_SYNC;
 			}
-
-			/* Force to async, narrow */
 			mptscsih_setDevicePage1Flags(0, MPT_ASYNC, 0, &requested,
-					&configuration, flags);
+				&configuration, flags);
 			dnegoprintk(("syncronize cache: id=%d width=0 factor=MPT_ASYNC "
 				"offset=0 negoFlags=%x request=%x config=%x\n",
 				id, flags, requested, configuration));
 			pcfg1Data->RequestedParameters = cpu_to_le32(requested);
 			pcfg1Data->Reserved = 0;
 			pcfg1Data->Configuration = cpu_to_le32(configuration);
-			cfg.pageAddr = (bus<<8) | id;
+			cfg.pageAddr = (vtarget->bus_id<<8) | id;
 			mpt_config(hd->ioc, &cfg);
 		}
-
-		/* If target Ptr NULL or if this target is NOT a disk, skip.
-		 */
-		if ((pTarget) && (pTarget->inq_data[0] == TYPE_DISK)){
-			for (lun=0; lun <= MPT_LAST_LUN; lun++) {
-				/* If LUN present, issue the command
-				 */
-				lun_index = (lun >> 5);  /* 32 luns per lun_index */
-				indexed_lun = (lun % 32);
-				if (pTarget->luns[lun_index] & (1<<indexed_lun)) {
-					iocmd.lun = lun;
-					(void) mptscsih_do_cmd(hd, &iocmd);
-				}
-			}
-		}
-
-		/* get next relevant device */
-		id++;
-
-		if (id == hostId)
-			id++;
-
-		if (id > max_id) {
-			id = 0;
-			bus++;
-		}
+	} else {
+		flags = vtarget->negoFlags;
+		mptscsih_setDevicePage1Flags(0, MPT_ASYNC, 0, &requested,
+				&configuration, flags);
+		dnegoprintk(("syncronize cache: id=%d width=0 factor=MPT_ASYNC "
+			"offset=0 negoFlags=%x request=%x config=%x\n",
+			vtarget->target_id, flags, requested, configuration));
+		pcfg1Data->RequestedParameters = cpu_to_le32(requested);
+		pcfg1Data->Reserved = 0;
+		pcfg1Data->Configuration = cpu_to_le32(configuration);
+		cfg.pageAddr = (vtarget->bus_id<<8) | vtarget->target_id;
+		mpt_config(hd->ioc, &cfg);
 	}
 
-	if (pcfg1Data) {
-		pci_free_consistent(ioc->pcidev, header1.PageLength * 4, pcfg1Data, cfg1_dma_addr);
-	}
+	if (pcfg1Data)
+		pci_free_consistent(ioc->pcidev, header.PageLength * 4, pcfg1Data, cfg1_dma_addr);
+}
 
-	return 0;
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mptscsih_synchronize_cache - Send SYNCHRONIZE_CACHE to all disks.
+ *	@hd: Pointer to a SCSI HOST structure
+ *	@vtarget: per device private data
+ *	@lun: lun
+ *
+ *	Uses the ISR, but with special processing.
+ *	MUST be single-threaded.
+ *
+ */
+static void
+mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
+{
+	INTERNAL_CMD		 iocmd;
+
+	/* Following parameters will not change
+	 * in this routine.
+	 */
+	iocmd.cmd = SYNCHRONIZE_CACHE;
+	iocmd.flags = 0;
+	iocmd.physDiskNum = -1;
+	iocmd.data = NULL;
+	iocmd.data_dma = -1;
+	iocmd.size = 0;
+	iocmd.rsvd = iocmd.rsvd2 = 0;
+	iocmd.bus = vdevice->bus_id;
+	iocmd.id = vdevice->target_id;
+	iocmd.lun = (u8)vdevice->lun;
+
+	if ((vdevice->vtarget->type & TYPE_DISK) &&
+	    (vdevice->configured_lun))
+		mptscsih_do_cmd(hd, &iocmd);
 }
 
 /* Search IOC page 3 to determine if this is hidden physical disk
@@ -4146,7 +4132,7 @@
 static void
 mptscsih_qas_check(MPT_SCSI_HOST *hd, int id)
 {
-	VirtDevice *pTarget;
+	VirtTarget *vtarget;
 	int ii;
 
 	if (hd->Targets == NULL)
@@ -4159,11 +4145,11 @@
 		if ((hd->ioc->spi_data.dvStatus[ii] & MPT_SCSICFG_DV_NOT_DONE) != 0)
 			continue;
 
-		pTarget = hd->Targets[ii];
+		vtarget = hd->Targets[ii];
 
-		if ((pTarget != NULL) && (!pTarget->raidVolume)) {
-			if ((pTarget->negoFlags & hd->ioc->spi_data.noQas) == 0) {
-				pTarget->negoFlags |= hd->ioc->spi_data.noQas;
+		if ((vtarget != NULL) && (!vtarget->raidVolume)) {
+			if ((vtarget->negoFlags & hd->ioc->spi_data.noQas) == 0) {
+				vtarget->negoFlags |= hd->ioc->spi_data.noQas;
 				dnegoprintk(("writeSDP1: id=%d flags=0\n", id));
 				mptscsih_writeSDP1(hd, 0, ii, 0);
 			}
@@ -4203,7 +4189,7 @@
 mptscsih_doDv(MPT_SCSI_HOST *hd, int bus_number, int id)
 {
 	MPT_ADAPTER		*ioc = hd->ioc;
-	VirtDevice		*pTarget;
+	VirtTarget		*vtarget;
 	SCSIDevicePage1_t	*pcfg1Data;
 	SCSIDevicePage0_t	*pcfg0Data;
 	u8			*pbuf1;
@@ -4274,12 +4260,12 @@
 	iocmd.physDiskNum = -1;
 	iocmd.rsvd = iocmd.rsvd2 = 0;
 
-	pTarget = hd->Targets[id];
+	vtarget = hd->Targets[id];
 
 	/* Use tagged commands if possible.
 	 */
-	if (pTarget) {
-		if (pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)
+	if (vtarget) {
+		if (vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
 			iocmd.flags |= MPT_ICFLAG_TAGGED_CMD;
 		else {
 			if (hd->ioc->facts.FWVersion.Word < 0x01000600)
@@ -4495,7 +4481,7 @@
 		/* Reset the size for disks
 		 */
 		inq0 = (*pbuf1) & 0x1F;
-		if ((inq0 == 0) && pTarget && !pTarget->raidVolume) {
+		if ((inq0 == 0) && vtarget && !vtarget->raidVolume) {
 			sz = 0x40;
 			iocmd.size = sz;
 		}
@@ -4505,8 +4491,7 @@
 		 */
 		if (inq0 == TYPE_PROCESSOR) {
 			mptscsih_initTarget(hd,
-				bus,
-				id,
+				vtarget,
 				lun,
 				pbuf1,
 				sz);
@@ -4520,22 +4505,22 @@
 			goto target_done;
 
 		if (sz == 0x40) {
-			if ((pTarget->maxWidth == 1) && (pTarget->maxOffset) && (nfactor < 0x0A)
-				&& (pTarget->minSyncFactor > 0x09)) {
+			if ((vtarget->maxWidth == 1) && (vtarget->maxOffset) && (nfactor < 0x0A)
+				&& (vtarget->minSyncFactor > 0x09)) {
 				if ((pbuf1[56] & 0x04) == 0)
 					;
 				else if ((pbuf1[56] & 0x01) == 1) {
-					pTarget->minSyncFactor =
+					vtarget->minSyncFactor =
 					    nfactor > MPT_ULTRA320 ? nfactor : MPT_ULTRA320;
 				} else {
-					pTarget->minSyncFactor =
+					vtarget->minSyncFactor =
 					    nfactor > MPT_ULTRA160 ? nfactor : MPT_ULTRA160;
 				}
 
-				dv.max.factor = pTarget->minSyncFactor;
+				dv.max.factor = vtarget->minSyncFactor;
 
 				if ((pbuf1[56] & 0x02) == 0) {
-					pTarget->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
+					vtarget->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
 					hd->ioc->spi_data.noQas = MPT_TARGET_NO_NEGO_QAS;
 					ddvprintk((MYIOC_s_NOTE_FMT
 					    "DV: Start Basic noQas on id=%d due to pbuf1[56]=%x\n",
@@ -4618,8 +4603,7 @@
 						    "DV:Inquiry compared id=%d, calling initTarget\n", ioc->name, id));
 						hd->ioc->spi_data.dvStatus[id] &= ~MPT_SCSICFG_DV_NOT_DONE;
 						mptscsih_initTarget(hd,
-							bus,
-							id,
+							vtarget,
 							lun,
 							pbuf1,
 							sz);
@@ -5120,7 +5104,7 @@
 static void
 mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void *pPage)
 {
-	VirtDevice		*pTarget;
+	VirtTarget		*vtarget;
 	SCSIDevicePage0_t	*pPage0;
 	SCSIDevicePage1_t	*pPage1;
 	int			val = 0, data, configuration;
@@ -5140,11 +5124,11 @@
 		 * already throttled back.
 		 */
 		negoFlags = hd->ioc->spi_data.noQas;
-		if ((hd->Targets)&&((pTarget = hd->Targets[(int)id]) != NULL) && !pTarget->raidVolume) {
-			width = pTarget->maxWidth;
-			offset = pTarget->maxOffset;
-			factor = pTarget->minSyncFactor;
-			negoFlags |= pTarget->negoFlags;
+		if ((hd->Targets)&&((vtarget = hd->Targets[(int)id]) != NULL) && !vtarget->raidVolume) {
+			width = vtarget->maxWidth;
+			offset = vtarget->maxOffset;
+			factor = vtarget->minSyncFactor;
+			negoFlags |= vtarget->negoFlags;
 		} else {
 			if (hd->ioc->spi_data.nvram && (hd->ioc->spi_data.nvram[id] != MPT_HOST_NVRAM_INVALID)) {
 				data = hd->ioc->spi_data.nvram[id];
@@ -5346,11 +5330,11 @@
 		 * or overwrite nvram (phys disks only).
 		 */
 
-		if ((hd->Targets)&&((pTarget = hd->Targets[(int)id]) != NULL) && !pTarget->raidVolume ) {
-			pTarget->maxWidth = dv->now.width;
-			pTarget->maxOffset = dv->now.offset;
-			pTarget->minSyncFactor = dv->now.factor;
-			pTarget->negoFlags = dv->now.flags;
+		if ((hd->Targets)&&((vtarget = hd->Targets[(int)id]) != NULL) && !vtarget->raidVolume ) {
+			vtarget->maxWidth = dv->now.width;
+			vtarget->maxOffset = dv->now.offset;
+			vtarget->minSyncFactor = dv->now.factor;
+			vtarget->negoFlags = dv->now.flags;
 		} else {
 			/* Preserv all flags, use
 			 * read-modify-write algorithm
@@ -5514,7 +5498,7 @@
  * Called only if DV_NOT_DONE flag is set
  */
 static void
-mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq)
+mptscsih_set_dvflags(MPT_SCSI_HOST *hd, struct scsi_cmnd *sc)
 {
 	MPT_ADAPTER	*ioc = hd->ioc;
 	u8 cmd;
@@ -5522,16 +5506,16 @@
 
 	ddvtprintk((MYIOC_s_NOTE_FMT
 		" set_dvflags: id=%d lun=%d negoNvram=%x cmd=%x\n",
-		hd->ioc->name, pReq->TargetID, pReq->LUN[1], hd->negoNvram, pReq->CDB[0]));
+		hd->ioc->name, sc->device->id, sc->device->lun , hd->negoNvram, sc->cmnd[0]));
 
-	if ((pReq->LUN[1] != 0) || (hd->negoNvram != 0))
+	if ((sc->device->lun != 0) || (hd->negoNvram != 0))
 		return;
 
-	cmd = pReq->CDB[0];
+	cmd = sc->cmnd[0];
 
 	if ((cmd == READ_CAPACITY) || (cmd == MODE_SENSE)) {
 		pSpi = &ioc->spi_data;
-		if ((ioc->raid_data.isRaid & (1 << pReq->TargetID)) && ioc->raid_data.pIocPg3) {
+		if ((ioc->raid_data.isRaid & (1 << sc->device->id)) && ioc->raid_data.pIocPg3) {
 			/* Set NEED_DV for all hidden disks
 			 */
 			Ioc3PhysDisk_t *pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
@@ -5544,8 +5528,8 @@
 				numPDisk--;
 			}
 		}
-		pSpi->dvStatus[pReq->TargetID] |= MPT_SCSICFG_NEED_DV;
-		ddvtprintk(("NEED_DV set for visible disk id %d\n", pReq->TargetID));
+		pSpi->dvStatus[sc->device->id] |= MPT_SCSICFG_NEED_DV;
+		ddvtprintk(("NEED_DV set for visible disk id %d\n", sc->device->id));
 	}
 }
 
@@ -5592,7 +5576,6 @@
 		}
 	}
 }
-
 #endif /* ~MPTSCSIH_ENABLE_DOMAIN_VALIDATION */
 
 EXPORT_SYMBOL(mptscsih_remove);
@@ -5604,7 +5587,9 @@
 EXPORT_SYMBOL(mptscsih_proc_info);
 EXPORT_SYMBOL(mptscsih_info);
 EXPORT_SYMBOL(mptscsih_qcmd);
+EXPORT_SYMBOL(mptscsih_target_alloc);
 EXPORT_SYMBOL(mptscsih_slave_alloc);
+EXPORT_SYMBOL(mptscsih_target_destroy);
 EXPORT_SYMBOL(mptscsih_slave_destroy);
 EXPORT_SYMBOL(mptscsih_slave_configure);
 EXPORT_SYMBOL(mptscsih_abort);
diff -uarN b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2005-11-16 17:44:59.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.h	2005-11-11 13:52:12.000000000 -0700
@@ -91,7 +91,9 @@
 extern int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int func);
 extern const char * mptscsih_info(struct Scsi_Host *SChost);
 extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *));
+extern int mptscsih_target_alloc(struct scsi_target *starget);
 extern int mptscsih_slave_alloc(struct scsi_device *device);
+extern void mptscsih_target_destroy(struct scsi_target *starget);
 extern void mptscsih_slave_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
diff -uarN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2005-11-16 17:26:47.000000000 -0700
+++ a/drivers/message/fusion/mptspi.c	2005-11-16 17:53:58.000000000 -0700
@@ -109,8 +109,10 @@
 	.name				= "MPT SPI Host",
 	.info				= mptscsih_info,
 	.queuecommand			= mptscsih_qcmd,
+	.target_alloc			= mptscsih_target_alloc,
 	.slave_alloc			= mptscsih_slave_alloc,
 	.slave_configure		= mptscsih_slave_configure,
+	.target_destroy			= mptscsih_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
@@ -312,10 +314,10 @@
 	}
 
 	memset(mem, 0, sz);
-	hd->Targets = (VirtDevice **) mem;
+	hd->Targets = (VirtTarget **) mem;
 
 	dprintk((KERN_INFO
-	  "  Targets @ %p, sz=%d\n", hd->Targets, sz));
+	  "  vdev @ %p, sz=%d\n", hd->Targets, sz));
 
 	/* Clear the TM flags
 	 */

--Boundary-00=_RL+eD7wd8l1B0lK--
