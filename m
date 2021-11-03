Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEAAC4321E
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA986113B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhKCRtF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhKCRsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:48:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE613C06120B;
        Wed,  3 Nov 2021 10:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uHG2wm56Aib5onrlzGvw5KjH0h5tirGqCGcKvr2W6EM=; b=gBMbh2D7gsBHsg1JNaLN9mdQW/
        V+CmgSVG3fdKFAbINMkYJa12xpO4Mv4Khu0mFo7x0pGe0lWSRakn7mCaerH3mm1bH0uWZD16O20D8
        LGDnh3mfxazbRMq/gwZdDmddaSB+h3j/o/7BqfuVm9Soos+qoWzrMf6fVcYYB4TRjTQvt0pD6H+GK
        DQBBeewWTyRrBJsc2ANvS4P2g2CMEQcOX/zwy+fZRncntJsPQvXDJhe4K1718cDILECOrGvD/Gdg9
        ObSRmne8sNaCpZA/KOsSS86QcSxQyuN0tDxMlwDXxTJAD0u/HKEtLG4FCn6FCVJcRTKD1L1RQGAUO
        ZEbYctPg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKKA-005z5n-N0; Wed, 03 Nov 2021 17:45:22 +0000
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
Subject: [PATCH v3 13/13] block: add __must_check for *add_disk*() callers
Date:   Wed,  3 Nov 2021 10:45:21 -0700
Message-Id: <20211103174521.1426407-14-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103174521.1426407-1-mcgrof@kernel.org>
References: <20211103174521.1426407-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that we have done a spring cleaning on all drivers and added
error checking / handling, let's keep it that way and ensure
no new drivers fail to stick with it.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 block/genhd.c         | 6 +++---
 include/linux/genhd.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 8837a89242a2..c5a37970c4e4 100644
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

