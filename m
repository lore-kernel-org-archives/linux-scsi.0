Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A7FC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C8EC207EA
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgHaCyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 22:54:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40479 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbgHaCyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 22:54:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id h12so3515992pgm.7
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2020 19:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SeFFyUKS6uGufgLGDwNhxeXppNyw1pKVFHPf/YB+iH0=;
        b=K/5G7q833zDF9PwQMMf0gNSjfHxfcGMdfgYolfjUXaJnnUq76wCcPmP7jmo1YxgPm9
         f1gSVv+WfLfgS4JdnbzlwVS6bNsBxuDjSICrgRJ0gpb0Jq+j31nIopuN5Wo4dD5gY2uX
         dntIv6tO0MpnNSad2BwFym2pKEECu4eDxz0C4F2CJWTL+fLbAJe3jjS+fBjDEBuAwPG9
         374hGVuZ6WV1wWlChBC9k5J8W+Ow09VBGbY6EUY1S7Ewfo3SAKoj6/OCTMnl+nTOIY6/
         iaKWOKxsdSNGuEvJKFr2+kO2M1HSoatuWSwDgKUIFIeO4PG/z3v6XQa1f2R553xtdQHw
         L3Jw==
X-Gm-Message-State: AOAM531c7dnv8IcNluuJhnp8ibUzClSn+KvAGaH6sBGcvz4Sx5MnSM9o
        PsH3OkYnxnz6fwiRZmjstAk=
X-Google-Smtp-Source: ABdhPJwzbTRu1Sz3qJz8PMl/txNcg3nyQydghqpojfl8Vnp3W+zcffbdnK90FG8i6A7WkDxL6/9cPA==
X-Received: by 2002:a63:e051:: with SMTP id n17mr6903455pgj.219.1598842456031;
        Sun, 30 Aug 2020 19:54:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l123sm583569pgl.24.2020.08.30.19.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 19:54:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-scsi@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH RFC 6/6] block, scsi, ide: Only submit power management requests in state RPM_SUSPENDED
Date:   Sun, 30 Aug 2020 19:53:57 -0700
Message-Id: <20200831025357.32700-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831025357.32700-1-bvanassche@acm.org>
References: <20200831025357.32700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Recently Martin Kepplinger reported a problem with the SCSI runtime PM
code. Alan Stern root-caused that deadlock as follows:

	Thread 0		Thread 1
	--------		--------
	Start runtime suspend
	blk_pre_runtime_suspend calls
	  blk_set_pm_only and sets
	  q->rpm_status to RPM_SUSPENDING

				Call sd_open -> ... -> scsi_test_unit_ready
				  -> __scsi_execute -> ...
				  -> blk_queue_enter
				Sees BLK_MQ_REQ_PREEMPT set and
				  RPM_SUSPENDING queue status, so does
				  not postpone the request

	blk_post_runtime_suspend sets
	  q->rpm_status to RPM_SUSPENDED
	The drive goes into runtime suspend

				Issues the TEST UNIT READY request
				Request fails because the drive is suspended

Fix that deadlock by only accepting power management requests while
suspended. Remove flag RQF_PREEMPT.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c        |  6 +++---
 block/blk-mq-debugfs.c  |  1 -
 block/blk-mq.c          |  4 ++--
 drivers/ide/ide-io.c    |  3 +--
 drivers/ide/ide-pm.c    |  2 +-
 drivers/scsi/scsi_lib.c | 27 ++++++++++++++-------------
 include/linux/blk-mq.h  |  4 ++--
 include/linux/blkdev.h  |  6 +-----
 8 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d9d632639bd1..78a002ff9473 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -420,11 +420,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
 /**
  * blk_queue_enter() - try to increase q->q_usage_counter
  * @q: request queue pointer
- * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
+ * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PM
  */
 int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 {
-	const bool pm = flags & BLK_MQ_REQ_PREEMPT;
+	const bool pm = flags & BLK_MQ_REQ_PM;
 
 	while (true) {
 		bool success = false;
@@ -626,7 +626,7 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
 	struct request *req;
 
 	WARN_ON_ONCE(op & REQ_NOWAIT);
-	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT));
+	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM));
 
 	req = blk_mq_alloc_request(q, op, flags);
 	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 3f09bcb8a6fd..9273978f06e7 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -296,7 +296,6 @@ static const char *const rqf_name[] = {
 	RQF_NAME(MIXED_MERGE),
 	RQF_NAME(MQ_INFLIGHT),
 	RQF_NAME(DONTPREP),
-	RQF_NAME(PREEMPT),
 	RQF_NAME(FAILED),
 	RQF_NAME(QUIET),
 	RQF_NAME(ELVPRIV),
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0015a1892153..4e7589e55bf5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -292,8 +292,8 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->mq_hctx = data->hctx;
 	rq->rq_flags = 0;
 	rq->cmd_flags = data->cmd_flags;
-	if (data->flags & BLK_MQ_REQ_PREEMPT)
-		rq->rq_flags |= RQF_PREEMPT;
+	if (data->flags & BLK_MQ_REQ_PM)
+		rq->rq_flags |= RQF_PM;
 	if (blk_queue_io_stat(data->q))
 		rq->rq_flags |= RQF_IO_STAT;
 	INIT_LIST_HEAD(&rq->queuelist);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 1a53c7a75224..beb850679fa9 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -522,8 +522,7 @@ blk_status_t ide_issue_rq(ide_drive_t *drive, struct request *rq,
 		 * state machine.
 		 */
 		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
-		    ata_pm_request(rq) == 0 &&
-		    (rq->rq_flags & RQF_PREEMPT) == 0) {
+		    ata_pm_request(rq) == 0) {
 			/* there should be no pending command at this point */
 			ide_unlock_port(hwif);
 			goto plug_device;
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 192e6c65d34e..82ab308f1aaf 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -77,7 +77,7 @@ int generic_ide_resume(struct device *dev)
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, BLK_MQ_REQ_PREEMPT);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
 	ide_req(rq)->type = ATA_PRIV_PM_RESUME;
 	ide_req(rq)->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 49eb8f2dffd8..bd9930964697 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -248,7 +248,8 @@ int __scsi_execute(struct request_queue *q, const unsigned char *cmd,
 	int ret = DRIVER_ERROR << 24;
 
 	req = blk_get_request(q, data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
+			      REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
+			      rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
@@ -1219,6 +1220,8 @@ static blk_status_t
 scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 {
 	switch (sdev->sdev_state) {
+	case SDEV_CREATED:
+		return BLK_STS_OK;
 	case SDEV_OFFLINE:
 	case SDEV_TRANSPORT_OFFLINE:
 		/*
@@ -1245,18 +1248,18 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 		return BLK_STS_RESOURCE;
 	case SDEV_QUIESCE:
 		/*
-		 * If the devices is blocked we defer normal commands.
+		 * If the device is blocked we only accept power management
+		 * commands.
 		 */
-		if (req && !(req->rq_flags & RQF_PREEMPT))
+		if (req && WARN_ON_ONCE(!(req->rq_flags & RQF_PM)))
 			return BLK_STS_RESOURCE;
 		return BLK_STS_OK;
 	default:
 		/*
 		 * For any other not fully online state we only allow
-		 * special commands.  In particular any user initiated
-		 * command is not allowed.
+		 * power management commands.
 		 */
-		if (req && !(req->rq_flags & RQF_PREEMPT))
+		if (req && !(req->rq_flags & RQF_PM))
 			return BLK_STS_IOERR;
 		return BLK_STS_OK;
 	}
@@ -2489,15 +2492,13 @@ void sdev_evt_send_simple(struct scsi_device *sdev,
 EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
 
 /**
- *	scsi_device_quiesce - Block user issued commands.
+ *	scsi_device_quiesce - Block all commands except power management.
  *	@sdev:	scsi device to quiesce.
  *
  *	This works by trying to transition to the SDEV_QUIESCE state
  *	(which must be a legal transition).  When the device is in this
- *	state, only special requests will be accepted, all others will
- *	be deferred.  Since special requests may also be requeued requests,
- *	a successful return doesn't guarantee the device will be
- *	totally quiescent.
+ *	state, only power management requests will be accepted, all others will
+ *	be deferred.
  *
  *	Must be called with user context, may sleep.
  *
@@ -2558,12 +2559,12 @@ void scsi_device_resume(struct scsi_device *sdev)
 	 * device deleted during suspend)
 	 */
 	mutex_lock(&sdev->state_mutex);
+	if (sdev->sdev_state == SDEV_QUIESCE)
+		scsi_device_set_state(sdev, SDEV_RUNNING);
 	if (sdev->quiesced_by) {
 		sdev->quiesced_by = NULL;
 		blk_clear_pm_only(sdev->request_queue);
 	}
-	if (sdev->sdev_state == SDEV_QUIESCE)
-		scsi_device_set_state(sdev, SDEV_RUNNING);
 	mutex_unlock(&sdev->state_mutex);
 }
 EXPORT_SYMBOL(scsi_device_resume);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 9d2d5ad367a4..864f3b512d83 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -433,8 +433,8 @@ enum {
 	BLK_MQ_REQ_NOWAIT	= (__force blk_mq_req_flags_t)(1 << 0),
 	/* allocate from reserved pool */
 	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
-	/* set RQF_PREEMPT */
-	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
+	/* set RQF_PM */
+	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 3),
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bb5636cc17b9..909cb8b1d4ee 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -77,9 +77,6 @@ typedef __u32 __bitwise req_flags_t;
 #define RQF_MQ_INFLIGHT		((__force req_flags_t)(1 << 6))
 /* don't call prep for this one */
 #define RQF_DONTPREP		((__force req_flags_t)(1 << 7))
-/* set for "ide_preempt" requests and also for requests for which the SCSI
-   "quiesce" state must be ignored. */
-#define RQF_PREEMPT		((__force req_flags_t)(1 << 8))
 /* vaguely specified driver internal error.  Ignored by the block layer */
 #define RQF_FAILED		((__force req_flags_t)(1 << 10))
 /* don't warn about errors */
@@ -424,8 +421,7 @@ struct request_queue {
 	unsigned long		queue_flags;
 	/*
 	 * Number of contexts that have called blk_set_pm_only(). If this
-	 * counter is above zero then only RQF_PM and RQF_PREEMPT requests are
-	 * processed.
+	 * counter is above zero then only RQF_PM requests are processed.
 	 */
 	atomic_t		pm_only;
 
