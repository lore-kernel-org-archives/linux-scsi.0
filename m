Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44455C04A94
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 15:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjHDPsi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 11:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbjHDPsd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 11:48:33 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88B33C3D;
        Fri,  4 Aug 2023 08:48:32 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-686b9920362so1645769b3a.1;
        Fri, 04 Aug 2023 08:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691164112; x=1691768912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cKob5yfr1F98047yz5yKCajSfKdMgNwlUre3zfhdDvI=;
        b=dsmzaPC10hxZpZ9FdlYg0Bt8APWvuy75WTWAPKmmR90FnN0D6XZUsOAuKdKan8739i
         bUuTcfoEtacWbyqpketFtpqbpOspEyYLvmzA1zi5bA4BiiFddU0UJ806eUhuT72b3R1r
         2LoRm4uPlk7AaITd9srR9Atr5F+1ou9WpPB6wIq9uLw4L3JAx4cTlBh8TksEjAVgIN4u
         xQ2hFwCvM/SODzz25gA91rkMDlzVm6FeodFDvzVIOg1v0wcKSRMU9T2RDN5+sJFLCqSK
         SEEH1hnqtik2U3dl7U5d3wtm9jqo0QOn868n5AW3CFM7Z0IaD8uY2ehbh21ME6+QlITw
         gUfg==
X-Gm-Message-State: AOJu0YxmRcjpEWU94iY7W3PrvrGUOMCIfTjoS6yTPUEUDM/EKYmfsuZG
        HJNnCmPHufpFtcm5o5SlKOw=
X-Google-Smtp-Source: AGHT+IGQ0ab0MoOn9aYfyCv0wQWxOPLxuimGkKvj/KED8sVDVmqsDV/1eIpJJdB9gTs6HguTD38SCg==
X-Received: by 2002:a05:6a00:1903:b0:682:7d8a:f887 with SMTP id y3-20020a056a00190300b006827d8af887mr2066625pfi.30.1691164112074;
        Fri, 04 Aug 2023 08:48:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4af5:d063:a66d:403b])
        by smtp.gmail.com with ESMTPSA id h8-20020a62b408000000b00640ddad2e0dsm1760839pfn.47.2023.08.04.08.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 08:48:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v6 3/7] scsi: core: Retry unaligned zoned writes
Date:   Fri,  4 Aug 2023 08:48:01 -0700
Message-ID: <20230804154821.3232094-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230804154821.3232094-1-bvanassche@acm.org>
References: <20230804154821.3232094-1-bvanassche@acm.org>
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
disabled. Let the SCSI error handler sort SCSI commands per LBA before
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
 drivers/scsi/scsi_error.c | 37 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 drivers/scsi/sd.c         |  3 +++
 include/scsi/scsi.h       |  1 +
 4 files changed, 42 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c67cdcdc3ba8..766a576b9be6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/list_sort.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -698,6 +699,16 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		fallthrough;
 
 	case ILLEGAL_REQUEST:
+		/*
+		 * Unaligned write command. This may indicate that zoned writes
+		 * have been received by the device in the wrong order. If zone
+		 * write locking is disabled, retry after all pending commands
+		 * have completed.
+		 */
+		if (sshdr.asc == 0x21 && sshdr.ascq == 0x04 &&
+		    blk_queue_no_zone_write_lock(scsi_cmd_to_rq(scmd)->q))
+			return NEEDS_DELAYED_RETRY;
+
 		if (sshdr.asc == 0x20 || /* Invalid command operation code */
 		    sshdr.asc == 0x21 || /* Logical block address out of range */
 		    sshdr.asc == 0x22 || /* Invalid function */
@@ -2186,6 +2197,25 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
 
+/*
+ * Returns a negative value if @_a has a lower starting sector than @_b, zero if
+ * both have the same starting sector and a positive value otherwise.
+ */
+static int scsi_cmp_sector(void *priv, const struct list_head *_a,
+			   const struct list_head *_b)
+{
+	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
+	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
+	const sector_t pos_a = blk_rq_pos(scsi_cmd_to_rq(a));
+	const sector_t pos_b = blk_rq_pos(scsi_cmd_to_rq(b));
+
+	if (pos_a < pos_b)
+		return -1;
+	if (pos_a > pos_b)
+		return 1;
+	return 0;
+}
+
 /**
  * scsi_eh_flush_done_q - finish processed commands or retry them.
  * @done_q:	list_head of processed commands.
@@ -2194,6 +2224,13 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
 
+	/*
+	 * Sort pending SCSI commands in starting sector order. This is
+	 * important if one of the SCSI devices associated with @shost is a
+	 * zoned block device for which zone write locking is disabled.
+	 */
+	list_sort(NULL, done_q, scsi_cmp_sector);
+
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
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
index 68b12afa0721..27b9ebe05b90 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1235,6 +1235,9 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = sdp->sector_size;
 	cmd->underflow = nr_blocks << 9;
 	cmd->allowed = sdkp->max_retries;
+	if (blk_queue_no_zone_write_lock(rq->q) &&
+	    blk_rq_is_seq_zoned_write(rq))
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
