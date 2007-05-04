From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8426] New: massive slowdown on SCSI CD/DVD
 drive connected to mptspi driver
Date: Thu, 3 May 2007 17:20:01 -0700
Message-ID: <20070503172001.617460e6.akpm@linux-foundation.org>
References: <200705032226.l43MQfl1029235@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423557AbXEDAUJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 20:20:09 -0400
In-Reply-To: <200705032226.l43MQfl1029235@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, doug.chapman@hp.com


(Switching to email - please use reply-to-all)

On Thu, 3 May 2007 15:26:41 -0700
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8426
> 
>            Summary: massive slowdown on SCSI CD/DVD drive connected to
>                     mptspi driver
>     Kernel Version: 2.6.21
>             Status: NEW
>           Severity: high
>              Owner: scsi_drivers-other@kernel-bugs.osdl.org
>          Submitter: doug.chapman@hp.com
> 
> 
> Most recent kernel where this bug did *NOT* occur:
> 2.6.20
> 
> Distribution:
> fedora 7 - test 4
> seen with fedora kernel and stock upstream 2.6.21 kernel as well
> 
> Hardware Environment:
> HP Integrity Superdome
> NEC  DVD_RW ND-3540A
> LSI Fusion MPT SPI SCSI adapter
> 
> also on:
> HP Integrity rx8640
> NEC DVD+RW ND-2100AD
> 
> 
> Software Environment: fedora 7 test 4
> 
> Problem Description:
> Reading CD/DVD is approx 150times slower than usual.  Simple test of:
> time cat kernel-2.6.20-1.3088.fc7.ia64.rpm > /dev/null
> 
> took approx 10 minutes on 2.6.21, took 2-4 seconds on 2.6.20 (same system, same
> disk, repeated multiple times to ensure it wasn't bad hardware)
> 
> 
> Steps to reproduce:
> mount a DVD
> read a large file from the DVD
> 
> 
> Appears to have been caused by this git commit:

Thanks heaps for doing the bisection - it really helps.

> commit 5a9c47b1344b514758d5d7f193c672850390cc36
> Author: Eric Moore <eric.moore@lsi.com>
> Date:   Mon Jan 29 09:43:17 2007 -0700
> 
>     [SCSI] fusion - move SPI API over to mptspi.c
> 
>     Move some functions that only apply to the mptspi module over from mptscsih.
>     Signed-off-by: Eric Moore <Eric.Moore@lsi.com>
>     Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> 
> 
> I backed out this patch against the current HEAD and DVD drive performance is
> back to normal.  I have not yet looked into this to determine exactly what in
> this patch caused the issue.

That's a bit surprising - all the patch allegedly does is move stuff
around.  Here's my version of a backout patch against 2.6.21 - can anyone
spot any bloopers in it?


 drivers/message/fusion/mptscsih.c |  284 ++++++++++++++++++++++++++++
 drivers/message/fusion/mptspi.c   |  268 --------------------------
 2 files changed, 285 insertions(+), 267 deletions(-)

diff -puN drivers/message/fusion/mptscsih.c~revert-fusion-move-spi-api-over-to-mptspic drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~revert-fusion-move-spi-api-over-to-mptspic
+++ a/drivers/message/fusion/mptscsih.c
@@ -98,6 +98,9 @@ static int	mptscsih_IssueTaskMgmt(MPT_SC
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
+static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
+static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
+static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int channel, int id);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
@@ -2410,6 +2413,7 @@ mptscsih_slave_configure(struct scsi_dev
 	}
 
 	vdevice->configured_lun = 1;
+	mptscsih_initTarget(hd, vtarget, sdev);
 	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 
 	dsprintk((MYIOC_s_INFO_FMT
@@ -2673,6 +2677,286 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
+ *	mptscsih_initTarget - Target, LUN alloc/free functionality.
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
+ */
+static void
+mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget,
+		    struct scsi_device *sdev)
+{
+	dinitprintk((MYIOC_s_INFO_FMT "initTarget channel=%d id=%d lun=%d hd=%p\n",
+		hd->ioc->name, vtarget->channel, vtarget->id,
+		sdev->lun, hd));
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
+	if (hd->ioc->bus_type != SPI)
+		return;
+
+	if ((sdev->type == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
+		/* Treat all Processors as SAF-TE if
+		 * command line option is set */
+		vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
+		mptscsih_writeIOCPage4(hd, vtarget->channel, vtarget->id);
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
+				mptscsih_writeIOCPage4(hd, vtarget->channel, vtarget->id);
+			}
+		}
+	}
+	mptscsih_setTargetNegoParms(hd, vtarget, sdev);
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+ *  Update the target negotiation parameters based on the
+ *  the Inquiry data, adapter capabilities, and NVRAM settings.
+ *
+ */
+static void
+mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target,
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
+	/* noQas == 0 => device supports QAS. */
+
+	if (sdev->scsi_level < SCSI_2) {
+		width = 0;
+		factor = MPT_ULTRA2;
+		offset = pspi_data->maxSyncOffset;
+		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
+	} else {
+		if (scsi_device_wide(sdev)) {
+			width = 1;
+		}
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
+						ddvtprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", scsi_device_qas(sdev), id));
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
+			if (target->raidVolume == 1) {
+				noQas = 0;
+			}
+		} else {
+			factor = MPT_ASYNC;
+			offset = 0;
+		}
+	}
+
+	if (!sdev->tagged_supported) {
+		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
+	}
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
+	if ((!width) && (factor < MPT_ULTRA2)) {
+		factor = MPT_ULTRA2;
+	}
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
+		ddvtprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
+	}
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+ *  SCSI Config Page functionality ...
+ */
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*	mptscsih_writeIOCPage4  - write IOC Page 4
+ *	@hd: Pointer to a SCSI Host Structure
+ *	@channel: write IOC Page4 for this Bus
+ *	@id: write IOC Page4 for this ID
+ *
+ *	Return: -EAGAIN if unable to obtain a Message Frame
+ *		or 0 if success.
+ *
+ *	Remark: We do not wait for a return, write pages sequentially.
+ */
+static int
+mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int channel, int id)
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
+	dinitprintk((MYIOC_s_INFO_FMT
+		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d channel=%d id=%d \n",
+			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, channel, id));
+
+	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
+
+	return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
  *  Bus Scan and Domain Validation functionality ...
  */
 
diff -puN drivers/message/fusion/mptspi.c~revert-fusion-move-spi-api-over-to-mptspic drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c~revert-fusion-move-spi-api-over-to-mptspic
+++ a/drivers/message/fusion/mptspi.c
@@ -95,269 +95,6 @@ static int	mptspiDoneCtx = -1;
 static int	mptspiTaskCtx = -1;
 static int	mptspiInternalCtx = -1; /* Used only for internal commands */
 
-/**
- * 	mptspi_setTargetNegoParms  - Update the target negotiation
- *	parameters based on the the Inquiry data, adapter capabilities,
- *	and NVRAM settings
- *
- *	@hd: Pointer to a SCSI Host Structure
- *	@vtarget: per target private data
- *	@sdev: SCSI device
- *
- **/
-static void
-mptspi_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target,
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
-	if (sdev->scsi_level < SCSI_2) {
-		width = 0;
-		factor = MPT_ULTRA2;
-		offset = pspi_data->maxSyncOffset;
-		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
-	} else {
-		if (scsi_device_wide(sdev))
-			width = 1;
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
-						ddvprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", scsi_device_qas(sdev), id));
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
-			if (target->raidVolume == 1)
-				noQas = 0;
-		} else {
-			factor = MPT_ASYNC;
-			offset = 0;
-		}
-	}
-
-	if (!sdev->tagged_supported)
-		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
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
-	if ((!width) && (factor < MPT_ULTRA2))
-		factor = MPT_ULTRA2;
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
-		ddvprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
-	}
-}
-
-/**
- * 	mptspi_writeIOCPage4  - write IOC Page 4
- *	@hd: Pointer to a SCSI Host Structure
- *	@channel:
- *	@id: write IOC Page4 for this ID & Bus
- *
- *	Return: -EAGAIN if unable to obtain a Message Frame
- *		or 0 if success.
- *
- *	Remark: We do not wait for a return, write pages sequentially.
- **/
-static int
-mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, u8 channel , u8 id)
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
-	ddvprintk((MYIOC_s_INFO_FMT
-		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d id=%d bus=%d\n",
-			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, id, channel));
-
-	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
-
-	return 0;
-}
-
-/**
- *	mptspi_initTarget - Target, LUN alloc/free functionality.
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
- **/
-static void
-mptspi_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget,
-		    struct scsi_device *sdev)
-{
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
-	if ((sdev->type == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
-		/* Treat all Processors as SAF-TE if
-		 * command line option is set */
-		vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
-		mptspi_writeIOCPage4(hd, vtarget->channel, vtarget->id);
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
-				mptspi_writeIOCPage4(hd, vtarget->channel, vtarget->id);
-			}
-		}
-	}
-	mptspi_setTargetNegoParms(hd, vtarget, sdev);
-}
 
 /**
  *	mptspi_is_raid - Determines whether target is belonging to volume
@@ -723,16 +460,13 @@ static int mptspi_slave_alloc(struct scs
 
 static int mptspi_slave_configure(struct scsi_device *sdev)
 {
+	int ret = mptscsih_slave_configure(sdev);
 	struct _MPT_SCSI_HOST *hd =
 		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
-	VirtTarget *vtarget = scsi_target(sdev)->hostdata;
-	int ret = mptscsih_slave_configure(sdev);
 
 	if (ret)
 		return ret;
 
-	mptspi_initTarget(hd, vtarget, sdev);
-
 	ddvprintk((MYIOC_s_INFO_FMT "id=%d min_period=0x%02x"
 		" max_offset=0x%02x max_width=%d\n", hd->ioc->name,
 		sdev->id, spi_min_period(scsi_target(sdev)),
_

