Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEBAC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 537516113B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhKCRsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhKCRsP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:48:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61869C061203;
        Wed,  3 Nov 2021 10:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=t1mKtGDFT6GqHO6H9O816oKN5hn/bfmk/IYkXq4Sf9w=; b=tRTBnxeQJlMn9nFQvp8Y8j16dZ
        6yUtFy225RjrZECgm8tpgmNLGBcPu2DyJBbqp5bjFMWoBIIxCixeO+dY8TMtULIu2wwao4TWqbucr
        dVUVDooXc0wBhVjrUdyeUcFl5obM0WY4iAK/gps/+NJDR5jxLtvRtrlRBEO+vTCDelJGJAIjc0vFc
        aRORqUF5kXo9i3+THevuoij6XxRXPY7pFLnLADi52Be3aeWgGPj2JxZFdrSaNSyR6R0Vv9ta1Rjhw
        rQgyLucW0XhPuowyQwxpd5CeseSjX4jtCGPmB4ory0f1URvLh2uA/aV2GvtwPlHD+CsU5HXL7nB/Y
        wSIu6O0A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKKA-005z5T-Bw; Wed, 03 Nov 2021 17:45:22 +0000
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
Subject: [PATCH v3 04/13] nvdimm/blk: avoid calling del_gendisk() on early failures
Date:   Wed,  3 Nov 2021 10:45:12 -0700
Message-Id: <20211103174521.1426407-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103174521.1426407-1-mcgrof@kernel.org>
References: <20211103174521.1426407-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If nd_integrity_init() fails we'd get del_gendisk() called,
but that's not correct as we should only call that if we're
done with device_add_disk(). Fix this by providing unwinding
prior to the devm call being registered and moving the devm
registration to the very end.

This should fix calling del_gendisk() if nd_integrity_init()
fails. I only spotted this issue through code inspection. It
does not fix any real world bug.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/blk.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index b6c6866f9259..4eef67918a7e 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -239,6 +239,7 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	resource_size_t available_disk_size;
 	struct gendisk *disk;
 	u64 internal_nlba;
+	int rc;
 
 	internal_nlba = div_u64(nsblk->size, nsblk_internal_lbasize(nsblk));
 	available_disk_size = internal_nlba * nsblk_sector_size(nsblk);
@@ -255,20 +256,26 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	blk_queue_logical_block_size(disk->queue, nsblk_sector_size(nsblk));
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 
-	if (devm_add_action_or_reset(dev, nd_blk_release_disk, disk))
-		return -ENOMEM;
-
 	if (nsblk_meta_size(nsblk)) {
-		int rc = nd_integrity_init(disk, nsblk_meta_size(nsblk));
+		rc = nd_integrity_init(disk, nsblk_meta_size(nsblk));
 
 		if (rc)
-			return rc;
+			goto out_before_devm_err;
 	}
 
 	set_capacity(disk, available_disk_size >> SECTOR_SHIFT);
 	device_add_disk(dev, disk, NULL);
+
+	/* nd_blk_release_disk() is called if this fails */
+	if (devm_add_action_or_reset(dev, nd_blk_release_disk, disk))
+		return -ENOMEM;
+
 	nvdimm_check_and_set_ro(disk);
 	return 0;
+
+out_before_devm_err:
+	blk_cleanup_disk(disk);
+	return rc;
 }
 
 static int nd_blk_probe(struct device *dev)
-- 
2.33.0

