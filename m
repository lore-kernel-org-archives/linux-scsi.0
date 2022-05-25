Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80489C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 16:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245488AbiEYQvX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 12:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243615AbiEYQvU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 12:51:20 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54D52180B;
        Wed, 25 May 2022 09:51:18 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id EA42467373; Wed, 25 May 2022 18:51:14 +0200 (CEST)
Date:   Wed, 25 May 2022 18:51:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 11/14] block: remove GENHD_FL_EXT_DEVT
Message-ID: <20220525165114.GA2750@lst.de>
References: <20211122130625.1136848-1-hch@lst.de> <20211122130625.1136848-12-hch@lst.de> <Yo4+zEnrBTnoEMCz@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo4+zEnrBTnoEMCz@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 25, 2022 at 10:35:56PM +0800, Ming Lei wrote:
> > @@ -872,7 +871,8 @@ static ssize_t disk_ext_range_show(struct device *dev,
> >  {
> >  	struct gendisk *disk = dev_to_disk(dev);
> >  
> > -	return sprintf(buf, "%d\n", disk_max_parts(disk));
> > +	return sprintf(buf, "%d\n",
>
>
> The above change breaks parted on loop, which reads 'ext_range' to add
> partitions.

That change alone is not the one breaking it alone, as even if the
file reported something else you still could not create new partitions.

Something like the test below should fix it, but I'll need some more
time to actually test it:

diff --git a/block/genhd.c b/block/genhd.c
index 36532b9318419..27205ae47d593 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -385,6 +385,8 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 
 	if (disk->flags & (GENHD_FL_NO_PART | GENHD_FL_HIDDEN))
 		return -EINVAL;
+	if (test_bit(GD_SUPPRESS_PART_SCAN, &disk->state))
+		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index e2cb51810e89a..5bef97ffbe21e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1102,7 +1102,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN;
 	if (partscan)
-		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
+		clear_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 
 	loop_global_unlock(lo, is_loop);
 	if (partscan)
@@ -1198,7 +1198,7 @@ static void __loop_clr_fd(struct loop_device *lo, bool release)
 	 */
 	lo->lo_flags = 0;
 	if (!part_shift)
-		lo->lo_disk->flags |= GENHD_FL_NO_PART;
+		set_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 	mutex_lock(&lo->lo_mutex);
 	lo->lo_state = Lo_unbound;
 	mutex_unlock(&lo->lo_mutex);
@@ -1308,7 +1308,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (!err && (lo->lo_flags & LO_FLAGS_PARTSCAN) &&
 	     !(prev_lo_flags & LO_FLAGS_PARTSCAN)) {
-		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
+		clear_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 		partscan = true;
 	}
 out_unlock:
@@ -2011,7 +2011,7 @@ static int loop_add(int i)
 	 * userspace tools. Parameters like this in general should be avoided.
 	 */
 	if (!part_shift)
-		disk->flags |= GENHD_FL_NO_PART;
+		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
 	mutex_init(&lo->lo_mutex);
 	lo->lo_number		= i;
 	spin_lock_init(&lo->lo_lock);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1b24c1fb3bb1e..bf0c85cfdd8bf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -147,6 +147,7 @@ struct gendisk {
 #define GD_DEAD				2
 #define GD_NATIVE_CAPACITY		3
 #define GD_ADDED			4
+#define GD_SUPPRESS_PART_SCAN		4
 
 	struct mutex open_mutex;	/* open/close mutex */
 	unsigned open_partitions;	/* number of open partitions */
