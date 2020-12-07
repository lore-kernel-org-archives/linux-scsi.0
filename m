Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D906C1B087
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5190823403
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgLGMug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:50:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:44212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbgLGMug (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 07:50:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CC01EAE76;
        Mon,  7 Dec 2020 12:48:31 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/35] aacraid: avoid setting message byte on completion
Date:   Mon,  7 Dec 2020 13:47:59 +0100
Message-Id: <20201207124819.95822-16-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201207124819.95822-1-hare@suse.de>
References: <20201207124819.95822-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The aacraid controller is a RAID controller, and the driver will
never see any SCSI messages. Plus it's quite pointless to set
the message byte if the host byte is already set, as the latter
takes precedence during error recovery.
So drop the message byte values for the final result.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/aacraid/aachba.c | 173 ++++++++++++++++--------------------------
 1 file changed, 64 insertions(+), 109 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 31233f6a0274..4ca5e13a26a6 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -556,7 +556,7 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 		}
 	}
 
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+	scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 
 	aac_fib_complete(fibptr);
 	scsicmd->scsi_done(scsicmd);
@@ -1092,7 +1092,7 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
 		}
 	}
 
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+	scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 
 	aac_fib_complete(fibptr);
 	scsicmd->scsi_done(scsicmd);
@@ -1191,8 +1191,7 @@ static int aac_bounds_32(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba)
 	if (lba & 0xffffffff00000000LL) {
 		int cid = scmd_id(cmd);
 		dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
-		cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-			SAM_STAT_CHECK_CONDITION;
+		cmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 		  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
 		  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
@@ -2364,13 +2363,11 @@ static void io_callback(void *context, struct fib * fibptr)
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
 	switch (le32_to_cpu(readreply->status)) {
 	case ST_OK:
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-			SAM_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 		dev->fsa_dev[cid].sense_data.sense_key = NO_SENSE;
 		break;
 	case ST_NOT_READY:
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-			SAM_STAT_CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data, NOT_READY,
 		  SENCODE_BECOMING_READY, ASENCODE_BECOMING_READY, 0, 0);
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
@@ -2378,8 +2375,7 @@ static void io_callback(void *context, struct fib * fibptr)
 			     SCSI_SENSE_BUFFERSIZE));
 		break;
 	case ST_MEDERR:
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-			SAM_STAT_CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data, MEDIUM_ERROR,
 		  SENCODE_UNRECOVERED_READ_ERROR, ASENCODE_NO_SENSE, 0, 0);
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
@@ -2391,8 +2387,7 @@ static void io_callback(void *context, struct fib * fibptr)
 		printk(KERN_WARNING "io_callback: io failed, status = %d\n",
 		  le32_to_cpu(readreply->status));
 #endif
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-			SAM_STAT_CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 		  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
 		  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
@@ -2467,8 +2462,7 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 	if ((lba + count) > (dev->fsa_dev[scmd_id(scsicmd)].size)) {
 		cid = scmd_id(scsicmd);
 		dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-			SAM_STAT_CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 			  ILLEGAL_REQUEST, SENCODE_LBA_OUT_OF_RANGE,
 			  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
@@ -2500,7 +2494,7 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 	/*
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
+	scsicmd->result = DID_OK << 16 | SAM_STAT_TASK_SET_FULL;
 	scsicmd->scsi_done(scsicmd);
 	aac_fib_complete(cmd_fibcontext);
 	aac_fib_free(cmd_fibcontext);
@@ -2559,8 +2553,7 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 	if ((lba + count) > (dev->fsa_dev[scmd_id(scsicmd)].size)) {
 		cid = scmd_id(scsicmd);
 		dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-			SAM_STAT_CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 			  ILLEGAL_REQUEST, SENCODE_LBA_OUT_OF_RANGE,
 			  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
@@ -2592,7 +2585,7 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 	/*
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
+	scsicmd->result = DID_OK << 16 | SAM_STAT_TASK_SET_FULL;
 	scsicmd->scsi_done(scsicmd);
 
 	aac_fib_complete(cmd_fibcontext);
@@ -2615,8 +2608,7 @@ static void synchronize_callback(void *context, struct fib *fibptr)
 
 	synchronizereply = fib_data(fibptr);
 	if (le32_to_cpu(synchronizereply->status) == CT_OK)
-		cmd->result = DID_OK << 16 |
-			COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+		cmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 	else {
 		struct scsi_device *sdev = cmd->device;
 		struct aac_dev *dev = fibptr->dev;
@@ -2624,8 +2616,7 @@ static void synchronize_callback(void *context, struct fib *fibptr)
 		printk(KERN_WARNING
 		     "synchronize_callback: synchronize failed, status = %d\n",
 		     le32_to_cpu(synchronizereply->status));
-		cmd->result = DID_OK << 16 |
-			COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
+		cmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 		  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
 		  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
@@ -2699,7 +2690,7 @@ static void aac_start_stop_callback(void *context, struct fib *fibptr)
 
 	BUG_ON(fibptr == NULL);
 
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+	scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 
 	aac_fib_complete(fibptr);
 	aac_fib_free(fibptr);
@@ -2716,8 +2707,7 @@ static int aac_start_stop(struct scsi_cmnd *scsicmd)
 
 	if (!(aac->supplement_adapter_info.supported_options2 &
 	      AAC_OPTION_POWER_MANAGEMENT)) {
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-				  SAM_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
@@ -2848,7 +2838,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		(scsicmd->cmnd[0] != TEST_UNIT_READY))
 	{
 		dprintk((KERN_WARNING "Only INQUIRY & TUR command supported for controller, rcvd = 0x%x.\n", scsicmd->cmnd[0]));
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 		  ILLEGAL_REQUEST, SENCODE_INVALID_COMMAND,
 		  ASENCODE_INVALID_COMMAND, 0, 0);
@@ -2877,8 +2867,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 
 	case SYNCHRONIZE_CACHE:
 		if (((aac_cache & 6) == 6) && dev->cache_protected) {
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-					  SAM_STAT_GOOD;
+			scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 			break;
 		}
 		/* Issue FIB to tell Firmware to flush it's cache */
@@ -2907,9 +2896,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				arr[1] = scsicmd->cmnd[2];
 				scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 							 sizeof(inq_data));
-				scsicmd->result = DID_OK << 16 |
-						  COMMAND_COMPLETE << 8 |
-						  SAM_STAT_GOOD;
+				scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 			} else if (scsicmd->cmnd[2] == 0x80) {
 				/* unit serial number page */
 				arr[3] = setinqserial(dev, &arr[4],
@@ -2920,9 +2907,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				if (aac_wwn != 2)
 					return aac_get_container_serial(
 						scsicmd);
-				scsicmd->result = DID_OK << 16 |
-						  COMMAND_COMPLETE << 8 |
-						  SAM_STAT_GOOD;
+				scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 			} else if (scsicmd->cmnd[2] == 0x83) {
 				/* vpd page 0x83 - Device Identification Page */
 				char *sno = (char *)&inq_data;
@@ -2931,14 +2916,10 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				if (aac_wwn != 2)
 					return aac_get_container_serial(
 						scsicmd);
-				scsicmd->result = DID_OK << 16 |
-						  COMMAND_COMPLETE << 8 |
-						  SAM_STAT_GOOD;
+				scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 			} else {
 				/* vpd page not implemented */
-				scsicmd->result = DID_OK << 16 |
-				  COMMAND_COMPLETE << 8 |
-				  SAM_STAT_CHECK_CONDITION;
+				scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 				set_sense(&dev->fsa_dev[cid].sense_data,
 				  ILLEGAL_REQUEST, SENCODE_INVALID_CDB_FIELD,
 				  ASENCODE_NO_SENSE, 7, 2);
@@ -2964,8 +2945,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			inq_data.inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 			scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 						 sizeof(inq_data));
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-					  SAM_STAT_GOOD;
+			scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 			break;
 		}
 		if (dev->in_reset)
@@ -3014,8 +2994,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;
 
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-				  SAM_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 		break;
 	}
 
@@ -3041,8 +3020,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		scsi_sg_copy_from_buffer(scsicmd, cp, sizeof(cp));
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-				  SAM_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 		break;
 	}
 
@@ -3121,8 +3099,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		scsi_sg_copy_from_buffer(scsicmd,
 					 (char *)&mpd,
 					 mode_buf_length);
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-				  SAM_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 		break;
 	}
 	case MODE_SENSE_10:
@@ -3199,8 +3176,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 					 (char *)&mpd10,
 					 mode_buf_length);
 
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-				  SAM_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 		break;
 	}
 	case REQUEST_SENSE:
@@ -3209,8 +3185,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				sizeof(struct sense_data));
 		memset(&dev->fsa_dev[cid].sense_data, 0,
 				sizeof(struct sense_data));
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-				  SAM_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 		break;
 
 	case ALLOW_MEDIUM_REMOVAL:
@@ -3220,16 +3195,14 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		else
 			fsa_dev_ptr[cid].locked = 0;
 
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-				  SAM_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 		break;
 	/*
 	 *	These commands are all No-Ops
 	 */
 	case TEST_UNIT_READY:
 		if (fsa_dev_ptr[cid].sense_data.sense_key == NOT_READY) {
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-				SAM_STAT_CHECK_CONDITION;
+			scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 			set_sense(&dev->fsa_dev[cid].sense_data,
 				  NOT_READY, SENCODE_BECOMING_READY,
 				  ASENCODE_BECOMING_READY, 0, 0);
@@ -3246,8 +3219,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	case REZERO_UNIT:
 	case REASSIGN_BLOCKS:
 	case SEEK_10:
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-				  SAM_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 		break;
 
 	case START_STOP:
@@ -3259,8 +3231,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	 */
 		dprintk((KERN_WARNING "Unhandled SCSI Command: 0x%x.\n",
 				scsicmd->cmnd[0]));
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-				SAM_STAT_CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 			  ILLEGAL_REQUEST, SENCODE_INVALID_COMMAND,
 			  ASENCODE_INVALID_COMMAND, 0, 0);
@@ -3441,9 +3412,7 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 				le32_to_cpu(srbreply->status));
 		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
 			    SCSI_SENSE_BUFFERSIZE);
-		scsicmd->result = DID_ERROR << 16
-				| COMMAND_COMPLETE << 8
-				| SAM_STAT_CHECK_CONDITION;
+		scsicmd->result = DID_ERROR << 16 | SAM_STAT_CHECK_CONDITION;
 		memcpy(scsicmd->sense_buffer,
 				srbreply->sense_data, len);
 	}
@@ -3455,7 +3424,7 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 	case SRB_STATUS_ERROR_RECOVERY:
 	case SRB_STATUS_PENDING:
 	case SRB_STATUS_SUCCESS:
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_OK << 16;
 		break;
 	case SRB_STATUS_DATA_OVERRUN:
 		switch (scsicmd->cmnd[0]) {
@@ -3472,60 +3441,52 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 				pr_warn("aacraid: SCSI CMD underflow\n");
 			else
 				pr_warn("aacraid: SCSI CMD Data Overrun\n");
-			scsicmd->result = DID_ERROR << 16
-					| COMMAND_COMPLETE << 8;
+			scsicmd->result = DID_ERROR << 16;
 			break;
 		case INQUIRY:
-			scsicmd->result = DID_OK << 16
-					| COMMAND_COMPLETE << 8;
+			scsicmd->result = DID_OK << 16;
 			break;
 		default:
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			scsicmd->result = DID_OK << 16;
 			break;
 		}
 		break;
 	case SRB_STATUS_ABORTED:
-		scsicmd->result = DID_ABORT << 16 | ABORT << 8;
+		scsicmd->result = DID_ABORT << 16;
 		break;
 	case SRB_STATUS_ABORT_FAILED:
 		/*
 		 * Not sure about this one - but assuming the
 		 * hba was trying to abort for some reason
 		 */
-		scsicmd->result = DID_ERROR << 16 | ABORT << 8;
+		scsicmd->result = DID_ERROR << 16;
 		break;
 	case SRB_STATUS_PARITY_ERROR:
-		scsicmd->result = DID_PARITY << 16
-				| MSG_PARITY_ERROR << 8;
+		scsicmd->result = DID_PARITY << 16;
 		break;
 	case SRB_STATUS_NO_DEVICE:
 	case SRB_STATUS_INVALID_PATH_ID:
 	case SRB_STATUS_INVALID_TARGET_ID:
 	case SRB_STATUS_INVALID_LUN:
 	case SRB_STATUS_SELECTION_TIMEOUT:
-		scsicmd->result = DID_NO_CONNECT << 16
-				| COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_NO_CONNECT << 16;
 		break;
 
 	case SRB_STATUS_COMMAND_TIMEOUT:
 	case SRB_STATUS_TIMEOUT:
-		scsicmd->result = DID_TIME_OUT << 16
-				| COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_TIME_OUT << 16;
 		break;
 
 	case SRB_STATUS_BUSY:
-		scsicmd->result = DID_BUS_BUSY << 16
-				| COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_BUS_BUSY << 16;
 		break;
 
 	case SRB_STATUS_BUS_RESET:
-		scsicmd->result = DID_RESET << 16
-				| COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_RESET << 16;
 		break;
 
 	case SRB_STATUS_MESSAGE_REJECTED:
-		scsicmd->result = DID_ERROR << 16
-				| MESSAGE_REJECT << 8;
+		scsicmd->result = DID_ERROR << 16;
 		break;
 	case SRB_STATUS_REQUEST_FLUSHED:
 	case SRB_STATUS_ERROR:
@@ -3561,19 +3522,14 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 			|| (scsicmd->cmnd[0] == ATA_16)) {
 
 			if (scsicmd->cmnd[2] & (0x01 << 5)) {
-				scsicmd->result = DID_OK << 16
-					| COMMAND_COMPLETE << 8;
-			break;
+				scsicmd->result = DID_OK << 16;
 			} else {
-				scsicmd->result = DID_ERROR << 16
-					| COMMAND_COMPLETE << 8;
-			break;
+				scsicmd->result = DID_ERROR << 16;
 			}
 		} else {
-			scsicmd->result = DID_ERROR << 16
-				| COMMAND_COMPLETE << 8;
-			break;
+			scsicmd->result = DID_ERROR << 16;
 		}
+		break;
 	}
 	if (le32_to_cpu(srbreply->scsi_status)
 			== SAM_STAT_CHECK_CONDITION) {
@@ -3609,7 +3565,7 @@ static void hba_resp_task_complete(struct aac_dev *dev,
 
 	switch (err->status) {
 	case SAM_STAT_GOOD:
-		scsicmd->result |= DID_OK << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result |= DID_OK << 16;
 		break;
 	case SAM_STAT_CHECK_CONDITION:
 	{
@@ -3620,19 +3576,19 @@ static void hba_resp_task_complete(struct aac_dev *dev,
 		if (len)
 			memcpy(scsicmd->sense_buffer,
 				err->sense_response_buf, len);
-		scsicmd->result |= DID_OK << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result |= DID_OK << 16;
 		break;
 	}
 	case SAM_STAT_BUSY:
-		scsicmd->result |= DID_BUS_BUSY << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result |= DID_BUS_BUSY << 16;
 		break;
 	case SAM_STAT_TASK_ABORTED:
-		scsicmd->result |= DID_ABORT << 16 | ABORT << 8;
+		scsicmd->result |= DID_ABORT << 16;
 		break;
 	case SAM_STAT_RESERVATION_CONFLICT:
 	case SAM_STAT_TASK_SET_FULL:
 	default:
-		scsicmd->result |= DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result |= DID_ERROR << 16;
 		break;
 	}
 }
@@ -3652,27 +3608,26 @@ static void hba_resp_task_failure(struct aac_dev *dev,
 			dev->hba_map[bus][cid].devtype = AAC_DEVTYPE_ARC_RAW;
 			dev->hba_map[bus][cid].rmw_nexus = 0xffffffff;
 		}
-		scsicmd->result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_NO_CONNECT << 16;
 		break;
 	}
 	case HBA_RESP_STAT_IO_ERROR:
 	case HBA_RESP_STAT_NO_PATH_TO_DEVICE:
-		scsicmd->result = DID_OK << 16 |
-			COMMAND_COMPLETE << 8 | SAM_STAT_BUSY;
+		scsicmd->result = DID_OK << 16 | SAM_STAT_BUSY;
 		break;
 	case HBA_RESP_STAT_IO_ABORTED:
-		scsicmd->result = DID_ABORT << 16 | ABORT << 8;
+		scsicmd->result = DID_ABORT << 16;
 		break;
 	case HBA_RESP_STAT_INVALID_DEVICE:
-		scsicmd->result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_NO_CONNECT << 16;
 		break;
 	case HBA_RESP_STAT_UNDERRUN:
 		/* UNDERRUN is OK */
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_OK << 16;
 		break;
 	case HBA_RESP_STAT_OVERRUN:
 	default:
-		scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_ERROR << 16;
 		break;
 	}
 }
@@ -3705,7 +3660,7 @@ void aac_hba_callback(void *context, struct fib *fibptr)
 
 	if (fibptr->flags & FIB_CONTEXT_FLAG_FASTRESP) {
 		/* fast response */
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_OK << 16;
 		goto out;
 	}
 
@@ -3717,17 +3672,17 @@ void aac_hba_callback(void *context, struct fib *fibptr)
 		hba_resp_task_failure(dev, scsicmd, err);
 		break;
 	case HBA_RESP_SVCRES_TMF_REJECTED:
-		scsicmd->result = DID_ERROR << 16 | MESSAGE_REJECT << 8;
+		scsicmd->result = DID_ERROR << 16;
 		break;
 	case HBA_RESP_SVCRES_TMF_LUN_INVALID:
-		scsicmd->result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_NO_CONNECT << 16;
 		break;
 	case HBA_RESP_SVCRES_TMF_COMPLETE:
 	case HBA_RESP_SVCRES_TMF_SUCCEEDED:
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_OK << 16;
 		break;
 	default:
-		scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		scsicmd->result = DID_ERROR << 16;
 		break;
 	}
 
-- 
2.16.4

