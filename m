Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7167FC61DD8
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 08:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 115AA20795
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 08:29:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vJB9c0uf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgKKI3h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 03:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgKKI1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 03:27:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F3EC061A04;
        Wed, 11 Nov 2020 00:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=DxpFRHQFxTQEJeN4GgGJQ0kD3jbey5oDwaxlpVZafNQ=; b=vJB9c0ufLsJ+1Xo5f8NEg4RHaC
        98XDL7CsYrrMKs9Q11bCNE34XEPD2IqwS7KKo5742pBrutf+nBOji8TuquAbexo/jmfAH5rN6yLvg
        vynvG1kS12vAEnRM0qCOkqzj4K6wx65p08QSCU6KweYUO41Ky9CBvAueWqKzfwAL2Izvf1mxdkMSH
        CF7dcunxgYm95R69mW8FLbnawc67+JRWKMKFSvpCi7sea2728l+t/4wD3D6d8xlKV/lA1rlhsloEC
        MoxWwOngvmgMlyXhXRA8eKa8tBI6ITu5Prbwd5gH9fsErYkZCfFYsvFdRkWPc5VOc0QL8QZblikj5
        EJ2PRWpw==;
Received: from [2001:4bb8:180:6600:bcde:334f:863c:27b8] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kclT9-0007aX-Sw; Wed, 11 Nov 2020 08:27:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 07/24] nbd: remove the call to set_blocksize
Date:   Wed, 11 Nov 2020 09:26:41 +0100
Message-Id: <20201111082658.3401686-8-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201111082658.3401686-1-hch@lst.de>
References: <20201111082658.3401686-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Block driver have no business setting the file system concept of a
block size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 drivers/block/nbd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index c4f9ccf5cc2ac5..f618688a196654 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -296,7 +296,7 @@ static void nbd_size_clear(struct nbd_device *nbd)
 	}
 }
 
-static void nbd_size_update(struct nbd_device *nbd, bool start)
+static void nbd_size_update(struct nbd_device *nbd)
 {
 	struct nbd_config *config = nbd->config;
 	struct block_device *bdev = bdget_disk(nbd->disk, 0);
@@ -311,11 +311,9 @@ static void nbd_size_update(struct nbd_device *nbd, bool start)
 	blk_queue_physical_block_size(nbd->disk->queue, config->blksize);
 	set_capacity(nbd->disk, nr_sectors);
 	if (bdev) {
-		if (bdev->bd_disk) {
+		if (bdev->bd_disk)
 			bd_set_nr_sectors(bdev, nr_sectors);
-			if (start)
-				set_blocksize(bdev, config->blksize);
-		} else
+		else
 			set_bit(GD_NEED_PART_SCAN, &nbd->disk->state);
 		bdput(bdev);
 	}
@@ -329,7 +327,7 @@ static void nbd_size_set(struct nbd_device *nbd, loff_t blocksize,
 	config->blksize = blocksize;
 	config->bytesize = blocksize * nr_blocks;
 	if (nbd->task_recv != NULL)
-		nbd_size_update(nbd, false);
+		nbd_size_update(nbd);
 }
 
 static void nbd_complete_rq(struct request *req)
@@ -1309,7 +1307,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 		args->index = i;
 		queue_work(nbd->recv_workq, &args->work);
 	}
-	nbd_size_update(nbd, true);
+	nbd_size_update(nbd);
 	return error;
 }
 
-- 
2.28.0

