Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B77C433F1
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77FD42073A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:54:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W1xAkgg5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgGUKyf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 06:54:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22644 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726942AbgGUKye (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 06:54:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595328873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R7PAK6mGU4s5P/JIBkrc14kuKjwtZGCYHATtOZzdKG0=;
        b=W1xAkgg5DL7qdqBBdzlzspLdsdKSwpL4byCsvwpiExC7dDTFyY9vWtidCRm/+f5OI1UqOd
        d84cbdhoJb2VGCsRi/bJDLV40lM07E+eRwIBiKma2qbjH8pGMTDXvhYOdT0o4Fj3qRCday
        mqfVLAyKDOg4/TSB8qLJz2fs4A9r0t4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-VDQQoSfTN4-IxGxUDewhHQ-1; Tue, 21 Jul 2020 06:54:29 -0400
X-MC-Unique: VDQQoSfTN4-IxGxUDewhHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76E051009600;
        Tue, 21 Jul 2020 10:54:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F7177621A;
        Tue, 21 Jul 2020 10:54:11 +0000 (UTC)
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
Subject: [PATCH 04/10] block: nbd: use blk_is_valid_logical_block_size
Date:   Tue, 21 Jul 2020 13:52:33 +0300
Message-Id: <20200721105239.8270-5-mlevitsk@redhat.com>
In-Reply-To: <20200721105239.8270-1-mlevitsk@redhat.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows to remove nbd's own check for valid block size

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/block/nbd.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index ce7e9f223b20b..2cd9c4e824f8b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1347,14 +1347,6 @@ static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
 		nbd_config_put(nbd);
 }
 
-static bool nbd_is_valid_blksize(unsigned long blksize)
-{
-	if (!blksize || !is_power_of_2(blksize) || blksize < 512 ||
-	    blksize > PAGE_SIZE)
-		return false;
-	return true;
-}
-
 static void nbd_set_cmd_timeout(struct nbd_device *nbd, u64 timeout)
 {
 	nbd->tag_set.timeout = timeout * HZ;
@@ -1379,7 +1371,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 	case NBD_SET_BLKSIZE:
 		if (!arg)
 			arg = NBD_DEF_BLKSIZE;
-		if (!nbd_is_valid_blksize(arg))
+		if (!blk_is_valid_logical_block_size(arg))
 			return -EINVAL;
 		nbd_size_set(nbd, arg,
 			     div_s64(config->bytesize, arg));
@@ -1811,7 +1803,7 @@ static int nbd_genl_size_set(struct genl_info *info, struct nbd_device *nbd)
 		bsize = nla_get_u64(info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]);
 		if (!bsize)
 			bsize = NBD_DEF_BLKSIZE;
-		if (!nbd_is_valid_blksize(bsize)) {
+		if (!blk_is_valid_logical_block_size(bsize)) {
 			printk(KERN_ERR "Invalid block size %llu\n", bsize);
 			return -EINVAL;
 		}
-- 
2.26.2

