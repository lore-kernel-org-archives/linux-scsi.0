Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F7FC54EE9
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 13:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbiI1Njk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 09:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbiI1NjM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 09:39:12 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31B6A6C75;
        Wed, 28 Sep 2022 06:38:57 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id p4so12703271vsa.9;
        Wed, 28 Sep 2022 06:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Ma+WfyDUOu65BUCzRZHjxnobNoWTb8YtsVUPTmbAysk=;
        b=FgAFPI/223pVOPaxxHEM/Zd1ZfWpjbG7PQ4A8Vy77PUd6ZD434RmmJ1INOCc5HuLI/
         DDjwTlHMTPSUWy72Sn7I7Y/cMdoOuZY4n95h3fNy5P9s1MMYWfc7Qvcg7MdN2iSSIVBi
         f07+FTLNkST49A/Fp8p7snt8SfPl7G/k7MaK4MWBrXoXPlxdxzczgNCG0g8zInW37Yfd
         nUfCHF0yYXQaGwsm0bXjBt1WZRjcW2jY310MpvQZ+hQ6ZFjfLiYX7fvCFDjm9bOpKPiD
         aHYOfdf5BSuxoQqqCjS9+ZrGJxmk2s6T/RWXAFlyff7/+TA7q2pRyQMZv+AvPFxvShhu
         z+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Ma+WfyDUOu65BUCzRZHjxnobNoWTb8YtsVUPTmbAysk=;
        b=EgbOfZvmyUB1HTLHUahyCW8JrWp4fKSf0lRwvn49Pbp4sJzBHYwtyo9Nxh0j2NGoF2
         b2+mhy3QLLKah4kO3RcYhoqXwMTx9FKcEF0C3SqWEzCKmbG3el/rs50aK087ipFgFdfF
         cRmFKgwtjLODe1vJpjbQ+1u7rlWb3qnCHRUCqbVGJ3hCcMQWy0j+ZLl0HtfMAO25RbT9
         M9AmIyuv8TGnzoMkgwX8UDiZtrmuQ9HpKm6hsq6ngjtFlw8WvwqRnJ5x4+cQFyXpq/CX
         5WOQYkElzeAnenkhixvBcIWL6oSPvhvfqBeaeNUyMrOweWhnMSn7jPKihbwtcIVXHC6N
         Y4SQ==
X-Gm-Message-State: ACrzQf3v4heMhoTHrqeGiQBwq4NpPi5INH+rzFqxY/9TbqghUZPOEJUi
        6JdAPufry2kKZJ/YTagOuCQ9gKBHi6CoEyX5pMab0/uRf5Wv
X-Google-Smtp-Source: AMsMyM5ZevjLPsHqYmkPkCeAItjJmrYLdDuwbEfDYF6XpvVDBajf5Yr1pIp2lc+jss4yCDtssVMxPfR5iMihBbL16Ps=
X-Received: by 2002:a67:bd14:0:b0:398:81fb:3d04 with SMTP id
 y20-20020a67bd14000000b0039881fb3d04mr14683646vsq.4.1664372336277; Wed, 28
 Sep 2022 06:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220927014420.71141-1-axboe@kernel.dk> <20220927014420.71141-2-axboe@kernel.dk>
In-Reply-To: <20220927014420.71141-2-axboe@kernel.dk>
From:   Anuj gupta <anuj1072538@gmail.com>
Date:   Wed, 28 Sep 2022 19:08:19 +0530
Message-ID: <CACzX3AsD6YwUTD7o+o1tan-Eva2BshffYRr2t4zp4+dgZ1AkLA@mail.gmail.com>
Subject: Re: [PATCH 1/5] block: enable batched allocation for blk_mq_alloc_request()
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 27, 2022 at 7:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> The filesystem IO path can take advantage of allocating batches of
> requests, if the underlying submitter tells the block layer about it
> through the blk_plug. For passthrough IO, the exported API is the
> blk_mq_alloc_request() helper, and that one does not allow for
> request caching.
>
> Wire up request caching for blk_mq_alloc_request(), which is generally
> done without having a bio available upfront.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-mq.c | 80 ++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 71 insertions(+), 9 deletions(-)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index c11949d66163..d3a9f8b9c7ee 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -510,25 +510,87 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
>                                         alloc_time_ns);
>  }
>
> -struct request *blk_mq_alloc_request(struct request_queue *q, blk_opf_t opf,
> -               blk_mq_req_flags_t flags)
> +static struct request *blk_mq_rq_cache_fill(struct request_queue *q,
> +                                           struct blk_plug *plug,
> +                                           blk_opf_t opf,
> +                                           blk_mq_req_flags_t flags)
>  {
>         struct blk_mq_alloc_data data = {
>                 .q              = q,
>                 .flags          = flags,
>                 .cmd_flags      = opf,
> -               .nr_tags        = 1,
> +               .nr_tags        = plug->nr_ios,
> +               .cached_rq      = &plug->cached_rq,
>         };
>         struct request *rq;
> -       int ret;
>
> -       ret = blk_queue_enter(q, flags);
> -       if (ret)
> -               return ERR_PTR(ret);
> +       if (blk_queue_enter(q, flags))
> +               return NULL;
> +
> +       plug->nr_ios = 1;
>
>         rq = __blk_mq_alloc_requests(&data);
> -       if (!rq)
> -               goto out_queue_exit;
> +       if (unlikely(!rq))
> +               blk_queue_exit(q);
> +       return rq;
> +}
> +
> +static struct request *blk_mq_alloc_cached_request(struct request_queue *q,
> +                                                  blk_opf_t opf,
> +                                                  blk_mq_req_flags_t flags)
> +{
> +       struct blk_plug *plug = current->plug;
> +       struct request *rq;
> +
> +       if (!plug)
> +               return NULL;
> +       if (rq_list_empty(plug->cached_rq)) {
> +               if (plug->nr_ios == 1)
> +                       return NULL;
> +               rq = blk_mq_rq_cache_fill(q, plug, opf, flags);
> +               if (rq)
> +                       goto got_it;
> +               return NULL;
> +       }
> +       rq = rq_list_peek(&plug->cached_rq);
> +       if (!rq || rq->q != q)
> +               return NULL;
> +
> +       if (blk_mq_get_hctx_type(opf) != rq->mq_hctx->type)
> +               return NULL;
> +       if (op_is_flush(rq->cmd_flags) != op_is_flush(opf))
> +               return NULL;
> +
> +       plug->cached_rq = rq_list_next(rq);
> +got_it:
> +       rq->cmd_flags = opf;
> +       INIT_LIST_HEAD(&rq->queuelist);
> +       return rq;
> +}
> +
> +struct request *blk_mq_alloc_request(struct request_queue *q, blk_opf_t opf,
> +               blk_mq_req_flags_t flags)
> +{
> +       struct request *rq;
> +
> +       rq = blk_mq_alloc_cached_request(q, opf, flags);
> +       if (!rq) {
> +               struct blk_mq_alloc_data data = {
> +                       .q              = q,
> +                       .flags          = flags,
> +                       .cmd_flags      = opf,
> +                       .nr_tags        = 1,
> +               };
> +               int ret;
> +
> +               ret = blk_queue_enter(q, flags);
> +               if (ret)
> +                       return ERR_PTR(ret);
> +
> +               rq = __blk_mq_alloc_requests(&data);
> +               if (!rq)
> +                       goto out_queue_exit;
> +       }
>         rq->__data_len = 0;
>         rq->__sector = (sector_t) -1;
>         rq->bio = rq->biotail = NULL;
> --
> 2.35.1
>

A large chunk of this improvement in passthrough performance is coming by
enabling request caching. On my setup, the performance improves from
2.34 to 2.54 MIOPS. I have tested this using the t/io_uring utility (in fio) and
I am using an Intel Optane Gen2 device.

Tested-by: Anuj Gupta <anuj20.g@samsung.com>

--
Anuj Gupta
