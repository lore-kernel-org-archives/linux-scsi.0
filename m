Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFFDC11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 15:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA08C61427
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 15:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhGBPKe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 11:10:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32695 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231549AbhGBPKe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 11:10:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625238482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ht/Xd2ak4U7qujGuNG5CB2WgJF3xQrYQ/kFs9BMWdJM=;
        b=d9WrnU7M+u6UkshoI6gmwVbFjhfBIEL3tqkHLFqTKJ/efzYoZ/jwZu8veXHprPgG0gxAEn
        N9FhUpCAuSHs8SiCpqpaHBc1Sa66gO8/DdTI+Va8GMWTgskRC4c5brrEizOpy1XrRwzlvc
        xCDO8n0eGnpKG3DnJJcHyGsaviagOEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-0sK1XWEVPYyQXhMVfg5jwg-1; Fri, 02 Jul 2021 11:08:00 -0400
X-MC-Unique: 0sK1XWEVPYyQXhMVfg5jwg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F3F0100C612;
        Fri,  2 Jul 2021 15:07:59 +0000 (UTC)
Received: from localhost (ovpn-12-40.pek2.redhat.com [10.72.12.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3623960853;
        Fri,  2 Jul 2021 15:07:53 +0000 (UTC)
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
Subject: [PATCH V2 3/6] scsi: add flag of .use_managed_irq to 'struct Scsi_Host'
Date:   Fri,  2 Jul 2021 23:05:52 +0800
Message-Id: <20210702150555.2401722-4-ming.lei@redhat.com>
In-Reply-To: <20210702150555.2401722-1-ming.lei@redhat.com>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk-mq needs this information of using managed irq for improving
deactivating hctx, so add such flag to 'struct Scsi_Host', then
drivers can pass such flag to blk-mq via scsi_mq_setup_tags().

The rule is that driver has to tell blk-mq if managed irq is used.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c  | 12 +++++++-----
 include/scsi/scsi_host.h |  3 +++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 532304d42f00..743df8e824b9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1915,6 +1915,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size;
 	struct blk_mq_tag_set *tag_set = &shost->tag_set;
+	unsigned long flags = BLK_MQ_F_SHOULD_MERGE |
+		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 
 	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
 				scsi_mq_inline_sgl_size(shost));
@@ -1933,12 +1935,12 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	tag_set->queue_depth = shost->can_queue;
 	tag_set->cmd_size = cmd_size;
 	tag_set->numa_node = NUMA_NO_NODE;
-	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
-	tag_set->flags |=
-		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
-	tag_set->driver_data = shost;
 	if (shost->host_tagset)
-		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
+		flags |= BLK_MQ_F_TAG_HCTX_SHARED;
+	if (shost->use_managed_irq)
+		flags |= BLK_MQ_F_MANAGED_IRQ;
+	tag_set->flags = flags;
+	tag_set->driver_data = shost;
 
 	return blk_mq_alloc_tag_set(tag_set);
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d0bf88d77f02..3ac589ae9592 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -657,6 +657,9 @@ struct Scsi_Host {
 	/* True if the host uses host-wide tagspace */
 	unsigned host_tagset:1;
 
+	/* True if the host uses managed irq */
+	unsigned use_managed_irq:1;
+
 	/* Host responded with short (<36 bytes) INQUIRY result */
 	unsigned short_inquiry:1;
 
-- 
2.31.1

