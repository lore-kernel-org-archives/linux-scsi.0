Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7B7C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 12:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D564E61186
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 12:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhKCMZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 08:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbhKCMYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 08:24:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09408C061203;
        Wed,  3 Nov 2021 05:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vOO0FvJ024arCNbvUF88TfdBl4E9VfDYArY2MspVEbQ=; b=lbx51LbE6J4UzCOCSyQ9rd+wv4
        MgUKh3R1jZLwy8fwPPdyVsoY4Do+o+TUfXkfBfAYcm0rsK7gzbZuHVeQQdexCLrDAQPov5jHX/jmv
        0ddXuODhBPGA7Z/FbsgXfoPq52HHYEhlWgAtiCEOgIx2RPx27OmekvOXrBD8qQ0ZiOAAzQMoUMOn6
        gidzTm4IVuMFSjQcek3WJNNzHa6eJNZY7mqyPppgz/RjJCJSM/wuvyKE8hSU8qm5rb9nIYZ26iaa/
        J85uO5pvPgzv8343oQKmJb2PWkLIG4fk4Hl5bxaBIUmri7e0jFo8zQVuIQMNfI0S6kcLv03tV2qcI
        aw8MxtCg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miFHC-0056IY-Ic; Wed, 03 Nov 2021 12:21:58 +0000
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
Subject: [PATCH v2 13/13] block: add __must_check for *add_disk*() callers
Date:   Wed,  3 Nov 2021 05:21:57 -0700
Message-Id: <20211103122157.1215783-14-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103122157.1215783-1-mcgrof@kernel.org>
References: <20211103122157.1215783-1-mcgrof@kernel.org>
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
index 7b56767e9e32..be4775c13760 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -397,8 +397,8 @@ static void disk_scan_partitions(struct gendisk *disk)
  * This function registers the partitioning information in @disk
  * with the kernel.
  */
-int device_add_disk(struct device *parent, struct gendisk *disk,
-		     const struct attribute_group **groups)
+int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
+				 const struct attribute_group **groups)
 
 {
 	struct device *ddev = disk_to_dev(disk);
@@ -543,7 +543,7 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 out_free_ext_minor:
 	if (disk->major == BLOCK_EXT_MAJOR)
 		blk_free_ext_minor(disk->first_minor);
-	return WARN_ON_ONCE(ret); /* keep until all callers handle errors */
+	return ret;
 }
 EXPORT_SYMBOL(device_add_disk);
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 016623245725..526ec4aaf85c 100644
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

