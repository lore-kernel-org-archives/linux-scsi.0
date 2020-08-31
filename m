Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4253C43461
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DDD52076D
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgHaCyW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 22:54:22 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51817 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbgHaCyS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 22:54:18 -0400
Received: by mail-pj1-f68.google.com with SMTP id ds1so2374411pjb.1
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2020 19:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4YX0sEfiQTofSJ4KcUjPBVPtbkSMO7Wts0x5QKbGp/I=;
        b=cpjHoVd4+zHKv/xkc6sCsZm0nl8hZLtX9oUniTeIr3gZrV9fdqrhoewJFEa6/qHVH0
         FFhGFjKcIarXcO3WVpjazDPO2CSCxGaiFCEWEGnc+hQ8VeMgr9HGROh4jhBPAM+oRK7P
         4Zlp71bm7VfTw5eut21RmWjRJxVe2BdpIwAbwGZIfos8dRoipCeM+1o8WeHDC+65ua+2
         5d/1GE6l82oKNqcamT88EpUYi049+JIXSyPNQFM/cvM5+5pUVQelIyExj1+tstbKiGC3
         s4fB/hTttaDH6djv7zpYpU9Pp+ldkOMqz4imRIqXC0gJSAJ/Xy+4RB+xjyMT/Cj/uzSn
         e8iQ==
X-Gm-Message-State: AOAM531qXusWWgMZtC4ic1NlTfZ1+9ijA1e1TlNibWbH+3SiV43GxO6u
        7TuqPO3PCjk4lI54Rz8Bgg8=
X-Google-Smtp-Source: ABdhPJx6AAo+CN+uErgb7TIHvIomOTrqIJw9ZcQnYZyJgkamjZSemBKAXADal4kDcT08qXwKOo40kg==
X-Received: by 2002:a17:90a:4401:: with SMTP id s1mr8431645pjg.79.1598842451502;
        Sun, 30 Aug 2020 19:54:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l123sm583569pgl.24.2020.08.30.19.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 19:54:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-scsi@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH RFC 3/6] scsi: Pass a request queue pointer to __scsi_execute()
Date:   Sun, 30 Aug 2020 19:53:54 -0700
Message-Id: <20200831025357.32700-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831025357.32700-1-bvanassche@acm.org>
References: <20200831025357.32700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes a later patch easier
to read.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 12 +++++-------
 include/scsi/scsi_device.h |  8 ++++----
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1bc7f2ffe627..1d7135f61962 100644
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
index 264501d23aea..ef6e96e12c7c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -437,7 +437,7 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+extern int __scsi_execute(struct request_queue *q, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, struct scsi_sense_hdr *sshdr,
 			int timeout, int retries, u64 flags,
@@ -448,9 +448,9 @@ extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
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
