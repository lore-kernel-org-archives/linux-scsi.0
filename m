Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7439C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B122860EE9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhKCRsP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhKCRsM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:48:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30AAC061208;
        Wed,  3 Nov 2021 10:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=z6AQC3QcP6lWjf+vfQidLFSzr4mm79xmfx8Neo8IBts=; b=W7TKNKKUTrCwqpK/XgkcFKsdQf
        g3PaWmRzMGMuayUtp0OhMTbiSTSUQgTzeiWlp/rug0FTfy4F/wEtB6XDPcB2B0PhCn5LGAv6A3R9t
        nz5ERoaFIAZLDrCu/69PXZ2Nqc9d7yE0/UXjnNSixSJ9VeCWIAB4QS4b7Qw8heN4Yv/tegHfxbC78
        qHUTaSiIZYVH7E6/2cnAH6aEB5niLSIEt4VOXfrhDClGmb1XaCNQhytI8uysaFAIUUft5buOzbiEl
        Lg4ZDqq3B39/skrZUDTfj0ZoiPO6Dp4qGOt8arevUlmN/QIwI+ok98d4+BvlMYXpZvobnZydkHcS3
        rAjU8VxA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKKA-005z5X-Er; Wed, 03 Nov 2021 17:45:22 +0000
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
Subject: [PATCH v3 06/13] nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
Date:   Wed,  3 Nov 2021 10:45:14 -0700
Message-Id: <20211103174521.1426407-7-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103174521.1426407-1-mcgrof@kernel.org>
References: <20211103174521.1426407-1-mcgrof@kernel.org>
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

