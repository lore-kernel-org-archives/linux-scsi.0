From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 6/9] mptfusion: task abort fix's
Date: Tue, 11 Jul 2006 17:32:33 -0600
Message-ID: <20060711233233.GA8622@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55762 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932257AbWGKXp3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 19:45:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Fix's to insure proper status is returned to midlayer
when a task abort failed to be aborted by controller 
firmware.

Also sanity checks to prevent scsi cmd from being
double completed during error recovery.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-07-11 12:10:21.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-07-11 12:56:42.000000000 -0600
@@ -307,8 +307,8 @@ typedef struct _SYSIF_REGS
 	u32	HostIndex;	/* 50     Host Index register        */
 	u32	Reserved4[15];	/* 54-8F                             */
 	u32	Fubar;		/* 90     For Fubar usage            */
-	u32     Reserved5[1050];/* 94-10F8                           */
-	u32     Reset_1078;     /* 10FC   Reset 1078                 */
+	u32	Reserved5[1050];/* 94-10F8                           */
+	u32	Reset_1078;	/* 10FC   Reset 1078                 */
 } SYSIF_REGS;
 
 /*
@@ -981,7 +981,8 @@ typedef struct _MPT_SCSI_HOST {
 	wait_queue_head_t	  scandv_waitq;
 	int			  scandv_wait_done;
 	long			  last_queue_full;
-	u8		 	  mpt_pq_filter;
+	u8			  mpt_pq_filter;
+	u16			  tm_iocstatus;
 } MPT_SCSI_HOST;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-07-11 12:58:55.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2006-07-11 12:42:06.000000000 -0600
@@ -114,7 +114,7 @@ static void	mptscsih_freeChainBuffers(MP
 static void	mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
 static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);
 static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout );
-static u32	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
+static int	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
 
 static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
 
@@ -554,6 +554,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 	}
 
 	sc = hd->ScsiLookup[req_idx];
+	hd->ScsiLookup[req_idx] = NULL;
 	if (sc == NULL) {
 		MPIHeader_t *hdr = (MPIHeader_t *)mf;
 
@@ -569,6 +570,12 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 		return 1;
 	}
 
+	if ((unsigned char *)mf != sc->host_scribble) {
+		mptscsih_freeChainBuffers(ioc, req_idx);
+		return 1;
+	}
+ 
+	sc->host_scribble = NULL;
 	sc->result = DID_OK << 16;		/* Set default reply as OK */
 	pScsiReq = (SCSIIORequest_t *) mf;
 	pScsiReply = (SCSIIOReply_t *) mr;
@@ -700,7 +707,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 				sc->result=DID_SOFT_ERROR << 16;
 			else /* Sufficient data transfer occurred */
 				sc->result = (DID_OK << 16) | scsi_status;
-			dreplyprintk((KERN_NOTICE 
+			dreplyprintk((KERN_NOTICE
 			    "RESIDUAL_MISMATCH: result=%x on id=%d\n", sc->result, sc->device->id));
 			break;
 
@@ -826,8 +833,6 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 				sc->request_bufflen, sc->sc_data_direction);
 	}
 
-	hd->ScsiLookup[req_idx] = NULL;
-
 	sc->scsi_done(sc);		/* Issue the command callback */
 
 	/* Free Chain buffers */
@@ -869,9 +874,17 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
 			dmfprintk(( "flush: ScsiDone (mf=%p,sc=%p)\n",
 					mf, SCpnt));
 
+			/* Free Chain buffers */
+			mptscsih_freeChainBuffers(ioc, ii);
+
+			/* Free Message frames */
+			mpt_free_msg_frame(ioc, mf);
+
+			if ((unsigned char *)mf != SCpnt->host_scribble)
+				continue;
+
 			/* Set status, free OS resources (SG DMA buffers)
 			 * Do OS callback
-			 * Free driver resources (chain, msg buffers)
 			 */
 			if (SCpnt->use_sg) {
 				pci_unmap_sg(ioc->pcidev,
@@ -887,12 +900,6 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
 			SCpnt->result = DID_RESET << 16;
 			SCpnt->host_scribble = NULL;
 
-			/* Free Chain buffers */
-			mptscsih_freeChainBuffers(ioc, ii);
-
-			/* Free Message frames */
-			mpt_free_msg_frame(ioc, mf);
-
 			SCpnt->scsi_done(SCpnt);	/* Issue the command callback */
 		}
 	}
@@ -929,10 +936,10 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 		if ((sc = hd->ScsiLookup[ii]) != NULL) {
 
 			mf = (SCSIIORequest_t *)MPT_INDEX_2_MFPTR(hd->ioc, ii);
-
+			if (mf == NULL)
+				continue;
 			dsprintk(( "search_running: found (sc=%p, mf = %p) target %d, lun %d \n",
 					hd->ScsiLookup[ii], mf, mf->TargetID, mf->LUN[1]));
-
 			if ((mf->TargetID != ((u8)vdevice->vtarget->target_id)) || (mf->LUN[1] != ((u8) vdevice->lun)))
 				continue;
 
@@ -941,6 +948,8 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 			hd->ScsiLookup[ii] = NULL;
 			mptscsih_freeChainBuffers(hd->ioc, ii);
 			mpt_free_msg_frame(hd->ioc, (MPT_FRAME_HDR *)mf);
+			if ((unsigned char *)mf != sc->host_scribble)
+				continue;
 			if (sc->use_sg) {
 				pci_unmap_sg(hd->ioc->pcidev,
 				(struct scatterlist *) sc->request_buffer,
@@ -1383,8 +1392,8 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 			goto fail;
 	}
 
+	SCpnt->host_scribble = (unsigned char *)mf;
 	hd->ScsiLookup[my_idx] = SCpnt;
-	SCpnt->host_scribble = NULL;
 
 	mpt_put_msg_frame(hd->ioc->DoneCtx, hd->ioc, mf);
 	dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
@@ -1571,6 +1580,12 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 		rc = mpt_HardResetHandler(hd->ioc, CAN_SLEEP);
 	}
 
+	/*
+	 * Check IOCStatus from TM reply message
+	 */
+	 if (hd->tm_iocstatus != MPI_IOCSTATUS_SUCCESS)
+		rc = FAILED;
+
 	dtmprintk((MYIOC_s_INFO_FMT "TMHandler rc = %d!\n", hd->ioc->name, rc));
 
 	return rc;
@@ -1696,6 +1711,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	int		 scpnt_idx;
 	int		 retval;
 	VirtDevice	 *vdev;
+	ulong	 	 sn = SCpnt->serial_number;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1749,6 +1765,11 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		vdev->vtarget->bus_id, vdev->vtarget->target_id, vdev->lun,
 		ctx2abort, mptscsih_get_tm_timeout(hd->ioc));
 
+	if (SCPNT_TO_LOOKUP_IDX(SCpnt) == scpnt_idx &&
+	    SCpnt->serial_number == sn) {
+		retval = FAILED;
+	}
+
 	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=%p)\n",
 		hd->ioc->name,
 		((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
@@ -2065,6 +2086,7 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *
 		DBG_DUMP_TM_REPLY_FRAME((u32 *)pScsiTmReply);
 
 		iocstatus = le16_to_cpu(pScsiTmReply->IOCStatus) & MPI_IOCSTATUS_MASK;
+		hd->tm_iocstatus = iocstatus;
 		dtmprintk((MYIOC_s_WARN_FMT "  SCSI TaskMgmt (%d) IOCStatus=%04x IOCLogInfo=%08x\n",
 			ioc->name, tmType, iocstatus, le32_to_cpu(pScsiTmReply->IOCLogInfo)));
 		/* Error?  (anything non-zero?) */
@@ -2458,7 +2480,7 @@ mptscsih_copy_sense_data(struct scsi_cmn
 	}
 }
 
-static u32
+static int
 SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc)
 {
 	MPT_SCSI_HOST *hd;
