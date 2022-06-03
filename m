Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9EF0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 05:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbiFCFXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 01:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiFCFXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 01:23:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14752BC2;
        Thu,  2 Jun 2022 22:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hMNctlx+C66dPDqtUr9DILwv+HtGnQVmz4/en1tCu3E=; b=me3pRb2Oetizv3pqhXyy556Bt9
        shNgHObeiTTHcnogYnbEjnVLmya3FVfkGq16GfT2+FkARAcDV479AE57ik/mye1ySwhOojq6LY5sT
        lUmSkn+7HCEJPWTzz9Z3ilSkMSK1J4ueT/kBbTllD3L+QtzYj1UE72lYhcwesZ8+Ler8GE+/8/tcB
        HDR0VCO2g3HfcdIa061k3v663g1l0JJKkD7GNYiV+hVf5+A3RmmQWrsqof8XrDcQx2zi2pUuWEVI+
        0G+lXpthYpz0A0A+TlGOVbbNHQ3r/S9kWJT9IpUTrL6VSCbld6PCJBDlnH2UM3dGEUyMFfurzLrOT
        2Dcrx5XA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwzmd-005tSF-L0; Fri, 03 Jun 2022 05:23:39 +0000
Date:   Thu, 2 Jun 2022 22:23:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Tyler Erickson <tyler.erickson@seagate.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, muhammad.ahmad@seagate.com
Subject: Re: [PATCH v2 0/3] ata,sd: Fix reading concurrent positioning ranges
Message-ID: <Ypma2xNMaHYJflNx@infradead.org>
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
 <d3cc3cff-b483-b2dd-b6eb-131500b97d54@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3cc3cff-b483-b2dd-b6eb-131500b97d54@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 03, 2022 at 10:30:04AM +0900, Damien Le Moal wrote:
> Looks all good to me. I tested this and really wonder how I did not catch
> these mistakes earlier :)
> 
> Using a tcmu emulator for various concurrent positioning range configs to
> test, I got a lockdep splat when unplugging the drive:

You probably want something like this:

---
From 4340b85be3532149310326b5f0caf329e1f4c748 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Mon, 23 May 2022 09:18:44 +0200
Subject: block: don't take sysfs_lock in blk_ia_range_sysfs_show

sysfs already synchronizes internally against kobject removal, so remove
the extra lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-ia-ranges.c  | 8 +-------
 include/linux/blkdev.h | 1 -
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/block/blk-ia-ranges.c b/block/blk-ia-ranges.c
index 853be76b9808b..e9e7ebf02737f 100644
--- a/block/blk-ia-ranges.c
+++ b/block/blk-ia-ranges.c
@@ -54,13 +54,8 @@ static ssize_t blk_ia_range_sysfs_show(struct kobject *kobj,
 		container_of(attr, struct blk_ia_range_sysfs_entry, attr);
 	struct blk_independent_access_range *iar =
 		container_of(kobj, struct blk_independent_access_range, kobj);
-	ssize_t ret;
 
-	mutex_lock(&iar->queue->sysfs_lock);
-	ret = entry->show(iar, buf);
-	mutex_unlock(&iar->queue->sysfs_lock);
-
-	return ret;
+	return entry->show(iar, buf);
 }
 
 static const struct sysfs_ops blk_ia_range_sysfs_ops = {
@@ -149,7 +144,6 @@ int disk_register_independent_access_ranges(struct gendisk *disk,
 	}
 
 	for (i = 0; i < iars->nr_ia_ranges; i++) {
-		iars->ia_range[i].queue = q;
 		ret = kobject_init_and_add(&iars->ia_range[i].kobj,
 					   &blk_ia_range_ktype, &iars->kobj,
 					   "%d", i);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a72203ed25454..0ceb85ca52af4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -348,7 +348,6 @@ static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
  */
 struct blk_independent_access_range {
 	struct kobject		kobj;
-	struct request_queue	*queue;
 	sector_t		sector;
 	sector_t		nr_sectors;
 };
-- 
2.30.2

