Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D224C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 12:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C6EE61184
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 12:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhKCMZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 08:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbhKCMYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 08:24:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F052C061205;
        Wed,  3 Nov 2021 05:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=H1GYsLEV/bOIHqFf9/LwZEIMVeaIqhZIz4rwtQbLUuA=; b=tMlsaZRa9bRwGIbJChyQJI+miU
        XOdM1W/9hgsi2wNo/n1W3Y4ZNKBMeHaJ9FHmZuBfZxNi7Xzl5P0Y/L2m8InI8YVkF+t0S4/oAJSC5
        tvL7vP3qui6hyluJKiZIF0/oThYibxKeBrklml5+8mtSjZLeePkaQPmo2n0pOy/E1oWHdQJOvGNUk
        gHGuTBA/YCQK2Tm3EdF2/r9hh7Z0zg3f/AxjAHuDqaKH+3AnIYUWcq3F1P2kCPvdpylctYlDzFszm
        /yTrkFGaf6Jffv3cSzaa2PkXCEtiVNHw2MvCwZKW4549keipYa8Erkbi56OJqNP+KIDWzg9joTMdf
        jezDbrEQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miFHC-0056IK-Ap; Wed, 03 Nov 2021 12:21:58 +0000
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
Subject: [PATCH v2 06/13] nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
Date:   Wed,  3 Nov 2021 05:21:50 -0700
Message-Id: <20211103122157.1215783-7-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103122157.1215783-1-mcgrof@kernel.org>
References: <20211103122157.1215783-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prior to devm being able to use pmem_release_disk() there are other
failure which can occur for which we must account for and release the
disk for. Address those few cases.

Fixes: 3dd60fb9d95d ("nvdimm/pmem: stop using q_usage_count as external pgmap refcount")
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/pmem.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 9cc0d0ebfad1..d98af6c31f42 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -471,8 +471,10 @@ static int pmem_attach_disk(struct device *dev,
 		bb_range.end = res->end;
 	}
 
-	if (IS_ERR(addr))
-		return PTR_ERR(addr);
+	if (IS_ERR(addr)) {
+		rc = PTR_ERR(addr);
+		goto out;
+	}
 	pmem->virt_addr = addr;
 
 	blk_queue_write_cache(q, true, fua);
@@ -497,7 +499,8 @@ static int pmem_attach_disk(struct device *dev,
 		flags = DAXDEV_F_SYNC;
 	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops, flags);
 	if (IS_ERR(dax_dev)) {
-		return PTR_ERR(dax_dev);
+		rc = PTR_ERR(dax_dev);
+		goto out;
 	}
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	pmem->dax_dev = dax_dev;
@@ -512,8 +515,10 @@ static int pmem_attach_disk(struct device *dev,
 					  "badblocks");
 	if (!pmem->bb_state)
 		dev_warn(dev, "'badblocks' notification disabled\n");
-
 	return 0;
+out:
+	blk_cleanup_disk(pmem->disk);
+	return rc;
 }
 
 static int nd_pmem_probe(struct device *dev)
-- 
2.33.0

