Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0B8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 14:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbiEYOgQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 10:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbiEYOgO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 10:36:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5419B2CDD4
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 07:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653489372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7eghtolzwl0drnd0tYSGSUnL+HRSRExNXVsg8ngNKhI=;
        b=BA+D+si3XTPdCuFCn/S2fbtI2WxLHQeY0RHXU3OVry9YSChqVMTgxKizK9uxZHpbAqB7ug
        KE3qXd6vMgRE5HmrARKCBVlNeEn0D61f72ucaR2MCgrPbYQqRKUc4Gfk3Q1TrxMDUyXWPI
        Ekdv0IXi4lcFMg2GJ/kozW15gW5DM78=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-dH-7GMT3P1Wh4rOdr0nFOg-1; Wed, 25 May 2022 10:36:07 -0400
X-MC-Unique: dH-7GMT3P1Wh4rOdr0nFOg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE8161C00ACB;
        Wed, 25 May 2022 14:36:06 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 90B35112131B;
        Wed, 25 May 2022 14:36:01 +0000 (UTC)
Date:   Wed, 25 May 2022 22:35:56 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 11/14] block: remove GENHD_FL_EXT_DEVT
Message-ID: <Yo4+zEnrBTnoEMCz@T590>
References: <20211122130625.1136848-1-hch@lst.de>
 <20211122130625.1136848-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122130625.1136848-12-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

On Mon, Nov 22, 2021 at 02:06:22PM +0100, Christoph Hellwig wrote:
> All modern drivers can support extra partitions using the extended
> dev_t.  In fact except for the ioctl method drivers never even see
> partitions in normal operation.
> 
> So remove the GENHD_FL_EXT_DEVT and allow extra partitions for all
> block devices that do support partitions, and require those that
> do not support partitions to explicit disallow them using
> GENHD_FL_NO_PART.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/genhd.c                  |  6 +++---
>  block/partitions/core.c        |  9 ++++-----
>  drivers/block/amiflop.c        |  1 +
>  drivers/block/ataflop.c        |  1 +
>  drivers/block/brd.c            |  1 -
>  drivers/block/drbd/drbd_main.c |  1 +
>  drivers/block/floppy.c         |  1 +
>  drivers/block/loop.c           |  1 -
>  drivers/block/null_blk/main.c  |  1 -
>  drivers/block/paride/pcd.c     |  1 +
>  drivers/block/paride/pf.c      |  1 +
>  drivers/block/pktcdvd.c        |  2 +-
>  drivers/block/ps3vram.c        |  1 +
>  drivers/block/rbd.c            |  6 ++----
>  drivers/block/swim.c           |  1 +
>  drivers/block/swim3.c          |  2 +-
>  drivers/block/virtio_blk.c     |  1 -
>  drivers/block/z2ram.c          |  1 +
>  drivers/block/zram/zram_drv.c  |  1 +
>  drivers/cdrom/gdrom.c          |  1 +
>  drivers/md/dm.c                |  1 +
>  drivers/md/md.c                |  5 -----
>  drivers/mmc/core/block.c       |  1 -
>  drivers/mtd/ubi/block.c        |  1 +
>  drivers/scsi/sd.c              |  1 -
>  drivers/scsi/sr.c              |  1 +
>  include/linux/genhd.h          | 28 +++++-----------------------
>  27 files changed, 30 insertions(+), 48 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 09abd41249fd4..e9346fae48ad4 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -376,7 +376,7 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
>  {
>  	struct block_device *bdev;
>  
> -	if (!disk_part_scan_enabled(disk))
> +	if (disk->flags & GENHD_FL_NO_PART)
>  		return -EINVAL;
>  	if (disk->open_partitions)
>  		return -EBUSY;
> @@ -438,7 +438,6 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
>  			return ret;
>  		disk->major = BLOCK_EXT_MAJOR;
>  		disk->first_minor = ret;
> -		disk->flags |= GENHD_FL_EXT_DEVT;
>  	}
>  
>  	ret = disk_alloc_events(disk);
> @@ -872,7 +871,8 @@ static ssize_t disk_ext_range_show(struct device *dev,
>  {
>  	struct gendisk *disk = dev_to_disk(dev);
>  
> -	return sprintf(buf, "%d\n", disk_max_parts(disk));
> +	return sprintf(buf, "%d\n",
> +		(disk->flags & GENHD_FL_NO_PART) ? 1 : DISK_MAX_PARTS);

The above change breaks parted on loop, which reads 'ext_range' to add
partitions.

Follows the test case:

	fallocate -l 4096M loop0.img
	losetup /dev/loop0 loop0.img
	parted -s /dev/loop0 mklabel MSDOS
	parted -s /dev/loop0 mkpart pri 1 1248

Since this patch is merged, /dev/loop0p1 can't be created any more
by above script.



Thanks,
Ming

