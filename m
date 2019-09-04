Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B51C3A5A9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 09:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1A6C22CF7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 09:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbfIDJFj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 05:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65055 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728878AbfIDJFj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Sep 2019 05:05:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76A778980EA;
        Wed,  4 Sep 2019 09:05:38 +0000 (UTC)
Received: from ming.t460p (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CA4B60606;
        Wed,  4 Sep 2019 09:05:32 +0000 (UTC)
Date:   Wed, 4 Sep 2019 17:05:27 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 2/7] block: Change elevator_init_mq() to always succeed
Message-ID: <20190904090526.GE7578@ming.t460p>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
 <20190904084247.23338-3-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904084247.23338-3-damien.lemoal@wdc.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Wed, 04 Sep 2019 09:05:38 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 04, 2019 at 05:42:42PM +0900, Damien Le Moal wrote:
> If the default elevator chosen is mq-deadline, elevator_init_mq() may
> return an error if mq-deadline initialization fails, leading to
> blk_mq_init_allocated_queue() returning an error, which in turn will
> cause the block device initialization to fail and the device not being
> exposed.
> 
> Instead of taking such extreme measure, handle mq-deadline
> initialization failures in the same manner as when mq-deadline is not
> available (no module to load), that is, default to the "none" scheduler.
> With this change, elevator_init_mq() return type can be changed to void.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c   |  8 +-------
>  block/blk.h      |  2 +-
>  block/elevator.c | 23 ++++++++++++-----------
>  3 files changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 13923630e00a..ee4caf0c0807 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2842,8 +2842,6 @@ static unsigned int nr_hw_queues(struct blk_mq_tag_set *set)
>  struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
>  						  struct request_queue *q)
>  {
> -	int ret = -ENOMEM;
> -
>  	/* mark the queue as mq asap */
>  	q->mq_ops = set->ops;
>  
> @@ -2904,14 +2902,10 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
>  	blk_mq_add_queue_tag_set(set, q);
>  	blk_mq_map_swqueue(q);
>  
> -	ret = elevator_init_mq(q);
> -	if (ret)
> -		goto err_tag_set;
> +	elevator_init_mq(q);
>  
>  	return q;
>  
> -err_tag_set:
> -	blk_mq_del_queue_tag_set(q);
>  err_hctxs:
>  	kfree(q->queue_hw_ctx);
>  	q->nr_hw_queues = 0;
> diff --git a/block/blk.h b/block/blk.h
> index e4619fc5c99a..ed347f7a97b1 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -184,7 +184,7 @@ void blk_account_io_done(struct request *req, u64 now);
>  
>  void blk_insert_flush(struct request *rq);
>  
> -int elevator_init_mq(struct request_queue *q);
> +void elevator_init_mq(struct request_queue *q);
>  int elevator_switch_mq(struct request_queue *q,
>  			      struct elevator_type *new_e);
>  void __elevator_exit(struct request_queue *, struct elevator_queue *);
> diff --git a/block/elevator.c b/block/elevator.c
> index 4721834815bb..2944c129760c 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -628,34 +628,35 @@ static inline bool elv_support_iosched(struct request_queue *q)
>  
>  /*
>   * For blk-mq devices supporting IO scheduling, we default to using mq-deadline,
> - * if available, for single queue devices. If deadline isn't available OR we
> - * have multiple queues, default to "none".
> + * if available, for single queue devices. If deadline isn't available OR
> + * deadline initialization fails OR we have multiple queues, default to "none".
>   */
> -int elevator_init_mq(struct request_queue *q)
> +void elevator_init_mq(struct request_queue *q)
>  {
>  	struct elevator_type *e;
> -	int err = 0;
> +	int err;
>  
>  	if (!elv_support_iosched(q))
> -		return 0;
> +		return;
>  
>  	if (q->nr_hw_queues != 1)
> -		return 0;
> +		return;
>  
>  	WARN_ON_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags));
>  
>  	if (unlikely(q->elevator))
> -		goto out;
> +		return;
>  
>  	e = elevator_get(q, "mq-deadline", false);
>  	if (!e)
> -		goto out;
> +		return;
>  
>  	err = blk_mq_init_sched(q, e);
> -	if (err)
> +	if (err) {
> +		pr_warn("\"%s\" elevator initialization failed, "
> +			"falling back to \"none\"\n", e->elevator_name);
>  		elevator_put(e);
> -out:
> -	return err;
> +	}
>  }

Looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

BTW, blk_mq_init_sched()'s failure patch should have restored
q->nr_request. And that could be done in another standalone patch.

-- 
Ming
