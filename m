From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 2/9] - fusion - move SPI API over to mptspi.c
Date: Mon, 29 Jan 2007 09:43:17 -0700
Message-ID: <20070129164317.GA1886@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60495 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbXA2Qmm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:42:42 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Move some functions that only apply to the mptspi module over from mptscsih.c

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:29.000000000 -0700
@@ -99,9 +99,6 @@ static int	mptscsih_IssueTaskMgmt(MPT_SC
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
-static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
-static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
-static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int channel, int id);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
@@ -2285,7 +2282,6 @@ mptscsih_slave_configure(struct scsi_dev
 	}
 
 	vdevice->configured_lun = 1;
-	mptscsih_initTarget(hd, vtarget, sdev);
 	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 
 	dsprintk((MYIOC_s_INFO_FMT
@@ -2549,286 +2545,6 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
- *	mptscsih_initTarget - Target, LUN alloc/free functionality.
- *	@hd: Pointer to MPT_SCSI_HOST structure
- *	@vtarget: per target private data
- *	@sdev: SCSI device
- *
- *	NOTE: It's only SAFE to call this routine if data points to
- *	sane & valid STANDARD INQUIRY data!
- *
- *	Allocate and initialize memory for this target.
- *	Save inquiry data.
- *
- */
-static void
-mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget,
-		    struct scsi_device *sdev)
-{
-	dinitprintk((MYIOC_s_INFO_FMT "initTarget channel=%d id=%d lun=%d hd=%p\n",
-		hd->ioc->name, vtarget->channel, vtarget->id,
-		sdev->lun, hd));
-
-	/* Is LUN supported? If so, upper 2 bits will be 0
-	* in first byte of inquiry data.
-	*/
-	if (sdev->inq_periph_qual != 0)
-		return;
-
-	if (vtarget == NULL)
-		return;
-
-	vtarget->type = sdev->type;
-
-	if (hd->ioc->bus_type != SPI)
-		return;
-
-	if ((sdev->type == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
-		/* Treat all Processors as SAF-TE if
-		 * command line option is set */
-		vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
-		mptscsih_writeIOCPage4(hd, vtarget->channel, vtarget->id);
-	}else if ((sdev->type == TYPE_PROCESSOR) &&
-		!(vtarget->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {
-		if (sdev->inquiry_len > 49 ) {
-			if (sdev->inquiry[44] == 'S' &&
-			    sdev->inquiry[45] == 'A' &&
-			    sdev->inquiry[46] == 'F' &&
-			    sdev->inquiry[47] == '-' &&
-			    sdev->inquiry[48] == 'T' &&
-			    sdev->inquiry[49] == 'E' ) {
-				vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
-				mptscsih_writeIOCPage4(hd, vtarget->channel, vtarget->id);
-			}
-		}
-	}
-	mptscsih_setTargetNegoParms(hd, vtarget, sdev);
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *  Update the target negotiation parameters based on the
- *  the Inquiry data, adapter capabilities, and NVRAM settings.
- *
- */
-static void
-mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target,
-			    struct scsi_device *sdev)
-{
-	SpiCfgData *pspi_data = &hd->ioc->spi_data;
-	int  id = (int) target->id;
-	int  nvram;
-	u8 width = MPT_NARROW;
-	u8 factor = MPT_ASYNC;
-	u8 offset = 0;
-	u8 nfactor;
-	u8 noQas = 1;
-
-	target->negoFlags = pspi_data->noQas;
-
-	/* noQas == 0 => device supports QAS. */
-
-	if (sdev->scsi_level < SCSI_2) {
-		width = 0;
-		factor = MPT_ULTRA2;
-		offset = pspi_data->maxSyncOffset;
-		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
-	} else {
-		if (scsi_device_wide(sdev)) {
-			width = 1;
-		}
-
-		if (scsi_device_sync(sdev)) {
-			factor = pspi_data->minSyncFactor;
-			if (!scsi_device_dt(sdev))
-					factor = MPT_ULTRA2;
-			else {
-				if (!scsi_device_ius(sdev) &&
-				    !scsi_device_qas(sdev))
-					factor = MPT_ULTRA160;
-				else {
-					factor = MPT_ULTRA320;
-					if (scsi_device_qas(sdev)) {
-						ddvtprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", scsi_device_qas(sdev), id));
-						noQas = 0;
-					}
-					if (sdev->type == TYPE_TAPE &&
-					    scsi_device_ius(sdev))
-						target->negoFlags |= MPT_TAPE_NEGO_IDP;
-				}
-			}
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
-	if (!sdev->tagged_supported) {
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
-	if (noQas && (pspi_data->noQas == 0)) {
-		pspi_data->noQas |= MPT_TARGET_NO_NEGO_QAS;
-		target->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
-
-		/* Disable QAS in a mixed configuration case
-		 */
-
-		ddvtprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
-	}
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *  SCSI Config Page functionality ...
- */
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*	mptscsih_writeIOCPage4  - write IOC Page 4
- *	@hd: Pointer to a SCSI Host Structure
- *	@channel: write IOC Page4 for this Bus
- *	@id: write IOC Page4 for this ID
- *
- *	Return: -EAGAIN if unable to obtain a Message Frame
- *		or 0 if success.
- *
- *	Remark: We do not wait for a return, write pages sequentially.
- */
-static int
-mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int channel, int id)
-{
-	MPT_ADAPTER		*ioc = hd->ioc;
-	Config_t		*pReq;
-	IOCPage4_t		*IOCPage4Ptr;
-	MPT_FRAME_HDR		*mf;
-	dma_addr_t		 dataDma;
-	u16			 req_idx;
-	u32			 frameOffset;
-	u32			 flagsLength;
-	int			 ii;
-
-	/* Get a MF for this command.
-	 */
-	if ((mf = mpt_get_msg_frame(ioc->DoneCtx, ioc)) == NULL) {
-		dfailprintk((MYIOC_s_WARN_FMT "writeIOCPage4 : no msg frames!\n",
-					ioc->name));
-		return -EAGAIN;
-	}
-
-	/* Set the request and the data pointers.
-	 * Place data at end of MF.
-	 */
-	pReq = (Config_t *)mf;
-
-	req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
-	frameOffset = ioc->req_sz - sizeof(IOCPage4_t);
-
-	/* Complete the request frame (same for all requests).
-	 */
-	pReq->Action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	pReq->Reserved = 0;
-	pReq->ChainOffset = 0;
-	pReq->Function = MPI_FUNCTION_CONFIG;
-	pReq->ExtPageLength = 0;
-	pReq->ExtPageType = 0;
-	pReq->MsgFlags = 0;
-	for (ii=0; ii < 8; ii++) {
-		pReq->Reserved2[ii] = 0;
-	}
-
-	IOCPage4Ptr = ioc->spi_data.pIocPg4;
-	dataDma = ioc->spi_data.IocPg4_dma;
-	ii = IOCPage4Ptr->ActiveSEP++;
-	IOCPage4Ptr->SEP[ii].SEPTargetID = id;
-	IOCPage4Ptr->SEP[ii].SEPBus = channel;
-	pReq->Header = IOCPage4Ptr->Header;
-	pReq->PageAddress = cpu_to_le32(id | (channel << 8 ));
-
-	/* Add a SGE to the config request.
-	 */
-	flagsLength = MPT_SGE_FLAGS_SSIMPLE_WRITE |
-		(IOCPage4Ptr->Header.PageLength + ii) * 4;
-
-	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
-
-	dinitprintk((MYIOC_s_INFO_FMT
-		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d channel=%d id=%d \n",
-			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, channel, id));
-
-	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
-
-	return 0;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
  *  Bus Scan and Domain Validation functionality ...
  */
 
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptspi.c	2007-01-28 12:57:29.000000000 -0700
@@ -95,6 +95,269 @@ static int	mptspiDoneCtx = -1;
 static int	mptspiTaskCtx = -1;
 static int	mptspiInternalCtx = -1; /* Used only for internal commands */
 
+/**
+ * 	mptspi_setTargetNegoParms  - Update the target negotiation
+ *	parameters based on the the Inquiry data, adapter capabilities,
+ *	and NVRAM settings
+ *
+ *	@hd: Pointer to a SCSI Host Structure
+ *	@vtarget: per target private data
+ *	@sdev: SCSI device
+ *
+ **/
+static void
+mptspi_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target,
+			    struct scsi_device *sdev)
+{
+	SpiCfgData *pspi_data = &hd->ioc->spi_data;
+	int  id = (int) target->id;
+	int  nvram;
+	u8 width = MPT_NARROW;
+	u8 factor = MPT_ASYNC;
+	u8 offset = 0;
+	u8 nfactor;
+	u8 noQas = 1;
+
+	target->negoFlags = pspi_data->noQas;
+
+	if (sdev->scsi_level < SCSI_2) {
+		width = 0;
+		factor = MPT_ULTRA2;
+		offset = pspi_data->maxSyncOffset;
+		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
+	} else {
+		if (scsi_device_wide(sdev))
+			width = 1;
+
+		if (scsi_device_sync(sdev)) {
+			factor = pspi_data->minSyncFactor;
+			if (!scsi_device_dt(sdev))
+					factor = MPT_ULTRA2;
+			else {
+				if (!scsi_device_ius(sdev) &&
+				    !scsi_device_qas(sdev))
+					factor = MPT_ULTRA160;
+				else {
+					factor = MPT_ULTRA320;
+					if (scsi_device_qas(sdev)) {
+						ddvprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", scsi_device_qas(sdev), id));
+						noQas = 0;
+					}
+					if (sdev->type == TYPE_TAPE &&
+					    scsi_device_ius(sdev))
+						target->negoFlags |= MPT_TAPE_NEGO_IDP;
+				}
+			}
+			offset = pspi_data->maxSyncOffset;
+
+			/* If RAID, never disable QAS
+			 * else if non RAID, do not disable
+			 *   QAS if bit 1 is set
+			 * bit 1 QAS support, non-raid only
+			 * bit 0 IU support
+			 */
+			if (target->raidVolume == 1)
+				noQas = 0;
+		} else {
+			factor = MPT_ASYNC;
+			offset = 0;
+		}
+	}
+
+	if (!sdev->tagged_supported)
+		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
+
+	/* Update tflags based on NVRAM settings. (SCSI only)
+	 */
+	if (pspi_data->nvram && (pspi_data->nvram[id] != MPT_HOST_NVRAM_INVALID)) {
+		nvram = pspi_data->nvram[id];
+		nfactor = (nvram & MPT_NVRAM_SYNC_MASK) >> 8;
+
+		if (width)
+			width = nvram & MPT_NVRAM_WIDE_DISABLE ? 0 : 1;
+
+		if (offset > 0) {
+			/* Ensure factor is set to the
+			 * maximum of: adapter, nvram, inquiry
+			 */
+			if (nfactor) {
+				if (nfactor < pspi_data->minSyncFactor )
+					nfactor = pspi_data->minSyncFactor;
+
+				factor = max(factor, nfactor);
+				if (factor == MPT_ASYNC)
+					offset = 0;
+			} else {
+				offset = 0;
+				factor = MPT_ASYNC;
+		}
+		} else {
+			factor = MPT_ASYNC;
+		}
+	}
+
+	/* Make sure data is consistent
+	 */
+	if ((!width) && (factor < MPT_ULTRA2))
+		factor = MPT_ULTRA2;
+
+	/* Save the data to the target structure.
+	 */
+	target->minSyncFactor = factor;
+	target->maxOffset = offset;
+	target->maxWidth = width;
+
+	target->tflags |= MPT_TARGET_FLAGS_VALID_NEGO;
+
+	/* Disable unused features.
+	 */
+	if (!width)
+		target->negoFlags |= MPT_TARGET_NO_NEGO_WIDE;
+
+	if (!offset)
+		target->negoFlags |= MPT_TARGET_NO_NEGO_SYNC;
+
+	if ( factor > MPT_ULTRA320 )
+		noQas = 0;
+
+	if (noQas && (pspi_data->noQas == 0)) {
+		pspi_data->noQas |= MPT_TARGET_NO_NEGO_QAS;
+		target->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
+
+		/* Disable QAS in a mixed configuration case
+		 */
+
+		ddvprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
+	}
+}
+
+/**
+ * 	mptspi_writeIOCPage4  - write IOC Page 4
+ *	@hd: Pointer to a SCSI Host Structure
+ *	@channel:
+ *	@id: write IOC Page4 for this ID & Bus
+ *
+ *	Return: -EAGAIN if unable to obtain a Message Frame
+ *		or 0 if success.
+ *
+ *	Remark: We do not wait for a return, write pages sequentially.
+ **/
+static int
+mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, u8 channel , u8 id)
+{
+	MPT_ADAPTER		*ioc = hd->ioc;
+	Config_t		*pReq;
+	IOCPage4_t		*IOCPage4Ptr;
+	MPT_FRAME_HDR		*mf;
+	dma_addr_t		 dataDma;
+	u16			 req_idx;
+	u32			 frameOffset;
+	u32			 flagsLength;
+	int			 ii;
+
+	/* Get a MF for this command.
+	 */
+	if ((mf = mpt_get_msg_frame(ioc->DoneCtx, ioc)) == NULL) {
+		dfailprintk((MYIOC_s_WARN_FMT "writeIOCPage4 : no msg frames!\n",
+					ioc->name));
+		return -EAGAIN;
+	}
+
+	/* Set the request and the data pointers.
+	 * Place data at end of MF.
+	 */
+	pReq = (Config_t *)mf;
+
+	req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
+	frameOffset = ioc->req_sz - sizeof(IOCPage4_t);
+
+	/* Complete the request frame (same for all requests).
+	 */
+	pReq->Action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	pReq->Reserved = 0;
+	pReq->ChainOffset = 0;
+	pReq->Function = MPI_FUNCTION_CONFIG;
+	pReq->ExtPageLength = 0;
+	pReq->ExtPageType = 0;
+	pReq->MsgFlags = 0;
+	for (ii=0; ii < 8; ii++) {
+		pReq->Reserved2[ii] = 0;
+	}
+
+	IOCPage4Ptr = ioc->spi_data.pIocPg4;
+	dataDma = ioc->spi_data.IocPg4_dma;
+	ii = IOCPage4Ptr->ActiveSEP++;
+	IOCPage4Ptr->SEP[ii].SEPTargetID = id;
+	IOCPage4Ptr->SEP[ii].SEPBus = channel;
+	pReq->Header = IOCPage4Ptr->Header;
+	pReq->PageAddress = cpu_to_le32(id | (channel << 8 ));
+
+	/* Add a SGE to the config request.
+	 */
+	flagsLength = MPT_SGE_FLAGS_SSIMPLE_WRITE |
+		(IOCPage4Ptr->Header.PageLength + ii) * 4;
+
+	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
+
+	ddvprintk((MYIOC_s_INFO_FMT
+		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d id=%d bus=%d\n",
+			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, id, channel));
+
+	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
+
+	return 0;
+}
+
+/**
+ *	mptspi_initTarget - Target, LUN alloc/free functionality.
+ *	@hd: Pointer to MPT_SCSI_HOST structure
+ *	@vtarget: per target private data
+ *	@sdev: SCSI device
+ *
+ *	NOTE: It's only SAFE to call this routine if data points to
+ *	sane & valid STANDARD INQUIRY data!
+ *
+ *	Allocate and initialize memory for this target.
+ *	Save inquiry data.
+ *
+ **/
+static void
+mptspi_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget,
+		    struct scsi_device *sdev)
+{
+
+	/* Is LUN supported? If so, upper 2 bits will be 0
+	* in first byte of inquiry data.
+	*/
+	if (sdev->inq_periph_qual != 0)
+		return;
+
+	if (vtarget == NULL)
+		return;
+
+	vtarget->type = sdev->type;
+
+	if ((sdev->type == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
+		/* Treat all Processors as SAF-TE if
+		 * command line option is set */
+		vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
+		mptspi_writeIOCPage4(hd, vtarget->channel, vtarget->id);
+	}else if ((sdev->type == TYPE_PROCESSOR) &&
+		!(vtarget->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {
+		if (sdev->inquiry_len > 49 ) {
+			if (sdev->inquiry[44] == 'S' &&
+			    sdev->inquiry[45] == 'A' &&
+			    sdev->inquiry[46] == 'F' &&
+			    sdev->inquiry[47] == '-' &&
+			    sdev->inquiry[48] == 'T' &&
+			    sdev->inquiry[49] == 'E' ) {
+				vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
+				mptspi_writeIOCPage4(hd, vtarget->channel, vtarget->id);
+			}
+		}
+	}
+	mptspi_setTargetNegoParms(hd, vtarget, sdev);
+}
 
 /**
  *	mptspi_is_raid - Determines whether target is belonging to volume
@@ -408,13 +671,16 @@ static int mptspi_slave_alloc(struct scs
 
 static int mptspi_slave_configure(struct scsi_device *sdev)
 {
-	int ret = mptscsih_slave_configure(sdev);
 	struct _MPT_SCSI_HOST *hd =
 		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
+	VirtTarget *vtarget = scsi_target(sdev)->hostdata;
+	int ret = mptscsih_slave_configure(sdev);
 
 	if (ret)
 		return ret;
 
+	mptspi_initTarget(hd, vtarget, sdev);
+
 	if ((sdev->channel == 1 ||
 	     !(mptspi_is_raid(hd, sdev->id))) &&
 	    !spi_initial_dv(sdev->sdev_target))
