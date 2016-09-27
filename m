From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v2 1/7] block: Add 'zoned' queue limit
Date: Tue, 27 Sep 2016 16:09:13 -0500
Message-ID: <CAJVOszDaQTS8WSMY0W_ogp0Du9XY9m-q3FWDUn5ZL0emmxCfow@mail.gmail.com>
References: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com> <1474888483-29762-2-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:57928 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934101AbcI0VJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Sep 2016 17:09:35 -0400
Received: from pps.filterd (m0075032.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8RL8QjM047274
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2016 17:09:34 -0400
Received: from mail-yw0-f197.google.com (mail-yw0-f197.google.com [209.85.161.197])
        by mx0b-00003501.pphosted.com with ESMTP id 25qv1jsr47-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2016 17:09:33 -0400
Received: by mail-yw0-f197.google.com with SMTP id t67so21040075ywg.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2016 14:09:33 -0700 (PDT)
In-Reply-To: <1474888483-29762-2-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>

On Mon, Sep 26, 2016 at 6:14 AM, Damien Le Moal <damien.lemoal@hgst.com> wrote:
> Add the zoned queue limit to indicate the zoning model of a block device.
> Defined values are 0 (BLK_ZONED_NONE) for regular block devices,
> 1 (BLK_ZONED_HA) for host-aware zone block devices and 2 (BLK_ZONED_HM)
> for host-managed zone block devices. The standards defined drive managed
> model is not defined here since these block devices do not provide any
> command for accessing zone information. Drive managed model devices will
> be reported as BLK_ZONED_NONE.
>
> The helper functions blk_queue_zoned_model and bdev_zoned_model return
> the zoned limit and the functions blk_queue_is_zoned and bdev_is_zoned
> return a boolean for callers to test if a block device is zoned.
>
> The zoned attribute is also exported as a string to applications via
> sysfs. BLK_ZONED_NONE shows as "none", BLK_ZONED_HA as "host-aware" and
> BLK_ZONED_HM as "host-managed".
>
> Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
> ---
>  block/blk-settings.c   |  1 +
>  block/blk-sysfs.c      | 18 ++++++++++++++++++
>  include/linux/blkdev.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 66 insertions(+)
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index f679ae1..b1d5b7f 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -107,6 +107,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>         lim->io_opt = 0;
>         lim->misaligned = 0;
>         lim->cluster = 1;
> +       lim->zoned = BLK_ZONED_NONE;
>  }
>  EXPORT_SYMBOL(blk_set_default_limits);
>
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 9cc8d7c..ff9cd9c 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -257,6 +257,18 @@ QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
>  QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
>  #undef QUEUE_SYSFS_BIT_FNS
>
> +static ssize_t queue_zoned_show(struct request_queue *q, char *page)
> +{
> +       switch (blk_queue_zoned_model(q)) {
> +       case BLK_ZONED_HA:
> +               return sprintf(page, "host-aware\n");
> +       case BLK_ZONED_HM:
> +               return sprintf(page, "host-managed\n");
> +       default:
> +               return sprintf(page, "none\n");
> +       }
> +}
> +
>  static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
>  {
>         return queue_var_show((blk_queue_nomerges(q) << 1) |
> @@ -485,6 +497,11 @@ static struct queue_sysfs_entry queue_nonrot_entry = {
>         .store = queue_store_nonrot,
>  };
>
> +static struct queue_sysfs_entry queue_zoned_entry = {
> +       .attr = {.name = "zoned", .mode = S_IRUGO },
> +       .show = queue_zoned_show,
> +};
> +
>  static struct queue_sysfs_entry queue_nomerges_entry = {
>         .attr = {.name = "nomerges", .mode = S_IRUGO | S_IWUSR },
>         .show = queue_nomerges_show,
> @@ -546,6 +563,7 @@ static struct attribute *default_attrs[] = {
>         &queue_discard_zeroes_data_entry.attr,
>         &queue_write_same_max_entry.attr,
>         &queue_nonrot_entry.attr,
> +       &queue_zoned_entry.attr,
>         &queue_nomerges_entry.attr,
>         &queue_rq_affinity_entry.attr,
>         &queue_iostats_entry.attr,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c47c358..f19e16b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -261,6 +261,15 @@ struct blk_queue_tag {
>  #define BLK_SCSI_MAX_CMDS      (256)
>  #define BLK_SCSI_CMD_PER_LONG  (BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
>
> +/*
> + * Zoned block device models (zoned limit).
> + */
> +enum blk_zoned_model {
> +       BLK_ZONED_NONE, /* Regular block device */
> +       BLK_ZONED_HA,   /* Host-aware zoned block device */
> +       BLK_ZONED_HM,   /* Host-managed zoned block device */
> +};
> +
>  struct queue_limits {
>         unsigned long           bounce_pfn;
>         unsigned long           seg_boundary_mask;
> @@ -290,6 +299,7 @@ struct queue_limits {
>         unsigned char           cluster;
>         unsigned char           discard_zeroes_data;
>         unsigned char           raid_partial_stripes_expensive;
> +       enum blk_zoned_model    zoned;
>  };
>
>  struct request_queue {
> @@ -627,6 +637,23 @@ static inline unsigned int blk_queue_cluster(struct request_queue *q)
>         return q->limits.cluster;
>  }
>
> +static inline enum blk_zoned_model
> +blk_queue_zoned_model(struct request_queue *q)
> +{
> +       return q->limits.zoned;
> +}
> +
> +static inline bool blk_queue_is_zoned(struct request_queue *q)
> +{
> +       switch (blk_queue_zoned_model(q)) {
> +       case BLK_ZONED_HA:
> +       case BLK_ZONED_HM:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}
> +
>  /*
>   * We regard a request as sync, if either a read or a sync write
>   */
> @@ -1354,6 +1381,26 @@ static inline unsigned int bdev_write_same(struct block_device *bdev)
>         return 0;
>  }
>
> +static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
> +{
> +       struct request_queue *q = bdev_get_queue(bdev);
> +
> +       if (q)
> +               return blk_queue_zoned_model(q);
> +
> +       return BLK_ZONED_NONE;
> +}
> +
> +static inline bool bdev_is_zoned(struct block_device *bdev)
> +{
> +       struct request_queue *q = bdev_get_queue(bdev);
> +
> +       if (q)
> +               return blk_queue_is_zoned(q);
> +
> +       return false;
> +}
> +
>  static inline int queue_dma_alignment(struct request_queue *q)
>  {
>         return q ? q->dma_alignment : 511;
> --
> 2.7.4

Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>
Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shaun Tancheff
