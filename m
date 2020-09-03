Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020B6C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC589206C0
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RoUq46ul"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgICIU3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgICIUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 04:20:13 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6110DC061249
        for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2020 01:20:12 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id h23so599827vkn.4
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 01:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kIOKgbobCAauivLjjD3+5H4D5uI6eOXaqQyNwWMzaro=;
        b=RoUq46ulZfpZ3paDBrOfHAcAMJ15GQITaSjDmtoXsPqSrrimdeqw0GpvJFItoGcvFb
         DN3wSTWA+C16s3z582YgsfunvLAxRZDsTr7GOPi0wCItVvqXppqiaopIUqFT+5bXl9sd
         NkA+MMJ3XTJ1YlmzoiZSSsVTJtcYmB/DDfVyCaACd0470zyZM8lVLen6FBuOPvoqkM18
         oTXDKFLQokjO0x7S4utPI6uaxClWtFTXDqZKKH6MGw4UoXBCv/Vmgt7u9DnMt43MZ7vb
         tDE1ikGwPpETwpaBATLHw5RLqWeWExa5U8OQfv9hnryx1WaZHqTAbZRRoASZUwwFq8hy
         InLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kIOKgbobCAauivLjjD3+5H4D5uI6eOXaqQyNwWMzaro=;
        b=YmbQqhWLupl5paS0DAaRMsmZLwtBuD0hcVn5jR2jCuRP70VaAKaktzikpn4eSrMyjo
         ZWcdV71KheawfmKUAW0YBUkfk5UTGID/rZILIHw2tzO9FqH7PyUmpD6xwbboOEKp3J8U
         mQgtrrqLwhwt/mRbP74ek9hvfySMhBWu3o/3jf0WlGWckO+ucNgtkJ2TZpRAvofs5KjU
         joYPhBzDx5yYTcq+LTddQX/YY4dePssmMWfouOZcwXNzrIjLMlvFjv3wkMWqVxKF3/zd
         6FwWvwmi20nI5JC9jQhdI69fpsqkz+Y3luVjcBUH7FTfnwPm/uOu64FJnZOIuYLiQT1g
         SWaA==
X-Gm-Message-State: AOAM5301Eme73JFADrN2LKTFzAHB6tfDqCvmhi+GaSZYkcZiKoz57Efc
        ZoRu4kHtQLym+BXRiWptuUpnwMvFdECpKC/LehlDXQ==
X-Google-Smtp-Source: ABdhPJygatPCTgngzA8BfCoD0l3nfEZ9seGBOFA3kGWjYO2vX4zcfDvdTtVrBTHFloSlsoY7V3JH6u4jQTlBSAJOSyQ=
X-Received: by 2002:a1f:e443:: with SMTP id b64mr859520vkh.17.1599121210936;
 Thu, 03 Sep 2020 01:20:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200903054104.228829-1-hch@lst.de> <20200903054104.228829-3-hch@lst.de>
In-Reply-To: <20200903054104.228829-3-hch@lst.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 3 Sep 2020 10:19:34 +0200
Message-ID: <CAPDyKFrkcpziGFPmSd8Kx4bzhoN6zxF1E8MagLQSa4sBmnicOg@mail.gmail.com>
Subject: Re: [PATCH 2/9] block: add a bdev_is_partition helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Sep 2020 at 07:42, Christoph Hellwig <hch@lst.de> wrote:
>
> Add a littler helper to make the somewhat arcane bd_contains checks a
> little more obvious.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Not sure why we have both "bd_contains" and "bd_partno", nevertheless,
feel free to add:

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  block/blk-lib.c                 | 2 +-
>  block/ioctl.c                   | 4 ++--
>  block/scsi_ioctl.c              | 2 +-
>  drivers/ide/ide-ioctls.c        | 4 ++--
>  drivers/md/dm-table.c           | 2 +-
>  drivers/mmc/core/block.c        | 2 +-
>  drivers/s390/block/dasd_ioctl.c | 8 ++++----
>  fs/nfsd/blocklayout.c           | 4 ++--
>  include/linux/blkdev.h          | 9 +++++++--
>  kernel/trace/blktrace.c         | 2 +-
>  10 files changed, 22 insertions(+), 17 deletions(-)
>
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 0d1811e57ac704..e90614fd8d6a42 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -64,7 +64,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>                 return -EINVAL;
>
>         /* In case the discard request is in a partition */
> -       if (bdev->bd_partno)
> +       if (bdev_is_partition(bdev))
>                 part_offset = bdev->bd_part->start_sect;
>
>         while (nr_sects) {
> diff --git a/block/ioctl.c b/block/ioctl.c
> index bdb3bbb253d9f8..e4af3df9d28a68 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -23,7 +23,7 @@ static int blkpg_do_ioctl(struct block_device *bdev,
>                 return -EACCES;
>         if (copy_from_user(&p, upart, sizeof(struct blkpg_partition)))
>                 return -EFAULT;
> -       if (bdev != bdev->bd_contains)
> +       if (bdev_is_partition(bdev))
>                 return -EINVAL;
>
>         if (p.pno <= 0)
> @@ -94,7 +94,7 @@ static int blkdev_reread_part(struct block_device *bdev)
>  {
>         int ret;
>
> -       if (!disk_part_scan_enabled(bdev->bd_disk) || bdev != bdev->bd_contains)
> +       if (!disk_part_scan_enabled(bdev->bd_disk) || bdev_is_partition(bdev))
>                 return -EINVAL;
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EACCES;
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index ef722f04f88a93..3bb4571385ce21 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -854,7 +854,7 @@ EXPORT_SYMBOL(scsi_cmd_ioctl);
>
>  int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
>  {
> -       if (bd && bd == bd->bd_contains)
> +       if (bd && !bdev_is_partition(bd))
>                 return 0;
>
>         if (capable(CAP_SYS_RAWIO))
> diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
> index 09491098047bff..58994da10c0664 100644
> --- a/drivers/ide/ide-ioctls.c
> +++ b/drivers/ide/ide-ioctls.c
> @@ -49,7 +49,7 @@ int ide_setting_ioctl(ide_drive_t *drive, struct block_device *bdev,
>         return err >= 0 ? put_user_long(err, arg) : err;
>
>  set_val:
> -       if (bdev != bdev->bd_contains)
> +       if (bdev_is_partition(bdev))
>                 err = -EINVAL;
>         else {
>                 if (!capable(CAP_SYS_ADMIN))
> @@ -257,7 +257,7 @@ int generic_ide_ioctl(ide_drive_t *drive, struct block_device *bdev,
>         switch (cmd) {
>         case HDIO_OBSOLETE_IDENTITY:
>         case HDIO_GET_IDENTITY:
> -               if (bdev != bdev->bd_contains)
> +               if (bdev_is_partition(bdev))
>                         return -EINVAL;
>                 return ide_get_identity_ioctl(drive, cmd, argp);
>         case HDIO_GET_NICE:
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 5edc3079e7c199..af156256e511ff 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -903,7 +903,7 @@ static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
>         struct request_queue *q = bdev_get_queue(bdev);
>
>         /* request-based cannot stack on partitions! */
> -       if (bdev != bdev->bd_contains)
> +       if (bdev_is_partition(bdev))
>                 return false;
>
>         return queue_is_mq(q);
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index fa313b63413547..8d3df0be0355ce 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -723,7 +723,7 @@ static int mmc_blk_check_blkdev(struct block_device *bdev)
>          * whole block device, not on a partition.  This prevents overspray
>          * between sibling partitions.
>          */
> -       if ((!capable(CAP_SYS_RAWIO)) || (bdev != bdev->bd_contains))
> +       if (!capable(CAP_SYS_RAWIO) || bdev_is_partition(bdev))
>                 return -EPERM;
>         return 0;
>  }
> diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
> index faaf5596e31c12..cb6427fb9f3d16 100644
> --- a/drivers/s390/block/dasd_ioctl.c
> +++ b/drivers/s390/block/dasd_ioctl.c
> @@ -277,7 +277,7 @@ dasd_ioctl_format(struct block_device *bdev, void __user *argp)
>                 dasd_put_device(base);
>                 return -EFAULT;
>         }
> -       if (bdev != bdev->bd_contains) {
> +       if (bdev_is_partition(bdev)) {
>                 pr_warn("%s: The specified DASD is a partition and cannot be formatted\n",
>                         dev_name(&base->cdev->dev));
>                 dasd_put_device(base);
> @@ -304,7 +304,7 @@ static int dasd_ioctl_check_format(struct block_device *bdev, void __user *argp)
>         base = dasd_device_from_gendisk(bdev->bd_disk);
>         if (!base)
>                 return -ENODEV;
> -       if (bdev != bdev->bd_contains) {
> +       if (bdev_is_partition(bdev)) {
>                 pr_warn("%s: The specified DASD is a partition and cannot be checked\n",
>                         dev_name(&base->cdev->dev));
>                 rc = -EINVAL;
> @@ -362,7 +362,7 @@ static int dasd_ioctl_release_space(struct block_device *bdev, void __user *argp
>                 rc = -EROFS;
>                 goto out_err;
>         }
> -       if (bdev != bdev->bd_contains) {
> +       if (bdev_is_partition(bdev)) {
>                 pr_warn("%s: The specified DASD is a partition and tracks cannot be released\n",
>                         dev_name(&base->cdev->dev));
>                 rc = -EINVAL;
> @@ -540,7 +540,7 @@ dasd_ioctl_set_ro(struct block_device *bdev, void __user *argp)
>
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EACCES;
> -       if (bdev != bdev->bd_contains)
> +       if (bdev_is_partition(bdev))
>                 // ro setting is not allowed for partitions
>                 return -EINVAL;
>         if (get_user(intval, (int __user *)argp))
> diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
> index 311e5ce80cfc27..a07c39c94bbd03 100644
> --- a/fs/nfsd/blocklayout.c
> +++ b/fs/nfsd/blocklayout.c
> @@ -170,7 +170,7 @@ nfsd4_block_proc_getdeviceinfo(struct super_block *sb,
>                 struct nfs4_client *clp,
>                 struct nfsd4_getdeviceinfo *gdp)
>  {
> -       if (sb->s_bdev != sb->s_bdev->bd_contains)
> +       if (bdev_is_partition(sb->s_bdev))
>                 return nfserr_inval;
>         return nfserrno(nfsd4_block_get_device_info_simple(sb, gdp));
>  }
> @@ -382,7 +382,7 @@ nfsd4_scsi_proc_getdeviceinfo(struct super_block *sb,
>                 struct nfs4_client *clp,
>                 struct nfsd4_getdeviceinfo *gdp)
>  {
> -       if (sb->s_bdev != sb->s_bdev->bd_contains)
> +       if (bdev_is_partition(sb->s_bdev))
>                 return nfserr_inval;
>         return nfserrno(nfsd4_block_get_device_info_scsi(sb, clp, gdp));
>  }
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 7575fa0aae6e5c..0006a78ebc5dde 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1341,6 +1341,11 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
>
>  extern int blk_verify_command(unsigned char *cmd, fmode_t mode);
>
> +static inline bool bdev_is_partition(struct block_device *bdev)
> +{
> +       return bdev->bd_partno;
> +}
> +
>  enum blk_default_limits {
>         BLK_MAX_SEGMENTS        = 128,
>         BLK_SAFE_MAX_SECTORS    = 255,
> @@ -1457,7 +1462,7 @@ static inline int bdev_alignment_offset(struct block_device *bdev)
>
>         if (q->limits.misaligned)
>                 return -1;
> -       if (bdev != bdev->bd_contains)
> +       if (bdev_is_partition(bdev))
>                 return queue_limit_alignment_offset(&q->limits,
>                                 bdev->bd_part->start_sect);
>         return q->limits.alignment_offset;
> @@ -1498,7 +1503,7 @@ static inline int bdev_discard_alignment(struct block_device *bdev)
>  {
>         struct request_queue *q = bdev_get_queue(bdev);
>
> -       if (bdev != bdev->bd_contains)
> +       if (bdev_is_partition(bdev))
>                 return queue_limit_discard_alignment(&q->limits,
>                                 bdev->bd_part->start_sect);
>         return q->limits.discard_alignment;
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 4b3a42fc3b24f1..157758a88773b9 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -527,7 +527,7 @@ static int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
>          * and scsi-generic block devices we create a temporary new debugfs
>          * directory that will be removed once the trace ends.
>          */
> -       if (bdev && bdev == bdev->bd_contains)
> +       if (bdev && !bdev_is_partition(bdev))
>                 dir = q->debugfs_dir;
>         else
>                 bt->dir = dir = debugfs_create_dir(buts->name, blk_debugfs_root);
> --
> 2.28.0
>
