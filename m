Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECADC47E49
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 12:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3C77214B2
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 12:23:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=javigon-com.20150623.gappssmtp.com header.i=@javigon-com.20150623.gappssmtp.com header.b="sQDjpAoA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbfJ2MXM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 08:23:12 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46429 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfJ2MXM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 08:23:12 -0400
Received: by mail-lj1-f195.google.com with SMTP id w8so10520285lji.13
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2019 05:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ufn9ULK4alp8KGYQ8RskQvdcv1NNkrdsXDvgI32jKa8=;
        b=sQDjpAoAVRG29yQt6RAWdFK5j/xVgLvUh2dJQXSCnZ7Lr4eRMpdPmcJAdLs1yc7ATA
         tnyKzygwfaTb1bV05NTJhyHM2yaXLPkRYNpYb5/A6GKCEnJMyGePChceol+ScgsfsR89
         wyjy6+H6J5yHTNICaAjkByjYRw92KRKdurRdeyeyr1fO3dWVxeNU5Jq41NwMxunj6K7V
         OxshM9Wkjtec8qCO9qOxP9f44J3DlzuaWsVU2yr9C19J7+1JH98iMLHceoKt4v6MgqEJ
         /sO+jVitC4/IPPBp6TQehyIu2Sk3fHVemtyXCQzVeZIi6d8IHNodYlbv717QeUeRrEkU
         Qe6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ufn9ULK4alp8KGYQ8RskQvdcv1NNkrdsXDvgI32jKa8=;
        b=qMZ13QoKPCNn8Yq0ewJH2WyMICBpN/SPGkYceucTjAB9ekB6jKjIbsvdsZUptU7VRg
         N4mZjj6QNaPk7FPzaGJxta2J9wTnWukDFUBYspLQhFQHEJKJCD8OM1sL6mDPbrlEhUUX
         ENQw49UhD33pReWtILD0jHWIZb5iFY9F+PxXyQ4iOOaqlyS8hhfI7kVBlwRnt+QqytRT
         1eNIvZ7hzEaFU2T6aKAd/2d03JTSWzzV6ah3B0j3IiCINAkmTyx5LvmIT1940FyibjqW
         gJuuKPUToMRKXl9RTX4cx4zcmjzVtiDkYq+Wx3vd6/0JeenH01WurSmxetxGgkTvFK6N
         dO4w==
X-Gm-Message-State: APjAAAUnjdEhmUUxFx1JsboF55zPWgFfaS5B4xYpgqjcv+GnuKBkwCx3
        Ks7/KLgwzTyjS+9iMEqv9ZBCSQ==
X-Google-Smtp-Source: APXvYqwFY4bAuNFZjlVfT9ZTCXgsa+d/BJsH3OK4suQ/8lncLWjF2JIEbaSZ/oExYCro8OO+kztNzw==
X-Received: by 2002:a2e:868d:: with SMTP id l13mr2499823lji.136.1572351788166;
        Tue, 29 Oct 2019 05:23:08 -0700 (PDT)
Received: from localhost ([194.62.217.57])
        by smtp.gmail.com with ESMTPSA id z15sm12034717ljb.24.2019.10.29.05.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 05:23:07 -0700 (PDT)
Date:   Tue, 29 Oct 2019 13:23:06 +0100
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
Subject: Re: [PATCH 5/8] block: add zone open, close and finish ioctl support
Message-ID: <20191029122306.aqly5g3xrzndf7cy@MacBook-Pro.gnusmas>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <20191027140549.26272-6-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191027140549.26272-6-damien.lemoal@wdc.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27.10.2019 23:05, Damien Le Moal wrote:
>From: Ajay Joshi <ajay.joshi@wdc.com>
>
>Introduce three new ioctl commands BLKOPENZONE, BLKCLOSEZONE and
>BLKFINISHZONE to allow applications to control the condition of zones
>on a zoned block device through the execution of the REQ_OP_ZONE_OPEN,
>REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH operations.
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
> block/blk-zoned.c             | 28 +++++++++++++++++++++++-----
> block/ioctl.c                 |  5 ++++-
> include/linux/blkdev.h        | 10 +++++-----
> include/uapi/linux/blkzoned.h | 17 ++++++++++++++---
> 4 files changed, 46 insertions(+), 14 deletions(-)
>
>diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>index dab34dc48fb6..481eaf7d04d4 100644
>--- a/block/blk-zoned.c
>+++ b/block/blk-zoned.c
>@@ -357,15 +357,16 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
> }
>
> /*
>- * BLKRESETZONE ioctl processing.
>+ * BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE and BLKFINISHZONE ioctl processing.
>  * Called from blkdev_ioctl.
>  */
>-int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
>-			     unsigned int cmd, unsigned long arg)
>+int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>+			   unsigned int cmd, unsigned long arg)
> {
> 	void __user *argp = (void __user *)arg;
> 	struct request_queue *q;
> 	struct blk_zone_range zrange;
>+	enum req_opf op;
>
> 	if (!argp)
> 		return -EINVAL;
>@@ -386,8 +387,25 @@ int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
> 	if (copy_from_user(&zrange, argp, sizeof(struct blk_zone_range)))
> 		return -EFAULT;
>
>-	return blkdev_zone_mgmt(bdev, REQ_OP_ZONE_RESET,
>-				zrange.sector, zrange.nr_sectors, GFP_KERNEL);
>+	switch (cmd) {
>+	case BLKRESETZONE:
>+		op = REQ_OP_ZONE_RESET;
>+		break;
>+	case BLKOPENZONE:
>+		op = REQ_OP_ZONE_OPEN;
>+		break;
>+	case BLKCLOSEZONE:
>+		op = REQ_OP_ZONE_CLOSE;
>+		break;
>+	case BLKFINISHZONE:
>+		op = REQ_OP_ZONE_FINISH;
>+		break;
>+	default:
>+		return -ENOTTY;
>+	}
>+
>+	return blkdev_zone_mgmt(bdev, op, zrange.sector, zrange.nr_sectors,
>+				GFP_KERNEL);
> }
>
> static inline unsigned long *blk_alloc_zone_bitmap(int node,
>diff --git a/block/ioctl.c b/block/ioctl.c
>index 15a0eb80ada9..8756efb1419e 100644
>--- a/block/ioctl.c
>+++ b/block/ioctl.c
>@@ -532,7 +532,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
> 	case BLKREPORTZONE:
> 		return blkdev_report_zones_ioctl(bdev, mode, cmd, arg);
> 	case BLKRESETZONE:
>-		return blkdev_reset_zones_ioctl(bdev, mode, cmd, arg);
>+	case BLKOPENZONE:
>+	case BLKCLOSEZONE:
>+	case BLKFINISHZONE:
>+		return blkdev_zone_mgmt_ioctl(bdev, mode, cmd, arg);
> 	case BLKGETZONESZ:
> 		return put_uint(arg, bdev_zone_sectors(bdev));
> 	case BLKGETNRZONES:
>diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>index bf797a63388c..dbef541c2530 100644
>--- a/include/linux/blkdev.h
>+++ b/include/linux/blkdev.h
>@@ -367,8 +367,8 @@ extern int blk_revalidate_disk_zones(struct gendisk *disk);
>
> extern int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
> 				     unsigned int cmd, unsigned long arg);
>-extern int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
>-				    unsigned int cmd, unsigned long arg);
>+extern int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>+				  unsigned int cmd, unsigned long arg);
>
> #else /* CONFIG_BLK_DEV_ZONED */
>
>@@ -389,9 +389,9 @@ static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
> 	return -ENOTTY;
> }
>
>-static inline int blkdev_reset_zones_ioctl(struct block_device *bdev,
>-					   fmode_t mode, unsigned int cmd,
>-					   unsigned long arg)
>+static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
>+					 fmode_t mode, unsigned int cmd,
>+					 unsigned long arg)
> {
> 	return -ENOTTY;
> }
>diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
>index 498eec813494..0cdef67135f0 100644
>--- a/include/uapi/linux/blkzoned.h
>+++ b/include/uapi/linux/blkzoned.h
>@@ -120,9 +120,11 @@ struct blk_zone_report {
> };
>
> /**
>- * struct blk_zone_range - BLKRESETZONE ioctl request
>- * @sector: starting sector of the first zone to issue reset write pointer
>- * @nr_sectors: Total number of sectors of 1 or more zones to reset
>+ * struct blk_zone_range - BLKRESETZONE/BLKOPENZONE/
>+ *                         BLKCLOSEZONE/BLKFINISHZONE ioctl
>+ *                         requests
>+ * @sector: Starting sector of the first zone to operate on.
>+ * @nr_sectors: Total number of sectors of all zones to operate on.
>  */
> struct blk_zone_range {
> 	__u64		sector;
>@@ -139,10 +141,19 @@ struct blk_zone_range {
>  *                sector range. The sector range must be zone aligned.
>  * @BLKGETZONESZ: Get the device zone size in number of 512 B sectors.
>  * @BLKGETNRZONES: Get the total number of zones of the device.
>+ * @BLKOPENZONE: Open the zones in the specified sector range.
>+ *               The 512 B sector range must be zone aligned.
>+ * @BLKCLOSEZONE: Close the zones in the specified sector range.
>+ *                The 512 B sector range must be zone aligned.
>+ * @BLKFINISHZONE: Mark the zones as full in the specified sector range.
>+ *                 The 512 B sector range must be zone aligned.
>  */
> #define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)
> #define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)
> #define BLKGETZONESZ	_IOR(0x12, 132, __u32)
> #define BLKGETNRZONES	_IOR(0x12, 133, __u32)
>+#define BLKOPENZONE	_IOW(0x12, 134, struct blk_zone_range)
>+#define BLKCLOSEZONE	_IOW(0x12, 135, struct blk_zone_range)
>+#define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
>
> #endif /* _UAPI_BLKZONED_H */
>-- 
>2.21.0
>

Looks good.

Reviewed-by: Javier González <javier@javigon.com>
