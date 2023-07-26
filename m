Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1729BC41513
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 09:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjGZJla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 05:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbjGZJl2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 05:41:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C531ADD
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 02:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690364447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k/XiItvuETzuFaV0q2/0Ml9SkHL0l2Lbxykjfon98Ww=;
        b=I+71LlkX1PeTN5NCxjhMTZ3OEBN5VKxOngUb8bTghTMqVC5PymCMPNpoj3EEx+Ei4MufYr
        6rroml47er/zPtHQDvoMJCtThVoeWheQC+wBNw6XGxAoS+n1jJlU26ntLKBrHwadT31Fpt
        ktzOBDLbB0Ix2U31DSoyT2TFAkwH0LY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-Ad3sbx7uMbeI3W7dnB5SwQ-1; Wed, 26 Jul 2023 05:40:43 -0400
X-MC-Unique: Ad3sbx7uMbeI3W7dnB5SwQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B3F4803FDF;
        Wed, 26 Jul 2023 09:40:43 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C6F3F7835;
        Wed, 26 Jul 2023 09:40:42 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 2/9] nvme-pci: use blk_mq_max_nr_hw_queues() to calculate io queues
Date:   Wed, 26 Jul 2023 17:40:20 +0800
Message-Id: <20230726094027.535126-3-ming.lei@redhat.com>
In-Reply-To: <20230726094027.535126-1-ming.lei@redhat.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

Reported-by: Wen Xiong <wenxiong@linux.ibm.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index baf69af7ea78..a1227ae7eb39 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2251,7 +2251,7 @@ static unsigned int nvme_max_io_queues(struct nvme_dev *dev)
 	 */
 	if (dev->ctrl.quirks & NVME_QUIRK_SHARED_TAGS)
 		return 1;
-	return num_possible_cpus() + dev->nr_write_queues + dev->nr_poll_queues;
+	return blk_mq_max_nr_hw_queues() + dev->nr_write_queues + dev->nr_poll_queues;
 }
 
 static int nvme_setup_io_queues(struct nvme_dev *dev)
-- 
2.40.1

