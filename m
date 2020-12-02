Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F82CC64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 10:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B54E22203
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 10:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388122AbgLBKGD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:06:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728118AbgLBKGC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 05:06:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606903476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NddWbL3iw/gQzLMebZ3zSWl7XRTb2Z+lkIWnSvOPPuA=;
        b=FwijM2uwNYFXK/nzkiC4Y0Ou7ElusthD6l6RLAGa7xsv2x5K4/XgQRAM6WXuyDgyXnbBl9
        1fgKvlN7+jjGtnRmrEY0fwIxKH7bqQ7qIXfhjwo6sqmagRnH6ieNmdVLrSGI1wROYMXrgh
        WAAcXpd+Zifoy5AEKRm+wGedInoy9o8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-LqzsIg6mODih0ShqtuFDmQ-1; Wed, 02 Dec 2020 05:04:32 -0500
X-MC-Unique: LqzsIg6mODih0ShqtuFDmQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4C0C1005D7E;
        Wed,  2 Dec 2020 10:04:30 +0000 (UTC)
Received: from localhost (ovpn-13-72.pek2.redhat.com [10.72.13.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B471460854;
        Wed,  2 Dec 2020 10:04:26 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: core: fix race between handling STS_RESOURCE and completion
Date:   Wed,  2 Dec 2020 18:04:19 +0800
Message-Id: <20201202100419.525144-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When queuing IO request to LLD, STS_RESOURCE may be returned because:

- host in recovery or blocked
- target queue throttling or blocked
- LLD rejection

Any one of the above doesn't happen frequently enough.

BLK_STS_DEV_RESOURCE is returned to block layer for avoiding unnecessary
re-run queue, and it is just one small optimization. However, all
in-flight requests originated from this scsi device may be completed
just after reading 'sdev->device_busy', so BLK_STS_DEV_RESOURCE is
returned to block layer. And the current failed IO won't get chance
to be queued any more, since it is invisible at that time for either
scsi_run_queue_async() or blk-mq's RESTART.

Fix the issue by not returning BLK_STS_DEV_RESOURCE in this situation.

Cc: Hannes Reinecke <hare@suse.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Ewan Milne <emilne@redhat.com>
Cc: Long Li <longli@microsoft.com>
Tested-by: "chenxiang (M)" <chenxiang66@hisilicon.com>
Reported-by: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 60c7a7d74852..03c6d0620bfd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1703,8 +1703,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		break;
 	case BLK_STS_RESOURCE:
 	case BLK_STS_ZONE_RESOURCE:
-		if (atomic_read(&sdev->device_busy) ||
-		    scsi_device_blocked(sdev))
+		if (scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
 	default:
-- 
2.28.0

