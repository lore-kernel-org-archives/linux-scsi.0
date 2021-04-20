Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042F3C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D77B3613AE
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhDTAK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:58 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:39879 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbhDTAKm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:42 -0400
Received: by mail-pl1-f181.google.com with SMTP id u7so16864379plr.6
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sZLQ8adwe87kUahmYTebrvmTTR5EZH5SBU+PFKb/PTE=;
        b=MHAZCVqEycwOAzOI55pu4Q1+GODGjmv0aswkzmFug4svMiwVlpLMlU/8PkgKZHWTLq
         dnj17tOK5fxMhLgkmpM5oSOvHLCTj9eIgbyksi7l/WQELRzHhykdcgFPlreFIivx7/ee
         gyW3rlr8CUGZYzejw4+9fUGWfM0DWAmgYdHbm4CKz08d9HEYkIP3DhL/0aFwIgqbrvvD
         qbqvTIKYPEpJmEKG54tzDzsh2lQ9v1ALaR9rH3JL21XgGZBRilSAnFXtJQHDqY2dtAPv
         xq89iWfxsKLPXRDkyamv6Mbal0bRi+aP9CT8yKijYVIXyKqN9LJnwmr0g7vo2zyKZ8lQ
         Gz+w==
X-Gm-Message-State: AOAM532d6KCqQ5do0iqL7XzTDmHzCtVa7mdN2WFZONk6kTZ3zOT7wV17
        spijc9+K3IAibPNYzxuBVgg=
X-Google-Smtp-Source: ABdhPJx08m1enQEoGe2l4aI+ddY8cmJxaC/xEFVSZDtw0imtHK1f3+3A8/A8ZcNdGuyLBMGoFlsr2g==
X-Received: by 2002:a17:90a:8b97:: with SMTP id z23mr1681057pjn.131.1618877411418;
        Mon, 19 Apr 2021 17:10:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 069/117] message: fusion: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:57 -0700
Message-Id: <20210420000845.25873-70-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/message/fusion/mptfc.c    |  6 +--
 drivers/message/fusion/mptsas.c   |  2 +-
 drivers/message/fusion/mptscsih.c | 70 +++++++++++++++----------------
 drivers/message/fusion/mptspi.c   |  4 +-
 4 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 0484e9c15c09..5cb9a435e60c 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -648,14 +648,14 @@ mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
 
 	if (!vdevice || !vdevice->vtarget) {
-		SCpnt->result = DID_NO_CONNECT << 16;
+		SCpnt->status.combined = DID_NO_CONNECT << 16;
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
 
 	err = fc_remote_port_chkready(rport);
 	if (unlikely(err)) {
-		SCpnt->result = err;
+		SCpnt->status.combined = err;
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
@@ -663,7 +663,7 @@ mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 	/* dd_data is null until finished adding target */
 	ri = *((struct mptfc_rport_info **)rport->dd_data);
 	if (unlikely(!ri)) {
-		SCpnt->result = DID_IMM_RETRY << 16;
+		SCpnt->status.combined = DID_IMM_RETRY << 16;
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index e0a65a348502..187ddb9ba8c2 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1923,7 +1923,7 @@ mptsas_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
 
 	if (!vdevice || !vdevice->vtarget || vdevice->vtarget->deleted) {
-		SCpnt->result = DID_NO_CONNECT << 16;
+		SCpnt->status.combined = DID_NO_CONNECT << 16;
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index ce2e5b21978e..5100cb659f5e 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -541,7 +541,7 @@ mptscsih_info_scsiio(MPT_ADAPTER *ioc, struct scsi_cmnd *sc, SCSIIOReply_t * pSc
 	    scsi_get_resid(sc));
 	printk(MYIOC_s_DEBUG_FMT "\ttag = %d, transfer_count = %d, "
 	    "sc->result = %08X\n", ioc->name, le16_to_cpu(pScsiReply->TaskTag),
-	    le32_to_cpu(pScsiReply->TransferCount), sc->result);
+	    le32_to_cpu(pScsiReply->TransferCount), sc->status.combined);
 
 	printk(MYIOC_s_DEBUG_FMT "\tiocstatus = %s (0x%04x), "
 	    "scsi_status = %s (0x%02x), scsi_state = (0x%02x)\n",
@@ -632,13 +632,13 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 
 		if (!vdevice || !vdevice->vtarget ||
 		    vdevice->vtarget->deleted) {
-			sc->result = DID_NO_CONNECT << 16;
+			sc->status.combined = DID_NO_CONNECT << 16;
 			goto out;
 		}
 	}
 
 	sc->host_scribble = NULL;
-	sc->result = DID_OK << 16;		/* Set default reply as OK */
+	sc->status.combined = DID_OK << 16;		/* Set default reply as OK */
 	pScsiReq = (SCSIIORequest_t *) mf;
 	pScsiReply = (SCSIIOReply_t *) mr;
 
@@ -705,21 +705,21 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			 * But not: DID_BUS_BUSY lest one risk
 			 * killing interrupt handler:-(
 			 */
-			sc->result = SAM_STAT_BUSY;
+			sc->status.combined = SAM_STAT_BUSY;
 			break;
 
 		case MPI_IOCSTATUS_SCSI_INVALID_BUS:		/* 0x0041 */
 		case MPI_IOCSTATUS_SCSI_INVALID_TARGETID:	/* 0x0042 */
-			sc->result = DID_BAD_TARGET << 16;
+			sc->status.combined = DID_BAD_TARGET << 16;
 			break;
 
 		case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE:	/* 0x0043 */
 			/* Spoof to SCSI Selection Timeout! */
 			if (ioc->bus_type != FC)
-				sc->result = DID_NO_CONNECT << 16;
+				sc->status.combined = DID_NO_CONNECT << 16;
 			/* else fibre, just stall until rescan event */
 			else
-				sc->result = DID_REQUEUE << 16;
+				sc->status.combined = DID_REQUEUE << 16;
 
 			if (hd->sel_timeout[pScsiReq->TargetID] < 0xFFFF)
 				hd->sel_timeout[pScsiReq->TargetID]++;
@@ -763,7 +763,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 							vdevice->vtarget->
 								inDMD = 1;
 
-					    sc->result =
+					    sc->status.combined =
 						    (DID_TRANSPORT_DISRUPTED
 						    << 16);
 					    break;
@@ -777,7 +777,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 				 * DID_RESET to permit retry of the command,
 				 * just not an infinite number of them
 				 */
-				sc->result = DID_ERROR << 16;
+				sc->status.combined = DID_ERROR << 16;
 				break;
 			}
 
@@ -790,25 +790,25 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			/* Linux handles an unsolicited DID_RESET better
 			 * than an unsolicited DID_ABORT.
 			 */
-			sc->result = DID_RESET << 16;
+			sc->status.combined = DID_RESET << 16;
 			break;
 
 		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
 			if (ioc->bus_type == FC)
-				sc->result = DID_ERROR << 16;
+				sc->status.combined = DID_ERROR << 16;
 			else
-				sc->result = DID_RESET << 16;
+				sc->status.combined = DID_RESET << 16;
 			break;
 
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
 			scsi_set_resid(sc, scsi_bufflen(sc) - xfer_cnt);
 			if((xfer_cnt==0)||(sc->underflow > xfer_cnt))
-				sc->result=DID_SOFT_ERROR << 16;
+				sc->status.combined = DID_SOFT_ERROR << 16;
 			else /* Sufficient data transfer occurred */
-				sc->result = (DID_OK << 16) | scsi_status;
+				sc->status.combined = (DID_OK << 16) | scsi_status;
 			dreplyprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 			    "RESIDUAL_MISMATCH: result=%x on channel=%d id=%d\n",
-			    ioc->name, sc->result, sc->device->channel, sc->device->id));
+			    ioc->name, sc->status.combined, sc->device->channel, sc->device->id));
 			break;
 
 		case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */
@@ -816,7 +816,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			 *  Do upfront check for valid SenseData and give it
 			 *  precedence!
 			 */
-			sc->result = (DID_OK << 16) | scsi_status;
+			sc->status.combined = (DID_OK << 16) | scsi_status;
 			if (!(scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID)) {
 
 				/*
@@ -836,7 +836,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 					    pScsiReq->CDB[0] == VERIFY_16) {
 						if (scsi_bufflen(sc) !=
 							xfer_cnt) {
-							sc->result =
+							sc->status.combined =
 							DID_SOFT_ERROR << 16;
 						    printk(KERN_WARNING "Errata"
 						    "on LSI53C1030 occurred."
@@ -850,18 +850,18 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 
 				if (xfer_cnt < sc->underflow) {
 					if (scsi_status == SAM_STAT_BUSY)
-						sc->result = SAM_STAT_BUSY;
+						sc->status.combined = SAM_STAT_BUSY;
 					else
-						sc->result = DID_SOFT_ERROR << 16;
+						sc->status.combined = DID_SOFT_ERROR << 16;
 				}
 				if (scsi_state & (MPI_SCSI_STATE_AUTOSENSE_FAILED | MPI_SCSI_STATE_NO_SCSI_STATUS)) {
 					/* What to do?
 				 	*/
-					sc->result = DID_SOFT_ERROR << 16;
+					sc->status.combined = DID_SOFT_ERROR << 16;
 				}
 				else if (scsi_state & MPI_SCSI_STATE_TERMINATED) {
 					/*  Not real sure here either...  */
-					sc->result = DID_RESET << 16;
+					sc->status.combined = DID_RESET << 16;
 				}
 			}
 
@@ -884,7 +884,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			fallthrough;
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
 		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
-			sc->result = (DID_OK << 16) | scsi_status;
+			sc->status.combined = (DID_OK << 16) | scsi_status;
 			if (scsi_state == 0) {
 				;
 			} else if (scsi_state &
@@ -955,11 +955,11 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 				/*
 				 * What to do?
 				 */
-				sc->result = DID_SOFT_ERROR << 16;
+				sc->status.combined = DID_SOFT_ERROR << 16;
 			}
 			else if (scsi_state & MPI_SCSI_STATE_TERMINATED) {
 				/*  Not real sure here either...  */
-				sc->result = DID_RESET << 16;
+				sc->status.combined = DID_RESET << 16;
 			}
 			else if (scsi_state & MPI_SCSI_STATE_QUEUE_TAG_REJECTED) {
 				/* Device Inq. data indicates that it supports
@@ -969,7 +969,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 				 * Not real sure here either so do nothing...  */
 			}
 
-			if (sc->result == MPI_SCSI_STATUS_TASK_SET_FULL)
+			if (sc->status.combined == MPI_SCSI_STATUS_TASK_SET_FULL)
 				mptscsih_report_queue_full(sc, pScsiReply, pScsiReq);
 
 			/* Add handling of:
@@ -979,7 +979,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			break;
 
 		case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR:		/* 0x0047 */
-			sc->result = DID_SOFT_ERROR << 16;
+			sc->status.combined = DID_SOFT_ERROR << 16;
 			break;
 
 		case MPI_IOCSTATUS_INVALID_FUNCTION:		/* 0x0001 */
@@ -994,13 +994,13 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			/*
 			 * What to do?
 			 */
-			sc->result = DID_SOFT_ERROR << 16;
+			sc->status.combined = DID_SOFT_ERROR << 16;
 			break;
 
 		}	/* switch(status) */
 
 #ifdef CONFIG_FUSION_LOGGING
-		if (sc->result && (ioc->debug_level & MPT_DEBUG_REPLY))
+		if (sc->status.combined && (ioc->debug_level & MPT_DEBUG_REPLY))
 			mptscsih_info_scsiio(ioc, sc, pScsiReply);
 #endif
 
@@ -1049,7 +1049,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 		if ((unsigned char *)mf != sc->host_scribble)
 			continue;
 		scsi_dma_unmap(sc);
-		sc->result = DID_RESET << 16;
+		sc->status.combined = DID_RESET << 16;
 		sc->host_scribble = NULL;
 		dtmprintk(ioc, sdev_printk(KERN_INFO, sc->device, MYIOC_s_FMT
 		    "completing cmds: fw_channel %d, fw_id %d, sc=%p, mf = %p, "
@@ -1112,7 +1112,7 @@ mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
 			mpt_free_msg_frame(ioc, (MPT_FRAME_HDR *)mf);
 			scsi_dma_unmap(sc);
 			sc->host_scribble = NULL;
-			sc->result = DID_NO_CONNECT << 16;
+			sc->status.combined = DID_NO_CONNECT << 16;
 			dtmprintk(ioc, sdev_printk(KERN_INFO, sc->device,
 			   MYIOC_s_FMT "completing cmds: fw_channel %d, "
 			   "fw_id %d, sc=%p, mf = %p, idx=%x\n", ioc->name,
@@ -1692,7 +1692,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = shost_priv(SCpnt->device->host)) == NULL) {
-		SCpnt->result = DID_RESET << 16;
+		SCpnt->status.combined = DID_RESET << 16;
 		SCpnt->scsi_done(SCpnt);
 		printk(KERN_ERR MYNAM ": task abort: "
 		    "can't locate host! (sc=%p)\n", SCpnt);
@@ -1709,7 +1709,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "task abort: device has been deleted (sc=%p)\n",
 		    ioc->name, SCpnt));
-		SCpnt->result = DID_NO_CONNECT << 16;
+		SCpnt->status.combined = DID_NO_CONNECT << 16;
 		SCpnt->scsi_done(SCpnt);
 		retval = SUCCESS;
 		goto out;
@@ -1721,7 +1721,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "task abort: hidden raid component (sc=%p)\n",
 		    ioc->name, SCpnt));
-		SCpnt->result = DID_RESET << 16;
+		SCpnt->status.combined = DID_RESET << 16;
 		retval = FAILED;
 		goto out;
 	}
@@ -1732,7 +1732,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "task abort: raid volume (sc=%p)\n",
 		    ioc->name, SCpnt));
-		SCpnt->result = DID_RESET << 16;
+		SCpnt->status.combined = DID_RESET << 16;
 		retval = FAILED;
 		goto out;
 	}
@@ -1743,7 +1743,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		/* Cmd not found in ScsiLookup.
 		 * Do OS callback.
 		 */
-		SCpnt->result = DID_RESET << 16;
+		SCpnt->status.combined = DID_RESET << 16;
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: "
 		   "Command not in the active list! (sc=%p)\n", ioc->name,
 		   SCpnt));
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index af0ce5611e4a..9e76e525e350 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -781,14 +781,14 @@ mptspi_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	if (!vdevice || !vdevice->vtarget) {
-		SCpnt->result = DID_NO_CONNECT << 16;
+		SCpnt->status.combined = DID_NO_CONNECT << 16;
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
 
 	if (SCpnt->device->channel == 1 &&
 		mptscsih_is_phys_disk(ioc, 0, SCpnt->device->id) == 0) {
-		SCpnt->result = DID_NO_CONNECT << 16;
+		SCpnt->status.combined = DID_NO_CONNECT << 16;
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
