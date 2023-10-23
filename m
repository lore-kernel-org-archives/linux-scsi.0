Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723D1C25B46
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbjJWV51 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbjJWV5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:57:19 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD1F10CE;
        Mon, 23 Oct 2023 14:57:17 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-27d23f1e3b8so3269265a91.1;
        Mon, 23 Oct 2023 14:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098236; x=1698703036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cx49ComzXIk6YQdiKmeJ7XcBZ6Q2N4Tg8VArGGWadjk=;
        b=lHaoNOSKp9oVZK8p1I0Jm+WurfzItL4rGUAlx+PEcwPVv92Sr2tQQ1UXZ24JkljOiM
         rdfk1LgOqL4/1lBDnb0lbisu1V0KxvKKC+87msq50Q/+3tbnwMzeCyebNsD20PD6s0Dr
         8Vy1CB9aBkp1zuJbO1W8Kbd0MgsC42Jwis8bAfbuMgfvXEDKcG0IVAwhCQ1Q+axWrRhN
         TKfpNILIqaxkuvDfHGD1gcysj2sIo0xo6WMrglXH1a4Cam7PrmvsVTezPjJfKJseI6Ke
         neLbJoh/ACWeSFAmfVFwzedBB/LKNXZnBeZZvB2lnIvIRqnxiZZwJ1vlSPzmQL2fsXxt
         UTNA==
X-Gm-Message-State: AOJu0YyRLGAu5d42J+cyjv90R8wCBQE65dPrcQa8vimHKi3acSxD9MJW
        1OelnruYXxV2AegUT+XzIgY=
X-Google-Smtp-Source: AGHT+IE21QgfX+sNSY3NPVXYgtSgxbmaU97grVdxp/FacjI6ezhQ2aLiy+bPREGymaqAZ4R9pR0LUg==
X-Received: by 2002:a17:90a:1996:b0:27d:2054:9641 with SMTP id 22-20020a17090a199600b0027d20549641mr10300547pji.36.1698098236525;
        Mon, 23 Oct 2023 14:57:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:57:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v14 10/19] scsi: core: Retry unaligned zoned writes
Date:   Mon, 23 Oct 2023 14:54:01 -0700
Message-ID: <20231023215638.3405959-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If zoned writes (REQ_OP_WRITE) for a sequential write required zone have
a starting LBA that differs from the write pointer, e.g. because zoned
writes have been reordered, then the storage device will respond with an
UNALIGNED WRITE COMMAND error. Send commands that failed with an
unaligned write error to the SCSI error handler if zone write locking is
disabled. The SCSI error handler will sort SCSI commands per LBA before
resubmitting these.

If zone write locking is disabled, increase the number of retries for
write commands sent to a sequential zone to the maximum number of
outstanding commands because in the worst case the number of times
reordered zoned writes have to be retried is (number of outstanding
writes per sequential zone) - 1.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 16 ++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 drivers/scsi/sd.c         |  6 ++++++
 include/scsi/scsi.h       |  1 +
 4 files changed, 24 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 8b1eb637ffa8..9a54856fa03b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -699,6 +699,22 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		fallthrough;
 
 	case ILLEGAL_REQUEST:
+		/*
+		 * Unaligned write command. This may indicate that zoned writes
+		 * have been received by the device in the wrong order. If zone
+		 * write locking is disabled, retry after all pending commands
+		 * have completed.
+		 */
+		if (sshdr.asc == 0x21 && sshdr.ascq == 0x04 &&
+		    !req->q->limits.use_zone_write_lock &&
+		    blk_rq_is_seq_zoned_write(req) &&
+		    scmd->retries <= scmd->allowed) {
+			sdev_printk(KERN_INFO, scmd->device,
+				    "Retrying unaligned write at LBA %#llx.\n",
+				    scsi_get_lba(scmd));
+			return NEEDS_DELAYED_RETRY;
+		}
+
 		if (sshdr.asc == 0x20 || /* Invalid command operation code */
 		    sshdr.asc == 0x21 || /* Logical block address out of range */
 		    sshdr.asc == 0x22 || /* Invalid function */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c2f647a7c1b0..33a34693c8a2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1443,6 +1443,7 @@ static void scsi_complete(struct request *rq)
 	case ADD_TO_MLQUEUE:
 		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 		break;
+	case NEEDS_DELAYED_RETRY:
 	default:
 		scsi_eh_scmd_add(cmd);
 		break;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 82abc721b543..4e6b77f5854f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1197,6 +1197,12 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = sdp->sector_size;
 	cmd->underflow = nr_blocks << 9;
 	cmd->allowed = sdkp->max_retries;
+	/*
+	 * Increase the number of allowed retries for zoned writes if zone
+	 * write locking is disabled.
+	 */
+	if (!rq->q->limits.use_zone_write_lock && blk_rq_is_seq_zoned_write(rq))
+		cmd->allowed += rq->q->nr_requests;
 	cmd->sdb.length = nr_blocks * sdp->sector_size;
 
 	SCSI_LOG_HLQUEUE(1,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index ec093594ba53..6600db046227 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -93,6 +93,7 @@ static inline int scsi_status_is_check_condition(int status)
  * Internal return values.
  */
 enum scsi_disposition {
+	NEEDS_DELAYED_RETRY	= 0x2000,
 	NEEDS_RETRY		= 0x2001,
 	SUCCESS			= 0x2002,
 	FAILED			= 0x2003,
