Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361ABC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09DCC613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhDTCO5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:57 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:37543 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbhDTCOz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:55 -0400
Received: by mail-pj1-f50.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso14473999pjg.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nfApnvmw4OEwvll2zTfFPKz4sd3PVzwuvV6C8tfF2fA=;
        b=DE1q5ODy305bdZmkR1hRCQVzraVeI7FXjpN2f1TDgUOzz5lWwr9+7CZ1DfxRHpQNN4
         ngW1NImcjgPjrvRQctrjSQR3usnU2VVFt/DLnxu10GPTBXh3CQTvLIzmdOJ9vBX2Zz8l
         lWJ/0el9OU3m3DeV2IDEZa4eDn4qReT4411CTiSrl2cyaaye8UJvQDQK/0s12V9Hv67N
         RhVWMtscdo1IYID6+vDC/GfjGv97sTI58OpZ/TaNT5+r9kWH4sKC1nGe4bf3+A8lymiQ
         VJYeS8TKXHLcITqWDeYJkKjpneGF7Ujiox05JWqeEir/FvB5m0jH7wKvdxRwSkAYCPzw
         RslA==
X-Gm-Message-State: AOAM530si+Zv8HGPPlraXx0e83vVk5RHPlXrCpvtsyQtD3zd2Eqf95R+
        7HLONy38KU4SGGci6DxtRliV3k8tnDznTw==
X-Google-Smtp-Source: ABdhPJwf9T9Afb3D+240nAU4vYgK4Uy20csBfvxp/tzCQjQ9WPAHrJ4lDklg+KqYUPvUVzWN749O6g==
X-Received: by 2002:a17:902:ed52:b029:ec:824a:404a with SMTP id y18-20020a170902ed52b02900ec824a404amr18205527plb.73.1618884864141;
        Mon, 19 Apr 2021 19:14:24 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 103/117] usb: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:48 -0700
Message-Id: <20210420021402.27678-13-bvanassche@acm.org>
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

Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/usb/image/microtek.c        |  4 ++--
 drivers/usb/storage/cypress_atacb.c | 12 +++++-----
 drivers/usb/storage/datafab.c       |  4 ++--
 drivers/usb/storage/isd200.c        | 34 ++++++++++++++---------------
 drivers/usb/storage/jumpshot.c      |  4 ++--
 drivers/usb/storage/realtek_cr.c    | 10 ++++-----
 drivers/usb/storage/scsiglue.c      |  4 ++--
 drivers/usb/storage/transport.c     | 30 ++++++++++++-------------
 drivers/usb/storage/uas.c           |  8 +++----
 drivers/usb/storage/usb.c           | 14 ++++++------
 10 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 59b02a539963..1e864ad1da8e 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -408,8 +408,8 @@ static void mts_transfer_done( struct urb *transfer )
 {
 	MTS_INT_INIT();
 
-	context->srb->result &= MTS_SCSI_ERR_MASK;
-	context->srb->result |= (unsigned)(*context->scsi_status)<<1;
+	context->srb->status.combined &= MTS_SCSI_ERR_MASK;
+	context->srb->status.combined |= (unsigned)(*context->scsi_status)<<1;
 
 	mts_transfer_cleanup(transfer);
 }
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index a6f3267bbef6..1d0449443759 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -148,7 +148,7 @@ static void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 	usb_stor_transparent_scsi_command(srb, us);
 
 	/* if the device doesn't support ATACB */
-	if (srb->result == SAM_STAT_CHECK_CONDITION &&
+	if (srb->status.combined == SAM_STAT_CHECK_CONDITION &&
 			memcmp(srb->sense_buffer, usb_stor_sense_invalidCDB,
 				sizeof(usb_stor_sense_invalidCDB)) == 0) {
 		usb_stor_dbg(us, "cypress atacb not supported ???\n");
@@ -159,8 +159,8 @@ static void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 	 * if ck_cond flags is set, and there wasn't critical error,
 	 * build the special sense
 	 */
-	if ((srb->result != (DID_ERROR << 16) &&
-				srb->result != (DID_ABORT << 16)) &&
+	if ((srb->status.combined != (DID_ERROR << 16) &&
+				srb->status.combined != (DID_ABORT << 16)) &&
 			save_cmnd[2] & 0x20) {
 		struct scsi_eh_save ses;
 		unsigned char regs[8];
@@ -182,7 +182,7 @@ static void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 
 		usb_stor_transparent_scsi_command(srb, us);
 		memcpy(regs, srb->sense_buffer, sizeof(regs));
-		tmp_result = srb->result;
+		tmp_result = srb->status.combined;
 		scsi_eh_restore_cmnd(srb, &ses);
 		/* we fail to get registers, report invalid command */
 		if (tmp_result != SAM_STAT_GOOD)
@@ -221,11 +221,11 @@ static void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 		desc[12] = regs[6];  /* device */
 		desc[13] = regs[7];  /* command */
 
-		srb->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		srb->status.combined = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 	}
 	goto end;
 invalid_fld:
-	srb->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+	srb->status.combined = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
 	memcpy(srb->sense_buffer,
 			usb_stor_sense_invalidCDB,
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index 588818483f4b..fc3c0305cad3 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -702,10 +702,10 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 		rc = datafab_id_device(us, info);
 		if (rc == USB_STOR_TRANSPORT_GOOD) {
 			info->sense_key = NO_SENSE;
-			srb->result = SUCCESS;
+			srb->status.combined = SUCCESS;
 		} else {
 			info->sense_key = UNIT_ATTENTION;
-			srb->result = SAM_STAT_CHECK_CONDITION;
+			srb->status.combined = SAM_STAT_CHECK_CONDITION;
 		}
 		return rc;
 	}
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 3c76336e43bb..11b1ad6fa5f0 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -630,12 +630,12 @@ static void isd200_invoke_transport( struct us_data *us,
 
 	case USB_STOR_TRANSPORT_GOOD:
 		/* Indicate a good result */
-		srb->result = SAM_STAT_GOOD;
+		srb->status.combined = SAM_STAT_GOOD;
 		break;
 
 	case USB_STOR_TRANSPORT_NO_SENSE:
 		usb_stor_dbg(us, "-- transport indicates protocol failure\n");
-		srb->result = SAM_STAT_CHECK_CONDITION;
+		srb->status.combined = SAM_STAT_CHECK_CONDITION;
 		return;
 
 	case USB_STOR_TRANSPORT_FAILED:
@@ -645,13 +645,13 @@ static void isd200_invoke_transport( struct us_data *us,
 
 	case USB_STOR_TRANSPORT_ERROR:
 		usb_stor_dbg(us, "-- transport indicates transport error\n");
-		srb->result = DID_ERROR << 16;
+		srb->status.combined = DID_ERROR << 16;
 		/* Need reset here */
 		return;
     
 	default:
 		usb_stor_dbg(us, "-- transport indicates unknown error\n");
-		srb->result = DID_ERROR << 16;
+		srb->status.combined = DID_ERROR << 16;
 		/* Need reset here */
 		return;
 	}
@@ -674,13 +674,13 @@ static void isd200_invoke_transport( struct us_data *us,
 		}
 		if (result == ISD200_GOOD) {
 			isd200_build_sense(us, srb);
-			srb->result = SAM_STAT_CHECK_CONDITION;
+			srb->status.combined = SAM_STAT_CHECK_CONDITION;
 
 			/* If things are really okay, then let's show that */
 			if ((srb->sense_buffer[2] & 0xf) == 0x0)
-				srb->result = SAM_STAT_GOOD;
+				srb->status.combined = SAM_STAT_GOOD;
 		} else {
-			srb->result = DID_ERROR << 16;
+			srb->status.combined = DID_ERROR << 16;
 			/* Need reset here */
 		}
 	}
@@ -690,7 +690,7 @@ static void isd200_invoke_transport( struct us_data *us,
 	 * condition, show that in the result code
 	 */
 	if (transferStatus == USB_STOR_TRANSPORT_FAILED)
-		srb->result = SAM_STAT_CHECK_CONDITION;
+		srb->status.combined = SAM_STAT_CHECK_CONDITION;
 	return;
 
 	/*
@@ -698,7 +698,7 @@ static void isd200_invoke_transport( struct us_data *us,
 	 * following an abort
 	 */
 	Handle_Abort:
-	srb->result = DID_ABORT << 16;
+	srb->status.combined = DID_ABORT << 16;
 
 	/* permit the reset transfer to take place */
 	clear_bit(US_FLIDX_ABORTING, &us->dflags);
@@ -1238,7 +1238,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		/* copy InquiryData */
 		usb_stor_set_xfer_buf((unsigned char *) &info->InquiryData,
 				sizeof(info->InquiryData), srb);
-		srb->result = SAM_STAT_GOOD;
+		srb->status.combined = SAM_STAT_GOOD;
 		sendToTransport = 0;
 		break;
 
@@ -1258,7 +1258,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			isd200_srb_set_bufflen(srb, 0);
 		} else {
 			usb_stor_dbg(us, "   Media Status not supported, just report okay\n");
-			srb->result = SAM_STAT_GOOD;
+			srb->status.combined = SAM_STAT_GOOD;
 			sendToTransport = 0;
 		}
 		break;
@@ -1276,7 +1276,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			isd200_srb_set_bufflen(srb, 0);
 		} else {
 			usb_stor_dbg(us, "   Media Status not supported, just report okay\n");
-			srb->result = SAM_STAT_GOOD;
+			srb->status.combined = SAM_STAT_GOOD;
 			sendToTransport = 0;
 		}
 		break;
@@ -1299,7 +1299,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 
 		usb_stor_set_xfer_buf((unsigned char *) &readCapacityData,
 				sizeof(readCapacityData), srb);
-		srb->result = SAM_STAT_GOOD;
+		srb->status.combined = SAM_STAT_GOOD;
 		sendToTransport = 0;
 	}
 	break;
@@ -1384,7 +1384,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			isd200_srb_set_bufflen(srb, 0);
 		} else {
 			usb_stor_dbg(us, "   Not removable media, just report okay\n");
-			srb->result = SAM_STAT_GOOD;
+			srb->status.combined = SAM_STAT_GOOD;
 			sendToTransport = 0;
 		}
 		break;
@@ -1410,7 +1410,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			isd200_srb_set_bufflen(srb, 0);
 		} else {
 			usb_stor_dbg(us, "   Nothing to do, just report okay\n");
-			srb->result = SAM_STAT_GOOD;
+			srb->status.combined = SAM_STAT_GOOD;
 			sendToTransport = 0;
 		}
 		break;
@@ -1418,7 +1418,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 	default:
 		usb_stor_dbg(us, "Unsupported SCSI command - 0x%X\n",
 			     srb->cmnd[0]);
-		srb->result = DID_ERROR << 16;
+		srb->status.combined = DID_ERROR << 16;
 		sendToTransport = 0;
 		break;
 	}
@@ -1519,7 +1519,7 @@ static void isd200_ata_command(struct scsi_cmnd *srb, struct us_data *us)
 
 	if (us->extra == NULL) {
 		usb_stor_dbg(us, "ERROR Driver not initialized\n");
-		srb->result = DID_ERROR << 16;
+		srb->status.combined = DID_ERROR << 16;
 		return;
 	}
 
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 229bf0c1afc9..7f512aa09f1c 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -627,10 +627,10 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 		rc = jumpshot_id_device(us, info);
 		if (rc == USB_STOR_TRANSPORT_GOOD) {
 			info->sense_key = NO_SENSE;
-			srb->result = SUCCESS;
+			srb->status.combined = SUCCESS;
 		} else {
 			info->sense_key = UNIT_ATTENTION;
-			srb->result = SAM_STAT_CHECK_CONDITION;
+			srb->status.combined = SAM_STAT_CHECK_CONDITION;
 		}
 		return rc;
 	}
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 3789698d9d3c..4e6d8070b3d2 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -822,9 +822,9 @@ static void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			if ((srb->cmnd[0] == TEST_UNIT_READY) &&
 			    (chip->pwr_state == US_SUSPEND)) {
 				if (TST_LUN_READY(chip, srb->device->lun)) {
-					srb->result = SAM_STAT_GOOD;
+					srb->status.combined = SAM_STAT_GOOD;
 				} else {
-					srb->result = SAM_STAT_CHECK_CONDITION;
+					srb->status.combined = SAM_STAT_CHECK_CONDITION;
 					memcpy(srb->sense_buffer,
 					       media_not_present,
 					       US_SENSE_SIZE);
@@ -835,12 +835,12 @@ static void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			if (srb->cmnd[0] == ALLOW_MEDIUM_REMOVAL) {
 				int prevent = srb->cmnd[4] & 0x1;
 				if (prevent) {
-					srb->result = SAM_STAT_CHECK_CONDITION;
+					srb->status.combined = SAM_STAT_CHECK_CONDITION;
 					memcpy(srb->sense_buffer,
 					       invalid_cmd_field,
 					       US_SENSE_SIZE);
 				} else {
-					srb->result = SAM_STAT_GOOD;
+					srb->status.combined = SAM_STAT_GOOD;
 				}
 				usb_stor_dbg(us, "ALLOW_MEDIUM_REMOVAL\n");
 				goto out;
@@ -850,7 +850,7 @@ static void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			chip->proto_handler_backup(srb, us);
 			/* Check whether card is plugged in */
 			if (srb->cmnd[0] == TEST_UNIT_READY) {
-				if (srb->result == SAM_STAT_GOOD) {
+				if (srb->status.combined == SAM_STAT_GOOD) {
 					SET_LUN_READY(chip, srb->device->lun);
 					if (card_first_show) {
 						card_first_show = 0;
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index e5a971b83e3f..1e7be15c2604 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -378,7 +378,7 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	/* fail the command if we are disconnecting */
 	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
 		usb_stor_dbg(us, "Fail command during disconnect\n");
-		srb->result = DID_NO_CONNECT << 16;
+		srb->status.combined = DID_NO_CONNECT << 16;
 		done(srb);
 		return 0;
 	}
@@ -387,7 +387,7 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 			(srb->cmnd[0] == ATA_12 || srb->cmnd[0] == ATA_16)) {
 		memcpy(srb->sense_buffer, usb_stor_sense_invalidCDB,
 		       sizeof(usb_stor_sense_invalidCDB));
-		srb->result = SAM_STAT_CHECK_CONDITION;
+		srb->status.combined = SAM_STAT_CHECK_CONDITION;
 		done(srb);
 		return 0;
 	}
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 5eb895b19c55..eeab940db880 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -560,7 +560,7 @@ static void last_sector_hacks(struct us_data *us, struct scsi_cmnd *srb)
 	if (sector + 1 != sdkp->capacity)
 		goto done;
 
-	if (srb->result == SAM_STAT_GOOD && scsi_get_resid(srb) == 0) {
+	if (srb->status.combined == SAM_STAT_GOOD && scsi_get_resid(srb) == 0) {
 
 		/*
 		 * The command succeeded.  We know this device doesn't
@@ -580,7 +580,7 @@ static void last_sector_hacks(struct us_data *us, struct scsi_cmnd *srb)
 		 */
 		if (++us->last_sector_retries < 3)
 			return;
-		srb->result = SAM_STAT_CHECK_CONDITION;
+		srb->status.combined = SAM_STAT_CHECK_CONDITION;
 		memcpy(srb->sense_buffer, record_not_found,
 				sizeof(record_not_found));
 	}
@@ -616,25 +616,25 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 		usb_stor_dbg(us, "-- command was aborted\n");
-		srb->result = DID_ABORT << 16;
+		srb->status.combined = DID_ABORT << 16;
 		goto Handle_Errors;
 	}
 
 	/* if there is a transport error, reset and don't auto-sense */
 	if (result == USB_STOR_TRANSPORT_ERROR) {
 		usb_stor_dbg(us, "-- transport indicates error, resetting\n");
-		srb->result = DID_ERROR << 16;
+		srb->status.combined = DID_ERROR << 16;
 		goto Handle_Errors;
 	}
 
 	/* if the transport provided its own sense data, don't auto-sense */
 	if (result == USB_STOR_TRANSPORT_NO_SENSE) {
-		srb->result = SAM_STAT_CHECK_CONDITION;
+		srb->status.combined = SAM_STAT_CHECK_CONDITION;
 		last_sector_hacks(us, srb);
 		return;
 	}
 
-	srb->result = SAM_STAT_GOOD;
+	srb->status.combined = SAM_STAT_GOOD;
 
 	/*
 	 * Determine if we need to auto-sense
@@ -727,7 +727,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 			usb_stor_dbg(us, "-- auto-sense aborted\n");
-			srb->result = DID_ABORT << 16;
+			srb->status.combined = DID_ABORT << 16;
 
 			/* If SANE_SENSE caused this problem, disable it */
 			if (sense_size != US_SENSE_SIZE) {
@@ -761,7 +761,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			 * multi-target device, since failure of an
 			 * auto-sense is perfectly valid
 			 */
-			srb->result = DID_ERROR << 16;
+			srb->status.combined = DID_ERROR << 16;
 			if (!(us->fflags & US_FL_SCM_MULT_TARG))
 				goto Handle_Errors;
 			return;
@@ -802,7 +802,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 #endif
 
 		/* set the result so the higher layers expect this data */
-		srb->result = SAM_STAT_CHECK_CONDITION;
+		srb->status.combined = SAM_STAT_CHECK_CONDITION;
 
 		scdd = scsi_sense_desc_find(srb->sense_buffer,
 					    SCSI_SENSE_BUFFERSIZE, 4);
@@ -821,7 +821,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			 * won't realize we did an unsolicited auto-sense.
 			 */
 			if (result == USB_STOR_TRANSPORT_GOOD) {
-				srb->result = SAM_STAT_GOOD;
+				srb->status.combined = SAM_STAT_GOOD;
 				srb->sense_buffer[0] = 0x0;
 			}
 
@@ -842,7 +842,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			 * entering an infinite retry loop.
 			 */
 			else {
-				srb->result = DID_ERROR << 16;
+				srb->status.combined = DID_ERROR << 16;
 				if ((sshdr.response_code & 0x72) == 0x72)
 					srb->sense_buffer[1] = HARDWARE_ERROR;
 				else
@@ -861,7 +861,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 */
 	if (unlikely((us->fflags & US_FL_INITIAL_READ10) &&
 			srb->cmnd[0] == READ_10)) {
-		if (srb->result == SAM_STAT_GOOD) {
+		if (srb->status.combined == SAM_STAT_GOOD) {
 			set_bit(US_FLIDX_READ10_WORKED, &us->dflags);
 		} else if (test_bit(US_FLIDX_READ10_WORKED, &us->dflags)) {
 			clear_bit(US_FLIDX_READ10_WORKED, &us->dflags);
@@ -875,15 +875,15 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		 */
 		if (test_bit(US_FLIDX_REDO_READ10, &us->dflags)) {
 			clear_bit(US_FLIDX_REDO_READ10, &us->dflags);
-			srb->result = DID_IMM_RETRY << 16;
+			srb->status.combined = DID_IMM_RETRY << 16;
 			srb->sense_buffer[0] = 0;
 		}
 	}
 
 	/* Did we transfer less than the minimum amount required? */
-	if ((srb->result == SAM_STAT_GOOD || srb->sense_buffer[2] == 0) &&
+	if ((srb->status.combined == SAM_STAT_GOOD || srb->sense_buffer[2] == 0) &&
 			scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
-		srb->result = DID_ERROR << 16;
+		srb->status.combined = DID_ERROR << 16;
 
 	last_sector_hacks(us, srb);
 	return;
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index bef89c6bd1d7..3e67c56fcfd8 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -167,7 +167,7 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 		uas_log_cmd_state(cmnd, __func__, 0);
 		/* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
 		cmdinfo->state &= ~COMMAND_INFLIGHT;
-		cmnd->result = result << 16;
+		cmnd->status.combined = result << 16;
 		err = uas_try_complete(cmnd, __func__);
 		WARN_ON(err != 0);
 	}
@@ -194,7 +194,7 @@ static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 		memcpy(cmnd->sense_buffer, sense_iu->sense, len);
 	}
 
-	cmnd->result = sense_iu->status;
+	cmnd->status.combined = sense_iu->status;
 }
 
 static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *prefix,
@@ -339,7 +339,7 @@ static void uas_stat_cmplt(struct urb *urb)
 	switch (iu->iu_id) {
 	case IU_ID_STATUS:
 		uas_sense(urb, cmnd);
-		if (cmnd->result != 0) {
+		if (cmnd->status.combined != 0) {
 			/* cancel data transfers on error */
 			data_in_urb = usb_get_urb(cmdinfo->data_in_urb);
 			data_out_urb = usb_get_urb(cmdinfo->data_out_urb);
@@ -652,7 +652,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 			(cmnd->cmnd[0] == ATA_12 || cmnd->cmnd[0] == ATA_16)) {
 		memcpy(cmnd->sense_buffer, usb_stor_sense_invalidCDB,
 		       sizeof(usb_stor_sense_invalidCDB));
-		cmnd->result = SAM_STAT_CHECK_CONDITION;
+		cmnd->status.combined = SAM_STAT_CHECK_CONDITION;
 		cmnd->scsi_done(cmnd);
 		return 0;
 	}
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 90aa9c12ffac..88afbfa79f70 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -325,7 +325,7 @@ static int usb_stor_control_thread(void * __us)
 
 		/* has the command timed out *already* ? */
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-			srb->result = DID_ABORT << 16;
+			srb->status.combined = DID_ABORT << 16;
 			goto SkipForAbort;
 		}
 
@@ -337,7 +337,7 @@ static int usb_stor_control_thread(void * __us)
 		 */
 		if (srb->sc_data_direction == DMA_BIDIRECTIONAL) {
 			usb_stor_dbg(us, "UNKNOWN data direction\n");
-			srb->result = DID_ERROR << 16;
+			srb->status.combined = DID_ERROR << 16;
 		}
 
 		/*
@@ -349,14 +349,14 @@ static int usb_stor_control_thread(void * __us)
 			usb_stor_dbg(us, "Bad target number (%d:%llu)\n",
 				     srb->device->id,
 				     srb->device->lun);
-			srb->result = DID_BAD_TARGET << 16;
+			srb->status.combined = DID_BAD_TARGET << 16;
 		}
 
 		else if (srb->device->lun > us->max_lun) {
 			usb_stor_dbg(us, "Bad LUN (%d:%llu)\n",
 				     srb->device->id,
 				     srb->device->lun);
-			srb->result = DID_BAD_TARGET << 16;
+			srb->status.combined = DID_BAD_TARGET << 16;
 		}
 
 		/*
@@ -371,7 +371,7 @@ static int usb_stor_control_thread(void * __us)
 
 			usb_stor_dbg(us, "Faking INQUIRY command\n");
 			fill_inquiry_response(us, data_ptr, 36);
-			srb->result = SAM_STAT_GOOD;
+			srb->status.combined = SAM_STAT_GOOD;
 		}
 
 		/* we've got a command, let's do it! */
@@ -385,7 +385,7 @@ static int usb_stor_control_thread(void * __us)
 		scsi_lock(host);
 
 		/* was the command aborted? */
-		if (srb->result == DID_ABORT << 16) {
+		if (srb->status.combined == DID_ABORT << 16) {
 SkipForAbort:
 			usb_stor_dbg(us, "scsi command aborted\n");
 			srb = NULL;	/* Don't call srb->scsi_done() */
@@ -416,7 +416,7 @@ static int usb_stor_control_thread(void * __us)
 		/* now that the locks are released, notify the SCSI core */
 		if (srb) {
 			usb_stor_dbg(us, "scsi cmd done, result=0x%x\n",
-					srb->result);
+					srb->status.combined);
 			srb->scsi_done(srb);
 		}
 	} /* for (;;) */
