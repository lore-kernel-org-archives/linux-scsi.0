Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E03C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C874F6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhDTAK7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:59 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:39872 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbhDTAKn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:43 -0400
Received: by mail-pl1-f173.google.com with SMTP id u7so16864395plr.6
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rH8H2f5lvxFiCIxcYnckQRop0TsGlHUa4BrzydtYUEk=;
        b=nkst0XSopXIya88s2iQEq6oodUkWYtJWSGLqLomSZzJOGN7yNNLFmEZC99pU7XCgf7
         cyd56iJtNX+SZu2a1K+rBUKTmRm0NYOGGal6EQzLT2m6w7I8+AFZOZr3Gd4wTpjsThSd
         vveOhZuR00rRMXrWKfIaAIks0UCUDybcO2z4Br/R+senyyROg+IwYmEJ6pKjMOE2V0w/
         5pytDntWtZOd6QP4sfihzSmSiU3HLbTJsFRINEh4Let6us9emFqzszyjuUtHC5Qeoo7u
         BCiCejX7MC+fml2vPp5G3Wx0sJG2ft616y/Y7jEp0nLPKGu2zJnLSQxuuquPv9NIvAjv
         QuWw==
X-Gm-Message-State: AOAM533Vu8jXoNgG67HozlYvBxVZC+siIOA2kIgi9ZKzVE0h0BpIIKca
        vAr2vHzVxZ1RospC8ogCKT/mU79mZ7feXw==
X-Google-Smtp-Source: ABdhPJyjtAbckUvxcKTaEP3CVAamK3vT0POctAAAnougnTCCh2KqoUCedtaiW8PxJcXfIIw8m/QHaw==
X-Received: by 2002:a17:90a:46c4:: with SMTP id x4mr1886549pjg.8.1618877412637;
        Mon, 19 Apr 2021 17:10:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 070/117] mpt3sas: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:58 -0700
Message-Id: <20210420000845.25873-71-bvanassche@acm.org>
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 78 ++++++++++++++--------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d00aca3c77ce..a03534741afc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3311,7 +3311,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 	    ioc->remove_host) {
 		sdev_printk(KERN_INFO, scmd->device,
 		    "device been deleted! scmd(0x%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		r = SUCCESS;
 		goto out;
@@ -3321,7 +3321,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 	if (st == NULL || st->cb_idx == 0xFF) {
 		sdev_printk(KERN_INFO, scmd->device, "No reference found at "
 		    "driver, assuming scmd(0x%p) might have completed\n", scmd);
-		scmd->result = DID_RESET << 16;
+		scmd->status.combined = DID_RESET << 16;
 		r = SUCCESS;
 		goto out;
 	}
@@ -3330,7 +3330,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 	if (sas_device_priv_data->sas_target->flags &
 	    MPT_TARGET_FLAGS_RAID_COMPONENT ||
 	    sas_device_priv_data->sas_target->flags & MPT_TARGET_FLAGS_VOLUME) {
-		scmd->result = DID_RESET << 16;
+		scmd->status.combined = DID_RESET << 16;
 		r = FAILED;
 		goto out;
 	}
@@ -3387,7 +3387,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 	    ioc->remove_host) {
 		sdev_printk(KERN_INFO, scmd->device,
 		    "device been deleted! scmd(0x%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		r = SUCCESS;
 		goto out;
@@ -3405,7 +3405,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		handle = sas_device_priv_data->sas_target->handle;
 
 	if (!handle) {
-		scmd->result = DID_RESET << 16;
+		scmd->status.combined = DID_RESET << 16;
 		r = FAILED;
 		goto out;
 	}
@@ -3467,7 +3467,7 @@ scsih_target_reset(struct scsi_cmnd *scmd)
 	    ioc->remove_host) {
 		starget_printk(KERN_INFO, starget,
 		    "target been deleted! scmd(0x%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		r = SUCCESS;
 		goto out;
@@ -3485,7 +3485,7 @@ scsih_target_reset(struct scsi_cmnd *scmd)
 		handle = sas_device_priv_data->sas_target->handle;
 
 	if (!handle) {
-		scmd->result = DID_RESET << 16;
+		scmd->status.combined = DID_RESET << 16;
 		r = FAILED;
 		goto out;
 	}
@@ -4984,9 +4984,9 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		mpt3sas_base_clear_st(ioc, st);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery || ioc->remove_host)
-			scmd->result = DID_NO_CONNECT << 16;
+			scmd->status.combined = DID_NO_CONNECT << 16;
 		else
-			scmd->result = DID_RESET << 16;
+			scmd->status.combined = DID_RESET << 16;
 		scmd->scsi_done(scmd);
 	}
 	dtmprintk(ioc, ioc_info(ioc, "completing %d cmds\n", count));
@@ -5079,7 +5079,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 	}
 	scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST, 0x10,
 	    ascq);
-	scmd->result = DRIVER_SENSE << 24 | (DID_ABORT << 16) |
+	scmd->status.combined = DRIVER_SENSE << 24 | (DID_ABORT << 16) |
 	    SAM_STAT_CHECK_CONDITION;
 }
 
@@ -5114,13 +5114,13 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
 
 	if (!(_scsih_allow_scmd_to_device(ioc, scmd))) {
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -5130,7 +5130,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	/* invalid device handle */
 	handle = sas_target_priv_data->handle;
 	if (handle == MPT3SAS_INVALID_DEVICE_HANDLE) {
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -5141,7 +5141,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		return SCSI_MLQUEUE_HOST_BUSY;
 	} else if (sas_target_priv_data->deleted) {
 		/* device has been deleted */
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	} else if (sas_target_priv_data->tm_busy ||
@@ -5460,7 +5460,7 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		 scsi_bufflen(scmd), scmd->underflow, scsi_get_resid(scmd));
 	ioc_warn(ioc, "\ttag(%d), transfer_count(%d), sc->result(0x%08x)\n",
 		 le16_to_cpu(mpi_reply->TaskTag),
-		 le32_to_cpu(mpi_reply->TransferCount), scmd->result);
+		 le32_to_cpu(mpi_reply->TransferCount), scmd->status.combined);
 	ioc_warn(ioc, "\tscsi_status(%s)(0x%02x), scsi_state(%s)(0x%02x)\n",
 		 desc_scsi_status, scsi_status, desc_scsi_state, scsi_state);
 
@@ -5688,14 +5688,14 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
 	if (mpi_reply == NULL) {
-		scmd->result = DID_OK << 16;
+		scmd->status.combined = DID_OK << 16;
 		goto out;
 	}
 
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
 	     sas_device_priv_data->sas_target->deleted) {
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		goto out;
 	}
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
@@ -5773,71 +5773,71 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	switch (ioc_status) {
 	case MPI2_IOCSTATUS_BUSY:
 	case MPI2_IOCSTATUS_INSUFFICIENT_RESOURCES:
-		scmd->result = SAM_STAT_BUSY;
+		scmd->status.combined = SAM_STAT_BUSY;
 		break;
 
 	case MPI2_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		break;
 
 	case MPI2_IOCSTATUS_SCSI_IOC_TERMINATED:
 		if (sas_device_priv_data->block) {
-			scmd->result = DID_TRANSPORT_DISRUPTED << 16;
+			scmd->status.combined = DID_TRANSPORT_DISRUPTED << 16;
 			goto out;
 		}
 		if (log_info == 0x31110630) {
 			if (scmd->retries > 2) {
-				scmd->result = DID_NO_CONNECT << 16;
+				scmd->status.combined = DID_NO_CONNECT << 16;
 				scsi_device_set_state(scmd->device,
 				    SDEV_OFFLINE);
 			} else {
-				scmd->result = DID_SOFT_ERROR << 16;
+				scmd->status.combined = DID_SOFT_ERROR << 16;
 				scmd->device->expecting_cc_ua = 1;
 			}
 			break;
 		} else if (log_info == VIRTUAL_IO_FAILED_RETRY) {
-			scmd->result = DID_RESET << 16;
+			scmd->status.combined = DID_RESET << 16;
 			break;
 		} else if ((scmd->device->channel == RAID_CHANNEL) &&
 		   (scsi_state == (MPI2_SCSI_STATE_TERMINATED |
 		   MPI2_SCSI_STATE_NO_SCSI_STATUS))) {
-			scmd->result = DID_RESET << 16;
+			scmd->status.combined = DID_RESET << 16;
 			break;
 		}
-		scmd->result = DID_SOFT_ERROR << 16;
+		scmd->status.combined = DID_SOFT_ERROR << 16;
 		break;
 	case MPI2_IOCSTATUS_SCSI_TASK_TERMINATED:
 	case MPI2_IOCSTATUS_SCSI_EXT_TERMINATED:
-		scmd->result = DID_RESET << 16;
+		scmd->status.combined = DID_RESET << 16;
 		break;
 
 	case MPI2_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
 		if ((xfer_cnt == 0) || (scmd->underflow > xfer_cnt))
-			scmd->result = DID_SOFT_ERROR << 16;
+			scmd->status.combined = DID_SOFT_ERROR << 16;
 		else
-			scmd->result = (DID_OK << 16) | scsi_status;
+			scmd->status.combined = (DID_OK << 16) | scsi_status;
 		break;
 
 	case MPI2_IOCSTATUS_SCSI_DATA_UNDERRUN:
-		scmd->result = (DID_OK << 16) | scsi_status;
+		scmd->status.combined = (DID_OK << 16) | scsi_status;
 
 		if ((scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID))
 			break;
 
 		if (xfer_cnt < scmd->underflow) {
 			if (scsi_status == SAM_STAT_BUSY)
-				scmd->result = SAM_STAT_BUSY;
+				scmd->status.combined = SAM_STAT_BUSY;
 			else
-				scmd->result = DID_SOFT_ERROR << 16;
+				scmd->status.combined = DID_SOFT_ERROR << 16;
 		} else if (scsi_state & (MPI2_SCSI_STATE_AUTOSENSE_FAILED |
 		     MPI2_SCSI_STATE_NO_SCSI_STATUS))
-			scmd->result = DID_SOFT_ERROR << 16;
+			scmd->status.combined = DID_SOFT_ERROR << 16;
 		else if (scsi_state & MPI2_SCSI_STATE_TERMINATED)
-			scmd->result = DID_RESET << 16;
+			scmd->status.combined = DID_RESET << 16;
 		else if (!xfer_cnt && scmd->cmnd[0] == REPORT_LUNS) {
 			mpi_reply->SCSIState = MPI2_SCSI_STATE_AUTOSENSE_VALID;
 			mpi_reply->SCSIStatus = SAM_STAT_CHECK_CONDITION;
-			scmd->result = (DRIVER_SENSE << 24) |
+			scmd->status.combined = (DRIVER_SENSE << 24) |
 			    SAM_STAT_CHECK_CONDITION;
 			scmd->sense_buffer[0] = 0x70;
 			scmd->sense_buffer[2] = ILLEGAL_REQUEST;
@@ -5851,14 +5851,14 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		fallthrough;
 	case MPI2_IOCSTATUS_SCSI_RECOVERED_ERROR:
 	case MPI2_IOCSTATUS_SUCCESS:
-		scmd->result = (DID_OK << 16) | scsi_status;
+		scmd->status.combined = (DID_OK << 16) | scsi_status;
 		if (response_code ==
 		    MPI2_SCSITASKMGMT_RSP_INVALID_FRAME ||
 		    (scsi_state & (MPI2_SCSI_STATE_AUTOSENSE_FAILED |
 		     MPI2_SCSI_STATE_NO_SCSI_STATUS)))
-			scmd->result = DID_SOFT_ERROR << 16;
+			scmd->status.combined = DID_SOFT_ERROR << 16;
 		else if (scsi_state & MPI2_SCSI_STATE_TERMINATED)
-			scmd->result = DID_RESET << 16;
+			scmd->status.combined = DID_RESET << 16;
 		break;
 
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
@@ -5877,12 +5877,12 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	case MPI2_IOCSTATUS_SCSI_TASK_MGMT_FAILED:
 	case MPI2_IOCSTATUS_INSUFFICIENT_POWER:
 	default:
-		scmd->result = DID_SOFT_ERROR << 16;
+		scmd->status.combined = DID_SOFT_ERROR << 16;
 		break;
 
 	}
 
-	if (scmd->result && (ioc->logging_level & MPT_DEBUG_REPLY))
+	if (scmd->status.combined && (ioc->logging_level & MPT_DEBUG_REPLY))
 		_scsih_scsi_ioc_info(ioc , scmd, mpi_reply, smid);
 
  out:
