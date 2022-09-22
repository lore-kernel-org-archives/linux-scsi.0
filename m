Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F798C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 18:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiIVSbj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 14:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiIVSa6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 14:30:58 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CE610CA41
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 11:28:12 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p3so8428894iof.13
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 11:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8xAQy7aZ7BYH1DPQ+8tvyApZhb4BnQnHW544FcJ7XiE=;
        b=aR9k5LYhnfTw7XXQzoO5WAz8DP39KvgUKyrz1rGsakd/XddUjw6vg3NHGqsum9PG+V
         QoYoKbT2kP5nhO/G7Sy/qccemyc0E3pmzD1crhRZt6HqXTJEmz/xelocvDqKLNuVcNQL
         Sl0HAFLPpFWkeQlEmS28RX7jV9+hMHFzbx3TOKoTuYtLcwK9Es9RpjUt11hx8enBYeBL
         f8ky37PViY/csWh7e3o3oS3HydD07wSBCxDqzwz1zuVf+k0iAXXg38nE5IjnxNq1FTab
         lrWaeH8Gb5fnrrASwQQHIZ/F9tg1KlBE+kuCAi0dR8ZXyjP4xFMf/mRUd8VVQV7PK8FO
         ew0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8xAQy7aZ7BYH1DPQ+8tvyApZhb4BnQnHW544FcJ7XiE=;
        b=VmThlZq/97AZ4/qY6bFfNh0TVF1MsJoUtpFXUTdzp6Cte/GUC8iYLspzfUkTUte8GF
         i0FGiidvJ62xoKBMTqM6z1LihMKSgDbDmY83S1OrAwCsiE87E10oAe6Dyylx+H0s9x0A
         rAh+0HIM/viPWclThvNJGezCDWwlNayRnukSlzQImzVGgNpkJCVetdXMDYyhf4vKtGae
         elkm+p4s7eu6vf76Kgtx99pXNOqCCWV6idV3XhHxVnPFwhXzlqchTTUQEDMy7zYWiEfw
         G0HFrN0/rIJf/WfuuJA76gJby8jirby9/lmp/N5EBCm6/P6/c27FnMy2pJduOQjy0Yi8
         WhUw==
X-Gm-Message-State: ACrzQf0bUgofij4VG8f33EYrApPH2I49ICh514ZEIbRCmspUiplc4h02
        X+IIVG08dGsgia8/l4E80brudA==
X-Google-Smtp-Source: AMsMyM4SGqW5jyi20l7Smo7p+cJHNnri3FkeeL9qvvrk+1n6md6nK0KgGtTcdgUAs/H34Ch0+VvUPg==
X-Received: by 2002:a6b:ba05:0:b0:68a:8a2f:8fdc with SMTP id k5-20020a6bba05000000b0068a8a2f8fdcmr2255996iof.148.1663871291224;
        Thu, 22 Sep 2022 11:28:11 -0700 (PDT)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q20-20020a05663810d400b0035a468b7fbesm2440646jad.71.2022.09.22.11.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 11:28:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Jens Axboe <axboe@kernel.dk>, Stefan Roesch <shr@fb.com>
Subject: [PATCH 4/5] nvme: split out metadata vs non metadata end_io uring_cmd completions
Date:   Thu, 22 Sep 2022 12:28:04 -0600
Message-Id: <20220922182805.96173-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922182805.96173-1-axboe@kernel.dk>
References: <20220922182805.96173-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By splitting up the metadata and non-metadata end_io handling, we can
remove any request dependencies on the normal non-metadata IO path. This
is in preparation for enabling the normal IO passthrough path to pass
the ownership of the request back to the block layer.

Co-developed-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/ioctl.c | 82 +++++++++++++++++++++++++++++++--------
 1 file changed, 66 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index c80b3ecca5c8..1ccc9dd6d434 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -349,9 +349,18 @@ struct nvme_uring_cmd_pdu {
 		struct bio *bio;
 		struct request *req;
 	};
-	void *meta; /* kernel-resident buffer */
-	void __user *meta_buffer;
 	u32 meta_len;
+	union {
+		struct {
+			void *meta; /* kernel-resident buffer */
+			void __user *meta_buffer;
+		};
+		struct {
+			u32 nvme_flags;
+			u32 nvme_status;
+			u64 result;
+		};
+	};
 };
 
 static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
@@ -360,11 +369,10 @@ static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
 	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
 }
 
-static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
+static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	struct request *req = pdu->req;
-	struct bio *bio = req->bio;
 	int status;
 	u64 result;
 
@@ -375,27 +383,43 @@ static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
 
 	result = le64_to_cpu(nvme_req(req)->result.u64);
 
-	if (pdu->meta)
+	if (pdu->meta_len)
 		status = nvme_finish_user_metadata(req, pdu->meta_buffer,
 					pdu->meta, pdu->meta_len, status);
-	if (bio)
-		blk_rq_unmap_user(bio);
+	if (req->bio)
+		blk_rq_unmap_user(req->bio);
 	blk_mq_free_request(req);
 
 	io_uring_cmd_done(ioucmd, status, result);
 }
 
+static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
+{
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+	int status;
+
+	if (pdu->nvme_flags & NVME_REQ_CANCELLED)
+		status = -EINTR;
+	else
+		status = pdu->nvme_status;
+
+	if (pdu->bio)
+		blk_rq_unmap_user(pdu->bio);
+
+	io_uring_cmd_done(ioucmd, status, pdu->result);
+}
+
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 						blk_status_t err)
 {
 	struct io_uring_cmd *ioucmd = req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
-	/* extract bio before reusing the same field for request */
-	struct bio *bio = pdu->bio;
 	void *cookie = READ_ONCE(ioucmd->cookie);
 
-	pdu->req = req;
-	req->bio = bio;
+	req->bio = pdu->bio;
+	pdu->nvme_flags = nvme_req(req)->flags;
+	pdu->nvme_status = nvme_req(req)->status;
+	pdu->result = le64_to_cpu(nvme_req(req)->result.u64);
 
 	/*
 	 * For iopoll, complete it directly.
@@ -406,6 +430,29 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 
+	blk_mq_free_request(req);
+	return RQ_END_IO_NONE;
+}
+
+static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req,
+						     blk_status_t err)
+{
+	struct io_uring_cmd *ioucmd = req->end_io_data;
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+	void *cookie = READ_ONCE(ioucmd->cookie);
+
+	req->bio = pdu->bio;
+	pdu->req = req;
+
+	/*
+	 * For iopoll, complete it directly.
+	 * Otherwise, move the completion to task work.
+	 */
+	if (cookie != NULL && blk_rq_is_poll(req))
+		nvme_uring_task_meta_cb(ioucmd);
+	else
+		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_meta_cb);
+
 	return RQ_END_IO_NONE;
 }
 
@@ -467,8 +514,6 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 			blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
-	req->end_io = nvme_uring_cmd_end_io;
-	req->end_io_data = ioucmd;
 
 	if (issue_flags & IO_URING_F_IOPOLL && rq_flags & REQ_POLLED) {
 		if (unlikely(!req->bio)) {
@@ -483,10 +528,15 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	}
 	/* to free bio on completion, as req->bio will be null at that time */
 	pdu->bio = req->bio;
-	pdu->meta = meta;
-	pdu->meta_buffer = nvme_to_user_ptr(d.metadata);
 	pdu->meta_len = d.metadata_len;
-
+	req->end_io_data = ioucmd;
+	if (pdu->meta_len) {
+		pdu->meta = meta;
+		pdu->meta_buffer = nvme_to_user_ptr(d.metadata);
+		req->end_io = nvme_uring_cmd_end_io_meta;
+	} else {
+		req->end_io = nvme_uring_cmd_end_io;
+	}
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
 }
-- 
2.35.1

