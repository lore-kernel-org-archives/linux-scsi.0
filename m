Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E036C6379F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 15:04:04 +0000 (UTC)
Received: from vger.kernel.org (unknown [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FAE420867
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 15:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PyHnyUh0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FAE420867
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-scsi-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbgKPPEA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 10:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730736AbgKPO65 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 09:58:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89985C0613CF;
        Mon, 16 Nov 2020 06:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=2MZ7rG2SVw4WzYTKnpU/EThu7I42ye4vtM6air7UEg8=; b=PyHnyUh0PPkH+yqLagQ19OvvC+
        FlSpzlSdg1OQunPTCAeDu0gQH1vPQJCoApDX7VxN6c/WOIqI0ic8Iv/M87Km2qTOlzCX+eJxIcK7t
        9gT+KgnonlrqeWO8HGhDmNKS9d2N8KcELAEcVJYOp2xLKPiY9VrDekD0EQIUvZfvsG5kAL+aHRVDf
        MrC5YNsHcLZkbfWU7+tWXI2XVoRl2stXpjIpNroEOB5aMcrebGwmReG2yS2Hcvy4gcX3e++R2ckwp
        3uA1SKy8JuMioxo6fxMdKZXrCHsKzlw8Gr1OG0+awbEELu9T1276RdekSFGCRODCHQGNUgKXtUJAu
        o8MV8THA==;
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kefxr-0003sC-Nh; Mon, 16 Nov 2020 14:58:44 +0000
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
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 24/78] mtd_blkdevs: don't override BLKFLSBUF
Date:   Mon, 16 Nov 2020 15:57:15 +0100
Message-Id: <20201116145809.410558-25-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116145809.410558-1-hch@lst.de>
References: <20201116145809.410558-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

BLKFLSBUF is not supposed to actually send a flush command to the device,
but to tear down buffer cache structures.  Remove the mtd_blkdevs
implementation and just use the default semantics instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/mtd_blkdevs.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 0c05f77f9b216e..fb8e12d590a13a 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -298,38 +298,10 @@ static int blktrans_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return ret;
 }
 
-static int blktrans_ioctl(struct block_device *bdev, fmode_t mode,
-			      unsigned int cmd, unsigned long arg)
-{
-	struct mtd_blktrans_dev *dev = blktrans_dev_get(bdev->bd_disk);
-	int ret = -ENXIO;
-
-	if (!dev)
-		return ret;
-
-	mutex_lock(&dev->lock);
-
-	if (!dev->mtd)
-		goto unlock;
-
-	switch (cmd) {
-	case BLKFLSBUF:
-		ret = dev->tr->flush ? dev->tr->flush(dev) : 0;
-		break;
-	default:
-		ret = -ENOTTY;
-	}
-unlock:
-	mutex_unlock(&dev->lock);
-	blktrans_dev_put(dev);
-	return ret;
-}
-
 static const struct block_device_operations mtd_block_ops = {
 	.owner		= THIS_MODULE,
 	.open		= blktrans_open,
 	.release	= blktrans_release,
-	.ioctl		= blktrans_ioctl,
 	.getgeo		= blktrans_getgeo,
 };
 
-- 
2.29.2

