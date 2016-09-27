From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v2 3/7] block: update chunk_sectors in blk_stack_limits()
Date: Tue, 27 Sep 2016 16:12:42 -0500
Message-ID: <CAJVOszAx9cfuWeSsh_LE--SXKT6ur9ZTdAYk7dzpc7njP=K06w@mail.gmail.com>
References: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com> <1474888483-29762-4-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:45556 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751018AbcI0VNE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Sep 2016 17:13:04 -0400
Received: from pps.filterd (m0075028.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8RLCqMS043458
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2016 17:13:03 -0400
Received: from mail-yw0-f199.google.com (mail-yw0-f199.google.com [209.85.161.199])
        by mx0b-00003501.pphosted.com with ESMTP id 25qv201rg9-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2016 17:13:03 -0400
Received: by mail-yw0-f199.google.com with SMTP id y201so29282247ywg.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2016 14:13:03 -0700 (PDT)
In-Reply-To: <1474888483-29762-4-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

On Mon, Sep 26, 2016 at 6:14 AM, Damien Le Moal <damien.lemoal@hgst.com> wrote:
> From: Hannes Reinecke <hare@suse.de>
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
> ---
>  block/blk-settings.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index b1d5b7f..55369a6 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -631,6 +631,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>                         t->discard_granularity;
>         }
>
> +       if (b->chunk_sectors)
> +               t->chunk_sectors = min_not_zero(t->chunk_sectors,
> +                                               b->chunk_sectors);
> +
>         return ret;
>  }
>  EXPORT_SYMBOL(blk_stack_limits);
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
