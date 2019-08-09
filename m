Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6A7C31E40
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 10:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A20272171F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 10:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZDx2+xm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406367AbfHIKyt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Aug 2019 06:54:49 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35333 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfHIKyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Aug 2019 06:54:49 -0400
Received: by mail-ed1-f65.google.com with SMTP id w20so94527938edd.2;
        Fri, 09 Aug 2019 03:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xt0t0Oq4acEqkJbqLnYVPWJEmHrA4PjKK4iicWzZq3o=;
        b=DZDx2+xmInpW+Kh0ULTjXBkwb9Wip1PO5f/pSyz8d0ghAkjYVaFhef+q9FU60+7G88
         oLt7/GikKceBNuaSuI8+SvfLJh6x9U69RAunqqEx6PNbjCnJZkC3tsotSlN6hH8q8AMK
         ZLmuc0m6StFP5MSAr5nK55X4u8rfTAGI7NNKSKt4JpGwNXLY40Mytuyw2V2Kun0/j/wM
         QTbclnhwnzv7sVW4RGm7Kx6Lf47tvMcMbL5iOshfnGXW7pYDHGG4yMZi6H9v+l7w09ib
         4Cc9JzQwk1jWQMa8GKzHTTQISnxDDjQgBNjN31xTAng8tPE5R64OCn2f5vqU++40TX8E
         WQ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xt0t0Oq4acEqkJbqLnYVPWJEmHrA4PjKK4iicWzZq3o=;
        b=B5JJW6odqJLIDFYqi1xc37VjsqqzjpoR0VosxNKVQB3g7S7MP3zgub60/6Y4sqTUhw
         hdype7qfFtQSe+jfcKr+59EzPAqX6JFcDE/ky4UEt6Q2aiJGS8vV8oP7CwT8t1klX88m
         lGxRN22o1eXQKg4P1sD0dLoKXrpOl8O6eCGgN/5zX19tllmn+XRLvkDTLPPKHA3R4pM7
         ts4N+OYNppoLB31VnCo48C2gnMlaBCbq4ZoHiE8/p05Zw4TeEZ7UKjYXy2pmQj2TKmC8
         gc/D59rl3woJRebnrmwFUaJqo+Del1/rOOK0Ap+PJBNuTdO107ojCTOyN78wN1sfMUJa
         iozA==
X-Gm-Message-State: APjAAAVPOn8NW3D+FtJweMrcGyLTjfBOAbCqSnLQ1eRWQ97basD2cVAv
        rcTyZm5oVZG33ee4GVstYKkGUx6vq68jPQ==
X-Google-Smtp-Source: APXvYqysaecgybcYmpXFxIi26pt+RPUTBMSRXuXUP90BrN0Ud3f7IHyfp5T7mPAKRtdgXyjfWoUa1Q==
X-Received: by 2002:a17:906:60c6:: with SMTP id f6mr12826090ejk.272.1565348085616;
        Fri, 09 Aug 2019 03:54:45 -0700 (PDT)
Received: from continental.suse.de ([177.96.42.43])
        by smtp.gmail.com with ESMTPSA id x55sm22289167edm.11.2019.08.09.03.54.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 03:54:45 -0700 (PDT)
From:   Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Marcos Paulo de Souza <marcos.souza.org@gmail.com>, hch@lst.de,
        axboe@kernel.dk, linux-block@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-nvme@lists.infradead.org (open list:NVM EXPRESS DRIVER),
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
Subject: [PATCHv2  3/4] block: Change at_head argument of blk_execute_rq_nowait to bool
Date:   Fri,  9 Aug 2019 07:54:32 -0300
Message-Id: <20190809105433.8946-4-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809105433.8946-1-marcos.souza.org@gmail.com>
References: <20190809105433.8946-1-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190809105432.lyMwAiC2-t-JHVTeSUSTL1JYRBifNg9j52hEtBw8Fz8@z>

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 block/blk-exec.c             |  2 +-
 drivers/nvme/host/core.c     | 12 ++++++------
 drivers/nvme/host/lightnvm.c |  2 +-
 drivers/nvme/host/nvme.h     |  2 +-
 drivers/nvme/host/pci.c      |  2 +-
 drivers/scsi/scsi_error.c    |  2 +-
 drivers/scsi/st.c            |  2 +-
 include/linux/blkdev.h       |  2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 7862f8be39d1..c8b88f469988 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -45,7 +45,7 @@ static void blk_end_sync_rq(struct request *rq, blk_status_t error)
  *    This function will invoke @done directly if the queue is dead.
  */
 void blk_execute_rq_nowait(struct gendisk *bd_disk, struct request *rq,
-			int at_head, rq_end_io_fn *done)
+			bool at_head, rq_end_io_fn *done)
 {
 	WARN_ON(irqs_disabled());
 	WARN_ON(!blk_rq_is_passthrough(rq));
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4a2ed03223b1..38c1a5db9e56 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -748,7 +748,7 @@ static void nvme_end_sync_rq(struct request *rq, blk_status_t error)
 }

 static void nvme_execute_rq_polled(struct request_queue *q,
-		struct gendisk *bd_disk, struct request *rq, int at_head)
+		struct gendisk *bd_disk, struct request *rq, bool at_head)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);

@@ -770,7 +770,7 @@ static void nvme_execute_rq_polled(struct request_queue *q,
  */
 int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		union nvme_result *result, void *buffer, unsigned bufflen,
-		unsigned timeout, int qid, int at_head,
+		unsigned timeout, int qid, bool at_head,
 		blk_mq_req_flags_t flags, bool poll)
 {
 	struct request *req;
@@ -808,7 +808,7 @@ int nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void *buffer, unsigned bufflen)
 {
 	return __nvme_submit_sync_cmd(q, cmd, NULL, buffer, bufflen, 0,
-			NVME_QID_ANY, 0, 0, false);
+			NVME_QID_ANY, false, 0, false);
 }
 EXPORT_SYMBOL_GPL(nvme_submit_sync_cmd);

@@ -941,7 +941,7 @@ static int nvme_keep_alive(struct nvme_ctrl *ctrl)
 	rq->timeout = ctrl->kato * HZ;
 	rq->end_io_data = ctrl;

-	blk_execute_rq_nowait(NULL, rq, 0, nvme_keep_alive_end_io);
+	blk_execute_rq_nowait(NULL, rq, false, nvme_keep_alive_end_io);

 	return 0;
 }
@@ -1127,7 +1127,7 @@ static int nvme_features(struct nvme_ctrl *dev, u8 op, unsigned int fid,
 	c.features.dword11 = cpu_to_le32(dword11);

 	ret = __nvme_submit_sync_cmd(dev->admin_q, &c, &res,
-			buffer, buflen, 0, NVME_QID_ANY, 0, 0, false);
+			buffer, buflen, 0, NVME_QID_ANY, false, 0, false);
 	if (ret >= 0 && result)
 		*result = le32_to_cpu(res.u32);
 	return ret;
@@ -1871,7 +1871,7 @@ int nvme_sec_submit(void *data, u16 spsp, u8 secp, void *buffer, size_t len,
 	cmd.common.cdw11 = cpu_to_le32(len);

 	return __nvme_submit_sync_cmd(ctrl->admin_q, &cmd, NULL, buffer, len,
-				      ADMIN_TIMEOUT, NVME_QID_ANY, 1, 0, false);
+				      ADMIN_TIMEOUT, NVME_QID_ANY, true, 0, false);
 }
 EXPORT_SYMBOL_GPL(nvme_sec_submit);
 #endif /* CONFIG_BLK_SED_OPAL */
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index 9c82a5044b75..c09989376c3b 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -685,7 +685,7 @@ static int nvme_nvm_submit_io(struct nvm_dev *dev, struct nvm_rq *rqd)

 	rq->end_io_data = rqd;

-	blk_execute_rq_nowait(NULL, rq, 0, nvme_nvm_end_io);
+	blk_execute_rq_nowait(NULL, rq, false, nvme_nvm_end_io);

 	return 0;
 }
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 26b563f9985b..f43d0189cba3 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -464,7 +464,7 @@ int nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void *buf, unsigned bufflen);
 int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		union nvme_result *result, void *buffer, unsigned bufflen,
-		unsigned timeout, int qid, int at_head,
+		unsigned timeout, int qid, bool at_head,
 		blk_mq_req_flags_t flags, bool poll);
 int nvme_set_features(struct nvme_ctrl *dev, unsigned int fid,
 		      unsigned int dword11, void *buffer, size_t buflen,
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d8f83696b4ba..20cbadc7469d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1332,7 +1332,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)

 	abort_req->timeout = ADMIN_TIMEOUT;
 	abort_req->end_io_data = NULL;
-	blk_execute_rq_nowait(NULL, abort_req, 0, abort_endio);
+	blk_execute_rq_nowait(NULL, abort_req, false, abort_endio);

 	/*
 	 * The aborted req will be completed on receiving the abort req.
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 49cda23c7fb8..48b1cbb72e32 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1988,7 +1988,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	req->timeout = 10 * HZ;
 	rq->retries = 5;

-	blk_execute_rq_nowait(NULL, req, 1, eh_lock_door_done);
+	blk_execute_rq_nowait(NULL, req, false, eh_lock_door_done);
 }

 /**
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 3b828f260294..1d81125f8d35 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -583,7 +583,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	rq->retries = retries;
 	req->end_io_data = SRpnt;

-	blk_execute_rq_nowait(NULL, req, 1, st_scsi_execute_end);
+	blk_execute_rq_nowait(NULL, req, true, st_scsi_execute_end);
 	return 0;
 }

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c9d9ca686290..19ed996f0074 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -866,7 +866,7 @@ extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
 			       struct rq_map_data *, const struct iov_iter *,
 			       gfp_t);
 extern void blk_execute_rq(struct gendisk *, struct request *, int);
-extern void blk_execute_rq_nowait(struct gendisk *, struct request *, int,
+extern void blk_execute_rq_nowait(struct gendisk *, struct request *, bool,
 				rq_end_io_fn *);

 /* Helper to convert REQ_OP_XXX to its string format XXX */
--
2.22.0

