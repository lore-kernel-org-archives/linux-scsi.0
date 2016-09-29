From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v4 2/7] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Wed, 28 Sep 2016 20:32:55 -0500
Message-ID: <CAJVOszCPu34Fx6MdH6G2Oo9s-pO7M3eN=KC-uQDKusEoQ+z_cw@mail.gmail.com>
References: <1475052339-10202-1-git-send-email-damien.lemoal@hgst.com> <1475052339-10202-3-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:48354 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751420AbcI2BdR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Sep 2016 21:33:17 -0400
Received: from pps.filterd (m0075028.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8T1X9kX002795
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2016 21:33:16 -0400
Received: from mail-yw0-f199.google.com (mail-yw0-f199.google.com [209.85.161.199])
        by mx0b-00003501.pphosted.com with ESMTP id 25rryh89aj-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2016 21:33:16 -0400
Received: by mail-yw0-f199.google.com with SMTP id g18so14525665ywb.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2016 18:33:16 -0700 (PDT)
In-Reply-To: <1475052339-10202-3-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>

On Wed, Sep 28, 2016 at 3:45 AM, Damien Le Moal <damien.lemoal@hgst.com> wrote:
> From: Hannes Reinecke <hare@suse.de>
>
> The queue limits already have a 'chunk_sectors' setting, so
> we should be presenting it via sysfs.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>
> [Damien: Updated Documentation/ABI/testing/sysfs-block]
>
> Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
> ---
>  Documentation/ABI/testing/sysfs-block | 13 +++++++++++++
>  block/blk-sysfs.c                     | 11 +++++++++++
>  2 files changed, 24 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
> index 75a5055..ee2d5cd 100644
> --- a/Documentation/ABI/testing/sysfs-block
> +++ b/Documentation/ABI/testing/sysfs-block
> @@ -251,3 +251,16 @@ Description:
>                 since drive-managed zoned block devices do not support
>                 zone commands, they will be treated as regular block
>                 devices and zoned will report "none".
> +
> +What:          /sys/block/<disk>/queue/chunk_sectors
> +Date:          September 2016
> +Contact:       Hannes Reinecke <hare@suse.com>
> +Description:
> +               chunk_sectors has different meaning depending on the type
> +               of the disk. For a RAID device (dm-raid), chunk_sectors
> +               indicates the size in 512B sectors of the RAID volume
> +               stripe segment. For a zoned block device, either
> +               host-aware or host-managed, chunk_sectors indicates the
> +               size of 512B sectors of the zones of the device, with
> +               the eventual exception of the last zone of the device
> +               which may be smaller.
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index ff9cd9c..488c2e2 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -130,6 +130,11 @@ static ssize_t queue_physical_block_size_show(struct request_queue *q, char *pag
>         return queue_var_show(queue_physical_block_size(q), page);
>  }
>
> +static ssize_t queue_chunk_sectors_show(struct request_queue *q, char *page)
> +{
> +       return queue_var_show(q->limits.chunk_sectors, page);
> +}
> +
>  static ssize_t queue_io_min_show(struct request_queue *q, char *page)
>  {
>         return queue_var_show(queue_io_min(q), page);
> @@ -455,6 +460,11 @@ static struct queue_sysfs_entry queue_physical_block_size_entry = {
>         .show = queue_physical_block_size_show,
>  };
>
> +static struct queue_sysfs_entry queue_chunk_sectors_entry = {
> +       .attr = {.name = "chunk_sectors", .mode = S_IRUGO },
> +       .show = queue_chunk_sectors_show,
> +};
> +
>  static struct queue_sysfs_entry queue_io_min_entry = {
>         .attr = {.name = "minimum_io_size", .mode = S_IRUGO },
>         .show = queue_io_min_show,
> @@ -555,6 +565,7 @@ static struct attribute *default_attrs[] = {
>         &queue_hw_sector_size_entry.attr,
>         &queue_logical_block_size_entry.attr,
>         &queue_physical_block_size_entry.attr,
> +       &queue_chunk_sectors_entry.attr,
>         &queue_io_min_entry.attr,
>         &queue_io_opt_entry.attr,
>         &queue_discard_granularity_entry.attr,
> --
> 2.7.4

Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>
Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shaun Tancheff
