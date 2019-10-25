Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4617CA9EBD
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 05:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD58620867
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 05:17:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=javigon-com.20150623.gappssmtp.com header.i=@javigon-com.20150623.gappssmtp.com header.b="WRpFeSIU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392755AbfJYFRx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:17:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53210 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392744AbfJYFRx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 01:17:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id p21so610932wmg.2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2019 22:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ypC8lgM3/Rt15xyp/AJsV4lSDdXYCNqSiXTkBhWcg5k=;
        b=WRpFeSIUDfXQGss2uOOMREJrTe2e97m97ts9bz8LoFYg2vpG8qNTCj7UeHfWXabyMj
         cCDikt/DthQvwpJqwrtMJteLkJkFL632bX+Dh0KFIzp9wq3kcua17jYSeWVg6UeQ+2Gp
         MmpvsI4O6T6qqH2lqbVvpU8NYzmq4cQWTgP1MNaKfsAHof8a9R/YtiuTPtA/dgPHfQnK
         SPTk1VLTb80VpQ7MeKZTE8UIqZmmQmPp8RL2/KPLo0DDADnJVB/jZ9Ti6z/XAXivTy+N
         tTyFON4Du2Og8jW2OwJ4oc1PFhc6Ri8tl9Tud2Pp6hw1B0eynhY3B425aIJXQw5iDqtR
         CWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ypC8lgM3/Rt15xyp/AJsV4lSDdXYCNqSiXTkBhWcg5k=;
        b=EhmisBWhMGdqg4EIWgAzGejupeI1NNiaMw3ZYiLd03Mq3DGXTnmhtZ5Aif7l1z5GLu
         66f9R+YUSUX4dkiNdpriXoKaalqv4HkOuiA/vtocGlT6w8jZGjDl+ANR1oaVu4ulvja5
         YyDipnlnmkX2DBOd2kZDQFWcdUUC9PFhJNQ2T4ogGmcXkbcmXdKs/taWObiQ8u5TwPI9
         9nZQTR/EcAl2aOdvXh92xqFRn5GfGDpIeIKEu13orWSDkbU2UvucVzqdksczW60+KtDi
         EAESMSPNUXDtNIifinjA8ZPVJGXlOWwdOFj+442mFbXUtLJkW6vkbAMOVYPSjey7T0t+
         S+bg==
X-Gm-Message-State: APjAAAXaCk8AyiXmiuOyS0nWtUjd6L3O5LwzkM26oFCfJenek12MvnMy
        XgjU5jxsJRPJZTekL5IXOX1gVA==
X-Google-Smtp-Source: APXvYqyWsiwWn2sDNixvTP3mLXZXTjfr7CtNwsbNHer2Tux0Rrk3qMlkCwVEebMfiSMtZ0pG4ncoHw==
X-Received: by 2002:a1c:7406:: with SMTP id p6mr1689534wmc.64.1571980669907;
        Thu, 24 Oct 2019 22:17:49 -0700 (PDT)
Received: from localhost ([194.62.217.57])
        by smtp.gmail.com with ESMTPSA id n11sm1032994wmd.26.2019.10.24.22.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 22:17:49 -0700 (PDT)
Date:   Fri, 25 Oct 2019 07:17:48 +0200
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/4] block: Simplify report zones execution
Message-ID: <20191025051748.2etv67wvb264mn3n@mpHalley>
References: <20191024065006.8684-1-damien.lemoal@wdc.com>
 <20191024065006.8684-3-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191024065006.8684-3-damien.lemoal@wdc.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24.10.2019 15:50, Damien Le Moal wrote:
>All kernel users of blkdev_report_zones() as well as applications use
>through ioctl(BLKZONEREPORT) expect to potentially get less zone
>descriptors than requested. As such, the use of the internal report
>zones command execution loop implemented by blk_report_zones() is
>not necessary and can even be harmful to performance by causing the
>execution of inefficient small zones report command to service the
>reminder of a requested zone array.
>
>This patch removes blk_report_zones(), simplifying the code. Also
>remove a now incorrect comment in dm_blk_report_zones().
>
>Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>---
> block/blk-zoned.c | 34 +++++-----------------------------
> drivers/md/dm.c   |  6 ------
> 2 files changed, 5 insertions(+), 35 deletions(-)
>
>diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>index 293891b7068a..43bfd1be0985 100644
>--- a/block/blk-zoned.c
>+++ b/block/blk-zoned.c
>@@ -119,31 +119,6 @@ static bool blkdev_report_zone(struct block_device *bdev, struct blk_zone *rep)
> 	return true;
> }
>
>-static int blk_report_zones(struct gendisk *disk, sector_t sector,
>-			    struct blk_zone *zones, unsigned int *nr_zones)
>-{
>-	struct request_queue *q = disk->queue;
>-	unsigned int z = 0, n, nrz = *nr_zones;
>-	sector_t capacity = get_capacity(disk);
>-	int ret;
>-
>-	while (z < nrz && sector < capacity) {
>-		n = nrz - z;
>-		ret = disk->fops->report_zones(disk, sector, &zones[z], &n);
>-		if (ret)
>-			return ret;
>-		if (!n)
>-			break;
>-		sector += blk_queue_zone_sectors(q) * n;
>-		z += n;
>-	}
>-
>-	WARN_ON(z > *nr_zones);
>-	*nr_zones = z;
>-
>-	return 0;
>-}
>-
> /**
>  * blkdev_report_zones - Get zones information
>  * @bdev:	Target block device
>@@ -164,6 +139,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
> 			struct blk_zone *zones, unsigned int *nr_zones)
> {
> 	struct request_queue *q = bdev_get_queue(bdev);
>+	struct gendisk *disk = bdev->bd_disk;
> 	unsigned int i, nrz;
> 	int ret;
>
>@@ -175,7 +151,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
> 	 * report_zones method. If it does not have one defined, the device
> 	 * driver has a bug. So warn about that.
> 	 */
>-	if (WARN_ON_ONCE(!bdev->bd_disk->fops->report_zones))
>+	if (WARN_ON_ONCE(!disk->fops->report_zones))
> 		return -EOPNOTSUPP;
>
> 	if (!*nr_zones || sector >= bdev->bd_part->nr_sects) {
>@@ -185,8 +161,8 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
>
> 	nrz = min(*nr_zones,
> 		  __blkdev_nr_zones(q, bdev->bd_part->nr_sects - sector));
>-	ret = blk_report_zones(bdev->bd_disk, get_start_sect(bdev) + sector,
>-			       zones, &nrz);
>+	ret = disk->fops->report_zones(disk, get_start_sect(bdev) + sector,
>+				       zones, &nrz);
> 	if (ret)
> 		return ret;
>
>@@ -552,7 +528,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
>
> 	while (z < nr_zones) {
> 		nrz = min(nr_zones - z, rep_nr_zones);
>-		ret = blk_report_zones(disk, sector, zones, &nrz);
>+		ret = disk->fops->report_zones(disk, sector, zones, &nrz);
> 		if (ret)
> 			goto out;
> 		if (!nrz)
>diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>index 1a5e328c443a..647aa5b0233b 100644
>--- a/drivers/md/dm.c
>+++ b/drivers/md/dm.c
>@@ -473,12 +473,6 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
> 		goto out;
> 	}
>
>-	/*
>-	 * blkdev_report_zones() will loop and call this again to cover all the
>-	 * zones of the target, eventually moving on to the next target.
>-	 * So there is no need to loop here trying to fill the entire array
>-	 * of zones.
>-	 */
> 	ret = tgt->type->report_zones(tgt, sector, zones, nr_zones);
>
> out:
>-- 
>2.21.0
>

Looks good to me.

Reviewed-by: Javier González <javier@javigon.com>
