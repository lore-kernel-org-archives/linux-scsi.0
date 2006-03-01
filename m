From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/2] mptspi: Add transport class Domain Validation
Date: Wed, 01 Mar 2006 09:17:28 -0600
Message-ID: <1141226248.3276.23.camel@mulgrave.il.steeleye.com>
References: <1141225370.3276.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38280 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932115AbWCAPRc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 10:17:32 -0500
In-Reply-To: <1141225370.3276.20.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>

And this is the second piece

James

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -114,21 +114,6 @@ typedef struct _internal_cmd {
 	u8		rsvd;
 } INTERNAL_CMD;
 
-typedef struct _negoparms {
-	u8 width;
-	u8 offset;
-	u8 factor;
-	u8 flags;
-} NEGOPARMS;
-
-typedef struct _dv_parameters {
-	NEGOPARMS	 max;
-	NEGOPARMS	 now;
-	u8		 cmd;
-	u8		 id;
-	u16		 pad1;
-} DVPARAMETERS;
-
 /*
  *  Other private/forward protos...
  */
@@ -149,28 +134,12 @@ static int	mptscsih_IssueTaskMgmt(MPT_SC
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
-static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, u8 lun, char *data, int dlen);
-static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *vtarget, char byte56);
-static void	mptscsih_setDevicePage1Flags (u8 width, u8 factor, u8 offset, int *requestedPtr, int *configurationPtr, u8 flags);
-static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, struct scsi_cmnd *sc);
-static int	mptscsih_writeSDP1(MPT_SCSI_HOST *hd, int portnum, int target, int flags);
+static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
+static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
 static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, int bus);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
-static void	mptscsih_negotiate_to_asyn_narrow(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
-static int	mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);
-
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-static int	mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD *io);
-static void	mptscsih_domainValidation(void *hd);
-static void	mptscsih_qas_check(MPT_SCSI_HOST *hd, int id);
-static int	mptscsih_doDv(MPT_SCSI_HOST *hd, int channel, int target);
-static void	mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void *pPage);
-static void	mptscsih_fillbuf(char *buffer, int size, int index, int width);
-static void	mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id);
-static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, struct scsi_cmnd *sc);
-#endif
 
 void 		mptscsih_remove(struct pci_dev *);
 void 		mptscsih_shutdown(struct pci_dev *);
@@ -181,16 +150,6 @@ int 		mptscsih_resume(struct pci_dev *pd
 
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
@@ -687,9 +646,6 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			 */
 			sc->result = DID_RESET << 16;
 
-			/* GEM Workaround. */
-			if (ioc->bus_type == SPI)
-				mptscsih_no_negotiate(hd, sc);
 			break;
 
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
@@ -1005,10 +961,6 @@ mptscsih_remove(struct pci_dev *pdev)
 	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
 	struct Scsi_Host 	*host = ioc->sh;
 	MPT_SCSI_HOST		*hd;
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-	int 		 	count;
-	unsigned long	 	flags;
-#endif	
 	int sz1;
 
 	if(!host) {
@@ -1021,25 +973,6 @@ mptscsih_remove(struct pci_dev *pdev)
 	if((hd = (MPT_SCSI_HOST *)host->hostdata) == NULL)
 		return;
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-	/* Check DV thread active */
-	count = 10 * HZ;
-	spin_lock_irqsave(&dvtaskQ_lock, flags);
-	if (dvtaskQ_active) {
-		spin_unlock_irqrestore(&dvtaskQ_lock, flags);
-		while(dvtaskQ_active && --count)
-			schedule_timeout_interruptible(1);
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
@@ -1127,21 +1060,6 @@ mptscsih_resume(struct pci_dev *pdev)
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
 
@@ -1317,6 +1235,13 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	if (vdev->vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT &&
+	    mptscsih_raid_id_to_num(hd, SCpnt->device->id) < 0) {
+		SCpnt->result = DID_NO_CONNECT << 16;
+		done(SCpnt);
+		return 0;
+	}
+
 	/*
 	 *  Put together a MPT SCSI request...
 	 */
@@ -1363,7 +1288,10 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	pScsiReq->TargetID = (u8) vdev->target_id;
 	pScsiReq->Bus = vdev->bus_id;
 	pScsiReq->ChainOffset = 0;
-	pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
+	if (vdev->vtarget->tflags &  MPT_TARGET_FLAGS_RAID_COMPONENT)
+		pScsiReq->Function = MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH;
+	else
+		pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
 	pScsiReq->CDBLength = SCpnt->cmd_len;
 	pScsiReq->SenseBufferLength = MPT_SENSE_BUFFER_SIZE;
 	pScsiReq->Reserved = 0;
@@ -1411,49 +1339,6 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	hd->ScsiLookup[my_idx] = SCpnt;
 	SCpnt->host_scribble = NULL;
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-	if (hd->ioc->bus_type == SPI) {
-		int dvStatus = hd->ioc->spi_data.dvStatus[vdev->target_id];
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
-				mptscsih_set_dvflags(hd, SCpnt);
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
@@ -2218,6 +2103,24 @@ mptscsih_bios_param(struct scsi_device *
 	return 0;
 }
 
+int
+mptscsih_raid_id_to_num(MPT_SCSI_HOST *hd, uint physdiskid)
+{
+	int i;
+
+	if (!hd->ioc->raid_data.isRaid || !hd->ioc->raid_data.pIocPg3)
+		return -ENXIO;
+
+	for (i = 0; i < hd->ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
+		if (physdiskid ==
+		    hd->ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)
+			return hd->ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskNum;
+	}
+
+	return -ENXIO;
+}
+EXPORT_SYMBOL(mptscsih_raid_id_to_num);
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	OS entry point to allow host driver to alloc memory
@@ -2233,6 +2136,7 @@ mptscsih_target_alloc(struct scsi_target
 	if (!vtarget)
 		return -ENOMEM;
 	starget->hostdata = vtarget;
+	vtarget->starget = starget;
 	return 0;
 }
 
@@ -2266,6 +2170,7 @@ mptscsih_slave_alloc(struct scsi_device 
 
 	starget = scsi_target(sdev);
 	vtarget = starget->hostdata;
+
 	vdev->vtarget = vtarget;
 
 	if (vtarget->num_luns == 0) {
@@ -2274,14 +2179,11 @@ mptscsih_slave_alloc(struct scsi_device 
 		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES;
 		vtarget->target_id = sdev->id;
 		vtarget->bus_id = sdev->channel;
-		if (hd->ioc->bus_type == SPI) {
-			if (hd->ioc->raid_data.isRaid & (1 << sdev->id)) {
-				vtarget->raidVolume = 1;
-				ddvtprintk((KERN_INFO
+		if (hd->ioc->bus_type == SPI && sdev->channel == 0 &&
+		    hd->ioc->raid_data.isRaid & (1 << sdev->id)) {
+			vtarget->raidVolume = 1;
+			ddvtprintk((KERN_INFO
 				    "RAID Volume @ id %d\n", sdev->id));
-			}
-		} else {
-			vtarget->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
 		}
 	}
 	vtarget->num_luns++;
@@ -2321,19 +2223,6 @@ mptscsih_slave_destroy(struct scsi_devic
 	vtarget->luns[0] &= ~(1 << vdevice->lun);
 	vtarget->num_luns--;
 	if (vtarget->num_luns == 0) {
-		mptscsih_negotiate_to_asyn_narrow(hd, vdevice);
-		if (hd->ioc->bus_type == SPI) {
-			if (mptscsih_is_phys_disk(hd->ioc, vtarget->target_id)) {
-				hd->ioc->spi_data.forceDv |= MPT_SCSICFG_RELOAD_IOC_PG3;
-			} else {
-				hd->ioc->spi_data.dvStatus[vtarget->target_id] =
-					MPT_SCSICFG_NEGOTIATE;
-				if (!hd->negoNvram) {
-					hd->ioc->spi_data.dvStatus[vtarget->target_id] |=
-						MPT_SCSICFG_DV_NOT_DONE;
-				}
-			}
-		}
 		hd->Targets[sdev->id] = NULL;
 	}
 	mptscsih_synchronize_cache(hd, vdevice);
@@ -2362,18 +2251,13 @@ mptscsih_change_queue_depth(struct scsi_
 	vtarget = starget->hostdata;
 
 	if (hd->ioc->bus_type == SPI) {
-		if (vtarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {
-			if (!(vtarget->tflags & MPT_TARGET_FLAGS_Q_YES))
-				max_depth = 1;
-			else if (((vtarget->inq_data[0] & 0x1f) == 0x00) &&
-			         (vtarget->minSyncFactor <= MPT_ULTRA160 ))
-				max_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
-			else
-				max_depth = MPT_SCSI_CMD_PER_DEV_LOW;
-		} else {
-			/* error case - No Inq. Data */
+		if (!(vtarget->tflags & MPT_TARGET_FLAGS_Q_YES))
 			max_depth = 1;
-		}
+		else if (sdev->type == TYPE_DISK &&
+			 vtarget->minSyncFactor <= MPT_ULTRA160)
+			max_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
+		else
+			max_depth = MPT_SCSI_CMD_PER_DEV_LOW;
 	} else
 		max_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
 
@@ -2427,8 +2311,7 @@ mptscsih_slave_configure(struct scsi_dev
 	lun_index = (vdevice->lun >> 5);  /* 32 luns per lun_index */
 	indexed_lun = (vdevice->lun % 32);
 	vtarget->luns[lun_index] |= (1 << indexed_lun);
-	mptscsih_initTarget(hd, vtarget, sdev->lun, sdev->inquiry,
-	    sdev->inquiry_len );
+	mptscsih_initTarget(hd, vtarget, sdev);
 	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 
 	dsprintk((MYIOC_s_INFO_FMT
@@ -2597,10 +2480,6 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
 
 		/* 4. Renegotiate to all devices, if SPI
 		 */
-		if (ioc->bus_type == SPI) {
-			dnegoprintk(("writeSDP1: ALL_IDS USE_NVRAM\n"));
-			mptscsih_writeSDP1(hd, 0, 0, MPT_SCSICFG_ALL_IDS | MPT_SCSICFG_USE_NVRAM);
-		}
 
 		/* 5. Enable new commands to be posted
 		 */
@@ -2624,13 +2503,6 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
 			hd->cmdPtr = NULL;
 		}
 
-		/* 7. SPI: Set flag to force DV and re-read IOC Page 3
-		 */
-		if (ioc->bus_type == SPI) {
-			ioc->spi_data.forceDv = MPT_SCSICFG_NEED_DV | MPT_SCSICFG_RELOAD_IOC_PG3;
-			ddvtprintk(("Set reload IOC Pg3 Flag\n"));
-		}
-
 		/* 7. FC: Rescan for blocked rports which might have returned.
 		 */
 		else if (ioc->bus_type == FC) {
@@ -2699,18 +2571,7 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
 		break;
 
 	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */
-	{
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-		pMpiEventDataRaid_t pRaidEventData =
-		    (pMpiEventDataRaid_t) pEvReply->Data;
-		/* Domain Validation Needed */
-		if (ioc->bus_type == SPI &&
-		    pRaidEventData->ReasonCode ==
-		    MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED)
-			mptscsih_set_dvflags_raid(hd, pRaidEventData->PhysDiskNum);
-#endif
 		break;
-	}
 
 	case MPI_EVENT_NONE:				/* 00 */
 	case MPI_EVENT_LOG_DATA:			/* 01 */
@@ -2729,9 +2590,7 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
  *	mptscsih_initTarget - Target, LUN alloc/free functionality.
  *	@hd: Pointer to MPT_SCSI_HOST structure
  *	@vtarget: per target private data
- *	@lun: SCSI LUN id
- *	@data: Pointer to data
- *	@dlen: Number of INQUIRY bytes
+ *	@sdev: SCSI device
  *
  *	NOTE: It's only SAFE to call this routine if data points to
  *	sane & valid STANDARD INQUIRY data!
@@ -2741,98 +2600,46 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
  *
  */
 static void
-mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, u8 lun, char *data, int dlen)
+mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget,
+		    struct scsi_device *sdev)
 {
-	SpiCfgData	*pSpi;
-	char		data_56;
-	int		inq_len;
-
 	dinitprintk((MYIOC_s_INFO_FMT "initTarget bus=%d id=%d lun=%d hd=%p\n",
 		hd->ioc->name, vtarget->bus_id, vtarget->target_id, lun, hd));
 
-	/*
-	 * If the peripheral qualifier filter is enabled then if the target reports a 0x1
-	 * (i.e. The targer is capable of supporting the specified peripheral device type
-	 * on this logical unit; however, the physical device is not currently connected
-	 * to this logical unit) it will be converted to a 0x3 (i.e. The target is not
-	 * capable of supporting a physical device on this logical unit). This is to work
-	 * around a bug in th emid-layer in some distributions in which the mid-layer will
-	 * continue to try to communicate to the LUN and evntually create a dummy LUN.
-	*/
-	if (hd->mpt_pq_filter && dlen && (data[0] & 0xE0))
-		data[0] |= 0x40;
-
 	/* Is LUN supported? If so, upper 2 bits will be 0
 	* in first byte of inquiry data.
 	*/
-	if (data[0] & 0xe0)
+	if (sdev->inq_periph_qual != 0)
 		return;
 
 	if (vtarget == NULL)
 		return;
 
-	if (data)
-		vtarget->type = data[0];
+	vtarget->type = sdev->type;
 
 	if (hd->ioc->bus_type != SPI)
 		return;
 
-	if ((data[0] == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
+	if ((sdev->type == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
 		/* Treat all Processors as SAF-TE if
 		 * command line option is set */
 		vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
 		mptscsih_writeIOCPage4(hd, vtarget->target_id, vtarget->bus_id);
-	}else if ((data[0] == TYPE_PROCESSOR) &&
+	}else if ((sdev->type == TYPE_PROCESSOR) &&
 		!(vtarget->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {
-		if ( dlen > 49 ) {
-			vtarget->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
-			if ( data[44] == 'S' &&
-			     data[45] == 'A' &&
-			     data[46] == 'F' &&
-			     data[47] == '-' &&
-			     data[48] == 'T' &&
-			     data[49] == 'E' ) {
+		if (sdev->inquiry_len > 49 ) {
+			if (sdev->inquiry[44] == 'S' &&
+			    sdev->inquiry[45] == 'A' &&
+			    sdev->inquiry[46] == 'F' &&
+			    sdev->inquiry[47] == '-' &&
+			    sdev->inquiry[48] == 'T' &&
+			    sdev->inquiry[49] == 'E' ) {
 				vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
 				mptscsih_writeIOCPage4(hd, vtarget->target_id, vtarget->bus_id);
 			}
 		}
 	}
-	if (!(vtarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY)) {
-		inq_len = dlen < 8 ? dlen : 8;
-		memcpy (vtarget->inq_data, data, inq_len);
-		/* If have not done DV, set the DV flag.
-		 */
-		pSpi = &hd->ioc->spi_data;
-		if ((data[0] == TYPE_TAPE) || (data[0] == TYPE_PROCESSOR)) {
-			if (pSpi->dvStatus[vtarget->target_id] & MPT_SCSICFG_DV_NOT_DONE)
-				pSpi->dvStatus[vtarget->target_id] |= MPT_SCSICFG_NEED_DV;
-		}
-		vtarget->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
-
-		data_56 = 0x0F;  /* Default to full capabilities if Inq data length is < 57 */
-		if (dlen > 56) {
-			if ( (!(vtarget->tflags & MPT_TARGET_FLAGS_VALID_56))) {
-			/* Update the target capabilities
-			 */
-				data_56 = data[56];
-				vtarget->tflags |= MPT_TARGET_FLAGS_VALID_56;
-			}
-		}
-		mptscsih_setTargetNegoParms(hd, vtarget, data_56);
-	} else {
-		/* Initial Inquiry may not request enough data bytes to
-		 * obtain byte 57.  DV will; if target doesn't return
-		 * at least 57 bytes, data[56] will be zero. */
-		if (dlen > 56) {
-			if ( (!(vtarget->tflags & MPT_TARGET_FLAGS_VALID_56))) {
-			/* Update the target capabilities
-			 */
-				data_56 = data[56];
-				vtarget->tflags |= MPT_TARGET_FLAGS_VALID_56;
-				mptscsih_setTargetNegoParms(hd, vtarget, data_56);
-			}
-		}
-	}
+	mptscsih_setTargetNegoParms(hd, vtarget, sdev);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2842,66 +2649,51 @@ mptscsih_initTarget(MPT_SCSI_HOST *hd, V
  *
  */
 static void
-mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target, char byte56)
+mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target,
+			    struct scsi_device *sdev)
 {
 	SpiCfgData *pspi_data = &hd->ioc->spi_data;
 	int  id = (int) target->target_id;
 	int  nvram;
-	VirtTarget	*vtarget;
-	int ii;
 	u8 width = MPT_NARROW;
 	u8 factor = MPT_ASYNC;
 	u8 offset = 0;
-	u8 version, nfactor;
+	u8 nfactor;
 	u8 noQas = 1;
 
 	target->negoFlags = pspi_data->noQas;
 
-	/* noQas == 0 => device supports QAS. Need byte 56 of Inq to determine
-	 * support. If available, default QAS to off and allow enabling.
-	 * If not available, default QAS to on, turn off for non-disks.
-	 */
+	/* noQas == 0 => device supports QAS. */
 
-	/* Set flags based on Inquiry data
-	 */
-	version = target->inq_data[2] & 0x07;
-	if (version < 2) {
+	if (sdev->scsi_level < SCSI_2) {
 		width = 0;
 		factor = MPT_ULTRA2;
 		offset = pspi_data->maxSyncOffset;
 		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
 	} else {
-		if (target->inq_data[7] & 0x20) {
+		if (scsi_device_wide(sdev)) {
 			width = 1;
 		}
 
-		if (target->inq_data[7] & 0x10) {
+		if (scsi_device_sync(sdev)) {
 			factor = pspi_data->minSyncFactor;
-			if (target->tflags & MPT_TARGET_FLAGS_VALID_56) {
-				/* bits 2 & 3 show Clocking support */
-				if ((byte56 & 0x0C) == 0)
+			if (!scsi_device_dt(sdev))
 					factor = MPT_ULTRA2;
+			else {
+				if (!scsi_device_ius(sdev) &&
+				    !scsi_device_qas(sdev))
+					factor = MPT_ULTRA160;
 				else {
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
+					factor = MPT_ULTRA320;
+					if (scsi_device_qas(sdev)) {
+						ddvtprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", byte56, id));
+						noQas = 0;
 					}
+					if (sdev->type == TYPE_TAPE &&
+					    scsi_device_ius(sdev))
+						target->negoFlags |= MPT_TAPE_NEGO_IDP;
 				}
-			} else {
-				ddvtprintk((KERN_INFO "Enabling QAS on id=%d due to ~TARGET_FLAGS_VALID_56!\n", id));
-				noQas = 0;
 			}
-
 			offset = pspi_data->maxSyncOffset;
 
 			/* If RAID, never disable QAS
@@ -2919,7 +2711,7 @@ mptscsih_setTargetNegoParms(MPT_SCSI_HOS
 		}
 	}
 
-	if ( (target->inq_data[7] & 0x02) == 0) {
+	if (!sdev->tagged_supported) {
 		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
 	}
 
@@ -2977,55 +2769,18 @@ mptscsih_setTargetNegoParms(MPT_SCSI_HOS
 	if ( factor > MPT_ULTRA320 )
 		noQas = 0;
 
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
-				if ( (vtarget = hd->Targets[ii]) ) {
-					vtarget->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
-					mptscsih_writeSDP1(hd, 0, ii, vtarget->negoFlags);
-				}
-			}
-		}
-	}
+	if (noQas && (pspi_data->noQas == 0)) {
+		pspi_data->noQas |= MPT_TARGET_NO_NEGO_QAS;
+		target->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
+
+		/* Disable QAS in a mixed configuration case
+		 */
 
-	/* Write SDP1 on this I/O to this target */
-	if (pspi_data->dvStatus[id] & MPT_SCSICFG_NEGOTIATE) {
-		ddvtprintk((KERN_INFO "MPT_SCSICFG_NEGOTIATE on id=%d!\n", id));
-		mptscsih_writeSDP1(hd, 0, id, hd->negoNvram);
-		pspi_data->dvStatus[id] &= ~MPT_SCSICFG_NEGOTIATE;
-	} else if (pspi_data->dvStatus[id] & MPT_SCSICFG_BLK_NEGO) {
-		ddvtprintk((KERN_INFO "MPT_SCSICFG_BLK_NEGO on id=%d!\n", id));
-		mptscsih_writeSDP1(hd, 0, id, MPT_SCSICFG_BLK_NEGO);
-		pspi_data->dvStatus[id] &= ~MPT_SCSICFG_BLK_NEGO;
+		ddvtprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
 	}
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- * If no Target, bus reset on 1st I/O. Set the flag to
- * prevent any future negotiations to this device.
- */
-static void
-mptscsih_no_negotiate(MPT_SCSI_HOST *hd, struct scsi_cmnd *sc)
-{
-	VirtDevice	*vdev;
-
-	if ((vdev = sc->device->hostdata) != NULL)
-		hd->ioc->spi_data.dvStatus[vdev->target_id] |= MPT_SCSICFG_BLK_NEGO;
-	return;
-}
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -3077,207 +2832,6 @@ mptscsih_setDevicePage1Flags (u8 width, 
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*	mptscsih_writeSDP1  - write SCSI Device Page 1
- *	@hd: Pointer to a SCSI Host Strucutre
- *	@portnum: IOC port number
- *	@target_id: writeSDP1 for single ID
- *	@flags: MPT_SCSICFG_ALL_IDS, MPT_SCSICFG_USE_NVRAM, MPT_SCSICFG_BLK_NEGO
- *
- *	Return: -EFAULT if read of config page header fails
- *		or 0 if success.
- *
- *	Remark: If a target has been found, the settings from the
- *		target structure are used, else the device is set
- *		to async/narrow.
- *
- *	Remark: Called during init and after a FW reload.
- *	Remark: We do not wait for a return, write pages sequentially.
- */
-static int
-mptscsih_writeSDP1(MPT_SCSI_HOST *hd, int portnum, int target_id, int flags)
-{
-	MPT_ADAPTER		*ioc = hd->ioc;
-	Config_t		*pReq;
-	SCSIDevicePage1_t	*pData;
-	VirtTarget		*vtarget=NULL;
-	MPT_FRAME_HDR		*mf;
-	dma_addr_t		 dataDma;
-	u16			 req_idx;
-	u32			 frameOffset;
-	u32			 requested, configuration, flagsLength;
-	int			 ii, nvram;
-	int			 id = 0, maxid = 0;
-	u8			 width;
-	u8			 factor;
-	u8			 offset;
-	u8			 bus = 0;
-	u8			 negoFlags;
-	u8			 maxwidth, maxoffset, maxfactor;
-
-	if (ioc->spi_data.sdp1length == 0)
-		return 0;
-
-	if (flags & MPT_SCSICFG_ALL_IDS) {
-		id = 0;
-		maxid = ioc->sh->max_id - 1;
-	} else if (ioc->sh) {
-		id = target_id;
-		maxid = min_t(int, id, ioc->sh->max_id - 1);
-	}
-
-	for (; id <= maxid; id++) {
-
-		if (id == ioc->pfacts[portnum].PortSCSIID)
-			continue;
-
-		/* Use NVRAM to get adapter and target maximums
-		 * Data over-riden by target structure information, if present
-		 */
-		maxwidth = ioc->spi_data.maxBusWidth;
-		maxoffset = ioc->spi_data.maxSyncOffset;
-		maxfactor = ioc->spi_data.minSyncFactor;
-		if (ioc->spi_data.nvram && (ioc->spi_data.nvram[id] != MPT_HOST_NVRAM_INVALID)) {
-			nvram = ioc->spi_data.nvram[id];
-
-			if (maxwidth)
-				maxwidth = nvram & MPT_NVRAM_WIDE_DISABLE ? 0 : 1;
-
-			if (maxoffset > 0) {
-				maxfactor = (nvram & MPT_NVRAM_SYNC_MASK) >> 8;
-				if (maxfactor == 0) {
-					/* Key for async */
-					maxfactor = MPT_ASYNC;
-					maxoffset = 0;
-				} else if (maxfactor < ioc->spi_data.minSyncFactor) {
-					maxfactor = ioc->spi_data.minSyncFactor;
-				}
-			} else
-				maxfactor = MPT_ASYNC;
-		}
-
-		/* Set the negotiation flags.
-		 */
-		negoFlags = ioc->spi_data.noQas;
-		if (!maxwidth)
-			negoFlags |= MPT_TARGET_NO_NEGO_WIDE;
-
-		if (!maxoffset)
-			negoFlags |= MPT_TARGET_NO_NEGO_SYNC;
-
-		if (flags & MPT_SCSICFG_USE_NVRAM) {
-			width = maxwidth;
-			factor = maxfactor;
-			offset = maxoffset;
-		} else {
-			width = 0;
-			factor = MPT_ASYNC;
-			offset = 0;
-			//negoFlags = 0;
-			//negoFlags = MPT_TARGET_NO_NEGO_SYNC;
-		}
-
-		/* If id is not a raid volume, get the updated
-		 * transmission settings from the target structure.
-		 */
-		if (hd->Targets && (vtarget = hd->Targets[id]) && !vtarget->raidVolume) {
-			width = vtarget->maxWidth;
-			factor = vtarget->minSyncFactor;
-			offset = vtarget->maxOffset;
-			negoFlags = vtarget->negoFlags;
-		}
-
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
-		if (flags & MPT_SCSICFG_BLK_NEGO)
-			negoFlags |= MPT_TARGET_NO_NEGO_WIDE | MPT_TARGET_NO_NEGO_SYNC;
-
-		mptscsih_setDevicePage1Flags(width, factor, offset,
-					&requested, &configuration, negoFlags);
-		dnegoprintk(("writeSDP1: id=%d width=%d factor=%x offset=%x negoFlags=%x request=%x config=%x\n",
-			target_id, width, factor, offset, negoFlags, requested, configuration));
-
-		/* Get a MF for this command.
-		 */
-		if ((mf = mpt_get_msg_frame(ioc->DoneCtx, ioc)) == NULL) {
-			dfailprintk((MYIOC_s_WARN_FMT "write SDP1: no msg frames!\n",
-				ioc->name));
-			return -EAGAIN;
-		}
-
-		ddvprintk((MYIOC_s_INFO_FMT "WriteSDP1 (mf=%p, id=%d, req=0x%x, cfg=0x%x)\n",
-			hd->ioc->name, mf, id, requested, configuration));
-
-
-		/* Set the request and the data pointers.
-		 * Request takes: 36 bytes (32 bit SGE)
-		 * SCSI Device Page 1 requires 16 bytes
-		 * 40 + 16 <= size of SCSI IO Request = 56 bytes
-		 * and MF size >= 64 bytes.
-		 * Place data at end of MF.
-		 */
-		pReq = (Config_t *)mf;
-
-		req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
-		frameOffset = ioc->req_sz - sizeof(SCSIDevicePage1_t);
-
-		pData = (SCSIDevicePage1_t *)((u8 *) mf + frameOffset);
-		dataDma = ioc->req_frames_dma + (req_idx * ioc->req_sz) + frameOffset;
-
-		/* Complete the request frame (same for all requests).
-		 */
-		pReq->Action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-		pReq->Reserved = 0;
-		pReq->ChainOffset = 0;
-		pReq->Function = MPI_FUNCTION_CONFIG;
-		pReq->ExtPageLength = 0;
-		pReq->ExtPageType = 0;
-		pReq->MsgFlags = 0;
-		for (ii=0; ii < 8; ii++) {
-			pReq->Reserved2[ii] = 0;
-		}
-		pReq->Header.PageVersion = ioc->spi_data.sdp1version;
-		pReq->Header.PageLength = ioc->spi_data.sdp1length;
-		pReq->Header.PageNumber = 1;
-		pReq->Header.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
-		pReq->PageAddress = cpu_to_le32(id | (bus << 8 ));
-
-		/* Add a SGE to the config request.
-		 */
-		flagsLength = MPT_SGE_FLAGS_SSIMPLE_WRITE | ioc->spi_data.sdp1length * 4;
-
-		mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
-
-		/* Set up the common data portion
-		 */
-		pData->Header.PageVersion = pReq->Header.PageVersion;
-		pData->Header.PageLength = pReq->Header.PageLength;
-		pData->Header.PageNumber = pReq->Header.PageNumber;
-		pData->Header.PageType = pReq->Header.PageType;
-		pData->RequestedParameters = cpu_to_le32(requested);
-		pData->Reserved = 0;
-		pData->Configuration = cpu_to_le32(configuration);
-
-		dprintk((MYIOC_s_INFO_FMT
-			"write SDP1: id %d pgaddr 0x%x req 0x%x config 0x%x\n",
-				ioc->name, id, (id | (bus<<8)),
-				requested, configuration));
-
-		mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
-	}
-
-	return 0;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*	mptscsih_writeIOCPage4  - write IOC Page 4
  *	@hd: Pointer to a SCSI Host Structure
  *	@target_id: write IOC Page4 for this ID & Bus
@@ -3465,6 +3019,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 					completionCode = MPT_SCANDV_GOOD;
 				else
 					completionCode = MPT_SCANDV_SOME_ERROR;
+				memcpy(hd->pLocal->sense, pr, sizeof(hd->pLocal->sense));
 
 			} else if (pReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID) {
 				u8		*sense_data;
@@ -3578,78 +3133,6 @@ mptscsih_timer_expired(unsigned long dat
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
@@ -3903,93 +3386,6 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_negotiate_to_asyn_narrow - Restore devices to default state
- *	@hd: Pointer to a SCSI HOST structure
- *	@vtarget: per device private data
- *
- *	Uses the ISR, but with special processing.
- *	MUST be single-threaded.
- *
- */
-static void
-mptscsih_negotiate_to_asyn_narrow(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
-{
-	VirtTarget		*vtarget = vdevice->vtarget;
-	MPT_ADAPTER		*ioc= hd->ioc;
-	SCSIDevicePage1_t	*pcfg1Data;
-	CONFIGPARMS		 cfg;
-	dma_addr_t		 cfg1_dma_addr;
-	ConfigPageHeader_t	 header;
-	int			 id;
-	int			 requested, configuration, data,i;
-	u8			 flags, factor;
-
-	if ((ioc->bus_type != SPI) ||
-		(!vdevice->configured_lun))
-		return;
-
-	if (!ioc->spi_data.sdp1length)
-		return;
-
-	pcfg1Data = (SCSIDevicePage1_t *)pci_alloc_consistent(ioc->pcidev,
-		 ioc->spi_data.sdp1length * 4, &cfg1_dma_addr);
-
-	if (pcfg1Data == NULL)
-		return;
-
-	header.PageVersion = ioc->spi_data.sdp1version;
-	header.PageLength = ioc->spi_data.sdp1length;
-	header.PageNumber = 1;
-	header.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
-	cfg.cfghdr.hdr = &header;
-	cfg.physAddr = cfg1_dma_addr;
-	cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	cfg.dir = 1;
-	cfg.timeout = 0;
-
-	if (vtarget->raidVolume && ioc->raid_data.pIocPg3) {
-		for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
-			id = ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID;
-			flags = hd->ioc->spi_data.noQas;
-			if (hd->ioc->spi_data.nvram && (hd->ioc->spi_data.nvram[id] != MPT_HOST_NVRAM_INVALID)) {
-				data = hd->ioc->spi_data.nvram[id];
-				if (data & MPT_NVRAM_WIDE_DISABLE)
-					flags |= MPT_TARGET_NO_NEGO_WIDE;
-				factor = (data & MPT_NVRAM_SYNC_MASK) >> MPT_NVRAM_SYNC_SHIFT;
-				if ((factor == 0) || (factor == MPT_ASYNC))
-					flags |= MPT_TARGET_NO_NEGO_SYNC;
-			}
-			mptscsih_setDevicePage1Flags(0, MPT_ASYNC, 0, &requested,
-				&configuration, flags);
-			dnegoprintk(("nego asyn narrow: id=%d width=0 factor=MPT_ASYNC "
-				"offset=0 negoFlags=%x request=%x config=%x\n",
-				id, flags, requested, configuration));
-			pcfg1Data->RequestedParameters = cpu_to_le32(requested);
-			pcfg1Data->Reserved = 0;
-			pcfg1Data->Configuration = cpu_to_le32(configuration);
-			cfg.pageAddr = (vtarget->bus_id<<8) | id;
-			mpt_config(hd->ioc, &cfg);
-		}
-	} else {
-		flags = vtarget->negoFlags;
-		mptscsih_setDevicePage1Flags(0, MPT_ASYNC, 0, &requested,
-				&configuration, flags);
-		dnegoprintk(("nego asyn narrow: id=%d width=0 factor=MPT_ASYNC "
-			"offset=0 negoFlags=%x request=%x config=%x\n",
-			vtarget->target_id, flags, requested, configuration));
-		pcfg1Data->RequestedParameters = cpu_to_le32(requested);
-		pcfg1Data->Reserved = 0;
-		pcfg1Data->Configuration = cpu_to_le32(configuration);
-		cfg.pageAddr = (vtarget->bus_id<<8) | vtarget->target_id;
-		mpt_config(hd->ioc, &cfg);
-	}
-
-	if (pcfg1Data)
-		pci_free_consistent(ioc->pcidev, header.PageLength * 4, pcfg1Data, cfg1_dma_addr);
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
  *	mptscsih_synchronize_cache - Send SYNCHRONIZE_CACHE to all disks.
  *	@hd: Pointer to a SCSI HOST structure
  *	@vtarget: per device private data
@@ -4018,1633 +3414,11 @@ mptscsih_synchronize_cache(MPT_SCSI_HOST
 	iocmd.id = vdevice->target_id;
 	iocmd.lun = (u8)vdevice->lun;
 
-	if ((vdevice->vtarget->type & TYPE_DISK) &&
+	if ((vdevice->vtarget->type == TYPE_DISK) &&
 	    (vdevice->configured_lun))
 		mptscsih_do_cmd(hd, &iocmd);
 }
 
-/* Search IOC page 3 to determine if this is hidden physical disk
- */
-static int
-mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)
-{
-	int i;
-
-	if (!ioc->raid_data.isRaid || !ioc->raid_data.pIocPg3)
-		return 0;
-
-	for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
-		if (id == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)
-			return 1;
-	}
-
-	return 0;
-}
-
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
-			/* DV only to SPI adapters */
-			if (ioc->bus_type != SPI)
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
-					if(mpt_alt_ioc_wait(hd->ioc)!=0) {
-						ddvprintk((MYIOC_s_WARN_FMT "alt_ioc busy!\n",
-						    hd->ioc->name));
-						continue;
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
-					spin_lock(&hd->ioc->initializing_hba_lock);
-					hd->ioc->initializing_hba_lock_flag=0;
-					spin_unlock(&hd->ioc->initializing_hba_lock);
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
-/* Write SDP1 if no QAS has been enabled
- */
-static void
-mptscsih_qas_check(MPT_SCSI_HOST *hd, int id)
-{
-	VirtTarget *vtarget;
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
-
-		vtarget = hd->Targets[ii];
-
-		if ((vtarget != NULL) && (!vtarget->raidVolume)) {
-			if ((vtarget->negoFlags & hd->ioc->spi_data.noQas) == 0) {
-				vtarget->negoFlags |= hd->ioc->spi_data.noQas;
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
-	VirtTarget		*vtarget;
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
-	vtarget = hd->Targets[id];
-
-	/* Use tagged commands if possible.
-	 */
-	if (vtarget) {
-		if (vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
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
-	 */
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
-	}
-
-	/* RAID Volume ID's may double for a physical device. If RAID but
-	 * not a physical ID as well, skip DV.
-	 */
-	if ((hd->ioc->raid_data.isRaid & (1 << id)) && !(iocmd.flags & MPT_ICFLAG_PHYS_DISK))
-		goto target_done;
-
-
-	/* Basic Test.
-	 * Async & Narrow - Inquiry
-	 * Async & Narrow - Inquiry
-	 * Maximum transfer rate - Inquiry
-	 * Compare buffers:
-	 *	If compare, test complete.
-	 *	If miscompare and first pass, repeat
-	 *	If miscompare and not first pass, fall back and repeat
-	 */
-	hd->pLocal = NULL;
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
-		if ((inq0 == 0) && vtarget && !vtarget->raidVolume) {
-			sz = 0x40;
-			iocmd.size = sz;
-		}
-
-		/* Another GEM workaround. Check peripheral device type,
-		 * if PROCESSOR, quit DV.
-		 */
-		if (inq0 == TYPE_PROCESSOR) {
-			mptscsih_initTarget(hd,
-				vtarget,
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
-			if ((vtarget->maxWidth == 1) && (vtarget->maxOffset) && (nfactor < 0x0A)
-				&& (vtarget->minSyncFactor > 0x09)) {
-				if ((pbuf1[56] & 0x04) == 0)
-					;
-				else if ((pbuf1[56] & 0x01) == 1) {
-					vtarget->minSyncFactor =
-					    nfactor > MPT_ULTRA320 ? nfactor : MPT_ULTRA320;
-				} else {
-					vtarget->minSyncFactor =
-					    nfactor > MPT_ULTRA160 ? nfactor : MPT_ULTRA160;
-				}
-
-				dv.max.factor = vtarget->minSyncFactor;
-
-				if ((pbuf1[56] & 0x02) == 0) {
-					vtarget->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
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
-							vtarget,
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
-
-	/* Set if cfg1_dma_addr contents is valid
-	 */
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
-
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
-
-	/* If this is a RAID Passthrough, enable internal IOs
-	 */
-	if (iocmd.flags & MPT_ICFLAG_PHYS_DISK) {
-		if (mptscsih_do_raid(hd, MPI_RAID_ACTION_ENABLE_PHYS_IO, &iocmd) < 0)
-			ddvprintk((MYIOC_s_ERR_FMT "RAID Enable FAILED!\n", ioc->name));
-	}
-
-	/* Done with the DV scan of the current target
-	 */
-	if (pDvBuf)
-		pci_free_consistent(ioc->pcidev, dv_alloc, pDvBuf, dvbuf_dma);
-
-	ddvtprintk((MYIOC_s_INFO_FMT "DV Done id=%d\n",
-			ioc->name, id));
-
-	return retcode;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*	mptscsih_dv_parms - perform a variety of operations on the
- *	parameters used for negotiation.
- *	@hd: Pointer to a SCSI host.
- *	@dv: Pointer to a structure that contains the maximum and current
- *		negotiated parameters.
- */
-static void
-mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void *pPage)
-{
-	VirtTarget		*vtarget;
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
-		if ((hd->Targets)&&((vtarget = hd->Targets[(int)id]) != NULL) && !vtarget->raidVolume) {
-			width = vtarget->maxWidth;
-			offset = vtarget->maxOffset;
-			factor = vtarget->minSyncFactor;
-			negoFlags |= vtarget->negoFlags;
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
-		if ((hd->Targets)&&((vtarget = hd->Targets[(int)id]) != NULL) && !vtarget->raidVolume ) {
-			vtarget->maxWidth = dv->now.width;
-			vtarget->maxOffset = dv->now.offset;
-			vtarget->minSyncFactor = dv->now.factor;
-			vtarget->negoFlags = dv->now.flags;
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
-
-				data &= ~MPT_NVRAM_SYNC_MASK;
-				data |= (dv->now.factor << MPT_NVRAM_SYNC_SHIFT) & MPT_NVRAM_SYNC_MASK;
-
-				hd->ioc->spi_data.nvram[id] = data;
-			}
-		}
-		break;
-	}
-}
-
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
-{
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
-
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
-
-				/* Flip the pattern every 32 bytes
-				 */
-				if (ii & 0x20)
-					*ptr = ~(*ptr);
-			}
-		}
-		break;
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
-mptscsih_set_dvflags(MPT_SCSI_HOST *hd, struct scsi_cmnd *sc)
-{
-	MPT_ADAPTER	*ioc = hd->ioc;
-	u8 cmd;
-	SpiCfgData	*pSpi;
-
-	ddvtprintk((MYIOC_s_NOTE_FMT
-		" set_dvflags: id=%d lun=%d negoNvram=%x cmd=%x\n",
-		hd->ioc->name, sc->device->id, sc->device->lun , hd->negoNvram, sc->cmnd[0]));
-
-	if ((sc->device->lun != 0) || (hd->negoNvram != 0))
-		return;
-
-	cmd = sc->cmnd[0];
-
-	if ((cmd == READ_CAPACITY) || (cmd == MODE_SENSE)) {
-		pSpi = &ioc->spi_data;
-		if ((ioc->raid_data.isRaid & (1 << sc->device->id)) && ioc->raid_data.pIocPg3) {
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
-		pSpi->dvStatus[sc->device->id] |= MPT_SCSICFG_NEED_DV;
-		ddvtprintk(("NEED_DV set for visible disk id %d\n", sc->device->id));
-	}
-}
-
-/* mptscsih_raid_set_dv_flags()
- *
- * New or replaced disk. Set DV flag and schedule DV.
- */
-static void
-mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id)
-{
-	MPT_ADAPTER	*ioc = hd->ioc;
-	SpiCfgData	*pSpi = &ioc->spi_data;
-	Ioc3PhysDisk_t	*pPDisk;
-	int		 numPDisk;
-
-	if (hd->negoNvram != 0)
-		return;
-
-	ddvtprintk(("DV requested for phys disk id %d\n", id));
-	if (ioc->raid_data.pIocPg3) {
-		pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
-		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
-		while (numPDisk) {
-			if (id == pPDisk->PhysDiskNum) {
-				pSpi->dvStatus[pPDisk->PhysDiskID] =
-				    (MPT_SCSICFG_NEED_DV | MPT_SCSICFG_DV_NOT_DONE);
-				pSpi->forceDv = MPT_SCSICFG_NEED_DV;
-				ddvtprintk(("NEED_DV set for phys disk id %d\n",
-				    pPDisk->PhysDiskID));
-				break;
-			}
-			pPDisk++;
-			numPDisk--;
-		}
-
-		if (numPDisk == 0) {
-			/* The physical disk that needs DV was not found
-			 * in the stored IOC Page 3. The driver must reload
-			 * this page. DV routine will set the NEED_DV flag for
-			 * all phys disks that have DV_NOT_DONE set.
-			 */
-			pSpi->forceDv = MPT_SCSICFG_NEED_DV | MPT_SCSICFG_RELOAD_IOC_PG3;
-			ddvtprintk(("phys disk %d not found. Setting reload IOC Pg3 Flag\n",id));
-		}
-	}
-}
-#endif /* ~MPTSCSIH_ENABLE_DOMAIN_VALIDATION */
-
 EXPORT_SYMBOL(mptscsih_remove);
 EXPORT_SYMBOL(mptscsih_shutdown);
 #ifdef CONFIG_PM


