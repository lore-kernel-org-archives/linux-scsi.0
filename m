Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61819C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45841613B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhDTAKF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:05 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:39427 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbhDTAJv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:51 -0400
Received: by mail-pg1-f179.google.com with SMTP id s22so4290451pgk.6
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZAnFHlYsbrhxzAh/ucwqA/x5Qkp3UvUFH9IDWwPMto=;
        b=sOJFzB5mRsHMLehFcAG+qdr06D633yZNFXfbFUe+cYDL8d7XPoPZ1DC2L1LyzIdJk7
         Y/Z3TqLiX45YSxtCRYifigZAc/1tGLmdnNqD4+U2doXfJuA7ux2fcg63BLsprz4cPSVC
         HTYKT1yh12UayepdTNjjBbmpBi6KaNHBWttL2uw4EgY+JWUFInd9844i2nnKb1h0AuxP
         JkKjNq776Xo6kx44nmA9Op0v6CtbfeYMNOqBZl1nT0SvkXH7S3C+3Sd+H3HFqQBjMcYv
         w8Rs+9XeU2by5GJ03gsKzuCGgXNOUjLXi/QjRz3aX6sF6Y3DPlHUm0VQbPHVgNDO2rAd
         jWxw==
X-Gm-Message-State: AOAM531Rj0FxyNzbzZdYrrjKkj8QDBAMwg7lpbHtLiUfBgeJxn4dbqPy
        fCS4Egzj/0GQpGOHP4m9Kl0=
X-Google-Smtp-Source: ABdhPJzlKx7nk1zr8eBsdAQ3lldQDz10ZuIAq7Y/ciI8kiRVAIGDgQsGDv58Vyh3N3Z3gdddug1ViQ==
X-Received: by 2002:a63:1e62:: with SMTP id p34mr5341991pgm.355.1618877360220;
        Mon, 19 Apr 2021 17:09:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 024/117] aacraid: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:12 -0700
Message-Id: <20210420000845.25873-25-bvanassche@acm.org>
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

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/aachba.c | 142 +++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index f1f62b5da8b7..a70b243990d5 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -556,7 +556,7 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 		}
 	}
 
-	scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+	scsicmd->status.combined = SAM_STAT_GOOD;
 
 	aac_fib_complete(fibptr);
 	scsicmd->scsi_done(scsicmd);
@@ -614,7 +614,7 @@ static int aac_probe_container_callback2(struct scsi_cmnd * scsicmd)
 	if ((fsa_dev_ptr[scmd_id(scsicmd)].valid & 1))
 		return aac_scsi_cmd(scsicmd);
 
-	scsicmd->result = DID_NO_CONNECT << 16;
+	scsicmd->status.combined = DID_NO_CONNECT << 16;
 	scsicmd->scsi_done(scsicmd);
 	return 0;
 }
@@ -1092,7 +1092,7 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
 		}
 	}
 
-	scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+	scsicmd->status.combined = SAM_STAT_GOOD;
 
 	aac_fib_complete(fibptr);
 	scsicmd->scsi_done(scsicmd);
@@ -1191,7 +1191,7 @@ static int aac_bounds_32(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba)
 	if (lba & 0xffffffff00000000LL) {
 		int cid = scmd_id(cmd);
 		dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
-		cmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+		cmd->status.combined = SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 		  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
 		  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
@@ -2358,11 +2358,11 @@ static void io_callback(void *context, struct fib * fibptr)
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
 	switch (le32_to_cpu(readreply->status)) {
 	case ST_OK:
-		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+		scsicmd->status.combined = SAM_STAT_GOOD;
 		dev->fsa_dev[cid].sense_data.sense_key = NO_SENSE;
 		break;
 	case ST_NOT_READY:
-		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+		scsicmd->status.combined = SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data, NOT_READY,
 		  SENCODE_BECOMING_READY, ASENCODE_BECOMING_READY, 0, 0);
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
@@ -2370,7 +2370,7 @@ static void io_callback(void *context, struct fib * fibptr)
 			     SCSI_SENSE_BUFFERSIZE));
 		break;
 	case ST_MEDERR:
-		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+		scsicmd->status.combined = SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data, MEDIUM_ERROR,
 		  SENCODE_UNRECOVERED_READ_ERROR, ASENCODE_NO_SENSE, 0, 0);
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
@@ -2382,7 +2382,7 @@ static void io_callback(void *context, struct fib * fibptr)
 		printk(KERN_WARNING "io_callback: io failed, status = %d\n",
 		  le32_to_cpu(readreply->status));
 #endif
-		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+		scsicmd->status.combined = SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 		  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
 		  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
@@ -2457,7 +2457,7 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 	if ((lba + count) > (dev->fsa_dev[scmd_id(scsicmd)].size)) {
 		cid = scmd_id(scsicmd);
 		dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
-		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+		scsicmd->status.combined = SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 			  ILLEGAL_REQUEST, SENCODE_LBA_OUT_OF_RANGE,
 			  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
@@ -2489,7 +2489,7 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 	/*
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
-	scsicmd->result = DID_OK << 16 | SAM_STAT_TASK_SET_FULL;
+	scsicmd->status.combined = SAM_STAT_TASK_SET_FULL;
 	scsicmd->scsi_done(scsicmd);
 	aac_fib_complete(cmd_fibcontext);
 	aac_fib_free(cmd_fibcontext);
@@ -2548,7 +2548,7 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 	if ((lba + count) > (dev->fsa_dev[scmd_id(scsicmd)].size)) {
 		cid = scmd_id(scsicmd);
 		dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
-		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+		scsicmd->status.combined = SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 			  ILLEGAL_REQUEST, SENCODE_LBA_OUT_OF_RANGE,
 			  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
@@ -2580,7 +2580,7 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 	/*
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
-	scsicmd->result = DID_OK << 16 | SAM_STAT_TASK_SET_FULL;
+	scsicmd->status.combined = SAM_STAT_TASK_SET_FULL;
 	scsicmd->scsi_done(scsicmd);
 
 	aac_fib_complete(cmd_fibcontext);
@@ -2603,7 +2603,7 @@ static void synchronize_callback(void *context, struct fib *fibptr)
 
 	synchronizereply = fib_data(fibptr);
 	if (le32_to_cpu(synchronizereply->status) == CT_OK)
-		cmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+		cmd->status.combined = SAM_STAT_GOOD;
 	else {
 		struct scsi_device *sdev = cmd->device;
 		struct aac_dev *dev = fibptr->dev;
@@ -2611,7 +2611,7 @@ static void synchronize_callback(void *context, struct fib *fibptr)
 		printk(KERN_WARNING
 		     "synchronize_callback: synchronize failed, status = %d\n",
 		     le32_to_cpu(synchronizereply->status));
-		cmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+		cmd->status.combined = SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 		  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
 		  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
@@ -2685,7 +2685,7 @@ static void aac_start_stop_callback(void *context, struct fib *fibptr)
 
 	BUG_ON(fibptr == NULL);
 
-	scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+	scsicmd->status.combined = SAM_STAT_GOOD;
 
 	aac_fib_complete(fibptr);
 	aac_fib_free(fibptr);
@@ -2702,7 +2702,7 @@ static int aac_start_stop(struct scsi_cmnd *scsicmd)
 
 	if (!(aac->supplement_adapter_info.supported_options2 &
 	      AAC_OPTION_POWER_MANAGEMENT)) {
-		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+		scsicmd->status.combined = SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
@@ -2777,7 +2777,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		if (scmd_channel(scsicmd) == CONTAINER_CHANNEL) {
 			if((cid >= dev->maximum_num_containers) ||
 					(scsicmd->device->lun != 0)) {
-				scsicmd->result = DID_NO_CONNECT << 16;
+				scsicmd->status.combined = DID_NO_CONNECT << 16;
 				goto scsi_done_ret;
 			}
 
@@ -2821,7 +2821,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 					return -1;
 				return aac_send_srb_fib(scsicmd);
 			} else {
-				scsicmd->result = DID_NO_CONNECT << 16;
+				scsicmd->status.combined = DID_NO_CONNECT << 16;
 				goto scsi_done_ret;
 			}
 		}
@@ -2833,7 +2833,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		(scsicmd->cmnd[0] != TEST_UNIT_READY))
 	{
 		dprintk((KERN_WARNING "Only INQUIRY & TUR command supported for controller, rcvd = 0x%x.\n", scsicmd->cmnd[0]));
-		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+		scsicmd->status.combined = SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 		  ILLEGAL_REQUEST, SENCODE_INVALID_COMMAND,
 		  ASENCODE_INVALID_COMMAND, 0, 0);
@@ -2862,7 +2862,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 
 	case SYNCHRONIZE_CACHE:
 		if (((aac_cache & 6) == 6) && dev->cache_protected) {
-			scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+			scsicmd->status.combined = SAM_STAT_GOOD;
 			break;
 		}
 		/* Issue FIB to tell Firmware to flush it's cache */
@@ -2891,7 +2891,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				arr[1] = scsicmd->cmnd[2];
 				scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 							 sizeof(inq_data));
-				scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+				scsicmd->status.combined = SAM_STAT_GOOD;
 			} else if (scsicmd->cmnd[2] == 0x80) {
 				/* unit serial number page */
 				arr[3] = setinqserial(dev, &arr[4],
@@ -2902,7 +2902,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				if (aac_wwn != 2)
 					return aac_get_container_serial(
 						scsicmd);
-				scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+				scsicmd->status.combined = SAM_STAT_GOOD;
 			} else if (scsicmd->cmnd[2] == 0x83) {
 				/* vpd page 0x83 - Device Identification Page */
 				char *sno = (char *)&inq_data;
@@ -2911,10 +2911,10 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				if (aac_wwn != 2)
 					return aac_get_container_serial(
 						scsicmd);
-				scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+				scsicmd->status.combined = SAM_STAT_GOOD;
 			} else {
 				/* vpd page not implemented */
-				scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+				scsicmd->status.combined = SAM_STAT_CHECK_CONDITION;
 				set_sense(&dev->fsa_dev[cid].sense_data,
 				  ILLEGAL_REQUEST, SENCODE_INVALID_CDB_FIELD,
 				  ASENCODE_NO_SENSE, 7, 2);
@@ -2940,7 +2940,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			inq_data.inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 			scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 						 sizeof(inq_data));
-			scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+			scsicmd->status.combined = SAM_STAT_GOOD;
 			break;
 		}
 		if (dev->in_reset)
@@ -2989,7 +2989,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;
 
-		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+		scsicmd->status.combined = SAM_STAT_GOOD;
 		break;
 	}
 
@@ -3015,7 +3015,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		scsi_sg_copy_from_buffer(scsicmd, cp, sizeof(cp));
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;
-		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+		scsicmd->status.combined = SAM_STAT_GOOD;
 		break;
 	}
 
@@ -3094,7 +3094,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		scsi_sg_copy_from_buffer(scsicmd,
 					 (char *)&mpd,
 					 mode_buf_length);
-		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+		scsicmd->status.combined = SAM_STAT_GOOD;
 		break;
 	}
 	case MODE_SENSE_10:
@@ -3171,7 +3171,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 					 (char *)&mpd10,
 					 mode_buf_length);
 
-		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+		scsicmd->status.combined = SAM_STAT_GOOD;
 		break;
 	}
 	case REQUEST_SENSE:
@@ -3180,7 +3180,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				sizeof(struct sense_data));
 		memset(&dev->fsa_dev[cid].sense_data, 0,
 				sizeof(struct sense_data));
-		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+		scsicmd->status.combined = SAM_STAT_GOOD;
 		break;
 
 	case ALLOW_MEDIUM_REMOVAL:
@@ -3190,14 +3190,14 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		else
 			fsa_dev_ptr[cid].locked = 0;
 
-		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+		scsicmd->status.combined = SAM_STAT_GOOD;
 		break;
 	/*
 	 *	These commands are all No-Ops
 	 */
 	case TEST_UNIT_READY:
 		if (fsa_dev_ptr[cid].sense_data.sense_key == NOT_READY) {
-			scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+			scsicmd->status.combined = SAM_STAT_CHECK_CONDITION;
 			set_sense(&dev->fsa_dev[cid].sense_data,
 				  NOT_READY, SENCODE_BECOMING_READY,
 				  ASENCODE_BECOMING_READY, 0, 0);
@@ -3214,7 +3214,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	case REZERO_UNIT:
 	case REASSIGN_BLOCKS:
 	case SEEK_10:
-		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
+		scsicmd->status.combined = SAM_STAT_GOOD;
 		break;
 
 	case START_STOP:
@@ -3226,7 +3226,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	 */
 		dprintk((KERN_WARNING "Unhandled SCSI Command: 0x%x.\n",
 				scsicmd->cmnd[0]));
-		scsicmd->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+		scsicmd->status.combined = SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 			  ILLEGAL_REQUEST, SENCODE_INVALID_COMMAND,
 			  ASENCODE_INVALID_COMMAND, 0, 0);
@@ -3407,7 +3407,7 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 				le32_to_cpu(srbreply->status));
 		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
 			    SCSI_SENSE_BUFFERSIZE);
-		scsicmd->result = DID_ERROR << 16 | SAM_STAT_CHECK_CONDITION;
+		scsicmd->status.combined = DID_ERROR << 16 | SAM_STAT_CHECK_CONDITION;
 		memcpy(scsicmd->sense_buffer,
 				srbreply->sense_data, len);
 	}
@@ -3419,7 +3419,7 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 	case SRB_STATUS_ERROR_RECOVERY:
 	case SRB_STATUS_PENDING:
 	case SRB_STATUS_SUCCESS:
-		scsicmd->result = DID_OK << 16;
+		scsicmd->status.combined = 0;
 		break;
 	case SRB_STATUS_DATA_OVERRUN:
 		switch (scsicmd->cmnd[0]) {
@@ -3436,52 +3436,52 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 				pr_warn("aacraid: SCSI CMD underflow\n");
 			else
 				pr_warn("aacraid: SCSI CMD Data Overrun\n");
-			scsicmd->result = DID_ERROR << 16;
+			scsicmd->status.combined = DID_ERROR << 16;
 			break;
 		case INQUIRY:
-			scsicmd->result = DID_OK << 16;
+			scsicmd->status.combined = 0;
 			break;
 		default:
-			scsicmd->result = DID_OK << 16;
+			scsicmd->status.combined = 0;
 			break;
 		}
 		break;
 	case SRB_STATUS_ABORTED:
-		scsicmd->result = DID_ABORT << 16;
+		scsicmd->status.combined = DID_ABORT << 16;
 		break;
 	case SRB_STATUS_ABORT_FAILED:
 		/*
 		 * Not sure about this one - but assuming the
 		 * hba was trying to abort for some reason
 		 */
-		scsicmd->result = DID_ERROR << 16;
+		scsicmd->status.combined = DID_ERROR << 16;
 		break;
 	case SRB_STATUS_PARITY_ERROR:
-		scsicmd->result = DID_PARITY << 16;
+		scsicmd->status.combined = DID_PARITY << 16;
 		break;
 	case SRB_STATUS_NO_DEVICE:
 	case SRB_STATUS_INVALID_PATH_ID:
 	case SRB_STATUS_INVALID_TARGET_ID:
 	case SRB_STATUS_INVALID_LUN:
 	case SRB_STATUS_SELECTION_TIMEOUT:
-		scsicmd->result = DID_NO_CONNECT << 16;
+		scsicmd->status.combined = DID_NO_CONNECT << 16;
 		break;
 
 	case SRB_STATUS_COMMAND_TIMEOUT:
 	case SRB_STATUS_TIMEOUT:
-		scsicmd->result = DID_TIME_OUT << 16;
+		scsicmd->status.combined = DID_TIME_OUT << 16;
 		break;
 
 	case SRB_STATUS_BUSY:
-		scsicmd->result = DID_BUS_BUSY << 16;
+		scsicmd->status.combined = DID_BUS_BUSY << 16;
 		break;
 
 	case SRB_STATUS_BUS_RESET:
-		scsicmd->result = DID_RESET << 16;
+		scsicmd->status.combined = DID_RESET << 16;
 		break;
 
 	case SRB_STATUS_MESSAGE_REJECTED:
-		scsicmd->result = DID_ERROR << 16;
+		scsicmd->status.combined = DID_ERROR << 16;
 		break;
 	case SRB_STATUS_REQUEST_FLUSHED:
 	case SRB_STATUS_ERROR:
@@ -3517,12 +3517,12 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 			|| (scsicmd->cmnd[0] == ATA_16)) {
 
 			if (scsicmd->cmnd[2] & (0x01 << 5)) {
-				scsicmd->result = DID_OK << 16;
+				scsicmd->status.combined = 0;
 			} else {
-				scsicmd->result = DID_ERROR << 16;
+				scsicmd->status.combined = DID_ERROR << 16;
 			}
 		} else {
-			scsicmd->result = DID_ERROR << 16;
+			scsicmd->status.combined = DID_ERROR << 16;
 		}
 		break;
 	}
@@ -3530,7 +3530,7 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 			== SAM_STAT_CHECK_CONDITION) {
 		int len;
 
-		scsicmd->result |= SAM_STAT_CHECK_CONDITION;
+		scsicmd->status.combined |= SAM_STAT_CHECK_CONDITION;
 		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
 			    SCSI_SENSE_BUFFERSIZE);
 #ifdef AAC_DETAILED_STATUS_INFO
@@ -3544,7 +3544,7 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 	/*
 	 * OR in the scsi status (already shifted up a bit)
 	 */
-	scsicmd->result |= le32_to_cpu(srbreply->scsi_status);
+	scsicmd->status.combined |= le32_to_cpu(srbreply->scsi_status);
 
 	aac_fib_complete(fibptr);
 	scsicmd->scsi_done(scsicmd);
@@ -3554,13 +3554,13 @@ static void hba_resp_task_complete(struct aac_dev *dev,
 					struct scsi_cmnd *scsicmd,
 					struct aac_hba_resp *err) {
 
-	scsicmd->result = err->status;
+	scsicmd->status.combined = err->status;
 	/* set residual count */
 	scsi_set_resid(scsicmd, le32_to_cpu(err->residual_count));
 
 	switch (err->status) {
 	case SAM_STAT_GOOD:
-		scsicmd->result |= DID_OK << 16;
+		scsicmd->status.combined |= 0;
 		break;
 	case SAM_STAT_CHECK_CONDITION:
 	{
@@ -3571,19 +3571,19 @@ static void hba_resp_task_complete(struct aac_dev *dev,
 		if (len)
 			memcpy(scsicmd->sense_buffer,
 				err->sense_response_buf, len);
-		scsicmd->result |= DID_OK << 16;
+		scsicmd->status.combined |= 0;
 		break;
 	}
 	case SAM_STAT_BUSY:
-		scsicmd->result |= DID_BUS_BUSY << 16;
+		scsicmd->status.combined |= DID_BUS_BUSY << 16;
 		break;
 	case SAM_STAT_TASK_ABORTED:
-		scsicmd->result |= DID_ABORT << 16;
+		scsicmd->status.combined |= DID_ABORT << 16;
 		break;
 	case SAM_STAT_RESERVATION_CONFLICT:
 	case SAM_STAT_TASK_SET_FULL:
 	default:
-		scsicmd->result |= DID_ERROR << 16;
+		scsicmd->status.combined |= DID_ERROR << 16;
 		break;
 	}
 }
@@ -3603,26 +3603,26 @@ static void hba_resp_task_failure(struct aac_dev *dev,
 			dev->hba_map[bus][cid].devtype = AAC_DEVTYPE_ARC_RAW;
 			dev->hba_map[bus][cid].rmw_nexus = 0xffffffff;
 		}
-		scsicmd->result = DID_NO_CONNECT << 16;
+		scsicmd->status.combined = DID_NO_CONNECT << 16;
 		break;
 	}
 	case HBA_RESP_STAT_IO_ERROR:
 	case HBA_RESP_STAT_NO_PATH_TO_DEVICE:
-		scsicmd->result = DID_OK << 16 | SAM_STAT_BUSY;
+		scsicmd->status.combined = SAM_STAT_BUSY;
 		break;
 	case HBA_RESP_STAT_IO_ABORTED:
-		scsicmd->result = DID_ABORT << 16;
+		scsicmd->status.combined = DID_ABORT << 16;
 		break;
 	case HBA_RESP_STAT_INVALID_DEVICE:
-		scsicmd->result = DID_NO_CONNECT << 16;
+		scsicmd->status.combined = DID_NO_CONNECT << 16;
 		break;
 	case HBA_RESP_STAT_UNDERRUN:
 		/* UNDERRUN is OK */
-		scsicmd->result = DID_OK << 16;
+		scsicmd->status.combined = 0;
 		break;
 	case HBA_RESP_STAT_OVERRUN:
 	default:
-		scsicmd->result = DID_ERROR << 16;
+		scsicmd->status.combined = DID_ERROR << 16;
 		break;
 	}
 }
@@ -3655,7 +3655,7 @@ void aac_hba_callback(void *context, struct fib *fibptr)
 
 	if (fibptr->flags & FIB_CONTEXT_FLAG_FASTRESP) {
 		/* fast response */
-		scsicmd->result = DID_OK << 16;
+		scsicmd->status.combined = 0;
 		goto out;
 	}
 
@@ -3667,17 +3667,17 @@ void aac_hba_callback(void *context, struct fib *fibptr)
 		hba_resp_task_failure(dev, scsicmd, err);
 		break;
 	case HBA_RESP_SVCRES_TMF_REJECTED:
-		scsicmd->result = DID_ERROR << 16;
+		scsicmd->status.combined = DID_ERROR << 16;
 		break;
 	case HBA_RESP_SVCRES_TMF_LUN_INVALID:
-		scsicmd->result = DID_NO_CONNECT << 16;
+		scsicmd->status.combined = DID_NO_CONNECT << 16;
 		break;
 	case HBA_RESP_SVCRES_TMF_COMPLETE:
 	case HBA_RESP_SVCRES_TMF_SUCCEEDED:
-		scsicmd->result = DID_OK << 16;
+		scsicmd->status.combined = 0;
 		break;
 	default:
-		scsicmd->result = DID_ERROR << 16;
+		scsicmd->status.combined = DID_ERROR << 16;
 		break;
 	}
 
@@ -3706,7 +3706,7 @@ static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	if (scmd_id(scsicmd) >= dev->maximum_num_physicals ||
 			scsicmd->device->lun > 7) {
-		scsicmd->result = DID_NO_CONNECT << 16;
+		scsicmd->status.combined = DID_NO_CONNECT << 16;
 		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
@@ -3747,7 +3747,7 @@ static int aac_send_hba_fib(struct scsi_cmnd *scsicmd)
 	dev = shost_priv(scsicmd->device->host);
 	if (scmd_id(scsicmd) >= dev->maximum_num_physicals ||
 			scsicmd->device->lun > AAC_MAX_LUN - 1) {
-		scsicmd->result = DID_NO_CONNECT << 16;
+		scsicmd->status.combined = DID_NO_CONNECT << 16;
 		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
