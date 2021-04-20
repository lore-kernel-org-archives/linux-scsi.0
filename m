Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B5DBC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40471613AF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhDTAKl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:41 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:38489 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbhDTAK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:28 -0400
Received: by mail-pg1-f178.google.com with SMTP id w10so25406266pgh.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TM+iXhxL14t5uiWy9auF6Ze+byFtf7C2C0qNcG32M4s=;
        b=k7guPLOdcsXpO0vTGShYESzvKIg/oUnmDy1c0LkKfkwTSYOevvxyxXVRHYEdpMdEdp
         jMyu9SzONRY+dcx/slupHlZs+z87mamUoR6AbNVzhRhJFrWVJex1vYowElCIatzjWu0p
         OhALPJaQzSrEuKWqt/+on4DfjxjVFB37KnDCLVLf65d9BZc0ZJQ/DevgR8KMLcBDny8r
         5O3pyPC/4QoRk8yU8DnUKVt8nRKfLyaN6rLci7ssNzb6bZZDuosdaEqTLTtev4bT73lo
         3DMZOChC8xiqNmj9TdU5DENqprLEvVT0fx1dloAz2wZD49uTJgeWln/R4jxeZRiLWobd
         vY8w==
X-Gm-Message-State: AOAM531rVKX6RDt98tRSSLsn6tY9UlHc7HtNC4fXDZ1UBQozKnevyliQ
        9nci+WflfN1gjs91jbgSVLm/w+DWLl7oHA==
X-Google-Smtp-Source: ABdhPJy8pImsF/Bcj/G71Tb/oo2Xmlki9Xbqt9vRDr/F11Nlp271MdnLy69jWX4jP7L3PgC0HlJnhg==
X-Received: by 2002:a63:e903:: with SMTP id i3mr14164636pgh.374.1618877397807;
        Mon, 19 Apr 2021 17:09:57 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 057/117] ide: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:45 -0700
Message-Id: <20210420000845.25873-58-bvanassche@acm.org>
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

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ide/ide-atapi.c    | 10 +++++-----
 drivers/ide/ide-cd.c       | 20 ++++++++++----------
 drivers/ide/ide-cd_ioctl.c |  2 +-
 drivers/ide/ide-devsets.c  |  4 ++--
 drivers/ide/ide-dma.c      |  2 +-
 drivers/ide/ide-eh.c       | 36 ++++++++++++++++++------------------
 drivers/ide/ide-floppy.c   | 10 +++++-----
 drivers/ide/ide-io.c       | 10 +++++-----
 drivers/ide/ide-ioctls.c   |  4 ++--
 drivers/ide/ide-park.c     |  2 +-
 drivers/ide/ide-pm.c       |  6 +++---
 drivers/ide/ide-tape.c     |  4 ++--
 drivers/ide/ide-taskfile.c |  6 +++---
 13 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index a1ce9f5ac3aa..92805a68a02e 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -108,7 +108,7 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	if (drive->media == ide_tape)
 		scsi_req(rq)->cmd[13] = REQ_IDETAPE_PC1;
 	blk_execute_rq(disk, rq, 0);
-	error = scsi_req(rq)->result ? -EIO : 0;
+	error = scsi_req(rq)->status.combined ? -EIO : 0;
 put_req:
 	blk_put_request(rq);
 	return error;
@@ -471,7 +471,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			debug_log("%s: I/O error\n", drive->name);
 
 			if (drive->media != ide_tape)
-				scsi_req(pc->rq)->result++;
+				scsi_req(pc->rq)->status.combined++;
 
 			if (scsi_req(rq)->cmd[0] == REQUEST_SENSE) {
 				printk(KERN_ERR PFX "%s: I/O error in request "
@@ -505,13 +505,13 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			drive->failed_pc = NULL;
 
 		if (ata_misc_request(rq)) {
-			scsi_req(rq)->result = 0;
+			scsi_req(rq)->status.combined = 0;
 			error = BLK_STS_OK;
 		} else {
 
 			if (blk_rq_is_passthrough(rq) && uptodate <= 0) {
-				if (scsi_req(rq)->result == 0)
-					scsi_req(rq)->result = -EIO;
+				if (scsi_req(rq)->status.combined == 0)
+					scsi_req(rq)->status.combined = -EIO;
 			}
 
 			error = uptodate ? BLK_STS_OK : BLK_STS_IOERR;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index cffbcc27a34c..4a3e7ab6d6f7 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -248,10 +248,10 @@ static int ide_cd_breathe(ide_drive_t *drive, struct request *rq)
 
 	struct cdrom_info *info = drive->driver_data;
 
-	if (!scsi_req(rq)->result)
+	if (!scsi_req(rq)->status.combined)
 		info->write_timeout = jiffies +	ATAPI_WAIT_WRITE_BUSY;
 
-	scsi_req(rq)->result = 1;
+	scsi_req(rq)->status.combined = 1;
 
 	if (time_after(jiffies, info->write_timeout))
 		return 0;
@@ -306,8 +306,8 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 	}
 
 	/* if we have an error, pass CHECK_CONDITION as the SCSI status byte */
-	if (blk_rq_is_scsi(rq) && !scsi_req(rq)->result)
-		scsi_req(rq)->result = SAM_STAT_CHECK_CONDITION;
+	if (blk_rq_is_scsi(rq) && !scsi_req(rq)->status.combined)
+		scsi_req(rq)->status.combined = SAM_STAT_CHECK_CONDITION;
 
 	if (blk_noretry_request(rq))
 		do_end_request = 1;
@@ -337,7 +337,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 * Arrange to retry the request but be sure to give up if we've
 		 * retried too many times.
 		 */
-		if (++scsi_req(rq)->result > ERROR_MAX)
+		if (++scsi_req(rq)->status.combined > ERROR_MAX)
 			do_end_request = 1;
 		break;
 	case ILLEGAL_REQUEST:
@@ -384,7 +384,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
 			return 1;
-		} else if (++scsi_req(rq)->result > ERROR_MAX)
+		} else if (++scsi_req(rq)->status.combined > ERROR_MAX)
 			/* we've racked up too many retries, abort */
 			do_end_request = 1;
 	}
@@ -468,7 +468,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 		}
 
 		blk_execute_rq(info->disk, rq, 0);
-		error = scsi_req(rq)->result ? -EIO : 0;
+		error = scsi_req(rq)->status.combined ? -EIO : 0;
 
 		if (buffer)
 			*bufflen = scsi_req(rq)->resid_len;
@@ -585,7 +585,7 @@ static bool ide_cdrom_prep_pc(struct request *rq)
 	 * appropriate action
 	 */
 	if (c[0] == MODE_SENSE || c[0] == MODE_SELECT) {
-		scsi_req(rq)->result = ILLEGAL_REQUEST;
+		scsi_req(rq)->status.combined = ILLEGAL_REQUEST;
 		return false;
 	}
 
@@ -773,8 +773,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			if (cmd->nleft == 0)
 				uptodate = 1;
 		} else {
-			if (uptodate <= 0 && scsi_req(rq)->result == 0)
-				scsi_req(rq)->result = -EIO;
+			if (uptodate <= 0 && scsi_req(rq)->status.combined == 0)
+				scsi_req(rq)->status.combined = -EIO;
 		}
 
 		if (uptodate == 0 && rq->bio)
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 011eab9c69b7..3dd1956df9b8 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -300,7 +300,7 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->rq_flags = RQF_QUIET;
 	blk_execute_rq(cd->disk, rq, 0);
-	ret = scsi_req(rq)->result ? -EIO : 0;
+	ret = scsi_req(rq)->status.combined ? -EIO : 0;
 	blk_put_request(rq);
 	/*
 	 * A reset will unlock the door. If it was previously locked,
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index ca1d4b3d3878..c56563a1e84d 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -174,7 +174,7 @@ int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
 	ide_req(rq)->special = setting->set;
 
 	blk_execute_rq(NULL, rq, 0);
-	ret = scsi_req(rq)->result;
+	ret = scsi_req(rq)->status.combined;
 	blk_put_request(rq);
 
 	return ret;
@@ -186,7 +186,7 @@ ide_startstop_t ide_do_devset(ide_drive_t *drive, struct request *rq)
 
 	err = setfunc(drive, *(int *)&scsi_req(rq)->cmd[1]);
 	if (err)
-		scsi_req(rq)->result = err;
+		scsi_req(rq)->status.combined = err;
 	ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 	return ide_stopped;
 }
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 6f344654ef22..344a4613f653 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -488,7 +488,7 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 	 * make sure request is sane
 	 */
 	if (hwif->rq)
-		scsi_req(hwif->rq)->result = 0;
+		scsi_req(hwif->rq)->status.combined = 0;
 	return ret;
 }
 
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 2f378213e9b5..0aef620c22cf 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -13,7 +13,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
 	if ((stat & ATA_BUSY) ||
 	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
 		/* other bits are useless when BUSY */
-		scsi_req(rq)->result |= ERROR_RESET;
+		scsi_req(rq)->status.combined |= ERROR_RESET;
 	} else if (stat & ATA_ERR) {
 		/* err has different meaning on cdrom and tape */
 		if (err == ATA_ABORTED) {
@@ -26,10 +26,10 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
 			drive->crc_count++;
 		} else if (err & (ATA_BBK | ATA_UNC)) {
 			/* retries won't help these */
-			scsi_req(rq)->result = ERROR_MAX;
+			scsi_req(rq)->status.combined = ERROR_MAX;
 		} else if (err & ATA_TRK0NF) {
 			/* help it find track zero */
-			scsi_req(rq)->result |= ERROR_RECAL;
+			scsi_req(rq)->status.combined |= ERROR_RECAL;
 		}
 	}
 
@@ -40,23 +40,23 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
 		ide_pad_transfer(drive, READ, nsect * SECTOR_SIZE);
 	}
 
-	if (scsi_req(rq)->result >= ERROR_MAX || blk_noretry_request(rq)) {
+	if (scsi_req(rq)->status.combined >= ERROR_MAX || blk_noretry_request(rq)) {
 		ide_kill_rq(drive, rq);
 		return ide_stopped;
 	}
 
 	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
-		scsi_req(rq)->result |= ERROR_RESET;
+		scsi_req(rq)->status.combined |= ERROR_RESET;
 
-	if ((scsi_req(rq)->result & ERROR_RESET) == ERROR_RESET) {
-		++scsi_req(rq)->result;
+	if ((scsi_req(rq)->status.combined & ERROR_RESET) == ERROR_RESET) {
+		++scsi_req(rq)->status.combined;
 		return ide_do_reset(drive);
 	}
 
-	if ((scsi_req(rq)->result & ERROR_RECAL) == ERROR_RECAL)
+	if ((scsi_req(rq)->status.combined & ERROR_RECAL) == ERROR_RECAL)
 		drive->special_flags |= IDE_SFLAG_RECALIBRATE;
 
-	++scsi_req(rq)->result;
+	++scsi_req(rq)->status.combined;
 
 	return ide_stopped;
 }
@@ -69,7 +69,7 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq,
 	if ((stat & ATA_BUSY) ||
 	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
 		/* other bits are useless when BUSY */
-		scsi_req(rq)->result |= ERROR_RESET;
+		scsi_req(rq)->status.combined |= ERROR_RESET;
 	} else {
 		/* add decoding error stuff */
 	}
@@ -78,14 +78,14 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq,
 		/* force an abort */
 		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
 
-	if (scsi_req(rq)->result >= ERROR_MAX) {
+	if (scsi_req(rq)->status.combined >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
 	} else {
-		if ((scsi_req(rq)->result & ERROR_RESET) == ERROR_RESET) {
-			++scsi_req(rq)->result;
+		if ((scsi_req(rq)->status.combined & ERROR_RESET) == ERROR_RESET) {
+			++scsi_req(rq)->status.combined;
 			return ide_do_reset(drive);
 		}
-		++scsi_req(rq)->result;
+		++scsi_req(rq)->status.combined;
 	}
 
 	return ide_stopped;
@@ -131,11 +131,11 @@ ide_startstop_t ide_error(ide_drive_t *drive, const char *msg, u8 stat)
 			if (cmd)
 				ide_complete_cmd(drive, cmd, stat, err);
 		} else if (ata_pm_request(rq)) {
-			scsi_req(rq)->result = 1;
+			scsi_req(rq)->status.combined = 1;
 			ide_complete_pm_rq(drive, rq);
 			return ide_stopped;
 		}
-		scsi_req(rq)->result = err;
+		scsi_req(rq)->status.combined = err;
 		ide_complete_rq(drive, err ? BLK_STS_IOERR : BLK_STS_OK, blk_rq_bytes(rq));
 		return ide_stopped;
 	}
@@ -150,8 +150,8 @@ static inline void ide_complete_drive_reset(ide_drive_t *drive, blk_status_t err
 
 	if (rq && ata_misc_request(rq) &&
 	    scsi_req(rq)->cmd[0] == REQ_DRIVE_RESET) {
-		if (err <= 0 && scsi_req(rq)->result == 0)
-			scsi_req(rq)->result = -EIO;
+		if (err <= 0 && scsi_req(rq)->status.combined == 0)
+			scsi_req(rq)->status.combined = -EIO;
 		ide_complete_rq(drive, err, blk_rq_bytes(rq));
 	}
 }
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index f5a2870aaf54..bad2eb12daa8 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -100,7 +100,7 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 	}
 
 	if (ata_misc_request(rq))
-		scsi_req(rq)->result = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
+		scsi_req(rq)->status.combined = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
 
 	return uptodate;
 }
@@ -241,7 +241,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 					? rq->rq_disk->disk_name
 					: "dev?"));
 
-	if (scsi_req(rq)->result >= ERROR_MAX) {
+	if (scsi_req(rq)->status.combined >= ERROR_MAX) {
 		if (drive->failed_pc) {
 			ide_floppy_report_error(floppy, drive->failed_pc);
 			drive->failed_pc = NULL;
@@ -249,7 +249,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
 
 		if (ata_misc_request(rq)) {
-			scsi_req(rq)->result = 0;
+			scsi_req(rq)->status.combined = 0;
 			ide_complete_rq(drive, BLK_STS_OK, blk_rq_bytes(rq));
 			return ide_stopped;
 		} else
@@ -303,8 +303,8 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 	return ide_floppy_issue_pc(drive, &cmd, pc);
 out_end:
 	drive->failed_pc = NULL;
-	if (blk_rq_is_passthrough(rq) && scsi_req(rq)->result == 0)
-		scsi_req(rq)->result = -EIO;
+	if (blk_rq_is_passthrough(rq) && scsi_req(rq)->status.combined == 0)
+		scsi_req(rq)->status.combined = -EIO;
 	ide_complete_rq(drive, BLK_STS_IOERR, blk_rq_bytes(rq));
 	return ide_stopped;
 }
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 4867b67b60d6..bda2093aed1c 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -151,12 +151,12 @@ void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 	drive->failed_pc = NULL;
 
 	if ((media == ide_floppy || media == ide_tape) && drv_req) {
-		scsi_req(rq)->result = 0;
+		scsi_req(rq)->status.combined = 0;
 	} else {
 		if (media == ide_tape)
-			scsi_req(rq)->result = IDE_DRV_ERROR_GENERAL;
-		else if (blk_rq_is_passthrough(rq) && scsi_req(rq)->result == 0)
-			scsi_req(rq)->result = -EIO;
+			scsi_req(rq)->status.combined = IDE_DRV_ERROR_GENERAL;
+		else if (blk_rq_is_passthrough(rq) && scsi_req(rq)->status.combined == 0)
+			scsi_req(rq)->status.combined = -EIO;
 	}
 
 	ide_complete_rq(drive, BLK_STS_IOERR, blk_rq_bytes(rq));
@@ -284,7 +284,7 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
-	scsi_req(rq)->result = 0;
+	scsi_req(rq)->status.combined = 0;
 	ide_complete_rq(drive, BLK_STS_OK, blk_rq_bytes(rq));
 
  	return ide_stopped;
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 43fbc37d85c3..11999ebd5637 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -138,7 +138,7 @@ static int ide_cmd_ioctl(ide_drive_t *drive, void __user *argp)
 		rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, 0);
 		ide_req(rq)->type = ATA_PRIV_TASKFILE;
 		blk_execute_rq(NULL, rq, 0);
-		err = scsi_req(rq)->result ? -EIO : 0;
+		err = scsi_req(rq)->status.combined ? -EIO : 0;
 		blk_put_request(rq);
 
 		return err;
@@ -236,7 +236,7 @@ static int generic_drive_reset(ide_drive_t *drive)
 	scsi_req(rq)->cmd_len = 1;
 	scsi_req(rq)->cmd[0] = REQ_DRIVE_RESET;
 	blk_execute_rq(NULL, rq, 1);
-	ret = scsi_req(rq)->result;
+	ret = scsi_req(rq)->status.combined;
 	blk_put_request(rq);
 	return ret;
 }
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index a80a0f28f7b9..dd891bd3fe1b 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -38,7 +38,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	ide_req(rq)->special = &timeout;
 	blk_execute_rq(NULL, rq, 1);
-	rc = scsi_req(rq)->result ? -EIO : 0;
+	rc = scsi_req(rq)->status.combined ? -EIO : 0;
 	blk_put_request(rq);
 	if (rc)
 		goto out;
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index d680b3e3295f..8058dbc1e03b 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -28,7 +28,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	rqpm.pm_state = mesg.event;
 
 	blk_execute_rq(NULL, rq, 0);
-	ret = scsi_req(rq)->result ? -EIO : 0;
+	ret = scsi_req(rq)->status.combined ? -EIO : 0;
 	blk_put_request(rq);
 
 	if (ret == 0 && ide_port_acpi(hwif)) {
@@ -46,13 +46,13 @@ static int ide_pm_execute_rq(struct request *rq)
 
 	if (unlikely(blk_queue_dying(q))) {
 		rq->rq_flags |= RQF_QUIET;
-		scsi_req(rq)->result = -ENXIO;
+		scsi_req(rq)->status.combined = -ENXIO;
 		blk_mq_end_request(rq, BLK_STS_OK);
 		return -ENXIO;
 	}
 	blk_execute_rq(NULL, rq, true);
 
-	return scsi_req(rq)->result ? -EIO : 0;
+	return scsi_req(rq)->status.combined ? -EIO : 0;
 }
 
 int generic_ide_resume(struct device *dev)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index fa05e7e7d609..d04b10c32dfa 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -367,7 +367,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 			err = pc->error;
 		}
 	}
-	scsi_req(rq)->result = err;
+	scsi_req(rq)->status.combined = err;
 
 	return uptodate;
 }
@@ -879,7 +879,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 		tape->valid = 0;
 
 	ret = size;
-	if (scsi_req(rq)->result == IDE_DRV_ERROR_GENERAL)
+	if (scsi_req(rq)->status.combined == IDE_DRV_ERROR_GENERAL)
 		ret = -EIO;
 out_put:
 	blk_put_request(rq);
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 6665fc4724b9..a542201b81a9 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -279,7 +279,7 @@ static void ide_pio_datablock(ide_drive_t *drive, struct ide_cmd *cmd,
 	u8 saved_io_32bit = drive->io_32bit;
 
 	if (cmd->tf_flags & IDE_TFLAG_FS)
-		scsi_req(cmd->rq)->result = 0;
+		scsi_req(cmd->rq)->status.combined = 0;
 
 	if (cmd->tf_flags & IDE_TFLAG_IO_16BIT)
 		drive->io_32bit = 0;
@@ -321,7 +321,7 @@ void ide_finish_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat)
 	u8 set_xfer = !!(cmd->tf_flags & IDE_TFLAG_SET_XFER);
 
 	ide_complete_cmd(drive, cmd, stat, err);
-	scsi_req(rq)->result = err;
+	scsi_req(rq)->status.combined = err;
 
 	if (err == 0 && set_xfer) {
 		ide_set_xfer_rate(drive, nsect);
@@ -444,7 +444,7 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 	cmd->rq = rq;
 
 	blk_execute_rq(NULL, rq, 0);
-	error = scsi_req(rq)->result ? -EIO : 0;
+	error = scsi_req(rq)->status.combined ? -EIO : 0;
 put_req:
 	blk_put_request(rq);
 	return error;
