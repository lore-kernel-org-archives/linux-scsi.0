From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: Re: [PATCH 02/15] blk-mq: support at_head inserations for blk_execute_rq
Date: Wed, 5 Feb 2014 18:27:38 -0800
Message-ID: <CAFR8uedLQyX7aFsuOs4UFYE=sYUOG+jpPMOQzqOW4f_RQGsf2g@mail.gmail.com>
References: <20140205124118.332902571@bombadil.infradead.org>
	<20140205124152.477413324@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51802 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbaBFC1j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 21:27:39 -0500
Received: by mail-pa0-f51.google.com with SMTP id ld10so1111975pab.10
        for <linux-scsi@vger.kernel.org>; Wed, 05 Feb 2014 18:27:38 -0800 (PST)
In-Reply-To: <20140205124152.477413324@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>

> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index b771080..88a2366 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -30,6 +30,8 @@ void blk_mq_init_flush(struct request_queue *q);
>  void blk_mq_drain_queue(struct request_queue *q);
>  void blk_mq_free_queue(struct request_queue *q);
>  void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq);
> +void blk_mq_insert_request(struct request_queue *, struct request *,
> +               bool, bool);
>
>  /*
>   * CPU hotplug helpers
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index c1684ec..8cfdca6 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -119,7 +119,6 @@ void blk_mq_init_commands(struct request_queue *, void (*init)(void *data, struc
>
>  void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
>
> -void blk_mq_insert_request(struct request_queue *, struct request *, bool);
>  void blk_mq_run_queues(struct request_queue *q, bool async);
>  void blk_mq_free_request(struct request *rq);
>  bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
> --
> 1.7.10.4
>

Currently its not used by any drivers. Are we sure we don't need it
public? If sure, please remove the EXPORT_SYMBOL() for it.

Rest looks good.

Regards,
Muthu


>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
