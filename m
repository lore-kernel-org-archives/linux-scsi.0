Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0E4C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiGFHEx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiGFHEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:04:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E956312;
        Wed,  6 Jul 2022 00:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=YBz/LhwBZw9yI8kZ+GIiGhL/9U8OwJhoN7e643gX1Pk=; b=OrWKhJ6iJkZoV/tAGt7bYxwSdQ
        nMVrHGB4lhjk7qf+22T39kBOgI6dTI9aZbfMpZfs9nmZ12o1h4JNUSOsmH3uSXYgTCt7XTSIGmstZ
        /CAaZ+ZSbbC3K12MmV7ipAwfvGNzhG4K8bc2YuG91q3md1xczFEMcyX7KSHCDg2mwaeQtrIX+OZ29
        DiAguk5VzOqg5FT1pMYdJlwEj+mj7aRQbFXzWLwNaJaWE92KNWq6y/+6c/9EDTFubZkzsIb+aktoz
        54R27FLAlwzC/MF8g9FszmTEVlLRfiZVc0bCc0RRCLqP4A7Nkdps2OHJPdDmblGC+gfVwEvL7YdxT
        NDAhwOiA==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z5H-006vEM-3p; Wed, 06 Jul 2022 07:04:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 13/16] nvmet:: use bdev based helpers in nvmet_bdev_zone_mgmt_emulate_all
Date:   Wed,  6 Jul 2022 09:03:47 +0200
Message-Id: <20220706070350.1703384-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the bdev based helpers instead of the queue based ones to clean up
the code a bit and prepare for storing all zone related fields in
struct gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/target/zns.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index c4c99b832daf2..9d8717126ab31 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -413,7 +413,7 @@ static u16 nvmet_bdev_zone_mgmt_emulate_all(struct nvmet_req *req)
 		ret = 0;
 	}
 
-	while (sector < get_capacity(bdev->bd_disk)) {
+	while (sector < bdev_nr_sectors(bdev)) {
 		if (test_bit(blk_queue_zone_no(q, sector), d.zbitmap)) {
 			bio = blk_next_bio(bio, bdev, 0,
 				zsa_req_op(req->cmd->zms.zsa) | REQ_SYNC,
@@ -422,7 +422,7 @@ static u16 nvmet_bdev_zone_mgmt_emulate_all(struct nvmet_req *req)
 			/* This may take a while, so be nice to others */
 			cond_resched();
 		}
-		sector += blk_queue_zone_sectors(q);
+		sector += bdev_zone_sectors(bdev);
 	}
 
 	if (bio) {
-- 
2.30.2

