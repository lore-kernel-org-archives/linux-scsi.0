Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C42EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42518610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhKSUBE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:04 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:55935 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhKSUA7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:00:59 -0500
Received: by mail-pj1-f48.google.com with SMTP id v23so8702244pjr.5
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:57:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IhHHR2qqqrkgcfwnn5h6oeh7wYJ9pG0vF4LRNmMis84=;
        b=G/vLXLIPn5KYaqrVgUArD9w5aG70Mz0MUd+RGyoha9QcdZ0p+Q8TL6awg2Z74zhOcv
         QzopFqd0xs5BtA6kIJ30626y6Txc8QYD/UsxHnpHPeM2xv0mGG847+NkyU/uf0VrnSjK
         Hl/eK9txc/E5xLJ0fP4KaGxwFEL5eC3E/ysHgbCUJhvw+MC7KyHeHMj6wBLw6VvY24eT
         cJ5Qn9sm72CBDfmyWQt7jy1UI6sf9gDNtfjWiRO2lMiBGsFrSR6SP+7vEOvm0z9bq50U
         MDPbKS+5fjhQ/jVoYUME8HZQP9vteeE0LzIQZlggwg7vMQ6PLrh6RKWawrUfHqWKC4/S
         MBWg==
X-Gm-Message-State: AOAM530ATzaCB9upCoJjH+JBA5PTOb4KJtoNBSogh04KnXpSNTIxpkfU
        UBLuXA8YrGzjY/R8v2TDV1w=
X-Google-Smtp-Source: ABdhPJzHQZxQsv94SiDfykvrpI36sd9QKSzB7YnAWg6eTO9lIcKIuF+fqCepb3I+vmm+qjXw/8jYPQ==
X-Received: by 2002:a17:90b:380e:: with SMTP id mq14mr2985928pjb.74.1637351876768;
        Fri, 19 Nov 2021 11:57:56 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:57:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 05/20] scsi: core: Add support for internal commands
Date:   Fri, 19 Nov 2021 11:57:28 -0800
Message-Id: <20211119195743.2817-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Add helper functions to allow LLDs to allocate and free internal commands.
This patch is based on Hannes' patch with the subject "scsi: add
scsi_{get,put}_internal_cmd() helper".

Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
[ bvanassche: changed type of the first argument of the new functions from
  struct scsi_device * into struct request_queue * and included changes for
  the timeout handlers in this patch. ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c  |  7 ++++++
 drivers/scsi/scsi_lib.c    | 46 +++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_device.h |  4 ++++
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cd05f2db3339..3703ee9c89dd 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -339,6 +339,13 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
 		return BLK_EH_DONE;
 
+	/*
+	 * The code below is for documentation purposes only since the
+	 * dereference above of the scmd->device pointer triggers a kernel
+	 * oops for internal commands.
+	 */
+	WARN_ON_ONCE(blk_rq_is_internal(scsi_cmd_to_rq(scmd)));
+
 	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 621d841d819a..59c3c4fbcfc0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1756,8 +1756,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 static enum blk_eh_timer_return scsi_timeout(struct request *req,
 		bool reserved)
 {
-	if (reserved)
+	if (blk_rq_is_internal(req) || WARN_ON_ONCE(reserved))
 		return BLK_EH_RESET_TIMER;
+
 	return scsi_times_out(req);
 }
 
@@ -1957,6 +1958,49 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
 	blk_mq_free_tag_set(&shost->tag_set);
 }
 
+/**
+ * scsi_get_internal_cmd - Allocate an internal SCSI command
+ * @q: request queue from which to allocate the command. This request queue may
+ *	but does not have to be associated with a SCSI device. This request
+ *	queue must be associated with a SCSI tag set. See also
+ *	scsi_mq_setup_tags().
+ * @data_direction: Data direction for the allocated command.
+ * @flags: Zero or more BLK_MQ_REQ_* flags.
+ *
+ * Allocates a request for driver-internal use. The tag of the returned SCSI
+ * command is guaranteed to be unique.
+ */
+struct scsi_cmnd *scsi_get_internal_cmd(struct request_queue *q,
+					enum dma_data_direction data_direction,
+					blk_mq_req_flags_t flags)
+{
+	unsigned int opf = REQ_INTERNAL;
+	struct request *rq;
+
+	opf |= data_direction == DMA_TO_DEVICE ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
+	rq = blk_mq_alloc_request(q, opf, flags);
+	if (IS_ERR(rq))
+		return ERR_CAST(rq);
+	return blk_mq_rq_to_pdu(rq);
+}
+EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
+
+/**
+ * scsi_put_internal_cmd - Free an internal SCSI command
+ * @scmd: SCSI command to be freed
+ *
+ * Check if @scmd is an internal command and call blk_mq_free_request() if true.
+ */
+void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
+{
+	struct request *rq = blk_mq_rq_from_pdu(scmd);
+
+	if (WARN_ON_ONCE(!blk_rq_is_internal(rq)))
+		return;
+	blk_mq_free_request(rq);
+}
+EXPORT_SYMBOL_GPL(scsi_put_internal_cmd);
+
 /**
  * scsi_device_from_queue - return sdev associated with a request_queue
  * @q: The request queue to return the sdev from
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d1c6fc83b1e3..348c12274324 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -9,6 +9,7 @@
 #include <scsi/scsi.h>
 #include <linux/atomic.h>
 #include <linux/sbitmap.h>
+#include <linux/dma-direction.h>
 
 struct bsg_device;
 struct device;
@@ -470,6 +471,9 @@ static inline int scsi_execute_req(struct scsi_device *sdev,
 	return scsi_execute(sdev, cmd, data_direction, buffer,
 		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
 }
+struct scsi_cmnd *scsi_get_internal_cmd(struct request_queue *q,
+	enum dma_data_direction data_direction, blk_mq_req_flags_t flags);
+void scsi_put_internal_cmd(struct scsi_cmnd *scmd);
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
