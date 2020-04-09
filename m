Return-Path: <SRS0=DEWY=5Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E58C2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 01:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0250A2085B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 01:13:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RNI22t0c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDIBNZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 21:13:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39974 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726510AbgDIBNZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 21:13:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586394805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r0cI23rv/CRPi00YuUefPu43DYEx/C8dlX+V/+YaZOc=;
        b=RNI22t0cIgBe+sU/YrYJVafxbmF9mvC8w6e6CG+qEv2bzj0CMUxuiKk9ItEOegP8ev3kM+
        CCzb/TNn0q20ReBhuYz/CKBMuSE+YLT9V33U8hipXGBtyzj/Go7gIzHXKx5X3cJIBXgjXu
        5aAH9ojeUF4jLabLikuScDBcxQa39JI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-XL7i7sUJOZCEc2DQIPo8NQ-1; Wed, 08 Apr 2020 21:13:20 -0400
X-MC-Unique: XL7i7sUJOZCEc2DQIPo8NQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 191C218AB2CF;
        Thu,  9 Apr 2020 01:13:17 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 102B952735;
        Thu,  9 Apr 2020 01:13:05 +0000 (UTC)
Date:   Thu, 9 Apr 2020 09:13:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        paolo.valente@linaro.org, groeck@chromium.org,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        sqazi@google.com,
        =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@collabora.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] blk-mq: Add blk_mq_delay_run_hw_queues() API call
Message-ID: <20200409011301.GA369792@localhost.localdomain>
References: <20200408150402.21208-1-dianders@chromium.org>
 <20200408080255.v4.2.I4c665d70212a5b33e103fec4d5019a59b4c05577@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408080255.v4.2.I4c665d70212a5b33e103fec4d5019a59b4c05577@changeid>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 08, 2020 at 08:04:00AM -0700, Douglas Anderson wrote:
> We have:
> * blk_mq_run_hw_queue()
> * blk_mq_delay_run_hw_queue()
> * blk_mq_run_hw_queues()
> 
> ...but not blk_mq_delay_run_hw_queues(), presumably because nobody
> needed it before now.  Since we need it for a later patch in this
> series, add it.
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> 
> Changes in v4: None
> Changes in v3:
> - ("blk-mq: Add blk_mq_delay_run_hw_queues() API call") new for v3
> 
> Changes in v2: None
> 
>  block/blk-mq.c         | 19 +++++++++++++++++++
>  include/linux/blk-mq.h |  1 +
>  2 files changed, 20 insertions(+)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2cd8d2b49ff4..ea0cd970a3ff 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1537,6 +1537,25 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
>  }
>  EXPORT_SYMBOL(blk_mq_run_hw_queues);
>  
> +/**
> + * blk_mq_delay_run_hw_queues - Run all hardware queues asynchronously.
> + * @q: Pointer to the request queue to run.
> + * @msecs: Microseconds of delay to wait before running the queues.
> + */
> +void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long msecs)
> +{
> +	struct blk_mq_hw_ctx *hctx;
> +	int i;
> +
> +	queue_for_each_hw_ctx(q, hctx, i) {
> +		if (blk_mq_hctx_stopped(hctx))
> +			continue;
> +
> +		blk_mq_delay_run_hw_queue(hctx, msecs);
> +	}
> +}
> +EXPORT_SYMBOL(blk_mq_delay_run_hw_queues);
> +
>  /**
>   * blk_mq_queue_stopped() - check whether one or more hctxs have been stopped
>   * @q: request queue.
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 11cfd6470b1a..405f8c196517 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -503,6 +503,7 @@ void blk_mq_unquiesce_queue(struct request_queue *q);
>  void blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
>  void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
>  void blk_mq_run_hw_queues(struct request_queue *q, bool async);
> +void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long msecs);
>  void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
>  		busy_tag_iter_fn *fn, void *priv);
>  void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset);
> -- 
> 2.26.0.292.g33ef6b2f38-goog
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

