Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C12C001B0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 16:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjHHQCX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 12:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjHHQAC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 12:00:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D443361A1
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 08:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691509431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvKrmms9fUHhxbhcGxDz7QDKl8B/hBW7QeIiIj8phvY=;
        b=I5Vbo+dRF6pfjn4rv7LSpNp4qyADSJQ3WotjfVmVyL4FQ112CWx8RCjnmrBuh61DRofa/U
        KoIVD+TwPyKeTagHc/bqvGe57rBja6nJNboRtH4xI5G8n07sb79TUcFJSLLhiiT8dHgFo7
        /SnPSVNzPzQa3keQHSOpPJapplyZw3U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-xZnrD3mGMTGBaneeBOzJFQ-1; Tue, 08 Aug 2023 06:42:52 -0400
X-MC-Unique: xZnrD3mGMTGBaneeBOzJFQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 955AC800270;
        Tue,  8 Aug 2023 10:42:51 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAD5A2026D4B;
        Tue,  8 Aug 2023 10:42:50 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 01/14] blk-mq: add blk_mq_max_nr_hw_queues()
Date:   Tue,  8 Aug 2023 18:42:26 +0800
Message-Id: <20230808104239.146085-2-ming.lei@redhat.com>
In-Reply-To: <20230808104239.146085-1-ming.lei@redhat.com>
References: <20230808104239.146085-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_mq_alloc_tag_set() may override set->nr_hw_queues as 1 in case of kdump
kernel. This way causes trouble for driver, because blk-mq and driver see
different queue mapping. Especially the only online CPU may not be 1 for
kdump kernel, in which 'maxcpus=1' is passed from kernel command line,
then driver may map hctx0 into one inactive real hw queue which cpu
affinity is 0(offline).

The issue exists on all drivers which use managed irq and support
multiple hw queue.

Prepare for fixing this kind of issue by applying the added helper, so
driver can take blk-mq max nr_hw_queues knowledge into account when
calculating io queues.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c         | 16 ++++++++++++++++
 include/linux/blk-mq.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b04ff6f56926..617d6f849a7b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -140,6 +140,22 @@ void blk_mq_freeze_queue_wait(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait);
 
+/*
+ * Return the max supported nr_hw_queues for each hw queue type
+ *
+ * blk_mq_alloc_tag_set() may change nr_hw_queues for kdump kernel, so
+ * driver has to take blk-mq max supported nr_hw_queues into account
+ * when figuring out nr_hw_queues from hardware info, for avoiding
+ * inconsistency between driver and blk-mq.
+ */
+unsigned int blk_mq_max_nr_hw_queues(void)
+{
+	if (is_kdump_kernel())
+		return 1;
+	return nr_cpu_ids;
+}
+EXPORT_SYMBOL_GPL(blk_mq_max_nr_hw_queues);
+
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 495ca198775f..4c0cfd1f9e52 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -711,6 +711,7 @@ int blk_mq_alloc_sq_tag_set(struct blk_mq_tag_set *set,
 		const struct blk_mq_ops *ops, unsigned int queue_depth,
 		unsigned int set_flags);
 void blk_mq_free_tag_set(struct blk_mq_tag_set *set);
+unsigned int blk_mq_max_nr_hw_queues(void);
 
 void blk_mq_free_request(struct request *rq);
 int blk_rq_poll(struct request *rq, struct io_comp_batch *iob,
-- 
2.40.1

