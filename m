Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253EDC43460
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 07:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7B1613C7
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 07:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347855AbhDNHvQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 03:51:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232528AbhDNHvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 03:51:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618386654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Ef1Sgck7C7ei8wcm3LP4xa8AJido8YxLjfgnN0FEIhE=;
        b=LWXXiKKrupFIE3kNKyq+3/hoDnOLJ3TLGAyhh0G+u941SwjvoMRHg04+YNtKQ0jxRBjRwG
        MOH4q+g3rdSj9SLB2yN0MtQLom0va37RzjjXlovhrLUqmoTfUL0eLkVbbdw+buPdvS7Ws9
        ImaoW9JiB4lxY18SqBwwzkdMXcc5pDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-1_ACkP7UNYK5jny4Q3nhCg-1; Wed, 14 Apr 2021 03:50:52 -0400
X-MC-Unique: 1_ACkP7UNYK5jny4Q3nhCg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FBD719251A2;
        Wed, 14 Apr 2021 07:50:51 +0000 (UTC)
Received: from T590 (ovpn-13-221.pek2.redhat.com [10.72.13.221])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15B6D51DCB;
        Wed, 14 Apr 2021 07:50:43 +0000 (UTC)
Date:   Wed, 14 Apr 2021 15:50:39 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     ming.lei@redhat.com, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YHaez6iN2HHYxYOh@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,

It is reported inside RH that CPU utilization is increased ~20% when
running simple FIO test inside VM which disk is built on image stored
on XFS/megaraid_sas.

When I try to investigate by reproducing the issue via scsi_debug, I found
IO hang when running randread IO(8k, direct IO, libaio) on scsi_debug disk
created by the following command:

	modprobe scsi_debug host_max_queue=128 submit_queues=$NR_CPUS virtual_gb=256

Looks it is caused by SCHED_RESTART because current RESTART is just done
on current hctx, and we may need to restart all hctxs for shared tags, and the
issue can be fixed by the append patch. However, IOPS drops more than 10% with
the patch.

So any idea for this issue and the original performance drop?

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index e1e997af89a0..45188f7aa789 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -59,10 +59,18 @@ EXPORT_SYMBOL_GPL(blk_mq_sched_mark_restart_hctx);
 
 void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
 {
+	bool shared_tag = blk_mq_is_sbitmap_shared(hctx->flags);
+
+	if (shared_tag)
+		blk_mq_run_hw_queues(hctx->queue, true);
+
 	if (!test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
 		return;
 	clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
 
+	if (shared_tag)
+		return;
+
 	/*
 	 * Order clearing SCHED_RESTART and list_empty_careful(&hctx->dispatch)
 	 * in blk_mq_run_hw_queue(). Its pair is the barrier in

Thanks, 
Ming

