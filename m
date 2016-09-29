From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v4 1/7] block: Add 'zoned' queue limit
Date: Wed, 28 Sep 2016 20:32:14 -0500
Message-ID: <CAJVOszCabdh0Z7oahhS7Tw+vdgfFt4xP5t5Yvo1G22hTpbqNRw@mail.gmail.com>
References: <1475052339-10202-1-git-send-email-damien.lemoal@hgst.com> <1475052339-10202-2-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1475052339-10202-2-git-send-email-damien.lemoal@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 28, 2016 at 3:45 AM, Damien Le Moal <damien.lemoal@hgst.com> wr=
ote:
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
>  Documentation/ABI/testing/sysfs-block | 16 ++++++++++++
>  block/blk-settings.c                  |  1 +
>  block/blk-sysfs.c                     | 18 ++++++++++++++
>  include/linux/blkdev.h                | 47 +++++++++++++++++++++++++++++=
++++++
>  4 files changed, 82 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/te=
sting/sysfs-block
> index 71d184d..75a5055 100644
> --- a/Documentation/ABI/testing/sysfs-block
> +++ b/Documentation/ABI/testing/sysfs-block
> @@ -235,3 +235,19 @@ Description:
>                 write_same_max_bytes is 0, write same is not supported
>                 by the device.
>
> +What:          /sys/block/<disk>/queue/zoned
> +Date:          September 2016
> +Contact:       Damien Le Moal <damien.lemoal@hgst.com>
> +Description:
> +               zoned indicates if the device is a zoned block device
> +               and the zone model of the device if it is indeed zoned.
> +               The possible values indicated by zoned are "none" for
> +               regular block devices and "host-aware" or "host-managed"
> +               for zoned block devices. The characteristics of
> +               host-aware and host-managed zoned block devices are
> +               described in the ZBC (Zoned Block Commands) and ZAC
> +               (Zoned Device ATA Command Set) standards. These standards
> +               also define the "drive-managed" zone model. However,
> +               since drive-managed zoned block devices do not support
> +               zone commands, they will be treated as regular block
> +               devices and zoned will report "none".
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index f679ae1..b1d5b7f 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -107,6 +107,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>         lim->io_opt =3D 0;
>         lim->misaligned =3D 0;
>         lim->cluster =3D 1;
> +       lim->zoned =3D BLK_ZONED_NONE;
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
> @@ -485,6 +497,11 @@ static struct queue_sysfs_entry queue_nonrot_entry =
=3D {
>         .store =3D queue_store_nonrot,
>  };
>
> +static struct queue_sysfs_entry queue_zoned_entry =3D {
> +       .attr =3D {.name =3D "zoned", .mode =3D S_IRUGO },
> +       .show =3D queue_zoned_show,
> +};
> +
>  static struct queue_sysfs_entry queue_nomerges_entry =3D {
>         .attr =3D {.name =3D "nomerges", .mode =3D S_IRUGO | S_IWUSR },
>         .show =3D queue_nomerges_show,
> @@ -546,6 +563,7 @@ static struct attribute *default_attrs[] =3D {
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
> @@ -627,6 +637,23 @@ static inline unsigned int blk_queue_cluster(struct =
request_queue *q)
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
> @@ -1354,6 +1381,26 @@ static inline unsigned int bdev_write_same(struct =
block_device *bdev)
>         return 0;
>  }
>
> +static inline enum blk_zoned_model bdev_zoned_model(struct block_device =
*bdev)
> +{
> +       struct request_queue *q =3D bdev_get_queue(bdev);
> +
> +       if (q)
> +               return blk_queue_zoned_model(q);
> +
> +       return BLK_ZONED_NONE;
> +}
> +
> +static inline bool bdev_is_zoned(struct block_device *bdev)
> +{
> +       struct request_queue *q =3D bdev_get_queue(bdev);
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
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=3Dhttp=
-3A__vger.kernel.org_majordomo-2Dinfo.html&d=3DDQIBAg&c=3DIGDlg0lD0b-nebmJJ=
0Kp8A&r=3DWg5NqlNlVTT7Ugl8V50qIHLe856QW0qfG3WVYGOrWzA&m=3DOrJGmhxktFJiu0t9z=
ZDWOTM1h0hle-YsGIdgS8egsv4&s=3DiBLL4ue7jd5w6PMQqeLF8l-1CVvqmRuI_aQgJJV6Cp0&=
e=3D



--=20
Shaun Tancheff
