Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8F1CD37B0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjIRQ6A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjIRQ5v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:57:51 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BEEBA;
        Mon, 18 Sep 2023 09:57:44 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-274928c74b0so2798528a91.3;
        Mon, 18 Sep 2023 09:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056264; x=1695661064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4iQ+x1FmLwZ9O/N7KU4Z9ms7MTG+wzcJZbbINtMFCM=;
        b=mKdLmJURJHhgq1qHmkjJnQQTGAi9UzvSWFRGXNnE7hqHUto0lktqsxGBRChy93tsPK
         pSpJpD+kCsNR4sJ7EyLtgQCL5hPd43YRDSO2g3JNm3G/y+gD217UvkDrV7Qbo/Tc4ZAi
         3X190MAJxnhyL89gvp3YZfgiARd5KZgwsqBqNnoYN2eFqU3a2rgEsh77WjWRgFpDj+pY
         dZb7chIwdnN53O/EMxUGfyXcZSAuYnbMHSnE8i1D22uG7e8shFrOPCrugR7qjjtqtjHR
         TEx0G1uJchiWmBC3BqF2eUvlj/dZEDbmHk3NxNKAE/WGaNJuo0Gd/A++yHRVr7GnImpu
         VpdA==
X-Gm-Message-State: AOJu0Yzhc162ebeR0IuN8JFKYvk7c+MBh9l6m/1TBqj7EeCysrm96rWm
        6I1EdZQbhMGQU9ufwD31GQM=
X-Google-Smtp-Source: AGHT+IEUdE3EvKF28q7wizIFY/7wxBeoFPNTuvt2x+gdkiL3b/VPmu6z2kSQP6adlFiErU0QLZ4ayw==
X-Received: by 2002:a17:90a:5901:b0:268:b7a2:62e8 with SMTP id k1-20020a17090a590100b00268b7a262e8mr9039559pji.7.1695056264082;
        Mon, 18 Sep 2023 09:57:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b005740aa41237sm5658041pgd.74.2023.09.18.09.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:57:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v12 07/16] scsi: core: Retry unaligned zoned writes
Date:   Mon, 18 Sep 2023 09:55:46 -0700
Message-ID: <20230918165713.1598705-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918165713.1598705-1-bvanassche@acm.org>
References: <20230918165713.1598705-1-bvanassche@acm.org>
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
index 1f932f2cdfd9..3af9e8cef015 100644
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
index 6f26d6d6f50b..6e4bfeb9c7ee 100644
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
