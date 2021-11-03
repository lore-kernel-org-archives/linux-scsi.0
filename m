Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FA0C43219
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2434760EE9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhKCRsj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbhKCRsY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:48:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6052C06120A;
        Wed,  3 Nov 2021 10:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Tm/hUm1c0RwnBHGX4ZxvGa4/Gfwf85WhVKa905j+Dus=; b=CWtaEaCefnFgRrPEC7PtJfHSAu
        ARbg1CXnlnCJxGrkWDdy09QKCJpIUV303hBLVvLRKEu/EPcreFnPswar0FzxiaQHGwOJspEzmK6KD
        TNVQdkRNc4mj5Y69cVUEzJPL3q4NdpNlv6QXLTPbfgKuoxQ5wZSCIuZ86shF/3CJbxe1p/ok6gtVQ
        XWnu3cp31pbrLg0wElkoosVPcWfcaZpECfwlagErS3oc7dcJ6YGZbf9zk2W75MQzO+0roBj/wyIjh
        csql2i0PH4FxMZWzaKeAD365GiEh1kWT4+03hD0/FP9QWobiv8EmdZmTwzMYvXoVPdJLZZjSckt28
        phNRVFsA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKKA-005z5P-9b; Wed, 03 Nov 2021 17:45:22 +0000
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
Subject: [PATCH v3 02/13] nvdimm/btt: use goto error labels on btt_blk_init()
Date:   Wed,  3 Nov 2021 10:45:10 -0700
Message-Id: <20211103174521.1426407-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103174521.1426407-1-mcgrof@kernel.org>
References: <20211103174521.1426407-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This will make it easier to share common error paths.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/btt.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index a62f23b945f1..416d31cda3e7 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1519,6 +1519,7 @@ static int btt_blk_init(struct btt *btt)
 {
 	struct nd_btt *nd_btt = btt->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
+	int rc = -ENOMEM;
 
 	btt->btt_disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!btt->btt_disk)
@@ -1534,19 +1535,22 @@ static int btt_blk_init(struct btt *btt)
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_disk->queue);
 
 	if (btt_meta_size(btt)) {
-		int rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
-
-		if (rc) {
-			blk_cleanup_disk(btt->btt_disk);
-			return rc;
-		}
+		rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
+		if (rc)
+			goto out_cleanup_disk;
 	}
+
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
 	device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
+
 	btt->nd_btt->size = btt->nlba * (u64)btt->sector_size;
 	nvdimm_check_and_set_ro(btt->btt_disk);
 
 	return 0;
+
+out_cleanup_disk:
+	blk_cleanup_disk(btt->btt_disk);
+	return rc;
 }
 
 static void btt_blk_cleanup(struct btt *btt)
-- 
2.33.0

