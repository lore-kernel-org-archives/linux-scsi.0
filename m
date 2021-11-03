Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFBFC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 184FF604DC
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhKCXH5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhKCXH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 19:07:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D4EC06120A;
        Wed,  3 Nov 2021 16:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EKg8l7DulUH89IPZrJiJCOmNU6yLebfQUxB2V9YdJy0=; b=UycxkmUl3rgzdcnFEz3/RXqM5M
        PaFTsRd0X7I1MsSZT6O1RCot3wGIEPfOclPTunIUGD5rE6lqjbHXAtuqk1c+FyjAoOHykuF1ymGJW
        +lxtbuaK8iRAXbrVdYmNZrWZW3hoWFHnT5HHe0Rl+jyi7CajrCAGYM9x7/c3SR572orSCTxe3z6wU
        EEqjcy6603frm90YaczwgD3eqe8TT9aDT8BaS6RDBI1Y7W1zznrtLEJZS334R4F3t9TJGUBZ0XDVi
        WFDj+HfDXrVRJA8ny5i1EPEVm//1qW2WFHjQ2sl4h3rCwdHCMyIk+LseQdpc5WcsnRy6rL0VNgmGm
        6AoCqpBA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miPJ8-006sel-US; Wed, 03 Nov 2021 23:04:38 +0000
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
Subject: [PATCH v5 14/14] block: add __must_check for *add_disk*() callers
Date:   Wed,  3 Nov 2021 16:04:37 -0700
Message-Id: <20211103230437.1639990-15-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103230437.1639990-1-mcgrof@kernel.org>
References: <20211103230437.1639990-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that we have done a spring cleaning on all drivers and added
error checking / handling, let's keep it that way and ensure
no new drivers fail to stick with it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 block/genhd.c         | 6 +++---
 include/linux/genhd.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 2f5b7e24e88a..2263f7862241 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -394,8 +394,8 @@ static void disk_scan_partitions(struct gendisk *disk)
  * This function registers the partitioning information in @disk
  * with the kernel.
  */
-int device_add_disk(struct device *parent, struct gendisk *disk,
-		     const struct attribute_group **groups)
+int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
+				 const struct attribute_group **groups)
 
 {
 	struct device *ddev = disk_to_dev(disk);
@@ -542,7 +542,7 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 out_free_ext_minor:
 	if (disk->major == BLOCK_EXT_MAJOR)
 		blk_free_ext_minor(disk->first_minor);
-	return WARN_ON_ONCE(ret); /* keep until all callers handle errors */
+	return ret;
 }
 EXPORT_SYMBOL(device_add_disk);
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 59eabbc3a36b..f7d6810e68b3 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -205,9 +205,9 @@ static inline dev_t disk_devt(struct gendisk *disk)
 void disk_uevent(struct gendisk *disk, enum kobject_action action);
 
 /* block/genhd.c */
-int device_add_disk(struct device *parent, struct gendisk *disk,
-		const struct attribute_group **groups);
-static inline int add_disk(struct gendisk *disk)
+int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
+				 const struct attribute_group **groups);
+static inline int __must_check add_disk(struct gendisk *disk)
 {
 	return device_add_disk(NULL, disk, NULL);
 }
-- 
2.33.0

