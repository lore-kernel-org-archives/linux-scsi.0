Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E00C2BA80
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbhKVNJv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238838AbhKVNJr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53F1C061714;
        Mon, 22 Nov 2021 05:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=McEuRrX09wHuglPPFck90vcSXRADf2rmkOluye4h1CE=; b=TDAgFDIA0aMGAzQCTsYQXZYZ7j
        bX4oCddnzfVg21AgNCuQNX7f1acQacffeLjB0y2iJaEUMQaHbZRxAlCxMu8vjgHDTiDW0jHgrYLW2
        rfl3uu+7TXLcm+/v49L6/3GlyoogmNsYO+3C+T2HeiTfjwNzJFyHi8mhHYlurC5PgloREbMU3jgVy
        Yq047cX/ojvbg+mYRLDUBL42/txZI0bfflYu2X9qMWKk031TITOt4eMKd2WTUGNU3QFZf8YrPaFIP
        AmAM5boWoZ798bNhEOLenr6V9nacyhQHeJSVpXyeBuRIofh8F/PFTv+SZFIZd0oYxVFdOFFvwFQz9
        W5j4Zmpg==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91p-00CrsF-QA; Mon, 22 Nov 2021 13:06:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 09/14] mmc: don't set GENHD_FL_SUPPRESS_PARTITION_INFO
Date:   Mon, 22 Nov 2021 14:06:20 +0100
Message-Id: <20211122130625.1136848-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This manually reverts 07b652cdbec3 ("mmc: card: Don't show eMMC RPMB and
BOOT areas in /proc/partitions").  Based on the commit description that
change was purely cosmetic.  mmc is the last driver that sets this
flag and thus prevents it from being removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mmc/core/block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index a71b3512c877a..2dd93d49d822c 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2397,8 +2397,7 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	set_disk_ro(md->disk, md->read_only || default_ro);
 	md->disk->flags = GENHD_FL_EXT_DEVT;
 	if (area_type & (MMC_BLK_DATA_AREA_RPMB | MMC_BLK_DATA_AREA_BOOT))
-		md->disk->flags |= GENHD_FL_NO_PART |
-				   GENHD_FL_SUPPRESS_PARTITION_INFO;
+		md->disk->flags |= GENHD_FL_NO_PART;
 
 	/*
 	 * As discussed on lkml, GENHD_FL_REMOVABLE should:
-- 
2.30.2

