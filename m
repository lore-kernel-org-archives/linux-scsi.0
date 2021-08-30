Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1327C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 21:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCB18600D0
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 21:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237965AbhH3V1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 17:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237527AbhH3V1E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 17:27:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2098C061575;
        Mon, 30 Aug 2021 14:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vRviJ2Q+W+fdmssObz0xPBy+U2+Ms4lUuLZlXzB02dA=; b=CWTBqWKQHMMz7fTV/SMV+3/fG4
        bg9K3W+/31wK9H28Ow3Gf9Ws76FgDom5TebADCF7mI9ZkVCU6S5l3Y+glkuKGSqNDEcIyx4g8V97v
        AzRuNUqSzaZXfNTe4f6xeEJaFzsDOQ4dIIGkC1kNwOXmDOp9VRisA0R1PUJb/Q8EAMBWl8cKjTwgP
        uaYMW+ZY2dpLWgRcc6ND0TYtDceOXSCXvBlHoOLpj4mruPezMq+av8z8Q5zcrL/fZq9M3BKJ+uI3y
        6dVwTSAQ9kQKZxfWQ9BW0R7lJvJGT1pd3ZDvCPnns8x8PR3QIBi45uXBWWXCZm1pEatL1HswTX1Hi
        UGlNq5Pw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKomk-000ciC-Ls; Mon, 30 Aug 2021 21:25:42 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com
Cc:     hch@infradead.org, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 4/8] mmc/core/block: add error handling support for add_disk()
Date:   Mon, 30 Aug 2021 14:25:34 -0700
Message-Id: <20210830212538.148729-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830212538.148729-1-mcgrof@kernel.org>
References: <20210830212538.148729-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

The caller only cleanups the disk if we pass on an allocated md
but on error we return return ERR_PTR(ret), and so we must do all
the unwinding ourselves.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/mmc/core/block.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 6a15fdf6e5f2..9b2856aa6231 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2453,9 +2453,14 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	/* used in ->open, must be set before add_disk: */
 	if (area_type == MMC_BLK_DATA_AREA_MAIN)
 		dev_set_drvdata(&card->dev, md);
-	device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
+	ret = device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
+	if (ret)
+		goto err_cleanup_queue;
 	return md;
 
+ err_cleanup_queue:
+	blk_cleanup_queue(md->disk->queue);
+	blk_mq_free_tag_set(&md->queue.tag_set);
  err_kfree:
 	kfree(md);
  out:
-- 
2.30.2

