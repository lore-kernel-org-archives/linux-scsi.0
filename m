Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F528C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C4620855
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I4xsY11y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgIJHvi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 03:51:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58631 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726676AbgIJHve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 03:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599724292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TFaZi1Msx1a0v+B/sKaQJEr7nC8zBB8mNKNk26nsde8=;
        b=I4xsY11yErSeOSB3jMxsT70scR0pOnrTYN+2BPp2CtuYAGxgWy+r0W85x0RcPz7L5MEywC
        oI/+KTdQyj6CkTAaBmWlXpPXJwmq+mRkwSiW6wAnoArJLrxlfz2h59Vz/w+S1Lr8PjWIqH
        qjxH7oWGuoEaE0G+tLYQgM/nfom2+VI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-cK6uyv9WPhyD_Hvfn12uAQ-1; Thu, 10 Sep 2020 03:51:28 -0400
X-MC-Unique: cK6uyv9WPhyD_Hvfn12uAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6636B801F98;
        Thu, 10 Sep 2020 07:51:27 +0000 (UTC)
Received: from localhost (ovpn-12-146.pek2.redhat.com [10.72.12.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7BCD5C1CF;
        Thu, 10 Sep 2020 07:51:22 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Long Li <longli@microsoft.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH V7] scsi: core: only re-run queue in scsi_end_request() if device queue is busy
Date:   Thu, 10 Sep 2020 15:50:56 +0800
Message-Id: <20200910075056.36509-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now the request queue is run in scsi_end_request() unconditionally if both
target queue and host queue is ready. We should have re-run request queue
only after this device queue becomes busy for restarting this LUN only.

Recently Long Li reported that cost of run queue may be very heavy in
case of high queue depth. So improve this situation by only running
the request queue when this LUN is busy.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Tested-by: Long Li <longli@microsoft.com>
Reported-by: Long Li <longli@microsoft.com>
Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V7:
        - patch style && comment change, as suggested by Bart
        - add reviewed-by tag
V6:
        - patch style && comment change, as suggested by Bart
        - add reviewed-by & tested-by tag
V5:
   	- patch style && comment change, as suggested by Bart
        - add reviewed-by & tested-by tag
V4:
        - fix one race reported by Kashyap, and simplify the implementation
        a bit; also pass Kashyap's both function and performance test
V3:
        - add one smp_mb() in scsi_mq_get_budget() and comment
V2:
        - commit log change, no any code change
        - add reported-by tag


 drivers/scsi/scsi_lib.c    | 48 ++++++++++++++++++++++++++++++++++----
 include/scsi/scsi_device.h |  1 +
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7affaaf8b98e..4fb624744ae6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -549,10 +549,27 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 static void scsi_run_queue_async(struct scsi_device *sdev)
 {
 	if (scsi_target(sdev)->single_lun ||
-	    !list_empty(&sdev->host->starved_list))
+	    !list_empty(&sdev->host->starved_list)) {
 		kblockd_schedule_work(&sdev->requeue_work);
-	else
-		blk_mq_run_hw_queues(sdev->request_queue, true);
+	} else {
+		/*
+		 * smp_mb() present in sbitmap_queue_clear() or implied in
+		 * .end_io is for ordering writing .device_busy in
+		 * scsi_device_unbusy() and reading sdev->restarts.
+		 */
+		int old = atomic_read(&sdev->restarts);
+
+		/*
+		 * ->restarts has to be kept as non-zero if new budget
+		 *  contention comes.
+		 *
+		 *  No need to run queue when either another re-run
+		 *  queue wins in updating ->restarts or one new budget
+		 *  contention comes.
+		 */
+		if (old && atomic_cmpxchg(&sdev->restarts, old, 0) == old)
+			blk_mq_run_hw_queues(sdev->request_queue, true);
+	}
 }
 
 /* Returns false when no more bytes to process, true if there are more */
@@ -1612,7 +1629,30 @@ static bool scsi_mq_get_budget(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 
-	return scsi_dev_queue_ready(q, sdev);
+	if (scsi_dev_queue_ready(q, sdev))
+		return true;
+
+	atomic_inc(&sdev->restarts);
+
+	/*
+	 * Orders atomic_inc(&sdev->restarts) and atomic_read(&sdev->device_busy).
+	 * .restarts must be incremented before .device_busy is read because the
+	 * code in scsi_run_queue_async() depends on the order of these operations.
+	 */
+	smp_mb__after_atomic();
+
+	/*
+	 * If all in-flight requests originated from this LUN are completed
+	 * before reading .device_busy, sdev->device_busy will be observed as
+	 * zero, then blk_mq_delay_run_hw_queues() will dispatch this request
+	 * soon. Otherwise, completion of one of these request will observe
+	 * the .restarts flag, and the request queue will be run for handling
+	 * this request, see scsi_end_request().
+	 */
+	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
+				!scsi_device_blocked(sdev)))
+		blk_mq_delay_run_hw_queues(sdev->request_queue, SCSI_QUEUE_DELAY);
+	return false;
 }
 
 static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bc5909033d13..1a5c9a3df6d6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -109,6 +109,7 @@ struct scsi_device {
 	atomic_t device_busy;		/* commands actually active on LLDD */
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
 
+	atomic_t restarts;
 	spinlock_t list_lock;
 	struct list_head starved_entry;
 	unsigned short queue_depth;	/* How deep of a queue we want */
-- 
2.25.2

