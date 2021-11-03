Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A370AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8637A611C7
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhKCXHz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhKCXHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 19:07:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB853C061205;
        Wed,  3 Nov 2021 16:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=C5e6xzRn1we/2kQlnWV6XI4+n17BdzCMXkcscKinpyQ=; b=rQgtdwDL4cqNfijcjNAVigkJo4
        cX41IEACk3LN5nzW3JDiDwX8es6sV7SJBWWrikL7wJZ10emJnbjr7mU1XRFvR8VMtTJM4AyMZ8jVD
        ok4DrTxNa/oasSfaFJFfkKbUtOi7je6lbRFigSrXDEWcAom7taLmsuUboNUAgZLbYgtrHyvXx3B/h
        /ZBVeIz+FgoSveARRuQ4SabpuYt7ALHIlq830GTFAf5XV2o+XE7onZyyzu+BQ4SV9yphrf9qfQpGc
        WzodY35tkNJnxgS7e1h4Gpj39ooMZLknfbE8sCzs9dbuSDpQN0hQj72PcpFstr83Cjzzq+BXNlNdD
        hYgqe1Xw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miPJ8-006seL-H5; Wed, 03 Nov 2021 23:04:38 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org, mcgrof@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/14] nvdimm/btt: add error handling support for add_disk()
Date:   Wed,  3 Nov 2021 16:04:25 -0700
Message-Id: <20211103230437.1639990-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103230437.1639990-1-mcgrof@kernel.org>
References: <20211103230437.1639990-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/btt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 5cb6d7ac6e36..38ed53eeea5e 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1541,7 +1541,9 @@ static int btt_blk_init(struct btt *btt)
 	}
 
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
-	device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
+	rc = device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
+	if (rc)
+		goto out_cleanup_disk;
 
 	btt->nd_btt->size = btt->nlba * (u64)btt->sector_size;
 	nvdimm_check_and_set_ro(btt->btt_disk);
-- 
2.33.0

