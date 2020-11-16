Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35CDC63699
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 03:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 715BB22284
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 03:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgKPDFP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 22:05:15 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33747 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgKPDFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 22:05:14 -0500
Received: by mail-pl1-f193.google.com with SMTP id t18so7684258plo.0;
        Sun, 15 Nov 2020 19:05:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mZIHmdfI6VuvHQbFk9elE6LcTPI0DIedaaHe1HmoEWQ=;
        b=aVfDMxUSJl3Ye3FqLMgBVE00iYf71oJGEXA0siXjzihcfpTHXrDrFj/1cDONE3X6+Y
         pt1FRmsFWCNbZoAisjkh8FS9xBN5cJe1s0T4gGxismfrOogMydQXKxh2gXRK/mXImR4y
         BqygnR5PDQYT7Qj3HbkVZ+4DoRza+mtvWLcbeOWV2iV655kpI4U7nysDmjdV1AtIdx7O
         eAshjCAOQPwPzQNxeOJ/xoFJURWnid7wPLyyWZmcbcr8gCy6oOladNe1GXQqPdKWJqN7
         qCx48RkNqu93Ldr3QK+xXw+PGedBkjsbg4r7qbdphgJo7SgQTuy2TBB5fz/RpaHM+8ss
         Ct6w==
X-Gm-Message-State: AOAM531KYi99i1a1hCil0Ni3AUrB/fFHuhEJrgbG7Qfc1tLtU+uYE8Ak
        7p1gL1IQ9cMj1yb9TVl1VlQmW9KxSBw=
X-Google-Smtp-Source: ABdhPJx/6VW6L7Lds24w5+sY39CJEbCX/iKl6RazpeIUgulPPS7RPBD5bhsbOyWRCgGGqTH1ubNGxg==
X-Received: by 2002:a17:902:8206:b029:d8:de70:7f7a with SMTP id x6-20020a1709028206b02900d8de707f7amr8537425pln.39.1605495913828;
        Sun, 15 Nov 2020 19:05:13 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r3sm17148131pjl.23.2020.11.15.19.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 19:05:13 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v2 3/9] scsi: Pass a request queue pointer to __scsi_execute()
Date:   Sun, 15 Nov 2020 19:04:53 -0800
Message-Id: <20201116030459.13963-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116030459.13963-1-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes a later patch easier
to read.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 12 +++++-------
 include/scsi/scsi_device.h |  8 ++++----
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 855e48c7514f..e4f9ed355be6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -221,7 +221,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 
 /**
  * __scsi_execute - insert request and wait for the result
- * @sdev:	scsi device
+ * @q:		queue to insert the request into
  * @cmd:	scsi command
  * @data_direction: data direction
  * @buffer:	data buffer
@@ -237,7 +237,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
-int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+int __scsi_execute(struct request_queue *q, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
 		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
 		 int timeout, int retries, u64 flags, req_flags_t rq_flags,
@@ -247,15 +247,13 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	struct scsi_request *rq;
 	int ret = DRIVER_ERROR << 24;
 
-	req = blk_get_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
+	req = blk_get_request(q, data_direction == DMA_TO_DEVICE ?
 			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
 
-	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
-					buffer, bufflen, GFP_NOIO))
+	if (bufflen && blk_rq_map_kern(q, req, buffer, bufflen, GFP_NOIO))
 		goto out;
 
 	rq->cmd_len = COMMAND_SIZE(cmd[0]);
@@ -268,7 +266,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	/*
 	 * head injection *required* here otherwise quiesce won't work
 	 */
-	blk_execute_rq(req->q, NULL, req, 1);
+	blk_execute_rq(q, NULL, req, 1);
 
 	/*
 	 * Some devices (USB mass-storage in particular) may transfer
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1a5c9a3df6d6..f47fdf9cf788 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -438,7 +438,7 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+extern int __scsi_execute(struct request_queue *q, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, struct scsi_sense_hdr *sshdr,
 			int timeout, int retries, u64 flags,
@@ -449,9 +449,9 @@ extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 ({									\
 	BUILD_BUG_ON((sense) != NULL &&					\
 		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
-		       sense, sshdr, timeout, retries, flags, rq_flags,	\
-		       resid);						\
+	__scsi_execute(sdev->request_queue, cmd, data_direction,	\
+		       buffer, bufflen, sense, sshdr, timeout, retries,	\
+		       flags, rq_flags, resid);				\
 })
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
