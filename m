Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDE0C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 277F9611C1
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhKCXHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhKCXHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 19:07:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB12FC06120F;
        Wed,  3 Nov 2021 16:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xM/pcG57FEbBLxlT6pgxDW/VMkBzlCLhukAAwabKrt0=; b=xsMwbns2CnrGhdC3/gdEK/EABA
        ryJ1vv66G9KRUIjiVXE2rvtujuCezBnuYy8ZMeP0BSvjcHtw/5p8GVhd8rSUFwIz29eanzizV2KQI
        4OGJij8kp9IyhVeXxKOWDvrTB+TmnahKwemhFatS3t8PkNnz8oqB+MAf3XpAdbftlqUPu2BYrep7t
        hXQUiSjuwnTpCtq6cSSvELxUlo4kcY5R6SZW3ZKeQPgDd0YYtvZr7qzfZ7o8XKSNSCAC6hbUR+x+5
        mPObwJUNUNOLmH2ZEgJqHUKtct7rEzptoCFR+bBGsLe5m7xDuqhH41f//ikcI2dvAsvI9mb5K9/oj
        pQwz2MnQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miPJ8-006sej-TO; Wed, 03 Nov 2021 23:04:38 +0000
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
Subject: [PATCH v5 13/14] floppy: address add_disk() error handling on probe
Date:   Wed,  3 Nov 2021 16:04:36 -0700
Message-Id: <20211103230437.1639990-14-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103230437.1639990-1-mcgrof@kernel.org>
References: <20211103230437.1639990-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to cleanup resources on the probe() callback registered
with __register_blkdev(), now that add_disk() error handling is
supported. Address this.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/floppy.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3873e789478e..c4267da716fe 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4528,10 +4528,19 @@ static void floppy_probe(dev_t dev)
 		return;
 
 	mutex_lock(&floppy_probe_lock);
-	if (!disks[drive][type]) {
-		if (floppy_alloc_disk(drive, type) == 0)
-			add_disk(disks[drive][type]);
-	}
+	if (disks[drive][type])
+		goto out;
+	if (floppy_alloc_disk(drive, type))
+		goto out;
+	if (add_disk(disks[drive][type]))
+		goto cleanup_disk;
+out:
+	mutex_unlock(&floppy_probe_lock);
+	return;
+
+cleanup_disk:
+	blk_cleanup_disk(disks[drive][type]);
+	disks[drive][type] = NULL;
 	mutex_unlock(&floppy_probe_lock);
 }
 
-- 
2.33.0

