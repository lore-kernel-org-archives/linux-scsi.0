Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00418C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A55E66113B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhKCRtE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhKCRsR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:48:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E0AC061208;
        Wed,  3 Nov 2021 10:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+G0HrywYCBknnU1QiNcJpSRJV8fKSVVdTBscrCYx8+A=; b=D7eJA/7/DaDgORWJoi+6J8nPHe
        XNvQ3qJIffm5PQ1T8PlXZwwWHsNr33hPvaXsBLuwnIhR2qTJRgm1AWVoceRlNYrDOgkmLrJs3WQri
        1J1M2dEIm6mmLsqwP1PUTFYX76zv80Vx9qjUrZMyMRaIvgOm96bvtmhpOCUh+VhiBbdILM6SAyTWf
        DlC718Jz3bjp5zk3MT0TlEPNz44rdABMulfDhjY5OJSIf0pRv/vlpuEZK0hCL7RR4QenHDiSuaJu+
        r2C+blUvqLyxA03qR4jhX71UQgeFGXbuoUP9EtigoUUn1Zk7PyYJeKyZzvduMWJUrd/bO9LRQ7Vr+
        zTuQeUmw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKKA-005z5h-Ji; Wed, 03 Nov 2021 17:45:22 +0000
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
Subject: [PATCH v3 10/13] mtd/ubi/block: add error handling support for add_disk()
Date:   Wed,  3 Nov 2021 10:45:18 -0700
Message-Id: <20211103174521.1426407-11-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103174521.1426407-1-mcgrof@kernel.org>
References: <20211103174521.1426407-1-mcgrof@kernel.org>
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
 drivers/mtd/ubi/block.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index e003b4b44ffa..062e6c2c45f5 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -447,12 +447,18 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	list_add_tail(&dev->list, &ubiblock_devices);
 
 	/* Must be the last step: anyone can call file ops from now on */
-	add_disk(dev->gd);
+	ret = add_disk(dev->gd);
+	if (ret)
+		goto out_destroy_wq;
+
 	dev_info(disk_to_dev(dev->gd), "created from ubi%d:%d(%s)",
 		 dev->ubi_num, dev->vol_id, vi->name);
 	mutex_unlock(&devices_mutex);
 	return 0;
 
+out_destroy_wq:
+	list_del(&dev->list);
+	destroy_workqueue(dev->wq);
 out_remove_minor:
 	idr_remove(&ubiblock_minor_idr, gd->first_minor);
 out_cleanup_disk:
-- 
2.33.0

