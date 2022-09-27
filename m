Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BB3C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 01:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiI0Bod (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 21:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiI0Boa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 21:44:30 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62A0A74C0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 18:44:27 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s26so8102041pgv.7
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 18:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=OWQyl94A5qNKtPnF/8PyOhg9aeGApg21Zf8bAO/j86s=;
        b=mP3PeN6PCELyvJQ+DXmQS2FoJwddmxuB7MQ2/UGEabb+Nm+/V452tOJaIqhRCFbWIv
         IDC2qnSZZmCGdo5dh/q1ZBrd1oigApYXtLJPSyGuJcrx8rVIz3Xa9fMTdc/32SjSGYm7
         R1IZP4E6Ph619vy2hU2ZZMhbef7T8doLfRUOMdOWG67R4osTEnmvvI4sEeF4Dotkbtmv
         CrJeo7+GHMCQX9bmnTYIvdrUCh1UfScfimPbsJ1bRgeXH5KLwHYydc/+NxR7gHcVuM7W
         vDmc3SweNBhuBsmVtob4aqGhkqVJzVipuHgB1xuPXoC3Yk7y4SIW9wNbXnUChX9C0mQN
         sIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=OWQyl94A5qNKtPnF/8PyOhg9aeGApg21Zf8bAO/j86s=;
        b=5vU+ZY4UxghnbWocdARALH0aEqFQ+Q7rqPMl8ZozZpOFBD5aV2vMyMqRz7GEyOKyfk
         4ntiMuTAIXbx9qCokJwNxXqZvSOFzuPtmiADH1kV17J4NsXjCBacMEqPWeBfscNYR8Hw
         JplkqzkCXNjkLDSUEvZq80/cP5Xys0ccHCH4cudlUFV6GFWwBJ2XfigKjzHJEPDauOtG
         ied3gmVWNzn41Y3h2+W4blUSG/LHK1Uxp5Oovufiz8Z8zGQPTZeDDqsHLmA1Qfyzs7E+
         Sz0soVVpKQoA69ODIIUv3U2pEXS7sRPATrL8ofOu2yqnSF/d7r6v6ohOvdwLmqV3trvC
         +NIw==
X-Gm-Message-State: ACrzQf1pv/RI517RHnELCq2yC1rWuYrxM46LvcTioITIyOijlBB4Qlq6
        iKJ6C11Yx/jHcXcGZRr8WBE7k4ElcN1Y/Q==
X-Google-Smtp-Source: AMsMyM4b4xjI5VuwTPQxKRtlKpdTkx4cE0vHyJY+Uc0NtDg0sPzbmbmbPkA9/NgxXSIQ4gKYg+MuEw==
X-Received: by 2002:a62:1bc8:0:b0:546:c62e:e84 with SMTP id b191-20020a621bc8000000b00546c62e0e84mr26532012pfb.45.1664243066985;
        Mon, 26 Sep 2022 18:44:26 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o2-20020aa79782000000b00537d60286c9sm183062pfp.113.2022.09.26.18.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 18:44:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Jens Axboe <axboe@kernel.dk>, Stefan Roesch <shr@fb.com>
Subject: [PATCH 4/5] nvme: split out metadata vs non metadata end_io uring_cmd completions
Date:   Mon, 26 Sep 2022 19:44:19 -0600
Message-Id: <20220927014420.71141-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220927014420.71141-1-axboe@kernel.dk>
References: <20220927014420.71141-1-axboe@kernel.dk>
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
 drivers/nvme/host/ioctl.c | 79 ++++++++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 18 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index c80b3ecca5c8..9e356a6c96c2 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -349,9 +349,15 @@ struct nvme_uring_cmd_pdu {
 		struct bio *bio;
 		struct request *req;
 	};
-	void *meta; /* kernel-resident buffer */
-	void __user *meta_buffer;
 	u32 meta_len;
+	u32 nvme_status;
+	union {
+		struct {
+			void *meta; /* kernel-resident buffer */
+			void __user *meta_buffer;
+		};
+		u64 result;
+	} u;
 };
 
 static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
@@ -360,11 +366,10 @@ static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
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
 
@@ -375,27 +380,39 @@ static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
 
 	result = le64_to_cpu(nvme_req(req)->result.u64);
 
-	if (pdu->meta)
-		status = nvme_finish_user_metadata(req, pdu->meta_buffer,
-					pdu->meta, pdu->meta_len, status);
-	if (bio)
-		blk_rq_unmap_user(bio);
+	if (pdu->meta_len)
+		status = nvme_finish_user_metadata(req, pdu->u.meta_buffer,
+					pdu->u.meta, pdu->meta_len, status);
+	if (req->bio)
+		blk_rq_unmap_user(req->bio);
 	blk_mq_free_request(req);
 
 	io_uring_cmd_done(ioucmd, status, result);
 }
 
+static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
+{
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+
+	if (pdu->bio)
+		blk_rq_unmap_user(pdu->bio);
+
+	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->u.result);
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
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		pdu->nvme_status = -EINTR;
+	else
+		pdu->nvme_status = nvme_req(req)->status;
+	pdu->u.result = le64_to_cpu(nvme_req(req)->result.u64);
 
 	/*
 	 * For iopoll, complete it directly.
@@ -406,6 +423,29 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
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
 
@@ -467,8 +507,6 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 			blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
-	req->end_io = nvme_uring_cmd_end_io;
-	req->end_io_data = ioucmd;
 
 	if (issue_flags & IO_URING_F_IOPOLL && rq_flags & REQ_POLLED) {
 		if (unlikely(!req->bio)) {
@@ -483,10 +521,15 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	}
 	/* to free bio on completion, as req->bio will be null at that time */
 	pdu->bio = req->bio;
-	pdu->meta = meta;
-	pdu->meta_buffer = nvme_to_user_ptr(d.metadata);
 	pdu->meta_len = d.metadata_len;
-
+	req->end_io_data = ioucmd;
+	if (pdu->meta_len) {
+		pdu->u.meta = meta;
+		pdu->u.meta_buffer = nvme_to_user_ptr(d.metadata);
+		req->end_io = nvme_uring_cmd_end_io_meta;
+	} else {
+		req->end_io = nvme_uring_cmd_end_io;
+	}
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
 }
-- 
2.35.1

