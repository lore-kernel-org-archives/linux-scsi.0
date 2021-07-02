Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5C3C11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 15:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FFCF61423
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 15:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhGBPKN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 11:10:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232171AbhGBPKN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 11:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625238460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9znRiot0Er4LvorWe0Rext34xrr/1zUg0AXQOCMp828=;
        b=jWW6nO7RejfFOVM0ygxYf0iVQEbb3llXhmoF+t9M6ZD+QzlBb+kzWnPksqI6nFbM9brNsI
        oSceWlLj1WxHAPgqaZGoT64dagDOynoBkEUcy3ygZ31ejlF5G/KqCGMw9ZLaQ42YoxothF
        vWYcJXcE/xwMKTHi8SWrAm49Jd0Ys4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-_w1dB6tLNYuFttS27tWrhw-1; Fri, 02 Jul 2021 11:07:39 -0400
X-MC-Unique: _w1dB6tLNYuFttS27tWrhw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3615310C1ADC;
        Fri,  2 Jul 2021 15:07:37 +0000 (UTC)
Received: from localhost (ovpn-12-40.pek2.redhat.com [10.72.12.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B33BC10016F7;
        Fri,  2 Jul 2021 15:07:27 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 2/6] nvme: pci: pass BLK_MQ_F_MANAGED_IRQ to blk-mq
Date:   Fri,  2 Jul 2021 23:05:51 +0800
Message-Id: <20210702150555.2401722-3-ming.lei@redhat.com>
In-Reply-To: <20210702150555.2401722-1-ming.lei@redhat.com>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk-mq needs to know if the controller allocates managed irq vectors or
not, so pass the info to blk-mq.

The rule is that driver has to tell blk-mq if managed irq is used.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d3c5086673bc..093c56e1428e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2317,7 +2317,8 @@ static void nvme_dev_add(struct nvme_dev *dev)
 		dev->tagset.queue_depth = min_t(unsigned int, dev->q_depth,
 						BLK_MQ_MAX_DEPTH) - 1;
 		dev->tagset.cmd_size = sizeof(struct nvme_iod);
-		dev->tagset.flags = BLK_MQ_F_SHOULD_MERGE;
+		dev->tagset.flags = BLK_MQ_F_SHOULD_MERGE |
+			BLK_MQ_F_MANAGED_IRQ;
 		dev->tagset.driver_data = dev;
 
 		/*
-- 
2.31.1

