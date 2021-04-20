Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457E9C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 271D3613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbhDTAKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:16 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:44604 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbhDTAKC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:02 -0400
Received: by mail-pf1-f173.google.com with SMTP id m11so24314361pfc.11
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RYjg19RCuf2V1Qv02HEt5M9WAuktmH6ApCN6rJVgyoo=;
        b=AWsfUIchPZVzV/xVH2T2wi65sQKkaAQ70hHkqN5sro7uGFQnOsy8gEBENuGtCSAHse
         rFITBSW/VqDYgk35Omc+mRh2Rkw27t2e01lzWYg9qZduA5mfmric2DTMxnf5O7nZZvjG
         p0uGY12XXwYByThxsUpXwhjnKL9jyM3iYKatnr8btccClqxlAm1na1kWvIDXR9OiEO5u
         QBtTJ2J+J2o6sl4leVN5eeyF1gcDb2lp3mCpAwvaVEjUtq3+vnR44cTwO4nMUYjvjns2
         FqJ5FC7K4ahZWb3IShyeGNZGNfGG46AI4o50jCMWCmKEeHn6JjjusdjNkXWVwQWFjfwr
         CEFw==
X-Gm-Message-State: AOAM530ttAsSoyXhAFzAuy67plrHv74jFj2icV26+FM0aLspOQ5shA3v
        gBKEW40ekESnmlMORgYNxcA=
X-Google-Smtp-Source: ABdhPJzyRcT19+BF+eNQHmS2MaIJhJdViwMaWDS0rrCsXJESTT+D8nA2DchFKBKbJRzr0NdusLUmow==
X-Received: by 2002:a65:4202:: with SMTP id c2mr14196849pgq.282.1618877368108;
        Mon, 19 Apr 2021 17:09:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 031/117] ata: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:19 -0700
Message-Id: <20210420000845.25873-32-bvanassche@acm.org>
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

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-sata.c |  2 +-
 drivers/ata/libata-scsi.c | 64 +++++++++++++++++++++------------------
 2 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 8adeab76dd38..e0296424ff0a 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1245,7 +1245,7 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap)
 	if (likely(ata_dev_enabled(ap->link.device)))
 		rc = __ata_scsi_queuecmd(cmd, ap->link.device);
 	else {
-		cmd->result = (DID_BAD_TARGET << 16);
+		cmd->status = (union scsi_status){ .b.host = DID_BAD_TARGET };
 		cmd->scsi_done(cmd);
 	}
 	return rc;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 48b8934970f3..5ba4b3152c99 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -196,7 +196,8 @@ void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
 	if (!cmd)
 		return;
 
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+	cmd->status = (union scsi_status){ .b.driver = DRIVER_SENSE,
+		.b.status = SAM_STAT_CHECK_CONDITION };
 
 	scsi_build_sense_buffer(d_sense, cmd->sense_buffer, sk, asc, ascq);
 }
@@ -362,7 +363,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	int argsize = 0;
 	enum dma_data_direction data_dir;
 	struct scsi_sense_hdr sshdr;
-	int cmd_result;
+	union scsi_status cmd_result;
 
 	if (arg == NULL)
 		return -EINVAL;
@@ -406,19 +407,19 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
+	cmd_result.combined = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
 				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
 		u8 *desc = sensebuf + 8;
-		cmd_result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
+		cmd_result.combined &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
 
 		/* If we set cc then ATA pass-through will cause a
 		 * check condition even if no error. Filter that. */
-		if (cmd_result & SAM_STAT_CHECK_CONDITION) {
+		if (cmd_result.combined & SAM_STAT_CHECK_CONDITION) {
 			if (sshdr.sense_key == RECOVERED_ERROR &&
 			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
-				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
+				cmd_result.combined &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
 		/* Send userspace a few ATA registers (same as drivers/ide) */
@@ -433,7 +434,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	}
 
 
-	if (cmd_result) {
+	if (cmd_result.combined) {
 		rc = -EIO;
 		goto error;
 	}
@@ -464,7 +465,7 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	u8 args[7];
 	struct scsi_sense_hdr sshdr;
-	int cmd_result;
+	union scsi_status cmd_result;
 
 	if (arg == NULL)
 		return -EINVAL;
@@ -487,19 +488,19 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
+	cmd_result.combined = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
 				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
 		u8 *desc = sensebuf + 8;
-		cmd_result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
+		cmd_result.combined &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
 
 		/* If we set cc then ATA pass-through will cause a
 		 * check condition even if no error. Filter that. */
-		if (cmd_result & SAM_STAT_CHECK_CONDITION) {
+		if (cmd_result.combined & SAM_STAT_CHECK_CONDITION) {
 			if (sshdr.sense_key == RECOVERED_ERROR &&
 			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
-				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
+				cmd_result.combined &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
 		/* Send userspace ATA registers */
@@ -517,7 +518,7 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 		}
 	}
 
-	if (cmd_result) {
+	if (cmd_result.combined) {
 		rc = -EIO;
 		goto error;
 	}
@@ -638,7 +639,8 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 		if (cmd->request->rq_flags & RQF_QUIET)
 			qc->flags |= ATA_QCFLAG_QUIET;
 	} else {
-		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
+		cmd->status = (union scsi_status){ .b.host = DID_OK,
+			.b.status = QUEUE_FULL << 1 };
 		cmd->scsi_done(cmd);
 	}
 
@@ -858,7 +860,8 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 
 	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
 
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+	cmd->status = (union scsi_status){ .b.driver = DRIVER_SENSE,
+		.b.status = SAM_STAT_CHECK_CONDITION };
 
 	/*
 	 * Use ata_to_sense_error() to map status register bits
@@ -957,7 +960,8 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 
 	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
 
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+	cmd->status = (union scsi_status){ .b.driver = DRIVER_SENSE,
+		.b.status = SAM_STAT_CHECK_CONDITION };
 
 	if (ata_dev_disabled(dev)) {
 		/* Device disabled after error recovery */
@@ -1241,7 +1245,7 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 	ata_scsi_set_invalid_field(qc->dev, scmd, fp, bp);
 	return 1;
  skip:
-	scmd->result = SAM_STAT_GOOD;
+	scmd->status.combined = 0;
 	return 1;
 }
 
@@ -1492,7 +1496,7 @@ static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc)
 	return 1;
 
 nothing_to_do:
-	scmd->result = SAM_STAT_GOOD;
+	scmd->status.combined = 0;
 	return 1;
 }
 
@@ -1625,7 +1629,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	return 1;
 
 nothing_to_do:
-	scmd->result = SAM_STAT_GOOD;
+	scmd->status.combined = 0;
 	return 1;
 }
 
@@ -1658,11 +1662,11 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	    ((cdb[2] & 0x20) || need_sense))
 		ata_gen_passthru_sense(qc);
 	else if (qc->flags & ATA_QCFLAG_SENSE_VALID)
-		cmd->result = SAM_STAT_CHECK_CONDITION;
+		cmd->status = (union scsi_status){ .b.status = SAM_STAT_CHECK_CONDITION };
 	else if (need_sense)
 		ata_gen_ata_sense(qc);
 	else
-		cmd->result = SAM_STAT_GOOD;
+		cmd->status.combined = 0;
 
 	if (need_sense && !ap->ops->error_handler)
 		ata_dump_status(ap->print_id, &qc->result_tf);
@@ -1746,7 +1750,7 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 err_did:
 	ata_qc_free(qc);
-	cmd->result = (DID_ERROR << 16);
+	cmd->status = (union scsi_status){ .b.host = DID_ERROR };
 	cmd->scsi_done(cmd);
 err_mem:
 	DPRINTK("EXIT - internal\n");
@@ -1842,7 +1846,7 @@ static void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
 	ata_scsi_rbuf_put(cmd, rc == 0, &flags);
 
 	if (rc == 0)
-		cmd->result = SAM_STAT_GOOD;
+		cmd->status.combined = 0;
 }
 
 /**
@@ -2623,14 +2627,14 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
 			qc->dev->sdev->locked = 0;
 
-		qc->scsicmd->result = SAM_STAT_CHECK_CONDITION;
+		qc->scsicmd->status = (union scsi_status){ .b.status = SAM_STAT_CHECK_CONDITION };
 		ata_qc_done(qc);
 		return;
 	}
 
 	/* successful completion or old EH failure path */
 	if (unlikely(err_mask & AC_ERR_DEV)) {
-		cmd->result = SAM_STAT_CHECK_CONDITION;
+		cmd->status = (union scsi_status){ .b.status = SAM_STAT_CHECK_CONDITION };
 		atapi_request_sense(qc);
 		return;
 	} else if (unlikely(err_mask)) {
@@ -2643,7 +2647,7 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 	} else {
 		if (cmd->cmnd[0] == INQUIRY && (cmd->cmnd[1] & 0x03) == 0)
 			atapi_fixup_inquiry(cmd);
-		cmd->result = SAM_STAT_GOOD;
+		cmd->status.combined = 0;
 	}
 
 	ata_qc_done(qc);
@@ -3833,7 +3837,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	return 1;
 
  skip:
-	scmd->result = SAM_STAT_GOOD;
+	scmd->status.combined = 0;
 	return 1;
 }
 
@@ -4061,7 +4065,7 @@ int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
  bad_cdb_len:
 	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
 		scmd->cmd_len, scsi_op, dev->cdb_len);
-	scmd->result = DID_ERROR << 16;
+	scmd->status = (union scsi_status){ .b.host = DID_ERROR };
 	scmd->scsi_done(scmd);
 	return 0;
 }
@@ -4103,7 +4107,7 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	if (likely(dev))
 		rc = __ata_scsi_queuecmd(cmd, dev);
 	else {
-		cmd->result = (DID_BAD_TARGET << 16);
+		cmd->status = (union scsi_status){ .b.host = DID_BAD_TARGET };
 		cmd->scsi_done(cmd);
 	}
 
@@ -4197,7 +4201,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 
 	case REQUEST_SENSE:
 		ata_scsi_set_sense(dev, cmd, 0, 0, 0);
-		cmd->result = (DRIVER_SENSE << 24);
+		cmd->status = (union scsi_status){ .b.driver = DRIVER_SENSE };
 		break;
 
 	/* if we reach this, then writeback caching is disabled,
