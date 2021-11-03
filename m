Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BA0C4167B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D501E611C4
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhKCXIE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhKCXH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 19:07:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599D2C06127A;
        Wed,  3 Nov 2021 16:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hYlR/8Tg6c9D0TIgopusNh68MuCB0xLxUMwkxbc8nBI=; b=GLTENMpjVjKLQA3pFzA2VnYGWK
        s102ZjrNqbmYB+Y8sQ1E9/bYIpb2ShekOXWSKZWfCU/fZTmqxVBcWAWnILLFRXRnxrEUIBidVtJDv
        egKwZoByW0tJEPaFYKCUHxtKT3e9NUFFSjkdJ+h1tlGrZqDe+q07zZ4+SPzz4Tj/pZOvubkzVuGVw
        S8d1LqhfqTsEOWOen0qlJVF/dzlSsqK/641EE9da7mgz2FsSbmF2HORs21ZE7IEUXhhV4WurEPowT
        niEbTla4FFTtoISTPwtXdpX/+JJwrE5dwC7XmnooAqOw2MInRcwWk+v5zSU33lPxi1SYeRNl4qZvE
        0mjxR69A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miPJ8-006seT-K3; Wed, 03 Nov 2021 23:04:38 +0000
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
Subject: [PATCH v5 05/14] nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
Date:   Wed,  3 Nov 2021 16:04:28 -0700
Message-Id: <20211103230437.1639990-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103230437.1639990-1-mcgrof@kernel.org>
References: <20211103230437.1639990-1-mcgrof@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/pmem.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index c74d7bceb222..bcfc36e7295f 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -428,8 +428,10 @@ static int pmem_attach_disk(struct device *dev,
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
@@ -454,7 +456,8 @@ static int pmem_attach_disk(struct device *dev,
 		flags = DAXDEV_F_SYNC;
 	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops, flags);
 	if (IS_ERR(dax_dev)) {
-		return PTR_ERR(dax_dev);
+		rc = PTR_ERR(dax_dev);
+		goto out;
 	}
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	pmem->dax_dev = dax_dev;
@@ -469,8 +472,10 @@ static int pmem_attach_disk(struct device *dev,
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

