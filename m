From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 7/19] fusion: convert to use the data buffer accessors
Date: Sat, 12 May 2007 19:05:43 +0900 (JST)
Message-ID: <20070512183510E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44890 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbXELKF4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eric.moore@lsi.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

This converts fusion to use the data buffer accessors.

TODO: use scsi_for_each_sg()

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/message/fusion/mptscsih.c |   51 +++++++++++++------------------------
 1 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index d7e2fa9..12f59f1 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -260,18 +260,13 @@ mptscsih_AddSGE(MPT_ADAPTER *ioc, struct
 	/* Map the data portion, if any.
 	 * sges_left  = 0 if no data transfer.
 	 */
-	if ( (sges_left = SCpnt->use_sg) ) {
-		sges_left = pci_map_sg(ioc->pcidev,
-			       (struct scatterlist *) SCpnt->request_buffer,
- 			       SCpnt->use_sg,
-			       SCpnt->sc_data_direction);
-		if (sges_left == 0)
-			return FAILED;
-	}
+	sges_left = scsi_dma_map(&ioc->pcidev->dev, SCpnt);
+	if (sges_left < 0)
+		return FAILED;
 
 	/* Handle the SG case.
 	 */
-	sg = (struct scatterlist *) SCpnt->request_buffer;
+	sg = scsi_sglist(SCpnt);
 	sg_done  = 0;
 	sgeOffset = sizeof(SCSIIORequest_t) - sizeof(SGE_IO_UNION);
 	chainSge = NULL;
@@ -650,7 +645,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 		scsi_state = pScsiReply->SCSIState;
 		scsi_status = pScsiReply->SCSIStatus;
 		xfer_cnt = le32_to_cpu(pScsiReply->TransferCount);
-		sc->resid = sc->request_bufflen - xfer_cnt;
+		scsi_resid(sc) = scsi_bufflen(sc) - xfer_cnt;
 		log_info = le32_to_cpu(pScsiReply->IOCLogInfo);
 
 		/*
@@ -755,7 +750,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			break;
 
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
-			sc->resid = sc->request_bufflen - xfer_cnt;
+			scsi_resid(sc) = scsi_bufflen(sc) - xfer_cnt;
 			if((xfer_cnt==0)||(sc->underflow > xfer_cnt))
 				sc->result=DID_SOFT_ERROR << 16;
 			else /* Sufficient data transfer occurred */
@@ -804,7 +799,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			break;
 
 		case MPI_IOCSTATUS_SCSI_DATA_OVERRUN:		/* 0x0044 */
-			sc->resid=0;
+			scsi_resid(sc) =0;
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
 		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
 			sc->result = (DID_OK << 16) | scsi_status;
@@ -887,20 +882,18 @@ #ifdef MPT_DEBUG_REPLY
 			    scsi_state, scsi_status, log_info));
 
 			dreplyprintk(("%s: [%d:%d:%d:%d] resid=%d "
-			    "bufflen=%d xfer_cnt=%d\n", __FUNCTION__,
-			    sc->device->host->host_no, sc->device->channel, sc->device->id,
-			    sc->device->lun, sc->resid, sc->request_bufflen,
-			    xfer_cnt));
+				      "bufflen=%d xfer_cnt=%d\n", __FUNCTION__,
+				      sc->device->host->host_no,
+				      sc->device->channel, sc->device->id,
+				      sc->device->lun, scsi_resid(sc),
+				      scsi_bufflen(sc), xfer_cnt));
 		}
 #endif
 
 	} /* end of address reply case */
 
 	/* Unmap the DMA buffers, if any. */
-	if (sc->use_sg)
-		pci_unmap_sg(ioc->pcidev, (struct scatterlist *) sc->request_buffer,
-			     sc->use_sg,
-			     sc->sc_data_direction);
+	scsi_dma_unmap(&ioc->pcidev->dev, sc);
 
 	sc->scsi_done(sc);		/* Issue the command callback */
 
@@ -955,11 +948,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
 			/* Set status, free OS resources (SG DMA buffers)
 			 * Do OS callback
 			 */
-			if (SCpnt->use_sg)
-				pci_unmap_sg(ioc->pcidev,
-					(struct scatterlist *) SCpnt->request_buffer,
-					SCpnt->use_sg,
-					SCpnt->sc_data_direction);
+			scsi_dma_unmap(&ioc->pcidev->dev, SCpnt);
 
 			SCpnt->result = DID_RESET << 16;
 			SCpnt->host_scribble = NULL;
@@ -1019,12 +1008,8 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 			mpt_free_msg_frame(hd->ioc, (MPT_FRAME_HDR *)mf);
 			if ((unsigned char *)mf != sc->host_scribble)
 				continue;
-			if (sc->use_sg) {
-				pci_unmap_sg(hd->ioc->pcidev,
-				(struct scatterlist *) sc->request_buffer,
-					sc->use_sg,
-					sc->sc_data_direction);
-			}
+			scsi_dma_unmap(&hd->ioc->pcidev->dev, sc);
+
 			sc->host_scribble = NULL;
 			sc->result = DID_NO_CONNECT << 16;
 			sc->scsi_done(sc);
@@ -1355,10 +1340,10 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	 *    will be no data transfer!  GRRRRR...
 	 */
 	if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
-		datalen = SCpnt->request_bufflen;
+		datalen = scsi_bufflen(SCpnt);
 		scsidir = MPI_SCSIIO_CONTROL_READ;	/* DATA IN  (host<--ioc<--dev) */
 	} else if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
-		datalen = SCpnt->request_bufflen;
+		datalen = scsi_bufflen(SCpnt);
 		scsidir = MPI_SCSIIO_CONTROL_WRITE;	/* DATA OUT (host-->ioc-->dev) */
 	} else {
 		datalen = 0;
-- 
1.4.3.2

