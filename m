Return-Path: <SRS0=a8U3=CP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52C6C433E2
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB21D20797
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgIFBWe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 21:22:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40347 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgIFBWc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 21:22:32 -0400
Received: by mail-pf1-f193.google.com with SMTP id c142so6695652pfb.7;
        Sat, 05 Sep 2020 18:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8jGBLbX9aQ4igyxvlbO+xM3lsCwOiOhsZviFPqeRyww=;
        b=QiK/TAjd0IRk/Urd3JimYAzpjZHStExafrJxJLOTD5S0JEvvL50CMGZCcpNV6YSP1c
         h6JcDjX47c6bZXIwbjz4gILz1OcutLShO1dVZGDZDzg9FFyhrIqbmOg3jPQ2TKmDgEFh
         mTGlCicnPAttXvjwKd/xyCN20HyPOGTjiNwvQ30Bkoeqwhki9lzXI54vKvAOah4bewp2
         C4h4WMRwgm+b5eI5bOVDDQnuGXePBaYgVR4WsQEvN9AKH14MFSaqUAG4L4gjXz0163Jv
         9552SbvJ3W89auQqMF7LHffbE9Cjh9Ah8oi7b/UuEtLIOUGbMbXk2W3zoAQyvgaN1Qkg
         yXOg==
X-Gm-Message-State: AOAM532pE+vM8Yv6vYI+FppH1Xlpx8AjTsRgdKANYI/9e93xhGmHRmAL
        u16GK+opIUThKZ+cj8GCZek=
X-Google-Smtp-Source: ABdhPJwjLI4CYnlp6qE+ah1iiZB2eY2NAaSszFwG9BwPWtxDpJmGRUrmd8LiBOw1N/4Z6IjOmY/fVA==
X-Received: by 2002:a63:1341:: with SMTP id 1mr12383078pgt.144.1599355351570;
        Sat, 05 Sep 2020 18:22:31 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:cd46:435a:ac98:84de])
        by smtp.gmail.com with ESMTPSA id 25sm3585165pjh.57.2020.09.05.18.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 18:22:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3/9] scsi: Pass a request queue pointer to __scsi_execute()
Date:   Sat,  5 Sep 2020 18:22:13 -0700
Message-Id: <20200906012219.17893-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200906012219.17893-1-bvanassche@acm.org>
References: <20200906012219.17893-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes a later patch easier
to read.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
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
index 7affaaf8b98e..760976f27634 100644
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
index bc5909033d13..48c80793915e 100644
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
