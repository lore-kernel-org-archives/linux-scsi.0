Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD21C64E7B
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9860C2137B
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgKWDSG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Nov 2020 22:18:06 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35224 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgKWDSE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2020 22:18:04 -0500
Received: by mail-pf1-f194.google.com with SMTP id e8so1680504pfh.2;
        Sun, 22 Nov 2020 19:18:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7U1bBg9mtcxgLSyUamru5veGVT0V1fCjsWqTiK4UHjc=;
        b=qt/C8qREgv/xLSTEblfYV+dYhpQHqFgdV7xp2DOBpS1lShgYSZ13VWxGSr/mTJSdLe
         GlxpP9ub9CO8S4lKy5+WgTcj46Veicmq0vztpTvTCAY6d4B9SXvt/zdVhrOjj1zLhu5n
         NueNJr6dkvC+0asKhg301RUFB/5QxpBaCCgfI8EoTkLTPGdl+Fl1WFe2ecwLNU2ThhaG
         yzh4GUhKaF7SkYZiaPdkrrz1iE7YHJU8LsKFwyanCzBJX0gj9Tvac56EF8mMI64IUn23
         JmR31ZOp1oxCDRN1It5953NpeCrZnvvN+ydRLSxWwg0pfbsEnGR7uxErAt+2gB3ZF4IG
         7sEg==
X-Gm-Message-State: AOAM531jDAB8MELoAIt/NIbFf45aIKRkYBRBL4+591o3mqa/XpEp8u8r
        i8ffTqQot6IciekXOk9ubi8=
X-Google-Smtp-Source: ABdhPJzwBKZTBTKXA/zbytcb/gOcpT30qXYxttCAJ6kyqqBHL1fy5iI9m4Qj8ogDX7EFbAMOTRLWXA==
X-Received: by 2002:a62:b417:0:b029:18b:8c55:849f with SMTP id h23-20020a62b4170000b029018b8c55849fmr22700983pfn.27.1606101483225;
        Sun, 22 Nov 2020 19:18:03 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w12sm3578751pfn.136.2020.11.22.19.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 19:18:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v3 3/9] scsi: Pass a request queue pointer to __scsi_execute()
Date:   Sun, 22 Nov 2020 19:17:43 -0800
Message-Id: <20201123031749.14912-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123031749.14912-1-bvanassche@acm.org>
References: <20201123031749.14912-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes a later patch easier
to read.

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Can Guo <cang@codeaurora.org>
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
index b7ac14571415..a7252df74c7b 100644
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
