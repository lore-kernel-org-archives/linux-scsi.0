From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v2 2/7] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Tue, 27 Sep 2016 16:10:23 -0500
Message-ID: <CAJVOszA-6nA2j2VRMgxWVmA831mcgQ1PGKLeyCycNOLWepo-JQ@mail.gmail.com>
References: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com> <1474888483-29762-3-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:57633 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932458AbcI0VKp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Sep 2016 17:10:45 -0400
Received: from pps.filterd (m0075034.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8RL8eui043968
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2016 17:10:44 -0400
Received: from mail-yw0-f200.google.com (mail-yw0-f200.google.com [209.85.161.200])
        by mx0b-00003501.pphosted.com with ESMTP id 25qv23hq2f-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2016 17:10:44 -0400
Received: by mail-yw0-f200.google.com with SMTP id g18so22834267ywb.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2016 14:10:44 -0700 (PDT)
In-Reply-To: <1474888483-29762-3-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

On Mon, Sep 26, 2016 at 6:14 AM, Damien Le Moal <damien.lemoal@hgst.com> wrote:
> From: Hannes Reinecke <hare@suse.de>
>
> The queue limits already have a 'chunk_sectors' setting, so
> we should be presenting it via sysfs.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
> ---
>  block/blk-sysfs.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
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


> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shaun Tancheff
