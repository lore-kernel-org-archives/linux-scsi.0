From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] raid class support for mptfusion
Date: Sun, 06 Nov 2005 12:03:23 -0600
Message-ID: <1131300203.3316.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:18057 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750772AbVKFSD1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Nov 2005 13:03:27 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id jA6I3Ox20895
	for <linux-scsi@vger.kernel.org>; Sun, 6 Nov 2005 13:03:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This adds both raid class support and SPI transport class support (the
raid classes are built on top of the SPI transport class support, so it
just seemed easier to combine the two patches).  The raid class features
are quite primitive, but it can now show the state of the raid array and
the resync completion fraction.  The next project will be to add a piece
state model allowing the individual raid pieces to be taken on and
offline.

James
diff --git a/drivers/message/fusion/Kconfig b/drivers/message/fusion/Kconfig
--- a/drivers/message/fusion/Kconfig
+++ b/drivers/message/fusion/Kconfig
@@ -9,6 +9,8 @@ config FUSION_SPI
 	tristate "Fusion MPT ScsiHost drivers for SPI"
 	depends on PCI && SCSI
 	select FUSION
+	select SCSI_SPI_ATTRS
+	select RAID_ATTRS
 	---help---
 	  SCSI HOST support for a parallel SCSI host adapters.
 
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -333,6 +333,8 @@ typedef struct _SYSIF_REGS
  */
 typedef struct _VirtDevice {
 	struct scsi_device	*device;
+	RaidVolumePage0_t	*raidVolume;	/* set, if RAID Volume */
+	int			 raidpg0size;
 	u8			 tflags;
 	u8			 ioc_id;
 	u8			 target_id;
@@ -341,7 +343,6 @@ typedef struct _VirtDevice {
 	u8			 maxOffset;	/* 0 if async */
 	u8			 maxWidth;	/* 0 if narrow, 1 if wide */
 	u8			 negoFlags;	/* bit field, see above */
-	u8			 raidVolume;	/* set, if RAID Volume */
 	u8			 type;		/* byte 0 of Inquiry data */
 	u8			 cflags;	/* controller flags */
 	u8			 rsvd1raid;
@@ -861,10 +862,15 @@ typedef struct _mpt_sge {
 typedef struct _MPT_LOCAL_REPLY {
 	ConfigPageHeader_t header;
 	int	completion;
-	u8	sense[SCSI_STD_SENSE_BYTES];
-	u8	scsiStatus;
-	u8	skip;
-	u32	pad;
+	union {
+		struct {
+			u8	sense[SCSI_STD_SENSE_BYTES];
+			u8	scsiStatus;
+			u8	skip;
+			u32	pad;
+		} s;
+		u64	r[6];
+	} u;
 } MPT_LOCAL_REPLY;
 
 #define MPT_HOST_BUS_UNKNOWN		(0xFF)
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -151,8 +151,6 @@ int		mptscsih_ioc_reset(MPT_ADAPTER *ioc
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
 static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id, u8 lun, char *data, int dlen);
-static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56);
-static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq);
 static void	mptscsih_setDevicePage1Flags (u8 width, u8 factor, u8 offset, int *requestedPtr, int *configurationPtr, u8 flags);
 static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int target_id);
 static int	mptscsih_writeSDP1(MPT_SCSI_HOST *hd, int portnum, int target, int flags);
@@ -163,19 +161,10 @@ static int	mptscsih_synchronize_cache(MP
 
 static struct work_struct   mptscsih_persistTask;
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-static int	mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD *io);
-static void	mptscsih_domainValidation(void *hd);
 static int	mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);
-static void	mptscsih_qas_check(MPT_SCSI_HOST *hd, int id);
-static int	mptscsih_doDv(MPT_SCSI_HOST *hd, int channel, int target);
-static void	mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void *pPage);
-static void	mptscsih_fillbuf(char *buffer, int size, int index, int width);
-static void	mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id);
-#endif
-
 void 		mptscsih_remove(struct pci_dev *);
 void 		mptscsih_shutdown(struct pci_dev *);
+static int	mptscsih_is_raid_volume(MPT_SCSI_HOST *hd, uint id);
 #ifdef CONFIG_PM
 int 		mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
 int 		mptscsih_resume(struct pci_dev *pdev);
@@ -183,16 +172,6 @@ int 		mptscsih_resume(struct pci_dev *pd
 
 #define SNS_LEN(scp)	sizeof((scp)->sense_buffer)
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-/*
- * Domain Validation task structure
- */
-static DEFINE_SPINLOCK(dvtaskQ_lock);
-static int dvtaskQ_active = 0;
-static int dvtaskQ_release = 0;
-static struct work_struct	dvTaskQ_task;
-#endif
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_add_sge - Place a simple SGE at address pAddr.
@@ -993,8 +972,6 @@ mptscsih_remove(struct pci_dev *pdev)
 	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
 	struct Scsi_Host 	*host = ioc->sh;
 	MPT_SCSI_HOST		*hd;
-	int 		 	count;
-	unsigned long	 	flags;
 	int sz1;
 
 	if(!host) {
@@ -1007,27 +984,6 @@ mptscsih_remove(struct pci_dev *pdev)
 	if((hd = (MPT_SCSI_HOST *)host->hostdata) == NULL)
 		return;
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-	/* Check DV thread active */
-	count = 10 * HZ;
-	spin_lock_irqsave(&dvtaskQ_lock, flags);
-	if (dvtaskQ_active) {
-		spin_unlock_irqrestore(&dvtaskQ_lock, flags);
-		while(dvtaskQ_active && --count) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(1);
-		}
-	} else {
-		spin_unlock_irqrestore(&dvtaskQ_lock, flags);
-	}
-	if (!count)
-		printk(KERN_ERR MYNAM ": ERROR - DV thread still active!\n");
-#if defined(MPT_DEBUG_DV) || defined(MPT_DEBUG_DV_TINY)
-	else
-		printk(KERN_ERR MYNAM ": DV thread orig %d, count %d\n", 10 * HZ, count);
-#endif
-#endif
-
 	mptscsih_shutdown(pdev);
 
 	sz1=0;
@@ -1120,21 +1076,6 @@ mptscsih_resume(struct pci_dev *pdev)
 	if(!hd)
 		return 0;
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-	{
-	unsigned long lflags;
-	spin_lock_irqsave(&dvtaskQ_lock, lflags);
-	if (!dvtaskQ_active) {
-		dvtaskQ_active = 1;
-		spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
-		INIT_WORK(&dvTaskQ_task,
-		  mptscsih_domainValidation, (void *) hd);
-		schedule_work(&dvTaskQ_task);
-	} else {
-		spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
-	}
-	}
-#endif
 	return 0;
 }
 
@@ -1289,6 +1230,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	MPT_FRAME_HDR		*mf;
 	SCSIIORequest_t		*pScsiReq;
 	VirtDevice		*pTarget = SCpnt->device->hostdata;
+	int	 target;
 	int	 lun;
 	u32	 datalen;
 	u32	 scsictl;
@@ -1298,9 +1240,12 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	int	 ii;
 
 	hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
+	target = SCpnt->device->id;
 	lun = SCpnt->device->lun;
 	SCpnt->scsi_done = done;
 
+	pTarget = mpt_target(hd, SCpnt->device->channel, target);
+
 	dmfprintk((MYIOC_s_INFO_FMT "qcmd: SCpnt=%p, done()=%p\n",
 			(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt, done));
 
@@ -1310,6 +1255,12 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	if (SCpnt->device->channel && !mptscsih_is_raid_volume(hd, target)) {
+		SCpnt->result = DID_NO_CONNECT << 16;
+		done(SCpnt);
+		return 0;
+	}
+
 	/*
 	 *  Put together a MPT SCSI request...
 	 */
@@ -1353,10 +1304,13 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 
 	/* Use the above information to set up the message frame
 	 */
-	pScsiReq->TargetID = (u8) pTarget->target_id;
-	pScsiReq->Bus = pTarget->bus_id;
+	pScsiReq->TargetID = (u8) target;
+	pScsiReq->Bus = 0;
 	pScsiReq->ChainOffset = 0;
-	pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
+	if (SCpnt->device->channel)
+		pScsiReq->Function = MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH;
+	else
+		pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
 	pScsiReq->CDBLength = SCpnt->cmd_len;
 	pScsiReq->SenseBufferLength = MPT_SENSE_BUFFER_SIZE;
 	pScsiReq->Reserved = 0;
@@ -1404,49 +1358,6 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	hd->ScsiLookup[my_idx] = SCpnt;
 	SCpnt->host_scribble = NULL;
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-	if (hd->ioc->bus_type == SCSI) {
-		int dvStatus = hd->ioc->spi_data.dvStatus[pTarget->target_id];
-		int issueCmd = 1;
-
-		if (dvStatus || hd->ioc->spi_data.forceDv) {
-
-			if ((dvStatus & MPT_SCSICFG_NEED_DV) ||
-				(hd->ioc->spi_data.forceDv & MPT_SCSICFG_NEED_DV)) {
-				unsigned long lflags;
-				/* Schedule DV if necessary */
-				spin_lock_irqsave(&dvtaskQ_lock, lflags);
-				if (!dvtaskQ_active) {
-					dvtaskQ_active = 1;
-					spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
-					INIT_WORK(&dvTaskQ_task, mptscsih_domainValidation, (void *) hd);
-
-					schedule_work(&dvTaskQ_task);
-				} else {
-					spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
-				}
-				hd->ioc->spi_data.forceDv &= ~MPT_SCSICFG_NEED_DV;
-			}
-
-			/* Trying to do DV to this target, extend timeout.
-			 * Wait to issue until flag is clear
-			 */
-			if (dvStatus & MPT_SCSICFG_DV_PENDING) {
-				mod_timer(&SCpnt->eh_timeout, jiffies + 40 * HZ);
-				issueCmd = 0;
-			}
-
-			/* Set the DV flags.
-			 */
-			if (dvStatus & MPT_SCSICFG_DV_NOT_DONE)
-				mptscsih_set_dvflags(hd, pScsiReq);
-
-			if (!issueCmd)
-				goto fail;
-		}
-	}
-#endif
-
 	mpt_put_msg_frame(hd->ioc->DoneCtx, hd->ioc, mf);
 	dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
 			hd->ioc->name, SCpnt, mf, my_idx));
@@ -2150,6 +2061,22 @@ mptscsih_bios_param(struct scsi_device *
 	return 0;
 }
 
+static int 
+mptscsih_is_raid_volume(MPT_SCSI_HOST *hd, uint id)
+{
+	int i;
+
+	if (!hd->ioc->raid_data.isRaid || !hd->ioc->raid_data.pIocPg3)
+		return 0;
+
+	for (i = 0; i < hd->ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
+		if (id == hd->ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)
+			return 1;
+	}
+
+	return 0;
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	OS entry point to allow host driver to alloc memory
@@ -2165,10 +2092,10 @@ mptscsih_slave_alloc(struct scsi_device 
 	VirtDevice		*vdev;
 	uint			target = device->id;
 
-	if (hd == NULL)
-		return -ENODEV;
+	if (device->channel)
+		device->no_uld_attach = 1;
 
-	if ((vdev = hd->Targets[target]) != NULL)
+	if ((vdev = mpt_target(hd, device->channel, target)) != NULL)
 		goto out;
 
 	vdev = kmalloc(sizeof(VirtDevice), GFP_KERNEL);
@@ -2181,13 +2108,22 @@ mptscsih_slave_alloc(struct scsi_device 
 	memset(vdev, 0, sizeof(VirtDevice));
 	vdev->tflags = MPT_TARGET_FLAGS_Q_YES;
 	vdev->ioc_id = hd->ioc->id;
-	vdev->target_id = device->id;
+	vdev->target_id = target;
 	vdev->bus_id = device->channel;
-	vdev->raidVolume = 0;
-	hd->Targets[device->id] = vdev;
-	if (hd->ioc->bus_type == SCSI) {
+	vdev->device = device;
+	vdev->raidVolume = NULL;
+	hd->Targets[target + (host->max_id * device->channel)] = vdev;
+	if (device->channel == 0 && hd->ioc->bus_type == SCSI) {
 		if (hd->ioc->raid_data.isRaid & (1 << device->id)) {
-			vdev->raidVolume = 1;
+			struct _CONFIG_PAGE_HEADER hdr;
+			if (mptscsih_read_raid_page0(device, (struct _CONFIG_PAGE_RAID_VOL_0 *)&hdr, sizeof(hdr), 0) < 0)
+				goto out_free;
+			vdev->raidpg0size = hdr.PageLength * 4;
+			vdev->raidVolume = kmalloc(vdev->raidpg0size, GFP_KERNEL);
+			if (!vdev->raidVolume)
+				goto out_free;
+			if (mptscsih_read_raid_page0(device, vdev->raidVolume, vdev->raidpg0size, hdr.PageVersion) < 0)
+				goto out_free;
 			ddvtprintk((KERN_INFO
 			    "RAID Volume @ id %d\n", device->id));
 		}
@@ -2199,6 +2135,12 @@ mptscsih_slave_alloc(struct scsi_device 
 	vdev->num_luns++;
 	device->hostdata = vdev;
 	return 0;
+ out_free:
+	dev_printk(KERN_ERR, &device->sdev_gendev, "failed to allocate vdev\n");
+	if (vdev)
+		kfree(vdev->raidVolume);
+	kfree(vdev);
+	return -EINVAL;
 }
 
 /*
@@ -2219,13 +2161,15 @@ mptscsih_slave_destroy(struct scsi_devic
 
 	mptscsih_search_running_cmds(hd, target, lun);
 
-	vdev = hd->Targets[target];
+	vdev = mpt_target(hd, device->channel, target);
 	vdev->luns[0] &= ~(1 << lun);
 	if (--vdev->num_luns)
 		return;
 
-	kfree(hd->Targets[target]);
-	hd->Targets[target] = NULL;
+	kfree(vdev->raidVolume);
+
+	kfree(hd->Targets[target + (device->channel * host->max_id)]);
+	hd->Targets[target + (device->channel * host->max_id)] = NULL;
 
 	if (hd->ioc->bus_type == SCSI) {
 		if (mptscsih_is_phys_disk(hd->ioc, target)) {
@@ -2257,10 +2201,11 @@ mptscsih_change_queue_depth(struct scsi_
 	VirtDevice *pTarget;
 	int	max_depth;
 	int	tagged;
+	int	target = sdev->id;
 
 	if (hd == NULL)
 		return 0;
-	if (!(pTarget = hd->Targets[sdev->id]))
+	if (!(pTarget = mpt_target(hd, sdev->channel, target)))
 		return 0;
 
 	if (hd->ioc->bus_type == SCSI) {
@@ -2302,6 +2247,7 @@ mptscsih_slave_configure(struct scsi_dev
 	struct Scsi_Host	*sh = device->host;
 	VirtDevice		*pTarget;
 	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)sh->hostdata;
+	int			target = device->id;
 
 	if ((hd == NULL) || (hd->Targets == NULL)) {
 		return 0;
@@ -2315,13 +2261,13 @@ mptscsih_slave_configure(struct scsi_dev
 		hd->ioc->name, device->sdtr, device->wdtr,
 		device->ppr, device->inquiry_len));
 
-	if (device->id > sh->max_id) {
+	if (target > sh->max_id) {
 		/* error case, should never happen */
 		scsi_adjust_queue_depth(device, 0, 1);
 		goto slave_configure_exit;
 	}
 
-	pTarget = hd->Targets[device->id];
+	pTarget = mpt_target(hd, device->channel, target);
 
 	if (pTarget == NULL) {
 		/* Driver doesn't know about this device.
@@ -2337,7 +2283,7 @@ mptscsih_slave_configure(struct scsi_dev
 		goto slave_configure_exit;
 	}
 
-	mptscsih_initTarget(hd, device->channel, device->id, device->lun,
+	mptscsih_initTarget(hd, device->channel, target, device->lun,
 		device->inquiry, device->inquiry_len );
 	mptscsih_change_queue_depth(device, MPT_SCSI_CMD_PER_DEV_HIGH);
 
@@ -2508,7 +2454,7 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
 		/* 4. Renegotiate to all devices, if SCSI
 		 */
 		if (ioc->bus_type == SCSI) {
-			dnegoprintk(("writeSDP1: ALL_IDS USE_NVRAM\n"));
+			printk("writeSDP1: ALL_IDS USE_NVRAM\n");
 			mptscsih_writeSDP1(hd, 0, 0, MPT_SCSICFG_ALL_IDS | MPT_SCSICFG_USE_NVRAM);
 		}
 
@@ -2598,24 +2544,6 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
 		break;
 
 	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */
-	{
-		pMpiEventDataRaid_t pRaidEventData =
-		    (pMpiEventDataRaid_t) pEvReply->Data;
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-		/* Domain Validation Needed */
-		if (ioc->bus_type == SCSI &&
-		    pRaidEventData->ReasonCode ==
-		    MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED)
-			mptscsih_set_dvflags_raid(hd, pRaidEventData->PhysDiskNum);
-#endif
-		break;
-	}
-
-	/* Persistent table is full. */
-	case MPI_EVENT_PERSISTENT_TABLE_FULL:
-		INIT_WORK(&mptscsih_persistTask,
-		    mptscsih_sas_persist_clear_table,(void *)ioc);
-		schedule_work(&mptscsih_persistTask);
 		break;
 
 	case MPI_EVENT_NONE:				/* 00 */
@@ -2676,7 +2604,7 @@ mptscsih_initTarget(MPT_SCSI_HOST *hd, i
 	if (data[0] & 0xe0)
 		return;
 
-	if ((vdev = hd->Targets[target_id]) == NULL) {
+	if ((vdev = mpt_target(hd, bus_id, target_id)) == NULL) {
 		return;
 	}
 
@@ -2732,7 +2660,6 @@ mptscsih_initTarget(MPT_SCSI_HOST *hd, i
 					vdev->tflags |= MPT_TARGET_FLAGS_VALID_56;
 				}
 			}
-			mptscsih_setTargetNegoParms(hd, vdev, data_56);
 		} else {
 			/* Initial Inquiry may not request enough data bytes to
 			 * obtain byte 57.  DV will; if target doesn't return
@@ -2743,232 +2670,10 @@ mptscsih_initTarget(MPT_SCSI_HOST *hd, i
 				 */
 					data_56 = data[56];
 					vdev->tflags |= MPT_TARGET_FLAGS_VALID_56;
-					mptscsih_setTargetNegoParms(hd, vdev, data_56);
-				}
-			}
-		}
-	}
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *  Update the target negotiation parameters based on the
- *  the Inquiry data, adapter capabilities, and NVRAM settings.
- *
- */
-static void
-mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56)
-{
-	SpiCfgData *pspi_data = &hd->ioc->spi_data;
-	int  id = (int) target->target_id;
-	int  nvram;
-	VirtDevice	*vdev;
-	int ii;
-	u8 width = MPT_NARROW;
-	u8 factor = MPT_ASYNC;
-	u8 offset = 0;
-	u8 version, nfactor;
-	u8 noQas = 1;
-
-	target->negoFlags = pspi_data->noQas;
-
-	/* noQas == 0 => device supports QAS. Need byte 56 of Inq to determine
-	 * support. If available, default QAS to off and allow enabling.
-	 * If not available, default QAS to on, turn off for non-disks.
-	 */
-
-	/* Set flags based on Inquiry data
-	 */
-	version = target->inq_data[2] & 0x07;
-	if (version < 2) {
-		width = 0;
-		factor = MPT_ULTRA2;
-		offset = pspi_data->maxSyncOffset;
-		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
-	} else {
-		if (target->inq_data[7] & 0x20) {
-			width = 1;
-		}
-
-		if (target->inq_data[7] & 0x10) {
-			factor = pspi_data->minSyncFactor;
-			if (target->tflags & MPT_TARGET_FLAGS_VALID_56) {
-				/* bits 2 & 3 show Clocking support */
-				if ((byte56 & 0x0C) == 0)
-					factor = MPT_ULTRA2;
-				else {
-					if ((byte56 & 0x03) == 0)
-						factor = MPT_ULTRA160;
-					else {
-						factor = MPT_ULTRA320;
-						if (byte56 & 0x02)
-						{
-							ddvtprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", byte56, id));
-							noQas = 0;
-						}
-						if (target->inq_data[0] == TYPE_TAPE) {
-							if (byte56 & 0x01)
-								target->negoFlags |= MPT_TAPE_NEGO_IDP;
-						}
-					}
-				}
-			} else {
-				ddvtprintk((KERN_INFO "Enabling QAS on id=%d due to ~TARGET_FLAGS_VALID_56!\n", id));
-				noQas = 0;
-			}
-
-			offset = pspi_data->maxSyncOffset;
-
-			/* If RAID, never disable QAS
-			 * else if non RAID, do not disable
-			 *   QAS if bit 1 is set
-			 * bit 1 QAS support, non-raid only
-			 * bit 0 IU support
-			 */
-			if (target->raidVolume == 1) {
-				noQas = 0;
-			}
-		} else {
-			factor = MPT_ASYNC;
-			offset = 0;
-		}
-	}
-
-	if ( (target->inq_data[7] & 0x02) == 0) {
-		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
-	}
-
-	/* Update tflags based on NVRAM settings. (SCSI only)
-	 */
-	if (pspi_data->nvram && (pspi_data->nvram[id] != MPT_HOST_NVRAM_INVALID)) {
-		nvram = pspi_data->nvram[id];
-		nfactor = (nvram & MPT_NVRAM_SYNC_MASK) >> 8;
-
-		if (width)
-			width = nvram & MPT_NVRAM_WIDE_DISABLE ? 0 : 1;
-
-		if (offset > 0) {
-			/* Ensure factor is set to the
-			 * maximum of: adapter, nvram, inquiry
-			 */
-			if (nfactor) {
-				if (nfactor < pspi_data->minSyncFactor )
-					nfactor = pspi_data->minSyncFactor;
-
-				factor = max(factor, nfactor);
-				if (factor == MPT_ASYNC)
-					offset = 0;
-			} else {
-				offset = 0;
-				factor = MPT_ASYNC;
-		}
-		} else {
-			factor = MPT_ASYNC;
-		}
-	}
-
-	/* Make sure data is consistent
-	 */
-	if ((!width) && (factor < MPT_ULTRA2)) {
-		factor = MPT_ULTRA2;
-	}
-
-	/* Save the data to the target structure.
-	 */
-	target->minSyncFactor = factor;
-	target->maxOffset = offset;
-	target->maxWidth = width;
-
-	target->tflags |= MPT_TARGET_FLAGS_VALID_NEGO;
-
-	/* Disable unused features.
-	 */
-	if (!width)
-		target->negoFlags |= MPT_TARGET_NO_NEGO_WIDE;
-
-	if (!offset)
-		target->negoFlags |= MPT_TARGET_NO_NEGO_SYNC;
-
-	if ( factor > MPT_ULTRA320 )
-		noQas = 0;
-
-	/* GEM, processor WORKAROUND
-	 */
-	if ((target->inq_data[0] == TYPE_PROCESSOR) || (target->inq_data[0] > 0x08)) {
-		target->negoFlags |= (MPT_TARGET_NO_NEGO_WIDE | MPT_TARGET_NO_NEGO_SYNC);
-		pspi_data->dvStatus[id] |= MPT_SCSICFG_BLK_NEGO;
-	} else {
-		if (noQas && (pspi_data->noQas == 0)) {
-			pspi_data->noQas |= MPT_TARGET_NO_NEGO_QAS;
-			target->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
-
-			/* Disable QAS in a mixed configuration case
-	 		*/
-
-			ddvtprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
-			for (ii = 0; ii < id; ii++) {
-				if ( (vdev = hd->Targets[ii]) ) {
-					vdev->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
-					mptscsih_writeSDP1(hd, 0, ii, vdev->negoFlags);
 				}
 			}
 		}
 	}
-
-	/* Write SDP1 on this I/O to this target */
-	if (pspi_data->dvStatus[id] & MPT_SCSICFG_NEGOTIATE) {
-		ddvtprintk((KERN_INFO "MPT_SCSICFG_NEGOTIATE on id=%d!\n", id));
-		mptscsih_writeSDP1(hd, 0, id, hd->negoNvram);
-		pspi_data->dvStatus[id] &= ~MPT_SCSICFG_NEGOTIATE;
-	} else if (pspi_data->dvStatus[id] & MPT_SCSICFG_BLK_NEGO) {
-		ddvtprintk((KERN_INFO "MPT_SCSICFG_BLK_NEGO on id=%d!\n", id));
-		mptscsih_writeSDP1(hd, 0, id, MPT_SCSICFG_BLK_NEGO);
-		pspi_data->dvStatus[id] &= ~MPT_SCSICFG_BLK_NEGO;
-	}
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* If DV disabled (negoNvram set to USE_NVARM) or if not LUN 0, return.
- * Else set the NEED_DV flag after Read Capacity Issued (disks)
- * or Mode Sense (cdroms).
- *
- * Tapes, initTarget will set this flag on completion of Inquiry command.
- * Called only if DV_NOT_DONE flag is set
- */
-static void
-mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq)
-{
-	MPT_ADAPTER	*ioc = hd->ioc;
-	u8 cmd;
-	SpiCfgData	*pSpi;
-
-	ddvtprintk((MYIOC_s_NOTE_FMT
-		" set_dvflags: id=%d lun=%d negoNvram=%x cmd=%x\n",
-		hd->ioc->name, pReq->TargetID, pReq->LUN[1], hd->negoNvram, pReq->CDB[0]));
-
-	if ((pReq->LUN[1] != 0) || (hd->negoNvram != 0))
-		return;
-
-	cmd = pReq->CDB[0];
-
-	if ((cmd == READ_CAPACITY) || (cmd == MODE_SENSE)) {
-		pSpi = &ioc->spi_data;
-		if ((ioc->raid_data.isRaid & (1 << pReq->TargetID)) && ioc->raid_data.pIocPg3) {
-			/* Set NEED_DV for all hidden disks
-			 */
-			Ioc3PhysDisk_t *pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
-			int		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
-
-			while (numPDisk) {
-				pSpi->dvStatus[pPDisk->PhysDiskID] |= MPT_SCSICFG_NEED_DV;
-				ddvtprintk(("NEED_DV set for phys disk id %d\n", pPDisk->PhysDiskID));
-				pPDisk++;
-				numPDisk--;
-			}
-		}
-		pSpi->dvStatus[pReq->TargetID] |= MPT_SCSICFG_NEED_DV;
-		ddvtprintk(("NEED_DV set for visible disk id %d\n", pReq->TargetID));
-	}
 }
 
 /* mptscsih_raid_set_dv_flags()
@@ -3189,17 +2894,6 @@ mptscsih_writeSDP1(MPT_SCSI_HOST *hd, in
 			negoFlags = pTarget->negoFlags;
 		}
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-		/* Force to async and narrow if DV has not been executed
-		 * for this ID
-		 */
-		if ((hd->ioc->spi_data.dvStatus[id] & MPT_SCSICFG_DV_NOT_DONE) != 0) {
-			width = 0;
-			factor = MPT_ASYNC;
-			offset = 0;
-		}
-#endif
-
 		if (flags & MPT_SCSICFG_BLK_NEGO)
 			negoFlags |= MPT_TARGET_NO_NEGO_WIDE | MPT_TARGET_NO_NEGO_SYNC;
 
@@ -3216,8 +2910,8 @@ mptscsih_writeSDP1(MPT_SCSI_HOST *hd, in
 			return -EAGAIN;
 		}
 
-		ddvprintk((MYIOC_s_INFO_FMT "WriteSDP1 (mf=%p, id=%d, req=0x%x, cfg=0x%x)\n",
-			hd->ioc->name, mf, id, requested, configuration));
+		printk(MYIOC_s_INFO_FMT "WriteSDP1 (mf=%p, id=%d, req=0x%x, cfg=0x%x)\n",
+			hd->ioc->name, mf, id, requested, configuration);
 
 
 		/* Set the request and the data pointers.
@@ -3414,7 +3108,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 			hd->ioc->name, mf, mr, req_idx));
 
 	hd->pLocal = &hd->localReply;
-	hd->pLocal->scsiStatus = 0;
+	hd->pLocal->u.s.scsiStatus = 0;
 
 	/* If target struct exists, clear sense valid flag.
 	 */
@@ -3468,6 +3162,9 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 					completionCode = MPT_SCANDV_GOOD;
 				else
 					completionCode = MPT_SCANDV_SOME_ERROR;
+				memcpy(hd->pLocal->u.r, pr,
+				       min((size_t)pr->MsgLength*4,
+					   sizeof(hd->pLocal->u.r)));
 
 			} else if (pReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID) {
 				u8		*sense_data;
@@ -3476,13 +3173,13 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 				/* save sense data in global structure
 				 */
 				completionCode = MPT_SCANDV_SENSE;
-				hd->pLocal->scsiStatus = scsi_status;
+				hd->pLocal->u.s.scsiStatus = scsi_status;
 				sense_data = ((u8 *)hd->ioc->sense_buf_pool +
 					(req_idx * MPT_SENSE_BUFFER_ALLOC));
 
 				sz = min_t(int, pReq->SenseBufferLength,
 							SCSI_STD_SENSE_BYTES);
-				memcpy(hd->pLocal->sense, sense_data, sz);
+				memcpy(hd->pLocal->u.s.sense, sense_data, sz);
 
 				ddvprintk((KERN_NOTICE "  Check Condition, sense ptr %p\n",
 						sense_data));
@@ -3498,7 +3195,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 				completionCode = MPT_SCANDV_DID_RESET;
 			else {
 				completionCode = MPT_SCANDV_GOOD;
-				hd->pLocal->scsiStatus = scsi_status;
+				hd->pLocal->u.s.scsiStatus = scsi_status;
 			}
 			break;
 
@@ -3581,78 +3278,6 @@ mptscsih_timer_expired(unsigned long dat
 	return;
 }
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*	mptscsih_do_raid - Format and Issue a RAID volume request message.
- *	@hd: Pointer to scsi host structure
- *	@action: What do be done.
- *	@id: Logical target id.
- *	@bus: Target locations bus.
- *
- *	Returns: < 0 on a fatal error
- *		0 on success
- *
- *	Remark: Wait to return until reply processed by the ISR.
- */
-static int
-mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD *io)
-{
-	MpiRaidActionRequest_t	*pReq;
-	MPT_FRAME_HDR		*mf;
-	int			in_isr;
-
-	in_isr = in_interrupt();
-	if (in_isr) {
-		dprintk((MYIOC_s_WARN_FMT "Internal raid request not allowed in ISR context!\n",
-       				hd->ioc->name));
-		return -EPERM;
-	}
-
-	/* Get and Populate a free Frame
-	 */
-	if ((mf = mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) == NULL) {
-		ddvprintk((MYIOC_s_WARN_FMT "_do_raid: no msg frames!\n",
-					hd->ioc->name));
-		return -EAGAIN;
-	}
-	pReq = (MpiRaidActionRequest_t *)mf;
-	pReq->Action = action;
-	pReq->Reserved1 = 0;
-	pReq->ChainOffset = 0;
-	pReq->Function = MPI_FUNCTION_RAID_ACTION;
-	pReq->VolumeID = io->id;
-	pReq->VolumeBus = io->bus;
-	pReq->PhysDiskNum = io->physDiskNum;
-	pReq->MsgFlags = 0;
-	pReq->Reserved2 = 0;
-	pReq->ActionDataWord = 0; /* Reserved for this action */
-	//pReq->ActionDataSGE = 0;
-
-	mpt_add_sge((char *)&pReq->ActionDataSGE,
-		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
-
-	ddvprintk((MYIOC_s_INFO_FMT "RAID Volume action %x id %d\n",
-			hd->ioc->name, action, io->id));
-
-	hd->pLocal = NULL;
-	hd->timer.expires = jiffies + HZ*10; /* 10 second timeout */
-	hd->scandv_wait_done = 0;
-
-	/* Save cmd pointer, for resource free if timeout or
-	 * FW reload occurs
-	 */
-	hd->cmdPtr = mf;
-
-	add_timer(&hd->timer);
-	mpt_put_msg_frame(hd->ioc->InternalCtx, hd->ioc, mf);
-	wait_event(hd->scandv_waitq, hd->scandv_wait_done);
-
-	if ((hd->pLocal == NULL) || (hd->pLocal->completion != MPT_SCANDV_GOOD))
-		return -1;
-
-	return 0;
-}
-#endif /* ~MPTSCSIH_ENABLE_DOMAIN_VALIDATION */
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
@@ -3886,7 +3511,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 
 	if (hd->pLocal) {
 		rc = hd->pLocal->completion;
-		hd->pLocal->skip = 0;
+		hd->pLocal->u.s.skip = 0;
 
 		/* Always set fatal error codes in some cases.
 		 */
@@ -4054,151 +3679,6 @@ mptscsih_synchronize_cache(MPT_SCSI_HOST
 	return 0;
 }
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_domainValidation - Top level handler for domain validation.
- *	@hd: Pointer to MPT_SCSI_HOST structure.
- *
- *	Uses the ISR, but with special processing.
- *	Called from schedule, should not be in interrupt mode.
- *	While thread alive, do dv for all devices needing dv
- *
- *	Return: None.
- */
-static void
-mptscsih_domainValidation(void *arg)
-{
-	MPT_SCSI_HOST		*hd;
-	MPT_ADAPTER		*ioc;
-	unsigned long		 flags;
-	int 			 id, maxid, dvStatus, did;
-	int			 ii, isPhysDisk;
-
-	spin_lock_irqsave(&dvtaskQ_lock, flags);
-	dvtaskQ_active = 1;
-	if (dvtaskQ_release) {
-		dvtaskQ_active = 0;
-		spin_unlock_irqrestore(&dvtaskQ_lock, flags);
-		return;
-	}
-	spin_unlock_irqrestore(&dvtaskQ_lock, flags);
-
-	/* For this ioc, loop through all devices and do dv to each device.
-	 * When complete with this ioc, search through the ioc list, and
-	 * for each scsi ioc found, do dv for all devices. Exit when no
-	 * device needs dv.
-	 */
-	did = 1;
-	while (did) {
-		did = 0;
-		list_for_each_entry(ioc, &ioc_list, list) {
-			spin_lock_irqsave(&dvtaskQ_lock, flags);
-			if (dvtaskQ_release) {
-				dvtaskQ_active = 0;
-				spin_unlock_irqrestore(&dvtaskQ_lock, flags);
-				return;
-			}
-			spin_unlock_irqrestore(&dvtaskQ_lock, flags);
-
-			msleep(250);
-
-			/* DV only to SCSI adapters */
-			if (ioc->bus_type != SCSI)
-				continue;
-
-			/* Make sure everything looks ok */
-			if (ioc->sh == NULL)
-				continue;
-
-			hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
-			if (hd == NULL)
-				continue;
-
-			if ((ioc->spi_data.forceDv & MPT_SCSICFG_RELOAD_IOC_PG3) != 0) {
-				mpt_read_ioc_pg_3(ioc);
-				if (ioc->raid_data.pIocPg3) {
-					Ioc3PhysDisk_t *pPDisk = ioc->raid_data.pIocPg3->PhysDisk;
-					int		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
-
-					while (numPDisk) {
-						if (ioc->spi_data.dvStatus[pPDisk->PhysDiskID] & MPT_SCSICFG_DV_NOT_DONE)
-							ioc->spi_data.dvStatus[pPDisk->PhysDiskID] |= MPT_SCSICFG_NEED_DV;
-
-						pPDisk++;
-						numPDisk--;
-					}
-				}
-				ioc->spi_data.forceDv &= ~MPT_SCSICFG_RELOAD_IOC_PG3;
-			}
-
-			maxid = min_t(int, ioc->sh->max_id, MPT_MAX_SCSI_DEVICES);
-
-			for (id = 0; id < maxid; id++) {
-				spin_lock_irqsave(&dvtaskQ_lock, flags);
-				if (dvtaskQ_release) {
-					dvtaskQ_active = 0;
-					spin_unlock_irqrestore(&dvtaskQ_lock, flags);
-					return;
-				}
-				spin_unlock_irqrestore(&dvtaskQ_lock, flags);
-				dvStatus = hd->ioc->spi_data.dvStatus[id];
-
-				if (dvStatus & MPT_SCSICFG_NEED_DV) {
-					did++;
-					hd->ioc->spi_data.dvStatus[id] |= MPT_SCSICFG_DV_PENDING;
-					hd->ioc->spi_data.dvStatus[id] &= ~MPT_SCSICFG_NEED_DV;
-
-					msleep(250);
-
-					/* If hidden phys disk, block IO's to all
-					 *	raid volumes
-					 * else, process normally
-					 */
-					isPhysDisk = mptscsih_is_phys_disk(ioc, id);
-					if (isPhysDisk) {
-						for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
-							if (hd->ioc->raid_data.isRaid & (1 << ii)) {
-								hd->ioc->spi_data.dvStatus[ii] |= MPT_SCSICFG_DV_PENDING;
-							}
-						}
-					}
-
-					if (mptscsih_doDv(hd, 0, id) == 1) {
-						/* Untagged device was busy, try again
-						 */
-						hd->ioc->spi_data.dvStatus[id] |= MPT_SCSICFG_NEED_DV;
-						hd->ioc->spi_data.dvStatus[id] &= ~MPT_SCSICFG_DV_PENDING;
-					} else {
-						/* DV is complete. Clear flags.
-						 */
-						hd->ioc->spi_data.dvStatus[id] &= ~(MPT_SCSICFG_DV_NOT_DONE | MPT_SCSICFG_DV_PENDING);
-					}
-
-					if (isPhysDisk) {
-						for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
-							if (hd->ioc->raid_data.isRaid & (1 << ii)) {
-								hd->ioc->spi_data.dvStatus[ii] &= ~MPT_SCSICFG_DV_PENDING;
-							}
-						}
-					}
-
-					if (hd->ioc->spi_data.noQas)
-						mptscsih_qas_check(hd, id);
-				}
-			}
-		}
-	}
-
-	spin_lock_irqsave(&dvtaskQ_lock, flags);
-	dvtaskQ_active = 0;
-	spin_unlock_irqrestore(&dvtaskQ_lock, flags);
-
-	return;
-}
-
-/* Search IOC page 3 to determine if this is hidden physical disk
- */
 /* Search IOC page 3 to determine if this is hidden physical disk
  */
 static int
@@ -4217,1370 +3697,153 @@ mptscsih_is_phys_disk(MPT_ADAPTER *ioc, 
 	return 0;
 }
 
-/* Write SDP1 if no QAS has been enabled
- */
-static void
-mptscsih_qas_check(MPT_SCSI_HOST *hd, int id)
+int
+mptscsih_raid_action(MPT_SCSI_HOST *hd, int action, int volume, int volbus,
+		     MpiRaidActionReply_t *pRep, int repLen)
 {
-	VirtDevice *pTarget;
-	int ii;
-
-	if (hd->Targets == NULL)
-		return;
-
-	for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
-		if (ii == id)
-			continue;
-
-		if ((hd->ioc->spi_data.dvStatus[ii] & MPT_SCSICFG_DV_NOT_DONE) != 0)
-			continue;
+	MpiRaidActionRequest_t	*pReq;
+	MPT_FRAME_HDR		*mf;
 
-		pTarget = hd->Targets[ii];
-
-		if ((pTarget != NULL) && (!pTarget->raidVolume)) {
-			if ((pTarget->negoFlags & hd->ioc->spi_data.noQas) == 0) {
-				pTarget->negoFlags |= hd->ioc->spi_data.noQas;
-				dnegoprintk(("writeSDP1: id=%d flags=0\n", id));
-				mptscsih_writeSDP1(hd, 0, ii, 0);
-			}
-		} else {
-			if (mptscsih_is_phys_disk(hd->ioc, ii) == 1) {
-				dnegoprintk(("writeSDP1: id=%d SCSICFG_USE_NVRAM\n", id));
-				mptscsih_writeSDP1(hd, 0, ii, MPT_SCSICFG_USE_NVRAM);
-			}
-		}
-	}
-	return;
-}
-
-
-
-#define MPT_GET_NVRAM_VALS	0x01
-#define MPT_UPDATE_MAX		0x02
-#define MPT_SET_MAX		0x04
-#define MPT_SET_MIN		0x08
-#define MPT_FALLBACK		0x10
-#define MPT_SAVE		0x20
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_doDv - Perform domain validation to a target.
- *	@hd: Pointer to MPT_SCSI_HOST structure.
- *	@portnum: IOC port number.
- *	@target: Physical ID of this target
- *
- *	Uses the ISR, but with special processing.
- *	MUST be single-threaded.
- *	Test will exit if target is at async & narrow.
- *
- *	Return: None.
- */
-static int
-mptscsih_doDv(MPT_SCSI_HOST *hd, int bus_number, int id)
-{
-	MPT_ADAPTER		*ioc = hd->ioc;
-	VirtDevice		*pTarget;
-	SCSIDevicePage1_t	*pcfg1Data;
-	SCSIDevicePage0_t	*pcfg0Data;
-	u8			*pbuf1;
-	u8			*pbuf2;
-	u8			*pDvBuf;
-	dma_addr_t		 dvbuf_dma = -1;
-	dma_addr_t		 buf1_dma = -1;
-	dma_addr_t		 buf2_dma = -1;
-	dma_addr_t		 cfg1_dma_addr = -1;
-	dma_addr_t		 cfg0_dma_addr = -1;
-	ConfigPageHeader_t	 header1;
-	ConfigPageHeader_t	 header0;
-	DVPARAMETERS		 dv;
-	INTERNAL_CMD		 iocmd;
-	CONFIGPARMS		 cfg;
-	int			 dv_alloc = 0;
-	int			 rc, sz = 0;
-	int			 bufsize = 0;
-	int			 dataBufSize = 0;
-	int			 echoBufSize = 0;
-	int			 notDone;
-	int			 patt;
-	int			 repeat;
-	int			 retcode = 0;
-	int			 nfactor =  MPT_ULTRA320;
-	char			 firstPass = 1;
-	char			 doFallback = 0;
-	char			 readPage0;
-	char			 bus, lun;
-	char			 inq0 = 0;
-
-	if (ioc->spi_data.sdp1length == 0)
-		return 0;
-
-	if (ioc->spi_data.sdp0length == 0)
-		return 0;
-
-	/* If multiple buses are used, require that the initiator
-	 * id be the same on all buses.
-	 */
-	if (id == ioc->pfacts[0].PortSCSIID)
-		return 0;
-
-	lun = 0;
-	bus = (u8) bus_number;
-	ddvtprintk((MYIOC_s_NOTE_FMT
-			"DV started: bus=%d, id=%d dv @ %p\n",
-			ioc->name, bus, id, &dv));
-
-	/* Prep DV structure
-	 */
-	memset (&dv, 0, sizeof(DVPARAMETERS));
-	dv.id = id;
-
-	/* Populate tmax with the current maximum
-	 * transfer parameters for this target.
-	 * Exit if narrow and async.
-	 */
-	dv.cmd = MPT_GET_NVRAM_VALS;
-	mptscsih_dv_parms(hd, &dv, NULL);
-
-	/* Prep SCSI IO structure
-	 */
-	iocmd.id = id;
-	iocmd.bus = bus;
-	iocmd.lun = lun;
-	iocmd.flags = 0;
-	iocmd.physDiskNum = -1;
-	iocmd.rsvd = iocmd.rsvd2 = 0;
-
-	pTarget = hd->Targets[id];
-
-	/* Use tagged commands if possible.
-	 */
-	if (pTarget) {
-		if (pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)
-			iocmd.flags |= MPT_ICFLAG_TAGGED_CMD;
-		else {
-			if (hd->ioc->facts.FWVersion.Word < 0x01000600)
-				return 0;
-
-			if ((hd->ioc->facts.FWVersion.Word >= 0x01010000) &&
-				(hd->ioc->facts.FWVersion.Word < 0x01010B00))
-				return 0;
-		}
-	}
-
-	/* Prep cfg structure
-	 */
-	cfg.pageAddr = (bus<<8) | id;
-	cfg.cfghdr.hdr = NULL;
-
-	/* Prep SDP0 header
-	 */
-	header0.PageVersion = ioc->spi_data.sdp0version;
-	header0.PageLength = ioc->spi_data.sdp0length;
-	header0.PageNumber = 0;
-	header0.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
-
-	/* Prep SDP1 header
-	 */
-	header1.PageVersion = ioc->spi_data.sdp1version;
-	header1.PageLength = ioc->spi_data.sdp1length;
-	header1.PageNumber = 1;
-	header1.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
-
-	if (header0.PageLength & 1)
-		dv_alloc = (header0.PageLength * 4) + 4;
-
-	dv_alloc +=  (2048 + (header1.PageLength * 4));
-
-	pDvBuf = pci_alloc_consistent(ioc->pcidev, dv_alloc, &dvbuf_dma);
-	if (pDvBuf == NULL)
-		return 0;
-
-	sz = 0;
-	pbuf1 = (u8 *)pDvBuf;
-	buf1_dma = dvbuf_dma;
-	sz +=1024;
-
-	pbuf2 = (u8 *) (pDvBuf + sz);
-	buf2_dma = dvbuf_dma + sz;
-	sz +=1024;
-
-	pcfg0Data = (SCSIDevicePage0_t *) (pDvBuf + sz);
-	cfg0_dma_addr = dvbuf_dma + sz;
-	sz += header0.PageLength * 4;
-
-	/* 8-byte alignment
-	 */
-	if (header0.PageLength & 1)
-		sz += 4;
-
-	pcfg1Data = (SCSIDevicePage1_t *) (pDvBuf + sz);
-	cfg1_dma_addr = dvbuf_dma + sz;
-
-	/* Skip this ID? Set cfg.cfghdr.hdr to force config page write
+	/* Get and Populate a free Frame
 	 */
-	{
-		SpiCfgData *pspi_data = &hd->ioc->spi_data;
-		if (pspi_data->nvram && (pspi_data->nvram[id] != MPT_HOST_NVRAM_INVALID)) {
-			/* Set the factor from nvram */
-			nfactor = (pspi_data->nvram[id] & MPT_NVRAM_SYNC_MASK) >> 8;
-			if (nfactor < pspi_data->minSyncFactor )
-				nfactor = pspi_data->minSyncFactor;
-
-			if (!(pspi_data->nvram[id] & MPT_NVRAM_ID_SCAN_ENABLE) ||
-				(pspi_data->PortFlags == MPI_SCSIPORTPAGE2_PORT_FLAGS_OFF_DV) ) {
-
-				ddvprintk((MYIOC_s_NOTE_FMT "DV Skipped: bus, id, lun (%d, %d, %d)\n",
-					ioc->name, bus, id, lun));
-
-				dv.cmd = MPT_SET_MAX;
-				mptscsih_dv_parms(hd, &dv, (void *)pcfg1Data);
-				cfg.cfghdr.hdr = &header1;
-
-				/* Save the final negotiated settings to
-				 * SCSI device page 1.
-				 */
-				cfg.physAddr = cfg1_dma_addr;
-				cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-				cfg.dir = 1;
-				mpt_config(hd->ioc, &cfg);
-				goto target_done;
-			}
-		}
-	}
-
-	/* Finish iocmd inititialization - hidden or visible disk? */
-	if (ioc->raid_data.pIocPg3) {
-		/* Search IOC page 3 for matching id
-		 */
-		Ioc3PhysDisk_t *pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
-		int		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
-
-		while (numPDisk) {
-			if (pPDisk->PhysDiskID == id) {
-				/* match */
-				iocmd.flags |= MPT_ICFLAG_PHYS_DISK;
-				iocmd.physDiskNum = pPDisk->PhysDiskNum;
-
-				/* Quiesce the IM
-				 */
-				if (mptscsih_do_raid(hd, MPI_RAID_ACTION_QUIESCE_PHYS_IO, &iocmd) < 0) {
-					ddvprintk((MYIOC_s_ERR_FMT "RAID Queisce FAILED!\n", ioc->name));
-					goto target_done;
-				}
-				break;
-			}
-			pPDisk++;
-			numPDisk--;
-		}
+	if ((mf = mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) == NULL) {
+		ddvprintk((MYIOC_s_WARN_FMT "_do_raid: no msg frames!\n",
+					hd->ioc->name));
+		return -EAGAIN;
 	}
+	pReq = (MpiRaidActionRequest_t *)mf;
+	pReq->Action = action;
+	pReq->Reserved1 = 0;
+	pReq->ChainOffset = 0;
+	pReq->Function = MPI_FUNCTION_RAID_ACTION;
+	pReq->VolumeID = volume;
+	pReq->VolumeBus = volbus;
+	pReq->PhysDiskNum = 0;
+	pReq->MsgFlags = 0;
+	pReq->Reserved2 = 0;
+	pReq->ActionDataWord = 0; /* Reserved for this action */
 
-	/* RAID Volume ID's may double for a physical device. If RAID but
-	 * not a physical ID as well, skip DV.
-	 */
-	if ((hd->ioc->raid_data.isRaid & (1 << id)) && !(iocmd.flags & MPT_ICFLAG_PHYS_DISK))
-		goto target_done;
+	mpt_add_sge((char *)&pReq->ActionDataSGE,
+		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
 
+	ddvprintk((MYIOC_s_INFO_FMT "RAID Volume action %x id %d\n",
+			hd->ioc->name, action, io->id));
 
-	/* Basic Test.
-	 * Async & Narrow - Inquiry
-	 * Async & Narrow - Inquiry
-	 * Maximum transfer rate - Inquiry
-	 * Compare buffers:
-	 *	If compare, test complete.
-	 *	If miscompare and first pass, repeat
-	 *	If miscompare and not first pass, fall back and repeat
-	 */
 	hd->pLocal = NULL;
-	readPage0 = 0;
-	sz = SCSI_MAX_INQUIRY_BYTES;
-	rc = MPT_SCANDV_GOOD;
-	while (1) {
-		ddvprintk((MYIOC_s_NOTE_FMT "DV: Start Basic test on id=%d\n", ioc->name, id));
-		retcode = 0;
-		dv.cmd = MPT_SET_MIN;
-		mptscsih_dv_parms(hd, &dv, (void *)pcfg1Data);
-
-		cfg.cfghdr.hdr = &header1;
-		cfg.physAddr = cfg1_dma_addr;
-		cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-		cfg.dir = 1;
-		if (mpt_config(hd->ioc, &cfg) != 0)
-			goto target_done;
-
-		/* Wide - narrow - wide workaround case
-		 */
-		if ((rc == MPT_SCANDV_ISSUE_SENSE) && dv.max.width) {
-			/* Send an untagged command to reset disk Qs corrupted
-			 * when a parity error occurs on a Request Sense.
-			 */
-			if ((hd->ioc->facts.FWVersion.Word >= 0x01000600) ||
-				((hd->ioc->facts.FWVersion.Word >= 0x01010000) &&
-				(hd->ioc->facts.FWVersion.Word < 0x01010B00)) ) {
-
-				iocmd.cmd = REQUEST_SENSE;
-				iocmd.data_dma = buf1_dma;
-				iocmd.data = pbuf1;
-				iocmd.size = 0x12;
-				if (mptscsih_do_cmd(hd, &iocmd) < 0)
-					goto target_done;
-				else {
-					if (hd->pLocal == NULL)
-						goto target_done;
-					rc = hd->pLocal->completion;
-					if ((rc == MPT_SCANDV_GOOD) || (rc == MPT_SCANDV_SENSE)) {
-						dv.max.width = 0;
-						doFallback = 0;
-					} else
-						goto target_done;
-				}
-			} else
-				goto target_done;
-		}
-
-		iocmd.cmd = INQUIRY;
-		iocmd.data_dma = buf1_dma;
-		iocmd.data = pbuf1;
-		iocmd.size = sz;
-		memset(pbuf1, 0x00, sz);
-		if (mptscsih_do_cmd(hd, &iocmd) < 0)
-			goto target_done;
-		else {
-			if (hd->pLocal == NULL)
-				goto target_done;
-			rc = hd->pLocal->completion;
-			if (rc == MPT_SCANDV_GOOD) {
-				if (hd->pLocal->scsiStatus == SAM_STAT_BUSY) {
-					if ((iocmd.flags & MPT_ICFLAG_TAGGED_CMD) == 0)
-						retcode = 1;
-					else
-						retcode = 0;
-
-					goto target_done;
-				}
-			} else if  (rc == MPT_SCANDV_SENSE) {
-				;
-			} else {
-				/* If first command doesn't complete
-				 * with a good status or with a check condition,
-				 * exit.
-				 */
-				goto target_done;
-			}
-		}
-
-		/* Reset the size for disks
-		 */
-		inq0 = (*pbuf1) & 0x1F;
-		if ((inq0 == 0) && pTarget && !pTarget->raidVolume) {
-			sz = 0x40;
-			iocmd.size = sz;
-		}
-
-		/* Another GEM workaround. Check peripheral device type,
-		 * if PROCESSOR, quit DV.
-		 */
-		if (inq0 == TYPE_PROCESSOR) {
-			mptscsih_initTarget(hd,
-				bus,
-				id,
-				lun,
-				pbuf1,
-				sz);
-			goto target_done;
-		}
-
-		if (inq0 > 0x08)
-			goto target_done;
-
-		if (mptscsih_do_cmd(hd, &iocmd) < 0)
-			goto target_done;
-
-		if (sz == 0x40) {
-			if ((pTarget->maxWidth == 1) && (pTarget->maxOffset) && (nfactor < 0x0A)
-				&& (pTarget->minSyncFactor > 0x09)) {
-				if ((pbuf1[56] & 0x04) == 0)
-					;
-				else if ((pbuf1[56] & 0x01) == 1) {
-					pTarget->minSyncFactor =
-					    nfactor > MPT_ULTRA320 ? nfactor : MPT_ULTRA320;
-				} else {
-					pTarget->minSyncFactor =
-					    nfactor > MPT_ULTRA160 ? nfactor : MPT_ULTRA160;
-				}
-
-				dv.max.factor = pTarget->minSyncFactor;
-
-				if ((pbuf1[56] & 0x02) == 0) {
-					pTarget->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
-					hd->ioc->spi_data.noQas = MPT_TARGET_NO_NEGO_QAS;
-					ddvprintk((MYIOC_s_NOTE_FMT
-					    "DV: Start Basic noQas on id=%d due to pbuf1[56]=%x\n",
-					    ioc->name, id, pbuf1[56]));
-				}
-			}
-		}
-
-		if (doFallback)
-			dv.cmd = MPT_FALLBACK;
-		else
-			dv.cmd = MPT_SET_MAX;
-
-		mptscsih_dv_parms(hd, &dv, (void *)pcfg1Data);
-		if (mpt_config(hd->ioc, &cfg) != 0)
-			goto target_done;
-
-		if ((!dv.now.width) && (!dv.now.offset))
-			goto target_done;
-
-		iocmd.cmd = INQUIRY;
-		iocmd.data_dma = buf2_dma;
-		iocmd.data = pbuf2;
-		iocmd.size = sz;
-		memset(pbuf2, 0x00, sz);
-		if (mptscsih_do_cmd(hd, &iocmd) < 0)
-			goto target_done;
-		else if (hd->pLocal == NULL)
-			goto target_done;
-		else {
-			/* Save the return code.
-			 * If this is the first pass,
-			 * read SCSI Device Page 0
-			 * and update the target max parameters.
-			 */
-			rc = hd->pLocal->completion;
-			doFallback = 0;
-			if (rc == MPT_SCANDV_GOOD) {
-				if (!readPage0) {
-					u32 sdp0_info;
-					u32 sdp0_nego;
-
-					cfg.cfghdr.hdr = &header0;
-					cfg.physAddr = cfg0_dma_addr;
-					cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
-					cfg.dir = 0;
-
-					if (mpt_config(hd->ioc, &cfg) != 0)
-						goto target_done;
-
-					sdp0_info = le32_to_cpu(pcfg0Data->Information) & 0x0E;
-					sdp0_nego = (le32_to_cpu(pcfg0Data->NegotiatedParameters) & 0xFF00 ) >> 8;
-
-					/* Quantum and Fujitsu workarounds.
-					 * Quantum: PPR U320 -> PPR reply with Ultra2 and wide
-					 * Fujitsu: PPR U320 -> Msg Reject and Ultra2 and wide
-					 * Resetart with a request for U160.
-					 */
-					if ((dv.now.factor == MPT_ULTRA320) && (sdp0_nego == MPT_ULTRA2)) {
-							doFallback = 1;
-					} else {
-						dv.cmd = MPT_UPDATE_MAX;
-						mptscsih_dv_parms(hd, &dv, (void *)pcfg0Data);
-						/* Update the SCSI device page 1 area
-						 */
-						pcfg1Data->RequestedParameters = pcfg0Data->NegotiatedParameters;
-						readPage0 = 1;
-					}
-				}
-
-				/* Quantum workaround. Restart this test will the fallback
-				 * flag set.
-				 */
-				if (doFallback == 0) {
-					if (memcmp(pbuf1, pbuf2, sz) != 0) {
-						if (!firstPass)
-							doFallback = 1;
-					} else {
-						ddvprintk((MYIOC_s_NOTE_FMT
-						    "DV:Inquiry compared id=%d, calling initTarget\n", ioc->name, id));
-						hd->ioc->spi_data.dvStatus[id] &= ~MPT_SCSICFG_DV_NOT_DONE;
-						mptscsih_initTarget(hd,
-							bus,
-							id,
-							lun,
-							pbuf1,
-							sz);
-						break;	/* test complete */
-					}
-				}
-
-
-			} else if (rc == MPT_SCANDV_ISSUE_SENSE)
-				doFallback = 1;	/* set fallback flag */
-			else if ((rc == MPT_SCANDV_DID_RESET) ||
-				 (rc == MPT_SCANDV_SENSE) ||
-				 (rc == MPT_SCANDV_FALLBACK))
-				doFallback = 1;	/* set fallback flag */
-			else
-				goto target_done;
-
-			firstPass = 0;
-		}
-	}
-	ddvprintk((MYIOC_s_NOTE_FMT "DV: Basic test on id=%d completed OK.\n", ioc->name, id));
-
-	if (ioc->spi_data.mpt_dv == 0)
-		goto target_done;
-
-	inq0 = (*pbuf1) & 0x1F;
-
-	/* Continue only for disks
-	 */
-	if (inq0 != 0)
-		goto target_done;
-
-	if ( ioc->spi_data.PortFlags == MPI_SCSIPORTPAGE2_PORT_FLAGS_BASIC_DV_ONLY )
-		goto target_done;
-
-	/* Start the Enhanced Test.
-	 * 0) issue TUR to clear out check conditions
-	 * 1) read capacity of echo (regular) buffer
-	 * 2) reserve device
-	 * 3) do write-read-compare data pattern test
-	 * 4) release
-	 * 5) update nego parms to target struct
-	 */
-	cfg.cfghdr.hdr = &header1;
-	cfg.physAddr = cfg1_dma_addr;
-	cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	cfg.dir = 1;
-
-	iocmd.cmd = TEST_UNIT_READY;
-	iocmd.data_dma = -1;
-	iocmd.data = NULL;
-	iocmd.size = 0;
-	notDone = 1;
-	while (notDone) {
-		if (mptscsih_do_cmd(hd, &iocmd) < 0)
-			goto target_done;
-
-		if (hd->pLocal == NULL)
-			goto target_done;
-
-		rc = hd->pLocal->completion;
-		if (rc == MPT_SCANDV_GOOD)
-			notDone = 0;
-		else if (rc == MPT_SCANDV_SENSE) {
-			u8 skey = hd->pLocal->sense[2] & 0x0F;
-			u8 asc = hd->pLocal->sense[12];
-			u8 ascq = hd->pLocal->sense[13];
-			ddvprintk((MYIOC_s_INFO_FMT
-				"SenseKey:ASC:ASCQ = (%x:%02x:%02x)\n",
-				ioc->name, skey, asc, ascq));
-
-			if (skey == UNIT_ATTENTION)
-				notDone++; /* repeat */
-			else if ((skey == NOT_READY) &&
-					(asc == 0x04)&&(ascq == 0x01)) {
-				/* wait then repeat */
-				mdelay (2000);
-				notDone++;
-			} else if ((skey == NOT_READY) && (asc == 0x3A)) {
-				/* no medium, try read test anyway */
-				notDone = 0;
-			} else {
-				/* All other errors are fatal.
-				 */
-				ddvprintk((MYIOC_s_INFO_FMT "DV: fatal error.",
-						ioc->name));
-				goto target_done;
-			}
-		} else
-			goto target_done;
-	}
-
-	iocmd.cmd = READ_BUFFER;
-	iocmd.data_dma = buf1_dma;
-	iocmd.data = pbuf1;
-	iocmd.size = 4;
-	iocmd.flags |= MPT_ICFLAG_BUF_CAP;
-
-	dataBufSize = 0;
-	echoBufSize = 0;
-	for (patt = 0; patt < 2; patt++) {
-		if (patt == 0)
-			iocmd.flags |= MPT_ICFLAG_ECHO;
-		else
-			iocmd.flags &= ~MPT_ICFLAG_ECHO;
-
-		notDone = 1;
-		while (notDone) {
-			bufsize = 0;
-
-			/* If not ready after 8 trials,
-			 * give up on this device.
-			 */
-			if (notDone > 8)
-				goto target_done;
-
-			if (mptscsih_do_cmd(hd, &iocmd) < 0)
-				goto target_done;
-			else if (hd->pLocal == NULL)
-				goto target_done;
-			else {
-				rc = hd->pLocal->completion;
-				ddvprintk(("ReadBuffer Comp Code %d", rc));
-				ddvprintk(("  buff: %0x %0x %0x %0x\n",
-					pbuf1[0], pbuf1[1], pbuf1[2], pbuf1[3]));
-
-				if (rc == MPT_SCANDV_GOOD) {
-					notDone = 0;
-					if (iocmd.flags & MPT_ICFLAG_ECHO) {
-						bufsize =  ((pbuf1[2] & 0x1F) <<8) | pbuf1[3];
-						if (pbuf1[0] & 0x01)
-							iocmd.flags |= MPT_ICFLAG_EBOS;
-					} else {
-						bufsize =  pbuf1[1]<<16 | pbuf1[2]<<8 | pbuf1[3];
-					}
-				} else if (rc == MPT_SCANDV_SENSE) {
-					u8 skey = hd->pLocal->sense[2] & 0x0F;
-					u8 asc = hd->pLocal->sense[12];
-					u8 ascq = hd->pLocal->sense[13];
-					ddvprintk((MYIOC_s_INFO_FMT
-						"SenseKey:ASC:ASCQ = (%x:%02x:%02x)\n",
-						ioc->name, skey, asc, ascq));
-					if (skey == ILLEGAL_REQUEST) {
-						notDone = 0;
-					} else if (skey == UNIT_ATTENTION) {
-						notDone++; /* repeat */
-					} else if ((skey == NOT_READY) &&
-						(asc == 0x04)&&(ascq == 0x01)) {
-						/* wait then repeat */
-						mdelay (2000);
-						notDone++;
-					} else {
-						/* All other errors are fatal.
-						 */
-						ddvprintk((MYIOC_s_INFO_FMT "DV: fatal error.",
-							ioc->name));
-						goto target_done;
-					}
-				} else {
-					/* All other errors are fatal
-					 */
-					goto target_done;
-				}
-			}
-		}
-
-		if (iocmd.flags & MPT_ICFLAG_ECHO)
-			echoBufSize = bufsize;
-		else
-			dataBufSize = bufsize;
-	}
-	sz = 0;
-	iocmd.flags &= ~MPT_ICFLAG_BUF_CAP;
-
-	/* Use echo buffers if possible,
-	 * Exit if both buffers are 0.
-	 */
-	if (echoBufSize > 0) {
-		iocmd.flags |= MPT_ICFLAG_ECHO;
-		if (dataBufSize > 0)
-			bufsize = min(echoBufSize, dataBufSize);
-		else
-			bufsize = echoBufSize;
-	} else if (dataBufSize == 0)
-		goto target_done;
-
-	ddvprintk((MYIOC_s_INFO_FMT "%s Buffer Capacity %d\n", ioc->name,
-		(iocmd.flags & MPT_ICFLAG_ECHO) ? "Echo" : " ", bufsize));
-
-	/* Data buffers for write-read-compare test max 1K.
-	 */
-	sz = min(bufsize, 1024);
-
-	/* --- loop ----
-	 * On first pass, always issue a reserve.
-	 * On additional loops, only if a reset has occurred.
-	 * iocmd.flags indicates if echo or regular buffer
-	 */
-	for (patt = 0; patt < 4; patt++) {
-		ddvprintk(("Pattern %d\n", patt));
-		if ((iocmd.flags & MPT_ICFLAG_RESERVED) && (iocmd.flags & MPT_ICFLAG_DID_RESET)) {
-			iocmd.cmd = TEST_UNIT_READY;
-			iocmd.data_dma = -1;
-			iocmd.data = NULL;
-			iocmd.size = 0;
-			if (mptscsih_do_cmd(hd, &iocmd) < 0)
-				goto target_done;
-
-			iocmd.cmd = RELEASE;
-			iocmd.data_dma = -1;
-			iocmd.data = NULL;
-			iocmd.size = 0;
-			if (mptscsih_do_cmd(hd, &iocmd) < 0)
-				goto target_done;
-			else if (hd->pLocal == NULL)
-				goto target_done;
-			else {
-				rc = hd->pLocal->completion;
-				ddvprintk(("Release rc %d\n", rc));
-				if (rc == MPT_SCANDV_GOOD)
-					iocmd.flags &= ~MPT_ICFLAG_RESERVED;
-				else
-					goto target_done;
-			}
-			iocmd.flags &= ~MPT_ICFLAG_RESERVED;
-		}
-		iocmd.flags &= ~MPT_ICFLAG_DID_RESET;
-
-		if (iocmd.flags & MPT_ICFLAG_EBOS)
-			goto skip_Reserve;
-
-		repeat = 5;
-		while (repeat && (!(iocmd.flags & MPT_ICFLAG_RESERVED))) {
-			iocmd.cmd = RESERVE;
-			iocmd.data_dma = -1;
-			iocmd.data = NULL;
-			iocmd.size = 0;
-			if (mptscsih_do_cmd(hd, &iocmd) < 0)
-				goto target_done;
-			else if (hd->pLocal == NULL)
-				goto target_done;
-			else {
-				rc = hd->pLocal->completion;
-				if (rc == MPT_SCANDV_GOOD) {
-					iocmd.flags |= MPT_ICFLAG_RESERVED;
-				} else if (rc == MPT_SCANDV_SENSE) {
-					/* Wait if coming ready
-					 */
-					u8 skey = hd->pLocal->sense[2] & 0x0F;
-					u8 asc = hd->pLocal->sense[12];
-					u8 ascq = hd->pLocal->sense[13];
-					ddvprintk((MYIOC_s_INFO_FMT
-						"DV: Reserve Failed: ", ioc->name));
-					ddvprintk(("SenseKey:ASC:ASCQ = (%x:%02x:%02x)\n",
-							skey, asc, ascq));
-
-					if ((skey == NOT_READY) && (asc == 0x04)&&
-									(ascq == 0x01)) {
-						/* wait then repeat */
-						mdelay (2000);
-						notDone++;
-					} else {
-						ddvprintk((MYIOC_s_INFO_FMT
-							"DV: Reserved Failed.", ioc->name));
-						goto target_done;
-					}
-				} else {
-					ddvprintk((MYIOC_s_INFO_FMT "DV: Reserved Failed.",
-							 ioc->name));
-					goto target_done;
-				}
-			}
-		}
-
-skip_Reserve:
-		mptscsih_fillbuf(pbuf1, sz, patt, 1);
-		iocmd.cmd = WRITE_BUFFER;
-		iocmd.data_dma = buf1_dma;
-		iocmd.data = pbuf1;
-		iocmd.size = sz;
-		if (mptscsih_do_cmd(hd, &iocmd) < 0)
-			goto target_done;
-		else if (hd->pLocal == NULL)
-			goto target_done;
-		else {
-			rc = hd->pLocal->completion;
-			if (rc == MPT_SCANDV_GOOD)
-				;		/* Issue read buffer */
-			else if (rc == MPT_SCANDV_DID_RESET) {
-				/* If using echo buffers, reset to data buffers.
-				 * Else do Fallback and restart
-				 * this test (re-issue reserve
-				 * because of bus reset).
-				 */
-				if ((iocmd.flags & MPT_ICFLAG_ECHO) && (dataBufSize >= bufsize)) {
-					iocmd.flags &= ~MPT_ICFLAG_ECHO;
-				} else {
-					dv.cmd = MPT_FALLBACK;
-					mptscsih_dv_parms(hd, &dv, (void *)pcfg1Data);
-
-					if (mpt_config(hd->ioc, &cfg) != 0)
-						goto target_done;
-
-					if ((!dv.now.width) && (!dv.now.offset))
-						goto target_done;
-				}
-
-				iocmd.flags |= MPT_ICFLAG_DID_RESET;
-				patt = -1;
-				continue;
-			} else if (rc == MPT_SCANDV_SENSE) {
-				/* Restart data test if UA, else quit.
-				 */
-				u8 skey = hd->pLocal->sense[2] & 0x0F;
-				ddvprintk((MYIOC_s_INFO_FMT
-					"SenseKey:ASC:ASCQ = (%x:%02x:%02x)\n", ioc->name, skey,
-					hd->pLocal->sense[12], hd->pLocal->sense[13]));
-				if (skey == UNIT_ATTENTION) {
-					patt = -1;
-					continue;
-				} else if (skey == ILLEGAL_REQUEST) {
-					if (iocmd.flags & MPT_ICFLAG_ECHO) {
-						if (dataBufSize >= bufsize) {
-							iocmd.flags &= ~MPT_ICFLAG_ECHO;
-							patt = -1;
-							continue;
-						}
-					}
-					goto target_done;
-				}
-				else
-					goto target_done;
-			} else {
-				/* fatal error */
-				goto target_done;
-			}
-		}
-
-		iocmd.cmd = READ_BUFFER;
-		iocmd.data_dma = buf2_dma;
-		iocmd.data = pbuf2;
-		iocmd.size = sz;
-		if (mptscsih_do_cmd(hd, &iocmd) < 0)
-			goto target_done;
-		else if (hd->pLocal == NULL)
-			goto target_done;
-		else {
-			rc = hd->pLocal->completion;
-			if (rc == MPT_SCANDV_GOOD) {
-				 /* If buffers compare,
-				  * go to next pattern,
-				  * else, do a fallback and restart
-				  * data transfer test.
-				  */
-				if (memcmp (pbuf1, pbuf2, sz) == 0) {
-					; /* goto next pattern */
-				} else {
-					/* Miscompare with Echo buffer, go to data buffer,
-					 * if that buffer exists.
-					 * Miscompare with Data buffer, check first 4 bytes,
-					 * some devices return capacity. Exit in this case.
-					 */
-					if (iocmd.flags & MPT_ICFLAG_ECHO) {
-						if (dataBufSize >= bufsize)
-							iocmd.flags &= ~MPT_ICFLAG_ECHO;
-						else
-							goto target_done;
-					} else {
-						if (dataBufSize == (pbuf2[1]<<16 | pbuf2[2]<<8 | pbuf2[3])) {
-							/* Argh. Device returning wrong data.
-							 * Quit DV for this device.
-							 */
-							goto target_done;
-						}
-
-						/* Had an actual miscompare. Slow down.*/
-						dv.cmd = MPT_FALLBACK;
-						mptscsih_dv_parms(hd, &dv, (void *)pcfg1Data);
-
-						if (mpt_config(hd->ioc, &cfg) != 0)
-							goto target_done;
-
-						if ((!dv.now.width) && (!dv.now.offset))
-							goto target_done;
-					}
-
-					patt = -1;
-					continue;
-				}
-			} else if (rc == MPT_SCANDV_DID_RESET) {
-				/* Do Fallback and restart
-				 * this test (re-issue reserve
-				 * because of bus reset).
-				 */
-				dv.cmd = MPT_FALLBACK;
-				mptscsih_dv_parms(hd, &dv, (void *)pcfg1Data);
-
-				if (mpt_config(hd->ioc, &cfg) != 0)
-					 goto target_done;
-
-				if ((!dv.now.width) && (!dv.now.offset))
-					goto target_done;
-
-				iocmd.flags |= MPT_ICFLAG_DID_RESET;
-				patt = -1;
-				continue;
-			} else if (rc == MPT_SCANDV_SENSE) {
-				/* Restart data test if UA, else quit.
-				 */
-				u8 skey = hd->pLocal->sense[2] & 0x0F;
-				ddvprintk((MYIOC_s_INFO_FMT
-					"SenseKey:ASC:ASCQ = (%x:%02x:%02x)\n", ioc->name, skey,
-					hd->pLocal->sense[12], hd->pLocal->sense[13]));
-				if (skey == UNIT_ATTENTION) {
-					patt = -1;
-					continue;
-				}
-				else
-					goto target_done;
-			} else {
-				/* fatal error */
-				goto target_done;
-			}
-		}
-
-	} /* --- end of patt loop ---- */
-
-target_done:
-	if (iocmd.flags & MPT_ICFLAG_RESERVED) {
-		iocmd.cmd = RELEASE;
-		iocmd.data_dma = -1;
-		iocmd.data = NULL;
-		iocmd.size = 0;
-		if (mptscsih_do_cmd(hd, &iocmd) < 0)
-			printk(MYIOC_s_INFO_FMT "DV: Release failed. id %d",
-					ioc->name, id);
-		else if (hd->pLocal) {
-			if (hd->pLocal->completion == MPT_SCANDV_GOOD)
-				iocmd.flags &= ~MPT_ICFLAG_RESERVED;
-		} else {
-			printk(MYIOC_s_INFO_FMT "DV: Release failed. id %d",
-						ioc->name, id);
-		}
-	}
-
+	hd->timer.expires = jiffies + HZ*10; /* 10 second timeout */
+	hd->scandv_wait_done = 0;
 
-	/* Set if cfg1_dma_addr contents is valid
+	/* Save cmd pointer, for resource free if timeout or
+	 * FW reload occurs
 	 */
-	if ((cfg.cfghdr.hdr != NULL) && (retcode == 0)){
-		/* If disk, not U320, disable QAS
-		 */
-		if ((inq0 == 0) && (dv.now.factor > MPT_ULTRA320)) {
-			hd->ioc->spi_data.noQas = MPT_TARGET_NO_NEGO_QAS;
-			ddvprintk((MYIOC_s_NOTE_FMT
-			    "noQas set due to id=%d has factor=%x\n", ioc->name, id, dv.now.factor));
-		}
-
-		dv.cmd = MPT_SAVE;
-		mptscsih_dv_parms(hd, &dv, (void *)pcfg1Data);
+	hd->cmdPtr = mf;
 
-		/* Double writes to SDP1 can cause problems,
-		 * skip save of the final negotiated settings to
-		 * SCSI device page 1.
-		 *
-		cfg.cfghdr.hdr = &header1;
-		cfg.physAddr = cfg1_dma_addr;
-		cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-		cfg.dir = 1;
-		mpt_config(hd->ioc, &cfg);
-		 */
-	}
+	add_timer(&hd->timer);
+	mpt_put_msg_frame(hd->ioc->InternalCtx, hd->ioc, mf);
+	wait_event(hd->scandv_waitq, hd->scandv_wait_done);
 
-	/* If this is a RAID Passthrough, enable internal IOs
-	 */
-	if (iocmd.flags & MPT_ICFLAG_PHYS_DISK) {
-		if (mptscsih_do_raid(hd, MPI_RAID_ACTION_ENABLE_PHYS_IO, &iocmd) < 0)
-			ddvprintk((MYIOC_s_ERR_FMT "RAID Enable FAILED!\n", ioc->name));
-	}
+	if ((hd->pLocal == NULL) || (hd->pLocal->completion != 0))
+		return -1;
 
-	/* Done with the DV scan of the current target
-	 */
-	if (pDvBuf)
-		pci_free_consistent(ioc->pcidev, dv_alloc, pDvBuf, dvbuf_dma);
+	if (pRep)
+		memcpy(pRep, hd->pLocal->u.r, repLen);
 
-	ddvtprintk((MYIOC_s_INFO_FMT "DV Done id=%d\n",
-			ioc->name, id));
+	return 0;
+}
+EXPORT_SYMBOL(mptscsih_raid_action);
 
-	return retcode;
+int
+mptscsih_read_raid_page0(struct scsi_device *sdev,
+			 struct _CONFIG_PAGE_RAID_VOL_0 *pass_pg0,
+			 int pg0len, int version)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	struct _MPT_ADAPTER *ioc = hd->ioc;
+	struct _CONFIG_PAGE_RAID_VOL_0 *pg0;
+	dma_addr_t pg0_dma;
+	struct _x_config_parms cfg;
+	struct _CONFIG_PAGE_HEADER hdr;
+	int err = -EBUSY;
+
+	pg0 = dma_alloc_coherent(&ioc->pcidev->dev, pg0len, &pg0_dma, GFP_KERNEL);
+	if (pg0 == NULL) {
+		dev_printk(KERN_ERR, &sdev->sdev_gendev,
+			   "dma_alloc_coherent for raid failed\n");
+		return -EINVAL;
+	}
+	memset(&hdr, 0, sizeof(hdr));
+
+	hdr.PageVersion = version;
+	hdr.PageLength = pg0len / 4;
+	hdr.PageNumber = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_RAID_VOLUME;
+
+	memset(&cfg, 0, sizeof(cfg));
+
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = pg0_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+	cfg.dir = 0;
+	cfg.pageAddr = sdev->id;
+
+	if (mpt_config(ioc, &cfg)) {
+		dev_printk(KERN_ERR, &sdev->sdev_gendev, "mpt_config failed\n");
+		goto out_free;
+	}
+	err = 0;
+	memcpy(pass_pg0, pg0, pg0len);
+
+ out_free:
+	dma_free_coherent(&ioc->pcidev->dev, pg0len, pg0, pg0_dma);
+	return err;
 }
+EXPORT_SYMBOL(mptscsih_read_raid_page0);
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*	mptscsih_dv_parms - perform a variety of operations on the
- *	parameters used for negotiation.
- *	@hd: Pointer to a SCSI host.
- *	@dv: Pointer to a structure that contains the maximum and current
- *		negotiated parameters.
- */
-static void
-mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void *pPage)
+static int
+mptscsih_find_physDiskNum(struct _MPT_SCSI_HOST *hd, int physDiskBus,
+			  int physDiskID)
 {
-	VirtDevice		*pTarget;
-	SCSIDevicePage0_t	*pPage0;
-	SCSIDevicePage1_t	*pPage1;
-	int			val = 0, data, configuration;
-	u8			width = 0;
-	u8			offset = 0;
-	u8			factor = 0;
-	u8			negoFlags = 0;
-	u8			cmd = dv->cmd;
-	u8			id = dv->id;
-
-	switch (cmd) {
-	case MPT_GET_NVRAM_VALS:
-		ddvprintk((MYIOC_s_NOTE_FMT "Getting NVRAM: ",
-							 hd->ioc->name));
-		/* Get the NVRAM values and save in tmax
-		 * If not an LVD bus, the adapter minSyncFactor has been
-		 * already throttled back.
-		 */
-		negoFlags = hd->ioc->spi_data.noQas;
-		if ((hd->Targets)&&((pTarget = hd->Targets[(int)id]) != NULL) && !pTarget->raidVolume) {
-			width = pTarget->maxWidth;
-			offset = pTarget->maxOffset;
-			factor = pTarget->minSyncFactor;
-			negoFlags |= pTarget->negoFlags;
-		} else {
-			if (hd->ioc->spi_data.nvram && (hd->ioc->spi_data.nvram[id] != MPT_HOST_NVRAM_INVALID)) {
-				data = hd->ioc->spi_data.nvram[id];
-				width = data & MPT_NVRAM_WIDE_DISABLE ? 0 : 1;
-				if ((offset = hd->ioc->spi_data.maxSyncOffset) == 0)
-					factor = MPT_ASYNC;
-				else {
-					factor = (data & MPT_NVRAM_SYNC_MASK) >> MPT_NVRAM_SYNC_SHIFT;
-					if ((factor == 0) || (factor == MPT_ASYNC)){
-						factor = MPT_ASYNC;
-						offset = 0;
-					}
-				}
-			} else {
-				width = MPT_NARROW;
-				offset = 0;
-				factor = MPT_ASYNC;
-			}
-
-			/* Set the negotiation flags */
-			if (!width)
-				negoFlags |= MPT_TARGET_NO_NEGO_WIDE;
-
-			if (!offset)
-				negoFlags |= MPT_TARGET_NO_NEGO_SYNC;
-		}
-
-		/* limit by adapter capabilities */
-		width = min(width, hd->ioc->spi_data.maxBusWidth);
-		offset = min(offset, hd->ioc->spi_data.maxSyncOffset);
-		factor = max(factor, hd->ioc->spi_data.minSyncFactor);
-
-		/* Check Consistency */
-		if (offset && (factor < MPT_ULTRA2) && !width)
-			factor = MPT_ULTRA2;
-
-		dv->max.width = width;
-		dv->max.offset = offset;
-		dv->max.factor = factor;
-		dv->max.flags = negoFlags;
-		ddvprintk((" id=%d width=%d factor=%x offset=%x flags=%x\n",
-				id, width, factor, offset, negoFlags));
-		break;
-
-	case MPT_UPDATE_MAX:
-		ddvprintk((MYIOC_s_NOTE_FMT
-			"Updating with SDP0 Data: ", hd->ioc->name));
-		/* Update tmax values with those from Device Page 0.*/
-		pPage0 = (SCSIDevicePage0_t *) pPage;
-		if (pPage0) {
-			val = le32_to_cpu(pPage0->NegotiatedParameters);
-			dv->max.width = val & MPI_SCSIDEVPAGE0_NP_WIDE ? 1 : 0;
-			dv->max.offset = (val&MPI_SCSIDEVPAGE0_NP_NEG_SYNC_OFFSET_MASK) >> 16;
-			dv->max.factor = (val&MPI_SCSIDEVPAGE0_NP_NEG_SYNC_PERIOD_MASK) >> 8;
-		}
-
-		dv->now.width = dv->max.width;
-		dv->now.offset = dv->max.offset;
-		dv->now.factor = dv->max.factor;
-		ddvprintk(("id=%d width=%d factor=%x offset=%x flags=%x\n",
-				id, dv->now.width, dv->now.factor, dv->now.offset, dv->now.flags));
-		break;
-
-	case MPT_SET_MAX:
-		ddvprintk((MYIOC_s_NOTE_FMT "Setting Max: ",
-								hd->ioc->name));
-		/* Set current to the max values. Update the config page.*/
-		dv->now.width = dv->max.width;
-		dv->now.offset = dv->max.offset;
-		dv->now.factor = dv->max.factor;
-		dv->now.flags = dv->max.flags;
-
-		pPage1 = (SCSIDevicePage1_t *)pPage;
-		if (pPage1) {
-			mptscsih_setDevicePage1Flags (dv->now.width, dv->now.factor,
-				dv->now.offset, &val, &configuration, dv->now.flags);
-			dnegoprintk(("Setting Max: id=%d width=%d factor=%x offset=%x negoFlags=%x request=%x config=%x\n",
-				id, dv->now.width, dv->now.factor, dv->now.offset, dv->now.flags, val, configuration));
-			pPage1->RequestedParameters = cpu_to_le32(val);
-			pPage1->Reserved = 0;
-			pPage1->Configuration = cpu_to_le32(configuration);
-		}
-
-		ddvprintk(("id=%d width=%d factor=%x offset=%x negoFlags=%x request=%x configuration=%x\n",
-				id, dv->now.width, dv->now.factor, dv->now.offset, dv->now.flags, val, configuration));
-		break;
-
-	case MPT_SET_MIN:
-		ddvprintk((MYIOC_s_NOTE_FMT "Setting Min: ",
-								hd->ioc->name));
-		/* Set page to asynchronous and narrow
-		 * Do not update now, breaks fallback routine. */
-		width = MPT_NARROW;
-		offset = 0;
-		factor = MPT_ASYNC;
-		negoFlags = dv->max.flags;
-
-		pPage1 = (SCSIDevicePage1_t *)pPage;
-		if (pPage1) {
-			mptscsih_setDevicePage1Flags (width, factor,
-				offset, &val, &configuration, negoFlags);
-			dnegoprintk(("Setting Min: id=%d width=%d factor=%x offset=%x negoFlags=%x request=%x config=%x\n",
-				id, width, factor, offset, negoFlags, val, configuration));
-			pPage1->RequestedParameters = cpu_to_le32(val);
-			pPage1->Reserved = 0;
-			pPage1->Configuration = cpu_to_le32(configuration);
-		}
-		ddvprintk(("id=%d width=%d factor=%x offset=%x request=%x config=%x negoFlags=%x\n",
-				id, width, factor, offset, val, configuration, negoFlags));
-		break;
-
-	case MPT_FALLBACK:
-		ddvprintk((MYIOC_s_NOTE_FMT
-			"Fallback: Start: offset %d, factor %x, width %d \n",
-				hd->ioc->name, dv->now.offset,
-				dv->now.factor, dv->now.width));
-		width = dv->now.width;
-		offset = dv->now.offset;
-		factor = dv->now.factor;
-		if ((offset) && (dv->max.width)) {
-			if (factor < MPT_ULTRA160)
-				factor = MPT_ULTRA160;
-			else if (factor < MPT_ULTRA2) {
-				factor = MPT_ULTRA2;
-				width = MPT_WIDE;
-			} else if ((factor == MPT_ULTRA2) && width) {
-				factor = MPT_ULTRA2;
-				width = MPT_NARROW;
-			} else if (factor < MPT_ULTRA) {
-				factor = MPT_ULTRA;
-				width = MPT_WIDE;
-			} else if ((factor == MPT_ULTRA) && width) {
-				width = MPT_NARROW;
-			} else if (factor < MPT_FAST) {
-				factor = MPT_FAST;
-				width = MPT_WIDE;
-			} else if ((factor == MPT_FAST) && width) {
-				factor = MPT_FAST;
-				width = MPT_NARROW;
-			} else if (factor < MPT_SCSI) {
-				factor = MPT_SCSI;
-				width = MPT_WIDE;
-			} else if ((factor == MPT_SCSI) && width) {
-				factor = MPT_SCSI;
-				width = MPT_NARROW;
-			} else {
-				factor = MPT_ASYNC;
-				offset = 0;
-			}
-
-		} else if (offset) {
-			width = MPT_NARROW;
-			if (factor < MPT_ULTRA)
-				factor = MPT_ULTRA;
-			else if (factor < MPT_FAST)
-				factor = MPT_FAST;
-			else if (factor < MPT_SCSI)
-				factor = MPT_SCSI;
-			else {
-				factor = MPT_ASYNC;
-				offset = 0;
-			}
-
-		} else {
-			width = MPT_NARROW;
-			factor = MPT_ASYNC;
-		}
-		dv->max.flags |= MPT_TARGET_NO_NEGO_QAS;
-		dv->max.flags &= ~MPT_TAPE_NEGO_IDP;
-
-		dv->now.width = width;
-		dv->now.offset = offset;
-		dv->now.factor = factor;
-		dv->now.flags = dv->max.flags;
-
-		pPage1 = (SCSIDevicePage1_t *)pPage;
-		if (pPage1) {
-			mptscsih_setDevicePage1Flags (width, factor, offset, &val,
-						&configuration, dv->now.flags);
-			dnegoprintk(("Finish: id=%d width=%d offset=%d factor=%x negoFlags=%x request=%x config=%x\n",
-			     id, width, offset, factor, dv->now.flags, val, configuration));
-
-			pPage1->RequestedParameters = cpu_to_le32(val);
-			pPage1->Reserved = 0;
-			pPage1->Configuration = cpu_to_le32(configuration);
-		}
-
-		ddvprintk(("Finish: id=%d offset=%d factor=%x width=%d request=%x config=%x\n",
-			     id, dv->now.offset, dv->now.factor, dv->now.width, val, configuration));
-		break;
-
-	case MPT_SAVE:
-		ddvprintk((MYIOC_s_NOTE_FMT
-			"Saving to Target structure: ", hd->ioc->name));
-		ddvprintk(("id=%d width=%x factor=%x offset=%d flags=%x\n",
-			     id, dv->now.width, dv->now.factor, dv->now.offset, dv->now.flags));
-
-		/* Save these values to target structures
-		 * or overwrite nvram (phys disks only).
-		 */
-
-		if ((hd->Targets)&&((pTarget = hd->Targets[(int)id]) != NULL) && !pTarget->raidVolume ) {
-			pTarget->maxWidth = dv->now.width;
-			pTarget->maxOffset = dv->now.offset;
-			pTarget->minSyncFactor = dv->now.factor;
-			pTarget->negoFlags = dv->now.flags;
-		} else {
-			/* Preserv all flags, use
-			 * read-modify-write algorithm
-			 */
-			if (hd->ioc->spi_data.nvram) {
-				data = hd->ioc->spi_data.nvram[id];
-
-				if (dv->now.width)
-					data &= ~MPT_NVRAM_WIDE_DISABLE;
-				else
-					data |= MPT_NVRAM_WIDE_DISABLE;
-
-				if (!dv->now.offset)
-					factor = MPT_ASYNC;
+	int i;
 
-				data &= ~MPT_NVRAM_SYNC_MASK;
-				data |= (dv->now.factor << MPT_NVRAM_SYNC_SHIFT) & MPT_NVRAM_SYNC_MASK;
+	struct _CONFIG_PAGE_IOC_3 *pg3 = hd->ioc->raid_data.pIocPg3;
 
-				hd->ioc->spi_data.nvram[id] = data;
-			}
+	for (i = 0; i < pg3->NumPhysDisks; i++) {
+		if (physDiskID == pg3->PhysDisk[i].PhysDiskID &&
+		    physDiskBus == pg3->PhysDisk[i].PhysDiskBus) {
+			return pg3->PhysDisk[i].PhysDiskNum;
 		}
-		break;
 	}
+	return -1;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*	mptscsih_fillbuf - fill a buffer with a special data pattern
- *		cleanup. For bus scan only.
- *
- *	@buffer: Pointer to data buffer to be filled.
- *	@size: Number of bytes to fill
- *	@index: Pattern index
- *	@width: bus width, 0 (8 bits) or 1 (16 bits)
- */
-static void
-mptscsih_fillbuf(char *buffer, int size, int index, int width)
+struct _VirtDevice *
+mptscsih_find_raid_device(struct _MPT_SCSI_HOST *hd, int physDiskBus,
+			  int physDiskID)
 {
-	char *ptr = buffer;
-	int ii;
-	char byte;
-	short val;
-
-	switch (index) {
-	case 0:
-
-		if (width) {
-			/* Pattern:  0000 FFFF 0000 FFFF
-			 */
-			for (ii=0; ii < size; ii++, ptr++) {
-				if (ii & 0x02)
-					*ptr = 0xFF;
-				else
-					*ptr = 0x00;
-			}
-		} else {
-			/* Pattern:  00 FF 00 FF
-			 */
-			for (ii=0; ii < size; ii++, ptr++) {
-				if (ii & 0x01)
-					*ptr = 0xFF;
-				else
-					*ptr = 0x00;
-			}
-		}
-		break;
-
-	case 1:
-		if (width) {
-			/* Pattern:  5555 AAAA 5555 AAAA 5555
-			 */
-			for (ii=0; ii < size; ii++, ptr++) {
-				if (ii & 0x02)
-					*ptr = 0xAA;
-				else
-					*ptr = 0x55;
-			}
-		} else {
-			/* Pattern:  55 AA 55 AA 55
-			 */
-			for (ii=0; ii < size; ii++, ptr++) {
-				if (ii & 0x01)
-					*ptr = 0xAA;
-				else
-					*ptr = 0x55;
-			}
-		}
-		break;
-
-	case 2:
-		/* Pattern:  00 01 02 03 04 05
-		 * ... FE FF 00 01..
-		 */
-		for (ii=0; ii < size; ii++, ptr++)
-			*ptr = (char) ii;
-		break;
-
-	case 3:
-		if (width) {
-			/* Wide Pattern:  FFFE 0001 FFFD 0002
-			 * ...  4000 DFFF 8000 EFFF
-			 */
-			byte = 0;
-			for (ii=0; ii < size/2; ii++) {
-				/* Create the base pattern
-				 */
-				val = (1 << byte);
-				/* every 64 (0x40) bytes flip the pattern
-				 * since we fill 2 bytes / iteration,
-				 * test for ii = 0x20
-				 */
-				if (ii & 0x20)
-					val = ~(val);
-
-				if (ii & 0x01) {
-					*ptr = (char)( (val & 0xFF00) >> 8);
-					ptr++;
-					*ptr = (char)(val & 0xFF);
-					byte++;
-					byte &= 0x0F;
-				} else {
-					val = ~val;
-					*ptr = (char)( (val & 0xFF00) >> 8);
-					ptr++;
-					*ptr = (char)(val & 0xFF);
-				}
+	int i;
+	struct _VirtDevice *vdev;
+	int physDiskNum = mptscsih_find_physDiskNum(hd, physDiskBus, physDiskID);
+	if (physDiskNum < 0)
+		return NULL;
 
-				ptr++;
-			}
-		} else {
-			/* Narrow Pattern:  FE 01 FD 02 FB 04
-			 * .. 7F 80 01 FE 02 FD ...  80 7F
-			 */
-			byte = 0;
-			for (ii=0; ii < size; ii++, ptr++) {
-				/* Base pattern - first 32 bytes
-				 */
-				if (ii & 0x01) {
-					*ptr = (1 << byte);
-					byte++;
-					byte &= 0x07;
-				} else {
-					*ptr = (char) (~(1 << byte));
-				}
+	for (i = 0; i < hd->ioc->sh->max_id; i++) {
+		int j;
 
-				/* Flip the pattern every 32 bytes
-				 */
-				if (ii & 0x20)
-					*ptr = ~(*ptr);
-			}
+		vdev = mpt_target(hd, 0, i);
+		if (!vdev || !vdev->raidVolume)
+			continue;
+		for (j = 0; j < vdev->raidVolume->NumPhysDisks; j++) {
+			if (vdev->raidVolume->PhysDisk[j].PhysDiskNum ==
+			    physDiskNum)
+				goto found;
 		}
-		break;
 	}
+	return NULL;
+ found:
+	return vdev;
 }
-#endif /* ~MPTSCSIH_ENABLE_DOMAIN_VALIDATION */
+EXPORT_SYMBOL(mptscsih_find_raid_device);
 
 EXPORT_SYMBOL(mptscsih_remove);
 EXPORT_SYMBOL(mptscsih_shutdown);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -60,16 +60,6 @@
 
 #define MPT_SCSI_MAX_SECTORS    8192
 
-/* To disable domain validation, uncomment the
- * following line. No effect for FC devices.
- * For SCSI devices, driver will negotiate to
- * NVRAM settings (if available) or to maximum adapter
- * capabilities.
- */
-
-#define MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-
-
 /* SCSI driver setup structure. Settings can be overridden
  * by command line options.
  */
@@ -106,3 +96,18 @@ extern int mptscsih_event_process(MPT_AD
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern void mptscsih_timer_expired(unsigned long data);
+extern int mptscsih_raid_action(MPT_SCSI_HOST *hd, int action, int volume,
+				int volbus, MpiRaidActionReply_t *pRep,
+				int repLen);
+extern int mptscsih_read_raid_page0(struct scsi_device *sdev,
+				    struct _CONFIG_PAGE_RAID_VOL_0 *pass_pg0,
+				    int pg0len, int version);
+
+extern struct _VirtDevice *
+mptscsih_find_raid_device(struct _MPT_SCSI_HOST *hd, int physDiskBus,
+			  int physDiskID);
+
+static inline VirtDevice *mpt_target(MPT_SCSI_HOST *hd, int channel, int id)
+{
+	return hd->Targets[id + (channel * hd->ioc->sh->max_id)];
+}
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -56,12 +56,15 @@
 #include <linux/reboot.h>	/* notifier code */
 #include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/raid_class.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -76,20 +79,6 @@ MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
 
 /* Command line args */
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-static int mpt_dv = MPTSCSIH_DOMAIN_VALIDATION;
-module_param(mpt_dv, int, 0);
-MODULE_PARM_DESC(mpt_dv, " DV Algorithm: enhanced=1, basic=0 (default=MPTSCSIH_DOMAIN_VALIDATION=1)");
-
-static int mpt_width = MPTSCSIH_MAX_WIDTH;
-module_param(mpt_width, int, 0);
-MODULE_PARM_DESC(mpt_width, " Max Bus Width: wide=1, narrow=0 (default=MPTSCSIH_MAX_WIDTH=1)");
-
-static ushort mpt_factor = MPTSCSIH_MIN_SYNC;
-module_param(mpt_factor, ushort, 0);
-MODULE_PARM_DESC(mpt_factor, " Min Sync Factor (default=MPTSCSIH_MIN_SYNC=0x08)");
-#endif
-
 static int mpt_saf_te = MPTSCSIH_SAF_TE;
 module_param(mpt_saf_te, int, 0);
 MODULE_PARM_DESC(mpt_saf_te, " Force enabling SEP Processor: enable=1  (default=MPTSCSIH_SAF_TE=0)");
@@ -98,10 +87,200 @@ static int mpt_pq_filter = 0;
 module_param(mpt_pq_filter, int, 0);
 MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: enable=1  (default=0)");
 
+static void mptspi_write_offset(struct scsi_target *, int);
+static void mptspi_write_width(struct scsi_target *, int);
+
+static struct scsi_transport_template *mptspi_transport_template = NULL;
+static struct raid_template *mptspi_raid_template = NULL;
+
 static int	mptspiDoneCtx = -1;
 static int	mptspiTaskCtx = -1;
 static int	mptspiInternalCtx = -1; /* Used only for internal commands */
 
+static int mptspi_target_alloc(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+
+	if (hd == NULL)
+		return -ENODEV;
+
+	if (hd->ioc->spi_data.nvram &&
+	    hd->ioc->spi_data.nvram[starget->id] != MPT_HOST_NVRAM_INVALID) {
+		u32 nvram = hd->ioc->spi_data.nvram[starget->id];
+		spi_min_period(starget) = (nvram & MPT_NVRAM_SYNC_MASK) >> MPT_NVRAM_SYNC_SHIFT;
+		spi_max_width(starget) = nvram & MPT_NVRAM_WIDE_DISABLE ? 0 : 1;
+	} else {
+		spi_min_period(starget) = hd->ioc->spi_data.minSyncFactor;
+		spi_max_width(starget) = hd->ioc->spi_data.maxBusWidth;
+	}
+	spi_max_offset(starget) = hd->ioc->spi_data.maxSyncOffset;
+
+	spi_offset(starget) = 0;
+	mptspi_write_width(starget, 0);
+
+	return 0;
+}
+
+static int mptspi_read_page0(struct scsi_target *starget,
+			     struct _CONFIG_PAGE_SCSI_DEVICE_0 *pass_pg0)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	struct _MPT_ADAPTER *ioc = hd->ioc;
+	struct _CONFIG_PAGE_SCSI_DEVICE_0 *pg0;
+	dma_addr_t pg0_dma;
+	int size;
+	struct _x_config_parms cfg;
+	struct _CONFIG_PAGE_HEADER hdr;
+	int err = -EBUSY;
+
+	size = ioc->spi_data.sdp0length * 4;
+	/*
+	if (ioc->spi_data.sdp0length & 1)
+		size += size + 4;
+	size += 2048;
+	*/
+
+	pg0 = dma_alloc_coherent(&ioc->pcidev->dev, size, &pg0_dma, GFP_KERNEL);
+	if (pg0 == NULL) {
+		dev_printk(KERN_ERR, &starget->dev, "dma_alloc_coherent for parameters failed\n");
+		return -EINVAL;
+	}
+
+	memset(&hdr, 0, sizeof(hdr));
+
+	hdr.PageVersion = ioc->spi_data.sdp0version;
+	hdr.PageLength = ioc->spi_data.sdp0length;
+	hdr.PageNumber = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
+
+	memset(&cfg, 0, sizeof(cfg));
+
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = pg0_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+	cfg.dir = 0;
+	cfg.pageAddr = starget->id;
+
+	if (mpt_config(ioc, &cfg)) {
+		dev_printk(KERN_ERR, &starget->dev, "mpt_config failed\n");
+		goto out_free;
+	}
+	err = 0;
+	memcpy(pass_pg0, pg0, size);
+
+ out_free:
+	dma_free_coherent(&ioc->pcidev->dev, size, pg0, pg0_dma);
+	return err;
+}
+
+static u32 mptspi_getRP(struct scsi_target *starget)
+{
+	u32 nego = 0;
+
+	nego |= spi_iu(starget) ? MPI_SCSIDEVPAGE1_RP_IU : 0;
+	nego |= spi_dt(starget) ? MPI_SCSIDEVPAGE1_RP_DT : 0;
+	nego |= spi_qas(starget) ? MPI_SCSIDEVPAGE1_RP_QAS : 0;
+	//nego |= spi_hold_mcs(starget) ? MPI_SCSIDEVPAGE1_RP_HOLD_MCS : 0;
+	nego |= spi_wr_flow(starget) ? MPI_SCSIDEVPAGE1_RP_WR_FLOW : 0;
+	nego |= spi_rd_strm(starget) ? MPI_SCSIDEVPAGE1_RP_RD_STRM : 0;
+	nego |= spi_rti(starget) ? MPI_SCSIDEVPAGE1_RP_RTI : 0;
+	nego |= spi_pcomp_en(starget) ? MPI_SCSIDEVPAGE1_RP_PCOMP_EN : 0;
+
+	nego |= (spi_period(starget) <<  MPI_SCSIDEVPAGE1_RP_SHIFT_MIN_SYNC_PERIOD) & MPI_SCSIDEVPAGE1_RP_MIN_SYNC_PERIOD_MASK;
+	nego |= (spi_offset(starget) << MPI_SCSIDEVPAGE1_RP_SHIFT_MAX_SYNC_OFFSET) & MPI_SCSIDEVPAGE1_RP_MAX_SYNC_OFFSET_MASK;
+	nego |= spi_width(starget) ?  MPI_SCSIDEVPAGE1_RP_WIDE : 0;
+
+	return nego;
+}
+
+static void mptspi_read_parameters(struct scsi_target *starget)
+{
+	int nego;
+	struct _CONFIG_PAGE_SCSI_DEVICE_0 pg0;
+
+	mptspi_read_page0(starget, &pg0);
+
+	nego = le32_to_cpu(pg0.NegotiatedParameters);
+
+	spi_iu(starget) = (nego & MPI_SCSIDEVPAGE0_NP_IU) ? 1 : 0;
+	spi_dt(starget) = (nego & MPI_SCSIDEVPAGE0_NP_DT) ? 1 : 0;
+	spi_qas(starget) = (nego & MPI_SCSIDEVPAGE0_NP_QAS) ? 1 : 0;
+	//spi_hold_mcs(starget) = (nego & MPI_SCSIDEVPAGE0_NP_HOLD_MCS) ? 1 : 0;
+	spi_wr_flow(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WR_FLOW) ? 1 : 0;
+	spi_rd_strm(starget) = (nego & MPI_SCSIDEVPAGE0_NP_RD_STRM) ? 1 : 0;
+	spi_rti(starget) = (nego & MPI_SCSIDEVPAGE0_NP_RTI) ? 1 : 0;
+	spi_pcomp_en(starget) = (nego & MPI_SCSIDEVPAGE0_NP_PCOMP_EN) ? 1 : 0;
+	spi_hold_mcs(starget) = (nego & MPI_SCSIDEVPAGE0_NP_HOLD_MCS) ? 1 : 0;
+	spi_period(starget) = (nego & MPI_SCSIDEVPAGE0_NP_NEG_SYNC_PERIOD_MASK) >> MPI_SCSIDEVPAGE0_NP_SHIFT_SYNC_PERIOD;
+	spi_offset(starget) = (nego & MPI_SCSIDEVPAGE0_NP_NEG_SYNC_OFFSET_MASK) >> MPI_SCSIDEVPAGE0_NP_SHIFT_SYNC_OFFSET;
+	spi_width(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WIDE) ? 1 : 0;
+}
+
+static void mptspi_dv_device(struct _MPT_SCSI_HOST *hd,
+			     struct scsi_device *sdev)
+{
+	if (sdev->channel &&
+	    mptscsih_raid_action(hd, MPI_RAID_ACTION_QUIESCE_PHYS_IO,
+				 sdev->id, 0, NULL, 0) < 0) {
+		dev_printk(KERN_ERR, &sdev->sdev_target->dev,
+			   "Integrated RAID quiesce failed\n");
+		return;
+	}
+
+	spi_dv_device(sdev);
+
+	if (sdev->channel &&
+	    mptscsih_raid_action(hd, MPI_RAID_ACTION_ENABLE_PHYS_IO,
+				 sdev->id, 0, NULL, 0) < 0)
+		dev_printk(KERN_ERR, &sdev->sdev_target->dev,
+			   "Integrated RAID resume failed\n");
+
+	mptspi_read_parameters(sdev->sdev_target);
+	spi_display_xfer_agreement(sdev->sdev_target);
+	mptspi_read_parameters(sdev->sdev_target);
+}
+
+static int mptspi_slave_configure(struct scsi_device *sdev)
+{
+	int ret = mptscsih_slave_configure(sdev);
+	struct _MPT_SCSI_HOST *hd =
+		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
+
+	if (ret)
+		return ret;
+
+	if (!sdev->channel && (hd->ioc->raid_data.isRaid & (1 << sdev->id))) {
+		enum raid_level level = RAID_LEVEL_UNKNOWN;
+
+		switch (hd->ioc->raid_data.pIocPg2->RaidVolume[sdev->id].VolumeType) {
+		case MPI_RAID_VOL_TYPE_IS:
+			level = RAID_LEVEL_0;
+			break;
+		case MPI_RAID_VOL_TYPE_IME:
+		case MPI_RAID_VOL_TYPE_IM:
+		case MPI_RAID_VOL_TYPE_RAID_10:
+			level = RAID_LEVEL_1;
+			break;
+		case MPI_RAID_VOL_TYPE_RAID_5:
+		case MPI_RAID_VOL_TYPE_RAID_50:
+			level = RAID_LEVEL_5;
+			break;
+		case MPI_RAID_VOL_TYPE_RAID_6:
+			level = RAID_LEVEL_6;
+			break;
+		}
+		raid_set_level(mptspi_raid_template, &sdev->sdev_gendev, level);
+	}
+
+	if ((sdev->channel || !(hd->ioc->raid_data.isRaid & (1 << sdev->id))) &&
+	    !spi_initial_dv(sdev->sdev_target))
+		mptspi_dv_device(hd, sdev);
+
+	return 0;
+}
+
 static struct scsi_host_template mptspi_driver_template = {
 	.proc_name			= "mptspi",
 	.proc_info			= mptscsih_proc_info,
@@ -109,8 +288,9 @@ static struct scsi_host_template mptspi_
 	.info				= mptscsih_info,
 	.queuecommand			= mptscsih_qcmd,
 	.slave_alloc			= mptscsih_slave_alloc,
-	.slave_configure		= mptscsih_slave_configure,
+	.slave_configure		= mptspi_slave_configure,
 	.slave_destroy			= mptscsih_slave_destroy,
+	.target_alloc			= mptspi_target_alloc,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
@@ -125,6 +305,421 @@ static struct scsi_host_template mptspi_
 	.use_clustering			= ENABLE_CLUSTERING,
 };
 
+static int mptspi_write_page1(struct scsi_target *starget,
+			       struct _CONFIG_PAGE_SCSI_DEVICE_1 *pass_pg1)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	struct _MPT_ADAPTER *ioc = hd->ioc;
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 *pg1;
+	dma_addr_t pg1_dma;
+	int size;
+	struct _x_config_parms cfg;
+	struct _CONFIG_PAGE_HEADER hdr;
+	int err = -EBUSY;
+
+	size = ioc->spi_data.sdp1length * 4;
+
+	pg1 = dma_alloc_coherent(&ioc->pcidev->dev, size, &pg1_dma, GFP_KERNEL);
+	if (pg1 == NULL) {
+		dev_printk(KERN_ERR, &starget->dev, "dma_alloc_coherent for parameters failed\n");
+		return -EINVAL;
+	}
+
+	memset(&hdr, 0, sizeof(hdr));
+
+	hdr.PageVersion = ioc->spi_data.sdp1version;
+	hdr.PageLength = ioc->spi_data.sdp1length;
+	hdr.PageNumber = 1;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
+
+	memset(&cfg, 0, sizeof(cfg));
+
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = pg1_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	cfg.dir = 1;
+	cfg.pageAddr = starget->id;
+
+	memcpy(pg1, pass_pg1, size);
+
+	pg1->Header.PageVersion = hdr.PageVersion;
+	pg1->Header.PageLength = hdr.PageLength;
+	pg1->Header.PageNumber = hdr.PageNumber;
+	pg1->Header.PageType = hdr.PageType;
+
+	if (mpt_config(ioc, &cfg)) {
+		dev_printk(KERN_ERR, &starget->dev, "mpt_config failed\n");
+		goto out_free;
+	}
+	err = 0;
+
+ out_free:
+	dma_free_coherent(&ioc->pcidev->dev, size, pg1, pg1_dma);
+	return err;
+}
+
+static void mptspi_write_offset(struct scsi_target *starget, int offset)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
+
+	if (offset < 0)
+		offset = 0;
+
+	if (offset > 255)
+		offset = 255;
+
+	if (spi_offset(starget) == -1)
+		mptspi_read_parameters(starget);
+
+	spi_offset(starget) = offset;
+
+	nego = mptspi_getRP(starget);
+
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_page1(starget, &pg1);
+}
+
+static void mptspi_write_period(struct scsi_target *starget, int period)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
+
+	if (period < 8)
+		period = 8;
+
+	if (period > 255)
+		period = 255;
+
+	if (spi_period(starget) == -1)
+		mptspi_read_parameters(starget);
+
+	if (period == 8) {
+		spi_iu(starget) = 1;
+		spi_dt(starget) = 1;
+	} else if (period == 9) {
+		spi_dt(starget) = 1;
+	}
+
+	spi_period(starget) = period;
+
+	nego = mptspi_getRP(starget);
+
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_page1(starget, &pg1);
+}
+
+static void mptspi_write_dt(struct scsi_target *starget, int dt)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
+
+	if (spi_period(starget) == -1)
+		mptspi_read_parameters(starget);
+
+	if (!dt && spi_period(starget) < 10)
+		spi_period(starget) = 10;
+
+	spi_dt(starget) = dt;
+
+	nego = mptspi_getRP(starget);
+
+	
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_page1(starget, &pg1);
+}
+
+static void mptspi_write_iu(struct scsi_target *starget, int iu)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
+
+	if (spi_period(starget) == -1)
+		mptspi_read_parameters(starget);
+
+	if (!iu && spi_period(starget) < 9)
+		spi_period(starget) = 9;
+
+	spi_iu(starget) = iu;
+
+	nego = mptspi_getRP(starget);
+
+	
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_page1(starget, &pg1);
+}
+
+#define MPTSPI_SIMPLE_TRANSPORT_PARM(parm) 				\
+static void mptspi_write_##parm(struct scsi_target *starget, int parm)\
+{									\
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;				\
+	u32 nego;							\
+									\
+	spi_rd_strm(starget) = parm;					\
+									\
+	nego = mptspi_getRP(starget);					\
+									\
+	pg1.RequestedParameters = cpu_to_le32(nego);			\
+	pg1.Reserved = 0;						\
+	pg1.Configuration = 0;						\
+									\
+	mptspi_write_page1(starget, &pg1);				\
+}
+
+MPTSPI_SIMPLE_TRANSPORT_PARM(qas)
+MPTSPI_SIMPLE_TRANSPORT_PARM(rd_strm)
+MPTSPI_SIMPLE_TRANSPORT_PARM(wr_flow)
+MPTSPI_SIMPLE_TRANSPORT_PARM(rti)
+MPTSPI_SIMPLE_TRANSPORT_PARM(hold_mcs)
+MPTSPI_SIMPLE_TRANSPORT_PARM(pcomp_en)
+
+static void mptspi_write_width(struct scsi_target *starget, int width)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
+
+	if (!width) {
+		spi_dt(starget) = 0;
+		if (spi_period(starget) < 10)
+			spi_period(starget) = 10;
+	}
+
+	spi_width(starget) = width;
+
+	nego = mptspi_getRP(starget);
+	
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_page1(starget, &pg1);
+}
+
+struct work_queue_wrapper {
+	struct work_struct	work;
+	struct _MPT_SCSI_HOST	*hd;
+	int			disk;
+};
+
+static void mpt_work_wrapper(void *data)
+{
+	struct work_queue_wrapper *wqw = (struct work_queue_wrapper *)data;
+	struct _MPT_SCSI_HOST *hd = wqw->hd;
+	int i, disk = wqw->disk;
+	struct _CONFIG_PAGE_IOC_3 *pg3 = hd->ioc->raid_data.pIocPg3;
+
+	kfree(wqw);
+
+	for (i = 0; i < pg3->NumPhysDisks; i++) {
+		if (disk == pg3->PhysDisk[i].PhysDiskNum) {
+			/* hard code channel 1 for phys device of RAID */
+			VirtDevice *vdev = mpt_target(hd, 1, disk);
+			if (!vdev)
+				break;
+			dev_printk(KERN_INFO, &vdev->device->sdev_target->dev,
+				   "Integrated RAID requests DV of new device\n");
+			mptspi_dv_device(hd, vdev->device);
+			return;
+		}
+	}
+	mpt_read_ioc_pg_3(hd->ioc);
+	dev_printk(KERN_INFO, &hd->ioc->sh->shost_gendev,
+		   "Integrated RAID detects new device %d\n", disk);
+	scsi_scan_target(&hd->ioc->sh->shost_gendev, 1, disk, 0, 1);
+}
+
+
+static void mpt_dv_raid(struct _MPT_SCSI_HOST *hd, int disk)
+{
+	struct work_queue_wrapper *wqw = kmalloc(sizeof(*wqw), GFP_ATOMIC);
+
+	if (!wqw) {
+		dev_printk(KERN_ERR, &hd->ioc->sh->shost_gendev,
+			   "Failed to act on RAID event for physical disk %d\n",
+			   disk);
+		return;
+	}
+	INIT_WORK(&wqw->work, mpt_work_wrapper, wqw);
+	wqw->hd = hd;
+	wqw->disk = disk;
+
+	schedule_work(&wqw->work);
+}
+
+static int
+mptspi_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
+{
+	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+
+	if (hd && event ==  MPI_EVENT_INTEGRATED_RAID) {
+		int reason
+			= (le32_to_cpu(pEvReply->Data[0]) & 0x00FF0000) >> 16;
+
+		if (reason == MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED) {
+			int disk = (le32_to_cpu(pEvReply->Data[0]) & 0xFF000000) >> 24;
+			mpt_dv_raid(hd, disk);
+		}
+	}
+	return mptscsih_event_process(ioc, pEvReply);
+}
+
+static int
+mptspi_deny_binding(struct scsi_target *starget)
+{
+	struct _MPT_SCSI_HOST *hd =
+		(struct _MPT_SCSI_HOST *)dev_to_shost(starget->dev.parent)->hostdata;
+	return ((hd->ioc->raid_data.isRaid & (1 << starget->id)) &&
+		starget->channel == 0) ? 1 : 0;
+}
+
+static struct spi_function_template mptspi_transport_functions = {
+	.get_offset	= mptspi_read_parameters,
+	.set_offset	= mptspi_write_offset,
+	.show_offset	= 1,
+	.get_period	= mptspi_read_parameters,
+	.set_period	= mptspi_write_period,
+	.show_period	= 1,
+	.get_width	= mptspi_read_parameters,
+	.set_width	= mptspi_write_width,
+	.show_width	= 1,
+	.get_iu		= mptspi_read_parameters,
+	.set_iu		= mptspi_write_iu,
+	.show_iu	= 1,
+	.get_dt		= mptspi_read_parameters,
+	.set_dt		= mptspi_write_dt,
+	.show_dt	= 1,
+	.get_qas	= mptspi_read_parameters,
+	.set_qas	= mptspi_write_qas,
+	.show_qas	= 1,
+	.get_wr_flow	= mptspi_read_parameters,
+	.set_wr_flow	= mptspi_write_wr_flow,
+	.show_wr_flow	= 1,
+	.get_rd_strm	= mptspi_read_parameters,
+	.set_rd_strm	= mptspi_write_rd_strm,
+	.show_rd_strm	= 1,
+	.get_rti	= mptspi_read_parameters,
+	.set_rti	= mptspi_write_rti,
+	.show_rti	= 1,
+	.get_pcomp_en	= mptspi_read_parameters,
+	.set_pcomp_en	= mptspi_write_pcomp_en,
+	.show_pcomp_en	= 1,
+	.get_hold_mcs	= mptspi_read_parameters,
+	.set_hold_mcs	= mptspi_write_hold_mcs,
+	.show_hold_mcs	= 1,
+	.deny_binding	= mptspi_deny_binding,
+};
+
+static int mptspi_is_raid(struct device *dev) {
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct _MPT_SCSI_HOST *hd =
+		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
+
+	return ((hd->ioc->raid_data.isRaid & (1 << sdev->id)) &&
+		sdev->channel == 0) ? 1 : 0;
+}
+
+static void mptspi_get_resync(struct device *dev)
+{
+	struct {
+		MpiRaidActionReply_t r;
+		u32	pad[sizeof(MpiRaidVolIndicator_t)/sizeof(u32) - 1];
+	} buf;
+	u32 total, remain;
+	int shift;
+	MpiRaidVolIndicator_t *ri = (MpiRaidVolIndicator_t *)&buf.r.ActionData;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct _MPT_SCSI_HOST *hd =
+		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
+
+	if (mptscsih_raid_action(hd, MPI_RAID_ACTION_INDICATOR_STRUCT,
+				 sdev->id, 0, &buf.r, sizeof(buf)) < 0) {
+		dev_printk(KERN_ERR, &sdev->sdev_gendev,
+			   "Integrated RAID indicator failed\n");
+		return;
+	}
+	shift = fls(le32_to_cpu(ri->TotalBlocks.High));
+	if (shift > 0) {
+		total = le32_to_cpu(ri->TotalBlocks.Low) >> shift;
+		total |= le32_to_cpu(ri->TotalBlocks.High) << (32 - shift);
+		remain = le32_to_cpu(ri->BlocksRemaining.Low) >> shift;
+		remain |= le32_to_cpu(ri->BlocksRemaining.High) << (32 - shift);
+	} else {
+		total = le32_to_cpu(ri->TotalBlocks.Low);
+		remain = le32_to_cpu(ri->BlocksRemaining.Low);
+	}
+	total /= RAID_MAX_RESYNC;
+	remain /= RAID_MAX_RESYNC;
+	remain = total - remain;
+	remain *= RAID_MAX_RESYNC;
+	if (total)
+		raid_set_resync(mptspi_raid_template, dev, remain/total);
+	else
+		raid_set_resync(mptspi_raid_template, dev, 0);
+}
+
+static void mptspi_get_state(struct device *dev)
+{
+	MpiRaidActionReply_t r;
+	enum raid_state state = RAID_STATE_UNKNOWN;
+	u32 volstate;
+
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct _MPT_SCSI_HOST *hd =
+		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
+
+	if (mptscsih_raid_action(hd, MPI_RAID_ACTION_STATUS,
+				 sdev->id, 0, &r, sizeof(r)) < 0) {
+		dev_printk(KERN_ERR, &sdev->sdev_gendev,
+			   "Integrated RAID status failed\n");
+		return;
+	}
+
+	volstate = le32_to_cpu(r.VolumeStatus);
+
+	if (volstate & MPI_RAIDVOL0_STATUS_FLAG_RESYNC_IN_PROGRESS)
+		state = RAID_STATE_RESYNCING;
+	else
+		switch((volstate >> 8) & 0xff) {
+		case MPI_RAIDVOL0_STATUS_STATE_OPTIMAL:
+			state = RAID_STATE_ACTIVE;
+			break;
+		case  MPI_RAIDVOL0_STATUS_STATE_DEGRADED:
+			state = RAID_STATE_DEGRADED;
+			break;
+		case MPI_RAIDVOL0_STATUS_STATE_FAILED:
+		case MPI_RAIDVOL0_STATUS_STATE_MISSING:
+			state = RAID_STATE_OFFLINE;
+			break;
+		default:
+			dev_printk(KERN_ERR, &sdev->sdev_gendev,
+				   "Integrated RAID status unknown value = 0x%x\n", r.VolumeStatus);
+			break;
+		}
+	
+	raid_set_state(mptspi_raid_template, dev, state);
+}
+
+static struct raid_function_template mptspi_raid_functions = {
+	.cookie		= &mptspi_driver_template,
+	.is_raid	= mptspi_is_raid,
+	.get_resync	= mptspi_get_resync,
+	.get_state	= mptspi_get_state,
+};
+
 
 /****************************************************************************
  * Supported hardware
@@ -161,7 +756,7 @@ mptspi_probe(struct pci_dev *pdev, const
 	int			 ioc_cap;
 	u8			*mem;
 	int			error=0;
-	int			r;
+	int			i,r;
 
 	if ((r = mpt_attach(pdev,id)) != 0)
 		return r;
@@ -237,7 +832,10 @@ mptspi_probe(struct pci_dev *pdev, const
 	sh->max_id = MPT_MAX_SCSI_DEVICES;
 
 	sh->max_lun = MPT_LAST_LUN + 1;
-	sh->max_channel = 0;
+	if (ioc->raid_data.isRaid)
+		sh->max_channel = 1;
+	else
+		sh->max_channel = 0;
 	sh->this_id = ioc->pfacts[0].PortSCSIID;
 
 	/* Required entry.
@@ -300,7 +898,7 @@ mptspi_probe(struct pci_dev *pdev, const
 	 * indicates a device exists.
 	 * max_id = 1 + maximum id (hosts.h)
 	 */
-	sz = sh->max_id * sizeof(void *);
+	sz = sh->max_id * sizeof(void *) *(sh->max_channel + 1);
 	mem = kmalloc(sz, GFP_ATOMIC);
 	if (mem == NULL) {
 		error = -ENOMEM;
@@ -338,34 +936,12 @@ mptspi_probe(struct pci_dev *pdev, const
 	ioc->spi_data.Saf_Te = mpt_saf_te;
 	hd->mpt_pq_filter = mpt_pq_filter;
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-	if (ioc->spi_data.maxBusWidth > mpt_width)
-		ioc->spi_data.maxBusWidth = mpt_width;
-	if (ioc->spi_data.minSyncFactor < mpt_factor)
-		ioc->spi_data.minSyncFactor = mpt_factor;
-	if (ioc->spi_data.minSyncFactor == MPT_ASYNC) {
-		ioc->spi_data.maxSyncOffset = 0;
-	}
-	ioc->spi_data.mpt_dv = mpt_dv;
-	hd->negoNvram = 0;
-
-	ddvprintk((MYIOC_s_INFO_FMT
-		"dv %x width %x factor %x saf_te %x mpt_pq_filter %x\n",
-		ioc->name,
-		mpt_dv,
-		mpt_width,
-		mpt_factor,
-		mpt_saf_te,
-		mpt_pq_filter));
-#else
 	hd->negoNvram = MPT_SCSICFG_USE_NVRAM;
 	ddvprintk((MYIOC_s_INFO_FMT
 		"saf_te %x mpt_pq_filter %x\n",
 		ioc->name,
 		mpt_saf_te,
 		mpt_pq_filter));
-#endif
-
 	ioc->spi_data.forceDv = 0;
 	ioc->spi_data.noQas = 0;
 
@@ -381,6 +957,11 @@ mptspi_probe(struct pci_dev *pdev, const
 	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
 
+	/* Some versions of the firmware don't support page 0; without
+	 * that we can't get the parameters */
+	if (hd->ioc->spi_data.sdp0length != 0)
+		sh->transportt = mptspi_transport_template;
+
 	error = scsi_add_host (sh, &ioc->pcidev->dev);
 	if(error) {
 		dprintk((KERN_ERR MYNAM
@@ -389,6 +970,20 @@ mptspi_probe(struct pci_dev *pdev, const
 	}
 
 	scsi_scan_host(sh);
+	if (hd->ioc->raid_data.isRaid) {
+		/* now assemble the raid devices */
+		for (i = 0; i < hd->ioc->sh->max_id; i++) {
+			VirtDevice *vdev = mpt_target(hd, 1, i);
+			VirtDevice *vdev_raid;
+			if (!vdev)
+				break;
+			vdev_raid = mptscsih_find_raid_device(hd, 0, i);
+			if(vdev_raid != NULL)
+				raid_component_add(mptspi_raid_template,
+						   &vdev_raid->device->sdev_gendev,
+						   &vdev->device->sdev_gendev);
+		}
+	}
 	return 0;
 
 mptspi_probe_failed:
@@ -419,14 +1014,22 @@ static struct pci_driver mptspi_driver =
 static int __init
 mptspi_init(void)
 {
-
 	show_mptmod_ver(my_NAME, my_VERSION);
 
+	mptspi_transport_template = spi_attach_transport(&mptspi_transport_functions);
+	if (!mptspi_transport_template)
+		return -ENODEV;
+	mptspi_raid_template = raid_class_attach(&mptspi_raid_functions);
+	if (!mptspi_raid_template) {
+		spi_release_transport(mptspi_transport_template);
+		return -ENODEV;
+	}
+
 	mptspiDoneCtx = mpt_register(mptscsih_io_done, MPTSPI_DRIVER);
 	mptspiTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSPI_DRIVER);
 	mptspiInternalCtx = mpt_register(mptscsih_scandv_complete, MPTSPI_DRIVER);
 
-	if (mpt_event_register(mptspiDoneCtx, mptscsih_event_process) == 0) {
+	if (mpt_event_register(mptspiDoneCtx, mptspi_event_process) == 0) {
 		devtprintk((KERN_INFO MYNAM
 		  ": Registered for IOC event notifications\n"));
 	}
@@ -461,6 +1064,8 @@ mptspi_exit(void)
 	mpt_deregister(mptspiInternalCtx);
 	mpt_deregister(mptspiTaskCtx);
 	mpt_deregister(mptspiDoneCtx);
+	spi_release_transport(mptspi_transport_template);
+	raid_class_release(mptspi_raid_template);
 }
 
 module_init(mptspi_init);


