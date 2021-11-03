Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B36C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41B8561220
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhKCXH5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhKCXH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 19:07:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE762C06120C;
        Wed,  3 Nov 2021 16:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZWWXDd/V8wSyF3GgA6ARDfKWedgyIPB1+zJe650uNsc=; b=gcZn3ERWC0VTuhgdk9N5H/ZgIU
        iRLL3boTrpaJ0tRIa2hYP7WQ4/m9P77DQ7IOyZowCmJB2G71SCHVmJgP/+GNvR5DHaTm5AGzJE0h4
        e1mb2pS0x6iXRPd2KS6UQFzXAnkgIdi0+dtzjDoNaKC2D8xC9Vx1uWt8XFiD9QQcfJa8smNOxj4xM
        J12EZ8XwAPCFPZ4vedxPXhGMCkbXiBKiQ7ZCVUanSC6HkfTPPPXtN2KOxfk3mW1dDgDXWP/Q6Uioa
        OqlvFtWnuefCyylqbvwTZ3XXYFcLmLR2MQcd06Tc3sRH86rziutJ4ctJrkUbwTiefUxb4VRNJRrdg
        qHIidldg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miPJ8-006seV-L7; Wed, 03 Nov 2021 23:04:38 +0000
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
Subject: [PATCH v5 06/14] nvdimm/pmem: use add_disk() error handling
Date:   Wed,  3 Nov 2021 16:04:29 -0700
Message-Id: <20211103230437.1639990-7-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103230437.1639990-1-mcgrof@kernel.org>
References: <20211103230437.1639990-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that device_add_disk() supports returning an error, use
that. We must unwind alloc_dax() on error.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/pmem.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index bcfc36e7295f..37fc03058556 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -462,7 +462,9 @@ static int pmem_attach_disk(struct device *dev,
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	pmem->dax_dev = dax_dev;
 
-	device_add_disk(dev, disk, pmem_attribute_groups);
+	rc = device_add_disk(dev, disk, pmem_attribute_groups);
+	if (rc)
+		goto out_cleanup_dax;
 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
@@ -473,6 +475,10 @@ static int pmem_attach_disk(struct device *dev,
 	if (!pmem->bb_state)
 		dev_warn(dev, "'badblocks' notification disabled\n");
 	return 0;
+
+out_cleanup_dax:
+	kill_dax(pmem->dax_dev);
+	put_dax(pmem->dax_dev);
 out:
 	blk_cleanup_disk(pmem->disk);
 	return rc;
-- 
2.33.0

