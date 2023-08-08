Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC00C001B0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 16:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjHHQJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 12:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjHHQIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 12:08:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB7F768C
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 08:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691509537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9SdkdgSqxhMyRTJ5vgJIEJL/WyHf61DHGM5o0eLsF7g=;
        b=YvBnxhU36CDOYSBOQdHgbNyuImwUNI/+w1WgH6QxdoBLgmmamS2iKcVn/YWOkhWckxJ4ow
        TMBoEEg9Ka2qVqB8sI9avPYEUxfP9v5xsUfdNLyvPZMBz5ExD3YtsNsw0tMJhTc/SNAbD9
        ydkT73ihHjhxuDCgn7KNZCreeYbpzjQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-HN97ZHsCP7utxVyyzgqj-Q-1; Tue, 08 Aug 2023 06:42:59 -0400
X-MC-Unique: HN97ZHsCP7utxVyyzgqj-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EAA6185A78B;
        Tue,  8 Aug 2023 10:42:58 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A81182166B27;
        Tue,  8 Aug 2023 10:42:57 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 03/14] ublk: limit max allowed nr_hw_queues
Date:   Tue,  8 Aug 2023 18:42:28 +0800
Message-Id: <20230808104239.146085-4-ming.lei@redhat.com>
In-Reply-To: <20230808104239.146085-1-ming.lei@redhat.com>
References: <20230808104239.146085-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Take blk-mq's knowledge into account for calculating io queues.

Fix wrong queue mapping in case of kdump kernel.

On arm and ppc64, 'maxcpus=1' is passed to kdump command line, see
`Documentation/admin-guide/kdump/kdump.rst`, so num_possible_cpus()
still returns all CPUs because 'maxcpus=1' just bring up one single
cpu core during booting.

blk-mq sees single queue in kdump kernel, and in driver's viewpoint
there are still multiple queues, this inconsistency causes driver to apply
wrong queue mapping for handling IO, and IO timeout is triggered.

Meantime, single queue makes much less resource utilization, and reduce
risk of kernel failure.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 21d2e71c5514..6cf4981951e2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2045,7 +2045,7 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	ub->dev_info.flags &= ~UBLK_F_SUPPORT_ZERO_COPY;
 
 	ub->dev_info.nr_hw_queues = min_t(unsigned int,
-			ub->dev_info.nr_hw_queues, nr_cpu_ids);
+			ub->dev_info.nr_hw_queues, blk_mq_max_nr_hw_queues());
 	ublk_align_max_io_size(ub);
 
 	ret = ublk_init_queues(ub);
-- 
2.40.1

