Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850B7CA9EC4
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 12:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4780121479
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 12:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=javigon-com.20150623.gappssmtp.com header.i=@javigon-com.20150623.gappssmtp.com header.b="Kwcn7lR7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfJ2MX3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 08:23:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45486 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbfJ2MX3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 08:23:29 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so14990747ljb.12
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2019 05:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=qu3mCYjooFBx3XIhkssdRQFyNsaAyusNnXYMgENon0Y=;
        b=Kwcn7lR7ent6yPLmKOvpYiR66CTX3GbR3s5YPPjBA/bkzJoGYvoL0M8LkAlX2xeWDg
         g1w+enT698BMvCsoh8UwB3fIB8Wy8mqtqNDoTIfgm667EuO28eyshRKASKZnFEIx0lIy
         TRkf0utHJqcy3qwDSqkUVQW3hj6jAzeWa/ZKE0Qr80EC29j2BKT6pqLxeb+mGtKHcrVd
         0AmXYmU2pAjzbZCutbxpf/Wc1VsUSIW8Eqx+I2EmCSVuyiB5T6a+HIL3883C1zlswUmY
         ZepSe0Qc89aMYvz8RwK5/U7a6WvRJAsWbh2WNVhykirULzUpyjHHdj9wNtIhoqJ7nCLA
         MqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=qu3mCYjooFBx3XIhkssdRQFyNsaAyusNnXYMgENon0Y=;
        b=EgdZU1OKTuYxhpwgDOKcUjU/370u6+6kSL9oq0cPOMAd/beUu112Ylw3mRcRK7WWEi
         NQ/qQa88iGMdvsdfMcpH0i5PfMDzV+offkizSuDWIAvo6yQ/Gpi76QzSVhODbkr6ty/b
         Xr0xJegyiYJWi12DHGUBYsqCDn6sJ1PceM5VjMD3+IG4HxJMHicUaLcsjA9EnOq2keCT
         9N5M5KmxCATGglek0U+pUmyHFwa4Vpb2bWw2VrfiMDx3ObPe6XoMQpPFr70ELuM1WuCV
         hBPl07wFHsbMgkKOSrdYcDMnoVWv8pQ2h+ae1k3SlVDoykaUFZhinVWBqfMG7/xxc1dX
         4N3w==
X-Gm-Message-State: APjAAAWcAao0JBQiwiWndKXnGDetwXWI+Uda1x4mPwCK+IsdrOLWXoOV
        L+MS5Q5PKIZD2ChRgc3B/0DtQA==
X-Google-Smtp-Source: APXvYqzJHA5aOjAtjzgMaMt8+erfRC6pxd5JHjpYnjnm8VpDn9Q9MxVUbUDnweYpxRkzsctYY3JODw==
X-Received: by 2002:a2e:87c9:: with SMTP id v9mr2401154ljj.65.1572351806544;
        Tue, 29 Oct 2019 05:23:26 -0700 (PDT)
Received: from localhost ([194.62.217.57])
        by smtp.gmail.com with ESMTPSA id 12sm11221179lje.92.2019.10.29.05.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 05:23:25 -0700 (PDT)
Date:   Tue, 29 Oct 2019 13:23:25 +0100
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Matias Bjorling <matias.bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 4/8] block: add zone open, close and finish operations
Message-ID: <20191029122325.eb74idotzywiw7dv@MacBook-Pro.gnusmas>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <20191027140549.26272-5-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191027140549.26272-5-damien.lemoal@wdc.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27.10.2019 23:05, Damien Le Moal wrote:
>From: Ajay Joshi <ajay.joshi@wdc.com>
>
>Zoned block devices (ZBC and ZAC devices) allow an explicit control
>over the condition (state) of zones. The operations allowed are:
>* Open a zone: Transition to open condition to indicate that a zone will
>  actively be written
>* Close a zone: Transition to closed condition to release the drive
>  resources used for writing to a zone
>* Finish a zone: Transition an open or closed zone to the full
>  condition to prevent write operations
>
>To enable this control for in-kernel zoned block device users, define
>the new request operations REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE
>and REQ_OP_ZONE_FINISH as well as the generic function
>blkdev_zone_mgmt() for submitting these operations on a range of zones.
>This results in blkdev_reset_zones() removal and replacement with this
>new zone magement function. Users of blkdev_reset_zones() (f2fs and
>dm-zoned) are updated accordingly.
>
>Contains contributions from Matias Bjorling, Hans Holmberg,
>Dmitry Fomichev, Keith Busch, Damien Le Moal and Christoph Hellwig.
>
>Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
>Signed-off-by: Matias Bjorling <matias.bjorling@wdc.com>
>Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
>Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
>Signed-off-by: Keith Busch <kbusch@kernel.org>
>Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>---
> block/blk-core.c               | 12 +++++++++---
> block/blk-zoned.c              | 35 ++++++++++++++++++++--------------
> drivers/md/dm-zoned-metadata.c |  6 +++---
> fs/f2fs/segment.c              |  3 ++-
> include/linux/blk_types.h      | 25 ++++++++++++++++++++++++
> include/linux/blkdev.h         |  5 +++--
> 6 files changed, 63 insertions(+), 23 deletions(-)
>
>diff --git a/block/blk-core.c b/block/blk-core.c
>index d5e668ec751b..3306a3c5bed6 100644
>--- a/block/blk-core.c
>+++ b/block/blk-core.c
>@@ -132,6 +132,9 @@ static const char *const blk_op_name[] = {
> 	REQ_OP_NAME(SECURE_ERASE),
> 	REQ_OP_NAME(ZONE_RESET),
> 	REQ_OP_NAME(ZONE_RESET_ALL),
>+	REQ_OP_NAME(ZONE_OPEN),
>+	REQ_OP_NAME(ZONE_CLOSE),
>+	REQ_OP_NAME(ZONE_FINISH),
> 	REQ_OP_NAME(WRITE_SAME),
> 	REQ_OP_NAME(WRITE_ZEROES),
> 	REQ_OP_NAME(SCSI_IN),
>@@ -849,10 +852,10 @@ static inline int blk_partition_remap(struct bio *bio)
> 		goto out;
>
> 	/*
>-	 * Zone reset does not include bi_size so bio_sectors() is always 0.
>-	 * Include a test for the reset op code and perform the remap if needed.
>+	 * Zone management bios do not have a sector count but they do have
>+	 * a start sector filled out and need to be remapped.
> 	 */
>-	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET) {
>+	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio))) {
> 		if (bio_check_eod(bio, part_nr_sects_read(p)))
> 			goto out;
> 		bio->bi_iter.bi_sector += p->start_sect;
>@@ -936,6 +939,9 @@ generic_make_request_checks(struct bio *bio)
> 			goto not_supported;
> 		break;
> 	case REQ_OP_ZONE_RESET:
>+	case REQ_OP_ZONE_OPEN:
>+	case REQ_OP_ZONE_CLOSE:
>+	case REQ_OP_ZONE_FINISH:
> 		if (!blk_queue_is_zoned(q))
> 			goto not_supported;
> 		break;
>diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>index 14785011e798..dab34dc48fb6 100644
>--- a/block/blk-zoned.c
>+++ b/block/blk-zoned.c
>@@ -221,23 +221,27 @@ static inline bool blkdev_allow_reset_all_zones(struct block_device *bdev,
> }
>
> /**
>- * blkdev_reset_zones - Reset zones write pointer
>+ * blkdev_zone_mgmt - Execute a zone management operation on a range of zones
>  * @bdev:	Target block device
>- * @sector:	Start sector of the first zone to reset
>- * @nr_sectors:	Number of sectors, at least the length of one zone
>+ * @op:		Operation to be performed on the zones
>+ * @sector:	Start sector of the first zone to operate on
>+ * @nr_sectors:	Number of sectors, should be at least the length of one zone and
>+ *		must be zone size aligned.
>  * @gfp_mask:	Memory allocation flags (for bio_alloc)
>  *
>  * Description:
>- *    Reset the write pointer of the zones contained in the range
>+ *    Perform the specified operation on the range of zones specified by
>  *    @sector..@sector+@nr_sectors. Specifying the entire disk sector range
>  *    is valid, but the specified range should not contain conventional zones.
>+ *    The operation to execute on each zone can be a zone reset, open, close
>+ *    or finish request.
>  */
>-int blkdev_reset_zones(struct block_device *bdev,
>-		       sector_t sector, sector_t nr_sectors,
>-		       gfp_t gfp_mask)
>+int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>+		     sector_t sector, sector_t nr_sectors,
>+		     gfp_t gfp_mask)
> {
> 	struct request_queue *q = bdev_get_queue(bdev);
>-	sector_t zone_sectors;
>+	sector_t zone_sectors = blk_queue_zone_sectors(q);
> 	sector_t end_sector = sector + nr_sectors;
> 	struct bio *bio = NULL;
> 	int ret;
>@@ -248,12 +252,14 @@ int blkdev_reset_zones(struct block_device *bdev,
> 	if (bdev_read_only(bdev))
> 		return -EPERM;
>
>+	if (!op_is_zone_mgmt(op))
>+		return -EOPNOTSUPP;
>+
> 	if (!nr_sectors || end_sector > bdev->bd_part->nr_sects)
> 		/* Out of range */
> 		return -EINVAL;
>
> 	/* Check alignment (handle eventual smaller last zone) */
>-	zone_sectors = blk_queue_zone_sectors(q);
> 	if (sector & (zone_sectors - 1))
> 		return -EINVAL;
>
>@@ -269,12 +275,13 @@ int blkdev_reset_zones(struct block_device *bdev,
> 		 * Special case for the zone reset operation that reset all
> 		 * zones, this is useful for applications like mkfs.
> 		 */
>-		if (blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {
>+		if (op == REQ_OP_ZONE_RESET &&
>+		    blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {
> 			bio->bi_opf = REQ_OP_ZONE_RESET_ALL;
> 			break;
> 		}
>
>-		bio->bi_opf = REQ_OP_ZONE_RESET;
>+		bio->bi_opf = op;
> 		bio->bi_iter.bi_sector = sector;
> 		sector += zone_sectors;
>
>@@ -287,7 +294,7 @@ int blkdev_reset_zones(struct block_device *bdev,
>
> 	return ret;
> }
>-EXPORT_SYMBOL_GPL(blkdev_reset_zones);
>+EXPORT_SYMBOL_GPL(blkdev_zone_mgmt);
>
> /*
>  * BLKREPORTZONE ioctl processing.
>@@ -379,8 +386,8 @@ int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
> 	if (copy_from_user(&zrange, argp, sizeof(struct blk_zone_range)))
> 		return -EFAULT;
>
>-	return blkdev_reset_zones(bdev, zrange.sector, zrange.nr_sectors,
>-				  GFP_KERNEL);
>+	return blkdev_zone_mgmt(bdev, REQ_OP_ZONE_RESET,
>+				zrange.sector, zrange.nr_sectors, GFP_KERNEL);
> }
>
> static inline unsigned long *blk_alloc_zone_bitmap(int node,
>diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
>index 595a73110e17..feb4718ce6a6 100644
>--- a/drivers/md/dm-zoned-metadata.c
>+++ b/drivers/md/dm-zoned-metadata.c
>@@ -1312,9 +1312,9 @@ static int dmz_reset_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
> 	if (!dmz_is_empty(zone) || dmz_seq_write_err(zone)) {
> 		struct dmz_dev *dev = zmd->dev;
>
>-		ret = blkdev_reset_zones(dev->bdev,
>-					 dmz_start_sect(zmd, zone),
>-					 dev->zone_nr_sectors, GFP_NOIO);
>+		ret = blkdev_zone_mgmt(dev->bdev, REQ_OP_ZONE_RESET,
>+				       dmz_start_sect(zmd, zone),
>+				       dev->zone_nr_sectors, GFP_NOIO);
> 		if (ret) {
> 			dmz_dev_err(dev, "Reset zone %u failed %d",
> 				    dmz_id(zmd, zone), ret);
>diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
>index 808709581481..2c997f94a3b2 100644
>--- a/fs/f2fs/segment.c
>+++ b/fs/f2fs/segment.c
>@@ -1771,7 +1771,8 @@ static int __f2fs_issue_discard_zone(struct f2fs_sb_info *sbi,
> 			return -EIO;
> 		}
> 		trace_f2fs_issue_reset_zone(bdev, blkstart);
>-		return blkdev_reset_zones(bdev, sector, nr_sects, GFP_NOFS);
>+		return blkdev_zone_mgmt(bdev, REQ_OP_ZONE_RESET,
>+					sector, nr_sects, GFP_NOFS);
> 	}
>
> 	/* For conventional zones, use regular discard if supported */
>diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>index d688b96d1d63..805d0efa2997 100644
>--- a/include/linux/blk_types.h
>+++ b/include/linux/blk_types.h
>@@ -290,6 +290,12 @@ enum req_opf {
> 	REQ_OP_ZONE_RESET_ALL	= 8,
> 	/* write the zero filled sector many times */
> 	REQ_OP_WRITE_ZEROES	= 9,
>+	/* Open a zone */
>+	REQ_OP_ZONE_OPEN	= 10,
>+	/* Close a zone */
>+	REQ_OP_ZONE_CLOSE	= 11,
>+	/* Transition a zone to full */
>+	REQ_OP_ZONE_FINISH	= 12,
>
> 	/* SCSI passthrough using struct scsi_request */
> 	REQ_OP_SCSI_IN		= 32,
>@@ -417,6 +423,25 @@ static inline bool op_is_discard(unsigned int op)
> 	return (op & REQ_OP_MASK) == REQ_OP_DISCARD;
> }
>
>+/*
>+ * Check if a bio or request operation is a zone management operation, with
>+ * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a special case
>+ * due to its different handling in the block layer and device response in
>+ * case of command failure.
>+ */
>+static inline bool op_is_zone_mgmt(enum req_opf op)
>+{
>+	switch (op & REQ_OP_MASK) {
>+	case REQ_OP_ZONE_RESET:
>+	case REQ_OP_ZONE_OPEN:
>+	case REQ_OP_ZONE_CLOSE:
>+	case REQ_OP_ZONE_FINISH:
>+		return true;
>+	default:
>+		return false;
>+	}
>+}
>+
> static inline int op_stat_group(unsigned int op)
> {
> 	if (op_is_discard(op))
>diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>index f3ea78b0c91c..bf797a63388c 100644
>--- a/include/linux/blkdev.h
>+++ b/include/linux/blkdev.h
>@@ -360,8 +360,9 @@ extern unsigned int blkdev_nr_zones(struct block_device *bdev);
> extern int blkdev_report_zones(struct block_device *bdev,
> 			       sector_t sector, struct blk_zone *zones,
> 			       unsigned int *nr_zones);
>-extern int blkdev_reset_zones(struct block_device *bdev, sector_t sectors,
>-			      sector_t nr_sectors, gfp_t gfp_mask);
>+extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>+			    sector_t sectors, sector_t nr_sectors,
>+			    gfp_t gfp_mask);
> extern int blk_revalidate_disk_zones(struct gendisk *disk);
>
> extern int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
>-- 
>2.21.0
>

Looks good.

Reviewed-by: Javier González <javier@javigon.com>
