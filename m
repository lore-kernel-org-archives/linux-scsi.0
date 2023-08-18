Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D07EE498F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354999AbjHRTqJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379728AbjHRTpi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:45:38 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FE3E4C;
        Fri, 18 Aug 2023 12:45:23 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1bdbf10333bso10689175ad.1;
        Fri, 18 Aug 2023 12:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387804; x=1692992604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0xCoxo/qg7/ntVVvz5KKadmaE1D/02ErCrJvy85BN4=;
        b=lUYeYs8I8X6zj2czPl45N0pQVDbXtt+i/DUiaSV08x+0/deprfHrvIOkpTSAlZVnHb
         Uc+vKuJLONo4PL3bbO5eQdQiKF6leRH4SN7zrs9mJT96cD75RULTXrx9FARv3EqbLkCe
         D+p+7qMXWuqp8/K1ZEcmK/w7DxW8if0EHNrKfSU8sR2Jrjc6MCSZ7Z+zBN9ohmdZ9baV
         Ej6WJejlEjwpTQmpFV9xAdXWzG5eCw7VHKVm9rHaGG9/oI+pj7CgJXtyOXlYv/NPm1DB
         PsQw64DvXLgMjWt6HNxAgUJ64MBF8bDOLSKHYlvyg0DgSZ4maV+ZTlk4RVRLVZG1ycWP
         0n6A==
X-Gm-Message-State: AOJu0YzwMsU0SI6wQfVYI3QJ+6j2mO7/O38Tf497V2vEHHRaRIEzTb8R
        R0M2wO0W0LHEI+1QhCOGQdo=
X-Google-Smtp-Source: AGHT+IFXWe77mlu7Q8bfL6K8M3GpduaICUrEk4gamEhEiTwo7H0n3/pNlWlQ4gM/vCgydxGQngznNA==
X-Received: by 2002:a17:902:c404:b0:1b5:64a4:be8b with SMTP id k4-20020a170902c40400b001b564a4be8bmr237400plk.35.1692387804515;
        Fri, 18 Aug 2023 12:43:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:43:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 07/18] scsi: core: Retry unaligned zoned writes
Date:   Fri, 18 Aug 2023 12:34:10 -0700
Message-ID: <20230818193546.2014874-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
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
index c4d817f044a0..e393d78b921b 100644
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
+		    blk_rq_is_seq_zoned_write(req)) {
+			SCSI_LOG_ERROR_RECOVERY(3,
+				sdev_printk(KERN_INFO, scmd->device,
+					    "Retrying unaligned write at LBA %#llx.\n",
+					    scsi_get_lba(scmd)));
+			return NEEDS_DELAYED_RETRY;
+		}
+
 		if (sshdr.asc == 0x20 || /* Invalid command operation code */
 		    sshdr.asc == 0x21 || /* Logical block address out of range */
 		    sshdr.asc == 0x22 || /* Invalid function */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 59176946ab56..69da8aee13df 100644
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
index d4feac5de17a..e96014caa34c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1240,6 +1240,12 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
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
