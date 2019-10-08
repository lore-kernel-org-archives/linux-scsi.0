Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2849BC10F14
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 10:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0164120673
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 10:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbfJHKKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 06:10:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730106AbfJHKKJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Oct 2019 06:10:09 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EFAF251EF1;
        Tue,  8 Oct 2019 10:10:08 +0000 (UTC)
Received: from localhost (ovpn-8-31.pek2.redhat.com [10.72.8.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46D9C5C219;
        Tue,  8 Oct 2019 10:10:02 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [RFC PATCH V3 2/2] scsi: core: don't limit per-LUN queue depth for SSD
Date:   Tue,  8 Oct 2019 18:09:45 +0800
Message-Id: <20191008100945.24951-3-ming.lei@redhat.com>
In-Reply-To: <20191008100945.24951-1-ming.lei@redhat.com>
References: <20191008100945.24951-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 08 Oct 2019 10:10:09 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI core uses the atomic variable of sdev->device_busy to track
in-flight IO requests dispatched to this scsi device. IO request may be
submitted from any CPU, so the cost for maintaining the shared atomic
counter can be very big on big NUMA machine with lots of CPU cores.

sdev->queue_depth is usually used for two purposes: 1) improve IO merge;
2) fair IO request scattered among all LUNs.

blk-mq already provides fair request allocation among all active shared
request queues(LUNs), see hctx_may_queue().

NVMe doesn't have such per-request-queue(namespace) queue depth, so it
is reasonable to ignore the limit for SCSI SSD too. Also IO merge won't
play big role for reaching top SSD performance.

With this patch, big cost for tracking in-flight per-LUN requests via
atomic variable can be saved.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Omar Sandoval <osandov@fb.com>,
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b6f66dcb15a5..0f8e7a522060 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -354,7 +354,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
 
-	atomic_dec(&sdev->device_busy);
+	if (!blk_queue_nonrot(sdev->request_queue))
+		atomic_dec(&sdev->device_busy);
 }
 
 static void scsi_kick_queue(struct request_queue *q)
@@ -410,7 +411,8 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 
 static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 {
-	if (atomic_read(&sdev->device_busy) >= sdev->queue_depth)
+	if (!blk_queue_nonrot(sdev->request_queue) &&
+			atomic_read(&sdev->device_busy) >= sdev->queue_depth)
 		return true;
 	if (atomic_read(&sdev->device_blocked) > 0)
 		return true;
@@ -1283,8 +1285,10 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 				  struct scsi_device *sdev)
 {
 	unsigned int busy;
+	bool bypass = blk_queue_nonrot(sdev->request_queue);
 
-	busy = atomic_inc_return(&sdev->device_busy) - 1;
+	if (!bypass)
+		busy = atomic_inc_return(&sdev->device_busy) - 1;
 	if (atomic_read(&sdev->device_blocked)) {
 		if (busy)
 			goto out_dec;
@@ -1298,12 +1302,16 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 				   "unblocking device at zero depth\n"));
 	}
 
+	if (bypass)
+		return 1;
+
 	if (busy >= sdev->queue_depth)
 		goto out_dec;
 
 	return 1;
 out_dec:
-	atomic_dec(&sdev->device_busy);
+	if (!bypass)
+		atomic_dec(&sdev->device_busy);
 	return 0;
 }
 
@@ -1624,7 +1632,8 @@ static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
 	struct request_queue *q = hctx->queue;
 	struct scsi_device *sdev = q->queuedata;
 
-	atomic_dec(&sdev->device_busy);
+	if (!blk_queue_nonrot(sdev->request_queue))
+		atomic_dec(&sdev->device_busy);
 }
 
 static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
@@ -1706,7 +1715,8 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-		if (atomic_read(&sdev->device_busy) ||
+		if ((!blk_queue_nonrot(sdev->request_queue) &&
+		     atomic_read(&sdev->device_busy)) ||
 		    scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
-- 
2.20.1

