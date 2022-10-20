Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5846C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 09:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiJTJKw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 05:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiJTJKs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 05:10:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F20518196A
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 02:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666257045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=6+CtSbpb8TXPeuZhxpRWK/BpD94ovFhE0lP0MjSv61M=;
        b=OVGyb65/dFj6GzlYWYXzQOJxV7jbgXkNUTDLS6V1BvungAYWBw4cEGGXWC1uDYK1bPbRB7
        9La0ovZqgmNv9HICs8Np2q/qhJOgfK/m+912xtPkWq47m3iahVv4mFY26bkSe7H+ojEAHP
        xUv1MdHqCA4fsVz8W2CNyKT9JIn7czQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-X3_1_fH6N6uHI1xTV2JJjA-1; Thu, 20 Oct 2022 05:10:42 -0400
X-MC-Unique: X3_1_fH6N6uHI1xTV2JJjA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 192C129324B0;
        Thu, 20 Oct 2022 09:10:36 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AC1E40C6EC2;
        Thu, 20 Oct 2022 09:10:19 +0000 (UTC)
Date:   Thu, 20 Oct 2022 17:10:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>, djeffery@redhat.com,
        stefanha@redhat.com
Cc:     ming.lei@redhat.com, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [Bug] double ->queue_rq() because of timeout in ->queue_rq()
Message-ID: <Y1EQdafQlKNAsutk@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

David Jeffery found one double ->queue_rq() issue, so far it can
be triggered in the following two cases:

1) scsi driver in guest kernel

- the story could be long vmexit latency or long preempt latency of
vCPU pthread, then IO req is timed out before queuing the request
to hardware but after calling blk_mq_start_request() during ->queue_rq(),
then timeout handler handles it by requeue, then double ->queue_rq() is
caused, and kernel panic

2) burst of kernel messages from irq handler 

For 1), I think it is one reasonable case, given latency from host side
can come anytime in theory because vCPU is emulated by one normal host
pthread which can be preempted anywhere. For 2), I guess kernel message is
supposed to be rate limited.

Firstly, is this kind of so long(30sec) random latency when running kernel
code something normal? Or do we need to take care of it? IMO, it looks
reasonable in case of VM, but our VM experts may have better idea about this
situation. Also the default 30sec timeout could be reduced via sysfs or
drivers.

Suppose it is one reasonable report to fix, what is the preferred solution?

So far, it is driver's responsibility to cover the race between timeout
and completion, so it is supposed to be solved in driver in theory, given
driver has enough knowledge.

But it is really one common problem, lots of driver could have similar
issue, and could be hard to fix all affected drivers, so David suggests
the following patch by draining in-progress ->queue_rq() for this issue.
And the patch looks reasonable too.

Any comments for this issue and the solution?


diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8070b6c10e8d..ca57c060bb65 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1523,7 +1523,12 @@ static void blk_mq_rq_timed_out(struct request *req)
 	blk_add_timer(req);
 }
 
-static bool blk_mq_req_expired(struct request *rq, unsigned long *next)
+struct blk_expired_data {
+	unsigned long next;
+	unsigned long now;
+};
+
+static bool blk_mq_req_expired(struct request *rq, struct blk_expired_data *expired)
 {
 	unsigned long deadline;
 
@@ -1533,13 +1538,13 @@ static bool blk_mq_req_expired(struct request *rq, unsigned long *next)
 		return false;
 
 	deadline = READ_ONCE(rq->deadline);
-	if (time_after_eq(jiffies, deadline))
+	if (time_after_eq(expired->now, deadline))
 		return true;
 
-	if (*next == 0)
-		*next = deadline;
-	else if (time_after(*next, deadline))
-		*next = deadline;
+	if (expired->next == 0)
+		expired->next = deadline;
+	else if (time_after(expired->next, deadline))
+		expired->next = deadline;
 	return false;
 }
 
@@ -1555,7 +1560,7 @@ void blk_mq_put_rq_ref(struct request *rq)
 
 static bool blk_mq_check_expired(struct request *rq, void *priv)
 {
-	unsigned long *next = priv;
+	struct blk_expired_data *expired = priv;
 
 	/*
 	 * blk_mq_queue_tag_busy_iter() has locked the request, so it cannot
@@ -1564,7 +1569,7 @@ static bool blk_mq_check_expired(struct request *rq, void *priv)
 	 * it was completed and reallocated as a new request after returning
 	 * from blk_mq_check_expired().
 	 */
-	if (blk_mq_req_expired(rq, next))
+	if (blk_mq_req_expired(rq, expired))
 		blk_mq_rq_timed_out(rq);
 	return true;
 }
@@ -1573,7 +1578,7 @@ static void blk_mq_timeout_work(struct work_struct *work)
 {
 	struct request_queue *q =
 		container_of(work, struct request_queue, timeout_work);
-	unsigned long next = 0;
+	struct blk_expired_data expired = {.next = 0, .now = jiffies};
 	struct blk_mq_hw_ctx *hctx;
 	unsigned long i;
 
@@ -1593,10 +1598,17 @@ static void blk_mq_timeout_work(struct work_struct *work)
 	if (!percpu_ref_tryget(&q->q_usage_counter))
 		return;
 
-	blk_mq_queue_tag_busy_iter(q, blk_mq_check_expired, &next);
+	/* Before walking tags, we must ensure any submit started before the
+	 * current time has finished. Since the submit uses srcu or rcu, wait
+	 * for a synchronization point to ensure all running submits have
+	 * finished
+	 */
+	blk_mq_wait_quiesce_done(q);
+
+	blk_mq_queue_tag_busy_iter(q, blk_mq_check_expired, &expired);
 
-	if (next != 0) {
-		mod_timer(&q->timeout, next);
+	if (expired.next != 0) {
+		mod_timer(&q->timeout, expired.next);
 	} else {
 		/*
 		 * Request timeouts are handled as a forward rolling timer. If



Thanks, 
Ming

