Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD4CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 12:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F2361183
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 12:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbhKCMZR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 08:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbhKCMYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 08:24:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA4CC061203;
        Wed,  3 Nov 2021 05:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ta8T2h+igHLkoXYKSDSsnffhuWJk+sXQmUMRve+1Rno=; b=GjG8sub2opJo2VJVXBNOnoUg0u
        LBNfxAar6SgW57AHIINAd+s2vt+OYmMUu64B3BnSiY8264QtM76epibtiDmbwikgwzTJkjJVr798d
        pkKw/Ei4KRx/cirUg+TwSOplcuPcXuLCz7lC4v9bC0tQpGY2Vj8feC8Cn2C9aUkhRZvXeGo0+kRDY
        FWoBjBQrhoD126rdQNkS9Yrvi494sPilHfG0HwAd4l4yTYZa3BuHbbGhqYUaTJ2BiPouqtZYwqHjh
        wcHv5kdsXqColJqkvG1bGUwz4bgzmf23yPJGFhU1WntGUVse4zUpulxkc2KCZcQGaxMxv2BVIJBAU
        qikEERCA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miFHC-0056IA-5g; Wed, 03 Nov 2021 12:21:58 +0000
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
Subject: [PATCH v2 01/13] nvdimm/btt: do not call del_gendisk() if not needed
Date:   Wed,  3 Nov 2021 05:21:45 -0700
Message-Id: <20211103122157.1215783-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103122157.1215783-1-mcgrof@kernel.org>
References: <20211103122157.1215783-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

del_gendisk() is not required if the disk has not been added.
On kernels prior to commit 40b3a52ffc5bc3 ("block: add a sanity
check for a live disk in del_gendisk") it is mandatory to not
call del_gendisk() if the underlying device has not been through
device_add().

Fixes: 41cd8b70c37a ("libnvdimm, btt: add support for blk integrity")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/btt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index f10a50ffa047..a62f23b945f1 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1537,7 +1537,6 @@ static int btt_blk_init(struct btt *btt)
 		int rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
 
 		if (rc) {
-			del_gendisk(btt->btt_disk);
 			blk_cleanup_disk(btt->btt_disk);
 			return rc;
 		}
-- 
2.33.0

