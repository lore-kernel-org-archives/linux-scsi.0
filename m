Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A44C433F8
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B1A2073A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D/wdza+A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgGUKzG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 06:55:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46560 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728028AbgGUKzF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jul 2020 06:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595328904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgMI0PUysaqC29ZhpllDxU2MZgp5OTSppOCpTSOb14s=;
        b=D/wdza+AVIj8gJlc3gELCshQS92ZfLEv56cJfXrhdF4trp6rH740vZ5aJkW57wHji2bFC5
        sSe6accOtICRnRYKpporTwSM4N5vf9CbsdKHwLUFXelhPjTxm+lyHw4bNiLt5Cea+gT+cs
        DQoWcXCDIMxLybXQblxZnxvK/f9k7wA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-aJsSQekbMPSFFHYbUkQrHg-1; Tue, 21 Jul 2020 06:55:03 -0400
X-MC-Unique: aJsSQekbMPSFFHYbUkQrHg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF672107ACCA;
        Tue, 21 Jul 2020 10:54:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23A671C4;
        Tue, 21 Jul 2020 10:54:49 +0000 (UTC)
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
Subject: [PATCH 07/10] block: mspro_blk: use blk_is_valid_logical_block_size
Date:   Tue, 21 Jul 2020 13:52:36 +0300
Message-Id: <20200721105239.8270-8-mlevitsk@redhat.com>
In-Reply-To: <20200721105239.8270-1-mlevitsk@redhat.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/memstick/core/mspro_block.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index cd6b8d4f23350..86c9eb0aef512 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1199,6 +1199,12 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
+	if (!(blk_is_valid_logical_block_size(msb->page_size))) {
+		dev_warn(&card->dev,
+			 "unsupported block size %d", msb->page_size);
+		return -EINVAL;
+	}
+
 	mutex_lock(&mspro_block_disk_lock);
 	disk_id = idr_alloc(&mspro_block_disk_idr, card, 0, 256, GFP_KERNEL);
 	mutex_unlock(&mspro_block_disk_lock);
-- 
2.26.2

