Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB5EC47087
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 06:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B2826140F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 06:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhEYGPD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 02:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhEYGO5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 02:14:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964E5C06138A;
        Mon, 24 May 2021 23:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZoEgGzPSTNzH+qs9ctTAS3W06AnYycTikvq1MWaeQqE=; b=BnCb/+Ryy1ZD5GsDo7WRS4PSov
        9hUThumym8DudSNN18ByJOQynp0wIRug4kNe6a1tIvs9i+tU6YSySlJjpt4cWRpYWH3p0P3qCstpO
        IudLhWt1cux74FsIzjJQeKdd+gb2IHI0QzSSLI/SMQh98ggkAxvHnvkgIs+o+aSUvXoFDJWfY0AJN
        GDlPYCIaVbhqWjCVkclj/ptq5Wy8yCw2owSKwtcO8OzmJEYcIMx1sneQ2x3XHm9oRVVuqHTGMl3o+
        eF/GRHgFEEvdQ6L1aCjjF09sx5omIRpBPUHdApveH6giGfXeuajBF3P4Kx40x1XbkhwRVbfZ8Sue7
        5HxnzCLw==;
Received: from [2001:4bb8:190:7543:af90:8b76:7e65:6578] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1llQJf-003ZEW-V0; Tue, 25 May 2021 06:13:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 7/8] block: factor out a part_devt helper
Date:   Tue, 25 May 2021 08:13:00 +0200
Message-Id: <20210525061301.2242282-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210525061301.2242282-1-hch@lst.de>
References: <20210525061301.2242282-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a helper to find the dev_t for a disk + partno tuple.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c         | 25 +++++++++++++++++--------
 include/linux/genhd.h |  1 +
 init/do_mounts.c      | 10 ++--------
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7c88c52c6589..e3de476797de 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1242,6 +1242,19 @@ static int __init proc_genhd_init(void)
 module_init(proc_genhd_init);
 #endif /* CONFIG_PROC_FS */
 
+dev_t part_devt(struct gendisk *disk, u8 partno)
+{
+	struct block_device *part = bdget_disk(disk, partno);
+	dev_t devt = 0;
+
+	if (part) {
+		devt = part->bd_dev;
+		bdput(part);
+	}
+
+	return devt;
+}
+
 dev_t blk_lookup_devt(const char *name, int partno)
 {
 	dev_t devt = MKDEV(0, 0);
@@ -1251,7 +1264,6 @@ dev_t blk_lookup_devt(const char *name, int partno)
 	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
 	while ((dev = class_dev_iter_next(&iter))) {
 		struct gendisk *disk = dev_to_disk(dev);
-		struct block_device *part;
 
 		if (strcmp(dev_name(dev), name))
 			continue;
@@ -1262,13 +1274,10 @@ dev_t blk_lookup_devt(const char *name, int partno)
 			 */
 			devt = MKDEV(MAJOR(dev->devt),
 				     MINOR(dev->devt) + partno);
-			break;
-		}
-		part = bdget_disk(disk, partno);
-		if (part) {
-			devt = part->bd_dev;
-			bdput(part);
-			break;
+		} else {
+			devt = part_devt(disk, partno);
+			if (devt)
+				break;
 		}
 	}
 	class_dev_iter_exit(&iter);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index a093ec40c0a2..96d55cd06cf6 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -310,6 +310,7 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
 }
 #endif /* CONFIG_SYSFS */
 
+dev_t part_devt(struct gendisk *disk, u8 partno);
 dev_t blk_lookup_devt(const char *name, int partno);
 void blk_request_module(dev_t devt);
 #ifdef CONFIG_BLOCK
diff --git a/init/do_mounts.c b/init/do_mounts.c
index a78e44ee6adb..74aede860de7 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -133,14 +133,8 @@ static dev_t devt_from_partuuid(const char *uuid_str)
 		 * Attempt to find the requested partition by adding an offset
 		 * to the partition number found by UUID.
 		 */
-		struct block_device *part;
-
-		part = bdget_disk(dev_to_disk(dev),
-				  dev_to_bdev(dev)->bd_partno + offset);
-		if (part) {
-			devt = part->bd_dev;
-			bdput(part);
-		}
+		devt = part_devt(dev_to_disk(dev),
+				 dev_to_bdev(dev)->bd_partno + offset);
 	} else {
 		devt = dev->devt;
 	}
-- 
2.30.2

