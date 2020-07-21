Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FC6C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446EB2073A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zw1rn9gF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgGUKyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 06:54:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52078 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729424AbgGUKym (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 06:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595328881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oFWGludvELnToYPGkXRL/IpOnO2KtH2SYm6kXUDscgk=;
        b=Zw1rn9gFFjSwXbe25rlBu8wrt7VHVMoKDznyt8EYIR869u/ypvh42oGonMK/bBFgGudcg/
        WacEFGNf370Ig/yb+rHZ/BPDYZ4ozyFknv194j64C0W69Und+9LFWEI+XNFq6KI4uzb3Sw
        goXmz5qDovY72e+YqaTDmv2BtKGsQnQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-PjdjcO50NH2_x-dheKbKbA-1; Tue, 21 Jul 2020 06:54:39 -0400
X-MC-Unique: PjdjcO50NH2_x-dheKbKbA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A06CF193F562;
        Tue, 21 Jul 2020 10:54:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D88637621A;
        Tue, 21 Jul 2020 10:54:26 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-block@vger.kernel.org (open list:BLOCK LAYER),
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org (open list:NVM EXPRESS DRIVER),
        linux-scsi@vger.kernel.org (open list:SCSI CDROM DRIVER),
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        linux-mmc@vger.kernel.org (open list:SONY MEMORYSTICK SUBSYSTEM),
        Christoph Hellwig <hch@lst.de>,
        Satya Tangirala <satyat@google.com>,
        nbd@other.debian.org (open list:NETWORK BLOCK DEVICE (NBD)),
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        virtualization@lists.linux-foundation.org (open list:VIRTIO CORE AND
        NET DRIVERS), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 05/10] block: null: use blk_is_valid_logical_block_size
Date:   Tue, 21 Jul 2020 13:52:34 +0300
Message-Id: <20200721105239.8270-6-mlevitsk@redhat.com>
In-Reply-To: <20200721105239.8270-1-mlevitsk@redhat.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This slightly changes the behavier of the driver,
when given invalid block size (non power of two, or below 512 bytes),
but shoudn't matter.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/block/null_blk_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 87b31f9ca362e..e4df4b903b90b 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1684,8 +1684,8 @@ static int null_init_tag_set(struct nullb *nullb, struct blk_mq_tag_set *set)
 
 static int null_validate_conf(struct nullb_device *dev)
 {
-	dev->blocksize = round_down(dev->blocksize, 512);
-	dev->blocksize = clamp_t(unsigned int, dev->blocksize, 512, 4096);
+	if (!blk_is_valid_logical_block_size(dev->blocksize))
+		return -ENODEV;
 
 	if (dev->queue_mode == NULL_Q_MQ && dev->use_per_node_hctx) {
 		if (dev->submit_queues != nr_online_nodes)
@@ -1865,7 +1865,7 @@ static int __init null_init(void)
 	struct nullb *nullb;
 	struct nullb_device *dev;
 
-	if (g_bs > PAGE_SIZE) {
+	if (!blk_is_valid_logical_block_size(g_bs)) {
 		pr_warn("invalid block size\n");
 		pr_warn("defaults block size to %lu\n", PAGE_SIZE);
 		g_bs = PAGE_SIZE;
-- 
2.26.2

